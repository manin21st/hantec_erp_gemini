$PBExportHeader$w_pdm_01630.srw
$PBExportComments$** 부하구간 정의
forward
global type w_pdm_01630 from window
end type
type p_exit from uo_picture within w_pdm_01630
end type
type p_can from uo_picture within w_pdm_01630
end type
type p_print from uo_picture within w_pdm_01630
end type
type p_mod from uo_picture within w_pdm_01630
end type
type p_inq from uo_picture within w_pdm_01630
end type
type cb_1 from commandbutton within w_pdm_01630
end type
type dw_1 from datawindow within w_pdm_01630
end type
type st_1 from statictext within w_pdm_01630
end type
type dw_list2 from datawindow within w_pdm_01630
end type
type cb_cancel from commandbutton within w_pdm_01630
end type
type dw_datetime from datawindow within w_pdm_01630
end type
type cb_retrieve from commandbutton within w_pdm_01630
end type
type cb_exit from commandbutton within w_pdm_01630
end type
type cb_save from commandbutton within w_pdm_01630
end type
type dw_list from datawindow within w_pdm_01630
end type
type gb_2 from groupbox within w_pdm_01630
end type
type gb_mode2 from groupbox within w_pdm_01630
end type
type sle_msg from singlelineedit within w_pdm_01630
end type
type gb_10 from groupbox within w_pdm_01630
end type
type rr_1 from roundrectangle within w_pdm_01630
end type
type rr_2 from roundrectangle within w_pdm_01630
end type
end forward

global type w_pdm_01630 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "부하구간 정의"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_print p_print
p_mod p_mod
p_inq p_inq
cb_1 cb_1
dw_1 dw_1
st_1 st_1
dw_list2 dw_list2
cb_cancel cb_cancel
dw_datetime dw_datetime
cb_retrieve cb_retrieve
cb_exit cb_exit
cb_save cb_save
dw_list dw_list
gb_2 gb_2
gb_mode2 gb_mode2
sle_msg sle_msg
gb_10 gb_10
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01630 w_pdm_01630

type variables
// 자료변경여부 검사
boolean  ib_any_typing

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		dw_list.SetFocus()						// yes 일 경우: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

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

integer icount, icount2, ilsu, ilsu2

dw_list.settransobject(sqlca)
dw_list2.settransobject(sqlca)

//초기화
dw_list.setredraw(false)
dw_list2.setredraw(false)

dw_list.reset()
dw_list2.reset()

FOR icount=1 TO 15
    dw_list.insertrow(0)
    dw_list.SetItem(icount, "gugan", icount)
    
	 SELECT "RESCAL"."GUILS"  
      INTO :ilsu  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
    dw_list.SetItem(icount, "guils", ilsu)
    
	 icount2 = icount + 15
	 dw_list2.insertrow(0)
    dw_list2.SetItem(icount, "gugan", icount2)

    SELECT "RESCAL"."GUILS"  
      INTO :ilsu2  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
    dw_list2.SetItem(icount, "guils", ilsu2)
NEXT

dw_list.SetFocus()

dw_list.setredraw(true)
dw_list2.setredraw(true)

ib_any_typing = false

dw_datetime.insertrow(0)
end event

on w_pdm_01630.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_print=create p_print
this.p_mod=create p_mod
this.p_inq=create p_inq
this.cb_1=create cb_1
this.dw_1=create dw_1
this.st_1=create st_1
this.dw_list2=create dw_list2
this.cb_cancel=create cb_cancel
this.dw_datetime=create dw_datetime
this.cb_retrieve=create cb_retrieve
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.dw_list=create dw_list
this.gb_2=create gb_2
this.gb_mode2=create gb_mode2
this.sle_msg=create sle_msg
this.gb_10=create gb_10
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_can,&
this.p_print,&
this.p_mod,&
this.p_inq,&
this.cb_1,&
this.dw_1,&
this.st_1,&
this.dw_list2,&
this.cb_cancel,&
this.dw_datetime,&
this.cb_retrieve,&
this.cb_exit,&
this.cb_save,&
this.dw_list,&
this.gb_2,&
this.gb_mode2,&
this.sle_msg,&
this.gb_10,&
this.rr_1,&
this.rr_2}
end on

on w_pdm_01630.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_print)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.dw_list2)
destroy(this.cb_cancel)
destroy(this.dw_datetime)
destroy(this.cb_retrieve)
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.dw_list)
destroy(this.gb_2)
destroy(this.gb_mode2)
destroy(this.sle_msg)
destroy(this.gb_10)
destroy(this.rr_1)
destroy(this.rr_2)
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

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type p_exit from uo_picture within w_pdm_01630
integer x = 4398
integer y = 40
integer width = 178
integer taborder = 110
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

type p_can from uo_picture within w_pdm_01630
integer x = 4229
integer y = 40
integer width = 178
integer taborder = 90
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

integer icount, icount2, ilsu, ilsu2

//초기화
dw_list.setredraw(false)
dw_list2.setredraw(false)

dw_list.reset()
dw_list2.reset()

FOR icount=1 TO 15
    dw_list.insertrow(0)
    dw_list.SetItem(icount, "gugan", icount)

    SELECT "RESCAL"."GUILS"  
      INTO :ilsu  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
    dw_list.SetItem(icount, "guils", ilsu)
    
	 icount2 = icount + 15
	 dw_list2.insertrow(0)
    dw_list2.SetItem(icount, "gugan", icount2)
    
	 SELECT "RESCAL"."GUILS"  
      INTO :ilsu2  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
    dw_list2.SetItem(icount, "guils", ilsu2)
NEXT

dw_list.SetFocus()

dw_list.setredraw(true)
dw_list2.setredraw(true)

ib_any_typing = false

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_print from uo_picture within w_pdm_01630
integer x = 4059
integer y = 40
integer width = 178
integer taborder = 120
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event clicked;IF MessageBox("확인", "출력하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_1.settransobject(sqlca)
dw_1.Retrieve() 
dw_1.print()

w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type p_mod from uo_picture within w_pdm_01630
integer x = 3890
integer y = 40
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;String ymd, symd, eymd, ymd2, sdate, sdate2
int  nguils, icount
long ljdat, ljdat2

IF dw_list.Accepttext() = -1 THEN 	
	dw_list.setfocus()
	RETURN
END IF
IF dw_list2.Accepttext() = -1 THEN 	
	dw_list.setfocus()
	RETURN
END IF

//////////////////////////////////////////////////////
//   구간별로 일수를 가지고 시작일과 종료일을 계산  //
//////////////////////////////////////////////////////

w_mdi_frame.sle_msg.text = '작업중이오니 잠시만 기다려주세요.!!!'
SetPointer(HourGlass!)

//cb_cancel.TriggerEvent("clicked")

ymd = f_today()

//처음시작일 체크
SELECT JDATE  
  INTO :sdate  
  FROM P4_CALENDAR  
 WHERE CLDATE = :ymd   ;

dw_list.SetItem(1, "gusdt", ymd)

FOR icount=1 TO 15
    nguils = dw_list.GetItemNumber(icount, "guils") 
    if isnull(nguils) or nguils = 0 then 
		 w_mdi_frame.sle_msg.text = ''
		 messagebox("확인", "일수를 입력하십시요.!!")
       dw_list.SetRedraw(FALSE)
		 dw_list.setrow(icount)
		 dw_list.setfocus()
		 dw_list.SetRedraw(true)
    	 RETURN 1
	 end if

    symd   = dw_list.GetItemString(icount, "gusdt")
	 //시작일로 calndr 테이블을 읽어서 일수2를 가지고 온다
 	 SELECT JDATE  
      INTO :ljdat  
	   FROM P4_CALENDAR  
	  WHERE CLDATE = :symd   ;

	 ljdat = ljdat + nguils - 1  //현재row의 종료일수
	 ljdat2 = ljdat + 1          //다음row의 시작일수 
	 //현재row의 종료일 가지고 오기
	 SELECT MAX(CLDATE)  
      INTO :eymd  
      FROM P4_CALENDAR  
     WHERE ( JDATE = :ljdat ) ;
    //다음row의 시작일 가지고 오기
	 SELECT MAX(CLDATE)
      INTO :ymd2  
      FROM P4_CALENDAR  
     WHERE ( JDATE = :ljdat2 ) ;
    
	 dw_list.SetItem(icount, "guedt", eymd)
	 if icount <= 14 then
       dw_list.SetItem(icount+1, "gusdt", ymd2)
	 else
		 dw_list2.setitem(1 , "gusdt", ymd2)
	 end if
NEXT

FOR icount=1 TO 15
    nguils = dw_list2.GetItemNumber(icount, "guils") 
    if isnull(nguils) or nguils = 0  then 
		 w_mdi_frame.sle_msg.text = ''
		 messagebox("확인", "일수를 입력하십시요.!!")
       dw_list2.SetRedraw(FALSE)
	 	 dw_list2.setrow(icount)
		 dw_list2.setfocus()
    	 dw_list2.SetRedraw(true)
		 RETURN 1
    end if

    symd   = dw_list2.GetItemString(icount, "gusdt")
 	 SELECT JDATE  
      INTO :ljdat  
	   FROM P4_CALENDAR  
	  WHERE CLDATE = :symd   ;
	 
	 ljdat = ljdat + nguils - 1
	 ljdat2 = ljdat + 1
	 
	 //현재row의 종료일 가지고 오기
	 SELECT MAX(CLDATE)  
      INTO :eymd  
      FROM P4_CALENDAR  
     WHERE ( JDATE = :ljdat ) ;
    //다음row의 시작일 가지고 오기
	 SELECT MAX(CLDATE)
      INTO :ymd2  
      FROM P4_CALENDAR  
     WHERE ( JDATE = :ljdat2 ) ;
    
	 dw_list2.SetItem(icount, "guedt", eymd)
	 if icount <= 14 then
       dw_list2.SetItem(icount+1, "gusdt", ymd2)
	 end if
NEXT

//////////////////////////////////////////////////////////////////////////////

w_mdi_frame.sle_msg.text = ''

if f_msg_update() = -1 then return

DELETE FROM "RESCAL"  ;

IF dw_list.Update() > 0 THEN
	IF dw_list2.Update() > 0	THEN 
		
		COMMIT USING sqlca;
	ELSE
		ROLLBACK USING sqlca;
      messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
   END IF 
ELSE
	ROLLBACK USING sqlca;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
END IF

p_inq.TriggerEvent("clicked")

ib_any_typing = false
//w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_pdm_01630
integer x = 3721
integer y = 40
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;integer icount, icount2, ilsu, ilsu2
string  sdate, edate 

dw_list.settransobject(sqlca)
dw_list2.settransobject(sqlca)

//초기화
dw_list.setredraw(false)
dw_list2.setredraw(false)

dw_list.reset()
dw_list2.reset()

FOR icount=1 TO 15
    dw_list.insertrow(0)
    dw_list.SetItem(icount, "gugan", icount)
    
	 SELECT "RESCAL"."GUILS", "RESCAL"."GUSDT", "RESCAL"."GUEDT"    
      INTO :ilsu,   :sdate, :edate  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
    dw_list.SetItem(icount, "guils", ilsu)
    dw_list.SetItem(icount, "gusdt", sdate)
    dw_list.SetItem(icount, "guedt", edate)
    
	 icount2 = icount + 15
	 dw_list2.insertrow(0)
    dw_list2.SetItem(icount, "gugan", icount2)

	 SELECT "RESCAL"."GUILS", "RESCAL"."GUSDT", "RESCAL"."GUEDT"    
      INTO :ilsu2,   :sdate, :edate  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
    dw_list2.SetItem(icount, "guils", ilsu2)
    dw_list2.SetItem(icount, "gusdt", sdate)
    dw_list2.SetItem(icount, "guedt", edate)
NEXT

dw_list.SetFocus()

dw_list.setredraw(true)
dw_list2.setredraw(true)

ib_any_typing = false

//w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type cb_1 from commandbutton within w_pdm_01630
boolean visible = false
integer x = 1490
integer y = 2868
integer width = 352
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;call super::clicked;//integer icount, icount2, ilsu, ilsu2
//string  sdate, edate 
//
//dw_list.settransobject(sqlca)
//dw_list2.settransobject(sqlca)
//
////초기화
//dw_list.setredraw(false)
//dw_list2.setredraw(false)
//
//dw_list.reset()
//dw_list2.reset()
//
//FOR icount=1 TO 15
//    dw_list.insertrow(0)
//    dw_list.SetItem(icount, "gugan", icount)
//    
//	 SELECT "RESCAL"."GUILS", "RESCAL"."GUSDT", "RESCAL"."GUEDT"    
//      INTO :ilsu,   :sdate, :edate  
//      FROM "RESCAL"  
//     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
//    dw_list.SetItem(icount, "guils", ilsu)
//    dw_list.SetItem(icount, "gusdt", sdate)
//    dw_list.SetItem(icount, "guedt", edate)
//    
//	 icount2 = icount + 15
//	 dw_list2.insertrow(0)
//    dw_list2.SetItem(icount, "gugan", icount2)
//
//	 SELECT "RESCAL"."GUILS", "RESCAL"."GUSDT", "RESCAL"."GUEDT"    
//      INTO :ilsu2,   :sdate, :edate  
//      FROM "RESCAL"  
//     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
//    dw_list2.SetItem(icount, "guils", ilsu2)
//    dw_list2.SetItem(icount, "gusdt", sdate)
//    dw_list2.SetItem(icount, "guedt", edate)
//NEXT
//
//dw_list.SetFocus()
//
//dw_list.setredraw(true)
//dw_list2.setredraw(true)
//
//ib_any_typing = false
//
end event

type dw_1 from datawindow within w_pdm_01630
boolean visible = false
integer x = 613
integer y = 2944
integer width = 782
integer height = 92
boolean titlebar = true
string title = "구간 No별 구간일수 출력"
string dataobject = "d_pdm_01630_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pdm_01630
boolean visible = false
integer x = 73
integer y = 3244
integer width = 347
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

type dw_list2 from datawindow within w_pdm_01630
event ue_pressenter pbm_dwnprocessenter
integer x = 2354
integer y = 284
integer width = 1746
integer height = 1888
integer taborder = 30
string dataobject = "d_pdm_01630"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;	ib_any_typing = true

end event

type cb_cancel from commandbutton within w_pdm_01630
boolean visible = false
integer x = 2807
integer y = 2852
integer width = 352
integer height = 100
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;sle_msg.text = ''

integer icount, icount2, ilsu, ilsu2

//초기화
dw_list.setredraw(false)
dw_list2.setredraw(false)

dw_list.reset()
dw_list2.reset()

FOR icount=1 TO 15
    dw_list.insertrow(0)
    dw_list.SetItem(icount, "gugan", icount)

    SELECT "RESCAL"."GUILS"  
      INTO :ilsu  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
    dw_list.SetItem(icount, "guils", ilsu)
    
	 icount2 = icount + 15
	 dw_list2.insertrow(0)
    dw_list2.SetItem(icount, "gugan", icount2)
    
	 SELECT "RESCAL"."GUILS"  
      INTO :ilsu2  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
    dw_list2.SetItem(icount, "guils", ilsu2)
NEXT

dw_list.SetFocus()

dw_list.setredraw(true)
dw_list2.setredraw(true)

ib_any_typing = false

end event

type dw_datetime from datawindow within w_pdm_01630
boolean visible = false
integer x = 2917
integer y = 3244
integer width = 745
integer height = 96
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type cb_retrieve from commandbutton within w_pdm_01630
boolean visible = false
integer x = 2437
integer y = 2852
integer width = 352
integer height = 100
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "출력(&P)"
end type

event clicked;call super::clicked;//IF MessageBox("확인", "출력하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
//
//dw_1.settransobject(sqlca)
//dw_1.Retrieve() 
//dw_1.print()
end event

type cb_exit from commandbutton within w_pdm_01630
boolean visible = false
integer x = 3177
integer y = 2852
integer width = 352
integer height = 100
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
boolean cancel = true
end type

event clicked;call super::clicked;//
//IF wf_warndataloss("종료") = -1 THEN  	RETURN
//
//close(parent)


end event

type cb_save from commandbutton within w_pdm_01630
boolean visible = false
integer x = 2066
integer y = 2852
integer width = 352
integer height = 100
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;call super::clicked;//String ymd, symd, eymd, ymd2, sdate, sdate2
//int  nguils, icount
//long ljdat, ljdat2
//
//IF dw_list.Accepttext() = -1 THEN 	
//	dw_list.setfocus()
//	RETURN
//END IF
//IF dw_list2.Accepttext() = -1 THEN 	
//	dw_list.setfocus()
//	RETURN
//END IF
//
////////////////////////////////////////////////////////
////   구간별로 일수를 가지고 시작일과 종료일을 계산  //
////////////////////////////////////////////////////////
//
//sle_msg.text = '작업중이오니 잠시만 기다려주세요.!!!'
//SetPointer(HourGlass!)
//
////cb_cancel.TriggerEvent("clicked")
//
//ymd = f_today()
//
////처음시작일 체크
//SELECT JDATE  
//  INTO :sdate  
//  FROM P4_CALENDAR  
// WHERE CLDATE = :ymd   ;
//
//dw_list.SetItem(1, "gusdt", ymd)
//
//FOR icount=1 TO 15
//    nguils = dw_list.GetItemNumber(icount, "guils") 
//    if isnull(nguils) or nguils = 0 then 
//		 sle_msg.text = ''
//		 messagebox("확인", "일수를 입력하십시요.!!")
//       dw_list.SetRedraw(FALSE)
//		 dw_list.setrow(icount)
//		 dw_list.setfocus()
//		 dw_list.SetRedraw(true)
//    	 RETURN 1
//	 end if
//
//    symd   = dw_list.GetItemString(icount, "gusdt")
//	 //시작일로 calndr 테이블을 읽어서 일수2를 가지고 온다
// 	 SELECT JDATE  
//      INTO :ljdat  
//	   FROM P4_CALENDAR  
//	  WHERE CLDATE = :symd   ;
//
//	 ljdat = ljdat + nguils - 1  //현재row의 종료일수
//	 ljdat2 = ljdat + 1          //다음row의 시작일수 
//	 //현재row의 종료일 가지고 오기
//	 SELECT MAX(CLDATE)  
//      INTO :eymd  
//      FROM P4_CALENDAR  
//     WHERE ( JDATE = :ljdat ) ;
//    //다음row의 시작일 가지고 오기
//	 SELECT MAX(CLDATE)
//      INTO :ymd2  
//      FROM P4_CALENDAR  
//     WHERE ( JDATE = :ljdat2 ) ;
//    
//	 dw_list.SetItem(icount, "guedt", eymd)
//	 if icount <= 14 then
//       dw_list.SetItem(icount+1, "gusdt", ymd2)
//	 else
//		 dw_list2.setitem(1 , "gusdt", ymd2)
//	 end if
//NEXT
//
//FOR icount=1 TO 15
//    nguils = dw_list2.GetItemNumber(icount, "guils") 
//    if isnull(nguils) or nguils = 0  then 
//		 sle_msg.text = ''
//		 messagebox("확인", "일수를 입력하십시요.!!")
//       dw_list2.SetRedraw(FALSE)
//	 	 dw_list2.setrow(icount)
//		 dw_list2.setfocus()
//    	 dw_list2.SetRedraw(true)
//		 RETURN 1
//    end if
//
//    symd   = dw_list2.GetItemString(icount, "gusdt")
// 	 SELECT JDATE  
//      INTO :ljdat  
//	   FROM P4_CALENDAR  
//	  WHERE CLDATE = :symd   ;
//	 
//	 ljdat = ljdat + nguils - 1
//	 ljdat2 = ljdat + 1
//	 
//	 //현재row의 종료일 가지고 오기
//	 SELECT MAX(CLDATE)  
//      INTO :eymd  
//      FROM P4_CALENDAR  
//     WHERE ( JDATE = :ljdat ) ;
//    //다음row의 시작일 가지고 오기
//	 SELECT MAX(CLDATE)
//      INTO :ymd2  
//      FROM P4_CALENDAR  
//     WHERE ( JDATE = :ljdat2 ) ;
//    
//	 dw_list2.SetItem(icount, "guedt", eymd)
//	 if icount <= 14 then
//       dw_list2.SetItem(icount+1, "gusdt", ymd2)
//	 end if
//NEXT
//
////////////////////////////////////////////////////////////////////////////////
//
//sle_msg.text = ''
//
//if f_msg_update() = -1 then return
//
//DELETE FROM "RESCAL"  ;
//
//IF dw_list.Update() > 0 THEN
//	IF dw_list2.Update() > 0	THEN 
//		
//		COMMIT USING sqlca;
//	ELSE
//		ROLLBACK USING sqlca;
//      messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//   END IF 
//ELSE
//	ROLLBACK USING sqlca;
//   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//END IF
//
//cb_1.TriggerEvent("clicked")
//
//ib_any_typing = false
end event

type dw_list from datawindow within w_pdm_01630
event ue_pressenter pbm_dwnprocessenter
integer x = 453
integer y = 284
integer width = 1746
integer height = 1888
integer taborder = 20
string dataobject = "d_pdm_01630"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;	ib_any_typing = true

end event

type gb_2 from groupbox within w_pdm_01630
boolean visible = false
integer x = 1445
integer y = 2800
integer width = 439
integer height = 204
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_mode2 from groupbox within w_pdm_01630
boolean visible = false
integer x = 2025
integer y = 2784
integer width = 1541
integer height = 204
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 65535
long backcolor = 79741120
end type

type sle_msg from singlelineedit within w_pdm_01630
boolean visible = false
integer x = 425
integer y = 3244
integer width = 2491
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type gb_10 from groupbox within w_pdm_01630
boolean visible = false
integer x = 59
integer y = 3192
integer width = 3611
integer height = 152
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

type rr_1 from roundrectangle within w_pdm_01630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 439
integer y = 272
integer width = 1792
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2341
integer y = 272
integer width = 1792
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

