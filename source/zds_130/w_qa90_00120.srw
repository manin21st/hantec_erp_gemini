$PBExportHeader$w_qa90_00120.srw
$PBExportComments$계측기기 일람표
forward
global type w_qa90_00120 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qa90_00120
end type
type pb_2 from u_pb_cal within w_qa90_00120
end type
type pb_3 from u_pb_cal within w_qa90_00120
end type
type pb_4 from u_pb_cal within w_qa90_00120
end type
type rr_1 from roundrectangle within w_qa90_00120
end type
end forward

global type w_qa90_00120 from w_standard_print
string title = "계측기기 일람표"
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_1 rr_1
end type
global w_qa90_00120 w_qa90_00120

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_group1 , ls_group2 , ls_sdate , ls_edate 
String ls_dept_st , ls_dept_ft , ls_deptnm_st , ls_deptnm_ft
String ls_empno1 , ls_empno2 
String ls_line1 , ls_line2 , ls_line1_nm , ls_line2_nm 
STring ls_yongdo
String ls_outdt_st , ls_outdt_ft

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	
ls_group1  = Trim(dw_ip.Object.group1[1])
ls_group2  = Trim(dw_ip.Object.group2[1])

ls_sdate   = Trim(dw_ip.Object.sgudate[1])
ls_edate   = Trim(dw_ip.Object.egudate[1])

//ls_outdt_st   = Trim(dw_ip.Object.lastoutdate_st[1])
//ls_outdt_ft   = Trim(dw_ip.Object.lastoutdate_ft[1])

ls_dept_st = Trim(dw_ip.Object.deptcode1[1])
ls_dept_ft = Trim(dw_ip.Object.deptcode2[1])
ls_deptnm_st = Trim(dw_ip.Object.deptname1[1])
ls_deptnm_ft = Trim(dw_ip.Object.deptname2[1])

//ls_empno1 = Trim(dw_ip.Object.empno1[1])
//ls_empno2 = Trim(dw_ip.Object.empno2[1])

ls_line1  = Trim(dw_ip.Object.linecode1[1])
ls_line2  = Trim(dw_ip.Object.linecode2[1])

ls_line1_nm  = Trim(dw_ip.Object.linecode_nm1[1])
ls_line2_nm  = Trim(dw_ip.Object.linecode_nm2[1])

//ls_yongdo = Trim(dw_ip.Object.yongdo[1])


If IsNull(ls_group1) or ls_group1 = ""  Then ls_group1 = '.'
If IsNull(ls_group2) or ls_group2 = ""  Then ls_group2 = 'zzzzzz'
If IsNull(ls_sdate) or ls_sdate = "" Then ls_sdate = '10000101'
If IsNull(ls_edate) or ls_edate = "" Then ls_edate = '99991231'
//If IsNull(ls_outdt_st) or ls_outdt_st = "" Then ls_outdt_st = '10000101'
//If IsNull(ls_outdt_ft) or ls_outdt_ft = "" Then ls_outdt_ft = '99991231'

If IsNull(ls_dept_st) or ls_dept_st = ""  Then ls_dept_st = '.'
If IsNull(ls_dept_ft) or ls_dept_ft = ""  Then ls_dept_ft = 'zzzzzz'

//If IsNull(ls_empno1) or ls_empno1 = ""  Then ls_empno1 = '.'
//If IsNull(ls_empno2) or ls_empno2 = ""  Then ls_empno2 = 'zzzzzz'

If IsNull(ls_line1) or ls_line1 = ""  Then ls_line1 = '.'
If IsNull(ls_line2) or ls_line2 = ""  Then ls_line2 = 'zzzzzz'

//if IsNull(ls_yongdo) or ls_yongdo = ""  then ls_yongdo = '%'

//if dw_list.Retrieve(gs_sabu ,ls_group1 , ls_group2 ,  &
//                             ls_sdate , ls_edate ,    &
//									  ls_outdt_st , ls_outdt_ft ,    &
//									  ls_dept_st , ls_dept_ft, &
//                             ls_empno1 , ls_empno2 ,  &
//									  ls_line1 , ls_line2 ,    &
//									  ls_yongdo               ) <= 0 then
if dw_list.Retrieve(gs_sabu ,ls_group1 , ls_group2 ,  &
                             ls_sdate , ls_edate ,    &
									  ls_dept_st , ls_dept_ft, &
									  ls_line1 , ls_line2 ) <= 0 then
	f_message_chk(50,"[계측기 일람표]")
	dw_ip.Setfocus()
	return -1
Else
	dw_print.Object.t_lastoutdept.Text = "["+ls_dept_st+"]"+ls_deptnm_st + " - ["+ls_dept_ft+"]"+ls_deptnm_ft
	dw_print.Object.t_linecode.Text    = "["+ls_line1+"]"+ls_line1_nm + " - ["+ls_line2+"]"+ls_line2_nm

end if

Return 1
	
end function

on w_qa90_00120.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.pb_4
this.Control[iCurrent+5]=this.rr_1
end on

on w_qa90_00120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_1)
end on

event open;call super::open;//dw_ip.Object.sgudate[1] = '19000101'
//dw_ip.Object.egudate[1] = is_today
//
//dw_ip.Object.lastoutdate_st[1] = '19000101'
//dw_ip.Object.lastoutdate_ft[1] = is_today
end event

type p_xls from w_standard_print`p_xls within w_qa90_00120
end type

type p_preview from w_standard_print`p_preview within w_qa90_00120
integer x = 4046
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_qa90_00120
integer x = 4389
integer y = 32
integer taborder = 110
end type

type p_print from w_standard_print`p_print within w_qa90_00120
integer x = 4219
integer y = 32
integer taborder = 70
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa90_00120
integer x = 3877
integer y = 32
end type



type sle_msg from w_standard_print`sle_msg within w_qa90_00120
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_qa90_00120
end type



type dw_print from w_standard_print`dw_print within w_qa90_00120
string dataobject = "d_qa90_00120_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qa90_00120
integer x = 32
integer y = 32
integer width = 3246
integer height = 328
string dataobject = "d_qa90_00120_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  ls_col , ls_cod ,ls_nam , ls_null
long		ljugi
string	scode, sname, snull, splace, sspec, sjung

Setnull(ls_null)
ls_col = Lower(GetColumnName())
ls_cod = Trim(GetText())

Choose Case ls_col
	Case 'group1' 
		If ls_cod = '' Or isNull(ls_cod) Then
			SetItem(1 , "group1" , ls_null)
			SetItem(1 , "group_nm1" , ls_null)
			Return 
		End If
		select grname into :ls_nam
		 from lw_mesgrp
		 where sabu = :gs_sabu and grgrco = :ls_cod ;
		If SQLCA.SQLCODE = 0 Then 
			SetItem(1 , "group_nm1" , ls_nam)
		Else
			f_message_chk(33 , "[계측기기 그룹코드 ]")
			SetItem(1 , "group1" , ls_null)
			SetItem(1 , "group_nm1" , ls_null)
			Return 1
		End If
	Case  'group2'
		If ls_cod = '' Or isNull(ls_cod) Then
			SetItem(1 , "group2" , ls_null)
			SetItem(1 , "group_nm2" , ls_null)
			Return 
		End If
		select grname into :ls_nam
		 from lw_mesgrp
		 where sabu = :gs_sabu and grgrco = :ls_cod ;
		If SQLCA.SQLCODE = 0 Then 
			SetItem(1 , "group_nm2" , ls_nam)
		Else
			f_message_chk(33 , "[계측기기 그룹코드 ]")
			SetItem(1 , "group2" , ls_null)
			SetItem(1 , "group_nm2" , ls_null)
			Return 1
		End If
//	Case 'sgudate' , 'egudate'
//		if f_datechk(ls_cod) = -1 then
//			f_message_chk(35, "[구입일자]")
//			SetItem(1 , ls_col , ls_null)
//			return 1
//		end if
//	Case 'lastoutdate_st' , 'lastoutdate_ft'
//		if f_datechk(ls_cod) = -1 then
//			f_message_chk(35, "[최종변경일자]")
//			SetItem(1 , ls_col , ls_null)
//			return 1
//		end if
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
	Case 'empno1'
//		If ls_cod = '' Or isNull(ls_cod) Then
//			this.setitem(1,'empno1',ls_null)
//			this.setitem(1,'empnm1',ls_null)
//			Return 
//		End If
//		select empname into :ls_nam	from p1_master
//		 where empno = :ls_cod ;
//		if sqlca.sqlcode = 0 then
//			this.setitem(1,'empnm1',ls_nam)
//		else
//			f_message_chk(33, "[불출사원(관리사원)]")
//			this.setitem(1,'empno1',ls_null)
//			this.setitem(1,'empnm1',ls_null)
//			return 1
//		end if
//	Case 'empno2'
//		If ls_cod = '' Or isNull(ls_cod) Then
//			this.setitem(1,'empno2',ls_null)
//			this.setitem(1,'empnm2',ls_null)
//			Return 
//		End If
//		select empname into :ls_nam	from p1_master
//		 where empno = :ls_cod ;
//		if sqlca.sqlcode = 0 then
//			this.setitem(1,'empnm2',ls_nam)
//		else
//			f_message_chk(33, "[불출사원(관리사원)]")
//			this.setitem(1,'empno2',ls_null)
//			this.setitem(1,'empnm2',ls_null)
//			return 1
//		end if
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
	Case 'group1' ,'group2'
		open(w_st22_00010_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,ls_col,gs_code)
		this.triggerevent(itemchanged!)
		
	Case 'deptcode1' ,'deptcode2'
		open(w_vndmst_4_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,ls_col,gs_code)
		this.triggerevent(itemchanged!)

//	Case 'empno1' , 'empno2'
//		Open(w_sawon_popup)
//		If isNull(gs_code) Or gs_code='' Then Return
//		This.setitem(1,ls_col,gs_code)
//		This.TriggerEvent("itemchanged")
	
	Case 'linecode1','linecode2'
		open(w_workplace_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)
	
End Choose

end event

type dw_list from w_standard_print`dw_list within w_qa90_00120
integer x = 55
integer y = 380
integer width = 4498
integer height = 1804
string dataobject = "d_qa90_00120_a"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type pb_1 from u_pb_cal within w_qa90_00120
integer x = 795
integer y = 140
integer height = 76
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sgudate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sgudate', gs_code)

end event

type pb_2 from u_pb_cal within w_qa90_00120
integer x = 1234
integer y = 140
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('egudate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'egudate', gs_code)

end event

type pb_3 from u_pb_cal within w_qa90_00120
boolean visible = false
integer x = 2226
integer y = 140
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('lastoutdate_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'lastoutdate_st', gs_code)

end event

type pb_4 from u_pb_cal within w_qa90_00120
boolean visible = false
integer x = 2670
integer y = 140
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('lastoutdate_ft')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'lastoutdate_ft', gs_code)

end event

type rr_1 from roundrectangle within w_qa90_00120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 372
integer width = 4521
integer height = 1828
integer cornerheight = 40
integer cornerwidth = 55
end type

