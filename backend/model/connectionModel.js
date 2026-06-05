const driver = require('../config/neo4jConfig');

class ConnectionModel {
    async connectReq(sentInfo) {
        const session = driver.session();

        const sessionToWrite = driver.session({
            defaultAccessMode: session.WRITE
        })

        try {
            // sentInfo = { id , connectToId}
            let query = `
                MATCH (requester:Person {id: $id})
                MATCH (requested:Person {id: $connectToId})
                
                WHERE requester <> requested
                AND NOT EXISTS {
                    (requester)-[:request_Connect|Connected]-(requested)
                }
                AND NOT EXISTS {
                    (requested)-[:request_Connect|Connected]-(requester)
                }
                
                MERGE (requester)-[r:request_Connect]->(requested)
                ON CREATE SET 
                    r.created_At = timestamp(),
                    r.status = 'pending'
                
                RETURN requester, r, requested
            `;



            let res = await sessionToWrite.executeWrite(
                tx => {
                    return tx.run(
                        query, sentInfo
                    )
                }
            )

            let returnedVals = res.records[0]?.length;

            return (returnedVals === 0) ? { success: false, reason: "Database issue" } : { success: true }

        } catch (err) {
            err.from = 'GraphConnection.connectReq';
            throw err;
        }

    }

    async rejectAReq(sentInfo) {
        const session = driver.session();

        const sessionToWrite = driver.session({
            defaultAccessMode: session.WRITE
        })
        try {
            // sentInfo = { id , rejectedId }
            //console.log(sentInfo);
            let query = `
                MATCH (requestor:Person)  WHERE requestor.id = $rejectedId
                MATCH (rejector:Person)  WHERE rejector.id = $id
                MATCH (requestor)-[r:request_Connect]->(rejector)
                DELETE r
                RETURN rejector
            `

            let result = await sessionToWrite.executeWrite(
                tx => {
                    return tx.run(
                        query, sentInfo
                    )
                }
            )


            //console.log("REsutl ", result.records)

            return (!result.records[0] || result.records[0].length === 0) ? {
                success: false,
                reason: "Error in the database"
            }
                :
                {
                    success: true
                }

        } catch (err) {
            err.from = "GraphConnection.rejectAReq";
            throw err;
        }
    }

    async acceptingRequest(sentInfo) {
        const session = driver.session();

        const sessionToWrite = driver.session({
            defaultAccessMode: session.WRITE
        })
        try {
            // sentInfo = {acceptorId , acceptedId }
            let query = `
                MATCH (accpetor:Person) WHERE accpetor.id = $acceptorId
                MATCH (accepted:Person) WHERE accepted.id = $acceptedId
                MATCH (accepted)-[r:request_Connect]->(accpetor)
                MERGE (accepted)-[c:Connected]-(accpetor)
                ON CREATE SET c.since = ${Date.now()}
                DETACH DELETE r
                RETURN accepted , accpetor
            `


            let result = await sessionToWrite.executeWrite(
                tx => {
                    return tx.run(
                        query, sentInfo
                    )
                }


            )

            let res = result.records[0]?.length;



            //console.log("Connecting graph result " , res);

            return (res === 0) ?
                {
                    success: false,
                    reason: "Error in the database"
                }
                :
                {
                    success: true
                }

        } catch (err) {
            err.from = 'GraphConnection.acceptingRequest';
            throw err;
        }

    }

    async disConnecting(sentInfo) {
        try {
            const session = driver.session();

            const sessionToWrite = driver.session({
                defaultAccessMode: session.WRITE
            })
            // sentInfo = {id , disconnectedId}
            let query = `
                MATCH (disconnector:Person) WHERE disconnector.id= $id
                MATCH (disconnected:Person) WHERE disconnected.id= $disconnectedId
                MATCH (disconnector)-[r:Connected]-(disconnected)
                DETACH DELETE r
                RETURN disconnected
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
                    success: false,
                    reason: "Error in the database"
                }
                :
                {
                    success: true
                }

        } catch (err) {
            err.from = 'GraphConnection.disConnecting';
            throw err;
        }

    }

    async allConnected(id) {
        const session = driver.session();

        const sessionToRead = driver.session({
            defaultAccessMode: session.READ
        })

        try {
            // seek out all ppl connected to the user


            let query = `
                MATCH (n:Person) WHERE n.id = $id 
                MATCH (n)-[r:Connected]-(x:Person)
                RETURN x.id
                `;

            let res = await sessionToRead.executeRead(
                tx => {
                    return tx.run(
                        query, { id }
                    )
                }
            );



            if (res.records.length === 0) return {
                // this means u havent connected to a user
                success: true,
                reason: "Data base search is empty",
                data: []
            }



            let connectedUserIds = res.records.map(
                r => r.get('x.id')
            )

            return {
                success: true,
                data: connectedUserIds
            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            err.from = 'RequestHandler.allConnected';
            throw err;
        }
    }


    async matchedUsers(id) {
        const session = driver.session();

        const sessionToRead = driver.session({
            defaultAccessMode: session.READ
        });

        try {
            //console.log("id ", id);

            // to match users we need to do a weighted search
            // first get users interest by number
            // and then half it up and find all users that havev >= 1/2 of that
            // return the users with most shared interests
            let queryToMatch = `
                MATCH (u1:Person { id: $id })-[r1:INTERESTED_IN]->(i:Interest)<-[r2:INTERESTED_IN]-(u2:Person)
                WHERE u1 <> u2
                AND NOT (u1)-[:request_Connect]-(u2)
                WITH u2, 
                    SUM(r1.rated_as * r2.rated_as) AS matchScore,
                    collect(i.name) AS sharedInterests
                ORDER BY matchScore DESC
                LIMIT 50
                RETURN u2.id AS matchedUserId, 
                    sharedInterests, 
                    matchScore
            `



            // the first line will get all share interest bn users
            // SUM (r1.rated_as * r2.rated_as) - will be the total score
            // we use with to return many things at once 

            let res = await sessionToRead.executeRead(
                tx => {
                    return tx.run(
                        queryToMatch, { id }
                    )
                }
            )

            if (!res) return {
                success: false,
                reason: "Couldnt find the matched users"
            }

            //console.log("res.records ", res.records);


            if (res.records.length === 0) return {
                success: true,
                data: []
            }


            // res.records is an array
            // so we can use .map method on it
            let matchedUsers = res.records.map(record => record.get('matchedUserId'));
            // sharedInterests: record.get('sharedInterests') - ignored this part



            // matchedUsers = [ { userId , sharedInterests }]
            // matchedUsers = [ userIds ]

            return {
                success: true,
                data: matchedUsers
            }


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            err.from = 'RequestHandler.matchedUsers';
            throw err;
        }
    }

}


module.exports = ConnectionModel;



