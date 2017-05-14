
/****** Object:  StoredProcedure [dbo].[PTodos]    Script Date: 1/3/2015 10:36:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian Kresge, MBA
-- Create date: 12/22/14
-- Description:	Returns todo by section
-- =============================================
CREATE PROCEDURE [dbo].[PTodos]

AS
BEGIN

SELECT		c.Section, count(a.id) as ItemCount
FROM		TTestResult a
INNER JOIN	TTestCase b ON a.TestCaseID = b.id
INNER JOIN	TTestProjectTestSection c on c.id = b.id
WHERE		a.StatusID != 2
GROUP BY	c.Section


END

GO

