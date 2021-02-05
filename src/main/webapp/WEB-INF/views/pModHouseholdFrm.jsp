<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>가계부 내용 수정</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<link href="resources/css/style_hjk.css" rel="stylesheet">
</head>
<body>
	<header>
		<jsp:include page="header.jsp" />
	</header>
	<section>
		<div class="container">
			<button class="btn btn-default btn-lg" type="button"
				onclick="location.href='pHouseholdFrm?planNum=${curPlan}'">
				<span class="glyphicon glyphicon-arrow-left" aria-hidden="true">
					목록으로&nbsp;</span>
			</button>
			<div class="page-header">
				<h1 class="text-center">내용 수정</h1>
			</div>
			<div class="contents-box">
				<form action="modHousehold" onsubmit="return changeCostFormat()">
				<input type="hidden" name="h_plannum" value="${curPlan}">
				<input type="hidden" name="h_curday" value="${dayCnt}">
				<input type="hidden" name="h_cnt" value="${contents.h_cnt}">
				<!-- 로그인 세션 추가시 변경할것 -->
				<input type="hidden" name="h_mid" value="${member.m_id}">
				<!--  -->
				<div class="row">
					<div class="form-group col-sm-offset-3 col-sm-6">
						<label for="day-select">날짜 선택</label> 
						<select id="day-select" class="form-control" name="h_day">
							<option value="0">여행 준비</option>
							<c:set var="i" value="1"/>
							<c:forEach begin="0" end="${days}">
								<option value="${i}">DAY ${i}</option>
							<c:set var="i" value="${i + 1}"/>
							</c:forEach>
						</select>
					</div>
				</div>
					<div class="row">
						<div class="form-group col-sm-offset-3  col-sm-6">
							<label class="category-list-title">항목</label>
							<input type="radio" name="h_category" id="category-radio1" class="category-radio" value="숙소">
							<label for="category-radio1" class="category-name"><span>숙소</span></label>
							<input type="radio" name="h_category" id="category-radio2" class="category-radio" value="교통">
							<label for="category-radio2" class="category-name"><span>교통</span></label>
							<input type="radio" name="h_category" id="category-radio3" class="category-radio" value="식사">
							<label for="category-radio3" class="category-name"><span>식사</span></label>
							<input type="radio" name="h_category" id="category-radio4" class="category-radio" value="쇼핑">
							<label for="category-radio4" class="category-name"><span>쇼핑</span></label>
							<input type="radio" name="h_category" id="category-radio5" class="category-radio" value="관광">
							<label for="category-radio5" class="category-name"><span>관광</span></label>
							<input type="radio" name="h_category" id="category-radio6" class="category-radio" value="기타">
							<label for="category-radio6" class="category-name"><span>기타</span></label>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-sm-offset-3  col-sm-6">
							<label for="household-contents">내용</label> 
							<input type="text" class="form-control" name="h_contents" id="household-contents" placeholder="내용을 입력해주세요" onkeyup="lengthCheck()" value="${contents.h_contents}">
						</div>
					</div>
					<div class="row">
						<div class="form-group col-sm-offset-3  col-sm-6">
							<label for="household-cost">금액 입력</label> 
							<input type="text" class="form-control" name="h_cost" id="household-cost" placeholder="금액을 입력해주세요" onkeyup="numberCheck(this)" value="${contents.h_cost}">
						</div>
					</div>
					<div class="row">
						<div class="form-group col-sm-offset-3  col-sm-6">
							<label for="household-spot">장소 입력</label> 
							<input type="text" class="form-control" name="h_sname" id="household-spot" placeholder="장소를 입력해주세요 (선택사항)" readonly value="${contents.h_sname}">
						</div>
					</div>
					<div class="row btn-box">
						<div class="form-group col-sm-offset-3 col-sm-3">
							<input type="button" class="btn btn-default btn-lg btn-block del-household-btn" value="삭제" onclick="delCheck()"/>
						</div>
						<div class="form-group col-sm-3">
							<button class="btn btn-default btn-lg btn-block submit-cost-btn" type="submit">수정완료</button>
						</div>
					</div>
					<div class="popup-wrap">
						<div class="popup-area">
							<div class="popup-close"><img src="resources/images/close.png" width="15"></div>
								<div class="search-box">
									<input type="text" class="search-bar" placeholder="장소를 검색해보세요" id="storeSearch" onkeyup="search()" value="${contents.h_sname}">
								</div>
								<div class="add-store-box">
								<ul class="list-group">
									<c:forEach var="sList" items="${sList}">
										  <li class="list-group-item storeBox" style="display: none;">
											    <div class="storeName" id="${i}">${sList.s_name} <input type="button" class="choiceBtn" value="선택" 
											    onclick="$('#household-spot').val('${sList.s_name}'); afterSelect()"></div>
										  </li>
									</c:forEach>
								</ul>
								</div>
						</div>
						<div class="popup-background"></div>
					</div>
				</form>
			</div>
		</div>
	</section>
	<footer>
		<jsp:include page="footer.jsp" />
	</footer>
</body>
<script type="text/javascript">
//셀렉트 박스 value값 선택
$(function(){
	//console.log(${contents.h_day});
	$("#day-select").val("${contents.h_day}").prop("selected",true);
});
//라디오 버튼 value값 선택
	$('input:radio[name="h_category"][value="${contents.h_category}"]').prop("checked",true);

//내용 글자수 제한
function lengthCheck(){
	var str = $("#household-contents").val();
	console.log(str);
	
	if(str.length > 50){
		alert("내용은 50글자 까지만 입력 가능합니다");
		$("#household-contents").val(str.substring(0,10));
	}
}

//금액 입력시 숫자 입력 제한, 콤마추가
function numberCheck(inputFrm){
	var cost = inputFrm.value;
	console.log(cost);
	cost = cost.replace(/,/gi,"");
	
	var check = /^[0-9]*$/;
	if(!check.test(cost)){
		$(inputFrm).val("");
		alert("숫자만 입력해주세요")
	} else {
		cost = cost.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",");
		$(inputFrm).val(cost);
	}
}

//금액 기본값 콤마 표시
$(function(){
	var beforeCost = $("#household-cost").val();
	console.log(beforeCost);
	var cost = beforeCost.replace(/\B(?=(\d{3})+(?!\d))/g,",");
	console.log(cost);
	$("#household-cost").val(cost);
})

//제출시 비용 형식 변환
function changeCostFormat(){
	var cost = $("#household-cost").val();
	//console.log(cost);
	//콤마 제거
	cost = cost.replace(/,/g,"");
	//console.log(cost);
	$("#household-cost").val(cost);
	
	return true;
}

//검색창
var storeList = $(".storeName");
var storeBox = $(".storeBox");
	
function search(){
	
	//검색하려는 단어
	var searchText = $("#storeSearch").val();
	console.log(searchText);
	
	for(var i = 0; i < storeList.length; i++){
		//입력한 단어가 포함된 가게들은 표시
		if(storeList[i].innerText.includes(searchText)){
			storeBox[i].style.display="block";
		}
		//포함된 단어가 없으면 숨김 처리
		else{
			storeBox[i].style.display="none";
		}
	}
	
	//입력값 없을 시 숨김처리
	if(searchText == ""){
		for(var i = 0; i < storeList.length; i++){
			storeBox[i].style.display="none";
		}
	}
}

//가게명 선택 완료시
function afterSelect(){
	$(".popup-wrap").css("opacity","0").css("visibility","hidden");
	$("#storeSearch").val("");
	for(var i = 0; i < storeList.length; i++){
		storeBox[i].style.display="none";
	}
}

//삭제 확인 후 삭제
function delCheck(){
	if(confirm("삭제하시겠습니까?")){
		location.href="delHousehold?day=${dayCnt}&householdCnt=${contents.h_cnt}";
	}
}
//팝업창 온오프
$(function(){
	
	$("#household-spot").focus(function(){
		$(".popup-wrap").css("opacity","1").css("visibility","visible");
	});
	$(".popup-close").click(function(){
		$(".popup-wrap").css("opacity","0").css("visibility","hidden");
		$("#storeSearch").val("");
		for(var i = 0; i < storeList.length; i++){
			storeBox[i].style.display="none";
		}
	});
	$(".popup-background").click(function(){
		$(".popup-wrap").css("opacity","0").css("visibility","hidden");
		$("#storeSearch").val("");
		for(var i = 0; i < storeList.length; i++){
			storeBox[i].style.display="none";
		}
	});
});
</script>
</html>