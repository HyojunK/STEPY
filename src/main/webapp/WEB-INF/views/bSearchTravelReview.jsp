<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
    
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>STEPY BoardPage</title>

<link rel="stylesheet"href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link href="resources/css/style.css" rel="stylesheet">

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<script type="text/javascript">
	$(function() {
		$(".suc").css("display", "none");
		$(".bef").css("display", "none");
});
</script>

<style type="text/css">
.paging{
	text-align: center;
	margin-top: 30px;
}
.pagination {
	color: #4375D9;
}

.searchFrm {
	position: absolute;
	bottom: 120px;
}
.option {
	float: left;
	width: 200px;
}
.keywordInput {
	float: left;
	width: 500px;
	margin: 0 5px;
}
.searchBtn {
	color: #4375D9;
	border: 1px solid #4375D9;
}
</style>
</head>

<body>
<header>
	<jsp:include page="header.jsp" />
</header>
	
<section>
	<div class="container">
		<!-- 키워드에 해당하는 게시판 출력(검색 결과) -->
		<div class="postTable">
			<c:if test="${empty pList}">
				해당 게시물이 없습니다.
			</c:if>
			
			<c:if test="${!empty pList}">
				<table class="table table-hover">
				<tr>
					<th>번호</th>
					<th>작성자</th>
					<th>제목</th>
					<th>조회수</th>
					<th>추천수</th>
					<th>작성일</th>
				</tr>
				
				<c:forEach var="pitem" items="${pList}">
				<tr>
					<td>${pitem.p_num}</td>
					<td>${pitem.p_mid}</td>
					<td><a href="contents?pnum=${pitem.p_num}">${pitem.p_title}</a></td>
					<td>${pitem.p_view}</td>
					<td>${pitem.p_like}</td>
					<td><fmt:formatDate value="${pitem.p_date}" pattern="yyyy-MM-dd HH:mm"/></td>
				</tr>
				</c:forEach>
				</table>
				
				<div class="paging">
					<nav>
						<ul class="pagination">
							<li><a href="#" aria-label="Previous"> <span
									aria-hidden="true">&laquo;</span>
								</a></li>
							<li><a href="#">${paging}</a></li>
							<li><a href="#" aria-label="Next"> <span
									aria-hidden="true">&raquo;</span>
								</a></li>
						</ul>
					</nav>
				</div>
			</c:if>
		</div>

		<!-- 검색창 -->
		<div class="container">
			<div class="searchFrm">
				<form action="searchTravelReview" method="post" id="searchForm">
					<select class="form-control option" name="searchOption">
						<option value="all" <c:out value="${pMap.searchOption == 'all'?'selected':''}"/>>
							전체(제목+내용+작성자)</option>	
						<option value="p_title" <c:out value="${pMap.searchOption == 'p_title'?'selected':''}"/>>
							제목</option>
						<option value="p_contents" <c:out value="${pMap.searchOption == 'p_contents'?'selected':''}"/>>
							내용</option>
						<option value="p_mid" <c:out value="${pMap.searchOption == 'p_mid'?'selected':''}"/>>
							작성자</option>
					</select>
					<input name="keyword" value="${pMap.keyword}"
						class="form-control keywordInput" type="text" placeholder="검색어를 입력해주세요.">
					<button class="btn btn-default searchBtn" type="submit">검색</button>
				</form>
			</div>
		</div>
	</div>
</section>
	
<footer>
	<jsp:include page="footer.jsp" />
</footer>
</body>

</html>