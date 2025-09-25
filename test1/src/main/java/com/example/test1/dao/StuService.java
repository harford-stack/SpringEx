package com.example.test1.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.StuMapper;
import com.example.test1.model.Stu;


@Service
public class StuService{
	
	@Autowired
	StuMapper stuMapper;
	
	public HashMap<String, Object> stuInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println("service => " + map);
		Stu stu = stuMapper.stuInfo(map);
		if(stu != null) {
			System.out.println(stu.getStuName());
			System.out.println(stu.getStuDept());
			System.out.println(stu.getStuNo());
		}
		
		resultMap.put("info", stu);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> getStuList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Stu> list = stuMapper.stuList(map);
		
		resultMap.put("list", list);
		resultMap.put("result", "success");
		return resultMap;
	}
}
