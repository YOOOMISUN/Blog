<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 로그인이 안되어 있을떄와 입력 불가. Index 페이지로
	if(session.getAttribute("loginId") == null ){
		response.sendRedirect("./Index.jsp");
		return;
	}
	request.setCharacterEncoding("utf-8");
	String diaryDate = request.getParameter("diaryDate");
	String diaryTodo = request.getParameter("diaryTodo");
	System.out.println("diaryDate : " + diaryDate);
	System.out.println("diaryTodo : " + diaryTodo);
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url,dbuser,dbpw);
	
	String sql = "INSERT INTO diary (diary_date, diary_todo,create_date) values(?,?,now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,diaryDate);
	stmt.setString(2,diaryTodo);
	
	int row = stmt.executeUpdate();
	
	if(row == 0){ 		// 입력 실패
		System.out.println("입력 실패");
	} else { 			// 입력 성공
		System.out.println("입력 성공");
	}
	
	response.sendRedirect("./diary.jsp");
	
	// DB 자원해제
	stmt.close();
	conn.close();
	
%>
