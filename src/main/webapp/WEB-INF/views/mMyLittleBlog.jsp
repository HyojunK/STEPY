<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">

<style>
.chip {
	display: inline-block;
	padding: 0 25px;
	height: 100px;
	font-size: 16px;
	line-height: 100px;
	border-radius: 50px;
	background-color: #f1f1f1;
	background-image: linear-gradient(to bottom right, rgba(67, 117, 217, 1),
		rgba(67, 117, 217, 0.5));
	color: white;
	margin-bottom: 40px;
	box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0
		rgba(0, 0, 0, 0.10);
}

.chip img {
	float: left;
	margin: 0 10px 0 -25px;
	height: 100px;
	width: 100px;
	border-radius: 50%;
}

#li1 {
	background-color: rgba(67, 117, 217, 0.5);
}

.beneath {
	position: relative;
}

.ontext {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	font-size: 18px;
}

.gradcolor {
	background-color: rgba(67, 117, 217, 0.5);
	color: white;
	box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0
		rgba(0, 0, 0, 0.10);
}
</style>

</head>
<body>

	<header>
		<jsp:include page="header.jsp" />
	</header>
	<main class="container" style="margin-top: 70px;">

		<div class="row">
			<div class="col-sm-9">
				<div class="chip">
					<img src="resources/profile/${hostprofile.f_oriname }" alt="Person" width="96" height="96">
					<b>${hostaccount.m_nickname } 님의 게시판 입니다 ! 방문을 환영합니다!</b>
				</div>
			</div>
			<div class="col-sm-2" style="display: none" id="forguest">
				<a class="btn gradcolor" target="popup" role="button"
					onclick="window.open('http://localhost/stepy/mSendMessage?toid=${hostaccount.m_id}&fromid=${member.m_id}', 'popup', 'width=600, height=600'); return false;"
					style="padding: 10px; margin-top: 18px;"
				>쪽지보내기</a>
			</div>
			<div class="col-sm-1 forhostre" style="display: none; margin-right: 30px;" id="removealarm">
				<a class="btn gradcolor" target="popup" role="button"
					onclick="openreceivebox();removealarm();"
					style="padding: 10px; margin-top: 18px;"
				>받은 쪽지함 <span id="newMsg" class="badge badge-pill"></span></a>
			</div>
			<div class="col-sm-1 forhostse" style="display: none" id="sendbox">
				<a class="btn gradcolor" target="popup" role="button"
					onclick="opensendbox()"
					style="padding: 10px; margin-top: 18px;"
				>보낸 쪽지함</a>
			</div>
		</div>



		<ul class="nav nav-tabs nav-justified">
			<li class="nav-item"><a class="nav-link" id="li1" href="#">작성한 후기</a></li>
			<li class="nav-item"><a class="nav-link" href="#">작성한 게시글</a></li>
			<li class="nav-item"><a class="nav-link" href="#">작성한 댓글</a></li>
		</ul>


	</main>
	<footer>
		<jsp:include page="footer.jsp" />
	</footer>
</body>

<script src="resources/js/jquery.serializeObject.js"></script>
<script>
var host = "${member.m_id}";
var guest = "${hostaccount.m_id}";

	$(function() {
		console.log(host);
		console.log(guest);
		if (host == guest) {
			$(".forhostre").css("display", "block");
			$(".forhostse").css("display", "block");
		} else {
			$("#forguest").css("display", "block");
		}

		mNewMsgCount(host);
	});

	function removealarm(){
		
		var m_id = {
				"ms_mid" : host
			};

			$.ajax({
				url : "mUploadAfterView",
				type : "get",
				data : m_id,
				success : function(msgCount) {
					mNewMsgCount(host);
				},
				error : function(error) {
					alert("please work i beeeg you");
				}
			});
		
	}

	
	function mNewMsgCount(host) {

		var m_id = {
			"ms_mid" : host
		};

		$.ajax({
			url : "mNewMsgCount",
			type : "get",
			data : m_id,
			dataType : "json",
			success : function(msgCount) {
				console.log("im sleepy");
				var bf = msgCount.ms_bfread;
				var af = msgCount.ms_afread;
				var newmsg = bf - af;
				$("#newMsg").text(newmsg);
			},
			error : function(error) {
				console.log("problem?");
				alert(error);
			}
		});
	}
	
	function opensendbox(){
		window.open('http://localhost/stepy/mMeSendOverview?ms_smid=${member.m_id}', 'popup', 'width=600, height=600');
	}

	function openreceivebox(){
		window.open('http://localhost/stepy/mReceiveOverview?hostid=${member.m_id}', 'popup', 'width=600, height=600');
	}

</script>
</html>