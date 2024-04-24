<%@ page import="java.sql.*" import="java.util.*" import="download.*"
	language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.*"%>
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
<!-- datatable -->
<link rel="stylesheet" type="text/css" href="datatable/jquery.dataTables.min.css">
<script type="text/javascript" charset="utf8" src="datatable/jquery.dataTables.min.js"></script>
<title>LncCE</title>
</head>
<%
DBConn2 db = new DBConn2();
String sel="";
ResultSet rs;
db.open();

String source="";
String gse="";
String tis="";
String tis2="";
String a_f="";
String compartment = request.getParameter("compart");
String cell = request.getParameter("currcell");
String sh = request.getParameter("cellresour");
String[] LS = sh.split("=");
if(LS.length==3){
	tis = LS[0];
	gse = LS[1];
	source = LS[2];
}else{
	tis = LS[0];
	source = LS[1];
}
if(tis.contains("Fetal-")){
	a_f="fetal";
	tis2=tis.split("Fetal-")[1];
}else if(tis.contains("Pediatric")){
	a_f="fetal";
	tis2=tis;
}else{
	a_f="adult";
	tis2=tis;
}
/**/
HashMap<String,String> cancer_clas = new HashMap<String,String>();
sel = "select distinct cancer_name,class from index_cancer";
rs = db.execute(sel); 
while(rs.next()){
	cancer_clas.put(rs.getString("cancer_name"),rs.getString("class"));
}


if(source.equals("geo")||source.equals("tiger")){
	if(cell.equals("all")){
		sel = "select * from "+source+"_basic where dataset='"+gse+"' and tissue='"+tis+"' ";
	}else{
		sel = "select * from "+source+"_basic where cell='"+cell+"' and dataset='"+gse+"' and tissue='"+tis+"' ";
	}
	
}else if(source.equals("other")||source.equals("epn")){
	if(cell.equals("all")){
		sel = "select * from "+source+"_basic where tissue='"+tis2+"'";
	}else{
		sel = "select * from "+source+"_basic where cell='"+cell+"' and tissue='"+tis2+"'";
	}		
	
}else{
	if(cell.equals("all")){
		sel = "select * from "+source+"_basic where tissue='"+tis2+"' and source='"+a_f+"'";
	}else{
		sel = "select * from "+source+"_basic where cell='"+cell+"' and tissue='"+tis2+"' and source='"+a_f+"'";
	}
	
}
//System.out.println(sel);
%>
<style>
.table th { 
    text-align: center;
    vertical-align: middle !important;
}
#content {
    height: 715px;
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
		<div style="height:25px;"></div>
		<div class="container-fluid">
		<div class="heading">
			<h3>
			<a class="font-color">
				<%if(source.equals("hcl")){ %>
      			Table of results based on single cell queries in <b>Human Cell Landscape</b>	
      			<%}else if(source.equals("tts")){ %>
      			Table of results based on single cell queries in <b>The Tabula Sapiens</b>
      			<%}else if(source.equals("cell_res")){ %>
      			Table of results based on single cell queries in <b>Junbin Qian. Cell Research. 2020</b>
      			<%}else if(source.equals("geo")||source.equals("tiger")){%>
      			Table of results based on single cell queries in <b><%=gse %></b>
      			<%}else if(source.equals("other")){ %>
      			Table of results based on single cell queries in <b>GSE140819</b>
      			<%}else if(source.equals("tica")){ %>
      			Table of results based on single cell queries in <b>TICA</b>
      			<%}else if(source.equals("epn")){ %>
      			Table of results based on single cell queries in <b>GSE125969</b>
      			<%} %>  
			</a>
			</h3>
		</div>
		<div class="content">
		<table id="Table_body" class="display nowrap" cellspacing="0" width="100%">
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
						<th style="text-align:center">Tissue</th>
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
							
						%>
						<%
								//返回可滚动的结果集  
								rs = db.execute(sel);								
																%>
							
							<%while(rs.next()){ 
							String tissue_na = rs.getString("tissue");
							%>	
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
							<% out.println("<td style='text-align:center'>"+((tis.replace("NA_","")).replace("_"," ")).replace("-"," ")+"</td>");%>
							<%if((source.equals("hcl")&&a_f.equals("adult"))||source.equals("tts")||source.equals("tica")){//正常成人%>
							<td style='text-align:center'><a href="re_Ndetails.jsp?value1=0.5&tissue=<%=rs.getString("tissue")%>&mRNA_tissue=&Name=<%=rs.getString("ensembl_gene_id")%>&classification=<%=rs.getString("classification")%>&resource=<%=source%>&celltype=<%=rs.getString("cell_fullname")%>&chr=<%=rs.getString("seqnames")%>">
							<img src="images/book_copy.jpg">
							</a>
							</td>
							<%}else if((source.equals("hcl")&&a_f.equals("fetal"))){//正常胎儿 %>
							<td style='text-align:center'><a href="fetal_Ndetails.jsp?value1=0.5&tissue=<%=rs.getString("tissue")%>&mRNA_tissue=&Name=<%=rs.getString("ensembl_gene_id")%>&classification=<%=rs.getString("classification")%>&resource=<%=source%>&celltype=<%=rs.getString("cell_fullname")%>&chr=<%=rs.getString("seqnames")%>">
							<img src="images/book_copy.jpg">
							</a>
							</td>
							<%}else if(source.equals("epn")||(source.equals("other")&&a_f.equals("fetal"))){//癌症儿童 %>
							<td style='text-align:center'><a href="pedia_details.jsp?value1=0.5&tissue=<%=rs.getString("tissue")%>&mRNA_tissue=&Name=<%=rs.getString("ensembl_gene_id")%>&classification=<%=rs.getString("classification")%>&resource=<%=source%>&celltype=<%=rs.getString("cell_fullname")%>&chr=<%=rs.getString("seqnames")%>">
							<img src="images/book_copy.jpg">
							</a>
							</td>
							<%}else if(source.equals("cell_res")||(source.equals("other")&&a_f.equals("adult"))){//癌症成人 %>
							<td style='text-align:center'><a href="re_details.jsp?value1=0.5&tissue=<%=tissue_na%>&mRNA_tissue=&Name=<%=rs.getString("ensembl_gene_id")%>&classification=<%=rs.getString("classification")%>&resource=<%=source%>&celltype=<%=rs.getString("cell_fullname")%>&chr=<%=rs.getString("seqnames")%>&broad=<%=cancer_clas.get(tissue_na)%>">
							<img src="images/book_copy.jpg">
							</a>
							</td>
							<%}else{//tisch和tiger的癌症成人 %>
							<td style='text-align:center'><a href="re_Gdetails.jsp?value1=0.5&tissue=<%=tissue_na%>&mRNA_tissue=&Name=<%=rs.getString("ensembl_gene_id")%>&classification=<%=rs.getString("classification")%>&resource=<%=gse%>=<%=source%>&celltype=<%=rs.getString("cell_fullname")%>&chr=<%=rs.getString("seqnames")%>&broad=<%=cancer_clas.get(tissue_na)%>">
							<img src="images/book_copy.jpg">
							</a>
							</td>
							<%} %>																				
							</tr>
						    <%} %>
						
						
						
						
						<%
								rs.close();
								db.close();
						%>
					</tbody>
      		</table>
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