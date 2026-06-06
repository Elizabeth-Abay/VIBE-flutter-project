const mongoose = require('mongoose');


const MessageSchema = new mongoose.Schema({
    chat_id : {
        type : mongoose.Schema.Types.ObjectId,
        ref : 'Chat',
        required : [true , 'A message must belong to a chat']
    },
    sender_id : {
        type : String,
        ref : 'User',
        required : [true , 'A sender needs to be there on the message']
    },
    text : {
        type : String,
        required : [ true , 'A message cant be an empty string']
    },
    created_at: {
        type: Date,
        default: Date.now
    }
});


const Message = mongoose.model('Message' , MessageSchema);

module.exports = Message;

