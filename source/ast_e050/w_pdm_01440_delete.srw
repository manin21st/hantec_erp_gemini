$PBExportHeader$w_pdm_01440_delete.srw
$PBExportComments$** 표준공정관리(대량삭제)
forward
global type w_pdm_01440_delete from window
end type
type p_inq from uo_picture within w_pdm_01440_delete
end type
type p_del from uo_picture within w_pdm_01440_delete
end type
type p_exit from uo_picture within w_pdm_01440_delete
end type
type dw_delete from datawindow within w_pdm_01440_delete
end type
type dw_1 from datawindow within w_pdm_01440_delete
end type
type dw_list from datawindow within w_pdm_01440_delete
end type
type rr_1 from roundrectangle within w_pdm_01440_delete
end type
end forward

global type w_pdm_01440_delete from window
integer x = 887
integer y = 112
integer width = 1911
integer height = 2072
boolean titlebar = true
string title = "표준공정 단품 삭제"
windowtype windowtype = response!
long backcolor = 32106727
p_inq p_inq
p_del p_del
p_exit p_exit
dw_delete dw_delete
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
end type
global w_pdm_01440_delete w_pdm_01440_delete

type variables

end variables

forward prototypes
public function integer wf_delete_chk (string sitnbr, string sopseq)
end prototypes

public function integer wf_delete_chk (string sitnbr, string sopseq);long  l_cnt

SELECT COUNT(*)
  INTO :l_cnt
  FROM "PSTRUC"  
 WHERE ( "PSTRUC"."PINBR" = :sItnbr ) AND ( "PSTRUC"."OPSNO" = :sOpseq )   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[생산BOM]')
	return -1
end if

SELECT COUNT(*)
  INTO :l_cnt
  FROM MOMAST, MOROUT  
 WHERE ( MOMAST.SABU = MOROUT.SABU) and  
       ( MOMAST.PORDNO = MOROUT.PORDNO)  and  
       ( ( MOMAST.STDITNBR = :sItnbr ) AND  
       ( MOROUT.OPSEQ = :sOpseq ) )   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[작업지시]')
	return -1
end if

return 1
end function

event open;f_window_center(this)

dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_delete.settransobject(sqlca)

dw_1.InsertRow(0)
end event

on w_pdm_01440_delete.create
this.p_inq=create p_inq
this.p_del=create p_del
this.p_exit=create p_exit
this.dw_delete=create dw_delete
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_inq,&
this.p_del,&
this.p_exit,&
this.dw_delete,&
this.dw_1,&
this.dw_list,&
this.rr_1}
end on

on w_pdm_01440_delete.destroy
destroy(this.p_inq)
destroy(this.p_del)
destroy(this.p_exit)
destroy(this.dw_delete)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
end on

type p_inq from uo_picture within w_pdm_01440_delete
integer x = 1335
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sItnbr

if dw_1.AcceptText() = -1 then return 
sItnbr = dw_1.GetItemString(1,"itnbr")

IF sItnbr ="" OR IsNull(sItnbr) THEN
	Messagebox("확 인","품번을 입력하세요!!")
   dw_1.setcolumn('itnbr')
   dw_1.setfocus()
	Return
END IF

dw_list.Retrieve(sItnbr)
dw_delete.Retrieve(sItnbr)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

type p_del from uo_picture within w_pdm_01440_delete
integer x = 1509
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;string	sWorkPlace,snull, sitem, sopseq
long		lRow, lRowCount

SetNull(snull)

lRowCount = dw_list.RowCount()

if lRowCount < 1 then return 

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", &
						         question!, yesno!, 2)  = 2		THEN return 

////////////////////////////////////////////////////
FOR	lRow = lRowCount	TO		1		STEP  -1
      sitem = dw_list.getitemstring(lrow, 'itnbr')	
      sopseq = dw_list.getitemstring(lrow, 'opseq')	
		if wf_delete_chk(sitem, sopseq) = -1 then continue
	   
		dw_list.DeleteRow(lRow)
		
		DELETE FROM ROUTNG_RESOURCE
		 WHERE ITNBR = :sitem
			AND OPSEQ = :sopseq
			AND GUBUN = 'M';
NEXT
		
IF dw_list.Update() > 0 THEN			
	COMMIT USING sqlca;
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
	RETURN 
END IF

///////////////////////////////////////////////////
FOR lRow = 1	TO	 lRowCount

	sWorkPlace = dw_delete.GetItemString(lRow, "wkctr")
	if f_WorkCount(sWorkPlace) = -1 then 
		rollback;
		messagebox('확 인', '작업장 갱신 실패')
      return 
	end if	

NEXT

COMMIT;

dw_1.SetItem(1, "itnbr", snull)
dw_1.SetItem(1, "itdsc", snull)
dw_1.SetItem(1, "ispec", snull)
dw_1.SetItem(1, "jijil", snull)
dw_1.SetItem(1, "ispec_code", snull)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

type p_exit from uo_picture within w_pdm_01440_delete
integer x = 1682
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

type dw_delete from datawindow within w_pdm_01440_delete
boolean visible = false
integer x = 187
integer y = 2100
integer width = 357
integer height = 172
string dragicon = "Rectangle!"
boolean titlebar = true
string title = "삭제 공정"
string dataobject = "d_pdm_01440_copy2"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_pdm_01440_delete
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 55
integer y = 172
integer width = 1746
integer height = 160
integer taborder = 10
string dataobject = "d_pdm_01440_copy1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
		
		p_inq.TriggerEvent(clicked!)
		RETURN 1
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sitnbr, sitdsc, sispec, sjijil, sispec_code
integer  ireturn

IF this.getcolumnname() = "itnbr"	THEN
	sitnbr = this.gettext()
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
elseIF this.getcolumnname() = "itdsc"	THEN
	sitdsc = this.gettext()
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
ELSEIF this.getcolumnname() = "ispec"	THEN
	sispec = this.gettext()
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
ELSEIF this.getcolumnname() = "jijil"	THEN
	sjijil = this.gettext()
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
ELSEIF this.getcolumnname() = "ispec_code"	THEN
	sispec_code = this.gettext()
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
end if
dw_list.Retrieve(sItnbr)
dw_delete.Retrieve(sItnbr)
return  ireturn

end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(gsbom)

IF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	this.setitem(1, "jijil", gsbom)
	
	p_inq.TriggerEvent(clicked!)
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	this.setitem(1, "jijil", gsbom)
	
	p_inq.TriggerEvent(clicked!)
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	this.setitem(1, "jijil", gsbom)
	
	p_inq.TriggerEvent(clicked!)
	
END IF
	
	

end event

event itemerror;RETURN 1
end event

type dw_list from datawindow within w_pdm_01440_delete
integer x = 64
integer y = 340
integer width = 1769
integer height = 1588
string dragicon = "Rectangle!"
string dataobject = "d_pdm_01440_copy2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdm_01440_delete
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 160
integer width = 1810
integer height = 1784
integer cornerheight = 40
integer cornerwidth = 55
end type

