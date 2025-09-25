package com.example.test1.mapper;

import java.util.HashMap;
import org.apache.ibatis.annotations.Mapper;
import com.example.test1.model.Stu;


@Mapper
public interface StuMapper {
	
	Stu stuList(HashMap<String, Object> map);
	
	
}
