const express = require('express');
const TokenDecoder = require('../middleware/tokenDecoder');
const MessageController = require('../controller/messageController');

const messageRouter = express.Router();
const messageController = new MessageController();


messageRouter.get('/get-messages/:chatId', TokenDecoder.accessDecode, messageController.getMessagesInChat); // -- worked
messageRouter.post('/send-message', TokenDecoder.accessDecode, messageController.createMessage); // -- worked
messageRouter.post('/update-message', TokenDecoder.accessDecode, messageController.updateMessage); // -- worked
messageRouter.delete('/delete-message/:msgId', TokenDecoder.accessDecode, messageController.deleteMessage); // -- worked

module.exports = messageRouter;