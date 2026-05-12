// assets/js/timetable_render.js - Timetable Rendering Functions

const TimetableRenderer = (function() {
    'use strict';
    
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const dayAbbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    // ============================================
    // TIMETABLE CREATION
    // ============================================
    
    function createTimetable(containerId, options = {}) {
        const defaults = {
            startHour: 8,
            endHour: 20,
            includeWeekend: true,
            cellHeight: 60,
            showLegend: true,
            showControls: true,
            title: 'Weekly Schedule'
        };
        
        const settings = { ...defaults, ...options };
        
        let html = buildTimetableWrapper(settings);
        $(`#${containerId}`).html(html);
        
        return {
            render: (schedules) => renderSchedules(containerId, schedules, settings),
            clear: () => clearTimetable(containerId),
            updateTitle: (title) => $(`#${containerId} .timetable-title h4`).text(title)
        };
    }
    
    function buildTimetableWrapper(settings) {
        const daysToShow = settings.includeWeekend ? days : days.slice(0, 5);
        
        let html = `
            <div class="timetable-wrapper">
                ${buildControls(settings)}
                <div class="timetable-container">
                    <table class="timetable" id="mainTimetable">
                        <thead>
                            ${buildHeader(daysToShow)}
                        </thead>
                        <tbody id="timetableBody">
                            ${buildTimeSlots(settings.startHour, settings.endHour, daysToShow, settings.cellHeight)}
                        </tbody>
                    </table>
                </div>
                ${settings.showLegend ? buildLegend() : ''}
            </div>
        `;
        
        return html;
    }
    
    function buildControls(settings) {
        if (!settings.showControls) return '';
        
        return `
            <div class="timetable-controls">
                <div class="timetable-title">
                    <h4><i class="bi bi-calendar-week me-2 text-success"></i>${settings.title}</h4>
                    <span class="badge bg-success bg-opacity-25 text-dark">
                        <i class="bi bi-clock me-1"></i>${settings.startHour}:00 - ${settings.endHour}:00
                    </span>
                </div>
                <div class="timetable-actions">
                    <div class="week-navigation">
                        <button class="week-nav-btn" onclick="TimetableRenderer.previousWeek()">
                            <i class="bi bi-chevron-left"></i>
                        </button>
                        <span class="week-display" id="weekDisplay">Current Week</span>
                        <button class="week-nav-btn" onclick="TimetableRenderer.nextWeek()">
                            <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>
                    <button class="btn btn-outline-success btn-sm" onclick="TimetableRenderer.exportTimetable()">
                        <i class="bi bi-download me-1"></i>Export
                    </button>
                    <button class="btn btn-outline-success btn-sm" onclick="TimetableRenderer.printTimetable()">
                        <i class="bi bi-printer me-1"></i>Print
                    </button>
                </div>
            </div>
        `;
    }
    
    function buildHeader(daysToShow) {
        let html = '<tr>';
        html += '<th class="time-header"><i class="bi bi-clock"></i> Time</th>';
        
        daysToShow.forEach((day, index) => {
            const today = new Date();
            const isToday = today.toLocaleDateString('en-US', { weekday: 'long' }) === day;
            
            html += `<th class="day-header ${isToday ? 'today' : ''}">`;
            html += day;
            html += `<span class="day-badge">${dayAbbr[index]}</span>`;
            if (isToday) {
                html += '<span class="badge bg-success ms-2" style="font-size: 0.6rem;">Today</span>';
            }
            html += '</th>';
        });
        
        html += '</tr>';
        return html;
    }
    
    function buildTimeSlots(startHour, endHour, daysToShow, cellHeight) {
        let html = '';
        
        for (let hour = startHour; hour < endHour; hour++) {
            // Full hour slot
            html += buildTimeSlotRow(hour, 0, daysToShow, cellHeight);
            
            // Half hour slot (except for last hour)
            if (hour < endHour - 1) {
                html += buildTimeSlotRow(hour, 30, daysToShow, cellHeight);
            }
        }
        
        return html;
    }
    
    function buildTimeSlotRow(hour, minute, daysToShow, cellHeight) {
        const timeKey = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
        const displayTime = formatTimeDisplay(hour, minute);
        const period = hour >= 12 ? 'PM' : 'AM';
        const isEvening = hour >= 17;
        
        let html = `<tr>`;
        html += `<td class="time-slot ${isEvening ? 'evening' : ''}" style="height: ${cellHeight}px;">
            <div class="time-main">${displayTime}</div>
            <div class="time-period">${period}</div>
        </td>`;
        
        daysToShow.forEach(day => {
            const cellId = `cell_${day}_${timeKey}`;
            const startTime = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}:00`;
            const endHour = minute === 30 ? hour + 1 : hour;
            const endMinute = minute === 30 ? 0 : 30;
            const endTime = `${endHour.toString().padStart(2, '0')}:${endMinute.toString().padStart(2, '0')}:00`;
            
            html += `<td id="${cellId}" 
                        class="timetable-cell ${isEvening ? 'evening-cell' : ''}"
                        data-day="${day}"
                        data-time="${timeKey}"
                        data-start="${startTime}"
                        data-end="${endTime}"
                        data-hour="${hour}"
                        data-minute="${minute}"
                        ondragover="DragDropTimetable.handleDragOver(event)"
                        ondragleave="DragDropTimetable.handleDragLeave(event)"
                        ondrop="DragDropTimetable.dropOnCell(event)">
                    <div id="wrapper_${cellId}" class="cell-wrapper">
                        <div class="timetable-cell-empty">
                            <i class="bi bi-dash-circle"></i>
                        </div>
                    </div>
                </td>`;
        });
        
        html += '</tr>';
        return html;
    }
    
    function buildLegend() {
        return `
            <div class="timetable-legend">
                <div class="legend-item">
                    <div class="legend-color ccse"></div>
                    <span>CCSE (BSIT/BSIS/BSCS)</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color polsci"></div>
                    <span>POLSCI (BSPOLS)</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color cba"></div>
                    <span>CBA (BSBA)</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color hki"></div>
                    <span>HKI (BSHKI)</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color lab"></div>
                    <span>Laboratory</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color exam"></div>
                    <span>Examination</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color evening"></div>
                    <span>Evening Class</span>
                </div>
            </div>
        `;
    }
    
    // ============================================
    // RENDER SCHEDULES
    // ============================================
    
    function renderSchedules(containerId, schedules, settings) {
        clearTimetable(containerId);
        
        if (!schedules || schedules.length === 0) {
            showEmptyState(containerId);
            return;
        }
        
        const daysToShow = settings.includeWeekend ? days : days.slice(0, 5);
        const timeSlots = generateTimeSlots(settings.startHour, settings.endHour);
        
        // Group schedules
        const schedulesByDayTime = groupSchedulesByDayTime(schedules);
        
        // Render blocks
        daysToShow.forEach(day => {
            const daySchedules = schedulesByDayTime[day] || {};
            
            Object.keys(daySchedules).forEach(startTimeKey => {
                const schedulesAtTime = daySchedules[startTimeKey];
                const startIndex = timeSlots.findIndex(slot => slot.timeKey === startTimeKey);
                
                if (startIndex === -1) return;
                
                const overlappingGroups = groupOverlappingSchedules(schedulesAtTime);
                
                overlappingGroups.forEach((group, groupIndex) => {
                    const columnWidth = 100 / group.length;
                    
                    group.forEach((schedule, idx) => {
                        const durationSlots = calculateDurationSlots(schedule, timeSlots, startIndex);
                        const blockHeight = durationSlots * settings.cellHeight;
                        const leftPosition = idx * columnWidth;
                        
                        renderScheduleBlock(day, startTimeKey, schedule, {
                            left: leftPosition,
                            width: columnWidth,
                            height: blockHeight,
                            durationSlots
                        });
                    });
                });
            });
        });
        
        updateStats(schedules);
    }
    
    function renderScheduleBlock(day, timeKey, schedule, dimensions) {
        const wrapperId = `wrapper_cell_${day}_${timeKey}`;
        const $wrapper = $(`#${wrapperId}`);
        
        if (!$wrapper.length) return;
        
        // Clear empty placeholder
        $wrapper.find('.timetable-cell-empty').remove();
        
        const deptClass = getDepartmentClass(schedule.program_code);
        const classType = getClassTypeClass(schedule);
        const isEvening = isEveningClass(schedule.start_time);
        
        const blockHtml = `
            <div class="schedule-block ${deptClass} ${classType} ${isEvening}"
                 style="position: absolute; top: 2px; left: ${dimensions.left}%; width: ${dimensions.width}%; height: ${dimensions.height - 4}px;"
                 draggable="true"
                 data-schedule-id="${schedule.schedule_id}"
                 data-class-id="${schedule.class_id}"
                 data-section="${escapeHtml(schedule.section || schedule.course_code)}"
                 data-course-code="${escapeHtml(schedule.course_code)}"
                 data-course-name="${escapeHtml(schedule.course_name)}"
                 data-room-id="${schedule.room_id}"
                 data-room-name="${escapeHtml(schedule.room_name)}"
                 data-instructor="${escapeHtml(schedule.instructor_name)}"
                 data-instructor-id="${schedule.instructor_id || ''}"
                 data-day="${schedule.day_of_week}"
                 data-start="${schedule.start_time}"
                 data-end="${schedule.end_time}"
                 data-credits="${schedule.credits || 3}">
                
                <div class="schedule-section">
                    <i class="bi bi-people-fill"></i>
                    ${escapeHtml(schedule.section || schedule.course_code)}
                </div>
                
                <div class="schedule-code">${escapeHtml(schedule.course_code)}</div>
                
                <div class="schedule-name" title="${escapeHtml(schedule.course_name)}">
                    ${truncate(schedule.course_name, 25)}
                </div>
                
                <div class="schedule-details">
                    <i class="bi bi-door-open"></i>
                    <span>${truncate(schedule.room_name, 15)}</span>
                </div>
                
                <div class="schedule-details">
                    <i class="bi bi-person"></i>
                    <span>${truncate(schedule.instructor_name, 15)}</span>
                </div>
                
                <div class="schedule-details">
                    <i class="bi bi-clock"></i>
                    <span>${formatTime(schedule.start_time)} - ${formatTime(schedule.end_time)}</span>
                </div>
                
                <div class="schedule-actions">
                    <div class="schedule-action-btn edit" onclick="DragDropTimetable.editSchedule(event, ${schedule.schedule_id})" title="Edit">
                        <i class="bi bi-pencil"></i>
                    </div>
                    <div class="schedule-action-btn delete" onclick="DragDropTimetable.deleteSchedule(event, ${schedule.schedule_id})" title="Delete">
                        <i class="bi bi-x"></i>
                    </div>
                </div>
            </div>
        `;
        
        $wrapper.append(blockHtml);
    }
    
    // ============================================
    // HELPER FUNCTIONS
    // ============================================
    
    function generateTimeSlots(startHour, endHour) {
        const slots = [];
        for (let hour = startHour; hour < endHour; hour++) {
            slots.push({
                timeKey: `${hour.toString().padStart(2, '0')}:00`,
                start: `${hour.toString().padStart(2, '0')}:00:00`,
                end: `${hour.toString().padStart(2, '0')}:30:00`,
                hour, minute: 0
            });
            if (hour < endHour - 1) {
                slots.push({
                    timeKey: `${hour.toString().padStart(2, '0')}:30`,
                    start: `${hour.toString().padStart(2, '0')}:30:00`,
                    end: `${(hour + 1).toString().padStart(2, '0')}:00:00`,
                    hour, minute: 30
                });
            }
        }
        return slots;
    }
    
    function groupSchedulesByDayTime(schedules) {
        const grouped = {};
        days.forEach(day => { grouped[day] = {}; });
        
        schedules.forEach(schedule => {
            const day = schedule.day_of_week;
            if (!grouped[day]) return;
            
            const startHour = parseInt(schedule.start_time.substring(0, 2));
            const startMinute = parseInt(schedule.start_time.substring(3, 5));
            const timeKey = `${startHour.toString().padStart(2, '0')}:${startMinute.toString().padStart(2, '0')}`;
            
            if (!grouped[day][timeKey]) {
                grouped[day][timeKey] = [];
            }
            grouped[day][timeKey].push(schedule);
        });
        
        return grouped;
    }
    
    function groupOverlappingSchedules(schedules) {
        const groups = [];
        
        schedules.forEach(schedule => {
            let added = false;
            const sStart = timeToMinutes(schedule.start_time);
            const sEnd = timeToMinutes(schedule.end_time);
            
            for (const group of groups) {
                const overlaps = group.some(existing => {
                    const eStart = timeToMinutes(existing.start_time);
                    const eEnd = timeToMinutes(existing.end_time);
                    return !(sEnd <= eStart || sStart >= eEnd);
                });
                
                if (overlaps) {
                    group.push(schedule);
                    added = true;
                    break;
                }
            }
            
            if (!added) {
                groups.push([schedule]);
            }
        });
        
        return groups;
    }
    
    function calculateDurationSlots(schedule, timeSlots, startIndex) {
        const startMinutes = timeToMinutes(schedule.start_time);
        const endMinutes = timeToMinutes(schedule.end_time);
        return (endMinutes - startMinutes) / 30;
    }
    
    function timeToMinutes(time) {
        const parts = time.split(':');
        return parseInt(parts[0]) * 60 + parseInt(parts[1]);
    }
    
    function getDepartmentClass(programCode) {
        if (!programCode) return '';
        if (['BSIT', 'BSIS', 'BSCS'].includes(programCode)) return 'ccse';
        if (programCode === 'BSPOLS') return 'polsci';
        if (programCode === 'BSBA') return 'cba';
        if (programCode === 'BSHKI') return 'hki';
        return '';
    }
    
    function getClassTypeClass(schedule) {
        if (schedule.requires_lab) return 'lab-class';
        if (schedule.is_exam) return 'exam';
        return 'lecture-class';
    }
    
    function isEveningClass(startTime) {
        const hour = parseInt(startTime.substring(0, 2));
        return hour >= 17 ? 'evening-class' : '';
    }
    
    function formatTimeDisplay(hour, minute) {
        const displayHour = hour % 12 || 12;
        return `${displayHour}:${minute.toString().padStart(2, '0')}`;
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
    
    function truncate(text, length) {
        if (!text) return '';
        return text.length > length ? text.substring(0, length) + '...' : text;
    }
    
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    function clearTimetable(containerId) {
        $(`#${containerId} .cell-wrapper`).each(function() {
            $(this).html('<div class="timetable-cell-empty"><i class="bi bi-dash-circle"></i></div>');
        });
    }
    
    function showEmptyState(containerId) {
        const $container = $(`#${containerId} .timetable-container`);
        $container.html(`
            <div class="timetable-empty">
                <i class="bi bi-calendar-x"></i>
                <h5>No Classes Scheduled</h5>
                <p>Drag and drop classes from the unscheduled list to create your timetable.</p>
                <button class="btn btn-primary-custom" onclick="AIGenerator.openAIModal()">
                    <i class="bi bi-robot me-2"></i>Generate with AI
                </button>
            </div>
        `);
    }
    
    function updateStats(schedules) {
        const totalClasses = schedules.length;
        const uniqueInstructors = new Set(schedules.map(s => s.instructor_id)).size;
        const uniqueRooms = new Set(schedules.map(s => s.room_id)).size;
        
        $('#totalClassesCount').text(totalClasses);
        $('#scheduledCount').text(totalClasses);
        
        // Calculate utilization
        const totalSlots = days.length * 24;
        const utilization = Math.min(100, Math.round((totalClasses / totalSlots) * 100));
        $('#utilizationRate').text(utilization + '%');
    }
    
    // ============================================
    // PUBLIC API
    // ============================================
    
    return {
        create: createTimetable,
        render: renderSchedules,
        clear: clearTimetable,
        days: days,
        exportTimetable: function() {
            const html = $('.timetable').prop('outerHTML');
            const style = $('style').text();
            const printWindow = window.open('', '_blank');
            printWindow.document.write(`
                <html><head><title>Timetable</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <style>${style}</style>
                </head><body><div class="container mt-4">${html}</div></body></html>
            `);
            printWindow.document.close();
            printWindow.print();
        },
        printTimetable: function() {
            window.print();
        },
        previousWeek: function() {
            // Implementation for week navigation
            showToast('info', 'Week navigation - implement as needed');
        },
        nextWeek: function() {
            showToast('info', 'Week navigation - implement as needed');
        }
    };
})();