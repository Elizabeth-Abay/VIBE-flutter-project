const RequestModel = require('../model/requestModel');
const UserProfileGetter = require('../model/UserProfileGetHelper');


const requestModel = new RequestModel();


class RequestService {
    async cancelConnectionRequest(sentInfo) {
        try {
            // sentInfo = { id , canceled }
            let res = await requestModel.cancelConnectionRequest(sentInfo);

            return (res.success) ? { success: true } : { success: false, reason: "data base problem from cancellingConnection" }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'RequestService.cancelConnectionRequest';
            }
            throw err;
        }

    }

    async getPendingRequests(id) {
        try {
            let res = await requestModel.pendingRequests(id);

            if (!res.success) return { succcess: false, reason: "Pending request fetching problem" }


            if (res.data.length === 0) return {
                success: true, data: []
            }



            // then get their profile information from the array sent
            let profiles = await UserProfileGetter.getProfileInfo(res.data);

            return (profiles.success) ? { success: true, data: profiles.data } : profiles;


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'RequestService.getPendingRequests';
            }
            throw err;
        }
    }

    async getSentRequests(id) {
        try {
            let res = await requestModel.sentOutRequests(id);
            // get their profile from the method
            // this will give us the array of user ids

            if (!res.success) return { success: false, reason: "data base problem from getSentRequests" }

            let profiles = await UserProfileGetter.getProfileInfo(res.data);

            return (profiles.success) ? { success: true, data: profiles.data } : profiles;

        }
        catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'RequestService.getSentRequests';
            }
            throw err;
        }
    }
}


module.exports = RequestService;