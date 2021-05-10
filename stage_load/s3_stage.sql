-- -*- coding: utf-8 -*-
-- Created by Luis Enrique Fuentes Plata

USE WAREHOUSE BI_WH_XS;
USE CC_TEST.CC_DW;

-- 1.- Creating generic file format
CREATE OR REPLACE FILE FORMAT FILE_GENERIC_S3
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    VALIDATE_UTF8 = FALSE
    TRIM_SPACE = TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' 
    NULL_IF = ('null', '');

--2.- Creating Internal Stage
CREATE OR REPLACE STAGE STAGE_FILE_GENERIC_S3 
    url='s3://'
    credentials=(aws_key_id='' aws_secret_key='')
    FILE_FORMAT = FILE_GENERIC_S3;

-- 3.- Listing files
LIST @STAGE_FILE_GENERIC_S3;

TRUNCATE TABLE T_AP_TERMS_STG;

-- 4.- COPYINTO
COPY INTO T_AP_TERMS_STG
    FROM @STAGE_FILE_GENERIC_S3
    file_format = (format_name = FILE_GENERIC_S3)
    PURGE = FALSE;

--remove @STAGE_FILE_GENERIC pattern='.*gz';

-- Idempotent Operation
DROP STAGE IF EXISTS STAGE_FILE_GENERIC_S3;
DROP FILE FORMAT IF EXISTS FILE_GENERIC_S3;
