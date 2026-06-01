const express = require('express');
const TokenDecoder = require('../middleware/tokenDecoder');
const NotificationController = require('../controller/NotificationController');



const notificationRouter = express.Router();
const notificationController = new NotificationController();


notificationRouter.get('/' , TokenDecoder.accessDecode , notificationController.getNotifications); // -- worked


module.exports = notificationRouter;


