package com.atsz.manager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("page")
public class PageController {

	@RequestMapping("{pageName}")
	public ModelAndView page(@PathVariable("pageName") String pageName) {
		
		ModelAndView mv = new ModelAndView(pageName);
		return mv;
	}
}
