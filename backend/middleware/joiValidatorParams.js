const Validator = require('../utils/validatorCreator');

const validateCategory = (schema) => {
    return (req, res, next) => {
        try {
            const { categorySelected } = req.params
            const { data } = Validator.validatorCreator(schema, { categorySelected });

            // Override req.body with the sanitized/validated Joi value
            req.category = data;
            next();
        } catch (error) {
            error.from = 'validate middleware'
            next(error);
        }
    };
}


module.exports = validateCategory;