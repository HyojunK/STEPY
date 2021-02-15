<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>내 정보 관리</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<style type="text/css">
.btn {
	background-color: #5983D9;
	color: white;
	width: 100%;
}
.btn-color1 {
	background-color: #F2B950;
	color: white;
	margin: 3px;
}
.btn-color2 {
	background-color: #F25D07;
	color: white; 
	margin: 3px;	
}
table {
	width: 100%;
	margin-top: 30px;
}
th {
	padding: 12px;
}
td.info {
	padding-left: 30px;
	width: 50%;
	text-align: left;
}
ul.dropdown-menu {
	width: 100%;
}
</style>
<script type="text/javascript">
$(function(){
	$(".suc").css("display", "block");
	$(".bef").css("display", "none");	
	
	var chk = "${msg}";
	if(chk != ""){
		alert(chk);
		location.reload(true);
	}	
});
</script>

</head>

<body>
	<header>
		<jsp:include page="stHeader.jsp" />
	</header>
	
	<!-- section -->
	<div class="container center-block" style="width:1000px;">
		<ul class="nav nav-tabs nav-justified">
  			<li role="presentation" class="active" class="dropdown">
  				<a class="dropdown-toggle" data-toggle="dropdown" href="./stMyPage" role="button" aria-expanded="false">내 정보 관리
  					<span class="caret"></span></a>
  				<ul class="dropdown-menu" role="menu">
  					<li><a href="./stMyThumb">스토어 대표사진 관리하기</a></li>
  					<li><a href="./stExtraPhoto">스토어 사진 추가하기</a></li>
  					<li><a href="./stModifyInfoFrm">내 정보 변경하기</a></li>
  				</ul>
  			</li>
  			<li role="presentation"><a href="./stMyProd">내 상품 관리</a></li>
  			<li role="presentation"><a href="./stResList">예약 현황 보기</a></li>
  			<!-- <li role="presentation"><a href="./stReviewList">가게 후기 보기</a></li>
  			<li role="presentation"><a href="./stReportList">가게 신고 보기</a></li>  -->
		</ul>
		
		<div class="container center-block" style="width: 60%;">
			<table>
				<tr>
					<td colspan="2" style="width: 15%; height: 70px; background-color: #eee; text-align: center;">
						<h4><span class="glyphicon glyphicon-user"></span> Information</h4>
					</td>
				</tr>
				<tr>
					<th style="width: 20%; text-align: right;">
						사업자번호
					</th>
					<td class="info">
						${ceo.c_num}
					</td>					
				</tr>
				<tr>
					<th style="width: 20%; text-align: right;">
						사업주명
					</th>
					<td class="info">
						${ceo.c_name}
					</td>					
				</tr>
				<tr>
					<th style="width: 20%; text-align: right;">
						사업주 연락처
					</th>
					<td class="info">
						${ceo.c_phone}
					</td>					
				</tr>
				<tr>
					<th style="width: 20%; text-align: right;">
						이메일주소
					</th>
					<td class="info">
						${ceo.c_email}
					</td>					
				</tr>
				<tr>
					<th style="width: 20%; text-align: right;">
						가게 이름
					</th>
					<td class="info">
						${store.s_name}
					</td>					
				</tr>
				<tr>
					<th style="width: 20%; text-align: right;">
						가게 연락처
					</th>
					<td class="info">
						${store.s_phone}
					</td>					
				</tr>
				<tr>
					<th style="width: 20%; text-align: right;">
						가게 주소
					</th>
					<td class="info">
						(${store.s_addr1}) ${store.s_addr2} ${store.s_addr3}
					</td>					
				</tr>
				<tr>
					<th style="width: 20%; text-align: right;">
						가게 소개
					</th>
					<td class="info">
						${store.s_summary}
					</td>					
				</tr>
				<tr>
					<th style="width: 20%; text-align: right;">
						가게 분류
					</th>
					<td class="info">
						${store.s_category}
					</td>					
				</tr>
				<tr>
					<td colspan="2" style="text-align: center; height: 90px;">
						<button type="submit" class="btn btn-color1" onclick="location.href='./stModifyPwdFrm'">비밀번호 변경하기</button>   						
   						<!-- <button type="submit" class="btn btn-color2">탈퇴하기</button>  -->
					</td>
				</tr>									
			</table>
		</div>
  	</div>		
	
	<footer>
		<jsp:include page="stFooter.jsp" />
	</footer>
</body>
</html>
