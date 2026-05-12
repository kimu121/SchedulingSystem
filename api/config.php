<?php
// api/config.php

function getConnection(): mysqli {
    // 1. If we are on local XAMPP, load the .env file. 
    // Using __DIR__ correctly points to the directory of this file, 
    // and '/../.env' goes up one level to the project root.
    $envPath = __DIR__ . '/../.env'; 
    
    if (file_exists($envPath)) {
        $lines = file($envPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) continue;
            $parts = explode('=', $line, 2);
            if (count($parts) === 2) {
                putenv(trim($parts[0]) . '=' . trim($parts[1]));
            }
        }
    }

    // 2. Grab the variables (works for both XAMPP's .env AND Render's settings)
    $host = getenv('SS_Host');
    $user = getenv('SS_User'); 
    $pass = getenv('SS_Password');
    // Fix: Match the actual environment variable name from Render
    $db   = getenv('SS_DataBase_NAME') ?: getenv('SS_DataBase_NAME'); // Try both possible names
    $port = getenv('SS_PORT') ?: 25926; // Default to Aiven port

    // Enable exception mode for mysqli
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

    try {
        // 3. Connect to the database with SSL
        $conn = mysqli_init();
        
        // Set SSL options for Aiven
        mysqli_ssl_set($conn, NULL, NULL, NULL, NULL, NULL);
        
        // Set connection timeout
        mysqli_options($conn, MYSQLI_OPT_CONNECT_TIMEOUT, 10);
        
        // Connect
        if (!mysqli_real_connect(
            $conn,
            $host,
            $user,
            $pass,
            $db,
            (int)$port,
            NULL,
            MYSQLI_CLIENT_SSL
        )) {
            throw new Exception('Connection failed: ' . mysqli_connect_error());
        }

        $conn->set_charset('utf8mb4');
        return $conn;
        
    } catch (Exception $e) {
        http_response_code(500);
        header('Content-Type: application/json');
        echo json_encode([
            'status'  => 'error',
            'message' => 'Database connection failed: ' . $e->getMessage()
        ]);
        exit;
    }
}

// 4. Initialize the connection globally
// This ensures that when dashboard.php requires this file, $conn is defined and ready.
$conn = getConnection();
?>