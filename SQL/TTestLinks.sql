USE [COGData]
GO

/****** Object:  Table [dbo].[TTestLinks]    Script Date: 1/3/2015 10:32:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TTestLinks](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[LinkDesc] [nvarchar](255) NOT NULL,
	[LinkHref] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_TTestLinks] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

