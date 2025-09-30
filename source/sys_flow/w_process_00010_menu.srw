$PBExportHeader$w_process_00010_menu.srw
$PBExportComments$업무Flow
forward
global type w_process_00010_menu from window
end type
type cb_exit from picture within w_process_00010_menu
end type
type cb_cancel from picture within w_process_00010_menu
end type
type cb_delete from picture within w_process_00010_menu
end type
type cb_1 from picture within w_process_00010_menu
end type
type cb_save from picture within w_process_00010_menu
end type
type dw_ip from datawindow within w_process_00010_menu
end type
type dw_1 from datawindow within w_process_00010_menu
end type
type st_5 from statictext within w_process_00010_menu
end type
type pb_next from picturebutton within w_process_00010_menu
end type
type dw_list from datawindow within w_process_00010_menu
end type
type dw_insert from datawindow within w_process_00010_menu
end type
type sle_msg from singlelineedit within w_process_00010_menu
end type
type dw_datetime from datawindow within w_process_00010_menu
end type
type st_10 from statictext within w_process_00010_menu
end type
type gb_3 from groupbox within w_process_00010_menu
end type
type gb_4 from groupbox within w_process_00010_menu
end type
type gb_5 from groupbox within w_process_00010_menu
end type
type gb_mode1 from groupbox within w_process_00010_menu
end type
type rr_1 from roundrectangle within w_process_00010_menu
end type
end forward

global type w_process_00010_menu from window
integer width = 3529
integer height = 1944
boolean titlebar = true
string title = "Attention Menu 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
boolean toolbarvisible = false
cb_exit cb_exit
cb_cancel cb_cancel
cb_delete cb_delete
cb_1 cb_1
cb_save cb_save
dw_ip dw_ip
dw_1 dw_1
st_5 st_5
pb_next pb_next
dw_list dw_list
dw_insert dw_insert
sle_msg sle_msg
dw_datetime dw_datetime
st_10 st_10
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_mode1 gb_mode1
rr_1 rr_1
end type
global w_process_00010_menu w_process_00010_menu

type variables
Int          il_lastclickedrow

Boolean ib_move_flag
String     is_User_id, is_primary_id
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public function integer ue_shift_highlight (long al_aclickedrow)
public subroutine wf_reset ()
end prototypes

public function integer wf_warndataloss (string as_titletext);///*=============================================================================================
//		 1. window-level user function : 종료, 등록시 호출됨
//		    dw_detail 의 typing(datawindow) 변경사항 검사
//
//		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               
//
//		 3. Argument:  as_titletext (warning messagebox)                                                                          
//		    Return values:                                                   
//                                                                  
//      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
//			* -1 : 진행을 중단할 경우.                      
//=============================================================================================*/
//
IF ib_move_flag = true THEN  			

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

public function integer ue_shift_highlight (long al_aclickedrow);int li_idx

dw_list.SetRedraw(FALSE)
dw_list.SelectRow(0, FALSE) 

IF il_lastclickedrow = 0 THEN
	dw_list.SetRedraw(TRUE)
	RETURN 1
END IF
IF il_lastclickedrow > al_aclickedrow THEN
	FOR li_idx = il_lastclickedrow TO al_aclickedrow STEP -1
		dw_list.SelectRow(li_idx, TRUE)
	END FOR
ELSE
	FOR li_idx = il_lastclickedrow TO al_aclickedrow
		dw_list.SelectRow(li_idx, TRUE)
	NEXT
END IF
dw_list.SetRedraw(TRUE)
RETURN 1
end function

public subroutine wf_reset ();dw_insert.setredraw(false)
dw_list.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_list.reset()
dw_1.reset()
dw_1.insertrow(0)

dw_1.Modify("win_nm.BackGround.Color= 12632256") 
dw_1.enabled = false

cb_delete.enabled = false

pb_next.enabled = false

dw_insert.setredraw(true)
dw_list.setredraw(true)
dw_1.setredraw(true)


ib_move_flag = False

end subroutine

on w_process_00010_menu.create
this.cb_exit=create cb_exit
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.cb_1=create cb_1
this.cb_save=create cb_save
this.dw_ip=create dw_ip
this.dw_1=create dw_1
this.st_5=create st_5
this.pb_next=create pb_next
this.dw_list=create dw_list
this.dw_insert=create dw_insert
this.sle_msg=create sle_msg
this.dw_datetime=create dw_datetime
this.st_10=create st_10
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_mode1=create gb_mode1
this.rr_1=create rr_1
this.Control[]={this.cb_exit,&
this.cb_cancel,&
this.cb_delete,&
this.cb_1,&
this.cb_save,&
this.dw_ip,&
this.dw_1,&
this.st_5,&
this.pb_next,&
this.dw_list,&
this.dw_insert,&
this.sle_msg,&
this.dw_datetime,&
this.st_10,&
this.gb_3,&
this.gb_4,&
this.gb_5,&
this.gb_mode1,&
this.rr_1}
end on

on w_process_00010_menu.destroy
destroy(this.cb_exit)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.cb_1)
destroy(this.cb_save)
destroy(this.dw_ip)
destroy(this.dw_1)
destroy(this.st_5)
destroy(this.pb_next)
destroy(this.dw_list)
destroy(this.dw_insert)
destroy(this.sle_msg)
destroy(this.dw_datetime)
destroy(this.st_10)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_mode1)
destroy(this.rr_1)
end on

event open;f_window_center_response(This)
dw_insert.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_ip.settransobject(sqlca)
dw_ip.insertrow(0)
dw_1.settransobject(sqlca)
dw_1.insertrow(0)
dw_datetime.insertrow(0)
ib_move_flag = False
end event

type cb_exit from picture within w_process_00010_menu
integer x = 3282
integer width = 178
integer height = 144
string picturename = "C:\ERPMAN\image\닫기_up.gif"
boolean focusrectangle = false
end type

event clicked;IF wf_warndataloss("종료") = -1 THEN  

	RETURN

END IF



close(parent)
end event

type cb_cancel from picture within w_process_00010_menu
integer x = 3054
integer width = 178
integer height = 144
string picturename = "C:\ERPMAN\image\취소_up.gif"
boolean focusrectangle = false
end type

event clicked;//f_window_center(This)
dw_insert.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_ip.settransobject(sqlca)
dw_ip.insertrow(0)
dw_1.settransobject(sqlca)
dw_1.insertrow(0)
dw_datetime.insertrow(0)
ib_move_flag = False
end event

type cb_delete from picture within w_process_00010_menu
integer x = 2825
integer width = 178
integer height = 144
string picturename = "C:\ERPMAN\image\삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;sle_msg.text = ""


string pgm_id, pgm_nm

Beep (1)

pgm_id = dw_insert.GetItemString(1, 'sub2_user_r_c_window')
pgm_nm = dw_insert.GetItemString(1, 'sub2_user_t_sub2_name')

IF	 MessageBox("삭 제", pgm_nm + " 을~r삭제하시겠습니까? ", &
						         question!, yesno!)  = 2		THEN	RETURN

dw_insert.DeleteRow(0)

IF dw_insert.Update() <> 1 THEN
	f_message_chk(31,'')
	ROLLBACK;
	Return
END IF	

ib_move_flag = False
this.enabled = false

dw_list.SelectRow(0, False)
dw_insert.SelectRow(0, False)

sle_msg.text = '자료를 삭제하였습니다.'

COMMIT;

end event

type cb_1 from picture within w_process_00010_menu
integer x = 2597
integer width = 178
integer height = 144
string picturename = "C:\ERPMAN\image\조회_up.gif"
boolean focusrectangle = false
end type

event clicked;String  sUserid, sdigital 
long    lmainid, lsubid

if dw_ip.accepttext() = -1	then	return -1

sUserid = dw_ip.GetitemString(1,'suserid')
lmainid = dw_ip.GetitemNumber(1,'main_id')
lsubid  = dw_ip.GetitemNumber(1,'sub1_id')

if isnull(sUserid) or sUserid = "" then
	f_message_chk(30,'[USER-ID]')
	dw_ip.SetColumn('suserid')
	dw_ip.SetFocus()
	return
end if	

if isnull(lmainid) or lmainid = 0 then 
	f_message_chk(30,'[대분류]')
	dw_ip.SetColumn('main_id')
	dw_ip.SetFocus()
	return
end if	

if isnull(lsubid) or lsubid = 0 then 
	f_message_chk(30,'[중분류]')
	dw_ip.SetColumn('sub1_id')
	dw_ip.SetFocus()
	return
end if	

if gs_digital = 'D' then
	sdigital = '%'
Else
	sdigital = 'D'
End if

////////////////////////////////////////////////////////////////
if dw_list.retrieve(suserid, lmainid, lsubid, sdigital) < 1	then
	f_message_chk(50,'')
	return
end if	
end event

type cb_save from picture within w_process_00010_menu
integer x = 2368
integer width = 178
integer height = 144
string picturename = "C:\ERPMAN\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;sle_msg.text = ""

IF ib_move_flag = False THEN RETURN

IF dw_insert.Update() <> 1 THEN
	f_message_chk(32,'')
	ROLLBACK;
	Return
END IF	

ib_move_flag = False

dw_list.SelectRow(0, False)
dw_insert.SelectRow(0, False)

sle_msg.text = '자료를 저장하였습니다.'

COMMIT;



end event

type dw_ip from datawindow within w_process_00010_menu
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 178
integer y = 164
integer width = 1550
integer height = 160
integer taborder = 20
string dataobject = "d_process_00010_4"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sconfirm, snull
int    inull, get_id, i_main, i_sub1

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="suserid" THEN
	is_User_id = this.gettext()
	
	IF	is_User_id = "" or isnull(is_User_id) THEN 
		wf_reset()
		setnull(is_user_id)
      return
	END IF
	
	SELECT "LOGIN_T"."L_USERID"
	INTO :sConfirm
	FROM "LOGIN_T"  
	WHERE ( "LOGIN_T"."L_USERID" = :is_User_Id )  ;

	IF	sqlca.sqlcode <> 0		then
		messagebox("USER ID 확인", "등록된 USER ID 가 아닙니다.")
		setnull(is_user_id)
	   this.setitem(1, 'suserid', snull)
		wf_reset()
		RETURN 1
	ELSE
		dw_list.reset()
		dw_insert.reset()
		dw_1.reset()
		dw_1.insertrow(0)
		dw_1.Modify("win_nm.BackGround.Color= 65535") 
		dw_1.enabled = true
		cb_delete.enabled = false
		ib_move_flag = False
	END IF
ELSEIF this.GetColumnName() ="main_id" THEN
	i_main = integer(this.GetText())
   
	IF i_main = 0 or isnull(i_main) then  return 
	
	IF i_main < 50 OR i_main > 99 Then
      messagebox("확 인", "물류관리의 대분류는 50 - 99 까지 입력가능합니다.")
	   this.setitem(1, 'main_id', inull)
	   return 1
	END IF	
	
	SELECT "SUB2_T"."MAIN_ID" 
	  INTO :get_id  
	  FROM "SUB2_T"  
	 WHERE ( "SUB2_T"."MAIN_ID" >= 50 ) AND  
			 ( "SUB2_T"."MAIN_ID" <= 99 ) AND  
			 ( "SUB2_T"."MAIN_ID" = :i_main ) AND
			 ( "SUB2_T"."SUB1_ID" =  99 ) AND
			 ( "SUB2_T"."SUB2_ID" =  99 ) ;
      IF SQLCA.SQLCODE <> 0 then 
         this.triggerevent(rbuttondown!)
         return 1
		END IF	
ELSEIF this.GetColumnName() ="sub1_id" THEN
	i_sub1 = integer(this.GetText())
   
	IF i_sub1 = 0 or isnull(i_sub1) then 
	   return 
	END IF	
END IF

end event

event itemerror;return 1
end event

event rbuttondown;int    i_code, i_name, inull

setnull(inull)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'main_id' then
	open(w_pgid_popup)
	
	i_code = integer(gs_code)	

	if isnull(i_code) or i_code = 0 then 
		this.SetItem(1,"main_id", inull)
		return 1
	end if
	this.SetItem(1,"main_id", i_code)
	RETURN 1
elseif this.GetColumnName() = 'sub1_id' then
	open(w_pgid_popup2)

	i_code = integer(gs_code)	
	i_name = integer(gs_codename)	
	
	if isnull(i_code) or i_code = 0 then 
		this.SetItem(1,"sub1_id", inull)
		return 1
	end if
	
	this.SetItem(1,"main_id", i_code)
	this.SetItem(1,"sub1_id", i_name)
	RETURN 1
end if	

end event

type dw_1 from datawindow within w_process_00010_menu
event ue_enter pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 2309
integer y = 204
integer width = 1125
integer height = 100
integer taborder = 40
boolean enabled = false
string dataobject = "d_process_00010_1"
boolean border = false
boolean livescroll = true
end type

event ue_enter;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;sle_msg.text = ""


setnull(gs_code)
setnull(gs_codename)

this.AcceptText ( )
gs_code = is_user_id

Open(w_pgm_popup)
		
if isnull(gs_code) or gs_code = "" then 	return 
if isnull(gs_codename) or gs_codename = "" then 	return 

this.SetItem(1,"win_nm", gs_codename)

is_primary_id = gs_code

dw_insert.retrieve(is_user_id, is_primary_id)
pb_next.enabled = true

ib_move_flag = False

RETURN 1

end event

event itemchanged;sle_msg.text = ""


string sPgm_nm, snull

setnull(snull)

ib_move_flag = False

sPgm_nm = trim(this.gettext())
		
IF sPgm_nm = "" OR IsNull(sPgm_nm) THEN 
   setnull(is_primary_id)
	dw_insert.reset()
	this.setfocus()
   pb_next.enabled = false
   RETURN
End if

SELECT DISTINCT "SUB2_USER_T"."WINDOW_NAME"  
  INTO :is_primary_id  
  FROM "SUB2_USER_T"  
 WHERE "SUB2_USER_T"."USER_ID" = :is_user_id AND
       "SUB2_USER_T"."SUB2_ID" <> 100 AND
       "SUB2_USER_T"."SUB2_ID" <> 99 AND
       "SUB2_USER_T"."WINDOW_NAME" <> 'w_sys_001_mdi' AND   //예외
       "SUB2_USER_T"."SUB2_NAME" = :sPgm_nm   ;

IF SQLCA.SQLCODE <> 0 THEN
	f_message_chk(33, '[Program 명]')
   setnull(is_primary_id)
   this.setitem(1, "win_nm", snull)
	this.setfocus()
   dw_insert.reset()
   pb_next.enabled = false
	RETURN 1
ELSE
   dw_insert.retrieve(is_user_id, is_primary_id)
   pb_next.enabled = true
END IF

end event

event itemerror;return 1
end event

type st_5 from statictext within w_process_00010_menu
integer x = 1979
integer y = 224
integer width = 320
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "PROGRAM 명"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_next from picturebutton within w_process_00010_menu
integer x = 1723
integer y = 364
integer width = 101
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\NEXT1.BMP"
string disabledname = "C:\erpman\image\NEXT1.BMP"
end type

event clicked;Int    il_ToRow, k, lreturnrow
string s_yesno, sFrom_id, spgm_nm

dw_insert.SetRedraw(False)

FOR k=1 TO dw_list.rowcount()
   s_yesno = dw_list.GetItemString(k, 's_select')
   
   if s_yesno = 'N' then continue
	
	sFrom_id = dw_list.GetItemstring(k,"sub2_user_t_window_name")
	
	IF sFrom_id = is_primary_id then continue
	
	lReturnRow = dw_insert.Find("sub2_user_r_c_window = '"+sFrom_id+"' ", 1, dw_insert.RowCount())
	
	IF lReturnRow <> 0 THEN continue
 	
	spgm_nm = dw_list.GetItemstring(k,"sub2_user_t_sub2_name")

	il_ToRow = dw_insert.insertrow(0)
	dw_insert.setitem(il_ToRow, "sub2_user_r_user_id",   is_user_id)
	dw_insert.setitem(il_ToRow, "sub2_user_r_p_window",  is_primary_id)
	dw_insert.setitem(il_ToRow, "sub2_user_t_sub2_name", sPgm_nm)
	dw_insert.setitem(il_ToRow, "sub2_user_r_c_window",  sFrom_id)
   
	dw_list.SelectRow(k, False)
NEXT

dw_insert.SetRedraw(True)

ib_move_flag = True


end event

type dw_list from datawindow within w_process_00010_menu
integer x = 96
integer y = 396
integer width = 1595
integer height = 1396
string dataobject = "d_process_00010_2"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//multi select
sle_msg.text = ""

string ls_keydowntype

IF row <= 0 THEN RETURN

IF Keydown(KeyShift!) THEN
	ue_shift_highlight(row)

ELSEIF this.IsSelected(row) THEN
	il_lastclickedrow = row
	
	this.SelectRow(0, FALSE)
	this.SelectRow(row, TRUE)
ELSEIF Keydown(KeyControl!) THEN
	il_lastclickedrow = row
	this.SelectRow(row, TRUE)
ELSE
	il_lastclickedrow = row
	
	this.SelectRow(0, FALSE)
	this.SelectRow(row, TRUE)
END IF 

end event

type dw_insert from datawindow within w_process_00010_menu
integer x = 1861
integer y = 396
integer width = 1595
integer height = 1396
string dataobject = "d_process_00010_3"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;sle_msg.text = ""


If Row <= 0 then
	SelectRow(0,False)
   cb_delete.enabled = false
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
   cb_delete.enabled = true
END IF

end event

type sle_msg from singlelineedit within w_process_00010_menu
integer x = 375
integer y = 5000
integer width = 2446
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

type dw_datetime from datawindow within w_process_00010_menu
integer x = 2821
integer y = 5000
integer width = 741
integer height = 84
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type st_10 from statictext within w_process_00010_menu
integer x = 9
integer y = 5000
integer width = 361
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

type gb_3 from groupbox within w_process_00010_menu
integer x = 1001
integer y = 5000
integer width = 471
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_process_00010_menu
integer x = 1833
integer y = 336
integer width = 1650
integer height = 1480
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "TO"
end type

type gb_5 from groupbox within w_process_00010_menu
integer x = 69
integer y = 336
integer width = 1650
integer height = 1480
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "FROM"
end type

type gb_mode1 from groupbox within w_process_00010_menu
integer x = 1330
integer y = 5000
integer width = 1650
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 65535
long backcolor = 12632256
end type

type rr_1 from roundrectangle within w_process_00010_menu
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1961
integer y = 172
integer width = 1499
integer height = 148
integer cornerheight = 40
integer cornerwidth = 55
end type

