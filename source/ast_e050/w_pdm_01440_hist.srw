$PBExportHeader$w_pdm_01440_hist.srw
$PBExportComments$** 표준공정 등록
forward
global type w_pdm_01440_hist from window
end type
type p_exit from uo_picture within w_pdm_01440_hist
end type
type p_mod from uo_picture within w_pdm_01440_hist
end type
type dw_insert from datawindow within w_pdm_01440_hist
end type
type dw_ip from datawindow within w_pdm_01440_hist
end type
type rr_2 from roundrectangle within w_pdm_01440_hist
end type
type str_offer_rex from structure within w_pdm_01440_hist
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

global type w_pdm_01440_hist from window
integer x = 37
integer y = 72
integer width = 3360
integer height = 908
boolean titlebar = true
string title = "표준공정 이력관리"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_mod p_mod
dw_insert dw_insert
dw_ip dw_ip
rr_2 rr_2
end type
global w_pdm_01440_hist w_pdm_01440_hist

type variables
string ls_itnbr
end variables

on w_pdm_01440_hist.create
this.p_exit=create p_exit
this.p_mod=create p_mod
this.dw_insert=create dw_insert
this.dw_ip=create dw_ip
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_mod,&
this.dw_insert,&
this.dw_ip,&
this.rr_2}
end on

on w_pdm_01440_hist.destroy
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.dw_insert)
destroy(this.dw_ip)
destroy(this.rr_2)
end on

event open;String sDate
f_window_center(this)

dw_ip.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

sDate = Left(f_today(),6) + '01'

dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'itnbr', gs_code)
dw_ip.SetItem(1, 'itdsc', gs_codename)
dw_ip.SetItem(1, 'sdate', sdate)

dw_insert.Retrieve(gs_code, sDate)
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
   	dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type p_exit from uo_picture within w_pdm_01440_hist
integer x = 3136
integer y = 8
integer width = 178
integer taborder = 60
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

type p_mod from uo_picture within w_pdm_01440_hist
integer x = 2962
integer y = 8
integer width = 178
integer taborder = 50
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;if dw_insert.update() = 1 then
   COMMIT;
	
	MessageBox('확인','저장하였습니다.!!')
else
	ROLLBACK;
	
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
end if



end event

type dw_insert from datawindow within w_pdm_01440_hist
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 82
integer y = 172
integer width = 3232
integer height = 620
integer taborder = 20
string dataobject = "d_pdm_01440_change2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
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

event rowfocuschanged;//THIS.SetRowFocusIndicator(HAND!)
//
//string spath
//
//IF THIS.rowcount() < 1 then return 
//
//spath = this.getitemstring(currentrow, 'path')
//
//dw_bmp.Retrieve(spath)
//dw_bmp.object.datawindow.print.preview="yes"
end event

event itemchanged;string sItem, sNull, sName
Int 	 ireturn, nRow

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

if this.getcolumnname() = "rcode" then
	ireturn = 0
	sitem = this.gettext()
	
	if isnull(sitem) or trim(sitem) = '' then
		this.setitem(nRow, "mchnam", snull)
		return
	end if
	select mchnam
	  into :sname
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sitem;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[설비]')
		setnull(sitem)
		setnull(sname)
		ireturn = 1
	end if
	this.setitem(nRow, "rcode",  sitem)
	this.setitem(nRow, "mchnam", sname)
	return ireturn
End If
end event

event itemerror;return 1
end event

event rbuttondown;Long nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = GetRow()
If nRow <= 0 then Return

IF GetColumnName() = "rcode" then
	 open(w_mchmst_popup)
	 if isnull(gs_code) or gs_code = "" then return
	 this.setitem(nRow, "rcode", gs_code)
	 this.setitem(nRow, "mchnam", gs_codename)
END IF
end event

type dw_ip from datawindow within w_pdm_01440_hist
integer x = 55
integer y = 20
integer width = 2386
integer height = 124
string dataobject = "d_pdm_01440_change1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String sDate, sItnbr

Choose Case GetColumnName()
	Case 'sdate'
		sDate = Trim(GetTExt())
		
		sItnbr = GetItemString(1, 'itnbr')
		dw_insert.Retrieve(sItnbr, sDate)
End Choose
end event

type rr_2 from roundrectangle within w_pdm_01440_hist
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 160
integer width = 3264
integer height = 644
integer cornerheight = 40
integer cornerwidth = 55
end type

