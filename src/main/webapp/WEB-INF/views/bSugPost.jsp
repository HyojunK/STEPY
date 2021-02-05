<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>건의사항 내용보기</title>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<script type="text/javascript">
	$(function() {
		$(".suc").css("display", "none");
		$(".bef").css("display", "none");	
		
		var id = "${member.m_id}";
		var sid = "${sList.sug_mid}";
		
		if(id == "" || id == null){
			$(".bef").css("display", "block");
			$("#rFrm").css("display", "none");			
		}
		if(id != sid){
			$("#puls").css("display", "none");
			$("#pulss").css("display", "none");
		}
		
	});
</script>
</head>
<body>

	<header>
		<jsp:include page="header.jsp" />
	</header>

	<section>
		<div class="container">
			<div class="row">
				<div class="col-md-8 col-md-offset-2 col-xs-12"
					style="border: 2px solid #4375d9; padding-top: 20px; padding-bottom: 20px; margin-bottom: 50px;">
					<table class="table col-xs-12 col-md-8" style="margin-bottom: 0;">
						<tr>
							<td class="col-md-1 col-xs-2"
								style="background-color: #4375d9; text-align: center;">제목</td>
							<td class="col-md-7 col-xs-9">${sList.sug_title}
						</tr>
					</table>
					<table class="table col-xs-12 col-md-8" style="margin-bottom: 0;">
						<tr>
							<td class="col-md-1 col-xs-2"
								style="background-color: #4375d9; text-align: center;">작성자</td>
							<td class="col-md-3 col-xs-9">${sList.sug_mid}</td>
							<td class="hidden-xs col-md-1"
								style="background-color: #4375d9; text-align: center;">작성일</td>
							<td class="hidden-xs col-md-3"><fmt:formatDate
									pattern="yyyy-MM-dd hh:mm" value="${sList.sug_date}" /></td>
						</tr>
					</table>
					<table class="table col-xs-12 col-md-8" style="margin-bottom: 0; border-bottom: 1px solid lightgray;">
						<tr>
							<td class="hidden-xs col-md-1"
								style="text-align: center; background-color: #4375d9">내용</td>
							<td class="col-md-7 col-xs-11 " style="height: 450px;">${sList.sug_contents}</td>
						</tr>
					</table>
					<div class="row col-md-8 col-md-offset-2 col-xs-8 col-xs-offset-2"
						style="text-align: center;">
						<button class="btn btn-info" id="puls"
							onclick="location.href='./bSugModifyProc?snum=${sList.sug_num}'"
							style="margin-top: 30px; text-align: center; background-color: #4375d9;">수정</button>
						<button type="button" class="btn btn-info" id="pulss"
							onclick="location.href='./sugdel?snum=${sList.sug_num}'"
							style="margin-top: 30px; text-align: center; background-color: #4375d9;">삭제</button>
						<button class="btn btn-info"
							style="margin-top: 30px; text-align: center; background-color: #4375d9;" onclick="page()">뒤로가기</button>
					</div>

				</div>
			</div>

		</div>
	</section>

	<footer>
		<jsp:include page="footer.jsp" />
	</footer>

</body>
<script src="resources/js/jquery.serializeObject.js"></script>
<script type="text/javascript">
function page(){
	history.back();
}
</script>
</html>