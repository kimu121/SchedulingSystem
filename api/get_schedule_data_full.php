<?php
// api/get_schedule_data_full.php - Get complete schedule data
require_once 'config.php';

header('Content-Type: application/json');

$semester = isset($_GET['semester']) ? $_GET['semester'] : '1st Semester';
$year = isset($_GET['year']) ? $_GET['year'] : 2025;

// Get all classes with instructor names - EXCLUDE Off-Cam
$classes_query = "SELECT c.*, cr.course_code, cr.name as course_name, cr.credits,
                  CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
                  e.employee_id as instructor_id,
                  (SELECT COUNT(*) FROM enrollments WHERE class_id = c.class_id) as enrolled,
                  c.section
                  FROM classes c
                  JOIN courses cr ON c.course_id = cr.course_id
                  JOIN employees e ON c.instructor_id = e.employee_id
                  WHERE c.semester = '$semester' AND c.year = $year
                  AND cr.course_code != 'Off-Cam'
                  ORDER BY cr.course_code, c.section";
$classes_result = $conn->query($classes_query);

$classes = [];
while ($class = $classes_result->fetch_assoc()) {
    $classes[] = $class;
}

// Get schedules with full details - EXCLUDE Off-Cam
$schedules_query = "SELECT s.*, c.course_code, c.name as course_name,
                    r.name as room_name,
                    CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
                    cl.class_id, cl.section, cl.program_code, cl.semester, cl.year, cl.year_level
                    FROM schedule s
                    JOIN classes cl ON s.class_id = cl.class_id
                    JOIN courses c ON cl.course_id = c.course_id
                    JOIN rooms r ON s.room_id = r.room_id
                    JOIN employees e ON cl.instructor_id = e.employee_id
                    WHERE cl.semester = '$semester' AND cl.year = $year
                    AND c.course_code != 'Off-Cam'
                    ORDER BY FIELD(s.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), s.start_time";
$schedules_result = $conn->query($schedules_query);

$schedules = [];
while ($schedule = $schedules_result->fetch_assoc()) {
    $schedules[] = $schedule;
}

// Calculate statistics
$total_classes = count($classes);
$scheduled_count = count($schedules);
$conflict_count = 0;

// Calculate room utilization
$rooms_query = "SELECT COUNT(*) as total FROM rooms";
$rooms_result = $conn->query($rooms_query);
$total_rooms = $rooms_result->fetch_assoc()['total'];
$total_time_slots = 12 * 7 * $total_rooms;
$utilization = $total_time_slots > 0 ? round(($scheduled_count / $total_time_slots) * 100) : 0;

echo json_encode([
    'classes' => $classes,
    'schedules' => $schedules,
    'total_classes' => $total_classes,
    'scheduled_count' => $scheduled_count,
    'conflict_count' => $conflict_count,
    'utilization' => $utilization . '%'
]);
?>