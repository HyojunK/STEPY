<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<style>
li .active {
	backgroud-color: #4375d9;
}

div.shady {
	width: 250px;
	box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0
		rgba(0, 0, 0, 0.19);
	text-align: center;
}
.card{
  position: relative;
  text-align: center;
}
.centered {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
   background: rgba(0, 0, 0, 0.7);
  color: white;
  padding : 50px;
  display:none;
  max-width:400px;
}
.card-img-top:hover + .centered, .centered:hover{
	display:block;
}
#hovera:link, #hovera:visited, #hovera:hover, #hovera:active{
	color:white;
	text-decoration:none;
}
</style>
</head>
<body>

	<header>
		<jsp:include page="header.jsp" />
	</header>
	<main class="container text-center center-block" style="margin-bottom: 200px; margin-top: 100px;">

		<ul class="nav nav-tabs nav-justified">
			<li class="nav-item"><a class="nav-link" href="./mMyPage">myPage</a></li>
			<li class="nav-item"><a class="nav-link" href="./pPlanList?id=${member.m_id}">나의 여행 플랜</a></li>
			<li class="nav-item"><a class="nav-link" href="./mMyLikedPages">좋아요 한 게시글</a></li>
			<li class="nav-item active"><a class="nav-link" href="./mMyCartPages">찜한 상품</a></li>
			<li class="nav-item"><a class="nav-link" href="./mMyPayment">내 결제 내역/쿠폰 확인</a></li>
			<li class="nav-item"><a class="nav-link" href="./mModifyMyinfo">내 정보 수정</a></li>
		</ul>

		<div class="row text-center center-block" style="width: 1200px; margin-top:90px;">

			<c:if test="${!empty cartList }">
				<c:forEach var="c" items="${cartList}">
					<div class="col-sm-6">
						<div class="shady" style="width: 500px;">
						<div class="card">
							<img class="card-img-top" src="resources/upload${c.f_sysname}" alt="Card image cap"
								style="width: 400px; height: 450px; object-fit: cover;"
							><div class="centered"><a id="hovera" href="./plProductList?c_num=${c.f_cnum }"><h1>${c.s_name }</h1><br><h4>이동하기</h4></a></div>
							</div>
							<div class="card-body">
							
								<h2 class="card-title">${c.s_name }</h2>
								<p class="card-text"></p>
								
								<br>
							</div>
						</div>
					</div>
				</c:forEach>
			</c:if>
			<c:if test="${empty cartList }">
			아직 찜한 상품이 없습니다!
			</c:if>

		</div>
	</main>
	<footer>
		<jsp:include page="footer.jsp" />
	</footer>

</body>
</html>