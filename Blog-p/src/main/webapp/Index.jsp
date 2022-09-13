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
</head>
<body>
<div class="container-fluid" style="background-color:#c6adf5;">
	<!-- header -->
		<%@ include file="Template-header.jsp" %>
	
	<div class="container" style="background-color:white; border-bottom-right-radius: 28px; border-bottom-left-radius: 28px;" >
	<br>	
	<br>	
	<br>	
	
	<% 
		if(request.getParameter("errorMsg") != null){		
	%>	
		<div><%=request.getParameter("erroMsg")%></div>
	<%		
		}
	%>
	<div style=" margin-left:auto; margin-right:auto; text-align:center;" >
	<h1>INDEX</h1>
	<br>
	<%
		if(session.getAttribute("loginId") == null){		// 로그인 한 적 없을때
			// 세션안에는 object 타입
	%>
	
	<h3>LOGIN</h3>
	<br>
	<form action="./loginAction.jsp" method="post" style="display: inline-block; text-align: center;">
		<table border="1" style=" border-top-width: 3px; border-right-width: 3px; border-bottom-width: 3px; border-left-width: 3px;">
			<tr>
				<td>ID</td>
				<td><input type="text" name="id"></td>
			</tr>
			<tr>
				<td>PASSWORD</td>
				<td><input type="password" name="pw"></td>
			</tr>
		</table>
		<br>
		
		<button type="submit" class="btn btn-info">로그인</button>
		<br>
		
	</form>
	<a href="./insertMemberForm.jsp" >회원가입</a>
	<br>
	
	<%
		} else {
	%>
		<br>
		<h2><%=session.getAttribute("loginId")%>(<%=session.getAttribute("loginLevel")%>)님 반갑습니다.</h2>
		<br>
		<br>
		<br>
		<br>
		<a href="./logout.jsp">로그아웃</a>
	<%		
		}
	%>
	<br>
	<br>
			<a href ="./boardList.jsp">게시판&nbsp;</a>
			<a href ="./guestbook.jsp">방명록&nbsp;</a>
			<a href ="./diary.jsp">다이어리</a>
			
			<br>
			<br>
			<br>
		</div>
		<br>
		<br>	
	<br>
	<br>
	</div>
	<br>
	<br>
	
	
	</div>
</body>
</html>
