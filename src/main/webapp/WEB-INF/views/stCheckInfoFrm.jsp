<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>본인 확인</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<script type="text/javascript">
$(function(){	
	$(".suc").css("display", "none");
	$(".bef").css("display", "block");
	
	var chk = "${msg}";
	if(chk != ""){
		alert(chk);
		location.reload(true);
	}
});

</script>

<style type="text/css">
.btn {
	background-color: #4375D9;
	color: white;
	margin-top: 30px;
	width: 100%;
}
.btn-color {
	background-color: #F2b950;
	margin-top: 10px;
}
h6 {
	color: #F25D07;
}
label {
	margin-top: 10px;
}
</style>

</head>

<body>
	<header>
		<jsp:include page="stHeader.jsp" />
	</header>
	
	<!-- section -->
	<div class="container center-block" style="width:400px;">
		<form action="./stCheckInfoProc" method="post">
			<h3 class="text-left">2. 본인 확인</h3>
			<h6>*입점신청 시 적었던 정보를 입력해주세요.</h6>
			<p>
			<label class="form-label">사업주명</label>
			<input type="text" class="form-control" name="c_name" required autofocus>
			<label class="form-label">사업주 연락처</label>
			<input type="text" class="form-control" name="c_phone" required placeholder="예) 01012345678">
			<label class="form-label">사업주 메일주소</label>
			<input type="text" class="form-control" name="c_email" required>
			</p>
						
			<button type="submit" class="btn">다음</button>
			<button type="button" class="btn btn-color" onclick="location.href='./stHome'">돌아가기</button>				
		</form>
	</div>
		
	<footer>
		<jsp:include page="stFooter.jsp" />
	</footer>
</body>
</html>