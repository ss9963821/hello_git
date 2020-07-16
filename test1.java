else if(StringUtil.equals(requestModel.getActionName(),
        "file_save")) {
  String nmFile = requestModel.getParameterValue("nm_file");
	// ... 추가된 DATA 값
	this.insertFile("DATA가 매개변수로");
}


private void insertFile("DATA가 매개변수로") {
			String realPath  = requestModel.getDzConfig("uploadBasePath").toString();
			String tempPath  = requestModel.getDzConfig("uploadTempPath").toString();
			String splitText = requestModel.getDzConfig("uploadSplitText").toString();
			String createFileName = p_wrm_cm_ojt_hello_world3.getFileName(tmpFileName, splitText);

			// temp폴더에서 real폴더로 파일 저장
			DzMultipartModel dzMultipartModel = new DzMultipartModel(new File(tempPath, tmpFileName), createFileName);
			dzMultipartModel.setMakeFolder(true);
			File file = p_wrm_cm_ojt_hello_world3.makePath(realPath, pFilePath, pIdMenu, pCdFile);
			// Java 6 호환코드
			dzMultipartModel.transfer(file.getPath());
			// 임시파일 제거
			File dfile = new File(tempPath, tmpFileName);
			dfile.delete();
			SqlPack so = new SqlPack();

			so.setStoreProcedure(true);
			so.setSqlText("UP_WRM_CM_HELLO_WORLD_FILE_I");
			so.getInParameters().put("P_CD_COMPANY", this.getCompanyCode());
			so.getInParameters().put("P_NO_PARTNER", no_partner);
			so.getInParameters().put("P_NM_FILE", nm_file);
			so.getInParameters().put("P_URL_FILE", file.getPath());
			so.getInParameters().put("P_SZ_FILE", sz_file);
			so.getInParameters().put("P_DC_REMARK", dc_remark);
			so.getInParameters().put("P_ID_FILE_UPLOAD", this.getUserId());
			this.getDataManager().update(so);

			System.out.println(tmpFileName + "\n" + splitText + "\n" + createFileName + "\n" + file.getPath());
		}
