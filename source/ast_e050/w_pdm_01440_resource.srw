$PBExportHeader$w_pdm_01440_resource.srw
$PBExportComments$** 표준공정 등록
forward
global type w_pdm_01440_resource from window
end type
type p_exit from uo_picture within w_pdm_01440_resource
end type
type p_mod from uo_picture within w_pdm_01440_resource
end type
type p_del from uo_picture within w_pdm_01440_resource
end type
type p_ins from uo_picture within w_pdm_01440_resource
end type
type dw_insert from datawindow within w_pdm_01440_resource
end type
type dw_ip from datawindow within w_pdm_01440_resource
end type
type rr_2 from roundrectangle within w_pdm_01440_resource
end type
type str_offer_rex from structure within w_pdm_01440_resource
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

global type w_pdm_01440_resource from window
integer x = 37
integer y = 72
integer width = 3191
integer height = 908
boolean titlebar = true
string title = "공정별 설비등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_mod p_mod
p_del p_del
p_ins p_ins
dw_insert dw_insert
dw_ip dw_ip
rr_2 rr_2
end type
global w_pdm_01440_resource w_pdm_01440_resource

type variables
string ls_itnbr
end variables

on w_pdm_01440_resource.create
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_del=create p_del
this.p_ins=create p_ins
this.dw_insert=create dw_insert
this.dw_ip=create dw_ip
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_mod,&
this.p_del,&
this.p_ins,&
this.dw_insert,&
this.dw_ip,&
this.rr_2}
end on

on w_pdm_01440_resource.destroy
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.dw_insert)
destroy(this.dw_ip)
destroy(this.rr_2)
end on

event open;f_window_center(this)

dw_ip.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

//gs_gubun 품번
//gs_code  공정코드
//gs_codename  공정코드명

dw_ip.Retrieve(gs_gubun) 	// 품번
dw_ip.SetItem(1, 'opseq', gs_code)
dw_ip.SetItem(1, 'opdsc', gs_codename)

dw_insert.Retrieve(gs_gubun, gs_code)

p_ins.setfocus()
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

type p_exit from uo_picture within w_pdm_01440_resource
integer x = 2953
integer y = 8
integer width = 178
integer taborder = 60
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;If dw_insert.RowCount() > 0 Then
	gs_code = dw_insert.GetItemString(1, 'rcode')
	gs_codename = dw_insert.GetItemString(1, 'mchnam')
	gs_gubun = '외 ' + String(dw_insert.RowCount() -1 )	// 설비 대수
Else
	SetNull(gs_code)
	SetNull(gs_codename)
	gs_gubun = ''
End If

close(parent)
end event

type p_mod from uo_picture within w_pdm_01440_resource
integer x = 2779
integer y = 8
integer width = 178
integer taborder = 50
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;long		lrow, lcnt, lfrow
string	swkctr, smchno

for lrow = 1 to dw_insert.rowcount()
	swkctr = dw_insert.getitemstring(lrow,'rcode2')
	select count(*) into :lcnt from wrkctr where wkctr = :swkctr ;
	if lcnt = 0 then
		MessageBox('확인','작업장코드를 확인하세요!!')
		dw_insert.ScrollToRow(lrow)
		dw_insert.setcolumn("rcode2")
		dw_insert.SetFocus()
		return
	end if
	
	smchno = dw_insert.getitemstring(lrow,'rcode')
	select count(*) into :lcnt from mchmst where mchno = :smchno ;
	if lcnt = 0 then
		MessageBox('확인','설비코드를 확인하세요!!')
		dw_insert.ScrollToRow(lrow)
		dw_insert.setcolumn("rcode")
		dw_insert.SetFocus()
		return
	end if
	
	lfrow = dw_insert.find("rcode2='"+swkctr+"' and rcode='"+smchno+"'",1,lrow)
	if lrow <> lfrow then
		MessageBox('확인','작업장+설비코드 가 중복입니다!!')
		dw_insert.ScrollToRow(lrow)
		dw_insert.setcolumn("rcode2")
		dw_insert.SetFocus()
		return
	end if
	if lrow > 1 and lrow < dw_insert.rowcount() then
		lfrow = dw_insert.find("rcode2='"+swkctr+"' and rcode='"+smchno+"'",lrow,lrow+1)
		if lrow <> lfrow then
			MessageBox('확인','작업장+설비코드 가 중복입니다!!')
			dw_insert.ScrollToRow(lrow)
			dw_insert.setcolumn("rcode2")
			dw_insert.SetFocus()
			return
		end if
	end if
next

if dw_insert.update() = 1 then
   COMMIT;
	
	MessageBox('확인','저장하였습니다.!!')
else
	ROLLBACK;
	
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
end if
end event

type p_del from uo_picture within w_pdm_01440_resource
integer x = 2606
integer y = 8
integer width = 178
integer taborder = 30
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;long 	curr_row, k

curr_row = dw_insert.getrow()

if curr_row > 0  then
   if f_msg_delete() = -1 then return
   dw_insert.deleterow(curr_row)
end if


end event

type p_ins from uo_picture within w_pdm_01440_resource
integer x = 2432
integer y = 8
integer width = 178
integer taborder = 10
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;int k, il_currow
string s_path

If dw_insert.accepttext() <> 1 Then Return

il_currow = dw_insert.insertrow(0)
dw_insert.setitem(il_currow, 'itnbr', dw_ip.GetItemString(1, 'itnbr'))
dw_insert.setitem(il_currow, 'opseq', dw_ip.GetItemString(1, 'opseq'))
dw_insert.setitem(il_currow, 'gubun', 'M')

dw_insert.ScrollToRow(il_currow)
dw_insert.setcolumn("rcode2")
dw_insert.SetFocus()
end event

type dw_insert from datawindow within w_pdm_01440_resource
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 82
integer y = 172
integer width = 3045
integer height = 620
integer taborder = 20
string dataobject = "d_pdm_01440_resource2"
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

event itemchanged;string sItem, sNull, sName, swkctr, swcdsc
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
	select mchnam, wkctr, fun_get_wcdsc(wkctr)
	  into :sname, :swkctr, :swcdsc
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sitem;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[설비]')
		this.setitem(nRow, "rcode",  sNull)
		this.setitem(nRow, "mchnam", sNull)
		this.setitem(nRow, "rcode2",  sNull)
		this.setitem(nRow, "wcdsc", sNull)
		setnull(sitem)
		setnull(sname)
		ireturn = 1
	end if
	this.setitem(nRow, "rcode",  sitem)
	this.setitem(nRow, "mchnam", sname)
	this.setitem(nRow, "rcode2",  swkctr)
	this.setitem(nRow, "wcdsc", swcdsc)
	return ireturn
elseif this.getcolumnname() = "rcode2" then
	ireturn = 0
	sitem = this.gettext()
	
	if isnull(sitem) or trim(sitem) = '' then
		this.setitem(nRow, "wcdsc", snull)
		return
	end if
	select wcdsc
	  into :sname
	  from wrkctr
	 where wkctr = :sitem;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[작업장]')
		setnull(sitem)
		setnull(sname)
		ireturn = 1
	end if
	this.setitem(nRow, "rcode2",  sitem)
	this.setitem(nRow, "wcdsc", sname)
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
	 this.triggerevent(itemchanged!)
//	 this.setitem(nRow, "mchnam", gs_codename)
ELSEIF GetColumnName() = "rcode2" then
	 open(w_workplace_popup)
	 if isnull(gs_code) or gs_code = "" then return
	 this.setitem(nRow, "rcode2", gs_code)
	 this.triggerevent(itemchanged!)
//	 this.setitem(nRow, "wcdsc", gs_codename)
END IF
end event

type dw_ip from datawindow within w_pdm_01440_resource
integer x = 55
integer y = 20
integer width = 2386
integer height = 124
string dataobject = "d_pdm_01440_resource1"
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within w_pdm_01440_resource
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 160
integer width = 3081
integer height = 644
integer cornerheight = 40
integer cornerwidth = 55
end type

