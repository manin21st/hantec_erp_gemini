$PBExportHeader$wr_pif2011.srw
$PBExportComments$조직도 MAIN
forward
global type wr_pif2011 from window
end type
type p_print from picture within wr_pif2011
end type
type p_exit from uo_picture within wr_pif2011
end type
type dw_2 from datawindow within wr_pif2011
end type
type dw_1 from datawindow within wr_pif2011
end type
type tv_1 from treeview within wr_pif2011
end type
type st_1 from statictext within wr_pif2011
end type
type dw_datetime from datawindow within wr_pif2011
end type
type sle_msg from singlelineedit within wr_pif2011
end type
type gb_10 from groupbox within wr_pif2011
end type
type rr_1 from roundrectangle within wr_pif2011
end type
type rr_2 from roundrectangle within wr_pif2011
end type
type rr_3 from roundrectangle within wr_pif2011
end type
end forward

global type wr_pif2011 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "조직도"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_print p_print
p_exit p_exit
dw_2 dw_2
dw_1 dw_1
tv_1 tv_1
st_1 st_1
dw_datetime dw_datetime
sle_msg sle_msg
gb_10 gb_10
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global wr_pif2011 wr_pif2011

type variables
/************* tree용 *****************************/
Datastore ids_data[3]
//m_dept im_pop
String is_tag
String is_userid
Boolean ib_timer = True
string is_drag_dept, is_window_id, is_totime, is_today, is_usegub
TreeViewItem		itv_old,itv_new,itv_now
long                                         il_oldhandle,il_newhandle,il_nowhandle
boolean ib_tag = false
boolean ie_tag = false
int dept_length
end variables

forward prototypes
public function integer wf_retrieve_data (long al_handle)
public function integer wf_add_tv (long al_parent, integer i_level, integer i_rows)
end prototypes

public function integer wf_retrieve_data (long al_handle);string            Current_data
Integer				i_level
TreeViewItem		tv_Current

/*****  현재의 level 을 결정  ************************************************/
tv_1.GetItem(al_Handle, tv_Current)
i_level = tv_Current.Level


/* datastore의 argument를 구한다.(현재레벨의 데이타값을 구함) ****************/
current_data = String(tv_Current.Data)

//choose case i_level
//   case 2
      Return ids_data[2].Retrieve( gs_company,left(current_data,dept_length))
//      Return ids_data[2].Retrieve( gs_company,left(current_data,4))
//	case 3
//		Return ids_data[2].Retrieve( is_userid,is_tag,Trim(Left(current_data,2)),  &
//		       Trim(Mid(current_data,3,2)), Trim(Right(current_data,2)) )
//End choose

end function

public function integer wf_add_tv (long al_parent, integer i_level, integer i_rows);Integer				i_Cnt
long cnt
string deptcode
TreeViewItem		tv_New

For i_Cnt = 1 To i_Rows

	Integer	li_Picture
deptcode = ids_data[2].Object.deptcode[i_cnt]
		   tv_New.data   = ids_data[2].Object.deptcode[i_cnt] + ids_data[2].Object.deptpart[i_cnt]
	   	tv_New.label  = ids_data[2].Object.deptname2[i_cnt]
         tv_New.PictureIndex = i_level
			tv_New.SelectedPictureindex = i_level
select count(*) into :cnt
	from p0_dept
	where deptpart = :deptcode;
if cnt > 0 then	
   tv_New.Children = True
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

on wr_pif2011.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.p_print=create p_print
this.p_exit=create p_exit
this.dw_2=create dw_2
this.dw_1=create dw_1
this.tv_1=create tv_1
this.st_1=create st_1
this.dw_datetime=create dw_datetime
this.sle_msg=create sle_msg
this.gb_10=create gb_10
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.Control[]={this.p_print,&
this.p_exit,&
this.dw_2,&
this.dw_1,&
this.tv_1,&
this.st_1,&
this.dw_datetime,&
this.sle_msg,&
this.gb_10,&
this.rr_1,&
this.rr_2,&
this.rr_3}
end on

on wr_pif2011.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_print)
destroy(this.p_exit)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.tv_1)
destroy(this.st_1)
destroy(this.dw_datetime)
destroy(this.sle_msg)
destroy(this.gb_10)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
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

messagebox('', gs_picpath)

ids_Data[1] = Create DataStore
ids_Data[1].DataObject = "d_pif2011_3"        // 단위업무 레벨(2)의 데이타

ids_Data[2] = Create DataStore
ids_Data[2].DataObject = "d_pif2011_3"       

ids_Data[3] = Create DataStore
ids_Data[3].DataObject = "d_pif2011_3"       

Ids_data[1].setTransobject(sqlca)
Ids_data[2].setTransobject(sqlca)
Ids_data[3].setTransobject(sqlca)

Dw_1.Settransobject(sqlca)
Dw_2.Settransobject(sqlca)

select to_number(dataname) into :dept_length
from p0_syscnfg 
where sysgu = 'P' and serial = 31 and lineno = '1';

Tv_1.Triggerevent("ue_tree")

end event

event key;Choose Case key
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose    
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

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type p_print from picture within wr_pif2011
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 4197
integer y = 12
integer width = 178
integer height = 144
integer taborder = 50
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;IF p_print.Enabled = True THEN
	PictureName = 'C:\erpman\image\인쇄_dn.gif'
END IF
end event

event ue_lbuttonup;IF p_print.Enabled = True THEN
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
END IF
end event

event clicked;//iF dw_1.rowcount() > 0 then 
//	gi_page = long(dw_print.Describe("evaluate('pagecount()', 1)" ))
//ELSE
//	gi_page = 1
//END IF
//OpenWithParm(w_print_options, dw_print)
OpenWithParm(w_print_options, dw_1)


end event

type p_exit from uo_picture within wr_pif2011
integer x = 4370
integer y = 12
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_2 from datawindow within wr_pif2011
integer x = 1431
integer y = 180
integer width = 727
integer height = 776
string dataobject = "d_pif2011_1"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;
string focus_object
string ls_empno
string	ret_val,tmp
long ar_row
setpointer(hourglass!)
	if dw_2.rowcount() > 0 then
	 	ls_empno = dw_2.getitemstring(1, "pers_master_empno")
//		Openwithparm(w_piz1105, ls_empno)
	end if
   
setpointer(arrow!)


end event

type dw_1 from datawindow within wr_pif2011
integer x = 2249
integer y = 208
integer width = 2286
integer height = 1964
string dataobject = "d_pif2011_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;//string ls_empno
//Integer	li_block_width, li_block_height,li_block_height2
//long lv_pos
//string first_row
//long   ar_row
//
//li_block_width   = This.Width  /2
//li_block_height2 = This.Height /4
//li_block_height  = This.Height /2
//
//first_row = describe('datawindow.firstrowonpage')
//if not isnumber(first_row) then return
//Choose Case This.PointerY()
//	Case Is < li_block_height2
//		Choose Case This.PointerX()
//			Case Is < li_block_width
//				lv_pos = 0
//			Case Is < (li_block_width * 2)
//				lv_pos = 1
//		End Choose
//	Case Is < li_block_height
//		Choose Case This.PointerX()
//			Case Is < li_block_width
//				lv_pos = 2
//			Case Is < (li_block_width * 2)
//				lv_pos = 3
//		End Choose		
//	Case Is < (li_block_height2 * 3)
//		Choose Case This.PointerX()
//			Case Is < li_block_width
//				lv_pos = 4
//			Case Is < (li_block_width * 2)
//				lv_pos = 5
//		End Choose		
//	Case Is < (li_block_height * 2)
//		Choose Case This.PointerX()
//			Case Is < li_block_width
//				lv_pos = 6
//			Case Is < (li_block_width * 2)
//				lv_pos = 7
//		End Choose
//End Choose
//
//ar_row = lv_pos + long(first_row)
//	if dw_1.rowcount() > 0 and ar_row > 0 and ar_row <=dw_1.rowcount() then
//		setpointer(hourglass!)
//	 	ls_empno = dw_1.getitemstring(ar_row, "pers_master_empno")
//		Openwithparm(w_piz1105, ls_empno)
//		setpointer(arrow!)
//	end if

end event

type tv_1 from treeview within wr_pif2011
event begindrag pbm_tvnbegindrag
event dragdrop pbm_tvndragdrop
event itempopulate pbm_tvnitempopulate
event rightclicked pbm_tvnrclicked
event selectionchanged pbm_tvnselchanged
event ue_tree ( )
event ue_move pbm_custom01
event ue_pop ( )
integer x = 50
integer y = 152
integer width = 1298
integer height = 2028
integer taborder = 20
string dragicon = "C:\GOORYONG\PI\gr.ico"
boolean dragauto = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean border = false
borderstyle borderstyle = stylelowered!
boolean deleteitems = true
string picturename[] = {"Library!","Start!","Custom039!","Custom050!","DosEdit5!","Report5!","Custom030!","Custom031!"}
long picturemaskcolor = 553648127
string statepicturename[] = {"Application5!","Globals!","Custom050!"}
long statepicturemaskcolor = 553648127
end type

event begindrag;//Integer				Rows, Level
//TreeViewItem		tv_Current
//string 				current_data
//GetItem(handle, tv_Current)
//Level = tv_Current.Level
//itv_old = tv_Current
//IF level = 1 then return
//
//is_drag_dept = String(tv_Current.Data)
//il_oldhandle = handle
//
end event

event dragdrop;//Integer				Rows, Level
//TreeViewItem		tv_Current
//string 				current_data
//GetItem(handle, tv_Current)
//Level = tv_Current.Level
//
//il_newhandle = handle
//itv_new = tv_current
//triggerevent('ue_move')
end event

event itempopulate;Integer				Rows, Level
TreeViewItem		tv_Current

/****  current item의 레벨을 결정한다  ************************************************/
if ib_tag then return
GetItem(handle, tv_Current)
Level = tv_Current.Level

IF level = 1 then return

Rows = wf_retrieve_data(handle)          // Datastore 의 데이타를 조회   

wf_add_tv(handle, Level + 1, Rows)       // 다음 레벨에 add한다.......

end event

event rightclicked;//Integer				Rows, Level
//TreeViewItem		tv_Current
//string 				current_data
//
//GetItem(handle, tv_Current)
//Level = tv_Current.Level
//itv_now = tv_Current
//IF level = 1 then return
//
//is_drag_dept = String(tv_Current.Data)
//il_nowhandle = handle
//
////im_pop.m_mcopy.m_paste.enabled = ib_tag
////im_pop.m_mcopy.PopMenu(gw_mainframe.PointerX(), gw_mainframe.PointerY())
////
end event

event selectionchanged;Integer				Rows, i_Level
TreeViewItem		tv_Current
String            current_data
string				deptcode, ls_empno, ls_deptnm
if  ie_tag then return
SetPointer(HourGlass!)

/* 현재의 레벨을 구한다.**************************************************************/
GetItem(newhandle, tv_Current)

i_Level = tv_Current.Level

if i_level = 1 then return

current_data = String(tv_Current.Data)

if  isnull(tv_Current.Data) then return

if len(string(tv_Current.Data)) < 8 then return

deptcode = left(tv_Current.Data,dept_length)

  SELECT "P0_DEPT"."EMPNO"  
    INTO :ls_empno  
    FROM "P0_DEPT"  
   WHERE "P0_DEPT"."DEPTCODE" = :deptcode   ;
	
  IF isnull(ls_empno) then
		ls_empno = '999999'
  end if	
  
  SELECT "P0_DEPT"."DEPTNAME2"  
    INTO :ls_deptnm  
    FROM "P0_DEPT"  
   WHERE "P0_DEPT"."DEPTCODE" = :deptcode   ;

int i
dw_2.retrieve(gs_company,ls_empno,gs_picpath)
//f_get_pic(gs_picpath,ls_empno)
dw_1.retrieve(gs_company,deptcode,ls_empno,ls_deptnm,gs_picpath)
for i = 1 to dw_1.rowcount()
	// f_get_pic(gs_picpath,dw_1.getitemstring(i,'pers_master_empno'))	 
next	 
dw_2.retrieve(gs_company,ls_empno,gs_picpath)


dw_1.retrieve(gs_company,deptcode,ls_empno,ls_deptnm,gs_picpath)

//dw_2.retrieve(gs_company,deptcode,gs_picpath)
//dw_1.retrieve(gs_company,deptcode,gs_picpath)

SetPointer(Arrow!)

end event

event ue_tree;//is_tag = gs_tag
//is_userid = gs_user_id
string deptcode
Long				ll_Root,ll_New,i_cnt,cur_row,cnt
TreeViewItem	ltvi_Root,tv_new
long ll_tvi

ie_tag = true

DO
   ll_tvi = tv_1.FindItem(roottreeitem!, 0)   //tv의 모든 item을 삭제한다.....
   tv_1.DeleteItem(ll_tvi)                      
Loop until ll_tvi = -1

ie_tag = false
Setpointer(Hourglass!)

//i_cnt = ids_data[1].Retrieve( gs_company,'000000')
i_cnt = ids_data[1].Retrieve( gs_company,'000000')
If i_cnt < 1 then 
	Setpointer(Arrow!)
	return
End If 
/* 첫번째 레벨을 등록하고 ........................... */
ltvi_Root.Data = '000000100000'          //1000000은 임원
ltvi_Root.Label= '회사전체'    // 단위업무명 
ltvi_Root.PictureIndex = 1
ltvi_Root.SelectedPictureIndex = 1
ltvi_Root.Children = True
ll_Root = tv_1.InsertItemLast(0, ltvi_Root)

cur_row = 1

For cur_row = 1 to i_cnt
	deptcode = ids_data[1].object.deptcode[cur_row]
	tv_New.data  = ids_data[1].object.deptcode[cur_row] + ids_data[1].object.deptpart[cur_row]
   tv_New.label = ids_data[1].object.deptname2[cur_row]
   tv_New.PictureIndex = 2
   tv_New.SelectedPictureindex = 2
	tv_New.Children = True
	ll_New = tv_1.insertitemlast(1,tv_New)
	
	select count(*) into :cnt
	  from p0_dept
	 where deptpart = :deptcode;
	
	if cnt > 0 then	
	   tv_New.Children = True
	else
	   tv_New.Children = false
	end if
	
   tv_1.ExpandItem(ll_New)
Next
	
tv_1.ExpandItem(ll_Root)

Setpointer(Arrow!)

end event

event ue_move;//string old_deptcode,old_deptpart,new_deptcode,new_deptpart,old_name
//long rows,level,new_handle
//
//treeviewitem tv_insert,tv_new
//ib_tag = true
//if il_newhandle = il_oldhandle then return
//if il_newhandle = finditem(ParentTreeItem!,il_oldhandle) then return
//
//old_deptcode = left(string(itv_old.data),6)
//old_deptpart = right(string(itv_old.data),6)
//new_deptcode = left(string(itv_new.data),6)
//new_deptpart = right(string(itv_new.data),6)
//  update p0_dept
//	  set deptpart = :new_deptcode
//	where deptcode = :old_deptcode;
//if sqlca.sqlcode = 0 then
//	commit;
//end if
//
//old_name = itv_old.label
//itv_new.children = true
//CollapseItem ( il_newhandle )
//expanditem( il_newhandle )
//setitem(il_newhandle,itv_new)
//expanditem( il_newhandle )
//CollapseItem ( il_newhandle )
//
//Level = itv_new.Level
//tv_insert.data   = old_deptcode + new_deptcode
//tv_insert.label = old_name
//tv_insert.PictureIndex = level + 1
//tv_insert.SelectedPictureindex = level + 1
//tv_insert.children = itv_old.children
//itv_new.children = true
//itv_new.PictureIndex = itv_new.level
//itv_new.SelectedPictureindex = itv_new.level
//setitem(il_newhandle,itv_new)
//
//new_handle = InsertItemLast(il_newhandle, tv_insert)
//
//If new_handle < 1 Then
//	MessageBox("Error", "Error inserting item", Exclamation!)
//	Return -1
//End If
//deleteitem(il_oldhandle)
//ib_tag = false
//tv_1.ExpandItem(il_newhandle)
//deleteitem(il_oldhandle)
//
end event

event ue_pop;expanditem(il_newhandle)
end event

type st_1 from statictext within wr_pif2011
boolean visible = false
integer x = 18
integer y = 3132
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

type dw_datetime from datawindow within wr_pif2011
boolean visible = false
integer x = 2830
integer y = 3132
integer width = 750
integer height = 92
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type sle_msg from singlelineedit within wr_pif2011
boolean visible = false
integer x = 347
integer y = 3132
integer width = 2482
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

type gb_10 from groupbox within wr_pif2011
boolean visible = false
integer y = 3080
integer width = 3589
integer height = 152
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 78160032
end type

type rr_1 from roundrectangle within wr_pif2011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1422
integer y = 172
integer width = 763
integer height = 804
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within wr_pif2011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2245
integer y = 168
integer width = 2299
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within wr_pif2011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 144
integer width = 1317
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 46
end type

