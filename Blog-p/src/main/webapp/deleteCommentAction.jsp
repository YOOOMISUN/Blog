<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 로그인 안했으면 로그인 페이지로
	if(session.getAttribute("loginId") == null){
		response.sendRedirect("./Index.jsp");
		return;
		}	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int comment_no = Integer.parseInt(request.getParameter("commentNo"));
	String comment_pw = request.getParameter("comment_pw");

	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String sql = "delete from comment where comment_no=? and comment_pw=PASSWORD(?)";  
	PreparedStatement stmt= conn.prepareStatement(sql);
	stmt.setInt(1,comment_no);
	stmt.setString(2,comment_pw);
	stmt.executeQuery();
	
	response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	
	// DB 자원해제 (해제는 밑에서부터)
	stmt.close();
	conn.close();

%>


