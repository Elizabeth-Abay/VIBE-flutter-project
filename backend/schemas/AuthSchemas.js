const Joi = require('joi');


class AuthSchemas {
    static registrationChecker = Joi.object({
        email: Joi.string().email().required()
    });

    static verifyUserOtp = Joi.object({
        id: Joi.string().uuid().required(),
        OTP: Joi.string().length(6).required()
    });

    static logInValidator = Joi.object({
        email: Joi.string().email().required(),
        password: Joi.string().length(8)
    });


}





module.exports = AuthSchemas;

