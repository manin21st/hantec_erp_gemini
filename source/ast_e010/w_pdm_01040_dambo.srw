$PBExportHeader$w_pdm_01040_dambo.srw
$PBExportComments$** 거래처 등록(담보등록)
forward
global type w_pdm_01040_dambo from window
end type
type p_delete from uo_picture within w_pdm_01040_dambo
end type
type p_can from uo_picture within w_pdm_01040_dambo
end type
type p_ins from uo_picture within w_pdm_01040_dambo
end type
type p_del from uo_picture within w_pdm_01040_dambo
end type
type p_mod from uo_picture within w_pdm_01040_dambo
end type
type p_exit from uo_picture within w_pdm_01040_dambo
end type
type dw_list from datawindow within w_pdm_01040_dambo
end type
type dw_detail from datawindow within w_pdm_01040_dambo
end type
type rr_1 from roundrectangle within w_pdm_01040_dambo
end type
end forward

global type w_pdm_01040_dambo from window
integer x = 457
integer y = 212
integer width = 4165
integer height = 2400
boolean titlebar = true
string title = "거래처 담보 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_delete p_delete
p_can p_can
p_ins p_ins
p_del p_del
p_mod p_mod
p_exit p_exit
dw_list dw_list
dw_detail dw_detail
rr_1 rr_1
end type
global w_pdm_01040_dambo w_pdm_01040_dambo

type variables
str_customer istr_cust

// 자료변경여부 검사
boolean  ib_any_typing

end variables

forward prototypes
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_required_chk (integer i);if dw_list.AcceptText() = -1 then return -1

if isnull(dw_list.GetItemNumber(i,'order')) or &
	dw_list.GetItemNumber(i,'order') = 0 then
	f_message_chk(1400,'[ '+string(i)+' 행 담보순위]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('order')
	dw_list.SetFocus()
	return -1		
end if	

Return 1

end function

on w_pdm_01040_dambo.create
this.p_delete=create p_delete
this.p_can=create p_can
this.p_ins=create p_ins
this.p_del=create p_del
this.p_mod=create p_mod
this.p_exit=create p_exit
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.rr_1=create rr_1
this.Control[]={this.p_delete,&
this.p_can,&
this.p_ins,&
this.p_del,&
this.p_mod,&
this.p_exit,&
this.dw_list,&
this.dw_detail,&
this.rr_1}
end on

on w_pdm_01040_dambo.destroy
destroy(this.p_delete)
destroy(this.p_can)
destroy(this.p_ins)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_exit)
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

event open;double d_totamt = 0 

f_window_center(this)

istr_cust = Message.PowerObjectParm

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)

if dw_detail.retrieve(istr_cust.st_custno, istr_cust.st_seq) > 0 then
   IF dw_list.retrieve(istr_cust.st_custno, istr_cust.st_seq) > 0 THEN
		d_totamt = dw_list.getitemnumber(1, 'tot_amt')
	ELSE
		d_totamt = 0
	END IF	
   dw_detail.setfocus() 	
else
	dw_detail.InsertRow(0)
	dw_detail.setitem(1, 'cust_no', istr_cust.st_custno)
	dw_detail.setitem(1, 'seq', istr_cust.st_seq)
   dw_detail.setfocus() 	
end if	
	
dw_detail.setitem(1, 'orderamt', d_totamt) 	
	

end event

type p_delete from uo_picture within w_pdm_01040_dambo
integer x = 3173
integer y = 8
integer width = 178
integer taborder = 30
string pointer = "c:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;long 	curr_row

dw_list.accepttext()

curr_row = dw_list.getrow()

if f_msg_delete() = -1 then return

if curr_row > 0  then
   dw_list.deleterow(curr_row)
	IF dw_list.Update() = 1 THEN
		COMMIT;
		
		if dw_list.rowcount() > 0 then
         dw_detail.setitem(1, 'orderamt', dw_list.getitemNumber(1, 'tot_amt'))
		else
         dw_detail.setitem(1, 'orderamt', 0)
		end if
		
   	dw_list.setcolumn('order')
   	dw_list.setfocus()
		
		ib_any_typing =False
	ELSE
		ROLLBACK;
		RETURN
	END IF
end if

end event

type p_can from uo_picture within w_pdm_01040_dambo
integer x = 3726
integer y = 8
integer width = 178
integer taborder = 70
string pointer = "c:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;double d_totamt

dw_detail.setredraw(false)

if dw_detail.retrieve(istr_cust.st_custno, istr_cust.st_seq) > 0 then
   IF dw_list.retrieve(istr_cust.st_custno, istr_cust.st_seq) > 0 THEN
		d_totamt = dw_list.getitemnumber(1, 'tot_amt')
	ELSE
		d_totamt = 0
	END IF	
   dw_detail.setfocus() 	
else
   dw_detail.reset()
   dw_list.reset()
	dw_detail.InsertRow(0)
	dw_detail.setitem(1, 'cust_no', istr_cust.st_custno)
	dw_detail.setitem(1, 'seq',  istr_cust.st_seq)
   dw_detail.setfocus() 	
end if	
	
dw_detail.setitem(1, 'orderamt', d_totamt) 	

dw_detail.setredraw(true)
	
ib_any_typing =False

end event

type p_ins from uo_picture within w_pdm_01040_dambo
integer x = 2999
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

dw_list.setcolumn('order')
dw_list.setrow(curr_row)
dw_list.scrolltorow(curr_row)

dw_list.setfocus()


end event

type p_del from uo_picture within w_pdm_01040_dambo
integer x = 3552
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

type p_mod from uo_picture within w_pdm_01040_dambo
integer x = 3378
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

type p_exit from uo_picture within w_pdm_01040_dambo
integer x = 3899
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

type dw_list from datawindow within w_pdm_01040_dambo
event ue_key pbm_dwnkey
event ue_presenter pbm_dwnprocessenter
integer x = 133
integer y = 728
integer width = 3913
integer height = 1520
integer taborder = 40
string title = "선순위 채권내역"
string dataobject = "d_pdm_01040_dambo2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_presenter;Send( Handle(this), 256, 9, 0 )
Return 1

end event

event editchanged;ib_any_typing = true
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

event itemchanged;Int lRow,lReturnRow, iorder, inull
string sorder

SetNull(inull)

lRow  = this.GetRow()	

IF this.GetColumnName() = "order" THEN
	sorder = THIS.GETTEXT()								
	lReturnRow = This.Find("sorder = '"+ sorder + "' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[순위]') 
		this.SetItem(lRow, "order", iNull)
		RETURN  1
	END IF
ELSEIF this.GetColumnName() = "bondamt" THEN
	this.accepttext()
   dw_detail.setitem(1, 'orderamt', this.getitemNumber(lrow, 'tot_amt')) 	
END IF
end event

event itemerror;return 1
end event

type dw_detail from datawindow within w_pdm_01040_dambo
event ue_key pbm_dwnkey
event ue_presenter pbm_dwnprocessenter
integer x = 78
integer y = 160
integer width = 3927
integer height = 552
integer taborder = 10
string dataobject = "d_pdm_01040_dambo1"
boolean border = false
boolean livescroll = true
end type

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_presenter;IF this.GetColumnName() = 'security' THEN RETURN 

Send( Handle(this), 256, 9, 0 )
Return 1

end event

event editchanged;ib_any_typing = true
end event

event itemerror;return 1
end event

event itemchanged;string s_date, snull

setnull(snull)

IF this.GetColumnName() = 'dmfdate' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[담보계약일]')
		this.SetItem(1,"dmfdate",snull)
		this.Setcolumn("dmfdate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() = 'dmtdate' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[담보만기일]')
		this.SetItem(1,"dmtdate",snull)
		this.Setcolumn("dmtdate")
		this.SetFocus()
		Return 1
	END IF
END IF	
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

type rr_1 from roundrectangle within w_pdm_01040_dambo
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 110
integer y = 724
integer width = 3954
integer height = 1540
integer cornerheight = 40
integer cornerwidth = 55
end type

