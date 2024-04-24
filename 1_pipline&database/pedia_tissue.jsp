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
<script type="text/javascript" charset="utf8" src="datatable/pdfmake.min.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/vfs_fonts.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/buttons.html5.min.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/buttons.print.min.js"></script>
<!-- my -->
<script src="js/iconify.min.js"></script>
<script src="js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="echarts/echarts.min.js"></script>
<script type="text/javascript" src="echarts/ecSimpleTransform.min.js"></script>
<script type="text/javascript" src="echarts/ecStat.min.js"></script>
<script src="viloin/plotly-2.18.2.min.js"></script>
<style>
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
</style> 
</head>
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
NODE = request.getParameter("NODE");

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
		/*for(int j=0;j<integra_cell.size();j++){
			if(integra_cell.get(j).equals(cell)){
				intesournor.add(integra_tiss.get(j)+"="+ou);
			}else{
				tempsournor.add(integra_tiss.get(j)+"="+ou);
			}			
		}*/
		for(int j=0;j<integra_tiss.size();j++){
			if(integra_tiss.get(j).equals(pd_tiss)){
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

<div id="main-page">
<section style="background-color:#fff;">

<%
String tisour = request.getParameter("tisssour");
String select_sour = "";
String select_tiss = "";
if(tisour==null){
	tisour = intesour_uniqnor.get(0);
	select_tiss = intesour_uniqnor.get(0).split("=")[0];
	select_sour = intesour_uniqnor.get(0).split("=")[1];
}else{
	select_tiss = tisour.split("=")[0];
	select_sour = tisour.split("=")[1];
}
String end_setis = (select_tiss.replace("_", " ")).replace("-"," ");
%>
<!--  <div class="TE_XBT">1) Spatial expression pattern in individual resources.</div>-->
<div class="">
<form id="form2" name="form2">
<input type="hidden" name="value1" value=0.5>
<input type="hidden" name="tissue" value='<%=tissue_pd %>'>
<input type="hidden" name="mRNA_tissue" value="">
<input type="hidden" name="Name" value='<%=ID %>'>
<input type="hidden" name="classification" value='<%=rs_a %>'>
<input type="hidden" name="resource" value='<%=resource %>'>
<input type="hidden" name="celltype" value='<%=cell %>'>
<input type="hidden" name="NODE" value='<%=NODE %>'>
<select id="tisssour" class="sesty" name="tisssour">
<%
//选中的组织+资源放前面
out.println("<option value='"+select_tiss+"="+select_sour+"'>");
out.println(select_tiss+" ("+hash_resource.get(select_sour)+")");		
out.println("</option>");
//循环输出所有的组织+资源
for(int se=0;se<intesour_uniqnor.size();se++){
	String inun[] = intesour_uniqnor.get(se).split("=");
	out.println("<option value='"+intesour_uniqnor.get(se)+"'>");
		out.println(inun[0]+" ("+hash_resource.get(inun[1])+")");		
	out.println("</option>");
	}
%>
</select>
<button type="submit" value="Submit" class="norbtn" onclick="submit2()">Apply Filter</button>
</form>
</div>

<div class="heading row-distance"><h4>Spatial expression pattern of <%=end_setis%> tissue in the data resource of <span style="color:#f11010"><%=hash_resource.get(select_sour)%></span></h4></div>
<%
/*max mean 表格*/
//----max mean normal----
		out.println("<table id='indivi_normal' class='table-lyj row-distance round-border' style='width:100%;'>");
		out.println("<thead>");
		out.println("<tr class=\"single\">");
		out.println("<th>");
			out.println("Tissue");
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
								
	List<String> integ_cell = new ArrayList<String>();
	List<String> integ_class = new ArrayList<String>();
	List<String> integ_exp = new ArrayList<String>();
	List<String> integ_max = new ArrayList<String>();
	List<String> integ_mean = new ArrayList<String>();
	db.open();
	sel = "select * from "+select_sour+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + select_tiss + "' and source='"+a_f+"' ";
	rs = db.execute(sel); 
	rs.beforeFirst();
	while(rs.next()){
		integ_cell.add(rs.getString("cell_fullname"));	
		integ_class.add(rs.getString("classification"));
		integ_exp.add(rs.getString("cell_exp"));
		integ_max.add(rs.getString("remain_max"));
		integ_mean.add(rs.getString("remain_mean"));
    }
	rs.close();
	db.close();	
						
	%>					
	<% 			
				int cesize=integ_cell.size();
				out.println("<tr>");			
				out.println("<td>");
				out.println(end_setis);
				//out.println("<span class=\"glyphicon glyphicon-question-sign\"></span>");
				out.println("</td>");
				out.println("<td style='color:#525acd'>");
				for(int j=0;j<cesize;j++){												
					out.println(integ_cell.get(j)+"<br/>");													
				}
				out.println("</td>");
				out.println("<td>");
				for(int j=0;j<cesize;j++){					
					out.println(integ_class.get(j));
					out.println("<img title=\""+hash_fullna.get(integ_class.get(j))+" : "+hash_description.get(integ_class.get(j))+"\" src=\"images/help.svg\">");
					//out.println("<span title=\""+hash_fullna.get(integ_class.get(j))+" : "+hash_description.get(integ_class.get(j))+"\" class=\"glyphicon glyphicon-question-sign\"></span>");						
					out.println("<br/>");
				}
				out.println("</td>");
				out.println("<td>");	
				for(int j=0;j<cesize;j++){						
					String aa0 = integ_exp.get(j);
					String aa = String.format("%.4f",Double.valueOf(aa0));	
					out.println(aa+"<br/>");												
				}
				out.println("</td>");
				out.println("<td>");
				for(int j=0;j<cesize;j++){
					String bb0 = integ_max.get(j);
					String bb = String.format("%.4f",Double.valueOf(bb0));	
					out.println(bb+"<br/>");
				}
				out.println("</td>");
				out.println("<td>");
				for(int j=0;j<cesize;j++){
					String cc0 = integ_mean.get(j);
					String cc = String.format("%.4f",Double.valueOf(cc0));		
					out.println(cc+"<br/>");	
				}				
				out.println("</tr>");

out.println("</tbody>");
out.println("</table>");
%>											
</div>
<script>
$(document).ready(function(){
    $('#indivi_normal').DataTable(
    {
    	"filter":false,
    	"bLengthChange": false,
    }		
    );
});   
</script>

<!-- 柱状图查询 -->		
<% 					db.open();
					sel = "select * from "+select_sour+"_"+a_f+"_lncexp where result=\""+NODE+"\" and tissue_type=\""+select_tiss+"\"";
					rs=db.execute(sel);
					ResultSetMetaData data3 = rs.getMetaData();
					int col_cell3=data3.getColumnCount();//获取细胞类型的个数
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
							colname3.add(oldcol3.get(g));
							v3.add(rs.getString(oldcol3.get(g)));
						}
					}
					rs.close();
					db.close();
					%>
<%if(v3.size()>0){ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Mean Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_setis);%></small></p>
        <div id="bar_n" class="bar"></div>
      </div>
    </div>
 
				<script>
				var chartDom = document.getElementById('bar_n');
				var myChart = echarts.init(chartDom);
				var option;

				option = {
				  <%--title:{
					   text: 'Expression level of <%=NODE%>',
					   subtext:'Tissue: '+<%out.println("'"+select_tiss+"'");%>,
						left: "center",
					    top: "10px",
					    textStyle: {
					      fontSize: 19
					    } 
				  },--%>
					xAxis: {
				    type: 'category',
				    nameTextStyle: {
					      fontSize: 10				      
					  },
				    axisLabel: {
				    	interval:0,
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
				    name:'CPM',
				    nameLocation: "middle",
				    nameTextStyle: {
				      fontSize: 16,
				      align: "center",
				      lineHeight: 70
				    }
				  },
				  //title: {
						//text: "Expression level of NODE in tiss.get(dd)"
					//},
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
					    left: 130,
					    //right: '10%',
					    bottom: 180
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
	                               /* int colorlen=v0.size();
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
	                            	<%int celllen3 = integ_cell.size();
                            			out.println("var cellList = new Array("+celllen3+");");
                            		for(int co=0;co<celllen3;co++){
                            			out.println("cellList["+co+"]="+"'"+integ_cell.get(co)+"'");
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
<!--  <div id="cellMap" class="TE_XXBT">Cell map in individual normal tissues</div>	-->			
<%/*查询detail*/
					db.open();
					sel="select * from "+select_sour+"_"+a_f+"_detail where Gene IN ('cell','cell_type','tsne_x','tsne_y',\""+NODE+"\") ORDER BY FIELD(Gene,\""+NODE+"\",'cell','cell_type','tsne_x','tsne_y')";
					rs=db.execute(sel);
						List<String> scat = new ArrayList<String>();//
						List<String> cell_type = new ArrayList<String>();//细胞类型
						List<String> cell_type1 = new ArrayList<String>();
						rs.beforeFirst();
						while(rs.next()){
							scat.add(rs.getString(select_tiss));
						}
						rs.close();
						db.close();
						
						String[] scatldz1_0 = scat.get(0).split(";");
			              String[] scatldz1_1 = scat.get(1).split(";");
			              String[] scatldz1_2 = scat.get(2).split(";");
			              String[] scatldz1_3 = scat.get(3).split(";");
			              String[] scatldz1_4 = scat.get(4).split(";");
						
						//查询表达max
						String hclmax="";
						db.open();
						sel="select * from "+select_sour+"_"+a_f+"_max where Gene = \""+NODE+"\"";
						rs=db.execute(sel);
						rs.beforeFirst();
						while(rs.next()){
							hclmax=rs.getString(select_tiss);
						}
						rs.close();
						db.close();	
						
						for(int p=0;p<scatldz1_2.length;p++){
							cell_type.add(scatldz1_2[p]);
						}
						//去重细胞类型
			        	  List<String> celltype_uniq = new ArrayList<String>();
			        	  for(int p=0;p<cell_type.size();p++){
			        		  celltype_uniq.add(cell_type.get(p).split(",")[0]);
			        	  }
			        	  String expr0=scat.get(0).split(",")[0];
			        	  
						%>		
<!-- 小提琴图start -->
<%if(expr0.equals("NONE")){
}else{ %>
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_setis);%></small></p>
        <div id="viloin_n" class="vilo"></div>
      </div>
    </div>
  </div>
</div>
<script>
//let Plotly = require('viloin/plotly-2.16.1.min.js');
//initViolin(){  //渲染violin图
    let rows_1 = [
      <%
      int sca=scatldz1_0.length;
      for(int p=0;p<sca;p++){
      	String[] scatldz2_0 = scatldz1_0[p].split(",");
      	int sca2=scatldz2_0.length;
      	for(int q=0;q<sca2;q++){
      		out.println("{");
      			out.println("EXPRESSION_VALUE:"+scatldz2_0[q]+",");
      			out.println("GROUP_NAME:"+"\""+celltype_uniq.get(p)+"\""+",");
      			out.println("GROUP_SHORT:"+"\""+celltype_uniq.get(p)+"\""+",");
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
      box: {
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
          for(int q=0;q<celltype_uniq.size();q++){
             out.println("{target:"+"'"+celltype_uniq.get(q)+"'"+","+"value: {line: {color: '"+volcolor[q]+"'}}},");
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

    Plotly.newPlot('viloin_n', data_1, layout_1, {showSendToCloud: true});
  //},
</script>
<%} %>
<!-- -------------------------------聚类图start-------------------------------- -->
<%if(expr0.equals("NONE")){
}else{ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b>Cell clustering based on highly variable genes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_setis);%></small></p>
        <div id="cluster_n" class="cluster_e"></div>
      </div>
    </div>
  
<script>
var myChart = echarts.init(document.getElementById('cluster_n'));
var data_left = [
            	 <% 
            	 for(int p=0;p<scatldz1_0.length;p++){
               	  String[] scatldz2_0 = scatldz1_0[p].split(",");
               	  String[] scatldz2_1 = scatldz1_1[p].split(",");
               	  String[] scatldz2_2 = scatldz1_2[p].split(",");
               	  String[] scatldz2_3 = scatldz1_3[p].split(",");
               	  String[] scatldz2_4 = scatldz1_4[p].split(",");
               	  for(int q=0;q<scatldz2_0.length;q++){
               		  out.println("{name:'"+scatldz2_1[q]+"'"+",");//symbol
               		  out.println("value:[");
               		  out.println(scatldz2_3[q]+",");//x
                   	  out.println(scatldz2_4[q]+",");//y      	  
                   	  out.println("'"+scatldz2_2[q]+"'");//celltype
                   	  out.println("],},");
               	  }
               }
                 %>
            ];
            var leg = [
            	<%
            	for(int q=0;q<celltype_uniq.size();q++){
            		out.println("'" +celltype_uniq.get(q)+"'"+",");
            	}
            	%>
            ];
            option = {       	    
                    <%--title: {
                        text: 'Cell clusters'<%//out.println("'Cell clusters in '+'"+tissue_pd4+"'");%>,
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
if(expr0.equals("NONE")){
}else{ %>
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> expression</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_setis);%></small></p>
        <div id="cluster_e" class="cluster_e"></div>
      </div>
    </div>
  </div>
</div>
<script>
var myChart = echarts.init(document.getElementById('cluster_e'));
var data_right = [
             	 <% 
             	 for(int p=0;p<scatldz1_0.length;p++){
             		  String[] scatldz2_0 = scatldz1_0[p].split(",");
             		  String[] scatldz2_1 = scatldz1_1[p].split(",");
             		  String[] scatldz2_2 = scatldz1_2[p].split(",");
             		  String[] scatldz2_3 = scatldz1_3[p].split(",");
             		  String[] scatldz2_4 = scatldz1_4[p].split(",");
                	  for(int q=0;q<scatldz2_0.length;q++){
                		  out.println("{name:'"+scatldz2_1[q]+"'"+",");//symbol
                		  out.println("value:[");
                		  out.println(scatldz2_3[q]+",");//x
                		  out.println(scatldz2_4[q]+",");//y
                		  out.println("'"+scatldz2_0[q]+"'");//exp
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
                    max: <%=hclmax%>,  
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

</body>
</html>