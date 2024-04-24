<!DOCTYPE html>
<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%>
<%@ page import="java.io.*" language="java"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.Random"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.*"%>
<html>
<head>
<title>LncCE</title>
<meta charset="utf-8" />
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
<script src="jquery-ui-1.13.2/jquery-3.5.1.js" ></script>
<!-- jQuery and JavaScript Bundle with Popper -->
<script src="Bootstrap/jquery.slim.js"></script>
<script src="Bootstrap/bootstrap.bundle.min.js"></script>
<script src="js/iconify.min.js"></script>
<script src="js/jquery-2.0.0.min.js" ></script>
</head>
<style>
.right_s{
margin-top: 37px;
margin-left: 93px;
}
.layui-tab-title li{
	font-size: 18px;
    font-weight: bolder;
    margin: auto 5px;
    background-color: #e0e0e0;
    /* box-shadow: 4px 4px 1px #c1c1c1; */
    width: 98px;
}
.layui-tab-title .layui-this{
	color:white;
	background:#335882;
}
.intro{
max-width: 1200px;
margin-top: -16px;
height: 137px;
border-radius: 10px;
padding-top: 28px;
padding-left: 52px;
padding-right: 52px;
}
.browseh{
max-width: 1200px;
margin-top: 32px;
height: 39px;
border-radius: 10px;
padding-top: 19px;
padding-left: 52px;
padding-right: 52px;
text-align: center;
}
.nav-pills .nav-link.active, .nav-pills .show>.nav-link{
background-color: #7028e4;
}
.contnt_lyj{
margin-top:57px;
width:100%;
}
</style>

<body>
<!--------------Header--------------->
<header> 
	<div id="logo"><a href="index.jsp"><img width="408px" src="./images/home/logo-white.png"/></a></div>	
</header>

<!--------------Navigation--------------->
<nav>
	<ul class="">
		<li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
		<li class="nav-item dropdown">
		<a class="nav-link dropdown-toggle" href="#" id="dropdownMenuLink" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Search</a>
		<div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
    		<a class="dropdown-item" target="_blank" href="search.jsp?method=normal">Normal</a>
    		<a class="dropdown-item" target="_blank" href="search.jsp?method=cancer">Cancer</a>
    		<a class="dropdown-item" target="_blank" href="search.jsp?method=lncRNA">LncRNA</a>
    		<a class="dropdown-item" target="_blank" href="search.jsp?method=cell">Cell</a>
  		</div>
		</li>
		<li class="nav-item dropdown">
		<a class="nav-link dropdown-toggle" href="#" id="dropdownMenuLink2" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Browse</a>
		<div class="dropdown-menu" aria-labelledby="dropdownMenuLink2">
    		<a class="dropdown-item" target="_blank" href="browse.jsp?leftTree=Normal">Normal-Centric</a>
    		<a class="dropdown-item" target="_blank" href="browse.jsp?leftTree=Cancer">Cancer-Centric</a>
    		<a class="dropdown-item" target="_blank" href="browse.jsp?leftTree=LncRNA">LncRNA-Centric</a>   		
  		</div>
		</li>
		<li class="nav-item"><a class="nav-link" href="download.jsp">Download</a></li>
		<li class="nav-item"><a class="nav-link" href="statistic.jsp">Statistic</a></li>
		<li class="nav-item"><a class="nav-link" href="help.jsp">Help</a></li>
		<li class="nav-item"><a class="nav-link" href="contact.jsp">Contact</a></li>
		<li class="nav-item"><a class="nav-link" href="news.jsp">News</a></li>
	</ul>
</nav>

<%
String leftTree = request.getParameter("leftTree");
if(leftTree==null || leftTree==""){
	leftTree = "Cancer";
}
%>
<section id="content" style="margin-top: 42px;">
	<div class="zerogrid">
		<div style="height:25px;"></div>
		<div class="container-fluid">			
			<div class="heading">
				<h2><a class="font-color">Users can view LncCE by different ways, based on LncRNA-Centric, Normal-Centric, Cancer-Centric.</a></h2>
			</div>
			<hr>
			<div class="content">
				<div style="overflow: hidden;">
				<%if(leftTree.equals("Normal")||leftTree.equals("Cancer")){ %>
				<iframe style="width: 100%;height: 2000px;" src="browse_cell.jsp?leftTree=<%=leftTree%>" frameborder="0"></iframe>
				<%}else{ %>
				<iframe style="width: 100%;height: 800px;" src="browse_cell.jsp?leftTree=<%=leftTree%>" frameborder="0"></iframe>
				<%} %>
				</div>
			</div>
		
		</div>
	</div>
</section>  

<!--------------Footer--------------->
<footer>		
	<div id="copyright">
	<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University</p>	
</div>
</footer>
</body>
</html>