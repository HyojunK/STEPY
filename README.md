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
<img alt="logo_tp_final01" src="https://user-images.githubusercontent.com/26563226/106997571-79d32b80-67c6-11eb-8396-1965301eba68.JPG"></img>
<img alt="logo_tp_final01" src="https://user-images.githubusercontent.com/26563226/106997611-89eb0b00-67c6-11eb-9a49-35ed6e08b0e0.JPG"></img>
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
![일정 추가](https://user-images.githubusercontent.com/26563226/107000809-db49c900-67cb-11eb-9b54-b335fa781870.gif)
<br><br>
#### **여행 일정 수정 및 삭제** 
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
