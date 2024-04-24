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
</head>
<style>
.font-color{
	color:#8064A2;
}
.row-distance{
	margin-top: 36px;
	margin-bottom: 36px;
}
table.dataTable thead th, table.dataTable thead td {
    border-bottom: 1px solid #000;
    border-top: 1px #000 solid;
}
</style>
<body>
<%
DBConn2 db = new DBConn2();							
ResultSet rs;
db.open();
String sel="";

HashMap<String,String> cancer_clas = new HashMap<String,String>();
sel = "select distinct cancer_name,class from index_cancer";
rs = db.execute(sel); 
while(rs.next()){
	cancer_clas.put(rs.getString("cancer_name"),rs.getString("class"));
}

HashMap<String,String> hash_resource = new HashMap<String,String>();
hash_resource.put("hcl","Human Cell Landscape");
hash_resource.put("tts","The Tabula Sapiens");
hash_resource.put("other","GSE140819");
hash_resource.put("cell_res","Qian et al., Cell Research 2020");
hash_resource.put("tica","TICA");
hash_resource.put("epn","GSE125969");
%>
<%
String ID=request.getParameter("sigcell_lncrna");
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
		<div class="container-fluid">
		<div class="heading">
			<h3><a class="font-color">Table of results based on lncRNA queries</a></h3>
			<hr>
		</div>
		<div class="content" style="height: 581px;">
			<div>
			<table id="Table_body" class="display nowrap table" cellspacing="0" style="width: 100%;">
							<thead style="text-align:center">
							<tr>
								<th><div style="text-align:center">Name</div></th>
								<th><div style="text-align:center">ID</div></th>
								<th><div style="text-align:center">Source</div></th>
								<!--  
								<th><div style="text-align:center">Chromosome</div></th>
								<th><div style="text-align:center">Start</div></th>
								<th><div style="text-align:center">End</div></th>
								<th><div style="text-align:center">Strand</div></th>
								-->
								<th><div style="text-align:center">Biotype</div></th>
								<th><div style="text-align:center">Classification</div></th>
								<th><div style="text-align:center">Tissue</div></th>
								<th><div style="text-align:center">Cell</div></th>
								<th><div style="text-align:center">Details</div></th>
							</tr>
							</thead>
							<%
         
         String rs_a="";
         String rs_t="";         
         String id="";
         int n=0;  //n is tissue number of integration
         String[] integration_tissue;
         String[] source = {"hcl","tts","tica","cell_res","other","epn","geo","tiger"};
         
        /* if(ID.indexOf("ENSG")==-1){
        	 db.open();
        	 sel="select ID from nametoid where name = '"+ID+"'";
        	 rs=db.execute(sel);
        	 while(rs.next()){
        		 ID=rs.getString("ID");
        	 }
        	 db.close();
         }*/
        
        try{
        	for(String i:source){        	
        	 sel="select * from "+i+"_basic where gene_name = '"+ID+"' or ensembl_gene_id = '"+ID+"' ";
        	 rs=db.execute(sel);
		while(rs.next()){
			rs_a=rs.getString("classification");
			rs_t=rs.getString("tissue");
			if(!(rs_t.equals("-"))){
					out.println("<tr  class='single table_center'>");
		        	out.println("<td>"+rs.getString("gene_name")+"</td>");
		        	out.println("<td>"+rs.getString("ensembl_gene_id")+"</td>");  
		        	if(i.equals("geo")||i.equals("tiger")){
		        		out.println("<td>"+rs.getString("dataset")+"</td>");
		        	}else{    		
		        		out.println("<td>"+hash_resource.get(i)+"</td>");
		        	}
		        	/*
		        	out.println("<td>"+rs.getString("seqnames")+"</td>");
		        	out.println("<td>"+rs.getString("start")+"</td>");
		        	out.println("<td>"+rs.getString("end")+"</td>");
		       		out.println("<td>"+rs.getString("strand")+"</td>");
		       		*/
		       		out.println("<td>"+rs.getString("gene_type")+"</td>");
		       		//classification
		        	out.println("<td>"+rs_a+"</td>");
		       		//tissue
		        	if(i.equals("hcl")&&rs.getString("source").equals("fetal")){
		        		out.println("<td>"+"Fetal-"+((rs_t.replace("NA_","")).replace("_"," ")).replace("-"," ")+"</td>");
		        	}else{
		        		out.println("<td>"+((rs_t.replace("NA_","")).replace("_"," ")).replace("-"," ")+"</td>");
		        	}		       		
		       		//新加一个cell type
		       		out.println("<td>"+rs.getString("cell_fullname")+"</td>");
		       		//details
		        	String a_f = rs.getString("source");
		        	out.println("<td>");
		       		if((i.equals("hcl")&&a_f.equals("adult"))||i.equals("tts")||i.equals("tica")){//正常成人
						out.println("<a href=\"re_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
					}else if((i.equals("hcl")&&a_f.equals("fetal"))){//正常胎儿
						out.println("<a href=\"fetal_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
					}else if(i.equals("epn")||(i.equals("other")&&a_f.equals("fetal"))){//癌症儿童
						out.println("<a href=\"pedia_details.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
					}else if(i.equals("cell_res")||(i.equals("other")&&a_f.equals("adult"))){//癌症成人
						out.println("<a href=\"re_details.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"&broad="+cancer_clas.get(rs_t)+"\">"+"<img src='images/book_copy.jpg'></a>");
					}else{//tisch和tiger的癌症成人
						out.println("<a href=\"re_Gdetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+rs.getString("dataset")+"="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"&broad="+cancer_clas.get(rs_t)+"\">"+"<img src='images/book_copy.jpg'></a>");
					}
		       		out.println("</td>");		       		
		        	out.println("</tr>");
			}
		}
        	}
        	db.close();
}catch(Exception e){e.printStackTrace();}
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
			
	    	});
	} );
</script>

<!--------------Footer--------------->
<footer>		
	<div id="copyright">
	<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University</p>
	</div>
</footer>
</body>
</html>