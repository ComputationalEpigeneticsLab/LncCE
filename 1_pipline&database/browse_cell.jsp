<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*" language="java"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.Random"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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

<link rel="stylesheet" type="text/css" href="ztree/css/metroStyle/metroStyle.css"/>
<script type="text/javascript" src="ztree/js/jquery.ztree.core.js"></script>
<title>LncCE</title>
</head>
<style>
.contnt{
font-size:23px;
}
.btn1{
width:100px;
height: 30px;
background-color: #3e56c1;
color:#f1b9f7;
font-size:21px;
}
</style>
<script type="text/javascript">
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel="";
db.open();
String leftTree = request.getParameter("leftTree");//leftTree用于判断生成哪棵树
%>
var zNodes = [

	<%if(leftTree.equals("Normal")){%>
	//Normal
	{name:"Adult Normal-Centric",open:true,children:[
		{name:"Circulatory System", open:false, children:[
			{name:"Artery",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Artery\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Blood",open:false,children:[
			<%
			    sel = "select * from treeleaf_normal where tissue = \"Blood\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Heart",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Heart\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Peripheral Blood",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Peripheral-Blood\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Vasculature",open:false,children:[
			<%
			    sel = "select * from treeleaf_normal where tissue = \"Vasculature\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			    }
			%>
			]}
		]},
		{name:"Digestive System", open:false, children:[
			{name:"Ascending Colon",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Ascending-Colon\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Caecum",open:false,children:[
			<%
			   sel = "select * from treeleaf_normal where tissue = \"Caecum\"";
			   rs=db.execute(sel);
			   while(rs.next()){
			   out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			   }
			%>
			]},
			{name:"Duodenum",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Duodenum\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Epityphlon",open:false,children:[
			<%
			   sel = "select * from treeleaf_normal where tissue = \"Epityphlon\"";
			   rs=db.execute(sel);
			   while(rs.next()){
			   out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			   }
			%>
			]},
			{name:"Esophagus",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Esophagus\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Gall Bladder",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Gall-Bladder\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Ileum",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Ileum\" or tissue = \"lleum\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"JeJunum",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"JeJunum\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Jejunum epithelial",open:false,children:[
			<%
			sel = "select * from treeleaf_normal where tissue = \"Jejunum_epithelial\"";
			rs=db.execute(sel);
			while(rs.next()){
			out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Jejunum lamina propria",open:false,children:[
			<%
			sel = "select * from treeleaf_normal where tissue = \"Jejunum_lamina_propria\"";
			rs=db.execute(sel);
			while(rs.next()){
			out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Large Intestine",open:false,children:[
			<%
			sel = "select * from treeleaf_normal where tissue = \"Large_Intestine\"";
			rs=db.execute(sel);
			while(rs.next()){
			out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Liver",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Liver\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Pancreas",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Pancreas\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Pancreas Baron",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Pancreas_Baron\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Pancreas Muraro",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Pancreas_Muraro\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Pancreas Segerstolpe",open:false,children:[
				<%
					sel = "select * from treeleaf_normal where tissue = \"Pancreas_Segerstolpe\"";
					rs=db.execute(sel);
					while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
				%>
			]},
			{name:"Rectum",open:false,children:[
				<%
					sel = "select * from treeleaf_normal where tissue = \"Rectum\"";
					rs=db.execute(sel);
					while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
				%>
			]},
			{name:"Salivary Gland",open:false,children:[
			<%
			      sel = "select * from treeleaf_normal where tissue = \"Salivary_Gland\"";
			      rs=db.execute(sel);
			      while(rs.next()){
			      out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			      }
			%>
			]},
			{name:"Sigmoid Colon",open:false,children:[
				<%
					sel = "select * from treeleaf_normal where tissue = \"Sigmoid-Colon\" or tissue = \"Sigmoid colon\"";
					rs=db.execute(sel);
					while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
				%>
			]},
			{name:"Small Intestine",open:false,children:[
			<%
			        sel = "select * from treeleaf_normal where tissue = \"Small_Intestine\"";
			        rs=db.execute(sel);
			        while(rs.next()){
			        out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			      }
			%>
			]},
			{name:"Stomach",open:false,children:[
				<%
					sel = "select * from treeleaf_normal where tissue = \"Stomach\"";
					rs=db.execute(sel);
					while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
				%>
			]},
			{name:"Transverse Colon",open:false,children:[
				<%
					sel = "select * from treeleaf_normal where tissue = \"Transverse-Colon\" or tissue = \"Transverse colon\"";
					rs=db.execute(sel);
					while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
				%>
			]},
		]},
		{name:"Endocrine System", open:false, children:[
			{name:"Adrenal Gland",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Adrenal-Gland\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Mammary",open:false,children:[
			<%
			    sel = "select * from treeleaf_normal where tissue = \"Mammary\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			    }
			%>
			]},
			{name:"Thymus",open:false,children:[
			<%
			    sel = "select * from treeleaf_normal where tissue = \"Thymus\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			    }
			%>
			]},
			{name:"Thyroid",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Thyroid\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]}
		]},
		{name:"Immune System", open:false, children:[
			{name:"Bone Marrow",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Bone-Marrow\" or tissue = \"Bone_Marrow\" or tissue = \"Bone marrow\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Bone Marrow CD34N",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Bone-Marrow-CD34N\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Bone Marrow CD34P",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Bone-Marrow-CD34P\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
			%>
			]},
			{name:"Lung draining lymph nodes",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Lung-draining lymph nodes\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
			%>
			]},
			{name:"Lymph Node",open:false,children:[
			<%
			    sel = "select * from treeleaf_normal where tissue = \"Lymph_Node\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			    }
		    %>
			]},
			{name:"Mesenteric lymph nodes",open:false,children:[
			<%
			   sel = "select * from treeleaf_normal where tissue = \"Mesenteric lymph nodes\"";
			   rs=db.execute(sel);
			   while(rs.next()){
			   out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			   }
			%>
			]},
			{name:"Spleen",open:false,children:[
			<%
			    sel = "select * from treeleaf_normal where tissue = \"Spleen\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			    }
			%>
			]},
		]},
		{name:"Locomotor System", open:false, children:[
			{name:"Muscle",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Muscle\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Skeletal muscle",open:false,children:[
			<%
			    sel = "select * from treeleaf_normal where tissue = \"Skeletal muscle\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
		]},
		{name:"Nervous System", open:false, children:[
			{name:"Brain Lake",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Brain_Lake\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Cerebellum",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Cerebellum\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Eye",open:false,children:[
			<%
			    sel = "select * from treeleaf_normal where tissue = \"Eye\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			    }
			%>
			]},
			{name:"Temporal Lobe",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Temporal-Lobe\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
			%>
			]}
		]},
		{name:"Reproductive System", open:false, children:[
			{name:"Cervix",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Cervix\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Fallopian Tube",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Fallopian-Tube\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
			%>
			]},
			{name:"Prostate",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Prostate\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
			%>
			]},			
			{name:"Uterus",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Uterus\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
				}
			%>
			]}
		]},
		{name:"Respiratory System", open:false, children:[
			{name:"Lung",open:false,children:[
			<%
			     sel = "select * from treeleaf_normal where tissue = \"Lung\" or tissue = \"Lungs\"";
			     rs=db.execute(sel);
			     while(rs.next()){
			     out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			     }
			%>
			]},
			{name:"Trachea",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Trachea\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]}
		]},
		{name:"Urinary System", open:false, children:[
			{name:"Bladder",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Bladder\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Kidney",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"kidney\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Ureter",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Ureter\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]}
		]},
		{name:"Other",open:false,children:[
			{name:"Adipose",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Adipose\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Fat",open:false,children:[
			<%
			     sel = "select * from treeleaf_normal where tissue = \"Fat\"";
			     rs=db.execute(sel);
			     while(rs.next()){
			     out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			     }
			%>
			]},
			{name:"Omentum",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Omentum\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Pleura",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Pleura\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Skin",open:false,children:[
			<%
				sel = "select * from treeleaf_normal where tissue = \"Skin\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
			{name:"Tongue",open:false,children:[
			<%
			     sel = "select * from treeleaf_normal where tissue = \"Tongue\"";
			     rs=db.execute(sel);
			     while(rs.next()){
			     out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=adult="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
			}
			%>
			]},
		]}
	]},
	//fetal
	{name:"Fetal Normal-Centric", open:true, children:[
		{name:"Circulatory System", open:false, children:[
			{name:"Heart",open:false,children:[
        	<%
          	sel = "select * from hcl_basic where tissue = \"Heart\" and source = \"fetal\"";
          	rs=db.execute(sel);
          	while(rs.next()){
          	out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
          	}
        	%>
        	]}
        ]},
        {name:"Digestive System", open:false, children:[
			{name:"Intestine",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Intestine\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Liver",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Liver\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Pancreas",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Pancreas\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Salivary Gland",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Salivary_Gland\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Stomach",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Stomach\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]}
        ]},
        {name:"Endocrine System", open:false, children:[
			{name:"Adrenal Gland",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Adrenal-Gland\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Female Gonad",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Female-Gonad\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Gonad Li",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Gonad_Li\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Male Gonad",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Male-Gonad\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Thymus",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Thymus\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]}
        ]},
        {name:"Locomotor System", open:false, children:[
			{name:"Rib",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Rib\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]}
        ]},
        {name:"Nervous System", open:false, children:[
            {name:"Brain",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Brain\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Brain Zhong",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Brain_Zhong\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Eyes",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Eyes\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Mid Brain LaManno",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Mid-Brain_LaManno\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Spinal Cord",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Spinal-Cord\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]}
        ]},
        {name:"Respiratory System", open:false, children:[
			{name:"Lung",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Lung\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]}                                         
        ]},
        {name:"Urinary System", open:false, children:[
            {name:"Kidney",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Kidney\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]}                                         
        ]},
        {name:"Other", open:false, children:[
            {name:"Calvaria",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Calvaria\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]},
            {name:"Skin",open:false,children:[
            <%
            sel = "select * from hcl_basic where tissue = \"Skin\" and source = \"fetal\"";
            rs=db.execute(sel);
            while(rs.next()){
            out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"=normal=fetal="+rs.getString("tissue")+"\",file:\"browse_cellre\"},");
            }
            %>
            ]}
        ]}
	]},
	<% db.close();rs.close();
	}else if(leftTree.equals("LncRNA")){
	%>
	//单个lncRNA
	{name:"LncRNA-Centric", open:true, children:[
		{name:"chr1",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr1' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr2",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr2' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr3",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr3' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr4",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr4' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr5",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr5' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr6",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr6' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr7",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr7' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr8",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr8' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr9",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr9' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr10",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr10' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr11",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr11' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr12",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr12' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr13",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr13' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}	
			%>
		]},
		{name:"chr14",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr14' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr15",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr15' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr16",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr16' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr17",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr17' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr18",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr18' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr19",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr19' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr20",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr20' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr21",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr21' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chr22",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chr22' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chrX",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chrX' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
		{name:"chrY",open:false,children:[
			<%
				sel = "select ensembl_gene_id,gene_name from integrat_basic where seqnames = 'chrY' group by gene_name order by gene_name";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("gene_name")+"\",PID:\""+rs.getString("ensembl_gene_id")+"\",url:\"search_re_lnc.jsp?sigcell_lncrna="+rs.getString("ensembl_gene_id")+"\",target:\"_blank\"},");
				}
			%>
		]},
	]}
	<%
	db.close();rs.close();
	}else if(leftTree.equals("Cancer")){
	%>
	//Cancer
	{name:"Adult Cancer-Centric",open:true,children:[
		{name:"Circulatory System", open:false, children:[
			{name:"AEL", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"AEL\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"ALL", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"ALL\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"AML", open:false, children:[
			<%
			    sel = "select * from treeleaf_cancer_adult where tissue = \"AML\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			    }
			%>
			]},
			{name:"Chronic lymphocytic leukemia scRNA", open:false, children:[
			<%
			    sel = "select * from treeleaf_cancer_adult where tissue = \"Chronic lymphocytic leukemia_NA_scRNA\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			    }
			%>
			]},
			{name:"Chronic lymphocytic leukemia snRNA", open:false, children:[
			<%
			    sel = "select * from treeleaf_cancer_adult where tissue = \"Chronic lymphocytic leukemia_NA_snRNA\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			    }
			%>
			]},
			{name:"CLL", open:false, children:[
				<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"CLL\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]}
		]},
		{name:"Digestive System", open:false, children:[
			{name:"CHOL", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"CHOL\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"COAD", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"COAD\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"CRC", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"CRC\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"LICA", open:false, children:[
			<%
			    sel = "select * from treeleaf_cancer_adult where tissue = \"LICA\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			       out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"LIHC", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"LIHC\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"PAAD", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"PAAD\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]}
		]},
		{name:"Endocrine System", open:false, children:[
		   {name:"BRCA", open:false, children:[
		   <%
		       sel = "select * from treeleaf_cancer_adult where tissue = \"BRCA\"";
		       rs=db.execute(sel);
		       while(rs.next()){
		          out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
		   }
		  %>
		  ]},
		  {name:"Metastatic breast cancer brain metastatic snRNA", open:false, children:[
		  <%
		       sel = "select * from treeleaf_cancer_adult where tissue = \"Metastatic breast cancer_brain metastatic_snRNA\"";
		       rs=db.execute(sel);
		       while(rs.next()){
		          out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
		     }
		  %>
		  ]},
		  {name:"Metastatic breast cancer liver metastases scRNA", open:false, children:[
		  <%
		      sel = "select * from treeleaf_cancer_adult where tissue = \"Metastatic breast cancer_liver metastases_scRNA\"";
		      rs=db.execute(sel);
		      while(rs.next()){
		        out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
		      }
		 %>
		  ]},
		  {name:"Metastatic breast cancer liver metastases snRNA", open:false, children:[
		  <%
		      sel = "select * from treeleaf_cancer_adult where tissue = \"Metastatic breast cancer_liver metastases_snRNA\"";
		      rs=db.execute(sel);
		      while(rs.next()){
		        out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
		      }
		  %>
		 ]},
		 {name:"Metastatic breast cancer lymph node metastases scRNA", open:false, children:[
		 <%
		     sel = "select * from treeleaf_cancer_adult where tissue = \"Metastatic breast cancer_lymph node metastases_scRNA\"";
		     rs=db.execute(sel);
		     while(rs.next()){
		        out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
		     }
		 %>
		]}
		]},
		{name:"Immune System", open:false, children:[
			{name:"MM", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"MM\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"NHL", open:false, children:[
			<%
			    sel = "select * from treeleaf_cancer_adult where tissue = \"NHL\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			        out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			   }
			%>
			]}
		]},
		{name:"Nervous System", open:false, children:[
			{name:"GBM", open:false, children:[
            <%
              sel = "select * from treeleaf_cancer_adult where tissue = \"GBM\"";
              rs=db.execute(sel);
              while(rs.next()){
                  out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
              }
            %>
            ]},
            {name:"Glioblastoma scRNA", open:false, children:[
            <%
               sel = "select * from treeleaf_cancer_adult where tissue = \"Glioblastoma_NA_scRNA\"";
               rs=db.execute(sel);
               while(rs.next()){
                   out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
               }
            %>
            ]},
			{name:"Glioma", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"Glioma\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"NET", open:false, children:[
			<%
			    sel = "select * from treeleaf_cancer_adult where tissue = \"NET\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			     out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			    }
			%>
			]}
		]},
		{name:"Reproductive System", open:false, children:[
			{name:"OV",open:false,children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"OV\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"Ovarian scRNA",open:false,children:[
			<%
			    sel = "select * from treeleaf_cancer_adult where tissue = \"Ovarian_NA_scRNA\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			    out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			    }
			%>
			]},
			{name:"Ovarian snRNA",open:false,children:[
			<%
			   sel = "select * from treeleaf_cancer_adult where tissue = \"Ovarian_NA_snRNA\"";
			   rs=db.execute(sel);
			   while(rs.next()){
			   out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			   }
			%>
			]}
		]},
		{name:"Respiratory System", open:false, children:[
			{name:"LUAD and LUSC", open:false, children:[
            <%
               sel = "select * from treeleaf_cancer_adult where tissue = \"LUAD_and_LUSC\"";
               rs=db.execute(sel);
               while(rs.next()){
                   out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
               }
            %>
            ]},
            {name:"non-small cell lung carcinoma scRNA", open:false, children:[
            <%
                sel = "select * from treeleaf_cancer_adult where tissue = \"non-small cell lung carcinoma_NA_scRNA\"";
                rs=db.execute(sel);
                while(rs.next()){
                   out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
                }
            %>
            ]},
			{name:"NSCLC", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"NSCLC\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]}
		]},
		{name:"Urinary System", open:false, children:[
			{name:"BLCA", open:false, children:[
            <%
               sel = "select * from treeleaf_cancer_adult where tissue = \"BLCA\"";
               rs=db.execute(sel);
               while(rs.next()){
                   out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
               }
            %>
           ]},
			{name:"KIRC", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"KIRC\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]}
		]},
		{name:"Other",open:false,children:[
			{name:"BCC", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"BCC\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"HNSCC", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"HNSCC\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"LUAD and LUSC", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"LUAD_and_LUSC\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"MCC", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"MCC\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"Melanoma", open:false, children:[
			<%
			    sel = "select * from treeleaf_cancer_adult where tissue = \"Melanoma\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			        out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			    }
			%>
			]},
			{name:"Melanoma snRNA", open:false, children:[
			<%
			    sel = "select * from treeleaf_cancer_adult where tissue = \"Melanoma_NA_snRNA\"";
			    rs=db.execute(sel);
			    while(rs.next()){
			        out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			    }
			%>
			]},
			{name:"SCC", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"SCC\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"SKCM", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"SKCM\"";
				rs=db.execute(sel);
				while(rs.next()){
					out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]},
			{name:"UVM", open:false, children:[
			<%
				sel = "select * from treeleaf_cancer_adult where tissue = \"UVM\"";
				rs=db.execute(sel);
				while(rs.next()){
				out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=adult="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
			}
			%>
			]}
		]}
	]},
	//Pediatric
	{name:"Pediatric Cancer-Centric",open:true,children:[
		{name:"Digestive System",open:false,children:[
			{name:"Pediatric Sarcoma snRNA", open:false, children:[
            <%
                sel = "select * from treeleaf_cancer_pedia where tissue = \"Pediatric_Sarcoma_NA_snRNA\"";
                rs=db.execute(sel);
                while(rs.next()){
                out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=fetal="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
                }
            %>
           ]},
           {name:"Pediatric Sarcoma rhabdomyosarcoma snRNA", open:false, children:[
           <%
               sel = "select * from treeleaf_cancer_pedia where tissue = \"Pediatric_Sarcoma_rhabdomyosarcoma_snRNA\"";
               rs=db.execute(sel);
               while(rs.next()){
               out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=fetal="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
               }
           %>
           ]}
		]},
		{name:"Nervous System",open:false,children:[
		   {name:"Pediatric high-grade glioma snRNA", open:false, children:[
		   <%
		      sel = "select * from treeleaf_cancer_pedia where tissue = \"Pediatric_high-grade glioma_NA_snRNA\"";
		      rs=db.execute(sel);
		      while(rs.next()){
		      out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=fetal="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
		      }
		   %>
		   ]},
		   {name:"Pediatric Neuroblastoma snRNA", open:false, children:[
		   <%
		      sel = "select * from treeleaf_cancer_pedia where tissue = \"Pediatric_Neuroblastoma_NA_snRNA\"";
		      rs=db.execute(sel);
		      while(rs.next()){
		      out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=fetal="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
		      }
		   %>
		   ]}
		 ]},
		 {name:"Other",open:false,children:[
		    {name:"Ependymoma", open:false, children:[
		    <%
		    sel = "select * from treeleaf_cancer_pedia where tissue = \"Ependymoma\"";
		    rs=db.execute(sel);
		    while(rs.next()){
		    out.println("{name:\""+rs.getString("leaf")+"\",PID:\""+rs.getString("ID")+"=cancer=fetal="+rs.getString("tissue")+"\",file:\"browse_cellreC\"},");
		    }
		    %>
		    ]}
		]}
	]}
	<%
	db.close();rs.close();
	}%>
];
var settingCell = {
		      view: {
		        dblClickExpand: true,
		        showLine: true,
		        selectedMulti: false
		      },
		      data: {
		        simpleData: {
		          enable: true,
		        }
		      },
		      callback: {
		        beforeClick: function (treeId, treeNode) {
		          //var zTree = $.fn.zTree.getZTreeObj("tree");
		          var zTree = $.fn.zTree.getZTreeObj("treeDemoCell");
		          if (treeNode.isParent) {
		            zTree.expandNode(treeNode);
		            return false;
		          } else {
		        	  <%
		        	  if(leftTree.equals("Normal")||leftTree.equals("Cancer")){
		        		  out.println("demoIframe.attr(\"src\", treeNode.file + \".jsp?PID=\"+treeNode.PID);");
		        	  }
		        	  %>
		            return true;
		          }
		        }
		      }
	};
var setting = {
	      view: {
	        dblClickExpand: true,
	        showLine: true,
	        selectedMulti: false
	      },
	      data: {
	        simpleData: {
	          enable: true,
	        }
	      },
	      callback: {
	        beforeClick: function (treeId, treeNode) {
	          //var zTree = $.fn.zTree.getZTreeObj("tree");
	          var zTree = $.fn.zTree.getZTreeObj("treeDemo");
	          if (treeNode.isParent) {
	            zTree.expandNode(treeNode);
	            return false;
	          } else {
	        	  <%
	        	  if(leftTree.equals("Normal")||leftTree.equals("Cancer")){
	        		  out.println("demoIframe.attr(\"src\", treeNode.file + \".jsp?PID=\"+treeNode.PID);");
	        	  }
	        	  %>
	            return true;
	          }
	        }
	      }
};
</script>
<body>
 

<div class="container-fluid" style="background-color:#fff;">
	<div class="row">
		<div class="col-3">
			<form method="post" name="form" target="right">
				<div id="treeDemo" class="ztree">
				<img src="images/loading.gif"/>
			</div>
			</form>
		</div>
		<div class="col-9">
			<%if(leftTree.equals("Normal")){ %>
			<iframe width="100%" height="2000px" src="RBrowse_n.jsp" id="right" name="right" scrolling="AUTO" frameborder="0" style="overflow:hidden;"></iframe>        
			<%}else if(leftTree.equals("LncRNA")){ %>
			<iframe width="100%" height="774px" src="RBrowse_l.jsp" id="right" name="right" scrolling="AUTO" frameborder="0" style="overflow:hidden;"></iframe>        
			<%}else if(leftTree.equals("Cancer")){ %>
			<iframe width="100%" height="2000px" src="RBrowse_c.jsp" id="right" name="right" scrolling="AUTO" frameborder="0" style="overflow:hidden;"></iframe>
			<%}%>
		</div>
	</div>

</div>

 
<script>
var t = $("#treeDemo");
t = $.fn.zTree.init(t, setting, zNodes);
demoIframe = $("#right");

$.fn.zTree.init($("#treeDemo"), setting, zNodes);
</script>

</body>
</html>