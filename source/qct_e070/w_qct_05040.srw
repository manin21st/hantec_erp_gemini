$PBExportHeader$w_qct_05040.srw
$PBExportComments$계측기 반납 등록
forward
global type w_qct_05040 from w_inherite
end type
type gb_3 from groupbox within w_qct_05040
end type
type gb_2 from groupbox within w_qct_05040
end type
type dw_1 from datawindow within w_qct_05040
end type
type rr_1 from roundrectangle within w_qct_05040
end type
end forward

global type w_qct_05040 from w_inherite
integer x = 5
integer y = 4
string title = "계측기 반납 등록"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
rr_1 rr_1
end type
global w_qct_05040 w_qct_05040

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_required_chk ()
end prototypes

public subroutine wf_reset ();string snull

setnull(snull)

dw_insert.setredraw(false)

dw_insert.reset()

dw_insert.setredraw(true)


end subroutine

public function integer wf_required_chk ();////필수입력항목 체크
//Long i, lCount
//string sdept, sdate
//
//lCount = dw_insert.RowCount()
//
//for i = 1 to lCount
//	sdept = trim(dw_insert.object.ipemp[i])
//	sdate = trim(dw_insert.object.ipdat[i])
//	
//   if (Isnull(sdept) or sdept =  "") and sdate > '.' then	
//	   f_message_chk(1400,'[접수자]')
//	   dw_insert.SetColumn('ipemp')
//	   dw_insert.SetFocus()
//	   return -1
//	elseif (Isnull(sdate) or sdate =  "") and sdept > '.' then	
//	   f_message_chk(1400,'[접수일자]')
//	   dw_insert.SetColumn('ipdat')
//	   dw_insert.SetFocus()
//	   return -1
//   end if
//next
//
return 1
end function

on w_qct_05040.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_qct_05040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.insertrow(0)
dw_1.SetFocus()
//dw_1.setitem(1, 'fdate', left(is_today, 6) + '01')
//dw_1.setitem(1, 'tdate', is_today)
//
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_qct_05040
integer x = 82
integer y = 244
integer width = 4503
integer height = 2028
integer taborder = 30
string dataobject = "d_qct_05040_1"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String s_cod, s_nam1, s_nam2
Int    i_rtn
long   lrow

s_cod = Trim(this.GetText())
lrow  = this.getrow()

if this.getcolumnname() = "ipemp" then 
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.ipemp[lrow] = s_cod
	this.object.p1_master_empname[lrow] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "hidat" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[회수일자]")
		this.object.ipdat[lrow] = ""
		return 1
	end if
elseif this.getcolumnname() = "opt" then 
	if s_cod = 'Y' then 
	   this.object.hidat[lrow] = is_today
	else
	   this.object.hidat[lrow] = ''
	end if
End If


end event

event dw_insert::rbuttondown;//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//if this.getcolumnname() = "ipemp" then
//	open(w_sawon_popup)
//	If IsNull(gs_code) Or gs_code = '' Then Return
//	this.SetItem(this.getrow(), "ipemp", gs_code)
//	this.SetItem(this.getrow(), "p1_master_empname", gs_codename)
//	return
//end if
//
end event

type p_delrow from w_inherite`p_delrow within w_qct_05040
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_qct_05040
boolean visible = false
end type

type p_search from w_inherite`p_search within w_qct_05040
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_qct_05040
boolean visible = false
end type

type p_exit from w_inherite`p_exit within w_qct_05040
end type

type p_can from w_inherite`p_can within w_qct_05040
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_qct_05040
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_qct_05040
integer x = 3918
end type

event p_inq::clicked;call super::clicked;string sDept, sFdate, sTdate, sGub, sFilter

if dw_1.AcceptText() = -1 then return 

sDept  = trim(dw_1.GetItemString(1,'deptcd'))
sFdate = trim(dw_1.GetItemString(1,'fdate'))
sTdate = trim(dw_1.GetItemString(1,'tdate'))
sGub   = dw_1.GetItemString(1,'gubun')

if isnull(sDept) or sDept = "" then sdept = '%'
if isnull(sfdate) or sfdate = "" then sfdate = '10000101'
if isnull(stdate) or stdate = "" then stdate = '99991231'

SetPointer(HourGlass!)

dw_insert.setredraw(false)

if sgub = "1" then  //미접수
   sfilter = "isnull(hidat)"
elseif sgub = "2" then  //접수
   sfilter = "hidat > '.' "
else
   sfilter = ""
end if	

dw_insert.SetFilter(sfilter)
dw_insert.Filter()

if dw_insert.Retrieve(gs_sabu, sdept, sfdate, stdate) <= 0 then 
	dw_1.Setfocus()
   dw_insert.setredraw(true)
	return
else
	dw_insert.SetFocus()
end if	

ib_any_typing = FALSE

dw_insert.setredraw(true)

end event

type p_del from w_inherite`p_del within w_qct_05040
boolean visible = false
end type

type p_mod from w_inherite`p_mod within w_qct_05040
integer x = 4096
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return

SetPointer(HourGlass!)
	
if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
cb_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_qct_05040
integer x = 3214
integer y = 1924
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_qct_05040
integer x = 2510
integer y = 1924
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qct_05040
integer x = 539
integer y = 2472
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qct_05040
integer x = 1143
integer y = 2392
end type

type cb_inq from w_inherite`cb_inq within w_qct_05040
integer x = 82
integer y = 1924
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_qct_05040
integer x = 645
integer y = 2324
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_qct_05040
end type

type cb_can from w_inherite`cb_can within w_qct_05040
integer x = 2862
integer y = 1924
integer taborder = 50
end type

type cb_search from w_inherite`cb_search within w_qct_05040
integer x = 2619
integer y = 2532
end type





type gb_10 from w_inherite`gb_10 within w_qct_05040
integer y = 2076
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_05040
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_05040
end type

type gb_3 from groupbox within w_qct_05040
boolean visible = false
integer x = 2469
integer y = 1864
integer width = 1120
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type gb_2 from groupbox within w_qct_05040
boolean visible = false
integer x = 37
integer y = 1864
integer width = 421
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_1 from datawindow within w_qct_05040
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer y = 8
integer width = 3552
integer height = 192
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_05040_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "deptcd" then
	open(w_vndmst_4_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "deptcd", gs_code)
	this.SetItem(1, "deptnm", gs_codename)
	return
elseif this.getcolumnname() = "empno" then
	open(w_sawon_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "empno", gs_code)
	this.SetItem(1, "empnm", gs_codename)
	return
end if
end event

event itemchanged;String s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.getcolumnname() = "deptcd" then //관리부서
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
	this.object.deptcd[1] = s_cod
	this.object.deptnm[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "empno" then 
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.empno[1] = s_cod
	this.object.empnm[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "fdate" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지급일자 FROM]")
		this.object.fdate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "tdate" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지급일자 TO]")
		this.object.tdate[1] = ""
		return 1
	end if
End If


end event

type rr_1 from roundrectangle within w_qct_05040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 240
integer width = 4539
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

