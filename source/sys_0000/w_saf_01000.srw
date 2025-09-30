$PBExportHeader$w_saf_01000.srw
$PBExportComments$** 안전재고
forward
global type w_saf_01000 from w_inherite
end type
type tab1 from tab within w_saf_01000
end type
type tabpage1 from userobject within tab1
end type
type gb_2 from groupbox within tabpage1
end type
type dw_ins1 from u_key_enter within tabpage1
end type
type cb_11 from commandbutton within tabpage1
end type
type cb_9 from commandbutton within tabpage1
end type
type cb_10 from commandbutton within tabpage1
end type
type tabpage1 from userobject within tab1
gb_2 gb_2
dw_ins1 dw_ins1
cb_11 cb_11
cb_9 cb_9
cb_10 cb_10
end type
type tabpage2 from userobject within tab1
end type
type rr_1 from roundrectangle within tabpage2
end type
type dw_2 from u_key_enter within tabpage2
end type
type cb_save from commandbutton within tabpage2
end type
type dw_ins2 from u_key_enter within tabpage2
end type
type cb_4 from commandbutton within tabpage2
end type
type cb_5 from commandbutton within tabpage2
end type
type cb_jo from commandbutton within tabpage2
end type
type cb_7 from commandbutton within tabpage2
end type
type cb_12 from commandbutton within tabpage2
end type
type cb_13 from commandbutton within tabpage2
end type
type tabpage2 from userobject within tab1
rr_1 rr_1
dw_2 dw_2
cb_save cb_save
dw_ins2 dw_ins2
cb_4 cb_4
cb_5 cb_5
cb_jo cb_jo
cb_7 cb_7
cb_12 cb_12
cb_13 cb_13
end type
type tabpage3 from userobject within tab1
end type
type st_2 from statictext within tabpage3
end type
type dw_ins3 from u_key_enter within tabpage3
end type
type cb_2 from commandbutton within tabpage3
end type
type tabpage3 from userobject within tab1
st_2 st_2
dw_ins3 dw_ins3
cb_2 cb_2
end type
type tabpage4 from userobject within tab1
end type
type rr_2 from roundrectangle within tabpage4
end type
type dw_jojung1 from datawindow within tabpage4
end type
type cb_1 from commandbutton within tabpage4
end type
type cb_3 from commandbutton within tabpage4
end type
type cb_6 from commandbutton within tabpage4
end type
type cb_8 from commandbutton within tabpage4
end type
type dw_jojung from datawindow within tabpage4
end type
type tabpage4 from userobject within tab1
rr_2 rr_2
dw_jojung1 dw_jojung1
cb_1 cb_1
cb_3 cb_3
cb_6 cb_6
cb_8 cb_8
dw_jojung dw_jojung
end type
type tab1 from tab within w_saf_01000
tabpage1 tabpage1
tabpage2 tabpage2
tabpage3 tabpage3
tabpage4 tabpage4
end type
end forward

global type w_saf_01000 from w_inherite
string title = "안전재고 계산"
tab1 tab1
end type
global w_saf_01000 w_saf_01000

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public subroutine wf_close ()
end prototypes

public subroutine wf_close ();close(this)
end subroutine

on w_saf_01000.create
int iCurrent
call super::create
this.tab1=create tab1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab1
end on

on w_saf_01000.destroy
call super::destroy
destroy(this.tab1)
end on

event open;call super::open;tab1.tabpage1.dw_ins1.SetTransObject(SQLCA)
tab1.tabpage2.dw_2.SetTransObject(SQLCA)
tab1.tabpage2.dw_ins2.SetTransObject(SQLCA)
tab1.tabpage3.dw_ins3.SetTransObject(SQLCA)
tab1.tabpage4.dw_jojung.SetTransObject(SQLCA)
tab1.tabpage4.dw_jojung1.SetTransObject(SQLCA)

tab1.tabpage2.dw_2.InsertRow(0)
tab1.tabpage3.dw_ins3.InsertRow(0)
tab1.tabpage4.dw_jojung.insertrow(0)

string syymm

select max(safyymm) into :syymm from zsafcal;

tab1.tabpage4.dw_jojung.setitem(1, "giyymm", syymm)

tab1.SelectTab(1)
if tab1.tabpage1.dw_ins1.Retrieve(gs_sabu) < 1 then
	tab1.tabpage1.dw_ins1.InsertRow(0)
	tab1.tabpage1.dw_ins1.SetFocus()
end if	



end event

type dw_insert from w_inherite`dw_insert within w_saf_01000
boolean visible = false
integer x = 14
integer y = 8
integer width = 535
integer height = 132
end type

event dw_insert::itemchanged;STRING s_date, snull

setnull(snull)

IF this.GetColumnName() ="syymm" THEN
	s_date = trim(this.GetText())
	
	if s_date = "" or isnull(s_date) then return 

  	IF f_datechk(s_date + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", left(f_today(), 6))
		return 1
	END IF
END IF
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_saf_01000
end type

type p_addrow from w_inherite`p_addrow within w_saf_01000
end type

type p_search from w_inherite`p_search within w_saf_01000
end type

type p_ins from w_inherite`p_ins within w_saf_01000
end type

type p_exit from w_inherite`p_exit within w_saf_01000
end type

type p_can from w_inherite`p_can within w_saf_01000
end type

type p_print from w_inherite`p_print within w_saf_01000
end type

type p_inq from w_inherite`p_inq within w_saf_01000
end type

type p_del from w_inherite`p_del within w_saf_01000
end type

type p_mod from w_inherite`p_mod within w_saf_01000
end type

type cb_exit from w_inherite`cb_exit within w_saf_01000
boolean visible = false
integer x = 2697
integer y = 2444
integer height = 120
integer taborder = 40
end type

event cb_exit::clicked;close(parent)
end event

type cb_mod from w_inherite`cb_mod within w_saf_01000
boolean visible = false
integer x = 649
integer y = 2612
end type

type cb_ins from w_inherite`cb_ins within w_saf_01000
boolean visible = false
integer x = 2363
integer y = 2444
integer height = 120
string text = "생성(&G)"
end type

type cb_del from w_inherite`cb_del within w_saf_01000
boolean visible = false
integer x = 1015
integer y = 2612
end type

type cb_inq from w_inherite`cb_inq within w_saf_01000
boolean visible = false
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_saf_01000
boolean visible = false
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_saf_01000
end type

type cb_can from w_inherite`cb_can within w_saf_01000
boolean visible = false
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_saf_01000
boolean visible = false
integer x = 2459
integer y = 2612
end type







type gb_button1 from w_inherite`gb_button1 within w_saf_01000
end type

type gb_button2 from w_inherite`gb_button2 within w_saf_01000
end type

type tab1 from tab within w_saf_01000
integer x = 50
integer y = 192
integer width = 4535
integer height = 2124
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
alignment alignment = center!
integer selectedtab = 1
tabpage1 tabpage1
tabpage2 tabpage2
tabpage3 tabpage3
tabpage4 tabpage4
end type

on tab1.create
this.tabpage1=create tabpage1
this.tabpage2=create tabpage2
this.tabpage3=create tabpage3
this.tabpage4=create tabpage4
this.Control[]={this.tabpage1,&
this.tabpage2,&
this.tabpage3,&
this.tabpage4}
end on

on tab1.destroy
destroy(this.tabpage1)
destroy(this.tabpage2)
destroy(this.tabpage3)
destroy(this.tabpage4)
end on

event selectionchanged;sle_msg.text = ""
if newindex = 1 then
	tab1.tabpage1.dw_ins1.SetFocus()
elseif newindex = 2 then
	tab1.tabpage2.dw_2.SetFocus()
elseif newindex = 3 then
	tab1.tabpage3.dw_ins3.SetFocus()
end if	
	
end event

type tabpage1 from userobject within tab1
integer x = 18
integer y = 96
integer width = 4498
integer height = 2012
long backcolor = 32106727
string text = "안전재고 기초정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
gb_2 gb_2
dw_ins1 dw_ins1
cb_11 cb_11
cb_9 cb_9
cb_10 cb_10
end type

on tabpage1.create
this.gb_2=create gb_2
this.dw_ins1=create dw_ins1
this.cb_11=create cb_11
this.cb_9=create cb_9
this.cb_10=create cb_10
this.Control[]={this.gb_2,&
this.dw_ins1,&
this.cb_11,&
this.cb_9,&
this.cb_10}
end on

on tabpage1.destroy
destroy(this.gb_2)
destroy(this.dw_ins1)
destroy(this.cb_11)
destroy(this.cb_9)
destroy(this.cb_10)
end on

type gb_2 from groupbox within tabpage1
integer x = 1563
integer y = 2284
integer width = 494
integer height = 360
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type dw_ins1 from u_key_enter within tabpage1
integer x = 59
integer y = 228
integer width = 4407
integer height = 1776
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_saf_01000_10"
boolean border = false
end type

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String sval
Real   nval
Integer i_rtn, pmon, emon

sval = Trim(this.GetText())
if not IsNumber(sval) then return 1
nval = Real(sval)

i_rtn = 0
if this.GetColumnName() = "fact01" then
	if nval < 0 or nval > 12 then i_rtn = 1
elseif this.GetColumnName() = "fact02" then
	if nval < 0 or nval >= 10 then i_rtn = 1
elseif this.GetColumnName() = "fact03" then
	if nval < 0 or nval >= 10 then i_rtn = 1
elseif this.GetColumnName() = "fact04" then
	if nval < 0 or nval > 5 then i_rtn = 1
	pmon = this.object.fact01[1] //평균판매량 개월수
	emon = Integer(sval)         //증감추세 개월수 
	if mod(pmon, emon) <> 0 then i_rtn = 1
elseif this.GetColumnName() = "fact05" then
	if nval < 0 or nval >= 10 then i_rtn = 1
elseif this.GetColumnName() = "fact06" then
	if nval < 0 or nval >= 10 then i_rtn = 1
elseif this.GetColumnName() = "fact10" or &
	    this.GetColumnName() = "fact11" or &
		 this.GetColumnName() = "fact12" or &
		 this.GetColumnName() = "fact13" or &
		 this.GetColumnName() = "fact14" or &
		 this.GetColumnName() = "fact15" or &
		 this.GetColumnName() = "fact16" or &
		 this.GetColumnName() = "fact17" or &
		 this.GetColumnName() = "fact18" then
	if nval < 0 or nval >= 10 then i_rtn = 1
end if

if i_rtn <> 0 then
	MessageBox("수치값 확인", "자료의 수치값을 정확히 입력하세요!")
end if

return i_rtn

end event

event getfocus;call super::getfocus;sle_msg.Text = ""
end event

type cb_11 from commandbutton within tabpage1
integer x = 3776
integer y = 56
integer width = 421
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장"
end type

event clicked;Real n1, n2, n3

tab1.tabpage1.dw_ins1.object.sabu[1] = gs_sabu

if tab1.tabpage1.dw_ins1.AcceptText() = -1 then
	MessageBox("자료입력 확인", "자료를 정확히 입력하세요!")
   return	
end if

n1 = tab1.tabpage1.dw_ins1.object.fact01[1] //평균판매량 개월수
n2 = tab1.tabpage1.dw_ins1.object.fact04[1] //증감추세 개월수
if Mod(n1, n2) <> 0 then
   MessageBox("개월수 확인", "평균판매량 개월수는 증감추세 개월수의 배수이어야 합니다!")
	return
end if

n1 = tab1.tabpage1.dw_ins1.object.fact02[1] //변동폭 MIN
n2 = tab1.tabpage1.dw_ins1.object.fact03[1] //변동폭 MAX
if n1 > n2 then
   MessageBox("변동폭 확인", "변동폭 MIN, MAX 수치값을 확인하세요!")
	return
end if

n1 = tab1.tabpage1.dw_ins1.object.fact10[1] //안전재고 적용치 MIN
n2 = tab1.tabpage1.dw_ins1.object.fact11[1] //안전재고 적용치 MID
n3 = tab1.tabpage1.dw_ins1.object.fact12[1] //안전재고 적용치 MAX
if (n1 > n2) or (n2 > n3) then
   MessageBox("안전재고 적용치 확인", "안전재고 적용치 MIN, MID, MAX 수치값을 확인하세요!")
	return
end if

if tab1.tabpage1.dw_ins1.update() <> 1 then
	ROLLBACK;
	sle_msg.Text = "저장작업 실패!"
	return
end if

COMMIT;
sle_msg.Text = "저장작업 완료! 자료가 저장되었습니다!"
return

end event

type cb_9 from commandbutton within tabpage1
integer x = 3214
integer y = 32
integer width = 576
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "안전재고계산현황"
end type

event clicked;String 	ls_window_id, spass
Window	lw_window

ls_window_id = 'w_saf_05000'
	
SELECT "SUB2_T"."PASSWORD"  
  INTO :sPass
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :ls_window_id ;

IF sPass ="" OR IsNull(sPass) THEN
ELSE
	OpenWithParm(W_PGM_PASS,spass)
	IF Message.StringParm = "CANCEL" THEN RETURN
END IF

OpenSheet(lw_window, ls_window_id, w_mdi_frame, 0, Layered!)
end event

type cb_10 from commandbutton within tabpage1
integer x = 4069
integer y = 68
integer width = 421
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료"
end type

event clicked;wf_close()
end event

type tabpage2 from userobject within tab1
integer x = 18
integer y = 96
integer width = 4498
integer height = 2012
long backcolor = 32106727
string text = "안전재고 개월수"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_2 dw_2
cb_save cb_save
dw_ins2 dw_ins2
cb_4 cb_4
cb_5 cb_5
cb_jo cb_jo
cb_7 cb_7
cb_12 cb_12
cb_13 cb_13
end type

on tabpage2.create
this.rr_1=create rr_1
this.dw_2=create dw_2
this.cb_save=create cb_save
this.dw_ins2=create dw_ins2
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_jo=create cb_jo
this.cb_7=create cb_7
this.cb_12=create cb_12
this.cb_13=create cb_13
this.Control[]={this.rr_1,&
this.dw_2,&
this.cb_save,&
this.dw_ins2,&
this.cb_4,&
this.cb_5,&
this.cb_jo,&
this.cb_7,&
this.cb_12,&
this.cb_13}
end on

on tabpage2.destroy
destroy(this.rr_1)
destroy(this.dw_2)
destroy(this.cb_save)
destroy(this.dw_ins2)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_jo)
destroy(this.cb_7)
destroy(this.cb_12)
destroy(this.cb_13)
end on

type rr_1 from roundrectangle within tabpage2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 268
integer width = 4398
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from u_key_enter within tabpage2
event ue_key pbm_dwnkey
integer x = 41
integer y = 36
integer width = 2469
integer height = 212
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_saf_01000_20"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemerror;call super::itemerror;return 1
end event

event getfocus;call super::getfocus;sle_msg.Text = ""
end event

event rbuttondown;string sname

if this.GetColumnName() = 'itcls1' then
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls1", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'itcls2' then
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
	this.SetItem(1,"itcls2", lstr_sitnct.s_sumgub)
end if	
end event

type cb_save from commandbutton within tabpage2
integer x = 3854
integer y = 80
integer width = 393
integer height = 120
integer taborder = 51
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장"
end type

event clicked;sle_msg.Text = ""
if tab1.tabpage2.dw_ins2.AcceptText() = -1 then
	MessageBox("자료입력 확인", "자료를 정확히 입력하세요!")
   return	
end if

if tab1.tabpage2.dw_ins2.update() <> 1 then
	ROLLBACK;
	sle_msg.Text = "저장작업 실패!"
	return
end if

COMMIT;
sle_msg.Text = "저장작업 완료! 자료가 저장되었습니다!"
ib_any_typing = False //입력필드 변경여부 No

return

end event

type dw_ins2 from u_key_enter within tabpage2
integer x = 69
integer y = 276
integer width = 4379
integer height = 1696
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_saf_01000_21"
boolean vscrollbar = true
boolean border = false
end type

event editchanged;call super::editchanged;ib_any_typing = True
end event

event itemerror;call super::itemerror;return 1
end event

event getfocus;call super::getfocus;sle_msg.Text = ""
end event

event constructor;Modify("ispec_t.text = '" + f_change_name('2') + "'" )
Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end event

type cb_4 from commandbutton within tabpage2
integer x = 1083
integer y = 2360
integer width = 247
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "none"
end type

type cb_5 from commandbutton within tabpage2
integer x = 2990
integer y = 60
integer width = 393
integer height = 120
integer taborder = 41
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄적용"
end type

event clicked;Long mon, i 

sle_msg.Text = ""
tab1.tabpage2.dw_2.AcceptText()
mon = tab1.tabpage2.dw_2.object.mon[1]
if IsNull(mon) then
   MessageBox("안전재고 개월수", "일괄적용할 안전재고 개월수를 입력하세요!")
	tab1.tabpage2.dw_2.SetColumn("mon")
	tab1.tabpage2.dw_2.SetFocus()
	return
end if	

if Messagebox("안전재고 개월수 일괄적용","안전재고 개월수를 '" + String(mon) + & 
              "'개월로 일괄적용 하시겠습나까?", Question!,YesNo!,1) <> 1 then
	sle_msg.text = "일괄적용 작업이 취소되었습니다!"
	return
end if

for i = 1 to tab1.tabpage2.dw_ins2.RowCount()
	tab1.tabpage2.dw_ins2.object.safmon[i] = mon	
next

tab1.tabpage2.cb_save.TriggerEvent(Clicked!)

return

end event

type cb_jo from commandbutton within tabpage2
integer x = 3397
integer y = 60
integer width = 393
integer height = 120
integer taborder = 71
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회"
end type

event clicked;String ittyp, itcls1, itcls2, spangbn
Long   mon, m1, m2

sle_msg.Text = ""
if tab1.tabpage2.dw_2.AcceptText() = -1 then 
	tab1.tabpage2.dw_2.SetFocus()
	return
end if	 

ittyp   = trim(tab1.tabpage2.dw_2.object.ittyp[1])
itcls1  = trim(tab1.tabpage2.dw_2.object.itcls1[1])
itcls2  = trim(tab1.tabpage2.dw_2.object.itcls2[1])
spangbn = trim(tab1.tabpage2.dw_2.object.pangbn[1])
mon     = tab1.tabpage2.dw_2.object.mon[1]

if (IsNull(ittyp) or ittyp = "")  then 
	f_message_chk(30, "[품목구분]")
	tab1.tabpage2.dw_2.SetColumn("ittyp")
	tab1.tabpage2.dw_2.SetFocus()
	return 1
end if

if (IsNull(itcls1) or itcls1 = "") then itcls1 = "." 
if (IsNull(itcls2) or itcls2 = "") then
	itcls2 = "zzzzzzz" 
else
	itcls2 = itcls2 + "zzzzzz" 
end if
	
if (IsNull(spangbn) or spangbn = "") then spangbn = "%" 

if mon > 0 and mon <= 9 then 
	m1 = mon
	m2 = mon
else
	m1 = 0
	m2 = 9
end if

tab1.tabpage2.dw_ins2.SetRedraw(False)
if tab1.tabpage2.dw_ins2.Retrieve(ittyp, itcls1, itcls2, m1, m2, spangbn) < 1 then 
	f_message_chk(50, "[안전재고 개월수]")
end if
tab1.tabpage2.dw_ins2.SetRedraw(True)

return
end event

type cb_7 from commandbutton within tabpage2
integer x = 3790
integer y = 48
integer width = 393
integer height = 120
integer taborder = 81
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소"
end type

event clicked;IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

sle_msg.Text = ""
tab1.tabpage2.dw_ins2.SetRedraw(False)
tab1.tabpage2.dw_ins2.Reset()
tab1.tabpage2.dw_ins2.SetRedraw(True)

tab1.tabpage2.dw_2.SetRedraw(False)
tab1.tabpage2.dw_2.Reset()
tab1.tabpage2.dw_2.InsertRow(0)
tab1.tabpage2.dw_2.SetRedraw(True)
tab1.tabpage2.dw_2.SetFocus()

sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type cb_12 from commandbutton within tabpage2
integer x = 2427
integer y = 72
integer width = 544
integer height = 108
integer taborder = 61
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "안전재고계산현황"
end type

event clicked;open(w_saf_05000)
end event

type cb_13 from commandbutton within tabpage2
integer x = 4114
integer y = 88
integer width = 393
integer height = 120
integer taborder = 61
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료"
end type

event clicked;wf_close()
end event

type tabpage3 from userobject within tab1
integer x = 18
integer y = 96
integer width = 4498
integer height = 2012
long backcolor = 32106727
string text = "안전재고 계산"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
st_2 st_2
dw_ins3 dw_ins3
cb_2 cb_2
end type

on tabpage3.create
this.st_2=create st_2
this.dw_ins3=create dw_ins3
this.cb_2=create cb_2
this.Control[]={this.st_2,&
this.dw_ins3,&
this.cb_2}
end on

on tabpage3.destroy
destroy(this.st_2)
destroy(this.dw_ins3)
destroy(this.cb_2)
end on

type st_2 from statictext within tabpage3
integer x = 1765
integer y = 256
integer width = 1070
integer height = 136
integer textsize = -20
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "안전재고 계산"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_ins3 from u_key_enter within tabpage3
integer x = 1522
integer y = 544
integer width = 1618
integer height = 884
integer taborder = 31
boolean bringtotop = true
string dataobject = "d_saf_01000_30"
boolean border = false
end type

event itemchanged;call super::itemchanged;String s_cod

s_cod = Trim(this.getText())

if this.GetColumnName() = "ym" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + "01") = -1 then
		f_message_chk(35, "[기준년월]")
		return 1
	end if	
end if

return
end event

event itemerror;call super::itemerror;return 1
end event

type cb_2 from commandbutton within tabpage3
integer x = 2766
integer y = 464
integer width = 334
integer height = 120
integer taborder = 41
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "생성"
end type

event clicked;String ym, gubun, gout
double i_rtn

sle_msg.Text = ""
if tab1.tabpage3.dw_ins3.AcceptText() = -1 then 
	tab1.tabpage3.dw_ins3.SetFocus()
	return
end if	 

ym = tab1.tabpage3.dw_ins3.object.ym[1]
gubun = tab1.tabpage3.dw_ins3.object.gubun[1]
if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[기준년월]")
	tab1.tabpage3.dw_ins3.SetColumn("ym")
	tab1.tabpage3.dw_ins3.SetFocus()
	return 1
end if

if Messagebox("주 의","이전에 생성된 기준년월의 안전재고 계획현황이 있으면 삭제후 재생성 합니다!~n~n" + &
                      "진행 하시겠습니까?",Question!,YesNo!,1) <> 1 then 
	sle_msg.text = "생성작업이 취소되었습니다!"						 
	return
else
	sle_msg.text = ""
end if

setpointer(hourglass!)
sle_msg.text = "안전재고 계산(1)......"
i_rtn = 0
sqlca.erp000000610(gs_sabu, ym, gubun, i_rtn);
If i_rtn = -1 then
	f_message_chk(41,'[안전재고 계산(ERP000000610)]')
	return
END If
sle_msg.text = "안전재고 계산(2)......"

gout = "N"
sqlca.erp000000620(gs_sabu, ym, gout);
If gout = "Y" then
	f_message_chk(41,'[안전재고 계산(ERP000000620)]')
	return
END If
sle_msg.text = "안전재고 계산 완료!"

return
end event

type tabpage4 from userobject within tab1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4498
integer height = 2012
long backcolor = 32106727
string text = "안전재고 조정"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_jojung1 dw_jojung1
cb_1 cb_1
cb_3 cb_3
cb_6 cb_6
cb_8 cb_8
dw_jojung dw_jojung
end type

on tabpage4.create
this.rr_2=create rr_2
this.dw_jojung1=create dw_jojung1
this.cb_1=create cb_1
this.cb_3=create cb_3
this.cb_6=create cb_6
this.cb_8=create cb_8
this.dw_jojung=create dw_jojung
this.Control[]={this.rr_2,&
this.dw_jojung1,&
this.cb_1,&
this.cb_3,&
this.cb_6,&
this.cb_8,&
this.dw_jojung}
end on

on tabpage4.destroy
destroy(this.rr_2)
destroy(this.dw_jojung1)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.cb_6)
destroy(this.cb_8)
destroy(this.dw_jojung)
end on

type rr_2 from roundrectangle within tabpage4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 276
integer width = 4462
integer height = 1704
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_jojung1 from datawindow within tabpage4
event us_enter pbm_dwnprocessenter
integer x = 32
integer y = 288
integer width = 4439
integer height = 1680
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_saf_05000_05"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event us_enter;Send(Handle(this),256,9,0)
Return 1
end event

event constructor;Modify("ispec_t.text = '" + f_change_name('2') + "'" )
Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end event

type cb_1 from commandbutton within tabpage4
integer x = 2912
integer y = 76
integer width = 325
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회"
end type

event clicked;string syymm, sittyp, sitcls, snext_yymm, spangbn

select max(safyymm) into :syymm from zsafcal;

snext_yymm = f_aftermonth(syymm, 1)

dw_jojung.setitem(1, "giyymm", syymm)

if dw_jojung.accepttext() = -1 then return

sittyp	= trim(dw_jojung.getitemstring(1, "ittyp"))
sitcls	= trim(dw_jojung.getitemstring(1, "itcls"))
spangbn	= trim(dw_jojung.getitemstring(1, "pangbn"))

if isnull( sitcls ) or trim( sitcls ) = '' then
	sitcls = '%'
else
	sitcls = sitcls + '%'
end if

dw_jojung1.retrieve(gs_sabu, syymm, sittyp, sitcls, snext_yymm, spangbn)
dw_jojung1.setfocus()
end event

type cb_3 from commandbutton within tabpage4
integer x = 4119
integer y = 76
integer width = 325
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료"
end type

event clicked;wf_close()
end event

type cb_6 from commandbutton within tabpage4
integer x = 3589
integer y = 76
integer width = 521
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "품목마스터 적용"
end type

event clicked;String syymm, sittyp, sitcls, sname, sname1
Long Lrow

if dw_jojung.accepttext() = -1 then return

SetPointer(HourGlass!)

syymm		= dw_jojung.getitemstring(1, "giyymm")
sittyp	= dw_jojung.getitemstring(1, "ittyp")
sitcls	= dw_jojung.getitemstring(1, "itcls")
sname1	= dw_jojung.getitemstring(1, "itnm")

if isnull( syymm ) or trim( syymm ) = '' then
	Messagebox("기준년월", "기준년월이 부정확합니다", stopsign!)
	return
end if

Setnull(sname)
Select fun_get_reffpf('05', :sittyp) into :sname from dual;

if sqlca.sqlcode <> 0 or isnull( sittyp ) or trim( sittyp ) = '' then
	Messagebox("품목구분", "품목구분이 부정확합니다", stopsign!)
	return
end if

if isnull( sitcls ) or trim( sitcls ) = '' then
	sitcls = '%'
	sname1 = '품목전체'
end if

if Messagebox("저장확인", 	"품목구분 -> " + sname 	+ '~n' + &
								  	"품목분류 -> " + sname1	+ '~n' + &
									" 에 대한 안전재고를 변경하시겠읍니까?", question!, yesno!) = 2 then
	return
end if

update	itemas a	
	set	( a.minsaf, a.midsaf, a.maxsaf )	=	
							(select nvl(b.safmin,0), nvl(b.safmid,0), nvl(b.safmax,0) 
								from zsafcal b, itemas c
							  where b.sabu  = :gs_sabu and safyymm = :syymm 	and a.itnbr = b.itnbr
							  	 and a.itnbr = c.itnbr	 and c.ittyp = :sittyp	and c.itcls like :sitcls)
 where   a.itnbr	in (select b.itnbr
								from zsafcal b, itemas c
							  where b.sabu  = :gs_sabu and safyymm = :syymm 	
							  	 and b.itnbr = c.itnbr	 and c.ittyp = :sittyp	and c.itcls like :sitcls);

Lrow = sqlca.sqlnrows

if sqlca.sqlcode = 0 then
	commit;
	Messagebox("저장완료", "총 -> " + string(Lrow) + " 을 저장하였읍니다", information!)
else
	rollback;	
	Messagebox("저장실패", "저장을 실패하였읍니다", stopsign!)
end if
end event

type cb_8 from commandbutton within tabpage4
integer x = 3250
integer y = 76
integer width = 325
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장"
end type

event clicked;Long lsqlcode

SetPointer(HourGlass!)

if dw_jojung1.update() = -1 then
	rollback;
	lsqlcode = dec(sqlca.sqlcode)
	f_message_chk(Lsqlcode, "자료저장")
	return
else
	commit;
end if
end event

type dw_jojung from datawindow within tabpage4
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 5
integer y = 48
integer width = 2853
integer height = 224
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_saf_05000_06"
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

event itemchanged;string	s_Itcls, s_Name, s_itt, snull
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
   cb_inq.TriggerEvent(Clicked!)
	return ireturn 
END IF
end event

event itemerror;return 1
end event

event rbuttondown;string sname

if this.GetColumnName() = 'itcls' then
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itnm", lstr_sitnct.s_titnm)
   cb_inq.TriggerEvent(Clicked!)
end if	
end event

