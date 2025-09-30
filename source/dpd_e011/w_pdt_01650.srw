$PBExportHeader$w_pdt_01650.srw
$PBExportComments$**작업장별 근무일력 등록
forward
global type w_pdt_01650 from window
end type
type p_1 from uo_picture within w_pdt_01650
end type
type p_exit from uo_picture within w_pdt_01650
end type
type p_can from uo_picture within w_pdt_01650
end type
type p_mod from uo_picture within w_pdt_01650
end type
type dw_list from datawindow within w_pdt_01650
end type
type dw_detail from datawindow within w_pdt_01650
end type
type rr_1 from roundrectangle within w_pdt_01650
end type
type rr_2 from roundrectangle within w_pdt_01650
end type
end forward

global type w_pdt_01650 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "작업장별 근무일력 등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 32106727
p_1 p_1
p_exit p_exit
p_can p_can
p_mod p_mod
dw_list dw_list
dw_detail dw_detail
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_01650 w_pdt_01650

type variables
Boolean ib_any_typing     

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

string  colname1[4] = {'janup', 'yayup','chlya','tukgn'}
string  colname2[4] = {'rate1', 'rate2','rate3','rate4'}
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
//여기까지 이력관리

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)

/*====================================================
	 WINDOW  datawindow(dw_1) 에 현재일자 retrieve
=====================================================*/
string 	retrieve_format 

retrieve_format = String( today(), "yyyymmdd" )

dw_detail.retrieve( retrieve_format )
dw_list.retrieve( retrieve_format, gs_sabu )
dw_detail.setfocus()

end event

on w_pdt_01650.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.p_1=create p_1
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_1,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.dw_list,&
this.dw_detail,&
this.rr_1,&
this.rr_2}
end on

on w_pdt_01650.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.dw_list)
destroy(this.dw_detail)
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

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type p_1 from uo_picture within w_pdt_01650
integer x = 3749
integer y = 20
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\보유공수재계산_up.gif"
end type

event clicked;call super::clicked;string srtn

w_mdi_frame.sle_msg.text = '작업장별 보유공수 재계산중.........!'

sqlca.erp000000320_1(srtn);

if srtn = 'Y' then
	Messagebox("보유공수", "작업장별 보유공수 내역 계산중 오류발생", stopsign!)
else
	Messagebox("보유공수", "작업장별 보유공수 내역 계산완료", information!)	
End if

w_mdi_frame.sle_msg.text = ''

string sdate

dw_detail.accepttext()

sdate = dw_detail.getitemstring(1, "cldate")

dw_list.setredraw(false)
dw_list.retrieve(sdate, gs_sabu)
dw_list.setredraw(true)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\보유공수재계산_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\보유공수재계산_dn.gif"
end event

type p_exit from uo_picture within w_pdt_01650
integer x = 4398
integer y = 20
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

type p_can from uo_picture within w_pdt_01650
integer x = 4224
integer y = 20
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetPointer(HourGlass!)

dw_detail.setredraw(false)
dw_list.setredraw(false)

dw_detail.Reset()
dw_list.Reset()


/*====================================================
	 WINDOW  datawindow(dw_1) 에 현재일자 retrieve
=====================================================*/
string 	retrieve_format 

retrieve_format = String( today(), "yyyymmdd" )

dw_detail.retrieve( retrieve_format )

dw_list.retrieve( retrieve_format, gs_sabu )

dw_detail.setredraw(true)
dw_list.setredraw(true)

SetPointer(HourGlass!)

dw_detail.setredraw(false)
dw_list.setredraw(false)

dw_detail.Reset()
dw_list.Reset()

w_mdi_frame.sle_msg.text = ''
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

type p_mod from uo_picture within w_pdt_01650
integer x = 4050
integer y = 20
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''	

IF	dw_list.AcceptText() = -1	then
	RETURN
END IF

IF dw_list.rowcount() <= 0 Then Return 


If f_msg_update() = -1 Then Return

IF dw_list.Update() > 0 THEN	 
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	COMMIT USING sqlca;
	commit ;
ELSE
	ROLLBACK USING sqlca;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type dw_list from datawindow within w_pdt_01650
event ue_pressenter pbm_dwnprocessenter
integer x = 320
integer y = 192
integer width = 3995
integer height = 1492
integer taborder = 10
string dataobject = "d_pdt_01650_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
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

event editchanged;ib_any_typing =True
end event

event itemchanged;string scolname, syn
decimal {2} drate, prate
long lrow

scolname = dwo.name
lrow = getrow()

if scolname = 'janup' then
	IF gettext() = 'Y' THEN 
		this.setitem(lrow, colname2[1], 100)
		this.setitem(lrow, colname1[2], 'N')
		this.setitem(lrow, colname1[3], 'N')
		this.setitem(lrow, colname1[4], 'N')		
		this.setitem(lrow, colname2[2], 0)
		this.setitem(lrow, colname2[3], 0)
		this.setitem(lrow, colname2[4], 0)		
	Else
		this.setitem(lrow, colname2[1], 0)		
	END IF
	return 
End if

if scolname = 'yayup' then
	IF gettext() = 'Y' THEN 
		this.setitem(lrow, colname2[2], 100)
		this.setitem(lrow, colname1[1], 'N')
		this.setitem(lrow, colname1[3], 'N')
		this.setitem(lrow, colname1[4], 'N')		
		this.setitem(lrow, colname2[1], 0)
		this.setitem(lrow, colname2[3], 0)
		this.setitem(lrow, colname2[4], 0)		
	Else
		this.setitem(lrow, colname2[2], 0)				
	END IF
	return 	
End if

if scolname = 'chlya' then
	IF gettext() = 'Y' THEN 
		this.setitem(lrow, colname2[3], 100)
		this.setitem(lrow, colname1[1], 'N')
		this.setitem(lrow, colname1[2], 'N')
		this.setitem(lrow, colname1[4], 'N')		
		this.setitem(lrow, colname2[1], 0)
		this.setitem(lrow, colname2[2], 0)
		this.setitem(lrow, colname2[4], 0)		
	Else
		this.setitem(lrow, colname2[3], 0)				
	END IF
	return 	
End if

if scolname = 'tukgn' then
	IF gettext() = 'Y' THEN 
		this.setitem(lrow, colname2[4], 100)
		this.setitem(lrow, colname1[1], 'N')
		this.setitem(lrow, colname1[2], 'N')
		this.setitem(lrow, colname1[3], 'N')		
		this.setitem(lrow, colname2[1], 0)
		this.setitem(lrow, colname2[2], 0)
		this.setitem(lrow, colname2[3], 0)		
	Else
		this.setitem(lrow, colname2[4], 0)
	END IF
	return 	
End if

prate = getitemdecimal(lrow, scolname)
drate = dec(gettext())

if drate = 0 then
	Messagebox("적용율", "적용율은 0이하 이어야 합니다", stopsign!)
	setitem(lrow, scolname, prate)
	return 1
end if
end event

event itemerror;return 1
end event

type dw_detail from datawindow within w_pdt_01650
event ue_pressenter pbm_dwnprocessenter
integer x = 635
integer y = 1768
integer width = 3369
integer height = 436
string dataobject = "d_pdt_01650_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;//Send( Handle(this), 256, 9, 0 )
//Return 1
end event

event editchanged;//ib_any_typing =True
end event

event itemchanged;string sdate, pdate

pdate = getitemstring(1, "cldate")
sdate = gettext()

this.setredraw(false)
if this.retrieve(sdate) < 1 then
	Messagebox("일자", "근무일력에 존재하지 않는 일자입니다", stopsign!)
	this.retrieve(pdate)
Else
	dw_list.retrieve(sdate, gs_sabu)
end if

this.setredraw(true)

end event

event itemerror;RETURN 1
end event

type rr_1 from roundrectangle within w_pdt_01650
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 315
integer y = 184
integer width = 4023
integer height = 1512
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_01650
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 315
integer y = 1704
integer width = 4023
integer height = 576
integer cornerheight = 40
integer cornerwidth = 55
end type

