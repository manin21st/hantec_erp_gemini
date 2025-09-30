$PBExportHeader$w_sys_0071p.srw
$PBExportComments$프로그램 별 사용자 조정
forward
global type w_sys_0071p from window
end type
type p_5 from uo_picture within w_sys_0071p
end type
type p_4 from uo_picture within w_sys_0071p
end type
type p_3 from uo_picture within w_sys_0071p
end type
type p_2 from uo_picture within w_sys_0071p
end type
type p_1 from uo_picture within w_sys_0071p
end type
type dw_insert from datawindow within w_sys_0071p
end type
type sle_msg from singlelineedit within w_sys_0071p
end type
type dw_datetime from datawindow within w_sys_0071p
end type
type st_10 from statictext within w_sys_0071p
end type
type tv_1 from treeview within w_sys_0071p
end type
type rr_1 from roundrectangle within w_sys_0071p
end type
type rr_2 from roundrectangle within w_sys_0071p
end type
end forward

global type w_sys_0071p from window
integer width = 4658
integer height = 2460
boolean titlebar = true
string title = "프로그램 별 사용자 "
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_5 p_5
p_4 p_4
p_3 p_3
p_2 p_2
p_1 p_1
dw_insert dw_insert
sle_msg sle_msg
dw_datetime dw_datetime
st_10 st_10
tv_1 tv_1
rr_1 rr_1
rr_2 rr_2
end type
global w_sys_0071p w_sys_0071p

type variables
// 자료변경여부 검사
boolean  ib_any_typing

String  c_status = '1'

/************* tree용 *****************************/
Datastore ids_data[3]
string      is_drag_data
String		is_window_id, is_today, is_totime, is_usegub
long        il_oldhandle,  il_newhandle, il_dragparent, &
            il_droptarget
TreeViewItem     itv_old, itv_new


int		ii_main, ii_sub1, ii_sub2
string	is_sub2_nm, is_window_nm
end variables

forward prototypes
public subroutine wf_treeview_delete ()
public function integer wf_warndataloss (string as_titletext)
public subroutine wf_move ()
public function integer wf_retrieve_data (long al_handle)
public subroutine wf_treeview_item ()
public function integer wf_chk ()
public function integer wf_confirmkey ()
public subroutine wf_modify2 (string sgub)
public function integer wf_add_tv (long al_parent, integer i_level, integer i_rows)
public subroutine wf_modify (string sgub)
end prototypes

public subroutine wf_treeview_delete ();//treeviewitem tvi_curr, tvi_prve
//Long 		currenthandle, Parenthandle
//String 	suser, sgroup
//
//currenthandle = tv_1.finditem(currenttreeitem!, 0)
//If tv_1.getitem(currenthandle, tvi_curr)		  = -1 Then Return
//Parenthandle = tv_1.finditem(parenttreeitem!, currenthandle)
//If tv_1.getitem(parenthandle, tvi_Prve) = -1 Then Return
//
//sgroup = tvi_prve.label
//suser  = tvi_curr.label
//
//If Messagebox("삭제확인", "Group -> " + sgroup + '~n' + &
//								  "User  -> " + suser  + " 를 삭제하시겠읍니까?", question!, yesno!, 2) = 1 Then
//
//   /* Treeview에서 삭제 */
//	tv_1.DeleteItem(currenthandle)	
//								  
//	/* User Menu삭제 */
//	Delete From sub2_user_t
//		   Where user_id = :suser;
//
//	/* User 삭제 */
//	Delete from login_t 
//		   Where l_userid = :suser;
//			
//	Commit;	
//							  
//end if
end subroutine

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

public subroutine wf_move ();string old_name
long   old_level, level,new_handle, max_sub2_id
int    old_main, old_sub1, old_sub2, new_main, new_sub1, new_sub2
treeviewitem tv_insert,tv_new

//ib_tag = true

if il_newhandle = il_oldhandle then return    //같은 라인은 drag 안됨
if il_newhandle = tv_1.finditem(ParentTreeItem!,il_oldhandle) then return //같은 트리도 안됨
if itv_old.Level <> itv_new.Level + 1 then return //level 3, 4 에서는 자기 level로 drag 안됨 
old_Level = itv_old.Level

old_main = integer(left(string(itv_old.data), 5))
old_sub1 = integer(mid(string(itv_old.data), 6, 5))
old_sub2 = integer(mid(string(itv_old.data), 11, 5))

new_main = integer(left(string(itv_new.data), 5))
new_sub1 = integer(mid(string(itv_new.data), 6, 5))
new_sub2 = integer(mid(string(itv_new.data), 11, 5))

if old_level = 4 then
//	UPDATE "SUB2_T"  
//		SET "MAIN_ID" = :,   
//			 "SUB1_ID" = fd,   
//			 "SUB2_ID" = adsfsub2_name,   
//			 "SUB2_NAME" = null  
//	 WHERE ( "SUB2_T"."MAIN_ID" = :old_main ) AND  
//			 ( "SUB2_T"."SUB1_ID" = :old_sub1 ) AND  
//			 ( "SUB2_T"."SUB2_ID" = :old_sub2 )   ;
//
//	UPDATE "SUB2_T"  
//		SET "MAIN_ID" = afs,   
//			 "SUB1_ID" = fd,   
//			 "SUB2_ID" = adsfsub2_name,   
//			 "SUB2_NAME" = null  
//	 WHERE ( "SUB2_T"."MAIN_ID" = 12 ) AND  
//			 ( "SUB2_T"."SUB1_ID" = 13 ) AND  
//			 ( "SUB2_T"."SUB2_ID" = 143 )   ;
//
//else
  SELECT MAX("SUB2_T"."SUB2_ID")  
    INTO :max_sub2_id  
    FROM "SUB2_T"  
   WHERE ( "SUB2_T"."MAIN_ID" = :new_main ) AND  
         ( "SUB2_T"."SUB1_ID" = :new_sub1 ) AND  
         ( "SUB2_T"."SUB2_ID" <> 100 ) AND  
         ( "SUB2_T"."SUB2_ID" <> 99 )   ;

	if isnull(max_sub2_id) then max_sub2_id = 0
	if max_sub2_id = 97 then
   	max_sub2_id = max_sub2_id + 4
   elseif max_sub2_id = 98 then 
   	max_sub2_id = max_sub2_id + 3
	else
		max_sub2_id = max_sub2_id + 2
   end if
	
	if max_sub2_id > 99999 then 
		messagebox('System Error!','소분류가 5자리를 넘어가니 조정 후 처리하기 바랍니다.!!')
      return 
   end if	
	
	UPDATE "SUB2_T"  
		SET "MAIN_ID" = :new_main,   
			 "SUB1_ID" = :new_sub1,   
			 "SUB2_ID" = :max_sub2_id
	 WHERE ( "SUB2_T"."MAIN_ID" = :old_main ) AND  
			 ( "SUB2_T"."SUB1_ID" = :old_sub1 ) AND  
			 ( "SUB2_T"."SUB2_ID" = :old_sub2 )   ;
end if

If sqlca.sqlcode <> 0 then
	Messagebox("SQL Error", "변경중 오류가 발생", stopsign!)
	Rollback;
	return
Else
	UPDATE "SUB2_USER_T"  
		SET "MAIN_ID" = :new_main,   
			 "SUB1_ID" = :new_sub1,   
			 "SUB2_ID" = :max_sub2_id
	 WHERE ( "SUB2_USER_T"."MAIN_ID" = :old_main ) AND  
			 ( "SUB2_USER_T"."SUB1_ID" = :old_sub1 ) AND  
			 ( "SUB2_USER_T"."SUB2_ID" = :old_sub2 )   ;
	If sqlca.sqlcode <> 0 then
		Messagebox("SQL Error", "변경중 오류가 발생", stopsign!)
		Rollback;
		return
	Else
   	Commit;
	End If	
End if
						
//itv_new.children = true
//tv_1.CollapseItem ( il_newhandle )
//tv_1.expanditem( il_newhandle )
//tv_1.setitem(il_newhandle,itv_new)
//tv_1.expanditem( il_newhandle )
//tv_1.CollapseItem ( il_newhandle )
//
Level = itv_new.Level
tv_insert.data  = string(new_main, "00000") + string(new_sub1, "00000") + &
	               string(max_sub2_id, "00000")
						 
old_name = itv_old.label
tv_insert.label = old_name
tv_insert.PictureIndex = level + 1
tv_insert.SelectedPictureindex = level + 1
tv_insert.children = itv_old.children
itv_new.children = true
itv_new.PictureIndex = itv_new.level
itv_new.SelectedPictureindex = itv_new.level
tv_1.setitem(il_newhandle,itv_new)

new_handle = tv_1.InsertItemLast(il_newhandle, tv_insert)

If new_handle < 1 Then
	MessageBox("Error", "Error inserting item", Exclamation!)
	Return 
End If
tv_1.deleteitem(il_oldhandle)
tv_1.ExpandItem(il_newhandle)
tv_1.deleteitem(il_oldhandle)

end subroutine

public function integer wf_retrieve_data (long al_handle);Integer				i_level, i_current_data, i_sub1
string            s_current_data
TreeViewItem		tv_Current

String sdigital
if gs_digital = 'D' then
	sdigital = '%'
Else
	sdigital = 'E'
End if

/*****  현재의 level 을 결정  ************************************************/
tv_1.GetItem(al_Handle, tv_Current)
i_level = tv_Current.Level

/* datastore의 argument를 구한다.(현재레벨의 데이타값을 구함) ****************/
s_current_data = String(tv_Current.Data)
i_current_data = integer(trim(left(s_current_data, 5)))
i_sub1         = integer(trim(mid(s_current_data, 6, 5)))

choose case i_level
   case 2
      Return ids_data[2].Retrieve(i_current_data, sdigital)
	case 3
		Return ids_data[3].Retrieve(i_current_data, i_sub1, sdigital)
   case else
      Return 0
End choose


end function

public subroutine wf_treeview_item ();/* Treeview내역을 생성 */
Treeviewitem   ltvi_Root, tv_new
Long				ll_Root, ll_New, i_cnt, l_row, ll_tvi, l_main

String sdigital
if gs_digital = 'D' then
	sdigital = '%'
Else
	sdigital = 'E'
End if

/* 전체내역을 삭제 */
long tvi_hdl = 0

DO UNTIL tv_1.FindItem(RootTreeItem!, 0) = -1	
	      tv_1.DeleteItem(tvi_hdl)
LOOP

Setpointer(Hourglass!)

/* 프로그램 대분류를 Retrieve */
If ids_data[1].Retrieve(sdigital) < 1 then 
	Setpointer(Arrow!)
	return
End If 

/* 첫번째 레벨을 등록하고 ........................... */
ltvi_Root.Data = '000000000000000'
ltvi_Root.Label= 'ERPMAN'    
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

public function integer wf_chk ();
dw_insert.accepttext()

int	iConfirm,	&
		iSub1_id,	&
		iSub2_id

iConfirm = dw_insert.getitemnumber(1, 'main_id')
if isnull(iconfirm) or iconfirm = 0	then
	messagebox("확 인", "대분류코드를 입력하세요")
	dw_insert.setcolumn('main_id')
	dw_insert.setfocus()
	return -1
end if


iSub1_id = dw_insert.getitemnumber(1, 'sub1_id')
if isnull(iSub1_id) or iSub1_id = 0	then
	messagebox("확 인", "중분류코드를 입력하세요")
	dw_insert.setcolumn('sub1_id')
	dw_insert.setfocus()
	return -1
end if


iSub2_id = dw_insert.getitemnumber(1, 'sub2_id')
if isnull(iSub2_id) or iSub2_id = 0	then
	messagebox("확 인", "소분류코드를 입력하세요")
	dw_insert.setcolumn('sub2_id')
	dw_insert.setfocus()
	return -1
end if


//
string	sCode

sCode = dw_insert.getitemstring(1, 'sub2_name')

if isnull(scode) or scode = ''	then
   if isub2_id = 99 then
		messagebox("확인", "대분류 명을 입력하세요")
		dw_insert.setcolumn('sub2_name')
		dw_insert.setfocus()
		return -1
   elseif isub2_id = 100 then
		messagebox("확인", "중분류 명을 입력하세요")
		dw_insert.setcolumn('sub2_name')
		dw_insert.setfocus()
		return -1
   elseif isub2_id = 100 then
		messagebox("확인", "Window 명을 입력하세요")
		dw_insert.setcolumn('sub2_name')
		dw_insert.setfocus()
		return -1
   end if
end if


if ( isub1_id = 99  and isub2_id = 99 ) then return 1
if  isub2_id = 100							 then return 1


sCode = dw_insert.getitemstring(1, 'window_name')

if isnull(scode) or scode = ''	then
		messagebox("확인", "WINDOW ID 를 입력하세요")
		dw_insert.setcolumn('window_name')
		dw_insert.setfocus()
		return -1
end if


return 1
end function

public function integer wf_confirmkey ();int	iMain_id,	 	&
		iSub1_id, 		&
		iSub2_id,		&
		iConfirm
string	sconfirm
dw_insert.accepttext()

iMain_id = dw_insert.GetItemNumber(1, 'main_id')
iSub1_id = dw_insert.GetItemNumber(1, 'sub1_id')
iSub2_id = dw_insert.GetItemNumber(1, 'sub2_id')

  SELECT "SUB2_T"."MAIN_ID"  
    INTO :iConfirm  
    FROM "SUB2_T"  
   WHERE ( "SUB2_T"."MAIN_ID" = :iMain_id ) AND  
         ( "SUB2_T"."SUB1_ID" = :iSub1_id ) AND  
         ( "SUB2_T"."SUB2_ID" = :iSub2_id )   ;

IF sqlca.sqlcode = 0 	then	
	f_message_chk(37, "[대/중/소 분류]")
	dw_insert.setcolumn('sub2_id')
	dw_insert.SetFocus()
	RETURN -1 
END IF
////////////////////////////////////////////////////////////////////////
IF (iSUB1_ID = 99)	AND (iSUB2_ID = 99) 	THEN	

  SELECT "SUB2_T"."SUB2_NAME"  
    INTO :sConfirm  
    FROM "SUB2_T"  
   WHERE ( "SUB2_T"."MAIN_ID" = :iMain_id ) AND  
         ( "SUB2_T"."SUB1_ID" = 99 ) AND  
         ( "SUB2_T"."SUB2_ID" = 99 )   ;

	if sqlca.sqlcode = 0	then	
		f_message_chk(37, "[대분류]")
		dw_insert.setcolumn('main_id')
   	dw_insert.SetFocus()
		RETURN -1
	end if
END IF
//////////////////////////////////////////////////////////////////////////////////////////////
IF  (iSUB2_ID = 100) 	THEN

	SELECT "SUB2_T"."SUB2_NAME"  
	 INTO :sConfirm  
	 FROM "SUB2_T"  
	WHERE ( "SUB2_T"."MAIN_ID" = :iMain_id ) AND  
			( "SUB2_T"."SUB1_ID" = :iSub1_id ) AND  
			( "SUB2_T"."SUB2_ID" = 100 )   ;

	if sqlca.sqlcode = 0	then	
		f_message_chk(37, "[대/중 분류]")
		dw_insert.setcolumn('sub1_id')
		dw_insert.SetFocus()
   	RETURN -1
	end if
END IF

RETURN 1
end function

public subroutine wf_modify2 (string sgub);//BackGround.Color ==> 12639424:Mint, 65535:노란색, 16777215:횐색, 12632256:회색	
dw_insert.setredraw(false)

IF sgub = 'E' THEN
	dw_insert.Modify("main_id.TabSequence = 0")
	dw_insert.Modify("sub1_id.TabSequence = 0")
	dw_insert.Modify("sub2_id.TabSequence = 0")
//	dw_insert.Modify("main_id.BackGround.Color= 12632256") 
//	dw_insert.Modify("sub1_id.BackGround.Color= 12632256") 
//	dw_insert.Modify("sub2_id.BackGround.Color= 12632256") 

	dw_insert.Modify("sub2_name.TabSequence = 50")
	dw_insert.Modify("window_name.TabSequence = 60")
	dw_insert.Modify("password.TabSequence = 70")
	dw_insert.Modify("open_history.TabSequence = 80")
	
//	dw_insert.Modify("window_name.BackGround.Color = 16777215")
//	dw_insert.Modify("password.BackGround.Color = 16777215")
//	dw_insert.Modify("open_history.BackGround.Color = 16777215")
	
	dw_insert.Object.sub2_name_t.Text = 'Window 명'
	
ELSEIF sgub = 'A' THEN
	dw_insert.Modify("main_id.TabSequence = 0")
	dw_insert.Modify("sub1_id.TabSequence = 0")
	dw_insert.Modify("sub2_id.TabSequence = 0")
//	dw_insert.Modify("main_id.BackGround.Color= 12632256") 
//	dw_insert.Modify("sub1_id.BackGround.Color= 12632256") 
//	dw_insert.Modify("sub2_id.BackGround.Color= 12632256") 

	dw_insert.Modify("sub2_name.TabSequence = 50")
	dw_insert.Modify("window_name.TabSequence = 0")
	dw_insert.Modify("password.TabSequence = 0")
	dw_insert.Modify("open_history.TabSequence = 0")
	
//	dw_insert.Modify("window_name.BackGround.Color = 12632256")
//	dw_insert.Modify("password.BackGround.Color = 12632256")
//	dw_insert.Modify("open_history.BackGround.Color = 12632256")
	
	dw_insert.Object.sub2_name_t.Text = '중분류 명'

ELSEIF sgub = 'T' THEN
	dw_insert.Modify("main_id.TabSequence = 0")
	dw_insert.Modify("sub1_id.TabSequence = 0")
	dw_insert.Modify("sub2_id.TabSequence = 0")
//	dw_insert.Modify("main_id.BackGround.Color= 12632256") 
//	dw_insert.Modify("sub1_id.BackGround.Color= 12632256") 
//	dw_insert.Modify("sub2_id.BackGround.Color= 12632256") 

	dw_insert.Modify("sub2_name.TabSequence = 50")
	dw_insert.Modify("window_name.TabSequence = 0")
	dw_insert.Modify("password.TabSequence = 0")
	dw_insert.Modify("open_history.TabSequence = 0")

//	dw_insert.Modify("window_name.BackGround.Color = 12632256")
//	dw_insert.Modify("password.BackGround.Color = 12632256")
//	dw_insert.Modify("open_history.BackGround.Color = 12632256")

	dw_insert.Object.sub2_name_t.Text = '대분류 명'

END IF

//cb_delete.enabled = true
ib_any_typing = false
c_status = '2'

dw_insert.setredraw(true)

end subroutine

public function integer wf_add_tv (long al_parent, integer i_level, integer i_rows);Integer				i_Cnt, i_sub1_id, i_main_id, k
long              cnt
TreeViewItem		tv_New
String   sWindow_name
k = i_level - 1

For i_Cnt = 1 To i_Rows
   i_main_id     = ids_data[k].Object.main_id[i_cnt]
	i_sub1_id     = ids_data[k].Object.sub1_id[i_cnt]
	sWindow_name  = ids_data[k].Object.window_name[i_cnt]
	if isNull(sWindow_name) or sWindow_name = '' then sWindow_name = 'Nul'
	
	tv_New.data   = string(ids_data[k].Object.main_id[i_cnt], "00000") + &
	                string(ids_data[k].Object.sub1_id[i_cnt], "00000") + &
	                string(ids_data[k].Object.sub2_id[i_cnt], "00000") + sWindow_name 
						 
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

public subroutine wf_modify (string sgub);//BackGround.Color ==> 12639424:Mint, 65535:노란색, 16777215:횐색, 12632256:회색	
int inull
string snull

setnull(inull)
setnull(snull)

dw_insert.setredraw(false)

dw_insert.reset()
dw_insert.insertrow(0)

IF sgub = 'E' THEN
	dw_insert.Modify("main_id.TabSequence = 20")
	dw_insert.Modify("sub1_id.TabSequence = 30")
	dw_insert.Modify("sub2_id.TabSequence = 40")
//	dw_insert.Modify("main_id.BackGround.Color= 65535") 
//	dw_insert.Modify("sub1_id.BackGround.Color= 65535") 
//	dw_insert.Modify("sub2_id.BackGround.Color= 65535") 

	dw_insert.Modify("sub2_name.TabSequence = 50")
	dw_insert.Modify("window_name.TabSequence = 60")
	dw_insert.Modify("password.TabSequence = 70")
	dw_insert.Modify("open_history.TabSequence = 80")
	
//	dw_insert.Modify("window_name.BackGround.Color = 16777215")
//	dw_insert.Modify("password.BackGround.Color = 16777215")
//	dw_insert.Modify("open_history.BackGround.Color = 16777215")
	
	dw_insert.Object.sub2_name_t.Text = 'Window 명'
	
	dw_insert.SetItem(1, "io_gubun", 'E')
	
	dw_insert.SetItem(1, "main_id", inull)
	dw_insert.SetItem(1, "sub1_id", inull)
	dw_insert.SetItem(1, "sub2_id", inull)
	dw_insert.SetItem(1, "sub2_name", snull)
ELSEIF sgub = 'R' THEN
	dw_insert.Modify("main_id.TabSequence = 20")
	dw_insert.Modify("sub1_id.TabSequence = 30")
	dw_insert.Modify("sub2_id.TabSequence = 40")
//	dw_insert.Modify("main_id.BackGround.Color= 65535") 
//	dw_insert.Modify("sub1_id.BackGround.Color= 65535") 
//	dw_insert.Modify("sub2_id.BackGround.Color= 65535") 

	dw_insert.Modify("sub2_name.TabSequence = 50")
	dw_insert.Modify("window_name.TabSequence = 60")
	dw_insert.Modify("password.TabSequence = 70")
	dw_insert.Modify("open_history.TabSequence = 80")
	
//	dw_insert.Modify("window_name.BackGround.Color = 16777215")
//	dw_insert.Modify("password.BackGround.Color = 16777215")
//	dw_insert.Modify("open_history.BackGround.Color = 16777215")
	
	dw_insert.Object.sub2_name_t.Text = 'Window 명'
	
	dw_insert.SetItem(1, "io_gubun", 'R')
	
	dw_insert.SetItem(1, "main_id", inull)
	dw_insert.SetItem(1, "sub1_id", inull)
	dw_insert.SetItem(1, "sub2_id", inull)
	dw_insert.SetItem(1, "sub2_name", snull)
ELSEIF sgub = 'P' THEN
	dw_insert.Modify("main_id.TabSequence = 20")
	dw_insert.Modify("sub1_id.TabSequence = 30")
	dw_insert.Modify("sub2_id.TabSequence = 40")
//	dw_insert.Modify("main_id.BackGround.Color= 65535") 
//	dw_insert.Modify("sub1_id.BackGround.Color= 65535") 
//	dw_insert.Modify("sub2_id.BackGround.Color= 65535") 

	dw_insert.Modify("sub2_name.TabSequence = 50")
	dw_insert.Modify("window_name.TabSequence = 60")
	dw_insert.Modify("password.TabSequence = 70")
	dw_insert.Modify("open_history.TabSequence = 80")
	
//	dw_insert.Modify("window_name.BackGround.Color = 16777215")
//	dw_insert.Modify("password.BackGround.Color = 16777215")
//	dw_insert.Modify("open_history.BackGround.Color = 16777215")
	
	dw_insert.Object.sub2_name_t.Text = 'Window 명'
	
	dw_insert.SetItem(1, "io_gubun", 'P')
	
	dw_insert.SetItem(1, "main_id", inull)
	dw_insert.SetItem(1, "sub1_id", inull)
	dw_insert.SetItem(1, "sub2_id", inull)
	dw_insert.SetItem(1, "sub2_name", snull)
ELSEIF sgub = 'A' THEN
	dw_insert.Modify("main_id.TabSequence = 20")
	dw_insert.Modify("sub1_id.TabSequence = 30")
	dw_insert.Modify("sub2_id.TabSequence = 0")
//	dw_insert.Modify("main_id.BackGround.Color= 65535") 
//	dw_insert.Modify("sub1_id.BackGround.Color= 65535") 
//	dw_insert.Modify("sub2_id.BackGround.Color= 12632256") 

	dw_insert.Modify("sub2_name.TabSequence = 50")
	dw_insert.Modify("window_name.TabSequence = 0")
	dw_insert.Modify("password.TabSequence = 0")
	dw_insert.Modify("open_history.TabSequence = 0")
	
//	dw_insert.Modify("window_name.BackGround.Color = 12632256")
//	dw_insert.Modify("password.BackGround.Color = 12632256")
//	dw_insert.Modify("open_history.BackGround.Color = 12632256")
	
	dw_insert.Object.sub2_name_t.Text = '중분류 명'

	dw_insert.SetItem(1, "io_gubun", 'A')
	dw_insert.SetItem(1, "main_id", inull)
	dw_insert.SetItem(1, "sub1_id", inull)
	dw_insert.SetItem(1, "sub2_id", 100)
	dw_insert.SetItem(1, "sub2_name", snull)
ELSEIF sgub = 'T' THEN
	dw_insert.Modify("main_id.TabSequence = 20")
	dw_insert.Modify("sub1_id.TabSequence = 0")
	dw_insert.Modify("sub2_id.TabSequence = 0")
//	dw_insert.Modify("main_id.BackGround.Color= 65535") 
//	dw_insert.Modify("sub1_id.BackGround.Color= 12632256") 
//	dw_insert.Modify("sub2_id.BackGround.Color= 12632256") 

	dw_insert.Modify("sub2_name.TabSequence = 50")
	dw_insert.Modify("window_name.TabSequence = 0")
	dw_insert.Modify("password.TabSequence = 0")
	dw_insert.Modify("open_history.TabSequence = 0")

//	dw_insert.Modify("window_name.BackGround.Color = 12632256")
//	dw_insert.Modify("password.BackGround.Color = 12632256")
//	dw_insert.Modify("open_history.BackGround.Color = 12632256")

	dw_insert.Object.sub2_name_t.Text = '대분류 명'

	dw_insert.SetItem(1, "io_gubun", 'T')
	dw_insert.SetItem(1, "main_id", inull)
	dw_insert.SetItem(1, "sub1_id", 99)
	dw_insert.SetItem(1, "sub2_id", 99)
	dw_insert.SetItem(1, "sub2_name", snull)
END IF

//cb_delete.enabled = false
ib_any_typing = false
c_status = '1'

dw_insert.setredraw(true)

end subroutine

on w_sys_0071p.create
this.p_5=create p_5
this.p_4=create p_4
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.dw_insert=create dw_insert
this.sle_msg=create sle_msg
this.dw_datetime=create dw_datetime
this.st_10=create st_10
this.tv_1=create tv_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_5,&
this.p_4,&
this.p_3,&
this.p_2,&
this.p_1,&
this.dw_insert,&
this.sle_msg,&
this.dw_datetime,&
this.st_10,&
this.tv_1,&
this.rr_1,&
this.rr_2}
end on

on w_sys_0071p.destroy
destroy(this.p_5)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_insert)
destroy(this.sle_msg)
destroy(this.dw_datetime)
destroy(this.st_10)
destroy(this.tv_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;
ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

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


ids_Data[1] = Create DataStore
ids_Data[1].DataObject = "d_sys_001_mdi_sheet_04_1"  // 대분류 테이타

ids_Data[2] = Create DataStore
ids_Data[2].DataObject = "d_sys_001_mdi_sheet_04_2"  // 중분류 테이타       

ids_Data[3] = Create DataStore
ids_Data[3].DataObject = "d_sys_001_mdi_sheet_04_3"  // 프로그램 테이타       

Ids_data[1].setTransobject(sqlca)
Ids_data[2].setTransobject(sqlca)
Ids_data[3].setTransobject(sqlca)

ids_data[2].SetFilter("isnull(del_status)")
ids_data[3].SetFilter("isnull(del_status)")
ids_data[2].filter()
ids_data[3].filter()

wf_treeview_item()   //대분류 트리 생성
//f_window_center(This)
dw_insert.settransobject(sqlca)
dw_insert.insertrow(0)
dw_datetime.insertrow(0)

setnull(ii_main)
setnull(ii_sub1)
setnull(ii_sub2)
setnull(is_sub2_nm)
setnull(is_window_nm)

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

long li_index

li_index = w_mdi_frame.lv_open_menu.FindItem(0,This.Title, TRUE,TRUE)

w_mdi_frame.lv_open_menu.DeleteItem(li_index)
w_mdi_frame.st_window.Text = ""
end event

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
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

event key;Choose Case key
//	Case KeyW!
	//	p_print.TriggerEvent(Clicked!)
//	Case KeyQ!
	//	p_inq.TriggerEvent(Clicked!)
	Case KeyT!
		p_5.TriggerEvent(Clicked!)
//	Case KeyA!
	//	p_addrow.TriggerEvent(Clicked!)
	//Case KeyE!
		//p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_1.TriggerEvent(Clicked!)
	Case KeyD!
		p_2.TriggerEvent(Clicked!)
	Case KeyC!
		p_3.TriggerEvent(Clicked!)
	Case KeyX!
		p_4.TriggerEvent(Clicked!)
End Choose
end event

type p_5 from uo_picture within w_sys_0071p
boolean visible = false
integer x = 2638
integer y = 28
integer width = 178
string pointer = "C:\erpman\cur\update.cur"
boolean enabled = false
string picturename = "C:\ERPMAN\image\추가_up.gif"
end type

event clicked;call super::clicked;//long ll_row
//string ls_sub2_nm, ls_win_nm
//
//
//if isnull(ii_main) then return
//
//if isnull(ii_sub1) then return
//
//if isnull(ii_sub2) then return
//
//IF dw_insert.Accepttext() = -1 THEN RETURN
//
//ll_row = dw_insert.insertrow(0)
//
//
//select sub2_name, window_name
//  into :ls_sub2_nm, :ls_win_nm
//from sub2_t
//where main_id = :ii_main
//  and sub1_id = :ii_sub1
//  and sub2_id = :ii_sub2 ;
//
//
//dw_insert.setitem(ll_row,'main_id',ii_main)
//dw_insert.setitem(ll_row,'sub1_id',ii_sub1)
//dw_insert.setitem(ll_row,'sub2_id',ii_sub2)
//
//dw_insert.setitem(ll_row,'sub2_name',ls_sub2_nm)
//dw_insert.setitem(ll_row,'window_name',ls_win_nm)
//
//
//dw_insert.scrolltorow(ll_row)
//dw_insert.setrow(ll_row)
//dw_insert.setcolumn('user_id')
//dw_insert.setfocus( )
//
//
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\추가_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\추가_up.gif'
end event

type p_4 from uo_picture within w_sys_0071p
integer x = 4320
integer y = 28
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

event clicked;call super::clicked;
IF wf_warndataloss("종료") = -1 THEN  	RETURN


close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\닫기_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\닫기_dn.gif'
end event

type p_3 from uo_picture within w_sys_0071p
integer x = 4146
integer y = 28
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\ERPMAN\image\취소_up.gif"
end type

event clicked;call super::clicked;c_status = '1'  //등록 모드

dw_insert.setredraw(false)
dw_insert.reset()

//dw_insert.insertrow(0)
//dw_insert.Modify("main_id.TabSequence = 20")
//dw_insert.Modify("sub1_id.TabSequence = 30")
//dw_insert.Modify("sub2_id.TabSequence = 40")
//dw_insert.Modify("sub2_name.TabSequence = 50")
//dw_insert.Modify("window_name.TabSequence = 60")
//dw_insert.Modify("password.TabSequence = 70")
//dw_insert.Modify("open_history.TabSequence = 80")
//
////dw_insert.Modify("main_id.BackGround.Color= 65535") 
////dw_insert.Modify("sub1_id.BackGround.Color= 65535") 
////dw_insert.Modify("sub2_id.BackGround.Color= 65535") 
////dw_insert.Modify("window_name.BackGround.Color = 16777215")
////dw_insert.Modify("password.BackGround.Color = 16777215")
////dw_insert.Modify("open_history.BackGround.Color = 16777215")
//
//dw_insert.Object.sub2_name_t.Text = 'Window 명'
//
//dw_insert.SetColumn('main_id')
//dw_insert.SetFocus()

dw_insert.setredraw(true)

/////////////////////////////////////////////////

//cb_delete.enabled = false

ib_any_typing = false


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\취소_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\취소_dn.gif'
end event

type p_2 from uo_picture within w_sys_0071p
boolean visible = false
integer x = 2839
integer y = 36
integer width = 178
string pointer = "C:\erpman\cur\delete.cur"
boolean enabled = false
string picturename = "C:\ERPMAN\image\삭제_up.gif"
end type

event clicked;call super::clicked;//int	 iMain_id, iSub1_id, iSub2_id,	iConfirm
//string s_login
//long ll_row
//
//IF dw_insert.AcceptText() = -1	THEN	RETURN
//
//ll_row = dw_insert.getrow()
//if ll_row < 1 then return
//
//iMain_id = dw_insert.GetItemNumber(ll_row, 'main_id')
//iSub1_id = dw_insert.GetItemNumber(ll_row, 'sub1_id')
//iSub2_id = dw_insert.GetItemNumber(ll_row, 'sub2_id')
//													
//s_login = dw_insert.GetItemString( ll_row, "user_id" )		
//
//Beep (1)
//
//IF	 MessageBox("삭제 확인", s_login + " 사용자를~r삭제하시겠습니까? ", &
//						         question!, yesno!)  = 2		THEN	RETURN
//									
//									
//DELETE FROM "SUB2_USER_T"
//	WHERE ( "SUB2_USER_T"."MAIN_ID" = :iMain_id ) AND
//			( "SUB2_USER_T"."SUB1_ID" = :iSub1_id ) AND
//			( "SUB2_USER_T"."SUB2_ID" = :iSub2_id ) AND
//			( "SUB2_USER_T"."USER_ID" = :s_login );
//
//if sqlca.sqlcode <> 0 then 
//	rollback ;
//	return 
//else
//	commit ;
//	dw_insert.retrieve(iMain_id, iSub1_id, iSub2_id)
//end if	
//
//
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\삭제_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\삭제_dn.gif'
end event

type p_1 from uo_picture within w_sys_0071p
boolean visible = false
integer x = 3063
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\update.cur"
boolean enabled = false
string picturename = "C:\ERPMAN\image\저장_up.gif"
end type

event clicked;call super::clicked;//string ls_user_id
//
//
//IF dw_insert.Accepttext() = -1 THEN 	RETURN
//
//
//
//if f_msg_update() = -1 then return
//
//string sio_gubun, sold_gubun, swindow_id, swindow_nm, snew
//
//ls_user_id  = dw_insert.getitemstring(1, 'user_id')
//
//IF dw_insert.Update(true, false) > 0 THEN
//			
//			if sqlca.sqlcode <> 0 then
//				rollback ;
//				messagebox("확인", "데이타 저장 실패!!!")
//				return
//			end if
//		COMMIT;		
//		dw_insert.ResetUpdate()
//		
//ELSE
//	   ROLLBACK;
//	   f_message_chk(32, "[저장실패]")
//END IF
//
//
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\저장_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\저장_dn.gif'
end event

type dw_insert from datawindow within w_sys_0071p
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 2473
integer y = 196
integer width = 2011
integer height = 2048
integer taborder = 20
string dataobject = "d_sys_0071p_1"
boolean vscrollbar = true
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

event editchanged;ib_any_typing = true
end event

event itemerror;return 1
end event

event rowfocuschanged;IF CURRENTROW > 0 THEN
	THIS.SElectrow( 0, FALSE)
	THIS.SElectrow( CURRENTROW, TRUE)
	THIS.SETROw(CURRENTROW)
END IF
end event

event rbuttondown;
string	sItem,sNull, sittyp
long		lrow

setnull(snull)
setnull(gs_code)
setnull(gs_codename)


lrow = this.getrow()

IF	this.Getcolumnname() = "user_id"	THEN		
	Open(w_sys_user_id_popup)

//	IF isnull(gs_Code)  or  gs_Code = ''	then 
//			this.SetItem(1, "user_id", snull)
//		return
//	end if

	this.SetItem(lrow, "user_id", gs_Code)
	
	this.triggerevent(itemchanged!)

END IF

end event

event itemchanged;
string	sCode, ls_empno, ls_dept, ls_empnm, sNull	
long		lRow
lRow = this.GetRow()
SetNull(sNull)


IF this.GetColumnName() = 'user_id' THEN

	sCode = this.gettext()
	
  SELECT LOGIN_T.L_EMPNO,
         P0_DEPT.DEPTNAME2,
         P1_MASTER.EMPNAME
   INTO :ls_empno, :ls_dept, :ls_empnm 			
    FROM LOGIN_T,
         P0_DEPT,
         P1_MASTER
   WHERE ( login_t.l_dept = p0_dept.deptcode (+)) and
         ( login_t.l_empno = p1_master.empno (+)) and
         ( LOGIN_T.L_GUBUN <> 0 ) and
             LOGIN_T.L_USERID = :sCode ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[user_id]')
		this.setitem(lrow, "userid", sNull)
		return 1
	end if
	
	this.setitem(lrow, "login_t_l_empno", ls_empno)
	this.setitem(lrow, "p1_master_empname", ls_empnm)
	this.setitem(lrow, "vndmst_cvnas", ls_dept)
	 
END IF
end event

event clicked;IF ROW > 0 THEN
	THIS.SElectrow( 0, FALSE)
	THIS.SElectrow( ROW, TRUE)
	THIS.SETROw(ROW)
END IF
end event

type sle_msg from singlelineedit within w_sys_0071p
integer x = 389
integer y = 2524
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

type dw_datetime from datawindow within w_sys_0071p
integer x = 2834
integer y = 2524
integer width = 741
integer height = 84
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type st_10 from statictext within w_sys_0071p
integer x = 23
integer y = 2524
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

type tv_1 from treeview within w_sys_0071p
integer x = 82
integer y = 172
integer width = 2263
integer height = 2072
integer taborder = 10
string dragicon = "Application!"
boolean dragauto = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean border = false
boolean linesatroot = true
boolean disabledragdrop = false
string picturename[] = {"Library!","Start!","Custom039!","DOSEDIT5!","DOSEDIT5!"}
long picturemaskcolor = 553648127
string statepicturename[] = {"Application!","GLOBAK!","CUSTOM050!"}
long statepicturemaskcolor = 553648127
end type

event begindrag;//Integer				Level
//TreeViewItem		tv_Current
//
//GetItem(handle, tv_Current)
//Level = tv_Current.Level
//itv_old = tv_Current
//IF level = 1 or level = 2 or level = 3 then 
//	Messagebox("Level Check", "Drag 할 수 없읍니다")
//	This.Drag(Cancel!)
//end if
//
//is_drag_data = String(tv_Current.Data)
//il_oldhandle = handle
//il_dragparent = finditem(parenttreeitem!, handle)
end event

event dragdrop;//Integer				Level
//TreeViewItem		tv_Current
//string 				current_data
//GetItem(handle, tv_Current)
//Level = tv_Current.Level
//
//il_newhandle = handle
//itv_new = tv_current
//
//wf_move()
end event

event dragwithin;//// drag within
//TreeViewItem		ltvi_Over, ltvi_parent
//
//If GetItem(handle, ltvi_Over) = -1 Then
//	SetDropHighlight(0)
//	il_DropTarget = 0
//	Return
//End If
//
//il_DropTarget = handle
//
//// Drop target is this item's parent
//If ltvi_over.level = 1 Then
//	SetDropHighlight(0)
//	return 
//ELSEIf ltvi_over.level = 2 Then
//	SetDropHighlight(0)
//	return 
//ELSEIf ltvi_over.level = 3 Then
//	SetDropHighlight(0)
//	return 
//Else
//	il_DropTarget = FindItem(ParentTreeItem!, handle)
//End if
//
//getitem(il_droptarget, ltvi_parent)
//If il_DropTarget <> il_DragParent Then
//	SetDropHighlight(il_DropTarget)
//Else
//	SetDropHighlight(0)
//	il_DropTarget = 0
//End If
//
//
end event

event key;//If key = keydelete! Then
//	wf_treeview_delete()
//End if
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

event selectionchanged;Integer				i_Level, i_main, i_sub1, i_sub2
TreeViewItem		tv_Current
String            current_data, sSub2_name

SetPointer(HourGlass!)

/* 현재의 레벨을 구한다.**************************************************************/
this.GetItem(newhandle, tv_Current)

i_Level = tv_Current.Level

current_data = String(tv_Current.Data)

i_main       = integer(trim(left(current_data, 5)))
i_sub1       = integer(trim(mid(current_data, 6, 5)))
i_sub2       = integer(trim(mid(current_data, 11, 5)))
sSub2_name   = trim(mid(current_data, 16, 30))

setnull(ii_main)
setnull(ii_sub1)
setnull(ii_sub2)
setnull(is_sub2_nm)
setnull(is_window_nm)

if i_level = 1 then
     p_3.triggerevent(clicked!)
	return 1
elseif i_level = 2 then
	ii_main = i_main
	ii_sub1 = i_sub1
	ii_sub2 = i_sub2	
	is_window_nm = sSub2_name
   if dw_insert.retrieve(i_main, i_sub1, i_sub2,is_window_nm) > 0 then
//      wf_modify2('T')
	else
		p_3.triggerevent(clicked!)
		return 1
   end if		
elseif i_level = 3 then
	ii_main = i_main
	ii_sub1 = i_sub1
	ii_sub2 = i_sub2	
	is_window_nm = sSub2_name
   if dw_insert.retrieve(i_main, i_sub1, i_sub2,is_window_nm) > 0 then
//      wf_modify2('A')
	else
		p_3.triggerevent(clicked!)
		return 1
   end if		
elseif i_level = 4 then
	ii_main = i_main
	ii_sub1 = i_sub1
	ii_sub2 = i_sub2	
	is_window_nm = sSub2_name

   if dw_insert.retrieve(i_main, i_sub1, i_sub2,is_window_nm) > 0 then
//      wf_modify2('E')
	else
		p_3.triggerevent(clicked!)
		return 1
   end if		
end if	
SetPointer(Arrow!)

end event

type rr_1 from roundrectangle within w_sys_0071p
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 64
integer y = 164
integer width = 2295
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sys_0071p
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2455
integer y = 188
integer width = 2053
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

