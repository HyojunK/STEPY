<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link href="resources/css/style.css" rel="stylesheet">


</head>
<body
	style="background-image: linear-gradient(to bottom right, rgba(67, 117, 217, 1), rgba(67, 117, 217, 0.5));"
>
	<main class="container" style="margin-top: 150px;">
		<div class="col-md-12 text-center">
			<table class="table table-hover" width="100%">
				<thead style="background-color: rgba(250, 250, 250, 0.9);">
					<tr>
						<th scope="col">발신인</th>
						<th scope="col">H</th>
						<th scope="col">내용</th>
						<th scope="col">날짜</th>
					</tr>
				</thead>
				<tbody style="background-color: rgba(250, 250, 250, 0.8); text-align:center;"
				id = "msgtbody">
				<c:forEach var="rml" items="${rmList }">
					<tr>
						<th scope="row" width="18%"><a href="./mSendMessage?toid=${rml.ms_smid }&fromid=${rml.ms_mid}">${rml.m_nickname }</a></th>
						<th width="1%"><a href="./mMyLittleBlog?blog_id=${rml.ms_smid }" 
						target="_blank"><img src="./resources/images/homeicon.png" style="width:15px; height:15px;">
						</a></th>
						<td width="63%">${rml.ms_contents }</td>
						<td width="18%">${rml.ms_date }</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</main>

</body>
</html>