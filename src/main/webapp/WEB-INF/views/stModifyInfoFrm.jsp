<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>내 정보 수정</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<style type="text/css">
.btn {
	background-color: #4375D9;
	color: white;
	margin-top: 5px;
	width: 100%;
}
.btn-color {
	background-color: #F2B950;
}
.btn-mt {
	margin-top: 125px;
}
label {
	margin-top: 10px;
}
.btn-size {
	width: 30%;
	margin-top: 0;
	float: right;
}
.leftbox {
	float: left;
}
.rightbox {
	float: right;
}
.addr-mt {
	margin-top: 5px;
}
.total-mb {
	margin-bottom: 25px;
}

</style>
<script type="text/javascript">
$(function(){
	$(".suc").css("display", "block");
	$(".bef").css("display", "none");
	
	var chk = "${msg}";
	if(chk != ""){
		alert(chk);
		location.reload(true);
	}	
});
</script>

</head>
<body>
	<header>
		<jsp:include page="stHeader.jsp" />
	</header>
	
	<!-- section -->	
	<form class="row g-3" name="stModifyInfoFrm" action="./stModifyInfo" method="post" enctype="multipart/form-data">
	<div class="container center-block total-mb" style="width:900px;">
		<div class="container leftbox" style="width: 50%;">		
			<h3 class="text-left">가게 정보 변경</h3>
			<div class="col-12">
    			<label for="inputAddress" class="form-label">가게 이름</label>
    			<input type="text" class="form-control" name="s_name" value="${store.s_name}" readonly>
  			</div>
  			<div class="col-12">
    			<label for="inputAddress" class="form-label">가게 연락처</label>
    			<input type="text" class="form-control" name="s_phone" value="${store.s_name}" required>
  			</div>    		
			<div class="form-group"> 
  				<label for="inputAddress" class="form-label">가게 주소</label><br>                
				<input class="form-control" style="width: 68%; display: inline;" name="s_addr1" id="s_addr1" type="text" value="${store.s_addr1}" required>
   				<button type="button" class="btn btn-size" onclick="execPostCode();"><i class="fa fa-search"></i>우편번호 찾기</button>                               
    			<input class="form-control addr-mt" style="top: 5px;" name="s_addr2" id="s_addr2" type="text" value="${store.s_addr2}" required>
    			<input class="form-control addr-mt" name="s_addr3" id="s_addr3" type="text" value="${store.s_addr3}" required>
			</div>
  			<div class="col-12">
    			<label for="inputAddress" class="form-label">가게 설명</label>
    			<textarea class="form-control" rows="3" name="s_summary">${store.s_summary}</textarea>
  			</div>
  			<div class="col-12">
    			<label for="inputAddress" class="form-label">카테고리</label><br>
    			<input class="form-control" name="s_category" value="${store.s_category}" readonly>    		
  			</div>
  		</div>	
	
	
		<div class="container rightbox" style="width: 50%;">		
			<h3 class="text-left">사업주 정보 변경</h3>
			<div class="col-12">
    			<label for="inputAddress" class="form-label">사업자번호</label><br>
    			<input type="text" class="form-control" name="c_num" value="${ceo.c_num}" readonly>
  			</div>
			<div class="col-12">
    			<label for="inputAddress" class="form-label">사업주명</label>
    			<input type="text" class="form-control" name="c_name" value="${ceo.c_name}" readonly>
  			</div>
  			<div class="col-12">
    			<label for="inputAddress" class="form-label">사업주 연락처</label>
    			<input type="text" class="form-control" name="c_phone" value="${ceo.c_phone}" required>
  			</div>
			<div class="col-12">  			
    			<label for="inputAddress" class="form-label">이메일</label><br> 		   		
    			<input type="text" class="form-control input-size" id="c_email" name="c_email" value="${ceo.c_email}" required>
    		</div>
			
			<div class="col-12">
   				<button type="submit" class="btn btn-mt">변경하기</button>
   				<button type="button" class="btn btn-color" onclick="location.href='./stMyPage'">돌아가기</button>
 			</div>				
		</div>
	</div>
	</form>		
	
	
	<footer>
		<jsp:include page="stFooter.jsp"/>
	</footer>

</body>
<script type="text/javascript">
function execPostCode() {
    new daum.Postcode({
        oncomplete: function(data) {           
           var fullRoadAddr = data.roadAddress;
           var extraRoadAddr = '';

           if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
               extraRoadAddr += data.bname;
           }
           
           if(data.buildingName !== '' && data.apartment === 'Y'){
              extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
           }

           if(extraRoadAddr !== ''){
               extraRoadAddr = ' (' + extraRoadAddr + ')';
           }
      
           if(fullRoadAddr !== ''){
               fullRoadAddr += extraRoadAddr;
           }

           console.log(data.zonecode);
           console.log(fullRoadAddr);           
           
           $("[name=s_addr1]").val(data.zonecode);
           $("[name=s_addr2]").val(fullRoadAddr);
       }
    }).open();
}
</script>
</html>