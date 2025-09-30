$PBExportHeader$w_eomst_popup.srw
$PBExportComments$** eo pop up
forward
global type w_eomst_popup from w_inherite_popup
end type
type rr_2 from roundrectangle within w_eomst_popup
end type
end forward

global type w_eomst_popup from w_inherite_popup
integer x = 357
integer y = 236
integer width = 2981
integer height = 2072
string title = "eo-No 조회"
rr_2 rr_2
end type
global w_eomst_popup w_eomst_popup

type variables
string is_itcls
end variables

on w_eomst_popup.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_eomst_popup.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

dw_jogun.setitem(1, 'ittyp', gs_gubun)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_eomst_popup
integer x = 0
integer y = 32
integer width = 2427
integer height = 396
string dataobject = "d_itemas_ittyp"
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

type p_exit from w_inherite_popup`p_exit within w_eomst_popup
integer x = 2779
integer y = 32
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_eomst_popup
integer x = 2432
integer y = 32
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sJijil ,sUseyn
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

IF IsNull(scode)  THEN scode  = ""
IF IsNull(sname)  THEN sname  = ""
IF IsNull(sspec)  THEN sspec  = ""
IF IsNull(sitcls) THEN sitcls = ""
IF IsNull(sJijil) THEN sJijil = ""
 
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
IF sUseyn <> "" THEN
	sUseyn = '%' + sUseyn +'%'
	swhere_clause = swhere_clause + "AND A.USEYN LIKE '"+sUseyn+"'"
END IF


snew_sql = sold_sql + swhere_clause

dw_1.SetSqlSelect(snew_sql)
	
dw_1.Retrieve()

dw_1.SetSqlSelect(sold_sql)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_eomst_popup
integer x = 2606
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

gs_code = dw_1.GetItemString(ll_Row, "eo_tb_eo_no")
gs_codename = dw_1.GetItemString(ll_row,"itemas_itnbr")
gs_gubun = dw_1.GetItemString(ll_row,"itemas_ispec")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_eomst_popup
integer y = 440
integer width = 2898
integer height = 1488
integer taborder = 100
string dataobject = "d_eomst_popup"
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

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

//IF dw_1.GetItemString(Row, "itemas_useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
//IF dw_1.GetItemString(Row, "itemas_useyn") = '2' then
//	f_message_chk(54, "[품번]")
//	Return 
//END IF

gs_code= dw_1.GetItemString(Row, "eo_tb_eo_no")
gs_codename= dw_1.GetItemString(row,"itemas_itnbr")
//gs_gubun= dw_1.GetItemString(row,"itemas_ispec")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_eomst_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_eomst_popup
end type

type cb_return from w_inherite_popup`cb_return within w_eomst_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_eomst_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_eomst_popup
end type

type st_1 from w_inherite_popup`st_1 within w_eomst_popup
end type

type rr_2 from roundrectangle within w_eomst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 432
integer width = 2917
integer height = 1512
integer cornerheight = 40
integer cornerwidth = 55
end type

