const express = require('express');
const TokenDecoder = require('../middleware/tokenDecoder');
const TokenController = require('../controller/TokenController');

const tokenRouter = express.Router();


// here given refresh token check if not expired and then revoke the old and generate the new
tokenRouter.post('/refresh-token', TokenDecoder.refreshDecoder, TokenController.tokenGeneration);



module.exports = tokenRouter;