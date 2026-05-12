<?php
// api/get_entities.php - API endpoint for instructors and rooms
require_once 'config.php';

header('Content-Type: application/json');

$view_type = isset($_GET['view']) ? $_GET['view'] : 'instructor';
$selected_dept = isset($_GET['dept']) ? $_GET['dept'] : 'all';

$response = [
    'success' => true,
    'entities' => [],
    'total' => 0
];

if ($view_type === 'instructor') {
    $dept_filter = "";
    if ($selected_dept != 'all') {
        $dept_name = "";
        if ($selected_dept == 'ccse') $dept_name = "Computing Science and Engineering";
        elseif ($selected_dept == 'polsci') $dept_name = "Political Science";
        elseif ($selected_dept == 'cba') $dept_name = "Business Administration";
        elseif ($selected_dept == 'hki') $dept_name = "Human Knowledge Intelligence";
        
        if ($dept_name) {
            $dept_filter = " AND d.name LIKE '%$dept_name%'";
        }
    }
    
    $query = "SELECT e.*, p.title as position_title, d.name as department_name,
              COUNT(DISTINCT c.class_id) as total_classes,
              COUNT(DISTINCT s.schedule_id) as total_schedules
              FROM employees e
              JOIN positions p ON e.position_id = p.position_id
              JOIN departments d ON e.department_id = d.department_id
              LEFT JOIN classes c ON e.employee_id = c.instructor_id
              LEFT JOIN schedule s ON c.class_id = s.class_id
              WHERE e.is_faculty = 1
              $dept_filter
              GROUP BY e.employee_id
              ORDER BY d.department_id, e.last_name";
    
    $result = $conn->query($query);
    
    while ($row = $result->fetch_assoc()) {
        $dept_short = '';
        if (strpos($row['department_name'], 'CCSE') !== false || strpos($row['department_name'], 'Computing') !== false) {
            $dept_short = 'CCSE';
        } elseif (strpos($row['department_name'], 'POLSCI') !== false || strpos($row['department_name'], 'Political') !== false) {
            $dept_short = 'POLSCI';
        } elseif (strpos($row['department_name'], 'CBA') !== false || strpos($row['department_name'], 'Business') !== false) {
            $dept_short = 'CBA';
        } elseif (strpos($row['department_name'], 'HKI') !== false || strpos($row['department_name'], 'Human') !== false) {
            $dept_short = 'HKI';
        }
        
        $response['entities'][] = [
            'type' => 'instructor',
            'id' => $row['employee_id'],
            'first_name' => $row['first_name'],
            'last_name' => $row['last_name'],
            'full_name' => $row['first_name'] . ' ' . $row['last_name'],
            'initials' => strtoupper(substr($row['first_name'], 0, 1) . substr($row['last_name'], 0, 1)),
            'position_title' => $row['position_title'],
            'department' => $dept_short,
            'department_name' => $row['department_name'],
            'total_classes' => (int)$row['total_classes'],
            'total_schedules' => (int)$row['total_schedules']
        ];
    }
    
} else {
    $dept_filter = "";
    if ($selected_dept == 'ccse') {
        $dept_filter = " AND r.room_id BETWEEN 1 AND 19";
    } elseif ($selected_dept == 'polsci') {
        $dept_filter = " AND r.room_id BETWEEN 20 AND 34";
    } elseif ($selected_dept == 'cba') {
        $dept_filter = " AND r.room_id BETWEEN 35 AND 57";
    } elseif ($selected_dept == 'hki') {
        $dept_filter = " AND r.room_id BETWEEN 58 AND 80";
    }
    
    $query = "SELECT r.*, COUNT(DISTINCT s.schedule_id) as total_schedules
              FROM rooms r
              LEFT JOIN schedule s ON r.room_id = s.room_id
              WHERE 1=1 $dept_filter
              GROUP BY r.room_id
              ORDER BY r.name";
    
    $result = $conn->query($query);
    
    while ($row = $result->fetch_assoc()) {
        $dept_short = '';
        if ($row['room_id'] >= 1 && $row['room_id'] <= 19) {
            $dept_short = 'CCSE';
        } elseif ($row['room_id'] >= 20 && $row['room_id'] <= 34) {
            $dept_short = 'POLSCI';
        } elseif ($row['room_id'] >= 35 && $row['room_id'] <= 57) {
            $dept_short = 'CBA';
        } elseif ($row['room_id'] >= 58 && $row['room_id'] <= 80) {
            $dept_short = 'HKI';
        }
        
        $response['entities'][] = [
            'type' => 'room',
            'id' => $row['room_id'],
            'name' => $row['name'],
            'location' => $row['location'],
            'capacity' => (int)$row['capacity'],
            'room_type' => $row['room_type'],
            'department' => $dept_short,
            'total_schedules' => (int)$row['total_schedules']
        ];
    }
}

$response['total'] = count($response['entities']);

echo json_encode($response);
?>