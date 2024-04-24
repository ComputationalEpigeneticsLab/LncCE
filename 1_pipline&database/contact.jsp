<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
<title>LncCE</title>
</head>
<style>
.contact {
    position: relative;
    margin: 32px auto;
    width: 1100px;
    height: 606px;
    font-size:18px;
}
</style>
<body>
<!--------------Header--------------->
<header> 
	<div id="logo"><a href="index.jsp"><img width="408px" src="./images/home/logo-white.png"/></a></div>	
</header>
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
	
<div class="contact">
                   <table width=95% align="center" style="margin-top: 85px;">
				<tr>
					<td align="left"><font size="5">Please don't hesitate
							to address comments, questions or suggestions regarding this
							website.</font></td>

				</tr>
				<tr>
					<td><br>
						<table width=90% align="center">
							
							<tr>
								<td align="left">Juan Xu (professor)</td>
							</tr>
							<tr>
								<td align="left"><table width=90% align="center"
										background="images/bg_contact.png" style = "background-size:96%">
										<tr>
											<td>College of Bioinformatics Science and Technology</td>
										</tr>
										<tr>
											<td><a href="http://www.hrbmu.edu.cn" target="_blank">Harbin
													Medical University, China</a></td>
										</tr>
										<tr>
											<td>Tel: +86 451 86615922</td>
										</tr>
										<tr>
											<td>Fax: +86 451 86615922</td>
										</tr>
										<tr>
											<td>Email: <a href="#">xujuanbiocc@ems.hrbmu.edu.cn</a></td>
										</tr>

									</table><br></td>
							</tr>														
							<tr>
								<td align="left">Yongsheng Li (professor)</td>
							</tr>
							<tr>
								<td align="left"><table width=90% align="center"
										background="images/bg_contact.png" style = "background-size:96%">
										<tr>
											<td>School of Interdisciplinary Medicine and Engineering</td>
										</tr>
										<tr>
											<td><a href="http://www.hainmc.edu.cn/" target="_blank">Harbin
													Medical University, China</a></td>
										</tr>
										<tr>
											<td>Tel: +86 451 86615922</td>
										</tr>
										<tr>
											<td>Fax: +86 451 86615922</td>
										</tr>										
										<tr>
											<td>Email: <a href="#">liyongsheng@ems.hrbmu.edu.cn</a></td>
										</tr>
									</table></td>
							</tr>
						</table></td>
				  </tr>
			    </table>
                                 
               </div> 

<footer>		
	<div id="copyright">
	<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University</p>
	
</div>
</footer>

</body>
</html>