<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<script src="jquery-ui-1.13.2/jquery-3.5.1.js" ></script>
<!-- jQuery and JavaScript Bundle with Popper -->
<script src="Bootstrap/jquery.slim.js"></script>
<script src="Bootstrap/bootstrap.bundle.min.js"></script>
<script src="js/iconify.min.js"></script>
<script src="js/jquery-2.0.0.min.js" ></script>
<script>
function Hidden1(class_H){
	var Display = $('.'+class_H).css("display");
	var up = '.up-'+class_H;
	var down = '.down-'+class_H;

	if(Display=="block"){
		$('.'+class_H).slideUp();
		$(up).css("display","none");
		$(down).css("display","inline-block");
	}else{
		$('.'+class_H).slideDown();
		$(up).css("display","inline-block");
		$(down).css("display","none");
	}
}
</script>
<style>
.title{
	font-size: 21px;
    font-weight: bolder;
    margin: 12px auto 5px auto;
}
.sub-title{
    font-size: 19px;
    margin-left: 21px;
    font-weight:bolder;
}
.home-content{
	font-size:18px;
}
.content{
	font-size:16px;
	margin-left: 47px;
}
.img{
	width:95%;
	margin:auto;
}
.num{
color:#fc011a
}
.intr{
margin-left: 35px;
}
.lead{
	text-align:justify;
	font-size: 20px;
}
</style>
</head>
<body>
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
<div class="container" style="margin-top: 35px;">
		<div class="row"><h2>1. Overview of LncCE</h2></div>
		<div class="row"><h3>1.1 The home page of LncCE</h3></div>
		<div class="row">
		<span class="lead">
		LncRNAs are well known as important players in maintaining morphology and function of tissues, and determining their cell specificity is fundamental to better comprehension of their function. LncCE is a database for Cellular-Elevated lncRNAs in human single cells. LncCE provides detailed expression atlas by analyzing single cell RNA sequencing from 2,893,787 single cell samples covering 149 cell types across 79 normal and 37 cancer tissues, enabling the exploration of the expression pattern for lncRNAs across different tissues. Currently, 14,941 CE lncRNAs were comprehensively discovered at the single-cell level.
		</span>
		</div>
		<div class="row"><h4>1.1.1</h4></div>
		<div class="row">
		<p class="lead">
		1.The main function modules of the database are provided in the navigation bar.<br/>
		2.Input lncRNA to obtain CE lncRNA information.
		</p>
		</div>
		<img src="images/help/1.png">
		
		<div class="row"><h4>1.1.2</h4></div>
		<div class="row">
		<p class="lead">
		1.It can be quickly queried by adult and pediatric body maps.<br/>
		2.Click on the tissues or cancers of interest to view CE lncRNA information.
		</p>
		</div>
		<img src="images/help/2.png">
		
		<div class="row"><h3>1.2 Definition of lncNRA classification</h3></div>
		<img src="images/help/3.png">
		
		<div class="row"><h2>2. Four ways to search in LncCE.</h2></div>
		<div class="row"><h3>2.1.Search normal tissues of LncCE</h3></div>
		<div class="row">
		<p class="lead">
		1.Select one of the 79 normal tissues, including adipose tissue, adrenal gland and so on.<br/>
		2.Select one of the three resources, including Human Cell Landscape, The Tabula Sapiens and TICA.<br/>
		3.Select one of CE classification, including CS, CER and CEH.<br/>
		4.Select a cell type in the corresponding resources and tissues.
		</p>
		</div>
		<img src="images/help/4.png">
				
		<div class="row"><h3>2.2 Search cancer type of LncCE</h3></div>
		<div class="row">
		<p class="lead">
		1.Select one of 16 cancer types, including bladder cancer, brain cancer and so on.<br/>
		2.Select a dataset associated with selected cancers.<br/>
		3.Select one of CE classification, including CS, CER and CEH.<br/>
		4.Select a cell type in the corresponding dataset and cancers.
		</p>
		</div>
		<img src="images/help/5.png">
		
		<div class="row"><h3>2.3 Search lncRNA of LncCE</h3></div>
		<div class="row">
		<p class="lead">
		Users can obtain the spatial expression pattern of the lncRNA by entering Gene Symbol or Ensembl Id.
		</p>
		</div>
		<img src="images/help/6.png">
		
		<div class="row"><h3>2.4.Search single cell of LncCE</h3></div>
		<div class="row">
		<p class="lead">
		1.Select one of 6 compartments, including cancer, endothelial and so on.<br/>
		2.Select one or all cell types in the corresponding compartment.<br/>
		3.Select one of 80 normal and 37 cancer tissues from different resources corresponding compartment and cells.
		</p>
		</div>
		<img src="images/help/7.png">
		
		<div class="row"><h2>3. Search result in LncCE.</h2></div>
		<div class="row"><h3>3.1.Search lncRNA of LncCE</h3></div>
		<div class="row">
		<p class="lead">
		1.Resources or datasets for search results.<br/>
		2.The basic information of CE lncRNA.<br/>
		3.Click to view the detail information.
		</p>
		</div>
		<img src="images/help/8.png">
		
		<div class="row"><h2>4.Spatial expression pattern in cancers.</h2></div>
		<div class="row">
		<p class="lead">
		4.1.1.The selected dataset or resource.<br/>
		4.1.2.The selected cancer.<br/>
		4.1.3.Detected increased expression in cells.<br/>
		4.1.4.The mean expression level of lncRNA in cells.<br/>
		4.1.5.The distribution of expression level of lncRNA in cells.<br/>
		4.1.6.Cell clustering based on highly variable genes.<br/>
		4.1.7.The expression level of lncRNA in cell types.
		</p>
		</div>
		<img src="images/help/9.1.png">
		<img src="images/help/9.2.png">
		<div class="row">
		<p class="lead">
		4.2.1.Other resources besides selecting resources.<br/>
		4.2.2.The mean expression level of lncRNA in cells of the selected cancer in other resources.<br/>
		4.2.3.The distribution of expression level of lncRNA in cells of the selected cancer in other resources.<br/>
		4.2.4.Cell clustering based on highly variable genes in other resources.<br/>
		4.2.5. The expression level of lncRNA in cell types in other resources.
		</p>
		</div>
		<img src="images/help/10.1.png">
		<img src="images/help/10.2.png">
		
		<div class="row"><h2>5.Spatial expression pattern in normal tissues.</h2></div>
		<div class="row">
		<p class="lead">
		5.1.1.Select tissues and resources.
		5.1.2.The mean expression level of lncRNA in cells of the selected tissue and resource.<br/>
		5.1.3.The distribution of expression level of lncRNA in cells of the selected cancer in other resources.<br/>
		5.1.4.Cell clustering based on highly variable genes in the selected tissue and resource.<br/>
		5.1.5.The expression level of lncRNA in cell clustering in the selected tissue and resource.
		</p>
		</div>
		<img src="images/help/11.1.png">
		<img src="images/help/11.2.png">
		<div class="row"><h2>6.LncRNA-mRNA co-expressed network and Prediction of function.</h2></div>
		<div class="row">
		<p class="lead">
		6.1.1.Select a classification.<br/>
		6.1.2.Select a relative r value.<br/>
		6.1.3.Predicted function.
		</p>
		</div>
		<img src="images/help/12.1.png">
		<img src="images/help/12.2.png">
		<img src="images/help/12.3.png">
		
		<div class="row"><h2>7.External links.</h2></div>		
		<img src="images/help/12.4.png">
		
		<div class="row"><h2>8.Differential expression analysis.</h2></div>		
		<img src="images/help/13.png">
		
		<div class="row"><h2>9.Survival analysis.</h2></div>		
		<img src="images/help/14.png">
		
		<div class="row"><h2>10.Browse and statistics in LncCE.</h2></div>
		<div class="row"><h3>10.1 LncRNA-Centric</h3></div>
		<div class="row">
		<p class="lead">
		1.Click on the lncRNA based on the tree structure of chromosomes to view its basic information.<br/>
		2.We provide the top 20 CE lncRNAs with highest entries for all resources.
		</p>
		</div>
		<img src="images/help/15.png">
		
		<div class="row"><h3>10.2 Normal-Centric</h3></div>
		<div class="row">
		<p class="lead">
		1.Click on the lncRNA based on the tree structure of normal tissues to view its basic information.<br/>
		2.We provide the distribution of adult and fetal normal tissues CE lncRNAs for each resource.
		</p>
		</div>
		<img src="images/help/16.png">
		
		<div class="row"><h3>10.3 Cancer-Centric</h3></div>
		<div class="row">
		<p class="lead">
		1.Click on the lncRNA based on the tree structure of cancers to view its basic information.<br/>
		2.We provide the distribution of adult and pediatric cancer CE lncRNAs.
		</p>
		</div>
		<img src="images/help/17.png">
				
		
	</div>


<footer>		
	<div id="copyright">
	<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University.</p>
	
</div>
</footer><!-- End Footer -->

</body>
</html>