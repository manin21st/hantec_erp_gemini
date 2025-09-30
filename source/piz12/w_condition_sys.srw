$PBExportHeader$w_condition_sys.srw
$PBExportComments$** 환경설정
forward
global type w_condition_sys from w_inherite_multi
end type
type p_mod2 from uo_picture within w_condition_sys
end type
type dw_detail2 from datawindow within w_condition_sys
end type
type dw_list from datawindow within w_condition_sys
end type
type dw_datetime1 from datawindow within w_condition_sys
end type
type rr_1 from roundrectangle within w_condition_sys
end type
type rr_2 from roundrectangle within w_condition_sys
end type
end forward

global type w_condition_sys from w_inherite_multi
string title = "환경 설정"
p_mod2 p_mod2
dw_detail2 dw_detail2
dw_list dw_list
dw_datetime1 dw_datetime1
rr_1 rr_1
rr_2 rr_2
end type
global w_condition_sys w_condition_sys

forward prototypes
public subroutine wf_cb_enabled (boolean pa)
public function integer wf_err_check ()
end prototypes

public subroutine wf_cb_enabled (boolean pa);p_addrow.enabled = pa
p_del.enabled = pa
p_mod.enabled   = pa
end subroutine

public function integer wf_err_check ();long    row_count, find_count, seek_count
string  line_check 

FOR row_count= 1 TO dw_list.rowcount()
    // 코드 check
    if dw_list.getitemstring(row_count, "lineno") = "" or &       
       isnull(dw_list.getitemstring(row_count, "lineno")) then
       dw_list.setcolumn("lineno")
       dw_list.setrow(row_count)
       messagebox("코드", "코드 입력하십시요", stopsign!)
       dw_list.setfocus()
       return -1
    end if
    // 구분명 check
    if dw_list.getitemstring(row_count, "titlename") = "" or &       
       isnull(dw_list.getitemstring(row_count, "titlename")) then
       dw_list.setcolumn("titlename")
       dw_list.setrow(row_count)
       messagebox("구분명", "구분명을 입력하십시요", stopsign!)
       dw_list.setfocus()
       return -1
    end if
NEXT

FOR row_count=1 TO dw_list.rowcount() - 1
    seek_count = row_count + 1
    line_check = dw_list.getitemstring(row_count, "lineno")    
    find_count  = dw_list.find("lineno = '" + line_check + "'", seek_count, dw_list.rowcount())    
    if find_count > 0 then  /* duplicate */
       messagebox("코드", "동일한 코드가 발생하였읍니다.", stopsign!)
       dw_list.setcolumn("lineno")
       dw_list.setrow(find_count)
       dw_list.setfocus()
       return -1
    end if
NEXT

return 0


end function

on w_condition_sys.create
int iCurrent
call super::create
this.p_mod2=create p_mod2
this.dw_detail2=create dw_detail2
this.dw_list=create dw_list
this.dw_datetime1=create dw_datetime1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_mod2
this.Control[iCurrent+2]=this.dw_detail2
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.dw_datetime1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_condition_sys.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_mod2)
destroy(this.dw_detail2)
destroy(this.dw_list)
destroy(this.dw_datetime1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_detail2.settransobject(sqlca)
dw_datetime1.settransobject(sqlca)
dw_datetime1.insertrow(0)

dw_detail2.reset()
dw_detail2.retrieve()







end event

type p_delrow from w_inherite_multi`p_delrow within w_condition_sys
integer x = 3739
end type

event p_delrow::clicked;call super::clicked;long 	lcRow
String sdata1, sdata2, sdata3
lcRow = dw_list.GetRow()

if lcRow <= 0 then return
if f_msg_delete() = -1 then return
	
sdata1 = Trim(dw_list.GetItemString(lcRow, "sysgu"))
sdata2 = Trim(String(dw_list.GetItemNumber(lcRow, "serial")))
sdata3 = Trim(dw_list.GetItemString(lcRow, "lineno"))

dw_list.DeleteRow(lcRow)
if sdata1 = "" or IsNull(sdata1) or &
	sdata1 = "" or IsNull(sdata1) or &
	sdata1 = "" or IsNull(sdata1) then 
elseif dw_list.Update() <> 1 then
   f_message_chk(31,'[삭제실패]') 
	ROLLBACK;
	Return
end if
if dw_list.RowCount() <= 0 then //전부 삭제된 경우 - 관리구분 삭제
	p_del.TriggerEvent(Clicked!)
	return
end if
COMMIT;
dw_list.SetColumn("lineno")
dw_list.SetFocus()



end event

type p_addrow from w_inherite_multi`p_addrow within w_condition_sys
integer x = 3566
end type

event p_addrow::clicked;call super::clicked;long lcRow, ldRow

if dw_list.GetRow() > 0 then
	lcRow = dw_list.GetRow() + 1
	dw_list.insertrow(lcRow)
ELSE
	lcRow = dw_list.insertrow(lcRow)
END IF

ldRow = dw_detail2.GetRow()
dw_list.setitem(lcRow, "sysgu", dw_detail2.getitemString(ldRow, "sysgu"))
dw_list.setitem(lcRow, "serial", dw_detail2.getitemNumber(ldRow, "serial"))

dw_list.setcolumn("lineno")
dw_list.setrow(lcRow)
dw_list.scrolltorow(lcRow)
dw_list.setfocus()

end event

type p_search from w_inherite_multi`p_search within w_condition_sys
integer x = 1029
integer y = 20
integer width = 306
string picturename = "C:\erpman\image\환경설정등록_up.gif"
end type

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\환경설정등록_up.gif"
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\환경설정등록_dn.gif"
end event

event p_search::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

long lcRow
int ii
String pa1, pa2, pa3, srtn_msg

lcRow = dw_detail2.GetRow()
dw_detail2.insertrow(lcRow)

	if lcRow = 0 then //맨마지막에 추가
	   lcRow = dw_detail2.RowCount()
	end if	
   dw_detail2.setitem(lcRow, "sysgu", 'P')
	dw_detail2.setitem(lcRow, "lineno", '00')

   if lcRow > 0 then
		dw_detail2.settaborder("serial",10)
		dw_detail2.settaborder("titlename",20)
	end if
	dw_detail2.ScrollToRow (lcRow)


end event

type p_ins from w_inherite_multi`p_ins within w_condition_sys
integer x = 3963
integer y = 2576
end type

type p_exit from w_inherite_multi`p_exit within w_condition_sys
integer x = 4087
end type

type p_can from w_inherite_multi`p_can within w_condition_sys
integer x = 4137
integer y = 2584
end type

type p_print from w_inherite_multi`p_print within w_condition_sys
integer x = 3616
integer y = 2576
end type

type p_inq from w_inherite_multi`p_inq within w_condition_sys
integer x = 3790
integer y = 2576
end type

type p_del from w_inherite_multi`p_del within w_condition_sys
boolean visible = false
integer x = 1627
integer y = 20
end type

event p_del::clicked;call super::clicked;long 	lcRow

if MessageBox("확인", "삭제하시겠습니까 ?", Question!, YesNo!) = 2 then return
lcRow = dw_detail2.GetRow()
if lcRow <= 0 then 
	f_message_chk(36,'[자료선택]')
	return
end if	
dw_detail2.DeleteRow(lcRow)
if dw_detail2.Update() <> 1 then
   f_message_chk(31,'[삭제실패]') 
	ROLLBACK;
	Return
end if
COMMIT;
p_del.Visible = False
p_del.picturename = 'C:\erpman\image\삭제_d.gif'

end event

type p_mod from w_inherite_multi`p_mod within w_condition_sys
integer x = 3913
end type

event p_mod::clicked;call super::clicked;integer f_check

dw_list.AcceptText()

// 입력 error
if wf_err_check() = -1 then return

if f_msg_update() = -1 then return  //저장 Yes/No ?
if dw_list.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장되었습니다!"	
	ib_any_typing = False
else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if
end event

type dw_insert from w_inherite_multi`dw_insert within w_condition_sys
integer x = 1330
integer y = 2572
end type

type st_window from w_inherite_multi`st_window within w_condition_sys
end type

type cb_append from w_inherite_multi`cb_append within w_condition_sys
end type

type cb_exit from w_inherite_multi`cb_exit within w_condition_sys
end type

type cb_update from w_inherite_multi`cb_update within w_condition_sys
end type

type cb_insert from w_inherite_multi`cb_insert within w_condition_sys
end type

type cb_delete from w_inherite_multi`cb_delete within w_condition_sys
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_condition_sys
end type

type st_1 from w_inherite_multi`st_1 within w_condition_sys
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_condition_sys
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_condition_sys
end type

type sle_msg from w_inherite_multi`sle_msg within w_condition_sys
end type

type gb_2 from w_inherite_multi`gb_2 within w_condition_sys
end type

type gb_1 from w_inherite_multi`gb_1 within w_condition_sys
end type

type gb_10 from w_inherite_multi`gb_10 within w_condition_sys
end type

type p_mod2 from uo_picture within w_condition_sys
integer x = 1326
integer y = 20
integer width = 306
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\환경설정저장_up.gif"
end type

event clicked;if dw_detail2.accepttext() = -1 then return

if messagebox("저장", "저장하시겠습니까 ?", question!, yesno!) = 2 then return

if dw_detail2.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장되었습니다!"	
	ib_any_typing = False
else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 !"
	return 
end if


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\환경설정저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\환경설정저장_up.gif"
end event

type dw_detail2 from datawindow within w_condition_sys
integer x = 475
integer y = 220
integer width = 1330
integer height = 2048
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_condition_sys_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;if wf_warndataloss("종료") = -1 then return

SelectRow(0,False)
dw_list.Reset()

if CurrentRow > 0 then
	SelectRow(CurrentRow,TRUE)
   dw_list.Retrieve(this.object.sysgu[CurrentRow], this.object.serial[CurrentRow])
	wf_cb_enabled(True)
	dw_list.Enabled = True
	p_del.Enabled = True
	p_del.picturename = 'C:\erpman\image\삭제_up.gif'
end if
end event

type dw_list from datawindow within w_condition_sys
event ue_downenter pbm_dwnprocessenter
integer x = 1902
integer y = 220
integer width = 2368
integer height = 2048
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_condition_sys_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;if dw_list.getcolumnname() = "dataname" and &
    dw_list.rowcount() = dw_list.getrow() then
   if p_mod.Enabled then p_mod.SetFocus()
else
	Send(Handle(this), 256, 9, 0 )
end if
Return 1
end event

event dberror;return 1
end event

event editchanged;ib_any_typing = true
end event

event getfocus;p_del.Enabled = False
p_del.picturename = 'C:\erpman\image\삭제_d.gif'
end event

event itemchanged;String sColName, sData
long lcRow, lrRow

lcRow  = GetRow()	
sColName = GetColumnName()
sData = Trim(GetText())

if sColName = "lineno" then
	if IsNull(sData) or sData = "" then 
		f_message_chk(1400,'[필수입력]') 
		p_mod.Enabled = False
		p_mod.picturename = 'C:\erpman\image\저장_d.gif'
		return 1		
	else
		p_mod.Enabled = True
		p_mod.picturename = 'C:\erpman\image\저장_up.gif'
	end if	
	lrRow = Find("lineno = '" + sData + "'", 1, RowCount())
	if (lcRow <> lrRow) and (lrRow <> 0) then
	   f_message_chk(1,'[자료중복]') 
		p_mod.Enabled = False
		p_mod.picturename = 'C:\erpman\image\저장_d.gif'
		return 1		
	else
		p_mod.Enabled = True
		p_mod.picturename = 'C:\erpman\image\저장_up.gif'
	end if
elseif sColName = "titlename" then
	if IsNull(sData) or sData = "" then 
		f_message_chk(1400,'[필수입력]') 
		p_mod.Enabled = False
		p_mod.picturename = 'C:\erpman\image\저장_d.gif'
		return 1		
	else
		p_mod.Enabled = True
		p_mod.picturename = 'C:\erpman\image\저장_up.gif'
	end if	
//elseif dwo.name ="datagu" then
//	if Integer(sData) = 1 then
//		dw_list.Modify("dataname.Edit.AutoVScroll =No")
//		dw_list.Modify("dataname.Height.AutoSize  =No")
//	else
//		dw_list.Modify("dataname.Edit.AutoVScroll =Yes")
//		dw_list.Modify("dataname.Height.AutoSize  =Yes")
//	end if
end if
return
end event

event itemerror;RETURN 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)
IF dwo.name ="titlename" OR dwo.name ="dataname" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

type dw_datetime1 from datawindow within w_condition_sys
boolean visible = false
integer x = 2935
integer y = 2760
integer width = 750
integer height = 84
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_condition_sys
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 466
integer y = 212
integer width = 1353
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_condition_sys
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1893
integer y = 212
integer width = 2395
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

