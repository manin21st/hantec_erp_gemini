$PBExportHeader$w_kglb012.srw
$PBExportComments$전표 품의 상세 등록
forward
global type w_kglb012 from window
end type
type p_ins from uo_picture within w_kglb012
end type
type p_mod from uo_picture within w_kglb012
end type
type p_exit from uo_picture within w_kglb012
end type
type p_print from uo_picture within w_kglb012
end type
type p_del from uo_picture within w_kglb012
end type
type dw_print from datawindow within w_kglb012
end type
type dw_ins from datawindow within w_kglb012
end type
type dw_disp from datawindow within w_kglb012
end type
type rr_1 from roundrectangle within w_kglb012
end type
end forward

global type w_kglb012 from window
integer x = 567
integer y = 136
integer width = 2715
integer height = 2048
boolean titlebar = true
string title = "전표 품의 내역 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_ins p_ins
p_mod p_mod
p_exit p_exit
p_print p_print
p_del p_del
dw_print dw_print
dw_ins dw_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb012 w_kglb012

type variables
Boolean ib_changed,ib_DbChanged = False
end variables

forward prototypes
public function integer wf_requiredchk (integer il_currow)
end prototypes

public function integer wf_requiredchk (integer il_currow);String sPumText

dw_ins.AcceptText()
sPumText = dw_ins.GetItemSTring(il_currow,"pum_text")

IF sPumText = "" OR IsNull(sPumText) THEN
	F_MessageChk(1,'[품의내역]')
	dw_ins.SetColumn("pum_text")
	dw_ins.SetFocus()
	Return -1
END IF

Return 1
end function

on w_kglb012.create
this.p_ins=create p_ins
this.p_mod=create p_mod
this.p_exit=create p_exit
this.p_print=create p_print
this.p_del=create p_del
this.dw_print=create dw_print
this.dw_ins=create dw_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.p_ins,&
this.p_mod,&
this.p_exit,&
this.p_print,&
this.p_del,&
this.dw_print,&
this.dw_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb012.destroy
destroy(this.p_ins)
destroy(this.p_mod)
destroy(this.p_exit)
destroy(this.p_print)
destroy(this.p_del)
destroy(this.dw_print)
destroy(this.dw_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

event open;String sMsgParm

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

sMsgParm = Message.StringParm

IF dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,lstr_jpra.bjunno) <=0 THEN
	dw_disp.InsertRow(0)
	
	dw_disp.SetItem(dw_disp.GetRow(),"saupj",     lstr_jpra.saupjang)
	dw_disp.SetItem(dw_disp.GetRow(),"bal_date",  lstr_jpra.baldate)
	dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",   lstr_jpra.upmugu)
	dw_disp.SetItem(dw_disp.GetRow(),"jun_no",    lstr_jpra.bjunno)
	
END IF

IF dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,lstr_jpra.bjunno) <=0 THEN
	IF sMsgParm = "" OR IsNull(sMsgParm) THEN Return
	
	dw_ins.InsertRow(0)
	
	dw_ins.SetItem(dw_ins.GetRow(),"saupj",     lstr_jpra.saupjang)
	dw_ins.SetItem(dw_ins.GetRow(),"bal_date",  lstr_jpra.baldate)
	dw_ins.SetItem(dw_ins.GetRow(),"upmu_gu",   lstr_jpra.upmugu)
	dw_ins.SetItem(dw_ins.GetRow(),"jun_no",    lstr_jpra.bjunno)
	dw_ins.SetItem(dw_ins.GetRow(),"pum_no",    1)	
	dw_ins.SetItem(dw_ins.GetRow(),"pum_text",  sMsgParm)	
	
	 ib_changed = True
ELSE
	 ib_changed = False
END IF

dw_ins.SetColumn("pum_text")	
dw_ins.SetFocus()

end event

type p_ins from uo_picture within w_kglb012
integer x = 1801
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;Integer  iCurRow,iFunctionValue

IF dw_ins.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_ins.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_ins.InsertRow(0)

	dw_ins.SetItem(iCurRow,"saupj",     lstr_jpra.saupjang)
	dw_ins.SetItem(iCurRow,"bal_date",  lstr_jpra.baldate)
	dw_ins.SetItem(iCurRow,"upmu_gu",   lstr_jpra.upmugu)
	dw_ins.SetItem(iCurRow,"jun_no",    lstr_jpra.bjunno)
	dw_ins.SetItem(iCurRow,"pum_no",    iCurRow)		

	dw_ins.ScrollToRow(iCurRow)
		
	dw_ins.SetColumn("pum_text")
	dw_ins.SetFocus()
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type p_mod from uo_picture within w_kglb012
integer x = 1975
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;Int k

IF dw_ins.RowCount() <=0 THEN RETURN

FOR k = 1 TO dw_ins.RowCount()
	IF Wf_RequiredChk(k) = -1 THEN Return	
	
	dw_ins.SetItem(k,"pum_no",k)
NEXT

IF F_DbConFirm('저장') = 2  then return

IF dw_ins.Update() <> 1 THEN
	Rollback;
	F_messageChk(13,'')
	Return
END IF

ib_changed = False
ib_dbchanged = True


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_exit from uo_picture within w_kglb012
integer x = 2496
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;String sRtnValue,sDescr

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
	sDescr = dw_ins.GetItemSTring(1,"pum_text")
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

type p_print from uo_picture within w_kglb012
integer x = 2322
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
IF dw_ins.RowCount() <=0 THEN Return

IF MessageBox("확 인","품의내역을 출력하시겠습니까?",Question!,YesNo!) =2 THEN RETURN

dw_ins.AcceptText()

IF dw_print.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,lstr_jpra.bjunno) > 0 THEN
	OpenWithParm(w_print_options, dw_print)
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type p_del from uo_picture within w_kglb012
integer x = 2149
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;String snull

SetNull(snull)

IF dw_ins.RowCount() <=0 THEN RETURN

IF F_DbConFirm('삭제') = 2  then return

dw_ins.SetRedraw(False)
dw_ins.DeleteRow(0)

IF dw_ins.Update() <> 1 THEN
	rollback;
	f_messagechk(12,'')
	Return
END IF
dw_ins.SetRedraw(True)

ib_changed = False
ib_dbchanged = True

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

type dw_print from datawindow within w_kglb012
boolean visible = false
integer x = 18
integer y = 1800
integer width = 663
integer height = 96
boolean titlebar = true
string title = "품의내역 인쇄"
string dataobject = "dw_kglb012_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_ins from datawindow within w_kglb012
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 59
integer y = 232
integer width = 2606
integer height = 1676
integer taborder = 10
string dataobject = "dw_kglb012_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;If dw_ins.getcolumnname() = "pum_text" then
   if dw_ins.rowcount() = dw_ins.getrow() then
   	p_ins.postevent(clicked!)
   end if
end if
end event

event editchanged;ib_changed = True
end event

event itemfocuschanged;
f_toggle_kor(Handle(this))

end event

type dw_disp from datawindow within w_kglb012
event ue_pressenter pbm_dwnprocessenter
integer x = 37
integer y = 12
integer width = 1605
integer height = 208
string dataobject = "dw_kglb012_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
IF this.GetColumnName() = "pum_text" THEN
ELSE
	Send(Handle(this),256,9,0)
	Return 1
END IF
end event

event itemfocuschanged;
IF this.GetColumnName() = "pum_text" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))	
END IF
end event

event itemerror;
Return 1
end event

type rr_1 from roundrectangle within w_kglb012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 224
integer width = 2629
integer height = 1696
integer cornerheight = 40
integer cornerwidth = 55
end type

