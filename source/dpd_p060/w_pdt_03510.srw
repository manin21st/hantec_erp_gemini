$PBExportHeader$w_pdt_03510.srw
$PBExportComments$** 불량발생현황(그래프)
forward
global type w_pdt_03510 from w_standard_dw_graph
end type
type rr_2 from roundrectangle within w_pdt_03510
end type
type tv_1 from treeview within w_pdt_03510
end type
type dw_1 from datawindow within w_pdt_03510
end type
end forward

global type w_pdt_03510 from w_standard_dw_graph
string title = "불량발생 현황"
rr_2 rr_2
tv_1 tv_1
dw_1 dw_1
end type
global w_pdt_03510 w_pdt_03510

type variables
/************* tree용 *****************************/
Datastore ids_data[3]
string        is_drag_data
long          il_oldhandle,  il_newhandle, il_dragparent, &
                 il_droptarget
TreeViewItem     itv_old, itv_new
end variables

forward prototypes
public subroutine wf_treeview_item ()
public function integer wf_retrieve ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve3 ()
public function integer wf_retrieve4 ()
public function integer wf_retrieve5 ()
public function integer wf_graph_retrieve (integer ilevel, string sdata)
end prototypes

public subroutine wf_treeview_item ();/* Treeview내역을 생성 */
Datastore ds_user
Treeviewitem tvi
Long 		l_row, L_gbn, H_item, L_parent, L_gbn_b
Long 		L_level[20]
Integer	I_cnt
Boolean  B_child

/* 전체내역을 삭제 */
long tvi_hdl = 0

DO UNTIL tv_1.FindItem(RootTreeItem!, 0) = -1	
	      tv_1.DeleteItem(tvi_hdl)
LOOP

if dw_ip.accepttext() = -1 then return 

/* USER-ID 내역을 Retrieve */
ds_user = Create datastore
ds_user.dataobject = "d_pdt_01620_d"
ds_user.settransobject(sqlca)
If ds_user.retrieve() < 1 Then Return

/* 첫번째 레벨을 등록하고 ........................... */
tvi.Data = 'TOP'
tvi.Label= '전체'    
tvi.PictureIndex = 1
tvi.SelectedPictureIndex = 1
tvi.Children = True
h_item = tv_1.InsertItemLast(0, tvi)

I_cnt = 1
L_level[I_cnt] = H_item
L_parent		   = H_item

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
	 if l_gbn = 1 then
		 tvi.label = ds_user.object.pdtname[l_row]
	 else
		 tvi.label = '[' + ds_user.object.pdtcod[l_row] + ']' + ds_user.object.pdtname[l_row]
	 end if
	 tvi.data  = ds_user.object.pdtcod[l_row]
	  
	 tvi.children = False
	 If b_child  Then
		 tvi.pictureindex = 2
		 tvi.Selectedpictureindex = 3
	 Else
		 tvi.pictureindex = 0
		 tvi.Selectedpictureindex = 0
	 End if
	 tvi.level  = L_gbn
	 H_item = tv_1.insertitemlast(L_parent, tvi)			// Root의 내용을 Sort를 하지않는 경우 

Next

Destroy ds_user
return 
end subroutine

public function integer wf_retrieve ();String gubun
Integer i_rtn

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if	

gubun = Trim(dw_1.object.gubun[1] )

if gubun = "2" then
   i_rtn = wf_retrieve2()
elseif gubun = "3" then
   i_rtn = wf_retrieve3()
elseif gubun = "4" then
   i_rtn = wf_retrieve4()
elseif gubun = "5" then
   i_rtn = wf_retrieve5()
end if

return i_rtn


end function

public function integer wf_retrieve2 ();string ym

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

ym = ym + "%"
if dw_list.Retrieve(gs_sabu, ym) <= 0 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

public function integer wf_retrieve3 ();string pym, cym

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if
cym = trim(dw_ip.object.ym[1])
 
if (IsNull(cym) or cym = "")  then 
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

pym = f_aftermonth(cym, -5)

dw_list.object.txt_title.text= String(cym, "@@@@년 @@월 공정불량율, A/S접수현황")
dw_list.object.gr_1.title = String(cym, "@@@@년 @@월 공정불량율 현황")
dw_list.object.gr_2.title = String(cym, "@@@@년 @@월 A/S접수율 현황")

if dw_list.Retrieve(gs_sabu, pym, cym) <= 0 then
	f_message_chk(50,'[공정불량율, A/S접수현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

public function integer wf_retrieve4 ();string yyyy

if dw_ip.AcceptText() = -1 then return -1

yyyy = dw_ip.object.yyyy[1]

if isnull(yyyy) or yyyy = "" or f_datechk(yyyy +'0101') = -1 then //날짜체크(년도 check)
   f_message_chk(35,"[기준년도]")
	return -1
end if

if dw_list.retrieve(gs_sabu, yyyy) <= 0 then
	MessageBox("확 인", "검색된 자료가 없습니다.!!")
	return -1
end if

return 1
end function

public function integer wf_retrieve5 ();string yyyy

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

yyyy = Trim(dw_ip.object.yyyy[1])
if (IsNull(yyyy) or yyyy = "")  then 
	f_message_chk(30,'[기준년도]')
	dw_ip.SetColumn("yyyy")
	dw_ip.Setfocus()
	return -1
end if

dw_list.object.txt_title.text = String(yyyy, "@@@@년 생산팀별 A/S접수 현황")

if dw_list.Retrieve(gs_sabu, yyyy) <= 0 then
	f_message_chk(50,'[생산팀별 A/S접수 현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

public function integer wf_graph_retrieve (integer ilevel, string sdata);string ym

if dw_ip.AcceptText() = -1 then	return -1

ym = Trim(dw_ip.object.ym[1])

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30,'[기준년월]')
	return -1
end if

dw_list.SetRedraw(False)

if ilevel = 1 then     //전체
	dw_list.dataobject = "d_pdt_03510_02"
	dw_list.settransobject(sqlca)
	if dw_list.Retrieve(gs_sabu, ym) <= 0 then
		dw_list.SetRedraw(True)
		f_message_chk(50,'')
		return -1
	end if
elseif ilevel = 2 then //그래프(생산팀)
	dw_list.dataobject = "d_pdt_03510_03"
	dw_list.settransobject(sqlca)
	if dw_list.Retrieve(gs_sabu, ym, sdata) <= 0 then
		dw_list.SetRedraw(True)
		f_message_chk(50,'')
		return -1
	end if
else  //그래프(조)
	dw_list.dataobject = "d_pdt_03510_04"
	dw_list.settransobject(sqlca)
	if dw_list.Retrieve(gs_sabu, ym, sdata) <= 0 then
		dw_list.SetRedraw(True)
		f_message_chk(50,'')
		return -1
	end if
end if
dw_list.SetRedraw(True)

Return 1


end function

on w_pdt_03510.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.tv_1=create tv_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.tv_1
this.Control[iCurrent+3]=this.dw_1
end on

on w_pdt_03510.destroy
call super::destroy
destroy(this.rr_2)
destroy(this.tv_1)
destroy(this.dw_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

wf_treeview_item()
w_mdi_frame.sle_msg.TEXT = '전체/생산팀/조를 선택 후 오른쪽 마우스 버튼을 누르면 그래프가 조회됩니다....'

end event

type p_exit from w_standard_dw_graph`p_exit within w_pdt_03510
end type

type p_print from w_standard_dw_graph`p_print within w_pdt_03510
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_pdt_03510
end type

event p_retrieve::clicked;SetPointer(HourGlass!)
IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'c:\erpman\image\인쇄_d.gif'
	pb_color.Enabled =False
	pb_graph.Enabled =False
	pb_space.Enabled =False
	pb_title.Enabled =False
	SetPointer(Arrow!)
	Return
ELSE
	string sgub
	sgub = dw_1.object.gubun[1]
	if dw_list.object.datawindow.print.preview <> 'yes' and &
	   ( sgub = '1' OR sgub = '4' ) then 
		pb_color.Enabled =True
		pb_graph.Enabled =True
		pb_space.Enabled =True
		pb_title.Enabled =True
	end if	
	p_print.Enabled =True
	p_print.PictureName = 'c:\erpman\image\인쇄_up.gif'
	dw_list.object.datawindow.print.preview="yes"
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)

end event

type st_window from w_standard_dw_graph`st_window within w_pdt_03510
end type

type st_popup from w_standard_dw_graph`st_popup within w_pdt_03510
end type

type pb_title from w_standard_dw_graph`pb_title within w_pdt_03510
end type

type pb_space from w_standard_dw_graph`pb_space within w_pdt_03510
end type

type pb_color from w_standard_dw_graph`pb_color within w_pdt_03510
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_pdt_03510
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_pdt_03510
integer x = 82
integer y = 32
integer width = 731
integer height = 88
integer taborder = 20
string dataobject = "d_pdt_03510_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.GetText())

if this.getcolumnname() = 'ym' then   
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35,'[기준년월]')
		this.object.ym[1] = ""
		return 1
	end if
elseif this.getcolumnname() = 'yyyy' then   
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + '0101') = -1 then
		f_message_chk(35,'[기준년도]')
		this.object.yyyy[1] = ""
		return 1
	end if
end if



end event

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_pdt_03510
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_pdt_03510
end type

type st_10 from w_standard_dw_graph`st_10 within w_pdt_03510
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_pdt_03510
long backcolor = 32106727
end type

type dw_list from w_standard_dw_graph`dw_list within w_pdt_03510
integer x = 59
integer y = 628
integer width = 4549
integer height = 1688
string dataobject = "d_pdt_03510_02"
boolean border = false
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_pdt_03510
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_pdt_03510
integer x = 41
integer y = 616
integer width = 4581
integer height = 1720
end type

type rr_2 from roundrectangle within w_pdt_03510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 12
integer width = 818
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

type tv_1 from treeview within w_pdt_03510
integer x = 891
integer y = 4
integer width = 745
integer height = 604
integer taborder = 30
string dragicon = "Application!"
boolean dragauto = true
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
boolean disabledragdrop = false
string picturename[] = {"TreeView!","AddWatch5!","DeleteWatch5!"}
long picturemaskcolor = 553648127
string statepicturename[] = {"TreeView!","AddWatch5!","DeleteWatch5!"}
long statepicturemaskcolor = 553648127
end type

event rightclicked;Integer				i_Level
TreeViewItem		tv_Current
String            current_data

SetPointer(HourGlass!)

/* 현재의 레벨을 구한다.**************************************************************/
this.GetItem(handle, tv_Current)

i_Level = tv_Current.Level

current_data = String(tv_Current.Data)

IF wf_graph_retrieve(i_level, current_data) = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'c:\erpman\image\인쇄_d.gif'
	pb_color.Enabled =False
	pb_graph.Enabled =False
	pb_space.Enabled =False
	pb_title.Enabled =False
	SetPointer(Arrow!)
	Return 1
ELSE
	p_print.Enabled =True
	p_print.PictureName = 'c:\erpman\image\인쇄_up.gif'
	pb_color.Enabled =True
	pb_graph.Enabled =True
	pb_space.Enabled =True
	pb_title.Enabled =True
	dw_list.object.datawindow.print.preview="yes"
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)


end event

type dw_1 from datawindow within w_pdt_03510
integer x = 32
integer y = 148
integer width = 818
integer height = 456
integer taborder = 10
string dataobject = "d_pdt_03510_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())
tv_1.Visible = False
sle_msg.TEXT = ''

dw_ip.SetReDraw(False)
dw_list.SetReDraw(False)
if gubun = "1" then //생산팀별일일불량발생현황(그래프)
   dw_ip.DataObject = "d_pdt_03510_01"
	dw_list.DataObject = "d_pdt_03510_02"
	tv_1.Visible = True
	sle_msg.TEXT = '전체/생산팀/조를 선택 후 오른쪽 마우스 버튼을 누르면 그래프가 조회됩니다....'
elseif gubun = "2" then	//생산팀별일일불량발생현황
   dw_ip.DataObject = "d_pdt_03500_01"
	dw_list.DataObject = "d_pdt_03500_02"
elseif gubun = "3" then	//공정불량율, A/S접수현황
   dw_ip.DataObject = "d_pdt_03580_01"
	dw_list.DataObject = "d_pdt_03580_02"
elseif gubun = "4" then	//생산팀별 공정불량율 현황
   dw_ip.DataObject = "d_pdt_03730_01"
	dw_list.DataObject = "d_pdt_03730_02"
elseif gubun = "5" then	//생산팀별 A/S접수현황
   dw_ip.DataObject = "d_pdt_03720_01"
	dw_list.DataObject = "d_pdt_03720_02"
end if	

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.ReSet()
dw_list.ReSet()
dw_ip.InsertRow(0)
dw_ip.SetReDraw(True)
dw_list.SetReDraw(True)

pb_color.Enabled =False
pb_graph.Enabled =False
pb_space.Enabled =False
pb_title.Enabled =False

p_print.Enabled =False
p_print.PictureName = 'c:\erpman\image\인쇄_d.gif'

end event

