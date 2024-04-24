<%@ page import="java.sql.*" import="java.util.*" import="download.*"
	language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Basic Page Needs
================================================== -->
<meta http-equiv="Content-Type" content="textml; charset=UTF-8">
<title>LncCE</title>
<meta name="description" content="Free Html5 Templates and Free Responsive Themes Designed by Kimmy | zerotheme.com">
<meta name="author" content="www.zerotheme.com">	
<!-- Mobile Specific Metas
================================================== -->
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">    
<!-- CSS
================================================== -->
<link rel="stylesheet" href="css/zerogrid.css">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/responsive.css">
<link rel="stylesheet" href="css/responsiveslides.css" />	
	<!--[if lt IE 8]>
       <div style=' clear: both; text-align:center; position: relative;'>
         <a href="http://windows.microsoft.com/en-US/internet-explorer/products/ie/home?ocid=ie6_countdown_bannercode">
           <img src="http://storage.ie6countdown.com/assets/100/images/banners/warning_bar_0000_us.jpg" border="0" height="42" width="820" alt="You are using an outdated browser. For a faster, safer browsing experience, upgrade for free today." />
        </a>
      </div>
    <![endif]-->
    <!--[if lt IE 9]>
		<script src="js/html5.js"></script>
		<script src="js/css3-mediaqueries.js"></script>
	<![endif]-->	
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
<script src="js/jquery-2.0.0.min.js" ></script>
<style>
.img-size{
	width:85px;
	height:85px;
}
.col2{
	padding-right: 73px;
    padding-top: 10px;
}
.font-color{
	color:#8064A2;
}
.nav-pills .nav-link.active, .nav-pills .show>.nav-link {
    color: #fff;
    background-color: #7e64a4;
}
.contain-scroll{
	overflow-y: scroll;
    height: 690px;
    width: 341px;
}
/*.contain-scroll2{
	overflow-y: scroll;
    height: 690px;
    width: 341px;
    margin-left:129px;
}*/
.human-distance{
	margin-left: 47px;
	margin-top: 92px;
}
.content-yj{
	width:208px;
	height:84px;
}
.right-distance{
    margin-left: 123px;
}
.psty{
	text-align: justify;
	font-size: 23px;
}
.container-link{
width:100%;
height:143px;
margin:50px auto;
padding:35px;
}
.ul-size{
height:75px;
width:100000px;
position: absolute;
}
.li-pad{
padding-left:60px;
}
</style>
<script>
function submit(){
	var value1= $("#sigcell_lncrna").val();
	if(value1==""){
		alert("Not emperty!");
	}else{
		document.form.submit();
	}
}
</script>
<script type="text/javascript"> 
function showImg(name){ 	 	
	var resource = name+'_resource'
	document.getElementById("body").style.display='none';
	document.getElementById(name).style.display='block';  

	document.getElementById("all_resource").style.display='none';
	document.getElementById(resource).style.display='block'; 
} 
function hideImg(name){ 
	var resource = name+'_resource'
	document.getElementById(name).style.display='none';
	document.getElementById("body").style.display='block';
	
	document.getElementById(resource).style.display='none';
	document.getElementById("all_resource").style.display='block';
	
}
function showImg_f(name){ 	 	
	var f_re = name+'_Fresour'	
	var f_name = 'fetal_'+name
	document.getElementById("body_pedia").style.display='none';
	document.getElementById(f_name).style.display='block';
	
	document.getElementById("all_fresource").style.display='none';
	document.getElementById(f_re).style.display='block';
} 
function hideImg_f(name){ 
	var f_re = name+'_Fresour'	
	var f_name = 'fetal_'+name
	document.getElementById(f_name).style.display='none';
	document.getElementById("body_pedia").style.display='block';
	
	document.getElementById(f_re).style.display='none';
	document.getElementById("all_fresource").style.display='block';
	
}
/*---------------------------------------------------------------------*/
function showImg2(name,name2){ 	 	
	var sub_name = 'sub_'+name
	document.getElementById("all_resource").style.display='none';		
	document.getElementById(sub_name).style.display='block'; 
	
	document.getElementById(name2).style.display='block';
	document.getElementById("body").style.display='none';
		
} 
function hideImg2(name,name2){ 
	var sub_name = 'sub_'+name	
	document.getElementById("all_resource").style.display='block';	
	document.getElementById(sub_name).style.display='none';
	
	document.getElementById(name2).style.display='none';
	document.getElementById("body").style.display='block';
	
}
function showImg2_f(name,name2){ 	 	
	var sub_name = 'sub_'+name
	var f_name2 = 'fetal_'+name2	
	
	document.getElementById("all_fresource").style.display='none';		
	document.getElementById(sub_name).style.display='block'; 
	
	document.getElementById(f_name2).style.display='block';
	document.getElementById("body_pedia").style.display='none';
} 
function hideImg2_f(name,name2){ 
	var sub_name = 'sub_'+name
	var f_name2 = 'fetal_'+name2	
	
	document.getElementById("all_fresource").style.display='block';	
	document.getElementById(sub_name).style.display='none';
	
	document.getElementById(f_name2).style.display='none';
	document.getElementById("body_pedia").style.display='block';
}
/*-------------------------------------------------*/
function showImg3(name,name1){ 	 	
	var datasets = name+'_dataset'
	document.getElementById("body").style.display='none';
	document.getElementById(name1).style.display='block';  	

	document.getElementById("all_datasets").style.display='none';
	document.getElementById(datasets).style.display='block';
	
		
} 
function hideImg3(name,name1){ 
	var datasets = name+'_dataset'
	document.getElementById(name1).style.display='none';
	document.getElementById("body").style.display='block';
	
	document.getElementById(datasets).style.display='none';
	document.getElementById("all_datasets").style.display='block';	

}
/*------------------------------------------------------*/
function showImg4(name,name2,name3){ 	 	
		var sub_name = 'sub_'+name  	
		document.getElementById("all_datasets").style.display='none';		
		document.getElementById(sub_name).style.display='block'; 
		
		document.getElementById(name3).style.display='block';
		document.getElementById("body").style.display='none';
	} 
	function hideImg4(name,name2,name3){ 
		var sub_name = 'sub_'+name	
		document.getElementById("all_datasets").style.display='block';	
		document.getElementById(sub_name).style.display='none';
		
		document.getElementById(name3).style.display='none';
		document.getElementById("body").style.display='block';
	}
/*-------------------------------------------------------------*/
function showImg5(name){ 	 	 		
	var fresour = name+'_Fresour'
	document.getElementById("all_Pdatasets").style.display='none';		
	document.getElementById(fresour).style.display='block'; 

	document.getElementById(name).style.display='block';
	document.getElementById("body_pedia").style.display='none';
} 
function hideImg5(name){ 			
	var fresour = name+'_Fresour'
	document.getElementById("all_Pdatasets").style.display='block';	
	document.getElementById(fresour).style.display='none';
	
	document.getElementById(name).style.display='none';
	document.getElementById("body_pedia").style.display='block';
}
</script>
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel="";
db.open();

/*---------------------------正常成人-----------------------------*/
List<String> normal_adult_class = new ArrayList<String>();
List<String> normal_adult_low = new ArrayList<String>();
List<String> normal_adult_tissue = new ArrayList<String>();
List<String> normal_adult_resource = new ArrayList<String>();
List<String> normal_adult_celltype = new ArrayList<String>();
List<String> normal_adult_class0 = new ArrayList<String>();
List<String> normal_adult_tissue0 = new ArrayList<String>();
List<String> normal_adult_resource0 = new ArrayList<String>();
List<String> normal_adult_celltype0 = new ArrayList<String>();
List<String> sub_normal_adult = new ArrayList<String>();
List<String> sub_normal_adult_resource = new ArrayList<String>();
List<String> sub_normal_adult_celltype = new ArrayList<String>();
sel = "select tissue_type2,tissue_type,resource_count,celltype_count from index_normal where class='Adult' order by tissue_type2";
rs = db.execute(sel);
while(rs.next()){
	String tmp_tis = rs.getString("tissue_type");
	normal_adult_class0.add(rs.getString("tissue_type2"));
	normal_adult_tissue0.add(tmp_tis);
	normal_adult_resource0.add(rs.getString("resource_count"));
	normal_adult_celltype0.add(rs.getString("celltype_count"));
}
//去重
for(int u=0;u<normal_adult_class0.size();u++){
	if(!normal_adult_class.contains(normal_adult_class0.get(u))){
		normal_adult_class.add(normal_adult_class0.get(u));
		normal_adult_resource.add(normal_adult_resource0.get(u));
		normal_adult_celltype.add(normal_adult_celltype0.get(u));
		normal_adult_tissue.add(normal_adult_tissue0.get(u));
	}
}

int normal_adult_size = normal_adult_class.size();
for(int k=0;k<normal_adult_size;k++){
	normal_adult_low.add(normal_adult_class.get(k).toLowerCase());
}

/*正常成人有子类*/
String[] tmp_tissue = {"Adipose","Blood","Bone Marrow","JeJunum","Lymph node","Muscle","Pancreas"};
for(int i=0;i<7;i++){
sel = "select tissue_type1,tissue_type,sub_resource_count,sub_celltype_count from index_normal where class='Adult' and tissue_type2='"+tmp_tissue[i]+"' order by tissue_type1";
rs = db.execute(sel);
while(rs.next()){
	String tmp_tiss=rs.getString("tissue_type1");    		
	sub_normal_adult.add(tmp_tiss);
	sub_normal_adult_resource.add(rs.getString("sub_resource_count"));
	sub_normal_adult_celltype.add(rs.getString("sub_celltype_count"));
}
}

/*----------------------------------正常胎儿-----------------------------------------*/
List<String> normal_fetal_class = new ArrayList<String>();
List<String> normal_fetal_class0 = new ArrayList<String>();
List<String> normal_fetal_tissue = new ArrayList<String>();
List<String> normal_fetal_tissue0 = new ArrayList<String>();
List<String> normal_fetal_low = new ArrayList<String>();
List<String> normal_fetal_resource = new ArrayList<String>();
List<String> normal_fetal_celltype = new ArrayList<String>();
List<String> normal_fetal_resource0 = new ArrayList<String>();
List<String> normal_fetal_celltype0 = new ArrayList<String>();
sel = "select tissue_type2,tissue_type,resource_count,celltype_count from index_normal where class='Fetal' order by tissue_type2";
rs = db.execute(sel);
while(rs.next()){
	String tmp_ti = rs.getString("tissue_type");
	normal_fetal_class0.add(rs.getString("tissue_type2"));
	normal_fetal_tissue0.add(tmp_ti.replace("Fetal-",""));
	normal_fetal_resource0.add(rs.getString("resource_count"));
	normal_fetal_celltype0.add(rs.getString("celltype_count"));	
}
//去重

for(int u=0;u<normal_fetal_class0.size();u++){
	if(!normal_fetal_class.contains(normal_fetal_class0.get(u))){
		normal_fetal_class.add(normal_fetal_class0.get(u));
		normal_fetal_resource.add(normal_fetal_resource0.get(u));
		normal_fetal_celltype.add(normal_fetal_celltype0.get(u));
		normal_fetal_tissue.add(normal_fetal_tissue0.get(u));
	}
}

int normal_fetal_size = normal_fetal_class.size();
for(int k=0;k<normal_fetal_size;k++){
	normal_fetal_low.add(normal_fetal_class.get(k).toLowerCase());
	//System.out.println(normal_fetal_class.get(k));
}

/*正常胎儿有子类*/
List<String> sub_normal_fetal = new ArrayList<String>();
List<String> sub_normal_fetal_tissue = new ArrayList<String>();
List<String> sub_normal_fetal_resource = new ArrayList<String>();
List<String> sub_normal_fetal_celltype = new ArrayList<String>();
String[] tmp_ftissue = {"Brain","Gonad"};
for(int i=0;i<2;i++){
sel = "select tissue_type1,tissue_type,sub_resource_count,sub_celltype_count from index_normal where class='Fetal' and tissue_type2='"+tmp_ftissue[i]+"' order by tissue_type1";
rs = db.execute(sel);
while(rs.next()){
	String tmp_tiss=rs.getString("tissue_type1");
	sub_normal_fetal_tissue.add(rs.getString("tissue_type"));
	sub_normal_fetal.add(tmp_tiss);
	sub_normal_fetal_resource.add(rs.getString("sub_resource_count"));
	sub_normal_fetal_celltype.add(rs.getString("sub_celltype_count"));
}
}

/*------------------------癌症成人----------------------------------*/
List<String> cancer_adult_class = new ArrayList<String>();
List<String> cancer_adult_resource = new ArrayList<String>();
List<String> cancer_adult_celltype = new ArrayList<String>();
sel = "select distinct class,resource_count,celltype_count from index_cancer where source='Adult' order by class";
rs = db.execute(sel);
while(rs.next()){
	cancer_adult_class.add(rs.getString("class"));
	cancer_adult_resource.add(rs.getString("resource_count"));
	cancer_adult_celltype.add(rs.getString("celltype_count"));
}
int cancer_adult_size = cancer_adult_class.size();

/*癌症成人有子类*/
List<String> sub_cancer_adult = new ArrayList<String>();
List<String> sub_cancer_adult_resource = new ArrayList<String>();
List<String> sub_cancer_adult_celltype = new ArrayList<String>();
for(int k=0;k<cancer_adult_size;k++){
	sel = "select distinct cancer,sub_resource_count,sub_celltype_count from index_cancer where source='Adult' and class='"+cancer_adult_class.get(k)+"' order by cancer";
	rs = db.execute(sel);
	while(rs.next()){
		String tmp_tiss=rs.getString("cancer");    		
		sub_cancer_adult.add(tmp_tiss);
		sub_cancer_adult_resource.add(rs.getString("sub_resource_count"));
		sub_cancer_adult_celltype.add(rs.getString("sub_celltype_count"));
	}
}

/*-----------------------癌症儿童-------------------------*/
List<String> cancer_pedia_class = new ArrayList<String>();
List<String> cancer_pedia_tissue = new ArrayList<String>();
List<String> cancer_pedia_resource = new ArrayList<String>();
List<String> cancer_pedia_celltype = new ArrayList<String>();
sel = "select cancer,cancer_name,sub_resource_count,sub_celltype_count from index_cancer where source='Fetal' order by class";
//System.out.println(sel);
rs = db.execute(sel);
while(rs.next()){
	cancer_pedia_class.add(rs.getString("cancer"));
	cancer_pedia_tissue.add(rs.getString("cancer_name"));
	cancer_pedia_resource.add(rs.getString("sub_resource_count"));
	cancer_pedia_celltype.add(rs.getString("sub_celltype_count"));
}
%>  
</head>
<body>
<!--------------Header--------------->
<header> 
	<div id="logo"><a href="index.jsp"><img width="408px" src="./images/home/logo-white.png"/></a></div>
	<div id="search">
		<div class="button-search" onclick="submit()"></div>
		<form name="form" action="search_re_lnc.jsp">
		<input name="showPage" id="showPage" type="hidden" value=1>
		<input placeholder="Input lncRNA.." type="text" id="sigcell_lncrna" name="sigcell_lncrna" class="form-control">
		</form>
	</div>
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
<section id="content" style="margin-top: 27px;">
	<div class="zerogrid">
		<div style="height:25px;"></div>
		<div class="container-fluid">
		<div class="heading">
			<h2><a class="font-color">Welcome to LncCE</a></h2>
			<hr>
		</div>
		<div class="content">
		<p class="psty">LncRNAs are well known as important players in maintaining morphology and function of tissues, and determining their cell specificity is fundamental to better comprehension of their function. LncCE is a database for <span style="text-decoration:underline;">C</span>ellular-<span style="text-decoration:underline;">E</span>levated <span style="text-decoration:underline;">lnc</span>RNAs in human single cells. LncCE provides detailed expression atlas by analyzing single cell RNA sequencing from 2,893,787 single cell samples covering 149 cell types across 79 normal and 37 cancer tissues, enabling the exploration of the expression pattern for lncRNAs across different tissues. Currently, 14,941 CE lncRNAs were comprehensively discovered at the single-cell level.</p>
		</div>
		</div>
		<div style="height:25px;"></div>
		<div class="container-fluid">
		<div class="heading">
			<h2><a class="font-color">Data overview</a></h2>
			<hr>
		</div>
		<div class="">
		<div class="row">
		<div class="col-md-auto">
			<div class="row">
				<div class="">
				<img src="images/home/cells.png" class="img-size" alt="cells">
				</div>
				<div class="col col2">
				<span><h4>2,893,787</h4></span><br/>
				<span class="psty"><p>Cells</p></span>
				</div>
			</div>
		</div>
		<div class="col-md-auto">
			<div class="row">
				<div class="">
				<span><img src="images/home/datasets.png" class="img-size" alt="cells"></span>
				</div>
				<div class="col col2">
				<span><h4>181</h4></span><br/>
				<span class="psty"><p>Datasets</p></span>
				</div>
			</div>
		</div>
		<div class="col-md-auto">
			<div class="row">
				<div class="">
				<span><img src="images/home/cell-types.png" class="img-size" alt="cells"></span>
				</div>
				<div class="col col2">
				<span><h4>149</h4></span><br/>
				<span class="psty"><p>Cell types</p></span>
				</div>
			</div>
		</div>
		<div class="col-md-auto">
			<div class="row">
				<div class="">
				<span><img src="images/home/healthy-tissue.png" class="img-size" alt="cells"></span>
				</div>
				<div class="col col2">
				<span><h4>79</h4></span><br/>
				<span class="psty"><p>Normal tissues</p></span>
				</div>
			</div>
		</div>
		<div class="col-md-auto">
			<div class="row">
				<div class="">
				<span><img src="images/home/cancer-tissues.png" class="img-size" alt="cells"></span>
				</div>
				<div class="col col2">
				<span><h4>37</h4></span><br/>
				<span class="psty"><p>Cancer tissues</p></span>
				</div>
			</div>
		</div>
		</div>
		</div>
		</div>
		<div style="height:25px;"></div>
		
		<div class="container-fluid">
		<div class="heading">
			<h2><a class="font-color">Quick search</a></h2>
			<hr>
		</div>
		
		<div class="content" style="max-width: 1500px;margin: 0 auto;">
		<div class="row justify-content-center">
		<ul class="nav nav-pills mb-3 tab-title" id="pills-tab" role="tablist">
  			<li class="nav-item" role="presentation">
    		<button class="nav-link active" id="sites-tab" data-toggle="pill" data-target="#sites" type="button" role="tab" aria-controls="sites" aria-selected="true">
    		<h4>Adult</h4>
			</button>
  			</li>
  			<li class="nav-item" role="presentation">
    		<button class="nav-link" id="gene-tab" data-toggle="pill" data-target="#gene" type="button" role="tab" aria-controls="gene" aria-selected="false">
    		<h4>Pediatric/fetal</h4>
			</button>
  			</li>
		</ul>
		</div>			
		<div class="tab-content" id="pills-tabContent">
<!-- ------------------------------成人------------------------------- -->
  		<div class="tab-pane fade show active" id="sites"  role="tabpanel" aria-labelledby="sites-tab">  		
  		<div class="row">
		
		<div class="col">
		<div class="row">
		<div class="col"><h4>Normal tissues:</h4></div>		
		</div>
		<div class="row">
		<div id="all_resource" class="">		
		<div class="col-12">
		<h3 class="font-color">3 resources</h3>
		<h3 class="font-color">262 Cell types</h3>
		</div>		
		</div>
		
		<%for(int i=0;i<normal_adult_size;i++){ %>
		<div id="<%=normal_adult_low.get(i)%>_resource" class="" style="display:none;">
		<div class="col-12">
		<h3 class="font-color"><%=normal_adult_resource.get(i) %> resources</h3>
		<h3 class="font-color"><%=normal_adult_celltype.get(i) %> Cell types</h3>
		</div>
		</div>
		<%} %>
		
		<%for(int i=0;i<sub_normal_adult.size();i++){ %>
		<div id="sub_<%=sub_normal_adult.get(i).toLowerCase()%>" class="" style="display:none;">
		<div class="col-12">
		<h3 class="font-color"><%=sub_normal_adult_resource.get(i) %> resources</h3>
		<h3 class="font-color"><%=sub_normal_adult_celltype.get(i) %> Cell types</h3>
		</div>
		</div>
		<%} //System.out.println(sub_normal_adult.size());%>
			
		</div>		
		
		<div id="tissues">				
		<div class="card card-body contain-scroll">
		<%for(int i=0;i<normal_adult_size;i++){ %>
		<%if(normal_adult_class.get(i).equals("Adipose")||normal_adult_class.get(i).equals("Blood")||normal_adult_class.get(i).equals("Bone Marrow")||normal_adult_class.get(i).equals("JeJunum")||normal_adult_class.get(i).equals("Lymph node")||normal_adult_class.get(i).equals("Muscle")||normal_adult_class.get(i).equals("Pancreas")){ %>
		<div class="btn-group dropright">
  		
  		<button onMouseOut="hideImg('<%=normal_adult_low.get(i) %>')" onmouseover="showImg('<%=normal_adult_low.get(i) %>')" type="button" class="btn btn-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    	<b><%=normal_adult_class.get(i) %></b>
  		</button>
  		
  		<div class="dropdown-menu">
    	<%
    	sel = "select distinct tissue_type1,tissue_type from index_normal where class='Adult' and tissue_type2='"+normal_adult_class.get(i)+"' order by tissue_type1";
    	rs = db.execute(sel);
    	while(rs.next()){
    		String tmp_tiss4=rs.getString("tissue_type1");
    		String tmp_tiss=rs.getString("tissue_type1").toLowerCase();
    		String tmp_tiss2=normal_adult_class.get(i).toLowerCase();
    		String tmp_tiss3=rs.getString("tissue_type");
    		out.println("<a class=\"dropdown-item\" target=\"_blank\" href=\"index_re.jsp?type=normal_adult&tissue="+tmp_tiss3+"\" onMouseOut=\"hideImg2('"+tmp_tiss+"','"+tmp_tiss2+"')\" onmouseover=\"showImg2('"+tmp_tiss+"','"+tmp_tiss2+"')\">");
    		out.println(tmp_tiss4);
    		out.println("</a>");    		
    	}
    	    	
    	%>
  		</div>
		</div>
		<%}else{ %>		
		<div class="btn-group">  		
  		<button onMouseOut="hideImg('<%=normal_adult_low.get(i) %>')" onmouseover="showImg('<%=normal_adult_low.get(i) %>')" onclick="window.location.href='index_re.jsp?type=normal_adult&tissue=<%=normal_adult_tissue.get(i) %>'" type="button" class="btn btn-light">
    	<b><%=normal_adult_class.get(i) %></b>
  		</button>
		</div>
		<%} %>
		
		<div class="row"></div>
		<%} %>
		
		
		</div>
		</div>
		</div>
		
		<div class="col">
		<div id="human">		
		<div class="human-distance">
			<div id="body">
			<img  src="images/adult_tissue/body.png">
			</div>
			<%for(int j=0;j<normal_adult_size;j++){ %>
			<img id="<%=normal_adult_low.get(j)%>" src="images/adult_tissue/<%=normal_adult_low.get(j)%>.png" style="display:none;">
			<%} %>
			<%for(int j=0;j<cancer_adult_size;j++){ %>
			<img id="<%=cancer_adult_class.get(j)%>" src="images/adult_cancer/<%=cancer_adult_class.get(j)%>.png" style="display:none;">
			<%} %>
		</div>
		</div>
		</div>
		
		<div class="col">
		<div class="row right-distance">
		<div class="col"><h4><span style="">Cancer tissues:</span></h4></div>		
		</div>
		
		<div class="row right-distance">
		<div id="all_datasets" class="" >		
		<div class="col-12">
		<h3 class="font-color"> <span style="">59 datasets</span></h3>
		<h3 class="font-color"> <span style="">103 Cell types</span></h3>
		</div>		
		</div>
		
		<%for(int i=0;i<cancer_adult_size;i++){ %>
		<div id="<%=cancer_adult_class.get(i)%>_dataset" class="" style="display:none;">
		<div class="col-12">
		<h3 class="font-color"><span style=""><%=cancer_adult_resource.get(i) %> datasets</span></h3>
		<h3 class="font-color"><span style=""><%=cancer_adult_celltype.get(i) %> Cell types</span></h3>
		</div>
		</div>
		<%} %>
		
		<%for(int i=0;i<sub_cancer_adult.size();i++){ %>
		<div id="sub_<%=sub_cancer_adult.get(i)%>" class="" style="display:none;">
		<div class="col-12">
		<h3 class="font-color"><%=sub_cancer_adult_resource.get(i) %> datasets</h3>
		<h3 class="font-color"><%=sub_cancer_adult_celltype.get(i) %> Cell types</h3>
		</div>
		</div>
		<%} //System.out.println(sub_normal_adult.size());%>
			
		</div>
		
		<div id="cancers">				
		<div class="card card-body contain-scroll" style="float: right;">
		<%for(int i=0;i<cancer_adult_class.size();i++){ %>
		<div class="btn-group dropright">
  		<button onMouseOut="hideImg3('<%=cancer_adult_class.get(i) %>','<%=cancer_adult_class.get(i)%>')" onmouseover="showImg3('<%=cancer_adult_class.get(i) %>','<%=cancer_adult_class.get(i) %>')" type="button" class="btn btn-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    	<b><%=cancer_adult_class.get(i) %></b>
  		</button>
  		<div class="dropdown-menu">
    	<%
    	sel = "select distinct cancer,cancer_name from index_cancer where source='Adult' and class='"+cancer_adult_class.get(i)+"' order by cancer";
    	rs = db.execute(sel);
    	while(rs.next()){
    		String tmp_tiss=rs.getString("cancer");
    		String tmp_tiss2=cancer_adult_class.get(i);
    		String tmp_tiss3=rs.getString("cancer_name");    		
    		out.println("<a class=\"dropdown-item\" target=\"_blank\" href=\"index_re.jsp?type=cancer_adult&tissue="+tmp_tiss3+"\" onMouseOut=\"hideImg4('"+tmp_tiss+"','"+tmp_tiss2+"','"+tmp_tiss2+"')\" onmouseover=\"showImg4('"+tmp_tiss+"','"+tmp_tiss2+"','"+tmp_tiss2+"')\">");
    		out.println(tmp_tiss3.replace("NA_",""));
    		out.println("</a>");
    	}
    	%>
  		</div>
		</div>
		<div class="row"></div>
		<%} %>
		</div>	

		</div>
		</div>
		
		</div>	
  		</div>
<!-- ---------------------------------儿童/胎儿------------------------------------------- -->  		
  		<div class="tab-pane fade" id="gene" role="tabpanel" aria-labelledby="gene-tab">			
		<div class="row">
		<div class="col">
		
		<div class="row">
		<div class="col"><h4>Fetal-Tissues:</h4></div>
		</div>
		
		<div class="row">
		<div id="all_fresource" class="">		
		<div class="col-12">
		<h3 class="font-color">1 resource</h3>
		<h3 class="font-color">148 Cell types</h3>
		</div>		
		</div>
		
		<%for(int i=0;i<normal_fetal_size;i++){ %>
		<div id="<%=normal_fetal_low.get(i)%>_Fresour" class="" style="display:none;">
		<div class="col-12">
		<h3 class="font-color"><%=normal_fetal_resource.get(i) %> resource</h3>
		<h3 class="font-color"><%=normal_fetal_celltype.get(i) %> Cell types</h3>
		</div>
		</div>
		<%} %>
		
		<%for(int i=0;i<sub_normal_fetal.size();i++){ %>
		<div id="sub_<%=sub_normal_fetal.get(i).toLowerCase()%>" class="" style="display:none;">
		<div class="col-12">
		<h3 class="font-color"><%=sub_normal_fetal_resource.get(i) %> resource</h3>
		<h3 class="font-color"><%=sub_normal_fetal_celltype.get(i) %> Cell types</h3>
		</div>
		</div>
		<%} //System.out.println(sub_normal_adult.size());%>
			
		</div>
		
		<div id="fetal_tissues">
		<div class="row">
		
		</div>
		<div class="card card-body contain-scroll">
		<%for(int i=0;i<normal_fetal_size;i++){ %>
		<%if(normal_fetal_class.get(i).equals("Brain")||normal_fetal_class.get(i).equals("Gonad")){ %>
		<div class="btn-group dropright">
  		<button onMouseOut="hideImg_f('<%=normal_fetal_low.get(i) %>')" onmouseover="showImg_f('<%=normal_fetal_low.get(i) %>')" type="button" class="btn btn-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    	<b><%=normal_fetal_class.get(i) %></b>
  		</button>
  		<div class="dropdown-menu">
    	<%
    	sel = "select distinct tissue_type1,tissue_type from index_normal where class='Fetal' and tissue_type2='"+normal_fetal_class.get(i)+"' order by tissue_type1";
    	rs = db.execute(sel);
    	while(rs.next()){
    		String tmp_tiss4=rs.getString("tissue_type1").replace("Fetal-","");
    		String tmp_tiss=rs.getString("tissue_type1").toLowerCase();
    		String tmp_tiss2=normal_fetal_class.get(i).toLowerCase();
    		String tmp_tiss3=rs.getString("tissue_type").replace("Fetal-","");
    		out.println("<a class=\"dropdown-item\" target=\"_blank\" href=\"index_re.jsp?type=normal_fetal&tissue="+tmp_tiss3+"\" onMouseOut=\"hideImg2_f('"+tmp_tiss+"','"+tmp_tiss2+"')\" onmouseover=\"showImg2_f('"+tmp_tiss+"','"+tmp_tiss2+"')\">");
    		out.println(tmp_tiss4);
    		out.println("</a>");    		
    	}
    	    	
    	%>
  		</div>
		</div>
		<div class="row"></div>
		<%}else{ %>
		<div class="btn-group">
  		<button onMouseOut="hideImg_f('<%=normal_fetal_low.get(i) %>')" onmouseover="showImg_f('<%=normal_fetal_low.get(i) %>')" onclick="window.location.href='index_re.jsp?type=normal_fetal&tissue=<%=normal_fetal_tissue.get(i) %>'" type="button" class="btn btn-light">
    	<b><%=normal_fetal_class.get(i) %></b>
  		</button>
  		
		</div>		
		
		<div class="row"></div>
		<%} }%>
		
		
		</div>
		</div>
		</div>
		
		<div class="col">
		<div id="pediatric">
		<div class="human-distance">						
		<img id="body_pedia" src="images/fetal_tissue/pediatric.png">
		<%for(int j=0;j<normal_fetal_size;j++){ %>
		<img id="fetal_<%=normal_fetal_low.get(j)%>" src="images/fetal_tissue/<%=normal_fetal_low.get(j)%>.png" style="display:none;">
		<%} %>
		<%for(int j=0;j<5;j++){ %>
		<img id="<%=cancer_pedia_class.get(j)%>" src="images/pedia_cancer/<%=cancer_pedia_class.get(j)%>.png" style="display:none;">
		<%} %>
		</div>
		</div>
		</div>
		
		<div class="col">
		<div class="row right-distance">
		<div class="col">
		<h4>Pediatric-Cancers</h4>
		</div>
		</div>
		
		<div class="row right-distance">
		<div id="all_Pdatasets" class="" >		
		<div class="col-12">
		<h3 class="font-color"> <span style="">2 datasets</span></h3>
		<h3 class="font-color"> <span style="">31 Cell types</span></h3>
		</div>		
		</div>
		
		<%for(int i=0;i<5;i++){ %>
		<div id="<%=cancer_pedia_class.get(i)%>_Fresour" class="" style="display:none;">
		<div class="col-12">
		<h3 class="font-color"><%=cancer_pedia_resource.get(i) %> resource</h3>
		<h3 class="font-color"><%=cancer_pedia_celltype.get(i) %> Cell types</h3>
		</div>
		</div>
		<%} %>
		
		</div>		
		
		<div id="pedia_cancers">		
		<div class="card card-body contain-scroll" style="float: right;">
		<% for(int i=0;i<5;i++){
		String end_tissue = cancer_pedia_tissue.get(i).replace("Pediatric_","");
		String end_tissue1 = end_tissue.replace("NA_","");
		String end_tissue2 = end_tissue1.replace("_"," ");
		String end_tissue3 = end_tissue2.replace("snRNA","");
		%>
		<div class="btn-group">
  		<button onMouseOut="hideImg5('<%=cancer_pedia_class.get(i) %>')" onmouseover="showImg5('<%=cancer_pedia_class.get(i) %>')" onclick="window.location.href='index_re.jsp?type=cancer_pedia&tissue=<%=cancer_pedia_tissue.get(i) %>'" type="button" class="btn btn-light">
    	<b><%=end_tissue3 %></b>
  		</button>
  		
		</div>
		<div class="row"></div>		
		<%} %>
		</div>
		</div>
		</div>
		
		</div>
  		</div>
		</div>	
		</div>
		
		
		</div>
		
		<div style="height:25px;"></div>
		
		<div class="container-fluid">
			<div class="heading">
				<h2><a class="font-color">Link of other related database</a></h2>
				<hr>
			</div>
			<div class="content">
			<!-- link of other related database  start -->
			<div id="yjiee" class="container-link col-lg-12">
			<ul class="row ul-size">
				<li class="li-pad">
					<a target="_blank" href="https://db.cngb.org/HCL/">
					<img src="images/database/hcl.png"></img>
					<span style="width:306px"></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="https://tabula-sapiens-portal.ds.czbiohub.org/">
					<img src="images/database/tts.png"></img>
					<span></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="http://tisch.comp-genomics.org/">
					<img src="images/database/tisch.png"></img>
					<span></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="http://bio-bigdata.hrbmu.edu.cn/lnc2cancer/">
					<img src="images/database/lnc2cancer.png"></img>
					<span></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="https://commonfund.nih.gov/GTEx/">
					<img src="images/database/gtex.png"></img>
					<span></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="https://data.humancellatlas.org/">
					<img src="images/database/hca.png"></img>
					<span></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="https://slidebase.binf.ku.dk/human_enhancers/">
					<img src="images/database/fantom.png"></img>
					<span></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="http://bio-bigdata.hrbmu.edu.cn/CellMarker/">
					<img src="images/database/cellmarker.png"></img>
					<span></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="http://bio-bigdata.hrbmu.edu.cn/ImmCluster/index.jsp">
					<img src="images/database/immcluster.png"></img>
					<span></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="https://bioinfo.uth.edu/scrnaseqdb/">
					<img src="images/database/scrnaseqdb.png"></img>
					<span></span>
					</a>
				</li>
				<li class="li-pad">
					<a target="_blank" href="http://bio-bigdata.hrbmu.edu.cn/LnCeCell/">
					<img src="images/database/lncecell.png"></img>
					<span></span>
					</a>
				</li>
			</ul>
			</div>
<!-- link of other related database  end -->
			</div>
		</div>
	</div>
</section>
<script>
//滚动
$(document).ready(function () {
	var box = $("#yjiee")//滚动对象
	var v0 = 0.8 //滚动对象的速率
    Run(box, v0);
	
	function Run($Box, v) {
        var $Box_ul = $Box.find("ul"),
            $Box_li = $Box_ul.find("li"),
            $Box_li_span = $Box_li.find("span"),
            left = 0,
            s = 0,
            timer;//定时器

        $Box_li.each(function (index) {
            $($Box_li_span[index]).width($(this).width());//hover
            s += $(this).outerWidth(true); //滚动的长度
        })
        window.requestAnimationFrame = window.requestAnimationFrame || function (Tmove) { return setTimeout(Tmove, 1000 / 60) };
        window.cancelAnimationFrame = window.cancelAnimationFrame || clearTimeout;

        if (s >= $Box.width()) {//如果滚动长度超出Box长度即开始滚动，没有的话就不执行滚动
            $Box_li.clone(true).appendTo($Box_ul);
            Tmove();
            function Tmove() {
                //运动是移动left  从0到-s;
                left -= v;
                if (left <= -s) { left = 0; $Box_ul.css("left", left) } else { $Box_ul.css("left", left) }
                timer = requestAnimationFrame(Tmove);
            }
            $Box_ul.hover(function () { cancelAnimationFrame(timer) }, function () { Tmove() })
        }
    }	
});
</script>

<!--------------Footer--------------->
<footer>
	<div class="zerogrid">
		<div class="row wrapper">			
			<div id="copyright">
			<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University </p>
			<script type="text/javascript" src="//rf.revolvermaps.com/0/0/3.js?i=5p3dz1q3wvm&amp;b=5&amp;s=0&amp;m=2&amp;cl=ffffff&amp;co=010020&amp;cd=aa0000&amp;v0=60&amp;v1=60&amp;r=1" async="async"></script>
			</div>
		</div>
	</div>
	
	
</footer>
<%
db.close();
%>
</body>
</html>