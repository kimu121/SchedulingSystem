<?php
// includes/navbar.php
$current_page = basename($_SERVER['PHP_SELF']);
?>
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.php">
            <i class="bi bi-calendar-check me-2"></i>
            <span>CCST Building Schedule</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link <?php echo $current_page == 'index.php' || $current_page == 'dashboard.php' ? 'active' : ''; ?>" href="dashboard.php">
                        <i class="bi bi-house-door me-1"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?php echo $current_page == 'schedule.php' ? 'active' : ''; ?>" href="schedule.php">
                        <i class="bi bi-table me-1"></i> Schedule
                    </a>
                </li>
                <li class="nav-item">
    <a class="nav-link <?php echo $current_page == 'ai_generator.php' ? 'active' : ''; ?>" href="ai_generator.php">
        <i class="bi bi-calendar-plus me-1"></i> Assign Schedule
    </a>
</li>
                <li class="nav-item">
                    <a class="nav-link <?php echo $current_page == 'reservations.php' ? 'active' : ''; ?>" href="reservations.php">
                        <i class="bi bi-bookmark-check me-1"></i> Reservations
                    </a>
                </li>
              
            </ul>
        </div>
    </div>
</nav>