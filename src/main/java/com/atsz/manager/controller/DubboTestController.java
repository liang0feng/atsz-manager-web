package com.atsz.manager.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atsz.manager.service.TestDubboService;

@Controller
@RequestMapping("page")
public class DubboTestController {
	
	@Autowired
	TestDubboService testDubboService;

	@RequestMapping(value="test",method=RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<String> test01() {
		return ResponseEntity.status(HttpStatus.OK).body(testDubboService.test01());
	}
}
