<img width="200" alt="logo_tp_final01" src="https://user-images.githubusercontent.com/26563226/106992922-e47f6980-67bc-11eb-9461-d4e39bbb036f.png"></img>
===
프로젝트 소개
---
STEPY는 여행을 할 때 예약을 하는 과정과, 일정을 만들고 관리하는 기능, 그리고 정보를 공유하는 커뮤니티 기능을 하나로 통합하여 이용할 수 있도록 제작한 프로젝트 입니다.

개발 환경
---
* 언어 - JAVA / JavaScript / HTML
* IDE - Eclipse
* 프레임워크 - Spring Framework
* 웹 서버 - Apache Tomcat 9.0
* 주요 라이브러리 - JQuery / JSON / Apache Commons / MyBatis
* DB 설계 - Oracle SQL Developer
* 버전 관리 - Github

주요 역할 및 기능 실행 화면
---
### 1. 여행 일정 페이지<br>   
#### **일정 페이지 메인**
```javascript
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
```
![일정 메인](https://user-images.githubusercontent.com/26563226/107020303-0d682480-67e6-11eb-8fa3-b66bfdcff85b.JPG)
<br><br>
#### **여행 일정 생성**
```javascript
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
```
![여행 생성](https://user-images.githubusercontent.com/26563226/107020120-d134c400-67e5-11eb-9319-82ccdccedfca.gif)
<br><br>
#### **여행 일정 추가**
```javascript
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
```
![일정 추가](https://user-images.githubusercontent.com/26563226/107021864-017d6200-67e8-11eb-9376-4a7cd2591873.gif)
<br><br>
#### **여행 일정 수정** 
```javascript
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
```  
![일정 수정](https://user-images.githubusercontent.com/26563226/107021939-1c4fd680-67e8-11eb-8cca-591375546f96.gif)
<br><br>
```javascript
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
```
![일정 삭제](https://user-images.githubusercontent.com/26563226/107003085-8f991e80-67cf-11eb-97d9-7bdb779de5d2.gif)
*****
### 2. 가계부 페이지<br>    
```javascript
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
```
![가계부 페이지](https://user-images.githubusercontent.com/26563226/107003896-d50a1b80-67d0-11eb-8620-c473552ea576.JPG)
<br><br>
#### **비용 추가** 
```javascript
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
```
![비용 추가](https://user-images.githubusercontent.com/26563226/107004967-675eef00-67d2-11eb-8543-cfbb8f37f44b.gif)
<br><br>
#### **비용 수정** 
```javascript
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
```
![비용 수정](https://user-images.githubusercontent.com/26563226/107010307-844af080-67d9-11eb-9b0d-2f47cff2071f.gif)
<br><br>
#### **비용 삭제** 
```javascript
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
```
![비용 삭제](https://user-images.githubusercontent.com/26563226/107011265-c3c60c80-67da-11eb-8baa-5c1d8cef7b6e.gif)
<br><br>
#### **예산 설정 및 확인**
```javascript
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
```
![예산 설정](https://user-images.githubusercontent.com/26563226/107011909-a9d8f980-67db-11eb-9ccd-cd52681054f3.gif)
*****
### 3. 체크리스트 페이지<br>
```javascript
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
```
![체크리스트 메인](https://user-images.githubusercontent.com/26563226/107019738-5f5c7a80-67e5-11eb-9d74-5097f152da86.JPG)
<br><br>
#### **준비물 추가** 
```javascript
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
```
![준비물 추가](https://user-images.githubusercontent.com/26563226/107020421-2f61a700-67e6-11eb-9de0-69760a17e1e6.gif)
<br><br>
#### **카테고리 추가**
```javascript
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
```
![카테고리 추가](https://user-images.githubusercontent.com/26563226/107020765-9c753c80-67e6-11eb-8694-3429590ff01b.gif)
<br><br>
#### **준비물 수정**
```javascript
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
```
![준비물 수정](https://user-images.githubusercontent.com/26563226/107020426-3092d400-67e6-11eb-881c-cae102037ad5.gif)
<br><br>
#### **카테고리 수정**
```javascript
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
```
![카테고리 수정](https://user-images.githubusercontent.com/26563226/107020759-9b440f80-67e6-11eb-89b4-892e14ab49c0.gif)
<br><br>
#### **준비물 삭제**
```javascript
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
```
![준비물 삭제](https://user-images.githubusercontent.com/26563226/107020432-31c40100-67e6-11eb-9981-9bc83bff48aa.gif)
<br><br>
#### **카테고리 삭제**
```javascript
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
```
![카테고리 삭제](https://user-images.githubusercontent.com/26563226/107020767-9da66980-67e6-11eb-8b0f-7610907a1e3a.gif)
<br><br>
#### **체크리스트 상태 변경**
```javascript
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
```
![준비물 체크](https://user-images.githubusercontent.com/26563226/107021310-51a7f480-67e7-11eb-95b3-2121eec21f20.gif)
<br><br>
