<?php
// api/config.php

function getConnection(): mysqli {
    // 1. If we are on local XAMPP, load the .env file. 
    // Using _DIR_ correctly points to the directory of this file, 
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
    $db   = getenv('SS_DataBase_NAME'); 
    $port = getenv('SS_PORT') ?: 3306; 


    mysqli_report(MYSQLI_REPORT_OFF);


    // 3. Connect to the database
    $conn = new mysqli($host, $user, $pass, $db, (int)$port);