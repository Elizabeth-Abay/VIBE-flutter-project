const ConnectionModel = require('../model/connectionModel.js');
const NotificationModel = require('../model/notificationModel.js');
const UserProfileGetter = require('../model/UserProfileGetHelper.js');


const connectionModel = new ConnectionModel();
const notificationModel = new NotificationModel();



class ConnectionService {
    async requestingConnection({ id, connectToId }) {
        try {
            // sentInfo = { id , connectToId}
            let res = await connectionModel.connectReq({ id, connectToId });

            return (res.success) ? { success: true } : { success: false, reason: "data base problem from requestingConnection" }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionService.requestingConnection';
            }
            throw err;
        }

    }


    async acceptingConnection({ acceptorId, acceptedId }) {
        try {
            // when u accept create a row in notification table
            let result = await connectionModel.acceptingRequest({ acceptorId, acceptedId });

            // then create a row in the notifications table for the user to see
            if (!result.success) return result;

            let notifying = await notificationModel.createNotifications({ notifierId: acceptorId, notifyToId: acceptedId, type: 'Connection Request Accepted' });

            //console.log("Going into the notifications , " , notifying);

            return notifying;


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionService.acceptingConnection';
            }
            throw err;
        }

    }


    async rejectingConnection({ id, rejectedId }) {
        try {
            // { userId , rejectedId }
            let res = await connectionModel.rejectAReq({ id, rejectedId });

            return (res.success) ? { success: true } : { success: false, reason: "data base problem from rejectingConnection" }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionService.rejectingConnection';
            }
            throw err;
        }
    }



    async disConnection({ id, disconnectedId }) {
        try {
            let res = await connectionModel.disConnecting({ id, disconnectedId });

            return (res.success) ? { success: true } : { success: false, reason: "data base problem from disConnection" }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionService.disConnection';
            }
            throw err;
        }

    }


    async getMatchedConnections(id) {
        try {

            let res = await connectionModel.matchedUsers(id);
            // //console.log("result from connectionModel.matchedUsers ", res)


            if (!res.success || (res.data.length === 0)) return res;


            let resultArr = res.data;

            let profiles = await UserProfileGetter.getProfileInfo(resultArr);

            if (!profiles.success) return profiles;

            return profiles;

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionService.getMatchedConnections';
            }
            throw err;
        }
    }


    async getAllConnections(id) {
        try {
            let res = await connectionModel.allConnected(id);

            if (!res.success) return {
                success: false,
                reason: "data base problem from getAllConnections"
            }


            let profiles = await UserProfileGetter.getProfileInfo(res.data);

            if (!profiles.success) return profiles;

            return profiles;

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionService.getAllConnections';
            }
            throw err;
        }
    }
}



module.exports = ConnectionService;


