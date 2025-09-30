$PBExportHeader$w_itmbuy_popup5.srw
$PBExportComments$품번 조회 선택
forward
global type w_itmbuy_popup5 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_itmbuy_popup5
end type
end forward

global type w_itmbuy_popup5 from w_inherite_popup
integer x = 466
integer y = 160
integer width = 3086
integer height = 2136
string title = "품번 조회 선택"
rr_1 rr_1
end type
global w_itmbuy_popup5 w_itmbuy_popup5

type variables
string is_cvcod
str_itnct str_sitnct
end variables

on w_itmbuy_popup5.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_itmbuy_popup5.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'ittyp', gs_gubun)

setnull(gs_code)
f_mod_saupj(dw_jogun, 'porgu')
dw_jogun.SetFocus()
dw_1.ScrollToRow(1)

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itmbuy_popup5
integer x = 9
integer y = 8
integer width = 2437
integer height = 392
string dataobject = "d_itemas_ittyp"
end type

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

IF 	this.GetColumnName() = 'ittyp' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN 
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_name)
	if 	isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		return 1
   end if	
END IF
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "itcls"
		OpenWithParm(w_ittyp_popup, GetItemString(GetRow(),"ittyp"))
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",str_sitnct.s_sumgub)		
		SetColumn('itnbr')
END Choose
end event

type p_exit from w_inherite_popup`p_exit within w_itmbuy_popup5
integer x = 2857
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itmbuy_popup5
integer x = 2510
integer y = 16
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sJijil, ls_porgu
String sold_sql, swhere_clause, snew_sql, ls_saupj

if dw_jogun.AcceptText() = -1 then return 

sgu 		= dw_jogun.GetItemString(1,'ittyp')
ls_porgu = dw_jogun.GetItemString(1,'porgu')

IF IsNull(sgu) THEN sgu = ""

scode  	= trim(dw_jogun.GetItemString(1,'itnbr'))
sname  	= trim(dw_jogun.GetItemString(1,'itdsc'))
sspec  	= trim(dw_jogun.GetItemString(1,'ispec'))
sitcls 	= trim(dw_jogun.GetItemString(1,'itcls'))
sJijil 	= trim(dw_jogun.GetItemString(1,'jijil'))

IF IsNull(scode)  or scode = '' 	THEN scode  = ''
IF IsNull(sname) or sname = '' 	THEN sname  = ''
IF IsNull(sspec)  or sspec = '' 	THEN sspec  = ''
IF IsNull(sitcls) 	or sitcls   = '' 	THEN sitcls = ''
IF IsNull(sJijil) 	or sjijil     = ''		THEN sJijil = ''

dw_1.Retrieve(ls_porgu, sgu, sitcls+'%', scode+'%', sname+'%', sspec+'%', sjijil+'%' )
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_itmbuy_popup5
integer x = 2683
integer y = 16
end type

event p_choose::clicked;call super::clicked;gs_code = 'Y'
SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_1.SaveAs("", Clipboard!, False)
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itmbuy_popup5
integer x = 27
integer y = 420
integer width = 3013
integer height = 1616
integer taborder = 20
string dataobject = "d_itmbuy_popup5"
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

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code= dw_1.GetItemString(Row, "baljpno")
//gs_codename= string(dw_1.GetItemNumber(Row, "poblkt_balseq"))
//
//Close(Parent)
//
end event

event dw_1::rowfocuschanged;RETURN 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_itmbuy_popup5
boolean visible = false
integer x = 1125
integer y = 2500
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_itmbuy_popup5
integer x = 1211
integer y = 2572
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_itmbuy_popup5
integer x = 1833
integer y = 2572
end type

type cb_inq from w_inherite_popup`cb_inq within w_itmbuy_popup5
integer x = 1522
integer y = 2572
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itmbuy_popup5
boolean visible = false
integer x = 462
integer y = 2500
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_itmbuy_popup5
boolean visible = false
integer x = 192
integer y = 2520
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_itmbuy_popup5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 412
integer width = 3049
integer height = 1632
integer cornerheight = 40
integer cornerwidth = 55
end type

