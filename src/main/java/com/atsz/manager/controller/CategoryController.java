package com.atsz.manager.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atsz.manager.pojo.Category;
import com.atsz.manager.service.CategoryService;

@Controller
@RequestMapping("page")
public class CategoryController {
	
	@Autowired
	private CategoryService categoryService;

	@RequestMapping(value="category")
	@ResponseBody
	public ResponseEntity<List<Category>> getCategory(){
		List<Category> list;
		try {
			list = categoryService.selectAll();
			//200
			return ResponseEntity.status(HttpStatus.OK).body(list);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//500
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
	}
}
