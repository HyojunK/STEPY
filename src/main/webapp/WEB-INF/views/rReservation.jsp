<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>STEPY 예약</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link href="resources/css/style.css" rel="stylesheet">

<!-- datepicker -->
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<style type="text/css">
.personalInfo {
	float: left;
	padding: 30px;
	width: 50%;
}
.bigTitle {
	font-size: 20px;
	font-weight: bold;
	margin-bottom: 25px;
}
.title {
	font-size: 18px;
	color: #808080;
	margin-bottom: 10px;
}
.contents {
	font-size: 22px;
	font-weight: bold;
	margin-bottom: 20px;
}
.infoInput {
	margin-bottom: 20px;
}

.reservInfo {
	float: right;
	background-color: #F8F8F8;
	margin-top: 20px;
	padding: 30px;
	width: 30%
}
.calendar {
	font-size: 17px;
	margin-bottom: 20px;
}
.dateInput {
	width: 100px;
}
.VAT {
	font-size: 16px;
}
.glyphicon-chevron-down {
	color: black;
	background: #808080;
	border-style: none;
}
.price {
	font-size: 25px;
	font-weight: bold;
	color: #F2B950;
	margin-top: 10px;
}
.reservBtn{
	margin-top: 10px;
	width: 280px;
	height: 50px;
	font-size: 20px;
	color: white;
	background: #4375D9;
	border: 1px solid #4375D9;
	border-radius: 5px;
}
</style>
</head>
	
<body>
<header>
	<jsp:include page="header.jsp" />
</header>

<section>
	<div class="container">
		<form action="rReservationConfirm" method="post">
			<div class="personalInfo">
				<div class="bigTitle">예약자 정보</div>
				<div class="title">예약자 이름</div>
				<div>
					<input class="form-control input-lg infoInput" type="text" id="formGroupInputLarge" 
						placeholder="체크인 시 필요한 정보입니다." required="required" name="res_name">
				</div>
				<div class="title">예약자 번호</div>
				<div>
					<input class="form-control input-lg infoInput" type="text" id="formGroupInputLarge"
						placeholder="안심번호로 변경되어 숙소에 전달됩니다." required="required" name="res_phone">
				</div>
				<input type="hidden" name="res_mid" value="${member.m_id}">
				<input type="hidden" name="res_plnum" value="${product.pl_num}">
				<hr>
				
				<div class="VAT">
					<div>
						<span class="glyphicon glyphicon-ok"></span>
						<span>결제까지 완료되어야 체크인하실 수 있습니다.</span>
					</div>
					<div>예약 후 반드시 결제해주세요!</div>
				</div>
			</div>
			
			<!-- --------- -->
			<div>
				<div  class="reservInfo">
					<div>
						<div class="title">숙소 이름</div> <div class="contents">${store.s_name}</div>
					</div>
					<div>
						<div class="title">객실 타입</div> <div class="contents">${product.pl_name}</div>
					</div>
					<div>
						<div class="title">체크인 (15:00)</div>
						<div class="form-group calendar">
							<input type="text" id="checkinDate" class="form-control" 
								required="required" name="res_checkindate" placeholder="체크인 날짜">
						</div>
					</div>
					<div>
						<div class="title">체크아웃 (11:00)</div>
						<div class="form-group calendar">
							<input type="text" id="checkoutDate" class="form-control" 
								required="required" name="res_checkoutdate" placeholder="체크아웃 날짜">
						</div>
					</div>
					<!-- 
					<hr>
					
					<div>
						<div>
							<span class="bigTitle">총 결제 금액</span> <span class="VAT">(VAT 포함)</span>
						</div>
						<div class="price">
							<fmt:formatNumber type="number" maxFractionDigits="3" 
								value="${product.pl_price}"/>원
						</div>
					</div> -->
					
					<div>
						<input type="submit" class="reservBtn" value="예약하기">
					</div>
				</div>
			</div> <!-- 숙소 정보 -->
		</form>
	</div>
</section>

<footer>
	<jsp:include page="footer.jsp" />
</footer>
</body>

<script type="text/javascript">
$(function() {
	// 달력
	$("#checkinDate").datepicker({
    	nextText: "다음 달", // > 화살표 툴팁
    	prevText: "이전 달", // < 화살표 툴팁
    	
    	dateFormat: "yy-mm-dd", // 날짜 표기 방식
    	minDate: 0, // 오늘 이전 날짜 선택 불가
    	
    	onClose: function( selectedDate ) {    
            // 시작일(checkinDate) datepicker가 닫힐 때
            // 종료일(checkoutDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
            $("#checkoutDate").datepicker("option", "minDate", selectedDate);
        }
    });
    
    $("#checkoutDate").datepicker({
    	nextText: "다음 달", // > 화살표 툴팁
    	prevText: "이전 달", // < 화살표 툴팁
    	
    	dateFormat: "yy-mm-dd", // 날짜 표기 방식
    	minDate: 0, // 오늘 이전 날짜 선택 불가
    	
    	onClose: function( selectedDate ) {
            // 종료일(checkoutDate) datepicker가 닫힐 때
            // 시작일(fromDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 종료일로 지정 
            $("#checkinDate").datepicker("option", "maxDate", selectedDate);
        }
    });
});
</script>

</html>