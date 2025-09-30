$PBExportHeader$w_adt_01010.srw
$PBExportComments$** 운송내역 등록
forward
global type w_adt_01010 from w_inherite
end type
type dw_cond from datawindow within w_adt_01010
end type
type dw_list from datawindow within w_adt_01010
end type
type st_2 from statictext within w_adt_01010
end type
type pb_1 from u_pb_cal within w_adt_01010
end type
type pb_2 from u_pb_cal within w_adt_01010
end type
type pb_3 from u_pb_cal within w_adt_01010
end type
type cbx_1 from checkbox within w_adt_01010
end type
type rb_1 from radiobutton within w_adt_01010
end type
type rb_2 from radiobutton within w_adt_01010
end type
type rr_1 from roundrectangle within w_adt_01010
end type
type rr_2 from roundrectangle within w_adt_01010
end type
type rr_3 from roundrectangle within w_adt_01010
end type
end forward

global type w_adt_01010 from w_inherite
string title = "운송내역 등록"
dw_cond dw_cond
dw_list dw_list
st_2 st_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
cbx_1 cbx_1
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_adt_01010 w_adt_01010

type variables
string is_gbn
end variables

forward prototypes
public function integer wf_ins_chk ()
public function integer wf_mod_chk ()
public subroutine wf_init ()
end prototypes

public function integer wf_ins_chk ();string sdate, sdept

sdate = dw_cond.GetItemString(1, 'sdate')
sdept = dw_cond.GetItemString(1, 'deptcode')

if sdate = '' or isNull(sdate) then
	f_message_chk(30,'[운송일자]')
	dw_cond.SetColumn("sdate")
	dw_cond.SetFocus()
	RETURN -1
END IF

if sdept = '' or isNull(sdept) then
	f_message_chk(30,'[작성부서]')
	dw_cond.SetColumn("deptcode")
	dw_cond.SetFocus()
	RETURN -1
END IF

return 1
end function

public function integer wf_mod_chk ();string scvcod, sarea, scarno, sdriver
double damt

scvcod  = dw_insert.GetItemString(1, 'cvcod')
sarea   = dw_insert.GetItemString(1, 'areanm')
scarno  = dw_insert.GetItemString(1, 'carno')
sdriver = dw_insert.GetItemString(1, 'driver')
damt    = dw_insert.GetItemNumber(1, 'trnsamt')

if scvcod = '' or isNull(scvcod) then
	f_message_chk(30,'[운송업체]')
	dw_cond.SetColumn("cvcod")
	dw_cond.SetFocus()
	RETURN -1
END IF

if sarea = '' or isNull(sarea) then
	f_message_chk(30,'[운송지역]')
	dw_cond.SetColumn("areanm")
	dw_cond.SetFocus()
	RETURN -1
END IF

if scarno = '' or isNull(scarno) then
	f_message_chk(30,'[차량번호]')
	dw_cond.SetColumn("carno")
	dw_cond.SetFocus()
	RETURN -1
END IF

if sdriver = '' or isNull(sdriver) then
	f_message_chk(30,'[차량번호]')
	dw_cond.SetColumn("driver")
	dw_cond.SetFocus()
	RETURN -1
END IF

if damt = 0 or isNull(damt) then
	f_message_chk(30,'[운송금액]')
	dw_cond.SetColumn("trnsamt")
	dw_cond.SetFocus()
	RETURN -1
END IF

return 1
end function

public subroutine wf_init ();dw_list.Reset()
dw_insert.Reset()
dw_cond.Reset()
dw_cond.InsertRow(0)

f_mod_saupj(dw_cond, 'saupj')
dw_cond.SetItem(1, 'sdate', f_today())

dw_cond.SetItem(1, 'fdate', string(f_today(),'@@@@@@01'))
dw_cond.SetItem(1, 'tdate', f_today())


dw_cond.SetColumn('deptcode')
dw_cond.SetFocus()


dw_cond.SetItem(1, 'gbn', is_gbn)

if is_gbn = '2' then
	p_ins.Picturename = 'c:\erpman\image\추가_d.gif'
	p_ins.Enabled = false	
	p_del.Picturename = 'c:\erpman\image\삭제_up.gif'
	p_del.Enabled = true
	dw_list.dataobject = 'd_adt_01010_04'
	pb_1.visible = false
else
	p_ins.Picturename = 'c:\erpman\image\추가_d.gif'
	p_ins.Enabled = false
	p_del.Picturename = 'c:\erpman\image\삭제_d.gif'
	p_del.Enabled = false
	dw_list.dataobject = 'd_adt_01010_03'
	pb_1.visible = true
end if

dw_list.SetTransObject(sqlca)
end subroutine

on w_adt_01010.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_list=create dw_list
this.st_2=create st_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.cbx_1=create cbx_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_3
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_3
end on

on w_adt_01010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.cbx_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_cond.SetTransobject(sqlca)
dw_insert.SetTransobject(sqlca)
dw_list.SetTransobject(sqlca)

is_gbn = '1'

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_adt_01010
integer x = 27
integer y = 296
integer width = 4544
integer height = 768
string dataobject = "d_adt_01010_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemfocuschanged;call super::itemfocuschanged;Choose Case GetColumnName()
	Case 'areanm', 'carno', 'driver', 'bigo'
		f_toggle_kor(handle(this))		
	Case Else
		f_toggle_eng(handle(this))
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::itemchanged;call super::itemchanged;string scvcod, scvnas, snull

setNull(sNull)

Choose Case getcolumnname()
	case 'cvcod'
		scvcod = trim(gettext())
		select cvnas2 into :scvnas
		  from vndmst
		 where cvcod = :scvcod;
		
		if sqlca.sqlcode = 0 then
			setitem(getrow(), 'cvnas2', scvnas)
		else
			setitem(getrow(), 'cvnas2', snull)
			setitem(getrow(), 'cvnas2', snull)
		end if
End Choose
end event

event dw_insert::rbuttondown;call super::rbuttondown;String snull

setNull(gs_code)
setNull(gs_codename)
setNull(gs_gubun)
setNull(sNull)

Choose Case GetColumnName()
	Case 'cvcod'
		gs_gubun = '1'
		open(w_vndmst_popup)
		
		if gs_code = '' or isNull(gs_code) then
			setitem(getrow(), 'cvcod', snull)
			setitem(getrow(), 'cvnas2', snull)
		else
			setitem(getrow(), 'cvcod',  gs_code)
			setitem(getrow(), 'cvnas2', gs_codename)
		end if
End Choose
			
		
end event

event dw_insert::doubleclicked;call super::doubleclicked;if is_gbn = '1' then return
if RowCount() < 1 then return

string sjpno

sjpno = GetItemString(getrow(), 'trnsno')

dw_list.Retrieve(gs_sabu, gs_saupj, sjpno + '%')


end event

type p_delrow from w_inherite`p_delrow within w_adt_01010
integer x = 2825
integer y = 700
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_adt_01010
integer x = 2651
integer y = 700
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_adt_01010
integer x = 1957
integer y = 700
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_adt_01010
integer x = 3749
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;if dw_cond.AcceptText() <> 1 then return 2
if wf_ins_chk() <> 1 then return 2

string sdept, sdate
long lRow

sdept = dw_cond.GetItemString(1, 'deptcode')
sdate = dw_cond.GetItemString(1, 'sdate')

dw_insert.ScrollToRow(dw_insert.InsertRow(0))
lRow = dw_insert.GetRow()
dw_insert.SetItem(lRow, 'sabu',     gs_sabu)
dw_insert.SetItem(lRow, 'saupj',    gs_saupj)
dw_insert.SetItem(lRow, 'trnsdat',  sdate)
dw_insert.SetItem(lRow, 'deptcode', sdept)

dw_insert.SetColumn('cvcod')
dw_insert.SetFocus()
return 1

end event

type p_exit from w_inherite`p_exit within w_adt_01010
end type

type p_can from w_inherite`p_can within w_adt_01010
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_adt_01010
integer x = 2130
integer y = 700
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_adt_01010
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string sfdate, stdate, sdept

if dw_cond.AcceptText() <> 1 then return

sfdate = dw_cond.Getitemstring(1, 'fdate')
stdate = dw_cond.Getitemstring(1, 'tdate')
sdept  = dw_cond.Getitemstring(1, 'deptcode')

if sfdate = '' or isNull(sfdate) then sfdate = '11111111'
if stdate = '' or isNull(stdate) then stdate = '99999999'
if sdept  = '' or isNull(sdept) then sdept = '%'

if is_gbn = '1' then		
	if dw_list.Retrieve(gs_sabu, gs_saupj, sfdate, stdate) < 1 then
		MessageBox('조회', '해당 의뢰기간으로 조회한 출문의뢰 내역이 없습니다.', Exclamation!)
		dw_cond.SetColumn('fdate')
		dw_cond.SetFocus()	
		return 2
	end if
	
	p_ins.Enabled = true
	p_ins.PictureName = 'c:\erpman\image\추가_up.gif'
	
else
	if dw_insert.Retrieve(gs_sabu, sdept, sfdate, stdate) < 1 then
		MessageBox('조회', '해당 조건으로 조회한 운송내역이 없습니다.', Exclamation!)
		dw_cond.SetColumn('fdate')
		dw_cond.SetFocus()	
		return 2
	end if
end if
end event

type p_del from w_inherite`p_del within w_adt_01010
end type

event p_del::clicked;call super::clicked;if dw_list.RowCount() < 1 then return
if dw_list.AcceptText() <> 1 then return

long i, j
string sjpno, schk

j = 0

For i = 1 to dw_list.RowCount()
	if dw_list.getitemstring(i, 'chk') = 'Y' then j++
Next

if j = dw_list.RowCount() then
	if MessageBox('[경고]', '모든 출문의뢰내역 연결을 삭제 시 운송내역도 자동삭제 됩니다.~r' + &
	                     '삭제하시겠습니까?', Question!, YesNo!, 2) = 2 then
		return
	else
		j = 0
	end if
end if


For i = dw_list.RowCount() to 1 step -1
	schk = dw_list.getitemstring(i, 'chk')
	if schk = 'Y' then
		j++
		sjpno = dw_list.getitemstring(i, 'yebi5')
		update imhist
		   set yebi5 = null
		 where yebi5 = :sjpno;
		 
		if sqlca.sqlcode <> 0 then
			
			MessageBox('삭제실패', '삭제에 실패하였습니다.~r' +&
			                       '전산실에 문의하세요.', Stopsign!)
			rollback;
			return
		end if
		
		dw_list.DeleteRow(i)
		
		if dw_list.RowCount() < 1 then
			dw_insert.DeleteRow(dw_insert.GetRow())
		end if
		
	end if
Next

if j < 1 then
	MessageBox('삭제', '선택한 삭제내역이 없습니다.', Exclamation!)
	return
else
	if dw_insert.Update() < 1 then
		MessageBox('삭제실패', '삭제에 실패하였습니다.~r' +&
		                       '전산실에 문의하세요.', Stopsign!)
		rollback;
		return
	end if	
	
	commit;
end if
end event

type p_mod from w_inherite`p_mod within w_adt_01010
end type

event p_mod::clicked;call super::clicked;string sjpno, sdate, siojpno
long dmaxno, i, dCnt

if dw_insert.RowCount() < 1 then return 2
if dw_insert.AcceptText() <> 1 then return 2
if wf_mod_chk() <> 1 then return 2

//업무 구분 필드(영업 = 'S', 구매 = 'M')
for i = 1 to dw_insert.rowcount()
	 dw_insert.Setitem(i, 'trnsgu', 'M')
next	

dCnt = 0
if is_gbn = '1' then
	for i = 1 to dw_list.Rowcount()
		if dw_list.GetItemString(i, 'chk') = 'Y' then dCnt++
	Next
	
	if dcnt < 1 then
		MessageBox('[출문의뢰내역]', '연결할 출문의뢰 내역이 없습니다.', Exclamation!)
	end if
		
	
	if MessageBox('[출문 의뢰내역 연결]', '[출문 의뢰 내역]에 Check된  의뢰 내역의 해당 운송장에 연결 하시겠습니까?', &
														question!, YesNo!, 2) = 2 then
		return 2
	end if
	
	sdate = dw_cond.GetItemString(1, 'sdate')
	
	dmaxno = sqlca.fun_junpyo(gs_sabu, sdate, 'M2') // 운송장 번호 채번
	commit;
	
	sjpno  = sdate + string(dmaxno, '0000')
	
	dw_insert.Setitem(1, 'trnsno', sjpno)
	
	if dw_insert.update() <> 1 then
		MessageBox('저장실패', '[운송내역] 등록에 실패했습니다.~r' + &
									  '전산실에 문의 하세요.', Stopsign!)
		Rollback;
		return
	end if
	
	for i = 1 to dw_list.Rowcount()
		siojpno = dw_list.GetItemString(i , 'iojpno')
		update imhist
			set yebi5 = :sjpno
		 where sabu = :gs_sabu
		   and iojpno = :siojpno;
		
		if sqlca.sqlcode <> 0 then
			MessageBox('저장실패', '[출문의뢰(출고) - 운송번호 저장] UPDATE 실패!~r' + &
										  '전산실에 문의 하세요.', Stopsign!)
			Rollback;
			return
		end if
		
		update imhist
			set yebi5 = :sjpno
		 where sabu = :gs_sabu 
		   and ip_jpno = :siojpno;
		
		if sqlca.sqlcode <> 0 then
			MessageBox('저장실패', '[출문의뢰(입고) - 운송번호 저장] UPDATE 실패!~r' + &
										  '전산실에 문의 하세요.', Stopsign!)
			Rollback;
			return
		end if
		
	Next
else
	if dw_insert.update() <> 1 then
		MessageBox('저장실패', '[운송내역] 수정에 실패했습니다.~r' + &
									  '전산실에 문의 하세요.', Stopsign!)
		Rollback;
		return
	end if
end if
Commit;

wf_init()
end event

type cb_exit from w_inherite`cb_exit within w_adt_01010
end type

type cb_mod from w_inherite`cb_mod within w_adt_01010
end type

type cb_ins from w_inherite`cb_ins within w_adt_01010
end type

type cb_del from w_inherite`cb_del within w_adt_01010
end type

type cb_inq from w_inherite`cb_inq within w_adt_01010
end type

type cb_print from w_inherite`cb_print within w_adt_01010
end type

type st_1 from w_inherite`st_1 within w_adt_01010
end type

type cb_can from w_inherite`cb_can within w_adt_01010
end type

type cb_search from w_inherite`cb_search within w_adt_01010
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_01010
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_01010
end type

type dw_cond from datawindow within w_adt_01010
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 23
integer y = 36
integer width = 2770
integer height = 228
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_adt_01010_01"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;send(handle(this), 256,9,0)
return 1
end event

event itemerror;return 1
end event

event rbuttondown;string sNull

setNull(gs_code)
setNull(gs_codename)
setNull(gs_gubun)
setNull(sNull)


Choose Case GetColumnName()
	Case "deptcode"
		open(w_vndmst_4_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return		
		SetItem(1, "deptcode", gs_Code)
		SetItem(1, "deptname", gs_Codename)
		
	Case "sjpno"
		
End Choose
end event

event itemchanged;string sNull, sjpno, sdeptcode, sdeptname

setNull(sNull)


Choose Case GetColumnName()
	Case "deptcode"
		sdeptcode = Trim(GetText())
		
		select cvnas into :sdeptname
		  from vndmst
		 where cvgu = '4'
		   and cvcod = :sdeptcode;
		
		if sqlca.sqlcode = 0 then
			setitem(1, 'deptname', sdeptname)
		else
			setitem(1, 'deptcode', snull)
			setitem(1, 'deptname', snull)
		end if
		
	Case "sjpno"		
End Choose
end event

type dw_list from datawindow within w_adt_01010
integer x = 27
integer y = 1204
integer width = 4544
integer height = 1032
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_adt_01010_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_adt_01010
integer x = 32
integer y = 1116
integer width = 466
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "* 출문의뢰 내역"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_adt_01010
integer x = 2629
integer y = 60
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_adt_01010
integer x = 649
integer y = 148
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('fdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'fdate', gs_code)

end event

type pb_3 from u_pb_cal within w_adt_01010
integer x = 1097
integer y = 148
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('tdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'tdate', gs_code)

end event

type cbx_1 from checkbox within w_adt_01010
integer x = 4256
integer y = 1108
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;if dw_list.RowCount() < 1 then return

long i

For i = 1 to dw_list.RowCount()
	IF checked then
		dw_list.SetItem(i, 'chk', 'Y')
	ELSE
		dw_list.SetItem(i, 'chk', 'N')
	END IF
NEXT


	
end event

type rb_1 from radiobutton within w_adt_01010
integer x = 2853
integer y = 84
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등  록"
boolean checked = true
end type

event clicked;is_gbn = '1'

wf_init()
end event

type rb_2 from radiobutton within w_adt_01010
integer x = 2853
integer y = 168
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수  정"
end type

event clicked;is_gbn = '2'

wf_init()
end event

type rr_1 from roundrectangle within w_adt_01010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 23
integer y = 284
integer width = 4576
integer height = 800
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_adt_01010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 23
integer y = 1188
integer width = 4576
integer height = 1064
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_adt_01010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2798
integer y = 40
integer width = 425
integer height = 220
integer cornerheight = 40
integer cornerwidth = 55
end type

