<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 로그인이 안되어 있으면 로그인 폼으로..
	if(session.getAttribute("loginId") == null){
		response.sendRedirect("./Index.jsp");
		return;
	}	
	
	request.setCharacterEncoding("utf-8");
	String guestbookContent = request.getParameter("guestbookContent");

	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴목록
	String sql = "INSERT INTO guestbook (guestbook_content, id, create_date) values(?,?,now()) ";
	PreparedStatement stmt= conn.prepareStatement(sql);
	stmt.setString(1, guestbookContent);
	stmt.setString(2, (String)session.getAttribute("loginId"));
	stmt.executeUpdate();
	response.sendRedirect("./guestbook.jsp");
	
	
	// DB 자원해제 (해제는 밑에서부터)
	stmt.close();
	conn.close();

	
	%>