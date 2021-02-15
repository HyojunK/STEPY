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

<title>내 상품 관리</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<style type="text/css">
.btn {
	background-color: #77acf2;
	color: white;
	margin: 10px 0px;
}
.btn-color {
	background-color: #F2B950;
}
.btn-color2 {
	background-color: #4375d9;
}
.sub {
	width: 80%;
}
.btn-mar {
	margin: 10px auto;	
}
.btn-radius {
	width: 40px;
	height: 40px;
	border-radius: 50%;
}
.contents-size {
	height: 180px;
	overflow: auto;
}
.contents-size::-webkit-scrollbar {
    width: 10px;
}
.contents-size::-webkit-scrollbar-thumb {
    background-color: #F2B950;
    border-radius: 10px;
    background-clip: padding-box;
    border: 2px solid transparent;
}
.contents-size::-webkit-scrollbar-track {
    background-color: #ddd;
    border-radius: 10px;
    box-shadow: inset 0px 0px 5px white;
}
.thumbnail {
	height: 450px!important;
}

#plus {
	position: absolute;
	opacity: 0;
}
.text_photo:hover #plus {
	opacity: 1;
	background-color: rgba(42, 41, 45, 0.6);
	width: 293px;
	height: 200px;
	color: white;
	text-align: center;
	line-height: 200px;
	font-size: xx-large;
	cursor: pointer;
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
  			<li role="presentation"><a href="./stMyPage">내 정보 관리</a></li>
  			<li role="presentation" class="active"><a href="./stMyProd">내 상품 관리</a></li>
  			<li role="presentation"><a href="./stResList">예약 현황 보기</a></li>
  			<!-- <li role="presentation"><a href="./stReviewList">가게 후기 보기</a></li>
  			<li role="presentation"><a href="./stReportList">가게 신고 보기</a></li>  -->
		</ul>
		
		<div class="btn-mar">
			<div class="alert alert-warning" role="alert">
				<span class="glyphicon glyphicon-bullhorn"></span>&nbsp;&nbsp;
			한 상품당 최소 하나의 사진을 기본으로 합니다.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;더 많은 사진을 넣고 싶다면 아래 상품에서 '+' 를 클릭해주세요:)<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;등록된 상품은 가격 순으로 정렬되어 노출됩니다.
			</div>			
   			<button type="button" class="btn btn-radius" onclick="location.href='./stWriteFrm'" title="상품 추가하기" >
   				<span class="glyphicon glyphicon-pencil"></span></button>
   			<button type="button" class="btn btn-color btn-radius" onclick="location.href='./plProductList?c_num=${ceo.c_num}'" title="전체 페이지 보기">
   				<span class="glyphicon glyphicon-open"></span></button> 				
		</div>		
		
		<c:if test="${empty pList}">
			<div class="text-center" style="margin-top: 40px;">등록된 상품이 없습니다.</div>
		</c:if>
		<c:if test="${!empty pList}">
			<div class="row">
				<c:forEach var="pt" items="${ptMap}" varStatus="status">
					<div class="col-sm-6 col-md-4">					
						<div class="thumbnail">						
							<c:if test="${fn:contains(pt.key, '.jpg')}">								
								<div class="text_photo">										
									<a href="stAddProdPhotos?pl_num=${pt.value.pl_num}">
									<p id="plus"><span class="glyphicon glyphicon-plus"></span></p></a>														
									<img src="resources/upload${pt.key}" style="width: 100%; height: 200px;">
								</div>									
							</c:if>
							<c:if test="${fn:contains(pt.key, '.png')}">
								<div class="text_photo">										
									<a href="stAddProdPhotos?pl_num=${pt.value.pl_num}">
									<p id="plus"><span class="glyphicon glyphicon-plus"></span></p></a>	
									<img src="resources/upload${pt.key}" style="width: 100%; height: 200px;">
								</div>	
							</c:if>						
							<div class="caption contents-size">								
								<h3>${pt.value.pl_name}</h3>
        						<p>
        							&bull; 가격: <fmt:formatNumber value="${pt.value.pl_price}" pattern="#,###"/>원 <br>
        							&bull; 인원: ${pt.value.pl_person}명 <br>
        						<c:if test="${!empty pt.value.pl_qty}">
        							&bull; 수량: ${pt.value.pl_qty}개<br>
        						</c:if>        						
        							&bull; 특징: ${pt.value.pl_text}<br>        							
        						</p>
        					</div>
        					<p class="text-center">
        						<button type="button" class="btn btn-color2 sub" onclick="del('${pt.value.pl_num}')">
        							<span class="glyphicon glyphicon-trash"></span>
        						</button>	
        					</p>        					     						
    					</div>
  					</div>		
				</c:forEach>
			</div>
		</c:if>		
	</div>
	
	<footer>
		<jsp:include page="stFooter.jsp" />
	</footer>

</body>
<script type="text/javascript">
function del(plnum) {
	var con = confirm("상품을 삭제하시겠습니까?");
	var plnum = plnum;
	console.log(plnum); 
	
	if(con){
		var objdata = {"pl_num" : plnum};
		
		$.ajax({
			url: "delProd",
			type: "post",
			data: objdata,
			dataType: "text",
			success: function(data){
				if(data == "success"){
					alert("삭제되었습니다.");
					location.reload(true);
				} else {
					alert("삭제 실패하였습니다.");					
				}				
			},
			error: function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				location.reload(true);
			}			
		});		
	}
}
</script>
</html>