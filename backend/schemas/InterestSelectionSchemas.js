const Joi = require('joi');

class InterestSchema {
    static interestSchema = Joi.object({
        interestedIn: Joi.array()
            .items(
                Joi.object().pattern(
                    // The Key: Must be a lowercase slug string (e.g., "football")
                    Joi.string().lowercase().trim().min(2).max(50).required(),

                    // The Value: Must be an integer score (e.g., 10)
                    Joi.number().integer().min(0).max(10).required()
                )
                    .length(1) // Ensures each object inside the array contains exactly one key-value pair
            )
            .min(1) // Requires the user to pick at least one interest block
            .required()
    });

}


module.exports = InterestSchema;