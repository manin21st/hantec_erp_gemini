$PBExportHeader$w_qct_01610.srw
$PBExportComments$월별 품질현황
forward
global type w_qct_01610 from w_standard_dw_graph
end type
type dw_1 from datawindow within w_qct_01610
end type
end forward

global type w_qct_01610 from w_standard_dw_graph
string title = "월별 업체 품질현황"
dw_1 dw_1
end type
global w_qct_01610 w_qct_01610

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sabu, ls_sdate, ls_vndcode, ls_m11, senddate
decimal {2} drate

if dw_ip.AcceptText() = -1 then return -1

ls_sabu = gs_sabu
ls_sdate = TRIM(dw_ip.GetItemString(1, 'stddate'))
ls_vndcode = dw_ip.GetItemString(1, 't_vndcode')
drate = dw_ip.GetItemdecimal(1, 'rate')

if IsNull(ls_sdate) or ls_sdate = "" then 
	f_message_chk(1400,'[기준년월]')
   dw_ip.Setfocus()
   dw_ip.Setcolumn('stddate')
	return -1
end if

if IsNull(ls_vndcode) or ls_vndcode = "" then 
	f_message_chk(1400,'[거래처코드]')
   dw_ip.Setfocus()
   dw_ip.Setcolumn('t_vndcode')	
	return -1
end if 

// M-11월을 계산하는 공식
// ls_m11 = M-11개월
if right(ls_sdate, 2) <= "11" then
	ls_m11 = string( long(ls_sdate) - 99)
elseif right(ls_sdate, 2) = "12" then
	ls_m11 = string( long(ls_sdate) - 11)	
else 
	MessageBox("확인", "잘못된 날짜입니다.!!")
end if

dw_list.object.stddate_t.text = left(ls_sdate, 4) + '년'  + right(ls_sdate, 2) + '월'
sEnddate = ls_sdate+'99'

//messagebox(ls_m11, senddate)
dw_list.setredraw(false)
if dw_list.retrieve(ls_sabu, ls_vndcode, ls_m11, sEnddate, drate) <= 0 then
   dw_list.setredraw(true)	
	f_message_chk(50,'[월별 품질현황]')
	dw_ip.Setfocus()
	return -1 
end if

dw_1.retrieve(ls_sabu, ls_vndcode, ls_sdate)

dw_list.setredraw(true)	
	
return 1

end function

on w_qct_01610.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_qct_01610.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;//dw_list.insertrow(0)

dw_1.settransobject(sqlca)

dw_ip.setitem(1, "stddate", left(f_today(), 6))
end event

type p_exit from w_standard_dw_graph`p_exit within w_qct_01610
end type

type p_print from w_standard_dw_graph`p_print within w_qct_01610
end type

event p_print::clicked;call super::clicked;//dw_1.print()
end event

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_01610
end type

type st_window from w_standard_dw_graph`st_window within w_qct_01610
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_01610
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_01610
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_01610
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_01610
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_01610
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_01610
integer x = 23
integer y = 12
integer width = 2985
integer height = 200
string dataobject = "d_qct_01610_01"
end type

event dw_ip::itemchanged;string ls_sdate, snull, scvcod, sname1, sname2
int    ireturn

SetNull(snull)

if this.GetColumnName() = "stddate" then 
	ls_sdate = trim(this.GetText())  

   if IsNUll(ls_sdate) or ls_sdate = "" then return  
   
	if f_datechk(ls_sdate + '01' ) = -1 then //날짜체크 
	   f_message_chk(35,"[사용일자]") 
	   this.SetItem(1, 'stddate', snull)   
	   return 1   
   end if  
elseif this.GetColumnName() = "t_vndcode" then 
	scvcod = trim(this.GetText())

	ireturn = f_get_name2('V1', 'Y', scvcod, sname1, sname2)    //1이면 실패, 0이 성공	
	this.setitem(1, "t_vndcode", scvcod)	
	this.setitem(1, "vndnm", sname1)	
	RETURN ireturn
elseif this.GetColumnName() = "gub" then
	If GetText() = '1' Then
		dw_list.DataObject = 'd_qct_01610_02'
	Else
		dw_list.DataObject = 'd_qct_01610_02_lot'
	End If
	dw_list.SetTransObject(sqlca)
end if

end event

event dw_ip::rbuttondown;setNull(Gs_code)
setNull(Gs_codename)


IF this.GetColumnName() = "t_vndcode" THEN
	open(w_vndmst_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(), "t_vndcode", Gs_code)
	this.SetItem(this.GetRow(), "vndnm", Gs_codename)
	
END IF
end event

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_01610
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_01610
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_01610
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_01610
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_01610
string title = "월별 품질현황"
string dataobject = "d_qct_01610_02"
boolean border = false
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_01610
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_01610
end type

type dw_1 from datawindow within w_qct_01610
boolean visible = false
integer x = 3241
integer y = 44
integer width = 745
integer height = 100
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "월별 품질현황2"
string dataobject = "d_qct_01610_05"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

