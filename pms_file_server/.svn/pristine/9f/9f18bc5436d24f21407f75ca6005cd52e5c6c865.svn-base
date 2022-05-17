package kr.or.server.service;

import java.util.List;
import java.util.Map;

import kr.or.server.command.CloudDownloadCommand;
import kr.or.server.command.CloudModifyCommand;
import kr.or.server.dto.AttachVO;
import kr.or.server.dto.CloudVO;
import org.springframework.web.multipart.MultipartFile;

public interface FileService {
	public List<AttachVO> attachesUploadFile(String paramString, List<MultipartFile> paramList) throws Exception;

	public CloudVO cloudUploadFile(String paramString1, MultipartFile paramMultipartFile, String paramString2) throws Exception;

	public byte[] getFile(String paramString1, String paramString2) throws Exception;

	public String removeFile(String filePath) throws Exception;
	public String removeCloudFile(String filePath) throws Exception;

	public byte[] getZipFile(CloudDownloadCommand[] paramArrayOfCloudDownloadCommand) throws Exception;

	public CloudModifyCommand modifyCloudName(CloudModifyCommand paramCloudModifyCommand) throws Exception;

	public String registCloudDirectory(String path) throws Exception;
	
	// 사용하지 않는 파일 삭제
	public String removeUnusedFile(Map<String, Object> filePath) throws Exception;
}
