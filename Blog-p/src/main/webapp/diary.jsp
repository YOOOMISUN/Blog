<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="diary.*"%>

<%	
	request.setCharacterEncoding("utf-8");
	String diaryDate = request.getParameter("diaryDate");
	String diaryTodo = request.getParameter("diaryTodo");
	
	Calendar c = Calendar.getInstance();	// request.getParameter("y랑 m이") null 이라면 오늘 날짜가 나옴
	if(request.getParameter("y") != null || request.getParameter("m") != null){
		int y = Integer.parseInt(request.getParameter("y"));
		int m = Integer.parseInt(request.getParameter("m"));
		
		if(m == 0) {			// 1월에서 이전버튼
			m = 11;
			y -= 1;				// y = y-1; y--;
		}
		
		if(m == 12){			// 12월에서 다음버튼
			m = 0;
			y +=1;				// y+=1; y++; ++y;
		}
		
		c.set(Calendar.YEAR,y);
		c.set(Calendar.MONTH,m);
	}
	// 1일날의 요일을 알면 그 앞에 나오는 빈칸 갯수를 알수 있음
	// 뒤에 빈칸은 앞에 빈칸 갯수와 마지막날 요일을 알면 더해서 뒤에 빈칸 알 수 있음.
	int lastDay = c.getActualMaximum(Calendar.DATE);	// 마지막 날짜		일의 정보만 갖고있음
	
	// 출력하는 달의 1일의 날짜 객체
	Calendar first = Calendar.getInstance();		// 년 월 일 정보 다 갖고 있음
	first.set(Calendar.YEAR, c.get(Calendar.YEAR));
	first.set(Calendar.MONTH, c.get(Calendar.MONTH));
	first.set(Calendar.DATE,1);
	
	// 1일 전에 빈 td의 개수
	int startBlank = first.get(Calendar.DAY_OF_WEEK)-1;	// 일요일=0, 월요일=1, 토요일=6 <- (1일의 요일값에서 -1을 한다)
	
	// 마지막 날짜 이후의 빈 td의 개수
	int endBlank = 7-(startBlank+lastDay)%7;
	if(endBlank==7){ endBlank = 0; }
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	
	ResultSet locationRs = locationStmt.executeQuery();
	
	/*
	SELECT * FROM diary 
	WHERE YEAR(diary_date) = ? AND MONTH(diary_date)=?
	ORDER BY diary_date;
	*/
	String sql = "SELECT diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo FROM diary WHERE YEAR(diary_date) = ? AND MONTH(diary_date) =? ORDER BY diary_date";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,c.get(Calendar.YEAR));
	stmt.setInt(2,c.get(Calendar.MONTH)+1);			// DB에 입력한 값과 화면 출력한 값이 같을려면 +1 해줘야 함.

	ResultSet rs = stmt.executeQuery();
	// 특수한 환경의 타입 diary 테이블의 ResultSet -> 자바를 모든곳에서 ArrayList<Diary>
	ArrayList<Diary> list = new ArrayList<Diary>();

	while(rs.next()){
	   Diary d = new Diary();
 	  d.diaryNo = rs.getInt("diaryNo");
 	  d.diaryDate = rs.getString("diaryDate");
 	  d.diaryTodo = rs.getString("diaryTodo");
 	  list.add(d);
	}
	
	// System.out.print(list);
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<!-- jQuery library -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
<!-- Popper JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
* {box-sizing: border-box;}
ul {list-style-type: none;}
body {font-family: Verdana, sans-serif;}

.month {
  padding: 70px 25px;
  width: 100%;
  background: #6999c9;
  text-align: center;
}

.month ul {
  margin: 0;
  padding: 0;
}

.month ul li {
  color: white;
  font-size: 20px;
  text-transform: uppercase;
  letter-spacing: 3px;
}

.month .prev {
  float: left;
  color : white;
  font-weight:bold;
  padding-top: 10px;
}

.month .next {
  float: right;
   color : white;
  font-weight:bold;
  padding-top: 10px;
}

.weekdays {
  margin: 0;
  padding: 10px 0;
  background-color: #ddd;
}

.weekdays li {
  display: inline-block;
  width: 13.6%;
  color: #666;
  text-align: center;
}

.days {
  padding: 10px 0;
  background: #eee;
  margin: 0;
}

.days li {
  list-style-type: none;
  display: inline-block;
  width: 13.6%;
  text-align: center;
  margin-bottom: 5px;
  font-size:12px;
  color: #777;
}


/* Add media queries for smaller screens */
@media screen and (max-width:720px) {
  .weekdays li, .days li {width: 13.1%;}
}

@media screen and (max-width: 420px) {
  .weekdays li, .days li {width: 12.5%;}
  .days li .active {padding: 2px;}
}

@media screen and (max-width: 290px) {
  .weekdays li, .days li {width: 12.2%;}
}
</style>

</head>
<body>
<div class="container-fluid" style="background-color:#c6adf5;">
	<!-- header -->
		<%@ include file="Template-header.jsp" %>


<!-- diary -->
	<div class="container month" style="border-radius:10px">      
  <ul >
    <li class="prev"><a href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)-1%>" >&#10094;</a></li>
    <li class="next"><a href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)+1%>" >&#10095;</a></li>
    <li>
      <span style="font-size:23px"><%=c.get(Calendar.YEAR)%>년 <%=c.get(Calendar.MONTH)+1%>월</span><br>
    </li>
  </ul>
</div>
	
		<ul class="weekdays container" style="border-radius:10px">
		  <li>Sunday</li>
		  <li >Monday</li>
		  <li>Tuesday</li>
		  <li>Wednesday</li>
		  <li>Thursday</li>
		  <li>Friday</li>
		  <li>Saturday</li>
		</ul>
	
	<%-- <div> startBlank : <%=startBlank%> </div> 시작 앞 빈칸 갯수 --%>   
	
	<table class="days container" border="1" style="border-radius:10px; border-color:white;">
	<tr>
	<%
		for(int i=1; i<=startBlank+lastDay+endBlank; i++){
		// -는 i-startBlank가 1보다 작으면 출력 안되게 해야함
		if(i-startBlank < 1){
	%>
			<td>&nbsp;</td>			<!-- 공백 넣는 코드 -->
	<%		
		} else if(i-startBlank > lastDay){
	%>
			<td>&nbsp;</td>
	<%			
		} else {	
	%>
			<td style="width:14%; height: 100px; text-indent :1em;">
				<a href="./insertDiaryForm.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)+1%>&d=<%=i-startBlank%>"><%=i-startBlank%></a>
				<!--  c.get(Calendar.MONTH)+1 DB에서는 0부터 시작해서 1월부터 시작하려면 +1 해줘야 한다 -->
				<%
					for (Diary d : list){
					     if(Integer.parseInt(d.diaryDate.substring(8)) == i-startBlank) {
				%>
					<div><a href="./diaryOne.jsp?diaryNo=<%=d.diaryNo%>"><%=d.diaryTodo%></a></div>
    
       		  <%
      			   }
     	  	  }
      	   %>
         
      		 </td>
         
      	   <%
     			    }
		
     		    if (i % 7 == 0) {
            %>
            
    	 	</tr> <tr>
         <%
      	 		  }
			}
         %>
      		</tr>
 		  </table>

<br>
<br>
<br>
</div>
</body>
</html>
<% 
	locationRs.close();
	rs.close();
	locationStmt.close();
	stmt.close();
	conn.close();
	
	%>
	
