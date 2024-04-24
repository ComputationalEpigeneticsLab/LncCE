<%@page import="org.eclipse.jdt.internal.compiler.ast.WhileStatement"%>
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
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.util.Arrays"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LncCE</title>
    
<!-- CSS
================================================== -->
<link rel="stylesheet" href="css/style.css">

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
<script type="text/javascript" src="echarts/echarts.min.js"></script>
<script type="text/javascript" src="echarts/ecSimpleTransform.min.js"></script>
<script type="text/javascript" src="echarts/ecStat.min.js"></script>
<script src="viloin/plotly-2.18.2.min.js"></script>
<script>
function submit1(){
	//document.form2.action = 'tmp_tissue.jsp?#floatMenu3';
	document.form2.submit();
}
</script>
<style>
.sesty{
text-align:left;
width: 523px; 
height: 45px;
/*border-width:3px;*/
}
.bar{
width:600px;
height:600px;
}
.vilo{
width:600px;
height:600px;
}
.cluster_e{
width:600px;
height:600px;
}
/*lncce*/
.font-color{
	color:#8064A2;
}
.row-distance{
	margin-top: 20px;
}
</style>
</head>
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;

String location="";
String type="";
String chr = request.getParameter("chr");
String ID = request.getParameter("Name");
String rs_a  = request.getParameter("classification");
String rs_t = "";
String cancer = "";
String resource = request.getParameter("resource");
String NODE=""; //gene的名字
String cell="";
String rs_c="";
String a_f="";
String tissue_pd="";
cell=request.getParameter("celltype");
tissue_pd = request.getParameter("tissue");
a_f="adult";
NODE = request.getParameter("NODE");
%>
<%
HashMap<String,String> cancer_fullname = new HashMap<String,String>();
cancer_fullname.put("AEL","Acute erythroid leukemia");
cancer_fullname.put("ALL","Acute lymphoblastic leukemia");
cancer_fullname.put("AML","Acute myeloid leukemia");
cancer_fullname.put("BCC", "Basal cell carcinoma");
cancer_fullname.put("BLCA","Bladder cancer");
cancer_fullname.put("BRCA","Breast cancer");
cancer_fullname.put("CHOL","Cholangiocarcinoma");
cancer_fullname.put("Chronic lymphocytic leukemia_NA_scRNA","Chronic lymphocytic leukemia");
cancer_fullname.put("CLL","Chronic lymphocytic leukemia");
cancer_fullname.put("COAD","Colon adenocarcinoma");
cancer_fullname.put("CRC","Colorectal cancer");
cancer_fullname.put("Ependymoma","Ependymoma");
cancer_fullname.put("GBM","Glioblastoma");
cancer_fullname.put("Glioblastoma_NA_scRNA","Glioblastoma");
cancer_fullname.put("Glioma","Glioma");
cancer_fullname.put("HNSCC","Head and neck squamous cell carcinoma");
cancer_fullname.put("Pediatric_high-grade glioma_NA_snRNA","High-grade glioma");
cancer_fullname.put("KIRC","Kidney renal clear cell carcinoma");
cancer_fullname.put("LICA","Liver cancer");
cancer_fullname.put("LIHC","Liver hepatocellular carcinoma");
cancer_fullname.put("LUAD_and_LUSC","Lung adenocarcinoma and lung squamous cell carcinoma");
cancer_fullname.put("Melanoma","Melanoma");
cancer_fullname.put("Melanoma_NA_snRNA","Melanoma");
cancer_fullname.put("MCC","Merkel cell carcinoma");
cancer_fullname.put("Metastatic breast cancer_brain metastatic_snRNA","Metastatic breast cancer brain metastases");
cancer_fullname.put("Metastatic breast cancer_liver metastases_scRNA","Metastatic breast cancer liver metastases");
cancer_fullname.put("Metastatic breast cancer_liver metastases_snRNA","Metastatic breast cancer liver metastases");
cancer_fullname.put("Metastatic breast cancer_lymph node metastases_scRNA","Metastatic breast cancer lymph node metastases");
cancer_fullname.put("MM","Multiple myeloma");
cancer_fullname.put("Pediatric_Neuroblastoma_NA_snRNA","Neuroblastoma");
cancer_fullname.put("NET","Neuroendocrine tumor");
cancer_fullname.put("NHL","Non Hodgkins lymphoma");
cancer_fullname.put("NSCLC","Non small cell lung cancer");
cancer_fullname.put("non-small cell lung carcinoma_NA_scRNA","Non small cell lung carcinoma");
cancer_fullname.put("OV","Ovarian cancer");
cancer_fullname.put("Ovarian_NA_scRNA","Ovarian cancer");
cancer_fullname.put("Ovarian_NA_snRNA","Ovarian cancer");
cancer_fullname.put("PAAD","Pancreatic ductal adenocarcinomas");
cancer_fullname.put("Pediatric_Sarcoma_rhabdomyosarcoma_snRNA","Rhabdomyosarcoma");
cancer_fullname.put("Pediatric_Sarcoma_NA_snRNA","Sarcoma");
cancer_fullname.put("SKCM","Skin cutaneous melanoma");
cancer_fullname.put("SCC","Squamous cell carcinoma");
cancer_fullname.put("UVM","Uveal melanoma");
%>
<%
//查询tissue_pd对应的癌症
String pd_tiss="";
db.open();
sel = "select cancer from tissue_cancer where tissue ='" + tissue_pd + "' ";
rs = db.execute(sel);
while(rs.next()){
	String tt=rs.getString("cancer");
	if(tt.equals("NONE")){}else{
		pd_tiss=tt;
	}
}
rs.close();
db.close();	
int mylen=1;
if(pd_tiss.contains(";")){
	mylen = pd_tiss.split(";").length;
}
String[] pd_cancer = new String[mylen];

pd_cancer = pd_tiss.split(";");

//cancer
List<String> tempsourcan = new ArrayList<String>();
List<String> intesourcan = new ArrayList<String>();
List<String> allsour = new ArrayList<String>();
String[] allcansour={"geo","cell_res","other","tiger"};
for(String ou : allcansour){
	List<String> integra_gse = new ArrayList<String>();
	List<String> integra_cell = new ArrayList<String>();
	List<String> integra_tissue = new ArrayList<String>();
	db.open();
	sel = "select * from "+ou+"_basic where ensembl_gene_id ='" + ID + "' and source='"+a_f+"'";
	rs = db.execute(sel); 
	rs.beforeFirst();
	while(rs.next()){
		allsour.add(ou);
		integra_cell.add(rs.getString("cell_fullname"));	
		integra_tissue.add(rs.getString("tissue"));
		if(ou.equals("geo")||ou.equals("tiger")){
			integra_gse.add(ou+"="+rs.getString("dataset"));
		}
	}
	rs.close();
	db.close();	
	
	/*if(integra_cell.size()>0){
		//存储组织+资源,并将cell_pd放前面
		for(int k=0;k<integra_cell.size();k++){
			if(integra_cell.get(k).equals(cell)){
				if(ou.equals("geo")||ou.equals("tiger")){
					for(int j=0;j<integra_gse.size();j++){
						intesourcan.add(integra_tissue.get(j)+"="+integra_gse.get(j));
					}
				}else{
					for(int j=0;j<integra_tissue.size();j++){
						intesourcan.add(integra_tissue.get(j)+"="+ou+"=");
					}			
				}
			}else{
				if(ou.equals("geo")||ou.equals("tiger")){
					for(int j=0;j<integra_gse.size();j++){
						tempsourcan.add(integra_tissue.get(j)+"="+integra_gse.get(j));
					}
				}else{
					for(int j=0;j<integra_tissue.size();j++){
						tempsourcan.add(integra_tissue.get(j)+"="+ou+"=");
					}			
				}
			}
		}
																
	}*/
	if(integra_cell.size()>0){
		//存储组织+资源,并将TISSUE_pd相关的癌症放前面
		for(int k=0;k<integra_cell.size();k++){
			if(pd_tiss.contains(";")){
				
				if(ou.equals("geo")||ou.equals("tiger")){
					
					for(int j=0;j<integra_gse.size();j++){
						for(int kk=0;kk<mylen;kk++){
							if(integra_tissue.get(j).equals(pd_cancer[kk])){
								intesourcan.add(integra_tissue.get(j)+"="+integra_gse.get(j));
							}else{
								tempsourcan.add(integra_tissue.get(j)+"="+integra_gse.get(j));
							}
						}												
						
					}
				}else{
					for(int j=0;j<integra_tissue.size();j++){
						for(int kk=0;kk<mylen;kk++){
							if(integra_tissue.get(j).equals(pd_cancer[kk])){
								intesourcan.add(integra_tissue.get(j)+"="+ou+"=");
							}else{
								tempsourcan.add(integra_tissue.get(j)+"="+ou+"=");
							}
						}						
						
					}			
				}
				
			}else{
			
				//if(integra_cell.get(k).equals(cell)){
					if(ou.equals("geo")||ou.equals("tiger")){
						
						for(int j=0;j<integra_gse.size();j++){
							if(integra_tissue.get(j).equals(pd_tiss)){
								intesourcan.add(integra_tissue.get(j)+"="+integra_gse.get(j));
							}else{
								tempsourcan.add(integra_tissue.get(j)+"="+integra_gse.get(j));
							}
							
						}
					}else{
						for(int j=0;j<integra_tissue.size();j++){
							if(integra_tissue.get(j).equals(pd_tiss)){
								intesourcan.add(integra_tissue.get(j)+"="+ou+"=");
							}else{
								tempsourcan.add(integra_tissue.get(j)+"="+ou+"=");
							}
							
						}			
					}
				/*}else{
					if(ou.equals("geo")||ou.equals("tiger")){
						for(int j=0;j<integra_gse.size();j++){
							if(integra_tissue.get(j).equals("pd_tiss")){
								intesourcan.add(integra_tissue.get(j)+"="+integra_gse.get(j));
							}else{
								tempsourcan.add(integra_tissue.get(j)+"="+integra_gse.get(j));
							}
							
						}
					}else{
						for(int j=0;j<integra_tissue.size();j++){
							if(integra_tissue.get(j).equals("pd_tiss")){
								intesourcan.add(integra_tissue.get(j)+"="+ou+"=");
							}else{
								tempsourcan.add(integra_tissue.get(j)+"="+ou+"=");
							}
														
						}			
					}
				}*/
			
			}
			
			
		}
																
	}
}

//按照首字母排序
Collections.sort(tempsourcan);
//汇总组织+资源
for(int j=0;j<tempsourcan.size();j++){
	intesourcan.add(tempsourcan.get(j));
}
//去重组织+资源
List<String> intesour_uniqcan = new ArrayList<String>();
for(int j=0;j<intesourcan.size();j++){
	if(!intesour_uniqcan.contains(intesourcan.get(j))){
		intesour_uniqcan.add(intesourcan.get(j));
	}
}
%>
<%
HashMap<String,String> hash_description = new HashMap<String,String>();
hash_description.put("CE","detected increased expression in cells,including cell specific(CS),cell enriched(CER) and cell enhanced(CEH)");
hash_description.put("CS","detected only in a particular cell");
hash_description.put("CER","at least fivefold higher lncRNA levels in a particular cell as compared to all other cells");
hash_description.put("CEH","at least fivefold higher lncRNA levels in a particular cell as compared to the average levels in all other cells");

HashMap<String,String> hash_fullna = new HashMap<String,String>();
hash_fullna.put("CS","Cell Specific");
hash_fullna.put("CER","Cell Enriched");
hash_fullna.put("CEH","Cell Enhanced");

HashMap<String,String> hash_resource = new HashMap<String,String>();
hash_resource.put("hcl","Human Cell Landscape");
hash_resource.put("tts","The Tabula Sapiens");
hash_resource.put("other","GSE140819");
hash_resource.put("cell_res","Qian et al., Cell Research 2020");
hash_resource.put("tica","TICA");
hash_resource.put("epn","GSE125969");
//hash_resource.put("group","Vento-Tormo Group");
//hash_resource.put("nature","Nature_Medicine_GSE150728");
String[] volcolor = {"#ffb980","#5ab1ef","#b6a2de","#2ec7c9","#fc97af","#87f7cf","#001852","#72ccff",
        		  "#f7c5a0","#e01f54","#d2f5a6","#76f2f2","#516b91","#59c4e6","#edafda","#93b7e3","#a5e7f0",
        		  "#cbb0e3","#588dd5","#f5994e","#ffb980","#5ab1ef","#b6a2de","#2ec7c9","#fc97af","#87f7cf",
        		  "#001852","#72ccff","#f7c5a0","#e01f54","#d2f5a6","#76f2f2","#516b91","#59c4e6","#edafda",
        		  "#93b7e3","#a5e7f0","#cbb0e3","#588dd5","#f5994e","#ffb980","#5ab1ef","#b6a2de","#2ec7c9",
        		  "#fc97af","#87f7cf","#001852","#72ccff",};
//System.out.println("0000");
%>
<body>      

<section style="background-color:#fff;">						
<div class="content">
<div>
<div>		
<%
//获取选择的组织+资源，并进行拆分
String tisssour = request.getParameter("tisssour");
String select_sour = "";
String select_tiss = "";
String select_gse = "";
if(tisssour==null){
	
	if(tissue_pd.equals("Lung")&&resource.equals("tts")&&ID.equals("ENSG00000248323")){
		tisssour = "NSCLC=geo=GSE117570";
		select_tiss = "NSCLC";
		select_sour = "geo";
		select_gse = "GSE117570";
	}else{
		tisssour = intesour_uniqcan.get(0);
		String ts[] = intesour_uniqcan.get(0).split("=");
		if(ts.length==3){
			select_tiss = ts[0];
			select_sour = ts[1];
			select_gse = ts[2];
		}else{
			select_tiss = ts[0];
			select_sour = ts[1];
		}
	}
}else{
	String ts2[] = tisssour.split("=");
	if(ts2.length==3){
		select_tiss = ts2[0];
		select_sour = ts2[1];
		select_gse = ts2[2];
	}else{
		select_tiss = ts2[0];
		select_sour = ts2[1];
	}
}
//System.out.println(select_tiss);
//System.out.println(select_sour);
String end_tiss = (select_tiss.replace("NA_", "")).replace("_"," ");
%>
<div class="">
<form id="form2" name="form2">
<input type="hidden" name="value1" value=0.5>
<input type="hidden" name="tissue" value='<%=tissue_pd %>'>
<input type="hidden" name="mRNA_tissue" value="">
<input type="hidden" name="Name" value='<%=ID %>'>
<input type="hidden" name="classification" value='<%=rs_a %>'>
<input type="hidden" name="resource" value='<%=resource %>'>
<input type="hidden" name="celltype" value='<%=cell %>'>
<input type="hidden" name="chr" value='<%=chr%>'>
<input type="hidden" name="NODE" value='<%=NODE%>'>
<select id="tisssour" class="sesty" name="tisssour">
<%
/*把选择的组织+资源放在第一个*/
if(select_sour.equals("geo")||select_sour.equals("tiger")){
	out.println("<option value='"+tisssour+"'>");
	out.println(end_tiss+" ("+select_gse+")");
	out.println("</option>");
}else{
	out.println("<option value='"+tisssour+"'>");
	out.println(end_tiss+" ("+hash_resource.get(select_sour)+")");
	out.println("</option>");
}
if(tissue_pd.equals("Lung")&&resource.equals("tts")&&ID.equals("ENSG00000248323")){
	out.println("<option value='NSCLC=geo=GSE117570'>");
	out.println("NSCLC(GSE117570)");
	out.println("</option>");
}
/*循环输出所有的组织+资源*/
for(int se=0;se<intesour_uniqcan.size();se++){		
		String inun[] = intesour_uniqcan.get(se).split("=");
		if(inun.length>2){
			out.println("<option value='"+intesour_uniqcan.get(se)+"'>");
			out.println((inun[0].replace("NA_", "")).replace("_"," ")+" ("+inun[2]+")");
			out.println("</option>");
		}else{
			out.println("<option value='"+intesour_uniqcan.get(se)+"'>");
			out.println((inun[0].replace("NA_","")).replace("_"," ")+" ("+hash_resource.get(inun[1])+")");
			out.println("</option>");
		}
	}

%>
</select>
<button id="sour_btn" type="submit" value="Submit" class="btn btn-dark" onclick="submit1()">Apply Filter</button>
</form>
</div>

<% if(select_sour.equals("geo")||select_sour.equals("tiger")){%>
<div class="heading row-distance">
<h4>
Spatial expression pattern of <%=end_tiss %> tissue in the data resource of <span style="color:#525acd"><%=select_gse %></span>
</h4>
</div>
<%}else{%>
<div class="heading row-distance">
<h4>Spatial expression pattern of <%=end_tiss %> tissue in the data resource of <span style="color:#525acd"><%=hash_resource.get(select_sour) %></span></h4></div>
<%}%>

<%//max mean查询,cell_res ,other, epn
if(select_gse==""){%>	
<%  	
	//max mean表格
	out.println("<table id='cancer-table' class='table-lyj round-border row-distance' style='width:100%;'>");
	out.println("<thead>");
	out.println("<tr class=\"single\">");
	out.println("<th>");
		out.println("Cancer");
	out.println("</th>");
	out.println("<th>");
		out.println("CE cell");
	out.println("</th>");
	out.println("<th>");
		out.println("Classification");
	out.println("</th>");
	out.println("<th title='Exp. in the CE cell'>");
		out.println("Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("<th title='Max Exp. in other cell'>");
		out.println("Max Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("<th title='Mean Exp. in other cell'>");
		out.println("Mean Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("</tr>");
	out.println("</thead>");
	out.println("<tbody>");
	
	List<String> celltt = new ArrayList<String>();
	List<String> clasii = new ArrayList<String>();
	List<String> cellexp = new ArrayList<String>();
	List<String> maxx = new ArrayList<String>();
	List<String> meann = new ArrayList<String>();
	db.open();
	sel = "select * from "+select_sour+"_basic where ensembl_gene_id ='" + ID + "' and tissue='"+select_tiss+"' ";
	rs = db.execute(sel);
	while(rs.next()){
		celltt.add(rs.getString("cell_fullname").replace("/"," or "));
		clasii.add(rs.getString("classification"));
		cellexp.add(rs.getString("cell_exp"));
		maxx.add(rs.getString("remain_max"));
		meann.add(rs.getString("remain_mean"));
	}
	rs.close();
	db.close();
	
	int cesize = celltt.size();
	out.println("<tr>");
	out.println("<td title=\""+cancer_fullname.get(select_tiss)+"\">");
	out.println(end_tiss);
	//out.println("<span class=\"glyphicon glyphicon-question-sign\" title=\""+cancer_fullname.get(select_tiss)+"\"></span>");
	out.println("<img src=\"images/help.svg\">");
	out.println("</td>");
	out.println("<td style='color:#525acd'>");
	for(int j=0;j<cesize;j++){		
		out.println(celltt.get(j)+"<br/>");		
	}
	out.println("</td>");
	out.println("<td>");
	for(int j=0;j<cesize;j++){
		out.println(clasii.get(j));
		//out.println("<span title=\""+hash_fullna.get(clasii.get(j))+" : "+hash_description.get(clasii.get(j))+"\"></span>");						
		out.println("<img title=\""+hash_fullna.get(clasii.get(j))+" : "+hash_description.get(clasii.get(j))+"\" src=\"images/help.svg\">");
		out.println("<br/>");
	}
	out.println("</td>");
	out.println("<td>");
	for(int j=0;j<cesize;j++){
		out.println(String.format("%.4f",Double.valueOf(cellexp.get(j)))+"<br/>");
	}
	out.println("</td>");
	out.println("<td>");
	for(int j=0;j<cesize;j++){
		out.println(String.format("%.4f",Double.valueOf(maxx.get(j)))+"<br/>");
	}
	out.println("</td>");
	out.println("<td>");
	for(int j=0;j<cesize;j++){
		out.println(String.format("%.4f",Double.valueOf(meann.get(j)))+"<br/>");
	}
	out.println("</td>");
	out.println("</tr>");
out.println("</tbody>");	
out.println("</table>");
%>
<!-- 柱状图start -->
<%
db.open();
sel = "select * from "+select_sour+"_"+a_f+"_lncexp where result=\""+NODE+"\" and tissue_type='"+select_tiss+"'";
rs=db.execute(sel);
ResultSetMetaData data3 = rs.getMetaData();
int col_cell3=data3.getColumnCount();//获取细胞类型的个数
List<String> coln3 = new ArrayList<String>();
List<String> vv3 = new ArrayList<String>();
List<String> oldcol3 = new ArrayList<String>();
List<String> colname3 = new ArrayList<String>();
List<String> v3 = new ArrayList<String>();
while(rs.next()){
	for(int g=4;g<=col_cell3;g++){
		if(rs.getString(g).equals("NA")){
		}else{
		oldcol3.add(data3.getColumnName(g));
		}
	}
}
Collections.sort(oldcol3);
rs.beforeFirst();
while(rs.next()){
	for(int g=0;g<oldcol3.size();g++){
		coln3.add(oldcol3.get(g));
		vv3.add(rs.getString(oldcol3.get(g)));
	}
}
rs.close();
db.close();

//去重列名和对应的值
	for(int k=0;k<coln3.size();k++){
		if(!colname3.contains(coln3.get(k))){
			colname3.add(coln3.get(k));
			v3.add(vv3.get(k));
		}
	}
%>
<script>
$(document).ready(function(){
    $('#cancer-table').DataTable(
    {
    	"filter":false,
    	"bLengthChange": false,
    }		
    );
});   
</script>
<%if(v3.size()>0){ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Mean Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tiss);%></small></p>
        <div id="barc" class="bar"></div>
      </div>
    </div>
  
<script>
				var chartDom = document.getElementById('barc');
				var myChart = echarts.init(chartDom);
				var option;

				option = {
					<%--title: {
						text: 'Expression level of <%=NODE%>',
						subtext:'Tissue: '+<%out.println("'"+tissue_pd+"'");%>,
						left: "center",
					    top: "10px",
					    textStyle: {
					      fontSize: 19
					    }
					},--%>
					xAxis: {
				    type: 'category',
				    axisLabel: {
				        rotate: 90
				      },
				    data: <%
				   		 out.println("[");
				    	for(int ee=0;ee<colname3.size()-1;ee++){
				    		out.println("'"+colname3.get(ee)+"'"+",");
				    	}
				    	out.println("'"+colname3.get(colname3.size()-1)+"'");
				    	out.println("]");
				    %>
				  },
				  yAxis: {
				    type: 'value',
				    name:"CPM",
				    nameLocation: "middle",
				    nameTextStyle: {
				      fontSize: 16,
				      align: "center",
				      lineHeight: 70
				    }
				   },				  
					tooltip: {
						// head + 每个 point + footer 拼接成完整的 table
						headerFormat: '<table>',
						pointFormat: '<tr><td colspan="3">{point.description}</td></tr>'+
						'<tr><td style="width:10px;color:{series.color};padding:0">{series.name}: </td>' +
						'<td style="padding:0;text-align:left"><b>{point.y}</b></td></tr>',
						footerFormat: '</table>',
						shared: true,
						useHTML: true,
					},
					grid: {
					    bottom:120,
					    left:80
					  },
				  series: [
				    {
				      data: <%
				   		 out.println("[");
			    	for(int ee=0;ee<v3.size()-1;ee++){
			    		 out.println(v3.get(ee)+",");
			    	}
			    	out.println(v3.get(v3.size()-1));
			    	out.println("]");
			    	%>,
				      type: 'bar',
				      name: 'mean of expression',
				      showBackground: true,
				      backgroundStyle: {
				        color: 'rgba(180, 180, 180, 0.2)'
				      },
				      itemStyle: {
	                        normal: {
	                            color: function(params) {
	                            	<%
	                                /*int colorlen=v0.size();
	                                int cor1=0;
	                                out.println("var colorList0 = ['#5470c6', '#91cc75', '#fac858', '#ee6666', '#73c0de', '#3ba272', '#fc8452', '#9a60b4', '#ea7ccc'];");
	                                out.println("var colorList = new Array("+colorlen+");");
	                                for(int cor=0;cor<v0.size();cor++){
	                                	if(cor1<9){
	                                		out.println("colorList["+cor+"]=colorList0["+cor1+"]");
	                                		cor1++;
	                                	}else{
	                                		cor1=0;
	                                		out.println("colorList["+cor+"]=colorList0["+cor1+"]");
	                                	}
	                                }*/
	                                %>
	                                //return colorList[params.dataIndex];
	                            	<%int celllen3 = celltt.size();
                            		out.println("var cellList = new Array("+celllen3+");");
                            		for(int co=0;co<celllen3;co++){
                            		out.println("cellList["+co+"]="+"'"+celltt.get(co)+"'");
                            		}
                            		%>
                               	 	var c ='';
                            		if(cellList.includes(params.name)){
                                    	c='#525acd'
                                	}else{
                                   		c='#bfbfbf'
                                	}
                                	return c;
	                            }
	                        }
	                    }
				    }
				  ]
				};
myChart.setOption(option);
</script>
<%} %>
<!-- 柱状图end -->
<%/*查询detail*/		
					db.open();
					sel="select * from "+select_sour+"_"+a_f+"_detail where Gene IN ('cell','cell_type','tsne_x','tsne_y',\""+NODE+"\") ORDER BY FIELD(Gene,\""+NODE+"\",'cell','cell_type','tsne_x','tsne_y')";
					rs=db.execute(sel);
						List<String> scat3 = new ArrayList<String>();//
						List<String> cell_type33 = new ArrayList<String>();//细胞类型
						//List<String> cell_type4 = new ArrayList<String>();
						//rs.beforeFirst();
						while(rs.next()){
							scat3.add(rs.getString(select_tiss));
						}
						rs.close();
						db.close();
					
						  String[] scat3ldz1_0 = scat3.get(0).split(";");//exp
			              String[] scat3ldz1_1 = scat3.get(1).split(";");//
			              String[] scat3ldz1_2 = scat3.get(2).split(";");
			              String[] scat3ldz1_3 = scat3.get(3).split(";");
			              String[] scat3ldz1_4 = scat3.get(4).split(";");
						
						//查询表达max
						String cancermax="";
						db.open();
						sel="select * from "+select_sour+"_"+a_f+"_max where Gene = \""+NODE+"\"";
						rs=db.execute(sel);
						while(rs.next()){
							cancermax=rs.getString(select_tiss);
						}
						rs.close();
						db.close();	
					
						for(int p=0;p<scat3ldz1_2.length;p++){
							cell_type33.add(scat3ldz1_2[p]);
						}
						//去重细胞类型
			        	  List<String> celltype_uniq3 = new ArrayList<String>();
			        	  for(int p=0;p<cell_type33.size();p++){
			        		  celltype_uniq3.add(cell_type33.get(p).split(",")[0]);
			        	  }
			        	  String expr3=scat3.get(0).split(",")[0];
						%>

<%if(expr3.equals("NONE")){
}else{ %>
<!-- 小提琴图 start -->
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tiss);%></small></p>
        <div id="boxplotc" class="vilo"></div>
      </div>
    </div>
  </div>
</div>
<script>
//let Plotly = require('viloin/plotly-2.16.1.min.js');
//initViolin(){  //渲染violin图
    let rows_1 = [
      <%
      int sca=scat3ldz1_0.length;
      for(int p=0;p<sca;p++){
      	String[] scat3ldz2_0 = scat3ldz1_0[p].split(",");
      	int sca2=scat3ldz2_0.length;
      	for(int q=0;q<sca2;q++){
      		out.println("{");
      			out.println("EXPRESSION_VALUE:"+scat3ldz2_0[q]+",");
      			out.println("GROUP_NAME:"+"\""+celltype_uniq3.get(p)+"\""+",");
      			out.println("GROUP_SHORT:"+"\""+celltype_uniq3.get(p)+"\""+",");
      		out.println("},");;		
      	}		
      }
      %>     
    ];
    function unpack(rows_1, key) {
      return rows_1.map(function(row) { return row[key]; });
    }
    let data_1 = [{
      type: 'violin',
      x: unpack(rows_1, 'GROUP_SHORT'),
      y: unpack(rows_1, 'EXPRESSION_VALUE'),
      //points: 'none',
      //hoverinfo: 'skip',//hover不显示数据信息
      box: {
        visible: true
      },
      line: {
        color: 'green',
      },
      /*fillcolor: 'cornflowerblue',
      opacity: 0.6,*/
      meanline: {
        visible: true
      },
      boxpoints: 'all',
      jitter: 1,
      pointpos: 0,//设置与小提琴相关的采样点的位置。如果“0”，则采样点位于小提琴中心上方。正(负)值对应垂直小提琴的右(左)位，水平小提琴的上(下)位。
      showlegend: false,//图例
      transforms: [{
        type: 'groupby',
        groups: unpack(rows_1, 'GROUP_SHORT'),
        styles: [
          <% 
          for(int q=0;q<celltype_uniq3.size();q++){
             out.println("{target:"+"'"+celltype_uniq3.get(q)+"'"+","+"value: {line: {color: '"+volcolor[q]+"'}}},");
           }
          %>
        ],
      }]
    }]

    let layout_1 = {
      <%--title: "Expression level of <%=NODE%><br>"+'Tissue: '+<%out.println("'"+tissue_pd+"'");%>,--%>
      /*font:{
    	  family:'Microsoft YaHei',
    	  size:14
      },*/
      xaxis: {
        "tickangle": -90,//倾斜角度
        title: {
        },
        position:[0,0.8]      
      },
      yaxis: {
        zeroline: false,
        title: {
          text: 'CPM'
        },
      //rangemode:'nonnegative',//截断图
      rangeselector:{
        font:{
    	  size:1
    	}
      }
      },
      height: 600,
      margin:{
    	  b:180,
    	  //left:190
      },
      legend:{
    	  title:{
    		  text:"Cell type"
    	  },
          itemwidth:10 
      }
    }

    Plotly.newPlot('boxplotc', data_1, layout_1, {showSendToCloud: true});
  //},
</script>
<!-- 小提琴图 end -->
<%} %>
<!-- -------------------------------聚类图start-------------------------------- -->
<%if(expr3.equals("NONE")){
}else{ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b>Cell clustering based on highly variable genes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tiss);%></small></p>
        <div id="clusterc" class="cluster_e"></div>
      </div>
    </div>
  
<script>
var myChart = echarts.init(document.getElementById('clusterc'));
var data_left1 = [
            	 <% 
            	 for(int p=0;p<scat3ldz1_0.length;p++){
               	  String[] scat3ldz2_0 = scat3ldz1_0[p].split(",");
               	  String[] scat3ldz2_1 = scat3ldz1_1[p].split(",");
               	  String[] scat3ldz2_2 = scat3ldz1_2[p].split(",");
               	  String[] scat3ldz2_3 = scat3ldz1_3[p].split(",");
               	  String[] scat3ldz2_4 = scat3ldz1_4[p].split(",");
               	  for(int q=0;q<scat3ldz2_0.length;q++){
               		  out.println("{name:'"+scat3ldz2_1[q]+"'"+",");//symbol
               		  out.println("value:[");
               		  out.println(scat3ldz2_3[q]+",");//x
                   	  out.println(scat3ldz2_4[q]+",");//y      	  
                   	  out.println("'"+scat3ldz2_2[q]+"'");//celltype
                   	  out.println("],},");
               	  }
               }
                 %>
            ];
            var leg = [
            	<%
            	for(int q=0;q<celltype_uniq3.size();q++){
            		out.println("'" +celltype_uniq3.get(q)+"'"+",");
            	}
            	%>
            ];
            option = {       	    
                    <%--title: {
                        text: 'Cell clusters'<%//out.println("'Cell clusters in '+'"+tissue_pd+"'");%>,
                        right:550,
                        top: 10,
                        subtext:'Tissue: '+<%out.println("'"+select_tiss+"'");%>   
                    },--%>
                    brush: {
                        xAxisIndex: 'all',
                        yAxisIndex: 'all',
                        toolbox:['rect', 'polygon', 'clear'],
                        brushStyle:{                	
                        	    borderWidth: 1,
                        	    color: 'rgba(242, 135, 5,0.3)',
                        	    borderColor: 'rgba(242, 135, 5,0.8)'            	
                        },
                        outOfBrush: {
                            colorAlpha: 0.1
                        }
                    },        
                    grid: {
                        left: '5%',
                        right: '10%',
                        bottom: '10%',
                        top:'15%',
                        containLabel: true
                    },        
                  toolbox:{
                	  show:true,
                      showTitle:true,
                      top:8,
                      left:40,
                      feature:{                            
                          dataView:{
                              show:true,
                              title:'Data View',
                              lang:['Data View','Close','Refresh'],
                              buttonColor : '#F28705',
                              optionToContent: function(opt) {                           
                                  var series = opt.series;                          
                                  //console.log(series);                           
                                  var length=series[0].data.length  //get length                          
                                  //console.log(length);                                                        
                                  var name=series[0].data[1].name;
                                 // console.log(name);                           
                                  var x=series[0].data[1].value[0];
                                 // console.log(x);                 
                                  var table = '<table  class="altrowstable"  style="width:100%;text-align:center"><tbody><tr>'
                                               + '<td>Cell name</td>'
                                               + '<td>x</td>'
                                               + '<td>y</td>'
                                               + '<td>cell_type</td>'
                                               + '</tr>';
                                  for (var i = 0, l = length; i < l; i++) {
                                      table += '<tr>'
                                               + '<td>' + series[0].data[i].name + '</td>'
                                               + '<td>' + series[0].data[i].value[0] + '</td>'
                                               + '<td>' + series[0].data[i].value[1] + '</td>'
                                               + '<td>' + series[0].data[i].value[2] + '</td>'
                                               + '</tr>';
                                  }
                                  table += '</tbody></table>';
                                  return table;
                              } 
                          },
                          restore:{
                              show:true,
                              title:'Restore'
                          },
                          saveAsImage:{
                              show:true,
                              title:'Save As Image'
                          },
                          //
                          dataZoom:{
                              show:true,
                              title:{
                              	zoom:'Zoom Region',
                              	back:'Zoom Region Back'
                              }
                          },
                          brush:{
                          	title:{rect:'Rectangular Region',polygon : 'Polygon Region',clear : 'Clear Region'}
                          }                          
                      }},                                        
                    visualMap: {            
                    	type :'piecewise',
                         padding: [
                        	    10,  // 
                        	    0, // 
                        	    5,  //
                        	    10, //
                        	],
                       	showLabel:true, 
                        itemHeight:10,  
                        itemGap:5,                    
                        orient: 'vertical',
                        right: 0,
                        top: 'center',
                        text: ['Cell type',''],
                    
                        calculable: true,
                        inRange: {
                        	  symbol:'circle', color:['#ffb980','#5ab1ef','#b6a2de','#2ec7c9','#fc97af','#87f7cf','#001852','#72ccff','#f7c5a0','#e01f54','#d2f5a6','#76f2f2','#516b91','#59c4e6','#edafda','#93b7e3','#a5e7f0','#cbb0e3','#588dd5','#f5994e','#ffb980','#5ab1ef','#b6a2de','#2ec7c9','#fc97af','#87f7cf','#001852','#72ccff','#f7c5a0','#e01f54','#d2f5a6','#76f2f2','#516b91','#59c4e6','#edafda','#93b7e3','#a5e7f0','#cbb0e3','#588dd5','#f5994e',]
                        },
            			textStyle:{            	
                        	fontWeight:'bold'
                        },                        
                        categories:leg
                    },                
                    tooltip: {                        
                    showDelay: 0,
                    trigger: 'item',            
                     // formatter:'{c}'          
                        formatter: function (params) {
                        	//console.log(params.value);
                        if (params.value.length > 1) {
                        	 return '<span style="font-weight:bold">'+'Cell type: '+params.value[2]+'</span>'+'<br/>'+
                             params.name +'<br/>'+'('
                             + params.value[0]+','+params.value[1]+')' ; 
                        }
                        else {
                            return params.seriesName + ' :<br/>'
                            + params.name + ' : '
                            + params.value ;
                        }
                    },
                    axisPointer: {
                        show: true,
                        type: 'cross',
                        
                        lineStyle: {
                            type: 'dashed',
                            width: 1
                        }
                    }
                },                               
                    xAxis: {                    	
                    name:"tSNE1",
                    nameLocation:"middle",//middle start end
                     nameTextStyle:{
                        
                          fontWeight : 'bolder',
                          fontSize : 14,
                    },
                    
                    nameGap:30,
                   
                },   
                   yAxis: {
                    name:"tSNE2",
                    nameLocation:"middle",//middle start end
                    nameGap:30,
                    nameTextStyle:{            
                          fontWeight : 'bolder',
                          fontSize : 14              
                    },
                },        
                    series: [{
                    //    name: 'price-area',
                        type: 'scatter',
                       animationDelay: function (idx) {
                        return idx * 5;
                        },
                        symbolSize:3,                                
                        data: data_left1,
                        /*markPoint: {
                            data: [{name:'OX1164@TGGCCAGGTTCGTGAT-1',xAxis:20.8306,yAxis:-5.683},],
                            symbol:'image://my_images/dangqian.png',
                            symbolSize: 30,
                          
                             itemStyle: {
                             normal: {
                                 borderWidth: 2,
                                 borderColor: '#fff',
                             }
                     },
                            
                            tooltip: {
                                trigger: 'item',
                                position: 'top',
                                formatter: function(x) {
                                    
                                    return 'Cell:'+x.name
                                }
                            }
                        }*/
                    },                        
                    ],
                     animationEasing: 'elasticIn'                
                };
myChart.setOption(option);
</script>
<%} %>
<!-- --------------------------------聚类图end--------------------------- -->
<%
/*-----------------------------------聚类图(带表达值)start------------------------*/
if(expr3.equals("NONE")){
}else{%>
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> expression</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tiss);%></small></p>
        <div id="clusterec" class="cluster_e"></div>
      </div>
    </div>
  </div>
</div>
<script>
var myChart = echarts.init(document.getElementById('clusterec'));
var data_right1 = [
             	 <% 
             	 for(int p=0;p<scat3ldz1_0.length;p++){
             		  String[] scat3ldz2_0 = scat3ldz1_0[p].split(",");
             		  String[] scat3ldz2_1 = scat3ldz1_1[p].split(",");
             		  String[] scat3ldz2_2 = scat3ldz1_2[p].split(",");
             		  String[] scat3ldz2_3 = scat3ldz1_3[p].split(",");
             		  String[] scat3ldz2_4 = scat3ldz1_4[p].split(",");
                	  for(int q=0;q<scat3ldz2_0.length;q++){
                		  out.println("{name:'"+scat3ldz2_1[q]+"'"+",");//symbol
                		  out.println("value:[");
                		  out.println(scat3ldz2_3[q]+",");//x
                		  out.println(scat3ldz2_4[q]+",");//y
                		  out.println("'"+scat3ldz2_0[q]+"'");//exp
                		  out.println("],},");
                	  }
                }
                  %>
             ];
option = {
        <%--title: {
               text: <%out.println("'"+NODE+" expression'");%><%//out.println("'"+NODE+"'+' expression of cell clusters in '+'"+tissue_pd+"'");%>,
               right: 490,
               top: 10, 
               subtext:<%out.println("'Tissue: "+select_tiss+"'");%>,                     
                },--%>
                grid: {
                    left: '5%',
                    right: '10%',
                    bottom: '10%',
                    top:'15%',
                    containLabel: true
                },
                brush: {
                    xAxisIndex: 'all',
                    yAxisIndex: 'all',
                    toolbox:['rect', 'polygon', 'clear'],
                    brushStyle:{                	
                    	    borderWidth: 1,
                    	    color: 'rgba(242, 135, 5,0.3)',
                    	    borderColor: 'rgba(242, 135, 5,0.8)'
                    	
                    },
                    outOfBrush: {
                        colorAlpha: 0.1
                    }
                },
                toolbox:{
                    show:true,
                    showTitle:true,
                    top:8,
                    left:40,
                    feature:{
                        dataView:{
                            show:true,
                            title:'Data View',
                            lang:['Data View','Close','Refresh'],
                            buttonColor : '#F28705',
                            optionToContent: function(opt) {                           
                                var series = opt.series;                          
                                //console.log(series);                           
                                var length=series[0].data.length  //get length                          
                                //console.log(length);                                                        
                                var name=series[0].data[1].name;
                               // console.log(name);                           
                                var x=series[0].data[1].value[0];
                               // console.log(x);                 
                                var table = '<table  class="altrowstable"  style="width:100%;text-align:center"><tbody><tr>'
                                             + '<td>Cell name</td>'
                                             + '<td>x</td>'
                                             + '<td>y</td>'
                                             + '<td>Exp</td>'
                                             + '</tr>';
                                for (var i = 0, l = length; i < l; i++) {
                                    table += '<tr>'
                                             + '<td>' + series[0].data[i].name + '</td>'
                                             + '<td>' + series[0].data[i].value[0] + '</td>'
                                             + '<td>' + series[0].data[i].value[1] + '</td>'
                                             + '<td>' + series[0].data[i].value[2] + '</td>'
                                             + '</tr>';
                                }
                                table += '</tbody></table>';
                                return table;
                            } 
                        },
                        //
                        restore:{
                            show:true,
                            title:'Restore'
                        },
                        saveAsImage:{
                            show:true,
                            title:'Save As Image'
                        },
                        //
                        dataZoom:{
                            show:true,
                            title:{
                            	zoom:'Zoom Region',
                            	back:'Zoom Region Back'
                            }
                        },
                        brush:{
                        	title:{rect:'Rectangular Region',polygon : 'Polygon Region',clear : 'Clear Region'}
                        }
                    },
                     iconStyle:{
                    	bordercolor:'#F28705'
                    } 
                },
                visualMap: {
                    min: 0.0,          
                    max: <%=cancermax%>,  
                    padding: [
                 	    10,  //
                 	    0, //
                 	    5,  //
                 	    10, //
                 	],
                    orient: 'vertical',
                    right: 0,
                    top: 'center',
                    text: ['Value', ''],
                    precision:3,
                    calculable: true,
                    inRange: {
                       /*   color: ['#D3D2D2','#FE5C00'], */
                      // color:['rgba(211,211,211,0.1)','#FFAA8E','#FF8B73','#FF6D58','#F54E3F','#d32c26'],
                    	color: ['#D3D3D5', '#2911FA', 'red'],
                    },
					textStyle:{
                    	
                    	fontWeight:'bold'
                    }
                },
                tooltip: {
                    showDelay: 0,
                    trigger: 'item',
                  //formatter:'{c}'
                    formatter: function (params) {
                    if (params.value.length > 1) { 	
                        return '<span style="font-weight:bold">'+'Exp:'+params.value[2]+'</span>'+'<br/>'+
                        params.name +'<br/>'+'('
                        + params.value[0]+','+params.value[1]+')' ; 
                    }
                    else {
                        return params.seriesName + ' :<br/>'
                        + params.name + ' : '
                        + params.value ;
                    }
                },
                axisPointer: {
                    show: true,
                    type: 'cross',
                    lineStyle: {
                        type: 'dashed',
                        width: 1
                    }
                }
            },
            xAxis: {
                name:"tSNE1",
                nameLocation:"middle",//middle start end
                nameTextStyle:{
                      fontWeight : 'bolder',
                      fontSize : 14,
                },
                nameGap:30,
            },
            yAxis: {
                name:"tSNE2",
                nameLocation:"middle",//middle start end
                nameGap:30,
                nameTextStyle:{
                       fontWeight : 'bolder',
                       fontSize : 14,
                       },
            },
            series: [{
                    type: 'scatter',
                    symbolSize: 3,
                       animationDelay: function (idx) {
                            return idx *5;
                            },
                      //symbolSize : 10,
                    data: data_right1
                },
                ],
        animationEasing: 'elasticIn'
   };
myChart.setOption(option);
</script>
<%}
/*--------------------------------------聚类图(带表达)end-----------------------------*/
%>
</div>	
<%}else{//geo tiger%>
<%//geo tiger max mean表格	
	//max mean表格
	out.println("<table id='geo' class='table-lyj round-border row-distance' style='width:100%;'>");
	out.println("<thead>");
	out.println("<tr class='single'>");
	out.println("<th>");
		out.println("Cancer");
	out.println("</th>");
	out.println("<th>");
		out.println("CE cell");
	out.println("</th>");
	out.println("<th>");
		out.println("Classification");
	out.println("</th>");
	out.println("<th title='Exp. in the CE cell'>");
		out.println("Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("<th title='Max Exp. in other cell'>");
		out.println("Max Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("<th title='Mean Exp. in other cell'>");
		out.println("Mean Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("</tr>");
	out.println("</thead>");	
	out.println("<tbody>");	
	List<String> celltt1 = new ArrayList<String>();
	List<String> clasii1 = new ArrayList<String>();
	List<String> cellexp1 = new ArrayList<String>();
	List<String> maxx1 = new ArrayList<String>();
	List<String> meann1 = new ArrayList<String>();
	db.open();
	sel = "select * from "+select_sour+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + select_tiss + "' and dataset='"+select_gse+"' ";
	rs = db.execute(sel);
	rs.beforeFirst();
	while(rs.next()){
		celltt1.add(rs.getString("cell_fullname").replace("/"," or "));
		clasii1.add(rs.getString("classification"));
		cellexp1.add(rs.getString("cell_exp"));
		maxx1.add(rs.getString("remain_max"));
		meann1.add(rs.getString("remain_mean"));
	}	
	rs.close();
	db.close();
	
	int cesize1 = celltt1.size();
	out.println("<tr>");
	out.println("<td title=\""+cancer_fullname.get(select_tiss)+"\">");
		out.println(select_tiss);
		//out.println("<span class=\"glyphicon glyphicon-question-sign\" title=\""+cancer_fullname.get(select_tiss)+"\"></span>");
		out.println("<img src=\"images/help.svg\">");
	out.println("</td>");
	out.println("<td style='color:#525acd'>");
	for(int j=0;j<cesize1;j++){												
		out.println(celltt1.get(j)+"<br/>");													
	}
	out.println("</td>");
	out.println("<td>");
	for(int j=0;j<cesize1;j++){					
		out.println(clasii1.get(j));
		//out.println("<span title=\""+hash_fullna.get(clasii1.get(j))+" : "+hash_description.get(clasii1.get(j))+"\" class=\"glyphicon glyphicon-question-sign\"></span>");						
		out.println("<img title=\""+hash_fullna.get(clasii1.get(j))+" : "+hash_description.get(clasii1.get(j))+"\" src=\"images/help.svg\">");
		out.println("<br/>");
	}
	out.println("</td>");
	out.println("<td>");	
	for(int j=0;j<cesize1;j++){						
			out.println(String.format("%.4f",Double.valueOf(cellexp1.get(j)))+"<br/>");						
	}
	out.println("</td>");
	out.println("<td>");
	for(int j=0;j<cesize1;j++){
			out.println(String.format("%.4f",Double.valueOf(maxx1.get(j)))+"<br/>");
	}
	out.println("</td>");
	out.println("<td>");
	for(int j=0;j<cesize1;j++){
			out.println(String.format("%.4f",Double.valueOf(meann1.get(j)))+"<br/>");
	}
	out.println("</td>");
	out.println("</tr>");
out.println("</tbody>");
out.println("</table>");
%>
<!-- 柱状图start -->
<%
db.open();
sel = "select * from "+select_sour+"_"+a_f+"_lncexp where result=\""+NODE+"\" and tissue_type='"+select_tiss+"_"+select_gse+"'";
rs=db.execute(sel);
ResultSetMetaData data4 = rs.getMetaData();
int col_cell4=data4.getColumnCount();//获取细胞类型的个数
List<String> oldcol4 = new ArrayList<String>();
List<String> coln4 = new ArrayList<String>();
List<String> vv4 = new ArrayList<String>();
List<String> colname4 = new ArrayList<String>();
List<String> v4 = new ArrayList<String>();
while(rs.next()){
	for(int g=4;g<=col_cell4;g++){
		if(rs.getString(g).equals("NA")){
		}else{
		oldcol4.add(data4.getColumnName(g));
		}
	}
}
Collections.sort(oldcol4);
rs.beforeFirst();
while(rs.next()){
	for(int g=0;g<oldcol4.size();g++){
		coln4.add(oldcol4.get(g));
		vv4.add(rs.getString(oldcol4.get(g)));
	}
}
rs.close();
db.close();
//去重列名和对应的值
	for(int k=0;k<coln4.size();k++){
		if(!colname4.contains(coln4.get(k))){
			colname4.add(coln4.get(k));
			v4.add(vv4.get(k));
		}
	}
%>
<script>
$(document).ready(function(){
    $('#geo').DataTable(
    {
    	"filter":false,
    	"bLengthChange": false,
    }		
    );
});   
</script>

<%if(v4.size()>0){ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Mean Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(select_tiss);%></small></p>
        <div class="bar" id="bar_c3"></div>
      </div>
    </div>
 
<script>
				var chartDom = document.getElementById('bar_c3');
				var myChart = echarts.init(chartDom);
				var option;

				option = {
					<%--title: {
						text: 'Expression level of <%=NODE%>',
						subtext:'Tissue: '+<%out.println("'"+tissue_pd+"'");%>,
						left: "center",
					    top: "10px",
					    textStyle: {
					      fontSize: 19
					    }
					},--%>
					xAxis: {
				    type: 'category',
				    axisLabel: {
				        rotate: 90
				      },
				    data: <%
				   		 out.println("[");
				    	for(int ee=0;ee<colname4.size()-1;ee++){
				    		out.println("'"+colname4.get(ee)+"'"+",");
				    	}
				    	out.println("'"+colname4.get(colname4.size()-1)+"'");
				    	out.println("]");
				    %>
				  },
				  yAxis: {
				    type: 'value',
				    name:"CPM",
				    nameLocation: "middle",
				    nameTextStyle: {
				      fontSize: 16,
				      align: "center",
				      lineHeight: 70
				    }
				   },				  
					tooltip: {
						// head + 每个 point + footer 拼接成完整的 table
						headerFormat: '<table>',
						pointFormat: '<tr><td colspan="3">{point.description}</td></tr>'+
						'<tr><td style="width:10px;color:{series.color};padding:0">{series.name}: </td>' +
						'<td style="padding:0;text-align:left"><b>{point.y}</b></td></tr>',
						footerFormat: '</table>',
						shared: true,
						useHTML: true,
					},
					grid: {
					    bottom:120,
					    left:80
					  },
				  series: [
				    {
				      data: <%
				   		 out.println("[");
			    	for(int ee=0;ee<v4.size()-1;ee++){
			    		 out.println(v4.get(ee)+",");
			    	}
			    	out.println(v4.get(v4.size()-1));
			    	out.println("]");
			    	%>,
				      type: 'bar',
				      name: 'mean of expression',
				      showBackground: true,
				      backgroundStyle: {
				        color: 'rgba(180, 180, 180, 0.2)'
				      },
				      itemStyle: {
	                        normal: {
	                            color: function(params) {
	                            	<%
	                                /*int colorlen=v0.size();
	                                int cor1=0;
	                                out.println("var colorList0 = ['#5470c6', '#91cc75', '#fac858', '#ee6666', '#73c0de', '#3ba272', '#fc8452', '#9a60b4', '#ea7ccc'];");
	                                out.println("var colorList = new Array("+colorlen+");");
	                                for(int cor=0;cor<v0.size();cor++){
	                                	if(cor1<9){
	                                		out.println("colorList["+cor+"]=colorList0["+cor1+"]");
	                                		cor1++;
	                                	}else{
	                                		cor1=0;
	                                		out.println("colorList["+cor+"]=colorList0["+cor1+"]");
	                                	}
	                                }*/
	                                %>
	                                //return colorList[params.dataIndex];
	                            	<%int celllen4 = celltt1.size();
                            		out.println("var cellList = new Array("+celllen4+");");
                            		for(int co=0;co<celllen4;co++){
                            		out.println("cellList["+co+"]="+"'"+celltt1.get(co)+"'");
                            		}
                            		%>
                               	 	var c ='';
                            		if(cellList.includes(params.name)){
                                    	c='#525acd'
                                	}else{
                                   		c='#bfbfbf'
                                	}
                                	return c;
	                            }
	                        }
	                    }
				    }
				  ]
				};
myChart.setOption(option);
</script>
<!-- 柱状图 end -->
<%} %>		
<%/*查询detail*/
					db.open();
					sel="select * from "+select_sour+"_"+a_f+"_detail where Gene IN ('cell','cell_type','tsne_x','tsne_y',\""+NODE+"\") ORDER BY FIELD(Gene,\""+NODE+"\",'cell','cell_type','tsne_x','tsne_y')";
					rs=db.execute(sel);
						List<String> scat_4 = new ArrayList<String>();//
						List<String> cell_type4 = new ArrayList<String>();//细胞类型
						//List<String> cell_type5 = new ArrayList<String>();
						//rs.beforeFirst();
						while(rs.next()){
							scat_4.add(rs.getString(select_tiss+"_"+select_gse));
						}
						rs.close();
						db.close();
						
						//查询表达max
						String cancermax1="";
						db.open();
						sel="select * from "+select_sour+"_"+a_f+"_max where Gene = \""+NODE+"\"";
						rs=db.execute(sel);
						while(rs.next()){
							cancermax1=rs.getString(select_tiss+"_"+select_gse);
						}
						rs.close();
						db.close();	
						
						  String[] scat0ldz1_0 = scat_4.get(0).split(";");
			              String[] scat0ldz1_1 = scat_4.get(1).split(";");
			              String[] scat0ldz1_2 = scat_4.get(2).split(";");
			              String[] scat0ldz1_3 = scat_4.get(3).split(";");
			              String[] scat0ldz1_4 = scat_4.get(4).split(";");
						
						for(int p=0;p<scat0ldz1_2.length;p++){
							cell_type4.add(scat0ldz1_2[p]);
						}
						//去重细胞类型
			        	  List<String> celltype_uniq4 = new ArrayList<String>();
			        	  for(int p=0;p<cell_type4.size();p++){
			        		  celltype_uniq4.add(cell_type4.get(p).split(",")[0]);
			        	  }
			        	  String ex4=scat_4.get(0).split(",")[0];
						%>
<%if(ex4.equals("NONE")){		
}else{%>
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(select_tiss);%></small></p>
        <div id="boxplot_c3" class="vilo"></div>
      </div>
    </div>
  </div>
</div>
<script>
//let Plotly = require('viloin/plotly-2.16.1.min.js');
//initViolin(){  //渲染violin图
    let rows_2 = [
      <%
      int sca=scat0ldz1_0.length;
      for(int p=0;p<sca;p++){
      	String[] scat0ldz2_0 = scat0ldz1_0[p].split(",");
      	int sca2=scat0ldz2_0.length;
      	for(int q=0;q<sca2;q++){
      		out.println("{");
      			out.println("EXPRESSION_VALUE:"+scat0ldz2_0[q]+",");
      			out.println("GROUP_NAME:"+"\""+celltype_uniq4.get(p)+"\""+",");
      			out.println("GROUP_SHORT:"+"\""+celltype_uniq4.get(p)+"\""+",");
      		out.println("},");;		
      	}		
      }
      %>     
    ];
    function unpack(rows_2, key) {
      return rows_2.map(function(row) { return row[key]; });
    }
    let data_2 = [{
      type: 'violin',
      x: unpack(rows_2, 'GROUP_SHORT'),
      y: unpack(rows_2, 'EXPRESSION_VALUE'),
      //points: 'none',
      //hoverinfo: 'skip',//hover不显示数据信息
      box: {
        visible: true
      },
      line: {
        color: 'green',
      },
      /*fillcolor: 'cornflowerblue',
      opacity: 0.6,*/
      meanline: {
        visible: true
      },
      boxpoints: 'all',
      jitter: 1,
      pointpos: 0,//设置与小提琴相关的采样点的位置。如果“0”，则采样点位于小提琴中心上方。正(负)值对应垂直小提琴的右(左)位，水平小提琴的上(下)位。
      showlegend: false,//图例
      transforms: [{
        type: 'groupby',
        groups: unpack(rows_2, 'GROUP_SHORT'),
        styles: [
          <% 
          for(int q=0;q<celltype_uniq4.size();q++){
             out.println("{target:"+"'"+celltype_uniq4.get(q)+"'"+","+"value: {line: {color: '"+volcolor[q]+"'}}},");
           }
          %>
        ],
      }]
    }]

    let layout_2 = {
      <%--title: "Expression level of <%=NODE%><br>"+'Tissue: '+<%out.println("'"+tissue_pd+"'");%>,--%>
      /*font:{
    	  family:'Microsoft YaHei',
    	  size:14
      },*/
      xaxis: {
        "tickangle": -90,//倾斜角度
        title: {
        },
        position:[0,0.8]      
      },
      yaxis: {
        zeroline: false,
        title: {
          text: 'CPM'
        },
      //rangemode:'nonnegative',//截断图
      rangeselector:{
        font:{
    	  size:1
    	}
      }
      },
      height: 600,
      margin:{
    	  b:180,
    	  //left:190
      },
      legend:{
    	  title:{
    		  text:"Cell type"
    	  },
          itemwidth:10 
      }
    }

    Plotly.newPlot('boxplot_c3', data_2, layout_2, {showSendToCloud: true});
  //},
</script>
<%}%>
<!-- -------------------------------聚类图start-------------------------------- -->
<%if(ex4.equals("NONE")){
}else{ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b>Cell clustering based on highly variable genes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(select_tiss);%></small></p>
        <div id="cluster_c3" class="cluster_e"></div>
      </div>
    </div>
 
<script>
var myChart = echarts.init(document.getElementById('cluster_c3'));
var data_leftc = [
            	 <% 
            	 for(int p=0;p<scat0ldz1_0.length;p++){
               	  String[] scat0ldz2_0 = scat0ldz1_0[p].split(",");
               	  String[] scat0ldz2_1 = scat0ldz1_1[p].split(",");
               	  String[] scat0ldz2_2 = scat0ldz1_2[p].split(",");
               	  String[] scat0ldz2_3 = scat0ldz1_3[p].split(",");
               	  String[] scat0ldz2_4 = scat0ldz1_4[p].split(",");
               	  for(int q=0;q<scat0ldz2_0.length;q++){
               		  out.println("{name:'"+scat0ldz2_1[q]+"'"+",");//symbol
               		  out.println("value:[");
               		  out.println(scat0ldz2_3[q]+",");//x
                   	  out.println(scat0ldz2_4[q]+",");//y      	  
                   	  out.println("'"+scat0ldz2_2[q].replace("/"," or ")+"'");//celltype
                   	  out.println("],},");
               	  }
               }
                 %>
            ];
            var leg = [
            	<%
            	for(int q=0;q<celltype_uniq4.size();q++){
            		out.println("'" +celltype_uniq4.get(q).replace("/"," or ")+"'"+",");
            	}
            	%>
            ];
            option = {       	    
                    <%--title: {
                        text: 'Cell clusters'<%//out.println("'Cell clusters in '+'"+tissue_pd+"'");%>,
                        right:550,
                        top: 10,
                        subtext:'Tissue: '+<%out.println("'"+select_tiss+"'");%>   
                    },--%>
                    brush: {
                        xAxisIndex: 'all',
                        yAxisIndex: 'all',
                        toolbox:['rect', 'polygon', 'clear'],
                        brushStyle:{                	
                        	    borderWidth: 1,
                        	    color: 'rgba(242, 135, 5,0.3)',
                        	    borderColor: 'rgba(242, 135, 5,0.8)'            	
                        },
                        outOfBrush: {
                            colorAlpha: 0.1
                        }
                    },        
                    grid: {
                        left: '5%',
                        right: '10%',
                        bottom: '10%',
                        top:'15%',
                        containLabel: true
                    },        
                  toolbox:{
                	  show:true,
                      showTitle:true,
                      top:8,
                      left:40,
                      feature:{                            
                          dataView:{
                              show:true,
                              title:'Data View',
                              lang:['Data View','Close','Refresh'],
                              buttonColor : '#F28705',
                              optionToContent: function(opt) {                           
                                  var series = opt.series;                          
                                  //console.log(series);                           
                                  var length=series[0].data.length  //get length                          
                                  //console.log(length);                                                        
                                  var name=series[0].data[1].name;
                                 // console.log(name);                           
                                  var x=series[0].data[1].value[0];
                                 // console.log(x);                 
                                  var table = '<table  class="altrowstable"  style="width:100%;text-align:center"><tbody><tr>'
                                               + '<td>Cell name</td>'
                                               + '<td>x</td>'
                                               + '<td>y</td>'
                                               + '<td>cell_type</td>'
                                               + '</tr>';
                                  for (var i = 0, l = length; i < l; i++) {
                                      table += '<tr>'
                                               + '<td>' + series[0].data[i].name + '</td>'
                                               + '<td>' + series[0].data[i].value[0] + '</td>'
                                               + '<td>' + series[0].data[i].value[1] + '</td>'
                                               + '<td>' + series[0].data[i].value[2] + '</td>'
                                               + '</tr>';
                                  }
                                  table += '</tbody></table>';
                                  return table;
                              } 
                          },
                          restore:{
                              show:true,
                              title:'Restore'
                          },
                          saveAsImage:{
                              show:true,
                              title:'Save As Image'
                          },
                          //
                          dataZoom:{
                              show:true,
                              title:{
                              	zoom:'Zoom Region',
                              	back:'Zoom Region Back'
                              }
                          },
                          brush:{
                          	title:{rect:'Rectangular Region',polygon : 'Polygon Region',clear : 'Clear Region'}
                          }                          
                      }},                                        
                    visualMap: {            
                    	type :'piecewise',
                         padding: [
                        	    10,  // 
                        	    0, // 
                        	    5,  //
                        	    10, //
                        	],
                       	showLabel:true, 
                        itemHeight:10,  
                        itemGap:5,                    
                        orient: 'vertical',
                        right: 0,
                        top: 'center',
                        text: ['Cell type',''],
                    
                        calculable: true,
                        inRange: {
                        	  symbol:'circle', color:['#ffb980','#5ab1ef','#b6a2de','#2ec7c9','#fc97af','#87f7cf','#001852','#72ccff','#f7c5a0','#e01f54','#d2f5a6','#76f2f2','#516b91','#59c4e6','#edafda','#93b7e3','#a5e7f0','#cbb0e3','#588dd5','#f5994e','#ffb980','#5ab1ef','#b6a2de','#2ec7c9','#fc97af','#87f7cf','#001852','#72ccff','#f7c5a0','#e01f54','#d2f5a6','#76f2f2','#516b91','#59c4e6','#edafda','#93b7e3','#a5e7f0','#cbb0e3','#588dd5','#f5994e',]
                        },
            			textStyle:{            	
                        	fontWeight:'bold'
                        },                        
                        categories:leg
                    },                
                    tooltip: {                        
                    showDelay: 0,
                    trigger: 'item',            
                     // formatter:'{c}'          
                        formatter: function (params) {
                        	//console.log(params.value);
                        if (params.value.length > 1) {
                        	 return '<span style="font-weight:bold">'+'Cell type: '+params.value[2]+'</span>'+'<br/>'+
                             params.name +'<br/>'+'('
                             + params.value[0]+','+params.value[1]+')' ; 
                        }
                        else {
                            return params.seriesName + ' :<br/>'
                            + params.name + ' : '
                            + params.value ;
                        }
                    },
                    axisPointer: {
                        show: true,
                        type: 'cross',
                        
                        lineStyle: {
                            type: 'dashed',
                            width: 1
                        }
                    }
                },                               
                    xAxis: {                    	
                    name:"tSNE1",
                    nameLocation:"middle",//middle start end
                     nameTextStyle:{
                        
                          fontWeight : 'bolder',
                          fontSize : 14,
                    },
                    
                    nameGap:30,
                   
                },   
                   yAxis: {
                    name:"tSNE2",
                    nameLocation:"middle",//middle start end
                    nameGap:30,
                    nameTextStyle:{            
                          fontWeight : 'bolder',
                          fontSize : 14              
                    },
                },        
                    series: [{
                    //    name: 'price-area',
                        type: 'scatter',
                       animationDelay: function (idx) {
                        return idx * 5;
                        },
                        symbolSize:3,                                
                        data: data_leftc,
                        /*markPoint: {
                            data: [{name:'OX1164@TGGCCAGGTTCGTGAT-1',xAxis:20.8306,yAxis:-5.683},],
                            symbol:'image://my_images/dangqian.png',
                            symbolSize: 30,
                          
                             itemStyle: {
                             normal: {
                                 borderWidth: 2,
                                 borderColor: '#fff',
                             }
                     },
                            
                            tooltip: {
                                trigger: 'item',
                                position: 'top',
                                formatter: function(x) {
                                    
                                    return 'Cell:'+x.name
                                }
                            }
                        }*/
                    },                        
                    ],
                     animationEasing: 'elasticIn'                
                };
myChart.setOption(option);
</script>
<%} %>
<!-- --------------------------------聚类图end--------------------------- -->
<%
/*-----------------------------------聚类图(带表达值)start------------------------*/
if(ex4.equals("NONE")){
}else{%>
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> expression</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(select_tiss);%></small></p>
        <div id="cluster_ce3" class="cluster_e"></div>
      </div>
    </div>
  </div>
</div>
<script>
var myChart = echarts.init(document.getElementById('cluster_ce3'));
var data_rightc = [
             	 <% 
             	 for(int p=0;p<scat0ldz1_0.length;p++){
             		  String[] scat0ldz2_0 = scat0ldz1_0[p].split(",");
             		  String[] scat0ldz2_1 = scat0ldz1_1[p].split(",");
             		  String[] scat0ldz2_2 = scat0ldz1_2[p].split(",");
             		  String[] scat0ldz2_3 = scat0ldz1_3[p].split(",");
             		  String[] scat0ldz2_4 = scat0ldz1_4[p].split(",");
                	  for(int q=0;q<scat0ldz2_0.length;q++){
                		  out.println("{name:'"+scat0ldz2_1[q]+"'"+",");//symbol
                		  out.println("value:[");
                		  out.println(scat0ldz2_3[q]+",");//x
                		  out.println(scat0ldz2_4[q]+",");//y
                		  out.println("'"+scat0ldz2_0[q]+"'");//exp
                		  out.println("],},");
                	  }
                }
                  %>
             ];
option = {
        <%--title: {
               text: <%out.println("'"+NODE+" expression'");%><%//out.println("'"+NODE+"'+' expression of cell clusters in '+'"+tissue_pd+"'");%>,
               right: 490,
               top: 10, 
               subtext:<%out.println("'Tissue: "+select_tiss+"'");%>,                     
                },--%>
                grid: {
                    left: '5%',
                    right: '10%',
                    bottom: '10%',
                    top:'15%',
                    containLabel: true
                },
                brush: {
                    xAxisIndex: 'all',
                    yAxisIndex: 'all',
                    toolbox:['rect', 'polygon', 'clear'],
                    brushStyle:{                	
                    	    borderWidth: 1,
                    	    color: 'rgba(242, 135, 5,0.3)',
                    	    borderColor: 'rgba(242, 135, 5,0.8)'
                    	
                    },
                    outOfBrush: {
                        colorAlpha: 0.1
                    }
                },
                toolbox:{
                    show:true,
                    showTitle:true,
                    top:8,
                    left:40,
                    feature:{
                        dataView:{
                            show:true,
                            title:'Data View',
                            lang:['Data View','Close','Refresh'],
                            buttonColor : '#F28705',
                            optionToContent: function(opt) {                           
                                var series = opt.series;                          
                                //console.log(series);                           
                                var length=series[0].data.length  //get length                          
                                //console.log(length);                                                        
                                var name=series[0].data[1].name;
                               // console.log(name);                           
                                var x=series[0].data[1].value[0];
                               // console.log(x);                 
                                var table = '<table  class="altrowstable"  style="width:100%;text-align:center"><tbody><tr>'
                                             + '<td>Cell name</td>'
                                             + '<td>x</td>'
                                             + '<td>y</td>'
                                             + '<td>Exp</td>'
                                             + '</tr>';
                                for (var i = 0, l = length; i < l; i++) {
                                    table += '<tr>'
                                             + '<td>' + series[0].data[i].name + '</td>'
                                             + '<td>' + series[0].data[i].value[0] + '</td>'
                                             + '<td>' + series[0].data[i].value[1] + '</td>'
                                             + '<td>' + series[0].data[i].value[2] + '</td>'
                                             + '</tr>';
                                }
                                table += '</tbody></table>';
                                return table;
                            } 
                        },
                        //
                        restore:{
                            show:true,
                            title:'Restore'
                        },
                        saveAsImage:{
                            show:true,
                            title:'Save As Image'
                        },
                        //
                        dataZoom:{
                            show:true,
                            title:{
                            	zoom:'Zoom Region',
                            	back:'Zoom Region Back'
                            }
                        },
                        brush:{
                        	title:{rect:'Rectangular Region',polygon : 'Polygon Region',clear : 'Clear Region'}
                        }
                    },
                     iconStyle:{
                    	bordercolor:'#F28705'
                    } 
                },
                visualMap: {
                    min: 0.0,          
                    max: <%=cancermax1%>,  
                    padding: [
                 	    10,  //
                 	    0, //
                 	    5,  //
                 	    10, //
                 	],
                    orient: 'vertical',
                    right: 0,
                    top: 'center',
                    text: ['Value', ''],
                    precision:3,
                    calculable: true,
                    inRange: {
                       /*   color: ['#D3D2D2','#FE5C00'], */
                      // color:['rgba(211,211,211,0.1)','#FFAA8E','#FF8B73','#FF6D58','#F54E3F','#d32c26'],
                    	color: ['#D3D3D5', '#2911FA', 'red'],
                    },
					textStyle:{
                    	
                    	fontWeight:'bold'
                    }
                },
                tooltip: {
                    showDelay: 0,
                    trigger: 'item',
                  //formatter:'{c}'
                    formatter: function (params) {
                    if (params.value.length > 1) { 	
                        return '<span style="font-weight:bold">'+'Exp:'+params.value[2]+'</span>'+'<br/>'+
                        params.name +'<br/>'+'('
                        + params.value[0]+','+params.value[1]+')' ; 
                    }
                    else {
                        return params.seriesName + ' :<br/>'
                        + params.name + ' : '
                        + params.value ;
                    }
                },
                axisPointer: {
                    show: true,
                    type: 'cross',
                    lineStyle: {
                        type: 'dashed',
                        width: 1
                    }
                }
            },
            xAxis: {
                name:"tSNE1",
                nameLocation:"middle",//middle start end
                nameTextStyle:{
                      fontWeight : 'bolder',
                      fontSize : 14,
                },
                nameGap:30,
            },
            yAxis: {
                name:"tSNE2",
                nameLocation:"middle",//middle start end
                nameGap:30,
                nameTextStyle:{
                       fontWeight : 'bolder',
                       fontSize : 14,
                       },
            },
            series: [{
                    type: 'scatter',
                    symbolSize: 3,
                       animationDelay: function (idx) {
                            return idx *5;
                            },
                      //symbolSize : 10,
                    data: data_rightc
                },
                ],
        animationEasing: 'elasticIn'
   };
myChart.setOption(option);
</script>
<%}
/*--------------------------------------聚类图(带表达)end-----------------------------*/
%>
<%//} %>
<%}//geo%>
	</div>
</div>
<!-- 内容 -->
		
</section>
</body>
</html>