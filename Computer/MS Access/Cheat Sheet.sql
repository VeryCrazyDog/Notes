#-----------------------------------------
# Select Date Range
#-----------------------------------------
SELECT *
FROM mytable
WHERE (DateValue([Case Create Date]) Between DateValue([From Date]) And DateValue([To Date]));