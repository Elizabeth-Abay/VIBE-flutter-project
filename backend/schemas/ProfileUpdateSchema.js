const Joi = require('joi');


class ProfileUpdateSchema {
    static updateBioAndName = Joi.object({
        bio: Joi.string().trim().min(1),
        name: Joi.string().trim().min(1)
    }).or('bio', 'name');
    // since the end point is same for both atleast one is required


    static updateProfilePic = Joi.object({
        // all this properties will be attached once multer accesses the file uploaded
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
    });


    static updateUserName = Joi.object({
        userName: Joi.string().required()
    });
}


module.exports = ProfileUpdateSchema;