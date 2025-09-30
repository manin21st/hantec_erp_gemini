$PBExportHeader$w_pdm_01360.srw
$PBExportComments$** 수입비용 산출율 등록
forward
global type w_pdm_01360 from w_inherite
end type
type gb_2 from groupbox within w_pdm_01360
end type
type gb_1 from groupbox within w_pdm_01360
end type
type st_2 from statictext within w_pdm_01360
end type
type rr_1 from roundrectangle within w_pdm_01360
end type
end forward

global type w_pdm_01360 from w_inherite
string title = "수입비용 산출율 등록"
gb_2 gb_2
gb_1 gb_1
st_2 st_2
rr_1 rr_1
end type
global w_pdm_01360 w_pdm_01360

forward prototypes
public function integer wf_required_chk ()
public function boolean wf_duplication_chk (integer crow)
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long i
if dw_insert.AcceptText() = -1 then return -1
for i = 1 to dw_insert.RowCount()
	if Isnull(Trim(dw_insert.object.hsno[i])) or Trim(dw_insert.object.hsno[i]) =  "" then
	   f_message_chk(1400,'[H.S No]')
	   dw_insert.SetColumn('hsno')
	   dw_insert.SetFocus()
	   return -1
   end if	
next

return 1
end function

public function boolean wf_duplication_chk (integer crow);String s1
long   ll_frow

s1 = Trim(dw_insert.object.hsno[crow])

ll_frow = dw_insert.Find("hsno = '" + s1 + "'", 1, crow - 1)
if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	return False
end if

ll_frow = dw_insert.Find("hsno = '" + s1 + "'", crow + 1, dw_insert.RowCount())

if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	return False
end if

return true
end function

on w_pdm_01360.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.gb_1=create gb_1
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_pdm_01360.destroy
call super::destroy
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Retrieve()
dw_insert.Setredraw(True)
dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01360
integer x = 507
integer y = 324
integer width = 3456
integer height = 1956
integer taborder = 10
string dataobject = "d_pdm_01360_01"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

event dw_insert::itemchanged;String sCol

this.AcceptText()
sCol = this.GetColumnName()
if sCol = "hsno" then
	if wf_duplication_chk(row) = False then
		this.object.hsno[row] = ""
		this.SetColumn("hsno")
		return 1
	end if	
elseif sCol = "cusrat" or sCol = "apprat" then
	if this.object.cusrat[row] > 100 then
		f_message_chk(34, String(this.object.cusrat[row]) + "=> [관세율 : 0 - 100 %]")
		this.object.cusrat[row] = 0 
		this.SetColumn("cusrat")
		return 1
	elseif this.object.apprat[row] > 100 then
		f_message_chk(34, String(this.object.apprat[row]) + "=> [비용적용율 : 0 - 100 %]")
		this.object.apprat[row] = 0
		this.SetColumn("apprat")
		return 1
	end if	
end if	

end event

type p_delrow from w_inherite`p_delrow within w_pdm_01360
boolean visible = false
integer x = 3255
integer y = 2792
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01360
boolean visible = false
integer x = 3081
integer y = 2792
end type

type p_search from w_inherite`p_search within w_pdm_01360
boolean visible = false
integer x = 2386
integer y = 2792
end type

type p_ins from w_inherite`p_ins within w_pdm_01360
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Long crow

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
dw_insert.Setredraw(True)
dw_insert.SetColumn("hsno") 
dw_insert.SetFocus()

end event

type p_exit from w_inherite`p_exit within w_pdm_01360
end type

type p_can from w_inherite`p_can within w_pdm_01360
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Retrieve()
dw_insert.Setredraw(True)

dw_insert.SetFocus()
w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_pdm_01360
boolean visible = false
integer x = 2560
integer y = 2792
end type

type p_inq from w_inherite`p_inq within w_pdm_01360
boolean visible = false
integer x = 2734
integer y = 2792
end type

type p_del from w_inherite`p_del within w_pdm_01360
end type

event p_del::clicked;call super::clicked;long 	lcRow

lcRow = dw_insert.GetRow()
if lcRow <= 0 then return
if f_msg_delete() = -1 then return
	
dw_insert.SetRedraw(False)
dw_insert.DeleteRow(lcRow)
if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
else	
   ROLLBACK;
	f_message_chk(31,'[삭제실폐]') 
	w_mdi_frame.sle_msg.Text = "삭제 작업 실패!"
	Return
end if
dw_insert.SetRedraw(True)
ib_any_typing = False //입력필드 변경여부 No
end event

type p_mod from w_inherite`p_mod within w_pdm_01360
end type

event p_mod::clicked;call super::clicked;if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return  //저장 Yes/No ?

if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
	ib_any_typing = False //입력필드 변경여부 No
else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if
 
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01360
boolean visible = false
integer x = 3689
integer y = 2644
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01360
boolean visible = false
integer x = 2647
integer y = 2644
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;//if wf_required_chk() = -1 then return //필수입력항목 체크 
//
//if f_msg_update() = -1 then return  //저장 Yes/No ?
//
//if dw_insert.Update() = 1 then
//	COMMIT;
//	sle_msg.text = "저장 되었습니다!"	
//	ib_any_typing = False //입력필드 변경여부 No
//else
//	f_message_chk(32,'[자료저장 실패]') 
//	ROLLBACK;
//   sle_msg.text = "저장작업 실패 하였습니다!"
//	return 
//end if
// 
end event

type cb_ins from w_inherite`cb_ins within w_pdm_01360
boolean visible = false
integer x = 2226
integer y = 2644
integer taborder = 20
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;//Long crow
//
//dw_insert.Setredraw(False)
//crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
//if IsNull(crow) then 
//	dw_insert.InsertRow(0)
//end if	
//dw_insert.ScrollToRow(crow)
//dw_insert.Setredraw(True)
//dw_insert.SetColumn("hsno") 
//dw_insert.SetFocus()
//
end event

type cb_del from w_inherite`cb_del within w_pdm_01360
boolean visible = false
integer x = 2994
integer y = 2644
integer taborder = 50
end type

event cb_del::clicked;call super::clicked;//long 	lcRow
//
//lcRow = dw_insert.GetRow()
//if lcRow <= 0 then return
//if f_msg_delete() = -1 then return
//	
//dw_insert.SetRedraw(False)
//dw_insert.DeleteRow(lcRow)
//if dw_insert.Update() = 1 then
//	COMMIT;
//	sle_msg.Text = "삭제 되었습니다!"
//else	
//   ROLLBACK;
//	f_message_chk(31,'[삭제실폐]') 
//	sle_msg.Text = "삭제 작업 실패!"
//	Return
//end if
//dw_insert.SetRedraw(True)
//ib_any_typing = False //입력필드 변경여부 No
end event

type cb_inq from w_inherite`cb_inq within w_pdm_01360
boolean visible = false
integer x = 997
integer y = 2752
end type

type cb_print from w_inherite`cb_print within w_pdm_01360
boolean visible = false
integer x = 1851
integer y = 2748
end type

type st_1 from w_inherite`st_1 within w_pdm_01360
end type

type cb_can from w_inherite`cb_can within w_pdm_01360
boolean visible = false
integer x = 3342
integer y = 2644
end type

event cb_can::clicked;call super::clicked;//sle_msg.text =""
//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 
//
//dw_insert.Setredraw(False)
//dw_insert.ReSet()
//dw_insert.Retrieve()
//dw_insert.Setredraw(True)
//
//dw_insert.SetFocus()
//sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
//ib_any_typing = False //입력필드 변경여부 No
//
//
end event

type cb_search from w_inherite`cb_search within w_pdm_01360
boolean visible = false
integer x = 1349
integer y = 2748
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01360
integer y = 2964
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01360
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01360
end type

type gb_2 from groupbox within w_pdm_01360
boolean visible = false
integer x = 2615
integer y = 2576
integer width = 1440
integer height = 208
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_pdm_01360
boolean visible = false
integer x = 2190
integer y = 2576
integer width = 411
integer height = 208
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_pdm_01360
integer x = 507
integer y = 232
integer width = 1426
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "◈ 관세율과 비용적용율은 퍼센트(%)로 입력하세요"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdm_01360
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 494
integer y = 312
integer width = 3515
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

