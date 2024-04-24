<%@ page import="java.io.*" import="java.util.ArrayList" language="java" 
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.Random"%>
<%@ page import="util.*"%>
<%@ page import="java.sql.*" import="java.util.*" language="java"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.Out"%>
<html>
<head>
<title>LncCE</title>
<meta charset="utf-8" />
<script src="js/jquery.min.js"></script>
</head>
<style>
.table-lyj .single {
    background: #d8cee7;
}
</style>
<body>
<%
DBConn2 db = new DBConn2();
ResultSet rs ;
String sel="";
String source="";
String tissue="";
String ID="";
String T="";
String a_f="";
String source_NC="";

String id = request.getParameter("PID");
db.open();
if(!(id==""||id==null)){
	ID = id.split("=")[0];//节点ID
	source_NC = id.split("=")[1];//资源:normal,cancer,clinical,Tclinical,target
	a_f = id.split("=")[2];
	T = id.split("=")[3];//组织或癌症
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
%>
<div id="content">
	<div id="result">
		<div id="Table_body">
			<table class="table-lyj" style="width: 100%;">
				<tr class="single">

					<th style="text-align:left"><div class='tooltip' >Name</div></th>
					<th style="text-align:left"><div class='tooltip' >ID</div></th>
					<th style="text-align:left"><div class='tooltip' >Source</div></th>
					<!--  
					<th style="text-align:center"><div class='tooltip' >Chromosome</div></th> 										
					<th style="text-align:center"><div class='tooltip' >Start</div></th>
					<th style="text-align:center"><div class='tooltip' >End</div></th>
					<th style="text-align:center"><div class='tooltip' >Strand</div></th>
					-->
					<th style="text-align:left"><div class='tooltip' >Biotype</div></th>				
					<th style="text-align:left"><div class='tooltip' >Classification</div></th>
					<th style="text-align:left"><div class='tooltip' >Tissue</div></th>
					<th style="text-align:left"><div class='tooltip' >Cell</div></th>
					<th style="text-align:left"><div class='tooltip' >Details</div></th>

				</tr>
				
				<%
				String[] allsource = {"hcl","tts","tica"};
					if(!(id==""||id==null)){
						//if(source_NC.equals("normal")){
							for(String i:allsource){
							sel="select * from "+i+"_basic where ensembl_gene_id = '"+ID+"' and tissue= '"+T+"' and source='"+a_f+"'";
							rs=db.execute(sel);
							//rs.last();
							while(rs.next()){
								out.println("<tr class='single table_center'>");
								out.println("<td>"+rs.getString("gene_name")+"</td>");
								out.println("<td>"+rs.getString("ensembl_gene_id")+"</td>");
								out.println("<td>"+hash_resource.get(i)+"</td>");
								/*
								out.println("<td>"+rs.getString("seqnames")+"</td>");
								out.println("<td>"+rs.getString("start")+"</td>");
								out.println("<td>"+rs.getString("end")+"</td>");
								out.println("<td>"+rs.getString("strand")+"</td>");
								*/
								out.println("<td>"+rs.getString("gene_type")+"</td>");								
								//classification
					        	out.println("<td>"+rs.getString("classification")+"</td>");
					        	out.println("<td>"+rs.getString("tissue")+"</td>");
					       		//新加一个cell type
					       		out.println("<td>"+rs.getString("cell_fullname")+"</td>");
					       		out.println("<td>");
					       		if((i.equals("hcl")&&a_f.equals("adult"))||i.equals("tts")||i.equals("tica")){//正常成人
									out.println("<a target='_blank' href=\"re_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
								}else if((i.equals("hcl")&&a_f.equals("fetal"))){//正常胎儿
									out.println("<a target='_blank' href=\"fetal_Ndetails.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
								}
					       		out.println("</td>");
								out.println("</tr>");
							}

						//}
						}							
						db.close();
					}
				%>
			</table>
		</div>  
	</div> 
</div> 

</body>
</html>