$PBExportHeader$w_imt_03070.srw
$PBExportComments$무역 금융한도 등록
forward
global type w_imt_03070 from window
end type
type pb_d_imt_03070_1 from u_pb_cal within w_imt_03070
end type
type pb_d_imt_03070_2 from u_pb_cal within w_imt_03070
end type
type p_exit from uo_picture within w_imt_03070
end type
type p_cancel from uo_picture within w_imt_03070
end type
type p_delete from uo_picture within w_imt_03070
end type
type p_save from uo_picture within w_imt_03070
end type
type p_inq from uo_picture within w_imt_03070
end type
type dw_inq from datawindow within w_imt_03070
end type
type rb_1 from radiobutton within w_imt_03070
end type
type rb_2 from radiobutton within w_imt_03070
end type
type gb_2 from groupbox within w_imt_03070
end type
type dw_list from datawindow within w_imt_03070
end type
type rr_1 from roundrectangle within w_imt_03070
end type
end forward

global type w_imt_03070 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "무역 금융한도 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 32106727
pb_d_imt_03070_1 pb_d_imt_03070_1
pb_d_imt_03070_2 pb_d_imt_03070_2
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_inq p_inq
dw_inq dw_inq
rb_1 rb_1
rb_2 rb_2
gb_2 gb_2
dw_list dw_list
rr_1 rr_1
end type
global w_imt_03070 w_imt_03070

type variables
// 자료변경여부 검사
Boolean ib_any_typing 

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
end variables

forward prototypes
public function integer wf_checkrequiredfield ()
public function integer wf_warndataloss (string as_titletext)
end prototypes

public function integer wf_checkrequiredfield ();string	sCode, syymm

if rb_1.checked then
	
	sCode = dw_list.GetItemString(1, "bankcd")
	IF IsNull(sCode) 	or   sCode = ''	THEN
		f_message_chk(30,'[은행코드]')		
		dw_list.SetColumn("bankcd")
		dw_list.SetFocus()
		RETURN -1
	END IF
else 
	sCode = dw_list.GetItemString(1, "bankcd")
	IF IsNull(sCode) 	or   sCode = ''	THEN
		f_message_chk(30,'[은행코드]')		
		dw_list.SetColumn("bankcd")
		dw_list.SetFocus()
		RETURN -1
	END IF
	
	syymm = dw_list.GetItemString(1, "yymm")	
	IF IsNull(syymm) 	or   syymm = ''	THEN
		f_message_chk(30,'[년월]')		
		dw_list.SetColumn("yymm")
		dw_list.SetFocus()
		RETURN -1
	END IF
end if

RETURN 1

end function

public function integer wf_warndataloss (string as_titletext);/*===================================================================
 1. window-level user function : 종료, 등록, 조회시 호출됨
    dw_detail, dw_list 의 typing(datawindow) 변경사항 검사

 2. 계속진행할 경우 변경사항이 저장되지 안음을 경고                                                               

 3. Argument:  as_titletext (warning messagebox)                                                                          
    Return values:                                                   
                                                                  
      *  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
		* -1 : 진행을 중단할 경우.                      
=====================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		dw_list.SetFocus()						// yes 일 경우: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1																// (dw_detail) 에 변경사항이 없거나 no일 경우
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
//////////////////////////////////////////////////////////////////////////////////

dw_list.settransobject(sqlca)
dw_inq.settransobject(sqlca)

p_cancel.TriggerEvent("clicked")

end event

on w_imt_03070.create
this.pb_d_imt_03070_1=create pb_d_imt_03070_1
this.pb_d_imt_03070_2=create pb_d_imt_03070_2
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_inq=create p_inq
this.dw_inq=create dw_inq
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_2=create gb_2
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.pb_d_imt_03070_1,&
this.pb_d_imt_03070_2,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_inq,&
this.dw_inq,&
this.rb_1,&
this.rb_2,&
this.gb_2,&
this.dw_list,&
this.rr_1}
end on

on w_imt_03070.destroy
destroy(this.pb_d_imt_03070_1)
destroy(this.pb_d_imt_03070_2)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_inq)
destroy(this.dw_inq)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_2)
destroy(this.dw_list)
destroy(this.rr_1)
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

type pb_d_imt_03070_1 from u_pb_cal within w_imt_03070
integer x = 987
integer y = 640
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_list.SetColumn('cnfdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_list.GetRow()
If ll_row < 1 Then Return
dw_list.SetItem(ll_row, 'cnfdat', gs_code)



end event

type pb_d_imt_03070_2 from u_pb_cal within w_imt_03070
boolean visible = false
integer x = 1134
integer y = 512
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_list.SetColumn('pobank_dtl_cnfdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_list.GetRow()
If ll_row < 1 Then Return
dw_list.SetItem(ll_row, 'pobank_dtl_cnfdat', gs_code)



end event

type p_exit from uo_picture within w_imt_03070
integer x = 4402
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;
/*===============================================================                                                                  
  1. DATAWINDOW  dw_detail 에 TYPING 을 했는지 검사 
     저장을 안하고 계속 진행할 경우 DATA lost 임을 경고 
                                                                  
  2. WINDOW LEVEL FUNTION(named wf_warndataloss)
     를 사용한다   
================================================================*/

IF wf_warndataloss("종료") = -1 THEN  

	RETURN

END IF

close(parent)
end event

type p_cancel from uo_picture within w_imt_03070
integer x = 4229
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;string sbankcd

w_mdi_frame.sle_msg.text =""

ib_any_typing     = FALSE

p_inq.enabled    = true
p_delete.enabled = false

if rb_1.checked then
	dw_list.object.bankcd.protect = 0
	
	dw_list.setredraw(false)
	dw_inq.setredraw(false)
	dw_list.reset()
	dw_list.insertrow(0)
	dw_list.setitem(1, "sabu", gs_sabu)
	dw_inq.retrieve(gs_sabu)
	dw_inq.setredraw(true)
	dw_list.setredraw(true)
	dw_list.setfocus()
else
	if dw_list.rowcount() > 0 then
		sbankcd = dw_list.getitemstring(1, "bankcd")
	end if
	
	dw_list.object.bankcd.protect = 0
	dw_list.object.yymm.protect = 0
	
	dw_list.setredraw(false)
	dw_inq.setredraw(false)
	dw_list.reset()
	dw_list.insertrow(0)
	dw_list.setitem(1, "sabu", gs_sabu)
	dw_inq.retrieve(gs_sabu, sbankcd)
	dw_inq.setredraw(true)
	dw_list.setredraw(true)
	dw_list.setfocus()	
end if


end event

type p_delete from uo_picture within w_imt_03070
integer x = 4055
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;string sbankcd, syymm
long   lRow

if rb_1.checked then
	if dw_list.getitemdecimal(1, "blwonamt") > 0 or &
		dw_list.getitemdecimal(1, "blusdamt") > 0 or & 
		dw_list.getitemdecimal(1, "saamtusd") > 0 or &
		dw_list.getitemdecimal(1, "saamtwon") > 0 or & 
		dw_list.getitemdecimal(1, "usansamt") > 0 or &
		dw_list.getitemdecimal(1, "usanswon") > 0 or &
		dw_list.getitemdecimal(1, "dapsamt") > 0 then
		Messagebox("삭제오류", "사용금액이 있으므로 삭제할 수 없읍니다", stopsign!)
		return
	end if
	
	lrow = 0
	sbankcd = dw_list.getitemstring(1, "bankcd")
	select count(*) into :lrow
	  From pobank_dtl
	 Where sabu = :gs_sabu and bankcd = :sbankcd;
	 
	if lrow > 0 then
		Messagebox("삭제오류", "월별 한도 금액이 있으므로 삭제할 수 없읍니다", stopsign!)
		return
	end if 
	
	IF f_msg_delete() = -1 THEN	RETURN
		
	Delete from pobank where sabu = :gs_sabu and bankcd = :sbankcd;
	if sqlca.sqlcode = 0 then
		COMMIT;
	else
		rollback;
		f_Rollback()
	end if
	
else

	IF f_msg_delete() = -1 THEN	RETURN
	
	sbankcd = dw_list.getitemstring(1, "bankcd")	
	syymm   = dw_list.getitemstring(1, "yymm")		
		
	Delete from pobank_dtl where sabu = :gs_sabu and yymm = :syymm and bankcd = :sbankcd;
	if sqlca.sqlcode = 0 then
		COMMIT;
	else
		f_Rollback()
		rollback;
	end if
		
end if

p_cancel.TriggerEvent("clicked")	


end event

type p_save from uo_picture within w_imt_03070
integer x = 3881
integer y = 24
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;if dw_list.accepttext() = -1 then return 

IF	wf_CheckRequiredField() = -1 	THEN	RETURN

if rb_1.checked then
	if isnull(dw_list.getitemstring(1, "cnfdat")) or &
		trim(dw_list.getitemstring(1, "cnfdat")) = '' then
		dw_list.setitem(1, "cnfdat", f_today())
	end if
end if

IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF		

p_cancel.TriggerEvent("clicked")	

end event

type p_inq from uo_picture within w_imt_03070
integer x = 3707
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;string sbankcd, syymm

if dw_list.accepttext() = -1 then return

if rb_1.checked then

	sbankcd = trim(dw_list.getitemstring(1, "bankcd"))
	
	IF isnull(sbankcd) or sbankcd = "" 	THEN
		f_message_chk(30,'[은행]')
		dw_list.SetColumn("bankcd")
		dw_list.SetFocus()
		RETURN
	END IF
	dw_list.setredraw(false)
	
	if dw_list.retrieve(gs_sabu, sbankcd) <> 1 then
		f_message_chk(50, '[무역금융한도(현재)]')
		p_cancel.triggerevent(clicked!)
	else
		p_inq.enabled    = false
		p_delete.enabled = true
		dw_list.object.bankcd.protect = 1
	end if
	
	dw_list.setredraw(true)
	dw_list.setfocus()
else
	
	sbankcd = trim(dw_list.getitemstring(1, "bankcd"))
	syymm   = trim(dw_list.getitemstring(1, "yymm"))	
	
	IF isnull(sbankcd) or sbankcd = "" 	THEN
		f_message_chk(30,'[은행]')
		dw_list.SetColumn("bankcd")
		dw_list.SetFocus()
		RETURN
	END IF
	IF isnull(syymm) or syymm = "" 	THEN
		f_message_chk(30,'[기준년월]')
		dw_list.SetColumn("yymm")
		dw_list.SetFocus()
		RETURN
	END IF
	
	dw_list.setredraw(false)
	
	if dw_list.retrieve(gs_sabu, syymm, sbankcd) <> 1 then
		f_message_chk(50, '[무역금융한도(월별)]')
		p_cancel.triggerevent(clicked!)
	else
		p_inq.enabled    = false
		p_delete.enabled = true
		
		dw_list.object.bankcd.protect = 1
		dw_list.object.yymm.protect = 1
	end if
	
	dw_list.setredraw(true)
	dw_list.setfocus()	
end if

end event

type dw_inq from datawindow within w_imt_03070
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 87
integer y = 1064
integer width = 4485
integer height = 1240
string dataobject = "d_imt_03070"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <= 0	then		RETURN									

dw_list.setitem(1, "bankcd", this.getitemstring(row, "bankcd"))
if rb_2.checked then
	dw_list.setitem(1, "yymm",   this.getitemstring(row, "yymm"))	
end if
p_inq.triggerevent(clicked!)

this.selectrow(0, false)
this.selectrow(Row, true)

end event

type rb_1 from radiobutton within w_imt_03070
integer x = 3817
integer y = 232
integer width = 293
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "현 재"
boolean checked = true
end type

event clicked;dw_list.DataObject = 'd_imt_03070_1'
dw_list.SetTransObject(SQLCA)
pb_d_imt_03070_1.Visible = True
pb_d_imt_03070_2.Visible = False

dw_inq.DataObject = 'd_imt_03070'
dw_inq.SetTransObject(SQLCA)

p_cancel.triggerevent(clicked!)

end event

type rb_2 from radiobutton within w_imt_03070
integer x = 4192
integer y = 232
integer width = 293
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "월 별"
end type

event clicked;dw_list.DataObject = 'd_imt_03070_2'
dw_list.SetTransObject(SQLCA)
pb_d_imt_03070_1.Visible = False
pb_d_imt_03070_2.Visible = True


dw_inq.DataObject = 'd_imt_03070_3'
dw_inq.SetTransObject(SQLCA)

p_cancel.triggerevent(clicked!)
end event

type gb_2 from groupbox within w_imt_03070
integer x = 3730
integer y = 184
integer width = 850
integer height = 156
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type dw_list from datawindow within w_imt_03070
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 64
integer y = 28
integer width = 3474
integer height = 1028
integer taborder = 10
string dataobject = "d_imt_03070_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

on editchanged; ib_any_typing = true
end on

event itemchanged;long		lReturnRow
String 	sBank, sName, snull, syymm

SetNull(snull)

IF this.GetColumnName() = "bankcd" and rb_1.checked THEN
	
	sBank = trim(THIS.GETTEXT())								
	
	if sbank = '' or isnull(sbank) then 
 		this.SetItem(1, "vndmst_cvnas2", sNull)
		RETURN 
	END IF
	
	SELECT CVNAS2
	  INTO :sName
	  FROM VNDMST
	 WHERE CVCOD    = :sBank 
	   AND CVGU     = '3' 	
		AND CVSTATUS = '0';
	 
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[은행코드]')		
		this.SetItem(1, "bankcd", sNull)
 		this.SetItem(1, "vndmst_cvnas2", sNull)
		RETURN 1
	END IF
	
	this.SetItem(1, "vndmst_cvnas2", sName)	
	
	// 은행코드 중복확인
	lReturnRow = 0
	
	select count(*) into :lreturnrow
	  From pobank
	 Where sabu = :gs_sabu
	 	And bankcd = :sbank;
	
	IF (lReturnRow <> 0)		THEN
		p_inq.triggerevent(clicked!)
	END IF

ELSEIF this.GetColumnName() = "bankcd" and rb_2.checked  THEN
	
	sBank = trim(THIS.GETTEXT())								
	syymm = trim(getitemstring(1, "yymm"))
	
	if sbank = '' or isnull(sbank) then 
 		this.SetItem(1, "vndmst_cvnas2", sNull)
		RETURN 
	END IF
	
	SELECT CVNAS2
	  INTO :sName
	  FROM VNDMST
	 WHERE CVCOD    = :sBank 
	   AND CVGU     = '3' 	
		AND CVSTATUS = '0';
	 
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[은행코드]')		
		this.SetItem(1, "bankcd", sNull)
 		this.SetItem(1, "vndmst_cvnas2", sNull)
		RETURN 1
	END IF
	
	this.SetItem(1, "vndmst_cvnas2", sName)	
	
	dw_inq.retrieve(gs_sabu, sbank)
	
	// 은행코드 중복확인
	lReturnRow = 0
	
	select count(*) into :lreturnrow
	  From pobank_dtl
	 Where sabu = :gs_sabu
	 	And bankcd = :sbank
		And yymm	  = :syymm;
	
	IF (lReturnRow <> 0)		THEN
		p_inq.triggerevent(clicked!)
	END IF

elseif this.getcolumnname() = 'yymm' then
	syymm = trim(this.gettext())
	sbank = trim(this.getitemstring(1, "bankcd"))	
	
	if f_datechk(syymm+'01') = -1 then
      f_message_chk(35, '[한도년월]')
		this.setitem(1, "yymm", sNull)
		return 1		
	end if
	
	// 은행코드 중복확인
	lReturnRow = 0
	
	select count(*) into :lreturnrow
	  From pobank_dtl
	 Where sabu   = :gs_sabu
	 	And bankcd = :sbank
		And yymm	  = :syymm;
	
	IF (lReturnRow <> 0)		THEN
		p_inq.triggerevent(clicked!)
	END IF	

elseif this.getcolumnname() = 'cnfdat' then
	syymm = trim(this.gettext())

	if syymm = '' or isnull(syymm) then return 
	
	if f_datechk(syymm) = -1 then
      f_message_chk(35, '[최종설정일]')
		this.setitem(1, "cnfdat", sNull)
		return 1		
	end if
END IF



end event

event itemerror;
RETURN 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = 'bankcd'	THEN

	gs_Gubun = '3'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"bankcd",		gs_code)
	SetItem(1,"vndmst_cvnas2",gs_codename)
	
	this.TriggerEvent("itemchanged")
	
END IF

end event

type rr_1 from roundrectangle within w_imt_03070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 1056
integer width = 4512
integer height = 1252
integer cornerheight = 40
integer cornerwidth = 55
end type

