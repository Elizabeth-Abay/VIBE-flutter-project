const express = require('express');
const RequestController = require('../controller/RequestController');
const TokenDecode = require('../middleware/tokenDecoder');
const RequestSchema = require('../schemas/ConnectionSchemas');
const validate = require('../middleware/joiValidatorConnection');

const requestController = new RequestController();


const requestRouter = express.Router();


requestRouter.get('/received-requests', TokenDecode.accessDecode, requestController.getPendingRequests); // -- works

requestRouter.get('/sent-requests', TokenDecode.accessDecode, requestController.getSentRequests); // --works

requestRouter.post('/cancel-request', TokenDecode.accessDecode, validate(RequestSchema.cancelRequest), requestController.cancelRequest); // -- works


module.exports = requestRouter;