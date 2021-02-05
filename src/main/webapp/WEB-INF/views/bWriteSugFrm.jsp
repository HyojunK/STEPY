<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>건의사항 글 작성</title>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<script type="text/javascript">
	$(function() {
		$(".suc").css("display", "none");
		$(".bef").css("display", "none");
		$(".buc").css("display", "none");
		
		var id = "${member.m_id}";
		
		if(id == "" || id == null){
			alert("로그인 후 이용해 주세요.");
			location.href="./bCommunity";
		}

	});
</script>
<body>

	<header>
		<jsp:include page="header.jsp" />
	</header>

	<section>

		<div class="row">
			<form action="./sugData" method="post" enctype="multipart/form-data">
				<div class="col-md-6 col-md-offset-3 col-xs-12" style="padding-top: 15px; padding-bottom: 15px; margin-bottom: 50px;">
					<div class="col-md-10 col-md-offset-1">
						<input type="text" class="form-control col-xs-8" placeholder="제목을 입력해 주세요."
							name="sug_title">

						<textarea rows="15" name="sug_contents" placeholder="내용을 적어주세요."
							class="write-input ta col-xs-12"
							style="border: 1px solid #ccc; margin-bottom: 50px;"></textarea>

						<input type="hidden" name="sug_mid" value="${member.m_id}" >
						<div class="row" style="text-align: center; margin-top:100px;">
							<button class="btn btn-info" type="submit" style="background-color: #4375d9;">등록</button>
							<input class="btn btn-info" type="button" value="뒤로가기" style="background-color: #4375d9;"
						onclick="location.href='./bSugList'">
						</div>

					</div>
				</div>
			</form>
		</div>
	</section>

	<footer>
		<jsp:include page="footer.jsp" />
	</footer>

</body>
</html>