ALTER TABLE SBI_KPI_KPI CHANGE COLUMN DEFINITION DEFINITION VARCHAR(4000) NOT NULL;
ALTER TABLE SBI_KPI_RULE CHANGE COLUMN DEFINITION DEFINITION VARCHAR(4000) NOT NULL;

ALTER TABLE SBI_META_MODEL	ADD CONSTRAINT FK_META_MODELS_DS_ID	 FOREIGN KEY (DATA_SOURCE_ID) 	REFERENCES SBI_DATA_SOURCE(DS_ID);

alter table SBI_AUDIT add (DOC_PARAMETERS_CLOB CLOB);
update SBI_AUDIT set DOC_PARAMETERS_CLOB = DOC_PARAMETERS;
alter table SBI_AUDIT drop column DOC_PARAMETERS;
alter table SBI_AUDIT rename column DOC_PARAMETERS_CLOB to DOC_PARAMETERS;

delete from SBI_PRODUCT_TYPE_ENGINE where ENGINE_ID in(select ENGINE_ID from SBI_ENGINES where NAME='Mobile Chart Engine');
delete from SBI_PRODUCT_TYPE_ENGINE where ENGINE_ID in(select ENGINE_ID from SBI_ENGINES where NAME='Mobile Cockpit Engine');
delete from SBI_PRODUCT_TYPE_ENGINE where ENGINE_ID in(select ENGINE_ID from SBI_ENGINES where NAME='Mobile Report Engine');
update SBI_ENGINES set BIOBJ_TYPE=null where NAME='Mobile Chart Engine';
update SBI_ENGINES set BIOBJ_TYPE=null where NAME='Mobile Cockpit Engine';
update SBI_ENGINES set BIOBJ_TYPE=null where NAME='Mobile Report Engine';
delete from SBI_DOMAINS where VALUE_CD='MOBILE_CHART';
delete from SBI_DOMAINS where VALUE_CD='MOBILE_COCKPIT';
delete from SBI_DOMAINS where VALUE_CD='MOBILE_REPORT';
commit;

CREATE TABLE SBI_DOSSIER_ACTIVITY(
		ID 					INTEGER NOT NULL,
		PROGRESS 			INTEGER NOT NULL,
		PPT					BLOB,
	    DOCUMENT_ID 		INTEGER,
	    ACTIVITY 			VARCHAR2(45) NOT NULL,
	    PARAMS 				VARCHAR2(4000),
     	USER_IN 			VARCHAR2(100) NOT NULL,
     	USER_UP 			VARCHAR2(100),
    	USER_DE				VARCHAR2(100),
		TIME_IN 			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	 	TIME_UP 			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	 	TIME_DE 			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     	SBI_VERSION_IN 		VARCHAR2(10),
     	SBI_VERSION_UP 		VARCHAR2(10),
     	SBI_VERSION_DE 		VARCHAR2(10),
     	ORGANIZATION 		VARCHAR2(20),
	    PRIMARY KEY (ID)
);

ALTER TABLE SBI_DOSSIER_ACTIVITY ADD CONSTRAINT FK_SBI_PROGRESS_THREAD	FOREIGN KEY (PROGRESS) 	REFERENCES SBI_PROGRESS_THREAD(PROGRESS_THREAD_ID)			ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE SBI_DOSSIER_ACTIVITY ADD CONSTRAINT FK_SBI_OBJECTS FOREIGN KEY  (DOCUMENT_ID) REFERENCES SBI_OBJECTS (BIOBJ_ID) ON DELETE CASCADE ON UPDATE CASCADE;