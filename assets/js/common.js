// assets/js/common.js - Common JavaScript functions

// Format time for display
function formatTime(time) {
    if (!time) return '';
    let parts = time.split(':');
    let hour = parseInt(parts[0]);
    let minute = parts[1];
    let ampm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    hour = hour ? hour : 12;
    return hour + ':' + minute + ' ' + ampm;
}

// Escape HTML
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Show toast notification
function showToast(type, message) {
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
        toastContainer.style.zIndex = '9999';
        document.body.appendChild(toastContainer);
    }
    
    const bgClass = type === 'success' ? 'bg-success' : (type === 'warning' ? 'bg-warning' : 'bg-danger');
    const icon = type === 'success' ? 'check-circle' : 'exclamation-triangle';
    const title = type === 'success' ? 'Success' : (type === 'warning' ? 'Warning' : 'Error');
    
    const toastEl = document.createElement('div');
    toastEl.className = 'toast show';
    toastEl.setAttribute('role', 'alert');
    toastEl.innerHTML = `
        <div class="toast-header ${bgClass} text-white">
            <i class="bi bi-${icon} me-2"></i>
            <strong class="me-auto">${title}</strong>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
        </div>
        <div class="toast-body">${message}</div>
    `;
    
    toastContainer.appendChild(toastEl);
    
    setTimeout(() => {
        toastEl.remove();
        if (toastContainer.children.length === 0) {
            toastContainer.remove();
        }
    }, 3000);
}

// Get department color class
function getDepartmentColorClass(programCode) {
    if (programCode === 'BSIT' || programCode === 'BSIS' || programCode === 'BSCS') return 'ccse';
    if (programCode === 'BSPOLS') return 'polsci';
    if (programCode === 'BSBA') return 'cba';
    if (programCode === 'BSHKI') return 'hki';
    return '';
}

// AJAX wrapper
function ajaxRequest(url, data, method = 'POST') {
    return $.ajax({
        url: url,
        method: method,
        data: data,
        dataType: 'json'
    });
}

// Confirm dialog
function confirmAction(message, callback) {
    if (confirm(message)) {
        callback();
    }
}

// Debounce function
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Get URL parameters
function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    const regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    const results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}