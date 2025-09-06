CREATE SCHEMA IF NOT EXISTS azure_company;
USE azure_company;

SELECT * 
FROM information_schema.table_constraints
WHERE constraint_schema = 'azure_company';

-- Restrição atribuída a um domínio (não suportado diretamente pelo MySQL)
-- CREATE DOMAIN D_num AS INT CHECK (D_num > 0 AND D_num < 21);

CREATE TABLE employee (
    Fname      VARCHAR(15) NOT NULL,
    Minit      CHAR,
    Lname      VARCHAR(15) NOT NULL,
    Ssn        CHAR(9)     NOT NULL, 
    Bdate      DATE,
    Address    VARCHAR(30),
    Sex        CHAR,
    Salary     DECIMAL(10,2),
    Super_ssn  CHAR(9),
    Dno        INT NOT NULL,
    CONSTRAINT chk_salary_employee CHECK (Salary > 2000.0),
    CONSTRAINT pk_employee PRIMARY KEY (Ssn)
);

ALTER TABLE employee 
    ADD CONSTRAINT fk_employee 
    FOREIGN KEY (Super_ssn) REFERENCES employee (Ssn)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE employee 
    MODIFY Dno INT NOT NULL DEFAULT 1;

DESC employee;

CREATE TABLE departament (
    Dname            VARCHAR(15) NOT NULL,
    Dnumber          INT NOT NULL,
    Mgr_ssn          CHAR(9) NOT NULL,
    Mgr_start_date   DATE, 
    Dept_create_date DATE,
    CONSTRAINT chk_date_dept CHECK (Dept_create_date < Mgr_start_date),
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE (Dname),
    FOREIGN KEY (Mgr_ssn) REFERENCES employee (Ssn)
);

-- Modificar uma constraint: drop e add
ALTER TABLE departament DROP FOREIGN KEY departament_ibfk_1;

ALTER TABLE departament 
    ADD CONSTRAINT fk_dept 
    FOREIGN KEY (Mgr_ssn) REFERENCES employee (Ssn)
    ON UPDATE CASCADE;

DESC departament;

CREATE TABLE dept_locations (
    Dnumber   INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES departament (Dnumber)
);

ALTER TABLE dept_locations DROP FOREIGN KEY fk_dept_locations;

ALTER TABLE dept_locations 
    ADD CONSTRAINT fk_dept_locations 
    FOREIGN KEY (Dnumber) REFERENCES departament (Dnumber)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

CREATE TABLE project (
    Pname    VARCHAR(15) NOT NULL,
    Pnumber  INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum     INT NOT NULL,
    PRIMARY KEY (Pnumber),
    CONSTRAINT unique_project UNIQUE (Pname),
    CONSTRAINT fk_project FOREIGN KEY (Dnum) REFERENCES departament (Dnumber)
);

CREATE TABLE works_on (
    Essn  CHAR(9) NOT NULL,
    Pno   INT NOT NULL,
    Hours DECIMAL(3,1) NOT NULL,
    PRIMARY KEY (Essn, Pno),
    CONSTRAINT fk_employee_works_on FOREIGN KEY (Essn) REFERENCES employee (Ssn),
    CONSTRAINT fk_project_works_on FOREIGN KEY (Pno) REFERENCES project (Pnumber)
);

DROP TABLE IF EXISTS dependent;

CREATE TABLE dependent (
    Essn            CHAR(9) NOT NULL,
    Dependent_name  VARCHAR(15) NOT NULL,
    Sex             CHAR,
    Bdate           DATE,
    Relationship    VARCHAR(8),
    PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT fk_dependent FOREIGN KEY (Essn) REFERENCES employee (Ssn)
);

SHOW TABLES;
DESC dependent;

-- =========================
-- Inserção de Employees
-- =========================
INSERT INTO employee VALUES
-- 1º: presidente sem supervisor
('James', 'E', 'Borg', 888665555, '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1),

-- 2º: gerentes que respondem ao presidente
('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, 888665555, 5),
('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, 888665555, 4),

-- 3º: funcionários que respondem a Franklin
('John', 'B', 'Smith', 123456789, '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, 333445555, 5),
('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, 333445555, 5),
('Joyce', 'A', 'English', 453453453, '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, 333445555, 5),

-- 4º: funcionários que respondem a Jennifer
('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, 987654321, 4),
('Ahmad', 'V', 'Jabbar', 987987987, '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, 987654321, 4);

-- =========================
-- Inserção de Dependents
-- =========================
INSERT INTO dependent VALUES
(333445555, 'Alice', 'F', '1986-04-05', 'Daughter'),
(333445555, 'Theodore', 'M', '1983-10-25', 'Son'),
(333445555, 'Joy', 'F', '1958-05-03', 'Spouse'),
(987654321, 'Abner', 'M', '1942-02-28', 'Spouse'),
(123456789, 'Michael', 'M', '1988-01-04', 'Son'),
(123456789, 'Alice', 'F', '1988-12-30', 'Daughter'),
(123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse');

-- =========================
-- Inserção de Departamentos
-- =========================
INSERT INTO departament VALUES
('Research', 5, 333445555, '1988-05-22','1986-05-22'),
('Administration', 4, 987654321, '1995-01-01','1994-01-01'),
('Headquarters', 1, 888665555,'1981-06-19','1980-06-19');

-- =========================
-- Inserção de Dept_Locations
-- =========================
INSERT INTO dept_locations VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

-- =========================
-- Inserção de Projects
-- =========================
INSERT INTO project VALUES
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

-- =========================
-- Inserção de Works_On
-- =========================
INSERT INTO works_on VALUES
(123456789, 1, 32.5),
(123456789, 2, 7.5),
(666884444, 3, 40.0),
(453453453, 1, 20.0),
(453453453, 2, 20.0),
(333445555, 2, 10.0),
(333445555, 3, 10.0),
(333445555, 10, 10.0),
(333445555, 20, 10.0),
(999887777, 30, 30.0),
(999887777, 10, 10.0),
(987987987, 10, 35.0),
(987987987, 30, 5.0),
(987654321, 30, 20.0),
(987654321, 20, 15.0),
(888665555, 20, 0.0);

-- =========================
-- Consultas SQL
-- =========================
-- Todos os employees
SELECT * FROM employee;

-- Contagem de dependentes por employee
SELECT e.Ssn, COUNT(d.Essn) AS total_dependentes
FROM employee e
JOIN dependent d ON e.Ssn = d.Essn
GROUP BY e.Ssn;

-- Todos os dependentes
SELECT * FROM dependent;

-- Informações de John B Smith
SELECT Bdate, Address 
FROM employee
WHERE Fname = 'John' AND Minit = 'B' AND Lname = 'Smith';

-- Departamentos específicos
SELECT * FROM departament WHERE Dname = 'Research';

-- Employees de Research
SELECT Fname, Lname, Address
FROM employee e, departament d
WHERE d.Dname = 'Research' AND d.Dnumber = e.Dno;

-- Todos os projetos
SELECT * FROM project;

-- Departamentos em Stafford
SELECT d.Dname AS Department, d.Mgr_ssn AS Manager
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
WHERE l.Dlocation = 'Stafford';

-- Concatenando nome do gerente
SELECT d.Dname AS Department, CONCAT(e.Fname, ' ', e.Lname) AS Manager
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn;

-- Projetos em Stafford
SELECT * 
FROM project p
JOIN departament d ON p.Dnum = d.Dnumber
WHERE p.Plocation = 'Stafford';

-- Departamentos e projetos em Stafford
SELECT p.Pnumber, p.Dnum, e.Lname, e.Address, e.Bdate
FROM project p
JOIN departament d ON p.Dnum = d.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn
WHERE p.Plocation = 'Stafford';

-- Employees em departamentos 3,6,9
SELECT * FROM employee WHERE Dno IN (3,6,9);

-- Operadores lógicos
SELECT Bdate, Address
FROM employee
WHERE Fname = 'John' AND Minit = 'B' AND Lname = 'Smith';

SELECT e.Fname, e.Lname, e.Address
FROM employee e, departament d
WHERE d.Dname = 'Research' AND d.Dnumber = e.Dno;

-- Expressões e alias
SELECT Fname, Lname, Salary, Salary*0.011 AS INSS FROM employee;
SELECT Fname, Lname, Salary, ROUND(Salary*0.011,2) AS INSS FROM employee;

-- Aumento para gerentes do projeto ProductX
SELECT e.Fname, e.Lname, 1.1*e.Salary AS increased_sal
FROM employee e
JOIN works_on w ON e.Ssn = w.Essn
JOIN project p ON w.Pno = p.Pnumber
WHERE p.Pname = 'ProductX';

-- Concatenando nomes com alias
SELECT d.Dname AS Department, CONCAT(e.Fname, ' ', e.Lname) AS Manager
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn;

-- Employees do departamento Research
SELECT e.Fname, e.Lname, e.Address
FROM employee e
JOIN departament d ON d.Dnumber = e.Dno
WHERE d.Dname = 'Research';
