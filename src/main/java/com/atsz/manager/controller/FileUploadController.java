package com.atsz.manager.controller;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.csource.common.MyException;
import org.csource.fastdfs.ClientGlobal;
import org.csource.fastdfs.StorageClient;
import org.csource.fastdfs.StorageServer;
import org.csource.fastdfs.TrackerClient;
import org.csource.fastdfs.TrackerServer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("file")
public class FileUploadController {
	
	@Value("${ATSZ_IMAGE_URL}")
	private String ATSZ_IMAGE_URL;

	@RequestMapping("upload")
	@ResponseBody
	public Map<String, Object> fileUpload(MultipartFile file) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			// 第一步:加载配置文件,配置文件中指定Trackerserver的位置.
			ClientGlobal.init(System.getProperty("user.dir")+"/src/main/resources/properties/tracker.properties");
			System.out.println("类路径：" + this.getClass().getResource("/").getPath());
			// 第二步:创建一个TrackerClient对象.
			TrackerClient trackerClient = new TrackerClient();
			
			// 第三步:从TrackerClient中获得TrackerServer对象.
			TrackerServer trackerServer = trackerClient.getConnection();
			
			// 第四步:声明一个StorageServer的引用.
			StorageServer storageServer = null;
			
			// 第五步:创建StorageClient对象,需要两个参数TrackerServer对象,StorageServer
			StorageClient storageClient = new StorageClient(trackerServer, storageServer);
			
			// 第六步:调用storageClient对象upload方法上传图片,返回图片的url.
			
			String extName = StringUtils.substringAfterLast(file.getOriginalFilename(), ".");
			String[] uploadFiles = storageClient.upload_file(file.getBytes(), extName , null);
			
			// 第七步:遍历结果
			String url = this.ATSZ_IMAGE_URL;
			for (String string : uploadFiles) {
				url = url+"/"+string;
			}
			
			result.put("state", "SUCCESS");
			result.put("url", url);
			result.put("size", file.getSize());
			result.put("original", extName);
			result.put("type", file.getContentType());
			
			return result;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (MyException e) {
			e.printStackTrace();
		}
		return null;
	}
}
