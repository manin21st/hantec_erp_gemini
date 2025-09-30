$PBExportHeader$w_kgle24.srw
$PBExportComments$외화평가환율 등록
forward
global type w_kgle24 from w_inherite
end type
type dw_detail from datawindow within w_kgle24
end type
type st_2 from statictext within w_kgle24
end type
type st_3 from statictext within w_kgle24
end type
type rr_1 from roundrectangle within w_kgle24
end type
type em_date from editmask within w_kgle24
end type
type gb_1 from groupbox within w_kgle24
end type
end forward

global type w_kgle24 from w_inherite
string title = "외화평가환율 등록"
dw_detail dw_detail
st_2 st_2
st_3 st_3
rr_1 rr_1
em_date em_date
gb_1 gb_1
end type
global w_kgle24 w_kgle24

type variables
String  sSelectedDate
end variables

forward prototypes
public subroutine wf_setting_datawindow (string sdate)
end prototypes

public subroutine wf_setting_datawindow (string sdate);String   sCurr,sCurrName
Integer  iCurRow

IF dw_detail.RowCount() <=0 THEN 
	
	dw_detail.SetRedraw(False)
	DECLARE Cur_Curr CURSOR FOR  
		SELECT "RFGUB",   "RFNA1"  
		   FROM "REFFPF"  
   		WHERE ("SABU" = '1' ) AND  ( "RFCOD" = '10' ) AND 
					("RFGUB" <> '00' AND "RFGUB" <> 'WON')  ;
	
	Open Cur_Curr;
	Do While True
		Fetch Cur_Curr INTO :sCurr, :sCurrName;
		IF Sqlca.Sqlcode <> 0 THEN exit
		
		iCurRow = dw_detail.InsertRow(0)
		
		dw_detail.SetItem(iCurRow,"kfz34ot1_closing_date",sDate)
		dw_detail.SetItem(iCurRow,"kfz34ot1_y_curr",      sCurr)
		dw_detail.SetItem(iCurRow,"reffpf_rfna1",         sCurrName)
	Loop
	Close Cur_Curr;	
	dw_detail.SetRedraw(True)
	
END IF
end subroutine

on w_kgle24.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
this.em_date=create em_date
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.em_date
this.Control[iCurrent+6]=this.gb_1
end on

on w_kgle24.destroy
call super::destroy
destroy(this.dw_detail)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
destroy(this.em_date)
destroy(this.gb_1)
end on

event open;call super::open;
dw_detail.settransobject(sqlca)

em_date.text = Left(F_Today(),4)+'.'+Mid(F_Today(),5,2)+'.'+Right(F_Today(),2)
dw_detail.retrieve(f_Today())

Wf_Setting_DataWindow(f_Today())
sle_msg.text = ''	

end event

type dw_insert from w_inherite`dw_insert within w_kgle24
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgle24
boolean visible = false
integer x = 2514
integer y = 1496
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kgle24
boolean visible = false
integer x = 2341
integer y = 1496
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kgle24
boolean visible = false
integer x = 1646
integer y = 1496
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kgle24
boolean visible = false
integer x = 2167
integer y = 1496
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kgle24
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kgle24
boolean visible = false
integer x = 3035
integer y = 1496
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kgle24
boolean visible = false
integer x = 1819
integer y = 1496
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kgle24
boolean visible = false
integer x = 1993
integer y = 1496
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kgle24
integer x = 4270
integer taborder = 40
end type

event p_del::clicked;call super::clicked;String sCurDate

sCurDate = Left(Trim(em_date.text),4)+Mid(Trim(em_date.text),6,2)+Right(Trim(em_date.text),2)
IF IsNull(sCurDate) OR sCurDate = '' THEN
	F_MessageChk(1,'[평가기준일]')
	em_date.SetFocus()
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN Return

delete from kfz34ot1 where closing_date  = :sCurDate;
if sqlca.sqlcode = 0 then
	dw_detail.retrieve(sCurDate)

	Wf_Setting_DataWindow(sCurDate)

	ib_any_typing = False
	
ELSE
	Rollback;
	F_MessageChk(13,'')
	Return
END IF
Commit;
sle_msg.text = '자료를 삭제하였습니다!'
end event

type p_mod from w_inherite`p_mod within w_kgle24
integer x = 4096
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;
IF dw_detail.AcceptText() = -1 THEN Return

IF F_DbConFirm('저장') = 2 THEN Return

IF dw_detail.Update() = 1 THEN
	ib_any_typing = False
ELSE
	Rollback;
	F_MessageChk(13,'')
	Return
END IF
Commit;
w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!'
end event

type cb_exit from w_inherite`cb_exit within w_kgle24
boolean visible = false
integer x = 3200
integer y = 1864
end type

type cb_mod from w_inherite`cb_mod within w_kgle24
boolean visible = false
integer x = 2501
integer y = 1864
end type

type cb_ins from w_inherite`cb_ins within w_kgle24
boolean visible = false
integer x = 955
integer y = 2720
end type

type cb_del from w_inherite`cb_del within w_kgle24
boolean visible = false
integer x = 2853
integer y = 1864
end type

type cb_inq from w_inherite`cb_inq within w_kgle24
boolean visible = false
integer x = 402
integer y = 2696
end type

type cb_print from w_inherite`cb_print within w_kgle24
integer x = 1317
integer y = 2720
end type

type st_1 from w_inherite`st_1 within w_kgle24
boolean visible = false
integer y = 2100
end type

type cb_can from w_inherite`cb_can within w_kgle24
boolean visible = false
integer x = 2185
integer y = 2720
end type

type cb_search from w_inherite`cb_search within w_kgle24
integer x = 1682
integer y = 2720
end type

type dw_datetime from w_inherite`dw_datetime within w_kgle24
boolean visible = false
integer x = 2830
integer y = 2100
end type

type sle_msg from w_inherite`sle_msg within w_kgle24
boolean visible = false
integer y = 2100
integer width = 2446
end type

type gb_10 from w_inherite`gb_10 within w_kgle24
boolean visible = false
integer y = 2048
integer width = 3575
end type

type gb_button1 from w_inherite`gb_button1 within w_kgle24
boolean visible = false
integer x = 366
integer y = 2640
integer width = 407
end type

type gb_button2 from w_inherite`gb_button2 within w_kgle24
boolean visible = false
integer x = 2459
integer y = 1808
integer width = 1111
end type

type dw_detail from datawindow within w_kgle24
integer x = 1595
integer y = 260
integer width = 1477
integer height = 1124
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kgle241"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;dw_detail.SetRowFocusIndicator(Hand!)
end event

event editchanged;ib_any_typing = True
end event

type st_2 from statictext within w_kgle24
integer x = 699
integer y = 332
integer width = 306
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "평가기준일"
boolean focusrectangle = false
end type

type st_3 from statictext within w_kgle24
integer x = 635
integer y = 332
integer width = 64
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kgle24
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1573
integer y = 248
integer width = 1513
integer height = 1148
integer cornerheight = 40
integer cornerwidth = 55
end type

type em_date from editmask within w_kgle24
integer x = 1010
integer y = 324
integer width = 375
integer height = 72
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
boolean autoskip = true
end type

event modified;String sCurDate

sCurDate = Left(Trim(em_date.text),4)+Mid(Trim(em_date.text),6,2)+Right(Trim(em_date.text),2)
dw_detail.Retrieve(sCurDate)

Wf_Setting_DataWindow(sCurDate)
sle_msg.text = ''	

end event

type gb_1 from groupbox within w_kgle24
integer x = 544
integer y = 228
integer width = 1006
integer height = 228
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

