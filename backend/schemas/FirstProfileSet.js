const Joi = require('joi');

class UserInfoSchema {
    static userInformationFirstTime = Joi.object({
        userName: Joi.string()
            .trim()
            .lowercase() // Keeps usernames standardized in your DB
            .min(3)      // Prevents single-character usernames
            .max(30)     // Keeps them readable
            // Allows: letters, numbers, underscores, and periods. Cannot start with a symbol.
            .pattern(/^[a-zA-Z0-9][a-zA-Z0-9._]*$/)
            .required()
            .messages({
                'string.pattern.base': 'Username can only contain letters, numbers, underscores, and periods, and must start with a letter or number.'
            }),
        password: Joi.string().length(8),
        name: Joi.string().required()
    });

    static userNameTakenChecker = Joi.object({
        userName: Joi.string()
            .trim()
            .lowercase() // Keeps usernames standardized in your DB
            .min(3)      // Prevents single-character usernames
            .max(30)     // Keeps them readable
            // Allows: letters, numbers, underscores, and periods. Cannot start with a symbol.
            .pattern(/^[a-zA-Z0-9][a-zA-Z0-9._]*$/)
            .required()
            .messages({
                'string.pattern.base': 'Username can only contain letters, numbers, underscores, and periods, and must start with a letter or number.'
            })
    });
}


module.exports = UserInfoSchema;

