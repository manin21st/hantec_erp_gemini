$PBExportHeader$w_process_00010.srw
$PBExportComments$업무Flow
forward
global type w_process_00010 from window
end type
type cb_1 from commandbutton within w_process_00010
end type
type ddlb_1 from dropdownlistbox within w_process_00010
end type
type dw_1 from datawindow within w_process_00010
end type
end forward

global type w_process_00010 from window
integer width = 4635
integer height = 2452
boolean titlebar = true
string title = "Process"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
ddlb_1 ddlb_1
dw_1 dw_1
end type
global w_process_00010 w_process_00010

type variables
string isname, istag
Boolean ib_any_typing     
String	is_window_id
String     is_today              //시작일자
String     is_totime             //시작시간
String     sModStatus
String     is_usegub           //이력관리 여부

/* 이미지 저장 */
Windowobject winobject[]
String is_picutre[]
String is_picutername_base[]
String is_picutername_on[]
end variables

forward prototypes
public function integer wf_menu_create (string arg_window)
end prototypes

public function integer wf_menu_create (string arg_window);/***********************************************************************
	드롭다운 매뉴를 생성한다.
	리턴값 : 없음
************************************************************************/

m_main	 lm_Menu
m_dynamic lm_Add_Menu
Long      ll_Rows, ll_Row
Integer   li_root = 1, li_2 = 0, li_3 = 0, i, iw=0
String    ls_name, ls_where
Datastore ds

ds = create datastore
ds.dataobject = 'd_process_menu'
ds.settransobject(sqlca)
if ds.retrieve(gs_userid, arg_window) < 1 then
	destroy ds	
	return -1
end if

lm_Menu = Create m_main
	
ll_Rows = ds.rowcount()
ll_Row = 1 

li_2 = 0
li_3 = 0

Do While ll_Row <= ll_Rows
	li_root += 1
	
	lm_Add_Menu = Create m_dynamic
	ls_name = ds.GetItemString( ll_Row, 'sub2_name_1' )
	lm_Add_Menu.item[1].Text = ls_name
	lm_Add_Menu.item[1].Tag = Left(ls_name, 4 )			
	lm_Add_Menu.is_window = ds.GetItemString( ll_Row, 'c_window' )
	lm_Menu.Item[li_root] = lm_Add_Menu.Item[1]
	
	ll_Row += 1 
Loop

lm_Menu.Hide()
lm_Menu.Show()

lm_Menu.PopMenu(PointerX(),PointerY())

destroy ds

return 1
end function

on w_process_00010.create
this.cb_1=create cb_1
this.ddlb_1=create ddlb_1
this.dw_1=create dw_1
this.Control[]={this.cb_1,&
this.ddlb_1,&
this.dw_1}
end on

on w_process_00010.destroy
destroy(this.cb_1)
destroy(this.ddlb_1)
destroy(this.dw_1)
end on

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


dw_1.insertrow(0)
end event

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

type cb_1 from commandbutton within w_process_00010
integer x = 4064
integer y = 4
integer width = 507
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Attention"
end type

event clicked;open(w_process_00010_menu)
end event

type ddlb_1 from dropdownlistbox within w_process_00010
integer width = 791
integer height = 880
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"(BIM) 기준정보 관리","(PLY) 년간계획 관리","(PLM) 월간계획 관리","(PLD) 주간계획 관리","(SAM) 영업 관리","(MFM) 생산 관리","(MTM) 자재 관리","(TQM) 품질 관리","(TQE) 계측기 관리","(FMM) 생산기술 관리","(DMM) 개발 관리"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;String sname, sdname

sname  = ddlb_1.text
//sdname = 'd_' + mid(sname, 2, 4)
sdname = 'd_' + mid(sname, 2, 3)

dw_1.dataobject = sdname
dw_1.insertrow(0)

end event

type dw_1 from datawindow within w_process_00010
event dwnmouse pbm_dwnmousemove
integer width = 4581
integer height = 2332
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dwnmouse;string swname, setname, swtag, settag, winname
integer ii

// 문자열 끝에 AAA1, AAA2, AAAn이 있으면 동일한 프로그램을 기술하기 위한
// 것이므로 Window-Name에서 삭제한다.
swname = string(dwo.name)
ii = pos(swname, 'aaa')
If ii > 0 then
	winname = Mid(swname, 1, ii - 1)
Else
	winname = swname
End if

if not isnull( isname ) or Trim( isname ) = '' then
	setname = isname + '.border = 0'
	modify(setname)				
End if
SetNull( isName)

if Left(swname, 2) = 'w_' or  Left(swname, 2) = 'd_' or Left(swname, 2) = 'wq' then
	
	setname = swname + '.border = 6'
	modify(setname)
	isName = swname
	
End if

if not isnull( istag ) or Trim( istag ) = '' then
	settag = istag + '.visible = 0'
	modify(settag)				
End if
SetNull( istag)
swtag = describe(swname + '.tag')
if  isnull( swtag ) OR Trim( swtag ) = '' OR swtag = '?' then
Else
	settag = swtag + '.visible = 1'
	modify(settag)
	istag = swtag
End if

end event

event clicked;String ls_window_id, spass
string swname, subname, setname
boolean lb_isopen
window lw_window

swname = string(dwo.name)
integer ii

// 문자열 끝에 AAA1, AAA2, AAAn이 있으면 동일한 프로그램을 기술하기 위한
// 것이므로 Window-Name에서 삭제한다.
ii = pos(swname, 'aaa')
If ii > 0 then
	ls_window_id = Mid(swname, 1, ii - 1)
Else
	ls_window_id = swname
End if

if Left(swname, 2) = 'w_' or Left(swname, 2) = 'wq' then
	
	Setpointer(Hourglass!)	
	
	setname = swname + '.border = 5'
	modify(setname)	
	
	Select sub2_name into :subname
	  From sub2_user_t
	 Where user_id = :gs_userid And window_name = :ls_window_id;
	
	If sqlca.sqlcode <> 0 then
		Setpointer(Arrow!)			
		MessageBox("권한부족", "사용권한이 없읍니다", stopsign!)
		return
	End if
	
	IF (ls_window_id <> "") THEN
		
		lb_isopen = FALSE
		lw_window = parent.GetFirstSheet()
		DO WHILE IsValid(lw_window)
			if ClassName(lw_window) = ls_window_id then
				lb_isopen = TRUE
				Exit
			else		
				lw_window = parent.GetNextSheet(lw_window)
			end if
		LOOP
		
		if lb_isopen then
			lw_window.windowstate = Normal!
			lw_window.SetFocus()
		else	
			
			SELECT "SUB2_T"."PASSWORD"  
			  INTO :sPass
			  FROM "SUB2_T"  
			 WHERE "SUB2_T"."WINDOW_NAME" = :ls_window_id ;
		
			IF sPass ="" OR IsNull(sPass) THEN
			ELSE
				OpenWithParm(W_PGM_PASS,spass)
				IF Message.StringParm = "CANCEL" THEN RETURN
			END IF		
			
			OpenSheet(lw_window, ls_window_id, w_mdi_frame, 0, Layered!)	
		end if
	End if
	
	Setpointer(Arrow!)	

Elseif Left(swname, 2) = 'd_' then
	this.dataobject = ls_window_id
	this.insertrow(0)
	
	ii = integer(mid(ls_window_id, 3, 3))
	ddlb_1.selectitem(ii)
End if;


end event

event rbuttondown;String ls_window_id, spass
string swname, subname, setname
boolean lb_isopen
window lw_window

swname = string(dwo.name)
integer ii, LL

// 문자열 끝에 AAA1, AAA2, AAAn이 있으면 동일한 프로그램을 기술하기 위한
// 것이므로 Window-Name에서 삭제한다.
ii = pos(swname, 'aaa')
If ii > 0 then
	ls_window_id = Mid(swname, 1, ii - 1)
Else
	ls_window_id = swname
End if

if Left(swname, 2) = 'w_' then
	

	IF (ls_window_id <> "") THEN 
		ll = wf_menu_create(ls_window_id)
		If ll = -1 then
			Messagebox("관련메뉴", "관련메뉴가 없읍니다", information!)
		End if
	End if
	
End if


end event

