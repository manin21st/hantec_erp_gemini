$PBExportHeader$w_pik1130.srw
$PBExportComments$** 장기근태자등록
forward
global type w_pik1130 from w_inherite_standard
end type
type dw_1 from datawindow within w_pik1130
end type
type dw_2 from u_d_select_sort within w_pik1130
end type
type dw_3 from u_d_popup_sort within w_pik1130
end type
type dw_5 from datawindow within w_pik1130
end type
type rr_1 from roundrectangle within w_pik1130
end type
type rr_2 from roundrectangle within w_pik1130
end type
end forward

global type w_pik1130 from w_inherite_standard
string title = "장기근태자등록"
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
dw_5 dw_5
rr_1 rr_1
rr_2 rr_2
end type
global w_pik1130 w_pik1130

forward prototypes
public subroutine wf_connecct ()
end prototypes

public subroutine wf_connecct ();//sqlca2 = Create Transaction
//sqlca2.dbms = 'MSS Microsoft SQL Server 6.x'
//sqlca2.database = 'DATABASE_NAME'
//sqlca2.logid = 'sa'
//sqlca2.logpass = 'PASSWORD'
//sqlca2.servername = 'SERVER_NAME'
//sqlca2.userid = ''
//sqlca2.dbpass = ''
//sqlca2.lock = ''
//
//Connect Using sqlca2;
//
//If sqlca2.sqlcode < 0 Then
// Messagebox("connect error(DB연결정보)", sqlca2.sqlerrtext)
// Halt Close 
// Return 1
//End If

end subroutine

on w_pik1130.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_5=create dw_5
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.dw_5
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_pik1130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_5)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;sle_msg.text = ''

dw_1.Settransobject(sqlca)
dw_2.Settransobject(sqlca)
dw_3.Settransobject(sqlca)
dw_5.Settransobject(sqlca)

dw_1.insertrow(0)
dw_5.insertrow(0)

f_set_saupcd(dw_5, 'saup', '1')
is_saupcd = gs_saupcd

dw_5.setitem(1,'sdate',f_today())




p_search.Triggerevent(Clicked!)

end event

event key;call super::key;IF key = KeyF! THEN
	p_mod.TriggerEvent(Clicked!)
END IF
end event

type p_mod from w_inherite_standard`p_mod within w_pik1130
integer x = 4027
string pointer = "C:\ERPMAN\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_mod::clicked;call super::clicked;string sempno, sktcode, sktname,frdate, stodate 
string ls_date, ls_daygubn, ls_hdaygubn

if dw_1.Accepttext() = -1 then return

sempno = dw_1.GetitemString(1,'empno')
sktcode = dw_1.GetitemString(1,'ktcode')
sktname = Trim(dw_1.Describe("Evaluate('LookUpDisplay(ktcode)   ',  1)"))
frdate = dw_1.GetitemString(1,'sdate')
stodate = dw_1.GetitemString(1,'edate')

IF frdate = "      " OR IsNull(frdate) THEN
	MessageBox("확 인","시작일을 입력하세요!!")
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return -1
ELSE
  IF f_datechk(frdate) = -1 THEN
	MessageBox("확인","시작일을 확인하세요")
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return -1
  END IF	
END IF 

IF stodate = "      " OR IsNull(stodate) THEN
	MessageBox("확 인","종료일을 입력하세요!!")
	dw_1.SetColumn("edate")
	dw_1.SetFocus()
	Return -1
ELSE
  IF f_datechk(stodate ) = -1 THEN
	  MessageBox("확인","종료일을 확인하세요")
	  dw_1.SetColumn("edate")
	  dw_1.SetFocus()
	  Return -1
  END IF	
END IF 
	
IF frdate > stodate THEN 
	MessageBox("확인","일자범위를 확인하세요")
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return -1
END IF	

if IsNull(sempno) or sempno = '' then
	MessageBox("확인","사원을 입력하세요!!")
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	Return -1
end if	
if IsNull(sktcode) or sktcode = '' then
	MessageBox("확인","근태구분을 입력하세요!!")
	dw_1.SetColumn("ktcode")
	dw_1.SetFocus()
	Return -1	
end if

if messagebox("확인","시작일과 종료일 사이에 기존에 생성되어 있던 자료는 삭제됩니다.~r~n" + &
							"                  생성하시겠습니까?",Question!, YesNo!) = 2 then
	return
end if

setpointer(Hourglass!)

delete from p4_predkentae
where empno = :sempno and 
      kdate between :frdate and :stodate;

if sqlca.sqlcode = 0 then
   commit;
else
	rollback;
end if

declare kt_date cursor for

select cldate, daygubn, hdaygubn
from p4_calendar
where companycode = :gs_company and
      cldate between :frdate and :stodate;
		
		
Open kt_date;

DO WHILE True
	Fetch kt_date INTO :ls_date,:ls_daygubn,:ls_hdaygubn;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	insert into p4_predkentae
	(kdate, empno, ktcode, ktcodename, daygubn, hdaygubn)
	values
	(:ls_date, :sempno, :sktcode, :sktname, :ls_daygubn, :ls_hdaygubn);
	
Loop
Close kt_date;

if sqlca.sqlcode = 0 then
   commit;	
	w_mdi_frame.sle_msg.text = '생성완료!!'
	dw_2.retrieve(sempno,frdate,stodate)
else
	rollback;
	w_mdi_frame.sle_msg.text = '생성실패!!'
end if

setpointer(Arrow!)	
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_del from w_inherite_standard`p_del within w_pik1130
integer x = 4201
end type

event p_del::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Int iRowCount, i

iRowCount = dw_2.RowCount()
IF iRowCount <=0 THEN RETURN

IF MessageBox("확 인","선택한 자료(들)를 삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN
setpointer(Hourglass!)
	FOR i = iRowCount to 1 STEP -1
		IF dw_2.IsSelected(i) THEN dw_2.DeleteRow(i)
	NEXT

IF dw_2.Update() <>  1 THEN
	MessageBox("확 인","자료 삭제를 실패하였습니다!!")
	Rollback;
setpointer(Arrow!)
	Return
END IF

COMMIT;

w_mdi_frame.sle_msg.text ='자료를 삭제하였습니다!!'
setpointer(Arrow!)

p_can.Enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"



end event

type p_inq from w_inherite_standard`p_inq within w_pik1130
integer x = 3854
end type

event p_inq::clicked;call super::clicked;string sempno, sktcode, sktname,frdate, stodate 
string ls_date, ls_daygubn, ls_hdaygubn

if dw_1.Accepttext() = -1 then return

sempno = dw_1.GetitemString(1,'empno')
sktcode = dw_1.GetitemString(1,'ktcode')
frdate = dw_1.GetitemString(1,'sdate')
stodate = dw_1.GetitemString(1,'edate')


IF frdate = "      " OR IsNull(frdate) THEN
	frdate = '10000101'
end if
IF stodate = "      " OR IsNull(stodate) THEN
	stodate = '99999999'
end if
//IF frdate = "      " OR IsNull(frdate) THEN
//	MessageBox("확 인","시작일을 입력하세요!!")
//	dw_1.SetColumn("sdate")
//	dw_1.SetFocus()
//	Return -1
//ELSE
//  IF f_datechk(frdate) = -1 THEN
//	MessageBox("확인","시작일을 확인하세요")
//	dw_1.SetColumn("sdate")
//	dw_1.SetFocus()
//	Return -1
//  END IF	
//END IF 
//
//IF stodate = "      " OR IsNull(stodate) THEN
//	MessageBox("확 인","종료일을 입력하세요!!")
//	dw_1.SetColumn("edate")
//	dw_1.SetFocus()
//	Return -1
//ELSE
//  IF f_datechk(stodate ) = -1 THEN
//	  MessageBox("확인","종료일을 확인하세요")
//	  dw_1.SetColumn("edate")
//	  dw_1.SetFocus()
//	  Return -1
//  END IF	
//END IF 
//	
//IF frdate > stodate THEN 
//	MessageBox("확인","일자범위를 확인하세요")
//	dw_1.SetColumn("sdate")
//	dw_1.SetFocus()
//	Return -1
//END IF	
//
if IsNull(sempno) or sempno = '' then
	IF dw_3.GetSelectedRow(0) > 0 THEN
		sempno = dw_3.GetItemString(dw_3.GetSelectedRow(0),"empno")
		dw_1.Setitem(1,'empno', sempno)
		dw_1.Triggerevent(ItemChanged!)
	END IF
end if	
if IsNull(sempno) or sempno = '' then	
	MessageBox("확인","사원을 입력하세요!!")
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	Return -1
end if	
if IsNull(sktcode) or sktcode = '' then sktcode = '%'

setpointer(Hourglass!)
w_mdi_frame.sle_msg.text = '조회중.........'

if dw_2.retrieve(sempno,frdate,stodate) > 0 then
	w_mdi_frame.sle_msg.text = '조회완료!!'
else
	w_mdi_frame.sle_msg.text = "조회자료가 없습니다!"
	
end if

setpointer(Arrow!)	
end event

type p_print from w_inherite_standard`p_print within w_pik1130
boolean visible = false
integer x = 2848
integer y = 2856
end type

type p_can from w_inherite_standard`p_can within w_pik1130
boolean visible = false
integer x = 4064
integer y = 2856
end type

type p_exit from w_inherite_standard`p_exit within w_pik1130
integer x = 4375
end type

type p_ins from w_inherite_standard`p_ins within w_pik1130
boolean visible = false
integer x = 3195
integer y = 2856
end type

type p_search from w_inherite_standard`p_search within w_pik1130
boolean visible = false
integer x = 3657
integer y = 32
end type

event p_search::clicked;call super::clicked;string sdate, sdept, sgrade, ssaup

if dw_5.Accepttext() = -1 then return

sdate = dw_5.getitemstring(1,'sdate')
sdept = dw_5.getitemstring(1,'deptcode')
sgrade = dw_5.getitemstring(1,'grade')
ssaup = dw_5.getitemstring(1,'saup')

if IsNull(sdate) or sdate = '' then
	messagebox("확인","퇴직일자기준을 확인하세요!")
	return
end if

if IsNull(sdept) or sdept = '' then sdept = '%'
if IsNull(sgrade) or sgrade = '' then sgrade = '%'
if IsNull(ssaup) or ssaup = '' then ssaup = '%'

if dw_3.retrieve(gs_company, sdept, sgrade,sdate,ssaup) < 1 then
	w_mdi_frame.sle_msg.text = "조회자료가 없습니다!"
	return
	dw_5.setcolumn('sdate')
	dw_5.setfocus()
end if
end event

type p_addrow from w_inherite_standard`p_addrow within w_pik1130
boolean visible = false
integer x = 3877
integer y = 2848
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1130
boolean visible = false
integer x = 3680
integer y = 2852
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1130
boolean visible = false
integer x = 27
integer y = 2244
end type

type st_window from w_inherite_standard`st_window within w_pik1130
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1130
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1130
boolean visible = false
integer x = 2491
string text = "생성(&S)"
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1130
boolean visible = false
integer x = 517
integer y = 2684
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1130
boolean visible = false
integer x = 2857
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1130
boolean visible = false
integer x = 151
integer y = 2684
end type

type st_1 from w_inherite_standard`st_1 within w_pik1130
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1130
boolean visible = false
integer x = 2519
integer y = 2480
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1130
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1130
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1130
boolean visible = false
integer x = 2446
integer width = 1143
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1130
boolean visible = false
integer x = 114
integer y = 2624
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1130
boolean visible = false
end type

type dw_1 from datawindow within w_pik1130
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1568
integer y = 68
integer width = 1819
integer height = 280
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik1130_1"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;//F1 key를 누르면 코드조회처리함	

if KeyDown(KeyF1!) then
	TriggerEvent(RbuttonDown!)
end if
end event

event itemchanged;string sempno,sempname, frdate, stodate, snull, ls_name
setnull(snull)

if this.Accepttext() = -1 then return

frdate = this.GetitemString(1,'sdate')
stodate = this.GetitemString(1,'edate')

if this.GetcolumnName() = 'empno' then
	sempno = this.Gettext()
	
	SELECT "P1_MASTER"."EMPNAME"  
	INTO :sempname  
	FROM "P1_MASTER"  
	WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
			( "P1_MASTER"."EMPNO" = :sempno ) ;
			
    IF SQLCA.SQLCODE<>0 THEN
		 MessageBox("확 인","사원번호를 확인하세요!!") 
		 this.SetITem(1,"empno",snull)
		 this.SetITem(1,"empname",snull)
		 RETURN 1 
	 END IF
		this.SetITem(1,"empname",sempname  )		
end if

IF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
	 return 1
END IF


if this.GetcolumnName() = 'sdate' then

	IF frdate = "      " OR IsNull(frdate) THEN
		MessageBox("확 인","시작일을 입력하세요!!")
		this.SetColumn("sdate")
		this.SetFocus()
		Return -1
	ELSE
	  IF f_datechk(frdate) = -1 THEN
		MessageBox("확인","시작일을 확인하세요")
		this.SetColumn("sdate")
		this.SetFocus()
		Return -1
	  END IF	
	END IF 
	
end if

if this.GetcolumnName() = 'edate' then
	
	IF stodate = "      " OR IsNull(stodate) THEN
		MessageBox("확 인","종료일을 입력하세요!!")
		this.SetColumn("edate")
		this.SetFocus()
		Return -1
	ELSE
	  IF f_datechk(stodate ) = -1 THEN
		MessageBox("확인","종료일을 확인하세요")
		this.SetColumn("edate")
		this.SetFocus()
		Return -1
	  END IF	
	END IF 
	
end if
//IF frdate > stodate THEN 
//	MessageBox("확인","기준년월범위를 확인하세요")
//	this.SetColumn("sdate")
//	this.SetFocus()
//	Return -1
//END IF	
//

p_inq.TriggerEvent(Clicked!)
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)


IF this.GetColumnName() = "empno" THEN
   Open(w_employee_popup)

   if isnull(gs_code) or gs_code = '' then return
   this.SetITem(1,"empno",gs_code)
	this.SetITem(1,"empname",gs_codename)
  
END IF	
end event

type dw_2 from u_d_select_sort within w_pik1130
integer x = 1623
integer y = 396
integer width = 2299
integer height = 1800
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pik1130_2"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;//If Row <= 0 then
//	dw_2.SelectRow(0,False)
//	b_flag =True
//ELSE
//
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
//	
//
//	
//	b_flag = False
//END IF
//
//CALL SUPER ::CLICKED

end event

event rowfocuschanged;call super::rowfocuschanged;this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)
end event

type dw_3 from u_d_popup_sort within w_pik1130
integer x = 178
integer y = 396
integer width = 1385
integer height = 1792
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pik1130_3"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;If Row <= 0 then
	dw_3.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_1.Setitem(1,'empno',this.GetitemString(row,'empno'))
	dw_1.Setitem(1,'empname',this.GetitemString(row,'empname'))
	p_inq.TriggerEvent(Clicked!)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

type dw_5 from datawindow within w_pik1130
event ue_key pbm_dwnprocessenter
event ue_enter pbm_dwnprocessenter
integer x = 105
integer y = 8
integer width = 1298
integer height = 376
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik1130_4"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event ue_key;//F1 key를 누르면 코드조회처리함	

if KeyDown(KeyF1!) then
	TriggerEvent(RbuttonDown!)
end if
end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string sdate, sdept, sgrade, snull, sdeptnm
setnull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if this.GetColumnName() = 'sdate' then
	sdate = this.gettext()
	if f_datechk(sdate) = -1 then
		messagebox("확인","일자를 확인하십시요!")
		dw_5.setitem(1,'sdate',snull)
		dw_5.setcolumn('sdate')
		dw_5.setfocus()		
		return
	end if
	p_search.Triggerevent(Clicked!)
elseif this.GetColumnName() = 'deptcode' then
	    sdept = this.Gettext()
	select deptname into :sdeptnm
	from p0_dept
	where deptcode = :sdept;
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'deptname', sdeptnm)
	else
		messagebox("확인","없는 코드입니다")
		this.setitem(1,'deptcode',snull)
		this.setitem(1,'deptname',snull)
		return 1
	end if
	p_search.Triggerevent(Clicked!)
elseif this.GetColumnName() = 'grade' then
	p_search.Triggerevent(Clicked!)
elseif this.GetColumnName() = 'saup' then
	p_search.Triggerevent(Clicked!)	
end if
end event

event itemerror;return 1
end event

event rbuttondown;IF this.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
   SetNull(Gs_gubun)

   Gs_gubun = is_saupcd
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	this.SetITem(1,"deptcode",gs_code)
	this.SetITem(1,"deptname",gs_codename)
	
	p_search.Triggerevent(Clicked!)
	
END IF	
end event

type rr_1 from roundrectangle within w_pik1130
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1609
integer y = 392
integer width = 2327
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pik1130
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 169
integer y = 392
integer width = 1413
integer height = 1800
integer cornerheight = 40
integer cornerwidth = 55
end type

