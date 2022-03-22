window.addEventListener('load', () => {
    document.querySelector('#refresh-img').addEventListener('click', () => {
        location.reload();
    });
    setInterval(() => {
        location.reload();
    }, 60000);
});