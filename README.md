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
##### - 여행의 이름, 장소, 기간 등을 선택하여 여행을 생성합니다.
##### - datepicker를 활용해 출발일과 도착일이 각각 범위를 벗어나지 못하도록 처리하였습니다.
##### - 여행을 생성함과 동시에 생성된 여행 번호가 session에 저장되고 일정 관리 페이지로 이동합니다.
##### - 여행을 생성하면 선택한 기간만큼 자동으로 DAY항목을 생성합니다.
##### - 일정 추가 버튼을 통해 데이터 베이스에 등록되어있는 매장 이름을 검색하여 선택이 가능처리하였습니다.
##### - 생성된 일정 내용에 마우스 오버시 수정과 삭제 버튼이 생성되며 각각의 기능을 처리하도록 하였습니다.
****
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
#### **여행 일정 삭제** 
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
##### - JSTL을 활용하여 선택한 기간에 해당하는 일 수 만큼 여행 준비 단계를 포함한 가계부 항목이 자동으로 생성됩니다.
##### - 비용 추가 버튼을 통해 가계부 내용 작성 페이지로 이동하며 날짜, 항목, 내용, 금액, 장소를 입력할 수 있습니다.
##### - 자바스크립트를 이용하여 금액 입력란에는 숫자만 입력 가능 및 입력 시 1,000 단위로 콤마 표시가 되도록 처리하였습니다.
##### - 장소 입력 시 글자수 입력을 50자로 제한하였습니다.
##### - 가계부 메인 화면에서 추가된 항목들의 항목, 내용, 비용, 장소를 확인 할 수 있습니다.
##### - 장소 입력란 클릭 시 팝업 창이 뜨며 매장 이름을 검색하여 선택할 수 있도록 처리하였습니다.
##### - 가계부 각 내용을 클릭하여 내용 수정이 가능합니다.
##### - 화면 좌측에 슬라이드 메뉴를 제작하여 여행 예산을 등록 및 변경 가능합니다.
##### - 슬라이드 메뉴에서 추가된 비용의 총 합계를 확인 가능하며 설정된 예산에서 남은 예산을 자동으로 계산하여 보여주도록 하고, 결과가 +일 시 푸른색 바탕, -일 시 붉은색 바탕으로 변하도록 처리하였습니다.
****
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
##### - 페이지에서 카테고리와 준비물을 각각 추가 가능합니다.
##### - 생성된 카테고리와 준비물은 각 메뉴에 마우스 오버시 수정과 삭제 메뉴가 나타나며 이를 클릭하여 수장과 삭제가 가능하도록 처리하였습니다.
##### - 카테고리와 준비물은 각각 미리 지정된 항목을 선택 가능하며 직접 입력도 가능하도록 처리하였습니다.
##### - 직접 입력 시 글자수 입력은 20자로 제한하였습니다.
##### - 준비물에 체크하면 ajax를 통해 따로 저장 버튼 등을 누르지 않더라도 데이터베이스에 변경사항 저장하도록 처리하였습니다.
****
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
*****
### 4. 일정 관리 기능<br>
##### - 생성한 일정페이지에서 아이디로 회원을 검색해 여행에 일행으로 초대가 가능합니다.
##### - 또한 초대 중인 회원을 클릭해 회원을 취소 할 수 있습니다.
##### - 초대를 받은 회원은 일정 페이지 접속 시 우측 하단에 알림창을 띄워 승인과 거절을 선택할 수 있도록 처리하였습니다.
##### - 현재 여행에 참여 중인 회원과 초대 중인 회원 목록을 확인 가능합니다.
##### - 여행을 생성한 회원만 참여 중인 회원을 클릭해 내보내기 가능하도록 처리하였습니다.
##### - 여행 정보 수정은 같은 일정에 참여중인 모든 회원이 접근 할 수 있도록 처리하였습니다.
##### - 여행을 생성한 회원만이 여행 삭제가 가능하고 그 이외의 회원은 여행에서 나가기 기능이 활성화 되도록 처리하였습니다.
****
#### **일행 초대**
```javascript
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
```
![일행 초대](https://user-images.githubusercontent.com/26563226/107022904-4655c880-67e9-11eb-9f65-7fc04f3551b0.gif)
<br><br>
#### **초대 취소**
```javascript
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
```
![일행 초대 취소](https://user-images.githubusercontent.com/26563226/107022912-481f8c00-67e9-11eb-9437-5e62637f3988.gif)
<br><br>
#### **초대 승인 및 초대 거절**
```javascript
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
```
![초대 승인](https://user-images.githubusercontent.com/26563226/107022927-4bb31300-67e9-11eb-8245-9e3f8be5ea67.gif)
![초대 거절](https://user-images.githubusercontent.com/26563226/107022932-4ce44000-67e9-11eb-9e8a-97a34f2f0b74.gif)
<br><br>
#### **여행 수정**
```javascript
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
```
![여행 수정](https://user-images.githubusercontent.com/26563226/107023391-e6abed00-67e9-11eb-8126-d0be6491ef50.gif)
<br><br>
#### **회원 내보내기**
```javascript
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
```
![회원 내보내기](https://user-images.githubusercontent.com/26563226/107022949-52418a80-67e9-11eb-828a-1d92623b4530.gif)
<br><br>
#### **여행에서 나가기**
```javascript
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
```
![여행에서 나가기](https://user-images.githubusercontent.com/26563226/107022959-54a3e480-67e9-11eb-84e0-99ce109b94f1.gif)
<br><br>
#### **여행 삭제**
```javascript
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
```
![여행 삭제](https://user-images.githubusercontent.com/26563226/107022973-58d00200-67e9-11eb-9970-45ee6e26a3f6.gif)
<br><br>
Controller 구성
---
```javascript
package com.bob.stepy;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bob.stepy.dto.AccompanyPlanDto;
import com.bob.stepy.dto.CheckListDto;
import com.bob.stepy.dto.HouseholdDto;
import com.bob.stepy.dto.InviteDto;
import com.bob.stepy.dto.TravelPlanDto;
import com.bob.stepy.service.TravelPlanService;

import lombok.extern.java.Log;

@Controller
@Log
public class TravelPlanController {
	
	@Autowired
	TravelPlanService tServ;
	
	ModelAndView mv;
	
	//여행 만들기 페이지 이동
	@GetMapping("pMakePlanFrm")
	public String pMakePlanFrm() {
		log.info("controller - pMakePlanFrm()");
		
		return "pMakePlanFrm";
	}
	
	//여행 등록
	@PostMapping("pRegPlan")
	public ModelAndView pRegPlan(TravelPlanDto plan, RedirectAttributes rttr) {
		log.info("controller - pRegPlan()");
		
		return tServ.pRegPlan(plan, rttr);
	}
	
	//여행 목록 페이지 이동
	@GetMapping("pPlanList")
	public ModelAndView pPlanList(String id) {
		log.info("controller - pPlanList()");
		//여행 정보 가져오기
		mv = tServ.pPlanList(id);
		
		return mv;
	}
	
	//일정 페이지 이동
	@GetMapping("pPlanFrm")
	public ModelAndView pPlanFrm(long planNum, RedirectAttributes rttr) {
		log.info("controller - pPlanFrm()");
		
		return tServ.pPlanFrm(planNum, rttr);
	}
	
	//장소 검색 페이지 이동
	@GetMapping("pStoreSearch")
	public ModelAndView pStoreSearch(long day, long planCnt) {
		log.info("controller - pStoreSearch()");
		
		return tServ.pStoreSearch(day, planCnt);
	}
	
	//여행 내용 등록
	@GetMapping("RegAccompanyPlan")
	public String RegAccompanyPlan(AccompanyPlanDto acPlan, RedirectAttributes rttr) {
		log.info("controller - RegAccompanyPlan()");
		
		return tServ.RegAccompanyPlan(acPlan, rttr);
	}
	
	//여행 내용 삭제
	@GetMapping("delAccompanyPlan")
	public String delAccompanyPlan(long day, long num, RedirectAttributes rttr) {
		log.info("controller - delAccompanyPlan() -  day : " + day + ", num : " + num);
		
		return tServ.delAccompanyPlan(day, num, rttr);
	}
	
	//여행 내용 수정 페이지 이동
	@GetMapping("pEditAccompanyPlanFrm")
	public ModelAndView pEditAccompanyPlanFrm(long day, long planCnt) {
		log.info("controller - editAccompanyPlanFrm() - day : " + day +  ", planCnt : " + planCnt);
		
		return tServ.pEditAccompanyPlanFrm(day, planCnt);
	}
	//여행 내용 수정
	@GetMapping("pEditAccompanyPlan")
	public String pEditAccompanyPlan(AccompanyPlanDto acPlan, RedirectAttributes rttr) {
		log.info("controller - pEditAccompanyPlan()");
		
		return tServ.pEditAccompanyPlan(acPlan, rttr);
	}
	
	//가계부 페이지 이동
	@GetMapping("pHouseholdFrm")
	public ModelAndView pHouseholdFrm(long planNum, RedirectAttributes rttr) {
		log.info("controller - pHouseholdFrm()");
		
		return tServ.pHouseholdFrm(planNum, rttr);
	}
	
	//가계부 내용 작성 페이지 이동
	@GetMapping("pWriteHousehold")
	public ModelAndView pWriteHousehold(long householdCnt, long days, long dayCnt) {
		log.info("controller - pWriteHousehold() - householdCnt : " + householdCnt + ", days : " + days + " , dayCnt : " + dayCnt);
		
		return tServ.pWriteHousehold(householdCnt, days, dayCnt);
	}
	
	//가계부 내용 등록
	@GetMapping("regHousehold")
	public String regHousehold(HouseholdDto household, RedirectAttributes rttr) {
		log.info("controller - regHousehold()");
		
		return tServ.regHousehold(household, rttr);
	}
	
	//가계부 수정 페이지 이동
	@GetMapping("pModHouseholdFrm")
	public ModelAndView pModHouseholdFrm(long days, long dayCnt, long householdCnt) {
		log.info("controller - pModHouseholdFrm()");
		
		return tServ.pModHouseholdFrm(days, dayCnt, householdCnt);
	}
	
	//가계부 내용 수정
	@GetMapping("modHousehold")
	public String ModHousehold(HouseholdDto household, RedirectAttributes rttr) {
		log.info("controller - modHousehold()");
		
		return tServ.modHousehold(household, rttr);
	}
	
	//가계부 내용 삭제
	@GetMapping("delHousehold")
	public String delHousehold(long day, long householdCnt, RedirectAttributes rttr) {
		log.info("contorller - delHousehold()");
		
		return tServ.delHousehold(day, householdCnt, rttr);
	}
	
	//예산 입력
	@PostMapping(value = "pRegBudget", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Long> pRegBudget(long planNum, long budget){
		log.info("controller - tServ.pRegBudget() - planNum : " + planNum + ", budget : " + budget);
		
		return tServ.pRegBudget(planNum, budget);
	}
	
	//체크리스트 페이지 이동
	@GetMapping("pCheckSupFrm")
	public ModelAndView pCheckSupFrm(long planNum, RedirectAttributes rttr) {
		log.info("controller - pCheckSupFrm()");
		
		return tServ.pCheckSupFrm(planNum, rttr);
	}
	
	//체크리스트 상태 변경
	@PostMapping(value = "pChangeCheck", produces = "application/json; charset=utf-8")
	@ResponseBody
	public CheckListDto pChangeCheck(long planNum, long category, long itemCnt, long check) {
		log.info("controller - pChangeCheck() - planNum : " + planNum + ", category : " + category + ", itemCnt : " + itemCnt + ", check : " + check);
		
		return tServ.pChangeCheck(planNum, category, itemCnt, check);
	}
	
	//준비물 추가 페이지 이동
	@GetMapping("pAddCheckItemFrm")
	public ModelAndView pAddCheckItemFrm(long category, String categoryName, long itemCnt) {
		log.info("controller - pAddCheckItemFrm() - category : " + category + ", categoryName : " + categoryName + ", itemCnt : " + itemCnt);
		
		return tServ.pAddCheckItemFrm(category, categoryName, itemCnt);
	}
	
	//준비물 추가
	@GetMapping("pAddCheckItem")
	public String pAddCheckItem(long category, String categoryName, long itemCnt, String itemName, RedirectAttributes rttr) {
		log.info("controller - pAddCheckItem() - category : " + category + ", categoryName : " + categoryName + ", itemCnt : " + itemCnt + ", itemName : " + itemName);
		
		return tServ.pAddCheckItem(category, categoryName, itemCnt, itemName, rttr);
	}
	
	//카테고리 추가 페이지 이동
	@GetMapping("pAddCheckCategoryFrm")
	public ModelAndView pAddCheckCategoryFrm(long category) {
		log.info("controller - pAddCheckCategoryFrm() - category : " + category);
		
		return tServ.pAddCheckCategoryFrm(category);
	}
	
	//카테고리 추가
	@GetMapping("pAddCheckCategory")
	public String pAddCheckCategory(CheckListDto checklist, RedirectAttributes rttr) {
		log.info("controller - pAddCheckCategory()");
		
		return tServ.pAddCheckCategory(checklist, rttr);
	}
	
	//준비물 삭제
	@GetMapping("delCheckItem")
	public String delCheckItem(long category, long itemCnt, RedirectAttributes rttr) {
		log.info("controller - delCheckItem() - category : " + category + ", itemCnt : " + itemCnt);
		
		return tServ.delCheckItem(category, itemCnt, rttr);
	}
	
	//카테고리 삭제
	@GetMapping("delCheckCategory")
	public String delCheckCategory(long category, RedirectAttributes rttr) {
		log.info("controller - delCheckCategory() - category : " + category); 
		
		return tServ.delCheckCategory(category, rttr);
	}
	
	//준비물 수정
	@GetMapping("pEditCheckItem")
	public String pEditCheckItem(CheckListDto checklist, RedirectAttributes rttr) {
		log.info("controller - pEditCheckItem()");
		
		return tServ.pEditCheckItem(checklist, rttr);
	}
	
	//카테고리 수정
	@GetMapping("pEditCheckCategory")
	public String pEditCheckCategory(CheckListDto checklist, RedirectAttributes rttr) {
		log.info("controller - pEditCheckCategory()");
		
		return tServ.pEditCheckCategory(checklist, rttr);
	}
	
	//일행 초대 페이지 이동
	@GetMapping("pInviteMemberFrm")
	public ModelAndView pInviteMemberFrm(String id, String planName) {
		log.info("controller - pInviteMemberFrm() - id : " + id +  ", planName : " + planName);
		
		return tServ.pInviteMemberFrm(id, planName);
	}
	
	//일행 초대
	@PostMapping("pInviteMember")
	public String pInviteMember(InviteDto invite, RedirectAttributes rttr) {
		log.info("contorller - pInviteMember()");
		
		return tServ.pInviteMember(invite, rttr);
	}
	
	//초대 승인
	@GetMapping("pJoinPlan")
	public String pJoinPlan(long code, long planNum, String id, RedirectAttributes rttr) {
		log.info("controller - pJoinPlan() - code : " + code + ", planNum : " + planNum + ", id : " + id);
		
		return tServ.pJoinPlan(code, planNum, id, rttr);
	}
	
	//초대 거절
	@PostMapping(value = "pRejectPlan", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, List<InviteDto>> pRejectPlan(long code) {
		log.info("controller - pRejectPlan() - code : " + code);
		
		return tServ.pRejectPlan(code);
	}
	
	//여행 삭제
	@GetMapping("pDelPlan")
	public String pDelPlan(RedirectAttributes rttr) {
		log.info("controller - pDelPlan()");
		
		return tServ.pDelPlan(rttr);
	}
	
	//여행 정보 수정페이지 이동
	@GetMapping("pEditPlanFrm")
	public ModelAndView pEditPlanFrm() {
		log.info("controller - pEditPlanFrm()");
		
		return tServ.pEditPlanFrm();
	}
	
	//여행 정보 수정
	@PostMapping("pEditPlan")
	public String pEditPlan(TravelPlanDto plan, RedirectAttributes rttr) {
		log.info("controller - pEditPlan()");
		
		return tServ.pEditPlan(plan, rttr);
	}
	
	//초대 취소
	@GetMapping("pCancelInvite")
	public String pCancelInvite(long planNum, String id, RedirectAttributes rttr) {
		log.info("controller - pCancelInvite() - planNum : " + planNum + ", id : " + id);
		
		return tServ.pCancelInvite(planNum, id, rttr);
	}
	//회원 내보내기
	@GetMapping("pDepMember")
	public String pDepMember(long planNum, String member, RedirectAttributes rttr) {
		log.info("controller - pDepMember1() - planNum : " + planNum + ", member : " + member);
		
		return tServ.pDepMember(planNum, member, rttr);
	}
	//여행에서 나가기
	@GetMapping("pExitPlan")
	public String pExitPlan(RedirectAttributes rttr) {
		log.info("controller - pExitPlan()");
		
		return tServ.pExitPlan(rttr);
	}
}
```
<br><br>
DAO 구성
---
MyBatis를 사용하여 mappingInterface와 실제 쿼리문이 작성된 mapper.xml로 나누어져 있습니다.
#### **DAO.java**
```javascript
package com.bob.stepy.dao;

import java.util.List;
import java.util.Map;

import com.bob.stepy.dto.AccompanyPlanDto;
import com.bob.stepy.dto.CheckListDto;
import com.bob.stepy.dto.ChecklistViewDto;
import com.bob.stepy.dto.HouseholdDto;
import com.bob.stepy.dto.InviteDto;
import com.bob.stepy.dto.MemberDto;
import com.bob.stepy.dto.StoreDto;
import com.bob.stepy.dto.TravelPlanDto;

public interface TravelPlanDao {
	//여행 일정 등록
	public void pRegPlan(TravelPlanDto plan);
	//여행 일정 리스트 가져오기
	public List<TravelPlanDto> getPlanList(String id);
	//여행 일정 정보 가져오기
	public TravelPlanDto getPlan(long planNum);
	//여행 일정 설정하기
	public void regPlanContents(AccompanyPlanDto acPlan);
	//여행 전체 일수 가져오기
	public int getTravelDays(long planNum);
	//여행 일정 내용 가져오기
	public List<AccompanyPlanDto> getPlanContents(long planNum);
	//가게 정보 가져오기
	public List<StoreDto> getStoreList();
	//여행 내용 등록
	public void regAccompanyPlan(AccompanyPlanDto acPlan);
	//여행 내용 삭제
	public void delAccompanyPlan(Map<String, Long> apMap);
	//여행 내용 수정
	public void pEditAccompanyPlan(AccompanyPlanDto acPlan);
	//여행 번호 카운트 정렬
	public void reduceNumCnt(Map<String, Long> apMap);
	//가계부 내용 등록
	public void regHousehold(HouseholdDto household);
	//가계부 목록 가져오기
	public List<HouseholdDto> getHouseholdList(long planNum);
	//가계부 내용 가져오기
	public HouseholdDto getHouseholdContentes(Map<String, Long> hList);
	//가계부 수정
	public void ModHousehold(HouseholdDto household);
	//가계부 내용 카운트 정렬
	public void reduceHouseholdCnt(Map<String, Long> hMap);
	//가계부 내용 삭제
	public void delHousehold(Map<String, Long> hMap);
	//예산 등록
	public void pRegBudget(Map<String, Long> rbMap);
	//예산 전체 조회
	public Long getBalance(Long planNum);
	//체크리스트 내용 가져오기
	public List<CheckListDto> getCheckList(long planNum);
	//체크리스트 카테고리 개수 가져오기
	public int getCategoryNum(long planNum);
	//체크리스트 레이아웃 생성용 뷰 가져오기
	public List<ChecklistViewDto> getCV(long planNum);
	//체크리스트 상태 변경
	public void pChangeCheck(Map<String, Long> clMap);
	//체크리스트 특정 항목 가져오기
	public CheckListDto getACheck(Map<String, Long> clMap);
	//가입시 준비물 초기 등록
	public void pInitChecklist1(long planNum);
	public void pInitChecklist2(long planNum);
	//준비물 추가하기
	public void pAddCheckItem(CheckListDto checklist);
	//준비물 삭제하기
	public void delCheckItem(CheckListDto checklist);
	//준비물 카운트 정렬하기
	public void reduceCheckItemCnt(CheckListDto checklist);
	//체크리스트 카테고리 삭제하기
	public void delCheckCategory(ChecklistViewDto cv);
	//체크리스트 카테고리 정렬하기
	public void reduceCheckCategoryCnt(ChecklistViewDto cv);
	//준비물 수정하기
	public void pEditCheckItem(CheckListDto checklist);
	//카테고리 수정하기
	public void pEditCheckCategory(CheckListDto checklist);
	//초대코드 중복검사
	public int checkInviteCode(long code);
	//일행 초대 등록
	public void pInviteMember(InviteDto invite);
	//회원 리스트 가져오기
	public List<MemberDto> pGetMemberList();
	//초대 리스트 가져오기
	public List<InviteDto> pGetInviteList();
	//초대 여부 확인 카운트
	public int pCheckInvite(String id);
	//초대 유효성 검사
	public int pCheckCodeValid(InviteDto invite);
	//일행 추가
	public void pJoinPlan1(InviteDto invite);
	public void pJoinPlan2(InviteDto invite);
	public void pJoinPlan3(InviteDto invite);
	public void pJoinPlan4(InviteDto invite);
	public void pJoinPlan5(InviteDto invite);
	//초대 삭제
	public void pDelInvite(InviteDto invite);
	//초대 회원 중복 검사
	public int pCheckInviteId(InviteDto invite);
	//여행 삭제
	public void pDelPlan(long planNum);
	//여행 삭제시 일정 삭제
	public void pDelSchedule(long planNum);
	//여행 삭제시 가계부 삭제
	public void pDelHousehold(long planNum);
	//여행 삭제시 체크리스트 삭제
	public void pDelChecklist(long planNum);
	//여행 정보 수정
	public void pEditPlan(TravelPlanDto plan);
	//기간 초과 일정 정보 삭제
	public void pDelOverDate(long newDays);
	//기간 초과 가계부 정보 삭제
	public void pDelOverHousehold(long newDays);
	//현재 일정에 초대중인 멤버 가져오기
	public List<InviteDto> pGetWaitingMember(long planNum);
	//초대 취소
	public void pCancelInvite(InviteDto invite);
	//회원 내보내기
	public void pDepmember1(long planNum);
	public void pDepmember2(long planNum);
	public void pDepmember3(long planNum);
	public void pDepmember4(long planNum);
	public void pDepmember5(long planNum);
}
```
#### **DAO.xml**
```java
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper 
   PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
   "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
 
<mapper namespace="com.bob.stepy.dao.TravelPlanDao">
	<!-- 여행 일정 등록 -->
	<insert id="pRegPlan" parameterType="com.bob.stepy.dto.TravelPlanDto">
		INSERT INTO T
		VALUES (#{t_plannum},#{t_planname},#{t_id},#{t_spot},#{t_stdate},#{t_bkdate},DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT)
	</insert>
	<!-- 여행 일정 리스트 가져오기 -->
	<select id="getPlanList" parameterType="String" resultType="com.bob.stepy.dto.TravelPlanDto">
		SELECT * FROM T
		WHERE T_ID=#{id} OR T_MEMBER1=#{id} OR T_MEMBER2=#{id} OR T_MEMBER3=#{id} OR T_MEMBER4=#{id} OR T_MEMBER5=#{id}
	</select>
	<!-- 여행 일정 정보 가져오기 -->
	<select id="getPlan" parameterType="long" resultType="com.bob.stepy.dto.TravelPlanDto">
		SELECT * FROM T
		WHERE T_PLANNUM=#{planNum}
	</select>
	<!-- 여행 일정 설정하기 -->
	<insert id="regPlanContents" parameterType="com.bob.stepy.dto.AccompanyPlanDto">
		INSERT INTO AP (AP_PLANNUM, AP_MID, AP_DAY)
		VALUES (#{ap_plannum},#{ap_mid},#{ap_day})
	</insert>
	<!-- 여행 전체 일수 가져오기 -->
	<select id="getTravelDays" parameterType="long" resultType="int">
		SELECT DISTINCT COUNT(AP_DAY) FROM AP
		WHERE AP_PLANNUM=#{planNum}
	</select>
	<!-- 여행 일정 내용 가져오기 -->
	<select id="getPlanContents" parameterType="long" resultType="com.bob.stepy.dto.AccompanyPlanDto">
		SELECT * FROM AP
		WHERE AP_PLANNUM=#{planNum} ORDER BY AP_PLANCNT
	</select>
	<!-- 가게 정보 가져오기 -->
	<select id="getStoreList" resultType="com.bob.stepy.dto.StoreDto">
		SELECT S_NUM, S_NAME FROM S
	</select>
	<!-- 여행 내용 등록 -->
	<insert id="regAccompanyPlan" parameterType="com.bob.stepy.dto.AccompanyPlanDto">
		INSERT INTO AP
		VALUES (#{ap_plannum},#{ap_mid},#{ap_day},#{ap_plancnt}, #{ap_contents})
	</insert>
	<!-- 여행 내용 삭제 -->
	<delete id="delAccompanyPlan" parameterType="HashMap">
		DELETE FROM AP
		WHERE AP_PLANNUM=#{planNum} AND AP_DAY=#{day} AND AP_PLANCNT=#{num}
	</delete>
	<!-- 여행 내용 수정 -->
	<update id="pEditAccompanyPlan" parameterType="com.bob.stepy.dto.AccompanyPlanDto">
		UPDATE AP
		SET AP_CONTENTS=#{ap_contents}
		WHERE AP_PLANNUM=#{ap_plannum} AND AP_DAY=#{ap_day} AND AP_PLANCNT=#{ap_plancnt}
	</update>
	<!-- 여행 번호 카운트 정렬 -->
	<update id="reduceNumCnt" parameterType="HashMap">
		UPDATE AP
		SET AP_PLANCNT=AP_PLANCNT-1
		WHERE AP_PLANNUM=#{planNum} AND AP_DAY=#{day} AND AP_PLANCNT>#{num}
	</update>
	<!-- 가계부 내용 등록 -->
	<insert id="regHousehold" parameterType="com.bob.stepy.dto.HouseholdDto" useGeneratedKeys="true" keyProperty="h_changecnt">
	<selectKey keyProperty="h_changecnt" resultType="long" order="BEFORE">
		SELECT COUNT(*)+1 FROM H
		WHERE H_PLANNUM=#{h_plannum} AND H_DAY=#{h_day}
	</selectKey>
		INSERT INTO H
		VALUES (#{h_plannum},#{h_day},#{h_changecnt},#{h_mid},#{h_cost},#{h_category},#{h_contents},#{h_sname},DEFAULT,DEFAULT)
	</insert>
	<!-- 가계부 목록 가져오기 -->
	<select id="getHouseholdList" resultType="com.bob.stepy.dto.HouseholdDto">
		SELECT * FROM H
		WHERE H_PLANNUM=#{planNum} ORDER BY H_CNT
	</select>
	<!-- 가계부 내용 가져오기 -->
	<select id="getHouseholdContentes" parameterType="HashMap" resultType="com.bob.stepy.dto.HouseholdDto">
		SELECT * FROM H
		WHERE H_PLANNUM=#{planNum} AND H_DAY=#{day} AND H_CNT=#{householdCnt}
	</select>
	<!-- 가계부 내용 수정 -->
	<update id="ModHousehold" parameterType="com.bob.stepy.dto.HouseholdDto" useGeneratedKeys="true" keyProperty="h_changecnt">
	<selectKey keyProperty="h_changecnt" resultType="long" order="BEFORE">
		SELECT COUNT(*)+1 FROM H
		WHERE H_PLANNUM=#{h_plannum} AND H_DAY=#{h_day}
	</selectKey>
		UPDATE H
		SET H_PLANNUM=#{h_plannum},H_DAY=#{h_day},H_CNT=#{h_changecnt},H_MID=#{h_mid},H_COST=#{h_cost},H_CATEGORY=#{h_category},H_CONTENTS=#{h_contents},H_SNAME=#{h_sname},H_CURDAY=DEFAULT,H_CHANGECNT=DEFAULT
		WHERE H_PLANNUM=#{h_plannum} AND H_DAY=#{h_curday} AND H_CNT=#{h_cnt}
	</update>
	<!-- 가계부 내용 카운트 정렬 -->
	<update id="reduceHouseholdCnt" parameterType="HashMap">
		UPDATE H
		SET H_CNT=H_CNT-1
		WHERE H_PLANNUM=#{planNum} AND H_DAY=#{curDay} AND H_CNT>#{householdCnt}
	</update>
	<!-- 가계부 내용 삭제 -->
	<delete id="delHousehold" parameterType="HashMap">
		DELETE H
		WHERE H_PLANNUM=#{planNum} AND H_DAY=#{curDay} AND H_CNT=#{householdCnt}
	</delete>
	<!-- 예산 등록 -->
	<update id="pRegBudget" parameterType="HashMap">
		UPDATE T
		SET T_BUDGET=#{budget}
		WHERE T_PLANNUM=#{planNum}
	</update>
	<!-- 예산 조회 -->
	<select id="getBalance" parameterType="Long" resultType="Long">
		SELECT H_TOTALCOST
		FROM B
		WHERE H_PLANNUM=#{planNum}
	</select>
	<!-- 체크리스트 내용 가져오기 -->
	<select id="getCheckList" parameterType="long" resultType="com.bob.stepy.dto.CheckListDto">
		SELECT * FROM CL
		WHERE CL_PLANNUM=#{planNum} ORDER BY CL_CATEGORY,CL_CNT
	</select>
	<!-- 체크리스트 카테고리 개수 가져오기 -->
	<select id="getCategoryNum" parameterType="long" resultType="int">
		SELECT COUNT(CL_CATEGORY)
		FROM CV
		WHERE CL_PLANNUM=#{planNum}
	</select>
	<!-- 체크리스트용 뷰 가져오기 -->
	<select id="getCV" parameterType="long" resultType="com.bob.stepy.dto.ChecklistViewDto">
		SELECT * FROM CV
		WHERE CL_PLANNUM=#{planNum} ORDER BY CL_CATEGORY
	</select>
	<!-- 체크리스트 상태 변경 -->
	<update id="pChangeCheck" parameterType="HashMap">
		UPDATE CL
		SET CL_CHECK=#{check}
		WHERE CL_PLANNUM=#{planNum} AND CL_CATEGORY=#{category} AND CL_CNT=#{itemCnt}
	</update>
	<!-- 체크리스트 특정 항목 가져오기 -->
	<select id="getACheck" parameterType="HashMap" resultType="com.bob.stepy.dto.CheckListDto">
		SELECT * FROM CL
		WHERE CL_PLANNUM=#{planNum} AND CL_CATEGORY=#{category} AND CL_CNT=#{itemCnt}
	</select>
	<!-- 가입시 준비물 초기 등록 -->
	<insert id="pInitChecklist1">
		INSERT INTO CL
		VALUES (#{planNum}, 0, '필수 준비물', 1, '의류', DEFAULT)
	</insert>
	<insert id="pInitChecklist2">
		INSERT INTO CL
		VALUES (#{planNum}, 0, '필수 준비물', 2, '세면용품', DEFAULT)
	</insert>
	<!-- 준비물 추가하기 -->
	<insert id="pAddCheckItem" parameterType="com.bob.stepy.dto.CheckListDto">
		INSERT INTO CL
		VALUES (#{cl_plannum},#{cl_category},#{cl_categoryname},#{cl_cnt},#{cl_item},DEFAULT)
	</insert>
	<!-- 준비물 삭제하기 -->
	<delete id="delCheckItem" parameterType="com.bob.stepy.dto.CheckListDto">
		DELETE CL
		WHERE CL_PLANNUM=#{cl_plannum} AND CL_CATEGORY=#{cl_category} AND CL_CNT=#{cl_cnt}
	</delete>
	<!-- 준비물 카운트 정렬하기 -->
	<update id="reduceCheckItemCnt" parameterType="com.bob.stepy.dto.CheckListDto">
		UPDATE CL
		SET CL_CNT=CL_CNT-1
		WHERE CL_PLANNUM=#{cl_plannum} AND CL_CATEGORY=#{cl_category} AND CL_CNT>#{cl_cnt}
	</update>
	<!-- 체크리스트 카테고리 삭제하기 -->
	<delete id="delCheckCategory" parameterType="com.bob.stepy.dto.ChecklistViewDto">
		DELETE CL
		WHERE CL_PLANNUM=#{cl_plannum} AND CL_CATEGORY=#{cl_category}
	</delete>
	<!-- 체크리스트 카테고리 정렬하기 -->
	<update id="reduceCheckCategoryCnt" parameterType="com.bob.stepy.dto.ChecklistViewDto">
		UPDATE CL
		SET CL_CATEGORY=CL_CATEGORY-1
		WHERE CL_PLANNUM=#{cl_plannum} AND CL_CATEGORY>#{cl_category}
	</update>
	<!-- 준비물 수정하기 -->
	<update id="pEditCheckItem" parameterType="com.bob.stepy.dto.CheckListDto">
		UPDATE CL
		SET CL_ITEM=#{cl_item}
		WHERE CL_PLANNUM=#{cl_plannum} AND CL_CATEGORY=#{cl_category} AND CL_CNT=#{cl_cnt}
	</update>
	<!-- 카테고리 수정하기 -->
	<update id="pEditCheckCategory" parameterType="com.bob.stepy.dto.CheckListDto">
		UPDATE CL
		SET CL_CATEGORYNAME=#{cl_categoryname}
		WHERE CL_PLANNUM=#{cl_plannum} AND CL_CATEGORY=#{cl_category}
	</update>
	<!-- 초대코드 중복검사 -->
	<select id="checkInviteCode" parameterType="long" resultType="int">
		SELECT COUNT(*) FROM I
		WHERE I_CODE=#{code}
	</select>
	<!-- 일행 초대 등록 -->
	<insert id="pInviteMember" parameterType="com.bob.stepy.dto.InviteDto">
		INSERT INTO I
		VALUES (#{i_code},#{i_plannum},#{i_mid},#{i_planname},#{i_inviteid})
	</insert>
	<!-- 회원 리스트 가져오기 -->
	<select id="pGetMemberList" resultType="com.bob.stepy.dto.MemberDto">
		SELECT * FROM M
	</select>
	<!-- 초대 리스트 가져오기 -->
	<select id="pGetInviteList" resultType="com.bob.stepy.dto.InviteDto">
		SELECT * FROM I
	</select>
	<!-- 초대 여부 확인 카운트 -->
	<select id="pCheckInvite" resultType="int">
		SELECT COUNT(*) FROM I
		WHERE I_INVITEID=#{id}
	</select>
	<!-- 초대 유효성 검사 -->
	<select id="pCheckCodeValid" parameterType="com.bob.stepy.dto.InviteDto" resultType="int">
		SELECT COUNT(*) FROM I
		WHERE I_CODE=#{i_code} AND I_INVITEID=#{i_inviteid}
	</select>
	<!-- 일행 추가 -->
	<update id="pJoinPlan1" parameterType="com.bob.stepy.dto.InviteDto">
		UPDATE T
		SET T_MEMBER1=#{i_inviteid}
		WHERE T_PLANNUM=#{i_plannum}
	</update>
	<update id="pJoinPlan2" parameterType="com.bob.stepy.dto.InviteDto">
		UPDATE T
		SET T_MEMBER2=#{i_inviteid}
		WHERE T_PLANNUM=#{i_plannum}
	</update>
	<update id="pJoinPlan3" parameterType="com.bob.stepy.dto.InviteDto">
		UPDATE T
		SET T_MEMBER3=#{i_inviteid}
		WHERE T_PLANNUM=#{i_plannum}
	</update>
	<update id="pJoinPlan4" parameterType="com.bob.stepy.dto.InviteDto">
		UPDATE T
		SET T_MEMBER4=#{i_inviteid}
		WHERE T_PLANNUM=#{i_plannum}
	</update>
	<update id="pJoinPlan5" parameterType="com.bob.stepy.dto.InviteDto">
		UPDATE T
		SET T_MEMBER5=#{i_inviteid}
		WHERE T_PLANNUM=#{i_plannum}
	</update>
	<!-- 초대 삭제 -->
	<delete id="pDelInvite" parameterType="com.bob.stepy.dto.InviteDto">
		DELETE I
		WHERE I_CODE=#{i_code}
	</delete>
	<!-- 초대 회원 중복 검사 -->
	<select id="pCheckInviteId" parameterType="com.bob.stepy.dto.InviteDto" resultType="int">
		SELECT COUNT(*) FROM I
		WHERE I_PLANNUM=#{i_plannum} AND I_INVITEID=#{i_inviteid}
	</select>
	<!-- 여행 삭제 -->
	<delete id="pDelPlan">
		DELETE T
		WHERE T_PLANNUM=#{planNum}
	</delete>
	<!-- 여행 삭제시 일정 삭제 -->
	<delete id="pDelSchedule">
		DELETE AP
		WHERE AP_PLANNUM=#{planNum}
	</delete>
	<!-- 여행 삭제시 가계부 삭제 -->
	<delete id="pDelHousehold">
		DELETE H
		WHERE H_PLANNUM=#{planNum}
	</delete>
	<!-- 여행 삭제시 체크리스트 삭제 -->
	<delete id="pDelChecklist">
		DELETE CL
		WHERE CL_PLANNUM=#{planNum}
	</delete>
	<!-- 여행 정보 수정 -->
	<update id="pEditPlan" parameterType="com.bob.stepy.dto.TravelPlanDto">
		UPDATE T
		SET T_PLANNAME=#{t_planname}, T_SPOT=#{t_spot}, T_STDATE=#{t_stdate}, T_BKDATE=#{t_bkdate}
		WHERE T_PLANNUM=#{t_plannum}
	</update>
	<!-- 기간 초과 일정 정보 삭제 -->
	<delete id="pDelOverDate" parameterType="long">
		DELETE AP
		WHERE AP_DAY>#{newDays+1}
	</delete>
	<!-- 기간 초과 가계부 정보 삭제 -->
	<delete id="pDelOverHousehold" parameterType="long">
		DELETE H
		WHERE H_DAY>#{newDays+1}
	</delete>
	<!-- 현재 일정 초대중인 멤버 가져오기 -->
	<select id="pGetWaitingMember" parameterType="long" resultType="com.bob.stepy.dto.InviteDto">
		SELECT * FROM I
		WHERE I_PLANNUM=#{planNum}
	</select>
	<!-- 초대 취소 -->
	<delete id="pCancelInvite" parameterType="com.bob.stepy.dto.InviteDto">
		DELETE I
		WHERE I_PLANNUM=#{i_plannum} AND I_INVITEID=#{i_inviteid}
	</delete>
	<!-- 회원 내보내기 -->
	<update id="pDepmember1" parameterType="long">
		UPDATE T
		SET T_MEMBER1=' '
		WHERE T_PLANNUM=#{t_plannum}
	</update>
	<update id="pDepmember2" parameterType="long">
		UPDATE T
		SET T_MEMBER2=' '
		WHERE T_PLANNUM=#{t_plannum}
	</update>
	<update id="pDepmember3" parameterType="long">
		UPDATE T
		SET T_MEMBER3=' '
		WHERE T_PLANNUM=#{t_plannum}
	</update>
	<update id="pDepmember4" parameterType="long">
		UPDATE T
		SET T_MEMBER4=' '
		WHERE T_PLANNUM=#{t_plannum}
	</update>
	<update id="pDepmember5" parameterType="long">
		UPDATE T
		SET T_MEMBER5=' '
		WHERE T_PLANNUM=#{t_plannum}
	</update>
</mapper>
```
<br><br>
DataBase 구성
---
#### **여행 정보 처리를 위한 TRAVELPLAN 테이블**
![travelplan](https://user-images.githubusercontent.com/26563226/107028272-aef47380-67f0-11eb-95e1-0a454bd60892.JPG)
<br>
#### **여행 세부 일정 처리를 위한 ACCOMPANYPLAN 테이블**
![accompanyplan](https://user-images.githubusercontent.com/26563226/107028277-b025a080-67f0-11eb-929a-64512b10d0a4.JPG)
<br>
#### **가계부 처리를 위한 HOUSEHOLD 테이블**
![household](https://user-images.githubusercontent.com/26563226/107028291-b451be00-67f0-11eb-801a-5486e54a8eb1.JPG)
<br>
#### **체크리스트 처리를 위한 CHECKLIST 테이블**
![checklist](https://user-images.githubusercontent.com/26563226/107028297-b61b8180-67f0-11eb-9cec-b16d99ea3918.JPG)
<br>
#### **일행 초대 처리를 위한 INVITE 테이블**
![invite](https://user-images.githubusercontent.com/26563226/107028305-b7e54500-67f0-11eb-8d9f-102401bf3c1a.JPG)
