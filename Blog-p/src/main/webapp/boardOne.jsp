<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	System.out.println("boardNo : " + boardNo);
	
	// 다른 경로로 들어왔을 경우 로그인이 되어있으면 로그인 페이지로 가서 로그아웃 할수 있게
	if(session.getAttribute("loginId") == null){
		response.sendRedirect("./Index.jsp?erroMsg=Please login in");
		return;
	}
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://3.37.51.139:3306/blog";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt= conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	
	/*
	select l.location_name locationName, b.board_title boardTitle, b.board_content boardContnt, b.create_date createDate
	from location l inner join board b
	on l.location_no = b.location_no
	where b.board_no=?
	*/
	
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
<div class="container-fluid" style="background-color:#c6adf5;">
	<!-- header -->
		<%@ include file="Template-header.jsp" %>
	
	
	<!-- left menu -->
	<div class="container" style="background-color:white;" >
	<br>
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
		<h3>Board Detail Page</h3>
		<div style="text-align :right">
			<a href="./boardList.jsp" class="btn btn-info" >글목록</a>
		</div>
		<br>
		<%
			if(boardRs.next()){		
		%>
			<table class="table table-bordered">
				<tr>
					<td>locationName</td>
					<td><%=boardRs.getString("locationName") %></td>
				</tr>
				<tr>
					<td>boardTitle</td>
					<td><%=boardRs.getString("boardTitle") %></td>
				</tr>
				<tr>
					<td>boardContent</td>
					<td><%=boardRs.getString("boardContent") %></td>
				</tr>
				<tr>
					<td>createDate</td>
					<td><%=boardRs.getString("createDate") %></td>
				</tr>
			</table>
			
			
		<% 
				}
			if((Integer)session.getAttribute("loginLevel") > 0){
		
		%>
			<div>
				<a href="./updateBoard.jsp?boardNo=<%=boardNo%>" class="btn btn-dark">수정</a>
				<a href="./deleteBoard.jsp?boardNo=<%=boardNo%>" class="btn btn-danger">삭제</a>
			</div>
		<%
			}
		%>
		<br/>
			
	<!-- 댓글 입력 폼 -->
	<div>
		<form action="./insertCommentAction.jsp" method="post">
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<div>
				<p>댓글</p>
				<textarea class = "form-control" name=comment_content rows="3" cols="50"></textarea>
				<p>비밀번호</p> 
				<input name=comment_pw type="password">
				<button type="submit" class="btn btn-info">댓글입력</button>
			</div>
		</form>
	</div>
	
	
	<!-- 댓글 목록 -->
	<%
	
	// select board_no, comment_content, create_date from comment where board_no=?
	PreparedStatement stmt2 = conn.prepareStatement("select board_no , comment_no , comment_content , create_date from comment where board_no=?");
	stmt2.setInt(1,boardNo);
	
	ResultSet rs2 = stmt2.executeQuery();
	
	%>
		<table border="1">
			<tr>
				<td>번호</td>	<td>댓글</td><td>날짜</td>
			</tr>
	<% 
		
		while(rs2.next()){
	%>		
			<tr>
				<td><%=rs2.getInt("comment_no") %></td>
				<td><%=rs2.getString("comment_content") %></td>
				<td><%=rs2.getString("create_date") %></td>
			</tr>
			
			<tr>
				<td><a href="./deleteCommentForm.jsp?boardNo=<%=rs2.getInt("board_no") %>&commentNo=<%=rs2.getInt("comment_no") %>">삭제</a>
			</tr>
	<%	
		}
	 %>
		</table> 
		</div>
	</div>
	<br>
	<br>
	
</div>
	<%-- 	 <%@ include file="Template-footer.jsp" %>  --%>

<br>
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
	