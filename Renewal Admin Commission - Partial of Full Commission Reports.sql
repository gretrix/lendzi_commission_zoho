SELECT
		 R."Id" AS "Renewal ID",
		 F."Id" AS "Funding ID",
		 F."Funding",
		 R."Renewal Name",
		 F."Funded Date" AS Earned_Date,
		 F."Renewal Admin" AS Sales_Person_ID,
		 'Renewal Admin' AS Reason,
		 F."Lender Commission",
		 F."Professional Service Fee",
		 F."Lendzi Origination Fee",
		 F."Application Fee",
		 AGG.Total_Gross_Revenue,
		 IFNULL(F."Lender Commission", 0) + IFNULL(F."Professional Service Fee", 0) + IFNULL(F."Lendzi Origination Fee", 0) + IFNULL(F."Application Fee", 0) AS Total,
		 
			CASE
				 WHEN AGG.Total_Gross_Revenue  > 130000 THEN (IFNULL(F."Lender Commission", 0) + IFNULL(F."Professional Service Fee", 0) + IFNULL(F."Lendzi Origination Fee", 0) + IFNULL(F."Application Fee", 0) * 0.02)
				 WHEN AGG.Total_Gross_Revenue  BETWEEN 65000  AND  130000 THEN (IFNULL(F."Lender Commission", 0) + IFNULL(F."Professional Service Fee", 0) + IFNULL(F."Lendzi Origination Fee", 0) + IFNULL(F."Application Fee", 0) * 0.02)
				 ELSE ((IFNULL(F."Lender Commission", 0) + IFNULL(F."Professional Service Fee", 0) + IFNULL(F."Lendzi Origination Fee", 0)) * 0.02)
			 END AS Commission,
		 
			CASE
				 WHEN AGG.Total_Gross_Revenue  > 130000 THEN 0.02
				 WHEN AGG.Total_Gross_Revenue  BETWEEN 65000  AND  130000 THEN 0.02
				 ELSE 0.02
			 END AS Commission_Multiplier,
		 R."Id" AS Deal_ID,
		 R."Renewal Name" AS Deal_Name
FROM  "Renewals" R
JOIN "Fundings" F ON R."Id"  = F."Renewal" 
JOIN(/* Total Rep Revenue Amount for Determining Commission Rate (Reps make different commission %s based on how much revenue they've made for the month) */
	SELECT
			 R2."Renewal Admin" AS Sales_Person_ID,
			 SUM((F2."Lender Commission" + F2."Professional Service Fee" + F2."Lendzi Origination Fee" + F2."Application Fee")) AS Total_Gross_Revenue,
			 DATE_FORMAT(F2."Funded Date", '%Y-%m') AS Funded_Month
	FROM  "Renewals" R2
JOIN "Fundings" F2 ON R2."Id"  = F2."Renewal"  
	GROUP BY R2."Renewal Admin",
		  Funded_Month 
) AGG ON R."Renewal Admin"  = AGG.Sales_Person_ID
	 AND	DATE_FORMAT(F."Funded Date", '%Y-%m')  = AGG.Funded_Month  
ORDER BY R."Renewal Name" 
