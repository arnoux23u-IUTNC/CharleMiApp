const jwt = require('jsonwebtoken');
const crypt = require('bcrypt');
const router = require('express').Router();

router.get('/', (req, res) => {
    res.send('Hello World!');
});

router.post('/', async (req, res) => {
    const {username, password} = req.body;


    /*if (username === 'admin' && password === 'admin') {
        const token = jwt.sign({username}, 'secret', {expiresIn: '1h'});
        res.json({token});
    } else {
        res.status(401).json({error: 'Invalid credentials'});
    }*/
    res.status(200).json({username});
});

module.exports = router;