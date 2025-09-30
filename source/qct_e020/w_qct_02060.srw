$PBExportHeader$w_qct_02060.srw
$PBExportComments$** 제안 사후 등록
forward
global type w_qct_02060 from w_inherite
end type
type gb_3 from groupbox within w_qct_02060
end type
type gb_2 from groupbox within w_qct_02060
end type
type gb_1 from groupbox within w_qct_02060
end type
type dw_1 from u_key_enter within w_qct_02060
end type
end forward

global type w_qct_02060 from w_inherite
string title = "제안 실시 사후 등록"
long backcolor = 12632256
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_1 dw_1
end type
global w_qct_02060 w_qct_02060

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//Long i
//
//for i = 1 to dw_insert.RowCount()
//	if IsNull(Trim(dw_insert.object.cnffir[i])) or Trim(dw_insert.object.cnffir[i]) = "" then
//		dw_insert.SetRow(i)
//		dw_insert.SetColumn("cnffir")
//		dw_insert.SetFocus()
//		return -1
//	end if	
//	if IsNull(Trim(dw_insert.object.cnfsec[i])) or Trim(dw_insert.object.cnfsec[i]) = "" then
//		dw_insert.SetRow(i)
//		dw_insert.SetColumn("cnfsec")
//		dw_insert.SetFocus()
//		return -1
//	end if	
//	if IsNull(Trim(dw_insert.object.cnfthi[i])) or Trim(dw_insert.object.cnfthi[i]) = "" then
//		dw_insert.SetRow(i)
//		dw_insert.SetColumn("cnfthi")
//		dw_insert.SetFocus()
//		return -1
//	end if	
//next
return 1

end function

on w_qct_02060.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_1
end on

on w_qct_02060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Setredraw(True)

dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)
dw_1.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_02060
integer x = 41
integer y = 192
integer width = 3561
integer height = 1676
integer taborder = 30
string dataobject = "d_qct_02060_02"
boolean vscrollbar = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String s_cod
Long crow

s_cod = Trim(this.GetText())
crow = this.GetRow()
if this.GetColumnName() = "cnffir" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[1차]")
		this.object.cnffir[crow] = ""
		return 1
	end if	
elseif this.GetColumnName() = "cnfsec" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[2차]")
		this.object.cnfsec[crow] = ""
		return 1
	end if	
elseif this.GetColumnName() = "cnfthi" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[3차]")
		this.object.cnfthi[crow] = ""
		return 1
	end if	
end if	

end event

event dw_insert::itemerror;return 1
end event

type cb_exit from w_inherite`cb_exit within w_qct_02060
integer x = 3232
integer y = 1936
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_qct_02060
integer x = 2496
integer y = 1936
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then	return

if dw_insert.RowCount() < 1 then
	messagebox("자료확인", "등록할 자료가 없습니다!")
	return
end if	

if wf_required_chk() = -1 then return

if f_msg_update() = -1 then return

IF dw_insert.Update() > 0 THEN		
	COMMIT;
	cb_inq.TriggerEvent(Clicked!)
	sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
END IF



end event

type cb_ins from w_inherite`cb_ins within w_qct_02060
boolean visible = false
integer taborder = 70
end type

type cb_del from w_inherite`cb_del within w_qct_02060
boolean visible = false
integer x = 923
integer taborder = 80
end type

type cb_inq from w_inherite`cb_inq within w_qct_02060
integer x = 73
integer y = 1936
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String sdate, edate, gu, simdpt

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return
end if	

simdpt = Trim(dw_1.object.simdpt[1])
sdate  = Trim(dw_1.object.sdate[1])
edate  = Trim(dw_1.object.edate[1])
gu     = Trim(dw_1.object.gu[1])

if IsNull(simdpt) or simdpt = "" then simdpt = "%"
if IsNull(sdate) or sdate = "" then sdate = "10000101"
if IsNull(edate) or edate = "" then edate = "99991231"

if dw_insert.Retrieve(gs_sabu, simdpt, sdate, edate, gu) < 1 then
	f_message_chk(50, "[제안 사후 등록]")
	sle_msg.text = "해당하는 자료가 없습니다!"
end if

ib_any_typing = False //입력필드 변경여부 No

end event

type cb_print from w_inherite`cb_print within w_qct_02060
boolean visible = false
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_qct_02060
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_02060
integer x = 2871
integer y = 1936
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""

IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.ReSet()

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_search from w_inherite`cb_search within w_qct_02060
boolean visible = false
integer x = 1371
integer y = 1956
integer taborder = 100
end type



type sle_msg from w_inherite`sle_msg within w_qct_02060
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_02060
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_02060
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_02060
end type

type gb_3 from groupbox within w_qct_02060
integer x = 41
integer width = 3561
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_qct_02060
integer x = 37
integer y = 1868
integer width = 411
integer height = 200
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

type gb_1 from groupbox within w_qct_02060
integer x = 2455
integer y = 1868
integer width = 1143
integer height = 200
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

type dw_1 from u_key_enter within w_qct_02060
integer x = 197
integer y = 56
integer width = 3250
integer height = 116
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_02060_01"
boolean border = false
end type

event itemchanged;String s_cod

s_cod = Trim(this.getText())

if this.GetColumnName() = "sdate" Then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "edate" Then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if	
end if	

end event

event itemerror;return 1
end event

event getfocus;//dw_insert.Reset()
end event

