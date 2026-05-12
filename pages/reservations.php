<?php
// pages/reservations.php - Manage resource reservations
require_once './api/config.php';

$page_title = 'Reservations - CCST Scheduling System';

include '../includes/header.php';
include '../includes/navbar.php';
?>

<div class="container-fluid px-4">
    <!-- Page Header -->
    <div class="page-header mt-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2><i class="bi bi-bookmark-check-fill me-2"></i>Resource Reservations</h2>
                <p class="text-muted">View all resource booking requests</p>
            </div>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <form method="GET" class="row g-3 align-items-end">
            <div class="col-md-3">
                <label class="form-label">Resource Type</label>
                <select name="type" class="form-select">
                    <option value="">All Types</option>
                    <option value="Equipment">Equipment</option>
                    <option value="Room">Room</option>
                    <option value="Vehicle">Vehicle</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">Date From</label>
                <input type="date" name="date_from" class="form-control">
            </div>
            <div class="col-md-3">
                <label class="form-label">Date To</label>
                <input type="date" name="date_to" class="form-control">
            </div>
            <div class="col-md-3">
                <button type="submit" class="btn btn-primary-custom w-100">
                    <i class="bi bi-funnel me-2"></i>Apply Filters
                </button>
            </div>
        </form>
    </div>

    <!-- Reservations Table -->
    <div class="content-card card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0"><i class="bi bi-list-task me-2 text-success"></i>All Reservations</h5>
            <div class="d-flex gap-2">
                <input type="text" class="form-control form-control-sm" placeholder="Search reservations..." style="width: 250px;">
                <button class="btn btn-outline-success btn-sm"><i class="bi bi-download"></i></button>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Resource</th>
                            <th>Reserved By</th>
                            <th>Date & Time</th>
                            <th>Purpose</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $query = "SELECT r.*, res.name as resource_name, res.type,
                                         CONCAT(e.first_name, ' ', e.last_name) as employee_name,
                                         CONCAT(s.first_name, ' ', s.last_name) as student_name
                                  FROM reservations r
                                  JOIN resources res ON r.resource_id = res.resource_id
                                  LEFT JOIN employees e ON r.reserved_by_employee = e.employee_id
                                  LEFT JOIN students s ON r.reserved_by_student = s.student_id
                                  ORDER BY r.start_time DESC
                                  LIMIT 50";
                        $result = $conn->query($query);
                        
                        if ($result->num_rows > 0) {
                            while($row = $result->fetch_assoc()) {
                                $reserved_by = $row['employee_name'] ? $row['employee_name'] : ($row['student_name'] ? $row['student_name'] : 'N/A');
                                $reserved_type = $row['employee_name'] ? 'Employee' : ($row['student_name'] ? 'Student' : '');
                                
                                echo "<tr>";
                                echo "<td><div class='fw-bold text-success'>{$row['resource_name']}</div><small class='text-muted'>{$row['type']}</small></td>";
                                echo "<td><div class='fw-bold'>{$reserved_by}</div><small class='text-muted'>{$reserved_type}</small></td>";
                                echo "<td><div class='fw-bold'>" . date('M d, Y', strtotime($row['start_time'])) . "</div><small class='text-muted'>" . date('h:i A', strtotime($row['start_time'])) . " - " . date('h:i A', strtotime($row['end_time'])) . "</small></td>";
                                echo "<td><span class='d-inline-block text-truncate' style='max-width: 200px;' title='{$row['purpose']}'>{$row['purpose']}</span></td>";
                                echo "</tr>";
                            }
                        } else {
                            echo "<tr><td colspan='4' class='text-center py-5'><i class='bi bi-calendar-x display-4 text-success mb-2'></i><p class='text-muted mb-0'>No reservations found</p></td></tr>";
                        }
                        ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<style>
.filter-section {
    background: white;
    border-radius: 20px;
    padding: 1.5rem;
    margin-bottom: 2rem;
    box-shadow: 0 5px 15px rgba(46, 125, 50, 0.1);
}
</style>

<?php include '../includes/footer.php'; ?>