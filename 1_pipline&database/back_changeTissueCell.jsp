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
String tissue = request.getParameter("c");
String result = "";
String sel = "";
//System.out.println(cancer);
//System.out.println(source);
DBConn2 db = new DBConn2();
ResultSet rs;
sel = "select distinct cell_type from tissue_cell where tissue_type=\""+tissue+"\" and resource=\""+source+"\" order by cell_type";
db.open();
rs = db.execute(sel);
while(rs.next()){
	result = result+"="+rs.getString("cell_type");
}
//System.out.println(sel);
db.close();
rs.close();
//System.out.println("result");
PrintWriter writer = response.getWriter();
writer.print(result);
writer.close();
%>
</body>
</html>