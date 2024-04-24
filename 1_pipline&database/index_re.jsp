<%@page import="org.apache.jasper.tagplugins.jstl.core.Out"%>
<%@ page import="java.sql.*" import="java.util.*" language="java"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.*"%>
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
<script src="jquery-ui-1.13.2/jquery-3.5.1.js" ></script>
<!-- jQuery and JavaScript Bundle with Popper -->
<script src="Bootstrap/jquery.slim.js"></script>
<script src="Bootstrap/bootstrap.bundle.min.js"></script>
<script src="js/iconify.min.js"></script>
<!-- datatable -->
<link rel="stylesheet" type="text/css" href="datatable/jquery.dataTables.min.css">
<script type="text/javascript" charset="utf8" src="datatable/jquery.dataTables.min.js"></script>
<!-- datatable button -->
<link href="datatable/jquery.dataTables.css" rel="stylesheet" >
<link href="datatable/dataTables.bootstrap4.min.css" rel="stylesheet">
<link href="datatable/buttons.dataTables.min.css" rel="stylesheet">
<script type="text/javascript" charset="utf8" src="datatable/jquery.dataTables.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/dataTables.buttons.min.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/jszip.min.js"></script>

<script type="text/javascript" charset="utf8" src="datatable/vfs_fonts.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/buttons.html5.min.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/buttons.print.min.js"></script>
</head>
<style>
.font-color{
	color:#8064A2;
}
.row-distance{
	margin-top: 36px;
	margin-bottom: 36px;
}
</style>
<body>
<%
HashMap<String,String> hash_resource = new HashMap<String,String>();
hash_resource.put("hcl","Human Cell Landscape");
hash_resource.put("tts","The Tabula Sapiens");
hash_resource.put("other","GSE140819");
hash_resource.put("cell_res","Qian et al., Cell Research 2020");
hash_resource.put("tica","TICA");
hash_resource.put("epn","GSE125969");
%>
<%
DBConn2 db = new DBConn2();							
ResultSet rs;
String sel="";
db.open();

HashMap<String,String> cancer_clas = new HashMap<String,String>();
sel = "select distinct cancer_name,class from index_cancer";
rs = db.execute(sel); 
while(rs.next()){
	cancer_clas.put(rs.getString("cancer_name"),rs.getString("class"));
}

/*获取上页所有参数*/
String type = request.getParameter("type");
String tissue = request.getParameter("tissue");
%>
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
<section id="content"  class="row-distance">
	<div class="zerogrid">
		<div style="height:25px;"></div>
		<div class="container-fluid">
		<div class="heading">
			<h3><a class="font-color">Table of results</a></h3>
			<hr>
		</div>
		<div class="content" style="height: 581px;">
			<div>
			<table id="Table_body" class="display" cellspacing="0" style="width: 100%;">
							<thead style="text-align:left">
							<tr>
								<th><div style="text-align:left">Name</div></th>
								<th><div style="text-align:left">ID</div></th>
								<th><div style="text-align:left">Source</div></th>
								<!--  
								<th><div style="text-align:left">Chromosome</div></th>
								<th><div style="text-align:left">Start</div></th>
								<th><div style="text-align:left">End</div></th>
								<th><div style="text-align:left">Strand</div></th>
								-->
								<th><div style="text-align:left">Biotype</div></th>
								<th><div style="text-align:left">Classification</div></th>
								<th><div style="text-align:left">Tissue</div></th>
								<th><div style="text-align:left">Cell</div></th>
								<th><div style="text-align:left">Details</div></th>
							</tr>
							</thead>
<%
if(type.equals("normal_adult")){
	String[] source = {"hcl","tts","tica"};
	for(int i=0;i<3;i++){
		sel="select * from "+source[i]+"_basic where tissue = '"+tissue+"' and source='adult' ";
   	 	rs=db.execute(sel);
   	 	while(rs.next()){
 			out.println("<tr>");
 			out.println("<td>"+rs.getString("gene_name")+"</td>");
 			out.println("<td>"+rs.getString("ensembl_gene_id")+"</td>"); 
 			out.println("<td>"+hash_resource.get(source[i])+"</td>");
 			/*
 			out.println("<td>"+rs.getString("seqnames")+"</td>");
 			out.println("<td>"+rs.getString("start")+"</td>");
 			out.println("<td>"+rs.getString("end")+"</td>");
 			out.println("<td>"+rs.getString("strand")+"</td>");
 			*/
 			out.println("<td>"+rs.getString("gene_type")+"</td>");
 			out.println("<td>"+rs.getString("classification")+"</td>");
 			out.println("<td>"+rs.getString("tissue")+"</td>");
 			out.println("<td>"+rs.getString("cell_fullname")+"</td>");
 			out.println("<td>");
 			out.println("<a href=\"re_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source[i]+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
 			out.println("</td>");
 			out.println("</tr>");
 	}
	}
}else if(type.equals("normal_fetal")){
	sel="select * from hcl_basic where tissue='"+tissue+"' and source='fetal' ";
	rs=db.execute(sel);
	while(rs.next()){
		out.println("<tr>");
		out.println("<td>"+rs.getString("gene_name")+"</td>");
		out.println("<td>"+rs.getString("ensembl_gene_id")+"</td>"); 
		out.println("<td>"+hash_resource.get("hcl")+"</td>");
		/*
		out.println("<td>"+rs.getString("seqnames")+"</td>");
		out.println("<td>"+rs.getString("start")+"</td>");
		out.println("<td>"+rs.getString("end")+"</td>");
		out.println("<td>"+rs.getString("strand")+"</td>");
		*/
		out.println("<td>"+rs.getString("gene_type")+"</td>");
		out.println("<td>"+rs.getString("classification")+"</td>");
		out.println("<td>"+rs.getString("tissue")+"</td>");
		out.println("<td>"+rs.getString("cell_fullname")+"</td>");
		out.println("<td>");
		out.println("<a href=\"fetal_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource=hcl&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
		out.println("</td>");
		out.println("</tr>");
	}
}else if(type.equals("cancer_adult")){
	
	String[] source = {"cell_res","other","epn","geo","tiger"};
	for(int i=0;i<5;i++){
		sel="select * from "+source[i]+"_basic where tissue = '"+tissue+"' and source='adult' ";
		rs=db.execute(sel);
		while(rs.next()){
   	 	String tissue_na = rs.getString("tissue");
		out.println("<tr>");
		out.println("<td>"+rs.getString("gene_name")+"</td>");
		out.println("<td>"+rs.getString("ensembl_gene_id")+"</td>"); 
		if(source[i].equals("geo")||source[i].equals("tiger")){
    		out.println("<td>"+rs.getString("dataset")+"</td>");
    	}else{    		
    		out.println("<td>"+hash_resource.get(source[i])+"</td>");
    	}
		/*
		out.println("<td>"+rs.getString("seqnames")+"</td>");
		out.println("<td>"+rs.getString("start")+"</td>");
		out.println("<td>"+rs.getString("end")+"</td>");
		out.println("<td>"+rs.getString("strand")+"</td>");
		*/
		out.println("<td>"+rs.getString("gene_type")+"</td>");
		out.println("<td>"+rs.getString("classification")+"</td>");
		out.println("<td>"+tissue_na+"</td>");
		out.println("<td>"+rs.getString("cell_fullname")+"</td>");
		out.println("<td>");
		if(source[i].equals("cell_res")||(source[i].equals("other"))){//癌症成人
			out.println("<a href=\"re_details.jsp?value1=0.5&tissue="+tissue_na+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source[i]+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"&broad="+cancer_clas.get(tissue_na)+"\">"+"<img src='images/book_copy.jpg'></a>");
		}else{//tisch和tiger的癌症成人
			out.println("<a href=\"re_Gdetails.jsp?value1=0.5&tissue="+tissue_na+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+rs.getString("dataset")+"="+source[i]+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"&broad="+cancer_clas.get(tissue_na)+"\">"+"<img src='images/book_copy.jpg'></a>");
		}
		out.println("</td>");
		out.println("</tr>");
	}
	}
	
}else if(type.equals("cancer_pedia")){
	String[] source = {"epn","other"};
	for(int i=0;i<2;i++){
		sel="select * from "+source[i]+"_basic where tissue = '"+tissue+"' and source='fetal' ";
   	 	rs=db.execute(sel);
   	 	while(rs.next()){
   	 		out.println("<tr>");
			out.println("<td>"+rs.getString("gene_name")+"</td>");
			out.println("<td>"+rs.getString("ensembl_gene_id")+"</td>"); 
			out.println("<td>"+hash_resource.get(source[i])+"</td>");
			/*
			out.println("<td>"+rs.getString("seqnames")+"</td>");
			out.println("<td>"+rs.getString("start")+"</td>");
			out.println("<td>"+rs.getString("end")+"</td>");
			out.println("<td>"+rs.getString("strand")+"</td>");
			*/
			out.println("<td>"+rs.getString("gene_type")+"</td>");
			out.println("<td>"+rs.getString("classification")+"</td>");
			out.println("<td>"+rs.getString("tissue")+"</td>");
			out.println("<td>"+rs.getString("cell_fullname")+"</td>");
			out.println("<td>");
			out.println("<a href=\"pedia_details.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source[i]+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
			out.println("</td>");
			out.println("</tr>");
   	 	}
	}	
}
%>
						</table>
						</div>
		</div>
		</div>
	</div>
</section>
<script type="text/javascript">
	$(document).ready(function() {
		$('#Table_body').DataTable({
			"filter":true,
			dom: 'Bfrtip',
			buttons: [
			{extend:'csv',exportOptions:  {columns:[0,1,2,3,4]}},
			{extend:'excel',exportOptions:{columns:[0,1,2,3,4]}},
			//{extend:'pdf',exportOptions:  {columns: [0,1,2,3,4]}}
			]
	    	});
	} );
</script>
<%
db.close();
%>			
<!--------------Footer--------------->
<footer>		
	<div id="copyright">
	<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University </p>
	
</div>
</footer>

</body>
</html>