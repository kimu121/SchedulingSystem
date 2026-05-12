<?php
// api/config.php
session_start();

$host = 'localhost';
$username = 'root';
$password = '';
$database = 'scheduling_system';

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

date_default_timezone_set('Asia/Manila');
?>