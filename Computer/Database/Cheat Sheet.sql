#-----------------------------------------
# Take Transpose, Microsoft Access
#-----------------------------------------
SELECT 
	DateValue([Case Create Date]) AS [Case Create Date],
	SUM(IIf(status='Success',1,0)) AS [Success],
	SUM(IIf(status='Failed',1,0)) AS [Failed],
	COUNT(*) AS [Grand Total]
FROM mytable
GROUP BY DateValue([Case Create Date]);
