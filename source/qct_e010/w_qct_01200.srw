$PBExportHeader$w_qct_01200.srw
$PBExportComments$시료수량 기준관리
forward
global type w_qct_01200 from window
end type
type p_exit from uo_picture within w_qct_01200
end type
type p_save from uo_picture within w_qct_01200
end type
type p_retrieve from uo_picture within w_qct_01200
end type
type p_delrow from uo_picture within w_qct_01200
end type
type p_addrow from uo_picture within w_qct_01200
end type
type dw_1 from datawindow within w_qct_01200
end type
type dw_list from datawindow within w_qct_01200
end type
type rr_1 from roundrectangle within w_qct_01200
end type
end forward

global type w_qct_01200 from window
integer width = 4640
integer height = 2440
boolean titlebar = true
string title = "시료수량 기준관리"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
windowstate windowstate = maximized!
long backcolor = 32106727
p_exit p_exit
p_save p_save
p_retrieve p_retrieve
p_delrow p_delrow
p_addrow p_addrow
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
end type
global w_qct_01200 w_qct_01200

type variables
char c_status

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

public function integer wf_checkrequiredfield ();
string	sGubun, sCode
long		lRow

sGubun = dw_1.GetItemString(1, 1)


FOR  lRow = 1	TO		dw_list.RowCount()

	dw_list.SetItem(lRow, "qcseq", 	 dw_list.GetItemNumber(lRow, "no"))
	dw_list.SetItem(lRow, "qcchk", sGubun)

	sCode = dw_list.GetitemString(lRow, "qcgub")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[검사구분]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("qcgub")
		dw_list.setfocus()
		RETURN -1
	END IF

NEXT


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


//////////////////////////////////////////////////////////////////////////////////

dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_1.InsertRow(0)

dw_1.SetFocus()

p_retrieve.TriggerEvent("clicked")






end event

event close;//w_frame.show()
end event

on w_qct_01200.create
this.p_exit=create p_exit
this.p_save=create p_save
this.p_retrieve=create p_retrieve
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_save,&
this.p_retrieve,&
this.p_delrow,&
this.p_addrow,&
this.dw_1,&
this.dw_list,&
this.rr_1}
end on

on w_qct_01200.destroy
destroy(this.p_exit)
destroy(this.p_save)
destroy(this.p_retrieve)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
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
		p_retrieve.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_save.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type p_exit from uo_picture within w_qct_01200
integer x = 4434
integer y = 16
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\close.cur"
boolean originalsize = true
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

type p_save from uo_picture within w_qct_01200
integer x = 4261
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\update.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;
IF	wf_CheckRequiredField() = -1		THEN		RETURN

IF f_msg_update() = -1 	THEN	RETURN


////////////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;

ELSE
	f_Rollback()
	ROLLBACK;
END IF


ib_any_typing = false
end event

type p_retrieve from uo_picture within w_qct_01200
integer x = 4087
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;
dw_1.AcceptText()

string	sGubun
sGubun = dw_1.GetItemString(1,1)

dw_list.Retrieve(gs_sabu, sGubun) 

//cb_insert.enabled = true
//cb_delete.enabled = true

end event

type p_delrow from uo_picture within w_qct_01200
integer x = 3904
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\delrow.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

event clicked;call super::clicked;long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN
	
dw_list.DeleteRow(0)



end event

type p_addrow from uo_picture within w_qct_01200
integer x = 3730
integer y = 12
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\addrow.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

event clicked;call super::clicked;
//IF f_CheckRequired(dw_list) = -1	THEN	RETURN


//////////////////////////////////////////////////////////////////////////
long	lRow
lRow = dw_list.InsertRow(0)


dw_list.ScrollToRow(lRow)
dw_list.SetColumn("lots")
dw_list.SetFocus()


end event

type dw_1 from datawindow within w_qct_01200
integer x = 14
integer y = 28
integer width = 1248
integer height = 132
integer taborder = 10
string dataobject = "d_qct_01201"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string	sGubun 
sGubun = this.GetText()

dw_list.Retrieve(gs_sabu, sGubun)

end event

event itemerror;RETURN 1
end event

type dw_list from datawindow within w_qct_01200
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 59
integer y = 184
integer width = 4535
integer height = 2184
integer taborder = 30
string dataobject = "d_qct_01200"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;
RETURN 1
end event

on editchanged; ib_any_typing = true
end on

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )
if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

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

type rr_1 from roundrectangle within w_qct_01200
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 172
integer width = 4562
integer height = 2204
integer cornerheight = 40
integer cornerwidth = 55
end type

