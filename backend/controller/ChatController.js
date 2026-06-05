const ChatService = require('../service/chatService');

const chatService = new ChatService();

class ChatController {
    async getAllChats(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let result = await chatService.getAllChats(id);

            return (result.success) ?
                res.status(200).json(result)
                :
                res.status(400).json(result)

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ChatController.getAllChats';
            }
            next(err);
        }
    }

    async createOrFindChat(req, res, next) {
        try {
            let { id } = req.decodedAccess;
            let { chatWith } = req.params;

            console.log("calling the createOrFindChat ");

            let result = await chatService.createOrFindChat({ id, chatWith });

            console.log(result);

            return (result.success)
                ?
                res.status(200).json(result)
                :
                res.status(400).json(result);


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ChatController.getOne';
            }
            next(err);
        }
    }


    async getOrCreateMyChat(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let result = await chatService.getOrCreateMyChat(id);

            return (result.success)
                ?
                res.status(200).json(result)
                :
                res.status(400).json(result)

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ChatController.getMyChat';
            }
            next(err);
        }
    }


}


module.exports = ChatController;