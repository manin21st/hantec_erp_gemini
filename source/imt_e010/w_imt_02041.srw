$PBExportHeader$w_imt_02041.srw
$PBExportComments$** 발주수정(발주특기사항 등록)
forward
global type w_imt_02041 from window
end type
type p_exit from uo_picture within w_imt_02041
end type
type p_cancel from uo_picture within w_imt_02041
end type
type p_delete from uo_picture within w_imt_02041
end type
type p_save from uo_picture within w_imt_02041
end type
type dw_detail from datawindow within w_imt_02041
end type
end forward

global type w_imt_02041 from window
integer x = 786
integer y = 588
integer width = 2194
integer height = 1008
boolean titlebar = true
string title = "발주특기사항 등록"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
dw_detail dw_detail
end type
global w_imt_02041 w_imt_02041

type variables
// 자료변경여부 검사
boolean  ib_any_typing


string    is_baljuno
end variables

on w_imt_02041.create
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.dw_detail=create dw_detail
this.Control[]={this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.dw_detail}
end on

on w_imt_02041.destroy
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.dw_detail)
end on

event open;f_window_center_response(this)

dw_detail.settransobject(sqlca)

if gs_code = "" or isnull(gs_code) then return

is_baljuno = gs_code

if dw_detail.retrieve(gs_sabu, is_baljuno) > 0 then
   dw_detail.setfocus() 	
else
	dw_detail.InsertRow(0)
	dw_detail.setitem(1, 'sabu', gs_sabu)
	dw_detail.setitem(1, 'baljpno', is_baljuno)
   dw_detail.setfocus() 	
end if	
	
	
	

end event

type p_exit from uo_picture within w_imt_02041
integer x = 1957
integer y = 4
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;close(parent)
end event

type p_cancel from uo_picture within w_imt_02041
integer x = 1783
integer y = 4
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;dw_detail.setredraw(false)

if dw_detail.retrieve(gs_sabu, is_baljuno) > 0 then
   dw_detail.setfocus() 	
else
	dw_detail.reset()
	dw_detail.InsertRow(0)
	dw_detail.setitem(1, 'sabu', gs_sabu)
	dw_detail.setitem(1, 'baljpno', is_baljuno)
   dw_detail.setfocus() 	
end if	
	
dw_detail.setredraw(true)
	
ib_any_typing =False

end event

type p_delete from uo_picture within w_imt_02041
integer x = 1609
integer y = 4
integer width = 178
integer taborder = 30
string pointer = "c:\ERPMAN\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;if f_msg_delete() = -1 then return

dw_detail.deleterow(0)
IF dw_detail.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	RETURN
END IF

close(parent)

end event

type p_save from uo_picture within w_imt_02041
integer x = 1435
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_detail.Update() > 0	THEN
	COMMIT USING sqlca;	
	ib_any_typing =False
ELSE
	ROLLBACK USING sqlca;
	Return
END IF

end event

type dw_detail from datawindow within w_imt_02041
event ue_key pbm_dwnkey
event ue_presenter pbm_dwnprocessenter
integer x = 32
integer y = 160
integer width = 2126
integer height = 736
integer taborder = 10
string dataobject = "d_imt_02041"
boolean border = false
boolean livescroll = true
end type

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event editchanged;ib_any_typing = true
end event

