<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	//로그인이 안되어 있으면 로그인 폼으로..
	if(session.getAttribute("loginId") == null){
		response.sendRedirect("./Index.jsp");
		return;
	}	
	
	// 다른데서 바로 deleteGuestbook으로 바로 넘어 오면 guestbookNo가 없으니까 guestbookNo가 null 이면 다시 방명록 페이지로
	if(request.getParameter("guestbookNo") == null){
		response.sendRedirect("./guestbook.jsp");
		return;
	}		

	int guestbookNo = Integer.parseInt(request.getParameter("guestbookNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);

	String sql = "delete from guestbook where guestbook_no=? and id=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,guestbookNo);
	stmt.setString(2,(String)session.getAttribute("loginId"));		// Object, 다형성, 형변환, Map
	
	int row = stmt.executeUpdate();
	
	response.sendRedirect("./guestbook.jsp");
	
	
	// DB 자원해제 (해제는 밑에서부터)
	stmt.close();
	conn.close();

%>