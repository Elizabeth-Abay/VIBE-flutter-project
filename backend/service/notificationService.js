const NotificationModel = require('../model/notificationModel');

const notificationModel = new NotificationModel();

class NotificationService {
    async getNotifications(id) {
        try {

            let result = await notificationModel.getNotifications(id);

            return result;

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'InterestService.linkingInterest';
            }
            throw err;
        }

    }

}


module.exports = NotificationService;