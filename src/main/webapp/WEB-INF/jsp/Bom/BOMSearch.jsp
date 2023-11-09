<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%
	/**
	 * @Name : BOMSearch
	 */       
%>   
<c:import url="../import/frameTop.jsp">
	<c:param name="progcd" value="BOMSearch" />
</c:import>
	
<!-- dummy -->
<div class="top_button_h_margin"></div>

<div id="ctu_wrap">
	<!--  <input type="text"  name="lineAlign"  id="lineAlign" style="visibility:hidden;"/>-->
	<!-- 검색조건 영역 시작 -->
	<form id="frmSearch" action="#">
		<input type="hidden"  name="CURRENT_PAGE"  id="CURRENT_PAGE" />
		<input type="hidden"  name="ROWS_PER_PAGE"  id="ROWS_PER_PAGE" />
			<div class="tab_top_search">
				<table>
					<tbody>  
						<tr>
							<td class="small_td" style="width:149px;"><p><s:message code="material.materialCode"/></p></td>
							<td class="medium_td" style="width:320px;"><input type="text" name="MATL_CD_ST" id="MATL_CD_ST" style="ime-mode:disabled;" maxlength="10" onKeyPress="fn_onlyNum(this)" >
							<td  width="180px" class="small_td"><p><s:message code="report.quotation.materialdec"/></p></td>
							<td class="medium_td"><input type="text" name="MATL_NM_ST" id="MATL_NM_ST"></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="small_td"><p><s:message code="material.plant"/></p></td>
							<td><select id="PLANT_CD" name="PLANT_CD"  class=""></select></td>
							<td class="small_td"><p><s:message code="material.usage"/></p></td>
							<td><select id="BOM_USAGE" name="BOM_USAGE" class=""></select></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="small_td"><p><s:message code="customer.ValidTo"/></p></td>
							<td><input type="text" id="VALID_DT" name="VALID_DT" data-type="date" readonly="true"/>
							<td><p style="float:left; margin-left:20px;"><p style="float:left; margin-left:23px;"><s:message code="material.headerdeletion"/></p></td>
							<td><label class="checkbox" style="margin-top:-9px;"><input type="checkbox" name="EXC_HD" id="EXC_HD" checked></input><i style="margin-top:-7px;">&nbsp;</i></label></td>
							<td>&nbsp;</td>
						</tr>
					</tbody>
				</table>
			</div>
	</form>
	<!-- 검색조건 영역 끝 -->
		
	<!-- 그리드 시작 -->
	<div class="ctu_g_wrap" style="width:100%; float:left; padding-top:0px;">
		<div class="ct_grid_top_wrap">
			<div class="ct_grid_top_left">
				<h4><s:message code='title.bomsearch'/></h4>
			</div>
		</div>		
		<table id="grid1"></table>
	    <div id="grid1_pager"></div>
	</div>
	<!-- 그리드 끝 -->

	<!-- 그리드 시작 -->
	<div class="ctu_g_wrap" style="width:100%; float:left; padding-top:2px;">
		<div class="ct_grid_top_wrap">
			<div class="ct_grid_top_left">
				<h4><s:message code='title.bomdetail'/></h4>
			</div>
			<div class="ct_grid_top_right">
				<input type="hidden" name="CURRENT_PAGE2"  id="CURRENT_PAGE2" />
				<input type="hidden" name="ROWS_PER_PAGE2"  id="ROWS_PER_PAGE2" />
			</div>	
		</div>
		<table id="grid2"></table>
	    <div id="grid2_pager"></div>
	</div>
</div>
<script type="text/javascript">
<%-- 
  * ========= 공통버튼 클릭함수 =========
  * 검색 : cSearch()
  * 추가 : cAdd()
  * 삭제 : cDel()
  * 저장 : cSave()
  * 인쇄 : cPrint()
  * 업로드 : cUpload()
  * 엑셀다운 : cExcel()
  * PDF다운 : cPdf()
  * 취소 : cCancel()
  * 사용자버튼 : cUser1() ~ cUser5()
  * -------------------------------
  * 버튼 순서 : setCommBtnSeq(['ret','list']) : Search,Add,Del,Save,Print,Upload,Excel,Pdf,Cancel,User1,2,3,4,5
  * 버튼 표시/숨김 : setCommBtn('ret', true) : Search,Add,Del,Save,Print,Upload,Excel,Pdf,Cancel,User1,2,3,4,5
  * ===============================
--%>
	//초기 로드
	$(function() {
		setCommBtn('Search', true);				
		initLayout();
		createGrid1();
		createGrid2();

		$('#MATL_CD_ST').focus();
		
		var codeBoxArray = [ 'PLANT_CD'
							, 'BOM_USAGE'
						   ];
				
		createCodeBoxByArr(codeBoxArray, true);

		$("#PLANT_CD").val('1000');
		$("#BOM_USAGE").val('5');
		$('#grid1').bind('jqGridSelectRow', function(e, rowid, status) {
				grid1_onCilckRow(e, rowid, status);
			});
			
		$('#MATL_CD_ST, #MATL_NM_ST').on('keyup', function (e) {
			if(e.which == 13){
				cSearch();
			}
		});
		
	});
	
	function createGrid1(){
		var colName = [
		     		  '<s:message code="material.materialCode"/>'
		     		, '<s:message code="material.material"/>'
		     		, '<s:message code="material.grid.desc"/>'
		     		, '<s:message code="material.usage"/>'
		     		, 'Plant code'
		     		, '<s:message code="material.plant"/>'
		     		, '<s:message code="material.baseQuantity"/>'
		     		, '<s:message code="material.basicUnit"/>'
		     		, 'Status code'
		     		, '<s:message code="material.bomStatus"/>'
		     		, '<s:message code="material.validFrom"/>'
		     		, '<s:message code="material.validTo"/>'
		     		];
		     	var colModel = [
		     		  { name: 'MATL_CD', width: 100, align: 'center'}
		     		, { name: 'MATL_DESC', width: 120, align: 'left', hidden:true}
		     		, { name: 'MATL_NM', width: 350, align: 'left' }
		     		, { name: 'BOM_USAGE', width: 100, align: 'left', hidden :true }
		     		, { name: 'PLANT_CD', width: 100, align: 'center', hidden :true}
		     		, { name: 'PLANT_NM', width: 200, align: 'left' }
		     		, { name: 'BOM_QTY', width: 100, align: 'right'}
		     		, { name: 'UNIT_CD', width: 100, align: 'center' }
		     		, { name: 'STATUS', width: 100, align: 'center' , hidden :true}
		     		, { name: 'STATUS_NM', width: 100, align: 'center' }
		     		, { name: 'VAL_FR_DT', width: 100, align: 'center' }
		     		, { name: 'VAL_TO_DT', width: 100, align: 'center' }
		     		];
		     	
		var gSetting = {
		        pgflg:true,
		        exportflg : true,  //엑셀, pdf 출력 버튼 노출여부
		        colsetting : true,
				searchInit : false,
				resizeing : true,
				rownumbers:false,
				shrinkToFit: true,
				autowidth: true,
				queryPagingGrid:true, // 쿼리 페이징 처리 여부
				height:247
		};
		
		btGrid.createGrid('grid1', colName, colModel, gSetting);
	}
	
	function createGrid2(){
		var colName = ['<s:message code="material.item"/>'
			             , 'ICT'
			             , '<s:message code="material.component"/>'
			             , '<s:message code="material.componentDescription"/>'
			             , '<s:message code="material.quantity"/>'
			             , '<s:message code="material.unit"/>'
			             , '<s:message code="material.validFrom"/>'
			             , '<s:message code="material.validTo"/>'
			             , '<s:message code="material.relToSales"/>'];
			var colModel = [
				{ name: 'ITEM', width: 80, align: 'center'},
				{ name: 'ITEM_CTG', width: 100, align: 'left' },
				{ name: 'COMPONENT', width: 100, align: 'center' },
				{ name: 'COMPONENT_DESC', width: 200, align: 'left' },
				{ name: 'QTY', width:100, align: 'right'},
				{ name: 'UNIT', width: 100, align: 'center' },
				{ name: 'FROM_DT', width: 100, align: 'center' },
				{ name: 'TO_DT', width: 100, align: 'center' },				
				{ name: 'RTS', width: 150, align: 'left' , hidden :true}
		  	];
		
		var gSetting = {
		        pgflg:true,
		        exportflg : true,  //엑셀, pdf 출력 버튼 노출여부
		        colsetting : true,
				searchInit : false,
				resizeing : true,
				rownumbers:false,
				shrinkToFit: true,
				autowidth: true,
				queryPagingGrid:true, // 쿼리 페이징 처리 여부
				height:247
		};
		
		btGrid.createGrid('grid2', colName, colModel, gSetting);
	}
	
	function grid1_onCilckRow(e, rowid, status){
		if(rowid.indexOf("new") > -1){
			clearGrid("grid2");
		}
		btGrid.gridSaveRow('grid1');
		detailSearch(null, rowid);
	}
	
	function cSearch(currentPage){

		var vCurrentPage = 1;
		var vRowsPerPage;
		if(!fn_empty(currentPage)){
			vCurrentPage = currentPage;
		} else if(!fn_empty($('#CURRENT_PAGE').val())) {
			vCurrentPage = $('#CURRENT_PAGE').val();
		} else {
			vCurrentPage = 1;
		}
		vRowsPerPage = btGrid.getGridRowSel('grid1_pager');
		$('#CURRENT_PAGE').val(vCurrentPage);
		$('#ROWS_PER_PAGE').val(vRowsPerPage);
		
		var url = "/Bom/selectMaterialList.do";
		
		var formData = formIdAllToMap('frmSearch');
		var param = {"param":formData};
		
		fn_ajax(url, true, param, function(data, xhr){
			if(fn_empty(data)){
				clearGrid("grid2");
			}else{
				reloadGrid("grid1", data.result);
				btGrid.gridQueryPaging($('#grid1'), 'cSearch', data.result);
				if(data.result.length > 0){
					$('#grid1').jqGrid('setSelection', $('#grid1').jqGrid('getDataIDs')[0]);
				}else{
					$("#grid2").jqGrid("clearGridData", true);
				}
			}

		});
	}
	
	function detailSearch(currentPage, rowid){
		var vCurrentPage = 1;
		var vRowsPerPage;
		if(!fn_empty(currentPage)){
			vCurrentPage = currentPage;
		} else if(!fn_empty($('#CURRENT_PAGE2').val())) {
			vCurrentPage = $('#CURRENT_PAGE2').val();
		} else {
			vCurrentPage = 1;
		}
		vRowsPerPage = btGrid.getGridRowSel('grid2_pager');
		$('#CURRENT_PAGE2').val(vCurrentPage);
		$('#ROWS_PER_PAGE2').val(vRowsPerPage);
		if(fn_empty(rowid)){
			rowid = $('#grid2').jqGrid('getGridParam', 'selrow');
		}

		var rowData = $("#grid1").getRowData(rowid);
		var url = "/Bom/selectBOMList.do";
		
		btGrid.gridEditRow("grid1", rowid);
		var formData = formIdAllToMap('frmSearch');
		formData["MATL_CD"] = rowData["MATL_CD"];
		formData["PLANT_CD"] = rowData["PLANT_CD"];
		formData["CURRENT_PAGE"] = $('#CURRENT_PAGE2').val();
		formData["ROWS_PER_PAGE"] = $('#ROWS_PER_PAGE2').val();
		var param = {"param":formData};
		fn_ajax(url, false, param, function(data, xhr){
			reloadGrid("grid2", data.result);
			btGrid.gridQueryPaging($('#grid2'), 'detailSearch', data.result);
		});
	}
	

	//공통버튼 - 엑셀 다운 클릭
	function cExcel() {
		if (confirm('<s:message code="info.excel"/>') == true) { 
			
			var colNms = excelToMap();
			
			var param = {"MATL_CD_ST": $("#MATL_CD_ST").val()
					    ,"MATL_NM_ST": $("#MATL_NM_ST").val()
					    ,"PLANT_CD":   $("#PLANT_CD").val()
					    ,"BOM_USAGE":  $("#BOM_USAGE").val()
					    ,"VALID_DT":   $("#VALID_DT").val()
					    ,"EXC_HD":     $("#EXC_HD").val()
					    ,'COL_NM':	   colNms};
		};
		fn_formSubmit('/Bom/selectBOMListAll.do', param);
	}
	
	function excelToMap() {
		
		var colNms = $("#grid1").jqGrid('getGridParam','colNames');
		var colid = $("#grid1")[0].p.colModel;
		var _string =  '%' ;
		for(var i= 0 ; i < colid.length; i++) {
			if(colid[i].name != "CHK"){
				if(i == (colid.length -1)) {
					 _string += ''+colid[i].name+':'		+ colNms[i] +'';
				}else  _string += ''+colid[i].name+':'		+ colNms[i] +',';
			}
		}
		var colNms2 = $("#grid2").jqGrid('getGridParam','colNames');
		var colid2 = $("#grid2")[0].p.colModel;
		
		for(var i= 0 ; i < colid2.length; i++) {
			if(colid2[i].name != "CHK"){
				if(i == (colid2.length -1)) {
					 _string += ''+colid2[i].name+':'		+ colNms2[i] +'';
				}else  _string += ''+colid2[i].name+':'		+ colNms2[i] +',';
			}
		}
		_string +=  '%' ;
		return _string;
	}
</script>
<c:import url="../import/frameBottom.jsp" />