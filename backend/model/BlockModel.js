const UserModel = require('./schemas/UserModel');


class BlockModel {
    async checkUserNotBlocked({ recipientId, senderId }) {
        try {
            const recipient = await UserModel.findOne({
                id: recipientId
            });

            if (!recipient) {
                throw new Error("Message recipient not found");
            }

            // Call the method to check if message can be sent by u
            const canMessage = recipient.canReceiveMessageFrom(senderId);

            // //console.log(canMessage); // Returns true or false
            return canMessage;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockModel.checkUserNotBlocked'
            }

            throw err;

        }
    }

    async getAllBlocked(id) {
        try {
            let blockedUsers = await UserModel.findOne({ id: id })
                .select('blocked_users')
                .lean();
            // Only pull the blocked_users field from the DB

            if (!blockedUsers) return { success: false, reason: "User doesn't even exist" }

            const blockedUsersStrings = blockedUsers.blocked_users.map(id => id.toString());

            return { success: true, data: blockedUsersStrings }

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockModel.getAllBlocked'
            }

            throw err;
        }
    }

    async blockUser({ id, blockedUser }) {
        try {
            let result = await UserModel.findOneAndUpdate(
                { id: id },
                {
                    // $addToSet ensures the ID is only added ONCE
                    $addToSet: { blocked_users: blockedUser }
                },
                {
                    new: true,      // Returns the updated document instead of the old one
                    runValidators: true
                }
            ).lean();

            // 2. If currentUserId doesn't exist, return an error
            if (!result) {
                return { success: false, reason: "Current user profile not found" };
            }

            return {
                success: true
            };

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockModel.blockUser'
            }

            throw err;
        }
    }


    async unblockUser({ id, unblockedUser }) {
        try {
            //console.log("{id, unblockedUser } respectively");
            //console.log({ id, unblockedUser })
            let result = await UserModel.findOneAndUpdate(
                { id: id },
                {
                    // $pull removes the matching ID from the blocked_users array
                    $pull: { blocked_users: unblockedUser }
                },
                {
                    new: true, // Returns the document AFTER the ID has been removed
                    runValidators: true
                }
            ).lean();

            // 2. Check if the current user actually exists
            if (!result) {
                return { success: false, reason: "Current user profile not found" };
            }

            return {
                success: true
            };


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockModel.unblockUser'
            }

            throw err;
        }
    }

}

module.exports = BlockModel;