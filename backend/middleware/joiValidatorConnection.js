const Validator = require('../utils/validatorCreator');

const validate = (schema) => {
    return (req, res, next) => {
        try {
            const { id } = req.decodedAccess;
            const { data } = Validator.connectionValidatorCreator(schema, req.body , id);
            
            // Override req.body with the sanitized/validated Joi value
            req.body = data; 
            next();
        } catch (error) {
            error.from = 'validate middleware'
            next(error);
        }
    };
}


module.exports = validate;