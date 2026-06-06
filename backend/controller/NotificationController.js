const NotificationService = require('../service/notificationService');


const notificationService = new NotificationService();

class NotificationController {
    async getNotifications(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let result = await notificationService.getNotifications(id);


            return (result.success) ? res.status(200).json(result) : res.status(400).json(result);

        } catch (err) {
            if (!err.from) {
                err.from = 'NotificationController.getNotifications';
            }

            next(err);
        }

    }
}



module.exports = NotificationController;