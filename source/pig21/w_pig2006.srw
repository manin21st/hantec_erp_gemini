$PBExportHeader$w_pig2006.srw
$PBExportComments$교육훈련계획조회
forward
global type w_pig2006 from w_inherite_standard
end type
type dw_1 from datawindow within w_pig2006
end type
type dw_emp from datawindow within w_pig2006
end type
type rr_2 from roundrectangle within w_pig2006
end type
type rr_1 from roundrectangle within w_pig2006
end type
end forward

global type w_pig2006 from w_inherite_standard
string title = "교육훈련계획조회"
dw_1 dw_1
dw_emp dw_emp
rr_2 rr_2
rr_1 rr_1
end type
global w_pig2006 w_pig2006

on w_pig2006.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_emp=create dw_emp
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_emp
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_pig2006.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_emp)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_emp.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

dw_emp.reset()
dw_emp.insertrow(0)

dw_emp.setItem(1, 'startdate', string(today(), 'YYYYMM') + '01' + '01')
dw_emp.setItem(1, 'enddate', string(today(), 'YYYYMMDD'))

dw_emp.setfocus()
dw_emp.setcolumn('startdate')


end event

type p_mod from w_inherite_standard`p_mod within w_pig2006
integer x = 4005
integer y = 3928
end type

type p_del from w_inherite_standard`p_del within w_pig2006
integer x = 4178
integer y = 3928
end type

type p_inq from w_inherite_standard`p_inq within w_pig2006
integer x = 4069
end type

event p_inq::clicked;call super::clicked;string ls_code, ls_empno, ls_sdate, ls_edate

if dw_emp.AcceptText() = -1 then return

ls_code =gs_company

ls_sdate = dw_emp.GetItemString(1, 'startdate')
ls_edate = dw_emp.GetItemString(1, 'enddate')
ls_empno = dw_emp.GetItemString(1, 'empno')

if isnull(ls_empno) or trim(ls_empno) = '' then 
	ls_empno = ''
end if

if isnull(trim(ls_sdate)) or trim(ls_sdate)="" then
	  f_message_chk(30, '[시작일자]')	
	  dw_emp.setfocus()
	  dw_emp.setcolumn('startdate')
     return
end if

if isnull(trim(ls_sdate)) or trim(ls_sdate)="" then
	  f_message_chk(30, '[종료일자]')	
	  dw_emp.setfocus()
	  dw_emp.setcolumn('enddate')
     return
end if

if  ls_sdate > ls_edate then
    MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
	                   "클 수는 없습니다.!!", stopsign!)
	  dw_emp.setfocus()
	  dw_emp.setcolumn('startdate')
	 return
end if



dw_1.setredraw(false)
if dw_1.retrieve(ls_code, ls_empno + '%', ls_sdate, ls_edate) <= 0 then
	MessageBox("확인", "조회한 자료가 없습니다.")
	dw_1.reset()
   dw_1.setredraw(true)		
	dw_emp.setcolumn('startdate')	
	dw_emp.setfocus()
	return
end if

dw_1.setredraw(true)
dw_1.setfocus()

end event

type p_print from w_inherite_standard`p_print within w_pig2006
integer x = 3794
integer y = 4048
end type

type p_can from w_inherite_standard`p_can within w_pig2006
integer x = 4242
end type

event p_can::clicked;call super::clicked;dw_emp.setredraw(false)
dw_1.SetRedraw(false)

dw_emp.reset()
dw_emp.insertrow(0)

dw_1.reset()

dw_emp.setItem(1, 'startdate', string(today(), 'YYYYMM') + '01' + '01')
dw_emp.setItem(1, 'enddate', string(today(), 'YYYYMMDD'))

dw_emp.setfocus()
dw_emp.setcolumn('startdate')

dw_emp.SetRedraw(true)
dw_1.SetRedraw(true)

end event

type p_exit from w_inherite_standard`p_exit within w_pig2006
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pig2006
integer x = 3831
integer y = 3928
end type

type p_search from w_inherite_standard`p_search within w_pig2006
integer x = 3621
integer y = 4048
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig2006
boolean visible = false
integer x = 4073
integer y = 3096
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig2006
boolean visible = false
integer x = 4247
integer y = 3096
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig2006
integer x = 1554
integer y = 4168
end type

type st_window from w_inherite_standard`st_window within w_pig2006
integer x = 2203
integer y = 4096
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig2006
integer x = 3200
integer y = 3924
end type

type cb_update from w_inherite_standard`cb_update within w_pig2006
boolean visible = false
integer x = 2098
integer y = 3924
integer taborder = 70
boolean enabled = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pig2006
boolean visible = false
integer x = 457
integer y = 3924
integer taborder = 30
boolean enabled = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig2006
boolean visible = false
integer x = 2862
integer y = 3912
integer taborder = 80
boolean enabled = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig2006
integer x = 1225
integer y = 3912
integer width = 370
integer taborder = 40
end type

event cb_retrieve::clicked;call super::clicked;string ls_code, ls_empno, ls_sdate, ls_edate

if dw_emp.AcceptText() = -1 then return

ls_code =gs_company

ls_sdate = dw_emp.GetItemString(1, 'startdate')
ls_edate = dw_emp.GetItemString(1, 'enddate')
ls_empno = dw_emp.GetItemString(1, 'empno')

if isnull(ls_empno) or trim(ls_empno) = '' then 
	ls_empno = ''
end if

if isnull(trim(ls_sdate)) or trim(ls_sdate)="" then
	  f_message_chk(30, '[시작일자]')	
	  dw_emp.setfocus()
	  dw_emp.setcolumn('startdate')
     return
end if

if isnull(trim(ls_sdate)) or trim(ls_sdate)="" then
	  f_message_chk(30, '[종료일자]')	
	  dw_emp.setfocus()
	  dw_emp.setcolumn('enddate')
     return
end if

if  ls_sdate > ls_edate then
    MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
	                   "클 수는 없습니다.!!", stopsign!)
	  dw_emp.setfocus()
	  dw_emp.setcolumn('startdate')
	 return
end if



dw_1.setredraw(false)
if dw_1.retrieve(ls_code, ls_empno + '%', ls_sdate, ls_edate) <= 0 then
	MessageBox("확인", "조회한 자료가 없습니다.")
	dw_1.reset()
   dw_1.setredraw(true)		
	dw_emp.setcolumn('startdate')	
	dw_emp.setfocus()
	return
end if

dw_1.setredraw(true)
dw_1.setfocus()

end event

type st_1 from w_inherite_standard`st_1 within w_pig2006
integer x = 37
integer y = 4096
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig2006
integer x = 3104
integer y = 3828
integer taborder = 50
end type

event cb_cancel::clicked;call super::clicked;
dw_emp.setredraw(false)
dw_1.SetRedraw(false)

dw_emp.reset()
dw_emp.insertrow(0)

dw_1.reset()

dw_emp.setItem(1, 'startdate', string(today(), 'YYYYMM') + '01' + '01')
dw_emp.setItem(1, 'enddate', string(today(), 'YYYYMMDD'))

dw_emp.setfocus()
dw_emp.setcolumn('startdate')

dw_emp.SetRedraw(true)
dw_1.SetRedraw(true)

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pig2006
integer x = 2848
integer y = 4096
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig2006
integer x = 366
integer y = 4096
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig2006
integer x = 2455
integer y = 3864
integer width = 1152
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig2006
boolean visible = false
integer x = 55
integer y = 3864
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig2006
integer x = 18
integer y = 4044
end type

type dw_1 from datawindow within w_pig2006
event ue_key pbm_dwnkey
integer x = 434
integer y = 240
integer width = 3717
integer height = 2028
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pig2006"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;choose case key
	case keypageup!
		this.scrollpriorpage()
	case keypagedown!
		this.scrollnextpage()
	case keyhome!
		this.scrolltorow(1)
	case keyend!
		this.scrolltorow(this.rowcount())
end choose
end event

type dw_emp from datawindow within w_pig2006
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 453
integer y = 64
integer width = 2363
integer height = 96
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig2006_1"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;Send(Handle(this),256,9,0)

Return 1


end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string ls_startdate, ls_enddate, sempno, &
       ls_empno, get_empno, snull

SetNull(snull)

IF this.GetcolumnName() ="startdate"THEN
	IF IsNull(data) OR data ="" THEN Return 1
		If f_datechk(data) = -1 Then
			MessageBox("확 인", "유효한 일자가 아닙니다.")
			Return 1
		end if
	ls_startdate = data
	ls_enddate = this.GetItemString(1, 'enddate')
		
	if  ls_startdate > ls_enddate then
       MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
			                 "클 수는 없습니다.!!", stopsign!)
	 	return 1
	end if
END IF

IF this.GetcolumnName() = "enddate"THEN
   IF IsNull(data) OR data ="" THEN Return 1
	If f_datechk(data) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	end if
		
	ls_startdate = this.GetItemstring(1, 'startdate')
	ls_enddate = data		
		
	if  ls_startdate > ls_enddate then
       MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
			                 "클 수는 없습니다.!!", stopsign!)
	 	return 1
	end if
end if

if this.GetcolumnName() = 'empno' then 
	ls_empno = this.GetText()
	
	if isnull(ls_empno) or trim(ls_empno) = '' then return 
	
 	IF IsNull(wf_exiting_data(this.GetColumnName(),ls_empno,"1")) THEN	
  	   MessageBox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다.!!")
     	Return 1
   end if
	
	SELECT "P1_MASTER"."EMPNO" 
		 INTO :get_empno 
		 FROM "P1_MASTER"  
		WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
				( "P1_MASTER"."EMPNO" = :ls_empno )   ;	
	if sqlca.sqlcode = 0 then 
		this.SetItem(1, 'empno', get_empno)	
    end if	
	if sqlca.sqlcode <> 0 then 
		this.SetItem(1, 'empno', snull)	
		return 1
    end if	
	p_inq.TriggerEvent(clicked!)	 
end if
end event

event rbuttondown;setnull(gs_code)

if This.GetColumnName() = 'empno' then 
	
	open(w_employee_popup)

   if isnull(gs_code) or trim(gs_code) = '' then return

   this.setItem(1, 'empno', gs_code)

   p_inq.TriggerEvent(clicked!)
	
end if
end event

event itemerror;return 1

end event

type rr_2 from roundrectangle within w_pig2006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 416
integer y = 228
integer width = 3753
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pig2006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 416
integer y = 28
integer width = 2441
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

