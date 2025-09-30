$PBExportHeader$w_sm04_00101_popup.srw
$PBExportComments$추정 손익 현황
forward
global type w_sm04_00101_popup from window
end type
type st_2 from statictext within w_sm04_00101_popup
end type
type p_exit from uo_picture within w_sm04_00101_popup
end type
type p_can from uo_picture within w_sm04_00101_popup
end type
type p_print from uo_picture within w_sm04_00101_popup
end type
type p_mod from uo_picture within w_sm04_00101_popup
end type
type st_1 from statictext within w_sm04_00101_popup
end type
type cb_1 from commandbutton within w_sm04_00101_popup
end type
type cb_exit from commandbutton within w_sm04_00101_popup
end type
type cb_cancel from commandbutton within w_sm04_00101_popup
end type
type cb_save from commandbutton within w_sm04_00101_popup
end type
type dw_1 from datawindow within w_sm04_00101_popup
end type
type rr_1 from roundrectangle within w_sm04_00101_popup
end type
end forward

global type w_sm04_00101_popup from window
integer x = 59
integer y = 124
integer width = 4233
integer height = 1908
boolean titlebar = true
string title = "투입자재 상세"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
st_2 st_2
p_exit p_exit
p_can p_can
p_print p_print
p_mod p_mod
st_1 st_1
cb_1 cb_1
cb_exit cb_exit
cb_cancel cb_cancel
cb_save cb_save
dw_1 dw_1
rr_1 rr_1
end type
global w_sm04_00101_popup w_sm04_00101_popup

type variables
str_05000 istr_05000
decimal idamt
end variables

on w_sm04_00101_popup.create
this.st_2=create st_2
this.p_exit=create p_exit
this.p_can=create p_can
this.p_print=create p_print
this.p_mod=create p_mod
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_exit=create cb_exit
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.st_2,&
this.p_exit,&
this.p_can,&
this.p_print,&
this.p_mod,&
this.st_1,&
this.cb_1,&
this.cb_exit,&
this.cb_cancel,&
this.cb_save,&
this.dw_1,&
this.rr_1}
end on

on w_sm04_00101_popup.destroy
destroy(this.st_2)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_print)
destroy(this.p_mod)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_exit)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;//istr_05000 = message.powerobjectparm
long damt

f_window_center_response(this) 

dw_1.settransobject(sqlca)

st_1.text = gs_codename

	// 재료비 내역을 계산하기 위한 funtion 실행
DECLARE proc1 procedure FOR ERP_CALC_PSTRUC2 (gs_code, 1, gs_gubun + '32', '1') USING SQLCA;
EXECUTE proc1;
FETCH proc1 INTO :dAmt;
CLOSE proc1;

IF dw_1.Retrieve(gs_code) = -1 THEN
	f_message_chk(50,'')
	dw_1.setredraw(true)
	return -1
end if

dw_1.Object.t_itnbr.text = gs_code



end event

type st_2 from statictext within w_sm04_00101_popup
integer x = 59
integer y = 236
integer width = 457
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "▣ 상세내역"
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_sm04_00101_popup
integer x = 4000
integer y = 36
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

//close(parent)

CloseWithReturn(parent, '2')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_sm04_00101_popup
boolean visible = false
integer x = 1687
integer y = 1776
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_print from uo_picture within w_sm04_00101_popup
boolean visible = false
integer x = 1513
integer y = 1776
integer width = 178
integer taborder = 100
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type p_mod from uo_picture within w_sm04_00101_popup
boolean visible = false
integer x = 1339
integer y = 1776
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type st_1 from statictext within w_sm04_00101_popup
integer x = 50
integer y = 116
integer width = 2203
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_sm04_00101_popup
boolean visible = false
integer x = 1861
integer y = 2468
integer width = 517
integer height = 104
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "출력(&P)"
end type

event clicked;dw_1.print()


end event

type cb_exit from commandbutton within w_sm04_00101_popup
boolean visible = false
integer x = 2921
integer y = 2468
integer width = 517
integer height = 104
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;close(parent)
end event

type cb_cancel from commandbutton within w_sm04_00101_popup
boolean visible = false
integer x = 2391
integer y = 2468
integer width = 517
integer height = 104
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;string sgijun
long   lCount

select dataname
  into :sgijun
  from syscnfg
 where sysgu = 'Y' and serial = 23 and lineno = '1';

if sgijun = '' or isnull(sgijun) then sgijun = '1'  //기본 검사일자로 셋팅

// 2000.06.23 유 local 은 사용안함
IF sgijun = '2' THEN  							//승인일자 기준
	dw_1.DataObject = 'd_pdt_05004_1'  
	st_1.text = '일자기준 : [승인일자 기준]'
ELSE 													//검사일자 기준
	dw_1.DataObject = 'd_pdt_05004'
	st_1.text = '일자기준 : [검사일자 기준]'
END IF
dw_1.SetTransObject(SQLCA)

lCount = dw_1.retrieve(istr_05000.sabu,  istr_05000.mayymm, istr_05000.mayysq, &
							  istr_05000.cvcod, istr_05000.sdate,  istr_05000.edate,  &
							  istr_05000.gubun, istr_05000.saupj )
if lCount < 1 then
	Messagebox("마감내역", "조회할 내역이 없읍니다", stopsign!)
	Close(parent)
	return
end if

if istr_05000.move_yn = 'Y' then 
	cb_save.Enabled = false
else	
	cb_save.Enabled = true
end if   


end event

type cb_save from commandbutton within w_sm04_00101_popup
boolean visible = false
integer x = 1330
integer y = 2468
integer width = 517
integer height = 104
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;Dec{0}  dAmt, dgongamt, dipamt
Long	  Lrow, Lcrow
Datawindow	dwchk

dwchk = istr_05000.dwname
Lcrow = istr_05000.lrow

// 구분이 old와 new가 동일하면  status를 
For Lrow = 1 to dw_1.rowcount()
	 if dw_1.getitemstring(Lrow, "gubun") = dw_1.getitemstring(Lrow, "old_gubun") then
		 dw_1.SetItemStatus(Lrow, 0, Primary!, NotModified!)
	 end if
Next

if dw_1.update() = 1 then
	dAmt = 0
	For Lrow = 1 to dw_1.rowcount()
		 if dw_1.getitemstring(Lrow, "gubun") = 'Y' then
			 dAmt     = dAmt + dw_1.getitemdecimal(lrow, "imhist_ioamt")
			 dgongamt = dgongamt + dw_1.getitemdecimal(lrow, "gongamt")
			 dipamt   = dipamt + dw_1.getitemdecimal(lrow, "ipamt")
			 
		 End if
	Next
	if dwchk.getitemdecimal(lcrow, "maamt") <> damt or &
	   dwchk.getitemdecimal(lcrow, "gongamt") <> dgongamt or &
		dwchk.getitemdecimal(lcrow, "ipamt") <> dipamt  then
		dwchk.setitem(lcrow, "maamt", damt)
		dwchk.setitem(lcrow, "gongamt", dgongamt)
		dwchk.setitem(lcrow, "ipamt", dipamt)
		dwchk.setitem(lcrow, "mavat", truncate(damt * 0.1, 0))
	end if
	
	close(parent)
else
	rollback ;
	f_rollback()
end if

end event

type dw_1 from datawindow within w_sm04_00101_popup
integer x = 46
integer y = 292
integer width = 4110
integer height = 1388
integer taborder = 20
string dataobject = "d_imt_02510_5_p"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;String sNull
Setnull(sNull)

if this.getcolumnname() = 'gubun' then
	if data = 'N' then
		this.setitem(row, "mayymm", snull)
		this.setitem(row, "mayysq", 0)
	else
		this.setitem(row, "mayymm", istr_05000.mayymm)
		this.setitem(row, "mayysq", istr_05000.mayysq)
	end if
end if
end event

type rr_1 from roundrectangle within w_sm04_00101_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 212
integer width = 4151
integer height = 1484
integer cornerheight = 40
integer cornerwidth = 46
end type

