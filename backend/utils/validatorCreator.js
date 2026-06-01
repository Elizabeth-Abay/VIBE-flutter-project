class Validator {
    static validatorCreator(schema, data) {
        const { error, value } = schema.validate(
            data, {
            abortEarly: false
        }
        )

        if (error) {
            // err.details is an array of obj
            let reason = error.details.map(i => i.message).join(', ');
            error.from = `Validating the schema ${schema} `;
            error.message = reason
            throw error
        }


        return {
            data: value
        }

    }


    static connectionValidatorCreator(schema, data, id) {
        const { error, value } = schema.validate(
            data, {
            abortEarly: false,
            context: { clientUserId: id }
        }
        )

        if (error) {
            // err.details is an array of obj
            let reason = error.details.map(i => i.message).join(', ');
            error.from = `Validating the schema ${schema} `;
            error.message = reason
            throw error
        }


        return {
            data: value
        }

    }
}

module.exports = Validator;