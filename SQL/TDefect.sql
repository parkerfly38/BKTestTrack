
/****** Object:  Table [dbo].[TDefect]    Script Date: 12/28/2014 10:45:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TDefect](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Defect] [varchar](max) NOT NULL,
	[DefectDate] [date] NOT NULL,
	[TestCaseId] [int] NOT NULL,
	[AxoSoftId] [varchar](50) NULL,
 CONSTRAINT [PK_TDefect] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

