$PBExportHeader$w_cic00037.srw
$PBExportComments$가공비재공평가 반영율 등록
forward
global type w_cic00037 from w_inherite
end type
type dw_1 from datawindow within w_cic00037
end type
type dw_2 from datawindow within w_cic00037
end type
type dw_3 from datawindow within w_cic00037
end type
type r_1 from rectangle within w_cic00037
end type
end forward

global type w_cic00037 from w_inherite
integer width = 4695
integer height = 2556
string title = "가공비 재공평가 반영율 등록"
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
r_1 r_1
end type
global w_cic00037 w_cic00037

type variables
string is_yymm, is_saupj
end variables

on w_cic00037.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.r_1
end on

on w_cic00037.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.r_1)
end on

event open;call super::open;dw_1.SettransObject(sqlca)
dw_2.SettransObject(sqlca)
dw_3.SettransObject(sqlca)

dw_3.retrieve()

dw_1.Insertrow(0)
dw_1.Setitem(1,"yymm", left(f_today(),6))
dw_1.SetItem(1,"saupj",  gs_saupj)

is_yymm = left(f_today(),6)

int i

if dw_2.Retrieve(is_yymm) < 1 then
	for i =1 to dw_3.rowcount()
		 dw_2.insertrow(0)
		 dw_2.Setitem(i,"opseq", dw_3.GetitemString(i, "rfgub"))
		 dw_2.Setitem(i,"workym", is_yymm)
	next
end if

end event

type dw_insert from w_inherite`dw_insert within w_cic00037
integer y = 2476
end type

type p_delrow from w_inherite`p_delrow within w_cic00037
boolean visible = false
integer x = 4453
integer y = 192
boolean enabled = false
boolean originalsize = true
end type

type p_addrow from w_inherite`p_addrow within w_cic00037
integer x = 3913
boolean originalsize = true
end type

event p_addrow::clicked;call super::clicked;int li_row



dw_2.insertrow(0)

dw_2.Setitem(dw_2.Rowcount(), "workym",   is_yymm )


end event

type p_search from w_inherite`p_search within w_cic00037
boolean visible = false
integer x = 3726
integer y = 188
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_cic00037
boolean visible = false
integer x = 4073
integer y = 188
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_cic00037
end type

type p_can from w_inherite`p_can within w_cic00037
end type

event p_can::clicked;call super::clicked;p_inq.Triggerevent(Clicked!)
end event

type p_print from w_inherite`p_print within w_cic00037
boolean visible = false
integer x = 3899
integer y = 188
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_cic00037
integer x = 3730
boolean originalsize = true
end type

event p_inq::clicked;call super::clicked;string snull
int i
SetNull(snull)

if dw_1.Accepttext() = -1 then return

is_yymm = dw_1.GetItemString(1, "yymm")
is_saupj = dw_1.GetItemString(1, "saupj")

if IsNull(is_yymm) or is_yymm = "" then 
   messagebox("확인","년월을 입력하세요!")
   dw_1.SetItem(1,"yymm", snull)
   dw_1.SetColumn("yymm")
   dw_1.Setfocus()
   return
end if

if f_datechk(is_yymm+'01') = -1 then
   messagebox("확인","년월을 확인하세요!")
   dw_1.SetItem(1,"yymm", snull)
   dw_1.SetColumn("yymm")
   dw_1.Setfocus()
   return
end if	

if dw_2.Retrieve(is_yymm, is_saupj) < 1 then
	for i =1 to dw_3.rowcount()
		 dw_2.insertrow(0)
		 dw_2.Setitem(i,"opseq", dw_3.GetitemString(i, "rfgub"))		 
		 dw_2.Setitem(i,"workym", is_yymm)
	next

end if
end event

type p_del from w_inherite`p_del within w_cic00037
boolean visible = false
integer x = 4265
integer y = 192
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_cic00037
integer x = 4091
boolean originalsize = true
end type

event p_mod::clicked;call super::clicked;

If dw_2.Update() = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	commit using sqlca;
		
Else
   messagebox("확인","자료저장시 에러!")
	Rollback;
end If


w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
end event

type cb_exit from w_inherite`cb_exit within w_cic00037
end type

type cb_mod from w_inherite`cb_mod within w_cic00037
end type

type cb_ins from w_inherite`cb_ins within w_cic00037
end type

type cb_del from w_inherite`cb_del within w_cic00037
end type

type cb_inq from w_inherite`cb_inq within w_cic00037
end type

type cb_print from w_inherite`cb_print within w_cic00037
end type

type st_1 from w_inherite`st_1 within w_cic00037
end type

type cb_can from w_inherite`cb_can within w_cic00037
end type

type cb_search from w_inherite`cb_search within w_cic00037
end type







type gb_button1 from w_inherite`gb_button1 within w_cic00037
end type

type gb_button2 from w_inherite`gb_button2 within w_cic00037
end type

type dw_1 from datawindow within w_cic00037
integer x = 1166
integer y = 32
integer width = 1966
integer height = 188
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cic0037_1"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;if this.GetColumnName() = "yymm" then
	is_yymm = this.Gettext()
	p_inq.Triggerevent(Clicked!)
end if
end event

type dw_2 from datawindow within w_cic00037
integer x = 1179
integer y = 240
integer width = 2158
integer height = 1976
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cic0037_2"
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;If CurrentRow <= 0 then
	this.SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(CurrentRow,TRUE)	
END IF
end event

type dw_3 from datawindow within w_cic00037
boolean visible = false
integer x = 105
integer y = 680
integer width = 1001
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_ref_d0"
boolean border = false
boolean livescroll = true
end type

type r_1 from rectangle within w_cic00037
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1175
integer y = 232
integer width = 2208
integer height = 2032
end type

