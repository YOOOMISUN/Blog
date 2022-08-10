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
	
	<!-- insertDiary form -->
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
</div>
	
	
</body>
</html>

<%
	// DB 자원해제
	locationStmt.close();
	locationRs.close();
	conn.close();
 %>
 