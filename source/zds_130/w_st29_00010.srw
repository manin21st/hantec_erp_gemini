$PBExportHeader$w_st29_00010.srw
$PBExportComments$계측기기 점검 기준 등록
forward
global type w_st29_00010 from w_inherite
end type
type dw_ins1 from u_key_enter within w_st29_00010
end type
type cb_add from commandbutton within w_st29_00010
end type
type p_tcopy from uo_picture within w_st29_00010
end type
type pb_1 from u_pb_cal within w_st29_00010
end type
type rr_1 from roundrectangle within w_st29_00010
end type
end forward

global type w_st29_00010 from w_inherite
string title = "점검 기준 등록"
dw_ins1 dw_ins1
cb_add cb_add
p_tcopy p_tcopy
pb_1 pb_1
rr_1 rr_1
end type
global w_st29_00010 w_st29_00010

forward prototypes
public function integer wf_required_chk ()
public function integer wf_scale_chk (long arg_row)
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크 + Fill
Long i, lcount 
Integer seq
String s_mchno , ls_damdang , ls_lastinsp , ls_inspgubn, scale 
Long  ll_jugimon

s_mchno = Trim(dw_ins1.object.mchno[1])

if IsNull(s_mchno) or s_mchno = '' then
	f_message_chk(30, "[관리번호]")
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return -1
end if

ls_lastinsp =  Trim(dw_ins1.object.lastinsp[1])

lcount = dw_insert.RowCount()
for i = 1 to lcount
	dw_insert.object.sabu[i] = gs_sabu
   dw_insert.object.mchno[i] = s_mchno
	
	if IsNull(Trim(dw_insert.object.insplist[i])) or Trim(dw_insert.object.insplist[i]) = "" then
		f_message_chk(1400, "[점검항목]")
		dw_insert.ScrollToRow (i)
		dw_insert.SetColumn("insplist")
		dw_insert.SetFocus()
		Return -1
   end if
	
	// 측정범위 check
	if wf_scale_chk(i) = -1 then return -1
	
next

return 1
end function

public function integer wf_scale_chk (long arg_row);if arg_row <= 0 then return 1
dw_insert.accepttext()

string	scale

//// 측정범위 check
//scale = dw_insert.getitemstring(arg_row,'scale')
//if IsNull(scale) or scale = "" then
//else
//	if pos(scale,' ') > 0 or &
//		pos(scale,'_') = 0 or &
//		pos(scale,'_',pos(scale,'_')+1) > 0 or &
//		not isnumber(left(scale,pos(scale,'_') -1)) or &
//		not isnumber(mid(scale,pos(scale,'_')+1)) then
//		messagebox('확인','측정범위 지정 오류입니다!!!~n~n ex) 0_15 , -30_30 , -30_-10')
//		dw_insert.ScrollToRow(arg_row)
//		dw_insert.SetColumn("scale")
//		dw_insert.SetFocus()
//		Return -1
//	end if
//end if

return 1
end function

on w_st29_00010.create
int iCurrent
call super::create
this.dw_ins1=create dw_ins1
this.cb_add=create cb_add
this.p_tcopy=create p_tcopy
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ins1
this.Control[iCurrent+2]=this.cb_add
this.Control[iCurrent+3]=this.p_tcopy
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_st29_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ins1)
destroy(this.cb_add)
destroy(this.p_tcopy)
destroy(this.pb_1)
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
//dw_ins1.Object.lastinsp[1] = is_today
//dw_ins1.Object.inspgubn[1] = '4'
dw_ins1.Setredraw(True)
dw_ins1.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_st29_00010
integer x = 46
integer y = 268
integer width = 4558
integer height = 1984
integer taborder = 20
string dataobject = "d_st29_00010_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

event dw_insert::ue_pressenter;if this.GetColumnName() = "inspban" or this.GetColumnName() = "inspgijun" &
   or this.GetColumnName() = "insplist"  then return

Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::itemchanged;call super::itemchanged;post wf_scale_chk(row)
end event

type p_delrow from w_inherite`p_delrow within w_st29_00010
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

//lcnt = 0
//select count(*) into :lcnt
//  from mchrsl
// where sabu 	= :gs_sabu
// 	and mchno	= :smchno
//	and seq		= :lseqno;
//	
//if lcnt > 0 then
//	Messagebox("계획 및 실적", "점검 계획 및 실적에 이미 자료가 존재합니다", stopsign!)
//	return
//end if


if f_msg_delete() = -1 then return

ib_any_typing =True

dw_insert.DeleteRow(lcRow)

w_mdi_frame.sle_msg.Text = "삭제 되었습니다! 저장버튼을 CLICK하여 자료를 저장하세요!"

end event

type p_addrow from w_inherite`p_addrow within w_st29_00010
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
dw_insert.SetColumn("insplist")

//if dw_insert.rowcount() > 1 then 
//   dw_insert.setitem(crow, 'seq', dw_insert.getitemnumber(1, 'max_seq') + 1)
//else
//   dw_insert.setitem(crow, 'seq', 1)
//end if

dw_insert.AcceptText()
dw_insert.Setredraw(True)
dw_insert.SetFocus()
ib_any_typing =True


end event

type p_search from w_inherite`p_search within w_st29_00010
integer x = 3273
integer y = 36
boolean originalsize = true
string picturename = "C:\erpman\image\복사_up.gif"
end type

event p_search::ue_lbuttondown;//picturename = "C:\erpman\image\타설비복사_dn.gif"
end event

event p_search::ue_lbuttonup;//picturename = "C:\erpman\image\타설비복사_up.gif"
end event

event p_search::clicked;call super::clicked;String  sMchno, sStopdat, sTargetMchno
Long    i_cnt, ix

if dw_ins1.AcceptText() = -1 then return

sMchno = Trim(dw_ins1.GetItemString(1,'mchno'))

if IsNull(sMchno) or sMchno = '' then
	sle_msg.text = "관리번호를 먼저 입력한 후 진행하세요!"
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return 
end if

//open(w_mchno_popup)
open(w_st22_00020_popup)
If IsNull(gs_code) Or gs_code = '' Then Return

sTargetMchno = gs_code

/* 계측기번호를 체크한다. */
select count(mchno) into :i_cnt from mchmst_insp
 where sabu = :gs_sabu and mchno = :sTargetMchno/* and inspday = '9' */;
	
If sqlca.sqlcode <> 0 or i_cnt < 1 then
   MessageBox("확인", "복사할 점검기준 내역이 없습니다!")
   Return
Else
	dw_insert.SetRedraw(False)
	If dw_insert.Retrieve(gs_sabu, sTargetMchno) < 1 then
		MessageBox("확인", "복사할 점검기준 내역이 없습니다!")
	Else
		/* 기존 내역 삭제 */
		DELETE FROM mchmst_insp
 		 WHERE sabu = :gs_sabu and mchno = :sMchno/* and inspday = '9' */;
 
 		If sqlca.sqlcode <> 0 Then
			RollBack;
			MessageBox("확인", "기존 점검기준 내역 삭제를 실패하였습니다!")
			dw_insert.SetRedraw(True)
			Return
		End If

		/* 신규 계측기번호 설정 */
		For ix = 1 To dw_insert.RowCount()
			dw_insert.SetItem(ix, 'mchno', sMchno)
			dw_insert.SetItemStatus(ix, 0, Primary!, NewModified!)
		Next
		
		p_delrow.Enabled = True		
		p_addrow.Enabled = True
		p_mod.Enabled = True
		p_delrow.picturename = "c:\erpman\image\행삭제_up.gif" 
		p_addrow.picturename = "c:\erpman\image\행추가_up.gif"
		p_mod.picturename = "c:\erpman\image\저장_up.gif"
				
		dw_insert.SetColumn("inspbody")
		dw_insert.SetFocus() 
	End If
   dw_insert.SetRedraw(True)
End If	

end event

type p_ins from w_inherite`p_ins within w_st29_00010
integer x = 3397
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_st29_00010
integer x = 4439
integer y = 36
end type

type p_can from w_inherite`p_can within w_st29_00010
integer x = 4265
integer y = 36
end type

event p_can::clicked;call super::clicked;//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 
rollback ;

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)

dw_ins1.SetRedraw(False)
dw_ins1.Reset()
dw_ins1.InsertRow(0)
//dw_ins1.Object.lastinsp[1] = is_today
//dw_ins1.Object.inspgubn[1] = '4'
dw_ins1.SetRedraw(True)
dw_ins1.SetFocus()

ib_any_typing = False //입력필드 변경여부 No
end event

type p_print from w_inherite`p_print within w_st29_00010
integer x = 3049
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_st29_00010
integer x = 3099
integer y = 36
end type

event p_inq::clicked;call super::clicked;String  s_mchno

if dw_ins1.AcceptText() = -1 then return

s_mchno = dw_ins1.object.mchno[1]

if IsNull(s_mchno) or s_mchno = '' then
	sle_msg.text = "관리번호를 먼저 입력한 후 진행하세요!"
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return 
end if

dw_insert.SetRedraw(False)
if dw_insert.Retrieve(gs_sabu, s_mchno) < 1 then
	dw_insert.InsertRow(0)
	sle_msg.text = "신규로 등록 합니다!"
end if	
p_delrow.Enabled = True
p_addrow.Enabled = True
p_mod.Enabled = True
p_delrow.picturename = "c:\erpman\image\행삭제_up.gif" 
p_addrow.picturename = "c:\erpman\image\행추가_up.gif"
p_mod.picturename = "c:\erpman\image\저장_up.gif"

dw_insert.SetColumn("insplist")
dw_insert.SetFocus() 
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_st29_00010
integer x = 4091
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_st29_00010
integer x = 4091
integer y = 36
end type

event p_mod::clicked;if dw_ins1.AcceptText() = -1 then return
if dw_insert.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return

long	lrow

//dw_insert.sort()
FOR lrow = 1 TO dw_insert.rowcount()
	dw_insert.setitem(lrow,'seq',dw_insert.getitemnumber(lrow,'no'))
NEXT

//RETURN

dw_insert.AcceptText()
IF dw_insert.Update() > 0 THEN		
	COMMIT;
	w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
END IF

dw_insert.SetRedraw(True)
ib_any_typing = False //입력필드 변경여부 No
end event

type cb_exit from w_inherite`cb_exit within w_st29_00010
integer x = 2953
integer y = 5000
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_st29_00010
integer x = 3977
integer y = 5000
integer taborder = 70
end type

type cb_ins from w_inherite`cb_ins within w_st29_00010
integer x = 352
integer y = 2336
integer taborder = 80
end type

type cb_del from w_inherite`cb_del within w_st29_00010
integer x = 4101
integer y = 5000
integer taborder = 60
end type

type cb_inq from w_inherite`cb_inq within w_st29_00010
integer x = 3739
integer y = 5000
integer taborder = 100
end type

type cb_print from w_inherite`cb_print within w_st29_00010
integer x = 731
integer y = 2328
integer taborder = 130
end type

type st_1 from w_inherite`st_1 within w_st29_00010
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_st29_00010
integer x = 4037
integer y = 5000
integer taborder = 90
end type

type cb_search from w_inherite`cb_search within w_st29_00010
integer x = 1719
integer y = 5000
integer width = 421
integer taborder = 140
string text = "타설비복사"
end type



type sle_msg from w_inherite`sle_msg within w_st29_00010
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_st29_00010
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_st29_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_st29_00010
end type

type dw_ins1 from u_key_enter within w_st29_00010
event ue_key pbm_dwnkey
integer x = 27
integer y = 24
integer width = 2711
integer height = 236
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_st29_00010_1"
boolean border = false
boolean livescroll = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;string	slast

SetNull(gs_code)
SetNull(gs_codename)

IF	GetColumnName() = "mchno" THEN		
	open(w_st22_00020_popup)
//	open(w_mchno_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	
	SetItem(GetRow(), "mchno", gs_code)
//	this.triggerevent(itemchanged!)
	this.Trigger Event itemchanged(GetRow(),dwo,gs_code)
//	SetItem(1, "mchnam", gs_codename)
//	if not (IsNull(gs_code) or gs_code = "") then
//		select lastinsp into :slast from mchmst_insp
//		 where sabu = :gs_sabu and mchno = :gs_code and inspday = '9' and rownum = 1 ;
//		if sqlca.sqlcode = 0 then this.object.lastinsp[1] = slast
//		
//	   p_inq.TriggerEvent(Clicked!)
//	end if
END IF
end event

event itemerror;return 1
end event

event itemchanged;String s_cod, s_nam, slast, s_spec, s_jungdo

s_cod = Trim(this.GetText())

if	this.getcolumnname() = "mchno" then
	
	select mchnam, spec, jungdo
	  into :s_nam, :s_spec, :s_jungdo
	  from mesmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then
		dw_insert.reset()
		f_message_chk(33,"[관리번호]")
		this.object.mchno[1] = ""
		this.object.mchnam[1] = ""
		this.object.spec[1] = ""
		this.object.jungdo[1] = ""
		return 1
	else
		this.object.mchnam[1] = s_nam
		this.object.spec[1] = s_spec
		this.object.jungdo[1] = s_jungdo
		
		select lastinsp into :slast from mchmst_insp
		 where sabu = :gs_sabu and mchno = :s_cod and /*inspday = '9' and*/ rownum = 1 ;
		if sqlca.sqlcode = 0 then this.object.lastinsp[1] = slast
		
		p_inq.TriggerEvent(Clicked!) 
	end if
	
end if


end event

type cb_add from commandbutton within w_st29_00010
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

type p_tcopy from uo_picture within w_st29_00010
integer x = 3442
integer y = 36
integer width = 306
integer taborder = 90
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\row복사_up.gif"
end type

event clicked;call super::clicked;String scol, sdata
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

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "C:\erpman\image\row복사_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "C:\erpman\image\row복사_dn.gif"
end event

type pb_1 from u_pb_cal within w_st29_00010
boolean visible = false
integer x = 2199
integer y = 52
integer height = 76
integer taborder = 150
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ins1.SetColumn('lastinsp')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ins1.SetItem(1, 'lastinsp', gs_code)

end event

type rr_1 from roundrectangle within w_st29_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 264
integer width = 4590
integer height = 2008
integer cornerheight = 40
integer cornerwidth = 55
end type

