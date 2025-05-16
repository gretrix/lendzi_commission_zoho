WITH EmployeeRevenue AS (/* Get all the deal-level revenue by employee with extra fields for debugging*/
SELECT
		 F."Id" AS "Funding_ID",
		 F."Commission Received Date" AS "Commission_Date",
		 D."Deal Name" AS "Deal_Name",
		 D."Account Executive" AS "Employee_ID",
		 E."Employee Name" AS "Employee_Name",
		 E."Manager" AS "Manager_ID",
		 M."Full Name" AS "Manager_Name",
		 COALESCE(F."Lender Commission", 0) AS "Lender_Commission",
		 COALESCE(F."Application Fee", 0) AS "Application_Fee",
		 COALESCE(F."Professional Service Fee", 0) AS "Professional_Fee",
		 COALESCE(F."Lendzi Origination Fee", 0) AS "Origination_Fee",
		 (COALESCE(F."Lender Commission", 0) + COALESCE(F."Application Fee", 0) + COALESCE(F."Professional Service Fee", 0) + COALESCE(F."Lendzi Origination Fee", 0)) AS "Total_Revenue"
FROM  "Deals" D
JOIN "Fundings" F ON F."Deal"  = D."Id" 
JOIN "Employees" E ON D."Account Executive"  = E."Employee" 
JOIN "Users" M ON E."Manager"  = M."Id"  
WHERE	 F."Commission Received Date"  IS NOT NULL
 AND	F."Status"  = 'Funded'
 AND	F."Clawback Date"  IS NULL
 AND	(F."Funds Returned"  IS NULL
 OR	F."Funds Returned"  = 0))
SELECT
		 ER."Funding_ID" AS "Funding ID",
		 ER."Commission_Date" AS "Commission Date",
		 ER."Deal_Name" AS "Deal Name",
		 ER."Employee_Name" AS "Employee Name",
		 ER."Manager_ID" AS "Manager ID",
		 ER."Manager_Name" AS "Manager Name",
		 ER."Lender_Commission" AS "Lender Commission",
		 ER."Application_Fee" AS "Application Fee",
		 ER."Professional_Fee" AS "Professional Fee",
		 ER."Origination_Fee" AS "Origination Fee",
		 ER."Total_Revenue" AS "Total Revenue",
		 
			/* Use different override rate for specific manager*/
			CASE
				 WHEN ER."Manager_ID"  = '4470003000014600001' THEN ER."Total_Revenue" * 0.01 /* 1% for Dean Jones*/
				 ELSE ER."Total_Revenue" * 0.015 /* 1.5% for everyone else*/
			 END AS "Override Commission"
FROM  EmployeeRevenue ER 
ORDER BY ER."Manager_Name",
	 ER."Commission_Date",
	 ER."Employee_Name" 
 