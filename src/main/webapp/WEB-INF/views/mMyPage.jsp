<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Page</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">


</head>
<body style="background-image: linear-gradient(to bottom right, rgba(67, 117, 217, 1),
		rgba(67, 117, 217, 0.3));">

	<header>
		<jsp:include page="header.jsp" />
	</header>
	<main class="container" style="margin-top: 100px;">


		<div class="list-group col-sm-3">
		
			<div style="box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.10);">

				<a href="#" class="list-group-item list-group-item-action"
					style="color: #4375d9; border: none;"
				> <h3><b>My Page</b></h3> </a> <a href="./mMyTravleSchedule" class="list-group-item list-group-item-action">나의
					여행 플랜</a> <a href="./mMyLikedPages" class="list-group-item list-group-item-action">좋아요 한
					게시글</a> <a href="./mMyCartPages" class="list-group-item list-group-item-action">찜한 상품</a> <a
					href="#" class="list-group-item list-group-item-action"
				>내 결제 내역/쿠폰 확인</a> <a href="./mModifyMyinfo" class="list-group-item list-group-item-action">내
					정보 수정</a>
					
					<div>
				<a href="./mMyLittleBlog?blog_id=${member.m_id }" class="list-group-item list-group-item-action" 
				style=" background-image:linear-gradient(to bottom right, rgba(67,117,217,1),rgba(67,117,217,0.5));
				color:white;"><b>나의 게시글</b></a>
			</div>

			</div>
			<br>
			
		</div>
		<div class="col-sm-9 container"
			style="height: 300px; background-color: #f5f5f5; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.10);"
		>
			<div class="col-sm-8 container" style="margin: 20px; margin-top: 40px;">
				<h2>반가워요 " ${member.m_nickname } "님!</h2>
				<br>
				<h2>새로운 여행을 떠나볼까요?</h2>
			</div>

			<div class="col-sm-2" style="margin: 20px; margin-top: 85px;">
				<c:if test="${!empty profile}">
					<div class="col-sm-2 container">
						<img src="resources/profile/${profile.f_oriname }"
							style="height: 110px; width: 110px; border-radius: 50%;"
						>
					</div>
				</c:if>
			</div>

		</div>


	</main>
	<footer>
		<jsp:include page="footer.jsp" />
	</footer>
</body>
</html>