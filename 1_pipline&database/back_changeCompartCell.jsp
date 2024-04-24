<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "util.*" %>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.util.HashMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LncCE</title>
</head>
<body>
<%
String compart = request.getParameter("compart");
String cell_type = request.getParameter("cell");

String result = "";
String sel = "";
DBConn2 db = new DBConn2();
ResultSet rs;

if(cell_type=="" || cell_type==null){
	sel = "select distinct cell_type from cell_tissue where compartment=\""+compart+"\" order by cell_type";
}else{
	if(cell_type.equals("all")){
		sel = "select distinct search,fix from cell_tissue where compartment=\""+compart+"\" order by fix";
	}else{
		sel = "select * from cell_tissue where compartment=\""+compart+"\" and cell_type=\""+cell_type+"\" order by fix";
	}
	
}

db.open();
rs = db.execute(sel);
while(rs.next()){
	if(cell_type=="" || cell_type==null){
		result = result+"="+rs.getString("cell_type");
	}else{
		result = result+";"+rs.getString("search")+"%"+rs.getString("fix");
	}
	
}

db.close();
//System.out.println(result);
PrintWriter writer = response.getWriter();
writer.print(result);
writer.close();
%>
</body>
</html>