const Joi = require('joi');

class ConnectionSchemas {
    static requestConnection = Joi.object({
        // The ID being passed in the body that shouldn't match the logged-in user
        connectToId: Joi.string()
            .uuid()
            .invalid(Joi.ref('$clientUserId')) // Asserts: targetUserId !== clientUserId
            .required()
            .messages({
                'any.invalid': 'Action denied: You cannot target your own user ID.'
            })
    }
    )


    static acceptConnection = Joi.object({
        // The ID being passed in the body that shouldn't match the logged-in user
        acceptedId: Joi.string()
            .uuid()
            .invalid(Joi.ref('$clientUserId')) // Asserts: targetUserId !== clientUserId
            .required()
            .messages({
                'any.invalid': 'Action denied: You cannot target your own user ID.'
            })
    }
    )


    static disConnectUser = Joi.object({
        // The ID being passed in the body that shouldn't match the logged-in user
        disconnectedId: Joi.string()
            .uuid()
            .invalid(Joi.ref('$clientUserId')) // Asserts: targetUserId !== clientUserId
            .required()
            .messages({
                'any.invalid': 'Action denied: You cannot target your own user ID.'
            })
    })


    static rejectConnection = Joi.object({
        // The ID being passed in the body that shouldn't match the logged-in user
        rejectedId: Joi.string()
            .uuid()
            .invalid(Joi.ref('$clientUserId')) // Asserts: targetUserId !== clientUserId
            .required()
            .messages({
                'any.invalid': 'Action denied: You cannot target your own user ID.'
            })
    }
    )

    static cancelRequest = Joi.object({
        // The ID being passed in the body that shouldn't match the logged-in user
        canceled: Joi.string()
            .uuid()
            .invalid(Joi.ref('$clientUserId')) // Asserts: targetUserId !== clientUserId
            .required()
            .messages({
                'any.invalid': 'Action denied: You cannot target your own user ID.'
            })
    }
    );


}


module.exports = ConnectionSchemas;