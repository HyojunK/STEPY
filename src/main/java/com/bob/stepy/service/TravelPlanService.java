package com.bob.stepy.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bob.stepy.dao.TravelPlanDao;
import com.bob.stepy.dto.AccompanyPlanDto;
import com.bob.stepy.dto.CheckListDto;
import com.bob.stepy.dto.ChecklistViewDto;
import com.bob.stepy.dto.HouseholdDto;
import com.bob.stepy.dto.InviteDto;
import com.bob.stepy.dto.MemberDto;
import com.bob.stepy.dto.PlanDto;
import com.bob.stepy.dto.StoreDto;
import com.bob.stepy.dto.TravelPlanDto;

import lombok.extern.java.Log;

@Service
@Log
public class TravelPlanService {
	@Autowired
	private HttpSession session;
	@Autowired
	private TravelPlanDao tDao;
	
	ModelAndView mv;
	
	//여행 등록
	@Transactional
	public ModelAndView pRegPlan(TravelPlanDto plan, RedirectAttributes rttr) {
		log.info("service - pRegPlan()");
		long planNum = System.currentTimeMillis();
		
		mv = new ModelAndView();
		
		try {
			plan.setT_plannum(planNum);
			tDao.pRegPlan(plan);
			mv.addObject("plan", plan);
			
			//시작일과 종료일의 차이 계산
			long days = getTime(plan.getT_stdate(), plan.getT_bkdate());
			mv.addObject("days", days);
			
			AccompanyPlanDto acPlan = new AccompanyPlanDto();
			
			for(int i = 1; i <= days; i++) {
				acPlan.setAp_plannum(planNum);
				acPlan.setAp_mid(plan.getT_id());
				acPlan.setAp_day(i);
				
			}
			//초기 체크리스트 설정
			tDao.pInitChecklist1(planNum);
			tDao.pInitChecklist2(planNum);
			
			//초대 리스트 가져오기
			List<InviteDto> iList = tDao.pGetInviteList();
			mv.addObject("iList", iList);
			//새로운 초대 여부 확인
			MemberDto member = (MemberDto)session.getAttribute("member");
			int iCnt = tDao.pCheckInvite(member.getM_id());
			mv.addObject("iCnt", iCnt);
			
			session.setAttribute("curPlan", planNum);
			mv.setViewName("pPlanFrm");
		} catch (Exception e) {
			e.printStackTrace();
			mv.setViewName("redirect:pMakePlanFrm");
			rttr.addFlashAttribute("msg", "등록에 실패하였습니다");
		}
		
		return mv;
	}
	
	//날짜 차이 계산
	public long getTime(String start, String end) {
		long days = 0;
		
		try {
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			//날짜를 Date형으로 변환
			Date startDate = format.parse(start);
			Date endDate = format.parse(end);
			
			//두 날짜간의 차이(1970년 기준 00:00:00부터 몇 초가 흘렀는지)
			long calDate = startDate.getTime() - endDate.getTime();
			
			//(일*시*분*초) = 일수
			days = calDate / (24*60*60*1000);
			//절대값 변환
			days = Math.abs(days);
			
		} catch (Exception e) {
			//e.printStackTrace();
		}
		
		return days;
	}

	//여행 목록 가져오기
	public ModelAndView pPlanList(String id) {
		log.info("service - pPlanList() - id: " + id);
		mv = new ModelAndView();
		
		List<TravelPlanDto> planList = tDao.getPlanList(id);
		
		//여행 일정 모델에 추가
		mv.addObject("planList", planList);
		//초대 리스트 가져오기
		List<InviteDto> iList = tDao.pGetInviteList();
		mv.addObject("iList", iList);
		//새로운 초대 여부 확인
		MemberDto member = (MemberDto)session.getAttribute("member");
		int iCnt = tDao.pCheckInvite(member.getM_id());
		mv.addObject("iCnt", iCnt);
		
		mv.setViewName("pPlanList");
		
		return mv;
	}

	//일정 페이지 이동
	public ModelAndView pPlanFrm(long planNum, RedirectAttributes rttr) {
		log.info("service - pPlanFrm() - planNum : " + planNum);
		
		long num = (planNum == 0)? (long)session.getAttribute("curPlan") : planNum;
		
		mv = new ModelAndView();
		
		TravelPlanDto plan = tDao.getPlan(num);
		
		//권한 검사
		if(memberAuthCheck(plan)) {

			mv.addObject("plan", plan);
			
			//시작일과 종료일의 차이 계산
			long days = getTime(plan.getT_stdate(), plan.getT_bkdate());
			mv.addObject("days", days);
			
			//멤버 카운트
			int memCnt = 0;
			if(!(plan.getT_member1().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member2().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member3().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member4().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member5().equals(" "))) {
				memCnt++;
			}
			
			mv.addObject("memCnt", memCnt);
			
			//여행 내용 가져오기	
			List<AccompanyPlanDto> planContentsList = tDao.getPlanContents(num);
			mv.addObject("planContentsList", planContentsList);
			//}
			//초대 리스트 전체 가져오기
			List<InviteDto> iList = tDao.pGetInviteList();
			mv.addObject("iList", iList);
			//새로운 초대 여부 확인
			MemberDto member = (MemberDto)session.getAttribute("member");
			int iCnt = tDao.pCheckInvite(member.getM_id());
			mv.addObject("iCnt", iCnt);
			//현재 일정에 초대중인 멤버 가져오기
			List<InviteDto> waitingList = tDao.pGetWaitingMember(num);
			mv.addObject("waitingList", waitingList);
			//세션에 현재 여행 번호 저장
			session.setAttribute("curPlan", num);
			
			//가게 목록 불러오기
			List<StoreDto> sList = tDao.getStoreList();
			mv.addObject("sList", sList);
			
			mv.setViewName("pPlanFrm");
		}
		else {
			mv.setViewName("redirect:/");
			rttr.addFlashAttribute("msg", "접근 권한이 없습니다");
		}
		
		return mv;
	}

	//장소 검색 페이지 이동
	public ModelAndView pStoreSearch(long day, long planCnt) {
		log.info("service - pStoreSearch()");
		
		mv = new ModelAndView();
		//가게 목록 불러오기
		List<StoreDto> sList = tDao.getStoreList();
		mv.addObject("sList", sList);
		mv.addObject("day", day);
		mv.addObject("planCnt", planCnt);
		
		return mv;
	}
	
	//여행 내용 등록
	@Transactional
	public String RegAccompanyPlan(AccompanyPlanDto acPlan, RedirectAttributes rttr) {
		log.info("service - RegAccompanyPlan()");
		
		try {
			//여행 내용 등록
			tDao.regAccompanyPlan(acPlan);
			
		} catch (Exception e) {
			//e.printStackTrace();
		}
		
		return "redirect:pPlanFrm?planNum=0";
	}

	//여행 내용 삭제
	@Transactional
	public String delAccompanyPlan(long day, long num, RedirectAttributes rttr) {
		log.info("service - delAccompanyPlan()");
		
		Map<String, Long> apMap = new HashMap<String, Long>();
		apMap.put("planNum", (long)session.getAttribute("curPlan"));
		apMap.put("day", day);
		apMap.put("num", num);
		try {
			//데이터 삭제
			tDao.delAccompanyPlan(apMap);
			//남은 데이터 카운트 정렬
			tDao.reduceNumCnt(apMap);
			
		} catch (Exception e) {
			//e.printStackTrace();
		}
		
		return "redirect:pPlanFrm?planNum=0";
	}
	
	//여행 내용 수정 페이지 이동
	public ModelAndView pEditAccompanyPlanFrm(long day, long planCnt) {
		log.info("service - pEditAccompanyPlanFrm()");
		
		return pStoreSearch(day, planCnt);
	}
	
	//여행 내용 수정
	@Transactional
	public String pEditAccompanyPlan(AccompanyPlanDto acPlan, RedirectAttributes rttr) {
		log.info("service - pEditAccompanyPlan()");
		
		try {
			tDao.pEditAccompanyPlan(acPlan);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:pPlanFrm?planNum=0";
	}
	
	//가계부 페이지 이동
	public ModelAndView pHouseholdFrm(long planNum, RedirectAttributes rttr) {
		log.info("service - pHouseholdFrm() - planNum : " + planNum);
		
		long num = (planNum == 0)? (long)session.getAttribute("curPlan") : planNum;
		
		mv = new ModelAndView();
		
		TravelPlanDto plan = tDao.getPlan(num);
		
		//권한 검사
		if(memberAuthCheck(plan)) {
			mv.addObject("plan", plan);
			
			//시작일과 종료일의 차이 계산
			long days = getTime(plan.getT_stdate(), plan.getT_bkdate());
			mv.addObject("days", days);
			
			//멤버 카운트
			int memCnt = 0;
			if(!(plan.getT_member1().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member2().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member3().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member4().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member5().equals(" "))) {
				memCnt++;
			}
			
			mv.addObject("memCnt", memCnt);
			
			//가계부 내용 가져오기
			List<HouseholdDto> hList = tDao.getHouseholdList(num);
			mv.addObject("hList", hList);
			
			//초대 리스트 가져오기
			List<InviteDto> iList = tDao.pGetInviteList();
			mv.addObject("iList", iList);
			//새로운 초대 여부 확인
			MemberDto member = (MemberDto)session.getAttribute("member");
			int iCnt = tDao.pCheckInvite(member.getM_id());
			mv.addObject("iCnt", iCnt);
			//현재 일정에 초대중인 멤버 가져오기
			List<InviteDto> waitingList = tDao.pGetWaitingMember(num);
			mv.addObject("waitingList", waitingList);
			mv.setViewName("pHouseholdFrm");
		}
		else {
			mv.setViewName("redirect:/");
			rttr.addFlashAttribute("msg", "접근 권한이 없습니다");
		}
		
		return mv;
	}

	//가계부 내용 작성페이지 이동
	public ModelAndView pWriteHousehold(long householdCnt, long days, long dayCnt) {
		log.info("service - pWriteHousehold() - householdCnt : " + householdCnt + ", days : " + days  + " , dayCnt : " + dayCnt);
		
		long num = (days == 0)? (long)session.getAttribute("curDays") : days;
		session.setAttribute("cruDays", days);
		
		mv = new ModelAndView();
		
		mv.addObject("householdCnt", householdCnt);
		mv.addObject("days", num);
		mv.addObject("dayCnt", dayCnt);
		
		//가게 목록 불러오기
		List<StoreDto> sList = tDao.getStoreList();
		mv.addObject("sList", sList);
				
		mv.setViewName("pWriteHousehold");
		
		return mv;
	}

	//가계부 내용 등록
	@Transactional
	public String regHousehold(HouseholdDto household, RedirectAttributes rttr) {
		log.info("service - regHousehold()");
		String view = null;
	
		try {
			tDao.regHousehold(household);
			view = "redirect:pHouseholdFrm?planNum=0";
			
		} catch (Exception e) {
			e.printStackTrace();
			String cnt = Long.toString(household.getH_cnt());
			view = "redirect:pWriteHousehold?householdCnt=" + cnt + "&days=0";
		}
		
		return view;
	}

	//가계부 내용 수정 페이지 이동
	public ModelAndView pModHouseholdFrm(long days, long dayCnt, long householdCnt) {
		log.info("service - pModHouseholdFrm()");
		
		mv = new ModelAndView();
		
		Map<String, Long> hList = new HashMap<String, Long>();
		hList.put("planNum", (long)session.getAttribute("curPlan"));
		hList.put("day", dayCnt);
		hList.put("householdCnt", householdCnt);
		
		HouseholdDto household = tDao.getHouseholdContentes(hList);
		
		mv.addObject("dayCnt", dayCnt);
		mv.addObject("days", days);
		mv.addObject("contents", household);
		mv.setViewName("pModHouseholdFrm");
		
		//가게 목록 불러오기
		List<StoreDto> sList = tDao.getStoreList();
		mv.addObject("sList", sList);
		
		return mv;
	}
	
	//가계부 내용 수정
	@Transactional
	public String modHousehold(HouseholdDto household, RedirectAttributes rttr) {
		log.info("service - modHousehold()");
		String view = null;
		
		Map<String, Long> hMap = new HashMap<String, Long>();
		hMap.put("planNum", household.getH_plannum());
		hMap.put("curDay", household.getH_curday());
		hMap.put("householdCnt", household.getH_cnt());
		
		try {
			//가계부 내용 수정
			tDao.ModHousehold(household);
			//남은 데이터 카운트 정렬
			tDao.reduceHouseholdCnt(hMap);
			view = "redirect:pHouseholdFrm?planNum=0";
		} catch (Exception e) {
			e.printStackTrace();
			view = "redirect:pPlanFrm?planNum=0";
		}
		
		return view;
	}

	//가계부 내용 삭제
	@Transactional
	public String delHousehold(long day, long householdCnt, RedirectAttributes rttr) {
		log.info("service - delHousehold()");
		String view = null;
		
		Map<String, Long> hMap = new HashMap<String, Long>();
		hMap.put("planNum", (long)session.getAttribute("curPlan"));
		hMap.put("curDay", day);
		hMap.put("householdCnt", householdCnt);
		
		try {
			//데이터 삭제
			tDao.delHousehold(hMap);
			//남은 데이터 카운트 정렬
			tDao.reduceHouseholdCnt(hMap);
			
			view = "redirect:pHouseholdFrm?planNum=0";
		} catch (Exception e) {
			e.printStackTrace();
			view = "redirect:pPlanFrm?planNum=0";
		}
		
		return view;
	}

	//예산 등록
	public Map<String, Long> pRegBudget(long planNum, long budget) {
		log.info("service - pRegBudget() - planNum : " + planNum + ", budget : " + budget);
		Map<String, Long> rbMap = new HashMap<String, Long>();
		rbMap.put("planNum", planNum);
		rbMap.put("budget", budget);
		
		try {
			//예산 등록
			tDao.pRegBudget(rbMap);
			//여행 정보 다시불러오기
			Long totalCost = tDao.getBalance(planNum);
			if(totalCost == null) {
				rbMap.put("totalCost", 0L);
				rbMap.put("balance", budget);
			} else {
				rbMap.put("totalCost", totalCost);
				rbMap.put("balance", (budget - totalCost));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return rbMap;
	}

	//체크리스트 페이지로 이동
	public ModelAndView pCheckSupFrm(long planNum, RedirectAttributes rttr) {
		log.info("service - pCheckSupFrm() - planNum : " + planNum);

		long num = (planNum == 0)? (long)session.getAttribute("curPlan") : planNum;
		
		mv = new ModelAndView();
		//여행 정보 가져오기
		TravelPlanDto plan = tDao.getPlan(num);
		
		//권한 체크
		if(memberAuthCheck(plan)) {
			//체크리스트 내용 가져오기
			List<CheckListDto> checklist = tDao.getCheckList(num);
			//체크리스트 카테고리 개수 가져오기
			int categoryNum = tDao.getCategoryNum(num);
			//레이아웃 생성용 뷰 가져오기
			List<ChecklistViewDto> cvList = tDao.getCV(num);
			
			mv.addObject("plan", plan);
			mv.addObject("checklist", checklist);
			mv.addObject("categoryNum", categoryNum);
			mv.addObject("cvList", cvList);
			
			//멤버 카운트
			int memCnt = 0;
			if(!(plan.getT_member1().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member2().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member3().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member4().equals(" "))) {
				memCnt++;
			}
			if(!(plan.getT_member5().equals(" "))) {
				memCnt++;
			}
			
			mv.addObject("memCnt", memCnt);
			
			//초대 리스트 가져오기
			List<InviteDto> iList = tDao.pGetInviteList();
			mv.addObject("iList", iList);
			//새로운 초대 여부 확인
			MemberDto member = (MemberDto)session.getAttribute("member");
			int iCnt = tDao.pCheckInvite(member.getM_id());
			mv.addObject("iCnt", iCnt);
			//현재 일정에 초대중인 멤버 가져오기
			List<InviteDto> waitingList = tDao.pGetWaitingMember(num);
			mv.addObject("waitingList", waitingList);
			mv.setViewName("pCheckSupFrm");
		}
		else {
			mv.setViewName("redirect:/");
			rttr.addFlashAttribute("msg", "접근 권한이 없습니다");
		}
		
		return mv;
	}

	//체크리스트 상태 변경
	public CheckListDto pChangeCheck(long planNum, long category, long itemCnt, long check) {
		log.info("service - pChangeCheck() - planNum : " + planNum + ", category : " + category + ", itemCnt : " + itemCnt + ", check : " + check);
		String result = null;
		
		Map<String, Long> clMap = new HashMap<String, Long>();
		clMap.put("planNum", planNum);
		clMap.put("category", category);
		clMap.put("itemCnt", itemCnt);
		clMap.put("check", check);
		try {
			tDao.pChangeCheck(clMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		CheckListDto checklist = tDao.getACheck(clMap);
		
		return checklist;
	}

	//준비물 추가 페이지 이동
	public ModelAndView pAddCheckItemFrm(long category, String categoryName, long itemCnt) {
		log.info("service - pAddCheckItemFrm() - category : " + category + ", categoryName : " + categoryName + ", itemCnt : " + itemCnt);
		
		mv = new ModelAndView();
		
		mv.addObject("planNum", (long)session.getAttribute("curPlan"));
		mv.addObject("category", category);
		mv.addObject("categoryName", categoryName);
		mv.addObject("itemCnt", itemCnt);
		
		mv.setViewName("pAddCheckItemFrm");
		
		return mv;
	}

	//준비물 추가
	@Transactional
	public String pAddCheckItem(long category, String categoryName, long itemCnt, String itemName, RedirectAttributes rttr) {
		log.info("service - pAddCheckItem() - planNum : " + ", category : " + category + ", categoryName : " + categoryName + ", itemCnt : " + itemCnt + ", itemName : " + itemName);

		CheckListDto checklist = new CheckListDto();
		checklist.setCl_plannum((long)session.getAttribute("curPlan"));
		checklist.setCl_category(category);
		checklist.setCl_categoryname(categoryName);
		checklist.setCl_cnt(itemCnt);
		checklist.setCl_item(itemName);
		
		mv = new ModelAndView();
		
		try {
			tDao.pAddCheckItem(checklist);
			
		} catch (Exception e) {
			e.printStackTrace();
			
		}
		
		return "redirect:pCheckSupFrm?planNum=0";
	}

	//카테고리 추가 페이지 이동
	public ModelAndView pAddCheckCategoryFrm(long category) {
		log.info("service - pAddCheckCategoryFrm() - category : " + category);
		
		mv = new ModelAndView();
		
		mv.addObject("category", category);
		mv.setViewName("pAddCheckCategoryFrm");
		
		return mv;
	}

	//카테고리 추가
	@Transactional
	public String pAddCheckCategory(CheckListDto checklist, RedirectAttributes rttr) {
		log.info("service - pAddCheckCategory()");
		String view = null;
		
		try {
			tDao.pAddCheckItem(checklist);
			
			view = "redirect:pCheckSupFrm?planNum=0";
		} catch (Exception e) {
			e.printStackTrace();
			
			view = "redirect:pAddCheckCategoryFrm?category=" + checklist.getCl_category();
		}
		
		return view;
	}

	//준비물 삭제
	@Transactional
	public String delCheckItem(long category, long itemCnt, RedirectAttributes rttr) {
		log.info("service - delCheckItem() - category : " + category + ", itemCnt : " + itemCnt);
		
		CheckListDto checklist = new CheckListDto();
		checklist.setCl_plannum((long)session.getAttribute("curPlan"));
		checklist.setCl_category(category);
		checklist.setCl_cnt(itemCnt);
		
		try {
			//준비물 삭제
			tDao.delCheckItem(checklist);
			//나머지 준비물 카운트 정렬
			tDao.reduceCheckItemCnt(checklist);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:pCheckSupFrm?planNum=0";
	}

	//카테고리 삭제
	@Transactional
	public String delCheckCategory(long category, RedirectAttributes rttr) {
		log.info("service - delCheckCategory() - category : " + category);
		
		ChecklistViewDto cv = new ChecklistViewDto();
		cv.setCl_plannum((long)session.getAttribute("curPlan"));
		cv.setCl_category(category);
		
		try {
			//카테고리 삭제
			tDao.delCheckCategory(cv);
			//나머지 카테고리 카운트 정렬
			tDao.reduceCheckCategoryCnt(cv);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:pCheckSupFrm?planNum=0";
	}

	
	//준비물 수정
	@Transactional
	public String pEditCheckItem(CheckListDto checklist, RedirectAttributes rttr) {
		log.info("service - pEditCheckItem()");
		
		try {
			//준비물 수정
			tDao.pEditCheckItem(checklist);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:pCheckSupFrm?planNum=0";
	}

	//카테고리 수정
	@Transactional
	public String pEditCheckCategory(CheckListDto checklist, RedirectAttributes rttr) {
		log.info("service - pEditCheckCategory()");
		
		try {
			//카테고리 수정
			tDao.pEditCheckCategory(checklist);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:pCheckSupFrm?planNum=0";
	}

	//일행 초대 페이지 이동
	@Transactional
	public ModelAndView pInviteMemberFrm(String id, String planName) {
		log.info("service - pInviteMemberFrm() - id : " + id + ", planName : " + planName);
		
		InviteDto invite = new InviteDto();
		
		invite.setI_mid(id);
		invite.setI_planname(planName);
		
		//회원 리스트 가져오기
		List<MemberDto> mList = tDao.pGetMemberList();
		
		mv = new ModelAndView();
				
		mv.addObject("invite", invite);
		mv.addObject("mList", mList);
		mv.setViewName("pInviteMemberFrm");
		
		return mv;
	}

	//일행 초대
	public String pInviteMember(InviteDto invite, RedirectAttributes rttr) {
		log.info("service - pInviteMember()");
		
		String msg = null;
		
		//초대 코드 생성
		while(true) {
			long code = (long)(Math.random()*10000000000000L);
			System.out.println("invite code : " + code);
			
			//생성된 중복 검사
			int codeCnt = tDao.checkInviteCode(code);
			
			if(codeCnt == 0) {
				//중복되는 코드가 없으면 코드 사용
				invite.setI_code(code);
				break;
			}
		}
		
		//초대 회원 중복 검사
		int inviteDupCheck = tDao.pCheckInviteId(invite);
		
		TravelPlanDto plan = tDao.getPlan(invite.getI_plannum());
		
		if(inviteDupCheck == 1) {
			msg = "이 일정에 이미 초대중인 회원입니다";
		}
		else if(plan.getT_member1().equals(invite.getI_inviteid()) || plan.getT_member2().equals(invite.getI_inviteid()) || plan.getT_member3().equals(invite.getI_inviteid()) ||
				plan.getT_member4().equals(invite.getI_inviteid()) || plan.getT_member5().equals(invite.getI_inviteid())) {
			msg = "이 일정에 이미 참여중인 회원입니다";
		}
		else if(inviteDupCheck == 0) {
			try {
				
				tDao.pInviteMember(invite);
				
				msg = invite.getI_inviteid() + "님을 일정에 초대하였습니다";
				
			} catch (Exception e) {
				e.printStackTrace();
				
				msg = "초대에 실패하였습니다. 관리자에 문의해주세요";
			}
		}
		
		rttr.addFlashAttribute("msg", msg);
		
		return "redirect:pPlanFrm?planNum=0";
	}

	//초대 승인
	@Transactional
	public String pJoinPlan(long code, long planNum, String id, RedirectAttributes rttr) {
		log.info("service - pJoinPlan() - code : " + code + ", planNum : " + planNum + ", id : " + id);
		
		String msg = null;
		
		InviteDto invite = new InviteDto();
		invite.setI_code(code);
		invite.setI_plannum(planNum);
		invite.setI_inviteid(id);
		
		//초대코드 유효성 검사
		int valid = tDao.pCheckCodeValid(invite);
		
		if(valid == 1) {
			//여행에 빈 멤버 자리 검사
			TravelPlanDto plan = tDao.getPlan(planNum);
			
			msg = plan.getT_planname() + " 에 참여하였습니다.";
			
			try {
				
				if(plan.getT_member1().equals(" ")) {
					//일정에 추가
					tDao.pJoinPlan1(invite);
					//초대코드 삭제
					tDao.pDelInvite(invite);
				}
				else if(plan.getT_member2().equals(" ")) {
					tDao.pJoinPlan2(invite);
					tDao.pDelInvite(invite);
				}
				else if(plan.getT_member3().equals(" ")) {
					tDao.pJoinPlan3(invite);
					tDao.pDelInvite(invite);
							}
				else if(plan.getT_member4().equals(" ")) {
					tDao.pJoinPlan4(invite);
					tDao.pDelInvite(invite);
				}
				else if(plan.getT_member5().equals(" ")) {
					tDao.pJoinPlan5(invite);
					tDao.pDelInvite(invite);
				}
				else {//일행이 5명 다 차있을 시
					msg = "더 이상 참여할 수 없습니다!";
				}
			} catch (Exception e) {
				e.printStackTrace();
				msg = "오류가 발생했습니다";
			}
		}
		
		rttr.addFlashAttribute("msg", msg);
		
		return "redirect:pPlanFrm?planNum=" + planNum;
	}

	//초대 거절
	@Transactional
	public Map<String, List<InviteDto>> pRejectPlan(long code) {
		log.info("service - pRejectPlan() - code : " + code);
		
		Map<String, List<InviteDto>> iMap = null;
		
		try {
			//초대 삭제
			InviteDto invite = new InviteDto();
			invite.setI_code(code);
			tDao.pDelInvite(invite);
			
			//초대 리스트 다시 가져오기
			List<InviteDto> iList = tDao.pGetInviteList();
			
			iMap = new HashMap<String, List<InviteDto>>();
			iMap.put("iList", iList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return iMap;
	}

	//여행 삭제
	@Transactional
	public String pDelPlan(RedirectAttributes rttr) {
		log.info("service - pDelPlan");
		String msg = null;
		
		long planNum = (long)session.getAttribute("curPlan");
		
		try {
			//일정 삭제
			tDao.pDelSchedule(planNum);
			//가계부 삭제
			tDao.pDelHousehold(planNum);
			//체크리스트 삭제
			tDao.pDelChecklist(planNum);
			//여행 삭제
			tDao.pDelPlan(planNum);
			
			msg = "여행을 삭제하였습니다";
		} catch (Exception e) {
			e.printStackTrace();
			msg = "삭제에 실패하였습니다";
		}
		
		MemberDto member = (MemberDto)session.getAttribute("member");
		String id = member.getM_id();
		
		rttr.addFlashAttribute("msg", msg);
		
		return "redirect:pPlanList?id=" + id;
	}

	//여행 정보 수정 페이지 이동
	public ModelAndView pEditPlanFrm() {
		log.info("service - pEditPlanFrm()");
		
		mv = new ModelAndView();
		
		TravelPlanDto plan = tDao.getPlan((long)session.getAttribute("curPlan"));
		
		mv.addObject("plan", plan);
		mv.setViewName("pEditPlanFrm");
		
		return mv;
	}

	//여행 정보 수정
	@Transactional
	public String pEditPlan(TravelPlanDto plan, RedirectAttributes rttr) {
		log.info("service - pEditPlan()");
		String msg = null;
		
		plan.setT_plannum((long)session.getAttribute("curPlan"));
		try {
			//정보 수정
			tDao.pEditPlan(plan);
			//새로운 날짜 차이
			long newDays = getTime(plan.getT_stdate(), plan.getT_bkdate());
			System.out.println(newDays);
			//기간을 초과하는 일정 정보 삭제
			tDao.pDelOverDate(newDays);
			//기간을 초과하는 가계부 정보 삭제
			tDao.pDelOverHousehold(newDays);
			
			msg = "정보가 수정되었습니다";
		} catch (Exception e) {
			e.printStackTrace();
			
			msg = "수정에 실패하였습니다";
		}
		
		rttr.addFlashAttribute("msg", msg);
		return "redirect:pPlanFrm?planNum=0";
	}

	//초대 취소
	@Transactional
	public String pCancelInvite(long planNum, String id, RedirectAttributes rttr) {
		log.info("service - pCancelInvite() - planNum : " + planNum + ", id : " + id);
		
		InviteDto invite = new InviteDto();
		invite.setI_plannum(planNum);
		invite.setI_inviteid(id);
		
		try {
			tDao.pCancelInvite(invite);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:pPlanFrm?planNum=0";
	}

	//회원 내보내기
	@Transactional
	public String pDepMember(long planNum, String member, RedirectAttributes rttr) {
		log.info("service - pDepMember() - planNum : " + planNum + ", member : " + member);
		String msg = null;
		
		try {
			//일행 삭제
			switch (member) {
			case "member1":
				tDao.pDepmember1(planNum);
				break;
			case "member2":
				tDao.pDepmember2(planNum);			
				break;
			case "member3":
				tDao.pDepmember3(planNum);
				break;
			case "member4":
				tDao.pDepmember4(planNum);
				break;
			case "member5":
				tDao.pDepmember5(planNum);
				break;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			msg = "오류가 발생했습니다";
		}
		
		rttr.addFlashAttribute("msg", msg);
		return "redirect:pPlanFrm?planNum=0";
	}

	//여행에서 나가기
	@Transactional
	public String pExitPlan(RedirectAttributes rttr) {
		log.info("service - pExitPlan()");
		
		String msg = null;
		
		TravelPlanDto plan = tDao.getPlan((long)session.getAttribute("curPlan"));
		MemberDto member = (MemberDto)session.getAttribute("member");
		String id = member.getM_id();
		
		try {
			if(plan.getT_member1().equals(id)) {
				tDao.pDepmember1(plan.getT_plannum());
			}
			else if(plan.getT_member2().equals(id)) {
				tDao.pDepmember2(plan.getT_plannum());
			}
			else if(plan.getT_member3().equals(id)) {
				tDao.pDepmember3(plan.getT_plannum());
			}
			else if(plan.getT_member4().equals(id)) {
				tDao.pDepmember4(plan.getT_plannum());
			}
			else if(plan.getT_member5().equals(id)) {
				tDao.pDepmember5(plan.getT_plannum());
			}
			msg = "여행에서 탈퇴하였습니다";
		} catch (Exception e) {
			e.printStackTrace();
			msg = "오류가 발생했습니다";
		}
		
		rttr.addFlashAttribute("msg", msg);
		return "redirect:pPlanList?id=" + id;
	}
	
	//권한검사
	public boolean memberAuthCheck(TravelPlanDto plan) {
		log.info("pMemberAuthCheck()");
		
		String leader = plan.getT_id();
		String m1 = plan.getT_member1();
		String m2 = plan.getT_member2();
		String m3 = plan.getT_member3();
		String m4 = plan.getT_member4();
		String m5 = plan.getT_member5();
		
		MemberDto m = (MemberDto)session.getAttribute("member");
		String id = m.getM_id();
		
		if(id.equals(leader) || id.equals(m1) || id.equals(m2) || id.equals(m3) || id.equals(m4) || id.equals(m5)) {
			return true;
		}
		else {
			return false;
		}
	}
}
