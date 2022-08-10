<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	// 아이디 or 비밀번호가 없거나 아이디, 비밀번호가 4자 미만이면 회원가입폼으로 
	if(id==null || pw==null || id.length()<4 || pw.length()<4){	 // 공백 포함
		response.sendRedirect("./insertMemberForm.jsp?errorMsg=error");
		return;			// return 대신 else 블록을 사용해도 됨
	}
	
	// 로그인 되어있으면 로그아웃 폼으로
	if(session.getAttribute("loginId") != null){
		response.sendRedirect("./logout.jsp");
		return;
	}
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴목록
	String sql = "INSERT INTO member(id,pw,level) values (?,PASSWORD(?),0)";
	PreparedStatement stmt= conn.prepareStatement(sql);
	stmt.setString(1,id);
	stmt.setString(2,pw);
	
	stmt.executeUpdate();
	
	response.sendRedirect("./Index.jsp");
		

	// DB 자원해제
	stmt.close();
	conn.close();

%>