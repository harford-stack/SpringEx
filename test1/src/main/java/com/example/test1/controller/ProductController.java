package com.example.test1.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.test1.dao.ProductService;
import com.google.gson.Gson;

@Controller
public class ProductController {
	
	@Autowired
	ProductService productService;

	@RequestMapping("/product.do") 
    public String product(Model model) throws Exception{
        return "/product";
    }
	
	@RequestMapping("/product/add.do") 
    public String addProduct(Model model) throws Exception{
        return "/product-add";
    }
	
	@RequestMapping(value = "/product/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getProductList(map);
		
		return new Gson().toJson(resultMap);
	}
	
}