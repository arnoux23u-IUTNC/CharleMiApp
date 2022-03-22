const dragStart = target => {
    target.classList.add('dragging');
};

const dragEnd = target => {
    target.classList.remove('dragging');
};

const dragEnter = event => {
    event.currentTarget.classList.add('drop');
};

const dragLeave = event => {
    event.currentTarget.classList.remove('drop');
};

const drag = event => {
    event.dataTransfer.setData('text/html', event.currentTarget.outerHTML);
    event.dataTransfer.setData('text/plain', event.currentTarget.dataset.id);
};

const drop = event => {
    try{
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
            cardId: event.dataTransfer.getData('text/plain'),
            columnId: event.currentTarget.dataset.colId.toUpperCase()
        }));
    }catch (err){

    }
};

const allowDrop = event => {
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
    console.log('dragEnd');
    try {
        if (e.target.className.includes('card')) {
            dragEnd(e.target);
        }
    } catch (err) {
    }
});

document.querySelectorAll('.card').forEach(card => {
    card.addEventListener('dragstart', drag);
});

window.addEventListener('load', () => {
    setInterval(() => {
        location.reload();
    }, 60000);
});