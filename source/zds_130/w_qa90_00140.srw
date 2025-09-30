$PBExportHeader$w_qa90_00140.srw
$PBExportComments$검교정 결과 현황
forward
global type w_qa90_00140 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qa90_00140
end type
type pb_2 from u_pb_cal within w_qa90_00140
end type
type rr_1 from roundrectangle within w_qa90_00140
end type
end forward

global type w_qa90_00140 from w_standard_print
integer height = 2516
string title = "검교정 결과 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qa90_00140 w_qa90_00140

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_sdate  ,ls_line1 , ls_line2 , ls_kan, ls_edate
String ls_dept_st , ls_dept_ft ,ls_deptnm_st , ls_deptnm_ft
String ls_line1_nm , ls_line2_nm

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

ls_sdate 		= Trim(dw_ip.Object.sdate[1])
ls_edate  = Trim(dw_ip.Object.edate[1])

ls_dept_st  = Trim(dw_ip.Object.deptcode1[1])
ls_dept_ft  = Trim(dw_ip.Object.deptcode2[1])

ls_deptnm_st  = Trim(dw_ip.Object.deptname1[1])
ls_deptnm_ft  = Trim(dw_ip.Object.deptname2[1])

ls_line1  = Trim(dw_ip.Object.linecode1[1])
ls_line2  = Trim(dw_ip.Object.linecode2[1])

ls_line1_nm  = Trim(dw_ip.Object.linecode_nm1[1])
ls_line2_nm  = Trim(dw_ip.Object.linecode_nm2[1])

ls_kan = Trim(dw_ip.Object.sikwan[1])

If IsNull(ls_sdate) or ls_sdate = "" or f_datechk(ls_sdate) < 1  Then 
	f_message_chk(35 , '[실시일자FROM]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("sdate")
	Return -1
ELSEIf IsNull(ls_edate) or ls_edate = "" or f_datechk(ls_edate) < 1  Then 
	f_message_chk(35 , '[실시일자TO]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("edate")
	Return -1	
End If

If IsNull(ls_dept_st) or ls_dept_st = ""  Then ls_dept_st = '.'
If IsNull(ls_dept_ft) or ls_dept_ft = ""  Then ls_dept_ft = 'zzzzzz'
If IsNull(ls_line1) or ls_line1 = ""  Then ls_line1 = '.'
If IsNull(ls_line2) or ls_line2 = ""  Then ls_line2 = 'zzzzzz'

if IsNull(ls_kan) or ls_kan = ""  then ls_kan = '%%'

if dw_list.Retrieve(gs_sabu, ls_sdate ,ls_edate, ls_dept_st , ls_dept_ft , ls_line1 , ls_line2 , ls_kan ) <= 0 then
	f_message_chk(50,"[계측기기 검교정 결과 현황]")
	dw_ip.Setfocus()
	return -1
Else
	dw_print.Object.t_lastoutdept.Text = "["+ls_dept_st+"]"+ls_deptnm_st + " - ["+ls_dept_ft+"]"+ls_deptnm_ft
	dw_print.Object.t_linecode.Text    = "["+ls_line1+"]"+ls_line1_nm + " - ["+ls_line2+"]"+ls_line2_nm
end if

Return 1
	
end function

on w_qa90_00140.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_qa90_00140.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Object.sdate[1] = Left(is_today , 6) + '01'
dw_ip.Object.edate[1] = is_today
end event

type p_xls from w_standard_print`p_xls within w_qa90_00140
end type

type p_sort from w_standard_print`p_sort within w_qa90_00140
end type

type p_preview from w_standard_print`p_preview within w_qa90_00140
integer x = 4046
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_qa90_00140
integer x = 4389
integer y = 32
integer taborder = 110
end type

type p_print from w_standard_print`p_print within w_qa90_00140
integer x = 4219
integer y = 32
integer taborder = 70
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa90_00140
integer x = 3877
integer y = 32
end type



type sle_msg from w_standard_print`sle_msg within w_qa90_00140
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_qa90_00140
end type



type dw_print from w_standard_print`dw_print within w_qa90_00140
string dataobject = "d_qa90_00140_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qa90_00140
integer x = 32
integer y = 32
integer width = 2981
integer height = 228
string dataobject = "d_qa90_00140_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  ls_col , ls_cod ,ls_nam , ls_null
Setnull(ls_null)

If this.AcceptText() = -1 Then ReTurn 1

ls_col = Lower(GetColumnName())
ls_cod = Trim(GetText())

Choose Case ls_col
	
	Case 'sdate','edate'
		if f_datechk(ls_cod+'01') = -1 then
			f_message_chk(35, "[검사년월]")
			SetItem(1 , ls_col , ls_null)
			return 1
		end if
	Case 'sikwan'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'cvnas',ls_null)
			Return 
		End If
		
		select cvnas into :ls_nam 
		from vndmst
		where cvcod = :ls_cod ;
		
		if sqlca.sqlcode = 0 then
			this.setitem(1,'cvnas',ls_nam)
		else
			f_message_chk(33, "[검사장소]")
			this.setitem(1,'sikwan',ls_null)
			this.setitem(1,'cvnas',ls_null)
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
	Case 'sikwan'
		open(w_vndmst_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,ls_col,gs_code)
		this.trigger event itemchanged(GetRow(),dwo,gs_code)
	Case 'deptcode1' ,'deptcode2'
		open(w_vndmst_4_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,ls_col,gs_code)
		this.trigger event itemchanged(GetRow(),dwo,gs_code)
	Case 'linecode1','linecode2'
		open(w_workplace_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   this.trigger event itemchanged(GetRow(),dwo,gs_code)	
End Choose

end event

type dw_list from w_standard_print`dw_list within w_qa90_00140
integer x = 50
integer y = 276
integer width = 4498
integer height = 2016
string dataobject = "d_qa90_00140_a"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type pb_1 from u_pb_cal within w_qa90_00140
integer x = 722
integer y = 60
integer height = 76
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type pb_2 from u_pb_cal within w_qa90_00140
integer x = 1202
integer y = 60
integer height = 76
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type rr_1 from roundrectangle within w_qa90_00140
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 268
integer width = 4521
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

