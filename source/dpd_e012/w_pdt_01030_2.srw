$PBExportHeader$w_pdt_01030_2.srw
$PBExportComments$MRP계산시 적용창고 및 생산팀 선택
forward
global type w_pdt_01030_2 from window
end type
type p_exit from picture within w_pdt_01030_2
end type
type p_create from picture within w_pdt_01030_2
end type
type cbx_2 from checkbox within w_pdt_01030_2
end type
type dw_2 from datawindow within w_pdt_01030_2
end type
type cbx_1 from checkbox within w_pdt_01030_2
end type
type sle_msg from singlelineedit within w_pdt_01030_2
end type
type dw_1 from datawindow within w_pdt_01030_2
end type
type rr_1 from roundrectangle within w_pdt_01030_2
end type
type rr_2 from roundrectangle within w_pdt_01030_2
end type
end forward

global type w_pdt_01030_2 from window
integer x = 123
integer y = 728
integer width = 3451
integer height = 1512
boolean titlebar = true
string title = "창고 및 생산팀 선택"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_create p_create
cbx_2 cbx_2
dw_2 dw_2
cbx_1 cbx_1
sle_msg sle_msg
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_01030_2 w_pdt_01030_2

type variables
long ilactno
end variables

on w_pdt_01030_2.create
this.p_exit=create p_exit
this.p_create=create p_create
this.cbx_2=create cbx_2
this.dw_2=create dw_2
this.cbx_1=create cbx_1
this.sle_msg=create sle_msg
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_create,&
this.cbx_2,&
this.dw_2,&
this.cbx_1,&
this.sle_msg,&
this.dw_1,&
this.rr_1,&
this.rr_2}
end on

on w_pdt_01030_2.destroy
destroy(this.p_exit)
destroy(this.p_create)
destroy(this.cbx_2)
destroy(this.dw_2)
destroy(this.cbx_1)
destroy(this.sle_msg)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;ilactno = message.doubleparm

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_1.retrieve(gs_saupj)
dw_2.retrieve(gs_saupj)

//dw_1.SetRowFocusIndicator(Hand!)
//dw_2.SetRowFocusIndicator(Hand!)
end event

type p_exit from picture within w_pdt_01030_2
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3186
integer y = 16
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;Messagebox("MRP실행", "MRP는 실행되지 않읍니다", stopsign!)
closewithreturn(parent, 'N')

end event

type p_create from picture within w_pdt_01030_2
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3003
integer y = 16
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\선택_up.gif'
end event

event clicked;dw_1.accepttext()
dw_2.accepttext()

String scode
Long	 Lrow, Lcnt

/* 창고 */
Lcnt = 0
For Lrow = 1 to dw_1.rowcount()
	 if dw_1.getitemstring(Lrow, "gubun") = 'Y' then
		 sCode = dw_1.getitemstring(Lrow, "cvcod")
		 insert into mrpsys_depot (sabu, actno, depot_no)
		 	values(:gs_sabu, :ilactno, :sCode);
			 
		 If sqlca.sqlcode <> 0 then
			 Rollback;
			 f_rollback()
			 closewithreturn(parent, 'N')
		 end if
		 
		 Lcnt = 1
			 
	 end if
Next

/* 생산팀 */
For Lrow = 1 to dw_2.rowcount()
	 if dw_2.getitemstring(Lrow, "gubun") = 'Y' then
		 sCode = dw_2.getitemstring(Lrow, "cvcod")
		 insert into mrpsys_dtl (sabu, actno, dptgu)
		 	values(:gs_sabu, :ilactno, :sCode);
		 
		 If sqlca.sqlcode <> 0 then
			 Rollback;
			 f_rollback()
			 closewithreturn(parent, 'N')
		 end if
		 
		 Lcnt = 1
		 
	 end if
Next

Commit;

if Lcnt > 0 then
	closewithreturn(parent, 'Y')
Else
	Messagebox("창고 & 생산팀 선택", &
				  "선택된 창고 및 생산팀이 없으므로 MRP는 실행되지 않읍니다", stopsign!)
	closewithreturn(parent, 'N')
End if
end event

type cbx_2 from checkbox within w_pdt_01030_2
integer x = 1934
integer y = 116
integer width = 549
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "생산팀 전체선택"
end type

event clicked;Long Lrow

if text = '생산팀 전체선택' then
	text = '생산팀 전체해제'	
	
	For Lrow = 1 to dw_2.rowcount()
		 dw_2.setitem(Lrow, "gubun", 'Y')
	Next
		
else
	text = '생산팀 전체선택'		
	For Lrow = 1 to dw_2.rowcount()
		 dw_2.setitem(Lrow, "gubun", 'N')
	Next	
end if
end event

type dw_2 from datawindow within w_pdt_01030_2
integer x = 1957
integer y = 208
integer width = 1426
integer height = 1048
integer taborder = 20
string title = "생산팀 선택"
string dataobject = "d_pdt_01030_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type cbx_1 from checkbox within w_pdt_01030_2
integer x = 18
integer y = 116
integer width = 489
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "창고 전체선택"
end type

event clicked;Long Lrow

if text = '창고 전체선택' then
	text = '창고 전체해제'	
	
	For Lrow = 1 to dw_1.rowcount()
		 dw_1.setitem(Lrow, "gubun", 'Y')
	Next
		
else
	text = '창고 전체선택'		
	For Lrow = 1 to dw_1.rowcount()
		 dw_1.setitem(Lrow, "gubun", 'N')
	Next	
end if
end event

type sle_msg from singlelineedit within w_pdt_01030_2
integer x = 27
integer y = 1296
integer width = 3378
integer height = 92
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

type dw_1 from datawindow within w_pdt_01030_2
integer x = 27
integer y = 208
integer width = 1870
integer height = 1048
integer taborder = 10
string title = "창고선택"
string dataobject = "d_pdt_02030_5_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdt_01030_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 196
integer width = 1888
integer height = 1072
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_01030_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1947
integer y = 196
integer width = 1449
integer height = 1072
integer cornerheight = 40
integer cornerwidth = 55
end type

