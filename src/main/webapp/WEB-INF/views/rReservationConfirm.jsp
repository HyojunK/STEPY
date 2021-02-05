<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>STEPY 예약 확인</title>
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
	<link href="resources/css/style.css" rel="stylesheet">
</head>

<body>
<header>
	<jsp:include page="header.jsp" />
</header>

<section>
</section>

<footer>
	<jsp:include page="footer.jsp" />
</footer>
</body>

<script type="text/javascript">
$(function() {
	// 메세지 출력
	var msg = ${msg};
	
	if(msg != null){
		alert(msg);
	}
});
</script>

</html>