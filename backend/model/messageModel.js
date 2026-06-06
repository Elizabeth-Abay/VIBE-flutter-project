const Message = require('./schemas/MessageModel');

class MessageModel {
    async getMessagesInAChat({ id, chatId }) {
        try {
    
            const messages = await Message.find({ chat_id: chatId })
                .sort({ timestamp: -1 })
                .limit(30)
                .lean();


            if (!messages) return { success: false, reason: 'Couldnt fetch messages | u r unauthorized' };
            // 3. Reverse the array before returning so the user reads them top-to-bottom


            return {
                success: true,
                data: messages.reverse()
            };

        } catch (err) {
            err.from = 'MessageModel.getMessagesInAChat';
            throw err;
        }
    };


    async updateMessage({ id, msgId, newMessage }) {
        try {
            const updatedMessage = await Message.findOneAndUpdate(
                {
                    _id: msgId,
                    sender_id: id
                }
                ,
                { text: newMessage },
                {
                    new: true,
                    runValidators: true
                }
            );


            if (!updatedMessage) return { success: false, reason: "Couldnt update the message" };

            return {
                success: true,
                data: {
                    msgId: updatedMessage._id,
                    newMessage: updatedMessage.text
                }
            }


        } catch (err) {
            err.from = 'MessageModel.updateMessage';
            throw err;
        }
    }

    async deleteMessage({ id, msgId }) {
        try {
            const deletedMessage = await Message.findOneAndDelete(
                {
                    _id: msgId,
                    sender_id: id
                }

            );

            if (!deletedMessage) return { success: false, reason: "Couldnt delete the message , not found" }

            return {
                success: true,
                data: deletedMessage._id
            }

        } catch (err) {
            err.from = 'MessageModel.deleteMessage';
            throw err;
        }
    }

    async createMessage({ id, message, chatId }) {
        try {
            // 2. Action: Create and save the new message
            console.log("Creating message");

            const newMessageDoc = await Message.create({
                chat_id: chatId,
                sender_id: id,
                text: message
            });

            const newMessage = newMessageDoc.toObject();
            console.log(newMessage);

            return (!newMessage)
                ?
                {
                    success: false,
                    reason: "Couldnt create new message"
                }
                :
                {
                    success: true,
                    data: newMessage
                };

        } catch (err) {
            console.log("Error happened ");
            console.log(err.message);
            err.from = 'MessageModel.createMessage';
            throw err;
        }
    }

}


module.exports = MessageModel;