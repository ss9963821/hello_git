CREATE PROCEDURE [NEOE].[UP_WRM_CM_HELLO_WORLD_CUSTOMER_S]
(
  @P_NO_PARTNER INT,
  @P_CD_COMPANY NVARCHAR(10)
)
AS

BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  SET NOCOUNT ON;

  SELECT C.CD_COMPANY,
         C.NO_CUST,
         C.NM_CUST,
         C.NM_DEPT,
         C.NM_DUTY_RESP,
         C.DC_JOB,
         C.NO_TEL,
         C.NO_CELPHONE,
         C.EMAIL,
         C.DC_RMK,
         C.NO_PARTNER,
         P.LN_PARTNER,
         C.ID_INSERT,
         C.DTS_INSERT,
         C.ID_UPDATE,
         C.DTS_UPDATE
    FROM WEB_RM_OJT_CUSTOMER AS C
         LEFT OUTER JOIN WEB_RM_OJT_PARTNER P
         ON P.CD_COMPANY = C.CD_COMPANY AND P.NO_PARTNER = C.NO_PARTNER
   WHERE C.CD_COMPANY = @P_CD_COMPANY
     AND ( ISNULL(@P_NO_PARTNER, '') = '' AND C.NO_PARTNER IS NULL OR C.NO_PARTNER = @P_NO_PARTNER)
END
