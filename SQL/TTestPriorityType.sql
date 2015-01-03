USE [COGData]
GO

/****** Object:  Table [dbo].[TTestPriorityType]    Script Date: 1/3/2015 10:33:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TTestPriorityType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[PriorityName] [nvarchar](255) NOT NULL,
	[PriorityRank] [int] NOT NULL,
 CONSTRAINT [PK_TTestPriorityType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

