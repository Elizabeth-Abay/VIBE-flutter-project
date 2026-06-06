const driver = require('../config/neo4jConfig');


class RequestHandler {
    async cancelConnectionRequest(sentInfo) {

        const session = driver.session();

        const sessionToWrite = driver.session({
            defaultAccessMode: session.WRITE
        })

        try {
            // sentInfo = { id , canceled }
            let query = `
                MATCH (requestor:Person)  WHERE requestor.id = $id
                MATCH (requested:Person)  WHERE requested.id = $canceled
                MATCH (requestor)-[r:request_Connect]->(requested)
                DETACH DELETE r
                RETURN requestor
            `

            let result = await sessionToWrite.executeWrite(
                tx => {
                    return tx.run(
                        query, sentInfo
                    )
                }
            )

            let res = result.records[0]?.length;

            return (res === 0) ?
                {
                    success: false, reason: "Error in the database"
                }
                :
                { success: true }

        } catch (err) {
            err.from = 'RequestHandler.cancelConnectionRequest';
            next(err);
        }

    }


    async pendingRequests(id) {
        const session = driver.session();


        const sessionToRead = driver.session({
            defaultAccessMode: session.READ
        })

        //console.log("id is " , id);
        try {
            // requests sent to the user

            let query = `
                MATCH (n:Person) WHERE n.id = $id 
                MATCH (n)<-[r:request_Connect]-(x:Person)
                RETURN x.id
                `;

            let res = await sessionToRead.executeRead(
                tx => {
                    return tx.run(
                        query, { id }
                    )
                }
            )

            if (res.records.length === 0) return {
                success: true,
                reason: "Data base search is empty",
                data: []
            }


            // convert the value to an array
            let ids = res.records.map(
                r => r.get('x.id')
            );

            return {
                success: true,
                data: ids
            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            err.from = 'RequestHandler.pendingRequests';
            throw err;
        }
    }

    async sentOutRequests(id) {

        const session = driver.session();

        const sessionToRead = driver.session({
            defaultAccessMode: session.READ
        })

        try {
            // then seek out ppl the user requested to connect to

            let query = `
                MATCH (n:Person) WHERE n.id = $id 
                MATCH (n)-[r:request_Connect]->(x:Person)
                RETURN x.id
                `;

            let res = await sessionToRead.executeRead(
                tx => {
                    return tx.run(
                        query , { id }
                    )
                }
            )

            if (res.records.length === 0) return {
                success: true,
                reason: "Data base search is empty",
                data: []
            }

            let sentOutReq = res.records.map(
                rec => {
                    return rec.get('x.id')
                }
            )

            // sentOutReq - will be an array of userIds

            return {
                success: true,
                data: sentOutReq
            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            err.from = 'RequestHandler.sentOutRequests';
            throw err;
        }
    }

}



module.exports = RequestHandler