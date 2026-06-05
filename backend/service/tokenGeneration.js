const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const path = require('path');



const stringGenerator = require('../utils/stringGenerator')
const refreshTokenModel = require('../model/refreshToken.js');
const shaHasher = require('../utils/shaHasher');


let { ACCESS_TOKEN_SECRET, REFRESH_TOKEN_SECRET } = process.env;

dotenv.config({
    path: path.resolve(__dirname, '../../.env')
});


const refreshModel = new refreshTokenModel();

class AccessToken {
    generateAccess(id) {

        let expirationTime = 3600; // 1hr in seconds

        let currently = Math.floor(Date.now() / 1000); // Convert to seconds
        // expire after 1 hr 


        let accessToken = jwt.sign(
            {
                exp: currently + expirationTime,
                id
            },
            ACCESS_TOKEN_SECRET);

        return {
            success: true,
            data: accessToken
        }

    }


}


class RefreshToken {
    async generateRefresh(userId) {
        try {
            // sent to db and sent to user

            // sentInfo = { randomString , userId}

            let randomString = stringGenerator();

            let twenty_days_from_now = 20 * 24 * 60 * 60;
            let exp = Date.now() / 1000 + twenty_days_from_now;


            let hashedRandomString = shaHasher(randomString);

            // sent to the database
            let refToken = await refreshModel.createRef({ userId, hashedRandomString });

            if (!refToken.success) return refToken


            // contents of the refresh token
            let refreshToken = jwt.sign({ exp, randomString }, REFRESH_TOKEN_SECRET)
            // //console.log("refreshToken" , refreshToken);

            // then return this as a data
            return {
                success: true,
                dataForUser: refreshToken,
                dataFromDb: refToken.data
            }

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'RefreshToken.generateRefresh';
            }
            throw err;
        }
    }

    async getTokenInfo(hashedTokenString) {
        try {

            let result = await refreshModel.getRefTokenInfo(hashedTokenString);

            return result;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'RefreshToken.getTokenInfo';
            }
            throw err;
        }
    }


    async invalidateRefresh({ oldTokenId, newTokenId }) {
        try {
            // do an update to set isvalid = false

            let res = await refreshModel.invalidateRefresh({ oldTokenId, newTokenId });

            return res;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'RefreshToken.invalidateRefresh';
            }
            throw err;
        }
    }

    async invalidateAllRefresh(userId) {
        try {
            // revoke all tokens if expired token used
            let res = await refreshModel.invalidateAll(userId);

            return res;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'RefreshToken.invalidateAllRefresh';
            }
            throw err;
        }
    }

    async invalidateForLogOut(randomString) {
        try {
            let hashedRandom = shaHasher(randomString);

            let result = await  refreshTokenModel.invalidateForLogOut(hashedRandom)
        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'RefreshToken.revokeToken';
            }
            throw err;
        }
    }
}



module.exports = {
    RefreshToken,
    AccessToken
}