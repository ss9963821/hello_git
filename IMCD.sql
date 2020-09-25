SELECT IMCD.COMPANY_CD,
       IMCD.INVTRX_DOC_NO,
       IMCD.INVTRX_DOC_SQ,
       MAX(IMCD.PLANT_CD) PLANT_CD,
       MAX(IMCD.INVTRX_DT) INVTRX_DT,
       MAX(IMCD.INVTRX_CNCL_YN) INVTRX_CNCL_YN,
       MAX(MPTM.PLANT_NM) PLANT_NM,
       MAX(IMCD.SL_CD) SL_CD,
       MAX(MSLI.SL_NM) SL_NM,
       MAX(IMCD.INVTRX_TP_CD) INVTRX_TP_CD,
       MAX(MMEM.INVTRX_TP_NM) INVTRX_TP_NM,
       MAX(IMCD.EMP_NO) EMP_NO,
       MAX(HEM.KOR_NM) KOR_NM,
       MAX(HEM.DEPT_CD) DEPT_CD,
       MAX(MDM.DEPT_NM) DEPT_NM,
       MAX(PPDM.ITEM_CD) ITEM_CD,
       CASE WHEN MAX(CIGS2.ITEM_NM) IS NOT NULL THEN MAX(CIGS2.ITEM_NM) ELSE MAX(CIM2.ITEM_NM) END ITEM_NM,
       MAX(IMCD.ITEM_CD) MTRIL_CD,
       CASE WHEN MAX(CIGS.ITEM_NM) IS NOT NULL THEN MAX(CIGS.ITEM_NM) ELSE MAX(CIM.ITEM_NM) END MTRIL_NM,
       CASE WHEN MAX(CIGS.ITEM_SPEC_DC) IS NOT NULL THEN MAX(CIGS.ITEM_SPEC_DC) ELSE MAX(CIM.ITEM_SPEC_DC) END ITEM_SPEC_DC,
       MAX(IMCD.ORD_UNIT_CD) ORD_UNIT_CD,
       MAX(IMCL.LOT_NO) LOT_NO,
       CASE WHEN MAX(IMCD.LOT_USE_YN) = 'Y' THEN MAX(IMCL.ORD_QT)*-1 ELSE MAX(IMCD.ORD_QT)*-1 END ORD_QT,
       MAX(IMCD.STD_UNIT_CD) STD_UNIT_CD,
       CASE WHEN MAX(IMCD.LOT_USE_YN) = 'Y' THEN MAX(IMCL.STD_UNIT_QT)*-1 ELSE MAX(IMCD.STD_UNIT_QT)*-1 END STD_UNIT_QT,
       MAX(IMCD.CC_CD) CC_CD,
       MAX(MCCM.CC_NM) CC_NM,
       MAX(IMCD.COST_DOCU_NO) COST_DOCU_NO,
       MAX(CAUM.ACTG_DT) ACTG_DT,
       MAX(IMCD.DOCU_NO) DOCU_NO,
       MAX(IMCD.ORD_NO) ORD_NO,
       MAX(PPDM.BASE_END_DT) BASE_END_DT,
       MAX(IMCD.PRWK_NO) PRWK_NO,
       MAX(PPFM.PRWK_START_DT) PRWK_START_DT,
       MAX(PPFM.PRWK_END_DT) PRWK_END_DT,
       MAX(PPDM.PR_VER_CD) PR_VER_CD,
       MAX(PPVM.PRPOS_CD) PRPOS_CD,
       MAX(PP_P00230.SYSDEF_NM) PRPOS_NM,
       MAX(PPDM.ALTNO_CD) ALTNO_CD,
       MAX(PPDM.PROD_TP_CD) PROD_TP_CD,
       MAX(PTDM.PROD_TP_NM) PROD_TP_NM,
       MAX(MA_P00130.SYSDEF_NM) ACCT_FG_NM,
       MAX(MTRIL_MA_P00130.SYSDEF_NM) MTRIL_ACCT_FG_NM,
       MAX(MA_P00650.SYSDEF_NM) PRCURE_FG_NM,
       MAX(MTRIL_MA_P00650.SYSDEF_NM) MTRIL_PRCURE_FG_NM,
       MAX(PPDM.WBS_NO) WBS_NO,
       MAX(PWM.WBS_NM) WBS_NM,
       MAX(PPDM.PJT_NO) PJT_NO,
       MAX(MPJM.PJT_NM) PJT_NM,
       MAX(PPDM.SODOC_NO)+'_'+MAX(PPDM.SODOC_SQ)+'_'+MAX(PPDM.DLV_SCHDUL_SQ) SODOC_NO
    FROM IM_MTLDOC_DTL IMCD
       LEFT OUTER JOIN HR_EMP_MST HEM ON HEM.COMPANY_CD = IMCD.COMPANY_CD AND HEM.EMP_NO = IMCD.EMP_NO
       LEFT OUTER JOIN MA_DEPT_MST MDM ON MDM.COMPANY_CD = HEM.COMPANY_CD AND MDM.DEPT_CD = HEM.DEPT_CD AND TO_CHAR(SYSDATE,'YYYYMMDD')>= MDM.DEPT_START_DT
       LEFT OUTER JOIN CI_ITEM CIM ON CIM.ITEM_CD = IMCD.ITEM_CD
             INNER JOIN MA_ITEM MMIM ON MMIM.COMPANY_CD = IMCD.COMPANY_CD
                        AND MMIM.ITEM_CD = IMCD.ITEM_CD
             INNER JOIN MA_PITEM MMPM ON MMPM.COMPANY_CD = IMCD.COMPANY_CD
                        AND MMPM.ITEM_CD = IMCD.ITEM_CD
                        AND MMPM.PLANT_CD = IMCD.PLANT_CD
       LEFT OUTER JOIN CI_ITEMLANG_SDTL CIGS ON CIGS.ITEM_CD = IMCD.ITEM_CD AND CIGS.LANG_CD = 'KO'
       LEFT OUTER JOIN IM_MTLDOC_LOT IMCL ON IMCL.COMPANY_CD = IMCD.COMPANY_CD AND IMCL.INVTRX_DOC_NO = IMCD.INVTRX_DOC_NO AND IMCL.INVTRX_DOC_SQ = IMCD.INVTRX_DOC_SQ
       LEFT OUTER JOIN MA_CC_MST MCCM ON MCCM.COMPANY_CD = IMCD.COMPANY_CD AND MCCM.CC_CD = IMCD.CC_CD AND TO_CHAR(SYSDATE,'YYYYMMDD')>= MCCM.START_DT
       LEFT OUTER JOIN PP_PROD_MST PPDM ON PPDM.COMPANY_CD = IMCD.COMPANY_CD AND PPDM.PROD_NO = IMCD.ORD_NO AND PPDM.PROD_SQ = IMCD.ORD_SQ
            INNER JOIN MA_ITEM MIM ON MIM.COMPANY_CD = PPDM.COMPANY_CD
                       AND MIM.ITEM_CD = PPDM.ITEM_CD
            INNER JOIN MA_PITEM MPM ON MPM.COMPANY_CD = PPDM.COMPANY_CD
                       AND MPM.ITEM_CD = PPDM.ITEM_CD
                       AND MPM.PLANT_CD = PPDM.PLANT_CD
       LEFT OUTER JOIN PP_TPPRDORD_MST PTDM ON PTDM.COMPANY_CD = PPDM.COMPANY_CD AND PTDM.PROD_TP_CD = PPDM.PROD_TP_CD
       LEFT OUTER JOIN PP_PRODV_MST PPVM ON PPVM.COMPANY_CD = PPDM.COMPANY_CD AND PPVM.PLANT_CD = PPDM.PLANT_CD AND PPVM.PR_VER_CD = PPDM.PR_VER_CD
       LEFT OUTER JOIN MA_CODEDTL PP_P00230 ON PP_P00230.COMPANY_CD = PPVM.COMPANY_CD AND PP_P00230.MODULE_CD='PP' AND PP_P00230.FIELD_CD='P00230' AND PP_P00230.SYSDEF_CD=PPVM.PRPOS_CD
       LEFT OUTER JOIN MA_PLANT_MST MPTM ON MPTM.COMPANY_CD = IMCD.COMPANY_CD AND MPTM.PLANT_CD = IMCD.PLANT_CD
       LEFT OUTER JOIN MA_SL_INFO MSLI ON MSLI.COMPANY_CD = IMCD.COMPANY_CD AND MSLI.PLANT_CD = IMCD.PLANT_CD AND MSLI.SL_CD = IMCD.SL_CD
       LEFT OUTER JOIN MA_MOVETYPE_MST MMEM ON MMEM.COMPANY_CD = IMCD.COMPANY_CD AND MMEM.INVTRX_TP_CD = IMCD.INVTRX_TP_CD
       LEFT OUTER JOIN PP_PRODCONF_MST PPFM ON PPFM.COMPANY_CD = IMCD.COMPANY_CD AND PPFM.PRWK_NO = IMCD.PRWK_NO AND PPFM.PRWK_SQ = IMCD.PRWK_SQ
       LEFT OUTER JOIN CO_ADOCU_MST CAUM ON CAUM.COMPANY_CD = IMCD.COMPANY_CD AND CAUM.DOCU_NO = IMCD.COST_DOCU_NO
       LEFT OUTER JOIN CI_ITEM CIM2 ON CIM2.ITEM_CD = PPDM.ITEM_CD
       LEFT OUTER JOIN CI_ITEMLANG_SDTL CIGS2 ON CIGS2.ITEM_CD = PPDM.ITEM_CD AND CIGS2.LANG_CD = 'KO'
       LEFT OUTER JOIN MA_CODEDTL MTRIL_MA_P00130 ON MTRIL_MA_P00130.COMPANY_CD = IMCD.COMPANY_CD
                                         AND MTRIL_MA_P00130.MODULE_CD  = 'MA'
                                         AND MTRIL_MA_P00130.FIELD_CD   = 'P00130'
                                         AND MTRIL_MA_P00130.SYSDEF_CD  = MMIM.ACCT_FG_CD
       LEFT OUTER JOIN  MA_CODEDTL MTRIL_MA_P00650 ON MTRIL_MA_P00650.COMPANY_CD = IMCD.COMPANY_CD
                                         AND MTRIL_MA_P00650.MODULE_CD = 'MA'
                                         AND MTRIL_MA_P00650.SYSDEF_CD  = MMPM.PRCURE_FG_CD
                                         AND MTRIL_MA_P00650.FIELD_CD = 'P00650'
       LEFT OUTER JOIN MA_CODEDTL MA_P00130 ON MA_P00130.COMPANY_CD = IMCD.COMPANY_CD
                                         AND MA_P00130.MODULE_CD  = 'MA'
                                         AND MA_P00130.FIELD_CD   = 'P00130'
                                         AND MA_P00130.SYSDEF_CD  = MIM.ACCT_FG_CD
       LEFT OUTER JOIN  MA_CODEDTL MA_P00650 ON MA_P00650.COMPANY_CD = IMCD.COMPANY_CD
                                         AND MA_P00650.MODULE_CD = 'MA'
                                         AND MA_P00650.SYSDEF_CD  = MPM.PRCURE_FG_CD
                                         AND MA_P00650.FIELD_CD = 'P00650'
       LEFT OUTER JOIN MA_PROJECT_MST MPJM ON MPJM.COMPANY_CD = PPDM.COMPANY_CD AND MPJM.PJT_NO = PPDM.PJT_NO
       LEFT OUTER JOIN PS_WBS_MST PWM ON PWM.COMPANY_CD = PPDM.COMPANY_CD AND PWM.PJT_NO = PPDM.PJT_NO AND PWM.WBS_NO = PPDM.WBS_NO
    WHERE IMCD.COMPANY_CD = 'BS_CORP'
       AND IMCD.PLANT_CD = '1000'
       AND ( IMCD.INVTRX_DT >= '20200901' AND IMCD.INVTRX_DT  <=  '20200921' )
       AND IMCD.INVTRX_DOC_NO LIKE '%%'
       AND IMCD.ORD_NO LIKE '%%'
       AND IMCD.INVTRX_TP_CD IN ('311','313','315')
       AND IMCD.INVTRX_CNCL_REL_NO IS NULL
   GROUP BY IMCD.COMPANY_CD , IMCD.INVTRX_DOC_NO , IMCD.INVTRX_DOC_SQ
   ORDER BY MAX(IMCD.INVTRX_DT) , IMCD.INVTRX_DOC_NO , IMCD.INVTRX_DOC_SQ