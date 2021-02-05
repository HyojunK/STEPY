package com.bob.stepy.dao;

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
	
	// 예약 취소

}
