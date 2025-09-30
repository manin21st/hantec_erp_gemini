$PBExportHeader$w_pdm_11730.srw
$PBExportComments$기술/생산bom-요약/비교현황
forward
global type w_pdm_11730 from w_standard_print
end type
type rb_2 from radiobutton within w_pdm_11730
end type
type rb_1 from radiobutton within w_pdm_11730
end type
type cbx_bomend from checkbox within w_pdm_11730
end type
type rb_drilldown from radiobutton within w_pdm_11730
end type
type rb_drillup from radiobutton within w_pdm_11730
end type
type cbx_1 from checkbox within w_pdm_11730
end type
type ddlb_1 from dropdownlistbox within w_pdm_11730
end type
type st_1 from statictext within w_pdm_11730
end type
type gb_3 from groupbox within w_pdm_11730
end type
type gb_1 from groupbox within w_pdm_11730
end type
type gb_4 from groupbox within w_pdm_11730
end type
type ddlb_2 from dropdownlistbox within w_pdm_11730
end type
end forward

global type w_pdm_11730 from w_standard_print
string title = "BOM-요약/비교"
rb_2 rb_2
rb_1 rb_1
cbx_bomend cbx_bomend
rb_drilldown rb_drilldown
rb_drillup rb_drillup
cbx_1 cbx_1
ddlb_1 ddlb_1
st_1 st_1
gb_3 gb_3
gb_1 gb_1
gb_4 gb_4
ddlb_2 ddlb_2
end type
global w_pdm_11730 w_pdm_11730

type variables
long    il_row
int       check_box, ii_ddlb, ii_ddlb1
string  is_Gubun, Isbom
str_itnct lstr_sitnct
datastore ds_bom


end variables

forward prototypes
public function integer wf_calculation (string arg_itnbr, decimal arg_qty, string sname, string sset, string sspec, string smodelname, string sittyp, string susedate)
public function integer wf_retrieve ()
end prototypes

public function integer wf_calculation (string arg_itnbr, decimal arg_qty, string sname, string sset, string sspec, string smodelname, string sittyp, string susedate);string 	sItem,		&
			sbom1,		&
			sbom2, slname, sSTART, snewsql, snull, scvcod, scvnas, ls_porgu
Decimal {5} dUnprc1, dUnprc2, dUnprc3 			
			
Decimal {4} dqty
Long		Lpos, lvlno, imsg, Lrow, Lrow1 
String  ls_rfna1, ls_rfna2

SetNull(snull)

ds_bom.reset()

//조회 조건에서 사업장 추가 시작
dw_ip.AcceptText()
ls_porgu = dw_ip.getItemString(1, "porgu")

SELECT "REFFPF"."RFNA1"  ,
       "REFFPF"."RFGUB"
Into :ls_rfna1, :ls_rfna2
FROM "REFFPF"  
WHERE ( "REFFPF"."SABU" = '1' ) AND  
      ( "REFFPF"."RFCOD" = 'AD' ) AND  
     ( "REFFPF"."RFGUB" NOT IN ('00','99') )
AND "REFFPF"."RFGUB" = :ls_porgu;

if ls_porgu ='%' Then
	dw_print.object.t_100.text = '전체'
ElseIf ls_porgu = ls_rfna2 Then
	dw_print.object.t_100.text = ls_rfna1
End If
//조회 조건에서 사업장 추가 끝

// 품목번호
sItem = arg_itnbr
dqty  = arg_qty

if rb_1.checked then
	if rb_drilldown.checked then
		dw_print.object.t_3.text  = '상위품번'
		dw_print.object.t_21.text = '상위품명'
		dw_print.object.t_22.text = '상위규격'
		dw_print.object.t_2.text  = '상위재질'		
		
		dw_print.object.cinbr_no_t.text = '하위품번'		
		dw_print.object.cinbr_itdsc_t.text = '하위품명'		
		dw_print.object.t_24.text = '하위규격'				
	Else
		dw_print.object.t_3.text  = '하위품번'
		dw_print.object.t_21.text = '하위품명'
		dw_print.object.t_22.text = '하위규격'
		dw_print.object.t_2.text  = '하위재질'		
		
		dw_print.object.cinbr_no_t.text = '상위품번'		
		dw_print.object.cinbr_itdsc_t.text = '상위품명'		
		dw_print.object.t_24.text = '상위규격'		
	End if
End if

if rb_1.checked then
	dw_print.modify("st_itnbr.text = '" + arg_itnbr +"'")
	dw_print.modify("st_itdsc.text = '" + sname +"'")
	dw_print.modify("st_spec.text = '" + sspec +"'")
	dw_print.modify("st_jijil.text = '" + smodelname +"'")
	dw_print.modify("st_date.text = '" + string(susedate, "@@@@.@@.@@")  + "'")
End if
////////////////////////////////////////////////////////////////////////////
sstart = '%'

/* Argument 변경 */
if ds_bom.retrieve(arg_itnbr, sstart, ls_porgu) < 1 then 
	return 1
end if

Decimal {4}  dsaveqty[20], dtempqty, drstqty

w_mdi_frame.sle_msg.text = '구성수량을 재계산중입니다.'
Long    ll_cnt
ll_cnt = ds_bom.rowcount()
For lrow = 1 to ll_cnt
	 If rb_drilldown.checked then  //정전개
		 If ds_bom.getitemdecimal(lrow, "lvlno") = 1 Then
			 dsaveqty[1] = dqty * ds_bom.getitemdecimal(lrow, "qtypr")
			 ds_bom.setitem(lrow, "qtypr", dsaveqty[1])
			 continue
		 END IF		 
		 
		 dtempqty = dsaveqty[ds_bom.getitemdecimal(lrow, "lvlno") - 1]
		 drstqty  = dtempqty * ds_bom.getitemdecimal(lrow, "qtypr")
		 dsaveqty[ds_bom.getitemdecimal(lrow, "lvlno")] = drstqty
		 ds_bom.setitem(lrow, "qtypr", drstqty)
	 Else									//역전개
		 If ds_bom.getitemdecimal(lrow, "lvlno") = 1 Then
			 dsaveqty[1] = dqty / ds_bom.getitemdecimal(lrow, "qtypr")
			 ds_bom.setitem(lrow, "qtypr", dsaveqty[1])
			 continue
		 END IF		 
		 
		 dtempqty = dsaveqty[ds_bom.getitemdecimal(lrow, "lvlno") - 1]
		 drstqty  = dtempqty / ds_bom.getitemdecimal(lrow, "qtypr")
		 dsaveqty[ds_bom.getitemdecimal(lrow, "lvlno")] = drstqty
		 ds_bom.setitem(lrow, "qtypr", drstqty)			
	 End if	
Next

/* 유효일자 적용여부 */
for lrow = 1 to ds_bom.rowcount()
	 ds_bom.setitem(lrow, "gidat", susedate)
Next

For lrow = 1 to ds_bom.rowcount()
	 if susedate < ds_bom.getitemstring(lrow, "efrdt")  or &
		 susedate > ds_bom.getitemstring(lrow, "eftdt")  Then
		 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
		 ds_bom.deleterow(lrow)
		 Do while true	
			 if lrow  > ds_bom.rowcount() then exit
			 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
				 ds_bom.deleterow(lrow)				 
			 Else
				 Exit
			 End if
		 Loop
		 lrow = lrow - 1
	 End if
	 
	 // 정전개인 경우 대체품제외인 경우 처리
	 if cbx_1.checked = False and rb_drilldown.checked then
		 if Lrow <= ds_bom.rowcount() and Lrow > 0 then
		 if not IsNull( ds_bom.getitemstring(lrow, "dcinbr") )  Then
			 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
			 ds_bom.deleterow(lrow)
			 Do while true	
				 if lrow  > ds_bom.rowcount() then exit
				 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
					 ds_bom.deleterow(lrow)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
		 End if
	 End if		 
	 
	 // 역전개인 경우 대체품제외인 경우 처리(삭제)	 
	 if cbx_1.checked = False and rb_drillup.checked then
		 if Lrow <= ds_bom.rowcount() and Lrow > 0 then		
		 if not IsNull( ds_bom.getitemstring(lrow, "dcinbr") )  Then
			 Lrow = Lrow - 1
			 if Lrow < 0 then exit
			 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
			 ds_bom.deleterow(lrow)
			 Do while true	
				 if lrow  > ds_bom.rowcount() then exit
				 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
					 ds_bom.deleterow(lrow)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
		 End if
	 End if
	 
	 // 정전개인 경우 BOM미완료이면 삭제
	 if cbx_bomend.checked = False and rb_drilldown.checked then
		 if Lrow <= ds_bom.rowcount() and Lrow > 0  then		
		 if ds_bom.getitemstring(lrow, "bomend") = 'N'   Then
			 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
			 ds_bom.deleterow(lrow)
			 Do while true	
				 if lrow  > ds_bom.rowcount() then exit
				 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
					 ds_bom.deleterow(lrow)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
		 End if
	 End if		 	 
	 
	 // 역전개인 경우 BOM미완료 인 경우 처리(삭제)	 
	 if cbx_bomend.checked = False and rb_drillup.checked then
		 if Lrow <= ds_bom.rowcount() and Lrow > 0  then		
		 if ds_bom.getitemstring(lrow, "bomend") = 'N'  Then
			 Lrow = Lrow - 1
			 if Lrow < 1 then exit
			 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
			 ds_bom.deleterow(lrow)
			 Do while true	
				 if lrow  > ds_bom.rowcount() then exit
				 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
					 ds_bom.deleterow(lrow)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
		 End if
	 End if

	 
	 // 역전개인 경우 대체품처리시 표시방법 변경(요약일 경우에만 실행)
	 If rb_1.checked then
		 if cbx_1.checked = True and rb_drillup.checked then
			 if Lrow <= ds_bom.rowcount() and Lrow > 0  then		
			 if not IsNull( ds_bom.getitemstring(lrow, "dcinbr") )  Then
				 Lrow1 = Lrow - 1
				 if Lrow1 < 1 then exit
					 ds_bom.setitem(Lrow1, "dcinbr", ds_bom.getitemstring(Lrow, "dcinbr"))
					 ds_bom.setitem(Lrow,  "dcinbr", sNull)
			 End if
			 End if
		 End if 
	 End if
Next

/* 품번별 집계 */
w_mdi_frame.sle_msg.text = '품목별 수량을 집계중입니다'	

if ds_bom.dataobject = "d_pdm_11730_p_single"    or &
	ds_bom.dataobject = "d_pdm_11730_p_single_1"  then
	 ds_bom.setsort("estruc_cinbr A")
Elseif ds_bom.dataobject = "d_pdm_11730_m_single"    or &
	 ds_bom.dataobject = "d_pdm_11730_m_single_1"  then
	 ds_bom.setsort("pstruc_cinbr A")
End if
ds_bom.sort()

Lrow = 0
Do while True
	Lrow++
	If Lrow >= ds_bom.rowcount() Then
		Exit
	End if

	if ds_bom.dataobject = "d_pdm_11730_p_single"    or ds_bom.dataobject = "d_pdm_11730_p_single_1"  then
		
		If ds_bom.getitemstring(Lrow,     "estruc_cinbr") = ds_bom.getitemstring(Lrow + 1, "estruc_cinbr")   Then
			ds_bom.setitem(Lrow + 1, "qtypr", ds_bom.getitemdecimal(Lrow + 1, "qtypr") + ds_bom.getitemdecimal(Lrow, "qtypr"))
			ds_bom.deleterow(Lrow)
			Lrow = Lrow - 1
		End if
		
	Elseif ds_bom.dataobject = "d_pdm_11730_m_single"    or ds_bom.dataobject = "d_pdm_11730_m_single_1"  then
		 
		If ds_bom.getitemstring(Lrow,     "pstruc_cinbr") = ds_bom.getitemstring(Lrow + 1, "pstruc_cinbr")   Then
			ds_bom.setitem(Lrow + 1, "qtypr", ds_bom.getitemdecimal(Lrow + 1, "qtypr")/* + ds_bom.getitemdecimal(Lrow, "qtypr")*/)
			ds_bom.deleterow(Lrow)
			Lrow = Lrow - 1
		End if
		 
	End if

Loop


If rb_1.checked then  //요약표 작성
	For Lrow = 1 to ds_bom.rowcount()
		
		 w_mdi_frame.sle_msg.text = '전체 ( ' + string(ds_bom.rowcount()) + ' ) 현재 ( ' + string(Lrow) + ' ) '	
		 
			 Lrow1 = dw_print.insertrow(0)
			 
			if ds_bom.dataobject = "d_pdm_11730_p_single"    or &
				ds_bom.dataobject = "d_pdm_11730_p_single_1"  then
				dw_print.setitem(Lrow1, "cinbr_no",    ds_bom.getitemstring(Lrow, "estruc_cinbr"))				
			Elseif ds_bom.dataobject = "d_pdm_11730_m_single"    or &
				 ds_bom.dataobject = "d_pdm_11730_m_single_1"  then
				dw_print.setitem(Lrow1, "cinbr_no",    ds_bom.getitemstring(Lrow, "pstruc_cinbr"))				 
			End if
			 
			 dw_print.setitem(Lrow1, "cinbr_itdsc", ds_bom.getitemstring(Lrow, "itdsc"))
			 dw_print.setitem(Lrow1, "cinbr_ispec", ds_bom.getitemstring(Lrow, "ispec"))	 
			 dw_print.setitem(Lrow1, "cinbr_jejos", ds_bom.getitemstring(Lrow, "jejos"))	 
			 dw_print.setitem(Lrow1, "cinbr_gu",    ds_bom.getitemstring(Lrow, "ittyp"))	 
			 dw_print.setitem(Lrow1, "cinbr_qtypr", ds_bom.getitemdecimal(Lrow, "qtypr"))
			 dw_print.setitem(Lrow1, "cinbr_unmsr", ds_bom.getitemstring(Lrow, "unmsr"))	 
			 dw_print.setitem(Lrow1, "startdate",   ds_bom.getitemstring(Lrow, "efrdt"))	 
			 dw_print.setitem(Lrow1, "enddate",     ds_bom.getitemstring(Lrow, "eftdt"))	 	 
			 dw_print.setitem(Lrow1, "pcb1",        ds_bom.getitemstring(Lrow, "pcb_name"))
				 
			 if not isnull( ds_bom.getitemstring(Lrow, "itnbr2") ) Then
				dw_print.setitem(Lrow1, "vendor",      ds_bom.getitemstring(Lrow, "cvcod2"))
				dw_print.setitem(Lrow1, "vendorname",  ds_bom.getitemstring(Lrow, "cvnas2"))
				dw_print.setitem(Lrow1, "cinbr_unprc", ds_bom.getitemdecimal(Lrow, "unprc2"))
				dw_print.setitem(Lrow1, "tuncu",       ds_bom.getitemstring(Lrow, "cunit2"))
			 Elseif not isnull( ds_bom.getitemstring(Lrow, "itnbr3") ) Then
				dw_print.setitem(Lrow1, "vendor",      ds_bom.getitemstring(Lrow, "cvcod3"))
				dw_print.setitem(Lrow1, "vendorname",  ds_bom.getitemstring(Lrow, "cvnas3"))
				dw_print.setitem(Lrow1, "cinbr_unprc", ds_bom.getitemdecimal(Lrow, "unprc3"))
				dw_print.setitem(Lrow1, "tuncu",       ds_bom.getitemstring(Lrow, "cunit3"))
			 Else
				dw_print.setitem(Lrow1, "vendor",      ds_bom.getitemstring(Lrow, "cvcod1"))
				dw_print.setitem(Lrow1, "vendorname",  ds_bom.getitemstring(Lrow, "cvnas1"))
				dw_print.setitem(Lrow1, "cinbr_unprc", ds_bom.getitemdecimal(Lrow, "unprc1"))
				dw_print.setitem(Lrow1, "tuncu",       ds_bom.getitemstring(Lrow, "cunit1"))
			 End if
	
	NExt
End if

return 1
end function

public function integer wf_retrieve ();dw_print.reset()
dw_list.reset()

string   sitcls, sitnbr, eitnbr, sittyp, sDataobject, ls_porgu
string 	sItem,		&
			sName,		&
			sSet,			&
			sStartItem,	&
			sSpec,		&
			sModel,		&
			sModelName,	&
			sUseDate,	&
			sbom1,		&
			sbom2, sstart, sitem1, sname1, sspec1, smodelname1, sset1, schkit
integer  ii			
Decimal  dqty
Long Lrow, Lrow1

// 품목번호
if dw_ip.accepttext() = -1 		then	
	return -1
end if

sittyp = dw_ip.getitemstring(1, "ittyp")
sitcls = dw_ip.getitemstring(1, "fitcls")
sitnbr = dw_ip.getitemstring(1, "fr_itnbr")
eitnbr = dw_ip.getitemstring(1, "to_itnbr")
dqty  = dw_ip.getitemNumber(1, "bqty")
ls_porgu  = dw_ip.getitemString(1, "porgu")

if IsNull(dQty) then dQty = 1

sitem  = sitnbr
sItem1 = eitnbr
Select itdsc, ispec, jijil, unmsr
  into :sname, :sspec, :smodelname, :sset
  from itemas
 Where itnbr = :sitem;
If sqlca.sqlcode <> 0 then
	MEssagebox("품번", "품번이 부정확 합니다", stopsign!)
	return -1
End if

If rb_1.checked then
	If ii_ddlb1 = 0 then
		MEssagebox("자료선택", "출력할 기준을 선택하십시요", stopsign!)
		return -1
	End if		
		
end if

If rb_2.checked then
	Select itdsc, ispec, jijil, unmsr
	  into :sname1, :sspec1, :smodelname1, :sset1
	  from itemas
	 Where itnbr = :sitem1;
	If sqlca.sqlcode <> 0 then
		MEssagebox("품번", "품번이 부정확 합니다", stopsign!)
		return -1
	End if
	
	If ii_ddlb = 0 then
		MEssagebox("비교선택", "비교할 기준을 선택하십시요", stopsign!)
		return -1
	End if		
		
end if

IF trim(dw_ip.getitemstring(1, "bdate")) = ''		or  IsNull(dw_ip.getitemstring(1, "bdate")) THEN
	is_Gubun = 'ALL'
	sUseDate = f_today()
ELSE
	is_Gubun = 'NOTALL'
	sUseDate = trim(dw_ip.getitemstring(1, "bdate"))
END IF

ds_bom = create datastore

if rb_1.checked then  // BOM요약표

	if ii_ddlb1 = 1 then
		if rb_drilldown.checked then
			ds_bom.dataobject   = "d_pdm_11730_p_single"	
		Elseif rb_drillup.checked then
			ds_bom.dataobject   = "d_pdm_11730_p_single_1"		
		End if
	Else
		if rb_drilldown.checked then
			ds_bom.dataobject   = "d_pdm_11730_m_single"	
		Elseif rb_drillup.checked then
			ds_bom.dataobject   = "d_pdm_11730_m_single_1"		
		End if		
	End if
	
	if rb_drilldown.checked then  // 요약
		dw_list.object.cinbr_no_t.text = '하위품번'
		dw_list.object.cinbr_itdsc_t.text = '하위품번'	
	Else
		dw_list.object.cinbr_no_t.text = '상위품번'
		dw_list.object.cinbr_itdsc_t.text = '상위품번'			
	end if	

	ds_bom.settransobject(sqlca)

	if wf_calculation(sitem, dqty, sname, sset, sspec, smodelname, sittyp, susedate) = -1 Then
		dw_print.reset()
	End if
Elseif rb_2.checked then //비교표 (외주비교표 제외)
	If ii_ddlb = 1 or ii_ddlb = 2 or ii_ddlb = 3 or ii_ddlb = 4 then
		if ii_ddlb = 1 or ii_ddlb = 2 then
			if rb_drilldown.checked then
				ds_bom.dataobject   = "d_pdm_11730_p_single"	
				sDataobject         = "d_pdm_11730_p_single"	
			Elseif rb_drillup.checked then
				ds_bom.dataobject   = "d_pdm_11730_p_single_1"		
				sDataobject         = "d_pdm_11730_p_single_1"
			End if
		Elseif ii_ddlb = 3 or ii_ddlb = 4 then
			if rb_drilldown.checked then
				ds_bom.dataobject   = "d_pdm_11730_m_single"	
				sDataobject         = "d_pdm_11730_m_single"	
			Elseif rb_drillup.checked then
				ds_bom.dataobject   = "d_pdm_11730_m_single_1"		
				sDataobject         = "d_pdm_11730_m_single_1"
			End if			
		End if
		ds_bom.settransobject(sqlca)
		
		// 품번1
		if wf_calculation(sitem, dqty, sname, sset, sspec, smodelname, sittyp, susedate) = -1 Then
			dw_print.reset()
		End if
		
	   For Lrow = 1 to ds_bom.rowcount()
			 Lrow1 = dw_print.insertrow(0)
			 if sdataobject = "d_pdm_11730_p_single"    or &
			    sdataobject = "d_pdm_11730_p_single_1"  then
				 dw_print.setitem(Lrow1, "itnbr",  ds_bom.getitemstring(Lrow, "estruc_cinbr"))
			 Elseif sdataobject = "d_pdm_11730_m_single"    or &
			  		  sdataobject = "d_pdm_11730_m_single_1"  then
				 dw_print.setitem(Lrow1, "itnbr",  ds_bom.getitemstring(Lrow, "pstruc_cinbr"))						 
			 End if
			 dw_print.setitem(Lrow1, "itdsc",  ds_bom.getitemstring(Lrow, "itdsc"))
			 dw_print.setitem(Lrow1, "ispec",  ds_bom.getitemstring(Lrow, "ispec"))	 
			 dw_print.setitem(Lrow1, "jijil",  ds_bom.getitemstring(Lrow, "jijil"))	 
			 dw_print.setitem(Lrow1, "ittyp",  ds_bom.getitemstring(Lrow, "ittyp"))	 
			 dw_print.setitem(Lrow1, "unmsr",  ds_bom.getitemstring(Lrow, "unmsr"))	 
			 dw_print.setitem(Lrow1, "qtypr1", ds_bom.getitemdecimal(Lrow, "qtypr"))	 
		Next

		if ii_ddlb = 1 or ii_ddlb = 4 then
			if rb_drilldown.checked then
				ds_bom.dataobject   = "d_pdm_11730_p_single"	
				sDataobject         = "d_pdm_11730_p_single"	
			Elseif rb_drillup.checked then
				ds_bom.dataobject   = "d_pdm_11730_p_single_1"
				sDataobject         = "d_pdm_11730_p_single_1"
			End if
		ElseIf ii_ddlb = 2 or ii_ddlb = 3 then
			if rb_drilldown.checked then
				ds_bom.dataobject   = "d_pdm_11730_m_single"	
				sDataobject         = "d_pdm_11730_m_single"
			Elseif rb_drillup.checked then
				ds_bom.dataobject   = "d_pdm_11730_m_single_1"
				sDataobject         = "d_pdm_11730_m_single_1"
			End if			
		End if
		ds_bom.settransobject(sqlca)		
		
		// 품번2
		if wf_calculation(sitem1, dqty, sname1, sset1, sspec1, smodelname1, sittyp, susedate) = -1 Then
			dw_print.reset()
		End if
		
	   For Lrow = 1 to ds_bom.rowcount()

			 if sdataobject = "d_pdm_11730_p_single"    or &
			    sdataobject = "d_pdm_11730_p_single_1"  then
				 schkit = ds_bom.getitemstring(Lrow, "estruc_cinbr")
			 Elseif sdataobject = "d_pdm_11730_m_single"    or &
				     sdataobject = "d_pdm_11730_m_single_1"  then
				 schkit = ds_bom.getitemstring(Lrow, "pstruc_cinbr")				
			 End if

			 Lrow1 = dw_print.find("itnbr = '"+ schkit +"'", 1, dw_print.rowcount())
			 if Lrow1 < 1 then
				 Lrow1 = dw_print.insertrow(0)
				 dw_print.setitem(Lrow1, "itnbr",  schkit)
				 dw_print.setitem(Lrow1, "itdsc",  ds_bom.getitemstring(Lrow, "itdsc"))
				 dw_print.setitem(Lrow1, "ispec",  ds_bom.getitemstring(Lrow, "ispec"))	 
				 dw_print.setitem(Lrow1, "jijil",  ds_bom.getitemstring(Lrow, "jijil"))	 
				 dw_print.setitem(Lrow1, "ittyp",  ds_bom.getitemstring(Lrow, "ittyp"))	 
				 dw_print.setitem(Lrow1, "unmsr",  ds_bom.getitemstring(Lrow, "unmsr"))	 
				 dw_print.setitem(Lrow1, "qtypr2", ds_bom.getitemdecimal(Lrow, "qtypr"))
			 Else
				 dw_print.setitem(Lrow1, "qtypr2", ds_bom.getitemdecimal(Lrow, "qtypr"))
			 End if
		Next		
		
	End if
end if	

destroy ds_bom

ii = dw_print.ShareData ( dw_list )

w_mdi_frame.sle_msg.text = ''

if rb_2.checked and (ii_ddlb = 1 or ii_ddlb = 2 or ii_ddlb = 3 or ii_ddlb = 4) then
	if ii_ddlb = 1 then
		dw_print.modify("st_level.text = '기술 - 기술'")
	ElseIf ii_ddlb = 2 then
		dw_print.modify("st_level.text = '기술 - 생산'")
	ElseIf ii_ddlb = 3 then
		dw_print.modify("st_level.text = '생산 - 생산'")
	ElseIf ii_ddlb = 4 then
		dw_print.modify("st_level.text = '생산 - 기술'")
	End if
	dw_print.modify("st_date.text = '" + string(susedate, "@@@@.@@.@@")  + "'")		
	dw_print.object.itnbr1_t.text = sitem
	dw_print.object.itnbr2_t.text = sitem1
	
	dw_list.object.itnbr1_t.text = sitem
	dw_list.object.itnbr2_t.text = sitem1	
End if

dw_list.scrolltorow(1)
dw_list.setredraw(true)
setpointer(arrow!)

If dw_list.rowcount() = 0 then
	MEssagebox("출력", "출력할 자료가 없읍니다", stopsign!)	
	return -1
End if
Return 1
end function

on w_pdm_11730.create
int iCurrent
call super::create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cbx_bomend=create cbx_bomend
this.rb_drilldown=create rb_drilldown
this.rb_drillup=create rb_drillup
this.cbx_1=create cbx_1
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.gb_3=create gb_3
this.gb_1=create gb_1
this.gb_4=create gb_4
this.ddlb_2=create ddlb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.cbx_bomend
this.Control[iCurrent+4]=this.rb_drilldown
this.Control[iCurrent+5]=this.rb_drillup
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.ddlb_1
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.gb_3
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_4
this.Control[iCurrent+12]=this.ddlb_2
end on

on w_pdm_11730.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cbx_bomend)
destroy(this.rb_drilldown)
destroy(this.rb_drillup)
destroy(this.cbx_1)
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.ddlb_2)
end on

event open;call super::open;dw_ip.object.t_1.visible = false
dw_ip.object.p_1.visible = false
dw_ip.object.to_itnbr.visible = false
end event

type p_xls from w_standard_print`p_xls within w_pdm_11730
end type

type p_sort from w_standard_print`p_sort within w_pdm_11730
end type

type p_preview from w_standard_print`p_preview within w_pdm_11730
end type

type p_exit from w_standard_print`p_exit within w_pdm_11730
end type

type p_print from w_standard_print`p_print within w_pdm_11730
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11730
end type

event p_retrieve::clicked;
IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)

//dw_list.object.datawindow.print.preview="yes"



	
end event







type st_10 from w_standard_print`st_10 within w_pdm_11730
end type



type dw_print from w_standard_print`dw_print within w_pdm_11730
integer x = 4041
integer y = 188
integer width = 489
integer height = 132
string dataobject = "d_pdm_11730_p"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11730
integer x = 32
integer y = 188
integer width = 3913
integer height = 148
string dataobject = "d_pdm_11730_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string scode

if THIS.GetColumnName() = "fr_itnbr" THEN
	sCode = This.GetText()
	
	IF sCode = '' OR ISNULL(sCode) THEN return 
	
	this.setitem(1, 'to_itnbr', sCode)
END IF	
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sittyp

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

this.accepttext()
if this.GetColumnName() = 'fitcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)

elseif this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.SetItem(1,"to_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
end if	


end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	open(w_itemas_popup2)
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "itnbr", gs_code)
   RETURN 1
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdm_11730
string dataobject = "d_pdm_11730"
end type

type rb_2 from radiobutton within w_pdm_11730
integer x = 315
integer y = 64
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "비교"
end type

event clicked;dw_print.dataobject = "d_pdm_11730_b_10"
dw_list.dataobject  = "d_pdm_11730_b_11"

dw_print.settransobject(sqlca);
dw_list.settransobject(sqlca);


st_1.text = '비교기준'
dw_ip.object.t_1.visible = true
dw_ip.object.p_1.visible = true
dw_ip.object.to_itnbr.visible = true
ddlb_1.visible = true
st_1.visible = true
ddlb_2.visible = false
end event

type rb_1 from radiobutton within w_pdm_11730
integer x = 96
integer y = 64
integer width = 210
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "요약"
boolean checked = true
end type

event clicked;dw_print.dataobject = "d_pdm_11730_p"
dw_list.dataobject  = "d_pdm_11730"

dw_print.settransobject(sqlca);
dw_list.settransobject(sqlca);

st_1.text = '자료기준'
dw_ip.object.t_1.visible = false
dw_ip.object.p_1.visible = false
dw_ip.object.to_itnbr.visible = false
ddlb_1.visible = false
st_1.visible = false
ddlb_2.visible = true
end event

type cbx_bomend from checkbox within w_pdm_11730
integer x = 3502
integer y = 64
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "미완료 포함"
end type

type rb_drilldown from radiobutton within w_pdm_11730
integer x = 727
integer y = 64
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "정전개"
boolean checked = true
end type

event clicked;if rb_1.checked then  // 요약
   dw_list.object.cinbr_no_t.text = '하위품번'
   dw_list.object.cinbr_itdsc_t.text = '하위품번'	
end if
end event

type rb_drillup from radiobutton within w_pdm_11730
integer x = 1006
integer y = 64
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "역전개"
end type

event clicked;if rb_1.checked then  // 요약
   dw_list.object.cinbr_no_t.text = '상위품번'
   dw_list.object.cinbr_itdsc_t.text = '상위품번'	
end if
end event

type cbx_1 from checkbox within w_pdm_11730
integer x = 1371
integer y = 64
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "대체품"
end type

type ddlb_1 from dropdownlistbox within w_pdm_11730
boolean visible = false
integer x = 2368
integer y = 44
integer width = 818
integer height = 452
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean sorted = false
string item[] = {"기술 - 기술BOM","기술 - 생산BOM","생산 - 생산BOM","생산 - 기술BOM",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;ii_ddlb = index
end event

type st_1 from statictext within w_pdm_11730
boolean visible = false
integer x = 2103
integer y = 56
integer width = 251
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "비교기준"
boolean focusrectangle = false
end type

type gb_3 from groupbox within w_pdm_11730
integer x = 50
integer y = 20
integer width = 571
integer height = 136
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "구분"
end type

type gb_1 from groupbox within w_pdm_11730
integer x = 658
integer y = 20
integer width = 667
integer height = 132
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전개방법"
end type

type gb_4 from groupbox within w_pdm_11730
integer x = 1339
integer y = 20
integer width = 370
integer height = 132
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type ddlb_2 from dropdownlistbox within w_pdm_11730
integer x = 2368
integer y = 48
integer width = 818
integer height = 300
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean sorted = false
string item[] = {"기술BOM","생산BOM"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;ii_ddlb1 = index
end event

