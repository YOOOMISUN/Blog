<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<%	
		// 로그인 안되어 있으면 로그아웃 페이지로 안넘어 옴. 로그인 페이지로
		if(session.getAttribute("loginId") == null){
			response.sendRedirect("./Index.jsp");
			return;
		}
	
		// 로그아웃 : 기존의 세션을 지우고 새로운 세션을 줌 
		session.invalidate();	// 기존 세셩영역을 지우고 새로운 세션을 부여
		response.sendRedirect("./Index.jsp");
		
	%>
