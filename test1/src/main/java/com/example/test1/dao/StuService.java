package com.example.test1.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.StuMapper;
import com.example.test1.model.Stu;


@Service
public class StuService{
	
	@Autowired
	StuMapper stuMapper;
	
	public HashMap<String, Object> stuList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println("service => " + map);
		Stu stu = stuMapper.stuList(map);
		if(stu != null) {
			System.out.println(stu.getStuName());
			System.out.println(stu.getStuDept());
			System.out.println(stu.getStuNo());
		}
		return resultMap;
	}
}
