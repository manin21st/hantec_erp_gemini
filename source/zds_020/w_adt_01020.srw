$PBExportHeader$w_adt_01020.srw
$PBExportComments$** 운송비 집계 (ADT)
forward
global type w_adt_01020 from w_inherite
end type
type dw_cond from datawindow within w_adt_01020
end type
type pb_2 from u_pb_cal within w_adt_01020
end type
type pb_3 from u_pb_cal within w_adt_01020
end type
type rb_1 from radiobutton within w_adt_01020
end type
type rb_2 from radiobutton within w_adt_01020
end type
type cbx_1 from checkbox within w_adt_01020
end type
type rr_3 from roundrectangle within w_adt_01020
end type
type rr_1 from roundrectangle within w_adt_01020
end type
end forward

global type w_adt_01020 from w_inherite
string title = "운송비 집계"
dw_cond dw_cond
pb_2 pb_2
pb_3 pb_3
rb_1 rb_1
rb_2 rb_2
cbx_1 cbx_1
rr_3 rr_3
rr_1 rr_1
end type
global w_adt_01020 w_adt_01020

type variables
string isgbn
end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();dw_insert.Reset()
dw_cond.Reset()

dw_cond.insertrow(0)
f_mod_saupj(dw_cond, 'saupj')

dw_cond.SetItem(1, 'fdate', left(f_today(),6) + '01')
dw_cond.SetItem(1, 'tdate', f_today())
dw_cond.Setcolumn('deptcode')
dw_cond.SetFocus()

end subroutine

on w_adt_01020.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.pb_2=create pb_2
this.pb_3=create pb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_1=create cbx_1
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.rr_3
this.Control[iCurrent+8]=this.rr_1
end on

on w_adt_01020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_1)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event open;call super::open;postevent("ue_open")
end event

event ue_open;call super::ue_open;dw_cond.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_cond.InsertRow(0)

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_adt_01020
integer x = 37
integer y = 320
integer width = 4585
integer height = 1924
integer taborder = 150
string dataobject = "d_adt_01020_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

type p_delrow from w_inherite`p_delrow within w_adt_01020
boolean visible = false
integer x = 2889
integer y = 1312
end type

type p_addrow from w_inherite`p_addrow within w_adt_01020
boolean visible = false
integer x = 2715
integer y = 1312
end type

type p_search from w_inherite`p_search within w_adt_01020
boolean visible = false
integer x = 2327
integer y = 1320
integer taborder = 120
end type

type p_ins from w_inherite`p_ins within w_adt_01020
boolean visible = false
integer x = 3538
integer y = 36
end type

type p_exit from w_inherite`p_exit within w_adt_01020
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_adt_01020
integer taborder = 80
end type

event p_can::clicked;call super::clicked;rb_1.checked = true
rb_2.checked = false
wf_init()
end event

type p_print from w_inherite`p_print within w_adt_01020
boolean visible = false
integer x = 2501
integer y = 1320
integer taborder = 140
end type

type p_inq from w_inherite`p_inq within w_adt_01020
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string sfdate, stdate, sdept

if dw_cond.AcceptText() <> 1 then return

sfdate = dw_cond.Getitemstring(1, 'fdate')
stdate = dw_cond.Getitemstring(1, 'tdate')
sdept  = dw_cond.Getitemstring(1, 'deptcode')

if sfdate = '' or isNull(sfdate) then sfdate = '11111111'
if stdate = '' or isNull(stdate) then stdate = '99999999'
if sdept  = '' or isNull(sdept) then
	f_message_chk(30,'[집계부서]')
	dw_cond.SetColumn("deptcode")
	dw_cond.SetFocus()
	RETURN -1
END IF	

if dw_insert.Retrieve(gs_sabu, sdept, sfdate, stdate) < 1 then
	MessageBox('조회', '해당 조건으로 조회한 운송내역이 없습니다.', Exclamation!)
	dw_cond.SetColumn('fdate')
	dw_cond.SetFocus()	
	return 2
end if
end event

type p_del from w_inherite`p_del within w_adt_01020
boolean visible = false
integer x = 3022
integer y = 1036
end type

type p_mod from w_inherite`p_mod within w_adt_01020
integer x = 4096
end type

event p_mod::clicked;call super::clicked;string ls_chk, ls_today, ls_depot, ls_trnsno, ls_maxno
long   i, ll_cnt, ll_maxno
double ld_amt, ld_vat

if dw_cond.accepttext() = -1 then return

/* 현재일자(집계일자) */
select to_char(sysdate,'YYYYMMDD')
 into :ls_today
 from dual;

/* 집계부서 */ 
ls_depot = dw_cond.getitemstring(1,'deptcode')

/* 집계자료 조회여부 */
if dw_insert.rowCount() < 1 then
	MessageBox('처리자료 오류', '집계할 자료가 없습니다.', Exclamation!)
	return
end if

/* 집계자료 선택여부 */
ll_cnt = 0
ld_amt = 0
ld_vat = 0
for i = 1 to dw_insert.RowCount()
	ls_chk = dw_insert.GetitemString(i, 'chk')
	if ls_chk = 'Y' Then
		ll_cnt++
	   ld_amt = ld_amt + dw_insert.getitemnumber(i, 'trnsamt')
		ld_vat = ld_vat + truncate((ld_amt / 10),2)
	end IF	
next

if ll_cnt = 0 then
	MessageBox('알림', '집계할 자료를 선택하세요')
   return
end if

/* 운송집계 번호 채번 */
ll_maxno = sqlca.fun_junpyo(gs_sabu, ls_today, 'M3') 
commit;
ls_maxno = ls_today + string(ll_maxno, '0000')	

/* 집계 자료 생성 */
ll_cnt = 0
select count(*)
  into :ll_cnt
  from trns_magam
 where magamno = :ls_maxno
   and rownum = 1;

if ll_cnt = 0 Then
	insert into trns_magam
	       ( magamno, depot_no, magam_dat, maamt, mavat)
			values
			 ( :ls_maxno, :ls_depot, :ls_today, :ld_amt, :ld_vat);
	if sqlca.sqlcode <> 0 then
		MessageBox('저장실패 Insert', '집계자료 생성 실패!~r' + &
											  '전산실에 문의 하세요.', Stopsign!)
		rollback;
 	   return
	end if		 
else
	 update trns_magam
	    set magam_dat = :ls_today,
		     maamt     = :ld_amt,
		     mavat     = :ld_vat
 	  where magamno   = :ls_maxno;
	if sqlca.sqlcode <> 0 then
		MessageBox('저장실패 Update', '집계자료 생성 실패!~r' + &
											  '전산실에 문의 하세요.', Stopsign!)
		rollback;
 	   return
	end if	
end if

/*운송비 내역 테이블 마감번호 업데이트*/
for i = 1 to dw_insert.RowCount()
	ls_chk = dw_insert.GetitemString(i, 'chk')
	if ls_chk = 'Y' Then
		ls_trnsno = dw_insert.getitemstring(i, 'trnsno')
		
		update trnsmst
		   set magamno = :ls_maxno
		 where trnsno  = :ls_trnsno;
		
		if sqlca.sqlcode <> 0 then
			MessageBox('저장실패 trnsmst', '집계자료 생성 실패!~r' + &
												  '전산실에 문의 하세요.', Stopsign!)
			rollback;
			return
		end if			
	end IF	
next

MessageBox('알림', '집계자료 생성 완료')
commit;
p_inq.Triggerevent(Clicked!)
					
end event

type cb_exit from w_inherite`cb_exit within w_adt_01020
end type

type cb_mod from w_inherite`cb_mod within w_adt_01020
end type

type cb_ins from w_inherite`cb_ins within w_adt_01020
end type

type cb_del from w_inherite`cb_del within w_adt_01020
end type

type cb_inq from w_inherite`cb_inq within w_adt_01020
end type

type cb_print from w_inherite`cb_print within w_adt_01020
end type

type st_1 from w_inherite`st_1 within w_adt_01020
end type

type cb_can from w_inherite`cb_can within w_adt_01020
end type

type cb_search from w_inherite`cb_search within w_adt_01020
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_01020
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_01020
end type

type dw_cond from datawindow within w_adt_01020
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 23
integer y = 32
integer width = 3131
integer height = 164
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_adt_01020_01"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;send(handle(this), 256,9,0)
return 1
end event

event itemerror;return 1
end event

event itemchanged;string sNull, sjpno, sdeptcode, sdeptname

setNull(sNull)


Choose Case GetColumnName()
	Case "deptcode"
		sdeptcode = Trim(GetText())
		
		select cvnas into :sdeptname
		  from vndmst
		 where cvgu = '4'
		   and cvcod = :sdeptcode;
		
		if sqlca.sqlcode = 0 then
			setitem(1, 'deptname', sdeptname)
		else
			setitem(1, 'deptcode', snull)
			setitem(1, 'deptname', snull)
		end if		
End Choose
end event

event rbuttondown;string sNull

setNull(gs_code)
setNull(gs_codename)
setNull(gs_gubun)
setNull(sNull)


Choose Case GetColumnName()
	Case "deptcode"
		open(w_vndmst_4_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return		
		SetItem(1, "deptcode", gs_Code)
		SetItem(1, "deptname", gs_Codename)
		
End Choose
end event

type pb_2 from u_pb_cal within w_adt_01020
integer x = 2574
integer y = 60
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('fdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'fdate', gs_code)

end event

type pb_3 from u_pb_cal within w_adt_01020
integer x = 3022
integer y = 60
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('tdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'tdate', gs_code)

end event

type rb_1 from radiobutton within w_adt_01020
boolean visible = false
integer x = 3191
integer y = 56
integer width = 261
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
string text = "집 계"
boolean checked = true
end type

event clicked;dw_insert.dataobject = 'd_adt_01020_02'
dw_insert.SetTransObject(sqlca)
end event

type rb_2 from radiobutton within w_adt_01020
boolean visible = false
integer x = 3191
integer y = 120
integer width = 261
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
string text = "삭 제"
end type

event clicked;dw_insert.dataobject = 'd_adt_01020_03'
dw_insert.SetTransObject(sqlca)
end event

type cbx_1 from checkbox within w_adt_01020
integer x = 4233
integer y = 204
integer width = 375
integer height = 76
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;if dw_insert.RowCount() < 1 then return

long i

For i = 1 to dw_insert.RowCount()
	IF checked then
		dw_insert.SetItem(i, 'chk', 'Y')
	ELSE
		dw_insert.SetItem(i, 'chk', 'N')
	END IF
NEXT

end event

type rr_3 from roundrectangle within w_adt_01020
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3159
integer y = 36
integer width = 315
integer height = 156
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_adt_01020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 14
integer y = 300
integer width = 4617
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

