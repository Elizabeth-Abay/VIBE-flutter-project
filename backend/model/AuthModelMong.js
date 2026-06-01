const User = require('./schemas/UserModel');
const mongoose = require('mongoose');


class AuthModelMong {
    async createUser(id) {
        try {
            let result = await User.create({
                id: id,
                blocked_users: []
            });


            return (result && result.id) ?
                {
                    success: true
                } :
                {
                    success: false,
                    reason : "Couldnt create mongodb instance"
                }



        } catch (err) {
            err.from = 'AuthModelMong.createUser';
            throw err;
        }
    }
}

module.exports = AuthModelMong;