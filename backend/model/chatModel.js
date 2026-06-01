const Chat = require('./schemas/ChatModel');


class ChatModel {
    async getAllChats(id) {
        try {
            let result = await Chat.find(
                // 1. Filter: Find all chats where id is in the participants array
                { participants: id, type: 'chat' },

                // 2. Projection: Shape the output data
                {
                    _id: 1, // Explicitly keep the chat _id

                    // Dynamically filter the array to return only the OTHER user's ID
                    otherParticipant: {
                        $arrayElemAt: [
                            {
                                $filter: {
                                    input: "$participants",
                                    as: "participant",
                                    cond: { $ne: ["$$participant", id] } // "Not Equal to 123"
                                }
                            },
                            0 // Grab the first (and only) item left in the filtered array
                        ]
                    }
                }
            ).lean(); // will be clean js object

            // and find method will return [] if nothing is found


            if (result.length === 0) return { success: false, reason: "Problem with Mongoose" }

            return {
                success: true,
                data: result
            }


        } catch (err) {
            err.from = 'ChatModel.getAllChats'
            throw err;
        }
    }


    async getParticipantsId(chatId) {
        try {
            const result = await Chat.findById(chatId)
                .select('participants')
                .lean();


            if (!result) return { success: false, reason: "Chat problem" }

            return { success: true, data: result.participants }

        } catch (err) {
            err.from = 'ChatModel.getParticipantsId'
            throw err;
        }
    }


    async checkUserAuthorized({ id, chatId }) {
        try {
            // check if the id is part of 
            const result = await Chat.exists({
                _id: chatId,
                participants: id
            });

            return (!result) ?
                {
                    success: false, reason: "User not authorized or chat don't exist"
                }
                :
                {
                    success: true
                }

        } catch (err) {
            err.from = 'ChatModel.checkUserAuthorized'
            throw err;
        }
    }

    async findOne({ id, chatWith, type }) {
        try {
            let existingChat;

            if (type === 'chat') {
                existingChat = await Chat.findOne({
                    participants: {
                        $all: [id, chatWith],               // Must contain all given IDs
                        $size: 2        // Must NOT contain any extra IDs
                    },
                    type: 'chat'
                });
            } else {
                // means we are tryig to find self messaging
                existingChat = await Chat.findOne({
                    participants: {
                        $all: [id],               // Must contain all given IDs
                        $size: 1      // Must NOT contain any extra IDs
                    },
                    type: 'self'
                });
            }

            if (!existingChat) return {
                success: false,
                reason: "couldn't find chat"

            }


            // 2. If found, just return the existing chat's ID
            return (existingChat.length !== 0)
                ?
                {
                    success: true,
                    isNew: false,
                    data: existingChat
                }
                :
                {
                    success: false,
                    reason: "couldn't find chat"

                }



        } catch (err) {
            err.from = 'ChatModel.findOne'
            throw err;
        }

    }

    async createOne({ id, chatWith, type }) {
        try {
            let newChat;

            if (type === 'chat') {
                newChat = await Chat.create({
                    participants: [id, chatWith],
                    type: 'chat'
                });
            } else {
                // means u are trying to create a chat with urself
                newChat = await Chat.create({
                    participants: [id],
                    type: 'self'
                });
            }

            if (!newChat) return {
                success: false,
                reason: "couldn't find chat"

            }


            return (newChat.length !== 0) ?
                {
                    success: true,
                    isNew: true,
                    data: newChat
                }
                :
                {
                    success: false,
                    reason: "couldn't create chat"
                }


        } catch (err) {
            err.from = 'ChatModel.createOne'
            throw err;
        }
    }

    async findOrCreateChat({ id, chatWith }) {
        try {
            // if there is one find it else create new
            let existingChat = await this.findOne({ id, chatWith, type: 'chat' });

            if (existingChat.success) return existingChat;

            let newChat = await this.createOne({ id, chatWith, type: 'chat' });

            return newChat;


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'ChatModel.findOrCreateChat'
            }
            throw err;
        }
    }


    async getOrCreateMyChat(id) {
        try {
            // the id is the participant id so filter using that only and return the id
            // if there is one find it else create new
            let existingChat = await this.findOne({ id, type: 'self' });

            if (existingChat.success) return existingChat;

            let newChat = await this.createOne({ id, type: 'self' });

            return newChat;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'ChatModel.getMyChat'
            }
            throw err;
        }
    }

}


module.exports = ChatModel;