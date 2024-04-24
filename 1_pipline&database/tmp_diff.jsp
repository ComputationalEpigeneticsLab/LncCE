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

</head>
<%
String path=application.getRealPath("enrich").replace("\\","/")+"/";
String path_survival=application.getRealPath("survival").replace("\\","/")+"/";
//共表达mRNA富集分析文件的输出路径，传程序时需要修改
//String path = "/pub1/Software/apache-tomcat-6.0.44/webapps/LncSpA/enrich/";
//String path="C:/Users/Administrator/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/LncSpA/enrich/";
//String path = "D:/apache-tomcat-6.0.44/webapps/LncSpA/enrich/";
//lncRNA生存分析图片的删除路径，下面还有一个setwd用来设置图片的输出路径，传程序时需要一起修改
//String path_survival = "/pub1/Software/apache-tomcat-6.0.44/webapps/LncSpA/survival/";
//String path_survival="C:/Users/Administrator/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/LncSpA/survival/";
//String path_survival = "D:/apache-tomcat-6.0.44/webapps/LncSpA/survival/";
%>
<%
DBConn db1 = new DBConn();
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;

String chr = request.getParameter("chr");
String ID = request.getParameter("Name");
String location="";
String type="";
String rs_a  = request.getParameter("classification");
String rs_t = "";
//String cancer = "";
//String fullname = "";
String resource = request.getParameter("resource");
String NODE=""; //gene的名字
String cell=request.getParameter("celltype");
//String rs_c="";
String tissue_pd = "";//tissue_pd用于网络图进行判断是否是组织特异,同时用于判断癌症放到前面
String cell_pd = cell;
String tissue_pd4="";
String a_f="";
tissue_pd4 = request.getParameter("tissue");
tissue_pd = tissue_pd4;
a_f = "adult";
/*if(tissue_pd4.contains("Fetal-")){
	tissue_pd = tissue_pd4.split("Fetal-")[1];
	a_f = "fetal";
}else{
	tissue_pd = tissue_pd4;
	a_f="adult";
}*/

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
/*cancer*/
int bt=1;
int yj=1;
int jy=1;
int yu=1;
int ji=1;
List<String> intesour = new ArrayList<String>();

String[] sour={"geo","tiger","other","cell_res"};
for(String i : sour){
List<String> integra_gse = new ArrayList<String>();
List<String> integra_cell = new ArrayList<String>();						
db.open();
sel = "select * from "+i+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + tissue_pd + "' and source='"+a_f+"'";
rs = db.execute(sel); 
rs.beforeFirst();
while(rs.next()){
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
			intesour.add(i+"="+integra_gse.get(j));
		}
	}else{
		intesour.add(i);
	}
	}
}
//去重资源
List<String> intesour_uniq0 = new ArrayList<String>();
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
}
%>
<%
/*normal*/
List<String> tempsournor = new ArrayList<String>();
List<String> intesournor = new ArrayList<String>();
List<String> allsour = new ArrayList<String>();
String[] allnorsour={"hcl","tts","tica"};
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

<style>
/*悬浮导航栏*/
#floatMenu-mm{
	position:absolute;
	z-index:1;
	min-height:100vh;
	background-color:#ededed;
	display: inline-block;
	zoom: 1; /* zoom and *display = ie7 hack for display:inline-block */
	display: inline;
	vertical-align: baseline;
	outline: none;
	cursor: pointer;
	text-align: center;
	text-decoration: none;
	padding: 8px;
	-webkit-border-radius: .5em; 
	-moz-border-radius: .5em;
	border-radius: .5em;
	
}
#floatMenu-mm button{
	margin-right: 37px;
}
#floatMenu-mm .button-color{
	background: #0B346E;
    color: #fff;
    font-size: 22px;
    border-radius: 9px;
}
#floatMenu-mm .button-color:hover{
	background: #000;
    color: #fff;
}
.detail-head{
	height: 94px;
    margin-bottom: -30px;
    display: flex;
    justify-content: center;
}
.scription{
	font-size:20px;
	margin-bottom: 27px;
}
.scriptionBold{
	font-weight:bolder;
}
.scriptionColor{
	color:red;
}
.fixed-left{
width: 451px;
height: 100vh;
border-radius: 0;
left: 0!important;
background-color:#ededed;
position: fixed;
top:86px;
}
.fixed-right{
width: 1400px;
height: auto;
border-radius: 0;
right: 0!important;
position: relative;
margin-left: 448px;
top: 87px;
}
.container_sty{
margin-top:104px;
}
.button-size{
font-size:21px;
margin-top:20px;
width:378px;
}
.detail-header{
margin-top:63px;
margin-left: 317px;
}
.ant-collapse-header{
position: relative;
padding: 12px 16px 12px 40px;
color: #f8f9fa;
line-height: 22px;
cursor: pointer;
transition: all .3s;
}
.detail-content{
margin-left: 42px;
margin-top: 28px;
}
.content-fontsize{
font-size:21px;
}
.sesty{
font-size:21px;
text-align:left;
width: 523px; 
height: 45px;
border-width:3px;
}
.bar{
width:1267px;
height:600px;
}
.vilo{
width:1200px;
height:600px;
}
.cluster_e{
width:1200px;
height:900px;
}
/*lncce*/
.font-color{
	color:#8064A2;
}
.row-distance{
	margin-top: 20px;
}
#floatMenu .button-color{
	background: #000;
    color: #fff;
}
</style>      
<%String end_tispd = ((tissue_pd.replace("NA_","")).replace("_"," ")).replace("-"," "); %>
<div id="main_loading" class="page-loading"></div>
<div id="main-page">

<section id="content" style="background-color:#fff;">
<div class="content">
<%
List<String> Cancer_1 = new ArrayList<String>();
Cancer_1.add("BLCA");Cancer_1.add("BRCA");Cancer_1.add("CHOL");Cancer_1.add("COAD");Cancer_1.add("ESCA");
Cancer_1.add("HNSC");Cancer_1.add("KICH");Cancer_1.add("KIRC");Cancer_1.add("KIRP");Cancer_1.add("LIHC");
Cancer_1.add("LUAD");Cancer_1.add("LUSC");Cancer_1.add("PRAD");Cancer_1.add("READ");Cancer_1.add("STAD");Cancer_1.add("THCA");Cancer_1.add("UCEC");

List<String> Cancer = new ArrayList<String>();
if(tissue_pd.contains("_")){
	Cancer.add(tissue_pd.split("_")[0]);
	Cancer.add(tissue_pd.split("_")[2]);
}else if(tissue_pd.equals("NSCLC")){
	Cancer.add("LUAD");
	Cancer.add("LUSC");
}else{
	Cancer.add(tissue_pd);
}
%>
<%
String cancer_name="BLCA,BRCA,CHOL,COAD,ESCA,HNSC,KICH,KIRC,KIRP,LIHC,LUAD,LUSC,PRAD,READ,STAD,THCA,UCEC";
List<String> Cancer_2 = Cancer;
Cancer_2=Cancer;
if(!(Collections.disjoint(Cancer_1,Cancer_2))){//判断是否画箱线图 
	//判断有无数据
	String data_cancer0 = "";
	String data_normal0 = "";
	db1.open();
	for(int c0=0;c0<Cancer.size();c0++){
	sel="select * from different_cancer where ID = '"+ID+"'";
	rs=db1.execute(sel);
	while(rs.next()){
		data_cancer0=rs.getString(Cancer.get(c0));
	}
	sel="select * from different_normal where ID = '"+ID+"'";
	rs=db1.execute(sel);
	while(rs.next()){
		data_normal0=rs.getString(Cancer.get(c0));
	}
	}
	rs.close();
	db1.close();
	
	if(data_cancer0==""||data_normal0==null||data_cancer0==null||data_normal0==""){}else{
%>
	<%
for(int c=0;c<Cancer.size();c++){
	String p_diff="";
	String method="";
	String normal_mean="";
	String cancer_mean="";
	String type_diff="";
	String data_cancer="";
	String data_normal="";
	db1.open();
		
	if(cancer_name.indexOf(Cancer.get(c))>=0){//判断有这个癌症
		sel="select p,method from different where lncRNA = '"+ID+"'and cancer = '"+Cancer.get(c)+"'";
		rs=db1.execute(sel);
		while(rs.next()){
			if(!(rs.getString(1)==""||rs.getString(1)==null)){//判断有这个基因
				p_diff=rs.getString(1);
				method=rs.getString(2);
			}
		}
		sel="select diff_type,cancer_mean,normal_mean from different_mean where ID= '"+ID+"' and cancer = '"+Cancer.get(c)+"'";
		rs=db1.execute(sel);
		while(rs.next()){
			if(!(rs.getString(1)==""||rs.getString(1)==null)){//判断有这个基因
				cancer_mean=rs.getString("cancer_mean");
				normal_mean=rs.getString("normal_mean");
				type_diff=rs.getString("diff_type");
			}
		}
		if(!(p_diff==""||p_diff==null)){//判断有这个基因
			sel="select * from different_cancer where ID = '"+ID+"'";
			rs=db1.execute(sel);
			while(rs.next()){
				data_cancer=rs.getString(Cancer.get(c));
			}
			sel="select * from different_normal where ID = '"+ID+"'";
			rs=db1.execute(sel);
			while(rs.next()){
				data_normal=rs.getString(Cancer.get(c));
			}
		}
	}
	db1.close();
	if(data_cancer==""||data_normal==null||data_cancer==null||data_normal==""){}else{
%>
					<div>
					<table id="mydiff<%=c %>" class="table-lyj round-border" style="width:100%;">
						<tr class="single">
							<th>LncRNA Name</th>
							<th>Cancer</th>
							<th>Differential Type</th>
							<th>Mean in Cancer</th>
							<th>Mean in Control</th>
							<th title="<%=method%>">P<span class="glyphicon glyphicon-question-sign"></span></th>
						</tr>
						<tr>
							<td><%=NODE %></td>
							<td><%=Cancer.get(c) %></td>
							<td><%=type_diff %></td>
							<td>
							<%
								if(cancer_mean.equals("0")){
									out.println(cancer_mean);
								}else{
									out.println(cancer_mean.split("\\.")[0]+"."+cancer_mean.split("\\.")[1].substring(0,2));
								}
							%></td>
							<td>
							<%
								if(normal_mean.equals("0")){
									out.println(normal_mean);
								}else{
									out.println(normal_mean.split("\\.")[0]+"."+normal_mean.split("\\.")[1].substring(0,2));
								}
							%></td>
							<td><%=p_diff %></td>
						</tr>
					</table>
<script>
$(document).ready(function(){
    $('#mydiff<%=c %>').DataTable(
    {
    	"filter":false,
    	"bLengthChange": false,
    }		
    );
});   
</script>

					
					</div>
					<div id="<%=Cancer.get(c) %>" style="width: 900px; height: 610px; margin: auto"></div>
					<script type="text/javascript">
			var dom = document.getElementById("<%=Cancer.get(c) %>");
			var myChart = echarts.init(dom);
			option = {
					  title:{
						 text:'Differential expression' ,
						 left:'center',
					  },
					/*title: [
					    {
					      borderColor: '#999',
					      borderWidth: 1,
					      textStyle: {
					        fontWeight: 'normal',
					        fontSize: 14,
					        lineHeight: 20
					      },
					      left: '10%',
					      top: '90%'
					    }
					  ],*/
					  dataset: [
					    {
					      // prettier-ignore
					      source: [[<%= data_cancer%>],
					                [<%= data_normal%>]]
					    },
					    {
					      transform: {
					        type: 'boxplot',
					        //config: { itemNameFormatter: 'expr {value}' }
					        config: { itemNameFormatter: function (param) {
					        	<%
					        	out.println("var ce0=[");
					       		out.println("'cancer'"+",");
					        	out.println("'control'");
					        	out.println("]");
					        	%>
					        	return ce0[param.value];
					        	} }
					      }
					    },
					    {
					      fromDatasetIndex: 1,
					      fromTransformResult: 1
					    }
					  ],
					  color: ['#48cda6'],
					  legend: {
					    bottom: 0,
					    data: ['lncRNA']
					  },
					  tooltip: {
					    trigger: 'item',
					    axisPointer: {
					      type: 'shadow'
					    }
					  },
					  grid: {
					    left: '15%',
					    top: '10%',
					    right: '10%',
					    bottom: '15%'
					  },
					  xAxis: {
					    type: 'category',
					    boundaryGap: true,
					    nameGap: 30,
					    splitArea: {
					      show: true
					    },
					    axisLabel: {
					      fontSize: 14
					    },
					    splitLine: {
					      show: false
					    }
					  },
					  yAxis: {
					    type: 'value',
					    name: 'Expression level(FPKM)',
					    nameLocation: 'center',
					    nameGap: 70,
					    nameTextStyle:{
					      fontSize: 16	
					    },
					    axisLabel: {
					      fontSize: 14
					    },
					    splitArea: {
					      show: false
					    }
					  },
					  series: [
					    {
					      name: 'lncRNA',
					      type: 'boxplot',
					      datasetIndex: 1,
					      tooltip: { formatter: formatter }
					    },
					    {
					      name: 'lncRNA',
					      type: 'scatter',
					      datasetIndex: 2
					    }
					  ]
					};
					function formatter(param) {
					  return [
					    'upper: ' + param.data[4],
					    'Q1: ' + param.data[3],
					    'median: ' + param.data[2],
					    'Q3: ' + param.data[1],
					    'lower: ' + param.data[0]
					  ].join('<br/>');
					}

			myChart.setOption(option);
			
</script>
<% 
	}
	}
}}
%>
</div>
</section>	
</div>
</body>
</html>