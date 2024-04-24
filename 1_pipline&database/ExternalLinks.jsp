<%@page import="org.eclipse.jdt.internal.compiler.ast.WhileStatement"%>
<%@ page import="action.Array2" import="util.*" import="action.ChartsData" language="java"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections"%>
<%@ page import="org.rosuda.REngine.REXP"%>
<%@ page import="org.rosuda.REngine.REXPMismatchException"%>
<%@ page import="org.rosuda.REngine.Rserve.RConnection"%>
<%@ page import="org.rosuda.REngine.Rserve.RserveException"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileWriter"%>
<%@ page import="java.util.Random"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.Format"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.util.Arrays"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LncCE</title>
<!-- CSS
================================================== -->
<link rel="stylesheet" href="css/zerogrid.css">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/responsive.css">
<link rel="stylesheet" href="css/responsiveslides.css" />		
<link href='./images/favicon.ico' rel='icon' type='image/x-icon'/>	
<script src="js/jquery.min.js"></script>
<script src="js/responsiveslides.js"></script>
<!-- my css js -->
<!-- CSS -->
<link href="Bootstrap/bootstrap.min.css" rel="stylesheet">
<!-- jQuery and JavaScript Bundle with Popper -->
<script src="Bootstrap/jquery.slim.js"></script>
<script src="Bootstrap/bootstrap.bundle.min.js"></script>
<script src="js/iconify.min.js"></script>
<script src="js/my.js"></script>
</head>
<style>
.content-fontsize{
font-size:21px;
}
</style> 
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;
String chr = request.getParameter("chr");
String ID = request.getParameter("Name");
String location="";
String type="";
String rs_a  = request.getParameter("classification");
String rs_t = "";
String cancer = "";
String resource = request.getParameter("resource");
String NODE=""; //gene的名字
String cell="";
String rs_c="";
String a_f="";
String tissue_pd="";
List<String> Cancer = new ArrayList<String>();
List<String> Cancer1 = new ArrayList<String>();
cell=request.getParameter("celltype");
//String tissue_pd = request.getParameter("tissue");//tissue_pd用于网络图进行判断是否是组织特异,同时用于判断癌症放到前面
tissue_pd = request.getParameter("tissue");
a_f="adult";
%>
<body>    
<div id="main-page">
<!-- 6.External links start -->
<% DBConn db1 = new DBConn();%>
<%
//各个资源中组织、分类、分类全称
String lnc2cancer="";
String lncrnadisease="";
String exo="";
sel="select lnc2cancer,lncrnadisease,exo from integration_basic where ID = '"+ID+"'";
db1.open();
rs=db1.execute(sel);
while(rs.next()){
	lnc2cancer=rs.getString("lnc2cancer");
	lncrnadisease=rs.getString("lncrnadisease");
	exo=rs.getString("exo");
}
db1.close();
if((lnc2cancer.equals("NA")&lncrnadisease.equals("NA")&exo.equals("NA"))||(lnc2cancer==null&lncrnadisease==null&exo==null)||(lnc2cancer==""&lncrnadisease==""&exo=="")){
%>
<div class="content card card-body" style="height: 173px;">
<h3>No result!</h3>
</div>
<%
}else{
%>
				
<div class="content card card-body" style="height: 173px;">
<table style="margin-top: 0px; margin-left: 10px; white-space: nowrap;width:100%">
					<tr style="text-align:left">
						<th>Database</th>
						<th>Disease</th>
					</tr>
					<tr style="text-align:left">
						<td>Lnc2Cancer</td>
						<td>
							<%if(lnc2cancer.equals("NA")){
            		out.println("-");
            	}else{
            		String[] lnc1=lnc2cancer.split(",");
            		for(int i=0;i<lnc1.length-1;i++){
            	%> <a onmouseout="normalSize(this)"
							onmouseover="bigSize(this)"
							href="http://bio-bigdata.hrbmu.edu.cn/lnc2cancer/analysis.jsp?Num=Num2&Gene=<%=NODE %>&Cancer=<%= lnc1[i]%>"><%= lnc1[i]%>,</a>
							<%
            		}
            	%> <a onmouseout="normalSize(this)"
							onmouseover="bigSize(this)"
							href="http://bio-bigdata.hrbmu.edu.cn/lnc2cancer/analysis.jsp?Num=Num2&Gene=<%=NODE %>&Cancer=<%= lnc1[lnc1.length-1]%>"><%= lnc1[lnc1.length-1]%></a>
							<%
            	}
            	%>
						</td>
					</tr>
					<tr style="text-align:left">
						<td>LncRNADisease</td>
						<td>
				<%if(lncrnadisease.equals("NA")){
            		out.println("-");
            	}else{
            	%> <a onmouseout="normalSize(this)"
							onmouseover="bigSize(this)"
							href="http://www.cuilab.cn/lncrnadisease#fragment-3"><%=lncrnadisease %></a>
							<%
            	}%>
						</td>
					</tr>
					<tr style="text-align:left">
						<td>exoRBase</td>
						<td>
				<%if(exo.equals("NA")){
            		out.println("-");
            	}else{
            	%> <a onmouseout="normalSize(this)"
							onmouseover="bigSize(this)"
							href="http://www.exorbase.org/exoRBaseV2/detail/detailInfo?id=<%= NODE%>&kind=longRNA"><%=exo %></a>
							<%
            	}%>
						</td>
					</tr>
				</table>
				</div>
				
<%} %>
<!-- 6.External links end -->
</div>
</body>
</html>