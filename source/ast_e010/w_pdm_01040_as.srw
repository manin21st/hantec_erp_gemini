$PBExportHeader$w_pdm_01040_as.srw
$PBExportComments$** 거래처 등록(애로 및 요청등록)
forward
global type w_pdm_01040_as from window
end type
type p_exit from uo_picture within w_pdm_01040_as
end type
type p_can from uo_picture within w_pdm_01040_as
end type
type p_del from uo_picture within w_pdm_01040_as
end type
type p_mod from uo_picture within w_pdm_01040_as
end type
type dw_detail from datawindow within w_pdm_01040_as
end type
end forward

global type w_pdm_01040_as from window
integer x = 864
integer y = 540
integer width = 2240
integer height = 1132
boolean titlebar = true
string title = "애로 및 요청사항 등록 및 수정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
dw_detail dw_detail
end type
global w_pdm_01040_as w_pdm_01040_as

type variables
str_customer istr_cust

// 자료변경여부 검사
boolean  ib_any_typing
end variables

on w_pdm_01040_as.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.dw_detail=create dw_detail
this.Control[]={this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.dw_detail}
end on

on w_pdm_01040_as.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.dw_detail)
end on

event open;f_window_center(this)

istr_cust = Message.PowerObjectParm

dw_detail.settransobject(sqlca)

if dw_detail.retrieve(istr_cust.st_custno, istr_cust.st_seq) > 0 then
   dw_detail.setfocus() 	
else
	dw_detail.InsertRow(0)
	dw_detail.setitem(1, 'cust_no', istr_cust.st_custno)
	dw_detail.setitem(1, 'seq', istr_cust.st_seq)
   dw_detail.setfocus() 	
end if	
	
	
	

end event

type p_exit from uo_picture within w_pdm_01040_as
integer x = 1993
integer width = 178
integer taborder = 50
string pointer = "c:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
close(parent)
end event

type p_can from uo_picture within w_pdm_01040_as
integer x = 1819
integer width = 178
integer taborder = 40
string pointer = "c:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;dw_detail.setredraw(false)

if dw_detail.retrieve(istr_cust.st_custno, istr_cust.st_seq) > 0 then
   dw_detail.setfocus() 	
else
   dw_detail.reset()
	dw_detail.InsertRow(0)
	dw_detail.setitem(1, 'cust_no', istr_cust.st_custno)
	dw_detail.setitem(1, 'seq',  istr_cust.st_seq)
   dw_detail.setfocus() 	
end if	
	
dw_detail.setredraw(true)
	
ib_any_typing =False

end event

type p_del from uo_picture within w_pdm_01040_as
integer x = 1646
integer width = 178
integer taborder = 30
string pointer = "c:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

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

type p_mod from uo_picture within w_pdm_01040_as
integer x = 1472
integer width = 178
integer taborder = 20
string pointer = "c:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;if dw_detail.AcceptText() = -1 then return 

if isnull(trim(dw_detail.GetItemString(1,'asdate'))) or &
	trim(dw_detail.GetItemString(1,'asdate')) = "" then
	f_message_chk(1400,'[접수일자]')
	dw_detail.SetColumn('asdate')
	dw_detail.SetFocus()
	return 		
end if	

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_detail.Update() > 0	THEN
	COMMIT USING sqlca;	
	ib_any_typing =False
ELSE
	ROLLBACK USING sqlca;
	Return
END IF

end event

type dw_detail from datawindow within w_pdm_01040_as
event ue_key pbm_dwnkey
event ue_presenter pbm_dwnprocessenter
integer x = 27
integer y = 144
integer width = 2167
integer height = 880
integer taborder = 10
string dataobject = "d_pdm_01040_as"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event ue_presenter;IF this.GetColumnName() = 'aslst' or this.GetColumnName() = 'asresult'  THEN RETURN 

Send( Handle(this), 256, 9, 0 )
Return 1

end event

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

event itemerror;return 1
end event

event itemchanged;string s_date, snull, sempno, sget_name

setnull(snull)

IF this.GetColumnName() = 'asdate' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[접수일자]')
		this.SetItem(1,"asdate",snull)
		this.Setcolumn("asdate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() ="empid" THEN
	
	sempno = this.GetText()
	
	IF sempno ="" OR IsNull(sempno) THEN 
		this.SetItem(1,"p1_master_empname",snull)
		RETURN
	END IF
	
	SELECT "P1_MASTER"."EMPNAME"  
     INTO :sget_name  
     FROM "P1_MASTER"  
    WHERE ( "P1_MASTER"."EMPNO" = :sempno ) AND  
          ( "P1_MASTER"."SERVICEKINDCODE" <> '3' )   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"p1_master_empname",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(1,"empid",snull)
			this.SetItem(1,"p1_master_empname",snull)
		END IF
		
		Return 1	
	END IF
END IF	
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() = "empid" THEN
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "empid", gs_Code)
	this.SetItem(1, "p1_master_empname", gs_Codename)
END IF
end event

