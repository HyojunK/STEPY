<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>글 수정</title>
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
				
		var msg = "${msg}";
			
	});
</script>
</head>
<body>

	<header>
		<jsp:include page="header.jsp" />
	</header>

	<section>
		
		<div class="row">
			<form action="./PostUpdate" method="post" 
				enctype="multipart/form-data">
				<div class="col-md-6 col-md-offset-3 col-xs-12">
					<div class="col-md-10 col-md-offset-1">
						<input type="text" class="form-control col-xs-8" value="${post.ptitle}"
							name="ptitle">
							 
						<select class="form-control col-xs-8" name="pcategory">
							<option>${post.pcategory}</option>
							<option>자유</option>
							<option>메이트 구하기</option>
							<option>후기</option>
							<option class="suc">공지글</option>
						</select> 
						
						<textarea  rows="15" name="pcontents"
							class="write-input ta col-xs-12" style=" border: 1px solid #ccc;">${post.pcontents}</textarea>
					
						<div class="filebox">
							<div class="befor-file" style="margin-bottom: 10px;">
								<c:if test="${empty fList}">
									<label style="width: 100%">파일변경</label> 
								</c:if>
								<c:if test="${!empty fList}">
									<c:forEach var="file" items="${fList}">
										<label style="width: 100%;" onclick="del('${file.con_sysname}')">
										${file.con_oriname}
										</label>
									</c:forEach>
								</c:if>
						</div>
						<label for="file" class="col-xs-2">파일 +</label>
						<input type="file" name="files" id="file" multiple>
						<input class="upload-name" value="파일선택"
						readonly>
						<input type="hidden" id="filecheck" value="0"
						name="fileCheck">
						<input type="hidden" name="pnum" value="${post.pnum}">
						<div class="col-md-6 col-xs-12" style="margin-top: 30px;">
						<button class="btn btn-info col-xs-offset-5" type="submit" style="margin-top:10px; background-color: #4375d9;">등록</button>
						</div>
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

function dal(con_sysname){
	var con = confirm("파일을 삭제하시겠습니까?");
	if(con){
		var objdata = {"con_sysname":con_sysname};
		
		$.ajax({
			url: "delfile",
			type: "get",
			data: objdata,
			success: function(data){
				alert(data);
				location.reload(true);
			},
			error: function(error){
				alert("삭제 실패")
			}
		});
	}
}
</script>
</html>