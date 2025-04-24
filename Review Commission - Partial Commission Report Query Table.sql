SELECT
		 "Google Review Date" AS Earned_Date,
		 "Account Executive" AS Sales_Person_ID,
		 'Google Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Deal Name" AS Deal_Name
FROM  "Deals" 
WHERE	 "Google Review Star Rating"  = '05'
 AND	"Account Executive"  != 4470003000001045001
UNION ALL
 SELECT
		 "Trust Pilot Review Date" AS Earned_Date,
		 "Account Executive" AS Sales_Person_ID,
		 'TrustPilot Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Deal Name" AS Deal_Name
FROM  "Deals" 
WHERE	 "TrustPilot Star Rating"  = '05'
 AND	"Account Executive"  != 4470003000001045001
UNION ALL
 SELECT
		 "BBB Review Date" AS Earned_Date,
		 "Account Executive" AS Sales_Person_ID,
		 'BBB Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Deal Name" AS Deal_Name
FROM  "Deals" 
WHERE	 "BBB Star Rating"  = '05'
 AND	"Account Executive"  != 4470003000001045001
UNION ALL
 SELECT
		 "Google Review Date" AS Earned_Date,
		 "Renewal Manager" AS Sales_Person_ID,
		 'Google Renewal Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Renewal Name" AS Deal_Name
FROM  "Renewals" 
WHERE	 "Google Review Star Rating"  = '05'
 AND	"Renewal Manager"  != 4470003000001045001
UNION ALL
 SELECT
		 "Google Review Date" AS Earned_Date,
		 "Renewal Manager" AS Sales_Person_ID,
		 'TrustPilot Renewal Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Renewal Name" AS Deal_Name
FROM  "Renewals" 
WHERE	 "TrustPilot Review Rating"  = '05'
 AND	"Renewal Manager"  != 4470003000001045001
UNION ALL
 SELECT
		 "BBB Review Date" AS Earned_Date,
		 "Renewal Manager" AS Sales_Person_ID,
		 'BBB Renewal Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Renewal Name" AS Deal_Name
FROM  "Renewals" 
WHERE	 "BBB Star Rating"  = '05'
 AND	"Renewal Manager"  != 4470003000001045001
UNION ALL
 SELECT
		 "Google Review Date" AS Earned_Date,
		 "Account Executive" AS Sales_Person_ID,
		 'Google Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Deal Name" AS Deal_Name
FROM  "Deals" 
WHERE	 "Google Review Star Rating"  = '05'
 AND	"Account Executive"  = 4470003000001045001
UNION ALL
 SELECT
		 "Trust Pilot Review Date" AS Earned_Date,
		 "Account Executive" AS Sales_Person_ID,
		 'TrustPilot Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Deal Name" AS Deal_Name
FROM  "Deals" 
WHERE	 "TrustPilot Star Rating"  = '05'
 AND	"Account Executive"  = 4470003000001045001
UNION ALL
 SELECT
		 "BBB Review Date" AS Earned_Date,
		 "Account Executive" AS Sales_Person_ID,
		 'BBB Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Deal Name" AS Deal_Name
FROM  "Deals" 
WHERE	 "BBB Star Rating"  = '05'
 AND	"Account Executive"  = 4470003000001045001
UNION ALL
 SELECT
		 "Google Review Date" AS Earned_Date,
		 "Renewal Manager" AS Sales_Person_ID,
		 'Google Renewal Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Renewal Name" AS Deal_Name
FROM  "Renewals" 
WHERE	 "Google Review Star Rating"  = '05'
 AND	"Renewal Manager"  = 4470003000001045001
UNION ALL
 SELECT
		 "TrustPilot Review Date" AS Earned_Date,
		 "Renewal Manager" AS Sales_Person_ID,
		 'TrustPilot Renewal Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Renewal Name" AS Deal_Name
FROM  "Renewals" 
WHERE	 "TrustPilot Review Rating"  = '05'
 AND	"Renewal Manager"  = 4470003000001045001
UNION ALL
 SELECT
		 "BBB Review Date" AS Earned_Date,
		 "Renewal Manager" AS Sales_Person_ID,
		 'BBB Renewal Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 "Id" AS Deal_ID,
		 "Renewal Name" AS Deal_Name
FROM  "Renewals" 
WHERE	 "BBB Star Rating"  = '05'
 AND	"Renewal Manager"  = 4470003000001045001
 
 
 
 
 
 
 
 
 
 
 
