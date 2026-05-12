// assets/js/schedule.js - Schedule page functionality

const ScheduleApp = (function() {
    'use strict';
    
    // ============================================
    // STATE
    // ============================================
    let currentView = 'instructor';
    let currentDept = 'all';
    let modalInstance = null;
    let entities = [];
    
    const daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    // ============================================
    // INITIALIZATION
    // ============================================
    function init(options = {}) {
        currentView = options.viewType || 'instructor';
        currentDept = options.department || 'all';
        
        console.log('ScheduleApp initializing:', { currentView, currentDept });
        
        initModal();
        renderDepartmentButtons();
        setupEventListeners();
        updateEntityTypeLabel();
        loadEntities();
    }
    
    function initModal() {
        const modalEl = document.getElementById('scheduleModal');
        if (modalEl) {
            modalInstance = new bootstrap.Modal(modalEl);
        }
    }
    
    function setupEventListeners() {
        // View toggle buttons
        document.getElementById('viewInstructorBtn')?.addEventListener('click', () => toggleView('instructor'));
        document.getElementById('viewRoomBtn')?.addEventListener('click', () => toggleView('room'));
        
        // Search input
        document.getElementById('entitySearch')?.addEventListener('input', debounce(filterEntities, 300));
        
        // Department buttons are rendered with onclick handlers
    }
    
    function updateEntityTypeLabel() {
        const icon = document.getElementById('entityTypeIcon');
        const label = document.getElementById('entityTypeLabel');
        
        if (currentView === 'instructor') {
            icon.className = 'bi bi-people me-2 text-success';
            label.textContent = 'Instructor';
        } else {
            icon.className = 'bi bi-grid-3x3 me-2 text-success';
            label.textContent = 'Room';
        }
    }
    
    // ============================================
    // DEPARTMENT BUTTONS
    // ============================================
    function renderDepartmentButtons() {
        const container = document.getElementById('deptButtonsContainer');
        if (!container) return;
        
        const departments = [
            { id: 'all', name: 'All Departments', icon: 'bi-grid-3x3-gap-fill' },
            { id: 'ccse', name: 'CCSE', icon: 'bi-laptop', colorClass: 'dept-ccse' },
            { id: 'polsci', name: 'POLSCI', icon: 'bi-building', colorClass: 'dept-polsci' },
            { id: 'cba', name: 'CBA', icon: 'bi-graph-up', colorClass: 'dept-cba' },
            { id: 'hki', name: 'HKI', icon: 'bi-brain', colorClass: 'dept-hki' }
        ];
        
        container.innerHTML = departments.map(dept => {
            const activeClass = currentDept === dept.id ? 'active' : '';
            const nameSpan = dept.colorClass 
                ? `<span class="${dept.colorClass}">${dept.name}</span>`
                : dept.name;
            
            return `
                <button class="dept-btn ${activeClass}" onclick="ScheduleApp.filterByDepartment('${dept.id}')">
                    <i class="bi ${dept.icon}"></i> ${nameSpan}
                </button>
            `;
        }).join('');
    }
    
    function filterByDepartment(dept) {
        currentDept = dept;
        renderDepartmentButtons();
        loadEntities();
        updateURL();
    }
    
    // ============================================
    // VIEW TOGGLE
    // ============================================
    function toggleView(view) {
        currentView = view;
        currentDept = 'all';
        renderDepartmentButtons();
        updateEntityTypeLabel();
        loadEntities();
        updateURL();
        
        // Update active states
        document.getElementById('viewInstructorBtn')?.classList.toggle('active', view === 'instructor');
        document.getElementById('viewRoomBtn')?.classList.toggle('active', view === 'room');
    }
    
    function updateURL() {
        const url = new URL(window.location);
        url.searchParams.set('view', currentView);
        url.searchParams.set('dept', currentDept);
        window.history.pushState({}, '', url);
    }
    
    // ============================================
    // DATA LOADING
    // ============================================
    async function loadEntities() {
        const container = document.getElementById('entityList');
        container.innerHTML = `
            <div class="col-12 text-center py-5">
                <div class="spinner-border text-success" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="mt-2 text-muted">Loading ${currentView}s...</p>
            </div>
        `;
        
        try {
            const response = await fetch(`../api/get_entities.php?view=${currentView}&dept=${currentDept}`);
            const data = await response.json();
            
            if (data.success) {
                entities = data.entities;
                renderEntities(entities);
                updateEntityCount(entities.length);
            } else {
                showError('Failed to load entities');
            }
        } catch (error) {
            console.error('Error loading entities:', error);
            showError('Error loading data. Please try again.');
        }
    }
    
    // ============================================
    // RENDER ENTITIES
    // ============================================
    function renderEntities(entities) {
        const container = document.getElementById('entityList');
        
        if (entities.length === 0) {
            container.innerHTML = `
                <div class="col-12 text-center py-5">
                    <i class="bi bi-search display-1 text-success mb-3"></i>
                    <h5 class="text-muted">No ${currentView}s found</h5>
                    <p class="text-muted">Try selecting a different department</p>
                </div>
            `;
            return;
        }
        
        const templateId = currentView === 'instructor' ? 'instructorCardTemplate' : 'roomCardTemplate';
        const template = document.getElementById(templateId);
        
        container.innerHTML = '';
        
        entities.forEach(entity => {
            const clone = template.content.cloneNode(true);
            const card = clone.querySelector('.entity-item');
            
            if (currentView === 'instructor') {
                populateInstructorCard(card, entity);
            } else {
                populateRoomCard(card, entity);
            }
            
            container.appendChild(clone);
        });
    }
    
    function populateInstructorCard(card, entity) {
        card.dataset.name = entity.full_name;
        card.dataset.detail = entity.position_title;
        card.dataset.department = entity.department;
        
        card.querySelector('.entity-avatar').textContent = entity.initials;
        card.querySelector('h6').textContent = entity.full_name;
        card.querySelector('small').textContent = entity.position_title;
        
        const badge = card.querySelector('.dept-badge');
        badge.textContent = entity.department;
        badge.classList.add(entity.department.toLowerCase());
        
        card.querySelector('.classes-badge').innerHTML = `<i class="bi bi-book me-1"></i>${entity.total_classes} Classes`;
        card.querySelector('.sessions-badge').innerHTML = `<i class="bi bi-calendar me-1"></i>${entity.total_schedules} Sessions`;
        
        const btn = card.querySelector('.view-schedule-btn');
        btn.onclick = () => showSchedule('instructor', entity.id, entity.full_name, 
            `${entity.position_title} - ${entity.department}`);
    }
    
    function populateRoomCard(card, entity) {
        card.dataset.name = entity.name;
        card.dataset.detail = entity.location;
        card.dataset.department = entity.department;
        
        card.querySelector('h6').textContent = entity.name;
        card.querySelector('small').textContent = entity.location;
        
        const badge = card.querySelector('.dept-badge');
        badge.textContent = entity.department;
        badge.classList.add(entity.department.toLowerCase());
        
        card.querySelector('.capacity-badge').innerHTML = `<i class="bi bi-people me-1"></i>Capacity: ${entity.capacity}`;
        card.querySelector('.schedules-badge').innerHTML = `<i class="bi bi-calendar me-1"></i>${entity.total_schedules} classes`;
        
        const btn = card.querySelector('.view-schedule-btn');
        const subtitle = `${entity.location} - Capacity: ${entity.capacity} | ${entity.department}`;
        btn.onclick = () => showSchedule('room', entity.id, entity.name, subtitle);
    }
    
    function updateEntityCount(count) {
        document.getElementById('entityCount').textContent = `${count} total`;
    }
    
    // ============================================
    // FILTER ENTITIES
    // ============================================
    function filterEntities() {
        const searchInput = document.getElementById('entitySearch');
        const filter = searchInput.value.toUpperCase();
        const items = document.querySelectorAll('.entity-item');
        let visibleCount = 0;
        
        items.forEach(item => {
            const name = item.dataset.name?.toUpperCase() || '';
            const detail = item.dataset.detail?.toUpperCase() || '';
            
            if (name.includes(filter) || detail.includes(filter)) {
                item.style.display = '';
                visibleCount++;
            } else {
                item.style.display = 'none';
            }
        });
        
        document.getElementById('entityCount').textContent = `${visibleCount} shown`;
    }
    
    // ============================================
    // SCHEDULE MODAL
    // ============================================
    async function showSchedule(type, id, name, subtitle) {
        console.log('showSchedule:', { type, id, name, subtitle });
        
        document.getElementById('entityName').textContent = name;
        document.getElementById('entitySubtitle').textContent = subtitle;
        
        const content = document.getElementById('timetableContent');
        content.innerHTML = `
            <div class="text-center py-5">
                <div class="spinner-border text-success" role="status"></div>
                <p class="mt-2">Loading weekly timetable...</p>
            </div>
        `;
        
        modalInstance.show();
        
        try {
            const response = await fetch(`../api/get_schedule_data.php?type=${type}&id=${id}`);
            const data = await response.json();
            
            if (data.error) {
                throw new Error(data.error);
            }
            
            displayFullWeekTimetable(data, type);
        } catch (error) {
            console.error('Error loading schedule:', error);
            content.innerHTML = `
                <div class="alert alert-danger m-3">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Error loading schedule. Please try again.
                </div>
            `;
        }
    }
    
    function displayFullWeekTimetable(data, type) {
        // Entity info
        const infoHtml = type === 'instructor' 
            ? buildInstructorInfo(data) 
            : buildRoomInfo(data);
        document.getElementById('entityInfo').innerHTML = infoHtml;
        
        // Build timetable
        const timeSlots = generateTimeSlots();
        const html = buildTimetableHTML(data, type, timeSlots);
        document.getElementById('timetableContent').innerHTML = html;
        
        // Summary stats
        const stats = calculateStats(data, timeSlots);
        document.getElementById('summaryStats').innerHTML = buildStatsHTML(stats);
    }
    
    function buildInstructorInfo(data) {
        return `
            <div class="row">
                <div class="col-md-4"><small class="text-muted">Position</small><div class="fw-bold">${escapeHtml(data.position || 'Faculty')}</div></div>
                <div class="col-md-4"><small class="text-muted">Email</small><div class="fw-bold">${escapeHtml(data.email || 'N/A')}</div></div>
                <div class="col-md-4"><small class="text-muted">Total Classes</small><div class="fw-bold">${calculateTotalClasses(data)}</div></div>
            </div>
        `;
    }
    
    function buildRoomInfo(data) {
        return `
            <div class="row">
                <div class="col-md-4"><small class="text-muted">Location</small><div class="fw-bold">${escapeHtml(data.location || 'N/A')}</div></div>
                <div class="col-md-4"><small class="text-muted">Capacity</small><div class="fw-bold">${data.capacity || 'N/A'} students</div></div>
                <div class="col-md-4"><small class="text-muted">Total Classes</small><div class="fw-bold">${calculateTotalClasses(data)}</div></div>
            </div>
        `;
    }
    
    function generateTimeSlots() {
        const slots = [];
        for (let hour = 8; hour < 20; hour++) {
            slots.push({
                start: `${hour.toString().padStart(2, '0')}:00:00`,
                display: `${hour.toString().padStart(2, '0')}:00`,
                hour, minute: 0
            });
            if (hour < 19) {
                slots.push({
                    start: `${hour.toString().padStart(2, '0')}:30:00`,
                    display: `${hour.toString().padStart(2, '0')}:30`,
                    hour, minute: 30
                });
            }
        }
        return slots;
    }
    
    function buildTimetableHTML(data, type, timeSlots) {
        let html = `
            <table class="full-week-table">
                <thead>
                    <tr><th>Time</th>${daysOfWeek.map(day => `<th>${day}</th>`).join('')}</tr>
                </thead>
                <tbody>
        `;
        
        const dayClassesMap = prepareDayClassesMap(data);
        const rowspanTracker = {};
        const placed = {};
        daysOfWeek.forEach(day => { rowspanTracker[day] = 0; placed[day] = new Set(); });
        
        timeSlots.forEach(slot => {
            html += `<tr><td class="time-slot"><strong>${slot.display}</strong></td>`;
            
            daysOfWeek.forEach(day => {
                if (rowspanTracker[day] > 0) {
                    rowspanTracker[day]--;
                    return;
                }
                
                const slotStart = timeToMinutes(slot.start);
                const slotEnd = slotStart + 30;
                const dayArr = dayClassesMap[day];
                
                const classObj = dayArr.find(c => 
                    !placed[day].has(c.schedule_id) && 
                    timeToMinutes(c.start_time) >= slotStart && 
                    timeToMinutes(c.start_time) < slotEnd
                );
                
                if (!classObj) {
                    html += `<td><div class="empty-slot-grid"><i class="bi bi-check-circle text-success me-1"></i> Available</div></td>`;
                } else {
                    placed[day].add(classObj.schedule_id);
                    const durationSlots = calculateDurationSlots(classObj);
                    const durationHours = (timeToMinutes(classObj.end_time) - timeToMinutes(classObj.start_time)) / 60;
                    const deptClass = getDepartmentClass(classObj.program_code);
                    
                    html += `<td rowspan="${durationSlots}" style="position: relative; height: ${durationSlots * 70}px; background: #fefef5;">
                        <div class="schedule-block-grid ${deptClass}" style="height: ${durationSlots * 70 - 4}px;">
                            <div class="course-code-grid">${escapeHtml(classObj.course_code)}</div>
                            <div class="course-name-grid" title="${escapeHtml(classObj.course_name)}">${escapeHtml(truncate(classObj.course_name, 30))}</div>
                            <div class="detail-info-grid"><i class="bi bi-clock"></i> ${formatTime(classObj.start_time)} - ${formatTime(classObj.end_time)}</div>
                            ${type === 'instructor' 
                                ? `<div class="detail-info-grid"><i class="bi bi-door-open"></i> ${escapeHtml(classObj.room_name)}</div>`
                                : `<div class="detail-info-grid"><i class="bi bi-person"></i> ${escapeHtml(classObj.instructor_name)}</div>`
                            }
                            <div class="detail-info-grid"><i class="bi bi-hourglass-split"></i> ${durationHours} hr${durationHours !== 1 ? 's' : ''}</div>
                        </div>
                    </td>`;
                    rowspanTracker[day] = durationSlots - 1;
                }
            });
            html += '</tr>';
        });
        
        html += '</tbody></table>';
        return html;
    }
    
    function prepareDayClassesMap(data) {
        const map = {};
        daysOfWeek.forEach(day => {
            const dayKey = day.toLowerCase();
            map[day] = (data.schedules[dayKey] || [])
                .slice()
                .sort((a, b) => timeToMinutes(a.start_time) - timeToMinutes(b.start_time));
        });
        return map;
    }
    
    // ============================================
    // HELPER FUNCTIONS
    // ============================================
    function timeToMinutes(time) {
        if (!time) return 0;
        const parts = time.split(':');
        return parseInt(parts[0], 10) * 60 + parseInt(parts[1], 10);
    }
    
    function calculateDurationSlots(classObj) {
        const startMinutes = timeToMinutes(classObj.start_time);
        const endMinutes = timeToMinutes(classObj.end_time);
        return Math.max(1, Math.ceil((endMinutes - startMinutes) / 30));
    }
    
    function getDepartmentClass(programCode) {
        if (!programCode) return '';
        if (['BSIT', 'BSIS', 'BSCS'].includes(programCode)) return 'ccse';
        if (programCode === 'BSPOLS') return 'polsci';
        if (programCode === 'BSBA') return 'cba';
        if (programCode === 'BSHKI') return 'hki';
        return '';
    }
    
    function calculateTotalClasses(data) {
        let total = 0;
        daysOfWeek.forEach(day => {
            total += (data.schedules[day.toLowerCase()] || []).length;
        });
        return total;
    }
    
    function calculateTotalHours(data) {
        let total = 0;
        daysOfWeek.forEach(day => {
            (data.schedules[day.toLowerCase()] || []).forEach(cls => {
                const start = timeToMinutes(cls.start_time);
                const end = timeToMinutes(cls.end_time);
                total += (end - start) / 60;
            });
        });
        return total;
    }
    
    function calculateBusySlots(data) {
        let busy = 0;
        daysOfWeek.forEach(day => {
            (data.schedules[day.toLowerCase()] || []).forEach(cls => {
                const start = timeToMinutes(cls.start_time);
                const end = timeToMinutes(cls.end_time);
                busy += (end - start) / 30;
            });
        });
        return busy;
    }
    
    function calculateStats(data, timeSlots) {
        const totalClasses = calculateTotalClasses(data);
        const totalHours = calculateTotalHours(data);
        const busySlots = calculateBusySlots(data);
        const totalSlots = daysOfWeek.length * timeSlots.length;
        const utilization = totalSlots > 0 ? Math.round((busySlots / totalSlots) * 100) : 0;
        
        return { totalClasses, totalHours, busySlots, totalSlots, utilization };
    }
    
    function buildStatsHTML(stats) {
        return `
            <div class="stat-badge"><i class="bi bi-book"></i> ${stats.totalClasses} Total Classes</div>
            <div class="stat-badge"><i class="bi bi-clock"></i> ${stats.totalHours.toFixed(1)} Total Hours</div>
            <div class="stat-badge"><i class="bi bi-calendar-week"></i> ${daysOfWeek.length} Days</div>
            <div class="stat-badge"><i class="bi bi-graph-up"></i> ${stats.utilization}% Utilization</div>
        `;
    }
    
    function formatTime(time) {
        if (!time) return '';
        const parts = time.split(':');
        let hour = parseInt(parts[0]);
        const minute = parts[1];
        const ampm = hour >= 12 ? 'PM' : 'AM';
        hour = hour % 12 || 12;
        return `${hour}:${minute} ${ampm}`;
    }
    
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    function truncate(text, length) {
        if (!text) return '';
        return text.length > length ? text.substring(0, length) + '...' : text;
    }
    
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
    
    function showError(message) {
        const container = document.getElementById('entityList');
        container.innerHTML = `
            <div class="col-12 text-center py-5">
                <i class="bi bi-exclamation-triangle display-1 text-warning mb-3"></i>
                <h5 class="text-muted">Error</h5>
                <p class="text-muted">${message}</p>
                <button class="btn btn-outline-success mt-3" onclick="ScheduleApp.refresh()">
                    <i class="bi bi-arrow-repeat me-2"></i>Try Again
                </button>
            </div>
        `;
    }
    
    function refresh() {
        loadEntities();
    }
    
    // ============================================
    // PUBLIC API
    // ============================================
    return {
        init,
        filterByDepartment,
        showSchedule,
        refresh
    };
    
})();

// Make globally available
window.ScheduleApp = ScheduleApp;