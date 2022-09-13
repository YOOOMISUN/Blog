<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<title>BLOG</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<!-- jQuery library -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
<!-- Popper JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
.sidemenu{ color : #3f51b5; font-weight :bold; font-family: sans-serif; padding: 0 10px; }
.menu_nav{ border-top-right-radius: 28px;
    border-top-left-radius: 28px; 
    padding: 0 60px;
    height: 56px;
    background-color: #f7faf6; 
    text-align: -webkit-match-parent;}
.small{display: block; padding-left: 80px; font: normal 15px/1.2em Arial, Helvetica, sans-serif; 
color: #edf3f6; letter-spacing: 2px;
}
.clr {
	clear:both;
	padding:0;
	margin:0;
	width:100%;
	font-size:0;
	line-height:0;
	}
.h1 { color : white; margin-bottom: -4.5rem; font-weight :bold; font-family: cursive; letter-spacing : 10px; }
</style>
</head>
<body id="myPage" data-spy="scroll" data-target=".navbar" data-offset="50">
<div class="container-fluid" style="background-color:#c6adf5; ">
	<br>
		<nav class="navbar navbar-inverse" style="height:250px; text-color:white;">
		 <div class="container-fluid">	
		<h1><a class="navbar-link h1" href="./boardList.jsp" >BLOG</a>
		<small class="small">YOOMISUN BLOG</small></h1>
 	 	</div>	
 	 	<div class="clr"></div>
 	 	<div class="container menu_nav" >
 	 		<ul class="navbar-nav" >
 	 		<li class="nav-item" >		<!-- padding 태그 사이 간격 -->
 	 	<a href="./boardList.jsp" class="sidemenu"><img src="./img/HOME.svg"> Home&nbsp;&nbsp;</a>
 	 	<a href="./guestbook.jsp" class="sidemenu"><img src="./img/book.svg"> Guestbook&nbsp;</a>
 	 	<a href="./diary.jsp" class="sidemenu"><img src="./img/calendar-date.svg"> Diary</a>
 	 	</li>
    		</ul>
        
 	 	<ul class="navbar-nav" >
 	 		<li class="nav-item">
  	  	<a href="./Index.jsp" class="sidemenu" >&nbsp;<img src="./img/person-login.svg" >&nbsp;Login&nbsp;</a>
  	 	<a href="./logout.jsp" class="sidemenu"><img src="./img/person-member.svg"> Logout&nbsp;</a>
    		</li>
    		</ul>
        </div>
	</nav>
</div>

	
	