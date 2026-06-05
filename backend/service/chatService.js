const ChatModel = require('../model/chatModel');
const UserProfileGetter = require('../model/UserProfileGetHelper');

const chatModel = new ChatModel();

class ChatService {
    async getAllChats(id) {
        try {
            // then filter out conversations where participants include that and return chat id ,  user profile
            let result = await chatModel.getAllChats(id);

            // if data = [] then it means the user havent started chatting  
            if (!result.success || result.data.length === 0) return result;

            // else get the participants in an array and fetch their profiles

            let ids = [];

            for (let chat of result.data) {
                ids.push(chat.otherParticipant)
            };


            let profiles = await UserProfileGetter.getProfileInfo(ids);

            if (!profiles.success) return profiles;


            const profileMap = new Map();
            for (const profile of profiles.data) {
                profileMap.set(profile.user_id, profile);
            }

            // 2. Combine the MongoDB chat data with the PostgreSQL profile details
            let returnedObj = [];

            for (const chat of result.data) {
                // Look up the corresponding PostgreSQL profile using the otherParticipant ID
                const matchingProfile = profileMap.get(chat.otherParticipant);

                if (matchingProfile) {
                    returnedObj.push({
                        chat_id: chat._id,
                        participant_id: chat.otherParticipant,
                        name: matchingProfile.name,
                        user_name: matchingProfile.user_name,
                        profile_url: matchingProfile.profile_url
                    });
                }
            }

            // 3. Return the fully structured payload to your controller layer
            return {
                success: true,
                data: returnedObj
            };


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ChatService.getAllChats';
            }
            throw err;
        }
    }


    async isUserAuthorized({ id, chatId }) {
        try {
            let result = await chatModel.checkUserAuthorized({ id, chatId });

            return result;


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ChatService.isUserAuthorized';
            }
            throw err;
        }
    }


    async getParticipantsId(chatId) {
        try {
            let result = await chatModel.getParticipantsId(chatId);

            return result;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ChatService.getParticipantsId';
            }
            throw err;
        }

    }

    async createOrFindChat({ id, chatWith }) {
        try {
            let result = await chatModel.findOrCreateChat({ id, chatWith });

            if (!result.success) return result;

            let data = result.data.toObject ? result.data.toObject() : { ...result.data };


            //console.log("Result of createOrFindChat ", data.participants);
            let othersProfile;
            data.otherUserProfile = undefined;

            // else fetch the second users profile
            for (let participantId of data.participants) {
                if (participantId !== id) {
                    othersProfile = await UserProfileGetter.getProfileInfo([participantId]);

                    if (!othersProfile.success) return othersProfile;

                    else {
                        //console.log(othersProfile.data)
                        data.otherUserProfile = Array.isArray(othersProfile.data) ? othersProfile.data[0] : othersProfile.data
                        //console.log("data.otherUserProfile");
                        //console.log(data.otherUserProfile);
                    }
                }
            }


            //console.log("data being sent");
            //console.log(data);

            // this will be used to represent the second user at the top
            return {
                success: true,
                data
            }


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ChatService.createOrFindChat';
            }
            throw err;
        }
    }


    async getOrCreateMyChat(id) {
        try {
            let result = await chatModel.getOrCreateMyChat(id);

            return result;
            // bc when it loads i expect the page to do a request again with the chatId given
        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ChatService.getMyChat';
            }
            throw err;
        }
    }

}

module.exports = ChatService;