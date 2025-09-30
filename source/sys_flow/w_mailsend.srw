$PBExportHeader$w_mailsend.srw
$PBExportComments$** 메일보내기
forward
global type w_mailsend from w_inherite
end type
type tv_1 from treeview within w_mailsend
end type
type dw_1 from datawindow within w_mailsend
end type
type gb_1 from groupbox within w_mailsend
end type
type rr_1 from roundrectangle within w_mailsend
end type
end forward

global type w_mailsend from w_inherite
integer height = 2884
string title = "메일주소 등록"
tv_1 tv_1
dw_1 dw_1
gb_1 gb_1
rr_1 rr_1
end type
global w_mailsend w_mailsend

type prototypes
FUNCTION integer Send_Mail1(string sender, string receiver, string subject,string contents) LIBRARY "maildll.dll" alias for "Send_Mail1;Ansi"
FUNCTION integer Send_Mail2(string sender, string receiver, string subject,string contents ,string filename) LIBRARY "maildll.dll" alias for "Send_Mail2;Ansi"
end prototypes

type variables
Transaction SQLCA_GW
end variables

forward prototypes
public subroutine wf_tree_pgm ()
end prototypes

public subroutine wf_tree_pgm ();/* Treeview내역을 생성 */
Datastore ds_menu
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

/* Bom내역을 Retrieve */
ds_menu = Create datastore
ds_menu.dataobject = "d_mail_pgm"
ds_menu.settransobject(sqlca)

If ds_menu.retrieve(gs_userid) < 1 Then Return

For L_row=1 to ds_menu.rowcount()
	 L_gbn    = Dec(ds_menu.object.level_no[L_row])
	 
	 B_child  = False
	 
	 If L_row < ds_menu.rowcount() Then
		 If L_gbn < Dec(ds_menu.object.level_no[L_row + 1]) Then
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
	 
	 tvi.label = ds_menu.object.sub2_name[L_row]
	  
	 tvi.children = False
	 
	 Choose Case	L_gbn
		Case	0
			tvi.pictureindex = 5
			tvi.Selectedpictureindex = 5
			tvi.data  = ds_menu.object.main_id[L_row]
		Case	1
			tvi.pictureindex = 1
			tvi.Selectedpictureindex = 1
			tvi.data  = ds_menu.object.main_id[L_row]
		Case	2
			
			IF ds_menu.object.window_name[L_row] = 'A' THEN
				tvi.pictureindex = 4
				tvi.Selectedpictureindex = 4
				tvi.data  = 'A'
			ELSE
				tvi.pictureindex = 2
				tvi.Selectedpictureindex = 2
				tvi.data  = ds_menu.object.sub1_id[L_row]
			END IF
		Case	3
			IF ds_menu.Object.io_gubun[L_row] = 'R' THEN
				tvi.pictureindex = 4
		 		tvi.Selectedpictureindex = 4
			ELSEIF ds_menu.Object.io_gubun[L_row] = 'P' THEN
						tvi.pictureindex = 7
						tvi.Selectedpictureindex = 7
				  ELSE
						If ds_menu.Object.gubun[L_row] = 'Y' then
							tvi.pictureindex = 6
							tvi.Selectedpictureindex = 6
						Else
							tvi.pictureindex = 3
							tvi.Selectedpictureindex = 3
						End If
				END IF
			tvi.data  = ds_menu.object.window_name[L_row]
	End Choose


	
	 tvi.level  = L_gbn
//	 H_item = This.insertitemsort(L_parent, tvi)			// Root의 내용을 Sort를 하면서 하고자 하는 경우
	 H_item = tv_1.insertitemLast(L_parent, tvi)			// Root의 내용을 Sort를 하지않는 경우 
Next

//H_item = This.FindItem(RootTreeItem!, 0) 
//			this.Expanditem(H_item)
//

Destroy ds_menu

return

end subroutine

on w_mailsend.create
int iCurrent
call super::create
this.tv_1=create tv_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_mailsend.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tv_1)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;//// Profile leewongw
//SQLCA_GW.DBMS = "O84 ORACLE 8.0.4"
//SQLCA_GW.LogPass = "dazone"
//SQLCA_GW.ServerName = "leewongw"
//SQLCA_GW.LogId = "WorkId"
//SQLCA_GW.AutoCommit = False
//SQLCA_GW.DBParm = "PBCatalogOwner='WorkId'"
//
//Connect Using SQLCA_GW;
//
//IF SQLCA_GW.sqlcode <> 0 THEN
//	MessageBox ("Cannot Connect to GroupWare Database!", "그룹워어 DB에 접속할 수 없습니다." + &
//	             string(SQLCA_GW.sqlcode) + '~n' + SQLCA_GW.sqlerrtext)
//   halt close
////Else
////	messageBox('','groopware connect')
//END IF

dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)


wf_tree_pgm()
tv_1.SetFocus()
tv_1.PostEvent(Clicked!)

end event

event key;///
end event

event close;call super::close;//DisConnect Using SQLCA_GW;
end event

type dw_insert from w_inherite`dw_insert within w_mailsend
integer x = 1710
integer y = 216
integer width = 2871
integer height = 2080
string dataobject = "d_mailsend"
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;Long ll_row ,ll_user_no
String ls_empno ,ls_empnm ,ls_send_mail ,ls_re_mail, ls_deptcode, ls_deptname

AcceptText()
ll_row = GetRow()
Choose Case Lower(GetColumnName())
	Case 'empno'
		ls_empno = Trim(Object.empno[ll_row])
		If ls_empno = '' Or isNull(ls_empno) Then
			f_message_chk(33,'[사번]')
			Return 1
		End If
		
		SELECT A.DEPTCODE, C.DEPTNAME, A.EMPNAME, B.EMAIL
		  INTO :ls_deptcode, :ls_deptname, :ls_empnm, :ls_re_mail
		  FROM P1_MASTER A, P1_ETC B, P0_DEPT C
		 WHERE A.EMPNO = B.EMPNO(+)
		   AND A.DEPTCODE = C.DEPTCODE
		   AND A.EMPNO = :ls_empno;

	  If SQLCA.SQLCODE <> 0 Then
			MessageBox('확인','해당 사번은 그룹웨어에 등록된 사원이 아닙니다.'+& 
			                   +'`~r~n~r~n해당사원을 그룹웨어에 등록하세요.')
			Return 1
		End if

		Object.deptcode[ll_row] = ls_deptcode
		Object.deptname[ll_row] = ls_deptname
		Object.empname[ll_row] = ls_empnm
		Object.addr_to[ll_row] = ls_re_mail

//		select a.userid ,
//		       a.name , 
//				 a.usernum,
//				 b.senderemail,
//				 b.replyemail 
//		  Into :ls_empno ,:ls_empnm, :ll_user_no,:ls_send_mail ,:ls_re_mail 
//		  from WBUser a , smtp b
//		 where a.usernum = b.usernum
//		   and a.userid = :ls_empno 
//			Using SQLCA_GW ;
//		
//	  If SQLCA_GW.SQLCODE <> 0 Then
//			MessageBox('확인','해당 사번은 그룹웨어에 등록된 사원이 아닙니다.'+& 
//			                   +'`~r~n~r~n해당사원을 그룹웨어에 등록하세요.')
//			Return 1
//		End if
//
//		Object.empname[ll_row] = ls_empnm
//		Object.addr_to[ll_row] = ls_re_mail
End Choose
		
end event

event dw_insert::rbuttondown;call super::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.getcolumnname() = 'empno' then
	open(w_sawon_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(row,'empno',gs_code)
	
	this.triggerevent(itemchanged!)

end if
end event

type p_delrow from w_inherite`p_delrow within w_mailsend
boolean visible = false
integer x = 2693
integer y = 36
end type

event p_delrow::clicked;call super::clicked;
if dw_insert.GetRow() < 1 Then Return

dw_insert.DeleteRow(dw_insert.GetRow())
end event

type p_addrow from w_inherite`p_addrow within w_mailsend
boolean visible = false
integer x = 2519
integer y = 36
end type

event p_addrow::clicked;call super::clicked;dw_insert.InsertRow(0)
end event

type p_search from w_inherite`p_search within w_mailsend
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_mailsend
integer x = 3749
end type

event p_ins::clicked;call super::clicked;String ls_win_id
Long   ll_r

dw_1.AcceptText()
ls_win_id = Trim(dw_1.Object.win_id[1])

If ls_win_id ='' Or isNull(ls_win_id) Then
	
	MessageBox('확인','프로그램명을 선택하세요')
	Return
End If

ll_r = dw_insert.InsertRow(0)
dw_insert.ScrollToRow(ll_r)

dw_insert.SetColumn(1)
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_mailsend
end type

type p_can from w_inherite`p_can within w_mailsend
end type

event p_can::clicked;call super::clicked;dw_1.Reset()
dw_1.InsertRow(0)
dw_1.Enabled = True

dw_1.SetFocus()
dw_1.SetColumn(1)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)


end event

type p_print from w_inherite`p_print within w_mailsend
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_mailsend
boolean visible = false
end type

type p_del from w_inherite`p_del within w_mailsend
end type

event p_del::clicked;call super::clicked;Long   ll_row
String ls_new
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return

If f_msg_delete() < 1 Then Return

ls_new = Trim(dw_insert.Object.is_new[ll_row])

dw_insert.DeleteRow(ll_row)

If ls_new = 'N' Then
	If dw_insert.Update() = -1 Then
		Rollback;
		f_message_chk(32 , '')
		Return
	Else
		Commit;
	End If
End If
		

end event

type p_mod from w_inherite`p_mod within w_mailsend
end type

event p_mod::clicked;call super::clicked;String ls_win_id ,ls_new ,ls_empno ,ls_addr
Long   i
If f_msg_update() < 1 Then Return

dw_1.AcceptText()
dw_insert.AcceptText()
ls_win_id = Trim(dw_1.Object.win_id[1])
If ls_win_id = '' or isNull(ls_win_id) Then
	MessageBox('확인','프로그램명을 선택하세요.')
	Return
End If
For i = 1 To dw_insert.RowCount()
	
	ls_new = Trim(dw_insert.Object.is_new[i])
	If ls_new = 'Y' Then
		ls_empno = Trim(dw_insert.Object.empno[i])
		ls_addr  = Trim(dw_insert.Object.addr_to[i])
		If ls_empno = '' Or isNull(ls_empno) Then
			MessageBox('확인','메일 보낼 사원명이 없습니다.')
			Return
		End If
		If ls_addr = '' Or isNull(ls_addr) Then
			MessageBox('확인','메일주소 없습니다.')
			Return
		End If
		dw_insert.Object.window_id[i]= Lower(ls_win_id)
	Else
		Continue;
	End If
Next
dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	f_message_chk(32,'')
	Return
Else
	Commit;
	
	dw_insert.Retrieve(ls_win_id)
End If

		





end event

type cb_exit from w_inherite`cb_exit within w_mailsend
end type

type cb_mod from w_inherite`cb_mod within w_mailsend
end type

type cb_ins from w_inherite`cb_ins within w_mailsend
end type

type cb_del from w_inherite`cb_del within w_mailsend
end type

type cb_inq from w_inherite`cb_inq within w_mailsend
end type

type cb_print from w_inherite`cb_print within w_mailsend
end type

type st_1 from w_inherite`st_1 within w_mailsend
end type

type cb_can from w_inherite`cb_can within w_mailsend
end type

type cb_search from w_inherite`cb_search within w_mailsend
end type







type gb_button1 from w_inherite`gb_button1 within w_mailsend
end type

type gb_button2 from w_inherite`gb_button2 within w_mailsend
end type

type tv_1 from treeview within w_mailsend
integer x = 78
integer y = 252
integer width = 1518
integer height = 2024
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean border = false
boolean linesatroot = true
boolean trackselect = true
boolean singleexpand = true
string picturename[] = {"Cascade!","Custom039!","Database!","DataWindow!","C:\erpman\image\computer.jpg","Custom050!"}
long picturemaskcolor = 536870912
string statepicturename[] = {"Sort!","Custom050!","DosEdit5!","EditDataFreeform!"}
long statepicturemaskcolor = 536870912
end type

event clicked;String				ls_window_id
Integer				li_Rows, li_Level, li_data, li_row
TreeViewItem		ltvi_Current


SetPointer(HourGlass!)
GetItem(handle, ltvi_Current)
li_Level = ltvi_Current.Level

IF li_level = 4 THEN 
	
	ls_window_id = ltvi_Current.Data
	IF (ls_window_id <> "") THEN
		
		dw_insert.Retrieve(Trim(ls_window_id)) 
		
		dw_1.Object.win_id[1] = ls_window_id
		dw_1.Object.win_nm[1] = ltvi_Current.label
	   dw_1.Enabled = False
	
	End if
END IF


end event

type dw_1 from datawindow within w_mailsend
integer x = 1838
integer y = 32
integer width = 1906
integer height = 164
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_mailsend_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_win_id ,ls_win_nm

AcceptText()

If GetColumnName() = 'win_id' Then
	ls_win_id = GetText()
	
	If ls_win_id = '' Or isNull(ls_win_id) Then
		f_message_chk(33,'[프로그램명-윈도우 ID]')
		Return 1
	End If
	
	select sub2_name Into :ls_win_nm 
     from Sub2_t
    where window_name = :ls_win_id ;
	If sqlca.sqlcode <> 0 then
		f_message_chk(33,'[프로그램명-윈도우 ID]')
		SetColumn(1)
   	Return 1
	Else
		Object.win_nm[1] = ls_win_nm
	End If

	
	If dw_insert.Retrieve(ls_win_id) > 1 Then
		This.Enabled = False
	Else
		This.Enabled = True
	End If
	
End If
		


end event

type gb_1 from groupbox within w_mailsend
integer x = 32
integer y = 180
integer width = 1650
integer height = 2132
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "프로그램선택"
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_mailsend
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1701
integer y = 208
integer width = 2894
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 55
end type

