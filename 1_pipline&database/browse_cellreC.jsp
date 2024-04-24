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
db.open();

String source="";
String tissue="";
String ID="";
String T="";
String source_NC="";
String a_f="";

String id = request.getParameter("PID");
//out.println(id);
if(!(id==""||id==null)){
	ID = id.split("=")[0];//节点ID
	source_NC = id.split("=")[1];
	a_f = id.split("=")[2];
	T = id.split("=")[3];//组织或癌症
}
%>
<%
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
<div id="content">
	<div id="result">
		<div id="Table_body">
			<table class="table-lyj" style="width: 100%;">
				<tr class="single">
					<th style="text-align:left"><div class='tooltip' >Name</div></th>
					<th style="text-align:left"><div class='tooltip' >ID</div></th>
					<th style="text-align:left"><div class='tooltip' >Source</div></th>					
					<!--  
					<th style="text-align:left"><div class='tooltip' >Chromosome</div></th> 
					<th style="text-align:left"><div class='tooltip' >Start</div></th>
					<th style="text-align:left"><div class='tooltip' >End</div></th>
					<th style="text-align:left"><div class='tooltip' >Strand</div></th>
					-->
					<th style="text-align:left"><div class='tooltip' >Biotype</div></th>					
					<th style="text-align:left"><div class='tooltip' >Classification</div></th>
					<th style="text-align:left"><div class='tooltip' >Cancer</div></th>
					<th style="text-align:left"><div class='tooltip' >Cell</div></th>
					<th style="text-align:left"><div class='tooltip' >Details</div></th>
				</tr>
				<%
					//if(source_NC.equals("cancer")){   
						 String[] sour = {"cell_res","tiger","geo","other","epn"};
					       for(String i:sour){
					        	 
					        	 sel="select * from "+i+"_basic where ensembl_gene_id = '"+ID+"' and tissue = '"+T+"' and source='"+a_f+"'";
					        	 rs=db.execute(sel);
					        	 //if(rs.first()){
								 while(rs.next()){
										String tissue_na = rs.getString("tissue");
										out.println("<tr  class='single table_center'>");
							        	out.println("<td>"+rs.getString("gene_name")+"</td>");
							        	out.println("<td>"+rs.getString("ensembl_gene_id")+"</td>");
							        	if(i.equals("cell_res")||i.equals("other")||i.equals("epn")){
							        		out.println("<td>"+hash_resource.get(i)+"</td>");
							        	}else{
							        		out.println("<td>"+rs.getString("dataset")+"</td>");
							        	}
							        	/*out.println("<td>"+rs.getString("seqnames")+"</td>");							        								        	
							        	out.println("<td>"+rs.getString("start")+"</td>");
							        	out.println("<td>"+rs.getString("end")+"</td>");
							       		out.println("<td>"+rs.getString("strand")+"</td>");*/
							       		out.println("<td>"+rs.getString("gene_type")+"</td>");							        	
							       		//classification
							        	out.println("<td>"+rs.getString("classification")+"</td>");
							        	out.println("<td>"+tissue_na+"</td>");
							       		//新加一个cell type
							       		out.println("<td>"+rs.getString("cell_fullname")+"</td>");
							       		//details
							        	out.println("<td>");
							        	if(i.equals("epn")||(i.equals("other")&&a_f.equals("fetal"))){//癌症儿童
											out.println("<a target='_blank' href=\"pedia_details.jsp?value1=0.5&tissue="+rs.getString("tissue")+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"\">"+"<img src='images/book_copy.jpg'></a>");
										}else if(i.equals("cell_res")||(i.equals("other")&&a_f.equals("adult"))){//癌症成人
											out.println("<a target='_blank' href=\"re_details.jsp?value1=0.5&tissue="+tissue_na+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"&broad="+cancer_clas.get(tissue_na)+"\">"+"<img src='images/book_copy.jpg'></a>");
										}else{//tisch和tiger的癌症成人
											out.println("<a target='_blank' href=\"re_Gdetails.jsp?value1=0.5&tissue="+tissue_na+"&mRNA_tissue=&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+rs.getString("dataset")+"="+i+"&celltype="+rs.getString("cell_fullname")+"&chr="+rs.getString("seqnames")+"&broad="+cancer_clas.get(tissue_na)+"\">"+"<img src='images/book_copy.jpg'></a>");
										}
							        	out.println("</td>");
							       		//out.println("<td><a target='_blank' href=\"re_details.jsp?value1=0.7&tissue="+rs.getString("tissue")+"&mRNA_tissue="+rs.getString("tissue")+"&Name="+rs.getString("ensembl_gene_id")+"&classification="+rs.getString("classification")+"&resource="+rs.getString("sequence")+"&celltype="+rs.getString("cell")+"\">"+"<img src=\"images/book_copy.jpg\"></a></td>");
							        	out.println("</tr>");
								}
								 
					       //}
					      }
					//}
					       rs.close();
						   db.close();
				%>
			</table>
		</div>  
	</div> 
</div> 

</body>
</html>