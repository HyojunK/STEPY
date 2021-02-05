<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>카테고리 추가</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<link href="resources/css/style_hjk.css" rel="stylesheet">
<script type="text/javascript">
</script>
</head>
<body>
<header>
<jsp:include page="header.jsp"/>
</header>
<section>
<div class="container">
	<button class="btn btn-default btn-lg" type="button" onclick="location.href='pCheckSupFrm?planNum=${curPlan}'">
	<span class="glyphicon glyphicon-arrow-left" aria-hidden="true"> 뒤로가기&nbsp;</span>
	</button>
	<div class="page-header">
	  <h1 class="text-center">카테고리 추가</h1>
	</div>
	<div class="search-box col-sm-offset-3 col-sm-6">
		<form action="pAddCheckCategory">
		<div class="form-group">
			<p><strong>카테고리 선택</strong></p>
			<input type="hidden" name="cl_plannum" value="${curPlan}">
			<input type="hidden" name="cl_category" value="${category}">
			<input type="hidden" name="cl_cnt" value="1">
			<input type="text" class="form-control" id="categoryName" placeholder="카테고리를 입력해주세요(최대 20자)" name="cl_categoryname" value="관광" required onkeyup="lengthCheck()">
			<select class="form-control" id="categorySelect" onchange="categoryChange()" style="margin: 15px 0;">
			  <option value="직접입력">직접 입력</option>
			  <option value="관광" selected>관광</option>
			  <option value="교통">교통</option>
			  <option value="숙소">숙소</option>
			</select>
		</div>
		<div class="form-group">
			<p><strong>준비물 선택</strong></p>
			<input type="text" class="form-control" id="itemName" placeholder="준비물을 입력해주세요(최대 20자)" name="cl_item" value="상비약" required onkeyup="lengthCheck()">
			<select class="form-control" id="itemSelect" onchange="itemChange()" style="margin: 15px 0;">
			  <option value="직접입력">직접 입력</option>
			  <option value="상비약" selected>상비약</option>
			  <option value="충전기">충전기</option>
			  <option value="신분증">신분증</option>
			</select>
		</div>
		<div class="form-group">
			<input class="btn btn-default btn-block add-day-plan-btn" type="submit" value="완료">
		</div>
		</form>
	</div>
</div>
</section>
<footer>
<jsp:include page="footer.jsp"/>
</footer>
</body>
<script type="text/javascript">
//내용 입력 글자수 제한
function lengthCheck(){
	var str = $("#categoryName").val();
	console.log(str);
	
	if(str.length > 20){
		$("#categoryName").val("");
		alert("내용은 20글자 까지만 입력해주세요");
	}
}

//카테고리 선택
function categoryChange(){
	//프리셋 선택시
	var category = $("#categorySelect").val();
	$("#categoryName").val(category);
	console.log($("#categorySelect").val());
	
	//직접입력 선택시
	if(category == "직접입력"){
		$("#categoryName").css("display", "block");
		$("#categoryName").val("");
		$("#categoryName").focus();
	}
	if(category != "직접입력"){
		$("#categoryName").css("display", "none");
	}
}
//준비물 선택
function itemChange(){
	//프리셋 선택시
	var item = $("#itemSelect").val();
	$("#itemName").val(item);
	console.log($("#itemSelect").val());
	
	//직접입력 선택시
	if(item == "직접입력"){
		$("#itemName").css("display", "block");
		$("#itemName").val("");
		$("#itemName").focus();
	}
	if(category != "직접입력"){
		$("#itemName").css("display", "none");
	}
}
</script>
</html>