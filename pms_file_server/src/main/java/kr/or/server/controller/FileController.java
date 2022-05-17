package kr.or.server.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import kr.or.server.command.CloudDownloadCommand;
import kr.or.server.command.CloudModifyCommand;
import kr.or.server.dto.AttachVO;
import kr.or.server.dto.CloudVO;
import kr.or.server.service.FileService;

@RestController
@RequestMapping({ "/file" })
public class FileController {
	@Autowired
	private FileService fileService;

	@RequestMapping(value = "/attachesUploadFile", method = RequestMethod.POST)
	public ResponseEntity<List<AttachVO>> attachesUploadFile(String register, List<MultipartFile> files) throws Exception {
		ResponseEntity<List<AttachVO>> entity = null;
		List<AttachVO> attachList = null;
		try {
			attachList = fileService.attachesUploadFile(register, files);
			entity = new ResponseEntity<List<AttachVO>>(attachList, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<List<AttachVO>>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return entity;
	}
	@RequestMapping(value = "/registCloudDirectory", method = RequestMethod.POST)
	public ResponseEntity<String> registCloudDirectory(String path) throws Exception{
		ResponseEntity<String> entity = null;
		String result = "";
		try {
			result = fileService.registCloudDirectory(path);
			entity = new ResponseEntity<String>(result, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
			entity = new ResponseEntity<String>(result, HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}

	@RequestMapping(value = "/cloudUploadFile", method = RequestMethod.POST)
	public ResponseEntity<CloudVO> cloudsUploadFile(String register, MultipartFile file, String filePath) throws Exception {
		ResponseEntity<CloudVO> entity = null;
		CloudVO cloud = null;
		try {
			cloud = fileService.cloudUploadFile(register, file, filePath);
			
			entity = new ResponseEntity<CloudVO>(cloud, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<CloudVO>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return entity;
	}

	@RequestMapping(value = "/getFile", method = RequestMethod.POST)
	public ResponseEntity<byte[]> getFile(String savedPath, String fileName) throws Exception {
		ResponseEntity<byte[]> entity = null;
		try {
			byte[] bytes = fileService.getFile(savedPath, fileName);
			
			entity = new ResponseEntity<byte[]>(bytes, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return entity;
	}

	@RequestMapping(value = "/downloadZip", method = RequestMethod.POST)
	public ResponseEntity<byte[]> downloadZip(@RequestBody CloudDownloadCommand[] downloadInfoList) throws Exception {
		ResponseEntity<byte[]> entity = null;
		try {
			byte[] bytes = fileService.getZipFile(downloadInfoList);
			entity = new ResponseEntity<byte[]>(bytes, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return entity;
	}

	@RequestMapping(value = "/removeFile", method = RequestMethod.POST)
	public ResponseEntity<String> removeFile(String savedPath, String fileName) throws Exception {
		ResponseEntity<String> entity = null;
		String result = "";
		try {
			String fullPath = savedPath + fileName;
			result = fileService.removeFile(fullPath);
			entity = new ResponseEntity<String>(result, HttpStatus.OK);
			
		} catch (Exception e) {
			result = "fail";
			entity = new ResponseEntity<String>(result, HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return entity;
	}
	
	@RequestMapping(value = "/removeCloudFile", method = RequestMethod.POST)
	public ResponseEntity<String> removeCloudFile(String savedPath, String fileName) throws Exception {
		ResponseEntity<String> entity = null;
		String result = "";
		try {
			String fullPath = savedPath + fileName;
			result = fileService.removeCloudFile(fullPath);
			entity = new ResponseEntity<String>(result, HttpStatus.OK);
			
		} catch (Exception e) {
			result = "fail";
			entity = new ResponseEntity<String>(result, HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return entity;
	}

	@RequestMapping(value = "/modifyCloudName", method = RequestMethod.POST)
	public ResponseEntity<CloudModifyCommand> modifyCloudName(@RequestBody CloudModifyCommand modifyInfo) throws Exception {
		ResponseEntity<CloudModifyCommand> entity = null;
		try {
			modifyInfo = fileService.modifyCloudName(modifyInfo);
			entity = new ResponseEntity<CloudModifyCommand>(modifyInfo, HttpStatus.OK);
		} catch (Exception e) {
			entity = new ResponseEntity<CloudModifyCommand>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return entity;
	}
	
	@RequestMapping(value = "/removeUnusedFile", method = RequestMethod.POST)
	public ResponseEntity<String> removeUnusedFile(@RequestBody Map<String, Object> filePath) {
		ResponseEntity<String> entity = null;
		String result = "";
		
		try {
			result = fileService.removeUnusedFile(filePath);
			entity = new ResponseEntity<String>(result, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
			entity = new ResponseEntity<String>(result, HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
}
