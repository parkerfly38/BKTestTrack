-- =============================================
-- Author:		Brian Kresge, MBA
-- Create date: 12/22/14
-- Description:	Returns counts of various categories of tests across 14 days
-- =============================================
ALTER PROCEDURE [dbo].[PReturnTestResultCounts]
	@projectid int
AS
BEGIN

SELECT		DateTested,
			sum(case when StatusID = 2 then 1 else 0 end) as PassedCount,
			sum(case when StatusID = 3 then 1 else 0 end) as FailedCount,
			sum(case when StatusID = 1 then 1 else 0 end) as UntestedCount,
			sum(case when StatusID = 4 then 1 else 0 end) as BlockedCount,
			sum(case when StatusID = 5 then 1 else 0 end) as RetestCount
FROM		TTestResult
INNER JOIN	TTestCase ON TTestResult.TestCaseID = TTestCase.id
--WHERE		DateTested <= GETDATE() and DateTested >= DATEADD(DAY,-14,GETDATE())
WHERE			TTestCase.ProjectID = @projectid
GROUP BY	DateTested
ORDER BY	DateTested ASC

END


