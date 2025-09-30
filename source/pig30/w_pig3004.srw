$PBExportHeader$w_pig3004.srw
$PBExportComments$차량운행 총무확인 등록
forward
global type w_pig3004 from w_inherite_standard
end type
type dw_2 from datawindow within w_pig3004
end type
type st_2 from statictext within w_pig3004
end type
type em_frdate from editmask within w_pig3004
end type
type st_3 from statictext within w_pig3004
end type
type em_todate from editmask within w_pig3004
end type
type rb_1 from radiobutton within w_pig3004
end type
type rb_2 from radiobutton within w_pig3004
end type
type gb_3 from groupbox within w_pig3004
end type
type rr_1 from roundrectangle within w_pig3004
end type
type rr_2 from roundrectangle within w_pig3004
end type
end forward

global type w_pig3004 from w_inherite_standard
string title = "차량운행일자 총무 확인"
dw_2 dw_2
st_2 st_2
em_frdate em_frdate
st_3 st_3
em_todate em_todate
rb_1 rb_1
rb_2 rb_2
gb_3 gb_3
rr_1 rr_1
rr_2 rr_2
end type
global w_pig3004 w_pig3004

type variables
string is_empno,is_empname
end variables

on w_pig3004.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.st_2=create st_2
this.em_frdate=create em_frdate
this.st_3=create st_3
this.em_todate=create em_todate
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_3=create gb_3
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.em_frdate
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.em_todate
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_pig3004.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.em_frdate)
destroy(this.st_3)
destroy(this.em_todate)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_3)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;long row
string first_day,last_day

dw_2.SetTransObject(sqlca)

// 운행일자 초기화 당월의 첫일과 마지막일자로..
select to_char(sysdate,'yyyymm') || '01', 
       to_char(last_day(sysdate),'yyyymmdd')
  into :first_day,:last_day		 
  from dual;
  
em_frdate.Text = first_day
em_todate.Text = last_day

ib_any_typing = False

end event

type p_mod from w_inherite_standard`p_mod within w_pig3004
integer x = 3895
end type

event p_mod::clicked;call super::clicked;int row
string carno,drvdayfr,driver

dw_2.AcceptText()

If dw_2.Update() = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	commit using sqlca;
Else
   f_message_chk(37,sqlca.sqlerrtext) //동일자료 발생
	Rollback;
end If

end event

type p_del from w_inherite_standard`p_del within w_pig3004
integer x = 4069
end type

event p_del::clicked;call super::clicked;int row 

row = dw_2.GetRow()
If row = 0 Then Return

IF Messagebox("삭제 확인", "차량운행정보가 삭제됩니다 ~n"+&
					"계속하시겠습니까?", question!, yesno!) = 2 then Return

dw_2.DeleteRow(row)
If dw_2.Update() = 1 Then
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
	Commit;
Else
	Rollback;
End If

end event

type p_inq from w_inherite_standard`p_inq within w_pig3004
integer x = 3547
end type

event p_inq::clicked;call super::clicked;string fr_date,to_date

fr_date = Left(em_frdate.Text,4) + Mid(em_frdate.Text,6,2) + Right(em_frdate.Text,2)
to_date = Left(em_todate.Text,4) + Mid(em_todate.Text,6,2) + Right(em_todate.Text,2)

If f_datechk(fr_date) = -1 or f_datechk(to_date) = -1 Then
   MessageBox("확 인"," 메 세 지  : 운행일자 오류~n~n" +&
		                " 처리방안  : 운행일자를 확인하세요", Exclamation! )
End If

dw_2.Retrieve(fr_date,to_date)

end event

type p_print from w_inherite_standard`p_print within w_pig3004
integer x = 3077
integer y = 6024
end type

type p_can from w_inherite_standard`p_can within w_pig3004
integer x = 4242
end type

type p_exit from w_inherite_standard`p_exit within w_pig3004
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pig3004
integer x = 3721
end type

type p_search from w_inherite_standard`p_search within w_pig3004
integer x = 2903
integer y = 6024
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig3004
integer x = 3598
integer y = 6024
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig3004
integer x = 3771
integer y = 6024
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig3004
integer x = 270
integer y = 5164
end type

type st_window from w_inherite_standard`st_window within w_pig3004
integer x = 2363
integer y = 5912
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig3004
integer x = 3163
integer y = 5740
integer taborder = 90
end type

type cb_update from w_inherite_standard`cb_update within w_pig3004
integer x = 2432
integer y = 5740
integer taborder = 60
end type

event cb_update::clicked;call super::clicked;int row
string carno,drvdayfr,driver

dw_2.AcceptText()

If dw_2.Update() = 1 Then
   ib_any_typing = False
	sle_msg.text ="자료를 저장하였습니다!!"
	commit using sqlca;
Else
   f_message_chk(37,sqlca.sqlerrtext) //동일자료 발생
	Rollback;
end If

end event

type cb_insert from w_inherite_standard`cb_insert within w_pig3004
boolean visible = false
integer x = 1221
integer y = 5456
integer width = 361
integer taborder = 50
string text = "추가(&I)"
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig3004
integer x = 2798
integer y = 5740
integer taborder = 70
end type

event cb_delete::clicked;call super::clicked;int row 

row = dw_2.GetRow()
If row = 0 Then Return

IF Messagebox("삭제 확인", "차량운행정보가 삭제됩니다 ~n"+&
					"계속하시겠습니까?", question!, yesno!) = 2 then Return

dw_2.DeleteRow(row)
If dw_2.Update() = 1 Then
	sle_msg.text ="자료를 삭제하였습니다!!"
	Commit;
Else
	Rollback;
End If

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig3004
integer x = 379
integer y = 5068
integer taborder = 100
end type

event cb_retrieve::clicked;call super::clicked;string fr_date,to_date

fr_date = Left(em_frdate.Text,4) + Mid(em_frdate.Text,6,2) + Right(em_frdate.Text,2)
to_date = Left(em_todate.Text,4) + Mid(em_todate.Text,6,2) + Right(em_todate.Text,2)

If f_datechk(fr_date) = -1 or f_datechk(to_date) = -1 Then
   MessageBox("확 인"," 메 세 지  : 운행일자 오류~n~n" +&
		                " 처리방안  : 운행일자를 확인하세요", Exclamation! )
End If

dw_2.Retrieve(fr_date,to_date)

end event

type st_1 from w_inherite_standard`st_1 within w_pig3004
integer x = 197
integer y = 5912
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig3004
boolean visible = false
integer x = 2793
integer y = 5392
integer taborder = 80
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pig3004
integer x = 3008
integer y = 5912
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig3004
integer x = 526
integer y = 5912
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig3004
integer x = 2373
integer y = 5680
integer width = 1175
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig3004
integer x = 293
integer y = 5016
integer width = 709
integer height = 180
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig3004
integer x = 178
integer y = 5860
end type

type dw_2 from datawindow within w_pig3004
integer x = 165
integer y = 340
integer width = 4133
integer height = 1948
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig1003_07"
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
end event

type st_2 from statictext within w_pig3004
integer x = 242
integer y = 164
integer width = 297
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "운행일자"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_frdate from editmask within w_pig3004
integer x = 590
integer y = 156
integer width = 357
integer height = 52
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 33554432
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
string mask = "####.##.##"
end type

type st_3 from statictext within w_pig3004
integer x = 955
integer y = 160
integer width = 119
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_todate from editmask within w_pig3004
integer x = 1079
integer y = 156
integer width = 357
integer height = 52
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 33554432
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
string mask = "####.##.##"
end type

type rb_1 from radiobutton within w_pig3004
integer x = 1595
integer y = 168
integer width = 494
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "업무용 차량"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_2.DataObject = 'd_pig1003_07'
dw_2.SetTransObject(sqlca)
end event

type rb_2 from radiobutton within w_pig3004
integer x = 2048
integer y = 168
integer width = 498
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "비업무용 차량"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_2.DataObject = 'd_pig1003_08'
dw_2.SetTransObject(sqlca)
end event

type gb_3 from groupbox within w_pig3004
integer x = 1563
integer y = 108
integer width = 1010
integer height = 152
integer taborder = 60
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

type rr_1 from roundrectangle within w_pig3004
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 155
integer y = 68
integer width = 2551
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pig3004
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 155
integer y = 332
integer width = 4151
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

