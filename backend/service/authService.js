const AuthModelPg = require('../model/AuthModel');
const AuthModelGraph = require('../model/AuthModelG');
const AuthModelMong = require('../model/AuthModelMong');
const generateOTP = require('../utils/otpGenerator');
const shaHasher = require('../utils/shaHasher');
const EmailSendingFunctions = require('./emailSending');
const doesOtpMatch = require('../utils/OtpMatched');
const { RefreshToken, AccessToken } = require('./tokenGeneration');
const BcryptRelated = require('../utils/bcryptRelated');


const authModelPg = new AuthModelPg();
const authModelGraph = new AuthModelGraph();
const authModelMong = new AuthModelMong();
const refreshService = new RefreshToken();
const accessService = new AccessToken();

class AuthService {
    async createUser(email) {
        try {
            // check if user exist send them email 
            let isUniqueResult = await authModelPg.checkUserExist(email);

            if (isUniqueResult.data.length !== 0) {
                // means if there is a user with same email
                return {
                    success: false,
                    reason: "User already exists"
                }
            }

            // else generate and hash otp and email it
            let OTP = generateOTP();
            let otpHashed = shaHasher(OTP);

            // sending email
            let res = await EmailSendingFunctions.sendingOTPEmail({ email, OTP });
            console.log(`OTP is ${OTP} and the user email sent is ${res}`)

            // creating the user node and the user in pg
            let userInPg = await authModelPg.createUser({ email, otpHashed });
            // console.log("userinPg" , userInPg);


            let { id } = userInPg.data;


            return {
                success: true,
                data: id
            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthService.createUser';
            }
            throw err;
        }

    }

    async verifyUser({ id, OTP }) {
        try {
            // get Otp and hash and compare it
            // hash otp
            let OtpHashed = shaHasher(OTP);


            // get the otp from db
            let result = await authModelPg.getOtp(id);

            console.log("Result from verifyUser is " , result);

            if (!result.success) return result;

            let { otp_hashed } = result.data;

            console.log("db ", otp_hashed, "hashed ", OtpHashed);

            let otpMatched = doesOtpMatch(otp_hashed, OtpHashed);

            if (!otpMatched) {
                return {
                    success: false,
                    reason: "Otps dont match"
                }
            }
            // update status of user to verified
            let gotVerified = await authModelPg.setUserAsVerified(id);

            if (!gotVerified.success) {
                return {
                    success: false,
                    reason: "Couldnt update user status"
                }
            }

            // create graph and mongodb instances once verified
            let userInGraph = await authModelGraph.createGraphNode(id);

            if (!userInGraph.success) return userInGraph;


            let userInMong = await authModelMong.createUser(id);

            if (!userInMong) return userInMong;


            // else create tokens

            let accessToken = accessService.generateAccess(id);
            let refreshToken = await refreshService.generateRefresh(id);
            // console.log("ref " , refreshToken);

            if (!accessToken.success || !refreshToken.success) {
                accessToken.success ? refreshToken : accessToken;
                // means return either one to be the cause
            }

            accessToken = accessToken.data;
            refreshToken = refreshToken.dataForUser;

            // console.log("refreshToken from ser" , refreshToken );



            return {
                success: true,
                data: {
                    accessToken,
                    refreshToken
                }

            }


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'AuthService.verifyUser';
            }
            throw err;
        }
    }


    async resendOtp(id) {
        try {

            let userInfo = await authModelPg.getUserEmail(id);

            if (!userInfo.success) return userInfo;

            let { email } = userInfo.data;

            // else generate and hash otp and email it
            let OTP = generateOTP();
            let otpHashed = shaHasher(OTP);

            // updating the OTP in the table
            let updatingOtp = await authModelPg.resendOtp({ email, otpHashed });

            if (!updatingOtp.success) return updatingOtp;

            // sending email
            await EmailSendingFunctions.sendingOTPEmail({ email, OTP });

            console.log(`OTP generated is ${OTP}`)

            return { success: true }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'AuthService.resendOtp';
            }
            throw err;
        }


    }

    async logIn({ email, password }) {
        try {
            let result = await authModelPg.logIn(email);

            if (!result.success) return result;

            // then cr8 access and ref tokens
            // fetch some posts and some new connections

            let { id, password_hashed } = result.data;

            let passwordsMatched = await BcryptRelated.bcryptCompare(password, password_hashed);

            if (!passwordsMatched) return {
                success: false,
                reason: "Password mismatch"
            }


            let accessToken = accessService.generateAccess(id);
            let refreshToken = await refreshService.generateRefresh(id);
            // console.log("ref " , refreshToken);

            if (!accessToken.success || !refreshToken.success) {
                accessToken.success ? refreshToken : accessToken;
                // means return either one to be the cause
            }

            accessToken = accessToken.data;
            refreshToken = refreshToken.dataForUser;

            // console.log("refreshToken from ser" , refreshToken );



            return {
                success: true,
                data: {
                    accessToken,
                    refreshToken
                }

            }



        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'AuthService.logIn';
            }
            throw err;
        }
    }

    async logOut(randomString) {
        try {
            // log-out means to invalidate all refresh tokens
            let hashedRandomString = shaHasher(randomString);

            let invalidateRefreshToken = await refreshService.invalidateForLogOut(hashedRandomString);

            return invalidateRefreshToken;


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'AuthService.logOut';
            }
            throw err;
        }

    }
}


module.exports = AuthService;
