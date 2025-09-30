$PBExportHeader$w_pdm_01300.srw
$PBExportComments$영업 대표 품목 관리
forward
global type w_pdm_01300 from w_inherite
end type
type gb_3 from groupbox within w_pdm_01300
end type
type gb_2 from groupbox within w_pdm_01300
end type
type dw_1 from datawindow within w_pdm_01300
end type
type rr_1 from roundrectangle within w_pdm_01300
end type
end forward

global type w_pdm_01300 from w_inherite
string title = "영업 대표 품목 관리"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
rr_1 rr_1
end type
global w_pdm_01300 w_pdm_01300

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public subroutine wf_color_change ()
end prototypes

public function integer wf_required_chk (integer i);//if dw_insert.AcceptText() = -1 then return -1
//
//if isnull(dw_insert.GetItemNumber(i,'vnqty')) or &
//	dw_insert.GetItemNumber(i,'vnqty') = 0 then
//	f_message_chk(1400,'[ '+string(i)+' 행 발주예정량]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('vnqty')
//	dw_insert.SetFocus()
//	return -1		
//end if	

return 1
end function

public subroutine wf_reset ();string snull

setnull(snull)

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

public subroutine wf_color_change ();long k, lcount

if dw_insert.AcceptText() = -1 then return 

lcount = dw_insert.rowcount()

if lcount < 1 then return 

FOR k=2 TO lcount
	if dw_insert.getitemstring(k - 1, 'itnbryd') <> dw_insert.getitemstring(k, 'itnbryd') then 
		if dw_insert.getitemstring(k - 1, 'yopt') = 'Y'	then
			dw_insert.setitem(k, 'yopt', 'N')
		else
			dw_insert.setitem(k, 'yopt', 'Y')
		end if	
	else
		dw_insert.setitem(k, 'yopt', dw_insert.getitemstring(k - 1, 'yopt'))
	end if	
NEXT



end subroutine

on w_pdm_01300.create
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

on w_pdm_01300.destroy
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

type dw_insert from w_inherite`dw_insert within w_pdm_01300
integer x = 37
integer y = 280
integer width = 4553
integer height = 2028
integer taborder = 30
string dataobject = "d_pdm_01301"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;string  snull, sitnbr, sitdsc, sispec, sjijil, sispec_code
integer ireturn
long    lrow

lrow = this.getrow()

IF this.GetColumnName() = "itnbryd"	THEN
	sItnbr = trim(this.GetText())

	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbryd", sitnbr)	
	this.setitem(lrow, "yitdsc", sitdsc)	
	this.setitem(lrow, "yispec", sispec)
	this.setitem(lrow, "yispec_code", sispec_code)
	this.setitem(lrow, "yjijil", sjijil)
	RETURN ireturn
ELSEIF this.GetColumnName() = "yitdsc"	THEN
	sitdsc = trim(this.GetText())

	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbryd", sitnbr)	
	this.setitem(lrow, "yitdsc", sitdsc)	
	this.setitem(lrow, "yispec", sispec)
	this.setitem(lrow, "yispec_code", sispec_code)
	this.setitem(lrow, "yjijil", sjijil)
	RETURN ireturn
ELSEIF this.GetColumnName() = "yispec"	THEN
	sispec = trim(this.GetText())

	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbryd", sitnbr)	
	this.setitem(lrow, "yitdsc", sitdsc)	
	this.setitem(lrow, "yispec", sispec)
	this.setitem(lrow, "yispec_code", sispec_code)
	this.setitem(lrow, "yjijil", sjijil)
	RETURN ireturn
ELSEIF this.GetColumnName() = "yjijil"	THEN
	sjijil = trim(this.GetText())

	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbryd", sitnbr)	
	this.setitem(lrow, "yitdsc", sitdsc)	
	this.setitem(lrow, "yispec", sispec)
	this.setitem(lrow, "yispec_code", sispec_code)
	this.setitem(lrow, "yjijil", sjijil)
	RETURN ireturn
ELSEIF this.GetColumnName() = "yispec_code"	THEN
	sispec_code = trim(this.GetText())

	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbryd", sitnbr)	
	this.setitem(lrow, "yitdsc", sitdsc)	
	this.setitem(lrow, "yispec", sispec)
	this.setitem(lrow, "yispec_code", sispec_code)
	this.setitem(lrow, "yjijil", sjijil)
	RETURN ireturn
END IF
end event

event dw_insert::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
IF this.GetcolumnName() ="itnbryd" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(lrow,"itnbryd",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1
END IF
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01300
boolean visible = false
integer x = 3986
integer y = 3484
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01300
boolean visible = false
integer x = 3813
integer y = 3484
end type

type p_search from w_inherite`p_search within w_pdm_01300
boolean visible = false
integer x = 3118
integer y = 3484
end type

type p_ins from w_inherite`p_ins within w_pdm_01300
boolean visible = false
integer x = 3639
integer y = 3484
end type

type p_exit from w_inherite`p_exit within w_pdm_01300
end type

type p_can from w_inherite`p_can within w_pdm_01300
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdm_01300
boolean visible = false
integer x = 3291
integer y = 3484
end type

type p_inq from w_inherite`p_inq within w_pdm_01300
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string s_ittyp, s_itcls, ls_porgu

if dw_1.AcceptText() = -1 then return 

s_ittyp 	= trim(dw_1.GetItemString(1,'ittyp'))
s_itcls	 	= trim(dw_1.GetItemString(1,'itcls'))
ls_porgu 	= trim(dw_1.GetItemString(1,'porgu'))

if isnull(s_ittyp) or s_ittyp = "" then
	f_message_chk(30,'[품목구분]')
	dw_1.SetColumn('ittyp')
	dw_1.SetFocus()
	return
end if	

SetPointer(HourGlass!)

dw_insert.setredraw(false)

if isnull(s_itcls) or s_itcls = "" then 
   s_itcls = "%"
else
	s_itcls = s_itcls + '%'
end if	

if dw_insert.Retrieve(ls_porgu,s_ittyp, s_itcls) <= 0 then 
	dw_1.Setfocus()
   dw_insert.setredraw(true)
	return
else
	dw_insert.SetFocus()
end if	

wf_color_change()

ib_any_typing = FALSE

dw_insert.setredraw(true)

end event

type p_del from w_inherite`p_del within w_pdm_01300
boolean visible = false
integer x = 4334
integer y = 3484
end type

type p_mod from w_inherite`p_mod within w_pdm_01300
integer x = 4096
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	

if f_msg_update() = -1 then return

SetPointer(HourGlass!)
	
if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01300
integer x = 2816
integer y = 3248
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01300
integer x = 2112
integer y = 3248
integer taborder = 40
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
//	sle_msg.text = "자료가 저장되었습니다!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//	return 
//end if	
//		
//cb_inq.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_pdm_01300
integer x = 471
integer y = 3428
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01300
integer x = 1074
integer y = 3348
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01300
integer x = 1687
integer y = 3256
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;//string s_ittyp, s_itcls
//
//if dw_1.AcceptText() = -1 then return 
//
//s_ittyp = trim(dw_1.GetItemString(1,'ittyp'))
//s_itcls = trim(dw_1.GetItemString(1,'itcls'))
//
//if isnull(s_ittyp) or s_ittyp = "" then
//	f_message_chk(30,'[품목구분]')
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
//   s_itcls = "%"
//else
//	s_itcls = s_itcls + '%'
//end if	
//
//if dw_insert.Retrieve(s_ittyp, s_itcls) <= 0 then 
//	dw_1.Setfocus()
//   dw_insert.setredraw(true)
//	return
//else
//	dw_insert.SetFocus()
//end if	
//
//wf_color_change()
//
//ib_any_typing = FALSE
//
//dw_insert.setredraw(true)
//
end event

type cb_print from w_inherite`cb_print within w_pdm_01300
integer x = 1915
integer y = 3500
end type

type st_1 from w_inherite`st_1 within w_pdm_01300
end type

type cb_can from w_inherite`cb_can within w_pdm_01300
integer x = 2464
integer y = 3248
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;//wf_reset()
//ib_any_typing = FALSE
//
//
//
end event

type cb_search from w_inherite`cb_search within w_pdm_01300
integer x = 2551
integer y = 3488
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01300
integer y = 2968
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01300
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01300
end type

type gb_3 from groupbox within w_pdm_01300
boolean visible = false
integer x = 2071
integer y = 3188
integer width = 1120
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type gb_2 from groupbox within w_pdm_01300
boolean visible = false
integer x = 1641
integer y = 3196
integer width = 421
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_1 from datawindow within w_pdm_01300
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 20
integer width = 3465
integer height = 228
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01300"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;str_itnct str_sitnct

setnull(gs_code)

IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
ELSEIF key = keyF2! THEN
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
			f_message_chk(33,'[품목구분]')
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
			ireturn = f_get_name2('품목분류', 'Y', s_itcls, s_name, s_itt)
			This.setitem(1, 'itcls', s_itcls)
			This.setitem(1, 'itnm', s_name)
   		END IF
//   		p_inq.TriggerEvent(Clicked!)
		return ireturn 
End Choose

//============================================================================

end event

type rr_1 from roundrectangle within w_pdm_01300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 264
integer width = 4576
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

