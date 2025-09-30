$PBExportHeader$w_inherite.srw
$PBExportComments$물류 관리 Inherite Window
forward
global type w_inherite from window
end type
type dw_insert from u_key_enter within w_inherite
end type
type p_delrow from uo_picture within w_inherite
end type
type p_addrow from uo_picture within w_inherite
end type
type p_search from uo_picture within w_inherite
end type
type p_ins from uo_picture within w_inherite
end type
type p_exit from uo_picture within w_inherite
end type
type p_can from uo_picture within w_inherite
end type
type p_print from uo_picture within w_inherite
end type
type p_inq from uo_picture within w_inherite
end type
type p_del from uo_picture within w_inherite
end type
type p_mod from uo_picture within w_inherite
end type
type cb_exit from commandbutton within w_inherite
end type
type cb_mod from commandbutton within w_inherite
end type
type cb_ins from commandbutton within w_inherite
end type
type cb_del from commandbutton within w_inherite
end type
type cb_inq from commandbutton within w_inherite
end type
type cb_print from commandbutton within w_inherite
end type
type st_1 from statictext within w_inherite
end type
type cb_can from commandbutton within w_inherite
end type
type cb_search from commandbutton within w_inherite
end type
type dw_datetime from datawindow within w_inherite
end type
type sle_msg from singlelineedit within w_inherite
end type
type gb_10 from groupbox within w_inherite
end type
type gb_button1 from groupbox within w_inherite
end type
type gb_button2 from groupbox within w_inherite
end type
end forward

global type w_inherite from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
long backcolor = 32106727
event ue_open ( )
dw_insert dw_insert
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
cb_exit cb_exit
cb_mod cb_mod
cb_ins cb_ins
cb_del cb_del
cb_inq cb_inq
cb_print cb_print
st_1 st_1
cb_can cb_can
cb_search cb_search
dw_datetime dw_datetime
sle_msg sle_msg
gb_10 gb_10
gb_button1 gb_button1
gb_button2 gb_button2
end type
global w_inherite w_inherite

type variables
Boolean ib_any_typing     
String	is_window_id
String     is_today              //시작일자
String     is_totime             //시작시간
String     sModStatus
String     is_usegub           //이력관리 여부
String is_saupcd  //사업장코드

/* 이미지 저장 */
Windowobject winobject[]
String is_picutre[]
String is_picutername_base[]
String is_picutername_on[]
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public subroutine wf_setfont ()
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

public subroutine wf_setfont ();WindowObject l_object[]
Long i
gstr_object_chg lstr_object		
For i = 1 To UpperBound(Control[])
	l_object[i] = Control[i]
	lstr_object.lu_object[i] = l_object[i]	//Window Object
	lstr_object.li_obj = i						//Window Object 갯수
Next
f_change_font(lstr_object)
end subroutine

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





end event

on w_inherite.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.dw_insert=create dw_insert
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
this.cb_exit=create cb_exit
this.cb_mod=create cb_mod
this.cb_ins=create cb_ins
this.cb_del=create cb_del
this.cb_inq=create cb_inq
this.cb_print=create cb_print
this.st_1=create st_1
this.cb_can=create cb_can
this.cb_search=create cb_search
this.dw_datetime=create dw_datetime
this.sle_msg=create sle_msg
this.gb_10=create gb_10
this.gb_button1=create gb_button1
this.gb_button2=create gb_button2
this.Control[]={this.dw_insert,&
this.p_delrow,&
this.p_addrow,&
this.p_search,&
this.p_ins,&
this.p_exit,&
this.p_can,&
this.p_print,&
this.p_inq,&
this.p_del,&
this.p_mod,&
this.cb_exit,&
this.cb_mod,&
this.cb_ins,&
this.cb_del,&
this.cb_inq,&
this.cb_print,&
this.st_1,&
this.cb_can,&
this.cb_search,&
this.dw_datetime,&
this.sle_msg,&
this.gb_10,&
this.gb_button1,&
this.gb_button2}
end on

on w_inherite.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_insert)
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
destroy(this.cb_exit)
destroy(this.cb_mod)
destroy(this.cb_ins)
destroy(this.cb_del)
destroy(this.cb_inq)
destroy(this.cb_print)
destroy(this.st_1)
destroy(this.cb_can)
destroy(this.cb_search)
destroy(this.dw_datetime)
destroy(this.sle_msg)
destroy(this.gb_10)
destroy(this.gb_button1)
destroy(this.gb_button2)
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

event mousemove;if p_ins.PictureName = 'C:\erpman\image\추가_over.gif' then
	p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
end If

if p_mod.PictureName = 'C:\erpman\image\저장_over.gif' then
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
end If

if p_exit.PictureName = 'C:\erpman\image\닫기_over.gif' then
	p_exit.PictureName = 'C:\erpman\image\닫기_up.gif'
end If

w_mdi_frame.st_bubble.visible = false
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

type dw_insert from u_key_enter within w_inherite
event ue_key pbm_dwnkey
integer x = 91
integer y = 2084
integer width = 256
integer height = 208
integer taborder = 110
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

// DATA EXPORT
IF keydown(keyControl!) AND keydown(keyShift!) AND keydown(keyS!) THEN
	SaveAs("", TEXT!, FALSE)
END IF

// DATA IMPORT
IF keydown(keyControl!) AND keydown(keyShift!) AND keydown(keyC!) THEN
	ImportFile("")
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

type p_delrow from uo_picture within w_inherite
integer x = 3749
integer y = 24
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

type p_addrow from uo_picture within w_inherite
integer x = 3575
integer y = 24
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

type p_search from uo_picture within w_inherite
integer x = 2880
integer y = 24
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\button_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\button_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\button_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

type p_ins from uo_picture within w_inherite
integer x = 3401
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

type p_exit from uo_picture within w_inherite
integer x = 4443
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

type p_can from uo_picture within w_inherite
integer x = 4270
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

type p_print from uo_picture within w_inherite
integer x = 3054
integer y = 24
integer width = 178
integer taborder = 100
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

type p_inq from uo_picture within w_inherite
integer x = 3227
integer y = 24
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event

type p_del from uo_picture within w_inherite
integer x = 4096
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

type p_mod from uo_picture within w_inherite
integer x = 3922
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

type cb_exit from commandbutton within w_inherite
boolean visible = false
integer x = 2981
integer y = 2780
integer width = 334
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

type cb_mod from commandbutton within w_inherite
boolean visible = false
integer x = 667
integer y = 2780
integer width = 334
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

type cb_ins from commandbutton within w_inherite
boolean visible = false
integer x = 306
integer y = 2780
integer width = 334
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "등록(&I)"
end type

type cb_del from commandbutton within w_inherite
boolean visible = false
integer x = 1029
integer y = 2780
integer width = 334
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

type cb_inq from commandbutton within w_inherite
boolean visible = false
integer x = 1390
integer y = 2780
integer width = 334
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

type cb_print from commandbutton within w_inherite
boolean visible = false
integer x = 1751
integer y = 2780
integer width = 334
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "출력(&P)"
end type

type st_1 from statictext within w_inherite
boolean visible = false
integer x = 18
integer y = 2992
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

type cb_can from commandbutton within w_inherite
boolean visible = false
integer x = 2075
integer y = 2740
integer width = 334
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

type cb_search from commandbutton within w_inherite
boolean visible = false
integer x = 2473
integer y = 2780
integer width = 480
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "자료조회(&W)"
end type

type dw_datetime from datawindow within w_inherite
boolean visible = false
integer x = 2862
integer y = 2992
integer width = 750
integer height = 92
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type sle_msg from singlelineedit within w_inherite
boolean visible = false
integer x = 370
integer y = 2992
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

type gb_10 from groupbox within w_inherite
boolean visible = false
integer y = 2940
integer width = 3621
integer height = 152
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

type gb_button1 from groupbox within w_inherite
boolean visible = false
integer x = 1170
integer y = 3212
integer width = 763
integer height = 192
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_button2 from groupbox within w_inherite
boolean visible = false
integer x = 1714
integer y = 3236
integer width = 1481
integer height = 192
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

