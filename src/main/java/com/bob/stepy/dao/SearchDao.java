package com.bob.stepy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.bob.stepy.dto.FileUpDto;
import com.bob.stepy.dto.PostDto;
import com.bob.stepy.dto.ProductDto;
import com.bob.stepy.dto.StoreDto;

public interface SearchDao {
	
	// 숙소 검색
	public List<StoreDto> searchHotel(String keyword);
	
	// 음식점 검색
	public List<StoreDto> searchRestaurant(String keyword);
		
	// 지역시설 검색
	public List<StoreDto> searchPlay(String keyword);
	
	// 가게의 상품 리스트 가져오기
	public List<ProductDto> productList(String c_num);
	
	// 가게 정보 가져오기
	public StoreDto getStoreInfo(String c_num);
	
	// 가게 썸네일 가져오기
	public List<FileUpDto> getThumbnail(String c_num);
	
	/* ***** */
	
	// 여행 후기 게시판 검색
	public List<PostDto> searchTravelReview(@Param("searchOption")String searchOption, 
			@Param("keyword")String keyword, @Param("pageNum")Integer pageNum);
	
	// 메이트 게시판 검색
	public List<PostDto> searchMate(@Param("searchOption")String searchOption, 
			@Param("keyword")String keyword, @Param("pageNum")Integer pageNum);
	
	// 자유 게시판 검색
	public List<PostDto> searchFree(@Param("searchOption")String searchOption, 
			@Param("keyword")String keyword, @Param("pageNum")Integer pageNum);

}
