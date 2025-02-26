document.addEventListener('DOMContentLoaded', function() {
    fetch('https://chestnut-info.ew.r.appspot.com/get-random-value')
        .then(response => response.json())
        .then(data => {
            const randomValueElement = document.getElementById('random-value');
            randomValueElement.innerHTML = `<a href="${data.url}" target="_blank">${data.text}</a>`;
        })
        .catch(error => console.error('Error:', error));
});