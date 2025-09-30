$PBExportHeader$w_imt_03037.srw
$PBExportComments$** 입고 예정 등록
forward
global type w_imt_03037 from w_inherite
end type
type dw_cond from datawindow within w_imt_03037
end type
type rb_1 from radiobutton within w_imt_03037
end type
type rb_2 from radiobutton within w_imt_03037
end type
type dw_update from datawindow within w_imt_03037
end type
type rr_1 from roundrectangle within w_imt_03037
end type
type rr_2 from roundrectangle within w_imt_03037
end type
end forward

global type w_imt_03037 from w_inherite
string title = "입고 예정 등록"
dw_cond dw_cond
rb_1 rb_1
rb_2 rb_2
dw_update dw_update
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_03037 w_imt_03037

type variables
STRING is_gbn
end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();dw_cond.Reset()
dw_Insert.Reset()
dw_update.Reset()

dw_cond.InsertRow(0)
f_mod_saupj(dw_cond, 'saupj')

dw_insert.SetColumn('poblno')
dw_insert.SetFocus()

if is_gbn = '1' then
	dw_insert.Dataobject = 'd_imt_03037_02'
else
	dw_insert.Dataobject = 'd_imt_03037_03'
end if

dw_insert.SetTransobject(sqlca)
ib_any_typing = false
end subroutine

on w_imt_03037.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_update=create dw_update
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_update
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_imt_03037.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_update)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;is_gbn = '1'

dw_cond.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_update.SetTransObject(sqlca)
wf_init()

end event

type dw_insert from w_inherite`dw_insert within w_imt_03037
integer x = 18
integer y = 244
integer width = 4576
integer height = 1996
string dataobject = "d_imt_03037_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_imt_03037
boolean visible = false
integer x = 3278
integer y = 32
end type

type p_addrow from w_inherite`p_addrow within w_imt_03037
boolean visible = false
integer x = 3451
integer y = 32
end type

type p_search from w_inherite`p_search within w_imt_03037
boolean visible = false
integer x = 2757
integer y = 32
end type

type p_ins from w_inherite`p_ins within w_imt_03037
boolean visible = false
integer x = 2930
integer y = 32
end type

type p_exit from w_inherite`p_exit within w_imt_03037
end type

type p_can from w_inherite`p_can within w_imt_03037
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_imt_03037
boolean visible = false
integer x = 3104
integer y = 32
end type

type p_inq from w_inherite`p_inq within w_imt_03037
integer x = 3922
end type

event p_inq::clicked;call super::clicked;if dw_cond.AcceptText() <> 1 then Return

STRING sblno, ssaupj

ssaupj = dw_cond.Getitemstring(1, 'saupj')
sblno  = dw_cond.Getitemstring(1, 'poblno')

IF isnull(sBlno) or sBlno = "" 	THEN
	f_message_chk(30,'[B/L번호]')
	dw_cond.SetColumn("poblno")
	dw_cond.SetFocus()
	RETURN
END IF

if dw_insert.Retrieve(gs_sabu, sblno, ssaupj) < 1 then
	f_message_chk(50, '[B/L번호]')
	dw_cond.setcolumn("poblno")
	dw_cond.setfocus()
END IF

dw_insert.SetColumn('ipdate')
dw_insert.SetFocus()

ib_any_typing = False
end event

type p_del from w_inherite`p_del within w_imt_03037
boolean visible = false
integer x = 2565
integer y = 40
end type

type p_mod from w_inherite`p_mod within w_imt_03037
integer x = 4096
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() <> 1 then return

string sdate, sblno, slcno, sbigo,spono
long i, dseq

if is_gbn = '1' then	
	for i = 1 to dw_insert.Rowcount()
		sdate = dw_insert.GetItemString(i, 'ipdate')
		
		if sdate = '' or isNull(sdate) then
			f_message_chk(30,'[입고예정일]')
			dw_insert.SetRow(i)
			dw_insert.SetColumn("ipdate")
			return
			dw_insert.setFocus()
		End if
	Next
	
	for i = 1 to dw_insert.Rowcount()
		dw_update.InsertRow(0)
		dw_update.SetItem(i, 'sabu',  gs_sabu)
		dw_update.SetItem(i, 'saupj',  dw_cond.GetItemString(1, 'saupj'))
		dw_update.SetItem(i, 'poblno', dw_insert.GetItemString(i, 'poblno'))
		dw_update.SetItem(i, 'polcno', dw_insert.GetItemString(i, 'polcbl_polcno'))
		dw_update.SetItem(i, 'baljpno', dw_insert.GetItemString(i, 'baljpno'))
		dw_update.SetItem(i, 'balseq', dw_insert.GetItemNumber(i, 'balseq'))
		dw_update.SetItem(i, 'ipdate', dw_insert.GetItemString(i, 'ipdate'))
		dw_update.SetItem(i, 'bigo', dw_insert.GetItemString(i, 'bigo'))		
	Next
	
	if dw_update.Update() <> 1 then
		rollback;
		return
	end if
	
else	
	if dw_insert.Update() <> 1 then
		rollback;
		return
	end if
end if

commit;

wf_init()
end event

type cb_exit from w_inherite`cb_exit within w_imt_03037
end type

type cb_mod from w_inherite`cb_mod within w_imt_03037
end type

type cb_ins from w_inherite`cb_ins within w_imt_03037
end type

type cb_del from w_inherite`cb_del within w_imt_03037
end type

type cb_inq from w_inherite`cb_inq within w_imt_03037
end type

type cb_print from w_inherite`cb_print within w_imt_03037
end type

type st_1 from w_inherite`st_1 within w_imt_03037
end type

type cb_can from w_inherite`cb_can within w_imt_03037
end type

type cb_search from w_inherite`cb_search within w_imt_03037
end type







type gb_button1 from w_inherite`gb_button1 within w_imt_03037
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_03037
end type

type dw_cond from datawindow within w_imt_03037
integer y = 32
integer width = 1893
integer height = 176
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_imt_03037_01"
boolean border = false
boolean livescroll = true
end type

event rbuttondown;string sNull
long   dcnt

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

Choose Case GetColumnName()
	Case 'poblno'
		open(w_bl_popup3)
		
		if gs_code = '' or isNull(gs_code) then return
		
		setitem(1, 'poblno', gs_code)
		
		select count(*) into :dcnt
		  from pobl_ipgo
		 where poblno = :gs_code;
		
		if dcnt > 0 then
			rb_2.checked = true
			dw_insert.dataobject = 'd_imt_03037_03'
			dw_insert.SetTransobject(sqlca)
		else
			rb_1.checked = true
			dw_insert.dataobject = 'd_imt_03037_02'
			dw_insert.SetTransobject(sqlca)
		end if
		
		p_inq.TriggerEvent(Clicked!)
		
		
End Choose
end event

type rb_1 from radiobutton within w_imt_03037
integer x = 1943
integer y = 60
integer width = 302
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등  록"
boolean checked = true
end type

event clicked;is_gbn = '1'

wf_init()
end event

type rb_2 from radiobutton within w_imt_03037
integer x = 1943
integer y = 136
integer width = 302
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수  정"
end type

event clicked;is_gbn = '2'

wf_init()
end event

type dw_update from datawindow within w_imt_03037
boolean visible = false
integer x = 2839
integer y = 20
integer width = 686
integer height = 180
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_imt_03037_04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_imt_03037
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer y = 232
integer width = 4622
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_03037
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1897
integer y = 36
integer width = 389
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

