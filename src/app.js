const express = require('express');

const app = express();
const SERVED_PORT = 6851;

//Use JSON parser
app.use(express.json({limit: '10mb'}));

//Import routes
const testRouter = require('./routes/test');
app.use('/api/test', testRouter);

//Start server
app.listen(SERVED_PORT, () => {
    console.log(`Server is listening on port ${SERVED_PORT}`);
});