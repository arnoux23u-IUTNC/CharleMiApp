let timer;
const INTERVAL = 60 * 1000;

let resetTimer = () => {
    clearTimeout(timer);
    timer = setTimeout(() => {
        window.location.reload();
    }, INTERVAL);
};

let dragStart = target => {
    target.classList.add('dragging');
};

let dragEnd = target => {
    target.classList.remove('dragging');
};

let dragEnter = event => {
    event.currentTarget.classList.add('drop');
};

let dragLeave = event => {
    event.currentTarget.classList.remove('drop');
};

let drag = event => {
    event.dataTransfer.setData('text/html', event.currentTarget.outerHTML);
    event.dataTransfer.setData('text/plain', event.currentTarget.dataset.id);
    resetTimer();
};

let drop = event => {
    try {
        document.querySelectorAll('.column').forEach(column => column.classList.remove('drop'));
        document.querySelector(`[data-id="${event.dataTransfer.getData('text/plain')}"]`).remove();
        event.preventDefault();
        event.currentTarget.innerHTML = event.currentTarget.innerHTML + event.dataTransfer.getData('text/html');
        const xhr = new XMLHttpRequest();
        xhr.open('POST', `/change-card-data/`);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.addEventListener('load', () => {
            location.reload();
        });
        xhr.send(JSON.stringify({
            cardId: event.dataTransfer.getData('text/plain'), columnId: event.currentTarget.dataset.colId.toUpperCase()
        }));
    } catch (err) {
    }
};

let allowDrop = event => {
    event.preventDefault();
};

document.querySelectorAll('.column').forEach(column => {
    column.addEventListener('dragenter', dragEnter);
    column.addEventListener('dragleave', dragLeave);
});

document.addEventListener('dragstart', e => {
    try {
        if (e.target.className.includes('card')) {
            dragStart(e.target);
        }
    } catch (err) {
    }
});

document.addEventListener('dragend', e => {
    try {
        if (e.target.className.includes('card')) {
            dragEnd(e.target);
        }
    } catch (err) {
    }
});

window.addEventListener('load', () => {
    document.querySelector('#refresh-img').addEventListener('click', () => {
        location.reload();
    });
    document.querySelectorAll('.card').forEach(card => {
        card.addEventListener('dragstart', drag);
    });
    document.querySelectorAll('.column').forEach(column => {
        column.addEventListener('drop', drop);
        column.addEventListener('dragover', allowDrop);
    });
    timer = setInterval(() => {
        location.reload();
    }, INTERVAL);
});