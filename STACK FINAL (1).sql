CREATE TABLE `users` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `address` text,
  `phone` varchar(20),
  `bio` text,
  `created_at` timestamp DEFAULT (now()),
  `updated_at` timestamp DEFAULT (now())
);

CREATE TABLE `educations` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `university` varchar(255) NOT NULL,
  `major` varchar(255) NOT NULL,
  `start_year` int NOT NULL,
  `end_year` int NOT NULL,
  `gpa` decimal(3,2)
);

CREATE TABLE `skills` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) UNIQUE NOT NULL
);

CREATE TABLE `user_skills` (
  `user_id` int,
  `skill_id` int,
  `proficiency_level` enum('Frontend Development', 'Backend Development', 'UI/UX Design', 'Mobile Development', 'Data Science', 'Machine Learning', 'Cloud Computing', 'DevOps', 'Cybersecurity', 'Blockchain', 'Digital Marketing', 'Project Management'),
  PRIMARY KEY (`user_id`, `skill_id`)
);

CREATE TABLE `social_medias` (
  `user_id` int,
  `platform` enum('instagram', 'linkedin', 'github', 'other'),
  `url` varchar(2048) NOT NULL,
  PRIMARY KEY (`user_id`, `platform`)
);

CREATE TABLE `certificates` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `activity_name` varchar(255) NOT NULL,
  `issuer` varchar(255) NOT NULL,
  `activity_year` int NOT NULL,
  `file_url` varchar(512) NOT NULL,
  `verification_status` enum('pending', 'verified', 'rejected') DEFAULT 'pending'
);

CREATE TABLE `user_cvs` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `cv_url` varchar(512) NOT NULL,
  `uploaded_at` timestamp DEFAULT (now()),
  `is_default` boolean DEFAULT false
);

CREATE TABLE `companies` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) UNIQUE NOT NULL,
  `location` varchar(255) NOT NULL,
  `industry` varchar(255) NOT NULL,
  `verification_status` enum('pending', 'verified', 'rejected') DEFAULT 'pending',
  `verification_notes` text,
  `verified_by` int,
  `verified_at` timestamp,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `company_verifications` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `employee_id` int NOT NULL,
  `status` enum('verified', 'rejected') NOT NULL,
  `verification_notes` text NOT NULL,
  `verified_at` timestamp DEFAULT (now())
);

CREATE TABLE `admins` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `employees` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `job_postings` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `admin_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `location_type` enum('online', 'onsite') NOT NULL,
  `address` text,
  `start_date` date NOT NULL,
  `duration` varchar(50) NOT NULL,
  `min_education` enum('high_school', 'diploma', 'S1 Informatika', 'S1 Sistem Informasi') NOT NULL,
  `reward` text NOT NULL,
  `description` text NOT NULL,
  `posted_at` timestamp DEFAULT (now()),
  `application_deadline` date NOT NULL,
  `is_active` boolean DEFAULT true
);

CREATE TABLE `job_applications` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `job_id` int NOT NULL,
  `cv_id` int NOT NULL,
  `applied_at` timestamp DEFAULT (now()),
  `status` enum('pending', 'under_review', 'accepted', 'rejected') DEFAULT 'pending',
  `rejection_reason` text,
  `reviewed_by` int,
  `reviewed_at` timestamp
);

ALTER TABLE `educations` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `user_skills` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `user_skills` ADD FOREIGN KEY (`skill_id`) REFERENCES `skills` (`id`);

ALTER TABLE `social_medias` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `certificates` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `user_cvs` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `admins` ADD FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`);

ALTER TABLE `company_verifications` ADD FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`);

ALTER TABLE `company_verifications` ADD FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

ALTER TABLE `companies` ADD FOREIGN KEY (`verified_by`) REFERENCES `employees` (`id`);

ALTER TABLE `job_postings` ADD FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`);

ALTER TABLE `job_applications` ADD FOREIGN KEY (`job_id`) REFERENCES `job_postings` (`id`);

ALTER TABLE `job_applications` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `job_applications` ADD FOREIGN KEY (`cv_id`) REFERENCES `user_cvs` (`id`);

ALTER TABLE `job_applications` ADD FOREIGN KEY (`reviewed_by`) REFERENCES `admins` (`id`);