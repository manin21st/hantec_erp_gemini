$PBExportHeader$w_sys_001_mdi_sheet_02.srw
$PBExportComments$User-Id 관리
forward
global type w_sys_001_mdi_sheet_02 from window
end type
type tv_1 from treeview within w_sys_001_mdi_sheet_02
end type
end forward

global type w_sys_001_mdi_sheet_02 from window
integer width = 2542
integer height = 2052
boolean titlebar = true
string title = "사용자 조정"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 32106727
tv_1 tv_1
end type
global w_sys_001_mdi_sheet_02 w_sys_001_mdi_sheet_02

type variables
Long il_dragsource, il_dragparent, il_droptarget
String	is_window_id, is_today, is_totime, is_usegub
end variables

forward prototypes
public subroutine wf_treeview_item ()
public subroutine wf_treeview_delete ()
end prototypes

public subroutine wf_treeview_item ();/* Treeview내역을 생성 */
Datastore ds_user
Treeviewitem tvi
String sToday
Long 		l_row, L_gbn, H_item, L_parent, L_gbn_b
Long 		L_level[20]
Integer	I_cnt
String 	L_userid
Boolean  B_child

/* 전체내역을 삭제 */
long tvi_hdl = 0

DO UNTIL tv_1.FindItem(RootTreeItem!, 0) = -1	
	      tv_1.DeleteItem(tvi_hdl)
LOOP

/* USER-ID 내역을 Retrieve */
ds_user = Create datastore
ds_user.dataobject = "d_sys_001_mdi_sheet_02"
ds_user.settransobject(sqlca)
If ds_user.retrieve() < 1 Then Return

For L_row=1 to ds_user.rowcount()
	 L_gbn    = Dec(ds_user.object.gubun[L_row])
	 
	 B_child  = False
	 
	 If L_row < ds_user.rowcount() Then
		 If L_gbn < Dec(ds_user.object.gubun[L_row + 1]) Then
		    B_child = True	
		 End if
	 End if

	 /* Root Level */
	 If 	  L_gbn = 0 Then
		 	  L_parent = 0
			  I_cnt    = 0
	 ElseIf L_gbn > L_gbn_b Then
			  I_cnt++		
			  L_level[I_cnt] = H_item
			  L_parent		  = H_item
    Elseif L_gbn < L_gbn_b Then
			  I_cnt = L_gbn
			  L_parent		  = L_level[i_cnt]
  	 Else
			  L_parent		  = L_level[i_cnt]
	 End if

    L_gbn_b   = L_gbn
	 tvi.label = ds_user.object.userid[l_row]
	 tvi.data  = ds_user.object.groupname[l_row]
	  
	 tvi.children = False
	 If b_child  Then
		 tvi.pictureindex = 2
		 tvi.Selectedpictureindex = 3
	 Else
		 tvi.pictureindex = 0
		 tvi.Selectedpictureindex = 0
	 End if
	 tvi.level  = L_gbn
/*	 H_item = tv_1.insertitemsort(L_parent, tvi)			// Root의 내용을 Sort를 하면서 하고자 하는 경우 */
	 H_item = tv_1.insertitemlast(L_parent, tvi)			// Root의 내용을 Sort를 하지않는 경우 

	 
Next

Destroy ds_user

return 

end subroutine

public subroutine wf_treeview_delete ();treeviewitem tvi_curr, tvi_prve
Long 		currenthandle, Parenthandle
String 	suser, sgroup

currenthandle = tv_1.finditem(currenttreeitem!, 0)
If tv_1.getitem(currenthandle, tvi_curr)		  = -1 Then Return
Parenthandle = tv_1.finditem(parenttreeitem!, currenthandle)
If tv_1.getitem(parenthandle, tvi_Prve) = -1 Then Return

sgroup = tvi_prve.label
suser  = tvi_curr.label

If Messagebox("삭제확인", "Group -> " + sgroup + '~n' + &
								  "User  -> " + suser  + " 를 삭제하시겠읍니까?", question!, yesno!, 2) = 1 Then

   /* Treeview에서 삭제 */
	tv_1.DeleteItem(currenthandle)	
								  
   delete from sub2_user_r
	       where user_id = :suser;
			 
	IF SQLCA.SQLCODE <> 0 THEN 
		MESSAGEBOX('확인', 'ATTENTION MENU 삭제 실패!', StopSign! )
		ROLLBACK;
		RETURN 
	END IF
	
	/* User Menu삭제 */
	Delete From sub2_user_t
		   Where user_id = :suser;

	IF SQLCA.SQLCODE <> 0 THEN 
		MESSAGEBOX('확인', '프로그램 MENU 삭제 실패!', StopSign! )
		ROLLBACK;
		RETURN 
	END IF
	
	/* User 삭제 */
	Delete from login_t 
		   Where l_userid = :suser;

	IF SQLCA.SQLCODE <> 0 THEN 
		MESSAGEBOX('확인', '삭제 실패!', StopSign! )
		ROLLBACK;
		RETURN 
	END IF

	Commit;	
							  
end if
end subroutine

on w_sys_001_mdi_sheet_02.create
this.tv_1=create tv_1
this.Control[]={this.tv_1}
end on

on w_sys_001_mdi_sheet_02.destroy
destroy(this.tv_1)
end on

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

wf_treeview_item()

end event

event resize;tv_1.Width = This.Width
tv_1.Height = This.Height
end event

event close;string s_frday, s_frtime

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

type tv_1 from treeview within w_sys_001_mdi_sheet_02
integer width = 1847
integer height = 1724
integer taborder = 10
boolean dragauto = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean border = false
boolean editlabels = true
boolean linesatroot = true
boolean disabledragdrop = false
string picturename[] = {"Start!","Regenerate5!","Undo!","Custom076!","Move!"}
long picturemaskcolor = 553648127
string statepicturename[] = {"Custom050!","Custom076!"}
long statepicturemaskcolor = 553648127
end type

event begindrag;// begin drag
TreeViewItem		ltvi_Source

GetItem(handle, ltvi_Source)

// Make sure only employees are being dragged
If ltvi_Source.Level = 1 Then
	Messagebox("Drag Cancel", "Root Level은 Drag할 수 없읍니다", Stopsign!)
	This.Drag(Cancel!)
Else
	/* 현재의 Handel과 Parent의 Handle의 값을 구한다 */
	il_DragSource = handle
	il_DragParent = FindItem(ParentTreeItem!, handle)
End If
end event

event dragdrop;// drag drop
Integer				li_Pending
Long					ll_NewItem
TreeViewItem		ltvi_Target, ltvi_Source, ltvi_Parent, ltvi_New
String				sGroupName, sUserName

If GetItem(il_DropTarget, ltvi_Target) = -1 Then Return
If GetItem(il_DragSource, ltvi_Source) = -1 Then Return


GetItem(il_DragParent, ltvi_Parent)
If MessageBox("Group 변경", "Group 변경을 원하십니까?  " + &
						ltvi_Source.Label + " from " + ltvi_Parent.label + " to " + ltvi_Target.label + &
						"?", Question!, YesNo!) = 2 Then Return
						
// 그룹명칭 변경
sGroupName = ltvi_target.label
sUserName  = ltvi_source.label
Update Login_t Set L_groupname = :sGroupName
 Where l_userid = :sUserName;
 
If sqlca.sqlcode <> 0 then
	Messagebox("SQL Error", "그룹명칭 변경중 오류가 발생", stopsign!)
	Rollback;
	return
Else
	Commit;
End if
						

// Move the item
// First delete the first item from the TreeView
DeleteItem(il_DragSource)

// Insert the item under the proper parent
SetNull(ltvi_Source.ItemHandle)
ll_NewItem = InsertItemLast(il_DropTarget, ltvi_Source)

// Select the new item
SelectItem(ll_NewItem)
end event

event dragwithin;// drag within
TreeViewItem		ltvi_Over, ltvi_parent

If GetItem(handle, ltvi_Over) = -1 Then
	SetDropHighlight(0)
	il_DropTarget = 0
	Return
End If

il_DropTarget = handle

// Drop target is this item's parent
If ltvi_over.level = 1 Then
Else
	il_DropTarget = FindItem(ParentTreeItem!, handle)
End if
getitem(il_droptarget, ltvi_parent)
If il_DropTarget <> il_DragParent Then
	SetDropHighlight(il_DropTarget)
Else
	SetDropHighlight(0)
	il_DropTarget = 0
End If


end event

event key;If key = keydelete! Then
	wf_treeview_delete()
	
End if
end event

event endlabeledit;Treeviewitem tvi
String sOldname, sNewname

Getitem(handle, tvi)
sOldname = tvi.Label
sNewname = newtext

If messagebox("User-Id변경", "변경전 User-Id -> " + soldname + '~n'  + &
									  "변경후 User-Id -> " + snewname + "로 변경하시겠읍니까?", &
									  question!, yesno!, 2) = 1 Then
									  
	// User-Id 변경
	Update Login_t Set L_userid = :sNewname
	 Where l_userid = :sOldName;
	 
	If sqlca.sqlcode <> 0 then
		Messagebox("SQL Error", "User-Id명칭 변경중 오류가 발생", stopsign!)
		Rollback;
		return
	Else
		Commit;
	End if

End if
end event

