$PBExportHeader$w_imt_02570.srw
$PBExportComments$** 발주서
forward
global type w_imt_02570 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_02570
end type
type rr_2 from roundrectangle within w_imt_02570
end type
end forward

global type w_imt_02570 from w_standard_print
integer height = 3168
string title = "발주서"
boolean maxbox = true
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_02570 w_imt_02570

type variables
string    is_printgu  = 'N'   //발주서 출력여부
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();//string sdate, edate, emp1, emp2, cvcod1, cvcod2, gubun, gubun2, sbaljpno, sortgu
//Long   ll_i
//
//if dw_ip.AcceptText() = -1 then 
//	dw_ip.SetFocus()
//	return -1
//end if
//sdate    = trim(dw_ip.object.sdate[1])
//edate    = trim(dw_ip.object.edate[1])
//emp1     = trim(dw_ip.object.emp1[1])
//emp2     = trim(dw_ip.object.emp2[1])
//cvcod1   = trim(dw_ip.object.cvcod1[1])
//cvcod2   = trim(dw_ip.object.cvcod2[1])
//gubun    = trim(dw_ip.object.gubun[1]) 
//gubun2   = trim(dw_ip.object.gubun2[1]) 
//sbaljpno = trim(dw_ip.object.baljpno[1]) 
//sortgu   = trim(dw_ip.object.sortgu[1]) 
//
//if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
//if (IsNull(edate) or edate = "")  then edate = "99991231"
//if (IsNull(emp1) or emp1 = "")  then emp1 = "."
//if (IsNull(emp2) or emp2 = "")  then emp2 = "ZZZZZZ"
//if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
//if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"
//if (IsNull(sbaljpno) or sbaljpno = "")  then sbaljpno = "%"
//
//IF dw_print.Retrieve(gs_sabu, sdate, edate, emp1, emp2, cvcod1, cvcod2, gubun, sbaljpno, sortgu, gs_saupj) <= 0 then
//	f_message_chk(50,'[발 주 서]')
//	dw_ip.Setfocus()
//	dw_list.Reset()
//	dw_print.insertrow(0)
////	Return -1
//END IF
//
//dw_print.ShareData(dw_list)
//
//if dw_print.rowcount() > 0 then 
//	For ll_i = 1 to dw_print.rowcount()
//		dw_print.object.reffpf_rfna1[ll_i] = gs_username
//	Next 
//End if 
//
//if dw_list.rowcount() > 0 then 
//	For ll_i = 1 to dw_list.rowcount()
//		dw_list.object.reffpf_rfna1[ll_i] = gs_username 
//	Next 
//End if 
//
///* 입고장소, 담당자, 전화번호, FAX */
//String a1, a2,a3, a4
//
//a1 = trim(dw_ip.GetItemString(1, 'a1'))
//a2 = trim(dw_ip.GetItemString(1, 'a2'))
////a3 = trim(dw_ip.GetItemString(1, 'a3')) 전화번호 사용안함
//a4 = trim(dw_ip.GetItemString(1, 'a4'))
//
//dw_list.Object.a1_t.text = a1
//dw_print.Object.a1_t.text = a1
////dw_list.Object.a2_t.text = a2
//
//For ll_i = 1 To dw_list.RowCount()
////	If Not IsNull(a3) Then dw_list.SetItem(ll_i, 'jasa_tel', a3)
//	If Not IsNull(a2) Then dw_list.SetItem(ll_i, 'vndmst_cvpln', a2)
//	If Not IsNull(a4) Then dw_list.SetItem(ll_i, 'jasa_fax', a4)
//Next
//
//return 1

dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_baljpno

ls_baljpno = dw_ip.GetItemString(row, 'baljpno')
If Trim(ls_baljpno) = '' OR IsNull(ls_baljpno) Then
	MessageBox('발주번호 확인', '발주번호는 필수 항목입니다.')
	Return -1
End If

String ls_baldate

ls_baldate = dw_ip.GetItemString(row, 'sdate')
If Trim(ls_baldate) = '' OR IsNull(ls_baldate) Then
	MessageBox('발주일자 확인', '발주일자는 필수 항목입니다.')
	Return -1
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_baljpno, ls_baldate)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1
end function

on w_imt_02570.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_imt_02570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.setitem(1, 'sdate', is_today)
dw_ip.setitem(1, 'edate', is_today)

end event

type p_xls from w_standard_print`p_xls within w_imt_02570
integer x = 3712
integer y = 16
end type

type p_sort from w_standard_print`p_sort within w_imt_02570
integer x = 3534
integer y = 16
end type

type p_preview from w_standard_print`p_preview within w_imt_02570
end type

type p_exit from w_standard_print`p_exit within w_imt_02570
end type

type p_print from w_standard_print`p_print within w_imt_02570
end type

event p_print::clicked;long k, lCount

//출력시 y로 변경
if is_printgu  = 'Y' then 

	lCount = dw_list.rowcount()
	
	if lCount < 1  then return 
	
	FOR k = 1 TO lCount
		dw_list.setitem(k, 'pomast_printgu', 'Y')
	NEXT
	
	if dw_list.update() = 1 then
		commit ;
	else
		rollback ;
	end if	

   is_printgu  = 'N'
end if

IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from w_standard_print`p_retrieve within w_imt_02570
end type

type st_window from w_standard_print`st_window within w_imt_02570
integer y = 3080
end type

type sle_msg from w_standard_print`sle_msg within w_imt_02570
integer y = 3080
end type

type dw_datetime from w_standard_print`dw_datetime within w_imt_02570
integer y = 3080
end type

type st_10 from w_standard_print`st_10 within w_imt_02570
integer y = 3048
end type

type gb_10 from w_standard_print`gb_10 within w_imt_02570
integer y = 3044
end type

type dw_print from w_standard_print`dw_print within w_imt_02570
integer x = 3287
integer y = 44
integer width = 174
integer height = 144
string dataobject = "d_imt_02570_02_han"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02570
integer x = 50
integer y = 52
integer width = 2016
integer height = 160
string dataobject = "d_imt_02570_01_han"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2, snull
integer i_rtn

s_cod = Trim(this.gettext())

setnull(snull)

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = 'cvcod1' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod1",s_cod)	
	this.SetItem(1,"cvnam1",s_nam1)	
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod2",s_cod)	
	this.SetItem(1,"cvnam2",s_nam1)	
	return i_rtn
elseIF this.GetColumnName() ="baljpno" THEN
	if IsNull(s_cod) or s_cod = "" then return 

  SELECT "POMAST"."BALDATE", 
  			"POMAST"."BALGU" 
    INTO :s_nam1, :s_nam2
    FROM "POMAST"  
   WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
         ( "POMAST"."BALJPNO" = :s_cod )   ;

	IF SQLCA.SQLCODE <> 0 then 
		setitem(1, "baljpno", snull)
      RETURN 1
//	Elseif s_nam2 = '3' then
//		Messagebox("발주내역", "외주발주 내역은 출력할 수 없읍니다", stopsign!)
//		setitem(1, "baljpno", snull)
//		return 1
	END IF
	this.object.sdate[1] = s_nam1
	this.object.edate[1] = s_nam1
END IF	

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.getcolumnname() = "cvcod1"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
	return
elseIF this.GetColumnName() = "baljpno" THEN
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	open(w_poblkt_popup)
	this.setitem(1, "baljpno", left(gs_code, 12))
	this.triggerevent(itemchanged!)
END IF
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_02570
integer x = 64
integer y = 272
integer width = 4521
integer height = 2596
string dataobject = "d_imt_02570_02_han"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_list::printend;is_printgu  = 'Y'

end event

type rr_1 from roundrectangle within w_imt_02570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 40
integer width = 2053
integer height = 188
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_02570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 256
integer width = 4571
integer height = 2624
integer cornerheight = 40
integer cornerwidth = 55
end type

