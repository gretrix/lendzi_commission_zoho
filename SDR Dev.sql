/* 
   SDR Commission - Partial Commission Report Table
   (using SDR Commission Percentage from Employee Module)
*/
SELECT
		 F."Id" AS "Funding ID",
		 D."Deal Name" AS "Deal Name",
		 D."Id" AS "Deal Id",
		 F."Commission Received Date" AS Earned_Date,
		 D."Sales Development Rep" AS Sales_Person_ID,
		 EMP."Employee Name" AS Employee_Name,
		 'SDR' AS Reason,
		 
			/* Use SDR Commission Percentage with NULL check */
			CASE
				 WHEN EMP."Employee Name"  IS NOT NULL THEN COALESCE(EMP."SDR Commission Percentage", 5)
				 ELSE 5
			 END AS SDR_Commission_Percentage,
		 (COALESCE(F."Lender Commission", 0) + COALESCE(F."Application Fee", 0) + COALESCE(F."Professional Service Fee", 0) + COALESCE(F."Lendzi Origination Fee", 0)) AS Total,
		 /* Use commission percentage in calculation with NULL check */ (COALESCE(F."Lender Commission", 0) + COALESCE(F."Application Fee", 0) + COALESCE(F."Professional Service Fee", 0) + COALESCE(F."Lendzi Origination Fee", 0)) * (
			CASE
				 WHEN EMP."Employee Name"  IS NOT NULL THEN COALESCE(EMP."SDR Commission Percentage", 5)
				 ELSE 5
			 END) / 100 AS Commission,
		 /* Commission Multiplier with NULL check */ (
			CASE
				 WHEN EMP."Employee Name"  IS NOT NULL THEN COALESCE(EMP."SDR Commission Percentage", 5)
				 ELSE 5
			 END) / 100 AS Commission_Multiplier
FROM  "Deals" D
LEFT JOIN "Fundings" F ON F."Deal"  = D."Id" 
LEFT JOIN "Employees" EMP ON D."Sales Development Rep"  = EMP."Employee"  
WHERE	 D."Sales Development Rep"  IS NOT NULL
 AND	F."Commission Received Date"  IS NOT NULL
UNION ALL
 /*--------------------------------------------
  Negative clawback rows
---------------------------------------------*/
SELECT
		 F."Id" AS "Funding ID",
		 D."Deal Name" AS "Deal Name",
		 D."Id" AS "Deal Id",
		 F."Clawback Date" AS Earned_Date,
		 D."Sales Development Rep" AS Sales_Person_ID,
		 EMP."Employee Name" AS Employee_Name,
		 'SDR Clawback' AS Reason,
		 
			/* Use SDR Commission Percentage with NULL check */
			CASE
				 WHEN EMP."Employee Name"  IS NOT NULL THEN COALESCE(EMP."SDR Commission Percentage", 5)
				 ELSE 5
			 END AS SDR_Commission_Percentage,
		 (-1 * COALESCE(F."Clawback Amount", 0)) AS Total,
		 /* Use commission percentage in calculation with NULL check */ (-1 * COALESCE(F."Clawback Amount", 0)) * (
			CASE
				 WHEN EMP."Employee Name"  IS NOT NULL THEN COALESCE(EMP."SDR Commission Percentage", 5)
				 ELSE 5
			 END) / 100 AS Commission,
		 /* Commission Multiplier with NULL check */ (
			CASE
				 WHEN EMP."Employee Name"  IS NOT NULL THEN COALESCE(EMP."SDR Commission Percentage", 5)
				 ELSE 5
			 END) / 100 AS Commission_Multiplier
FROM  "Deals" D
LEFT JOIN "Fundings" F ON F."Deal"  = D."Id" 
LEFT JOIN "Employees" EMP ON D."Sales Development Rep"  = EMP."Employee"  
WHERE	 F."Clawback Date"  IS NOT NULL
 AND	D."Sales Development Rep"  IS NOT NULL
 
