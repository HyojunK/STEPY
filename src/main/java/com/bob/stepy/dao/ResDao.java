package com.bob.stepy.dao;

import org.apache.ibatis.annotations.Param;

import com.bob.stepy.dto.ProductDto;
import com.bob.stepy.dto.ResTicketDto;
import com.bob.stepy.dto.StoreDto;

public interface ResDao {
	
	// 예약하려는 가게 정보 가져오기
	public StoreDto getStoreInfo(String c_num);
	
	// 예약하려는 상품(룸) 정보 가져오기
	public ProductDto getProductInfo(Integer pl_num);
	
	// 호텔 예약
	public void reservation(ResTicketDto resTicket);
	
	// 상품번호로 가게 정보 가져오기
	public StoreDto getStoreName(Integer pl_num);
	
	// 해당 날짜 예약 여부
	public int resChecking(@Param("res_checkindate")String res_checkindate, @Param("res_plnum")Integer res_plnum);
	
	// 예약 취소
	public void resCancle(Integer res_num);
	
	// 결제하면 예약 상태 1로 바꾸기
	public void upResStatus(Integer res_num);

}
