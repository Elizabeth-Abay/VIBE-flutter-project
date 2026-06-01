const express = require('express');

const validate = require('../middleware/joiValidator');
const UserInfoSchema = require('../schemas/FirstProfileSet');
const ProfileController = require('../controller/ProfileController');
const TokenDecoder = require('../middleware/tokenDecoder');
const ProfileUpdateSchema = require('../schemas/ProfileUpdateSchema');
const uploads = require('../config/multerConfig');


const profileRouter = express.Router();
const profileController = new ProfileController();


// check if the username is unique
// will be called everytime the user stops typing in username -- works
profileRouter.post('/check-unique-username', validate(UserInfoSchema.userNameTakenChecker), TokenDecoder.accessDecode, profileController.checkUniqueUserName);


// enter password , username for a user -- works
profileRouter.post('/enter-user-info-first-time', validate(UserInfoSchema.userInformationFirstTime), TokenDecoder.accessDecode, profileController.enterUserInfo);


//  validate(ProfileUpdateSchema.updateProfilePic)
// set up profile picture -- works
profileRouter.post('/set-profile-picture', uploads.single('profilePic'), TokenDecoder.accessDecode, profileController.settingProfilePic);


// setting bio and name  -- works
profileRouter.post('/set-bio-and-name', validate(ProfileUpdateSchema.updateBioAndName), TokenDecoder.accessDecode, profileController.updateNameAndBio);


// updating their username -- works
profileRouter.post('/set-user-name', validate(ProfileUpdateSchema.updateUserName) , TokenDecoder.accessDecode, profileController.updateUserName)



module.exports = profileRouter;
