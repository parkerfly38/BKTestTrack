USE [COGData]
GO

/****** Object:  Table [dbo].[TTestResult]    Script Date: 1/3/2015 10:34:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TTestResult](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[StatusID] [int] NOT NULL,
	[TesterID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[ElapsedTime] [int] NULL,
	[Comment] [varchar](max) NULL,
	[DateTested] [datetime] NOT NULL,
	[AttachmentList] [nvarchar](max) NULL,
	[TestCaseID] [int] NOT NULL,
 CONSTRAINT [PK_TTestResult] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TTestResult] ADD  CONSTRAINT [DF_TTestResult_TestCaseID]  DEFAULT ((0)) FOR [TestCaseID]
GO

