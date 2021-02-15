<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	$(function() {

		var memberinfo = "${member.m_nickname}";
		if (memberinfo != "") {
			console.log(memberinfo);
			$("#mname").html(memberinfo);
			$(".suc").css("display", "block");
			$(".bef").css("display", "none");
		}

		var msgforlogin = "${msgforlogin}";
		if (msgforlogin != "") {
			alert(msgforlogin);
		}
		//메시지 출력
		var chk = "${msg}";
		if (chk != "") {
			alert(chk);
			//location.reload(true);
		}
	});
</script>
<!-- 부트스트랩 각 페이지 처리 -->
<div class="jumbotron"
	style="background-color: white; margin-bottom: 0; height: 150px; padding: 20px 0;">
	<a href="./"><img src="resources/images/logo_tp_final01.png"
		style="width: 177px; height: 80px; margin-left: auto; margin-right: auto; display: block;"></a>
</div>
<nav class="navbar navbar-default"
	style="background-color: #4375d9; border: none;">
	<div class="container">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
		</div>

		<!-- Collect the nav links, forms, and other content for toggling -->
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav navbar-right mr-auto" id="headnavfont">

				<li class="nav-item bef"><a href="./mLoginFrm"
					style="color: white;">로그인</a></li>
				<li class="nav-item bef"><a href="./mJoinFrm"
					style="color: white;">회원가입</a></li>

				<li class="nav-item suc" id="mname"
					style="display: none; color: white;"><a
					class="nav-link disabled" style="color: white;" href="#"></a></li>
				<li class="nav-item suc" style="display: none"><a
					href="./mMyPage" style="color: white;">My Page</a></li>
				<li class="nav-item suc" style="display: none"><a
					href="./mLogoutProc" style="color: white;">로그아웃</a></li>
				<li class="nav-item buc"><a href="./bReviewList"
					style="color: white;">리뷰</a></li>
				<li class="nav-item buc"><a href="./bMateList"
					style="color: white;">여행동행</a></li>
				<li class="nav-item buc"><a href="./bFreeList"
					style="color: white;">자유게시판</a></li>

			</ul>
		</div>
		<!-- /.navbar-collapse -->
	</div>
	<!-- /.containe -->
</nav>