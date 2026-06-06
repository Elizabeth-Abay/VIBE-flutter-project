const AuthModelPg = require('../model/AuthModel');
const ProfileModel = require('../model/profileModel');
const UserProfileGetter = require('../model/UserProfileGetHelper');
const { getProfileInfo } = require('../model/UserProfileGetHelper');
const BcryptRelated = require('../utils/bcryptRelated');



const authModelPg = new AuthModelPg();
const profileModel = new ProfileModel();

class ProfileService {
    async checkUniqueUserName(userName) {
        try {
            let result = await profileModel.checkUniqueUserName(userName);

            return result;

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'ProfileService.checkUniqueUserName';
            }
            throw err;
        }
    }

    async enterUserInfo({ id, name, userName, password }) {
        try {
            let hashedPassword = await BcryptRelated.bcryptHasher(password);
            let passwordPutIn = await authModelPg.putInPassword({ id, passwordHashed: hashedPassword });

            if (!passwordPutIn.success) return passwordPutIn;

            let result = await profileModel.settingProfileFirstTime({ id, name, userName });

            return result;

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'ProfileService.enterUserInfo';
            }
            throw err;
        }
    }


    async updateUserName({ id, userName }) {
        try {
            // while the users are typing check if it is unique
            let result = await profileModel.settingUserName({ id, userName });

            return result;
        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'ProfileService.updateUserName';
            }
            throw err;
        }

    }

    async updateNameAndBio({ id, name, bio }) {
        try {
            // first check which one is to be
            let whichUpdated;

            if (name && !bio) whichUpdated = 'name';

            else if (!name && bio) whichUpdated = 'bio';

            else whichUpdated = 'both';


            let result = await profileModel.settingNameAndBio({ id, name, bio, whichUpdated });

            return result;

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'ProfileService.updateNameAndBio';
            }
            throw err;
        }

    }


    async updateProfilePic({ id, profilePicUrl }) {
        try {
            if (!id || !profilePicUrl) return { success: false, reason: "Insufficient data provided" };

            let result = await profileModel.settingProfilePic({ id, profilePicUrl });

            return result;

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'ProfileService.updateProfilePic';
            }
            throw err;
        }

    }


    async getProfileInfo(id) {
        try {
            let result = await UserProfileGetter.getProfileInfo([id]);

            console.log("Result of getProfileInfo");
            console.log(result);

            if (!result.success) return result;

            return result;

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'ProfileService.getProfileInfo';
            }
            throw err;
        }
    }

}

module.exports = ProfileService;