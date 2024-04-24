<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "util.*" %>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.util.HashMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>back_changeCellType</title>
</head>
<body>
<%
String source = request.getParameter("source");
String cancer = request.getParameter("c");
String result = "";
String sel = "";
DBConn2 db = new DBConn2();
ResultSet rs;
if(source.equals("cell_res")||source.equals("cra")){
	sel = "select distinct cell,cell_fullname from "+source+"_basic where tissue=\""+cancer+"\" order by cell";
}else{
	sel = "select distinct cell,cell_fullname from geo_basic where sequence=\""+source+"\" and tissue=\""+cancer+"\" order by cell";
}
db.open();
rs = db.execute(sel);
while(rs.next()){
	result = result+"="+rs.getString("cell")+"%"+rs.getString("cell_fullname");
}

db.close();
rs.close();
//System.out.println(result);
PrintWriter writer = response.getWriter();
writer.print(result);
writer.close();
%>
</body>
</html>