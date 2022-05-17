package kr.or.pms.util;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import kr.or.pms.dto.DbcnVO;

public class JdbcPropertiesFileIoAPI {

	public static DbcnVO callMakeJdbcProperties(DbcnVO dbcnVO) throws Exception {
		
		RestTemplate restTemplate = new RestTemplate();
		
		ResponseEntity<DbcnVO> response;
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		String uri = "http://192.168.144.16/server/admin/dbcn/makeJdbcProperties";

		response = restTemplate.postForEntity(uri, dbcnVO, DbcnVO.class);

		if (response.getStatusCode() != HttpStatus.OK) {
			throw new Exception();
		}

		return dbcnVO = response.getBody();
		
	}
	
	public static void callRemoveJdbcProperties(DbcnVO dbcnVO) throws Exception {
		
		RestTemplate restTemplate = new RestTemplate();
		
		ResponseEntity<DbcnVO> response;
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		String uri = "http://192.168.144.16/server/admin/dbcn/removeJdbcProperties";

		response = restTemplate.postForEntity(uri, dbcnVO, DbcnVO.class);

		if (response.getStatusCode() != HttpStatus.OK) {
			throw new Exception();
		}

		
	}

	public static byte[] getJdbcPropertiesFile(DbcnVO dbcnVO) throws Exception {

		RestTemplate restTemplate = new RestTemplate();
		
		ResponseEntity<byte[]> response;
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		String uri = "http://192.168.144.16/server/admin/dbcn/getJdbcProperties";

		response = restTemplate.postForEntity(uri, dbcnVO, byte[].class);

		
		if (response.getStatusCode() != HttpStatus.OK) {
			throw new Exception();
		}
		
		System.out.println(response.getBody());
		
		return response.getBody();
		
	}
}
