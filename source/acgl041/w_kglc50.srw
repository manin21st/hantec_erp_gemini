$PBExportHeader$w_kglc50.srw
$PBExportComments$지급결제 결제방법 등록
forward
global type w_kglc50 from w_inherite
end type
type dw_ip from u_key_enter within w_kglc50
end type
type rr_1 from roundrectangle within w_kglc50
end type
type dw_rtv from datawindow within w_kglc50
end type
end forward

global type w_kglc50 from w_inherite
integer height = 2972
string title = "지급결제 결제방법 등록"
dw_ip dw_ip
rr_1 rr_1
dw_rtv dw_rtv
end type
global w_kglc50 w_kglc50

type variables

String sUpmuGbn = 'A',LsAutoSungGbn
end variables

on w_kglc50.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_rtv
end on

on w_kglc50.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.dw_rtv)
end on

event open;call super::open;String sToday,sLastDate

dw_ip.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)

dw_ip.reset()
dw_ip.insertrow(0)

sToday = F_Today()

Select to_char(last_day(:sToday),'YYYYMMDD')
  Into :sLastDate
  From dual;

dw_ip.SetItem(dw_ip.Getrow(),"baldate",sLastDate)
dw_ip.SetItem(dw_ip.Getrow(),"acc1_cd","1")

end event

type dw_insert from w_inherite`dw_insert within w_kglc50
boolean visible = false
integer x = 1550
integer y = 2544
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglc50
boolean visible = false
integer x = 3881
integer y = 2700
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc50
boolean visible = false
integer x = 3707
integer y = 2700
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc50
boolean visible = false
integer x = 3872
integer y = 2540
integer taborder = 0
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kglc50
integer x = 4096
integer y = 8
integer taborder = 0
string picturename = "C:\erpman\image\전표처리_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\전표처리_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\전표처리_up.gif"
end event

type p_exit from w_inherite`p_exit within w_kglc50
integer y = 8
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kglc50
integer y = 8
integer taborder = 0
end type

event p_can::clicked;call super::clicked;String sToday,sLastDate

dw_ip.reset()
dw_rtv.reset()
dw_ip.insertrow(0)

sToday = F_Today()

Select to_char(last_day(:sToday),'YYYYMMDD')
  Into :sLastDate
  From dual;

dw_ip.SetItem(dw_ip.Getrow(),"baldate",sLastDate)
dw_ip.SetItem(dw_ip.Getrow(),"acc1_cd","1")
end event

type p_print from w_inherite`p_print within w_kglc50
boolean visible = false
integer x = 3698
integer y = 2528
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglc50
integer x = 3749
integer y = 8
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sGdate,sGb,sAccCd

dw_ip.accepttext()

sGdate = dw_ip.GetItemString(dw_ip.GetRow(),"baldate")
sGb    = dw_ip.GetItemString(dw_ip.GetRow(),"acc1_cd")

IF sGdate = "" OR IsNull(sGdate) THEN
	F_MessageChk(1,'[결제일자]')
	dw_ip.Setcolumn("baldate")
	dw_ip.SetFocus()
	Return
END IF

IF sGb = "" OR IsNull(sGb) THEN
	F_MessageChk(1,'[계정과목]')
	dw_ip.Setcolumn("acc1_cd")
	dw_ip.SetFocus()
	Return
END IF

Select dataname
  Into :sAccCd
  From syscnfg
 Where sysgu = 'A'
	And serial = 80
	And lineno = to_number(:sGb);

dw_rtv.Setredraw(False)

IF dw_rtv.Retrieve(sGdate,sAccCd) <=0 THEN
	F_MessageChk(14,'')
	dw_rtv.Setredraw(True)
	Return
END IF

dw_rtv.Setredraw(True)

dw_rtv.setfocus()

w_mdi_frame.sle_msg.text ="조회되었습니다!"
end event

type p_del from w_inherite`p_del within w_kglc50
boolean visible = false
integer x = 4055
integer y = 2700
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglc50
integer y = 8
string pointer = "C:\erpman\cur\create.cur"
end type

event p_mod::clicked;call super::clicked;Int    i
Double dGyelAmt,dCashAmt,dBillAmt,dAccAmt

dw_rtv.accepttext()

IF dw_rtv.rowcount() = 0 THEN
	Messagebox("확인", "처리할 자료가 없습니다!")
	Return
END IF

IF F_DbConfirm('저장') = 2 THEN Return

For i = 1 To dw_rtv.rowcount()
	
	dGyelAmt = dw_rtv.getitemnumber(i,"gyelamt")
	dCashAmt = dw_rtv.getitemnumber(i,"cashamt")
	dBillAmt = dw_rtv.getitemnumber(i,"billamt")
	dAccAmt  = dw_rtv.getitemnumber(i,"accamt")
	
	IF Isnull(dGyelAmt) THEN dGyelAmt = 0
	IF Isnull(dCashAmt) THEN dCashAmt = 0
	IF Isnull(dBillAmt) THEN dBillAmt = 0
	IF Isnull(dAccAmt)  THEN dAccAmt = 0
	
	IF dCashAmt + dBillAmt + dAccAmt > 0 THEN
		IF dGyelAmt <> dCashAmt + dBillAmt + dAccAmt THEN
			Messagebox("확인", String(i)+"행은 결제금액과 결제방법별 금액의 합이 다릅니다!")
			dw_rtv.setrow(i)
			dw_rtv.setfocus()
			Return
		END IF
	END IF
	
Next

IF dw_rtv.Update() < 0 THEN
	Rollback;
	Messagebox("확인", "수정중 오류가 발생했습니다!")
	dw_rtv.setfocus()
	Return
END IF

Commit;

p_inq.triggerevent(Clicked!)

w_mdi_frame.sle_msg.text ="저장되었습니다!"
end event

type cb_exit from w_inherite`cb_exit within w_kglc50
boolean visible = false
integer x = 2743
integer y = 2768
end type

type cb_mod from w_inherite`cb_mod within w_kglc50
boolean visible = false
integer x = 2386
integer y = 2768
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kglc50
boolean visible = false
integer x = 1006
integer y = 2580
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kglc50
boolean visible = false
integer x = 2085
integer y = 2580
end type

type cb_inq from w_inherite`cb_inq within w_kglc50
boolean visible = false
integer x = 2025
integer y = 2768
end type

type cb_print from w_inherite`cb_print within w_kglc50
boolean visible = false
integer x = 2437
integer y = 2580
end type

type st_1 from w_inherite`st_1 within w_kglc50
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kglc50
boolean visible = false
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kglc50
boolean visible = false
integer x = 3122
integer y = 2580
integer width = 334
string text = "변경(&E)"
end type

event cb_search::clicked;call super::clicked;//OPEN(W_KIFA05A)
end event

type dw_datetime from w_inherite`dw_datetime within w_kglc50
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kglc50
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kglc50
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc50
boolean visible = false
integer x = 1993
integer y = 2532
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc50
boolean visible = false
integer x = 1984
integer y = 2712
integer width = 1134
end type

type dw_ip from u_key_enter within w_kglc50
event ue_key pbm_dwnkey
integer x = 27
integer y = 20
integer width = 1925
integer height = 156
integer taborder = 10
string dataobject = "dw_kglc501"
boolean border = false
end type

event ue_key;IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  sNull,sGb,sDate
Integer iCurRow,iCount

SetNull(sNull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "baldate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate+'01') = -1 THEN
		F_MessageChk(21,'[결제일자]')
		this.SetItem(iCurRow,"baldate",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "acc1_cd" THEN
	sGb = Trim(this.GetText())
	IF sGb = "" OR IsNull(sGb) THEN RETURN
	
	Select count(*)
	  Into :iCount
	  From syscnfg
	 Where sysgu = 'A'
	   And serial = 80
		And lineno = to_number(:sGb);
	
	IF iCount = 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",sNull)
		Return 1
	END IF
END IF
end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_kglc50
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 184
integer width = 4567
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kglc50
event ue_enter pbm_dwnprocessenter
integer x = 41
integer y = 192
integer width = 4539
integer height = 2076
integer taborder = 30
string dataobject = "dw_kglc502"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;Int    iCurRow
Double dAmt,dGamt,dAmtSum

iCurRow = this.GetRow()

IF this.GetColumnName() = "cashamt" THEN
	dAmt = Double(this.GetText())
	IF dAmt = 0 OR IsNull(dAmt) THEN RETURN
	
	IF dAmt < 0 THEN
		Messagebox("확인", "금액은 양수이어야 합니다!")
		this.SetItem(iCurRow,"cashamt",0)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "billamt" THEN
	dAmt = Double(this.GetText())
	IF dAmt = 0 OR IsNull(dAmt) THEN RETURN
	
	IF dAmt < 0 THEN
		Messagebox("확인", "금액은 양수이어야 합니다!")
		this.SetItem(iCurRow,"billamt",0)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "accamt" THEN
	dAmt = Double(this.GetText())
	IF dAmt = 0 OR IsNull(dAmt) THEN RETURN
	
	IF dAmt < 0 THEN
		Messagebox("확인", "금액은 양수이어야 합니다!")
		this.SetItem(iCurRow,"accamt",0)
		Return 1
	END IF
END IF
end event

event itemerror;Return 1
end event

