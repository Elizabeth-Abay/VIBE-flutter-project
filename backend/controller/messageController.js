const MessageService = require('../service/messageService');
const { deleteAcc } = require('./DeleteController');

const messageService = new MessageService();


class MessageController {
    async getMessagesInChat(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let { chatId } = req.params;

            let result = await messageService.getMessagesInAChat({ id, chatId });

            // //console.log("result of getMessagesInChat");
            // //console.log(result);


            return (result.success)
                ?
                res.status(200).json(result)
                :
                res.status(400).json(result)

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'MessageController.getMessagesInChat';
            }
            next(err)
        }

    }

    async createMessage(req, res, next) {
        try {
            let { id } = req.decodedAccess;
            console.log("Message creation");

            let { chatId, message, type } = req.body;

            let result = await messageService.createMessage({ id, chatId, message, type });
            console.log("Result");
            console.log(result);

            return (result.success)
                ?
                res.status(201).json(result)
                :
                res.status(400).json(result)

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'MessageController.createMessage';
            }
            next(err)
        }

    }

    async updateMessage(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let { chatId, msgId, newMessage } = req.body;

            let result = await messageService.updateMessage({ id, chatId, msgId, newMessage });

            return (result.success)
                ?
                res.status(201).json(result)
                :
                res.status(400).json(result)

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'MessageController.updateMessage';
            }
            next(err)
        }

    }

    async deleteMessage(req, res, next) {
        try {
            let { id } = req.decodedAccess;
            //console.log("delete Messgae");

            let { msgId } = req.params;

            let result = await messageService.deleteMessage({ id, msgId });

            //console.log("delete Messgae");
            //console.log(result);

            return (result.success)
                ?
                res.status(200).json({ success: true })
                :
                res.status(400).json(result)


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'MessageController.deleteMessage';
            }
            next(err)
        }

    }

}


module.exports = MessageController;