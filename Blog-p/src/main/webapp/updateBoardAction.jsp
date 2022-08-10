<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String board_title = request.getParameter("board_title");
	String board_content = request.getParameter("board_content");
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
	

	// UPDATE board set board_title=? , board_content=? where board_no=? and board_pw=?

	// 메뉴목록
	String boardsSql = "UPDATE board set board_title=?, board_content=? where board_no=? and board_pw=PASSWORD(?);";
	PreparedStatement boardStmt = conn.prepareStatement(boardsSql);
	boardStmt.setString(1,board_title);
	boardStmt.setString(2,board_content);
	boardStmt.setInt(3,boardNo);
	boardStmt.setString(4,board_pw);

	int row = boardStmt.executeUpdate();
	if( row == 0){				// 수정 실패		- 수정 폼으로
		response.sendRedirect("./updateBoard.jsp?boardNo="+boardNo);
	} else {					// 수정 성공		- 상세페이지로
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	}
	
	// DB 자원해제
	boardStmt.close();
	conn.close();

%>


