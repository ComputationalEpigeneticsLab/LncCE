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
%>     
<div id="main-page">
<section id="content" style="background-color:#fff;">

<%
			for(int c=0;c<Cancer.size();c++){
				db1.open();
				String sur="";
				sel = "select * from tcga_exp where ID ='" + ID + "'" ;
				rs=db1.execute(sel);
				while(rs.next()){
					sur=rs.getString(Cancer.get(c));
				}
				db1.close();
				if(sur.equals("")){					
				}else{
				
				if(Cancer.size()>1){//判断是否输出标题，如果仅有一个癌症，标题样式不同
				%>
				<div class="container">

				<div class="row"><h5 class="card-title"><%=c+1 %>) Survival analysis results of <%=NODE %> in <%=Cancer.get(c) %></h5></div>
				<div class="row">
				<div class="TCGA_survival_XBT col"><h5 class="card-title">i) The results of cox regression analysis</h5></div>
				<div class="TCGA_survival_XBT col"><h5 class="card-title">ii) Kaplan-Meier survival curve</h5></div>
				</div>

				<div style="height: 27px;"></div>
				<%}else{%>
				<div class="row">
				<div class="col"><h5 class="card-title">i) The results of cox regression analysis</h5></div>
				<div class="col"><h5 class="card-title">ii) Kaplan-Meier survival curve</h5></div>
				</div>
				<div style="height: 27px;"></div>
				<%
				}
				db1.open();
				out.println("<div class=\"row\">");
				out.println("<div class=\"col\">");
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
			
			String survival="";
			sel = "select * from tcga_exp where ID ='" + ID + "'" ;
			rs=db1.execute(sel);
			while(rs.next()){
				survival=rs.getString(Cancer.get(c));
			}
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
			rc.eval("cli <- data.frame()");
				for(i=0;i<row;i++){
					for(int n=0;n<col-1;n++){
						survival2[i][n] = rs.getString(n+1);//out.println(survival2[i][n]+"<br/>");
					}
					rc.assign("x",survival2[i]);
					rc.eval("cli <- rbind(cli,as.data.frame(t(x),stringsAsFactors = F))");
					//i++;
					rs.next();
				}
				db1.close();
				
				rc.assign("expr",survival1);
				rc.assign("rownames",ID);
				rc.eval("library(survival)");
				rc.eval("expr = as.numeric(expr)");
				rc.eval("expr = as.data.frame(t(expr),stringsAsFactors = F)");
				rc.eval("colnames(expr) <- cli[,1]");
				rc.eval("temp_lnc_exp <- expr[1,]");
				//TARGET原始文件已经log转换，不必进行log
// 				if(resource.equals("tcga")){
					rc.eval("temp_lnc_exp <- log2(temp_lnc_exp+0.01)");
// 				}else if(resource.equals("target")){}
				rc.eval("low_score<- quantile(as.matrix(temp_lnc_exp),0.2)");
				rc.eval("high_score<- quantile(as.matrix(temp_lnc_exp),1-0.2)");
				rc.eval("low_index <- temp_lnc_exp<=low_score");
				rc.eval("high_index <- temp_lnc_exp>=high_score");
				rc.eval("low_sample <- colnames(temp_lnc_exp)[low_index]");
				rc.eval("high_sample <- colnames(temp_lnc_exp)[high_index]");
				rc.eval("temp_low_cli <- cli[cli[,1]%in%low_sample,]");
				rc.eval("temp_high_cli <- cli[cli[,1]%in%high_sample,]");
				rc.eval("temp_result_cli <- data.frame(rbind(temp_low_cli,temp_high_cli),label=c(rep(\"low\",nrow(temp_low_cli)),rep(\"high\",nrow(temp_high_cli))))");
				rc.eval("setwd(\""+path_survival+"\")");
				rc.eval("dif<-survdiff(Surv(as.numeric(as.character(temp_result_cli[,3])),as.numeric(as.character(temp_result_cli[,2])))~label,data=temp_result_cli)");
				rc.eval("temp_p <- round(1-pchisq(dif[[5]],1),4)");
				rc.eval("fit<-survfit(Surv(as.numeric(as.character(temp_result_cli[,3])),as.numeric(as.character(temp_result_cli[,2])))~label,data=temp_result_cli)");
				Random random = new Random();
				int ra = random.nextInt(100000000);
				rc.eval("jpeg(\""+ra+".jpg\")");
				rc.eval("plot(fit,xlab=\"survival time\",ylab=\"survival probability\",cex.lab=1.5,mark=3,cex.main=1.5,col=c(\"firebrick1\",\"forestgreen\"),lwd=2)");
				rc.eval("aaa <- as.numeric(as.matrix(temp_result_cli)[,3])");		
				rc.eval("text(max(aaa[!is.na(aaa)])/2,0.1,cex=1.5,paste0(\"log-rank p=\",temp_p))");
				rc.eval("legend(\"topright\",c(\"high\",\"low\"),lty=1,col=c(\"firebrick1\",\"forestgreen\"))");
				rc.eval("dev.off()");
				rc.close();
								
				out.println("<div class=\"col\">");
				out.println("<img src=\"survival/"+ra+".jpg\" style=\"height:313px\"></img>");
				out.println("</div>");
				out.println("</div>");
				out.println("</div>");
			}
			//delete file
			
			File file = new File(path_survival);
	  		File[] list = file.listFiles();
	  		Format simpleFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	  		Date now = new Date();
	  		int here = now.getDate(); 
	  		for (int i = 0; i < list.length; i++)
	  		{
	  		    Date da = new Date(list[i].lastModified());
	  		    int day = da.getDate();
	  		    if(Math.abs(here-day)>=1){
	  		    	list[i].delete();
	  		    }
	  		}
	  		rs.close();
%>
<%} %>
</div>
</section>	
</div>
</body>
</html>