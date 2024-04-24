<%@ page import="action.Array3" import="util.*" import="action.ChartsData" language="java"
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

</head>
<style>
.TCGA_survival_XBT{
	float: left;
    font-size: 20px;
    padding-top:16px;
}
</style>
<%
//String path=application.getRealPath("enrich").replace("\\","/")+"/";
String path_survival=application.getRealPath("survival").replace("\\","/")+"/";
String output_error=application.getRealPath("output").replace("\\","/")+"/";
//System.out.println(output_error);
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

//String chr = request.getParameter("chr");
String ID = request.getParameter("Name");
String location="";
String type="";
//String rs_a  = request.getParameter("classification");
String rs_t = "";
//String resource1 = request.getParameter("resource");
String resource = "";
String gse = "";
String NODE=""; //gene的名字
//String cell=request.getParameter("celltype");
String tissue_pd = "";
String tissue_pd4 = "";//tissue_pd用于网络图进行判断是否是组织特异,同时用于判断癌症放到前面
String a_f = "";
//String cell_pd = cell;
tissue_pd4 = request.getParameter("tissue");
tissue_pd = tissue_pd4;
a_f = "adult";
NODE = request.getParameter("NODE");


String cancer_paste="";
db.open();
sel = "select tcga from survival_cancer where cancer ='" + tissue_pd + "' ";
rs = db.execute(sel);
while(rs.next()){
	cancer_paste = rs.getString("tcga");
}
db.close();
%>

<body>

<%
List<String> Cancer_1 = new ArrayList<String>();
Cancer_1.add("BLCA");Cancer_1.add("BRCA");Cancer_1.add("CHOL");Cancer_1.add("COAD");Cancer_1.add("ESCA");
Cancer_1.add("HNSC");Cancer_1.add("KICH");Cancer_1.add("KIRC");Cancer_1.add("KIRP");Cancer_1.add("LIHC");
Cancer_1.add("LUAD");Cancer_1.add("LUSC");Cancer_1.add("PRAD");Cancer_1.add("READ");Cancer_1.add("STAD");Cancer_1.add("THCA");Cancer_1.add("UCEC");

List<String> Cancer = new ArrayList<String>();
if(cancer_paste.contains(";")){
	String[] tmp_ca = cancer_paste.split(";");
	for(int mm=0;mm<tmp_ca.length;mm++){
		Cancer.add(tmp_ca[mm]);
	}
}else{
	Cancer.add(cancer_paste);
}
/*if(tissue_pd.contains("_")){
	Cancer.add(tissue_pd.split("_")[0]);
	Cancer.add(tissue_pd.split("_")[2]);
}else if(tissue_pd.equals("NSCLC")){
	Cancer.add("LUAD");
	Cancer.add("LUSC");
}else{
	Cancer.add(tissue_pd);
}*/
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

	db1.close();
	
	if(data_cancer0==""||data_normal0==null||data_cancer0==null||data_normal0==""){%>
		
<%	}else{
%>
<!-- 7. Differential expression start -->
<div class="sidebar" >
<section id="floatMenu7" style="background-color:#fff;">				
<div class="heading">
<h3><a class="font-color">Differential expression analysis</a></h3>
</div>
<div class="content card card-body">

	<%
for(int c=0;c<Cancer.size();c++){
	String p_diff="";
	String method="";
	String normal_mean="";
	String cancer_mean="";
	String type_diff="";
	String data_cancer="";
	String data_normal="";
	String data_cancer_log = "";
	String data_normal_log = "";
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
			String[] tmp_data_cancer = data_cancer.split(",");
			for(int mm=0;mm<tmp_data_cancer.length;mm++){
				double logValue; 
				Double tmp_number = Double.parseDouble(tmp_data_cancer[mm]);
				logValue = Math.log(tmp_number+1) / Math.log(2);
				data_cancer_log += logValue+",";
			}
			//out.println(data_cancer_log);
			
			sel="select * from different_normal where ID = '"+ID+"'";
			rs=db1.execute(sel);
			while(rs.next()){
				data_normal=rs.getString(Cancer.get(c));
			}
			String[] tmp_data_normal = data_normal.split(",");
			for(int mm=0;mm<tmp_data_normal.length;mm++){
				Double logValue;
				Double tmp_number = Double.parseDouble(tmp_data_normal[mm]);
				logValue = Math.log(tmp_number+1) / Math.log(2);
				data_normal_log += logValue+",";
			}
			//out.println(data_normal_log);
		}
	}
	db1.close();
	if(data_cancer==""||data_normal==null||data_cancer==null||data_normal==""){
%>			
<%	}else{
%>

<div id="Table_body_details">
					<table id="diff-table<%=c %>" class="table-lyj round-border" style="width:100%;">
						<tr class="single">
							<th>LncRNA Name</th>
							<th>Cancer</th>
							<th>Differential Type</th>
							<th>Mean in Cancer</th>
							<th>Mean in Control</th>
							<th title="<%=method%>">
							P
							</th>
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
    $('#diff-table<%=c%>').DataTable(
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
					  title:{
						  text:'Differential analysis',
						  left:'center',
						  top:'10%'
					  },
					  dataset: [
					    {
					      // prettier-ignore
					      source: [[<%= data_cancer_log%>],
					                [<%= data_normal_log%>]]
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
					    //y: '10%',
					    data: ['lncRNA'],
					    bottom:0,
					  },
					  tooltip: {
					    trigger: 'item',
					    axisPointer: {
					      type: 'shadow'
					    }
					  },
					  grid: {
					    left: '15%',
					    top: '20%',
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
					    name: 'Expression level(log2(FPKM+1))',
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
}}
%>

</div>
</section>
</div>
<% }}//判断是否画箱式图结束%>
<!-- 7. Differential expression end -->
<!-- 8. Survival analysis start -->

<%if(!tissue_pd.equals("MM")){//判断是否画生存  %>
<div class="sidebar" >
<section id="floatMenu8" style="background-color:#fff;">				
<div class="heading">
<h3><a class="font-color">Survival analysis</a></h3>
</div>
<div class="content card card-body">

<div id="Table_body_details" class="container-fluid content-fontsize">
	<%
			for(int c=0;c<Cancer.size();c++){							
					db1.open();
					String sur="";
					String survival="";
					sel = "select * from tcga_exp where ID ='" + ID + "'" ;
					rs=db1.execute(sel);
					while(rs.next()){
						sur=rs.getString(Cancer.get(c));
						survival=rs.getString(Cancer.get(c));
					}
					db1.close();
									
								
				if(sur.equals("")||sur.equals(null)){					
					out.println("<h3>No result!</h3>");
				}else{								
				
				try{	
				if(Cancer.size()>1){//判断是否输出标题，如果仅有一个癌症，标题样式不同
				%>
				<div class="row">
				<div style="font-size:24px"><%=c+1 %>) Survival analysis results of <%=NODE %> in <%=Cancer.get(c) %></div>
				</div>
				<div class="row">
				<div class="col-6">
				<div class="TCGA_survival_XBT">i) The results of cox regression analysis</div>
				</div>
				<div class="col-6">
				<div class="TCGA_survival_XBT">ii) Kaplan-Meier survival curve</div>
				</div>
				</div>
				<%}else{%>
				<div class="row">
				<div class="col-6">
				<div class="TCGA_survival_XBT">i) The results of cox regression analysis</div>
				</div>
				<div class="col-6">
				<div class="TCGA_survival_XBT">ii) Kaplan-Meier survival curve</div>
				</div>
				</div>
				<%
				}
				}catch(Exception e){
					e.printStackTrace();
				    out.println("no survival000");
				}
				
				db1.open();
				out.println("<div class=\"row\">");
				out.println("<div class=\"col-6\">");
				//out.println("<div style=\"font-size:20px\">"+NODE+" in "+Cancer.get(c)+"(cox regression)</div>");
// 				if(resource.equals("tcga")){
					out.println("<table style=\"border-collapse:collapse;border:solid #000000;border-width:2px 0px 2px 0px;height:313px;width:430px\">");
// 				}else if(resource.equals("target")){
// 					out.println("<table style=\"border-collapse:collapse;border:solid #000000;border-width:2px 0px 2px 0px;height:100px;width:430px\">");
// 				}
				sel="select * from tcga_cox where lncRNA ='" + ID + "' and cancer ='"+Cancer.get(c) +"'" ;
				rs=db1.execute(sel);
				while(rs.next()){
					out.println("<tr><td style=\"border:solid #000000;border-width:0px 0px 2px 0px;\"></td><td style=\"border:solid #000000;border-width:0px 0px 2px 0px;\"></td><td style=\"border:solid #000000;border-width:0px 0px 2px 0px;\">beta</td><td style=\"border:solid #000000;border-width:0px 0px 2px 0px;\">HR</td><td style=\"border:solid #000000;border-width:0px 0px 2px 0px;\">P</td></tr>");
					out.println("<tr><td>univariate</td><td>"+NODE+"</td><td>"+rs.getString(3)+"</td>");
					out.println("<td>"+rs.getString(4)+"</td>");
					out.println("<td>"+rs.getString(5)+"</td></tr>");
				}
				//TARGET资源只有单变量cox,这里只显示TCGA资源就可以
// 				if(resource.equals("tcga")){
					out.println("<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
					sel="select * from tcga_cox_multivariable where lncRNA ='" + ID + "' and cancer ='"+Cancer.get(c) +"'" ;
					rs=db1.execute(sel);
					while(rs.next()){
						out.println("");
						out.println("<tr><td></td><td>"+NODE+"</td><td>"+rs.getString(3)+"</td>");
						out.println("<td>"+rs.getString(4)+"</td>");
						out.println("<td>"+rs.getString(5)+"</td></tr>");
						out.println("<tr><td>multivariate</td><td>gender</td><td>"+rs.getString(6)+"</td>");
						out.println("<td>"+rs.getString(7)+"</td>");
						out.println("<td>"+rs.getString(8)+"</td></tr>");
						out.println("<tr><td></td><td>age</td><td>"+rs.getString(9)+"</td>");
						out.println("<td>"+rs.getString(10)+"</td>");
						out.println("<td>"+rs.getString(11)+"</td></tr>");
						out.println("<tr><td></td><td>stage</td><td>"+rs.getString(12)+"</td>");
						out.println("<td>"+rs.getString(13)+"</td>");
						out.println("<td>"+rs.getString(14)+"</td></tr>");
					}
// 				}
				out.println("</table>");
				out.println("</div>");
%>
			<%
			/*sel="select p_value from result where ID ='" + ID + "' and cancer ='"+Cancer.get(c) +"'" ;
			rs=db.execute(sel);
			String p="";
			while(rs.next()){
			   p=rs.getString(1);
			}*/
			
			/*String survival="";
			sel = "select * from tcga_exp where ID ='" + ID + "'" ;
			rs=db1.execute(sel);
			while(rs.next()){
				survival=rs.getString(Cancer.get(c));
			}*/
			String[] survival1 = survival.split(",");	  
			
			sel="select * from tcga_cli where cancer = '"+Cancer.get(c)+"'";
			rs=db1.execute(sel);
			ResultSetMetaData rsmd;
			int i=0;
			rs.last();
			int row=rs.getRow();
			rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			rs.first();
			//rs=sql.executeQuery(sel);
			String[][] survival2 = new String[row][col-1];
			
			RConnection rc = new RConnection();
			
			try{rc.eval("cli <- data.frame()");}catch(Exception e){out.println(e+"no survival111");rc.eval("write.table(cli,'"+output_error+"1.txt')");}
			try{
				for(i=0;i<row;i++){
					for(int n=0;n<col-1;n++){
						survival2[i][n] = rs.getString(n+1);//out.println(survival2[i][n]+"<br/>");
					}
					rc.assign("x",survival2[i]);
					rc.eval("cli <- rbind(cli,as.data.frame(t(x),stringsAsFactors = F))");
					//i++;
					rs.next();
				}
			}catch(Exception e){
	    		out.println(e+"no survival222");
	    		rc.eval("write.table(cli,'"+output_error+"2.txt')");
	    	}	
				db1.close();
				try{rc.assign("expr",survival1);}catch(Exception e){
	    			out.println(e+"no survival333");
	    			rc.eval("write.table(expr,'"+output_error+"3.txt')");
	    		}
				try{rc.assign("rownames",ID);}catch(Exception e){e.printStackTrace();out.println(e+"no survival333");rc.eval("write.table(rownames,'"+output_error+"4.txt')");}
				try{rc.eval("library(survival)");}catch(Exception e){e.printStackTrace();out.println("no survival444");rc.eval("write.table('5',"+output_error+"5.txt')");}
				try{rc.eval("expr = as.numeric(expr)");}catch(Exception e){e.printStackTrace();out.println(e+"no survival555");rc.eval("write.table(expr,'"+output_error+"6.txt')");}
				try{rc.eval("expr = as.data.frame(t(expr),stringsAsFactors = F)");}catch(Exception e){e.printStackTrace();out.println(e+"no survival666");rc.eval("write.table(expr,'"+output_error+"7.txt')");}
				try{rc.eval("colnames(expr) <- cli[,1]");}catch(Exception e){e.printStackTrace();out.println(e+"no survival777");rc.eval("write.table('8','"+output_error+"8.txt')");}
				try{rc.eval("temp_lnc_exp <- expr[1,]");}catch(Exception e){e.printStackTrace();out.println(e+"no survival888");rc.eval("write.table('9','"+output_error+"9.txt')");}
				//TARGET原始文件已经log转换，不必进行log
// 				if(resource.equals("tcga")){
				try{rc.eval("temp_lnc_exp <- log2(temp_lnc_exp+0.01)");}catch(Exception e){e.printStackTrace();out.println(e+"no survival999");rc.eval("write.table(temp_lnc_exp,'"+output_error+"10.txt')");}
// 				}else if(resource.equals("target")){}
				try{rc.eval("low_score<- quantile(as.matrix(temp_lnc_exp),0.2)");}catch(Exception e){e.printStackTrace();out.println(e+"no survival10");rc.eval("write.table(low_score,'"+output_error+"11.txt')");}
				try{rc.eval("high_score<- quantile(as.matrix(temp_lnc_exp),1-0.2)");}catch(Exception e){e.printStackTrace();out.println(e+"no survival11");rc.eval("write.table(high_score,'"+output_error+"12.txt')");}
				try{rc.eval("low_index <- temp_lnc_exp<=low_score");}catch(Exception e){e.printStackTrace();out.println(e+"no survival12");rc.eval("write.table(low_index,'"+output_error+"13.txt')");}
				try{rc.eval("high_index <- temp_lnc_exp>=high_score");}catch(Exception e){e.printStackTrace();out.println(e+"no survival13");rc.eval("write.table(high_index,'"+output_error+"14.txt')");}
				try{rc.eval("low_sample <- colnames(temp_lnc_exp)[low_index]");}catch(Exception e){e.printStackTrace();out.println(e+"no survival14");rc.eval("write.table(low_sample,'"+output_error+"15.txt')");}
				try{rc.eval("high_sample <- colnames(temp_lnc_exp)[high_index]");}catch(Exception e){e.printStackTrace();out.println(e+"no survival15");rc.eval("write.table(high_sample,'"+output_error+"16.txt')");}
				try{rc.eval("temp_low_cli <- cli[cli[,1]%in%low_sample,]");}catch(Exception e){e.printStackTrace();out.println(e+"no survival16");rc.eval("write.table(temp_low_cli,'"+output_error+"17.txt')");}
				try{rc.eval("temp_high_cli <- cli[cli[,1]%in%high_sample,]");}catch(Exception e){e.printStackTrace();out.println(e+"no survival17");rc.eval("write.table(temp_high_cli,'"+output_error+"18.txt')");}
				try{rc.eval("temp_result_cli <- data.frame(rbind(temp_low_cli,temp_high_cli),label=c(rep(\"low\",nrow(temp_low_cli)),rep(\"high\",nrow(temp_high_cli))))");}catch(Exception e){
					e.printStackTrace();
					out.println(e+"no survival18");
					rc.eval("write.table(temp_result_cli,'"+output_error+"19.txt')");
				}
				try{rc.eval("setwd(\""+path_survival+"\")");}catch(Exception e){e.printStackTrace();out.println(e+"no survival19");}
				try{rc.eval("dif<-survdiff(Surv(as.numeric(as.character(temp_result_cli[,3])),as.numeric(as.character(temp_result_cli[,2])))~label,data=temp_result_cli)");}catch(Exception e){
					e.printStackTrace();
					out.println(e+"no survival19");
					rc.eval("write.table(dif,'"+output_error+"20.txt')");
				}
				try{rc.eval("temp_p <- round(1-pchisq(dif[[5]],1),4)");}catch(Exception e){e.printStackTrace();out.println(e+"no survival20");rc.eval("write.table(temp_p,'"+output_error+"21.txt')");}
				try{rc.eval("fit<-survfit(Surv(as.numeric(as.character(temp_result_cli[,3])),as.numeric(as.character(temp_result_cli[,2])))~label,data=temp_result_cli)");}catch(Exception e){e.printStackTrace();out.println(e+"no survival21");rc.eval("write.table(fit,'"+output_error+"22.txt')");}
				Random random = new Random();
				int ra = random.nextInt(100000000);
				try{rc.eval("jpeg(\""+ra+".jpg\")");}catch(Exception e){e.printStackTrace();out.println(e+"no survival22");rc.eval("write.table('23','"+output_error+"23.txt')");}
				try{rc.eval("plot(fit,xlab=\"survival time\",ylab=\"survival probability\",cex.lab=1.5,mark=3,cex.main=1.5,col=c(\"firebrick1\",\"forestgreen\"),lwd=2)");}catch(Exception e){e.printStackTrace();out.println(e+"no survival23");rc.eval("write.table('24','"+output_error+"24.txt')");}
				try{rc.eval("aaa <- as.numeric(as.matrix(temp_result_cli)[,3])");}catch(Exception e){e.printStackTrace();out.println(e+"no survival24");rc.eval("write.table(aaa,'"+output_error+"25.txt')");}		
				try{rc.eval("text(max(aaa[!is.na(aaa)])/2,0.1,cex=1.5,paste0(\"log-rank p=\",temp_p))");}catch(Exception e){e.printStackTrace();out.println(e+"no survival25");rc.eval("write.table('26','"+output_error+"26.txt')");}
				try{rc.eval("legend(\"topright\",c(\"high\",\"low\"),lty=1,col=c(\"firebrick1\",\"forestgreen\"))");}catch(Exception e){e.printStackTrace();out.println(e+"no survival26");rc.eval("write.table('27','"+output_error+"27.txt')");}
				try{rc.eval("dev.off()");}catch(Exception e){e.printStackTrace();out.println(e+"no survival27");rc.eval("write.table('28','"+output_error+"28.txt')");}
				rc.close();
				try{				
				out.println("<div class=\"col-6\">");
				out.println("<img src=\"survival/"+ra+".jpg\" style=\"width: 444px;height:313px\"></img>");
				out.println("</div>");
				out.println("</div>");
				}catch(Exception e){e.printStackTrace();out.println(e+"no survival28");}
			}
							
			//delete file
			try{
				
			File file = new File(path_survival);
	  		File[] list = file.listFiles();
	  		Format simpleFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	  		Date now = new Date();
	  		int here = now.getDate(); 
	  		for (int ij = 0; ij < list.length; ij++)
	  		{
	  		    Date da = new Date(list[ij].lastModified());
	  		    int day = da.getDate();
	  		    if(Math.abs(here-day)>=1){
	  		    	list[ij].delete();
	  		    }
	  		}
	  		rs.close();
			}catch(Exception e){
				e.printStackTrace();
			    out.println(e+"no survivalFile");
			}
	  		%>
<%}%>
</div>
</div>
</section>
</div>
<% }else{ %>
<div class="sidebar">
<section id="floatMenu8" style="background-color:#fff;">				
<div class="heading">
<h3><a class="font-color">Survival analysis</a></h3>
</div>
<div class="content card card-body">
<div id="Table_body_details" class="container-fluid content-fontsize">
<h3>No result!</h3>
</div>
</div>
</section>
</div>
<% } %>

<!-- 8. Survival analysis end -->

</body>
</html>