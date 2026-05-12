<?php
// pages/schedule.php - View instructor and facility schedules
require_once '../api/config.php';

$page_title = 'Schedule View - Scheduling System';
$view_type = isset($_GET['view']) ? $_GET['view'] : 'instructor';
$selected_dept = isset($_GET['dept']) ? $_GET['dept'] : 'all';

include '../includes/header.php';
include '../includes/navbar.php';
?>

<div class="container-fluid px-4">
    <!-- Page Header -->
    <div class="page-header mt-4">
        <div class="d-flex justify-content-between align-items-center flex-wrap">
            <div>
                <h2><i class="bi bi-calendar-week me-2"></i>Weekly Schedule View</h2>
                <p class="text-muted">View full weekly timetable (Monday to Sunday, 8:00 AM - 8:00 PM)</p>
            </div>
            <div class="text-muted">
                <i class="bi bi-calendar3 me-2 text-success"></i>1st Semester 2025
            </div>
        </div>
    </div>

    <!-- View Toggle -->
    <div class="d-flex justify-content-center mb-4">
        <div class="view-toggle">
            <button class="btn <?php echo $view_type == 'instructor' ? 'active' : ''; ?>" id="viewInstructorBtn">
                <i class="bi bi-person-badge me-2"></i>Instructors
            </button>
            <button class="btn <?php echo $view_type == 'room' ? 'active' : ''; ?>" id="viewRoomBtn">
                <i class="bi bi-building me-2"></i>Facilities
            </button>
        </div>
    </div>

    <!-- Department Filter Bar -->
    <div class="dept-filter-bar">
        <div class="dept-buttons" id="deptButtonsContainer">
            <!-- Department buttons will be rendered by JavaScript -->
        </div>
        <div class="d-flex gap-2">
            <div class="search-box">
                <i class="bi bi-search text-success me-2"></i>
                <input type="text" id="entitySearch" placeholder="Search..." autocomplete="off">
            </div>
        </div>
    </div>

    <!-- Entity List Header -->
    <div class="row mb-4">
        <div class="col-md-8">
            <h5 class="mb-3">
                <i class="bi bi-people me-2 text-success" id="entityTypeIcon"></i>
                View <span id="entityTypeLabel">Instructor</span>
                <span class="badge-count ms-2" id="entityCount">0 total</span>
            </h5>
        </div>
    </div>

    <!-- Entity Cards Container -->
    <div class="row g-3 mb-4" id="entityList">
        <div class="col-12 text-center py-5">
            <div class="spinner-border text-success" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2 text-muted">Loading entities...</p>
        </div>
    </div>
</div>

<!-- Schedule Modal -->
<div class="modal fade schedule-modal" id="scheduleModal" tabindex="-1" data-bs-backdrop="static">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <div>
                    <h4 class="modal-title" id="modalTitle">
                        <i class="bi bi-calendar-week me-2"></i>
                        <span id="entityName"></span>
                    </h4>
                    <p class="mb-0 small opacity-75" id="entitySubtitle"></p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="entity-info" id="entityInfo"></div>
                <div class="full-week-container" id="fullWeekContainer">
                    <div id="timetableContent"></div>
                </div>
                <div class="summary-stats" id="summaryStats"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-lg me-2"></i>Close
                </button>
                <button type="button" class="btn btn-primary-custom" onclick="window.print()">
                    <i class="bi bi-printer me-2"></i>Print
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Entity Card Template -->
<template id="instructorCardTemplate">
    <div class="col-xl-3 col-lg-4 col-md-6 entity-item" data-name="" data-detail="" data-department="">
        <div class="entity-card card">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="entity-avatar"></div>
                    <div class="flex-grow-1">
                        <h6 class="mb-1"></h6>
                        <small class="text-muted"></small>
                        <span class="dept-badge"></span>
                    </div>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="badge bg-success bg-opacity-25 text-dark classes-badge"></span>
                    <span class="badge bg-success bg-opacity-25 text-dark sessions-badge"></span>
                </div>
                <button class="btn-view-schedule w-100 view-schedule-btn">
                    <i class="bi bi-calendar-week me-2"></i>View Full Week Timetable
                </button>
            </div>
        </div>
    </div>
</template>

<template id="roomCardTemplate">
    <div class="col-xl-3 col-lg-4 col-md-6 entity-item" data-name="" data-detail="" data-department="">
        <div class="entity-card card">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="entity-icon"><i class="bi bi-building"></i></div>
                    <div class="flex-grow-1">
                        <h6 class="mb-1"></h6>
                        <small class="text-muted"></small>
                        <span class="dept-badge"></span>
                    </div>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="badge bg-success bg-opacity-25 text-dark capacity-badge"></span>
                    <span class="badge bg-success bg-opacity-25 text-dark schedules-badge"></span>
                </div>
                <button class="btn-view-schedule w-100 view-schedule-btn">
                    <i class="bi bi-calendar-week me-2"></i>View Full Week Timetable
                </button>
            </div>
        </div>
    </div>
</template>

<!-- CSS -->
<link rel="stylesheet" href="../assets/css/schedule.css">

<!-- JavaScript -->
<script src="../assets/js/schedule.js"></script>

<script>
// Initialize with PHP values
document.addEventListener('DOMContentLoaded', function() {
    ScheduleApp.init({
        viewType: '<?php echo $view_type; ?>',
        department: '<?php echo $selected_dept; ?>'
    });
});
</script>

<?php include '../includes/footer.php'; ?>