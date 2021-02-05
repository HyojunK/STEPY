<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>건의사항 수정</title>
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
			
	});
</script>
</head>
<body>

	<header>
		<jsp:include page="header.jsp" />
	</header>

	<section>

		<div class="row">
			<form action="./SugUpdate" method="post"
				enctype="multipart/form-data">
				<div class="col-md-6 col-md-offset-3 col-xs-12">
					<div class="col-md-10 col-md-offset-1">
						<input type="text" class="form-control col-xs-8"
							value="${sList.sug_title}" name="sug_title">

						<textarea rows="15" name="sug_contents"
							class="write-input ta col-xs-12" style="border: 1px solid #ccc; resize: none;">${sList.sug_contents}</textarea>							
							
							<input type="hidden" name="sug_num" value="${sList.sug_num}">
							<div class="col-md-6 col-xs-12" style="margin-top: 30px;">
								<button class="btn btn-info col-xs-12 col-md-3 col-md-offset-10" type="submit"
									style="margin-top: 10px; background-color: #4375d9;">업로드</button>
							</div>
						
					</div>
				</div>
				<!-- <div class="row">
						<button class="btn btn-info" style="margin-top: 30px;"
							onclick="location.href='./bMateList?pageNum=${pageNum}'">
							뒤로가기</button>
					</div>  -->
			</form>
		</div>
	</section>

	<footer>
		<jsp:include page="footer.jsp" />
	</footer>

</body>
<script type="text/javascript">


</script>
</html>