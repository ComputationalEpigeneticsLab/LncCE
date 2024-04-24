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
<script src="js/iconify.min.js"></script>
<!-- datatable -->
<link rel="stylesheet" type="text/css" href="datatable/jquery.dataTables.min.css">
<link rel="stylesheet" type="text/css" href="datatable/responsive.dataTables.min.css">
<script src="js/jquery-3.5.1.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/jquery.dataTables.min.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/dataTables.responsive.min.js"></script>
<!-- datatable button -->
<link href="datatable/jquery.dataTables.css" rel="stylesheet" >
<link href="datatable/dataTables.bootstrap4.min.css" rel="stylesheet">
<link href="datatable/buttons.dataTables.min.css" rel="stylesheet">
<script type="text/javascript" charset="utf8" src="datatable/jquery.dataTables.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/dataTables.buttons.min.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/jszip.min.js"></script>
<!--  
<script type="text/javascript" charset="utf8" src="datatable/pdfmake.min.js"></script>
-->
<script type="text/javascript" charset="utf8" src="datatable/vfs_fonts.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/buttons.html5.min.js"></script>
<script type="text/javascript" charset="utf8" src="datatable/buttons.print.min.js"></script>
<!-- my -->
<script type="text/javascript" src="echarts/echarts.min.js"></script>
<script type="text/javascript" src="echarts/ecSimpleTransform.min.js"></script>
<script type="text/javascript" src="echarts/ecStat.min.js"></script>

<script type="text/javascript" src="js/eCharts/dat.gui.min.js"></script>
<script type="text/javascript" src="js/eCharts/dataTool.min.js"></script>
<script type="text/javascript" src="js/eCharts/china.js"></script>
<script type="text/javascript" src="js/eCharts/world.js"></script>
<script type="text/javascript" src="js/eCharts/bmap.min.js"></script>
<script type="text/javascript">
	function actsel1(s) {
		if (s != "") {
			document.form1.action = 'tmp_lncmrna.jsp?#floatMenu4';
			document.form1.submit();
		}
		document.all.down.options[0].selected = true;
	}
</script>
<%
HashMap<String,String> hash_resource = new HashMap<String,String>();
hash_resource.put("hcl","Human Cell Landscape");
hash_resource.put("tts","The Tabula Sapiens");
hash_resource.put("other","GSE140819");
hash_resource.put("cell_res","Qian et al., Cell Research 2020");
hash_resource.put("tica","TICA");
hash_resource.put("epn","GSE125969");
%> 
</head>
<style>
/*lncce*/
.font-color{
	color:#8064A2;
}
.row-distance{
	margin-top: 20px;
}
</style>
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;

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
<body>
      

<!-- 内容 start --> 
<% DBConn db1 = new DBConn();%>
<!-- 4.LncRNA-mRNA start -->
<%
Array2 arr = new Array2();
List<String> set = new ArrayList<String>();
set = arr.Array2(ID+";"+NODE,resource+"_"+a_f);
if(set.size()==0){
%>
<div class="sidebar">
<section id="floatMenu4" style="background-color: #fff;">				
<div class="heading">
<h3><a class="font-color">LncRNA-mRNA interaction in the data resource of <%=hash_resource.get(resource) %></a></h3>
</div>
<div class="content card card-body">
<h6>No result!</h6>
</div>
</section>
</div>
<%	
}  //R-P为空
else{	
%>
<%
//System.out.println(set.get(0));
List<String> alone_tissue = new ArrayList<String>();
List<String> alone_tissue0 = new ArrayList<String>();
List<String> alone_cell = new ArrayList<String>();
for(int n=0;n<set.size();n++){
	String[] re = set.get(n).toString().split("=");
	//存储组织
	if(re[0].equals(tissue_pd)){
		alone_tissue.add(re[0]);
	}else{
		alone_tissue0.add(re[0]);
	}	
	//存储细胞	
	/*String[] result = re[1].split(";");
	for(int m=0;m<result.length;m++){
		String[] al=result[m].split(":");
		if(!(alone_cell.contains(al[5]))){
			alone_cell.add(al[5]);
		}		
	}*/		
}
for(int i=0;i<alone_tissue0.size();i++){
	alone_tissue.add(alone_tissue0.get(i));
}
//System.out.println(alone_tissue.get(0));
%>
<%
//String a_f2="";
String i4 = request.getParameter("value1");
String mRNA_tissue= request.getParameter("mRNA_tissue");
/*if(a_f.equals("adult")){
	//mRNA_tissue = mRNA_tissue.split("Adult-")[1];
	a_f2 = "Adult-";
}else if(a_f.equals("fetal")){
	//mRNA_tissue = mRNA_tissue.split("Fetal-")[1];
	a_f2 = "Fetal-";
}*/
String mRNA_classification=request.getParameter("mRNA_classification");
if(mRNA_classification==null){
 	mRNA_classification="All";
}
if(mRNA_tissue==null||mRNA_tissue==""){
 	mRNA_tissue=alone_tissue.get(0);
}
%>
<div id="abc">
<div class="sidebar">
<section id="floatMenu4" style="background-color: #fff;">				
<div class="heading">
<h3><a class="font-color">LncRNA-mRNA interaction in the data resource of <%=hash_resource.get(resource) %></a></h3>
</div>
<div class="content card card-body">

<div id="detail_m" class="Menu4">
		<div id="Table_body_details" class="content-fontsize">
			<form action="tmp_lncmrna.jsp" name="form1">
			<table id="lnc_mrna" class="table-lyj round-border display" width="100%">
			<thead>
			<tr class="single">
			<th style="width: 120px;text-align: center;">Name</th>
			<th style="text-align: center;"><div class="row">&nbsp&nbsp&nbspTissue&nbsp&nbsp
			<%-- 
			<select style="width:150px;float:left;" name="mRNA_tissue" onchange="actsel1(this.options[this.options.selectedIndex].value)">			
			<%if(!mRNA_tissue.equals("All_tissue")){
			out.println("<option value='"+mRNA_tissue+"'>"+((mRNA_tissue.replace("NA_","")).replace("_"," ")).replace("-"," ")+"</option>");
			} %>
			<option value="All_tissue">all tissue</option>
			<%
			for(String t:alone_tissue){
				out.println("<option value='"+t+"'>"+((t.replace("NA_","")).replace("_"," ")).replace("-"," ")+"</option>");
			}
			%>
 			</select>
 			--%>
 			</div>
			</th>
			<th style="width: 120px;text-align: center;">Cell
			<!--  <select style="width:150px;float:left;" name="mRNA_cell" onchange="actsel1(this.options[this.options.selectedIndex].value)">			
			<%
			/*for(String t:alone_cell){
				out.println("<option title='"+t+"'>"+t+"</option>");
			}*/
			%>
 			</select>
 			-->
			</th>
			<th><div class="row">&nbsp&nbsp&nbsp&nbspClassification&nbsp&nbsp
 			<select style="width:150px;float:left;" name="mRNA_classification" onchange="actsel1(this.options[this.options.selectedIndex].value)">
			<%if(!mRNA_classification.equals("All")){
				out.println("<option>"+mRNA_classification+"</option>");
			} %>
 			<option>All</option>
 			<option>CS</option>
 			<option>CER</option>
			<option>CEH</option>
			</select>
			</div>
			</th>
			<th><div class="row">R&nbsp&nbsp&nbsp
			<select style="width:150px;float:left;" name="value1" onchange="actsel1(this.options[this.options.selectedIndex].value)">
			<option><%=i4 %></option>
 			<option>0.0</option>
 			<option>0.1</option> 
			<option>0.2</option> 
 			<option>0.3</option>
 			<option>0.4</option>
 			<option>0.5</option> 
			<option>0.6</option> 
 			<option>0.7</option>  
 			</select> 
 			</div>
			</th>
			<th style="width: 120px;text-align: center;">P</th>
			</tr>
			</thead>		  			
			<input type="hidden" name="tissue" value='<%=tissue_pd %>'>
			<input type="hidden" name="Name" value='<%=ID %>'>
			<input type="hidden" name="classification" value='<%=rs_a %>'>
			<input type="hidden" name="resource" value='<%=resource %>'>
			<input type="hidden" name="celltype" value='<%=cell %>'>
			<input type="hidden" name="chr" value='<%=chr %>'>
			<input type="hidden" name="NODE" value='<%=NODE %>'>
<div class="container">
<tbody>
<%
//int n44=1;
String mRNA1="";
List<String> node = new ArrayList<String>();
List<String> node_id = new ArrayList<String>();
List<String> node_tissue = new ArrayList<String>();

if(mRNA_tissue.equals("All_tissue")){
//无组织	
for(int at=0;at<alone_tissue.size();at++){
	String mrr="";
	db.open();
	sel = "select mRNA from "+resource+"_"+a_f+"_paste where tissue_type='"+alone_tissue.get(at)+"' and ID='"+ID+";"+NODE+"'";
	rs=db.execute(sel);
	while(rs.next()){
		mrr=rs.getString("mRNA");
	}
	rs.close();
	db.close();
	String[] set1 = mrr.toString().split(";");	
	for(int n4=0;n4<set1.length;n4++){		
		String[] result = set1[n4].split(":");
		//将科学记数法字符串转换成数字字符串
		//BigDecimal ee = new BigDecimal(result[2]);
		//result[2] = ee.toPlainString();
		result[3] = result[3].replace(" ","");		
		double R_v = Double.parseDouble(result[3]);
		double P_v = Double.parseDouble(result[2]);
		if(result[3].compareTo("0") < 0){
			result[3] = result[3].split("-")[1];
		}
		String end_altiss = ((alone_tissue.get(at).replace("NA_","")).replace("_"," ")).replace("-"," ");
		if(mRNA_classification.equals("All")){
			//无组织，无分类
			if(result[3].compareTo(i4) > 0){//判断R值
			out.println("<tr>");
			out.println("<td>"+result[1]+"</td>");             
            out.println("<td>"+end_altiss+"</td>");
            out.println("<td>"+result[5]+"</td>");
            out.println("<td>"+result[4]+"</td>");
            out.println("<td>"+String.format("%.4f",R_v)+"</td>");
            out.println("<td>"+String.format("%.4f",P_v)+"</td>");
            out.println("</tr>");
            
            mRNA1 = "\',\'" +result[0] + mRNA1;//mRNA  ID
            node.add(result[1]);
            node_id.add(result[0]);
            node_tissue.add(alone_tissue.get(at));
		}
		}else{
			//无组织，有分类
			if(result[4].equals(mRNA_classification)){
			if(result[3].compareTo(i4) > 0){//判断R值
			out.println("<tr>");
			out.println("<td>"+result[1]+"</td>");             
            out.println("<td>"+end_altiss+"</td>");
            out.println("<td>"+result[5]+"</td>");
            out.println("<td>"+result[4]+"</td>");
            out.println("<td>"+String.format("%.4f",R_v)+"</td>");
            out.println("<td>"+String.format("%.4f",P_v)+"</td>");
            out.println("</tr>");
            
            mRNA1 = "\',\'" +result[0] + mRNA1;//mRNA  ID
            node.add(result[1]);
            node_id.add(result[0]);
            node_tissue.add(alone_tissue.get(at));
			}
		 }
		}		
	}
}
}else{
//有组织
	String mrr="";
	db.open();
	sel = "select mRNA from "+resource+"_"+a_f+"_paste where tissue_type='"+mRNA_tissue+"' and ID='"+ID+";"+NODE+"'";
	rs=db.execute(sel);
	while(rs.next()){
		mrr=rs.getString("mRNA");
	}
	rs.close();
	db.close();
	String[] set1 = mrr.toString().split(";");
	
	for(int n4=0;n4<set1.length;n4++){		
		String[] result = set1[n4].split(":");		
		//将科学记数法字符串转换成数字字符串
		//BigDecimal ee = new BigDecimal(result[2]);
		//result[2] = ee.toPlainString();
		result[3] = result[3].replace(" ","");		
		double R_v = Double.parseDouble(result[3]);
		double P_v = Double.parseDouble(result[2]);
		if(result[3].compareTo("0") < 0){
			result[3] = result[3].split("-")[1];
		}
		String end_mtiss = ((mRNA_tissue.replace("NA_","")).replace("_"," ")).replace("-"," ");
		if(mRNA_classification.equals("All")){
			//有组织，无分类
			if(result[3].compareTo(i4) > 0){//判断R值
			out.println("<tr>");
			out.println("<td>"+result[1]+"</td>");             
            out.println("<td>"+end_mtiss+"</td>");
            out.println("<td>"+result[5]+"</td>");
            out.println("<td>"+result[4]+"</td>");
            out.println("<td>"+String.format("%.4f",R_v)+"</td>");
            out.println("<td>"+String.format("%.4f",P_v)+"</td>");
            out.println("</tr>");
            
            mRNA1 = "\',\'" +result[0] + mRNA1;//mRNA  ID
            node.add(result[1]);
            node_id.add(result[0]);
            node_tissue.add(mRNA_tissue);
		}
		}else{
			//有组织，有分类
			if(result[4].equals(mRNA_classification)){
			if(result[3].compareTo(i4) > 0){//判断R值
			out.println("<tr>");
			out.println("<td>"+result[1]+"</td>");             
            out.println("<td>"+end_mtiss+"</td>");
            out.println("<td>"+result[5]+"</td>");
            out.println("<td>"+result[4]+"</td>");
            out.println("<td>"+String.format("%.4f",R_v)+"</td>");
            out.println("<td>"+String.format("%.4f",P_v)+"</td>");
            out.println("</tr>");
            
            mRNA1 = "\',\'" +result[0] + mRNA1;//mRNA  ID
            node.add(result[1]);
            node_id.add(result[0]);
            node_tissue.add(mRNA_tissue);
		    }
		  }
		}		
	}
}
%>
</tbody>
</div>	
</table>
</form>
</div>

<div class="container-fluid">
<% if(mRNA1==""||node.get(0)==null||node.get(0)==""){%>
<div style="height:340px;width:438px;"></div>
<%}else{  %>

<div style="margin-top:50px;">
<div class="card" style="max-width: 1300px;">
  <div class="row no-gutters">
    <div class="col-md-8">
      <div class="card-body">
      <div style="float:left;">
		<div id="graph" style="height:700px;width:800px;margin:0 auto;"></div>
	  </div>
	  </div>
    </div>
    <div class="col-md-4" style="background-color: #f8f9fb;">
      <div class="card-img">
        <div class="right-container" style="float:right;margin-top: 75px;margin-right: 68px;"></div>
        <div style="float:right;margin-top: 148px;margin-right: 55px;">
		<div class="row"><img class="comRNA-img coexp-img-size" src="images/details/lncRNA.png"/><span class="comRNA-text">lncRNA</span></div>
		<div class="row"><img class="comRNA-img coexp-img-size" src="images/details/mRNA.png"/><span class="comRNA-text">mRNA</span></div>
		<div class="row"><img class="comRNA-img" src="images/details/tissue.png"/><span class="comRNA-text">mRNA with the <%=cell %></span></div>
		<div class="row"><img class="comRNA-img" src="images/details/other.png"/><span class="comRNA-text">other mRNA</span></div>
		</div>
      </div>
    </div>
  </div>
</div>
</div>
<%int n44=node.size(); 
//System.out.println(node.get(3));
//System.out.println(node_tissue.get(3));
%>
<script>
var dom = document.getElementById("graph");
var myChart = echarts.init(dom);
var app = {};
option=null;
app.configParameters = {
    size: {
	   min: 4,
	   max: 30
	}
};
app.config = {
	<%
		if(n44<=70){
			out.println("size:15,");
		}else if(n44<=250&&n44>70){
			out.println("size:10,");
		}else if(n44>250){
			out.println("size:5,");
		}
	%>
    //size: 15,
    onChange: function () {
        myChart.setOption({
        series: {
            type: 'graph',
            symbolSize:app.config.size,
            label: {
                normal: {
                    fontSize: app.config.size
                }
            }
        }
        });
    }
	};
var gui=null;
option = null;
if (app.config) {
	gui = new dat.GUI({
        autoPlace: false
    });
    $(gui.domElement).css({
    	width:248,
        height:49,
        zIndex: 1000
    });
    $('.right-container').append(gui.domElement);

    var configParameters = app.configParameters || {};
    for (var name in app.config) {
        var value = app.config[name];
        
        if (name !== 'onChange' && name !== 'onFinishChange') {
            var isColor = false;
            var controller;
            if (configParameters[name]) {
                if (configParameters[name].options) {
                    controller = gui.add(app.config, name, configParameters[name].options);
                }
                else if (configParameters[name].min != null) {
                    controller = gui.add(app.config, name, configParameters[name].min, configParameters[name].max);
                }
            }
            app.config.onChange && controller.onChange(app.config.onChange);
            app.config.onFinishChange && controller.onFinishChange(app.config.onFinishChange);
        }
    }
}
option = {
		title: {
            text: 'Co-expressed mRNAs',
            subtext: '',
            top: 'top',
            left: 'center'
        },
		toolbox: {
	        show : true,
	        feature : {
	            mark : {show: true},
	            magicType : {
	                show: true,
	                type: ['pie', 'funnel']
	            },
	            restore : {show: true},
	            saveAsImage : {show: true}
	        }
	    },
        animationDuration: 3000,
        animationEasingUpdate: 'quinticInOut',
        series : [{
                name: '',
                type: 'graph',
                layout: 'circular',  //circular/none
                circular: {
                	rotateLabel: true
            	},
            	data: [
                    	<%out.println("{name:'"+NODE+"',id:'0',itemStyle:{color:'#D8AFF1'},symbol:'diamond',symbolSize:25,label:{show:true,position:'right'}},");%>
                        <% for(int n=0;n<n44-1;n++){
                        	if(node_tissue.get(n).indexOf(tissue_pd)>=0){
                        		out.println("{name:'"+node.get(n)+"',id:'"+(n+1)+"',itemStyle:{color:'#D8AFF1'},label:{show:true,position:'right'}},");
                        	}else{
                        		out.println("{name:'"+node.get(n)+"',id:'"+(n+1)+"',itemStyle:{color:'#D8D8D8'},label:{show:true,position:'right'}},");
                        	}
                        }
                        if(node_tissue.get(n44-1).indexOf(tissue_pd)>=0){
                        	out.println("{name:'"+node.get(n44-1)+"',id:'"+n44+"',itemStyle:{color:'#D8AFF1'},label:{show:true,position:'right'}},");
                        }else{
                        	out.println("{name:'"+node.get(n44-1)+"',id:'"+n44+"',itemStyle:{color:'#D8D8D8'},label:{show:true,position:'right'}},");
                        }
                        %>
                ],
                links: [
						<% //for(int n=0;n<249;n++){
							//out.println("{source:'0',target:'"+(n+1)+"'},");
						//}
						%>
						<% for(int n=0;n<n44-1;n++){
							out.println("{source:'0',target:'"+(n+1)+"'},");
						}
						out.println("{source:'0',target:'"+n44+"'},");
						%>
                ],
                roam: true,
                focusNodeAdjacency: true,
            	itemStyle: {
                	normal: {
                    	borderColor: '#fff',
                    	borderWidth: 1,
                    	shadowBlur: 15,
                    	shadowColor: 'rgba(0, 0, 0, 0.3)'
                	}
            	},
            	symbolSize:app.config.size,
                label: {
                    normal: {
                        position: 'top',
                        formatter: '{b}',
                        fontSize:app.config.size,
                    }
                },
                lineStyle: {
                	color: 'source',
                	curveness: 0.2
                },
            	emphasis: {
                	lineStyle: {
                    	width: 10
                	}
            	}
            }]
};
myChart.setOption(option);
</script>
<%}%>
</div>
</div>

</div>
</section>
</div>

<%if(node.size()>0){%>
<div class="sidebar">
<section id="floatMenu5" style="background-color: #fff;">				
<div class="heading">
<h3><a class="font-color">Function</a></h3>
</div>
<div class="content card card-body">
<div class="row">
	<div id="KEGGFun" style="width:1100px;height:500px"></div>
</div>
<div class="row">
	<div id="GOFun" style="width:1100px;height:500px"></div>
</div>
</div>
</section>
</div>
<% 
String path_pathway=application.getRealPath("Pathway").replace("\\","/")+"/";
//System.out.println(path_pathway);
String geneList="";
for(int y=0;y<node.size();y++){
	geneList += node.get(y)+",";
}
//System.out.println(geneList);
RConnection rc = new RConnection();

rc.assign("geneList",geneList);
rc.eval("geneList <- unlist(strsplit(geneList,','))");
rc.eval("KEGG_path <- clusterProfiler::read.gmt('"+path_pathway+"KEGG.gmt')");
rc.eval("KEGG <- clusterProfiler::enricher(geneList,TERM2GENE=KEGG_path)");
rc.eval("KEGG <- as.data.frame(KEGG)");
rc.eval("if(dim(KEGG)[1]>=5){KEGG_top = KEGG[order(KEGG$p.adjust,decreasing = F),][1:5,]}else{KEGG_top = KEGG}");
rc.eval("KEGG_top$p.adjust <- format(KEGG_top$p.adjust,digits = 4)");
rc.eval("KEGGre = paste0(\"[\",KEGG_top$GeneRatio,\",'\",KEGG_top$ID,\"',\",KEGG_top$Count,\",\",KEGG_top$p.adjust,\"]\")");
rc.eval("KEGGre = paste0(KEGGre,collapse = ',')");
rc.eval("KEGGre = paste0('[',KEGGre,']')");
rc.eval("if(dim(KEGG)[1]==0){KEGGre = \"[[0,'No Result',0,0]]\"}");
String KEGG_re = rc.eval("KEGGre").asString();
//System.out.println(KEGG_re);

rc.eval("GO_path <- clusterProfiler::read.gmt('"+path_pathway+"GOBP.gmt')");
rc.eval("GO <- clusterProfiler::enricher(geneList,TERM2GENE=GO_path)");
rc.eval("GO <- as.data.frame(GO)");
rc.eval("if(dim(GO)[1]>=5){GO_top<-GO[order(GO$p.adjust,decreasing = F),][1:5,]}else{GO_top<-GO}");
rc.eval("GO_top$p.adjust <- format(GO_top$p.adjust,digits = 4)");
rc.eval("GOre = paste0(\"[\",GO_top$GeneRatio,\",'\",GO_top$ID,\"',\",GO_top$Count,\",\",GO_top$p.adjust,\"]\")");
rc.eval("GOre = paste0(GOre,collapse = ',')");
rc.eval("GOre = paste0('[',GOre,']')");
rc.eval("if(dim(GO)[1]==0){GOre = \"[[0,'No Result',0,0]]\"}");
String GO_re = rc.eval("GOre").asString();

rc.close();
%>

<script>
var chartDom = document.getElementById('KEGGFun');
var myChartKEGGFun = echarts.init(chartDom,null,{renderer:'svg'});
myChartKEGGFun.showLoading();
var data = eval(<%=KEGG_re%>);
var data2 = [];
for(var i=0;i<data.length;i++){
  data2.push(data[i][2])
}
data2min = Math.min.apply(null,data2)
data2max = Math.max.apply(null,data2)

var data3 = [];
for(var i=0;i<data.length;i++){
  data3.push(data[i][3])
}
data3min = Math.min.apply(null,data3)
data3max = Math.max.apply(null,data3)
option = {
  title:{
	  text:'i)KEGG Enrichment',
	  left:'center',
  },
	grid: {
    left: '50%',
    right: 150,
    top: '18%',
    bottom: '10%'
  },
  tooltip: {
    backgroundColor: 'rgba(255,255,255,0.7)',
    formatter: function (param) {
      var value = param.value;
      return 'Pathway：' + value[1] + '<br>'
              + 'P.adjust：' + value[3] + '<br>'
              + 'Count：' + value[2] + '<br>';
    }
  },
  visualMap: [
    {
      left: 'right',
      top: '10%',
      dimension: 2,
      min: data2min,
      max: data2max,
      itemWidth: 30,
      calculable: false,
      precision: 0.1,
      text: ['Count'],
      inRange: {
        symbolSize: [10, 30],
      },
      outOfRange: {
        symbolSize: [10, 30],
        color: ['grey']
      },
      controller: {
        inRange: {
          color: ['grey']
        },
        outOfRange: {
          color: ['grey']
        }
      }
    },
    {
      left: 'right',
      top: '45%',
      dimension: 3,
      min: data3min,
      max: data3max,
      itemWidth: 30,
      calculable: true,
      precision: 0.0001,
      text: ['P.adjust'],
      inRange: {
        color: ['blue','red'],
      },
      outOfRange: {
        color: ['grey'],
      },
      controller: {
        inRange: {
          color: ['blue','red']
        },
        outOfRange: {
          color: ['grey']
        }
      }
    
    }
  ],
  xAxis: {
    type: 'value',
    name: 'GeneRadio',
    nameGap: 16,
    nameTextStyle: {
      fontSize: 16
    },
    splitLine: {
      show: true
    }
  },
  yAxis: {
    type: 'category',
    name: 'Pathway',
    nameLocation: 'end',
    nameGap: 20,
    nameTextStyle: {
      fontSize: 16
    },
    splitLine: {
      show: false
    }
  },
  series: [
    {
      type: 'scatter',
      data: data
    },
  ]
};
myChartKEGGFun.setOption(option);
myChartKEGGFun.hideLoading();

var chartDom = document.getElementById('GOFun');
var myChartGOFun = echarts.init(chartDom,null,{renderer:'svg'});
myChartGOFun.showLoading();
var data = eval(<%=GO_re%>);
var data2 = [];
for(var i=0;i<data.length;i++){
  data2.push(data[i][2])
}
data2min = Math.min.apply(null,data2)
data2max = Math.max.apply(null,data2)

var data3 = [];
for(var i=0;i<data.length;i++){
  data3.push(data[i][3])
}
data3min = Math.min.apply(null,data3)
data3max = Math.max.apply(null,data3)
option = {
	title:{
		  text:'ii)GO Enrichment',
		  left:'center',
	  },
	grid: {
    left: '50%',
    right: 150,
    top: '18%',
    bottom: '10%'
  },
  tooltip: {
    backgroundColor: 'rgba(255,255,255,0.7)',
    formatter: function (param) {
      var value = param.value;
      return 'Pathway：' + value[1] + '<br>'
              + 'P.adjust：' + value[3] + '<br>'
              + 'Count：' + value[2] + '<br>';
    }
  },
  visualMap: [
    {
      left: 'right',
      top: '10%',
      dimension: 2,
      min: data2min,
      max: data2max,
      itemWidth: 30,
      calculable: false,
      precision: 0.1,
      text: ['Count'],
      inRange: {
        symbolSize: [10, 30],
      },
      outOfRange: {
        symbolSize: [10, 30],
        color: ['grey']
      },
      controller: {
        inRange: {
          color: ['grey']
        },
        outOfRange: {
          color: ['grey']
        }
      }
    },
    {
      left: 'right',
      top: '45%',
      dimension: 3,
      min: data3min,
      max: data3max,
      itemWidth: 30,
      calculable: true,
      precision: 0.0001,
      text: ['P.adjust'],
      inRange: {
        color: ['blue','red'],
      },
      outOfRange: {
        color: ['grey'],
      },
      controller: {
        inRange: {
          color: ['blue','red']
        },
        outOfRange: {
          color: ['grey']
        }
      }
    
    }
  ],
  xAxis: {
    type: 'value',
    name: 'GeneRadio',
    nameGap: 16,
    nameTextStyle: {
      fontSize: 16
    },
    splitLine: {
      show: true
    }
  },
  yAxis: {
    type: 'category',
    name: 'Pathway',
    nameLocation: 'end',
    nameGap: 20,
    nameTextStyle: {
      fontSize: 16
    },
    splitLine: {
      show: false
    }
  },
  series: [
    {
      type: 'scatter',
      data: data
    },
  ]
};
myChartGOFun.setOption(option);
myChartGOFun.hideLoading();

</script>
<%}else{ %>

<div class="sidebar">
<section id="floatMenu5" style="background-color: #fff;">				
<div class="heading">
<h3><a class="font-color">Function</a></h3>
</div>
<div class="content card card-body">
<h6>No result!</h6>
</div>
</section>
</div>
<%}}%>
</div>

<!-- 内容 end -->
<script>
$(document).ready(function () {
	var table = $('#lnc_mrna').DataTable({
		"filter":false,
		dom: 'Bfrtip',
		buttons: [
		{extend:'csv',exportOptions:  {columns:[0,1,2,3,4]}},
		{extend:'excel',exportOptions:{columns:[0,1,2,3,4]}},
		//{extend:'pdf',exportOptions:  {columns: [0,1,2,3,4]}}
		]
	})
});
</script>
</body>
</html>