package com.bob.stepy;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.bob.stepy.service.SearchService;

import lombok.extern.java.Log;

@Log
@Controller
public class SearchController {
	
	// ModelAndView
	private ModelAndView mv;
	
	// 서비스 객체
	@Autowired
	private SearchService sServ;
	
	
	
	// 검색 페이지 이동
	@GetMapping("sSearchFrm")
	public String sSearchFrm() {
		log.info("sSearchFrm()");
		
		return "sSearchFrm";
	}
	
	
	// 숙소 검색
	@GetMapping("searchHotel")
	public ModelAndView searchHotel(String keyword) {
		log.info("searchHotel() keyword : " + keyword);
		
		mv = sServ.searchHotel(keyword);
		
		return mv;
	}
	
	// 숙소 검색 결과 페이지
	@GetMapping("sSearchHotel")
	public String sSearchHotel() {
		log.info("sSearchHotel()");
		
		return "sSearchHotel";
	}
	
	
	// 음식점 검색
	@GetMapping("searchRestaurant")
	public ModelAndView searchRestaurant(String keyword) {
		log.info("searchRestaurant()");
		
		mv = sServ.searchRestaurant(keyword);
		
		return mv;
	}
	
	// 음식점 검색 결과 페이지
	@GetMapping("sSearchRestaurant")
	public String sSearchRestaurant() {
		log.info("sSearchRestaurant()");
		
		return "sSearchRestaurant";
	}
	
	
	// 지역시설 검색
	@GetMapping("searchPlay")
	public ModelAndView searchPlay(String keyword) {
		log.info("searchPlay()");
			
		mv = sServ.searchPlay(keyword);
			
		return mv;
	}
	
	// 지역시설 검색 결과 페이지
	@GetMapping("sSearchPlay")
	public String sSearchPlay() {
		log.info("sSearchPlay()");
		
		return "sSearchPlay";
	}
	
	
	/* ************* */
	
	// 여행 후기 게시판 검색
	@PostMapping("searchTravelReview")
	public ModelAndView searchTravelReview(@RequestParam(defaultValue = "all") String searchOption, 
			@RequestParam(defaultValue = "") String keyword, @RequestParam(defaultValue = "1") Integer pageNum) {
		log.info("searchTravelReview() searchOption : " + searchOption + ", keyword : " + keyword);
		
		mv = sServ.searchTravelReview(searchOption, keyword, pageNum);
		
		return mv;
	}
	
	
	// 메이트 게시판 검색
	@PostMapping("searchMate")
	public ModelAndView searchMate(@RequestParam(defaultValue = "all") String searchOption, 
			@RequestParam(defaultValue = "") String keyword, @RequestParam(defaultValue = "1") Integer pageNum) {
		log.info("searchMate() searchOption : " + searchOption + ", keyword : " + keyword);

		mv = sServ.searchMate(searchOption, keyword, pageNum);

		return mv;
	}
	
	
	// 자유 게시판 검색
	@PostMapping("searchFree")
	public ModelAndView searchFree(@RequestParam(defaultValue = "all") String searchOption, 
			@RequestParam(defaultValue = "") String keyword, @RequestParam(defaultValue = "1") Integer pageNum) {
		log.info("searchFree() searchOption : " + searchOption + ", keyword : " + keyword);

		mv = sServ.searchFree(searchOption, keyword, pageNum);

		return mv;
	}

}
