$PBExportHeader$w_qct_01710.srw
$PBExportComments$**검사기준 예정변경현황(출력)
forward
global type w_qct_01710 from w_standard_print
end type
type st_1 from statictext within w_qct_01710
end type
type em_month from editmask within w_qct_01710
end type
type rr_1 from roundrectangle within w_qct_01710
end type
type rr_2 from roundrectangle within w_qct_01710
end type
end forward

global type w_qct_01710 from w_standard_print
string title = "검사 기준 예정 변경 현황"
st_1 st_1
em_month em_month
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_01710 w_qct_01710

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_cod1, s_cod2, s_nam1, s_nam2, s_month, s_null, s_frmdate, s_todate
integer  i_year, i_month

SetNull(s_null)
if dw_ip.AcceptText() = -1 then return -1

//입력정보 검사
IF Integer(em_month.Text) < 1 OR Integer(em_month.Text) > 12 THEN
	f_message_chk(50,"[검사기준 예정변경현황]")
	em_month.Text = "1"
   em_month.SetFocus()
	return -1
END IF

s_month = em_month.Text
s_cod1 = Trim(dw_ip.GetItemString(1,"cod1"))
s_cod2 = Trim(dw_ip.GetItemString(1,"cod2"))

IF IsNull(s_cod1) OR s_cod1 = "" THEN	
	s_cod1 = '.'
END IF
IF IsNull(s_cod2) OR s_cod2 = "" THEN  
	s_cod2 = 'ZZZZZZ'
END IF

IF s_cod1 = '.' and s_cod2 = 'ZZZZZZ' then 
	dw_print.Object.t_vendor.Text = '전체'
ELSE
	dw_print.Object.t_vendor.Text = s_cod1 + " - " + s_cod2
END IF

IF IsNull(s_month) OR s_month = "" THEN
	s_month = '1'
END IF

//날짜얻기
s_todate = f_today() //String(Today(), 'yyyymmdd')
i_month = Integer(Mid(s_todate, 5, 2)) - Integer(s_month)
i_year  = Integer(Mid(s_todate, 1, 4))

IF i_month <= 0 THEN
	i_month = 12 + i_month
	i_year  = i_year - 1
END IF

IF i_month < 10 THEN
   s_frmdate = String(i_year) + "0" + String(i_month) + "01"
ELSE
	s_frmdate = String(i_year)  + String(i_month) + "01"
END IF

dw_print.Object.t_month.Text  = s_month

//IF dw_list.Retrieve(gs_sabu, s_cod1, s_cod2, s_frmdate, s_todate ) < 1 THEN
//	f_message_chk(50,"[검사기준 예정변경현황]")
//	dw_ip.SetColumn('cod1')
//	dw_ip.SetFocus()
//	return -1
//END IF

IF dw_print.Retrieve(gs_sabu, s_cod1, s_cod2, s_frmdate, s_todate ) < 1 THEN
	f_message_chk(50,"[검사기준 예정변경현황]")
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.Object.t_month.Text  = s_month
dw_print.ShareData(dw_list)

Return 1

end function

on w_qct_01710.create
int iCurrent
call super::create
this.st_1=create st_1
this.em_month=create em_month
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_month
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_qct_01710.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_month)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;em_month.Text = "1"
end event

type p_preview from w_standard_print`p_preview within w_qct_01710
end type

type p_exit from w_standard_print`p_exit within w_qct_01710
end type

type p_print from w_standard_print`p_print within w_qct_01710
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01710
end type







type st_10 from w_standard_print`st_10 within w_qct_01710
end type



type dw_print from w_standard_print`dw_print within w_qct_01710
integer x = 2775
integer y = 60
integer width = 229
boolean titlebar = true
string dataobject = "d_qct_01711_p"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01710
integer x = 654
integer y = 68
integer width = 1783
integer height = 92
string dataobject = "d_qct_01710"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

gs_gubun = '1'

IF	this.GetColumnName() = "cod1"	THEN		
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "cod1", gs_code)
	this.SetItem(1, "nam1", gs_codename)
ELSEIF this.GetColumnName() = "cod2" THEN		
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "cod2", gs_code)
	this.SetItem(1, "nam2", gs_codename)
END IF

end event

event dw_ip::itemchanged;string snull, s_cod, s_nam1, s_nam2
int    i_rtn

IF this.GetColumnName() = 'cod1' THEN   
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cod1",s_cod)
	this.SetItem(1,"nam1",s_nam1)
	return i_rtn
elseIF this.GetColumnName() = 'cod2' THEN   
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cod2",s_cod)
	this.SetItem(1,"nam2",s_nam1)
	return i_rtn
END IF	
end event

type dw_list from w_standard_print`dw_list within w_qct_01710
integer y = 228
integer width = 4549
integer height = 2084
string dataobject = "d_qct_01711"
boolean border = false
end type

type st_1 from statictext within w_qct_01710
integer x = 87
integer y = 84
integer width = 334
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
string text = "기준개월수"
boolean focusrectangle = false
end type

type em_month from editmask within w_qct_01710
integer x = 430
integer y = 76
integer width = 174
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string mask = "#####"
boolean spin = true
string minmax = "1~~12"
end type

type rr_1 from roundrectangle within w_qct_01710
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 40
integer width = 2560
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_01710
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 216
integer width = 4567
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 55
end type

