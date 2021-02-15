<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">


</head>
<body
	style="background-image: linear-gradient(to bottom right, rgba(67, 117, 217, 1), rgba(67, 117, 217, 0.3));"
>

	<header>
		<jsp:include page="header.jsp" />
	</header>
	<main class="container" style="margin-bottom: 200px; margin-top: 100px;">

		<div class="center-block"
			style="box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.10); max-width: 600px; margin-top: 50px; margin-bottom: 100px;"
		>

			<div class="container mt-4 center-block text-center"
				style="max-width: 600px; background-color: #4375d9; color: white;"
			>
				<h4>비밀번호 변경</h4>
			</div>
			<div class="container mt-4 center-block text-dark text-center"
				style="max-width: 600px; background-color: #fafafa;"
			>
				<br> <br>
				<form action="" method="">

					<div class="form-group row">
						<label for="checkid" class="col-sm-2 col-form-label">아이디</label>
						<div class="col-sm-8">
							<input type="text" name="m_id" class="form-control" id="checkid" value="${member.m_id }"
								readonly
							>
						</div>
					</div>

					<div class="form-group row">
						<label for="inputPassword3" class="col-sm-2 col-form-label">비밀번호</label>
						<div class="col-sm-8">
							<input type="password" class="form-control" id="pass"
								placeholder="기존의 비밀번호를 먼저 입력해주세요" required
							>

						</div>
						<div class="col-sm-2">
							<button id="precheck" type="button">확인</button>
						</div>
					</div>

					<div class="form-group row">
						<span id="prealarm" style="display: none;"></span>
					</div>

					<div class="form-group row" id="newpwd" style="display:none">
						<label for="inputPassword3" class="col-sm-2 col-form-label">새 비밀번호</label>
						<div class="col-sm-8">
							<input type="password" name="m_pwd" class="form-control" id="newpass"
								placeholder="변경할 비밀번호를 입력해주세요" required
							>
						</div>
					</div>
					<button type="button" class="btn" id="confirm" style="background-color: #4375d9; color: white;">저장</button>

				</form>

				<br>
			</div>
		</div>

	</main>
	<footer>
		<jsp:include page="footer.jsp" />
	</footer>


</body>
<script>

var confirm = document.getElementById('confirm');
confirm.addEventListener("click",function(){
	
	var newp = $("#newpass").val();
	var newpass = {"m_pwd": newp};
	newpass.m_id = $("#checkid").val();
	
	$.ajax({
		url: "mUpdatePwd",
		type:"post",
		data: newpass,
		success: function(re){
			if(re.includes("success")){
				$("#newpwd").css("display","none");
				$("#pass").val("");
				$("#prealarm").text("비밀번호가 성공적으로 변경되었습니다!");
				$("#newpass").val("");
			}	
		},
		error: function(re){
			alert("error");
		}
	});
});

var checkbtn = document.getElementById("precheck");

checkbtn.addEventListener("click",function(){
	var pass = $("#pass").val();
	var pwd = {"pwd" : pass};

	pwd.m_id = $("#checkid").val();
	
	$.ajax({
		url: "mGetCrypPwd",
		type: "post",
		data: pwd,
		success: function(re){
			if(re == "1"){
				$("#prealarm").css("display","block");
				$("#prealarm").text("변경할 비밀번호를 입력해주세요!");
				$("#newpwd").css("display","block");
			}else{
				$("#prealarm").css("display","block");
				$("#prealarm").text("비밀번호가 일치하지 않습니다.");
			}
		},
		error : function(re){
			alert("error");
		}
	});

});

</script>
</html>