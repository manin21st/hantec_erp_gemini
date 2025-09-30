$PBExportHeader$w_pdt_06020.srw
$PBExportComments$** 설비 점검 기준 등록
forward
global type w_pdt_06020 from w_inherite
end type
type dw_ins1 from u_key_enter within w_pdt_06020
end type
type cb_add from commandbutton within w_pdt_06020
end type
type p_tcopy from uo_picture within w_pdt_06020
end type
type rr_1 from roundrectangle within w_pdt_06020
end type
end forward

global type w_pdt_06020 from w_inherite
string title = "설비 점검 기준 등록"
dw_ins1 dw_ins1
cb_add cb_add
p_tcopy p_tcopy
rr_1 rr_1
end type
global w_pdt_06020 w_pdt_06020

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크 + Fill
Long i, lcount 
Integer seq
String s_mchno , ls_damdang

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

	ls_damdang = Trim(dw_insert.getitemstring(i,'damdang'))
	if isnull(ls_damdang) or ls_damdang = "" then
		f_message_chk(1400, "[점검담당]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("damdang")
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
	
//	if Trim(dw_insert.object.inspday[i]) = "2" then //정기점검인 경우 
//    	if IsNull(Trim(dw_insert.object.lastinsp[i])) or Trim(dw_insert.object.lastinsp[i]) = "" then
//		   f_message_chk(1400, "[최종점검일]")
//		   dw_insert.ScrollToRow (i)
//		   dw_insert.SetColumn("lastinsp")
//		   dw_insert.SetFocus()
//			Return -1
//      end if
//	end if	
	
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

on w_pdt_06020.create
int iCurrent
call super::create
this.dw_ins1=create dw_ins1
this.cb_add=create cb_add
this.p_tcopy=create p_tcopy
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ins1
this.Control[iCurrent+2]=this.cb_add
this.Control[iCurrent+3]=this.p_tcopy
this.Control[iCurrent+4]=this.rr_1
end on

on w_pdt_06020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ins1)
destroy(this.cb_add)
destroy(this.p_tcopy)
destroy(this.rr_1)
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

type dw_insert from w_inherite`dw_insert within w_pdt_06020
integer x = 46
integer y = 224
integer width = 4549
integer height = 2028
integer taborder = 20
string dataobject = "d_pdt_06020_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
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
//elseif this.getcolumnname() = "lastinsp" then
//	
//	
//	if IsNull(s_cod) or s_cod = "" THEN RETURN 
//	
//	IF f_datechk(s_cod) = -1 then
//		f_message_chk(35, "[최종점검일자]")
//		this.object.lastinsp[nRow] = ""
//		return 1
////	else
////		for i = 1 to this.RowCount()
////			 this.object.lastinsp[i] = s_cod
////		next 	
//	end if
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

type p_delrow from w_inherite`p_delrow within w_pdt_06020
integer x = 3918
integer y = 36
end type

event p_delrow::clicked;call super::clicked;long lcRow, lseqno, lcnt
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

type p_addrow from w_inherite`p_addrow within w_pdt_06020
integer x = 3744
integer y = 36
end type

event p_addrow::clicked;call super::clicked;Long   crow, i, lReturnRow
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

type p_search from w_inherite`p_search within w_pdt_06020
integer x = 3145
integer y = 36
integer width = 183
string picturename = "C:\erpman\image\타설비복사_up.gif"
end type

event p_search::ue_lbuttondown;call super::ue_lbuttondown;picturename = "C:\erpman\image\타설비복사_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;picturename = "C:\erpman\image\타설비복사_up.gif"
end event

event p_search::clicked;call super::clicked;String  sMchno, sStopdat, sTargetMchno, sGubun, sInspday
Long    i_cnt, ix, ii, max_seq1, max_seq2

if dw_ins1.AcceptText() = -1 then return

sMchno = Trim(dw_ins1.GetItemString(1,'mchno'))
sGubun = Trim(dw_ins1.GetItemString(1,'gubun'))

if IsNull(sMchno) or sMchno = '' then
	sle_msg.text = "관리번호를 먼저 입력한 후 진행하세요!"
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return 
end if

open(w_mchno_popup)
If IsNull(gs_code) Or gs_code = '' Then Return

sTargetMchno = gs_code

if IsNull(sGubun) Or sGubun = '' Then sGubun = '%'
/* 설비번호를 체크한다. */
select count(mchno) into :i_cnt from mchmst_insp
 where sabu = :gs_sabu 
   and mchno = :sTargetMchno 
   and inspday like :sGubun;
	
If sqlca.sqlcode <> 0 or i_cnt < 1 then
   MessageBox("확인", "복사할 설비 내역이 없습니다!")
   Return
Else
	select count(mchno),max(decode(inspday,'1',seq,0)),max(decode(inspday,'2',seq,0)) 
	  into :ii,:max_seq1, :max_seq2 
	  from mchmst_insp
	 where sabu = :gs_sabu 
		and mchno = :sMchno 
		and inspday like :sGubun;
		
	if isNull(ii) then ii = 0
	if isNull(max_seq1) then max_seq1 = 0
	if isNull(max_seq2) then max_seq2 = 0
	
	dw_insert.SetRedraw(False)
	If dw_insert.Retrieve(gs_sabu, sTargetMchno,sGubun) < 1 then
		MessageBox("확인", "복사할 설비 내역이 없습니다!")
	Else
		/* 신규 관리번호 설정 */
		For ix = 1 To dw_insert.RowCount()
			dw_insert.SetItem(ix, 'mchno', sMchno)
			sInspday = dw_insert.GetItemString(ix, 'inspday')
         if sInspday = '1' then
			   max_seq1 = max_seq1 + 1
			   dw_insert.SetItem(ix, 'seq', Max_seq1)
			Else
			   max_seq2 = max_seq2 + 1
			   dw_insert.SetItem(ix, 'seq', Max_seq2)
			End if
			dw_insert.SetItemStatus(ix, 0, Primary!, NewModified!)
		Next
		
		IF dw_insert.Update() > 0 THEN		
			COMMIT;
		ELSE
			ROLLBACK;
			f_message_chk(32, "[복사 실패]")
			sle_msg.Text = "복사 작업 실패!"
		END IF		
		p_inq.TriggerEvent(clicked!)
	End If
   dw_insert.SetRedraw(True)
End If	

//원본
//	dw_insert.SetRedraw(False)
//	If dw_insert.Retrieve(gs_sabu, sTargetMchno,sGubun) < 1 then
//		MessageBox("확인", "복사할 설비 내역이 없습니다!")
//	Else
//		/* 기존 내역 삭제 */
//		DELETE FROM mchmst_insp
// 		 WHERE sabu = :gs_sabu and mchno = :sMchno and inspday in ( '1','2' );
// 
// 		If sqlca.sqlcode <> 0 Then
//			RollBack;
//			MessageBox("확인", "기존 내역 삭제를 실패하였습니다!")
//			dw_insert.SetRedraw(True)
//			Return
//		End If
//
//		/* 신규 관리번호 설정 */
//		For ix = 1 To dw_insert.RowCount()
//			dw_insert.SetItem(ix, 'mchno', sMchno)
//			dw_insert.SetItemStatus(ix, 0, Primary!, NewModified!)
//		Next
//		
//		p_delrow.Enabled = True		
//		p_addrow.Enabled = True
//		p_mod.Enabled = True
//		p_delrow.picturename = "c:\erpman\image\행삭제_up.gif" 
//		p_addrow.picturename = "c:\erpman\image\행추가_up.gif"
//		p_mod.picturename = "c:\erpman\image\저장_up.gif"
//		
//		dw_insert.SetColumn("inspbody")
//		dw_insert.SetFocus() 
//	End If
//   dw_insert.SetRedraw(True)
//End If	
//
end event

type p_ins from w_inherite`p_ins within w_pdt_06020
integer x = 3397
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_06020
integer x = 4439
integer y = 36
end type

type p_can from w_inherite`p_can within w_pdt_06020
integer x = 4265
integer y = 36
end type

event p_can::clicked;call super::clicked;//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

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

type p_print from w_inherite`p_print within w_pdt_06020
integer x = 3049
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_06020
integer x = 2976
integer y = 36
end type

event p_inq::clicked;call super::clicked;String  s_mchno, s_stopdat, s_gubun
Long    i_cnt, i

if dw_ins1.AcceptText() = -1 then return

s_mchno = dw_ins1.object.mchno[1]
s_gubun = dw_ins1.object.gubun[1]

if IsNull(s_mchno) or s_mchno = '' then
	sle_msg.text = "관리번호를 먼저 입력한 후 진행하세요!"
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return 
end if

if IsNull(s_gubun) or s_gubun = '' then
	s_gubun = '%'	
end if

//사용중지일자 확인
select stopdat into :s_stopdat from mchmst
 where sabu = :gs_sabu and mchno = :s_mchno;
if sqlca.sqlcode <> 0 or (not (IsNull(s_stopdat) or s_stopdat = "")) then
	MessageBox("사용중지일자 확인", String(s_stopdat,"@@@@.@@.@@") + " 일자로 사용 중지된 설비 입니다!")
	dw_ins1.object.mchno[1] = ""
   dw_ins1.object.mchnam[1] = ""
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return
end if	

//설비번호를 체크한다. (신규로 생성시 이전 데이터 남겨놓기 위해) 
select count(mchno) into :i_cnt from mchmst_insp
 where sabu = :gs_sabu and mchno = :s_mchno
   and inspday in ( '1','2' );
 
if sqlca.sqlcode <> 0 or i_cnt < 1 then
	p_delrow.Enabled = True
   p_addrow.Enabled = True
   p_mod.Enabled    = True
	p_delrow.picturename = "c:\erpman\image\행삭제_up.gif" 
	p_addrow.picturename = "c:\erpman\image\행추가_up.gif"
	p_mod.picturename    = "c:\erpman\image\저장_up.gif"
	
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
   if dw_insert.Retrieve(gs_sabu, s_mchno, s_gubun) < 1 then
	   dw_insert.InsertRow(0)
	   sle_msg.text = "신규로 등록 합니다!"
   end if	
   p_delrow.Enabled = True
   p_addrow.Enabled = True
   p_mod.Enabled = True
	p_delrow.picturename = "c:\erpman\image\행삭제_up.gif" 
	p_addrow.picturename = "c:\erpman\image\행추가_up.gif"
	p_mod.picturename = "c:\erpman\image\저장_up.gif"
   dw_insert.SetColumn("inspbody")
   dw_insert.SetFocus() 
   dw_insert.SetRedraw(True)
end if	



end event

type p_del from w_inherite`p_del within w_pdt_06020
integer x = 4091
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_06020
integer x = 4091
integer y = 36
end type

event p_mod::clicked;call super::clicked;if dw_ins1.AcceptText() = -1 then return
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

type cb_exit from w_inherite`cb_exit within w_pdt_06020
integer x = 2953
integer y = 5000
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06020
integer x = 3977
integer y = 5000
integer taborder = 70
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06020
integer x = 357
integer y = 2304
integer taborder = 80
end type

type cb_del from w_inherite`cb_del within w_pdt_06020
integer x = 4101
integer y = 5000
integer taborder = 60
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06020
integer x = 3739
integer y = 5000
integer taborder = 100
end type

type cb_print from w_inherite`cb_print within w_pdt_06020
integer x = 731
integer y = 2328
integer taborder = 130
end type

type st_1 from w_inherite`st_1 within w_pdt_06020
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdt_06020
integer x = 4037
integer y = 5000
integer taborder = 90
end type

type cb_search from w_inherite`cb_search within w_pdt_06020
integer x = 1719
integer y = 5000
integer width = 421
integer taborder = 140
string text = "타설비복사"
end type



type sle_msg from w_inherite`sle_msg within w_pdt_06020
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdt_06020
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_06020
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06020
end type

type dw_ins1 from u_key_enter within w_pdt_06020
event ue_key pbm_dwnkey
integer x = 23
integer y = 20
integer width = 2912
integer height = 164
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_06020_01"
boolean border = false
boolean livescroll = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	GetColumnName() = "mchno" THEN	
	gs_gubun = 'ALL'
	open(w_mchno_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	
	SetItem(1, "mchno", gs_code)
	SetItem(1, "mchnam", gs_codename)
	SetItem(1, "buncd", gs_codename2)

	String s_lvlno
	select lvlno into :s_lvlno from mchmst
	 where sabu = :gs_sabu and mchno = :gs_code;
	SetItem(1, "lvlno", s_lvlno)

	if not (IsNull(gs_code) or gs_code = "") then
	   p_inq.TriggerEvent(Clicked!)
	end if
END IF

end event

event itemerror;return 1
end event

event itemchanged;String s_cod, s_nam, s_buncd, sbuncd, s_lvlno
int    ll_cnt

s_cod = Trim(this.GetText())

if	this.getcolumnname() = "mchno" then
	select mchnam, buncd, lvlno into :s_nam, :s_buncd, :s_lvlno from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then
		dw_insert.reset()
		f_message_chk(33,"[관리번호]")
		this.object.mchno[1] = ""
		this.object.mchnam[1] = ""
		this.object.lvlno[1] = ""
		this.object.buncd[1] = ""
		return 1
	else	
		this.object.mchnam[1] = s_nam
		this.object.buncd[1] = s_buncd
		this.object.lvlno[1] = s_lvlno
		p_inq.TriggerEvent(Clicked!)  	
	end if
elseif this.getcolumnname() = "buncd" then
	
		Sbuncd = Trim(GetText())
		
		If Sbuncd > '' Then
			select max(mchno), count(*) into :s_cod, :ll_cnt from mchmst where buncd = :sBuncd;
			
			If ll_cnt > 0 Then

				select mchnam into :s_nam from mchmst
	          where sabu = :gs_sabu and mchno = :s_cod;
					 
				this.object.mchno[1]  = s_cod
		      this.object.mchnam[1] = s_nam
				
				p_inq.TriggerEvent(Clicked!)
			Else
				this.object.mchno[1] = ""
				this.object.mchnam[1] = ""
				this.object.buncd[1] = ""
				return 1
			End If
		End If
end if
end event

event getfocus;//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 
end event

type cb_add from commandbutton within w_pdt_06020
integer x = 3753
integer y = 5000
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

type p_tcopy from uo_picture within w_pdt_06020
integer x = 3442
integer y = 36
integer width = 306
integer taborder = 90
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\row복사_up.gif"
end type

event clicked;call super::clicked;String scol, sdata
Long   crow, nrow, aa

crow = dw_insert.GetRow()
if crow < 1 then return

if dw_insert.RowsCopy(crow, crow, Primary!, dw_insert, crow + 1, Primary!) <> 1 then Return -1

nrow = crow + 1 

// 순번은 setting

dw_insert.setitem(nrow, 'seq', dw_insert.getitemnumber(1, 'max_seq') + 1)

dw_insert.ScrollToRow(nrow)
dw_insert.SetRow(nrow)
dw_insert.SetColumn("insplist")
dw_insert.SetFocus()
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "C:\erpman\image\row복사_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "C:\erpman\image\row복사_dn.gif"
end event

type rr_1 from roundrectangle within w_pdt_06020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 212
integer width = 4590
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

