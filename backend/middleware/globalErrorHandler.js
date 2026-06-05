function errorHandler(err, req, res, next) {
    // the errorHandler will get called by the controller
    // but when it gets passed to layers dont change the source of the message
    // thus it is the layers job to check if it is from themself or from layers under
    // before throwing check if it has got err.from property - if it has that then it came from lower layer

    
    let status = err.status ? err.status : 500;
    //console.log(`Error while ${err.from} , ${err.message}`);
    
    return res.status(status).send({
        success: false,
        reason: err.message
    })

}

// the format for error handling

module.exports = errorHandler;