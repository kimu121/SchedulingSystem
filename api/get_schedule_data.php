<?php
// api/get_schedule_data.php - API endpoint for schedule data
require_once 'config.php';

header('Content-Type: application/json');

$type = $_GET['type'] ?? '';
$id = $_GET['id'] ?? '';

if (!$type || !$id) {
    echo json_encode(['error' => 'Missing parameters']);
    exit;
}

$response = [
    'schedules' => [
        'monday' => [],
        'tuesday' => [],
        'wednesday' => [],
        'thursday' => [],
        'friday' => [],
        'saturday' => [],
        'sunday' => []
    ]
];

$day_map = [
    'Monday' => 'monday',
    'Tuesday' => 'tuesday',
    'Wednesday' => 'wednesday',
    'Thursday' => 'thursday',
    'Friday' => 'friday',
    'Saturday' => 'saturday',
    'Sunday' => 'sunday'
];

if ($type === 'instructor') {
    // Get instructor info
    $info_query = "SELECT e.*, p.title as position 
                   FROM employees e
                   JOIN positions p ON e.position_id = p.position_id
                   WHERE e.employee_id = $id AND e.is_faculty = 1";
    $info_result = $conn->query($info_query);
    if ($info_result->num_rows > 0) {
        $info = $info_result->fetch_assoc();
        $response['position'] = $info['position'];
        $response['email'] = $info['email'];
        $response['name'] = $info['first_name'] . ' ' . $info['last_name'];
    }
    
    $query = "SELECT 
                s.schedule_id,
                s.day_of_week,
                s.start_time,
                s.end_time,
                c.course_code,
                c.name as course_name,
                c.credits,
                r.name as room_name,
                r.room_id,
                cl.class_id,
                cl.section,
                cl.program_code,
                cl.year_level,
                (SELECT COUNT(*) FROM enrollments WHERE class_id = cl.class_id) as enrolled
              FROM schedule s
              JOIN classes cl ON s.class_id = cl.class_id
              JOIN courses c ON cl.course_id = c.course_id
              JOIN rooms r ON s.room_id = r.room_id
              WHERE cl.instructor_id = $id
              AND c.course_code != 'Off-Cam'
              ORDER BY FIELD(s.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), s.start_time";
    
    $result = $conn->query($query);
    
    if (!$result) {
        echo json_encode(['error' => 'Database error: ' . $conn->error]);
        exit;
    }
    
    while ($row = $result->fetch_assoc()) {
        $day_key = $day_map[$row['day_of_week']] ?? strtolower($row['day_of_week']);
        if (isset($response['schedules'][$day_key])) {
            $response['schedules'][$day_key][] = [
                'start_time' => $row['start_time'],
                'end_time' => $row['end_time'],
                'course_code' => $row['course_code'],
                'course_name' => $row['course_name'],
                'room_name' => $row['room_name'],
                'room_id' => $row['room_id'],
                'section' => $row['section'],
                'program_code' => $row['program_code'],
                'year_level' => $row['year_level'],
                'credits' => $row['credits'],
                'enrolled' => $row['enrolled'] ?? 0,
                'schedule_id' => $row['schedule_id']
            ];
        }
    }
    
} else if ($type === 'room') {
    // Get room info
    $info_query = "SELECT * FROM rooms WHERE room_id = $id";
    $info_result = $conn->query($info_query);
    if ($info_result->num_rows > 0) {
        $info = $info_result->fetch_assoc();
        $response['location'] = $info['location'];
        $response['capacity'] = $info['capacity'];
        $response['name'] = $info['name'];
    }
    
    $query = "SELECT 
                s.schedule_id,
                s.day_of_week,
                s.start_time,
                s.end_time,
                c.course_code,
                c.name as course_name,
                c.credits,
                CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
                e.employee_id as instructor_id,
                cl.class_id,
                cl.section,
                cl.program_code,
                cl.year_level,
                (SELECT COUNT(*) FROM enrollments WHERE class_id = cl.class_id) as enrolled
              FROM schedule s
              JOIN classes cl ON s.class_id = cl.class_id
              JOIN courses c ON cl.course_id = c.course_id
              JOIN employees e ON cl.instructor_id = e.employee_id
              WHERE s.room_id = $id
              AND c.course_code != 'Off-Cam'
              ORDER BY FIELD(s.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), s.start_time";
    
    $result = $conn->query($query);
    
    if (!$result) {
        echo json_encode(['error' => 'Database error: ' . $conn->error]);
        exit;
    }
    
    while ($row = $result->fetch_assoc()) {
        $day_key = $day_map[$row['day_of_week']] ?? strtolower($row['day_of_week']);
        if (isset($response['schedules'][$day_key])) {
            $response['schedules'][$day_key][] = [
                'start_time' => $row['start_time'],
                'end_time' => $row['end_time'],
                'course_code' => $row['course_code'],
                'course_name' => $row['course_name'],
                'instructor_name' => $row['instructor_name'],
                'instructor_id' => $row['instructor_id'],
                'section' => $row['section'],
                'program_code' => $row['program_code'],
                'year_level' => $row['year_level'],
                'credits' => $row['credits'],
                'enrolled' => $row['enrolled'] ?? 0,
                'schedule_id' => $row['schedule_id']
            ];
        }
    }
}

$total_schedules = 0;
foreach ($response['schedules'] as $day => $classes) {
    $total_schedules += count($classes);
}
if ($total_schedules == 0) {
    $response['message'] = 'No schedules found for this ' . ($type === 'instructor' ? 'instructor' : 'room');
}

echo json_encode($response);
?>