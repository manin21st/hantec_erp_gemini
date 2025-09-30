$PBExportHeader$w_pip10022.srw
$PBExportComments$** 제외인원 등록
forward
global type w_pip10022 from w_inherite_multi
end type
type st_2 from statictext within w_pip10022
end type
type st_name from statictext within w_pip10022
end type
type gb_5 from groupbox within w_pip10022
end type
type gb_4 from groupbox within w_pip10022
end type
type gb_3 from groupbox within w_pip10022
end type
type pb_1 from picturebutton within w_pip10022
end type
type pb_2 from picturebutton within w_pip10022
end type
type dw_lst from u_d_select_sort within w_pip10022
end type
type dw_ins from u_d_select_sort within w_pip10022
end type
type rb_1 from radiobutton within w_pip10022
end type
type rb_2 from radiobutton within w_pip10022
end type
end forward

global type w_pip10022 from w_inherite_multi
integer x = 1742
integer y = 4
integer width = 1911
integer height = 2196
string title = "제외인원 등록"
string menuname = ""
boolean controlmenu = false
boolean maxbox = false
st_2 st_2
st_name st_name
gb_5 gb_5
gb_4 gb_4
gb_3 gb_3
pb_1 pb_1
pb_2 pb_2
dw_lst dw_lst
dw_ins dw_ins
rb_1 rb_1
rb_2 rb_2
end type
global w_pip10022 w_pip10022

type variables
string sAllowanceCode,sAddSubtag,sPbTag
end variables

event open;call super::open;
String sMsgRtn

dw_lst.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)

sMsgRtn = Message.StringParm

sAddSubtag  = Left(sMsgRtn,1)
sAllowanceCode = Mid(sMsgRtn,2,2)

st_name.text = Mid(sMsgRtn,4,20)

pb_1.picturename = "C:\erpman\Image\next.gif"
pb_2.picturename = "C:\erpman\Image\prior.gif"

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

dw_ins.Retrieve(gs_company,sAllowancecode,sAddSubtag,sPbTag)
dw_lst.Retrieve(Left(gs_today,6))



end event

on w_pip10022.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_name=create st_name
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_3=create gb_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_lst=create dw_lst
this.dw_ins=create dw_ins
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_name
this.Control[iCurrent+3]=this.gb_5
this.Control[iCurrent+4]=this.gb_4
this.Control[iCurrent+5]=this.gb_3
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.dw_lst
this.Control[iCurrent+9]=this.dw_ins
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.rb_2
end on

on w_pip10022.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_name)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_lst)
destroy(this.dw_ins)
destroy(this.rb_1)
destroy(this.rb_2)
end on

type p_delrow from w_inherite_multi`p_delrow within w_pip10022
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip10022
end type

type p_search from w_inherite_multi`p_search within w_pip10022
end type

type p_ins from w_inherite_multi`p_ins within w_pip10022
end type

type p_exit from w_inherite_multi`p_exit within w_pip10022
integer x = 1655
integer y = 0
end type

type p_can from w_inherite_multi`p_can within w_pip10022
end type

type p_print from w_inherite_multi`p_print within w_pip10022
end type

type p_inq from w_inherite_multi`p_inq within w_pip10022
end type

type p_del from w_inherite_multi`p_del within w_pip10022
end type

type p_mod from w_inherite_multi`p_mod within w_pip10022
integer x = 1481
integer y = 0
end type

event p_mod::clicked;call super::clicked;
IF dw_ins.AcceptText() = -1 THEN RETURN

//IF dw_ins.RowCount() <=0 THEN RETURN

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_ins.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

		

end event

type dw_insert from w_inherite_multi`dw_insert within w_pip10022
boolean visible = false
integer x = 64
integer y = 2504
end type

type st_window from w_inherite_multi`st_window within w_pip10022
end type

type cb_append from w_inherite_multi`cb_append within w_pip10022
boolean visible = false
integer x = 238
integer y = 2692
integer width = 270
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pip10022
boolean visible = false
integer x = 1097
integer y = 2532
integer width = 270
integer taborder = 60
end type

type cb_update from w_inherite_multi`cb_update within w_pip10022
boolean visible = false
integer x = 805
integer y = 2532
integer width = 270
integer taborder = 50
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip10022
boolean visible = false
integer x = 530
integer y = 2692
integer width = 270
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip10022
boolean visible = false
integer x = 823
integer y = 2848
integer width = 270
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip10022
boolean visible = false
integer x = 110
integer y = 2840
integer taborder = 0
end type

type st_1 from w_inherite_multi`st_1 within w_pip10022
boolean visible = false
integer x = 18
integer y = 2620
integer width = 224
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip10022
boolean visible = false
integer x = 1051
integer y = 2732
integer width = 274
integer taborder = 0
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip10022
boolean visible = false
integer x = 1408
integer y = 2736
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip10022
boolean visible = false
integer x = 279
integer y = 2620
integer width = 1513
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip10022
boolean visible = false
integer x = 763
integer y = 2484
integer width = 640
integer height = 180
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip10022
boolean visible = false
integer x = 197
integer y = 2632
integer width = 645
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip10022
boolean visible = false
integer x = 0
integer y = 2568
integer width = 1792
end type

type st_2 from statictext within w_pip10022
integer x = 41
integer y = 176
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "급여항목"
boolean focusrectangle = false
end type

type st_name from statictext within w_pip10022
integer x = 297
integer y = 160
integer width = 494
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_5 from groupbox within w_pip10022
integer x = 1042
integer y = 132
integer width = 782
integer height = 120
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
borderstyle borderstyle = stylelowered!
end type

type gb_4 from groupbox within w_pip10022
integer x = 1038
integer y = 272
integer width = 791
integer height = 1784
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "제외 사원"
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_pip10022
integer x = 46
integer y = 272
integer width = 850
integer height = 1784
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "사원 현황"
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_pip10022
integer x = 919
integer y = 500
integer width = 101
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName
Long   totRow , sRow,rowcnt
int i

totrow =dw_lst.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_lst.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_lst.GetItemString(sRow, "empno")
   sEmpName    = dw_lst.GetItemString(sRow, "empname")
	
	rowcnt = dw_ins.RowCount() + 1
	
	dw_ins.insertrow(rowcnt)
	dw_ins.setitem(rowcnt, "empname",   sEmpName)
	dw_ins.setitem(rowcnt, "empno",     sEmpNo)
	dw_ins.SetItem(rowcnt,"companycode",gs_company)
	dw_ins.SetItem(rowcnt,"allowancecode",  sAllowanceCode)
	dw_ins.SetItem(rowcnt,"addsubtag",      saddsubtag)
	dw_ins.SetItem(rowcnt,"pbtag",          sPbtag)
	
	dw_lst.deleterow(sRow)
NEXT	

end event

type pb_2 from picturebutton within w_pip10022
integer x = 919
integer y = 608
integer width = 101
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName
Long    rowcnt , totRow , sRow 
int     i

totRow =dw_ins.Rowcount()

FOR i = 1 TO totRow 
	sRow = dw_ins.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_ins.GetItemString(sRow, "empno")
   sEmpName    = dw_ins.GetItemString(sRow, "empname")
	
	rowcnt = dw_lst.RowCount() + 1
	
	dw_lst.insertrow(rowcnt)
	dw_lst.setitem(rowcnt, "empname", sEmpName)
	dw_lst.setitem(rowcnt, "empno", sEmpNo)
	
	dw_ins.deleterow(sRow)
NEXT	

end event

type dw_lst from u_d_select_sort within w_pip10022
integer x = 73
integer y = 340
integer width = 795
integer height = 1684
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pip1009_1"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_ins from u_d_select_sort within w_pip10022
integer x = 1079
integer y = 340
integer width = 713
integer height = 1684
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pip10022_1"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type rb_1 from radiobutton within w_pip10022
integer x = 1152
integer y = 164
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "급여"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
sPbTag = 'P'

dw_ins.Retrieve(gs_company,sAllowancecode,sAddSubtag,sPbTag)
dw_lst.Retrieve(Left(gs_today,6))
end event

type rb_2 from radiobutton within w_pip10022
integer x = 1481
integer y = 164
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "상여"
borderstyle borderstyle = stylelowered!
end type

event clicked;
sPbTag = 'B'

dw_ins.Retrieve(gs_company,sAllowancecode,sAddSubtag,sPbTag)
dw_lst.Retrieve(Left(gs_today,6))
end event

