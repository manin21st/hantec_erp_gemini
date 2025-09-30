$PBExportHeader$w_imt_03090.srw
$PBExportComments$B/L수입원가 계산서
forward
global type w_imt_03090 from window
end type
type cb_print from commandbutton within w_imt_03090
end type
type tab_1 from tab within w_imt_03090
end type
type tabpage_1 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_2 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_3 dw_3
end type
type tab_1 from tab within w_imt_03090
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_1 from datawindow within w_imt_03090
end type
type cb_cancel from commandbutton within w_imt_03090
end type
type dw_imhist from datawindow within w_imt_03090
end type
type dw_datetime from datawindow within w_imt_03090
end type
type cb_exit from commandbutton within w_imt_03090
end type
type cb_retrieve from commandbutton within w_imt_03090
end type
type gb_4 from groupbox within w_imt_03090
end type
type gb_2 from groupbox within w_imt_03090
end type
type gb_3 from groupbox within w_imt_03090
end type
type gb_1 from groupbox within w_imt_03090
end type
type st_message_text from statictext within w_imt_03090
end type
type sle_message_line from statictext within w_imt_03090
end type
end forward

global type w_imt_03090 from window
integer width = 3657
integer height = 2408
boolean titlebar = true
string title = "B/L, 인수증 마감"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
cb_print cb_print
tab_1 tab_1
dw_1 dw_1
cb_cancel cb_cancel
dw_imhist dw_imhist
dw_datetime dw_datetime
cb_exit cb_exit
cb_retrieve cb_retrieve
gb_4 gb_4
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
st_message_text st_message_text
sle_message_line sle_message_line
end type
global w_imt_03090 w_imt_03090

type variables
boolean ib_ItemError, ib_any_typing
char ic_status

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

String     is_expgub          //수입비용 적용구분
string     is_useyn      //외자인터페이스 생성 적용구분
end variables

forward prototypes
public subroutine wf_hsno ()
end prototypes

public subroutine wf_hsno ();////////////////////////////////////////////////////////////////////////////
//// 수입비용산출율로 비용계산시 H.S No 로 율을 계산함                    //
////////////////////////////////////////////////////////////////////////////
//
//string s_cusrate, s_apprate, sgub, s_hsno
//long   i, k
//dec    dcusrate, dapprate
//
//FOR i=1 TO dw_list.rowcount()
//   s_hsno = dw_list.Getitemstring(i, 'itemas_hsno')
//	
//	if len(s_hsno) = 10 then 
//		FOR k = 10 TO 2 STEP -2 
//			s_hsno = left(s_hsno, k)
//			
//			SELECT "IMPRAT"."CUSRAT", "IMPRAT"."APPRAT"  
//			  INTO :dcusrate, :dapprate
//			  FROM "IMPRAT"  
//			 WHERE "IMPRAT"."HSNO" = :s_hsno   ;
//	
//			if sqlca.sqlcode = 0 then 
//				sgub = 'Y'
//				exit
//			end if	
//		NEXT
//	elseif len(s_hsno) = 8 or len(s_hsno) = 9 then	 
//		FOR k = 8 TO 2 STEP -2 
//			s_hsno = left(s_hsno, k)
//			
//			SELECT "IMPRAT"."CUSRAT", "IMPRAT"."APPRAT"  
//			  INTO :dcusrate, :dapprate
//			  FROM "IMPRAT"  
//			 WHERE "IMPRAT"."HSNO" = :s_hsno   ;
//	
//			if sqlca.sqlcode = 0 then 
//				sgub = 'Y'
//				exit
//			end if	
//		NEXT
//	elseif len(s_hsno) = 6 or len(s_hsno) = 7 then	 
//		FOR k = 6 TO 2 STEP -2 
//			s_hsno = left(s_hsno, k)
//			
//			SELECT "IMPRAT"."CUSRAT", "IMPRAT"."APPRAT"  
//			  INTO :dcusrate, :dapprate
//			  FROM "IMPRAT"  
//			 WHERE "IMPRAT"."HSNO" = :s_hsno   ;
//	
//			if sqlca.sqlcode = 0 then 
//				sgub = 'Y'
//				exit
//			end if	
//		NEXT
//	elseif len(s_hsno) = 4 or len(s_hsno) = 5 then	 
//		FOR k = 4 TO 2 STEP -2 
//			s_hsno = left(s_hsno, k)
//			
//			SELECT "IMPRAT"."CUSRAT", "IMPRAT"."APPRAT"  
//			  INTO :dcusrate, :dapprate
//			  FROM "IMPRAT"  
//			 WHERE "IMPRAT"."HSNO" = :s_hsno   ;
//	
//			if sqlca.sqlcode = 0 then 
//				sgub = 'Y'
//				exit
//			end if	
//		NEXT
//	else
//		s_hsno = left(s_hsno, k)
//		
//		SELECT "IMPRAT"."CUSRAT", "IMPRAT"."APPRAT"  
//		  INTO :dcusrate, :dapprate
//		  FROM "IMPRAT"  
//		 WHERE "IMPRAT"."HSNO" = :s_hsno   ;
//		if sqlca.sqlcode = 0 then 
//			sgub = 'Y'
//		end if	
//	end if	
//	
//	if sgub <> 'Y' then 
//		SELECT "SYSCNFG"."DATANAME"  
//		  INTO :s_cusrate  
//		  FROM "SYSCNFG"  
//		 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  ( "SYSCNFG"."SERIAL" = 16 ) AND  
//				 ( "SYSCNFG"."LINENO" = '2' )   ;
//		
//		SELECT "SYSCNFG"."DATANAME"  
//		  INTO :s_apprate  
//		  FROM "SYSCNFG"  
//		 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  ( "SYSCNFG"."SERIAL" = 16 ) AND  
//				 ( "SYSCNFG"."LINENO" = '3' )   ;
//	
//		dcusrate = dec(s_cusrate)
//		dapprate = dec(s_apprate)
//	end if	
//
//   dw_list.Setitem(i, 'cusrat', dcusrate)
//   dw_list.Setitem(i, 'apprat', dapprate)
//
//NEXT
//
end subroutine

event open;is_window_id = Message.StringParm	
is_today = f_today()
is_totime = f_totime()

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_1.settransobject(sqlca)
dw_1.insertrow(0)
dw_datetime.insertrow(0)

tab_1.tabpage_1.dw_2.settransobject(sqlca)
tab_1.tabpage_2.dw_3.settransobject(sqlca)
end event

on w_imt_03090.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.cb_print=create cb_print
this.tab_1=create tab_1
this.dw_1=create dw_1
this.cb_cancel=create cb_cancel
this.dw_imhist=create dw_imhist
this.dw_datetime=create dw_datetime
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.gb_4=create gb_4
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.st_message_text=create st_message_text
this.sle_message_line=create sle_message_line
this.Control[]={this.cb_print,&
this.tab_1,&
this.dw_1,&
this.cb_cancel,&
this.dw_imhist,&
this.dw_datetime,&
this.cb_exit,&
this.cb_retrieve,&
this.gb_4,&
this.gb_2,&
this.gb_3,&
this.gb_1,&
this.st_message_text,&
this.sle_message_line}
end on

on w_imt_03090.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print)
destroy(this.tab_1)
destroy(this.dw_1)
destroy(this.cb_cancel)
destroy(this.dw_imhist)
destroy(this.dw_datetime)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.gb_4)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.st_message_text)
destroy(this.sle_message_line)
end on

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  


end event

type cb_print from commandbutton within w_imt_03090
integer x = 535
integer y = 1976
integer width = 347
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "출력(&P)"
end type

event clicked;gi_page = 1

OpenWithParm(w_print_options, tab_1.tabpage_2.dw_3)


end event

type tab_1 from tab within w_imt_03090
integer x = 50
integer y = 224
integer width = 3525
integer height = 1696
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
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

event selectionchanged;if newindex = 2 and tab_1.tabpage_2.dw_3.rowcount() > 0 then
	cb_print.enabled = true
else
	cb_print.enabled = false
end if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3488
integer height = 1584
long backcolor = 79741120
string text = "B/L마감내역 상세"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_1.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_1.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_1
integer y = 16
integer width = 3470
integer height = 1552
integer taborder = 20
string title = "none"
string dataobject = "d_imt_03091"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;IF row < 1 THEN RETURN 

gs_code = this.getitemstring(row, 'poblno')

open(w_imt_03050_popup)
end event

event doubleclicked;if row < 1 then return

Long Lrow
Lrow = row

String sblno
sblno = getitemstring(Lrow, "poblno")

gs_code = sblno

open(w_imt_03090_1)

if tab_1.tabpage_2.dw_3.retrieve(gs_sabu, sblno) < 1 then
	Messagebox("원가계산서", "원가계산서 내역이 없읍니다", stopsign!)
	return
Else	
	tab_1.tabpage_2.dw_3.setfocus()
	tab_1.selecttab(2);	
End if
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3488
integer height = 1584
long backcolor = 79741120
string text = "수입원가계산서"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_2.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_2.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_2
integer x = 9
integer y = 12
integer width = 3483
integer height = 1568
integer taborder = 20
string title = "none"
string dataobject = "d_imt_03092"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_imt_03090
event ue_presenter pbm_dwnprocessenter
integer x = 197
integer y = 76
integer width = 1179
integer height = 120
integer taborder = 10
string dataobject = "d_imt_03050_a"
boolean border = false
boolean livescroll = true
end type

event ue_presenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string  snull, sdate, gub

setnull(snull)

IF this.GetColumnName() = "fr_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[마감일자]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
	

ELSEIF this.GetColumnName() = "to_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[마감일자]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
END IF
end event

event itemerror;return 1
end event

type cb_cancel from commandbutton within w_imt_03090
integer x = 2711
integer y = 1976
integer width = 347
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;tab_1.tabpage_1.dw_2.reset()
dw_1.setfocus()
end event

type dw_imhist from datawindow within w_imt_03090
boolean visible = false
integer x = 96
integer y = 2316
integer width = 494
integer height = 212
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pme3001_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_datetime from datawindow within w_imt_03090
integer x = 2843
integer y = 2120
integer width = 759
integer height = 108
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type cb_exit from commandbutton within w_imt_03090
event key_in pbm_keydown
integer x = 3077
integer y = 1976
integer width = 347
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

on clicked;CLOSE(PARENT)
end on

type cb_retrieve from commandbutton within w_imt_03090
integer x = 142
integer y = 1976
integer width = 347
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;IF dw_1.accepttext() = -1			THEN 	RETURN 

string	sf_Date, st_date, slcno, ssaupj
Long     k
Integer  iseq, get_seq

sf_Date =  trim(dw_1.getitemstring(1, 'fr_date'))
st_Date =  trim(dw_1.getitemstring(1, 'to_date'))

IF isnull(sf_Date) or sf_Date = "" 	THEN
	sf_date = '10000101'
END IF
IF isnull(st_Date) or st_Date = "" 	THEN
	st_date = '99999999'
END IF

IF	tab_1.tabpage_1.dw_2.Retrieve(gs_sabu, sf_Date, st_date) <	1		THEN
	f_message_chk(50, '[마감 자료]')
	dw_1.SetColumn('fr_date')
	dw_1.SetFocus()
	RETURN
END IF


end event

type gb_4 from groupbox within w_imt_03090
integer x = 50
integer width = 2368
integer height = 204
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_imt_03090
integer x = 2427
integer width = 1147
integer height = 204
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_imt_03090
integer x = 2537
integer y = 1908
integer width = 1038
integer height = 204
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_imt_03090
integer x = 50
integer y = 1908
integer width = 896
integer height = 204
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

type st_message_text from statictext within w_imt_03090
integer x = 32
integer y = 2120
integer width = 375
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
string text = "메세지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_message_line from statictext within w_imt_03090
integer x = 411
integer y = 2120
integer width = 2432
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

