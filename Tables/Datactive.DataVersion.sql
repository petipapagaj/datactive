CREATE TABLE [Datactive].[DataVersion]
(
[Version] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GitReference] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetime] NULL,
[Data] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Datactive].[DataVersion] ADD CONSTRAINT [PK_Version] PRIMARY KEY CLUSTERED  ([Version]) ON [PRIMARY]
GO
