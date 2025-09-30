$PBExportHeader$w_plancheck_popup.srw
$PBExportComments$** 구매계획 CHECK
forward
global type w_plancheck_popup from w_inherite_popup
end type
type tab_1 from tab within w_plancheck_popup
end type
type tabpage_1 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_2 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_3 from userobject within tab_1
end type
type dw_4 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_4 dw_4
end type
type tabpage_4 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_5 from userobject within tab_1
end type
type dw_6 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_6 dw_6
end type
type tab_1 from tab within w_plancheck_popup
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
end forward

global type w_plancheck_popup from w_inherite_popup
integer x = 46
integer y = 160
integer width = 2661
integer height = 1732
string title = "구매계획 CHECK"
boolean controlmenu = true
tab_1 tab_1
end type
global w_plancheck_popup w_plancheck_popup

on w_plancheck_popup.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_plancheck_popup.destroy
call super::destroy
destroy(this.tab_1)
end on

event open;call super::open;dw_jogun.InsertRow(0)
dw_jogun.setitem(1,'yymmdd',gs_gubun)
dw_jogun.setitem(1,'itnbr',gs_code)
dw_jogun.setitem(1,'itdsc',gs_codename)
dw_jogun.setitem(1,'numqty',integer(gs_codename2))

tab_1.tabpage_1.dw_2.settransobject(sqlca)
tab_1.tabpage_2.dw_3.settransobject(sqlca)
tab_1.tabpage_3.dw_4.settransobject(sqlca)
tab_1.tabpage_4.dw_5.settransobject(sqlca)
tab_1.tabpage_5.dw_6.settransobject(sqlca)

p_inq.triggerevent(clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_plancheck_popup
integer x = 23
integer y = 16
integer width = 2354
integer height = 120
string dataobject = "d_plancheck_popup_0"
boolean border = true
end type

event dw_jogun::rbuttondown;call super::rbuttondown;String sNull

setnull(gs_code); setnull(gs_gubun); setnull(gs_codename); setnull(snull)

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:은행,4:부서,5:창고   
      f_message_chk(70, '[발주처]')
		this.SetItem(1, "cvcod", snull)
		this.SetItem(1, "cvnas", snull)
      return 1  		
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnas", gs_Codename)
END IF	
end event

event dw_jogun::itemchanged;call super::itemchanged;string snull, sbaljno, get_nm, s_date, s_empno, s_name, s_name2
int    ireturn 

setnull(snull)

IF this.GetColumnName() = "cvcod" THEN
	s_empno = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
	this.setitem(1, "cvcod", s_empno)	
	this.setitem(1, "cvnas", get_nm)	
	RETURN ireturn
END IF	

end event

type p_exit from w_inherite_popup`p_exit within w_plancheck_popup
boolean visible = false
integer x = 3264
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_plancheck_popup
integer x = 2395
integer y = 0
end type

event p_inq::clicked;call super::clicked;string	syymmdd, sitnbr
integer	inumqty

IF dw_jogun.AcceptText() = -1 THEN RETURN 

syymmdd = trim(dw_jogun.GetItemString(1,"yymmdd"))
sitnbr  = dw_jogun.GetItemString(1,"itnbr")
inumqty = dw_jogun.GetItemnumber(1,"numqty")

tab_1.tabpage_1.dw_2.retrieve(gs_saupj,syymmdd,inumqty,sitnbr)
tab_1.tabpage_2.dw_3.retrieve(gs_saupj,syymmdd,inumqty,sitnbr)
tab_1.tabpage_3.dw_4.retrieve(gs_saupj,syymmdd,inumqty,sitnbr)
tab_1.tabpage_4.dw_5.retrieve(gs_saupj,syymmdd,inumqty,sitnbr)
tab_1.tabpage_5.dw_6.retrieve(gs_saupj,syymmdd,inumqty,sitnbr)
end event

type p_choose from w_inherite_popup`p_choose within w_plancheck_popup
boolean visible = false
integer x = 3090
integer y = 24
end type

event p_choose::clicked;call super::clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//gs_code= dw_1.GetItemString(ll_Row, "baljpno")
//gs_codename= string(dw_1.GetItemNumber(ll_Row, "poblkt_balseq"))
//
//Close(Parent)
//
end event

type dw_1 from w_inherite_popup`dw_1 within w_plancheck_popup
boolean visible = false
integer x = 3717
integer y = 260
integer width = 389
integer height = 264
string dataobject = "d_pu04_00010_popup_1"
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

gs_code= dw_1.GetItemString(Row, "baljpno")
gs_codename= string(dw_1.GetItemNumber(Row, "poblkt_balseq"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_plancheck_popup
boolean visible = false
integer x = 1038
integer y = 2044
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_plancheck_popup
boolean visible = false
integer x = 1170
integer y = 2052
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_plancheck_popup
boolean visible = false
integer x = 1792
integer y = 2052
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_plancheck_popup
boolean visible = false
integer x = 1481
integer y = 2052
integer taborder = 20
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_plancheck_popup
boolean visible = false
integer x = 375
integer y = 2044
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_plancheck_popup
boolean visible = false
integer x = 105
integer y = 2064
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type tab_1 from tab within w_plancheck_popup
integer x = 18
integer y = 148
integer width = 2587
integer height = 1448
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2551
integer height = 1336
long backcolor = 32106727
string text = "B O M"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_1.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_1.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_1
integer width = 2546
integer height = 1340
integer taborder = 50
string title = "none"
string dataobject = "d_plancheck_popup_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type tabpage_2 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 96
integer width = 2551
integer height = 1336
long backcolor = 32106727
string text = "상  품"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_2.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_2.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_2
integer y = 72
integer width = 2551
integer height = 1264
integer taborder = 50
string title = "none"
string dataobject = "d_plancheck_popup_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type tabpage_3 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 96
integer width = 2551
integer height = 1336
long backcolor = 32106727
string text = "외주품"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_3.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_3.destroy
destroy(this.dw_4)
end on

type dw_4 from datawindow within tabpage_3
integer y = 48
integer width = 2551
integer height = 1288
integer taborder = 50
string title = "none"
string dataobject = "d_plancheck_popup_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type tabpage_4 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 96
integer width = 2551
integer height = 1336
long backcolor = 32106727
string text = "유상사급 1"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_4.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_4.destroy
destroy(this.dw_5)
end on

type dw_5 from datawindow within tabpage_4
integer y = 80
integer width = 2551
integer height = 1256
integer taborder = 50
string title = "none"
string dataobject = "d_plancheck_popup_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_5 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 96
integer width = 2551
integer height = 1336
long backcolor = 32106727
string text = "유상사급2"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_5.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_5.destroy
destroy(this.dw_6)
end on

type dw_6 from datawindow within tabpage_5
integer y = 84
integer width = 2551
integer height = 1252
integer taborder = 50
string title = "none"
string dataobject = "d_plancheck_popup_5"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

