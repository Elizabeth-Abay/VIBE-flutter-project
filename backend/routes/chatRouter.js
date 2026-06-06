const express = require('express');
const TokenDecoder = require('../middleware/tokenDecoder');
const ChatController = require('../controller/ChatController');



const chatRouter = express.Router();
const chatController = new ChatController();


chatRouter.get('/get-all', TokenDecoder.accessDecode, chatController.getAllChats); // -- worked
chatRouter.get('/get-single-chat/:chatWith', TokenDecoder.accessDecode, chatController.createOrFindChat); // -- worked

chatRouter.get('/self-chat', TokenDecoder.accessDecode, chatController.getOrCreateMyChat);

module.exports = chatRouter;