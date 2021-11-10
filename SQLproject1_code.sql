
/*
	PROJECT NAME:Pay raise Proposal 
				Date of compiling:
				Description: detail records of employees and new salary proposal.
				By: Mossa
				Date of modification:
				Modified by:
				What is changed:
*/	
--First create the database

CREATE DATABASE HRMDB;
GO

USE HRMDB;
GO

-- CREATING TABLES, WITH CONSTRAINTS

CREATE TABLE Patient
(
	mrn CHAR(5) NOT NULL,
	pFName VARCHAR(30) NOT NULL,
	pLName VARCHAR(30) NOT NULL,
	PDoB DATE NOT NULL,
	insuranceId CHAR(7) NULL, 
	gender CHAR(1) NOT NULL,
	SSN CHAR(11) NULL,
	stAddress VARCHAR(25) NOT NULL,
	city VARCHAR(25) NOT NULL,
	[state] CHAR(2) NOT NULL,
	zipCode CHAR(5) NOT NULL,
	registeredDate DATE NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_Patient_mrn PRIMARY KEY (mrn),
	CONSTRAINT CK_Patient_mrn_Format CHECK(mrn LIKE '[A-Z][A-Z][0-9][0-9][0-9]'),
	CONSTRAINT UQ_Patient_insuranceId UNIQUE (insuranceId),
	CONSTRAINT CK_Patient_gender_Format CHECK(gender IN ('F', 'M', 'U')),
	CONSTRAINT CK_Patient_SSN_Format CHECK ((SSN LIKE '[0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9][0-9][0-9]') AND (SSN NOT LIKE '000-00-0000')),
	CONSTRAINT UQ_Patient_SSN UNIQUE (SSN),
	CONSTRAINT CK_Patient_state_Format CHECK([state] LIKE '[A-Z][A-Z]'),
	CONSTRAINT CK_Pateint_zipCode_Fomrat CHECK((zipCode LIKE '[0-9][0-9][0-9][0-9][0-9]') AND (zipCode NOT LIKE '00000'))
);
GO


CREATE TABLE Employee
(
	empId CHAR(5) NOT NULL,
	empFName VARCHAR(25) NOT NULL,
	empLName VARCHAR(25) NOT NULL,
	SSN CHAR(11) NOT NULL,
	DoB DATE NOT NULL,
	gender CHAR(1) NOT NULL,
	salary DECIMAL(8,2) NULL,
	employedDate DATE NOT NULL,
	strAddress VARCHAR (30) NOT NULL,
	apt VARCHAR(5) NULL,
	city VARCHAR(25) NOT NULL,
	[state] CHAR(2) NOT NULL,
	zipCode CHAR(5) NOT NULL,
	phoneNo CHAR(14) NOT NULL,
	email VARCHAR(50) NULL,
	empType VARCHAR(20) NOT NULL,
	CONSTRAINT PK_Employee_empId PRIMARY KEY (empId)
);
GO

CREATE TABLE Disease
(
	dId INT NOT NULL,	
	dName VARCHAR(100) NOT NULL,
	dCategoryId CHAR(2) NULL,
	dCategory VARCHAR(50) NOT NULL,
	dType VARCHAR(40) NOT NULL,
	CONSTRAINT PK_Disease_dId PRIMARY KEY (dId),
	CONSTRAINT CHK_Disease_dCategoryId CHECK (dCategoryId LIKE '[A-Z][0-9]')
);
GO


CREATE TABLE Doctor
(
	empId CHAR(5) NOT NULL, 
	docId CHAR(4) NOT NULL,
	lisenceNo CHAR(11) UNIQUE NOT NULL,
	lisenceDate DATE NOT NULL,
	[rank] VARCHAR(25) NOT NULL,
	specialization VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Doctor_docId PRIMARY KEY (docId),
	CONSTRAINT FK_Doctor_Employee_empId FOREIGN KEY (empId) REFERENCES Employee (empId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


CREATE TABLE Diagnosis
(
	diagnosisNo INT NOT NULL,
	mrn CHAR(5) NOT NULL,
	docId CHAR(4) NULL,
	dId INT NOT NULL,
	diagDate DATE DEFAULT GETDATE() NOT NULL,
	diagResult VARCHAR(1000) NOT NULL,
	CONSTRAINT PK_Diagnosis_diagnosisNo PRIMARY KEY (diagnosisNo),
	CONSTRAINT FK_Diagnosis_Patient_mrn FOREIGN KEY (mrn) REFERENCES Patient(mrn),
	CONSTRAINT FK_Diagnosis_Doctor_docId FOREIGN KEY (docId) REFERENCES Doctor(docId) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT FK_Diagnosis_Disease_dId FOREIGN KEY (dId) REFERENCES Disease(dId)
);
GO



CREATE TABLE PharmacyPersonel
(
	empId CHAR(5) NOT NULL,
	pharmacistLisenceNo CHAR (11) NOT NULL,
	lisenceDate DATE NOT NULL,
	PCATTestResult INT NULL,
	[level] VARCHAR (40) NOT NULL,
	CONSTRAINT FK_PharmacyPersonel_empId FOREIGN KEY (empId) REFERENCES Employee (empId),
	CONSTRAINT UQ_PharmacyPersonel_pharmacistLisenceNo UNIQUE (pharmacistLisenceNo)
);
GO


CREATE TABLE Medicine
(
	mId SMALLINT NOT NULL,
	brandName VARCHAR(40) NOT NULL,
	genericName VARCHAR(50) NOT NULL,
	qtyInStock INT NOT NULL,
	[use] VARCHAR(50) NOT NULL,
	expDate DATE NOT NULL,
	unitPrice DECIMAL(6,2) NOT NULL,
	CONSTRAINT PK_Medicine_mId PRIMARY KEY (mId)
);
GO

CREATE TABLE Prescription
(
	prescriptionId INT NOT NULL,
	diagnosisNo INT NOT NULL,
	prescriptionDate DATE NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_Prescription_prescriptionId PRIMARY KEY (prescriptionId),
	CONSTRAINT FK_Prescription_Diagnosis_diagnosisNo FOREIGN KEY (diagnosisNo) REFERENCES Diagnosis(diagnosisNo) 
);
GO


CREATE TABLE MedicinePrescribed
(
	prescriptionId INT NOT NULL,
	mId SMALLINT NOT NULL,
	dosage VARCHAR(50) NOT NULL,
	numberOfAllowedRefills TINYINT NOT NULL,
	CONSTRAINT PK_MedicinePrescribed_prescriptionId_mId PRIMARY KEY(prescriptionId, mId),
	CONSTRAINT FK_MedicinePrescribed_prescriptionId FOREIGN KEY (prescriptionId) REFERENCES Prescription(prescriptionId),
	CONSTRAINT FK_MedicinePrescribed_mId FOREIGN KEY (mId) REFERENCES Medicine(mId)
);
GO

/*Alter Employee table and add a unique constriant to SSN*/

ALTER TABLE Employee
ADD CONSTRAINT UQ_Employee_SSN UNIQUE (SSN);

/*Alter Employee table and add a check constraint that accepts 'M' for male 'F' for female and 'U' for Unidentfied*/
ALTER TABLE Employee
ADD CONSTRAINT ck_Employee_gender_format CHECK (gender IN ('F','M','U')); 

--Here is the answer for the project  
SELECT E.empId AS [Employee ID], 
		CONCAT(empLName,', ',empFName) as [Full Name], DoB, 
		DATEPART(YEAR,DoB) AS [Year of birth],
		DATEPART(MONTH,DoB) AS [Month of birth],
		DATEPART(DAY,DoB) AS [date of birth],
		gender AS [Gender],DATEDIFF(YEAR,DoB,GETDATE()) AS [Age],
		SUBSTRING (phoneNo,2,3) AS [Area Code],
		CONCAT(strAddress,' ',apt,' ',city,' ',[state],' ',zipCode) AS [Full Adress],
		LEFT(strAddress, CHARINDEX(' ', strAddress)) AS [House Number], 
		email AS [Email], 
		RIGHT(email,LEN(email)-CHARINDEX('@',email)) AS [Email domain],
		RIGHT(SSN,4) AS [Last 4 digit of SSN],
			CASE 
				WHEN salary>90000 THEN 'High'
				WHEN salary BETWEEN 50000 AND 90000 THEN 'Middle'
				WHEN salary<50000 THEN 'Low'
				END AS [ Income Level],
			 CASE 
				WHEN [state] IN ('MD','VA','DC') THEN 'YES'
				ELSE 'NO'
			    END AS [DMV Area Employee],
		 IIF (E.empId IN  
			(SELECT E.empId FROM Employee E 
			RIGHT JOIN Doctor D ON E.empId=D.empId), 'YES', 'NO') AS [Doctor],
			--Doctor speciality
			CASE
				WHEN  Dr.specialization IS NOT NULL  THEN Dr.specialization 
					ELSE 'Not Applicable'
					END [Doctot Speciality],
					--
		IIF (E.empId IN 
				(SELECT E.empId FROM Employee E 
				RIGHT JOIN  PharmacyPersonel PP ON E.empId=PP.empId), 'YES', 'NO') AS [Pharmacy Personnel],
			--General Employee: If employee is not doctor and not pharmacy personell return Yes, other wise NO
		IIF (E.empId IN
				(SELECT E.empId
			 FROM  Employee E 
			 LEFT JOIN PharmacyPersonel PP  ON E.empId=PP.empId 
			 LEFT JOIN Doctor D ON E.empId=D.empId
			 WHERE PP.empId is null AND D.empId IS NULL), 'YES', 'NO') AS [General Employee],
		DATEPART(YEAR, employedDate) AS [Year recruited],
		DATEDIFF(YEAR,employedDate,GETDATE()) AS [Experiance year in the organization],
		empType AS [Emp Type], 
		salary AS [Old Salary],
		--tax applied to old salary is 35%
		CONVERT(DECIMAL (8,2),salary/(1+0.35)) AS [Net pay from old salary],
		--We have a plan to increase their salary by 6% 
		CONVERT(DECIMAL (8,2),salary*1.06) AS [Proposed new salary], 
		--Net pay from new salary (Assume the total tax applied to salary is 35%) 
		CONVERT(DECIMAL (8,2),salary*1.06/1.35) AS [Net pay from new salary]
FROM Employee E LEFT JOIN Doctor Dr ON Dr.empId=E.empId




