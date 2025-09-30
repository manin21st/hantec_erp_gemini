$PBExportHeader$w_kgld91.srw
$PBExportComments$일별 마감 처리
forward
global type w_kgld91 from w_inherite
end type
type dw_ip from u_key_enter within w_kgld91
end type
type rr_1 from roundrectangle within w_kgld91
end type
type dw_rtv from datawindow within w_kgld91
end type
type cbx_bchk from checkbox within w_kgld91
end type
type cbx_buchk from checkbox within w_kgld91
end type
type st_2 from statictext within w_kgld91
end type
type cbx_achk from checkbox within w_kgld91
end type
type cbx_auchk from checkbox within w_kgld91
end type
end forward

global type w_kgld91 from w_inherite
string title = "일별 마감 처리"
dw_ip dw_ip
rr_1 rr_1
dw_rtv dw_rtv
cbx_bchk cbx_bchk
cbx_buchk cbx_buchk
st_2 st_2
cbx_achk cbx_achk
cbx_auchk cbx_auchk
end type
global w_kgld91 w_kgld91

type variables

String sUpmuGbn = 'A',LsAutoSungGbn
end variables

on w_kgld91.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
this.cbx_bchk=create cbx_bchk
this.cbx_buchk=create cbx_buchk
this.st_2=create st_2
this.cbx_achk=create cbx_achk
this.cbx_auchk=create cbx_auchk
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_rtv
this.Control[iCurrent+4]=this.cbx_bchk
this.Control[iCurrent+5]=this.cbx_buchk
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cbx_achk
this.Control[iCurrent+8]=this.cbx_auchk
end on

on w_kgld91.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.dw_rtv)
destroy(this.cbx_bchk)
destroy(this.cbx_buchk)
destroy(this.st_2)
destroy(this.cbx_achk)
destroy(this.cbx_auchk)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)

dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",   Gs_Saupj)
dw_ip.SetItem(dw_ip.Getrow(),"basedate",Left(f_today(),6))

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.Modify("saupj.protect = 1")
ELSE
	dw_ip.Modify("saupj.protect = 0")
END IF

dw_ip.SetColumn("basedate")
dw_ip.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_kgld91
boolean visible = false
integer x = 1550
integer y = 2544
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgld91
boolean visible = false
integer x = 3881
integer y = 2700
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kgld91
boolean visible = false
integer x = 3707
integer y = 2700
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kgld91
integer x = 4096
integer y = 8
integer taborder = 0
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::clicked;call super::clicked;Integer i
String sSaupj,sBaseYm,sLastDay

w_mdi_frame.sle_msg.text = ''

dw_ip.AcceptText()

sSaupj  = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sBaseYm = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"basedate"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.Setcolumn("saupj")
	dw_ip.SetFocus()
	Return
END IF
	
IF sBaseYm = "" OR IsNull(sBaseYm) THEN
	F_MessageChk(1,'[처리년월]')
	dw_ip.Setcolumn("basedate")
	dw_ip.SetFocus()
	Return
END IF
	
IF dw_rtv.Retrieve(sSaupj,sBaseYm) <= 0 THEN
	
	Select substr(to_char(last_day(:sBaseYm||'01'),'YYYYMMDD'), 7, 2)
	  Into :sLastDay
	  From dual;
	
	For i = 1 To Integer(sLastDay)
		
		dw_rtv.insertrow(0)
		
		dw_rtv.setitem(i, "saupj", sSaupj)
		dw_rtv.setitem(i, "maym", sBaseYm)
		dw_rtv.setitem(i, "madd", String(i, "00"))
		dw_rtv.setitem(i, "mbflag", "Y")
		dw_rtv.setitem(i, "maflag", "Y")
		
	Next

END IF

cbx_bchk.checked = False
cbx_buchk.checked = False
cbx_achk.checked = False
cbx_auchk.checked = False

w_mdi_frame.sle_msg.text = '정상적으로 조회되었습니다'
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kgld91
boolean visible = false
integer x = 3534
integer y = 2700
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kgld91
integer y = 8
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kgld91
boolean visible = false
integer x = 4229
integer y = 2700
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kgld91
boolean visible = false
integer x = 3698
integer y = 2528
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kgld91
integer x = 3922
integer y = 8
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaupj,sBaseYm

w_mdi_frame.sle_msg.text = ''

dw_ip.AcceptText()

sSaupj  = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sBaseYm = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"basedate"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.Setcolumn("saupj")
	dw_ip.SetFocus()
	Return
END IF
	
IF sBaseYm = "" OR IsNull(sBaseYm) THEN
	F_MessageChk(1,'[처리년월]')
	dw_ip.Setcolumn("basedate")
	dw_ip.SetFocus()
	Return
END IF
	
IF dw_rtv.Retrieve(sSaupj,sBaseYm) <= 0 THEN
	F_MessageChk(14,'')
	Return
END IF

cbx_bchk.checked = False
cbx_buchk.checked = False
cbx_achk.checked = False
cbx_auchk.checked = False

w_mdi_frame.sle_msg.text = '정상적으로 조회되었습니다'
end event

type p_del from w_inherite`p_del within w_kgld91
boolean visible = false
integer x = 4055
integer y = 2700
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kgld91
integer x = 4270
integer y = 8
string pointer = "C:\erpman\cur\create.cur"
end type

event p_mod::clicked;call super::clicked;If dw_rtv.rowcount() <= 0 Then Return

IF F_DbConFirm('저장') = 2 THEN Return

dw_rtv.accepttext()

w_mdi_frame.sle_msg.text =""

If dw_rtv.Update() < 0 Then
	Rollback;
	Messagebox("확인", "저장시 오류가 발생했습니다")
	Return
End if

Commit;

cbx_bchk.checked = False
cbx_buchk.checked = False
cbx_achk.checked = False
cbx_auchk.checked = False

w_mdi_frame.sle_msg.text ="정상적으로 저장되었습니다"
end event

type cb_exit from w_inherite`cb_exit within w_kgld91
boolean visible = false
integer x = 2743
integer y = 2768
end type

type cb_mod from w_inherite`cb_mod within w_kgld91
boolean visible = false
integer x = 2386
integer y = 2768
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kgld91
boolean visible = false
integer x = 1006
integer y = 2580
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kgld91
boolean visible = false
integer x = 2085
integer y = 2580
end type

type cb_inq from w_inherite`cb_inq within w_kgld91
boolean visible = false
integer x = 2025
integer y = 2768
end type

type cb_print from w_inherite`cb_print within w_kgld91
boolean visible = false
integer x = 2437
integer y = 2580
end type

type st_1 from w_inherite`st_1 within w_kgld91
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kgld91
boolean visible = false
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kgld91
boolean visible = false
integer x = 3122
integer y = 2580
integer width = 334
string text = "변경(&E)"
end type

event cb_search::clicked;call super::clicked;//OPEN(W_KIFA05A)
end event

type dw_datetime from w_inherite`dw_datetime within w_kgld91
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kgld91
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kgld91
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kgld91
boolean visible = false
integer x = 1993
integer y = 2532
end type

type gb_button2 from w_inherite`gb_button2 within w_kgld91
boolean visible = false
integer x = 1984
integer y = 2712
integer width = 1134
end type

type dw_ip from u_key_enter within w_kgld91
event ue_key pbm_dwnkey
integer x = 64
integer y = 8
integer width = 1650
integer height = 152
integer taborder = 10
string dataobject = "dw_kgld911"
boolean border = false
end type

event ue_key;IF key = keyF1! or key = keytab! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  sYearMonth,sSaupj,snull,ssql
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()
IF this.GetColumnName() ="saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '9' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[사업장]")
		dw_ip.SetItem(1,"saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() = "basedate" THEN
	sYearMonth = Trim(this.GetText())
	IF sYearMonth = "" OR IsNull(sYearMonth) THEN RETURN
	
	IF F_DateChk(sYearMonth+'01') = -1 THEN
		F_MessageChk(21,'[처리년월]')
		this.SetItem(iCurRow,"basedate",snull)
		Return 1
	END IF
END IF
end event

event rbuttondown;this.accepttext()
IF this.GetColumnName() = "acc1_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
//	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"accname",lstr_account.acc2_nm)
END IF
end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_kgld91
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 216
integer width = 4539
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kgld91
integer x = 82
integer y = 228
integer width = 4507
integer height = 2068
integer taborder = 30
string dataobject = "dw_kgld912"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type cbx_bchk from checkbox within w_kgld91
integer x = 1833
integer y = 52
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "작성 일괄마감"
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer i

If dw_rtv.rowcount() <= 0 Then Return

For i = 1 To dw_rtv.rowcount()
	
	dw_rtv.setitem(i, "mbflag", "Y")
	
Next

cbx_buchk.checked = False
end event

type cbx_buchk from checkbox within w_kgld91
integer x = 1833
integer y = 116
integer width = 549
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "작성 일괄마감취소"
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer i

If dw_rtv.rowcount() <= 0 Then Return

For i = 1 To dw_rtv.rowcount()
	
	dw_rtv.setitem(i, "mbflag", "N")
	
Next

cbx_bchk.checked = False
end event

type st_2 from statictext within w_kgld91
integer x = 78
integer y = 160
integer width = 699
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "* 마감여부 Check시 마감임"
boolean focusrectangle = false
end type

type cbx_achk from checkbox within w_kgld91
integer x = 2427
integer y = 52
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "승인 일괄마감"
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer i

If dw_rtv.rowcount() <= 0 Then Return

For i = 1 To dw_rtv.rowcount()
	
	dw_rtv.setitem(i, "maflag", "Y")
	
Next

cbx_auchk.checked = False
end event

type cbx_auchk from checkbox within w_kgld91
integer x = 2427
integer y = 116
integer width = 549
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "승인 일괄마감취소"
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer i

If dw_rtv.rowcount() <= 0 Then Return

For i = 1 To dw_rtv.rowcount()
	
	dw_rtv.setitem(i, "maflag", "N")
	
Next

cbx_achk.checked = False
end event

