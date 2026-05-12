-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 07, 2026 at 05:14 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `scheduling_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `account_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` enum('Asset','Liability','Revenue','Expense') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`account_id`, `name`, `type`) VALUES
(1, 'CCSE Cash on Hand', 'Asset'),
(2, 'CCSE Cash in Bank - BDO', 'Asset'),
(3, 'CCSE Equipment Fund', 'Asset'),
(4, 'CCSE Lab Equipment', 'Asset'),
(5, 'CCSE Supplies Inventory', 'Asset'),
(6, 'CCSE Budget Allocation', 'Liability'),
(7, 'CCSE Laboratory Fees', 'Revenue'),
(8, 'CCSE Equipment Expenses', 'Expense'),
(9, 'CCSE Supplies Expense', 'Expense'),
(10, 'CCSE Maintenance Expense', 'Expense'),
(11, 'POLSCI Cash on Hand', 'Asset'),
(12, 'POLSCI Cash in Bank - BDO', 'Asset'),
(13, 'POLSCI Budget Allocation', 'Liability'),
(14, 'POLSCI Program Fees', 'Revenue'),
(15, 'POLSCI Seminar Expenses', 'Expense'),
(16, 'POLSCI Research Grant', 'Expense'),
(17, 'POLSCI Debate Program Fund', 'Expense'),
(18, 'CBA Cash on Hand', 'Asset'),
(19, 'CBA Cash in Bank - BDO', 'Asset'),
(20, 'CBA Equipment Fund', 'Asset'),
(21, 'CBA Business Lab Equipment', 'Asset'),
(22, 'CBA Supplies Inventory', 'Asset'),
(23, 'CBA Budget Allocation', 'Liability'),
(24, 'CBA Tuition Fees', 'Revenue'),
(25, 'CBA Equipment Expenses', 'Expense'),
(26, 'CBA Supplies Expense', 'Expense'),
(27, 'CBA Maintenance Expense', 'Expense'),
(28, 'CBA Marketing Expenses', 'Expense'),
(29, 'CBA Research Grant', 'Expense'),
(31, 'HKI Cash on Hand', 'Asset'),
(32, 'HKI Cash in Bank - BDO', 'Asset'),
(33, 'HKI Equipment Fund', 'Asset'),
(34, 'HKI Knowledge Lab Equipment', 'Asset'),
(35, 'HKI Supplies Inventory', 'Asset'),
(36, 'HKI Budget Allocation', 'Liability'),
(37, 'HKI Program Fees', 'Revenue'),
(38, 'HKI Equipment Expenses', 'Expense'),
(39, 'HKI Supplies Expense', 'Expense'),
(40, 'HKI Maintenance Expense', 'Expense'),
(41, 'HKI Research Grant Expense', 'Expense');

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `assignment_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `due_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `budgets`
--

CREATE TABLE `budgets` (
  `budget_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `year` year(4) NOT NULL,
  `allocated_amount` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `budgets`
--

INSERT INTO `budgets` (`budget_id`, `department_id`, `year`, `allocated_amount`) VALUES
(1, 1, '2026', 5000000.00),
(2, 2, '2026', 3500000.00),
(3, 3, '2026', 4200000.00),
(4, 4, '2026', 4800000.00);

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE `classes` (
  `class_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `section` varchar(10) DEFAULT NULL,
  `instructor_id` int(11) NOT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `year` year(4) DEFAULT NULL,
  `max_enrollment` int(11) DEFAULT NULL,
  `program_code` varchar(10) DEFAULT NULL COMMENT 'BSIT, BSIS, BSCS',
  `year_level` int(11) DEFAULT NULL COMMENT '1,2,3,4'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `classes`
--

INSERT INTO `classes` (`class_id`, `course_id`, `section`, `instructor_id`, `semester`, `year`, `max_enrollment`, `program_code`, `year_level`) VALUES
(1, 1, '1A', 1, '1st Semester', '2026', 40, 'BSIT', 1),
(2, 2, '1A', 2, '1st Semester', '2026', 40, 'BSIT', 1),
(3, 3, '1A', 3, '1st Semester', '2026', 40, 'BSIT', 1),
(4, 4, '1A', 4, '1st Semester', '2026', 40, 'BSIT', 1),
(5, 5, '1A', 5, '1st Semester', '2026', 40, 'BSIT', 1),
(6, 6, '1A', 6, '1st Semester', '2026', 40, 'BSIT', 1),
(7, 7, '1A', 7, '1st Semester', '2026', 40, 'BSIT', 1),
(8, 8, '1A', 8, '1st Semester', '2026', 40, 'BSIT', 1),
(9, 1, '1B', 9, '1st Semester', '2026', 40, 'BSIT', 1),
(10, 2, '1B', 10, '1st Semester', '2026', 40, 'BSIT', 1),
(11, 3, '1B', 11, '1st Semester', '2026', 40, 'BSIT', 1),
(12, 4, '1B', 12, '1st Semester', '2026', 40, 'BSIT', 1),
(13, 5, '1B', 13, '1st Semester', '2026', 40, 'BSIT', 1),
(14, 6, '1B', 14, '1st Semester', '2026', 40, 'BSIT', 1),
(15, 7, '1B', 15, '1st Semester', '2026', 40, 'BSIT', 1),
(16, 8, '1B', 16, '1st Semester', '2026', 40, 'BSIT', 1),
(17, 18, '2A', 17, '1st Semester', '2026', 40, 'BSIT', 2),
(18, 19, '2A', 18, '1st Semester', '2026', 40, 'BSIT', 2),
(19, 20, '2A', 19, '1st Semester', '2026', 40, 'BSIT', 2),
(20, 21, '2A', 20, '1st Semester', '2026', 40, 'BSIT', 2),
(21, 22, '2A', 21, '1st Semester', '2026', 40, 'BSIT', 2),
(22, 23, '2A', 22, '1st Semester', '2026', 40, 'BSIT', 2),
(23, 24, '2A', 23, '1st Semester', '2026', 40, 'BSIT', 2),
(24, 25, '2A', 24, '1st Semester', '2026', 40, 'BSIT', 2),
(25, 18, '2B', 25, '1st Semester', '2026', 40, 'BSIT', 2),
(26, 19, '2B', 26, '1st Semester', '2026', 40, 'BSIT', 2),
(27, 20, '2B', 27, '1st Semester', '2026', 40, 'BSIT', 2),
(28, 21, '2B', 28, '1st Semester', '2026', 40, 'BSIT', 2),
(29, 22, '2B', 29, '1st Semester', '2026', 40, 'BSIT', 2),
(30, 23, '2B', 30, '1st Semester', '2026', 40, 'BSIT', 2),
(31, 24, '2B', 31, '1st Semester', '2026', 40, 'BSIT', 2),
(32, 25, '2B', 32, '1st Semester', '2026', 40, 'BSIT', 2),
(33, 36, '3A', 33, '1st Semester', '2026', 35, 'BSIT', 3),
(34, 37, '3A', 34, '1st Semester', '2026', 35, 'BSIT', 3),
(35, 38, '3A', 35, '1st Semester', '2026', 35, 'BSIT', 3),
(36, 39, '3A', 36, '1st Semester', '2026', 35, 'BSIT', 3),
(37, 40, '3A', 37, '1st Semester', '2026', 35, 'BSIT', 3),
(38, 41, '3A', 38, '1st Semester', '2026', 35, 'BSIT', 3),
(39, 42, '3A', 39, '1st Semester', '2026', 35, 'BSIT', 3),
(40, 43, '3A', 40, '1st Semester', '2026', 35, 'BSIT', 3),
(41, 36, '3B', 41, '1st Semester', '2026', 35, 'BSIT', 3),
(42, 37, '3B', 42, '1st Semester', '2026', 35, 'BSIT', 3),
(43, 38, '3B', 43, '1st Semester', '2026', 35, 'BSIT', 3),
(44, 39, '3B', 44, '1st Semester', '2026', 35, 'BSIT', 3),
(45, 40, '3B', 45, '1st Semester', '2026', 35, 'BSIT', 3),
(46, 41, '3B', 46, '1st Semester', '2026', 35, 'BSIT', 3),
(47, 42, '3B', 47, '1st Semester', '2026', 35, 'BSIT', 3),
(48, 43, '3B', 48, '1st Semester', '2026', 35, 'BSIT', 3),
(49, 44, '4A', 49, '1st Semester', '2026', 30, 'BSIT', 4),
(50, 45, '4A', 50, '1st Semester', '2026', 30, 'BSIT', 4),
(51, 46, '4A', 51, '1st Semester', '2026', 30, 'BSIT', 4),
(52, 47, '4A', 52, '1st Semester', '2026', 30, 'BSIT', 4),
(53, 48, '4A', 53, '1st Semester', '2026', 30, 'BSIT', 4),
(54, 49, '4A', 54, '1st Semester', '2026', 30, 'BSIT', 4),
(55, 44, '4B', 55, '1st Semester', '2026', 30, 'BSIT', 4),
(56, 45, '4B', 56, '1st Semester', '2026', 30, 'BSIT', 4),
(57, 46, '4B', 57, '1st Semester', '2026', 30, 'BSIT', 4),
(58, 47, '4B', 58, '1st Semester', '2026', 30, 'BSIT', 4),
(59, 48, '4B', 59, '1st Semester', '2026', 30, 'BSIT', 4),
(60, 49, '4B', 60, '1st Semester', '2026', 30, 'BSIT', 4),
(61, 50, '1A', 61, '1st Semester', '2026', 40, 'BSPOLS', 1),
(62, 51, '1A', 62, '1st Semester', '2026', 40, 'BSPOLS', 1),
(63, 52, '1A', 63, '1st Semester', '2026', 40, 'BSPOLS', 1),
(64, 53, '1A', 64, '1st Semester', '2026', 40, 'BSPOLS', 1),
(65, 54, '1A', 65, '1st Semester', '2026', 40, 'BSPOLS', 1),
(66, 50, '1B', 66, '1st Semester', '2026', 40, 'BSPOLS', 1),
(67, 51, '1B', 67, '1st Semester', '2026', 40, 'BSPOLS', 1),
(68, 52, '1B', 68, '1st Semester', '2026', 40, 'BSPOLS', 1),
(69, 53, '1B', 69, '1st Semester', '2026', 40, 'BSPOLS', 1),
(70, 54, '1B', 70, '1st Semester', '2026', 40, 'BSPOLS', 1),
(71, 55, '2A', 71, '1st Semester', '2026', 40, 'BSPOLS', 2),
(72, 56, '2A', 72, '1st Semester', '2026', 40, 'BSPOLS', 2),
(73, 57, '2A', 73, '1st Semester', '2026', 40, 'BSPOLS', 2),
(74, 58, '2A', 74, '1st Semester', '2026', 40, 'BSPOLS', 2),
(75, 59, '2A', 75, '1st Semester', '2026', 40, 'BSPOLS', 2),
(76, 55, '2B', 61, '1st Semester', '2026', 40, 'BSPOLS', 2),
(77, 56, '2B', 62, '1st Semester', '2026', 40, 'BSPOLS', 2),
(78, 57, '2B', 63, '1st Semester', '2026', 40, 'BSPOLS', 2),
(79, 58, '2B', 64, '1st Semester', '2026', 40, 'BSPOLS', 2),
(80, 59, '2B', 65, '1st Semester', '2026', 40, 'BSPOLS', 2),
(81, 60, '3A', 66, '1st Semester', '2026', 35, 'BSPOLS', 3),
(82, 61, '3A', 67, '1st Semester', '2026', 35, 'BSPOLS', 3),
(83, 62, '3A', 68, '1st Semester', '2026', 35, 'BSPOLS', 3),
(84, 63, '3A', 69, '1st Semester', '2026', 35, 'BSPOLS', 3),
(85, 64, '3A', 70, '1st Semester', '2026', 35, 'BSPOLS', 3),
(86, 60, '3B', 71, '1st Semester', '2026', 35, 'BSPOLS', 3),
(87, 61, '3B', 72, '1st Semester', '2026', 35, 'BSPOLS', 3),
(88, 62, '3B', 73, '1st Semester', '2026', 35, 'BSPOLS', 3),
(89, 63, '3B', 74, '1st Semester', '2026', 35, 'BSPOLS', 3),
(90, 64, '3B', 75, '1st Semester', '2026', 35, 'BSPOLS', 3),
(91, 65, '4A', 61, '1st Semester', '2026', 30, 'BSPOLS', 4),
(92, 66, '4A', 62, '1st Semester', '2026', 30, 'BSPOLS', 4),
(93, 67, '4A', 63, '1st Semester', '2026', 30, 'BSPOLS', 4),
(94, 68, '4A', 64, '1st Semester', '2026', 30, 'BSPOLS', 4),
(95, 69, '4A', 65, '1st Semester', '2026', 30, 'BSPOLS', 4),
(96, 65, '4B', 66, '1st Semester', '2026', 30, 'BSPOLS', 4),
(97, 66, '4B', 67, '1st Semester', '2026', 30, 'BSPOLS', 4),
(98, 67, '4B', 68, '1st Semester', '2026', 30, 'BSPOLS', 4),
(99, 68, '4B', 69, '1st Semester', '2026', 30, 'BSPOLS', 4),
(100, 69, '4B', 70, '1st Semester', '2026', 30, 'BSPOLS', 4),
(101, 100, '1A', 76, '1st Semester', '2026', 40, 'BSBA', 1),
(102, 101, '1A', 77, '1st Semester', '2026', 40, 'BSBA', 1),
(103, 102, '1A', 78, '1st Semester', '2026', 40, 'BSBA', 1),
(104, 103, '1A', 79, '1st Semester', '2026', 40, 'BSBA', 1),
(105, 104, '1A', 80, '1st Semester', '2026', 40, 'BSBA', 1),
(106, 105, '1A', 81, '1st Semester', '2026', 40, 'BSBA', 1),
(107, 106, '1A', 82, '1st Semester', '2026', 40, 'BSBA', 1),
(108, 107, '1A', 83, '1st Semester', '2026', 40, 'BSBA', 1),
(109, 100, '1B', 84, '1st Semester', '2026', 40, 'BSBA', 1),
(110, 101, '1B', 85, '1st Semester', '2026', 40, 'BSBA', 1),
(111, 102, '1B', 86, '1st Semester', '2026', 40, 'BSBA', 1),
(112, 103, '1B', 87, '1st Semester', '2026', 40, 'BSBA', 1),
(113, 104, '1B', 88, '1st Semester', '2026', 40, 'BSBA', 1),
(114, 105, '1B', 89, '1st Semester', '2026', 40, 'BSBA', 1),
(115, 106, '1B', 90, '1st Semester', '2026', 40, 'BSBA', 1),
(116, 107, '1B', 91, '1st Semester', '2026', 40, 'BSBA', 1),
(117, 108, '2A', 92, '1st Semester', '2026', 40, 'BSBA', 2),
(118, 109, '2A', 93, '1st Semester', '2026', 40, 'BSBA', 2),
(119, 200, '2A', 94, '1st Semester', '2026', 40, 'BSBA', 2),
(120, 201, '2A', 95, '1st Semester', '2026', 40, 'BSBA', 2),
(121, 202, '2A', 76, '1st Semester', '2026', 40, 'BSBA', 2),
(122, 203, '2A', 77, '1st Semester', '2026', 40, 'BSBA', 2),
(123, 204, '2A', 78, '1st Semester', '2026', 40, 'BSBA', 2),
(124, 108, '2B', 79, '1st Semester', '2026', 40, 'BSBA', 2),
(125, 109, '2B', 80, '1st Semester', '2026', 40, 'BSBA', 2),
(126, 200, '2B', 81, '1st Semester', '2026', 40, 'BSBA', 2),
(127, 201, '2B', 82, '1st Semester', '2026', 40, 'BSBA', 2),
(128, 202, '2B', 83, '1st Semester', '2026', 40, 'BSBA', 2),
(129, 203, '2B', 84, '1st Semester', '2026', 40, 'BSBA', 2),
(130, 204, '2B', 85, '1st Semester', '2026', 40, 'BSBA', 2),
(131, 205, '3A', 86, '1st Semester', '2026', 35, 'BSBA', 3),
(132, 206, '3A', 87, '1st Semester', '2026', 35, 'BSBA', 3),
(133, 207, '3A', 88, '1st Semester', '2026', 35, 'BSBA', 3),
(134, 208, '3A', 89, '1st Semester', '2026', 35, 'BSBA', 3),
(135, 209, '3A', 90, '1st Semester', '2026', 35, 'BSBA', 3),
(136, 300, '3A', 91, '1st Semester', '2026', 35, 'BSBA', 3),
(137, 301, '3A', 92, '1st Semester', '2026', 35, 'BSBA', 3),
(138, 205, '3B', 93, '1st Semester', '2026', 35, 'BSBA', 3),
(139, 206, '3B', 94, '1st Semester', '2026', 35, 'BSBA', 3),
(140, 207, '3B', 95, '1st Semester', '2026', 35, 'BSBA', 3),
(141, 208, '3B', 76, '1st Semester', '2026', 35, 'BSBA', 3),
(142, 209, '3B', 77, '1st Semester', '2026', 35, 'BSBA', 3),
(143, 300, '3B', 78, '1st Semester', '2026', 35, 'BSBA', 3),
(144, 301, '3B', 79, '1st Semester', '2026', 35, 'BSBA', 3),
(145, 302, '4A', 80, '1st Semester', '2026', 30, 'BSBA', 4),
(146, 303, '4A', 81, '1st Semester', '2026', 30, 'BSBA', 4),
(147, 304, '4A', 82, '1st Semester', '2026', 30, 'BSBA', 4),
(148, 305, '4A', 83, '1st Semester', '2026', 30, 'BSBA', 4),
(149, 306, '4A', 84, '1st Semester', '2026', 30, 'BSBA', 4),
(150, 307, '4A', 85, '1st Semester', '2026', 30, 'BSBA', 4),
(151, 308, '4A', 86, '1st Semester', '2026', 30, 'BSBA', 4),
(152, 309, '4A', 87, '1st Semester', '2026', 30, 'BSBA', 4),
(153, 302, '4B', 88, '1st Semester', '2026', 30, 'BSBA', 4),
(154, 303, '4B', 89, '1st Semester', '2026', 30, 'BSBA', 4),
(155, 304, '4B', 90, '1st Semester', '2026', 30, 'BSBA', 4),
(156, 305, '4B', 91, '1st Semester', '2026', 30, 'BSBA', 4),
(157, 306, '4B', 92, '1st Semester', '2026', 30, 'BSBA', 4),
(158, 307, '4B', 93, '1st Semester', '2026', 30, 'BSBA', 4),
(159, 308, '4B', 94, '1st Semester', '2026', 30, 'BSBA', 4),
(160, 309, '4B', 95, '1st Semester', '2026', 30, 'BSBA', 4),
(161, 400, '1A', 96, '1st Semester', '2026', 40, 'BSHKI', 1),
(162, 401, '1A', 97, '1st Semester', '2026', 40, 'BSHKI', 1),
(163, 402, '1A', 98, '1st Semester', '2026', 40, 'BSHKI', 1),
(164, 403, '1A', 99, '1st Semester', '2026', 40, 'BSHKI', 1),
(165, 404, '1A', 100, '1st Semester', '2026', 40, 'BSHKI', 1),
(166, 405, '1A', 101, '1st Semester', '2026', 40, 'BSHKI', 1),
(167, 406, '1A', 102, '1st Semester', '2026', 40, 'BSHKI', 1),
(168, 407, '1A', 103, '1st Semester', '2026', 40, 'BSHKI', 1),
(169, 400, '1B', 104, '1st Semester', '2026', 40, 'BSHKI', 1),
(170, 401, '1B', 105, '1st Semester', '2026', 40, 'BSHKI', 1),
(171, 402, '1B', 106, '1st Semester', '2026', 40, 'BSHKI', 1),
(172, 403, '1B', 107, '1st Semester', '2026', 40, 'BSHKI', 1),
(173, 404, '1B', 108, '1st Semester', '2026', 40, 'BSHKI', 1),
(174, 405, '1B', 109, '1st Semester', '2026', 40, 'BSHKI', 1),
(175, 406, '1B', 110, '1st Semester', '2026', 40, 'BSHKI', 1),
(176, 407, '1B', 111, '1st Semester', '2026', 40, 'BSHKI', 1),
(177, 409, '2A', 112, '1st Semester', '2026', 40, 'BSHKI', 2),
(178, 410, '2A', 113, '1st Semester', '2026', 40, 'BSHKI', 2),
(179, 411, '2A', 114, '1st Semester', '2026', 40, 'BSHKI', 2),
(180, 412, '2A', 115, '1st Semester', '2026', 40, 'BSHKI', 2),
(181, 413, '2A', 96, '1st Semester', '2026', 40, 'BSHKI', 2),
(182, 414, '2A', 97, '1st Semester', '2026', 40, 'BSHKI', 2),
(183, 415, '2A', 98, '1st Semester', '2026', 40, 'BSHKI', 2),
(184, 416, '2A', 99, '1st Semester', '2026', 40, 'BSHKI', 2),
(185, 409, '2B', 100, '1st Semester', '2026', 40, 'BSHKI', 2),
(186, 410, '2B', 101, '1st Semester', '2026', 40, 'BSHKI', 2),
(187, 411, '2B', 102, '1st Semester', '2026', 40, 'BSHKI', 2),
(188, 412, '2B', 103, '1st Semester', '2026', 40, 'BSHKI', 2),
(189, 413, '2B', 104, '1st Semester', '2026', 40, 'BSHKI', 2),
(190, 414, '2B', 105, '1st Semester', '2026', 40, 'BSHKI', 2),
(191, 415, '2B', 106, '1st Semester', '2026', 40, 'BSHKI', 2),
(192, 416, '2B', 107, '1st Semester', '2026', 40, 'BSHKI', 2),
(193, 417, '3A', 108, '1st Semester', '2026', 35, 'BSHKI', 3),
(194, 418, '3A', 109, '1st Semester', '2026', 35, 'BSHKI', 3),
(195, 419, '3A', 110, '1st Semester', '2026', 35, 'BSHKI', 3),
(196, 420, '3A', 111, '1st Semester', '2026', 35, 'BSHKI', 3),
(197, 421, '3A', 112, '1st Semester', '2026', 35, 'BSHKI', 3),
(198, 422, '3A', 113, '1st Semester', '2026', 35, 'BSHKI', 3),
(199, 423, '3A', 114, '1st Semester', '2026', 35, 'BSHKI', 3),
(200, 424, '3A', 115, '1st Semester', '2026', 35, 'BSHKI', 3),
(201, 417, '3B', 96, '1st Semester', '2026', 35, 'BSHKI', 3),
(202, 418, '3B', 97, '1st Semester', '2026', 35, 'BSHKI', 3),
(203, 419, '3B', 98, '1st Semester', '2026', 35, 'BSHKI', 3),
(204, 420, '3B', 99, '1st Semester', '2026', 35, 'BSHKI', 3),
(205, 421, '3B', 100, '1st Semester', '2026', 35, 'BSHKI', 3),
(206, 422, '3B', 101, '1st Semester', '2026', 35, 'BSHKI', 3),
(207, 423, '3B', 102, '1st Semester', '2026', 35, 'BSHKI', 3),
(208, 424, '3B', 103, '1st Semester', '2026', 35, 'BSHKI', 3),
(209, 425, '4A', 104, '1st Semester', '2026', 30, 'BSHKI', 4),
(210, 426, '4A', 105, '1st Semester', '2026', 30, 'BSHKI', 4),
(211, 427, '4A', 106, '1st Semester', '2026', 30, 'BSHKI', 4),
(212, 428, '4A', 107, '1st Semester', '2026', 30, 'BSHKI', 4),
(213, 429, '4A', 108, '1st Semester', '2026', 30, 'BSHKI', 4),
(214, 430, '4A', 109, '1st Semester', '2026', 30, 'BSHKI', 4),
(215, 425, '4B', 110, '1st Semester', '2026', 30, 'BSHKI', 4),
(216, 426, '4B', 111, '1st Semester', '2026', 30, 'BSHKI', 4),
(217, 427, '4B', 112, '1st Semester', '2026', 30, 'BSHKI', 4),
(218, 428, '4B', 113, '1st Semester', '2026', 30, 'BSHKI', 4),
(219, 429, '4B', 114, '1st Semester', '2026', 30, 'BSHKI', 4),
(220, 430, '4B', 115, '1st Semester', '2026', 30, 'BSHKI', 4);

--
-- Triggers `classes`
--
DELIMITER $$
CREATE TRIGGER `trg_enforce_instructor_dept_insert` BEFORE INSERT ON `classes` FOR EACH ROW BEGIN
    DECLARE v_instructor_dept INT;
    DECLARE v_course_dept INT;
    
    -- Get instructor's department
    SELECT department_id INTO v_instructor_dept
    FROM employees
    WHERE employee_id = NEW.instructor_id;
    
    -- Determine course's department
    SET v_course_dept = CASE 
        WHEN NEW.course_id BETWEEN 1 AND 49 THEN 1
        WHEN NEW.course_id BETWEEN 50 AND 99 THEN 2
        WHEN NEW.course_id BETWEEN 100 AND 399 THEN 3
        WHEN NEW.course_id BETWEEN 400 AND 430 THEN 4
    END;
    
    -- Enforce constraint
    IF v_instructor_dept != v_course_dept THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'ERROR: Instructor must be from the same department as the course.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_enforce_instructor_dept_update` BEFORE UPDATE ON `classes` FOR EACH ROW BEGIN
    DECLARE v_instructor_dept INT;
    DECLARE v_course_dept INT;
    
    -- Only check if instructor_id is being changed
    IF NEW.instructor_id != OLD.instructor_id THEN
        -- Get instructor's department
        SELECT department_id INTO v_instructor_dept
        FROM employees
        WHERE employee_id = NEW.instructor_id;
        
        -- Determine course's department
        SET v_course_dept = CASE 
            WHEN NEW.course_id BETWEEN 1 AND 49 THEN 1
            WHEN NEW.course_id BETWEEN 50 AND 99 THEN 2
            WHEN NEW.course_id BETWEEN 100 AND 399 THEN 3
            WHEN NEW.course_id BETWEEN 400 AND 430 THEN 4
        END;
        
        -- Enforce constraint
        IF v_instructor_dept != v_course_dept THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'ERROR: Instructor must be from the same department as the course.';
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `credits` int(11) DEFAULT NULL,
  `hours_per_week` int(11) DEFAULT 3 COMMENT 'Total hours needed per week',
  `requires_lab` tinyint(1) DEFAULT 0 COMMENT 'Does this course need a lab room?',
  `duration_hours` int(11) DEFAULT 3 COMMENT 'Hours per meeting'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `course_code`, `name`, `description`, `credits`, `hours_per_week`, `requires_lab`, `duration_hours`) VALUES
(1, 'CC111', 'Introduction to Computing', 'Introduction to computing concepts, history of computers, hardware, software, and basic computer applications', 3, 3, 1, 3),
(2, 'CC112', 'Computer Programming 1', 'Fundamentals of programming using C++: variables, control structures, functions, arrays, and basic algorithms', 3, 3, 1, 3),
(3, 'FIL101', 'Kontekstwalisadong Komunikasyon sa Filipino', 'Pag-aaral sa komunikasyon sa kontekstong Filipino', 3, 3, 0, 2),
(4, 'GE101', 'Understanding the Self', 'Exploration of self-identity, personal development, and understanding one\'s self', 3, 3, 0, 2),
(5, 'GE102', 'Readings in Philippine History', 'Analysis of primary sources in Philippine history and critical thinking about historical narratives', 3, 3, 0, 2),
(6, 'LITE', 'Living in IT Era', 'Understanding the digital age, IT trends, and the impact of technology on society', 3, 3, 0, 2),
(7, 'NSTP1', 'CWTS/LTS/ROTC', 'National Service Training Program 1 - Civic Welfare Training Service', 3, 3, 0, 2),
(8, 'PE1', 'PATHFit 1 - Movement Competency Training', 'Physical education focusing on fundamental movement skills and fitness concepts', 2, 2, 0, 2),
(18, 'CC214', 'Data Structures and Algorithm', 'Advanced data structures: trees, graphs, sorting, searching, and algorithm analysis', 3, 3, 1, 3),
(19, 'GE105', 'Arts Appreciation', 'Introduction to visual arts, music, theater, and dance appreciation', 3, 3, 0, 2),
(20, 'GE106', 'Science, Technology & Society', 'Interplay between science, technology, and social development', 3, 3, 0, 2),
(21, 'GenSoc', 'Gender and Society', 'Gender studies, gender equality, and social issues', 3, 3, 0, 2),
(22, 'IM211', 'Fundamentals of Database System', 'Database concepts, SQL, normalization, and database design', 3, 3, 1, 3),
(23, 'ITELECTV1', 'Object-Oriented Programming', 'OOP concepts: classes, inheritance, polymorphism, and design patterns using Java', 3, 3, 1, 3),
(24, 'MS121', 'Discrete Mathematics', 'Mathematical logic, sets, relations, combinatorics, and graph theory', 3, 3, 0, 3),
(25, 'Net212', 'Networking 1', 'Introduction to computer networks: OSI model, TCP/IP, network topologies', 3, 3, 1, 3),
(36, 'GE108', 'Ethics', 'Ethical theories, moral reasoning, and professional ethics', 3, 3, 0, 2),
(37, 'GE109', 'Life and Works of Rizal', 'Study of Jose Rizal\'s life, writings, and contributions to nation-building', 3, 3, 0, 2),
(38, 'ITElectv3', 'Project Management', 'Project planning, execution, monitoring, and control using PM methodologies', 3, 3, 0, 3),
(39, 'ITProfEL1', 'Advanced Software Development', 'Software engineering principles, design patterns, and development methodologies', 3, 3, 1, 3),
(40, 'ITProfEL2', 'Open Source Programming', 'Open source technologies, Linux, PHP, Python, and open source development', 3, 3, 1, 3),
(41, 'MOR311', 'Methods of Research for IT/IS', 'Research methodologies, quantitative and qualitative research for IT', 3, 3, 0, 3),
(42, 'SIA311', 'System Integration and Architecture 1', 'System architecture, integration patterns, and enterprise application integration', 3, 3, 1, 3),
(43, 'Technopre', 'Technopreneurship', 'Technology entrepreneurship, business models, and startup development', 3, 3, 0, 3),
(44, 'Capstone1', 'Capstone Project 1', 'Project proposal, planning, and initial development for capstone project', 3, 3, 1, 3),
(45, 'CC326', 'Application Development and Emerging Technologies', 'Development using emerging technologies: mobile, web, cloud, and AI', 3, 3, 1, 3),
(46, 'IAS321', 'Information Assurance and Security 1', 'Security principles, cryptography, network security, and risk management', 3, 3, 0, 3),
(47, 'ITElectv4', 'System Administration and Maintenance', 'System administration, server management, and IT infrastructure maintenance', 3, 3, 1, 3),
(48, 'ITProfEL3', 'Client Server Technologies and Application', 'Client-server architecture, distributed systems, and web services', 3, 3, 1, 3),
(49, 'ITProfEL4', 'UML Based Software Development', 'Object-oriented analysis and design using UML', 3, 3, 0, 3),
(50, 'PS101', 'Introduction to Political Science', 'Fundamental concepts of political science: state, government, sovereignty, and political ideologies', 3, 3, 0, 3),
(51, 'PS102', 'Philippine Government and Constitution', 'Study of the Philippine political system, branches of government, and the 1987 Constitution', 3, 3, 0, 3),
(52, 'PS103', 'Political Theory and Ideologies', 'Major political theories: liberalism, conservatism, socialism, fascism, and contemporary ideologies', 3, 3, 0, 3),
(53, 'PS104', 'Comparative Government and Politics', 'Comparative analysis of different political systems, institutions, and processes worldwide', 3, 3, 0, 3),
(54, 'PS105', 'International Relations', 'Study of interactions between states, international organizations, diplomacy, and global issues', 3, 3, 0, 3),
(55, 'PS106', 'Public Administration', 'Principles of public administration, bureaucracy, policy implementation, and governance', 3, 3, 0, 3),
(56, 'PS107', 'Political Analysis and Research Methods', 'Quantitative and qualitative research methods for political science', 3, 3, 1, 3),
(57, 'PS108', 'Local Governance and Regional Administration', 'Study of local government units, decentralization, and regional development', 3, 3, 0, 3),
(58, 'PS109', 'Political Economy', 'Relationship between politics and economics, development theories, and global political economy', 3, 3, 0, 3),
(59, 'PS110', 'Human Rights and Social Justice', 'Human rights frameworks, constitutional rights, and social justice issues in the Philippines', 3, 3, 0, 3),
(60, 'PS111', 'Foreign Policy Analysis', 'Analysis of Philippine foreign policy, diplomatic relations, and international engagements', 3, 3, 0, 3),
(61, 'PS112', 'Electoral Politics and Political Parties', 'Study of electoral systems, party politics, campaign strategies, and voting behavior', 3, 3, 0, 3),
(62, 'PS201', 'Advanced Political Theory', 'In-depth study of classical and contemporary political philosophers', 3, 3, 0, 3),
(63, 'PS202', 'Public Policy Analysis', 'Policy formulation, implementation, evaluation, and case studies of Philippine policies', 3, 3, 0, 3),
(64, 'PS203', 'Philippine Foreign Relations', 'Detailed study of Philippines\' relations with ASEAN, US, China, Japan, and other nations', 3, 3, 0, 3),
(65, 'PS204', 'Conflict Resolution and Peace Studies', 'Theories of conflict, negotiation, mediation, and peacebuilding', 3, 3, 0, 3),
(66, 'PS205', 'Political Sociology', 'Relationship between politics and society, social movements, and political participation', 3, 3, 0, 3),
(67, 'PS206', 'Constitutional Law', 'Philippine constitutional law, judicial review, and landmark Supreme Court cases', 3, 3, 0, 3),
(68, 'PS207', 'Gender and Politics', 'Gender issues in politics, women\'s representation, and feminist political theory', 3, 3, 0, 3),
(69, 'PS208', 'Environmental Politics and Policy', 'Environmental governance, climate change policy, and sustainable development', 3, 3, 0, 3),
(70, 'PS209', 'Political Communication', 'Media and politics, political propaganda, public opinion, and digital democracy', 3, 3, 0, 3),
(71, 'PS301', 'Research Seminar in Political Science', 'Advanced research and thesis writing in political science', 3, 3, 0, 3),
(72, 'PS302', 'Internship and Practicum', 'On-the-job training in government agencies, NGOs, or legislative offices', 3, 3, 0, 3),
(73, 'PS303', 'Capstone Project in Political Science', 'Comprehensive project applying political science concepts to real-world issues', 3, 3, 1, 3),
(100, 'BA101', 'Introduction to Business', 'Fundamentals of business, business environment, and basic business concepts', 3, 3, 0, 3),
(101, 'BA102', 'Financial Accounting', 'Basic accounting principles, financial statements, and accounting cycle', 3, 3, 1, 3),
(102, 'BA103', 'Business Mathematics', 'Mathematics for business: interest, annuities, loans, investments', 3, 3, 0, 3),
(103, 'BA104', 'Principles of Management', 'Management functions: planning, organizing, leading, controlling', 3, 3, 0, 3),
(104, 'BA105', 'Business Communication', 'Effective business writing, presentations, and interpersonal communication', 3, 3, 0, 3),
(105, 'BA106', 'Microeconomics', 'Economic principles: supply and demand, market structures, consumer behavior', 3, 3, 0, 3),
(106, 'BA107', 'Macroeconomics', 'National income, inflation, unemployment, fiscal and monetary policy', 3, 3, 0, 3),
(107, 'BA108', 'Marketing Management', 'Marketing principles, consumer behavior, product, price, place, promotion', 3, 3, 0, 3),
(108, 'BA109', 'Human Resource Management', 'HR functions: recruitment, training, performance evaluation, compensation', 3, 3, 0, 3),
(109, 'BA110', 'Business Law', 'Legal aspects of business: contracts, partnerships, corporations', 3, 3, 0, 3),
(200, 'BA201', 'Financial Management', 'Financial analysis, capital budgeting, working capital management', 3, 3, 1, 3),
(201, 'BA202', 'Operations Management', 'Production planning, quality control, supply chain management', 3, 3, 0, 3),
(202, 'BA203', 'Managerial Accounting', 'Cost accounting, budgeting, variance analysis, decision making', 3, 3, 1, 3),
(203, 'BA204', 'Organizational Behavior', 'Individual and group behavior in organizations, leadership, motivation', 3, 3, 0, 3),
(204, 'BA205', 'Business Statistics', 'Statistical methods for business: descriptive stats, probability, inference', 3, 3, 1, 3),
(205, 'BA206', 'Strategic Management', 'Strategic planning, competitive analysis, corporate strategy', 3, 3, 0, 3),
(206, 'BA207', 'Entrepreneurship', 'Business planning, opportunity recognition, startup management', 3, 3, 0, 3),
(207, 'BA208', 'International Business', 'Global trade, foreign exchange, multinational corporations', 3, 3, 0, 3),
(208, 'BA209', 'Business Ethics', 'Ethical issues in business, CSR, corporate governance', 3, 3, 0, 3),
(209, 'BA210', 'Business Research Methods', 'Research design, data collection, analysis for business research', 3, 3, 1, 3),
(300, 'BA301', 'Investment and Portfolio Management', 'Stocks, bonds, securities analysis, portfolio theory', 3, 3, 0, 3),
(301, 'BA302', 'Business Analytics', 'Data analytics for business decision making, data visualization', 3, 3, 1, 3),
(302, 'BA303', 'Supply Chain Management', 'Logistics, procurement, inventory management, distribution', 3, 3, 0, 3),
(303, 'BA304', 'Corporate Finance', 'Capital structure, dividend policy, mergers and acquisitions', 3, 3, 0, 3),
(304, 'BA305', 'Digital Marketing', 'Social media marketing, SEO, email marketing, online advertising', 3, 3, 1, 3),
(305, 'BA306', 'Financial Derivatives', 'Options, futures, swaps, risk management', 3, 3, 0, 3),
(306, 'BA307', 'Business Consulting', 'Consulting frameworks, problem solving, client management', 3, 3, 0, 3),
(307, 'BA308', 'Project Management for Business', 'Project planning, execution, monitoring, agile methods', 3, 3, 0, 3),
(308, 'BA309', 'Business Internship', 'On-the-job training in business organizations', 3, 3, 0, 3),
(309, 'BA310', 'Business Capstone', 'Integrated business simulation and strategic project', 3, 3, 1, 3),
(400, 'HKI101', 'Introduction to Knowledge Science', 'Foundations of knowledge representation, cognitive science, and information theory', 3, 3, 0, 3),
(401, 'HKI102', 'Cognitive Psychology', 'Study of mental processes: perception, memory, reasoning, and decision making', 3, 3, 0, 3),
(402, 'HKI103', 'Logic and Critical Thinking', 'Formal logic, argumentation, fallacies, and analytical reasoning', 3, 3, 0, 3),
(403, 'HKI104', 'Knowledge Management Fundamentals', 'Principles of capturing, organizing, and sharing organizational knowledge', 3, 3, 1, 3),
(404, 'HKI105', 'Kontekstwalisadong Komunikasyon sa Filipino', 'Pag-aaral sa komunikasyon sa kontekstong Filipino', 3, 3, 0, 2),
(405, 'HKI106', 'Understanding the Self', 'Exploration of self-identity, personal development, and understanding one\'s self', 3, 3, 0, 2),
(406, 'HKI107', 'Readings in Philippine History', 'Analysis of primary sources in Philippine history and critical thinking about historical narratives', 3, 3, 0, 2),
(407, 'HKI108', 'CWTS/LTS/ROTC', 'National Service Training Program 1 - Civic Welfare Training Service', 3, 3, 0, 2),
(408, 'HKI109', 'PATHFit 1 - Movement Competency Training', 'Physical education focusing on fundamental movement skills and fitness concepts', 2, 2, 0, 2),
(409, 'HKI201', 'Data Mining and Knowledge Discovery', 'Techniques for extracting patterns and knowledge from large datasets', 3, 3, 1, 3),
(410, 'HKI202', 'Information Architecture', 'Design and organization of information systems for optimal findability and usability', 3, 3, 1, 3),
(411, 'HKI203', 'Human-Computer Interaction', 'Design principles for user-centered systems and interfaces', 3, 3, 1, 3),
(412, 'HKI204', 'Research Methods in Knowledge Science', 'Qualitative and quantitative research methods for knowledge studies', 3, 3, 0, 3),
(413, 'HKI205', 'Arts Appreciation', 'Introduction to visual arts, music, theater, and dance appreciation', 3, 3, 0, 2),
(414, 'HKI206', 'Science, Technology & Society', 'Interplay between science, technology, and social development', 3, 3, 0, 2),
(415, 'HKI207', 'Gender and Society', 'Gender studies, gender equality, and social issues', 3, 3, 0, 2),
(416, 'HKI208', 'Discrete Mathematics', 'Mathematical logic, sets, relations, combinatorics, and graph theory', 3, 3, 0, 3),
(417, 'HKI301', 'Artificial Intelligence in Knowledge Systems', 'AI techniques for knowledge representation, reasoning, and learning', 3, 3, 1, 3),
(418, 'HKI302', 'Semantic Web and Ontologies', 'Building semantic web applications and ontology engineering', 3, 3, 1, 3),
(419, 'HKI303', 'Knowledge Visualization', 'Visual representation of complex knowledge and data', 3, 3, 1, 3),
(420, 'HKI304', 'Organizational Learning', 'Theories and practices of learning organizations and knowledge transfer', 3, 3, 0, 3),
(421, 'HKI305', 'Ethics', 'Ethical theories, moral reasoning, and professional ethics', 3, 3, 0, 2),
(422, 'HKI306', 'Life and Works of Rizal', 'Study of Jose Rizal\'s life, writings, and contributions to nation-building', 3, 3, 0, 2),
(423, 'HKI307', 'Text Mining and Natural Language Processing', 'Extracting knowledge from unstructured text data', 3, 3, 1, 3),
(424, 'HKI308', 'Methods of Research for HKI', 'Advanced research methodologies for knowledge intelligence', 3, 3, 0, 3),
(425, 'HKI401', 'Capstone Project 1', 'Project proposal, planning, and initial development for knowledge systems', 3, 3, 1, 3),
(426, 'HKI402', 'Knowledge Engineering', 'Design and implementation of knowledge-based systems', 3, 3, 1, 3),
(427, 'HKI403', 'Decision Support Systems', 'Systems that support business and organizational decision making', 3, 3, 1, 3),
(428, 'HKI404', 'Knowledge Audit and Assessment', 'Methods for evaluating knowledge assets and intellectual capital', 3, 3, 0, 3),
(429, 'HKI405', 'Collaborative Intelligence', 'Technologies and practices for group knowledge work and collaboration', 3, 3, 0, 3),
(430, 'HKI406', 'Knowledge Economy and Innovation', 'Role of knowledge in economic development and innovation systems', 3, 3, 0, 3);

-- --------------------------------------------------------

--
-- Table structure for table `course_prerequisites`
--

CREATE TABLE `course_prerequisites` (
  `prereq_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL COMMENT 'Course that requires prerequisites',
  `prerequisite_course_id` int(11) NOT NULL COMMENT 'Course that must be taken first'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course_prerequisites`
--

INSERT INTO `course_prerequisites` (`prereq_id`, `course_id`, `prerequisite_course_id`) VALUES
(1, 18, 2),
(2, 22, 18),
(3, 23, 18),
(4, 25, 2),
(5, 39, 23),
(6, 40, 23),
(7, 44, 39),
(8, 45, 40),
(9, 49, 23),
(10, 18, 2),
(11, 22, 18),
(12, 23, 18),
(13, 25, 2),
(14, 39, 23),
(15, 40, 23),
(16, 44, 39),
(17, 45, 40),
(18, 49, 23),
(19, 18, 2),
(20, 22, 18),
(21, 23, 18),
(22, 25, 2),
(23, 39, 23),
(24, 40, 23),
(25, 44, 39),
(26, 45, 40),
(27, 49, 23);

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `department_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`department_id`, `name`) VALUES
(1, 'Computing Science and Engineering - CCSE (Computer Science Building)'),
(2, 'Political Science - POLSCI (Social Sciences Building)'),
(3, 'Business Administration - CBA (Business Building)'),
(4, 'Human Knowledge Intelligence - HKI (Humanities Building)');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `position_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('M','F','Other') DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `salary` decimal(12,2) DEFAULT NULL,
  `is_faculty` tinyint(1) DEFAULT 0,
  `max_hours_per_week` int(11) DEFAULT 24 COMMENT 'Maximum teaching hours per week'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `department_id`, `position_id`, `first_name`, `last_name`, `dob`, `gender`, `email`, `hire_date`, `salary`, `is_faculty`, `max_hours_per_week`) VALUES
(1, 1, 3, 'Dr. Maria', 'Santos', '1970-05-15', 'F', 'maria.santos@ccse.edu.ph', '2005-06-01', 95000.00, 1, 24),
(2, 1, 3, 'Dr. Jose', 'Reyes', '1972-08-22', 'M', 'jose.reyes@ccse.edu.ph', '2006-08-15', 92000.00, 1, 24),
(3, 1, 3, 'Dr. Ana', 'Villanueva', '1975-11-10', 'F', 'ana.villanueva@ccse.edu.ph', '2008-01-10', 89000.00, 1, 24),
(4, 1, 2, 'Prof. Roberto', 'Garcia', '1978-03-18', 'M', 'roberto.garcia@ccse.edu.ph', '2010-03-20', 78000.00, 1, 24),
(5, 1, 2, 'Prof. Carmen', 'Fernandez', '1980-09-25', 'F', 'carmen.fernandez@ccse.edu.ph', '2011-11-05', 76000.00, 1, 24),
(6, 1, 2, 'Prof. Michael', 'Tan', '1982-02-28', 'M', 'michael.tan@ccse.edu.ph', '2012-07-12', 75000.00, 1, 24),
(7, 1, 2, 'Prof. Patricia', 'Lim', '1985-12-03', 'F', 'patricia.lim@ccse.edu.ph', '2014-09-01', 68000.00, 1, 24),
(8, 1, 2, 'Prof. Daniel', 'Aquino', '1987-06-14', 'M', 'daniel.aquino@ccse.edu.ph', '2015-01-15', 66000.00, 1, 24),
(9, 1, 2, 'Prof. Ramon', 'Mercado', '1984-04-12', 'M', 'ramon.mercado@ccse.edu.ph', '2013-08-01', 69000.00, 1, 24),
(10, 1, 2, 'Prof. Jennifer', 'Rivera', '1986-07-23', 'F', 'jennifer.rivera@ccse.edu.ph', '2014-06-15', 67000.00, 1, 24),
(11, 1, 1, 'Prof. Victor', 'Lazaro', '1988-11-08', 'M', 'victor.lazaro@ccse.edu.ph', '2016-01-10', 58000.00, 1, 24),
(12, 1, 1, 'Prof. Cristina', 'Ramos', '1987-09-17', 'F', 'cristina.ramos@ccse.edu.ph', '2015-08-20', 59000.00, 1, 24),
(13, 1, 1, 'Prof. Emmanuel', 'Gonzales', '1983-05-29', 'M', 'emmanuel.gonzales@ccse.edu.ph', '2012-06-01', 62000.00, 1, 24),
(14, 1, 1, 'Prof. Theresa', 'Manalo', '1990-02-14', 'F', 'theresa.manalo@ccse.edu.ph', '2017-01-15', 55000.00, 1, 24),
(15, 1, 1, 'Prof. George', 'Bernardo', '1981-10-30', 'M', 'george.bernardo@ccse.edu.ph', '2011-05-10', 64000.00, 1, 24),
(16, 1, 1, 'Prof. Mark', 'Santiago', '1985-08-30', 'M', 'mark.santiago@ccse.edu.ph', '2016-06-15', 52000.00, 1, 24),
(17, 1, 1, 'Prof. John', 'Dela Cruz', '1988-02-14', 'M', 'john.delacruz@ccse.edu.ph', '2017-03-10', 54000.00, 1, 24),
(18, 1, 1, 'Prof. Alice', 'Mendoza', '1985-03-15', 'F', 'alice.mendoza@ccse.edu.ph', '2015-06-01', 58000.00, 1, 24),
(19, 1, 1, 'Prof. Brian', 'Torres', '1987-07-22', 'M', 'brian.torres@ccse.edu.ph', '2016-08-15', 56000.00, 1, 24),
(20, 1, 1, 'Prof. Carla', 'Dimagiba', '1989-11-10', 'F', 'carla.dimagiba@ccse.edu.ph', '2017-01-10', 54000.00, 1, 24),
(21, 1, 1, 'Prof. Dennis', 'Reyes', '1986-09-18', 'M', 'dennis.reyes@ccse.edu.ph', '2015-03-20', 59000.00, 1, 24),
(22, 1, 1, 'Prof. Elena', 'Santos', '1990-12-25', 'F', 'elena.santos@ccse.edu.ph', '2018-06-05', 53000.00, 1, 24),
(23, 1, 1, 'Prof. Francis', 'Luna', '1988-05-30', 'M', 'francis.luna@ccse.edu.ph', '2016-11-12', 57000.00, 1, 24),
(24, 1, 1, 'Prof. Grace', 'Aquino', '1991-08-14', 'F', 'grace.aquino@ccse.edu.ph', '2019-07-01', 52000.00, 1, 24),
(25, 1, 1, 'Prof. Henry', 'Cruz', '1985-10-20', 'M', 'henry.cruz@ccse.edu.ph', '2014-09-15', 60000.00, 1, 24),
(26, 1, 1, 'Prof. Isabel', 'Garcia', '1992-02-28', 'F', 'isabel.garcia@ccse.edu.ph', '2020-01-10', 51000.00, 1, 24),
(27, 1, 1, 'Prof. Jerome', 'Villanueva', '1987-06-12', 'M', 'jerome.villanueva@ccse.edu.ph', '2016-04-20', 58000.00, 1, 24),
(28, 1, 1, 'Prof. Karen', 'Ramos', '1989-09-05', 'F', 'karen.ramos@ccse.edu.ph', '2017-08-01', 55000.00, 1, 24),
(29, 1, 1, 'Prof. Leo', 'Fernandez', '1986-01-17', 'M', 'leo.fernandez@ccse.edu.ph', '2015-05-10', 59000.00, 1, 24),
(30, 1, 1, 'Prof. Mara', 'Gonzales', '1990-04-22', 'F', 'mara.gonzales@ccse.edu.ph', '2018-02-15', 54000.00, 1, 24),
(31, 1, 1, 'Prof. Nico', 'Perez', '1988-07-08', 'M', 'nico.perez@ccse.edu.ph', '2016-10-01', 56000.00, 1, 24),
(32, 1, 1, 'Prof. Olive', 'Romero', '1991-11-19', 'F', 'olive.romero@ccse.edu.ph', '2019-03-20', 53000.00, 1, 24),
(33, 1, 1, 'Prof. Paul', 'Rivera', '1987-04-12', 'M', 'paul.rivera@ccse.edu.ph', '2015-07-15', 57000.00, 1, 24),
(34, 1, 1, 'Prof. Queenie', 'Sison', '1990-08-08', 'F', 'queenie.sison@ccse.edu.ph', '2017-11-20', 54000.00, 1, 24),
(35, 1, 1, 'Prof. Randy', 'Valdez', '1986-12-01', 'M', 'randy.valdez@ccse.edu.ph', '2014-09-10', 61000.00, 1, 24),
(36, 1, 1, 'Prof. Sarah', 'Lopez', '1989-03-25', 'F', 'sarah.lopez@ccse.edu.ph', '2016-06-18', 55000.00, 1, 24),
(37, 1, 1, 'Prof. Timothy', 'Magsino', '1985-10-14', 'M', 'timothy.magsino@ccse.edu.ph', '2013-04-22', 63000.00, 1, 24),
(38, 1, 1, 'Prof. Ursula', 'David', '1991-01-07', 'F', 'ursula.david@ccse.edu.ph', '2018-08-14', 52000.00, 1, 24),
(39, 1, 1, 'Prof. Vincent', 'Castro', '1988-06-19', 'M', 'vincent.castro@ccse.edu.ph', '2015-12-03', 58000.00, 1, 24),
(40, 1, 1, 'Prof. Wendy', 'Alcantara', '1990-09-11', 'F', 'wendy.alcantara@ccse.edu.ph', '2017-03-27', 55000.00, 1, 24),
(41, 1, 1, 'Prof. Xavier', 'Manuel', '1987-11-29', 'M', 'xavier.manuel@ccse.edu.ph', '2014-10-19', 59000.00, 1, 24),
(42, 1, 1, 'Prof. Yvonne', 'Salazar', '1989-07-16', 'F', 'yvonne.salazar@ccse.edu.ph', '2016-05-24', 56000.00, 1, 24),
(43, 1, 1, 'Prof. Zachary', 'Molina', '1986-02-23', 'M', 'zachary.molina@ccse.edu.ph', '2013-09-08', 62000.00, 1, 24),
(44, 1, 1, 'Prof. Angela', 'Pascual', '1992-04-30', 'F', 'angela.pascual@ccse.edu.ph', '2019-01-15', 51000.00, 1, 24),
(45, 1, 1, 'Prof. Benjamin', 'Estrada', '1988-08-27', 'M', 'benjamin.estrada@ccse.edu.ph', '2015-11-11', 57000.00, 1, 24),
(46, 1, 1, 'Prof. Catherine', 'Guevarra', '1990-12-09', 'F', 'catherine.guevarra@ccse.edu.ph', '2017-07-06', 54000.00, 1, 24),
(47, 1, 1, 'Prof. Dominic', 'Villanueva', '1987-05-18', 'M', 'dominic.villanueva@ccse.edu.ph', '2014-03-14', 60000.00, 1, 24),
(48, 1, 1, 'Prof. Erica', 'Bautista', '1991-09-22', 'F', 'erica.bautista@ccse.edu.ph', '2018-10-09', 53000.00, 1, 24),
(49, 1, 1, 'Prof. Ferdinand', 'Marcos', '1985-01-04', 'M', 'ferdinand.marcos@ccse.edu.ph', '2012-08-30', 65000.00, 1, 24),
(50, 1, 1, 'Prof. Gina', 'Aquino', '1989-06-13', 'F', 'gina.aquino@ccse.edu.ph', '2016-04-05', 56000.00, 1, 24),
(51, 1, 1, 'Prof. Harold', 'Lim', '1988-02-26', 'M', 'harold.lim@ccse.edu.ph', '2015-10-22', 58000.00, 1, 24),
(52, 1, 1, 'Prof. Irene', 'Chua', '1990-11-17', 'F', 'irene.chua@ccse.edu.ph', '2017-12-13', 54000.00, 1, 24),
(53, 1, 1, 'Prof. Jeffrey', 'Ong', '1987-07-07', 'M', 'jeffrey.ong@ccse.edu.ph', '2014-05-19', 59000.00, 1, 24),
(54, 1, 1, 'Prof. Kristine', 'Yu', '1991-03-31', 'F', 'kristine.yu@ccse.edu.ph', '2018-09-27', 52000.00, 1, 24),
(55, 1, 1, 'Prof. Lawrence', 'Co', '1988-12-15', 'M', 'lawrence.co@ccse.edu.ph', '2016-02-18', 57000.00, 1, 24),
(56, 1, 1, 'Prof. Michelle', 'Tan', '1990-10-28', 'F', 'michelle.tan@ccse.edu.ph', '2017-06-09', 55000.00, 1, 24),
(57, 1, 1, 'Prof. Nathaniel', 'Sy', '1987-08-03', 'M', 'nathaniel.sy@ccse.edu.ph', '2014-12-01', 60000.00, 1, 24),
(58, 1, 1, 'Prof. Olivia', 'Go', '1992-01-19', 'F', 'olivia.go@ccse.edu.ph', '2019-04-24', 51000.00, 1, 24),
(59, 1, 1, 'Prof. Patrick', 'Uy', '1989-05-20', 'M', 'patrick.uy@ccse.edu.ph', '2016-08-07', 56000.00, 1, 24),
(60, 1, 1, 'Prof. Rachelle', 'Dy', '1991-07-12', 'F', 'rachelle.dy@ccse.edu.ph', '2018-03-03', 53000.00, 1, 24),
(61, 2, 3, 'Dr. Ramon', 'Cruz', '1968-03-12', 'M', 'ramon.cruz@polsci.edu.ph', '2004-06-01', 95000.00, 1, 24),
(62, 2, 3, 'Dr. Lourdes', 'Santos', '1970-07-25', 'F', 'lourdes.santos@polsci.edu.ph', '2005-08-15', 92000.00, 1, 24),
(63, 2, 2, 'Prof. Manuel', 'Reyes', '1975-11-30', 'M', 'manuel.reyes@polsci.edu.ph', '2008-01-10', 78000.00, 1, 24),
(64, 2, 2, 'Prof. Corazon', 'Aquino', '1978-04-18', 'F', 'corazon.aquino@polsci.edu.ph', '2010-03-20', 76000.00, 1, 24),
(65, 2, 2, 'Prof. Benigno', 'Marcos', '1980-09-05', 'M', 'benigno.marcos@polsci.edu.ph', '2011-11-05', 74000.00, 1, 24),
(66, 2, 1, 'Prof. Maria', 'Clara', '1983-12-15', 'F', 'maria.clara@polsci.edu.ph', '2012-07-12', 65000.00, 1, 24),
(67, 2, 1, 'Prof. Jose', 'Rizal', '1985-06-20', 'M', 'jose.rizal@polsci.edu.ph', '2014-09-01', 63000.00, 1, 24),
(68, 2, 1, 'Prof. Andres', 'Bonifacio', '1987-02-14', 'M', 'andres.bonifacio@polsci.edu.ph', '2015-01-15', 61000.00, 1, 24),
(69, 2, 1, 'Prof. Gabriela', 'Silang', '1989-08-22', 'F', 'gabriela.silang@polsci.edu.ph', '2016-06-15', 58000.00, 1, 24),
(70, 2, 1, 'Prof. Emilio', 'Aguinaldo', '1986-10-30', 'M', 'emilio.aguinaldo@polsci.edu.ph', '2015-05-10', 62000.00, 1, 24),
(71, 2, 1, 'Prof. Melchora', 'Aquino', '1990-03-17', 'F', 'melchora.aquino@polsci.edu.ph', '2017-08-20', 56000.00, 1, 24),
(72, 2, 1, 'Prof. Apolinario', 'Mabini', '1988-07-28', 'M', 'apolinario.mabini@polsci.edu.ph', '2016-01-10', 59000.00, 1, 24),
(73, 2, 1, 'Prof. Gregoria', 'De Jesus', '1991-11-11', 'F', 'gregoria.dejesus@polsci.edu.ph', '2018-03-15', 55000.00, 1, 24),
(74, 2, 1, 'Prof. Antonio', 'Luna', '1987-04-09', 'M', 'antonio.luna@polsci.edu.ph', '2015-09-22', 60000.00, 1, 24),
(75, 2, 1, 'Prof. Teresa', 'Magbanua', '1992-12-01', 'F', 'teresa.magbanua@polsci.edu.ph', '2019-06-10', 54000.00, 1, 24),
(76, 3, 8, 'Dr. Henry', 'Sy', '1965-03-15', 'M', 'henry.sy@cba.edu.ph', '2003-06-01', 120000.00, 1, 24),
(77, 3, 9, 'Dr. Tessie', 'Ong', '1968-07-20', 'F', 'tessie.ong@cba.edu.ph', '2005-08-15', 98000.00, 1, 24),
(78, 3, 3, 'Dr. William', 'Go', '1970-11-10', 'M', 'william.go@cba.edu.ph', '2006-01-10', 91000.00, 1, 24),
(79, 3, 3, 'Dr. Grace', 'Tan', '1972-04-18', 'F', 'grace.tan@cba.edu.ph', '2007-03-20', 89000.00, 1, 24),
(80, 3, 2, 'Prof. Richard', 'Lim', '1975-08-25', 'M', 'richard.lim@cba.edu.ph', '2009-11-05', 77000.00, 1, 24),
(81, 3, 2, 'Prof. Susan', 'Chua', '1977-12-30', 'F', 'susan.chua@cba.edu.ph', '2010-07-12', 75000.00, 1, 24),
(82, 3, 2, 'Prof. George', 'Yap', '1979-05-22', 'M', 'george.yap@cba.edu.ph', '2011-09-01', 73000.00, 1, 24),
(83, 3, 2, 'Prof. Michelle', 'Ang', '1981-09-14', 'F', 'michelle.ang@cba.edu.ph', '2012-01-15', 71000.00, 1, 24),
(84, 3, 2, 'Prof. Benedict', 'Uy', '1983-02-28', 'M', 'benedict.uy@cba.edu.ph', '2013-08-01', 69000.00, 1, 24),
(85, 3, 1, 'Prof. Christine', 'Lao', '1985-06-20', 'F', 'christine.lao@cba.edu.ph', '2014-06-15', 65000.00, 1, 24),
(86, 3, 1, 'Prof. Dennis', 'Sy', '1986-10-08', 'M', 'dennis.sy@cba.edu.ph', '2015-01-10', 63000.00, 1, 24),
(87, 3, 1, 'Prof. Elizabeth', 'Co', '1988-03-17', 'F', 'elizabeth.co@cba.edu.ph', '2016-08-20', 61000.00, 1, 24),
(88, 3, 1, 'Prof. Francis', 'Cheng', '1987-07-29', 'M', 'francis.cheng@cba.edu.ph', '2015-05-10', 62000.00, 1, 24),
(89, 3, 1, 'Prof. Gloria', 'Yao', '1990-11-11', 'F', 'gloria.yao@cba.edu.ph', '2018-03-15', 55000.00, 1, 24),
(90, 3, 1, 'Prof. Henry Jr.', 'Sy', '1989-04-09', 'M', 'henryjr.sy@cba.edu.ph', '2017-09-22', 58000.00, 1, 24),
(91, 3, 1, 'Prof. Irene', 'Tan', '1991-12-01', 'F', 'irene.tan@cba.edu.ph', '2019-06-10', 54000.00, 1, 24),
(92, 3, 1, 'Prof. Joseph', 'Ong', '1986-05-18', 'M', 'joseph.ong@cba.edu.ph', '2014-10-20', 66000.00, 1, 24),
(93, 3, 1, 'Prof. Karen', 'Lim', '1990-02-22', 'F', 'karen.lim@cba.edu.ph', '2018-08-01', 56000.00, 1, 24),
(94, 3, 1, 'Prof. Leonard', 'Chua', '1988-09-14', 'M', 'leonard.chua@cba.edu.ph', '2016-12-10', 59000.00, 1, 24),
(95, 3, 1, 'Prof. Mary', 'Uy', '1992-04-30', 'F', 'mary.uy@cba.edu.ph', '2020-02-15', 52000.00, 1, 24),
(96, 4, 16, 'Dr. Christopher', 'Gonzales', '1968-04-20', 'M', 'christopher.gonzales@hki.edu.ph', '2004-06-01', 105000.00, 1, 20),
(97, 4, 12, 'Dr. Victoria', 'Santiago', '1970-09-15', 'F', 'victoria.santiago@hki.edu.ph', '2005-08-15', 98000.00, 1, 24),
(98, 4, 12, 'Dr. Raymond', 'Villanueva', '1972-11-28', 'M', 'raymond.villanueva@hki.edu.ph', '2006-01-10', 95000.00, 1, 24),
(99, 4, 13, 'Dr. Michelle', 'Ocampo', '1975-03-12', 'F', 'michelle.ocampo@hki.edu.ph', '2008-06-15', 85000.00, 1, 24),
(100, 4, 13, 'Dr. Lawrence', 'Mendoza', '1977-07-08', 'M', 'lawrence.mendoza@hki.edu.ph', '2009-09-01', 83000.00, 1, 24),
(101, 4, 14, 'Prof. Irene', 'Castillo', '1979-12-05', 'F', 'irene.castillo@hki.edu.ph', '2011-11-15', 75000.00, 1, 24),
(102, 4, 14, 'Prof. Jonathan', 'Rivera', '1981-05-22', 'M', 'jonathan.rivera@hki.edu.ph', '2012-07-10', 73000.00, 1, 24),
(103, 4, 14, 'Prof. Kristine', 'Lopez', '1983-08-30', 'F', 'kristine.lopez@hki.edu.ph', '2013-09-20', 71000.00, 1, 24),
(104, 4, 14, 'Prof. Mark', 'Fernandez', '1985-02-14', 'M', 'mark.fernandez@hki.edu.ph', '2015-01-15', 68000.00, 1, 24),
(105, 4, 14, 'Prof. Rachel', 'Garcia', '1986-06-25', 'F', 'rachel.garcia@hki.edu.ph', '2015-08-01', 67000.00, 1, 24),
(106, 4, 15, 'Prof. Bryan', 'Torres', '1988-10-18', 'M', 'bryan.torres@hki.edu.ph', '2016-06-10', 58000.00, 1, 24),
(107, 4, 15, 'Prof. Diana', 'Ramos', '1989-04-07', 'F', 'diana.ramos@hki.edu.ph', '2017-01-20', 56000.00, 1, 24),
(108, 4, 15, 'Prof. Eric', 'Santos', '1987-11-29', 'M', 'eric.santos@hki.edu.ph', '2016-03-15', 57000.00, 1, 24),
(109, 4, 15, 'Prof. Fiona', 'Cruz', '1990-07-13', 'F', 'fiona.cruz@hki.edu.ph', '2018-08-01', 54000.00, 1, 24),
(110, 4, 15, 'Prof. Gerald', 'Aquino', '1991-09-22', 'M', 'gerald.aquino@hki.edu.ph', '2019-01-10', 52000.00, 1, 24),
(111, 4, 15, 'Prof. Hannah', 'Lim', '1989-12-03', 'F', 'hannah.lim@hki.edu.ph', '2017-06-15', 55000.00, 1, 24),
(112, 4, 15, 'Prof. Ivan', 'Chua', '1990-03-19', 'M', 'ivan.chua@hki.edu.ph', '2018-10-20', 53000.00, 1, 24),
(113, 4, 15, 'Prof. Jasmine', 'Ong', '1992-05-27', 'F', 'jasmine.ong@hki.edu.ph', '2020-01-15', 51000.00, 1, 24),
(114, 4, 15, 'Prof. Kevin', 'Tan', '1988-08-11', 'M', 'kevin.tan@hki.edu.ph', '2016-11-01', 56000.00, 1, 24),
(115, 4, 15, 'Prof. Laura', 'Uy', '1991-02-28', 'F', 'laura.uy@hki.edu.ph', '2019-08-20', 52000.00, 1, 24),
(116, 4, 17, 'Dr. Norman', 'Dela Cruz', '1980-12-10', 'M', 'norman.delacruz@hki.edu.ph', '2010-06-01', 65000.00, 0, 0),
(117, 4, 18, 'Mark', 'Sison', '1992-04-16', 'M', 'mark.sison@hki.edu.ph', '2018-03-15', 35000.00, 0, 0),
(118, 4, 18, 'Patricia', 'Yap', '1994-07-24', 'F', 'patricia.yap@hki.edu.ph', '2019-05-20', 32000.00, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `employee_leave`
--

CREATE TABLE `employee_leave` (
  `leave_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `leave_type` varchar(50) DEFAULT NULL,
  `status` enum('Pending','Approved','Denied') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_leave`
--

INSERT INTO `employee_leave` (`leave_id`, `employee_id`, `start_date`, `end_date`, `leave_type`, `status`) VALUES
(1, 5, '2026-04-10', '2026-04-12', 'Sick Leave', 'Approved'),
(2, 12, '2026-04-15', '2026-04-18', 'Vacation Leave', 'Pending'),
(3, 28, '2026-05-01', '2026-05-05', 'Personal Leave', 'Approved'),
(4, 62, '2026-04-20', '2026-04-25', 'Sick Leave', 'Approved'),
(5, 66, '2026-05-10', '2026-05-15', 'Vacation Leave', 'Pending'),
(6, 70, '2026-06-01', '2026-06-05', 'Personal Leave', 'Approved'),
(7, 85, '2026-04-20', '2026-04-25', 'Vacation Leave', 'Pending'),
(8, 90, '2026-05-10', '2026-05-15', 'Sick Leave', 'Approved'),
(9, 76, '2026-06-01', '2026-06-05', 'Personal Leave', 'Approved');

-- --------------------------------------------------------

--
-- Table structure for table `employee_payments`
--

CREATE TABLE `employee_payments` (
  `pay_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `pay_date` date NOT NULL,
  `gross_amount` decimal(12,2) DEFAULT NULL,
  `deductions` decimal(12,2) DEFAULT NULL,
  `net_amount` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_payments`
--

INSERT INTO `employee_payments` (`pay_id`, `employee_id`, `pay_date`, `gross_amount`, `deductions`, `net_amount`) VALUES
(1, 1, '2026-02-28', 95000.00, 15000.00, 80000.00),
(2, 2, '2026-02-28', 92000.00, 14500.00, 77500.00),
(3, 3, '2026-02-28', 89000.00, 14000.00, 75000.00),
(4, 4, '2026-02-28', 78000.00, 12000.00, 66000.00),
(5, 5, '2026-02-28', 76000.00, 11500.00, 64500.00),
(6, 61, '2026-02-28', 95000.00, 15000.00, 80000.00),
(7, 62, '2026-02-28', 92000.00, 14500.00, 77500.00),
(8, 63, '2026-02-28', 78000.00, 12000.00, 66000.00),
(9, 64, '2026-02-28', 76000.00, 11500.00, 64500.00),
(10, 65, '2026-02-28', 74000.00, 11000.00, 63000.00),
(11, 76, '2026-02-28', 120000.00, 20000.00, 100000.00),
(12, 77, '2026-02-28', 98000.00, 16000.00, 82000.00),
(13, 78, '2026-02-28', 91000.00, 14500.00, 76500.00),
(14, 79, '2026-02-28', 89000.00, 14000.00, 75000.00),
(15, 80, '2026-02-28', 77000.00, 12000.00, 65000.00);

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `enrollment_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `grade` varchar(10) DEFAULT NULL,
  `enroll_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `enrollments`
--
DELIMITER $$
CREATE TRIGGER `check_enrollment_capacity` BEFORE INSERT ON `enrollments` FOR EACH ROW BEGIN
    DECLARE current_count INT;
    DECLARE max_allowed INT;
    
    SELECT COUNT(*) INTO current_count
    FROM enrollments
    WHERE class_id = NEW.class_id;
    
    SELECT max_enrollment INTO max_allowed
    FROM classes
    WHERE class_id = NEW.class_id;
    
    IF current_count >= max_allowed THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'CONFLICT: Class has reached maximum enrollment capacity.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_student_schedule_conflict` BEFORE INSERT ON `enrollments` FOR EACH ROW BEGIN
    DECLARE conflict_count INT;
    
    SELECT COUNT(*) INTO conflict_count
    FROM enrollments e
    JOIN schedule s1 ON e.class_id = s1.class_id
    JOIN schedule s2 ON NEW.class_id = s2.class_id
    WHERE e.student_id = NEW.student_id
      AND s1.day_of_week = s2.day_of_week
      AND (s1.start_time < s2.end_time AND s1.end_time > s2.start_time);
    
    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'CONFLICT: Student already has a class scheduled at this time.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `evaluation_details`
--

CREATE TABLE `evaluation_details` (
  `detail_id` int(11) NOT NULL,
  `eval_id` int(11) NOT NULL,
  `criterion_id` int(11) NOT NULL,
  `score` int(11) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `evaluation_details`
--

INSERT INTO `evaluation_details` (`detail_id`, `eval_id`, `criterion_id`, `score`, `remarks`) VALUES
(1, 1, 1, 5, 'Excellent teaching methods'),
(2, 1, 2, 5, 'Very knowledgeable'),
(3, 1, 3, 4, 'Good classroom management'),
(4, 1, 4, 5, 'Highly engaging'),
(5, 1, 5, 4, 'Timely feedback'),
(6, 2, 1, 4, 'Good delivery'),
(7, 2, 2, 5, 'Expert in the field'),
(8, 2, 3, 4, 'Well-organized class'),
(9, 6, 9, 5, 'Excellent lecture delivery and organization'),
(10, 6, 10, 5, 'Deep expertise in public administration'),
(11, 6, 11, 4, 'Good classroom management'),
(12, 6, 12, 5, 'Very engaging with students'),
(13, 6, 13, 4, 'Timely and constructive feedback'),
(14, 6, 14, 5, 'Active in research and publications'),
(15, 6, 15, 4, 'Good debate facilitation'),
(16, 6, 16, 5, 'Excellent integration of current events'),
(18, 10, 17, 5, 'Excellent lecture delivery'),
(19, 10, 18, 5, 'Deep business expertise'),
(20, 10, 19, 4, 'Good case facilitation'),
(21, 10, 20, 5, 'Highly engaging'),
(22, 11, 17, 4, 'Clear explanations'),
(23, 11, 18, 5, 'Expert in accounting'),
(24, 11, 21, 4, 'Timely feedback');

-- --------------------------------------------------------

--
-- Table structure for table `eval_criteria`
--

CREATE TABLE `eval_criteria` (
  `criterion_id` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `eval_criteria`
--

INSERT INTO `eval_criteria` (`criterion_id`, `description`) VALUES
(1, 'Teaching Effectiveness - CCSE'),
(2, 'Subject Matter Expertise - CCSE'),
(3, 'Classroom Management - CCSE'),
(4, 'Student Engagement - CCSE'),
(5, 'Assessment and Feedback - CCSE'),
(6, 'Research Output - CCSE'),
(7, 'Lab Instruction Quality - CCSE'),
(8, 'Industry Relevance - CCSE'),
(9, 'Lecture Effectiveness - POLSCI'),
(10, 'Subject Matter Expertise - POLSCI'),
(11, 'Classroom Management - POLSCI'),
(12, 'Student Engagement - POLSCI'),
(13, 'Assessment and Feedback - POLSCI'),
(14, 'Research Output - POLSCI'),
(15, 'Debate Facilitation Skills - POLSCI'),
(16, 'Current Events Integration - POLSCI'),
(17, 'Teaching Effectiveness - CBA'),
(18, 'Business Expertise - CBA'),
(19, 'Case Method Facilitation - CBA'),
(20, 'Student Engagement - CBA'),
(21, 'Assessment and Feedback - CBA'),
(22, 'Industry Relevance - CBA'),
(23, 'Research Output - CBA'),
(24, 'Practical Application Skills - CBA'),
(25, 'Knowledge Representation Understanding - HKI'),
(26, 'Cognitive Science Application - HKI'),
(27, 'Logical Reasoning Skills - HKI'),
(28, 'Research Methodology - HKI'),
(29, 'AI Knowledge Systems Competency - HKI'),
(30, 'Information Architecture Design - HKI');

-- --------------------------------------------------------

--
-- Table structure for table `event_requests`
--

CREATE TABLE `event_requests` (
  `request_id` int(11) NOT NULL,
  `requested_by` int(11) NOT NULL,
  `event_type` enum('makeup_class','seminar','lab_session','campus_event') NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `preferred_date` date NOT NULL,
  `preferred_start` time NOT NULL,
  `preferred_end` time NOT NULL,
  `required_resources` text DEFAULT NULL,
  `status` enum('pending','approved','denied') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reviewed_by` int(11) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event_requests`
--

INSERT INTO `event_requests` (`request_id`, `requested_by`, `event_type`, `title`, `description`, `preferred_date`, `preferred_start`, `preferred_end`, `required_resources`, `status`, `created_at`, `reviewed_by`, `reviewed_at`) VALUES
(1, 1, 'seminar', 'CCSE Tech Summit 2026', 'Annual technology summit with industry speakers', '2026-04-20', '09:00:00', '17:00:00', 'Multimedia Hall, sound system, projectors, 200 chairs', 'approved', '2026-02-15 00:00:00', 1, '2026-02-20 10:30:00'),
(2, 5, 'makeup_class', 'Data Structures Makeup', 'Makeup session for missed Data Structures class', '2026-03-25', '13:00:00', '16:00:00', 'Computer Lab 2, whiteboard', 'approved', '2026-03-10 00:00:00', 2, '2026-03-12 09:00:00'),
(3, 10, 'lab_session', 'Python Workshop', 'Hands-on Python programming workshop for beginners', '2026-04-05', '08:00:00', '12:00:00', 'Computer Lab 3, Python IDE installed', 'pending', '2026-03-18 00:00:00', NULL, NULL),
(4, 25, 'campus_event', 'CCSE Foundation Day', 'Celebration of CCSE department founding anniversary', '2026-05-10', '08:00:00', '18:00:00', 'Open grounds, stage, sound system', 'approved', '2026-03-01 00:00:00', 1, '2026-03-05 14:00:00'),
(5, 61, 'seminar', 'POLSCI National Election Forum 2026', 'Forum with candidates discussing national issues and platforms', '2026-04-25', '09:00:00', '17:00:00', 'POLSCI Seminar Room, sound system, projectors, 200 chairs', 'approved', '2026-02-19 16:00:00', 61, '2026-02-25 11:00:00'),
(6, 63, 'campus_event', 'Constitutional Reform Debate', 'Open debate on proposed constitutional amendments', '2026-05-05', '13:00:00', '17:00:00', 'POLSCI Seminar Room, debate podium, microphones', 'pending', '2026-03-04 16:00:00', NULL, NULL),
(7, 66, 'seminar', 'Human Rights Summit', 'Seminar on human rights issues in the Philippines', '2026-04-15', '08:00:00', '16:00:00', 'POLSCI Seminar Room, sound system, multimedia', 'approved', '2026-02-09 16:00:00', 62, '2026-02-15 14:30:00'),
(8, 76, 'seminar', 'CBA Business Summit 2026', 'Annual business summit with industry leaders and entrepreneurs', '2026-04-22', '09:00:00', '17:00:00', 'CBA Seminar Room, sound system, projectors, 200 chairs', 'approved', '2026-02-19 16:00:00', 76, '2026-02-25 10:30:00'),
(9, 80, 'seminar', 'Financial Literacy Workshop', 'Workshop on personal finance and investment basics', '2026-04-18', '13:00:00', '17:00:00', 'CBA 101, projector, whiteboard', 'approved', '2026-03-04 16:00:00', 77, '2026-03-10 09:00:00'),
(10, 85, 'lab_session', 'Business Analytics Training', 'Hands-on training on Excel and data analytics tools', '2026-04-08', '08:00:00', '12:00:00', 'Business Computer Lab 1, Excel installed', 'pending', '2026-03-19 16:00:00', NULL, NULL),
(11, 76, 'campus_event', 'CBA Entrepreneurship Week', 'Week-long entrepreneurship activities and pitch competition', '2026-05-15', '08:00:00', '18:00:00', 'Business Building grounds, stage, sound system', 'approved', '2026-02-28 16:00:00', 76, '2026-03-08 14:00:00'),
(12, 3, 'lab_session', 'CCSE Hackathon 2026', '24-hour coding competition for CCSE students', '2026-05-01', '09:00:00', '18:00:00', 'Computer Labs 1-4, high-speed internet, snacks area', 'pending', '2026-04-18 01:22:09', NULL, NULL),
(13, 7, 'seminar', 'AI and Machine Learning Workshop', 'Industry expert workshop on AI/ML technologies', '2026-04-28', '13:00:00', '17:00:00', 'Multimedia Room, projectors, Python environment', 'approved', '2026-04-18 01:22:09', NULL, NULL),
(14, 12, 'makeup_class', 'Database Systems Makeup Session', 'Makeup class for missed database lecture', '2026-04-12', '10:00:00', '13:00:00', 'Computer Lab 2, MySQL installed', 'approved', '2026-04-18 01:22:09', NULL, NULL),
(15, 62, 'seminar', 'ASEAN Integration Forum', 'Forum on ASEAN economic and political integration', '2026-05-03', '09:00:00', '16:00:00', 'POLSCI Seminar Room, translation equipment', 'pending', '2026-04-18 01:22:09', NULL, NULL),
(16, 65, 'campus_event', 'Mock United Nations Assembly', 'Student simulation of UN General Assembly', '2026-05-08', '08:00:00', '17:00:00', 'POLSCI Conference Room, country placards, sound system', 'approved', '2026-04-18 01:22:09', NULL, NULL),
(17, 68, 'seminar', 'Philippine Foreign Policy Lecture', 'Guest lecture by former ambassador', '2026-04-29', '14:00:00', '16:00:00', 'POLSCI 301, projector, document camera', 'pending', '2026-04-18 01:22:09', NULL, NULL),
(18, 78, 'seminar', 'Entrepreneurship Summit 2026', 'Startup founders sharing success stories', '2026-05-05', '09:00:00', '17:00:00', 'CBA Seminar Room, networking area, catering', 'approved', '2026-04-18 01:22:09', NULL, NULL),
(19, 82, 'lab_session', 'Excel for Business Analytics', 'Advanced Excel training for business students', '2026-04-26', '13:00:00', '17:00:00', 'Business Computer Lab 1, Excel 365', 'pending', '2026-04-18 01:22:09', NULL, NULL),
(20, 88, 'campus_event', 'CBA Career Fair', 'Job fair with partner companies', '2026-05-12', '08:00:00', '18:00:00', 'Business Building grounds, booths, sound system', 'approved', '2026-04-18 01:22:09', NULL, NULL),
(21, 98, 'seminar', 'Knowledge Management Conference', 'Annual conference on KM best practices', '2026-05-10', '09:00:00', '17:00:00', 'HKI Seminar Room, video conferencing equipment', 'approved', '2026-04-18 01:22:09', NULL, NULL),
(22, 103, 'lab_session', 'Cognitive Science Workshop', 'Hands-on cognitive psychology experiments', '2026-04-27', '10:00:00', '15:00:00', 'Cognitive Science Lab, EEG equipment', 'pending', '2026-04-18 01:22:09', NULL, NULL),
(23, 108, 'makeup_class', 'AI Knowledge Systems Makeup', 'Makeup session for missed AI lecture', '2026-04-14', '13:00:00', '16:00:00', 'Knowledge Lab 2, Python/Jupyter environment', 'approved', '2026-04-18 01:22:09', NULL, NULL),
(24, 112, 'campus_event', 'HKI Research Symposium', 'Student research presentations in knowledge science', '2026-05-15', '09:00:00', '17:00:00', 'HKI Conference Room, poster boards, projectors', 'pending', '2026-04-18 01:22:09', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `faculty_evaluations`
--

CREATE TABLE `faculty_evaluations` (
  `eval_id` int(11) NOT NULL,
  `faculty_id` int(11) NOT NULL,
  `evaluator_id` int(11) NOT NULL,
  `eval_date` date NOT NULL,
  `overall_score` decimal(5,2) DEFAULT NULL,
  `comments` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faculty_evaluations`
--

INSERT INTO `faculty_evaluations` (`eval_id`, `faculty_id`, `evaluator_id`, `eval_date`, `overall_score`, `comments`) VALUES
(1, 1, 100, '2026-03-01', 4.70, 'Excellent professor, very knowledgeable'),
(2, 2, 101, '2026-03-02', 4.50, 'Great teaching style'),
(3, 3, 102, '2026-03-03', 4.80, 'Very engaging lectures'),
(4, 4, 103, '2026-03-04', 4.40, 'Good but could improve lab sessions'),
(5, 5, 104, '2026-03-05', 4.60, 'Excellent research guidance'),
(6, 61, 31, '2026-03-10', 4.80, 'Excellent professor, very engaging lectures on public administration'),
(7, 62, 32, '2026-03-11', 4.70, 'Very knowledgeable about international relations'),
(8, 66, 33, '2026-03-12', 4.60, 'Great teaching style, makes complex theories understandable'),
(9, 70, 34, '2026-03-13', 4.50, 'Good but could use more interactive activities'),
(10, 85, 61, '2026-03-10', 4.75, 'Excellent teaching style, very practical examples'),
(11, 86, 62, '2026-03-11', 4.65, 'Very knowledgeable in accounting'),
(12, 90, 63, '2026-03-12', 4.70, 'Great at explaining complex concepts'),
(13, 92, 64, '2026-03-13', 4.55, 'Good use of case studies');

-- --------------------------------------------------------

--
-- Table structure for table `faculty_unavailability`
--

CREATE TABLE `faculty_unavailability` (
  `unavailability_id` int(11) NOT NULL,
  `faculty_id` int(11) NOT NULL,
  `day_of_week` varchar(10) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faculty_unavailability`
--

INSERT INTO `faculty_unavailability` (`unavailability_id`, `faculty_id`, `day_of_week`, `start_time`, `end_time`) VALUES
(1, 1, 'Wednesday', '13:00:00', '17:00:00'),
(2, 1, 'Friday', '13:00:00', '17:00:00'),
(3, 5, 'Tuesday', '13:00:00', '17:00:00'),
(4, 10, 'Thursday', '08:00:00', '12:00:00'),
(5, 15, 'Monday', '13:00:00', '17:00:00'),
(6, 20, 'Wednesday', '08:00:00', '12:00:00'),
(7, 61, 'Wednesday', '13:00:00', '17:00:00'),
(8, 62, 'Friday', '08:00:00', '12:00:00'),
(9, 63, 'Thursday', '13:00:00', '17:00:00'),
(10, 66, 'Tuesday', '13:00:00', '17:00:00'),
(11, 70, 'Monday', '13:00:00', '17:00:00'),
(12, 76, 'Wednesday', '13:00:00', '17:00:00'),
(13, 76, 'Friday', '13:00:00', '17:00:00'),
(14, 80, 'Tuesday', '13:00:00', '17:00:00'),
(15, 85, 'Thursday', '08:00:00', '12:00:00'),
(16, 90, 'Monday', '13:00:00', '17:00:00'),
(17, 96, 'Wednesday', '13:00:00', '17:00:00'),
(18, 96, 'Friday', '13:00:00', '17:00:00'),
(19, 101, 'Tuesday', '13:00:00', '17:00:00'),
(20, 105, 'Thursday', '08:00:00', '12:00:00'),
(21, 110, 'Monday', '13:00:00', '17:00:00'),
(22, 115, 'Wednesday', '08:00:00', '12:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_items`
--

CREATE TABLE `inventory_items` (
  `inventory_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `reorder_level` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_items`
--

INSERT INTO `inventory_items` (`inventory_id`, `name`, `description`, `quantity`, `unit_price`, `reorder_level`, `supplier_id`) VALUES
(1, 'Keyboard', 'Standard USB keyboard', 50, 350.00, 20, 1),
(2, 'Mouse', 'Optical USB mouse', 50, 250.00, 20, 1),
(3, 'Monitor', '22-inch LED monitor', 30, 4500.00, 10, 2),
(4, 'CPU Unit', 'Desktop computer system unit', 25, 25000.00, 10, 2),
(5, 'HDMI Cable', '3-meter HDMI cable', 40, 150.00, 15, 1),
(6, 'USB Flash Drive', '32GB USB 3.0', 100, 300.00, 30, 3),
(7, 'Printer Paper', 'A4 bond paper (500 sheets)', 200, 200.00, 50, 3),
(8, 'Whiteboard Marker', 'Dry erase marker (black)', 80, 45.00, 30, 1),
(9, 'Whiteboard', 'Standard whiteboard for POLSCI classrooms', 20, 2500.00, 5, 1),
(10, 'Projector', 'POLSCI department projector', 10, 35000.00, 3, 2),
(11, 'Debate Timer', 'Digital timer for debate sessions', 15, 1500.00, 5, 1),
(12, 'Reference Books', 'Political science reference books set', 100, 800.00, 20, 3),
(13, 'Gavel', 'Official gavel for debate sessions', 5, 500.00, 2, 1),
(14, 'Business Calculator', 'Financial calculator for business courses', 60, 850.00, 20, 1),
(15, 'Case Study Books', 'Harvard business case study collection', 80, 1200.00, 25, 3),
(16, 'Whiteboard', 'Standard whiteboard for CBA classrooms', 25, 2500.00, 5, 1),
(17, 'Projector', 'CBA department projector', 12, 35000.00, 3, 2),
(18, 'Business Simulation Software', 'Software license for business simulation', 5, 15000.00, 2, 1),
(19, 'Accounting Ledger Books', 'Manual accounting ledger books', 100, 150.00, 30, 3),
(20, 'Statistical Software License', 'SPSS/Excel analytics software licenses', 30, 5000.00, 10, 2),
(21, 'Cognitive Science Software License', 'Annual license for cognitive science tools', 20, 5000.00, 5, 2),
(22, 'Eye Tracker Device', 'Eye tracking equipment for cognitive research', 5, 25000.00, 2, 2),
(23, 'Knowledge Management Books', 'Reference books on KM and knowledge science', 80, 900.00, 20, 3),
(24, 'Whiteboard (HKI)', 'Standard whiteboard for HKI classrooms', 20, 2500.00, 5, 1),
(25, 'Projector (HKI)', 'HKI department projector', 8, 35000.00, 2, 2),
(26, 'Survey Software License', 'Online survey and research tool license', 15, 3000.00, 5, 2);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `recipient_type` enum('student','employee','all') NOT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `type` enum('schedule','exam','event','conflict','reminder') NOT NULL,
  `is_read` tinyint(4) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `scheduled_for` datetime DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `recipient_type`, `recipient_id`, `title`, `message`, `type`, `is_read`, `created_at`, `scheduled_for`, `sent_at`) VALUES
(1, 'all', NULL, 'Enrollment for 2nd Semester', 'Online enrollment for 2nd Semester AY 2025-2026 will start on June 1, 2026', 'reminder', 0, '2026-02-15 00:00:00', '2026-05-15 08:00:00', NULL),
(3, 'employee', 5, 'Faculty Meeting', 'Monthly faculty meeting on March 25 at 2:00 PM in Conference Room', 'event', 0, '2026-03-01 00:00:00', '2026-03-25 14:00:00', NULL),
(4, 'all', NULL, 'CCSE Foundation Week', 'CCSE Foundation Week celebration from May 10-15, 2026. Various activities planned.', 'event', 0, '2026-03-10 00:00:00', '2026-05-01 08:00:00', NULL),
(5, 'student', 16, 'Midterm Exam Schedule', 'Midterm exams will be held from April 1-5, 2026. Check your class schedule for specific dates.', 'exam', 0, '2026-03-15 00:00:00', '2026-03-20 08:00:00', NULL),
(6, 'all', NULL, 'POLSCI National Election Forum', 'POLSCI department is hosting a National Election Forum on April 25, 2026. All students are encouraged to attend.', 'event', 0, '2026-02-24 16:00:00', '2026-04-20 08:00:00', NULL),
(7, 'student', 31, 'Debate Competition', 'You have been selected to represent POLSCI in the inter-school debate competition.', 'event', 0, '2026-02-28 16:00:00', '2026-03-15 10:00:00', NULL),
(8, 'employee', 61, 'Faculty Meeting', 'POLSCI faculty meeting on March 30 at 2:00 PM in POLSCI Conference Room', 'event', 0, '2026-03-09 16:00:00', '2026-03-30 14:00:00', NULL),
(9, 'all', NULL, 'CBA Business Summit 2026', 'CBA department is hosting the annual Business Summit on April 22, 2026. All students are encouraged to attend.', 'event', 0, '2026-02-24 16:00:00', '2026-04-15 08:00:00', NULL),
(10, 'student', 61, 'Business Plan Competition', 'Your business plan has been selected for the final round of the CBA Business Plan Competition.', 'event', 0, '2026-02-28 16:00:00', '2026-03-20 10:00:00', NULL),
(11, 'employee', 85, 'Faculty Development Workshop', 'Teaching case method workshop on April 5, 2026 at CBA Conference Room.', 'event', 0, '2026-03-09 16:00:00', '2026-04-05 09:00:00', NULL),
(12, 'all', NULL, 'CBA Internship Fair', 'Annual internship fair with partner companies on May 5, 2026.', 'event', 0, '2026-03-14 16:00:00', '2026-05-01 08:00:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `positions`
--

CREATE TABLE `positions` (
  `position_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `positions`
--

INSERT INTO `positions` (`position_id`, `title`, `description`) VALUES
(1, 'Instructor', 'Instructor with bachelor/masteral degree'),
(2, 'Assistant Professor', 'Assistant professor with masteral degree'),
(3, 'Associate Professor', 'Associate professor with masteral/doctoral degree'),
(4, 'Professor', 'Full professor with doctoral degree'),
(5, 'Department Chair', 'CCSE Department chairperson'),
(6, 'IT Support', 'CCSE IT support staff'),
(7, 'Lab Technician', 'Computer laboratory technician'),
(8, 'Dean - CBA', 'Dean of College of Business Administration'),
(9, 'Department Chair - CBA', 'CBA Department Chairperson'),
(10, 'Assistant Professor - CBA', 'Assistant professor with business specialization'),
(11, 'Instructor - CBA', 'CBA Instructor with business degree'),
(12, 'Professor - HKI', 'Full professor with doctoral degree in Knowledge Science'),
(13, 'Associate Professor - HKI', 'Associate professor with masteral/doctoral degree in Knowledge Science'),
(14, 'Assistant Professor - HKI', 'Assistant professor with masteral degree in Knowledge Science'),
(15, 'Instructor - HKI', 'Instructor with bachelor/masteral degree in Knowledge Science'),
(16, 'Department Chair - HKI', 'Human KI Department chairperson'),
(17, 'Research Fellow - HKI', 'HKI research staff specializing in knowledge science'),
(18, 'Lab Technician - HKI', 'Knowledge laboratory technician');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_items`
--

CREATE TABLE `purchase_items` (
  `po_item_id` int(11) NOT NULL,
  `po_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_items`
--

INSERT INTO `purchase_items` (`po_item_id`, `po_id`, `inventory_id`, `quantity`, `unit_price`) VALUES
(1, 1, 1, 20, 350.00),
(2, 1, 2, 20, 250.00),
(3, 2, 6, 50, 300.00),
(4, 2, 7, 100, 200.00),
(5, 3, 3, 10, 4500.00),
(6, 3, 4, 10, 25000.00),
(7, 4, 9, 10, 2500.00),
(8, 4, 11, 10, 1500.00),
(9, 5, 12, 50, 800.00),
(10, 5, 13, 3, 500.00),
(11, 6, 14, 60, 850.00),
(12, 7, 15, 80, 1200.00),
(13, 8, 17, 12, 35000.00);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `po_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `order_date` date NOT NULL,
  `total_amount` decimal(12,2) DEFAULT NULL,
  `status` enum('Draft','Ordered','Received','Cancelled') DEFAULT 'Draft'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_orders`
--

INSERT INTO `purchase_orders` (`po_id`, `supplier_id`, `order_date`, `total_amount`, `status`) VALUES
(1, 1, '2026-02-10', 12000.00, 'Received'),
(2, 3, '2026-02-15', 35000.00, 'Ordered'),
(3, 2, '2026-03-01', 295000.00, 'Draft'),
(4, 1, '2026-02-20', 50000.00, 'Received'),
(5, 3, '2026-02-25', 80000.00, 'Ordered'),
(6, 1, '2026-02-12', 51000.00, 'Received'),
(7, 3, '2026-02-18', 96000.00, 'Ordered'),
(8, 2, '2026-03-05', 420000.00, 'Draft');

-- --------------------------------------------------------

--
-- Table structure for table `qa_indicators`
--

CREATE TABLE `qa_indicators` (
  `indicator_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `target_value` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `qa_indicators`
--

INSERT INTO `qa_indicators` (`indicator_id`, `name`, `description`, `target_value`) VALUES
(1, 'CCSE Graduation Rate', 'Percentage of CCSE students graduating within 4 years', 85.00),
(2, 'CCSE Board Exam Passing Rate', 'Percentage of passers in IT-related certifications', 80.00),
(3, 'CCSE Student Satisfaction', 'Student satisfaction survey score', 4.50),
(4, 'CCSE Faculty with Graduate Degrees', 'Percentage with masteral/doctoral degrees', 90.00),
(5, 'CCSE Research Publications', 'Number of publications per year', 15.00),
(6, 'CCSE Employment Rate', 'Percentage employed within 1 year', 90.00),
(7, 'CCSE Lab Utilization', 'Average utilization rate of laboratories', 85.00),
(8, 'POLSCI Graduation Rate', 'Percentage of POLSCI students graduating within 4 years', 85.00),
(9, 'POLSCI Board Exam Passing Rate', 'Percentage of passers in civil service and related exams', 75.00),
(10, 'POLSCI Student Satisfaction', 'Student satisfaction survey score', 4.50),
(11, 'POLSCI Faculty with Graduate Degrees', 'Percentage with masteral/doctoral degrees', 95.00),
(12, 'POLSCI Research Publications', 'Number of publications per year', 10.00),
(13, 'POLSCI Employment Rate', 'Percentage employed within 1 year in government/NGOs', 85.00),
(14, 'POLSCI Debate Competition Wins', 'Number of inter-school debate competition wins', 3.00),
(15, 'CBA Graduation Rate', 'Percentage of BSBA students graduating within 4 years', 85.00),
(16, 'CBA Board Exam Passing Rate', 'Percentage of passers in business licensure exams', 80.00),
(17, 'CBA Student Satisfaction', 'Student satisfaction survey score', 4.50),
(18, 'CBA Faculty with Graduate Degrees', 'Percentage with masteral/doctoral degrees', 90.00),
(19, 'CBA Research Publications', 'Number of publications per year', 12.00),
(20, 'CBA Employment Rate', 'Percentage employed within 1 year', 90.00),
(21, 'CBA Industry Partnerships', 'Number of active industry partnerships', 15.00),
(22, 'CBA Internship Placement Rate', 'Percentage of students placed in internships', 95.00),
(23, 'HKI Graduation Rate', 'Percentage of HKI students graduating within 4 years', 85.00),
(24, 'HKI Certification Passing Rate', 'Percentage of passers in knowledge management certifications', 80.00),
(25, 'HKI Student Satisfaction', 'Student satisfaction survey score', 4.50),
(26, 'HKI Faculty with Graduate Degrees', 'Percentage with masteral/doctoral degrees', 90.00),
(27, 'HKI Research Publications', 'Number of publications per year', 12.00),
(28, 'HKI Employment Rate', 'Percentage employed within 1 year', 88.00),
(29, 'HKI Lab Utilization', 'Average utilization rate of knowledge labs', 85.00),
(30, 'HKI Industry Projects', 'Number of industry collaboration projects', 8.00);

-- --------------------------------------------------------

--
-- Table structure for table `qa_records`
--

CREATE TABLE `qa_records` (
  `record_id` int(11) NOT NULL,
  `indicator_id` int(11) NOT NULL,
  `year` year(4) NOT NULL,
  `actual_value` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `qa_records`
--

INSERT INTO `qa_records` (`record_id`, `indicator_id`, `year`, `actual_value`) VALUES
(1, 1, '2025', 82.50),
(2, 2, '2025', 78.00),
(3, 3, '2025', 4.35),
(4, 4, '2025', 88.00),
(5, 5, '2025', 12.00),
(6, 6, '2025', 87.50),
(7, 7, '2025', 82.00),
(8, 8, '2025', 83.00),
(9, 9, '2025', 72.00),
(10, 10, '2025', 4.30),
(11, 11, '2025', 92.00),
(12, 12, '2025', 8.00),
(13, 13, '2025', 82.00),
(14, 14, '2025', 2.00),
(15, 15, '2025', 83.50),
(16, 16, '2025', 78.50),
(17, 17, '2025', 4.40),
(18, 18, '2025', 88.00),
(19, 19, '2025', 10.00),
(20, 20, '2025', 88.50),
(21, 21, '2025', 12.00),
(22, 22, '2025', 92.00),
(24, 23, '2025', 83.00),
(25, 24, '2025', 76.00),
(26, 25, '2025', 4.32),
(27, 26, '2025', 87.00),
(28, 27, '2025', 9.00),
(29, 28, '2025', 85.00),
(30, 29, '2025', 80.00),
(31, 30, '2025', 6.00);

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `reservation_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `reserved_by_employee` int(11) DEFAULT NULL,
  `reserved_by_student` int(11) DEFAULT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `status` enum('Pending','Confirmed','Cancelled') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`reservation_id`, `resource_id`, `reserved_by_employee`, `reserved_by_student`, `start_time`, `end_time`, `purpose`, `status`) VALUES
(10, 1, 5, NULL, '2026-04-15 09:00:00', '2026-04-15 12:00:00', 'CCSE Faculty Meeting - Projector needed for presentation', 'Confirmed'),
(11, 2, 10, NULL, '2026-04-16 13:00:00', '2026-04-16 16:00:00', 'Programming Workshop - Sound system for demo', 'Confirmed'),
(12, 3, 15, NULL, '2026-04-17 08:00:00', '2026-04-17 11:00:00', 'Mobile Lab Session for IT Students', 'Pending'),
(13, 5, 20, NULL, '2026-04-18 14:00:00', '2026-04-18 15:30:00', 'Document Camera needed for code review session', 'Confirmed'),
(14, 1, NULL, 5, '2026-04-19 10:00:00', '2026-04-19 12:00:00', 'Group Project Presentation - CC111', 'Pending'),
(15, 2, NULL, 12, '2026-04-20 15:00:00', '2026-04-20 17:00:00', 'Capstone Project Demo - Sound System Required', 'Confirmed'),
(16, 6, 61, NULL, '2026-04-21 13:00:00', '2026-04-21 17:00:00', 'POLSCI Inter-School Debate Competition - Professional sound system', 'Confirmed'),
(17, 7, 63, NULL, '2026-04-22 09:00:00', '2026-04-22 16:00:00', 'Political Geography Class - Map Set for ASEAN studies', 'Confirmed'),
(18, 8, 66, NULL, '2026-04-23 10:00:00', '2026-04-23 12:00:00', 'Document Camera for Philippine Constitution lecture', 'Pending'),
(19, 6, NULL, 35, '2026-04-24 14:00:00', '2026-04-24 17:00:00', 'Student Debate Practice Session', 'Confirmed'),
(20, 7, NULL, 40, '2026-04-25 11:00:00', '2026-04-25 13:00:00', 'Research Presentation on ASEAN Politics', 'Cancelled'),
(21, 8, NULL, 45, '2026-04-26 09:00:00', '2026-04-26 11:00:00', 'Document Camera for Thesis Defense', 'Confirmed'),
(22, 9, 76, NULL, '2026-04-15 08:00:00', '2026-04-15 17:00:00', 'CBA Business Simulation Day - Full day workshop', 'Confirmed'),
(23, 10, 80, NULL, '2026-04-16 13:00:00', '2026-04-16 16:00:00', 'Financial Calculator Set for Finance class', 'Confirmed'),
(24, 11, 85, NULL, '2026-04-17 09:00:00', '2026-04-17 12:00:00', 'Case Study Analysis Session - Digital library access', 'Pending'),
(25, 12, 90, NULL, '2026-04-18 10:00:00', '2026-04-18 15:00:00', 'Strategic Management Case Discussion', 'Confirmed'),
(26, 13, 76, NULL, '2026-04-19 14:00:00', '2026-04-19 16:00:00', 'Document Camera for Accounting lecture', 'Confirmed'),
(27, 14, 80, NULL, '2026-04-20 11:00:00', '2026-04-20 13:00:00', 'Interactive Marketing Lecture - Clicker System', 'Pending'),
(28, 9, NULL, 65, '2026-04-21 15:00:00', '2026-04-21 17:00:00', 'Business Plan Competition Practice', 'Confirmed'),
(29, 10, NULL, 70, '2026-04-22 13:00:00', '2026-04-22 15:00:00', 'Financial Analysis Group Project', 'Pending'),
(30, 11, NULL, 75, '2026-04-23 10:00:00', '2026-04-23 12:00:00', 'Marketing Case Study Presentation', 'Confirmed'),
(31, 15, 96, NULL, '2026-04-15 09:00:00', '2026-04-15 17:00:00', 'Knowledge Management Workshop - Full day session', 'Confirmed'),
(32, 16, 101, NULL, '2026-04-16 13:00:00', '2026-04-16 16:00:00', 'Cognitive Science Lab - Memory experiment session', 'Confirmed'),
(33, 17, 105, NULL, '2026-04-17 10:00:00', '2026-04-17 13:00:00', 'Ontology Engineering Workshop - Semantic web tools', 'Pending'),
(34, 18, 110, NULL, '2026-04-18 14:00:00', '2026-04-18 17:00:00', 'Text Analytics Research - NLP tools training', 'Confirmed'),
(35, 15, NULL, 100, '2026-04-19 11:00:00', '2026-04-19 14:00:00', 'Knowledge Management System Project', 'Pending'),
(36, 16, NULL, 110, '2026-04-20 09:00:00', '2026-04-20 12:00:00', 'Cognitive Psychology Experiment', 'Confirmed'),
(37, 17, NULL, 120, '2026-04-21 14:00:00', '2026-04-21 17:00:00', 'Semantic Web Research Project', 'Confirmed'),
(38, 18, NULL, 130, '2026-04-22 13:00:00', '2026-04-22 15:00:00', 'Text Mining Assignment - Data collection', 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `resource_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`resource_id`, `name`, `type`, `description`) VALUES
(1, 'Projector', 'AV Equipment', '[CCSE] Epson HD projector'),
(2, 'Sound System', 'AV Equipment', '[CCSE] Portable sound system with microphones'),
(3, 'Laptop Cart', 'Equipment', '[CCSE] Cart with 30 laptops for mobile lab'),
(4, 'Whiteboard', 'Furniture', '[CCSE] Portable whiteboard with markers'),
(5, 'Document Camera', 'AV Equipment', '[CCSE] Visual presenter for demonstrations'),
(6, 'Debate Sound System', 'AV Equipment', '[POLSCI] Professional sound system for debate sessions'),
(7, 'Political Map Set', 'Educational Material', '[POLSCI] Set of world and Philippine political maps'),
(8, 'Document Camera', 'AV Equipment', '[POLSCI] Document camera for displaying texts and documents'),
(9, 'Business Simulation Software', 'Software', '[CBA] Enterprise business simulation platform'),
(10, 'Financial Calculator Set', 'Equipment', '[CBA] Set of 30 financial calculators'),
(11, 'Case Study Library', 'Educational Material', '[CBA] Digital library of business case studies'),
(12, 'Portable Whiteboard', 'Furniture', '[CBA] Mobile whiteboard for case discussions'),
(13, 'Document Camera', 'AV Equipment', '[CBA] Document camera for displaying case materials'),
(14, 'Clicker Response System', 'AV Equipment', '[CBA] Student response system for interactive lectures'),
(15, 'Knowledge Management Software', 'Software', '[HKI] Enterprise knowledge management platform'),
(16, 'Cognitive Science Lab Kit', 'Equipment', '[HKI] Tools for cognitive psychology experiments'),
(17, 'Ontology Editor Suite', 'Software', '[HKI] Professional ontology and semantic web tools'),
(18, 'Text Analytics Software', 'Software', '[HKI] NLP and text mining analysis tools'),
(19, 'VR Headset Set', 'Equipment', 'Oculus Quest 2 VR headsets (5 units) for immersive learning'),
(20, 'Arduino Kit', 'Equipment', 'Arduino starter kits for IoT and embedded systems courses'),
(21, 'Network Switch', 'Equipment', 'Cisco network switches for networking lab exercises'),
(22, 'Coding Monitor', 'Equipment', '27-inch 4K monitors for programming labs'),
(23, 'Server Rack', 'Equipment', 'Dell PowerEdge servers for cloud computing courses'),
(24, 'Digital Voice Recorder', 'AV Equipment', 'Professional voice recorders for interview and field research'),
(25, 'Portable PA System', 'AV Equipment', 'Portable public address system for outdoor political events'),
(26, 'Voting Simulation Kit', 'Educational Material', 'Mock election materials for political science practicum'),
(27, 'International Relations Database', 'Software', 'Access to global political databases and journals'),
(28, 'Debate Timer Pro', 'Equipment', 'Professional debate timing system with visual displays'),
(29, 'Stock Market Ticker', 'Equipment', 'Real-time stock market display for finance lab'),
(30, 'Point of Sale System', 'Equipment', 'POS terminals for retail management training'),
(31, 'Business Plan Software', 'Software', 'LivePlan business planning software licenses'),
(32, 'Marketing Analytics Tool', 'Software', 'Google Analytics and SEO tools for digital marketing'),
(33, 'Conference Speaker System', 'AV Equipment', 'Wireless microphone and speaker system for business presentations'),
(34, 'EEG Headset', 'Equipment', 'Brain-computer interface for cognitive research'),
(35, 'Eye Tracking Glasses', 'Equipment', 'Tobii Pro eye tracking glasses for usability studies'),
(36, 'Knowledge Graph Software', 'Software', 'Neo4j graph database for knowledge representation'),
(37, 'Sentiment Analysis Tool', 'Software', 'AI-powered sentiment analysis for text mining'),
(38, 'Collaborative Whiteboard', 'Furniture', 'Microsoft Surface Hub for collaborative knowledge work');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `room_type` varchar(20) DEFAULT 'lecture' COMMENT 'lecture, lab, seminar'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `name`, `location`, `capacity`, `room_type`) VALUES
(1, 'Computer Laboratory 1', 'CCSE Building - Ground Floor', 60, 'lab'),
(2, 'Computer Laboratory 2', 'CCSE Building - Ground Floor', 60, 'lab'),
(3, 'Computer Laboratory 3', 'CCSE Building - Ground Floor', 60, 'lab'),
(4, 'Computer Laboratory 4', 'CCSE Building - 2nd Floor', 60, 'lab'),
(5, 'Room 101', 'CCSE Building - 1st Floor', 80, 'lecture'),
(6, 'Room 102', 'CCSE Building - 1st Floor', 80, 'lecture'),
(7, 'Room 103', 'CCSE Building - 1st Floor', 80, 'lecture'),
(8, 'Room 104', 'CCSE Building - 1st Floor', 80, 'lecture'),
(9, 'Room 201', 'CCSE Building - 2nd Floor', 80, 'lecture'),
(10, 'Room 202', 'CCSE Building - 2nd Floor', 80, 'lecture'),
(11, 'Room 203', 'CCSE Building - 2nd Floor', 80, 'lecture'),
(12, 'Room 204', 'CCSE Building - 2nd Floor', 80, 'lecture'),
(13, 'Room 301', 'CCSE Building - 3rd Floor', 80, 'lecture'),
(14, 'Room 302', 'CCSE Building - 3rd Floor', 80, 'lecture'),
(15, 'Room 303', 'CCSE Building - 3rd Floor', 80, 'lecture'),
(16, 'Multimedia Room', 'CCSE Building - 3rd Floor', 80, 'seminar'),
(17, 'Conference Room', 'CCSE Building - 4th Floor', 80, 'seminar'),
(18, 'Research Lab', 'CCSE Building - 4th Floor', 60, 'lab'),
(19, 'Project Lab', 'CCSE Building - 3rd Floor', 60, 'lab'),
(20, 'POLSCI 101', 'Social Sciences Building - 1st Floor', 80, 'lecture'),
(21, 'POLSCI 102', 'Social Sciences Building - 1st Floor', 80, 'lecture'),
(22, 'POLSCI 103', 'Social Sciences Building - 1st Floor', 80, 'lecture'),
(23, 'POLSCI 104', 'Social Sciences Building - 1st Floor', 80, 'lecture'),
(24, 'POLSCI 201', 'Social Sciences Building - 2nd Floor', 80, 'lecture'),
(25, 'POLSCI 202', 'Social Sciences Building - 2nd Floor', 80, 'lecture'),
(26, 'POLSCI 203', 'Social Sciences Building - 2nd Floor', 80, 'lecture'),
(27, 'POLSCI 204', 'Social Sciences Building - 2nd Floor', 80, 'lecture'),
(28, 'POLSCI 301', 'Social Sciences Building - 3rd Floor', 80, 'lecture'),
(29, 'POLSCI 302', 'Social Sciences Building - 3rd Floor', 80, 'lecture'),
(30, 'POLSCI 303', 'Social Sciences Building - 3rd Floor', 80, 'lecture'),
(31, 'POLSCI Seminar Room', 'Social Sciences Building - 3rd Floor', 80, 'seminar'),
(32, 'POLSCI Conference Room', 'Social Sciences Building - 4th Floor', 80, 'seminar'),
(33, 'POLSCI Research Lab', 'Social Sciences Building - 4th Floor', 60, 'lab'),
(34, 'POLSCI Library', 'Social Sciences Building - 2nd Floor', 80, 'lecture'),
(35, 'CBA 101', 'Business Building - Ground Floor', 80, 'lecture'),
(36, 'CBA 102', 'Business Building - Ground Floor', 80, 'lecture'),
(37, 'CBA 103', 'Business Building - Ground Floor', 80, 'lecture'),
(38, 'CBA 104', 'Business Building - Ground Floor', 80, 'lecture'),
(39, 'CBA 105', 'Business Building - Ground Floor', 80, 'lecture'),
(40, 'CBA 201', 'Business Building - 2nd Floor', 80, 'lecture'),
(41, 'CBA 202', 'Business Building - 2nd Floor', 80, 'lecture'),
(42, 'CBA 203', 'Business Building - 2nd Floor', 80, 'lecture'),
(43, 'CBA 204', 'Business Building - 2nd Floor', 80, 'lecture'),
(44, 'CBA 205', 'Business Building - 2nd Floor', 80, 'lecture'),
(45, 'CBA 301', 'Business Building - 3rd Floor', 80, 'lecture'),
(46, 'CBA 302', 'Business Building - 3rd Floor', 80, 'lecture'),
(47, 'CBA 303', 'Business Building - 3rd Floor', 80, 'lecture'),
(48, 'CBA 304', 'Business Building - 3rd Floor', 80, 'lecture'),
(49, 'CBA 305', 'Business Building - 3rd Floor', 80, 'lecture'),
(50, 'Business Computer Lab 1', 'Business Building - 2nd Floor', 60, 'lab'),
(51, 'Business Computer Lab 2', 'Business Building - 2nd Floor', 60, 'lab'),
(52, 'CBA Seminar Room', 'Business Building - 4th Floor', 80, 'seminar'),
(53, 'CBA Conference Room', 'Business Building - 4th Floor', 80, 'seminar'),
(54, 'CBA Board Room', 'Business Building - 4th Floor', 80, 'seminar'),
(55, 'CBA Research Center', 'Business Building - 4th Floor', 60, 'lab'),
(56, 'CBA Case Room', 'Business Building - 3rd Floor', 80, 'seminar'),
(58, 'HKI 101', 'Humanities Building - Ground Floor', 80, 'lecture'),
(59, 'HKI 102', 'Humanities Building - Ground Floor', 80, 'lecture'),
(60, 'HKI 103', 'Humanities Building - Ground Floor', 80, 'lecture'),
(61, 'HKI 104', 'Humanities Building - Ground Floor', 80, 'lecture'),
(62, 'HKI 105', 'Humanities Building - Ground Floor', 80, 'lecture'),
(63, 'HKI 201', 'Humanities Building - 2nd Floor', 80, 'lecture'),
(64, 'HKI 202', 'Humanities Building - 2nd Floor', 80, 'lecture'),
(65, 'HKI 203', 'Humanities Building - 2nd Floor', 80, 'lecture'),
(66, 'HKI 204', 'Humanities Building - 2nd Floor', 80, 'lecture'),
(67, 'HKI 205', 'Humanities Building - 2nd Floor', 80, 'lecture'),
(68, 'HKI 301', 'Humanities Building - 3rd Floor', 80, 'lecture'),
(69, 'HKI 302', 'Humanities Building - 3rd Floor', 80, 'lecture'),
(70, 'HKI 303', 'Humanities Building - 3rd Floor', 80, 'lecture'),
(71, 'HKI 304', 'Humanities Building - 3rd Floor', 80, 'lecture'),
(72, 'HKI 305', 'Humanities Building - 3rd Floor', 80, 'lecture'),
(73, 'Knowledge Lab 1', 'Humanities Building - 2nd Floor', 60, 'lab'),
(74, 'Knowledge Lab 2', 'Humanities Building - 2nd Floor', 60, 'lab'),
(75, 'Knowledge Lab 3', 'Humanities Building - 3rd Floor', 60, 'lab'),
(76, 'HKI Seminar Room', 'Humanities Building - 4th Floor', 80, 'seminar'),
(77, 'HKI Conference Room', 'Humanities Building - 4th Floor', 80, 'seminar'),
(78, 'HKI Research Center', 'Humanities Building - 4th Floor', 60, 'lab'),
(79, 'Cognitive Science Lab', 'Humanities Building - 3rd Floor', 60, 'lab'),
(80, 'HKI Library', 'Humanities Building - 2nd Floor', 80, 'lecture');

-- --------------------------------------------------------

--
-- Table structure for table `schedule`
--

CREATE TABLE `schedule` (
  `schedule_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `day_of_week` varchar(10) NOT NULL COMMENT 'Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday',
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schedule`
--

INSERT INTO `schedule` (`schedule_id`, `class_id`, `room_id`, `day_of_week`, `start_time`, `end_time`) VALUES
(1, 7, 50, 'Thursday', '10:00:00', '13:00:00'),
(2, 4, 6, 'Monday', '15:00:00', '17:00:00'),
(3, 1, 50, 'Tuesday', '09:30:00', '12:30:00'),
(4, 6, 10, 'Saturday', '12:15:00', '14:15:00'),
(5, 3, 51, 'Thursday', '08:00:00', '11:00:00'),
(7, 5, 7, 'Monday', '18:00:00', '20:00:00'),
(8, 2, 2, 'Wednesday', '16:00:00', '19:00:00'),
(9, 16, 51, 'Saturday', '08:00:00', '10:00:00'),
(10, 13, 10, 'Saturday', '15:30:00', '17:30:00'),
(11, 10, 3, 'Thursday', '14:15:00', '17:15:00'),
(12, 15, 35, 'Wednesday', '10:30:00', '13:30:00'),
(13, 12, 50, 'Saturday', '11:30:00', '14:30:00'),
(14, 9, 4, 'Saturday', '08:15:00', '11:15:00'),
(15, 14, 14, 'Tuesday', '15:30:00', '17:30:00'),
(16, 11, 10, 'Saturday', '17:30:00', '19:30:00'),
(17, 23, 7, 'Saturday', '16:30:00', '19:30:00'),
(18, 20, 8, 'Tuesday', '13:45:00', '15:45:00'),
(19, 17, 18, 'Friday', '16:45:00', '19:45:00'),
(20, 22, 4, 'Saturday', '13:00:00', '16:00:00'),
(21, 19, 51, 'Wednesday', '11:30:00', '14:30:00'),
(22, 24, 51, 'Tuesday', '12:00:00', '15:00:00'),
(23, 21, 3, 'Wednesday', '12:15:00', '15:15:00'),
(24, 18, 8, 'Friday', '09:15:00', '11:15:00'),
(25, 32, 18, 'Saturday', '10:45:00', '13:45:00'),
(26, 29, 36, 'Saturday', '09:00:00', '12:00:00'),
(27, 26, 11, 'Tuesday', '14:00:00', '16:00:00'),
(28, 31, 14, 'Friday', '14:45:00', '17:45:00'),
(29, 28, 7, 'Friday', '17:45:00', '19:45:00'),
(30, 25, 1, 'Saturday', '14:30:00', '17:30:00'),
(31, 30, 19, 'Thursday', '14:30:00', '17:30:00'),
(32, 27, 15, 'Wednesday', '11:15:00', '13:15:00'),
(33, 39, 19, 'Tuesday', '16:15:00', '19:15:00'),
(35, 33, 10, 'Monday', '17:00:00', '19:00:00'),
(36, 38, 15, 'Thursday', '14:30:00', '17:30:00'),
(37, 35, 50, 'Monday', '08:00:00', '11:00:00'),
(38, 40, 12, 'Friday', '14:45:00', '17:45:00'),
(39, 37, 19, 'Wednesday', '15:45:00', '18:45:00'),
(40, 34, 50, 'Wednesday', '09:30:00', '12:30:00'),
(41, 48, 12, 'Friday', '10:45:00', '13:45:00'),
(42, 45, 4, 'Thursday', '16:45:00', '19:45:00'),
(43, 42, 15, 'Wednesday', '16:45:00', '18:45:00'),
(45, 44, 51, 'Monday', '10:30:00', '13:30:00'),
(46, 41, 5, 'Monday', '17:45:00', '19:45:00'),
(47, 46, 8, 'Monday', '12:15:00', '15:15:00'),
(48, 43, 13, 'Friday', '16:00:00', '19:00:00'),
(49, 52, 51, 'Thursday', '11:00:00', '14:00:00'),
(50, 49, 1, 'Tuesday', '12:15:00', '15:15:00'),
(51, 54, 35, 'Tuesday', '11:00:00', '14:00:00'),
(52, 51, 15, 'Saturday', '16:30:00', '19:30:00'),
(53, 53, 18, 'Thursday', '10:15:00', '13:15:00'),
(54, 50, 35, 'Saturday', '08:30:00', '11:30:00'),
(55, 59, 51, 'Tuesday', '08:00:00', '11:00:00'),
(56, 56, 1, 'Tuesday', '08:15:00', '11:15:00'),
(57, 58, 36, 'Wednesday', '08:00:00', '11:00:00'),
(58, 55, 3, 'Tuesday', '16:15:00', '19:15:00'),
(59, 60, 9, 'Wednesday', '12:45:00', '15:45:00'),
(60, 57, 12, 'Monday', '16:00:00', '19:00:00'),
(61, 61, 23, 'Monday', '08:30:00', '11:30:00'),
(62, 63, 34, 'Friday', '12:00:00', '15:00:00'),
(63, 65, 24, 'Thursday', '12:15:00', '15:15:00'),
(64, 62, 50, 'Friday', '08:30:00', '11:30:00'),
(65, 64, 29, 'Wednesday', '12:45:00', '15:45:00'),
(66, 67, 28, 'Monday', '13:45:00', '16:45:00'),
(67, 69, 29, 'Monday', '08:30:00', '11:30:00'),
(68, 66, 34, 'Tuesday', '11:15:00', '14:15:00'),
(69, 68, 30, 'Thursday', '11:00:00', '14:00:00'),
(70, 70, 34, 'Friday', '08:15:00', '11:15:00'),
(71, 74, 25, 'Monday', '09:45:00', '12:45:00'),
(72, 71, 28, 'Friday', '12:30:00', '15:30:00'),
(73, 73, 21, 'Thursday', '13:45:00', '16:45:00'),
(74, 75, 29, 'Monday', '14:00:00', '17:00:00'),
(75, 72, 33, 'Wednesday', '09:15:00', '12:15:00'),
(76, 80, 26, 'Monday', '08:45:00', '11:45:00'),
(77, 77, 33, 'Thursday', '08:45:00', '11:45:00'),
(78, 79, 24, 'Monday', '12:00:00', '15:00:00'),
(79, 76, 21, 'Wednesday', '13:15:00', '16:15:00'),
(80, 78, 22, 'Tuesday', '09:15:00', '12:15:00'),
(81, 84, 24, 'Tuesday', '11:45:00', '14:45:00'),
(82, 81, 30, 'Monday', '14:00:00', '17:00:00'),
(83, 83, 28, 'Monday', '08:00:00', '11:00:00'),
(84, 85, 24, 'Friday', '11:30:00', '14:30:00'),
(85, 82, 23, 'Wednesday', '12:00:00', '15:00:00'),
(86, 90, 24, 'Wednesday', '10:15:00', '13:15:00'),
(87, 87, 28, 'Thursday', '13:45:00', '16:45:00'),
(88, 89, 28, 'Tuesday', '12:00:00', '15:00:00'),
(89, 86, 27, 'Tuesday', '09:00:00', '12:00:00'),
(90, 88, 21, 'Thursday', '09:30:00', '12:30:00'),
(91, 92, 27, 'Wednesday', '10:45:00', '13:45:00'),
(92, 94, 26, 'Thursday', '13:45:00', '16:45:00'),
(93, 91, 29, 'Tuesday', '09:00:00', '12:00:00'),
(94, 93, 29, 'Friday', '08:15:00', '11:15:00'),
(95, 95, 27, 'Monday', '14:00:00', '17:00:00'),
(96, 98, 21, 'Tuesday', '13:15:00', '16:15:00'),
(97, 100, 25, 'Thursday', '10:45:00', '13:45:00'),
(98, 97, 21, 'Friday', '08:15:00', '11:15:00'),
(99, 99, 29, 'Wednesday', '08:15:00', '11:15:00'),
(100, 96, 27, 'Thursday', '14:00:00', '17:00:00'),
(101, 105, 36, 'Tuesday', '16:30:00', '19:30:00'),
(102, 102, 50, 'Saturday', '15:45:00', '18:45:00'),
(103, 107, 44, 'Friday', '16:45:00', '19:45:00'),
(104, 104, 38, 'Saturday', '08:45:00', '11:45:00'),
(105, 101, 49, 'Thursday', '17:00:00', '20:00:00'),
(106, 106, 39, 'Monday', '11:30:00', '14:30:00'),
(107, 103, 50, 'Saturday', '08:00:00', '11:00:00'),
(108, 109, 50, 'Wednesday', '17:00:00', '20:00:00'),
(109, 110, 50, 'Thursday', '16:30:00', '19:30:00'),
(110, 111, 35, 'Wednesday', '15:00:00', '18:00:00'),
(111, 112, 50, 'Tuesday', '17:00:00', '20:00:00'),
(112, 113, 51, 'Tuesday', '17:00:00', '20:00:00'),
(113, 114, 51, 'Wednesday', '17:00:00', '20:00:00'),
(114, 115, 51, 'Thursday', '17:00:00', '20:00:00'),
(115, 108, 50, 'Monday', '16:30:00', '19:30:00'),
(116, 116, 35, 'Tuesday', '15:00:00', '18:00:00'),
(117, 117, 35, 'Thursday', '16:00:00', '19:00:00'),
(118, 124, 51, 'Saturday', '17:00:00', '20:00:00'),
(119, 118, 51, 'Monday', '17:00:00', '20:00:00'),
(120, 125, 36, 'Thursday', '15:00:00', '18:00:00'),
(121, 119, 50, 'Friday', '16:30:00', '19:30:00'),
(122, 126, 51, 'Friday', '17:00:00', '20:00:00'),
(123, 120, 35, 'Monday', '15:30:00', '18:30:00'),
(124, 161, 37, 'Thursday', '16:30:00', '19:30:00'),
(125, 47, 51, 'Wednesday', '08:30:00', '11:30:00'),
(126, 127, 50, 'Friday', '13:30:00', '16:30:00'),
(127, 36, 50, 'Sunday', '14:00:00', '17:00:00'),
(128, 121, 51, 'Sunday', '16:30:00', '19:30:00'),
(129, 128, 50, 'Sunday', '17:00:00', '20:00:00'),
(130, 122, 38, 'Thursday', '17:00:00', '20:00:00');

--
-- Triggers `schedule`
--
DELIMITER $$
CREATE TRIGGER `check_instructor_unavailability` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN
    DECLARE unavailable_count INT;
    DECLARE instructor_id INT;
    
    SELECT instructor_id INTO instructor_id 
    FROM classes WHERE class_id = NEW.class_id;
    
    SELECT COUNT(*) INTO unavailable_count
    FROM faculty_unavailability fu
    WHERE fu.faculty_id = instructor_id
      AND fu.day_of_week = NEW.day_of_week
      AND fu.start_time <= NEW.start_time 
      AND fu.end_time >= NEW.end_time;
    
    IF unavailable_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'CONFLICT: Instructor is marked unavailable during this time slot.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_room_compatibility` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN
    DECLARE room_type_val VARCHAR(20);
    DECLARE requires_lab_val TINYINT;
    
    SELECT room_type INTO room_type_val
    FROM rooms WHERE room_id = NEW.room_id;
    
    SELECT co.requires_lab INTO requires_lab_val
    FROM classes c
    JOIN courses co ON c.course_id = co.course_id
    WHERE c.class_id = NEW.class_id;
    
    IF requires_lab_val = 1 AND room_type_val != 'lab' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'CONFLICT: Course requires a laboratory room, but assigned room is not a lab.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_instructor_conflict` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN
    DECLARE conflict_count INT;
    DECLARE instructor_id INT;
    DECLARE instructor_max_hours INT;
    DECLARE weekly_hours INT;
    DECLARE course_duration INT;

    SELECT instructor_id INTO instructor_id 
    FROM classes WHERE class_id = NEW.class_id;
    
    SELECT duration_hours INTO course_duration
    FROM courses c
    JOIN classes cl ON c.course_id = cl.course_id
    WHERE cl.class_id = NEW.class_id;

    SELECT COUNT(*) INTO conflict_count
    FROM schedule s
    JOIN classes c ON s.class_id = c.class_id
    WHERE c.instructor_id = instructor_id
      AND s.day_of_week = NEW.day_of_week
      AND (NEW.start_time < s.end_time AND NEW.end_time > s.start_time);

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'CONFLICT: Instructor already scheduled for another class at this time.';
    END IF;
    
    SELECT max_hours_per_week INTO instructor_max_hours 
    FROM employees WHERE employee_id = instructor_id AND is_faculty = 1;
    
    IF instructor_max_hours > 0 THEN
        SELECT COALESCE(SUM(co.duration_hours), 0) INTO weekly_hours
        FROM schedule s
        JOIN classes c ON s.class_id = c.class_id
        JOIN courses co ON c.course_id = co.course_id
        WHERE c.instructor_id = instructor_id;
        
        IF (weekly_hours + course_duration) > instructor_max_hours THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'CONFLICT: Would exceed instructor maximum weekly teaching hours.';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_room_conflict` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN
    DECLARE conflict_count INT;
    DECLARE room_capacity INT;
    DECLARE class_size INT;
    DECLARE new_dept_id INT;

    -- Determine department of the new class
    SELECT 
        CASE 
            WHEN c.course_id BETWEEN 1 AND 49 THEN 1
            WHEN c.course_id BETWEEN 50 AND 99 THEN 2
            WHEN c.course_id BETWEEN 100 AND 399 THEN 3
            WHEN c.course_id BETWEEN 400 AND 430 THEN 4
            ELSE 0
        END INTO new_dept_id
    FROM classes c
    WHERE c.class_id = NEW.class_id;

    -- Check room conflict ONLY within same department
    SELECT COUNT(*) INTO conflict_count
    FROM schedule s
    JOIN classes c ON s.class_id = c.class_id
    JOIN courses cr ON c.course_id = cr.course_id
    WHERE s.room_id = NEW.room_id 
      AND s.day_of_week = NEW.day_of_week
      AND (NEW.start_time < s.end_time AND NEW.end_time > s.start_time)
      AND (
          (new_dept_id = 1 AND cr.course_id BETWEEN 1 AND 49) OR
          (new_dept_id = 2 AND cr.course_id BETWEEN 50 AND 99) OR
          (new_dept_id = 3 AND cr.course_id BETWEEN 100 AND 399) OR
          (new_dept_id = 4 AND cr.course_id BETWEEN 400 AND 430)
      );

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'CONFLICT: Room already booked for this time slot in the same department.';
    END IF;

    -- Check capacity
    SELECT capacity INTO room_capacity FROM rooms WHERE room_id = NEW.room_id;
    SELECT max_enrollment INTO class_size FROM classes WHERE class_id = NEW.class_id;

    IF class_size > room_capacity THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'CONFLICT: Room capacity insufficient for class enrollment.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `schedule_errors`
--

CREATE TABLE `schedule_errors` (
  `error_id` int(11) NOT NULL,
  `class_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `error_message` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('M','F','Other') DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `first_name`, `last_name`, `dob`, `gender`, `enrollment_date`, `email`) VALUES
(1, 'Juan', 'Dela Cruz', '2004-01-15', 'M', '2025-08-01', 'juan.delacruz@student.ccse.edu.ph'),
(2, 'Maria', 'Santos', '2004-02-20', 'F', '2025-08-01', 'maria.santos@student.ccse.edu.ph'),
(3, 'Jose', 'Reyes', '2004-03-10', 'M', '2025-08-01', 'jose.reyes@student.ccse.edu.ph'),
(4, 'Ana', 'Garcia', '2004-04-05', 'F', '2025-08-01', 'ana.garcia@student.ccse.edu.ph'),
(5, 'Pedro', 'Luna', '2004-05-12', 'M', '2025-08-01', 'pedro.luna@student.ccse.edu.ph'),
(6, 'Rosa', 'Mendoza', '2004-06-18', 'F', '2025-08-01', 'rosa.mendoza@student.ccse.edu.ph'),
(7, 'Antonio', 'Flores', '2004-07-22', 'M', '2025-08-01', 'antonio.flores@student.ccse.edu.ph'),
(8, 'Teresa', 'Ramos', '2004-08-30', 'F', '2025-08-01', 'teresa.ramos@student.ccse.edu.ph'),
(9, 'Manuel', 'Torres', '2004-09-14', 'M', '2025-08-01', 'manuel.torres@student.ccse.edu.ph'),
(10, 'Elena', 'Aquino', '2004-10-25', 'F', '2025-08-01', 'elena.aquino@student.ccse.edu.ph'),
(11, 'Ricardo', 'Cruz', '2003-11-11', 'M', '2024-08-01', 'ricardo.cruz@student.ccse.edu.ph'),
(12, 'Isabella', 'Rivera', '2003-12-03', 'F', '2024-08-01', 'isabella.rivera@student.ccse.edu.ph'),
(13, 'Gabriel', 'Villanueva', '2004-01-19', 'M', '2024-08-01', 'gabriel.villanueva@student.ccse.edu.ph'),
(14, 'Sofia', 'Gonzales', '2004-02-28', 'F', '2024-08-01', 'sofia.gonzales@student.ccse.edu.ph'),
(15, 'Miguel', 'Dizon', '2004-03-17', 'M', '2024-08-01', 'miguel.dizon@student.ccse.edu.ph'),
(16, 'Andrea', 'Fernandez', '2003-04-09', 'F', '2023-08-01', 'andrea.fernandez@student.ccse.edu.ph'),
(17, 'Daniel', 'Lopez', '2003-05-21', 'M', '2023-08-01', 'daniel.lopez@student.ccse.edu.ph'),
(18, 'Patricia', 'Martinez', '2003-06-13', 'F', '2023-08-01', 'patricia.martinez@student.ccse.edu.ph'),
(19, 'Christopher', 'Perez', '2003-07-07', 'M', '2023-08-01', 'christopher.perez@student.ccse.edu.ph'),
(20, 'Kathleen', 'Morales', '2003-08-26', 'F', '2023-08-01', 'kathleen.morales@student.ccse.edu.ph'),
(21, 'Michael', 'Navarro', '2002-09-15', 'M', '2022-08-01', 'michael.navarro@student.ccse.edu.ph'),
(22, 'Catherine', 'Santiago', '2002-10-10', 'F', '2022-08-01', 'catherine.santiago@student.ccse.edu.ph'),
(23, 'Jonathan', 'Roxas', '2002-11-28', 'M', '2022-08-01', 'jonathan.roxas@student.ccse.edu.ph'),
(24, 'Megan', 'Bautista', '2002-12-14', 'F', '2022-08-01', 'megan.bautista@student.ccse.edu.ph'),
(25, 'Lawrence', 'Guevarra', '2002-01-22', 'M', '2022-08-01', 'lawrence.guevarra@student.ccse.edu.ph'),
(26, 'Angel', 'Rivera', '2003-05-18', 'F', '2024-08-01', 'angel.rivera@student.ccse.edu.ph'),
(27, 'Christian', 'Lopez', '2004-07-25', 'M', '2025-08-01', 'christian.lopez@student.ccse.edu.ph'),
(28, 'Diana', 'Cruz', '2003-11-02', 'F', '2023-08-01', 'diana.cruz@student.ccse.edu.ph'),
(29, 'Emmanuel', 'Santos', '2002-09-30', 'M', '2022-08-01', 'emmanuel.santos@student.ccse.edu.ph'),
(30, 'Francesca', 'Garcia', '2004-12-15', 'F', '2025-08-01', 'francesca.garcia@student.ccse.edu.ph'),
(31, 'Ferdinand', 'Marcos Jr.', '2004-05-15', 'M', '2025-08-01', 'ferdinand.marcos@student.polsci.edu.ph'),
(32, 'Leni', 'Robredo', '2004-08-23', 'F', '2025-08-01', 'leni.robredo@student.polsci.edu.ph'),
(33, 'Manny', 'Pacquiao', '2004-02-10', 'M', '2025-08-01', 'manny.pacquiao@student.polsci.edu.ph'),
(34, 'Grace', 'Poe', '2004-09-12', 'F', '2025-08-01', 'grace.poe@student.polsci.edu.ph'),
(35, 'Bongbong', 'Marcos', '2004-01-28', 'M', '2025-08-01', 'bongbong.marcos@student.polsci.edu.ph'),
(36, 'Isko', 'Moreno', '2004-10-15', 'M', '2025-08-01', 'isko.moreno@student.polsci.edu.ph'),
(37, 'Sara', 'Duterte', '2004-06-30', 'F', '2025-08-01', 'sara.duterte@student.polsci.edu.ph'),
(38, 'Kiko', 'Pangilinan', '2004-03-22', 'M', '2025-08-01', 'kiko.pangilinan@student.polsci.edu.ph'),
(39, 'Risa', 'Hontiveros', '2004-11-05', 'F', '2025-08-01', 'risa.hontiveros@student.polsci.edu.ph'),
(40, 'Alan Peter', 'Cayetano', '2004-07-18', 'M', '2025-08-01', 'alan.cayetano@student.polsci.edu.ph'),
(41, 'Pia', 'Cayetano', '2004-12-12', 'F', '2025-08-01', 'pia.cayetano@student.polsci.edu.ph'),
(42, 'Tito', 'Sotto', '2003-04-08', 'M', '2024-08-01', 'tito.sotto@student.polsci.edu.ph'),
(43, 'Vic', 'Sotto', '2003-09-25', 'M', '2024-08-01', 'vic.sotto@student.polsci.edu.ph'),
(44, 'Joey', 'De Venecia', '2004-01-14', 'M', '2024-08-01', 'joey.devenecia@student.polsci.edu.ph'),
(45, 'Loren', 'Legarda', '2003-06-19', 'F', '2024-08-01', 'loren.legarda@student.polsci.edu.ph'),
(46, 'Cynthia', 'Villar', '2003-11-29', 'F', '2023-08-01', 'cynthia.villar@student.polsci.edu.ph'),
(47, 'Mark', 'Villar', '2003-08-14', 'M', '2023-08-01', 'mark.villar@student.polsci.edu.ph'),
(48, 'Nancy', 'Binay', '2003-05-21', 'F', '2023-08-01', 'nancy.binay@student.polsci.edu.ph'),
(49, 'Jejomar', 'Binay Jr.', '2003-02-09', 'M', '2023-08-01', 'jejomar.binay@student.polsci.edu.ph'),
(50, 'Bam', 'Aquino', '2004-07-07', 'M', '2022-08-01', 'bam.aquino@student.polsci.edu.ph'),
(51, 'Kris', 'Aquino', '2002-10-10', 'F', '2022-08-01', 'kris.aquino@student.polsci.edu.ph'),
(52, 'Noynoy', 'Aquino', '2002-12-28', 'M', '2022-08-01', 'noynoy.aquino@student.polsci.edu.ph'),
(53, 'Cory', 'Aquino', '2003-01-25', 'F', '2023-08-01', 'cory.aquino@student.polsci.edu.ph'),
(54, 'Ninoy', 'Aquino', '2004-03-17', 'M', '2025-08-01', 'ninoy.aquino@student.polsci.edu.ph'),
(55, 'Gloria', 'Macapagal', '2003-04-28', 'F', '2024-08-01', 'gloria.macapagal@student.polsci.edu.ph'),
(56, 'Diosdado', 'Macapagal', '2002-09-03', 'M', '2022-08-01', 'diosdado.macapagal@student.polsci.edu.ph'),
(57, 'Ramon', 'Magsaysay', '2003-07-05', 'M', '2023-08-01', 'ramon.magsaysay@student.polsci.edu.ph'),
(58, 'Elpidio', 'Quirino', '2004-10-22', 'M', '2025-08-01', 'elpidio.quirino@student.polsci.edu.ph'),
(59, 'Manuel', 'Roxas', '2004-01-11', 'M', '2025-08-01', 'manuel.roxas@student.polsci.edu.ph'),
(60, 'Sergio', 'Osmeña', '2003-12-09', 'M', '2024-08-01', 'sergio.osmena@student.polsci.edu.ph'),
(61, 'Alice', 'Sy', '2004-05-20', 'F', '2025-08-01', 'alice.sy@student.cba.edu.ph'),
(62, 'Benjamin', 'Tan', '2004-08-15', 'M', '2025-08-01', 'benjamin.tan@student.cba.edu.ph'),
(63, 'Catherine', 'Lim', '2004-03-10', 'F', '2025-08-01', 'catherine.lim@student.cba.edu.ph'),
(64, 'David', 'Ong', '2004-11-22', 'M', '2025-08-01', 'david.ong@student.cba.edu.ph'),
(65, 'Erika', 'Chua', '2004-07-08', 'F', '2025-08-01', 'erika.chua@student.cba.edu.ph'),
(66, 'Francis', 'Uy', '2004-02-14', 'M', '2025-08-01', 'francis.uy@student.cba.edu.ph'),
(67, 'Grace', 'Go', '2004-09-30', 'F', '2025-08-01', 'grace.go@student.cba.edu.ph'),
(68, 'Henry', 'Co', '2004-04-25', 'M', '2025-08-01', 'henry.co@student.cba.edu.ph'),
(69, 'Isabel', 'Yap', '2004-12-12', 'F', '2025-08-01', 'isabel.yap@student.cba.edu.ph'),
(70, 'John', 'Yao', '2004-06-18', 'M', '2025-08-01', 'john.yao@student.cba.edu.ph'),
(71, 'Karen', 'Cheng', '2004-01-05', 'F', '2025-08-01', 'karen.cheng@student.cba.edu.ph'),
(72, 'Leo', 'Ang', '2004-10-10', 'M', '2025-08-01', 'leo.ang@student.cba.edu.ph'),
(73, 'Maria', 'Lao', '2004-03-28', 'F', '2025-08-01', 'maria.lao@student.cba.edu.ph'),
(74, 'Nathan', 'Sy', '2004-07-19', 'M', '2025-08-01', 'nathan.sy@student.cba.edu.ph'),
(75, 'Olivia', 'Tan', '2004-09-09', 'F', '2025-08-01', 'olivia.tan@student.cba.edu.ph'),
(76, 'Paul', 'Lim', '2004-05-05', 'M', '2025-08-01', 'paul.lim@student.cba.edu.ph'),
(77, 'Rachel', 'Ong', '2004-11-11', 'F', '2025-08-01', 'rachel.ong@student.cba.edu.ph'),
(78, 'Samuel', 'Chua', '2004-02-20', 'M', '2025-08-01', 'samuel.chua@student.cba.edu.ph'),
(79, 'Tina', 'Uy', '2004-08-08', 'F', '2025-08-01', 'tina.uy@student.cba.edu.ph'),
(80, 'Victor', 'Go', '2004-12-25', 'M', '2025-08-01', 'victor.go@student.cba.edu.ph'),
(81, 'Wendy', 'Co', '2003-04-15', 'F', '2024-08-01', 'wendy.co@student.cba.edu.ph'),
(82, 'Xavier', 'Yap', '2003-07-22', 'M', '2024-08-01', 'xavier.yap@student.cba.edu.ph'),
(83, 'Yvonne', 'Yao', '2003-10-30', 'F', '2024-08-01', 'yvonne.yao@student.cba.edu.ph'),
(84, 'Zachary', 'Cheng', '2003-01-18', 'M', '2024-08-01', 'zachary.cheng@student.cba.edu.ph'),
(85, 'Anna', 'Ang', '2002-06-12', 'F', '2023-08-01', 'anna.ang@student.cba.edu.ph'),
(86, 'Brian', 'Lao', '2002-09-25', 'M', '2023-08-01', 'brian.lao@student.cba.edu.ph'),
(87, 'Carla', 'Sy', '2002-11-08', 'F', '2023-08-01', 'carla.sy@student.cba.edu.ph'),
(88, 'Dennis', 'Tan', '2002-03-14', 'M', '2023-08-01', 'dennis.tan@student.cba.edu.ph'),
(89, 'Emma', 'Lim', '2001-08-19', 'F', '2022-08-01', 'emma.lim@student.cba.edu.ph'),
(90, 'Felix', 'Ong', '2001-12-01', 'M', '2022-08-01', 'felix.ong@student.cba.edu.ph'),
(91, 'Aaron', 'Smith', '2005-01-15', 'M', '2025-08-01', 'aaron.smith@student.hki.edu.ph'),
(92, 'Bella', 'Johnson', '2005-02-20', 'F', '2025-08-01', 'bella.johnson@student.hki.edu.ph'),
(93, 'Caleb', 'Williams', '2005-03-10', 'M', '2025-08-01', 'caleb.williams@student.hki.edu.ph'),
(94, 'Daisy', 'Brown', '2005-04-05', 'F', '2025-08-01', 'daisy.brown@student.hki.edu.ph'),
(95, 'Ethan', 'Jones', '2005-05-12', 'M', '2025-08-01', 'ethan.jones@student.hki.edu.ph'),
(96, 'Faith', 'Garcia', '2005-06-18', 'F', '2025-08-01', 'faith.garcia@student.hki.edu.ph'),
(97, 'Gabriel', 'Miller', '2005-07-22', 'M', '2025-08-01', 'gabriel.miller@student.hki.edu.ph'),
(98, 'Hannah', 'Davis', '2005-08-30', 'F', '2025-08-01', 'hannah.davis@student.hki.edu.ph'),
(99, 'Ian', 'Rodriguez', '2005-09-14', 'M', '2025-08-01', 'ian.rodriguez@student.hki.edu.ph'),
(100, 'Julia', 'Martinez', '2005-10-25', 'F', '2025-08-01', 'julia.martinez@student.hki.edu.ph'),
(101, 'Kevin', 'Hernandez', '2005-11-11', 'M', '2025-08-01', 'kevin.hernandez@student.hki.edu.ph'),
(102, 'Lily', 'Lopez', '2005-12-03', 'F', '2025-08-01', 'lily.lopez@student.hki.edu.ph'),
(103, 'Mason', 'Gonzales', '2005-01-19', 'M', '2025-08-01', 'mason.gonzales@student.hki.edu.ph'),
(104, 'Nora', 'Perez', '2005-02-28', 'F', '2025-08-01', 'nora.perez@student.hki.edu.ph'),
(105, 'Oscar', 'Torres', '2005-03-17', 'M', '2025-08-01', 'oscar.torres@student.hki.edu.ph'),
(106, 'Paula', 'Flores', '2004-04-09', 'F', '2024-08-01', 'paula.flores@student.hki.edu.ph'),
(107, 'Quinn', 'Rivera', '2004-05-21', 'M', '2024-08-01', 'quinn.rivera@student.hki.edu.ph'),
(108, 'Rose', 'Cruz', '2004-06-13', 'F', '2024-08-01', 'rose.cruz@student.hki.edu.ph'),
(109, 'Sam', 'Reyes', '2004-07-07', 'M', '2024-08-01', 'sam.reyes@student.hki.edu.ph'),
(110, 'Tina', 'Aquino', '2004-08-26', 'F', '2024-08-01', 'tina.aquino@student.hki.edu.ph'),
(111, 'Ulysses', 'Mendoza', '2004-09-15', 'M', '2024-08-01', 'ulysses.mendoza@student.hki.edu.ph'),
(112, 'Vera', 'Gomez', '2004-10-10', 'F', '2024-08-01', 'vera.gomez@student.hki.edu.ph'),
(113, 'Wesley', 'Diaz', '2004-11-28', 'M', '2024-08-01', 'wesley.diaz@student.hki.edu.ph'),
(114, 'Xena', 'Castro', '2004-12-14', 'F', '2024-08-01', 'xena.castro@student.hki.edu.ph'),
(115, 'Yuri', 'Ortiz', '2004-01-22', 'M', '2024-08-01', 'yuri.ortiz@student.hki.edu.ph'),
(116, 'Zara', 'Morales', '2004-02-28', 'F', '2024-08-01', 'zara.morales@student.hki.edu.ph'),
(117, 'Adam', 'Ramirez', '2004-03-30', 'M', '2024-08-01', 'adam.ramirez@student.hki.edu.ph'),
(118, 'Beth', 'Santiago', '2004-04-17', 'F', '2024-08-01', 'beth.santiago@student.hki.edu.ph'),
(119, 'Carl', 'Villanueva', '2004-05-25', 'M', '2024-08-01', 'carl.villanueva@student.hki.edu.ph'),
(120, 'Dina', 'Guevarra', '2004-06-08', 'F', '2024-08-01', 'dina.guevarra@student.hki.edu.ph'),
(121, 'Edward', 'Bautista', '2003-07-19', 'M', '2023-08-01', 'edward.bautista@student.hki.edu.ph'),
(122, 'Faye', 'Ramos', '2003-08-23', 'F', '2023-08-01', 'faye.ramos@student.hki.edu.ph'),
(123, 'George', 'Luna', '2003-09-11', 'M', '2023-08-01', 'george.luna@student.hki.edu.ph'),
(124, 'Helen', 'Valdez', '2003-10-05', 'F', '2023-08-01', 'helen.valdez@student.hki.edu.ph'),
(125, 'Ivy', 'Salazar', '2003-11-20', 'F', '2023-08-01', 'ivy.salazar@student.hki.edu.ph'),
(126, 'Jack', 'Magsino', '2003-12-08', 'M', '2023-08-01', 'jack.magsino@student.hki.edu.ph'),
(127, 'Kate', 'David', '2003-01-16', 'F', '2023-08-01', 'kate.david@student.hki.edu.ph'),
(128, 'Leo', 'Castro', '2003-02-24', 'M', '2023-08-01', 'leo.castro@student.hki.edu.ph'),
(129, 'Mia', 'Alcantara', '2003-03-14', 'F', '2023-08-01', 'mia.alcantara@student.hki.edu.ph'),
(130, 'Noah', 'Manuel', '2003-04-22', 'M', '2023-08-01', 'noah.manuel@student.hki.edu.ph'),
(131, 'Olga', 'Pascual', '2003-05-30', 'F', '2023-08-01', 'olga.pascual@student.hki.edu.ph'),
(132, 'Peter', 'Estrada', '2003-06-18', 'M', '2023-08-01', 'peter.estrada@student.hki.edu.ph'),
(133, 'Queenie', 'Guevarra', '2003-07-07', 'F', '2023-08-01', 'queenie.guevarra@student.hki.edu.ph'),
(134, 'Ryan', 'Villanueva', '2003-08-29', 'M', '2023-08-01', 'ryan.villanueva@student.hki.edu.ph'),
(135, 'Sonia', 'Bautista', '2003-09-17', 'F', '2023-08-01', 'sonia.bautista@student.hki.edu.ph'),
(136, 'Tom', 'Lim', '2002-10-10', 'M', '2022-08-01', 'tom.lim@student.hki.edu.ph'),
(137, 'Uma', 'Chua', '2002-11-28', 'F', '2022-08-01', 'uma.chua@student.hki.edu.ph'),
(138, 'Vince', 'Ong', '2002-12-14', 'M', '2022-08-01', 'vince.ong@student.hki.edu.ph'),
(139, 'Wendy', 'Yap', '2002-01-22', 'F', '2022-08-01', 'wendy.yap@student.hki.edu.ph'),
(140, 'Xander', 'Co', '2002-02-28', 'M', '2022-08-01', 'xander.co@student.hki.edu.ph'),
(141, 'Yasmin', 'Ang', '2002-03-15', 'F', '2022-08-01', 'yasmin.ang@student.hki.edu.ph'),
(142, 'Zion', 'Lao', '2002-04-20', 'M', '2022-08-01', 'zion.lao@student.hki.edu.ph'),
(143, 'April', 'Sy', '2002-05-25', 'F', '2022-08-01', 'april.sy@student.hki.edu.ph'),
(144, 'Bruce', 'Tan', '2002-06-30', 'M', '2022-08-01', 'bruce.tan@student.hki.edu.ph'),
(145, 'Chloe', 'Uy', '2002-07-14', 'F', '2022-08-01', 'chloe.uy@student.hki.edu.ph'),
(146, 'Drake', 'Go', '2002-08-19', 'M', '2022-08-01', 'drake.go@student.hki.edu.ph'),
(147, 'Ellie', 'Cheng', '2002-09-23', 'F', '2022-08-01', 'ellie.cheng@student.hki.edu.ph'),
(148, 'Finn', 'Yao', '2002-10-27', 'M', '2022-08-01', 'finn.yao@student.hki.edu.ph'),
(149, 'Gwen', 'Lee', '2002-11-11', 'F', '2022-08-01', 'gwen.lee@student.hki.edu.ph'),
(150, 'Hugo', 'King', '2002-12-25', 'M', '2022-08-01', 'hugo.king@student.hki.edu.ph');

-- --------------------------------------------------------

--
-- Table structure for table `student_payments`
--

CREATE TABLE `student_payments` (
  `payment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `pay_date` date DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_payments`
--

INSERT INTO `student_payments` (`payment_id`, `student_id`, `amount`, `pay_date`, `description`) VALUES
(1, 1, 25000.00, '2025-08-15', '1st Semester Tuition'),
(2, 1, 25000.00, '2026-01-10', '2nd Semester Tuition'),
(3, 2, 25000.00, '2025-08-15', '1st Semester Tuition'),
(4, 3, 25000.00, '2025-08-16', '1st Semester Tuition'),
(5, 4, 25000.00, '2025-08-15', '1st Semester Tuition'),
(6, 5, 25000.00, '2025-08-17', '1st Semester Tuition'),
(7, 31, 18000.00, '2025-08-15', '1st Semester Tuition - POLSCI'),
(8, 31, 18000.00, '2026-01-10', '2nd Semester Tuition - POLSCI'),
(9, 32, 18000.00, '2025-08-15', '1st Semester Tuition - POLSCI'),
(10, 33, 18000.00, '2025-08-16', '1st Semester Tuition - POLSCI'),
(11, 34, 18000.00, '2025-08-15', '1st Semester Tuition - POLSCI'),
(12, 35, 18000.00, '2025-08-17', '1st Semester Tuition - POLSCI'),
(13, 61, 22000.00, '2025-08-15', '1st Semester Tuition - CBA'),
(14, 61, 22000.00, '2026-01-10', '2nd Semester Tuition - CBA'),
(15, 62, 22000.00, '2025-08-15', '1st Semester Tuition - CBA'),
(16, 63, 22000.00, '2025-08-16', '1st Semester Tuition - CBA'),
(17, 64, 22000.00, '2025-08-15', '1st Semester Tuition - CBA'),
(18, 65, 22000.00, '2025-08-17', '1st Semester Tuition - CBA');

-- --------------------------------------------------------

--
-- Table structure for table `submissions`
--

CREATE TABLE `submissions` (
  `submission_id` int(11) NOT NULL,
  `assignment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `submit_date` datetime DEFAULT NULL,
  `grade` varchar(10) DEFAULT NULL,
  `feedback` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `name`, `contact_person`, `phone`, `email`, `address`) VALUES
(1, 'Office Warehouse', 'John Santos', '02-8123-4567', 'sales@officewarehouse.ph', '123 Main St, Manila'),
(2, 'PC Express', 'Maria Cruz', '02-8765-4321', 'info@pcexpress.ph', '456 Tech Ave, Quezon City'),
(3, 'National Book Store', 'Robert Lee', '02-8901-2345', 'supply@nationalbookstore.ph', '789 Book St, Makati');

-- --------------------------------------------------------

--
-- Table structure for table `surveys`
--

CREATE TABLE `surveys` (
  `survey_id` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `surveys`
--

INSERT INTO `surveys` (`survey_id`, `title`, `description`, `created_date`) VALUES
(1, 'CCSE Faculty Evaluation Survey', 'Student evaluation of CCSE faculty performance', '2025-08-01'),
(2, 'CCSE Program Satisfaction Survey', 'Student satisfaction with CCSE academic programs', '2025-08-01'),
(3, 'CCSE Alumni Tracer Study', 'Employment and career tracking of CCSE graduates', '2025-08-15'),
(4, 'CCSE Employer Feedback Survey', 'Employer feedback on CCSE graduate performance', '2025-08-15'),
(5, 'CCSE Lab Facilities Survey', 'Student feedback on CCSE laboratory facilities', '2025-08-10'),
(6, 'POLSCI Program Satisfaction Survey', 'Student satisfaction with POLSCI academic programs', '2025-08-01'),
(7, 'POLSCI Faculty Evaluation Survey', 'Student evaluation of POLSCI faculty performance', '2025-08-01'),
(8, 'POLSCI Alumni Tracer Study', 'Employment and career tracking of POLSCI graduates', '2025-08-15'),
(9, 'POLSCI Debate Program Feedback', 'Feedback on debate training and competition program', '2025-08-10'),
(10, 'CBA Program Satisfaction Survey', 'Student satisfaction with BSBA academic programs', '2025-08-01'),
(11, 'CBA Faculty Evaluation Survey', 'Student evaluation of CBA faculty performance', '2025-08-01'),
(12, 'CBA Alumni Tracer Study', 'Employment and career tracking of CBA graduates', '2025-08-15'),
(13, 'CBA Employer Feedback Survey', 'Employer feedback on CBA graduate performance', '2025-08-15'),
(14, 'CBA Business Lab Facilities Survey', 'Student feedback on CBA business lab facilities', '2025-08-10');

-- --------------------------------------------------------

--
-- Table structure for table `survey_responses`
--

CREATE TABLE `survey_responses` (
  `response_id` int(11) NOT NULL,
  `survey_id` int(11) NOT NULL,
  `respondent_role` varchar(50) DEFAULT NULL,
  `question` varchar(255) DEFAULT NULL,
  `answer` text DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `response_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `survey_responses`
--

INSERT INTO `survey_responses` (`response_id`, `survey_id`, `respondent_role`, `question`, `answer`, `rating`, `response_date`) VALUES
(1, 1, 'Student', 'Rate the instructor\'s teaching effectiveness', 'Very effective', 5, '2025-12-15'),
(2, 1, 'Student', 'Rate the course organization', 'Well organized', 4, '2025-12-15'),
(3, 2, 'Student', 'Overall satisfaction with CCSE program', 'Satisfied', 4, '2025-12-20'),
(4, 5, 'Student', 'Lab equipment condition', 'Good condition', 4, '2025-12-10'),
(5, 6, 'Student', 'Overall satisfaction with POLSCI program', 'Very satisfied', 5, '2025-12-20'),
(6, 6, 'Student', 'Quality of faculty instruction', 'Excellent', 5, '2025-12-20'),
(7, 7, 'Student', 'Rate the instructor\'s teaching effectiveness', 'Very effective', 5, '2025-12-15'),
(8, 7, 'Student', 'Rate the course organization', 'Well organized', 4, '2025-12-15'),
(9, 8, 'Alumni', 'Relevance of POLSCI degree to current job', 'Highly relevant', 5, '2025-12-10'),
(10, 10, 'Student', 'Overall satisfaction with BSBA program', 'Very satisfied', 5, '2025-12-20'),
(11, 10, 'Student', 'Quality of faculty instruction', 'Excellent', 5, '2025-12-20'),
(12, 11, 'Student', 'Rate the instructor\'s teaching effectiveness', 'Very effective', 5, '2025-12-15'),
(13, 11, 'Student', 'Rate the course organization', 'Well organized', 4, '2025-12-15'),
(14, 12, 'Alumni', 'Relevance of BSBA degree to current job', 'Highly relevant', 5, '2025-12-10');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `transaction_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `trans_date` date NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `type` enum('Debit','Credit') NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`transaction_id`, `account_id`, `trans_date`, `amount`, `type`, `description`) VALUES
(1, 7, '2025-08-15', 1500000.00, 'Credit', 'Laboratory fees collection'),
(2, 6, '2025-08-01', 5000000.00, 'Credit', 'Annual budget allocation'),
(3, 8, '2025-09-10', 250000.00, 'Debit', 'Computer equipment purchase'),
(4, 9, '2025-10-05', 50000.00, 'Debit', 'Office supplies'),
(5, 10, '2025-11-20', 35000.00, 'Debit', 'Laboratory maintenance'),
(6, 14, '2025-08-15', 540000.00, 'Credit', 'POLSCI program fees collection'),
(7, 13, '2025-08-01', 3500000.00, 'Credit', 'POLSCI annual budget allocation'),
(8, 15, '2025-09-10', 50000.00, 'Debit', 'POLSCI seminar materials purchase'),
(9, 16, '2025-10-05', 75000.00, 'Debit', 'POLSCI research grant disbursement'),
(10, 17, '2025-11-20', 25000.00, 'Debit', 'Debate competition expenses'),
(11, 24, '2025-08-15', 1200000.00, 'Credit', 'Tuition fees collection'),
(12, 23, '2025-08-01', 4200000.00, 'Credit', 'Annual budget allocation'),
(13, 25, '2025-09-10', 180000.00, 'Debit', 'Business lab equipment purchase'),
(14, 26, '2025-10-05', 45000.00, 'Debit', 'Office supplies'),
(15, 27, '2025-11-20', 30000.00, 'Debit', 'Business lab maintenance'),
(16, 28, '2025-11-15', 25000.00, 'Debit', 'Marketing materials for CBA events'),
(17, 29, '2025-10-25', 50000.00, 'Debit', 'Business research grant'),
(18, 37, '2025-08-15', 1400000.00, 'Credit', 'Program fees collection - HKI'),
(19, 36, '2025-08-01', 4800000.00, 'Credit', 'Annual budget allocation - HKI'),
(20, 38, '2025-09-10', 200000.00, 'Debit', 'Knowledge lab equipment purchase'),
(21, 39, '2025-10-05', 45000.00, 'Debit', 'Office supplies - HKI'),
(22, 40, '2025-11-20', 30000.00, 'Debit', 'Lab maintenance - HKI'),
(23, 41, '2025-10-25', 60000.00, 'Debit', 'Knowledge science research grant');

-- --------------------------------------------------------

--
-- Table structure for table `vendor_payments`
--

CREATE TABLE `vendor_payments` (
  `payment_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `po_id` int(11) DEFAULT NULL,
  `pay_date` date NOT NULL,
  `amount` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vendor_payments`
--

INSERT INTO `vendor_payments` (`payment_id`, `supplier_id`, `po_id`, `pay_date`, `amount`) VALUES
(1, 1, 1, '2026-02-25', 12000.00),
(2, 3, 2, '2026-03-01', 35000.00),
(3, 1, 4, '2026-02-28', 50000.00),
(4, 3, 5, '2026-03-05', 80000.00),
(5, 1, 6, '2026-02-28', 51000.00),
(6, 3, 7, '2026-03-05', 96000.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`);

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `fk_assign_class` (`class_id`);

--
-- Indexes for table `budgets`
--
ALTER TABLE `budgets`
  ADD PRIMARY KEY (`budget_id`),
  ADD KEY `fk_budget_dept` (`department_id`);

--
-- Indexes for table `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`class_id`),
  ADD KEY `fk_class_course` (`course_id`),
  ADD KEY `fk_class_instructor` (`instructor_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD UNIQUE KEY `course_code` (`course_code`);

--
-- Indexes for table `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  ADD PRIMARY KEY (`prereq_id`),
  ADD KEY `fk_prereq_course` (`course_id`),
  ADD KEY `fk_prereq_prerequisite` (`prerequisite_course_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`department_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`),
  ADD KEY `fk_emp_department` (`department_id`),
  ADD KEY `fk_emp_position` (`position_id`);

--
-- Indexes for table `employee_leave`
--
ALTER TABLE `employee_leave`
  ADD PRIMARY KEY (`leave_id`),
  ADD KEY `fk_leave_employee` (`employee_id`);

--
-- Indexes for table `employee_payments`
--
ALTER TABLE `employee_payments`
  ADD PRIMARY KEY (`pay_id`),
  ADD KEY `fk_pay_employee` (`employee_id`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD KEY `fk_enroll_class` (`class_id`),
  ADD KEY `fk_enroll_student` (`student_id`);

--
-- Indexes for table `evaluation_details`
--
ALTER TABLE `evaluation_details`
  ADD PRIMARY KEY (`detail_id`),
  ADD KEY `fk_detail_eval` (`eval_id`),
  ADD KEY `fk_detail_criterion` (`criterion_id`);

--
-- Indexes for table `eval_criteria`
--
ALTER TABLE `eval_criteria`
  ADD PRIMARY KEY (`criterion_id`);

--
-- Indexes for table `event_requests`
--
ALTER TABLE `event_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `requested_by` (`requested_by`),
  ADD KEY `reviewed_by` (`reviewed_by`);

--
-- Indexes for table `faculty_evaluations`
--
ALTER TABLE `faculty_evaluations`
  ADD PRIMARY KEY (`eval_id`),
  ADD KEY `fk_eval_faculty` (`faculty_id`),
  ADD KEY `fk_eval_evaluator` (`evaluator_id`);

--
-- Indexes for table `faculty_unavailability`
--
ALTER TABLE `faculty_unavailability`
  ADD PRIMARY KEY (`unavailability_id`),
  ADD KEY `faculty_id` (`faculty_id`);

--
-- Indexes for table `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD PRIMARY KEY (`inventory_id`),
  ADD KEY `fk_item_supplier` (`supplier_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`);

--
-- Indexes for table `positions`
--
ALTER TABLE `positions`
  ADD PRIMARY KEY (`position_id`);

--
-- Indexes for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD PRIMARY KEY (`po_item_id`),
  ADD KEY `fk_pi_po` (`po_id`),
  ADD KEY `fk_pi_item` (`inventory_id`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`po_id`),
  ADD KEY `fk_po_supplier` (`supplier_id`);

--
-- Indexes for table `qa_indicators`
--
ALTER TABLE `qa_indicators`
  ADD PRIMARY KEY (`indicator_id`);

--
-- Indexes for table `qa_records`
--
ALTER TABLE `qa_records`
  ADD PRIMARY KEY (`record_id`),
  ADD KEY `fk_qa_indicator` (`indicator_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`reservation_id`),
  ADD KEY `fk_res_resource` (`resource_id`),
  ADD KEY `fk_res_emp` (`reserved_by_employee`),
  ADD KEY `fk_res_student` (`reserved_by_student`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`resource_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `schedule`
--
ALTER TABLE `schedule`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `fk_sched_class` (`class_id`),
  ADD KEY `fk_sched_room` (`room_id`);

--
-- Indexes for table `schedule_errors`
--
ALTER TABLE `schedule_errors`
  ADD PRIMARY KEY (`error_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`);

--
-- Indexes for table `student_payments`
--
ALTER TABLE `student_payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `fk_spay_student` (`student_id`);

--
-- Indexes for table `submissions`
--
ALTER TABLE `submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `fk_sub_assign` (`assignment_id`),
  ADD KEY `fk_sub_student` (`student_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `surveys`
--
ALTER TABLE `surveys`
  ADD PRIMARY KEY (`survey_id`);

--
-- Indexes for table `survey_responses`
--
ALTER TABLE `survey_responses`
  ADD PRIMARY KEY (`response_id`),
  ADD KEY `fk_survey` (`survey_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `fk_trans_account` (`account_id`);

--
-- Indexes for table `vendor_payments`
--
ALTER TABLE `vendor_payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `fk_vpay_supplier` (`supplier_id`),
  ADD KEY `fk_vpay_po` (`po_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `budgets`
--
ALTER TABLE `budgets`
  MODIFY `budget_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `classes`
--
ALTER TABLE `classes`
  MODIFY `class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=221;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=431;

--
-- AUTO_INCREMENT for table `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  MODIFY `prereq_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `department_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `employee_leave`
--
ALTER TABLE `employee_leave`
  MODIFY `leave_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `employee_payments`
--
ALTER TABLE `employee_payments`
  MODIFY `pay_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=211;

--
-- AUTO_INCREMENT for table `evaluation_details`
--
ALTER TABLE `evaluation_details`
  MODIFY `detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `eval_criteria`
--
ALTER TABLE `eval_criteria`
  MODIFY `criterion_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `event_requests`
--
ALTER TABLE `event_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `faculty_evaluations`
--
ALTER TABLE `faculty_evaluations`
  MODIFY `eval_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `faculty_unavailability`
--
ALTER TABLE `faculty_unavailability`
  MODIFY `unavailability_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `inventory_items`
--
ALTER TABLE `inventory_items`
  MODIFY `inventory_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `positions`
--
ALTER TABLE `positions`
  MODIFY `position_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `purchase_items`
--
ALTER TABLE `purchase_items`
  MODIFY `po_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `po_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `qa_indicators`
--
ALTER TABLE `qa_indicators`
  MODIFY `indicator_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `qa_records`
--
ALTER TABLE `qa_records`
  MODIFY `record_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `reservation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `resources`
--
ALTER TABLE `resources`
  MODIFY `resource_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `schedule`
--
ALTER TABLE `schedule`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=131;

--
-- AUTO_INCREMENT for table `schedule_errors`
--
ALTER TABLE `schedule_errors`
  MODIFY `error_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=151;

--
-- AUTO_INCREMENT for table `student_payments`
--
ALTER TABLE `student_payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `submissions`
--
ALTER TABLE `submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `surveys`
--
ALTER TABLE `surveys`
  MODIFY `survey_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `survey_responses`
--
ALTER TABLE `survey_responses`
  MODIFY `response_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `vendor_payments`
--
ALTER TABLE `vendor_payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `fk_assign_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`);

--
-- Constraints for table `budgets`
--
ALTER TABLE `budgets`
  ADD CONSTRAINT `fk_budget_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`);

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `fk_emp_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),
  ADD CONSTRAINT `fk_emp_position` FOREIGN KEY (`position_id`) REFERENCES `positions` (`position_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
