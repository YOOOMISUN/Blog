<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<% 

	
	if(session.getAttribute("loginId") != null){
		response.sendRedirect("./Index.jsp");
		return;
	}

	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	if(id==null || pw==null ){	
	response.sendRedirect("./Index.jsp?errorMsg=Invalid Access");
	return;			// return 대신 else 블록을 사용해도 됨
	}
	
	request.setCharacterEncoding("utf-8");
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String sql = "SELECT id,level FROM member where id=? and pw=PASSWORD(?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,id);
	stmt.setString(2,pw);
	
	ResultSet rs = stmt.executeQuery();
	
	if(rs.next()){		// 로그인 성공
		// setAttribute(String,Object)
		session.setAttribute("loginId", rs.getString("id"));	
		// 실제로 object타입이 들어가야하는데 rs.getString("id") 들어가 있음
		// Object <- String 추상화,상속,다형성,캡슐화
		session.setAttribute("loginLevel", rs.getInt("level"));	
		// 기본타입은 참조타입에 들어갈 수 없음
		// Object <- Integer <- Int 
		//     (다형성)    (오토박싱) 
		response.sendRedirect("./Index.jsp");
	} else {			// 로그인 실패
		response.sendRedirect("./Index.jsp?errorMsg=Invalid Id or Pw");
	}

	// DB 자원해제 
	rs.close();
	stmt.close();
	conn.close();


%>
