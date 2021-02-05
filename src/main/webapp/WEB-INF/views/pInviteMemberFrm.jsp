<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>일행 초대</title>
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
	<button class="btn btn-default btn-lg" type="button" onclick="location.href='pPlanFrm?planNum=${curPlan}'">
	<span class="glyphicon glyphicon-arrow-left" aria-hidden="true"> 뒤로가기&nbsp;</span>
	</button>
	<div class="page-header">
	  <h1 class="text-center">회원 검색</h1>
	</div>
	<div class="search-box col-sm-offset-3 col-sm-6">
		
				<div class="search-box">
					<input type="text" class="search-bar" placeholder="초대하고싶은 회원을 검색해보세요" id="storeSearch" onkeyup="search()">
				</div>
			
		<div class="add-store-box">
		<ul class="list-group">
			<c:forEach var="mList" items="${mList}">
				<c:if test="${mList.m_id != member.m_id}">
				<li class="list-group-item storeBox">
					<form action="pInviteMember" method="post" class="iFrm">
						<input type="hidden" name="i_plannum" value="${curPlan}">
						<input type="hidden" name="i_mid" value="${invite.i_mid}">
						<input type="hidden" name="i_planname" value="${invite.i_planname}">
						<input type="hidden" name="i_inviteid" value="${mList.m_id}">
					    <div class="storeName">${mList.m_id} <input class="choiceBtn" type="submit" value="초대"></div>
					</form>
				</li>
				</c:if>
			</c:forEach>
		</ul>
		</div>
	</div>
</div>
</section>
<footer>
<jsp:include page="footer.jsp"/>
</footer>
</body>
<script type="text/javascript">
	var storeList = $(".storeName");
	var storeBox = $(".storeBox")
	
function search(){
	//검색하려는 단어
	var searchText = $("#storeSearch").val();
	console.log(searchText);
	
	for(var i = 0; i < storeList.length; i++){
		//입력한 단어가 포함된 회원들은 표시
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
</script>

</html>