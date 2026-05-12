-- sql/schema.sql - Database Schema for Scheduling System

-- Create database
CREATE DATABASE IF NOT EXISTS scheduling_system;
USE scheduling_system;

-- Departments table
CREATE TABLE IF NOT EXISTS departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default departments
INSERT INTO departments (name) VALUES
('Computing Science and Engineering - CCSE (Computer Science Building)'),
('Political Science - POLSCI (Social Sciences Building)'),
('Business Administration - CBA (Business Building)'),
('Human Knowledge Intelligence - HKI (Humanities Building)');

-- Positions table
CREATE TABLE IF NOT EXISTS positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO positions (title) VALUES
('Professor'), ('Associate Professor'), ('Assistant Professor'), ('Instructor'), ('Lecturer');

-- Employees table
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    position_id INT,
    department_id INT,
    is_faculty BOOLEAN DEFAULT TRUE,
    max_hours_per_week INT DEFAULT 24,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (position_id) REFERENCES positions(position_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Students table
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    program_code VARCHAR(20),
    year_level INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Courses table
CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    credits INT DEFAULT 3,
    hours_per_week INT DEFAULT 3,
    requires_lab BOOLEAN DEFAULT FALSE,
    duration_hours INT DEFAULT 2,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Rooms table
CREATE TABLE IF NOT EXISTS rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    room_type ENUM('lecture', 'lab', 'conference', 'office', 'other') DEFAULT 'lecture',
    capacity INT DEFAULT 30,
    location VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Classes table
CREATE TABLE IF NOT EXISTS classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    instructor_id INT NOT NULL,
    section VARCHAR(20),
    year_level INT,
    program_code VARCHAR(20),
    semester VARCHAR(20),
    year INT,
    max_enrollment INT DEFAULT 30,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (instructor_id) REFERENCES employees(employee_id)
);

-- Schedule table
CREATE TABLE IF NOT EXISTS schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL,
    room_id INT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Enrollments table
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    UNIQUE KEY unique_enrollment (student_id, class_id)
);

-- Resources table
CREATE TABLE IF NOT EXISTS resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type ENUM('Equipment', 'Facility', 'Furniture', 'Vehicle', 'Other') DEFAULT 'Equipment',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reservations table
CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    resource_id INT NOT NULL,
    reserved_by_employee INT NULL,
    reserved_by_student INT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    purpose TEXT,
    status ENUM('Pending', 'Confirmed', 'Cancelled', 'Completed') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resource_id) REFERENCES resources(resource_id),
    FOREIGN KEY (reserved_by_employee) REFERENCES employees(employee_id),
    FOREIGN KEY (reserved_by_student) REFERENCES students(student_id)
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_type ENUM('student', 'employee', 'all') NOT NULL,
    recipient_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    type VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample data for rooms (CCSE - IDs 1-19)
INSERT INTO rooms (name, room_type, capacity, location) VALUES
('Computer Laboratory 1', 'lab', 40, 'CCSE Building 2nd Floor'),
('Computer Laboratory 2', 'lab', 40, 'CCSE Building 2nd Floor'),
('Computer Laboratory 3', 'lab', 40, 'CCSE Building 2nd Floor'),
('Computer Laboratory 4', 'lab', 40, 'CCSE Building 2nd Floor'),
('Computer Laboratory 5', 'lab', 40, 'CCSE Building 3rd Floor'),
('Computer Laboratory 6', 'lab', 40, 'CCSE Building 3rd Floor'),
('Lecture Room 101', 'lecture', 50, 'CCSE Building 1st Floor'),
('Lecture Room 102', 'lecture', 50, 'CCSE Building 1st Floor'),
('Lecture Room 103', 'lecture', 45, 'CCSE Building 1st Floor'),
('Lecture Room 201', 'lecture', 45, 'CCSE Building 2nd Floor'),
('Lecture Room 202', 'lecture', 45, 'CCSE Building 2nd Floor'),
('Lecture Room 301', 'lecture', 40, 'CCSE Building 3rd Floor'),
('Lecture Room 302', 'lecture', 40, 'CCSE Building 3rd Floor'),
('Project Lab', 'lab', 30, 'CCSE Building 2nd Floor'),
('Research Lab', 'lab', 20, 'CCSE Building 3rd Floor'),
('Multimedia Room', 'lecture', 40, 'CCSE Building 2nd Floor'),
('Conference Room', 'conference', 20, 'CCSE Building 1st Floor'),
('Smart Classroom', 'lecture', 35, 'CCSE Building 2nd Floor'),
('Innovation Hub', 'lab', 25, 'CCSE Building 3rd Floor');

-- Sample data for courses
INSERT INTO courses (course_code, name, credits, hours_per_week, requires_lab, duration_hours) VALUES
('CC111', 'Introduction to Computing', 3, 3, TRUE, 3),
('CC112', 'Computer Programming 1', 3, 3, TRUE, 3),
('CC113', 'Computer Programming 2', 3, 3, TRUE, 3),
('CC114', 'Data Structures and Algorithms', 3, 3, TRUE, 3),
('CC115', 'Database Management Systems', 3, 3, TRUE, 3),
('CC116', 'Web Development', 3, 3, TRUE, 3),
('CC117', 'Software Engineering', 3, 3, FALSE, 2),
('CC118', 'Operating Systems', 3, 3, TRUE, 3),
('CC119', 'Computer Networks', 3, 3, TRUE, 3),
('CC120', 'Information Security', 3, 3, FALSE, 2);