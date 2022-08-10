<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   <% 
   
	// 로그인 안했으면 로그인 페이지로
	if(session.getAttribute("loginId") == null){
		response.sendRedirect("./Index.jsp"); 
		return;
		}	
   
    // 로그인성공했고 level이 1미만일때는 로그인 페이지로 돌아가야함
	if((Integer)session.getAttribute("loginLevel") < 1){
		response.sendRedirect("./Index.jsp");
		return;
	}	
	request.setCharacterEncoding("utf-8");
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
    
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String deletesql = "DELETE FROM diary WHERE diary_no=?";
	PreparedStatement deleteStmt = conn.prepareStatement(deletesql);
	deleteStmt.setInt(1,diaryNo);
	ResultSet deleteRs = deleteStmt.executeQuery();
	
	response.sendRedirect("./diary.jsp");
    
		// DB 자원해제
		deleteStmt.close();
		deleteRs.close();
		conn.close();
		
	%>