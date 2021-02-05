<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>글 작성</title>
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
		if(id != "admin"){
			$("#gogo").css("display", "none");
		}

	});
</script>
</head>
<body>

	<header>
		<jsp:include page="header.jsp" />
	</header>

	<section>

		<div class="row">
			<form action="./writDate" method="post" enctype="multipart/form-data">
				<div class="col-md-6 col-md-offset-3 col-xs-12" style="padding-top: 15px; padding-bottom: 15px; margin-bottom: 50px;">
					<div class="col-md-10 col-md-offset-1">
						<input type="text" class="form-control col-xs-8" placeholder="제목을 입력해 주세요."
							name="ptitle"> <select
							class="form-control col-xs-8" name="pcategory">
							<option>카테고리를 선택해 주세요.</option>
							<option>자유</option>
							<option>메이트 구하기</option>
							<option>후기</option>
							<option id="gogo">공지글</option>
						</select>

						<textarea rows="15" name="pcontents" placeholder="내용을 적어주세요."
							class="write-input ta col-xs-12"
							style="border: 1px solid #ccc;"></textarea>

						<div class="filebox">
							<label for="file">파일 +</label> <input type="file" name="files"
								id="file" multiple> <input class="upload-name"
								value="파일선택" readonly> <input type="hidden"
								id="filecheck" value="0" name="fileCheck">
						</div>
						<input type="hidden" name="pmid" value="${member.m_id}">
						<div class="row" style="text-align: center; margin-top:100px;">
							<button class="btn btn-info" type="submit" style="background-color: #4375d9;">등록</button>
							<input class="btn btn-info" type="button" value="뒤로가기" style="background-color: #4375d9;"
						onclick="location.href='./bCommunity'">
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
<script src="resources/js/jquery.serializeObject.js"></script>
<script type="text/javascript">
$("#file").on('change', function(){
	   var files = $("#file")[0].files;
	   console.log(files);
	   
	   var fileName = "";
	   
	   for(var i = 0; i < files.length; i++){
	      fileName += files[i].name + " ";
	   }
	   console.log(fileName);
	   
	   $(".upload-name").val(fileName);
	   
	   if(fileName == ""){
	      console.log("empty");
	      $("#filecheck").val(0);
	      $(".upload-name").val("파일선택");
	   }
	   else {
	      console.log("not empty");
	      $("#filecheck").val(1);
	   }
});
</script>
</html>