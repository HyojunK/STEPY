<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>STEPY - 관리자 페이지</title>
<!-- 스크립트 - jquery 임포트 -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- 합쳐지고 최소화된 최신 CSS
부트스트랩 min 버전 임포트 -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<!-- 스크립트 - 부트스트랩용 스크립트 임포트 -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="resources/css/aListStyle.css">

</head>
<body>
	<!-- header,footer는 공통 양식으로 include 처리 -->
	<header>
		<jsp:include page="header.jsp" />
	</header>
	<main class="container">
		<jsp:include page="aSideBar.jsp" />
		<jsp:include page="aCeoList.jsp">
			<jsp:param value="승인 대기 업체 회원" name="type" />
			<jsp:param value="3" name="typeNum" />
		</jsp:include>
	</main>
	<footer>
		<jsp:include page="footer.jsp" />
	</footer>
</body>
</html>