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
        .timeline {
            list-style-type: none;
            padding: 0;
            position: absolute;
            height:33px;
        }

        .timeline-item {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .timeline-item:before {
            content: "";
            width: 2px;
            height: 100%;
            background-color: #333;
            position: absolute;
            left: 5px;
        }

        .timeline-item-content {
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 5px;
            flex: 1;
        }

        .timeline-date {
            font-weight: bold;
            margin-right: 10px;
        }

        .timeline-content {
            font-size: 19px;
        }
</style>
<body>
<!--------------Header--------------->
<header> 
	<div id="logo"><a href="index.jsp"><img width="408px" src="./images/home/logo-white.png"/></a></div>	
</header>
<nav>
	<ul>
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
	
<div class="container" style="margin-top:42px;">
   
    <ul class="timeline">
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2020-05-15</span>
                <span class="timeline-content">The first version is online! <a target="_blank" href="http://bio-bigdata.hrbmu.edu.cn/LncSpA">LncSpA: LncRNA Spatial Atlas of Expression across Normal and Cancer Tissues</a></span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2022-03-05</span>
                <span class="timeline-content">Reading single-cell literature; Put forward the topic idea.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2022-06-16</span>
                <span class="timeline-content">Collection and preprocessing of single cell transcriptome data.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2022-07-01</span>
                <span class="timeline-content">Downstream analysis of single cell transcriptome data.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2023-02-28</span>
                <span class="timeline-content">Web platform construction start.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2023-03-01</span>
                <span class="timeline-content">Added 2 resources for normal tissues.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2023-03-28</span>
                <span class="timeline-content">Added 30 datasets for cancer tissues.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2023-04-01</span>
                <span class="timeline-content">Added 80 datasets for cancer tissues.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2023-04-16</span>
                <span class="timeline-content">Added 67 datasets for cancer tissues.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2023-04-21</span>
                <span class="timeline-content">Added 1 resource for normal tissues.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2023-05-10</span>
                <span class="timeline-content">Added 3 datasets for cancer tissues.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2023-05-12</span>
                <span class="timeline-content">Added 1 datasets for cancer tissues.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2023-05-29</span>
                <span class="timeline-content">Unify cancer names across all datasets.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2024-03-14</span>
                <span class="timeline-content">Added a "News" tab to show the update history of the database.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2024-03-15</span>
                <span class="timeline-content">Added links to other databases on the "Home" page.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2024-03-15</span>
                <span class="timeline-content">Center the navigation bar of the "Result" page.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2024-03-15</span>
                <span class="timeline-content">On the "Browsing" page, added full cancer names.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2024-03-15</span>
                <span class="timeline-content">Added CE lncRNAs based on tissue or cancer type.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2024-03-15</span>
                <span class="timeline-content">Add a download button for the results table.</span>
            </div>
        </li>
        <li class="timeline-item">
            <div class="timeline-item-content">
                <span class="timeline-date">2024-03-15</span>
                <span class="timeline-content">The updated version of LncCE is online!</span>
            </div>
        </li>
    </ul>                  
                                 
</div> 

<!-- <footer>		 -->
<!-- 	<div id="copyright"> -->
<!-- 		<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University</p> -->
<!-- 	</div> -->
<!-- </footer> -->
</body>
</html>