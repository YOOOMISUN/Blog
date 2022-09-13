<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

	<%
		request.setCharacterEncoding("utf-8");
		String locationNo = request.getParameter("locationNo");
	    System.out.println(locationNo+" <-- locationNo");   
		
	    String word = request.getParameter("word");
	    
	    int currentPage = 1;
	    if(request.getParameter("currentPage") != null) {
	    	currentPage = Integer.parseInt(request.getParameter("currentPage"));
	    }
	    
	    final int ROW_PER_PAGE = 10;
	    int beginRow = (currentPage -1 ) * ROW_PER_PAGE;
	    
	    
		Class.forName("org.mariadb.jdbc.Driver");
		String url = "jdbc:mariadb://3.37.51.139:3306/blog";
		String dbuser = "root";
		String dbpw = "java1234";
		Connection conn = DriverManager.getConnection(url,dbuser,dbpw);
		
		// 메뉴 목록
		
		String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		
		ResultSet locationRs = locationStmt.executeQuery();
		
		// 마지막 페이지 계산
		int totalRow = 0;
			
		PreparedStatement countStmt = null;
			
		if(word == null) {
			countStmt = conn.prepareStatement("select count(*) from board");
		} else {
			countStmt = conn.prepareStatement("select count(*) from board where board_title like ?");
			countStmt.setString(1,"%"+word+"%");
		}
		ResultSet countRs = countStmt.executeQuery();
		
		if(countRs.next()) {
			totalRow = countRs.getInt("count(*)"); 
		}
		
		int lastPage = totalRow / ROW_PER_PAGE;
		if(totalRow % ROW_PER_PAGE != 0) {
			lastPage += 1;
		}
		System.out.println(totalRow + " <-- totalRow");
		System.out.println(lastPage + " <-- lastPage");
		System.out.println(currentPage + " <-- currentPage");
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
	
	<div class="container" style="background-color:white; border-bottom-right-radius: 28px; border-bottom-left-radius: 28px;" >
	<br>	

	<!-- left menu -->
	<br>
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
	<%
		// 게시글 목록 - 지역 누르면 지역에 따라 목록 나타남.
		String boardSql = "";
		PreparedStatement boardStmt = null;
		if(locationNo == null ){ 
			if(word == null) {
		/*  SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle 
			FROM location l inner join board b
			on l.location_no = b.location_no
			ORDER BY board_no DESC 
			LIMIT ?,?	*/
			
			boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l inner join board b on l.location_no = b.location_no ORDER BY board_no DESC LIMIT ?,?";
		    boardStmt = conn.prepareStatement(boardSql);
            boardStmt.setInt(1, beginRow);
            boardStmt.setInt(2, ROW_PER_PAGE);
			}
			
		else {  
		/* 	SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle 
			FROM location l inner join board b
			on l.location_no = b.location_no
			WHERE l.location_no = ? 
			ORDER BY board_no DESC 
			LIMIT ?,?   */
			
			boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l inner join board b on l.location_no = b.location_no WHERE l.location_no = ? ORDER BY board_no DESC LIMIT ?,?"; 

	         boardStmt = conn.prepareStatement(boardSql);
             boardStmt.setInt(1, Integer.parseInt(locationNo));
             boardStmt.setInt(2, beginRow);
             boardStmt.setInt(3, ROW_PER_PAGE);
				}
		} else {
			if(word == null){		
				boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.location_no = ? ORDER BY board_no DESC LIMIT ?, ?";
				boardStmt = conn.prepareStatement(boardSql);
				boardStmt.setInt(1, Integer.parseInt(locationNo));
				boardStmt.setInt(2, beginRow);
				boardStmt.setInt(3, ROW_PER_PAGE);
			} else {
				boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.location_no = ? and b.board_title like ? ORDER BY board_no DESC LIMIT ?, ?";
				boardStmt = conn.prepareStatement(boardSql);
				boardStmt.setInt(1, Integer.parseInt(locationNo));
				boardStmt.setString(2, "%"+word+"%");
				boardStmt.setInt(3, beginRow);
				boardStmt.setInt(4, ROW_PER_PAGE);
			}
		}
		ResultSet boardRs = boardStmt.executeQuery();
		
	%>
	</div>
	
	
	<!-- main -->
	<div class="col-sm-10">
		<%
			if(session.getAttribute("loginLevel") != null && (Integer)(session.getAttribute("loginLevel")) > 0){
				// Object -> Integer 언오토박싱    =>   Integer -> Int 언오토박싱
		%>
			<div style="text-align :right">
				<a href="./insertBoard.jsp" class="btn btn-info" >글쓰기</a>		<!-- 로그인 되어있을때만 나와야함. -->
			</div>
		<%
			}
		
		%>
		
		<br/>
		<table class="table table-striped tabel-hover" style="text-align :center;">
		<thead>
			<tr>
				<th>locationName</th>
				<th>boardNo</th>
				<th>boardTitle</th>
			</tr>
		</thead>
		<tbody>
			<%
				while(boardRs.next()){
			%>
			<tr>
				<td><%=boardRs.getString("locationName") %></td>
				<td><%=boardRs.getInt("boardNo") %></td>
				<td>
					<a href="./boardOne.jsp?boardNo=<%=boardRs.getInt("boardNo")%>"><%=boardRs.getString("boardTitle") %></a></td>
			</tr>		
			<%	
				}
			
			%>
		
		</tbody>
		</table>
		<div>
		
		<!--  페이징 -->
		<div class="container">
			<div class="row">
			<div class="col-sm-6">
				<ul class="pagination pagination-sm">
					<!-- 이전 -->
					<%					
					if (locationNo == null) {
						if (word == null) {		
							if(currentPage > 1) {
					%>			
							<li class="page-item"><a class="page-link"
								href="./boardList.jsp?currentPage=<%=currentPage - 1%>">이전</a></li>
					<%
							}
						} else {
							if(currentPage > 1) {
					%>		
							<li class="page-item"><a class="page-link"
									href="./boardList.jsp?currentPage=<%=currentPage - 1%>&word=<%=word%>">이전</a></li>
					<%
							}
						}
					} else {
						if (word == null) {
							if(currentPage > 1) {
					%>					
							<li class="page-item"><a class="page-link"
									href="./boardList.jsp?currentPage=<%=currentPage - 1%>&locationNo=<%=locationNo%>">이전</a></li>
					<%
							}
						} else {
							if(currentPage > 1) {
					%>
							<li class="page-item"><a class="page-link"
										href="./boardList.jsp?currentPage=<%=currentPage - 1%>&locationNo=<%=locationNo%>&word=<%=word%>">이전</a></li>
					<%
							}
						}
					}
					%>
						
					<!-- 페이지 번호 -->
					<%	
					 	int pageCount = 10;
						int startPage = ((currentPage - 1) / pageCount) * pageCount + 1;
				    	int endPage = (((currentPage - 1) / pageCount) + 1) * pageCount;
				    	if (lastPage < endPage) { endPage = lastPage; }
				    	
				    	for (int i = startPage; i <= endPage; i++) {
				    		if (i <= lastPage) {
				    			if (locationNo == null) {
				    				if (word == null) {		
				    %>			
				    					<li class="page-item" ><a  class="page-link"
				    							href="./boardList.jsp?currentPage=<%=i%>"><%=i%></a></li>
				    <%
				    					
				    				} else {
					    %>		
				    					<li class="page-item"><a class="page-link"
				    							href="./boardList.jsp?currentPage=<%=i%>&word=<%=word%>"><%=i%></a></li>
				    <%
				    					
				    				}
				    			} else {
				    				if (word == null) {
					    %>					
				    					<li class="page-item"><a class="page-link"
				    							href="./boardList.jsp?currentPage=<%=i%>&locationNo=<%=locationNo%>"><%=i%></a></li>
				    <%
				    					
				    				} else {
					    %>
				    					<li class="page-item"><a class="page-link"
				    								href="./boardList.jsp?currentPage=<%=i%>&locationNo=<%=locationNo%>&word=<%=word%>"><%=i%></a></li>
				    <%
				    					
				    				}
				    			}
				    		}
				    	}
					%>
						
					<!-- 다음 -->
					<%					
					if (locationNo == null) {
						if (word == null) {		
							if(currentPage < lastPage) {
					%>			
							<li class="page-item"><a class="page-link"
									href="./boardList.jsp?currentPage=<%=currentPage + 1%>">다음</a></li>
					<%
							}
						} else {
							if(currentPage < lastPage) {
					%>		
							<li class="page-item"><a class="page-link"
									href="./boardList.jsp?currentPage=<%=currentPage + 1%>&word=<%=word%>">다음</a></li>
					<%
							}
						}
					} else {
						if (word == null) {
							if(currentPage < lastPage) {
					%>					
							<li class="page-item"><a class="page-link"
									href="./boardList.jsp?currentPage=<%=currentPage + 1%>&locationNo=<%=locationNo%>">다음</a></li>
					<%
							}
						} else {
							if(currentPage < lastPage) {
					%>
							<li class="page-item"><a class="page-link"
										href="./boardList.jsp?currentPage=<%=currentPage + 1%>&locationNo=<%=locationNo%>&word=<%=word%>">다음</a></li>
					<%
							}
						}
					}
					%>
						</ul>
						</div>
					<div class="col-sm-4">
				 <form class="form-inline" action="./boardList.jsp"  >
			 	<%
			 		if(locationNo != null){
		 		%>
		 			<input type="hidden"  name="locationNo" value="<%=locationNo%>">
		 		<%
		 			}
		 		%>
		     	<input type="text" class="form-control" name="word" >
 				<button type="submit" class="btn btn-primary">검색</button>
					</form>
					</div>			
					</div>
				</div>
			</div>
		</div>	
	</div>
	<br>
	<br>
	
</div>
<br>
</div>
</body>
</html>

<%
	// DB 자원해제
	locationStmt.close();
	locationRs.close();
	countStmt.close();
	countRs.close();
	boardStmt.close();
	boardRs.close();
	conn.close();
%>

		