const express = require('express');
const TokenDecoder = require('../middleware/tokenDecoder');
const BlockController = require('../controller/BlockController');

const blockRouter = express.Router();
const blockController = new BlockController();

blockRouter.get('/blocked-users', TokenDecoder.accessDecode , blockController.getAllBlocked );
blockRouter.post('/block-a-user', TokenDecoder.accessDecode , blockController.blockUser);
blockRouter.post('/unblock-a-user', TokenDecoder.accessDecode , blockController.unblockUser);

module.exports = blockRouter;