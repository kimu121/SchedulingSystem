<?php
// pages/ai_generator.php - Schedule Generator (AI removed, drag-drop kept)
require_once '../api/config.php';

$page_title = 'Schedule Generator -  Scheduling System';
$extra_css = '<link rel="stylesheet" href="../assets/css/ai_generator.css">';
$extra_js = '<script src="../assets/js/schedule_generator.js"></script>';

include '../includes/header.php';
include '../includes/navbar.php';
?>

<div class="container-fluid px-4">
    <div class="page-header mt-4">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h2><i class="bi bi-calendar-week me-2 text-success"></i>Drag & Drop Scheduling</h2>
                <p class="text-muted mb-0">Drag and drop classes to schedule them - Automatic conflict detection</p>
            </div>
            <div class="col-md-4 text-md-end mt-3 mt-md-0">
                <button class="btn btn-primary-custom" onclick="ScheduleGenerator.openPublishModal()">
                    <i class="bi bi-send me-2"></i>Publish Schedule
                </button>
                <button class="btn btn-outline-success ms-2" onclick="ScheduleGenerator.exportSchedule()">
                    <i class="bi bi-download me-2"></i>Export
                </button>
            </div>
        </div>
    </div>

    <div class="control-card card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-gear me-2"></i>Schedule Controls</h5>
        </div>
        <div class="card-body">
            <div class="row g-4">
                <div class="col-md-3">
                    <label class="form-label fw-bold">Semester</label>
                    <select id="semesterSelect" class="form-select">
                        <option value="1st Semester">1st Semester</option>
                        <option value="2nd Semester">2nd Semester</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">Academic Year</label>
                    <select id="yearSelect" class="form-select">
                        <option value="2025">2025-2026</option>
                        <option value="2026" selected>2026-2027</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">Operating Hours</label>
                    <div class="d-flex gap-2">
                        <input type="number" id="startHour" class="form-control" value="8" min="6" max="12">
                        <span class="align-self-center">to</span>
                        <input type="number" id="endHour" class="form-control" value="20" min="12" max="23">
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Semester/Year Filter Bar -->
    <div class="semester-filter-bar">
        <div class="filter-buttons">
            <button class="filter-btn" onclick="ScheduleGenerator.setSemesterFilter('2025_1')" id="filter_2025_1">
                <i class="bi bi-calendar"></i> 2025-2026 - 1st Sem
            </button>
            <button class="filter-btn" onclick="ScheduleGenerator.setSemesterFilter('2025_2')" id="filter_2025_2">
                <i class="bi bi-calendar"></i> 2025-2026 - 2nd Sem
            </button>
            <button class="filter-btn active" onclick="ScheduleGenerator.setSemesterFilter('2026_1')" id="filter_2026_1">
                <i class="bi bi-calendar"></i> 2026-2027 - 1st Sem
            </button>
            <button class="filter-btn" onclick="ScheduleGenerator.setSemesterFilter('2026_2')" id="filter_2026_2">
                <i class="bi bi-calendar"></i> 2026-2027 - 2nd Sem
            </button>
        </div>
        <div class="filter-info">
            <span class="badge bg-success bg-opacity-25 text-dark" id="currentFilterDisplay">
                <i class="bi bi-eye me-1"></i> Viewing: 2026-2027 - 1st Semester
            </span>
            <span class="badge bg-success bg-opacity-25 text-dark" id="scheduleCountBadge">
                <i class="bi bi-calendar-check me-1"></i> 0 schedules
            </span>
        </div>
    </div>
    
    <!-- Department Buttons -->
    <div class="dept-buttons" id="deptButtons"></div>
    
    <!-- Department Header -->
    <div id="deptHeader" style="display: none;">
        <div class="dept-header">
            <div>
                <h4 id="deptHeaderTitle"><i class="bi bi-building me-2"></i>Department Schedule</h4>
                <p class="text-muted mb-0" id="deptHeaderDesc">Viewing all class schedules</p>
            </div>
            <div class="dept-stats" id="deptHeaderStats"></div>
        </div>
    </div>
    
    <!-- Section Buttons -->
    <div id="sectionButtonsContainer" style="display: none;">
        <div class="section-buttons" id="sectionButtons"></div>
    </div>
    
    <div class="row g-4 mb-4" id="statsRow">
        <div class="col-md-3">
            <div class="stats-card">
                <i class="bi bi-calendar-check fs-1 text-success"></i>
                <div class="stats-number" id="totalClassesCount">0</div>
                <div class="text-muted">Total Classes</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card">
                <i class="bi bi-check-circle fs-1 text-success"></i>
                <div class="stats-number" id="scheduledCount">0</div>
                <div class="text-muted">Scheduled</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card">
                <i class="bi bi-exclamation-triangle fs-1 text-warning"></i>
                <div class="stats-number" id="conflictCount">0</div>
                <div class="text-muted">Conflicts</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card">
                <i class="bi bi-building fs-1 text-success"></i>
                <div class="stats-number" id="utilizationRate">0%</div>
                <div class="text-muted">Room Utilization</div>
            </div>
        </div>
    </div>

    <!-- Timetable Container -->
    <div class="timetable-container" id="timetableContainer">
        <table class="timetable" id="timetable">
            <thead id="timetableHeader"></thead>
            <tbody id="timetableBody"></tbody>
        </table>
    </div>

    <!-- Unscheduled Classes Container -->
    <div class="unscheduled-container" id="unscheduledContainer" style="display: none;">
        <h5 class="mb-3"><i class="bi bi-clock-history me-2 text-warning"></i>Unscheduled Classes</h5>
        <div id="unscheduledList"></div>
    </div>
</div>

<!-- Drag Cancel Panel -->
<div id="dragCancelPanel" class="drag-cancel-panel">
    <i class="bi bi-arrow-repeat"></i>
    <span>Dragging class</span>
    <button class="btn-cancel-drag" onclick="ScheduleGenerator.cancelDrag()">
        <i class="bi bi-x-lg me-1"></i>Cancel
    </button>
</div>

<!-- Room Selection Modal -->
<div class="modal fade" id="roomSelectionModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-door-open me-2"></i>Select Room</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body"><div id="roomSelectionContent"></div></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary-custom" id="confirmRoomBtn" onclick="ScheduleGenerator.confirmRoomSelection()">Confirm</button>
            </div>
        </div>
    </div>
</div>

<!-- Edit Schedule Modal -->
<div class="modal fade" id="editScheduleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Edit Schedule</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editClassId"><input type="hidden" id="editScheduleId">
                <div class="class-info-preview">
                    <div class="row">
                        <div class="col-6"><small class="text-muted">Section</small><div class="fw-bold" id="editSectionName">-</div></div>
                        <div class="col-6"><small class="text-muted">Course</small><div class="fw-bold text-success" id="editCourseCode">-</div></div>
                        <div class="col-12 mt-2"><small class="text-muted">Course Name</small><div id="editCourseName">-</div></div>
                        <div class="col-6 mt-2"><small class="text-muted">Instructor</small><div id="editInstructor">-</div></div>
                    </div>
                </div>
                <div class="mb-3"><label class="form-label">Day</label>
                    <select id="editDay" class="form-select">
                        <option>Monday</option><option>Tuesday</option><option>Wednesday</option>
                        <option>Thursday</option><option>Friday</option><option>Saturday</option>
                    </select>
                </div>
                <div class="row">
                    <div class="col-md-6"><label class="form-label">Start</label><input type="time" id="editStartTime" class="form-control" step="1800"></div>
                    <div class="col-md-6"><label class="form-label">End</label><input type="time" id="editEndTime" class="form-control" step="1800"></div>
                </div>
                <div class="mb-3 mt-3"><label class="form-label">Room</label><select id="editRoom" class="form-select"></select></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary-custom" onclick="ScheduleGenerator.saveEditedSchedule()">Save</button>
            </div>
        </div>
    </div>
</div>

<!-- Section Schedule Modal -->
<div class="modal fade" id="sectionScheduleModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-calendar-week me-2"></i>Section: <span id="modalSectionName"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="sectionScheduleContent"></div>
        </div>
    </div>
</div>

<!-- Publish Modal -->
<div class="modal fade" id="publishModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-send me-2"></i>Publish Schedule</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Publish the current schedule?</p>
                <div class="alert alert-info"><span id="publishStats">0 schedules</span></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary-custom" onclick="ScheduleGenerator.publishSchedule()">Publish</button>
            </div>
        </div>
    </div>
</div>

<?php include '../includes/footer.php'; ?>