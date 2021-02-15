package com.bob.stepy;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
	@GetMapping("rReservation")
	public ModelAndView getStoreInfo(String c_num, Integer pl_num) {
		log.info("getStoreInfo() c_num : " + c_num + ", pl_num : " + pl_num);
		
		mv = rServ.getStoreInfo(c_num, pl_num);
		
		return mv;
	}
	
	
	// 예약
	@PostMapping("rReservationConfirm")
	public ModelAndView rReservationConfirm(ResTicketDto resTicket, Integer res_plnum, String res_checkindate) {
		log.info("rReservationConfirm()");
		
		mv = rServ.reservation(resTicket, res_plnum, res_checkindate);
		
		return mv;
	}
	
	
	// 예약 취소
	@GetMapping("resCancle")
	public String resCancle(Integer res_num, RedirectAttributes rttr) {
		log.info("resCancle() res_num : " + res_num);
		
		String view = rServ.resCancle(res_num, rttr);
		
		return view;
	}
	
	
	// 결제하면 예약 상태 1로 바꾸기
	@PostMapping("upResStatus")
	public String upResStatus(Integer res_num, RedirectAttributes rttr) {
		log.info("upResStatus() res_num : " + res_num);
		
		String view = rServ.upResStatus(res_num, rttr);
		
		return view;
	}
	
}
