package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Bbs;
import com.example.test1.model.Board;

@Mapper
public interface BbsMapper {
	
	// 게시글 목록 호출
	List<Bbs> bbsList(HashMap<String, Object> map);
	
	// 게시글 등록
	int insertBbs(HashMap<String, Object> map);
	
	// 게시글 삭제
	int deleteBbs(HashMap<String, Object> map);
	
	// 게시글 상세보기
	Bbs selectBbs(HashMap<String, Object> map);

}
