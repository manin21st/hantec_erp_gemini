$PBExportHeader$w_qct_01570.srw
$PBExportComments$**재검사현황-[검사일자별](출력)
forward
global type w_qct_01570 from w_standard_print
end type
type rb_1 from radiobutton within w_qct_01570
end type
type rb_2 from radiobutton within w_qct_01570
end type
type st_4 from statictext within w_qct_01570
end type
type pb_1 from u_pb_cal within w_qct_01570
end type
type pb_2 from u_pb_cal within w_qct_01570
end type
type rr_1 from roundrectangle within w_qct_01570
end type
type rr_2 from roundrectangle within w_qct_01570
end type
end forward

global type w_qct_01570 from w_standard_print
string title = "재검사 현황[검사일자별]"
rb_1 rb_1
rb_2 rb_2
st_4 st_4
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_01570 w_qct_01570

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_frmdate, s_todate, s_insemp, s_null
integer  i_rtnval

SetNull(s_null)
if dw_ip.AcceptText() = -1 then return -1

s_frmdate = trim(dw_ip.GetItemString(1,"s_frmdate"))
s_todate  = trim(dw_ip.GetItemString(1,"s_todate"))
s_insemp  = dw_ip.GetItemString(1,"s_insemp")

//디폴트 입력값
IF (IsNull(s_frmdate) OR s_frmdate = "") THEN s_frmdate = "11110101"
IF (IsNull(s_todate) OR s_todate = "") THEN s_todate = "99991231"
IF IsNull(s_insemp) THEN  s_insemp = "%"

// 사내,사외 데이타윈도우 구분
dw_list.setredraw(false)
IF rb_1.checked = true	THEN
	dw_list.DataObject = 'd_qct_01571'
	dw_print.DataObject = 'd_qct_01571_p'
	dw_list.Object.t_gubun.Text = '사내'
ELSE
	dw_list.DataObject = 'd_qct_01572'
	dw_print.DataObject = 'd_qct_01572_p'
	dw_list.Object.t_gubun.Text = '사외'
END IF
dw_list.setredraw(true)

dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

//IF dw_list.Retrieve(gs_sabu, s_frmdate, s_todate, s_insemp) < 1 THEN
//	f_message_chk(50,"[재검사현황(검사일자별)]")
//	dw_ip.SetColumn('s_frmdate')
//	dw_ip.SetFocus()
//	return -1
//END IF

IF dw_print.Retrieve(gs_sabu, s_frmdate, s_todate, s_insemp) < 1 THEN
	f_message_chk(50,"[재검사현황(검사일자별)]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

dw_print.Object.t_inspdate.Text = Mid(s_frmdate,1,4) + "." + Mid(s_frmdate,5,2) + "." + &
        Mid(s_frmdate,7,2) + "-" + Mid(s_todate,1,4) + "." + Mid(s_todate,5,2) + "." + &
	     Mid(s_todate,7,2)


Return 1
end function

on w_qct_01570.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_4=create st_4
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_qct_01570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_4)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, "s_frmdate", left(is_today, 6) + '01')		
dw_ip.SetItem(1, "s_todate", is_today)

/* 생산팀 & 영업팀 & 관할구역 Filtering */
DataWindowChild state_child
integer rtncode

//담당자1
rtncode 	= dw_ip.GetChild('s_insemp', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자1")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('45',gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_qct_01570
end type

type p_exit from w_standard_print`p_exit within w_qct_01570
end type

type p_print from w_standard_print`p_print within w_qct_01570
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01570
end type







type st_10 from w_standard_print`st_10 within w_qct_01570
end type



type dw_print from w_standard_print`dw_print within w_qct_01570
string dataobject = "d_qct_01571_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01570
integer x = 923
integer y = 52
integer width = 2263
integer height = 148
string dataobject = "d_qct_01570"
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

type dw_list from w_standard_print`dw_list within w_qct_01570
integer x = 64
integer y = 248
integer width = 4503
integer height = 2056
string dataobject = "d_qct_01571"
boolean border = false
end type

type rb_1 from radiobutton within w_qct_01570
integer x = 325
integer y = 88
integer width = 238
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 8388608
long backcolor = 33027312
string text = "사내"
boolean checked = true
end type

type rb_2 from radiobutton within w_qct_01570
integer x = 571
integer y = 88
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 8388608
long backcolor = 33027312
string text = "기타입고"
end type

type st_4 from statictext within w_qct_01570
integer x = 73
integer y = 96
integer width = 197
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "구  분"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_qct_01570
integer x = 1527
integer y = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('s_frmdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 's_frmdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_01570
integer x = 1947
integer y = 76
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('s_todate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 's_todate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_01570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 36
integer width = 3191
integer height = 180
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_01570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 240
integer width = 4535
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

