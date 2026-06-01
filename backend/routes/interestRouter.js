const express = require('express');
const TokenDecoder = require('../middleware/tokenDecoder');
const InterestController = require('../controller/InterestController');
const validate = require('../middleware/joiValidator');
const InterestSelectionSchema = require('../schemas/InterestSelectionSchemas');

const interestRouter = express.Router();
const interestController = new InterestController();


// -- works
interestRouter.post('/put-in-interests', TokenDecoder.accessDecode, validate(InterestSelectionSchema.interestSchema), interestController.firstTimeLinking);


// -- works
interestRouter.post('/update-interests', TokenDecoder.accessDecode, validate(InterestSelectionSchema.interestSchema), interestController.updatingLinks);


// -- works
interestRouter.get('/get-interests', TokenDecoder.accessDecode, interestController.getUserInterests);


module.exports = interestRouter;