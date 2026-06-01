const ejs = require('ejs');


async function renderEjs({ templatePath, placeHolders }) {
    try {
        return await ejs.renderFile(templatePath, placeHolders);

    } catch (err) {
        err.from = 'from utils renderEjs'
        throw err
    }

}


module.exports = renderEjs;