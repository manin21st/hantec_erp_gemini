$PBExportHeader$w_pdm_01390.srw
$PBExportComments$주차 생성 및 관리
forward
global type w_pdm_01390 from w_inherite
end type
type dw_head from datawindow within w_pdm_01390
end type
type dw_list1 from datawindow within w_pdm_01390
end type
type dw_list2 from datawindow within w_pdm_01390
end type
type dw_list3 from datawindow within w_pdm_01390
end type
end forward

global type w_pdm_01390 from w_inherite
string title = "주차 생성 및 관리"
dw_head dw_head
dw_list1 dw_list1
dw_list2 dw_list2
dw_list3 dw_list3
end type
global w_pdm_01390 w_pdm_01390

on w_pdm_01390.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.dw_list1=create dw_list1
this.dw_list2=create dw_list2
this.dw_list3=create dw_list3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.dw_list1
this.Control[iCurrent+3]=this.dw_list2
this.Control[iCurrent+4]=this.dw_list3
end on

on w_pdm_01390.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.dw_list1)
destroy(this.dw_list2)
destroy(this.dw_list3)
end on

event open;call super::open;dw_list1.settransobject(sqlca)
dw_list2.settransobject(sqlca)
dw_list3.settransobject(sqlca)

dw_head.insertrow(0)
dw_head.setitem(1, "yyyy", LONG(Left(f_Today(), 4)))
dw_head.setfocus()


end event

type dw_insert from w_inherite`dw_insert within w_pdm_01390
boolean visible = false
integer y = 2484
integer width = 544
integer height = 76
integer taborder = 0
boolean enabled = false
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01390
boolean visible = false
integer x = 4000
integer y = 2968
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01390
boolean visible = false
integer x = 3826
integer y = 2968
end type

type p_search from w_inherite`p_search within w_pdm_01390
boolean visible = false
integer x = 3131
integer y = 2968
end type

type p_ins from w_inherite`p_ins within w_pdm_01390
boolean visible = false
integer x = 3653
integer y = 2968
end type

type p_exit from w_inherite`p_exit within w_pdm_01390
end type

type p_can from w_inherite`p_can within w_pdm_01390
end type

event p_can::clicked;call super::clicked;dw_list1.reset()
dw_list2.reset()
dw_list3.reset()

dw_head.setfocus()
end event

type p_print from w_inherite`p_print within w_pdm_01390
boolean visible = false
integer x = 3305
integer y = 2968
end type

type p_inq from w_inherite`p_inq within w_pdm_01390
integer x = 3922
end type

event p_inq::clicked;call super::clicked;String sYear, sDate1, sDate2, sDate3, spyear
Long	 Lrow, pjucha

if dw_head.accepttext() = -1 then return

sYear  = String(dw_head.getitemdecimal(1, "yyyy"), '0000')
spYear = String(dw_head.getitemdecimal(1, "yyyy") - 1, '0000')

Lrow = 0
Select Count(*) Into :Lrow
  From pdtweek
 Where week_year = :sYear;
 
If Lrow < 1 then
	If MessageBox("주차", "해당년도로 작성된 자료가 없읍니다" + '~n' + &
							 "자료를 작성하시겠읍니까?", Question!, yesno!) = 2 then
		Return
	End if
End if

SetPointer(HourGlass!)

// 자료가 없는 경우에는 신규로 작성
if Lrow < 1 then
	// 요일구분을 이용하여 기본 데이타를 작성
//	INSERT INTO "PDTWEEK"  
//         ( "WEEK_SDATE",  "WEEK_EDATE",   "WEEK_JUCHA",   "WEEK_YEAR",   "WEEK_YEAR_JUCHA" )  
//	SELECT A.CLDATE, 
//			 DECODE(B.CLDATE, NULL, A.CLDATE, B.CLDATE), 0, :SYEAR, 0
//	  FROM
//		  (SELECT CLDATE, JDATE
//			  FROM P4_CALENDAR
//			 WHERE CLDATE LIKE :sYear||'%'
//				AND DAYGUBN = '2' ) A,
//			P4_CALENDAR B
//	 WHERE A.JDATE + 6 = B.JDATE (+);


//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	INSERT INTO "PDTWEEK"  
         ( "WEEK_SDATE",  "WEEK_EDATE",   "WEEK_JUCHA",   "WEEK_YEAR",   "WEEK_YEAR_JUCHA", "MON_JUCHA", "WEEK_LDATE" )  
	SELECT A.CLDATE, 
			 DECODE(B.CLDATE, NULL, A.CLDATE, B.CLDATE), 0, :SYEAR, 0, 0, DECODE(B.CLDATE, NULL, A.CLDATE, B.CLDATE)
	  FROM
		  (SELECT CLDATE, JDATE
			  FROM P4_CALENDAR
			 WHERE CLDATE LIKE :sYear||'%'
				AND DAYGUBN = '2' ) A,
			P4_CALENDAR B
	 WHERE A.JDATE + 6 = B.JDATE (+);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	 
	 // 최종주차의 종료일이 해당년도 이후 인 경우 해당년도의 마지막 일자를 입력한다.
	 UPDATE PDTWEEK
	    SET WEEK_EDATE = (SELECT MAX(CLDATE) FROM P4_CALENDAR WHERE CLDATE LIKE :SYEAR||'%')
	  WHERE WEEK_SDATE = (SELECT MAX(WEEK_SDATE) FROM PDTWEEK WHERE WEEK_YEAR = :SYEAR);
	 	
	 
	 // 1주차의 자료작성(가장 적은 시작일이 해당년도의 시작일자와 틀린경우에만 작성)
	 Select min(week_sdate) Into :sDate1 From Pdtweek 	   Where week_year  =  :sYear;
 	 Select min(cldate) 		Into :sDate2 From p4_calendar Where cldate   Like :sYear||'%';
	  
	 If sDate1 <> sDate2 Then
		 SELECT A.CLDATE INTO :sDate3
			FROM P4_CALENDAR A,
			     (SELECT A.JDATE
					  FROM P4_CALENDAR A
					 WHERE A.CLDATE = :sDate1) B
		  WHERE B.JDATE - 1 = A.JDATE;
		
//		 INSERT INTO PDTWEEK (WEEK_SDATE, WEEK_EDATE, WEEK_JUCHA, WEEK_YEAR)
//		 				 VALUES  (:sDate2,    :sDate3,    0,			 :sYear);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

		 INSERT INTO PDTWEEK (WEEK_SDATE, WEEK_EDATE, WEEK_JUCHA, WEEK_YEAR, MON_JUCHA, WEEK_YEAR_JUCHA, WEEK_LDATE )
		 				 VALUES  (:sDate2,    :sDate3,    0,			 :sYear, 0, 0, :sDate3);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	End if
	 
	 // 마지막 주차의 자료작성(가장 적은 시작일이 해당년도의 시작일자와 틀린경우에만 작성)
	 Select Max(week_edate) Into :sDate1 From Pdtweek 	  Where week_year =    :sYear;
 	 Select Max(cldate) 		Into :sDate2 From p4_calendar Where cldate   Like :sYear||'%';
	  
	 If sDate1 <> sDate2 Then
		 SELECT A.CLDATE INTO :sDate3
			FROM P4_CALENDAR A,
			     (SELECT A.JDATE
					  FROM P4_CALENDAR A
					 WHERE A.CLDATE = :sDate1) B
		  WHERE B.JDATE + 1 = A.JDATE;
		
//		 INSERT INTO PDTWEEK (WEEK_SDATE, WEEK_EDATE, WEEK_JUCHA, WEEK_YEAR)
//		 				 VALUES  (:sDate3,    :sDate2,    0,			 :sYear);


//////////////////////////////////////////////////////////////////////////////////////////////////////////////

		 INSERT INTO PDTWEEK (WEEK_SDATE, WEEK_EDATE, WEEK_JUCHA, WEEK_YEAR, MON_JUCHA, WEEK_YEAR_JUCHA, WEEK_LDATE)
		 				 VALUES  (:sDate3,    :sDate2,    0,			 :sYear, 0, 0, :sDate2);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	End if	
//	 commit;	
	// 시작및 종료일의 월이 달라진 경우...
	
		INSERT INTO PDTWEEK 
				(	WEEK_SDATE, 
					WEEK_EDATE,
					WEEK_JUCHA, WEEK_YEAR, MON_JUCHA, WEEK_YEAR_JUCHA, WEEK_LDATE )	
		select substr(week_edate,1,6)||'01',
				 week_edate,
				 0,	:sYear,	0, 	0, 	week_ldate 
		from pdtweek
		where week_year = :sYear
		and substr(week_sdate,1,6) != substr(week_edate,1,6)	;
		
		
		
		update pdtweek t
		set	t.week_edate 	=  TO_CHAR(last_day(to_date(t.week_sdate,'YYYYMMDD')),'YYYYMMDD')
		where t.week_year 	= :sYear
		and substr(t.week_sdate,1,6) != substr(t.week_edate,1,6) ;		
	
	 
	 commit;
	 
	 // 순서적으로 주차내역을 지정하여 저장한다.
	 // 단 Julian 주차는 전년의 마지막 주차를 기준으로 시작한다.
	 pjucha = 0
	 
	 Select Max(week_year_jucha)
	 	Into :pjucha
	 	From pdtweek
	  Where week_year = :spyear;
	  
	  
	 if Isnull(pjucha) then pjucha = 0 
 
	 dw_list1.setredraw(false)
	 dw_list1.retrieve(syear, 0,  0)		 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	 string	smon, spmon
	 integer	icnt
	 
	 spmon = ' '
	 For Lrow = 1 to dw_list1.rowcount()
		  dw_list1.setitem(Lrow, "week_jucha", Lrow)
		  
		  pjucha++
		  dw_list1.setitem(Lrow, "week_year_jucha", pjucha)		  

		  smon = left(trim(dw_list1.getitemstring(Lrow,'week_sdate')),6)
		  if smon <> spmon then icnt = 0
		  icnt++
		  dw_list1.setitem(Lrow, "mon_jucha", icnt)
		  spmon = smon
	 Next
//////////////////////////////////////////////////////////////////////////////////////////////////////////////	 
	 
	 
	 dw_list1.update()
	 Commit;
	 dw_list1.reset()
	 dw_list1.setredraw(True)
	 
End if
							 
dw_list1.retrieve(syear, 1,  21)	
dw_list2.retrieve(syear, 22, 42)	
dw_list3.retrieve(syear, 43, 100)	

end event

type p_del from w_inherite`p_del within w_pdm_01390
boolean visible = false
integer x = 4347
integer y = 2968
end type

type p_mod from w_inherite`p_mod within w_pdm_01390
integer x = 4096
end type

event p_mod::clicked;call super::clicked;if dw_list1.accepttext() = -1 then return
if dw_list2.accepttext() = -1 then return
if dw_list3.accepttext() = -1 then return

if dw_list1.update() <> 1 or dw_list2.update() <> 1 or dw_list3.update() <> 1 then
	MessageBox("자료저장", "자료저장을 실패하였읍니다", stopsign!)
	rollback;
	return
End if

Commit;

MessageBox("자료저장", "자료를 저장하였읍니다", information!)

p_inq.triggerevent(CliCked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01390
integer taborder = 130
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01390
integer x = 2496
integer taborder = 70
end type

event cb_mod::clicked;call super::clicked;//if dw_list1.accepttext() = -1 then return
//if dw_list2.accepttext() = -1 then return
//if dw_list3.accepttext() = -1 then return
//
//if dw_list1.update() <> 1 or dw_list2.update() <> 1 or dw_list3.update() <> 1 then
//	MessageBox("자료저장", "자료저장을 실패하였읍니다", stopsign!)
//	rollback;
//	return
//End if
//
//Commit;
//
//MessageBox("자료저장", "자료를 저장하였읍니다", information!)
//
//Cb_can.triggerevent(CliCked!)
end event

type cb_ins from w_inherite`cb_ins within w_pdm_01390
integer x = 736
integer y = 2560
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdm_01390
integer x = 1184
integer y = 2548
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01390
integer x = 69
integer taborder = 22
end type

event cb_inq::clicked;call super::clicked;//String sYear, sDate1, sDate2, sDate3, spyear
//Long	 Lrow, pjucha
//
//if dw_head.accepttext() = -1 then return
//
//sYear  = String(dw_head.getitemdecimal(1, "yyyy"), '0000')
//spYear = String(dw_head.getitemdecimal(1, "yyyy") - 1, '0000')
//
//Lrow = 0
//Select Count(*) Into :Lrow
//  From pdtweek
// Where week_year = :sYear;
// 
//If Lrow < 1 then
//	If MessageBox("주차", "해당년도로 작성된 자료가 없읍니다" + '~n' + &
//							 "자료를 작성하시겠읍니까?", Question!, yesno!) = 2 then
//		Return
//	End if
//End if
//
//SetPointer(HourGlass!)
//
//// 자료가 없는 경우에는 신규로 작성
//if Lrow < 1 then
//	// 요일구분을 이용하여 기본 데이타를 작성
//	INSERT INTO "PDTWEEK"  
//         ( "WEEK_SDATE",  "WEEK_EDATE",   "WEEK_JUCHA",   "WEEK_YEAR",   "WEEK_YEAR_JUCHA" )  
//	SELECT A.CLDATE, 
//			 DECODE(B.CLDATE, NULL, A.CLDATE, B.CLDATE), 0, :SYEAR, 0
//	  FROM
//		  (SELECT CLDATE, JDATE
//			  FROM P4_CALENDAR
//			 WHERE CLDATE LIKE :sYear||'%'
//				AND DAYGUBN = '2' ) A,
//			P4_CALENDAR B
//	 WHERE A.JDATE + 6 = B.JDATE (+);
//	 
//	 // 최종주차의 종료일이 해당년도 이후 인 경우 해당년도의 마지막 일자를 입력한다.
//	 UPDATE PDTWEEK
//	    SET WEEK_EDATE = (SELECT MAX(CLDATE) FROM P4_CALENDAR WHERE CLDATE LIKE :SYEAR||'%')
//	  WHERE WEEK_SDATE = (SELECT MAX(WEEK_SDATE) FROM PDTWEEK WHERE WEEK_YEAR = :SYEAR);
//	 	
//	 
//	 // 1주차의 자료작성(가장 적은 시작일이 해당년도의 시작일자와 틀린경우에만 작성)
//	 Select min(week_sdate) Into :sDate1 From Pdtweek 	   Where week_year  =  :sYear;
// 	 Select min(cldate) 		Into :sDate2 From p4_calendar Where cldate   Like :sYear||'%';
//	  
//	 If sDate1 <> sDate2 Then
//		 SELECT A.CLDATE INTO :sDate3
//			FROM P4_CALENDAR A,
//			     (SELECT A.JDATE
//					  FROM P4_CALENDAR A
//					 WHERE A.CLDATE = :sDate1) B
//		  WHERE B.JDATE - 1 = A.JDATE;
//		
//		 INSERT INTO PDTWEEK (WEEK_SDATE, WEEK_EDATE, WEEK_JUCHA, WEEK_YEAR)
//		 				 VALUES  (:sDate2,    :sDate3,    0,			 :sYear);
//	 End if
//	 
//	 // 마지막 주차의 자료작성(가장 적은 시작일이 해당년도의 시작일자와 틀린경우에만 작성)
//	 Select Max(week_edate) Into :sDate1 From Pdtweek 	  Where week_year =    :sYear;
// 	 Select Max(cldate) 		Into :sDate2 From p4_calendar Where cldate   Like :sYear||'%';
//	  
//	 If sDate1 <> sDate2 Then
//		 SELECT A.CLDATE INTO :sDate3
//			FROM P4_CALENDAR A,
//			     (SELECT A.JDATE
//					  FROM P4_CALENDAR A
//					 WHERE A.CLDATE = :sDate1) B
//		  WHERE B.JDATE + 1 = A.JDATE;
//		
//		 INSERT INTO PDTWEEK (WEEK_SDATE, WEEK_EDATE, WEEK_JUCHA, WEEK_YEAR)
//		 				 VALUES  (:sDate3,    :sDate2,    0,			 :sYear);
//	 End if	 
//	 
//	 commit;
//	 
//	 // 순서적으로 주차내역을 지정하여 저장한다.
//	 // 단 Julian 주차는 전년의 마지막 주차를 기준으로 시작한다.
//	 pjucha = 0
//	 Select Max(week_year_jucha)
//	 	Into :pjucha
//	 	From pdtweek
//	  Where week_year = :spyear;
//	 if Isnull(pjucha) then pjucha = 0 
// 
//	 dw_list1.setredraw(false)
//	 dw_list1.retrieve(syear, 0,  0)		 
//	 For Lrow = 1 to dw_list1.rowcount()
//		  dw_list1.setitem(Lrow, "week_jucha", Lrow)
//		  
//		  pjucha++
//		  dw_list1.setitem(Lrow, "week_year_jucha", pjucha)		  
//	 Next
//	 dw_list1.update()
//	 Commit;
//	 dw_list1.reset()
//	 dw_list1.setredraw(True)
//	 
//End if
//							 
//dw_list1.retrieve(syear, 1,  18)	
//dw_list2.retrieve(syear, 19, 36)	
//dw_list3.retrieve(syear, 37, 100)	
//
end event

type cb_print from w_inherite`cb_print within w_pdm_01390
integer x = 1563
integer y = 2536
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdm_01390
end type

type cb_can from w_inherite`cb_can within w_pdm_01390
integer x = 2857
integer taborder = 110
end type

event cb_can::clicked;call super::clicked;//dw_list1.reset()
//dw_list2.reset()
//dw_list3.reset()
//
//dw_head.setfocus()
end event

type cb_search from w_inherite`cb_search within w_pdm_01390
integer x = 1975
integer y = 2524
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_01390
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01390
end type

type dw_head from datawindow within w_pdm_01390
integer x = 96
integer y = 64
integer width = 809
integer height = 148
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdm_01390_1"
boolean border = false
end type

type dw_list1 from datawindow within w_pdm_01390
integer x = 59
integer y = 252
integer width = 1513
integer height = 2044
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "1주 ~~ 21주"
string dataobject = "d_pdm_01390_2"
borderstyle borderstyle = stylelowered!
end type

type dw_list2 from datawindow within w_pdm_01390
integer x = 1568
integer y = 252
integer width = 1513
integer height = 2044
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "22주 ~~ 42주"
string dataobject = "d_pdm_01390_2"
borderstyle borderstyle = stylelowered!
end type

type dw_list3 from datawindow within w_pdm_01390
integer x = 3077
integer y = 252
integer width = 1513
integer height = 2044
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "43주 ~~  "
string dataobject = "d_pdm_01390_2"
borderstyle borderstyle = stylelowered!
end type

