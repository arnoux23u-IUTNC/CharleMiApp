/*'use strict';

const URL_API = 'https://europe-west1-charlemi-app.cloudfunctions.net/api'

window.addEventListener('load', () => {
    const btn = document.getElementById('chg-btn');
    btn.addEventListener('click', () => changeData(btn.innerText.toLowerCase()))
});

let changeData = (mode) => {
    const xhr = new XMLHttpRequest();
    //send patch request to api with body parameter open value is mode
    xhr.open('PATCH', `${URL_API}/set-open`, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Access-Control-Allow-Origin', 'http://localhost');
    xhr.addEventListener('load', (e) => {
        console.log(e.target.response);
    })
    xhr.send(JSON.stringify({opened: mode}));
}*/