<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="util.*" import="action.ChartsData"%>
<%@ page import="java.util.HashMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
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
<script src="js/jquery-2.0.0.min.js" ></script>

<script type="text/javascript" src="echarts/echarts.min.js"></script>
<title>LncCE</title>
</head>
<style>
.BT{
	background-color: #fff;
	text-align: center;
}
</style>
<body>

<div style="background-color: #fff;">
<div class="BT"><h3>Distribution of cancers CE lncRNAs</h3></div>
<div class="card border-primary">
  <h5 class="card-header">Qian et al., Cell Research 2020</h5>
  <div class="card-body">
    <h5 class="card-title">Adult tissues</h5>
    <div class="row">    
    	<div id="bar_cellres" style="width: 1200px;height:500px;"></div>
    </div>
    <div class="row">    
    	<div id="pie_cellres" style="width: 1200px;height:500px;"></div>
    </div>
  </div>
</div>
<div class="card border-info">
  <h5 class="card-header">NGDC</h5>
  <div class="card-body">
    <h5 class="card-title">Adult tissues</h5>
    <div class="row">    
    	<div id="bar_ngdc" style="width: 800px;height:300px;"></div>
    </div>
    <div class="row">    
    	<div id="pie_ngdc" style="width: 1200px;height:300px;"></div>
    </div>
  </div>
</div>
<div class="card border-success">
  <h5 class="card-header">EMTAB</h5>
  <div class="card-body">
    <h5 class="card-title">Adult tissues</h5>
    <div class="row">    
    	<div id="bar_emtab" style="width: 800px;height:300px;"></div>
    </div>
    <div class="row">    
    	<div id="pie_emtab" style="width: 1200px;height:300px;"></div>
    </div>
  </div>
</div>
<div class="card border-warning">
  <h5 class="card-header">GEO</h5>
  <div class="card-body">
    <h5 class="card-title">Adult tissues</h5>
    <div class="row">        
    	<div id="bar_geo" style="width: 800px;height:860px;"></div>
    </div>
    <div class="row">        
    	<div id="pie_geo" style="width: 800px;height:650px;"></div>
    </div>
	<h5 class="card-title">Pediatric tissues</h5>
    <div class="row">    
    	<div id="bar_pedia" style="width: 800px;height:860px;"></div>
    </div>
    <div class="row">    
    	<div id="pie_pedia" style="width: 800px;height:650px;"></div>
    </div>
  </div>
</div>
</div>
<%
HashMap<String,String> cancer_fullname = new HashMap<String,String>();
cancer_fullname.put("AEL","Acute erythroid leukemia");
cancer_fullname.put("ALL","Acute lymphoblastic leukemia");
cancer_fullname.put("AML","Acute myeloid leukemia");
cancer_fullname.put("BCC", "Basal cell carcinoma");
cancer_fullname.put("BLCA","Bladder cancer");
cancer_fullname.put("BRCA","Breast cancer");
cancer_fullname.put("CHOL","Cholangiocarcinoma");
cancer_fullname.put("Chronic lymphocytic leukemia_NA_scRNA","Chronic lymphocytic leukemia_scRNA");
cancer_fullname.put("CLL","Chronic lymphocytic leukemia");
cancer_fullname.put("COAD","Colon adenocarcinoma");
cancer_fullname.put("CRC","Colorectal cancer");
cancer_fullname.put("Ependymoma","Ependymoma");
cancer_fullname.put("GBM","Glioblastoma");
cancer_fullname.put("Glioblastoma_NA_scRNA","Glioblastoma_scRNA");
cancer_fullname.put("Glioma","Glioma");
cancer_fullname.put("HNSCC","Head and neck squamous cell carcinoma");
cancer_fullname.put("Pediatric_high-grade glioma_NA_snRNA","Pediatric_high-grade glioma_snRNA");
cancer_fullname.put("KIRC","Kidney renal clear cell carcinoma");
cancer_fullname.put("LICA","Liver cancer");
cancer_fullname.put("LIHC","Liver hepatocellular carcinoma");
cancer_fullname.put("LUAD_and_LUSC","Lung adenocarcinoma and lung squamous cell carcinoma");
cancer_fullname.put("Melanoma","Melanoma");
cancer_fullname.put("Melanoma_NA_snRNA","Melanoma_snRNA");
cancer_fullname.put("MCC","Merkel cell carcinoma");
cancer_fullname.put("Metastatic breast cancer_brain metastatic_snRNA","Metastatic breast cancer_brain metastatic_snRNA");
cancer_fullname.put("Metastatic breast cancer_liver metastases_scRNA","Metastatic breast cancer_liver metastases_scRNA");
cancer_fullname.put("Metastatic breast cancer_liver metastases_snRNA","Metastatic breast cancer_liver metastases_snRNA");
cancer_fullname.put("Metastatic breast cancer_lymph node metastases_scRNA","Metastatic breast cancer_lymph node metastases_scRNA");
cancer_fullname.put("MM","Multiple myeloma");
cancer_fullname.put("Pediatric_Neuroblastoma_NA_snRNA","Pediatric_Neuroblastoma_snRNA");
cancer_fullname.put("NET","Neuroendocrine tumor");
cancer_fullname.put("NHL","Non Hodgkins lymphoma");
cancer_fullname.put("NSCLC","Non small cell lung cancer");
cancer_fullname.put("non-small cell lung carcinoma_NA_scRNA","non-small cell lung carcinoma_scRNA");
cancer_fullname.put("OV","Ovarian cancer");
cancer_fullname.put("Ovarian_NA_scRNA","Ovarian_cancer_scRNA");
cancer_fullname.put("Ovarian_NA_snRNA","Ovarian_cancer_snRNA");
cancer_fullname.put("PAAD","Pancreatic ductal adenocarcinomas");
cancer_fullname.put("Pediatric_Sarcoma_rhabdomyosarcoma_snRNA","Pediatric_Sarcoma_rhabdomyosarcoma_snRNA");
cancer_fullname.put("Pediatric_Sarcoma_NA_snRNA","Pediatric_Sarcoma_snRNA");
cancer_fullname.put("SKCM","Skin cutaneous melanoma");
cancer_fullname.put("SCC","Squamous cell carcinoma");
cancer_fullname.put("UVM","Uveal melanoma");
cancer_fullname.put("Chronic lymphocytic leukemia_NA_snRNA","Chronic lymphocytic leukemia_snRNA");
%>
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;
db.open();
%>
<%
//cell_res
List<String> colname0 = new ArrayList<String>();
List<String> v0 = new ArrayList<String>();
sel = "select * from cell_res_order";
rs=db.execute(sel);
while(rs.next()){
	String tissue = rs.getString("tissue");
	colname0.add(cancer_fullname.get(tissue));
	v0.add(rs.getString("cenum"));
}

sel="select * from cell_res_sunburst";
rs=db.execute(sel);
List<String> tissue = new ArrayList<String>();
List<String> cell = new ArrayList<String>();
List<String> num = new ArrayList<String>();
List<String> ce = new ArrayList<String>();
while(rs.next()){
	String tissue_yj1 = rs.getString("tissue");
	tissue.add(cancer_fullname.get(tissue_yj1));
	cell.add(rs.getString("cell"));
	num.add(rs.getString("num"));
	ce.add(rs.getString("CE"));
}

//NGDC
List<String> colname1 = new ArrayList<String>();
List<String> v1 = new ArrayList<String>();
sel = "select * from ngdc_order";
rs=db.execute(sel);
while(rs.next()){
	String tissue_yj2 = rs.getString("tissue");
	colname1.add(cancer_fullname.get(tissue_yj2));
	v1.add(rs.getString("cenum"));
}

sel="select * from ngdc_sunburst";
rs=db.execute(sel);
List<String> tissue1 = new ArrayList<String>();
List<String> cell1 = new ArrayList<String>();
List<String> num1 = new ArrayList<String>();
List<String> ce1 = new ArrayList<String>();
while(rs.next()){
	String tissue_yj3 = rs.getString("tissue");
	tissue1.add(cancer_fullname.get(tissue_yj3));
	cell1.add(rs.getString("cell"));
	num1.add(rs.getString("num"));
	ce1.add(rs.getString("CE"));
}

//EMTAB
List<String> colname2 = new ArrayList<String>();
List<String> v2 = new ArrayList<String>();
sel = "select * from emtab_order";
rs=db.execute(sel);
while(rs.next()){
	String tissue_yj4 = rs.getString("tissue");
	colname2.add(cancer_fullname.get(tissue_yj4));
	v2.add(rs.getString("cenum"));
}

sel="select * from emtab_sunburst";
rs=db.execute(sel);
List<String> tissue2 = new ArrayList<String>();
List<String> cell2 = new ArrayList<String>();
List<String> num2 = new ArrayList<String>();
List<String> ce2 = new ArrayList<String>();
while(rs.next()){
	String tissue_yj5 = rs.getString("tissue");
	tissue2.add(cancer_fullname.get(tissue_yj5));
	cell2.add(rs.getString("cell"));
	num2.add(rs.getString("num"));
	ce2.add(rs.getString("CE"));
}

//geo adult
List<String> colname3 = new ArrayList<String>();
List<String> v3 = new ArrayList<String>();
sel = "select * from geo_adult_order";
rs=db.execute(sel);
while(rs.next()){
	String tissue_yj6 = rs.getString("tissue");
	if(tissue_yj6 == null ||tissue_yj6 == ""){
		colname3.add(tissue_yj6);
	}else{
		colname3.add(cancer_fullname.get(tissue_yj6));
	}
	v3.add(rs.getString("cenum"));
}

sel="select * from geo_adult_sunburst";
rs=db.execute(sel);
List<String> tissue3 = new ArrayList<String>();
List<String> cell3 = new ArrayList<String>();
List<String> num3 = new ArrayList<String>();
List<String> ce3 = new ArrayList<String>();
while(rs.next()){
	String tissue_yj7 = rs.getString("tissue");
	if(tissue_yj7 == null){
		tissue3.add(tissue_yj7);
	}else{
		tissue3.add(cancer_fullname.get(tissue_yj7));
	}
	cell3.add(rs.getString("cell"));
	num3.add(rs.getString("num"));
	ce3.add(rs.getString("CE"));
}

//geo pedia
List<String> colname4 = new ArrayList<String>();
List<String> v4 = new ArrayList<String>();
sel = "select * from geo_fetal_order";
rs=db.execute(sel);
while(rs.next()){
	String tissue_yj8 = rs.getString("tissue").replace("_NA", "");
	colname4.add(tissue_yj8);
	v4.add(rs.getString("cenum"));
}

sel="select * from geo_fetal_sunburst";
rs=db.execute(sel);
List<String> tissue4 = new ArrayList<String>();
List<String> cell4 = new ArrayList<String>();
List<String> num4 = new ArrayList<String>();
List<String> ce4 = new ArrayList<String>();
while(rs.next()){
	String tissue_yj9 = rs.getString("tissue");
	tissue4.add(tissue_yj9);
	cell4.add(rs.getString("cell"));
	num4.add(rs.getString("num"));
	ce4.add(rs.getString("CE"));
}
rs.close();
db.close();
%>
<script>
//cell_res
var chartDom = document.getElementById('bar_cellres');
var myChart1 = echarts.init(chartDom);
var option1;

option1 = {
  /*title: {
    text: 'Three resources'
  },*/
  color:['#F7B27F'],
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {show:false},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true,
    height:'400px',
    width:'800px'
  },
  xAxis: {
    type: 'value',
    boundaryGap: [0, 0.01]
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<colname0.size()-1;i++){
    	out.println("'"+colname0.get(i)+"'"+",");
    }
    out.println("'"+colname0.get(colname0.size()-1)+"'");
    out.println("]");
    %>
  },
  series: [
    {
      //name: 'CE:',
      type: 'bar',
      <%
      out.println("data:[");
      for(int i=0;i<v0.size()-1;i++){
      	out.println(v0.get(i)+",");
      }
      out.println(v0.get(v0.size()-1));
      out.println("]");
      %>
    }
  ]
};
myChart1.setOption(option1);
</script>
<script>
var app = {};
var chartDom = document.getElementById('pie_cellres');
var myChart2 = echarts.init(chartDom);
var option2;
<%
out.println("var data2=[");
for(int i=0;i<tissue.size();i++){
	out.println("{");
	out.println("name:'"+tissue.get(i)+"',");
	out.println("children: [");
			for(int j=0;j<cell.get(i).split(",").length;j++){
				out.println("{");
				out.println("name:'"+cell.get(i).split(",")[j]+"',");
					//out.println("value:"+num.get(i).split(",")[j]+",");
						out.println("children: [");
						for(int k=0;k<ce.get(i).split(";")[j].split(",").length;k++){
							out.println("{");
							out.println("name:'"+ce.get(i).split(";")[j].split(",")[k]+"',");
							out.println("value:"+num.get(i).split(";")[j].split(",")[k]+",");
							out.println("},");
						}
						out.println("],");
						out.println("},");
			}
			out.println("]");
			out.println("},");
}
out.println("];");
%>
option2 = {
	  series: {
	    type: 'sunburst',
	    data: data2,
	    radius: [0, '100%'],
	    sort: undefined,
	    emphasis: {
	      focus: 'ancestor'
	    },
	    levels: [
	      {},
	      {
	        r0: '15%',
	        r: '35%',
	        itemStyle: {
	          borderWidth: 2
	        },
	        label: {
	          rotate: 'tangential',
	          minAngle: 0
	        }
	      },
	      {
	        r0: '35%',
	        r: '70%',
	        label: {
	          align: 'right',
	          minAngle: 8
	        }
	      },
	      {
	        r0: '70%',
	        r: '82%',
	        label: {
	          position: 'outside',
	          padding: 3,
	          silent: true,
	          minAngle: 1
	        },
	        itemStyle: {
	          borderWidth: 3
	        }
	      }
	    ]
	  }
	};
myChart2.setOption(option2);
</script>
<script>
var chartDom = document.getElementById('bar_ngdc');
var myChart3 = echarts.init(chartDom);
var option3;

option3 = {
  /*title: {
    text: 'Three resources'
  },*/
  color:['#F7B27F'],
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {show:false},
  grid: {
    left: '26%',
    right: '4%',
    bottom: '3%',
    containLabel: true,
    //height:'800px',
    //width:'700px'
  },
  xAxis: {
    type: 'value',
    boundaryGap: [0, 0.01]
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<colname1.size()-1;i++){
    	out.println("'"+colname1.get(i)+"'"+",");
    }
    out.println("'"+colname1.get(colname1.size()-1)+"'");
    out.println("]");
    %>
  },
  series: [
    {
      //name: 'CE:',
      type: 'bar',
      <%
      out.println("data:[");
      for(int i=0;i<v1.size()-1;i++){
      	out.println(v1.get(i)+",");
      }
      out.println(v1.get(v1.size()-1));
      out.println("]");
      %>
    }
  ]
};
myChart3.setOption(option3);
</script>
<script>
var app = {};
var chartDom = document.getElementById('pie_ngdc');
var myChart4 = echarts.init(chartDom);
var option4;
<%
out.println("var data4=[");
for(int i=0;i<tissue1.size();i++){
	out.println("{");
		out.println("name:'"+tissue1.get(i)+"',");
		out.println("children: [");
			for(int j=0;j<cell1.get(i).split(",").length;j++){
				out.println("{");
					out.println("name:'"+cell1.get(i).split(",")[j]+"',");
					//out.println("value:"+num.get(i).split(",")[j]+",");
						out.println("children: [");
						for(int k=0;k<ce1.get(i).split(";")[j].split(",").length;k++){
							out.println("{");
								out.println("name:'"+ce1.get(i).split(";")[j].split(",")[k]+"',");
								out.println("value:"+num1.get(i).split(";")[j].split(",")[k]+",");
							out.println("},");
						}
						out.println("],");
				out.println("},");
			}
		out.println("]");
	out.println("},");
}
out.println("];");
%>
option4 = {
	  series: {
	    type: 'sunburst',
	    data: data4,
	    radius: [0, '100%'],
	    sort: undefined,
	    emphasis: {
	      focus: 'ancestor'
	    },
	    levels: [
	      {},
	      {
	        r0: '15%',
	        r: '35%',
	        itemStyle: {
	          borderWidth: 2
	        },
	        label: {
	          rotate: 'center',
	          minAngle: 0
	        }
	      },
	      {
	        r0: '35%',
	        r: '70%',
	        label: {
	          align: 'center',
	          minAngle: 12
	        }
	      },
	      {
	        r0: '70%',
	        r: '72%',
	        label: {
	          position: 'outside',
	          padding: 3,
	          silent: true,
	          minAngle: 1
	        },
	        itemStyle: {
	          borderWidth: 3
	        }
	      }
	    ]
	  }
	};
myChart4.setOption(option4);
</script>
<script>
/*emtab*/
var chartDom = document.getElementById('bar_emtab');
var myChart5 = echarts.init(chartDom);
var option5;

option5 = {
  /*title: {
    text: 'Three resources'
  },*/
  color:['#F7B27F'],
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {show:false},
  grid: {
    left: '16%',
    right: '4%',
    bottom: '3%',
    containLabel: true,
    height:'400px',
    width:'800px'
  },
  xAxis: {
    type: 'value',
    boundaryGap: [0, 0.01]
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<colname2.size()-1;i++){
    	out.println("'"+colname2.get(i)+"'"+",");
    }
    out.println("'"+colname2.get(colname2.size()-1)+"'");
    out.println("]");
    %>
  },
  series: [
    {
      //name: 'CE:',
      type: 'bar',
      <%
      out.println("data:[");
      for(int i=0;i<v2.size()-1;i++){
      	out.println(v2.get(i)+",");
      }
      out.println(v2.get(v2.size()-1));
      out.println("]");
      %>
    }
  ]
};
myChart5.setOption(option5);
</script>
<script>
var app = {};
var chartDom = document.getElementById('pie_emtab');
var myChart6 = echarts.init(chartDom);
var option6;
<%
out.println("var data6=[");
for(int i=0;i<tissue2.size();i++){
	out.println("{");
		out.println("name:'"+tissue2.get(i)+"',");
		out.println("children: [");
			for(int j=0;j<cell2.get(i).split(",").length;j++){
				out.println("{");
					out.println("name:'"+cell2.get(i).split(",")[j]+"',");
					//out.println("value:"+num.get(i).split(",")[j]+",");
						out.println("children: [");
						for(int k=0;k<ce2.get(i).split(";")[j].split(",").length;k++){
							out.println("{");
								out.println("name:'"+ce2.get(i).split(";")[j].split(",")[k]+"',");
								out.println("value:"+num2.get(i).split(";")[j].split(",")[k]+",");
							out.println("},");
						}
						out.println("],");
				out.println("},");
			}
		out.println("]");
	out.println("},");
}
out.println("];");
%>
option6 = {
	  series: {
	    type: 'sunburst',
	    data: data6,
	    radius: [0, '100%'],
	    sort: undefined,
	    emphasis: {
	      focus: 'ancestor'
	    },
	    levels: [
	      {},
	      {
	        r0: '15%',
	        r: '35%',
	        itemStyle: {
	          borderWidth: 2
	        },
	        label: {
	          rotate: 'center',
	          minAngle: 12
	        }
	      },
	      {
	        r0: '35%',
	        r: '70%',
	        label: {
	          align: 'center',
	          minAngle: 16
	        }
	      },
	      {
	        r0: '70%',
	        r: '72%',
	        label: {
	          position: 'outside',
	          padding: 3,
	          silent: true,
	          minAngle: 1
	        },
	        itemStyle: {
	          borderWidth: 3
	        }
	      }
	    ]
	  }
	};
myChart6.setOption(option6);
</script>
<script>
/*geo adult*/
var chartDom = document.getElementById('bar_geo');
var myChart7 = echarts.init(chartDom);
var option7;

option7 = {
  /*title: {
    text: 'Three resources'
  },*/
  color:['#F7B27F'],
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {show:false},
  grid: {
    left: '16%',
    right: '4%',
    bottom: '3%',
    containLabel: true,
    height:'800px',
    width:'700px'
  },
  xAxis: {
    type: 'value',
    boundaryGap: [0, 0.01]
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<colname3.size()-1;i++){
    	out.println("'"+colname3.get(i)+"'"+",");
    }
    out.println("'"+colname3.get(colname3.size()-1)+"'");
    out.println("]");
    %>
  },
  series: [
    {
      //name: 'CE:',
      type: 'bar',
      <%
      out.println("data:[");
      for(int i=0;i<v3.size()-1;i++){
      	out.println(v3.get(i)+",");
      }
      out.println(v3.get(v3.size()-1));
      out.println("]");
      %>
    }
  ]
};
myChart7.setOption(option7);
</script>
<script>
var app = {};
var chartDom = document.getElementById('pie_geo');
var myChart8 = echarts.init(chartDom);
var option8;
<%
out.println("var data8=[");
for(int i=0;i<tissue3.size();i++){
	out.println("{");
		out.println("name:'"+tissue3.get(i)+"',");
		out.println("children: [");
			for(int j=0;j<cell3.get(i).split(",").length;j++){
				out.println("{");
					out.println("name:'"+cell3.get(i).split(",")[j]+"',");
					//out.println("value:"+num.get(i).split(",")[j]+",");
						out.println("children: [");
						for(int k=0;k<ce3.get(i).split(";")[j].split(",").length;k++){
							out.println("{");
								out.println("name:'"+ce3.get(i).split(";")[j].split(",")[k]+"',");
								out.println("value:"+num3.get(i).split(";")[j].split(",")[k]+",");
							out.println("},");
						}
						out.println("],");
				out.println("},");
			}
		out.println("]");
	out.println("},");
}
out.println("];");
%>
option8 = {
	  series: {
	    type: 'sunburst',
	    data: data8,
	    radius: [0, '100%'],
	    sort: undefined,
	    emphasis: {
	      focus: 'ancestor'
	    },
	    center: ["60%", "50%"],
	    levels: [
	      {},
	      {
	        r0: '15%',
	        r: '35%',
	        itemStyle: {
	          borderWidth: 2
	        },
	        label: {
	          rotate: 'center',
	          minAngle: 20
	        }
	      },
	      {
	        r0: '35%',
	        r: '70%',
	        label: {
	          align: 'center',
	          minAngle: 8
	        }
	      },
	      {
	        r0: '70%',
	        r: '72%',
	        label: {
	          position: 'outside',
	          padding: 3,
	          silent: true,
	          minAngle: 1
	        },
	        itemStyle: {
	          borderWidth: 3
	        }
	      }
	    ]
	  }
	};
myChart8.setOption(option8);
</script>
<script>
/*tica*/
var chartDom9 = document.getElementById('bar_pedia');
var myChart9 = echarts.init(chartDom9);
var option9;

option9 = {
  /*title: {
    text: 'Three resources'
  },*/
  color:['#F7B27F'],
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {show:false},
  grid: {
    left: '16%',
    right: '4%',
    bottom: '3%',
    containLabel: true,
    height:'800px',
    width:'700px'
  },
  xAxis: {
    type: 'value',
    boundaryGap: [0, 0.01]
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<colname4.size()-1;i++){
    	out.println("'"+colname4.get(i)+"'"+",");
    }
    out.println("'"+colname4.get(colname4.size()-1)+"'");
    out.println("]");
    %>
  },
  series: [
    {
      //name: 'CE:',
      type: 'bar',
      <%
      out.println("data:[");
      for(int i=0;i<v4.size()-1;i++){
      	out.println(v4.get(i)+",");
      }
      out.println(v4.get(v4.size()-1));
      out.println("]");
      %>
    }
  ]
};
myChart9.setOption(option9);
</script>
<script>
var app = {};
var chartDom10 = document.getElementById('pie_pedia');
var myChart10 = echarts.init(chartDom10);
var option10;
<%
out.println("var data10=[");
for(int i=0;i<tissue4.size();i++){
	out.println("{");
		out.println("name:'"+tissue4.get(i)+"',");
		out.println("children: [");
			for(int j=0;j<cell4.get(i).split(",").length;j++){
				out.println("{");
					out.println("name:'"+cell4.get(i).split(",")[j]+"',");
					//out.println("value:"+num.get(i).split(",")[j]+",");
						out.println("children: [");
						for(int k=0;k<ce4.get(i).split(";")[j].split(",").length;k++){
							out.println("{");
								out.println("name:'"+ce4.get(i).split(";")[j].split(",")[k]+"',");
								out.println("value:"+num4.get(i).split(";")[j].split(",")[k]+",");
							out.println("},");
						}
						out.println("],");
				out.println("},");
			}
		out.println("]");
	out.println("},");
}
out.println("];");
%>
option10 = {
	  series: {
	    type: 'sunburst',
	    data: data8,
	    radius: [0, '95%'],
	    sort: undefined,
	    emphasis: {
	      focus: 'ancestor'
	    },
	    center: ["60%", "50%"],
	    levels: [
	      {},
	      {
	        r0: '15%',
	        r: '35%',
	        itemStyle: {
	          borderWidth: 2
	        },
	        label: {
	          rotate: 'center',
	          minAngle: 16
	        }
	      },
	      {
	        r0: '35%',
	        r: '70%',
	        label: {
	          align: 'right',
	          minAngle: 8
	        }
	      },
	      {
	        r0: '70%',
	        r: '72%',
	        label: {
	          position: 'outside',
	          padding: 3,
	          silent: true,
	          minAngle: 1
	        },
	        itemStyle: {
	          borderWidth: 3
	        }
	      }
	    ]
	  }
	};
myChart10.setOption(option10);
</script>
</body>
</html>
