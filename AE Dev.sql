SELECT
		 CommissionData."Deal Name" AS "Deal Name",
		 CommissionData."Deal ID" AS "Deal ID",
		 /* 1 */ CommissionData.Earned_Date,
		 /* 2 */ CommissionData.Sales_Person_ID,
		 /* 3 */ CommissionData.Reason,
		 /* 4 */ CommissionData.Lender_Commission,
		 /* 5 */ CommissionData.Application_Fee,
		 /* 6 */ CommissionData.Professional_Service_Fee,
		 /* 7 */ CommissionData.Lendzi_Origination_Fee,
		 /* 8 */ CommissionData.Total,
		 /* 9 */ CommissionData.Division_Factor_Debug,
		 /* 10: Sum of all Totals for each person WITHIN THE SAME MONTH */ SUM(CommissionData.Total) OVER(PARTITION BY CommissionData.Sales_Person_ID , DATE_FORMAT(CommissionData.Earned_Date, '%Y-%m')  ) AS Total_Gross_Revenue,
		 EMP."Employee Name" AS Employee_Name,
		 EMP."Commission Percentage Tier 1" AS Commission_Percentage_Tier_1,
		 EMP."Commission Percentage Tier 2" AS Commission_Percentage_Tier_2,
		 EMP."Commission Percentage Tier 3" AS Commission_Percentage_Tier_3,
		 
			/* 11: Commission calculation using tiers - per person revenue not group total */
			CASE
				 WHEN SUM(CommissionData.Total) OVER(PARTITION BY CommissionData.Sales_Person_ID , DATE_FORMAT(CommissionData.Earned_Date, '%Y-%m')  )  > 130000 THEN CommissionData.Total * (COALESCE(EMP."Commission Percentage Tier 3", 8) / 100)
				 WHEN SUM(CommissionData.Total) OVER(PARTITION BY CommissionData.Sales_Person_ID , DATE_FORMAT(CommissionData.Earned_Date, '%Y-%m')  )  > 65000 THEN CommissionData.Total * (COALESCE(EMP."Commission Percentage Tier 2", 7) / 100)
				 ELSE CommissionData.Total * (COALESCE(EMP."Commission Percentage Tier 1", 6) / 100)
			 END AS Commission,
		 
			/* 12: Multiplier with tiers - per person revenue not group total */
/* Removed division by Division_Factor_Debug so AE Split shows same rate as AE */
			CASE
				 WHEN SUM(CommissionData.Total) OVER(PARTITION BY CommissionData.Sales_Person_ID , DATE_FORMAT(CommissionData.Earned_Date, '%Y-%m')  )  > 130000 THEN (COALESCE(EMP."Commission Percentage Tier 3", 8) / 100)
				 WHEN SUM(CommissionData.Total) OVER(PARTITION BY CommissionData.Sales_Person_ID , DATE_FORMAT(CommissionData.Earned_Date, '%Y-%m')  )  > 65000 THEN (COALESCE(EMP."Commission Percentage Tier 2", 7) / 100)
				 ELSE (COALESCE(EMP."Commission Percentage Tier 1", 6) / 100)
			 END AS Commission_Multiplier
FROM (/*------------------------------------------------------------------*/
/*  Subquery #1: Original (positive) fundings                       */
/* For Primary AE*/
	SELECT
			 D."Deal Name" AS "Deal Name",
			 D."Id" AS "Deal ID",
			 F."Status",
			 F."Commission Received Date" AS Earned_Date,
			 D."Account Executive" AS Sales_Person_ID,
			 'AE' AS Reason,
			 COALESCE(F."Lender Commission", 0) AS Lender_Commission,
			 COALESCE(F."Application Fee", 0) AS Application_Fee,
			 COALESCE(F."Professional Service Fee", 0) AS Professional_Service_Fee,
			 COALESCE(F."Lendzi Origination Fee", 0) AS Lendzi_Origination_Fee,
			 ((COALESCE(F."Lender Commission", 0) + COALESCE(F."Application Fee", 0) + COALESCE(F."Professional Service Fee", 0) + COALESCE(F."Lendzi Origination Fee", 0)) / 
				CASE
					 WHEN D."Secondary Account Executive"  IS NULL THEN 1
					 ELSE 2
				 END) AS Total,
			 
				CASE
					 WHEN D."Secondary Account Executive"  IS NULL THEN 1
					 ELSE 2
				 END AS Division_Factor_Debug
	FROM  "Deals" D
LEFT JOIN "Fundings" F ON F."Deal"  = D."Id"  
	WHERE	 F."Status"  = 'Funded'
	UNION ALL
 /* For Secondary AE (when exists)*/
	SELECT
			 D."Deal Name" AS "Deal Name",
			 D."Id" AS "Deal ID",
			 F."Status",
			 F."Commission Received Date" AS Earned_Date,
			 D."Secondary Account Executive" AS Sales_Person_ID,
			 'AE Split' AS Reason,
			 COALESCE(F."Lender Commission", 0) AS Lender_Commission,
			 COALESCE(F."Application Fee", 0) AS Application_Fee,
			 COALESCE(F."Professional Service Fee", 0) AS Professional_Service_Fee,
			 COALESCE(F."Lendzi Origination Fee", 0) AS Lendzi_Origination_Fee,
			 ((COALESCE(F."Lender Commission", 0) + COALESCE(F."Application Fee", 0) + COALESCE(F."Professional Service Fee", 0) + COALESCE(F."Lendzi Origination Fee", 0)) / 
				CASE
					 WHEN D."Secondary Account Executive"  IS NULL THEN 1
					 ELSE 2
				 END) AS Total,
			 2 AS Division_Factor_Debug
	FROM  "Deals" D
LEFT JOIN "Fundings" F ON F."Deal"  = D."Id"  
	WHERE	 D."Secondary Account Executive"  IS NOT NULL
	 AND	F."Status"  = 'Funded'
	UNION ALL
 /*------------------------------------------------------------------*/
/*  Subquery #2: Clawback (negative) rows                           */
/*  Appear in the month of F."Clawback Date" with negative Total.   */
	SELECT
			 D."Deal Name" AS "Deal Name",
			 D."Id" AS "Deal ID",
			 F."Status",
			 F."Clawback Date" AS Earned_Date,
			 D."Account Executive" AS Sales_Person_ID,
			 
				CASE
					 WHEN D."Secondary Account Executive"  IS NULL THEN 'AE Clawback'
					 ELSE 'AE Split Clawback'
				 END AS Reason,
			 0 AS Lender_Commission,
			 0 AS Application_Fee,
			 0 AS Professional_Service_Fee,
			 0 AS Lendzi_Origination_Fee,
			 (-1 * COALESCE(F."Clawback Amount", 0)) / 
				CASE
					 WHEN D."Secondary Account Executive"  IS NULL THEN 1
					 ELSE 2
				 END AS Total,
			 
				CASE
					 WHEN D."Secondary Account Executive"  IS NULL THEN 1
					 ELSE 2
				 END AS Division_Factor_Debug
	FROM  "Deals" D
LEFT JOIN "Fundings" F ON F."Deal"  = D."Id"  
	WHERE	 F."Clawback Date"  IS NOT NULL
	 AND	F."Status"  = 'Funded'
	UNION ALL
 /* Clawback for Secondary AE (only if split)*/
	SELECT
			 D."Deal Name" AS "Deal Name",
			 D."Id" AS "Deal ID",
			 F."Status",
			 F."Clawback Date" AS Earned_Date,
			 D."Secondary Account Executive" AS Sales_Person_ID,
			 'AE Split Clawback' AS Reason,
			 0 AS Lender_Commission,
			 0 AS Application_Fee,
			 0 AS Professional_Service_Fee,
			 0 AS Lendzi_Origination_Fee,
			 (-1 * COALESCE(F."Clawback Amount", 0)) / 
				CASE
					 WHEN D."Secondary Account Executive"  IS NULL THEN 1
					 ELSE 2
				 END AS Total,
			 2 AS Division_Factor_Debug
	FROM  "Deals" D
LEFT JOIN "Fundings" F ON F."Deal"  = D."Id"  
	WHERE	 F."Clawback Date"  IS NOT NULL
	 AND	D."Secondary Account Executive"  IS NOT NULL
	 AND	F."Status"  = 'Funded'
 
 
 
) AS  CommissionData
LEFT JOIN "Employees" EMP ON CommissionData.Sales_Person_ID  = EMP."Employee"  
WHERE	 CommissionData.Sales_Person_ID  IS NOT NULL
