<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>상품 등록하기</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<script type="text/javascript">
$(function(){
	$(".suc").css("display", "block");
	$(".bef").css("display", "none");
	$(".add3").css("display", "none");
	$("#add2").css("display", "none");
});
</script>
<style type="text/css">
.btn {
	background-color: #4375D9;
	color: white;
	width: 100%;
	margin: 5px 0px;
}
.btn-color {
	background-color: #F2B950;
	margin-bottom: 50px;
}
.btn-mt {
	margin-top: 30px;
}
label {
	margin-top: 10px;
}
.nomar {
	margin-bottom: 0px;
}
.must {
	color: red;
	font-size: x-small;
	vertical-align: text-top;
}



</style>
</head>
<body>
	<header>
		<jsp:include page="stHeader.jsp" />
	</header>
	
	<!-- section -->
	<div class="container center-block" style="width:600px;">
		<form name="stWriteFrm" action="./stWriteProc" method="post" enctype="multipart/form-data">
		<div class="col-12">
    		<label for="inputAddress" class="form-label">상품명<span class="must"> *필수</span></label>
    		<input type="hidden" name="pl_cnum" value="${ceo.c_num}">
    		<input type="text" class="form-control" name="pl_name" placeholder="10자 이내" required autofocus>    		
  		</div>
  		<div class="col-12">
    		<label for="inputAddress" class="form-label">가격<span class="must"> *필수</span></label>
    		<input type="number" class="form-control" name="pl_price" required>    		
  		</div>
  		<div class="col-12">
    		<label for="inputAddress" class="form-label">인원<span class="must"> *필수</span></label>
    		<input type="number" class="form-control" name="pl_person" required>    		
  		</div>
  		<div class="col-12">
    		<label for="inputAddress" class="form-label">수량</label>
    		<input type="number" class="form-control" name="pl_qty">    		
  		</div>  		
  		<div class="col-12">
    		<label for="inputAddress" class="form-label">특징</label>
    		<textarea class="form-control" rows="3" name="pl_text" placeholder="500자 이내"></textarea>
  		</div>
  		<div class="col-12">	  		
  			<label for="file" class="nomar">상품 사진 업로드<span class="must"> *필수</span></label>
  			<h6 class="text-left">
  				상품의 특징을 잘 보여줄 수 있는 대표사진을 1장 선택해주세요:)	
  			</h6>			  					
  			<input type="file" name="files" id="file" required accept="image/jpeg, image/jpg, image/png">
  			<input class="hidden upload-name" readonly>
  			<input type="hidden" id="filecheck" value="0" name="fileCheck">  			
		</div>
			<div class="col-12 btn-mt">
   				<button type="submit" class="btn">상품 등록하기</button><br>
   				<button type="button" class="btn btn-color" onclick="location.href='./stMyProd'">돌아가기</button>
 			</div>		
		</form>
	</div>
	
	<footer>
		<jsp:include page="stFooter.jsp" />
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
		$(".upload-name").val("선택된 파일 없음");
	} else {
		console.log("not empty");
		$("#filecheck").val(1);
	}
});


</script>
</html>