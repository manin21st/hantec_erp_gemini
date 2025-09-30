$PBExportHeader$w_qct_05550.srw
$PBExportComments$계측기 수리결과 등록
forward
global type w_qct_05550 from w_inherite
end type
type gb_3 from groupbox within w_qct_05550
end type
type gb_4 from groupbox within w_qct_05550
end type
type gb_2 from groupbox within w_qct_05550
end type
type dw_1 from datawindow within w_qct_05550
end type
type gb_1 from groupbox within w_qct_05550
end type
type rb_1 from radiobutton within w_qct_05550
end type
type rb_2 from radiobutton within w_qct_05550
end type
type rb_3 from radiobutton within w_qct_05550
end type
type st_2 from statictext within w_qct_05550
end type
type st_3 from statictext within w_qct_05550
end type
type st_4 from statictext within w_qct_05550
end type
type cb_1 from commandbutton within w_qct_05550
end type
end forward

global type w_qct_05550 from w_inherite
integer width = 3657
integer height = 2400
string title = "계측기 수리결과 등록"
gb_3 gb_3
gb_4 gb_4
gb_2 gb_2
dw_1 dw_1
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_2 st_2
st_3 st_3
st_4 st_4
cb_1 cb_1
end type
global w_qct_05550 w_qct_05550

type variables

end variables

forward prototypes
public function integer wf_required_chk ()
public function integer wf_retrieve ()
public function integer wf_init ()
end prototypes

public function integer wf_required_chk ();string scode, sFdate, sTdate, sFtime, sTtime

if Isnull(Trim(dw_1.object.sidat[1])) or Trim(dw_1.object.sidat[1]) = "" then
  	f_message_chk(1400,'[실시 일자]')
	dw_1.SetColumn('sidat')
	dw_1.SetFocus()
	return -1
end if	

if Isnull(Trim(dw_1.object.mchno[1])) or Trim(dw_1.object.mchno[1]) = "" then
  	f_message_chk(1400,'[관리 번호]')
	dw_1.SetColumn('mchno')
	dw_1.SetFocus()
	return -1
end if	

if Isnull(Trim(dw_insert.object.mchrsl_chkman[1])) or &
   Trim(dw_insert.object.mchrsl_chkman[1]) = "" then
  	f_message_chk(1400,'[수리담당자]')
	dw_insert.SetColumn('mchrsl_chkman')
	dw_insert.SetFocus()
	return -1
end if	

if Isnull(Trim(dw_insert.object.mchrsl_measure[1])) or &
   Trim(dw_insert.object.mchrsl_measure[1]) = "" then
  	f_message_chk(1400,'[조치여부]')
	dw_insert.SetColumn('mchrsl_measure')
	dw_insert.SetFocus()
	return -1
end if	

scode = dw_insert.object.mchrsl_iegbn[1]
if IsNull(scode) or scode = "" then
	f_message_chk(1400, "[사내/외 구분]")
	dw_insert.SetColumn("mchrsl_iegbn")
	dw_insert.SetFocus()
   Return -1
elseif scode = '2' then  //사외인 경우 
	scode = trim(dw_insert.object.mchrsl_cvcod[1])
	if IsNull(scode) or scode = "" then
		f_message_chk(1400, "[거래처]")
		dw_insert.SetColumn("mchrsl_cvcod")
		dw_insert.SetFocus()
		Return -1
	end if
end if

sFdate = dw_insert.object.mchrsl_susidat[1]
if Isnull(sFdate) or Trim(sFdate) = "" then
  	f_message_chk(1400,'[수리시작일자]')
	dw_insert.SetColumn('mchrsl_susidat')
	dw_insert.SetFocus()
	return -1
end if	

sFtime = dw_insert.object.mchrsl_susitim[1]
if Isnull(sFtime) or Trim(sFtime) = "" then
  	f_message_chk(1400,'[수리시작시간]')
	dw_insert.SetColumn('mchrsl_susitim')
	dw_insert.SetFocus()
	return -1
end if	

sTdate = dw_insert.object.mchrsl_sueddat[1]
if Isnull(sTdate) or Trim(sTdate) = "" then
  	f_message_chk(1400,'[수리완료일자]')
	dw_insert.SetColumn('mchrsl_sueddat')
	dw_insert.SetFocus()
	return -1
end if	

sTtime = dw_insert.object.mchrsl_suedtim[1]
if Isnull(sTtime) or Trim(sTtime) = "" then
  	f_message_chk(1400,'[수리완료시간]')
	dw_insert.SetColumn('mchrsl_suedtim')
	dw_insert.SetFocus()
	return -1
end if	

if sfdate > stdate then 
  	f_message_chk(200,'[수리시작일자]')
	dw_insert.SetColumn('mchrsl_susidat')
	dw_insert.SetFocus()
	return -1
elseif sfdate + sFtime > stdate + sTtime then 
  	f_message_chk(200,'[수리시작시간]')
	dw_insert.SetColumn('mchrsl_susitim')
	dw_insert.SetFocus()
	return -1
end if

if rb_3.checked then 
	if Isnull(dw_insert.object.mchrsl_jutim[1]) or &
	   dw_insert.object.mchrsl_jutim[1] <= 0 then
		f_message_chk(1400,'[고장시간]')
		dw_insert.SetColumn('mchrsl_jutim')
		dw_insert.SetFocus()
		return -1
	end if	
end if	

if IsNull(dw_insert.object.mchrsl_gocod[1]) or dw_insert.object.mchrsl_gocod[1] = "" then //고장 내역 코드 
	f_message_chk(1400, "[고장 내역 코드]")
	dw_insert.setcolumn("mchrsl_gocod")
	dw_insert.setfocus()
	return -1 
end if

return 1 


end function

public function integer wf_retrieve ();string ls_rslcod , ls_sidat , ls_mchno 
int   li_seq

if dw_1.Accepttext() = -1 then return -1 

ls_sidat = dw_1.Getitemstring( 1, "sidat" )
ls_mchno = dw_1.Getitemstring( 1, "mchno" )
li_seq   = dw_1.Getitemnumber( 1, "seq"  )

if Isnull(ls_sidat) or ls_sidat = "" then
	f_message_chk (1400 , "[수리의뢰일]" ) 
	dw_1.setcolumn("sidat")
	dw_1.setfocus()
	return -1
elseif IsNull(ls_mchno) or ls_mchno = "" then
	f_message_chk (1400 , "[관리번호]" ) 
	dw_1.setcolumn("mchno")
	dw_1.setfocus()
	return -1
elseif IsNull(li_seq) or li_seq = 0 then

	if rb_1.checked = true or rb_2.checked = true  then
		f_message_chk (1400, "[의뢰번호]" ) 
		dw_1.setcolumn("seq")
		dw_1.setfocus()
		return -1
    end if 

end if

if dw_insert.retrieve(gs_sabu, ls_sidat, ls_mchno, li_seq) <= 0 then  
	f_message_chk(50, "")
   wf_init()
	return -1 
end if

// 조회후  dw_1 에 protect 걸어줌 
dw_1.Modify('sidat.protect = 1')
dw_1.Modify('sidat.background.color = 79741120')
dw_1.Modify('mchno.protect = 1')
dw_1.Modify('mchno.background.color = 79741120')
dw_1.Modify('buncd.protect = 1')
dw_1.Modify('buncd.background.color = 79741120')
dw_1.Modify('seq.protect = 1' )
dw_1.Modify('seq.background.color = 79741120')

return 1

end function

public function integer wf_init ();dw_insert.Setredraw(false)
dw_insert.reset()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

dw_1.setRedraw(false)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.setfocus()

if rb_1.checked = True then  //  결과등록 (의뢰) 
   dw_1.Modify('sidat.protect = 0')
	dw_1.Modify('sidat.background.color = 12639424') //  민트 
	dw_1.Modify('mchno.protect = 0')
	dw_1.Modify('mchno.background.color = 65535')
	dw_1.Modify('buncd.protect = 0')
	dw_1.Modify('buncd.background.color = 65535')
	dw_1.Modify('seq.protect = 0' )
	dw_1.Modify('seq.background.color = 65535' ) 
	dw_1.setitem(1, 'sidat', is_today)
	dw_1.setcolumn('sidat')
	
	cb_inq.enabled = true  
	cb_del.enabled = false 
	cb_1.enabled   = false 
	cb_mod.enabled = false 

elseif rb_2.checked = true then  // 결과 수정 
	dw_1.Modify('sidat.protect = 0')
	dw_1.Modify('sidat.background.color = 12639424') // 민트 
	dw_1.Modify('mchno.protect = 0')
	dw_1.Modify('mchno.background.color = 65535')
	dw_1.Modify('buncd.protect = 0')
	dw_1.Modify('buncd.background.color = 65535')
	dw_1.Modify('seq.protect = 0')
	dw_1.Modify('seq.background.color = 65535' ) 
	dw_1.setitem(1, 'sidat', is_today)
	dw_1.setcolumn('sidat')
	
   cb_inq.enabled = true
	cb_del.enabled = false 
	cb_1.enabled   = false 
	cb_mod.enabled = false 
elseif rb_3.checked = true then // 결과 등록(임의)  
	dw_1.Modify('sidat.protect = 0')
	dw_1.Modify('sidat.background.color = 12639424') // 민트 
	dw_1.Modify('mchno.protect = 0')
	dw_1.Modify('mchno.background.color = 65535')
	dw_1.Modify('buncd.protect = 0')
	dw_1.Modify('buncd.background.color = 65535')
	dw_1.Modify('seq.protect = 1' )
	dw_1.Modify('seq.background.color =  79741120' )  // 회색 
	dw_1.setitem(1, 'sidat', is_today)
	dw_1.setcolumn('sidat')

	cb_inq.enabled = false
	cb_del.enabled = false 
	cb_1.enabled   = false 
	cb_mod.enabled = true
end if

dw_1.Setredraw(True)

ib_any_typing = false

return 1
	
end function

on w_qct_05550.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_2=create gb_2
this.dw_1=create dw_1
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_3
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.cb_1
end on

on w_qct_05550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_1)
end on

event open;call super::open;dw_insert.settransobject(sqlca)

wf_init()




end event

type dw_insert from w_inherite`dw_insert within w_qct_05550
integer x = 119
integer y = 304
integer width = 3397
integer height = 1584
integer taborder = 20
string dataobject = "d_qct_05550_01"
end type

event dw_insert::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "mchrsl_chkman" then
	open(w_sawon_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "mchrsl_chkman", gs_code)
	this.SetItem(1, "p1_master_bname", gs_codename)
elseif this.getcolumnname() = "mchrsl_cvcod" then  // 수리거래처 코드
	gs_gubun = '1'
	open(w_vndmst_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "mchrsl_cvcod", gs_code)
	this.SetItem(1, "vndmst_cvnas", gs_codename)
end if

end event

event dw_insert::itemchanged;String  s_cod, s_nam1, s_nam2, sNull
Integer ireturn
long    ll_ret

setnull(sNull)

if this.getcolumnname() = "mchrsl_susidat" then // 유효성 체크 
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[수리시작 일자]")
		this.object.mchrsl_susidat[1] = ""
		return 1
	end if
   this.setitem(1, "mchrsl_sueddat", s_cod ) 
elseif this.getcolumnname() = "mchrsl_sueddat" then
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[수리완료 일자]")
		this.object.mchrsl_sueddat[1] = ""
		return 1
	end if
elseif  this.getcolumnname() = "mchrsl_susitim" then 
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_timechk(s_cod) = -1 then
		f_message_chk(176, "[수리시작 시간]")
		this.object.mchrsl_susitim[1] = ""
		return 1
	end if
elseif  this.getcolumnname() = "mchrsl_suedtim"  then   
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_timechk(s_cod) = -1 then
		f_message_chk(176, "[수리완료 시간]")
		this.object.mchrsl_suedtim[1] = ""
		return 1
	end if
ELSEIF this.GetColumnName() = 'mchrsl_chkman' THEN
   s_cod = this.gettext()
	ireturn = f_get_name2('사번', 'Y', s_cod, s_nam1, s_nam2)
	this.setitem(1, "mchrsl_chkman", s_cod)
	this.setitem(1, "p1_master_bname", s_nam1)
	return ireturn 			
ELSEIF this.GetColumnName() = 'mchrsl_cvcod' then
   s_cod = this.gettext()
   ireturn = f_get_name2('V1', 'Y', s_cod, s_nam1, s_nam2)
   this.setitem(1, "mchrsl_cvcod", s_cod)
   this.setitem(1, "vndmst_cvnas", s_nam1)
   return ireturn
ELSEIF this.GetColumnName() = 'mchrsl_iegbn' then
   s_cod = this.gettext()
	if s_cod = '1' then //사내인 경우 
		this.setitem(1, "mchrsl_cvcod", sNull)
		this.setitem(1, "vndmst_cvnas", sNull)
		this.setitem(1, "mchrsl_damnm", sNull)
	end if
End if

end event

event dw_insert::itemerror;call super::itemerror;return 1


end event

event dw_insert::ue_pressenter;call super::ue_pressenter;//if this.getcolumnname() = "mchrsl_gowon" or this.getcolumnname() = "mchrsl_gorsl" or &
//   this.getcolumnname() = "mchrsl_godae" then
//   return 1
//else
//   Send(Handle(this),256,9,0)
//   Return 1
//end if
end event

event dw_insert::losefocus;call super::losefocus;this.accepttext()
end event

type cb_exit from w_inherite`cb_exit within w_qct_05550
integer x = 3177
integer y = 1936
end type

type cb_mod from w_inherite`cb_mod within w_qct_05550
integer x = 2135
integer y = 1936
integer taborder = 50
boolean enabled = false
end type

event cb_mod::clicked;call super::clicked;String ls_sidat, ls_mchno, ls_susidat, ls_susitim, ls_sueddat, ls_suedtim
int    ll_seq
long   lTerm

if dw_1.AcceptText() = -1 then return
if dw_insert.AcceptText() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크

if f_msg_update() = -1 then return

ls_susidat = dw_insert.getitemstring( 1, "mchrsl_susidat")  //수리시작일자 
ls_susitim = dw_insert.getitemstring( 1, "mchrsl_susitim")  // 수리시작시간
ls_sueddat = dw_insert.getitemstring( 1, "mchrsl_sueddat")  // 수리완료일자 
ls_suedtim = dw_insert.getitemstring( 1, "mchrsl_suedtim")   // 수리완료시간 

lTerm = f_daytimeterm(ls_susidat, ls_sueddat, ls_susitim, ls_suedtim )
if lTerm < 0 then
	MessageBox("확인", "시간이 올바르게 등록되지않았습니다!" )
	dw_insert.setcolumn("mchrsl_susidat")
	dw_insert.setfocus()
	return
else
	dw_insert.setitem(1, 'mchrsl_sutim', lTerm)
end if

if rb_3.checked then  // 결과등록   
	ls_sidat = dw_1.getitemstring(1, "sidat")
	ls_mchno = dw_1.getitemstring(1, "mchno")
				
   // 자동 채번 
	select Max(seq)  // 의뢰 번호 자동채번 
	  into :ll_seq
	  from mchrsl 
	 where sabu  = :gs_sabu
	   and sidat = :ls_sidat 
		and gubun = '4'
		and mchno = :ls_mchno ;

	if ll_seq = 0 or IsNULL(ll_seq) then
		ll_seq = 950
	else
		ll_seq ++
	end if

	dw_insert.object.mchrsl_sabu[1]  = gs_sabu
	dw_insert.object.mchrsl_sidat[1] = ls_sidat   
	dw_insert.object.mchrsl_mchno[1] = ls_mchno
	dw_insert.object.mchrsl_gubun[1] = '4'
	dw_insert.object.mchrsl_rslcod[1] = '3'
	dw_insert.setitem(1, "mchrsl_seq", ll_seq)
	dw_insert.setitem(1, "mchrsl_ins_gub", '2')
			
elseif rb_1.checked then  // 결과등록(의뢰) 
	dw_insert.object.mchrsl_rslcod[1] = '3'
end if

IF dw_insert.Update() > 0 THEN		
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
	return 
END IF

cb_del.enabled = True
cb_1.enabled   = True
rb_2.checked = true

ib_any_typing = False //입력필드 변경여부 No

end event

type cb_ins from w_inherite`cb_ins within w_qct_05550
boolean visible = false
integer x = 2011
integer y = 2372
integer width = 361
integer taborder = 0
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_qct_05550
integer x = 2482
integer y = 1936
integer taborder = 60
boolean enabled = false
end type

event clicked;string snull, sIns_gub, sSidat, sMchno
int    iseq

setnull(snull)

if dw_1.Accepttext() = -1 then return
if dw_insert.Accepttext() = -1 then return

if rb_2.checked = false then return 

sSidat = trim(dw_insert.object.mchrsl_sidat[1])
smchno = trim(dw_insert.object.mchrsl_mchno[1])
iseq   = dw_insert.object.mchrsl_seq[1]

if IsNull(ssidat) or ssidat = "" then
	f_message_chk(30, "[의뢰일자]")
	dw_insert.SetColumn("sidat")
	dw_insert.SetFocus()
   return
end if
if IsNull(smchno) or smchno = "" then
	f_message_chk(30, "[관리번호]")
	dw_insert.SetColumn("mchno")
	dw_insert.SetFocus()
   return
end if
if IsNull(iseq) or iseq = 0 then
	f_message_chk(30, "[의뢰번호]")
	dw_insert.SetColumn("seq")
	dw_insert.SetFocus()
   return
end if

IF f_msg_delete() = -1 THEN	RETURN

sIns_gub = dw_insert.getitemstring(1,"mchrsl_ins_gub")

DELETE FROM "MCHCHK_MTR"  
 WHERE ( "MCHCHK_MTR"."SABU"  = :gs_sabu ) AND  
		 ( "MCHCHK_MTR"."SIDAT" = :sSidat ) AND  
		 ( "MCHCHK_MTR"."MCHNO" = :sMchno ) AND  
		 ( "MCHCHK_MTR"."SEQNO" = :iseq ) AND  
		 ( "MCHCHK_MTR"."GUBUN" = '4' )   ;
		 
IF SQLCA.SQLCODE = 0	THEN	

	if sIns_gub = '1' then // 결과수정 	
		dw_insert.object.mchrsl_rslcod[1] = 'W'	
		dw_insert.object.mchrsl_measure[1] = snull
		dw_insert.object.mchrsl_chkman[1] = snull
		dw_insert.object.mchrsl_cvcod[1] = snull
		dw_insert.object.mchrsl_damnm[1] = snull
		dw_insert.object.mchrsl_iegbn[1] = '1'
		dw_insert.object.mchrsl_susidat[1] = snull
		dw_insert.object.mchrsl_susitim[1] = snull
		dw_insert.object.mchrsl_sueddat[1] = snull
		dw_insert.object.mchrsl_suedtim[1] = snull
		dw_insert.object.mchrsl_jutim[1] = 0
		dw_insert.object.mchrsl_sutim[1] = 0
		dw_insert.object.mchrsl_watim[1] = 0
		dw_insert.object.mchrsl_suamt[1] = 0
		dw_insert.object.mchrsl_gowon[1] = snull
		dw_insert.object.mchrsl_gorsl[1] = snull
		dw_insert.object.mchrsl_godae[1] = snull
		dw_insert.object.mchrsl_tesidat[1] = snull
		dw_insert.object.mchrsl_tesitim[1] = snull
		dw_insert.object.mchrsl_teeddat[1] = snull
		dw_insert.object.mchrsl_teedtim[1] = snull
		
		IF dw_insert.Update() > 0 THEN		
			COMMIT;
		ELSE
			ROLLBACK;
			f_message_chk(32, "[저장실패]")
			sle_msg.Text = "저장작업 실패!"
		END IF
		wf_init()
	elseif sIns_gub = '2' then // 결과수정 	
		dw_insert.setredraw(false)
		dw_insert.deleterow(0)  
		IF dw_insert.Update() > 0 THEN		
			COMMIT;
		ELSE
			ROLLBACK;
			f_message_chk(32, "[저장실패]")
		END IF
		wf_init()
		dw_insert.setredraw(true)
	end if
ELSE
	Rollback;
	Messagebox('삭제실패', '사용자재 삭제를 실패하였습니다.')
	Return 
END IF

end event

type cb_inq from w_inherite`cb_inq within w_qct_05550
integer x = 96
integer y = 1936
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;wf_retrieve() 

if rb_1.checked then 
   cb_mod.enabled = true
elseif rb_2.checked then 	
   cb_mod.enabled = true
   cb_del.enabled = true
   cb_1.enabled = true
end if
end event

type cb_print from w_inherite`cb_print within w_qct_05550
boolean visible = false
integer x = 2034
integer y = 2828
integer taborder = 0
end type

type st_1 from w_inherite`st_1 within w_qct_05550
end type

type cb_can from w_inherite`cb_can within w_qct_05550
integer x = 2830
integer y = 1936
end type

event cb_can::clicked;call super::clicked;wf_init()
end event

type cb_search from w_inherite`cb_search within w_qct_05550
boolean visible = false
integer x = 2971
integer y = 2828
integer taborder = 0
end type







type gb_button1 from w_inherite`gb_button1 within w_qct_05550
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_05550
end type

type gb_3 from groupbox within w_qct_05550
integer x = 2830
integer width = 667
integer height = 296
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

type gb_4 from groupbox within w_qct_05550
integer x = 123
integer width = 2688
integer height = 296
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

type gb_2 from groupbox within w_qct_05550
integer x = 2094
integer y = 1892
integer width = 1454
integer height = 176
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

type dw_1 from datawindow within w_qct_05550
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 174
integer y = 60
integer width = 2546
integer height = 184
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_05550_02"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string s_cod, ls_mchnam, ls_sidat, ls_mchno, snull, ls_buncd
int    inull, li_seq

sle_msg.text = ""

setnull(snull)
setnull(inull)
 
if this.getcolumnname() = "sidat"  then  // 수리의뢰 일자 
	s_cod = Trim(this.gettext()) 
   
	if s_cod = '' or isnull(s_cod) then return 
	if f_datechk(s_cod) = -1 then 
		f_message_chk(35, "[수리의뢰일]" )
		this.object.sidat[1] = "" 
		return 1
	end if
elseif  this.getcolumnname() = "mchno" then // 관리번호 
	s_cod = Trim(this.gettext())
		
	if IsNull(s_cod) or s_cod = ""  then
		this.object.mchnam[1] = ""
		this.object.buncd[1] = ""
		this.object.seq[1] = inull
		return 
	end if
		
	select mchnam , buncd
	  into :ls_mchnam, :ls_buncd
	  from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod ;
		
	if sqlca.sqlcode <> 0 then
		messageBox("확인", "등록된 관리번호가 아닙니다. " )
		this.setitem(1, "mchno",  snull)
		this.setitem(1, "mchnam", snull)
		this.setitem(1, "buncd",  snull)
		this.setitem(1, "seq",    inull)
		return 1
	end if
	
	this.setitem(1, "mchnam", ls_mchnam) 
   this.setitem(1, "buncd", ls_buncd) 
	
	
	
elseif this.GetColumnName() = "buncd" then    // 계측기 관리번호
	
	s_cod = Trim(this.Gettext())
	
	if IsNull(s_cod) or s_cod = "" then
		this.object.mchno[1] = ""
		this.object.mchnam[1] = ""
		this.object.seq[1] = inull
		return 
	end if
		
	SELECT mchno,    mchnam   
	  INTO :ls_mchno, :ls_mchnam
    FROM mchmst
	WHERE sabu = :gs_sabu and KEGBN = 'Y'
	  AND BUNCD = :s_cod ; 
	
	if sqlca.sqlcode <> 0  then
		f_message_chk(33, '[계측기관리번호]')
      this.setitem(1,"mchno", snull )
		this.setitem(1,"mchnam", snull)
		this.setitem(1,"buncd",  snull)
		this.setitem(1,"seq",    inull)
		return  1
	end if
	
	this.setitem(1,"mchno", ls_mchno )
	this.setitem(1,"mchnam" , ls_mchnam  )

	
elseif  this.getcolumnname() = "seq" then   // 순번 
	li_seq   = integer(this.gettext())
	if li_seq <= 0 or isnull(li_seq) then return 
	 
	ls_sidat = trim(this.getitemstring(1, "sidat"))
	ls_mchno = trim(this.getitemstring(1, "mchno"))
	 
	if ls_sidat = '' or isnull(ls_sidat) then 
 	   messagebox('확 인', '수리의뢰일자를 먼저 입력하세요!')
		this.setitem(1, 'seq', inull)
		this.SetColumn('sidat')
		return 1
	end if
	if ls_mchno = '' or isnull(ls_mchno) then 
 	   messagebox('확 인', '관리번호를 먼저 입력하세요!')
		this.setitem(1, 'seq', inull)
		this.SetColumn('mchno')
		return 1
	end if
	
   	select  buncd
	     into  :ls_buncd
	     from   mchmst
	    where   sabu = :gs_sabu and mchno = :ls_mchno ;
		
		this.setitem(1, "buncd", ls_buncd)
	 
	if rb_1.checked then  // 결과등록(의뢰) 
		select rslcod
		  into :s_cod
		  from mchrsl
		 where sabu   = :gs_sabu
		   and sidat  = :ls_sidat 
			and gubun  = '4'   
			and mchno  = :ls_mchno 
			and seq    = :li_seq ;
			
		if sqlca.sqlcode <> 0 then 
			MessageBox("확인", "등록된 의뢰번호가 아닙니다. 자료를 확인하세요!")
			this.setitem(1, "seq", inull ) 
			return 1
		else
			if s_cod <> 'W' then 
				MessageBox("확인", "수리 처리된 의뢰번호입니다. 결과수정에서 자료를 선택하세요")
				this.setitem(1, "seq", inull ) 
				return 1
			end if
		end if
				
		cb_inq.triggerevent(clicked!)
	elseif rb_2.checked then // 결과수정 
		select rslcod
		  into :s_cod
		  from mchrsl
		 where sabu   = :gs_sabu
		   and sidat  = :ls_sidat 
			and gubun  = '4'   
			and mchno  = :ls_mchno 
			and seq    = :li_seq ;
			
		if sqlca.sqlcode <> 0 then 
			MessageBox("확인", "등록된 의뢰번호가 아닙니다. 자료를 확인하세요!")
			this.setitem(1, "seq", inull ) 
			return 1
		else
			if s_cod = 'W' then 
				MessageBox("확인", "수리 의뢰된 의뢰번호입니다. 결과등록에서 자료를 선택하세요")
				this.setitem(1, "seq", inull ) 
				return 1
			end if
		end if
		cb_inq.triggerevent(clicked!)
	end if
end if 	


end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "mchno" THEN	
	gs_gubun = 'ALL'
	gs_code = '계측기'
	open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchnam", gs_codename)
	this.triggerevent(itemchanged!)
	
elseif this.GetColumnName() = "buncd" then
	
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd[1] = gs_code
	this.triggerevent(itemchanged!)	

elseif  this.getcolumnname() = 'seq' then
	if rb_1.checked then //  결과등록  , 의뢰 
		gs_code  = this.getitemstring( 1, "mchno" )
		gs_gubun  = 'W'
		gs_codename = '계측기'		
		
		open ( w_pdt_06043_pop_up)
		if IsNull(gs_code) or gs_code= "" then return
		
		this.setitem(1, 'mchno', gs_code)
		this.setitem(1, 'mchnam', gs_codename)
		this.setitem(1, "sidat" , gs_gubun )
		this.setitem(1, "seq", gi_page ) 
		
//		cb_inq.triggerevent(clicked!)
      this.triggerevent(itemchanged!)
	
  elseif  rb_2.checked then  //  결과수정 
		gs_code  = this.getitemstring( 1, "mchno" )
		gs_gubun  = '3'
	   gs_codename = '계측기'
	
		open(w_pdt_06043_pop_up)
		If IsNull(gs_code)  or gs_code="" Then Return
		
		this.setitem(1, 'mchno', gs_code)
		this.setitem(1, 'mchnam', gs_codename)
		this.setitem(1, "sidat" , gs_gubun )
		this.setitem(1, "seq", gi_page )
//		cb_inq.triggerevent(clicked!)
      this.triggerevent(itemchanged!)
	end if
end if
end event

event itemerror;return 1

end event

type gb_1 from groupbox within w_qct_05550
integer x = 55
integer y = 1892
integer width = 837
integer height = 176
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

type rb_1 from radiobutton within w_qct_05550
integer x = 2903
integer y = 52
integer width = 553
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "결과등록(의뢰)"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_init()
sle_msg.text = " 의뢰건에 대한 수리결과 등록모드"
end event

type rb_2 from radiobutton within w_qct_05550
integer x = 2903
integer y = 204
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "결과수정"
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_init()
sle_msg.text = "수리 결과 수정 모드"


end event

type rb_3 from radiobutton within w_qct_05550
integer x = 2903
integer y = 128
integer width = 521
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "결과등록(임의)"
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_init()
sle_msg.text = "의뢰가 없는 수리 결과 등록 모드"

end event

type st_2 from statictext within w_qct_05550
integer x = 969
integer y = 1904
integer width = 1070
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
boolean enabled = false
string text = "고장시간 = 정지시간     - TEST완료시간"
boolean focusrectangle = false
end type

type st_3 from statictext within w_qct_05550
integer x = 969
integer y = 1964
integer width = 1070
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
boolean enabled = false
string text = "수리시간 = 수리시작시간 - 수리완료시간"
boolean focusrectangle = false
end type

type st_4 from statictext within w_qct_05550
integer x = 969
integer y = 2024
integer width = 1070
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
boolean enabled = false
string text = "대기시간 = TEST시작시간 - TEST완료시간"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_qct_05550
integer x = 443
integer y = 1936
integer width = 411
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "사용자재등록"
end type

event clicked;if dw_1.AcceptText() = -1 then return 

gs_codename2 = dw_insert.object.mchrsl_sidat[1]
gs_gubun     = '4' //:설비
gs_code      = dw_insert.object.mchrsl_mchno[1]
gs_codename  = dw_insert.object.mchmst_mchnam[1]
gi_page      = dw_insert.object.mchrsl_seq[1] 

if IsNull(gs_codename2) or gs_codename2 = '' then
   MessageBox("자료 확인", "의뢰일자를 확인하세요!")
	return
end if
if IsNull(gs_code) or gs_code = '' then
   MessageBox("자료 확인", "관리번호를 확인하세요!")
	return
end if

if IsNull(gi_page) or gi_page <= 0 then
   MessageBox("자료 확인", "의뢰번호를 확인하세요!")
	return
end if

Open(w_pdt_06060)

end event

