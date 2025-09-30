$PBExportHeader$w_imt_04775.srw
$PBExportComments$금형/치공구 접수등록
forward
global type w_imt_04775 from w_inherite
end type
type gb_3 from groupbox within w_imt_04775
end type
type gb_2 from groupbox within w_imt_04775
end type
type dw_1 from datawindow within w_imt_04775
end type
end forward

global type w_imt_04775 from w_inherite
boolean TitleBar=true
string Title="금형/ 치공구 접수 등록"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
end type
global w_imt_04775 w_imt_04775

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

public function integer wf_required_chk ();//필수입력항목 체크
Long i, lCount
string sdept, sdate

lCount = dw_insert.RowCount()

for i = 1 to lCount
	sdept = trim(dw_insert.object.ipemp[i])
	sdate = trim(dw_insert.object.ipdat[i])
	
   if (Isnull(sdept) or sdept =  "") and sdate > '.' then	
	   f_message_chk(1400,'[접수자]')
	   dw_insert.SetColumn('ipemp')
	   dw_insert.SetFocus()
	   return -1
	elseif (Isnull(sdate) or sdate =  "") and sdept > '.' then	
	   f_message_chk(1400,'[접수일자]')
	   dw_insert.SetColumn('ipdat')
	   dw_insert.SetFocus()
	   return -1
   end if
next

return 1
end function

on w_imt_04775.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
end on

on w_imt_04775.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
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

type dw_insert from w_inherite`dw_insert within w_imt_04775
int X=41
int Y=272
int Width=3543
int Height=1596
int TabOrder=30
string DataObject="d_imt_04775_1"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
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
elseif this.getcolumnname() = "ipdat" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[접수일자]")
		this.object.ipdat[lrow] = ""
		return 1
	end if
elseif this.getcolumnname() = "opt" then 
	if s_cod = 'Y' then 
		this.object.ipemp[lrow] = dw_1.getitemstring(1, 'empno')
	   this.object.p1_master_empname[lrow] = dw_1.getitemstring(1, 'empnm')
	   this.object.ipdat[lrow] = this.getitemstring(lrow, 'jidat')
	else
		this.object.ipemp[lrow] = ''
	   this.object.p1_master_empname[lrow] = ''
	   this.object.ipdat[lrow] = ''
	end if
End If


end event

event dw_insert::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "ipemp" then
	open(w_sawon_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(this.getrow(), "ipemp", gs_code)
	this.SetItem(this.getrow(), "p1_master_empname", gs_codename)
	return
end if

end event

type cb_exit from w_inherite`cb_exit within w_imt_04775
int X=3214
int Y=1924
int TabOrder=60
end type

type cb_mod from w_inherite`cb_mod within w_imt_04775
int X=2510
int Y=1924
int TabOrder=40
end type

event cb_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return

SetPointer(HourGlass!)
	
if dw_insert.update() = 1 then
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
cb_inq.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_imt_04775
int X=539
int Y=2472
int TabOrder=0
boolean Visible=false
string Text="추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_imt_04775
int X=1143
int Y=2392
int TabOrder=0
boolean Visible=false
end type

type cb_inq from w_inherite`cb_inq within w_imt_04775
int X=82
int Y=1924
int TabOrder=20
end type

event cb_inq::clicked;call super::clicked;string sDept, sFdate, sTdate, sGub, sFilter

if dw_1.AcceptText() = -1 then return 

sDept  = trim(dw_1.GetItemString(1,'deptcd'))
sFdate = trim(dw_1.GetItemString(1,'fdate'))
sTdate = trim(dw_1.GetItemString(1,'tdate'))
sGub   = dw_1.GetItemString(1,'gubun')

if isnull(sDept) or sDept = "" then
	f_message_chk(30, '[접수부서]')
	dw_1.SetColumn('deptcd')
	dw_1.SetFocus()
	return
end if	
if isnull(sfdate) or sfdate = "" then sfdate = '10000101'
if isnull(stdate) or stdate = "" then stdate = '99991231'

SetPointer(HourGlass!)

dw_insert.setredraw(false)

if sgub = "1" then  //미접수
   sfilter = "isnull(ipdat)"
elseif sgub = "2" then  //접수
   sfilter = "ipdat > '.' "
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

type cb_print from w_inherite`cb_print within w_imt_04775
int X=645
int Y=2324
int TabOrder=0
boolean Visible=false
boolean Enabled=false
end type

type cb_can from w_inherite`cb_can within w_imt_04775
int X=2862
int Y=1924
int TabOrder=50
end type

event cb_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type cb_search from w_inherite`cb_search within w_imt_04775
int X=2619
int Y=2532
int TabOrder=0
boolean Visible=false
end type

type gb_10 from w_inherite`gb_10 within w_imt_04775
int X=5
int Y=2076
int Height=144
int TextSize=-9
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_3 from groupbox within w_imt_04775
int X=2469
int Y=1864
int Width=1120
int Height=204
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_2 from groupbox within w_imt_04775
int X=37
int Y=1864
int Width=421
int Height=204
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_1 from datawindow within w_imt_04775
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
int X=37
int Y=8
int Width=3557
int Height=252
int TabOrder=10
boolean BringToTop=true
string DataObject="d_imt_04775_a"
boolean Border=false
boolean LiveScroll=true
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

