<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String locationNo = request.getParameter("locationNo");
	
	System.out.println("boardNo : " + boardNo);
	System.out.println("commentNo : " + commentNo);
	
	// 로그인 안했으면 로그인 페이지로
	if(session.getAttribute("loginId") == null){
		response.sendRedirect("./Index.jsp");
		return;
		}
		
		Class.forName("org.mariadb.jdbc.Driver");
		String url = "jdbc:mariadb://3.37.51.139:3306/blog";
		String dbuser = "root";
		String dbpw = "java1234";
		Connection conn = DriverManager.getConnection(url,dbuser,dbpw);
		
		// 메뉴 목록
		String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		
		ResultSet locationRs = locationStmt.executeQuery();	
		
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
		
	
	<!-- left menu -->
	<div class="container">
	<div class="row">
		<div class="col-sm-2">
		<div class="list-group">
		  <ul class="nav navbar-nav list-group">
			<li class="list-group-item" style="background-color : black;"><a href="./boardList.jsp" style = "color : white; font-family: GulimChe; ">전체보기</a></li>
			<%
				while(locationRs.next()){
			%>
				<li class="list-group-item" ><a style = "color : black;" href="./boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>"><%=locationRs.getString("locationName") %></a></li>	
			<%
				}
			%>	
			</ul>
		</div>
	</div>
	
	
	<div class="col-sm-10">
	<form action="./deleteCommentAction.jsp" method="post">
		<input type="hidden" name="boardNo" value="<%=boardNo%>">	<!-- 코멘트 테이블 번호 받아와 숨기기 -->
		<input type="hidden" name="commentNo" value="<%=commentNo%>">	<!-- 보드 테이블 번호 받아와 숨기기 -->
		<a>비밀번호 : </a>
		<input type="password" name="comment_pw">        <!-- 비밀번호 받아오기 -->
		<button type="submit">삭제</button>
			</form>
		</div>
	</div>
</div>
</body>
</html>

