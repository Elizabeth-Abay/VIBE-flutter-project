const Joi = require('joi');

const allowedCategories = ['tech', 'gaming', 'lifestyle', 'cooking' , 'books']

class PostSchemas {
    static getPostCategory = Joi.object({
        categorySelected: Joi.string()
            .valid(...allowedCategories)
            .trim()
            .lowercase()
            .required()
    });


    static makePost = Joi.object({

        categorySelected: Joi.string()
            .valid(...allowedCategories)
            .trim()
            .lowercase()
            .required(),

        postTitle: Joi.string(),

        postContent: Joi.string(),

        // image fields
        postImage: Joi.object({
            fieldname: Joi.string().required(),
            originalname: Joi.string().required(),
            encoding: Joi.string().required(),

            // 1. Validate Image Type (Mimetype)
            mimetype: Joi.string()
                .valid('image/jpeg', 'image/png', 'image/webp')
                .required()
                .messages({
                    'any.only': 'Only JPEG, PNG, and WebP images are allowed.'
                }),

            // 2. Validate Image Size (e.g., max 2MB = 2 * 1024 * 1024 bytes)
            size: Joi.number()
                .max(2 * 1024 * 1024)
                .required()
                .messages({
                    'number.max': 'Image size must be less than 2MB.'
                }),

            destination: Joi.string().required(),
            filename: Joi.string().required(),
            path: Joi.string().required()
        }).optional(),


    });
}


module.exports = PostSchemas;