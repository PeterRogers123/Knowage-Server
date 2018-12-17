INSERT into SBI_DOMAINS (VALUE_ID, VALUE_CD, VALUE_NM, DOMAIN_CD, DOMAIN_NM,VALUE_DS, USER_IN) values ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'), 'Date', 'Date', 'DS_META_VALUE', 'Dataset Metadata Value', 'Dataset Metadata Value', '');
UPDATE hibernate_sequences SET next_val = (SELECT MAX(VALUE_ID) + 1 FROM SBI_DOMAINS) WHERE sequence_name = 'SBI_DOMAINS';

UPDATE SBI_FEDERATION_DEFINITION SET NAME = LABEL WHERE NAME IS NULL;
ALTER TABLE SBI_FEDERATION_DEFINITION MODIFY NAME VARCHAR(100) NOT NULL;

ALTER TABLE SBI_EXT_ROLES ADD COLUMN IS_PUBLIC BOOLEAN NULL;

ALTER TABLE SBI_DATA_SOURCE ADD COLUMN JDBC_ADVANCED_CONFIGURATION VARCHAR(4000) AFTER WRITE_DEFAULT;

INSERT into SBI_DOMAINS (VALUE_ID, VALUE_CD, VALUE_NM, DOMAIN_CD, DOMAIN_NM,VALUE_DS, USER_IN) values ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'), 'Solr', 'SbiSolrDataSet', 'DATA_SET_TYPE', 'Data Set Type', 'SbiSolrDataSet', '');
UPDATE hibernate_sequences SET next_val = (SELECT MAX(VALUE_ID) + 1 FROM SBI_DOMAINS) WHERE sequence_name = 'SBI_DOMAINS';

DELETE FROM SBI_PRODUCT_TYPE_ENGINE WHERE ENGINE_ID = (
    SELECT ENGINE_ID FROM SBI_ENGINES WHERE BIOBJ_TYPE = (
        SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'ACCESSIBLE_HTML'
    )
);
 
DELETE FROM SBI_ENGINES WHERE BIOBJ_TYPE = (
    SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'ACCESSIBLE_HTML'
);
 
DELETE FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'ACCESSIBLE_HTML';

ALTER TABLE `SBI_ATTRIBUTE` CHANGE COLUMN `DESCRIPTION` `DESCRIPTION` VARCHAR(500) NULL;

ALTER TABLE SBI_OUTPUT_PARAMETER MODIFY COLUMN FORMAT_VALUE varchar(30);

ALTER TABLE `SBI_FEDERATION_DEFINITION` ADD COLUMN `OWNER` VARCHAR(100) NOT NULL AFTER `DEGENERATED`;

-- STATEMENT START
DELETE FROM SBI_EXPORTERS WHERE ENGINE_ID IN (SELECT ENGINE_ID FROM SBI_ENGINES WHERE DRIVER_NM = 'it.eng.spagobi.engines.drivers.qbe.QbeDriver') 
AND 
DOMAIN_ID IN (SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'EXPORT_TYPE' AND VALUE_CD IN ('PDF', 'RTF', 'JRXML'));

UPDATE SBI_EXPORTERS SET DEFAULT_VALUE = 1 WHERE ENGINE_ID IN (SELECT ENGINE_ID FROM SBI_ENGINES WHERE DRIVER_NM = 'it.eng.spagobi.engines.drivers.qbe.QbeDriver')
AND
DOMAIN_ID IN (SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'EXPORT_TYPE' AND VALUE_CD = 'XLS');

commit;
-- STATEMENT END


-- STATEMENT START
ALTER TABLE SBI_DATA_SOURCE DROP INDEX XAK1SBI_DATA_SOURCE;

ALTER TABLE SBI_DATA_SOURCE ADD CONSTRAINT XAK1SBI_DATA_SOURCE UNIQUE (LABEL);
-- STATEMENT END

DELETE FROM SBI_ROLE_TYPE_USER_FUNC WHERE ROLE_TYPE_ID = (SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'TEST_ROLE') AND USER_FUNCT_ID IN (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC  WHERE  NAME IN ('TIMESPAN', 'FUNCTIONSCATALOGMANAGEMENT','MANAGECROSSNAVIGATION','EVENTSMANAGEMENT'));
COMMIT;
