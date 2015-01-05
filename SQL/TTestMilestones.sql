
/****** Object:  Table [dbo].[TTestMilestones]    Script Date: 1/3/2015 10:32:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TTestMilestones](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Milestone] [varchar](255) NOT NULL,
	[DueOn] [date] NULL,
	[MilestoneDescription] [varchar](max) NULL,
	[Closed] [bit] NOT NULL,
	[ProjectID] [int] NOT NULL,
 CONSTRAINT [PK_TTestMilestones] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TTestMilestones] ADD  CONSTRAINT [DF_TTestMilestones_Closed]  DEFAULT ((0)) FOR [Closed]
GO
