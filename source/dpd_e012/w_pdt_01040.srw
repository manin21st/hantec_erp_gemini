$PBExportHeader$w_pdt_01040.srw
$PBExportComments$** 계획 ORDER 관리
forward
global type w_pdt_01040 from w_inherite
end type
type dw_1 from datawindow within w_pdt_01040
end type
type st_2 from statictext within w_pdt_01040
end type
type rr_4 from roundrectangle within w_pdt_01040
end type
end forward

global type w_pdt_01040 from w_inherite
string title = "계획 ORDER 관리"
dw_1 dw_1
st_2 st_2
rr_4 rr_4
end type
global w_pdt_01040 w_pdt_01040

type variables

end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_planset (decimal dactno)
public function integer wf_required_chk (long i)
end prototypes

public subroutine wf_reset ();dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()
dw_1.insertrow(0)

//wf_planset('1')   //년간계획 

dw_1.setredraw(true)
dw_insert.setredraw(true)


end subroutine

public function integer wf_planset (decimal dactno);String syymm, sgijun, snull
int    iseq, inull

select mrpgiyymm, mrpseq, mrpdata
  into :syymm, :iseq, :sgijun
  from mrpsys
 where sabu = :gs_sabu and actno = :dActno;

if sqlca.sqlcode = 0 then
	dw_1.setitem(1, "plangub", sgijun)
	IF sgijun = '1' THEN //년간계획
		dw_1.setitem(1, 'syear', syymm) 
		dw_1.setitem(1, 'iseq',  iseq) 
	ELSE   //연동계획
		dw_1.setitem(1, 'syymm', syymm) 
		dw_1.setitem(1, 'igub',  iseq) 
	END IF	
	return 1	
else
	setnull(sNull)	
	setnull(iNull)	
	dw_1.setitem(1, "plangub", sNull)
	dw_1.setitem(1, 'syear', sNull) 
	dw_1.setitem(1, 'syymm', sNull) 
	dw_1.setitem(1, 'iseq',  iNull) 
	dw_1.setitem(1, 'igub',  iNull) 
	return -1
end if

end function

public function integer wf_required_chk (long i);if dw_insert.AcceptText() = -1 then return -1


//if isnull(dw_insert.GetItemNumber(i,'unprc')) or &
//	dw_insert.GetItemNumber(i,'unprc') = 0 then
//	f_message_chk(1400,'[ '+string(i)+' 행 발주단가]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('unprc')
//	dw_insert.SetFocus()
//	return -1		
//end if	

if dw_insert.GetItemString(i,'stdat') > "" and &
   dw_insert.GetItemString(i,'dudat') > "" then
   if dw_insert.GetItemString(i,'stdat') > dw_insert.GetItemString(i,'dudat') then
		f_message_chk(34,'[ '+string(i)+' 행 시작일]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('stdat')
		dw_insert.SetFocus()
		return -1		
   end if	
end if	

return 1
end function

on w_pdt_01040.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_4
end on

on w_pdt_01040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.rr_4)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)

wf_reset()

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

type dw_insert from w_inherite`dw_insert within w_pdt_01040
integer x = 27
integer y = 432
integer width = 4562
integer height = 1880
integer taborder = 20
string dataobject = "d_pdt_01040_1"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;String snull, s_date
long ll_row

SetNull(snull)

ll_row = this.getrow()

IF this.GetColumnName() ="stdat" THEN  //시작일
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[시작일]')
		this.SetItem(ll_row,"stdat",snull)
		this.Setcolumn("stdat")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() ="dudat" THEN  //납기일
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[납기일]')
		this.SetItem(1,"dudat",snull)
		this.Setcolumn("dudat")
		this.SetFocus()
		Return 1
	END IF
END IF	
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_pdt_01040
boolean visible = false
integer x = 3374
integer y = 40
end type

type p_addrow from w_inherite`p_addrow within w_pdt_01040
boolean visible = false
integer x = 3319
end type

type p_search from w_inherite`p_search within w_pdt_01040
integer x = 41
boolean originalsize = true
string picturename = "C:\erpman\image\확정_up.gif"
end type

event p_search::clicked;call super::clicked;open(w_pdt_01050)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\확정_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\확정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pdt_01040
boolean visible = false
integer x = 3639
end type

type p_exit from w_inherite`p_exit within w_pdt_01040
integer x = 4434
end type

type p_can from w_inherite`p_can within w_pdt_01040
integer x = 4261
end type

event p_can::clicked;call super::clicked;
wf_reset()

ib_any_typing = FALSE

//cb_search.enabled = true
p_search.enabled = true	
p_search.PictureName = 'C:\erpman\image\확정_up.gif'
end event

type p_print from w_inherite`p_print within w_pdt_01040
boolean visible = false
integer x = 3291
end type

type p_inq from w_inherite`p_inq within w_pdt_01040
integer x = 3913
end type

event p_inq::clicked;call super::clicked;string s_plgub, s_team, s_fritnbr, s_toitnbr, s_ittyp
decimal d_actno

if dw_1.AcceptText() = -1 then return 

d_actno = dw_1.GetItemDecimal(1,'actno')  //계획구분 
s_plgub = dw_1.GetItemString(1,'plangub')  //계획구분 
s_ittyp = dw_1.GetItemString(1,'ittyp')    //품목구분


if isnull(s_ittyp) or s_ittyp = "" then
	f_message_chk(30,'[품목구분]')
	dw_1.Setcolumn('ittyp')
	dw_1.SetFocus()
	return
end if	

if s_ittyp = '1' or s_ittyp = '2' then 
	s_team = dw_1.GetItemString(1,'steam')  //생산팀 
	if isnull(s_team) or s_team = "" then
		f_message_chk(30,'[생산팀]')
		dw_1.Setcolumn('steam')
		dw_1.SetFocus()
		return
	else
		dw_insert.SetFilter("pdtgu = '"+ s_team +" '")
		dw_insert.Filter()
	end if	
else
	dw_insert.SetFilter("")
	dw_insert.Filter()
end if

s_fritnbr = dw_1.GetItemString(1,'fr_itnbr')  //품번
s_toitnbr = dw_1.GetItemString(1,'to_itnbr')  //품번

if isnull(s_fritnbr) or s_fritnbr = "" then s_fritnbr = '.'
if isnull(s_toitnbr) or s_toitnbr = "" then s_toitnbr = 'zzzzzzzzzzzzzzz'

if dw_insert.Retrieve(gs_sabu, d_actno, s_plgub, s_ittyp, s_fritnbr, s_toitnbr, gs_saupcd) <= 0 then 
	f_message_chk(50,'')
	dw_1.SetFocus()
	p_search.enabled = true	
	p_search.PictureName = 'C:\erpman\image\확정_up.gif'
   return 
else
	dw_insert.SetFocus()
end if	

p_search.enabled = false
p_search.PictureName = 'C:\erpman\image\확정_d.gif'
	
ib_any_typing = FALSE

end event

type p_del from w_inherite`p_del within w_pdt_01040
boolean visible = false
integer x = 4087
end type

type p_mod from w_inherite`p_mod within w_pdt_01040
integer x = 4091
end type

event p_mod::clicked;call super::clicked;long i

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 

sle_msg.text = '자료를 검색중입니다'

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

sle_msg.text = ''

if f_msg_update() = -1 then return

if dw_insert.update() = 1 then
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
	
end event

type cb_exit from w_inherite`cb_exit within w_pdt_01040
integer x = 2917
integer y = 40
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_pdt_01040
integer x = 2213
integer y = 40
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_pdt_01040
integer x = 457
integer y = 2480
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_01040
integer x = 448
integer y = 2480
end type

type cb_inq from w_inherite`cb_inq within w_pdt_01040
integer x = 1221
integer y = 40
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pdt_01040
integer x = 539
integer y = 2472
end type

type st_1 from w_inherite`st_1 within w_pdt_01040
end type

type cb_can from w_inherite`cb_can within w_pdt_01040
integer x = 2565
integer y = 40
end type

type cb_search from w_inherite`cb_search within w_pdt_01040
integer x = 1573
integer y = 40
integer width = 590
integer taborder = 30
boolean enabled = false
string text = "계획ORDER 확정"
end type





type gb_10 from w_inherite`gb_10 within w_pdt_01040
integer x = 183
integer y = 2368
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_01040
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_01040
end type

type dw_1 from datawindow within w_pdt_01040
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 200
integer width = 4622
integer height = 228
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_01040_a"
boolean border = false
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string  sitnbr, sitdsc, sispec, s_gub
int     ireturn
decimal dactno

if this.getcolumnname() = 'actno' then
	dactno = dec(this.gettext())
		 
	if wf_planset(dactno) = -1 then
		f_message_chk(33, '[MRP실행순번]')
   	this.setitem(1, "actno", 0)	
		return 1
	end if
	
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
END IF
end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF this.GetcolumnName() ="fr_itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.SetItem(1,"fr_itdsc",gs_codename)
	this.SetItem(1,"fr_ispec",gs_gubun)
ELSEIF this.GetcolumnName() ="to_itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.SetItem(1,"to_itdsc",gs_codename)
	this.SetItem(1,"to_ispec",gs_gubun)
ELSEIF this.GetcolumnName() ="actno" THEN
	open(w_mrpsys_popup)
	
	this.setitem(1, "actno", double(gs_code))
	this.triggerevent(itemchanged!)
END IF	
end event

type st_2 from statictext within w_pdt_01040
integer x = 347
integer y = 68
integer width = 1774
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long textcolor = 16711680
long backcolor = 32106727
string text = "계획ORDER 확정은 년/월간 계획 확정 임."
boolean focusrectangle = false
end type

type rr_4 from roundrectangle within w_pdt_01040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 428
integer width = 4590
integer height = 1888
integer cornerheight = 40
integer cornerwidth = 55
end type

