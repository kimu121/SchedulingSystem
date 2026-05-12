<?php
// pages/resources.php - Manage resources
require_once './api/config.php';

$page_title = 'Resources - Scheduling System';

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['action'])) {
        if ($_POST['action'] == 'add_resource') {
            $name = $conn->real_escape_string($_POST['name']);
            $type = $conn->real_escape_string($_POST['type']);
            $description = $conn->real_escape_string($_POST['description']);
            
            $query = "INSERT INTO resources (name, type, description) VALUES ('$name', '$type', '$description')";
            if ($conn->query($query)) {
                $success = "Resource added successfully!";
            } else {
                $error = "Error adding resource: " . $conn->error;
            }
        } elseif ($_POST['action'] == 'update_resource') {
            $resource_id = $_POST['resource_id'];
            $name = $conn->real_escape_string($_POST['name']);
            $type = $conn->real_escape_string($_POST['type']);
            $description = $conn->real_escape_string($_POST['description']);
            
            $query = "UPDATE resources SET name = '$name', type = '$type', description = '$description' WHERE resource_id = $resource_id";
            if ($conn->query($query)) {
                $success = "Resource updated successfully!";
            } else {
                $error = "Error updating resource: " . $conn->error;
            }
        } elseif ($_POST['action'] == 'delete_resource') {
            $resource_id = $_POST['resource_id'];
            
            $check_query = "SELECT COUNT(*) as count FROM reservations WHERE resource_id = $resource_id";
            $check = $conn->query($check_query)->fetch_assoc();
            
            if ($check['count'] > 0) {
                $error = "Cannot delete resource. It has " . $check['count'] . " existing reservation(s).";
            } else {
                $query = "DELETE FROM resources WHERE resource_id = $resource_id";
                if ($conn->query($query)) {
                    $success = "Resource deleted successfully!";
                } else {
                    $error = "Error deleting resource: " . $conn->error;
                }
            }
        }
    }
}

$filter_type = isset($_GET['type']) ? $_GET['type'] : '';
$filter_search = isset($_GET['search']) ? $_GET['search'] : '';

include '../includes/header.php';
include '../includes/navbar.php';
?>

<div class="container-fluid px-4">
    <!-- Page Header -->
    <div class="page-header mt-4">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h2><i class="bi bi-tools me-2"></i>Resources Management</h2>
                <p class="text-muted">Manage and track all available resources for scheduling and reservations</p>
            </div>
            <div>
                <button type="button" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addResourceModal">
                    <i class="bi bi-plus-circle me-2"></i>Add Resource
                </button>
            </div>
        </div>
    </div>

    <!-- Alerts -->
    <?php if (isset($success)): ?>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i><?php echo $success; ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>
    
    <?php if (isset($error)): ?>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i><?php echo $error; ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>

    <!-- Statistics Overview -->
    <?php
    $total_resources = $conn->query("SELECT COUNT(*) as count FROM resources")->fetch_assoc()['count'];
    $active_reservations = $conn->query("SELECT COUNT(*) as count FROM reservations WHERE status = 'Confirmed' AND start_time > NOW()")->fetch_assoc()['count'];
    $reservations_this_month = $conn->query("SELECT COUNT(*) as count FROM reservations WHERE MONTH(start_time) = MONTH(CURDATE()) AND YEAR(start_time) = YEAR(CURDATE())")->fetch_assoc()['count'];
    ?>
    
    <div class="stats-overview">
        <div class="row g-3">
            <div class="col-md-3 col-sm-6">
                <div class="stat-card-mini">
                    <i class="bi bi-box"></i>
                    <div>
                        <span class="stat-value d-block fs-3"><?php echo $total_resources; ?></span>
                        <span class="stat-label">Total Resources</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-card-mini">
                    <i class="bi bi-calendar-check"></i>
                    <div>
                        <span class="stat-value d-block fs-3"><?php echo $active_reservations; ?></span>
                        <span class="stat-label">Active Reservations</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-card-mini">
                    <i class="bi bi-clock-history"></i>
                    <div>
                        <span class="stat-value d-block fs-3"><?php echo $reservations_this_month; ?></span>
                        <span class="stat-label">This Month</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-card-mini">
                    <i class="bi bi-tags"></i>
                    <div>
                        <span class="stat-value d-block fs-3"><?php echo $conn->query("SELECT COUNT(DISTINCT type) as count FROM resources")->fetch_assoc()['count']; ?></span>
                        <span class="stat-label">Resource Types</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <form method="GET" class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label">Resource Type</label>
                <select name="type" class="form-select">
                    <option value="">All Types</option>
                    <option value="Equipment" <?php echo $filter_type == 'Equipment' ? 'selected' : ''; ?>>Equipment</option>
                    <option value="Facility" <?php echo $filter_type == 'Facility' ? 'selected' : ''; ?>>Facility</option>
                    <option value="Furniture" <?php echo $filter_type == 'Furniture' ? 'selected' : ''; ?>>Furniture</option>
                    <option value="Vehicle" <?php echo $filter_type == 'Vehicle' ? 'selected' : ''; ?>>Vehicle</option>
                    <option value="Other" <?php echo $filter_type == 'Other' ? 'selected' : ''; ?>>Other</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">Search</label>
                <input type="text" name="search" class="form-control" placeholder="Search by name or description..." value="<?php echo htmlspecialchars($filter_search); ?>">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary-custom w-100">
                    <i class="bi bi-funnel me-2"></i>Apply
                </button>
            </div>
        </form>
    </div>

    <!-- Resources Grid -->
    <div class="row g-4">
        <?php
        $query = "SELECT r.*, 
                  (SELECT COUNT(*) FROM reservations WHERE resource_id = r.resource_id AND status = 'Confirmed' AND start_time > NOW()) as upcoming,
                  (SELECT COUNT(*) FROM reservations WHERE resource_id = r.resource_id AND status = 'Confirmed') as total_reservations
                  FROM resources r
                  WHERE 1=1";
        
        if (!empty($filter_type)) {
            $query .= " AND r.type = '" . $conn->real_escape_string($filter_type) . "'";
        }
        if (!empty($filter_search)) {
            $search = $conn->real_escape_string($filter_search);
            $query .= " AND (r.name LIKE '%$search%' OR r.description LIKE '%$search%')";
        }
        
        $query .= " ORDER BY r.type, r.name";
        $result = $conn->query($query);
        
        if ($result && $result->num_rows > 0) {
            while($resource = $result->fetch_assoc()) {
                $upcoming = $resource['upcoming'] ?? 0;
                $total_reservations = $resource['total_reservations'] ?? 0;
                
                $availability = 'Available';
                $availability_class = 'availability-available';
                if ($upcoming > 5) {
                    $availability = 'Limited';
                    $availability_class = 'availability-limited';
                }
                
                $utilization = $total_reservations > 0 ? min(100, round(($total_reservations / 20) * 100)) : 0;
                ?>
                <div class="col-xl-4 col-lg-6 col-md-6">
                    <div class="resource-card card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-box me-2"></i><?php echo htmlspecialchars($resource['name']); ?></h5>
                            <span class="availability-badge <?php echo $availability_class; ?>"><?php echo $availability; ?></span>
                        </div>
                        <div class="card-body">
                            <span class="resource-type"><i class="bi bi-tag me-1"></i><?php echo htmlspecialchars($resource['type']); ?></span>
                            <p class="resource-description"><?php echo htmlspecialchars($resource['description']) ?: '<span class="text-muted">No description provided.</span>'; ?></p>
                            
                            <div class="resource-stats">
                                <div class="stat-item">
                                    <span class="stat-value"><?php echo $upcoming; ?></span>
                                    <span class="stat-label">Upcoming</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-value"><?php echo $total_reservations; ?></span>
                                    <span class="stat-label">Total Uses</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-value"><?php echo $utilization; ?>%</span>
                                    <span class="stat-label">Utilization</span>
                                </div>
                            </div>
                            
                            <div class="utilization-bar">
                                <div class="utilization-fill" style="width: <?php echo $utilization; ?>%;"></div>
                            </div>
                            
                            <div class="btn-action-group">
                                <a href="reservations.php?resource=<?php echo $resource['resource_id']; ?>" class="btn btn-outline-primary flex-grow-1">
                                    <i class="bi bi-calendar-check me-1"></i>View
                                </a>
                                <div class="dropdown">
                                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                        <i class="bi bi-gear"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><button class="dropdown-item" onclick='editResource(<?php echo $resource['resource_id']; ?>, "<?php echo htmlspecialchars($resource['name']); ?>", "<?php echo htmlspecialchars($resource['type']); ?>", "<?php echo addslashes(htmlspecialchars($resource['description'])); ?>")'><i class="bi bi-pencil me-2"></i>Edit</button></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><button class="dropdown-item text-danger" onclick='deleteResource(<?php echo $resource['resource_id']; ?>, "<?php echo htmlspecialchars($resource['name']); ?>")'><i class="bi bi-trash me-2"></i>Delete</button></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <?php
            }
        } else {
            echo '<div class="col-12 text-center py-5">';
            echo '<i class="bi bi-box display-1 text-success mb-3"></i>';
            echo '<h5 class="text-muted">No Resources Found</h5>';
            echo '<button type="button" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addResourceModal">Add Resource</button>';
            echo '</div>';
        }
        ?>
    </div>
</div>

<!-- Add Resource Modal -->
<div class="modal fade" id="addResourceModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Add New Resource</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST">
                <div class="modal-body">
                    <input type="hidden" name="action" value="add_resource">
                    
                    <div class="mb-3">
                        <label class="form-label">Resource Name <span class="text-danger">*</span></label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Type <span class="text-danger">*</span></label>
                        <select name="type" class="form-select" required>
                            <option value="">Select Type</option>
                            <option value="Equipment">Equipment</option>
                            <option value="Facility">Facility / Room</option>
                            <option value="Furniture">Furniture</option>
                            <option value="Vehicle">Vehicle</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="4"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom">Add Resource</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Resource Modal -->
<div class="modal fade" id="editResourceModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Edit Resource</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" id="editResourceForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update_resource">
                    <input type="hidden" name="resource_id" id="edit_resource_id">
                    
                    <div class="mb-3">
                        <label class="form-label">Resource Name</label>
                        <input type="text" name="name" id="edit_name" class="form-control" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Type</label>
                        <select name="type" id="edit_type" class="form-select">
                            <option value="Equipment">Equipment</option>
                            <option value="Facility">Facility</option>
                            <option value="Furniture">Furniture</option>
                            <option value="Vehicle">Vehicle</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" id="edit_description" class="form-control" rows="4"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Resource Form -->
<form id="deleteResourceForm" method="POST" style="display: none;">
    <input type="hidden" name="action" value="delete_resource">
    <input type="hidden" name="resource_id" id="delete_resource_id">
</form>

<style>
.stats-overview {
    background: white;
    border-radius: 20px;
    padding: 1.5rem;
    margin-bottom: 2rem;
    box-shadow: 0 5px 15px rgba(46, 125, 50, 0.1);
}

.stat-card-mini {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem;
    border-radius: 12px;
    background: #f1f8e9;
}

.stat-card-mini i {
    font-size: 2rem;
    color: var(--primary-color);
}

.resource-card {
    border: none;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(46, 125, 50, 0.1);
    height: 100%;
    background: white;
}

.resource-card .card-header {
    background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
    color: white;
    padding: 1.2rem;
}

.resource-type {
    display: inline-block;
    padding: 0.4rem 1rem;
    background-color: #f1f8e9;
    color: var(--primary-dark);
    border-radius: 20px;
    font-size: 0.8rem;
    margin-bottom: 1rem;
}

.resource-description {
    color: #4a5a4a;
    line-height: 1.6;
    margin-bottom: 1.5rem;
    min-height: 70px;
}

.resource-stats {
    display: flex;
    justify-content: space-between;
    padding: 1rem 0;
    border-top: 1px solid #e8f5e9;
    border-bottom: 1px solid #e8f5e9;
    margin-bottom: 1.5rem;
}

.stat-item {
    text-align: center;
    flex: 1;
}

.stat-value {
    font-weight: 700;
    color: var(--primary-dark);
    font-size: 1.2rem;
}

.stat-label {
    font-size: 0.7rem;
    color: #6c757d;
}

.availability-badge {
    display: inline-block;
    padding: 0.4rem 1rem;
    border-radius: 20px;
    font-size: 0.8rem;
}

.availability-available { background-color: #c8e6c9; color: #1b5e20; }
.availability-limited { background-color: #fff3cd; color: #856404; }

.utilization-bar {
    height: 6px;
    background-color: #e8f5e9;
    border-radius: 10px;
    margin: 0.5rem 0;
}

.utilization-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--primary-color), var(--primary-light));
    border-radius: 10px;
}

.btn-action-group {
    display: flex;
    gap: 0.5rem;
}
</style>

<script>
function editResource(id, name, type, description) {
    document.getElementById('edit_resource_id').value = id;
    document.getElementById('edit_name').value = name;
    document.getElementById('edit_type').value = type;
    document.getElementById('edit_description').value = description;
    new bootstrap.Modal(document.getElementById('editResourceModal')).show();
}

function deleteResource(id, name) {
    if (confirm('Are you sure you want to delete "' + name + '"?')) {
        document.getElementById('delete_resource_id').value = id;
        document.getElementById('deleteResourceForm').submit();
    }
}
</script>

<?php include '../includes/footer.php'; ?>