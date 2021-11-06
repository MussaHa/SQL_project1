
/*
	PROJECT NAME:Pay raise Proposal 
				Date of compiling:
				Description: detail records of employees and new salary proposal.
				By: Mossa
				Date of modification:
				Modified by:
				What is changed:
*/		  

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




