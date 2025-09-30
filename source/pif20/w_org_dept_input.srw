$PBExportHeader$w_org_dept_input.srw
$PBExportComments$조직도 등록
forward
global type w_org_dept_input from window
end type
type p_deldept from uo_picture within w_org_dept_input
end type
type p_newdept from uo_picture within w_org_dept_input
end type
type cb_deldept from commandbutton within w_org_dept_input
end type
type cb_newdept from commandbutton within w_org_dept_input
end type
type cb_saveorg from commandbutton within w_org_dept_input
end type
type cb_openorg from commandbutton within w_org_dept_input
end type
type cb_connect2 from commandbutton within w_org_dept_input
end type
type cb_connect1 from commandbutton within w_org_dept_input
end type
type cb_newatom from commandbutton within w_org_dept_input
end type
type dw_emplist from datawindow within w_org_dept_input
end type
type st_vsplit from statictext within w_org_dept_input
end type
type dw_treedata from datawindow within w_org_dept_input
end type
type tv_org from treeview within w_org_dept_input
end type
type dw_child from datawindow within w_org_dept_input
end type
type tab_1 from tab within w_org_dept_input
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tab_1 from tab within w_org_dept_input
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type gb_s1 from groupbox within w_org_dept_input
end type
type p_newatom from uo_picture within w_org_dept_input
end type
type p_connect1 from uo_picture within w_org_dept_input
end type
type p_connect2 from uo_picture within w_org_dept_input
end type
type p_openorg from uo_picture within w_org_dept_input
end type
type p_saveorg from uo_picture within w_org_dept_input
end type
type p_exit from uo_picture within w_org_dept_input
end type
type dw_1 from datawindow within w_org_dept_input
end type
end forward

global type w_org_dept_input from window
integer x = 5
integer y = 136
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "조직도-입력"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 32106727
boolean toolbarvisible = false
toolbaralignment toolbaralignment = alignatleft!
event ue_append ( )
event ue_delete ( )
event ue_detail ( )
event ue_addroot ( )
event ue_refreshtree ( )
event ue_newatom ( )
event ue_connect1 ( )
event ue_connect2 ( )
event ue_addemp ( )
event type boolean ue_openorg ( )
event ue_saveorg ( )
event ue_resetorg ( )
event ue_print ( )
event ue_open ( )
p_deldept p_deldept
p_newdept p_newdept
cb_deldept cb_deldept
cb_newdept cb_newdept
cb_saveorg cb_saveorg
cb_openorg cb_openorg
cb_connect2 cb_connect2
cb_connect1 cb_connect1
cb_newatom cb_newatom
dw_emplist dw_emplist
st_vsplit st_vsplit
dw_treedata dw_treedata
tv_org tv_org
dw_child dw_child
tab_1 tab_1
gb_s1 gb_s1
p_newatom p_newatom
p_connect1 p_connect1
p_connect2 p_connect2
p_openorg p_openorg
p_saveorg p_saveorg
p_exit p_exit
dw_1 dw_1
end type
global w_org_dept_input w_org_dept_input

type variables
treeviewitem	itvi_drag_object
integer	ii_thickness = 22
menu	im_pop

String	is_Emp_Cd
w_org_dept_detail	iw_detail
String	is_Authority

String	is_org_cd


String print_gu                 //window가 조회인지 인쇄인지  

String     is_today            //시작일자
String     is_totime           //시작시간
String     is_window_id    //윈도우 ID
String     is_usegub         //이력관리 여부
String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false



String     sModStatus

char c_status

// 자료변경여부 검사
boolean  ib_any_typing
end variables

forward prototypes
public function long of_add_level (string as_data, string as_label, long al_parent)
public function long of_refresh_item (long al_handle)
public function long of_add_item (string as_data, string as_label, long al_parent)
public subroutine wf_get_image (datawindow fdw)
end prototypes

event ue_append;Window	lw_to_open
String		ls_parm, ls_orgcode
Long		ll_handle
treeviewitem	ltvi_current

ll_handle = tv_org.FindItem(CurrentTreeItem!, 0)
tv_org.GetItem(ll_handle, ltvi_current)
ls_orgcode = String(ltvi_current.Data)

ls_parm = "##ADD##~t"
//ls_parm += "19990101~t"
ls_parm += ls_orgcode

//String	ls_new_code
//ls_new_code = f_strip_0(ls_orgcode)
//
//
//Messagebox('ls_new_code', ls_new_code)
//Messagebox('ls_new_code', left(ls_orgcode, len(ls_new_code)))
//
//Select 

OpenWithParm(lw_to_open, ls_parm, "w_org_dept_input_add")
ls_parm = Message.StringParm
If ls_parm = "##OK##" Then
	ll_handle = tv_org.FindItem(CurrentTreeItem!, 0)
	of_refresh_item(ll_handle)
End If
end event

event ue_delete;if dw_child.GetRow() > 0 then
	MessageBox('조직 삭제 불가', is_org_cd + '의 하위조직이 존재하여 삭제가 불가능합니다 !!!')
else
	if Messagebox('조직 삭제 확인', is_org_cd + '을 삭제하시겠습니까?', Exclamation!, YesNo!, 2) = 1 Then
		Delete From "P0_DEPT_EMP"
		 Where "ORG_CD" = :is_org_cd ;

		Delete From "P0_ORG_DEPT"
		 Where "ORG_CD" = :is_org_cd ;
		Commit ;
		Event ue_refreshtree()
	end if
end if

end event

event ue_detail;Window		lw_to_open
String			ls_parm
Long			ll_handle
treeviewitem	ltvi_current
String			ls_orgcode

ll_handle = tv_org.FindItem(CurrentTreeItem!, 0)
tv_org.GetItem(ll_handle, ltvi_current)
ls_orgcode = String(ltvi_current.Data)

ls_parm = "##EDIT##~t"
//ls_parm += "19990101~t"
ls_parm += ls_orgcode

OpenWithParm(lw_to_open, ls_parm, "w_org_dept_input_add")
ls_parm = Message.StringParm
If ls_parm = "##OK##" Then
	ll_handle = tv_org.FindItem(CurrentTreeItem!, 0)
	of_refresh_item(ll_handle)
End If

Post Event ue_refreshtree()
end event

event ue_addroot;Window	lw_to_open
String		ls_parm
//, ls_orgcode
//Long		ll_handle
//treeviewitem	ltvi_current

MessageBox("조직도", "자료가 없습니다. 회사정보를 먼저 입력하셔야 합니다.")

//ll_handle = tv_org.FindItem(CurrentTreeItem!, 0)
//tv_org.GetItem(ll_handle, ltvi_current)
//ls_orgcode = String(ltvi_current.Data)

ls_parm = "##ROOT##~t"
ls_parm += "000000"

OpenWithParm(lw_to_open, ls_parm, "w_org_dept_input_add")
ls_parm = Message.StringParm
If ls_parm = "##OK##" Then
//	ll_handle = tv_org.FindItem(CurrentTreeItem!, 0)
	Event ue_refreshtree()
//	of_refresh_item(ll_handle)
Else
	Post Close(This)
	Return
End If
end event

event ue_refreshtree;String	ls_rootname
Long	ll_tophandle

tv_org.DeleteItem(0)

Select "ORG_NM"
  Into :ls_rootname
  From "P0_ORG_DEPT"
 Where "ORG_CD" = '000000' ;

Choose Case SQLCA.SQLCode
	Case 0
		ll_tophandle = of_add_level("000000", ls_rootname, 0)
		tv_org.SelectItem(ll_tophandle)
		tv_org.ExpandItem(tv_org.FindItem(RootTreeItem!, 0))
	Case 100
		// 없음 - 초기화 요망
		Post Event ue_addroot()
	Case -1
		MessageBox("인사급여 시스템 오류", "조직도 테이블에 오류가 있습니다.", StopSign!)
		Post Close(This)
		Return
End Choose
end event

event ue_newatom;iw_detail.Event Dynamic ue_newatom()
end event

event ue_connect1;iw_detail.Event Dynamic ue_connect1()
end event

event ue_connect2;iw_detail.Event Dynamic ue_connect2()
end event

event ue_addemp;iw_detail.Event Dynamic ue_addemp()
end event

event type boolean ue_openorg();if iw_detail.ib_chabged = true then
	choose case messagebox('데이타 변경 확인', '조직도가 변경되었습니다.~r~n~r~n저장하시겠습니까?', question!, yesnocancel!, 1)
		case 1
			iw_detail.event dynamic ue_saveorg()
		case 2

		case 3
			return false
	end choose		
end if

iw_detail.Event Dynamic ue_openorg()

return true


end event

event ue_saveorg;iw_detail.Event Dynamic ue_saveorg()
end event

event ue_resetorg;iw_detail.Event Dynamic ue_resetorg()
end event

event ue_print;Long	ll_printjob

ll_printjob = PrintOpen( )
iw_detail.Print(ll_printjob, 100, 200)
PrintClose(ll_printjob)

//Open(w_org_pmis_print, This)
// ll_printjob = PrintOpen( )
//w_org_pmis_print.Print(ll_printjob, 100, 200)
//PrintClose(ll_printjob)
//Close(w_org_pmis_print)
end event

event ue_open();dw_emplist.SetTransObject(SQLCA)
dw_treedata.SetTransObject(SQLCA)
dw_child.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

Post Event ue_refreshtree()

iw_detail.Move(dw_child.X, dw_child.Y)
iw_detail.Dynamic wf_set_windowmode('I')
iw_detail.Dynamic Post wf_set_empdw(dw_emplist)
end event

public function long of_add_level (string as_data, string as_label, long al_parent);Long				ll_NewItem
Long				ll_row, ll_rowcount
TreeViewItem		ltvi_Item
String				ls_org_cd[], ls_org_nm[]

ll_newitem = of_add_item(as_data, as_label, al_parent)
ll_rowcount = dw_treedata.Retrieve(as_data)
For ll_row = 1 To ll_rowcount
	ls_org_cd[ll_row] = dw_treedata.object.org_cd[ll_row]
	ls_org_nm[ll_row] = dw_treedata.object.org_nm[ll_row]
Next
For ll_row = 1 To ll_rowcount
	of_add_level(ls_org_cd[ll_row], ls_org_nm[ll_row], ll_newitem)
Next

Return ll_newitem
end function

public function long of_refresh_item (long al_handle);Long	ll_parenthandle, ll_newhandle
String	ls_orgcode, ls_orgname
treeviewitem	ltvi_current

tv_org.GetItem(al_handle, ltvi_current)
ls_orgcode = String(ltvi_current.Data)
ls_orgname = String(ltvi_current.Label)

If al_handle = tv_org.FindItem(RootTreeItem!, 0) Then
	ll_parenthandle = 0
Else
	ll_parenthandle = tv_org.FindItem(ParentTreeItem!, al_handle)			
End If

tv_org.DeleteItem(al_handle)

ll_newhandle = of_add_level(ls_orgcode, ls_orgname, ll_parenthandle)
tv_org.SelectItem(ll_newhandle)
tv_org.ExpandItem(ll_newhandle)

Return 1
end function

public function long of_add_item (string as_data, string as_label, long al_parent);// Add a entry to the TreeView
Long				ll_NewItem
TreeViewItem		ltvi_Item

// Add an item to the TreeView
ltvi_Item.Data = as_data
ltvi_Item.Label = as_label
If al_Parent = 0 Then
	ltvi_Item.PictureIndex = 1
	ltvi_Item.SelectedPictureIndex = 1
Else
	ltvi_Item.PictureIndex = 2
	ltvi_Item.SelectedPictureIndex = 3
End If
ll_NewItem = tv_org.InsertItemLast(al_Parent, ltvi_Item)

Return ll_NewItem
end function

public subroutine wf_get_image (datawindow fdw);blob imagedata
int li_FileNum
String ls_filename, sempno, sname
int i, lrow
blob{0} bzero

For i = 1 to fdw.rowcount() 
	sempno = fdw.GetitemString(i,'empno')
   lrow = f_get_pic(gs_picpath,sempno)
Next

end subroutine

on w_org_dept_input.create
this.p_deldept=create p_deldept
this.p_newdept=create p_newdept
this.cb_deldept=create cb_deldept
this.cb_newdept=create cb_newdept
this.cb_saveorg=create cb_saveorg
this.cb_openorg=create cb_openorg
this.cb_connect2=create cb_connect2
this.cb_connect1=create cb_connect1
this.cb_newatom=create cb_newatom
this.dw_emplist=create dw_emplist
this.st_vsplit=create st_vsplit
this.dw_treedata=create dw_treedata
this.tv_org=create tv_org
this.dw_child=create dw_child
this.tab_1=create tab_1
this.gb_s1=create gb_s1
this.p_newatom=create p_newatom
this.p_connect1=create p_connect1
this.p_connect2=create p_connect2
this.p_openorg=create p_openorg
this.p_saveorg=create p_saveorg
this.p_exit=create p_exit
this.dw_1=create dw_1
this.Control[]={this.p_deldept,&
this.p_newdept,&
this.cb_deldept,&
this.cb_newdept,&
this.cb_saveorg,&
this.cb_openorg,&
this.cb_connect2,&
this.cb_connect1,&
this.cb_newatom,&
this.dw_emplist,&
this.st_vsplit,&
this.dw_treedata,&
this.tv_org,&
this.dw_child,&
this.tab_1,&
this.gb_s1,&
this.p_newatom,&
this.p_connect1,&
this.p_connect2,&
this.p_openorg,&
this.p_saveorg,&
this.p_exit,&
this.dw_1}
end on

on w_org_dept_input.destroy
destroy(this.p_deldept)
destroy(this.p_newdept)
destroy(this.cb_deldept)
destroy(this.cb_newdept)
destroy(this.cb_saveorg)
destroy(this.cb_openorg)
destroy(this.cb_connect2)
destroy(this.cb_connect1)
destroy(this.cb_newatom)
destroy(this.dw_emplist)
destroy(this.st_vsplit)
destroy(this.dw_treedata)
destroy(this.tv_org)
destroy(this.dw_child)
destroy(this.tab_1)
destroy(this.gb_s1)
destroy(this.p_newatom)
destroy(this.p_connect1)
destroy(this.p_connect2)
destroy(this.p_openorg)
destroy(this.p_saveorg)
destroy(this.p_exit)
destroy(this.dw_1)
end on

event open;
String		ls_rootname

is_Authority = Message.StringParm

ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

is_window_id = Upper(this.ClassName())
is_today = f_today()
is_totime = f_totime()
w_mdi_frame.st_window.Text = is_window_id

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

//dw_datetime.InsertRow(0)

//f_change_menu(This, "org")
im_pop = Create Using "m_dept_diagram_popup"
Open(iw_detail, "w_org_dept_detail", This)

Post Event ue_open()





end event

event close;//if isvalid(gv_env.mdi_main) then timer(.5, gv_env.mdi_main)

end event

event mousedown;If flags = 1 Then
	If xpos >= tv_org.X + tv_org.Width And xpos <= tv_org.X + tv_org.Width + ii_thickness Then
		Pointer = "SizeWE!"
		tv_org.Pointer = "SizeWE!"
		dw_child.object.datawindow.Pointer = "SizeWE!"
		tab_1.Pointer = "SizeWE!"
		st_vsplit.Show()
		tv_org.SetPosition(ToBottom!)
		dw_child.SetPosition(ToBottom!)
		tab_1.SetPosition(ToBottom!)
		tab_1.tabpage_1.SetPosition(ToBottom!)
		tab_1.tabpage_2.SetPosition(ToBottom!)
	End If
End If
end event

event mousemove;If flags = 0 Then
	If xpos >= tv_org.X + tv_org.Width And xpos <= dw_child.X Then
//		dw_list.object.datawindow.Pointer = "SizeWE!"
//		tv_org.Pointer = "SizeWE!"
		Pointer = "SizeWE!"
	Else
		dw_child.object.datawindow.Pointer = "Arrow!"
		tv_org.Pointer = "Arrow!"
		Pointer = "Arrow!"
	End If
End If

If flags = 1 And Pointer = "SizeWE!" Then
	If xpos > 900 And xpos <= 2100 Then
		st_vsplit.X = xpos
	End If
End If
end event

event mouseup;If flags = 0 Then
	If Pointer = "SizeWE!" Then
//		gw_mdi_main.SetRedraw(False)
		tv_org.Width = st_vsplit.X - 11 - tv_org.X
//		dw_child.X = st_vsplit.X + 11
//		dw_child.Width = This.WorkSpaceWidth() - (tv_org.X * 2) - tv_org.Width - ii_thickness
		tab_1.X = st_vsplit.X + 11
		tab_1.Width = This.WorkSpaceWidth() - (tv_org.X * 2) - tv_org.Width - ii_thickness		
		Pointer = "Arrow!"
		tv_org.Pointer = "Arrow!"
		dw_child.object.datawindow.Pointer = "Arrow!"
		tab_1.Pointer = "Arrow!"
		st_vsplit.Hide()

		PostEvent(Resize!)
//		gw_mdi_main.SetRedraw(True)
	End If
End If
end event

event resize;tv_org.Height = newheight - 150
gb_s1.height  = tv_org.Height + 124

tab_1.Resize(WorkSpaceWidth() - (tv_org.X * 2) - tv_org.Width - ii_thickness, WorkSpaceHeight() - tab_1.Y - p_newdept.Y)

dw_child.Move(tab_1.X + 29, tab_1.Y + 106)
dw_child.Resize(tab_1.Width - 68, tab_1.Height - 136)

dw_emplist.Move(dw_child.X, dw_child.Y + (dw_child.Height - dw_emplist.Height))
dw_emplist.Width = dw_child.Width

if IsValid(iw_detail) then
	iw_detail.Move(tab_1.X + 29, tab_1.Y + 106)
	iw_detail.Resize(tab_1.Width - 68, tab_1.Height - 136 - dw_emplist.Height - 40)
end if

st_vsplit.Height = tv_org.Height + 100

end event

event activate;//if isvalid(gv_env.wm_menu) then
//	if gv_env.wm_menu.visible then gv_env.wm_menu.hide()
//end if
end event

event closequery;if iw_detail.ib_chabged = true then
	choose case messagebox('데이타 변경 확인', '조직도가 변경되었습니다.~r~n~r~n저장하시겠습니까?', question!, yesnocancel!, 1)
		case 1
			iw_detail.event dynamic ue_saveorg()
		case 2

		case 3
			return 1
	end choose		
end if

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

long li_index

li_index = w_mdi_frame.lv_open_menu.FindItem(0,This.Title, TRUE,TRUE)

w_mdi_frame.lv_open_menu.DeleteItem(li_index)
w_mdi_frame.st_window.Text = ""
end event

type p_deldept from uo_picture within w_org_dept_input
integer x = 773
integer y = 20
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\조직삭제_up.gif"
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;parent.event ue_delete()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조직삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조직삭제_dn.gif"
end event

type p_newdept from uo_picture within w_org_dept_input
integer x = 471
integer y = 20
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\신규하위조직_up.gif"
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;parent.event ue_append()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\신규하위조직_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\신규하위조직_dn.gif"
end event

type cb_deldept from commandbutton within w_org_dept_input
boolean visible = false
integer x = 539
integer y = 2856
integer width = 398
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "조직 삭제"
end type

event clicked;parent.event ue_delete()
end event

type cb_newdept from commandbutton within w_org_dept_input
boolean visible = false
integer x = 37
integer y = 2852
integer width = 480
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "신규 하위조직"
end type

event clicked;parent.event ue_append()
end event

type cb_saveorg from commandbutton within w_org_dept_input
boolean visible = false
integer x = 2779
integer y = 2888
integer width = 297
integer height = 92
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "조직저장"
end type

event clicked;parent.event ue_saveorg()
end event

type cb_openorg from commandbutton within w_org_dept_input
boolean visible = false
integer x = 2487
integer y = 2888
integer width = 297
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "조직읽기"
end type

event clicked;parent.event ue_openorg()
end event

type cb_connect2 from commandbutton within w_org_dept_input
boolean visible = false
integer x = 2190
integer y = 2888
integer width = 297
integer height = 92
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "독립연결"
end type

event clicked;parent.event ue_connect2()
end event

type cb_connect1 from commandbutton within w_org_dept_input
boolean visible = false
integer x = 1893
integer y = 2888
integer width = 297
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "하위연결"
end type

event clicked;parent.event ue_connect1()
end event

type cb_newatom from commandbutton within w_org_dept_input
boolean visible = false
integer x = 1522
integer y = 2860
integer width = 297
integer height = 92
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "새 개체"
end type

event clicked;parent.event ue_newatom()
end event

type dw_emplist from datawindow within w_org_dept_input
event ue_lbuttondown pbm_lbuttondown
integer x = 997
integer y = 1492
integer width = 3543
integer height = 764
integer taborder = 40
string dragicon = "WinLogo!"
string dataobject = "d_org_dept_member"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_lbuttondown;String	ls_clicked_info

if left(GetBandAtPointer(), 6) = 'detail' then
	//If Long(ls_clicked_info) > 0 And Long(ls_clicked_info) <= This.RowCount() Then
	if getrow() > 0 then
		drag(begin!)
	end if
end if

end event

event constructor;Hide()
Post SelectRow(1, True)
end event

event rowfocuschanged;SelectRow(0, False)
SelectRow(currentrow, True)
end event

type st_vsplit from statictext within w_org_dept_input
integer x = 1134
integer width = 5
integer height = 1988
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
fillpattern fillpattern = horizontal!
boolean focusrectangle = false
end type

event constructor;Hide()
end event

type dw_treedata from datawindow within w_org_dept_input
integer x = 1929
integer y = 608
integer width = 521
integer height = 208
integer taborder = 20
string dataobject = "d_org_dept_tree"
boolean livescroll = true
end type

event constructor;Hide()
end event

type tv_org from treeview within w_org_dept_input
event ue_mousemove pbm_mousemove
event ue_mousedown pbm_lbuttondown
event ue_mouseup pbm_lbuttonup
integer x = 64
integer y = 192
integer width = 887
integer height = 2092
integer taborder = 10
boolean dragauto = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
boolean disabledragdrop = false
string picturename[] = {"CreateLibrary5!","OleGenReg!","NestedReturn!"}
integer picturewidth = 16
integer pictureheight = 16
long picturemaskcolor = 12632256
long statepicturemaskcolor = 553648127
end type

event ue_mousemove;Parent.Event mousemove(flags, Parent.PointerX(), Parent.PointerY())
end event

event ue_mousedown;Parent.Event mousedown(flags, Parent.PointerX(), Parent.PointerY())
end event

event ue_mouseup;Parent.Event mouseup(flags, Parent.PointerX(), Parent.PointerY())
end event

event begindrag;If handle = FindItem(RootTreeItem!, 0) Then
	Drag(Cancel!)
End If
This.GetItem(handle, itvi_drag_object)
end event

event dragdrop;TreeViewItem		ltv_temp, ltv_temp2
Long				ll_roothandle, ll_temphandle, ll_loopcount
String				ls_parent_cd_new, ls_org_cd

If is_Authority <> 'U' Then Return

If handle = itvi_drag_object.itemhandle Then
	Return
End If

ll_roothandle = FindItem(RootTreeItem!, handle)
If handle <> ll_roothandle Then
	ll_temphandle = FindItem(ParentTreeItem!, handle)
	Do While ll_temphandle <> ll_roothandle
		ll_loopcount ++
		If ll_loopcount = 500 Then
			MessageBox("이동 불가", "시스템 오류", StopSign!); Return
		End If
	
		If ll_temphandle = itvi_drag_object.itemhandle Then
			MessageBox("이동 불가", "자신의 하위 조직으로 이동할 수 없습니다.", StopSign!); Return
		End If
	
		ll_temphandle = FindItem(ParentTreeItem!, ll_temphandle)
	Loop
End If

This.GetItem(itvi_drag_object.itemhandle, ltv_temp)
This.GetItem(handle, ltv_temp2)
ls_org_cd = ltv_temp.data
ls_parent_cd_new = String(ltv_temp2.data)

UPDATE "TBL_ORG_DEPT"
	SET "ORG_CD_PARENT" = :ls_parent_cd_new
 WHERE "ORG_CD" = :ls_org_cd ;

If SQLCA.SQLCode = 0 Then
	COMMIT;
Else
	MessageBox("DB 오류", "조직도 자료를 저장할 수 없습니다!", StopSign!)
	ROLLBACK;
	Return
End If

of_add_level(itvi_drag_object.data, itvi_drag_object.label, handle)

This.DeleteItem(itvi_drag_object.itemhandle)
end event

event selectionchanged;TreeViewItem		ltvi_current
String	ls_dept_cd

If GetItem(newhandle, ltvi_current) = 1 Then
	is_org_cd = String(ltvi_current.Data)
	Select DEPT_CD
	  Into :ls_dept_cd
	  From P0_ORG_DEPT
	 Where ORG_CD = :is_org_cd ;

//	dw_child.Retrieve(is_org_cd, gv_env.setupdir)
   dw_child.Retrieve(is_org_cd)

	dw_emplist.Retrieve(ls_dept_cd, is_org_cd)
	dw_1.Retrieve(ls_dept_cd, is_org_cd)
	wf_get_image(dw_1)

	iw_detail.Dynamic wf_set_org_cd(is_org_cd)
	iw_detail.Dynamic Event ue_openorg()

End If

end event

event rightclicked;If handle >= 0 Then
	im_pop.item[2].Post PopMenu(w_mdi_frame.PointerX(), w_mdi_frame.PointerY())
End If
end event

event selectionchanging;if iw_detail.ib_chabged = true then
	choose case messagebox('데이타 변경 확인', '조직도가 변경되었습니다.~r~n~r~n저장하시겠습니까?', question!, yesnocancel!, 1)
		case 1
			iw_detail.event dynamic ue_saveorg()
		case 2

		case 3
			return 1
	end choose		
end if

end event

type dw_child from datawindow within w_org_dept_input
event ue_mousemove pbm_mousemove
event ue_mousedown pbm_lbuttondown
event ue_mouseup pbm_lbuttonup
integer x = 997
integer y = 184
integer width = 3538
integer height = 1984
integer taborder = 30
string dataobject = "d_org_dept_input"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;Parent.Event mousemove(flags, Parent.PointerX(), Parent.PointerY())
end event

event ue_mousedown;Parent.Event mousedown(flags, Parent.PointerX(), Parent.PointerY())
end event

event ue_mouseup;Parent.Event mouseup(flags, Parent.PointerX(), Parent.PointerY())
end event

event doubleclicked;Window		lw_to_open
String			ls_parm
Long			ll_handle

If is_Authority <> 'U' Then Return

If row > 0 Then
	ls_parm = "##EDIT##~t"
//	ls_parm += "19990101~t"
	ls_parm += GetItemString(row, "dept_cd_org")
	OpenWithParm(lw_to_open, ls_parm, "w_org_dept_input_add")
	ls_parm = Message.StringParm
	If ls_parm = "##OK##" Then
		ll_handle = tv_org.FindItem(CurrentTreeItem!, 0)
		of_refresh_item(ll_handle)
	End If
End If
end event

event retrieveend;If rowcount > 0 Then
	If GetSelectedRow(0) = 0 Then
		SelectRow(1, True)
	End If
End If
end event

event rowfocuschanged;SelectRow(0, False)
SelectRow(currentrow, True)
end event

type tab_1 from tab within w_org_dept_input
event create ( )
event destroy ( )
integer x = 987
integer y = 76
integer width = 3575
integer height = 2204
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;If newindex = 1 Then
	iw_detail.Show()
	dw_emplist.Show()
	dw_child.Hide()
Else
	iw_detail.Hide()
	dw_emplist.Hide()
	dw_child.Show()
End If
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3538
integer height = 2092
long backcolor = 32106727
string text = "구성원"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3538
integer height = 2092
long backcolor = 32106727
string text = "하위조직"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
end type

type gb_s1 from groupbox within w_org_dept_input
integer x = 50
integer y = 164
integer width = 914
integer height = 2128
integer taborder = 30
integer textsize = -6
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type p_newatom from uo_picture within w_org_dept_input
integer x = 3520
integer y = 12
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\새개체_up.gif"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = true
end type

event clicked;call super::clicked;parent.event ue_newatom()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\새개체_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\새개체_up.gif"
end event

type p_connect1 from uo_picture within w_org_dept_input
integer x = 3694
integer y = 12
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\하위연결_up.gif"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = true
end type

event clicked;call super::clicked;parent.event ue_connect1()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\하위연결_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\하위연결_dn.gif"
end event

type p_connect2 from uo_picture within w_org_dept_input
integer x = 3867
integer y = 12
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\독립연결_up.gif"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = true
end type

event clicked;call super::clicked;parent.event ue_connect2()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\독립연결_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\독립연결_dn.gif"
end event

type p_openorg from uo_picture within w_org_dept_input
integer x = 4041
integer y = 12
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\조직읽기_up.gif"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = true
end type

event clicked;call super::clicked;parent.event ue_openorg()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조직읽기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조직읽기_dn.gif"
end event

type p_saveorg from uo_picture within w_org_dept_input
integer x = 4215
integer y = 12
integer width = 178
integer taborder = 90
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\조직저장_up.gif"
boolean focusrectangle = true
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

parent.event ue_saveorg()

iw_detail.ib_chabged = false
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조직저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조직저장_up.gif"
end event

type p_exit from uo_picture within w_org_dept_input
integer x = 4389
integer y = 12
integer width = 178
integer taborder = 80
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = true
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_1 from datawindow within w_org_dept_input
boolean visible = false
integer x = 1545
integer width = 1815
integer height = 400
integer taborder = 100
string title = "none"
string dataobject = "d_org_dept_member01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

