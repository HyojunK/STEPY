package com.bob.stepy.service;

import java.text.SimpleDateFormat;
import java.util.Date;

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
		mv.addObject("m_id", member.getM_id());
		
		mv.setViewName("rReservation");
		
		return mv;
	}
	
	
	// 예약
	@Transactional
	public ModelAndView reservation(ResTicketDto resTicket, Integer res_plnum, String res_checkindate) {
		log.info("reservation() pl_num : " + res_plnum);
		
		mv = new ModelAndView();
		
		int resCnt = rDao.resChecking(res_checkindate, res_plnum);
		int roomQty = rDao.getProductInfo(res_plnum).getPl_qty();
		
		try {
			if(resCnt < roomQty) {
				rDao.reservation(resTicket);
				StoreDto store = rDao.getStoreName(res_plnum);
				ProductDto product = rDao.getProductInfo(res_plnum);
					
				// 체크인아웃 날짜 차이
				String checkin = resTicket.getRes_checkindate();
				String checkout = resTicket.getRes_checkoutdate();
				
				SimpleDateFormat format = new SimpleDateFormat("yyyy-mm-dd");

			    Date FirstDate = format.parse(checkin);
			    Date SecondDate = format.parse(checkout);
			        
			    long calDate = FirstDate.getTime() - SecondDate.getTime(); 
			        
			    long calDateDays = calDate / ( 24*60*60*1000); 
			 
			    calDateDays = Math.abs(calDateDays);
			        
			    // 머무는 일수(몇 박)에 따라 가격 변동
			    int price = product.getPl_price();
			    long realPrice = calDateDays * price;
					
				mv.addObject("store", store);
				mv.addObject("product", product);
				mv.addObject("resTicket", resTicket);
				mv.addObject("nights", calDateDays);
				mv.addObject("realPrice", realPrice);
					
				mv.addObject("msg", "예약이 완료되었습니다.");
				mv.setViewName("rReservationConfirm");
			}
			
			else {
				mv.addObject("msg", "해당 날짜는 예약이 불가능합니다. 다른 날짜를 선택해주세요.");
				mv.setViewName("rReservation");
			}
				
		} catch (Exception e) {
			e.printStackTrace();
				
			mv.addObject("msg", "예약에 실패했습니다. 다시 예약해주세요.");
			mv.setViewName("rReservation");
		}
		
		return mv;
	}
	
	
	// 예약 취소
	public String resCancle(Integer res_num, RedirectAttributes rttr) {
		log.info("resCancle() res_num : " + res_num);
		
		String view = null;
		
		try {
			rDao.resCancle(res_num);
			
			view = "redirect:/";
			rttr.addFlashAttribute("msg", "예약이 취소되었습니다.");
			
		} catch (Exception e) {
			e.printStackTrace();
			
			view = "redirect:/";
			rttr.addFlashAttribute("msg", "예약 취소에 실패했습니다.");
		}
		
		return view;
	}
	
	
	// 결제하면 예약 상태 1로 바꾸기
	@Transactional
	public String upResStatus(Integer res_num, RedirectAttributes rttr) {
		log.info("upResStatus() res_num : " + res_num);
		
		String view = null;
		
		try {
			rDao.upResStatus(res_num);
			
			view = "redirect:/";
			rttr.addFlashAttribute("msg", "결제가 완료되었습니다.");
			
		} catch (Exception e) {
			e.printStackTrace();
			
		}
		
		return view;
	}

}
