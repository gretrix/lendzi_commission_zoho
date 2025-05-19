SELECT DISTINCT
		 Subquery."Earned_Date" AS "Earned_Date",
		 B."Full Name" AS "Sales_Person_Name",
		 Subquery."Reason" AS "Reason",
		 Subquery."Total" AS "Collected",
		 Subquery."Commission" AS "Commission",
		 Subquery."Commission_Multiplier" AS "Commission Split",
		 Subquery."Deal_Name" AS "Deal Name",
		 Subquery."Subordinate Name" AS "Subordinate Name"
FROM (/* Standardized subquery ensuring 7 columns in all SELECTs*/
	SELECT
			 "Earned_Date",
			 "Sales_Person_ID",
			 "Reason",
			 "Total",
			 "Commission",
			 "Commission_Multiplier",
			 "Deal_Name",
			 NULL AS "Subordinate Name"
	FROM  "Spiffs - Partial of Full Sales Commission Table" 
	WHERE	 "Sales_Person_ID"  IS NOT NULL
	UNION ALL
 	SELECT
			 "CommissionData.Earned_Date",
			 "CommissionData.Sales_Person_ID",
			 "CommissionData.Reason",
			 "CommissionData.Total",
			 "Commission",
			 "Commission_Multiplier",
			 "Deal Name",
			 NULL AS "Subordinate Name"
	FROM  "AE Dev" 
	WHERE	 "CommissionData.Sales_Person_ID"  IS NOT NULL
	UNION ALL
 	SELECT
			 "Earned_Date",
			 "Sales_Person_ID",
			 "Reason",
			 "Total",
			 "Commission",
			 "Commission_Multiplier",
			 "Deal Name",
			 NULL AS "Subordinate Name"
	FROM  "SDR Dev" 
	WHERE	 "Sales_Person_ID"  IS NOT NULL
	UNION ALL
 	SELECT
			 "Earned_Date",
			 "Sales_Person_ID",
			 "Reason",
			 "Total",
			 "Commission",
			 "Commission_Multiplier",
			 "Deal_Name",
			 NULL AS "Subordinate Name"
	FROM  "Review Commission - Partial Commission Report Query Table" 
	WHERE	 "Sales_Person_ID"  IS NOT NULL
	UNION ALL
 	SELECT
			 "Earned_Date",
			 "Sales_Person_ID",
			 "Reason",
			 "Total",
			 "Commission",
			 "Commission_Multiplier",
			 "Deal_Name",
			 NULL AS "Subordinate Name"
	FROM  "Renewal Manager Aggregated Commission - Partial of Full Commission Report" 
	WHERE	 "Sales_Person_ID"  IS NOT NULL
	UNION ALL
 	SELECT
			 "Earned_Date",
			 "Sales_Person_ID",
			 "Reason",
			 "Total",
			 "Commission",
			 "Commission_Multiplier",
			 "Deal_Name",
			 NULL AS "Subordinate Name"
	FROM  "Renewal Admin Commission - Partial of Full Commission Reports" 
	WHERE	 "Sales_Person_ID"  IS NOT NULL
	UNION ALL
 	SELECT
			 "Commission Date" AS "Earned_Date",
			 "Manager ID" AS "Sales_Person_ID",
			 "Reason Type" AS "Reason",
			 "Total Revenue" AS "Total",
			 "Override Commission" AS "Commission",
			 0.01 AS "Commission_Multiplier",
			 /* Fixed 1% for Renewal Manager Override*/ "Deal Name" AS "Deal_Name",
			 "Employee Name" AS "Subordinate Name"
	FROM  "Renewal Manager Override - Query Table" 
	UNION ALL
 	SELECT
			 "Commission Date" AS "Earned_Date",
			 "Manager ID" AS "Sales_Person_ID",
			 'Manager Override' AS "Reason",
			 "Total Revenue" AS "Total",
			 "Override Commission" AS "Commission",
			 0.015 AS "Commission_Multiplier",
			 /* Standard 1.5% for Manager Override*/ "Deal Name" AS "Deal_Name",
			 "Employee Name" AS "Subordinate Name"
	FROM  "Manager Override - Query Table.sql" 
 
 
 
 
 
 
 
) AS  Subquery
LEFT JOIN "Users" B ON Subquery."Sales_Person_ID"  = B."Id"  
WHERE	 B."Full Name"  IS NOT NULL
