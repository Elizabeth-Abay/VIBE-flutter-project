const Validator = require('../utils/validatorCreator');

const validate = (schema) => {
    return (req, res, next) => {
        try {
            const { data } = Validator.validatorCreator(schema, req.body);
            
            // Override req.body with the sanitized/validated Joi value
            req.body = data; 
            next();
        } catch (error) {
            error.from = 'validate middleware from connection'
            next(error);
        }
    };
}


module.exports = validate;