$PBExportHeader$w_pip5022_year.srw
$PBExportComments$퇴직금 근무년수 수정
forward
global type w_pip5022_year from w_inherite_popup
end type
type dw_sawon from datawindow within w_pip5022_year
end type
type rr_3 from roundrectangle within w_pip5022_year
end type
type rr_1 from roundrectangle within w_pip5022_year
end type
end forward

global type w_pip5022_year from w_inherite_popup
integer x = 626
integer y = 12
integer width = 3301
integer height = 1072
string title = "퇴직금 근무년수 수정"
boolean controlmenu = true
dw_sawon dw_sawon
rr_3 rr_3
rr_1 rr_1
end type
global w_pip5022_year w_pip5022_year

type variables
String sgubn 
int ls_seq
end variables

forward prototypes
public subroutine wf_retrieve (string sempno)
end prototypes

public subroutine wf_retrieve (string sempno);
dw_1.Retrieve(sempno)

end subroutine

event open;call super::open;string  sempno, sFromDt, sToDt, sEnterDate, sBeforeDate,sTempDate, sBeforeGbn
Double  dBeforeAmt
Integer iMonthWork, iYearWork, iYears, iMonths, iDays, iTempYear, iTempMonth, iTempDay, iCworkYear, iDworkYear

muiltstr l_str_parms 
l_str_parms = Message.PowerObjectParm

sempno  = l_str_parms.s[1]
sFromDt = l_str_parms.s[2]
sToDt   = l_str_parms.s[3]

dw_sawon.SetTransObject(Sqlca)
dw_sawon.Retrieve(gs_company, sEmpno)
dw_sawon.SetItem(1,"fromdt",  sFromDt)
dw_sawon.SetItem(1,"todt",    sToDt)

dw_sawon.SetItem(1,"beforegbn", l_str_parms.s[4])
dw_sawon.SetItem(1,"beforedt", l_str_parms.s[5])
dw_sawon.SetItem(1,"beforeamt", l_str_parms.dc[1])	

dw_sawon.SetItem(1,"years", l_str_parms.dc[2])	
dw_sawon.SetItem(1,"months", l_str_parms.dc[3])	
dw_sawon.SetItem(1,"days", l_str_parms.dc[4])	
	
sEnterDate  = dw_sawon.GetItemString(1,"enterdate") 
sBeforeGbn  = dw_sawon.GetItemString(1,"beforegbn") 
sBeforeDate = dw_sawon.GetItemString(1,"beforedt") 
dBeforeAmt  = dw_sawon.GetItemNumber(1,"beforeamt") 
iYears      = dw_sawon.GetItemNumber(1,"years") 
iMonths     = dw_sawon.GetItemNumber(1,"months") 
iDays       = dw_sawon.GetItemNumber(1,"days") 
if IsNull(dBeforeAmt) then dBeforeAmt = 0
if IsNull(iYears) then iYears = 0
if IsNull(iMonths) then iMonths = 0
if IsNull(iDays) then iDays = 0
if iDays > 0 then iDays = 1

if dw_1.Retrieve(sEmpNo, sFromDt, sToDt ) <=0 then
	dw_1.InsertRow(0)
	
	dw_1.SetItem(1,"empno", sEmpNo)
	dw_1.SetItem(1,"fromdate", sFromDt)
	dw_1.SetItem(1,"todate", sToDt)
	
	//중간지급
	if dBeforeAmt <> 0 then
		dw_1.SetItem(1,"a_enterday", sEnterDate)	
		dw_1.SetItem(1,"a_fromday",  sBeforeDate)	
		
		select TO_CHAR(TO_DATE(:sFromDt) - 1,'YYYYMMDD')  into :sTempDate from dual ;			
		dw_1.SetItem(1,"a_today",  sTempDate)	
		
		select ceil(months_between( to_date(:sTempDate,'yyyymmdd'), to_date(NVL(GROUPENTERDATE, ENTERDATE),'yyyymmdd') )) ,
				 to_number(hr_fun_term_calc2(NVL(GROUPENTERDATE, ENTERDATE), :sTempDate, '1'))
             + DECODE(to_number(hr_fun_term_calc2(NVL(GROUPENTERDATE, ENTERDATE), :sTempDate, '2')), 0,0,1)
			into :iMonthWork, :iYearWork
			from p1_master
			where empno = :sEmpNo ;
		dw_1.SetItem(1,"a_workmon",  iMonthWork)	
		dw_1.SetItem(1,"a_workyear", iYearWork)	
	end if
	
	//최종분
	dw_1.SetItem(1,"b_enterday", sEnterDate)	
	dw_1.SetItem(1,"b_fromday",  sFromDt)	
	dw_1.SetItem(1,"b_today",    sToDt)	
	dw_1.SetItem(1,"b_workmon",  ( iYears * 12 ) + iMonths + iDays )	
	if iMonths > 0 or iDays > 0 then
		dw_1.SetItem(1,"b_workyear", iYears + 1 )	
	else
		dw_1.SetItem(1,"b_workyear", iYears)		
	end if
	
	//정산분
	dw_1.SetItem(1,"c_enterday", sEnterDate)
	
	if sBeforeGbn = 'Y' then
		dw_1.SetItem(1,"c_fromday",  sEnterDate)		
	else
		dw_1.SetItem(1,"c_fromday",  sFromDt)			
	end if
	dw_1.SetItem(1,"c_today",    sToDt)	
	
	select nvl(to_number(hr_fun_term_calc2(DECODE(:sBeforeGbn,'Y', NVL(GROUPENTERDATE, ENTERDATE),:sFromDt), :sToDt, '1')), 0),
			 nvl(to_number(hr_fun_term_calc2(DECODE(:sBeforeGbn,'Y', NVL(GROUPENTERDATE, ENTERDATE),:sFromDt), :sToDt, '2')), 0),
			 nvl(to_number(hr_fun_term_calc2(DECODE(:sBeforeGbn,'Y', NVL(GROUPENTERDATE, ENTERDATE),:sFromDt), :sToDt, '3')), 0)
		into :iTempYear, :iTempMonth, :iTempDay
		from p1_master
		where empno = :sEmpNo ;
	if IsNull(iTempYear) then iTempYear = 0
	if IsNull(iTempMonth) then iTempMonth = 0
	if IsNull(iTempDay) then iTempDay = 0
	if iTempDay > 0 then iTempDay = 1
	dw_1.SetItem(1,"c_workmon",  ( iTempYear * 12 ) + iTempMonth + iTempDay )	
	
	if iTempMonth > 0 or iTempDay > 0 then
		iCworkYear = iTempYear + 1		
	else
		iCworkYear = iTempYear
	end if
	dw_1.SetItem(1,"c_workyear", iCworkYear )
	
	//2012년까지
	if sBeforeGbn = 'Y' then 
		dw_1.SetItem(1,"d_fromday",  sEnterDate)	
	else
		dw_1.SetItem(1,"d_fromday",  sFromDt)		
	end if
	dw_1.SetItem(1,"d_today",    '20121231' )	
	
	//2012년 이후 입사자 예외 처리 수정(2014.07.07)
	IF sEnterDate <= '20121231' THEN		
		select nvl(to_number(hr_fun_term_calc2(DECODE(:sBeforeGbn,'Y',:sEnterDate,:sFromDt), '20121231', '1')), 0), 
				 nvl(to_number(hr_fun_term_calc2(DECODE(:sBeforeGbn,'Y',:sEnterDate,:sFromDt), '20121231', '2')), 0), 
				 nvl(to_number(hr_fun_term_calc2(DECODE(:sBeforeGbn,'Y',:sEnterDate,:sFromDt), '20121231', '3')), 0)
		into :iTempYear, :iTempMonth, :iTempDay
		from dual;
		 
		if IsNull(iTempYear) then iTempYear = 0
		if IsNull(iTempMonth) then iTempMonth = 0
		if IsNull(iTempDay) then iTempDay = 0
		if iTempDay > 0 then iTempDay = 1
		dw_1.SetItem(1,"d_workmon",  ( iTempYear * 12 ) + iTempMonth + iTempDay )	
		if iTempMonth > 0 or iTempDay > 0 then
			iDworkYear = iTempYear + 1 		
		else
			iDworkYear = iTempYear
		end if
		dw_1.SetItem(1,"d_workyear", iDworkYear)	
	ELSE
		dw_1.SetItem(1,"d_fromday",  '')
		dw_1.SetItem(1,"d_today",    '' )	
		dw_1.SetItem(1,"d_workmon",  0 )	
		dw_1.SetItem(1,"d_workyear", 0)		
	END IF
	//
	
	
	//2013년이후
	//2013년 이후 입사자 예외처리 추가(2014.07.07)
	if sToDt >= '20130101' then
		IF sEnterDate < '20130101' THEN
			dw_1.SetItem(1,"e_fromday",  '20130101')	
			
			select nvl(to_number(hr_fun_term_calc2('20130101', :sToDt, '1')), 0), 
				 	nvl(to_number(hr_fun_term_calc2('20130101', :sToDt, '2')), 0), 
					 nvl(to_number(hr_fun_term_calc2('20130101', :sToDt, '3')), 0)
			into :iTempYear, :iTempMonth, :iTempDay
			from dual;
		ELSE
			dw_1.SetItem(1,"e_fromday",  sEnterDate)	
			
			select nvl(to_number(hr_fun_term_calc2(:sEnterDate, :sToDt, '1')), 0), 
				 	nvl(to_number(hr_fun_term_calc2(:sEnterDate, :sToDt, '2')), 0), 
					 nvl(to_number(hr_fun_term_calc2(:sEnterDate, :sToDt, '3')), 0)
			into :iTempYear, :iTempMonth, :iTempDay
			from dual;
		END IF
		//
		dw_1.SetItem(1,"e_today",    sToDt )			
		
		if IsNull(iTempYear) then iTempYear = 0
		if IsNull(iTempMonth) then iTempMonth = 0
		if IsNull(iTempDay) then iTempDay = 0
		if iTempDay > 0 then iTempDay = 1
		dw_1.SetItem(1,"e_workmon",  ( iTempYear * 12 ) + iTempMonth + iTempDay )	
		dw_1.SetItem(1,"e_workyear", iCworkYear - iDworkYear )	
	end if
end if

if dBeforeAmt <> 0 then
	dw_1.Modify("a_giday.protect = '0'")
	dw_1.Modify("a_workmon.protect = '0'")
	dw_1.Modify("a_expmon.protect = '0'")
	dw_1.Modify("a_addmon.protect = '0'")
	dw_1.Modify("a_dumon.protect = '0'")
	dw_1.Modify("a_workyear.protect = '0' ")
else
	dw_1.Modify("a_giday.protect = '1'")
	dw_1.Modify("a_workmon.protect = '1'")
	dw_1.Modify("a_expmon.protect = '1'")
	dw_1.Modify("a_addmon.protect = '1'")
	dw_1.Modify("a_dumon.protect = '1'")
	dw_1.Modify("a_workyear.protect = '1' ")
end if
end event

on w_pip5022_year.create
int iCurrent
call super::create
this.dw_sawon=create dw_sawon
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_sawon
this.Control[iCurrent+2]=this.rr_3
this.Control[iCurrent+3]=this.rr_1
end on

on w_pip5022_year.destroy
call super::destroy
destroy(this.dw_sawon)
destroy(this.rr_3)
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_pip5022_year
boolean visible = false
integer x = 0
integer y = 2780
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_pip5022_year
integer x = 3063
integer y = 24
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;rollback;

CloseWithReturn(Parent, '0')
end event

type p_inq from w_inherite_popup`p_inq within w_pip5022_year
boolean visible = false
integer x = 1966
integer y = 2384
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_pip5022_year
integer x = 2889
integer y = 24
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_choose::clicked;call super::clicked;dw_1.AcceptText()

dw_1.Update()
Commit;

CloseWithReturn(Parent,'1')
end event

type dw_1 from w_inherite_popup`dw_1 within w_pip5022_year
integer x = 55
integer y = 332
integer width = 3177
integer height = 592
string dataobject = "d_pip5022_year_1"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::clicked;//If Row <= 0 then
//	dw_1.SelectRow(0,False)
//	b_flag =True
//ELSE
//
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
//	
//	b_flag = False
//END IF
//
//CALL SUPER ::CLICKED
end event

event dw_1::rowfocuschanged;b_flag = False
end event

type sle_2 from w_inherite_popup`sle_2 within w_pip5022_year
boolean visible = false
integer y = 2656
end type

type cb_1 from w_inherite_popup`cb_1 within w_pip5022_year
boolean visible = false
integer y = 2404
end type

type cb_return from w_inherite_popup`cb_return within w_pip5022_year
boolean visible = false
integer y = 2404
end type

type cb_inq from w_inherite_popup`cb_inq within w_pip5022_year
boolean visible = false
integer y = 2404
end type

type sle_1 from w_inherite_popup`sle_1 within w_pip5022_year
boolean visible = false
integer y = 2656
end type

type st_1 from w_inherite_popup`st_1 within w_pip5022_year
boolean visible = false
integer y = 2668
end type

type dw_sawon from datawindow within w_pip5022_year
integer x = 69
integer y = 28
integer width = 2706
integer height = 264
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip5022_year_0"
boolean border = false
boolean livescroll = true
end type

type rr_3 from roundrectangle within w_pip5022_year
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 320
integer width = 3214
integer height = 616
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pip5022_year
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 32
integer y = 20
integer width = 2752
integer height = 284
integer cornerheight = 40
integer cornerwidth = 55
end type

