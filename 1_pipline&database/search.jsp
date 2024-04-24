<%@ page import="java.sql.*" import="java.util.*" import="download.*"
	language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
<script src="js/jquery-2.0.0.min.js" ></script>

<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel="";
db.open();
%>
<%
String method = request.getParameter("method");

if(method==null || method==""){
	method = "cancer";
}

HashMap<String,String> hash_resource = new HashMap<String,String>();
hash_resource.put("hcl","Human Cell Landscape");
hash_resource.put("tts","The Tabula Sapiens");
hash_resource.put("other","GSE140819");
hash_resource.put("cell_res","Qian et al., Cell Research 2020");
hash_resource.put("tica","TICA");
hash_resource.put("epn","GSE125969");

HashMap<String,String> hash_method = new HashMap<String,String>();
hash_method.put("normal","normal tissues");
hash_method.put("cancer","cancer tissues");
hash_method.put("lncRNA","lncRNA");
hash_method.put("cell","single cell");
%>
<script language="javascript">
/*联动*/
function change_normal_source(tissue){
	$.get("back_changeTissueSource.jsp",
			{
				tissue:tissue,
			},
			function(data){
				var resource = data.split("=");
				$('#resource_tissue_sig option').remove();
				$('#resource_tissue_sig').append("<option value=''></option>");
				for (var i = 1; i < resource.length; i++) {
					if(resource[i]=="hcl"){
						$('#resource_tissue_sig').append("<option value='hcl' title='Human Cell Landscape'>Human Cell Landscape</option>");
					}else if(resource[i]=="tts"){
						$('#resource_tissue_sig').append("<option value='tts' title='The Tabula Sapiens'>The Tabula Sapiens</option>");
					}else if(resource[i]=="tica"){
						$('#resource_tissue_sig').append("<option value='tica' title='TICA'>TICA</option>");
					}
				}
		});
}
function change_tissue_cell(){
	$.get("back_changeTissueCell.jsp",
			{
				source:$("#resource_tissue_sig").find("option:selected").val(),
				c:$("#tissue_sig option:selected").val()
			},
			function(data){
				var cell = data.split("=");
				$('#sigcell_type1 option').remove();
				$('#sigcell_type1').append("<option value=''>All cell type</option>");
				for (var i = 1; i < cell.length; i++) {
					$('#sigcell_type1').append("<option value='"+cell[i]+"' title='"+cell[i]+"'>"+cell[i]+"</option>");
				}
		});
}
function change_cancer_source(cancer){
	$.get("back_changeCancerSource.jsp",
			{
				cancer:cancer,
			},
			function(data){
				var tifull = data.split("#");
				$('#resource_cancer_sig option').remove();
				$('#resource_cancer_sig').append("<option value=''></option>");
				for (var i = 1; i < tifull.length; i++) {
					var tis = tifull[i].split("%");
					//for(var j=0;j<tis.length;j++){
						//var ca = tis[j].split("#");
					$('#resource_cancer_sig').append("<option value='"+tis[1]+"' title='"+tis[2]+"'>"+tis[0]+"</option>");
					//}
					/*if(resource[i]=="JunbinQian.CellResearch.2020"){
						$('#resource_cancer_sig').append("<option value='cell_res' title='"+resource[i]+"'>"+resource[i]+"</option>");
					}else if(resource[i]=="NGDC"){
						$('#resource_cancer_sig').append("<option value='cra' title='CRA001160'>"+resource[i]+"</option>");
					}else{
						$('#resource_cancer_sig').append("<option value='"+resource[i]+"' title='"+resource[i]+"'>"+resource[i]+"</option>");	
					}*/
				}
		});
}
	//var c = $("#cancer_sig option:selected").val();
	//var c = $("#cancer_sig").find("option:selected").val();
	//$('#cancer_sig option').remove();
function change_cancer_cell(){
		$.get("back_changeCancerCell.jsp",
			{
				source:$("#resource_cancer_sig").find("option:selected").val(),
				//c:$("#cancer_sig option:selected").val()
			},
			function(data){
				var cell = data.split("=");
				$('#sigcell_type2 option').remove();
				$('#sigcell_type2').append("<option value=''>All cell type</option>");
				for (var i = 1; i < cell.length; i++) {
					var cell1 =  cell[i].split("%");
					$('#sigcell_type2').append("<option value='"+cell1[0]+"' title='"+cell1[1].replace("_"," ")+"'>"+cell1[1].replace("_"," ")+"</option>");
				}
			});
}

function change_compart_cell(compart){
	$.get("back_changeCompartCell.jsp",
			{
				compart:compart,
			},
			function(data){
				var cell = data.split("=");
				$('#currcell option').remove();
				$('#currcell').append("<option value=''></option>");
				$('#currcell').append("<option value='all'>All cell type</option>");
				for (var i = 1; i < cell.length; i++) {
					$('#currcell').append("<option value='"+cell[i]+"' title='"+cell[i]+"'>"+cell[i]+"</option>");
				}
		});
}

function change_cell_dataset(){
	$.get("back_changeCompartCell.jsp",
		{
			compart:$("#compart").find("option:selected").val(),
			cell:$("#currcell option:selected").val()
		},
		function(data){
			var cell = data.split(";");
			$('#cellresour option').remove();		
			//$('#cellresour').append("<option value='all'>All</option>");
			for (var i = 1; i < cell.length; i++) {
				var cell1 =  cell[i].split("%");
				$('#cellresour').append("<option value='"+cell1[0]+"' title='"+cell1[1]+"'>"+cell1[1]+"</option>");
			}
		});
}

function submit_1(){	
	var value2 = $("#resource_tissue_sig").val();	
	if(value2=="" || value2==null){
		alert("Not emperty!Please select a resource!");
	}else{
		document.form1.submit();
	}
}
function submit_2(){
	var value1 = $("#resource_cancer_sig").val();	
	if(value1=="" || value1==null){
		alert("Not emperty!Please select a resource!");
	}else{
		document.form2.submit();
	}
}

function submit_4(){
	var value1 = $("#currcell").val();
	var value2 = $("#cellresour").val();	
	if(value1=="" || value1==null || value2=="" || value2==null){
		alert("Not emperty!Please select a resource!");
	}else{
		document.form4.submit();
	}
}

function getGeneName(value){
	$('#GeneName').css('display','block');
	$.get("back_getGeneSearch.jsp",
			{
			value:value,
			//tissue_cancer:$('#tissue_cancer option:selected').val(),
			//tissue_type:$('#tissue_type option:selected').val()
			},
			function(data){
				$("#GeneName").empty();
				var gene = data.split(",");
				for (var i = 1; i < gene.length; i++) {
					if(i>500)
						break;
					$('#GeneName').append('<div onclick="giveValue(this)">'+gene[i]+'</div>');
				}
		});
}
function giveValue(geneName){
	$('#sigcell_lncrna').val($(geneName).text());
	$('#GeneName').css('display','none');
	//$('#submit').css('margin-top','-215px');
}

window.onclick = function(event) {
var _con = $('#GeneName'); // 设置目标区域
if (!_con.is(event.target) && _con.has(event.target).length === 0) { 
	$('#GeneName').css('display','none');
 }
}

function example_1(){
	document.getElementById("tissue_sig").value ="Lung";
	$('#resource_tissue_sig option').remove();
	$('#resource_tissue_sig').append("<option value='tts'>The Tabula Sapiens</option>");
	document.getElementById("resource_tissue_sig").value ="tts";
	$('#sigcell_type1').append("<option value='Neutrophil'>Neutrophil</option>");
	document.getElementById("sigcell_type1").value ="Neutrophil";	
}

function example_2(){
	$('#cancer_sig').append("<option value='Lung cancer'>Lung cancer</option>");
	document.getElementById("cancer_sig").value = "Lung cancer";
	$('#resource_cancer_sig option').remove();
	$('#resource_cancer_sig').append("<option value='NSCLC=GSE117570=geo'>NSCLC (GSE117570)</option>");
	document.getElementById("resource_cancer_sig").value = "NSCLC=GSE117570=geo";
	$('#sigcell_type2').append("<option value='Monocyte/Macrophage'>Monocyte/Macrophage</option>");
	document.getElementById("sigcell_type2").value = "Monocyte/Macrophage";
}

function example_3(){
	document.getElementById("sigcell_lncrna").value = "LUCAT1";
}
function example_4(){
	$('#compart').append("<option value='immune'>immune</option>");
	document.getElementById("compart").value = "immune";
	$('#currcell option').remove();
	$('#currcell').append("<option value='Monocyte/Macrophage'>Monocyte/Macrophage</option>");
	document.getElementById("currcell").value = "Monocyte/Macrophage";
	$('#cellresour').append("<option value='NSCLC=GSE117570=geo'>NSCLC(GSE117570)</option>");
	document.getElementById("cellresour").value = "NSCLC=GSE117570=geo";
}
</script>
<title>LncCE</title>
</head>
<style>
.font-color{
	color:#8064A2;
}
.row-distance{
	margin-top: 20px;
}
.row-distance2{
	margin-top: 43px;
}
.in-quick-search {
    /*position: absolute;
    z-index: 999;
    width: 890.39px;
    left: 315px;
    display: none;
    background-color: rgb(255, 255, 255);*/
    cursor: pointer;
    height: 298px;
    overflow: auto;
}
</style>
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
<section id="content" style="margin-top: 42px;height: 693px;">
	<div class="zerogrid">
		<div class="container-fluid">			
			<div class="heading">
				<h2><a class="font-color">Search <%=hash_method.get(method) %> of LncCE</a></h2>
			</div>
			<hr>
			<%if(method.equals("normal")){ %>
			<div class="content">
				<div class="card card-body">
					<div class="container">
						<form action="search_re.jsp" name="form1">
						<div>
							<label for="tissue_sig"><h4>Tissue:</h4></label><br/>
							<select id="tissue_sig" name="tissue_sig" class="form-control" onchange=change_normal_source(this.value)>
							<option value="Lung" title="Lung">Lung</option>
							<% 
							sel = "select distinct tissue_type1,tissue_type from tissue_cell order by tissue_type1";
							rs = db.execute(sel);
							while(rs.next()){
								out.println("<option value='"+rs.getString("tissue_type")+"' title='"+rs.getString("tissue_type1")+"'>");
									out.println(""+rs.getString("tissue_type1")+"");
								out.println("</option>");
								}
							%>
							</select>
						</div>
						<div class="row-distance">
							<label for="resource_tissue_sig"><h4>Resource:</h4></label><br>
							<select id="resource_tissue_sig" name="source_sig" class="form-control" onchange=change_tissue_cell()>
							<option value="tts" title="The Tabula Sapiens">The Tabula Sapiens</option>								
							</select>
						</div>
						<div class="row-distance">
							<label for="classification3"><h4>Classification:</h4></label><br>
							<select id="classification3" name="classification" class="form-control">
							<option value="" title="detected increased expression in cells,including cell specific(CS),cell enriched(CER) and cell enhanced(CEH)">CE</option>
							<option value="CS" title="Detected only in a particular cell">CS</option>
							<option value="CER" title="At least fivefold higher lncRNA levels in a particular cell as compared to all other cells">CER</option>
							<option value="CEH" title="At least fivefold higher lncRNA levels in a particular cell as compared to the average levels in all cells">CEH</option>
							</select>
						</div>
						<div class="row-distance">
							<label for="sigcell_type1"><h4>Cell type:</h4></label><br>
							<select id="sigcell_type1" name="sigcell_type2" class="form-control">
							<option value='Neutrophil'>Neutrophil</option>
							<option value=''>All cell type</option>
							<%
							sel = "select cell_type from tissue_cell where tissue_type='Lung' and resource='tts'";
							rs = db.execute(sel);
							while(rs.next()){
								out.println("<option value='"+rs.getString("cell_type")+"' title='"+rs.getString("cell_type")+"'>");
								out.println(""+rs.getString("cell_type")+"");
								out.println("</option>");
							}
							db.close();
								%>
							</select>
						</div>
						<div class="row-distance">
						<button type="button" class="btn btn-outline-dark" onclick="submit_1()"><h4>Submit</h4></button>
						<button type="button" class="btn btn-outline-dark" onclick="example_1()"><h4>Example</h4></button>
						</div>
						</form>
					</div>	
				</div>
			</div>
			<%}else if(method.equals("cancer")){ %>
			<div class="content">
				<div class="card card-body">
					<div class="container">
						<form action="search_re.jsp" name="form2">
						<div>
							<label for="cancer_sig"><h4>Cancer:</h4></label><br/>
							<select id="cancer_sig" name="cancer_sig" class="form-control" onchange=change_cancer_source(this.value)>
							<option value="Lung cancer" title="Lung cancer">Lung cancer</option>
							<% 
							sel="select distinct class from cancer_resource order by class";
							rs = db.execute(sel);
							while(rs.next()){
								out.println("<option value='"+rs.getString("class")+"' title='"+rs.getString("class")+"'>");
								out.println(rs.getString("class"));
								out.println("</option>");
							}
							%>
							</select>
						</div>
						<div class="row-distance">
							<label for="resource_cancer_sig"><h4>Resource:</h4></label><br>
							<select id="resource_cancer_sig" name="canc_dataset" class="form-control" onchange=change_cancer_cell()>
							<option title='NSCLC(GSE117570)' value='NSCLC=GSE117570=geo'>NSCLC(GSE117570)</option>
							<%
							sel="select distinct tissue_full,tissue,cancer_name from cancer_resource where class='Lung cancer' order by tissue_full";
							rs = db.execute(sel);
							while(rs.next()){
								out.println("<option value='"+rs.getString("tissue")+"' title='"+rs.getString("cancer_name")+"'>");
								out.println(rs.getString("tissue_full"));
								out.println("</option>");
							}
							%>								
							</select>
						</div>
						<div class="row-distance">
							<label for="classification3"><h4>Classification:</h4></label><br>
							<select id="classification3" name="classification" class="form-control">
							<option value="" title="detected increased expression in cells,including cell specific(CS),cell enriched(CER) and cell enhanced(CEH)">CE</option>
							<option value="CS" title="Detected only in a particular cell">CS</option>
							<option value="CER" title="At least fivefold higher lncRNA levels in a particular cell as compared to all other cells">CER</option>
							<option value="CEH" title="At least fivefold higher lncRNA levels in a particular cell as compared to the average levels in all cells">CEH</option>
							</select>
						</div>
						<div class="row-distance">
							<label for="sigcell_type2"><h4>Cell type:</h4></label><br>
							<select id="sigcell_type2" name="sigcell_type2" class="form-control">
							<option title='Monocyte/Macrophage' value='Monocyte/Macrophage'>Monocyte/Macrophage</option>							
							<option value=''>All cell type</option>
							<%
							sel = "select cell_type from cancer_resource where tissue='BRCA=GSE114727_indrop=geo'";
							rs = db.execute(sel);
							while(rs.next()){
								out.println("<option value='"+rs.getString("cell_type")+"' title='"+rs.getString("cell_type")+"'>");
								out.println(""+rs.getString("cell_type")+"");
								out.println("</option>");
							}
							db.close();
								%>
							</select>
						</div>
						<div class="row-distance">
						<button type="button" class="btn btn-outline-dark" onclick="submit_2()"><h4>Submit</h4></button>
						<button type="button" class="btn btn-outline-dark" onclick="example_2()"><h4>Example</h4></button>
						</div>
						</form>
					</div>	
				</div>
			</div>
			<%}else if(method.equals("lncRNA")){%>
			<div class="content">
				<div class="card card-body" style="height: 503px;">
					<div class="container">
						<form action="search_re_lnc.jsp" name="form3">
						<input name="showPage" id="showPage" type="hidden" value=1>
						<div class="input-group" style="margin-top: 144px;">  				
  						<input oninput="getGeneName(this.value)" type="text" class="form-control" aria-label="Text input with dropdown button" id="sigcell_lncrna" name="sigcell_lncrna" placeholder="LUCAT1/ENSG00000248323"></input>
  						<div class="input-group-append">
    					<button class="btn btn-outline-dark" type="Submit">Submit</button>
  						<button class="btn btn-outline-dark" onclick="example_3()" type="button">Example</button>
  						</div>
						</div>
						<div id="GeneName" class="in-quick-search"></div>
						</form>
					</div>
				</div>
			</div>
			<%}else if(method.equals("cell")){ %>
			<div class="content">
				<div class="card card-body" style="height: 559px;">
					<div class="container">
					<form action="cell_re.jsp" name="form4">
					<label for="compart"><h4>Compartment:</h4></label><br/>
					<select id="compart" name="compart" class="form-control" onchange=change_compart_cell(this.value)>
					<option value='immune'>immune</option>
					<%
					String[] compartment = {"cancer","endothelial","epithelial","immune","Other","stromal"};
					for(int i=0;i<compartment.length;i++){
						out.println("<option title='"+compartment[i]+"' value='"+compartment[i]+"'>"+compartment[i]+"</option>");
					}
					%>
					</select>
					
					<div class="row-distance2">
					<label for="currcell"><h4>Cell type:</h4></label><br/>
					<select id="currcell" name="currcell" class="form-control" onchange=change_cell_dataset(this.value)>
					<option value='Monocyte/Macrophage'>Monocyte/Macrophage</option>
					<option value='all' title='All cell type'>All cell type</option>
					<%
					sel = "select distinct cell_type from cell_tissue where compartment='cancer' order by cell_type";
					rs = db.execute(sel);
					while(rs.next()){
						out.println("<option value='"+rs.getString("cell_type")+"' title='"+rs.getString("cell_type")+"'>");
						out.println(""+rs.getString("cell_type")+"");
						out.println("</option>");
					}

					%>
					</select>
					</div>
					
					<div class="row-distance2">
					<label for="cellresour"><h4>Resource:</h4></label><br/>
					<select id="cellresour" name="cellresour" class="form-control">
					<option title='NSCLC(GSE117570)' value='NSCLC=GSE117570=geo'>NSCLC(GSE117570)</option>
					<%
					sel = "select distinct search,fix from cell_tissue where compartment='cancer' order by fix";
					rs = db.execute(sel);
					while(rs.next()){
						out.println("<option value='"+rs.getString("search")+"' title='"+rs.getString("fix")+"'>");
						out.println(""+rs.getString("fix")+"");
						out.println("</option>");
					}
					db.close();
					%>
					</select>
					</div>
					
					<div class="row-distance2">
						<button type="button" class="btn btn-outline-dark" onclick="submit_4()"><h4>Submit</h4></button>
						<button type="button" class="btn btn-outline-dark" onclick="example_4()"><h4>Example</h4></button>
					</div>
					
					</form>
					</div>
				</div>
			</div>
			<%}%>
		</div>
	</div>
</section>
<div style="height:25px;"></div>
<!--------------Footer--------------->
<footer>		
	<div id="copyright">
	<p>Copyright© 2023 College of Bioinformatics Science and Technology, Harbin Medical University</p>
	</div>
</footer>
</body>
</html>