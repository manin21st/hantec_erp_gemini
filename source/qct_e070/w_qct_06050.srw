$PBExportHeader$w_qct_06050.srw
$PBExportComments$계측기 Test 결과등록
forward
global type w_qct_06050 from w_inherite
end type
type dw_1 from datawindow within w_qct_06050
end type
type rb_1 from radiobutton within w_qct_06050
end type
type rb_2 from radiobutton within w_qct_06050
end type
type gb_4 from groupbox within w_qct_06050
end type
type gb_3 from groupbox within w_qct_06050
end type
type gb_2 from groupbox within w_qct_06050
end type
type gb_1 from groupbox within w_qct_06050
end type
type dw_2 from u_d_popup_sort within w_qct_06050
end type
end forward

global type w_qct_06050 from w_inherite
integer width = 3662
integer height = 2396
string title = "계측기 Test 결과등록"
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
gb_4 gb_4
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_2 dw_2
end type
global w_qct_06050 w_qct_06050

forward prototypes
public function integer wf_required_chk ()
public subroutine wf_init ()
end prototypes

public function integer wf_required_chk ();String sfdate, stdate, sftime, sttime
long   lterm

sfdate = Trim(dw_insert.object.mchrsl_tesidat[1])
sftime = Trim(dw_insert.object.mchrsl_tesitim[1])
stdate = Trim(dw_insert.object.mchrsl_teeddat[1])
sttime = Trim(dw_insert.object.mchrsl_teedtim[1])

if Isnull(sfdate) or sfdate = "" then
  	f_message_chk(1400,'[TEST 시작일자]')
	dw_insert.SetColumn('mchrsl_tesidat')
	dw_insert.SetFocus()
	return -1
end if
if Isnull(sftime) or sftime = "" then
  	f_message_chk(1400,'[TEST 시작시간]')
	dw_insert.SetColumn('mchrsl_tesitim')
	dw_insert.SetFocus()
	return -1
end if
if Isnull(stdate) or stdate = "" then
  	f_message_chk(1400,'[TEST 완료일자]')
	dw_insert.SetColumn('mchrsl_teeddat')
	dw_insert.SetFocus()
	return -1
end if
if Isnull(sttime) or sttime = "" then
  	f_message_chk(1400,'[TEST 완료시간]')
	dw_insert.SetColumn('mchrsl_teedtim')
	dw_insert.SetFocus()
	return -1
end if

if sfdate > stdate then 
  	f_message_chk(200,'[TEST 시작일자]')
	dw_insert.SetColumn('mchrsl_tesidat')
	dw_insert.SetFocus()
	return -1
elseif sfdate + sFtime > stdate + sTtime then 
  	f_message_chk(200,'[TEST 시작시간]')
	dw_insert.SetColumn('mchrsl_tesitim')
	dw_insert.SetFocus()
	return -1
end if

lTerm = f_daytimeterm(sfdate, stdate, sftime, sttime)
if lTerm < 0 then
	MessageBox("확인", "시간이 올바르게 등록되지않았습니다!" )
	dw_insert.SetColumn('mchrsl_tesidat')
	dw_insert.setfocus()
	return -1
else
	dw_insert.setitem(1, 'mchrsl_watim', lTerm)
end if

if Isnull(Trim(dw_insert.object.mchrsl_testyn[1])) or &
   Trim(dw_insert.object.mchrsl_testyn[1]) = "" then
  	f_message_chk(1400,'[판정유무]')
	dw_insert.SetColumn('mchrsl_testyn')
	dw_insert.SetFocus()
	return -1
end if

return 1
end function

public subroutine wf_init ();dw_2.ReSet()

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.Setredraw(True)

cb_mod.Enabled = false
cb_del.Enabled = false

ib_any_typing = False

dw_1.SetFocus()
end subroutine

on w_qct_06050.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.gb_4
this.Control[iCurrent+5]=this.gb_3
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.dw_2
end on

on w_qct_06050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_2)
end on

event open;call super::open;dw_1.InsertRow(0)
dw_1.setitem(1, 'sdate', left(is_today, 6) + '01')
dw_1.setitem(1, 'edate', is_today)

dw_2.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

rb_1.checked = true 
rb_1.triggerevent(clicked!)



end event

type dw_insert from w_inherite`dw_insert within w_qct_06050
integer x = 27
integer y = 656
integer width = 3648
integer height = 1260
integer taborder = 40
string dataobject = "d_qct_06050_03"
end type

event dw_insert::itemchanged;String  s_cod

if this.getcolumnname() = "mchrsl_tesidat" then // 유효성 체크 
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[TEST 시작일자]")
		this.object.mchrsl_tesidat[1] = ""
		return 1
	end if
   this.setitem(1, "mchrsl_teeddat", s_cod ) 
elseif this.getcolumnname() = "mchrsl_teeddat" then
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[TEST 완료일자]")
		this.object.mchrsl_teeddat[1] = ""
		return 1
	end if
elseif  this.getcolumnname() = "mchrsl_tesitim" then 
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_timechk(s_cod) = -1 then
		f_message_chk(176, "[TEST 시작시간]")
		this.object.mchrsl_tesitim[1] = ""
		return 1
	end if
elseif  this.getcolumnname() = "mchrsl_teedtim"  then   
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_timechk(s_cod) = -1 then
		f_message_chk(176, "[TEST 완료시간]")
		this.object.mchrsl_teedtim[1] = ""
		return 1
	end if
End if

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type cb_exit from w_inherite`cb_exit within w_qct_06050
integer x = 3232
integer y = 1940
end type

type cb_mod from w_inherite`cb_mod within w_qct_06050
integer x = 2190
integer y = 1940
integer taborder = 50
boolean enabled = false
end type

event cb_mod::clicked;call super::clicked;string ls_testyn
integer Net

if dw_insert.Accepttext() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return

ls_testyn = dw_insert.getitemstring(1, "mchrsl_testyn")

IF dw_insert.Update() > 0 THEN	
	COMMIT;
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	return
END IF

if ls_testyn = 'N' then //불합격 
	Net = MessageBox("확인", " Test 판정이 불합격입니다. ~r~n~n 수리의뢰 등록 하시겠습니까?", Exclamation!, YesNo!, 1)
	IF Net = 1 THEN
		gs_gubun = "testno" // Process OK.
		gs_code  = dw_insert.getitemstring( 1 , "mchrsl_mchno")
		gs_codename = dw_insert.getitemstring( 1 , "mchrsl_sidat") 
		gi_page  = dw_insert.getitemnumber( 1 , "mchrsl_seq")
	end if
end if

cb_inq.triggerevent(clicked!)

if gs_gubun = 'testno' then 
	open( w_pdt_06043 ) 
END IF
	
end event

type cb_ins from w_inherite`cb_ins within w_qct_06050
boolean visible = false
integer x = 1285
integer y = 2500
integer taborder = 0
end type

type cb_del from w_inherite`cb_del within w_qct_06050
integer x = 2537
integer y = 1940
integer taborder = 60
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;String s_cod , snull

if dw_insert.Accepttext() = -1 then return

if f_msg_delete() = -1 then return

setnull(snull)

dw_insert.setitem(1, "mchrsl_tesidat", snull)
dw_insert.setitem(1, "mchrsl_tesitim", snull)
dw_insert.setitem(1, "mchrsl_teeddat", snull)
dw_insert.setitem(1, "mchrsl_teedtim", snull)
dw_insert.setitem(1, "mchrsl_testyn",  snull)
dw_insert.setitem(1, "mchrsl_watim",   0)

IF dw_insert.Update() > 0 THEN	
	COMMIT;
ELSE
	ROLLBACK;
	f_message_chk(32, "[삭제 실패]")
END IF

cb_inq.triggerevent(clicked!)

end event

type cb_inq from w_inherite`cb_inq within w_qct_06050
integer x = 82
integer y = 1940
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;String sdate, edate, smchno, emchno, buncd, buncd1

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return 
end if	

sdate = Trim(dw_1.object.sdate[1])
edate = Trim(dw_1.object.edate[1])
buncd  = trim(dw_1.object.buncd[1])
buncd1 = trim(dw_1.object.buncd1[1])

if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 
if IsNull(sdate) or sdate = "" then sdate = "10000101"
if IsNull(edate) or edate = "" then edate = "99991231"
//if IsNull(smchno) or smchno = "" then smchno = '.'
//if IsNull(emchno) or emchno = "" then emchno = "zzzzzz"
	

if dw_2.Retrieve(gs_sabu, sdate, edate, buncd, buncd1 ) < 1 then
	sle_msg.text = "등록된 자료가 없습니다! "
else	
	sle_msg.text = ""
end if	

dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)
ib_any_typing = False

end event

type cb_print from w_inherite`cb_print within w_qct_06050
boolean visible = false
integer x = 1691
integer y = 2468
integer taborder = 0
end type

type st_1 from w_inherite`st_1 within w_qct_06050
end type

type cb_can from w_inherite`cb_can within w_qct_06050
integer x = 2885
integer y = 1940
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""

wf_init()


end event

type cb_search from w_inherite`cb_search within w_qct_06050
boolean visible = false
integer x = 2231
integer y = 2484
integer taborder = 0
end type







type gb_button1 from w_inherite`gb_button1 within w_qct_06050
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_06050
end type

type dw_1 from datawindow within w_qct_06050
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 212
integer width = 869
integer height = 408
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_06050_01"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String  s_cod, s_nam1, s_nam2, ls_buncd
integer i_rtn

s_cod = Trim(this.GetText())

//if this.GetColumnName() = "smchno" then 
//	if IsNull(s_cod) or s_cod = "" then 
//		this.object.smchnam[1] = ""
//		return
//	end if	
//	
//	select mchnam into :s_nam1 from mchmst
//	 where sabu = :gs_sabu and mchno = :s_cod;
//	 
//	if sqlca.sqlcode <> 0 then 
//	   this.object.smchno[1] = ""
//	   this.object.smchnam[1] = ""
//	else
//	   this.object.smchno[1] = s_cod
//	   this.object.smchnam[1] = s_nam1
//   end if
//elseif this.GetColumnName() = "emchno" then 
//	if IsNull(s_cod) or s_cod = "" then 
//		this.object.emchnam[1] = ""
//		return 
//	end if	
//	
//	select mchnam into :s_nam1 from mchmst
//	 where sabu = :gs_sabu and mchno = :s_cod;
//	 
//	if sqlca.sqlcode <> 0 then 
//	   this.object.emchno[1] = ""
//	   this.object.emchnam[1] = ""
//	else
//	   this.object.emchno[1] = s_cod
//	   this.object.emchnam[1] = s_nam1
//   end if

//if this.GetColumnName() = "buncd" then    // 계측기 관리번호
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//   FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//      setitem(1 , "buncd", '')
//		return 2 
//	end if
//
//elseif this.GetColumnName() = "buncd1" then    // 계측기 관리번호
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//	FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//     	setitem(1 , "buncd1", '')
//		return 2 
//	end if

if this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if	
end if

end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "buncd" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd[1] = gs_code
	
elseif this.GetColumnName() = "buncd1" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd1[1] = gs_code
		
end if


//if this.GetColumnName() = "smchno" then
//	gs_gubun = 'ALL'
//	gs_code  = '계측기'
//	open(w_mchno_popup)
//	this.object.smchno[1] = gs_code
//	this.object.smchnam[1] = gs_codename
//elseif this.GetColumnName() = "emchno" then
//	gs_gubun = 'ALL'
//	gs_code  = '계측기'
//   open(w_mchno_popup)
//	this.object.emchno[1] = gs_code
//	this.object.emchnam[1] = gs_codename
//end if	

end event

event itemerror;return 1 
end event

type rb_1 from radiobutton within w_qct_06050
integer x = 101
integer y = 68
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "결과등록"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_2.dataobject = "d_qct_06050_02" 
dw_2.settransobject(sqlca)

wf_init()
end event

type rb_2 from radiobutton within w_qct_06050
integer x = 485
integer y = 68
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "결과수정"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_2.dataobject = "d_qct_06050_02_1" 
dw_2.settransobject(sqlca)

wf_init()


end event

type gb_4 from groupbox within w_qct_06050
integer x = 32
integer width = 887
integer height = 176
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_qct_06050
integer x = 2158
integer y = 1896
integer width = 1440
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_qct_06050
integer x = 41
integer y = 1896
integer width = 407
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_qct_06050
integer x = 32
integer y = 164
integer width = 887
integer height = 484
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_2 from u_d_popup_sort within w_qct_06050
integer x = 937
integer y = 24
integer width = 2651
integer height = 624
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_qct_06050_02"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;string ls_sidat, ls_mchno
integer li_seq

this.SelectRow(0,False)

if Row <= 0 then return
this.SelectRow(Row,TRUE)

ls_sidat = this.getitemstring(row, "mchrsl_sidat")
ls_mchno = this.getitemstring(row, "mchrsl_mchno")
li_seq   = this.getitemnumber(row, "mchrsl_seq")

if dw_insert.Retrieve(gs_sabu, ls_sidat, ls_mchno, li_seq ) < 1 then
   f_message_chk(50, "[Test 결과 등록]")
	dw_insert.SetRedraw(False)
	dw_insert.Reset()
	dw_insert.InsertRow(0)
	dw_insert.SetRedraw(True)	
else
	cb_mod.Enabled = True
	if rb_2.checked then 
	   cb_del.Enabled = true
	end if
	dw_insert.SetFocus()
end if	
end event

