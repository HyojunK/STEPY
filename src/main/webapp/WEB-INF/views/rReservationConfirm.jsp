<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
    
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>STEPY 예약 확인</title>
	
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link href="resources/css/style.css" rel="stylesheet">

<style type="text/css">
.resConfirm {
	width: 40%;
	height: 580px;
	margin: 0 auto;
	background: #F8F8F8;
	padding: 30px;
}
.title {
	font-size: 24px;
	font-weight: bold;
}
.storeInfo {
	font-size: 20px;
	font-weight: bold;
	color: #444444;
	margin-bottom: 10px;
}
.home {
	float: right;
	border-style: none;
	background-color: #F8F8F8;
}
.contentsTitle {
	font-size: 20px;
	color: #808080;
	margin-bottom: 10px;
}
.checkin {
	float: right;
	color: black;
	font-weight: bold;
}
.price {
	float: right;
	font-size: 23px;
	font-weight: bold;
	color: #F2B950;
}
.nights {
	font-size: 20px;
	color: #808080;
	font-weight: normal;
}
ul {
	margin: 0;
	font-size: 18px;
	color: #555555;
}
li {
	margin-bottom: 5px;
}
.btnStyle {
	margin-top: 30px;
	font-size: 20px;
	color: white;
}
.cancleBtn {
	float: left;
	width: 240px;
	height: 45px;
	background: #4375D9;
	border: 1px solid #4375D9;
	border-radius: 5px;
}
.payBtn {
	float: right;
	width: 240px;
	height: 45px;
	background: #F2B950;
	border: 1px solid #F2B950;
	border-radius: 5px;
}
</style>
</head>

<body>
<header>
	<jsp:include page="header.jsp" />
</header>

<section>
	<div class="resConfirm">
		<div class="title">
			<span>예약 내역 확인</span>
			<button class="home" onclick="location.href='./'">
				<span class="glyphicon glyphicon-home -empty"></span>
			</button>
		</div>
		<hr>
		
		<div>
			<div class="storeInfo">${store.s_name}</div>
			<div class="storeInfo">${product.pl_name}</div>
			<hr>
			<div class="contentsTitle">
				<span>체크인</span> <span class="checkin">${resTicket.res_checkindate} &nbsp;(15시)</span>
			</div>
			<div class="contentsTitle">
				<span>체크아웃</span> <span class="checkin">${resTicket.res_checkoutdate} &nbsp;(11시)</span>
			</div>
			<div class="contentsTitle">
				<span>가격</span>
				<span class="price">
					<fmt:formatNumber type="number" maxFractionDigits="3" value="${realPrice}"/>원
						<span class="nights">&nbsp;/ ${nights}박</span>
				</span>
			</div>
		</div>
		<hr>
		
		<div>
			<div>
				<ul>
					<li>결제까지 마친 후에 객실을 이용하실 수 있습니다.</li>
					<li>미성년자는 보호자 동반 시 투숙이 가능합니다.</li>
					<li>취소 및 환불 규정에 따라 취소 수수료 부과 및 취소 불가 될 수 있습니다.</li>
				</ul>
			</div>
		</div>
		
		<div class="btnStyle">
			<span><button class="cancleBtn"
				onclick="location.href='./resCancle?res_num=${resTicket.res_num}'">예약 취소</button></span>
			<span><button class="payBtn" onclick="pay()">결제하기</button></span>
		</div>
	</div>
</section>

<footer>
	<jsp:include page="footer.jsp" />
</footer>
</body>

<!-- 아임포트 -->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>

<script type="text/javascript">
function pay(){
	var IMP = window.IMP; // 생략가능
	IMP.init('imp80721626'); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
	
	IMP.request_pay({
	    pg : 'kakaopay',
	    //pay_method : 'kpay',
	    merchant_uid : 'merchant_' + new Date().getTime(),
	    name : '${store.s_name}',
	    amount : '${realPrice}',
	    buyer_email : '${member.m_email}',
	    buyer_name : 'res_name',
	    buyer_tel : 'res_phone',
	    buyer_addr : '${member.m_addr}',
	    //buyer_postcode : '123-456'
	}, function(rsp) {
	    if ( rsp.success ) {
	    	//[1] 서버단에서 결제정보 조회를 위해 jQuery ajax로 imp_uid 전달하기
	    	jQuery.ajax({
	    		url: "upResStatus?res_num=${resTicket.res_num}", //cross-domain error가 발생하지 않도록 동일한 도메인으로 전송
	    		type: 'POST',
	    		dataType: 'json',
	    		data: {
		    		imp_uid : rsp.imp_uid
		    		//기타 필요한 데이터가 있으면 추가 전달
	    		}
	    	}).done(function(data) {
	    		//[2] 서버에서 REST API로 결제정보확인 및 서비스루틴이 정상적인 경우
	    		if ( everythings_fine ) {
	    			var msg = '결제가 완료되었습니다.';
	    			//msg += '\n고유ID : ' + rsp.imp_uid;
	    			//msg += '\n상점 거래ID : ' + rsp.merchant_uid;
	    			//msg += '\결제 금액 : ' + rsp.paid_amount;
	    			//msg += '카드 승인번호 : ' + rsp.apply_num;

	    			alert(msg);
	    		} else {
	    			//[3] 아직 제대로 결제가 되지 않았습니다.
	    			//[4] 결제된 금액이 요청한 금액과 달라 결제를 자동취소처리하였습니다.
	    		}
	    	});
	    } else {
	        var msg = '결제에 실패했습니다.';
	        msg += '에러내용 : ' + rsp.error_msg;

	        alert(msg);
	    }
	});
}
</script>

</html>