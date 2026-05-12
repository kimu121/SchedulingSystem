// assets/js/ai_generator.js - Complete Fixed Implementation

const AIGenerator = (function() {
    'use strict';
    
    // State variables
    let allClasses = [];
    let allSchedules = [];
    let allRooms = [];
    let unscheduledClasses = [];
    let departments = [];
    let selectedDepartment = null;
    let currentSemesterFilter = { year: '2026', semester: '1st Semester' };
    
    // Drag state
    let draggedItem = null;
    let currentDragTarget = null;
    let currentDurationSlots = 0;
    let currentDragClassId = null;
    let pendingDropData = null;
    let selectedRoomId = null;
    let availableRooms = [];
    let isDraggingActive = false;
    
    // AI Modal
    let aiModalInstance = null;
    let exportedData = null;
    let aiPreviewData = null;
    
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const API_URL = '../api/generate_timetable_api.php';
    
    // ============================================
    // INITIALIZATION
    // ============================================
    function init() {
        console.log('AIGenerator initializing...');
        initTimetable();
        loadRooms();
        loadDepartments();
        setupEventListeners();
        setSemesterFilter('2026_1');
    }
    
    function setupEventListeners() {
        $('#semesterSelect').on('change', function() {
            currentSemesterFilter.semester = $(this).val();
            updateFilterDisplay();
            loadScheduleData();
        });
        
        $('#yearSelect').on('change', function() {
            currentSemesterFilter.year = $(this).val();
            updateFilterDisplay();
            loadScheduleData();
        });
        
        $('#startHour, #endHour').on('change', function() {
            initTimetable();
            if (allSchedules.length > 0) {
                renderTimetable(allSchedules);
            } else {
                loadScheduleData();
            }
        });
    }
    
    // ============================================
    // TIMETABLE FUNCTIONS
    // ============================================
    function initTimetable() {
        const timeSlots = getTimeSlots();
        
        let headerHtml = '<tr><th style="width: 100px;">Time</th>';
        days.forEach(day => { headerHtml += `<th>${day}</th>`; });
        headerHtml += '</tr>';
        $('#timetableHeader').html(headerHtml);
        
        let bodyHtml = '';
        for (let i = 0; i < timeSlots.length; i++) {
            let slot = timeSlots[i];
            bodyHtml += `<tr><td class="time-slot">${slot.display}</td>`;
            
            for (let j = 0; j < days.length; j++) {
                // IMPORTANT: Use same ID format as renderTimetable
                const safeTimeKey = slot.timeKey.replace(/:/g, '-');
                let cellId = `cell_${days[j]}_${safeTimeKey}`;
                bodyHtml += `<td id="${cellId}" class="timetable-cell" 
                           data-day="${days[j]}" 
                           data-time="${slot.timeKey}"
                           data-start="${slot.start}"
                           data-end="${slot.end}"
                           data-index="${i}">
                        <div id="wrapper_${cellId}" class="cell-wrapper" style="position: relative; height: 70px;"></div>
                           </td>`;
                }
            bodyHtml += '</tr>';
        }
        $('#timetableBody').html(bodyHtml);
        
        // Attach drag event listeners
        $('.timetable-cell').on('dragover', handleDragOver);
        $('.timetable-cell').on('dragleave', handleDragLeave);
        $('.timetable-cell').on('drop', dropOnCell);
    }
    
    function getTimeSlots() {
        const startHour = parseInt($('#startHour').val() || 8);
        const endHour = parseInt($('#endHour').val() || 20);
        let slots = [];
        
        for (let hour = startHour; hour < endHour; hour++) {
            slots.push({
                start: `${hour.toString().padStart(2, '0')}:00:00`,
                end: `${hour.toString().padStart(2, '0')}:30:00`,
                display: `${hour.toString().padStart(2, '0')}:00 - ${hour.toString().padStart(2, '0')}:30`,
                timeKey: `${hour.toString().padStart(2, '0')}:00`
            });
            slots.push({
                start: `${hour.toString().padStart(2, '0')}:30:00`,
                end: `${(hour + 1).toString().padStart(2, '0')}:00:00`,
                display: `${hour.toString().padStart(2, '0')}:30 - ${(hour + 1).toString().padStart(2, '0')}:00`,
                timeKey: `${hour.toString().padStart(2, '0')}:30`
            });
        }
        return slots;
    }
    
    function timeToMinutes(time) {
        if (!time) return 0;
        const parts = time.split(':');
        return parseInt(parts[0]) * 60 + parseInt(parts[1]);
    }
    
    // ============================================
    // DATA LOADING
    // ============================================
    function loadRooms() {
        $.getJSON('../api/get_rooms.php', function(data) {
            allRooms = data;
            let options = '<option value="">Select Room</option>';
            data.forEach(room => {
                options += `<option value="${room.room_id}">${room.name} (Capacity: ${room.capacity})</option>`;
            });
            $('#editRoom').html(options);
        }).fail(function() {
            console.error('Failed to load rooms');
        });
    }
    
    function loadDepartments() {
        $.post(API_URL, { action: 'get_departments' }, function(data) {
            if (data.success) {
                departments = data.departments;
                renderDepartmentButtons();
            }
        }, 'json').fail(function() {
            console.error('Failed to load departments');
        });
    }
    
    function renderDepartmentButtons() {
        const $container = $('#deptButtons');
        $container.empty();
        
        $container.append(`
            <button class="dept-btn ${!selectedDepartment ? 'active' : ''}" onclick="AIGenerator.selectDepartment(null)">
                <i class="bi bi-grid-3x3"></i> All Departments
            </button>
        `);
        
        departments.forEach(dept => {
            let icon = 'bi-building';
            if (dept.short_name === 'CCSE') icon = 'bi-laptop';
            else if (dept.short_name === 'POLSCI') icon = 'bi-building';
            else if (dept.short_name === 'CBA') icon = 'bi-graph-up';
            else if (dept.short_name === 'HKI') icon = 'bi-brain';
            
            const activeClass = selectedDepartment && selectedDepartment.department_id === dept.department_id ? 'active' : '';
            
            $container.append(`
                <button class="dept-btn ${activeClass}" onclick="AIGenerator.selectDepartment(${dept.department_id})">
                    <i class="bi ${icon}"></i> ${dept.short_name}
                </button>
            `);
        });
    }
    
    function selectDepartment(departmentId) {
        if (departmentId === null) {
            selectedDepartment = null;
            renderDepartmentButtons();
            $('#deptHeader').hide();
            $('#sectionButtonsContainer').hide();
            loadScheduleData();
            return;
        }
        
        const department = departments.find(d => d.department_id == departmentId);
        if (!department) return;
        
        selectedDepartment = department;
        renderDepartmentButtons();
        loadDepartmentSchedule(departmentId);
    }
    
    function loadDepartmentSchedule(departmentId) {
        const semester = currentSemesterFilter.semester;
        const year = currentSemesterFilter.year;
        
        $('#timetableContainer').css('opacity', '0.5');
        showToast('info', `Loading ${semester} ${year} schedule...`);
        
        $.post(API_URL, {
            action: 'get_department_schedule',
            department_id: departmentId,
            semester: semester,
            year: year
        }, function(data) {
            if (data.success) {
                allSchedules = data.schedules;
                
                // Load all classes first
                $.getJSON(`../api/get_schedule_data_full.php?semester=${encodeURIComponent(semester)}&year=${year}`, function(fullData) {
                    allClasses = fullData.classes.filter(cls => cls.course_code !== 'Off-Cam');
                    
                    const deptClasses = allClasses.filter(cls => data.program_codes.includes(cls.program_code));
                    const scheduledClassIds = new Set(data.schedules.map(s => s.class_id));
                    unscheduledClasses = deptClasses.filter(cls => !scheduledClassIds.has(cls.class_id));
                    
                    renderTimetable(data.schedules);
                    updateUnscheduledList();
                    
                    updateStats({
                        total_classes: deptClasses.length,
                        scheduled_count: data.schedules.length,
                        conflict_count: 0,
                        utilization: calculateUtilization(data.schedules)
                    });
                    
                    $('#scheduleCountBadge').html(`<i class="bi bi-calendar-check me-1"></i> ${data.schedules.length} schedules`);
                    
                    updateDepartmentUI(data);
                    
                    $('#deptHeader').show();
                    $('#sectionButtonsContainer').show();
                    $('#unscheduledContainer').toggle(unscheduledClasses.length > 0);
                    
                    showToast('success', `Loaded ${data.department.short_name} schedule`);
                    $('#timetableContainer').css('opacity', '1');
                }).fail(function() {
                    $('#timetableContainer').css('opacity', '1');
                    showToast('error', 'Error loading classes');
                });
            } else {
                $('#timetableContainer').css('opacity', '1');
                showToast('error', data.message || 'Error loading department schedule');
            }
        }, 'json').fail(function() {
            $('#timetableContainer').css('opacity', '1');
            showToast('error', 'Error loading department schedule');
        });
    }
    
    function updateDepartmentUI(data) {
        const semester = currentSemesterFilter.semester;
        const year = currentSemesterFilter.year;
        
        $('#deptHeaderTitle').html(`<i class="bi bi-building me-2"></i>${data.department.short_name} - ${semester} ${year}`);
        $('#deptHeaderDesc').html(`Viewing all class schedules for ${data.department.name}`);
        $('#deptHeaderStats').html(`
            <span class="stat"><i class="bi bi-layers"></i> ${data.sections.length} Sections</span>
            <span class="stat"><i class="bi bi-calendar-check"></i> ${data.schedules.length} Scheduled</span>
        `);
        
        const $sectionButtons = $('#sectionButtons');
        $sectionButtons.empty();
        
        data.sections.forEach(section => {
            $sectionButtons.append(`
                <button class="section-btn" onclick="AIGenerator.showSectionSchedule('${section.section}')">
                    <i class="bi bi-calendar-week me-2"></i>${section.section} (Year ${section.year_level || '?'})
                </button>
            `);
        });
    }
    
    function loadScheduleData() {
        const semester = currentSemesterFilter.semester;
        const year = currentSemesterFilter.year;
        
        if (selectedDepartment) {
            loadDepartmentSchedule(selectedDepartment.department_id);
            return;
        }
        
        $('#timetableContainer').css('opacity', '0.5');
        showToast('info', `Loading ${semester} ${year} schedule...`);
        
        $('#deptHeader').hide();
        $('#sectionButtonsContainer').hide();
        
        $.getJSON(`../api/get_schedule_data_full.php?semester=${encodeURIComponent(semester)}&year=${year}`, function(data) {
            console.log('Schedule data loaded:', data.schedules.length, 'schedules');
            
            allClasses = data.classes.filter(cls => cls.course_code !== 'Off-Cam');
            allSchedules = data.schedules;
            
            const scheduledClassIds = new Set(allSchedules.map(s => s.class_id));
            unscheduledClasses = allClasses.filter(cls => !scheduledClassIds.has(cls.class_id));
            
            renderTimetable(allSchedules);
            updateStats({
                total_classes: allClasses.length,
                scheduled_count: allSchedules.length,
                conflict_count: 0,
                utilization: data.utilization
            });
            updateUnscheduledList();
            
            $('#scheduleCountBadge').html(`<i class="bi bi-calendar-check me-1"></i> ${allSchedules.length} schedules`);
            $('#unscheduledContainer').toggle(unscheduledClasses.length > 0);
            
            showToast('success', `Loaded ${allSchedules.length} schedules`);
            $('#timetableContainer').css('opacity', '1');
        }).fail(function(xhr, status, error) {
            console.error('Failed to load schedule:', error);
            $('#timetableContainer').css('opacity', '1');
            showToast('error', 'Error loading schedule data');
        });
    }
    
    function calculateUtilization(schedules) {
        const timeSlots = getTimeSlots();
        const totalTimeSlots = days.length * timeSlots.length;
        return totalTimeSlots > 0 ? Math.min(100, Math.round((schedules.length / totalTimeSlots) * 100)) + '%' : '0%';
    }
    
    // ============================================
    // RENDER TIMETABLE
    // ============================================
    function renderTimetable(schedules) {
        const timeSlots = getTimeSlots();
        const rowHeight = 70;
        
        // Clear all wrappers FIRST
        days.forEach(day => {
            timeSlots.forEach(slot => {
                const safeTimeKey = slot.timeKey.replace(/:/g, '-');
                const wrapperId = `wrapper_cell_${day}_${safeTimeKey}`;
                $(`#${wrapperId}`).empty();
            });
        });
        
        if (!schedules || schedules.length === 0) {
            console.log('No schedules to render');
            return;
        }
        
        console.log('Rendering', schedules.length, 'schedules');
        
        // Group schedules by day and start time
        const schedulesByDayAndTime = {};
        days.forEach(day => { schedulesByDayAndTime[day] = {}; });
        
        schedules.forEach(schedule => {
            const day = schedule.day_of_week;
            if (!schedulesByDayAndTime[day]) return;
            
            const startHour = parseInt(schedule.start_time.substring(0, 2));
            const startMinute = parseInt(schedule.start_time.substring(3, 5));
            const startTimeKey = `${startHour.toString().padStart(2, '0')}:${startMinute.toString().padStart(2, '0')}`;
            
            if (!schedulesByDayAndTime[day][startTimeKey]) {
                schedulesByDayAndTime[day][startTimeKey] = [];
            }
            schedulesByDayAndTime[day][startTimeKey].push(schedule);
        });
        
        // Render blocks
        days.forEach(day => {
            const daySchedules = schedulesByDayAndTime[day];
            const sortedTimeKeys = Object.keys(daySchedules).sort();
            
            sortedTimeKeys.forEach(startTimeKey => {
                const schedulesAtTime = daySchedules[startTimeKey];
                    const startIndex = timeSlots.findIndex(slot => slot.timeKey === startTimeKey);
                if (startIndex === -1) return;
                
                const overlappingGroups = groupOverlappingSchedules(schedulesAtTime);
                
                overlappingGroups.forEach(group => {
                    const groupSize = group.length;
                    const columnWidth = 100 / groupSize;
                    
                    group.sort((a, b) => timeToMinutes(b.end_time) - timeToMinutes(a.end_time));
                    
                    group.forEach((schedule, idx) => {
                        const startMinutes = timeToMinutes(schedule.start_time);
                        const endMinutes = timeToMinutes(schedule.end_time);
                        const durationSlots = (endMinutes - startMinutes) / 30;
                        const blockHeight = durationSlots * rowHeight;
                        const leftPosition = idx * columnWidth;
                        
                        const safeStartKey = startTimeKey.replace(/:/g, '-');
                        const wrapperId = `wrapper_cell_${day}_${safeStartKey}`;
                        const $wrapper = $(`#${wrapperId}`);
                        
                        if ($wrapper.length) {
                            const deptClass = getDepartmentColorClass(schedule.program_code || '');
                            renderScheduleBlock($wrapper, schedule, leftPosition, columnWidth, blockHeight, deptClass);
                        } else {
                            console.warn('Wrapper not found:', wrapperId);
                        }
                    });
                });
            });
        });
        
        attachDragListeners();
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
            
            if (!added) groups.push([schedule]);
        });
        
        return groups;
    }
    
    function renderScheduleBlock($wrapper, schedule, left, width, height, deptClass) {
        const instructorName = schedule.instructor_name || 'N/A';
        const roomName = schedule.room_name || 'N/A';
        const sectionName = schedule.section || schedule.course_code || 'Unknown';
        
        const blockHtml = `
            <div class="schedule-block ${deptClass}" 
                 style="position: absolute; top: 2px; left: ${left}%; width: ${width - 2}%; height: ${height - 4}px; min-width: 80px;"
                 draggable="true"
                 data-schedule-id="${schedule.schedule_id}"
                 data-class-id="${schedule.class_id}"
                 data-section="${escapeHtml(sectionName)}"
                 data-course-code="${escapeHtml(schedule.course_code)}"
                 data-course-name="${escapeHtml(schedule.course_name)}"
                 data-room-id="${schedule.room_id}"
                 data-room-name="${escapeHtml(roomName)}"
                 data-instructor="${escapeHtml(instructorName)}"
                 data-instructor-id="${schedule.instructor_id || ''}"
                 data-day="${schedule.day_of_week}"
                 data-start="${schedule.start_time}"
                 data-end="${schedule.end_time}">
                <div class="schedule-section">${escapeHtml(sectionName)}</div>
                <div class="schedule-code">${escapeHtml(schedule.course_code)}</div>
                <div class="schedule-details"><i class="bi bi-door-open"></i> ${escapeHtml(roomName.substring(0, 12))}</div>
                <div class="schedule-details"><i class="bi bi-person"></i> ${escapeHtml(instructorName.substring(0, 12))}</div>
                <div class="schedule-delete" onclick="AIGenerator.deleteSchedule(event, ${schedule.schedule_id})">
                    <i class="bi bi-x"></i>
                </div>
                <div class="schedule-edit" onclick="AIGenerator.editSchedule(event, ${schedule.schedule_id})">
                    <i class="bi bi-pencil"></i>
                </div>
            </div>
        `;
        
        $wrapper.append(blockHtml);
    }
    
    function getDepartmentColorClass(programCode) {
        if (programCode === 'BSIT' || programCode === 'BSIS' || programCode === 'BSCS') return 'ccse';
        if (programCode === 'BSPOLS') return 'polsci';
        if (programCode === 'BSBA') return 'cba';
        if (programCode === 'BSHKI') return 'hki';
        return '';
    }
    
    function attachDragListeners() {
        $('.schedule-block').off('dragstart').on('dragstart', dragSchedule);
        $('.unscheduled-class').off('dragstart').on('dragstart', dragUnscheduledClass);
        $(document).off('dragend').on('dragend', dragEnd);
    }
    
    // ============================================
    // UNSCHEDULED CLASSES
    // ============================================
    function updateUnscheduledList() {
        const $container = $('#unscheduledContainer');
        const $listContainer = $('#unscheduledList');
        
        if (unscheduledClasses.length > 0) {
            $container.show();
            $listContainer.empty();
            
            unscheduledClasses.forEach(cls => {
                const sectionName = cls.section || cls.course_code;
                $listContainer.append(`
                    <div class="unscheduled-class" draggable="true"
                         data-class-id="${cls.class_id}"
                         data-section="${escapeHtml(sectionName)}"
                         data-course-code="${escapeHtml(cls.course_code)}"
                         data-course-name="${escapeHtml(cls.course_name)}"
                         data-credits="${cls.credits || 3}"
                         data-instructor="${escapeHtml(cls.instructor_name)}"
                         data-instructor-id="${cls.instructor_id}">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <strong>${escapeHtml(sectionName)}</strong>
                                <div class="small text-muted mt-1">${escapeHtml(cls.course_code)} - ${escapeHtml(cls.course_name)}</div>
                                <div class="small text-muted mt-1">
                                    <i class="bi bi-clock"></i> ${cls.credits || 3} hour(s) | 
                                    <i class="bi bi-person"></i> ${escapeHtml(cls.instructor_name)}
                                </div>
                            </div>
                            <button class="btn btn-sm btn-outline-success" onclick="AIGenerator.scheduleUnscheduledClass(${cls.class_id})">
                                <i class="bi bi-plus"></i> Schedule
                            </button>
                        </div>
                    </div>
                `);
            });
            
            $('.unscheduled-class').on('dragstart', dragUnscheduledClass);
        } else {
            $container.hide();
        }
    }
    
    function scheduleUnscheduledClass(classId) {
        showToast('info', 'Drag this class to a time slot on the timetable to schedule it');
    }
    
    // ============================================
    // DRAG AND DROP
    // ============================================
    async function dragSchedule(event) {
        const block = event.target.closest('.schedule-block');
        if (!block) return;
        
        const $block = $(block);
        const classId = parseInt($block.data('classId'));
        const credits = await getClassCredits(classId);
        const durationSlots = credits * 2;
        
        currentDurationSlots = durationSlots;
        currentDragClassId = classId;
        
        enableFixedMode();
        
        draggedItem = {
            type: 'scheduled',
            scheduleId: $block.data('scheduleId'),
            classId: classId,
            section: $block.data('section'),
            courseCode: $block.data('courseCode'),
            courseName: $block.data('courseName'),
            day: $block.data('day'),
            start: $block.data('start'),
            end: $block.data('end'),
            roomId: $block.data('roomId'),
            roomName: $block.data('roomName'),
            instructor: $block.data('instructor'),
            instructorId: $block.data('instructorId')
        };
        
        event.originalEvent.dataTransfer.setData('text/plain', JSON.stringify(draggedItem));
        event.originalEvent.dataTransfer.effectAllowed = 'move';
        $block.addClass('dragging');
    }
    
    async function dragUnscheduledClass(event) {
        const unscheduled = event.target.closest('.unscheduled-class');
        if (!unscheduled) return;
        
        const $unscheduled = $(unscheduled);
        const credits = parseFloat($unscheduled.data('credits'));
        const durationSlots = credits * 2;
        
        currentDurationSlots = durationSlots;
        currentDragClassId = $unscheduled.data('classId');
        
        enableFixedMode();
        
        draggedItem = {
            type: 'unscheduled',
            classId: $unscheduled.data('classId'),
            section: $unscheduled.data('section'),
            courseCode: $unscheduled.data('courseCode'),
            courseName: $unscheduled.data('courseName'),
            credits: credits,
            instructor: $unscheduled.data('instructor'),
            instructorId: $unscheduled.data('instructorId')
        };
        
        event.originalEvent.dataTransfer.setData('text/plain', JSON.stringify(draggedItem));
        event.originalEvent.dataTransfer.effectAllowed = 'copy';
        $unscheduled.addClass('dragging');
    }
    
    function dragEnd(event) {
        $('.dragging').removeClass('dragging');
        $('.timetable-cell').removeClass('drag-over-no-conflict drag-over-teacher-conflict drag-over-room-conflict');
        disableFixedMode();
        draggedItem = null;
        currentDurationSlots = 0;
        currentDragClassId = null;
    }
    
    function handleDragOver(event) {
        event.preventDefault();
        const targetCell = event.target.closest('.timetable-cell');
        if (!targetCell || !draggedItem) return;
        
        if (targetCell !== currentDragTarget) {
            if (currentDragTarget) {
                $(currentDragTarget).removeClass('drag-over-no-conflict drag-over-teacher-conflict drag-over-room-conflict');
            }
            $(targetCell).addClass('drag-over-no-conflict');
            currentDragTarget = targetCell;
        }
    }
    
    function handleDragLeave(event) {
        const targetCell = event.target.closest('.timetable-cell');
        if (targetCell && targetCell === currentDragTarget) {
            $(targetCell).removeClass('drag-over-no-conflict drag-over-teacher-conflict drag-over-room-conflict');
            currentDragTarget = null;
        }
    }
    
    async function dropOnCell(event) {
        event.preventDefault();
        
        $('.timetable-cell').removeClass('drag-over-no-conflict drag-over-teacher-conflict drag-over-room-conflict');
        
        const targetCell = event.target.closest('.timetable-cell');
        if (!targetCell) return;
        
        let data;
        try {
            data = JSON.parse(event.originalEvent.dataTransfer.getData('text/plain'));
        } catch (e) {
            return;
        }
        
        const day = targetCell.dataset.day;
        const startTime = targetCell.dataset.start;
        const timeSlots = getTimeSlots();
        const startIndex = parseInt(targetCell.dataset.index);
        const endIndex = startIndex + currentDurationSlots - 1;
        
        if (endIndex >= timeSlots.length) {
            showToast('error', 'Not enough time slots available');
            cleanupAfterDrop();
            return;
        }
        
        const endTime = timeSlots[endIndex].end;
        const classDetails = allClasses.find(c => c.class_id == data.classId);
        
        if (!classDetails) {
            cleanupAfterDrop();
            return;
        }
        
        const dropData = {
            classId: data.classId,
            section: data.section || classDetails.section,
            courseCode: classDetails.course_code,
            courseName: classDetails.course_name,
            instructor: classDetails.instructor_name,
            credits: classDetails.credits,
            instructorId: classDetails.instructor_id,
            durationSlots: currentDurationSlots,
            day: day,
            startTime: startTime,
            endTime: endTime
        };
        
        const conflictResult = await checkConflictsAsync(data.classId, day, startTime, endTime, classDetails.instructor_id);
        
        if (conflictResult.hasTeacherConflict) {
            showToast('error', `Teacher conflict: ${conflictResult.teacherConflictDetails}`);
            cleanupAfterDrop();
            return;
        }
        
        if (conflictResult.hasRoomConflict) {
            await loadAvailableRooms(day, startTime, endTime, data.classId);
            
            if (availableRooms.length === 0) {
                showToast('error', 'No available rooms for this time slot');
                cleanupAfterDrop();
                return;
            }
            
            pendingDropData = dropData;
            showRoomSelectionModal();
            cleanupAfterDrop();
            return;
        }
        
        await directSaveSchedule(dropData);
        cleanupAfterDrop();
    }
    
    async function checkConflictsAsync(classId, day, startTime, endTime, instructorId) {
        try {
            const response = await $.post(API_URL, {
                action: 'check_conflicts',
                class_id: classId,
                room_id: 0,
                day: day,
                start_time: startTime,
                end_time: endTime,
                instructor_id: instructorId
            });
            
            let hasTeacherConflict = false;
            let teacherConflictDetails = '';
            let hasRoomConflict = false;
            
            if (response.has_conflict) {
                response.conflicts.forEach(conflict => {
                    if (conflict.type === 'instructor') {
                        hasTeacherConflict = true;
                        teacherConflictDetails = conflict.details;
                    } else if (conflict.type === 'room') {
                        hasRoomConflict = true;
                    }
                });
            }
            
            return { hasTeacherConflict, teacherConflictDetails, hasRoomConflict };
        } catch (error) {
            return { hasTeacherConflict: false, hasRoomConflict: false };
        }
    }
    
    async function loadAvailableRooms(day, startTime, endTime, classId) {
        try {
            const response = await $.post(API_URL, {
                action: 'get_available_rooms',
                day: day,
                start_time: startTime,
                end_time: endTime,
                class_id: classId
            });
            availableRooms = response.rooms || [];
        } catch (error) {
            availableRooms = [];
        }
    }
    
    async function directSaveSchedule(dropData) {
        const availableRoomsForSlot = await getAvailableRoomsForSlot(dropData.day, dropData.startTime, dropData.endTime, dropData.classId);
        
        if (availableRoomsForSlot.length === 0) {
            showToast('error', 'No available rooms for this time slot');
            return;
        }
        
        const selectedRoom = availableRoomsForSlot[0];
        
        const scheduleData = {
            class_id: dropData.classId,
            room_id: selectedRoom.room_id,
            day: dropData.day,
            start_time: dropData.startTime,
            end_time: dropData.endTime
        };
        
        try {
            const response = await $.post(API_URL, {
                action: 'save_schedule',
                schedule_data: JSON.stringify(scheduleData)
            });
            
            if (response.success) {
                showToast('success', `Class scheduled in ${selectedRoom.name}`);
                loadScheduleData();
            } else {
                showToast('error', response.message);
            }
        } catch (error) {
            showToast('error', 'Error saving schedule');
        }
    }
    
    async function getAvailableRoomsForSlot(day, startTime, endTime, classId) {
        try {
            const response = await $.post(API_URL, {
                action: 'get_available_rooms',
                day: day,
                start_time: startTime,
                end_time: endTime,
                class_id: classId
            });
            return response.rooms || [];
        } catch (error) {
            return [];
        }
    }
    
    async function getClassCredits(classId) {
        const classData = allClasses.find(c => c.class_id == classId);
        return classData ? classData.credits : 3;
    }
    
    function cleanupAfterDrop() {
        $('.dragging').removeClass('dragging');
        disableFixedMode();
        draggedItem = null;
        currentDurationSlots = 0;
        currentDragClassId = null;
    }
    
    function enableFixedMode() {
        if (isDraggingActive) return;
        isDraggingActive = true;
        $('.schedule-block').addClass('fixed-mode');
        $('#dragCancelPanel').addClass('show');
    }
    
    function disableFixedMode() {
        if (!isDraggingActive) return;
        isDraggingActive = false;
        $('.schedule-block').removeClass('fixed-mode');
        $('#dragCancelPanel').removeClass('show');
    }
    
    function cancelDrag() {
        if (draggedItem) {
            cleanupAfterDrop();
            showToast('info', 'Drag cancelled');
        }
    }
    
    // ============================================
    // ROOM SELECTION MODAL
    // ============================================
    function showRoomSelectionModal() {
        if (!pendingDropData) return;
        
        let contentHtml = `
            <div class="class-info-preview">
                <div class="row">
                    <div class="col-6"><small class="text-muted">Section</small><div class="fw-bold">${escapeHtml(pendingDropData.section)}</div></div>
                    <div class="col-6"><small class="text-muted">Course</small><div class="fw-bold text-success">${escapeHtml(pendingDropData.courseCode)}</div></div>
                    <div class="col-12 mt-2"><small class="text-muted">Time</small><div>${formatTime(pendingDropData.startTime)} - ${formatTime(pendingDropData.endTime)}</div></div>
                    <div class="col-12 mt-2"><small class="text-muted">Day</small><div>${pendingDropData.day}</div></div>
                </div>
            </div>
            <h6 class="mt-3 mb-2">Select Available Room</h6>
        `;
        
        if (availableRooms.length === 0) {
            contentHtml += `<div class="alert alert-warning">No rooms available.</div>`;
            $('#confirmRoomBtn').prop('disabled', true);
        } else {
            contentHtml += `<div class="room-list">`;
            availableRooms.forEach(room => {
                contentHtml += `
                    <div class="room-card-selection" onclick="AIGenerator.selectRoom(${room.room_id})" data-room-id="${room.room_id}">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="room-name">${escapeHtml(room.name)}</div>
                                <div class="room-capacity">Capacity: ${room.capacity}</div>
                            </div>
                            <div><i class="bi bi-check-circle-fill text-success" style="display: none;"></i></div>
                        </div>
                    </div>
                `;
            });
            contentHtml += `</div>`;
            $('#confirmRoomBtn').prop('disabled', false);
        }
        
        $('#roomSelectionContent').html(contentHtml);
        selectedRoomId = null;
        
        new bootstrap.Modal(document.getElementById('roomSelectionModal')).show();
    }
    
    function selectRoom(roomId) {
        $('.room-card-selection').removeClass('selected').find('.bi-check-circle-fill').hide();
        $(`.room-card-selection[data-room-id="${roomId}"]`).addClass('selected').find('.bi-check-circle-fill').show();
        selectedRoomId = roomId;
    }
    
    function confirmRoomSelection() {
        if (!selectedRoomId) {
            showToast('warning', 'Please select a room');
            return;
        }
        
        if (!pendingDropData) return;
        
        const scheduleData = {
            class_id: pendingDropData.classId,
            room_id: selectedRoomId,
            day: pendingDropData.day,
            start_time: pendingDropData.startTime,
            end_time: pendingDropData.endTime
        };
        
        $.post(API_URL, {
            action: 'save_schedule',
            schedule_data: JSON.stringify(scheduleData)
        }, function(data) {
            if (data.success) {
                showToast('success', `Class scheduled successfully`);
                bootstrap.Modal.getInstance(document.getElementById('roomSelectionModal')).hide();
                loadScheduleData();
                pendingDropData = null;
                selectedRoomId = null;
            } else {
                showToast('error', data.message);
            }
        }, 'json');
    }
    
    // ============================================
    // SCHEDULE ACTIONS
    // ============================================
    function deleteSchedule(event, scheduleId) {
        event.stopPropagation();
        if (confirm('Remove this class from the schedule?')) {
            $.post(API_URL, { action: 'delete_schedule', schedule_id: scheduleId }, function(data) {
                if (data.success) {
                    showToast('success', data.message);
                    loadScheduleData();
                } else {
                    showToast('error', data.message);
                }
            }, 'json');
        }
    }
    
    function editSchedule(event, scheduleId) {
        event.stopPropagation();
        
        let schedule = allSchedules.find(s => s.schedule_id == scheduleId);
        if (!schedule) return;
        
        $('#editClassId').val(schedule.class_id);
        $('#editScheduleId').val(scheduleId);
        $('#editSectionName').html(schedule.section || schedule.course_code);
        $('#editCourseCode').html(schedule.course_code);
        $('#editCourseName').html(schedule.course_name);
        $('#editInstructor').html(schedule.instructor_name);
        $('#editDay').val(schedule.day_of_week);
        $('#editStartTime').val(schedule.start_time.substring(0, 5));
        $('#editEndTime').val(schedule.end_time.substring(0, 5));
        
        $.getJSON('../api/get_rooms.php', function(data) {
            let options = '<option value="">Select Room</option>';
            data.forEach(room => {
                const selected = (room.room_id == schedule.room_id) ? 'selected' : '';
                options += `<option value="${room.room_id}" ${selected}>${room.name} (Capacity: ${room.capacity})</option>`;
            });
            $('#editRoom').html(options);
        });
        
        new bootstrap.Modal(document.getElementById('editScheduleModal')).show();
    }
    
    function saveEditedSchedule() {
        const classId = $('#editClassId').val();
        const roomId = $('#editRoom').val();
        const day = $('#editDay').val();
        const startTime = $('#editStartTime').val() + ':00';
        const endTime = $('#editEndTime').val() + ':00';
        
        if (!roomId) {
            showToast('warning', 'Please select a room');
            return;
        }
        
        const scheduleData = { class_id: classId, room_id: roomId, day: day, start_time: startTime, end_time: endTime };
        
        $.post(API_URL, {
            action: 'save_schedule',
            schedule_data: JSON.stringify(scheduleData)
        }, function(data) {
            if (data.success) {
                showToast('success', data.message);
                bootstrap.Modal.getInstance(document.getElementById('editScheduleModal')).hide();
                loadScheduleData();
            } else {
                showToast('error', data.message);
            }
        }, 'json');
    }
    
    // ============================================
    // SECTION SCHEDULE
    // ============================================
    function showSectionSchedule(section) {
        const semester = currentSemesterFilter.semester;
        const year = currentSemesterFilter.year;
        
        const modal = new bootstrap.Modal(document.getElementById('sectionScheduleModal'));
        $('#modalSectionName').html(`${selectedDepartment ? selectedDepartment.short_name + ' - ' : ''}${section} (${semester} ${year})`);
        $('#sectionScheduleContent').html(`
            <div class="text-center py-5">
                <div class="spinner-border text-success" role="status"></div>
                <p class="mt-2">Loading schedule...</p>
            </div>
        `);
        modal.show();
        
        $.post(API_URL, {
            action: 'get_section_schedule',
            section_name: section,
            department: selectedDepartment ? selectedDepartment.short_name : null,
            semester: semester,
            year: year
        }, function(data) {
            if (data.success) {
                displaySectionSchedule(data, section);
            } else {
                $('#sectionScheduleContent').html(`<div class="alert alert-danger m-4">${data.message || 'Error loading schedule'}</div>`);
            }
        }, 'json').fail(function() {
            $('#sectionScheduleContent').html(`<div class="alert alert-danger m-4">Error loading schedule</div>`);
        });
    }
    
    function displaySectionSchedule(data, section) {
        let html = `
            <div class="p-3 border-bottom bg-light">
                <h5 class="mb-1 fw-bold text-success">${escapeHtml(section)} - Classes</h5>
                <p class="mb-0 text-muted">${data.total_classes} total classes, ${data.scheduled_count} scheduled, ${data.unscheduled_count} unscheduled</p>
            </div>
            <div class="table-responsive p-3">
                <table class="table table-sm table-hover">
                    <thead><tr><th>Course</th><th>Name</th><th>Instructor</th><th>Day</th><th>Time</th><th>Room</th></tr></thead>
                    <tbody>
        `;
        
        data.schedules.forEach(s => {
            html += `<tr>
                <td><strong>${escapeHtml(s.course_code)}</strong></td>
                <td>${escapeHtml(s.course_name)}</td>
                <td>${escapeHtml(s.instructor_name)}</td>
                <td>${s.day_of_week}</td>
                <td>${formatTime(s.start_time)} - ${formatTime(s.end_time)}</td>
                <td>${escapeHtml(s.room_name)}</td>
            </tr>`;
        });
        
        if (data.unscheduled_classes && data.unscheduled_classes.length > 0) {
            html += `<tr><td colspan="6" class="bg-warning bg-opacity-10"><strong>Unscheduled Classes:</strong></td></tr>`;
            data.unscheduled_classes.forEach(cls => {
                html += `<tr class="bg-warning bg-opacity-10">
                    <td><strong>${escapeHtml(cls.course_code)}</strong></td>
                    <td>${escapeHtml(cls.course_name)}</td>
                    <td>${escapeHtml(cls.instructor_name)}</td>
                    <td colspan="3" class="text-warning">Not scheduled</td>
                </tr>`;
            });
        }
        
        html += `</tbody></table></div>`;
        $('#sectionScheduleContent').html(html);
    }
    
    // ============================================
    // SEMESTER FILTER
    // ============================================
    function setSemesterFilter(filterValue) {
        const [year, semesterNum] = filterValue.split('_');
        const semester = semesterNum === '1' ? '1st Semester' : '2nd Semester';
        
        currentSemesterFilter = { year, semester };
        
        $('.filter-btn').removeClass('active');
        $(`#filter_${filterValue}`).addClass('active');
        
        const nextYear = parseInt(year) + 1;
        $('#currentFilterDisplay').html(`<i class="bi bi-eye me-1"></i> Viewing: ${year}-${nextYear} - ${semester}`);
        
        $('#semesterSelect').val(semester);
        $('#yearSelect').val(year);
        
        if (selectedDepartment) {
            selectedDepartment = null;
            renderDepartmentButtons();
            $('#deptHeader').hide();
            $('#sectionButtonsContainer').hide();
        }
        
        loadScheduleData();
        showToast('info', `Switched to ${semester}, ${year}-${nextYear}`);
    }
    
    function updateFilterDisplay() {
        const semesterNum = currentSemesterFilter.semester === '1st Semester' ? '1' : '2';
        const filterValue = `${currentSemesterFilter.year}_${semesterNum}`;
        $('.filter-btn').removeClass('active');
        $(`#filter_${filterValue}`).addClass('active');
        const nextYear = parseInt(currentSemesterFilter.year) + 1;
        $('#currentFilterDisplay').html(`<i class="bi bi-eye me-1"></i> Viewing: ${currentSemesterFilter.year}-${nextYear} - ${currentSemesterFilter.semester}`);
    }
    
    // ============================================
    // STATS
    // ============================================
    function updateStats(data) {
        $('#totalClassesCount').text(data.total_classes || 0);
        $('#scheduledCount').text(data.scheduled_count || 0);
        $('#conflictCount').text(data.conflict_count || 0);
        $('#utilizationRate').text(data.utilization || '0%');
    }
    
    // ============================================
    // PUBLISH & EXPORT
    // ============================================
    function openPublishModal() {
        const scheduledCount = $('.schedule-block').length;
        $('#publishStats').text(`${scheduledCount} schedules will be published`);
        new bootstrap.Modal(document.getElementById('publishModal')).show();
    }
    
    function publishSchedule() {
        $.post(API_URL, { action: 'publish_schedule', schedule_id: 'all' }, function(data) {
            if (data.success) {
                showToast('success', data.message);
                bootstrap.Modal.getInstance(document.getElementById('publishModal')).hide();
            } else {
                showToast('error', data.message);
            }
        }, 'json');
    }
    
    function exportSchedule() {
        const html = $('#timetable').prop('outerHTML');
        const printWindow = window.open('', '_blank');
        printWindow.document.write(`
            <html><head><title>Class Timetable</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="../assets/css/ai_generator.css">
            <style>.schedule-delete, .schedule-edit { display: none; }</style>
            </head><body><div class="container mt-4">${html}</div></body></html>
        `);
        printWindow.document.close();
        printWindow.print();
    }
    
    // ============================================
    // AI FUNCTIONS
    // ============================================
    function openAIModal() {
        if (!aiModalInstance) {
            aiModalInstance = new bootstrap.Modal(document.getElementById('aiModal'));
        }
        aiModalInstance.show();
    }
    
    function exportDataForAI() {
        const semester = currentSemesterFilter.semester;
        const year = currentSemesterFilter.year;
        const $exportBtn = $('#exportAIBtn');
        
        $exportBtn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span>Exporting...');
        
        $.post(API_URL, { action: 'export_data', semester, year }, function(data) {
            if (data.success) {
                exportedData = data.data;
                displayExportedDataForAI();
                $('#exportedDataDisplay').show();
                showToast('success', 'Data exported successfully!');
            } else {
                showToast('error', data.message || 'Error exporting data');
            }
            $exportBtn.prop('disabled', false).html('<i class="bi bi-download me-2"></i>Export Data');
        }, 'json');
    }
    
    function displayExportedDataForAI() {
        if (!exportedData) return;
        
        let dataText = "SCHEDULE GENERATION DATA\n" + "=".repeat(60) + "\n\n";
        dataText += "COURSES DATA\n" + "-".repeat(40) + "\n";
        exportedData.courses.forEach(c => {
            dataText += `${c.course_code} | ${c.course_name} | ${c.credits} | Lab: ${c.requires_lab} | Year ${c.year_level} | Section ${c.section}\n`;
        });
        
        dataText += "\nROOMS DATA\n" + "-".repeat(40) + "\n";
        exportedData.rooms.forEach(r => {
            dataText += `${r.name} | ${r.room_type} | Capacity: ${r.capacity}\n`;
        });
        
        dataText += "\nINSTRUCTORS DATA\n" + "-".repeat(40) + "\n";
        exportedData.instructors.forEach(i => {
            dataText += `${i.first_name} ${i.last_name} | ${i.position}\n`;
        });
        
        $('#exportedDataContent').text(dataText);
    }
    
    function copyExportedData() {
        const dataText = $('#exportedDataContent').text();
        navigator.clipboard.writeText(dataText).then(() => {
            showToast('success', 'Data copied to clipboard!');
        });
    }
    
    function copyFullPrompt() {
        const dataText = $('#exportedDataContent').text();
        const promptText = $('#promptTemplateText').text();
        const fullPrompt = promptText.replace('[PASTE_EXPORTED_DATA_HERE]', dataText);
        
        navigator.clipboard.writeText(fullPrompt).then(() => {
            showToast('success', 'Full prompt copied!');
        });
    }
    
    function processAIResponse() {
        const responseText = $('#aiResponse').val().trim();
        
        if (!responseText) {
            showToast('warning', 'Please paste the AI response first.');
            return;
        }
        
        const $processBtn = $('#processAIBtn');
        $processBtn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span>Processing...');
        
        try {
            let parsed = JSON.parse(responseText);
            let scheduleArray = parsed.schedules || (Array.isArray(parsed) ? parsed : null);
            
            if (!scheduleArray) throw new Error('Invalid format');
            
            $.post(API_URL, {
                action: 'import_schedule',
                schedule_data: JSON.stringify({schedules: scheduleArray}),
                semester: currentSemesterFilter.semester,
                year: currentSemesterFilter.year
            }, function(data) {
                if (data.success) {
                    aiPreviewData = data;
                    displayAIPreview(data);
                    $('#aiStep4').show();
                    showToast('success', data.message);
                } else {
                    showToast('error', data.message);
                }
                $processBtn.prop('disabled', false).html('<i class="bi bi-magic me-2"></i>Process & Preview');
            }, 'json');
            
        } catch (e) {
            showToast('error', 'Error parsing JSON: ' + e.message);
            $processBtn.prop('disabled', false).html('<i class="bi bi-magic me-2"></i>Process & Preview');
        }
    }
    
    function displayAIPreview(data) {
        let statsHtml = `
            <div class="col-md-3"><div class="stats-card"><div class="stats-number">${data.stats.total}</div><small>Total</small></div></div>
            <div class="col-md-3"><div class="stats-card"><div class="stats-number">${data.stats.warnings}</div><small>Warnings</small></div></div>
            <div class="col-md-3"><div class="stats-card"><div class="stats-number">${data.stats.errors || 0}</div><small>Errors</small></div></div>
        `;
        $('#aiPreviewStats').html(statsHtml);
        
        let alertsHtml = '';
        if (data.warnings && data.warnings.length > 0) {
            alertsHtml += `<div class="alert alert-warning"><ul>${data.warnings.map(w => `<li>${escapeHtml(w)}</li>`).join('')}</ul></div>`;
        }
        if (data.errors && data.errors.length > 0) {
            alertsHtml += `<div class="alert alert-danger"><ul>${data.errors.map(e => `<li>${escapeHtml(e)}</li>`).join('')}</ul></div>`;
        }
        $('#aiPreviewAlerts').html(alertsHtml);
        
        let tableHtml = '';
        data.preview_schedules.forEach(s => {
            tableHtml += `
                <tr>
                    <td>${escapeHtml(s.section)}</td>
                    <td>${escapeHtml(s.course_code)}</td>
                    <td>${escapeHtml(s.day_of_week)}</td>
                    <td>${formatTime(s.start_time)}</td>
                    <td>${formatTime(s.end_time)}</td>
                    <td>${escapeHtml(s.room_name)}</td>
                    <td>${escapeHtml(s.instructor_name)}</td>
                </tr>
            `;
        });
        $('#aiPreviewBody').html(tableHtml);
    }
    
    function saveAISchedule() {
        if (!aiPreviewData || !aiPreviewData.preview_schedules) {
            showToast('warning', 'No schedule to save.');
            return;
        }
        
        const replaceExisting = $('#replaceExistingAI').is(':checked');
        
        if (!confirm(`Save ${aiPreviewData.preview_schedules.length} schedules?`)) return;
        
        const $saveBtn = $('#saveAIBtn');
        $saveBtn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span>Saving...');
        
        $.post(API_URL, {
            action: 'save_imported_schedule',
            schedule_data: JSON.stringify(aiPreviewData.preview_schedules),
            replace_existing: replaceExisting,
            semester: currentSemesterFilter.semester,
            year: currentSemesterFilter.year
        }, function(data) {
            $saveBtn.prop('disabled', false).html('Save to Database');
            
            if (data.success) {
                showToast('success', data.message);
                if (aiModalInstance) aiModalInstance.hide();
                aiPreviewData = null;
                $('#aiStep4').hide();
                $('#aiResponse').val('');
                loadScheduleData();
            } else {
                showToast('error', data.message);
            }
        }, 'json');
    }
    
    function resetAIModal() {
        if (aiModalInstance) aiModalInstance.hide();
        $('#aiResponse').val('');
        $('#aiStep4').hide();
        $('#exportedDataDisplay').hide();
        aiPreviewData = null;
    }
    
    // ============================================
    // UTILITY FUNCTIONS
    // ============================================
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
    
    function showToast(type, message) {
        const bgClass = type === 'success' ? 'bg-success' : (type === 'warning' ? 'bg-warning' : 'bg-danger');
        const icon = type === 'success' ? 'check-circle' : 'exclamation-triangle';
        const title = type === 'success' ? 'Success' : (type === 'warning' ? 'Warning' : 'Error');
        
        const toastEl = $(`
            <div class="toast show" role="alert" style="position: fixed; bottom: 20px; right: 20px; z-index: 9999;">
                <div class="toast-header ${bgClass} text-white">
                    <i class="bi bi-${icon} me-2"></i>
                    <strong class="me-auto">${title}</strong>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
                </div>
                <div class="toast-body">${message}</div>
            </div>
        `);
        
        $('body').append(toastEl);
        setTimeout(() => toastEl.remove(), 3000);
    }
    
    // ============================================
    // PUBLIC API
    // ============================================
    return {
        init,
        setSemesterFilter,
        selectDepartment,
        showSectionSchedule,
        openAIModal,
        exportDataForAI,
        copyExportedData,
        copyFullPrompt,
        processAIResponse,
        saveAISchedule,
        resetAIModal,
        deleteSchedule,
        editSchedule,
        saveEditedSchedule,
        scheduleUnscheduledClass,
        selectRoom,
        confirmRoomSelection,
        cancelDrag,
        openPublishModal,
        publishSchedule,
        exportSchedule
    };
})();

// Initialize on document ready
$(document).ready(function() {
    AIGenerator.init();
});