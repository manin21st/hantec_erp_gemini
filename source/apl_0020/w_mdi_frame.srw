$PBExportHeader$w_mdi_frame.srw
$PBExportComments$ez-erp mdi frame - 권
forward
global type w_mdi_frame from window
end type
type mdi_1 from mdiclient within w_mdi_frame
end type
type st_bubble from statictext within w_mdi_frame
end type
type dw_listbar from datawindow within w_mdi_frame
end type
type cb_2 from commandbutton within w_mdi_frame
end type
type cb_1 from commandbutton within w_mdi_frame
end type
type dw_addr from datawindow within w_mdi_frame
end type
type sle_addr from dropdownlistbox within w_mdi_frame
end type
type p_1 from picture within w_mdi_frame
end type
type st_3 from statictext within w_mdi_frame
end type
type dw_date from datawindow within w_mdi_frame
end type
type st_window from statictext within w_mdi_frame
end type
type st_user from statictext within w_mdi_frame
end type
type dw_menu from datawindow within w_mdi_frame
end type
type sle_msg from singlelineedit within w_mdi_frame
end type
type lv_open_menu from listview within w_mdi_frame
end type
end forward

global type w_mdi_frame from window
integer width = 4681
integer height = 2968
boolean titlebar = true
string title = "ERP-MANager"
string menuname = "m_mdi_menu"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = mdi!
long backcolor = 80269524
event ue_open ( )
event ue_barrefresh ( )
event ue_mousemove pbm_mousemove
mdi_1 mdi_1
st_bubble st_bubble
dw_listbar dw_listbar
cb_2 cb_2
cb_1 cb_1
dw_addr dw_addr
sle_addr sle_addr
p_1 p_1
st_3 st_3
dw_date dw_date
st_window st_window
st_user st_user
dw_menu dw_menu
sle_msg sle_msg
lv_open_menu lv_open_menu
end type
global w_mdi_frame w_mdi_frame

type variables

end variables

forward prototypes
public subroutine wf_menu_create (integer arg_gubun)
public function integer wf_navi (string arg_name)
end prototypes

event ue_open();window	lw_active

//user변경시 활성화 되어있는 모든 윈도우 닫기
DO WHILE TRUE
	lw_active = this.GetActiveSheet()
	if IsValid(lw_active) then
		Close(lw_active)
	else
		Exit
	end if
LOOP

// Server현재일자Setting
Select To_char(sysdate, 'yyyymmdd')
  Into :gs_today
  From dual;

SELECT "DATANAME"  
 INTO :gs_digital  
 FROM "SYSCNFG"  
WHERE ( "SYSCNFG"."SYSGU"  = 'C'  ) AND  
		( "SYSCNFG"."SERIAL" =  2   ) AND  
		( "SYSCNFG"."LINENO" =  '1' )   ;

IF gs_digital ='' or isnull(gs_digital) then 
	gs_digital = 'D'
END IF

  SELECT "DATANAME"  
    INTO :gs_grpgbn
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU"  = 'W'  ) AND  
         ( "SYSCNFG"."SERIAL" =  1   ) AND  
         ( "SYSCNFG"."LINENO" =  '1' )   ;

IF gs_grpgbn ='' or isnull(gs_grpgbn) then 
	gs_grpgbn = 'N'
END IF

IF gs_grpgbn = 'Y' THEN
//	dw_menu.Object.p_1.filename = 'C:\erpman\image\menu_erp.jpg'	//그룹웨어 연동시
//	dw_menu.Object.p_1.filename = 'C:\erpman\image\menu_grpw.gif'	//그룹웨어 연동시
	dw_menu.Object.p_g.Filename = 'C:\erpman\image\but1_ov.gif' //그룹웨어 연동시
	dw_menu.Object.t_1.Visible = True
	dw_menu.Object.t_2.Visible = True
	dw_menu.Object.t_3.Visible = True
	dw_menu.Object.t_4.Visible = True
	select  dataname into :gs_path from syscnfg where sysgu = 'W' and  serial = 1 and lineno = 6 ;
ELSE
//	dw_menu.Object.p_1.filename = 'C:\erpman\image\menu_erp.jpg'	//ERP 만 사용시
	dw_menu.Object.p_g.filename = 'C:\erpman\image\but1.jpg'	//ERP 만 사용시
	dw_menu.Object.t_1.Visible = False
	dw_menu.Object.t_2.Visible = False
	dw_menu.Object.t_3.Visible = False
	dw_menu.Object.t_4.Visible = False
END IF

Open(w_login)

if gs_Saupj = '' or IsNull(gs_Saupj) or gs_Saupj = '%' then
	this.Title = 'ERP-MANAGER'
else
	this.Title = 'ERP-MANAGER '  +  ' << ' + F_GET_REFFERANCE('AD',gs_Saupj) + ' >>'
end if

st_user.Text = gs_username

Int	li_i		// 1:회계, 2:인사, 3:물류, 4:시스템, 5:바로가기, 6:경영정보

For	li_i = 1 To 6

	gds_menu[li_i] = CREATE datastore
	
	Choose Case	li_i
		Case	1
			gds_menu[li_i].DataObject = 'd_sub2_user_e'	
		Case	2
			gds_menu[li_i].DataObject = 'd_sub2_user_p'	
		Case	3
			gds_menu[li_i].DataObject = 'd_sub2_user_m'				
		Case	4
			gds_menu[li_i].DataObject = 'd_sub2_user_s'				
		Case	5
			gds_menu[li_i].DataObject = 'd_sub2_user_f'	
		Case	6
			gds_menu[li_i].DataObject = 'd_sub2_user_i'				
	End Choose	
	gds_menu[li_i].SetTransObject(SQLCA)
	gds_menu[li_i].Retrieve(gs_userid)	
Next

// 공지사항 팝업
// open(w_notice_popup)
end event

event ue_barrefresh();Int i, j, li_count
Dec dwidth
String sTitle
ListviewItem llvi_Current

lv_open_menu.SetRedraw(False)
//--------------------------
li_count = dw_listbar.RowCount()
if li_count < 1 then 
	lv_open_menu.deleteitems()
	lv_open_menu.SetRedraw(True)
	Return 
end if

dwidth = (This.Width - p_1.Width)/li_count
//1자간 폭을 대략 90으로 Setting 
j = Truncate(dwidth/100,0)

lv_open_menu.deleteitems()

FOR i = 1 TO dw_listbar.Rowcount()
	
	llvi_Current.Data  = dw_listbar.GetItemString(i,'window_id')
	sTitle = dw_listbar.GetItemString(i,'window_name')
	if j < Len(sTitle) then 
		llvi_Current.Label = Left(sTitle,(j+2)) + '..'
	else 
		llvi_Current.Label = sTitle
	end if
	llvi_Current.itemx = (i - 1) * 500
	llvi_Current.itemy = 0
	llvi_Current.PictureIndex = 1
		
	lv_open_menu.additem(llvi_Current)
		
NEXT
lv_open_menu.Scrolling = False

lv_open_menu.SetRedraw(True)
end event

event type long ue_mousemove(unsignedlong flags, integer xpos, integer ypos);st_bubble.visible = False
Return 0
end event

public subroutine wf_menu_create (integer arg_gubun);/***********************************************************************
	드롭다운 매뉴를 생성한다.
	인자값 : arg_gubun - 업무구분 , 1:회계, 2:인사, 3:물류, 4:시스템, 5:즐겨찾기
	리턴값 : 없음
************************************************************************/

m_main	 lm_Menu
m_dynamic lm_Add_Menu
Long      ll_Rows, ll_Row
Integer   li_root = 1, li_2 = 0, li_3 = 0, i, iw=0
String    ls_name, ls_where

IF arg_gubun = 5 THEN	//즐겨찾기
	lm_Menu = Create m_main
		
	ll_Rows = gds_menu[arg_gubun].RowCount()
	ll_Row = 1 
	
	li_2 = 0
	li_3 = 0
	
	Do While ll_Row <= ll_Rows
		li_root += 1
		
		If gds_menu[arg_gubun].GetItemString( ll_Row, 'gbn' ) = '2' And iw = 0 Then			
			lm_Add_Menu = Create m_dynamic
			lm_Add_Menu.item[1].Text = '-'
			lm_Menu.Item[li_root] = lm_Add_Menu.Item[1]
			
			iw++
			li_root += 1
		End If
		
		lm_Add_Menu = Create m_dynamic
		ls_name = gds_menu[arg_gubun].GetItemString( ll_Row, 'sub2_name' )
		lm_Add_Menu.item[1].Text = ls_name
		lm_Add_Menu.item[1].Tag = Left(ls_name, 4 )			
		lm_Add_Menu.is_window = gds_menu[arg_gubun].GetItemString( ll_Row, 'window_name' )
		lm_Menu.Item[li_root] = lm_Add_Menu.Item[1]
		
		ll_Row += 1 
	Loop
	
	lm_Menu.Hide()
	lm_Menu.Show()
	
	lm_Menu.PopMenu(PointerX(),PointerY())
ELSEIF arg_gubun = 6 THEN	//경영정보
	
	lm_Menu = Create m_main
		
	ll_Rows = gds_menu[arg_gubun].RowCount()
	ll_Row = 1 
	
	li_2 = 0
	li_3 = 0
	
	Do While ll_Row <= ll_Rows
		
		lm_Add_Menu = Create m_dynamic
		ls_name = gds_menu[arg_gubun].GetItemString( ll_Row, 'sub2_name' )
		lm_Add_Menu.item[1].Text = ls_name
	
		Choose Case gds_menu[arg_gubun].GetItemDecimal( ll_Row, 'level_no' )
			Case 1;
						li_root += 1
						lm_Add_Menu.is_window = ''					
						lm_Menu.Item[li_root] = lm_Add_Menu.Item[1]
						li_2 = 0
						li_3 = 0
			Case 2;
						li_2 += 1
						lm_Add_Menu.item[1].Text = ls_name
						lm_Add_Menu.item[1].Tag = Left(ls_name, 4 )			
						lm_Add_Menu.is_window = gds_menu[arg_gubun].GetItemString( ll_Row, 'window_name' )
						lm_Menu.Item[li_root].Item[li_2] = lm_Add_Menu.Item[1]
		End Choose
	
		ll_Row += 1 
	
	Loop
	
	lm_Menu.Hide()
	lm_Menu.Show()
	
	lm_Menu.PopMenu(PointerX(),PointerY())
	
	
ELSE
		
	lm_Menu = Create m_main
		
	ll_Rows = gds_menu[arg_gubun].RowCount()
	ll_Row = 1 
	
	li_2 = 0
	li_3 = 0
	
	Do While ll_Row <= ll_Rows
		
		lm_Add_Menu = Create m_dynamic
		ls_name = gds_menu[arg_gubun].GetItemString( ll_Row, 'sub2_name' )
		lm_Add_Menu.item[1].Text = ls_name
	
		Choose Case gds_menu[arg_gubun].GetItemDecimal( ll_Row, 'level_no' )
			Case 1;
						li_root += 1
						lm_Add_Menu.is_window = ''					
						lm_Menu.Item[li_root] = lm_Add_Menu.Item[1]
						li_2 = 0
						li_3 = 0
			Case 2;
						li_2 += 1
						lm_Add_Menu.is_window = ''					
						lm_Menu.Item[li_root].Item[li_2] = lm_Add_Menu.Item[1]
						li_3 = 0
			Case 3;
						lm_Add_Menu.item[1].Text = ls_name
						lm_Add_Menu.item[1].Tag = Left(ls_name, 4 )			
						li_3 += 1
						lm_Add_Menu.is_window = gds_menu[arg_gubun].GetItemString( ll_Row, 'window_name' )
						lm_Menu.Item[li_root].Item[li_2].Item[li_3] = lm_Add_Menu.Item[1]
		End Choose
	
		ll_Row += 1 
	
	Loop

	/* 비밀번호 변경 추가 start */
	lm_Add_Menu = Create m_dynamic
	ls_name = '비밀번호 변경'
	lm_Add_Menu.item[1].Text = ls_name

	li_root += 1
	lm_Add_Menu.is_window = 'w_modify_pass'
	lm_Add_Menu.item[1].Text = ls_name
	lm_Add_Menu.item[1].Tag = Left(ls_name, 4 )
	lm_Menu.Item[li_root] = lm_Add_Menu.Item[1]

	/* 비밀번호 변경 추가 end */
	
	lm_Menu.Hide()
	lm_Menu.Show()
	
	lm_Menu.PopMenu(PointerX(),PointerY())
END IF
end subroutine

public function integer wf_navi (string arg_name);String   sPass, ls_window_id, ls_name
Long 		Parenthandle, nCnt, ix
Window	lw_window

string  ls_screen_id
window  lw_sheet
boolean lb_valid, lb_IsOpen, lb_IsWeb

ls_name = Trim(arg_name)
/* erp 인지 www인지 확인 */
nCnt = dw_addr.Retrieve(gs_userid, +'%'+ls_name+'%')

sle_addr.Reset()

If nCnt > 0 Then
	/* ERP PGM 호출 */
	lb_IsWeb = False
	
	If nCnt = 1 Then
		ls_window_id = dw_addr.GetItemString(nCnt, 'window_name')
		sPass			 = dw_addr.GetItemString(nCnt, 'password')
	Else
		For ix = 1 To dw_addr.RowCount()
			sle_addr.AddItem(dw_addr.GetItemString(ix, 'sub2_name'))
		Next
		sle_addr.ShowList = True
		Return 1
		
	End If
Else
	/* WWW BROSWER 호출 */
	ls_window_id = 'w_web_browser'
	lb_IsWeb = True
End If


//열고자하는 화면이 맨위에 있을때
lw_sheet = w_mdi_frame.GetFirstSheet()
IF IsValid(lw_sheet) then
	ls_screen_id = lw_sheet.ClassName()
	if lower(ls_window_id) = lower(ls_screen_id) then
		lw_sheet.Setposition(Totop!)
		lw_sheet.WindowState = Normal!
		lb_IsOpen = True
	end if
end if
	
//열고자하는 화면이 뒤에 있을때
If lb_IsOpen = False Then
	DO
		lw_sheet = w_mdi_frame.GetNextSheet(lw_sheet)
		lb_valid  = isValid(lw_sheet)
		
		if lb_valid then
			ls_screen_id = lw_sheet.ClassName()
			if lower(ls_window_id) = lower(ls_screen_id) then
				lw_sheet.Setposition(Totop!)
				lw_sheet.WindowState = Normal!
				lb_IsOpen = True
				Exit
			end if
		end if
	LOOP WHILE lb_valid
End If
	
If lb_IsWeb = False Then	
	If lb_IsOpen = False Then
		IF sPass ="" OR IsNull(sPass) THEN
		ELSE
			OpenWithParm(W_PGM_PASS,spass)
			IF Message.StringParm = "CANCEL" THEN RETURN -1
		END If
		
		OpenSheetWithParm(lw_window, ls_window_id, ls_window_id, w_mdi_frame, 0, Layered!)
	End If
End If

If lb_IsWeb Then
	w_web_browser wd
	If lb_IsOpen = False Then	
		OpenSheetWithParm(wd, ls_window_id, ls_window_id, w_mdi_frame, 0, Layered!)
		wd.Post wf_nav(ls_name)
	Else
		wd = lw_sheet
		wd.Post wf_nav(ls_name)
	End If
End If

Return 1
end function

on w_mdi_frame.create
if this.MenuName = "m_mdi_menu" then this.MenuID = create m_mdi_menu
this.mdi_1=create mdi_1
this.st_bubble=create st_bubble
this.dw_listbar=create dw_listbar
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_addr=create dw_addr
this.sle_addr=create sle_addr
this.p_1=create p_1
this.st_3=create st_3
this.dw_date=create dw_date
this.st_window=create st_window
this.st_user=create st_user
this.dw_menu=create dw_menu
this.sle_msg=create sle_msg
this.lv_open_menu=create lv_open_menu
this.Control[]={this.mdi_1,&
this.st_bubble,&
this.dw_listbar,&
this.cb_2,&
this.cb_1,&
this.dw_addr,&
this.sle_addr,&
this.p_1,&
this.st_3,&
this.dw_date,&
this.st_window,&
this.st_user,&
this.dw_menu,&
this.sle_msg,&
this.lv_open_menu}
end on

on w_mdi_frame.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
destroy(this.st_bubble)
destroy(this.dw_listbar)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_addr)
destroy(this.sle_addr)
destroy(this.p_1)
destroy(this.st_3)
destroy(this.dw_date)
destroy(this.st_window)
destroy(this.st_user)
destroy(this.dw_menu)
destroy(this.sle_msg)
destroy(this.lv_open_menu)
end on

event open;dw_date.insertRow(0)
dw_addr.SetTransObject(sqlca)

This.Center = True

PostEvent("ue_open")
end event

event resize;Window	lw_openwd
boolean	lb_isopen
Int		li_cnt = 0 
Long    Ll_Wt, Ll_Ht

Ll_wt = NewWidth - 5
Ll_ht = NewHeight - dw_menu.height - st_3.height - sle_msg.height
Mdi_1.Move(0,dw_menu.height + st_3.height) 
Mdi_1.Resize(Ll_wt,Ll_Ht)
//st_1.width = This.Width
st_3.width = This.Width
dw_menu.width = This.Width
lv_open_menu.width = This.Width - p_1.Width

cb_1.x = this.width - cb_1.width -10
cb_2.x = this.width - cb_1.width - cb_2.width - 10
sle_addr.width = This.Width - p_1.Width - cb_1.width - cb_2.width - 50

//ddlb_list.width = This.Width - st_2.Width - 60

sle_msg.width = NewWidth - dw_date.width - st_window.width - st_user.width
sle_msg.y = NewHeight - sle_msg.height

st_user.x = NewWidth - dw_date.width - st_window.width - st_user.width
st_user.y = NewHeight - sle_msg.height

st_window.x = NewWidth - dw_date.width - st_window.width
st_window.y = NewHeight - sle_msg.height

dw_date.x = NewWidth - dw_date.width
dw_date.y = NewHeight - sle_msg.height
//w_main_menu_test.height = This.Height
//w_main_menu_test.width = This.Width

This.ArrangeSheets(Layer!)
end event

event closequery;Int	li_i

For	li_i = 1 To 5
	destroy	gds_menu[li_i]
Next

If gs_empno = '1059' Then
	UPDATE DUMP_1059
	   SET CHECK_OT_DATE = TO_CHAR(SYSDATE, 'YYYYMMDD'),
		    CHECK_OT_TIME = TO_CHAR(SYSDATE, 'HH24MISS') 
	 WHERE EMPNO = '1059' ;
	If SQLCA.SQLCODE = 0 Then
		COMMIT USING SQLCA;
	Else
		ROLLBACK USING SQLCA;
	End If
End If
end event

type mdi_1 from mdiclient within w_mdi_frame
long BackColor=16777215
end type

type st_bubble from statictext within w_mdi_frame
integer x = 1198
integer y = 344
integer width = 987
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 15793151
boolean focusrectangle = false
end type

type dw_listbar from datawindow within w_mdi_frame
boolean visible = false
integer x = 654
integer y = 548
integer width = 919
integer height = 496
integer taborder = 100
boolean titlebar = true
string dataobject = "d_listbar"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean border = false
boolean livescroll = true
end type

type cb_2 from commandbutton within w_mdi_frame
boolean visible = false
integer x = 2715
integer y = 252
integer width = 471
integer height = 84
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "즐겨찾기"
end type

event clicked;//gs_code = string(Parent.PointerX())
//gs_codename = string(Parent.PointerY())

gs_code 		= string(this.x )
gs_codename = string(this.y+this.height + 20)

Open(w_webloc_popup)
end event

type cb_1 from commandbutton within w_mdi_frame
boolean visible = false
integer x = 3799
integer y = 252
integer width = 471
integer height = 84
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "즐겨찾기 추가"
end type

event clicked;String   sPass, ls_window_id, ls_name
Long 		Parenthandle, nCnt, ix
Window	lw_window

string  ls_screen_id
window  lw_sheet
boolean lb_valid, lb_IsOpen, lb_IsWeb

/* WWW BROSWER 호출 */
ls_window_id = 'w_web_browser'
lb_IsWeb = True
lb_IsOpen = False

//열고자하는 화면이 맨위에 있을때
lw_sheet = w_mdi_frame.GetFirstSheet()
IF IsValid(lw_sheet) then
	ls_screen_id = lw_sheet.ClassName()
	if lower(ls_window_id) = lower(ls_screen_id) then
		lw_sheet.Setposition(Totop!)
		lw_sheet.WindowState = Normal!
		lb_IsOpen = True
	end if
end if
	
//열고자하는 화면이 뒤에 있을때
If lb_IsOpen = False Then
	DO
		lw_sheet = w_mdi_frame.GetNextSheet(lw_sheet)
		lb_valid  = isValid(lw_sheet)
		
		if lb_valid then
			ls_screen_id = lw_sheet.ClassName()
			if lower(ls_window_id) = lower(ls_screen_id) then
				lw_sheet.Setposition(Totop!)
				lw_sheet.WindowState = Normal!
				lb_IsOpen = True
				Exit
			end if
		end if
	LOOP WHILE lb_valid
End If

If lb_IsWeb Then
	w_web_browser wd
	If lb_IsOpen = False Then
		SetNull(gs_code)
		Open(w_webloc_add_popup)
	Else
		wd = lw_sheet
		
		String sUrl, sMax
		
		sUrl = wd.sle_1.Text
//		If MessageBox('확 인',sUrl + ' 을(를) 즐겨찾기에 추가하시겠습니까?', Exclamation!, OKCancel!, 1) = 1 Then

		gs_code = sUrl
		Open(w_webloc_add_popup)
//			SELECT MAX(WINDOW_NAME) INTO :sMax FROM SUB2_USER_T_ADD WHERE USER_ID = :gs_userid AND GBN = '2';
//			If IsNull(sMax) Or sMax = '' Then	sMax = '0'
//			
//			sMax = String(Dec(sMax)+1,'0000000000')
//		  INSERT INTO "SUB2_USER_T_ADD"  
//					( "USER_ID",   					  "WINDOW_NAME",   					  "SUB2_NAME",   					  "WEB_URL",     "GBN" )  
//		  VALUES ( :gs_userid,   					  :sMax,   								  :sUrl,   							  :sUrl,   		  '2' )  ;
//			COMMIT;
				
//		End If
	End If
End If

Return 1
end event

type dw_addr from datawindow within w_mdi_frame
boolean visible = false
integer x = 27
integer y = 444
integer width = 453
integer height = 444
integer taborder = 90
string title = "none"
string dataobject = "d_menu_addr"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event losefocus;This.Visible = False
end event

type sle_addr from dropdownlistbox within w_mdi_frame
event ue_keydown pbm_keydown
event ue_dwnkey pbm_dwnkey
event ue_enter pbm_dwnprocessenter
boolean visible = false
integer x = 635
integer y = 252
integer width = 402
integer height = 1188
integer taborder = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean allowedit = true
boolean sorted = false
boolean vscrollbar = true
string item[] = {"","",""}
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;//If keyDown(KeyEnter!) Then
//	MessageBox('1', '1')
//End If

//If keyDown(keyV!) And keyDown(keyAlt!) Then
//	p_choose.TriggerEvent(Clicked!)
//End If
//
//If keyDown(keyC!) And keyDown(keyAlt!) Then
//	p_exit.TriggerEvent(Clicked!)
//End If
end event

event modified;IF This.ShowList THEN Return
wf_navi(Trim(This.Text))
Return 1
end event

event selectionchanged;IF sle_addr.ShowList THEN Return
sle_addr.ShowList = False
end event

event doubleclicked;sle_addr.ShowList = False
wf_navi(Trim(This.Text))
end event

event dragenter;//MessageBox('1','1')
end event

type p_1 from picture within w_mdi_frame
event ue_mousemove pbm_mousemove
integer x = 5
integer y = 248
integer width = 617
integer height = 88
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\erp_log.jpg"
boolean focusrectangle = false
end type

event type long ue_mousemove(unsignedlong flags, integer xpos, integer ypos);st_bubble.visible = false
Return 0
end event

event clicked;If sle_addr.Visible = False Then
	sle_addr.Visible = True
	lv_open_menu.Visible = False
	
	cb_1.Visible = True
	cb_2.Visible = True
	sle_addr.SetFocus()
Else
	sle_addr.Visible = False
	lv_open_menu.Visible = true
	
	cb_1.Visible = False
	cb_2.Visible = False
End If
end event

type st_3 from statictext within w_mdi_frame
integer y = 240
integer width = 1993
integer height = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 29793924
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_date from datawindow within w_mdi_frame
integer x = 1861
integer y = 1232
integer width = 736
integer height = 84
integer taborder = 40
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_window from statictext within w_mdi_frame
integer x = 1061
integer y = 1232
integer width = 786
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_user from statictext within w_mdi_frame
integer x = 709
integer y = 1232
integer width = 338
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_menu from datawindow within w_mdi_frame
event ue_mousemove pbm_mousemove
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondwn pbm_lbuttondown
integer width = 3776
integer height = 244
integer taborder = 10
string title = "none"
string dataobject = "d_main_menu"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event ue_mousemove;String ls_Object

Long	ll_x, ll_y

st_bubble.visible = False

ls_Object = Lower(This.GetObjectAtPointer())

ll_x = This.PointerX()
ll_y = This.PointerY()

//IF ll_x >= 1120 AND ll_x <= (1120+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//그룹웨어
If LEFT(ls_object, 3) = 'p_g' Then
	IF gs_grpgbn = 'N' THEN Return 0
//	This.Object.t_grp.Border 	= "6"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "0"	
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '6'
	This.Object.p_2.Border = '0'
	This.Object.p_3.Border = '0'
	This.Object.p_4.Border = '0'
	This.Object.p_5.Border = '0'
	This.Object.p_6.Border = '0'
	This.Object.p_7.Border = '0'
	This.Object.p_8.Border = '0'
	This.Object.p_9.Border = '0'
//ELSEIF ll_x >= 1431 AND ll_x <= (1431+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//초기메뉴
ElseIf LEFT(ls_object, 3) = 'p_2' Then
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border	= "6"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "0"	
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '0'
	This.Object.p_2.Border = '6'
	This.Object.p_3.Border = '0'
	This.Object.p_4.Border = '0'
	This.Object.p_5.Border = '0'
	This.Object.p_6.Border = '0'
	This.Object.p_7.Border = '0'
	This.Object.p_8.Border = '0'
	This.Object.p_9.Border = '0'
//ELSEIF ll_x >= 1691 AND ll_x <= (1691+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//바로가기
ElseIf LEFT(ls_object, 3) = 'p_3' Then
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "6"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "0"
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '0'
	This.Object.p_2.Border = '0'
	This.Object.p_3.Border = '6'
	This.Object.p_4.Border = '0'
	This.Object.p_5.Border = '0'
	This.Object.p_6.Border = '0'
	This.Object.p_7.Border = '0'
	This.Object.p_8.Border = '0'
	This.Object.p_9.Border = '0'
//ELSEIF ll_x >= 2016 AND ll_x <= (2016+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//경영정보
ElseIf LEFT(ls_object, 3) = 'p_4' Then
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "6"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "0"
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '0'
	This.Object.p_2.Border = '0'
	This.Object.p_3.Border = '0'
	This.Object.p_4.Border = '6'
	This.Object.p_5.Border = '0'
	This.Object.p_6.Border = '0'
	This.Object.p_7.Border = '0'
	This.Object.p_8.Border = '0'
	This.Object.p_9.Border = '0'
//ELSEIF ll_x >= 2295 AND ll_x <= (2295+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//회계
ElseIf LEFT(ls_object, 3) = 'p_5' Then
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "6"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "0"
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '0'
	This.Object.p_2.Border = '0'
	This.Object.p_3.Border = '0'
	This.Object.p_4.Border = '0'
	This.Object.p_5.Border = '6'
	This.Object.p_6.Border = '0'
	This.Object.p_7.Border = '0'
	This.Object.p_8.Border = '0'
	This.Object.p_9.Border = '0'
//ELSEIF ll_x >= 2551 AND ll_x <= (2551+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//인사
ElseIf LEFT(ls_object, 3) = 'p_6' Then
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "6"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "0"
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '0'
	This.Object.p_2.Border = '0'
	This.Object.p_3.Border = '0'
	This.Object.p_4.Border = '0'
	This.Object.p_5.Border = '0'
	This.Object.p_6.Border = '6'
	This.Object.p_7.Border = '0'
	This.Object.p_8.Border = '0'
	This.Object.p_9.Border = '0'
//ELSEIF ll_x >= 2802 AND ll_x <= (2802+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//물류
ElseIf LEFT(ls_object, 3) = 'p_7' Then
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "6"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "0"
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '0'
	This.Object.p_2.Border = '0'
	This.Object.p_3.Border = '0'
	This.Object.p_4.Border = '0'
	This.Object.p_5.Border = '0'
	This.Object.p_6.Border = '0'
	This.Object.p_7.Border = '6'
	This.Object.p_8.Border = '0'
	This.Object.p_9.Border = '0'
//ELSEIF ll_x >= 3067 AND ll_x <= (3067+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//시스템
ElseIf LEFT(ls_object, 3) = 'p_8' Then
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "6"
//	This.Object.t_out.Border 	= "0"
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '0'
	This.Object.p_2.Border = '0'
	This.Object.p_3.Border = '0'
	This.Object.p_4.Border = '0'
	This.Object.p_5.Border = '0'
	This.Object.p_6.Border = '0'
	This.Object.p_7.Border = '0'
	This.Object.p_8.Border = '6'
	This.Object.p_9.Border = '0'
//ELSEIF ll_x >= 3383 AND ll_x <= (3383+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//로그아웃
ElseIf LEFT(ls_object, 3) = 'p_9' Then
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "6"
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '0'
	This.Object.p_2.Border = '0'
	This.Object.p_3.Border = '0'
	This.Object.p_4.Border = '0'
	This.Object.p_5.Border = '0'
	This.Object.p_6.Border = '0'
	This.Object.p_7.Border = '0'
	This.Object.p_8.Border = '0'
	This.Object.p_9.Border = '6'
//ELSEIF ll_x >= 3699 AND ll_x <= (3699+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//help
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "0"
//	This.Object.t_help.Border 	= "6"
ELSE
//	This.Object.t_grp.Border 	= "0"
//	This.Object.t_menu.Border 	= "0"
//	This.Object.t_fav.Border 	= "0"
//	This.Object.t_acc.Border 	= "0"
//	This.Object.t_per.Border 	= "0"
//	This.Object.t_prd.Border 	= "0"
//	This.Object.t_com.Border 	= "0"
//	This.Object.t_sys.Border 	= "0"
//	This.Object.t_out.Border 	= "0"
//	This.Object.t_help.Border 	= "0"
	This.Object.p_g.Border = '0'
	This.Object.p_2.Border = '0'
	This.Object.p_3.Border = '0'
	This.Object.p_4.Border = '0'
	This.Object.p_5.Border = '0'
	This.Object.p_6.Border = '0'
	This.Object.p_7.Border = '0'
	This.Object.p_8.Border = '0'
	This.Object.p_9.Border = '0'
END IF

Return 0
end event

event ue_lbuttondown;String ls_Object

Long	ll_x, ll_y

ls_Object = Lower(This.GetObjectAtPointer())

ll_x = This.PointerX()
ll_y = This.PointerY()

IF LEFT(ls_object, 3) = 'p_g' THEN	//그룹웨어
	IF gs_grpgbn = 'N' THEN Return
	This.Object.p_g.Border = '5'
ELSEIF LEFT(ls_object, 3) = 'p_2' THEN	//초기메뉴
	This.Object.p_2.Border = '5'
ELSEIF LEFT(ls_object, 3) = 'p_3' THEN	//바로가기
	This.Object.p_3.Border = '5'
ELSEIF LEFT(ls_object, 3) = 'p_4' THEN	//경영정보
	This.Object.p_4.Border = '5'	
ELSEIF LEFT(ls_object, 3) = 'p_5' THEN	//회계
	This.Object.p_5.Border = '5'
ELSEIF LEFT(ls_object, 3) = 'p_6' THEN	//인사
	This.Object.p_6.Border = '5'
ELSEIF LEFT(ls_object, 3) = 'p_7' THEN	//물류
	This.Object.p_7.Border = '5'
ELSEIF LEFT(ls_object, 3) = 'p_8' THEN	//시스템
	This.Object.p_8.Border = '5'
ELSEIF LEFT(ls_object, 3) = 'p_9' THEN	//로그아웃
	This.Object.p_9.Border = '5'
//ELSEIF ll_x >= 3699 AND ll_x <= (3699+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//help
//	This.Object.t_help.Border = "5"
END IF

//IF ll_x >= 1120 AND ll_x <= (1120+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//그룹웨어
//	IF gs_grpgbn = 'N' THEN Return
//	This.Object.t_grp.Border = "5"
//ELSEIF ll_x >= 1435 AND ll_x <= (1435+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//초기메뉴
//	This.Object.t_menu.Border = "5"	
//ELSEIF ll_x >= 1691 AND ll_x <= (1691+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//바로가기
//	This.Object.t_fav.Border = "5"
//ELSEIF ll_x >= 2016 AND ll_x <= (2016+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//경영정보
//	This.Object.t_com.Border = "5"	
//ELSEIF ll_x >= 2295 AND ll_x <= (2295+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//회계
//	This.Object.t_acc.Border = "5"
//ELSEIF ll_x >= 2551 AND ll_x <= (2551+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//인사
//	This.Object.t_per.Border = "5"
//ELSEIF ll_x >= 2802 AND ll_x <= (2802+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//물류
//	This.Object.t_prd.Border = "5"
//ELSEIF ll_x >= 3067 AND ll_x <= (3067+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//시스템
//	This.Object.t_sys.Border = "5"
//ELSEIF ll_x >= 3383 AND ll_x <= (3383+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//로그아웃
//	This.Object.t_out.Border = "5"
//ELSEIF ll_x >= 3699 AND ll_x <= (3699+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//help
//	This.Object.t_help.Border = "5"
//END IF
end event

event ue_lbuttonup;String ls_Object

Long	ll_x, ll_y

ls_Object = Lower(This.GetObjectAtPointer())

ll_x = This.PointerX()
ll_y = This.PointerY()

IF LEFT(ls_object, 3) = 'p_g' THEN	//그룹웨어
	IF gs_grpgbn = 'N' THEN Return
	This.Object.p_g.Border = '6'
ELSEIF LEFT(ls_object, 3) = 'p_2' THEN	//초기메뉴
	This.Object.p_2.Border = '6'
ELSEIF LEFT(ls_object, 3) = 'p_3' THEN	//바로가기
	This.Object.p_3.Border = '6'
ELSEIF LEFT(ls_object, 3) = 'p_4' THEN	//경영정보
	This.Object.p_4.Border = '6'	
ELSEIF LEFT(ls_object, 3) = 'p_5' THEN	//회계
	This.Object.p_5.Border = '6'
ELSEIF LEFT(ls_object, 3) = 'p_6' THEN	//인사
	This.Object.p_6.Border = '6'
ELSEIF LEFT(ls_object, 3) = 'p_7' THEN	//물류
	This.Object.p_7.Border = '6'
ELSEIF LEFT(ls_object, 3) = 'p_8' THEN	//시스템
	This.Object.p_8.Border = '6'
ELSEIF LEFT(ls_object, 3) = 'p_9' THEN	//로그아웃
	This.Object.p_9.Border = '6'
//ELSEIF ll_x >= 3699 AND ll_x <= (3699+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//help
//	This.Object.t_help.Border = "6"
END IF

//IF ll_x >= 1120 AND ll_x <= (1120+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//그룹웨어
//	IF gs_grpgbn = 'N' THEN Return
//	This.Object.t_grp.Border = "6"
//ELSEIF ll_x >= 1431 AND ll_x <= (1431+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//초기메뉴
//	This.Object.t_menu.Border = "6"	
//ELSEIF ll_x >= 1691 AND ll_x <= (1691+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//바로가기
//	This.Object.t_fav.Border = "6"
//ELSEIF ll_x >= 2016 AND ll_x <= (2016+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//경영정보
//	This.Object.t_com.Border = "6"	
//ELSEIF ll_x >= 2295 AND ll_x <= (2295+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//회계
//	This.Object.t_acc.Border = "6"
//ELSEIF ll_x >= 2551 AND ll_x <= (2551+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//인사
//	This.Object.t_per.Border = "6"
//ELSEIF ll_x >= 2802 AND ll_x <= (2802+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//물류
//	This.Object.t_prd.Border = "6"
//ELSEIF ll_x >= 3067 AND ll_x <= (3067+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//시스템
//	This.Object.t_sys.Border = "6"
//ELSEIF ll_x >= 3383 AND ll_x <= (3383+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//로그아웃
//	This.Object.t_out.Border = "6"
//ELSEIF ll_x >= 3699 AND ll_x <= (3699+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//help
//	This.Object.t_help.Border = "6"
//END IF
end event

event clicked;//Choose Case dwo.name
//	Case 't_menu'
//		IF gs_grpgbn = 'N' THEN 
//			w_erp_menu.SetFocus()
//		ELSE
//			w_grp_menu.SetFocus()
//			w_grp_menu.wf_workcrew_gyul(gs_userid)
//			w_grp_menu.wf_mail_cnt(gs_userid)
//			w_grp_menu.dw_bbs.Retrieve()
//		END IF
//		
//	Case 't_fav'
//		This.Object.t_fav.Border = "5"
//		wf_menu_create(5)
//		This.Object.t_fav.Border = "0"
//		
//	Case 't_prd'
//		This.Object.t_prd.Border = "5"
//		wf_menu_create(3)
//		This.Object.t_prd.Border = "0"
//		
//	Case 't_sys'
//		This.Object.t_sys.Border = "5"
//		wf_menu_create(4)
//		This.Object.t_sys.Border = "0"
//		
//	Case 't_out'
//		IF MessageBox('확인', '로그오프 하시겠습니까?', Question!, YesNo!) = 1 THEN
//			
//			/* 전체내역을 삭제 */
//			long tvi_hdl = 0
//			
//			SetNull(gs_empno)
//			SetNull(gs_dept)
//			SetNull(gs_UserId)
//			SetNull(gs_saupj)
//			SetNull(gs_sabu)	
//			
//			IF gs_grpgbn = 'Y' THEN
//				Close(w_grp_menu)
//			ELSE
//				Close(w_erp_menu)
//			END IF
//			
//			Parent.TriggerEvent("ue_open")
//	
//		END IF
//End Choose

String ls_Object, ls_fullpath, ls_eis_path, ls_user_gubun, ls_path

Long	ll_x, ll_y

ls_Object = Lower(This.GetObjectAtPointer())

ll_x = This.PointerX()
ll_y = This.PointerY()

window lw_first, lw_next, lw_active, lw_tmp, lw_window
String	ls_f, ls_n
//IF ll_x >= 1120 AND ll_x <= (1120+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//그룹웨어
If LEFT(ls_object, 3) = 'p_g' Then
	IF gs_grpgbn = 'N' THEN Return
//	This.Object.t_grp.Border = "5"
	This.Object.p_g.Border = '5'
	
	select  dataname into :ls_path from syscnfg where sysgu = 'W' and  serial = 1 and lineno = '6' ;
//	ls_fullpath = "HTTP://"+ls_path+"/WBCGI/WBAuthPass.asp?userid="+Lower(gs_userid)+"&password="+Lower(gs_PassWord)
//	ls_fullpath = "http://"+gs_path+"/WBCGI/WBLogin.aspx?userid="+'admin'+"%26password="+'sknam'
//	ls_fullpath = "http://"+gs_path+"/WBCGI/WBAuthPass.asp?userid="+'admin'+"&password="+'sknam'
	ls_fullpath = "http://"+ls_path+"/WBCGI/WBLogin.aspx?IsAction=1&UserId_auto="+Lower(gs_userid) //+" &password="+Lower(gs_PassWord)
	sle_addr.text = ls_fullpath
	sle_addr.PostEvent(Modified!)
//ELSEIF ll_x >= 1431 AND ll_x <= (1431+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//초기메뉴
ElseIf LEFT(ls_object, 3) = 'p_2' Then
	IF gs_grpgbn = 'N' THEN 
		w_erp_menu.SetFocus()
	ELSE
		w_grp_menu.SetFocus()
		w_grp_menu.wf_workcrew_gyul(gs_userid)
		w_grp_menu.wf_mail_cnt(gs_userid)
		w_grp_menu.dw_bbs.Retrieve()
	END IF
//ELSEIF ll_x >= 1691 AND ll_x <= (1691+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//바로가기
ElseIf LEFT(ls_object, 3) = 'p_3' Then
//	This.Object.t_fav.Border = "5"
	This.Object.p_3.Border = '5'
	wf_menu_create(5)
//	This.Object.t_fav.Border = "0"
	This.Object.p_3.Border = '0'
//ELSEIF ll_x >= 2016 AND ll_x <= (2016+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//경영정보
ElseIf LEFT(ls_object, 3) = 'p_4' Then

//	This.Object.t_com.Border = "5"
	This.Object.p_4.Border = '5'

	Select USER_GUBUN
	Into :ls_user_gubun
	From login_t
	where l_userid =:gs_userid;
	
	If ls_user_gubun = 'EIS' Then

	   SELECT "DATANAME"  
   	 INTO :ls_eis_path
	    FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU"  = 'W'  ) AND  
      	   ( "SYSCNFG"."SERIAL" =  1   ) AND  
         	( "SYSCNFG"."LINENO" =  '8' )   ;
	
		ls_eis_path = 'explorer http://' + ls_eis_path
	
		Run(ls_eis_path)
	Else
		MessageBox('확인','경영정보를 볼수 있는 권한이 없습니다.')
	End If
	
//	wf_menu_create(6)
//	This.Object.t_com.Border = "0"	
	This.Object.p_4.Border = '0'
//ELSEIF ll_x >= 2295 AND ll_x <= (2295+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//회계
ElseIf LEFT(ls_object, 3) = 'p_5' Then
//	This.Object.t_acc.Border = "5"
	This.Object.p_5.Border = '5'
	wf_menu_create(1)
//	This.Object.t_acc.Border = "0"
	This.Object.p_5.Border = '0'
//ELSEIF ll_x >= 2551 AND ll_x <= (2551+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//인사
ElseIf LEFT(ls_object, 3) = 'p_6' Then
//	This.Object.t_per.Border = "5"
	This.Object.p_6.Border = '5'
	wf_menu_create(2)
//	This.Object.t_per.Border = "0"
	This.Object.p_6.Border = '0'
//ELSEIF ll_x >= 2802 AND ll_x <= (2802+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//물류
ElseIf LEFT(ls_object, 3) = 'p_7' Then
//	This.Object.t_prd.Border = "5"
	This.Object.p_7.Border = '5'
	wf_menu_create(3)
//	This.Object.t_prd.Border = "0"
	This.Object.p_7.Border = '0'
//ELSEIF ll_x >= 3067 AND ll_x <= (3067+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//시스템
ElseIf LEFT(ls_object, 3) = 'p_8' Then
//	This.Object.t_sys.Border = "5"
	This.Object.p_8.Border = '5'
	wf_menu_create(4)
//	This.Object.t_sys.Border = "0"
	This.Object.p_8.Border = '0'
//ELSEIF ll_x >= 3383 AND ll_x <= (3383+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//로그아웃
ElseIf LEFT(ls_object, 3) = 'p_9' Then
	
	IF MessageBox('확인', '로그오프 하시겠습니까?', Question!, YesNo!) = 1 THEN
		String ls_ip
		  SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS')
			 INTO :ls_ip
			 FROM DUAL ;
		
		If Trim(ls_ip) = '' OR IsNull(ls_ip) Then
			  UPDATE IP_USER
				  SET DIS_DATE = TO_CHAR(SYSDATE, 'YYYYMMDD'),
						DIS_TIME = TO_CHAR(SYSDATE, 'HH24MISS')
				WHERE EMPNO  = :gs_empno
				  AND DIS_DATE IS NULL  ;
		Else
			  UPDATE IP_USER
				  SET DIS_DATE = TO_CHAR(SYSDATE, 'YYYYMMDD'),
						DIS_TIME = TO_CHAR(SYSDATE, 'HH24MISS')
				WHERE EMPNO  = :gs_empno
				  AND CON_IP = :ls_ip
				  AND DIS_DATE IS NULL  ;
		End If
			
		If SQLCA.SQLCODE = 0 Then
			COMMIT USING SQLCA;
		Else
			ROLLBACK USING SQLCA;
		End If
		
		/* 전체내역을 삭제 */
		long tvi_hdl = 0
		
		SetNull(gs_empno)
		SetNull(gs_dept)
		SetNull(gs_UserId)
		SetNull(gs_saupj)
		SetNull(gs_sabu)	
		
		IF gs_grpgbn = 'Y' THEN
			Close(w_grp_menu)
		ELSE
			Close(w_erp_menu)
		END IF
		
		Parent.TriggerEvent("ue_open")

	END IF	
//ELSEIF ll_x >= 3699 AND ll_x <= (3699+128) AND ll_y >= 52 AND ll_y <= (52+84) THEN	//HELP
// OpenSheetWithParm(lw_window, 'w_sys_help_010', 'w_sys_help_010', w_mdi_frame, 0, Layered!)
END IF

end event

type sle_msg from singlelineedit within w_mdi_frame
integer y = 1232
integer width = 457
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type lv_open_menu from listview within w_mdi_frame
integer x = 635
integer y = 260
integer width = 1422
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 29793924
boolean border = false
boolean showheader = false
boolean trackselect = true
boolean oneclickactivate = true
boolean underlinehot = true
listviewview view = listviewlist!
string largepicturename[] = {"Database!","DataWindow!"}
long largepicturemaskcolor = 536870912
string smallpicturename[] = {"Database!","DataWindow!"}
long smallpicturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event clicked;Long					ll_Parent, ll_Item, ll_rtn, ll_row
Boolean				lb_isopen
String				ls_window_id
Window				lw_window
ListViewItem		llvi_Current

If index <= 0 Then Return

If GetItem(index, llvi_Current) = -1 Then Return

ls_window_id = llvi_Current.Data

IF (ls_window_id <> "") THEN
	
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if Upper(ClassName(lw_window)) = ls_window_id then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	
	if lb_isopen then
		lw_window.windowstate = Normal!
		lw_window.SetFocus()
	end if
End if
end event

event getfocus;//---------------------------
//ii_itemx
integer li_index, li_len
String  sTitle
ListviewItem l_lvi


li_index = lv_open_menu.FindItem(0, DirectionAll!, True, False, False, False)

IF li_index = -1 THEN Return 0

If dw_listbar.RowCount() >= li_index Then
	sTitle = dw_listbar.GetItemString(li_index,'window_name')
	//풍선도움말 길이 
	li_len = Len(sTitle)
	st_bubble.width = li_len*32
	
	if li_index < 7 then
		st_bubble.x = w_mdi_frame.PointerX()
	else
		st_bubble.x = w_mdi_frame.PointerX() - li_len*32
	end if
	st_bubble.y = 350 //w_mdi_frame.PointerY() + lv_open_menu.Height
	//---------------------------------------------------------------------------------
	st_bubble.text = sTitle
	st_bubble.visible = True
	st_bubble.SetFocus()
End If
end event

