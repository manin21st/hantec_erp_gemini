$PBExportHeader$w_pdm_01280.srw
$PBExportComments$도면관리
forward
global type w_pdm_01280 from window
end type
type p_exit from uo_picture within w_pdm_01280
end type
type p_mod from uo_picture within w_pdm_01280
end type
type p_del from uo_picture within w_pdm_01280
end type
type p_ins from uo_picture within w_pdm_01280
end type
type st_zoom from statictext within w_pdm_01280
end type
type ddlb_zoom from dropdownlistbox within w_pdm_01280
end type
type dw_bmp from datawindow within w_pdm_01280
end type
type dw_insert from datawindow within w_pdm_01280
end type
type dw_ip from datawindow within w_pdm_01280
end type
type rr_1 from roundrectangle within w_pdm_01280
end type
type rr_2 from roundrectangle within w_pdm_01280
end type
type str_offer_rex from structure within w_pdm_01280
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

global type w_pdm_01280 from window
integer x = 37
integer y = 72
integer width = 3877
integer height = 2272
boolean titlebar = true
string title = "도면 관리"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_mod p_mod
p_del p_del
p_ins p_ins
st_zoom st_zoom
ddlb_zoom ddlb_zoom
dw_bmp dw_bmp
dw_insert dw_insert
dw_ip dw_ip
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01280 w_pdm_01280

type variables
string ls_itnbr
end variables

on w_pdm_01280.create
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_del=create p_del
this.p_ins=create p_ins
this.st_zoom=create st_zoom
this.ddlb_zoom=create ddlb_zoom
this.dw_bmp=create dw_bmp
this.dw_insert=create dw_insert
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_mod,&
this.p_del,&
this.p_ins,&
this.st_zoom,&
this.ddlb_zoom,&
this.dw_bmp,&
this.dw_insert,&
this.dw_ip,&
this.rr_1,&
this.rr_2}
end on

on w_pdm_01280.destroy
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.st_zoom)
destroy(this.ddlb_zoom)
destroy(this.dw_bmp)
destroy(this.dw_insert)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;f_window_center(this)

dw_ip.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_bmp.SetTransObject(SQLCA)

ls_itnbr = Message.StringParm	

dw_ip.Retrieve(ls_itnbr) 

dw_insert.Retrieve(ls_itnbr)

p_ins.setfocus()
//dw_bmp.object.datawindow.print.preview="yes"



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

type p_exit from uo_picture within w_pdm_01280
integer x = 3639
integer width = 178
integer taborder = 60
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;
close(parent)
end event

type p_mod from uo_picture within w_pdm_01280
integer x = 3465
integer width = 178
integer taborder = 50
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;if dw_insert.update() = 1 then
   COMMIT;
   close(parent)
else
	ROLLBACK;
   close(parent)
end if



end event

type p_del from uo_picture within w_pdm_01280
integer x = 3291
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

FOR k = dw_insert.rowcount() TO 1 STEP -1
    dw_insert.setitem(k, 'seq',  k)
NEXT

end event

type p_ins from uo_picture within w_pdm_01280
integer x = 3118
integer width = 178
integer taborder = 10
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;int k, il_currow
string s_path

dw_insert.accepttext()

il_currow = dw_insert.insertrow(0)
dw_insert.setitem(il_currow, 'itnbr', ls_itnbr)

SELECT "SYSCNFG"."DATANAME"  
  INTO :s_path  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 1 ) AND  
		 ( "SYSCNFG"."LINENO" = '2' )   ;

IF sqlca.sqlcode = 0 then 
	dw_insert.setitem(il_currow, 'path', s_path)
ELSE
	dw_insert.setitem(il_currow, 'path' , 'C:\TEMP\')
END IF	

FOR k=il_currow TO 1 STEP -1
    dw_insert.setitem(k, 'seq',  k)
NEXT

dw_insert.ScrollToRow(il_currow)
dw_insert.setcolumn("engno")
dw_insert.SetFocus()
end event

type st_zoom from statictext within w_pdm_01280
integer x = 2505
integer y = 56
integer width = 283
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
boolean enabled = false
string text = "확대/축소"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_zoom from dropdownlistbox within w_pdm_01280
integer x = 2802
integer y = 40
integer width = 265
integer height = 296
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "100"
boolean allowedit = true
boolean sorted = false
boolean vscrollbar = true
integer limit = 3
string item[] = {"30","50","75","100","120","150","200"}
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_zoom, ls_return

ls_zoom = trim(ddlb_zoom.text)

triggerevent(selectionchanged!)

choose case ls_zoom
	case '30'
		ls_zoom = '30'
	case '50'
		ls_zoom = '50'		
	case '75'
		ls_zoom = '75'
	case '100'
		ls_zoom = '100'
	case '120'
		ls_zoom = '120'
	case '150'
		ls_zoom = '150'
	case '200'
		ls_zoom = '200'
	case '250'
		ls_zoom = '250'
	case '300'
		ls_zoom = '300'
	case '350'
		ls_zoom = '350'
	case '400'
		ls_zoom = '400'
	case else
		if isnumber(ddlb_zoom.text) then
			ls_zoom = ddlb_zoom.text
		else
			messagebox("ZOOM 확인", "배율 범위를 확인하세요.!", information!, OK!)
			return
		end if
end choose

dw_bmp.modify("Datawindow.print.preview.zoom = '"+ls_zoom+"'")
end event

type dw_bmp from datawindow within w_pdm_01280
integer x = 64
integer y = 840
integer width = 3730
integer height = 1300
boolean titlebar = true
string dataobject = "d_pdm_01280"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_insert from datawindow within w_pdm_01280
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 119
integer y = 188
integer width = 3643
integer height = 592
integer taborder = 20
string dataobject = "d_pdm_01281"
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

string spath

IF THIS.rowcount() < 1 then return 

spath = this.getitemstring(currentrow, 'path')

dw_bmp.Retrieve(spath)
dw_bmp.object.datawindow.print.preview="yes"
end event

event itemchanged;string spath

IF this.GetColumnName() = 'path' then
   spath = this.gettext()

	dw_bmp.Retrieve(spath)
	dw_bmp.object.datawindow.print.preview="yes"
END IF
end event

event itemerror;return 1
end event

event rbuttondown;integer fh, ret

blob Emp_pic
string txtname, named
string defext = "BMP"
string Filter = "bitmap Files (*.bmp), *.bmp"

IF this.GetColumnName() = 'path' then
	ret = GetFileOpenName("Open Bitmap", txtname, named, defext, filter)
	
	IF ret = 1 THEN
      dw_bmp.Retrieve(txtname)
      dw_bmp.object.datawindow.print.preview="yes"
      this.setitem(this.getrow(), 'path', txtname)
	END IF
	
END IF
end event

event buttonclicking;integer fh, ret

blob Emp_pic
string txtname, named
string defext = "BMP"
string Filter = "bitmap Files (*.bmp), *.bmp"

	ret = GetFileOpenName("Open Bitmap", txtname, named, defext, filter)
	
	IF ret = 1 THEN
      dw_bmp.Retrieve(txtname)
      dw_bmp.object.datawindow.print.preview="yes"
      this.setitem(this.getrow(), 'path', txtname)
	END IF

end event

type dw_ip from datawindow within w_pdm_01280
integer x = 55
integer y = 20
integer width = 2386
integer height = 124
string dataobject = "d_pdm_01282"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdm_01280
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2487
integer y = 16
integer width = 603
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01280
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 160
integer width = 3739
integer height = 644
integer cornerheight = 40
integer cornerwidth = 55
end type

