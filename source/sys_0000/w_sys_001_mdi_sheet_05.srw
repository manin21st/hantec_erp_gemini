$PBExportHeader$w_sys_001_mdi_sheet_05.srw
$PBExportComments$User별 Program 등록
forward
global type w_sys_001_mdi_sheet_05 from Window
end type
type cb_cancel from commandbutton within w_sys_001_mdi_sheet_05
end type
type cb_save from commandbutton within w_sys_001_mdi_sheet_05
end type
type cb_retrieve from commandbutton within w_sys_001_mdi_sheet_05
end type
type sle_userid from singlelineedit within w_sys_001_mdi_sheet_05
end type
type st_4 from statictext within w_sys_001_mdi_sheet_05
end type
type tv_user from treeview within w_sys_001_mdi_sheet_05
end type
type cb_exit from commandbutton within w_sys_001_mdi_sheet_05
end type
type sle_msg from singlelineedit within w_sys_001_mdi_sheet_05
end type
type dw_datetime from datawindow within w_sys_001_mdi_sheet_05
end type
type st_10 from statictext within w_sys_001_mdi_sheet_05
end type
type tv_1 from treeview within w_sys_001_mdi_sheet_05
end type
type gb_1 from groupbox within w_sys_001_mdi_sheet_05
end type
type gb_mode1 from groupbox within w_sys_001_mdi_sheet_05
end type
end forward

global type w_sys_001_mdi_sheet_05 from Window
int X=0
int Y=0
int Width=3625
int Height=2440
boolean TitleBar=true
string Title="User별 Program등록"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
WindowState WindowState=maximized!
cb_cancel cb_cancel
cb_save cb_save
cb_retrieve cb_retrieve
sle_userid sle_userid
st_4 st_4
tv_user tv_user
cb_exit cb_exit
sle_msg sle_msg
dw_datetime dw_datetime
st_10 st_10
tv_1 tv_1
gb_1 gb_1
gb_mode1 gb_mode1
end type
global w_sys_001_mdi_sheet_05 w_sys_001_mdi_sheet_05

type variables
/************* tree용 *****************************/
Datastore ids_data[3], ids_user[3]
string        is_drag_data, is_user_id
long          il_oldhandle,  il_newhandle, il_droptarget, & 
                 il_dragparent
TreeViewItem     itv_old, itv_new
end variables

forward prototypes
public subroutine wf_treeview_item ()
public subroutine wf_treeview_delete ()
public function integer wf_retrieve_data (long al_handle)
public function integer wf_add_tv (long al_parent, integer i_level, integer i_rows)
public subroutine wf_move ()
public function string wf_confirmuser ()
public subroutine wf_usertree_item ()
public function integer wf_retrieve_user (integer al_handle)
public function integer wf_add_user (long al_parent, integer i_level, integer i_rows)
public function integer wf_lmove (integer ireturn)
public function integer wf_mmove (integer ireturn)
end prototypes

public subroutine wf_treeview_item ();/* Treeview내역을 생성 */
Treeviewitem   ltvi_Root, tv_new
Long				ll_Root, ll_New, i_cnt, l_row, ll_tvi, l_main


/* 전체내역을 삭제 */
long tvi_hdl = 0

DO UNTIL tv_1.FindItem(RootTreeItem!, 0) = -1	
	      tv_1.DeleteItem(tvi_hdl)
LOOP

Setpointer(Hourglass!)

/* 프로그램 대분류를 Retrieve */
If ids_data[1].Retrieve() < 1 then 
	Setpointer(Arrow!)
	return
End If 

/* 첫번째 레벨을 등록하고 ........................... */
ltvi_Root.Data = '000000000000000'
ltvi_Root.Label= '물류관리 시스템'    
ltvi_Root.PictureIndex = 1
ltvi_Root.SelectedPictureIndex = 1
ltvi_Root.Children = True
ll_Root = tv_1.InsertItemLast(0, ltvi_Root)

For L_row=1 to  ids_data[1].rowcount()
	l_main = ids_data[1].object.main_id[L_row]
	tv_New.data  = string(ids_data[1].object.main_id[L_row], "00000") + &
	               string(ids_data[1].object.sub1_id[L_row], "00000") + &
	               string(ids_data[1].object.sub2_id[L_row], "00000")
   tv_New.label = ids_data[1].object.sub2_name[L_row]
   tv_New.PictureIndex = 2
   tv_New.SelectedPictureindex = 2
	tv_New.Children = True
	ll_New = tv_1.insertitemlast(1,tv_New)
	
   SELECT COUNT(*)	 INTO :i_cnt  
	  FROM "SUB2_T"  
	 WHERE ( "SUB2_T"."MAIN_ID" = :l_main ) AND  
			 ( "SUB2_T"."SUB2_ID" <> 100 ) AND  
			 ( "SUB2_T"."SUB2_ID" <> 99 )  ;
	
	if i_cnt > 0 then	
	   tv_New.Children = True
	else
	   tv_New.Children = false
	end if
	
   tv_1.ExpandItem(ll_New)
Next

Setpointer(Arrow!)

return 

end subroutine

public subroutine wf_treeview_delete ();treeviewitem tvi_curr
Long 		currenthandle, lLevel
long      i_main, i_sub1, i_sub2
String 	sLabel, sdata

currenthandle = tv_user.finditem(currenttreeitem!, 0)
If tv_user.getitem(currenthandle, tvi_curr)		  = -1 Then Return

sData   = string(tvi_curr.data)
i_main  = long(trim(left(sdata, 5)))
i_sub1  = long(trim(mid(sdata, 6, 5)))
i_sub2  = long(trim(mid(sdata, 11, 5)))

sLabel  = tvi_curr.label
lLevel  = tvi_curr.level

if llevel = 1 then 
	return 
elseif	llevel = 2 then 
	If Messagebox("삭제확인", "대분류 " + slabel  + "을(를) 삭제하시겠읍니까?", &
	              question!, yesno!, 2) = 2 Then return 
	
	/* Treeview에서 삭제 */
	tv_user.DeleteItem(currenthandle)	
									  
	/* User별 Menu삭제 */
  DELETE FROM "SUB2_USER_T"  
   WHERE ( "SUB2_USER_T"."USER_ID" = :is_user_id ) AND  
         ( "SUB2_USER_T"."MAIN_ID" = :i_main )   ;

   if sqlca.sqlcode  = 0 then
		Commit;	
	else
		Rollback;
	end if	
elseif	llevel = 3 then 
	If Messagebox("삭제확인", "중분류 " + slabel  + "을(를) 삭제하시겠읍니까?", &
	              question!, yesno!, 2) = 2 Then return 
	
	/* Treeview에서 삭제 */
	tv_user.DeleteItem(currenthandle)	
									  
	/* User별 Menu삭제 */
  DELETE FROM "SUB2_USER_T"  
   WHERE ( "SUB2_USER_T"."USER_ID" = :is_user_id ) AND  
         ( "SUB2_USER_T"."MAIN_ID" = :i_main )  AND
         ( "SUB2_USER_T"."SUB1_ID" = :i_sub1 )   ;
 
   if sqlca.sqlcode  = 0 then
		Commit;	
	else
		Rollback;
	end if	
else								  
	If Messagebox("삭제확인", + slabel  + "을(를) 삭제하시겠읍니까?", &
	              question!, yesno!, 2) = 2 Then return 
	
	/* Treeview에서 삭제 */
	tv_user.DeleteItem(currenthandle)	
									  
	/* User별 Menu삭제 */
  DELETE FROM "SUB2_USER_T"  
   WHERE ( "SUB2_USER_T"."USER_ID" = :is_user_id ) AND  
         ( "SUB2_USER_T"."MAIN_ID" = :i_main )  AND
         ( "SUB2_USER_T"."SUB1_ID" = :i_sub1 )  AND
         ( "SUB2_USER_T"."SUB2_ID" = :i_sub2 )   ;
 
   if sqlca.sqlcode  = 0 then
		Commit;	
	else
		Rollback;
	end if	
end if
end subroutine

public function integer wf_retrieve_data (long al_handle);LONG			   	i_level, i_current_data, i_sub1
string            s_current_data
TreeViewItem		tv_Current

/*****  현재의 level 을 결정  ************************************************/
tv_1.GetItem(al_Handle, tv_Current)
i_level = tv_Current.Level

/* datastore의 argument를 구한다.(현재레벨의 데이타값을 구함) ****************/
s_current_data = String(tv_Current.Data)
i_current_data = long(trim(left(s_current_data, 5)))
i_sub1         = long(trim(mid(s_current_data, 6, 5)))

choose case i_level
   case 2
      Return ids_data[2].Retrieve(i_current_data)
	case 3
		Return ids_data[3].Retrieve(i_current_data, i_sub1)
   case else
      Return 0
End choose


end function

public function integer wf_add_tv (long al_parent, integer i_level, integer i_rows);Integer				i_Cnt, i_sub1_id, i_main_id, k
long              cnt
TreeViewItem		tv_New

k = i_level - 1

For i_Cnt = 1 To i_Rows
   i_main_id     = ids_data[k].Object.main_id[i_cnt]
	i_sub1_id     = ids_data[k].Object.sub1_id[i_cnt]
	tv_New.data   = string(ids_data[k].Object.main_id[i_cnt], "00000") + &
	                string(ids_data[k].Object.sub1_id[i_cnt], "00000") + &
	                string(ids_data[k].Object.sub2_id[i_cnt], "00000")
						 
	tv_New.label  = ids_data[k].Object.sub2_name[i_cnt]
	tv_New.PictureIndex = i_level
	tv_New.SelectedPictureindex = i_level

	if i_level < 4 then
	   select count(*) into :cnt
		  from sub2_t
		 where main_id = :i_main_id and sub1_id = :i_sub1_id and 
				 sub2_id <> 99 and sub2_id <> 100  ;
		 
		if cnt > 0 then	
			tv_New.Children = True
		else
			tv_New.Children = false
		end if
	else
		tv_New.Children = false
   end if		
	/********************************************/
	// Add the item after the last child
	If tv_1.InsertItemLast(al_Parent, tv_New) < 1 Then
		MessageBox("Error", "Error inserting item", Exclamation!)
		Return -1
	End If
Next

Return i_Rows

end function

public subroutine wf_move ();string old_name, sub_nm, win_nm
long   old_level, level, new_handle
long   old_main, old_sub1, old_sub2
treeviewitem tv_insert, tv_current

if tv_1.GetItem(il_dragparent, tv_current) = -1 Then Return

if itv_old.Level <> itv_new.Level + 1 then
	messagebox("확인", tv_current.label + " 메뉴로 넣어 주세요!")
	return //level 3, 4 에서는 자기 level로 drag 안됨 
end if

if itv_new.data <> tv_current.data then 
	messagebox("확인", tv_current.label + " 메뉴로 넣어 주세요!")
	return 
end if

old_Level = itv_old.Level

old_main = long(left(string(itv_old.data), 5))
old_sub1 = long(mid(string(itv_old.data), 6, 5))
old_sub2 = long(mid(string(itv_old.data), 11, 5))

if old_level = 4 then
   SELECT "SUB2_T"."SUB2_NAME",  "SUB2_T"."WINDOW_NAME"  
     INTO :sub_nm, :win_nm
     FROM "SUB2_T"  
    WHERE ( "SUB2_T"."MAIN_ID" = :old_main ) AND  
          ( "SUB2_T"."SUB1_ID" = :old_sub1 ) AND  
          ( "SUB2_T"."SUB2_ID" = :old_sub2 )   ;

   If sqlca.sqlcode <> 0 then return 
		
   INSERT INTO "SUB2_USER_T"  
             ( "USER_ID",   "MAIN_ID",  "SUB1_ID", "SUB2_ID", "SUB2_NAME", "WINDOW_NAME" )  
      VALUES ( :is_user_id, :old_main,  :old_sub1, :old_sub2, :sub_nm,     :win_nm )  ;
	
   If sqlca.sqlcode <> 0 then
		Messagebox("SQL Error", "변경중 오류가 발생", stopsign!)
		Rollback;
		return
	Else
   	Commit;
	End If	
End if

itv_new.children = true
itv_new.PictureIndex = itv_new.level
itv_new.SelectedPictureindex = itv_new.level
tv_user.setitem(il_newhandle,itv_new)
Level = itv_new.Level
tv_insert.data  = string(old_main, "00000") + string(old_sub1, "00000") + &
						string(old_sub2, "00000")

old_name = itv_old.label
tv_insert.label = old_name
tv_insert.PictureIndex = level + 1
tv_insert.SelectedPictureindex = level + 1
tv_insert.children = itv_old.children

new_handle = tv_user.InsertItemSort(il_newhandle, tv_insert)

If new_handle < 1 Then
	MessageBox("Error", "Error inserting item", Exclamation!)
	Return 
End If
// Select the new item
tv_user.SelectItem(new_handle)



end subroutine

public function string wf_confirmuser ();string	sUserId,		&
			sConfirm

sUserId = trim(sle_userid.text)

IF IsNull(sUserId)	 or  sUserId = ''	THEN
	MessageBox("USER ID 확인", "USER ID 를 입력하세요.")
	sle_userid.SetFocus()
	RETURN '-1'
END IF

SELECT "LOGIN_T"."L_USERID"
	INTO :sConfirm
	FROM "LOGIN_T"  
   WHERE ( "LOGIN_T"."L_USERID" = :sUserId )  ;

IF	sqlca.sqlcode <> 0		then
	messagebox("USER ID 확인", "등록된 USER ID 가 아닙니다.")
	sle_userid.setfocus()
	RETURN '-1'
END IF

//cb_save.enabled = true

RETURN	sUserid
end function

public subroutine wf_usertree_item ();/* Treeview내역을 생성 */
Treeviewitem   ltvi_Root, tv_new
Long				ll_Root, ll_New, i_cnt, l_row, ll_tvi, l_main

/* 전체내역을 삭제 */
long tvi_hdl = 0

DO UNTIL tv_user.FindItem(RootTreeItem!, 0) = -1	
	      tv_user.DeleteItem(tvi_hdl)
LOOP

Setpointer(Hourglass!)

/* 첫번째 레벨을 등록하고 ........................... */
ltvi_Root.Data = '999999999999999'
ltvi_Root.Label= is_user_id
ltvi_Root.PictureIndex = 1
ltvi_Root.SelectedPictureIndex = 1
ltvi_Root.Children = True
ll_Root = tv_user.InsertItemLast(0, ltvi_Root)

/* 프로그램 대분류를 Retrieve */
If ids_user[1].Retrieve(is_user_id) < 1 then 
	Setpointer(Arrow!)
	return
End If 

For L_row=1 to  ids_user[1].rowcount()
	l_main = ids_user[1].object.main_id[L_row]
	tv_New.data  = string(ids_user[1].object.main_id[L_row], "00000") + &
	               string(ids_user[1].object.sub1_id[L_row], "00000") + &
	               string(ids_user[1].object.sub2_id[L_row], "00000")
   tv_New.label = ids_user[1].object.sub2_name[L_row]
   tv_New.PictureIndex = 2
   tv_New.SelectedPictureindex = 2
	tv_New.Children = True
	ll_New = tv_user.insertitemlast(1,tv_New)
	
   SELECT COUNT(*)	 INTO :i_cnt  
	  FROM "SUB2_USER_T"  
	 WHERE ( "SUB2_USER_T"."USER_ID" = :is_user_id ) AND  
			 ( "SUB2_USER_T"."MAIN_ID" = :l_main ) AND  
			 ( "SUB2_USER_T"."SUB2_ID" <> 100 ) AND  
			 ( "SUB2_USER_T"."SUB2_ID" <> 99 )  ;
	
	if i_cnt > 0 then	
	   tv_New.Children = True
	else
	   tv_New.Children = false
	end if
	
   tv_user.ExpandItem(ll_New)
Next

Setpointer(Arrow!)

return 

end subroutine

public function integer wf_retrieve_user (integer al_handle);long				i_level, i_current_data, i_sub1
string            s_current_data
TreeViewItem		tv_Current

/*****  현재의 level 을 결정  ************************************************/
tv_user.GetItem(al_Handle, tv_Current)
i_level = tv_Current.Level

/* datastore의 argument를 구한다.(현재레벨의 데이타값을 구함) ****************/
s_current_data = String(tv_Current.Data)
i_current_data = long(trim(left(s_current_data, 5)))
i_sub1         = long(trim(mid(s_current_data, 6, 5)))

choose case i_level
   case 2
      Return ids_user[2].Retrieve(is_user_id, i_current_data)
	case 3
		Return ids_user[3].Retrieve(is_user_id, i_current_data, i_sub1)
   case else
      Return 0
End choose


end function

public function integer wf_add_user (long al_parent, integer i_level, integer i_rows);Integer				i_Cnt, i_sub1_id, i_main_id, k
long              cnt
TreeViewItem		tv_New

k = i_level - 1

For i_Cnt = 1 To i_Rows
   i_main_id     = ids_user[k].Object.main_id[i_cnt]
	i_sub1_id     = ids_user[k].Object.sub1_id[i_cnt]
	tv_New.data   = string(ids_user[k].Object.main_id[i_cnt], "00000") + &
	                string(ids_user[k].Object.sub1_id[i_cnt], "00000") + &
	                string(ids_user[k].Object.sub2_id[i_cnt], "00000")
						 
	tv_New.label  = ids_user[k].Object.sub2_name[i_cnt]
	tv_New.PictureIndex = i_level
	tv_New.SelectedPictureindex = i_level

	if i_level < 4 then
	   select count(*) into :cnt
		  from sub2_user_t
		 where user_id = :is_user_id and 
		       main_id = :i_main_id and sub1_id = :i_sub1_id and 
				 sub2_id <> 99 and sub2_id <> 100  ;
		 
		if cnt > 0 then	
			tv_New.Children = True
		else
			tv_New.Children = false
		end if
	else
		tv_New.Children = false
   end if		
	/********************************************/
	// Add the item after the last child
	If tv_user.InsertItemLast(al_Parent, tv_New) < 1 Then
		MessageBox("Error", "Error inserting item", Exclamation!)
		Return -1
	End If
Next

Return i_Rows

end function

public function integer wf_lmove (integer ireturn);string sub_nm, win_nm, get_nm
long   old_main, old_sub1, old_sub2, i_rows, icount, icount2

old_main = long(left(string(itv_old.data), 5))
old_sub1 = long(mid(string(itv_old.data), 6, 5))
old_sub2 = long(mid(string(itv_old.data), 11, 5))

SELECT "SUB2_USER_T"."SUB2_NAME"
  INTO :get_nm
  FROM "SUB2_USER_T"  
 WHERE ( "SUB2_USER_T"."USER_ID" = :is_user_id ) AND  
		 ( "SUB2_USER_T"."MAIN_ID" = :old_main ) AND  
		 ( "SUB2_USER_T"."SUB1_ID" = :old_sub1 ) AND  
		 ( "SUB2_USER_T"."SUB2_ID" = :old_sub2 )  ;

If sqlca.sqlcode = 0 then 
	Messagebox("확인", "이미 대분류 " + get_nm + "가 존재합니다." +"~n"+&
	   "기존자료를 삭제하시고 추가 하십시요!")
	RETURN -1
END IF	

SELECT "SUB2_T"."SUB2_NAME",  "SUB2_T"."WINDOW_NAME"  
  INTO :sub_nm, :win_nm
  FROM "SUB2_T"  
 WHERE ( "SUB2_T"."MAIN_ID" = :old_main ) AND  
		 ( "SUB2_T"."SUB1_ID" = :old_sub1 ) AND  
		 ( "SUB2_T"."SUB2_ID" = :old_sub2 )   ;

INSERT INTO "SUB2_USER_T"  
			 ( "USER_ID",   "MAIN_ID",  "SUB1_ID", "SUB2_ID", "SUB2_NAME", "WINDOW_NAME" )  
	VALUES ( :is_user_id, :old_main,  :old_sub1, :old_sub2, :sub_nm,     :win_nm )  ;

If sqlca.sqlcode <> 0 then
	Messagebox("SQL Error", "변경중 오류가 발생", stopsign!)
	Rollback;
	return -1
End If	

if ireturn = 1 then 
	commit;
   wf_usertree_item()   
   return 1
elseif ireturn = 2 then
	If ids_data[2].Retrieve(old_main) < 1 then 
		COMMIT;
      wf_usertree_item()   
		RETURN 1
	End If 
	For icount = 1 To ids_data[2].rowcount()
		old_main = ids_data[2].object.main_id[icount]
		old_sub1 = ids_data[2].object.sub1_id[icount]
		old_sub2 = ids_data[2].object.sub2_id[icount]
		sub_nm   = ids_data[2].object.sub2_name[icount]
		win_nm   = ids_data[2].object.window_name[icount]
		INSERT INTO "SUB2_USER_T"  
					 ( "USER_ID",   "MAIN_ID",  "SUB1_ID", "SUB2_ID", "SUB2_NAME", "WINDOW_NAME" )  
			VALUES ( :is_user_id, :old_main,  :old_sub1, :old_sub2, :sub_nm,     :win_nm )  ;
		
		If sqlca.sqlcode <> 0 then
			Messagebox("SQL Error", "변경중 오류가 발생", stopsign!)
			Rollback;
			return -1
		End If	

   Next
	commit;
   wf_usertree_item()   
   return 1
elseif ireturn = 3 then
	If ids_data[2].Retrieve(old_main) < 1 then 
		COMMIT;
		RETURN 1
	End If 
	For icount = 1 To ids_data[2].rowcount()
		old_main = ids_data[2].object.main_id[icount]
		old_sub1 = ids_data[2].object.sub1_id[icount]
		old_sub2 = ids_data[2].object.sub2_id[icount]
		sub_nm   = ids_data[2].object.sub2_name[icount]
		win_nm   = ids_data[2].object.window_name[icount]
		INSERT INTO "SUB2_USER_T"  
					 ( "USER_ID",   "MAIN_ID",  "SUB1_ID", "SUB2_ID", "SUB2_NAME", "WINDOW_NAME" )  
			VALUES ( :is_user_id, :old_main,  :old_sub1, :old_sub2, :sub_nm,     :win_nm )  ;
		
		If sqlca.sqlcode <> 0 then
			Messagebox("SQL Error", "변경중 오류가 발생", stopsign!)
			Rollback;
			return -1
		End If	
		ids_data[3].Retrieve(old_main, old_sub1)
		For icount2 = 1 To ids_data[3].rowcount()
			old_main = ids_data[3].object.main_id[icount2]
			old_sub1 = ids_data[3].object.sub1_id[icount2]
			old_sub2 = ids_data[3].object.sub2_id[icount2]
			sub_nm   = ids_data[3].object.sub2_name[icount2]
			win_nm   = ids_data[3].object.window_name[icount2]
			INSERT INTO "SUB2_USER_T"  
						 ( "USER_ID",   "MAIN_ID",  "SUB1_ID", "SUB2_ID", "SUB2_NAME", "WINDOW_NAME" )  
				VALUES ( :is_user_id, :old_main,  :old_sub1, :old_sub2, :sub_nm,     :win_nm )  ;
			
			If sqlca.sqlcode <> 0 then
				Messagebox("SQL Error", "변경중 오류가 발생", stopsign!)
				Rollback;
				return -1
			End If	
		Next
	Next
	commit;
   wf_usertree_item()   
   return 1
End If

COMMIT;
RETURN 1
end function

public function integer wf_mmove (integer ireturn);string sub_nm, win_nm, get_nm
long   old_main, old_sub1, old_sub2,i_rows, icount

old_main = long(left(string(itv_old.data), 5))
old_sub1 = long(mid(string(itv_old.data), 6, 5))
old_sub2 = long(mid(string(itv_old.data), 11, 5))

SELECT "SUB2_USER_T"."SUB2_NAME"
  INTO :get_nm
  FROM "SUB2_USER_T"  
 WHERE ( "SUB2_USER_T"."USER_ID" = :is_user_id ) AND  
		 ( "SUB2_USER_T"."MAIN_ID" = :old_main ) AND  
		 ( "SUB2_USER_T"."SUB1_ID" = :old_sub1 ) AND  
		 ( "SUB2_USER_T"."SUB2_ID" = :old_sub2 )  ;

If sqlca.sqlcode = 0 then 
	Messagebox("확인", "이미 중분류 " + get_nm + "가 존재합니다." +"~n"+&
	   "기존자료를 삭제하시고 추가 하십시요!")
	RETURN -1
END IF	

SELECT "SUB2_T"."SUB2_NAME",  "SUB2_T"."WINDOW_NAME"  
  INTO :sub_nm, :win_nm
  FROM "SUB2_T"  
 WHERE ( "SUB2_T"."MAIN_ID" = :old_main ) AND  
		 ( "SUB2_T"."SUB1_ID" = :old_sub1 ) AND  
		 ( "SUB2_T"."SUB2_ID" = :old_sub2 )   ;

INSERT INTO "SUB2_USER_T"  
			 ( "USER_ID",   "MAIN_ID",  "SUB1_ID", "SUB2_ID", "SUB2_NAME", "WINDOW_NAME" )  
	VALUES ( :is_user_id, :old_main,  :old_sub1, :old_sub2, :sub_nm,     :win_nm )  ;

If sqlca.sqlcode <> 0 then
	Messagebox("SQL Error", "변경중 오류가 발생", stopsign!)
	Rollback;
	return -1
End If	

if ireturn = 2 then 
	commit;
   wf_usertree_item()   
   return 1
elseif ireturn = 3 then
	If ids_data[3].Retrieve(old_main, old_sub1) < 1 then 
		COMMIT;
      wf_usertree_item()   
		RETURN 1
	End If 
	For icount = 1 To ids_data[3].rowcount()
		old_main = ids_data[3].object.main_id[icount]
		old_sub1 = ids_data[3].object.sub1_id[icount]
		old_sub2 = ids_data[3].object.sub2_id[icount]
		sub_nm   = ids_data[3].object.sub2_name[icount]
		win_nm   = ids_data[3].object.window_name[icount]
		INSERT INTO "SUB2_USER_T"  
					 ( "USER_ID",   "MAIN_ID",  "SUB1_ID", "SUB2_ID", "SUB2_NAME", "WINDOW_NAME" )  
			VALUES ( :is_user_id, :old_main,  :old_sub1, :old_sub2, :sub_nm,     :win_nm )  ;
		
		If sqlca.sqlcode <> 0 then
			Messagebox("SQL Error", "변경중 오류가 발생", stopsign!)
			Rollback;
			return -1
		End If	

   Next
	commit;
   wf_usertree_item()   
   return 1
End If

COMMIT;
RETURN 1
end function

on w_sys_001_mdi_sheet_05.create
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.cb_retrieve=create cb_retrieve
this.sle_userid=create sle_userid
this.st_4=create st_4
this.tv_user=create tv_user
this.cb_exit=create cb_exit
this.sle_msg=create sle_msg
this.dw_datetime=create dw_datetime
this.st_10=create st_10
this.tv_1=create tv_1
this.gb_1=create gb_1
this.gb_mode1=create gb_mode1
this.Control[]={this.cb_cancel,&
this.cb_save,&
this.cb_retrieve,&
this.sle_userid,&
this.st_4,&
this.tv_user,&
this.cb_exit,&
this.sle_msg,&
this.dw_datetime,&
this.st_10,&
this.tv_1,&
this.gb_1,&
this.gb_mode1}
end on

on w_sys_001_mdi_sheet_05.destroy
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.cb_retrieve)
destroy(this.sle_userid)
destroy(this.st_4)
destroy(this.tv_user)
destroy(this.cb_exit)
destroy(this.sle_msg)
destroy(this.dw_datetime)
destroy(this.st_10)
destroy(this.tv_1)
destroy(this.gb_1)
destroy(this.gb_mode1)
end on

event open;ids_Data[1] = Create DataStore
ids_Data[1].DataObject = "d_sys_001_mdi_sheet_04_1"  // 대분류 데이타

ids_Data[2] = Create DataStore
ids_Data[2].DataObject = "d_sys_001_mdi_sheet_04_2"  // 중분류 데이타       

ids_Data[3] = Create DataStore
ids_Data[3].DataObject = "d_sys_001_mdi_sheet_04_3"  // 프로그램 데이타       

ids_User[1] = Create DataStore
ids_User[1].DataObject = "d_sys_001_mdi_sheet_05_1"  // 사용자 대분류 

ids_User[2] = Create DataStore
ids_User[2].DataObject = "d_sys_001_mdi_sheet_05_2"  // 사용자 중분류 

ids_User[3] = Create DataStore
ids_User[3].DataObject = "d_sys_001_mdi_sheet_05_3"  // 사용자 프로그램        

Ids_data[1].setTransobject(sqlca)
Ids_data[2].setTransobject(sqlca)
Ids_data[3].setTransobject(sqlca)

Ids_user[1].setTransobject(sqlca)
Ids_user[2].setTransobject(sqlca)
Ids_user[3].setTransobject(sqlca)
dw_datetime.insertrow(0)
wf_treeview_item()   //대분류 트리 생성

end event

type cb_cancel from commandbutton within w_sys_001_mdi_sheet_05
int X=2423
int Y=1776
int Width=475
int Height=96
int TabOrder=50
string Text="취소(&C)"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;long tvi_hdl = 0

/* 전체내역을 삭제 */
DO UNTIL tv_user.FindItem(RootTreeItem!, 0) = -1	
	      tv_user.DeleteItem(tvi_hdl)
LOOP

wf_treeview_item()   //대분류 트리 생성

sle_userid.enabled = true
sle_userid.text = ''
sle_msg.text = ''

sle_userid.setfocus()

//cb_save.enabled = false


end event

type cb_save from commandbutton within w_sys_001_mdi_sheet_05
int X=1733
int Y=2220
int Width=366
int Height=96
int TabOrder=40
boolean Visible=false
boolean Enabled=false
string Text="저장(&S)"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;//string	sUserid
//
//sUserId = wf_ConfirmUser()
//
//if sUserId = '-1'		then	return
//
//if f_msg_update() = -1 then return
//
///////////////////////////////////////////////////////////////////////////////////
//
//SetPointer(HourGlass!)
//st_status.text = '작업중입니다.'
//
//long	lrow
//
//FOR	lrow = 1	to		dw_list.rowcount()
//
//		dw_list.SetItem(lrow, "user_id", sUserId)
//
//NEXT
//
////////////////////////////////////////////////////////////////////////////
//
//int		iMain_id,		&
//			iSub1_id
//
//string	sConfirm
//
//
//iMain_id = dw_2.getitemnumber(dw2_CurrentRow, "main_id")
//iSub1_id = dw_2.getitemnumber(dw2_CurrentRow, "sub1_id")
//
//
//  SELECT "SUB2_USER_T"."SUB2_NAME"  
//    INTO :sConfirm  
//    FROM "SUB2_USER_T"  
//   WHERE ( "SUB2_USER_T"."USER_ID" = :sUserId ) AND  
//         ( "SUB2_USER_T"."MAIN_ID" = :iMain_id ) AND  
//         ( "SUB2_USER_T"."SUB1_ID" = 99 ) AND  
//         ( "SUB2_USER_T"."SUB2_ID" = 99 )   ;
//
//
//if sqlca.sqlcode = 100	then	
//
//  INSERT INTO "SUB2_USER_T"  
//         ( "USER_ID",   
//           "MAIN_ID",   
//           "SUB1_ID",   
//           "SUB2_ID",   
//           "SUB2_NAME",   
//           "WINDOW_NAME",   
//           "LEVEL_1",   
//           "LEVEL_2",   
//           "GUBUN" )  
//  VALUES ( :sUserid,   
//           :iMain_id,   
//           99,   
//           99,   
//           :sConfirm,   
//           null,   
//           null,   
//           null,   
//           null )  ;
//
//	commit ;
//
//end if
//
//
//setnull(sConfirm)
//
//
//  SELECT "SUB2_USER_T"."SUB2_NAME"  
//    INTO :sConfirm  
//    FROM "SUB2_USER_T"  
//   WHERE ( "SUB2_USER_T"."USER_ID" = :sUserId ) AND  
//         ( "SUB2_USER_T"."MAIN_ID" = :iMain_id ) AND  
//         ( "SUB2_USER_T"."SUB1_ID" = :iSub1_id ) AND  
//         ( "SUB2_USER_T"."SUB2_ID" = 100 )   ;
//
//
//if sqlca.sqlcode = 100	then	
//
//  INSERT INTO "SUB2_USER_T"  
//         ( "USER_ID",   
//           "MAIN_ID",   
//           "SUB1_ID",   
//           "SUB2_ID",   
//           "SUB2_NAME",   
//           "WINDOW_NAME",   
//           "LEVEL_1",   
//           "LEVEL_2",   
//           "GUBUN" )  
//  VALUES ( :sUserid,   
//           :iMain_id,   
//           :iSub1_id,   
//           100,   
//           :sConfirm,   
//           null,   
//           null,   
//           null,   
//           null )  ;
//
//	commit ;
//
//end if
//
//
//
////////////////////////////////////////////////////
//IF dw_list.Update() > 0 THEN			
//
//	COMMIT USING sqlca;
//
//ELSE
//
//	ROLLBACK USING sqlca;
//
//END IF
//
//
//
//SETPOINTER(ARROW!)
//
//
//
/////////////////////////////////////////////////////////////////////////////
//
//
//cb_cancel.TriggerEvent(clicked!)
end event

type cb_retrieve from commandbutton within w_sys_001_mdi_sheet_05
int X=1920
int Y=1776
int Width=475
int Height=96
int TabOrder=30
string Text="조회(&R)"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;string	sUserid

sUserId = wf_ConfirmUser()

IF sUserId = '-1' THEN RETURN

is_user_id = sUserId

wf_usertree_item()   //user 대분류 트리 생성



end event

type sle_userid from singlelineedit within w_sys_001_mdi_sheet_05
int X=686
int Y=1776
int Width=896
int Height=92
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
int Limit=20
TextCase TextCase=Upper!
long BackColor=16777215
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_4 from statictext within w_sys_001_mdi_sheet_05
int X=293
int Y=1800
int Width=361
int Height=72
boolean Enabled=false
string Text="USER ID :"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type tv_user from treeview within w_sys_001_mdi_sheet_05
int X=1810
int Y=36
int Width=1705
int Height=1668
BorderStyle BorderStyle=StyleRaised!
string PictureName[]={"Move!",&
"Start!",&
"Custom039!",&
"DOSEDIT5!"}
long PictureMaskColor=553648127
string StatePictureName[]={"Application!",&
"Custom050!"}
long StatePictureMaskColor=553648127
long TextColor=33554432
long BackColor=12632256
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event key;If key = keydelete! Then
	wf_treeview_delete()
End if
end event

event itempopulate;Integer				Rows, Level
TreeViewItem		tv_Current

/****  current item의 레벨을 결정한다  ************************************************/
//if ib_tag then return
this.GetItem(handle, tv_Current)
Level = tv_Current.Level

IF level = 1 then return

Rows = wf_retrieve_user(handle)          // Datastore 의 데이타를 조회   

wf_add_user(handle, Level + 1, Rows)       // 다음 레벨에 add한다.......

end event

event dragdrop;Integer				Level, ireturn
TreeViewItem		tv_Current, tv_source
string 				current_data

If tv_1.GetItem(il_oldhandle, tv_Source) = -1 Then Return

IF GetItem(handle, tv_Current) = -1 THEN RETURN 
Level = tv_Current.Level

il_newhandle = handle
itv_new = tv_current

IF itv_old.Level = 2 then
	open(w_question_popup1)
	ireturn = Message.DoubleParm
	if ireturn = 1 then
		if wf_lmove(1) = -1 then return 
	elseif ireturn = 2 then
		if wf_lmove(2) = -1 then return 
	elseif ireturn = 3 then
		if wf_lmove(3) = -1 then return 
	else
		return 
	end if
ELSEIF itv_old.Level = 3 then 
	open(w_question_popup2)
	ireturn = Message.DoubleParm
	if ireturn = 2 then
		if wf_mmove(2) = -1 then return 
	elseif ireturn = 3 then
		if wf_mmove(3) = -1 then return 
	else
		return 
	end if
ELSE	
  wf_move()
END IF  
end event

type cb_exit from commandbutton within w_sys_001_mdi_sheet_05
int X=2926
int Y=1776
int Width=475
int Height=96
int TabOrder=60
string Text="종료(&X)"
boolean Cancel=true
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;close(parent)
end event

type sle_msg from singlelineedit within w_sys_001_mdi_sheet_05
int X=375
int Y=1936
int Width=2446
int Height=84
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_datetime from datawindow within w_sys_001_mdi_sheet_05
int X=2821
int Y=1936
int Width=741
int Height=84
string DataObject="d_datetime"
boolean Border=false
boolean LiveScroll=true
end type

type st_10 from statictext within w_sys_001_mdi_sheet_05
int X=9
int Y=1936
int Width=361
int Height=84
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="메세지"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=128
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type tv_1 from treeview within w_sys_001_mdi_sheet_05
int X=78
int Y=36
int Width=1705
int Height=1668
int TabOrder=10
boolean DragAuto=true
BorderStyle BorderStyle=StyleRaised!
boolean DisableDragDrop=false
boolean LinesAtRoot=true
string PictureName[]={"Library!",&
"Start!",&
"Custom039!",&
"DOSEDIT5!",&
"DOSEDIT5!"}
long PictureMaskColor=553648127
string StatePictureName[]={"Application!",&
"GLOBAK!",&
"CUSTOM050!"}
long StatePictureMaskColor=553648127
long TextColor=33554432
long BackColor=12632256
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event begindrag;Integer				Level
TreeViewItem		tv_Current

GetItem(handle, tv_Current)
Level = tv_Current.Level
itv_old = tv_Current
IF level = 1 then 
	Messagebox("Level Check", "Drag 할 수 없읍니다")
	this.setfocus()
	return 
end if

is_drag_data = String(tv_Current.Data)
il_oldhandle = handle
il_DragParent = FindItem(ParentTreeItem!, handle)

end event

event itempopulate;Integer				Rows, Level
TreeViewItem		tv_Current

/****  current item의 레벨을 결정한다  ************************************************/
//if ib_tag then return
this.GetItem(handle, tv_Current)
Level = tv_Current.Level

IF level = 1 then return

Rows = wf_retrieve_data(handle)          // Datastore 의 데이타를 조회   

wf_add_tv(handle, Level + 1, Rows)       // 다음 레벨에 add한다.......

end event

type gb_1 from groupbox within w_sys_001_mdi_sheet_05
int X=78
int Y=1712
int Width=1705
int Height=196
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_mode1 from groupbox within w_sys_001_mdi_sheet_05
int X=1815
int Y=1712
int Width=1705
int Height=196
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

