$PBExportHeader$w_pdt_07300.srw
$PBExportComments$자동생성전송취소화면
forward
global type w_pdt_07300 from window
end type
type p_4 from uo_picture within w_pdt_07300
end type
type p_3 from uo_picture within w_pdt_07300
end type
type p_2 from uo_picture within w_pdt_07300
end type
type p_1 from uo_picture within w_pdt_07300
end type
type st_1 from statictext within w_pdt_07300
end type
type dw_1 from datawindow within w_pdt_07300
end type
type rr_1 from roundrectangle within w_pdt_07300
end type
end forward

global type w_pdt_07300 from window
integer x = 160
integer y = 72
integer width = 4155
integer height = 2324
boolean titlebar = true
string title = "구매 전송 취소"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_4 p_4
p_3 p_3
p_2 p_2
p_1 p_1
st_1 st_1
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_07300 w_pdt_07300

type variables
string is_date
end variables

on w_pdt_07300.create
this.p_4=create p_4
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.st_1=create st_1
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_4,&
this.p_3,&
this.p_2,&
this.p_1,&
this.st_1,&
this.dw_1,&
this.rr_1}
end on

on w_pdt_07300.destroy
destroy(this.p_4)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;is_date = gs_code

dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu, is_date)

IF f_change_name('1') = 'Y' then 
   dw_1.object.ispec_t.text = f_change_name('2')
   dw_1.object.jijil_t.text = f_change_name('3')
END IF
end event

type p_4 from uo_picture within w_pdt_07300
integer x = 3406
integer y = 12
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\전체선택_up.gif"
end type

event clicked;call super::clicked;Long Lrow

if this.pictureName = 'c:\erpman\image\전체선택_up.gif' then
	this.pictureName = 'c:\erpman\image\전체해제_up.gif'
	For Lrow = 1 to dw_1.rowcount()
		 if dw_1.getitemstring(Lrow, "estima_blynd") <> '3' then // 발주가 안된 검토내역만 가능
		 	 dw_1.setitem(Lrow, "choice", 'Y')
		 end if
   Next
else
	this.pictureName = 'c:\erpman\image\전체선택_up.gif'	
	For Lrow = 1 to dw_1.rowcount()
		 if dw_1.getitemstring(Lrow, "estima_blynd") <> '3' then // 발주가 안된 검토내역만 가능
		 	 dw_1.setitem(Lrow, "choice", 'N')
		 end if
   Next	
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;if pictureName = "c:\erpman\image\전체선택_up.gif" then
	pictureName = "c:\erpman\image\전체선택_dn.gif"
else
	pictureName = "c:\erpman\image\전체해제_dn.gif"
end if

end event

event ue_lbuttonup;call super::ue_lbuttonup;if pictureName = "c:\erpman\image\전체선택_up.gif" or &
   pictureName = "c:\erpman\image\전체선택_dn.gif" then
	pictureName = "c:\erpman\image\전체선택_up.gif"
else
	pictureName = "c:\erpman\image\전체해제_up.gif"
end if

end event

type p_3 from uo_picture within w_pdt_07300
integer x = 3927
integer y = 16
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\닫기_up.gif"
end type

event clicked;CLOSE(PARENT)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\닫기_dn.gif"
end event

type p_2 from uo_picture within w_pdt_07300
integer x = 3753
integer y = 16
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\저장_up.gif"
end type

event clicked;if dw_1.accepttext() = -1 then return

Long Lrow
String sEstno, sChoice

Setpointer(hourglass!)

st_1.enabled = true

For Lrow = 1 to dw_1.rowcount()
	 sChoice = dw_1.getitemstring(Lrow, "choice")
	 sEstno 	= dw_1.getitemstring(Lrow, "estno")
	 if sChoice = 'Y' then
		 // 생산 검토내역의 전송내역을 취소한다
		 Update estima_examination
		 	 Set blynd = '2'
		  Where sabu = :gs_sabu And estno = :sEstno;
		 if sqlca.sqlcode <> 0 then
			 rollback;
			 f_rollback()
			 Setpointer(Arrow!)			 
			 return
		 End if		  
		  
		 // 발주검토내역을 삭제한다
		 Delete From estima
		  Where sabu = :gs_sabu And estno = :sEstno;		

		 if sqlca.sqlcode <> 0 then
			 rollback;
			 f_rollback()
			 Setpointer(Arrow!)
			 return
		 End if
	 End if
NExt

Commit;

MessageBox("저장완료", "저장이 완료되었읍니다")

p_3.triggerevent(clicked!)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\저장_dn.gif"
end event

type p_1 from uo_picture within w_pdt_07300
integer x = 3579
integer y = 12
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\조회_up.gif"
end type

event clicked;dw_1.retrieve(gs_sabu, is_date)


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\조회_dn.gif"
end event

type st_1 from statictext within w_pdt_07300
boolean visible = false
integer x = 146
integer y = 2592
integer width = 1682
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
boolean enabled = false
string text = "자료내역을 취소중입니다. 잠시만 기다려 주십시요.....!!!"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pdt_07300
integer x = 37
integer y = 196
integer width = 4037
integer height = 1972
integer taborder = 10
string dataobject = "d_pdt_07200_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pdt_07300
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 180
integer width = 4096
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

