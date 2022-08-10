<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String locationNo = request.getParameter("locationNo");
	System.out.println(locationNo+" <-- locationNo");	
	
	// 로그인 안되어있으면 insert 들어 올 수 없음
	if(session.getAttribute("loginId") == null){
		response.sendRedirect("./Index.jsp");
		return;
	}
	
	// 로그인성공했고 level이 1미만일때는 boardList로 돌아가야함
	if(session.getAttribute("loginLevel") != null && (Integer)(session.getAttribute("loginLevel")) > 1){
		response.sendRedirect("./boardList.jsp");
		return;
	}	
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;

	
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
	
	
		<!-- start main -->
		<div class="col-sm-10">
			<h1>게시글 입력</h1>
			<form action="./insertBoardAction.jsp" method="post">
				<table class="table table-header">
					<tr>
						<td>LocationNo</td>
						<td>
							<select name = "locationNo">
								<%
									locationRs.first();			// 커서가 맨 위로 이동 위에 while 문 때문에 locationRs 끝나서 맨 위로 이동해야함
									
									do {						// do-while 한번 실행후 시작
								%>
										<option value="<%=locationRs.getInt("locationNo")%>"><%=locationRs.getString("locationName") %></option>
								<% 
									} while(locationRs.next());
								%>
							
							</select>	
						</td>
					</tr>	
					<tr>
						<td>boardTitle</td>
						<td><input type="text" name="boardTitle"></td>
					</tr>
					<tr>
						<td>boardContent</td>
						<td><textarea rows="5" cols="80" name="boardContent"></textarea></td>
					</tr>
					<tr>
						<td>boardPw</td>
						<td><input type="password" name="boardPw"></td>
					</tr>
				</table>
				<button type="submit">글입력</button>
				<button type="reset">초기화</button>
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


