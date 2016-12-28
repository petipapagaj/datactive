CREATE TYPE [Datactive].[HashVersion] AS TABLE
(
[TableName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PK] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[md5] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
