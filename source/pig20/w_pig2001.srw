$PBExportHeader$w_pig2001.srw
$PBExportComments$교육훈련계획등록
forward
global type w_pig2001 from w_inherite_standard
end type
type dw_emp from datawindow within w_pig2001
end type
type tab_1 from tab within w_pig2001
end type
type tabpage_1 from userobject within tab_1
end type
type dw_main1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_main1 dw_main1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_main2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_main2 dw_main2
end type
type tab_1 from tab within w_pig2001
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_pig2001 from w_inherite_standard
string title = "교육훈련계획등록"
dw_emp dw_emp
tab_1 tab_1
end type
global w_pig2001 w_pig2001

type variables
//구조체
str_edu istr_edu

//등록구분
string ls_gub
end variables

forward prototypes
public subroutine wf_init ()
public function integer wf_thour ()
public function long wf_date (string sdate, string edate)
public function long wf_time (string stime, string etime)
public function integer wf_requiredchk (integer argtab, long argrow)
public function integer wf_count ()
public subroutine wf_setting_retrievemode (string mode)
end prototypes

public subroutine wf_init ();string ls_empno

choose case tab_1.selectedtab
	case 1
        tab_1.tabpage_1.dw_main1.SetRedraw(false)
        tab_1.tabpage_1.dw_main1.Reset()
        tab_1.tabpage_1.dw_main1.insertRow(0)

        tab_1.tabpage_1.dw_main1.SetTaborder('p5_educations_p_eduyear',10)
        tab_1.tabpage_1.dw_main1.SetTaborder('empseq',20)


		  
		  if dw_emp.AcceptText() = -1 then return
		  
		  ls_empno = dw_emp.GetitemString(1, 'empno')
		  
        tab_1.tabpage_1.dw_main1.SetItem(1, 'companycode', gs_company)
        tab_1.tabpage_1.dw_main1.SetItem(1, 'empno', ls_empno)		  
		  
        //년도 setting
        tab_1.tabpage_1.dw_main1.setitem(1, "p5_educations_p_eduyear", & 
		                                   string(today(), 'YYYY'))
        //계획일자 setting
//        tab_1.tabpage_1.dw_main1.setitem(1, "startdate", &
//                                         string(today(), 'YYYYMMDD'))
//        tab_1.tabpage_1.dw_main1.setitem(1, "enddate", &
//                                 string(today(), 'YYYYMMDD'))
//													  
//        //시간 setting
//        tab_1.tabpage_1.dw_main1.setitem(1, "starttime", long(string(0900)))
//        tab_1.tabpage_1.dw_main1.setitem(1, "endtime", long(string(1800)))
//
		  
        tab_1.tabpage_1.dw_main1.SetItem(1, 'bgubn', "P")	// 계획자료(P)	  		  
		  
        tab_1.tabpage_1.dw_main1.SetItemStatus(1, 0,Primary!, NotModified!)
        tab_1.tabpage_1.dw_main1.SetItemStatus(1, 0,Primary!, New!)

		  
//        tab_1.tabpage_1.dw_main1.setfocus()
//        tab_1.tabpage_1.dw_main1.setcolumn('p5_educations_p_eduyear')		  
        tab_1.tabpage_1.dw_main1.SetRedraw(true)		  
   case 2
        tab_1.tabpage_2.dw_main2.SetRedraw(false)

        tab_1.tabpage_2.dw_main2.Reset()
        tab_1.tabpage_2.dw_main2.insertRow(0)

        tab_1.tabpage_2.dw_main2.SetTaborder('p5_educations_p_eduyear',10)
        tab_1.tabpage_2.dw_main2.SetTaborder('empseq',20)

		  if dw_emp.AcceptText() = -1 then return
		  
		  ls_empno = dw_emp.GetitemString(1, 'empno')
		  
        tab_1.tabpage_2.dw_main2.SetItem(1, 'companycode', gs_company)
        tab_1.tabpage_2.dw_main2.SetItem(1, 'empno', ls_empno)		  
		  
        //년도 setting
        tab_1.tabpage_2.dw_main2.setitem(1, "p5_educations_p_eduyear", & 
		                                   string(today(), 'YYYY'))

        //계획일자 setting
//        tab_1.tabpage_2.dw_main2.setitem(1, "startdate", &
//                                         string(today(), 'YYYYMMDD'))
//        tab_1.tabpage_2.dw_main2.setitem(1, "enddate", &
//                                 string(today(), 'YYYYMMDD'))
//													  
//        //시간 setting
//        tab_1.tabpage_2.dw_main2.setitem(1, "starttime", long(string(0900)))
//        tab_1.tabpage_2.dw_main2.setitem(1, "endtime", long(string(1800)))
//		  
        tab_1.tabpage_2.dw_main2.SetItem(1, 'bgubn', "R")	// 신청자료(R)
		  
        tab_1.tabpage_2.dw_main2.SetItemStatus(1, 0,Primary!, NotModified!)
        tab_1.tabpage_2.dw_main2.SetItemStatus(1, 0,Primary!, New!)
		  
//        tab_1.tabpage_2.dw_main2.setfocus()
//        tab_1.tabpage_2.dw_main2.setcolumn('p5_educations_p_eduyear')		  		  
        tab_1.tabpage_2.dw_main2.SetRedraw(true)		  
end choose	

end subroutine

public function integer wf_thour ();string ls_startdate, ls_enddate
long ll_time1, ll_time2 


choose case tab_1.selectedtab
	case 1
	ls_startdate = tab_1.tabpage_1.dw_main1.GetItemstring(1, 'startdate')
	ls_enddate = tab_1.tabpage_1.dw_main1.GetItemstring(1, 'enddate')
end choose 

return 1

		
//		if  ls_startdate > ls_enddate then
//			MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
//			                   "클 수는 없습니다.!!", stopsign!)
//			return 1
////		temp_date1 = string(left(ls_startdate, 4) + "/"+ mid(ls_startdate, 5,2) + "/" + &
//		             right(ls_startdate, 2))
//		temp_date2 = string(left(ls_enddate, 4) + "/"+ mid(ls_enddate, 5,2) + "/" + &
//		             right(ls_enddate, 2))
//      ll_temp1 = 	daysafter(date(temp_date1), date(temp_date2)) + 1
//		
//		tab_1.tabpage_1.dw_main1.setItem(1, 'datesu', ll_temp1)
//		

//	   ls_starttime = string(long(data), '00:00')
//		if Istime(ls_starttime) = false Then
//			MessageBox("확 인", "유효한 시간이 아닙니다.")			
//			return 1
//		end if
//	case 'endtime'
//	   ls_endtime = string(long(data), '00:00')
//		if Istime(ls_endtime) = false Then
//			MessageBox("확 인", "유효한 시간이 아닙니다.")			
//			return 1
//		end if
//		ls_starttime = string(tab_1.tabpage_1.dw_main1.GetItemNumber(1, 'starttime'), & 
//		                           '00:00')
//		if ls_starttime >= ls_endtime then
//			MessageBox("확 인", "시작 시간이 종료시간보다" + "~n" + & 
//			                   "클 수는 없습니다.!!")			
//			return 1
//		end if
//      ll_time1 = (long ( left (ls_endtime, 2 ) ) * 60  + long (mid (ls_endtime ,4,2 ))) - &
//            		(long ( left (ls_starttime, 2 ) ) * 60  + long (mid (ls_starttime ,4,2 )))
//			
//       //computed field에 들어 가 있는 계산
//      //truncate( ((  long(left(string(endtime, '0000'), 2)) * 60  + &
//      //         long (right(string(endtime, '0000'), 2))) - &
//      //         (long(left(string(starttime, '0000'), 2)) * 60  + &
//      //           long (right(string(starttime, '0000'), 2)) )) / 60, 0)
//			
//		if ll_time1 < 60 then
//       	ll_time2	= 1
//		else 
//         ll_time2 = truncate(ll_time1/60, 0) // + (mod(ll_time1, 60 ))/100 
//		end if
//

//		ll_datesu = long(data) * tab_1.tabpage_1.dw_main1.GetItemNumber(1, 'temp1')  
//		tab_1.tabpage_1.dw_main1.SetItem(1, 'ehour', ll_datesu)


end function

public function long wf_date (string sdate, string edate);string temp_date1, temp_date2
long ll_temp1

if isnull(sdate) or sdate = "" then return -1
if isnull(edate) or edate = "" then return -1

temp_date1 = string(left(sdate, 4) + "/"+ mid(sdate, 5,2) + "/" + &
				 right(sdate, 2))
temp_date2 = string(left(edate, 4) + "/"+ mid(edate, 5,2) + "/" + &
				 right(edate, 2))
ll_temp1 = 	daysafter(date(temp_date1), date(temp_date2)) + 1

return ll_temp1

end function

public function long wf_time (string stime, string etime);string ls_stime, ls_etime
long ll_time1, ll_time2

ls_stime = stime
ls_etime = etime

if isnull(ls_stime) or  ls_stime = "" then return -1
if isnull(ls_etime) or  ls_etime = "" then return -1

ll_time1 = (long ( left (ls_etime, 2 ) ) * 60  + long ( right (ls_etime, 2))) - &
				(long ( left (ls_stime, 2 ) ) * 60  + long (right (ls_stime, 2)))

if ll_time1 < 60 then
  	ll_time2	= 0
else 
	ll_time2 = truncate(ll_time1/60, 0) // + (mod(ll_time1, 60 ))/100 
	
end if

return ll_time2

end function

public function integer wf_requiredchk (integer argtab, long argrow);string ls_empno, ls_eduyear, ls_sdate, ls_edate
string ls_arguempseq

long ll_empseq, lnull

SetNull(lnull)

choose case argtab
	case 1
		ls_empno    =  dw_emp.GetItemString(1, 'empno')
      
		
		ls_eduyear  =  tab_1.tabpage_1.dw_main1.GetItemString(argrow, 'p5_educations_p_eduyear')		
		ls_sdate    =  tab_1.tabpage_1.dw_main1.GetItemString(argrow, 'startdate')		
      ls_edate    =  tab_1.tabpage_1.dw_main1.GetItemString(argrow, 'enddate')	
		
		ll_empseq    = tab_1.tabpage_1.dw_main1.GetItemNumber(argrow, 'empseq')				
		
		// 필수 입력사항 check
      if isnull(ls_empno) or ls_empno = "" then
			MessageBox("확 인", "사번은 필수입력사항입니다.!!", stopsign!)
			dw_emp.setcolumn('empno')
			dw_emp.setfocus()
			return -1
		end if
		
      if isnull(ls_eduyear) or ls_eduyear = "" then
			MessageBox("확 인", "계획년도는 필수입력사항입니다.!!", stopsign!)
			tab_1.tabpage_1.dw_main1.setcolumn('p5_educations_p_eduyear')
         tab_1.tabpage_1.dw_main1.setfocus()
			return -1
		end if
		
		if f_datechk(ls_eduyear+'01'+'01') = -1 then 
			MessageBox("확 인", "유효한 계획년도가 아닙니다.")
			tab_1.tabpage_1.dw_main1.setcolumn('p5_educations_p_eduyear')
         tab_1.tabpage_1.dw_main1.setfocus()
			Return -1
		end if
		
		if isnull(ll_empseq) or trim(string(ll_empseq)) = "" or ll_empseq <= 0 then 
			ls_gub = "등록"
		else
			SELECT "P5_EDUCATIONS_P"."EMPSEQ"  
			 INTO :ls_arguempseq   
			 FROM "P5_EDUCATIONS_P"  
			WHERE ( "P5_EDUCATIONS_P"."COMPANYCODE" = :gs_company ) AND  
					( "P5_EDUCATIONS_P"."EMPNO" = :ls_empno ) AND  
					( "P5_EDUCATIONS_P"."EDUYEAR" = :ls_eduyear )  AND   
					( "P5_EDUCATIONS_P"."EMPSEQ" = :ll_empseq ) ;
			if sqlca.sqlcode = 100 then //no data found
				 tab_1.tabpage_1.dw_main1.setItem(argrow, 'empseq', lnull)
             ls_gub = "등록"				
			elseif  sqlca.sqlcode = 0 then 
				 ls_gub = "조회"
			else
				MessageBox("확 인", "사번 자동 채번중 에러 발생.!!", stopsign!)
				tab_1.tabpage_1.dw_main1.setcolumn('empseq')
				tab_1.tabpage_1.dw_main1.setfocus()
				return -1
	  	   end if 
		end if

		if isnull(ls_sdate) or ls_sdate = "" then 
			MessageBox("확 인", "교육 시작일자는 필수입력사항입니다.!!")			
			tab_1.tabpage_1.dw_main1.setcolumn('startdate')			
         tab_1.tabpage_1.dw_main1.setfocus()
			return -1
		end if
		If f_datechk(ls_sdate) = -1 Then
			MessageBox("확 인", "유효한 일자가 아닙니다.")
			tab_1.tabpage_1.dw_main1.setcolumn('startdate')			
         tab_1.tabpage_1.dw_main1.setfocus()
			Return -1
		end if
		
		if isnull(ls_edate) or ls_edate = "" then 
			MessageBox("확 인", "교육 종료일자는 필수입력사항입니다.!!")			
			tab_1.tabpage_1.dw_main1.setcolumn('enddate')
         tab_1.tabpage_1.dw_main1.setfocus()
			return -1
		end if
		If f_datechk(ls_edate) = -1 Then
			MessageBox("확 인", "유효한 일자가 아닙니다.")
			tab_1.tabpage_1.dw_main1.setcolumn('enddate')
         tab_1.tabpage_1.dw_main1.setfocus()
			Return -1
		end if

		if  ls_sdate > ls_edate then
			MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
			                   "클 수는 없습니다.!!", stopsign!)
			tab_1.tabpage_1.dw_main1.setcolumn('startdate')
         tab_1.tabpage_1.dw_main1.setfocus()
			return -1
		end if
		

	case 2

		ls_empno    =  dw_emp.GetItemString(1, 'empno')
		ls_eduyear  =  tab_1.tabpage_2.dw_main2.GetItemString(argrow, 'p5_educations_p_eduyear')		
		ls_sdate    =  tab_1.tabpage_2.dw_main2.GetItemString(argrow, 'startdate')		
      ls_edate    =  tab_1.tabpage_2.dw_main2.GetItemString(argrow, 'enddate')		

		ll_empseq    = tab_1.tabpage_2.dw_main2.GetItemNumber(argrow, 'empseq')				

		// 필수 입력사항 check
      if isnull(ls_empno) or ls_empno = "" then
			MessageBox("확 인", "사번은 필수입력사항입니다.!!", stopsign!)
			dw_emp.setcolumn('empno')
			dw_emp.setfocus()
			return -1
		end if
		
      if isnull(ls_eduyear) or ls_eduyear = "" then
			MessageBox("확 인", "계획년도는 필수입력사항입니다.!!", stopsign!)
			tab_1.tabpage_2.dw_main2.setcolumn('p5_educations_p_eduyear')
         tab_1.tabpage_2.dw_main2.setfocus()
			return -1
		end if
		
		if f_datechk(ls_eduyear+'01'+'01') = -1 then 
			MessageBox("확 인", "유효한 계획년도가 아닙니다.")
			tab_1.tabpage_2.dw_main2.setcolumn('p5_educations_p_eduyear')
         tab_1.tabpage_2.dw_main2.setfocus()
			Return -1
		end if
		
		if isnull(ll_empseq) or string(ll_empseq) = "" or ll_empseq <= 0 then 
			ls_gub = "등록"
		else
			SELECT "P5_EDUCATIONS_P"."EMPSEQ"  
			 INTO :ls_arguempseq   
			 FROM "P5_EDUCATIONS_P"  
			WHERE ( "P5_EDUCATIONS_P"."COMPANYCODE" = :gs_company ) AND  
					( "P5_EDUCATIONS_P"."EMPNO" = :ls_empno ) AND  
					( "P5_EDUCATIONS_P"."EDUYEAR" = :ls_eduyear )  AND   
					( "P5_EDUCATIONS_P"."EMPSEQ" = :ll_empseq ) ;
			if sqlca.sqlcode = 100 then //no data found
             tab_1.tabpage_2.dw_main2.SetItem(argrow, 'empseq', lnull)						
             ls_gub = "등록"				
			elseif sqlca.sqlcode = 0 then
				ls_gub = "조회"
			else
				MessageBox("확 인", "사번 자동 채번중 에러 발생.!!", stopsign!)
				tab_1.tabpage_2.dw_main2.setcolumn('empseq')
				tab_1.tabpage_2.dw_main2.setfocus()
				return -1
	  	   end if 
		end if
		
		if isnull(ls_sdate) or ls_sdate = "" then 
			MessageBox("확 인", "교육 시작일자는 필수입력사항입니다.!!")			
			tab_1.tabpage_2.dw_main2.setcolumn('startdate')
         tab_1.tabpage_2.dw_main2.setfocus()
			return -1
		end if
		If f_datechk(ls_sdate) = -1 Then
			MessageBox("확 인", "유효한 일자가 아닙니다.")
			tab_1.tabpage_2.dw_main2.setcolumn('startdate')
         tab_1.tabpage_2.dw_main2.setfocus()
			Return -1
		end if
		
		if isnull(ls_edate) or ls_edate = "" then 
			MessageBox("확 인", "교육 종료일자는 필수입력사항입니다.!!")			
			tab_1.tabpage_2.dw_main2.setcolumn('enddate')
         tab_1.tabpage_2.dw_main2.setfocus()
			return -1
		end if
		If f_datechk(ls_edate) = -1 Then
			MessageBox("확 인", "유효한 일자가 아닙니다.")
			tab_1.tabpage_2.dw_main2.setcolumn('enddate')
         tab_1.tabpage_2.dw_main2.setfocus()
			Return -1
		end if
		
		if  ls_sdate > ls_edate then
			MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
			                   "클 수는 없습니다.!!", stopsign!)
			tab_1.tabpage_2.dw_main2.setcolumn('startdate')
         tab_1.tabpage_2.dw_main2.setfocus()
			return -1
		end if
		
end choose

return 1
end function

public function integer wf_count ();string ls_company, ls_empno, ls_eduyear
long ll_empseq, ll_empseq1

choose case tab_1.selectedTab
	case 1
		if tab_1.tabpage_1.dw_main1.AcceptText() = -1 then return -1
	
     	ls_company  = tab_1.tabpage_1.dw_main1.GetItemString(1, 'companycode')
		ls_empno    =  tab_1.tabpage_1.dw_main1.GetItemString(1, 'empno')
		ls_eduyear  =  tab_1.tabpage_1.dw_main1.GetItemString(1, 'p5_educations_p_eduyear')		
//		ll_empseq   =  tab_1.tabpage_1.dw_main1.GetItemNumber(1, 'empseq')
		
//		if isnull(ll_empseq) or trim(string(ll_empseq)) = '' then 

      SELECT MAX("P5_EDUCATIONS_P"."EMPSEQ")
      INTO :ll_empseq  
      FROM "P5_EDUCATIONS_P"  
      WHERE ( "P5_EDUCATIONS_P"."COMPANYCODE" = :ls_company ) AND  
            ( "P5_EDUCATIONS_P"."EMPNO" = :ls_empno ) AND  
            ( "P5_EDUCATIONS_P"."EDUYEAR" = :ls_eduyear )   ;
		if sqlca.sqlcode <> 0 then
			f_message_chk(51, "계획자료 등록")
			return -1
		end if
		if isnull(ll_empseq) or ll_empseq = 0 or trim(string(ll_empseq)) = "" then
			ll_empseq = 0 
		end if
		ll_empseq1 = ll_empseq + 1
		tab_1.tabpage_1.dw_main1.SetItem(1, "empseq", ll_empseq1)
      return 1		
		
	case 2
		if tab_1.tabpage_2.dw_main2.AcceptText() = -1 then return -1
	
     	ls_company  = tab_1.tabpage_2.dw_main2.GetItemString(1, 'companycode')
		ls_empno    =  tab_1.tabpage_2.dw_main2.GetItemString(1, 'empno')
		ls_eduyear  =  tab_1.tabpage_2.dw_main2.GetItemString(1, 'p5_educations_p_eduyear')		
//		ll_empseq   =  tab_1.tabpage_1.dw_main1.GetItemNumber(1, 'empseq')

      SELECT MAX("P5_EDUCATIONS_P"."EMPSEQ")
      INTO :ll_empseq  
      FROM "P5_EDUCATIONS_P"  
      WHERE ( "P5_EDUCATIONS_P"."COMPANYCODE" = :ls_company ) AND  
            ( "P5_EDUCATIONS_P"."EMPNO" = :ls_empno ) AND  
            ( "P5_EDUCATIONS_P"."EDUYEAR" = :ls_eduyear )   ;
		if sqlca.sqlcode <> 0 then
			f_message_chk(51, "신청자료 등록")
			return -1
		end if
		if isnull(ll_empseq) or ll_empseq = 0 or trim(string(ll_empseq)) = "" then
			ll_empseq = 0 
		end if
		ll_empseq1 = ll_empseq + 1
		
		tab_1.tabpage_2.dw_main2.SetItem(1, "empseq", ll_empseq1)
      return 1		
end choose
	
end function

public subroutine wf_setting_retrievemode (string mode);////************************************************************************************//
//// **** FUNCTION NAME :WF_SETTING_RETRIEVEMODE(DATAWINDOW 제어)      					  //
////      * ARGUMENT : String mode(수정mode 인지 입력 mode 인지 구분)						  //
////		  * RETURN VALUE : 없슴 																		  //
////************************************************************************************//
//

p_mod.Enabled =True

Choose Case tab_1.selectedtab
	case 1
       tab_1.tabpage_1.dw_main1.SetRedraw(False)				
		if mode = "등록" then
         tab_1.tabpage_1.dw_main1.SetTaborder('p5_educations_p_eduyear',10)
         tab_1.tabpage_1.dw_main1.SetTaborder('empseq',20)
         p_del.Enabled =false			
		elseif mode = "조회" then 
      	tab_1.tabpage_1.dw_main1.SetTabOrder('p5_educations_p_eduyear', 0)
	      tab_1.tabpage_1.dw_main1.SetTabOrder('empseq', 0)
         p_del.Enabled =True						
			
		end if
       tab_1.tabpage_1.dw_main1.SetRedraw(true)						
	case 2
       tab_1.tabpage_2.dw_main2.SetRedraw(False)		
		if mode = "등록" then
         tab_1.tabpage_2.dw_main2.SetTaborder('p5_educations_p_eduyear',10)
         tab_1.tabpage_2.dw_main2.SetTaborder('empseq',20)
         p_del.Enabled =false						
		elseif mode = "조회" then 
      	tab_1.tabpage_2.dw_main2.SetTabOrder('p5_educations_p_eduyear', 0)
	      tab_1.tabpage_2.dw_main2.SetTabOrder('empseq', 0)
         p_del.Enabled =True									
		end if
       tab_1.tabpage_2.dw_main2.SetRedraw(true)
end choose
		

end subroutine

on w_pig2001.create
int iCurrent
call super::create
this.dw_emp=create dw_emp
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_emp
this.Control[iCurrent+2]=this.tab_1
end on

on w_pig2001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_emp)
destroy(this.tab_1)
end on

event open;call super::open;This.SetRedraw(false)
dw_emp.settransobject(sqlca)
tab_1.tabpage_1.dw_main1.settransobject(sqlca)
tab_1.tabpage_2.dw_main2.settransobject(sqlca)

tab_1.tabpage_1.dw_main1.reset()
tab_1.tabpage_2.dw_main2.reset()

tab_1.tabpage_1.dw_main1.insertrow(0)
tab_1.tabpage_2.dw_main2.insertrow(0)

dw_emp.reset()
dw_emp.insertrow(0)

PostEvent('ue_append')
This.SetRedraw(true)
end event

event ue_append;
dw_emp.setfocus()
dw_emp.SetColumn("empno")


ib_any_typing = false
end event

type p_mod from w_inherite_standard`p_mod within w_pig2001
end type

event p_mod::clicked;call super::clicked;string ls_company, ls_empno, ls_eduyear, &
       ls_totchk, ls_sdate, ls_edate, get_eduyear
		 
long ll_empseq, ll_row, ll_cnt, get_seq, get_empseq
Long sCount

choose case tab_1.selectedtab
	case 1
		if dw_emp.AcceptText() = -1 then return
		if tab_1.tabpage_1.dw_main1.AcceptText() = -1 then return
		
		ll_row = tab_1.tabpage_1.dw_main1.getrow()
		
		if ll_row <= 0 then return
		
		ls_company = gs_company
		ls_empno = dw_emp.GetItemString(1, 'empno')
		ls_eduyear = tab_1.tabpage_1.dw_main1.GetItemString(ll_row, 'p5_educations_p_eduyear')
		ll_empseq  = tab_1.tabpage_1.dw_main1.GetItemNumber(ll_row, 'empseq')
		
		/*수정부분*/
	   SELECT count("P5_EDUCATIONS_P"."EMPNO")  
        INTO :sCount  
		  FROM "P5_EDUCATIONS_P"  
		 WHERE  ( "P5_EDUCATIONS_P"."COMPANYCODE" =:gs_company ) AND  
		   	  ( "P5_EDUCATIONS_P"."EMPNO"   =:ls_empno ) AND  
				  ( "P5_EDUCATIONS_P"."EDUYEAR" =:ls_eduyear ) AND  
				  ( "P5_EDUCATIONS_P"."EMPSEQ"  =:ll_empseq )   ;
        IF sCount >= 1 THEN
		    if  MessageBox("확 인","동일한 자료가 존재합니다."+ "~n" + &
			             "저장하시겠습니까?",Question!,YesNo!) = 2 then return
			
		  END IF
		 		
		// 필수 입력항목 check
		// 1 은 교육계획 tabpabe
		if wf_requiredchk(1, ll_row) = -1 then return
		
      // 총무과에서 확인이 되어 있으면 자료 입력 불가
		
		SELECT "P5_EDUCATIONS_S"."EDUYEAR", 
		       "P5_EDUCATIONS_S"."EMPSEQ",  COUNT(*)   
		INTO  :get_eduyear, 
		      :get_empseq, :get_seq   
		 FROM "P5_EDUCATIONS_S"    
		 WHERE "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company  AND    
				 "P5_EDUCATIONS_S"."EMPNO"  = :ls_empno    AND       
				 "P5_EDUCATIONS_S"."PEDUYEAR"  = :ls_eduyear AND     
				 "P5_EDUCATIONS_S"."PEMPSEQ"  = :ll_empseq AND   
				 "P5_EDUCATIONS_S"."ISU"  = 'Y' AND  
				 "P5_EDUCATIONS_S"."BGUBN"  = 'P'      
		GROUP BY "P5_EDUCATIONS_S"."EDUYEAR",    
		         "P5_EDUCATIONS_S"."EMPSEQ" ;   
				  
		if sqlca.sqlcode = 0 and get_seq > 0 then 
			MessageBox("확 인", "실적번호 : " + "~"" + string(get_empseq) + "~"로 " + &
									  "이미 이수처리된 자료입니다.!!" + "~n" + "~n" + &
									  "자료를 수정하거나 삭제할 후 없습니다.!!")
	     ib_any_typing = false									  									  
			return 
		end if 
		if sqlca.sqlcode < 0 then 
			MessageBox("확 인", "저장중 에러 발생(실적조회)")
			return 
		end if 
		
		
		ls_totchk   =  tab_1.tabpage_1.dw_main1.GetItemString(ll_row, 'p5_educations_p_totchk')  		
		
      if ls_totchk = "Y" then
       	MessageBox("확 인", "이미 총무에서 확인이 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 수정할 수 없습니다.")
	     ib_any_typing = false									  							  
    	   return
      end if 
		
		
		if ls_gub = '등록' then
			if wf_count() = -1 then return //자동채번
		end if
		
		if f_msg_update() = -1 then return
				
      if tab_1.tabpage_1.dw_main1.update() <> 1 then
    	   rollback using sqlca;
         w_mdi_frame.sle_msg.text ="자료를 저장하지 못하였습니다.!!"		  			 
   	   return
      end if
		commit using sqlca;
      w_mdi_frame.sle_msg.text ="자료를 저장하였습니다.!!"				
		
	case 2
		if dw_emp.AcceptText() = -1 then return		
		if tab_1.tabpage_2.dw_main2.AcceptText() = -1 then return
		
		ll_row = tab_1.tabpage_2.dw_main2.getrow()

		if ll_row <= 0 then return

		ls_company = gs_company		
		
		ls_empno = dw_emp.GetItemString(1, 'empno')
		ls_eduyear = tab_1.tabpage_2.dw_main2.GetItemString(ll_row, 'p5_educations_p_eduyear')
		ll_empseq = tab_1.tabpage_2.dw_main2.GetItemNumber(ll_row, 'empseq')
		
		/*수정부분*/
		SELECT count("P5_EDUCATIONS_P"."EMPNO")  
        INTO :sCount  
		  FROM "P5_EDUCATIONS_P"  
		 WHERE  ( "P5_EDUCATIONS_P"."COMPANYCODE" =:gs_company ) AND  
		   	  ( "P5_EDUCATIONS_P"."EMPNO"   =:ls_empno ) AND  
				  ( "P5_EDUCATIONS_P"."EDUYEAR" =:ls_eduyear ) AND  
				  ( "P5_EDUCATIONS_P"."EMPSEQ"  =:ll_empseq )   ;
        IF sCount >= 1 THEN
			 if  MessageBox("확 인","동일한 자료가 존재합니다."+ "~n" + &
			             "저장하시겠습니까?",Question!,YesNo!) = 2 then return
			  Return 
		  END IF
		 	
		// 필수 입력항목 check
		// 2 는 교육신청 tabpabe
		if wf_requiredchk(2, ll_row) = -1 then return
		
		SELECT "P5_EDUCATIONS_S"."EDUYEAR", 
		       "P5_EDUCATIONS_S"."EMPSEQ",  COUNT(*)   
		INTO   :get_eduyear, :get_empseq, :get_seq   
		 FROM "P5_EDUCATIONS_S"    
		 WHERE "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company  AND    
				 "P5_EDUCATIONS_S"."EMPNO"  = :ls_empno    AND       
				 "P5_EDUCATIONS_S"."PEDUYEAR"  = :ls_eduyear AND     
				 "P5_EDUCATIONS_S"."PEMPSEQ"  = :ll_empseq AND   
				 "P5_EDUCATIONS_S"."ISU"  = 'Y' AND  
				 "P5_EDUCATIONS_S"."BGUBN"  = 'R'      
		GROUP BY "P5_EDUCATIONS_S"."EDUYEAR", 
		         "P5_EDUCATIONS_S"."EMPSEQ" ;   
				  
		if sqlca.sqlcode = 0 and get_seq > 0 then 
			MessageBox("확 인", "실적번호 : " + "~"" + string(get_empseq) + "~"로 " + &
									  "이미 이수처리된 자료입니다.!!" + "~n" + "~n" + &
									  "자료를 수정하거나 삭제할 후 없습니다.!!")
	     ib_any_typing = false									  									  
			return 
		end if 
		if sqlca.sqlcode < 0 then 
			MessageBox("확 인", "저장중 에러 발생(실적조회)")
			return 
		end if 



      // 총무과에서 확인이 되어 있으면 자료 입력 불가
		
		ls_totchk   =  tab_1.tabpage_2.dw_main2.GetItemString(ll_row, 'p5_educations_p_totchk')
		
      if ls_totchk = "Y" then
       	MessageBox("확 인", "이미 총무에서 확인이 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 수정할 수 없습니다.")
	     ib_any_typing = false									  							  
    	   return
      end if 
		
		
		if ls_gub = '등록' then
			if wf_count() = -1 then return //자동채번
		end if
		
		if f_msg_update() = -1 then return

      if tab_1.tabpage_2.dw_main2.update() <> 1 then
        rollback using sqlca;
        w_mdi_frame.sle_msg.text ="자료를 저장하지 못하였습니다.!!"		  
        return 
      end if
		commit using sqlca;
      sle_msg.text ="자료를 저장하였습니다.!!"		
END CHOOSE

// 이미 저장이 되었음을 나타냄
ls_gub = '조회'

WF_SETTING_RETRIEVEMODE(ls_gub)

ib_any_typing = false
end event

type p_del from w_inherite_standard`p_del within w_pig2001
end type

event p_del::clicked;call super::clicked;string ls_totchk, ls_company, ls_empno, ls_eduyear, &
       get_eduyear


long ll_empseq, get_empseq, get_seq   
int il_currow

choose case tab_1.selectedtab
	case 1

      if dw_emp.AcceptText() = -1 then return 
		if tab_1.tabpage_1.dw_main1.AcceptText() = -1 then return 
		
		il_currow = tab_1.tabpage_1.dw_main1.GetRow()
		
      IF il_currow <=0 Then Return		
		
		ls_company = gs_company
		ls_empno = dw_emp.GetItemString(1, 'empno')
		ls_eduyear = tab_1.tabpage_1.dw_main1.GetItemString(il_currow, &
		            'p5_educations_p_eduyear')
		ll_empseq = tab_1.tabpage_1.dw_main1.GetItemNumber(il_currow, 'empseq')
		
		
		SELECT "P5_EDUCATIONS_S"."EDUYEAR", 
		       "P5_EDUCATIONS_S"."EMPSEQ",  COUNT(*)   
		INTO  :get_eduyear, 
		      :get_empseq, :get_seq   
		 FROM "P5_EDUCATIONS_S"    
		 WHERE "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company  AND    
				 "P5_EDUCATIONS_S"."EMPNO"  = :ls_empno    AND       
				 "P5_EDUCATIONS_S"."PEDUYEAR"  = :ls_eduyear AND     
				 "P5_EDUCATIONS_S"."PEMPSEQ"  = :ll_empseq AND   
				 "P5_EDUCATIONS_S"."ISU"  = 'Y' AND  
				 "P5_EDUCATIONS_S"."BGUBN"  = 'P'      
		GROUP BY "P5_EDUCATIONS_S"."EDUYEAR", 
		         "P5_EDUCATIONS_S"."EMPSEQ" ;   
				  
		if sqlca.sqlcode = 0 and get_seq > 0 then 
			MessageBox("확 인", "실적번호 : " + "~"" + string(get_empseq) + "~"로 " + &
									  "이미 이수처리된 자료입니다.!!" + "~n" + "~n" + &
									  "자료를 수정하거나 삭제할 후 없습니다.!!")
	     ib_any_typing = false									  
   		return 
		end if 
		if sqlca.sqlcode < 0 then 
			MessageBox("확 인", "저장중 에러 발생(실적조회)")
			return 
		end if 		
		
		ls_totchk   =  tab_1.tabpage_1.dw_main1.GetItemString(il_currow, 'p5_educations_p_totchk')
                     // 총무과에서 확인이 되어 있으면 자료 입력 불가

      if ls_totchk = "Y" then
       	MessageBox("확 인", "이미 총무에서 확인이 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 삭제할 수 없습니다.")
		  ib_any_typing = false
    	   return
      end if 
		
		if f_msg_delete() = -1 then return

      tab_1.tabpage_1.dw_main1.SetRedraw(false)		
      tab_1.tabpage_1.dw_main1.DeleteRow(il_currow)

		
      if tab_1.tabpage_1.dw_main1.update() <> 1 then
			MessageBox("확 인", "교육계획등록 자료를 삭제하는 도중, ~r~r오류가 발생하였습니다.!!")			
    	   rollback using sqlca;
         ib_any_typing =True
         tab_1.tabpage_1.dw_main1.SetRedraw(true)

   	   return 1
      end if
		commit using sqlca;
		
      tab_1.tabpage_1.dw_main1.SetRedraw(true)			
		
		wf_init()		
	case 2
		
		
      if dw_emp.AcceptText() = -1 then return 
		if tab_1.tabpage_2.dw_main2.AcceptText() = -1 then return 
		

		il_currow = tab_1.tabpage_2.dw_main2.GetRow()
		
      IF il_currow <=0 Then Return		

		ls_company = gs_company		
		ls_empno = dw_emp.GetItemString(1, 'empno')
		ls_eduyear = tab_1.tabpage_2.dw_main2.GetItemString(il_currow, 'p5_educations_p_eduyear')
		ll_empseq = tab_1.tabpage_2.dw_main2.GetItemNumber(il_currow, 'empseq')

		SELECT "P5_EDUCATIONS_S"."EDUYEAR", 
		       "P5_EDUCATIONS_S"."EMPSEQ",  COUNT(*)   
		INTO  :get_eduyear, 
		      :get_empseq, :get_seq   
		 FROM "P5_EDUCATIONS_S"    
		 WHERE "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company  AND    
				 "P5_EDUCATIONS_S"."EMPNO"  = :ls_empno    AND       
				 "P5_EDUCATIONS_S"."PEDUYEAR"  = :ls_eduyear AND     
				 "P5_EDUCATIONS_S"."PEMPSEQ"  = :ll_empseq AND   
				 "P5_EDUCATIONS_S"."ISU"  = 'Y' AND  
				 "P5_EDUCATIONS_S"."BGUBN"  = 'R'      
		GROUP BY "P5_EDUCATIONS_S"."EDUYEAR", 
		         "P5_EDUCATIONS_S"."EMPSEQ" ;   
				  
		if sqlca.sqlcode = 0 and get_seq > 0 then 
			MessageBox("확 인", "실적번호 : " + "~"" + string(get_empseq) + "~"로 " + &
									  "이미 이수처리된 자료입니다.!!" + "~n" + "~n" + &
									  "자료를 수정하거나 삭제할 후 없습니다.!!")
	     ib_any_typing = false									  									  
			return 
		end if 
		if sqlca.sqlcode < 0 then 
			MessageBox("확 인", "저장중 에러 발생(실적조회)")
			return 
		end if 		
		

		ls_totchk   =  tab_1.tabpage_2.dw_main2.GetItemString(il_currow, 'p5_educations_p_totchk')
                     // 총무과에서 확인이 되어 있으면 자료 입력 불가

      if ls_totchk = "Y" then
       	MessageBox("확 인", "이미 총무에서 확인이 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 삭제할 수 없습니다.")
	     ib_any_typing = false									  							  
    	   return
      end if 
		
		
		if f_msg_delete() = -1 then return
		
      tab_1.tabpage_2.dw_main2.DeleteRow(il_currow)
		
      tab_1.tabpage_1.dw_main1.SetRedraw(false)		
		
      if tab_1.tabpage_2.dw_main2.update() <> 1 then
			MessageBox("확 인", "교육신청등록 자료를 삭제하는 도중, ~r~r 오류가 발생하였습니다.!!")			
    	   rollback using sqlca;
         tab_1.tabpage_1.dw_main1.SetRedraw(true)			 
         ib_any_typing =True
   	   return 1
      end if
		
		commit using sqlca;
      tab_1.tabpage_1.dw_main1.SetRedraw(true)						
   	wf_init()
END CHOOSE

// 이미 저장이 되었음을 나타냄
ls_gub = "등록"

WF_SETTING_RETRIEVEMODE(ls_gub)

ib_any_typing = false
w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"

end event

type p_inq from w_inherite_standard`p_inq within w_pig2001
integer x = 3689
end type

event p_inq::clicked;call super::clicked;string ls_code, ls_empno, ls_eduyear, &
       ls_bgubn
long ll_empseq

if tab_1.selectedtab = 1 then
	
	tab_1.tabpage_1.dw_main1.AcceptText()
	
	if tab_1.tabpage_1.dw_main1.RowCount() <= 0 then
		tab_1.tabpage_1.dw_main1.setfocus()
		return
	end if
  gs_code = tab_1.tabpage_1.dw_main1.GetItemString(1, "companycode")
  ls_empno = tab_1.tabpage_1.dw_main1.GetItemString(1, "empno")
  ls_eduyear = tab_1.tabpage_1.dw_main1.GetItemString(1, "p5_educations_p_eduyear")
  ll_empseq = tab_1.tabpage_1.dw_main1.GetItemNumber(1, "empseq")
  ls_bgubn = tab_1.tabpage_1.dw_main1.GetItemString(1, "bgubn")

  if ls_empno="" or isnull(ls_empno) then
	  MessageBox("확 인", "사번은 필수 입력사항입니다.!!")
	  dw_emp.SetColumn('empno')
	  dw_emp.setfocus()
     return	  
  end if 
  
  if ls_eduyear="" or isnull(ls_eduyear) then
	  MessageBox("확 인", "계획년도는 필수 입력사항입니다.!!")
     return	
  end if
  
  if ll_empseq=0 or isnull(ll_empseq) then	
	  MessageBox("확 인", "일련번호는 필수 입력사항입니다.!!")
     return	
  end if

  if gs_code="" or isnull(gs_code) then
	  MessageBox("확 인", "법인코드는 필수 입력사항입니다.!!")
     return
  end if
	  
  if ls_bgubn="" or isnull(ls_bgubn) then		
	  MessageBox("확 인", "자료구분은 필수 입력사항입니다.!!")
     return	
  end if
  
  tab_1.tabpage_1.dw_main1.setredraw(false)
  
  if tab_1.tabpage_1.dw_main1.Retrieve(Gs_code, ls_empno, ls_eduyear, &
                                       ll_empseq, ls_bgubn) <= 0 then
	  MessageBox("확 인", "검색된 교육계획등록 자료가 ~r존재하지 않습니다.!!")
     wf_init()		  
	  
     ls_gub= "등록"    // 등록 mode	  
     WF_SETTING_RETRIEVEMODE(ls_gub)	  

     tab_1.tabpage_1.dw_main1.SetItem(1, 'p5_educations_p_eduyear', ls_eduyear)
	  tab_1.tabpage_1.dw_main1.SetItem(1, 'empseq', ll_empseq)
     tab_1.tabpage_1.dw_main1.SetColumn('p5_educations_p_prostate')			  
     tab_1.tabpage_1.dw_main1.setredraw(true)			  	  
     return
  else
   	ib_any_typing = false
   	ls_gub= "조회"    // 조회 mode
      WF_SETTING_RETRIEVEMODE(ls_gub)		

      tab_1.tabpage_1.dw_main1.Setfocus()
   	tab_1.tabpage_1.dw_main1.SetColumn('p5_educations_p_prostate')		
      tab_1.tabpage_1.dw_main1.setredraw(true)			
  end if
  dw_emp.enabled = false
  
elseif tab_1.selectedtab = 2 then
	
	tab_1.tabpage_2.dw_main2.AcceptText()
	
	if tab_1.tabpage_2.dw_main2.RowCount() <= 0 then
		tab_1.tabpage_2.dw_main2.setfocus()
		return
	end if
	
   gs_code = tab_1.tabpage_2.dw_main2.GetItemString(1, "companycode")
   ls_empno = tab_1.tabpage_2.dw_main2.GetItemString(1, "empno")
   ls_eduyear = tab_1.tabpage_2.dw_main2.GetItemString(1, "p5_educations_p_eduyear")
   ll_empseq = tab_1.tabpage_2.dw_main2.GetItemNumber(1, "empseq")
   ls_bgubn = tab_1.tabpage_2.dw_main2.GetItemString(1, "bgubn")

   if ls_empno="" or isnull(ls_empno) then
	  MessageBox("확 인", "사번은 필수 입력사항입니다.!!")
	  dw_emp.SetColumn('empno')
	  dw_emp.setfocus()
      return	  
	end if
  
   if ls_eduyear="" or isnull(ls_eduyear) then
	  MessageBox("확 인", "계획년도는 필수 입력사항입니다.!!")
      return	
	end if
	
   if ll_empseq=0 or isnull(ll_empseq) then	
	  MessageBox("확 인", "일련번호는 필수 입력사항입니다.!!")
      return	
	end if
   if gs_code="" or isnull(gs_code) then
	  MessageBox("확 인", "법인코드는 필수 입력사항입니다.!!")
      return
	end if
		
   if ls_bgubn="" or isnull(ls_bgubn) then		
	  MessageBox("확 인", "자료구분은 필수 입력사항입니다.!!")
      return	
   end if
	
  tab_1.tabpage_2.dw_main2.setredraw(false)	
  
  if tab_1.tabpage_2.dw_main2.Retrieve(Gs_code, ls_empno, ls_eduyear, &
                                       ll_empseq, ls_bgubn) <= 0 then
	  MessageBox("확 인", "검색된 교육신청등록 자료가 ~r존재하지 않습니다.!!")

     tab_1.tabpage_2.dw_main2.setredraw(true)		

      wf_init()			

    	ls_gub = '등록'    // 등록 mode      
      WF_SETTING_RETRIEVEMODE(ls_gub)						 

      tab_1.tabpage_2.dw_main2.SetItem(1, 'p5_educations_p_eduyear', ls_eduyear)
	   tab_1.tabpage_2.dw_main2.SetItem(1, 'empseq', ll_empseq)

		tab_1.tabpage_2.dw_main2.setfocus()
   	tab_1.tabpage_2.dw_main2.SetColumn('p5_educations_p_prostate')
	   return
  else
      tab_1.tabpage_2.dw_main2.setredraw(true)			
   	
		ls_gub = '조회'    //  조회 mode		
	   ib_any_typing = false

      WF_SETTING_RETRIEVEMODE(ls_gub)				

      tab_1.tabpage_2.dw_main2.Setfocus()
   	tab_1.tabpage_2.dw_main2.SetColumn('p5_educations_p_prostate')
  end if
  dw_emp.enabled = false
end if

end event

type p_print from w_inherite_standard`p_print within w_pig2001
integer x = 3904
integer y = 4064
end type

type p_can from w_inherite_standard`p_can within w_pig2001
end type

event p_can::clicked;call super::clicked;dw_emp.setredraw(false)
tab_1.tabpage_1.dw_main1.setredraw(false)
tab_1.tabpage_2.dw_main2.setredraw(false)

tab_1.tabpage_1.dw_main1.reset()
tab_1.tabpage_1.dw_main1.insertrow(0)		
tab_1.tabpage_1.dw_main1.setfocus()		
//tab_1.tabpage_1.dw_main1.enabled = true


tab_1.tabpage_2.dw_main2.reset()
tab_1.tabpage_2.dw_main2.insertrow(0)		
tab_1.tabpage_2.dw_main2.setfocus()		
//tab_1.tabpage_2.dw_main2.enabled = true

dw_emp.reset()
dw_emp.insertrow(0)
dw_emp.setfocus()
dw_emp.setColumn("empno")

dw_emp.enabled = true
tab_1.tabpage_1.dw_main1.enabled = false
tab_1.tabpage_2.dw_main2.enabled = false

dw_emp.setredraw(true)
tab_1.tabpage_1.dw_main1.setredraw(true)
tab_1.tabpage_2.dw_main2.setredraw(true)		

tab_1.tabpage_1.dw_main1.SetTaborder('p5_educations_p_eduyear',10)
tab_1.tabpage_1.dw_main1.SetTaborder('empseq',20)

tab_1.tabpage_2.dw_main2.SetTaborder('p5_educations_p_eduyear',10)
tab_1.tabpage_2.dw_main2.SetTaborder('empseq',20)

p_can.enabled = false 

//choose case tab_1.selectedTab
//     case 1
//		wf_init()
//		ib_any_typing = false
//		tab_1.tabpage_1.dw_main1.SetColumn('p5_educations_p_eduyear')
//		tab_1.tabpage_1.dw_main1.setfocus()
//     case 2
//		wf_init()
//		ib_any_typing = false
//		tab_1.tabpage_2.dw_main2.SetColumn('p5_educations_p_eduyear')
//		tab_1.tabpage_2.dw_main2.setfocus()
//end choose
//
end event

type p_exit from w_inherite_standard`p_exit within w_pig2001
end type

type p_ins from w_inherite_standard`p_ins within w_pig2001
integer x = 4096
integer y = 4060
end type

type p_search from w_inherite_standard`p_search within w_pig2001
integer x = 3730
integer y = 4064
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig2001
integer x = 4270
integer y = 4060
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig2001
integer x = 4443
integer y = 4060
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig2001
integer x = 178
integer y = 3656
end type

type st_window from w_inherite_standard`st_window within w_pig2001
integer x = 2272
integer y = 4104
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig2001
integer x = 3269
integer y = 3932
integer taborder = 80
end type

type cb_update from w_inherite_standard`cb_update within w_pig2001
integer x = 2194
integer y = 3932
integer taborder = 30
end type

event cb_update::clicked;call super::clicked;string ls_company, ls_empno, ls_eduyear, &
       ls_totchk, ls_sdate, ls_edate, get_eduyear
		 
long ll_empseq, ll_row, ll_cnt, get_seq, get_empseq
Long sCount

choose case tab_1.selectedtab
	case 1
		if dw_emp.AcceptText() = -1 then return
		if tab_1.tabpage_1.dw_main1.AcceptText() = -1 then return
		
		ll_row = tab_1.tabpage_1.dw_main1.getrow()
		
		if ll_row <= 0 then return
		
		ls_company = gs_company
		ls_empno = dw_emp.GetItemString(1, 'empno')
		ls_eduyear = tab_1.tabpage_1.dw_main1.GetItemString(ll_row, 'p5_educations_p_eduyear')
		ll_empseq  = tab_1.tabpage_1.dw_main1.GetItemNumber(ll_row, 'empseq')
		
		/*수정부분*/
	   SELECT count("P5_EDUCATIONS_P"."EMPNO")  
        INTO :sCount  
		  FROM "P5_EDUCATIONS_P"  
		 WHERE  ( "P5_EDUCATIONS_P"."COMPANYCODE" =:gs_company ) AND  
		   	  ( "P5_EDUCATIONS_P"."EMPNO"   =:ls_empno ) AND  
				  ( "P5_EDUCATIONS_P"."EDUYEAR" =:ls_eduyear ) AND  
				  ( "P5_EDUCATIONS_P"."EMPSEQ"  =:ll_empseq )   ;
        IF sCount >= 1 THEN
		    if  MessageBox("확 인","동일한 자료가 존재합니다."+ "~n" + &
			             "저장하시겠습니까?",Question!,YesNo!) = 2 then return
			
		  END IF
		 		
		// 필수 입력항목 check
		// 1 은 교육계획 tabpabe
		if wf_requiredchk(1, ll_row) = -1 then return
		
      // 총무과에서 확인이 되어 있으면 자료 입력 불가
		
		SELECT "P5_EDUCATIONS_S"."EDUYEAR", 
		       "P5_EDUCATIONS_S"."EMPSEQ",  COUNT(*)   
		INTO  :get_eduyear, 
		      :get_empseq, :get_seq   
		 FROM "P5_EDUCATIONS_S"    
		 WHERE "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company  AND    
				 "P5_EDUCATIONS_S"."EMPNO"  = :ls_empno    AND       
				 "P5_EDUCATIONS_S"."PEDUYEAR"  = :ls_eduyear AND     
				 "P5_EDUCATIONS_S"."PEMPSEQ"  = :ll_empseq AND   
				 "P5_EDUCATIONS_S"."ISU"  = 'Y' AND  
				 "P5_EDUCATIONS_S"."BGUBN"  = 'P'      
		GROUP BY "P5_EDUCATIONS_S"."EDUYEAR",    
		         "P5_EDUCATIONS_S"."EMPSEQ" ;   
				  
		if sqlca.sqlcode = 0 and get_seq > 0 then 
			MessageBox("확 인", "실적번호 : " + "~"" + string(get_empseq) + "~"로 " + &
									  "이미 이수처리된 자료입니다.!!" + "~n" + "~n" + &
									  "자료를 수정하거나 삭제할 후 없습니다.!!")
	     ib_any_typing = false									  									  
			return 
		end if 
		if sqlca.sqlcode < 0 then 
			MessageBox("확 인", "저장중 에러 발생(실적조회)")
			return 
		end if 
		
		
		ls_totchk   =  tab_1.tabpage_1.dw_main1.GetItemString(ll_row, 'p5_educations_p_totchk')  		
		
      if ls_totchk = "Y" then
       	MessageBox("확 인", "이미 총무에서 확인이 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 수정할 수 없습니다.")
	     ib_any_typing = false									  							  
    	   return
      end if 
		
		
		if ls_gub = '등록' then
			if wf_count() = -1 then return //자동채번
		end if
		
		if f_msg_update() = -1 then return
				
      if tab_1.tabpage_1.dw_main1.update() <> 1 then
    	   rollback using sqlca;
         sle_msg.text ="자료를 저장하지 못하였습니다.!!"		  			 
   	   return
      end if
		commit using sqlca;
      sle_msg.text ="자료를 저장하였습니다.!!"				
		
	case 2
		if dw_emp.AcceptText() = -1 then return		
		if tab_1.tabpage_2.dw_main2.AcceptText() = -1 then return
		
		ll_row = tab_1.tabpage_2.dw_main2.getrow()

		if ll_row <= 0 then return

		ls_company = gs_company		
		
		ls_empno = dw_emp.GetItemString(1, 'empno')
		ls_eduyear = tab_1.tabpage_2.dw_main2.GetItemString(ll_row, 'p5_educations_p_eduyear')
		ll_empseq = tab_1.tabpage_2.dw_main2.GetItemNumber(ll_row, 'empseq')
		
		/*수정부분*/
		SELECT count("P5_EDUCATIONS_P"."EMPNO")  
        INTO :sCount  
		  FROM "P5_EDUCATIONS_P"  
		 WHERE  ( "P5_EDUCATIONS_P"."COMPANYCODE" =:gs_company ) AND  
		   	  ( "P5_EDUCATIONS_P"."EMPNO"   =:ls_empno ) AND  
				  ( "P5_EDUCATIONS_P"."EDUYEAR" =:ls_eduyear ) AND  
				  ( "P5_EDUCATIONS_P"."EMPSEQ"  =:ll_empseq )   ;
        IF sCount >= 1 THEN
			 if  MessageBox("확 인","동일한 자료가 존재합니다."+ "~n" + &
			             "저장하시겠습니까?",Question!,YesNo!) = 2 then return
			  Return 
		  END IF
		 	
		// 필수 입력항목 check
		// 2 는 교육신청 tabpabe
		if wf_requiredchk(2, ll_row) = -1 then return
		
		SELECT "P5_EDUCATIONS_S"."EDUYEAR", 
		       "P5_EDUCATIONS_S"."EMPSEQ",  COUNT(*)   
		INTO   :get_eduyear, :get_empseq, :get_seq   
		 FROM "P5_EDUCATIONS_S"    
		 WHERE "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company  AND    
				 "P5_EDUCATIONS_S"."EMPNO"  = :ls_empno    AND       
				 "P5_EDUCATIONS_S"."PEDUYEAR"  = :ls_eduyear AND     
				 "P5_EDUCATIONS_S"."PEMPSEQ"  = :ll_empseq AND   
				 "P5_EDUCATIONS_S"."ISU"  = 'Y' AND  
				 "P5_EDUCATIONS_S"."BGUBN"  = 'R'      
		GROUP BY "P5_EDUCATIONS_S"."EDUYEAR", 
		         "P5_EDUCATIONS_S"."EMPSEQ" ;   
				  
		if sqlca.sqlcode = 0 and get_seq > 0 then 
			MessageBox("확 인", "실적번호 : " + "~"" + string(get_empseq) + "~"로 " + &
									  "이미 이수처리된 자료입니다.!!" + "~n" + "~n" + &
									  "자료를 수정하거나 삭제할 후 없습니다.!!")
	     ib_any_typing = false									  									  
			return 
		end if 
		if sqlca.sqlcode < 0 then 
			MessageBox("확 인", "저장중 에러 발생(실적조회)")
			return 
		end if 



      // 총무과에서 확인이 되어 있으면 자료 입력 불가
		
		ls_totchk   =  tab_1.tabpage_2.dw_main2.GetItemString(ll_row, 'p5_educations_p_totchk')
		
      if ls_totchk = "Y" then
       	MessageBox("확 인", "이미 총무에서 확인이 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 수정할 수 없습니다.")
	     ib_any_typing = false									  							  
    	   return
      end if 
		
		
		if ls_gub = '등록' then
			if wf_count() = -1 then return //자동채번
		end if
		
		if f_msg_update() = -1 then return

      if tab_1.tabpage_2.dw_main2.update() <> 1 then
        rollback using sqlca;
        sle_msg.text ="자료를 저장하지 못하였습니다.!!"		  
        return 
      end if
		commit using sqlca;
      sle_msg.text ="자료를 저장하였습니다.!!"		
END CHOOSE

// 이미 저장이 되었음을 나타냄
ls_gub = '조회'

WF_SETTING_RETRIEVEMODE(ls_gub)

ib_any_typing = false
end event

type cb_insert from w_inherite_standard`cb_insert within w_pig2001
integer x = 197
integer y = 3932
integer width = 421
integer taborder = 70
string text = "신청서출력"
end type

event cb_insert::clicked;call super::clicked;open(w_pig2020_1)
end event

type cb_delete from w_inherite_standard`cb_delete within w_pig2001
integer x = 2565
integer y = 3932
integer taborder = 40
end type

event cb_delete::clicked;call super::clicked;string ls_totchk, ls_company, ls_empno, ls_eduyear, &
       get_eduyear


long ll_empseq, get_empseq, get_seq   
int il_currow

choose case tab_1.selectedtab
	case 1

      if dw_emp.AcceptText() = -1 then return 
		if tab_1.tabpage_1.dw_main1.AcceptText() = -1 then return 
		
		il_currow = tab_1.tabpage_1.dw_main1.GetRow()
		
      IF il_currow <=0 Then Return		
		
		ls_company = gs_company
		ls_empno = dw_emp.GetItemString(1, 'empno')
		ls_eduyear = tab_1.tabpage_1.dw_main1.GetItemString(il_currow, &
		            'p5_educations_p_eduyear')
		ll_empseq = tab_1.tabpage_1.dw_main1.GetItemNumber(il_currow, 'empseq')
		
		
		SELECT "P5_EDUCATIONS_S"."EDUYEAR", 
		       "P5_EDUCATIONS_S"."EMPSEQ",  COUNT(*)   
		INTO  :get_eduyear, 
		      :get_empseq, :get_seq   
		 FROM "P5_EDUCATIONS_S"    
		 WHERE "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company  AND    
				 "P5_EDUCATIONS_S"."EMPNO"  = :ls_empno    AND       
				 "P5_EDUCATIONS_S"."PEDUYEAR"  = :ls_eduyear AND     
				 "P5_EDUCATIONS_S"."PEMPSEQ"  = :ll_empseq AND   
				 "P5_EDUCATIONS_S"."ISU"  = 'Y' AND  
				 "P5_EDUCATIONS_S"."BGUBN"  = 'P'      
		GROUP BY "P5_EDUCATIONS_S"."EDUYEAR", 
		         "P5_EDUCATIONS_S"."EMPSEQ" ;   
				  
		if sqlca.sqlcode = 0 and get_seq > 0 then 
			MessageBox("확 인", "실적번호 : " + "~"" + string(get_empseq) + "~"로 " + &
									  "이미 이수처리된 자료입니다.!!" + "~n" + "~n" + &
									  "자료를 수정하거나 삭제할 후 없습니다.!!")
	     ib_any_typing = false									  
   		return 
		end if 
		if sqlca.sqlcode < 0 then 
			MessageBox("확 인", "저장중 에러 발생(실적조회)")
			return 
		end if 		
		
		ls_totchk   =  tab_1.tabpage_1.dw_main1.GetItemString(il_currow, 'p5_educations_p_totchk')
                     // 총무과에서 확인이 되어 있으면 자료 입력 불가

      if ls_totchk = "Y" then
       	MessageBox("확 인", "이미 총무에서 확인이 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 삭제할 수 없습니다.")
		  ib_any_typing = false
    	   return
      end if 
		
		if f_msg_delete() = -1 then return

      tab_1.tabpage_1.dw_main1.SetRedraw(false)		
      tab_1.tabpage_1.dw_main1.DeleteRow(il_currow)

		
      if tab_1.tabpage_1.dw_main1.update() <> 1 then
			MessageBox("확 인", "교육계획등록 자료를 삭제하는 도중, ~r~r오류가 발생하였습니다.!!")			
    	   rollback using sqlca;
         ib_any_typing =True
         tab_1.tabpage_1.dw_main1.SetRedraw(true)

   	   return 1
      end if
		commit using sqlca;
		
      tab_1.tabpage_1.dw_main1.SetRedraw(true)			
		
		wf_init()		
	case 2
		
		
      if dw_emp.AcceptText() = -1 then return 
		if tab_1.tabpage_2.dw_main2.AcceptText() = -1 then return 
		

		il_currow = tab_1.tabpage_2.dw_main2.GetRow()
		
      IF il_currow <=0 Then Return		

		ls_company = gs_company		
		ls_empno = dw_emp.GetItemString(1, 'empno')
		ls_eduyear = tab_1.tabpage_2.dw_main2.GetItemString(il_currow, 'p5_educations_p_eduyear')
		ll_empseq = tab_1.tabpage_2.dw_main2.GetItemNumber(il_currow, 'empseq')

		SELECT "P5_EDUCATIONS_S"."EDUYEAR", 
		       "P5_EDUCATIONS_S"."EMPSEQ",  COUNT(*)   
		INTO  :get_eduyear, 
		      :get_empseq, :get_seq   
		 FROM "P5_EDUCATIONS_S"    
		 WHERE "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company  AND    
				 "P5_EDUCATIONS_S"."EMPNO"  = :ls_empno    AND       
				 "P5_EDUCATIONS_S"."PEDUYEAR"  = :ls_eduyear AND     
				 "P5_EDUCATIONS_S"."PEMPSEQ"  = :ll_empseq AND   
				 "P5_EDUCATIONS_S"."ISU"  = 'Y' AND  
				 "P5_EDUCATIONS_S"."BGUBN"  = 'R'      
		GROUP BY "P5_EDUCATIONS_S"."EDUYEAR", 
		         "P5_EDUCATIONS_S"."EMPSEQ" ;   
				  
		if sqlca.sqlcode = 0 and get_seq > 0 then 
			MessageBox("확 인", "실적번호 : " + "~"" + string(get_empseq) + "~"로 " + &
									  "이미 이수처리된 자료입니다.!!" + "~n" + "~n" + &
									  "자료를 수정하거나 삭제할 후 없습니다.!!")
	     ib_any_typing = false									  									  
			return 
		end if 
		if sqlca.sqlcode < 0 then 
			MessageBox("확 인", "저장중 에러 발생(실적조회)")
			return 
		end if 		
		

		ls_totchk   =  tab_1.tabpage_2.dw_main2.GetItemString(il_currow, 'p5_educations_p_totchk')
                     // 총무과에서 확인이 되어 있으면 자료 입력 불가

      if ls_totchk = "Y" then
       	MessageBox("확 인", "이미 총무에서 확인이 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 삭제할 수 없습니다.")
	     ib_any_typing = false									  							  
    	   return
      end if 
		
		
		if f_msg_delete() = -1 then return
		
      tab_1.tabpage_2.dw_main2.DeleteRow(il_currow)
		
      tab_1.tabpage_1.dw_main1.SetRedraw(false)		
		
      if tab_1.tabpage_2.dw_main2.update() <> 1 then
			MessageBox("확 인", "교육신청등록 자료를 삭제하는 도중, ~r~r 오류가 발생하였습니다.!!")			
    	   rollback using sqlca;
         tab_1.tabpage_1.dw_main1.SetRedraw(true)			 
         ib_any_typing =True
   	   return 1
      end if
		
		commit using sqlca;
      tab_1.tabpage_1.dw_main1.SetRedraw(true)						
   	wf_init()
END CHOOSE

// 이미 저장이 되었음을 나타냄
ls_gub = "등록"

WF_SETTING_RETRIEVEMODE(ls_gub)

ib_any_typing = false
sle_msg.text ="자료를 삭제하였습니다!!"

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig2001
integer x = 1824
integer y = 3932
integer taborder = 60
end type

event cb_retrieve::clicked;call super::clicked;string ls_code, ls_empno, ls_eduyear, &
       ls_bgubn
long ll_empseq

if tab_1.selectedtab = 1 then
	
	tab_1.tabpage_1.dw_main1.AcceptText()
	
	if tab_1.tabpage_1.dw_main1.RowCount() <= 0 then
		tab_1.tabpage_1.dw_main1.setfocus()
		return
	end if
  gs_code = tab_1.tabpage_1.dw_main1.GetItemString(1, "companycode")
  ls_empno = tab_1.tabpage_1.dw_main1.GetItemString(1, "empno")
  ls_eduyear = tab_1.tabpage_1.dw_main1.GetItemString(1, "p5_educations_p_eduyear")
  ll_empseq = tab_1.tabpage_1.dw_main1.GetItemNumber(1, "empseq")
  ls_bgubn = tab_1.tabpage_1.dw_main1.GetItemString(1, "bgubn")

  if ls_empno="" or isnull(ls_empno) then
	  MessageBox("확 인", "사번은 필수 입력사항입니다.!!")
	  dw_emp.SetColumn('empno')
	  dw_emp.setfocus()
     return	  
  end if 
  
  if ls_eduyear="" or isnull(ls_eduyear) then
	  MessageBox("확 인", "계획년도는 필수 입력사항입니다.!!")
     return	
  end if
  
  if ll_empseq=0 or isnull(ll_empseq) then	
	  MessageBox("확 인", "일련번호는 필수 입력사항입니다.!!")
     return	
  end if

  if gs_code="" or isnull(gs_code) then
	  MessageBox("확 인", "법인코드는 필수 입력사항입니다.!!")
     return
  end if
	  
  if ls_bgubn="" or isnull(ls_bgubn) then		
	  MessageBox("확 인", "자료구분은 필수 입력사항입니다.!!")
     return	
  end if
  
  tab_1.tabpage_1.dw_main1.setredraw(false)
  
  if tab_1.tabpage_1.dw_main1.Retrieve(Gs_code, ls_empno, ls_eduyear, &
                                       ll_empseq, ls_bgubn) <= 0 then
	  MessageBox("확 인", "검색된 교육계획등록 자료가 ~r존재하지 않습니다.!!")
     wf_init()		  
	  
     ls_gub= "등록"    // 등록 mode	  
     WF_SETTING_RETRIEVEMODE(ls_gub)	  

     tab_1.tabpage_1.dw_main1.SetItem(1, 'p5_educations_p_eduyear', ls_eduyear)
	  tab_1.tabpage_1.dw_main1.SetItem(1, 'empseq', ll_empseq)
     tab_1.tabpage_1.dw_main1.SetColumn('p5_educations_p_prostate')			  
     tab_1.tabpage_1.dw_main1.setredraw(true)			  	  
     return
  else
   	ib_any_typing = false
   	ls_gub= "조회"    // 조회 mode
      WF_SETTING_RETRIEVEMODE(ls_gub)		

      tab_1.tabpage_1.dw_main1.Setfocus()
   	tab_1.tabpage_1.dw_main1.SetColumn('p5_educations_p_prostate')		
      tab_1.tabpage_1.dw_main1.setredraw(true)			
  end if
  dw_emp.enabled = false
  
elseif tab_1.selectedtab = 2 then
	
	tab_1.tabpage_2.dw_main2.AcceptText()
	
	if tab_1.tabpage_2.dw_main2.RowCount() <= 0 then
		tab_1.tabpage_2.dw_main2.setfocus()
		return
	end if
	
   gs_code = tab_1.tabpage_2.dw_main2.GetItemString(1, "companycode")
   ls_empno = tab_1.tabpage_2.dw_main2.GetItemString(1, "empno")
   ls_eduyear = tab_1.tabpage_2.dw_main2.GetItemString(1, "p5_educations_p_eduyear")
   ll_empseq = tab_1.tabpage_2.dw_main2.GetItemNumber(1, "empseq")
   ls_bgubn = tab_1.tabpage_2.dw_main2.GetItemString(1, "bgubn")

   if ls_empno="" or isnull(ls_empno) then
	  MessageBox("확 인", "사번은 필수 입력사항입니다.!!")
	  dw_emp.SetColumn('empno')
	  dw_emp.setfocus()
      return	  
	end if
  
   if ls_eduyear="" or isnull(ls_eduyear) then
	  MessageBox("확 인", "계획년도는 필수 입력사항입니다.!!")
      return	
	end if
	
   if ll_empseq=0 or isnull(ll_empseq) then	
	  MessageBox("확 인", "일련번호는 필수 입력사항입니다.!!")
      return	
	end if
   if gs_code="" or isnull(gs_code) then
	  MessageBox("확 인", "법인코드는 필수 입력사항입니다.!!")
      return
	end if
		
   if ls_bgubn="" or isnull(ls_bgubn) then		
	  MessageBox("확 인", "자료구분은 필수 입력사항입니다.!!")
      return	
   end if
	
  tab_1.tabpage_2.dw_main2.setredraw(false)	
  
  if tab_1.tabpage_2.dw_main2.Retrieve(Gs_code, ls_empno, ls_eduyear, &
                                       ll_empseq, ls_bgubn) <= 0 then
	  MessageBox("확 인", "검색된 교육신청등록 자료가 ~r존재하지 않습니다.!!")

     tab_1.tabpage_2.dw_main2.setredraw(true)		

      wf_init()			

    	ls_gub = '등록'    // 등록 mode      
      WF_SETTING_RETRIEVEMODE(ls_gub)						 

      tab_1.tabpage_2.dw_main2.SetItem(1, 'p5_educations_p_eduyear', ls_eduyear)
	   tab_1.tabpage_2.dw_main2.SetItem(1, 'empseq', ll_empseq)

		tab_1.tabpage_2.dw_main2.setfocus()
   	tab_1.tabpage_2.dw_main2.SetColumn('p5_educations_p_prostate')
	   return
  else
      tab_1.tabpage_2.dw_main2.setredraw(true)			
   	
		ls_gub = '조회'    //  조회 mode		
	   ib_any_typing = false

      WF_SETTING_RETRIEVEMODE(ls_gub)				

      tab_1.tabpage_2.dw_main2.Setfocus()
   	tab_1.tabpage_2.dw_main2.SetColumn('p5_educations_p_prostate')
  end if
  dw_emp.enabled = false
end if

end event

type st_1 from w_inherite_standard`st_1 within w_pig2001
integer x = 105
integer y = 4104
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig2001
integer x = 2898
integer y = 3932
integer taborder = 50
end type

event cb_cancel::clicked;call super::clicked;dw_emp.setredraw(false)
tab_1.tabpage_1.dw_main1.setredraw(false)
tab_1.tabpage_2.dw_main2.setredraw(false)

tab_1.tabpage_1.dw_main1.reset()
tab_1.tabpage_1.dw_main1.insertrow(0)		
tab_1.tabpage_1.dw_main1.setfocus()		
//tab_1.tabpage_1.dw_main1.enabled = true


tab_1.tabpage_2.dw_main2.reset()
tab_1.tabpage_2.dw_main2.insertrow(0)		
tab_1.tabpage_2.dw_main2.setfocus()		
//tab_1.tabpage_2.dw_main2.enabled = true

dw_emp.reset()
dw_emp.insertrow(0)
dw_emp.setfocus()
dw_emp.setColumn("empno")

dw_emp.enabled = true
tab_1.tabpage_1.dw_main1.enabled = false
tab_1.tabpage_2.dw_main2.enabled = false

dw_emp.setredraw(true)
tab_1.tabpage_1.dw_main1.setredraw(true)
tab_1.tabpage_2.dw_main2.setredraw(true)		

tab_1.tabpage_1.dw_main1.SetTaborder('p5_educations_p_eduyear',10)
tab_1.tabpage_1.dw_main1.SetTaborder('empseq',20)

tab_1.tabpage_2.dw_main2.SetTaborder('p5_educations_p_eduyear',10)
tab_1.tabpage_2.dw_main2.SetTaborder('empseq',20)

cb_delete.enabled = false 

//choose case tab_1.selectedTab
//     case 1
//		wf_init()
//		ib_any_typing = false
//		tab_1.tabpage_1.dw_main1.SetColumn('p5_educations_p_eduyear')
//		tab_1.tabpage_1.dw_main1.setfocus()
//     case 2
//		wf_init()
//		ib_any_typing = false
//		tab_1.tabpage_2.dw_main2.SetColumn('p5_educations_p_eduyear')
//		tab_1.tabpage_2.dw_main2.setfocus()
//end choose
//
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pig2001
integer x = 2917
integer y = 4104
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig2001
integer x = 434
integer y = 4104
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig2001
integer x = 1765
integer y = 3872
integer width = 1934
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig2001
integer x = 123
integer y = 3872
integer width = 503
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig2001
integer x = 87
integer y = 4052
end type

type dw_emp from datawindow within w_pig2001
event ue_key pbm_dwnprocessenter
event ue_f1 pbm_dwnkey
integer x = 818
integer y = 144
integer width = 2505
integer height = 196
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig2001_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_f1;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String 	sEmpNo, sEmpName, sEnterDate, snull, is_empno
Int      il_RowCount
			
SetNull(snull)


//if dw_emp.Accepttext() = -1 then return

w_mdi_frame.sle_msg.text = ''


sempno = dw_emp.getitemstring(1,"empno")

//sle_msg.text = '자료 조회 중'

SetPointer(HourGlass!)

If dw_emp.GetColumnName() = "empno" /*and (sempno = "" or isnull(sempno))*/ Then
	sempno = this.GetText()
 	IF IsNull(wf_exiting_data(dw_emp.GetColumnName(),sempno,"1")) THEN	
  	   MessageBox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다.!!")
   	dw_emp.enabled = true
      w_mdi_frame.sle_msg.text = ''
      SetPointer(Arrow!)
   	tab_1.tabpage_1.dw_main1.enabled = false
   	tab_1.tabpage_2.dw_main2.enabled = false
     	Return 1
   end if
	dw_emp.enabled = false
  	tab_1.tabpage_1.dw_main1.enabled = true
  	tab_1.tabpage_2.dw_main2.enabled = true
end if

tab_1.tabpage_1.dw_main1.SetRedraw(false)
tab_1.tabpage_2.dw_main2.SetRedraw(false)

dw_emp.Retrieve(gs_company, sempno)

tab_1.tabpage_1.dw_main1.reset()
tab_1.tabpage_2.dw_main2.reset()

is_empno = dw_emp.GetItemString(1, "empno")

il_RowCount = tab_1.tabpage_1.dw_main1.insertrow(0)
tab_1.tabpage_1.dw_main1.setitem(il_RowCount, "companycode", gs_company)				
tab_1.tabpage_1.dw_main1.setitem(il_RowCount, "empno", is_empno)		

//년도 setting
tab_1.tabpage_1.dw_main1.setitem(il_RowCount, "p5_educations_p_eduyear", &
                                  string(today(), 'YYYY'))

//자료구분(P : 계획자료, R : 신청자료)을 SETTING		
tab_1.tabpage_1.dw_main1.setitem(il_RowCount, "bgubn", "P")
tab_1.tabpage_1.dw_main1.SetItemStatus(il_RowCount, 0,Primary!, NotModified!)
tab_1.tabpage_1.dw_main1.SetItemStatus(il_RowCount, 0,Primary!, New!)

tab_1.tabpage_2.dw_main2.insertrow(0)		
tab_1.tabpage_2.dw_main2.setitem(il_RowCount, "companycode", gs_company)				
tab_1.tabpage_2.dw_main2.setitem(il_RowCount, "empno", is_empno)		

//년도 setting
tab_1.tabpage_2.dw_main2.setitem(il_RowCount, "p5_educations_p_eduyear", & 
                                 string(today(), 'YYYY'))


//자료구분(P : 계획자료, R : 신청자료)을 SETTING		
tab_1.tabpage_2.dw_main2.setitem(il_RowCount, "bgubn", "R")

tab_1.tabpage_2.dw_main2.SetItemStatus(il_RowCount, 0,Primary!, NotModified!)
tab_1.tabpage_2.dw_main2.SetItemStatus(il_RowCount, 0,Primary!, New!)

tab_1.tabpage_1.dw_main1.SetRedraw(true)
tab_1.tabpage_2.dw_main2.SetRedraw(true)

w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)

// 새로운 등록이면 false, 조회면 true
ls_gub = "등록"
WF_SETTING_RETRIEVEMODE(ls_gub)	  

ib_any_typing = False

//tab_1.selectedtab = 1
tab_1.tabpage_1.dw_main1.setcolumn('p5_educations_p_eduyear')
tab_1.tabpage_1.dw_main1.setfocus()


end event

event itemfocuschanged;IF dwo.name = "empno" then
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event rbuttondown;int il_count

SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()

IF This.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(), "empno", Gs_code)

	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemerror;return 1
end event

type tab_1 from tab within w_pig2001
integer x = 805
integer y = 428
integer width = 3195
integer height = 1608
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3159
integer height = 1496
long backcolor = 32106727
string text = "교육계획등록"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 553648127
dw_main1 dw_main1
end type

on tabpage_1.create
this.dw_main1=create dw_main1
this.Control[]={this.dw_main1}
end on

on tabpage_1.destroy
destroy(this.dw_main1)
end on

type dw_main1 from datawindow within tabpage_1
event ue_key pbm_dwnprocessenter
event ue_f1 pbm_dwnkey
integer x = 119
integer y = 60
integer width = 2985
integer height = 1324
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig2001_2"
boolean border = false
boolean livescroll = true
end type

event ue_key;Send( Handle(this), 256, 9, 0 )

Return 1
end event

event ue_f1;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string sedept, sdeptcode, sdeptcodename, ls_eduyear, ls_empno, &
       ls_startdate, ls_enddate, ls_starttime, ls_endtime, &
		 ls_bgubn, ls_educur, get_educur, snull
		 
string temp_date1, temp_date2

long ll_empseq, ll_cnt, ll_time1, ll_time2, ll_datesu

setNull(Gs_code)
SetNull(snull)

// 계획년도
//날짜 유효 값 CHECK
if this.GetColumnName() = 'p5_educations_p_eduyear'  then 
	ls_eduyear = this.GetText()
	if trim(ls_eduyear) = "" or isnull(ls_eduyear) then 
		MessageBox("확 인", "계획년도는 필수 입력사항입니다.!!")
		return 1
	end if
	if f_datechk(ls_eduyear + '01'+ '01') = -1 then 
		MessageBox("확 인", "유효한 년도가 아닙니다.")
		Return 1
	end if
end if

// 순번
if this.GetColumnName() = 'empseq' then 
	ll_empseq = long(this.GetText())
	if trim(string(ll_empseq)) = "" or isnull(ll_empseq) then
		ls_gub = '등록'			
		return
	end if

	if dw_emp.AcceptText() = -1 then return 
	
	ls_empno = dw_emp.GetItemString(1, 'empno')

	gs_code = this.GetItemString(1, "companycode")
	ls_eduyear = this.GetItemstring(1, 'p5_educations_p_eduyear')
	ls_bgubn = this.GetItemstring(1, 'bgubn')
	
   this.setredraw(false)
	
	if this.Retrieve(Gs_code, ls_empno, ls_eduyear, & 
													 ll_empseq, ls_bgubn) <= 0 then
		wf_init()
		ls_gub= "등록"    // 등록 mode	  
		WF_SETTING_RETRIEVEMODE(ls_gub)	  
	
		this.SetItem(1, 'p5_educations_p_eduyear', ls_eduyear)
		this.SetItem(1, 'empseq', ll_empseq)
		this.SetColumn('p5_educations_p_prostate')			  
		this.setredraw(true)			  	  
		return
	else
		
		ib_any_typing = false
		ls_gub= "조회"    // 조회 mode
		WF_SETTING_RETRIEVEMODE(ls_gub)		
	
		this.Setfocus()
		this.SetColumn('p5_educations_p_prostate')		
		this.setredraw(true)			
	end if
	dw_emp.enabled = false
end if

// 교육 시작일자
if this.GetColumnName() = 'startdate'   then
	this.Accepttext()
	ls_startdate = this.GetItemstring(1, 'startdate')	
	ls_enddate = this.GetItemstring(1, 'enddate')		
	
	if isnull(ls_startdate) or trim(ls_startdate) = "" then 
		MessageBox("확 인", "교육 시작일자는 필수입력사항입니다.!!")			
		return 1
	end if
	
	If f_datechk(ls_startdate) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	end if
	
	//종료일자가 존재하지 않으면, 시작일자를 입력한다.
	if isnull(ls_enddate) or trim(ls_enddate) = "" or ls_enddate = "00:00" then 
		ls_enddate = ls_startdate
		this.SetItem(1, 'enddate', ls_enddate)			
	end if
	
	// 총일수를 구하는 function(일수는 구하는데 실패하면 -1, 아니면 총일수 값을 return )
	if wf_date(ls_startdate, ls_enddate) = -1 then 
		MessageBox("확 인", "일수를 구하는데 실패하였습니다.!!")
		return 
	else
	  ll_datesu = wf_date(ls_startdate, ls_enddate)			
	end if
	
	this.setItem(1, 'datesu', ll_datesu)		
	
	ll_time1 = Long(this.GetItemString(1, 'temp1'))		
	
	if isnull(ll_time1) or  string(ll_time1) = "" then 
		ll_time1 = 0 
	end if
	
	// 총일수와 총시간을 수정한다.		
	this.setItem(1, 'datesu', ll_datesu)		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    
	
end if 

// 교육 종료일자
if this.GetColumnName() =  'enddate'  then
   ls_enddate = trim(this.GetText())  
   ls_startdate = trim(this.GetItemstring(1, 'startdate'))	
	
	if isnull(ls_enddate) or ls_enddate = "" then 
		MessageBox("확 인", "교육 종료일자는 필수입력사항입니다.!!")
		return 1		
	end if
	If f_datechk(ls_enddate) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	end if

	if  ls_startdate > ls_enddate then
		MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
								 "클 수는 없습니다.!!", stopsign!)
		return 1
	end if

	//종료일자가 존재하지 않으면, 시작일자를 입력한다.
	if isnull(ls_startdate) or ls_startdate = "" then 
		ls_startdate = ls_enddate 
		this.SetItem(1, 'startdate', ls_startdate)						
	end if

	// 총일수를 구하는 function(일수는 구하는데 실패하면 -1, 아니면 총일수 값을 return )
	if wf_date(ls_startdate, ls_enddate) = -1 then 
		MessageBox("확 인", "일수를 구하는데 실패하였습니다.!!")
		return 
	else
	  ll_datesu = wf_date(ls_startdate, ls_enddate)			
	end if

	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu= 0 
	end if
	
	ll_time1 = Long(this.GetItemString(1, 'temp1'))		
	
	if isnull(ll_time1) or string(ll_time1) = "" then 
		ll_time1 = 0 
	end if

	// 총일수와 총시간을 수정한다.		
	this.setItem(1, 'datesu', ll_datesu)		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    

end if

// 교육시작시간
if this.GetColumnName() = 'starttime' then 
	ls_starttime = string(long(trim(this.GetText())), '00:00')
	ls_endtime = string(this.GetItemNumber(1, 'endtime'), '00:00')
	
	if Istime(ls_starttime) = false Then
		MessageBox("확 인", "유효한 시간이 아닙니다.")			
		return 1
	end if
	
	//temp1의 computed field에 들어갈 값
//	  truncate( ((  long(left(string(endtime, '0000'), 2)) * 60  + &
//	  long (right(string(endtime, '0000'), 2))) - (long(left(string(starttime, '0000'), 2)) &
//	  * 60  + long (right(string(starttime, '0000'), 2)) )) / 60, 0)		
	

	
	if isnull(ls_endtime) or trim(ls_endtime) = "" or ls_endtime = '00:00' then
		ls_endtime = this.GetText()
		this.SetItem(1, 'endtime',  long(ls_endtime))			
	end if
	
	ll_datesu = this.GetItemNumber(1, 'datesu')				
	
	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu = 0 
	end if
	
	//		ll_time1 = tab_1.tabpage_1.dw_main1.GetItemNumber(1, 'temp1')		
	if wf_time(ls_starttime, ls_endtime) = -1 then 
		MessageBox("확 인", "시간 산출 에러")
		return 1
	else 
		ll_time1 = wf_time(ls_starttime, ls_endtime)
	end if
	
	if isnull(ll_time1) or string(ll_time1) = ""  then ll_time1 = 0
	
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    		
	
end if


//교육 종료시간
if this.GetColumnName() = 'endtime' then
	ls_endtime = trim(string(long(this.GetText()), '00:00'))
	ls_starttime = string(this.GetItemNumber(1, 'starttime'), '00:00')
	
	if Istime(ls_endtime) = false Then
		MessageBox("확 인", "유효한 시간이 아닙니다.")			
		return 1
	end if
	

	
	if ls_starttime > ls_endtime then
		MessageBox("확 인", "시작 시간이 종료시간보다" + "~n" + & 
								 "클 수는 없습니다.!!")			
		return 1
	end if
	
	if isnull(ls_starttime) or string(ls_starttime) = "" or ls_starttime = "00:00" then
		ls_starttime = this.GetText()
		this.SetItem(1, 'starttime',  long(ls_starttime))			
	end if
	
	ll_datesu = this.GetItemNumber(1, 'datesu')				
	
	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu = 0 
	end if
	
	//		ll_time1 = tab_1.tabpage_1.dw_main1.GetItemNumber(1, 'temp1')		
	if wf_time(ls_starttime, ls_endtime) = -1 then 
		MessageBox("확 인", "시간을 산출 에러")
		return 1
	else 
		ll_time1 = wf_time(ls_starttime, ls_endtime)
	end if
	
	if isnull(ll_time1) or string(ll_time1) = "" then ll_time1 = 0
		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    		
		
end if 

if this.GetColumnName() =  'datesu' then  //교육일수
	ll_datesu = long(trim(this.GetText()))
	
	if isnull(ll_datesu)  or ll_datesu = 0 or string(ll_datesu) = "" then 
		ll_datesu = 0
		this.setItem(1, 'datesu', 0)    		
	end if
	
	// 총교육시간, 교육일수 * 교육시간
	ll_time1 = Long(this.GetItemString(1, 'temp1')) 
	if isnull(ll_time1) or string(ll_time1) = "" then
		ll_time1 = 0 
	end if
	
	this.SetItem(1, 'ehour', ll_datesu * ll_time1)
	
end if


// 교육기관
if this.GetColumnName() = 'eoffice'    then 
	if trim(this.GetText()) = "" or isnull(this.GetText()) then return
end if


// 주관부서
if this.GetColumnName() =  'edept' then 
   sedept = this.GetText()

	if trim(sedept) = "" or isnull(sedept) then return

	select deptcode, deptname
	into   :sdeptcode, :sdeptcodename
	from p0_dept
	where companycode = :gs_company and
			deptcode = :sedept ;
	if sqlca.sqlcode <> 0 then
		MessageBox("확 인", "조회한 자료가 없습니다.")
		return 1
	end if

end if
// 교육과정 추가(1999.09.01)
if this.GetColumnName() =  'eudcur' then 
	ls_educur = trim(this.GetText())
	
	if ls_educur = '' or isnull(ls_educur) then 
		return 
	else
		SELECT "P0_REF"."CODE"   
		INTO :get_educur   
		FROM "P0_REF"  
		WHERE "P0_REF"."CODEGBN" = 'MQ' AND 
				"P0_REF"."CODE" <> '00'  ;
      if sqlca.sqlcode <> 0 then 
			MessageBox("확 인", "조회하신 코드로 자료가 존재하가 않습니다.!!")
    		this.SetItem(1, 'eudcur', snull)						
			return 1
		end if
	end if
end if
end event

event itemerror;return 1
end event

event rbuttondown;

string snull, ls_empno, ls_company, ls_eduyear
int li_count

SetNull(snull)
SetNull(gs_code)

IF This.GetColumnName() = "p5_educations_p_eduyear" or This.GetColumnName() = "empseq" THEN
	ls_eduyear = this.object.p5_educations_p_eduyear[GetRow()]
	
	if isnull(ls_eduyear) then
		ls_eduyear = ""
	end if
	
	Gs_Code  = gs_company
   istr_edu.str_empno   = dw_emp.Getitemstring(1, "empno")  // 사번
   istr_edu.str_eduyear =  ls_eduyear                       // 계획년도
	
   istr_edu.str_empseq  = this.GetitemNumber(1, "empseq")  // 	일련번호
   istr_edu.str_gbn  = this.GetItemString(1, "bgubn")  		// 자료구분(P : 계획자료, R : 신청자료)

	openwithparm(w_edu_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	IF IsNull(Gs_code) THEN RETURN
   IF	IsNull(istr_edu.str_empno) THEN RETURN
   IF	IsNull(istr_edu.str_eduyear) THEN RETURN
   IF	IsNull(istr_edu.str_empseq) THEN RETURN
   IF	IsNull(istr_edu.str_gbn) THEN RETURN	
	
 	this.SetItem(1, "companycode", Gs_code)
 	this.SetItem(1, "empno", istr_edu.str_empno)	 
 	this.SetItem(1, "p5_educations_p_eduyear", istr_edu.str_eduyear)
 	this.SetItem(1, "empseq", istr_edu.str_empseq)
 	this.SetItem(1, "bgubn", istr_edu.str_gbn)

	this.SetColumn('p5_educations_p_eduyear')
	
	p_inq.TriggerEvent(Clicked!)

END IF

IF This.GetColumnName() ="edept" THEN

	Gs_code = this.getText()

	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"edept",gs_code)

	
	this.TriggerEvent(ItemChanged!)
	
END IF

end event

event editchanged;ib_any_typing =True


end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF this.GetColumnName() ="eduteacher" OR this.GetColumnName() ="edudepmentt" OR &
   this.GetColumnName() ="eduarea" OR this.GetColumnName() ="educdesc" OR &
	this.GetColumnName() ="edubook" or this.GetColumnName() ="edubook1" OR &
	this.GetColumnName() ="ekind" or this.GetColumnName() ="educur" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3159
integer height = 1496
long backcolor = 32106727
string text = "추가신청등록"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_main2 dw_main2
end type

on tabpage_2.create
this.dw_main2=create dw_main2
this.Control[]={this.dw_main2}
end on

on tabpage_2.destroy
destroy(this.dw_main2)
end on

type dw_main2 from datawindow within tabpage_2
event ue_key pbm_dwnprocessenter
event ue_f1 pbm_dwnkey
integer x = 123
integer y = 60
integer width = 2985
integer height = 1384
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pig2001_3"
boolean border = false
boolean livescroll = true
end type

event ue_key;if tab_1.tabpage_2.dw_main2.GetColumnName() = 'remark' then 
	return 
end if 

Send( Handle(this), 256, 9, 0 )

Return 1
end event

event ue_f1;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string sedept, sdeptcode, sdeptcodename, ls_eduyear, ls_empno, &
       ls_startdate, ls_enddate, ls_starttime, ls_endtime, &
		 ls_bgubn, snull, ls_educur, get_educur
		 
string temp_date1, temp_date2

int ll_temp1

long ll_empseq, ll_cnt, ll_time1, ll_time2, ll_datesu

setNull(snull)

//계획년도
if this.GetColumnName() = 	'p5_educations_p_eduyear' then 
	
   ls_eduyear = trim(this.GetText())
		
	if ls_eduyear = "" or isnull(ls_eduyear) then 
		MessageBox("확 인", "계획년도는 필수 입력사항입니다.!!", stopsign!)			
		return 1
	end if
	if f_datechk(ls_eduyear + '01' + '01') = -1 then 
		MessageBox("확 인", "유효한 년도가 아닙니다.")
		Return 1
	end if
end if

//순번(일련번호)
if this.GetColumnName() = 'empseq' then 
	ll_empseq = long(trim(this.GetText()))
	if string(ll_empseq) = "" or isnull(ll_empseq) then
		ls_gub = '등록'						
		return
	end if

   if dw_emp.AcceptText() = -1 then return 
	
	ls_empno = dw_emp.GetItemString(1, 'empno')


	
	gs_code = this.GetItemString(1, "companycode")
	ls_eduyear = this.GetItemstring(1, 'p5_educations_p_eduyear')
	ls_bgubn = this.GetItemstring(1, 'bgubn')

	this.setredraw(false)
	if this.Retrieve(Gs_code, ls_empno, ls_eduyear, & 
													 ll_empseq, ls_bgubn) < 1 then
		wf_init()
		ls_gub= "등록"    // 등록 mode	  
		WF_SETTING_RETRIEVEMODE(ls_gub)	  

		this.SetItem(1, 'p5_educations_p_eduyear', ls_eduyear)
		this.SetItem(1, 'empseq', ll_empseq)
		this.SetColumn('p5_educations_p_prostate')			  
		this.setredraw(true)			  	  
		return
	else
		
		ib_any_typing = false
		ls_gub= "조회"    // 조회 mode
		WF_SETTING_RETRIEVEMODE(ls_gub)		

		this.SetColumn('p5_educations_p_prostate')		
		this.Setfocus()

		this.setredraw(true)			
  end if
  dw_emp.enabled = false
	  
end if

// 교육시작일자
if this.GetColumnName() = 'startdate' then 
	ls_startdate = trim(this.GetText())
	ls_enddate = trim(this.GetItemstring(1, 'enddate'))
	
	if isnull(ls_startdate) or ls_startdate = "" then 
		MessageBox("확 인", "교육 시작일자는 필수입력사항입니다.!!")			
		return 1
	end if
	If f_datechk(ls_startdate) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	end if

	
	//종료일자가 존재하지 않으면, 시작일자를 입력한다.
	if isnull(ls_enddate) or ls_enddate = "" then 
		ls_enddate = ls_startdate
		this.SetItem(1, 'enddate', ls_enddate)									
	end if
	
	// 총일수를 구하는 function(일수는 구하는데 실패하면 -1, 아니면 총일수 값을 return )
	if wf_date(ls_startdate, ls_enddate) = -1 then 
		MessageBox("확 인", "일수를 구하는데 실패하였습니다.!!")
		return 
	else
	  ll_datesu = wf_date(ls_startdate, ls_enddate)			
	end if
	
	ll_time1 = this.GetItemNumber(1, 'temp1')		

	if isnull(ll_datesu) or string(ll_datesu) = "" then 
		ll_datesu = 0 
	end if
	
	if isnull(ll_time1) or string(ll_time1) = "" then 
		ll_time1 = 0 
	end if
	
	// 총일수와 총시간을 수정한다.		
	this.setItem(1, 'datesu', ll_datesu)		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    
end if


// 교육 종료일자
if this.GetColumnName() =  'enddate'  then
   ls_enddate = trim(this.GetText())  
   ls_startdate = trim(this.GetItemstring(1, 'startdate'))	
	
	if isnull(ls_enddate) or ls_enddate = "" then 
		MessageBox("확 인", "교육 종료일자는 필수입력사항입니다.!!")
		return 1		
	end if
	If f_datechk(ls_enddate) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	end if

	if  ls_startdate > ls_enddate then
		MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
								 "클 수는 없습니다.!!", stopsign!)
		return 1
	end if

	//종료일자가 존재하지 않으면, 시작일자를 입력한다.
	if isnull(ls_startdate) or ls_startdate = "" then 
		ls_startdate = ls_enddate 
		this.SetItem(1, 'startdate', ls_startdate)						
	end if

	// 총일수를 구하는 function(일수는 구하는데 실패하면 -1, 아니면 총일수 값을 return )
	if wf_date(ls_startdate, ls_enddate) = -1 then 
		MessageBox("확 인", "일수를 구하는데 실패하였습니다.!!")
		return 
	else
	  ll_datesu = wf_date(ls_startdate, ls_enddate)			
	end if

	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu= 0 
	end if
	
	ll_time1 = this.GetItemNumber(1, 'temp1')		
	
	if isnull(ll_time1) or string(ll_time1) = "" then 
		ll_time1 = 0 
	end if

	// 총일수와 총시간을 수정한다.		
	this.setItem(1, 'datesu', ll_datesu)		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    

end if

//교육시작시간
if  this.GetColumnName() = 'starttime' then   
	ls_starttime = string(long(this.GetText()), '00:00')
	ls_endtime = string(this.GetItemNumber(1, 'endtime'), '00:00')	
	ll_datesu = this.GetItemNumber(1, 'datesu')					
	
	if Istime(ls_starttime) = false Then
		MessageBox("확 인", "유효한 시간이 아닙니다.")			
		return 1
	end if
	//temp1의 computed field에 들어갈 값
	//  truncate( ((  long(left(string(endtime, '0000'), 2)) * 60  + &
	//  long (right(string(endtime, '0000'), 2))) - (long(left(string(starttime, '0000'), 2)) &
	//  * 60  + long (right(string(starttime, '0000'), 2)) )) / 60, 0)		
	
	if isnull(ls_endtime) or trim(ls_endtime) = "" or ls_endtime = "00:00" then
		ls_endtime = this.GetText()
		this.SetItem(1, 'endtime',  long(ls_endtime))			
	end if
	
	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu = 0 
	end if
		
      if wf_time(ls_starttime, ls_endtime) = -1 then 
			MessageBox("확 인", "시간 산출 에러")
		   return 1
		else 
			ll_time1 = wf_time(ls_starttime, ls_endtime)
		end if
		
		if isnull(ll_time1) or string(ll_time1) = "" then ll_time1 = 0
		
		this.setItem(1, 'ehour', ll_datesu * ll_time1)    		
end if

//교육종료시간
if this.GetColumnName() = 'endtime' then 
	
	ls_starttime = trim(string(this.GetItemNumber(1, 'starttime'), '00:00'))	
	ls_endtime = string(long(trim(this.GetText())), '00:00')

	if Istime(ls_endtime) = false Then
		MessageBox("확 인", "유효한 시간이 아닙니다.")			
		return 1
	end if
	
	if ls_starttime > ls_endtime then
		MessageBox("확 인", "시작 시간이 종료시간보다" + "~n" + & 
								 "클 수는 없습니다.!!")			
		return 1
	end if
	
	if isnull(ls_starttime) or trim(ls_starttime) = "" or ls_starttime= "00:00" then
		ls_starttime = this.GetText()
		this.SetItem(1, 'starttime',  long(ls_starttime))			
	end if

	ll_datesu = this.GetItemNumber(1, 'datesu')				
	
	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu = 0 
	end if
	
	if wf_time(ls_starttime, ls_endtime) = -1 then 
		MessageBox("확 인", "시간 산출 에러")
		return 1
	else 
		ll_time1 = wf_time(ls_starttime, ls_endtime)
	end if

	if isnull(ll_time1) or string(ll_time1) = "" then ll_time1 = 0
		
   this.setItem(1, 'ehour', ll_datesu * ll_time1)    		
		
end if


//교육일수
if this.GetColumnName() =  'datesu' then 
	ll_datesu = long(this.GetText())
	ll_time1 = this.GetItemNumber(1, 'temp1') 
	
	if isnull(ll_datesu)  or ll_datesu = 0 or string(ll_datesu) = "" then 
		ll_datesu = 0
		this.setItem(1, 'datsu', 0)    		
	end if

	if isnull(ll_time1) or string(ll_time1) ="" then
		ll_time1 = 0 
	end if
	
	// 총교육시간, 교육일수 * 교육시간	
	this.SetItem(1, 'ehour', ll_datesu * ll_time1)
end if

// 교육기관
if this.GetColumnName() = 'eoffice' then 
	if trim(this.GetText()) = "" or isnull(this.GetText()) then return
end if

// 주관부서
if  this.GetColumnName() = 'edept' then 
	sedept = trim(this.GetText())	
	
	if sedept = "" or isnull(sedept) then	return 

	select deptcode, deptname
	into   :sdeptcode, :sdeptcodename
	from p0_dept
	where companycode = :gs_company and
			deptcode = :sedept ;
	if sqlca.sqlcode <> 0 then
		MessageBox("확 인", "조회한 자료가 없습니다.")
		this.SetItem(1, 'edept', snull)
		return 1
	end if
end if

// 교육과정 추가(1999.09.01)
if this.GetColumnName() =  'eudcur' then 
	ls_educur = trim(this.GetText())
	
	if ls_educur = '' or isnull(ls_educur) then 
		return 
	else
		SELECT "P0_REF"."CODE"   
		INTO :get_educur   
		FROM "P0_REF"  
		WHERE "P0_REF"."CODEGBN" = 'MQ' AND 
				"P0_REF"."CODE" <> '00'  ;
      if sqlca.sqlcode <> 0 then 
			MessageBox("확 인", "조회하신 코드로 자료가 존재하가 않습니다.!!")
    		this.SetItem(1, 'eudcur', snull)			
			return 1
		end if
	end if
end if
end event

event itemerror;return 1
end event

event rbuttondown;string snull, ls_empno, ls_company, ls_eduyear
int li_count

SetNull(snull)
SetNull(gs_code)     

IF This.GetColumnName() = "p5_educations_p_eduyear" or This.GetColumnName() = "empseq" THEN
	ls_eduyear = this.object.p5_educations_p_eduyear[GetRow()]
	
	if isnull(ls_eduyear) then
		ls_eduyear = ""
	end if
	
	Gs_Code  = gs_company
   istr_edu.str_empno   = dw_emp.Getitemstring(1, "empno")  // 사번
   istr_edu.str_eduyear =  ls_eduyear                       // 계획년도
	
   istr_edu.str_empseq  = this.GetitemNumber(1, "empseq")  // 	일련번호
   istr_edu.str_gbn  = this.GetItemString(1, "bgubn")  		// 자료구분(P : 계획자료, R : 신청자료)

	openwithparm(w_edu_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	IF IsNull(Gs_code) THEN RETURN
   IF	IsNull(istr_edu.str_empno) THEN RETURN
   IF	IsNull(istr_edu.str_eduyear) THEN RETURN
   IF	IsNull(istr_edu.str_empseq) THEN RETURN
   IF	IsNull(istr_edu.str_gbn) THEN RETURN	
	
 	this.SetItem(1, "companycode", Gs_code)
 	this.SetItem(1, "empno", istr_edu.str_empno)	 
 	this.SetItem(1, "p5_educations_p_eduyear", istr_edu.str_eduyear)
 	this.SetItem(1, "empseq", istr_edu.str_empseq)
 	this.SetItem(1, "bgubn", istr_edu.str_gbn)

	this.SetColumn('p5_educations_p_eduyear')
	
	p_inq.TriggerEvent(Clicked!)
	
//	return 1

END IF

IF This.GetColumnName() ="edept_1" THEN

	Gs_code = this.getText()

	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"edept",gs_code)
	
END IF

end event

event editchanged;ib_any_typing =True
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF this.GetColumnName() ="eduteacher" OR this.GetColumnName() ="edudepmentt" OR &
   this.GetColumnName() ="eduarea" OR this.GetColumnName() ="educdesc" OR &
	this.GetColumnName() ="edubook" or this.GetColumnName() ="edubook1" OR & 
	this.GetColumnName() = 'remark' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

