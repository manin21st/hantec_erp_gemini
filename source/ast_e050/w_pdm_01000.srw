$PBExportHeader$w_pdm_01000.srw
$PBExportComments$참조코드등록
forward
global type w_pdm_01000 from w_inherite
end type
type rb_1 from radiobutton within w_pdm_01000
end type
type cbx_account from checkbox within w_pdm_01000
end type
type dw_detail from u_key_enter within w_pdm_01000
end type
type dw_remark from datawindow within w_pdm_01000
end type
type dw_list from u_d_popup_sort within w_pdm_01000
end type
type cbx_1 from checkbox within w_pdm_01000
end type
type rb_2 from radiobutton within w_pdm_01000
end type
type rb_3 from radiobutton within w_pdm_01000
end type
type gb_1 from groupbox within w_pdm_01000
end type
type rr_1 from roundrectangle within w_pdm_01000
end type
type rr_2 from roundrectangle within w_pdm_01000
end type
type rr_3 from roundrectangle within w_pdm_01000
end type
type rr_4 from roundrectangle within w_pdm_01000
end type
end forward

global type w_pdm_01000 from w_inherite
integer height = 2480
string title = "참조코드 등록"
rb_1 rb_1
cbx_account cbx_account
dw_detail dw_detail
dw_remark dw_remark
dw_list dw_list
cbx_1 cbx_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_pdm_01000 w_pdm_01000

type variables
String  LsGubun, is_delgub
end variables

forward prototypes
public function integer wf_requiredchk (integer irow)
end prototypes

public function integer wf_requiredchk (integer irow);String sRfGub,sRfna1,sRfna2

dw_detail.AcceptText()
sRfGub = dw_detail.getitemstring(iRow, "rfgub")
sRfNa1 = dw_detail.getitemstring(iRow, "rfna1")
sRfNa2 = dw_detail.getitemstring(iRow, "rfna2")

IF sRfGub = '' OR IsNull(sRfGub) THEN
	F_MessageChk(1,'[참조코드]')
	dw_detail.SetColumn("rfgub")
	dw_detail.SetFocus()
	Return -1
END IF

IF sRfNa1 = '' OR IsNull(sRfNa1) THEN
	F_MessageChk(1,'[참조명칭]')
	dw_detail.SetColumn("rfna1")
	dw_detail.SetFocus()
	Return -1
END IF

//IF sRfNa2 = '' OR IsNull(sRfna2) THEN
//	dw_detail.setitem(iRow, "rfna2", LEFT(sRfna1, 30)) 
//END IF

return 1


end function

on w_pdm_01000.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.cbx_account=create cbx_account
this.dw_detail=create dw_detail
this.dw_remark=create dw_remark
this.dw_list=create dw_list
this.cbx_1=create cbx_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.cbx_account
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_remark
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_3
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_3
this.Control[iCurrent+13]=this.rr_4
end on

on w_pdm_01000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.cbx_account)
destroy(this.dw_detail)
destroy(this.dw_remark)
destroy(this.dw_list)
destroy(this.cbx_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_insert.settransobject(sqlca)

dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_remark.settransobject(sqlca)

dw_detail.Reset()

//cbx_account.Checked = True
LsGubun ='00'

dw_list.Retrieve(LsGubun)
dw_list.Setfocus()

//cb_check()

end event

type dw_insert from w_inherite`dw_insert within w_pdm_01000
boolean visible = false
integer x = 37
integer y = 980
integer taborder = 0
string dataobject = "d_pdm_01000_4"
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01000
boolean visible = false
integer x = 2560
integer y = 2344
integer taborder = 0
string picturename = "C:\erpman\image"
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01000
boolean visible = false
integer x = 2386
integer y = 2344
integer taborder = 0
string picturename = ""
end type

type p_search from w_inherite`p_search within w_pdm_01000
boolean visible = false
integer x = 2907
integer y = 2344
integer taborder = 0
string picturename = ""
end type

type p_ins from w_inherite`p_ins within w_pdm_01000
integer x = 3479
boolean originalsize = true
end type

event p_ins::clicked;call super::clicked;Integer iRowCount,iFunctionValue,iCurRow

if dw_list.GetSelectedRow(0) <=0 then return

w_mdi_frame.sle_msg.text =""

iRowCount = dw_detail.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_detail.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF gs_userid = 'ADMIN' or gs_userid = '1406' then
	is_delgub = 'Y'
end if

IF iFunctionValue = 1 and is_delgub <> 'N' THEN
	iCurRow = iRowCount + 1
	
	dw_detail.InsertRow(iCurRow)

	dw_detail.ScrollToRow(iCurRow)
	dw_detail.setitem(iCurRow, "rfcod", 	dw_list.getitemstring(dw_list.GetSelectedRow(0), "rfcod"))
	dw_detail.setitem(iCurRow, "rfupdate", is_delgub )
	dw_detail.SetItem(iCurRow,'sflag','I')
	dw_detail.SetColumn("rfgub")
	dw_detail.SetFocus()
	
	ib_any_typing =False
	w_mdi_frame.sle_msg.Text = ''
Else
	w_mdi_frame.sle_msg.Text = '추가할 수 있는 참조코드가 아닙니다. 전산실로 연락하십시요!!!'
End If



end event

type p_exit from w_inherite`p_exit within w_pdm_01000
integer x = 4174
integer taborder = 110
boolean originalsize = true
end type

type p_can from w_inherite`p_can within w_pdm_01000
integer x = 4000
integer taborder = 100
boolean originalsize = true
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_detail.Reset()

dw_list.SelectRow(0,False)
dw_list.Retrieve(LsGubun)


end event

type p_print from w_inherite`p_print within w_pdm_01000
boolean visible = false
integer x = 3086
integer y = 2340
integer taborder = 0
string picturename = ""
end type

type p_inq from w_inherite`p_inq within w_pdm_01000
boolean visible = false
integer x = 2734
integer y = 2344
integer taborder = 0
string picturename = ""
end type

type p_del from w_inherite`p_del within w_pdm_01000
integer x = 3826
integer taborder = 80
boolean originalsize = true
end type

event p_del::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

IF dw_detail.GetRow() > 0 THEN 
	IF F_DbConFirm('삭제') = 2 THEN Return

	dw_detail.deleterow(0)
	IF dw_detail.Update() <> 1 THEN
		f_messagechk(12,"")
		ROLLBACK;
		Return
	END IF
	COMMIT;
END IF

if dw_detail.rowcount() <= 0 		then 														/* 전부 삭제된 경우 */  
	if messagebox("전산실 확인", "구분코드를 삭제하시겠습니까 ?",exclamation!, okcancel!) = 1 then
		dw_list.DeleteRow(dw_list.GetSelectedRow(0))
		IF dw_list.Update() <> 1 THEN
			f_messagechk(12,'[구분코드]')
			ROLLBACK;
			Return
		ELSE
			dw_remark.DeleteRow(0)
			IF dw_remark.Update() <> 1 THEN
				f_messagechk(12,'[참조값 설명]')
				ROLLBACK;
				Return
			END IF
		END IF
		Commit;
	end if   
end if

w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ib_any_typing = False


end event

type p_mod from w_inherite`p_mod within w_pdm_01000
integer x = 3653
integer taborder = 60
boolean originalsize = true
end type

event p_mod::clicked;call super::clicked;Integer  i

w_mdi_frame.sle_msg.text =""

dw_list.accepttext()
IF dw_list.GetSelectedRow(0) <=0 THEN Return

IF dw_detail.RowCount() <=0 THEN Return
FOR i = 1 TO dw_detail.RowCount()
	IF Wf_RequiredChk(i) = -1 THEN Return
NEXT

IF F_DbConfirm('저장') = 2 THEN Return

IF dw_detail.Update() <> 1 THEN
	f_messagechk(13,'')
	ROLLBACK;
	Return
ELSE
	IF dw_remark.Update() <> 1 THEN
		f_messagechk(13,'[참조값 설명]')
		ROLLBACK;
		Return
	END IF	
END IF
Commit;

FOR i = 1 TO dw_detail.RowCount()
	dw_detail.SetItem(i,'sflag','M')
NEXT
	
w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ib_any_typing = False

end event

type cb_exit from w_inherite`cb_exit within w_pdm_01000
integer x = 3433
integer y = 2684
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01000
integer x = 2350
integer y = 2684
integer taborder = 70
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01000
integer x = 379
integer y = 2684
integer taborder = 50
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01000
integer x = 2711
integer y = 2684
integer taborder = 90
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01000
integer x = 987
integer y = 2688
end type

type cb_print from w_inherite`cb_print within w_pdm_01000
integer x = 1353
integer y = 2692
end type

type st_1 from w_inherite`st_1 within w_pdm_01000
end type

type cb_can from w_inherite`cb_can within w_pdm_01000
integer x = 3072
integer y = 2684
end type

type cb_search from w_inherite`cb_search within w_pdm_01000
integer x = 1723
integer y = 2696
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_01000
integer x = 334
integer y = 2628
integer width = 421
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01000
integer x = 2318
integer y = 2628
end type

type rb_1 from radiobutton within w_pdm_01000
integer x = 2203
integer y = 68
integer width = 507
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "구분코드 등록"
end type

event clicked;OpenWithParm(w_pdm_01000a,'')
IF Left(Message.StringParm,1) = '1' THEN									/*신규코드 등록했으면*/
	dw_list.Selectrow(0,False)
	dw_list.Retrieve(LsGubun)
	dw_list.Setfocus()
	
	dw_detail.Reset()
END IF

end event

type cbx_account from checkbox within w_pdm_01000
integer x = 1600
integer y = 96
integer width = 526
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
string text = "회계사용코드만"
end type

event clicked;IF cbx_account.Checked = True THEN
	LsGubun ='AA'
ELSE
	LsGubun ='00'
END IF

dw_list.SelectRow(0,False)

dw_list.Retrieve(LsGubun)
dw_detail.Reset()

end event

type dw_detail from u_key_enter within w_pdm_01000
integer x = 1605
integer y = 320
integer width = 2720
integer height = 1684
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdm_01000_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="rfna1" OR dwo.name ="rfna2" or dwo.name = 'rfna3' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event editchanged;ib_any_typing = true
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event itemchanged;//String    sRfGub,sNull
//Integer   iFindRow,iCurRow
//
//SetNull(sNull)
//
//iCurRow = this.GetRow()
//IF this.GetColumnName() = "rfgub" THEN
//	sRfGub = this.GetText()
//	IF sRfGub = '' OR IsNull(sRfGub) THEN Return
//	
//	iFindRow = this.find("rfgub ='" + sRfGub + "'", 1, this.RowCount())
//
//	IF (iCurRow <> iFindRow) and (iFindRow <> 0) THEN
//		f_MessageChk(10,'[참조코드]')
//		this.SetItem(iCurRow,"rfgub",sNull)
//		RETURN  1
//	END IF
//
//END IF	
//


//String	ls_a
//
//IF GetColumnName() = 'rfna1' THEN
//	ls_a = Gettext()
//	MessageBox('',ls_a)
//END IF
end event

event itemerror;Return 1
end event

type dw_remark from datawindow within w_pdm_01000
integer x = 585
integer y = 2048
integer width = 3698
integer height = 228
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pdm_01000_3"
boolean border = false
boolean livescroll = true
end type

type dw_list from u_d_popup_sort within w_pdm_01000
integer x = 357
integer y = 32
integer width = 1193
integer height = 1972
integer taborder = 10
string dataobject = "d_pdm_01000_1"
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
	b_flag = True
ELSE
	this.SelectRow(0,False)
	this.SelectRow(row,True)

	b_flag = False
	
	dw_detail.Retrieve(this.GetItemString(row,"rfcod"))
	if dw_remark.Retrieve(this.GetItemString(row,"rfcod")) <=0 then
		dw_remark.InsertRow(0)
		dw_remark.SetItem(1,"rfcod",this.GetItemString(row,"rfcod"))
	end if
	
	is_delgub = this.getItemString(row, 'rfupdate')
	
END IF

call super ::clicked
end event

event rowfocuschanged;If currentrow > 0 then
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
	
	dw_detail.SetRedraw(False)
	dw_detail.Retrieve(this.GetItemString(currentrow,"rfcod"))
	dw_detail.SetRedraw(True)
	
	dw_remark.SetRedraw(False)
	if dw_remark.Retrieve(this.GetItemString(currentrow,"rfcod")) <=0 then
		dw_remark.InsertRow(0)
		dw_remark.SetItem(1,"rfcod", this.GetItemString(currentrow,"rfcod"))
	end if
	dw_remark.SetRedraw(True)
	
	this.ScrollToRow(currentrow)
	this.SetFocus()
END IF
end event

type cbx_1 from checkbox within w_pdm_01000
integer x = 2757
integer y = 72
integer width = 603
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "참조코드 미리보기"
end type

event clicked;cbx_1.Checked = False


dw_insert.retrieve(LsGubun) 

OpenWithParm(w_print_preview,dw_insert)
end event

type rb_2 from radiobutton within w_pdm_01000
integer x = 1618
integer y = 220
integer width = 526
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "관리항목 1,2,3"
boolean checked = true
end type

event clicked;dw_detail.DataObject = 'd_pdm_01000_2'
dw_remark.DataObject = 'd_pdm_01000_3'
dw_detail.SetTransObject(SQLCA)
dw_remark.SetTransObject(SQLCA)
dw_remark.reset()
dw_remark.insertRow(0)
end event

type rb_3 from radiobutton within w_pdm_01000
integer x = 2217
integer y = 220
integer width = 507
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "관리항목 4,5"
end type

event clicked;dw_detail.DataObject = 'd_pdm_01000_5'
dw_detail.SetTransObject(SQLCA)
dw_remark.DataObject = 'd_pdm_01000_3_1'
dw_remark.SetTransObject(SQLCA)
dw_remark.reset()
dw_remark.insertRow(0)
end event

type gb_1 from groupbox within w_pdm_01000
integer x = 1595
integer y = 172
integer width = 1179
integer height = 132
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_pdm_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 343
integer y = 24
integer width = 1216
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2158
integer y = 44
integer width = 1298
integer height = 116
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdm_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1595
integer y = 312
integer width = 2747
integer height = 1700
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pdm_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 343
integer y = 2024
integer width = 4005
integer height = 284
integer cornerheight = 40
integer cornerwidth = 55
end type

