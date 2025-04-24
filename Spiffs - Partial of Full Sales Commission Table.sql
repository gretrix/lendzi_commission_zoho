SELECT
		 I.Id AS "Spiff Id",
		 MAX(I."Date") AS "Earned_Date",
		 /* use latest date in the month as Earned_Date*/ U."Id" AS "Sales_Person_ID",
		 'Spiffs' AS "Reason",
		 SUM(I."Amount") AS "Total",
		 0 AS "Commission",
		 0 AS "Commission_Multiplier",
		 COALESCE(D."Deal Name", I."Description") AS "Deal_Name",
		 I."Status" /* Added Status column with alias */ AS "Status"
FROM  "Incentives" I
LEFT JOIN "Incentive-Deals" AS  IncDeals ON IncDeals."Incentive"  = I.Id 
LEFT JOIN "Deals" AS  D ON IncDeals."Deal"  = D.Id 
LEFT JOIN "Users" U ON I."Incentive Owner Name"  = U."Full Name"  
WHERE	 I."Status"  = 'Approved' /* Added status filter for approved Spiffs only */

GROUP BY U."Id",
	 DATE_TRUNC('MONTH', I."Date"),
	 I."Status",
	 COALESCE(D."Deal Name", I."Description"),
	  I."Id" 
