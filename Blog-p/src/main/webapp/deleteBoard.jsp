<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	// 다른 경로로 들어왔을 경우 로그인이 되어있으면 로그인 페이지로 가서 로그아웃 할수 있게
	if(session.getAttribute("loginId") == null){
		response.sendRedirect("./Index.jsp");
		return;			
	}
	
	// 로그인성공했고 level이 1미만일때는 boardList로 돌아가야함
	if((Integer)session.getAttribute("loginLevel") < 1){
		response.sendRedirect("./boardList.jsp");
		return;
	}	
%>

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
		
		
	 <div class="container" style="text-align :center; margin:auto; height:80%;" >	
		<form action="./deleteBoardAction.jsp" method="post" >
			<input type="hidden" name="boardNo" value="<%=boardNo%>">	
			비밀번호 : 
			<input type="password" name="board_pw">
			<button type="submit">삭제</button>
	</form>
	<%-- 	 <%@ include file="Template-footer.jsp" %>  --%>

	<br>
</div>
</body>
</html>