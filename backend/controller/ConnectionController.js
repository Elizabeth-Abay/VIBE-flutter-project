// when creating connection two things - userId from decodedAccess and the other user's id from req.body

const ConnectionService = require('../service/connectionService.js');



let connectionService = new ConnectionService();


class ConnectionController {
    async requestConnection(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let { connectToId } = req.body;

            let result = await connectionService.requestingConnection({ id, connectToId });

            return (result.success) ? res.status(200).json({ success: true }) : res.status(400).json(result);

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionController.requestConnectionController';
            }

            next(err);
        }
    }

    async acceptConnection(req, res, next) {
        try {
            // {acceptorId , acceptedId }
            let { id } = req.decodedAccess;
            let { acceptedId } = req.body;

            let result = await connectionService.acceptingConnection({ acceptorId: id, acceptedId });

            return (result.success) ? res.status(200).json({ success: true }) : res.status(400).json(result);

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionController.acceptConnectionController';
            }
            next(err);
        }
    }

    async rejectConnection(req, res, next) {
        try {
            // { userId , rejectedId }
            let { id } = req.decodedAccess;
            let { rejectedId } = req.body;

            let result = await connectionService.rejectingConnection({ id, rejectedId });

            return (result.success) ? res.status(200).json({ success: true }) : res.status(400).json(result);

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionController.rejectConnection';
            }
            next(err);
        }
    }

    async disconnectConnection(req, res, next) {
        try {
            let { id } = req.decodedAccess;
            let { disconnectedId } = req.body;
            let result = await connectionService.disConnection({ id, disconnectedId });

            return (result.success) ? res.status(200).json({ success: true }) : res.status(400).json(result);

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionController.disconnectController';
            }
            next(err);
        }
    }


    async getAllConnections(req, res, next) {
        try {
            let { id } = req.decodedAccess;
            let result = await connectionService.getAllConnections(id);

            return (result.success) ? res.status(200).json(result) : res.status(400).json(result);

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionController.getAllConnections';
            }
            next(err);
        }
    }



    async getMatchedConnections(req, res, next) {
        try {
            // console.log("req.decodedAccess from getMachedCOnn " , req.decodedAccess)
            let { id } = req.decodedAccess;
            let result = await connectionService.getMatchedConnections(id);

            return (result.success) ? res.status(200).json(result.data) : res.status(400).json(result);

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ConnectionController.getMatchedConnections';
            }
            next(err);
        }
    }
}


module.exports = ConnectionController

