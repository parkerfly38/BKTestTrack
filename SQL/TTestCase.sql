
/****** Object:  Table [dbo].[TTestCase]    Script Date: 1/3/2015 10:31:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TTestCase](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TestTitle] [nvarchar](255) NOT NULL,
	[TestDetails] [nvarchar](max) NULL,
	[PriorityId] [int] NOT NULL,
	[TypeId] [int] NOT NULL,
	[SectionId] [int] NOT NULL,
	[ProjectID] [int] NOT NULL,
	[Preconditions] [nvarchar](max) NULL,
	[Steps] [nvarchar](max) NULL,
	[ExpectedResult] [nvarchar](max) NULL,
	[MilestoneId] [int] NOT NULL,
	[Estimate] [int] NULL,
 CONSTRAINT [PK_TTestCase] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[TTestCase] ADD  CONSTRAINT [DF_TTestCase_MilestoneId]  DEFAULT ((0)) FOR [MilestoneId]
GO

