
/****** Object:  StoredProcedure [dbo].[PReturnTestResultCounts]    Script Date: 1/3/2015 10:35:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian Kresge, MBA
-- Create date: 12/22/14
-- Description:	Returns counts of various categories of tests across 14 days
-- =============================================
CREATE PROCEDURE [dbo].[PReturnTestResultCounts]
	@projectid int
AS
BEGIN

SELECT		Convert(varchar(10),DateTested,101) as DateTested,
			sum(case when StatusID = 2 then 1 else 0 end) as PassedCount,
			sum(case when StatusID = 3 then 1 else 0 end) as FailedCount,
			sum(case when StatusID = 1 then 1 else 0 end) as UntestedCount,
			sum(case when StatusID = 4 then 1 else 0 end) as BlockedCount,
			sum(case when StatusID = 5 then 1 else 0 end) as RetestCount
FROM		TTestResult
INNER JOIN	TTestCase ON TTestResult.TestCaseID = TTestCase.id
WHERE		DateTested <= GETDATE() and DateTested >= DATEADD(DAY,-14,GETDATE())
AND			TTestCase.ProjectID = @projectid
GROUP BY	DateTested


END

GO

