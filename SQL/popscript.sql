
GO
--SET IDENTITY_INSERT [TTestPriorityType] ON 

INSERT INTO TTestPriorityType (id, PriorityName, PriorityRank) VALUES (1, 'High - Urgent', 1)
INSERT INTO TTestPriorityType (id, PriorityName, PriorityRank) VALUES (2, 'High', 2)
INSERT INTO TTestPriorityType (id, PriorityName, PriorityRank) VALUES (3, 'Medium', 3)
INSERT INTO TTestPriorityType (id, PriorityName, PriorityRank) VALUES (4, 'Low', 4)
--SET IDENTITY_INSERT [TTestPriorityType] OFF
--SET IDENTITY_INSERT [TTestSettings] ON 

INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (1, N'UseLDAP', N'false')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (2, N'AllowCaseDelete', N'true')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (3, N'MAILERDAEMONADDRESS', N'cftesttrack@cornerstoneoperations.com')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (4, N'AllowChat', N'true')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (5, N'AxoSoftIntegration', N'false')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (6, N'AxoSoftAuthentication', N'Authorization')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (7, N'AxoSoftClient_Id', N'9f8b89e1-e314-4685-a0fc-2ad85bef0350')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (8, N'AxoSoftClient_Secret', N'a92edd03-6fa0-44dc-aebc-b90ea1bb399c')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (9, N'AxoSoftRedirectURI', N'http://localhost/CFTestTrack/AxoSoftRedirect.cfm')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (10, N'AxoSoftExpiration', N'false')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (11, N'AxoSoftURL', N'https://cornerops.axosoft.com/')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (12, N'AxoSoftUseAPI', N'false')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (13, N'SlackIntegration', N'true')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (14, N'SlackAPIToken', N'xoxb-15570080624-enfYmo68URHDZ43Bq8sK4kCj')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (15, N'SlackBotChannel', N'C0F91JR9C')
INSERT [TTestSettings] ([id], [Setting], [SettingValue]) VALUES (16, N'SlackBotURL', N'https://bk-mp.slack.com/services/hooks/slackbot?token=SnVXOOFeNY8jkD4g2DL2UvSx')


INSERT INTO TTestStatus (id, Status) VALUES (1, 'Untested')
INSERT INTO TTestStatus (id, Status) VALUES (2, 'Passed')
INSERT INTO TTestStatus (id, Status) VALUES (3, 'Failed')
INSERT INTO TTestStatus (id, Status) VALUES (4, 'Blocked')
INSERT INTO TTestStatus (id, Status) VALUES (5, 'Retest')
--SET IDENTITY_INSERT [TTestStatus] OFF
--SET IDENTITY_INSERT [TTestTester] ON 

INSERT into TTestTester (id, ADID, UserName, password, email, salt, samaccountname, isApproved, AxoSoftToken) VALUES (2, 'mmuffi', 'Mortimer McMuffi', '66D4974BBD6702D418E9BBCE172BE843AD492C619E2BC8485039BBE71F2466DFACB0EB85CE9E010AAC3C0DE1002DEAD7C9D9FB4C8D87A3D70B65C18218CF12BA', 'brian.kresge@gmail.com', 'F1dH7hkHB5VHCnrqLI4xoA==', NULL, true, NULL);
INSERT into TTestTester (id, ADID, UserName, password, email, salt, samaccountname, isApproved, AxoSoftToken) VALUES (3, 'eoff', 'Elf Off', '3E698A4D412BE08ABA9BE2EF716DDB3DF201E70470B9E24A36F7EACF9B5A9E8BE9978EE56AEBFC91F91548B0C0396745122140489892FFCF2E38A7F9AA1D4D99', 'brian.kresge@gmail.com', 'GVbAXbf75LnJoneotE2rtg==', NULL, true, NULL);
INSERT into TTestTester (id, ADID, UserName, password, email, salt, samaccountname, isApproved, AxoSoftToken) VALUES (4, 'rpudding', 'Rice Pudding', 'A483FEDD4BDFC072FEE3E9431222B454D0CF4A25C70D0272184A4E12C70FE9038415E45EA9B4BCB64306BEF8D7C1A3AEB7503A2306884B3161706818A497F81D', 'brian.kresge@gmail.com', 'YfdlyMr0voGmbcWPS1JCCw==', NULL, true, NULL);
INSERT into TTestTester (id, ADID, UserName, password, email, salt, samaccountname, isApproved, AxoSoftToken) VALUES (5, 'mchip', 'Martin Chip', 'AD9B7A95A1689E034393454CC1768DB07199BA49BC77C9B85C495364A15F5248592A46601E5704E48B8784DBF7A6D1BCE2314E907604F227ABC96FB487B0BB04', 'brian.kresge@gmail.com', 'A9i0fd9icN57v7SrloFlhg==', NULL, true, NULL);
INSERT into TTestTester (id, ADID, UserName, password, email, salt, samaccountname, isApproved, AxoSoftToken) VALUES (6, 'tcleaver', 'Timmy Cleaver', '5EB20FFBFBAA0B86E74BCF981158E0BE97BC505EE9DC047499C921F6D5BEE011F9215E57CDCB0E7706DA3E7EE274967A1CFD8776F7735B5C302EEDA3F9EEAE6B', 'brian.kresge@gmail.com', 'j4oqtF16R80U7TaGYvHoMg==', NULL, true, NULL);
INSERT into TTestTester (id, ADID, UserName, password, email, salt, samaccountname, isApproved, AxoSoftToken) VALUES (7, 'TestUser', 'Test User', '0AF7F0F37ABDEBCF03280B8000672F49B5BADFE5575C49A923192ED56828E758BF7D9749225CF7E6A1B6B3284E42FD4FD4509695D1ED678E7D54984514C9A13C', 'bk@bk-mp.com', '4CYAlsE+yjWE5NpWEJ22vg==', NULL, false, NULL);
INSERT into TTestTester (id, ADID, UserName, password, email, salt, samaccountname, isApproved, AxoSoftToken) VALUES (8, 'System', 'System Account', NULL, NULL, NULL, NULL, true, NULL);

--SET IDENTITY_INSERT [TTestTester] OFF
--SET IDENTITY_INSERT [TTestType] ON 

INSERT INTO TTestType (id, Type) VALUES (1, 'Functionality');
INSERT INTO TTestType (id, Type) VALUES (2, 'Performance');
INSERT INTO TTestType (id, Type) VALUES (3, 'Usability');
INSERT INTO TTestType (id, Type) VALUES (4, 'Automated');
INSERT INTO TTestType (id, Type) VALUES (5, 'Regression');
--SET IDENTITY_INSERT [TTestType] OFF
