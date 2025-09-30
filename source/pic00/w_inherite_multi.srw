$PBExportHeader$w_inherite_multi.srw
$PBExportComments$** 다중 access inherite Window
forward
global type w_inherite_multi from window
end type
type p_delrow from uo_picture within w_inherite_multi
end type
type p_addrow from uo_picture within w_inherite_multi
end type
type p_search from uo_picture within w_inherite_multi
end type
type p_ins from uo_picture within w_inherite_multi
end type
type p_exit from uo_picture within w_inherite_multi
end type
type p_can from uo_picture within w_inherite_multi
end type
type p_print from uo_picture within w_inherite_multi
end type
type p_inq from uo_picture within w_inherite_multi
end type
type p_del from uo_picture within w_inherite_multi
end type
type p_mod from uo_picture within w_inherite_multi
end type
type dw_insert from u_key_enter within w_inherite_multi
end type
type st_window from singlelineedit within w_inherite_multi
end type
type cb_append from commandbutton within w_inherite_multi
end type
type cb_exit from commandbutton within w_inherite_multi
end type
type cb_update from commandbutton within w_inherite_multi
end type
type cb_insert from commandbutton within w_inherite_multi
end type
type cb_delete from commandbutton within w_inherite_multi
end type
type cb_retrieve from commandbutton within w_inherite_multi
end type
type st_1 from statictext within w_inherite_multi
end type
type cb_cancel from commandbutton within w_inherite_multi
end type
type dw_datetime from datawindow within w_inherite_multi
end type
type sle_msg from singlelineedit within w_inherite_multi
end type
type gb_2 from groupbox within w_inherite_multi
end type
type gb_1 from groupbox within w_inherite_multi
end type
type gb_10 from groupbox within w_inherite_multi
end type
end forward

global type w_inherite_multi from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
event ue_append pbm_custom01
event ue_keydonw pbm_keydown
p_delrow p_delrow
p_addrow p_addrow
p_search p_search
p_ins p_ins
p_exit p_exit
p_can p_can
p_print p_print
p_inq p_inq
p_del p_del
p_mod p_mod
dw_insert dw_insert
st_window st_window
cb_append cb_append
cb_exit cb_exit
cb_update cb_update
cb_insert cb_insert
cb_delete cb_delete
cb_retrieve cb_retrieve
st_1 st_1
cb_cancel cb_cancel
dw_datetime dw_datetime
sle_msg sle_msg
gb_2 gb_2
gb_1 gb_1
gb_10 gb_10
end type
global w_inherite_multi w_inherite_multi

type variables
Boolean ib_any_typing 
String print_gu                 //window가 조회인지 인쇄인지  

String     is_today            //시작일자
String     is_totime           //시작시간
String     is_window_id    //윈도우 ID
String     is_usegub         //이력관리 여부
String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false

String     is_saupcd           //인사사업장




String     sModStatus

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


dw_datetime.InsertRow(0)

w_mdi_frame.sle_msg.text =""

ib_any_typing=False




end event

on w_inherite_multi.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.p_search=create p_search
this.p_ins=create p_ins
this.p_exit=create p_exit
this.p_can=create p_can
this.p_print=create p_print
this.p_inq=create p_inq
this.p_del=create p_del
this.p_mod=create p_mod
this.dw_insert=create dw_insert
this.st_window=create st_window
this.cb_append=create cb_append
this.cb_exit=create cb_exit
this.cb_update=create cb_update
this.cb_insert=create cb_insert
this.cb_delete=create cb_delete
this.cb_retrieve=create cb_retrieve
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.dw_datetime=create dw_datetime
this.sle_msg=create sle_msg
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_10=create gb_10
this.Control[]={this.p_delrow,&
this.p_addrow,&
this.p_search,&
this.p_ins,&
this.p_exit,&
this.p_can,&
this.p_print,&
this.p_inq,&
this.p_del,&
this.p_mod,&
this.dw_insert,&
this.st_window,&
this.cb_append,&
this.cb_exit,&
this.cb_update,&
this.cb_insert,&
this.cb_delete,&
this.cb_retrieve,&
this.st_1,&
this.cb_cancel,&
this.dw_datetime,&
this.sle_msg,&
this.gb_2,&
this.gb_1,&
this.gb_10}
end on

on w_inherite_multi.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.p_search)
destroy(this.p_ins)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_print)
destroy(this.p_inq)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.dw_insert)
destroy(this.st_window)
destroy(this.cb_append)
destroy(this.cb_exit)
destroy(this.cb_update)
destroy(this.cb_insert)
destroy(this.cb_delete)
destroy(this.cb_retrieve)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.dw_datetime)
destroy(this.sle_msg)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_10)
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

event key;Choose Case key
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyT!
		p_ins.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type p_delrow from uo_picture within w_inherite_multi
integer x = 3698
integer y = 24
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_addrow from uo_picture within w_inherite_multi
integer x = 3525
integer y = 24
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_search from uo_picture within w_inherite_multi
integer x = 2830
integer y = 24
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\button_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\button_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\button_up.gif"
end event

type p_ins from uo_picture within w_inherite_multi
integer x = 3351
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type p_exit from uo_picture within w_inherite_multi
integer x = 4393
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_inherite_multi
integer x = 4219
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_print from uo_picture within w_inherite_multi
integer x = 3003
integer y = 24
integer width = 178
integer taborder = 100
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type p_inq from uo_picture within w_inherite_multi
integer x = 3177
integer y = 24
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_del from uo_picture within w_inherite_multi
integer x = 4046
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_inherite_multi
integer x = 3872
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type dw_insert from u_key_enter within w_inherite_multi
event ue_key pbm_dwnkey
integer x = 91
integer y = 2024
integer width = 256
integer height = 208
integer taborder = 10
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dberror;call super::dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)

RETURN 1
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

type st_window from singlelineedit within w_inherite_multi
integer x = 2190
integer y = 2836
integer width = 649
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type cb_append from commandbutton within w_inherite_multi
string tag = "Bubblehelp=버튼을 누르시면 행이 추가됩니다!"
integer x = 457
integer y = 2664
integer width = 334
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

event clicked;sle_msg.text =""
end event

type cb_exit from commandbutton within w_inherite_multi
string tag = "Bubblehelp=버튼을 누르시면 윈도우 화면이 종료됩니다!"
integer x = 3186
integer y = 2664
integer width = 334
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

type cb_update from commandbutton within w_inherite_multi
string tag = "Bubblehelp=버튼을 누르시면 저장됩니다!"
integer x = 2089
integer y = 2664
integer width = 334
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;sle_msg.text =""
end event

type cb_insert from commandbutton within w_inherite_multi
string tag = "Bubblehelp=버튼을 누르시면 행이 삽입됩니다!"
integer x = 823
integer y = 2664
integer width = 334
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삽입(&I)"
end type

event clicked;sle_msg.text =""
end event

type cb_delete from commandbutton within w_inherite_multi
string tag = "Bubblehelp=버튼을 누르시면 해당행이 삭제됩니다!"
integer x = 2455
integer y = 2664
integer width = 334
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;sle_msg.text =""
end event

type cb_retrieve from commandbutton within w_inherite_multi
string tag = "Bubblehelp=버튼을 누르시면 조회됩니다!"
integer x = 91
integer y = 2664
integer width = 334
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;sle_msg.text =""
end event

type st_1 from statictext within w_inherite_multi
integer x = 27
integer y = 2836
integer width = 325
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "메세지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_inherite_multi
string tag = "Bubblehelp=버튼을 누르시면 보여지는 데이타를~~n~~n지우고 처음상태로 돌아갑니다!"
integer x = 2821
integer y = 2664
integer width = 334
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

event clicked;sle_msg.text =""
ib_any_typing =False
end event

type dw_datetime from datawindow within w_inherite_multi
integer x = 2839
integer y = 2836
integer width = 750
integer height = 92
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type sle_msg from singlelineedit within w_inherite_multi
integer x = 357
integer y = 2836
integer width = 1829
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_inherite_multi
integer x = 2048
integer y = 2604
integer width = 1513
integer height = 200
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type gb_1 from groupbox within w_inherite_multi
integer x = 46
integer y = 2604
integer width = 1152
integer height = 200
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type gb_10 from groupbox within w_inherite_multi
integer x = 9
integer y = 2784
integer width = 3589
integer height = 152
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
end type

