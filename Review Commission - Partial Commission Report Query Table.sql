SELECT
		 D."Google Review Date" AS Earned_Date,
		 D."Account Executive" AS Sales_Person_ID,
		 'Google Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 D."Id" AS Deal_ID,
		 D."Deal Name" AS Deal_Name
FROM "Deals" D
WHERE D."Google Review Star Rating" = '05'
 AND D."Account Executive" != 4470003000001045001
UNION ALL
 SELECT
		 D."Trust Pilot Review Date" AS Earned_Date,
		 D."Account Executive" AS Sales_Person_ID,
		 'TrustPilot Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 D."Id" AS Deal_ID,
		 D."Deal Name" AS Deal_Name
FROM "Deals" D
WHERE D."TrustPilot Star Rating" = '05'
 AND D."Account Executive" != 4470003000001045001
UNION ALL
 SELECT
		 D."BBB Review Date" AS Earned_Date,
		 D."Account Executive" AS Sales_Person_ID,
		 'BBB Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 D."Id" AS Deal_ID,
		 D."Deal Name" AS Deal_Name
FROM "Deals" D
WHERE D."BBB Star Rating" = '05'
 AND D."Account Executive" != 4470003000001045001
UNION ALL
 SELECT
		 R."Google Review Date" AS Earned_Date,
		 R."Renewal Manager" AS Sales_Person_ID,
		 'Google Renewal Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 R."Id" AS Deal_ID,
		 R."Renewal Name" AS Deal_Name
FROM "Renewals" R
WHERE R."Google Review Star Rating" = '05'
 AND R."Renewal Manager" != 4470003000001045001
UNION ALL
 SELECT
		 R."TrustPilot Review Date" AS Earned_Date, -- Fixed: Was incorrectly using Google Review Date
		 R."Renewal Manager" AS Sales_Person_ID,
		 'TrustPilot Renewal Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 R."Id" AS Deal_ID,
		 R."Renewal Name" AS Deal_Name
FROM "Renewals" R
WHERE R."TrustPilot Review Rating" = '05' -- Fixed: Using actual column name from database
 AND R."Renewal Manager" != 4470003000001045001
UNION ALL
 SELECT
		 R."BBB Review Date" AS Earned_Date,
		 R."Renewal Manager" AS Sales_Person_ID,
		 'BBB Renewal Reviews' AS Reason,
		 1 AS Total,
		 25 AS Commission,
		 25 AS Commission_Multiplier,
		 R."Id" AS Deal_ID,
		 R."Renewal Name" AS Deal_Name
FROM "Renewals" R
WHERE R."BBB Star Rating" = '05'
 AND R."Renewal Manager" != 4470003000001045001
UNION ALL
 SELECT
		 D."Google Review Date" AS Earned_Date,
		 D."Account Executive" AS Sales_Person_ID,
		 'Google Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 D."Id" AS Deal_ID,
		 D."Deal Name" AS Deal_Name
FROM "Deals" D
WHERE D."Google Review Star Rating" = '05'
 AND D."Account Executive" = 4470003000001045001
UNION ALL
 SELECT
		 D."Trust Pilot Review Date" AS Earned_Date,
		 D."Account Executive" AS Sales_Person_ID,
		 'TrustPilot Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 D."Id" AS Deal_ID,
		 D."Deal Name" AS Deal_Name
FROM "Deals" D
WHERE D."TrustPilot Star Rating" = '05'
 AND D."Account Executive" = 4470003000001045001
UNION ALL
 SELECT
		 D."BBB Review Date" AS Earned_Date,
		 D."Account Executive" AS Sales_Person_ID,
		 'BBB Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 D."Id" AS Deal_ID,
		 D."Deal Name" AS Deal_Name
FROM "Deals" D
WHERE D."BBB Star Rating" = '05'
 AND D."Account Executive" = 4470003000001045001
UNION ALL
 SELECT
		 R."Google Review Date" AS Earned_Date,
		 R."Renewal Manager" AS Sales_Person_ID,
		 'Google Renewal Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 R."Id" AS Deal_ID,
		 R."Renewal Name" AS Deal_Name
FROM "Renewals" R
WHERE R."Google Review Star Rating" = '05'
 AND R."Renewal Manager" = 4470003000001045001
UNION ALL
 SELECT
		 R."TrustPilot Review Date" AS Earned_Date, -- Fixed: Was incorrectly using Google Review Date
		 R."Renewal Manager" AS Sales_Person_ID,
		 'TrustPilot Renewal Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 R."Id" AS Deal_ID,
		 R."Renewal Name" AS Deal_Name
FROM "Renewals" R
WHERE R."TrustPilot Review Rating" = '05' -- Fixed: Using actual column name from database
 AND R."Renewal Manager" = 4470003000001045001
UNION ALL
 SELECT
		 R."BBB Review Date" AS Earned_Date,
		 R."Renewal Manager" AS Sales_Person_ID,
		 'BBB Renewal Reviews' AS Reason,
		 1 AS Total,
		 30 AS Commission,
		 30 AS Commission_Multiplier,
		 R."Id" AS Deal_ID,
		 R."Renewal Name" AS Deal_Name
FROM "Renewals" R
WHERE R."BBB Star Rating" = '05'
 AND R."Renewal Manager" = 4470003000001045001