package kr.or.server.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.server.dto.DbcnVO;
import kr.or.server.service.FileService;
import kr.or.server.util.JdbcPropertiesFileIO;

@RestController
@RequestMapping("/admin/dbcn")
public class AdminDbcnController {
	
	@Autowired
	private FileService fileService;
	
	@RequestMapping("/makeJdbcProperties")
	public ResponseEntity<DbcnVO> makeJdbcProperties(@RequestBody DbcnVO dbcnVO) {
		
		DbcnVO resultVO;
		try {
			resultVO = JdbcPropertiesFileIO.jdbcPropertiesBuilder(dbcnVO);
		} catch (IOException e) {
			e.printStackTrace();
			return new ResponseEntity<DbcnVO>(dbcnVO, HttpStatus.INTERNAL_SERVER_ERROR); 
		}
		
		return new ResponseEntity<DbcnVO>(resultVO, HttpStatus.OK); 
		
	}
	@RequestMapping("/removeJdbcProperties")
	public ResponseEntity<DbcnVO> removeJdbcProperties(@RequestBody DbcnVO dbcnVO) {
		
		String filePath = dbcnVO.getPath();
		String fileNm = dbcnVO.getFileNm();
		
		try {
			JdbcPropertiesFileIO.removeJdbcProperties(filePath, fileNm);
		} catch (IOException e) {
			e.printStackTrace();
			return new ResponseEntity<DbcnVO>(dbcnVO, HttpStatus.INTERNAL_SERVER_ERROR); 
		}
		
		return new ResponseEntity<DbcnVO>(dbcnVO, HttpStatus.OK); 
		
	}
	@RequestMapping("/getJdbcProperties")
	public ResponseEntity<byte[]> getJdbcProperties(@RequestBody DbcnVO dbcnVO) {
		
		String filePath = dbcnVO.getPath();
		String fileNm = dbcnVO.getFileNm();
		byte[] fileArr = null;
		try {
			System.out.println(filePath+ fileNm);
			fileArr = fileService.getFile(filePath, fileNm);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<byte[]>(fileArr, HttpStatus.INTERNAL_SERVER_ERROR); 
		}
		
		return new ResponseEntity<byte[]>(fileArr, HttpStatus.OK); 
		
	}
}