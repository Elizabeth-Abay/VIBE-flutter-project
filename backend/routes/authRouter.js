const express = require('express');
const AuthSchemas = require('../schemas/AuthSchemas');
const validate = require('../middleware/joiValidator');
const AuthController = require('../controller/AuthController');
const TokenDecoder = require('../middleware/tokenDecoder');


const authRouter = express.Router();
const authController = new AuthController();


// to create a user - by receiving the email only -- works
authRouter.post('/create-a-user' , validate(AuthSchemas.registrationChecker) , authController.createUser);

// to verify the user -- works
authRouter.post('/verify-user-otp' , validate(AuthSchemas.verifyUserOtp) , authController.verifyUserOtp);


authRouter.post('/resend-user-otp' , authController.resendOtp)


// sign in -- works
authRouter.post('/log-in' , validate(AuthSchemas.logInValidator) , authController.logIn);


// sign out 
authRouter.post('/log-out' , TokenDecoder.refreshDecoder , authController.logOut );

module.exports = authRouter;