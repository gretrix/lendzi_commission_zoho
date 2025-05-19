WITH RenewalManagerRevenue AS (/* Get all the renewal deal-level revenue for Scarlett Hite and Tony Piccone */
SELECT
		 F."Id" AS "Funding_ID",
		 F."Commission Received Date" AS "Commission_Date",
		 R."Renewal Name" AS "Deal_Name",
		 F."Renewal Manager" AS "Employee_ID",
		 E."Employee Name" AS "Employee_Name",
		 '4470003000014600001' AS "Manager_ID",
		 /* Dean Jones ID*/ 'Dean Jones' AS "Manager_Name",
		 COALESCE(F."Lender Commission", 0) AS "Lender_Commission",
		 COALESCE(F."Application Fee", 0) AS "Application_Fee",
		 COALESCE(F."Professional Service Fee", 0) AS "Professional_Fee",
		 COALESCE(F."Lendzi Origination Fee", 0) AS "Origination_Fee",
		 (COALESCE(F."Lender Commission", 0) + COALESCE(F."Application Fee", 0) + COALESCE(F."Professional Service Fee", 0) + COALESCE(F."Lendzi Origination Fee", 0)) AS "Total_Revenue",
		 'Renewal Manager Override' AS "Reason_Type"
FROM  "Renewals" R
JOIN "Fundings" F ON F."Renewal"  = R."Id" 
JOIN "Employees" E ON F."Renewal Manager"  = E."Employee"  
WHERE	 F."Commission Received Date"  IS NOT NULL
 AND	F."Status"  = 'Funded'
 AND	F."Clawback Date"  IS NULL
 AND	(F."Funds Returned"  IS NULL
 OR	F."Funds Returned"  = 0)
 AND	(E."Employee Name"  = 'Scarlett Hite'
 OR	E."Employee Name"  = 'Tony Piccone'))
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
		 ER."Total_Revenue" * 0.01 AS "Override Commission",
		 /* Fixed 1% rate for Dean Jones*/ ER."Reason_Type" AS "Reason Type"
FROM  RenewalManagerRevenue ER 
ORDER BY ER."Commission_Date",
	 ER."Employee_Name" 
 