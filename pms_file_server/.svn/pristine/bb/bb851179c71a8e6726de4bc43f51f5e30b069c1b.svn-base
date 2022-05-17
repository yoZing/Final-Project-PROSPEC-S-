package kr.or.server.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.UUID;

import kr.or.server.dto.DbcnVO;

public class JdbcPropertiesFileIO {

	private static String jdbcPropertiesPath;
	public void setJdbcPropertiesPath(String jdbcPropertiesPath) {
		JdbcPropertiesFileIO.jdbcPropertiesPath = jdbcPropertiesPath;
	}

	public static DbcnVO jdbcPropertiesBuilder(DbcnVO dbcnVO) throws IOException {

		String savePath = jdbcPropertiesPath.replace("/", File.separator);
		String fileName = UUID.randomUUID() + "jdbc.properties";
		if (!dbcnVO.getFileNm().equals(""))
			fileName = dbcnVO.getFileNm();

		String strHead = "\n" + "jdbc.";

		String driverClassName = strHead + "driverClassName=" + dbcnVO.getDbDriver();
		String url = strHead + "url=jdbc:oracle:thin:@" + dbcnVO.getDbcnUrl() + ":1521:XE";
		String username = strHead + "username=" + dbcnVO.getDbcnUser();
		String password = strHead + "password=" + dbcnVO.getDbcnPwd();
		String maxIdle = strHead + "maxIdle=" + dbcnVO.getMaxIdle();
		String maxTotal = strHead + "maxTotal=" + dbcnVO.getMaxTotal();

		// 로그 파일 생성
		File file = new File(savePath);
		file.mkdirs();

		try {

			BufferedWriter out = new BufferedWriter(new FileWriter(savePath + File.separator + fileName, false));

			// 로그를 기록
			out.write(driverClassName);
			out.write(url);
			out.write(username);
			out.write(password);
			out.write(maxIdle);
			out.write(maxTotal);

			out.close();
		} catch (IOException ex) {
			ex.printStackTrace();
			throw ex;
		}

		dbcnVO.setFileNm(fileName);
		dbcnVO.setPath(savePath);

		return dbcnVO;
	}

	public static void removeJdbcProperties(String filePath, String fileNm) throws IOException {
		
		String savedPath = filePath.replace("/", File.separator);
		
		File file = new File(savedPath + File.separator + fileNm);
		if (file.exists()) file.delete();

	}
}
