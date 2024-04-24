<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
<!-- datatable -->
<link rel="stylesheet" type="text/css" href="datatable/jquery.dataTables.min.css">
<script type="text/javascript" charset="utf8" src="datatable/jquery.dataTables.min.js"></script>
<title>LncCE</title>
</head>
<body>
<!--------------Header--------------->
<header> 
	<div id="logo"><a href="index.jsp"><img width="408px" src="./images/home/logo-white.png"/></a></div>	
</header>
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

<section id="content" style="margin-top: 32px;height: 693px;">
	<div class="zerogrid">
		<div style="height:25px;"></div>
		<div class="container-fluid">			
			<div class="heading">
				<h2><a class="font-color">Download data from database</a></h2>
			</div>
			<hr>
			<div class="container-fluid">
				<div class="card">
					<div class="card-header">
					<h3>Resources</h3>
					</div>
					<div class="card-body">
					<table id="resource-lyj" class="display table" style="width:100%">
					<thead style="text-align:center">
						<tr>
							<th style="text-align:center">Type</th>
							<th style="text-align:center">Description</th>
							<th style="text-align:center">Download link</th>
						</tr>
					</thead>
					<tr class="">
						<td class='col_des'>Human Cell Landscape</td>
						<td class='col1'>All CE lncRNAs in Human Cell Landscape</td>
						<td class='col2'><form action="download/Human_Cell_Landscape.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>The Tabula Sapiens</td>
						<td class='col1'>All CE lncRNAs in The Tabula Sapiens</td>
						<td class='col2'><form action="download/The_Tabula_Sapiens.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>TICA</td>
						<td class='col1'>All CE lncRNAs in The TICA</td>
						<td class='col2'><form action="download/TICA.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>GEO</td>
						<td class='col1'>All CE lncRNAs in GEO</td>
						<td class='col2'><form action="download/GEO.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>Qian et al., Cell Research 2020</td>
						<td class='col1'>All CE lncRNAs in Qian et al., Cell Research 2020</td>
						<td class='col2'><form action="download/Cell_Research.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>NGDC</td>
						<td class='col1'>All CE lncRNAs in NGDC</td>
						<td class='col2'><form action="download/NGDC.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>					
					<tr>
						<td class='col_des'>EMTAB</td>
						<td class='col1'>All CE lncRNAs in EMTAB</td>
						<td class='col2'><form action="download/EMTAB.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
 					 
					<tr>
						<td class='col_des'>Integration</td>
						<td class='col1'>All TE lncRNAs in Integration</td>
						<td class='col2'><form action="download/Integration_classification.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>GTEx</td>
						<td class='col1'>All TE lncRNAs in GTEx</td>
						<td class='col2'><form
								action="download/GTEx_classification.txt" method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>HPA</td>
						<td class='col1'>All TE lncRNAs in HPA</td>
						<td class='col2'><form
								action="download/MCP_classification.txt" method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>HBM2</td>
						<td class='col1'>All TE lncRNAs in HBM2</td>
						<td class='col2'><form
								action="download/HBM2_classification.txt" method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>FANTOM</td>
						<td class='col1'>All TE lncRNAs in FANTOM</td>
						<td class='col2'><form
								action="download/FANTOM_classification.txt" method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>					
					<tr>
						<td class='col_des'>TCGA</td>
						<td class='col1'>All TE lncRNAs in TCGA</td>
						<td class='col2'><form action="download/TCGA_classification.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
					<tr>
						<td class='col_des'>TARGET</td>
						<td class='col1'>All TE lncRNAs in TARGET</td>
						<td class='col2'><form action="download/TARGET_classification.txt"
								method="get">
								<input class='image' type="image" src="images/download.jpg">
							</form></td>
					</tr>
				</table>
					</div>
				</div>
				<div style="height:20px;"></div>
				<div class="card">
					<div class="card-header">
					<h3>Normal tissues</h3>
					</div>
					<div class="card-body">
					<table id="tissue-lyj" class="display table" cellspacing="0" width="100%">
					<thead style="text-align:center">
						<tr>
							<th style="text-align:center">Normal tissues</th>
							<th style="text-align:center">Description</th>
							<th style="text-align:center">Download links</th>
						</tr>
					</thead>
					    <%
					    String[] tissues = {"Adipose","Adrenal Gland","Artery","Ascending Colon","Bladder","Blood","Bone Marrow","Bone Marrow CD34N","Bone Marrow CD34P","Brain","Brain Lake","Brain Zhong","Caecum","Calvaria","Cerebellum","Cervix","Duodenum","Epityphlon","Esophagus","Eye","Fallopian Tube","Fat","Female Gonad","Gall Bladder","Gonad Li","Heart","Ileum","Intestine","JeJunum","jejunum epithelial","jejunum lamina propria","Kidney","Large Intestine","Liver","Lung","Lung draining lymph nodes","Lymph Node","Male Gonad","Mammary","Mesenteric lymph nodes","Mid Brain LaManno","Muscle","Omentum","Pancreas","Pancreas Baron","Pancreas Muraro","Pancreas Segerstolpe","Peripheral Blood","Pleura","Prostate","Rectum","Rib","Salivary Gland","Sigmoid Colon","Skeletal muscle","Skin","Small Intestine","Spinal Cord","Spleen","Stomach","Temporal Lobe","Thymus","Thyroid","Tongue","Trachea","Transverse Colon","Ureter","Uterus","Vasculature"}; 
					    String[] resourceCount = {"1","1","1","1","2","2","1","1","3","1","1","1","1","1","1","1","2","1","1","2","1","1","1","1","1","2","2","1","1","1","1","2","1","3","1","3","1","1","1","1","1","2","2","1","1","1","2","1","1","2","1","1","1","2","1","2","1","1","3","1","1","3","1","1","2","2","1","2","1"};
					    String[] lncCount = {"21","377","145","28","1358","1349","109","50","1440","490","70","147","95","49","289","72","134","36","217","4332","261","1509","161","134","664","644","180","148","295","586","57","989","713","1229","486","2094","915","61","767","420","31","1429","317","57","79","243","1439","149","257","1209","52","44","1284","34","77","826","850","47","1636","333","82","1426","584","990","1271","295","32","867","1117"};
					    %>
					    
					    <%for(int i=0;i<tissues.length;i++){ %>
					    <tr style="text-align:center">
							<td><%=tissues[i]%></td>
							<td><%=lncCount[i] %> CE lncRNAs from <%=resourceCount[i]%> resources</td>
							<td>
							<form action="download/tissues/<%=tissues[i] %>.csv" method="get">
							<input class='image' type="image" src="images/download.jpg">
							</form>
							</td>
					    </tr>
					    <%} %>
					</table>
					</div>
				</div>
			
			<div style="height:20px;"></div>
			<div class="card">
				<div class="card-header">
				<h3>Cancer Tissues</h3>
				</div>
				<div class="card-body">
				<table id="cancer-lyj" class="display table" cellspacing="0" width="100%">
					<thead style="text-align:center">
						<tr>
							<th style="text-align:center">Cancer tissues</th>
							<th style="text-align:center">Description</th>
							<th style="text-align:center">Download links</th>
						</tr>
					</thead>
					<%
					String[] cancers = {"AEL","ALL","AML","BCC","BLCA","BRCA","CHOL","Chronic lymphocytic leukemia_scRNA","Chronic lymphocytic leukemia_snRNA","CLL","COAD","CRC","Ependymoma","GBM","Glioblastoma_scRNA","Glioma","HNSCC","KIRC","LICA","LIHC","LUAD_and_LUSC","MCC","Melanoma","Melanoma_snRNA","Metastatic breast cancer_brain metastatic_snRNA","Metastatic breast cancer_liver metastases_scRNA","Metastatic breast cancer_liver metastases_snRNA","Metastatic breast cancer_lymph node metastases_scRNA","MM","NET","NHL","non-small cell lung carcinoma_scRNA","NSCLC","OV","Ovarian_scRNA","Ovarian_snRNA","PAAD","Pediatric_high-grade glioma_snRNA","Pediatric_Neuroblastoma_snRNA","Pediatric_Sarcoma_snRNA","Pediatric_Sarcoma_rhabdomyosarcoma_snRNA","SCC","SKCM","UVM"}; 
					String[] lncCount1 = {"87","751","108","1430","264","2187","122","64","198","441","1293","2159","490","127","168","4303","249","553","630","1234","1404","1147","185","444","1223","833","1131","1005","222","173","226","1131","1890","1426","322","678","740","267","1499","1695","300","184","493","411"};
					String[] datasetCount = {"1","1","1","1","1","6","1","1","1","2","2","6","1","1","1","8","2","3","1","3","1","2","2","1","1","1","1","1","1","1","1","1","7","3","1","1","2","1","1","1","1","1","3","1"};
					%>
					    <%for(int i=0;i<cancers.length;i++){ %>
					    <tr style="text-align:center">
							<td><%=cancers[i]%></td>
							<td><%=lncCount1[i] %> CE lncRNAs from <%=datasetCount[i]%> datasets</td>
							<td>
							<form action="download/cancers/<%=cancers[i] %>.csv" method="get">
							<input class='image' type="image" src="images/download.jpg">
							</form>
							</td>
					    </tr>
					    <%} %>
				</table>
				</div>
			</div>
			</div>
			<div style="height:20px;"></div>
			
		</div>
	</div>
</section>
<script type="text/javascript">
	$(document).ready(function() {
		var table = $('#resource-lyj').DataTable({
	    	orderCellsTop: true,   //move sorting to top header
	  	});
	} );
	$(document).ready(function() {
		var table = $('#tissue-lyj').DataTable({
		    orderCellsTop: true,   //move sorting to top header
		  });
	} );
	$(document).ready(function() {
		var table = $('#cancer-lyj').DataTable({
		    orderCellsTop: true,   //move sorting to top header
		  });
	} );
</script>  

	
<!--------------Footer--------------->
<!-- <footer>		 -->
<!-- 	<div id="copyright"> -->
<!-- 	<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University</p> -->
	
<!-- </div> -->
<!-- </footer> -->

</body>
</html>