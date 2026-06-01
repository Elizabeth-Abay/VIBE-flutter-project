const BlockModel = require('../model/BlockModel');
const UserProfileGetter = require('../model/UserProfileGetHelper');


const blockModel = new BlockModel();

class BlockService {
    async checkUserNotBlocked({ recipientId, senderId }) {
        try {
            // we get to the userid and then check if the senderId is part 
            // of the blocked list of the user's list 

            let result = await blockModel.checkUserNotBlocked({ recipientId, senderId });

            return result;

            //  if success = true  -- u can message 
            // if success = false -- u can't message

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockService.checkUserNotBlocked'
            }

            throw err;
        }
    }
    async getAllBlocked(id) {
        try {
            let result = await blockModel.getAllBlocked(id);

            if (!result.success || (result.data.length === 0)) return result;

            let { data } = result; // this is the array of ids

            let profiles = await UserProfileGetter.getProfileInfo(data);

            if (!profiles.success) return profiles;

            return {
                success: true,
                data: profiles.data
            }


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockService.getAllBlocked'
            }

            throw err;
        }
    }

    async blockUser({ id, blockedUser }) {
        try {
            let result = await blockModel.blockUser({ id, blockedUser });

            return result;


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockService.blockUser'
            }

            throw err;
        }
    }

    async unblockUser({ id, unblockedUser }) {
        try {
            let result = await blockModel.unblockUser({ id, unblockedUser });

            return result;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockService.unblockUser'
            }

            throw err;
        }
    }
}


module.exports = BlockService;