<%@ page import="java.sql.*" import="java.util.*" import="download.*"
	language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
String value = request.getParameter("value");
String result = "";
String sel = "";
DBConn2 db = new DBConn2();
ResultSet rs;
db.open();

List<String> re_data = new ArrayList<String>();//
List<String> re_data0 = new ArrayList<String>();//

String[] resource = {"hcl","tts","tica","cell_res","other","epn","geo","tiger"};
for(int k=0;k<resource.length;k++){
	sel = "select distinct gene_name from "+resource[k]+"_basic where gene_name like '"+value+"%'";
	rs = db.execute(sel);
	while(rs.next()){
		re_data0.add(rs.getString("gene_name")+",");

	}
}

for(int j=0;j<re_data0.size();j++){
	if(!re_data.contains(re_data0.get(j))){
		re_data.add(re_data0.get(j));
	}
}

for(int i=0;i<re_data.size();i++){
	result += re_data.get(i);
}

//result = result.substring(1, result.length());
db.close();

PrintWriter writer = response.getWriter();
writer.print(result);
writer.close();
%>
</body>
</html>