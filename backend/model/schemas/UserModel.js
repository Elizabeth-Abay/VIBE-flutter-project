const mongoose = require('mongoose');


const UserSchema = new mongoose.Schema({
    id: {
        type: String,
        required: [true, 'id is required to create a profile']
    },
    created_at: {
        type: Date,
        default: Date.now
    },
    blocked_users: [
        {
            type: String, // Tells Mongoose this is a database ID
            ref: 'User'
        }
    ]
})


// this is used to check if the sender can send messages
UserSchema.methods.canReceiveMessageFrom = function (senderId) {
    // 1. Check if the senderId is in the blocked_users array
    const isBlocked = this.blocked_users.includes(senderId);
    // bool - if inc - true = cant send the message

    // 2. If blocked, return false. Otherwise, return true.
    return (isBlocked) ? { success: false, reason: "Blocked" } : { success: true };
};

// the model is where u attach the methods
// and the schema is there too
const User = mongoose.model('User', UserSchema);


module.exports = User;