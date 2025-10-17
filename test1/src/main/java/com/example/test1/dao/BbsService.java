package com.example.test1.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.BbsMapper;
import com.example.test1.model.Bbs;
import com.example.test1.model.Board;
import com.example.test1.model.Comment;

@Service
public class BbsService {
	
	@Autowired
	BbsMapper bbsMapper;
	
	public HashMap<String, Object> getBbsList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Bbs> list = bbsMapper.selectBbsList(map);
			int cnt = bbsMapper.bbsCnt(map);
			
			resultMap.put("list", list);
			resultMap.put("cnt", cnt);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addBbs(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = bbsMapper.insertBbs(map);
		
		resultMap.put("bbsNum", map.get("bbsNum"));
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> removeBbs(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = bbsMapper.deleteBbs(map);
		
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> getBbs(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		Bbs bbs = bbsMapper.selectBbs(map);
		
		List<Bbs> fileList = bbsMapper.selectFileList(map);
		resultMap.put("fileList", fileList);
		
		resultMap.put("info", bbs);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> editBbs(HashMap<String, Object> map) {
	    // TODO Auto-generated method stub
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    int cnt = bbsMapper.updateBbs(map);
	    
	    resultMap.put("result", "success");
	    return resultMap;
	}
	
	public void addBbsImg(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		int cnt = bbsMapper.insertBbsImg(map);
	}

}
