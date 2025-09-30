$PBExportHeader$w_kcda03.srw
$PBExportComments$참조코드등록
forward
global type w_kcda03 from w_inherite
end type
type dw_list from u_d_popup_sort within w_kcda03
end type
type rb_1 from radiobutton within w_kcda03
end type
type rb_3 from radiobutton within w_kcda03
end type
type cbx_account from checkbox within w_kcda03
end type
type dw_detail from u_key_enter within w_kcda03
end type
type dw_remark from datawindow within w_kcda03
end type
end forward

global type w_kcda03 from w_inherite
string title = "참조코드 등록"
boolean maxbox = true
dw_list dw_list
rb_1 rb_1
rb_3 rb_3
cbx_account cbx_account
dw_detail dw_detail
dw_remark dw_remark
end type
global w_kcda03 w_kcda03

type variables
String  LsGubun
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

IF sRfNa2 = '' OR IsNull(sRfNa2) THEN
	dw_detail.setitem(iRow, "rfna2", LEFT(sRfna1, 30)) 
END IF

return 1
end function

on w_kcda03.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.rb_1=create rb_1
this.rb_3=create rb_3
this.cbx_account=create cbx_account
this.dw_detail=create dw_detail
this.dw_remark=create dw_remark
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.cbx_account
this.Control[iCurrent+5]=this.dw_detail
this.Control[iCurrent+6]=this.dw_remark
end on

on w_kcda03.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.cbx_account)
destroy(this.dw_detail)
destroy(this.dw_remark)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_remark.settransobject(sqlca)

dw_detail.Reset()
cbx_account.Checked = True
LsGubun = 'AA'

dw_list.Retrieve(LsGubun)
dw_list.Setfocus()
end event

event resize;call super::resize;
dw_list.height = this.height - dw_list.y - 150
dw_detail.x = dw_list.x + dw_list.width + 10
dw_detail.width = this.width - dw_detail.x - 40
dw_detail.height = this.height - dw_detail.y - dw_remark.height - 160
dw_remark.x = dw_detail.x
dw_remark.y = this.height - dw_remark.height - 150
dw_remark.width = dw_detail.width
end event

event activate;call super::activate;
gw_window = this
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true)
end event

event ue_append;
Integer iRowCount,iFunctionValue,iCurRow
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

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	dw_detail.InsertRow(iCurRow)
	dw_detail.ScrollToRow(iCurRow)
	dw_detail.setitem(iCurRow, "rfcod", dw_list.getitemstring(dw_list.GetSelectedRow(0), "rfcod"))
	dw_detail.SetItem(iCurRow,'sflag','I')
	dw_detail.SetColumn("rfgub")
	dw_detail.SetFocus()
	ib_any_typing =False
END IF
end event

event ue_delete;
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

if dw_detail.rowcount() <= 0 then // 전부 삭제된 경우
	if messagebox("삭제 확인", "구분코드를 삭제하시겠습니까 ?",exclamation!, okcancel!) = 1 then
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

event ue_update;
Integer  i
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

event ue_cancel;
w_mdi_frame.sle_msg.text =""
dw_detail.Reset()
dw_list.SelectRow(0,False)
dw_list.Retrieve(LsGubun)
end event

type dw_list from u_d_popup_sort within w_kcda03
integer x = 59
integer y = 48
integer width = 1024
integer height = 1844
integer taborder = 10
string dataobject = "dw_kcda03_2"
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

type rb_1 from radiobutton within w_kcda03
integer x = 2304
integer y = 76
integer width = 507
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "구분코드 등록"
end type

event clicked;OpenWithParm(w_kcda03c,'')
IF Left(Message.StringParm,1) = '1' THEN //신규코드 등록했으면
	dw_list.Selectrow(0,False)
	dw_list.Retrieve(LsGubun)
	dw_list.Setfocus()
	dw_detail.Reset()
END IF
end event

type rb_3 from radiobutton within w_kcda03
integer x = 2830
integer y = 76
integer width = 654
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "참조코드 조회 출력"
end type

event clicked;OPEN(w_kcda03b)
end event

type cbx_account from checkbox within w_kcda03
integer x = 1285
integer y = 84
integer width = 526
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
string text = "회계사용코드만"
boolean checked = true
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

type dw_detail from u_key_enter within w_kcda03
integer x = 1143
integer y = 204
integer width = 3447
integer height = 1696
integer taborder = 30
string dataobject = "dw_kcda03_1"
end type

event itemchanged;String    sRfGub,sNull
Integer   iFindRow,iCurRow

SetNull(sNull)
iCurRow = this.GetRow()
IF this.GetColumnName() = "rfgub" THEN
	sRfGub = this.GetText()
	IF sRfGub = '' OR IsNull(sRfGub) THEN Return
	iFindRow = this.find("rfgub ='" + sRfGub + "'", 1, this.RowCount())
	IF (iCurRow <> iFindRow) and (iFindRow <> 0) THEN
		f_MessageChk(10,'[참조코드]')
		this.SetItem(iCurRow,"rfgub",sNull)
		RETURN  1
	END IF
END IF	
end event

type dw_remark from datawindow within w_kcda03
integer x = 46
integer y = 1936
integer width = 4567
integer height = 284
integer taborder = 40
string dataobject = "dw_kcda03_3"
boolean border = false
boolean livescroll = true
end type