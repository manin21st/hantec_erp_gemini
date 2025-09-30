$PBExportHeader$w_pdm_01287.srw
$PBExportComments$신제품평가부서 등록
forward
global type w_pdm_01287 from window
end type
type p_exit from uo_picture within w_pdm_01287
end type
type p_can from uo_picture within w_pdm_01287
end type
type p_del from uo_picture within w_pdm_01287
end type
type p_mod from uo_picture within w_pdm_01287
end type
type p_ins from uo_picture within w_pdm_01287
end type
type dw_ip from datawindow within w_pdm_01287
end type
type rr_1 from roundrectangle within w_pdm_01287
end type
type dw_list from datawindow within w_pdm_01287
end type
type str_offer_rex from structure within w_pdm_01287
end type
end forward

type str_offer_rex from structure
	string		offno
	string		rcdat
	double		offamt
	double		foramt
	double		wonamt
	boolean		flag
end type

global type w_pdm_01287 from window
integer x = 430
integer y = 600
integer width = 1778
integer height = 1084
boolean titlebar = true
string title = "신제품 평가부서 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_ins p_ins
dw_ip dw_ip
rr_1 rr_1
dw_list dw_list
end type
global w_pdm_01287 w_pdm_01287

type variables
string ls_itnbr
end variables

forward prototypes
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_required_chk (integer i);if dw_list.AcceptText() = -1 then return -1

dw_list.setitem(i, 'itemas_pyeong_itnbr', ls_itnbr)

if isnull(dw_list.GetItemString(i,'itemas_pyeong_dptno')) or &
	dw_list.GetItemString(i,'itemas_pyeong_dptno') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 평가부서]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('itemas_pyeong_dptno')
	dw_list.SetFocus()
	return -1		
end if	

if isnull(dw_list.GetItemString(i,'jcode')) or &
	dw_list.GetItemString(i,'jcode') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 집계공정코드]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('jcode')
	dw_list.SetFocus()
	return -1		
end if	

Return 1

end function

on w_pdm_01287.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_ins=create p_ins
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.dw_list=create dw_list
this.Control[]={this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_ins,&
this.dw_ip,&
this.rr_1,&
this.dw_list}
end on

on w_pdm_01287.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_ins)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.dw_list)
end on

event open;f_window_center(this)

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

ls_itnbr = Message.StringParm	

IF dw_ip.Retrieve(ls_itnbr)  < 1 then 
	messagebox('확인', '품번을 확인하세요!')
	p_exit.TriggerEvent(Clicked!)
	return 
END IF

dw_list.Retrieve(ls_itnbr)

end event

type p_exit from uo_picture within w_pdm_01287
integer x = 1577
integer y = 12
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_pdm_01287
integer x = 1403
integer y = 12
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;dw_list.retrieve(ls_itnbr)  

w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_del from uo_picture within w_pdm_01287
integer x = 1056
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;long 	curr_row

if dw_list.RowCount() < 1 then return 

curr_row = dw_list.getrow()

if curr_row > 0  then
   dw_list.deleterow(curr_row)
end if

w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_pdm_01287
integer x = 1230
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;int i

FOR i = 1 TO dw_list.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_list.update() > 0 then 
	COMMIT USING sqlca;	
ELSE	
	ROLLBACK USING sqlca;
	Return
END IF

w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_ins from uo_picture within w_pdm_01287
integer x = 882
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;long curr_row, i

curr_row = dw_list.insertrow(0)

dw_list.setcolumn('itemas_pyeong_dptno')
dw_list.setrow(curr_row)
dw_list.scrolltorow(curr_row)

dw_list.setfocus()
w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type dw_ip from datawindow within w_pdm_01287
integer x = 14
integer y = 164
integer width = 1239
integer height = 292
string dataobject = "d_pdm_01286"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdm_01287
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 460
integer width = 1728
integer height = 520
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_pdm_01287
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 472
integer width = 1705
integer height = 496
integer taborder = 50
string dataobject = "d_pdm_01287"
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(Gs_gubun)
SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() = "itemas_pyeong_dptno" THEN
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(this.getrow(), "itemas_pyeong_dptno", gs_Code)
	this.SetItem(this.getrow(), "vndmst_cvnas2", gs_Codename)
END IF

end event

event itemchanged;string sdptno, sget_name, snull
	
IF this.GetColumnName() ="itemas_pyeong_dptno" THEN
	
	sdptno = this.GetText()
	
	IF sdptno ="" OR IsNull(sdptno) THEN 
		this.SetItem(this.getrow(),"vndmst_cvnas2",snull)
		RETURN
	END IF
	
	SELECT "VNDMST"."CVNAS2"  INTO :sget_name  
     FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :sdptno  AND "VNDMST"."CVGU" = '4' ;
	  
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"vndmst_cvnas2",sget_name)
	ELSE
		messagebox('확 인', '부서코드를 확인하세요!')
		this.SetItem(1,"itemas_pyeong_dptno",snull)
		this.SetItem(1,"vndmst_cvnas2",snull)
		Return 1	
	END IF
END IF 

end event

