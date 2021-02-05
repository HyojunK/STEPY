package com.bob.stepy.service;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bob.stepy.dao.ResDao;
import com.bob.stepy.dto.MemberDto;
import com.bob.stepy.dto.ProductDto;
import com.bob.stepy.dto.ResTicketDto;
import com.bob.stepy.dto.StoreDto;

import lombok.extern.java.Log;

@Log
@Service
public class ResService {
	
	// Dao 객체
	@Autowired
	private ResDao rDao;
	
	// ModelAndView 객체
	private ModelAndView mv;
	
	// session 객체
	@Autowired 
	private HttpSession session;
	
	
	
	// 예약하려는 가게 정보, 상품(룸) 정보 가져오기
	public ModelAndView getStoreInfo(String c_num, Integer pl_num) {
		log.info("getStoreInfo() c_num : " + c_num + ", pl_num : " + pl_num);
		
		mv = new ModelAndView();
		
		StoreDto store = rDao.getStoreInfo(c_num);
		ProductDto product = rDao.getProductInfo(pl_num);
		MemberDto member = (MemberDto) session.getAttribute("member");
		
		mv.addObject("store", store);
		mv.addObject("product", product);
		mv.addObject("member", member);
		
		mv.setViewName("rReservation");
		
		return mv;
	}
	
	
	// 예약
	@Transactional
	public ModelAndView reservation(ResTicketDto resTicket, RedirectAttributes rttr) {
		log.info("reservation()");
		
		mv = new ModelAndView();
		
		try {
			rDao.reservation(resTicket);
			
			mv.setViewName("rReservationConfirm");
			rttr.addFlashAttribute("message", "예약되었습니다.");
			
		} catch (Exception e) {
			e.printStackTrace();
			
			mv.setViewName("rReservation");
			rttr.addFlashAttribute("message", "예약에 실패했습니다.");
		}
		
		return mv;
	}

}
