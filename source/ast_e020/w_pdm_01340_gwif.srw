$PBExportHeader$w_pdm_01340_gwif.srw
$PBExportComments$품목정보 변경(NEW)
forward
global type w_pdm_01340_gwif from w_inherite
end type
type gb_3 from groupbox within w_pdm_01340_gwif
end type
type gb_2 from groupbox within w_pdm_01340_gwif
end type
type dw_1 from datawindow within w_pdm_01340_gwif
end type
type dw_2 from u_d_popup_sort within w_pdm_01340_gwif
end type
type cbx_1 from checkbox within w_pdm_01340_gwif
end type
type dw_3 from uo_multi_select within w_pdm_01340_gwif
end type
type p_1 from picture within w_pdm_01340_gwif
end type
type p_2 from picture within w_pdm_01340_gwif
end type
type cb_1 from commandbutton within w_pdm_01340_gwif
end type
type rr_1 from roundrectangle within w_pdm_01340_gwif
end type
end forward

global type w_pdm_01340_gwif from w_inherite
string title = "품목정보 변경-NEW"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
dw_2 dw_2
cbx_1 cbx_1
dw_3 dw_3
p_1 p_1
p_2 p_2
cb_1 cb_1
rr_1 rr_1
end type
global w_pdm_01340_gwif w_pdm_01340_gwif

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_item_chk (string sitem)
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
end prototypes

public function integer wf_item_chk (string sitem);long  get_count

SELECT COUNT(*)  
  INTO :get_count
  FROM "ITEMAS"  
 WHERE "ITEMAS"."STDNBR" = :sitem  ;

if get_count > 0 then 
	messagebox("확 인", "표준품번으로 등록된 자료는 사용정지/단종 시킬 수 없습니다.")
	return -1
end if	

return 1
end function

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

//dw_2.setredraw(false)
dw_3.setredraw(false)
dw_1.setredraw(false)

//dw_2.reset()
dw_3.reset()
dw_1.reset()

dw_1.setcolumn('ittyp')
dw_1.setfocus()
dw_1.insertrow(0)

dw_1.setredraw(true)
//dw_2.setredraw(true)
dw_3.setredraw(true)


end subroutine

on w_pdm_01340_gwif.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cbx_1=create cbx_1
this.dw_3=create dw_3
this.p_1=create p_1
this.p_2=create p_2
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.p_2
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.rr_1
end on

on w_pdm_01340_gwif.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cbx_1)
destroy(this.dw_3)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event open;call super::open;//dw_2.SetTransObject(sqlca)
dw_3.SetTransObject(SQLCA)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

//f_mod_saupj(dw_1, 'porgu')

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
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyT!
		p_ins.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01340_gwif
integer x = 471
integer y = 796
integer width = 2295
integer height = 648
integer taborder = 70
string dataobject = "d_pdm_01340"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sitnbr, sgub, sold
long   lrow

lrow = this.getrow()

IF this.GetColumnName() = "itemas_gwif_useyn"	THEN
	sitnbr = this.getitemstring(lrow, "itemas_gwif_itnbr")
	sold   = this.getitemstring(lrow, "itemas_gwif_useyn")
	sgub   = trim(this.GetText())
   if sold = '0' then 
		if wf_item_chk(sitnbr) = -1 then
			return 1 
		end if	
	end if
END IF
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
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

event dw_insert::clicked;call super::clicked;//If Row <= 0 then
//	dw_insert.SelectRow(0,False)
//	b_flag =True
//ELSE
//
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
//	
//	b_flag = False
//END IF
//
//CALL SUPER ::CLICKED
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01340_gwif
boolean visible = false
integer x = 4041
integer y = 2792
integer taborder = 90
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01340_gwif
boolean visible = false
integer x = 3867
integer y = 2792
integer taborder = 80
end type

type p_search from w_inherite`p_search within w_pdm_01340_gwif
boolean visible = false
integer x = 3173
integer y = 2792
integer taborder = 170
end type

type p_ins from w_inherite`p_ins within w_pdm_01340_gwif
boolean visible = false
integer x = 3694
integer y = 2792
integer taborder = 50
end type

type p_exit from w_inherite`p_exit within w_pdm_01340_gwif
integer taborder = 160
end type

type p_can from w_inherite`p_can within w_pdm_01340_gwif
integer taborder = 150
end type

event clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE
end event

type p_print from w_inherite`p_print within w_pdm_01340_gwif
boolean visible = false
integer x = 3346
integer y = 2792
integer taborder = 180
end type

type p_inq from w_inherite`p_inq within w_pdm_01340_gwif
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string s_ittyp, s_itcls, sfilter, newsort, sSaupj, sCvcod, schk, s_itgu, s_itnbr

if dw_1.AcceptText() = -1 then return 

s_ittyp = dw_1.GetItemString(1,'ittyp')
s_itcls = dw_1.GetItemString(1,'itcls')
sSaupj  = dw_1.GetItemString(1,'porgu') 
sCvcod  = dw_1.GetItemString(1,'cvcod') 
s_itgu  = dw_1.GetItemString(1,'itemas_itgu')
s_itnbr  = dw_1.GetItemString(1,'itnbr')

If Trim(sSaupj) = '' OR IsNull(sSaupj) Then sSaupj = '%'

// VAN 임시등록품번 조회
if dw_1.GetItemString(1,'tempchk') = 'Y' then
	s_ittyp = '1'
	s_itcls = '9999'
	schk = 'Y'
else
	schk = '%'
end if


if isnull(s_ittyp) or s_ittyp = "" then
	f_message_chk(30,'[품목구분]')
	dw_1.SetColumn('ittyp')
	dw_1.SetFocus()
	return
end if	

if isnull(sCvcod) or sCvcod = "" then
   sCvcod = '%'
End if

If Trim(s_itgu) = '' OR IsNull(s_itgu) Then s_itgu = '%'
If Trim(s_itnbr) = '' OR IsNull(s_itnbr) Then 
	s_itnbr = '%'
Else
	s_itnbr = s_itnbr + '%'
End If

SetPointer(HourGlass!)

dw_3.setredraw(false)

if isnull(s_itcls) Then s_itcls = ""

if dw_3.Retrieve(sSaupj, s_ittyp, s_itcls, schk, s_itgu, s_itnbr) <= 0 then 
	dw_1.Setfocus()
   dw_3.setredraw(true)
	return
else
	dw_3.SetFocus()
end if	

ib_any_typing = FALSE

dw_3.setredraw(true)

end event

type p_del from w_inherite`p_del within w_pdm_01340_gwif
boolean visible = false
integer x = 4389
integer y = 2792
integer taborder = 130
end type

type p_mod from w_inherite`p_mod within w_pdm_01340_gwif
boolean visible = false
integer x = 4096
integer taborder = 110
end type

event p_mod::clicked;call super::clicked;//if dw_2.AcceptText() = -1 then return 
//
//if dw_2.rowcount() <= 0 then return 	
//
//if f_msg_update() = -1 then return
//
//SetPointer(HourGlass!)
//	
//if dw_2.update() = 1 then
//	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//	return 
//end if	
//		
//p_inq.TriggerEvent(Clicked!)

if dw_3.AcceptText() = -1 then return 

if dw_3.rowcount() <= 0 then return 	

if f_msg_update() = -1 then return

SetPointer(HourGlass!)
	
if dw_3.update() = 1 then
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

type cb_exit from w_inherite`cb_exit within w_pdm_01340_gwif
integer x = 2825
integer y = 2640
integer taborder = 140
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01340_gwif
integer x = 2126
integer y = 2640
integer taborder = 100
end type

event cb_mod::clicked;call super::clicked;//if dw_2.AcceptText() = -1 then return 
//
//if dw_2.rowcount() <= 0 then return 	
//
//if f_msg_update() = -1 then return
//
//SetPointer(HourGlass!)
//	
//if dw_2.update() = 1 then
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

type cb_ins from w_inherite`cb_ins within w_pdm_01340_gwif
integer x = 581
integer y = 2816
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01340_gwif
integer x = 1184
integer y = 2736
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01340_gwif
integer x = 1641
integer y = 2648
integer width = 329
integer taborder = 60
end type

event cb_inq::clicked;call super::clicked;//string s_ittyp, s_itcls, sfilter, newsort
//
//if dw_1.AcceptText() = -1 then return 
//
//s_ittyp = dw_1.GetItemString(1,'ittyp')
//s_itcls = dw_1.GetItemString(1,'itcls')
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
//dw_2.setredraw(false)
//
//if isnull(s_itcls) Then s_itcls = ""
//
//if dw_2.Retrieve(s_ittyp, s_itcls) <= 0 then 
//	dw_1.Setfocus()
//   dw_2.setredraw(true)
//	return
//else
//	dw_2.SetFocus()
//end if	
//
//ib_any_typing = FALSE
//
//dw_2.setredraw(true)
//
end event

type cb_print from w_inherite`cb_print within w_pdm_01340_gwif
integer x = 686
integer y = 2668
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdm_01340_gwif
end type

type cb_can from w_inherite`cb_can within w_pdm_01340_gwif
integer x = 2473
integer y = 2640
integer taborder = 120
end type

event cb_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type cb_search from w_inherite`cb_search within w_pdm_01340_gwif
integer x = 2661
integer y = 2876
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01340_gwif
integer y = 2976
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01340_gwif
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01340_gwif
end type

type gb_3 from groupbox within w_pdm_01340_gwif
boolean visible = false
integer x = 2080
integer y = 2580
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

type gb_2 from groupbox within w_pdm_01340_gwif
boolean visible = false
integer x = 1591
integer y = 2588
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

type dw_1 from datawindow within w_pdm_01340_gwif
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 28
integer width = 3415
integer height = 224
integer taborder = 20
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
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itnm", lstr_sitnct.s_titnm)
//   p_inq.TriggerEvent(Clicked!)
	
elseif this.GetColumnName() ="cvcod" THEN
	
	SetNull(gs_gubun)
   SetNull(gs_code)
   SetNull(gs_codename)

   OPEN(W_VNDMST_POPUP)
	this.SetItem(1,"cvcod",gs_code)
	this.SetItem(1,"cvnas2",gs_codename)
	
end if	
end event

event itemchanged;string	s_Itcls, s_Name, s_itt, snull, scode, s_name2
int      ireturn 

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
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
//      cb_inq.TriggerEvent(Clicked!)
   end if

ELSEIF this.GetColumnName() = "tempchk"	THEN
		this.SetItem(1,'ittyp', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
	

ELSEIF this.GetColumnName() = "itcls"	THEN
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
   p_inq.TriggerEvent(Clicked!)
	return ireturn 
ELSEIF this.GetColumnName() = "cvcod" THEN
	scode = this.GetText()
	
	ireturn = f_get_name2('V0', 'N', scode, s_name, s_name2)
	This.SetItem(1,"cvcod" ,scode)
	This.SetItem(1,"cvnas2",s_name)
   return ireturn 
END IF
end event

type dw_2 from u_d_popup_sort within w_pdm_01340_gwif
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
boolean visible = false
integer x = 27
integer y = 2120
integer width = 160
integer height = 156
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_pdm_01340"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event clicked;call super::clicked;If Row <= 0 then
	dw_2.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event itemchanged;call super::itemchanged;String sitnbr, sgub, sold
long   lrow

lrow = this.getrow()

IF this.GetColumnName() = "itemas_gwif_useyn"	THEN
	sitnbr = this.getitemstring(lrow, "itemas_gwif_itnbr")
	sold   = this.getitemstring(lrow, "itemas_gwif_useyn")
	sgub   = trim(this.GetText())
   if sold = '0' then 
		if wf_item_chk(sitnbr) = -1 then
			return 1 
		end if	
	end if
END IF
end event

event updatestart;call super::updatestart;/* Update() function 호출시 user 설정 */
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

event itemerror;call super::itemerror;return 1
end event

type cbx_1 from checkbox within w_pdm_01340_gwif
integer x = 3525
integer y = 188
integer width = 334
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "일괄변경"
end type

type dw_3 from uo_multi_select within w_pdm_01340_gwif
integer x = 37
integer y = 280
integer width = 4562
integer height = 2032
integer taborder = 40
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_pdm_01340_gwif"
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

event itemchanged;call super::itemchanged;String ls_itnbr
String ls_old

Long    i

Boolean lb_char

String  ls_col

ls_col = dwo.name

If Not IsNull(ls_col) Then
	If LEFT(Describe(ls_col + '.coltype'), 4) = 'char' Then
		lb_char = True
	Else
		lb_char = False
	End If
	
	If cbx_1.Checked = True Then
		For i = 1 To This.RowCount()
			IF IsSelected(i) Then
				If lb_char Then
					This.SetItem(i, ls_col, data)
					
					IF this.GetColumnName() = "itemas_gwif_useyn"	THEN
						ls_itnbr = this.getitemstring(i, "itemas_gwif_itnbr")
						ls_old   = this.getitemstring(i, "itemas_gwif_useyn")
						if ls_old = '0' then 
							if wf_item_chk(ls_itnbr) = -1 then
								return 1 
							end if	
						end if
					END IF
					
				Else
					This.SetItem(i, ls_col, DEC(data))
				End If
			End If
		Next
		SelectRow(0, False)
	End If
End If
end event

event updatestart;call super::updatestart;/* Update() function 호출시 user 설정 */
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

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;String ls_itnbr
String ls_old

Long    i

Boolean lb_char

String  ls_col

ls_col = dwo.name

Choose Case ls_col
	Case 'itcls'
		If Not IsNull(ls_col) Then
			String ls_ittyp
			
			ls_ittyp = This.GetItemString(row, 'itemas_gwif_ittyp')
			OpenWithParm(w_ittyp_popup4, ls_ittyp)
			
			lstr_sitnct = Message.PowerObjectParm
			
			If IsValid(lstr_sitnct) = False Then Return
			
			If cbx_1.Checked = True Then
				For i = 1 To This.RowCount()
					IF IsSelected(i) Then
						This.SetItem(i, 'itemas_gwif_ittyp', lstr_sitnct.s_ittyp)
						This.SetItem(i, ls_col, lstr_sitnct.s_sumgub)
						This.SetItem(i, 'itnct', lstr_sitnct.s_titnm)
					End If
				Next
				SelectRow(0, False)
			Else
				This.SetItem(row, 'itemas_gwif_ittyp', lstr_sitnct.s_ittyp)
				This.SetItem(row, ls_col, lstr_sitnct.s_sumgub)
				This.SetItem(row, 'itnct', lstr_sitnct.s_titnm)
			End If
		End If
End Choose
end event

event clicked;//
string ls_keydowntype

IF row <= 0 THEN 
//	MESSAGEBOX("Select", "선택된 자료가 없읍니다")
	RETURN
END IF

IF Keydown(KeyShift!) THEN
	ufi_shift_highlight(ROW)
ELSEIF this.IsSelected(ROW) THEN
	il_lastclickedrow = ROW
	ib_action_on_buttonup = TRUE
ELSEIF Keydown(KeyControl!) THEN
	il_lastclickedrow = ROW
	this.SelectRow(ROW, TRUE)
ELSE
	il_lastclickedrow = ROW
	this.SelectRow(0, FALSE)
	this.SelectRow(ROW, TRUE)
END IF 

end event

type p_1 from picture within w_pdm_01340_gwif
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 3749
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\정렬_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\정렬_up.gif'
end event

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\정렬_dn.gif'
end event

event clicked;Openwithparm(w_sort, dw_3)
end event

type p_2 from picture within w_pdm_01340_gwif
integer x = 4096
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\결재상신_up.gif"
boolean focusrectangle = false
end type

event clicked;If dw_3.AcceptText() = -1 Then Return

If dw_3.Find(" gw_chk = 'Y' ", 1, dw_3.RowCount()) <= 0 Then
	MessageBox('확인', '전자결재 대상 자료가 선택되지 않았습니다!')
	Return
End If	

if MessageBox('확인', '그룹웨어 전자결재 상신하시겠습니까?', Question!, YesNo!, 2) = 2 then return

SetPointer(HourGlass!)
	
if dw_3.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if

Long			i, ii
String			ls_key, ls_keys[], ls_formno, ls_docno

ls_formno = '18'		//양식번호-18 : 품목정보변경

For i = 1 To dw_3.RowCount()
	If dw_3.GetItemString(i, 'gw_chk') <> 'Y' Then Continue
	
	// Unique 조건값, 2개이상이면 구분자(|)로 문자열 조합 => ex) ls_cvcod + '|' + ls_itnbr
	ls_key = dw_3.GetItemString(i, 'itemas_gwif_itnbr')

//	// 기등록된 그룹웨어 전자결재 문서인지 확인
//	ls_docno = f_gwif_docno(ls_formno, ls_key)
//	If ls_docno > '.' Then
//		dw_3.SetItem(i, 'gw_chk', 'N')
//		f_gwif_inquiry(ls_docno, gs_empno);
//		Return
//	End If
	
	ii++
	ls_keys[ii] = ls_key
Next

// 그룹웨어 전자결재 상신
f_gwif_approval(ls_formno, is_window_id, gs_empno, ls_keys)

end event

type cb_1 from commandbutton within w_pdm_01340_gwif
boolean visible = false
integer x = 3986
integer y = 180
integer width = 402
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "PDF Merge"
end type

event clicked;f_gwif_pdfmerge()
end event

type rr_1 from roundrectangle within w_pdm_01340_gwif
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 272
integer width = 4581
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

