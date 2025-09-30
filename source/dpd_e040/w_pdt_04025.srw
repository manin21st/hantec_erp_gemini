$PBExportHeader$w_pdt_04025.srw
$PBExportComments$입고승인등록(명세서별)
forward
global type w_pdt_04025 from window
end type
type pb_cal from u_pb_cal within w_pdt_04025
end type
type p_save from uo_picture within w_pdt_04025
end type
type p_exit from uo_picture within w_pdt_04025
end type
type p_cancel from uo_picture within w_pdt_04025
end type
type p_inq from uo_picture within w_pdt_04025
end type
type dw_3 from datawindow within w_pdt_04025
end type
type dw_list from u_d_select_sort within w_pdt_04025
end type
type dw_1 from datawindow within w_pdt_04025
end type
type rb_2 from radiobutton within w_pdt_04025
end type
type rb_1 from radiobutton within w_pdt_04025
end type
type gb_3 from groupbox within w_pdt_04025
end type
type rr_1 from roundrectangle within w_pdt_04025
end type
type rr_2 from roundrectangle within w_pdt_04025
end type
type rr_3 from roundrectangle within w_pdt_04025
end type
end forward

shared variables

end variables

global type w_pdt_04025 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "입고승인등록(명세서별)"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_cal pb_cal
p_save p_save
p_exit p_exit
p_cancel p_cancel
p_inq p_inq
dw_3 dw_3
dw_list dw_list
dw_1 dw_1
rb_2 rb_2
rb_1 rb_1
gb_3 gb_3
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pdt_04025 w_pdt_04025

type variables
char  ic_status

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

String     is_ispec,  is_jijil 
end variables

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_window_id = this.ClassName()
is_today = f_today()
is_totime = f_totime()
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


///////////////////////////////////////////////////////////////////////////
dw_1.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_list.settransobject(sqlca)

p_cancel.TriggerEvent("clicked")

f_child_saupj(dw_1, 'house', gs_saupj)
f_child_saupj(dw_1, 'pdtgu', gs_saupj)

end event

on w_pdt_04025.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.pb_cal=create pb_cal
this.p_save=create p_save
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_inq=create p_inq
this.dw_3=create dw_3
this.dw_list=create dw_list
this.dw_1=create dw_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_3=create gb_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.Control[]={this.pb_cal,&
this.p_save,&
this.p_exit,&
this.p_cancel,&
this.p_inq,&
this.dw_3,&
this.dw_list,&
this.dw_1,&
this.rb_2,&
this.rb_1,&
this.gb_3,&
this.rr_1,&
this.rr_2,&
this.rr_3}
end on

on w_pdt_04025.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_cal)
destroy(this.p_save)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_inq)
destroy(this.dw_3)
destroy(this.dw_list)
destroy(this.dw_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event closequery;
string s_frday, s_frtime

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

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
	Case KeyR!
		p_SAVE.TriggerEvent(Clicked!)
	Case KeyC!
		p_canCEL.TriggerEvent(Clicked!)
End Choose
end event

type pb_cal from u_pb_cal within w_pdt_04025
integer x = 2725
integer y = 192
integer taborder = 20
end type

event clicked;call super::clicked;dw_1.SetColumn('edate')
IF IsNull(gs_code) THEN Return
If dw_1.Object.edate.protect = '1' Or dw_1.Object.edate.TabSequence = '0' Then Return

dw_1.SetItem(1, 'edate', gs_code)
end event

type p_save from uo_picture within w_pdt_04025
integer x = 4046
integer y = 16
integer width = 178
integer taborder = 30
string pointer = "c:\ERPMAN\cur\create.cur"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\처리_d.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event clicked;call super::clicked;if dw_1.AcceptText() = -1 then return
if dw_list.AcceptText() = -1 then return

IF dw_list.RowCount() < 1	THEN	RETURN

////////////////////////////////////////////////////////
string	sDate, sEmpno, sHouse, sNull, sSalegu, sInsdat, sIpjpno, sIoDate, sIgbn
dec{3}	dQty
dec{5}   dPrice
long		lRow

sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
sEmpno = dw_1.GetItemString(1, "empno")

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[입고승인일]')
	dw_1.SetColumn("edate")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sEmpno) or sEmpno = "" 	THEN
	f_message_chk(30,'[입고승인자]')
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	RETURN
END IF

SetNull(sNull)
////////////////////////////////////////////////////////

IF dw_list.rowcount() < 1 then
	Messagebox("저장내역", "저장할 내역이 없읍니다", stopsign!)
	return
end if

IF f_msg_update() = -1 	THEN	RETURN

SetPointer(HourGlass!)

FOR  lRow = 1	TO		dw_list.RowCount()

	dQty   = dw_list.GetItemDecimal(lRow, "iosuqty")
	dPrice = dw_list.GetItemDecimal(lRow, "ioprc")
	sIpjpno = dw_list.GetItemString(lRow, "imhist_ip_jpno")
	sIgbn = dw_list.GetItemString(lRow, "imhist_iogbn")

	if rb_1.checked then
		sInsdat  = dw_list.GetItemString(lRow, 'insdat')   //검사일자
		IF sinsdat > sDate then 
			messagebox("확 인", "입고승인일을 확인하세요. 승인일자가 검사일자 보다 작을 수 없습니다.")
			dw_1.SetColumn("edate")
			dw_1.SetFocus()
			return 
		End if
		
		// 승인
		dw_list.SetItem(lRow, "ioamt", 	 TRUNCATE(dQty * dPrice, 2))
		dw_list.SetItem(lRow, "ioqty", 	 dQty)
		dw_list.SetItem(lRow, "io_date",  sDate)
		dw_list.SetItem(lRow, "io_empno", sEmpno)

		//수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 
		//검수일자에 승인일자를 move
		sSalegu = dw_list.GetItemString(lRow, "salegu")
		IF sSalegu = 'Y' Then 
			dw_list.SetItem(lRow, "yebi1",  sDate)
			dw_list.SetItem(lRow, "dyebi3", 	 TRUNCATE(dQty * dPrice, 2) * 0.1)			
		END IF 		
		
		/*직접출고로 등록한 사업장도 이동되는 출고는 출고승인일자와 수불승인여부, 수불수량이 업데이트 되지 않아 입고승인시 출고자료도 수정 2023.08.09 by dykim */
			SELECT IO_DATE
			   INTO :sIoDate
			  FROM IMHIST
			WHERE IOJPNO = :sIpjpno;
		 
			IF isNull(sIodate) Then
				UPDATE IMHIST
				      SET  IO_DATE = :sDate,
							IOQTY = :dQty	
				 WHERE	IOJPNO = :sIpjpno;
			 
				If SQLCA.SQLCODE <> 0 Then
					rollback;
					MessageBox("출고자료 업데이트 실패", "출고자료의 출고일자 업데이트 실패하였습니다.")
					return
				End if	
			END IF
		
			
	else
		
		sIpjpno = dw_list.GetItemString(lRow, "imhist_ip_jpno")
		sIgbn = dw_list.GetItemString(lRow, "imhist_iogbn")
		
		/*직접출고로 등록한 사업장도 이동되는 출고는 출고승인일자와 수불승인여부, 수불수량이 업데이트 되지 않아 입고승인시 출고자료도 수정 2023.08.09 by dykim */		
			SELECT IO_DATE
			   INTO :sIoDate
			  FROM IMHIST
			WHERE IOJPNO = :sIpjpno;
		 
			IF isNull(sIodate) Then
			else	
				UPDATE IMHIST
				      SET  IO_DATE = :sNull,
							IOQTY = 0	
				 WHERE	IOJPNO = :sIpjpno;
			 
				IF SQLCA.SQLCODE <> 0 Then
					rollback;
					MessageBox("출고자료 업데이트 실패", "출고자료의 출고일자 업데이트 실패하였습니다.")
					return
				END IF
			END IF
		
		// 승인취소
		dw_list.SetItem(lRow, "ioamt", 	 0)
		dw_list.SetItem(lRow, "ioqty", 	 0)
		dw_list.SetItem(lRow, "io_date",  sNull)
		dw_list.SetItem(lRow, "io_empno", sNull)
		
		
		//반대로 수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 검수일자 clear
		sSalegu = dw_list.GetItemString(lRow, "salegu")
		IF sSalegu = 'Y' Then 
			dw_list.SetItem(lRow, "yebi1",  sNull)
			dw_list.SetItem(lRow, "dyebi3", 0)						
		END IF 		
			
	END IF

NEXT


//////////////////////////////////////////////////////////////////////

IF dw_list.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
	Return
END IF

dw_list.Reset()
p_save.enabled = False
p_inq.triggerevent(clicked!)

SetPointer(Arrow!)

end event

type p_exit from uo_picture within w_pdt_04025
integer x = 4393
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;
close(parent)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_cancel from uo_picture within w_pdt_04025
integer x = 4219
integer y = 16
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;string	sToday
sToday = f_Today()

dw_1.SetRedraw(false)

dw_1.Reset()
dw_list.Reset()

dw_1.InsertRow(0)
dw_1.SetItem(1, "edate", sToday)

dw_1.SetRedraw(true)

////////////////////////////////////////////////////////
p_save.enabled = False
p_save.PictureName = 'c:\erpman\image\처리_d.gif'

rb_1.checked = true
rb_1.TriggerEvent("clicked")
end event

type p_inq from uo_picture within w_pdt_04025
integer x = 3872
integer y = 16
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;string	sHouse, sGubun, sDate, sTitle, siogbn, pdtgu, sidate, stdate, sempno,	&
			sSaupj

if dw_1.accepttext() = -1 then return 

sSaupj = dw_1.GetItemString(1, "saupj")
sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
siDate  = trim(dw_1.GetItemString(1, "idate"))
stDate  = trim(dw_1.GetItemString(1, "tdate"))
siogbn = dw_1.GetItemString(1, "iogbn")
pdtgu = Trim(dw_1.GetItemString(1, "pdtgu"))
sempno = Trim(dw_1.GetItemString(1, "empno"))

IF isnull(sSaupj) or sSaupj = "" 	THEN
	f_message_chk(30,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	RETURN
END IF


IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

if rb_1.checked then
	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[입고승인일]')
		dw_1.SetColumn("edate")
		dw_1.SetFocus()
		RETURN
	END IF
end if

IF isnull(sEmpno) or sEmpno = "" 	THEN
	f_message_chk(30,'[승인자]')
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sidate) or sidate = "" 	THEN  sidate = '10000101'
IF isnull(stdate) or stdate = "" 	THEN  stdate = '99991231'
IF sidate > stdate 	THEN
	if rb_1.checked then
		f_message_chk(34,'[의뢰일자]')
		dw_1.SetColumn("idate")
		dw_1.SetFocus()
		RETURN
	else
		f_message_chk(34,'[의뢰일자]')
		dw_1.SetColumn("idate")
		dw_1.SetFocus()
		RETURN		
	end if
END IF

IF isnull(siogbn) or siogbn = "" 	THEN
	siogbn = '%'
END IF

/////////////////////////////////////////////////////
// 입고미승인 내역
/////////////////////////////////////////////////////
SetPointer(HourGlass!)

long	lRowCount

dw_3.SetRedraw(False)
dw_3.SetFilter("")
if not(IsNull(pdtgu) or pdtgu = "") then
	dw_3.SetFilter("pdtgu = '" + pdtgu + "'")
end if
dw_3.Filter( )

IF rb_1.checked  = true		THEN
	sGubun = 'N'
	sTitle = '[입고미승인현황]'
	lRowCount = dw_3.Retrieve(gs_sabu, sHouse, siogbn, sidate, stdate, sSaupj)
ELSE
	sGubun = 'Y'
	sTitle = '[입고승인현황]'
	lRowCount = dw_3.Retrieve(gs_sabu, sHouse, siDate, stdate, siogbn, sempno, sSaupj)
END IF
dw_3.SetRedraw(True)

IF lRowCount < 1	THEN
	f_message_chk(50, sTitle)
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

p_save.enabled = true
p_save.PictureName = 'c:\erpman\image\처리_up.gif'


end event

type dw_3 from datawindow within w_pdt_04025
integer x = 96
integer y = 436
integer width = 4425
integer height = 620
string dataobject = "d_pdt_04025_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;String 	sIojpno, sempno,		&
			sSaupj

sempno = Trim(dw_1.GetItemString(1, "empno"))

if row > 0 then
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)	

	sIojpno = getitemstring(row, "imhist_iojpno")
	sSaupj  = getitemstring(row, "saupj")
	dw_list.retrieve(gs_sabu, siojpno, sSaupj)

end if
	
end event

type dw_list from u_d_select_sort within w_pdt_04025
event ue_downenter pbm_dwnprocessenter
integer x = 82
integer y = 1092
integer width = 4453
integer height = 1112
integer taborder = 0
string dataobject = "d_pdt_04025_03"
boolean border = false
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;//string scheck, siojpno, sinsdat, sio_date
//long   lcount
//
//IF this.GetColumnName() ="io_check"   THEN
//	scheck = this.GetText()
//	
//	IF	scheck = 'N'	Then	RETURN 
//
//	IF rb_2.checked THEN 
//	
//		siojpno = this.getitemstring(row, 'iojpno')
//	
//		SELECT COUNT(*)
//		  INTO :lcount
//		  FROM HOLDSTOCK  
//		 WHERE SABU = :gs_sabu AND OUT_CHK = '2' AND 
//				 HOLD_NO in ( SELECT HOLD_NO  FROM HOLDSTOCK_AUTO  
//									WHERE SABU = :gs_sabu AND IOJPNO = :siojpno ) ;
//	
//		IF lcount > 0 then 
//			messagebox("확 인", "송장발행된 자료는 승인취소 할 수 없습니다.")
//			return 2
//		end if
//   ELSE
//      sinsdat  = this.GetItemString(row, 'insdat')  //검사일자
//      dw_1.accepttext()
//      sio_date = dw_1.GetItemString(1, 'edate')     //입고승인일
//		
//		IF sinsdat > sio_date then 
//			messagebox("확 인", "입고승인일을 확인하세요. 승인일자가 검사일자 보다 작을 수 없습니다.")
//			return 1
//		end if
//	END IF
//END IF
//
end event

event itemerror;Return 1
end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type dw_1 from datawindow within w_pdt_04025
event ue_downenter pbm_dwnprocessenter
event ud_downkey pbm_dwnkey
integer x = 114
integer y = 192
integer width = 3941
integer height = 172
integer taborder = 10
string dataobject = "d_pdt_04021"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ud_downkey;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

if keydown(keydelete!) and this.getcolumnname() = 'iogbn' then
	string snull
	setnull(snull)
	setitem(1, "iogbn", snull)
end if
end event

event rbuttondown;string shouse, sPass

gs_code = ''
gs_codename = ''
gs_gubun = ''

this.accepttext() 
// 입고승인담당자
IF this.GetColumnName() = 'empno'	THEN
   gs_gubun = '2' 
	gs_code = this.getitemstring(1, 'house')
	shouse  = gs_code
	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

   If isnull(shouse) or shouse = '' or shouse <> gs_gubun then 
		SELECT DAJIGUN
		  INTO :sPass
		  FROM VNDMST
		 WHERE CVCOD = :gs_gubun AND 
				 CVGU = '5'		  AND
				 CVSTATUS = '0' ;
		 
		if sqlca.sqlcode <> 0 	then
			f_message_chk(33,'[출고창고]')
			return 
		end if
	
		IF not (sPass ="" OR IsNull(sPass)) THEN
			OpenWithParm(W_PGM_PASS,spass)
			IF Message.StringParm = "CANCEL" THEN 
				return 
			END IF		
		END IF
   End if
	
	SetItem(1,"house",gs_gubun)
	SetItem(1,"empno",gs_code)
	SetItem(1,"name",gs_codename)
	
END IF
end event

event itemerror;return 1
end event

event itemchanged;string	sCode, sName,	&
			sDate, sHouse, sempno, &
			sYN,	 sNull, sname2, sPass, ssaupj 
int      ireturn 			
long     k

SetNull(sNull)

IF this.GetColumnName() = 'edate' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[입고승인일]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'idate' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[의뢰일자]')
		this.setitem(1, "idate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'tdate' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[의뢰일자]')
		this.setitem(1, "tdate", sNull)
		return 1
	END IF
// 창고 -> 매출여부 확인
ELSEIF this.GetColumnName() = 'house' THEN

	sHouse = this.gettext()
	
	SELECT HOMEPAGE, DAJIGUN, IPJOGUN
	  INTO :sYN, :sPass, :ssaupj
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[창고]')
		this.setitem(1, "house", sNull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		this.setitem(1, "saupj", sNull)		
		dw_list.reset()
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "house", sNull)
			this.setitem(1, "empno", sNull)
			this.setitem(1, "name", sNull)
			this.setitem(1, "saupj", sNull)					
			dw_list.reset()
			return 1
      END IF		
	END IF
	
	this.setitem(1, "empno", sNull)
	this.setitem(1, "name", sNull)
	this.setitem(1, "saupj", sSaupj)
	dw_list.reset()

	SELECT A.EMPNO, B.EMPNAME INTO :sempno, :sname
		FROM DEPOT_EMP A, P1_MASTER B
		WHERE A.EMPNO = B.EMPNO
		AND	A.DEPOT_NO = :sHouse AND A.OWNER = 'Y';
		
	If isNull(sempno) Or sempno = '' Then
		this.SetItem(1,"empno", '')
		this.SetItem(1,"name", '')
	Else
		this.SetItem(1,"empno", sempno)
		this.SetItem(1,"name", sname)
	End If

// 입고승인담당자 
ELSEIF this.GetColumnName() = "empno" THEN

	scode = this.GetText()								
	
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'name', sname)
      return 
   end if
   this.accepttext()
	
	sname2 = this.getitemstring(1, 'house')
	
	if sname2 = '' or isnull(sname2) then 
	   messagebox("확 인", "창고를 먼저 입력하세요")
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if
	
   ireturn = f_get_name2('입고승인자', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'name', sname)
   return ireturn 
elseif this.getcolumnname() = 'saupj' then 
	scode = this.GetText()								
	f_child_saupj(this, 'house', scode)
	f_child_saupj(this, 'pdtgu', scode)
END IF

end event

event losefocus;dw_1.accepttext()
end event

type rb_2 from radiobutton within w_pdt_04025
integer x = 4151
integer y = 276
integer width = 347
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33554431
string text = "승인취소"
end type

event clicked;string snull

setnull(snull)

ic_status = '2'

gb_3.text = '입고 승인 내역'

dw_1.Modify("edate.Visible= 0") 
dw_1.Modify("edate_t.Visible= 0") 
dw_1.Modify("idate_t.text = '승인일자'")
pb_cal.Visible = False

dw_3.DataObject = 'd_pdt_04025_02'
dw_3.SetTransObject(sqlca)

dw_list.DataObject = 'd_pdt_04025_03'
dw_list.SetTransObject(sqlca)

dw_list.object.itemas_ispec_t.text = is_ispec
dw_list.object.jijil_t.text = is_jijil

//cb_save.Text = "취소저장(&S)"
dw_1.setcolumn('house')
dw_1.setfocus()


end event

type rb_1 from radiobutton within w_pdt_04025
integer x = 4151
integer y = 204
integer width = 347
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33554431
string text = "입고승인"
boolean checked = true
end type

event clicked;
ic_status = '1'

gb_3.text = '입고 대기 내역'

dw_1.Modify("edate.Visible= 1") 
dw_1.Modify("edate_t.Visible= 1") 
dw_1.Modify("idate_t.text = '의뢰일자'")
pb_cal.Visible = True

dw_1.setItem(1, "idate", left(is_today, 6) + '01')
dw_1.setItem(1, "tdate", is_today)

dw_3.DataObject = 'd_pdt_04025_01'
dw_3.SetTransObject(sqlca)

dw_list.DataObject = 'd_pdt_04025_03'
dw_list.SetTransObject(sqlca)

//dw_list.object.itemas_ispec_t.text = is_ispec
//dw_list.object.jijil_t.text = is_jijil

f_mod_saupj(dw_1, 'saupj')

dw_1.setcolumn('house')
dw_1.setfocus()

//p_save.Text = "승인저장(&S)"
dw_1.setcolumn('house')
dw_1.setfocus()

end event

type gb_3 from groupbox within w_pdt_04025
integer x = 73
integer y = 388
integer width = 4480
integer height = 680
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "입고 대기 내역"
end type

type rr_1 from roundrectangle within w_pdt_04025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 73
integer y = 176
integer width = 4000
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_04025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 1080
integer width = 4480
integer height = 1132
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdt_04025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4105
integer y = 176
integer width = 448
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

