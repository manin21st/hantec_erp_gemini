$PBExportHeader$w_pm01_02020_1_pop.srw
$PBExportComments$월 생산능력 검토_CO2아이템조합popup(ver.17.10.10)
forward
global type w_pm01_02020_1_pop from w_inherite_popup
end type
type cbx_1 from checkbox within w_pm01_02020_1_pop
end type
type rr_1 from roundrectangle within w_pm01_02020_1_pop
end type
end forward

global type w_pm01_02020_1_pop from w_inherite_popup
integer x = 741
integer y = 248
integer width = 1961
integer height = 1864
string title = "CO2용접 아이템 조합"
boolean controlmenu = true
cbx_1 cbx_1
rr_1 rr_1
end type
global w_pm01_02020_1_pop w_pm01_02020_1_pop

type variables
string is_itcls
end variables

on w_pm01_02020_1_pop.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pm01_02020_1_pop.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

dw_jogun.setitem(1, 'itnbr', gs_code)
//dw_jogun.setitem(1, 'opseq', '0010')

If dw_1.Retrieve(gs_code, gs_gubun) > 0 Then
	dw_jogun.setitem(1, 'rob_sec', dw_1.getitemnumber(1, 'b_rob_sec'))
	dw_jogun.setitem(1, 'man_sec', dw_1.getitemnumber(1, 'b_man_sec'))
End If

dw_1.SetFilter("plan_qty > 0")
dw_1.Filter()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pm01_02020_1_pop
integer x = 32
integer y = 0
integer width = 1897
integer height = 144
string dataobject = "d_pm01_02020_1_pop0"
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

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_pm01_02020_1_pop
boolean visible = false
integer x = 2592
integer y = 208
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pm01_02020_1_pop
boolean visible = false
integer x = 2245
integer y = 208
end type

type p_choose from w_inherite_popup`p_choose within w_pm01_02020_1_pop
boolean visible = false
integer x = 2418
integer y = 208
end type

type dw_1 from w_inherite_popup`dw_1 within w_pm01_02020_1_pop
integer x = 41
integer y = 224
integer width = 1847
integer height = 1532
integer taborder = 10
string dataobject = "d_pm01_02020_1_pop1"
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

gs_gubun= 'OK'
gs_code= dw_1.GetItemString(Row, "itnbr")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_pm01_02020_1_pop
boolean visible = false
integer x = 722
integer y = 1916
integer width = 1001
end type

event sle_2::getfocus;f_toggle_eng(Handle(this))
end event

type cb_1 from w_inherite_popup`cb_1 within w_pm01_02020_1_pop
integer x = 233
integer y = 1896
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_pm01_02020_1_pop
integer x = 873
integer y = 1896
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_pm01_02020_1_pop
integer x = 553
integer y = 1896
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pm01_02020_1_pop
boolean visible = false
integer x = 297
integer y = 1916
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_pm01_02020_1_pop
boolean visible = false
integer y = 1928
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type cbx_1 from checkbox within w_pm01_02020_1_pop
integer x = 1417
integer y = 148
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "계획 수량 > 0"
boolean checked = true
end type

event clicked;If this.Checked Then
	dw_1.SetFilter("plan_qty > 0")
	dw_1.Filter()
Else
	dw_1.SetFilter("1=1")
	dw_1.Filter()
End If
end event

type rr_1 from roundrectangle within w_pm01_02020_1_pop
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 216
integer width = 1870
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 55
end type

