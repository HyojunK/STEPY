<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>업체 인증메일 보내기</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
$(function(){	
	$(".suc").css("display", "none");
	$(".bef").css("display", "block");	
	
});
</script>
<style type="text/css">
.btn {
	width: 50px;
}
</style>

</head>
<body>
	<header>
		<jsp:include page="stHeader.jsp" />
	</header>
	
	<!-- section -->
	<div class="container center-block" style="width:1000px;">
	<div class="panel panel-default">  		
  	<div class="panel-heading"><span class="glyphicon glyphicon-list-alt"></span> 미승인 업체 리스트</div>	
  	<table class="table">
    	<tr>
    		<th class="text-center">사업자번호</th>
    		<th class="text-center">이메일 주소</th>
    		<th class="text-center">연락처</th>
    		<th class="text-center">사업자등록증</th>
    		<th class="text-center">인증 상태</th>
    		<th class="text-center">인증메일 보내기</th>    	
    	</tr>
    	<c:if test="${empty ceoList}">
    		<tr class="text-center">   
    			<td colspan="6"><span class="text-center">해당 리스트가 없습니다.</span></td>
    		</tr>
    	</c:if>
    	<c:if test="${!empty ceoList}">
    		<c:forEach var="biz" items="${bizMap}">
    			<tr class="text-center">     			
    				<td style="vertical-align: middle;">${biz.value.c_num}</td>
    				<td style="vertical-align: middle;">${biz.value.c_email}</td>
    				<td style="vertical-align: middle;">${biz.value.c_phone}</td>
    				<c:if test="${fn:contains(biz.key, '.jpg')}">
    					<td style="vertical-align: middle;">
    						<img src="resources/upload/${biz.key}" id="bizImg" alt="${biz.key}" style="width: 50px; height: 30px; cursor: pointer;"
    							onclick="imgView('resources/upload/${biz.key}')">
    					</td>
    				</c:if>
    				<c:if test="${fn:contains(biz.key, '.png')}">
    					<td style="vertical-align: middle;">
    						<img src="resources/upload/${biz.key}" id="bizImg" alt="${biz.key}" style="width: 50px; height: 30px; cursor: pointer;"
    							onclick="imgView('resources/upload/${biz.key}')">
    					</td>
    				</c:if>    				
    				<td style="vertical-align: middle;">${biz.value.c_join}</td>
    				<td><button type="button" class="btn" onclick="sendAuthMail('${biz.value.c_email}', '${biz.value.c_num}');"><span class="glyphicon glyphicon-envelope"></span></button></td>    	
    			</tr>
    		</c:forEach>
    	</c:if>
    	
 	</table>
	</div></div>
	
	
	<footer>
		<jsp:include page="stFooter.jsp" />
	</footer>
	
</body>
<script type="text/javascript">

	function imgView(url){
		if(url) {
			var imgW = document.getElementById('bizImg').naturalWidth;
			var imgH = document.getElementById('bizImg').naturalHeight;
			var imgWindow = window.open("", "_image_view_", "width="+imgW, "height="+imgH);
			imgWindow.document.write("<img src='"+url+"'>");
		}
	}

	function sendAuthMail(email, id) {
		var mailvar = email;
		console.log(mailvar);
		var cnum = id;
		var mailObj = {"c_email" : mailvar, "c_num" : cnum};
		console.log(mailObj);

		$.ajax({
			url : "stAuthMail",
			type : "post",
			data : mailObj,
			success: function(data){
				alert("인증메일이 발송되었습니다.");			
			},
			error : function(error) {
				alert(error);
			}
		});
	}
	
</script>
</html>