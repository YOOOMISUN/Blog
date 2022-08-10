<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	
	request.setCharacterEncoding("utf-8");
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
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt= conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	
	String boardsSql = "select l.location_name locationName, b.board_title boardTitle, b.board_content boardContent, b.create_date createDate from location l inner join board b on l.location_no = b.location_no where b.board_no=?";
	PreparedStatement boardStmt = conn.prepareStatement(boardsSql);
	boardStmt.setInt(1,boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	
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
	
		<!-- start main -->
		<div class="col-sm-10">
			<h2>게시판 수정</h2>
			<form action="./updateBoardAction.jsp?boardNo=<%=boardNo%>" method="post" >
		<div>
			<a href="./boardList.jsp" >글목록</a>
		</div>
		<%
			if(boardRs.next()){		
		%>
			<table class="table table-bordered">
				<tr>
					<td>locationName</td>
					<td><input type="text" name="name" value="<%=boardRs.getString("locationName") %>" readonly></td>
				</tr>
				<tr>
					<td>boardTitle</td>
					<td><input type="text" name="board_title" value="<%=boardRs.getString("boardTitle") %>"></td>
				</tr>
				<tr>
					<td>boardContent</td>
					<td><textarea rows="5" cols="80" name="board_content"><%=boardRs.getString("boardContent") %>"></textarea></td>
				</tr>
				<tr>
					<td>createDate</td>
					<td><%=boardRs.getString("createDate") %></td>
				</tr>
				<tr>
					<td>PW</td>
					<td><input type="password" name="board_pw" ></td>		<!-- name은 뒤에 Action으로 값을 넘겨줄때 이름과 같아야함. -->
				</tr>	
			</table>
		<% 
			}
		%>
				<div>
					<button type="submit" class="btn btn-dark">수정하기</button>
				</div>
			</form>
		</div>
	</div>
</div>
</body>
</html>

<%
	// DB 자원해제
	locationStmt.close();
	locationRs.close();
	boardStmt.close();
	boardRs.close();
	conn.close();

%>


