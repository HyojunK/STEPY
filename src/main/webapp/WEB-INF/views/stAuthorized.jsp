<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
</head>
<body>
	<header>
		<jsp:include page="stHeader.jsp" />
	</header>
	
	<!-- section -->
	<div class="container center-block" style="width:400px;">
		<div class="alert alert-success" role="alert"><h2>환영합니다:)</h2><br>STEPY 업체 인증이 완료되었습니다.<br>로그인 후  상품을 등록해주시기 바랍니다.</div>
	</div>
	
	<footer>
		<jsp:include page="stFooter.jsp" />
	</footer>	
</body>
</html>