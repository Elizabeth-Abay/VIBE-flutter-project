const express = require('express');
const TokenDecoder = require('../middleware/tokenDecoder');
const DeleteAccController = require('../controller/DeleteController');

const deleteRouter = express.Router();

deleteRouter.post('/delete-acc',TokenDecoder.accessDecode , TokenDecoder.refreshDecoder, DeleteAccController.deleteAcc);

module.exports = deleteRouter;