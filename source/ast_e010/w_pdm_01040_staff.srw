$PBExportHeader$w_pdm_01040_staff.srw
$PBExportComments$** 거래처 등록(임직원 등록)
forward
global type w_pdm_01040_staff from window
end type
type p_exit from uo_picture within w_pdm_01040_staff
end type
type p_mod from uo_picture within w_pdm_01040_staff
end type
type p_del from uo_picture within w_pdm_01040_staff
end type
type p_ins from uo_picture within w_pdm_01040_staff
end type
type p_can from uo_picture within w_pdm_01040_staff
end type
type p_delete from uo_picture within w_pdm_01040_staff
end type
type dw_list from datawindow within w_pdm_01040_staff
end type
type dw_detail from datawindow within w_pdm_01040_staff
end type
type rr_1 from roundrectangle within w_pdm_01040_staff
end type
end forward

global type w_pdm_01040_staff from window
integer x = 96
integer y = 224
integer width = 4165
integer height = 2400
boolean titlebar = true
string title = "임직원 등록 및 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_mod p_mod
p_del p_del
p_ins p_ins
p_can p_can
p_delete p_delete
dw_list dw_list
dw_detail dw_detail
rr_1 rr_1
end type
global w_pdm_01040_staff w_pdm_01040_staff

type variables
str_customer istr_cust

// 자료변경여부 검사
boolean  ib_any_typing

end variables

forward prototypes
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_required_chk (integer i);if dw_list.AcceptText() = -1 then return -1

if isnull(dw_list.GetItemNumber(i,'fno')) or &
	dw_list.GetItemNumber(i,'fno') = 0 then
	f_message_chk(1400,'[ '+string(i)+' 행 순번]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('fno')
	dw_list.SetFocus()
	return -1		
end if	

Return 1

end function

on w_pdm_01040_staff.create
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_del=create p_del
this.p_ins=create p_ins
this.p_can=create p_can
this.p_delete=create p_delete
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_mod,&
this.p_del,&
this.p_ins,&
this.p_can,&
this.p_delete,&
this.dw_list,&
this.dw_detail,&
this.rr_1}
end on

on w_pdm_01040_staff.destroy
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.p_can)
destroy(this.p_delete)
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.rr_1)
end on

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose


end event

event open;f_window_center_response(this)
istr_cust = Message.PowerObjectParm

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)

if dw_detail.retrieve(istr_cust.st_custno, istr_cust.st_seq) > 0 then
   dw_list.retrieve(istr_cust.st_custno, istr_cust.st_seq)
   dw_detail.setfocus() 	
else
	dw_detail.InsertRow(0)
	dw_detail.setitem(1, 'cust_no', istr_cust.st_custno)
	dw_detail.setitem(1, 'seq', istr_cust.st_seq)
   dw_detail.setfocus() 	
end if	
	
	
	

end event

type p_exit from uo_picture within w_pdm_01040_staff
integer x = 3909
integer y = 8
integer width = 178
integer taborder = 80
string pointer = "c:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
close(parent)
end event

type p_mod from uo_picture within w_pdm_01040_staff
integer x = 3387
integer y = 8
integer width = 178
integer taborder = 50
string pointer = "c:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;int i

FOR i = 1 TO dw_list.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_detail.Update() > 0	THEN
   IF dw_list.update() > 0 then 
		COMMIT USING sqlca;	
		ib_any_typing =False
	ELSE	
		ROLLBACK USING sqlca;
		Return
	END IF
ELSE
	ROLLBACK USING sqlca;
	Return
END IF

end event

type p_del from uo_picture within w_pdm_01040_staff
integer x = 3561
integer y = 8
integer width = 178
integer taborder = 60
string pointer = "c:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;int i

IF MessageBox("확인", "전체 삭제하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_detail.setredraw(false)
dw_list.setredraw(false)

FOR i = dw_detail.rowcount() TO 1 step -1
    dw_list.deleterow(i)
NEXT

dw_detail.deleterow(dw_detail.getrow())

IF dw_list.Update() = 1 THEN
   IF dw_detail.update()  = 1 then 
	  	COMMIT;
	ELSE
		ROLLBACK;
		dw_detail.setredraw(true)
		dw_list.setredraw(true)
		RETURN
   END IF
ELSE
	ROLLBACK;
	dw_detail.setredraw(true)
	dw_list.setredraw(true)
	RETURN
END IF

dw_detail.setredraw(true)
dw_list.setredraw(true)
	
ib_any_typing =False

close(parent)
end event

type p_ins from uo_picture within w_pdm_01040_staff
integer x = 3008
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "c:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;long curr_row, i

FOR i = 1 TO dw_list.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

curr_row = dw_list.insertrow(0)

dw_list.setitem(curr_row, "cust_no", istr_cust.st_custno)
dw_list.setitem(curr_row, "seq", istr_cust.st_seq)

dw_list.setcolumn('fno')
dw_list.setrow(curr_row)
dw_list.scrolltorow(curr_row)

dw_list.setfocus()


end event

type p_can from uo_picture within w_pdm_01040_staff
integer x = 3735
integer y = 8
integer width = 178
integer taborder = 70
string pointer = "c:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;dw_detail.setredraw(false)

if dw_detail.retrieve(istr_cust.st_custno, istr_cust.st_seq) > 0 then
   dw_list.retrieve(istr_cust.st_custno, istr_cust.st_seq)
   dw_detail.setfocus() 	
else
   dw_detail.reset()
   dw_list.reset()
	dw_detail.InsertRow(0)
	dw_detail.setitem(1, 'cust_no', istr_cust.st_custno)
	dw_detail.setitem(1, 'seq',  istr_cust.st_seq)
   dw_detail.setfocus() 	
end if	
	
dw_detail.setredraw(true)
	
ib_any_typing =False

end event

type p_delete from uo_picture within w_pdm_01040_staff
integer x = 3182
integer y = 8
integer width = 178
integer taborder = 30
string pointer = "c:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;long 	curr_row

curr_row = dw_list.getrow()

if f_msg_delete() = -1 then return

if curr_row > 0  then
   dw_list.deleterow(curr_row)
	IF dw_list.Update() = 1 THEN
		COMMIT;
		
   	dw_list.setcolumn('fno')
   	dw_list.setfocus()
		
		ib_any_typing =False
	ELSE
		ROLLBACK;
		RETURN
	END IF
end if

end event

type dw_list from datawindow within w_pdm_01040_staff
event ue_prosenter pbm_dwnprocessenter
integer x = 96
integer y = 908
integer width = 3959
integer height = 1344
integer taborder = 20
string title = "가족사항"
string dataobject = "d_pdm_01040_staffamily"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_prosenter;Send( Handle(this), 256, 9, 0 )
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

event itemchanged;Int lRow,lReturnRow, iorder, inull
string sorder

SetNull(inull)

IF this.GetColumnName() = "fno" THEN
	
	lRow  = this.GetRow()	
	
	sorder = THIS.GETTEXT()								
	
	lReturnRow = This.Find("sorder = '"+ sorder + "' ", 1, This.RowCount())
	
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		f_message_chk(37,'[순위]') 
		
		this.SetItem(lRow, "order", iNull)
		
		RETURN  1
		
	END IF
END IF
end event

event itemerror;return 1
end event

type dw_detail from datawindow within w_pdm_01040_staff
event ue_key pbm_dwnkey
event ue_presenter pbm_dwnprocessenter
integer x = 55
integer y = 148
integer width = 4023
integer height = 740
integer taborder = 10
string dataobject = "d_pdm_01040_staff"
boolean border = false
boolean livescroll = true
end type

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_presenter;Send( Handle(this), 256, 9, 0 )
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

event itemchanged;string s_date, snull, sres_no

setnull(snull)

IF this.GetColumnName() = 'birthday' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[생년월일]')
		this.SetItem(1,"birthday",snull)
		this.Setcolumn("birthday")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() = 'wedate' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[결혼기념일]')
		this.SetItem(1,"wedate",snull)
		this.Setcolumn("wedate")
		this.SetFocus()
		Return 1
   END IF
ELSEIF this.GetColumnName() = "resident" THEN
	sres_no = this.GetText()
	
	IF sres_no = "" OR IsNull(sres_no) THEN RETURN
	
	IF f_vendcode_check(sres_no) = False THEN
		IF MessageBox("확 인","주민등록번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
			this.SetItem(this.GetRow(),"resident",snull)
			Return 1
		END IF
	END IF
ELSEIF this.GetColumnName() = 'enterdate' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[입사일자]')
		this.SetItem(1,"enterdate",snull)
		this.Setcolumn("enterdate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() = 'retire' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[퇴사일자]')
		this.SetItem(1,"retire",snull)
		this.Setcolumn("retire")
		this.SetFocus()
		Return 1
	END IF
END IF	
end event

event itemerror;RETURN 1
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() ="sfaddr1" THEN
	
	Gs_code = this.GetText()
	
	IF IsNull(Gs_code) THEN Gs_code =""
	
	Open(w_zip_popup)
	
	IF IsNull(Gs_Code) THEN RETURN
	
	this.SetItem(this.GetRow(),"sfposno",Gs_code)
	this.SetItem(this.GetRow(),"sfaddr1",Gs_codename)
	
	this.SetColumn("sfaddr2")
	this.SetFocus()
END IF
end event

type rr_1 from roundrectangle within w_pdm_01040_staff
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 896
integer width = 3995
integer height = 1368
integer cornerheight = 40
integer cornerwidth = 55
end type

