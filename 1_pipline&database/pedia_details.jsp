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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
<link href='./images/favicon.ico' rel='icon' type='image/x-icon'/>	
<script src="js/jquery.min.js"></script>
<script src="js/responsiveslides.js"></script>
<!-- my css js -->
<!-- CSS -->
<link href="Bootstrap/bootstrap.min.css" rel="stylesheet">
<!-- jQuery and JavaScript Bundle with Popper -->
<script src="Bootstrap/jquery.slim.js"></script>
<script src="Bootstrap/bootstrap.bundle.min.js"></script>
<!-- datatable -->
<script src="jquery-ui-1.13.2/jquery-3.5.1.js" ></script>
<link rel="stylesheet" type="text/css" href="datatable/jquery.dataTables.min.css">
<script type="text/javascript" charset="utf8" src="datatable/jquery.dataTables.min.js"></script>
<!-- my -->
<script src="js/iconify.min.js"></script>
</head>
<style>
.h6, h6 {
    font-size: 21px;
    line-height:2.5;
}
</style>
<script>
//导航栏定位
$(document).ready(function () {
		var scTop=0;//初始化垂直滚动的距离
		var menuYloc = $("#floatMenu").offset().top;//获取到距离顶部的垂直距离		
	    $(window).scroll(function () {
	    	scTop=$(this).scrollTop();//获取到滚动条拉动的距离
	    	
	    	if(scTop>=menuYloc){
	    		//核心部分：当滚动条拉动的距离大于等于导航栏距离顶部的距离时，添加指定的样式
	    		var offsetTop=$(window).scrollTop()-20 + "px";
	    		$("#floatMenu").animate({ top: offsetTop }, { duration: 0, queue: false });
	    	}else{
	    		var offsetTop = menuYloc + "px";
	            $("#floatMenu").animate({ top: offsetTop }, { duration:0, queue: false });
	    	}
	    });
	});
</script>
<%
DBConn db1 = new DBConn();
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;

String ID = request.getParameter("Name");
String location="";
String type="";
String rs_a  = request.getParameter("classification");
String rs_t = "";
String cancer = "";
String resource = request.getParameter("resource");
String NODE=""; //gene的名字
String cell=request.getParameter("celltype");
String rs_c="";
String tissue_pd = "";//tissue_pd用于网络图进行判断是否是组织特异,同时用于判断癌症放到前面
String cell_pd = cell;
String tissue_pd4="";
String a_f="fetal";
tissue_pd4 = request.getParameter("tissue");
tissue_pd = tissue_pd4;

//查询tissue_pd对应的组织
String pd_tiss="";
db.open();
sel = "select tissue from cancer_tissue where cancer ='" + tissue_pd + "' ";
rs = db.execute(sel);
while(rs.next()){
	String tt=rs.getString("tissue");
	if(tt.equals("none")){}else{
		pd_tiss=tt;
	}
}
rs.close();
db.close();
%>
<%
//basic
db.open();
sel = "select * from "+resource+"_basic where ensembl_gene_id ='" + ID + "' and source='"+a_f+"'" ;
rs=db.execute(sel); 
while(rs.next()){
	NODE=rs.getString("gene_name");//gene的名字
    location=rs.getString("seqnames")+","+rs.getString("start")+"-"+rs.getString("end")+","+rs.getString("strand");
    type=rs.getString("gene_type");
    rs_a=rs.getString("classification");
}
rs.close();
db.close();
%>
<%
/*normal*/
List<String> tempsournor = new ArrayList<String>();
List<String> intesournor = new ArrayList<String>();
List<String> allsour = new ArrayList<String>();
String[] allnorsour={"hcl"};
for(String ou : allnorsour){
	List<String> integra_cell = new ArrayList<String>();
	List<String> integra_tiss = new ArrayList<String>();
	db.open();
	sel = "select * from "+ou+"_basic where ensembl_gene_id ='" + ID + "' and source='"+a_f+"'";
	rs = db.execute(sel); 
	rs.beforeFirst();
	while(rs.next()){
		allsour.add(ou);
		integra_cell.add(rs.getString("cell_fullname"));
		integra_tiss.add(rs.getString("tissue"));
	}
	rs.close();
	db.close();
	if(integra_cell.size()>0){
		//存储组织+资源，并且把cell_pd放前面								
		for(int j=0;j<integra_cell.size();j++){
			if(integra_cell.get(j).equals(cell)){
				intesournor.add(integra_tiss.get(j)+"="+ou);
			}else{
				tempsournor.add(integra_tiss.get(j)+"="+ou);
			}			
		}													
	}
}
//按照首字母排序
Collections.sort(tempsournor);
//汇总组织+资源
for(int j=0;j<tempsournor.size();j++){
	intesournor.add(tempsournor.get(j));
}
//去重组织+资源
	List<String> intesour_uniqnor = new ArrayList<String>();
	for(int j=0;j<intesournor.size();j++){
		if(!intesour_uniqnor.contains(intesournor.get(j))){
			intesour_uniqnor.add(intesournor.get(j));
		}
	}
%>
<%
HashMap<String,String> hash_resource = new HashMap<String,String>();
hash_resource.put("hcl","Human Cell Landscape");
hash_resource.put("tts","The Tabula Sapiens");
hash_resource.put("other","GSE140819");
hash_resource.put("cell_res","Qian et al., Cell Research 2020");
hash_resource.put("tica","TICA");
hash_resource.put("epn","GSE125969");

HashMap<String,String> cancer_fullname = new HashMap<String,String>();
cancer_fullname.put("AEL","Acute erythroid leukemia");
cancer_fullname.put("ALL","Acute lymphoblastic leukemia");
cancer_fullname.put("AML","Acute myeloid leukemia");
cancer_fullname.put("BCC", "Basal cell carcinoma");
cancer_fullname.put("BLCA","Bladder cancer");
cancer_fullname.put("BRCA","Breast cancer");
cancer_fullname.put("CHOL","Cholangiocarcinoma");
cancer_fullname.put("Chronic lymphocytic leukemia_NA_scRNA","NONE");
cancer_fullname.put("CLL","Chronic lymphocytic leukemia");
cancer_fullname.put("COAD","Colon adenocarcinoma");
cancer_fullname.put("CRC","Colorectal cancer");
cancer_fullname.put("Ependymoma","NONE");
cancer_fullname.put("GBM","Glioblastoma");
cancer_fullname.put("Glioblastoma_NA_scRNA","Glioblastoma");
cancer_fullname.put("Glioma","Glioma");
cancer_fullname.put("HNSCC","Head and neck squamous cell carcinoma");
cancer_fullname.put("Pediatric_high-grade glioma_NA_snRNA","NONE");
cancer_fullname.put("KIRC","Kidney renal clear cell carcinoma");
cancer_fullname.put("LICA","Liver cancer");
cancer_fullname.put("LIHC","Liver hepatocellular carcinoma");
cancer_fullname.put("LUAD_and_LUSC","Lung adenocarcinoma and lung squamous cell carcinoma");
cancer_fullname.put("Melanoma","Melanoma");
cancer_fullname.put("Melanoma_NA_snRNA","Melanoma");
cancer_fullname.put("MCC","Merkel cell carcinoma");
cancer_fullname.put("Metastatic breast cancer_brain metastatic_snRNA","NONE");
cancer_fullname.put("Metastatic breast cancer_liver metastases_scRNA","NONE");
cancer_fullname.put("Metastatic breast cancer_liver metastases_snRNA","NONE");
cancer_fullname.put("Metastatic breast cancer_lymph node metastases_scRNA","NONE");
cancer_fullname.put("MM","Multiple myeloma");
cancer_fullname.put("Pediatric_Neuroblastoma_NA_snRNA","NONE");
cancer_fullname.put("NET","Neuroendocrine tumor");
cancer_fullname.put("NHL","Non Hodgkins lymphoma");
cancer_fullname.put("NSCLC","Non small cell lung cancer");
cancer_fullname.put("non-small cell lung carcinoma_NA_scRNA","NONE");
cancer_fullname.put("OV","Ovarian cancer");
cancer_fullname.put("Ovarian_NA_scRNA","Ovarian cancer");
cancer_fullname.put("Ovarian_NA_snRNA","Ovarian cancer");
cancer_fullname.put("PAAD","Pancreatic ductal adenocarcinomas");
cancer_fullname.put("Pediatric_Sarcoma_rhabdomyosarcoma_snRNA","NONE");
cancer_fullname.put("Pediatric_Sarcoma_NA_snRNA","Sarcoma");
cancer_fullname.put("SKCM","Skin cutaneous melanoma");
cancer_fullname.put("SCC","Squamous cell carcinoma");
cancer_fullname.put("UVM","Uveal melanoma");
%>
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

<div id="main-page">
<div class="detail-head">
<div id="floatMenu" style="top:156px;">
<div class="container-fluid">
<div class="row">
<div class="col">
	<a href = "#floatMenu1"><button type="button" class="btn button-color font-weight-bold">Basic information</button></a>
</div>
<div class="col">
	<a href = "#floatMenu2"><button type="button" class="btn button-color font-weight-bold" style="width:368px;">Spatial pattern in pediatric cancers</button></a>
</div>
<div class="col">
	<%if(allsour.size()>0) {%>
	<a href = "#floatMenu3"><button type="button" class="btn button-color font-weight-bold">Spatial pattern in fetal normal tissues</button></a>
	<%} %>
</div>
<div class="col">
	<a href = "#floatMenu4"><button type="button" class="btn button-color font-weight-bold">LncRNA-mRNA</button></a>
</div>
</div>

<div style="height:10px;"></div>

<div class="row">
<div class="col">
	<a href = "#floatMenu5"><button type="button" class="btn button-color font-weight-bold">Function</button></a>
</div>
<div class="col">
	<a href = "#floatMenu6"><button type="button" class="btn button-color font-weight-bold">External links</button></a>
</div>
<div class="col">
	<a href = "#floatMenu7"><button type="button" class="btn button-color font-weight-bold">Differential expression analysis</button></a>
</div>
<div class="col">
	<a href = "#floatMenu8"><button type="button" class="btn button-color font-weight-bold">Survival analysis</button></a>
</div>
</div>
</div>							
</div>
</div>
<!-- floatmenu 菜单栏 start -->
<section id="content" style="margin-top: 143px;">
		<div class="container">			
			<div class="row justify-content-md-center">
				<h2><a class="font-color">The detailed information Page of <span style="color:#f11010"><%= NODE %></span></b></a></h2>
			</div>
		</div>
</section>

<section id="lyj" style="margin-top: 20px;">
<div class="zerogrid">
<div class="container-fluid">
<div class="sidebar">
	<section id="floatMenu1">				
			<div class="heading">
				<h3><a class="font-color">Basic information</a></h3>
			</div>
			<div class="card card-body content">
			<div class="container">
  				<div class="row detail-row2">
				<div class="col detail-col1"><h6>Cancer tissue</h6></div>
				<div class="col detail-col2">
				<span class="bastable-font">
				<%
				String can_ful = cancer_fullname.get(tissue_pd4);
				if(can_ful.equals("NONE")){
					out.println(tissue_pd4.replace("_"," "));
				}else{
					out.println(tissue_pd4+" ("+can_ful+")");
				}
				%>
				</span>
				</div>
				</div>
				
				<div class="row detail-row2">
				<div class="col detail-col1"><h6>Dataset</h6></div>
				<div class="col detail-col2"><span class="bastable-font"><%=hash_resource.get(resource) %></span></div>
				</div>
			
				<div class="row detail-row2">
				<div class="col detail-col1"><h6>Cell type</h6></div>
				<div class="col detail-col2"><span class="bastable-font"><%=cell_pd %></span></div>
				</div>
					
				<div class="row detail-row2">
				<div class="col detail-col1"><h6>Name</h6></div>
				<div class="col detail-col2"><span class="bastable-font"><%=NODE %></span></div>
				</div>	
				
				<div class="row detail-row2">
				<div class="col detail-col1"><h6>ID</h6></div>
				<div class="col detail-col2"><span class="bastable-font"><a href="http://grch37.ensembl.org/Multi/Search/Results?q=<%=ID %>"><%=ID %></a></span></div>
				</div>
					
				<div class="row detail-row2">
				<div class="col detail-col1"><h6>Location</h6></div>
				<div class="col detail-col2"><span class="bastable-font"><%=location %></span></div>
				</div>
				
				<div class="row detail-row2">
				<div class="col detail-col1"><h6>Type</h6></div>
				<div class="col detail-col2"><span class="bastable-font"><%=type %></span></div>
				</div>
				
				<div class="row detail-row2">
				<div class="col detail-col1"><h6>Annotation</h6></div>
				<div class="col detail-col2">
				<span class="bastable-font">
				<a target="_blank" href="http://bio-bigdata.hrbmu.edu.cn/ImmReg/quick_search_details.jsp?database_name=quichsearch_cell&q_s_k=<%=NODE%>">ImmReg</a> ;
				<a target="_blank" href="http://bio-bigdata.hrbmu.edu.cn/TransLnc/search_lncRNA_re.jsp?species=Human&lncRNA=<%=NODE%>">TransLnc</a> ; 
				<a target="_blank" href="http://bio-bigdata.hrbmu.edu.cn/LncSpA/search_lncrna.jsp?showPage=1&lncrna=<%=NODE%>">LncSpA</a>
				</span>
				</div>
				</div>
					
			</div>
													
			</div>
	</section>
	
<section id="floatMenu2">				
<div class="heading">
<h3><a class="font-color">Spatial pattern in pediatric cancers</a></h3>
</div>
<div class="content card card-body" style="height: 2029px;">
<iframe id="pedia_cancer" name="pedia_cancer" src="pedia_cancer.jsp?value1=0.5&tissue=<%=tissue_pd%>&mRNA_tissue=&Name=<%=ID %>&classification=<%=rs_a %>&resource=<%=resource %>&celltype=<%=cell%>&NODE=<%=NODE %>" style="width: 100%; height: 100%; margin: 0 auto; position: relative;" frameborder="0" scrolling="hidden"></iframe>		
</div>
</section>

<%
//判断normal_resource里面有没有lnc
if(allsour.size()>0){
%>
<section id="floatMenu3">				
<div class="heading">
<h3><a class="font-color">Spatial pattern in fetal normal tissues</a></h3>
</div>
<div class="content card card-body" style="height: 1000px;">
<iframe id="pedia_tissue" name="pedia_tissue" src="pedia_tissue.jsp?value1=0.5&tissue=<%=tissue_pd%>&mRNA_tissue=&Name=<%=ID %>&classification=<%=rs_a %>&resource=<%=resource %>&celltype=<%=cell%>&NODE=<%=NODE %>" style="width: 100%; height: 100%; margin: 0 auto; position: relative;" frameborder="0" scrolling="hidden"></iframe>		
</div>
</section>	
<%}else{ %>
<section id="floatMenu3">				
<div class="heading">
<h3><a class="font-color">Spatial pattern in fetal normal tissues</a></h3>
</div>
<div class="content card card-body">
<h3>No result!</h3>
</div>
</section>	
<%} %>

<section id="floatMenu4">				
<div style="height: 1000px;">
<iframe id="lnc_mrna" name="lnc_mrna" src="tmp_Plncmrna.jsp?value1=0.5&tissue=<%=tissue_pd%>&mRNA_tissue=&Name=<%=ID %>&classification=<%=rs_a %>&resource=<%=resource %>&celltype=<%=cell%>&NODE=<%=NODE %>" style="width: 100%; height: 100%; margin: 0 auto; position: relative;" frameborder="0" scrolling="hidden"></iframe>		
</div>
</section>

<section id="floatMenu6">				
<div class="heading">
<h3><a class="font-color">External links</a></h3>
</div>
<div class="content card card-body" style="height: 209px;">
<iframe id="externalLink" name="externalLink" src="ExternalLinks.jsp?value1=0.5&tissue=<%=tissue_pd%>&mRNA_tissue=&Name=<%=ID %>&classification=<%=rs_a %>&resource=<%=resource %>&celltype=<%=cell%>&chr=&NODE=<%=NODE %>" style="width: 100%; height: 100%; margin: 0 auto; position: relative;" frameborder="0" scrolling="hidden"></iframe>		
</div>
</section>

 
<div style="height:762px;">
<div class="row-distance"></div>
<iframe id="diffExp" name="diffExp" src="DiffExp.jsp?value1=0.5&tissue=<%=tissue_pd%>&mRNA_tissue=&Name=<%=ID %>&classification=<%=rs_a %>&resource=<%=resource %>&celltype=<%=cell%>&chr=&NODE=<%=NODE %>" style="width: 100%; height: 100%; margin: 0 auto; position: relative;" frameborder="0" scrolling="hidden"></iframe>
</div>

	
</div>
</div>
</div>
</section>

</div>

</body>
</html>