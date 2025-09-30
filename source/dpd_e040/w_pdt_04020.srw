$PBExportHeader$w_pdt_04020.srw
$PBExportComments$입고승인등록(개별)
forward
global type w_pdt_04020 from window
end type
type pb_3 from u_pb_cal within w_pdt_04020
end type
type pb_2 from u_pb_cal within w_pdt_04020
end type
type pb_1 from u_pb_cal within w_pdt_04020
end type
type cbx_select from checkbox within w_pdt_04020
end type
type p_exit from uo_picture within w_pdt_04020
end type
type p_can from uo_picture within w_pdt_04020
end type
type p_mod from uo_picture within w_pdt_04020
end type
type p_inq from uo_picture within w_pdt_04020
end type
type p_search from uo_picture within w_pdt_04020
end type
type dw_list from u_d_select_sort within w_pdt_04020
end type
type cb_1 from commandbutton within w_pdt_04020
end type
type dw_1 from datawindow within w_pdt_04020
end type
type rb_2 from radiobutton within w_pdt_04020
end type
type rb_1 from radiobutton within w_pdt_04020
end type
type cb_cancel from commandbutton within w_pdt_04020
end type
type cb_retrieve from commandbutton within w_pdt_04020
end type
type cb_exit from commandbutton within w_pdt_04020
end type
type cb_save from commandbutton within w_pdt_04020
end type
type rr_1 from roundrectangle within w_pdt_04020
end type
type rr_2 from roundrectangle within w_pdt_04020
end type
type rr_3 from roundrectangle within w_pdt_04020
end type
end forward

shared variables

end variables

global type w_pdt_04020 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "입고승인등록(개별)"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
cbx_select cbx_select
p_exit p_exit
p_can p_can
p_mod p_mod
p_inq p_inq
p_search p_search
dw_list dw_list
cb_1 cb_1
dw_1 dw_1
rb_2 rb_2
rb_1 rb_1
cb_cancel cb_cancel
cb_retrieve cb_retrieve
cb_exit cb_exit
cb_save cb_save
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pdt_04020 w_pdt_04020

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

///////////////////////////////////////////////////////////////////////////
dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)

p_can.TriggerEvent("clicked")
end event

on w_pdt_04020.create
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.cbx_select=create cbx_select
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.p_inq=create p_inq
this.p_search=create p_search
this.dw_list=create dw_list
this.cb_1=create cb_1
this.dw_1=create dw_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_cancel=create cb_cancel
this.cb_retrieve=create cb_retrieve
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.Control[]={this.pb_3,&
this.pb_2,&
this.pb_1,&
this.cbx_select,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.p_inq,&
this.p_search,&
this.dw_list,&
this.cb_1,&
this.dw_1,&
this.rb_2,&
this.rb_1,&
this.cb_cancel,&
this.cb_retrieve,&
this.cb_exit,&
this.cb_save,&
this.rr_1,&
this.rr_2,&
this.rr_3}
end on

on w_pdt_04020.destroy
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.cbx_select)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.p_search)
destroy(this.dw_list)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_cancel)
destroy(this.cb_retrieve)
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
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

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type pb_3 from u_pb_cal within w_pdt_04020
integer x = 3950
integer y = 284
integer taborder = 40
end type

event clicked;call super::clicked;dw_1.Setcolumn('tdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'tdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_04020
integer x = 3515
integer y = 284
integer taborder = 30
end type

event clicked;call super::clicked;dw_1.Setcolumn('idate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'idate', gs_code)
end event

type pb_1 from u_pb_cal within w_pdt_04020
integer x = 2642
integer y = 200
integer taborder = 20
end type

event clicked;call super::clicked;dw_1.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'edate', gs_code)
end event

type cbx_select from checkbox within w_pdt_04020
integer x = 4210
integer y = 420
integer width = 334
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;String  sStatus, sItnbr, sIspec, Sdatachk
Integer k, nRow
Double  dHoldQty,dIsQty, dJegoQty, dValidQty, dStkQty 

IF cbx_select.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

/* 입고 승인 처리 */
IF ic_status = '1' And sStatus = 'N' THEN
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,"io_check",sStatus)
	NEXT
ElseIF ic_status = '1' And sStatus = 'Y' THEN
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,"io_check",sStatus)
	NEXT
	
ELSE
/* 입고 승인 취소 */
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,"io_check",sStatus)
	NEXT	
END IF


end event

type p_exit from uo_picture within w_pdt_04020
integer x = 4411
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_pdt_04020
integer x = 4238
integer y = 16
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string	sToday
sToday = f_Today()

dw_1.SetRedraw(false)

dw_1.Reset()
dw_list.Reset()

dw_1.InsertRow(0)
dw_1.SetItem(1, "edate", sToday)

dw_1.SetRedraw(true)

// 부가세 사업장 설정
f_mod_saupj(dw_1, 'saupj')

f_child_saupj(dw_1, 'pdtgu', gs_saupj)
f_child_saupj(dw_1, 'house', gs_saupj)

////////////////////////////////////////////////////////
p_mod.enabled = false
p_mod.picturename = "C:\erpman\image\저장_d.gif"

rb_1.checked = true
rb_1.TriggerEvent("clicked")
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_mod from uo_picture within w_pdt_04020
integer x = 3890
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_d.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


if dw_1.AcceptText() = -1 then return
if dw_list.AcceptText() = -1 then return

IF dw_list.RowCount() < 1	THEN	RETURN

////////////////////////////////////////////////////////
string	sDate, sEmpno, sHouse, sCheck, sNull, sSalegu, ls_saupj
dec{3}	dQty
dec{5}   dPrice
long		lRow

sHouse 	= dw_1.GetItemString(1, "house")
sDate  	= trim(dw_1.GetItemString(1, "edate"))
sEmpno 	= dw_1.GetItemString(1, "empno")
ls_saupj	= dw_1.GetItemString(1, "saupj")

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


IF rb_1.checked = true	THEN
	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[입고승인자]')
		dw_1.SetColumn("empno")
		dw_1.SetFocus()
		RETURN
	END IF
END IF


SetNull(sNull)
////////////////////////////////////////////////////////

IF f_msg_update() = -1 	THEN	RETURN

SetPointer(HourGlass!)

FOR  lRow = 1	TO		dw_list.RowCount()

	dQty      = dw_list.GetItemDecimal(lRow, "iosuqty")
	dPrice    = dw_list.GetItemDecimal(lRow, "ioprc")
	sCheck    = dw_list.GetItemString(lRow, "io_check")

	if rb_1.checked then

		IF sCheck = 'Y'	THEN		// 승인
			dw_list.SetItem(lRow, "ioamt", 	 TRUNCATE(dQty * dPrice, 2))
			dw_list.SetItem(lRow, "ioqty", 	 dQty)
			dw_list.SetItem(lRow, "io_date",  sDate)
			dw_list.SetItem(lRow, "io_empno", sEmpno)

			//수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 
			//검수일자에 승인일자를 move
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sDate)
				dw_list.Setitem(lRow, "dyebi3", TRUNCATE(dQty * dPrice, 2) * 0.1)
	      END IF 		
		End if
	else
		IF sCheck = 'Y'	THEN		// 승인취소
			dw_list.SetItem(lRow, "ioamt", 	 0)
			dw_list.SetItem(lRow, "ioqty", 	 0)
			dw_list.SetItem(lRow, "io_date",  sNull)
			dw_list.SetItem(lRow, "io_empno", sNull)

			//반대로 수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 검수일자 clear
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sNull)
				dw_list.Setitem(lRow, "dyebi3", 0)				
	      END IF 		
		End if
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
p_mod.enabled = false
p_mod.picturename = "C:\erpman\image\저장_d.gif"


SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_pdt_04020
integer x = 3717
integer y = 16
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string	sHouse, sGubun, sDate, sTitle, siogbn, pdtgu, sidate, stdate, sempno

if dw_1.accepttext() = -1 then return 

sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
siDate  = trim(dw_1.GetItemString(1, "idate"))
stDate  = trim(dw_1.GetItemString(1, "tdate"))
siogbn = dw_1.GetItemString(1, "iogbn")
pdtgu = Trim(dw_1.GetItemString(1, "pdtgu"))
sempno = Trim(dw_1.GetItemString(1, "empno"))


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
	dw_1.SetColumn("house")
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

dw_list.SetRedraw(False)
dw_list.SetFilter("")
if not(IsNull(pdtgu) or pdtgu = "") then
	dw_list.SetFilter("pdtgu = '" + pdtgu + "'")
end if
dw_list.Filter( )

IF rb_1.checked  = true		THEN
	sGubun = 'N'
	sTitle = '[입고미승인현황]'
	lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siogbn, sidate, stdate, gs_saupj)
ELSE
	sGubun = 'Y'
	sTitle = '[입고승인현황]'
	lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siDate, stdate, siogbn, sempno, gs_saupj)
END IF
dw_list.SetRedraw(True)

IF lRowCount < 1	THEN
	f_message_chk(50, sTitle)
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

p_mod.enabled = true
p_mod.picturename = "C:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_search from uo_picture within w_pdt_04020
integer x = 4064
integer y = 16
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Long i, lcount
string sinsdat, sio_date

IF dw_1.accepttext() = -1 THEN RETURN 

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

IF rb_2.checked THEN 
	For i = 1 to lCount
		IF dw_list.GetItemString(i, 'outchk') = 'Y' then 
			dw_list.object.io_check[i] = "Y"
		END IF	
	Next	
ELSE
	For i = 1 to lCount
		sinsdat  = dw_list.GetItemString(i, 'insdat')  //검사일자
		sio_date = dw_1.GetItemString(1, 'edate')     //입고승인일
		
		IF sinsdat <= sio_date then 
			dw_list.object.io_check[i] = "Y"
		End if
	Next	
END IF


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\button_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\button_up.gif"
end event

type dw_list from u_d_select_sort within w_pdt_04020
event ue_downenter pbm_dwnprocessenter
integer x = 41
integer y = 504
integer width = 4517
integer height = 1796
integer taborder = 20
string dataobject = "d_pdt_04020"
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string scheck, siojpno, sinsdat, sio_date
long   lcount

IF this.GetColumnName() ="io_check"   THEN
	scheck = this.GetText()
	
	IF	scheck = 'N'	Then	RETURN 

	IF rb_2.checked THEN 
	
		siojpno = this.getitemstring(row, 'iojpno')
	
		SELECT COUNT(*)
		  INTO :lcount
		  FROM HOLDSTOCK  
		 WHERE SABU = :gs_sabu AND OUT_CHK = '2' AND 
				 HOLD_NO in ( SELECT HOLD_NO  FROM HOLDSTOCK_AUTO  
									WHERE SABU = :gs_sabu AND IOJPNO = :siojpno ) ;
	
		IF lcount > 0 then 
			messagebox("확 인", "송장발행된 자료는 승인취소 할 수 없습니다.")
			return 2
		end if
   ELSE
      sinsdat  = this.GetItemString(row, 'insdat')  //검사일자
      dw_1.accepttext()
      sio_date = dw_1.GetItemString(1, 'edate')     //입고승인일
		
		IF sinsdat > sio_date then 
			messagebox("확 인", "입고승인일을 확인하세요. 승인일자가 검사일자 보다 작을 수 없습니다.")
			return 1
		end if
	END IF
END IF

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

type cb_1 from commandbutton within w_pdt_04020
boolean visible = false
integer x = 3776
integer y = 2472
integer width = 311
integer height = 92
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄선택"
end type

event clicked;Long i, lcount
string sinsdat, sio_date

IF dw_1.accepttext() = -1 THEN RETURN 

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

IF rb_2.checked THEN 
	For i = 1 to lCount
		IF dw_list.GetItemString(i, 'outchk') = 'Y' then 
			dw_list.object.io_check[i] = "Y"
		END IF	
	Next	
ELSE
	For i = 1 to lCount
		sinsdat  = dw_list.GetItemString(i, 'insdat')  //검사일자
		sio_date = dw_1.GetItemString(1, 'edate')     //입고승인일
		
		IF sinsdat <= sio_date then 
			dw_list.object.io_check[i] = "Y"
		End if
	Next	
END IF


end event

type dw_1 from datawindow within w_pdt_04020
event ue_downenter pbm_dwnprocessenter
event ud_downkey pbm_dwnkey
integer x = 46
integer y = 200
integer width = 4014
integer height = 176
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
   if ic_status = '1' then 
		For k = 1 to dw_list.RowCount() 
			dw_list.object.io_check[k] = 'N'
		Next	
	end if
	
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
	this.setitem(1, "saupj", ssaupj)
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

type rb_2 from radiobutton within w_pdt_04020
integer x = 4201
integer y = 296
integer width = 347
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "승인취소"
end type

event clicked;string snull

setnull(snull)

ic_status = '2'

dw_1.Modify("edate.Visible= 0") 
dw_1.Modify("edate_t.Visible= 0") 
dw_1.Modify("idate_t.text = '승인일자'")

dw_list.DataObject = 'd_pdt_04022'
dw_list.SetTransObject(sqlca)
pb_1.visible = False
//dw_list.object.itemas_ispec_t.text = is_ispec
//dw_list.object.jijil_t.text = is_jijil
//
//cb_save.Text = "취소저장(&S)"
//p_mod.picturename = "C:\erpman\image\저장_up.gif"

dw_1.setcolumn('house')
dw_1.setfocus()


end event

type rb_1 from radiobutton within w_pdt_04020
integer x = 4201
integer y = 208
integer width = 347
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "입고승인"
boolean checked = true
end type

event clicked;
ic_status = '1'

dw_1.Modify("edate.Visible= 1") 
dw_1.Modify("edate_t.Visible= 1") 
dw_1.Modify("idate_t.text = '의뢰일자'")
dw_1.setItem(1, "idate", left(is_today, 6) + '01')
dw_1.setItem(1, "tdate", is_today)

dw_list.DataObject = 'd_pdt_04020'
dw_list.SetTransObject(sqlca)
pb_1.visible = True
//dw_list.object.itemas_ispec_t.text = is_ispec
//dw_list.object.jijil_t.text = is_jijil

//cb_save.Text = "승인저장(&S)"
//p_mod.picturename = "C:\erpman\image\저장_up.gif"

dw_1.setcolumn('house')
dw_1.setfocus()

end event

type cb_cancel from commandbutton within w_pdt_04020
boolean visible = false
integer x = 2135
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;string	sToday
sToday = f_Today()

dw_1.SetRedraw(false)

dw_1.Reset()
dw_list.Reset()

dw_1.InsertRow(0)
dw_1.SetItem(1, "edate", sToday)

dw_1.SetRedraw(true)

////////////////////////////////////////////////////////
cb_save.enabled = False
rb_1.checked = true
rb_1.TriggerEvent("clicked")
end event

type cb_retrieve from commandbutton within w_pdt_04020
boolean visible = false
integer x = 242
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;string	sHouse, sGubun, sDate, sTitle, siogbn, pdtgu, sidate, stdate, sempno

if dw_1.accepttext() = -1 then return 

sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
siDate  = trim(dw_1.GetItemString(1, "idate"))
stDate  = trim(dw_1.GetItemString(1, "tdate"))
siogbn = dw_1.GetItemString(1, "iogbn")
pdtgu = Trim(dw_1.GetItemString(1, "pdtgu"))
sempno = Trim(dw_1.GetItemString(1, "empno"))

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
	dw_1.SetColumn("house")
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

dw_list.SetRedraw(False)
dw_list.SetFilter("")
if not(IsNull(pdtgu) or pdtgu = "") then
	dw_list.SetFilter("pdtgu = '" + pdtgu + "'")
end if
dw_list.Filter( )

IF rb_1.checked  = true		THEN
	sGubun = 'N'
	sTitle = '[입고미승인현황]'
	lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siogbn, sidate, stdate)
ELSE
	sGubun = 'Y'
	sTitle = '[입고승인현황]'
	lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siDate, stdate, siogbn, sempno)
END IF
dw_list.SetRedraw(True)

IF lRowCount < 1	THEN
	f_message_chk(50, sTitle)
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

cb_save.enabled = true


end event

type cb_exit from commandbutton within w_pdt_04020
boolean visible = false
integer x = 2766
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
boolean cancel = true
end type

event clicked;
close(parent)


end event

type cb_save from commandbutton within w_pdt_04020
boolean visible = false
integer x = 873
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "승인저장(&S)"
end type

event clicked;
if dw_1.AcceptText() = -1 then return
if dw_list.AcceptText() = -1 then return

IF dw_list.RowCount() < 1	THEN	RETURN

////////////////////////////////////////////////////////
string	sDate, sEmpno, sHouse, sCheck, sNull, sSalegu
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


IF rb_1.checked = true	THEN
	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[입고승인자]')
		dw_1.SetColumn("empno")
		dw_1.SetFocus()
		RETURN
	END IF
END IF


SetNull(sNull)
////////////////////////////////////////////////////////

IF f_msg_update() = -1 	THEN	RETURN

SetPointer(HourGlass!)

FOR  lRow = 1	TO		dw_list.RowCount()

	dQty   = dw_list.GetItemDecimal(lRow, "iosuqty")
	dPrice = dw_list.GetItemDecimal(lRow, "ioprc")
	sCheck = dw_list.GetItemString(lRow, "io_check")

	if rb_1.checked then
		IF sCheck = 'Y'	THEN		// 승인
			dw_list.SetItem(lRow, "ioamt", 	 TRUNCATE(dQty * dPrice, 0))
			dw_list.SetItem(lRow, "ioqty", 	 dQty)
			dw_list.SetItem(lRow, "io_date",  sDate)
			dw_list.SetItem(lRow, "io_empno", sEmpno)

			//수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 
			//검수일자에 승인일자를 move
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sDate)
	      END IF 		
		End if
	else
		IF sCheck = 'Y'	THEN		// 승인취소
			dw_list.SetItem(lRow, "ioamt", 	 0)
			dw_list.SetItem(lRow, "ioqty", 	 0)
			dw_list.SetItem(lRow, "io_date",  sNull)
			dw_list.SetItem(lRow, "io_empno", sNull)

			//반대로 수불이 매출인 자료[iomatrix에 매출구분(salegu)이 = 'Y')]는 검수일자 clear
			sSalegu = dw_list.GetItemString(lRow, "salegu")
			IF sSalegu = 'Y' Then 
				dw_list.SetItem(lRow, "yebi1",  sNull)
	      END IF 		
		End if
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
cb_save.enabled = False

SetPointer(Arrow!)

end event

type rr_1 from roundrectangle within w_pdt_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4183
integer y = 180
integer width = 389
integer height = 216
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pdt_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 180
integer width = 4128
integer height = 216
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_pdt_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 416
integer width = 4544
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 46
end type

