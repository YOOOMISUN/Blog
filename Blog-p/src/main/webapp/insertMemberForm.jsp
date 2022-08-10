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
	<!-- header -->
	<%@ include file="Template-header.jsp" %>
		
	
	<div style="margin:auto; text-align:center; height:50%;">
	<h1>회원가입</h1>
	<br>
	<%
		// 로그인 되어있으면 로그아웃 폼으로
		if(session.getAttribute("loginId") != null){
			response.sendRedirect("./Index.jsp");
			return;
			}
		if(request.getParameter("errorMsg") != null) {
	%>
		<span style="color:red;"><%=request.getParameter("errorMsg")%></span>		
			
	<%		
		}
	%>
	<form method="post" action="./insertMemberAction.jsp"  style="display:inline-block;">
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
		<button type="submit" class="btn btn-info">회원가입</button>
		<a href="javascript:history.go(-1)" class="btn btn-info" title="BACK">돌아가기</a>
	</form>
	</div>
</body>
</html>
