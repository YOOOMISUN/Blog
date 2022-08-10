<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String board_pw = request.getParameter("board_pw");
	
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
	String boardSql = "delete from board where board_no=? and board_pw=PASSWORD(?)";
	PreparedStatement boardStmt= conn.prepareStatement(boardSql);
	boardStmt.setInt(1,boardNo);
	boardStmt.setString(2,board_pw);

	int row = boardStmt.executeUpdate();
	if(row == 0){
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	} else {
		response.sendRedirect("./boardList.jsp");
	}

%>

<%
	// DB 자원해제
	boardStmt.close();
	conn.close();

%>
