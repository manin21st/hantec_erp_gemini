$PBExportHeader$w_cic00020.srw
$PBExportComments$제품별 단량표 등록
forward
global type w_cic00020 from w_inherite_multi
end type
type dw_list from u_d_select_sort within w_cic00020
end type
type p_1 from uo_picture within w_cic00020
end type
type dw_choose from datawindow within w_cic00020
end type
type dw_excel from datawindow within w_cic00020
end type
type p_2 from picture within w_cic00020
end type
type p_3 from uo_picture within w_cic00020
end type
type rr_1 from roundrectangle within w_cic00020
end type
type rr_2 from roundrectangle within w_cic00020
end type
end forward

global type w_cic00020 from w_inherite_multi
integer width = 4768
integer height = 2972
string title = "제품별 단량표 등록"
dw_list dw_list
p_1 p_1
dw_choose dw_choose
dw_excel dw_excel
p_2 p_2
p_3 p_3
rr_1 rr_1
rr_2 rr_2
end type
global w_cic00020 w_cic00020

type variables
string is_itnbr
end variables

on w_cic00020.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.p_1=create p_1
this.dw_choose=create dw_choose
this.dw_excel=create dw_excel
this.p_2=create p_2
this.p_3=create p_3
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.dw_choose
this.Control[iCurrent+4]=this.dw_excel
this.Control[iCurrent+5]=this.p_2
this.Control[iCurrent+6]=this.p_3
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_cic00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.p_1)
destroy(this.dw_choose)
destroy(this.dw_excel)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_list.retrieve()

is_itnbr = dw_list.GetItemString(1,"itnbr")
end event

type p_delrow from w_inherite_multi`p_delrow within w_cic00020
integer x = 1778
integer y = 2624
integer taborder = 100
end type

type p_addrow from w_inherite_multi`p_addrow within w_cic00020
integer x = 1605
integer y = 2624
integer taborder = 80
end type

type p_search from w_inherite_multi`p_search within w_cic00020
integer x = 1266
integer y = 2624
integer taborder = 190
end type

type p_ins from w_inherite_multi`p_ins within w_cic00020
integer x = 3525
integer taborder = 50
end type

event p_ins::clicked;call super::clicked;
decimal ls_qty
string stdat, endat

if dw_insert.RowCount() = 0 then
	dw_insert.insertRow(0)
	dw_insert.Setitem(dw_insert.rowcount(),"cic0050_itnbr", is_itnbr)
else
	
	ls_qty = dw_insert.GetItemdecimal(dw_insert.rowcount(), "cic0050_un_qty")
	stdat = dw_insert.GetItemString(dw_insert.rowcount(), "cic0050_stdat")
	endat = dw_insert.GetItemString(dw_insert.rowcount(), "cic0050_endat")
	
	if isnull(ls_qty)  then
		messagebox("확인","메타당 소요량은 필수입력사항입니다.")
		return 1
	end if
	
	if ls_qty = 0  then
		messagebox("확인","메타당 소요량은 0이 될수 없습니다.")
		return 1
	end if
	
	if stdat = '' or isnull(stdat) then
		dw_insert.SetItem(dw_insert.RowCount(), "cic0050_stdat", '19000101')
	end if
	
	if endat = '' or isnull(endat) then
		dw_insert.SetItem(dw_insert.RowCount(), "cic0050_endat", '99991231')
	end if
	
	dw_insert.insertRow(0)
	dw_insert.Setitem(dw_insert.rowcount(),"cic0050_itnbr", is_itnbr)
end if

dw_insert.setcolumn("cic0050_opseq")
dw_insert.scrolltorow(dw_insert.rowcount())
dw_insert.setfocus()
end event

type p_exit from w_inherite_multi`p_exit within w_cic00020
integer taborder = 180
end type

type p_can from w_inherite_multi`p_can within w_cic00020
integer taborder = 160
end type

event p_can::clicked;call super::clicked;dw_insert.retrieve(is_itnbr)
end event

type p_print from w_inherite_multi`p_print within w_cic00020
integer x = 1440
integer y = 2624
integer taborder = 200
end type

type p_inq from w_inherite_multi`p_inq within w_cic00020
integer x = 3351
end type

event p_inq::clicked;call super::clicked;dw_list.retrieve()
end event

type p_del from w_inherite_multi`p_del within w_cic00020
integer x = 3698
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

type p_mod from w_inherite_multi`p_mod within w_cic00020
integer taborder = 120
end type

event p_mod::clicked;call super::clicked;decimal ls_qty
int ls_row
string stdat, endat, sItnbr

IF MessageBox("확 인","자료를 저장하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

dw_list.Accepttext()

ls_qty = dw_insert.GetItemdecimal(dw_insert.rowcount(), "cic0050_un_qty")
stdat = dw_insert.GetItemString(dw_insert.rowcount(), "cic0050_stdat")
endat = dw_insert.GetItemString(dw_insert.rowcount(), "cic0050_endat")
sItnbr = dw_insert.GetItemString(dw_insert.rowcount(), "cic0050_itnbr")

if isnull(ls_qty)  then
	messagebox("확인","메타당 소요량은 필수입력사항입니다.")
	return 1
end if

if ls_qty = 0  then
	messagebox("확인","메타당 소요량은 0이 될수 없습니다.")
	return 1
end if

if stdat = '' or isnull(stdat) then
	dw_insert.SetItem(dw_insert.RowCount(), "cic0050_stdat", '19000101')
end if

if endat = '' or isnull(endat) then
	dw_insert.SetItem(dw_insert.RowCount(), "cic0050_endat", '99991231')
end if

IF dw_insert.Update() <> 1 THEN
	MessageBox("확 인","자료 저장을 실패하였습니다!!")
	ROLLBACK;
	ib_any_typing = True
	Return
END IF

commit;

w_mdi_frame.sle_msg.text ="자료가 저장되었습니다."

ls_row = dw_list.GetRow()
//// 수정한 품번으로 위치 이동
dw_list.SetRedraw(False)
//dw_list.Retrieve(sItnbr)
dw_list.Retrieve()

integer iRow
iRow = dw_list.Find("itnbr = '"+sItnbr+"'" ,1,dw_list.RowCount())
if iRow > 0 then
	dw_list.ScrollToRow(iRow)
	dw_list.SelectRow(iRow,True)
end if
dw_list.SetRedraw(True)
//
//dw_list.retrieve()
//dw_list.selectrow(0,false) 
//dw_list.selectrow(ls_row,true) 

dw_insert.retrieve(dw_list.GetItemString(ls_row, "itnbr"))




end event

type dw_insert from w_inherite_multi`dw_insert within w_cic00020
integer x = 2098
integer y = 208
integer width = 2482
integer height = 2008
integer taborder = 20
string dataobject = "d_cic00020_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

int ll_lstrow, ll_row, ls_row
string ls_itnbr, ls_itdsc, ls_opseq, ls_pumsr

ls_row = dw_insert.rowcount()

this.AcceptText()
ls_opseq = this.GetItemString(ls_row,'cic0050_opseq')
if isnull(ls_opseq) or ls_opseq = '' then
   ls_opseq = '0010'
end if
			
IF this.GetColumnName() ="cic0050_mitnbr" THEN
	Open(w_itemas_popup10_cic)
	
	dw_choose.Reset()
	dw_choose.ImportClipboard()


    string ls_filter
    Int  li_row, li_Trow, li_seq
    ls_filter = "flag = 'Y'"
    dw_choose.SetFilter(ls_filter)
    dw_choose.filter()
	 
 	ll_lstrow = dw_choose.RowCount()

	if ll_lstrow < 1 then Return 
		
		For ll_row = 1 to ll_lstrow
			
			ls_itnbr = dw_choose.GetItemString(ll_row,'itemas_itnbr')

			This.SetItem(( ls_row + ll_row -1 ), 'cic0050_mitnbr', ls_itnbr )
			This.SetItem(( ls_row + ll_row -1 ), 'cic0050_opseq', ls_opseq )			
			This.SetItem(( ls_row + ll_row -1 ), 'cic0050_itnbr', is_itnbr )			
	
			select itdsc
			into :ls_itdsc
			from cic_itemas_vw
			where itnbr = :ls_itnbr;
			
			This.SetItem(( ls_row + ll_row -1 ), 'cic_itemas_vw_itdsc', ls_itdsc )
			
			
			SELECT pumsr
			INTO :ls_pumsr
			FROM itemas
			WHERE  itnbr = :ls_itnbr;
			
			This.SetItem(( ls_row + ll_row -1 ), 'itemas_pumsr', ls_pumsr )
			
//			if ll_row > 1 then
//				this.SetItem(ll_row+ls_row, "cic0050_opseq", this.GetitemString(ll_row-1, "cic0050_opseq"))
//			end if
				
			if ll_row = ll_lstrow then Continue
			This.InsertRow( ll_row + ls_row )

		Next
		
END IF


IF this.GetColumnName() ="cic_itemas_vw_itdsc" THEN
	Open(w_itemas_popup10_cic)
	
	dw_choose.Reset()
	ll_lstrow = dw_choose.ImportClipboard()

	if ll_lstrow < 1 then Return 

		
		For ll_row = 1 to ll_lstrow
			ls_itnbr = dw_choose.GetItemString(ll_row,'itnbr')
			This.SetItem(( ls_row + ll_row -1 ), 'cic0050_mitnbr', ls_itnbr )
			
			select itdsc
			into :ls_itdsc
			from cic_itemas_vw
			where itnbr = :ls_itnbr;
			
			This.SetItem(( ls_row + ll_row -1 ), 'cic_itemas_vw_itdsc', ls_itdsc )
			
//			if ll_row > 1 then
//				this.SetItem(ls_row+ll_row, "cic0050_opseq", this.GetitemString(ll_row-1, "cic0050_opseq"))
//			end if
		
			if ll_row = ll_lstrow then Continue
			This.InsertRow( ll_row + ls_row)

		Next
END IF





end event

event dw_insert::itemchanged;call super::itemchanged;String  sItnbr, ls_itdsc, sNull, ls_pumsr

SetNull(snull)

IF this.GetColumnName() = "cic0050_mitnbr" THEN
   sItnbr = this.GetText()
	IF sItnbr = '' OR ISNULL(sItnbr) THEN RETURN
	
	SELECT itdsc
		INTO :ls_itdsc
		FROM cic_itemas_vw
		WHERE itnbr = :sItnbr   ;
	IF SQLCA.SQLCODE = 0 THEN
         This.SetItem(row, 'cic_itemas_vw_itdsc', ls_itdsc )
	end if
	
	SELECT pumsr
		INTO :ls_pumsr
		FROM itemas
		WHERE itnbr = :sItnbr   ;
	IF SQLCA.SQLCODE = 0 THEN
         This.SetItem(row, 'itemas_pumsr', ls_pumsr )
	end if
	
END IF	  
ib_any_typing =True

end event

type st_window from w_inherite_multi`st_window within w_cic00020
integer taborder = 60
end type

type cb_append from w_inherite_multi`cb_append within w_cic00020
integer taborder = 30
end type

type cb_exit from w_inherite_multi`cb_exit within w_cic00020
integer taborder = 170
end type

type cb_update from w_inherite_multi`cb_update within w_cic00020
integer taborder = 90
end type

type cb_insert from w_inherite_multi`cb_insert within w_cic00020
integer taborder = 70
end type

type cb_delete from w_inherite_multi`cb_delete within w_cic00020
integer taborder = 110
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_cic00020
integer taborder = 150
end type

type st_1 from w_inherite_multi`st_1 within w_cic00020
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_cic00020
integer taborder = 130
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_cic00020
end type

type sle_msg from w_inherite_multi`sle_msg within w_cic00020
end type

type gb_2 from w_inherite_multi`gb_2 within w_cic00020
end type

type gb_1 from w_inherite_multi`gb_1 within w_cic00020
end type

type gb_10 from w_inherite_multi`gb_10 within w_cic00020
end type

type dw_list from u_d_select_sort within w_cic00020
integer x = 27
integer y = 208
integer width = 2030
integer height = 2016
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_cic00020_1"
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

type p_1 from uo_picture within w_cic00020
integer x = 3177
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
DECLARE cic0050_sp PROCEDURE FOR cic0050_sp();
EXECUTE cic0050_sp;
IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
	MessageBox('DB Procedure Error',SQLCA.SQLERRTEXT)
	RETURN
END IF
p_inq.TriggerEvent(Clicked!)

end event

type dw_choose from datawindow within w_cic00020
boolean visible = false
integer x = 1815
integer width = 169
integer height = 168
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_itemas_popup10_detail_cic"
boolean border = false
end type

type dw_excel from datawindow within w_cic00020
boolean visible = false
integer x = 2592
integer y = 36
integer width = 425
integer height = 148
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_cic00020_p"
boolean border = false
boolean livescroll = true
end type

event constructor;SetTransObject(Sqlca)
end event

type p_2 from picture within w_cic00020
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = -5001
integer y = 480
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;PictureName = "C:\erpman\image\엑셀변환_up.gif"
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\엑셀변환_dn.gif"
end event

type p_3 from uo_picture within w_cic00020
integer x = 4046
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\엑셀변환_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\엑셀변환_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\엑셀변환_up.gif"
end event

event clicked;call super::clicked;//2008.04.21 엑셀저장기능 추가 - 조성원
String docname, named
Long value
docname = "제품별 단랑표"
value = GetFileSaveName("Select File",	docname, named, "excel",  " Excel Files (*.xls), *.xls")
SETPOINTER(HOURGLASS!)		
IF value = 1 THEN 			
	dw_excel.Retrieve()
	dw_excel.saveasascii(docname, '	', '')
END IF
end event

type rr_1 from roundrectangle within w_cic00020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 18
integer y = 204
integer width = 2057
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_cic00020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2089
integer y = 204
integer width = 2505
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

