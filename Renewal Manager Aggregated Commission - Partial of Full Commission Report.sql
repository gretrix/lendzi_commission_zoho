SELECT
		 R."Id" AS "Renewal ID",
		 F."Id" AS "Funding ID",
		 F."Funding",
		 R."Renewal Name",
		 F."Commission Received Date" AS Earned_Date,
		 F."Renewal Manager" AS Sales_Person_ID,
		 EMP."Employee Name" AS Employee_Name,
		 'Renewal Manager' AS Reason,
		 F."Lender Commission",
		 F."Professional Service Fee",
		 F."Lendzi Origination Fee",
		 F."Application Fee",
		 EMP."Commission Percentage Tier 1" AS Commission_Percentage_Tier_1,
		 EMP."Commission Percentage Tier 2" AS Commission_Percentage_Tier_2,
		 EMP."Commission Percentage Tier 3" AS Commission_Percentage_Tier_3,
		 EMP."Manager Commission" AS Manager_Commission,
		 AGG.Total_Gross_Revenue,
		 IFNULL(F."Lender Commission", 0) + IFNULL(F."Professional Service Fee", 0) + IFNULL(F."Lendzi Origination Fee", 0) + IFNULL(F."Application Fee", 0) AS Total,
		 
			CASE
				 WHEN AGG.Total_Gross_Revenue  > 130000 THEN (IFNULL(F."Lender Commission", 0) + IFNULL(F."Professional Service Fee", 0) + IFNULL(F."Lendzi Origination Fee", 0) + IFNULL(F."Application Fee", 0)) * (COALESCE(EMP."Manager Commission", 5) / 100)
				 WHEN AGG.Total_Gross_Revenue  BETWEEN 65000  AND  130000 THEN (IFNULL(F."Lender Commission", 0) + IFNULL(F."Professional Service Fee", 0) + IFNULL(F."Lendzi Origination Fee", 0) + IFNULL(F."Application Fee", 0)) * (COALESCE(EMP."Manager Commission", 5) / 100)
				 ELSE (IFNULL(F."Lender Commission", 0) + IFNULL(F."Professional Service Fee", 0) + IFNULL(F."Lendzi Origination Fee", 0)) * (COALESCE(EMP."Manager Commission", 5) / 100)
			 END AS Commission,
		 
			CASE
				 WHEN AGG.Total_Gross_Revenue  > 130000 THEN (COALESCE(EMP."Manager Commission", 5) / 100)
				 WHEN AGG.Total_Gross_Revenue  BETWEEN 65000  AND  130000 THEN (COALESCE(EMP."Manager Commission", 5) / 100)
				 ELSE (COALESCE(EMP."Manager Commission", 5) / 100)
			 END AS Commission_Multiplier,
		 R."Id" AS Deal_ID,
		 R."Renewal Name" AS Deal_Name
FROM  "Renewals" R
JOIN "Fundings" F ON R."Id"  = F."Renewal" 
LEFT JOIN "Employees" EMP ON F."Renewal Manager"  = EMP."Employee" 
JOIN(	SELECT
			 R2."Renewal Manager" AS Sales_Person_ID,
			 SUM((F2."Lender Commission" + F2."Professional Service Fee" + F2."Lendzi Origination Fee" + F2."Application Fee")) AS Total_Gross_Revenue,
			 DATE_FORMAT(F2."Commission Received Date", '%Y-%m') AS Funded_Month
	FROM  "Renewals" R2
JOIN "Fundings" F2 ON R2."Id"  = F2."Renewal"  
	GROUP BY R2."Renewal Manager",
		  Funded_Month 
) AGG ON R."Renewal Manager"  = AGG.Sales_Person_ID
	 AND	DATE_FORMAT(F."Commission Received Date", '%Y-%m')  = AGG.Funded_Month  
UNION ALL
 /* Add clawback handling for Renewal Manager */
SELECT
		 R."Id" AS "Renewal ID",
		 F."Id" AS "Funding ID",
		 F."Funding",
		 R."Renewal Name",
		 F."Clawback Date" AS Earned_Date,
		 /* Use Clawback Date for clawbacks*/ F."Renewal Manager" AS Sales_Person_ID,
		 EMP."Employee Name" AS Employee_Name,
		 'Renewal Manager Clawback' AS Reason,
		 /* New reason for clawbacks*/ 0 AS "Lender Commission",
		 0 AS "Professional Service Fee",
		 0 AS "Lendzi Origination Fee",
		 0 AS "Application Fee",
		 EMP."Commission Percentage Tier 1" AS Commission_Percentage_Tier_1,
		 EMP."Commission Percentage Tier 2" AS Commission_Percentage_Tier_2,
		 EMP."Commission Percentage Tier 3" AS Commission_Percentage_Tier_3,
		 EMP."Manager Commission" AS Manager_Commission,
		 AGG.Total_Gross_Revenue,
		 (-1 * COALESCE(F."Clawback Amount", 0)) AS Total,
		 
			/* Negative amount for clawback*/
			CASE
				 WHEN AGG.Total_Gross_Revenue  > 130000 THEN (-1 * COALESCE(F."Clawback Amount", 0)) * (COALESCE(EMP."Manager Commission", 5) / 100)
				 WHEN AGG.Total_Gross_Revenue  BETWEEN 65000  AND  130000 THEN (-1 * COALESCE(F."Clawback Amount", 0)) * (COALESCE(EMP."Manager Commission", 5) / 100)
				 ELSE (-1 * COALESCE(F."Clawback Amount", 0)) * (COALESCE(EMP."Manager Commission", 5) / 100)
			 END AS Commission,
		 
			CASE
				 WHEN AGG.Total_Gross_Revenue  > 130000 THEN (COALESCE(EMP."Manager Commission", 5) / 100)
				 WHEN AGG.Total_Gross_Revenue  BETWEEN 65000  AND  130000 THEN (COALESCE(EMP."Manager Commission", 5) / 100)
				 ELSE (COALESCE(EMP."Manager Commission", 5) / 100)
			 END AS Commission_Multiplier,
		 R."Id" AS Deal_ID,
		 R."Renewal Name" AS Deal_Name
FROM  "Renewals" R
JOIN "Fundings" F ON R."Id"  = F."Renewal" 
LEFT JOIN "Employees" EMP ON F."Renewal Manager"  = EMP."Employee" 
JOIN(	SELECT
			 R2."Renewal Manager" AS Sales_Person_ID,
			 SUM((F2."Lender Commission" + F2."Professional Service Fee" + F2."Lendzi Origination Fee" + F2."Application Fee")) AS Total_Gross_Revenue,
			 DATE_FORMAT(F2."Clawback Date", '%Y-%m') AS Clawback_Month
	FROM  "Renewals" R2
JOIN "Fundings" F2 ON R2."Id"  = F2."Renewal"  
	WHERE	 F2."Clawback Date"  IS NOT NULL
	GROUP BY R2."Renewal Manager",
		  Clawback_Month 
) AGG ON R."Renewal Manager"  = AGG.Sales_Person_ID
	 AND	DATE_FORMAT(F."Clawback Date", '%Y-%m')  = AGG.Clawback_Month  
WHERE	 F."Clawback Date"  IS NOT NULL /* Only for fundings with clawbacks*/
 
ORDER BY R."Renewal Name" 
