<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!doctype html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>예약 상세 정보</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<style>
body::-webkit-scrollbar { 
    display: none; 
}
</style>
</head>
<body>
<div class="panel panel-default">
  <div class="panel-heading"><h4 class="text-center"><b>예약 정보</b></h4></div>  
	<table class="table">
		<tr>
			<th class="text-center">예약자명</th>
			<th class="text-center">연락처</th>
			<th class="text-center">상품명</th>
			<th class="text-center">체크인</th>
			<th class="text-center">체크아웃</th>
		</tr>
		<tr class="text-center">
			<td>${res.res_name}</td>
			<td>${res.res_phone}</td>
			<td>${res_plname}</td>
			<td>${res.res_checkindate}</td>
			<td>${res.res_checkoutdate}</td>			
		</tr>		
	</table>
</div>

</body>
</html>