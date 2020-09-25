USE [NEOE]
GO
/****** Object:  StoredProcedure [NEOE].[UP_WRM_CM_CUDO_CLOSE_RPT_CNT_S]    Script Date: 2020-08-31 오전 10:10:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [NEOE].[UP_WRM_CM_CUDO_CLOSE_RPT_CNT_S]
	@I_START_DT_SRCH	NCHAR(8),		--조회일자
	@I_END_DT_SRCH	  NCHAR(8),		--조회일자
	@P_USER_ID			  NVARCHAR(50),
	@I_OP_DPMT				NVARCHAR(100),	--기회부서
	@I_CD_DEPT		    NVARCHAR(100),	--기회부서
	@CD_COMPANY				NVARCHAR(10)
AS

-- =============================================
-- Author:		황현욱
-- Create date: 20180116
-- Description: 마감된 영업기회 현황
-- =============================================
/* *********************************************************
** Change History
** 2018/04/17 | LMG     | 권한별 기회부서 조회는 파라메터로 받아서 조회하도록 수정(+구분자로 넘어옴)
*********************************************************** */
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  SET NOCOUNT ON;

  BEGIN TRY

      SELECT COUNT(*) AS CN_DATA ,SUM(AM_ESTSALE) AS AM_ESTSALE,SUM(AM_MARGIN) AS AM_MARGIN
      FROM (
        SELECT
          MV.NO_OPT,
          ISNULL(MV.AM_ESTSALE,0) AS AM_ESTSALE,
          ISNULL(MV.AM_MARGIN,0) AS AM_MARGIN
        FROM WEB_RM_CM_CUDO_SALES_OPPORTUNITY MV
          WHERE 1 = 1
          AND MV.CD_COMPANY = @CD_COMPANY
          AND MV.DT_FNSCLOSE BETWEEN SUBSTRING(@I_START_DT_SRCH,1,4)+'-'+SUBSTRING(@I_START_DT_SRCH,5,2)+'-'+SUBSTRING(@I_START_DT_SRCH,7,2) AND SUBSTRING(@I_END_DT_SRCH,1,4)+'-'+SUBSTRING(@I_END_DT_SRCH,5,2)+'-'+SUBSTRING(@I_END_DT_SRCH,7,2)
          AND ( MV.CD_PIPE = '004')
          --AND MV.CD_OPPR   IN (SELECT VAL1 FROM FN_CZ_SPLIT(@I_OP_DPMT,'+'))
          AND (ISNULL(@I_OP_DPMT,'')='' OR MV.CD_OPPR = @I_OP_DPMT)
          AND (ISNULL(@I_CD_DEPT,'')='' OR MV.SALE_DEPT = @I_CD_DEPT)
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

USE [NEOE]
GO
/****** Object:  StoredProcedure [NEOE].[UP_WRM_CM_CUDO_RPT_SALEPROGRESS_CNT_S]    Script Date: 2020-08-31 오전 10:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [NEOE].[UP_WRM_CM_CUDO_RPT_SALEPROGRESS_CNT_S]
(
    @P_CD_COMPANY     NVARCHAR(10) , /* 회사코드   */
    @P_DT_START       NVARCHAR(8)  , /* 마감기간   */
    @P_DT_END         NVARCHAR(8)  , /* 마감기간   */
    @P_CD_DEPT        NVARCHAR(100), /* 기획부서   */
	  @P_CD_DEPT2       NVARCHAR(100), /* 기획부서   */
    @P_NO_OPPR_EMPID  NVARCHAR(10) , /* 기회소유자 */
    @P_USER_ID        NVARCHAR(10)  /* 사원       */
)
AS
/*******************************************
**  System     : customize(싸이버로지텍)
**  Sub System : CRM-영업기회관리
**  Page       : 영업진행현황
**  Desc       : 영업진행현황 목록 조회
**  Return Values
**
**  작    성    자  :  문 범 석
**  작    성    일  :  2017-12-07
**  수    정    자  :  박 성 민
**  수    정    일  :  2018-07-18
**  수  정  내  용   : 담당자 -> 담당자(담당자영문)
*********************************************
** Change History
** 2018/04/19 | LMG     | 권한별 기회부서 조회는 파라메터로 받아서 조회하도록 수정(+구분자로 넘어옴)
*********************************************/
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

  SET NOCOUNT ON;

  BEGIN TRY

        SELECT COUNT(*) AS CN_DATA ,SUM(AM_ESTSALE) AS AM_ESTSALE,SUM(AM_EST_SUM) AS AM_EST_SUM
        FROM (
            SELECT A2.NO_OPT,
                   ISNULL(A2.AM_ESTSALE,0) AS AM_ESTSALE,
                   ISNULL(A2.AM_EST_SUM,0) AS AM_EST_SUM
            FROM (
              SELECT  A1.CD_COMPANY                         /* 회사코드     */
                    , A1.NO_OPT                             /* 영업기회번호 */
                    , A1.NM_THEMA                           /* 영업기회명   */
                    ,(SELECT  DISTINCT FIRST_VALUE(S.CD_ITEM)
                              OVER (PARTITION BY S.CD_COMPANY, S.NO_OPT
                                    ORDER BY S.DTS_INSERT, S.CD_ITEM ) AS CD_ITEM
                      FROM  NEOE.WEB_RM_CM_CUDO_SALES_OPT_ITEM S
                      WHERE  S.CD_COMPANY = A1.CD_COMPANY
                      AND  S.NO_OPT     = A1.NO_OPT
                    ) CD_ITEM                              /* (제품)       */
                    ,(SELECT  DISTINCT FIRST_VALUE(S.CD_PLANT)
                              OVER (PARTITION BY S.CD_COMPANY, S.NO_OPT
                                    ORDER BY S.DTS_INSERT, S.CD_ITEM ) AS CD_ITEM
                      FROM  NEOE.WEB_RM_CM_CUDO_SALES_OPT_ITEM S
                      WHERE  S.CD_COMPANY = A1.CD_COMPANY
                      AND  S.NO_OPT     = A1.NO_OPT
                    ) CD_PLANT                              /* (공장)       */
                    , A1.CD_OPPR                            /* (부서)       */
                    , A1.NO_OPPR_EMPID                      /* (담당자)     */
                    , A1.NO_PARTNER                         /* (고객)       */
                    , A1.CD_PIPE                            /* (영업단계)   */
                    , A1.RT_ESTSALE                         /* 성공가능성   */
                    , SUM( A1.AM_ESTSALE ) AS AM_ESTSALE    /* 영업진행금액 */
                    , SUM( A1.AM_EST_SUM ) AS AM_EST_SUM    /* 예상가능금액 */
              FROM
                  (SELECT  A.CD_COMPANY                      /* 회사코드     */
                         , A.NO_OPT                          /* 영업기회번호 */
                         , A.NM_THEMA                        /* 영업기회명   */
                         , A.CD_OPPR                         /* (부서)       */
                         , A.NO_OPPR_EMPID                   /* (담당자)     */
                         , A.NO_PARTNER                      /* (고객)       */
                         , ISNULL(A.AM_ESTSALE,0)  AS AM_ESTSALE /* 영업진행금액 */
                         , 0                   AS AM_EST_SUM /* 예상가능금액 */
                         , A.CD_PIPE                         /* (영업단계)   */
                         , A.RT_ESTSALE                      /* 성공가능성   */
                  FROM  NEOE.WEB_RM_CM_CUDO_SALES_OPPORTUNITY A
                  WHERE  A.CD_COMPANY    = @P_CD_COMPANY
                  AND (A.NO_OPPR_EMPID = @P_NO_OPPR_EMPID OR @P_NO_OPPR_EMPID IS NULL OR @P_NO_OPPR_EMPID = '')
                  AND  A.CD_PIPE       = '004'  /* 예측범주 BestCase:002/확약:003/마감:004 */
                  AND  A.ST_PROGRESS   = '008'
                  AND ( A.DT_FNSCLOSE BETWEEN @P_DT_START AND @P_DT_END
                        OR A.DT_FNSCLOSE BETWEEN SUBSTRING(@P_DT_START,1,4)+'-'+SUBSTRING(@P_DT_START,5,2)+'-'+SUBSTRING(@P_DT_START,7,2)
                        AND SUBSTRING(@P_DT_END  ,1,4)+'-'+SUBSTRING(@P_DT_END  ,5,2)+'-'+SUBSTRING(@P_DT_END  ,7,2)
                  )
 					        --AND  A.CD_OPPR   IN (SELECT VAL1 FROM FN_CZ_SPLIT(@P_CD_DEPT,'+'))
                  AND (ISNULL(@P_CD_DEPT,'')='' OR A.CD_OPPR = @P_CD_DEPT)
 					        AND (ISNULL(@P_CD_DEPT2,'')='' OR A.SALE_DEPT = @P_CD_DEPT2)
 					        UNION  ALL
                    SELECT  A.CD_COMPANY                      /* 회사코드     */
                          , A.NO_OPT                          /* 영업기회번호 */
                          , A.NM_THEMA                        /* 영업기회명   */
                          , A.CD_OPPR                         /* (부서)       */
                          , A.NO_OPPR_EMPID                   /* (담당자)     */
                          , A.NO_PARTNER                      /* (고객)       */
                          , 0                   AS AM_ESTSALE /* 영업진행금액 */
                          , ISNULL(A.AM_ESTSALE,0)  AS AM_EST_SUM /* 예상가능금액 */
                          , A.CD_PIPE                         /* (영업단계)   */
                          , A.RT_ESTSALE                      /* 성공가능성   */
                    FROM  NEOE.WEB_RM_CM_CUDO_SALES_OPPORTUNITY A
                    WHERE  A.CD_COMPANY    = @P_CD_COMPANY
                    AND (A.NO_OPPR_EMPID = @P_NO_OPPR_EMPID OR @P_NO_OPPR_EMPID IS NULL OR @P_NO_OPPR_EMPID = '')
                    AND  A.CD_PIPE       IN ('001','002','003')   /* 예측범주 파이프라인:001/BestCase:002/확약:003 */
                    AND ( A.DT_FNSCLOSE BETWEEN @P_DT_START AND @P_DT_END
                          OR A.DT_FNSCLOSE BETWEEN SUBSTRING(@P_DT_START,1,4)+'-'+SUBSTRING(@P_DT_START,5,2)+'-'+SUBSTRING(@P_DT_START,7,2)
                          AND SUBSTRING(@P_DT_END  ,1,4)+'-'+SUBSTRING(@P_DT_END  ,5,2)+'-'+SUBSTRING(@P_DT_END  ,7,2)
                    )
 					          --AND  A.CD_OPPR   IN (SELECT VAL1 FROM FN_CZ_SPLIT(@P_CD_DEPT,'+'))
 					          AND (ISNULL(@P_CD_DEPT,'')='' OR A.CD_OPPR = @P_CD_DEPT)
 					          AND (ISNULL(@P_CD_DEPT2,'')='' OR A.SALE_DEPT = @P_CD_DEPT2)
                  ) A1
                   GROUP  BY A1.CD_COMPANY
                    , A1.NO_OPT
                    , A1.NM_THEMA
                    , A1.CD_OPPR
                    , A1.NO_OPPR_EMPID
                    , A1.NO_PARTNER
                    , A1.CD_PIPE
                    , A1.RT_ESTSALE
            ) A2
            LEFT  OUTER JOIN NEOE.WEB_RM_CM_CUDO_PARTNER C
                  ON   C.CD_COMPANY    = A2.CD_COMPANY
                  AND  C.NO_PARTNER    = A2.NO_PARTNER
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

USE [NEOE]
GO
/****** Object:  StoredProcedure [NEOE].[UP_WRM_CM_CUDO_SALE_ACTION_RPT_CNT_S]    Script Date: 2020-08-31 오전 10:13:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [NEOE].[UP_WRM_CM_CUDO_SALE_ACTION_RPT_CNT_S]
(
    @P_CD_COMPANY     NVARCHAR(10) , /* 회사코드   */
    @P_DT_START       NVARCHAR(8)  , /* 조회기간   */
    @P_DT_END         NVARCHAR(8)  , /* 조회기간   */
    @P_CD_DEPT        NVARCHAR(100), /* 기획부서   */
	  @P_CD_DEPT2       NVARCHAR(100), /* 기획부서   */
    @P_NO_OPPR_EMPID  NVARCHAR(10) , /* 기회소유자 */
    @P_USER_ID        NVARCHAR(10)   /* 사원       */
)
AS

/*******************************************
**  System     : customize(싸이버로지텍)
**  Sub System : CRM-영업기회관리
**  Page       : 영업활동내역현황
**  Desc       : 영업활동내역현황 조회
**  Return Values
**
**  작    성    자  :  문 범 석
**  작    성    일  :  2017-12-19
**  수    정    자  :
**  수  정  내  용 :
*********************************************
** Change History
** 2018/04/19 | LMG     | 권한별 기회부서 조회는 파라메터로 받아서 조회하도록 수정(+구분자로 넘어옴)
** 2018/07/18 | 박 성 민  | 담당자 -> 담당자(담당자영문)
*********************************************/
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  SET NOCOUNT ON;

  BEGIN TRY

      SELECT COUNT(*) AS CN_DATA ,SUM(AM_ESTSALE) AS AM_ESTSALE
      FROM (
        SELECT
          A.NO_OPT,
          ISNULL(A.AM_ESTSALE,0) AS AM_ESTSALE
        FROM  NEOE.WEB_RM_CM_CUDO_SALES_OPPORTUNITY A
          WHERE  A.CD_COMPANY    = @P_CD_COMPANY
          AND( A.NO_OPPR_EMPID = @P_NO_OPPR_EMPID OR @P_NO_OPPR_EMPID IS NULL OR @P_NO_OPPR_EMPID = '')
          AND( (A.DT_FNSCLOSE    <= @P_DT_END  AND  A.DT_FNSCLOSE  >= @P_DT_START )
            OR ( A.DT_FNSCLOSE  <= SUBSTRING(@P_DT_END,1,4)+'-'+SUBSTRING(@P_DT_END,5,2)+'-'+SUBSTRING(@P_DT_END,7,2)
                  AND A.DT_FNSCLOSE  >= SUBSTRING(@P_DT_START,1,4)+'-'+SUBSTRING(@P_DT_START,5,2)+'-'+SUBSTRING(@P_DT_START,7,2)
               )
          )
    	   --AND  A.CD_OPPR         IN (SELECT VAL1 FROM FN_CZ_SPLIT(@P_CD_DEPT,'+'))
    	    AND (ISNULL(@P_CD_DEPT,'')='' OR A.CD_OPPR = @P_CD_DEPT)
    		  AND (ISNULL(@P_CD_DEPT2,'')='' OR A.SALE_DEPT = @P_CD_DEPT2)
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

USE [NEOE]
GO
/****** Object:  StoredProcedure [NEOE].[UP_WRM_CM_CUDO_OPPR_SOLUTION_RP_CNT_S]    Script Date: 2020-08-31 오전 10:14:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [NEOE].[UP_WRM_CM_CUDO_OPPR_SOLUTION_RP_CNT_S]
  @I_START_DT_SRCH	NCHAR(8),		--조회일자
  @I_END_DT_SRCH		NCHAR(8),		--조회일자
  @I_OP_DPMT				NVARCHAR(100),	--기회부서
  @I_CD_DEPT				NVARCHAR(100),	--기회부서
  @I_EXPCT_RANGE		NVARCHAR(30),	--예측범주
  @P_USER_ID				NVARCHAR(50),
  @GRP_ITEM					NVARCHAR(5),
  @CD_COMPANY				NVARCHAR(10)
  AS
  /* *********************************************************
  ** Change History
  ** 2018/04/06 | LMG    | 권한별 기회부서 조회는 파라메터로 받아서 조회하도록 수정(+구분자로 넘어옴)
  ** 2018/07/18 | 박 성 민 | 담당자 -> 담당자(담당자영문)
  *********************************************************** */
  BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SET NOCOUNT ON;

    BEGIN TRY

      SELECT COUNT(*) AS CN_DATA ,SUM(AM_ESTSALE) AS AM_ESTSALE,SUM(AM_MARGIN) AS AM_MARGIN
      FROM (
	  SELECT E.* FROM (
		SELECT H.* FROM(
			SELECT
			  MV.NO_OPT,
			  ISNULL(SI.AM_SO,0) AS AM_ESTSALE,
			  ISNULL(SI.AM_MARGIN,0) AS AM_MARGIN,
			  (select   CLS_M
						from MA_PITEM B
						where  CD_COMPANY = @CD_COMPANY
						AND B.CD_PLANT = SI.CD_PLANT
						--and  cls_item IN ('001', '003', '005', '007', '010')
						and  B.CD_ITEM = SI.CD_ITEM ) GRP_ITEM
			FROM WEB_RM_CM_CUDO_SALES_OPPORTUNITY MV
  					INNER JOIN WEB_RM_CM_CUDO_SALES_OPT_ITEM SI
  					ON MV.CD_COMPANY = SI.CD_COMPANY AND MV.NO_OPT = SI.NO_OPT
  				WHERE 1 = 1
  				AND MV.CD_COMPANY = @CD_COMPANY
  				AND MV.DT_FNSCLOSE BETWEEN SUBSTRING(@I_START_DT_SRCH,1,4)+'-'+SUBSTRING(@I_START_DT_SRCH,5,2)+'-'+SUBSTRING(@I_START_DT_SRCH,7,2) AND SUBSTRING(@I_END_DT_SRCH,1,4)+'-'+SUBSTRING(@I_END_DT_SRCH,5,2)+'-'+SUBSTRING(@I_END_DT_SRCH,7,2)
  				--AND MV.CD_OPPR IN (SELECT VAL1 FROM FN_CZ_SPLIT(@I_OP_DPMT,'+'))
  				AND (ISNULL(@I_OP_DPMT,'')='' OR MV.CD_OPPR = @I_OP_DPMT)
  				AND (ISNULL(@I_CD_DEPT,'')='' OR MV.SALE_DEPT = @I_CD_DEPT)
  				AND (MV.CD_PIPE IN (SELECT VAL1 FROM FN_CZ_SPLIT(@I_EXPCT_RANGE,'|')) OR @I_EXPCT_RANGE = '')
  				AND MV.CD_PIPE <> '005'
			) H
		) E
		WHERE GRP_ITEM = @GRP_ITEM OR @GRP_ITEM IS NULL OR @GRP_ITEM = ''
      ) G

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
