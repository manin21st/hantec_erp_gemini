$PBExportHeader$w_pdm_11712_a.srw
$PBExportComments$BOM 기준 제조원가 등록
forward
global type w_pdm_11712_a from w_standard_print
end type
type rb_single from radiobutton within w_pdm_11712_a
end type
type rb_prtgu from radiobutton within w_pdm_11712_a
end type
type cbx_date from checkbox within w_pdm_11712_a
end type
type rb_opseq from radiobutton within w_pdm_11712_a
end type
type rb_usseq from radiobutton within w_pdm_11712_a
end type
type cbx_qty from checkbox within w_pdm_11712_a
end type
type cbx_1 from checkbox within w_pdm_11712_a
end type
type rb_2 from radiobutton within w_pdm_11712_a
end type
type rb_1 from radiobutton within w_pdm_11712_a
end type
type rb_drilldown from radiobutton within w_pdm_11712_a
end type
type rb_drillup from radiobutton within w_pdm_11712_a
end type
type cbx_bomend from checkbox within w_pdm_11712_a
end type
type pb_1 from u_pb_cal within w_pdm_11712_a
end type
type ddlb_1 from dropdownlistbox within w_pdm_11712_a
end type
type dw_1 from datawindow within w_pdm_11712_a
end type
type gb_5 from groupbox within w_pdm_11712_a
end type
type gb_2 from groupbox within w_pdm_11712_a
end type
type gb_3 from groupbox within w_pdm_11712_a
end type
type gb_4 from groupbox within w_pdm_11712_a
end type
type gb_1 from groupbox within w_pdm_11712_a
end type
end forward

global type w_pdm_11712_a from w_standard_print
integer width = 4713
integer height = 3376
string title = "BOM 기준 제조원가 등록"
rb_single rb_single
rb_prtgu rb_prtgu
cbx_date cbx_date
rb_opseq rb_opseq
rb_usseq rb_usseq
cbx_qty cbx_qty
cbx_1 cbx_1
rb_2 rb_2
rb_1 rb_1
rb_drilldown rb_drilldown
rb_drillup rb_drillup
cbx_bomend cbx_bomend
pb_1 pb_1
ddlb_1 ddlb_1
dw_1 dw_1
gb_5 gb_5
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_1 gb_1
end type
global w_pdm_11712_a w_pdm_11712_a

type variables
long    il_row
int       check_box
string  is_Gubun, Isbom
str_itnct lstr_sitnct
datastore ds_bom


end variables

forward prototypes
public function integer wf_calculation (string arg_itnbr, decimal arg_qty, string sname, string sset, string sspec, string smodelname, string sittyp, string susedate)
public function integer wf_retrieve ()
public function integer wf_calculation2 (string arg_itnbr, decimal arg_qty, string sname, string sset, string sspec, string smodelname, string sittyp, string susedate)
end prototypes

public function integer wf_calculation (string arg_itnbr, decimal arg_qty, string sname, string sset, string sspec, string smodelname, string sittyp, string susedate); string 	sItem,		&
			sbom2, slname, sSTART, snewsql, snull, ls_porgu, ls_rfna1, ls_rfna2
			
Decimal  dqty
Long		Lpos, lvlno, imsg, Lrow, Lrow1

SetNull(snull)

//공장 구분 삽입
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
	dw_print.object.t_18.text = '전체'
ElseIf ls_porgu = ls_rfna2 Then
	dw_print.object.t_18.text = ls_rfna1
End If

ds_bom.reset()

// 품목번호
sItem = arg_itnbr
dqty  = arg_qty

If rb_1.checked Then
	ds_bom.modify("st_level.text = '단단계'")
	dw_print.modify("st_level.text = '단단계'")	
Else
	ds_bom.modify("st_level.text = '다단계'")
	dw_print.modify("st_level.text = '다단계'")	
End if

ds_bom.modify("st_date.text = '" + string(susedate, "@@@@.@@.@@")  + "'")
dw_print.modify("st_date.text = '" + string(susedate, "@@@@.@@.@@")  + "'")
////////////////////////////////////////////////////////////////////////////
If rb_1.checked Then
	sstart = sitem
Else
	sstart = '%'
End if

If rb_usseq.checked then
	slname = "usseq"
Else
	slname = "opsno"	
End if

/* Argument 변경 */
if ds_bom.retrieve(arg_itnbr, sstart, ls_porgu) < 1 then return 1

/* 상위기준 품번을 setting */
for Lrow = 1 to ds_bom.rowcount()
	 ds_bom.setitem(Lrow, "pitnbr", arg_itnbr)
	 ds_bom.setitem(Lrow, "pitdsc", sname)
	 ds_bom.setitem(Lrow, "pispec", sspec)
	 ds_bom.setitem(Lrow, "pjijil", smodelname)
	 ds_bom.setitem(Lrow, "punmsr", sset)	 
Next

/* 단단계시 가상품목에 대한 하위품목  검색용 */
long    lastrow, lsec, lsec1, lsec2, lcnt
String  lvlbyo, lvlname
boolean blvlchk
if rb_1.checked then
	datastore ds_dan
	ds_dan = create datastore	
	if rb_drilldown.checked then
		ds_dan.dataobject  = "d_pdm_11712_a_2"	
	elseif rb_drilldown.checked then
		ds_dan.dataobject  = "d_pdm_11712_a_2_1"
	end if
	ds_dan.settransobject(sqlca)	
	
	For lpos = 1 to ds_bom.rowcount()
		 if ds_bom.getitemstring(lpos, "ittyp") <> '8' then
			 continue
		 End if
		 
		 ds_dan.reset()
		 ds_dan.retrieve(ds_bom.getitemstring(lpos, "pstruc_cinbr"), ds_bom.getitemstring(lpos, "pstruc_cinbr"), ls_porgu)
		 For lsec2 = 1 to ds_dan.rowcount()
			  lastrow = ds_bom.insertrow(lpos + 1)
			 ds_bom.setitem(lastrow, "lvlno",   		2)
			 ds_bom.setitem(lastrow, "usseq",   		ds_dan.getitemstring(lsec2, "usseq"))
			 ds_bom.setitem(lastrow, "pstruc_cinbr",  ds_dan.getitemstring(lsec2, "pstruc_cinbr"))
			 ds_bom.setitem(lastrow, "qtypr", 			ds_dan.getitemdecimal(lsec2, "qtypr"))
			 ds_bom.setitem(lastrow, "pcb_name", 	   ds_dan.getitemstring(lsec2, "pcb_name"))
			 ds_bom.setitem(lastrow, "pdtname", 	   ds_dan.getitemstring(lsec2, "pdtname"))
			 ds_bom.setitem(lastrow, "efrdt", 		   ds_dan.getitemstring(lsec2, "efrdt"))
			 ds_bom.setitem(lastrow, "eftdt", 		   ds_dan.getitemstring(lsec2, "eftdt"))
			 ds_bom.setitem(lastrow, "dcinbr",		   ds_dan.getitemstring(lsec2, "dcinbr"))
			 ds_bom.setitem(lastrow, "row_no", 			ds_dan.getitemdecimal(lsec2, "row_no"))	 
			 ds_bom.setitem(lastrow, "itdsc",   		ds_dan.getitemstring(lsec2, "itdsc"))
			 ds_bom.setitem(lastrow, "ispec",   		ds_dan.getitemstring(lsec2, "ispec"))
			 ds_bom.setitem(lastrow, "jijil",   		ds_dan.getitemstring(lsec2, "jijil"))
			 ds_bom.setitem(lastrow, "jejos",   		ds_dan.getitemstring(lsec2, "jejos"))
			 ds_bom.setitem(lastrow, "unmsr",   		ds_dan.getitemstring(lsec2, "unmsr"))
			 ds_bom.setitem(lastrow, "ittyp",   		ds_dan.getitemstring(lsec2, "ittyp"))
			 ds_bom.setitem(lastrow, "ldtim",   		ds_dan.getitemdecimal(lsec2, "ldtim"))
			 ds_bom.setitem(lastrow, "opsno",   		ds_dan.getitemstring(lsec2, "opsno"))		 
			 ds_bom.setitem(lastrow, "sortlevel",     ds_dan.getitemstring(lsec2, "sortlevel"))
			 ds_bom.setitem(lastrow, "mpm",     		ds_dan.getitemstring(lsec2, "mpm"))
			// ds_bom.setitem(lastrow, "cvnas",        ds_dan.getitemstring(lsec2, "cvnas"))
			 
			 
			 ds_bom.setitem(lastrow, "pitnbr", arg_itnbr)
			 ds_bom.setitem(lastrow, "pitdsc", sname)
			 ds_bom.setitem(lastrow, "pispec", sspec)
			 ds_bom.setitem(lastrow, "pjijil", smodelname)
			 ds_bom.setitem(lastrow, "punmsr", sset)
		 Next
	Next
	destroy ds_dan
end if

Decimal {4}  dsaveqty[10], dtempqty, drstqty

If cbx_qty.checked then
	w_mdi_frame.sle_msg.text = '구성수량을 재계산중입니다.'
	For lrow = 1 to ds_bom.rowcount()
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
End if

/* 출력순서 */
lrow = 1
lcnt = ds_bom.rowcount()
If Rb_drilldown.checked then
	do while true
		
		if lrow > ds_bom.rowcount() or lrow > lcnt then exit
		lvlname = ds_bom.getitemstring(lrow, "sortlevel")	
		lvlbyo  = ds_bom.getitemstring(lrow, slname)
		blvlchk = false
		
		For lsec  = lrow + 1 to lcnt 
			 if lvlname < ds_bom.getitemstring(lsec, "sortlevel") then
				 continue
			 End if
			 if lvlname > ds_bom.getitemstring(lsec, "sortlevel") then
				 exit
			 End if				 
			 if lvlbyo  > ds_bom.getitemstring(lsec, slname) then
				 blvlchk = true
				 exit
			 end if		 		
		Next
		
		if blvlchk = false then
			lrow++
			continue
		end if	
	
		For lsec1 = lsec + 1 to lcnt
			 if lvlname < ds_bom.getitemstring(lsec1, "sortlevel") then
				 continue
			 End if
			 if lvlname > ds_bom.getitemstring(lsec1, "sortlevel") then
				 exit
			 End if		 
			 if lvlbyo < ds_bom.getitemstring(lsec1, slname) then
				 exit
			 end if
		Next
	
		lsec2 = lrow
		do while true
			 lastrow = ds_bom.insertrow(lsec1)		 
			 ds_bom.setitem(lastrow, "lvlno",   		ds_bom.getitemdecimal(lsec2, "lvlno"))
			 ds_bom.setitem(lastrow, "usseq",   		ds_bom.getitemstring(lsec2, "usseq"))
			 ds_bom.setitem(lastrow, "pstruc_cinbr", ds_bom.getitemstring(lsec2, "pstruc_cinbr"))
			 ds_bom.setitem(lastrow, "qtypr", 			ds_bom.getitemdecimal(lsec2, "qtypr"))
			 ds_bom.setitem(lastrow, "pcb_name", 	   ds_bom.getitemstring(lsec2, "pcb_name"))
			 ds_bom.setitem(lastrow, "pdtname", 	   ds_bom.getitemstring(lsec2, "pdtname"))
			 ds_bom.setitem(lastrow, "efrdt", 		   ds_bom.getitemstring(lsec2, "efrdt"))
			 ds_bom.setitem(lastrow, "eftdt", 		   ds_bom.getitemstring(lsec2, "eftdt"))
			 ds_bom.setitem(lastrow, "dcinbr",		   ds_bom.getitemstring(lsec2, "dcinbr"))
			 ds_bom.setitem(lastrow, "row_no", 		   ds_bom.getitemdecimal(lsec2, "row_no"))	 
			 ds_bom.setitem(lastrow, "itdsc",   		ds_bom.getitemstring(lsec2, "itdsc"))
			 ds_bom.setitem(lastrow, "ispec",   		ds_bom.getitemstring(lsec2, "ispec"))
			 ds_bom.setitem(lastrow, "jijil",   		ds_bom.getitemstring(lsec2, "jijil"))
			 ds_bom.setitem(lastrow, "jejos",   		ds_bom.getitemstring(lsec2, "jejos"))
			 ds_bom.setitem(lastrow, "unmsr",   		ds_bom.getitemstring(lsec2, "unmsr"))
			 ds_bom.setitem(lastrow, "ittyp",   		ds_bom.getitemstring(lsec2, "ittyp"))
			 ds_bom.setitem(lastrow, "ldtim",   		ds_bom.getitemdecimal(lsec2, "ldtim"))
			 ds_bom.setitem(lastrow, "opsno",   		ds_bom.getitemstring(lsec2, "opsno"))
			 ds_bom.setitem(lastrow, "sortlevel",    ds_bom.getitemstring(lsec2, "sortlevel"))		 
			// ds_bom.setitem(lastrow, "cvnas",        ds_dan.getitemstring(lsec2, "cvnas"))
			 ds_bom.setitem(lastrow, "wkctr",        ds_bom.getitemstring(lsec2, "wkctr"))			 
			 ds_bom.setitem(lastrow, "pitnbr",        ds_bom.getitemstring(lsec2, "pitnbr"))
			 ds_bom.setitem(lastrow, "pitdsc", 			ds_bom.getitemstring(lsec2, "pitdsc"))
			 ds_bom.setitem(lastrow, "pispec", 			ds_bom.getitemstring(lsec2, "pispec"))
			 ds_bom.setitem(lastrow, "pjijil", 			ds_bom.getitemstring(lsec2, "pjijil"))
			 ds_bom.setitem(lastrow, "punmsr", 			ds_bom.getitemstring(lsec2, "punmsr"))
	
			 ds_bom.deleterow(lsec2)
			 if lsec2 > lcnt or &
				 lvlname >= ds_bom.getitemstring(lsec2, "sortlevel") then
				 exit
			 end if
		Loop		
	Loop
End if

/* 유효일자 적용여부 */
for lrow = 1 to ds_bom.rowcount()
	 ds_bom.setitem(lrow, "gidat", susedate)
Next

For lrow = 1 to ds_bom.rowcount()
	 if cbx_date.checked then    // 유효일자 제외인 경우 삭제
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
			 Lrow1 = Lrow - 1
			 if Lrow1 < 1 then exit
			 lvlno = ds_bom.getitemdecimal(lrow1, "lvlno")
			 ds_bom.deleterow(lrow1)
			 Do while true	
				 if lrow1  > ds_bom.rowcount() then exit
				 if lvlno < ds_bom.getitemdecimal(lrow1, "lvlno") then
					 ds_bom.deleterow(lrow1)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
		 End if
	 End if
	 
	 // 정전개인 경우 BOM미완료이면 삭제
	 if 	cbx_bomend.checked = False and rb_drilldown.checked then
		 if 	Lrow <= ds_bom.rowcount() and Lrow > 0  then		
		 if 	ds_bom.getitemstring(lrow, "bomend") = 'N'   Then
			lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
			if	isNull(lvlno) or lvlno = 0	then exit
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
		 if 	ds_bom.getitemstring(lrow, "bomend") = 'N'  Then
			Lrow1 = Lrow - 1
			if Lrow1 < 1 then exit
			lvlno 	= ds_bom.getitemdecimal(lrow1, "lvlno")
			if	lvlno = 0	then exit
			
			ds_bom.deleterow(lrow1)
			Do while true	
				 if 	lrow1  > ds_bom.rowcount() then exit
				 if 	lvlno 	< ds_bom.getitemdecimal(lrow1, "lvlno") then
					ds_bom.deleterow(lrow1)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
		 End if
	 End if

	 
	 // 역전개인 경우 대체품처리시 표시방법 변경
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
Next

/* 자료를 print로 복사한다 */
ds_bom.RowsCopy(1, ds_bom.RowCount(), Primary!, dw_print, dw_print.rowcount() + 1, Primary!)

return 1
end function

public function integer wf_retrieve ();dw_list.reset()

string   sitcls, sitnbr, eitnbr, sittyp, sporgu
string 	sItem,		&
			sName,		&
			sSet,			&
			sStartItem,	&
			sSpec,		&
			sModel,		&
			sModelName,	&
			sUseDate,	&
			sbom1,		&
			sbom2, sstart
integer  ii
Decimal  dqty
Long Lrow, fi

// 품목번호
if dw_ip.accepttext() = -1 		then	
	return -1
end if

sittyp = dw_ip.getitemstring(1, "ittyp")
sitcls = dw_ip.getitemstring(1, "fitcls")
sitnbr = dw_ip.getitemstring(1, "fr_itnbr")
eitnbr = dw_ip.getitemstring(1, "to_itnbr")
sporgu = dw_ip.getItemString(1, "porgu")

dqty  = dw_ip.getitemNumber(1, "bqty")
if IsNull(dQty) then dQty = 0

IF isnull(sitcls)	or		trim(sItcls) = ''	THEN	
	sitcls = '%'
ELSE	
	sitcls = sitcls + '%'
END IF
IF isnull(sitnbr)	or		trim(sItnbr) = ''	THEN	
	sitnbr = '.'
END IF
IF isnull(eitnbr)	or		trim(eItnbr) = ''	THEN	
	eitnbr = 'zzzzzzzzzzzzzzz'
END IF

IF trim(dw_ip.getitemstring(1, "bdate")) = ''		or  IsNull(dw_ip.getitemstring(1, "bdate")) THEN
	is_Gubun = 'ALL'
	sUseDate = f_today()
ELSE
	is_Gubun = 'NOTALL'
	sUseDate = trim(dw_ip.getitemstring(1, "bdate"))
END IF

ds_bom = create datastore

if rb_drilldown.checked then //정전개
	if rb_single.checked then
		//한줄출력
		dw_print.dataobject = "d_pdm_11712_p_single"		
		ds_bom.dataobject   = "d_pdm_11712_p_single"	
	else
		//두줄출력
		dw_print.dataobject = "d_pdm_11712_p_double"
		ds_bom.dataobject   = "d_pdm_11712_p_double"
	end if
Elseif rb_drillup.checked then //역전개
	if rb_single.checked then 
		//한줄출력
		dw_print.dataobject = "d_pdm_11712_p_single_1"		
		ds_bom.dataobject   = "d_pdm_11712_p_single_1"	
	else
		//두줄출력
		dw_print.dataobject = "d_pdm_11712_p_double_1"
		ds_bom.dataobject   = "d_pdm_11712_p_double_1"
	end if	
End if
dw_print.settransobject(sqlca)
ds_bom.settransobject(sqlca)

// ds Data Count용 다른 용도 없음
datastore ds
ds = create datastore
if rb_drilldown.checked then
	ds.dataobject = "d_pdm_11712_3"
elseif rb_drillup.checked then
	ds.dataobject = "d_pdm_11712_3_1"	
End if
ds.settransobject(sqlca)


Lrow = ds.retrieve(sittyp, sitcls, sitnbr, eitnbr, sporgu)

If Lrow > 10 then
	If MessageBox("BOM", "출력하려는 품목건수가 " + string(Lrow) + " 입니다" + '~n' + &
							   "출력하시겠습니까?", question!, yesno!) = 2 then
		Return -1
	End if
Elseif Lrow = 0 then
	MessageBox("BOM","출력할 자료가 없습니다", stopsign!)
	return -1
End if

dw_list.reset()
For Lrow = 1 to ds.rowcount()
	
	 w_mdi_frame.sle_msg.text = '검색중 총건수('+string(ds.rowcount())+') : 현재건수('+string(Lrow)+')'
	
	 sitem  = ds.getitemstring(Lrow, "itnbr")
	 sname  = ds.getitemstring(Lrow, "itdsc")
	 smodelname = ds.getitemstring(Lrow, "jijil")
	 sspec = ds.getitemstring(Lrow, "ispec")	 
	 sset  = ds.getitemstring(Lrow, "unmsr")

//현재 여기 진행     품번 기준수량, 품명 관리단위 규격 재질       품목구분 기준일자
	if wf_calculation(sitem, dqty, sname, sset, sspec, smodelname, sittyp, susedate) = -1 then
		exit
	end if	

Next
destroy ds

destroy ds_bom

if dw_print.RowCount() = 0 Then
//	dw_list.setredraw(true)
	f_message_chk(50," 생산BOM-정전개/역전개 ")
	Return -1
End If

ii = dw_print.ShareData ( dw_list )

///////////////////////////////////////
string	  sitnam,sPinbr,sOldPinbr, sPcbGub
string   sroutng
string   suseyn
integer sRow, eRow, iMpm
For Lrow = 1 to dw_print.rowcount()
	sitem  = dw_print.getitemstring(Lrow, "pstruc_cinbr")
	
	select mpm
	  into :iMpm
	  from pstruc
	 where cinbr = :sitem;
	dw_print.setitem(Lrow, 'mpm', iMpm)
	
	select decode(itgu,'1','내자외주','2','내자구매','3','외자외주','4','외자구매','5','내작','6','외작','')
	   into :sitnam
	  from itemas
	 where itnbr = :sitem ;
	 
	dw_print.setitem(Lrow,'pcb_name',sitnam)
	
	SELECT CASE WHEN COUNT('X') < 1 THEN '무' ELSE '유' END
	  INTO :sroutng
     FROM ROUTNG
    WHERE ITNBR = :sitem ;
	 
	dw_print.setitem(Lrow,'jejos',sroutng)
	
//	If rb_drillup.Checked = True Then
		SELECT DECODE(USEYN, '0', '사용', NULL)
		  INTO :suseyn
        FROM ITEMAS
		 WHERE ITNBR = :sitem ;
		
		dw_print.setitem(Lrow,'gubun',suseyn)
//	End If
	
	sPinbr = dw_print.getitemstring(Lrow, "pitnbr_1")
	If Lrow = 1 Then
		sOldPinbr = dw_print.getitemstring(Lrow, "pitnbr_1")
		sRow = Lrow
	    sPcbGub = sroutng
	End if
	
	// 유로 바뀌는 시점
	If sPcbGub = '무' and sPcbGub <> sroutng and sPinbr = sOldPinbr Then
	    sPcbGub = sroutng
	End if
	
	eRow = Lrow
	
	If sPinbr <> sOldPinbr Then
			For fi = sRow to eRow - 1
				If sPcbGub = '유' Then
					dw_print.setitem(fi,'pcb_gbn','생산')
				Else 
					dw_print.setitem(fi,'pcb_gbn','외주')
				End if
			NEXT
			
		sOldPinbr = sPinbr
		sRow = Lrow
		sPcbGub = sroutng
	End if
	
	//제일 마직막 품번 처리
	If Lrow =  dw_print.rowcount() Then
		For fi = sRow to Lrow
			If sPcbGub = '유' Then
				dw_print.setitem(fi,'pcb_gbn','생산')
			Else 
				dw_print.setitem(fi,'pcb_gbn','외주')
			End if
		NEXT
	End if
NEXT


///////////////////////////////////////
DataWindowChild state_child

integer rtncode

rtncode = dw_print.GetChild('ittyp', state_child)
state_child.SetTransObject(SQLCA)
state_child.Retrieve()


w_mdi_frame.sle_msg.text = ''

dw_list.scrolltorow(1)
dw_list.setredraw(true)
setpointer(arrow!)

Return 1
end function

public function integer wf_calculation2 (string arg_itnbr, decimal arg_qty, string sname, string sset, string sspec, string smodelname, string sittyp, string susedate); string 	sItem,		&
			sbom2, slname, sSTART, snewsql, snull, ls_porgu, ls_rfna1, ls_rfna2
			
Decimal  dqty
Long		Lpos, lvlno, imsg, Lrow, Lrow1

SetNull(snull)

//공장 구분 삽입
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
	dw_print.object.t_18.text = '전체'
ElseIf ls_porgu = ls_rfna2 Then
	dw_print.object.t_18.text = ls_rfna1
End If

ds_bom.reset()

// 품목번호
sItem = arg_itnbr
dqty  = arg_qty

If rb_1.checked Then
	ds_bom.modify("st_level.text = '단단계'")
	dw_print.modify("st_level.text = '단단계'")	
Else
	ds_bom.modify("st_level.text = '다단계'")
	dw_print.modify("st_level.text = '다단계'")	
End if

ds_bom.modify("st_date.text = '" + string(susedate, "@@@@.@@.@@")  + "'")
dw_print.modify("st_date.text = '" + string(susedate, "@@@@.@@.@@")  + "'")
////////////////////////////////////////////////////////////////////////////
If rb_1.checked Then
	sstart = sitem
Else
	sstart = '%'
End if

If rb_usseq.checked then
	slname = "usseq"
Else
	slname = "opsno"	
End if

/* Argument 변경 */
if ds_bom.retrieve(arg_itnbr, sstart, ls_porgu) < 1 then return 1

/* 상위기준 품번을 setting */
for Lrow = 1 to ds_bom.rowcount()
	 ds_bom.setitem(Lrow, "pitnbr", arg_itnbr)
	 ds_bom.setitem(Lrow, "pitdsc", sname)
	 ds_bom.setitem(Lrow, "pispec", sspec)
	 ds_bom.setitem(Lrow, "pjijil", smodelname)
	 ds_bom.setitem(Lrow, "punmsr", sset)	 
Next

/* 단단계시 가상품목에 대한 하위품목  검색용 */
long    lastrow, lsec, lsec1, lsec2, lcnt
String  lvlbyo, lvlname
boolean blvlchk
if rb_1.checked then
	datastore ds_dan
	ds_dan = create datastore	
	if rb_drilldown.checked then
		ds_dan.dataobject  = "d_pdm_11712_a_2"	
	elseif rb_drilldown.checked then
		ds_dan.dataobject  = "d_pdm_11712_a_2_1"
	end if
	ds_dan.settransobject(sqlca)	
	
	For lpos = 1 to ds_bom.rowcount()
		 if ds_bom.getitemstring(lpos, "ittyp") <> '8' then
			 continue
		 End if
		 
		 ds_dan.reset()
		 ds_dan.retrieve(ds_bom.getitemstring(lpos, "pstruc_cinbr"), ds_bom.getitemstring(lpos, "pstruc_cinbr"), ls_porgu)
		 For lsec2 = 1 to ds_dan.rowcount()
			  lastrow = ds_bom.insertrow(lpos + 1)
			 ds_bom.setitem(lastrow, "lvlno",   		2)
			 ds_bom.setitem(lastrow, "usseq",   		ds_dan.getitemstring(lsec2, "usseq"))
			 ds_bom.setitem(lastrow, "pstruc_cinbr",  ds_dan.getitemstring(lsec2, "pstruc_cinbr"))
			 ds_bom.setitem(lastrow, "qtypr", 			ds_dan.getitemdecimal(lsec2, "qtypr"))
			 ds_bom.setitem(lastrow, "pcb_name", 	   ds_dan.getitemstring(lsec2, "pcb_name"))
			 ds_bom.setitem(lastrow, "pdtname", 	   ds_dan.getitemstring(lsec2, "pdtname"))
			 ds_bom.setitem(lastrow, "efrdt", 		   ds_dan.getitemstring(lsec2, "efrdt"))
			 ds_bom.setitem(lastrow, "eftdt", 		   ds_dan.getitemstring(lsec2, "eftdt"))
			 ds_bom.setitem(lastrow, "dcinbr",		   ds_dan.getitemstring(lsec2, "dcinbr"))
			 ds_bom.setitem(lastrow, "row_no", 			ds_dan.getitemdecimal(lsec2, "row_no"))	 
			 ds_bom.setitem(lastrow, "itdsc",   		ds_dan.getitemstring(lsec2, "itdsc"))
			 ds_bom.setitem(lastrow, "ispec",   		ds_dan.getitemstring(lsec2, "ispec"))
			 ds_bom.setitem(lastrow, "jijil",   		ds_dan.getitemstring(lsec2, "jijil"))
			 ds_bom.setitem(lastrow, "jejos",   		ds_dan.getitemstring(lsec2, "jejos"))
			 ds_bom.setitem(lastrow, "unmsr",   		ds_dan.getitemstring(lsec2, "unmsr"))
			 ds_bom.setitem(lastrow, "ittyp",   		ds_dan.getitemstring(lsec2, "ittyp"))
			 ds_bom.setitem(lastrow, "ldtim",   		ds_dan.getitemdecimal(lsec2, "ldtim"))
			 ds_bom.setitem(lastrow, "opsno",   		ds_dan.getitemstring(lsec2, "opsno"))		 
			 ds_bom.setitem(lastrow, "sortlevel",     ds_dan.getitemstring(lsec2, "sortlevel"))
			 ds_bom.setitem(lastrow, "mpm",     		ds_dan.getitemstring(lsec2, "mpm"))
			// ds_bom.setitem(lastrow, "cvnas",        ds_dan.getitemstring(lsec2, "cvnas"))
			 
			 
			 ds_bom.setitem(lastrow, "pitnbr", arg_itnbr)
			 ds_bom.setitem(lastrow, "pitdsc", sname)
			 ds_bom.setitem(lastrow, "pispec", sspec)
			 ds_bom.setitem(lastrow, "pjijil", smodelname)
			 ds_bom.setitem(lastrow, "punmsr", sset)
		 Next
	Next
	destroy ds_dan
end if

Decimal {4}  dsaveqty[10], dtempqty, drstqty

If cbx_qty.checked then
	w_mdi_frame.sle_msg.text = '구성수량을 재계산중입니다.'
	For lrow = 1 to ds_bom.rowcount()
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
End if

/* 출력순서 */
lrow = 1
lcnt = ds_bom.rowcount()
If Rb_drilldown.checked then
	do while true
		
		if lrow > ds_bom.rowcount() or lrow > lcnt then exit
		lvlname = ds_bom.getitemstring(lrow, "sortlevel")	
		lvlbyo  = ds_bom.getitemstring(lrow, slname)
		blvlchk = false
		
		For lsec  = lrow + 1 to lcnt 
			 if lvlname < ds_bom.getitemstring(lsec, "sortlevel") then
				 continue
			 End if
			 if lvlname > ds_bom.getitemstring(lsec, "sortlevel") then
				 exit
			 End if				 
			 if lvlbyo  > ds_bom.getitemstring(lsec, slname) then
				 blvlchk = true
				 exit
			 end if		 		
		Next
		
		if blvlchk = false then
			lrow++
			continue
		end if	
	
		For lsec1 = lsec + 1 to lcnt
			 if lvlname < ds_bom.getitemstring(lsec1, "sortlevel") then
				 continue
			 End if
			 if lvlname > ds_bom.getitemstring(lsec1, "sortlevel") then
				 exit
			 End if		 
			 if lvlbyo < ds_bom.getitemstring(lsec1, slname) then
				 exit
			 end if
		Next
	
		lsec2 = lrow
		do while true
			 lastrow = ds_bom.insertrow(lsec1)		 
			 ds_bom.setitem(lastrow, "lvlno",   		ds_bom.getitemdecimal(lsec2, "lvlno"))
			 ds_bom.setitem(lastrow, "usseq",   		ds_bom.getitemstring(lsec2, "usseq"))
			 ds_bom.setitem(lastrow, "pstruc_cinbr", ds_bom.getitemstring(lsec2, "pstruc_cinbr"))
			 ds_bom.setitem(lastrow, "qtypr", 			ds_bom.getitemdecimal(lsec2, "qtypr"))
			 ds_bom.setitem(lastrow, "pcb_name", 	   ds_bom.getitemstring(lsec2, "pcb_name"))
			 ds_bom.setitem(lastrow, "pdtname", 	   ds_bom.getitemstring(lsec2, "pdtname"))
			 ds_bom.setitem(lastrow, "efrdt", 		   ds_bom.getitemstring(lsec2, "efrdt"))
			 ds_bom.setitem(lastrow, "eftdt", 		   ds_bom.getitemstring(lsec2, "eftdt"))
			 ds_bom.setitem(lastrow, "dcinbr",		   ds_bom.getitemstring(lsec2, "dcinbr"))
			 ds_bom.setitem(lastrow, "row_no", 		   ds_bom.getitemdecimal(lsec2, "row_no"))	 
			 ds_bom.setitem(lastrow, "itdsc",   		ds_bom.getitemstring(lsec2, "itdsc"))
			 ds_bom.setitem(lastrow, "ispec",   		ds_bom.getitemstring(lsec2, "ispec"))
			 ds_bom.setitem(lastrow, "jijil",   		ds_bom.getitemstring(lsec2, "jijil"))
			 ds_bom.setitem(lastrow, "jejos",   		ds_bom.getitemstring(lsec2, "jejos"))
			 ds_bom.setitem(lastrow, "unmsr",   		ds_bom.getitemstring(lsec2, "unmsr"))
			 ds_bom.setitem(lastrow, "ittyp",   		ds_bom.getitemstring(lsec2, "ittyp"))
			 ds_bom.setitem(lastrow, "ldtim",   		ds_bom.getitemdecimal(lsec2, "ldtim"))
			 ds_bom.setitem(lastrow, "opsno",   		ds_bom.getitemstring(lsec2, "opsno"))
			 ds_bom.setitem(lastrow, "sortlevel",    ds_bom.getitemstring(lsec2, "sortlevel"))
			 ds_bom.setitem(lastrow, "mpm",    			ds_bom.getitemstring(lsec2, "mpm"))
			// ds_bom.setitem(lastrow, "cvnas",        ds_dan.getitemstring(lsec2, "cvnas"))
			 
			 ds_bom.setitem(lastrow, "pitnbr",        ds_bom.getitemstring(lsec2, "pitnbr"))
			 ds_bom.setitem(lastrow, "pitdsc", 			ds_bom.getitemstring(lsec2, "pitdsc"))
			 ds_bom.setitem(lastrow, "pispec", 			ds_bom.getitemstring(lsec2, "pispec"))
			 ds_bom.setitem(lastrow, "pjijil", 			ds_bom.getitemstring(lsec2, "pjijil"))
			 ds_bom.setitem(lastrow, "punmsr", 			ds_bom.getitemstring(lsec2, "punmsr"))			 
	
			 ds_bom.deleterow(lsec2)
			 if lsec2 > lcnt or &
				 lvlname >= ds_bom.getitemstring(lsec2, "sortlevel") then
				 exit
			 end if
		Loop		
	Loop
End if

/* 유효일자 적용여부 */
for lrow = 1 to ds_bom.rowcount()
	 ds_bom.setitem(lrow, "gidat", susedate)
Next

For lrow = 1 to ds_bom.rowcount()
	 if cbx_date.checked then    // 유효일자 제외인 경우 삭제
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
			 Lrow1 = Lrow - 1
			 if Lrow1 < 1 then exit
			 lvlno = ds_bom.getitemdecimal(lrow1, "lvlno")
			 ds_bom.deleterow(lrow1)
			 Do while true	
				 if lrow1  > ds_bom.rowcount() then exit
				 if lvlno < ds_bom.getitemdecimal(lrow1, "lvlno") then
					 ds_bom.deleterow(lrow1)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
		 End if
	 End if
	 
	 // 정전개인 경우 BOM미완료이면 삭제
	 if 	cbx_bomend.checked = False and rb_drilldown.checked then
		 if 	Lrow <= ds_bom.rowcount() and Lrow > 0  then		
		 if 	ds_bom.getitemstring(lrow, "bomend") = 'N'   Then
			lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
			if	isNull(lvlno) or lvlno = 0	then exit
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
		 if 	ds_bom.getitemstring(lrow, "bomend") = 'N'  Then
			Lrow1 = Lrow - 1
			if Lrow1 < 1 then exit
			lvlno 	= ds_bom.getitemdecimal(lrow1, "lvlno")
			if	lvlno = 0	then exit
			
			ds_bom.deleterow(lrow1)
			Do while true	
				 if 	lrow1  > ds_bom.rowcount() then exit
				 if 	lvlno 	< ds_bom.getitemdecimal(lrow1, "lvlno") then
					ds_bom.deleterow(lrow1)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
		 End if
	 End if

	 
	 // 역전개인 경우 대체품처리시 표시방법 변경
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
Next

/* 자료를 print로 복사한다 */
ds_bom.RowsCopy(1, ds_bom.RowCount(), Primary!, dw_print, dw_print.rowcount() + 1, Primary!)

return 1
end function

on w_pdm_11712_a.create
int iCurrent
call super::create
this.rb_single=create rb_single
this.rb_prtgu=create rb_prtgu
this.cbx_date=create cbx_date
this.rb_opseq=create rb_opseq
this.rb_usseq=create rb_usseq
this.cbx_qty=create cbx_qty
this.cbx_1=create cbx_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.rb_drilldown=create rb_drilldown
this.rb_drillup=create rb_drillup
this.cbx_bomend=create cbx_bomend
this.pb_1=create pb_1
this.ddlb_1=create ddlb_1
this.dw_1=create dw_1
this.gb_5=create gb_5
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_single
this.Control[iCurrent+2]=this.rb_prtgu
this.Control[iCurrent+3]=this.cbx_date
this.Control[iCurrent+4]=this.rb_opseq
this.Control[iCurrent+5]=this.rb_usseq
this.Control[iCurrent+6]=this.cbx_qty
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.rb_drilldown
this.Control[iCurrent+11]=this.rb_drillup
this.Control[iCurrent+12]=this.cbx_bomend
this.Control[iCurrent+13]=this.pb_1
this.Control[iCurrent+14]=this.ddlb_1
this.Control[iCurrent+15]=this.dw_1
this.Control[iCurrent+16]=this.gb_5
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_3
this.Control[iCurrent+19]=this.gb_4
this.Control[iCurrent+20]=this.gb_1
end on

on w_pdm_11712_a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_single)
destroy(this.rb_prtgu)
destroy(this.cbx_date)
destroy(this.rb_opseq)
destroy(this.rb_usseq)
destroy(this.cbx_qty)
destroy(this.cbx_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.rb_drilldown)
destroy(this.rb_drillup)
destroy(this.cbx_bomend)
destroy(this.pb_1)
destroy(this.ddlb_1)
destroy(this.dw_1)
destroy(this.gb_5)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'porgu')

ddlb_1.Text = '전체'

dw_1.Insertrow(0)
end event

type p_xls from w_standard_print`p_xls within w_pdm_11712_a
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//
If this.Enabled Then wf_excel_down(dw_list)
end event

type p_sort from w_standard_print`p_sort within w_pdm_11712_a
integer x = 4261
integer y = 572
boolean enabled = false
end type

type p_preview from w_standard_print`p_preview within w_pdm_11712_a
end type

type p_exit from w_standard_print`p_exit within w_pdm_11712_a
end type

type p_print from w_standard_print`p_print within w_pdm_11712_a
boolean visible = false
integer x = 4434
integer y = 572
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11712_a
end type

event p_retrieve::clicked;
IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
	
	If ddlb_1.Text = "생산"  Then		
		dw_print.SetFilter("pcb_gbn='생산'")
		dw_print.Filter()
		dw_list.SetFilter("pcb_gbn='생산'")
		dw_list.Filter()
	Elseif  ddlb_1.Text = "외주" Then
		dw_print.SetFilter("pcb_gbn='외주'")
		dw_print.Filter()
		dw_list.SetFilter("pcb_gbn='외주'")
		dw_list.Filter()
	Else
		dw_print.SetFilter("")
		dw_print.Filter()
		dw_list.SetFilter("")
		dw_list.Filter()
	End if
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)

//dw_list.object.datawindow.print.preview="yes"



	
end event







type st_10 from w_standard_print`st_10 within w_pdm_11712_a
end type



type dw_print from w_standard_print`dw_print within w_pdm_11712_a
integer x = 219
integer y = 936
integer width = 4366
integer height = 724
string dataobject = "d_pdm_11712_p_single"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11712_a
integer x = 32
integer y = 188
integer width = 4594
integer height = 148
string dataobject = "d_pdm_11712_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string scode, sittyp

if THIS.GetColumnName() = "fr_itnbr" THEN
	sCode = This.GetText()
	
	IF sCode = '' OR ISNULL(sCode) THEN return 
	
	select ittyp into :sittyp from itemas where itnbr = :sCode;
	this.SetItem(1,"ittyp",sittyp)
	
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
	gs_gubun = GetItemString(1, 'ittyp')
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.SetItem(1,"to_itnbr",gs_code)
	
	select ittyp into :sittyp from itemas where itnbr = :gs_code;
	this.SetItem(1,"ittyp",sittyp)
elseif this.GetColumnName() = 'to_itnbr' then
	gs_gubun = GetItemString(1, 'ittyp')
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

type dw_list from w_standard_print`dw_list within w_pdm_11712_a
integer x = 27
integer y = 580
integer height = 1736
string dataobject = "d_pdm_11712_a_2"
end type

event dw_list::clicked;call super::clicked;if row > 0 then
	if dw_list.getitemstring(row, "gidat") < dw_list.getitemstring(row, "efrdt") or &
		dw_list.getitemstring(row, "gidat") > dw_list.getitemstring(row, "eftdt") then
		Messagebox("일자", "유효기간경과") 
	end if
	
	String sItnbr, sItdsc, sIspec, sItgu, sCinbr , sPbom
	
	String Spinbr , sPispec , sPitdsc, sWkctr
	
	Integer Ilvel
	
	sItnbr = dw_ip.getitemstring(1,'fr_itnbr')
	sCinbr = this.getitemstring(row,'pstruc_cinbr')
	
		select a.pinbr
		into :Spinbr
		from (
				  Select level as lvlno, pinbr as pinbr, cinbr as cinbr
				  from pstruc
				  connect by prior cinbr = pinbr
				  start with pinbr = :sItnbr
				  ) a
		where a.cinbr = :sCinbr;
		  
		 dw_1.setitem(1,'itnbr',Spinbr)
		 
		 select itdsc,
				ispec,
				itgu
		into   :sPitdsc,
				  :sPispec,
				  :sItgu
		from itemas
		where itnbr = :Spinbr;
		 
		  dw_1.setitem(1,'itdsc',sPitdsc)
		 dw_1.setitem(1,'ispec',sPispec)
		 dw_1.setitem(1,'itgu',sItgu)
		 
		 select wkctr
		 into :sWkctr
		from routng
		where itnbr = :Spinbr;

      dw_1.setitem(1,'routng_wkctr',sWkctr)
 
 		SELECT CASE WHEN COUNT('X') < 1 THEN '무' ELSE '유' END
		 into :sPbom
		 FROM ROUTNG
		WHERE ITNBR = :Spinbr;
		
		 dw_1.setitem(1,'bom',sPbom)
	
end if
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;String sItnbr, sItdsc, sIspec, sItgu, sCinbr , sPbom
	
	String Spinbr , sPispec , sPitdsc, sWkctr, sIttyp , sUpd_date
	Decimal	dWonfac
	Integer Ilvel
	
	sItnbr = dw_ip.getitemstring(1,'fr_itnbr')
	sCinbr = this.getitemstring(currentrow,'pstruc_cinbr')
	
		select a.pinbr
		into :Spinbr
		from (
				  Select level as lvlno, pinbr as pinbr, cinbr as cinbr
				  from pstruc
				  connect by prior cinbr = pinbr
				  start with pinbr = :sItnbr
				  ) a
		where a.cinbr = :sCinbr;
		  
		dw_1.setitem(1,'itnbr',Spinbr)
		 
		select itdsc,
				 ispec,
				 ittyp,
				 itgu,
				 wonfac
		into   :sPitdsc,
				 :sPispec,
				 :sIttyp,
				 :sItgu,
				 :dWonfac
		from itemas
		where itnbr = :Spinbr;
		 
		SELECT UPD_DATE
		   INTO :sUpd_date
	       FROM PSTRUC
		WHERE PINBR = :Spinbr
		    AND CINBR = :sCinbr;
		 
		dw_1.setitem(1,'itdsc',sPitdsc)
		dw_1.setitem(1,'ispec',sPispec)
		dw_1.setitem(1,'itgu',sItgu)
		dw_1.setitem(1,'wonfac',dWonfac)
		dw_1.setitem(1,'upd_date',sUpd_date)
		
		/* 2018-12-17 제조원가 추가소스 */
		if sIttyp <> '1' then
			select distinct mpm
			into :dWonfac
			from pstruc
			where cinbr = :Spinbr;
			
			dw_1.setitem(1,'wonfac',dWonfac)
		end if
		 
		select wkctr
		into :sWkctr
		from routng
		where itnbr = :Spinbr;

      dw_1.setitem(1,'routng_wkctr',sWkctr)
 
 		SELECT CASE WHEN COUNT('X') < 1 THEN '무' ELSE '유' END
		  into :sPbom
		  FROM ROUTNG
		 WHERE ITNBR = :Spinbr;
		
		dw_1.setitem(1,'bom',sPbom)
end event

type rb_single from radiobutton within w_pdm_11712_a
integer x = 2341
integer y = 72
integer width = 219
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
string text = "한줄"
boolean checked = true
end type

type rb_prtgu from radiobutton within w_pdm_11712_a
integer x = 2565
integer y = 72
integer width = 219
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
string text = "두줄"
end type

type cbx_date from checkbox within w_pdm_11712_a
integer x = 727
integer y = 72
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "유효일자적용"
end type

type rb_opseq from radiobutton within w_pdm_11712_a
integer x = 2043
integer y = 72
integer width = 206
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
string text = "공정"
end type

type rb_usseq from radiobutton within w_pdm_11712_a
integer x = 1810
integer y = 72
integer width = 206
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
string text = "번호"
boolean checked = true
end type

type cbx_qty from checkbox within w_pdm_11712_a
integer x = 361
integer y = 72
integer width = 334
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "수량계산"
end type

type cbx_1 from checkbox within w_pdm_11712_a
integer x = 73
integer y = 72
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

type rb_2 from radiobutton within w_pdm_11712_a
integer x = 1490
integer y = 72
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
string text = "다단계"
boolean checked = true
end type

event clicked;dw_list.modify("st_level.text = '다단계'") 
end event

type rb_1 from radiobutton within w_pdm_11712_a
integer x = 1221
integer y = 72
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
string text = "단단계"
end type

event clicked;dw_list.modify("st_level.text = '단단계'") 
end event

type rb_drilldown from radiobutton within w_pdm_11712_a
integer x = 2866
integer y = 72
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

event clicked;dw_list.dataobject = 'd_pdm_11712_a_2'
dw_list.settransobject(sqlca)
end event

type rb_drillup from radiobutton within w_pdm_11712_a
integer x = 3159
integer y = 72
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

event clicked;dw_list.dataobject = 'd_pdm_11712_a_2_1'
dw_list.settransobject(sqlca)

dw_1.setredraw(false)

if rb_drillup.checked then
	
	dw_1.reset()
	
	dw_1.insertrow(0) 
	
	dw_1.setredraw(true)

end if
end event

type cbx_bomend from checkbox within w_pdm_11712_a
integer x = 3502
integer y = 28
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

type pb_1 from u_pb_cal within w_pdm_11712_a
integer x = 3945
integer y = 208
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('bdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'bdate', gs_code)

end event

type ddlb_1 from dropdownlistbox within w_pdm_11712_a
integer x = 3506
integer y = 96
integer width = 338
integer height = 248
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
string item[] = {"전체","생산","외주"}
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_pdm_11712_a
integer x = 32
integer y = 320
integer width = 4594
integer height = 260
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_11712_a_1_1"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;IF dwo.name = "b_1" THEN
	string		ls_wan

	ls_wan = Trim(this.GetItemString(1, 'itnbr'))
	If IsNull(ls_wan) Or ls_wan = '' Then
		MessageBox('확인','상위품번을 지정해야 검색이 가능합니다!')
		Return
	End If
	
	gs_code = ls_wan
	OPEN(w_pdm_11712_pop)
	If IsNull(gs_code) Or gs_code = '' Then Return
	
//	this.SetItem(1,'itnbr', gs_code)
	p_retrieve.TriggerEvent(Clicked!)

END IF
end event

type gb_5 from groupbox within w_pdm_11712_a
integer x = 2304
integer y = 28
integer width = 498
integer height = 132
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "출력"
end type

type gb_2 from groupbox within w_pdm_11712_a
integer x = 1774
integer y = 28
integer width = 521
integer height = 132
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "순서"
end type

type gb_3 from groupbox within w_pdm_11712_a
integer x = 1193
integer y = 24
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
end type

type gb_4 from groupbox within w_pdm_11712_a
integer x = 46
integer y = 24
integer width = 1138
integer height = 136
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type gb_1 from groupbox within w_pdm_11712_a
integer x = 2811
integer y = 28
integer width = 667
integer height = 132
integer taborder = 20
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

