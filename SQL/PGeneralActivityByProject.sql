

-- =============================================
-- Author:		Brian Kresge, MBA
-- Create date: 01/02/15
-- Description:	Returns active project data
-- =============================================
ALTER PROCEDURE [dbo].[PGeneralActivityByProject]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--declare @tempDates table (
--	datelist date
--)

declare @maximumDate datetime;
select @maximumDate = MAX(DateTested) FROM TTestResult

;with cte (datelist, maxdate) as
(
	SELECT DateAdd(day, -30, @maximumDate) as datelist, @maximumDate as maxdate
	UNION ALL
	select dateadd(dd,1,datelist), maxdate
	FROM cte
	WHERE datelist < maxdate
)
select c.dateList
into #tempDates
from cte c

DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX)

-- declare our columns
select @cols = STUFF((SELECT distinct ',' + QUOTENAME(convert(CHAR(10), datelist, 120)) 
                    from #tempDates
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		set @query = '
		     DECLARE @maximumDate datetime;
		     SELECT @maximumDate = MAX(DateTested) FROM TTestResult;
			 SELECT ProjectTitle, Color, ' + @cols + ' from 
             (
                select b.ProjectTitle, 
                    d.datelist,
                    b.Color,
                    convert(CHAR(10), datelist, 120) PivotDate
                from #tempDates d
                inner join
					(
						SELECT ProjectTitle, DateTested, Color
						FROM TTestProject
						INNER JOIN TTestCase ON TTestCase.ProjectID = TTestProject.id
						INNER JOIN TTestResult ON TTestResult.TestCaseID = TTestCase.id
						--WHERE DateTested <= @maximumDate  and DateTested >= DATEADD(DAY,-30,@maximumDate)
						WHERE Closed = 0
						
					)  b
					on cast(d.datelist as date) = cast(b.datetested as date)
            ) x
            pivot 
            (
                count(datelist)
                for PivotDate in (' + @cols + ')
            ) p 
			
			
			drop table #tempDates'

			execute(@query)

END

