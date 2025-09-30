$PBExportHeader$w_kgla15.srw
$PBExportComments$원가부문별 계정잔액 등록
forward
global type w_kgla15 from w_inherite
end type
type dw_cond from u_key_enter within w_kgla15
end type
type dw_ins from u_key_enter within w_kgla15
end type
type cb_1 from commandbutton within w_kgla15
end type
type p_1 from uo_picture within w_kgla15
end type
type dw_list from datawindow within w_kgla15
end type
type rr_1 from roundrectangle within w_kgla15
end type
type rr_2 from roundrectangle within w_kgla15
end type
end forward

global type w_kgla15 from w_inherite
string title = "원가부문별 계정잔액 등록"
dw_cond dw_cond
dw_ins dw_ins
cb_1 cb_1
p_1 p_1
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
end type
global w_kgla15 w_kgla15

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

on w_kgla15.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_ins=create dw_ins
this.cb_1=create cb_1
this.p_1=create p_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_ins
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_kgla15.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_ins)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_cond.SetTransObject(Sqlca)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_ins.SetTransObject(Sqlca)
dw_ins.Reset()

dw_list.SetTransObject(Sqlca)

dw_cond.SetItem(1,"acc_yy", Left(F_Today(),4))
dw_cond.SetItem(1,"acc_mm", Mid(F_Today(),5,2))

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_cond.Modify("saupj.protect = 1")
ELSE
	dw_cond.Modify("saupj.protect = 0")
END IF	

dw_cond.SetColumn("acc_yy")
dw_cond.SetFocus()

ib_any_typing =False

end event

type dw_insert from w_inherite`dw_insert within w_kgla15
boolean visible = false
integer x = 128
integer y = 2684
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgla15
boolean visible = false
integer x = 3694
integer y = 2820
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kgla15
boolean visible = false
integer x = 3520
integer y = 2820
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kgla15
boolean visible = false
integer x = 2825
integer y = 2820
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kgla15
boolean visible = false
integer x = 3346
integer y = 2820
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kgla15
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kgla15
integer taborder = 60
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

ib_any_typing = False

dw_ins.Reset()
dw_cond.SetFocus()

dw_list.Reset()
end event

type p_print from w_inherite`p_print within w_kgla15
boolean visible = false
integer x = 2999
integer y = 2820
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kgla15
integer x = 3922
integer taborder = 20
end type

event p_inq::clicked;String  sSaup,sAccYear,sAccMonth

w_mdi_frame.sle_msg.text = ''

dw_cond.AcceptText()

sSaup   = dw_cond.GetItemString(dw_cond.GetRow(),"saup_dept")
sAccYear = dw_cond.GetItemString(dw_cond.GetRow(),"acc_yy")
sAccMonth= dw_cond.GetItemString(dw_cond.GetRow(),"acc_mm")

IF sSaup ="" OR IsNull(sSaup) THEN
	f_messagechk(1,"[원가부문]")
	dw_cond.SetColumn("saup_dept")
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
IF dw_ins.Retrieve(sSaup,sAccYear,sAccMonth) <=0 THEN
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

dw_list.Reset()

ib_any_typing =False

end event

type p_del from w_inherite`p_del within w_kgla15
boolean visible = false
integer x = 4041
integer y = 2820
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kgla15
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Integer i,iRowCount
String  sStatus

dw_cond.AcceptText()
IF dw_ins.AcceptText() = -1 THEN Return
IF F_DbConFirm('저장') = 2 THEN Return

irowCount = dw_ins.RowCount()
SetPointer(HourGlass!)
w_mdi_frame.sle_msg.Text = '자료 저장 중...'

FOR i = 1 TO iRowCount
	IF dw_ins.GetItemString(i,"status") = 'M' THEN
		dw_ins.SetItemStatus(i, 0, Primary!, DataModified!)
	ELSE
		dw_ins.SetItemStatus(i, 0, Primary!, NewModified!)
	END IF
NEXT

IF dw_ins.Update() <> 1 Then
   f_messagechk(13,"") 
   dw_ins.SetFocus()
   Rollback;
	Return
END IF
Commit;

dw_list.Retrieve(dw_cond.GetItemString(1,"saup_dept"),&
					  dw_cond.GetItemString(1,"acc_yy"),&
					  dw_ins.GetItemString(dw_ins.GetRow(),"kfz01om0_acc1_cd"),&
					  dw_ins.GetItemString(dw_ins.GetRow(),"kfz01om0_acc2_cd"))	

SetPointer(Arrow!)
w_mdi_frame.sle_msg.Text = '자료 저장 완료'

end event

type cb_exit from w_inherite`cb_exit within w_kgla15
boolean visible = false
integer x = 3232
integer y = 2644
end type

type cb_mod from w_inherite`cb_mod within w_kgla15
boolean visible = false
integer x = 2523
integer y = 2644
end type

type cb_ins from w_inherite`cb_ins within w_kgla15
boolean visible = false
integer x = 818
integer y = 2520
end type

type cb_del from w_inherite`cb_del within w_kgla15
boolean visible = false
integer x = 1175
integer y = 2516
end type

type cb_inq from w_inherite`cb_inq within w_kgla15
boolean visible = false
integer x = 603
integer y = 2716
end type

type cb_print from w_inherite`cb_print within w_kgla15
integer x = 2025
integer y = 2520
end type

type st_1 from w_inherite`st_1 within w_kgla15
end type

type cb_can from w_inherite`cb_can within w_kgla15
boolean visible = false
integer x = 2885
integer y = 2644
end type

type cb_search from w_inherite`cb_search within w_kgla15
integer x = 1527
integer y = 2516
end type







type gb_button1 from w_inherite`gb_button1 within w_kgla15
boolean visible = false
integer x = 567
integer y = 2660
integer width = 407
end type

type gb_button2 from w_inherite`gb_button2 within w_kgla15
boolean visible = false
integer x = 2487
integer y = 2588
integer width = 1120
end type

type dw_cond from u_key_enter within w_kgla15
integer x = 59
integer y = 16
integer width = 1934
integer height = 132
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgla151"
boolean border = false
end type

event itemchanged;String snull,sMonth,sYear

SetNull(snull)

IF this.GetColumnName() ="acc_mm" THEN
	sMonth = this.GetText()
	IF sMonth = "" OR IsNull(sMonth) THEN Return
	
	sYear = this.GetItemString(1,"acc_yy")
	if sYear = '' or IsNull(sYear) then sYear = '0000'
	
	IF F_DateChk(sYear+sMonth+'01') = -1 THEN
	  	f_messagechk(22,"")
		this.SetItem(1,"acc_mm",snull)
		Return 1
	END IF
END IF

dw_ins.Reset()

end event

event itemerror;Return 1
end event

event editchanged;w_mdi_frame.sle_msg.text = ''
end event

type dw_ins from u_key_enter within w_kgla15
integer x = 50
integer y = 196
integer width = 3072
integer height = 2012
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kgla152"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event retrieverow;
IF row > 0 THEN
	this.SetItem(row,"kfz14ot1_saup_dept",   	dw_cond.GetItemString(1,"saup_dept"))
	this.SetItem(row,"kfz14ot1_acc_yy",  		dw_cond.GetItemString(1,"acc_yy"))
	this.SetItem(row,"kfz14ot1_acc_mm",  		dw_cond.GetItemString(1,"acc_mm"))
	
	this.SetItem(row,"kfz14ot1_acc1_cd", 		this.GetItemString(row,"kfz01om0_acc1_cd"))
	this.SetItem(row,"kfz14ot1_acc2_cd", 		this.GetItemString(row,"kfz01om0_acc2_cd"))
END IF
end event

event editchanged;w_mdi_frame.sle_msg.text = ''
ib_any_typing = True
end event

event itemerror;Return 1
end event

event itemchanged;Double  dDrAmt,dCrAmt,dJanAmt
String  sDcrGbn

IF this.GetColumnName() = "dr_amt" THEN
	dDrAmt = Double(this.GetText())
	
	IF IsNull(dDrAmt) THEN Return 1	
	
	dCrAmt = this.GetItemNumber(this.GetRow(),"cr_amt")
	IF IsNull(dCrAmt) THEN dCrAmt = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"kfz01om0_dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJanAmt = dDrAmt - dCrAmt
	ELSE
		dJanAmt = dCrAmt - dDrAmt
	END IF
	
	this.SetItem(this.GetRow(),"jan_amt",dJanAmt)
END IF

IF this.GetColumnName() = "cr_amt" THEN
	dCrAmt = Double(this.GetText())
	IF IsNull(dCrAmt) THEN Return 1	
	
	dDrAmt = this.GetItemNumber(this.GetRow(),"dr_amt")
	IF IsNull(dDrAmt) THEN dDrAmt = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"kfz01om0_dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJanAmt = dDrAmt - dCrAmt
	ELSE
		dJanAmt = dCrAmt - dDrAmt
	END IF
	
	this.SetItem(this.GetRow(),"jan_amt",dJanAmt)
END IF

end event

event clicked;call super::clicked;
if row <=0 then Return

dw_list.Retrieve(dw_cond.GetItemString(1,"saup_dept"),&
					  dw_cond.GetItemString(1,"acc_yy"),&
					  this.GetItemString(row,"kfz01om0_acc1_cd"),&
					  this.GetItemString(row,"kfz01om0_acc2_cd"))	
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then Return

dw_list.Retrieve(dw_cond.GetItemString(1,"saup_dept"),&
					  dw_cond.GetItemString(1,"acc_yy"),&
					  this.GetItemString(currentrow,"kfz01om0_acc1_cd"),&
					  this.GetItemString(currentrow,"kfz01om0_acc2_cd"))	
end event

type cb_1 from commandbutton within w_kgla15
boolean visible = false
integer x = 1609
integer y = 2772
integer width = 498
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "상위집계(&U)"
end type

type p_1 from uo_picture within w_kgla15
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondn pbm_lbuttondown
boolean visible = false
integer x = 2574
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Erpman\image\상위집계_up.gif"
end type

event ue_lbuttonup;PictureName = "C:\Erpman\image\상위집계_up.gif"
end event

event ue_lbuttondn;PictureName = "C:\Erpman\image\상위집계_dn.gif"
end event

event clicked;call super::clicked;//String sSaupj,sAccYear,sAccMonth
//
//IF dw_ins.RowCount() <=0 THEN Return
//
//dw_cond.AcceptText()     
//sSaupj    = dw_cond.GetItemString(1,  "saupj")
//sAccYear  = dw_cond.GetItemString(1,  "acc_yy")
//sAccMonth = dw_cond.GetItemString(1,  "acc_mm")
//
//IF sSaupj = '99' THEN
//	f_messagechk(15,"") 
//	dw_cond.SetColumn("saupj")
//	dw_cond.SetFocus()
//	Return 
//END IF
///*계정 잔고를 상위계정으로 집계함,거래처 잔고를 상위계정으로 집계함*/
///*계정 잔고를 전사('99')로 생성함,거래처 잔고를 전사('99')로 생성함*/
//SetPointer(HourGlass!)
//w_mdi_frame.sle_msg.text = "상위 집계 중..." 
//f_acc_sum(sAccYear+sAccMonth,sAccYear+sAccMonth)
//
//p_inq.TriggerEvent(clicked!)
//
//w_mdi_frame.sle_msg.text = "상위계정 집계가 완료되었습니다!" 
//SetPointer(Arrow!)
//
//ib_any_typing =False
end event

type dw_list from datawindow within w_kgla15
integer x = 3159
integer y = 200
integer width = 1435
integer height = 1672
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "dw_kgla153"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kgla15
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 192
integer width = 3099
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kgla15
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3154
integer y = 192
integer width = 1454
integer height = 1692
integer cornerheight = 40
integer cornerwidth = 55
end type

