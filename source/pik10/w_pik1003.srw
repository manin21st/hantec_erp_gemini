$PBExportHeader$w_pik1003.srw
$PBExportComments$** 근무 타입 등록
forward
global type w_pik1003 from w_inherite_standard
end type
type dw_detail from u_key_enter within w_pik1003
end type
type rr_1 from roundrectangle within w_pik1003
end type
end forward

global type w_pik1003 from w_inherite_standard
string title = "근무 타입 등록"
boolean maxbox = false
boolean resizable = false
dw_detail dw_detail
rr_1 rr_1
end type
global w_pik1003 w_pik1003

event open;call super::open;dw_detail.setTransObject(sqlca)

p_can.enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"

IF dw_detail.retrieve() < 1 THEN
	dw_detail.InsertRow(0)
END IF

dw_detail.SetColumn('ktype')
dw_detail.SetFocus()
end event

on w_pik1003.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.rr_1
end on

on w_pik1003.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.rr_1)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1003
integer x = 3899
end type

event p_mod::clicked;call super::clicked;long ll_row

ll_row = dw_detail.getRow()

if ll_row <= 0 then
	return
end if

dw_detail.acceptText()
IF isNull(dw_detail.getItemString(ll_row,"ktype")) or dw_detail.getItemString(ll_row,"ktype") = '' THEN
	MessageBox('저장 실패','근무타입은 반드시 입력하셔야 합니다!')
	dw_detail.setfocus()
	dw_detail.setcolumn('ktype')
	return
END IF

IF dw_detail.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
	ib_any_typing = True
	w_mdi_frame.sle_msg.text ="저장 실패!!"
	Return
END IF
	
dw_detail.retrieve()

p_can.enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"
end event

type p_del from w_inherite_standard`p_del within w_pik1003
integer x = 4073
end type

event p_del::clicked;call super::clicked;string ls_ktype
long   ll_row , ll_chk

ll_row   = dw_detail.getrow()

if ll_row <= 0 then
	return
end if
ls_ktype  = dw_detail.Object.ktype[ll_row]
ll_chk   = messagebox('삭제','선택 항목을 삭제하시겠습니까?',QUESTION!,okcancel!,2)

if ll_chk = 1 then
	if dw_detail.deleteRow(ll_row) = 1 then
		delete from p0_ktype
		 where ktype = :ls_ktype;
		commit;

		w_mdi_frame.sle_msg.text = '자료가 삭제되었습니다.'
	else
		w_mdi_frame.sle_msg.text = '자료 삭제에 실패하였습니다.'
		return
	end if
else
	return
end if

//dw_detail.retrieve()
dw_detail.setfocus()
dw_detail.setRow(ll_row)
dw_detail.setcolumn('ktype')

p_can.enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"

end event

type p_inq from w_inherite_standard`p_inq within w_pik1003
boolean visible = false
integer x = 1449
integer y = 2460
end type

type p_print from w_inherite_standard`p_print within w_pik1003
boolean visible = false
integer x = 1275
integer y = 2460
end type

type p_can from w_inherite_standard`p_can within w_pik1003
integer x = 4247
end type

event p_can::clicked;call super::clicked;dw_detail.retrieve()

enabled = false
PictureName = "C:\erpman\image\취소_d.gif"
end event

type p_exit from w_inherite_standard`p_exit within w_pik1003
integer x = 4421
end type

type p_ins from w_inherite_standard`p_ins within w_pik1003
integer x = 3726
end type

event p_ins::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ""

long ll_row

ll_row = dw_detail.getRow()

if ll_row > 0 then
	dw_detail.acceptText()
	IF isNull(dw_detail.getItemString(ll_row,"ktype")) or dw_detail.getItemString(ll_row,"ktype") = '' THEN
		MessageBox('입력 오류','근무타입은 반드시 입력하셔야 합니다!')
		dw_detail.setfocus()
		dw_detail.setcolumn('ktype')
		return
	END IF
end if

dw_detail.scrolltorow(dw_detail.insertrow(ll_row + 1))

dw_detail.setItem(ll_row + 1,"sagubn",'1')

dw_detail.setfocus()
dw_detail.setcolumn('ktype')

p_can.enabled = true
p_can.PictureName = "C:\erpman\image\취소_up.gif"

w_mdi_frame.sle_msg.text = "자료가 추가되었습니다."
end event

type p_search from w_inherite_standard`p_search within w_pik1003
boolean visible = false
integer x = 1097
integer y = 2460
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1003
boolean visible = false
integer x = 1623
integer y = 2460
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1003
boolean visible = false
integer x = 1797
integer y = 2460
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1003
boolean visible = false
integer x = 832
integer y = 2464
end type

type st_window from w_inherite_standard`st_window within w_pik1003
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1003
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1003
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1003
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1003
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1003
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1003
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1003
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1003
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1003
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1003
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1003
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1003
boolean visible = false
end type

type dw_detail from u_key_enter within w_pik1003
integer x = 55
integer y = 216
integer width = 4526
integer height = 2024
integer taborder = 11
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik1003_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)
end event

type rr_1 from roundrectangle within w_pik1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 212
integer width = 4553
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

