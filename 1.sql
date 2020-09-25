CREATE PROCEDURE [NEOE].[UP_WRM_CM_HELLO_WORLD_M2_CNT_S]
(
	@P_CD_COMPANY NVARCHAR(10),
    @P_NM_CUST NVARCHAR(20)
)
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  SET NOCOUNT ON;

  BEGIN TRY

  SELECT COUNT(*) AS CN_DATA
  FROM (
    SELECT NO_PARTNER, LN_PARTNER, FG_PARTNER, TP_INTOVER, TP_TRNSITION, TP_PRIO, NO_COMPANY
    FROM WEB_RM_OJT_PARTNER
    WHERE CD_COMPANY = @P_CD_COMPANY AND LN_PARTNER LIKE '%' + @P_NM_CUST + '%'
  ) H

  END TRY

  BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();

		RAISERROR ( @ErrorMessage, @ErrorSeverity, @ErrorState );

	END CATCH
END

CREATE PROCEDURE [NEOE].[UP_WRM_CM_HELLO_WORLD_M2_S1]
(
	@P_CD_COMPANY 		NVARCHAR(10),
  @P_NM_CUST			  NVARCHAR(20),
	@P_PAGE			      INT,
	@P_LIST_SIZE	    INT
)

AS

BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  SET NOCOUNT ON;
	IF (@P_PAGE = 0 OR @P_PAGE IS NULL)
	BEGIN
		SET @P_PAGE = 1
	END
	DECLARE @V_LISTCOUNT INT

	SET @V_LISTCOUNT = @P_LIST_SIZE

  BEGIN TRY
		SELECT H.* FROM(
			SELECT ROW_NUMBER() OVER(ORDER BY MV.NO_PARTNER ASC) ROWID,
				NO_PARTNER,
				LN_PARTNER,
				FG_PARTNER,
				TP_INTOVER,
				TP_TRNSITION,
				TP_PRIO,
				NO_COMPANY
			FROM WEB_RM_OJT_PARTNER MV
			WHERE CD_COMPANY = @P_CD_COMPANY AND LN_PARTNER LIKE '%' + @P_NM_CUST + '%'
		) H
		WHERE H.ROWID <= @P_PAGE * @V_LISTCOUNT AND (@P_PAGE = 1 OR H.ROWID > (@P_PAGE-1) * @V_LISTCOUNT)
		ORDER BY H.ROWID ASC

	END TRY

	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();

		RAISERROR ( @ErrorMessage, @ErrorSeverity, @ErrorState );

	END CATCH
	
END