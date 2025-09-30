$PBExportHeader$w_pdm_t_10030.srw
$PBExportComments$콤파운드 처방표
forward
global type w_pdm_t_10030 from w_standard_print
end type
type rb_single from radiobutton within w_pdm_t_10030
end type
type rb_prtgu from radiobutton within w_pdm_t_10030
end type
type cbx_date from checkbox within w_pdm_t_10030
end type
type rb_opseq from radiobutton within w_pdm_t_10030
end type
type rb_usseq from radiobutton within w_pdm_t_10030
end type
type cbx_qty from checkbox within w_pdm_t_10030
end type
type cbx_1 from checkbox within w_pdm_t_10030
end type
type rb_2 from radiobutton within w_pdm_t_10030
end type
type rb_1 from radiobutton within w_pdm_t_10030
end type
type rb_drilldown from radiobutton within w_pdm_t_10030
end type
type rb_drillup from radiobutton within w_pdm_t_10030
end type
type cbx_bomend from checkbox within w_pdm_t_10030
end type
type pb_1 from u_pb_cal within w_pdm_t_10030
end type
type pb_2 from u_pb_cal within w_pdm_t_10030
end type
type gb_5 from groupbox within w_pdm_t_10030
end type
type gb_2 from groupbox within w_pdm_t_10030
end type
type gb_3 from groupbox within w_pdm_t_10030
end type
type gb_4 from groupbox within w_pdm_t_10030
end type
type gb_1 from groupbox within w_pdm_t_10030
end type
end forward

global type w_pdm_t_10030 from w_standard_print
string title = "콤파운드 처방표"
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
pb_2 pb_2
gb_5 gb_5
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_1 gb_1
end type
global w_pdm_t_10030 w_pdm_t_10030

type variables
//long    il_row
//int       check_box
//string  is_Gubun, Isbom
str_itnct lstr_sitnct
//datastore ds_bom


end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_calculation (string arg_itnbr, decimal arg_qty, string sname, string sset, string sspec, string smodelname, string sittyp, string sfrom_date, string sto_date)
end prototypes

public function integer wf_retrieve ();string ls_from_date,ls_to_date,ls_itnbr,ls_porgu,ls_gubun,ls_bomend
string ls_rfna1,ls_rfna2
int li_num

dw_ip.AcceptText()

//ls_porgu = dw_ip.getItemString(1, "porgu")
ls_itnbr = dw_ip.getitemstring(1, "itnbr")
ls_from_date = dw_ip.getitemstring(1, "from_date")
ls_to_date = dw_ip.getitemstring(1, "to_date")

//공장 구분 삽입
//SELECT "REFFPF"."RFNA1"  ,
//       "REFFPF"."RFGUB"
//Into :ls_rfna1, :ls_rfna2
//FROM "REFFPF"  
//WHERE ( "REFFPF"."SABU" = '1' ) AND  
//      ( "REFFPF"."RFCOD" = 'AD' ) AND  
//     ( "REFFPF"."RFGUB" NOT IN ('00','99') )
//AND "REFFPF"."RFGUB" = :ls_porgu;

if dw_ip.accepttext() = -1 		then	
	return -1
end if

IF ls_itnbr = '' OR ISNULL(ls_itnbr) THEN 
	f_message_chk(30,'[ 품번 ]')
	dw_ip.setFocus()
	dw_ip.setColumn('itnbr')
	return 1
End If

IF cbx_date.checked and (ls_from_date = '' OR ISNULL(ls_from_date) or ls_to_date = '' OR ISNULL(ls_to_date)) THEN 
	f_message_chk(30,'[ 기준일자 ]')
	dw_ip.setFocus()
	dw_ip.setColumn('from_date')
	return 1
End If


//if ls_porgu ='%' Then
//	dw_print.object.t_18.text = '전체'
//ElseIf ls_porgu = ls_rfna2 Then
//	dw_print.object.t_18.text = ls_rfna1
//End If

//출력구분
if rb_single.checked then
	dw_print.dataobject = "d_pdm_t_10030_p_single"		
else
	dw_print.dataobject = "d_pdm_t_10030_p_double"
end if

dw_print.settransobject(sqlca)

dw_print.object.itdsc_t.text = dw_ip.getitemstring(dw_ip.getrow(),'itdsc')
dw_print.object.ispec_t.text = dw_ip.getitemstring(dw_ip.getrow(),'ispec')

IF trim(ls_from_date) = ''	or  IsNull(ls_from_date) THEN
	li_num = 1
	ls_from_date = '2'
else
	li_num = 8
END IF

IF trim(ls_to_date) = ''	or  IsNull(ls_to_date) THEN
	li_num = 1
	ls_to_date = '2'
else
	li_num = 8
END IF

//대체품 제외
if cbx_1.checked then
	ls_gubun = '21'
else
	ls_gubun = '9%'
end if
//미완료포함
if cbx_bomend.checked then
	ls_bomend = 'X%'
else
	ls_bomend = 'NY'
end if

dw_print.ShareData(dw_list)

dw_list.setredraw(false)

If dw_print.retrieve(ls_itnbr,ls_from_date,ls_to_date,ls_gubun,ls_bomend,li_num) <= 0 then
	MessageBox("처방표","출력할 자료가 없읍니다", stopsign!)
	return -1
End if

if rb_usseq.checked then
	dw_print.setsort("usseq a")
else
	dw_print.setsort("opsno a,usseq a")
end if
	
//	if wf_calculation(sitem, dqty, sname, sset, sspec, smodelname, sittyp, sfrom_date, sto_date) = -1 then
//		exit
//	end if	


//if dw_print.RowCount() = 0 Then
////	dw_list.setredraw(true)
//	f_message_chk(50," 콤파운드 처방표 ")
//	Return -1
//End If

w_mdi_frame.sle_msg.text = ''

dw_list.scrolltorow(1)
dw_list.setredraw(true)
setpointer(arrow!)

Return 1
end function

public function integer wf_calculation (string arg_itnbr, decimal arg_qty, string sname, string sset, string sspec, string smodelname, string sittyp, string sfrom_date, string sto_date);// string 	sItem,		&
//			sbom1,		&
//			sbom2, slname, sSTART, snewsql, snull, ls_porgu, ls_rfna1, ls_rfna2
//			
//Decimal  dqty
//Long		Lpos, lvlno, imsg, Lrow, Lrow1
//
//SetNull(snull)
//
////공장 구분 삽입
//dw_ip.AcceptText()
//ls_porgu = dw_ip.getItemString(1, "porgu")
//
//SELECT "REFFPF"."RFNA1"  ,
//       "REFFPF"."RFGUB"
//Into :ls_rfna1, :ls_rfna2
//FROM "REFFPF"  
//WHERE ( "REFFPF"."SABU" = '1' ) AND  
//      ( "REFFPF"."RFCOD" = 'AD' ) AND  
//     ( "REFFPF"."RFGUB" NOT IN ('00','99') )
//AND "REFFPF"."RFGUB" = :ls_porgu;
//
//if ls_porgu ='%' Then
//	dw_print.object.t_18.text = '전체'
//ElseIf ls_porgu = ls_rfna2 Then
//	dw_print.object.t_18.text = ls_rfna1
//End If
//
//ds_bom.reset()
//
//// 품목번호
//sItem = arg_itnbr
//dqty  = arg_qty
//
//ds_bom.modify("st_date.text = '" + string(sfrom_date, "@@@@.@@.@@")  + "'")
//dw_print.modify("st_date.text = '" + string(sfrom_date, "@@@@.@@.@@")  + "'")
//ds_bom.modify("st_date1.text = '" + string(sto_date, "@@@@.@@.@@")  + "'")
//dw_print.modify("st_date1.text = '" + string(sto_date, "@@@@.@@.@@")  + "'")
//
//If rb_1.checked Then
//	sstart = sitem
//Else
//	sstart = '%'
//End if
//
//If rb_usseq.checked then
//	slname = "usseq"
//Else
//	slname = "opsno"	
//End if
//
///* Argument 변경 */
//// Retrieve   ========================>
//if ds_bom.retrieve(arg_itnbr, sstart, ls_porgu) < 1 then return 1
//
///* 상위기준 품번을 setting */
//for Lrow = 1 to ds_bom.rowcount()
//	 ds_bom.setitem(Lrow, "pitnbr", arg_itnbr)
//	 ds_bom.setitem(Lrow, "pitdsc", sname)
//	 ds_bom.setitem(Lrow, "pispec", sspec)
//	 ds_bom.setitem(Lrow, "pjijil", smodelname)
//	 ds_bom.setitem(Lrow, "punmsr", sset)	 
//Next
//
///* 단단계시 가상품목에 대한 하위품목  검색용 */
//long    lastrow, lsec, lsec1, lsec2, lcnt
//String  lvlbyo, lvlname
//boolean blvlchk
//
//
//datastore ds_dan
//ds_dan = create datastore	
//ds_dan.dataobject  = "d_pdm_t_10030_2"	
//ds_dan.settransobject(sqlca)	
//	
//For lpos = 1 to ds_bom.rowcount()
//	 if ds_bom.getitemstring(lpos, "ittyp") <> '8' then
//		 continue
//	 End if
//		 
//	 ds_dan.reset()
//	 // Retrieve   ========================>
//	 ds_dan.retrieve(ds_bom.getitemstring(lpos, "pstruc_cinbr"), ds_bom.getitemstring(lpos, "pstruc_cinbr"), ls_porgu)
//	 For lsec2 = 1 to ds_dan.rowcount()
//		  lastrow = ds_bom.insertrow(lpos + 1)
//		 ds_bom.setitem(lastrow, "lvlno",   		2)
//		 ds_bom.setitem(lastrow, "usseq",   		ds_dan.getitemstring(lsec2, "usseq"))
//		 ds_bom.setitem(lastrow, "pstruc_cinbr", ds_dan.getitemstring(lsec2, "pstruc_cinbr"))
//		 ds_bom.setitem(lastrow, "qtypr", 			ds_dan.getitemdecimal(lsec2, "qtypr"))
//		 ds_bom.setitem(lastrow, "pcb_name", 	   ds_dan.getitemstring(lsec2, "pcb_name"))
//		 ds_bom.setitem(lastrow, "pdtname", 	   ds_dan.getitemstring(lsec2, "pdtname"))
//		 ds_bom.setitem(lastrow, "efrdt", 		   ds_dan.getitemstring(lsec2, "efrdt"))
//		 ds_bom.setitem(lastrow, "eftdt", 		   ds_dan.getitemstring(lsec2, "eftdt"))
//		 ds_bom.setitem(lastrow, "dcinbr",		   ds_dan.getitemstring(lsec2, "dcinbr"))
//		 ds_bom.setitem(lastrow, "row_no", 		ds_dan.getitemdecimal(lsec2, "row_no"))	 
//		 ds_bom.setitem(lastrow, "itdsc",   		ds_dan.getitemstring(lsec2, "itdsc"))
//		 ds_bom.setitem(lastrow, "ispec",   		ds_dan.getitemstring(lsec2, "ispec"))
//		 ds_bom.setitem(lastrow, "jijil",   		ds_dan.getitemstring(lsec2, "jijil"))
//		 ds_bom.setitem(lastrow, "jejos",   		ds_dan.getitemstring(lsec2, "jejos"))
//		 ds_bom.setitem(lastrow, "unmsr",   		ds_dan.getitemstring(lsec2, "unmsr"))
//		 ds_bom.setitem(lastrow, "ittyp",   		ds_dan.getitemstring(lsec2, "ittyp"))
//		 ds_bom.setitem(lastrow, "ldtim",   		ds_dan.getitemdecimal(lsec2, "ldtim"))
//		 ds_bom.setitem(lastrow, "opsno",   		ds_dan.getitemstring(lsec2, "opsno"))		 
//		 ds_bom.setitem(lastrow, "sortlevel",    ds_dan.getitemstring(lsec2, "sortlevel"))
//		// ds_bom.setitem(lastrow, "cvnas",        ds_dan.getitemstring(lsec2, "cvnas"))
//		 ds_bom.setitem(lastrow, "pitnbr", arg_itnbr)
//		 ds_bom.setitem(lastrow, "pitdsc", sname)
//		 ds_bom.setitem(lastrow, "pispec", sspec)
//		 ds_bom.setitem(lastrow, "pjijil", smodelname)
//		 ds_bom.setitem(lastrow, "punmsr", sset)
//	 Next
//Next
//
//destroy ds_dan
//
//Decimal {4}  dsaveqty[10], dtempqty, drstqty
//
//If cbx_qty.checked then
//	w_mdi_frame.sle_msg.text = '구성수량을 재계산중입니다.'
//	For lrow = 1 to ds_bom.rowcount()
//		 If ds_bom.getitemdecimal(lrow, "lvlno") = 1 Then
//			 dsaveqty[1] = dqty * ds_bom.getitemdecimal(lrow, "qtypr")
//			 ds_bom.setitem(lrow, "qtypr", dsaveqty[1])
//			 continue
//		 END IF		 
//			 
//		 dtempqty = dsaveqty[ds_bom.getitemdecimal(lrow, "lvlno") - 1]
//		 drstqty  = dtempqty * ds_bom.getitemdecimal(lrow, "qtypr")
//		 dsaveqty[ds_bom.getitemdecimal(lrow, "lvlno")] = drstqty
//		 ds_bom.setitem(lrow, "qtypr", drstqty)
//	Next
//End if
//
///* 출력순서 */
//lrow = 1
//lcnt = ds_bom.rowcount()
//If Rb_drilldown.checked then
//	do while true
//		
//		if lrow > ds_bom.rowcount() or lrow > lcnt then exit
//		lvlname = ds_bom.getitemstring(lrow, "sortlevel")	
//		lvlbyo  = ds_bom.getitemstring(lrow, slname)
//		blvlchk = false
//		
//		For lsec  = lrow + 1 to lcnt 
//			 if lvlname < ds_bom.getitemstring(lsec, "sortlevel") then
//				 continue
//			 End if
//			 if lvlname > ds_bom.getitemstring(lsec, "sortlevel") then
//				 exit
//			 End if				 
//			 if lvlbyo  > ds_bom.getitemstring(lsec, slname) then
//				 blvlchk = true
//				 exit
//			 end if		 		
//		Next
//		
//		if blvlchk = false then
//			lrow++
//			continue
//		end if	
//	
//		For lsec1 = lsec + 1 to lcnt
//			 if lvlname < ds_bom.getitemstring(lsec1, "sortlevel") then
//				 continue
//			 End if
//			 if lvlname > ds_bom.getitemstring(lsec1, "sortlevel") then
//				 exit
//			 End if		 
//			 if lvlbyo < ds_bom.getitemstring(lsec1, slname) then
//				 exit
//			 end if
//		Next
//	
//		lsec2 = lrow
//		do while true
//			 lastrow = ds_bom.insertrow(lsec1)		 
//			 ds_bom.setitem(lastrow, "lvlno",   		ds_bom.getitemdecimal(lsec2, "lvlno"))
//			 ds_bom.setitem(lastrow, "usseq",   		ds_bom.getitemstring(lsec2, "usseq"))
//			 ds_bom.setitem(lastrow, "pstruc_cinbr", ds_bom.getitemstring(lsec2, "pstruc_cinbr"))
//			 ds_bom.setitem(lastrow, "qtypr", 			ds_bom.getitemdecimal(lsec2, "qtypr"))
//			 ds_bom.setitem(lastrow, "pcb_name", 	   ds_bom.getitemstring(lsec2, "pcb_name"))
//			 ds_bom.setitem(lastrow, "pdtname", 	   ds_bom.getitemstring(lsec2, "pdtname"))
//			 ds_bom.setitem(lastrow, "efrdt", 		   ds_bom.getitemstring(lsec2, "efrdt"))
//			 ds_bom.setitem(lastrow, "eftdt", 		   ds_bom.getitemstring(lsec2, "eftdt"))
//			 ds_bom.setitem(lastrow, "dcinbr",		   ds_bom.getitemstring(lsec2, "dcinbr"))
//			 ds_bom.setitem(lastrow, "row_no", 		   ds_bom.getitemdecimal(lsec2, "row_no"))	 
//			 ds_bom.setitem(lastrow, "itdsc",   		ds_bom.getitemstring(lsec2, "itdsc"))
//			 ds_bom.setitem(lastrow, "ispec",   		ds_bom.getitemstring(lsec2, "ispec"))
//			 ds_bom.setitem(lastrow, "jijil",   		ds_bom.getitemstring(lsec2, "jijil"))
//			 ds_bom.setitem(lastrow, "jejos",   		ds_bom.getitemstring(lsec2, "jejos"))
//			 ds_bom.setitem(lastrow, "unmsr",   		ds_bom.getitemstring(lsec2, "unmsr"))
//			 ds_bom.setitem(lastrow, "ittyp",   		ds_bom.getitemstring(lsec2, "ittyp"))
//			 ds_bom.setitem(lastrow, "ldtim",   		ds_bom.getitemdecimal(lsec2, "ldtim"))
//			 ds_bom.setitem(lastrow, "opsno",   		ds_bom.getitemstring(lsec2, "opsno"))
//			 ds_bom.setitem(lastrow, "sortlevel",    ds_bom.getitemstring(lsec2, "sortlevel"))		 
//			// ds_bom.setitem(lastrow, "cvnas",        ds_dan.getitemstring(lsec2, "cvnas"))
//			 
//			 ds_bom.setitem(lastrow, "pitnbr",        ds_bom.getitemstring(lsec2, "pitnbr"))
//			 ds_bom.setitem(lastrow, "pitdsc", 			ds_bom.getitemstring(lsec2, "pitdsc"))
//			 ds_bom.setitem(lastrow, "pispec", 			ds_bom.getitemstring(lsec2, "pispec"))
//			 ds_bom.setitem(lastrow, "pjijil", 			ds_bom.getitemstring(lsec2, "pjijil"))
//			 ds_bom.setitem(lastrow, "punmsr", 			ds_bom.getitemstring(lsec2, "punmsr"))			 
//	
//			 ds_bom.deleterow(lsec2)
//			 if lsec2 > lcnt or &
//				 lvlname >= ds_bom.getitemstring(lsec2, "sortlevel") then
//				 exit
//			 end if
//		Loop		
//	Loop
//End if
//
///* 유효일자 적용여부 */
////for lrow = 1 to ds_bom.rowcount()
////	 ds_bom.setitem(lrow, "gidat", sfrom_date)
////Next
//
//For lrow = 1 to ds_bom.rowcount()
//	 if cbx_date.checked then    // 유효일자 제외인 경우 삭제
//	 	 //기준 일자 1, 2의 부합 여부 확인
//		 if sfrom_date < ds_bom.getitemstring(lrow, "efrdt")  or &
//			 sfrom_date > ds_bom.getitemstring(lrow, "eftdt")  or & 
//			 sto_date < ds_bom.getitemstring(lrow, "efrdt")  or &
//			 sto_date > ds_bom.getitemstring(lrow, "eftdt")  Then
//			 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
//			 ds_bom.deleterow(lrow)
//			 Do while true	
//				 if lrow  > ds_bom.rowcount() then exit
//				 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
//					 ds_bom.deleterow(lrow)				 
//				 Else
//					 Exit
//				 End if
//			 Loop
//			 lrow = lrow - 1
//		 End if
//	End if
//	 
//	 // 정전개인 경우 대체품제외인 경우 처리
//	 if cbx_1.checked = False and rb_drilldown.checked then
//		 if Lrow <= ds_bom.rowcount() and Lrow > 0 then
//		 if not IsNull( ds_bom.getitemstring(lrow, "dcinbr") )  Then
//			 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
//			 ds_bom.deleterow(lrow)
//			 Do while true	
//				 if lrow  > ds_bom.rowcount() then exit
//				 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
//					 ds_bom.deleterow(lrow)				 
//				 Else
//					 Exit
//				 End if
//			 Loop
//			 lrow = lrow - 1
//		 End if
//		 End if
//	 End if		 
//	 
//	 // 정전개인 경우 BOM미완료이면 삭제
//	 if cbx_bomend.checked = False and rb_drilldown.checked then
//		 if Lrow <= ds_bom.rowcount() and Lrow > 0  then		
//		 if ds_bom.getitemstring(lrow, "bomend") = 'N'   Then
//			 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
//			 ds_bom.deleterow(lrow)
//			 Do while true	
//				 if lrow  > ds_bom.rowcount() then exit
//				 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
//					 ds_bom.deleterow(lrow)				 
//				 Else
//					 Exit
//				 End if
//			 Loop
//			 lrow = lrow - 1
//		 End if
//		 End if
//	 End if		 	 
//Next
//
///* 자료를 print로 복사한다 */
//ds_bom.RowsCopy(1, ds_bom.RowCount(), Primary!, dw_print, dw_print.rowcount() + 1, Primary!)
//
return 1
end function

on w_pdm_t_10030.create
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
this.pb_2=create pb_2
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
this.Control[iCurrent+14]=this.pb_2
this.Control[iCurrent+15]=this.gb_5
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_3
this.Control[iCurrent+18]=this.gb_4
this.Control[iCurrent+19]=this.gb_1
end on

on w_pdm_t_10030.destroy
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
destroy(this.pb_2)
destroy(this.gb_5)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'porgu')

end event

type p_preview from w_standard_print`p_preview within w_pdm_t_10030
end type

type p_exit from w_standard_print`p_exit within w_pdm_t_10030
end type

type p_print from w_standard_print`p_print within w_pdm_t_10030
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_t_10030
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







type st_10 from w_standard_print`st_10 within w_pdm_t_10030
end type



type dw_print from w_standard_print`dw_print within w_pdm_t_10030
integer x = 4155
integer y = 496
integer width = 361
integer height = 248
string dataobject = "d_pdm_11712_p_single"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_t_10030
integer x = 32
integer y = 188
integer width = 4110
integer height = 260
string dataobject = "d_pdm_t_10030_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string scode, sItDsc, sIspec, sJijil

if THIS.GetColumnName() = "itnbr" THEN
	sCode = This.GetText()
	
	IF sCode = '' OR ISNULL(sCode) THEN 
		f_message_chk(35,'[ 품번 ]')
		this.setFocus()
		this.setColumn('itnbr')
		return 1
	End If
	
	SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
	  INTO :sItDsc,   		 :sIspec, 		:sJijil
	  FROM "ITEMAS"
	 WHERE "ITEMAS"."ITNBR" = :sCode AND	"ITEMAS"."USEYN" = '0' ;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
		this.setitem(1, 'itnbr', '')
		this.setitem(1, 'itdsc', '')
		this.setitem(1, 'ispec', '')
		this.setFocus()
		this.setColumn('itnbr')
//         p_can.triggerevent(clicked!)
		Return 1
	END IF
		this.setitem(1, 'itnbr', sCode)
		this.setitem(1, 'itdsc', sItDsc)
		this.setitem(1, 'ispec', sIspec)
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

elseif this.GetColumnName() = 'itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itnbr",gs_code)
	this.SetItem(1,"itdsc",gs_codename)
	
	this.TriggerEvent(Itemchanged!)

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

type dw_list from w_standard_print`dw_list within w_pdm_t_10030
integer y = 464
integer width = 4567
integer height = 1852
string dataobject = "d_pdm_t_10030_2"
end type

event dw_list::clicked;call super::clicked;//if row > 0 then
//	if dw_list.getitemstring(row, "gidat") < dw_list.getitemstring(row, "efrdt") or &
//		dw_list.getitemstring(row, "gidat") > dw_list.getitemstring(row, "eftdt") then
//		Messagebox("일자", "유효기간경과") 
//	end if
//end if
end event

type rb_single from radiobutton within w_pdm_t_10030
integer x = 1627
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

type rb_prtgu from radiobutton within w_pdm_t_10030
integer x = 1851
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

type cbx_date from checkbox within w_pdm_t_10030
integer x = 553
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

type rb_opseq from radiobutton within w_pdm_t_10030
integer x = 1330
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

type rb_usseq from radiobutton within w_pdm_t_10030
integer x = 1097
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

type cbx_qty from checkbox within w_pdm_t_10030
boolean visible = false
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

type cbx_1 from checkbox within w_pdm_t_10030
integer x = 110
integer y = 72
integer width = 375
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "대체품제외"
end type

type rb_2 from radiobutton within w_pdm_t_10030
boolean visible = false
integer x = 2981
integer y = 76
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
boolean enabled = false
string text = "다단계"
end type

event clicked;dw_list.modify("st_level.text = '다단계'") 
end event

type rb_1 from radiobutton within w_pdm_t_10030
boolean visible = false
integer x = 2711
integer y = 76
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
boolean checked = true
end type

event clicked;dw_list.modify("st_level.text = '단단계'") 
end event

type rb_drilldown from radiobutton within w_pdm_t_10030
boolean visible = false
integer x = 3337
integer y = 76
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
boolean enabled = false
string text = "정전개"
boolean checked = true
end type

event clicked;dw_list.dataobject = 'd_pdm_10030_2'
dw_list.settransobject(sqlca)
end event

type rb_drillup from radiobutton within w_pdm_t_10030
boolean visible = false
integer x = 3593
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
boolean enabled = false
string text = "역전개"
end type

event clicked;dw_list.dataobject = 'd_pdm_10030_2_1'
dw_list.settransobject(sqlca)
end event

type cbx_bomend from checkbox within w_pdm_t_10030
integer x = 2158
integer y = 80
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

type pb_1 from u_pb_cal within w_pdm_t_10030
integer x = 1769
integer y = 208
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('from_date')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'from_date', gs_code)

end event

type pb_2 from u_pb_cal within w_pdm_t_10030
integer x = 2181
integer y = 208
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('to_date')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'to_date', gs_code)

end event

type gb_5 from groupbox within w_pdm_t_10030
integer x = 1591
integer y = 28
integer width = 498
integer height = 136
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

type gb_2 from groupbox within w_pdm_t_10030
integer x = 1061
integer y = 28
integer width = 521
integer height = 136
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

type gb_3 from groupbox within w_pdm_t_10030
boolean visible = false
integer x = 2683
integer y = 28
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
boolean enabled = false
end type

type gb_4 from groupbox within w_pdm_t_10030
integer x = 46
integer y = 24
integer width = 1006
integer height = 140
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type gb_1 from groupbox within w_pdm_t_10030
boolean visible = false
integer x = 3264
integer y = 32
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
boolean enabled = false
string text = "전개방법"
end type

