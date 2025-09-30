$PBExportHeader$w_cic00030.srw
$PBExportComments$제품 공정별 ST등록
forward
global type w_cic00030 from w_inherite_multi
end type
type dw_list from u_d_select_sort within w_cic00030
end type
type p_1 from uo_picture within w_cic00030
end type
type p_3 from uo_picture within w_cic00030
end type
type dw_excel from datawindow within w_cic00030
end type
type rr_1 from roundrectangle within w_cic00030
end type
type rr_2 from roundrectangle within w_cic00030
end type
end forward

global type w_cic00030 from w_inherite_multi
integer width = 4695
integer height = 2612
string title = "제품 공정별 ST등록"
dw_list dw_list
p_1 p_1
p_3 p_3
dw_excel dw_excel
rr_1 rr_1
rr_2 rr_2
end type
global w_cic00030 w_cic00030

type variables
string is_itnbr
end variables

on w_cic00030.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.p_1=create p_1
this.p_3=create p_3
this.dw_excel=create dw_excel
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.p_3
this.Control[iCurrent+4]=this.dw_excel
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_cic00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.p_1)
destroy(this.p_3)
destroy(this.dw_excel)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_list.retrieve()

is_itnbr = dw_list.GetItemString(1,"itnbr")
end event

type p_delrow from w_inherite_multi`p_delrow within w_cic00030
integer x = 1778
integer y = 2624
integer taborder = 100
end type

type p_addrow from w_inherite_multi`p_addrow within w_cic00030
integer x = 1605
integer y = 2624
integer taborder = 80
end type

type p_search from w_inherite_multi`p_search within w_cic00030
integer x = 1266
integer y = 2624
integer taborder = 190
end type

type p_ins from w_inherite_multi`p_ins within w_cic00030
integer x = 3648
integer y = 2740
integer taborder = 50
end type

event p_ins::clicked;call super::clicked;
decimal ls_qty

if dw_insert.RowCount() = 0 then
	dw_insert.insertRow(0)
	dw_insert.Setitem(dw_insert.rowcount(),"cic0050_itnbr", is_itnbr)
else
	
	ls_qty = dw_insert.GetItemdecimal(dw_insert.rowcount(), "cic0050_un_qty")
	
	if isnull(ls_qty) or ls_qty = 0 then
		messagebox("확인","메타당 소요량은 필수입력사항입니다.")
		return 1
	end if
	
	dw_insert.insertRow(0)
	dw_insert.Setitem(dw_insert.rowcount(),"cic0050_itnbr", is_itnbr)
end if

dw_insert.setcolumn("cic0050_opseq")
dw_insert.scrolltorow(dw_insert.rowcount())
dw_insert.setfocus()
end event

type p_exit from w_inherite_multi`p_exit within w_cic00030
integer taborder = 180
end type

type p_can from w_inherite_multi`p_can within w_cic00030
integer taborder = 160
end type

event p_can::clicked;call super::clicked;dw_insert.retrieve(is_itnbr)
end event

type p_print from w_inherite_multi`p_print within w_cic00030
integer x = 1440
integer y = 2624
integer taborder = 200
end type

type p_inq from w_inherite_multi`p_inq within w_cic00030
integer x = 3698
end type

event p_inq::clicked;call super::clicked;dw_list.retrieve()
end event

type p_del from w_inherite_multi`p_del within w_cic00030
integer x = 3822
integer y = 2740
integer taborder = 140
end type

event p_del::clicked;call super::clicked;string ls_opseq, ls_mitnbr

ls_opseq = dw_insert.GetItemString(dw_insert.GetRow(),"cic0050_opseq")
ls_mitnbr = dw_insert.GetItemString(dw_insert.GetRow(),"cic0050_mitnbr")

IF MessageBox("확 인","공정순서 : "+ ls_opseq + "~n자재코드 : " + ls_mitnbr + "~n자료를 삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

dw_insert.deleterow(dw_insert.GetRow())


int ls_row

dw_list.Accepttext()

IF dw_insert.Update() <> 1 THEN
	MessageBox("확 인","자료 저장을 실패하였습니다!!")
	ROLLBACK;
	ib_any_typing = True
	Return
END IF

w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다."

ls_row = dw_list.GetRow()

dw_list.retrieve()

dw_list.selectrow(0,false) 
dw_list.selectrow(ls_row,true) 

dw_insert.retrieve(dw_list.GetItemString(ls_row, "itnbr"))




	
	
end event

type p_mod from w_inherite_multi`p_mod within w_cic00030
integer taborder = 120
end type

event p_mod::clicked;call super::clicked;decimal ls_qty, ls_chk
int ls_row

IF MessageBox("확 인","자료를 저장하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

dw_list.Accepttext()

//ls_qty = dw_insert.GetItemdecimal(dw_insert.rowcount(), "cic0050_un_qty")
//	
//if isnull(ls_qty) or ls_qty = 0 then
//	messagebox("확인","메타당 소요량은 필수입력사항입니다.")
//	return 1
//end if

/*IF dw_insert.Update() <> 1 THEN
	MessageBox("확 인","자료 저장을 실패하였습니다!!")
	ROLLBACK;
	ib_any_typing = True
	Return
END IF*/

select count(itnbr)
into :ls_chk
from cic0060 
where itnbr = :is_itnbr;

int i, s_row
decimal ls_linespeed, ls_stmin, ls_colinespeed, ls_costmin
string ls_rfgub, sItnbr

	s_row = dw_insert.RowCount()
	
	delete from cic0060 where itnbr = :is_itnbr;
	
	for i = 1 to  s_row
		ls_rfgub = dw_insert.GetItemString(i,"rfgub")
		ls_linespeed = dw_insert.GetItemdecimal(i,"linespeed")
		ls_stmin = dw_insert.GetItemdecimal(i,"stmin")
		ls_colinespeed = dw_insert.GetItemdecimal(i,"colinespeed")
		ls_costmin = dw_insert.GetItemdecimal(i,"costmin")
		sItnbr = dw_insert.GetItemString(i,"itnbr")		

						
		insert into cic0060 
		values (:is_itnbr, :ls_rfgub, :ls_linespeed, :ls_stmin, :ls_colinespeed, :ls_costmin);
		
		commit;
	next



w_mdi_frame.sle_msg.text ="자료가 저장되었습니다."

ls_row = dw_list.GetRow()

//dw_list.retrieve()
//// 수정한 품번으로 위치 이동
dw_list.SetRedraw(False)
dw_list.Retrieve()

integer iRow
iRow = dw_list.Find("itnbr = '"+sItnbr+"'" ,1,dw_list.RowCount())
if iRow > 0 then
	dw_list.ScrollToRow(iRow)
	dw_list.SelectRow(iRow,True)
end if
dw_list.SetRedraw(True)

////
//dw_list.selectrow(0,false) 
//dw_list.selectrow(ls_row,true) 


dw_insert.retrieve(dw_list.GetItemString(ls_row, "itnbr"))




end event

type dw_insert from w_inherite_multi`dw_insert within w_cic00030
integer x = 2592
integer y = 208
integer width = 1979
integer height = 2008
integer taborder = 20
string dataobject = "d_cic00030_2"
boolean hscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;decimal ls_linespeed, ls_stmin, ls_colinespeed, ls_costmin

this.accepttext()

if this.GetColumnName() = "linespeed" then
	ls_linespeed = this.GetItemDecimal(this.GetRow(), "linespeed")
	
	ls_stmin = round(1 / ls_linespeed,3)
	
	this.SetItem(this.GetRow(), "stmin", ls_stmin)
end if


if this.GetColumnName() = "colinespeed" then
	ls_colinespeed = this.GetItemDecimal(this.GetRow(), "colinespeed")
	
	ls_costmin = round(1 / ls_colinespeed,3)
	
	this.SetItem(this.GetRow(), "costmin", ls_costmin)
end if


this.SetItem(this.GetRow(), "itnbr", is_itnbr)
this.Setitem(this.GetRow(), "opseq", this.GetItemString(this.GetRow(), "rfgub"))



	
	
end event

type st_window from w_inherite_multi`st_window within w_cic00030
integer taborder = 60
end type

type cb_append from w_inherite_multi`cb_append within w_cic00030
integer taborder = 30
end type

type cb_exit from w_inherite_multi`cb_exit within w_cic00030
integer taborder = 170
end type

type cb_update from w_inherite_multi`cb_update within w_cic00030
integer taborder = 90
end type

type cb_insert from w_inherite_multi`cb_insert within w_cic00030
integer taborder = 70
end type

type cb_delete from w_inherite_multi`cb_delete within w_cic00030
integer taborder = 110
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_cic00030
integer taborder = 150
end type

type st_1 from w_inherite_multi`st_1 within w_cic00030
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_cic00030
integer taborder = 130
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_cic00030
end type

type sle_msg from w_inherite_multi`sle_msg within w_cic00030
end type

type gb_2 from w_inherite_multi`gb_2 within w_cic00030
end type

type gb_1 from w_inherite_multi`gb_1 within w_cic00030
end type

type gb_10 from w_inherite_multi`gb_10 within w_cic00030
end type

type dw_list from u_d_select_sort within w_cic00030
integer x = 27
integer y = 208
integer width = 2501
integer height = 2016
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_cic00030_1"
boolean hscrollbar = false
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;if this.rowcount() < 1 then return

this.selectrow(0,false)
this.selectrow(currentrow,true) 

string ls_itnbr

ls_itnbr = this.GetItemString(currentrow, "itnbr")

is_itnbr = ls_itnbr

if dw_insert.retrieve(ls_itnbr) < 1 then
	w_mdi_frame.sle_msg.text ="해당하는 자료가 없습니다."
else
	w_mdi_frame.sle_msg.text =""	
end if







end event

type p_1 from uo_picture within w_cic00030
integer x = 3525
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\생성_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event clicked;call super::clicked;IF MessageBox("확 인","변경된 자료를 불러오시겠습니까?",Question!,YesNo!) = 2 THEN RETURN	
SetPointer(HourGlass!)
DECLARE cic0060_sp PROCEDURE FOR cic0060_sp();
EXECUTE cic0060_sp;
IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
	MessageBox('DB Procedure Error',SQLCA.SQLERRTEXT)
	RETURN
END IF
p_inq.TriggerEvent(Clicked!)
end event

type p_3 from uo_picture within w_cic00030
integer x = 4046
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\엑셀변환_up.gif"
end type

event clicked;call super::clicked;//2008.04.21 엑셀저장기능 추가 - 조성원
String docname, named
Long value
docname = "제품 공정별 ST등록"
value = GetFileSaveName("Select File",	docname, named, "excel",  " Excel Files (*.xls), *.xls")
SETPOINTER(HOURGLASS!)		
IF value = 1 THEN 			
	dw_excel.Retrieve()
	dw_excel.saveasascii(docname, '	', '')
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\엑셀변환_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\엑셀변환_up.gif"
end event

type dw_excel from datawindow within w_cic00030
boolean visible = false
integer x = 2779
integer y = 20
integer width = 311
integer height = 112
integer taborder = 190
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_cic00030_excel"
boolean border = false
boolean livescroll = true
end type

event constructor;settransobject(sqlca)
end event

type rr_1 from roundrectangle within w_cic00030
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 18
integer y = 204
integer width = 2528
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_cic00030
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2578
integer y = 204
integer width = 2016
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

