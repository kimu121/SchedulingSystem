<?php
// api/get_rooms.php - API endpoint for rooms
require_once 'config.php';

header('Content-Type: application/json');

$query = "SELECT * FROM rooms ORDER BY name";
$result = $conn->query($query);

$rooms = [];
while ($room = $result->fetch_assoc()) {
    $rooms[] = $room;
}

echo json_encode($rooms);
?>