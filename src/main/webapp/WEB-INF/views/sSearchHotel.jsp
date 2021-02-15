<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page session="false"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>STEPY 숙소 검색</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link href="resources/css/style.css" rel="stylesheet">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<style type="text/css">
.title {
	font-size: 23px;
	font-weight: bold;
}
.title>a {
	color: black;
}
.searchFrm {
	margin-bottom: 30px;
}
#searchBtn {
	border: 1px solid #4375D9; 
	color: #4375D9;
}
.searchRes {
	width: 50%;
	float: left;
	margin: 30px 0;
	box-sizing: border-box;
}
.searchRes>a {
	text-decoration: none;
	color: black;
}
.storeImg {
	float: left;
	width: 250px;
	height: 200px;
	border-radius: 5px;
}
.star {
	color: #F2B950;
	width: 16px;
}
.ratingValue {
	font-size: 17px;
	margin-left: 10px;
}
</style>
</head>

<body>
<header>
	<jsp:include page="header.jsp" />
</header>

<section>
	<div class="container">
		<!-- Tab panes -->
		<div class="tab-content">
			<div class="container title">
				<a href="./sSearchFrm"><span class="glyphicon glyphicon-chevron-left"></span></a>
				<span>&nbsp;&nbsp;&nbsp;숙소 검색</span>
			</div>
			
			<div role="tabpanel" class="tab-pane active searchFrm" id="hotel">
				<form action="searchHotel">
					<div class="form-group form-group-lg">
						<div class="col-sm-10">
							<input class="form-control" type="text" id="formGroupInputLarge"
								placeholder="지역, 숙소명" name="keyword" value="${keyword}">
						</div>
					</div>
					<input type="submit" class="btn btn-default btn-lg" id="searchBtn" value="검색">
				</form>
			</div>
		</div>
		
		<!-- 검색 결과 출력 -->
		<div class="container">
			<c:if test="${empty sList}">
				<div class="container">해당 가게가 없습니다.</div>
			</c:if>
			<c:if test="${!empty sList}">
				<c:forEach var="t" items="${tMap}">
					<div class="container searchRes">
						<a href="plProductList?c_num=${t.value.s_num}">
							<div class="media">
								<div class="media-left">
									<c:if test="${fn:contains(t.key, '.jpg')}">
										<img src="resources/upload${t.key}" class="storeImg">
									</c:if>
									
									<c:if test="${fn:contains(t.key, '.png')}">
										<img src="resources/upload${t.key}" class="storeImg">
									</c:if>
									
									<c:if test="${fn:contains(t.key, '.jpeg')}">
										<img src="resources/upload${t.key}" class="storeImg">
									</c:if>
								</div>
								<div class="media-body">
									<h4 class="media-heading">${t.value.s_name}</h4>
									<div class="storeRate">
										<span data-rate="${t.value.s_rate}" class="starRating">
											<span><img src="resources/images/star-empty.svg" class="star"></span>
											<span><img src="resources/images/star-empty.svg" class="star"></span>
											<span><img src="resources/images/star-empty.svg" class="star"></span>
											<span><img src="resources/images/star-empty.svg" class="star"></span>
											<span><img src="resources/images/star-empty.svg" class="star"></span>
										</span>
										<span class="ratingValue">
											<fmt:formatNumber value="${t.value.s_rate}" pattern=".0"/></span>
									</div>
								</div>
							</div>
						</a>
					</div>
				</c:forEach>
			</c:if>
		</div>
	</div>
</section>

<footer>
	<jsp:include page="footer.jsp" />
</footer>
</body>


<script type="text/javascript">
$(function(){
	var starRating = $('.starRating');
	
	starRating.each(function(){
		var targetScore = $(this).attr('data-rate');
		console.log(targetScore);
		$(this).find('svg:nth-child(-n+' + targetScore + ')').css({color:'#F2B950;'})
	});
});
</script>

</html>