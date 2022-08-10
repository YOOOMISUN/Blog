<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 아이디나 레벨이 없을경우 로그인 페이지로 (로그인 안했는데 주소창으로 넘어올 경우를 막음)
	if(session.getAttribute("loginId") == null || (Integer)session.getAttribute("loginLevel") == null){
		response.sendRedirect("./Index.jsp");
		return;
	}

	request.setCharacterEncoding("UTF-8");
	int locationNo = Integer.parseInt(request.getParameter("locationNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	
	// 아이디나 레벨이 없을경우 로그인 페이지로
	if(session.getAttribute("loginId") == null || (Integer)session.getAttribute("loginLevel") == null){
		response.sendRedirect("./Index.jsp");
		return;
	}
	
	// 로그인이 되어있으면 로그인 페이지로 가서 로그아웃 할수 있게
	if(session.getAttribute("loginId") == null){
		response.sendRedirect("./Index.jsp");
		return;			
	}
	
	
	// 디버깅
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String sql = "INSERT INTO board( location_no, board_title, board_content, board_pw, create_date) values (?,?,?,PASSWORD(?),now())";
	// 패스워드가 암호화 되어있어서 PASSWORD() 함수 사용
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, locationNo);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, boardPw);
	
	int row = stmt.executeUpdate();
	// 쿼리 실행 경로가 디버깅
	if(row == 1){
		// 
		
	} else {
		//
		
	}
	
	// 입력 성공해도 실패해도 boardList로 넘어가서 안써줌

	// 재요청
	response.sendRedirect("./boardList.jsp");


	// DB 자원해제
	stmt.close();
	conn.close();

	
%>
