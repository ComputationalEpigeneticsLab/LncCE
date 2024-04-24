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
<script src="js/iconify.min.js"></script>
<!-- datatable -->
<script src="jquery-ui-1.13.2/jquery-3.5.1.js" ></script>
<link rel="stylesheet" type="text/css" href="datatable/jquery.dataTables.min.css">
<script type="text/javascript" charset="utf8" src="datatable/jquery.dataTables.min.js"></script>
<!-- my -->
<script type="text/javascript" src="echarts/echarts.min.js"></script>
<script type="text/javascript" src="echarts/ecSimpleTransform.min.js"></script>
<script type="text/javascript" src="echarts/ecStat.min.js"></script>
<script src="viloin/plotly-2.18.2.min.js"></script>

<script type="text/javascript">
function submit4(){
	document.form4.action = 'cancer_details.jsp?#othersour';
	document.form4.submit();
}
</script>
</head>
<style>
.sesty{
font-size:21px;
text-align:left;
width: 523px; 
height: 45px;
border-width:3px;
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
<%
DBConn db1 = new DBConn();
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;

String location="";
String type="";
String rs_t = "";
String NODE=""; //gene的名字
String tissue_pd = "";//tissue_pd用于网络图进行判断是否是组织特异,同时用于判断癌症放到前面
String tissue_pd4="";
String a_f="";
String chr = request.getParameter("chr");
String ID = request.getParameter("Name");
String rs_a  = request.getParameter("classification");
String resource = request.getParameter("resource");
String cell=request.getParameter("celltype");
tissue_pd4 = request.getParameter("tissue");
String cell_pd = cell;
tissue_pd = tissue_pd4;
a_f = "adult";

NODE = request.getParameter("NODE");

String broad_cancer = request.getParameter("broad");

String tmp_can = "";
//查询tissue_pd对应的组织
String pd_tiss="";
db.open();
sel = "select tissue from cancer_tissue where cancer ='" + tissue_pd + "' ";
rs = db.execute(sel);
while(rs.next()){
	String tt=rs.getString("tissue");
	if(tt.equals("NONE")){}else{
		pd_tiss=tt;
	}
}
/*查询大类癌症对应的小类癌症*/
sel = "select cancer from cancer_other where broad='"+broad_cancer+"'" ;
rs=db.execute(sel); 
while(rs.next()){
	tmp_can = rs.getString("cancer");
}
rs.close();
db.close();

%>
<%
/*cancer*/
String re_can = "";
if(tmp_can.contains(";")){
	String[] tmp_broad_cancer = tmp_can.split(";");
	int mylen = tmp_broad_cancer.length;
	for(int lyj=0;lyj<mylen-1;lyj++){		
			re_can += "'"+tmp_broad_cancer[lyj]+"',";	
	}	
	re_can += "'"+tmp_broad_cancer[mylen-1]+"'";
}else{
	re_can = "'"+tmp_can+"'";
}
int bt=1;
int yj=1;
int jy=1;
int yu=1;
int ji=1;
List<String> intesour = new ArrayList<String>();
List<String> intecancer = new ArrayList<String>();
String[] sour={"geo","tiger","other","cell_res"};
for(String i : sour){
List<String> integra_gse = new ArrayList<String>();
List<String> integra_cell = new ArrayList<String>();						
db.open();
sel = "select * from "+i+"_basic where ensembl_gene_id ='" + ID + "' and tissue IN ("+re_can+") and source='"+a_f+"'";
rs = db.execute(sel); 
rs.beforeFirst();
while(rs.next()){
	intecancer.add(rs.getString("tissue"));
	integra_cell.add(rs.getString("cell_fullname"));								
	if(i.equals("geo")||i.equals("tiger")){
		integra_gse.add(rs.getString("dataset"));
	}
}
rs.close();
db.close();
	
if(integra_cell.size()>0){
	//存储资源
	if(i.equals("geo")||i.equals("tiger")){
		for(int j=0;j<integra_gse.size();j++){
			intesour.add(integra_gse.get(j)+"="+i);
		}
	}else{
		intesour.add(i);
	}
	}
}
//癌症+资源
List<String> intecancer_sour0 = new ArrayList<String>();
List<String> intecancer_sour = new ArrayList<String>();
List<String> otherCancer_sour = new ArrayList<String>();
for(int j=0;j<intesour.size();j++){
	intecancer_sour0.add(intecancer.get(j)+";"+intesour.get(j));
}
//去重
for(int j=0;j<intecancer_sour0.size();j++){
	if(!intecancer_sour.contains(intecancer_sour0.get(j))){
		intecancer_sour.add(intecancer_sour0.get(j));
	}
}
//去除tissue_pd+resource
String tmp_cs = tissue_pd+";"+resource;
for(int n=0;n<intecancer_sour.size();n++){
	if(!intecancer_sour.get(n).equals(tmp_cs)){
		otherCancer_sour.add(intecancer_sour.get(n));
	}
}
//去重资源
/*List<String> intesour_uniq0 = new ArrayList<String>();
List<String> intesour_uniq = new ArrayList<String>();
for(int j=0;j<intesour.size();j++){
	if(!intesour_uniq0.contains(intesour.get(j))){
		intesour_uniq0.add(intesour.get(j));
	}
}
//去掉resource，存放其他资源
for(int n=0;n<intesour_uniq0.size();n++){
	if(!(intesour_uniq0.get(n).equals(resource))){
		intesour_uniq.add(intesour_uniq0.get(n));
	}
}*/
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

String[] volcolor = {"#ffb980","#5ab1ef","#b6a2de","#2ec7c9","#fc97af","#87f7cf","#001852","#72ccff",
		  "#f7c5a0","#e01f54","#d2f5a6","#76f2f2","#516b91","#59c4e6","#edafda","#93b7e3","#a5e7f0",
		  "#cbb0e3","#588dd5","#f5994e","#ffb980","#5ab1ef","#b6a2de","#2ec7c9","#fc97af","#87f7cf",
		  "#001852","#72ccff","#f7c5a0","#e01f54","#d2f5a6","#76f2f2","#516b91","#59c4e6","#edafda",
		  "#93b7e3","#a5e7f0","#cbb0e3","#588dd5","#f5994e","#ffb980","#5ab1ef","#b6a2de","#2ec7c9",
		  "#fc97af","#87f7cf","#001852","#72ccff",};

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
<body>     
<%String end_tispd = ((tissue_pd.replace("NA_","")).replace("_"," ")).replace("-"," "); %>
<div id="main-page">

<section id="content" style="background-color:#fff;">
<div class="heading">
<h4>
1) Spatial expression pattern of <span style="color:#525acd"><%=end_tispd %></span> tissue in the data resource of <span style="color:#525acd"><%=hash_resource.get(resource) %></span>
</h4>
</div>
<div class="content">

<% //max mean查询
if(resource.equals("cell_res")||resource.equals("other")||resource.equals("epn")){ %>	
<%  
	List<String> celltt = new ArrayList<String>();
	List<String> clasii = new ArrayList<String>();
	List<String> cellexp = new ArrayList<String>();
	List<String> maxx = new ArrayList<String>();
	List<String> meann = new ArrayList<String>();
	db.open();
	sel = "select * from "+resource+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + tissue_pd + "' and cell='"+cell+"' and seqnames='"+chr+"'";
	rs = db.execute(sel);
	rs.beforeFirst();
	while(rs.next()){
		celltt.add(rs.getString("cell_fullname"));
		clasii.add(rs.getString("classification"));
		cellexp.add(rs.getString("cell_exp"));
		maxx.add(rs.getString("remain_max"));
		meann.add(rs.getString("remain_mean"));
	}
	rs.close();
	db.close();
	
	db.open();
	sel = "select * from "+resource+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + tissue_pd + "' and cell!='"+cell+"' and seqnames='"+chr+"'";
	rs = db.execute(sel);
	rs.beforeFirst();
	while(rs.next()){
		celltt.add(rs.getString("cell_fullname"));
		clasii.add(rs.getString("classification"));
		cellexp.add(rs.getString("cell_exp"));
		maxx.add(rs.getString("remain_max"));
		meann.add(rs.getString("remain_mean"));
	}
	rs.close();
	db.close();
	//max mean表格
	out.println("<table id=\"cancer-table\" class='table-lyj round-border row-distance' style='width:100%'>");
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
	out.println("<th>");
		out.println("Subclassification");
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
	for(int g=0;g<celltt.size();g++){
		out.println("<tr>");
		out.println("<td title=\""+cancer_fullname.get(tissue_pd)+"\">");
			out.println(end_tispd);
			out.println("<img src=\"images/help.svg\">");
			//out.println("<span class=\"glyphicon glyphicon-question-sign\" title=\""+cancer_fullname.get(tissue_pd)+"\"></span>");
		out.println("</td>");
		out.println("<td style='color:#525acd'>");
			out.println(celltt.get(g));
		//out.println("<span class=\"glyphicon glyphicon-question-sign\"></span>");
		out.println("</td>");
		out.println("<td>");
			out.println("CE");
		out.println("</td>");
		out.println("<td title=\""+hash_fullna.get(clasii.get(g))+" : "+hash_description.get(clasii.get(g))+"\">");
			out.println(clasii.get(g));
			out.println("<img src=\"images/help.svg\">");
			//out.println("<span class=\"glyphicon glyphicon-question-sign\"></span>");
		out.println("</td>");
		out.println("<td>");
			out.println(String.format("%.4f",Double.valueOf(cellexp.get(g))));
		out.println("</td>");
		out.println("<td>");
		out.println(String.format("%.4f",Double.valueOf(maxx.get(g))));
			out.println("</td>");
		out.println("<td>");
			out.println(String.format("%.4f",Double.valueOf(meann.get(g))));
		out.println("</td>");
		out.println("</tr>");
	}
	out.println("</table>");
//柱状图查询
	db.open();
	sel = "select * from "+resource+"_"+a_f+"_lncexp where result=\""+NODE+"\" and tissue_type=\""+tissue_pd+"\"";
	rs=db.execute(sel);
	ResultSetMetaData data0 = rs.getMetaData();
	int col_cell0=data0.getColumnCount();//获取细胞类型的个数
	List<String> oldcol = new ArrayList<String>();
	List<String> coln = new ArrayList<String>();
	List<String> vv = new ArrayList<String>();
	List<String> colname0 = new ArrayList<String>();
	List<String> v0 = new ArrayList<String>();
	rs.beforeFirst();
	while(rs.next()){
		for(int g=4;g<=col_cell0;g++){
			if(rs.getString(g).equals("NA")){
			}else{
			oldcol.add(data0.getColumnName(g));
			}
		}
	}
	Collections.sort(oldcol);
	rs.beforeFirst();
	while(rs.next()){
		for(int g=0;g<oldcol.size();g++){
			coln.add(oldcol.get(g));
			vv.add(rs.getString(oldcol.get(g)));
		}
	}
	rs.close();
	db.close();
	//去重列名和对应的值
	for(int k=0;k<coln.size();k++){
		if(!colname0.contains(coln.get(k))){
			colname0.add(coln.get(k));
			v0.add(vv.get(k));
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
<%if(v0.size()>0){ %>
<!-- 柱状图 start-->
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Mean Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tispd);%></small></p>
        <div id="bar_c_re1" class="vilo"></div>
      </div>
    </div>
  
	<script>
				var chartDom = document.getElementById('bar_c_re1');
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
				        rotate:90
				      },
				    data: <%
				   		 out.println("[");
				    	for(int ee=0;ee<colname0.size()-1;ee++){
				    		out.println("'"+colname0.get(ee)+"'"+",");
				    	}
				    	out.println("'"+colname0.get(colname0.size()-1)+"'");
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
			    	for(int ee=0;ee<v0.size()-1;ee++){
			    		 out.println(v0.get(ee)+",");
			    	}
			    	out.println(v0.get(v0.size()-1));
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
	                            	<%int celllen = celltt.size();
                            		out.println("var cellList = new Array("+celllen+");");
                            		for(int co=0;co<celllen;co++){
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
<!-- 柱状图 end -->
<%} %>
<%/*查询detail*/
					db.open();
					sel="select * from "+resource+"_"+a_f+"_detail where Gene IN ('cell','cell_type','tsne_x','tsne_y',\""+NODE+"\") ORDER BY FIELD(Gene,\""+NODE+"\",'cell','cell_type','tsne_x','tsne_y')";
					rs=db.execute(sel);
						List<String> scat3 = new ArrayList<String>();//
						List<String> cell_type3 = new ArrayList<String>();//细胞类型
						//List<String> cell_type4 = new ArrayList<String>();
						rs.beforeFirst();
						while(rs.next()){
							scat3.add(rs.getString(tissue_pd));
						}
						rs.close();
						db.close();
						
						  String[] scat3ldz1_0 = scat3.get(0).split(";");
			              String[] scat3ldz1_1 = scat3.get(1).split(";");
			              String[] scat3ldz1_2 = scat3.get(2).split(";");
			              String[] scat3ldz1_3 = scat3.get(3).split(";");
			              String[] scat3ldz1_4 = scat3.get(4).split(";");
						
						//查询表达max
						String cancermax="";
						db.open();
						sel="select * from "+resource+"_"+a_f+"_max where Gene = \""+NODE+"\"";
						rs=db.execute(sel);
						while(rs.next()){
							cancermax=rs.getString(tissue_pd);
						}
						rs.close();
						db.close();
						
						for(int p=0;p<scat3ldz1_2.length;p++){
							cell_type3.add(scat3ldz1_2[p]);
						}
						//去重细胞类型
			        	  List<String> celltype_uniq3 = new ArrayList<String>();
			        	  for(int p=0;p<cell_type3.size();p++){
			        		  celltype_uniq3.add(cell_type3.get(p).split(",")[0]);
			        	  }
			        	  String expr3=scat3.get(0).split(",")[0];
						%>
<%
	if(expr3.equals("NONE")){
	}else{
/*---------------------------------小提琴图start----------------------------------*/
%>

    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tispd);%></small></p>
        <div id="viloin_c" class="vilo"></div>
      </div>
    </div>
  </div>
</div>
<script>
//let Plotly = require('viloin/plotly-2.16.1.min.js');
//initViolin(){  //渲染violin图
    let rows = [
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
    function unpack(rows, key) {
      return rows.map(function(row) { return row[key]; });
    }
    let data = [{
      type: 'violin',
      x: unpack(rows, 'GROUP_SHORT'),
      y: unpack(rows, 'EXPRESSION_VALUE'),
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
      box: {
    	visible: true
      },
      boxpoints: 'all',
      jitter: 1,
      pointpos: 0,//设置与小提琴相关的采样点的位置。如果“0”，则采样点位于小提琴中心上方。正(负)值对应垂直小提琴的右(左)位，水平小提琴的上(下)位。
      showlegend: false,//图例
      transforms: [{
        type: 'groupby',
        groups: unpack(rows, 'GROUP_SHORT'),
        styles: [
          <% 
          for(int q=0;q<celltype_uniq3.size();q++){
             out.println("{target:"+"'"+celltype_uniq3.get(q)+"'"+","+"value: {line: {color: '"+volcolor[q]+"'}}},");
           }
          %>
        ],
      }]
    }]

    let layout = {
      <%--title: "Expression level of <%=NODE%><br>"+'Tissue: '+<%out.println("'"+tissue_pd+"'");%>,--%>
      /*font:{
    	  family:'Microsoft YaHei',
    	  size:14
      },*/
      xaxis: {
        "tickangle": -90,//倾斜角度
        title: {
        },
        //position:[0,0.8]      
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
      //height: 600,
      margin:{
    	  b:180,
    	  //left:100
      },
      legend:{
    	  title:{
    		  text:"Cell type"
    	  },
          itemwidth:10 
      }
    }

    Plotly.newPlot('viloin_c', data, layout, {showSendToCloud: true});
  //},
</script>
<%}
/*----------------------------------小提琴图end----------------------------------*/
%>													
<!-- -------------------------------聚类图start-------------------------------- -->
<%if(expr3.equals("NONE")){
}else{ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b>Cell clustering based on highly variable genes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tispd);%></small></p>
        <div id="clusterc_re1" class="cluster_e"></div>
      </div>
    </div>
  
<script>
var myChart = echarts.init(document.getElementById('clusterc_re1'));
var data_left = [
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
        	text: 'Cell clusters'<%//out.println("'Cell clusters in '+'"+tissue_pd4+"'");%>,
            right:450,
            top: 10,
            subtext:'Tissue: '+<%out.println("'"+tissue_pd+"'");%>   
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
                                   + '<td>Cell type</td>'
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
            itemHeight:10,  itemGap:5,                    
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
            	 return '<span style="font-weight:bold">'+'cell_type: '+params.value[2]+'</span>'+'<br/>'+
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
            data: data_left,
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

    <div class="col">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> expression</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tispd);%></small></p>
        <div id="clusterec_re1" class="cluster_e"></div>
      </div>
    </div>
  </div>
</div>
<script>
var myChart = echarts.init(document.getElementById('clusterec_re1'));
var data_right = [
	 <% 
     for(int p=0;p<scat3ldz1_0.length;p++){
   	  String[] scat3ldz2_0 = scat3ldz1_0[p].split(",");
   	  String[] scat3ldz2_1 = scat3ldz1_1[p].split(",");
   	  //String[] scat3ldz2_2 = scat3ldz1_2[p].split(",");
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
               text: <%out.println("'"+NODE+" expression'");%><%//out.println("'"+NODE+"'+' expression of cell clusters in '+'"+tissue_pd4+"'");%>,
               right: 440,
               top: 10, 
               subtext:<%out.println("'Tissue: "+tissue_pd+"'");%>,                     
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
                    data: data_right
                },
                ],
        animationEasing: 'elasticIn'
   };
myChart.setOption(option);
</script>
<%}
/*--------------------------------------聚类图(带表达)end-----------------------------*/
%>	
<%}%>																					
<!-- resource end -->

<!-- other resource start-->
<%if(otherCancer_sour.size()==0){ %>
<div class="heading row-distance">
<h4>
2) Spatial expression pattern of <%=tissue_pd %> tissue in other resources
</h4>
</div>
<div>
<h3>No result!</h3>
</div>
<%}else if(otherCancer_sour.size()>0){ 	
//选择的资源
String slet_sour = request.getParameter("seother");
String slet_cancer = "";
String select_other = "";
String select_gse = "";
if(slet_sour==null){
	String other_sour = otherCancer_sour.get(0);
	String tmp_aa = other_sour.split(";")[0];
	String tmp_bb = other_sour.split(";")[1];
	if(tmp_bb.contains("=")){
			slet_cancer = tmp_aa;
			select_other = tmp_bb.split("=")[1];
			select_gse = tmp_bb.split("=")[0];
		}else{
			slet_cancer = tmp_aa;
			select_other = tmp_bb;
		}
}else{
		String tmp_cc = slet_sour.split(";")[0];
		String tmp_dd = slet_sour.split(";")[1];
		if(tmp_dd.contains("=")){			
			slet_cancer = tmp_cc;
			select_other = tmp_dd.split("=")[1];
			select_gse = tmp_dd.split("=")[0];
		}else{
			slet_cancer = tmp_cc;
			select_other = tmp_dd;
		}
}

%>
<div class="heading row-distance"><h4>2) Spatial expression pattern of <%=end_tispd%> tissue in other resources</h4></div>
<div>
<div>
<div>
<div>
     
<%//for(int k=0;k<intesour_uniq.size();k++){ //资源循环%> 
<div id="othersour" class="row-distance">
<form id="form4" name="form4">
<input type="hidden" name="value1" value=0.5>
<input type="hidden" name="tissue" value='<%=tissue_pd4 %>'>
<input type="hidden" name="mRNA_tissue" value="">
<input type="hidden" name="Name" value='<%=ID %>'>
<input type="hidden" name="classification" value='<%=rs_a %>'>
<input type="hidden" name="resource" value='<%=resource %>'>
<input type="hidden" name="celltype" value='<%=cell %>'>
<input type="hidden" name="chr" value='<%=chr %>'>
<input type="hidden" name="NODE" value='<%=NODE %>'>
<input type="hidden" name="broad" value='<%=broad_cancer %>'>
<select id="seother" class="sesty" name="seother">
<%
/*把选择的资源放在第一个*/
if(select_other.equals("geo")||select_other.equals("tiger")){
	out.println("<option value='"+slet_cancer+";"+select_gse+"="+select_other+"'>");
	out.println(slet_cancer+" ("+select_gse+")");
	out.println("</option>");
}else{
	out.println("<option value='"+slet_cancer+";"+slet_sour+"'>");
	out.println(slet_cancer+" ("+hash_resource.get(select_other)+")");
	out.println("</option>");
}
/*循环输出所有的癌症+资源*/
for(int se=0;se<otherCancer_sour.size();se++){		
	String other_cancer = otherCancer_sour.get(se).split(";")[0];
	String other_sour = otherCancer_sour.get(se).split(";")[1];
	out.println("<option value='"+otherCancer_sour.get(se)+"'>");			
		if(otherCancer_sour.get(se).contains("=")){
			out.println(other_cancer+" ("+other_sour.split("=")[0]+")");
		}else{
			out.println(other_cancer+" ("+hash_resource.get(other_sour)+")");
		}								
		out.println("</option>");
	}
%>
</select>
<button id="sour_btn4" type="submit" value="Submit" class="btn btn-dark" onclick="submit4()">Apply Filter</button>
</form>
</div>
<%//max mean查询
//geo tiger max mean表格
if(select_other.equals("geo")||select_other.equals("tiger")){
	//List<String> dataset = new ArrayList<String>();
	List<String> celltt1 = new ArrayList<String>();
	List<String> clasii1 = new ArrayList<String>();
	List<String> cellexp1 = new ArrayList<String>();
	List<String> maxx1 = new ArrayList<String>();
	List<String> meann1 = new ArrayList<String>();
	db.open();
	sel = "select * from "+select_other+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + slet_cancer + "' and dataset='" + select_gse + "' ";
	rs = db.execute(sel);
	rs.beforeFirst();
	while(rs.next()){
		//dataset.add(rs.getString("dataset"));
		celltt1.add(rs.getString("cell_fullname"));
		clasii1.add(rs.getString("classification"));
		cellexp1.add(rs.getString("cell_exp"));
		maxx1.add(rs.getString("remain_max"));
		meann1.add(rs.getString("remain_mean"));
	}
	rs.close();
	db.close();
	//max mean表格
	out.println("<table id='other-table' class='table-lyj row-distance round-border' style='width:100%'>");
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
	out.println("<th>");
		out.println("Subclassification");
	out.println("</th>");
	out.println("<th title='Exp. in the CE cell'>");
		out.println("Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th title='Max Exp. in other cell'>");
	out.println("<th>");
		out.println("Max Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("<th title='Mean Exp. in other cell'>");
		out.println("Mean Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("</tr>");
	for(int g=0;g<celltt1.size();g++){
		out.println("<tr>");
		out.println("<td title=\""+cancer_fullname.get(slet_cancer)+"\">");
			out.println(slet_cancer);
			out.println("<img src=\"images/help.svg\">");
		//out.println("<span class=\"glyphicon glyphicon-question-sign\" title=\""+cancer_fullname.get(tissue_pd)+"\"></span>");
		out.println("</td>");
		out.println("<td style='color:#525acd'>");
			out.println(celltt1.get(g));
		//out.println("<span class=\"glyphicon glyphicon-question-sign\"></span>");
		out.println("</td>");
		out.println("<td>");
			out.println("CE");
		out.println("</td>");
		out.println("<td title=\""+hash_fullna.get(clasii1.get(g))+" : "+hash_description.get(clasii1.get(g))+"\">");
			out.println(clasii1.get(g));
			out.println("<img src=\"images/help.svg\">");
			//out.println("<span class=\"glyphicon glyphicon-question-sign\"></span>");
		out.println("</td>");
		out.println("<td>");
			out.println(String.format("%.4f",Double.valueOf(cellexp1.get(g))));
		out.println("</td>");
		out.println("<td>");
			out.println(String.format("%.4f",Double.valueOf(maxx1.get(g))));
		out.println("</td>");
		out.println("<td>");
			out.println(String.format("%.4f",Double.valueOf(meann1.get(g))));
		out.println("</td>");
		out.println("</tr>");
	}
	out.println("</table>");
//柱状图查询	
	db.open();
	sel = "select * from "+select_other+"_"+a_f+"_lncexp where result=\""+NODE+"\" and tissue_type='"+slet_cancer+"_"+select_gse+"'";
	rs=db.execute(sel);
	ResultSetMetaData data0 = rs.getMetaData();
	int col_cell0=data0.getColumnCount();//获取细胞类型的个数
	List<String> oldcol1 = new ArrayList<String>();
	List<String> coln1 = new ArrayList<String>();
	List<String> vv1 = new ArrayList<String>();
	List<String> colname0 = new ArrayList<String>();
	List<String> v0 = new ArrayList<String>();
	while(rs.next()){
		for(int g=4;g<=col_cell0;g++){
			if(rs.getString(g).equals("NA")){
			}else{
			oldcol1.add(data0.getColumnName(g));
			}
		}
	}
	Collections.sort(oldcol1);
	rs.beforeFirst();
	while(rs.next()){
		for(int g=0;g<oldcol1.size();g++){
			coln1.add(oldcol1.get(g));
			vv1.add(rs.getString(oldcol1.get(g)));
		}
	}
	rs.close();
	db.close();		
	//去重列名和对应的值
		for(int k=0;k<coln1.size();k++){
			if(!colname0.contains(coln1.get(k))){
				colname0.add(coln1.get(k));
				v0.add(vv1.get(k));
			}
		}	
	%>
<script>
$(document).ready(function(){
    $('#other-table').DataTable(
    {
    	"filter":false,
    	"bLengthChange": false,
    }		
    );
});   
</script>
<!-- 柱状图 start-->
<%if(v0.size()>0){ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Mean Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(slet_cancer);%></small></p>
        <div id="bar_other" class="vilo"></div>
      </div>
    </div>
  
		<script>
					var chartDom = document.getElementById('bar_other');
					var myChart = echarts.init(chartDom);
					var option;

					option = {
					  <%--title:{
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
					    	for(int ee=0;ee<colname0.size()-1;ee++){
					    		out.println("'"+colname0.get(ee)+"'"+",");
					    	}
					    	out.println("'"+colname0.get(colname0.size()-1)+"'");
					    	out.println("]");
					    %>
					  },
					  yAxis: {
					    type: 'value',
					    name:'CPM',
					    nameLocation: "middle",
					    nameTextStyle: {
					      fontSize: 16,
					      align: "center",
					      lineHeight: 80
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
						    left:80,
						    //right: '10%',
						    bottom:120
						  },
					  series: [
					    {
					      data: <%
					   		 out.println("[");
				    	for(int ee=0;ee<v0.size()-1;ee++){
				    		 out.println(v0.get(ee)+",");
				    	}
				    	out.println(v0.get(v0.size()-1));
				    	out.println("]");
				    	%>,
					      type: 'bar',
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
		                            	<%int celllen1 = celltt1.size();
	                            			out.println("var cellList = new Array("+celllen1+");");
	                            		for(int co=0;co<celllen1;co++){
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
<%} %>
<!-- 柱状图 end -->	
<%/*查询detail*/				
					db.open();
					sel="select * from "+select_other+"_"+a_f+"_detail where Gene IN ('cell','cell_type','tsne_x','tsne_y',\""+NODE+"\") ORDER BY FIELD(Gene,\""+NODE+"\",'cell','cell_type','tsne_x','tsne_y')";
					rs=db.execute(sel);
						List<String> scat_0 = new ArrayList<String>();//
						List<String> cell_type2 = new ArrayList<String>();//细胞类型
						List<String> cell_type3 = new ArrayList<String>();
						while(rs.next()){
							scat_0.add(rs.getString(slet_cancer+"_"+select_gse+""));
						}
						rs.close();
						db.close();
						
						  String[] scat0ldz1_0 = scat_0.get(0).split(";");
			              String[] scat0ldz1_1 = scat_0.get(1).split(";");
			              String[] scat0ldz1_2 = scat_0.get(2).split(";");
			              String[] scat0ldz1_3 = scat_0.get(3).split(";");
			              String[] scat0ldz1_4 = scat_0.get(4).split(";");
						
						//查询表达max
						String cancermax1="";
						db.open();
						sel="select * from "+select_other+"_"+a_f+"_max where Gene = \""+NODE+"\"";
						rs=db.execute(sel);
						while(rs.next()){
							cancermax1=rs.getString(slet_cancer+"_"+select_gse+"");
						}
						rs.close();
						db.close();
						
						for(int p=0;p<scat0ldz1_2.length;p++){
							cell_type2.add(scat0ldz1_2[p]);
						}
						//去重细胞类型
			        	  List<String> celltype_uniq0 = new ArrayList<String>();
			        	  for(int p=0;p<cell_type2.size();p++){
			        		  celltype_uniq0.add(cell_type2.get(p).split(",")[0]);
			        	  }
			        	  String ex=scat_0.get(0).split(",")[0];
						%>		
<%
	if(ex.equals("NONE")){
	}else{
/*---------------------------------小提琴图 start----------------------------------*/
%>

    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(slet_cancer);%></small></p>
        <div id="viloin_other" class="vilo"></div>
      </div>
    </div>
  </div>
</div>
<script>
//let Plotly = require('viloin/plotly-2.16.1.min.js');
//initViolin(){  //渲染violin图
    let rows_other = [
      <%
      int sca=scat0ldz1_0.length;
      for(int p=0;p<sca;p++){
      	String[] scat0ldz2_0 = scat0ldz1_0[p].split(",");
      	int sca2=scat0ldz2_0.length;
      	for(int q=0;q<sca2;q++){
      		out.println("{");
      			out.println("EXPRESSION_VALUE:"+scat0ldz2_0[q]+",");
      			out.println("GROUP_NAME:"+"\""+celltype_uniq0.get(p)+"\""+",");
      			out.println("GROUP_SHORT:"+"\""+celltype_uniq0.get(p)+"\""+",");
      		out.println("},");;		
      	}		
      }
      %>     
    ];
    function unpack(rows_other, key) {
      return rows_other.map(function(row) { return row[key]; });
    }
    let data_other = [{
      type: 'violin',
      x: unpack(rows_other, 'GROUP_SHORT'),
      y: unpack(rows_other, 'EXPRESSION_VALUE'),
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
      box: {
    	visible: true
      },
      boxpoints: 'all',
      jitter: 1,
      pointpos: 0,//设置与小提琴相关的采样点的位置。如果“0”，则采样点位于小提琴中心上方。正(负)值对应垂直小提琴的右(左)位，水平小提琴的上(下)位。
      showlegend: false,//图例
      transforms: [{
        type: 'groupby',
        groups: unpack(rows_other, 'GROUP_SHORT'),
        styles: [
          <% 
          for(int q=0;q<celltype_uniq0.size();q++){
             out.println("{target:"+"'"+celltype_uniq0.get(q)+"'"+","+"value: {line: {color: '"+volcolor[q]+"'}}},");
           }
          %>
        ],
      }]
    }]

    let layout_other = {
      <%--title: "Expression level of <%=NODE%><br>"+'Tissue: '+<%out.println("'"+tissue_pd+"'");%>,--%>
      /*font:{
    	  family:'Microsoft YaHei',
    	  size:14
      },*/
      xaxis: {
        "tickangle": -90,//倾斜角度
        title: {
        },
        //position:[0,0.8]      
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
      //height: 600,
      margin:{
    	  b:180,
    	  //left:100
      },
      legend:{
    	  title:{
    		  text:"Cell type"
    	  },
          itemwidth:10 
      }
    }

    Plotly.newPlot('viloin_other', data_other, layout_other, {showSendToCloud: true});
  //},
</script>
<%}
/*----------------------------------小提琴图 end----------------------------------*/
%>													
<!-- -------------------------------聚类图start-------------------------------- -->
<%if(ex.equals("NONE")){
}else{ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b>Cell clustering based on highly variable genes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(slet_cancer);%></small></p>
        <div id="cluster_other" class="cluster_e"></div>
      </div>
    </div>
  
<script>
var myChart = echarts.init(document.getElementById('cluster_other'));
var data_left = [
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
                   	  out.println("'"+scat0ldz2_2[q]+"'");//celltype
                   	  out.println("],},");
               	  }
               }
                 %>
            ];
            var leg = [
            	<%
            	for(int q=0;q<celltype_uniq0.size();q++){
            		out.println("'" +celltype_uniq0.get(q)+"'"+",");
            	}
            	%>
            ];
            option = {       	    
                    <%--title: {
                        text: 'Cell clusters'<%//out.println("'Cell clusters in '+'"+tissue_pd4+"'");%>,
                        right:550,
                        top: 10,
                        subtext:'Tissue: '+<%out.println("'"+tissue_pd+"'");%>   
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
                        data: data_left,
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
if(ex.equals("NONE")){
}else{%>

    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> expression</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(slet_cancer);%></small></p>
        <div id="clustere_other" class="cluster_e"></div>
      </div>
    </div>
  </div>
</div>
<script>
var myChart = echarts.init(document.getElementById('clustere_other'));
var data_right = [
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
               text: <%out.println("'"+NODE+" expression'");%><%//out.println("'"+NODE+"'+' expression of cell clusters in '+'"+tissue_pd4+"'");%>,
               right: 490,
               top: 10, 
               subtext:<%out.println("'Tissue: "+tissue_pd+"'");%>,                     
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
                    data: data_right
                },
                ],
        animationEasing: 'elasticIn'
   };
myChart.setOption(option);
</script>
<%}
/*--------------------------------------聚类图(带表达)end-----------------------------*/
%>
<%}else{%>
<% 
	List<String> celltt2 = new ArrayList<String>();
	List<String> clasii2 = new ArrayList<String>();
	List<String> cellexp2 = new ArrayList<String>();
	List<String> maxx2 = new ArrayList<String>();
	List<String> meann2 = new ArrayList<String>();
	db.open();
	sel = "select * from "+select_other+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + slet_cancer + "' ";
	rs = db.execute(sel);
	rs.beforeFirst();
	while(rs.next()){
		//dataset.add(rs.getString("dataset"));
		celltt2.add(rs.getString("cell_fullname"));
		clasii2.add(rs.getString("classification"));
		cellexp2.add(rs.getString("cell_exp"));
		maxx2.add(rs.getString("remain_max"));
		meann2.add(rs.getString("remain_mean"));
	}
	rs.close();
	db.close();
	//max mean表格
	out.println("<table id='other-table2' class='table-lyj row-distance round-border' style='width:100%'>");
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
	out.println("<th>");
		out.println("Subclassification");
	out.println("</th>");
	out.println("<th title='Exp. in the CE cell'>");
		out.println("Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th title='Max Exp. in other cell'>");
	out.println("<th>");
		out.println("Max Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("<th title='Mean Exp. in other cell'>");
		out.println("Mean Exp.");
		out.println("<img src=\"images/help.svg\">");
	out.println("</th>");
	out.println("</tr>");
	for(int g=0;g<celltt2.size();g++){
		out.println("<tr>");
		out.println("<td title=\""+cancer_fullname.get(slet_cancer)+"\">");
			out.println(slet_cancer);
			out.println("<img src=\"images/help.svg\">");
			//out.println("<span class=\"glyphicon glyphicon-question-sign\" title=\""+cancer_fullname.get(tissue_pd)+"\"></span>");
		out.println("</td>");
		out.println("<td style='color:#525acd'>");
			out.println(celltt2.get(g));
		//out.println("<span class=\"glyphicon glyphicon-question-sign\"></span>");
		out.println("</td>");
		out.println("<td>");
			out.println("CE");
		out.println("</td>");
		out.println("<td title=\""+hash_fullna.get(clasii2.get(g))+" : "+hash_description.get(clasii2.get(g))+"\">");
			out.println(clasii2.get(g));
			out.println("<img src=\"images/help.svg\">");
			//out.println("<span class=\"glyphicon glyphicon-question-sign\"></span>");
		out.println("</td>");
		out.println("<td>");
			out.println(cellexp2.get(g));
		out.println("</td>");
		out.println("<td>");
		out.println(maxx2.get(g));
			out.println("</td>");
		out.println("<td>");
			out.println(meann2.get(g));
		out.println("</td>");
		out.println("</tr>");
	}
	out.println("</table>");
	
	//柱状图查询	
		db.open();
		sel = "select * from "+select_other+"_"+a_f+"_lncexp where result=\""+NODE+"\" and tissue_type='"+slet_cancer+"'";
		rs=db.execute(sel);
		ResultSetMetaData data2 = rs.getMetaData();
		int col_cell2=data2.getColumnCount();//获取细胞类型的个数
		List<String> oldcol2 = new ArrayList<String>();
		List<String> coln2 = new ArrayList<String>();
		List<String> vv2 = new ArrayList<String>();
		List<String> colname2 = new ArrayList<String>();
		List<String> v2 = new ArrayList<String>();
		while(rs.next()){
			for(int g=4;g<=col_cell2;g++){
				if(rs.getString(g).equals("NA")){
				}else{
				oldcol2.add(data2.getColumnName(g));
				}
			}
		}
		Collections.sort(oldcol2);
		rs.beforeFirst();
		while(rs.next()){
			for(int g=0;g<oldcol2.size();g++){
				coln2.add(oldcol2.get(g));
				vv2.add(rs.getString(oldcol2.get(g)));
			}
		}
		rs.close();
		db.close();		
		//去重列名和对应的值
		for(int k=0;k<coln2.size();k++){
			if(!colname2.contains(coln2.get(k))){
				colname2.add(coln2.get(k));
				v2.add(vv2.get(k));
			}
		}		
%>
<script>
$(document).ready(function(){
    $('#other-table2').DataTable(
    {
    	"filter":false,
    	"bLengthChange": false,
    }		
    );
});   
</script>
<!-- 柱状图 start -->
<%if(v2.size()>0){ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Mean Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(slet_cancer);%></small></p>
        <div id="bar_other1" class="vilo"></div>
      </div>
    </div>
  
		<script>
					var chartDom = document.getElementById('bar_other1');
					var myChart = echarts.init(chartDom);
					var option;

					option = {
					  <%--title:{
						   text: 'Expression level of <%=NODE%>',
						   subtext:'Tissue: '+<%out.println("'"+tissue_pd+"'");%>,
							left: "center",
						    top: "20px",
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
					    	for(int ee=0;ee<colname2.size()-1;ee++){
					    		out.println("'"+colname2.get(ee)+"'"+",");
					    	}
					    	out.println("'"+colname2.get(colname2.size()-1)+"'");
					    	out.println("]");
					    %>
					  },
					  yAxis: {
					    type: 'value',
					    name:'CPM',
					    nameLocation: "middle",
					    nameTextStyle: {
					      fontSize: 16,
					      align: "center",
					      lineHeight: 80
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
						    left:80,
						    //right: '10%',
						    bottom:120
						  },
					  series: [
					    {
					      data: <%
					   		 out.println("[");
				    	for(int ee=0;ee<v2.size()-1;ee++){
				    		 out.println(v2.get(ee)+",");
				    	}
				    	out.println(v2.get(v2.size()-1));
				    	out.println("]");
				    	%>,
					      type: 'bar',
					      showBackground: true,
					      backgroundStyle: {
					        color: 'rgba(180, 180, 180, 0.2)'
					      },
					      itemStyle: {
		                        normal: {
		                            color: function(params) {
		                            	<%
		                                /*int colorlen=v2.size();
		                                int cor1=0;
		                                out.println("var colorList0 = ['#5470c6', '#91cc75', '#fac858', '#ee6666', '#73c0de', '#3ba272', '#fc8452', '#9a60b4', '#ea7ccc'];");
		                                out.println("var colorList = new Array("+colorlen+");");
		                                for(int cor=0;cor<v2.size();cor++){
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
		                            	<%int celllen2 = celltt2.size();
	                            			out.println("var cellList = new Array("+celllen2+");");
	                            		for(int co=0;co<celllen2;co++){
	                            			out.println("cellList["+co+"]="+"'"+celltt2.get(co)+"'");
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
<!-- 柱状图 end -->
<%/*查询detail*/				
					db.open();
					sel="select * from "+select_other+"_"+a_f+"_detail where Gene IN ('cell','cell_type','tsne_x','tsne_y',\""+NODE+"\") ORDER BY FIELD(Gene,\""+NODE+"\",'cell','cell_type','tsne_x','tsne_y')";
					rs=db.execute(sel);
						List<String> scat_2 = new ArrayList<String>();//
						List<String> cell_type2 = new ArrayList<String>();//细胞类型
						List<String> cell_type3 = new ArrayList<String>();
						while(rs.next()){
							scat_2.add(rs.getString(slet_cancer));
						}
						rs.close();
						db.close();
						
						  String[] scat2ldz1_0 = scat_2.get(0).split(";");
			              String[] scat2ldz1_1 = scat_2.get(1).split(";");
			              String[] scat2ldz1_2 = scat_2.get(2).split(";");
			              String[] scat2ldz1_3 = scat_2.get(3).split(";");
			              String[] scat2ldz1_4 = scat_2.get(4).split(";");
						
						//查询表达max
						String cancermax2="";
						db.open();
						sel="select * from "+select_other+"_"+a_f+"_max where Gene = \""+NODE+"\"";
						rs=db.execute(sel);
						while(rs.next()){
							cancermax2=rs.getString(slet_cancer);
						}
						rs.close();
						db.close();
						
						for(int p=0;p<scat2ldz1_2.length;p++){
							cell_type2.add(scat2ldz1_2[p]);
						}
						//去重细胞类型
			        	  List<String> celltype_uniq0 = new ArrayList<String>();
			        	  for(int p=0;p<cell_type2.size();p++){
			        		  celltype_uniq0.add(cell_type2.get(p).split(",")[0]);
			        	  }
			        	  String ex=scat_2.get(0).split(",")[0];
						%>	
<%
	if(ex.equals("NONE")){
	}else{
/*---------------------------------小提琴图start----------------------------------*/
%>
    <div class="col">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(slet_cancer);%></small></p>
        <div id="viloin_other1" class="vilo"></div>
      </div>
    </div>
  </div>
</div>
<script>
//let Plotly = require('viloin/plotly-2.16.1.min.js');
//initViolin(){  //渲染violin图
    let rows_2 = [
      <%
      int sca=scat2ldz1_0.length;
      for(int p=0;p<sca;p++){
      	String[] scat2ldz2_0 = scat2ldz1_0[p].split(",");
      	int sca2=scat2ldz2_0.length;
      	for(int q=0;q<sca2;q++){
      		out.println("{");
      			out.println("EXPRESSION_VALUE:"+scat2ldz2_0[q]+",");
      			out.println("GROUP_NAME:"+"\""+celltype_uniq0.get(p)+"\""+",");
      			out.println("GROUP_SHORT:"+"\""+celltype_uniq0.get(p)+"\""+",");
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
      box: {
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
          for(int q=0;q<celltype_uniq0.size();q++){
             out.println("{target:"+"'"+celltype_uniq0.get(q)+"'"+","+"value: {line: {color: '"+volcolor[q]+"'}}},");
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
        //position:[0,0.8]      
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
      //height: 600,
      margin:{
    	  b:180,
    	  //left:100
      },
      legend:{
    	  title:{
    		  text:"Cell type"
    	  },
          itemwidth:10 
      }
    }

    Plotly.newPlot('viloin_other1', data_2, layout_2, {showSendToCloud: true});
  //},
</script>
<%}
/*----------------------------------小提琴图end----------------------------------*/
%>													
<!-- -------------------------------聚类图start-------------------------------- -->
<%if(ex.equals("NONE")){
}else{ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b>Cell clustering based on highly variable genes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(slet_cancer);%></small></p>
        <div id="cluster_other1" class="cluster_e"></div>
      </div>
    </div>
  
<script>
var myChart = echarts.init(document.getElementById('cluster_other1'));
var data_left = [
            	 <% 
            	 for(int p=0;p<scat2ldz1_0.length;p++){
               	  String[] scat2ldz2_0 = scat2ldz1_0[p].split(",");
               	  String[] scat2ldz2_1 = scat2ldz1_1[p].split(",");
               	  String[] scat2ldz2_2 = scat2ldz1_2[p].split(",");
               	  String[] scat2ldz2_3 = scat2ldz1_3[p].split(",");
               	  String[] scat2ldz2_4 = scat2ldz1_4[p].split(",");
               	  for(int q=0;q<scat2ldz2_0.length;q++){
               		  out.println("{name:'"+scat2ldz2_1[q]+"'"+",");//symbol
               		  out.println("value:[");
               		  out.println(scat2ldz2_3[q]+",");//x
                   	  out.println(scat2ldz2_4[q]+",");//y      	  
                   	  out.println("'"+scat2ldz2_2[q]+"'");//celltype
                   	  out.println("],},");
               	  }
               }
                 %>
            ];
            var leg = [
            	<%
            	for(int q=0;q<celltype_uniq0.size();q++){
            		out.println("'" +celltype_uniq0.get(q)+"'"+",");
            	}
            	%>
            ];
            option = {       	    
                    <%--title: {
                        text: 'Cell clusters'<%//out.println("'Cell clusters in '+'"+tissue_pd4+"'");%>,
                        right:550,
                        top: 10,
                        subtext:'Tissue: '+<%out.println("'"+tissue_pd+"'");%>   
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
                        data: data_left,
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
if(ex.equals("NONE")){
}else{%>
  <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> expression</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(slet_cancer);%></small></p>
        <div id="clustere_other1" class="cluster_e"></div>
      </div>
    </div>
  </div>
</div>
<script>
var myChart = echarts.init(document.getElementById('clustere_other1'));
var data_right = [
             	 <% 
             	 for(int p=0;p<scat2ldz1_0.length;p++){
             		  String[] scat2ldz2_0 = scat2ldz1_0[p].split(",");
             		  String[] scat2ldz2_1 = scat2ldz1_1[p].split(",");
             		  String[] scat2ldz2_2 = scat2ldz1_2[p].split(",");
             		  String[] scat2ldz2_3 = scat2ldz1_3[p].split(",");
             		  String[] scat2ldz2_4 = scat2ldz1_4[p].split(",");
                	  for(int q=0;q<scat2ldz2_0.length;q++){
                		  out.println("{name:'"+scat2ldz2_1[q]+"'"+",");//symbol
                		  out.println("value:[");
                		  out.println(scat2ldz2_3[q]+",");//x
                		  out.println(scat2ldz2_4[q]+",");//y
                		  out.println("'"+scat2ldz2_0[q]+"'");//exp
                		  out.println("],},");
                	  }
                }
                  %>
             ];
option = {
        <%--title: {
               text: <%out.println("'"+NODE+" expression'");%><%//out.println("'"+NODE+"'+' expression of cell clusters in '+'"+tissue_pd4+"'");%>,
               right: 490,
               top: 10, 
               subtext:<%out.println("'Tissue: "+tissue_pd+"'");%>,                     
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
                    max: <%=cancermax2%>,  
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
                    data: data_right
                },
                ],
        animationEasing: 'elasticIn'
   };
myChart.setOption(option);
</script>
<%}
/*--------------------------------------聚类图(带表达)end-----------------------------*/
%>
<%}%>														     
     </div>
     </div>
     </div>
     </div>
<%}%>


<!-- other resource end -->	

</div>
</section>	
</div>
</body>
</html>