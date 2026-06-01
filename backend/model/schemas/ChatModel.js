const mongoose = require('mongoose');

const ChatSchema = new mongoose.Schema({
    // id will be assigned automatically
    participants: [
        {
            type: String, // <-- MongoDB ObjectId
            ref: 'User',
            required: true
        }
    ],
    created_at: {
        type: Date,
        default: Date.now
    },
    type: {
        type: String,
        enum: ['chat', 'self'], // Strictly limits the values to these two options
        default: 'chat',        // Falls back to 'chat' if no type is provided
        required: true          // Ensures the type field is always populated
    }
});



const Chat = mongoose.model('Chat', ChatSchema);

module.exports = Chat;