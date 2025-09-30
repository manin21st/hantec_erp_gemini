$PBExportHeader$w_qct_05075.srw
$PBExportComments$계측기 점검 기준등록
forward
global type w_qct_05075 from w_inherite
end type
type gb_6 from groupbox within w_qct_05075
end type
type gb_4 from groupbox within w_qct_05075
end type
type gb_3 from groupbox within w_qct_05075
end type
type gb_2 from groupbox within w_qct_05075
end type
type gb_1 from groupbox within w_qct_05075
end type
type dw_ins1 from u_key_enter within w_qct_05075
end type
type cb_add from commandbutton within w_qct_05075
end type
type cb_tcopy from commandbutton within w_qct_05075
end type
type gb_5 from groupbox within w_qct_05075
end type
end forward

global type w_qct_05075 from w_inherite
string title = "계측기 점검 기준 등록"
long backcolor = 12632256
gb_6 gb_6
gb_4 gb_4
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_ins1 dw_ins1
cb_add cb_add
cb_tcopy cb_tcopy
gb_5 gb_5
end type
global w_qct_05075 w_qct_05075

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크 + Fill
Long i, lcount 
Integer seq
String s_mchno

s_mchno = Trim(dw_ins1.object.mchno[1])

if IsNull(s_mchno) or s_mchno = '' then
	f_message_chk(30, "[관리번호]")
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return -1
end if

lcount = dw_insert.RowCount()
for i = 1 to lcount
	dw_insert.object.sabu[i] = gs_sabu
   dw_insert.object.mchno[i] = s_mchno
	if IsNull(Trim(dw_insert.object.inspbody[i])) or Trim(dw_insert.object.inspbody[i]) = "" then
		f_message_chk(1400, "[점검부위]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("inspbody")
		dw_insert.SetFocus()
		Return -1
   end if
	if IsNull(Trim(dw_insert.object.insplist[i])) or Trim(dw_insert.object.insplist[i]) = "" then
		f_message_chk(1400, "[점검항목]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("insplist")
		dw_insert.SetFocus()
		Return -1
   end if
	
	if IsNull(Trim(dw_insert.object.inspday[i])) or Trim(dw_insert.object.inspday[i]) = "" then
		f_message_chk(1400, "[점검구분]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("inspday")
		dw_insert.SetFocus()
		Return -1
   end if
	
	if Trim(dw_insert.object.inspday[i]) = "2" then //정기점검인 경우 
    	if IsNull(Trim(dw_insert.object.lastinsp[i])) or Trim(dw_insert.object.lastinsp[i]) = "" then
		   f_message_chk(1400, "[최종점검일]")
		   dw_insert.ScrollToRow (i)
		   dw_insert.SetColumn("lastinsp")
		   dw_insert.SetFocus()
			Return -1
      end if
	end if	
	
	if IsNull(Trim(dw_insert.object.inspsigi[i])) or Trim(dw_insert.object.inspsigi[i]) = "" then
		f_message_chk(1400, "[점검시기]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("inspsigi")
		dw_insert.SetFocus()
		Return -1
   end if
	if IsNull(Trim(dw_insert.object.inspgubn[i])) or Trim(dw_insert.object.inspgubn[i]) = "" then
		f_message_chk(1400, "[주기구분]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("inspgubn")
		dw_insert.SetFocus()
		Return -1
   end if
	if dw_insert.object.inspilsu[i] < 1 then
		f_message_chk(1400, "[주기(기준일수)]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("inspilsu")
		dw_insert.SetFocus()
		Return -1
   end if
	
	if IsNull(Trim(dw_insert.object.inspban[i])) or Trim(dw_insert.object.inspban[i]) = "" then
		f_message_chk(1400, "[점검방법]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("inspban")
		dw_insert.SetFocus()
		Return -1
   end if
	
	if IsNull(Trim(dw_insert.object.inspgijun[i])) or Trim(dw_insert.object.inspgijun[i]) = "" then
		f_message_chk(1400, "[점검기준]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("inspgijun")
		dw_insert.SetFocus()
		Return -1
   end if
next	

return 1
end function

on w_qct_05075.create
int iCurrent
call super::create
this.gb_6=create gb_6
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_ins1=create dw_ins1
this.cb_add=create cb_add
this.cb_tcopy=create cb_tcopy
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_6
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.dw_ins1
this.Control[iCurrent+7]=this.cb_add
this.Control[iCurrent+8]=this.cb_tcopy
this.Control[iCurrent+9]=this.gb_5
end on

on w_qct_05075.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_6)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_ins1)
destroy(this.cb_add)
destroy(this.cb_tcopy)
destroy(this.gb_5)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ins1.SetTransObject(SQLCA)

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Setredraw(True)

dw_ins1.Setredraw(False)
dw_ins1.ReSet()
dw_ins1.InsertRow(0)
dw_ins1.Setredraw(True)
dw_ins1.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_05075
integer x = 41
integer y = 180
integer width = 3552
integer height = 1696
integer taborder = 20
string dataobject = "d_qct_05075_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String s_cod
Long   i, ilsu, nRow

nRow = GetRow()
If nRow <= 0 Then Return

if this.getcolumnname() = "inspilsu" then //주기일수
   ilsu = Long(Trim(this.GetText()))  
else	
   s_cod = Trim(this.GetText())
end if

/* 주기구분 */
If Getcolumnname() = 'inspgubn' Then
	Choose Case s_cod
		Case '1'
			SetItem(nRow, 'inspilsu', 1)
		Case '2'
			SetItem(nRow, 'inspilsu', 7)
		Case '3'
			SetItem(nRow, 'inspilsu', 30)
		Case '4'
			SetItem(nRow, 'inspilsu', 90)
		Case '5'
			SetItem(nRow, 'inspilsu', 180)
		Case '6'
			SetItem(nRow, 'inspilsu', 365)
		Case '7'
			SetItem(nRow, 'inspilsu', 0)
	End Choose
//if this.getcolumnname() = "inspilsu" then //주기일수
//	// 정기정검 자료가 수정된 경우에는 정기점검자료를 동일하게 수정
//	if this.getitemstring(row, "inspday") = '2' then
//		for i = 1 to this.RowCount()
//			 if this.object.inspday[i] = '2' then
//				 this.object.inspilsu[i] = ilsu
//			end if	 
//		next 
//	end if
//elseif this.getcolumnname() = "inspgubn" then //주기구분
//	// 정기정검 자료가 수정된 경우에는 정기점검자료를 동일하게 수정	
//	if this.getitemstring(row, "inspday") = '2' then	
//		for i = 1 to this.RowCount()
//			 if this.object.inspday[i] = '2' then
//				 this.object.inspgubn[i] = s_cod
//			end if	 
//		next 
//	end if
elseif this.getcolumnname() = "lastinsp" then
	
	
	if IsNull(s_cod) or s_cod = "" THEN RETURN 
	
	IF f_datechk(s_cod) = -1 then
		f_message_chk(35, "[최종점검일자]")
		this.object.lastinsp[nRow] = ""
		return 1
//	else
//		for i = 1 to this.RowCount()
//			 this.object.lastinsp[i] = s_cod
//		next 	
	end if
end if	
end event

event dw_insert::rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

event dw_insert::buttonclicked;call super::buttonclicked;string pathname, filename
integer value

if dwo.name <> "btn1" then return

this.AcceptText()
pathname = Trim(this.object.imgpath[1])

//이미지 등록 윈도우 Call
OpenWithParm(w_pdt_06010, pathname)
pathname = Message.StringParm
if not (IsNull(pathname) or pathname = "") then
   dw_insert.object.imgpath[1] = Trim(pathname)
end if	

end event

event dw_insert::ue_pressenter;if this.GetColumnName() = "inspban" or this.GetColumnName() = "inspgijun" &
   or this.GetColumnName() = "insplist"  then return

Send(Handle(this),256,9,0)
Return 1
end event

type cb_exit from w_inherite`cb_exit within w_qct_05075
integer x = 3227
integer y = 1936
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_qct_05075
integer x = 2459
integer y = 1936
integer taborder = 70
end type

event cb_mod::clicked;call super::clicked;if dw_ins1.AcceptText() = -1 then return
if dw_insert.AcceptText() = -1 then return 
if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return

IF dw_insert.Update() > 0 THEN		
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
END IF

dw_insert.SetRedraw(True)
ib_any_typing = False //입력필드 변경여부 No
end event

type cb_ins from w_inherite`cb_ins within w_qct_05075
boolean visible = false
integer x = 357
integer y = 2304
integer taborder = 80
end type

type cb_del from w_inherite`cb_del within w_qct_05075
integer x = 1344
integer y = 1936
integer taborder = 60
end type

event cb_del::clicked;call super::clicked;long lcRow, lseqno, lcnt
String smchno

// 점검계획 및 실적 check
if dw_insert.rowcount() < 1 then return  
if dw_insert.accepttext() = -1 then return  

lcRow = dw_insert.GetRow()
if lcrow < 1 then return 
smchno = dw_insert.getitemstring(Lcrow, "mchno")
lseqno = dw_insert.getitemdecimal(Lcrow, "seq")

lcnt = 0
select count(*) into :lcnt
  from mchrsl
 where sabu 	= :gs_sabu
 	and mchno	= :smchno
	and seq		= :lseqno;
	
if lcnt > 0 then
	Messagebox("계획 및 실적", "점검 계획 및 실적에 이미 자료가 존재합니다", stopsign!)
	return
end if


if f_msg_delete() = -1 then return

ib_any_typing =True

dw_insert.DeleteRow(lcRow)

sle_msg.Text = "삭제 되었습니다! 저장버튼을 CLICK하여 자료를 저장하세요!"

end event

type cb_inq from w_inherite`cb_inq within w_qct_05075
integer x = 73
integer y = 1936
integer taborder = 100
end type

event cb_inq::clicked;call super::clicked;String  s_mchno, s_stopdat
Long    i_cnt, i

if dw_ins1.AcceptText() = -1 then return

s_mchno = dw_ins1.object.mchno[1]

if IsNull(s_mchno) or s_mchno = '' then
	sle_msg.text = "관리번호를 먼저 입력한 후 진행하세요!"
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return 
end if

//사용중지일자 확인
select stopdat into :s_stopdat from mchmst
 where sabu = :gs_sabu and mchno = :s_mchno;
if sqlca.sqlcode <> 0 or (not (IsNull(s_stopdat) or s_stopdat = "")) then
	MessageBox("사용중지일자 확인", String(s_stopdat,"@@@@.@@.@@") + " 일자로 사용 중지된 계측기 입니다!")
	dw_ins1.object.mchno[1] = ""
   dw_ins1.object.mchnam[1] = ""
	dw_ins1.object.buncd[1] = ""
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return
end if	

//설비번호를 체크한다. (신규로 생성시 이전 데이터 남겨놓기 위해) 
select count(mchno) into :i_cnt from mchmst_insp
 where sabu = :gs_sabu and mchno = :s_mchno
   and inspday in ( '1','2' );
 
if sqlca.sqlcode <> 0 or i_cnt < 1 then
	cb_del.Enabled = True
   cb_add.Enabled = True
   cb_mod.Enabled = True
   dw_insert.SetColumn("inspbody")
	dw_insert.SetFocus() 
   for i = 1 to dw_insert.RowCount()
		 dw_insert.setitem(i, "seq", i)		
	    dw_insert.SetItemStatus(i, 0, primary!, new!)
	next 
   MessageBox("신규등록", "신규로 등록 합니다!")
   return
else
	dw_insert.SetRedraw(False)
   if dw_insert.Retrieve(gs_sabu, s_mchno) < 1 then
	   dw_insert.InsertRow(0)
	   sle_msg.text = "신규로 등록 합니다!"
   end if	
   cb_del.Enabled = True
   cb_add.Enabled = True
   cb_mod.Enabled = True
   dw_insert.SetColumn("inspbody")
   dw_insert.SetFocus() 
   dw_insert.SetRedraw(True)
end if	

end event

type cb_print from w_inherite`cb_print within w_qct_05075
boolean visible = false
integer x = 731
integer y = 2328
integer taborder = 130
end type

type st_1 from w_inherite`st_1 within w_qct_05075
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_05075
integer x = 2807
integer y = 1936
integer taborder = 90
end type

event cb_can::clicked;call super::clicked;//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)

dw_ins1.SetRedraw(False)
dw_ins1.Reset()
dw_ins1.InsertRow(0)
dw_ins1.SetRedraw(True)
dw_ins1.SetFocus()

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_search from w_inherite`cb_search within w_qct_05075
integer x = 416
integer y = 1936
integer width = 489
integer taborder = 140
string text = "타계측기복사"
end type

event clicked;call super::clicked;String  sMchno, sStopdat, sTargetMchno
Long    i_cnt, ix

if dw_ins1.AcceptText() = -1 then return

sMchno = Trim(dw_ins1.GetItemString(1,'mchno'))

if IsNull(sMchno) or sMchno = '' then
	sle_msg.text = "관리번호를 먼저 입력한 후 진행하세요!"
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return 
end if

open(w_mchno_popup)
If IsNull(gs_code) Or gs_code = '' Then Return

sTargetMchno = gs_code

/* 설비번호를 체크한다. */
select count(mchno) into :i_cnt from mchmst_insp
 where sabu = :gs_sabu and mchno = :sTargetMchno and inspday in ( '1','2' );
	
If sqlca.sqlcode <> 0 or i_cnt < 1 then
   MessageBox("확인", "복사할 계측기 내역이 없습니다!")
   Return
Else
	dw_insert.SetRedraw(False)
	If dw_insert.Retrieve(gs_sabu, sTargetMchno) < 1 then
		MessageBox("확인", "복사할 계측기 내역이 없습니다!")
	Else
		/* 기존 내역 삭제 */
		DELETE FROM mchmst_insp
 		 WHERE sabu = :gs_sabu and mchno = :sMchno and inspday in ( '1','2' );
 
 		If sqlca.sqlcode <> 0 Then
			RollBack;
			MessageBox("확인", "기존 내역 삭제를 실패하였습니다!")
			dw_insert.SetRedraw(True)
			Return
		End If

		/* 신규 관리번호 설정 */
		For ix = 1 To dw_insert.RowCount()
			dw_insert.SetItem(ix, 'mchno', sMchno)
			dw_insert.SetItemStatus(ix, 0, Primary!, NewModified!)
		Next
		
		cb_del.Enabled = True
		cb_add.Enabled = True
		cb_mod.Enabled = True
		dw_insert.SetColumn("inspbody")
		dw_insert.SetFocus() 
	End If
   dw_insert.SetRedraw(True)
End If	

end event



type sle_msg from w_inherite`sle_msg within w_qct_05075
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_05075
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_05075
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_05075
end type

type gb_6 from groupbox within w_qct_05075
integer x = 41
integer width = 3547
integer height = 168
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

type gb_4 from groupbox within w_qct_05075
integer x = 965
integer y = 1868
integer width = 745
integer height = 200
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

type gb_3 from groupbox within w_qct_05075
integer x = 2427
integer y = 1868
integer width = 745
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

type gb_2 from groupbox within w_qct_05075
integer x = 37
integer y = 1868
integer width = 905
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

type gb_1 from groupbox within w_qct_05075
integer x = 3195
integer y = 1868
integer width = 398
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

type dw_ins1 from u_key_enter within w_qct_05075
event ue_key pbm_dwnkey
integer x = 128
integer y = 56
integer width = 3410
integer height = 100
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_05075_01"
boolean border = false
boolean livescroll = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

//IF	GetColumnName() = "mchno" THEN
//	gs_gubun = 'ALL'
//	gs_code  = '계측기'
//	open(w_mchno_popup)
//	If IsNull(gs_code) Or gs_code = '' Then Return
//	
//	SetItem(1, "mchno", gs_code)
//	SetItem(1, "mchnam", gs_codename)
//	if not (IsNull(gs_code) or gs_code = "") then
//	   cb_inq.TriggerEvent(Clicked!)
//	end if
//END IF


IF	this.getcolumnname() = "mchno" THEN	
	gs_gubun = 'ALL'
	gs_code = '계측기'
	open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchnam", gs_codename)
	this.triggerevent(itemchanged!)
	
elseif this.GetColumnName() = "buncd" then
	
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd[1] = gs_code
	this.triggerevent(itemchanged!)	
end if
end event

event itemerror;return 1
end event

event itemchanged;String s_cod, s_nam,  ls_mchnam, ls_buncd, snull, ls_mchno

setnull(snull)

s_cod = Trim(this.GetText())

//if	this.getcolumnname() = "mchno" then
//	select mchnam into :s_nam from mchmst
//	 where sabu = :gs_saupj and mchno = :s_cod;
//	 
//	if sqlca.sqlcode <> 0 then
//		dw_insert.reset()
//		f_message_chk(33,"[관리번호]")
//		this.object.mchno[1] = ""
//		this.object.mchnam[1] = ""
//		return 1
//	else	
//		this.object.mchnam[1] = s_nam
//		cb_inq.TriggerEvent(Clicked!)  	
//	end if
//end if

if this.GetColumnName() = "mchno" then // 관리번호  
	
 	if IsNull(s_cod) or s_cod = ""  then
		this.object.mchnam[1] = ""
		this.object.buncd[1] = ""
		dw_insert.reset()
		return 
	end if
	
	select mchnam , buncd 
	  into :ls_mchnam, :ls_buncd
  	  from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, '[관리 번호]')
		this.setitem(1,"mchno", snull )
		this.setitem(1,"mchnam", snull)
		this.setitem(1,"buncd",  snull)
		dw_insert.reset()
		return 1
	end if
	
	this.setitem(1,"mchnam", ls_mchnam )
	this.setitem(1,"buncd" , ls_buncd  )
	cb_inq.postevent(clicked!)
	
	
elseif this.GetColumnName() = "buncd" then    // 계측기 관리번호
	if IsNull(s_cod) or s_cod = "" then
		this.object.mchno[1] = ""
		this.object.mchnam[1] = ""
		dw_insert.reset()
		return 
	end if
		
	SELECT mchno, mchnam   
	INTO :ls_mchno, :ls_mchnam
   FROM mchmst
	WHERE KEGBN = 'Y'
	AND   BUNCD = :s_cod ; 
	
	if sqlca.sqlcode <> 0  then
		f_message_chk(33, '[계측기관리번호]')
      this.setitem(1,"mchno", snull )
		this.setitem(1,"mchnam", snull)
		this.setitem(1,"buncd",  snull)
		dw_insert.reset()
		return  1
	end if
	
	this.setitem(1,"mchno", ls_mchno )
	this.setitem(1,"mchnam" , ls_mchnam  )
	cb_inq.postevent(clicked!)
	
end if
end event

event getfocus;//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 
end event

type cb_add from commandbutton within w_qct_05075
integer x = 997
integer y = 1936
integer width = 334
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

event clicked;Long   crow, i, lReturnRow
string s_mchno

if dw_ins1.AcceptText() = -1 then return

s_mchno = trim(dw_ins1.object.mchno[1])

if IsNull(s_mchno) or s_mchno = '' then
	f_message_chk(30, "[관리번호]")
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return 
end if

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	crow = dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
if crow > 1 then
	i = crow - 1
	dw_insert.object.inspbody[crow] = dw_insert.object.inspbody[i]
	dw_insert.object.lastinsp[crow] = dw_insert.object.lastinsp[i]
	dw_insert.SetColumn("insplist")
else
	dw_insert.SetColumn("inspbody")
end if	

if dw_insert.rowcount() > 1 then 
   dw_insert.setitem(crow, 'seq', dw_insert.getitemnumber(1, 'max_seq') + 1)
else
   dw_insert.setitem(crow, 'seq', 1)
end if

dw_insert.AcceptText()
dw_insert.Setredraw(True)
dw_insert.SetFocus()
ib_any_typing =True


end event

type cb_tcopy from commandbutton within w_qct_05075
integer x = 1792
integer y = 1936
integer width = 549
integer height = 108
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "ROW 복사(추가)"
end type

event clicked;String scol, sdata
Long   crow, nrow

crow = dw_insert.GetRow()
if crow < 1 then return

if dw_insert.RowsCopy(crow, crow, Primary!, dw_insert, crow, Primary!) <> 1 then Return -1

nrow = crow + 1 

// 순번은 setting
dw_insert.setitem(nrow, 'seq', dw_insert.getitemnumber(1, 'max_seq') + 1)

dw_insert.ScrollToRow(nrow)
dw_insert.SetRow(nrow)
dw_insert.SetColumn("insplist")
dw_insert.SetFocus()
end event

type gb_5 from groupbox within w_qct_05075
integer x = 1755
integer y = 1868
integer width = 626
integer height = 200
integer taborder = 50
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

