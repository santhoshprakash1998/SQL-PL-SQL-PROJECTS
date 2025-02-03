REM   Script: Sql and pl/sql general
REM   Creating a table and inserting dating and updating the data procedure exection and triggers to raise a error if anyone wants to delete the data from the table 

--1. Create Tables

Create table Departments ( 
DeptID Number PRIMARY KEY, 
    DeptName Varchar2(50) not null     
); --DepartmentsTable


CREATE Table Employees( 
    EmpId Number Primary Key, 
    EmpName Varchar2(100) NOT NULL, 
    Age Number CHECK (Age >= 18), 
    Salary Number(10,2) Not null, 
    DeptId Number(12) Not null, 
    JoinDate DATE not null, 
    CONSTRAINT FK_department FOREIGN KEY (DeptId) REFERENCES  Departments(DeptID) 
     
); --EmployeesTable

--2.Insert Sample Data


INSERT INTO  Departments (DeptID,DeptName) VALUES (100,HR);

INSERT INTO  Departments (DeptID,DeptName) VALUES (101,'IT');

INSERT INTO  Departments (DeptID,DeptName) VALUES (102,'Finance');

INSERT INTO Employees (EmpId,EmpName,Age,Salary,DeptId,JoinDate)  
VALUES (1010,'SAN',25,49000,100,SYSDATE);

INSERT INTO Employees (EmpId,EmpName,Age,Salary,DeptId,JoinDate)  
VALUES (1009,'Shiva',29,58000,100,To_date('2020-01-12','YYYY-MM-DD'));


INSERT INTO Employees (EmpId,EmpName,Age,Salary,DeptId,JoinDate)      
  VALUES  (1008,'Vishnu',28,52000,100,To_date('2020-02-12','YYYY-MM-DD'));

--3. Queries to Retrieve Data


SELECT * FROM Employees;


SELECT * FROM Departments;

--4.Upadting the data

UPDATE Employees SET DeptId = 101 where EmpId = 1009; --Changes made for dept_id 100 to 101 

UPDATE Employees SET DeptId = 102 where EmpId = 1008; --Changes made for dept_id 100 to 102


--5. Queries to Retrieve Data

-- a. Get all Employees

SELECT * FROM Employees;

-- b. Get Employees in IT Department

SELECT EmpName, Salary 
FROM Employees E
JOIN Departments D ON E.DeptID = D.DeptID
WHERE D.DeptName = 'IT';

-- c. Count Employees per Department

SELECT D.DeptName, COUNT(E.EmpID) AS EmployeeCount
FROM Departments D LEFT JOIN Employees E ON D.DeptID = E.DeptID
GROUP BY D.DeptName;

-- 6. PL/SQL: Stored Procedure to Get Employee Details by Department

CREATE PROCEDURE GetEmployeesByDept(deptName VARCHAR(50))
BEGIN
    SELECT E.EmpName, E.Salary, E.JoinDate 
    FROM Employees E
    JOIN Departments D ON E.DeptID = D.DeptID
    WHERE D.DeptName = deptName;
END;
/


EXEC GetEmployeesByDept('HR');

-- 7. PL/SQL: Trigger to Prevent Deleting IT Department Employees


CREATE TRIGGER PreventITDeptDelete
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
    IF (SELECT DeptName FROM Departments WHERE DeptID = OLD.DeptID) = 'IT' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete employees from IT Department');
    END IF;
END;
/



