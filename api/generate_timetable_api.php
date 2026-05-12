<?php
// api/generate_timetable_api.php - API Backend for Schedule Generator
require_once 'config.php';

error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['action'])) {
    $action = $_POST['action'];
    
    if ($action == 'export_data') {
        $semester = $_POST['semester'];
        $year = $_POST['year'];
        $result = exportScheduleData($conn, $semester, $year);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'import_schedule') {
        $schedule_data = json_decode($_POST['schedule_data'], true);
        $semester = $_POST['semester'];
        $year = $_POST['year'];
        $result = importAndPreviewSchedule($conn, $schedule_data, $semester, $year);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'save_imported_schedule') {
        $schedule_data = json_decode($_POST['schedule_data'], true);
        $replace_existing = isset($_POST['replace_existing']) ? filter_var($_POST['replace_existing'], FILTER_VALIDATE_BOOLEAN) : true;
        $semester = isset($_POST['semester']) ? $_POST['semester'] : null;
        $year = isset($_POST['year']) ? $_POST['year'] : null;
        $result = saveImportedSchedule($conn, $schedule_data, $replace_existing, $semester, $year);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'check_conflicts') {
        $class_id = $_POST['class_id'];
        $room_id = $_POST['room_id'];
        $day = $_POST['day'];
        $start_time = $_POST['start_time'];
        $end_time = $_POST['end_time'];
        $instructor_id = $_POST['instructor_id'];
        $result = checkConflicts($conn, $class_id, $room_id, $day, $start_time, $end_time, $instructor_id);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'save_schedule') {
        $schedule_data = json_decode($_POST['schedule_data'], true);
        $result = saveSchedule($conn, $schedule_data);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'delete_schedule') {
        $schedule_id = $_POST['schedule_id'];
        $result = deleteSchedule($conn, $schedule_id);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'publish_schedule') {
        $schedule_id = $_POST['schedule_id'];
        $result = publishSchedule($conn, $schedule_id);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'get_class_duration') {
        $class_id = $_POST['class_id'];
        $result = getClassDuration($conn, $class_id);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'get_section_schedule') {
        $section_name = $_POST['section_name'];
        $department = isset($_POST['department']) ? $_POST['department'] : null;
        $semester = isset($_POST['semester']) ? $_POST['semester'] : null;
        $year = isset($_POST['year']) ? $_POST['year'] : null;
        $result = getSectionSchedule($conn, $section_name, $department, $semester, $year);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'get_department_schedule') {
        $department_id = $_POST['department_id'];
        $semester = $_POST['semester'];
        $year = $_POST['year'];
        $result = getDepartmentSchedule($conn, $department_id, $semester, $year);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'get_available_rooms') {
        $day = $_POST['day'];
        $start_time = $_POST['start_time'];
        $end_time = $_POST['end_time'];
        $class_id = $_POST['class_id'];
        $result = getAvailableRooms($conn, $day, $start_time, $end_time, $class_id);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    } elseif ($action == 'get_departments') {
        $result = getDepartments($conn);
        header('Content-Type: application/json');
        echo json_encode($result);
        exit;
    }
}

// ============================================
// AI FUNCTIONS
// ============================================

function exportScheduleData($conn, $semester, $year) {
    $courses_query = "SELECT DISTINCT 
                        c.course_id, c.course_code, c.name as course_name, 
                        c.credits, c.hours_per_week, c.requires_lab, c.duration_hours,
                        cl.year_level, cl.section, cl.program_code, d.department_id, d.name as department_name
                      FROM courses c
                      JOIN classes cl ON c.course_id = cl.course_id
                      JOIN departments d ON cl.program_code = 
                        CASE 
                          WHEN cl.program_code LIKE 'BSIT%' OR cl.program_code LIKE 'BSIS%' OR cl.program_code LIKE 'BSCS%' THEN 'CCSE'
                          WHEN cl.program_code = 'BSPOLS' THEN 'POLSCI'
                          WHEN cl.program_code = 'BSBA' THEN 'CBA'
                          WHEN cl.program_code = 'BSHKI' THEN 'HKI'
                          ELSE 'CCSE'
                        END
                      WHERE cl.semester = '$semester' AND cl.year = $year
                      AND c.course_code != 'Off-Cam'
                      ORDER BY d.department_id, cl.year_level, cl.section, c.course_code";
    $courses_result = $conn->query($courses_query);
    
    $courses = [];
    while ($row = $courses_result->fetch_assoc()) {
        $courses[] = $row;
    }
    
    $rooms_query = "SELECT * FROM rooms ORDER BY room_type, name";
    $rooms_result = $conn->query($rooms_query);
    $rooms = [];
    while ($row = $rooms_result->fetch_assoc()) {
        $rooms[] = $row;
    }
    
    $instructors_query = "SELECT e.*, p.title as position, 
                          (SELECT COUNT(*) FROM classes WHERE instructor_id = e.employee_id AND semester = '$semester' AND year = $year) as class_count
                          FROM employees e
                          JOIN positions p ON e.position_id = p.position_id
                          WHERE e.is_faculty = 1
                          ORDER BY e.last_name";
    $instructors_result = $conn->query($instructors_query);
    $instructors = [];
    while ($row = $instructors_result->fetch_assoc()) {
        $instructors[] = $row;
    }
    
    $existing_query = "SELECT s.*, c.course_code, c.name as course_name,
                              r.name as room_name, r.room_type,
                              CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
                              cl.section, cl.year_level, cl.program_code
                       FROM schedule s
                       JOIN classes cl ON s.class_id = cl.class_id
                       JOIN courses c ON cl.course_id = c.course_id
                       JOIN rooms r ON s.room_id = r.room_id
                       JOIN employees e ON cl.instructor_id = e.employee_id
                       WHERE cl.semester = '$semester' AND cl.year = $year
                       ORDER BY cl.year_level, cl.section, s.day_of_week, s.start_time";
    $existing_result = $conn->query($existing_query);
    $existing_schedules = [];
    while ($row = $existing_result->fetch_assoc()) {
        $existing_schedules[] = $row;
    }
    
    $depts_query = "SELECT * FROM departments";
    $depts_result = $conn->query($depts_query);
    $departments = [];
    while ($row = $depts_result->fetch_assoc()) {
        $departments[] = $row;
    }
    
    return [
        'success' => true,
        'data' => [
            'courses' => $courses,
            'rooms' => $rooms,
            'instructors' => $instructors,
            'existing_schedules' => $existing_schedules,
            'departments' => $departments,
            'semester' => $semester,
            'year' => $year,
            'rules' => [
                'days' => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Saturday'],
                'time_start' => '08:00:00',
                'time_end' => '20:00:00',
                'no_friday' => true,
                'no_sunday' => true
            ]
        ]
    ];
}

function importAndPreviewSchedule($conn, $schedule_data, $semester, $year) {
    $preview_schedules = [];
    $errors = [];
    $warnings = [];
    
    if (!isset($schedule_data['schedules']) || !is_array($schedule_data['schedules'])) {
        return ['success' => false, 'message' => 'Invalid schedule format. Expected "schedules" array.'];
    }
    
    $classes_map = [];
    $classes_query = "SELECT c.class_id, c.course_id, TRIM(c.section) as section, 
                             TRIM(cr.course_code) as course_code, cr.name as course_name,
                             c.instructor_id, CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
                             c.year_level, cr.requires_lab, cr.credits,
                             c.semester as class_semester, c.year as class_year,
                             c.program_code
                      FROM classes c
                      JOIN courses cr ON c.course_id = cr.course_id
                      JOIN employees e ON c.instructor_id = e.employee_id";
    
    $classes_result = $conn->query($classes_query);
    
    if (!$classes_result) {
        return ['success' => false, 'message' => 'Database error: ' . $conn->error];
    }
    
    while ($class = $classes_result->fetch_assoc()) {
        $key_original = $class['section'] . '|' . $class['course_code'];
        $key_upper = strtoupper($class['section']) . '|' . strtoupper($class['course_code']);
        $key_lower = strtolower($class['section']) . '|' . strtolower($class['course_code']);
        $key_trim = trim($class['section']) . '|' . trim($class['course_code']);
        
        $classes_map[$key_original] = $class;
        $classes_map[$key_upper] = $class;
        $classes_map[$key_lower] = $class;
        $classes_map[$key_trim] = $class;
    }
    
    $rooms_map = [];
    $rooms_query = "SELECT * FROM rooms";
    $rooms_result = $conn->query($rooms_query);
    while ($room = $rooms_result->fetch_assoc()) {
        $rooms_map[$room['name']] = $room;
        $rooms_map[strtolower($room['name'])] = $room;
        $rooms_map[trim($room['name'])] = $room;
    }
    
    $valid_days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    $processed_count = 0;
    $failed_count = 0;
    
    foreach ($schedule_data['schedules'] as $index => $item) {
        if (!isset($item['section']) || !isset($item['course_code']) || 
            !isset($item['day']) || !isset($item['start_time']) || 
            !isset($item['end_time']) || !isset($item['room'])) {
            $errors[] = "Item $index: Missing required fields";
            $failed_count++;
            continue;
        }
        
        $section = trim($item['section']);
        $course_code = trim($item['course_code']);
        $day = trim($item['day']);
        $start_time = $item['start_time'];
        $end_time = $item['end_time'];
        $room_name = trim($item['room']);
        
        if (!in_array($day, $valid_days)) {
            $warnings[] = "Item $index: Invalid day '$day' for $section - $course_code. Skipping.";
            $failed_count++;
            continue;
        }
        
        $class = null;
        $key1 = $section . '|' . $course_code;
        $key2 = strtoupper($section) . '|' . strtoupper($course_code);
        
        if (isset($classes_map[$key1])) {
            $class = $classes_map[$key1];
        } elseif (isset($classes_map[$key2])) {
            $class = $classes_map[$key2];
        }
        
        if (!$class) {
            $errors[] = "Item $index: Class not found: $section - $course_code";
            $failed_count++;
            continue;
        }
        
        $room_id = null;
        $room_display_name = $room_name;
        
        if (isset($rooms_map[$room_name])) {
            $room_id = $rooms_map[$room_name]['room_id'];
            $room_display_name = $rooms_map[$room_name]['name'];
        } elseif (isset($rooms_map[strtolower($room_name)])) {
            $room_id = $rooms_map[strtolower($room_name)]['room_id'];
            $room_display_name = $rooms_map[strtolower($room_name)]['name'];
        } else {
            $room_id = 1;
            $warnings[] = "Item $index: Room '$room_name' not found. Using default room.";
        }
        
        if ($start_time >= $end_time) {
            $errors[] = "Item $index: Invalid time range for $section - $course_code";
            $failed_count++;
            continue;
        }
        
        $room_conflict_query = "SELECT s.*, c.course_code, c.name as course_name, 
                                       cl.section, CONCAT(e.first_name, ' ', e.last_name) as instructor_name
                                FROM schedule s
                                JOIN classes cl ON s.class_id = cl.class_id
                                JOIN courses c ON cl.course_id = c.course_id
                                JOIN employees e ON cl.instructor_id = e.employee_id
                                WHERE s.room_id = $room_id 
                                AND s.day_of_week = '$day'
                                AND NOT (s.end_time <= '$start_time' OR s.start_time >= '$end_time')";
        
        $room_conflict_result = $conn->query($room_conflict_query);
        if ($room_conflict_result && $room_conflict_result->num_rows > 0) {
            $conflict = $room_conflict_result->fetch_assoc();
            $errors[] = "Item $index: Room conflict for $section - $course_code. Room '$room_display_name' is already booked for {$conflict['course_code']} - {$conflict['course_name']} (Section: {$conflict['section']}) on $day from {$conflict['start_time']} to {$conflict['end_time']}";
            $failed_count++;
            continue;
        }
        
        $instructor_conflict_query = "SELECT s.*, c.course_code, c.name as course_name, 
                                             cl.section, r.name as room_name
                                      FROM schedule s
                                      JOIN classes cl ON s.class_id = cl.class_id
                                      JOIN courses c ON cl.course_id = c.course_id
                                      JOIN rooms r ON s.room_id = r.room_id
                                      WHERE cl.instructor_id = {$class['instructor_id']}
                                      AND s.day_of_week = '$day'
                                      AND NOT (s.end_time <= '$start_time' OR s.start_time >= '$end_time')";
        
        $instructor_conflict_result = $conn->query($instructor_conflict_query);
        if ($instructor_conflict_result && $instructor_conflict_result->num_rows > 0) {
            $conflict = $instructor_conflict_result->fetch_assoc();
            $errors[] = "Item $index: Instructor conflict for $section - $course_code. {$class['instructor_name']} is already scheduled for {$conflict['course_code']} - {$conflict['course_name']} (Section: {$conflict['section']}) on $day from {$conflict['start_time']} to {$conflict['end_time']} in {$conflict['room_name']}";
            $failed_count++;
            continue;
        }
        
        if ($class['requires_lab'] && isset($rooms_map[$room_name])) {
            $room_info = $rooms_map[$room_name];
            if ($room_info['room_type'] !== 'lab') {
                $errors[] = "Item $index: Room type mismatch for $section - $course_code. Lab course requires a lab room, but '$room_display_name' is a {$room_info['room_type']} room";
                $failed_count++;
                continue;
            }
        }
        
        $preview_schedules[] = [
            'class_id' => $class['class_id'],
            'course_code' => $course_code,
            'course_name' => $class['course_name'],
            'section' => $section,
            'instructor_name' => $class['instructor_name'],
            'room_id' => $room_id,
            'room_name' => $room_display_name,
            'day_of_week' => $day,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'year_level' => $class['year_level'],
            'program_code' => $class['program_code']
        ];
        
        $processed_count++;
    }
    
    $stats = [
        'total' => count($preview_schedules),
        'processed' => $processed_count,
        'failed' => $failed_count,
        'errors' => count($errors),
        'warnings' => count($warnings),
        'by_year' => [],
        'by_day' => []
    ];
    
    foreach ($preview_schedules as $s) {
        $year_level = $s['year_level'];
        $stats['by_year'][$year_level] = ($stats['by_year'][$year_level] ?? 0) + 1;
        $stats['by_day'][$s['day_of_week']] = ($stats['by_day'][$s['day_of_week']] ?? 0) + 1;
    }
    
    return [
        'success' => true,
        'preview_schedules' => $preview_schedules,
        'errors' => $errors,
        'warnings' => $warnings,
        'stats' => $stats,
        'message' => sprintf("Processed %d schedules: %d successful, %d failed", 
                            count($schedule_data['schedules']), $processed_count, $failed_count)
    ];
}

function saveImportedSchedule($conn, $schedule_data, $replace_existing = true, $semester = null, $year = null) {
    $conn->begin_transaction();
    
    try {
        $saved_count = 0;
        $updated_count = 0;
        $errors = [];
        
        if ($replace_existing) {
            $delete_all_query = "DELETE FROM schedule";
            if (!$conn->query($delete_all_query)) {
                $errors[] = "Failed to delete existing schedules: " . $conn->error;
            } else {
                $delete_notifications = "DELETE FROM notifications WHERE type = 'schedule'";
                $conn->query($delete_notifications);
            }
        }
        
        foreach ($schedule_data as $schedule) {
            if (!isset($schedule['class_id']) || !isset($schedule['room_id']) || 
                !isset($schedule['day_of_week']) || !isset($schedule['start_time']) || 
                !isset($schedule['end_time'])) {
                $errors[] = "Missing required fields for schedule";
                continue;
            }
            
            $class_id = intval($schedule['class_id']);
            $room_id = intval($schedule['room_id']);
            $day_of_week = $conn->real_escape_string($schedule['day_of_week']);
            $start_time = $schedule['start_time'];
            $end_time = $schedule['end_time'];
            
            $check_query = "SELECT schedule_id FROM schedule WHERE class_id = $class_id";
            $existing = $conn->query($check_query);
            
            if ($existing && $existing->num_rows > 0) {
                $update_query = "UPDATE schedule 
                                SET room_id = $room_id, 
                                    day_of_week = '$day_of_week', 
                                    start_time = '$start_time', 
                                    end_time = '$end_time'
                                WHERE class_id = $class_id";
                if ($conn->query($update_query)) {
                    $updated_count++;
                } else {
                    $errors[] = "Failed to update schedule for class_id: $class_id - " . $conn->error;
                }
            } else {
                $insert_query = "INSERT INTO schedule (class_id, room_id, day_of_week, start_time, end_time)
                                VALUES ($class_id, $room_id, '$day_of_week', '$start_time', '$end_time')";
                if ($conn->query($insert_query)) {
                    $saved_count++;
                } else {
                    $errors[] = "Failed to insert schedule for class_id: $class_id - " . $conn->error;
                }
            }
        }
        
        $conn->commit();
        
        $message = "Successfully saved $saved_count new schedules and updated $updated_count existing schedules.";
        if (!empty($errors)) {
            $message .= " Warnings: " . implode("; ", array_slice($errors, 0, 3));
        }
        
        return [
            'success' => true,
            'saved_count' => $saved_count,
            'updated_count' => $updated_count,
            'message' => $message
        ];
        
    } catch (Exception $e) {
        $conn->rollback();
        return [
            'success' => false,
            'saved_count' => 0,
            'updated_count' => 0,
            'message' => 'Error saving schedules: ' . $e->getMessage()
        ];
    }
}

function checkConflicts($conn, $class_id, $room_id, $day, $start_time, $end_time, $instructor_id) {
    $conflicts = [];
    
    $instructor_query = "SELECT s.*, c.course_code, cl.section
                         FROM schedule s
                         JOIN classes cl ON s.class_id = cl.class_id
                         JOIN courses c ON cl.course_id = c.course_id
                         WHERE cl.instructor_id = $instructor_id 
                         AND s.day_of_week = '$day'
                         AND s.class_id != $class_id
                         AND NOT (s.end_time <= '$start_time' OR s.start_time >= '$end_time')";
    $instructor_conflicts = $conn->query($instructor_query);
    
    while ($conflict = $instructor_conflicts->fetch_assoc()) {
        $conflicts[] = [
            'type' => 'instructor',
            'details' => "Instructor conflict with {$conflict['section']} ({$conflict['course_code']}) at " . 
                         date('h:i A', strtotime($conflict['start_time'])) . " - " . 
                         date('h:i A', strtotime($conflict['end_time']))
        ];
    }
    
    if ($room_id > 0) {
        $room_query = "SELECT s.*, c.course_code, cl.section
                       FROM schedule s
                       JOIN classes cl ON s.class_id = cl.class_id
                       JOIN courses c ON cl.course_id = c.course_id
                       WHERE s.room_id = $room_id 
                       AND s.day_of_week = '$day'
                       AND s.class_id != $class_id
                       AND NOT (s.end_time <= '$start_time' OR s.start_time >= '$end_time')";
        $room_conflicts = $conn->query($room_query);
        
        while ($conflict = $room_conflicts->fetch_assoc()) {
            $conflicts[] = [
                'type' => 'room',
                'details' => "Room conflict with {$conflict['section']} ({$conflict['course_code']}) at " . 
                             date('h:i A', strtotime($conflict['start_time'])) . " - " . 
                             date('h:i A', strtotime($conflict['end_time']))
            ];
        }
    }
    
    return [
        'has_conflict' => count($conflicts) > 0,
        'conflicts' => $conflicts
    ];
}

function saveSchedule($conn, $schedule_data) {
    $conn->begin_transaction();
    
    try {
        $check_query = "SELECT schedule_id FROM schedule WHERE class_id = {$schedule_data['class_id']}";
        $existing = $conn->query($check_query);
        
        if ($existing->num_rows > 0) {
            $update_query = "UPDATE schedule 
                            SET room_id = {$schedule_data['room_id']}, 
                                day_of_week = '{$schedule_data['day']}', 
                                start_time = '{$schedule_data['start_time']}', 
                                end_time = '{$schedule_data['end_time']}'
                            WHERE class_id = {$schedule_data['class_id']}";
            $conn->query($update_query);
        } else {
            $insert_query = "INSERT INTO schedule (class_id, room_id, day_of_week, start_time, end_time)
                             VALUES ({$schedule_data['class_id']}, {$schedule_data['room_id']}, 
                                     '{$schedule_data['day']}', '{$schedule_data['start_time']}', 
                                     '{$schedule_data['end_time']}')";
            $conn->query($insert_query);
        }
        
        $conn->commit();
        return ['success' => true, 'message' => 'Schedule saved successfully'];
    } catch (Exception $e) {
        $conn->rollback();
        return ['success' => false, 'message' => 'Error: ' . $e->getMessage()];
    }
}

function deleteSchedule($conn, $schedule_id) {
    $query = "DELETE FROM schedule WHERE schedule_id = $schedule_id";
    if ($conn->query($query)) {
        return ['success' => true, 'message' => 'Schedule deleted successfully'];
    }
    return ['success' => false, 'message' => 'Error deleting schedule'];
}

function publishSchedule($conn, $schedule_id) {
    if ($schedule_id == 'all') {
        $schedules_query = "SELECT s.*, c.course_code, c.name as course_name,
                           CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
                           r.name as room_name,
                           cl.class_id, cl.section
                           FROM schedule s
                           JOIN classes cl ON s.class_id = cl.class_id
                           JOIN courses c ON cl.course_id = c.course_id
                           JOIN employees e ON cl.instructor_id = e.employee_id
                           JOIN rooms r ON s.room_id = r.room_id";
        $schedules = $conn->query($schedules_query);
        
        $notified_total = 0;
        
        while ($schedule = $schedules->fetch_assoc()) {
            $section_name = $schedule['section'] ?: $schedule['course_code'];
            
            $students_query = "SELECT DISTINCT s.student_id, s.email, s.first_name, s.last_name
                               FROM students s
                               JOIN enrollments e ON s.student_id = e.student_id
                               WHERE e.class_id = {$schedule['class_id']}";
            $students = $conn->query($students_query);
            
            while ($student = $students->fetch_assoc()) {
                $title = "Schedule Published: {$section_name}";
                $message = "Your class {$section_name} - {$schedule['course_name']} has been scheduled.\n\n" .
                           "Day: {$schedule['day_of_week']}\n" .
                           "Time: " . date('h:i A', strtotime($schedule['start_time'])) . " - " . 
                                  date('h:i A', strtotime($schedule['end_time'])) . "\n" .
                           "Room: {$schedule['room_name']}\n" .
                           "Instructor: {$schedule['instructor_name']}";
                
                $notify_query = "INSERT INTO notifications (recipient_type, recipient_id, title, message, type, sent_at)
                                 VALUES ('student', {$student['student_id']}, '$title', '$message', 'schedule', NOW())";
                if ($conn->query($notify_query)) {
                    $notified_total++;
                }
            }
        }
        
        return [
            'success' => true,
            'message' => "Schedule published. Notifications sent to $notified_total students."
        ];
    }
    
    return ['success' => false, 'message' => 'Invalid schedule ID'];
}

function getClassDuration($conn, $class_id) {
    $query = "SELECT c.credits, cr.course_code, cr.name as course_name,
              CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
              cl.section, cl.year_level
              FROM classes cl
              JOIN courses c ON cl.course_id = c.course_id
              JOIN employees e ON cl.instructor_id = e.employee_id
              WHERE cl.class_id = $class_id";
    $result = $conn->query($query);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        return [
            'credits' => $row['credits'],
            'duration_slots' => $row['credits'] * 2,
            'course_code' => $row['course_code'],
            'course_name' => $row['course_name'],
            'instructor_name' => $row['instructor_name'],
            'section' => $row['section'],
            'year_level' => $row['year_level']
        ];
    }
    return ['credits' => 3, 'duration_slots' => 6];
}

function getSectionSchedule($conn, $section_name, $department = null, $semester = null, $year = null) {
    $department_filter = "";
    if ($department) {
        $program_codes = [];
        switch(strtoupper($department)) {
            case 'CCSE':
                $program_codes = ['BSIT', 'BSIS', 'BSCS'];
                break;
            case 'POLSCI':
                $program_codes = ['BSPOLS'];
                break;
            case 'CBA':
                $program_codes = ['BSBA'];
                break;
            case 'HKI':
                $program_codes = ['BSHKI'];
                break;
            default:
                $program_codes = [];
        }
        
        if (!empty($program_codes)) {
            $program_filter = "'" . implode("','", $program_codes) . "'";
            $department_filter = " AND cl.program_code IN ($program_filter)";
        }
    }
    
    $semester_filter = "";
    if ($semester) {
        $semester_filter = " AND cl.semester = '$semester'";
    }
    
    $year_filter = "";
    if ($year) {
        $year_filter = " AND cl.year = $year";
    }
    
    $classes_query = "SELECT cl.*, c.course_code, c.name as course_name, c.credits, c.requires_lab,
                      CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
                      e.employee_id as instructor_id
                      FROM classes cl
                      JOIN courses c ON cl.course_id = c.course_id
                      JOIN employees e ON cl.instructor_id = e.employee_id
                      WHERE cl.section = '$section_name' 
                      AND c.course_code != 'Off-Cam'
                      $department_filter $semester_filter $year_filter
                      ORDER BY c.course_code";
    $classes_result = $conn->query($classes_query);
    $classes = [];
    while ($row = $classes_result->fetch_assoc()) {
        $classes[] = $row;
    }
    
    $query = "SELECT s.*, c.course_code, c.name as course_name,
              CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
              r.name as room_name, r.room_type,
              cl.class_id, cl.section, cl.program_code, cl.semester, cl.year, cl.year_level
              FROM schedule s
              JOIN classes cl ON s.class_id = cl.class_id
              JOIN courses c ON cl.course_id = c.course_id
              JOIN employees e ON cl.instructor_id = e.employee_id
              JOIN rooms r ON s.room_id = r.room_id
              WHERE cl.section = '$section_name' 
              AND c.course_code != 'Off-Cam'
              $department_filter $semester_filter $year_filter
              ORDER BY FIELD(s.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), s.start_time";
    
    $result = $conn->query($query);
    $schedules = [];
    $scheduled_class_ids = [];
    while ($row = $result->fetch_assoc()) {
        $schedules[] = $row;
        $scheduled_class_ids[] = $row['class_id'];
    }
    
    $unscheduled_classes = [];
    foreach ($classes as $class) {
        if (!in_array($class['class_id'], $scheduled_class_ids)) {
            $unscheduled_classes[] = $class;
        }
    }
    
    return [
        'success' => true,
        'schedules' => $schedules,
        'classes' => $classes,
        'unscheduled_classes' => $unscheduled_classes,
        'section' => $section_name,
        'semester' => $semester,
        'year' => $year,
        'total_classes' => count($classes),
        'scheduled_count' => count($schedules),
        'unscheduled_count' => count($unscheduled_classes)
    ];
}

function getDepartmentSchedule($conn, $department_id, $semester, $year) {
    $dept_query = "SELECT * FROM departments WHERE department_id = $department_id";
    $dept_result = $conn->query($dept_query);
    $department = $dept_result->fetch_assoc();
    
    $program_codes = [];
    switch($department['name']) {
        case 'Computing Science and Engineering - CCSE (Computer Science Building)':
            $program_codes = ['BSIT', 'BSIS', 'BSCS'];
            break;
        case 'Political Science - POLSCI (Social Sciences Building)':
            $program_codes = ['BSPOLS'];
            break;
        case 'Business Administration - CBA (Business Building)':
            $program_codes = ['BSBA'];
            break;
        case 'Human Knowledge Intelligence - HKI (Humanities Building)':
            $program_codes = ['BSHKI'];
            break;
        default:
            $program_codes = [];
    }
    
    if (empty($program_codes)) {
        return ['success' => false, 'message' => 'No program codes found for this department'];
    }
    
    $program_filter = "'" . implode("','", $program_codes) . "'";
    
    $query = "SELECT s.*, c.course_code, c.name as course_name,
              CONCAT(e.first_name, ' ', e.last_name) as instructor_name,
              r.name as room_name,
              cl.class_id, cl.section, cl.year_level, cl.program_code
              FROM schedule s
              JOIN classes cl ON s.class_id = cl.class_id
              JOIN courses c ON cl.course_id = c.course_id
              JOIN employees e ON cl.instructor_id = e.employee_id
              JOIN rooms r ON s.room_id = r.room_id
              WHERE cl.program_code IN ($program_filter)
              AND cl.semester = '$semester'
              AND cl.year = $year
              ORDER BY cl.year_level, cl.section, FIELD(s.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), s.start_time";
    
    $result = $conn->query($query);
    $schedules = [];
    while ($row = $result->fetch_assoc()) {
        $schedules[] = $row;
    }
    
    $sections_query = "SELECT DISTINCT section, year_level 
                       FROM classes 
                       WHERE program_code IN ($program_filter)
                       AND semester = '$semester'
                       AND year = $year
                       ORDER BY year_level, section";
    $sections_result = $conn->query($sections_query);
    $sections = [];
    while ($row = $sections_result->fetch_assoc()) {
        $sections[] = $row;
    }
    
    return [
        'success' => true,
        'schedules' => $schedules,
        'department' => $department,
        'sections' => $sections,
        'program_codes' => $program_codes
    ];
}

function getAvailableRooms($conn, $day, $start_time, $end_time, $class_id) {
    $query = "SELECT r.* FROM rooms r
              WHERE r.room_id NOT IN (
                  SELECT s.room_id FROM schedule s
                  WHERE s.day_of_week = '$day'
                  AND s.class_id != $class_id
                  AND NOT (s.end_time <= '$start_time' OR s.start_time >= '$end_time')
              )
              ORDER BY r.name";
    $result = $conn->query($query);
    $rooms = [];
    while ($room = $result->fetch_assoc()) {
        $rooms[] = $room;
    }
    return ['success' => true, 'rooms' => $rooms];
}

function getDepartments($conn) {
    $query = "SELECT * FROM departments";
    $result = $conn->query($query);
    $departments = [];
    while ($row = $result->fetch_assoc()) {
        if (strpos($row['name'], 'CCSE') !== false) {
            $row['short_name'] = 'CCSE';
        } elseif (strpos($row['name'], 'POLSCI') !== false) {
            $row['short_name'] = 'POLSCI';
        } elseif (strpos($row['name'], 'CBA') !== false) {
            $row['short_name'] = 'CBA';
        } elseif (strpos($row['name'], 'HKI') !== false) {
            $row['short_name'] = 'HKI';
        } else {
            $row['short_name'] = substr($row['name'], 0, 20);
        }
        $departments[] = $row;
    }
    return ['success' => true, 'departments' => $departments];
}
?>