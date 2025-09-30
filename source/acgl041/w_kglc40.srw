$PBExportHeader$w_kglc40.srw
$PBExportComments$지급결제 결제내역 등록
forward
global type w_kglc40 from w_inherite
end type
type dw_ip from u_key_enter within w_kglc40
end type
type rr_1 from roundrectangle within w_kglc40
end type
type dw_rtv from datawindow within w_kglc40
end type
type rb_1 from radiobutton within w_kglc40
end type
type rb_2 from radiobutton within w_kglc40
end type
type rr_2 from roundrectangle within w_kglc40
end type
end forward

global type w_kglc40 from w_inherite
string title = "지급결제 결제내역 등록"
dw_ip dw_ip
rr_1 rr_1
dw_rtv dw_rtv
rb_1 rb_1
rb_2 rb_2
rr_2 rr_2
end type
global w_kglc40 w_kglc40

type variables

String sUpmuGbn = 'A',LsAutoSungGbn
end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();String sNull,sToday,sLastDate

SetNull(sNull)

dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.InsertRow(0)

sToday = F_Today()

Select to_char(last_day(:sToday),'YYYYMMDD')
  Into :sLastDate
  From dual;

dw_ip.SetItem(dw_ip.Getrow(),"basedate",F_Today())
dw_ip.SetItem(dw_ip.Getrow(),"baldate",sLastDate)
dw_ip.SetItem(dw_ip.Getrow(),"acc1_cd","1")

dw_ip.SetItem(dw_ip.Getrow(),"saupj",gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(),"deptcode",gs_dept)
dw_ip.SetItem(dw_ip.GetRow(),"empno",   gs_empno)
dw_ip.SetItem(dw_ip.GetRow(),"empname", F_Get_PersonLst('4',Gs_EmpNo,'1'))

dw_ip.SetRedraw(True)

dw_ip.SetColumn("basedate")
dw_ip.SetFocus()

dw_rtv.reset()

IF sModStatus = 'I' THEN					/*등록*/
	dw_rtv.DataObject = 'dw_kglc402'
ELSE
	dw_rtv.DataObject = 'dw_kglc403'
END IF

dw_rtv.SetTransObject(SQLCA)

p_mod.Enabled = False
p_mod.PictureName = "C:\erpman\image\저장_d.gif"
end subroutine

on w_kglc40.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_rtv
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rr_2
end on

on w_kglc40.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.dw_rtv)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_kglc40
boolean visible = false
integer x = 1550
integer y = 2544
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglc40
boolean visible = false
integer x = 3881
integer y = 2700
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc40
boolean visible = false
integer x = 3707
integer y = 2700
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc40
boolean visible = false
integer x = 3712
integer y = 0
integer taborder = 0
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kglc40
boolean visible = false
integer x = 3534
integer y = 2700
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglc40
integer y = 8
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kglc40
integer y = 8
integer taborder = 0
end type

event p_can::clicked;call super::clicked;rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_kglc40
boolean visible = false
integer x = 3698
integer y = 2528
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglc40
integer x = 3922
integer y = 8
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sBdate,sGdate,sGb,sAccCd,sCust,sJunMon,sJJunMon

dw_ip.AcceptText()

sBdate = dw_ip.GetItemString(dw_ip.GetRow(),"basedate")
sGdate = dw_ip.GetItemString(dw_ip.GetRow(),"baldate")
sGb    = dw_ip.GetItemString(dw_ip.GetRow(),"acc1_cd")
sCust  = dw_ip.GetItemString(dw_ip.GetRow(),"cust")

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

IF sModStatus = "I" THEN
	
	IF sBdate = "" OR IsNull(sBdate) THEN
		F_MessageChk(1,'[기준일자]')
		dw_ip.Setcolumn("basedate")
		dw_ip.SetFocus()
		Return
	END IF

	IF sCust = "" OR IsNull(sCust) THEN sCust = '%'
	
	IF Mid(sBdate,5,2) = "01" THEN
		sJunMon = "000000"
		sJJunMon = Mid(sBdate,1,4)+"00"
	ELSE
		sJunMon = String(Long(Mid(sBdate,1,6))-1)
		sJJunMon = String(Long(Mid(sBdate,1,6))-2)
	END IF
	
	dw_rtv.Setredraw(False)
	
	IF dw_rtv.Retrieve(gs_saupj,sBdate,sGdate,sJJunMon,sJunMon,Mid(sBdate,1,6),sAccCd,sCust) <=0 THEN
		F_MessageChk(14,'')
		dw_rtv.Setredraw(True)
		Return
	END IF
	
	dw_rtv.Setredraw(True)
	
ELSE
	
	dw_rtv.Setredraw(False)
	
	IF dw_rtv.Retrieve(sGdate,sAccCd) <=0 THEN
		F_MessageChk(14,'')
		dw_rtv.Setredraw(True)
		Return
	END IF
	
	dw_rtv.Setredraw(True)
	
	dw_ip.setitem(dw_ip.getrow(),"saupj",dw_rtv.getitemstring(1,"saupj"))
	dw_ip.setitem(dw_ip.getrow(),"deptcode",dw_rtv.getitemstring(1,"dept_cd"))
	dw_ip.setitem(dw_ip.getrow(),"empno",dw_rtv.getitemstring(1,"sawon"))
	dw_ip.setitem(dw_ip.getrow(),"empname",dw_rtv.getitemstring(1,"sawon_nm"))
	
END IF

dw_rtv.setfocus()

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"

w_mdi_frame.sle_msg.text ="조회되었습니다!"
end event

type p_del from w_inherite`p_del within w_kglc40
boolean visible = false
integer x = 4055
integer y = 2700
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglc40
integer x = 4096
integer y = 8
string pointer = "C:\erpman\cur\create.cur"
end type

event p_mod::clicked;call super::clicked;Int    i,iCount
Double dGyelAmt,dGichoAmt,dJunMonAmt,dDangMonAmt
String sGb,sBaseDate,sGyelDate,sSaupj,sDept,sSawon,sAccCd,sSaupNo

dw_ip.accepttext()
dw_rtv.accepttext()

IF F_DbConfirm('저장') = 2 THEN Return

sBaseDate = dw_ip.GetItemString(dw_ip.GetRow(),"basedate")
sGyelDate = dw_ip.GetItemString(dw_ip.GetRow(),"baldate")
sGb       = dw_ip.GetItemString(dw_ip.GetRow(),"acc1_cd")

sSaupj = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sDept  = dw_ip.GetItemString(dw_ip.GetRow(),"deptcode")
sSawon = dw_ip.GetItemString(dw_ip.GetRow(),"empno")

Select dataname
  Into :sAccCd
  From syscnfg
 Where sysgu = 'A'
	And serial = 80
	And lineno = to_number(:sGb);

IF sModStatus = "I" THEN

	IF sBaseDate = "" OR IsNull(sBaseDate) THEN
		F_MessageChk(1,'[기준일자]')
		dw_ip.Setcolumn("basedate")
		dw_ip.SetFocus()
		Return
	END IF
	
	IF sModStatus = 'I' AND sGyelDate = "" OR IsNull(sGyelDate) THEN
		F_MessageChk(1,'[결제일자]')
		dw_ip.Setcolumn("baldate")
		dw_ip.SetFocus()
		Return
	END IF
	
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')
		dw_ip.Setcolumn("saupj")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF sDept = "" OR IsNull(sDept) THEN
		F_MessageChk(1,'[결제부서]')
		dw_ip.Setcolumn("deptcode")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF sSawon = "" OR IsNull(sSawon) THEN
		F_MessageChk(1,'[결제자]')
		dw_ip.Setcolumn("empno")
		dw_ip.SetFocus()
		Return -1
	END IF

	iCount = 0
	
	//처리자료 Check,결재금액 Check
	For i = 1 To dw_rtv.RowCount()
		
		IF dw_rtv.getitemstring(i,"sel") = "Y" THEN
			
			dGyelAmt = dw_rtv.getitemnumber(i,"gyel_amt")	//결제금액
			
			IF dGyelAmt = 0 THEN
				Messagebox("확인", String(i)+"행은 결제금액이 없으므로 처리할수 없습니다!")
				dw_rtv.setrow(i)
				dw_rtv.setfocus()
				Return
			END IF
			iCount++
			
		END IF
		
	Next
	
	IF iCount = 0 THEN
		Messagebox("확인", "처리할 자료가 없습니다!")
		dw_rtv.setfocus()
		Return
	END IF
	
	For i = 1 To dw_rtv.RowCount()
		
		IF dw_rtv.getitemstring(i,"sel") = "Y" THEN
			
			sSaupNo     = dw_rtv.getitemstring(i,"saup_no")			//거래처
			dGyelAmt    = dw_rtv.getitemnumber(i,"gyel_amt")		//결제금액
			dGichoAmt   = dw_rtv.getitemnumber(i,"gicho_amt")		//이전잔액
			dJunMonAmt  = dw_rtv.getitemnumber(i,"junmon_amt")		//전월잔액
			dDangMonAmt = dw_rtv.getitemnumber(i,"dangmon_amt")	//당월잔액
			
			Insert Into kfz19ot6 ( gyel_date, acc1_cd, acc2_cd, saup_no,
			                       saupj, dept_cd, sawon, jjunamt, junamt, dangamt,
										  gyelamt, cashamt, billamt, billno, bbaldate, bmandate,
                                bank_cd, bill_nm, accamt, sacc1_cd, sacc2_cd, accjunno )
			              Values ( :sGyelDate, substr(:sAccCd,1,5), substr(:sAccCd,6,2), :sSaupNo,
							           :sSaupj, :sDept, :sSawon, :dGichoAmt, :dJunMonAmt, :dDangMonAmt,
										  :dGyelAmt, 0, 0, Null, Null, Null,
										  Null, Null, 0, Null, Null, Null);
			IF SQLCA.sqlcode <> 0 THEN
				Rollback;
				Messagebox("오류", String(i)+"행 자료 저장중 오류가 발생했습니다!")
				dw_rtv.setrow(i)
				dw_rtv.setfocus()
				Return
			END IF
			
		END IF
		
	Next
	
	Commit;
	
	p_inq.triggerevent(Clicked!)
	
ELSE
	
	//금액 0인 경우 Delete
	For i = dw_rtv.rowcount() To 1 Step -1
		
		IF dw_rtv.getitemnumber(i,"gyelamt") = 0 THEN dw_rtv.deleterow(i)
	
	Next
	
	IF dw_rtv.Update() < 0 THEN
		Rollback;
		Messagebox("확인", "수정중 오류가 발생했습니다!")
		dw_rtv.setfocus()
		Return
	END IF
	
	Commit;
	
	p_inq.triggerevent(Clicked!)
	
END IF

w_mdi_frame.sle_msg.text ="저장되었습니다!"
end event

type cb_exit from w_inherite`cb_exit within w_kglc40
boolean visible = false
integer x = 2743
integer y = 2768
end type

type cb_mod from w_inherite`cb_mod within w_kglc40
boolean visible = false
integer x = 2386
integer y = 2768
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kglc40
boolean visible = false
integer x = 1006
integer y = 2580
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kglc40
boolean visible = false
integer x = 2085
integer y = 2580
end type

type cb_inq from w_inherite`cb_inq within w_kglc40
boolean visible = false
integer x = 2025
integer y = 2768
end type

type cb_print from w_inherite`cb_print within w_kglc40
boolean visible = false
integer x = 2437
integer y = 2580
end type

type st_1 from w_inherite`st_1 within w_kglc40
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kglc40
boolean visible = false
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kglc40
boolean visible = false
integer x = 3122
integer y = 2580
integer width = 334
string text = "변경(&E)"
end type

event cb_search::clicked;call super::clicked;//OPEN(W_KIFA05A)
end event

type dw_datetime from w_inherite`dw_datetime within w_kglc40
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kglc40
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kglc40
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc40
boolean visible = false
integer x = 1993
integer y = 2532
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc40
boolean visible = false
integer x = 1984
integer y = 2712
integer width = 1134
end type

type dw_ip from u_key_enter within w_kglc40
event ue_key pbm_dwnkey
integer x = 27
integer y = 148
integer width = 4521
integer height = 312
integer taborder = 10
string dataobject = "dw_kglc401"
boolean border = false
end type

event ue_key;IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  sDate,sGb,sNull,sCust,sCustName,sSaupj,sDeptCode,sBalDate,sEmpNo,sEmpName,sSdeptCode
Integer iCurRow,iCount

SetNull(sNull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "basedate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[기준일자]')
		this.SetItem(iCurRow,"basedate",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "baldate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
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

IF this.GetColumnName() = "cust" THEN
	sCust = this.GetText()
	
	this.SetItem(iCurRow, "custname", sNull)
	
	IF sCust = '' OR IsNull(sCust) THEN Return
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
		FROM "KFZ04OM0"  
		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCust) AND 
				(( "KFZ04OM0"."PERSON_GU" like '1') OR 
				( "KFZ04OM0"."PERSON_GU" = '99')) AND
				( "KFZ04OM0"."PERSON_STS" = '1');
	
	IF SQLCA.SQLCODE = 100 THEN
		Messagebox("확인", "거래처를 확인하십시오")
		this.SetItem(iCurRow, "cust",sNull)
		this.SetItem(iCurRow, "custname",sNull)
		Return 1
	END IF
	
	this.SetItem(iCurRow, "custname",sCustName)
END IF

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN Return
	
	IF IsNull(F_Get_PersonLst('3',sDeptCode,'1')) THEN
		F_MessageChk(20,'[결제부서]')
		this.SetItem(iCurRow,"deptcode",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "empno" THEN
	sEmpNo = this.GetText()
	
	this.SetItem(iCurRow,"empname",sNull)
	
	IF sEmpNo = "" OR IsNull(sEmpNo) THEN Return
	
	sEmpName = F_Get_PersonLst('4',sEmpNo,'1')
	IF IsNull(sEmpName) THEN
		F_MessageChk(20,'[결제자]')
		this.SetItem(iCurRow,"empno",sNull)
		Return 1
	END IF
	
	this.SetItem(iCurRow,"empname",sEmpName)
END IF

IF this.GetColumnName() = "sdeptcode" THEN
	sSdeptCode = this.GetText()	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN RETURN
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  INTO :sSdeptCode  
		FROM "VW_CDEPT_CODE"  
		WHERE "VW_CDEPT_CODE"."COST_CD" = :sSdeptCode;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(iCurRow,"sdeptcode",sNull)
		Return 1
	END IF
END IF
end event

event rbuttondown;String sNull

SetNull(sNull)

this.AcceptText()

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="cust" THEN
		
	lstr_custom.code = this.GetItemString(this.GetRow(),"cust")
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""

	OpenWithParm(W_KFZ04OM0_POPUP,"1")
	
	IF IsNull(lstr_custom) THEN
		this.SetItem(this.GetRow(), "cust",sNull)
		this.SetItem(this.GetRow(), "custname",sNull)
	ELSE	
		this.SetItem(this.GetRow(), "cust",lstr_custom.code)
		this.SetItem(this.GetRow(), "custname",lstr_custom.name)
	END IF
END IF
end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_kglc40
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 464
integer width = 4512
integer height = 1816
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kglc40
integer x = 41
integer y = 472
integer width = 4485
integer height = 1796
integer taborder = 30
string dataobject = "dw_kglc402"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event itemchanged;Int    iCurRow
Double dGamt,dLamt

iCurRow = this.GetRow()

IF this.GetColumnName() = "gyel_amt" THEN
	dGamt = Double(this.GetText())
	IF dGamt = 0 OR IsNull(dGamt) THEN RETURN
	
	IF dGamt < 0 THEN
		Messagebox("확인", "금액은 양수이어야 합니다!")
		this.SetItem(iCurRow,"gyel_amt",0)
		Return 1
	END IF
	
	dLamt = this.getitemnumber(iCurRow,"last_amt")
	
	IF dGamt > dLamt THEN
		Messagebox("확인", "최종잔액보다 결재금액이 큽니다!")
		this.SetItem(iCurRow,"gyel_amt",0)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "gyelamt" THEN
	dGamt = Double(this.GetText())
	IF dGamt = 0 OR IsNull(dGamt) THEN RETURN
	
	IF dGamt < 0 THEN
		Messagebox("확인", "금액은 양수이어야 합니다!")
		this.SetItem(iCurRow,"gyelamt",0)
		Return 1
	END IF
	
	dLamt = this.getitemnumber(iCurRow,"lastamt")
	
	IF dGamt > dLamt THEN
		Messagebox("확인", "최종잔액보다 결재금액이 큽니다!")
		this.SetItem(iCurRow,"gyelamt",0)
		Return 1
	END IF
END IF
end event

event itemerror;Return 1
end event

type rb_1 from radiobutton within w_kglc40
integer x = 69
integer y = 52
integer width = 215
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등록"
boolean checked = true
end type

event clicked;sModStatus = 'I'									

Wf_Init()
end event

type rb_2 from radiobutton within w_kglc40
integer x = 347
integer y = 52
integer width = 215
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수정"
end type

event clicked;sModStatus = 'M'									

Wf_Init()
end event

type rr_2 from roundrectangle within w_kglc40
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 24
integer width = 590
integer height = 116
integer cornerheight = 40
integer cornerwidth = 55
end type

