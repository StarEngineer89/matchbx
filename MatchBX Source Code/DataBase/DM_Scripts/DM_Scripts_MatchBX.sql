
--Purpose		: Data insertion to Table UserType
--Date			: 20 June 2018
--Created By	: Sanu Mohan

IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'UserType'))
BEGIN
	
	IF (NOT EXISTS (SELECT 1 FROM UserType WHERE UserTypeFlag = 'S'))
	BEGIN
		INSERT INTO UserType VALUES ('S','Get hired')
	END	
	IF (NOT EXISTS (SELECT 1 FROM UserType WHERE UserTypeFlag = 'P'))
	BEGIN
		INSERT INTO UserType VALUES ('P','Post a job')
	END	
	IF (NOT EXISTS (SELECT 1 FROM UserType WHERE UserTypeFlag = 'D'))
	BEGIN
		INSERT INTO UserType VALUES ('D','Get hired and post a job')
	END	
	IF (NOT EXISTS (SELECT 1 FROM UserType WHERE UserTypeFlag = 'A'))
	BEGIN
		INSERT INTO UserType VALUES ('A','Admin User')
	END
	
END

--Purpose		: Data insertion to Table JobCategory
--Date			: 25 June 2018
--Created By	: Sanu Mohan

IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobCategory'))
BEGIN
	
	IF (NOT EXISTS (SELECT 1 FROM JobCategory WHERE Category = 'Development'))
	BEGIN
		INSERT INTO JobCategory VALUES ('Development')
	END	
	IF (NOT EXISTS (SELECT 1 FROM JobCategory WHERE Category = 'Marketing'))
	BEGIN
		INSERT INTO JobCategory VALUES ('Marketing')
	END	
	IF (NOT EXISTS (SELECT 1 FROM JobCategory WHERE Category = 'Creative'))
	BEGIN
		INSERT INTO JobCategory VALUES ('Creative')
	END	
	IF (NOT EXISTS (SELECT 1 FROM JobCategory WHERE Category = 'WRITING'))
	BEGIN
		INSERT INTO JobCategory VALUES ('WRITING')
	END	
	IF (NOT EXISTS (SELECT 1 FROM JobCategory WHERE Category = 'ADMIN'))
	BEGIN
		INSERT INTO JobCategory VALUES ('ADMIN')
	END
	IF (NOT EXISTS (SELECT 1 FROM JobCategory WHERE Category = 'TOKEN SALE'))
	BEGIN
		INSERT INTO JobCategory VALUES ('TOKEN SALE')
	END
	IF (NOT EXISTS (SELECT 1 FROM JobCategory WHERE Category = 'TRANSLATION'))
	BEGIN
		INSERT INTO JobCategory VALUES ('TRANSLATION')
	END
	IF (NOT EXISTS (SELECT 1 FROM JobCategory WHERE Category = 'OTHER'))
	BEGIN
		INSERT INTO JobCategory VALUES ('OTHER')
	END	
	IF EXISTS(SELECT 1 FROM JobCategory WHERE JobCategoryId = 1 AND Category <> 'MARKETING')
	BEGIN
		UPDATE JobCategory SET Category = 'MARKETING' WHERE JobCategoryId = 1
	END	
	IF EXISTS(SELECT 1 FROM JobCategory WHERE JobCategoryId = 2 AND Category <> 'DEVELOPMENT')
	BEGIN
		UPDATE JobCategory SET Category = 'DEVELOPMENT' WHERE JobCategoryId = 2
	END	
	IF EXISTS(SELECT 1 FROM JobCategory WHERE JobCategoryId = 3 AND Category = 'CREATIVE')
	BEGIN
		UPDATE JobCategory SET Category = 'CREATIVE' WHERE JobCategoryId = 3
	END	
END


--Purpose		: Data insertion to Table TrendingTags
--Date			: 25 June 2018
--Created By	: Sanu Mohan

IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'TrendingTags'))
BEGIN
	
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Professional Editors' AND JobCategoryId = 4)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Professional Editors',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Professional Proofreaders & Copy Editors' AND JobCategoryId = 4)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Professional Proofreaders & Copy Editors',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Content Writer' AND JobCategoryId = 4)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Content Writer',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Article content writer' AND JobCategoryId = 4)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Article content writer',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Manage Community' AND JobCategoryId = 6)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Manage Community',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#White Paper' AND JobCategoryId = 6)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#White Paper',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Creativity' AND JobCategoryId = 6)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Creativity',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Marketing Stategy' AND JobCategoryId = 6)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Marketing Stategy',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#SEO SPECIALISTS' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#SEO SPECIALISTS',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Search engine marketers' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Search engine marketers',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#SOCIAL MEDIA MARKETERS' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#SOCIAL MEDIA MARKETERS',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#EMAIL MARKETERS' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#EMAIL MARKETERS',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#MARKETING STRATEGISTS' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#MARKETING STRATEGISTS',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#TELEMARKETERS ' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#TELEMARKETERS ',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#LEAD GENERATORS' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#LEAD GENERATORS',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Copy writing' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Copy writing',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#White Paper' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#White Paper',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Content Writing' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Content Writing',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Translation' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Legal' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Legal',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Programmer' AND JobCategoryId = 2)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Programmer',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Project Manager' AND JobCategoryId = 2)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Project Manager',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Cyber Security' AND JobCategoryId = 2)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Cyber Security',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Ethical Hacker' AND JobCategoryId = 2)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Ethical Hacker',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Accounting' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Accounting',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Financial Planning' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Financial Planning',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Human Resources' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Human Resources',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Management Consulting' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Management Consulting',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Other - Accounting & Consulting' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Other - Accounting & Consulting',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Graphic Design' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Graphic Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Illustration' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Illustration',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Logo Design & Branding' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Logo Design & Branding',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Photography' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Photography',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Presentations' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Presentations',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Video Production' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Video Production',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Voice Talent' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Voice Talent',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Other - Design & Creative' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Other - Design & Creative',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Microsoft Excel Professionals' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Microsoft Excel Professionals',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Customer Service Specialists' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Customer Service Specialists',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Microsoft Word Experts & Typists' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Microsoft Word Experts & Typists',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Internet Researchers' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Internet Researchers',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM TrendingTags WHERE Description = '#Virtual Office Assistants' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO TrendingTags VALUES ('#Virtual Office Assistants',5) 
	 END

END


--Purpose		: Data insertion to Table Skills
--Date			: 26 June 2018
--Created By	: Sanu Mohan

IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'Skills'))
BEGIN
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Creative Writing' AND JobCategoryId = 4)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Creative Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Content Writing' AND JobCategoryId = 4)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Content Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Blog Writing' AND JobCategoryId = 4)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Blog Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Article Writing' AND JobCategoryId = 4)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Article Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Social Media Manager' AND JobCategoryId = 6)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Social Media Manager',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Bounty Program Coordinator' AND JobCategoryId = 6)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Bounty Program Coordinator',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Community Moderator' AND JobCategoryId = 6)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Community Moderator',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Creative Writing' AND JobCategoryId = 6)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Creative Writing',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Marketing Strategy' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Marketing Strategy',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Search Engine Optimization (SEO)' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Search Engine Optimization (SEO)',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Web Design' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Web Design',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Conversion Rate Optimization' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Conversion Rate Optimization',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'WordPress' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('WordPress',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Coaching' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Business Coaching',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SEO Audit' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('SEO Audit',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Consulting' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Business Consulting',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Localization' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Localization',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'All Translation' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('All Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'General Translation' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('General Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Legal Translation' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Legal Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Medical Translation' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Medical Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Technical Translation' AND JobCategoryId = 7)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Technical Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Java' AND JobCategoryId = 2)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Java',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'NodeJS' AND JobCategoryId = 2)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('NodeJS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PHP' AND JobCategoryId = 2)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('PHP',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SQL' AND JobCategoryId = 2)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('SQL',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Planning' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Business Planning',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Modeling' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Business Modeling',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Financial Modeling' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Financial Modeling',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Startup Consulting' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Startup Consulting',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Analysis' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Business Analysis',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Financial Analysis' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Financial Analysis',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Management' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Business Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Financial Management' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Financial Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Financial Accounting' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Financial Accounting',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Certified Public Accountant (CPA)' AND JobCategoryId = 8)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Certified Public Accountant (CPA)',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Graphic Design' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Graphic Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Logo Design' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Logo Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Label and Package Design' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Label and Package Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Adobe Illustrator' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Adobe Illustrator',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Adobe Photoshop' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Adobe Photoshop',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Animation' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Animation',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Audio Production' AND JobCategoryId = 3)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Audio Production',3) 
	 END	 
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Technical Support' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Technical Support',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Customer Support' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Customer Support',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sales Management' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Sales Management',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Market Research' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Market Research',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Project Management' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Project Management',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Entry' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Data Entry',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Telemarketing' AND JobCategoryId = 5)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Telemarketing',5) 
	 END	
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ad Planning & Buying' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Ad Planning & Buying',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Advertising' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Advertising',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Affiliate Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Affiliate Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Airbnb' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Airbnb',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Analytics Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Analytics Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'ATS Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('ATS Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Brand Management' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Brand Management',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Brand Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Brand Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Branding' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Branding',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Bulk Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Bulk Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Channel Account Management' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Channel Account Management',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Channel Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Channel Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Classifieds Posting' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Classifieds Posting',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Cloud Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Cloud Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Content Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Content Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Conversion Rate Optimisation' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Conversion Rate Optimisation',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'CRM' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('CRM',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Datacenter Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Datacenter Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Digital Agency Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Digital Agency Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'eBay marketer' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('eBay marketer',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Email Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Email Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Emerging Accounts' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Emerging Accounts',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Enterprise Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Enterprise Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Enterprise Sales Management' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Enterprise Sales Management',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Etsy manager' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Etsy manager',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Facebook Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Facebook Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Field Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Field Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Field Sales Management' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Field Sales Management',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Financial Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Financial Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Adsense' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Google Adsense',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Adwords' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Google Adwords',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Healthcare Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Healthcare Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'HR Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('HR Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'IDM Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('IDM Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Inside Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Inside Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Internet Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Internet Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Internet Research' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Internet Research',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'ISV Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('ISV Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Journalist' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Journalist',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Keyword Research' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Keyword Research',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Leads' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Leads',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Life Science Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Life Science Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mailchimp sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Mailchimp sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mailwizz' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Mailwizz',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Market Research' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Market Research',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Marketing Strategy' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Marketing Strategy',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Media Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Media Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Medical Devices Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Medical Devices Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MLM marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('MLM marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mobile Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Mobile Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Network Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Network Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OEM Account Management' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('OEM Account Management',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OEM Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('OEM Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Pardot' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Pardot',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Payroll Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Payroll Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Periscope' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Periscope',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PPC Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('PPC Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Recruiting Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Recruiting Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Resellers' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Resellers',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Retail Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Retail Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SaaS Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('SaaS Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sales Account Management' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Sales Account Management',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sales Management' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Sales Management',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sales Promotion' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Sales Promotion',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Search Engine Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Search Engine Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Security Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Security Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Social Media Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Social Media Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Social media Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Social media Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Software Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Software Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Technology Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Technology Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Telecom Sales' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Telecom Sales',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Telemarketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Telemarketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Twitter Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Twitter Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Viral Marketing' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Viral Marketing',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Visual Merchandising' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('Visual Merchandising',1) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'WooCommerce' AND JobCategoryId = 1)) 
	 BEGIN 
		INSERT INTO Skills VALUES ('WooCommerce',1) 
	 END	 
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'AJAX development' AND JobCategoryId = 2))
	 BEGIN 
		INSERT INTO Skills VALUES ('AJAX development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ecommerce installer' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ecommerce installer',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Web Analytics' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Web Analytics',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'App tester' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('App tester',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'API' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('API',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'App Developer' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('App Developer',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Argus Monitoring Software' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Argus Monitoring Software',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Artificial Intelligence' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Artificial Intelligence',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Backend Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Backend Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Big Data Sales' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Big Data Sales',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'BigCommerce' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('BigCommerce',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Binary Analysis' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Binary Analysis',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Blockchain analyst' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Blockchain analyst',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Catalyst' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Business Catalyst',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Intelligence' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Business Intelligence',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'C Programming' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('C Programming',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'C# Programming' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('C# Programming',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'C++ Programming' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('C++ Programming',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Charts programming' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Charts programming',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Warehousing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Warehousing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Database Administration' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Database Administration',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Database Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Database Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Database Programming' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Database Programming',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Debugging' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Debugging',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Delphi' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Delphi',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Digital Marketing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Digital Marketing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Django' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Django',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Docker' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Docker',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Documentation' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Documentation',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Dojo' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Dojo',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'DOS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('DOS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'DotNetNuke' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('DotNetNuke',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Drawing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Drawing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Drupal' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Drupal',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Dynamics' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Dynamics',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Eclipse' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Eclipse',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'ECMAScript' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('ECMAScript',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'eCommerce' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('eCommerce',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'edX' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('edX',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Elasticsearch' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Elasticsearch',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'eLearning' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('eLearning',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Electronic Forms' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Electronic Forms',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Elixir' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Elixir',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Email Developer' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Email Developer',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Embedded Software' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Embedded Software',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ember.js' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ember.js',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Erlang' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Erlang',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ethereum' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ethereum',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Express JS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Express JS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Expression Engine' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Expression Engine',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ext JS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ext JS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'f#' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('f#',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Face Recognition' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Face Recognition',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Facebook API' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Facebook API',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'FileMaker' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('FileMaker',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Firefox' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Firefox',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Flask' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Flask',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Fortran' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Fortran',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Forum Software' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Forum Software',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'FreelancerAPI' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('FreelancerAPI',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'FreeSwitch' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('FreeSwitch',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Frontend Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Frontend Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Full Stack Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Full Stack Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Game Consoles' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Game Consoles',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Game Design' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Game Design',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Game Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Game Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'GameSalad' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('GameSalad',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Gamification' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Gamification',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Geographical Information System (GIS)' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Geographical Information System (GIS)',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'GIMP' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('GIMP',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Git' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Git',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Golang' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Golang',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Analytics' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Analytics',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google App Engine' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google App Engine',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Cardboard' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Cardboard',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Chrome' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Chrome',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Cloud Storage' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Cloud Storage',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Earth' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Earth',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Maps API' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Maps API',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Plus' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Plus',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Web Toolkit' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Web Toolkit',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Webmaster Tools' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Webmaster Tools',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google Website Optimizer' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google Website Optimizer',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'GoPro' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('GoPro',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'GPGPU' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('GPGPU',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Grails' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Grails',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Graphics Programming' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Graphics Programming',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Grease Monkey' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Grease Monkey',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Growth Hacking' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Growth Hacking',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Grunt' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Grunt',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'GTK+' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('GTK+',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Hadoop' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Hadoop',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Handlebars.js' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Handlebars.js',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Haskell' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Haskell',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'HBase' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('HBase',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Heroku' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Heroku',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Hive' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Hive',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'HomeKit' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('HomeKit',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'HP Openview' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('HP Openview',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'HTC Vive' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('HTC Vive',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'HTML' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('HTML',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'HTML5' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('HTML5',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'iBeacon' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('iBeacon',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'IBM Bluemix' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('IBM Bluemix',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'IBM BPM' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('IBM BPM',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'IBM Tivoli' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('IBM Tivoli',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'IBM Websphere Transformation Tool' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('IBM Websphere Transformation Tool',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'IIS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('IIS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Instagram' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Instagram',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Instagram API' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Instagram API',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Internet Security' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Internet Security',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Interspire' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Interspire',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ionic Framework' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ionic Framework',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'iOS Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('iOS Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'ITIL' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('ITIL',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'J2EE' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('J2EE',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Jabber' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Jabber',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Java' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Java',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Java ME' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Java ME',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Java Spring' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Java Spring',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'JavaFX' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('JavaFX',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Javascript' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Javascript',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'JD Edwards CNC' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('JD Edwards CNC',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Jinja2' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Jinja2',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Joomla' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Joomla',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'jqGrid' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('jqGrid',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'jQuery / Prototype' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('jQuery / Prototype',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'JSON' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('JSON',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'JSP' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('JSP',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Julia Language' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Julia Language',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'JUnit' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('JUnit',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Kinect' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Kinect',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Knockout.js' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Knockout.js',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'LabVIEW' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('LabVIEW',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Laravel' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Laravel',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Leap Motion SDK' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Leap Motion SDK',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Learning Management Systems (LMS)' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Learning Management Systems (LMS)',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'LESS/Sass/SCSS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('LESS/Sass/SCSS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Link Building' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Link Building',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Linkedin' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Linkedin',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'LINQ' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('LINQ',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Linux' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Linux',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Lisp' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Lisp',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'LiveCode' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('LiveCode',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Lotus Notes' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Lotus Notes',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Lua' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Lua',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Lucene' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Lucene',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mac OS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Mac OS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Magento' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Magento',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Magic Leap' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Magic Leap',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Map Reduce' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Map Reduce',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MapKit' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MapKit',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MariaDB' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MariaDB',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Metatrader' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Metatrader',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MeteorJS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MeteorJS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Microsoft Expression' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Microsoft Expression',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Microsoft Hololens' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Microsoft Hololens',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Microsoft SQL Server' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Microsoft SQL Server',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Microsoft Visio' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Microsoft Visio',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Minitab' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Minitab',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MMORPG' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MMORPG',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mobile App Testing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Mobile App Testing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MODx' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MODx',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MonetDB' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MonetDB',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Moodle' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Moodle',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Moz' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Moz',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MQTT' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MQTT',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MVC' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MVC',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MySpace' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MySpace',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MySQL' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MySQL',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Netbeans' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Netbeans',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Network Administration' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Network Administration',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Nginx' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Nginx',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ning' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ning',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'node.js' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('node.js',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'NoSQL Couch & Mongo' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('NoSQL Couch & Mongo',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OAuth' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OAuth',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Object Oriented Programming (OOP)' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Object Oriented Programming (OOP)',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Objective C' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Objective C',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OCR' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OCR',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Oculus Mobile SDK' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Oculus Mobile SDK',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Oculus Rift' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Oculus Rift',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Odoo' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Odoo',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Open Cart' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Open Cart',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Open Journal Systems' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Open Journal Systems',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenBravo' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenBravo',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenCL' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenCL',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenCV' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenCV',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenGL' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenGL',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenSceneGraph' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenSceneGraph',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenSSL' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenSSL',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenStack' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenStack',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenVMS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenVMS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenVPN' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenVPN',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OpenVZ' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OpenVZ',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Oracle' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Oracle',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'OSCommerce' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('OSCommerce',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Papiamento' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Papiamento',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Parallax Scrolling' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Parallax Scrolling',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Parallel Processing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Parallel Processing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Parallels Automation' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Parallels Automation',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Parallels Desktop' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Parallels Desktop',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Pascal' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Pascal',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Pattern Matching' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Pattern Matching',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Payment Gateway Integration' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Payment Gateway Integration',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PayPal API' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PayPal API',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Paytrace' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Paytrace',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PEGA PRPC' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PEGA PRPC',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PencilBlue CMS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PencilBlue CMS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Penetration Testing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Penetration Testing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Pentaho' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Pentaho',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Perl' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Perl',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PhoneGap' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PhoneGap',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Photoshop Coding' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Photoshop Coding',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PHP' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PHP',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'phpFox' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('phpFox',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'phpMyAdmin' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('phpMyAdmin',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PhpNuke' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PhpNuke',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PICK Multivalue DB' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PICK Multivalue DB',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Pinterest' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Pinterest',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Plesk' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Plesk',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Plugin' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Plugin',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PostgreSQL' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PostgreSQL',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Powershell' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Powershell',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Prestashop' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Prestashop',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Programming' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Programming',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Prolog' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Prolog',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Protoshare' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Protoshare',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Puppet' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Puppet',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Push Notification' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Push Notification',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Python' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Python',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'QlikView' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('QlikView',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Qt' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Qt',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Qualtrics Survey Platform' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Qualtrics Survey Platform',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'QuickBase' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('QuickBase',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'R Programming Language' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('R Programming Language',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Racket' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Racket',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'RapidWeaver' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('RapidWeaver',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Raspberry Pi' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Raspberry Pi',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ray-tracing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ray-tracing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'React.js' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('React.js',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'REALbasic' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('REALbasic',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Red Hat' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Red Hat',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Redis' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Redis',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Redshift' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Redshift',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Regular Expressions' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Regular Expressions',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'RESTful' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('RESTful',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Rocket Engine' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Rocket Engine',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'RSS' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('RSS',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ruby' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ruby',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ruby on Rails' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ruby on Rails',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sails.js' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sails.js',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Salesforce App Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Salesforce App Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Samsung Accessory SDK' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Samsung Accessory SDK',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SAP' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SAP',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Scala' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Scala',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Scheme' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Scheme',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Scikit Learn' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Scikit Learn',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Scrapy' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Scrapy',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Script Install' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Script Install',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Scripting' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Scripting',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Scrum' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Scrum',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Scrum Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Scrum Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Selenium Webdriver' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Selenium Webdriver',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sencha / YahooUI' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sencha / YahooUI',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SEO' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SEO',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SEO Auditing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SEO Auditing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sharepoint' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sharepoint',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Shell Script' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Shell Script',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Shopify' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Shopify',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Shopping Carts' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Shopping Carts',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Siebel' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Siebel',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Silverlight' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Silverlight',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sketching' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sketching',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Smarty PHP' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Smarty PHP',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Snapchat' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Snapchat',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Social Engine' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Social Engine',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Social Media Management' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Social Media Management',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Social Networking' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Social Networking',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Socket IO' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Socket IO',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Software Architecture' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Software Architecture',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Software Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Software Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Software Testing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Software Testing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Solaris' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Solaris',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Spark' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Spark',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sphinx' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sphinx',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Splunk' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Splunk',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SPSS Statistics' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SPSS Statistics',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SQL' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SQL',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SQLite' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SQLite',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Squarespace' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Squarespace',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Squid Cache' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Squid Cache',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SSIS (SQL Server Integration Services)' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SSIS (SQL Server Integration Services)',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Steam API' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Steam API',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Storage Area Networks' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Storage Area Networks',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Stripe' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Stripe',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Subversion' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Subversion',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SugarCRM' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SugarCRM',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SVG' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SVG',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Swift' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Swift',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Swing (Java)' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Swing (Java)',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Symfony PHP' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Symfony PHP',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'System Admin' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('System Admin',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'T-SQL (Transact Structures Query Language)' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('T-SQL (Transact Structures Query Language)',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Tableau' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Tableau',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Tally Definition Language' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Tally Definition Language',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'TaoBao API' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('TaoBao API',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'TestStand' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('TestStand',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Tibco Spotfire' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Tibco Spotfire',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Titanium' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Titanium',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Tizen SDK for Wearables' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Tizen SDK for Wearables',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Tumblr' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Tumblr',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Twitter' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Twitter',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Twitter API' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Twitter API',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Typescript' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Typescript',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Typing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Typing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'TYPO3' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('TYPO3',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ubuntu' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ubuntu',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Umbraco' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Umbraco',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'UML Design' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('UML Design',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Underscore.js' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Underscore.js',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Unity 3D' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Unity 3D',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'UNIX' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('UNIX',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Usability Testing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Usability Testing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'User Interface / IA' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('User Interface / IA',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Varnish Cache' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Varnish Cache',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Web Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Web Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Web Hosting' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Web Hosting',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Web Scraping' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Web Scraping',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Web Security' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Web Security',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Website Analytics' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Website Analytics',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Website Management' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Website Management',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Website Testing' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Website Testing',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mobile App Development' AND JobCategoryId = 2))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Mobile App Development',2) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'General Translation' AND JobCategoryId = 7))
	 BEGIN 
		INSERT INTO Skills VALUES ('General Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Legal Translation' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Legal Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Medical Translation' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Medical Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Technical Translation' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Technical Translation',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Afrikaans' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Afrikaans',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Albanian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Albanian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Arabic' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Arabic',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Basque' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Basque',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Bengali' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Bengali',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Bosnian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Bosnian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Bulgarian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Bulgarian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Catalan' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Catalan',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Croatian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Croatian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Czech' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Czech',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Danish' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Danish',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Dari' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Dari',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Dutch' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Dutch',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'English (UK)' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('English (UK)',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'English (US)' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('English (US)',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'English Grammar' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('English Grammar',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'English Spelling' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('English Spelling',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Estonian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Estonian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Filipino' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Filipino',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Finnish' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Finnish',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'French' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('French',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'French (Canadian)' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('French (Canadian)',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'German' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('German',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Greek' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Greek',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Hebrew' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Hebrew',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Hindi' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Hindi',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Hungarian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Hungarian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Indonesian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Indonesian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Interpreter' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Interpreter',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Italian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Italian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Japanese' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Japanese',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Kannada' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Kannada',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Korean' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Korean',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Latvian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Latvian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Lithuanian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Lithuanian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Macedonian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Macedonian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Malay' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Malay',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Malayalam' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Malayalam',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Maltese' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Maltese',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Norwegian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Norwegian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Poet' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Poet',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Polish' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Polish',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Portuguese' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Portuguese',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Portuguese (Brazil)' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Portuguese (Brazil)',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Punjabi' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Punjabi',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Romanian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Romanian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Russian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Russian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Serbian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Serbian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Simplified Chinese (China)' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Simplified Chinese (China)',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Slovakian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Slovakian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Slovenian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Slovenian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Spanish' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Spanish',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Spanish (Spain)' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Spanish (Spain)',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Swedish' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Swedish',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Tamil' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Tamil',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Telugu' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Telugu',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Thai' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Thai',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Traditional Chinese (Hong Kong)' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Traditional Chinese (Hong Kong)',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Traditional Chinese (Taiwan)' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Traditional Chinese (Taiwan)',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Turkish' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Turkish',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ukrainian' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ukrainian',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Urdu' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Urdu',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Vietnamese' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Vietnamese',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Voice Artist' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Voice Artist',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Welsh' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Welsh',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Yiddish' AND JobCategoryId = 7))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Yiddish',7) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Account Management' AND JobCategoryId = 8))
	 BEGIN 
		INSERT INTO Skills VALUES ('Account Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Agronomy' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Agronomy',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Algorithm development' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Algorithm development',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Arduino' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Arduino',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Article Submission' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Article Submission',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Astrophysics' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Astrophysics',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Audit Manager' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Audit Manager',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'AutoCAD design' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('AutoCAD design',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Autotask' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Autotask',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Biology' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Biology',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Bookkeeping' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Bookkeeping',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'BPO' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('BPO',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Brain Storming' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Brain Storming',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Broadcast Engineering' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Broadcast Engineering',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Analysis' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Business Analysis',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Coaching' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Business Coaching',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Plans' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Business Plans',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'CAD/CAM' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('CAD/CAM',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Call Center' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Call Center',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'CATIA' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('CATIA',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Chemical Engineering' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Chemical Engineering',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Christmas' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Christmas',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Circuit Design' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Circuit Design',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Civil Engineering' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Civil Engineering',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Clean Technology' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Clean Technology',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Climate Sciences' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Climate Sciences',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Compliance review' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Compliance review',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Construction Monitoring' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Construction Monitoring',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Contracts reports' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Contracts reports',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Cooking & Recipes' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Cooking & Recipes',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Cryptography' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Cryptography',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Crystal Reports' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Crystal Reports',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Customer Service' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Customer Service',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Customer Support' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Customer Support',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Analytics' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Analytics',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Cleansing' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Cleansing',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Entry' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Entry',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Extraction' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Extraction',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Mining' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Mining',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Processing' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Processing',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Science' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Science',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Scraping' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Scraping',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Dating' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Dating',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Desktop Support' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Desktop Support',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Digital Design' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Digital Design',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Econometrics' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Econometrics',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Education & Tutoring' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Education & Tutoring',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Email Handling' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Email Handling',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Employment Law' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Employment Law',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Engineering Drawing' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Engineering Drawing',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Entrepreneurship' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Entrepreneurship',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'ePub' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('ePub',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'ERP' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('ERP',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Event Planning' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Event Planning',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Excel' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Excel',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Excel Macros' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Excel Macros',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Excel VBA' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Excel VBA',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Financial Analysis' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Financial Analysis',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Finite Element Analysis' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Finite Element Analysis',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Fundraising' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Fundraising',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'General Office' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('General Office',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Health' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Health',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Helpdesk' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Helpdesk',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'History' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('History',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Home Design' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Home Design',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Human Resources' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Human Resources',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Human Sciences' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Human Sciences',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Imaging' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Imaging',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Industrial Engineering' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Industrial Engineering',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Instrumentation' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Instrumentation',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Insurance' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Insurance',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Intuit QuickBooks' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Intuit QuickBooks',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Inventory Management' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Inventory Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Investment Research' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Investment Research',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Legal Research' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Legal Research',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Legal Writing' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Legal Writing',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Life Coaching' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Life Coaching',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Linear Programming' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Linear Programming',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Linnworks Order Management' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Linnworks Order Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Machine Learning' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Machine Learning',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Management' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mathematics' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Mathematics',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Matlab and Mathematica' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Matlab and Mathematica',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mechanical Engineering' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Mechanical Engineering',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mechatronics' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Mechatronics',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Medical' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Medical',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Microbiology' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Microbiology',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Microsoft Office' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Microsoft Office',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Microsoft Outlook' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Microsoft Outlook',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'MYOB' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('MYOB',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Natural Language' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Natural Language',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Neural Networks' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Neural Networks',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Nintex Forms' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Nintex Forms',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Nintex Workflow' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Nintex Workflow',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Nutrition' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Nutrition',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Order Processing' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Order Processing',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Organizational Change Management' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Organizational Change Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Patents' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Patents',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Pattern Making' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Pattern Making',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Payroll' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Payroll',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PCB Layout' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PCB Layout',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PeopleSoft' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PeopleSoft',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Personal Development' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Personal Development',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Phone Support' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Phone Support',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Physics' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Physics',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PLC & SCADA' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PLC & SCADA',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Procurement' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Procurement',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Product Management' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Product Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Project Management' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Project Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Project Scheduling' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Project Scheduling',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Property Development' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Property Development',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Property Law' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Property Law',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Property Management' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Property Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Psychology advice' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Psychology advice',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Public Relations' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Public Relations',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Qualitative Research' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Qualitative Research',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Recruitment' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Recruitment',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Risk Management' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Risk Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Salesforce.com' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Salesforce.com',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Startups' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Startups',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Statistical Analysis' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Statistical Analysis',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Structural Engineering design' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Structural Engineering design',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Surfboard Design' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Surfboard Design',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Tax Law' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Tax Law',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Technical Support' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Technical Support',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Telephone Handling' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Telephone Handling',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Time Management' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Time Management',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Training' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Training',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Transcription' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Transcription',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Troubleshooting' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Troubleshooting',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Unit4 Business World' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Unit4 Business World',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Valuation & Appraisal' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Valuation & Appraisal',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Video Upload' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Video Upload',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Visa / Immigration planner' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Visa / Immigration planner',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Web Search' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Web Search',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Weddings planning' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Weddings planning',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Xero' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Xero',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Career Advisor' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Career Advisor',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Financial Advisor' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Financial Advisor',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Fitness Advisor' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Fitness Advisor',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Health Advisor' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Health Advisor',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Legal Consultant' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Legal Consultant',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Legal Consultant' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Legal Consultant',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Parenting Advisor' AND JobCategoryId = 8))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Parenting Advisor',8) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = '2D Animation' AND JobCategoryId = 3))
	 BEGIN 
		INSERT INTO Skills VALUES ('2D Animation',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = '360-degree video animation' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('360-degree video animation',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = '3D Animation' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('3D Animation',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = '3D Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('3D Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = '3D Model Maker' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('3D Model Maker',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = '3D Modeling' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('3D Modeling',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = '3D Rendering' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('3D Rendering',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = '3ds Max maker' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('3ds Max maker',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Action Script writer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Action Script writer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Adobe Dreamweaver developer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Adobe Dreamweaver developer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Adobe Fireworks' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Adobe Fireworks',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Adobe Flash developer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Adobe Flash developer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Adobe InDesign' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Adobe InDesign',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Adobe Lightroom designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Adobe Lightroom designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Adobe LiveCycle Designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Adobe LiveCycle Designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Advertisement Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Advertisement Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'After Effects producer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('After Effects producer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Album designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Album designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Animation' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Animation',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'App Designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('App Designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Apple Compressor' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Apple Compressor',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Apple Logic Pro' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Apple Logic Pro',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Apple Motion' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Apple Motion',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Arts & Crafts designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Arts & Crafts designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Audio Production' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Audio Production',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Audio Services' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Audio Services',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Autodesk Inventor' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Autodesk Inventor',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Autodesk Revit' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Autodesk Revit',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Autodesk Sketchbook Pro' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Autodesk Sketchbook Pro',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Axure producer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Axure producer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Banner Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Banner Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Blog Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Blog Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Book Artist' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Book Artist',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Bootstrap' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Bootstrap',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Brochure Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Brochure Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Building Architecture' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Building Architecture',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Card Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Business Card Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Cards' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Business Cards',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Capture NX2' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Capture NX2',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Caricature & Cartoons' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Caricature & Cartoons',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'CGI designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('CGI designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Cinema 4D designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Cinema 4D designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Commercials designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Commercials designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Concept Art designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Concept Art designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Concept Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Concept Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Corel Painter' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Corel Painter',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Corporate Identity' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Corporate Identity',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Covers & Packaging' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Covers & Packaging',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Creative Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Creative Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'CSSDesigner' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('CSSDesigner',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Digital Designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Digital Designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'eLearning Designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('eLearning Designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Fashion Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Fashion Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Fashion Modeling' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Fashion Modeling',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Filmmaking' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Filmmaking',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Final Cut Pro' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Final Cut Pro',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Finale / Sibelius' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Finale / Sibelius',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Flash 3D animation' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Flash 3D animation',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Flash Animation' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Flash Animation',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Flex designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Flex designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Flow Charts' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Flow Charts',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Flyer Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Flyer Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Format & Layout' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Format & Layout',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Furniture Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Furniture Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'GarageBand designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('GarageBand designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Google SketchUp' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Google SketchUp',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Graphic Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Graphic Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Icon Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Icon Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Illustration' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Illustration',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Illustrator' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Illustrator',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Image Processing' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Image Processing',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'iMovie producer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('iMovie producer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Industrial Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Industrial Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Infographics designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Infographics designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Instagram Marketing' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Instagram Marketing',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Interior Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Interior Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Invitation card Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Invitation card Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'JDF' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('JDF',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Kinetic Typography' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Kinetic Typography',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Label Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Label Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Landing Pages' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Landing Pages',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Logo Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Logo Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Makerbot producer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Makerbot producer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Merchandise designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Merchandise designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Maya designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Maya designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Mobile graphics designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Mobile graphics designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Motion Graphics' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Motion Graphics',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Music' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Music',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Oil painter' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Oil painter',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Package Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Package Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Photo Editing' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Photo Editing',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Photo Restoration' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Photo Restoration',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Photo Retouching' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Photo Retouching',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Photography' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Photography',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Photoshop' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Photoshop',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Photoshop Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Photoshop Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Post-Production' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Post-Production',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Poster Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Poster Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Pre-production' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Pre-production',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Presentations' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Presentations',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Prezi artist' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Prezi artist',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Print artist' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Print artist',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PSD to HTML producer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PSD to HTML producer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'PSD2CMS producer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('PSD2CMS producer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'QuarkXPress' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('QuarkXPress',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Responsive Web Designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Responsive Web Designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Shopify Templates designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Shopify Templates designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sign Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sign Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Social media designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Social media designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sound Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sound Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Stationery Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Stationery Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sticker Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sticker Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sketch artist' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sketch artist',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Storyboard artist' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Storyboard artist',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'T-Shirts designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('T-Shirts designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Tattoo Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Tattoo Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Tekla Structures' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Tekla Structures',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Templates' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Templates',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Typography' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Typography',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'User Experience Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('User Experience Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'User Interface Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('User Interface Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Vectorization' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Vectorization',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Vehicle Signage' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Vehicle Signage',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Video Broadcasting' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Video Broadcasting',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Video Editing' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Video Editing',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Video Production' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Video Production',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Video Services' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Video Services',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Videography' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Videography',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'VideoScribe' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('VideoScribe',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Visual Arts' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Visual Arts',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Voice Talent' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Voice Talent',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Website Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Website Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Wireframes' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Wireframes',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Word designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Word designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Yahoo! Store Design' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Yahoo! Store Design',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Zbrush designer' AND JobCategoryId = 3))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Zbrush designer',3) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Academic Writing' AND JobCategoryId = 4))
	 BEGIN 
		INSERT INTO Skills VALUES ('Academic Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Apple iBooks Author' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Apple iBooks Author',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Article Rewriting' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Article Rewriting',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Article Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Article Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Blogging' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Blogging',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Blog Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Blog Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Book Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Book Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Business Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Business Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Cartography & Maps' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Cartography & Maps',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Catch Phrases' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Catch Phrases',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Communications' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Communications',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Content Strategy' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Content Strategy',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Content Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Content Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Copy Editing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Copy Editing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Copy Typing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Copy Typing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Copywriting' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Copywriting',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Cover letter writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Cover letter writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Creative Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Creative Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'EBooks writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('EBooks writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Editing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Editing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Editorial Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Editorial Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Essay Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Essay Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Fiction writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Fiction writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Financial Research' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Financial Research',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Forum Posting' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Forum Posting',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Ghostwriting' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Ghostwriting',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Grant Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Grant Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'LaTeX writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('LaTeX writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Legal Writer' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Legal Writer',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Medical Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Medical Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Newsletters' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Newsletters',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Online Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Online Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Poetry writer' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Poetry writer',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Powerpoint presenter' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Powerpoint presenter',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Press Releases writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Press Releases writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Product Descriptions writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Product Descriptions writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Proofreading' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Proofreading',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Proposal/Bid Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Proposal/Bid Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Publishing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Publishing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Report Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Report Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Research' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Research',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Research Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Research Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Resumes' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Resumes',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Reviews writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Reviews writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Screenwriting' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Screenwriting',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'SEO Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('SEO Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Short Stories' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Short Stories',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Slogans writer' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Slogans writer',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Speech Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Speech Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Technical Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Technical Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Translation' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Translation',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Travel Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Travel Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Wikipedia writer' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Wikipedia writer',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Word Processing Writing' AND JobCategoryId = 4))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Word Processing Writing',4) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Technical Support' AND JobCategoryId = 5))
	 BEGIN 
		INSERT INTO Skills VALUES ('Technical Support',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Customer Support' AND JobCategoryId = 5))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Customer Support',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Sales Management' AND JobCategoryId = 5))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Sales Management',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Market Research' AND JobCategoryId = 5))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Market Research',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Project Management' AND JobCategoryId = 5))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Project Management',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Data Entry' AND JobCategoryId = 5))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Data Entry',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Telemarketing' AND JobCategoryId = 5))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Telemarketing',5) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Social Media Manager' AND JobCategoryId = 6))
	 BEGIN 
		INSERT INTO Skills VALUES ('Social Media Manager',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Bounty Program Coordinator' AND JobCategoryId = 6))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Bounty Program Coordinator',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Community Moderator' AND JobCategoryId = 6))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Community Moderator',6) 
	 END
	 IF (NOT EXISTS (SELECT 1 FROM Skills WHERE Description = 'Creative Writing' AND JobCategoryId = 6))
	 BEGIN 
		 INSERT INTO Skills VALUES ('Creative Writing',6) 
	 END
END

--Purpose		: Data insertion to Table JobReferance
--Date			: 26 June 2018
--Created By	: Sanu Mohan

IF (NOT EXISTS (SELECT 1 FROM JobReferance))
BEGIN
	INSERT INTO JobReferance VALUES (3000)
END

--Purpose		: Data insertion to Table JobStatusMaster
--Date			: 31 July 2018
--Created By	: Sanu Mohan

IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobStatusMaster'))
BEGIN
	
	IF (NOT EXISTS (SELECT 1 FROM JobStatusMaster WHERE JobStatusFlag = 'P'))
	BEGIN
		INSERT INTO JobStatusMaster VALUES ('P','Posted')
	END	
	IF (NOT EXISTS (SELECT 1 FROM JobStatusMaster WHERE JobStatusFlag = 'B'))
	BEGIN
		INSERT INTO JobStatusMaster VALUES ('B','Bid')
	END	
	IF (NOT EXISTS (SELECT 1 FROM JobStatusMaster WHERE JobStatusFlag = 'A'))
	BEGIN
		INSERT INTO JobStatusMaster VALUES ('A','Assigned')
	END
	IF (NOT EXISTS (SELECT 1 FROM JobStatusMaster WHERE JobStatusFlag = 'C'))
	BEGIN
		INSERT INTO JobStatusMaster VALUES ('C','Completed')
	END	
	
END


--Purpose		: Data insertion to Table EmailPreference
--Date			: 31 July 2018
--Created By	: Sanu Mohan

IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'EmailPreference'))
BEGIN
	
	IF (NOT EXISTS (SELECT 1 FROM EmailPreference WHERE Description = 'Marketing emails'))
	BEGIN
		INSERT INTO EmailPreference VALUES ('Marketing emails')
	END	
	IF (NOT EXISTS (SELECT 1 FROM EmailPreference WHERE Description = 'Job emails'))
	BEGIN
		INSERT INTO EmailPreference VALUES ('Job emails')
	END	
	IF (NOT EXISTS (SELECT 1 FROM EmailPreference WHERE Description = 'Direct message'))
	BEGIN
		INSERT INTO EmailPreference VALUES ('Direct message')
	END
	IF (NOT EXISTS (SELECT 1 FROM EmailPreference WHERE Description = 'New notification'))
	BEGIN
		INSERT INTO EmailPreference VALUES ('New notification')
	END
	IF (NOT EXISTS (SELECT 1 FROM EmailPreference WHERE Description = 'When you get a bid'))
	BEGIN
		INSERT INTO EmailPreference VALUES ('When you get a bid')
	END	
	
END


--Purpose		: Data insertion to Table UserBlocking
--Date			: 01 Aug 2018
--Created By	: Sanu Mohan

IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'UserBlocking'))
BEGIN
	
	IF (NOT EXISTS (SELECT 1 FROM UserBlocking WHERE Reason = 'Spammer'))
	BEGIN
		INSERT INTO UserBlocking VALUES ('Spammer')
	END	
	IF (NOT EXISTS (SELECT 1 FROM UserBlocking WHERE Reason = 'Long term Inactive'))
	BEGIN
		INSERT INTO UserBlocking VALUES ('Long term Inactive')
	END	
	IF (NOT EXISTS (SELECT 1 FROM UserBlocking WHERE Reason = 'Compliance Issue'))
	BEGIN
		INSERT INTO UserBlocking VALUES ('Compliance Issue')
	END
	IF (NOT EXISTS (SELECT 1 FROM UserBlocking WHERE Reason = 'Job related conflict'))
	BEGIN
		INSERT INTO UserBlocking VALUES ('Job related conflict')
	END
	IF (NOT EXISTS (SELECT 1 FROM UserBlocking WHERE Reason = 'Suspected Hacker'))
	BEGIN
		INSERT INTO UserBlocking VALUES ('Suspected Hacker')
	END	
	
END


--Purpose		: Data insertion to Table JobCancellation
--Date			: 07 Aug 2018
--Created By	: Sanu Mohan

--IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobCancellation'))
--BEGIN	
--	IF (NOT EXISTS (SELECT 1 FROM JobCancellation WHERE Reason = 'Bad Description'))
--	BEGIN
--		INSERT INTO JobCancellation VALUES ('Bad Description')
--	END	
--	IF (NOT EXISTS (SELECT 1 FROM JobCancellation WHERE Reason = 'Wrong Category Allocation'))
--	BEGIN
--		INSERT INTO JobCancellation VALUES ('Wrong Category Allocation')
--	END	
--	IF (NOT EXISTS (SELECT 1 FROM JobCancellation WHERE Reason = 'Wrong Skills Associated'))
--	BEGIN
--		INSERT INTO JobCancellation VALUES ('Wrong Skills Associated')
--	END
--	IF (NOT EXISTS (SELECT 1 FROM JobCancellation WHERE Reason = 'Budget amount unreasonable'))
--	BEGIN
--		INSERT INTO JobCancellation VALUES ('Budget amount unreasonable')
--	END	
--END

--Purpose		: Data updation in Table TransactionDetail
--Date			: 13 Oct 2018
--Created By	: Sanu Mohan

IF EXISTS(SELECT 1 FROM TransactionDetail WHERE ProcessType = 'A' AND ISNULL(Address,'') = '')
BEGIN
	UPDATE TransactionDetail SET Address = Hash,Hash = '' WHERE ISNULL(Address,'') = '' AND ProcessType = 'A'
END

--Purpose		: Data updation in Table JobCancellation
--Date			: 07 Nov 2018
--Created By	: Sanu Mohan

IF (EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE  TABLE_NAME = 'JobCancellation'))
BEGIN	
	IF (EXISTS (SELECT 1 FROM JobCancellation WHERE Reason = 'Bad Description'))
	BEGIN
		UPDATE JobCancellation SET Reason = 'Insufficient information' WHERE Reason ='Bad Description'		
	END	
	IF (EXISTS (SELECT 1 FROM JobCancellation WHERE Reason = 'Wrong Category Allocation'))
	BEGIN
		UPDATE JobCancellation SET Reason = 'Incorrect category allocation' WHERE Reason ='Wrong Category Allocation'		
	END	
	IF (EXISTS (SELECT 1 FROM JobCancellation WHERE Reason = 'Wrong Skills Associated'))
	BEGIN
		UPDATE JobCancellation SET Reason = 'Incorrect skills associated' WHERE Reason ='Wrong Skills Associated'		
	END	
END

--Purpose		: Data updation in Table TrendingTags
--Date			: 07 Nov 2018
--Created By	: Sanu Mohan

IF (EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TrendingTags' AND COLUMN_NAME = 'TagType'))
BEGIN
	UPDATE TrendingTags SET TagType = 'S' WHERE TagType IS NULL	
END
