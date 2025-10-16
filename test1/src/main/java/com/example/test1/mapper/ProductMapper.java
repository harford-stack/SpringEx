package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Board;
import com.example.test1.model.Menu;
import com.example.test1.model.Product;

@Mapper
public interface ProductMapper {
	
	// 제품 목록
	List<Product> selectProductList(HashMap<String, Object> map);
	
	// 메뉴 목록
	List<Menu> selectMenuList(HashMap<String, Object> map);
	
	// 제품 추가
	int insertProduct(HashMap<String, Object> map);
	
	// 게시글 상세보기
	Product selectProduct(HashMap<String, Object> map);
	
	// 첨부파일(이미지) 업로드
	int insertProductImg(HashMap<String, Object> map);
	
	// 첨부파일 목록
	List<Product> selectFileList(HashMap<String, Object> map);
	
	// 제품 결제 정보 삽입
	int insertPayHistory(HashMap<String, Object> map);

}
