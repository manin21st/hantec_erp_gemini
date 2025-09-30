$PBExportHeader$w_qct_01600.srw
$PBExportComments$**담당자별 품목별 입고현황-[수입검사](출력)
forward
global type w_qct_01600 from w_standard_print
end type
type rb_request from radiobutton within w_qct_01600
end type
type rb_insdone from radiobutton within w_qct_01600
end type
type rb_rcvdone from radiobutton within w_qct_01600
end type
type st_1 from statictext within w_qct_01600
end type
type ddlb_stat from dropdownlistbox within w_qct_01600
end type
type rb_all from radiobutton within w_qct_01600
end type
type pb_1 from u_pb_cal within w_qct_01600
end type
type pb_2 from u_pb_cal within w_qct_01600
end type
type rr_1 from roundrectangle within w_qct_01600
end type
type rr_2 from roundrectangle within w_qct_01600
end type
end forward

global type w_qct_01600 from w_standard_print
string title = "담당자별 품목별 입고 현황-[수입검사]"
rb_request rb_request
rb_insdone rb_insdone
rb_rcvdone rb_rcvdone
st_1 st_1
ddlb_stat ddlb_stat
rb_all rb_all
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_01600 w_qct_01600

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_frmdat, s_todat, s_frmemp, s_toemp, s_ittyp, s_prtgbn

if dw_ip.AcceptText() = -1 then return -1

s_frmdat = trim(dw_ip.GetItemString(1,"s_frmdat"))
s_todat  = trim(dw_ip.GetItemString(1,"s_todat"))
s_frmemp  = dw_ip.GetItemString(1,"s_frmemp")
s_toemp   = dw_ip.GetItemString(1,"s_toemp")
s_ittyp   = dw_ip.GetItemString(1,"ittyp")
s_prtgbn  = dw_ip.GetItemString(1,"prtgbn")

//디폴트 입력값
IF (IsNull(s_frmdat) OR s_frmdat = "") THEN s_frmdat = "11110101"
IF (IsNull(s_todat) OR s_todat = "") THEN s_todat = "99991231"

IF (IsNull(s_ittyp) OR s_ittyp = "") THEN 
	s_ittyp =	 "%"
end if

IF IsNull(s_frmemp) THEN  
	s_frmemp = "."
END IF
IF IsNull(s_toemp) THEN
	s_toemp  = "ZZZZZZ"
END IF

// 상태구분에 따라 데이타윈도우 선택
IF rb_request.checked = true	THEN
	if s_prtgbn = '1' then
		dw_list.DataObject = 'd_qct_01601'
		dw_print.DataObject = 'd_qct_01601_p'
	else
		dw_list.DataObject = 'd_qct_01601_1'
		dw_print.DataObject = 'd_qct_01601_1_p'
	end if
	dw_print.Object.t_statgub.Text = '검사대기'
ELSEIF rb_insdone.checked = TRUE THEN
	//자료구분에 따른 선택사항
	IF IsNull(ddlb_stat.Text) OR ddlb_stat.Text = "" OR ddlb_stat.Text = "전체" THEN
		if s_prtgbn = '1' then		
			dw_list.DataObject = 'd_qct_01602'
			dw_print.DataObject = 'd_qct_01602_p'
		ELSE
			dw_list.DataObject = 'd_qct_01602_1'
			dw_print.DataObject = 'd_qct_01602_1_p'
		END IF
	   dw_print.Object.t_dtgub.Text = "전체"
			
	ELSEIF ddlb_stat.Text = "정상" THEN
		if s_prtgbn = '1' then		
			dw_list.DataObject = 'd_qct_01603'
			dw_print.DataObject = 'd_qct_01603_p'
		ELSE
			dw_list.DataObject = 'd_qct_01603_1'		
			dw_print.DataObject = 'd_qct_01603_1_p'		
		END IF		
		dw_print.Object.t_dtgub.Text = "정상"
	ELSE
		if s_prtgbn = '1' then		
			dw_list.DataObject = 'd_qct_01604'
			dw_print.DataObject = 'd_qct_01604_p'
		ELSE
			dw_list.DataObject = 'd_qct_01604_1'		
			dw_print.DataObject = 'd_qct_01604_1_p'		
		END IF				
		dw_print.Object.t_dtgub.Text = "불량"
	END IF
	dw_print.Object.t_statgub.Text = '검사완료'
ELSEIF rb_rcvdone.checked = TRUE THEN
		if s_prtgbn = '1' then		
			dw_list.DataObject = 'd_qct_01605'
			dw_print.DataObject = 'd_qct_01605_p'
		ELSE
			dw_list.DataObject = 'd_qct_01605_1'
			dw_print.DataObject = 'd_qct_01605_1_p'
		END IF			
	dw_print.Object.t_statgub.Text = '입고완료'
ELSEIF rb_all.checked = TRUE THEN
		if s_prtgbn = '1' then		
			dw_list.DataObject = 'd_qct_01606'
			dw_print.DataObject = 'd_qct_01606_p'
		ELSE
			dw_list.DataObject = 'd_qct_01606_1'		
			dw_print.DataObject = 'd_qct_01606_1_p'		
		END IF			
	dw_print.Object.t_statgub.Text = '전체'	
END IF

//기간
dw_print.Object.t_date.Text = Mid(s_frmdat,1,4) + "." + Mid(s_frmdat,5,2) + "." + &
        Mid(s_frmdat,7,2) + "-" + Mid(s_todat,1,4) + "." + Mid(s_todat,5,2) + "." + &
	     Mid(s_todat,7,2)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

//IF dw_list.Retrieve(gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp, s_ittyp) < 1 THEN	
//	f_message_chk(50,"담당자별 품목별 입고현황-[수입검사]")
//	dw_ip.SetColumn('s_frmdat')
//	dw_ip.SetFocus()
//	return -1
//END IF

IF dw_print.Retrieve(gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp, s_ittyp) < 1 THEN	
	f_message_chk(50,"담당자별 품목별 입고현황-[수입검사]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

Return 1
end function

on w_qct_01600.create
int iCurrent
call super::create
this.rb_request=create rb_request
this.rb_insdone=create rb_insdone
this.rb_rcvdone=create rb_rcvdone
this.st_1=create st_1
this.ddlb_stat=create ddlb_stat
this.rb_all=create rb_all
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_request
this.Control[iCurrent+2]=this.rb_insdone
this.Control[iCurrent+3]=this.rb_rcvdone
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.ddlb_stat
this.Control[iCurrent+6]=this.rb_all
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_qct_01600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_request)
destroy(this.rb_insdone)
destroy(this.rb_rcvdone)
destroy(this.st_1)
destroy(this.ddlb_stat)
destroy(this.rb_all)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, "s_frmdat", left(is_today, 6) + '01')		
dw_ip.SetItem(1, "s_todat", is_today)

end event

type p_preview from w_standard_print`p_preview within w_qct_01600
end type

type p_exit from w_standard_print`p_exit within w_qct_01600
end type

type p_print from w_standard_print`p_print within w_qct_01600
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01600
end type







type st_10 from w_standard_print`st_10 within w_qct_01600
end type



type dw_print from w_standard_print`dw_print within w_qct_01600
string dataobject = "d_qct_01601_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01600
integer x = 663
integer y = 40
integer width = 2949
integer height = 240
string dataobject = "d_qct_01600"
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

type dw_list from w_standard_print`dw_list within w_qct_01600
integer x = 27
integer y = 308
integer width = 4567
integer height = 2008
string dataobject = "d_qct_01601"
boolean border = false
end type

type rb_request from radiobutton within w_qct_01600
integer x = 37
integer y = 144
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 33027312
string text = "의뢰중"
boolean checked = true
end type

event clicked;ddlb_stat.SelectItem(0)
ddlb_stat.Enabled = FALSE

end event

type rb_insdone from radiobutton within w_qct_01600
integer x = 329
integer y = 68
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 33027312
string text = "검사완료"
end type

event clicked;ddlb_stat.SelectItem(1)
ddlb_stat.Enabled = TRUE
	
end event

type rb_rcvdone from radiobutton within w_qct_01600
integer x = 329
integer y = 144
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 33027312
string text = "입고완료"
end type

event clicked;ddlb_stat.SelectItem(0)
ddlb_stat.Enabled = FALSE

end event

type st_1 from statictext within w_qct_01600
integer x = 2871
integer y = 88
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "자료구분"
boolean focusrectangle = false
end type

type ddlb_stat from dropdownlistbox within w_qct_01600
integer x = 3109
integer y = 76
integer width = 421
integer height = 304
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
boolean sorted = false
string item[] = {"전체","정상","불량"}
end type

type rb_all from radiobutton within w_qct_01600
integer x = 37
integer y = 68
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 33027312
string text = "전체"
end type

event clicked;ddlb_stat.SelectItem(0)
ddlb_stat.Enabled = FALSE

end event

type pb_1 from u_pb_cal within w_qct_01600
integer x = 1381
integer y = 64
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('s_frmdat')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 's_frmdat', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_01600
integer x = 1801
integer y = 64
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('s_todat')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 's_todat', gs_code)
end event

type rr_1 from roundrectangle within w_qct_01600
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 48
integer width = 640
integer height = 216
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_01600
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 300
integer width = 4590
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

