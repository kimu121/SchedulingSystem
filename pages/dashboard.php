<?php
// pages/dashboard.php - Dashboard page
require_once './api/config.php';

$page_title = 'Dashboard -  Scheduling System';

// Get statistics
$schedule_count = $conn->query("SELECT COUNT(*) as count FROM schedule")->fetch_assoc()['count'];
$reservation_count = $conn->query("SELECT COUNT(*) as count FROM reservations")->fetch_assoc()['count'];
$room_count = $conn->query("SELECT COUNT(*) as count FROM rooms")->fetch_assoc()['count'];
$pending_reservations = $conn->query("SELECT COUNT(*) as count FROM reservations WHERE status='Pending'")->fetch_assoc()['count'];
$total_capacity = $conn->query("SELECT SUM(capacity) as total FROM rooms")->fetch_assoc()['total'];

include '../includes/header.php';
include '../includes/navbar.php';
?>

<div class="container-fluid px-4">
    <!-- Page Header -->
    <div class="page-header mt-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2><i class="bi bi-grid-3x3-gap-fill me-2"></i>Dashboard</h2>
                <p class="text-muted">Welcome back! Here's what's happening with your academic schedule today.</p>
            </div>
            <div class="text-muted">
                <i class="bi bi-calendar3 me-2"></i><?php echo date('l, F d, Y'); ?>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-4">
        <div class="col-xl-4 col-md-6">
            <div class="stats-card">
                <i class="bi bi-calendar-week fs-1 text-success"></i>
                <div class="stats-number"><?php echo number_format($schedule_count); ?></div>
                <div class="text-muted">Total Classes</div>
                <small class="text-success">Active this semester</small>
            </div>
        </div>
        
        <div class="col-xl-4 col-md-6">
            <div class="stats-card">
                <i class="bi bi-bookmark-check fs-1 text-success"></i>
                <div class="stats-number"><?php echo number_format($reservation_count); ?></div>
                <div class="text-muted">Reservations</div>
                <small class="text-warning"><?php echo $pending_reservations; ?> awaiting approval</small>
            </div>
        </div>
        
        <div class="col-xl-4 col-md-6">
            <div class="stats-card">
                <i class="bi bi-building fs-1 text-success"></i>
                <div class="stats-number"><?php echo number_format($room_count); ?></div>
                <div class="text-muted">Facilities</div>
                <small class="text-muted">Total capacity: <?php echo $total_capacity; ?></small>
            </div>
        </div>
        <!-- REMOVED: Resources card -->
    </div>

    <!-- Quick Generate Button -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="content-card card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="mb-1"><i class="bi bi-magic text-success me-2"></i>Need to regenerate schedules?</h6>
                            <p class="text-muted small mb-0">Generate complete semester schedules including classes and exams</p>
                        </div>
                        <a href="ai_generator.php" class="btn btn-primary-custom">
                            <i class="bi bi-arrow-repeat me-2"></i>Assign Schedule
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Access Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="content-card card" onclick="window.location.href='schedule.php?view=instructor'" style="cursor: pointer;">
                <div class="card-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-success bg-opacity-10 p-3 rounded">
                            <i class="bi bi-person-badge fs-3 text-success"></i>
                        </div>
                        <div>
                            <h5 class="mb-1">Instructor Schedules</h5>
                            <p class="text-muted mb-2">View weekly schedules by instructor</p>
                            <span class="badge bg-success">Click to view →</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="content-card card" onclick="window.location.href='schedule.php?view=room'" style="cursor: pointer;">
                <div class="card-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-success bg-opacity-10 p-3 rounded">
                            <i class="bi bi-building fs-3 text-success"></i>
                        </div>
                        <div>
                            <h5 class="mb-1">Facility Schedules</h5>
                            <p class="text-muted mb-2">View facility availability and schedules</p>
                            <span class="badge bg-success">Click to view →</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Today's Schedule and Pending Reservations -->
    <div class="row g-4 mt-2">
        <div class="col-lg-8">
            <div class="content-card card">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">
                        <i class="bi bi-calendar-day text-success me-2"></i>
                        Today's Schedule
                    </h5>
                    <span class="badge bg-success bg-opacity-25 text-dark">
                        <i class="bi bi-clock me-1"></i><?php echo date('l, M d'); ?>
                    </span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Time</th>
                                    <th>Course</th>
                                    <th>Facility</th>
                                    <th>Instructor</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                $today = date('l');
                                $query = "SELECT s.*, c.course_code, c.name as course_name, 
                                                 r.name as room_name, 
                                                 CONCAT(e.first_name, ' ', e.last_name) as instructor_name
                                          FROM schedule s
                                          JOIN classes cl ON s.class_id = cl.class_id
                                          JOIN courses c ON cl.course_id = c.course_id
                                          JOIN rooms r ON s.room_id = r.room_id
                                          JOIN employees e ON cl.instructor_id = e.employee_id
                                          WHERE s.day_of_week = '$today'
                                          ORDER BY s.start_time
                                          LIMIT 5";
                                $result = $conn->query($query);
                                
                                if ($result && $result->num_rows > 0) {
                                    while($row = $result->fetch_assoc()) {
                                        $now = new DateTime();
                                        $start = DateTime::createFromFormat('H:i:s', $row['start_time']);
                                        $end = DateTime::createFromFormat('H:i:s', $row['end_time']);
                                        $current_time = DateTime::createFromFormat('H:i:s', $now->format('H:i:s'));
                                        
                                        if ($current_time >= $start && $current_time <= $end) {
                                            $status = 'Ongoing';
                                            $status_class = 'bg-warning bg-opacity-25';
                                        } elseif ($current_time < $start) {
                                            $status = 'Upcoming';
                                            $status_class = 'bg-success bg-opacity-25';
                                        } else {
                                            $status = 'Completed';
                                            $status_class = 'bg-secondary bg-opacity-25';
                                        }
                                        
                                        echo "<tr>";
                                        echo "<td><span class='fw-bold'>" . $start->format('h:i A') . "</span><br><small class='text-muted'>" . $end->format('h:i A') . "</small></td>";
                                        echo "<td><span class='fw-bold text-success'>{$row['course_code']}</span><br><small class='text-muted'>{$row['course_name']}</small></td>";
                                        echo "<td><span class='fw-bold'>{$row['room_name']}</span></td>";
                                        echo "<td>{$row['instructor_name']}</td>";
                                        echo "<td><span class='badge {$status_class}'>{$status}</span></td>";
                                        echo "</tr>";
                                    }
                                } else {
                                    echo "<tr><td colspan='5' class='text-center py-4'>";
                                    echo "<i class='bi bi-calendar-x display-6 text-success d-block mb-2'></i>";
                                    echo "<p class='text-muted mb-0'>No classes scheduled for today</p>";
                                    echo "</td></tr>";
                                }
                                ?>
                            </tbody>
                        </table>
                    </div>
                    <?php if($result && $result->num_rows > 0): ?>
                    <div class="text-end mt-3">
                        <a href="schedule.php" class="btn btn-outline-success btn-sm">
                            View Full Schedule <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="content-card card">
                <div class="card-header bg-white">
                    <h5 class="mb-0">
                        <i class="bi bi-clock-history text-warning me-2"></i>
                        Pending Reservations
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="list-group list-group-flush">
                        <?php
                        $query = "SELECT r.*, res.name as resource_name, res.type
                                  FROM reservations r
                                  JOIN resources res ON r.resource_id = res.resource_id
                                  WHERE r.status = 'Pending'
                                  ORDER BY r.start_time
                                  LIMIT 5";
                        $result = $conn->query($query);
                        
                        if ($result && $result->num_rows > 0) {
                            while($row = $result->fetch_assoc()) {
                                echo "<div class='list-group-item'>";
                                echo "<div class='d-flex w-100 justify-content-between align-items-start mb-2'>";
                                echo "<h6 class='mb-0 fw-bold text-success'>{$row['resource_name']}</h6>";
                                echo "<span class='badge bg-warning'>Pending</span>";
                                echo "</div>";
                                echo "<p class='mb-2 small text-muted'><i class='bi bi-calendar3 me-1 text-success'></i>" . date('M d, Y', strtotime($row['start_time'])) . "</p>";
                                echo "<p class='mb-2 small'><i class='bi bi-chat-text me-1 text-success'></i>" . substr($row['purpose'], 0, 50) . (strlen($row['purpose']) > 50 ? '...' : '') . "</p>";
                                echo "<small class='text-success'><i class='bi bi-clock me-1'></i>" . date('h:i A', strtotime($row['start_time'])) . " - " . date('h:i A', strtotime($row['end_time'])) . "</small>";
                                echo "</div>";
                            }
                        } else {
                            echo "<div class='text-center py-4'>";
                            echo "<i class='bi bi-check2-circle display-4 text-success mb-2'></i>";
                            echo "<p class='text-muted mb-0'>No pending reservations</p>";
                            echo "</div>";
                        }
                        ?>
                    </div>
                </div>
                <?php if($result && $result->num_rows > 0): ?>
                <div class="card-footer bg-white border-0">
                    <a href="reservations.php" class="btn btn-outline-warning btn-sm w-100">
                        Manage Reservations <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<?php include '../includes/footer.php'; ?>