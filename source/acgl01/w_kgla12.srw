$PBExportHeader$w_kgla12.srw
$PBExportComments$계정 기초잔액 등록
forward
global type w_kgla12 from w_inherite
end type
type dw_cond from u_key_enter within w_kgla12
end type
type dw_ins from u_key_enter within w_kgla12
end type
type cb_1 from commandbutton within w_kgla12
end type
type p_1 from uo_picture within w_kgla12
end type
type rr_1 from roundrectangle within w_kgla12
end type
end forward

global type w_kgla12 from w_inherite
string title = "기초잔액 등록"
dw_cond dw_cond
dw_ins dw_ins
cb_1 cb_1
p_1 p_1
rr_1 rr_1
end type
global w_kgla12 w_kgla12

forward prototypes
public function integer wf_create_00 (string arg_saupj, string arg_year)
end prototypes

public function integer wf_create_00 (string arg_saupj, string arg_year);
/*계정별 기초잔고의 '00'월 자료 생성*/
insert into kfz14ot0
	(saupj,				acc_yy,		acc_mm,		acc1_cd,		acc2_cd,		dr_amt,		cr_amt,		jan_amt)
select :Arg_Saupj, 	:Arg_Year,	'00',			acc1_cd,		acc2_cd,		0,				0,				0
	from kfz01om0
	where acc1_cd||acc2_cd not in 
			(select acc1_cd||acc2_cd from 
				kfz14ot0 where saupj = :Arg_Saupj and acc_yy||acc_mm = :Arg_Year||'00');
if sqlca.sqlcode <> 0 then Return -1

Return 1
end function

on w_kgla12.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_ins=create dw_ins
this.cb_1=create cb_1
this.p_1=create p_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_ins
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_kgla12.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_ins)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.rr_1)
end on

event open;call super::open;
dw_cond.SetTransObject(Sqlca)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_ins.SetTransObject(Sqlca)
dw_ins.Reset()

dw_cond.SetItem(1,"saupj",  Gs_Saupj)
dw_cond.SetItem(1,"acc_yy", Left(F_Today(),4))

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_cond.Modify("saupj.protect = 1")
//	dw_cond.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_cond.Modify("saupj.protect = 0")
//	dw_cond.Modify("saupj.background.color ='"+String(RGB(190,225,184))+"'")
END IF	

dw_cond.SetColumn("acc_yy")
dw_cond.SetFocus()

ib_any_typing =False

end event

type dw_insert from w_inherite`dw_insert within w_kgla12
boolean visible = false
integer x = 128
integer y = 2684
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgla12
boolean visible = false
integer x = 3694
integer y = 2820
end type

type p_addrow from w_inherite`p_addrow within w_kgla12
boolean visible = false
integer x = 3520
integer y = 2820
end type

type p_search from w_inherite`p_search within w_kgla12
boolean visible = false
integer x = 2825
integer y = 2820
end type

type p_ins from w_inherite`p_ins within w_kgla12
boolean visible = false
integer x = 3346
integer y = 2820
end type

type p_exit from w_inherite`p_exit within w_kgla12
end type

type p_can from w_inherite`p_can within w_kgla12
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

ib_any_typing = False

dw_ins.Reset()
dw_cond.SetFocus()
end event

type p_print from w_inherite`p_print within w_kgla12
boolean visible = false
integer x = 2999
integer y = 2820
end type

type p_inq from w_inherite`p_inq within w_kgla12
integer x = 3739
end type

event p_inq::clicked;call super::clicked;String  sSaupj,sAccYear,sAccMonth

w_mdi_frame.sle_msg.text = ''

dw_cond.AcceptText()

sSaupj   = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sAccYear = dw_cond.GetItemString(dw_cond.GetRow(),"acc_yy")
sAccMonth= dw_cond.GetItemString(dw_cond.GetRow(),"acc_mm")

IF sSaupj ="" OR IsNull(sSaupj) THEN
	f_messagechk(1,"[사업장]")
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	RETURN 
END IF   
	
IF sAccYear ="" OR IsNull(sAccYear) THEN
	f_messagechk(1,"[회계년도]")
	dw_cond.SetColumn("acc_yy")
	dw_cond.SetFocus()
	RETURN 
END IF   

SetPointer(HourGlass!)
dw_ins.SetRedraw(False)
w_mdi_frame.sle_msg.text = '자료 조회 중...'
IF dw_ins.Retrieve(sSaupj,sAccYear,sAccMonth) <=0 THEN
   f_messagechk(14,"")
   dw_cond.Setfocus()
	dw_ins.SetRedraw(True)
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text = ''
	Return
END IF
dw_ins.SetRedraw(True)
SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = '자료 조회 완료'

ib_any_typing =False

end event

type p_del from w_inherite`p_del within w_kgla12
boolean visible = false
integer x = 4041
integer y = 2820
end type

type p_mod from w_inherite`p_mod within w_kgla12
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Integer i,iRowCount
String  sStatus

dw_cond.AcceptText()
IF dw_cond.GetItemString(1,"saupj") = '99' THEN
	f_messagechk(15,"") 
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return 
END IF

IF dw_ins.AcceptText() = -1 THEN Return
IF F_DbConFirm('저장') = 2 THEN Return

irowCount = dw_ins.RowCount()
SetPointer(HourGlass!)
w_mdi_frame.sle_msg.Text = '자료 저장 중...'

FOR i = 1 TO iRowCount
//	IF dw_ins.GetItemString(i,"kfz01om0_bal_gu") = '4' THEN
//		dw_ins.SetItemStatus(i, 0, Primary!, NotModified!)
//	ELSE
		IF dw_ins.GetItemString(i,"status") = 'M' THEN
			dw_ins.SetItemStatus(i, 0, Primary!, DataModified!)
		ELSE
			dw_ins.SetItemStatus(i, 0, Primary!, NewModified!)
		END IF
//	END IF
NEXT

IF dw_ins.Update() <> 1 Then
   f_messagechk(13,"") 
   dw_ins.SetFocus()
   Rollback;
	Return
END IF
Commit;

if dw_cond.GetItemString(1,"acc_mm") = '00' then							/*00월 자료 생성-40000이상*/
	if Wf_Create_00(dw_cond.GetItemString(1,"saupj"),dw_cond.GetItemString(1,"acc_yy")) = -1 then 
	   f_messagechk(13,'[00월 자료 생성]') 
		Rollback;
		Return
	else
		Commit;
	end if
end if

IF MessageBox('확 인','상위집계를 하시겠습니까?',Question!,YesNo!) = 1 THEN
	p_1.TriggerEvent(Clicked!)
ELSE
	p_inq.TriggerEvent(Clicked!)
END IF

SetPointer(Arrow!)
w_mdi_frame.sle_msg.Text = '자료 저장 완료'

end event

type cb_exit from w_inherite`cb_exit within w_kgla12
boolean visible = false
integer x = 3232
integer y = 2644
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_kgla12
boolean visible = false
integer x = 2523
integer y = 2644
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;Integer i,iRowCount
String  sStatus

dw_cond.AcceptText()
IF dw_cond.GetItemString(1,"saupj") = '99' THEN
	f_messagechk(15,"") 
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return 
END IF

IF dw_ins.AcceptText() = -1 THEN Return
IF F_DbConFirm('저장') = 2 THEN Return

irowCount = dw_ins.RowCount()
SetPointer(HourGlass!)
sle_msg.Text = '자료 저장 중...'

FOR i = 1 TO iRowCount
//	IF dw_ins.GetItemString(i,"kfz01om0_bal_gu") = '4' THEN
//		dw_ins.SetItemStatus(i, 0, Primary!, NotModified!)
//	ELSE
		IF dw_ins.GetItemString(i,"status") = 'M' THEN
			dw_ins.SetItemStatus(i, 0, Primary!, DataModified!)
		ELSE
			dw_ins.SetItemStatus(i, 0, Primary!, NewModified!)
		END IF
//	END IF
NEXT

IF dw_ins.Update() <> 1 Then
   f_messagechk(13,"") 
   dw_ins.SetFocus()
   Rollback;
	Return
END IF
Commit;

if dw_cond.GetItemString(1,"acc_mm") = '00' then							/*00월 자료 생성-40000이상*/
	if Wf_Create_00(dw_cond.GetItemString(1,"saupj"),dw_cond.GetItemString(1,"acc_yy")) = -1 then 
	   f_messagechk(13,'[00월 자료 생성]') 
		Rollback;
		Return
	else
		Commit;
	end if
end if

IF MessageBox('확 인','상위집계를 하시겠습니까?',Question!,YesNo!) = 1 THEN
	cb_1.TriggerEvent(Clicked!)
ELSE
	cb_inq.TriggerEvent(Clicked!)
END IF

SetPointer(Arrow!)
sle_msg.Text = '자료 저장 완료'

end event

type cb_ins from w_inherite`cb_ins within w_kgla12
boolean visible = false
integer x = 818
integer y = 2520
end type

type cb_del from w_inherite`cb_del within w_kgla12
boolean visible = false
integer x = 1175
integer y = 2516
end type

type cb_inq from w_inherite`cb_inq within w_kgla12
boolean visible = false
integer x = 603
integer y = 2716
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String  sSaupj,sAccYear,sAccMonth

sle_msg.text = ''

dw_cond.AcceptText()

sSaupj   = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sAccYear = dw_cond.GetItemString(dw_cond.GetRow(),"acc_yy")
sAccMonth= dw_cond.GetItemString(dw_cond.GetRow(),"acc_mm")

IF sSaupj ="" OR IsNull(sSaupj) THEN
	f_messagechk(1,"[사업장]")
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	RETURN 
END IF   
	
IF sAccYear ="" OR IsNull(sAccYear) THEN
	f_messagechk(1,"[회계년도]")
	dw_cond.SetColumn("acc_yy")
	dw_cond.SetFocus()
	RETURN 
END IF   

SetPointer(HourGlass!)
dw_ins.SetRedraw(False)
sle_msg.text = '자료 조회 중...'
IF dw_ins.Retrieve(sSaupj,sAccYear,sAccMonth) <=0 THEN
   f_messagechk(14,"")
   dw_cond.Setfocus()
	dw_ins.SetRedraw(True)
	SetPointer(Arrow!)
	sle_msg.text = ''
	Return
END IF
dw_ins.SetRedraw(True)
SetPointer(Arrow!)
sle_msg.text = '자료 조회 완료'

ib_any_typing =False

end event

type cb_print from w_inherite`cb_print within w_kgla12
integer x = 2025
integer y = 2520
end type

type st_1 from w_inherite`st_1 within w_kgla12
end type

type cb_can from w_inherite`cb_can within w_kgla12
boolean visible = false
integer x = 2885
integer y = 2644
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;
sle_msg.text = ''

ib_any_typing = False

dw_ins.Reset()
dw_cond.SetFocus()
end event

type cb_search from w_inherite`cb_search within w_kgla12
integer x = 1527
integer y = 2516
end type







type gb_button1 from w_inherite`gb_button1 within w_kgla12
boolean visible = false
integer x = 567
integer y = 2660
integer width = 407
end type

type gb_button2 from w_inherite`gb_button2 within w_kgla12
boolean visible = false
integer x = 2487
integer y = 2588
integer width = 1120
end type

type dw_cond from u_key_enter within w_kgla12
integer x = 64
integer y = 20
integer width = 2107
integer height = 144
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgla121"
boolean border = false
end type

event itemchanged;String snull,sSaupj

SetNull(snull)

IF this.GetColumnName() ="saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	IF IsNull(f_get_refferance('AD',sSaupj)) THEN
	  	f_messagechk(20,"사업장")
		this.SetItem(1,"saupj",snull)
		Return 1
	END IF
END IF

dw_ins.Reset()

end event

event itemerror;Return 1
end event

event editchanged;w_mdi_frame.sle_msg.text = ''
end event

type dw_ins from u_key_enter within w_kgla12
integer x = 59
integer y = 196
integer width = 4485
integer height = 2032
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kgla122"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event retrieverow;
IF row > 0 THEN
	this.SetItem(row,"kfz14ot0_saupj",   dw_cond.GetItemString(1,"saupj"))
	this.SetItem(row,"kfz14ot0_acc_yy",  dw_cond.GetItemString(1,"acc_yy"))
	this.SetItem(row,"kfz14ot0_acc_mm",  dw_cond.GetItemString(1,"acc_mm"))
	
	this.SetItem(row,"kfz14ot0_acc1_cd", this.GetItemString(row,"kfz01om0_acc1_cd"))
	this.SetItem(row,"kfz14ot0_acc2_cd", this.GetItemString(row,"kfz01om0_acc2_cd"))
END IF
end event

event editchanged;sle_msg.text = ''
ib_any_typing = True
end event

event itemerror;Return 1
end event

event itemchanged;Double  dDrAmt,dCrAmt,dJanAmt
String  sDcrGbn

IF this.GetColumnName() = "kfz14ot0_dr_amt" THEN
	dDrAmt = Double(this.GetText())
	
	IF IsNull(dDrAmt) THEN Return 1	
	
	dCrAmt = this.GetItemNumber(this.GetRow(),"kfz14ot0_cr_amt")
	IF IsNull(dCrAmt) THEN dCrAmt = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"kfz01om0_dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJanAmt = dDrAmt - dCrAmt
	ELSE
		dJanAmt = dCrAmt - dDrAmt
	END IF
	
	this.SetItem(this.GetRow(),"kfz14ot0_jan_amt",dJanAmt)
END IF

IF this.GetColumnName() = "kfz14ot0_cr_amt" THEN
	dCrAmt = Double(this.GetText())
	IF IsNull(dCrAmt) THEN Return 1	
	
	dDrAmt = this.GetItemNumber(this.GetRow(),"kfz14ot0_dr_amt")
	IF IsNull(dDrAmt) THEN dDrAmt = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"kfz01om0_dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJanAmt = dDrAmt - dCrAmt
	ELSE
		dJanAmt = dCrAmt - dDrAmt
	END IF
	
	this.SetItem(this.GetRow(),"kfz14ot0_jan_amt",dJanAmt)
END IF

end event

event buttonclicked;s_JanGo  IStr_JanGo
Double   ddr,dcr,djan
Integer  iCount

IF dwo.name = "dcb_cust" THEN
	Istr_JanGo.saupj    = dw_cond.GetItemString(1,"saupj")
	Istr_janGo.acc_yy   = dw_cond.GetItemString(1,"acc_yy")
	Istr_janGo.acc_mm   = dw_cond.GetItemString(1,"acc_mm")
	Istr_janGo.acc1_cd  = this.GetItemString(row,"kfz01om0_acc1_cd")
	Istr_janGo.acc2_cd  = this.GetItemString(row,"kfz01om0_acc2_cd")
	Istr_janGo.remark4  = this.GetItemString(row,"kfz01om0_remark4")
	
	OpenWithParm(w_kgla12a,Istr_JanGo)
	
	select Count(*), sum(nvl(dr_amt,0)),	sum(nvl(cr_amt,0)),	sum(nvl(jan_amt,0))	
		into :iCount, :dDr,						:dCr,						:dJan
		from kfz13ot0
		where saupj   = :Istr_JanGo.saupj and acc_yy = :Istr_JanGo.acc_yy and acc_mm = :Istr_JanGo.acc_mm and
				acc1_cd = :Istr_JanGo.acc1_cd and acc2_cd = :Istr_JanGo.acc2_cd ;
	if sqlca.sqlcode <> 0 then
		iCount = 0
	else
		if IsNull(iCount) then iCount = 0
	end if
	
	if iCount > 0 then
		this.SetItem(Row,"kfz14ot0_dr_amt",  dDr)
		this.SetItem(Row,"kfz14ot0_cr_amt",  dCr)
		this.SetItem(Row,"kfz14ot0_jan_amt", dJan)
		
		ib_any_typing = True
	end if
	
END IF
end event

type cb_1 from commandbutton within w_kgla12
boolean visible = false
integer x = 1609
integer y = 2772
integer width = 498
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "상위집계(&U)"
end type

event clicked;String sSaupj,sAccYear,sAccMonth

IF dw_ins.RowCount() <=0 THEN Return

dw_cond.AcceptText()     
sSaupj    = dw_cond.GetItemString(1,  "saupj")
sAccYear  = dw_cond.GetItemString(1,  "acc_yy")
sAccMonth = dw_cond.GetItemString(1,  "acc_mm")

IF sSaupj = '99' THEN
	f_messagechk(15,"") 
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return 
END IF
/*계정 잔고를 상위계정으로 집계함,거래처 잔고를 상위계정으로 집계함*/
/*계정 잔고를 전사('99')로 생성함,거래처 잔고를 전사('99')로 생성함*/
SetPointer(HourGlass!)
sle_msg.text = "상위 집계 중..." 
f_acc_sum(sAccYear+sAccMonth,sAccYear+sAccMonth)

cb_inq.TriggerEvent(clicked!)

sle_msg.text = "상위계정 집계가 완료되었습니다!" 
SetPointer(Arrow!)

ib_any_typing =False
end event

type p_1 from uo_picture within w_kgla12
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondn pbm_lbuttondown
integer x = 3918
integer y = 24
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Erpman\image\상위집계_up.gif"
end type

event ue_lbuttonup;PictureName = "C:\Erpman\image\상위집계_up.gif"
end event

event ue_lbuttondn;PictureName = "C:\Erpman\image\상위집계_dn.gif"
end event

event clicked;call super::clicked;String sSaupj,sAccYear,sAccMonth

IF dw_ins.RowCount() <=0 THEN Return

dw_cond.AcceptText()     
sSaupj    = dw_cond.GetItemString(1,  "saupj")
sAccYear  = dw_cond.GetItemString(1,  "acc_yy")
sAccMonth = dw_cond.GetItemString(1,  "acc_mm")

IF sSaupj = '99' THEN
	f_messagechk(15,"") 
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return 
END IF
/*계정 잔고를 상위계정으로 집계함,거래처 잔고를 상위계정으로 집계함*/
/*계정 잔고를 전사('99')로 생성함,거래처 잔고를 전사('99')로 생성함*/
SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "상위 집계 중..." 
f_acc_sum(sAccYear+sAccMonth,sAccYear+sAccMonth)

p_inq.TriggerEvent(clicked!)

w_mdi_frame.sle_msg.text = "상위계정 집계가 완료되었습니다!" 
SetPointer(Arrow!)

ib_any_typing =False
end event

type rr_1 from roundrectangle within w_kgla12
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 192
integer width = 4553
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 46
end type

