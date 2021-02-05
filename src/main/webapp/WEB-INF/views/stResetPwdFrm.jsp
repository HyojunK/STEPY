<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>비밀번호 재설정</title>
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
.input-mt {
	margin-top: 5px;
}
</style>

</head>

<body>
	<header>
		<jsp:include page="stHeader.jsp" />
	</header>
	
	<!-- section -->
	<div class="container center-block" style="width:400px;">
		<form action="./stResetPwdProc" method="post">
			<h3 class="text-left">3. 비밀번호 재설정</h3>
			<h6>*새로운 비밀번호를 입력해주세요.</h6>
			<div class="col-12">
				<label for="inputAddress" class="form-label">새 비밀번호</label><br>
    			<input type="password" class="form-control" id="c_pwd" name="c_pwd" required placeholder="새 비밀번호">
    			<input type="password" class="form-control input-mt" id="c_pwd2" required placeholder="새 비밀번호 확인">
    			<input type="hidden" name="nothing" id="nothing" value="">
			</div>
			<div class="col-12">
  				<h6 class="pwdComp text-right"></h6>
  			</div> 	
						
			<button type="submit" class="btn">다음</button>
			<button type="button" class="btn btn-color" onclick="location.href='./stHome'">돌아가기</button>				
		</form>
	</div>
		
	<footer>
		<jsp:include page="stFooter.jsp" />
	</footer>
</body>
<script type="text/javascript">
$("#c_pwd2").on('change paste', function(){	
	var pwd1 = $("#c_pwd").val();
	var pwd2 = $("#c_pwd2").val();
	var msg1 = "*일치합니다.";
	var msg2 = "*일치하지 않습니다. 다시 작성하여 주십시오";
		
	if(pwd1 == pwd2){
		document.querySelector(".pwdComp").innerHTML = msg1;
		document.querySelector(".pwdComp").style.color = 'blue';
	} else {
		document.querySelector(".pwdComp").innerHTML = msg2;
		document.querySelector(".pwdComp").style.color = 'red';
		$('#c_pwd').val('');
		$('#c_pwd2').val('');
		$('#c_pwd').focus();
	}

	
});

</script>
</html>