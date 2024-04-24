<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "util.*" %>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.util.HashMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>back_changeTissueSource</title>
</head>
<body>
<%
String tissue0 = request.getParameter("tissue");
//String tissue = (tissue0.replace("-", " ")).replace("_"," ");
String result = "";
String result1 = "";
String sel = "";

DBConn2 db = new DBConn2();
ResultSet rs;
sel = "select distinct resource from tissue_cell where tissue_type='"+tissue0+"'";
db.open();
rs = db.execute(sel);
while(rs.next()){
	result = result+"="+rs.getString("resource");
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