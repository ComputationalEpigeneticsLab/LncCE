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
//首页加载时loading
document.onreadystatechange = completeLoading;
// 加载状态为complete时移除loading效果
function completeLoading() {
if (document.readyState =="complete") {
	document.getElementById('main_loading').style.display="none";
}
else{
	document.getElementById('main_loading').style.display="block";
}
}
//console.log(echarts.version);
</script>
<script>
function submit5(){
	document.form5.action = 'tmp_tissue.jsp?#othersour';
	document.form5.submit();
}
</script>

</head>
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;
db.open();

String location="";
String type="";
String rs_t = "";
String cancer = "";
String NODE=""; //gene的名字
String cell="";
String rs_c="";
String a_f="";
String tissue_pd="";
String resource = request.getParameter("resource");
String chr = request.getParameter("chr");
String ID = request.getParameter("Name");
String rs_a  = request.getParameter("classification");
cell=request.getParameter("celltype");
tissue_pd = request.getParameter("tissue");
a_f="adult";
NODE = request.getParameter("NODE");
%>
<%
//normal
int bt=1;
int yj=1;
int jy=1;
int yu=1;
int ji=1;
List<String> intesour = new ArrayList<String>();			
String[] sour={"hcl","tts","tica"};
for(String i : sour){			
	List<String> integra_cell = new ArrayList<String>();
	db.open();
	sel = "select * from "+i+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + tissue_pd + "' and source='" + a_f + "' ";
	rs = db.execute(sel); 
	rs.beforeFirst();
	while(rs.next()){
		integra_cell.add(rs.getString("cell_fullname"));				
	}
	rs.close();
	db.close();
				
	if(integra_cell.size()>0){
		//存储资源				
		intesour.add(i);																		
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
.row-distance{
	margin-top: 20px;
}
.page-loading{
	position: fixed;
    left: 0px;
    top: 0px;
    width: 100%;
    height: 100%;
    z-index: 99999;
    background: rgb(255 255 255 / 52%) url(images/loading.gif) center center no-repeat;
}
</style>
<body>      
<div id="main_loading" class="page-loading"></div>
<div id="main-page">
<section style="background-color:#fff;">
						
<div class="heading">
<h4>1) Spatial expression pattern of 
<span style="color:#525acd">
<%out.println((tissue_pd.replace("-"," ")).replace("_"," "));%>
</span> tissue in the data resource of 
<span style="color:#525acd">
<%= hash_resource.get(resource)%>
</span>
</h4>
</div>
<div class="content row-distance">
<%
					/*---------------------------------最大值、均值表格start---------------------------------*/
					out.println("<table id='normal-table' class='table-lyj round-border' width='100%'>");
					out.println("<tr class='single'>");
					out.println("<th>");
						out.println("Tissue");
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
					
					List<String> max0 = new ArrayList<String>();
					List<String> mean0 = new ArrayList<String>();
					List<String> exp0 = new ArrayList<String>();
					List<String> tis0 = new ArrayList<String>();
					List<String> cel0 = new ArrayList<String>();
					List<String> clas0 = new ArrayList<String>();
					/*虽然这个方法很笨，但是我只是想把ce cell放前边*/
					db.open();
					sel="select * from "+resource+"_basic where ensembl_gene_id = '"+ID+"' and tissue='"+tissue_pd+"' and source='"+a_f+"' and cell='"+cell+"' and seqnames='"+chr+"'";
					//System.out.println(sel);
					rs=db.execute(sel);
					while(rs.next()){
							tis0.add(tissue_pd);
							cel0.add(rs.getString("cell"));
							clas0.add(rs.getString("classification"));
							exp0.add(rs.getString("cell_exp"));
							max0.add(rs.getString("remain_max"));
							mean0.add(rs.getString("remain_mean"));
					}										
					
					sel="select * from "+resource+"_basic where ensembl_gene_id = '"+ID+"' and tissue='"+tissue_pd+"' and source='"+a_f+"' and cell!='"+cell+"' and seqnames='"+chr+"'";
					rs=db.execute(sel);
					while(rs.next()){
							tis0.add(tissue_pd);
							cel0.add(rs.getString("cell"));
							clas0.add(rs.getString("classification"));
							exp0.add(rs.getString("cell_exp"));
							max0.add(rs.getString("remain_max"));
							mean0.add(rs.getString("remain_mean"));
					}
					db.close();
					rs.close();
					/*虽然这个方法很笨，但是我只是想把ce cell放前边*/
					/*因为一个组织可能有多个细胞，所以循环输出*/
					for(int cc=0;cc<tis0.size();cc++){
						out.println("<tr>");
			  			out.println("<td title=\""+tis0.get(cc)+"\">");//癌症/组织类型
							out.println((tis0.get(cc).replace("-"," ")).replace("_"," "));						
			  			out.println("</td>");
			  			out.println("<td style='color:#525acd'>");
							out.println(cel0.get(cc));//细胞类型
						out.println("</td>");
						out.println("<td>");
							out.println("CE");
						out.println("</td>");
						out.println("<td title=\""+hash_fullna.get(clas0.get(cc))+" : "+hash_description.get(clas0.get(cc))+"\">");
							out.println(clas0.get(cc));
							out.println("<img src=\"images/help.svg\">");
						out.println("</td>");
						out.println("<td>");
							out.println(String.format("%.4f",Double.valueOf(exp0.get(cc))));
						out.println("</td>");
						out.println("<td>");
							out.println(String.format("%.4f",Double.valueOf(max0.get(cc))));
						out.println("</td>");
						out.println("<td>");
							out.println(String.format("%.4f",Double.valueOf(mean0.get(cc))));
						out.println("</td>");
						out.println("</tr>");
					}
					/*因为一个组织可能有多个细胞，所以循环输出*/
out.println("</table>");				%>
				<%/*---------------------------------最大值、均值表格end---------------------------------*/%>
				<%/*---------------------------------柱状图start-------------------------------------------*/%> 
				<%
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
					//重新命名tissue_pd
					String end_tissue = ((tissue_pd.replace("NA_","")).replace("_"," ")).replace("-"," ");
					%>				
<script>
$(document).ready(function(){
    $('#normal-table').DataTable(
    {
    	"filter":false,
    	"bLengthChange": false,
    }		
    );
});   
</script>

<%if(v0.size()>0){ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><%=NODE%> Mean Exp in celltypes</h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tissue);%></small></p>
        <div id="bar_n" class="bar"></div>
      </div>
    </div>
 
				<script>
				var chartDom = document.getElementById('bar_n');
				var myChart = echarts.init(chartDom);
				var option;

				option = {
				  title:{
					   <%--text: 'Expression level of <%=NODE%>',--%>
					   <%--subtext:'Tissue: '+<%out.println("'"+tissue_pd+"'");%>,--%>
						left: "center",
					    top: "10px",
					    textStyle: {
					      fontSize: 19
					    } 
				  },
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
					    left: 130,
					    //right: '10%',
					    bottom: 180
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
				      name: 'Count',
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
	                            	<%int celllen = cel0.size();
	                            		out.println("var cellList = new Array("+celllen+");");
	                            	for(int co=0;co<celllen;co++){
	                            		out.println("cellList["+co+"]="+"'"+cel0.get(co)+"'");
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
<%/*---------------------------------柱状图end-------------------------------------------*/%> 
<%/*查询detail*/
					db.open();
					sel="select * from "+resource+"_"+a_f+"_detail where Gene IN ('cell','cell_type','tsne_x','tsne_y',\""+NODE+"\") ORDER BY FIELD(Gene,\""+NODE+"\",'cell','cell_type','tsne_x','tsne_y')";
					//System.out.println(sel);
					rs=db.execute(sel);
						List<String> scat_0 = new ArrayList<String>();//
						List<String> cell_type2 = new ArrayList<String>();//细胞类型						
						rs.beforeFirst();
						while(rs.next()){
							scat_0.add(rs.getString(tissue_pd));
						}
						rs.close();
						db.close();
						
						  String[] scatldz1_0 = scat_0.get(0).split(";");
			              String[] scatldz1_1 = scat_0.get(1).split(";");
			              String[] scatldz1_2 = scat_0.get(2).split(";");
			              String[] scatldz1_3 = scat_0.get(3).split(";");
			              String[] scatldz1_4 = scat_0.get(4).split(";");
						
						
						//查询表达max
						String hclmax="";
						db.open();
						sel="select * from "+resource+"_"+a_f+"_max where Gene = \""+NODE+"\"";
						rs=db.execute(sel);
						while(rs.next()){
							hclmax=rs.getString(tissue_pd);
						}
						rs.close();
						db.close();
						
						for(int p=0;p<scatldz1_2.length;p++){
							cell_type2.add(scatldz1_2[p]);
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
/*---------------------------------小提琴图+饼图start----------------------------------*/
%>		
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><%=NODE%> Exp in celltypes</h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tissue);%></small></p>
        <div id="viloin_n" class="vilo"></div>
      </div>
    </div>
  </div>
</div>
<script>
//let Plotly = require('viloin/plotly-2.16.1.min.js');
//initViolin(){  //渲染violin图
    let rows = [
      <%
      int sca=scatldz1_0.length;
      /*int allcell_num[] = new int[sca];//存储每个细胞类型的在组织中的总数
	  int cellexp_num[] = new int[sca];//
	  int cellnoexp_num[] = new int[sca];//
	  int count_exp=0;
	  int count_no=0;*/
      for(int p=0;p<sca;p++){
      	String[] scatldz2_0 = scatldz1_0[p].split(",");
      	int sca2=scatldz2_0.length;
      	//allcell_num[p]=sca2;
      	for(int q=0;q<sca2;q++){
      		out.println("{");
      		/*if(scatldz2_0[q].equals("0")){
      			count_no++;
      		}else{
      			count_exp++;
      		}*/
      			out.println("EXPRESSION_VALUE:"+scatldz2_0[q]+",");
      			out.println("GROUP_NAME:"+"\""+celltype_uniq0.get(p)+"\""+",");
      			out.println("GROUP_SHORT:"+"\""+celltype_uniq0.get(p)+"\""+",");
      		out.println("},");;		
      	}
      	/*cellexp_num[p]=count_exp;
      	cellnoexp_num[p]=count_no;*/
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
          for(int q=0;q<celltype_uniq0.size();q++){
             out.println("{target:"+"'"+celltype_uniq0.get(q)+"'"+","+"value: {line: {color: '"+volcolor[q]+"'}}},");
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
        tickangle: -90,//倾斜角度
        title: {
        },
        tickmode:'linear'
       // position:[0,0.8]      
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
    	 // left:100
      },
      legend:{
    	  title:{
    		  text:"Cell type"
    	  },
          itemwidth:10 
      }
    }

    Plotly.newPlot('viloin_n', data, layout, {showSendToCloud: true});
  //},
</script>

<%}
/*----------------------------------小提琴图+饼图 end----------------------------------*/
%>													
<!-- -------------------------------聚类图start-------------------------------- -->
<%if(ex.equals("NONE")){
}else{ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title">Cell clustering based on highly variable genes</h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tissue);%></small></p>
        <div id="cluster" class="cluster_e"></div>
      </div>
    </div>
  
<script>
var myChart = echarts.init(document.getElementById('cluster'));
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
            	for(int q=0;q<celltype_uniq0.size();q++){
            		out.println("'" +celltype_uniq0.get(q)+"'"+",");
            	}
            	%>
            ];
            option = {       	    
                    <%--title: {
                        text: 'Cell clustering based on highly variable genes'<%//out.println("'Cell clusters in '+'"+tissue_pd+"'");%>,
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
                      marker:{
                    	  showexponent: 'all'
                      },
                      visualMap: {            
                    	type :'piecewise',
                         padding: [
                        	    20,  // 
                        	    0, // 
                        	    5,  //
                        	    40, //
                        	],
                        splitNumber:5,
                       	showLabel:true, 
                        itemHeight:5,  
                        itemGap:3,                    
                        //orient: 'horizontal',
                        right: 0,
                        top: 'center',
                        text: ['Cell type',''],
                    
                        calculable: true,
                        inRange: {
                        	  symbol:'circle', color:['#ffb980','#5ab1ef','#b6a2de','#2ec7c9','#fc97af','#87f7cf','#001852','#72ccff','#f7c5a0','#e01f54','#d2f5a6','#76f2f2','#516b91','#59c4e6','#edafda','#93b7e3','#a5e7f0','#cbb0e3','#588dd5','#f5994e','#ffb980','#5ab1ef','#b6a2de','#2ec7c9','#fc97af','#87f7cf','#001852','#72ccff','#f7c5a0','#e01f54','#d2f5a6','#76f2f2','#516b91','#59c4e6','#edafda','#93b7e3','#a5e7f0','#cbb0e3','#588dd5','#f5994e',]
                        },
                        align: "left",
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
        <h5 class="card-title"><%=NODE%> expression</h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tissue);%></small></p>
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
             		  //String[] scatldz2_2 = scatldz1_2[p].split(",");
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
               text: <%out.println("'"+NODE+" expression'");%><%//out.println("'"+NODE+"'+' expression of cell clusters in '+'"+tissue_pd+"'");%>,
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
<!-- resource end -->
<!-- other resource start-->
<%if(intesour_uniq.size()>0){
//选择的资源
String select_other = "";
if(request.getParameter("seother")==null){
	select_other = intesour_uniq.get(0);
}else{
	select_other = request.getParameter("seother");
}
%>

<div class="heading row-distance">
<h3>2) Spatial expression pattern of <%=end_tissue%> tissue in other resources
</h3>
</div>
<div class="content row-distance">
	
<div id="othersour" class="TE_XBT">
<form id="form5" name="form5">
<input type="hidden" name="value1" value=0.5>
<input type="hidden" name="tissue" value='<%=tissue_pd %>'>
<input type="hidden" name="mRNA_tissue" value="">
<input type="hidden" name="Name" value='<%=ID %>'>
<input type="hidden" name="classification" value='<%=rs_a %>'>
<input type="hidden" name="resource" value='<%=resource %>'>
<input type="hidden" name="celltype" value='<%=cell %>'>
<input type="hidden" name="chr" value='<%=chr%>'>
<input type="hidden" name="NODE" value='<%=NODE%>'>
<select id="seother" class="sesty" name="seother">
<%
/*把选择的资源放在第一个*/
out.println("<option value='"+select_other+"'>");
out.println(hash_resource.get(select_other));
out.println("</option>");
/*循环输出所有的资源*/
for(int se=0;se<intesour_uniq.size();se++){		
		out.println("<option value='"+intesour_uniq.get(se)+"'>");			
			out.println(hash_resource.get(intesour_uniq.get(se)));						
		out.println("</option>");
	}
%>
</select>
<button id="sour_btn5" type="submit" value="Submit" class="btn btn-dark" onclick="submit5()">Apply Filter</button>
</form>
</div>
<br/>
<%
//max mean 查询，把CE cell放前面 
	List<String> celltt = new ArrayList<String>();
	List<String> clasii = new ArrayList<String>();
	List<String> cellexp = new ArrayList<String>();
	List<String> maxx = new ArrayList<String>();
	List<String> meann = new ArrayList<String>();
	db.open();
	sel = "select * from "+select_other+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + tissue_pd + "' and source='"+a_f+"' and cell='"+cell+"'";
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
	sel = "select * from "+select_other+"_basic where ensembl_gene_id ='" + ID + "' and tissue='" + tissue_pd + "' and source='"+a_f+"' and cell!='"+cell+"'";
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
	out.println("<table id='other-table' class='table-lyj round-border row-distance' style='width:100%'>");
	out.println("<tr class='single'>");
	out.println("<th>");
		out.println("Tissue");
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
		out.println("<td>");
			out.println(end_tissue);
		out.println("</td>");
		out.println("<td style='color:#525acd'>");
			out.println(celltt.get(g));
		out.println("</td>");
		out.println("<td>");
			out.println("CE");
		out.println("</td>");
		out.println("<td title=\""+hash_fullna.get(clasii.get(g))+" : "+hash_description.get(clasii.get(g))+"\">");
			out.println(clasii.get(g));
			out.println("<img src=\"images/help.svg\">");
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
	sel = "select * from "+select_other+"_"+a_f+"_lncexp where result=\""+NODE+"\" and tissue_type=\""+tissue_pd+"\"";
	rs=db.execute(sel);
	ResultSetMetaData data1 = rs.getMetaData();
	int col_cell1=data1.getColumnCount();//获取细胞类型的个数
	List<String> coln1 = new ArrayList<String>();
	List<String> vv1 = new ArrayList<String>();
	List<String> oldcol1 = new ArrayList<String>();
	List<String> colname1 = new ArrayList<String>();
	List<String> v1 = new ArrayList<String>();
	rs.beforeFirst();
	while(rs.next()){
		for(int g=4;g<=col_cell1;g++){
			if(rs.getString(g).equals("NA")){
			}else{
			oldcol1.add(data1.getColumnName(g));
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
		if(!colname1.contains(coln1.get(k))){
			colname1.add(coln1.get(k));
			v1.add(vv1.get(k));
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
<%if(v1.size()>0){ %>
<div class="card card-body row-distance">
  <div class="row">
    <div class="col-6">
      <div class="card-body" style="text-align:center;">
        <h5 class="card-title"><b><%=NODE%> Mean Exp in celltypes</b></h5>
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tissue);%></small></p>
        <div id="bar_other" class="bar"></div>
      </div>
    </div>
  
	<script>
				var chartDom = document.getElementById('bar_other');
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
				        rotate: 90,
				        interval:0,
				      },
				    data: <%
				   		 out.println("[");
				    	for(int ee=0;ee<colname1.size()-1;ee++){
				    		out.println("'"+colname1.get(ee)+"'"+",");
				    	}
				    	out.println("'"+colname1.get(colname1.size()-1)+"'");
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
					    bottom:150,
					    left:80
					  },
				  series: [
				    {
				      data: <%
				   		 out.println("[");
			    	for(int ee=0;ee<v1.size()-1;ee++){
			    		 out.println(v1.get(ee)+",");
			    	}
			    	out.println(v1.get(v1.size()-1));
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
	                            	<%int celllen1 = celltt.size();
                            		out.println("var cellList = new Array("+celllen1+");");
                            		for(int co=0;co<celllen1;co++){
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
<!-- 柱状图 end-->
<%/*查询detail*/
					db.open();
					sel="select * from "+select_other+"_"+a_f+"_detail where Gene IN ('cell','cell_type','tsne_x','tsne_y',\""+NODE+"\") ORDER BY FIELD(Gene,\""+NODE+"\",'cell','cell_type','tsne_x','tsne_y')";
					rs=db.execute(sel);
						List<String> scat3 = new ArrayList<String>();//
						List<String> cell_typee3 = new ArrayList<String>();//细胞类型
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
						sel="select * from "+select_other+"_"+a_f+"_max where Gene = \""+NODE+"\"";
						rs=db.execute(sel);
						while(rs.next()){
							cancermax=rs.getString(tissue_pd);
						}
						rs.close();
						db.close();
						
						for(int p=0;p<scat3ldz1_2.length;p++){
							cell_typee3.add(scat3ldz1_2[p]);
						}
						//去重细胞类型
			        	  List<String> celltype_uniq3 = new ArrayList<String>();
			        	  for(int p=0;p<cell_typee3.size();p++){
			        		  celltype_uniq3.add(cell_typee3.get(p).split(",")[0]);
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
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tissue);%></small></p>
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
      boxpoints: 'all',
      jitter: 1,
      pointpos: 0,//设置与小提琴相关的采样点的位置。如果“0”，则采样点位于小提琴中心上方。正(负)值对应垂直小提琴的右(左)位，水平小提琴的上(下)位。
      showlegend: false,//图例
      transforms: [{
        type: 'groupby',
        groups: unpack(rows_other, 'GROUP_SHORT'),
        styles: [
          <% 
          for(int q=0;q<celltype_uniq3.size();q++){
             out.println("{target:"+"'"+celltype_uniq3.get(q)+"'"+","+"value: {line: {color: '"+volcolor[q]+"'}}},");
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
       // position:[0,0.8]      
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
    	 // left:190
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
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tissue);%></small></p>
        <div id="cluster_other" class="cluster_e"></div>
      </div>
    </div>
  
<script>
var myChart = echarts.init(document.getElementById('cluster_other'));
var data_otherl = [
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
                        itemHeight:5,  
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
                        data: data_otherl,
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
        <p class="card-text" style="text-align:center;"><small class="text-muted">Tissue:<%out.println(end_tissue);%></small></p>
        <div id="clustere_other" class="cluster_e"></div>
      </div>
    </div>
  </div>
</div>
<script>
var myChart = echarts.init(document.getElementById('clustere_other'));
var data_otherr = [
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
		<%-- title: {
               text: <%out.println("'"+NODE+" expression'");%><%//out.println("'"+NODE+"'+' expression of cell clusters in '+'"+tissue_pd+"'");%>,
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
                    data: data_otherr
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
<%}else{ %>
<div class="heading row-distance">
<h3>2) Spatial expression pattern of <%=end_tissue%> tissue in other resources
</h3>
</div>
<div class="content row-distance">
<h6>No result!</h6>
</div>
<%} %>
<!-- other resource end -->
</div>		
</section>
</div>
</body>
</html>