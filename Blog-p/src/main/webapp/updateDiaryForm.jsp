<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   <% 
   
	// 아이디나 레벨이 없을경우 로그인 페이지로 (로그인 안했는데 주소창으로 넘어올 경우를 막음)
	if(session.getAttribute("loginId") == null || (Integer)session.getAttribute("loginLevel") == null){
		response.sendRedirect("./Index.jsp");
		return;
	}
   
   	// 로그인성공했고 level이 1미만일때는 로그인 페이지로 돌아가야함
	if((Integer)session.getAttribute("loginLevel") < 1){
		response.sendRedirect("./diary.jsp");
		return;
	}	
   	
	request.setCharacterEncoding("utf-8");
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);

	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	
	String sql = "SELECT diary_date, diary_todo, create_date FROM diary WHERE diary_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,diaryNo);
	ResultSet rs = stmt.executeQuery();
	
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
<div class="container">
		<nav class="navbar navbar-inverse">
		 <div class="container-fluid">	
		<h1><a class="navbar-link" href="./boardList.jsp" style="color : black; font-weight :bold; font-family: Dotum; ">BLOG</a></h1>
 	 		<ul class="navbar-nav">
 	 		<li class="nav-item">
 	 	 <li><a href="./boardList.jsp"><img src="./img/HOME.svg"> Home</a></li>
  	  	 <li><a href="./Index.jsp"><img src="./img/person-login.svg"> Login</a></li>
  	 	 <li><a href="./logout.jsp"><img src="./img/person-member.svg"> Logout</a></li>
    </ul>
    </div>    
	</nav>
</div>
	
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
			<h3>Diary Update Page</h3>
			<br>
			<form action="./updateDiaryAction.jsp?diaryNo=<%=diaryNo%>" method="post">
				<table class="table table-header">
				<%
					if(rs.next()){
				%>
					<tr>
						<td>Diary Date</td>
						<td><input type="text" name="diaryDate" value="<%=rs.getString("diary_date")%>" readonly></td>
					</tr>
					<tr>
						<td>Diary Todo</td>
						<td><textarea rows="5" cols="80" name="diaryTodo"><%=rs.getString("diary_todo")%></textarea></td>
					</tr>
					<tr>
						<td>Create Date</td>
						<td><input type="text" name="createDate" value="<%=rs.getString("create_date")%>" readonly></td>
					</tr>
				<%
					}
				%>
			</table>
				<div style="text-align :right">
					<button class="btn btn-info">수정하기</button>
				</div>
			</form>
		</div>
	</div>
</div>
	
	
</body>
</html>


<%
	// DB 자원해제
	locationRs.close();
	locationStmt.close();
	rs.close();
	stmt.close();
	conn.close();
	
 %>
 
