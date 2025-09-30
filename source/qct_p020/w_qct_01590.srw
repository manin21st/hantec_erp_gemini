$PBExportHeader$w_qct_01590.srw
$PBExportComments$**일일 품목별 입고현황-[수입검사](출력)
forward
global type w_qct_01590 from w_standard_print
end type
type rb_request from radiobutton within w_qct_01590
end type
type rb_insdone from radiobutton within w_qct_01590
end type
type rb_rcvdone from radiobutton within w_qct_01590
end type
type ddlb_stat from dropdownlistbox within w_qct_01590
end type
type rb_all from radiobutton within w_qct_01590
end type
type ddlb_1 from dropdownlistbox within w_qct_01590
end type
type pb_1 from u_pb_cal within w_qct_01590
end type
type pb_2 from u_pb_cal within w_qct_01590
end type
type gb_1 from groupbox within w_qct_01590
end type
type gb_2 from groupbox within w_qct_01590
end type
type rr_1 from roundrectangle within w_qct_01590
end type
end forward

global type w_qct_01590 from w_standard_print
string title = "일일 품목별 입고 현황-[수입검사]"
rb_request rb_request
rb_insdone rb_insdone
rb_rcvdone rb_rcvdone
ddlb_stat ddlb_stat
rb_all rb_all
ddlb_1 ddlb_1
pb_1 pb_1
pb_2 pb_2
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
end type
global w_qct_01590 w_qct_01590

type variables

end variables

forward prototypes
public function integer wf_retrieve2 (string arg_rptgbn, string s_frmdat, string s_todat, string s_frmemp, string s_toemp, string sjnpcrt1, string sjnpcrt2)
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve2 (string arg_rptgbn, string s_frmdat, string s_todat, string s_frmemp, string s_toemp, string sjnpcrt1, string sjnpcrt2);////--------------------------------------------------
////      dw_list를 조회 한다. 
//// Argument : Report 구분 
////--------------------------------------------------
//String sSql, sNewSql, sWhere_Clase_add
//
//sSql = dw_list.GetSqlselect()
//
//CHOOSE CASE arg_rptgbn
//	CASE '1'
//		sWhere_Clase_add = 'and ( "IMHIST"."SABU" = ' + gs_sabu + ' ) and ' + &
//			                '( "IMHIST"."SUDAT" >= ' + s_frmdat + ') and ( "IMHIST"."SUDAT" <= ' + s_todat + ')  and' + &
//                      	 '( "IMHIST"."INSEMP" >= ' + s_frmemp + ') and ( "IMHIST"."INSEMP" <= ' + s_toemp + ') and' + &
//                      	 '( "IMHIST"."JNPCRT" in  (' + sJnpcrt1 + ', ' + sJnpcrt2 + ') ) and' + &
//                      	 '( "IMHIST"."INSDAT" IS NULL ) '
//	CASE '2'
//		sWhere_Clase_add = 'and ( "IMHIST"."SABU" = ' + gs_sabu + ' ) and ' + &
//			                '( "IMHIST"."SUDAT" >= ' + s_frmdat + ') and ( "IMHIST"."SUDAT" <= ' + s_todat + ')  and' + &
//                      	 '( "IMHIST"."INSEMP" >= ' + s_frmemp + ') and ( "IMHIST"."INSEMP" <= ' + s_toemp + ') and' + &
//                      	 '( "IMHIST"."INSDAT" IS NOT NULL ) and ' + &
//                      	 '( "IMHIST"."JNPCRT" in  (' + sJnpcrt1 + ', ' + sJnpcrt2 + ') ) '
//	CASE '3'
//
//		sWhere_Clase_add = 'and ( "IMHIST"."SABU" = ' + gs_sabu + ' ) and ' + &
//			                '( "IMHIST"."SUDAT" >= ' + s_frmdat + ') and ( "IMHIST"."SUDAT" <= ' + s_todat + ')  and' + &
//                      	 '( "IMHIST"."INSEMP" >= ' + s_frmemp + ') and ( "IMHIST"."INSEMP" <= ' + s_toemp + ') and' + &
//                      	 '( "IMHIST"."INSDAT" IS NOT NULL ) and ' + &
//                      	 '( "IMHIST"."JNPCRT" in  (' + sJnpcrt1 + ', ' + sJnpcrt2 + ') ) '
//	CASE '4'
//
//
//	CASE '5'
//
//
//	CASE '6'
//
//
//END CHOOSE
//
Return 1	
//	
//
////gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp, sJnpcrt1, sJnpcrt2
//
////( "IMHIST"."SABU" = :gsabu ) and
////			( "IMHIST"."SUDAT" >= :frmdat ) and ( "IMHIST"."SUDAT" <= :todat )  and
////         ( "IMHIST"."INSEMP" >= :frmemp ) and ( "IMHIST"."INSEMP" <= :toemp )  and
////         ( "IMHIST"."INSDAT" IS NOT NULL )  and
////         ( "IMHIST"."JNPCRT" IN ('007', '025' ) ) and
end function

public function integer wf_retrieve ();string   s_frmdat, s_todat, s_frmemp, s_toemp, sJnpcrt1, sJnpcrt2, sJnpcrt3, sJnpcrt4, ls_fcvcod, ls_tcvcod

if dw_ip.AcceptText() = -1 then return -1

s_frmdat = trim(dw_ip.GetItemString(1,"s_frmdat"))
s_todat  = trim(dw_ip.GetItemString(1,"s_todat"))
s_frmemp  = dw_ip.GetItemString(1,"s_frmemp")
s_toemp   = dw_ip.GetItemString(1,"s_toemp")
ls_fcvcod   = dw_ip.GetItemString(1,"fcvcod")
ls_tcvcod   = dw_ip.GetItemString(1,"tcvcod")

//디폴트 입력값
IF (IsNull(s_frmdat) OR s_frmdat = "") THEN s_frmdat = "10000101"
IF (IsNull(s_todat) OR s_todat = "") THEN s_todat = "99991231"
IF (IsNull(ls_fcvcod) OR ls_fcvcod = "") THEN ls_fcvcod = "."
IF (IsNull(ls_tcvcod) OR ls_tcvcod = "") THEN ls_tcvcod = "ZZZZ"

IF IsNull(s_frmemp) THEN  
	s_frmemp = "."
END IF

IF IsNull(s_toemp) THEN
	s_toemp  = "ZZZZZZ"
END IF

// 상태구분에 따라 데이타윈도우 선택
sJnpcrt1 = '007'
sJnpcrt2 = '025'
sJnpcrt3 = '009'
sJnpcrt4 = '011'
IF rb_request.checked = true	THEN	
	dw_list.DataObject = 'd_qct_01591'
	dw_print.DataObject = 'd_qct_01591_p'
	dw_print.Object.t_statgub.Text = '검사대기'
	
	//자료구분에 따른 선택사항
	IF IsNull(ddlb_1.Text) OR ddlb_1.Text = "" OR ddlb_1.Text = "전체" THEN
		sJnpcrt1 = '007'
		sJnpcrt2 = '025'
	   dw_print.Object.t_dtgub.Text = "전체"		
	ELSEIF ddlb_1.Text = "수입" THEN
		sJnpcrt1 = '007'
		sJnpcrt2 = '007'
		dw_print.Object.t_dtgub.Text = "수입검사"
	ELSE
		sJnpcrt1 = '025'
		sJnpcrt2 = '025'
		dw_print.Object.t_dtgub.Text = "특채검사"
	END IF
	
ELSEIF rb_insdone.checked = TRUE THEN
	//자료구분에 따른 선택사항
	IF IsNull(ddlb_stat.Text) OR ddlb_stat.Text = "" OR ddlb_stat.Text = "전체" THEN
	   dw_list.DataObject = 'd_qct_01592'
		dw_print.DataObject = 'd_qct_01592_p'
	   dw_print.Object.t_dtgub.Text = "전체"		
	ELSEIF ddlb_stat.Text = "정상" THEN
		dw_list.DataObject = 'd_qct_01593'
		dw_print.DataObject = 'd_qct_01593_p'
		dw_print.Object.t_dtgub.Text = "정상"
	ELSE
		dw_list.DataObject = 'd_qct_01594'
		dw_print.DataObject = 'd_qct_01594_p'
		dw_print.Object.t_dtgub.Text = "불량"
	END IF
	dw_print.Object.t_statgub.Text = '검사완료'
ELSEIF rb_rcvdone.checked = TRUE THEN
	dw_list.DataObject = 'd_qct_01595'
	dw_print.DataObject = 'd_qct_01595_p'
	dw_print.Object.t_statgub.Text = '입고완료'
ELSE
	dw_list.DataObject = 'd_qct_01596'
	dw_print.DataObject = 'd_qct_01596_p'
	dw_print.Object.t_statgub.Text = '전체'
END IF	

//기간
dw_print.Object.t_date.Text = Mid(s_frmdat,1,4) + "." + Mid(s_frmdat,5,2) + "." + &
        Mid(s_frmdat,7,2) + "-" + Mid(s_todat,1,4) + "." + Mid(s_todat,5,2) + "." + &
	     Mid(s_todat,7,2)

//조회
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

//IF rb_request.checked = true	THEN
//	IF dw_list.Retrieve(gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp, sJnpcrt1, sJnpcrt2) < 1 THEN
//		f_message_chk(50,"일일 품목별 입고현황")
//		dw_ip.SetColumn('s_frmdat')
//		dw_ip.SetFocus()
//		return -1
//	END IF
//ELSE
//	IF dw_list.Retrieve(gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp) < 1 THEN
//		f_message_chk(50,"일일 품목별 입고현황")
//		dw_ip.SetColumn('s_frmdat')
//		dw_ip.SetFocus()
//		return -1
//	END IF
//END IF

IF rb_request.checked = true	THEN
	IF dw_print.Retrieve(gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp, sJnpcrt1, sJnpcrt2, sJnpcrt3, sJnpcrt4, ls_fcvcod,ls_tcvcod) < 1 THEN
		f_message_chk(50,"일일 품목별 입고현황")
		dw_ip.SetColumn('s_frmdat')
		dw_ip.SetFocus()
		return -1
	END IF
ELSE
	IF dw_print.Retrieve(gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp,ls_fcvcod,ls_tcvcod) < 1 THEN
		f_message_chk(50,"일일 품목별 입고현황")
		dw_ip.SetColumn('s_frmdat')
		dw_ip.SetFocus()
		return -1
	END IF
END IF

//IF dw_print.Retrieve(gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp, sJnpcrt1, sJnpcrt2) < 1 THEN
//	f_message_chk(50,"일일 품목별 입고현황")
//	dw_list.Reset()
//	dw_ip.SetFocus()
//	dw_list.SetRedraw(true)
//	dw_print.insertrow(0)
////	Return -1
//END IF
//
dw_print.ShareData(dw_list)

Return 1
end function

on w_qct_01590.create
int iCurrent
call super::create
this.rb_request=create rb_request
this.rb_insdone=create rb_insdone
this.rb_rcvdone=create rb_rcvdone
this.ddlb_stat=create ddlb_stat
this.rb_all=create rb_all
this.ddlb_1=create ddlb_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_request
this.Control[iCurrent+2]=this.rb_insdone
this.Control[iCurrent+3]=this.rb_rcvdone
this.Control[iCurrent+4]=this.ddlb_stat
this.Control[iCurrent+5]=this.rb_all
this.Control[iCurrent+6]=this.ddlb_1
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.rr_1
end on

on w_qct_01590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_request)
destroy(this.rb_insdone)
destroy(this.rb_rcvdone)
destroy(this.ddlb_stat)
destroy(this.rb_all)
destroy(this.ddlb_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.rr_1)
end on

event open;call super::open;string  s_today, s_frmdate, s_todate, s_lastday, syymm

s_today = String(Today(), 'yyyymmdd')
s_frmdate = Mid(s_today,1,6) + "01"

syymm     = Mid(s_today,1,6)

  SELECT Max(substr(cldate, 7, 2))
    INTO :s_lastday  
	 FROM p4_calendar
   where cldate like :syymm||'%';

s_todate  = Mid(s_today,1,6) + s_lastday

dw_ip.SetItem(1, "s_frmdat", s_frmdate)		
dw_ip.SetItem(1, "s_todat", s_todate)

ddlb_1.SelectItem(1)
ddlb_1.Enabled = TRUE
	
/* 생산팀 & 영업팀 & 관할구역 Filtering */
/* 생산팀 & 영업팀 & 관할구역 Filtering */
//DataWindowChild state_child
//integer rtncode
//
////담당자1
//rtncode 	= dw_ip.GetChild('s_frmemp', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자1")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve('45',gs_saupj)
//
////담당자2
//rtncode 	= dw_ip.GetChild('s_toemp', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자2")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve('45',gs_saupj)

end event

type p_preview from w_standard_print`p_preview within w_qct_01590
end type

type p_exit from w_standard_print`p_exit within w_qct_01590
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_qct_01590
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01590
end type







type st_10 from w_standard_print`st_10 within w_qct_01590
end type



type dw_print from w_standard_print`dw_print within w_qct_01590
string dataobject = "d_qct_01592_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01590
integer x = 18
integer y = 12
integer width = 2222
integer height = 232
string dataobject = "d_qct_01590"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String s_col

this.AcceptText()
s_col = this.GetColumnName()
if s_col = "s_frmdate" then
	if IsNull(trim(this.object.s_frmdate[1])) or trim(this.object.s_frmdate[1]) = "" then return 
	if f_datechk(trim(this.object.s_frmdate[1])) = -1 then
		messagebox("확인","날짜입력에러![" + trim(this.object.s_frmdate[1]) + "]")
		this.object.s_frmdate[1] = ""
		return 1
	end if
elseif s_col = "s_todate" then
	if IsNull(trim(this.object.s_todate[1])) or trim(this.object.s_todate[1]) = "" then return 
	if f_datechk(trim(this.object.s_todate[1])) = -1 then
		messagebox("확인","날짜입력에러![" + trim(this.object.s_todate[1]) + "]")
		this.object.s_todate[1] = ""
		return 1
	end if
end if
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = 'fcvcod'	THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"fcvcod",		gs_code)
//	SetItem(1,"fcvnm",  gs_codename)
ELSEIF this.GetColumnName() = 'tcvcod'	THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"tcvcod",	gs_code)
//	SetItem(1,"tcvnm",  gs_codename)
END IF
end event

type dw_list from w_standard_print`dw_list within w_qct_01590
integer x = 32
integer y = 288
integer width = 4562
integer height = 2008
string dataobject = "d_qct_01592"
boolean border = false
end type

type rb_request from radiobutton within w_qct_01590
integer x = 2587
integer y = 64
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 8388608
long backcolor = 32106727
string text = "검사대기"
boolean checked = true
end type

event clicked;ddlb_stat.SelectItem(0)
ddlb_stat.Enabled = FALSE

ddlb_1.SelectItem(1)
ddlb_1.Enabled = TRUE

dw_ip.Modify("fcvcod.visible = NO")
dw_ip.Modify("tcvcod.visible = NO")
dw_ip.Modify("t_5.visible = NO")
dw_ip.Modify("p_1.visible = NO")
dw_ip.Modify("t_6.visible = NO")
end event

type rb_insdone from radiobutton within w_qct_01590
integer x = 2962
integer y = 64
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 8388608
long backcolor = 32106727
string text = "검사완료"
end type

event clicked;ddlb_stat.SelectItem(1)
ddlb_stat.Enabled = TRUE
	
ddlb_1.SelectItem(0)
ddlb_1.Enabled = FALSE

dw_ip.Modify("fcvcod.visible = YES")
dw_ip.Modify("tcvcod.visible = YES")
dw_ip.Modify("t_5.visible = YES")
dw_ip.Modify("p_1.visible = YES")
dw_ip.Modify("t_6.visible = YES")
end event

type rb_rcvdone from radiobutton within w_qct_01590
integer x = 2587
integer y = 152
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 8388608
long backcolor = 32106727
string text = "입고완료"
end type

event clicked;ddlb_stat.SelectItem(0)
ddlb_stat.Enabled = FALSE

ddlb_1.SelectItem(0)
ddlb_1.Enabled = FALSE

dw_ip.Modify("fcvcod.visible = NO")
dw_ip.Modify("tcvcod.visible = NO")
dw_ip.Modify("t_5.visible = NO")
dw_ip.Modify("p_1.visible = NO")
dw_ip.Modify("t_6.visible = NO")
end event

type ddlb_stat from dropdownlistbox within w_qct_01590
integer x = 3461
integer y = 160
integer width = 247
integer height = 260
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
boolean sorted = false
string item[] = {"전체","정상","불량"}
borderstyle borderstyle = stylelowered!
end type

type rb_all from radiobutton within w_qct_01590
integer x = 2962
integer y = 152
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체"
end type

event clicked;ddlb_stat.SelectItem(0)
ddlb_stat.Enabled = FALSE

ddlb_1.SelectItem(0)
ddlb_1.Enabled = FALSE

dw_ip.Modify("fcvcod.visible = NO")
dw_ip.Modify("tcvcod.visible = NO")
dw_ip.Modify("t_5.visible = NO")
dw_ip.Modify("p_1.visible = NO")
dw_ip.Modify("t_6.visible = NO")
end event

type ddlb_1 from dropdownlistbox within w_qct_01590
integer x = 3461
integer y = 68
integer width = 247
integer height = 276
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
boolean sorted = false
string item[] = {"전체","수입","특채"}
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_qct_01590
integer x = 763
integer y = 28
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('s_frmdat')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 's_frmdat', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_01590
integer x = 1184
integer y = 28
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('s_todat')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 's_todat', gs_code)
end event

type gb_1 from groupbox within w_qct_01590
integer x = 2542
integer width = 809
integer height = 260
integer taborder = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "상태구분"
end type

type gb_2 from groupbox within w_qct_01590
integer x = 3387
integer width = 393
integer height = 260
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "자료구분"
end type

type rr_1 from roundrectangle within w_qct_01590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 280
integer width = 4599
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

