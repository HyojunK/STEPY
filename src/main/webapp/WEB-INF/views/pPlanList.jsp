<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>나의 여행 목록</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">
<link href="resources/css/style_hjk.css" rel="stylesheet">
</head>
<body>
<header>
<jsp:include page="header.jsp"/>
</header>
<section>
<div class="container">
	<div>
	<button class="btn btn-default btn-lg" type="button" onclick="location.href='./'">
	<span class="glyphicon glyphicon-arrow-left" aria-hidden="true"> 메인으로&nbsp;</span>
	</button>
	<button class="btn btn-default btn-lg add-party-btn pull-right" type="button" onclick="location.href='./pMakePlanFrm'">새 여행 만들기</button>
	</div>
	<div class="page-header">
	  <h1>내 여행 목록</h1>
	</div>
	<div class="contents-box">
		<table class="table table-hover">
			<thead>
				<tr>
					<th class="col-sm-6">여행 이름</th>
					<th class="col-sm-2">장소</th>
					<th class="col-sm-2 hidden-xs">출발일</th>
					<th class="col-sm-2 hidden-xs">도착일</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty planList}">
						<td colspan="4">계획된 여행이 없습니다. 새로운 여행을 준비해보세요</td>
					</c:when>
					<c:when test="${!empty planList}">
						<c:forEach var="planList" items="${planList}">
							<tr>
								<td><a href="pPlanFrm?planNum=${planList.t_plannum}">${planList.t_planname}</a></td>
								<td>${planList.t_spot}</td>
								<td class="hidden-xs">${planList.t_stdate}</td>
								<td class="hidden-xs">${planList.t_bkdate}</td>
							</tr>
						</c:forEach>
					</c:when>
				</c:choose>
			</tbody>
		</table>
	</div>
	<c:if test="${iCnt != 0}">
		<div class="invite-alert-btn">
			<img src="resources/images/warning.png" width="50" title="새로운 초대가 있습니다">
		</div>
	</c:if>
	<div class="invite-wrap">
	<div class="close-btn">
	<img src="resources/images/close.png" width="15">
	</div>
	<c:forEach var="iList" items="${iList}">
		<c:if test="${iList.i_inviteid == member.m_id}">
			<div class="invite-alert">
				<div class="invite-contents">
					<p><strong>'${iList.i_mid}'</strong> 님의 여행초대</p>
					<p><strong>'${iList.i_planname}'</strong></p>
				</div>
				<div class="invite-select-box">
					<input class="btn btn-default add-party-btn col-sm-5" type="button" value="참여" onclick="location.href='pJoinPlan?code=${iList.i_code}&planNum=${iList.i_plannum}&id=${member.m_id}'">
					<input class="btn btn-default del-party-btn col-sm-offset-2 col-sm-5" type="button" value="거절" onclick="reject(${iList.i_code})">
				</div>
			</div>
		</c:if>
	</c:forEach>	
	</div>
</div>
</section>
<footer>
<jsp:include page="footer.jsp"/>
</footer>
</body>
<script src="resources/js/jquery.serializeObject.js"></script>
<script type="text/javascript">
function reject(code){
	if(confirm("거절 후에는 초대를 다시 확인할 수 없습니다")){
		var obj = {"code": code}
		console.log(obj);
		
		$.ajax({
			url: "pRejectPlan",
			type: "post",
			data: obj,
			dataType: "json",
			success: function(data){
				var str = '<div class="close-btn"><img src="resources/images/close.png" width="15"></div>';
				var iList = data.iList;
				
				for(var i = 0; i < iList.length; i++){
					
					if(iList[i].i_inviteid == '${member.m_id}'){
						str += '<div class="invite-alert" style="opacity: 0, visibility: hidden"><div class="invite-contents">' +
							'<p><strong>' + iList[i].i_mid + '</strong> 님의 여행초대</p>' +
							'<p><strong>' + iList[i].i_planname + '</strong></p></div>' +
							'<div class="invite-select-box"><input class="btn btn-default add-party-btn col-sm-5" type="button" value="참여"' + 
							'onclick="location.href=' +
							"'pJoinPlan?code=" + iList[i].i_code + '&planNum=' + iList[i].i_plannum + "&id=${member.m_id}'" + '">' +
							'<input class="btn btn-default del-party-btn col-sm-offset-2 col-sm-5" type="button" value="거절"' +
							'onclick="reject(' + iList[i].i_code + ')"></div></div>';
					}
				}
				
				$(".invite-wrap").html(str);
				
				//새로운 초대가 없으면 버튼 숨김
				if(!($(".invite-wrap").html().includes("invite-alert"))){
					$(".invite-alert-btn").css("opacity", "0");
					$(".invite-alert-btn").css("visibility", "hidden");
				}
				
				//초대 알림창 끄기
				$(".close-btn").click(function(){
					$(".invite-alert").css("opacity", "0");
					$(".invite-alert").css("visibility", "hidden");
					$(".close-btn").css("opacity", "0");
					$(".close-btn").css("visibility", "hidden");
				})
			},
			error: function(error){
				console.log(error);
				alert("오류가 발생했습니다");
			}
		})
		
	}
}

$(function(){
	//초대 알림창 켜기
	$(".invite-alert-btn").click(function(){
		$(".invite-alert").css("opacity", "1");
		$(".invite-alert").css("visibility", "visible");
		$(".close-btn").css("opacity", "1");
		$(".close-btn").css("visibility", "visible");
	})
	
	//초대 알림창 끄기
	$(".close-btn").click(function(){
		$(".invite-alert").css("opacity", "0");
		$(".invite-alert").css("visibility", "hidden");
		$(".close-btn").css("opacity", "0");
		$(".close-btn").css("visibility", "hidden");
	})
})


</script>
</html>