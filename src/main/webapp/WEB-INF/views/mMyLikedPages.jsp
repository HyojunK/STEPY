<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내가 좋아요한 글</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">


</head>
<body>

	<header>
		<jsp:include page="header.jsp" />
	</header>
	<main class="container">

		<input id="check1" type="checkbox"> <label for="check1">Check me</label>
		<button onclick="bla()">click</button>
		<p>???</p>

		<div class="col-sm-7 requirecheck">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" name="m_gender" id="gender_wm" value="여성">
				<label class="form-check-label" for="gender_wm"> 여성 </label>
			</div>
			<div class="form-check">
				<input class="form-check-input" type="checkbox" name="m_gender" id="gender_m" value="남성">
				<label class="form-check-label" for="gender_m"> 남성 </label>
			</div>
		</div>

	</main>
	<footer>
		<jsp:include page="footer.jsp" />
	</footer>
</body>

<script>
function bla(){


	$("p").text("hello");
	
	var wm = $("#gender_wm");
	var tf1 = wm.prop('checked');
	console.log(tf1);
	var m = $("#gender_m");
	var tf2 = wm.prop('checked');

	if(tf1 == false && tf2 == false){
		alert("성별을 입력해주세요");
		return false;
	}
	
}


</script>
</html>