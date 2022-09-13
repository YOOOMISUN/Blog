<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
	int year = Integer.parseInt(request.getParameter("y"));		// 년 
	int month = Integer.parseInt(request.getParameter("m"));	// 월
	int day = Integer.parseInt(request.getParameter("d"));		// 일

	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);

	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	
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
	<div class="container-fluid" style="background-color:#c6adf5;">
	<!-- header -->
		<%@ include file="Template-header.jsp" %>
	
	<div class="container" style="background-color:white; border-bottom-right-radius:28px; border-bottom-left-radius:28px;" >
	<br>	

	
	<!-- insertDiary form -->
	<div class="container">
		<div class="col-sm-10">
			<h1>다이어리 입력</h1>
			<form action="./insertDiaryAction.jsp?year=<%=year%>&month=<%=month%>&day=<%=day%>" method="post">
				<table class="table table-header">
					<tr>
						<td>DiaryDate</td>
						<td><a><%=year%>년 <%=month%>월 <%=day%>일</a></td>
						<td><input type = "hidden" name="diaryDate" value="<%=year%>-<%=month%>-<%=day%>"></td>
					</tr>
					<tr>
						<td>DiaryTodo</td>
						<td><textarea class = "form-control" name=diaryTodo rows="3" cols="50"></textarea></td>
					</tr>
				</table>
				<div style="text-align :right">
					<button type="submit" class="btn btn-info">입력</button>
					<button type="reset" class="btn btn-info">초기화</button>
				</div>
			</form>
		</div> <!-- end main -->
	</div>
	<br>
		<br>
	</div>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
</div>

	
	
</body>
</html>

<%
	// DB 자원해제
	locationStmt.close();
	locationRs.close();
	conn.close();
 %>
 