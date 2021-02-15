<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page session="false"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>STEPY 통합 검색</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link href="resources/css/style.css" rel="stylesheet">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<style type="text/css">
.searchFrm {
	margin-bottom: 30px;
}
#searchBtn {
	border: 1px solid #4375D9; 
	color: #4375D9;
}
.searchRes {
	width: 50%;
	float: left;
	margin: 30px 0;
	box-sizing: border-box;
}
.searchRes>a {
	text-decoration: none;
	color: black;
}
.storeImg {
	float: left;
	width: 250px;
	height: 200px;
	border-radius: 5px;
	
}
.glyphicon-star-empty {
	color: #F2B950;
}
.ratingValue {
	font-size: 15px;
	margin-left: 10px;
}
</style>
</head>

<body>
	<header>
		<jsp:include page="header.jsp" />
	</header>

	<section>
		<div class="container">
			<div class="container-fluid">
				<ul class="nav nav-tabs" role="tablist">
					<li role="presentation" class="active">
						<a href="#hotel" aria-controls="hotel" role="tab" data-toggle="tab">
							<h4>숙소</h4></a></li>
					<li role="presentation">
						<a href="#restaurant" aria-controls="restaurant" role="tab" data-toggle="tab">
							<h4>음식점</h4></a></li>
					<li role="presentation">
						<a href="#play" aria-controls="play" role="tab" data-toggle="tab">
							<h4>레저/티켓</h4></a></li>
				</ul>
			</div>
			
			<!-- Tab panes -->
			<div class="tab-content">
				<div role="tabpanel" class="tab-pane active searchFrm" id="hotel">
					<form action="searchHotel">
						<div class="form-group form-group-lg">
							<div class="col-sm-10">
								<input class="form-control" type="text" id="formGroupInputLarge"
									placeholder="지역, 숙소명" name="keyword">
							</div>
						</div>
						<input type="submit" class="btn btn-default btn-lg" id="searchBtn" value="검색">
					</form>
				</div>
				
				<div role="tabpanel" class="tab-pane" id="restaurant">
					<form action="searchRestaurant">
						<div class="form-group form-group-lg">
							<div class="col-sm-10">
								<input class="form-control" type="text" id="formGroupInputLarge"
									placeholder="지역, 음식점명" name="keyword" value="${keyword}">
							</div>
						</div>
						<input type="submit" class="btn btn-default btn-lg" id="searchBtn" value="검색">
					</form>
				</div>
				
				<div role="tabpanel" class="tab-pane" id="play">
					<form action="searchPlay">
						<div class="form-group form-group-lg">
							<div class="col-sm-10">
								<input class="form-control" type="text" id="formGroupInputLarge"
									placeholder="지역, 티켓명" name="keyword">
							</div>
						</div>
						<input type="submit" class="btn btn-default btn-lg" id="searchBtn" value="검색">
					</form>
				</div>
			</div>
		</div>
	</section>

	<footer>
		<jsp:include page="footer.jsp" />
	</footer>
</body>


<script type="text/javascript">
$('#myTab a').click(function (e) {
	e.preventDefault()
	$(this).tab('show')
})
</script>

</html>