<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="util.*" import="action.ChartsData"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
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
<script src="js/jquery-2.0.0.min.js" ></script>

<script type="text/javascript" src="echarts/echarts.min.js"></script>
<title>LncCE</title>
</head>
<style>
.bardom{
width: 1100px;
height:800px;
margin-top:40px;
}
.piedom{
width: 400px;
height:400px;
}
.nav-pills .nav-link.active, .nav-pills .show>.nav-link{
	background-color: #7028e4;
}
.card-locat{
	margin-top:10px;
}
.border-menu5{
	border-color:#7952b3;
}
.border-menu6{
	border-color:#f60;
}
.sta_title{
	font-size: 22px;
	font-weight: bold;
}
</style>
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;

List<String> tissue1 = new ArrayList<String>();
List<String> cs1 = new ArrayList<String>();
List<String> cer1 = new ArrayList<String>();
List<String> ceh1 = new ArrayList<String>();
db.open();
sel = "select * from statis_hcl_tis";
rs=db.execute(sel);
while(rs.next()){
	tissue1.add((rs.getString("tissue").replace("_", " ")).replace("-"," "));
	cs1.add(rs.getString("CS"));
	cer1.add(rs.getString("CER"));
	ceh1.add(rs.getString("CEH"));
}

List<String> tissue2 = new ArrayList<String>();
List<String> cs2 = new ArrayList<String>();
List<String> cer2 = new ArrayList<String>();
List<String> ceh2 = new ArrayList<String>();
sel = "select * from statis_tts_tis";
rs=db.execute(sel);
while(rs.next()){
	tissue2.add((rs.getString("tissue").replace("_"," ")).replace("-"," "));
	cs2.add(rs.getString("CS"));
	cer2.add(rs.getString("CER"));
	ceh2.add(rs.getString("CEH"));
}

List<String> tissue3 = new ArrayList<String>();
List<String> cs3 = new ArrayList<String>();
List<String> cer3 = new ArrayList<String>();
List<String> ceh3 = new ArrayList<String>();
sel = "select * from statis_tica_tis";
rs=db.execute(sel);
while(rs.next()){
	tissue3.add((rs.getString("tissue").replace("_"," ")).replace("-"," "));
	cs3.add(rs.getString("CS"));
	cer3.add(rs.getString("CER"));
	ceh3.add(rs.getString("CEH"));
}

List<String> tissue4 = new ArrayList<String>();
List<String> cs4 = new ArrayList<String>();
List<String> cer4 = new ArrayList<String>();
List<String> ceh4 = new ArrayList<String>();
sel = "select * from statis_geo_tis";
rs=db.execute(sel);
while(rs.next()){
	tissue4.add((rs.getString("tissue").replace("NA_","")).replace("_"," "));
	cs4.add(rs.getString("CS"));
	cer4.add(rs.getString("CER"));
	ceh4.add(rs.getString("CEH"));
}

List<String> cs5 = new ArrayList<String>();
List<String> cer5 = new ArrayList<String>();
List<String> ceh5 = new ArrayList<String>();
sel = "select * from statis_hcl_chr";
rs=db.execute(sel);
while(rs.next()){
	cs5.add(rs.getString("CS"));
	cer5.add(rs.getString("CER"));
	ceh5.add(rs.getString("CEH"));
}

List<String> cs6 = new ArrayList<String>();
List<String> cer6 = new ArrayList<String>();
List<String> ceh6 = new ArrayList<String>();
sel = "select * from statis_tts_chr";
rs=db.execute(sel);
while(rs.next()){
	cs6.add(rs.getString("CS"));
	cer6.add(rs.getString("CER"));
	ceh6.add(rs.getString("CEH"));
}

List<String> cs7 = new ArrayList<String>();
List<String> cer7 = new ArrayList<String>();
List<String> ceh7 = new ArrayList<String>();
sel = "select * from statis_tica_chr";
rs=db.execute(sel);
while(rs.next()){
	cs7.add(rs.getString("CS"));
	cer7.add(rs.getString("CER"));
	ceh7.add(rs.getString("CEH"));
}

List<String> cs8 = new ArrayList<String>();
List<String> cer8 = new ArrayList<String>();
List<String> ceh8 = new ArrayList<String>();
sel = "select * from statis_cellres_chr";
rs=db.execute(sel);
while(rs.next()){
	cs8.add(rs.getString("CS"));
	cer8.add(rs.getString("CER"));
	ceh8.add(rs.getString("CEH"));
}

List<String> cs9 = new ArrayList<String>();
List<String> cer9 = new ArrayList<String>();
List<String> ceh9 = new ArrayList<String>();
sel = "select * from statis_ngdc_chr";
rs=db.execute(sel);
while(rs.next()){
	cs9.add(rs.getString("CS"));
	cer9.add(rs.getString("CER"));
	ceh9.add(rs.getString("CEH"));
}

List<String> cs10 = new ArrayList<String>();
List<String> cer10 = new ArrayList<String>();
List<String> ceh10 = new ArrayList<String>();
sel = "select * from statis_emtab_chr";
rs=db.execute(sel);
while(rs.next()){
	cs10.add(rs.getString("CS"));
	cer10.add(rs.getString("CER"));
	ceh10.add(rs.getString("CEH"));
}

List<String> cs11 = new ArrayList<String>();
List<String> cer11 = new ArrayList<String>();
List<String> ceh11 = new ArrayList<String>();
sel = "select * from statis_geo_chr";
rs=db.execute(sel);
while(rs.next()){
	cs11.add(rs.getString("CS"));
	cer11.add(rs.getString("CER"));
	ceh11.add(rs.getString("CEH"));
}
rs.close();
db.close();
%>
<%
String file_path = getServletContext().getRealPath("/data");
String file_path2 = file_path.replaceAll("\\\\", "/")+"/statistic_lncrna.txt";
ReadAndProcessTextFile rapt = new ReadAndProcessTextFile();
String[] lncrna_count = rapt.readAndProcessTextFile(file_path2);
%>
<body>
<!--------------Header--------------->
<header> 
	<div id="logo"><a href="index.jsp"><img width="408px" src="./images/home/logo-white.png"/></a></div>	
</header>

<!--------------Navigation--------------->
<nav>
	<ul class="">
		<li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
		<li class="nav-item dropdown">
		<a class="nav-link dropdown-toggle" href="#" id="dropdownMenuLink" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Search</a>
		<div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
    		<a class="dropdown-item" target="_blank" href="search.jsp?method=normal">Normal</a>
    		<a class="dropdown-item" target="_blank" href="search.jsp?method=cancer">Cancer</a>
    		<a class="dropdown-item" target="_blank" href="search.jsp?method=lncRNA">LncRNA</a>
    		<a class="dropdown-item" target="_blank" href="search.jsp?method=cell">Cell</a>
  		</div>
		</li>
		<li class="nav-item dropdown">
		<a class="nav-link dropdown-toggle" href="#" id="dropdownMenuLink2" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Browse</a>
		<div class="dropdown-menu" aria-labelledby="dropdownMenuLink2">
    		<a class="dropdown-item" target="_blank" href="browse.jsp?leftTree=Normal">Normal-Centric</a>
    		<a class="dropdown-item" target="_blank" href="browse.jsp?leftTree=Cancer">Cancer-Centric</a>
    		<a class="dropdown-item" target="_blank" href="browse.jsp?leftTree=LncRNA">LncRNA-Centric</a>   		
  		</div>
		</li>
		<li class="nav-item"><a class="nav-link" href="download.jsp">Download</a></li>
		<li class="nav-item"><a class="nav-link" href="statistic.jsp">Statistic</a></li>
		<li class="nav-item"><a class="nav-link" href="help.jsp">Help</a></li>
		<li class="nav-item"><a class="nav-link" href="contact.jsp">Contact</a></li>
		<li class="nav-item"><a class="nav-link" href="news.jsp">News</a></li>
	</ul>
</nav>

<section id="content" style="margin-top: 27px;">
	<div class="zerogrid">
		<div style="height:25px;"></div>
		<div class="container-fluid">
		<div class="heading">
			<h2><a class="font-color">Statistics of LncCE</a></h2>
			<hr>
		</div>
		<div class="content">
		<div class="container-fluid">
  		<div>
			<div class="card border-primary card-locat">
 	 		<h5 class="card-header sta_title">1. Data overview</h5>
  			<div class="card-body">
    		<div class="container">
			<img src="images/image3.png" />
  			</div> 
  			</div>
			</div>
			<div class="card border-info card-locat">
  			<h5 class="card-header sta_title">2. The definition of spatial classification of lncRNAs based on expression levels in single cells</h5>
    		<div class="card-body">
    		<div class="container">
			<img src="images/image4.png" />
  			</div> 
  			</div>
			</div>
			<div class="card border-success card-locat">
  			<h5 class="card-header sta_title">3. Numbers of CE lncRNAs in each resource</h5>
  			<div class="card-body">
  			<div class="container">
  			<div class="row">
  			<div id="all" class="col-4 piedom"></div>
    		<div id="hcl" class="col-4 piedom"></div>
    		<div id="tts" class="col-4 piedom"></div>
    		</div>
    		</div>
    		<div class="container">
    		<div class="row">
    		<div id="tica" class="col-4 piedom"></div>
  			<div id="cell_res" class="col-4 piedom"></div>
  			<div id="ngdc" class="col-4 piedom"></div>  
  			</div>
  			</div>
  			<div class="container">
  			<div class="row">
  			<div id="emtab" class="col-6 piedom"></div>
  			<div id="geo" class="col-6 piedom"></div>
  			</div>
  			</div>
  			</div>
			</div>
			<div class="card border-warning card-locat">
  			<h5 class="card-header sta_title">4. Numbers of CE lncRNAs in each tissue</h5>
  			<div class="card-body">
  			<div class="container">
  			<div id="all_adult_tissue" class="bardom"></div>
  			<div id="all_fetal_tissue" class="bardom"></div>
    		<div id="hcl_tissue" style="width:1100px;height:1002px;margin-top:40px;"></div>
    		<div id="tts_tissue" class="bardom"></div>
    		<div id="tica_tissue" class="bardom"></div>
    		<div id="all_adult_cancer" class="bardom"></div>
    		<div id="all_fetal_cancer" class="bardom"></div>
  			<div id="cellres_tissue" class="bardom"></div>
  			<div id="ngdc_tissue" style="width:400px;height:300px;margin-left:75px;"></div>
  			<div id="emtab_tissue" style="width:400px;height:300px;margin-left:75px;"></div>
  			<div id="geo_tissue" class="bardom"></div>
  			</div>
  			</div>
			</div>
			<div class="card border-menu5 card-locat">
  			<h5 class="card-header sta_title">5. CE lncRNAs distribution on chromosome</h5>
  			<div class="card-body">
  			<div id="all_chr" class="bardom"></div>
    		<div id="hcl_chr" class="bardom"></div>
    		<div id="tts_chr" class="bardom"></div>
    		<div id="tica_chr" class="bardom"></div>
  			<div id="cellres_chr" class="bardom"></div>
  			<div id="ngdc_chr" class="bardom"></div>
  			<div id="emtab_chr" class="bardom"></div>
  			<div id="geo_chr" class="bardom"></div>
  			</div>
			</div>
			<div class="card border-menu6 card-locat">
  			<h5 class="card-header sta_title">6. Cancer name abbreviations</h5>
  			<div class="card-body">
    		<table id="Table_body" align="left" style="margin-left: 137px;">
				<tr class="table_left">
					<th style="width:500px">Abbreviations</th>
					<th style="width:500px">Cancer</th>
				</tr>
				<tr class='single left'>
					<td>AEL</td>
					<td>Acute erythroid leukemia</td>
				</tr>
				<tr class="double">
					<td>ALL</td>
					<td>Acute lymphoblastic leukemia</td>
				</tr>
				<tr class='single'>
					<td>AML</td>
					<td>Acute myeloid leukemia</td>
				</tr>
				<tr class='double'>
					<td>BCC</td>
					<td>Basal cell carcinoma</td>
				</tr>
				<tr class='single'>
					<td>BLCA</td>
					<td>Bladder cancer</td>
				</tr>
				<tr class='double'>
					<td>BRCA</td>
					<td>Breast cancer</td>
				</tr>
				<tr class='single'>
					<td>CHOL</td>
					<td>Cholangiocarcinoma</td>
				</tr>
				<tr class='single'>
					<td>CLL</td>
					<td>Chronic lymphocytic leukemia</td>
				</tr>
				<tr class='double'>
					<td>COAD</td>
					<td>Colon adenocarcinoma</td>
				</tr>
				<tr class='single'>
					<td>CRC</td>
					<td>Colorectal cancer</td>
				</tr>
				<tr class='single'>
					<td>GBM</td>
					<td>Glioblastoma</td>
				</tr>
				<tr class='double'>
					<td>HNSCC</td>
					<td>Head and neck squamous cell carcinoma</td>
				</tr>				
				<tr class='single'>
					<td>KIRC</td>
					<td>Kidney renal clear cell carcinoma</td>
				</tr>
				<tr class='double'>
					<td>LICA</td>
					<td>Liver cancer</td>
				</tr>
				<tr class='single'>
					<td>LIHC</td>
					<td>Liver hepatocellular carcinoma</td>
				</tr>
				<tr class="double">
					<td>LUAD and LUSC</td>
					<td>Lung adenocarcinoma and lung squamous cell carcinoma</td>
				</tr>
				<tr class="single">
					<td>Melanoma</td>
					<td>Melanoma</td>
				</tr>
				<tr class='double'>
					<td>MCC</td>
					<td>Merkel cell carcinoma</td>
				</tr>				
				<tr class='single'>
					<td>MM</td>
					<td>Multiple myeloma</td>
				</tr>				
				<tr class='double'>
					<td>NET</td>
					<td>Neuroendocrine tumor</td>
				</tr>
				<tr class='single'>
					<td>NHL</td>
					<td>Non Hodgkins lymphoma</td>
				</tr>
				<tr class='double'>
					<td>NSCLC</td>
					<td>Non small cell lung cancer</td>
				</tr>				
				<tr class='single'>
					<td>OV</td>
					<td>Ovarian cancer</td>
				</tr>				
				<tr class="double">
					<td>PAAD</td>
					<td>Pancreatic ductal adenocarcinomas</td>
				</tr>								
				<tr class="single">
					<td>SKCM</td>
					<td>Skin cutaneous melanoma</td>
				</tr>
				<tr class="double">
					<td>SCC</td>
					<td>Squamous cell carcinoma</td>
				</tr>
				<tr class="single">
					<td>UVM</td>
					<td>Uveal melanoma</td>
				</tr>
			</table>
  			</div>
			</div>
  		</div>
  		</div> 
		</div>
		</div>
	</div>
</section>
<script>
var chartDom = document.getElementById('all');
var myChart = echarts.init(chartDom);
var option;
option = {
		  title: {
		    text: 'All',
		    left: 'center'
		  },
		  tooltip: {
		        headerFormat: '{series.name}<br>',
		        pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
		    },
		  legend: {
		    orient: 'vertical',
		    left: 'left'
		  },
		  series: [
		    {
		      name: 'Numbers of lncRNAs',
		      type: 'pie',
		      radius: '50%',
		      data: [
		        { value: 15386, name: 'CS' },
		        { value: 10238, name: 'CER' },
		        { value: 62322, name: 'CEH' }
		      ],
		      emphasis: {
		        itemStyle: {
		          shadowBlur: 10,
		          shadowOffsetX: 0,
		          shadowColor: 'rgba(0, 0, 0, 0.5)'
		        }
		      }
		    }
		  ]
		};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('hcl');
var myChart = echarts.init(chartDom);
var option;
option = {
		  title: {
		    text: 'Human Cell Landscape',
		    left: 'center'
		  },
		  tooltip: {
		        headerFormat: '{series.name}<br>',
		        pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
		    },
		  legend: {
		    orient: 'vertical',
		    left: 'left'
		  },
		  series: [
		    {
		      name: 'Numbers of lncRNAs',
		      type: 'pie',
		      radius: '50%',
		      data: [
		        { value: 345, name: 'CS' },
		        { value: 957, name: 'CER' },
		        { value: 8028, name: 'CEH' }
		      ],
		      emphasis: {
		        itemStyle: {
		          shadowBlur: 10,
		          shadowOffsetX: 0,
		          shadowColor: 'rgba(0, 0, 0, 0.5)'
		        }
		      }
		    }
		  ]
		};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('tts');
var myChart = echarts.init(chartDom);
var option;
option = {
		  title: {
		    text: 'The Tabula Sapiens',
		    left: 'center'
		  },
		  tooltip: {
		        headerFormat: '{series.name}<br>',
		        pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
		    },
		  legend: {
		    orient: 'vertical',
		    left: 'left'
		  },
		  series: [
		    {
		      name: 'Numbers of lncRNAs',
		      type: 'pie',
		      radius: '50%',
		      data: [
		        { value: 2993, name: 'CS' },
		        { value: 2356, name: 'CER' },
		        { value: 27304, name: 'CEH' }
		      ],
		      emphasis: {
		        itemStyle: {
		          shadowBlur: 10,
		          shadowOffsetX: 0,
		          shadowColor: 'rgba(0, 0, 0, 0.5)'
		        }
		      }
		    }
		  ]
		};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('tica');
var myChart = echarts.init(chartDom);
var option;
option = {
		  title: {
		    text: 'TICA',
		    left: 'center'
		  },
		  tooltip: {
		        headerFormat: '{series.name}<br>',
		        pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
		    },
		  legend: {
		    orient: 'vertical',
		    left: 'left'
		  },
		  series: [
		    {
		      name: 'Numbers of lncRNAs',
		      type: 'pie',
		      radius: '50%',
		      data: [
		        { value: 823, name: 'CS' },
		        { value: 423, name: 'CER' },
		        { value: 3823, name: 'CEH' }
		      ],
		      emphasis: {
		        itemStyle: {
		          shadowBlur: 10,
		          shadowOffsetX: 0,
		          shadowColor: 'rgba(0, 0, 0, 0.5)'
		        }
		      }
		    }
		  ]
		};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('cell_res');
var myChart = echarts.init(chartDom);
var option;
option = {
		  title: {
		    text: 'Qian et al., Cell Research 2020',
		    left: 'center'
		  },
		  tooltip: {
		        headerFormat: '{series.name}<br>',
		        pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
		    },
		  legend: {
		    orient: 'vertical',
		    left: 'left'
		  },
		  series: [
		    {
		      name: 'Numbers of lncRNAs',
		      type: 'pie',
		      radius: '50%',
		      data: [
		        { value: 1296, name: 'CS' },
		        { value: 830, name: 'CER' },
		        { value: 3186, name: 'CEH' }
		      ],
		      emphasis: {
		        itemStyle: {
		          shadowBlur: 10,
		          shadowOffsetX: 0,
		          shadowColor: 'rgba(0, 0, 0, 0.5)'
		        }
		      }
		    }
		  ]
		};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('ngdc');
var myChart = echarts.init(chartDom);
var option;
option = {
		  title: {
		    text: 'NGDC',
		    left: 'center'
		  },
		  tooltip: {
		        headerFormat: '{series.name}<br>',
		        pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
		    },
		  legend: {
		    orient: 'vertical',
		    left: 'left'
		  },
		  series: [
		    {
		      name: 'Numbers of lncRNAs',
		      type: 'pie',
		      radius: '50%',
		      data: [
		        { value: 76, name: 'CS' },
		        { value: 129, name: 'CER' },
		        { value: 559, name: 'CEH' }
		      ],
		      emphasis: {
		        itemStyle: {
		          shadowBlur: 10,
		          shadowOffsetX: 0,
		          shadowColor: 'rgba(0, 0, 0, 0.5)'
		        }
		      }
		    }
		  ]
		};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('emtab');
var myChart = echarts.init(chartDom);
var option;
option = {
		  title: {
		    text: 'EMTAB',
		    left: 'center'
		  },
		  tooltip: {
		        headerFormat: '{series.name}<br>',
		        pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
		    },
		  legend: {
		    orient: 'vertical',
		    left: 'left'
		  },
		  series: [
		    {
		      name: 'Numbers of lncRNAs',
		      type: 'pie',
		      radius: '50%',
		      data: [
		        { value: 59, name: 'CS' },
		        { value: 107, name: 'CER' },
		        { value: 403, name: 'CEH' }
		      ],
		      emphasis: {
		        itemStyle: {
		          shadowBlur: 10,
		          shadowOffsetX: 0,
		          shadowColor: 'rgba(0, 0, 0, 0.5)'
		        }
		      }
		    }
		  ]
		};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('geo');
var myChart = echarts.init(chartDom);
var option;
option = {
		  title: {
		    text: 'GEO',
		    left: 'center'
		  },
		  tooltip: {
		        headerFormat: '{series.name}<br>',
		        pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
		    },
		  legend: {
		    orient: 'vertical',
		    left: 'left'
		  },
		  series: [
		    {
		      name: 'Numbers of lncRNAs',
		      type: 'pie',
		      radius: '50%',
		      data: [
		        { value: 9794, name: 'CS' },
		        { value: 5436, name: 'CER' },
		        { value: 19019, name: 'CEH' }
		      ],
		      emphasis: {
		        itemStyle: {
		          shadowBlur: 10,
		          shadowOffsetX: 0,
		          shadowColor: 'rgba(0, 0, 0, 0.5)'
		        }
		      }
		    }
		  ]
		};
myChart.setOption(option);
</script>

<script>
var chartDom = document.getElementById('all_adult_tissue');
var myChart = echarts.init(chartDom);
var option;
option = {
  title: {
	text: 'All-Normal-Adult-tissue'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    axisLabel: {
        interval: 0,  // 强制显示所有标签
        //rotate: 45    // 旋转角度
    },
    data:['Adipose','Adrenal Gland','Artery','Ascending Colon','Bladder','Blood','Bone Marrow','Brain','Breast','Caecum','Cerebellum','Cervix','Colon','Duodenum','Epityphlon','Esophagus','Eye','Fallopian Tube','Gall Bladder','Heart','Ileum','Jejunum','Kidney','Large Intestine','Liver',
    	 'Lung','Lymph Node','Muscle','Omentum','Pancreas','Pleura','Prostate','Rectum','Salivary Gland','Skin','Small Intestine','Spleen','Stomach','Temporal Lobe','Thymus','Thyroid','Tongue','Trachea','Transverse Colon','Ureter','Uterus','Vasculature']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[114,2,5,6,157,110,86,8,89,25,8,4,6,50,7,1366,4,1,86,26,301,145,17,87,112,133,84,26,119,22,23,2,18,57,43,177,5,1,84,111,84,63,19,1,83,143]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[157,18,15,1,142,114,157,53,68,11,31,8,5,5,6,16,276,86,6,77,15,78,136,70,194,183,136,65,10,178,16,82,3,73,35,90,272,23,6,103,26,53,188,16,3,50,73]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[1416,151,128,21,1232,1789,1888,435,635,61,252,61,25,80,30,202,3098,178,148,461,145,571,691,711,1055,2546,1843,1573,293,1579,220,1422,47,1500,812,852,1772,264,80,1634,449,951,1201,292,28,806,1019]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('all_fetal_tissue');
var myChart = echarts.init(chartDom);
var option;
option = {
  title: {
	text: 'All-Normal-Fetal-tissue'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    axisLabel: {
        interval: 0,  // 强制显示所有标签
        //rotate: 45    // 旋转角度
    },
    data:['Adrenal Gland','Brain','Calvaria','Eye','Gonad','Heart','Intestine','Kidney','Liver','Lung','Mid Brain','Pancreas','Rib','Skin','Spinal Cord','Stomach','Thymus']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[2,7,1,0,20,0,1,0,6,1,0,1,1,0,0,0,1]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[21,45,6,0,129,1,6,36,3,7,816,4,7,11,6,1]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[286,167,42,24,810,44,145,227,124,96,23,297,39,51,38,68,27]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('hcl_tissue');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'Human Cell Landscape'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<tissue1.size()-1;i++){
    	out.println("'"+tissue1.get(i)+"',");
    }
    out.println("'"+tissue1.get(tissue1.size()-1)+"'");
    out.println("]");
    %>
    //data: ['testis','brain','pituitary','spleen','blood','kidney','liver','prostate','thyroid','small.intestine','skin','nerve','muscle','ovary','lung','salivary.gland','adrenal.gland','heart','bladder','fallopian.tube','pancreas','vagina','breast','colon','blood.vessel','uterus','cervix','stomach','adipose.tissue','esophagus']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<cs1.size()-1;i++){
            	out.println(cs1.get(i)+",");
            }
            out.println(cs1.get(cs1.size()-1));
            %>
            ]
      //data: [2379,59,18,10,11,26,25,17,9,3,8,6,4,0,8,5,2,9,3,0,2,0,0,1,4,0,1,2,0,0]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<cer1.size()-1;i++){
            	out.println(cer1.get(i)+",");
            }
            out.println(cer1.get(cer1.size()-1));
            %>
      ]
      //data: [844,30,28,9,13,23,30,19,15,2,12,10,19,2,8,5,10,12,4,4,12,0,5,2,9,2,0,2,0,0]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<ceh1.size()-1;i++){
            	out.println(ceh1.get(i)+",");
            }
            out.println(ceh1.get(ceh1.size()-1));
            %>
           ]
      //data:[1790,436,427,333,246,217,211,176,174,183,148,132,112,129,114,118,105,94,103,105,89,98,84,83,71,72,71,57,58,58]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom_tts = document.getElementById('tts_tissue');
var myCharttts = echarts.init(chartDom_tts);
var optiontts;

optiontts = {
  title: {
	text: 'The Tabula Sapiens'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data:[
    <%
    for(int i=0;i<tissue2.size()-1;i++){
    	out.println("'"+tissue2.get(i)+"',");
    }
    out.println("'"+tissue2.get(tissue2.size()-1)+"'");
    %>
    ]
    //data: ['testis','brain','pituitary','spleen','blood','kidney','liver','prostate','thyroid','small.intestine','skin','nerve','muscle','ovary','lung','salivary.gland','adrenal.gland','heart','bladder','fallopian.tube','pancreas','vagina','breast','colon','blood.vessel','uterus','cervix','stomach','adipose.tissue','esophagus']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<cs2.size()-1;i++){
            	out.println(cs2.get(i)+",");
            }
            out.println(cs2.get(cs2.size()-1));
            %>
            ]
      //data: [2379,59,18,10,11,26,25,17,9,3,8,6,4,0,8,5,2,9,3,0,2,0,0,1,4,0,1,2,0,0]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<cer2.size()-1;i++){
            	out.println(cer2.get(i)+",");
            }
            out.println(cer2.get(cer2.size()-1));
            %>
      ]
      //data: [844,30,28,9,13,23,30,19,15,2,12,10,19,2,8,5,10,12,4,4,12,0,5,2,9,2,0,2,0,0]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<ceh2.size()-1;i++){
            	out.println(ceh2.get(i)+",");
            }
            out.println(ceh2.get(ceh2.size()-1));
            %>
           ]
      //data:[1790,436,427,333,246,217,211,176,174,183,148,132,112,129,114,118,105,94,103,105,89,98,84,83,71,72,71,57,58,58]
    }
  ]
};
myCharttts.setOption(optiontts);
</script>
<script>
var chartDomtica = document.getElementById('tica_tissue');
var myCharttica = echarts.init(chartDomtica);
var optiontica;

optiontica = {
  title: {
	text: 'TICA'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data:[
    <%
    for(int i=0;i<tissue3.size()-1;i++){
    	out.println("'"+tissue3.get(i)+"',");
    }
    out.println("'"+tissue3.get(tissue3.size()-1)+"'");
    %>
    ]
    //data: ['testis','brain','pituitary','spleen','blood','kidney','liver','prostate','thyroid','small.intestine','skin','nerve','muscle','ovary','lung','salivary.gland','adrenal.gland','heart','bladder','fallopian.tube','pancreas','vagina','breast','colon','blood.vessel','uterus','cervix','stomach','adipose.tissue','esophagus']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<cs3.size()-1;i++){
            	out.println(cs3.get(i)+",");
            }
            out.println(cs3.get(cs3.size()-1));
            %>
            ]
      //data: [2379,59,18,10,11,26,25,17,9,3,8,6,4,0,8,5,2,9,3,0,2,0,0,1,4,0,1,2,0,0]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<cer3.size()-1;i++){
            	out.println(cer3.get(i)+",");
            }
            out.println(cer3.get(cer3.size()-1));
            %>
      ]
      //data: [844,30,28,9,13,23,30,19,15,2,12,10,19,2,8,5,10,12,4,4,12,0,5,2,9,2,0,2,0,0]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<ceh3.size()-1;i++){
            	out.println(ceh3.get(i)+",");
            }
            out.println(ceh3.get(ceh3.size()-1));
            %>
           ]
      //data:[1790,436,427,333,246,217,211,176,174,183,148,132,112,129,114,118,105,94,103,105,89,98,84,83,71,72,71,57,58,58]
    }
  ]
};
myCharttica.setOption(optiontica);
</script>

<script>
var chartDom = document.getElementById('all_adult_cancer');
var myChart = echarts.init(chartDom);
var option;
option = {
  title: {
	text: 'All-Cancer-Adult-tissue'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    axisLabel: {
        interval: 0,  // 强制显示所有标签
        //rotate: 45    // 旋转角度
    },
    data:['AEL','ALL','AML','BCC','BLCA','BRCA','CHOL','CLL','COAD','CRC','GBM','GLI','HNSCC','KIRC','LICA','LIHC','LUAD_and_LUSC','MCC','MEL','MM','NET',
    	  'NHL','NSCLC','OV','PAAD','SCC','SKCM','UVM']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[9,114,279,4,739,4,119,281,1356,21,3026,80,65,85,300,238,9,155,32,20,197,466,76,10,58,90]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[23,141,14,172,30,351,36,72,171,507,9,1032,60,62,118,209,279,109,51,33,61,44,430,214,129,28,97,51]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[55,500,106,1124,270,1333,83,252,896,1899,104,1717,192,526,450,1184,858,885,204,34,80,162,1943,840,560,147,351,276]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('all_fetal_cancer');
var myChart = echarts.init(chartDom);
var option;
option = {
  title: {
	text: 'All-Cancer-Pediatric-tissue'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    axisLabel: {
        interval: 0,  // 强制显示所有标签
        //rotate: 45    // 旋转角度
    },
    data:['EPN','Pediatric-HGG','Pediatric-NBM','Pediatric-RBM','Pediatric-SARC']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[188,4,312,1168,19]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[119,116,279,68,44]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[184,148,915,463,239]
    }
  ]
};
myChart.setOption(option);
</script>

<script>
var chartDom = document.getElementById('cellres_tissue');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'Qian et al., Cell Research 2020'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data:['BRCA','COAD','LUAD and LUSC','OV']
    //data: ['testis','brain','pituitary','spleen','blood','kidney','liver','prostate','thyroid','small.intestine','skin','nerve','muscle','ovary','lung','salivary.gland','adrenal.gland','heart','bladder','fallopian.tube','pancreas','vagina','breast','colon','blood.vessel','uterus','cervix','stomach','adipose.tissue','esophagus']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[383,281,300,332]
      //data: [2379,59,18,10,11,26,25,17,9,3,8,6,4,0,8,5,2,9,3,0,2,0,0,1,4,0,1,2,0,0]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[248,164,279,139]
      //data: [844,30,28,9,13,23,30,19,15,2,12,10,19,2,8,5,10,12,4,4,12,0,5,2,9,2,0,2,0,0]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[799,860,858,669]
      //data:[1790,436,427,333,246,217,211,176,174,183,148,132,112,129,114,118,105,94,103,105,89,98,84,83,71,72,71,57,58,58]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('ngdc_tissue');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'NGDC'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '12%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data:['PAAD']
    //data: ['testis','brain','pituitary','spleen','blood','kidney','liver','prostate','thyroid','small.intestine','skin','nerve','muscle','ovary','lung','salivary.gland','adrenal.gland','heart','bladder','fallopian.tube','pancreas','vagina','breast','colon','blood.vessel','uterus','cervix','stomach','adipose.tissue','esophagus']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[76]
      //data: [2379,59,18,10,11,26,25,17,9,3,8,6,4,0,8,5,2,9,3,0,2,0,0,1,4,0,1,2,0,0]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[129]
      //data: [844,30,28,9,13,23,30,19,15,2,12,10,19,2,8,5,10,12,4,4,12,0,5,2,9,2,0,2,0,0]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[559]
      //data:[1790,436,427,333,246,217,211,176,174,183,148,132,112,129,114,118,105,94,103,105,89,98,84,83,71,72,71,57,58,58]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('emtab_tissue');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'EMTAB'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '12%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data:['NSCLC']
    //data: ['testis','brain','pituitary','spleen','blood','kidney','liver','prostate','thyroid','small.intestine','skin','nerve','muscle','ovary','lung','salivary.gland','adrenal.gland','heart','bladder','fallopian.tube','pancreas','vagina','breast','colon','blood.vessel','uterus','cervix','stomach','adipose.tissue','esophagus']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[59]
      //data: [2379,59,18,10,11,26,25,17,9,3,8,6,4,0,8,5,2,9,3,0,2,0,0,1,4,0,1,2,0,0]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[107]
      //data: [844,30,28,9,13,23,30,19,15,2,12,10,19,2,8,5,10,12,4,4,12,0,5,2,9,2,0,2,0,0]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[403]
      //data:[1790,436,427,333,246,217,211,176,174,183,148,132,112,129,114,118,105,94,103,105,89,98,84,83,71,72,71,57,58,58]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('geo_tissue');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'GEO'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<tissue4.size()-1;i++){
    	out.println("'"+tissue4.get(i)+"',");
    }
    out.println("'"+tissue4.get(tissue4.size()-1)+"'");
    out.println("]");
    %>
    //data: ['testis','brain','pituitary','spleen','blood','kidney','liver','prostate','thyroid','small.intestine','skin','nerve','muscle','ovary','lung','salivary.gland','adrenal.gland','heart','bladder','fallopian.tube','pancreas','vagina','breast','colon','blood.vessel','uterus','cervix','stomach','adipose.tissue','esophagus']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<cs4.size()-1;i++){
            	out.println(cs4.get(i)+",");
            }
            out.println(cs4.get(cs4.size()-1));
            %>
            ]
      //data: [2379,59,18,10,11,26,25,17,9,3,8,6,4,0,8,5,2,9,3,0,2,0,0,1,4,0,1,2,0,0]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<cer4.size()-1;i++){
            	out.println(cer4.get(i)+",");
            }
            out.println(cer4.get(cer4.size()-1));
            %>
      ]
      //data: [844,30,28,9,13,23,30,19,15,2,12,10,19,2,8,5,10,12,4,4,12,0,5,2,9,2,0,2,0,0]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data:[
            <%
            for(int i=0;i<ceh4.size()-1;i++){
            	out.println(ceh4.get(i)+",");
            }
            out.println(ceh4.get(ceh4.size()-1));
            %>
           ]
      //data:[1790,436,427,333,246,217,211,176,174,183,148,132,112,129,114,118,105,94,103,105,89,98,84,83,71,72,71,57,58,58]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('all_chr');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'All-Resource'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data: ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10',
           'chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20',
           'chr21','chr22','chrX','chrY']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [1163,1271,879,680,797,771,742,744,580,680,607,749,503,664,532,711,710,470,578,414,370,361,361,49]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [781,841,574,467,566,471,514,417,453,455,337,512,272,518,441,442,485,285,445,253,274,236,176,23]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [5271,5184,4139,2463,3117,3155,2875,2646,2455,2807,2426,3416,1941,2411,2204,2553,3086,1301,2345,1559,1646,1443,1633,246]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('hcl_chr');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'Human Cell Landscape'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data: ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10',
           'chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20',
           'chr21','chr22','chrX','chrY']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
           <%
           for(int i=0;i<cs5.size()-1;i++){
        	   out.println(cs5.get(i)+",");
           }
           out.println(cs5.get(cs5.size()-1));
           %>  
             ]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
		<%
		for(int i=0;i<cer5.size()-1;i++){
	   		out.println(cer5.get(i)+",");
		}
		out.println(cer5.get(cer5.size()-1));
		%> 
            ]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
	<%
		for(int i=0;i<ceh5.size()-1;i++){
			out.println(ceh5.get(i)+",");
		}
		out.println(ceh5.get(ceh5.size()-1));
	%> 
             ]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('tts_chr');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'The Tabula Sapiens'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data: ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10',
           'chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20',
           'chr21','chr22','chrX','chrY']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
           <%
           for(int i=0;i<cs6.size()-1;i++){
        	   out.println(cs6.get(i)+",");
           }
           out.println(cs6.get(cs6.size()-1));
           %>  
             ]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
		<%
		for(int i=0;i<cer6.size()-1;i++){
	   		out.println(cer6.get(i)+",");
		}
		out.println(cer6.get(cer6.size()-1));
		%> 
            ]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
	<%
		for(int i=0;i<ceh6.size()-1;i++){
			out.println(ceh6.get(i)+",");
		}
		out.println(ceh6.get(ceh6.size()-1));
	%> 
             ]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('tica_chr');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'TICA'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data: ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10',
           'chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20',
           'chr21','chr22','chrX','chrY']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
           <%
           for(int i=0;i<cs7.size()-1;i++){
        	   out.println(cs7.get(i)+",");
           }
           out.println(cs7.get(cs7.size()-1));
           %>  
             ]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
		<%
		for(int i=0;i<cer7.size()-1;i++){
	   		out.println(cer7.get(i)+",");
		}
		out.println(cer7.get(cer7.size()-1));
		%> 
            ]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
	<%
		for(int i=0;i<ceh7.size()-1;i++){
			out.println(ceh7.get(i)+",");
		}
		out.println(ceh7.get(ceh7.size()-1));
	%> 
             ]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('cellres_chr');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'Qian et al., Cell Research 2020'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data: ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10',
           'chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20',
           'chr21','chr22','chrX','chrY']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
           <%
           for(int i=0;i<cs8.size()-1;i++){
        	   out.println(cs8.get(i)+",");
           }
           out.println(cs8.get(cs8.size()-1));
           %>  
             ]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
		<%
		for(int i=0;i<cer8.size()-1;i++){
	   		out.println(cer8.get(i)+",");
		}
		out.println(cer8.get(cer8.size()-1));
		%> 
            ]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
	<%
		for(int i=0;i<ceh8.size()-1;i++){
			out.println(ceh8.get(i)+",");
		}
		out.println(ceh8.get(ceh8.size()-1));
	%> 
             ]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('ngdc_chr');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'NGDC'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data: ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10',
           'chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20',
           'chr21','chr22','chrX','chrY']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
           <%
           for(int i=0;i<cs9.size()-1;i++){
        	   out.println(cs9.get(i)+",");
           }
           out.println(cs9.get(cs9.size()-1));
           %>  
             ]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
		<%
		for(int i=0;i<cer9.size()-1;i++){
	   		out.println(cer9.get(i)+",");
		}
		out.println(cer9.get(cer9.size()-1));
		%> 
            ]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
	<%
		for(int i=0;i<ceh9.size()-1;i++){
			out.println(ceh9.get(i)+",");
		}
		out.println(ceh9.get(ceh9.size()-1));
	%> 
             ]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('emtab_chr');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'EMTAB'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data: ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10',
           'chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20',
           'chr21','chr22','chrX','chrY']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
           <%
           for(int i=0;i<cs10.size()-1;i++){
        	   out.println(cs10.get(i)+",");
           }
           out.println(cs10.get(cs10.size()-1));
           %>  
             ]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
		<%
		for(int i=0;i<cer10.size()-1;i++){
	   		out.println(cer10.get(i)+",");
		}
		out.println(cer10.get(cer10.size()-1));
		%> 
            ]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
	<%
		for(int i=0;i<ceh10.size()-1;i++){
			out.println(ceh10.get(i)+",");
		}
		out.println(ceh10.get(ceh10.size()-1));
	%> 
             ]
    }
  ]
};
myChart.setOption(option);
</script>
<script>
var chartDom = document.getElementById('geo_chr');
var myChart = echarts.init(chartDom);
var option;

option = {
  title: {
	text: 'GEO'
  },	
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      // Use axis to trigger tooltip
      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
    }
  },
  legend: {},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value',
    name: 'Numbers of lncRNAs',
    nameLocation:'middle',
    nameTextStyle: {
      fontSize: 18,
      //align: "center",
      //lineHeight: 56		      
    },
    boundaryGap: [0, 0.01],
    nameGap: 27
  },
  yAxis: {
    type: 'category',
    data: ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10',
           'chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20',
           'chr21','chr22','chrX','chrY']
  },
  series: [
    {
      name: 'CS',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
           <%
           for(int i=0;i<cs11.size()-1;i++){
        	   out.println(cs11.get(i)+",");
           }
           out.println(cs11.get(cs11.size()-1));
           %>  
             ]
    },
    {
      name: 'CER',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
		<%
		for(int i=0;i<cer11.size()-1;i++){
	   		out.println(cer11.get(i)+",");
		}
		out.println(cer11.get(cer11.size()-1));
		%> 
            ]
    },
    {
      name: 'CEH',
      type: 'bar',
      stack: 'total',
      /*label: {
        show: true
      },*/
      emphasis: {
        focus: 'series'
      },
      data: [
	<%
		for(int i=0;i<ceh11.size()-1;i++){
			out.println(ceh9.get(i)+",");
		}
		out.println(ceh11.get(ceh11.size()-1));
	%> 
             ]
    }
  ]
};
myChart.setOption(option);
</script>
<!--------------Footer--------------->
<footer>		
	<div id="copyright">
	<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University</p>
	
</div>
</footer>
</body>
</html>