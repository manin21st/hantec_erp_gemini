$PBExportHeader$w_pdm_01345.srw
$PBExportComments$�۾����� ����ǰ����
forward
global type w_pdm_01345 from w_inherite
end type
type gb_3 from groupbox within w_pdm_01345
end type
type gb_2 from groupbox within w_pdm_01345
end type
type dw_1 from datawindow within w_pdm_01345
end type
type rr_1 from roundrectangle within w_pdm_01345
end type
end forward

global type w_pdm_01345 from w_inherite
integer width = 4640
integer height = 2504
string title = "�ڵ��۾����� ����ǰ�� ����"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
rr_1 rr_1
end type
global w_pdm_01345 w_pdm_01345

type variables
str_itnct lstr_sitnct
String is_itnbr
boolean ib_changed
end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
end prototypes

public function integer wf_required_chk (integer i);//if dw_insert.AcceptText() = -1 then return -1
//
//if isnull(dw_insert.GetItemNumber(i,'vnqty')) or &
//	dw_insert.GetItemNumber(i,'vnqty') = 0 then
//	f_message_chk(1400,'[ '+string(i)+' �� ���ֿ�����]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('vnqty')
//	dw_insert.SetFocus()
//	return -1		
//end if	

return 1
end function

public subroutine wf_reset ();string snull

setnull(snull)

p_ins.enabled = true

dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()

dw_1.setcolumn('ittyp')
dw_1.setfocus()
dw_1.insertrow(0)

dw_1.setredraw(true)
dw_insert.setredraw(true)


end subroutine

on w_pdm_01345.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_pdm_01345.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

f_mod_saupj(dw_1, 'porgu')


end event

event key;// Page Up & Page Down & Home & End Key ��� ����
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

type dw_insert from w_inherite`dw_insert within w_pdm_01345
integer x = 32
integer y = 304
integer width = 4558
integer height = 2004
integer taborder = 40
string dataobject = "d_pdm_01345_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;string  snull, sitnbr, sitdsc, sispec, sjijil, sispec_code
integer ireturn
long    lrow, get_count

lrow = this.getrow()
this.AcceptText()

IF this.GetColumnName() = "stdnbr"	THEN
//	sItnbr = trim(this.GetText())
	sItnbr = trim(this.GETITEMSTRING(lrow,'stdnbr'))
	IF sitnbr = "" OR IsNull(sitnbr) THEN
		this.SetItem(lrow,"itemas_itdsc",snull)
		this.SetItem(lrow,"itemas_ispec",snull)
		this.SetItem(lrow,"itemas_ispec_code",snull)
		this.SetItem(lrow,"itemas_jijil",snull)
		RETURN
	END IF

	ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	
	if ireturn = 0 then
		 	ib_changed = true
			is_itnbr   = sItnbr
			
			this.setitem(lrow, "stdnbr", sitnbr)
			this.setitem(lrow, "itemas_itdsc", sitdsc)	
			this.setitem(lrow, "itemas_ispec", sispec)
			this.setitem(lrow, "itemas_ispec_code", sispec_code)
			this.setitem(lrow, "itemas_jijil", sjijil)
//			return 0      
			this.TriggerEvent(itemFocusChanged!)
	else	
		this.setitem(lrow, "stdnbr", snull)	
		this.SetItem(lrow,"itemas_itdsc",snull)
		this.SetItem(lrow,"itemas_ispec",snull)
		this.SetItem(lrow,"itemas_ispec_code",snull)
		this.SetItem(lrow,"itemas_jijil",snull)
		return 1
	end if	
END IF


end event

event dw_insert::rbuttondown;string  snull, sitnbr, sitdsc, sispec, sjijil, sispec_code
integer ireturn
long    lrow, get_count

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
IF this.GetcolumnName() ="stdnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	this.SetItem(lRow,"stdnbr",gs_code)
	this.TriggerEvent("itemchanged")

//	sItnbr = gs_code
	
//	IF sitnbr = "" OR IsNull(sitnbr) THEN
//		this.SetItem(lrow,"itemas_itdsc",snull)
//		this.SetItem(lrow,"itemas_ispec",snull)
//		this.SetItem(lrow,"itemas_ispec_code",snull)
//		this.SetItem(lrow,"itemas_jijil",snull)
//		RETURN
//	END IF
//
//	ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
//	
//	if ireturn = 0 then
//			this.setitem(lrow, "stdnbr", sitnbr)
//			this.setColumn("stdnbr")
//			this.TriggerEvent(ItemChanged!)
//			this.setitem(lrow, "itemas_itdsc", sitdsc)	
//			this.setitem(lrow, "itemas_ispec", sispec)
//			this.setitem(lrow, "itemas_ispec_code", sispec_code)
//			this.setitem(lrow, "itemas_jijil", sjijil)
//	      return 
//	else	
//		this.setitem(lrow, "stdnbr", snull)	
//		this.SetItem(lrow,"itemas_itdsc",snull)
//		this.SetItem(lrow,"itemas_ispec",snull)
//		this.SetItem(lrow,"itemas_ispec_code",snull)
//		this.SetItem(lrow,"itemas_jijil",snull)
//		return 1
//	end if	

END IF
end event

event dw_insert::updatestart;/* Update() function ȣ��� user ���� */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;If ib_changed = True Then
	this.setItem( row, 'stdnbr', is_itnbr)
	ib_changed = False
//	return
End If
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01345
boolean visible = false
integer x = 3355
integer y = 3440
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01345
boolean visible = false
integer x = 3182
integer y = 3440
end type

type p_search from w_inherite`p_search within w_pdm_01345
boolean visible = false
integer x = 2487
integer y = 3440
end type

type p_ins from w_inherite`p_ins within w_pdm_01345
integer x = 3749
boolean enabled = false
end type

event p_ins::clicked;call super::clicked;long lrow

lrow = dw_insert.insertrow(0)
dw_insert.setfocus()
end event

type p_exit from w_inherite`p_exit within w_pdm_01345
end type

type p_can from w_inherite`p_can within w_pdm_01345
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdm_01345
integer x = 4096
end type

event p_print::clicked;call super::clicked;OpenWithParm(w_print_options, dw_insert)
end event

type p_inq from w_inherite`p_inq within w_pdm_01345
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string s_ittyp, s_itcls, sfilter, newsort, ls_porgu

if dw_1.AcceptText() = -1 then return 

s_ittyp 	= dw_1.GetItemString(1,'ittyp')
s_itcls 	= dw_1.GetItemString(1,'itcls')
ls_porgu 	= dw_1.GetItemString(1,'porgu')

if 	isnull(s_ittyp) or s_ittyp = "" then
	f_message_chk(30,'[ǰ�񱸺�]')
	dw_1.SetColumn('ittyp')
	dw_1.SetFocus()
	return
end if	

SetPointer(HourGlass!)

dw_insert.setredraw(false)

if 	isnull(s_itcls) or s_itcls = "" then 
   	sfilter = ""
else
	s_itcls = s_itcls + '%'
   	sfilter = " itemas_itcls  like '"+ s_itcls +"' "
end if	

dw_insert.SetFilter(sfilter)
dw_insert.Filter( )

if 	dw_insert.Retrieve(ls_porgu, s_ittyp) <= 0 then 
   	dw_insert.setredraw(true)
else
	dw_insert.SetFocus()
end if	

//wf_color_change()

ib_any_typing = FALSE

dw_insert.setredraw(true)
p_ins.enabled = true

end event

type p_del from w_inherite`p_del within w_pdm_01345
boolean visible = false
integer x = 3703
integer y = 3440
end type

type p_mod from w_inherite`p_mod within w_pdm_01345
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	

if f_msg_update() = -1 then return

SetPointer(HourGlass!)
	
if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
	return 
end if	
		
p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01345
integer x = 4005
integer y = 3244
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01345
integer x = 3301
integer y = 3244
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;//if dw_insert.AcceptText() = -1 then return 
//
//if dw_insert.rowcount() <= 0 then return 	
//
//if f_msg_update() = -1 then return
//
//SetPointer(HourGlass!)
//	
//if dw_insert.update() = 1 then
//	sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//	messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
//	return 
//end if	
//		
//cb_inq.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_pdm_01345
integer x = 567
integer y = 2848
string text = "�߰�(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01345
integer x = 1170
integer y = 2768
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01345
integer x = 73
integer y = 3232
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;//string s_ittyp, s_itcls, sfilter, newsort
//
//if dw_1.AcceptText() = -1 then return 
//
//s_ittyp = dw_1.GetItemString(1,'ittyp')
//s_itcls = dw_1.GetItemString(1,'itcls')
//
//if isnull(s_ittyp) or s_ittyp = "" then
//	f_message_chk(30,'[ǰ�񱸺�]')
//	dw_1.SetColumn('ittyp')
//	dw_1.SetFocus()
//	return
//end if	
//
//SetPointer(HourGlass!)
//
//dw_insert.setredraw(false)
//
//if isnull(s_itcls) or s_itcls = "" then 
//   sfilter = ""
//else
//	s_itcls = s_itcls + '%'
//   sfilter = " itemas_itcls  like '"+ s_itcls +"' "
//end if	
//
//dw_insert.SetFilter(sfilter)
//dw_insert.Filter( )
//
//if dw_insert.Retrieve(s_ittyp) <= 0 then 
//	dw_1.Setfocus()
//   dw_insert.setredraw(true)
//	return
//else
//	dw_insert.SetFocus()
//end if	
//
////wf_color_change()
//
//ib_any_typing = FALSE
//
//dw_insert.setredraw(true)
//
end event

type cb_print from w_inherite`cb_print within w_pdm_01345
integer x = 425
integer y = 3232
integer taborder = 30
end type

event cb_print::clicked;call super::clicked;//OpenWithParm(w_print_options, dw_insert)
end event

type st_1 from w_inherite`st_1 within w_pdm_01345
end type

type cb_can from w_inherite`cb_can within w_pdm_01345
integer x = 3653
integer y = 3244
end type

event cb_can::clicked;call super::clicked;//wf_reset()
//ib_any_typing = FALSE
//
//
//
end event

type cb_search from w_inherite`cb_search within w_pdm_01345
integer x = 2647
integer y = 2908
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01345
integer y = 2960
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01345
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01345
end type

type gb_3 from groupbox within w_pdm_01345
boolean visible = false
integer x = 3259
integer y = 3184
integer width = 1120
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 79741120
end type

type gb_2 from groupbox within w_pdm_01345
boolean visible = false
integer x = 27
integer y = 3172
integer width = 777
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_1 from datawindow within w_pdm_01345
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 28
integer width = 3483
integer height = 232
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01345_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;str_itnct str_sitnct

setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" Then
		this.accepttext()
		gs_code = this.getitemstring(1, 'ittyp')
		
		open(w_ittyp_popup2)
		
		str_sitnct = Message.PowerObjectParm	
		
		if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
			return
		end if
	
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp)
		this.SetItem(1,"itcls", str_sitnct.s_sumgub)
		this.SetItem(1,"itnm", str_sitnct.s_titnm)
      p_inq.TriggerEvent(Clicked!)
   End If
END IF

end event

event itemerror;return 1
end event

event rbuttondown;string sname

if this.GetColumnName() = 'itcls' then
   	this.accepttext()
	SetNull(gs_gubun)
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itnm", lstr_sitnct.s_titnm)
   p_inq.TriggerEvent(Clicked!)
end if	
end event

event itemchanged;string	s_Itcls, s_Name, s_itt, snull
int      ireturn 

setnull(snull)

//============================================================================

Choose Case this.GetColumnName()
	Case	"ittyp" 
		s_itt = this.gettext()
 
   		IF s_itt = "" OR IsNull(s_itt) THEN 
			this.SetItem(1,'itcls', snull)
			this.SetItem(1,'itnm', snull)
      		dw_insert.reset()
			RETURN
   		END IF
	
		s_name = f_get_reffer('05', s_itt)
		if isnull(s_name) or s_name="" then
			f_message_chk(33,'[ǰ�񱸺�]')
			this.SetItem(1,'ittyp', snull)
			this.SetItem(1,'itcls', snull)
			this.SetItem(1,'itnm', snull)
      		dw_insert.reset()
			return 1
		else	
			this.SetItem(1,'itcls', snull)
			this.SetItem(1,'itnm', snull)
   		end if
	Case	"itcls" 
		s_itcls = this.gettext()
   		IF s_itcls = "" OR IsNull(s_itcls) THEN 
			this.SetItem(1,'itnm', snull)
      		dw_insert.reset()
   		ELSE
			s_itt  = this.getitemstring(1, 'ittyp')
			ireturn = f_get_name2('ǰ��з�', 'Y', s_itcls, s_name, s_itt)
			This.setitem(1, 'itcls', s_itcls)
			This.setitem(1, 'itnm', s_name)
   		END IF
//   		p_inq.TriggerEvent(Clicked!)
		return ireturn 
End Choose

//============================================================================


end event

type rr_1 from roundrectangle within w_pdm_01345
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 296
integer width = 4581
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

