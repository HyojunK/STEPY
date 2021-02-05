<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>STEPY 사장님</title>
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
	margin-top: 10px;
	width: 100%;
}
.btn-color {
	background-color: #F2b950;
	margin-top: 0px;
}
label {
	margin-top: 10px;
}
.msg1 {
	margin-top: 40px;
}
</style>

</head>

<body>
	<header>
		<jsp:include page="stHeader.jsp" />
	</header>
	
	<!-- section -->
	<div class="container center-block" style="width:400px;">
		<form action="./stLoginProc" method="post">
			<h3 class="text-left">사장님 로그인</h3>
			<label class="form-label">사업자번호</label>
			<input type="text" class="form-control" name="c_num" required autofocus>
			<label class="form-label">비밀번호</label>
			<input type="password" class="form-control" name="c_pwd" required>
			<button type="submit" class="btn">로그인</button>
			<h6 class="text-right"><a href="./stFindPwdFrm">비밀번호 찾기</a></h6>		
			<h6 class="text-center msg1">처음이신가요? 입점 신청 후 이용 바랍니다.</h6>
			<button class="btn btn-color" onclick="location.href='./stJoinFrm'">입점 신청하기</button>			
		</form>
	</div>
		
	<footer>
		<jsp:include page="stFooter.jsp" />
	</footer>
</body>
</html>