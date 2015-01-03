
/****** Object:  Table [dbo].[TTestProject]    Script Date: 1/3/2015 10:33:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TTestProject](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectTitle] [nvarchar](255) NOT NULL,
	[AxoSoftID] [nvarchar](50) NULL,
	[ProjectDescription] [nvarchar](max) NOT NULL,
	[ProjectStartDate] [date] NOT NULL,
	[ProjectProjectedEndDate] [date] NULL,
	[ProjectActualEndDate] [date] NULL,
	[IncludeAnnouncement] [bit] NOT NULL,
	[RepositoryType] [int] NOT NULL,
	[Closed] [bit] NOT NULL,
 CONSTRAINT [PK_TTestProject] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[TTestProject] ADD  CONSTRAINT [DF_TTestProject_IncludeAnnouncement]  DEFAULT ((0)) FOR [IncludeAnnouncement]
GO

