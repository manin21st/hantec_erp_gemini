$PBExportHeader$w_cfm_input2.srw
$PBExportComments$수주확정일 입력 박스(창고)
forward
global type w_cfm_input2 from window
end type
type p_2 from uo_picture within w_cfm_input2
end type
type p_1 from uo_picture within w_cfm_input2
end type
type st_2 from statictext within w_cfm_input2
end type
type st_1 from statictext within w_cfm_input2
end type
type dw_1 from datawindow within w_cfm_input2
end type
type rr_1 from roundrectangle within w_cfm_input2
end type
end forward

global type w_cfm_input2 from window
integer x = 1097
integer y = 916
integer width = 1349
integer height = 548
boolean titlebar = true
string title = "수주확정일 입력"
windowtype windowtype = response!
long backcolor = 32106727
p_2 p_2
p_1 p_1
st_2 st_2
st_1 st_1
dw_1 dw_1
rr_1 rr_1
end type
global w_cfm_input2 w_cfm_input2

on w_cfm_input2.create
this.p_2=create p_2
this.p_1=create p_1
this.st_2=create st_2
this.st_1=create st_1
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_2,&
this.p_1,&
this.st_2,&
this.st_1,&
this.dw_1,&
this.rr_1}
end on

on w_cfm_input2.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;string sDepotNo, sDate, sNextDate, sTime

dw_1.SetTransObject(sqlca)
dw_1.InsertRow(0)

select min(cvcod )
  into :sDepotNo
  from vndmst
 where cvgu = '5' and
       juprod = '1' and       // 완제품
/*        juhandle = '2' ;       */
       soguan = '1';

dw_1.SetItem(1,'sdate', f_today())

f_child_saupj(dw_1,'depot_no', gs_code)
f_child_saupj(dw_1,'house_no', gs_code)

//dw_1.SetItem(1,'depot_no',sDepotNo)
//dw_1.SetItem(1,'house_no',sDepotNo)

f_window_center_response(this)
end event

type p_2 from uo_picture within w_cfm_input2
integer x = 1079
integer y = 304
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;call super::clicked;Closewithreturn(Parent,'')
end event

type p_1 from uo_picture within w_cfm_input2
integer x = 901
integer y = 304
integer width = 178
string pointer = "C:\erpman\cur\confirm.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\확인_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\확인_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\확인_up.gif'
end event

event clicked;call super::clicked;string sdate,sdepot_no, sHouseNo

If dw_1.AcceptText() <> 1 Then Return

sdate = dw_1.GetItemString(1,'sdate')
If f_datechk(sdate) <> 1 Then
	f_message_chk(35,sdate)
  	dw_1.setFocus()
   Return
END IF

sdepot_no = dw_1.GetItemString(1,'depot_no')
If IsNull(sdepot_no) Or sdepot_no = '' then
	f_message_chk(1400,'[출고창고]')
  	dw_1.setFocus()
   Return
END IF

sHouseNo = dw_1.GetItemString(1,'house_no')
If IsNull(sHouseNo) Or sHouseNo = '' then
	f_message_chk(1400,'[납품창고]')
  	dw_1.setFocus()
   Return
END IF

gs_gubun = sHouseNo
Closewithreturn(Parent,sdate+sdepot_no)

end event

type st_2 from statictext within w_cfm_input2
boolean visible = false
integer x = 55
integer y = 368
integer width = 1458
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "  그렇지않으면 이송으로 처리됩니다.!!"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cfm_input2
boolean visible = false
integer x = 55
integer y = 300
integer width = 1458
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "* 출고창고와 납품창고가 동일할 경우 직납처리하며"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_cfm_input2
event ue_enter pbm_dwnprocessenter
integer x = 32
integer y = 48
integer width = 1147
integer height = 212
integer taborder = 10
string dataobject = "d_cfm_input"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sDate, sNull

SetNull(sNull)

Choose Case GetColumnName()
	Case 'sdate'
//		/* 일자 변경불가 */
//		Return 2
		
		/* 일자 변경가능 */
		sDate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'[일자]')
      	SetItem(1,'sdate',sNull)
	      Return 1
      END IF
	// 출고창고 변경시 납품창고도 같이 변경한다
	Case 'depot_no'
		SetItem(1, 'house_no', GetText())
End Choose

end event

type rr_1 from roundrectangle within w_cfm_input2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 28
integer width = 1275
integer height = 244
integer cornerheight = 40
integer cornerwidth = 55
end type

