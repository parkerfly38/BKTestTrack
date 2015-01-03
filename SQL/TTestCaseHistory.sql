

/****** Object:  Table [dbo].[TTestCaseHistory]    Script Date: 1/3/2015 10:32:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TTestCaseHistory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Action] [nvarchar](255) NOT NULL,
	[TesterID] [int] NOT NULL,
	[DateOfAction] [date] NOT NULL,
	[CaseId] [int] NOT NULL,
	[DateActionClosed] [date] NULL,
 CONSTRAINT [PK_TTestCaseHistory] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

