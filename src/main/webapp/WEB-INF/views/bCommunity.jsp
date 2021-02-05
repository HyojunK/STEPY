<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 홈</title>
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
		
		var id = "${member.m_id}";
		
		if(id == "" || id == null){
			$(".bef").css("display","block");
		}
	});
	
</script>
</head>
<body>

	<header>
		<jsp:include page="header.jsp" />
	</header>

	<section>
		
		<div class="row">
			<div class="col-md-6 col-md-offset-3 col-xs-12" style="border: 2px solid #4375d9; padding-top:15px; padding-bottom: 15px;">
				<table class="table" style="text-align: center;">
					<tr>
						<td style="width:40px;">작성자</td>
						<td style="width:230px;">제목</td>
						<td class="hidden-xs" style="width:50px;">조회수</td>	
						<td class="hidden-xs" style="width:40px;">작성일</td>	
					</tr>
					<c:forEach var="pitem" items="${pList}">
					<tr>
						<td style="width:40px;">${pitem.pmid}</td>
						<td style="width:230px;">
							<a href="contents?pnum=${pitem.pnum}">${pitem.ptitle}</a></td>
						<td class="hidden-xs" style="width:50px;">${pitem.pview}</td>	
						<td class="hidden-xs" style="width:40px;"><fmt:formatDate
									pattern="yyyy-MM-dd hh:mm" value="${pitem.pdate}" /></td>	
					</tr>
					</c:forEach>				
				</table>
					<div class="row">
						<div class="col-xs-12" style="text-align: center;">${paging}</div>	
					</div>
					<div class="row" style="text-align: center;">
						<button type="button" class="btn btn-info"
							onclick="location.href='./bWriteProc'" style="margin-top:50px; background-color: #4375d9;">글쓰기</button>
					</div>
			</div>
		</div>
	</section>

	<footer>
		<jsp:include page="footer.jsp" />
	</footer>

</body>
</html>