

/****** Object:  Table [dbo].[TTestProjectTestSection]    Script Date: 1/3/2015 10:33:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TTestProjectTestSection](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Section] [nvarchar](255) NOT NULL,
	[ProjectID] [int] NOT NULL,
 CONSTRAINT [PK_TTestProjectTestSection] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

