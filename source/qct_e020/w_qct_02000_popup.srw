$PBExportHeader$w_qct_02000_popup.srw
$PBExportComments$** 제안목표등록(개인별)-일괄처리
forward
global type w_qct_02000_popup from window
end type
type dw_insert from datawindow within w_qct_02000_popup
end type
type dw_list from u_d_popup_sort within w_qct_02000_popup
end type
type dw_update from datawindow within w_qct_02000_popup
end type
type cbx_1 from checkbox within w_qct_02000_popup
end type
type cb_cancel from commandbutton within w_qct_02000_popup
end type
type cb_retrieve from commandbutton within w_qct_02000_popup
end type
type dw_ip from datawindow within w_qct_02000_popup
end type
type cb_update from commandbutton within w_qct_02000_popup
end type
type cb_exit from commandbutton within w_qct_02000_popup
end type
type gb_3 from groupbox within w_qct_02000_popup
end type
type gb_2 from groupbox within w_qct_02000_popup
end type
type gb_1 from groupbox within w_qct_02000_popup
end type
end forward

global type w_qct_02000_popup from window
integer x = 741
integer y = 188
integer width = 2875
integer height = 2136
boolean titlebar = true
string title = "사원별 재안목표 일괄 조정"
windowtype windowtype = response!
long backcolor = 79741120
dw_insert dw_insert
dw_list dw_list
dw_update dw_update
cbx_1 cbx_1
cb_cancel cb_cancel
cb_retrieve cb_retrieve
dw_ip dw_ip
cb_update cb_update
cb_exit cb_exit
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
end type
global w_qct_02000_popup w_qct_02000_popup

type variables
string   is_year,  is_dptno //조회부서
end variables

event open;f_window_center(this)

is_year = gs_code
if is_year = '' or isnull(is_year) then 
	is_year = string(long(left(f_today(), 4)) + 1) 
end if

dw_list.SetTransObject(SQLCA)
dw_update.SetTransObject(SQLCA)

dw_insert.InsertRow(0)
dw_ip.InsertRow(0)

dw_insert.setitem(1, 'mokyy', is_year)


end event

on w_qct_02000_popup.create
this.dw_insert=create dw_insert
this.dw_list=create dw_list
this.dw_update=create dw_update
this.cbx_1=create cbx_1
this.cb_cancel=create cb_cancel
this.cb_retrieve=create cb_retrieve
this.dw_ip=create dw_ip
this.cb_update=create cb_update
this.cb_exit=create cb_exit
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.dw_insert,&
this.dw_list,&
this.dw_update,&
this.cbx_1,&
this.cb_cancel,&
this.cb_retrieve,&
this.dw_ip,&
this.cb_update,&
this.cb_exit,&
this.gb_3,&
this.gb_2,&
this.gb_1}
end on

on w_qct_02000_popup.destroy
destroy(this.dw_insert)
destroy(this.dw_list)
destroy(this.dw_update)
destroy(this.cbx_1)
destroy(this.cb_cancel)
destroy(this.cb_retrieve)
destroy(this.dw_ip)
destroy(this.cb_update)
destroy(this.cb_exit)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
end on

type dw_insert from datawindow within w_qct_02000_popup
event ue_pressenter pbm_dwnprocessenter
integer x = 96
integer y = 108
integer width = 2683
integer height = 236
integer taborder = 10
string dataobject = "d_qct_02000_popup1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

type dw_list from u_d_popup_sort within w_qct_02000_popup
integer x = 901
integer y = 436
integer width = 1915
integer height = 1356
integer taborder = 40
string dataobject = "d_qct_02000_popup"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type dw_update from datawindow within w_qct_02000_popup
boolean visible = false
integer x = 41
integer y = 908
integer width = 837
integer height = 848
boolean titlebar = true
string dataobject = "d_qct_02000_update"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_qct_02000_popup
integer x = 539
integer y = 732
integer width = 338
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "일괄해제"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;long  k, lcount

lcount = dw_list.rowcount()

if this.text = '일괄선택' then 
	this.text = '일괄해제'
	
	FOR k = 1 TO lcount
		dw_list.setitem(k, 'opt', 'Y')
	NEXT
else
	this.text = '일괄선택'
	FOR k = 1 TO lcount
		dw_list.setitem(k, 'opt', 'N')
	NEXT
end if


end event

type cb_cancel from commandbutton within w_qct_02000_popup
integer x = 1870
integer y = 1864
integer width = 439
integer height = 92
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;dw_list.reset()
dw_update.reset()

dw_insert.setredraw(false)

dw_insert.reset()

dw_insert.insertrow(0)
dw_insert.setitem(1, 'mokyy', is_year)

dw_insert.setredraw(true)

cbx_1.text = '일괄해제'
cbx_1.checked = true
end event

type cb_retrieve from commandbutton within w_qct_02000_popup
integer x = 965
integer y = 1864
integer width = 439
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;if dw_ip.AcceptText() = -1 then return 

is_dptno  = dw_ip.GetItemString(1,'dptno')

if isnull(is_dptno) or is_dptno = "" then is_dptno = '%'

if dw_list.retrieve(is_dptno) < 1 then 
	f_message_chk(50,'')
	dw_ip.SetFocus()
end if

end event

type dw_ip from datawindow within w_qct_02000_popup
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 82
integer y = 484
integer width = 773
integer height = 172
integer taborder = 20
string dataobject = "d_qct_02000_popup2"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;String s_dptno, s_name, s_name2
int    ireturn

if this.GetColumnName() = "dptno" then
	s_dptno = this.gettext()
 
   ireturn = f_get_name2('부서', 'Y', s_dptno, s_name, s_name2)
	this.SetItem(Row, "dptno", s_dptno)
	this.SetItem(Row, "dptnm", s_name)
  	return ireturn 
END IF
end event

event itemerror;RETURN 1
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() = "dptno" THEN
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(this.getrow(), "dptno", gs_Code)
	this.SetItem(this.getrow(), "dptnm", gs_Codename)
END IF
end event

type cb_update from commandbutton within w_qct_02000_popup
integer x = 1417
integer y = 1864
integer width = 439
integer height = 92
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄조정(&E)"
end type

event clicked;string s_year, smsgtxt, sOpt, sempno 
long   lcount, k, i, lrow, lfind, lReturnRow, &
       lGen01, lGen02, lGen03, lGen04, lGen05, lGen06, &
       lGen07, lGen08, lGen09, lGen10, lGen11, lGen12, &
       lTem01, lTem02, lTem03, lTem04, lTem05, lTem06, &
       lTem07, lTem08, lTem09, lTem10, lTem11, lTem12
String sGen01 = 'Y', sGen02 = 'Y', sGen03 = 'Y', sGen04 = 'Y', sGen05 = 'Y', sGen06 = 'Y', &
       sGen07 = 'Y', sGen08 = 'Y', sGen09 = 'Y', sGen10 = 'Y', sGen11 = 'Y', sGen12 = 'Y', &
       sTem01 = 'Y', sTem02 = 'Y', sTem03 = 'Y', sTem04 = 'Y', sTem05 = 'Y', sTem06 = 'Y', &
       sTem07 = 'Y', sTem08 = 'Y', sTem09 = 'Y', sTem10 = 'Y', sTem11 = 'Y', sTem12 = 'Y'

if dw_ip.AcceptText() = -1 then return 
if dw_insert.AcceptText() = -1 then return 

s_year  = dw_insert.GetItemString(1, 'mokyy')  //1:분류코드, 2:품번

if IsNull(s_year) or s_year = '' then
	f_message_chk(1400, "[기준년도]")
	dw_insert.SetColumn("mokyy")
	dw_insert.SetFocus()
	return 
end if

lGen01 = dw_insert.GetItemNumber(1, 'gen01')
lGen02 = dw_insert.GetItemNumber(1, 'gen02')
lGen03 = dw_insert.GetItemNumber(1, 'gen03')
lGen04 = dw_insert.GetItemNumber(1, 'gen04')
lGen05 = dw_insert.GetItemNumber(1, 'gen05')
lGen06 = dw_insert.GetItemNumber(1, 'gen06')
lGen07 = dw_insert.GetItemNumber(1, 'gen07')
lGen08 = dw_insert.GetItemNumber(1, 'gen08')
lGen09 = dw_insert.GetItemNumber(1, 'gen09')
lGen10 = dw_insert.GetItemNumber(1, 'gen10')
lGen11 = dw_insert.GetItemNumber(1, 'gen11')
lGen12 = dw_insert.GetItemNumber(1, 'gen12')

lTem01 = dw_insert.GetItemNumber(1, 'Tem01')
lTem02 = dw_insert.GetItemNumber(1, 'Tem02')
lTem03 = dw_insert.GetItemNumber(1, 'Tem03')
lTem04 = dw_insert.GetItemNumber(1, 'Tem04')
lTem05 = dw_insert.GetItemNumber(1, 'Tem05')
lTem06 = dw_insert.GetItemNumber(1, 'Tem06')
lTem07 = dw_insert.GetItemNumber(1, 'Tem07')
lTem08 = dw_insert.GetItemNumber(1, 'Tem08')
lTem09 = dw_insert.GetItemNumber(1, 'Tem09')
lTem10 = dw_insert.GetItemNumber(1, 'Tem10')
lTem11 = dw_insert.GetItemNumber(1, 'Tem11')
lTem12 = dw_insert.GetItemNumber(1, 'Tem12')

if isnull(lGen01) and isnull(lGen02) and isnull(lGen03) and isnull(lGen04) and &
   isnull(lGen05) and isnull(lGen06) and isnull(lGen07) and isnull(lGen08) and &
	isnull(lGen09) and isnull(lGen10) and isnull(lGen11) and isnull(lGen12) and &
   isnull(ltem01) and isnull(ltem02) and isnull(ltem03) and isnull(ltem04) and &
   isnull(ltem05) and isnull(ltem06) and isnull(ltem07) and isnull(ltem08) and &
	isnull(ltem09) and isnull(ltem10) and isnull(ltem11) and isnull(ltem12) then 
	f_message_chk(1400, "[제안]")
	dw_insert.SetColumn("gen01")
	dw_insert.SetFocus()
	return 
end if

lcount = dw_list.rowcount()
if lcount < 1 then
	messagebox('확 인', '처리 할 자료가 없습니다. 자료를 먼저 조회하세요!')
	return 
end if

smsgtxt = s_year + '년 ' + '사원별 제안목표를 일괄 처리 하시겠습니까?'

if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   

SetPointer(HourGlass!)

if isnull(lGen01) then; lGen01 = 0; sGen01 = 'N'; end if;
if isnull(lGen02) then; lGen02 = 0; sGen02 = 'N'; end if;
if isnull(lGen03) then; lGen03 = 0; sGen03 = 'N'; end if;
if isnull(lGen04) then; lGen04 = 0; sGen04 = 'N'; end if;
if isnull(lGen05) then; lGen05 = 0; sGen05 = 'N'; end if;
if isnull(lGen06) then; lGen06 = 0; sGen06 = 'N'; end if;
if isnull(lGen07) then; lGen07 = 0; sGen07 = 'N'; end if;
if isnull(lGen08) then; lGen08 = 0; sGen08 = 'N'; end if;
if isnull(lGen09) then; lGen09 = 0; sGen09 = 'N'; end if;
if isnull(lGen10) then; lGen10 = 0; sGen10 = 'N'; end if;
if isnull(lGen11) then; lGen11 = 0; sGen11 = 'N'; end if;
if isnull(lGen12) then; lGen12 = 0; sGen12 = 'N'; end if;

if isnull(ltem01) then; ltem01 = 0; stem01 = 'N'; end if;
if isnull(ltem02) then; ltem02 = 0; stem02 = 'N'; end if;
if isnull(ltem03) then; ltem03 = 0; stem03 = 'N'; end if;
if isnull(ltem04) then; ltem04 = 0; stem04 = 'N'; end if;
if isnull(ltem05) then; ltem05 = 0; stem05 = 'N'; end if;
if isnull(ltem06) then; ltem06 = 0; stem06 = 'N'; end if;
if isnull(ltem07) then; ltem07 = 0; stem07 = 'N'; end if;
if isnull(ltem08) then; ltem08 = 0; stem08 = 'N'; end if;
if isnull(ltem09) then; ltem09 = 0; stem09 = 'N'; end if;
if isnull(ltem10) then; ltem10 = 0; stem10 = 'N'; end if;
if isnull(ltem11) then; ltem11 = 0; stem11 = 'N'; end if;
if isnull(ltem12) then; ltem12 = 0; stem12 = 'N'; end if;

lfind = dw_update.retrieve(s_year, is_dptno)

FOR k = 1 TO lcount
	sOpt = dw_list.getitemString(k, 'opt') 
	
	if sOpt = 'N' then continue 
	i ++ 

	sEmpno = dw_list.getitemString(k, 'empno') 
	
	IF lfind > 0 THEN 
		lReturnRow = dw_update.Find("empno = '"+sempno+"' ", 1, lfind)
		IF lReturnRow <= 0	THEN //신규생성
			lrow = dw_update.insertrow(0)
			
			dw_update.setitem(lrow, 'sabu',   gs_sabu)
			dw_update.setitem(lrow, 'mokyy',  s_year)
			dw_update.setitem(lrow, 'empno',  sEmpno)
			
			dw_update.setitem(lrow, 'gen01',  lGen01)
			dw_update.setitem(lrow, 'gen02',  lGen02)
			dw_update.setitem(lrow, 'gen03',  lGen03)
			dw_update.setitem(lrow, 'gen04',  lGen04)
			dw_update.setitem(lrow, 'gen05',  lGen05)
			dw_update.setitem(lrow, 'gen06',  lGen06)
			dw_update.setitem(lrow, 'gen07',  lGen07)
			dw_update.setitem(lrow, 'gen08',  lGen08)
			dw_update.setitem(lrow, 'gen09',  lGen09)
			dw_update.setitem(lrow, 'gen10',  lGen10)
			dw_update.setitem(lrow, 'gen11',  lGen11)
			dw_update.setitem(lrow, 'gen12',  lGen12)
			
			dw_update.setitem(lrow, 'tem01',  ltem01)
			dw_update.setitem(lrow, 'tem02',  ltem02)
			dw_update.setitem(lrow, 'tem03',  ltem03)
			dw_update.setitem(lrow, 'tem04',  ltem04)
			dw_update.setitem(lrow, 'tem05',  ltem05)
			dw_update.setitem(lrow, 'tem06',  ltem06)
			dw_update.setitem(lrow, 'tem07',  ltem07)
			dw_update.setitem(lrow, 'tem08',  ltem08)
			dw_update.setitem(lrow, 'tem09',  ltem09)
			dw_update.setitem(lrow, 'tem10',  ltem10)
			dw_update.setitem(lrow, 'tem11',  ltem11)
			dw_update.setitem(lrow, 'tem12',  ltem12)
			
		ELSE //수정처리
			IF sGen01 = 'Y' then; dw_update.setitem(lReturnRow, 'gen01',  lGen01); end if; 
			IF sGen02 = 'Y' then; dw_update.setitem(lReturnRow, 'gen02',  lGen02); end if; 
			IF sGen03 = 'Y' then; dw_update.setitem(lReturnRow, 'gen03',  lGen03); end if; 
			IF sGen04 = 'Y' then; dw_update.setitem(lReturnRow, 'gen04',  lGen04); end if; 
			IF sGen05 = 'Y' then; dw_update.setitem(lReturnRow, 'gen05',  lGen05); end if; 
			IF sGen06 = 'Y' then; dw_update.setitem(lReturnRow, 'gen06',  lGen06); end if; 
			IF sGen07 = 'Y' then; dw_update.setitem(lReturnRow, 'gen07',  lGen07); end if; 
			IF sGen08 = 'Y' then; dw_update.setitem(lReturnRow, 'gen08',  lGen08); end if; 
			IF sGen09 = 'Y' then; dw_update.setitem(lReturnRow, 'gen09',  lGen09); end if; 
			IF sGen10 = 'Y' then; dw_update.setitem(lReturnRow, 'gen10',  lGen10); end if; 
			IF sGen11 = 'Y' then; dw_update.setitem(lReturnRow, 'gen11',  lGen11); end if; 
			IF sGen12 = 'Y' then; dw_update.setitem(lReturnRow, 'gen12',  lGen12); end if; 
			
			IF stem01 = 'Y' then; dw_update.setitem(lReturnRow, 'tem01',  ltem01); end if; 
			IF stem02 = 'Y' then; dw_update.setitem(lReturnRow, 'tem02',  ltem02); end if; 
			IF stem03 = 'Y' then; dw_update.setitem(lReturnRow, 'tem03',  ltem03); end if; 
			IF stem04 = 'Y' then; dw_update.setitem(lReturnRow, 'tem04',  ltem04); end if; 
			IF stem05 = 'Y' then; dw_update.setitem(lReturnRow, 'tem05',  ltem05); end if; 
			IF stem06 = 'Y' then; dw_update.setitem(lReturnRow, 'tem06',  ltem06); end if; 
			IF stem07 = 'Y' then; dw_update.setitem(lReturnRow, 'tem07',  ltem07); end if; 
			IF stem08 = 'Y' then; dw_update.setitem(lReturnRow, 'tem08',  ltem08); end if; 
			IF stem09 = 'Y' then; dw_update.setitem(lReturnRow, 'tem09',  ltem09); end if; 
			IF stem10 = 'Y' then; dw_update.setitem(lReturnRow, 'tem10',  ltem10); end if; 
			IF stem11 = 'Y' then; dw_update.setitem(lReturnRow, 'tem11',  ltem11); end if; 
			IF stem12 = 'Y' then; dw_update.setitem(lReturnRow, 'tem12',  ltem12); end if; 
		END IF	
	ELSE //신규생성
		lrow = dw_update.insertrow(0)
		
		dw_update.setitem(lrow, 'sabu',   gs_sabu)
		dw_update.setitem(lrow, 'mokyy',  s_year)
		dw_update.setitem(lrow, 'empno',  sEmpno)
		
      dw_update.setitem(lrow, 'gen01',  lGen01)
      dw_update.setitem(lrow, 'gen02',  lGen02)
      dw_update.setitem(lrow, 'gen03',  lGen03)
      dw_update.setitem(lrow, 'gen04',  lGen04)
      dw_update.setitem(lrow, 'gen05',  lGen05)
      dw_update.setitem(lrow, 'gen06',  lGen06)
      dw_update.setitem(lrow, 'gen07',  lGen07)
      dw_update.setitem(lrow, 'gen08',  lGen08)
      dw_update.setitem(lrow, 'gen09',  lGen09)
      dw_update.setitem(lrow, 'gen10',  lGen10)
      dw_update.setitem(lrow, 'gen11',  lGen11)
      dw_update.setitem(lrow, 'gen12',  lGen12)
		
      dw_update.setitem(lrow, 'tem01',  ltem01)
      dw_update.setitem(lrow, 'tem02',  ltem02)
      dw_update.setitem(lrow, 'tem03',  ltem03)
      dw_update.setitem(lrow, 'tem04',  ltem04)
      dw_update.setitem(lrow, 'tem05',  ltem05)
      dw_update.setitem(lrow, 'tem06',  ltem06)
      dw_update.setitem(lrow, 'tem07',  ltem07)
      dw_update.setitem(lrow, 'tem08',  ltem08)
      dw_update.setitem(lrow, 'tem09',  ltem09)
      dw_update.setitem(lrow, 'tem10',  ltem10)
      dw_update.setitem(lrow, 'tem11',  ltem11)
      dw_update.setitem(lrow, 'tem12',  ltem12)
	END IF
NEXT

if i < 1 then
	messagebox('확 인', '처리 할 자료가 없습니다. 처리 할 자료를 선택하세요!')
	return 
end if

if dw_update.update() = 1 then
	commit ;
   messagebox("확 인", "완료처리 되었습니다")
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	


end event

type cb_exit from commandbutton within w_qct_02000_popup
integer x = 2322
integer y = 1864
integer width = 439
integer height = 92
integer taborder = 70
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;close(parent)
end event

type gb_3 from groupbox within w_qct_02000_popup
integer x = 41
integer y = 24
integer width = 2775
integer height = 360
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "기준입력(입력한 수량만 적용됩니다. 0 을 입력하여도 적용됩니다.)"
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_qct_02000_popup
integer x = 41
integer y = 416
integer width = 837
integer height = 268
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "조회조건"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_qct_02000_popup
integer x = 901
integer y = 1800
integer width = 1915
integer height = 196
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
borderstyle borderstyle = styleraised!
end type

