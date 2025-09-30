$PBExportHeader$w_pdm_01450.srw
$PBExportComments$** 품목별 표준공정 A/T 일괄 변경
forward
global type w_pdm_01450 from w_inherite
end type
type gb_1 from groupbox within w_pdm_01450
end type
type dw_1 from datawindow within w_pdm_01450
end type
type rb_1 from radiobutton within w_pdm_01450
end type
type rb_2 from radiobutton within w_pdm_01450
end type
type rb_3 from radiobutton within w_pdm_01450
end type
type st_2 from statictext within w_pdm_01450
end type
type st_3 from statictext within w_pdm_01450
end type
type st_4 from statictext within w_pdm_01450
end type
type pb_1 from u_pb_cal within w_pdm_01450
end type
type pb_2 from u_pb_cal within w_pdm_01450
end type
type rr_1 from roundrectangle within w_pdm_01450
end type
end forward

global type w_pdm_01450 from w_inherite
string title = "품목별 표준공정 A/T 일괄 변경"
gb_1 gb_1
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_2 st_2
st_3 st_3
st_4 st_4
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_pdm_01450 w_pdm_01450

type variables

end variables

on w_pdm_01450.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.rr_1
end on

on w_pdm_01450.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()


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

type dw_insert from w_inherite`dw_insert within w_pdm_01450
integer x = 55
integer y = 296
integer width = 4530
integer height = 1780
integer taborder = 30
string dataobject = "d_pdm_01450_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::editchanged;return 1
end event

event dw_insert::doubleclicked;if row < 1 then return 

gs_code     = this.getitemstring(row, 'stditnbr')
gs_codename = this.getitemstring(row, 'opseq')
gs_gubun    = this.getitemstring(row, 'gigan')

open(w_pdm_01450_popup)


end event

type p_delrow from w_inherite`p_delrow within w_pdm_01450
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01450
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdm_01450
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdm_01450
integer x = 3749
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdm_01450
end type

type p_can from w_inherite`p_can within w_pdm_01450
end type

event p_can::clicked;call super::clicked;dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()

dw_1.setcolumn('fr_date')
dw_1.setfocus()
dw_1.insertrow(0)

dw_1.setredraw(true)
dw_insert.setredraw(true)





end event

type p_print from w_inherite`p_print within w_pdm_01450
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdm_01450
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string sfdate, stdate, sfteam, stteam, sfitnbr, stitnbr, sfcode, stcode

if dw_1.AcceptText() = -1 then return 

sFdate  = trim(dw_1.GetItemString(1, 'fr_date'))
sTdate  = trim(dw_1.GetItemString(1, 'to_date'))
sFteam  = trim(dw_1.GetItemString(1, 'fr_team'))
sTteam  = trim(dw_1.GetItemString(1, 'to_team'))
sFitnbr = trim(dw_1.GetItemString(1, 'fr_itnbr'))
sTitnbr = trim(dw_1.GetItemString(1, 'to_itnbr'))
sFcode  = trim(dw_1.GetItemString(1, 'fr_opcod'))
sTcode  = trim(dw_1.GetItemString(1, 'to_opcod'))

if isnull(sFdate) or sFdate = "" then
	f_message_chk(30,'[지시기간 FROM]')
	dw_1.SetColumn('fr_date')
	dw_1.SetFocus()
	return
end if	

if isnull(sTdate) or sTdate = "" then
	f_message_chk(30,'[지시기간 TO]')
	dw_1.SetColumn('to_date')
	dw_1.SetFocus()
	return
end if	

if isnull(sFteam)  or sFteam  = "" then sFteam = "."
if isnull(sTteam)  or sTteam  = "" then sTteam = "zzzzzz"
if isnull(sFitnbr) or sFitnbr = "" then sFitnbr = "."
if isnull(sTitnbr) or sTitnbr = "" then sTitnbr = "zzzzzzzzzzzzzzz"
if isnull(sFcode)  or sFcode  = "" then sFcode = "."
if isnull(sTcode)  or sTcode  = "" then sTcode = "zzzzzz"

SetPointer(HourGlass!)

dw_insert.setredraw(false)

IF rb_1.checked then  //품번순
	dw_insert.SetSort("stditnbr A, opseq A")
ELSEIF rb_2.checked then  //품명순
	dw_insert.SetSort("itdsc A, ispec A, stditnbr A, opseq A")
ELSE  //공정 순
   dw_insert.SetSort("opseq A, stditnbr A")
END IF
dw_insert.Sort()

if dw_insert.Retrieve( gs_sabu, sFdate, sTdate, sFteam, sTteam, sFitnbr, sTitnbr, &
                       sFcode,   sTcode ) <= 0 then 
	f_message_chk(50,'')
	dw_1.SetColumn('fr_date')
	dw_1.Setfocus()
   dw_insert.setredraw(true)
	return
else
	dw_insert.SetFocus()
end if	

dw_insert.setredraw(true)

end event

type p_del from w_inherite`p_del within w_pdm_01450
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdm_01450
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Long   k, lCount
Dec{2} dTime, dMctime
String sitnbr, sopseq, sCalgu

if dw_insert.AcceptText() = -1 then return 

lCount = dw_insert.rowcount()

if lCount <= 0 then return 	

if f_msg_update() = -1 then return
w_mdi_frame.sle_msg.text = "표준공정에 자료 적용중......."
SetPointer(HourGlass!)

FOR k = 1 TO lCount
	IF dw_insert.GetItemString(k, 'opt') = 'Y' THEN 
		sitnbr = dw_insert.GetItemString(k, 'stditnbr')
		sopseq = dw_insert.GetItemString(k, 'opseq')
		scalgu = dw_insert.GetItemString(k, 'calgu')
		dtime  = dw_insert.GetItemDecimal(k, 'update_time')
		dmctime  = dw_insert.GetItemDecimal(k, 'update_mctime')
			
		UPDATE "ROUTNG"  
			SET "MANHR1" = :dtime, "MCHR1" = :dmctime    
		 WHERE ( "ROUTNG"."ITNBR" = :sitnbr ) AND  
				 ( "ROUTNG"."OPSEQ" = :sopseq )   ;

		IF SQLCA.SQLCODE <> 0 THEN 
			ROLLBACK ;
			w_mdi_frame.sle_msg.text = ''
			messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
		RETURN 
	END IF

	END IF	
		
NEXT

COMMIT ;
w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"

end event

type cb_exit from w_inherite`cb_exit within w_pdm_01450
integer x = 4187
integer y = 5000
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01450
integer x = 3520
integer y = 5000
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01450
boolean visible = false
integer x = 539
integer y = 2472
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01450
boolean visible = false
integer x = 1143
integer y = 2392
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01450
integer x = 3515
integer y = 5000
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_pdm_01450
boolean visible = false
integer x = 645
integer y = 5000
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdm_01450
end type

type cb_can from w_inherite`cb_can within w_pdm_01450
integer x = 3845
integer y = 5000
integer taborder = 50
end type

type cb_search from w_inherite`cb_search within w_pdm_01450
boolean visible = false
integer x = 2619
integer y = 2532
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01450
integer x = 9
integer y = 5000
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01450
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01450
end type

type gb_1 from groupbox within w_pdm_01450
integer x = 3026
integer width = 407
integer height = 268
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "조회순서"
end type

type dw_1 from datawindow within w_pdm_01450
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 16
integer width = 3003
integer height = 244
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01450"
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

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
end if	

end event

event itemchanged;String  s_cod

s_cod = Trim(this.GetText())

IF this.GetColumnName() = "fr_date" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지시기간]")
		this.object.fr_date[1] = ""
		return 1
	end if	
ELSEIF this.GetColumnName() = "to_date" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지시기간]")
		this.object.to_date[1] = ""
		return 1
	end if	
END IF
end event

type rb_1 from radiobutton within w_pdm_01450
integer x = 3090
integer y = 56
integer width = 279
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "품번순"
boolean checked = true
end type

event clicked;dw_insert.SetSort("stditnbr A, opseq A")
dw_insert.Sort()

end event

type rb_2 from radiobutton within w_pdm_01450
integer x = 3090
integer y = 120
integer width = 279
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "품명순"
end type

event clicked;dw_insert.SetSort("itdsc A, ispec A, stditnbr A, opseq A")
dw_insert.Sort()

end event

type rb_3 from radiobutton within w_pdm_01450
integer x = 3090
integer y = 184
integer width = 279
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "공정순"
end type

event clicked;dw_insert.SetSort("opseq A, stditnbr A")
dw_insert.Sort()

end event

type st_2 from statictext within w_pdm_01450
integer x = 14
integer y = 2116
integer width = 1893
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "표준 && 평균시간 = 표준공정에 표준 && 평균시간 / 시간기준수량"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdm_01450
integer x = 14
integer y = 2192
integer width = 1943
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "실적 A/T = 기간내 작업실적(MAN && M/C)시간SUM/ 작업실적수량SUM"
boolean focusrectangle = false
end type

type st_4 from statictext within w_pdm_01450
integer x = 14
integer y = 2264
integer width = 1893
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "저장시 표준공정에 적용되는 A/T = 확정 A/T * 시간기준수량"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_pdm_01450
integer x = 722
integer y = 32
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('fr_date')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'fr_date', gs_code)

end event

type pb_2 from u_pb_cal within w_pdm_01450
integer x = 1170
integer y = 32
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('to_date')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'to_date', gs_code)


end event

type rr_1 from roundrectangle within w_pdm_01450
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 272
integer width = 4594
integer height = 1824
integer cornerheight = 40
integer cornerwidth = 55
end type

