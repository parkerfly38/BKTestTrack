USE [COGData]
GO

/****** Object:  StoredProcedure [dbo].[PGeneralActivityByProject]    Script Date: 1/3/2015 10:35:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian Kresge, MBA
-- Create date: 01/02/15
-- Description:	Returns active project data
-- =============================================
CREATE PROCEDURE [dbo].[PGeneralActivityByProject]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--declare @tempDates table (
--	datelist date
--)

;with cte (datelist, maxdate) as
(
	SELECT DateAdd(day, -14, GETDATE()) as datelist, getdate() as  maxdate
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

		set @query = 'SELECT ProjectTitle, ' + @cols + ' from 
             (
                select b.ProjectTitle, 
                    d.datelist,
                    convert(CHAR(10), datelist, 120) PivotDate
                from #tempDates d
                inner join
					(
						SELECT ProjectTitle, DateTested
						FROM TTestProject
						INNER JOIN TTestCase ON TTestCase.ProjectID = TTestProject.id
						INNER JOIN TTestResult ON TTestResult.TestCaseID = TTestCase.id
						WHERE DateTested <= GETDATE() and DateTested >= DATEADD(DAY,-14,GETDATE())
						AND Closed = 0
						
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

GO

