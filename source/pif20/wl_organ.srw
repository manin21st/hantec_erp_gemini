$PBExportHeader$wl_organ.srw
$PBExportComments$# 조직도
forward
global type wl_organ from window
end type
type tv_org from treeview within wl_organ
end type
type gb_s01 from groupbox within wl_organ
end type
type dw_treedata from datawindow within wl_organ
end type
type dw_1 from datawindow within wl_organ
end type
end forward

global type wl_organ from window
integer width = 3561
integer height = 1992
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_refreshtree ( )
tv_org tv_org
gb_s01 gb_s01
dw_treedata dw_treedata
dw_1 dw_1
end type
global wl_organ wl_organ

type variables
treeviewitem	itvi_drag_object
integer		ii_thickness = 22
menu			im_pop
string		is_clickedempno
window		iw_detail

end variables

forward prototypes
public function integer wf_add_item (string as_data, string as_label, long al_parent)
public function integer wf_add_level (string as_data, string as_label, long al_parent)
public function long wf_refresh_item (long al_handle)
end prototypes

event ue_refreshtree();String	ls_rootname
Long	ll_tophandle

tv_org.DeleteItem(0)

Select "ORG_NM"
  Into :ls_rootname
  From "ORG_DEPT"
 Where "ORG_CD" = '000000' USING SQLCA;

Choose Case SQLCA.SQLCode
	Case 0
		ll_tophandle = wf_add_level("000000", ls_rootname, 0)
		tv_org.SelectItem(ll_tophandle)
		tv_org.ExpandItem(tv_org.FindItem(RootTreeItem!, 0))
	Case 100
		// 없음 - 초기화 요망
//		Post Event ue_addroot()
	Case -1
		MessageBox("인사급여 시스템 오류", "조직도 테이블에 오류가 있습니다.", StopSign!)
		Post Close(This)
		Return
End Choose

end event

public function integer wf_add_item (string as_data, string as_label, long al_parent);// Add a entry to the TreeView
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

public function integer wf_add_level (string as_data, string as_label, long al_parent);Long				ll_NewItem
Long				ll_row, ll_rowcount
TreeViewItem		ltvi_Item
String			ls_org_cd[], ls_org_nm[]

ll_newitem  = wf_add_item(as_data, as_label, al_parent)
ll_rowcount = dw_treedata.Retrieve(as_data)
For ll_row = 1 To ll_rowcount
	ls_org_cd[ll_row]	= dw_treedata.object.org_cd[ll_row]
	ls_org_nm[ll_row]		= dw_treedata.object.org_nm[ll_row]
Next
For ll_row = 1 To ll_rowcount
	wf_add_level(ls_org_cd[ll_row], ls_org_nm[ll_row], ll_newitem)
Next

Return ll_newitem
end function

public function long wf_refresh_item (long al_handle);Long	ll_parenthandle, ll_newhandle
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

ll_newhandle = wf_add_level(ls_orgcode, ls_orgname, ll_parenthandle)
tv_org.SelectItem(ll_newhandle)
tv_org.ExpandItem(ll_newhandle)

Return 1

end function

event open;if isvalid(this) = false then return

dw_treedata.SetTransObject(SQLCA)

im_pop = Create Using "m_dept_diagram_popup"
Open(iw_detail, "w_org_dept_detail", This)
iw_detail.width  = gb_s01.width - 200
iw_detail.Height = gb_s01.height

iw_detail.Move(942, tv_org.y -5)
Post Event ue_refreshtree()
//wf_setmode(false,false,false,false,false)



end event

on wl_organ.create
this.tv_org=create tv_org
this.gb_s01=create gb_s01
this.dw_treedata=create dw_treedata
this.dw_1=create dw_1
this.Control[]={this.tv_org,&
this.gb_s01,&
this.dw_treedata,&
this.dw_1}
end on

on wl_organ.destroy
destroy(this.tv_org)
destroy(this.gb_s01)
destroy(this.dw_treedata)
destroy(this.dw_1)
end on

event resize;gb_s01.height = newheight     - 20
tv_org.height = gb_s01.height - 36

iw_detail.width  = newwidth - 970
iw_detail.height = tv_org.height + 10
//
//uo_tb.x = iw_detail.x + iw_detail.width + 10
//uo_tb.height = tv_org.height + 10
end event

type tv_org from treeview within wl_organ
event ue_mousemove pbm_mousemove
event ue_mousedown pbm_lbuttondown
event ue_mouseup pbm_lbuttonup
integer x = 27
integer y = 28
integer width = 878
integer height = 1824
integer taborder = 10
boolean dragauto = true
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32567551
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
 WHERE "ORG_CD" = :ls_org_cd USING SQLCA;

If SQLCA.SQLCode = 0 Then
	COMMIT USING SQLCA;
Else
	MessageBox("DB 오류", "조직도 자료를 저장할 수 없습니다!", StopSign!)
	ROLLBACK USING SQLCA;
	Return
End If

wf_add_level(itvi_drag_object.data, itvi_drag_object.label, handle)

This.DeleteItem(itvi_drag_object.itemhandle)
end event

event rightclicked;If handle >= 0 Then
	im_pop.item[2].Post PopMenu(w_mdi_frame.PointerX(), w_mdi_frame.PointerY())
End If
end event

event selectionchanged;TreeViewItem		ltvi_current
String	ls_org_cd, ls_dept_cd

If GetItem(newhandle, ltvi_current) = 1 Then
	ls_org_cd = String(ltvi_current.Data)
	SELECT "DEPT_CD"
	  INTO :ls_dept_cd
	  FROM "ORG_DEPT"
	 WHERE "ORG_CD" = :ls_org_cd USING SQLCA;

//	dw_child.Retrieve(DateTime(Date(1999,1,1)), ls_orgcode, gs_pic_dir)

	//iw_detail.Dynamic wf_openorg(String(ltvi_current.Data))
	iw_detail.Dynamic wf_set_org_cd(ls_org_cd)
	iw_detail.Dynamic Event ue_openorg()

//	dw_deptemp.Retrieve(ls_deptcode)
End If
end event

type gb_s01 from groupbox within wl_organ
integer x = 18
integer width = 896
integer height = 1860
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
borderstyle borderstyle = styleraised!
end type

type dw_treedata from datawindow within wl_organ
boolean visible = false
integer x = 201
integer y = 160
integer width = 521
integer height = 208
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_org_dept_tree"
boolean livescroll = true
end type

event constructor;Hide()
end event

type dw_1 from datawindow within wl_organ
integer x = 942
integer y = 24
integer width = 1774
integer height = 1832
integer taborder = 20
string title = "none"
boolean border = false
boolean livescroll = true
end type

