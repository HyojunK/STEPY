<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Welcome Travelers!</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
</head>
<body style="background-image: linear-gradient(to bottom right, rgba(67, 117, 217, 1),
		rgba(67, 117, 217, 0.3));">

	<header>
		<jsp:include page="header.jsp" />
	</header>
	<main class="container">
		<div class="center-block"
			style="box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.10); 
			max-width: 600px; margin-top: 50px; margin-bottom: 100px;"
		>

			<div class="container mt-4 center-block text-center"
				style="max-width: 600px; background-color: #4375d9; color: white;"
			>
				<h1>Log In</h1>
			</div>
			<div class="container mt-4 center-block text-dark text-center"
				style="max-width: 600px; background-color: #fafafa;"
			>
				<br>
				<br>
				<form action="mLoginProc" method="post">

					<div class="form-group row">
						<label for="checkid" class="col-sm-2 col-form-label">아이디</label>
						<div class="col-sm-8">
							<input type="text" name="m_id" class="form-control" placeholder="id입력" id="checkid" required>
						</div>
					</div>

					<div class="form-group row">
						<label for="inputPassword3" class="col-sm-2 col-form-label">비밀번호</label>
						<div class="col-sm-8">
							<input type="password" name="m_pwd" class="form-control" id="inputPassword3"
								placeholder="비밀번호" required
							>
						</div>
					</div>
					
					<div class="form-group row">
						<span id="loginresult" style="display: none;"></span>
					</div>
					

					<button type="submit" class="btn" style="background-color:#4375d9; color:white;">로그인</button>

				</form>
				<br>
				<br> <a href="./kakaoLogin"> <img src=resources/images/kakao_login_medium_wide.png></a>
				<br>
				<br>
			</div>
		</div>
	</main>
	<footer>
		<jsp:include page="footer.jsp" />
	</footer>
</body>
<script>
	$(function(){
		var resultNum = ${resultNum};
		
		if(resultNum == "1"){
			$("#loginresult").css("display","block");
			$("#loginresult").text("${loginMsg}");
		}
		if(resultNum == "2"){
			$("#loginresult").css("display","block");
			$("#loginresult").text("${loginMsg}");
		}
	});
</script>

</html>