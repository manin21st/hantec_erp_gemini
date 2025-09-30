$PBExportHeader$w_pdm_01040_mark.srw
$PBExportComments$** 거래처 등록(인증마크등록)
forward
global type w_pdm_01040_mark from window
end type
type p_exit from uo_picture within w_pdm_01040_mark
end type
type p_can from uo_picture within w_pdm_01040_mark
end type
type p_del from uo_picture within w_pdm_01040_mark
end type
type p_mod from uo_picture within w_pdm_01040_mark
end type
type p_ins from uo_picture within w_pdm_01040_mark
end type
type dw_list from datawindow within w_pdm_01040_mark
end type
type rr_1 from roundrectangle within w_pdm_01040_mark
end type
end forward

global type w_pdm_01040_mark from window
integer x = 823
integer y = 360
integer width = 3333
integer height = 2096
boolean titlebar = true
string title = "인증마크 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_ins p_ins
dw_list dw_list
rr_1 rr_1
end type
global w_pdm_01040_mark w_pdm_01040_mark

type variables
str_customer istr_cust

// 자료변경여부 검사
boolean  ib_any_typing

end variables

forward prototypes
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_required_chk (integer i);if dw_list.AcceptText() = -1 then return -1

if isnull(dw_list.GetItemString(i,'inmark')) or &
	dw_list.GetItemString(i,'inmark') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 인증마크]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('inmark')
	dw_list.SetFocus()
	return -1		
end if	

Return 1

end function

on w_pdm_01040_mark.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_ins=create p_ins
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_ins,&
this.dw_list,&
this.rr_1}
end on

on w_pdm_01040_mark.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_ins)
destroy(this.dw_list)
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

event open;f_window_center(this)
istr_cust = Message.PowerObjectParm

dw_list.settransobject(sqlca)

if dw_list.retrieve(istr_cust.st_custno) > 0 then
   dw_list.setfocus() 	
else
   p_ins.setfocus() 	
end if	
	
	
	
end event

type p_exit from uo_picture within w_pdm_01040_mark
integer x = 3104
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "c:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
close(parent)
end event

type p_can from uo_picture within w_pdm_01040_mark
integer x = 2930
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "c:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;if dw_list.retrieve(istr_cust.st_custno) > 0 then
   dw_list.setfocus() 	
else
   p_ins.setfocus() 	
end if	

end event

type p_del from uo_picture within w_pdm_01040_mark
integer x = 2757
integer y = 12
integer width = 178
integer taborder = 40
string pointer = "c:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;long 	curr_row, I

FOR i = 1 TO dw_list.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

curr_row = dw_list.getrow()

if curr_row > 0  then

   if f_msg_delete() = -1 then return

   dw_list.deleterow(curr_row)
	IF dw_list.Update() = 1 THEN
		COMMIT;
		
   	dw_list.setcolumn('inmark')
   	dw_list.setfocus()
		
		ib_any_typing =False
	ELSE
		ROLLBACK;
		RETURN
	END IF
end if

end event

type p_mod from uo_picture within w_pdm_01040_mark
integer x = 2583
integer y = 12
integer width = 178
integer taborder = 30
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

IF dw_list.update() > 0 then 
	COMMIT USING sqlca;	
	ib_any_typing =False
ELSE	
	ROLLBACK USING sqlca;
	Return
END IF

end event

type p_ins from uo_picture within w_pdm_01040_mark
integer x = 2409
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "c:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;long curr_row, i

FOR i = 1 TO dw_list.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

curr_row = dw_list.insertrow(0)

dw_list.setitem(curr_row, "cust_no", istr_cust.st_custno)

dw_list.setcolumn('inmark')
dw_list.setrow(curr_row)
dw_list.scrolltorow(curr_row)

dw_list.setfocus()

end event

type dw_list from datawindow within w_pdm_01040_mark
event ue_enterkey pbm_dwnprocessenter
integer x = 50
integer y = 176
integer width = 3209
integer height = 1772
integer taborder = 10
string dataobject = "d_pdm_01040_mark"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;Send( Handle(this), 256, 9, 0 )
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

event itemchanged;Int lRow,lReturnRow
string sorder, snull, s_date

SetNull(snull)
lRow  = this.GetRow()	

IF this.GetColumnName() = "inmark" THEN
	sorder = THIS.GETTEXT()								
	lReturnRow = This.Find("inmark = '"+ sorder + "' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[인증마크]') 
		this.SetItem(lRow, "inmark", sNull)
		RETURN  1
	END IF
ELSEIF this.GetColumnName() = "getdate" THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[획득일자]')
		this.SetItem(lrow,"getdate",snull)
		this.Setcolumn("getdate")
		this.SetFocus()
		Return 1
	END IF
END IF
end event

type rr_1 from roundrectangle within w_pdm_01040_mark
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 164
integer width = 3237
integer height = 1800
integer cornerheight = 40
integer cornerwidth = 55
end type

