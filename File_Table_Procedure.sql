CREATE PROCEDURE [NEOE].[UP_WRM_CM_HELLO_WORLD_FILE_S]
(
	@P_CD_COMPANY NVARCHAR(10),
	@P_NO_PARTNER INT
)
AS
  SELECT NO_PARTNER, NO_OPT_FILE, NM_FILE, URL_FILE, SZ_FILE,
          ID_FILE_UPLOAD, DTS_FILE_UPLOAD, DC_REMARK
  FROM WEB_RM_CM_YBTOUR_SALES_OPT_ATTACHFILE
  WHERE NO_PARTNER = @P_NO_PARTNER AND CD_COMPANY = @P_CD_COMPANY
  GO

INSERT INTO WEB_RM_CM_YBTOUR_SALES_OPT_ATTACHFILE
(
  CD_COMPANY,
  NO_PARTNER,
  NO_OPT_FILE,
  NM_FILE
)VALUES(
  'YBTOUR',
  '1',
  '1',
  '1'
)
**TETSTETSETST
CREATE PROCEDURE [NEOE].[UP_WRM_CM_HELLO_WORLD_PARTNER_S]
    @P_LN_PARTNER NVARCHAR(20)
AS
  SELECT LN_PARTNER, NM_PRES, NO_COMPANY, DC_ADS1_H, TP_JOB
  FROM WEB_RM_OJT_PARTNER
  WHERE LN_PARTNER LIKE '%' + @P_LN_PARTNER + '%'


