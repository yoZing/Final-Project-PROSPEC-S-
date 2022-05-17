package kr.or.server.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.IOUtils;
import org.springframework.web.multipart.MultipartFile;

import kr.or.server.command.CloudDownloadCommand;
import kr.or.server.command.CloudModifyCommand;
import kr.or.server.dto.AttachVO;
import kr.or.server.dto.CloudVO;
import kr.or.server.util.MakeFileName;
import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.model.ZipParameters;

public class FileServiceImpl implements FileService {
	private Map<String, String> pathMap;
	
	private String fileUploadPath;
	public void setFileUploadPath(String fileUploadPath) {
		this.fileUploadPath = fileUploadPath;
	}
	private String cloudUploadPath;
	public void setClouUploadPath(String cloudUploadPath) {
		this.cloudUploadPath = cloudUploadPath;
	}
	@Override
	public List<AttachVO> attachesUploadFile(String register, List<MultipartFile> files) throws Exception {
		List<AttachVO> attachList = new ArrayList<>();

		for (MultipartFile multi : files) {
			String originalFileName = multi.getOriginalFilename();
			String storedFileName = MakeFileName.toUUIDFileName(originalFileName, "$$");
			String fileSize = Long.toString(multi.getSize());
			String extension = multi.getOriginalFilename().substring(multi.getOriginalFilename().lastIndexOf(".") + 1);
			File file = new File(this.fileUploadPath, storedFileName);

			file.mkdirs();

			multi.transferTo(file);

			AttachVO attach = new AttachVO();
			attach.setRegister(register);
			attach.setAttachPath(this.fileUploadPath);
			attach.setNm(originalFileName);
			attach.setStroredNm(storedFileName);
			attach.setExt(extension);
			attach.setFileSize(fileSize);
			attach.setRegDt(new Date());

			attachList.add(attach);
		}
		return attachList;
	}

	@Override
	public CloudVO cloudUploadFile(String register, MultipartFile file, String filePath) throws Exception {
		String originalFileName = file.getOriginalFilename();
		String storedFileName = MakeFileName.toUUIDFileName(originalFileName, "$$");
		String fileSize = Long.toString(file.getSize());
		String extension = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".") + 1);
		String dirPath = this.cloudUploadPath + "/" + filePath;
		File uploadFile = new File(dirPath, storedFileName);

		uploadFile.mkdirs();
		if (file != null) {
			file.transferTo(uploadFile);
		}

		CloudVO cloud = new CloudVO();
		cloud.setRegister(register);
		cloud.setPath(dirPath + "/" + storedFileName);
		cloud.setFileNm(originalFileName);
		cloud.setStoredNm(storedFileName);
		cloud.setExt(extension);
		cloud.setFilesize(fileSize);
		cloud.setRegDt(new Date());

		return cloud;
	}
	
	@Override
	public byte[] getFile(String savedPath, String fileName) throws Exception {
		File downloadFile = new File(savedPath, fileName);
		byte[] bytes = Files.readAllBytes(downloadFile.toPath());

		return bytes;
	}

	@Override
	public String removeFile(String path) throws Exception {
		File savedFile = new File(path);
		
		String result = "";
		if (savedFile.exists()) {
			savedFile.delete();
			result = "success";
		}

		return result;
	}
	
	@Override
	public String removeCloudFile(String path) throws Exception {
		File savedFile = null;
		if (path.lastIndexOf("c:") > 0) {
			savedFile = new File(path.substring(cloudUploadPath.length()));
		} else {
			savedFile = new File(path);
		}
		String result = "";
		if (savedFile.isDirectory()) {
			File[] folderList = savedFile.listFiles(); // 파일리스트 얻어오기

			for (int i = 0; i < folderList.length; i++) {
				if (folderList[i].isFile()) {
					folderList[i].delete(); // 파일 삭제
				} else { // 폴더면 재귀함수
					removeFile(folderList[i].getPath());
				}
				folderList[i].delete();
			}
			savedFile.delete(); // 대상폴더 삭제
			result = "success";
		} else {
			savedFile.delete();	// 파일로 들어오면 그냥 삭제
			result = "success";
		}

		return result;
	}

	@Override
	public byte[] getZipFile(CloudDownloadCommand[] downloadInfoList) throws Exception {
		String zipFilePath = this.cloudUploadPath + File.separator + "CloudFile.zip";
		ZipFile zipFile = new ZipFile(zipFilePath);

		ZipParameters parameters = new ZipParameters();
		parameters.setCompressionMethod(8);
		parameters.setCompressionLevel(5);

		String filePath = "";
		if (downloadInfoList != null) {
			CloudDownloadCommand[] arrayOfCloudDownloadCommand;
			int j = (arrayOfCloudDownloadCommand = downloadInfoList).length;
			for (int i = 0; i < j; i++) {
				CloudDownloadCommand cdc = arrayOfCloudDownloadCommand[i];
				if (cdc.getType().equals("folder")) {
					filePath = this.cloudUploadPath + cdc.getPath();
					System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + filePath);
					zipFile.addFolder(filePath, parameters);
				} else {
					filePath = cdc.getPath();
					zipFile.addFile(new File(filePath), parameters);
				}
			}
		}
		InputStream is = null;
		try {
			is = new FileInputStream(zipFile.getFile());
			File tempFile;
			return IOUtils.toByteArray(is);
		} finally {
			is.close();
			File tempFile = new File(zipFilePath);
			if (tempFile.exists()) {
				tempFile.delete();
			}
		}
	}
	
	@Override
	public CloudModifyCommand modifyCloudName(CloudModifyCommand modifyInfo) throws Exception {
		if (modifyInfo.getType().equals("file")) {
			String oldPath = modifyInfo.getPath();
			String newFileName = modifyInfo.getNewFileName() + "." + modifyInfo.getExtension();
			newFileName = MakeFileName.toUUIDFileName(newFileName, "$$");

			String newPath = oldPath.substring(0, oldPath.lastIndexOf("/") + 1) + newFileName;

			File file = new File(oldPath);
			File newFile = new File(newPath);

			boolean result = file.renameTo(newFile);
			if (result) {
				modifyInfo.setNewFileName(MakeFileName.parseFileNameFromUUID(newFileName, "\\$\\$"));
				modifyInfo.setPath(newPath);
			}
			return modifyInfo;
		}
		String oldPath = modifyInfo.getPath();
		String newFileName = modifyInfo.getNewFileName();

		String newPath = this.cloudUploadPath + oldPath.substring(0, oldPath.lastIndexOf("/") + 1) + newFileName;

		File file = new File(this.cloudUploadPath + oldPath);
		File newFile = new File(newPath);

		boolean result = file.renameTo(newFile);
		if (result) {
			modifyInfo.setPath(newPath);
		}
		return modifyInfo;
	}

	@Override
	public String registCloudDirectory(String path) throws Exception {
		File newDirectory = new File(cloudUploadPath + path);
		String result = "";
		if (newDirectory != null) {
			newDirectory.mkdirs();
			result = "success";
		}

		return result;
	}

	@Override
	public String removeUnusedFile(Map<String, Object> filePath) throws Exception {
		Map<String, String> dirPathMap = new HashMap<String, String>();
		Map<String, String> storedFileNameMap = new HashMap<String, String>();
		String result = "";
		
		Set<String> keySet = filePath.keySet();
		Iterator<String> it = keySet.iterator();
		while (it.hasNext()) {
			String key = it.next();
			List<String> pathList = (List<String>) filePath.get(key);
			for (String path : pathList) {
				String dirPath = path.substring(0, path.lastIndexOf("/"));
				String storedFileName = path.substring(path.lastIndexOf("/") + 1);
				
				dirPathMap.put(dirPath, dirPath);
				storedFileNameMap.put(storedFileName, storedFileName);
			}
		}
		
		if (!(dirPathMap == null && dirPathMap.isEmpty() && storedFileNameMap == null && storedFileNameMap.isEmpty())) {
			Set<String> dirKeySet = dirPathMap.keySet();
			Iterator<String> dirIt = dirKeySet.iterator();
			
			while (dirIt.hasNext()) {
				String key = dirIt.next();
				
				File dir = new File(dirPathMap.get(key));
				File[] files = dir.listFiles();
				
				if (files != null) {
					for (File file : files) {
						if (storedFileNameMap.get(file.getName()) != null) {
							continue;
						} else {
							file.delete();
						}
					}
				}
			}
		}
		
		result = "success";
		
		return result;
	}
}