use  company

CREATE TABLE Department(
DeptID INT PRIMARY KEY,
DeptName NVARCHAR(50)  NOT NULL UNIQUE,
ManagerID INT UNIQUE
);


DROP TABLE IF EXISTS Employee;  -- DROP the existing table 
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    BirthDate DATE NOT NULL,
    DeptID INT NOT NULL,
    CONSTRAINT FK_Employee_Department FOREIGN KEY (DeptID)
    REFERENCES Department(DeptID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);


CREATE TABLE Project (
    ProjectID INT PRIMARY KEY ,
    ProjectName NVARCHAR(100) NOT NULL UNIQUE,
    DeptID INT NOT NULL,
    CONSTRAINT FK_Project_Department FOREIGN KEY (DeptID)
        REFERENCES Department(DeptID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);


CREATE TABLE DEPENENT (
DependentID INT PRIMARY KEY ,
DependentName NVARCHAR(50) NOT NULL,
BirthDate DATE NOT NULL,
EmpID INT NOT NULL,
CONSTRAINT FK_Dependent FOREIGN KEY (EmpID)
REFERENCES Employee(EmpID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


     --ALTER 

ALTER TABLE Employee
ADD Email NVARCHAR(100) NULL;


ALTER TABLE Department
ADD CONSTRAINT FK_Department_Manager FOREIGN KEY (ManagerID)
    REFERENCES Employee(EmpID);
  

  ALTER TABLE Department
    DROP CONSTRAINT FK_Department_Manager;



      --Isertion

INSERT INTO Department ( DeptID , DeptName, ManagerID) 
VALUES( 1 , 'CS' , 1234 ) , 
      ( 2 , 'AI' , 5678 ),
	  ( 3 , 'SC', 2468 );


	  INSERT INTO Employee (  EmpID ,  FirstName , LastName, BirthDate , Gender ) 
VALUES('1234589', 'Zeyad', 'Mohamed', '2000-05-10', 'M'),
      ('9876321', 'jooo', 'Ibrahim', '1995-08-15', 'M'),
      ('5548555', 'Mostafa', 'Adm', '1980-12-20', 'M');

	  --INSERT INTO Employee (FirstName, LastName, Gender, DeptID)
--VALUES ('Youssef', 'Mohamed', 'M', 1),
      -- ('Zeyad', 'Ahmed', 'M', 2),
      -- ('nada', 'Omar', 'F', 3);


	  INSERT INTO Project (ProjectName, ProjectID , DeptID)VALUES
	   ('Software ',10, 3), 
       (' Network',20, 1),
       ('Ai ',30, 2);


	   INSERT INTO DEPENENT (DependentID,EmpID, DependentName, BirthDate)
VALUES (2 , 1 , 'Amar', '2010-05-01'),
       (4 , 2 , 'Adm' , '2012-08-15');
