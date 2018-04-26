package com.atsz.manager.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.function.LongPredicate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.common.pojo.DataTableJSONResponse;
import com.atsz.manager.pojo.Product;
import com.atsz.manager.service.ProductService;
import com.atsz.manager.service.ProductdesService;

@RequestMapping("page")
@Controller
public class ProductController {
	
	@Autowired
	ProductService productService;
	
	@Autowired
	ProductdesService productdesService;

	/**
	 * 
	 * 仅添加商品项
	 * @param product 页面传入的商品信息
	 * @return 
	 */
	@RequestMapping(value="product1",method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Boolean> addProduct(Product product){
		System.out.println("要添加的商品："+product);
		try {
			productService.insertSelective(product);
			return ResponseEntity.status(HttpStatus.OK).body(true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false);
	}
	
	/**
	 * 添加商品项和商品描述
	 * @param product
	 * @return
	 */
	@RequestMapping(value="product",method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Boolean> addProduct(Product product,String image){
		System.out.println("要添加的商品："+product);
		try {
			productdesService.saveProuductAndDesc(product, image);
			return ResponseEntity.status(HttpStatus.OK).body(true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false);
	}
	
	
	/**
	 * 查询所有产品，返回数据列表显示
	 * 
	 */
	@RequestMapping(value="product",method=RequestMethod.GET)
	public ResponseEntity<DataTableJSONResponse> queryByCid(
			@RequestParam("aodata") String aodata,
			@RequestParam(value="cid",required=false) Long cid){
		
		DataTableJSONResponse tableJSONResponse = new DataTableJSONResponse();
		
		try {
			String sEcho ="0"; //默认为0
			int iDisplayStart = 0;//默认从第一页开始
			int iDisplayLength = 10;//默认每页显示10条记录
			
			if (aodata != null) {
				JSONArray jsonArray = new JSONArray(aodata);
				for (Object json : jsonArray) {
					JSONObject jsonObj = (JSONObject) json;
					
					if (jsonObj.get("name").equals("sEcho")) {
						//统计次数参数
						sEcho = jsonObj.get("value").toString();
					}
					
					//起始显示序号
					if (jsonObj.get("name").equals("iDisplayStart")) {
						iDisplayStart = jsonObj.getInt("value");
					}
					
					//每页显示条数
					if (jsonObj.get("name").equals("iDisplayLength")) {
						iDisplayLength = jsonObj.getInt("value");
					}
				}
			}
			
			Product product = new Product();
			if (cid != null) {
				product.setCid(cid);
			}
			
			//查询到的总计录数
			Integer count = productService.count(product);
			//查询结果
			List<Product> aaData = productService.selectByExample(product);
			
			//分页逻辑：当前页显示逻辑
			if (count > iDisplayStart) {
				if ((count - iDisplayStart) > iDisplayLength) {
					aaData = aaData.subList(iDisplayStart, iDisplayStart+iDisplayLength);
				}else {
					aaData = aaData.subList(iDisplayStart, count);
				}
			}
			
			DataTableJSONResponse dataTableJSONResponse = new DataTableJSONResponse(sEcho, count, count, aaData);
			
			return ResponseEntity.status(HttpStatus.OK).body(dataTableJSONResponse);
		} catch (JSONException e) {
			e.printStackTrace();
		}
        
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
	}
	
	
	/**
	 * 批量删除
	 * ids以“，”号分隔
	 * @return
	 */
	@RequestMapping(value="product",method=RequestMethod.DELETE)
	public ResponseEntity<Boolean> deleteByIds(
			@RequestParam("ids") String ids){
		
		System.out.println("ids:"+ids);
		ArrayList<Object> idsList = new ArrayList<Object>();
		
		try {
			String[] split = ids.split(",");
			for (String string : split) {
				long id = Long.parseLong(string);
				idsList.add(string);
			}
			
			productService.deleteByIds(idsList);
			return ResponseEntity.status(HttpStatus.OK).body(true);
			
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false);
	}
	
	
}
