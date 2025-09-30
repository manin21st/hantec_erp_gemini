$PBExportHeader$w_imt_03036.srw
$PBExportComments$B/L 통관일자 등록(분할가능)
forward
global type w_imt_03036 from w_inherite
end type
type dw_1 from datawindow within w_imt_03036
end type
type dw_detail from datawindow within w_imt_03036
end type
type dw_hidden from datawindow within w_imt_03036
end type
type st_2 from statictext within w_imt_03036
end type
type st_3 from statictext within w_imt_03036
end type
type p_1 from uo_picture within w_imt_03036
end type
type st_22 from statictext within w_imt_03036
end type
type pb_1 from u_pb_cal within w_imt_03036
end type
type pb_2 from u_pb_cal within w_imt_03036
end type
type pb_3 from u_pb_cal within w_imt_03036
end type
type rr_2 from roundrectangle within w_imt_03036
end type
type rr_4 from roundrectangle within w_imt_03036
end type
type rr_44 from roundrectangle within w_imt_03036
end type
end forward

global type w_imt_03036 from w_inherite
string title = "B/L 통관일자 등록(분할)"
dw_1 dw_1
dw_detail dw_detail
dw_hidden dw_hidden
st_2 st_2
st_3 st_3
p_1 p_1
st_22 st_22
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
rr_2 rr_2
rr_4 rr_4
rr_44 rr_44
end type
global w_imt_03036 w_imt_03036

type variables
//정렬 사용 변수
String is_old_dwobject_name,is_old_color
Boolean b_flag

//Multi Select 사용 변수
long il_lastclickedrow
boolean ib_action_on_buttonup
end variables

forward prototypes
public subroutine wf_reset ()
end prototypes

public subroutine wf_reset ();dw_1.setredraw(false)

dw_insert.reset()
dw_detail.reset()
dw_hidden.reset()
dw_1.reset()
dw_1.insertrow(0)
dw_1.setitem(1, 'sdate', f_today())
dw_1.setcolumn('fblno')
dw_1.setfocus()
dw_1.setredraw(true)


end subroutine

on w_imt_03036.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_detail=create dw_detail
this.dw_hidden=create dw_hidden
this.st_2=create st_2
this.st_3=create st_3
this.p_1=create p_1
this.st_22=create st_22
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.rr_2=create rr_2
this.rr_4=create rr_4
this.rr_44=create rr_44
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_hidden
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.st_22
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.pb_3
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_4
this.Control[iCurrent+13]=this.rr_44
end on

on w_imt_03036.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_detail)
destroy(this.dw_hidden)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.st_22)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.rr_2)
destroy(this.rr_4)
destroy(this.rr_44)
end on

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
dw_hidden.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1, 'sdate', is_today)
f_mod_saupj(dw_1, 'saupj')

dw_1.SetFocus()

end event

event open;call super::open;PostEvent("ue_open")
end event

type dw_insert from w_inherite`dw_insert within w_imt_03036
integer x = 1486
integer y = 228
integer width = 3122
integer height = 1304
integer taborder = 30
string dataobject = "d_imt_03036_1"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::rowfocuschanged;//
//SelectRow(0,False)
//SelectRow(currentrow,True)
//
//ScrollToRow(currentrow)
end event

event dw_insert::clicked;call super::clicked;string s_blno, sentdat
Dec    dEntSeq
Long   ix

If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	s_blno  = this.getitemstring(row, 'poblno')
	sentdat = this.getitemstring(row, 'entdat')
	dEntSeq = this.getitemNumber(row, 'entseq')	// 통관차수
   dw_detail.Retrieve(gs_sabu, s_blno, dEntSeq) 
   dw_hidden.Retrieve(gs_sabu, s_blno) 
				
	if sentdat = '' or isnull(sentdat) then 
	   dw_1.setitem(1, 'sdate', '')
	   dw_1.setitem(1, 'impno', '')
	   dw_1.setitem(1, 'blrate', 0)
	   dw_1.setitem(1, 'usrate', 0)
	   dw_1.setitem(1, 'usdrat', 0)

		// 통관처리시 Insert하기위해 new상태로 변경
		For ix = 1 To dw_detail.RowCount()
			dw_detail.SetItem(ix, 'polcbl_enthst_entqty', dw_detail.getitemNumber(ix, 'janqty'))
			dw_detail.SetItemStatus(ix, 0, Primary!, New!)
		Next
	else
	   dw_1.setitem(1, 'sdate', sentdat)
	   dw_1.setitem(1, 'impno', this.getitemstring(row, 'imt_license'))
	   dw_1.setitem(1, 'blrate', this.getitemdecimal(row, 'blrate'))
	   dw_1.setitem(1, 'usrate', this.getitemdecimal(row, 'usrate'))
	   dw_1.setitem(1, 'usdrat', this.getitemdecimal(row, 'usdrat'))
	end if
END IF

sle_msg.text = ''
end event

type p_delrow from w_inherite`p_delrow within w_imt_03036
boolean visible = false
integer x = 2789
integer y = 28
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_imt_03036
boolean visible = false
integer x = 3026
integer y = 12
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_imt_03036
boolean visible = false
integer x = 2784
integer y = 0
integer taborder = 60
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_imt_03036
integer x = 3922
integer taborder = 0
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\통관처리_up.gif"
end type

event p_ins::clicked;call super::clicked;string sdate, simpno, sGubun, sPoblNo, sNull
Long   lmax
int    k
dec{4} nBlrate, nusrate, nusdrat 
Dec    dBlqty, dEntQty

if dw_1.AcceptText() = -1 then return 

if dw_detail.AcceptText() = -1 then return 

if dw_detail.rowcount() <= 0 then return 

If MessageBox('확 인','통관 처리 하시겠습니까?', Information!, YesNo!) = 2 Then Return

SetNull(sNull)

sGubun   = trim(dw_1.getitemstring(1, 'gubun'))
sdate   = trim(dw_1.getitemstring(1, 'sdate'))
simpno  = trim(dw_1.getitemstring(1, 'impno'))
nBlrate = dw_1.getitemdecimal(1, 'blrate')
nUsrate = dw_1.getitemdecimal(1, 'usrate') //미화환율
nUsdrat = dw_1.getitemdecimal(1, 'usdrat') //대미환산율

IF sdate = '' or isnull(sdate) then 
	f_message_chk(30,'[통관일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return
END IF

//IF nblrate <= 0 or isnull(nblrate) then 
//	f_message_chk(30,'[면장환율]')
//	dw_1.SetColumn("blrate")
//	dw_1.SetFocus()
//	Return
//END IF

//IF nusrate <= 0 or isnull(nusrate) then 
//	f_message_chk(30,'[미화환율]')
//	dw_1.SetColumn("usrate")
//	dw_1.SetFocus()
//	Return
//END IF

//IF nusdrat <= 0 or isnull(nusdrat) then 
//	f_message_chk(30,'[대미 환산율]')
//	dw_1.SetColumn("usdrat")
//	dw_1.SetFocus()
//	Return
//END IF

// 신규로 통관일자 지정시 통관차수를 계산한다
If sGubun = 'N' Then
	sPoblNo = dw_detail.GetItemString(1, 'poblno')
	select max(entseq) into :lmax from polcbl_enthst where sabu = :gs_sabu and poblno = :sPoblNo;
	If IsNull(lmax) Then lmax = 0
	
	lmax = lmax + 1
End If

FOR k=1 TO dw_detail.rowcount()
	If sGubun = 'N' Then
		dw_detail.setitem(k, 'polcbl_enthst_sabu', gs_sabu)
		dw_detail.setitem(k, 'polcbl_enthst_poblno', sPoblNo)
		dw_detail.setitem(k, 'polcbl_enthst_pobseq', dw_detail.GetItemNumber(k, 'pobseq'))
		dw_detail.setitem(k, 'polcbl_enthst_entseq', lmax)
	End If
	
   dw_detail.setitem(k, 'polcbl_enthst_entdat', sdate)
   dw_detail.setitem(k, 'polcbl_enthst_imt_license', simpno)
	dw_detail.setitem(k, 'polcbl_enthst_blrate', nBlrate)
	dw_detail.setitem(k, 'polcbl_enthst_usrate', nUsrate)
	dw_detail.setitem(k, 'polcbl_enthst_usdrat', nUsdrat)
NEXT

if dw_detail.update() = 1  then
	// B/L 헤더에 통관일자 저장한다, 단 bl수량과 통관수량이 동일한 경우만 	
	SELECT SUM(BLQTY), SUM(ENTQTY) INTO :dBlqty, :dEntQty 
	  FROM POLCBL 
	 WHERE SABU = :gs_sabu AND POBLNO = :sPoblno;
	If dBlqty > 0 And ( dBlqty = dEntQty) Then
		dw_hidden.setitem(1, 'entdat', sdate)
	Else
		dw_hidden.setitem(1, 'entdat', snull)
	End If

	if dw_hidden.update() = 1  then
		sle_msg.text = "자료가 저장되었습니다!!"
		ib_any_typing= FALSE
		commit ;
	else
		rollback ;
		messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	end if
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	

wf_reset()

ib_any_typing = True
end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\통관처리_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\통관처리_up.gif"
end event

type p_exit from w_inherite`p_exit within w_imt_03036
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_imt_03036
integer taborder = 80
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE

end event

type p_print from w_inherite`p_print within w_imt_03036
boolean visible = false
integer x = 2967
integer y = 28
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_imt_03036
integer x = 3749
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string s_frblno, s_toblno, s_frdate, s_todate, s_cvcod, sgubun, ssaupj

if dw_1.AcceptText() = -1 then return 

s_frblno= trim(dw_1.GetItemString(1, 'fblno')) 
s_toblno= trim(dw_1.GetItemString(1, 'tblno')) 
s_cvcod = dw_1.GetItemString(1,'cvcod')
s_frdate= trim(dw_1.GetItemString(1,'frdate'))  
s_todate= trim(dw_1.GetItemString(1,'todate'))  
sGubun  = dw_1.GetItemString(1,'gubun')
ssaupj  = dw_1.GetItemString(1,'saupj')

if isnull(s_frblno) or s_frblno = "" then s_frblno = '.'
if isnull(s_toblno) or s_toblno = "" then s_toblno = 'zzzzzzzzzzzzzzzzzzzz'
if isnull(s_cvcod) or s_cvcod = "" then s_cvcod = '%'
if isnull(s_frdate) or s_frdate = "" then s_frdate = '00000101'
if isnull(s_todate) or s_todate = "" then s_todate = '99991231'

IF s_frblno > s_toblno then 
	f_message_chk(34,'[B/L No]')
	dw_1.SetColumn("fblno")
	dw_1.SetFocus()
	Return
END if

IF s_frdate > s_todate then 
	f_message_chk(34,'[접수일자]')
	dw_1.SetColumn("frdate")
	dw_1.SetFocus()
	Return
END if

if dw_insert.Retrieve(gs_sabu, s_frblno, s_toblno, s_cvcod, s_frdate, s_todate, sSaupj) <= 0 then 
	f_message_chk(50,'')
	dw_1.SetFocus()
else
end if	

dw_detail.reset()
dw_hidden.reset()
ib_any_typing = FALSE

end event

type p_del from w_inherite`p_del within w_imt_03036
integer taborder = 0
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\통관취소_up.gif"
end type

event p_del::clicked;call super::clicked;int    k
string snull

setnull(snull)

if dw_1.AcceptText() = -1 then return 

if dw_detail.AcceptText() = -1 then return 

if dw_detail.rowcount() <= 0 then return 

If MessageBox('확 인','통관 취소 하시겠습니까?', Information!, YesNo!) = 2 Then Return

// 삭제
dw_detail.RowsMove(1, dw_detail.RowCount(), Primary!, dw_detail, 1, Delete!)

//FOR k=1 TO dw_detail.rowcount()
//   dw_detail.setitem(k, 'polcbl_enthst_entdat', snull)
//   dw_detail.setitem(k, 'polcbl_enthst_imt_license', snull)
//	dw_detail.setitem(k, 'polcbl_enthst_blrate', 0)
//	dw_detail.setitem(k, 'polcbl_enthst_usrate', 0)
//	dw_detail.setitem(k, 'polcbl_enthst_usdrat', 0)
//NEXT

dw_hidden.setitem(1, 'entdat', snull)

if dw_detail.update() = 1 or dw_hidden.update() = 1 then
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	

wf_reset()

ib_any_typing = True
end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\통관취소_dn.gif"
end event

event p_del::ue_lbuttonup;PictureName = "C:\erpman\image\통관취소_up.gif"
end event

type p_mod from w_inherite`p_mod within w_imt_03036
boolean visible = false
integer x = 3246
integer y = 20
integer taborder = 70
boolean enabled = false
end type

event p_mod::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 
if dw_detail.AcceptText() = -1 then return 

if dw_detail.rowcount() <= 0 then return 

if f_msg_update() = -1 then return

//if dw_detail.update() = 1 or dw_hidden.update() = 1 then
//	sle_msg.text = "자료가 저장되었습니다!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//end if	
//
end event

type cb_exit from w_inherite`cb_exit within w_imt_03036
integer x = 2130
integer y = 2680
end type

type cb_mod from w_inherite`cb_mod within w_imt_03036
integer x = 1426
integer y = 2680
end type

event cb_mod::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 
if dw_detail.AcceptText() = -1 then return 

if dw_detail.rowcount() <= 0 then return 

if f_msg_update() = -1 then return

if dw_detail.update() = 1 or dw_hidden.update() = 1 then
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	

end event

type cb_ins from w_inherite`cb_ins within w_imt_03036
integer x = 517
integer y = 2664
integer width = 352
string text = "통관처리"
end type

event cb_ins::clicked;call super::clicked;string sdate, simpno
int    k
dec{4} nBlrate, nusrate, nusdrat 

if dw_1.AcceptText() = -1 then return 

if dw_detail.AcceptText() = -1 then return 

if dw_detail.rowcount() <= 0 then return 

sdate   = trim(dw_1.getitemstring(1, 'sdate'))
simpno  = trim(dw_1.getitemstring(1, 'impno'))
nBlrate = dw_1.getitemdecimal(1, 'blrate')
nUsrate = dw_1.getitemdecimal(1, 'usrate') //미화환율
nUsdrat = dw_1.getitemdecimal(1, 'usdrat') //대미환산율

IF sdate = '' or isnull(sdate) then 
	f_message_chk(30,'[통관일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return
END IF

IF nblrate <= 0 or isnull(nblrate) then 
	f_message_chk(30,'[면장환율]')
	dw_1.SetColumn("blrate")
	dw_1.SetFocus()
	Return
END IF

IF nusrate <= 0 or isnull(nusrate) then 
	f_message_chk(30,'[미화환율]')
	dw_1.SetColumn("usrate")
	dw_1.SetFocus()
	Return
END IF

IF nusdrat <= 0 or isnull(nusdrat) then 
	f_message_chk(30,'[대미 환산율]')
	dw_1.SetColumn("usdrat")
	dw_1.SetFocus()
	Return
END IF

FOR k=1 TO dw_detail.rowcount()
   dw_detail.setitem(k, 'entdat', sdate)
   dw_detail.setitem(k, 'imt_license', simpno)
	dw_detail.setitem(k, 'blrate', nBlrate)
	dw_detail.setitem(k, 'usrate', nUsrate)
	dw_detail.setitem(k, 'usdrat', nUsdrat)
NEXT

dw_hidden.setitem(1, 'entdat', sdate)

ib_any_typing = True
end event

type cb_del from w_inherite`cb_del within w_imt_03036
integer x = 887
integer y = 2664
integer width = 352
string text = "통관취소"
end type

event cb_del::clicked;call super::clicked;int    k
string snull

setnull(snull)

if dw_1.AcceptText() = -1 then return 

if dw_detail.AcceptText() = -1 then return 

if dw_detail.rowcount() <= 0 then return 

FOR k=1 TO dw_detail.rowcount()
   dw_detail.setitem(k, 'entdat', snull)
   dw_detail.setitem(k, 'imt_license', snull)
	dw_detail.setitem(k, 'blrate', 0)
	dw_detail.setitem(k, 'usrate', 0)
	dw_detail.setitem(k, 'usdrat', 0)
NEXT

dw_hidden.setitem(1, 'entdat', snull)

ib_any_typing = True
end event

type cb_inq from w_inherite`cb_inq within w_imt_03036
integer x = 165
integer y = 2664
end type

event cb_inq::clicked;call super::clicked;string s_frblno, s_toblno, s_frdate, s_todate, s_cvcod, sgubun

if dw_1.AcceptText() = -1 then return 

s_frblno= trim(dw_1.GetItemString(1, 'fblno')) 
s_toblno= trim(dw_1.GetItemString(1, 'tblno')) 
s_cvcod = dw_1.GetItemString(1,'cvcod')
s_frdate= trim(dw_1.GetItemString(1,'frdate'))  
s_todate= trim(dw_1.GetItemString(1,'todate'))  
sGubun  = dw_1.GetItemString(1,'gubun')  

if isnull(s_frblno) or s_frblno = "" then s_frblno = '.'
if isnull(s_toblno) or s_toblno = "" then s_toblno = 'zzzzzzzzzzzzzzzzzzzz'
if isnull(s_cvcod) or s_cvcod = "" then s_cvcod = '%'
if isnull(s_frdate) or s_frdate = "" then s_frdate = '00000101'
if isnull(s_todate) or s_todate = "" then s_todate = '99991231'

IF s_frblno > s_toblno then 
	f_message_chk(34,'[B/L No]')
	dw_1.SetColumn("fblno")
	dw_1.SetFocus()
	Return
END if

IF s_frdate > s_todate then 
	f_message_chk(34,'[접수일자]')
	dw_1.SetColumn("frdate")
	dw_1.SetFocus()
	Return
END if


if sgubun = 'N' then 
	dw_insert.setFilter("isnull(polcbl_entdat)")
elseif sgubun = 'Y' then 
	dw_insert.setFilter("polcbl_entdat > '.' ")
else
	dw_insert.setFilter("")
end if
dw_insert.filter()

if dw_insert.Retrieve(gs_sabu, s_frblno, s_toblno, s_cvcod, s_frdate, s_todate) <= 0 then 
	f_message_chk(50,'')
	dw_1.SetFocus()
else
end if	

dw_detail.reset()
dw_hidden.reset()
ib_any_typing = FALSE

end event

type cb_print from w_inherite`cb_print within w_imt_03036
integer x = 1984
integer y = 2544
end type

type st_1 from w_inherite`st_1 within w_imt_03036
end type

type cb_can from w_inherite`cb_can within w_imt_03036
integer x = 1778
integer y = 2680
end type

event cb_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type cb_search from w_inherite`cb_search within w_imt_03036
integer x = 2619
integer y = 2532
end type





type gb_10 from w_inherite`gb_10 within w_imt_03036
integer y = 2764
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_03036
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_03036
end type

type dw_1 from datawindow within w_imt_03036
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 220
integer width = 1394
integer height = 1104
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_03036_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sDate, 			&
			sCode, sName,	&
			sNull
dec{4}   drate, dusrate

SetNull(sNull)

IF this.GetcolumnName() = 'cvcod'	THEN
	
	sCode = this.GetText()								
	
  	if scode = '' or isnull(scode) then
		this.setitem(1, 'cvnm', snull)
		return 
   end if
	
   SELECT CVNAS2
     INTO :sName
     FROM VNDMST
    WHERE CVCOD = :sCode  AND
	 		 CVSTATUS = '0' ;

	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[관세사]')
		this.setitem(1, 'cvcod', sNull)
		this.setitem(1, 'cvnm', snull)
	   return 1
   ELSE
		this.setitem(1, 'cvnm', sName)
   END IF
ELSEIF this.GetColumnName() = 'frdate' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[접수일자 FROM]')
		This.setitem(1, "frdate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'todate' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[접수일자 TO]')
		This.setitem(1, "todate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'sdate' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[통관일자]')
		This.setitem(1, "sdate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'blrate' THEN
   drate = dec(this.gettext()) 	
	
	if drate <= 0 or isnull(drate) then  
		this.setitem(1, 'usdrat', 0)
		return 
	end if
	
	dusrate   = this.getitemdecimal(1, 'usrate')
	if dusrate <= 0 or isnull(dusrate) then  
		this.setitem(1, 'usrate', drate)
		this.setitem(1, 'usdrat', 1)
	else
		this.setitem(1, 'usdrat', round(drate/dusrate, 6))
	end if
ELSEIF this.GetColumnName() = 'usrate' THEN
   dusrate = dec(this.gettext()) 	
	drate   = this.getitemdecimal(1, 'blrate')

	if drate <= 0 or isnull(drate) or dusrate <= 0 or isnull(dusrate) then  
		this.setitem(1, 'usdrat', 0)
	else
		this.setitem(1, 'usdrat', round(drate/dusrate, 6))
	end if

ELSEIF this.GetColumnName() = 'gubun' THEN
	if GetText() = 'N' then
		dw_insert.DataObject = 'd_imt_03036_1'
	Else
		dw_insert.DataObject = 'd_imt_03036_3'
	End If
	dw_insert.SetTransObject(sqlca)

	dw_detail.Reset()
END IF


end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "cvcod" THEN
	open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnm",  gs_CodeName)
ELSEIF this.GetColumnName() = "fblno" THEN
	Open(w_bl_popup)
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "fblno", gs_code)
ELSEIF this.GetColumnName() = "tblno" THEN
	Open(w_bl_popup)
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "tblno", gs_code)
END IF	
end event

type dw_detail from datawindow within w_imt_03036
integer x = 46
integer y = 1576
integer width = 4562
integer height = 748
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_imt_03036_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event editchanged;ib_any_typing =True
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event itemerror;RETURN 1
end event

event itemchanged;Long nRow
Dec  dJanQty, dEntQty

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'polcbl_enthst_entqty'
		dEntQty = Dec(GetText())
		
		dJanQty = GetItemNumber(nrow, 'janqty')
		If dEntQty > dJanQty Then
			MessageBox('확인','B/L 잔량보다 통관수량이 큽니다.!!')
			Return 2
		End If
End Choose
end event

type dw_hidden from datawindow within w_imt_03036
boolean visible = false
integer x = 955
integer y = 2764
integer width = 494
integer height = 360
boolean bringtotop = true
string dataobject = "d_imt_03035_3"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_imt_03036
integer x = 87
integer y = 1332
integer width = 1093
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "* 면장환율은 외화금액 1 을 기준으로"
boolean focusrectangle = false
end type

type st_3 from statictext within w_imt_03036
integer x = 146
integer y = 1480
integer width = 878
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "예) USD => 1200,  JPY => 10"
boolean focusrectangle = false
end type

type p_1 from uo_picture within w_imt_03036
boolean visible = false
integer x = 2565
integer y = 52
integer width = 178
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\button_up.gif"
end type

type st_22 from statictext within w_imt_03036
integer x = 119
integer y = 1404
integer width = 1019
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = " 원화금액을 입력하세요."
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_imt_03036
integer x = 869
integer y = 612
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('frdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'frdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_03036
integer x = 1317
integer y = 612
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('todate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'todate', gs_code)



end event

type pb_3 from u_pb_cal within w_imt_03036
integer x = 919
integer y = 832
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'sdate', gs_code)



end event

type rr_2 from roundrectangle within w_imt_03036
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 216
integer width = 1426
integer height = 1328
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_imt_03036
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1481
integer y = 216
integer width = 3136
integer height = 1328
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_44 from roundrectangle within w_imt_03036
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 1560
integer width = 4590
integer height = 776
integer cornerheight = 40
integer cornerwidth = 55
end type

