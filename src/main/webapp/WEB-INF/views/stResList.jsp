<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>예약 현황 보기</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<link href='resources/css/main.css' rel='stylesheet' />
<script src='resources/js/main.js'></script>
<script type="text/javascript">
$(function(){
	$(".suc").css("display", "block");
	$(".bef").css("display", "none");
});
</script>
<script>
function getTimeStamp() {
	var d = new Date();
	var s = leadingZeros(d.getFullYear(), 4) + '-' +
			leadingZeros(d.getMonth() + 1, 2) + '-' +
			leadingZeros(d.getDate(), 2);
	return s;
}
function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();
	if(n.length < digits) {
		for(i = 0; i < digits - n.length; i++)
			zero += '0';
	}
	return zero + n;
}
	
	var today = getTimeStamp();
  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new FullCalendar.Calendar(calendarEl, {
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      initialDate: today,
      navLinks: true, 
      selectable: true,
      selectMirror: true,
      select: function(arg) {
        var title = prompt('일정 제목 : ');
        if (title) {
          calendar.addEvent({
            title: title,
            start: arg.start,
            end: arg.end,
            allDay: arg.allDay
          })
        }
        calendar.unselect()
      },
      eventClick: function(arg) {
        if (confirm('예약을 삭제하시겠습니까?')) {
          arg.event.remove()
        }
      },
      editable: true,
      dayMaxEvents: true,
      events: [
    	  <c:forEach var="res" items="${resMap}">
    	 	{
              title: '예약번호 : ' +'${res.value.res_num}' + '번',
              start: '${res.value.res_checkindate}',
              end: '${res.value.res_checkoutdate}'
            },    	  
    	  </c:forEach>       
      ]
    });

    calendar.render();
  });

</script>
<style>
body {
	font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
	font-size: 14px;
}
#calendar { width: 100%; }
.left {
  	float: left;
  	width: 35%;
  	padding-top: 30px;
}
.right {
  	float: right;
  	width: 60%;
  	padding-top: 30px;
}
.badge {
  	background-color: #f2b950!important;
  	color: white;
}
.panel-heading {
  	background-color: #2c3e50!important;
  	color: white!important;
}
.b-color {
	background-color: rgb(118, 130, 142)!important;
  	color: white;
}
.fc-event-title-container {
	background-color: #4375d9!important;
}

</style>
</head>
<body>
	<header>
		<jsp:include page="stHeader.jsp" />
	</header>
	
	<!-- section -->
	<div class="container center-block" style="width:1000px; padding-bottom: 40px;">
		<ul class="nav nav-tabs nav-justified">
  			<li role="presentation"><a href="./stMyPage">내 정보 관리</a></li>
  			<li role="presentation"><a href="./stMyProd">내 상품 관리</a></li>
  			<li role="presentation" class="active"><a href="./stResList">예약 현황 보기</a></li>
  			<!-- <li role="presentation"><a href="./stReviewList">가게 후기 보기</a></li>
  			<li role="presentation"><a href="./stReportList">가게 신고 보기</a></li>  -->
		</ul>

		<div class="center-block" style="width: 1000px;">
			<div class="left">
				<div class="panel panel-default">
					<div class="panel-heading">
						<b>실시간 상품 재고</b>
					</div>
					<table class="table">
						<c:if test="${empty prodList}">
							<tr>
								<td style="text-align: center;">등록된 상품이 없습니다.</td>
							</tr>
						</c:if>
						<c:if test="${!empty prodList}">
							<tr>
								<c:forEach var="prod" items="${prodList}">
									<td style="text-align: center;">${prod.pl_name}</td>
								</c:forEach>							
							</tr>							
							<tr>
								<c:forEach var="prod" items="${prodList}">
									<td style="text-align: center;">${prod.pl_qty}</td>
								</c:forEach>							
							</tr>														
						</c:if>
					</table>
				</div>

				<div class="panel panel-default">						
					<div class="panel-heading">
						<b>예약 리스트</b>
					</div>										
					<table class="table">						
						<tr>
							<td style="text-align: center;">예약번호</td>
							<td style="text-align: center;">예약정보</td>
							<td style="text-align: center;">예약상태</td>							
						</tr>
						<c:if test="${empty resMap}">
						<tr>
							<td colspan="3" style="text-align: center;">예약 정보가 없습니다.</td>
						</tr>
						</c:if>
						<c:if test="${!empty resMap}">
							<c:forEach var="res" items="${resMap}">
							<tr>
								<td style="text-align: center;">${res.value.res_num}</td>
								<td style="text-align: center; cursor: pointer;"><span class="badge" onclick="showInfo('${res.value.res_num}');">상세보기</span></td>
								<td style="text-align: center;"><span class="badge b-color">결제완료</span></td>						
							</tr>							
							</c:forEach>							
						</c:if>						
					</table>
				</div>
			</div>
		</div>
		<div class="right">	
			<div id='calendar'></div>
		</div>	
		</div>
	
	<footer>
		<jsp:include page="stFooter.jsp" />
	</footer>
</body>
<script type="text/javascript">
function showInfo(resNum){
	var num = resNum;
	console.log(num);
	window.open("stShowInfo?res_num=" + num, "info", "width=800, height=150, left=100, top=50");
};
</script>
</html>