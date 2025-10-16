package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Bbs;

@Mapper
public interface BbsMapper {
	
	// 게시글 목록 호출
	List<Bbs> bbsList(HashMap<String, Object> map);
	

}
