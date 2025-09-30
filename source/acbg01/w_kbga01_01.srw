$PBExportHeader$w_kbga01_01.srw
$PBExportComments$예산배정등록(편성근거 상세)
forward
global type w_kbga01_01 from window
end type
type p_exit from uo_picture within w_kbga01_01
end type
type p_del from uo_picture within w_kbga01_01
end type
type p_mod from uo_picture within w_kbga01_01
end type
type p_ins from uo_picture within w_kbga01_01
end type
type dw_ins from datawindow within w_kbga01_01
end type
type dw_disp from datawindow within w_kbga01_01
end type
type rr_1 from roundrectangle within w_kbga01_01
end type
end forward

global type w_kbga01_01 from window
integer x = 864
integer y = 288
integer width = 2907
integer height = 1676
boolean titlebar = true
string title = "예산배정등록(편성근거 상세)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_del p_del
p_mod p_mod
p_ins p_ins
dw_ins dw_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kbga01_01 w_kbga01_01

type variables
Boolean ib_changed,ib_DbChanged = False
end variables

forward prototypes
public function integer wf_requiredchk (integer il_currow)
end prototypes

public function integer wf_requiredchk (integer il_currow);String ls_bg_txt

if dw_ins.AcceptText() = -1 then return -1
ls_bg_txt = dw_ins.GetItemSTring(il_currow,"bg_txt")

IF trim(ls_bg_txt) = "" OR IsNull(ls_bg_txt) THEN
	F_MessageChk(1,'[편성근거]')
	dw_ins.SetColumn("bg_txt")
	dw_ins.SetFocus()
	Return -1
END IF

Return 1
end function

on w_kbga01_01.create
this.p_exit=create p_exit
this.p_del=create p_del
this.p_mod=create p_mod
this.p_ins=create p_ins
this.dw_ins=create dw_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_del,&
this.p_mod,&
this.p_ins,&
this.dw_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kbga01_01.destroy
destroy(this.p_exit)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_ins)
destroy(this.dw_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

event open;String sMsgParm, sqlfd3, sqlfd4

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)

dw_disp.reset()

sMsgParm = Message.StringParm

dw_disp.InsertRow(0)

dw_disp.SetItem(dw_disp.GetRow(),"saupj",     lstr_jpra.saupjang)
dw_disp.SetItem(dw_disp.GetRow(),"acc_yy",    lstr_jpra.baldate)	 
dw_disp.SetItem(dw_disp.GetRow(),"dept_cd",   lstr_jpra.dept) 
dw_disp.SetItem(dw_disp.GetRow(),"acc1_cd",   lstr_jpra.acc1) 
dw_disp.SetItem(dw_disp.GetRow(),"acc2_cd",   lstr_jpra.acc2)

SELECT "ACC1_NM","YACC2_NM"
	INTO :sqlfd3, :sqlfd4
	FROM "KFZ01OM0"  
	WHERE "ACC1_CD" = :lstr_jpra.acc1 and "ACC2_CD" = :lstr_jpra.acc2 ;
		
	if sqlca.sqlcode = 0 then
		dw_disp.Setitem(1,"accname", sqlfd3 + " - " + sqlfd4)
	else
		dw_disp.Setitem(1,"accname"," ")
	end if

IF dw_ins.Retrieve(lstr_jpra.saupjang, lstr_jpra.baldate, lstr_jpra.dept, &
                   lstr_jpra.acc1, lstr_jpra.acc2) < 1 THEN
	IF sMsgParm = "" OR IsNull(sMsgParm) THEN Return
	
	dw_ins.InsertRow(0)
	
	dw_ins.SetItem(dw_ins.GetRow(), 'saupj',     lstr_jpra.saupjang)  
	dw_ins.SetItem(dw_ins.GetRow(), 'dept_cd',   lstr_jpra.dept)	 
	dw_ins.SetItem(dw_ins.GetRow(), 'acc1_cd',   lstr_jpra.acc1)	 
	dw_ins.SetItem(dw_ins.GetRow(), 'acc2_cd',   lstr_jpra.acc2) 
	dw_ins.SetItem(dw_ins.GetRow(), 'acc_yy',    lstr_jpra.baldate)  
	dw_ins.SetItem(dw_ins.GetRow(), 'seqno',    1)	
	dw_ins.SetItem(dw_ins.GetRow(), 'bg_txt',  sMsgParm)	
	
	 ib_changed = True
ELSE
	 ib_changed = False
END IF

dw_ins.SetColumn("bg_txt")	
dw_ins.SetFocus()

end event

type p_exit from uo_picture within w_kbga01_01
integer x = 2683
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;String sRtnValue,sDescr

IF ib_changed = True THEN
	IF MessageBox("확인 : " , "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN
		Return
	ELSE
		ib_dbchanged = False
	END IF
END IF

IF dw_ins.RowCount() <=0 THEN
	sDescr = ' '
ELSE
	sDescr = dw_ins.GetItemSTring(1,"bg_txt")
	IF IsNull(sDescr) THEN sDescr = ' '
END IF

IF Ib_DbChanged = True THEN
	sRtnValue = '1'
ELSE
	sRtnValue = '0'
END IF

CloseWithReturn(parent,sRtnValue + sDescr)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_del from uo_picture within w_kbga01_01
integer x = 2510
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String snull

SetNull(snull)

IF dw_ins.RowCount() <=0 THEN RETURN

IF F_DbConFirm('삭제') = 2  then return

dw_ins.SetRedraw(False)
dw_ins.DeleteRow(0)

IF dw_ins.Update() <> 1 THEN
	rollback using sqlca;
	f_messagechk(12,'')
	Return
END IF
dw_ins.SetRedraw(True)

commit using sqlca;

ib_changed = False
ib_dbchanged = True

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_kbga01_01
integer x = 2336
integer y = 24
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Int k

IF dw_ins.RowCount() <=0 THEN RETURN

FOR k = 1 TO dw_ins.RowCount()
	IF Wf_RequiredChk(k) = -1 THEN Return	
	
	dw_ins.SetItem(k,"seqno", string(k, '000'))
NEXT

IF F_DbConFirm('저장') = 2  then return

IF dw_ins.Update() <> 1 THEN
	Rollback using sqlca;
	F_messageChk(13,'')
	Return
END IF
commit using sqlca;

ib_changed = False
ib_dbchanged = True


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_ins from uo_picture within w_kbga01_01
integer x = 2162
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\추가_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Integer  iCurRow,iFunctionValue

IF dw_ins.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_ins.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_ins.InsertRow(0)

	dw_ins.SetItem(iCurRow,"saupj",     lstr_jpra.saupjang)
	dw_ins.SetItem(iCurRow,"acc_yy",  lstr_jpra.baldate)
	dw_ins.SetItem(iCurRow,"dept_cd",  lstr_jpra.dept)	
	
	dw_ins.SetItem(iCurRow,"acc1_cd",   lstr_jpra.acc1)
	dw_ins.SetItem(iCurRow,"acc2_cd",    lstr_jpra.acc2)
	dw_ins.SetItem(iCurRow,"seqno",    string(iCurRow, '000'))		

	dw_ins.ScrollToRow(iCurRow)
		
	dw_ins.SetColumn("bg_txt")
	
	dw_ins.SetFocus()
	
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type dw_ins from datawindow within w_kbga01_01
event ue_enterkey pbm_dwnprocessenter
integer x = 64
integer y = 360
integer width = 2770
integer height = 1176
integer taborder = 30
string dataobject = "dw_kbga01_1_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;If dw_ins.getcolumnname() = "bg_txt" then
   if dw_ins.rowcount() = dw_ins.getrow() then
   	p_ins.postevent(clicked!)
   end if
end if
end event

event itemerror;return 1
end event

event editchanged;ib_changed = True
end event

type dw_disp from datawindow within w_kbga01_01
integer x = 32
integer y = 24
integer width = 2085
integer height = 328
integer taborder = 10
string dataobject = "dw_kbga01_1_01"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kbga01_01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 356
integer width = 2798
integer height = 1196
integer cornerheight = 40
integer cornerwidth = 46
end type

