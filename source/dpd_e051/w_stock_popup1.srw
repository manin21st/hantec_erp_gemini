$PBExportHeader$w_stock_popup1.srw
$PBExportComments$** 현재고 조회 팝업
forward
global type w_stock_popup1 from w_inherite_popup
end type
type rr_2 from roundrectangle within w_stock_popup1
end type
end forward

global type w_stock_popup1 from w_inherite_popup
integer x = 357
integer y = 236
integer width = 3054
integer height = 1924
string title = "품목코드 조회(MRO)"
rr_2 rr_2
end type
global w_stock_popup1 w_stock_popup1

type variables
string is_itcls
str_code		iscode 
end variables

on w_stock_popup1.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_stock_popup1.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
//
//dw_jogun.setitem(1, 'ittyp', gs_gubun)

//창고
//DataWindowChild state_child
//Long   rtncode
//rtncode 	= dw_jogun.GetChild('depot_no', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 창고")
//state_child.SetTransObject(SQLCA)

//Long ll_rtn
//ll_rtn = state_child.Retrieve(gs_dept)

dw_jogun.InsertRow(0)

//If ll_rtn > 0 Then
//	dw_jogun.SetItem(1, 'depot_no', state_child.GetItemString(1, 'cvcod'))
//End If

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_stock_popup1
integer x = 0
integer y = 32
integer width = 2144
integer height = 300
string dataobject = "d_itemas_ittyp_stock"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN 
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_name)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		return 1
   end if	
END IF
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

type p_exit from w_inherite_popup`p_exit within w_stock_popup1
integer x = 2807
integer y = 32
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_stock_popup1
integer x = 2459
integer y = 32
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sJijil ,sUseyn, sDepot_no
String sold_sql, swhere_clause, snew_sql

if dw_jogun.AcceptText() = -1 then return 

sgu = dw_jogun.GetItemString(1,'ittyp')

IF IsNull(sgu) THEN sgu = ""

scode  = trim(dw_jogun.GetItemString(1,'itnbr'))
sname  = trim(dw_jogun.GetItemString(1,'itdsc'))
sspec  = trim(dw_jogun.GetItemString(1,'ispec'))
sitcls = trim(dw_jogun.GetItemString(1,'itcls'))
sJijil = trim(dw_jogun.GetItemString(1,'jijil'))
sUseyn = trim(dw_jogun.GetItemString(1,'useyn'))
sDepot_no = trim(dw_jogun.GetItemString(1,'depot_no'))

IF IsNull(scode)  THEN scode  = ""
IF IsNull(sname)  THEN sname  = ""
IF IsNull(sspec)  THEN sspec  = ""
IF IsNull(sitcls) THEN sitcls = ""
IF IsNull(sJijil) THEN sJijil = ""
IF IsNull(sDepot_no) or sDepot_no = "" THEN sDepot_no = '%'

sold_sql = dw_1.GetSQLSelect()	  

swhere_clause = ""

IF sgu <> ""  THEN 
   swhere_clause = swhere_clause + "AND A.ITTYP ='"+sgu+"'"
END IF
IF scode <> "" THEN
	scode = '%' + scode +'%'
	swhere_clause = swhere_clause + "AND A.ITNBR LIKE '"+scode+"'"
END IF
IF sname <> "" THEN
	sname = '%' + sname +'%'
	swhere_clause = swhere_clause + "AND A.ITDSC LIKE '"+sname+"'"
END IF
IF sspec <> "" THEN
	sspec = '%' + sspec +'%'
	swhere_clause = swhere_clause + "AND A.ISPEC LIKE '"+sspec+"'"
END IF
IF sUseyn <> "" THEN
	sUseyn = '%' + sUseyn +'%'
	swhere_clause = swhere_clause + "AND A.USEYN LIKE '"+sUseyn+"'"
END IF


snew_sql = sold_sql + swhere_clause

dw_1.SetSqlSelect(snew_sql)
	
dw_1.Retrieve(sDepot_no)

dw_1.SetSqlSelect(sold_sql)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_stock_popup1
integer x = 2633
integer y = 32
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '2' then
//	f_message_chk(54, "[품번]")
//	Return 
//END IF

gs_code = dw_1.GetItemString(ll_Row, "itemas_itnbr")
gs_codename = dw_1.GetItemString(ll_row,"itemas_itdsc")
//gs_gubun = dw_1.GetItemString(ll_row,"itemas_ispec")
gs_gubun = dw_1.GetItemString(ll_row, 'pspec')
iscode.qty = dw_1.GetItemNumber(ll_row,"jego_qty")

//messagebox('1', iscode.qty)

CloseWithReturn(Parent , iscode)
//Close(Parent)


end event

type dw_1 from w_inherite_popup`dw_1 within w_stock_popup1
integer y = 356
integer width = 2981
integer height = 1432
integer taborder = 50
string dataobject = "d_itemas_popup_stock"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '2' then
//	f_message_chk(54, "[품번]")
//	Return 
//END IF

gs_code = dw_1.GetItemString(ll_Row, "itemas_itnbr")
gs_codename = dw_1.GetItemString(ll_row,"itemas_itdsc")
gs_gubun = dw_1.GetItemString(ll_row,"itemas_ispec")
iscode.qty = dw_1.GetItemNumber(ll_row,"jego_qty")

CloseWithReturn(Parent , iscode)
//Close(Parent)


end event

type sle_2 from w_inherite_popup`sle_2 within w_stock_popup1
end type

type cb_1 from w_inherite_popup`cb_1 within w_stock_popup1
end type

type cb_return from w_inherite_popup`cb_return within w_stock_popup1
end type

type cb_inq from w_inherite_popup`cb_inq within w_stock_popup1
end type

type sle_1 from w_inherite_popup`sle_1 within w_stock_popup1
end type

type st_1 from w_inherite_popup`st_1 within w_stock_popup1
end type

type rr_2 from roundrectangle within w_stock_popup1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 344
integer width = 2999
integer height = 1464
integer cornerheight = 40
integer cornerwidth = 55
end type

