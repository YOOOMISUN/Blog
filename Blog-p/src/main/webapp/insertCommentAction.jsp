<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>


<%
	// 아이디나 레벨이 없을경우 로그인 페이지로 (로그인 안했는데 주소창으로 넘어올 경우를 막음)
	if(session.getAttribute("loginId") == null || (Integer)session.getAttribute("loginLevel") == null){
		response.sendRedirect("./Index.jsp");
		return;
		}

	request.setCharacterEncoding("utf-8");
	// 요청분석 디버깅 - 컨트롤러
	// hidden으로 받아진 board의 no 
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));	
	String comment_content = request.getParameter("comment_content");
	String comment_pw = request.getParameter("comment_pw");
	 
	System.out.println("boardNo : " + boardNo);
	System.out.println("comment_content : " + comment_content);
	System.out.println("comment_pw : " + comment_pw);
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn=DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog","root","1234");
	System.out.println("conn : " + conn);
	
	// db 처리 - 서비스 (모델)
	PreparedStatement stmt = conn.prepareStatement("insert into comment (board_no,comment_content,create_date,comment_pw) values (?,?,NOW(),PASSWORD(?))");		
	stmt.setInt(1, boardNo);		
	stmt.setString(2, comment_content);		
	stmt.setString(3, comment_pw);	
	
	stmt.executeUpdate();
	// 뷰
	response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);	
	
	// DB 자원해제 (해제는 밑에서부터)
	stmt.close();
	conn.close();

%>




