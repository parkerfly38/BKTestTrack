USE [COGData]
GO

/****** Object:  Table [dbo].[TEmailContent]    Script Date: 12/28/2014 11:29:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TEmailContent](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[emailTitle] [varchar](1000) NOT NULL,
	[emailBody] [nvarchar](max) NULL,
	[date] [date] NOT NULL,
	[emailTemplate] [varchar](255) NULL,
 CONSTRAINT [PK_TEmailContent] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TEmailContent]  WITH CHECK ADD  CONSTRAINT [FK_TEmailContent_TEmailContent] FOREIGN KEY([id])
REFERENCES [dbo].[TEmailContent] ([id])
GO

ALTER TABLE [dbo].[TEmailContent] CHECK CONSTRAINT [FK_TEmailContent_TEmailContent]
GO

