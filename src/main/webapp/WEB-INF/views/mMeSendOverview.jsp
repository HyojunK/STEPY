<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
.spantap {
	font-size: 16px;
	color: white;
	margin-left: 40px;
	margin-right: 40px;
}

.spanbody {
	margin-bottom: 30px;
}
#divhover{
	position:absolute;
	background-color: #ffdf5e;
	z-index:1;
	display:none;
}
#idhover:hover + #divhover{
	display:inline-block;
}
#divhover:hover{
	display:inline-block;
}
</style>

</head>
<body
	style="background-image: linear-gradient(to bottom right, rgba(67, 117, 217, 1), rgba(67, 117, 217, 0.5));"
>
	<main class="container" style="margin-top: 100px;">
		<div class="row spanbody">
			<div class="col-md-12 text-center">
				<a href="./mReceiveOverview?hostid=${member.m_id }" id="now" class="spantap"> <span class="align-middle"
					style="color: black; background-color:#f5f5f5 ;"
				>받은 메일함</span></a>&nbsp;&nbsp;&nbsp; 
				<a href="./mMeSendOverview?hostid=${member.m_id }" class="spantap">
					<span class="align-middle" style="color: black; background-color: #ffdf5e;">보낸 메일함</span>
				</a>&nbsp;&nbsp;&nbsp; 
				<a href="./mSendMessage?fromid=${member.m_id}&toid=" class="spantap">
					<span class="align-middle" style="color: black; background-color: #f5f5f5;">메일쓰기</span>
				</a>
			</div>
		</div>

		<div class="col-md-12 text-center">
			<table class="table table-hover" width="100%">
				<thead style="background-color: rgba(250, 250, 250, 0.9);">
					<tr>
						<th scope="col">수신인</th>
						<th scope="col">H</th>
						<th scope="col">내용</th>
						<th scope="col">날짜</th>
					</tr>
				</thead>
				<tbody style="background-color: rgba(250, 250, 250, 0.8); text-align: center;" id="msgtbody">
					<c:forEach var="sml" items="${smList }">
						<tr>
							<th scope="row" width="18%"><a id="idhover"
								href="./mSendMessage?toid=${sml.ms_mid }&fromid=${sml.ms_smid}"
							>${sml.m_nickname }</a><span id="divhover">${sml.ms_mid }</span></th>
							<th width="1%"><a href="./mMyLittleBlog?blog_id=${sml.ms_mid }" target="_blank">
							<span class="glyphicon glyphicon-home"></span></a></th>
							<td width="63%">${sml.ms_contents }</td>
							<td width="18%"><fmt:formatDate
											pattern="yyyy-MM-dd" value="${sml.ms_date}"
										/></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div class="col">
				<div class="paging">${paging }</div>
			</div>
		</div>
	</main>

</body>
</html>