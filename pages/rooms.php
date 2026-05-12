<?php
// pages/rooms.php - View rooms and their schedules
require_once '../api/config.php';

$page_title = 'Rooms - Scheduling System';
$filter_building = isset($_GET['building']) ? $_GET['building'] : '';
$filter_capacity = isset($_GET['capacity']) ? $_GET['capacity'] : '';

include '../includes/header.php';
include '../includes/navbar.php';
?>

<div class="container-fluid px-4">
    <!-- Page Header -->
    <div class="page-header mt-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2><i class="bi bi-door-open-fill me-2"></i>Rooms & Facilities</h2>
                <p class="text-muted">View room details, capacity, and schedule (8:00 AM - 8:00 PM)</p>
            </div>
            <div class="text-muted">
                <i class="bi bi-calendar3 me-2 text-success"></i><?php echo date('l, F d, Y'); ?>
            </div>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <form method="GET" class="row g-3 align-items-end">
            <div class="col-md-3">
                <label class="form-label">Building</label>
                <select name="building" class="form-select">
                    <option value="">All Buildings</option>
                    <option value="Main" <?php echo $filter_building == 'Main' ? 'selected' : ''; ?>>Main Building</option>
                    <option value="Science" <?php echo $filter_building == 'Science' ? 'selected' : ''; ?>>Science Building</option>
                    <option value="Engineering" <?php echo $filter_building == 'Engineering' ? 'selected' : ''; ?>>Engineering Building</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">Min. Capacity</label>
                <select name="capacity" class="form-select">
                    <option value="">Any</option>
                    <option value="30" <?php echo $filter_capacity == '30' ? 'selected' : ''; ?>>30+ persons</option>
                    <option value="50" <?php echo $filter_capacity == '50' ? 'selected' : ''; ?>>50+ persons</option>
                    <option value="100" <?php echo $filter_capacity == '100' ? 'selected' : ''; ?>>100+ persons</option>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">Search</label>
                <input type="text" name="search" class="form-control" placeholder="Search rooms...">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary-custom w-100">
                    <i class="bi bi-funnel me-2"></i>Filter
                </button>
            </div>
        </form>
    </div>

    <!-- Rooms Grid -->
    <div class="row g-4">
        <?php
        $query = "SELECT * FROM rooms";
        $conditions = [];
        
        if (!empty($filter_building)) {
            $conditions[] = "location LIKE '%$filter_building%'";
        }
        if (!empty($filter_capacity)) {
            $conditions[] = "capacity >= $filter_capacity";
        }
        
        if (!empty($conditions)) {
            $query .= " WHERE " . implode(" AND ", $conditions);
        }
        
        $query .= " ORDER BY name";
        $result = $conn->query($query);
        
        if ($result->num_rows > 0) {
            while($room = $result->fetch_assoc()) {
                $today = date('l');
                $schedule_query = "SELECT s.*, c.course_code, c.name as course_name,
                                          CONCAT(e.first_name, ' ', e.last_name) as instructor
                                   FROM schedule s
                                   JOIN classes cl ON s.class_id = cl.class_id
                                   JOIN courses c ON cl.course_id = c.course_id
                                   JOIN employees e ON cl.instructor_id = e.employee_id
                                   WHERE s.room_id = {$room['room_id']}
                                   AND s.day_of_week = '$today'
                                   ORDER BY s.start_time";
                $schedule_result = $conn->query($schedule_query);
                
                $total_slots = 8;
                $occupied_slots = $schedule_result->num_rows;
                $occupancy_rate = $total_slots > 0 ? round(($occupied_slots / $total_slots) * 100) : 0;
                
                $building_parts = explode(' ', $room['location']);
                $building = $building_parts[0];
                ?>
                <div class="col-xl-6">
                    <div class="room-card card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-door-open me-2"></i><?php echo $room['name']; ?></h5>
                            <span class="building-tag"><i class="bi bi-building me-1"></i><?php echo $building; ?></span>
                        </div>
                        <div class="card-body">
                            <div class="room-details">
                                <div class="room-detail-item">
                                    <i class="bi bi-geo-alt"></i>
                                    <span class="label">Location</span>
                                    <span class="value"><?php echo $room['location']; ?></span>
                                </div>
                                <div class="room-detail-item">
                                    <i class="bi bi-people"></i>
                                    <span class="label">Capacity</span>
                                    <span class="value"><?php echo $room['capacity']; ?></span>
                                </div>
                                <div class="room-detail-item">
                                    <i class="bi bi-graph-up"></i>
                                    <span class="label">Occupancy</span>
                                    <span class="value"><?php echo $occupancy_rate; ?>%</span>
                                </div>
                            </div>
                            
                            <div class="occupancy-bar">
                                <div class="occupancy-fill" style="width: <?php echo $occupancy_rate; ?>%;"></div>
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h6 class="mb-0"><i class="bi bi-calendar-day me-2 text-success"></i>Today's Schedule</h6>
                                <small class="text-muted"><?php echo date('l'); ?></small>
                            </div>
                            
                            <div class="schedule-list mb-3">
                                <?php
                                if ($schedule_result->num_rows > 0) {
                                    while($schedule_row = $schedule_result->fetch_assoc()) {
                                        $start_time = DateTime::createFromFormat('H:i:s', $schedule_row['start_time']);
                                        $end_time = DateTime::createFromFormat('H:i:s', $schedule_row['end_time']);
                                        ?>
                                        <div class="schedule-item">
                                            <div class="schedule-time">
                                                <i class="bi bi-clock me-1"></i><?php echo $start_time->format('h:i A') . ' - ' . $end_time->format('h:i A'); ?>
                                            </div>
                                            <div class="schedule-course"><i class="bi bi-book me-1 text-success"></i><?php echo $schedule_row['course_code'] . ' - ' . $schedule_row['course_name']; ?></div>
                                            <div class="schedule-instructor"><i class="bi bi-person me-1 text-success"></i><?php echo $schedule_row['instructor']; ?></div>
                                        </div>
                                        <?php
                                    }
                                } else {
                                    echo '<div class="empty-schedule"><i class="bi bi-calendar-x"></i><p class="mb-0">No classes scheduled for today</p></div>';
                                }
                                ?>
                            </div>
                            
                            <a href="schedule.php?view=room&id=<?php echo $room['room_id']; ?>" class="btn-view">
                                <i class="bi bi-calendar-week me-2"></i>View Full Schedule
                            </a>
                        </div>
                    </div>
                </div>
                <?php
            }
        } else {
            echo '<div class="col-12 text-center py-5"><i class="bi bi-door-open display-1 text-success mb-3"></i><h5 class="text-muted">No Rooms Found</h5></div>';
        }
        ?>
    </div>
</div>

<style>
.room-card {
    border: none;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(46, 125, 50, 0.1);
    height: 100%;
}

.room-card .card-header {
    background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
    color: white;
    padding: 1.2rem;
}

.room-details {
    display: flex;
    gap: 1.5rem;
    margin-bottom: 1.5rem;
    padding: 1rem;
    background: #f1f8e9;
    border-radius: 15px;
}

.room-detail-item {
    text-align: center;
    flex: 1;
}

.room-detail-item i {
    font-size: 1.2rem;
    color: var(--primary-color);
}

.room-detail-item .label {
    font-size: 0.7rem;
    color: #6c757d;
    display: block;
}

.room-detail-item .value {
    font-weight: 600;
    color: var(--primary-dark);
}

.building-tag {
    display: inline-block;
    padding: 0.3rem 1rem;
    background-color: rgba(255,255,255,0.2);
    color: white;
    border-radius: 20px;
    font-size: 0.8rem;
}

.schedule-list {
    max-height: 300px;
    overflow-y: auto;
    border-radius: 15px;
    border: 1px solid #e8f5e9;
}

.schedule-item {
    padding: 0.8rem 1rem;
    border-bottom: 1px solid #e8f5e9;
}

.schedule-item:last-child {
    border-bottom: none;
}

.schedule-item:hover {
    background-color: #f1f8e9;
}

.schedule-time {
    font-size: 0.8rem;
    color: var(--primary-color);
    font-weight: 500;
}

.schedule-course {
    font-weight: 600;
    color: var(--primary-dark);
}

.schedule-instructor {
    font-size: 0.8rem;
    color: #6c757d;
}

.occupancy-bar {
    height: 8px;
    background-color: #e8f5e9;
    border-radius: 10px;
    margin: 1rem 0;
}

.occupancy-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--primary-color), var(--primary-light));
    border-radius: 10px;
}

.btn-view {
    background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
    color: white;
    border-radius: 12px;
    padding: 0.6rem 1rem;
    font-weight: 500;
    text-decoration: none;
    display: block;
    text-align: center;
}

.btn-view:hover {
    background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-color) 100%);
    color: white;
}

.empty-schedule {
    text-align: center;
    padding: 2rem;
    color: #6c757d;
}
</style>

<?php include '../includes/footer.php'; ?>