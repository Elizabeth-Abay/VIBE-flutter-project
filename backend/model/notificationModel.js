const pool = require('../config/pgConfig');

class NotificationModel {
    async getNotifications(id) {
        try {
            // do  a join to find names of people who accepted
            let query = `
                    SELECT 
                        p.name ,
                        n.type , 
                        n.created_at
                    FROM profile_info p
                    INNER JOIN notifications n
                    ON p.user_id = n.notify_to_id
                    WHERE n.notify_to_id = $1
                    ORDER BY n.created_at DESC;
                `;


            let values = [id];


            let result = await pool.query(query, values);

            // if it is empty then it means no new notification is there
            return {
                success: true,
                data: result.rows[0]

            }

        } catch (err) {
            err.from = 'GraphConnection.disConnecting';
            throw err;
        }
    }


    async createNotifications({ notifierId, notifyToId, type }) {
        try {
            // notifierId - is the person accepting the connection request
            // notifyToId - is the person who made the connection request

            let query = `
                    INSERT INTO notifications( notifier_id , notify_to_id , type  )
                    VALUES ($1 , $2 , $3)
                    RETURNING id
                `;

            let values = [notifierId, notifyToId, type];

            let result = await pool.query(query, values);

            console.log("Result from the notification model ", result);

            return (result.rowCount !== 0) ? { success: true } : { success: false, reason: "Couldnt create a notification instance" }

        } catch (err) {
            err.from = 'GraphConnection.disConnecting';
            throw err;
        }
    }

}


module.exports = NotificationModel;