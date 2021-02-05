<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>상품 상세정보</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bxslider/4.2.15/jquery.bxslider.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/bxslider/4.2.15/jquery.bxslider.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<style type="text/css">
.title-zone {
	width: 900px;
	height: 40px;
	padding: 5px;
	margin-bottom: 5px;
	background-color: #F2B950;
	color: white;
	position: fixed;	
	z-index: 10;
	opacity: 80%;
}
.title-deco {
	font-size: 18px;
	font-weight: bold;
	text-align: center;
	margin-top: 3px;
}
.photo-zone {
	width: 900px;
}
.bxslider {
	width: 900px;
	height: 400px;
}
.bx-wrapper {
	-moz-box-shadow: none;
	-webkit-box-shadow: none;
	box-shadow: none;
	border: 0;
}
.bx-wrapper img {
	width: 900px;
	height: 400px;
}
.info-zone {
	margin-top: 50px;
	margin-bottom: 30px;
}
table {
	width: 100%;
	border: 1px solid #ddd;
	marign: 10px;
}
td {
	padding: 10px 20px 10px 20px;
}
.guide-zone {
	margin-top: 50px;
}
.price-deco {
	font-size: xx-large;
	font-weight: bold;
}
.address {
	color: #4375d9;
	font-weight: bold;
}
.btn {
	width: 900px;
	background-color: #4375d9;
	color: white;
	margin-top: 30px;
}
a:link {
	color: black;
	text-decoration: none;
}

a:visited {
	color: black;
	text-decoration: none;
}
</style>

</head>
<body>
<!-- section -->
<div class="container center-block" style="width:900px;">
	<div class="container center-block title-zone">
		<a href="javascript:history.back();">
			<span class="text-left" style="float: left;">
			&nbsp;<span class="glyphicon glyphicon-menu-left" style="margin-top: 5px; color: white;"></span></span></a>
		<p class="title-deco"><b>상품 상세</b></p>		
	</div>
	
	<div class="container center-block info-zone" style="width:900px;">
		<h2 class="text-left" style="margin: 30px 0px"><b>${product.pl_name}</b></h2>
		<h5>&bull; 남은 개수 : ${product.pl_qty}개</h5>
		<h5>&bull; 기준 인원 : ${product.pl_person}명</h5>
		<div style="width: 100%;">
		<c:if test="${!empty product.pl_text}">
			<h5 style="margin-bottom: 25px; line-height: normal;">&bull; ${product.pl_text}</h5>
		</c:if>
		<c:if test="${empty product.pl_text}">
			<br>
		</c:if>
		</div>
		
		<h5 class="address"><span class="glyphicon glyphicon-map-marker"></span> ${store.s_name}</h5>
	</div>	
	<div class="photo-zone">
		<c:if test="${empty photoList}">
			<c:if test="${fn:contains(fDto.f_sysname, '.png')}">
				<li style="list-style: none;"><img src="resources/upload${fDto.f_sysname}"
					style="width: 900px; height: 400px; margin-bottom: 50px;"/></li>
			</c:if>
			<c:if test="${fn:contains(fDto.f_sysname, '.jpg')}">
				<li style="list-style: none;"><img src="resources/upload${fDto.f_sysname}"
					style="width: 900px; height: 400px; margin-bottom: 50px;"/></li>
			</c:if>			
		</c:if>
		<c:if test="${!empty photoList}">
			<ul class="bxslider">
				<c:if test="${fn:contains(fDto.f_sysname, '.png')}">
					<li><img src="resources/upload${fDto.f_sysname}" /></li>
				</c:if>
				<c:if test="${fn:contains(fDto.f_sysname, '.jpg')}">
					<li><img src="resources/upload${fDto.f_sysname}" /></li>
				</c:if>				
				<c:forEach var="photo" items="${photoList}">
					<c:if test="${fn:contains(photo.f_sysname, '.png')}">
						<li><img src="resources/upload${photo.f_sysname}" /></li>
					</c:if>
					<c:if test="${fn:contains(photo.f_sysname, '.jpg')}">
						<li><img src="resources/upload${photo.f_sysname}" /></li>
					</c:if>
				</c:forEach>
			</ul>										
		</c:if>		
	</div>	
	<div class="center-block res-zone" style="width: 900px">
		<table>
			<tr>
				<td class="text-left"><h4><b>숙박</b></h4></td>
				<td></td>
			</tr>
			<tr>
				<td>체크인 23:00 부터 <br>체크아웃 13:00 까지</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td class="text-right">판매가<br><span class="price-deco">
					<b><fmt:formatNumber value="${product.pl_price}" pattern="#,###"/></b></span>원</td>
			</tr>
		</table>		
	</div>
	<div class="center-block btn-zone" style="width: 900px">
		<button type="button" class="btn btn1">예약하기</button>	
	</div>

</div>

</body>
<script type="text/javascript">
var j = $.noConflict(true);
j(document).ready(function() {
	j('.bxslider').bxSlider({
		auto : false,
		controls : true,
		randomStart : false,
		pager : false,
	});
});
</script>	
</html>
