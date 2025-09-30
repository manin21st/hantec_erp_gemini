$PBExportHeader$w_sal_04030.srw
$PBExportComments$ ===> 관할구역별 입금표 배포 및 입금표번호 생성
forward
global type w_sal_04030 from w_inherite
end type
type gb_5 from groupbox within w_sal_04030
end type
type gb_4 from groupbox within w_sal_04030
end type
type gb_2 from groupbox within w_sal_04030
end type
type gb_1 from groupbox within w_sal_04030
end type
type dw_jogun from u_key_enter within w_sal_04030
end type
type gb_3 from groupbox within w_sal_04030
end type
type dw_display from datawindow within w_sal_04030
end type
type st_2 from statictext within w_sal_04030
end type
end forward

global type w_sal_04030 from w_inherite
integer height = 2408
string title = "입금표 배포 등록"
gb_5 gb_5
gb_4 gb_4
gb_2 gb_2
gb_1 gb_1
dw_jogun dw_jogun
gb_3 gb_3
dw_display dw_display
st_2 st_2
end type
global w_sal_04030 w_sal_04030

type variables
Integer ii_chk
String isarea, isteam, isaupj
end variables

on w_sal_04030.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_jogun=create dw_jogun
this.gb_3=create gb_3
this.dw_display=create dw_display
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.dw_jogun
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.dw_display
this.Control[iCurrent+8]=this.st_2
end on

on w_sal_04030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_jogun)
destroy(this.gb_3)
destroy(this.dw_display)
destroy(this.st_2)
end on

event open;call super::open;dw_jogun.Settransobject(sqlca)
dw_Insert.Settransobject(sqlca)
dw_display.Settransobject(sqlca)
dw_jogun.InsertRow(0)

cb_can.TriggerEvent(Clicked!)

dw_jogun.SetItem(1, 'dst_date', f_today())

/* User별 관할구역 Setting */
If f_check_sarea(isarea, isteam, isaupj) = 1 Then
	dw_jogun.SetItem(1, 'sarea', isarea)
	dw_jogun.Modify("sarea.protect=1")
	dw_jogun.Modify("sarea.background.color = 80859087")
	dw_insert.Modify("sarea.protect=1")
	dw_insert.Modify("sarea.background.color = 80859087")
Else
	isarea = ''
End If

cb_inq.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_04030
integer x = 46
integer y = 300
integer width = 2034
integer height = 1560
integer taborder = 10
string dataobject = "d_sal_04030_01"
boolean vscrollbar = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_key;call super::ue_key;Long CurRow

choose case key
	case KeyDownArrow! 
		CurRow = this.GetRow()
		this.triggerEvent(itemchanged!)
		if ii_chk = 1 then return 1
		
      this.AcceptText()
		if this.GetItemString(CurRow, 'sarea') = '' or &
		   isNull(this.GetItemString(CurRow, 'sarea')) then
			f_message_chk(30, '[관할구역]')
			this.SetColumn('sarea')
			return 1
		end if
		
		if this.rowcount() = CurRow then
			cb_ins.postevent(clicked!)
		end if
end choose
end event

event dw_insert::rowfocuschanged;this.SetRowFocusIndicator(Hand!, 10, -10)
end event

event dw_insert::itemchanged;String sCol_Name, sNull, sSarea, sDstEmp, sEmpName, sNoFrom, sNoTo
Long   CurRow, RtnRow

sCol_Name = this.GetColumnName()
SetNull(sNull)

CurRow = this.GetRow()
ii_chk = 0

Choose Case sCol_Name
	// 관할구역 입력시	
	Case "sarea"
   	sSarea = this.GetText()
   	RtnRow = this.find("sarea ='" + sSarea +"'", 1, this.RowCount())

   	if (CurRow <> RtnRow) and (RtnRow <> 0) then
	   	f_message_chk(1,'[관할구역]')
		   this.SetItem(CurRow, "sarea", sNull)
			ii_chk = 1
   		return 1
   	end if
		
	// 담당자코드 입력시	
	Case "dst_emp"
		sDstEmp = this.GetText()
      
		//************************************************
		Select empname Into :sEmpName From p1_master
		Where empno = :sDstEmp;
		//************************************************
		if sEmpName = '' or isNull(sEmpName) then
 			f_Message_Chk(33, '[배포담당자]')
			this.SetItem(CurRow, "dst_emp", sNull)
			this.SetItem(CurRow, "empname", sNull)
			return 1
		else
			this.SetItem(CurRow, "empname", sEmpName)
		end if

	// 입금표번호 FROM 입력시	
	Case "ipgnofrom"
		sNoFrom = this.GetText()
		if Not(isNumber(sNoFrom)) then
			f_Message_Chk(201, '[입금표번호]')
			this.SetItem(CurRow, "ipgnofrom", sNull)
			return 1
		end if
		
		sNoFrom = Mid('0000000' + sNoFrom, Len(Trim(sNoFrom)), 8)
		this.SetItem(CurRow, "ipgnofrom", sNoFrom)
		return 2
	// 입금표번호 TO 입력시	
	Case "ipgnoto"
		sNoTo = this.GetText()
		if Not(isNumber(sNoTo)) then
			f_Message_Chk(201, '[입금표번호]')
			this.SetItem(CurRow, "ipgnoto", sNull)
			return 1
		end if

		sNoTo = Mid('0000000' + sNoTo, Len(Trim(sNoTo)), 8)
		this.SetItem(CurRow, "ipgnoto", sNoTo)		
		
		sNoFrom = this.GetItemString(CurRow, "ipgnofrom")
		if Long(sNoFrom) > Long(sNoTo) then
			MessageBox('확인', '시작번호가 끝번호보다 큽니다. 다시 입력하세요!!!')
			this.SetColumn('ipgnofrom')
			this.SetFocus()
			return 1
		end if		
		
		return 2
end Choose
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;String sCol_Name
Long   CurRow

CurRow = this.GetRow()

sCol_Name = This.GetColumnName()
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case sCol_Name
   // 배포담당자 에디트에 Right 버턴클릭시 Popup 화면
	Case "dst_emp"
		gs_code = this.GetText()
		Open(w_sawon_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		this.SetItem(CurRow, 'dst_emp', gs_code)
		this.SetItem(CurRow, 'empname', gs_codename)
		this.SetColumn('ipgnofrom')
		this.SetFocus()
		return 1
end Choose
end event

type cb_exit from w_inherite`cb_exit within w_sal_04030
integer y = 1936
integer width = 361
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_sal_04030
integer x = 2167
integer y = 1936
integer width = 640
integer taborder = 90
string text = "저장 및 생성(&S)"
end type

event cb_mod::clicked;call super::clicked;Integer i
String  sSarea, sGbn, sDstDate, sIpgumNo
Long    lFromNo, lToNo, lIpgumNo

SetPointer(HourGlass!)

if dw_Insert.Accepttext() = -1 then return
// 
for i = 1 to dw_Insert.RowCount()
	sSarea = dw_Insert.GetItemString(i, "sarea")
	if isNull(sSarea) or sSarea = '' then
		dw_Insert.DeleteRow(i)
	end if
next

if dw_Insert.Update() = -1 THEN			
   f_message_Chk(32,'[입금표 배포내역 등록]')	
	rollback;
	SetPointer(Arrow!)
	ib_any_typing = True
	Return
end if

for i = 1 to dw_Insert.RowCount()
	sGbn = dw_Insert.GetItemString(i, "gbn")
	if sGbn <> '1' then
   	sDstDate = dw_Insert.GetItemString(i, "dst_date")
   	sSarea   = dw_Insert.GetItemString(i, "sarea")
   	lFromNo  = long(dw_Insert.GetItemString(i, "ipgnofrom"))		
   	lToNo    = long(dw_Insert.GetItemString(i, "ipgnoto"))
		for lIpgumNo = lFromNo to lToNo
			sIpgumNo = Mid('0000000' + String(lIpgumNo), Len(String(lIpgumNo)), 8)
			
   		Insert Into ipgumpyo (ipgum_no, use_gu, dst_date, sarea)
	   	Values(:sIpgumNo, '1', :sDstDate, :sSarea);
			
			if SQLCA.Sqlcode = -1 then
				messagebox(string(SQLCA.Sqlcode), sqlca.sqlerrtext)
            f_message_Chk(32,'[입금표번호 분배 등록]')	
         	rollback;
				SetPointer(Arrow!)
         	ib_any_typing = True
         	Return
         end if				
		next
	end if
next

commit;

ib_any_typing = False
sle_msg.Text = ''
SetPointer(Arrow!)		
f_message_Chk(202, '[입금표배포 및 생성]')

cb_inq.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_sal_04030
integer x = 73
integer y = 1936
integer width = 361
integer taborder = 80
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;String sNull, sDstDate, sSarea, sIpgnoFrom, sIpgnoTo
Long   CurRow

SetNull(sNull)

If dw_Jogun.AcceptText() <> 1 Then Return

sDstDate = dw_Jogun.GetItemString(1, 'dst_date')

// 입금표 배포일자 입력 유무 CHECK
if sDstDate = '' or isNull(sDstDate) then
	f_Message_Chk(30, '[입금표배포일자]')
	dw_Jogun.SetFocus()
	return 1
end if
// 입금표 배포일자 유효성 CHECK
if f_DateChk(Trim(sDstDate)) = -1 then
	f_Message_Chk(35, '[입금표배포일자]')
	dw_Jogun.SetItem(1, "dst_date", sNull)
	dw_Jogun.SetFocus()
	return 1
end if

If dw_insert.AcceptText() <> 1 Then Return

if dw_insert.RowCount() > 0 then 
   sSarea = dw_insert.GetItemString(dw_insert.RowCount(), 'sarea')
	sIpgnoFrom = dw_insert.GetItemString(dw_insert.RowCount(), 'ipgnofrom')
	sIpgnoTo = dw_insert.GetItemString(dw_insert.RowCount(), 'ipgnoto')
   if sSarea = '' or isNull(sSarea) or sIpgnoFrom = '' or isNull(sIpgnoFrom) or &
	   sIpgnoTo = '' or isNull(sIpgnoTo) then
	   MessageBox('확인', '먼저 추가한 ROW에 입력이 완료되지 않았습니다' + '~r~r' + &
	                      '먼저 입력을 완료하고 추가 하세요(필수입력항목)')
   	dw_insert.SetColumn('sarea')
	   dw_insert.SetFocus()
   	return 1
	end if
end if

CurRow = dw_insert.InsertRow(0)
	
dw_insert.SetItem(CurRow, 'dst_date', sDstDate)
dw_insert.SetItem(CurRow, 'sarea', 	  iSarea)
dw_insert.SetItem(CurRow, 'dst_emp',  sNull)
dw_insert.SetItem(CurRow, 'empname',  sNull)
dw_insert.SetItem(CurRow, 'ipgnofrom',sNull)
dw_insert.SetItem(CurRow, 'ipgnoto',  sNull)
dw_insert.SetItem(CurRow, 'rcv_date', sNull)
dw_insert.SetItem(CurRow, 'gbn', '0')

dw_insert.ScrollToRow(CurRow)
	
dw_insert.setcolumn('sarea')
dw_insert.SetFocus()
	
sle_msg.Text = "입금표 배포 내역을 입력하세요!!!"
end event

type cb_del from w_inherite`cb_del within w_sal_04030
integer x = 466
integer y = 1936
integer width = 361
integer taborder = 100
end type

event cb_del::clicked;call super::clicked;String sRcvDate, sFrom, sTo, sArea
Long   CurRow

If dw_insert.AcceptText() <> 1 Then Return

CurRow = dw_insert.GetRow()
if CurRow <= 0 then Return

sRcvDate = dw_insert.GetItemString(CurRow, 'rcv_date')
Beep (1)
if isNull(sRcvDate) or sRcvDate = '' then
   if MessageBox('삭제확인', '해당 관할구역의 입금표 배포내역을 삭제하시겠습니까? ' &
                           ,Exclamation!,yesno!, 2) = 2 then Return
else
	MessageBox('삭제불가', '해당 입금표를 영업에서 수령하였음으로 삭제할 수 없습니다.')
	return
end if

sArea = Trim(dw_jogun.GetItemString(1,'sarea'))
If IsNull(sArea) Then sArea = ''

sFrom = dw_insert.GetItemString(CurRow, 'ipgnofrom')
sTo = dw_insert.GetItemString(CurRow, 'ipgnoto')

// 입금표 테이블 삭제
Delete From ipgumpyo
Where  ipgum_no between :sFrom and :sTo;
if SQLCA.Sqlcode = -1 then
	Rollback;
	MessageBox('ERROR', '입금표 테이블 삭제 Error')
	Return
end if

dw_insert.DeleteRow(CurRow)

if dw_insert.Update() < 0 then
   f_Message_Chk(31, '[상환계획 삭제]')	
	RollBack;
	ib_any_typing =True
	Return
end if

Commit;
if CurRow = 1 or CurRow <= dw_insert.RowCount() then
else
	dw_insert.ScrollToRow(CurRow - 1)
	dw_insert.SetFocus()
end if
	
dw_display.Retrieve(sarea+'%')

sle_msg.text ="자료를 삭제하였습니다!!"

ib_any_typing =False
end event

type cb_inq from w_inherite`cb_inq within w_sal_04030
boolean visible = false
integer x = 1518
integer y = 2384
integer taborder = 110
end type

event cb_inq::clicked;call super::clicked;String sDstDate, sArea

If dw_Jogun.AcceptText() <> 1 Then Return

sDstDate = dw_Jogun.GetItemString(1, 'dst_date')
sArea = dw_Jogun.GetItemString(1, 'sarea')
If IsNull(sArea) Then sArea = ''

dw_Insert.Retrieve(sDstDate)
dw_Display.Retrieve(sArea+'%')

cb_ins.Enabled = True
cb_del.Enabled = True
cb_mod.Enabled = True

cb_ins.SetFocus()
end event

type cb_print from w_inherite`cb_print within w_sal_04030
boolean visible = false
integer x = 1934
integer y = 2380

integer taborder = 120
end type

type st_1 from w_inherite`st_1 within w_sal_04030
end type

type cb_can from w_inherite`cb_can within w_sal_04030
integer x = 2834
integer y = 1936
integer width = 361
integer taborder = 130
end type

event cb_can::clicked;call super::clicked;String sArea

//dw_Jogun.Reset()
//dw_Jogun.InsertRow(0)

dw_Insert.Reset()

sArea = dw_Jogun.GetItemString(1, 'sarea')
If IsNull(sArea) Then sArea = ''

dw_Display.Retrieve(sArea+'%')

cb_ins.Enabled = False
cb_del.Enabled = False
cb_mod.Enabled = False

sle_msg.Text = '입금표 배포일자를 입력하세요'

ib_any_typing = False

dw_jogun.SetItem(1, 'dst_date', '')
dw_Jogun.SetFocus()

end event

type cb_search from w_inherite`cb_search within w_sal_04030
boolean visible = false
integer x = 2309
integer y = 2384
integer taborder = 140
boolean enabled = false
end type







type gb_5 from groupbox within w_sal_04030
integer x = 2126
integer y = 48
integer width = 1490
integer height = 1824
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type gb_4 from groupbox within w_sal_04030
integer x = 37
integer y = 268
integer width = 2057
integer height = 1604
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type gb_2 from groupbox within w_sal_04030
integer x = 37
integer y = 1884
integer width = 832
integer height = 180
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_sal_04030
integer x = 2126
integer y = 1884
integer width = 1490
integer height = 180
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_jogun from u_key_enter within w_sal_04030
integer x = 69
integer y = 116
integer width = 1952
integer height = 84
integer taborder = 50
string dataobject = "d_sal_04030"
boolean border = false
end type

event itemchanged;cb_inq.TriggerEvent(Clicked!)
end event

event itemerror;return 1
end event

type gb_3 from groupbox within w_sal_04030
integer x = 37
integer y = 48
integer width = 2057
integer height = 204
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type dw_display from datawindow within w_sal_04030
integer x = 2135
integer y = 180
integer width = 1467
integer height = 1680
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sal_04030_02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_sal_04030
integer x = 2139
integer y = 108
integer width = 1463
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean enabled = false
string text = "[ 입 금 표 배 포 현 황 ]"
alignment alignment = center!
boolean focusrectangle = false
end type

