package com.bob.stepy;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bob.stepy.dto.ResTicketDto;
import com.bob.stepy.service.ResService;

import lombok.extern.java.Log;

@Log
@Controller
public class ResController {
	
	// 서비스 객체
	@Autowired
	private ResService rServ;
	
	// ModelAndView 객체
	private ModelAndView mv;
	
	
	
	// 예약하려는 가게 정보, 상품(룸) 정보 가져오기
	//@GetMapping("rReservation")
	@RequestMapping(value="rReservation", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView getStoreInfo(String c_num, Integer pl_num) {
		log.info("getStoreInfo() c_num : " + c_num + ", pl_num : " + pl_num);
		
		mv = rServ.getStoreInfo(c_num, pl_num);
		
		return mv;
	}
	
	
	// 예약
	@PostMapping("rReservationConfirm")
	public ModelAndView rReservationConfirm(ResTicketDto resTicket, RedirectAttributes rttr) {
		log.info("res_checkoutdate()");
		
		mv = rServ.reservation(resTicket, rttr);
		
		return mv;
	}
	
}
