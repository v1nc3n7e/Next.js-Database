-- Students Table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- Fees Payments Table
CREATE TABLE fees_payments (
    payment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL 
);

-- Courses Table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    credits INT NOT NULL
);

-- Enrollments Table
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    course_id INT REFERENCES courses(course_id),
    enrollment_date DATE NOT NULL
);

-- Lectures Table
CREATE TABLE lectures (
    lecture_id SERIAL PRIMARY KEY,
    course_id INT REFERENCES courses(course_id),
    lecturer_name VARCHAR(100) NOT NULL,
    lecture_time TIME NOT NULL,
    lecture_day VARCHAR(15) NOT NULL 
);

-- TA Assignments Table
CREATE TABLE ta_assignments (
    assignment_id SERIAL PRIMARY KEY,
    lecture_id INT REFERENCES lectures(lecture_id),
    ta_name VARCHAR(100) NOT NULL
);

-- Insert into Students
INSERT INTO students (first_name, last_name, dob, email, phone) VALUES
('Kofi', 'Dogbe', '2000-01-01', 'kofi.do@example.com', '123-456-7890'),
('Yao', 'Kutor', '1999-05-15', 'yao.k@example.com', '098-765-4321');

-- Insert into Fees Payments
INSERT INTO fees_payments (student_id, amount, payment_date, status) VALUES
(1, 5000.00, '2024-01-10', 'paid'),
(2, 3000.00, '2024-02-20', 'pending');

-- Insert into Courses
INSERT INTO courses (course_name, course_code, credits) VALUES
('Software Engineering', 'CPEN208', 3),
('Data Structures', 'CPEN202', 4);

-- Insert into Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2024-03-01'),
(2, 2, '2024-03-02');

-- Insert into Lectures
INSERT INTO lectures (course_id, lecturer_name, lecture_time, lecture_day) VALUES
(1, 'Dr. Frank Aboagye', '13:00', 'Monday'),
(2, 'Dr. Bobby Asiamah', '9:00', 'Wednesday');

-- Insert into TA Assignments
INSERT INTO ta_assignments (lecture_id, ta_name) VALUES
(1, 'Anas');

-- Create a function to calculate outstanding fees
CREATE OR REPLACE FUNCTION calculate_outstanding_fees()
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(row_to_json(t))
    INTO result
    FROM (
        SELECT
            s.student_id,
            s.first_name,
            s.last_name,
            COALESCE(SUM(fp.amount) FILTER (WHERE fp.status = 'pending'), 0) AS outstanding_fees
        FROM students s
        LEFT JOIN fees_payments fp ON s.student_id = fp.student_id
        GROUP BY s.student_id, s.first_name, s.last_name
    ) t;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Execute the function to get outstanding fees
SELECT calculate_outstanding_fees();
