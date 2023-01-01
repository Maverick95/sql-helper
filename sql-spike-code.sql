-- Query to return valid tables.

SELECT			Id = TAB.[object_id],
				[Schema] = SCH.[name],
				[Name] = TAB.[name]
FROM			[sys].[schemas] SCH
INNER JOIN		[sys].[database_principals] DPR
	ON			DPR.[principal_id] = SCH.[principal_id]
INNER JOIN		[sys].[tables] TAB
	ON			TAB.[schema_id] = SCH.[schema_id]
WHERE			DPR.[name] IN ('dbo')
AND				SCH.[name] NOT IN ('dbo','tSQLt')
AND				TAB.[temporal_type_desc] NOT IN ('HISTORY_TABLE')
ORDER BY		TAB.[object_id];

-- Query to return valid fields.

SELECT			TableId = [TAB].[object_id],
				ColumnId = ACO.column_id,
				[Name] = ACO.[name],
				[Type] = TYP.[name],
				Nullable = ACO.is_nullable
FROM			[sys].[schemas] SCH
INNER JOIN		[sys].[database_principals] DPR
	ON			DPR.[principal_id] = SCH.[principal_id]
INNER JOIN		[sys].[tables] [TAB]
	ON			TAB.[schema_id] = SCH.[schema_id]
INNER JOIN		[sys].[all_columns] ACO
	ON			ACO.[object_id] = TAB.[object_id]
INNER JOIN		[sys].[types] TYP
	ON			TYP.system_type_id = ACO.system_type_id
AND				TYP.user_type_id = ACO.user_type_id
WHERE			DPR.[name] IN ('dbo')
AND				SCH.[name] NOT IN ('dbo','tSQLt')
AND				TAB.[temporal_type_desc] NOT IN ('HISTORY_TABLE')
ORDER BY		TAB.[object_id],		
				ACO.column_id;

-- Query to return constraint fields.

SELECT			Id = FKS.[object_id],
				TargetTableId = FKC.parent_object_id,
				SourceTableId = FKC.referenced_object_id,
				TargetColumn = FKC.parent_column_id,
				SourceColumn = FKC.referenced_column_id
FROM			[sys].[schemas] SCH
INNER JOIN		[sys].[database_principals] DPR
	ON			DPR.[principal_id] = SCH.[principal_id]
INNER JOIN		[sys].[tables] TAB
	ON			TAB.[schema_id] = SCH.[schema_id]
INNER JOIN		[sys].[foreign_keys] FKS
	ON			FKS.[parent_object_id] = TAB.[object_id]
INNER JOIN		[sys].[foreign_key_columns] FKC
	ON			FKC.constraint_object_id = FKS.[object_id]
WHERE			DPR.[name] IN ('dbo')
AND				SCH.[name] NOT IN ('dbo','tSQLt')
AND				TAB.[temporal_type_desc] NOT IN ('HISTORY_TABLE')
ORDER BY		FKC.parent_object_id,
				FKC.referenced_object_id;

-- EXAMPLE OUTPUT

SELECT
[saas_LICENSE].*,
[saas_VENDOR].*
FROM [saas].[LICENSE] [saas_LICENSE]
INNER JOIN [saas].[CREDENTIALINFO] [saas_CREDENTIALINFO] ON [saas_CREDENTIALINFO].[credentialInfoId] = [saas_LICENSE].[CredentialInfoId]
INNER JOIN [saas].[TENANTALIAS] [saas_TENANTALIAS] ON [saas_TENANTALIAS].[TenantAliasId] = [saas_CREDENTIALINFO].[TenantAliasId]
INNER JOIN [saas].[VENDOR] [saas_VENDOR] ON [saas_VENDOR].[VendorId] = [saas_TENANTALIAS].[VendorUid]
