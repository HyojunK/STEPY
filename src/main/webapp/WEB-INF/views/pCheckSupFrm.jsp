<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>체크리스트</title>
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
	<button class="btn btn-default btn-lg" type="button" onclick="location.href='pPlanList?id=${member.m_id}'">
	<span class="glyphicon glyphicon-arrow-left" aria-hidden="true"> 목록으로&nbsp;</span>
	</button>
	<div class="page-header">
		<div class="plan-edit-box">
		<h1 class="plan-name">${plan.t_planname} &nbsp;&nbsp;<small>${plan.t_spot}</small></h1>
		<span class="glyphicon glyphicon-option-vertical plan-edit" aria-hidden="true"></span>
		</div>
		<div class="edit-menu">
			<ul class="edit-menu-sub">
				<li class="edit-plan-name">여행 정보 수정</li>
				<c:if test="${member.m_id == plan.t_id}">
					<li class="del-plan">여행 삭제하기</li>
				</c:if>
				<c:if test="${member.m_id != plan.t_id}">
					<li class="exit-plan">여행에서 나가기</li>
				</c:if>
			</ul>
		</div>
		<h3 style="margin-top: 0"><small>${plan.t_stdate} ~ ${plan.t_bkdate}</small></h3>
		<input class="btn btn-default add-party-btn show-member-btn" type="button" value="${plan.t_id}님 외 ${memCnt}명">
		<input class="btn btn-default add-party-btn inviteBtn" type="button" value="일행 초대하기 +">
	
		<div class="show-member-wrap">
			<h4><strong>참여중</strong></h4>
			<p class="leader">${plan.t_id}</p>
			<c:if test="${plan.t_member1 != ' '}"><p class="member" title="내보내기" id="member1">${plan.t_member1}</p></c:if>
			<c:if test="${plan.t_member2 != ' '}"><p class="member" title="내보내기" id="member2">${plan.t_member2}</p></c:if>
			<c:if test="${plan.t_member3 != ' '}"><p class="member" title="내보내기" id="member3">${plan.t_member3}</p></c:if>
			<c:if test="${plan.t_member4 != ' '}"><p class="member" title="내보내기" id="member4">${plan.t_member4}</p></c:if>
			<c:if test="${plan.t_member5 != ' '}"><p class="member" title="내보내기" id="member5">${plan.t_member5}</p></c:if>
			<c:if test="${!empty waitingList}">
				<h4><strong>초대중</strong></h4>
				<c:forEach var="wList" items="${waitingList}">
					<p class="invitedMember" title="초대 취소">${wList.i_inviteid}</p>
				</c:forEach>
			</c:if>
		</div>
	</div>
	<ul class="nav nav-pills nav-justified">
	  <li role="presentation"><a href="pPlanFrm?planNum=${curPlan}">일정</a></li>
	  <li role="presentation"><a href="pHouseholdFrm?planNum=${curPlan}">가계부</a></li>
	  <li role="presentation" class="active"><a href="pCheckSupFrm?planNum=${curPlan}">체크리스트</a></li>
	</ul>
	<div class="contents-box">
		<div class="dayList">
			<c:forEach var="cvList" items="${cvList}">
				<div class="page-header">
					<h1 style="padding-right: 15px">${cvList.cl_categoryname}
					<div class="dayDelBtn pull-right" title="카테고리 삭제" onclick="if(confirm('카테고리를 삭제하시겠습니까?')) location.href='delCheckCategory?category=${cvList.cl_category}'"><img src="resources/images/remove.png"></div>
					<div class="dayEditBtn pull-right" title="준비물 수정" onclick="categoryPopup(${cvList.cl_category})"><img src="resources/images/edit.png"></div>
					</h1>
				</div>
				<div class="dayList-sub">
					<c:set var="itemCnt" value="1"/>
					<c:forEach var="checklist" items="${checklist}">
					  	<c:if test="${cvList.cl_category == checklist.cl_category}">
					  	<div class="panel panel-default">
							<div class="panel-body">
								<c:choose>
									<c:when test="${checklist.cl_check == 1}">
									<div id="ajax-box${checklist.cl_category}${itemCnt}">
										<input class="inp-cbx" id="cbx${checklist.cl_category}${itemCnt}" type="checkbox" style="display: none" checked/>
										<label class="cbx" for="cbx${checklist.cl_category}${itemCnt}" onclick="checkItem(${checklist.cl_category}, ${itemCnt}, ${checklist.cl_check})">
											<span>
												<svg width="12px" height="9px" viewbox="0 0 12 9">
												<polyline points="1 5 4 8 11 1"></polyline>
												 </svg>
											 </span>
											 <span>${checklist.cl_item}</span>
										 </label>
										 <div class="dayDelBtn pull-right" title="준비물 삭제" onclick="if(confirm('준비물을 삭제하시겠습니까?')) location.href='delCheckItem?category=${checklist.cl_category}&itemCnt=${itemCnt}'"><img src="resources/images/remove.png"></div>
										 <div class="dayEditBtn pull-right" title="준비물 수정" onclick="togglePopup(${checklist.cl_category},${itemCnt})"><img src="resources/images/edit.png"></div>
									</div>
									</c:when>
									<c:when test="${checklist.cl_check == 0}">
										<div id="ajax-box${checklist.cl_category}${itemCnt}">
											<input class="inp-cbx" id="cbx${checklist.cl_category}${itemCnt}" type="checkbox" style="display: none"/>
											<label class="cbx" for="cbx${checklist.cl_category}${itemCnt}" onclick="checkItem(${checklist.cl_category}, ${itemCnt}, ${checklist.cl_check})">
												<span>
													<svg width="12px" height="9px" viewbox="0 0 12 9">
													<polyline points="1 5 4 8 11 1"></polyline>
													 </svg>
												 </span>
												 <span>${checklist.cl_item}</span>
											 </label>
											 <div class="dayDelBtn pull-right" title="준비물 삭제" onclick="if(confirm('준비물을 삭제하시겠습니까?')) location.href='delCheckItem?category=${checklist.cl_category}&itemCnt=${itemCnt}'"><img src="resources/images/remove.png"></div>
											  <div class="dayEditBtn pull-right" title="준비물 수정" onclick="togglePopup(${checklist.cl_category},${itemCnt})"><img src="resources/images/edit.png"></div>
										</div>
									</c:when>
								</c:choose>
							</div>
						</div>
						<c:set var="itemCnt" value="${itemCnt + 1}"/>
					  	</c:if>
					</c:forEach>
				</div>
			<input class="btn btn-default btn-block btn-lg add-party-btn" type="button" value="준비물 추가 +" onclick="location.href='pAddCheckItemFrm?category=${cvList.cl_category}&categoryName=${cvList.cl_categoryname}&itemCnt=${itemCnt}'">
			</c:forEach>
			<div class="page-header"></div>
			<input class="btn btn-default btn-block btn-lg add-party-btn" type="button" value="카테고리 추가 +" onclick="location.href='pAddCheckCategoryFrm?category=${categoryNum + 1}'">
	  </div>
	  <div class="popup-wrap">
		<div class="popup-area">
			<div class="popup-close"><img src="resources/images/close.png" width="15"></div>
				<div class="search-box">
					<div class="page-header edit-title">
					  <h3>준비물 수정</h3>
					</div>
				</div>
			<div class="add-store-box">
			<form action="pEditCheckItem" id="itemEditFrm">
			<input type="hidden" name="cl_plannum" value="${curPlan}">
			<input type="hidden" name="cl_category" class="inputCategory">
			<input type="hidden" name="cl_cnt" id="inputCnt">
			<textarea class="form-control" rows="8" id="inputItem" name="cl_item" placeholder="수정할 내용을 입력해주세요 (최대 20자)" style="resize: none;" onkeyup="lengthCheck()"></textarea>
			<div class="row" style="margin-top: 30px">
				<div class="col-sm-6">
					<input class="btn btn-default btn-block del-party-btn cancel" type="button" value="취소">
				</div>
				<div class="col-sm-6">
					<input class="btn btn-default btn-block add-party-btn" type="submit" value="완료">
				</div>
			</div>
			</form>
			<form action="pEditCheckCategory" id="categoryEditFrm">
			<input type="hidden" name="cl_plannum" value="${curPlan}">
			<input type="hidden" name="cl_category" class="inputCategory">
			<textarea class="form-control" rows="8" id="inputCategoryName" name="cl_categoryname" placeholder="수정할 내용을 입력해주세요 (최대 20자)" style="resize: none; displany: none;" onkeyup="lengthCheck()"></textarea>
			<div class="row" style="margin-top: 30px">
				<div class="col-sm-6">
					<input class="btn btn-default btn-block del-party-btn cancel" type="button" value="취소">
				</div>
				<div class="col-sm-6">
					<input class="btn btn-default btn-block add-party-btn" type="submit" value="완료">
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="popup-background"></div>
	</div>
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
$(function(){
	//일행 초대 버튼 클릭
	$(".inviteBtn").click(function(){
		var id = '${member.m_id}';
		var planNum = ${curPlan};
		var planName = '${plan.t_planname}';
		
		location.href="pInviteMemberFrm?id=" + id + "&planName=" + planName;
	})
	
	//일행 초대 버튼 클릭
	$(".inviteBtn").click(function(){
		var id = '${member.m_id}';
		var planNum = ${curPlan};
		var planName = '${plan.t_planname}';
		
		location.href="pInviteMemberFrm?id=" + id + "&planNum=" + planNum + "&planName=" + planName;
	})
	
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
	
});
//준비믈 체크 상태 변경
function checkItem(category, itemCnt, check){
	var planNum =${curPlan}
	//console.log($("#ajax-box" + category + itemCnt));	
	if(check == 0) check = 1;
	else if(check == 1) check = 0;
	
	var obj = {"planNum": planNum, "category": category, "itemCnt": itemCnt, "check": check};
	console.log(obj);
	$.ajax({
		url: "pChangeCheck",
		type: "post",
		data: obj,
		dataType: "json",
		success: function(data){
			//console.log(data);
			var str = null;
			if(check == 0){
				str = '<input class="inp-cbx" id="cbx' + category + itemCnt + '" type="checkbox" style="display: none"/>'
			}
			else if(check == 1){
				str = '<input class="inp-cbx" id="cbx' + category + itemCnt + '" type="checkbox" style="display: none" checked/>'
			}
			str += '<label class="cbx" for="cbx' + category + itemCnt + 
					'" onclick="checkItem(' + category + ', ' + itemCnt + ', ' + check + ')">' +
					'<span><svg width="12px" height="9px" viewbox="0 0 12 9"><polyline points="1 5 4 8 11 1"></polyline></svg></span>' +
					'<span>' + data.cl_item + '</span></label>' +
					'<div class="dayDelBtn pull-right" title="준비물 삭제" onclick="' +
					"if(confirm('준비물을 삭제하시겠습니까?')) location.href='delCheckItem?category=" + category + "&itemCnt=" + itemCnt + "'" +
					'"><img src="resources/images/remove.png"></div>' +
					' <div class="dayEditBtn pull-right" title="준비물 수정" onclick="' +
					'togglePopup(' + category + ',' + itemCnt +')"><img src="resources/images/edit.png"></div>'
			
			$("#ajax-box" + category + itemCnt).html(str);
		},
		error: function(error){
			console.log(error)
		}
	});
}

//팝업창 온오프
function togglePopup(category, itemCnt, categoryName) {
	$(".popup-wrap").css("opacity","1").css("visibility","visible");
	$("#itemEditFrm").css("display", "block");
	$("#categoryEditFrm").css("display", "none");
	
	//폼 value 입력
	$(".inputCategory").val(category);
	$("#inputCnt").val(itemCnt);
	
	//팝업창 제목 변경
	$(".edit-title").html("<h3>준비물 수정</h3>");
}
//카테고리 변경 팝업
function categoryPopup(category){
	$(".popup-wrap").css("opacity","1").css("visibility","visible");
	$("#itemEditFrm").css("display", "none");
	$("#categoryEditFrm").css("display", "block");
	
	//폼 value 입력
	$(".inputCategory").val(category);
	
	//팝업창 제목 변경
	$(".edit-title").html("<h3>카테고리 수정</h3>");
}

$(function(){
	$(".cancel").click(function(){
		$(".popup-wrap").css("opacity","0").css("visibility","hidden");
		$("#inputItem").val("");
		$("#inputCategoryName").val("");
	});
	$(".popup-close").click(function(){
		$(".popup-wrap").css("opacity","0").css("visibility","hidden");
		$("#inputItem").val("");
		$("#inputCategoryName").val("");
	});
	$(".popup-background").click(function(){
		$(".popup-wrap").css("opacity","0").css("visibility","hidden");
		$("#inputItem").val("");
		$("#inputCategoryName").val("");
	});
});

//내용 입력 글자수 제한
function lengthCheck(){
	var str = $("#inputItem").val();
	var str2 = $("#inputCategoryName").val();
	
	if(str.length > 20 || str2.length > 20){
		$("#inputItem").val("");
		$("#inputCategoryName").val("");
		alert("내용은 20글자 까지만 입력해주세요");
	}
}
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

//여행 수정 메뉴
var menuClose = true;
$(function(){
	//메뉴 클릭시 창 온오프
	$(".plan-edit").click(function(){
		if(menuClose){
			$(".edit-menu").css("display", "inline-block");
			menuClose = false;
		}
		else if(!menuClose){
			$(".edit-menu").css("display", "none");
			menuClose = true;
		}
	});
	
	//여행 삭제
	$(".del-plan").click(function(){
		if(confirm('여행을 삭제하면 저장된 모든 내용이 삭제 됩니다.\n정말로 삭제하시겠습니까?')){
			location.href="pDelPlan";
		}
	});
	
	//여행 수정
	$(".edit-plan-name").click(function(){
		location.href="pEditPlanFrm"
	});
});

//일행 보기 메뉴
var showMemberClose = true;
$(function(){
	//버튼 클릭시 세부사항 온오프
	$(".show-member-btn").click(function(){
		if(showMemberClose == true){
			$(".show-member-wrap").css("display", "block");
			showMemberClose = false;
		}
		else{
			$(".show-member-wrap").css("display", "none");
			showMemberClose = true;
		}
	});
	
	//리더 로그인시 메뉴 활성화
	if(${plan.t_id == member.m_id}){
		$(".member").addClass("member-leader");
	}
	
	//초대 취소
	$(".invitedMember").click(function(){
		var id = $(this).text();
		
		if(confirm('초대를 취소하시겠습니까?')){
			location.href="pCancelInvite?planNum=" + ${curPlan} + "&id=" + id;
		}
	})
	//내보내기
	$(".member-leader").click(function(){
		var id = $(this).attr('id');

		if(confirm('회원을 내보내시겠습니까?')){
			location.href="pDepMember?planNum=" + ${curPlan} + "&member=" + id;
		}
	})
});
</script>
</html>