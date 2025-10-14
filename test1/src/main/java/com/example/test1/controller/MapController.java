package com.example.test1.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MapController {
	
	@RequestMapping("/map.do")
	public String product(Model model) throws Exception{
		return "/map/map2";
	}
}
