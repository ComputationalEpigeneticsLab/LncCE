<%@ page import="java.sql.*" import="java.util.*" import="download.*"
	language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

<title>LncCE</title>
</head>
<%
String source="";
String classification="";
String celltype = "";
String cancer = "";
String tissue = "";
String chr="";
String start="";
String end="";
String a_f="";
String tissue4="";
String gse="";
//int showPage;
//String sh = request.getParameter("showPage");
//showPage=Integer.parseInt(sh);
String broad_can = "";
if(request.getParameter("cancer_sig")==null||request.getParameter("cancer_sig")==""){
	
}else{
	broad_can = request.getParameter("cancer_sig");
}

	if(request.getParameter("source_sig")==null||request.getParameter("source_sig")==""){source="";}
	  else{
		  source=request.getParameter("source_sig");
	  }
		  
	if(request.getParameter("tissue_sig")==null||request.getParameter("tissue_sig")==""){tissue="";}
	else{ 
		tissue=request.getParameter("tissue_sig");
		tissue4 = tissue;
		  if(tissue.contains("Fetal-")){
			  tissue = tissue.split("Fetal-")[1];
			  a_f = "fetal";
		  }else{
			  tissue = tissue4;
			  a_f = "adult";
		  }
	}	  
	  
	if(request.getParameter("classification")==null||request.getParameter("classification")==""){classification="";}
	else{
		  classification=request.getParameter("classification");
	}
	 
	 if(request.getParameter("canc_dataset")==null||request.getParameter("canc_dataset")==""){
		 cancer="";
	 }else{		 		 
		 	cancer=request.getParameter("canc_dataset");			
		  	String temp[] = cancer.split("=");
		 	tissue4 = temp[0];
		  	source = temp[1];
		  	if(temp.length==3){
		  		gse = temp[2];
		  	}
			  if(cancer.contains("Pediatric")){
				  tissue=tissue4;;
				  a_f = "fetal";
			  }else if(source.equals("epn")){
				  tissue = tissue4;
				  a_f = "fetal";
			  }else{
				  tissue = tissue4;
				  a_f = "adult";
			  }
	 }
	  
	  if(request.getParameter("sigcell_type2")==null||request.getParameter("sigcell_type2")==""){celltype="";}
	  else{
		  celltype=request.getParameter("sigcell_type2");
	  }
%>
<%
/*鸡肋操作 start*/
if(source.equals("hcl")&&tissue.equals("Bone Marrow")){
	tissue = "Bone-Marrow";
}else if(source.equals("tts")&&tissue.equals("Bone Marrow")){
	tissue = "Bone_Marrow";
}else if(source.equals("tica")&&tissue.equals("Bone Marrow")){
	tissue = "Bone marrow";
}
if(source.equals("tica")&&tissue.equals("Lung")){
	tissue = "Lungs";
}
if(source.equals("hcl")&&tissue.equals("Sigmoid Colon")){
	tissue = "Sigmoid-Colon";
}else if(source.equals("tica")&&tissue.equals("Sigmoid Colon")){
	tissue = "Sigmoid colon";
}
if(source.equals("hcl")&&tissue.equals("Transverse Colon")){
	tissue = "Transverse-Colon";
}else if(source.equals("tica")&&tissue.equals("Transverse Colon")){
	tissue = "Transverse colon";
}
if(source.equals("tica")&&tissue.equals("Ileum")){
	tissue = "lleum";
}
/*鸡肋操作 end*/
%>
<% 
//查询
String sel="";
if(source.equals("cell_res")||source.equals("hcl")||source.equals("tica")||source.equals("epn")||source.equals("tts")){
if(classification==""){//没有分类
	if(celltype==""||celltype==null){
			sel="select * from "+source+"_basic where tissue = \""+tissue+"\" and source = \""+a_f+"\"";
	}else{
			sel="select * from "+source+"_basic where tissue = \""+tissue+"\" and source = \""+a_f+"\" and cell = \""+celltype+"\"";
	}	
}else{//有分类
	if(celltype!=""){
			sel="select * from "+source+"_basic where tissue = \""+tissue+"\" and source = \""+a_f+"\" and cell = \""+celltype+"\" and classification=\""+classification+"\"";
		}else{
			sel="select * from "+source+"_basic where tissue = \""+tissue+"\" and classification=\""+classification+"\"";
		}
}
}else if(source.equals("other")){//来源是other的可以直接根据组织区分成人和儿童
	if(classification==""){//没有分类
		if(celltype==""||celltype==null){
				sel="select * from "+source+"_basic where tissue = \""+tissue+"\"";
		}else{
				sel="select * from "+source+"_basic where tissue = \""+tissue+"\" and cell = \""+celltype+"\"";
		}
		
	}else{//有分类
		if(celltype!=""){
				sel="select * from "+source+"_basic where tissue = \""+tissue+"\" and cell = \""+celltype+"\" and classification=\""+classification+"\"";
			}else{
				sel="select * from "+source+"_basic where tissue = \""+tissue+"\" and classification=\""+classification+"\"";
			}
	}
}else{//来源是geo和tiger的，要根据dataset进行查询
	if(classification==""){//没有分类
			if(celltype!=""){
				sel="select * from "+gse+"_basic where tissue = \""+tissue+"\" and cell = \""+celltype+"\" and dataset=\""+source+"\"";
			}else{
				sel="select * from "+gse+"_basic where tissue = \""+tissue+"\" and dataset=\""+source+"\"";
			}
		
	}else{//有分类
			if(celltype!=""){
				sel="select * from "+gse+"_basic where tissue = \""+tissue+"\" and cell = \""+celltype+"\" and classification=\""+classification+"\" and dataset=\""+source+"\"";
			}else{
				sel="select * from "+gse+"_basic where tissue = \""+tissue+"\" and classification=\""+classification+"\" and dataset=\""+source+"\"";
			}
	}
}
//System.out.println(sel);
%>
<%
HashMap<String,String> hash_resource = new HashMap<String,String>();
hash_resource.put("hcl","Human Cell Landscape");
hash_resource.put("tts","The Tabula Sapiens");
hash_resource.put("other","GSE140819");
hash_resource.put("cell_res","Qian et al., Cell Research 2020");
hash_resource.put("tica","TICA");
hash_resource.put("epn","GSE125969");
//hash_resource.put("group","Vento-Tormo Group");
//hash_resource.put("nature","Nature_Medicine_GSE150728");
%>
<style>
.table th { 
    text-align: center;
    vertical-align: middle !important;
}
.font-color{
	color:#8064A2;
}
.row-distance{
	margin-top: 36px;
	margin-bottom: 36px;
}
table.dataTable thead th, table.dataTable thead td {
    border-bottom: 1px solid #f0f0f0;
    border-top: 1px #000 solid;
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

<section id="content" class="row-distance">
	<div class="zerogrid">
		<div class="container-fluid">
		<div class="heading">
			<h3>
			<a class="font-color">
			<!-- 
			<span class="iconify icon_position" data-icon="carbon:table-of-contents" style="color: rgba(19, 126, 217, 0.6);" data-width="36" data-height="36"></span>
      		-->
      			<%if(gse.equals("")){%>
      			Table of results based on tissue and cell type queries in <b><%=hash_resource.get(source) %></b>	
      			<%}else{%>
      			Table of results based on cancer and cell type queries in <b><%=source %></b>
      			<%} %>
			</a>
			</h3>
			<hr>
		</div>
		<div class="content" style="height: 581px;">
			<div>
				<table id="Table_body" class="display table" cellspacing="0" width="100%">
      			<thead style="text-align:center">
						<tr>
						<th style="text-align:center">Name</th>
						<th style="text-align:center">ID</th>
						<!-- 
						<th style="text-align:center">Chromosome</th>
						<th style="text-align:center">Start</th>
						<th style="text-align:center">End</th>
						<th style="text-align:center">Strand</th>
						 -->
						<th style="text-align:center">Biotype</th>
						<th style="text-align:center">Classfication</th>
						<th style="text-align:center">Cell</th>
						<%if(source.equals("hcl")||source.equals("tts")||source.equals("tica")){ %>
						<th style="text-align:center">Tissue</th>
						<%}else{ %>
						<th style="text-align:center">Cancer</th>
						<%} %>
						<th style="text-align:center">Details</th>
						</tr>
						<tr class="second">
            			<th style="text-align:center"></th>
            			<th style="text-align:center"></th>
            			<th style="text-align:center"></th>
            			<th style="text-align:center"></th>
            			<th style="text-align:center"></th>
           			 	<th style="text-align:center"></th>
           			 	<th style="text-align:center"></th>
          				</tr>
				</thead>
				<%
							DBConn2 db = new DBConn2();
							db.open();
						%>
						<%
							try {

								//返回可滚动的结果集  
								ResultSet rs = db.execute(sel);
								//将游标移到最后一行  
								/*rs.last();
								//获取最后一行的行号  
								int recordCount = rs.getRow();
								//System.out.println(recordCount);
								rs.first();
								if(rs.first()){
									out.println("<tbody>");
									out.println("<tr>");
									
									out.println("<td style='text-align:center'>");
									out.println(rs.getString("gene_name"));
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									out.println(rs.getString("ensembl_gene_id"));
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									out.println(rs.getString("seqnames"));
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									out.println(rs.getString("start"));
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									out.println(rs.getString("end"));
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									out.println(rs.getString("strand"));
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									out.println(rs.getString("gene_type"));
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									out.println(rs.getString("classification"));
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									out.println(rs.getString("cell_fullname"));
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									if(tissue4==null||tissue4==""||a_f=="adult"){
										out.println(rs.getString("tissue"));
									}else{
										out.println(tissue4);
									}						
									out.println("</td>");
									
									out.println("<td style='text-align:center'>");
									if((source.equals("hcl")&&a_f.equals("adult"))||source.equals("tts")||source.equals("tica")){//正常成人
										out.println("<a href=\"re_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
									}else if((source.equals("hcl")&&a_f.equals("fetal"))){//正常胎儿
										out.println("<a href=\"fetal_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
									}else if(source.equals("epn")||(source.equals("other")&&a_f.equals("fetal"))){//癌症儿童
										out.println("<a href=\"pedia_details.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue="+rs.getString("tissue")+"&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"&celltype="+rs.getString("cell_fullname")+"\">"+"<img src='images/book_copy.jpg'></a>");
									}else if(source.equals("cell_res")||(source.equals("other")&&a_f.equals("adult"))){//癌症成人
										out.println("<a href=\"re_details.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue="+rs.getString("tissue")+"&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"&celltype="+rs.getString("cell_fullname")+"\">"+"<img src='images/book_copy.jpg'></a>");
									}else{//tisch和tiger的癌症成人
										out.println("<a href=\"re_Gdetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue="+rs.getString("tissue")+"&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"="+gse+"&celltype="+rs.getString("cell_fullname")+"\">"+"<img src='images/book_copy.jpg'></a>");
									}
									out.println("</td>");
									
									out.println("</tr>");
								}*/
								%>							
							<%--
							if(source.equals("tts")&&tissue.equals("Lung")||celltype.equals("Neutrophil")){
							
							<tr>
							<td style='text-align:center'>LUCAT1</td>
							<td style='text-align:center'>ENSG00000248323</td>
							<td style='text-align:center'>lncRNA</td>
							<td style='text-align:center'>CER</td>
							<td style='text-align:center'>Neutrophil</td>
							<td style='text-align:center'>Lung</td>
							<td style='text-align:center'>
							
							out.println("<a href=\"re_Ndetails.jsp?value1=0.5&tissue=Lung&mRNA_tissue=&Name=ENSG00000248323&classification=CER&resource=tts&celltype=Neutrophil&chr=chr5\">"+"<img src='images/book_copy.jpg'></a>");
							
							</td>														
							</tr>
							} --%>
							<%while(rs.next()){ %>							    
						    
						    <tr>
							<td style='text-align:center'><%=rs.getString("gene_name")%></td>
							<td style='text-align:center'><%=rs.getString("ensembl_gene_id")%></td>
							<%-- 
							<td style='text-align:center'><%=rs.getString("seqnames")%></td>
							<td style='text-align:center'><%=rs.getString("start")%></td>
							<td style='text-align:center'><%=rs.getString("end")%></td>
							<td style='text-align:center'><%=rs.getString("strand")%></td>
							--%>
							<td style='text-align:center'><%=rs.getString("gene_type")%></td>
							<td style='text-align:center'><%=rs.getString("classification")%></td>
							<td style='text-align:center'><%=rs.getString("cell_fullname")%></td>
							<td style='text-align:center'>
							<%
							String so=rs.getString("source");
							if(tissue4==null||tissue4==""||so=="fetal"){
								String tiss3 = rs.getString("tissue");
								out.println("Fetal-"+((tiss3.replace("NA_","")).replace("_"," ")).replace("-"," "));
							}else{
								out.println(((tissue4.replace("NA_","")).replace("_"," ")).replace("-"," "));
							}		
							%>							
							</td>
							<td style='text-align:center'>
							<%
							if((source.equals("hcl")&&a_f.equals("adult"))||source.equals("tts")||source.equals("tica")){//正常成人
								out.println("<a href=\"re_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
							}else if((source.equals("hcl")&&a_f.equals("fetal"))){//正常胎儿
								out.println("<a href=\"fetal_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
							}else if(source.equals("epn")||(source.equals("other")&&a_f.equals("fetal"))){//癌症儿童
								out.println("<a href=\"pedia_details.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
							}else if(source.equals("cell_res")||(source.equals("other")&&a_f.equals("adult"))){//癌症成人
								out.println("<a href=\"re_details.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"&broad="+broad_can+"\">"+"<img src='images/book_copy.jpg'></a>");
							}else{//tisch和tiger的癌症成人
								out.println("<a href=\"re_Gdetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+source+"="+gse+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"&broad="+broad_can+"\">"+"<img src='images/book_copy.jpg'></a>");
							}
							%>
							</td>
							</tr>
						    <%} %>
						<%
								rs.close();
								db.close();
							} catch (Exception e) {
								e.printStackTrace();
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
		var table = $('#Table_body').DataTable({
		    orderCellsTop: true,   //move sorting to top header
		  });
		 // Get the index of matching row.  Assumes only one match
		  var indexes = table.rows().eq( 0 ).filter( function (rowIdx) {    //check column 0 of each row for tradeMsg.message.coin
		    return table.cell( rowIdx, 0 ).data() === 'LUCAT1' ? true : false;
		  } );
		 
		  // grab the data from the row
		  var data = table.row(indexes).data();
		 
		  // populate the .second header with the data
		  for (i = 0; i < data.length; i++) {
		    $('.second').find('th').eq(i).html( data[i] );
		  }
		  
		  // remove the row from the table
		  table.row(indexes).remove().draw(false);
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