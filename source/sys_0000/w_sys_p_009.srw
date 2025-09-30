$PBExportHeader$w_sys_p_009.srw
$PBExportComments$** 프로그램 사용내역 조회 출력
forward
global type w_sys_p_009 from w_standard_print
end type
type rb_time from radiobutton within w_sys_p_009
end type
type rb_user from radiobutton within w_sys_p_009
end type
type rb_win from radiobutton within w_sys_p_009
end type
type st_1 from statictext within w_sys_p_009
end type
type rr_1 from roundrectangle within w_sys_p_009
end type
end forward

global type w_sys_p_009 from w_standard_print
integer x = 0
integer y = 0
string title = "프로그램 사용내역 현황"
boolean resizable = true
windowstate windowstate = maximized!
rb_time rb_time
rb_user rb_user
rb_win rb_win
st_1 st_1
rr_1 rr_1
end type
global w_sys_p_009 w_sys_p_009

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sSQL, s_sdate, s_edate, s_winid

if dw_ip.AcceptText() = -1 then return -1

s_sdate = trim(dw_ip.GetItemString(1,'sdate'))
s_edate = trim(dw_ip.GetItemString(1,'edate'))

if s_sdate > s_edate then
   f_message_chk(34,'[사용일자]')
   dw_ip.Setfocus()
   return -1
end if		
s_winid = trim(dw_ip.GetItemString(1,'winid'))
	 
sSQL = "SELECT A.L_USERID, A.CDATE, A.STIME, A.WINDOW_NAME, A.EDATE, A.ETIME, " + &
       "       A.IPADD, A.USER_NAME, B.SUB2_NAME, A.UPD_DATE, A.UPD_TIME " + &
       "  FROM PGM_HISTORY A, ( SELECT DISTINCT WINDOW_NAME, SUB2_NAME FROM SUB2_T ) B " + &
       " WHERE A.WINDOW_NAME = B.WINDOW_NAME (+) "      

if not IsNUll(s_sdate) then
	sSQL = sSQL + " AND A.CDATE >= '" + s_sdate + "' " 
end if
if not IsNUll(s_edate) then
	sSQL = sSQL + " AND A.CDATE <= '" + s_edate + "' " 
end if
if not IsNUll(s_winid) then
	sSQL = sSQL + " AND A.WINDOW_NAME LIKE '" + s_winid + "%' " 
end if

if rb_time.Checked = True then
	sSQL = sSQL + " ORDER BY A.CDATE, A.STIME, A.L_USERID, A.WINDOW_NAME "
elseif rb_user.Checked then
	sSQL = sSQL + " ORDER BY A.L_USERID, A.CDATE, A.STIME, A.WINDOW_NAME "
else	
   sSQL = sSQL + " ORDER BY A.WINDOW_NAME, A.CDATE, A.STIME, A.L_USERID "
end if	
dw_list.SetSQLSelect(sSQL)
if dw_list.Retrieve() <= 0 then
	f_message_chk(50,'[프로그램 사용내역 현황]')
	dw_ip.Setfocus()
	return -1
end if			
return 1


end function

on w_sys_p_009.create
int iCurrent
call super::create
this.rb_time=create rb_time
this.rb_user=create rb_user
this.rb_win=create rb_win
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_time
this.Control[iCurrent+2]=this.rb_user
this.Control[iCurrent+3]=this.rb_win
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_sys_p_009.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_time)
destroy(this.rb_user)
destroy(this.rb_win)
destroy(this.st_1)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_sys_p_009
end type

type p_sort from w_standard_print`p_sort within w_sys_p_009
end type

type p_preview from w_standard_print`p_preview within w_sys_p_009
integer x = 4059
integer y = 20
end type

type p_exit from w_standard_print`p_exit within w_sys_p_009
integer x = 4416
integer y = 20
end type

type p_print from w_standard_print`p_print within w_sys_p_009
integer x = 4238
integer y = 20
end type

type p_retrieve from w_standard_print`p_retrieve within w_sys_p_009
integer x = 3881
integer y = 20
end type

event p_retrieve::clicked;long ip_row
String s_sdate, s_edate, s_sort

dw_ip.AcceptText()
ip_row = dw_ip.getrow()
s_sdate = trim(dw_ip.GetItemString(ip_row, "sdate"))
s_edate = trim(dw_ip.GetItemString(ip_row, "edate"))

if IsNull(s_sdate) or s_sdate = "" then 
	s_sdate = ' '
else
   s_sdate = String(s_sdate, "@@@@.@@.@@")
end if

if IsNull(s_edate) or s_edate = "" then
	s_edate = ' '
else
   s_edate = String(s_edate, "@@@@.@@.@@")
end if

if rb_time.Checked then 
	s_sort = rb_time.Text
elseif rb_user.Checked then 
	s_sort = rb_user.Text
else 
	s_sort = rb_win.Text	
end if	

dw_print.object.txt_date.Text = s_sdate + " - " + s_edate
dw_print.object.txt_sort.Text = s_sort

call SUPER::Clicked
end event

type st_window from w_standard_print`st_window within w_sys_p_009
boolean visible = false
integer x = 2354
integer y = 2600
end type

type sle_msg from w_standard_print`sle_msg within w_sys_p_009
boolean visible = false
integer x = 407
integer y = 2600
integer width = 1943
boolean enabled = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_sys_p_009
boolean visible = false
integer x = 2853
integer y = 2600
integer width = 741
integer height = 84
boolean enabled = false
end type

type st_10 from w_standard_print`st_10 within w_sys_p_009
boolean visible = false
integer x = 41
integer y = 2600
integer width = 361
end type

type gb_10 from w_standard_print`gb_10 within w_sys_p_009
boolean visible = false
integer x = 32
integer y = 2564
boolean enabled = false
end type

type dw_print from w_standard_print`dw_print within w_sys_p_009
integer x = 91
integer y = 168
string dataobject = "d_sys_p_0091_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sys_p_009
integer x = 18
integer width = 3845
integer height = 152
string dataobject = "d_sys_p_0092"
end type

event dw_ip::rbuttondown;String s_colname
long nRow

s_colname = GetColumnName()
nRow = GetRow()
if (s_colname <> "winid") then return
open(w_sys_p_009_popup)
if Isnull(gs_code) or Trim(gs_code) = "" then return
SetItem(nRow,"winid",gs_code)
SetItem(nRow,"winname",gs_codename)
end event

event dw_ip::itemchanged;constant string fld1 = "sdate", fld2 = "edate"
string snull, s_colname, s_data

SetNull(snull)
//dw_list.object.txt_date.text = ""
//dw_list.object.txt_sort.text = ""
//dw_list.ReSet()

AcceptText()
s_colname = GetColumnName()
if (s_colname <> fld1) and (s_colname <> fld2) then return 
s_data = Trim(GetItemString(1, s_colname))
if IsNUll(s_data) or s_data = "" then return 
if f_datechk(s_data) = -1 then
	f_message_chk(35,"[사용일자]")
	SetItem(1, s_colname, snull)
	return 1
end if	
return



end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;//string sCol
//
//sCol = GetColumnName()
//setnull(gs_code)
//if (scol <> 'winid') then return
//if KeyDown(KeyF2!) THEN
//	open(w_sys_p_009_popup)
//	if IsNull(gs_code) or gs_code = "" then return
//	SetItem(1,"winid",gs_code)
//	SetItem(1,"winname",gs_codename)
//end if	
//
end event

type dw_list from w_standard_print`dw_list within w_sys_p_009
integer x = 46
integer y = 192
integer width = 4530
integer height = 2108
string dataobject = "d_sys_p_0091"
boolean border = false
end type

type rb_time from radiobutton within w_sys_p_009
integer x = 3483
integer y = 68
integer width = 315
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "사용일시"
boolean checked = true
end type

type rb_user from radiobutton within w_sys_p_009
integer x = 3218
integer y = 68
integer width = 270
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "사용자"
end type

type rb_win from radiobutton within w_sys_p_009
integer x = 2903
integer y = 68
integer width = 311
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "WINDOW명"
end type

type st_1 from statictext within w_sys_p_009
integer x = 2624
integer y = 68
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "정렬순서"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sys_p_009
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 180
integer width = 4567
integer height = 2132
integer cornerheight = 40
integer cornerwidth = 55
end type

