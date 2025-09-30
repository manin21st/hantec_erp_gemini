$PBExportHeader$w_pdt_02605.srw
$PBExportComments$부하현황(그래프)
forward
global type w_pdt_02605 from w_standard_dw_graph
end type
type tv_1 from treeview within w_pdt_02605
end type
type rr_2 from roundrectangle within w_pdt_02605
end type
end forward

global type w_pdt_02605 from w_standard_dw_graph
string title = "부하현황[그래프]"
tv_1 tv_1
rr_2 rr_2
end type
global w_pdt_02605 w_pdt_02605

type variables
integer i_level
string scode, sname
end variables

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_treeview ()
end prototypes

public function integer wf_retrieve ();integer gu1, gu2
long lrow
string sc1, sc2, gubun, ls_saupj

dw_ip.accepttext()
gu1 = dw_ip.getitemdecimal(1, "gu1")
gu2 = dw_ip.getitemdecimal(1, "gu2")
gubun = dw_ip.getitemstring(1, "gubun")
ls_saupj = dw_ip.getitemstring(1, "saupj")

if gubun = '1' then
	dw_list.dataobject = 'd_pdt_02605_01'
	dw_list.settransobject(sqlca)
	if i_level = 1 then
		Lrow = dw_list.retrieve(gs_sabu, gu1, gu2, '%', '%', '%')
	elseif i_level = 2 then
		Lrow = dw_list.retrieve(gs_sabu, gu1, gu2, '%', '%', scode)		
	elseif i_level = 3 then	
		select pdtgu into :sc1 from jomast where jocod = :scode;
		Lrow = dw_list.retrieve(gs_sabu, gu1, gu2, '%', scode, sc1)
	else
		select jocod into :sc2 from wrkctr where wkctr = :scode;
		select pdtgu into :sc1 from jomast where jocod = :sc2;	
		Lrow = dw_list.retrieve(gs_sabu, gu1, gu2, scode, sc2, sc1)
	end if
	dw_list.object.gr_1.title = sname + '부하현황'	
Else
	dw_list.dataobject = 'd_pdt_02605_02'
	dw_list.settransobject(sqlca)	
	if i_level = 1 then
		Lrow = dw_list.retrieve(gs_sabu, gu1, gu2, '%', '%', '%','1')
	elseif i_level = 2 then
		Lrow = dw_list.retrieve(gs_sabu, gu1, gu2, '%', '%', scode,'2')		
	elseif i_level = 3 then	
		select pdtgu into :sc1 from jomast where jocod = :scode;
		Lrow = dw_list.retrieve(gs_sabu, gu1, gu2, '%', scode, sc1,'3')
	else
		Messagebox("부하율", "작업장은 공수로 확인하십시요", information!)
		return 1
	end if	
	dw_list.object.gr_1.title = sname + '부하율'		
End if

if lrow < 1 then
	f_message_chk(50,'[부하현황-그래프]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

public subroutine wf_treeview ();/* Treeview내역을 생성 */
Datastore ds_user
Treeviewitem tvi
String sToday
Long 		l_row, L_gbn, H_item, L_parent, L_gbn_b
Long 		L_level[20]
Integer	I_cnt
String 	L_userid, ls_saupj
Boolean  B_child

/* 전체내역을 삭제 */
long tvi_hdl = 0

DO UNTIL tv_1.FindItem(RootTreeItem!, 0) = -1	
	      tv_1.DeleteItem(tvi_hdl)
LOOP

dw_ip.AcceptText()

ls_saupj = dw_ip.getItemString(1, 'saupj')

/* USER-ID 내역을 Retrieve */
ds_user = Create datastore
ds_user.dataobject = "d_pdt_02605_0"
ds_user.settransobject(sqlca)
If ds_user.retrieve(ls_saupj) < 1 Then Return

/* 첫번째 레벨을 등록하고 ........................... */
tvi.Data = 'TOP'
tvi.Label= '부하전체'    
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
	 If 	  L_gbn = 1 Then
		 	  L_parent = 1
			  I_cnt    = 1
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
	 tvi.label = ds_user.object.pdtname[l_row]
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
/*	 H_item = tv_1.insertitemsort(L_parent, tvi)			// Root의 내용을 Sort를 하면서 하고자 하는 경우 */
	 H_item = tv_1.insertitemlast(L_parent, tvi)			// Root의 내용을 Sort를 하지않는 경우 

	 
Next

Destroy ds_user

return 
end subroutine

on w_pdt_02605.create
int iCurrent
call super::create
this.tv_1=create tv_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pdt_02605.destroy
call super::destroy
destroy(this.tv_1)
destroy(this.rr_2)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')

wf_treeview()
end event

type p_exit from w_standard_dw_graph`p_exit within w_pdt_02605
end type

type p_print from w_standard_dw_graph`p_print within w_pdt_02605
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_pdt_02605
end type

event p_retrieve::clicked;SetPointer(HourGlass!)
IF wf_retrieve() = -1 THEN
//	pb_color.Enabled =False
//	pb_graph.Enabled =False
//	pb_space.Enabled =False
//	pb_title.Enabled =False
	
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	
	
	SetPointer(Arrow!)
	Return
ELSE
	if dw_list.object.datawindow.print.preview <> 'yes' then 
//		pb_color.Enabled =True
//		pb_graph.Enabled =True
//		pb_space.Enabled =True
//		pb_title.Enabled =True
	end if	
//	dw_list.object.datawindow.print.preview="yes"
	
	p_print.Enabled =True
	p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'
	
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)



end event

type st_window from w_standard_dw_graph`st_window within w_pdt_02605
end type

type st_popup from w_standard_dw_graph`st_popup within w_pdt_02605
end type

type pb_title from w_standard_dw_graph`pb_title within w_pdt_02605
end type

type pb_space from w_standard_dw_graph`pb_space within w_pdt_02605
end type

type pb_color from w_standard_dw_graph`pb_color within w_pdt_02605
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_pdt_02605
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_pdt_02605
integer x = 14
integer y = 48
integer width = 2053
integer height = 132
string dataobject = "d_pdt_02605_00"
end type

event dw_ip::rbuttondown;call super::rbuttondown;Long  Curr_Row

Curr_Row  =  dw_ip.GetRow()

IF this.GetColumnName() = "gu1" THEN
	Open(w_gugan_popup)
   
	IF isnull(gs_code) OR gs_code = '' THEN RETURN
   dw_ip.SetItem(Curr_Row,"gu1",gs_code) 

ELSEIF this.GetColumnName() = "gu2" THEN
	Open(w_gugan_popup)
   
	IF isnull(gs_code) OR gs_code = '' THEN RETURN
   dw_ip.SetItem(Curr_Row,"gu2",gs_code) 

END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;

if dwo.name = "gu2" then
	if dec(gettext()) < getitemdecimal(1, "gu1") then
		MessageBox("구간", "구간의 범위가 부정확합니다", stopsign!)
		setitem(1, "gu2", 10)
		return 1
	end if
end if
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_pdt_02605
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_pdt_02605
end type

type st_10 from w_standard_dw_graph`st_10 within w_pdt_02605
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_pdt_02605
end type

type dw_list from w_standard_dw_graph`dw_list within w_pdt_02605
integer x = 814
integer width = 3781
string dataobject = "d_pdt_02605_01"
end type

event dw_list::doubleclicked;//

end event

type gb_10 from w_standard_dw_graph`gb_10 within w_pdt_02605
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_pdt_02605
integer x = 795
integer width = 3813
end type

type tv_1 from treeview within w_pdt_02605
integer x = 37
integer y = 244
integer width = 718
integer height = 2072
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean border = false
string picturename[] = {"ShowWatch5!","AddWatch5!","DeleteWatch5!"}
long picturemaskcolor = 553648127
string statepicturename[] = {"ShowWatch5!","AddWatch5!","DeleteWatch5!"}
long statepicturemaskcolor = 553648127
end type

event selectionchanged;Integer				i_main, i_sub1, i_sub2, i_loc, gu1, gu2
TreeViewItem		tv_Current
String            current_data, Ls_loc, Syymm
Long 					Lrow

dw_ip.accepttext()
gu1 = dw_ip.getitemdecimal(1, "gu1")
gu2 = dw_ip.getitemdecimal(1, "gu2")

SetPointer(HourGlass!)

if isnull(syymm) or trim(syymm) = '' then
	syymm = '%'
else
	syymm = syymm + '%'
end if

/* 현재의 레벨을 구한다.**************************************************************/
this.GetItem(newhandle, tv_Current)

i_Level = tv_Current.Level

current_data = String(tv_Current.Data)
scode = current_data
sname = String(tv_Current.label)

p_retrieve.triggerevent(clicked!)



end event

type rr_2 from roundrectangle within w_pdt_02605
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 232
integer width = 750
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

