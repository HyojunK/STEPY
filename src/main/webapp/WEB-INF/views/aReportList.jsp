<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String type = request.getParameter("type");
int typeNum = Integer.parseInt(request.getParameter("typeNum"));
%>
<head>
<link rel="stylesheet" href="resources/css/aListStyle.css">
</head>
<div class="list_area col-sm-3 col-md-10">
	<table class="listTbl table-bordered table-hover table-striped">
		<caption>
			<font id="caption_title"><%=type%> 리스트 보기 </font>
		</caption>
		<thead>
			<tr>
				<th class="rpNum">신고 번호</th>
				<th>신고 제목</th>
				<th>신고 항목</th>
				<th>신고일자</th>
				<th>처리 대상</th>
				<th>신고자 ID</th>
				<th>세부사항</th>
				<th>처리 상태</th>
			</tr>
		</thead>
		<c:forEach var="rpItem" items="${rpList}">
			<tr class="item">
				<td>${rpItem.rp_num }</td>
				<td>${rpItem.rp_title }</td>
				<td class="rpType">${rpItem.rp_category }</td>
				<td>${rpItem.rp_date }</td>
				<td>${rpItem.rp_mid }</td>
				<td>${rpItem.rp_cnum }</td>
				<td class="detail" onclick="reportDetail(${rpItem.rp_num})">상세보기</td>
				<td class="condition no-drag">${rpItem.rp_condition }</td>
			</tr>
		</c:forEach>
		<c:if test="${empty rpList }">
			<tr>
				<!-- 칼럼의 수만큼 colspan -->
				<td id="noData">신고를 처리할 대상이 없습니다</td>
			</tr>
		</c:if>
	</table>
	<!-- 페이지 버튼 영역 -->
	<div class="btn-area" align="center">
		<!-- 페이지 버튼, EL 처리 -->
		<div class="paging">${paging}</div>
	</div>
</div>
<script>
condiCells = document.getElementsByClassName("condition");
detailCells = document.getElementsByClassName("detail");
trs = document.getElementsByClassName("item");
typeCells = document.getElementsByClassName("rpType");

function reportDetail(rp_num) {
	location.href="aReportDetail?rp_num=" + rp_num;
};
	
//처리 중, 처리 완료에 따라 (배경색을 지정해둔) 클래스 배정
for (var i = 0; i < condiCells.length; i++) {
	if (condiCells[i].innerHTML == "처리완료") {
		condiCells[i].classList.add("finished");
	}
	else {
	condiCells[i].classList.add("unfinished");
	}
	};
</script>
<script src="resources/js/aAutoColspan.js"></script>