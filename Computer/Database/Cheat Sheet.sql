#-----------------------------------------
# Take Transpose
#-----------------------------------------
SELECT 
	DateValue(iFEMaster.[Case Create Date]) AS [Case Create Date],
	SUM(IIf(Nature1='Coverage issue',1,0)) AS [Coverage issue],
	SUM(IIf(Nature1='Voice Quality',1,0)) AS [Voice Quality],
	SUM(IIf(Nature1 Like '*(Data)*',1,0)) AS Data,
	SUM(IIf(Nature1='Drop call',1,0)) AS [Drop call],
	SUM(IIf(Nature1='Unable to make/ receive call',1,0)) AS [Unable to make/ receive call],
	COUNT(*) AS [Grand Total]
FROM iFEMaster
GROUP BY DateValue([Case Create Date]);
