<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<div class="jumbotron" style="background-color: white; margin-bottom: 0; height:150px; padding: 20px 0;">
  <img src="resources/images/logo_tp_final01.png" onclick="gohome();"
  style="width: 177px; height: 80px; margin-left: auto; margin-right: auto; display: block;">
</div>
<nav class="navbar navbar-default" style="background-color: #4375d9; border: none;;">
  <div class="container">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav navbar-right" id="headnavfont">
      	<li class="suc"><a href="./stLogout" style="color:white;">로그아웃</a></li>
        <li class="bef"><a href="./stHome" style="color:white;">로그인</a></li>
        <li class="bef"><a href="./stJoinFrm" style="color:white;">회원가입</a></li>        
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.containe -->
</nav>
<style>
body::-webkit-scrollbar { 
    display: none; 
}
</style>

<script>
function gohome(){
	var id = "${ceo.c_num}";
	
	if(id == ""){
		location.href = "./";
	}
	else if(id != ""){
		location.href = "./stMyPage";
	}
}	
</script>
      


