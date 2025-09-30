$PBExportHeader$w_kgla071.srw
$PBExportComments$월할 선급비용 등록-조회 선택
forward
global type w_kgla071 from window
end type
type p_inq from uo_picture within w_kgla071
end type
type p_can from uo_picture within w_kgla071
end type
type p_search from uo_picture within w_kgla071
end type
type dw_1 from u_key_enter within w_kgla071
end type
type cb_3 from commandbutton within w_kgla071
end type
type cb_2 from commandbutton within w_kgla071
end type
type cb_1 from commandbutton within w_kgla071
end type
type dw_2 from datawindow within w_kgla071
end type
type gb_1 from groupbox within w_kgla071
end type
type rr_1 from roundrectangle within w_kgla071
end type
end forward

global type w_kgla071 from window
integer x = 46
integer y = 48
integer width = 3657
integer height = 2128
boolean titlebar = true
string title = "해당자료를 선택하세요!!"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_inq p_inq
p_can p_can
p_search p_search
dw_1 dw_1
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_2 dw_2
gb_1 gb_1
rr_1 rr_1
end type
global w_kgla071 w_kgla071

on w_kgla071.create
this.p_inq=create p_inq
this.p_can=create p_can
this.p_search=create p_search
this.dw_1=create dw_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_2=create dw_2
this.gb_1=create gb_1
this.rr_1=create rr_1
this.Control[]={this.p_inq,&
this.p_can,&
this.p_search,&
this.dw_1,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_2,&
this.gb_1,&
this.rr_1}
end on

on w_kgla071.destroy
destroy(this.p_inq)
destroy(this.p_can)
destroy(this.p_search)
destroy(this.dw_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;String sAccDate

F_Window_Center_Response(This)

sAccDate = Message.StringParm

dw_1.SetTransObject(Sqlca)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(1,"accdate",sAccDate)
dw_1.SetFocus()

dw_2.settransobject(sqlca)


end event

type p_inq from uo_picture within w_kgla071
integer x = 3058
integer y = 24
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;string s_date, s_date2, snull

setnull(snull)

dw_1.AcceptText()
s_date  = Trim(dw_1.GetItemString(1,"accdate"))

if isnull(s_date) or s_date = "" then 
  SELECT MIN("KFZ31OT0"."ACC_DATE")  
    INTO :s_date  
    FROM "KFZ31OT0"  ;
end if

	SELECT MAX("KFZ31OT0"."ACC_DATE")  
    INTO :s_date2  
    FROM "KFZ31OT0"  ;

//// <조회> /////////////////////////////////////////////////////////
IF dw_2.retrieve(s_date, s_date2) <= 0 THEN
   F_MessageChk(14,'[월할 선급비용자료 조회]')
	dw_1.SetFocus()
	SetPointer(Arrow!)
	Return
else
	dw_2.setfocus()
END IF
SetPointer(Arrow!)
end event

type p_can from uo_picture within w_kgla071
integer x = 3415
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

type p_search from uo_picture within w_kgla071
integer x = 3237
integer y = 24
integer width = 178
integer taborder = 90
string picturename = "C:\Erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;int row 

row = dw_2.GetRow()

IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 조회한후 [선택]을 누르십시오 !")
   return
END IF

lstr_jpra.saupjang = dw_2.GetItemString(Row,"saupj")
lstr_jpra.accdate  = dw_2.GetItemString(Row,"acc_date")
lstr_jpra.junno    = dw_2.GetItemnumber(Row,"jun_no")
lstr_jpra.sortno   = dw_2.GetItemnumber(Row,"lin_no")
lstr_jpra.upmugu   = dw_2.GetItemString(Row,"upmu_gu")
lstr_jpra.baldate  = dw_2.GetItemString(Row,"bal_date")
lstr_jpra.bjunno   = dw_2.GetItemnumber(Row,"bjun_no")

Close(Parent)


end event

event ue_lbuttondown;PictureName = "C:\Erpman\image\선택_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\Erpman\image\선택_up.gif"
end event

type dw_1 from u_key_enter within w_kgla071
integer x = 9
integer y = 20
integer width = 951
integer height = 168
integer taborder = 10
string dataobject = "dw_kgla071_02"
boolean border = false
end type

type cb_3 from commandbutton within w_kgla071
boolean visible = false
integer x = 3099
integer y = 2312
integer width = 361
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&X)"
end type

event clicked;close(parent)
end event

type cb_2 from commandbutton within w_kgla071
boolean visible = false
integer x = 2706
integer y = 2312
integer width = 361
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&C)"
end type

event clicked;int row 

row = dw_2.GetRow()

IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 조회한후 [선택]을 누르십시오 !")
   return
END IF

lstr_jpra.saupjang = dw_2.GetItemString(Row,"saupj")
lstr_jpra.accdate  = dw_2.GetItemString(Row,"acc_date")
lstr_jpra.junno    = dw_2.GetItemnumber(Row,"jun_no")
lstr_jpra.sortno   = dw_2.GetItemnumber(Row,"lin_no")
lstr_jpra.upmugu   = dw_2.GetItemString(Row,"upmu_gu")
lstr_jpra.baldate  = dw_2.GetItemString(Row,"bal_date")
lstr_jpra.bjunno   = dw_2.GetItemnumber(Row,"bjun_no")

Close(Parent)


end event

type cb_1 from commandbutton within w_kgla071
boolean visible = false
integer x = 2313
integer y = 2312
integer width = 361
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
boolean default = true
end type

event clicked;string s_date, s_date2, snull

setnull(snull)

dw_1.AcceptText()
s_date  = Trim(dw_1.GetItemString(1,"accdate"))

if isnull(s_date) or s_date = "" then 
  SELECT MIN("KFZ31OT0"."ACC_DATE")  
    INTO :s_date  
    FROM "KFZ31OT0"  ;
end if

	SELECT MAX("KFZ31OT0"."ACC_DATE")  
    INTO :s_date2  
    FROM "KFZ31OT0"  ;

//// <조회> /////////////////////////////////////////////////////////
IF dw_2.retrieve(s_date, s_date2) <= 0 THEN
   F_MessageChk(14,'[월할 선급비용자료 조회]')
	dw_1.SetFocus()
	SetPointer(Arrow!)
	Return
else
	dw_2.setfocus()
END IF
SetPointer(Arrow!)
end event

type dw_2 from datawindow within w_kgla071
event ue_keyenter pbm_dwnprocessenter
integer x = 32
integer y = 216
integer width = 3543
integer height = 1792
integer taborder = 20
string dataobject = "dw_kgla071_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keyenter;cb_2.TriggerEvent(Clicked!)
end event

event clicked;If Row <= 0 then
	dw_2.SelectRow(0,False)
ELSE
	dw_2.SelectRow(0,False)
	dw_2.SelectRow(row,True)
END IF

end event

event rowfocuschanged;dw_2.SelectRow(0,False)
dw_2.SelectRow(currentrow,True)
dw_2.ScrollToRow(currentrow)
end event

event doubleclicked;
IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 조회한후 [선택]을 누르십시오 !")
   return
END IF

lstr_jpra.saupjang = dw_2.GetItemString(Row,"saupj")
lstr_jpra.accdate  = dw_2.GetItemString(Row,"acc_date")
lstr_jpra.junno    = dw_2.GetItemnumber(Row,"jun_no")
lstr_jpra.sortno   = dw_2.GetItemnumber(Row,"lin_no")
lstr_jpra.upmugu   = dw_2.GetItemString(Row,"upmu_gu")
lstr_jpra.baldate  = dw_2.GetItemString(Row,"bal_date")
lstr_jpra.bjunno   = dw_2.GetItemnumber(Row,"bjun_no")

Close(Parent)
end event

type gb_1 from groupbox within w_kgla071
boolean visible = false
integer x = 2249
integer y = 2252
integer width = 1257
integer height = 196
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_1 from roundrectangle within w_kgla071
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 212
integer width = 3575
integer height = 1808
integer cornerheight = 40
integer cornerwidth = 46
end type

