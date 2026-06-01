const { RefreshToken, AccessToken } = require('./tokenGeneration');
const shaHasher = require('../utils/shaHasher');

const refreshService = new RefreshToken();
const accessService = new AccessToken();

class RefreshTokenService {
    static async generateNewTokens(randomString) {
        try {
            const hashedOldString = shaHasher(randomString);
            const dbTokenInfo = await refreshService.getTokenInfo(hashedOldString);

            // Check if the token record even exists in our database
            if (!dbTokenInfo || !dbTokenInfo.success || !dbTokenInfo.data) {
                return { success: false, reason: "Refresh token not recognized" };
            }

            const tokenRecord = dbTokenInfo.data; // Expecting fields: id, user_id, is_revoked

            // 3. REUSE DETECTION (CRITICAL SECURITY CHECK)
            // If the token is found but marked invalid/used, it means someone is attempting a replay attack
            if (tokenRecord.is_revoked) {
                // means user trying to get in with revoked refresh token
                // Breach detected! Invalidate all sessions for this user for safety
                await refreshService.invalidateAllRefresh(tokenRecord.userId);
                return {
                    success: false,
                    reason: "Security Alert: Refresh token reuse detected. All sessions revoked."
                };
            }



            // generate new token info
            const newAccess = accessService.generateAccess(tokenRecord.user_id);
            const newRefresh = await refreshService.generateRefresh(tokenRecord.user_id);

            if (!newRefresh.success) return newRefresh;

            // invalidate the old refresh
            let { dataFromDb } = newRefresh;

            // invalidate old refresh
            let invalidateRefresh = await refreshService.invalidateRefresh({ oldTokenId: tokenRecord.id, newTokenId: dataFromDb.id });


            if (!invalidateRefresh.success) return invalidateRefresh;


            return {
                success: true,
                data: {
                    accessToken: newAccess.data,
                    refreshToken: newRefresh.dataForUser
                }
            };


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'RefreshTokenService.generateNewTokens';
            }
            throw err;
        }
    }

}


module.exports = RefreshTokenService;