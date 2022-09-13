<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%	
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt= conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	System.out.println("locationRs : " + locationRs);
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
	<br>
	<!-- start main -->
	<h3 style="font-weight:bold; text-align :center;">방명록</h3>
		<div class="container" style="background-color:white; text-align :center; display: inline-block; margin-top: 100px;">
		<%
				if(session.getAttribute("loginId") != null){	// 로그인 되어있을때만 보여줌
			%>	
			<form action="./insertGuestbookAction.jsp" method="post" >
				<div>	
					<textarea rows="3" cols="50" name="guestbookContent"></textarea>
					<button type="submit">글 입력</button>
				</div>
			</form>
			<br>
			<!-- guestbook_no : auto increment
				guestbook_content : guestbookContent
				id : seesion.getAttribute("loginId")
				create_date : now() -->
		<%
				}
		%>
			<!-- to do -->
		<%
			/*
			SELECT guestbook_no guestbookNo, guestbook_content guestbookContent, id, create_date createDate 
			FROM guestbook 
			ORDER BY create_date LIMIT ?,?
			*/
			
			/*
			pageCount : 한번에 출력될 페이징 버튼 수
			startPage : 페이징 버튼 시작 값
			endPage : 페이징 버튼 종료 값
			*/
		
		 	PreparedStatement stmt2 = null;
			stmt2 = conn.prepareStatement("select count(*) from guestbook");
			ResultSet rs2 = stmt2.executeQuery();
			
			
			int currentPage = 1;			// 현재 페이지
			int totalCount = 0;				// 총 데이터의 갯수
			int limit = 5;					// 한 페이지당 나타낼 데이터의 갯수
			final int ROW_PER_PAGE = 5;

			if(request.getParameter("currentPage") != null){
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			
			int beginRow = (currentPage - 1) * ROW_PER_PAGE;
			
			String guestbookSql = "SELECT guestbook_no guestbookNo, guestbook_content guestbookContent, id, create_date createDate FROM guestbook ORDER BY guestbook_no DESC LIMIT ?,?";
			PreparedStatement guestbookStmt = conn.prepareStatement(guestbookSql);
			guestbookStmt.setInt(1,beginRow);
			guestbookStmt.setInt(2,ROW_PER_PAGE);
			ResultSet guestbookRs = guestbookStmt.executeQuery();
			
			if(rs2.next()) { totalCount = rs2.getInt("count(*)"); }  			//  db에서 전체 게시물 카운트해서 값 가져오기.
			int pageCount = (int) Math.ceil((double)totalCount / limit);		// pageCount : 화면에 나타날 페이지 갯수 => 올림 

			int startPage = ((currentPage - 1) / pageCount) * pageCount + 1;
			int endPage = (((currentPage - 1) / pageCount) + 1) * pageCount;
			int lastPage = totalCount / ROW_PER_PAGE;
			    if (totalCount % ROW_PER_PAGE != 0) { lastPage += 1; }
			    if (lastPage < endPage) { endPage = lastPage; }
		%>
		
		<%
			while(guestbookRs.next()){
		%>
		
		<table style="height:80px; weight:300px;" >	
				<tr>
					<td>글</td>
					<td colspan="4"><%=guestbookRs.getString("guestbookContent")%></td>
				</tr>
				<tr>	
					<td>아이디</td>
					<td><%=guestbookRs.getString("id")%></td>
					<td>글쓴날짜</td>
					<td><%=guestbookRs.getString("createDate")%></td>
				
		<%
		System.out.println("guestbookNo : " + guestbookRs.getString("guestbookNo"));
		
			String loginId = (String)session.getAttribute("loginId");
			if(loginId != null && loginId.equals(guestbookRs.getString("id"))){
			// 로그인이 되어있어야하고 guestbook id랑 loginId의 값이 같아야지만 삭제 가능
		%>
			  <td> 
			  	<a class="btn btn-primary"
                       href="deleteGuestbook.jsp?guestbookNo=<%=guestbookRs.getInt("guestbookNo")%>">삭제</a></td>
				<!-- 위 조건을 만족해야지 삭제 링크 버튼이 보임 -->
		<%		
				}
			}
		%>
		</tr>
		</table>
		<br>
		
	 <!--  페이징 -->
		<div class="container" >
				<ul class="pagination pagination-sm">
               <!--  이전 -->
                <%
                	if(currentPage > 1) { 				
                %>
                <li class="page-item active">
                    <a class="page-link"
                       href="./guestbook.jsp?currentPage=<%=currentPage-1%>">이전 </a>
                </li>
                <%
                    }
                %>
                
              <!-- 페이지넘버 -->
                <%
                    for (int i = startPage; i <= endPage; i++) {
                        if (currentPage == i) {
                %>
                <li class="page-item active">
                    <a class="page-link"><%=i%>
                    </a>
                </li>
                <%
               		 } else {
                %>
                <li class="page-item">
                    <a class="page-link"
                       href="./guestbook.jsp?currentPage=<%=i%>"><%=i%>
                    </a>
                </li>
                <%
                        }
                    }
                %>
              <!-- 다음 -->
                <%
              	  if(currentPage < lastPage) {	
                %>
                <li class="page-item">
                    <a class="page-link"
                       href="./guestbook.jsp?currentPage=<%=currentPage+1%>">다음</a>
                </li>
                <%
                    }
                %>
            </ul>
			</div> 
		</div>
		<br>
		<br>
	</div>
	<br>
	<br>
</div>


</body>
</html>

<%	
	// DB 자원해제 (해제는 밑에서부터)
	locationStmt.close();
	locationRs.close();
	guestbookStmt.close();
	guestbookRs.close();
	conn.close();
%>

