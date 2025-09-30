$PBExportHeader$w_qa90_00130.srw
$PBExportComments$검교정 계획 현황
forward
global type w_qa90_00130 from w_standard_print
end type
type rr_1 from roundrectangle within w_qa90_00130
end type
end forward

global type w_qa90_00130 from w_standard_print
string title = "검교정 계획 현황"
rr_1 rr_1
end type
global w_qa90_00130 w_qa90_00130

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_yymm  ,ls_line1 , ls_line2 , ls_yongdo, ls_yymmend
String ls_dept_st , ls_dept_ft ,ls_deptnm_st , ls_deptnm_ft
String ls_line1_nm , ls_line2_nm, ls_silgu

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

ls_yymm    = Trim(dw_ip.Object.sdate[1])
ls_yymmend = Trim(dw_ip.Object.edate[1])

ls_dept_st  = Trim(dw_ip.Object.deptcode1[1])
ls_dept_ft  = Trim(dw_ip.Object.deptcode2[1])

ls_deptnm_st  = Trim(dw_ip.Object.deptname1[1])
ls_deptnm_ft  = Trim(dw_ip.Object.deptname2[1])

ls_line1  = Trim(dw_ip.Object.linecode1[1])
ls_line2  = Trim(dw_ip.Object.linecode2[1])

ls_line1_nm  = Trim(dw_ip.Object.linecode_nm1[1])
ls_line2_nm  = Trim(dw_ip.Object.linecode_nm2[1])

ls_silgu = Trim(dw_ip.Object.silgu[1])

If IsNull(ls_yymm) or ls_yymm = "" or f_datechk(ls_yymm+'01') < 1  Then 
	f_message_chk(35 , '[검사년월]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("sdate")
	Return -1
ELSEIF IsNull(ls_yymmend) or ls_yymmend = "" or f_datechk(ls_yymmend+'01') < 1  Then 
	f_message_chk(35 , '[검사년월]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("edate")
End If

If IsNull(ls_dept_st) or ls_dept_st = ""  Then ls_dept_st = '.'
If IsNull(ls_dept_ft) or ls_dept_ft = ""  Then ls_dept_ft = 'zzzzzz'
If IsNull(ls_line1) or ls_line1 = ""  Then ls_line1 = '.'
If IsNull(ls_line2) or ls_line2 = ""  Then ls_line2 = 'zzzzzz'

//if IsNull(ls_yongdo) or ls_yongdo = ""  then ls_yongdo = '%%'
if IsNull(ls_silgu) or ls_silgu = ""  then ls_silgu = '%'
	
if dw_list.Retrieve(gs_sabu, ls_yymm , ls_yymmend, ls_dept_st , ls_dept_ft , ls_line1 , ls_line2 , ls_silgu ) <= 0 then
	f_message_chk(50,"[계측기기 검교정 대상 현황]")
	dw_ip.Setfocus()
	return -1
Else
	dw_print.Object.t_lastoutdept.Text = "["+ls_dept_st+"]"+ls_deptnm_st + " - ["+ls_dept_ft+"]"+ls_deptnm_ft
	dw_print.Object.t_linecode.Text    = "["+ls_line1+"]"+ls_line1_nm + " - ["+ls_line2+"]"+ls_line2_nm

end if

Return 1
	
end function

on w_qa90_00130.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qa90_00130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Object.sdate[1] = Left(is_today , 6)
dw_ip.Object.edate[1] = Left(is_today , 6)
end event

type p_preview from w_standard_print`p_preview within w_qa90_00130
integer x = 4046
integer y = 32
integer taborder = 30
end type

type p_exit from w_standard_print`p_exit within w_qa90_00130
integer x = 4389
integer y = 32
integer taborder = 50
end type

type p_print from w_standard_print`p_print within w_qa90_00130
integer x = 4219
integer y = 32
integer taborder = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa90_00130
integer x = 3877
integer y = 32
end type



type sle_msg from w_standard_print`sle_msg within w_qa90_00130
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_qa90_00130
end type



type dw_print from w_standard_print`dw_print within w_qa90_00130
string dataobject = "d_qa90_00130_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qa90_00130
integer x = 32
integer y = 32
integer width = 2693
integer height = 232
string dataobject = "d_qa90_00130_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  ls_col , ls_cod ,ls_nam , ls_null
Setnull(ls_null)
ls_col = Lower(GetColumnName())
ls_cod = Trim(GetText())

Choose Case ls_col
	
	Case 'sdate'
		if f_datechk(ls_cod+'01') = -1 then
			f_message_chk(35, "[검사년월]")
			SetItem(1 , ls_col , ls_null)
			return 1
		end if
	Case 'deptcode1'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'deptcode1',ls_null)
			this.setitem(1,'deptname1',ls_null)
			Return 
		End If
		select deptname into :ls_nam from p0_dept
		 where deptcode = :ls_cod ;
		if sqlca.sqlcode = 0 then
			this.setitem(1,'deptname1',ls_nam)
		else
			f_message_chk(33, "[관리부서]")
			this.setitem(1,'deptcode1',ls_null)
			this.setitem(1,'deptname1',ls_null)
			return 1
		end if
	Case 'deptcode2'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'deptcode2',ls_null)
			this.setitem(1,'deptname2',ls_null)
			Return 
		End If
		select deptname into :ls_nam from p0_dept
		 where deptcode = :ls_cod ;
		if sqlca.sqlcode = 0 then
			this.setitem(1,'deptname2',ls_nam)
		else
			f_message_chk(33, "[관리부서]")
			this.setitem(1,'deptcode2',ls_null)
			this.setitem(1,'deptname2',ls_null)
			return 1
		end if
	Case 'linecode1' 
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'linecode1',ls_null)
			this.setitem(1,'linecode_nm1',ls_null)
			Return 
		End If
		select wcdsc into :ls_nam from wrkctr
	 	 where wkctr = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'linecode_nm1',ls_nam)
		else
			f_message_chk(33, "[ADDRESS]")
			this.setitem(1,'linecode1',ls_null)
			this.setitem(1,'linecode_nm1',ls_null)
			return 1
		end if
	Case 'linecode2' 
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'linecode2',ls_null)
			this.setitem(1,'linecode_nm2',ls_null)
			Return 
		End If
		select wcdsc into :ls_nam from wrkctr
	 	 where wkctr = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'linecode_nm2',ls_nam)
		else
			f_message_chk(33, "[ADDRESS]")
			this.setitem(1,'linecode2',ls_null)
			this.setitem(1,'linecode_nm2',ls_null)
			return 1
		end if

End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;String ls_col

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
ls_col = Lower(GetColumnName())

Choose Case ls_col
	Case 'deptcode1' ,'deptcode2'
		open(w_vndmst_4_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,ls_col,gs_code)
		this.triggerevent(itemchanged!)
	Case 'linecode1','linecode2'
		open(w_workplace_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)
	
End Choose

end event

type dw_list from w_standard_print`dw_list within w_qa90_00130
integer x = 55
integer y = 288
integer width = 4498
integer height = 1960
integer taborder = 10
string dataobject = "d_qa90_00130_a"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_1 from roundrectangle within w_qa90_00130
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 280
integer width = 4521
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

