$PBExportHeader$w_imt_03020_1.srw
$PBExportComments$구매L/C-AMEND HISTORY
forward
global type w_imt_03020_1 from window
end type
type p_exit from uo_picture within w_imt_03020_1
end type
type p_del from uo_picture within w_imt_03020_1
end type
type dw_1 from datawindow within w_imt_03020_1
end type
type rr_1 from roundrectangle within w_imt_03020_1
end type
end forward

global type w_imt_03020_1 from window
integer x = 270
integer y = 840
integer width = 3127
integer height = 1496
boolean titlebar = true
string title = "L/C AMEND HISTORY"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_del p_del
dw_1 dw_1
rr_1 rr_1
end type
global w_imt_03020_1 w_imt_03020_1

type variables
string islcno

end variables

on w_imt_03020_1.create
this.p_exit=create p_exit
this.p_del=create p_del
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_del,&
this.dw_1,&
this.rr_1}
end on

on w_imt_03020_1.destroy
destroy(this.p_exit)
destroy(this.p_del)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;islcno = message.stringparm

dw_1.settransobject(sqlca)
if dw_1.retrieve(gs_sabu, islcno) > 0 then
	p_del.enabled = true
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
end if

gs_codename = 'N'
end event

type p_exit from uo_picture within w_imt_03020_1
integer x = 2912
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_del from uo_picture within w_imt_03020_1
integer x = 2734
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_d.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;long lrow
Decimal {2} dlcAmt, dmdamt

dw_1.accepttext()

// L/C-AMEND자료 삭제
for lrow = 1 to dw_1.rowcount()
	 if dw_1.getitemdecimal(lrow, "amendno") = 0 then continue
	 
	 if dw_1.getitemstring(Lrow, "sel") = 'N' then continue
	 dw_1.deleterow(lrow)
	 lrow = lrow - 1
Next

// L/C-AMEND NO재정의
for lrow = 1 to dw_1.rowcount()
	dw_1.setitem(lrow, "amendno", lrow - 1)
Next

// 마지막 amend사항의 L/C금액
dmdamt = dw_1.getitemdecimal(dw_1.rowcount(), "polcamta")

IF dw_1.Update() > 0		THEN
	// 저장후 마지막 AMEND자료의 변경후 L/C금액과 L/C HEAD의 금액이 일치해야함
	dlcAmt = 0
	Select polamt into :dlcamt 
	  From polchd 
	 Where sabu = :gs_sabu and polcno = :islcno;
	if dlcamt <> dmdamt then
		rollback;		
		Messagebox("자료오류", "마지막 AMEND의 금액과 현재의 L/C금액이 일치하지 않읍니다", STOPSIGN!)
		dw_1.retrieve(gs_sabu, islcno)
		return
	end if
	commit;
ELSE
	ROLLBACK;
	f_Rollback()
	return
END IF

gs_codename = 'Y'
close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type dw_1 from datawindow within w_imt_03020_1
integer x = 32
integer y = 176
integer width = 3040
integer height = 1184
integer taborder = 10
string dataobject = "d_imt_03020_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_imt_03020_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 164
integer width = 3063
integer height = 1204
integer cornerheight = 40
integer cornerwidth = 55
end type

