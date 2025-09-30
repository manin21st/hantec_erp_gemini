$PBExportHeader$w_kfia21.srw
$PBExportComments$일자금수지금액 수정
forward
global type w_kfia21 from w_inherite
end type
type gb_4 from groupbox within w_kfia21
end type
type gb_3 from groupbox within w_kfia21
end type
type gb_2 from groupbox within w_kfia21
end type
type dw_update from datawindow within w_kfia21
end type
type cbx_1 from checkbox within w_kfia21
end type
type cbx_2 from checkbox within w_kfia21
end type
type rb_auto from radiobutton within w_kfia21
end type
type rb_up from radiobutton within w_kfia21
end type
type rb_acc from radiobutton within w_kfia21
end type
type rb_total from radiobutton within w_kfia21
end type
type cb_2 from commandbutton within w_kfia21
end type
type dw_cond from u_key_enter within w_kfia21
end type
type rr_1 from roundrectangle within w_kfia21
end type
end forward

global type w_kfia21 from w_inherite
string title = "일자금수지금액 수정"
gb_4 gb_4
gb_3 gb_3
gb_2 gb_2
dw_update dw_update
cbx_1 cbx_1
cbx_2 cbx_2
rb_auto rb_auto
rb_up rb_up
rb_acc rb_acc
rb_total rb_total
cb_2 cb_2
dw_cond dw_cond
rr_1 rr_1
end type
global w_kfia21 w_kfia21

forward prototypes
public function integer wf_requiredchk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);
String sdate,scode

sdate = dw_update.GetItemString(ll_row,"finance_date")
scode = dw_update.GetItemString(ll_row,"finance_cd")

IF sdate ="" OR IsNull(sdate) THEN
	Messagebox("확 인","자금수지일자를 입력하세요!!")
	dw_update.SetColumn("finance_date")
	dw_update.SetFocus()
	Return -1
END IF

IF scode ="" OR IsNull(scode) THEN
	Messagebox("확 인","자금수지코드를 입력하세요!!")
	dw_update.SetColumn("finance_cd")
	dw_update.SetFocus()
	Return -1
END IF

Return 1
end function

on w_kfia21.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_update=create dw_update
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.rb_auto=create rb_auto
this.rb_up=create rb_up
this.rb_acc=create rb_acc
this.rb_total=create rb_total
this.cb_2=create cb_2
this.dw_cond=create dw_cond
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_update
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.cbx_2
this.Control[iCurrent+7]=this.rb_auto
this.Control[iCurrent+8]=this.rb_up
this.Control[iCurrent+9]=this.rb_acc
this.Control[iCurrent+10]=this.rb_total
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.dw_cond
this.Control[iCurrent+13]=this.rr_1
end on

on w_kfia21.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_update)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.rb_auto)
destroy(this.rb_up)
destroy(this.rb_acc)
destroy(this.rb_total)
destroy(this.cb_2)
destroy(this.dw_cond)
destroy(this.rr_1)
end on

event open;call super::open;
dw_cond.SetTransObject(Sqlca)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetItem(1,"fromdate",Left(F_Today(),6)+'01')
dw_cond.SetItem(1,"todate",  F_Today())
dw_cond.SetFocus()

dw_update.SetTransObject(SQLCA)
dw_update.Reset()


end event

type dw_insert from w_inherite`dw_insert within w_kfia21
boolean visible = false
integer x = 818
integer y = 2996
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia21
boolean visible = false
integer x = 3090
integer y = 3076
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia21
boolean visible = false
integer x = 2917
integer y = 3076
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia21
integer x = 3401
integer taborder = 80
boolean originalsize = true
string picturename = "C:\erpman\image\일집계_up.gif"
end type

event p_search::clicked;String sdate_fr,sdate_to

w_mdi_frame.sle_msg.text =""

dw_cond.AcceptText()
sdate_fr = Trim(dw_cond.GetItemString(1,"fromdate"))
sdate_to = Trim(dw_cond.GetItemString(1,"todate"))

OpenWithParm(w_kfia21a,sDate_Fr+sDate_To)

p_inq.TriggerEvent(Clicked!)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\일집계_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\일집계_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kfia21
integer x = 3749
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

w_mdi_frame.sle_msg.text =""

IF dw_update.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredchk(dw_update.GetRow())
	
	il_currow = dw_update.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_update.InsertRow(il_currow)
	
	dw_update.ScrollToRow(il_currow)
	dw_update.SetColumn("finance_date")
	dw_update.SetFocus()
	
END IF

end event

type p_exit from w_inherite`p_exit within w_kfia21
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_kfia21
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_update.Reset()

dw_cond.SetFocus()

ib_any_typing =False
end event

type p_print from w_inherite`p_print within w_kfia21
boolean visible = false
integer x = 2395
integer y = 3076
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia21
integer x = 3575
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sdate_fr,sdate_to,sAutoFlag

w_mdi_frame.sle_msg.text =""

dw_cond.AcceptText()
sdate_fr = Trim(dw_cond.GetItemString(1,"fromdate"))
sdate_to = Trim(dw_cond.GetItemString(1,"todate"))

IF sDate_Fr = "" OR IsNull(sDate_Fr) THEN
	F_MessageChk(1,'[자금수지일자]')	
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	Return
END IF
IF sDate_To = "" OR IsNull(sDate_To) THEN
	F_MessageChk(1,'[자금수지일자]')	
	dw_cond.SetColumn("todate")
	dw_cond.SetFocus()
	Return
END IF

IF rb_auto.Checked = True THEN
	sAutoFlag = 'Y'
END IF

IF rb_up.Checked = True THEN
	sAutoFlag = 'C'
END IF
IF rb_acc.Checked = True THEN
	sAutoFlag = 'N'
END IF
IF rb_total.Checked = True THEN
	sAutoFlag = '%'
END IF

dw_update.SetRedraw(False)
dw_update.SetFilTer("auto_cd like '"+sAutoFlag + "'")
dw_update.Filter()
dw_update.setredraw(True)

IF dw_update.Retrieve(sdate_fr,sdate_to) <=0 THEN
	F_MessageChk(14,'')
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	Return
END IF

w_mdi_frame.sle_msg.text ="자료를 조회하였습니다!!"
end event

type p_del from w_inherite`p_del within w_kfia21
end type

event p_del::clicked;call super::clicked;Int il_currow

w_mdi_frame.sle_msg.text =""

il_currow = dw_update.GetRow()

IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_update.DeleteRow(il_currow)

IF dw_update.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_update.ScrollToRow(il_currow - 1)
		dw_update.SetColumn("finance_date")
		dw_update.SetFocus()
	END IF
	ib_any_typing =False
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite`p_mod within w_kfia21
end type

event p_mod::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

IF dw_update.Accepttext() = -1 THEN 	RETURN

IF dw_update.RowCount() > 0 THEN
	IF wf_requiredchk(dw_update.GetRow()) = -1 THEN RETURN
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	
IF dw_update.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

dw_update.Setfocus()
		

end event

type cb_exit from w_inherite`cb_exit within w_kfia21
boolean visible = false
integer x = 3506
integer y = 3084
integer width = 283
integer height = 104
end type

type cb_mod from w_inherite`cb_mod within w_kfia21
boolean visible = false
integer x = 1765
integer y = 3104
integer width = 283
integer height = 104
end type

type cb_ins from w_inherite`cb_ins within w_kfia21
boolean visible = false
integer x = 1079
integer y = 3112
integer width = 274
integer height = 104
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_kfia21
boolean visible = false
integer x = 2062
integer y = 3104
integer width = 283
integer height = 104
end type

type cb_inq from w_inherite`cb_inq within w_kfia21
boolean visible = false
integer x = 791
integer y = 3116
integer width = 274
integer height = 104
end type

type cb_print from w_inherite`cb_print within w_kfia21
boolean visible = false
integer x = 2199
integer y = 2484
integer height = 104
end type

type st_1 from w_inherite`st_1 within w_kfia21
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfia21
boolean visible = false
integer x = 2359
integer y = 3104
integer width = 283
integer height = 104
end type

type cb_search from w_inherite`cb_search within w_kfia21
boolean visible = false
integer x = 1358
integer y = 3108
integer width = 393
integer height = 104
string text = "일집계(U)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia21
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfia21
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfia21
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia21
boolean visible = false
integer x = 110
integer y = 1876
integer width = 910
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia21
boolean visible = false
integer x = 3337
integer y = 3016
integer width = 1225
end type

type gb_4 from groupbox within w_kfia21
integer x = 1486
integer width = 1157
integer height = 184
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "자료구분"
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_kfia21
boolean visible = false
integer x = 1102
integer y = 1876
integer width = 1134
integer height = 192
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

type gb_2 from groupbox within w_kfia21
integer x = 2679
integer width = 695
integer height = 180
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type dw_update from datawindow within w_kfia21
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 91
integer y = 196
integer width = 4507
integer height = 2036
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_kfia21_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event rowfocuschanged;this.SetRowFocusIndicator(Hand!)
end event

event editchanged;ib_any_typing =True
end event

event rbuttondown;
SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

IF this.GetColumnName() ="finance_cd" THEN
	gs_code = this.getitemstring(this.getrow(), "finance_cd")
	
	if gs_code = "" or isnull(gs_code) then
		gs_code = ""
	end if
	
	OpenWithParm(W_KFM10OM0_POPUP,'N')

	IF IsNull(gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"finance_cd",gs_code)
	this.SetItem(this.GetRow(),"kfm10om0_finance_name",gs_codename)
	
//	this.TriggerEvent(ItemChanged!)
END IF
end event

event itemchanged;String snull,scode,sname,sauto_gubun,sdate
Int    lReturnRow,lRow

SetNull(snull)

lRow = this.GetRow()
IF this.GetColumnName() = "finance_date" THEN
	scode = Trim(this.GetText())
	IF sCode = "" OR isNull(sCode) THEN Return
	
	IF f_datechk(scode) = -1 THEN
		MessageBox("확 인","날짜를 확인하십시요!!")
		this.SetItem(lRow,"finance_date",snull)
		Return 1
	END IF
	
END IF

IF this.GetColumnName() = "finance_cd"THEN
	
	scode = this.GetText()
	
	SELECT "FINANCE_NAME","AUTO_CD" INTO :sname, :sauto_gubun
		FROM "KFM10OM0"
		WHERE "KFM10OM0"."FINANCE_CD" = :scode ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[자금수지코드]')
		this.SetItem(lRow,"finance_cd",snull)
		this.SetItem(lRow,"kfm10om0_finance_name",snull)
		Return 1
	ELSE
		IF sauto_gubun = 'Y' THEN
			MessageBox("확 인","입력하신 자금수지코드는 '자동계산'하는 항목입니다!!")
			this.SetItem(lRow,"finance_cd",snull)
			this.SetItem(lRow,"kfm10om0_finance_name",snull)
			Return 1
		END IF
		this.SetItem(lRow,"kfm10om0_finance_name",sname)
	END IF
	
	sdate = THIS.GetItemString(lRow,"finance_date")					
	
	lReturnRow = This.Find("finance_date = '"+sdate+"'"+"and finance_cd = '"+scode + "' ", 1, This.RowCount())
	
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		MessageBox("확인","등록된 자금수지일자와 자금수지코드 입니다.~r등록할 수 없습니다.")
		this.SetItem(lRow,"finance_cd",snull)
		this.SetItem(lRow,"kfm10om0_finance_name",snull)
		RETURN  1
		
	END IF
	
END IF
ib_any_typing =True
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

type cbx_1 from checkbox within w_kfia21
integer x = 2702
integer y = 32
integer width = 649
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "일자금수지 조회 출력"
end type

event clicked;OpenSheet(w_kfia25,w_mdi_frame,2,Layered!)
cbx_1.Checked =False
end event

type cbx_2 from checkbox within w_kfia21
integer x = 2702
integer y = 92
integer width = 649
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "월자금수지 조회 출력"
end type

event clicked;OpenSheet(w_kfia26,w_mdi_frame,2,Layered!)

cbx_2.Checked =False
end event

type rb_auto from radiobutton within w_kfia21
integer x = 1504
integer y = 72
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "자동계산"
borderstyle borderstyle = stylelowered!
end type

event clicked;
cb_inq.TriggerEvent(Clicked!)
end event

type rb_up from radiobutton within w_kfia21
integer x = 1819
integer y = 72
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "상위집계"
borderstyle borderstyle = stylelowered!
end type

event clicked;cb_inq.TriggerEvent(Clicked!)
end event

type rb_acc from radiobutton within w_kfia21
integer x = 2126
integer y = 72
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "계정연결"
borderstyle borderstyle = stylelowered!
end type

event clicked;cb_inq.TriggerEvent(Clicked!)
end event

type rb_total from radiobutton within w_kfia21
integer x = 2432
integer y = 72
integer width = 201
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;cb_inq.TriggerEvent(Clicked!)
end event

type cb_2 from commandbutton within w_kfia21
boolean visible = false
integer x = 1719
integer y = 3108
integer width = 654
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "월자금소요 적용(&W)"
end type

event clicked;//String  sdate_fr,sdate_to,sAutoFlag ='N', sReadDate,sReadFinCd,sFinName
//Integer iBefCnt,k,iFindRow,iCurRow
//Double  dReadAmt,dBefAmt
//
//sle_msg.text =""
//
//dw_cond.AcceptText()
//sdate_fr = Trim(dw_cond.GetItemString(1,"fromdate"))
//sdate_to = Trim(dw_cond.GetItemString(1,"todate"))
//
//IF sDate_Fr = "" OR IsNull(sDate_Fr) THEN
//	F_MessageChk(1,'[자금수지일자]')	
//	dw_cond.SetColumn("fromdate")
//	dw_cond.SetFocus()
//	Return
//END IF
//IF sDate_To = "" OR IsNull(sDate_To) THEN
//	F_MessageChk(1,'[자금수지일자]')	
//	dw_cond.SetColumn("todate")
//	dw_cond.SetFocus()
//	Return
//END IF
//
//dw_update.SetRedraw(False)
//dw_update.SetFilTer("auto_cd like '"+sAutoFlag + "'")
//dw_update.Filter()
//dw_update.setredraw(True)
//
//iBefCnt = dw_update.Retrieve(sdate_fr,sdate_to) 		/*이전자료*/
//IF iBefCnt > 0 THEN
//	IF MessageBox("확 인","이미 입력된 자금수지 자료가 존재합니다"+"~n"+&
//								 "기존 자료를 삭제 후 다시 생성하시겠습니까?",Question!,YesNo!) = 1 THEN
//		FOR k = iBefCnt TO 1 STEP -1
//			dw_update.DeleteRow(k)
//		NEXT
//		IF dw_update.Update() <> 1 THEN
//			F_MessageChk(12,'')
//			Rollback;
//			Return
//		END IF
//		Commit;
//		iBefCnt = 0
//	END IF	
//END IF
//
//DECLARE Cur_Kfm14ot0 CURSOR FOR  
//	SELECT "KFM14OT0"."ACC_YM"||Ltrim(to_char(to_number("KFM14OT0"."PLAN_DAY"),'00')),   
//          "KFM14OT0"."FINANCE_CD",   
//          SUM(NVL("KFM14OT0"."FAMT",0))  
//   FROM "KFM14OT0"  
//   WHERE ( "KFM14OT0"."ACC_YM"||Ltrim(to_char(to_number("KFM14OT0"."PLAN_DAY"),'00')) >= :sdate_fr ) AND  
//         ( "KFM14OT0"."ACC_YM"||Ltrim(to_char(to_number("KFM14OT0"."PLAN_DAY"),'00')) <= :sdate_to ) AND
//			( nvl("KFM14OT0"."CONFIRM",'N') = 'Y')
//	GROUP BY "KFM14OT0"."ACC_YM"||Ltrim(to_char(to_number("KFM14OT0"."PLAN_DAY"),'00')),   
//            "KFM14OT0"."FINANCE_CD";
//
//OPEN Cur_Kfm14ot0;
//DO WHILE TRUE
//	FETCH Cur_Kfm14ot0 INTO :sReadDate,		:sReadFinCd,	:dReadAmt;
//	IF SQLCA.SQLCODE <> 0 THEN EXIT
//	
//	IF IsNull(dReadAmt) THEN dReadAmt = 0
//	
//	SELECT "FINANCE_NAME"			 INTO :sFinName
//		FROM "KFM10OM0"
//		WHERE "KFM10OM0"."FINANCE_CD" = :sReadFinCd ;
//		
//	iFindRow = dw_update.Find("finance_date ='" + sReadDate + "' and finance_cd ='" + sReadFinCd +"'",1,iBefCnt)
//	IF iFindRow > 0 THEN		
//		dBefAmt = dw_update.GetItemNumber(iFindRow,"plan_amt")
//		IF IsNull(dBefAmt) THEN dBefAmt = 0
//
//		iCurRow = iFindRow
//	ELSE
//		iCurRow = dw_update.InsertRow(0)
//		
//		dw_update.SetItem(iCurRow,"finance_date", sReadDate)
//		dw_update.SetItem(iCurRow,"finance_cd",   sReadFinCd)
//		dw_update.SetItem(iCurRow,"kfm10om0_finance_name",   sFinName)		
//		dBefAmt = 0
//	END IF
//	
//	dw_update.SetItem(iCurRow,"plan_amt",dBefAmt + dReadAmt)
//LOOP
//CLOSE Cur_Kfm14ot0;
//
//
end event

type dw_cond from u_key_enter within w_kfia21
integer x = 59
integer y = 28
integer width = 1166
integer height = 144
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfia21_0"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia21
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 188
integer width = 4535
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

