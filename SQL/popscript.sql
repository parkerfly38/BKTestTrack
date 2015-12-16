USE [bk]
GO
/****** Object:  Table [dbo].[TTestPriorityType]    Script Date: 12/16/2015 7:34:39 AM ******/
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
/****** Object:  Table [dbo].[TTestSettings]    Script Date: 12/16/2015 7:34:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TTestSettings](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Setting] [varchar](255) NOT NULL,
	[SettingValue] [varchar](255) NOT NULL,
 CONSTRAINT [PK_TTestSettings] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TTestStatus]    Script Date: 12/16/2015 7:34:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TTestStatus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_TTestStatus] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TTestTester]    Script Date: 12/16/2015 7:34:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TTestTester](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ADID] [nvarchar](50) NOT NULL,
	[UserName] [nvarchar](255) NOT NULL,
	[password] [varchar](1000) NULL,
	[email] [varchar](255) NULL,
	[salt] [varchar](1000) NULL,
	[samaccountname] [varchar](255) NULL,
	[isApproved] [bit] NOT NULL CONSTRAINT [DF__TTestTest__isApp__56E8E7AB]  DEFAULT ((0)),
	[AxoSoftToken] [varchar](50) NULL,
 CONSTRAINT [PK_TTestTester] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TTestType]    Script Date: 12/16/2015 7:34:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TTestType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](255) NOT NULL,
 CONSTRAINT [PK_TTestType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[TTestPriorityType] ON 

INSERT [dbo].[TTestPriorityType] ([id], [PriorityName], [PriorityRank]) VALUES (1, N'High - Urgent', 1)
INSERT [dbo].[TTestPriorityType] ([id], [PriorityName], [PriorityRank]) VALUES (2, N'High', 2)
INSERT [dbo].[TTestPriorityType] ([id], [PriorityName], [PriorityRank]) VALUES (3, N'Medium', 3)
INSERT [dbo].[TTestPriorityType] ([id], [PriorityName], [PriorityRank]) VALUES (4, N'Low', 4)
SET IDENTITY_INSERT [dbo].[TTestPriorityType] OFF
SET IDENTITY_INSERT [dbo].[TTestSettings] ON 

INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (1, N'UseLDAP', N'false')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (2, N'AllowCaseDelete', N'true')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (3, N'MAILERDAEMONADDRESS', N'cftesttrack@cornerstoneoperations.com')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (4, N'AllowChat', N'true')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (5, N'AxoSoftIntegration', N'false')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (6, N'AxoSoftAuthentication', N'Authorization')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (7, N'AxoSoftClient_Id', N'9f8b89e1-e314-4685-a0fc-2ad85bef0350')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (8, N'AxoSoftClient_Secret', N'a92edd03-6fa0-44dc-aebc-b90ea1bb399c')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (9, N'AxoSoftRedirectURI', N'http://localhost/CFTestTrack/AxoSoftRedirect.cfm')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (10, N'AxoSoftExpiration', N'false')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (11, N'AxoSoftURL', N'https://cornerops.axosoft.com/')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (12, N'AxoSoftUseAPI', N'false')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (13, N'SlackIntegration', N'true')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (14, N'SlackAPIToken', N'xoxb-15570080624-enfYmo68URHDZ43Bq8sK4kCj')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (15, N'SlackBotChannel', N'C0F91JR9C')
INSERT [dbo].[TTestSettings] ([id], [Setting], [SettingValue]) VALUES (16, N'SlackBotURL', N'https://bk-mp.slack.com/services/hooks/slackbot?token=SnVXOOFeNY8jkD4g2DL2UvSx')
SET IDENTITY_INSERT [dbo].[TTestSettings] OFF
SET IDENTITY_INSERT [dbo].[TTestStatus] ON 

INSERT [dbo].[TTestStatus] ([id], [Status]) VALUES (1, N'Untested')
INSERT [dbo].[TTestStatus] ([id], [Status]) VALUES (2, N'Passed')
INSERT [dbo].[TTestStatus] ([id], [Status]) VALUES (3, N'Failed')
INSERT [dbo].[TTestStatus] ([id], [Status]) VALUES (4, N'Blocked')
INSERT [dbo].[TTestStatus] ([id], [Status]) VALUES (5, N'Retest')
SET IDENTITY_INSERT [dbo].[TTestStatus] OFF
SET IDENTITY_INSERT [dbo].[TTestTester] ON 

INSERT [dbo].[TTestTester] ([id], [ADID], [UserName], [password], [email], [salt], [samaccountname], [isApproved], [AxoSoftToken]) VALUES (1, N'bkresge', N'Brian Kresge', N'4BAB78F62F4B2A290CC4D64495D742CE65DB3EE754FD937DB3D5F6396579D09DD3360F10AD28125EBFD55FC45957F159765983C5DC9297F97596E588DD08D946', N'brian.kresge@gmail.com', N'VxlD1LA52MmQ3UXYqT8L/g==', NULL, 1, N'58dfb0e4-c727-4008-a03c-fe352bc747ce')
INSERT [dbo].[TTestTester] ([id], [ADID], [UserName], [password], [email], [salt], [samaccountname], [isApproved], [AxoSoftToken]) VALUES (2, N'nemmons', N'Mortimer McMuffin', N'66D4974BBD6702D418E9BBCE172BE843AD492C619E2BC8485039BBE71F2466DFACB0EB85CE9E010AAC3C0DE1002DEAD7C9D9FB4C8D87A3D70B65C18218CF12BA', N'brian.kresge@gmail.com', N'F1dH7hkHB5VHCnrqLI4xoA==', NULL, 1, NULL)
INSERT [dbo].[TTestTester] ([id], [ADID], [UserName], [password], [email], [salt], [samaccountname], [isApproved], [AxoSoftToken]) VALUES (3, N'kgockley', N'Elf Off', N'3E698A4D412BE08ABA9BE2EF716DDB3DF201E70470B9E24A36F7EACF9B5A9E8BE9978EE56AEBFC91F91548B0C0396745122140489892FFCF2E38A7F9AA1D4D99', N'brian.kresge@gmail.com', N'GVbAXbf75LnJoneotE2rtg==', NULL, 1, NULL)
INSERT [dbo].[TTestTester] ([id], [ADID], [UserName], [password], [email], [salt], [samaccountname], [isApproved], [AxoSoftToken]) VALUES (4, N'bkimmich', N'Rice Pudding', N'A483FEDD4BDFC072FEE3E9431222B454D0CF4A25C70D0272184A4E12C70FE9038415E45EA9B4BCB64306BEF8D7C1A3AEB7503A2306884B3161706818A497F81D', N'brian.kresge@gmail.com', N'YfdlyMr0voGmbcWPS1JCCw==', NULL, 1, NULL)
INSERT [dbo].[TTestTester] ([id], [ADID], [UserName], [password], [email], [salt], [samaccountname], [isApproved], [AxoSoftToken]) VALUES (5, N'DMARTIN', N'Martin Chip', N'AD9B7A95A1689E034393454CC1768DB07199BA49BC77C9B85C495364A15F5248592A46601E5704E48B8784DBF7A6D1BCE2314E907604F227ABC96FB487B0BB04', N'brian.kresge@gmail.com', N'A9i0fd9icN57v7SrloFlhg==', NULL, 1, NULL)
INSERT [dbo].[TTestTester] ([id], [ADID], [UserName], [password], [email], [salt], [samaccountname], [isApproved], [AxoSoftToken]) VALUES (6, N'TLORCH', N'Timmy Cleaver', N'5EB20FFBFBAA0B86E74BCF981158E0BE97BC505EE9DC047499C921F6D5BEE011F9215E57CDCB0E7706DA3E7EE274967A1CFD8776F7735B5C302EEDA3F9EEAE6B', N'brian.kresge@gmail.com', N'j4oqtF16R80U7TaGYvHoMg==', NULL, 1, NULL)
INSERT [dbo].[TTestTester] ([id], [ADID], [UserName], [password], [email], [salt], [samaccountname], [isApproved], [AxoSoftToken]) VALUES (7, N'TestUser', N'Test User', N'0AF7F0F37ABDEBCF03280B8000672F49B5BADFE5575C49A923192ED56828E758BF7D9749225CF7E6A1B6B3284E42FD4FD4509695D1ED678E7D54984514C9A13C', N'bk@bk-mp.com', N'4CYAlsE+yjWE5NpWEJ22vg==', NULL, 0, NULL)
INSERT [dbo].[TTestTester] ([id], [ADID], [UserName], [password], [email], [salt], [samaccountname], [isApproved], [AxoSoftToken]) VALUES (8, N'System', N'System Account', NULL, NULL, NULL, NULL, 1, NULL)
SET IDENTITY_INSERT [dbo].[TTestTester] OFF
SET IDENTITY_INSERT [dbo].[TTestType] ON 

INSERT [dbo].[TTestType] ([id], [Type]) VALUES (1, N'Functionality')
INSERT [dbo].[TTestType] ([id], [Type]) VALUES (2, N'Performance')
INSERT [dbo].[TTestType] ([id], [Type]) VALUES (3, N'Usability')
INSERT [dbo].[TTestType] ([id], [Type]) VALUES (4, N'Automated')
INSERT [dbo].[TTestType] ([id], [Type]) VALUES (5, N'Regression')
SET IDENTITY_INSERT [dbo].[TTestType] OFF
