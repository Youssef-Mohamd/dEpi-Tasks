-- 1. Create DEPARTMENT table
CREATE TABLE DEPARTMENT (
    DNUM INT PRIMARY KEY,
    DName VARCHAR(30) NOT NULL UNIQUE,
    ManagerSSN CHAR(9) NOT NULL UNIQUE,
    ManagerStartDate DATE NOT NULL
);

-- 2. Create EMPLOYEE table
CREATE TABLE EMPLOYEE (
    SSN CHAR(9) PRIMARY KEY,
    Fname VARCHAR(30) NOT NULL,
    Lname VARCHAR(30) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M','F')),
    DNO INT NOT NULL,
    SupervisorSSN CHAR(9),
    FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNUM),
    FOREIGN KEY (SupervisorSSN) REFERENCES EMPLOYEE(SSN)
);

-- 3. Add foreign key constraint for ManagerSSN in DEPARTMENT (after EMPLOYEE created)
ALTER TABLE DEPARTMENT
ADD CONSTRAINT fk_manager FOREIGN KEY (ManagerSSN) REFERENCES EMPLOYEE(SSN);

-- 4. Create DEPT_LOCATIONS table (for multiple locations per department)
CREATE TABLE DEPT_LOCATIONS (
    DNUM INT NOT NULL,
    Location VARCHAR(40) NOT NULL,
    PRIMARY KEY (DNUM, Location),
    FOREIGN KEY (DNUM) REFERENCES DEPARTMENT(DNUM)
);

-- 5. Create PROJECT table
CREATE TABLE PROJECT (
    PNumber INT PRIMARY KEY,
    PName VARCHAR(30) NOT NULL,
    Location VARCHAR(40),
    DNUM INT NOT NULL,
    FOREIGN KEY (DNUM) REFERENCES DEPARTMENT(DNUM)
);

-- 6. Create WORKS_ON table (many-to-many between EMPLOYEE and PROJECT)
CREATE TABLE WORKS_ON (
    SSN CHAR(9) NOT NULL,
    PNumber INT NOT NULL,
    Hours DECIMAL(4,1) NOT NULL,
    PRIMARY KEY (SSN, PNumber),
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (PNumber) REFERENCES PROJECT(PNumber)
);

-- 7. Create DEPENDENT table
CREATE TABLE DEPENDENT (
    SSN CHAR(9) NOT NULL,
    DependentName VARCHAR(30) NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M','F')),
    BirthDate DATE NOT NULL,
    PRIMARY KEY (SSN, DependentName),
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN) ON DELETE CASCADE
);



-- Insert Departments
INSERT INTO DEPARTMENT (DNUM, DName, ManagerSSN, ManagerStartDate) VALUES
(1, 'CS', '123456789', '2020-01-01'),
(2, 'AI', '987654321', '2021-02-01'),
(3, 'SC', '555555555', '2022-03-01'),
(4, 'HR', '111222333', '2023-04-01'),
(5, 'IT', '444555666', '2024-05-01');

-- Insert Employees
INSERT INTO EMPLOYEE (SSN, Fname, Lname, BirthDate, Gender, DNO, SupervisorSSN) VALUES
('123456789', 'Yousef', 'Ahmed', '1980-05-10', 'M', 1, NULL),        
('987654321', 'Mohamed', 'Ali', '1985-08-15', 'M', 2, '123456789'),    
('555555555', 'Omar', 'Saeed', '1990-12-20', 'M', 3, '123456789'),     
('111222333', 'Ahmed', 'Khaled', '1992-09-25', 'M', 4, '987654321'), 
('444555666', 'Ali', 'Mahmoud', '1995-07-30', 'M', 5, '555555555');    

-- Insert Department Locations
INSERT INTO DEPT_LOCATIONS (DNUM, Location) VALUES
(1, 'New York'),
(2, 'Cairo'),
(3, 'Alex'),
(4, 'France');


-- Insert Projects
INSERT INTO PROJECT (PNumber, PName, Location, DNUM) VALUES
(10, 'Project CS1', 'New York', 1),
(20, 'Project AI1', 'Cairo', 2),
(30, 'Project SC1', 'Alex', 3),
(40, 'Project HR1', 'France', 4);


-- Insert Dependents
INSERT INTO DEPENDENT (SSN, DependentName, Gender, BirthDate) VALUES
('123456789', 'Sara', 'F', '2010-03-05'),
('987654321', 'Alia', 'F', '2012-06-10'),
('555555555', 'Mahmoud', 'M', '2015-09-15');

-- Insert Employee-Project assignments
INSERT INTO WORKS_ON (SSN, PNumber, Hours) VALUES
('123456789', 10, 20.0),
('987654321', 20, 25.0),
('555555555', 30, 30.0),
('111222333', 40, 15.0),
('444555666', 50, 10.0);

-------------

ALTER TABLE Employee
ADD Email NVARCHAR(100) NULL;
-------
UPDATE EMPLOYEE
SET DNO = 2
WHERE SSN = '444555666';

------
SELECT SSN, Fname, Lname
FROM EMPLOYEE
WHERE DNO = 1;
------

