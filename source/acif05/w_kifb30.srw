$PBExportHeader$w_kifb30.srw
$PBExportComments$자동전표 현황 관리
forward
global type w_kifb30 from w_inherite
end type
type rr_1 from roundrectangle within w_kifb30
end type
type st_2 from statictext within w_kifb30
end type
type em_ym from editmask within w_kifb30
end type
type dw_list from datawindow within w_kifb30
end type
type st_3 from statictext within w_kifb30
end type
type ln_1 from line within w_kifb30
end type
type rr_2 from roundrectangle within w_kifb30
end type
end forward

global type w_kifb30 from w_inherite
string title = "자동전표 현황 관리"
rr_1 rr_1
st_2 st_2
em_ym em_ym
dw_list dw_list
st_3 st_3
ln_1 ln_1
rr_2 rr_2
end type
global w_kifb30 w_kifb30

type variables

end variables

on w_kifb30.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.st_2=create st_2
this.em_ym=create em_ym
this.dw_list=create dw_list
this.st_3=create st_3
this.ln_1=create ln_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.em_ym
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.ln_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_kifb30.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.st_2)
destroy(this.em_ym)
destroy(this.dw_list)
destroy(this.st_3)
destroy(this.ln_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.SetTransObject(Sqlca)
dw_list.Reset()

em_ym.Text = Left(F_today(),4)+'.'+Mid(F_Today(),5,2)
em_ym.SetFocus()



end event

type dw_insert from w_inherite`dw_insert within w_kifb30
boolean visible = false
integer x = 41
integer y = 3124
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifb30
boolean visible = false
integer x = 3090
integer y = 2788
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifb30
boolean visible = false
integer x = 2917
integer y = 2788
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifb30
boolean visible = false
integer x = 2222
integer y = 2788
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kifb30
boolean visible = false
integer x = 2743
integer y = 2788
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifb30
integer x = 4411
integer taborder = 40
end type

type p_can from w_inherite`p_can within w_kifb30
boolean visible = false
integer x = 3611
integer y = 2788
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifb30
boolean visible = false
integer x = 2395
integer y = 2788
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kifb30
integer x = 4238
end type

event p_inq::clicked;call super::clicked;String sYearMonth

sYearMonth = Left(Trim(em_ym.text),4)+Right(Trim(em_ym.text),2)
IF sYearMonth = '' OR IsNull(sYearMonth) THEN
	F_MessageChk(1,'[기준년월]')
	em_ym.SetFocus()
	Return
END IF

IF dw_list.Retrieve(sYearMonth) <=0 THEN
	F_MessageChk(14,'')
	em_ym.SetFocus()
	Return
END IF
end event

type p_del from w_inherite`p_del within w_kifb30
boolean visible = false
integer x = 3438
integer y = 2788
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifb30
boolean visible = false
integer x = 3264
integer y = 2788
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kifb30
boolean visible = false
integer x = 3122
integer y = 3216
end type

type cb_mod from w_inherite`cb_mod within w_kifb30
boolean visible = false
integer x = 1989
integer y = 2700
end type

type cb_ins from w_inherite`cb_ins within w_kifb30
boolean visible = false
integer x = 1591
integer y = 2700
end type

type cb_del from w_inherite`cb_del within w_kifb30
boolean visible = false
integer x = 2345
integer y = 2696
end type

type cb_inq from w_inherite`cb_inq within w_kifb30
boolean visible = false
integer x = 2766
integer y = 3216
end type

type cb_print from w_inherite`cb_print within w_kifb30
boolean visible = false
integer x = 1157
integer y = 3224
end type

type st_1 from w_inherite`st_1 within w_kifb30
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kifb30
boolean visible = false
integer x = 2702
integer y = 2700
end type

type cb_search from w_inherite`cb_search within w_kifb30
boolean visible = false
integer x = 1554
integer y = 3224
end type

type dw_datetime from w_inherite`dw_datetime within w_kifb30
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kifb30
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kifb30
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kifb30
boolean visible = false
integer x = 1938
integer y = 2636
end type

type gb_button2 from w_inherite`gb_button2 within w_kifb30
boolean visible = false
integer x = 2729
integer y = 3164
integer width = 763
end type

type rr_1 from roundrectangle within w_kifb30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 105
integer y = 28
integer width = 754
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within w_kifb30
integer x = 165
integer y = 76
integer width = 265
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "기준년월"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_ym from editmask within w_kifb30
integer x = 434
integer y = 68
integer width = 370
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

type dw_list from datawindow within w_kifb30
integer x = 114
integer y = 196
integer width = 4457
integer height = 2040
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_kifb301"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;String  sUpmuGbn

IF dwo.name = 'dcb_junpoy' THEN
	IF this.GetItemString(this.GetRow(),"gubun") = '1' THEN
		sUpmuGbn = this.GetItemString(this.GetRow(),"jungu")
		
		CHOOSE CASE sUpmuGbn
			CASE 'B'													/*매입*/
				OpenSheet(w_kifa41,w_mdi_frame,0,Layered!)	
			CASE 'D'													/*매출*/
				OpenSheet(w_kifa42,w_mdi_frame,0,Layered!)				
			CASE 'F'													/*수금*/
				OpenSheet(w_kifa05,w_mdi_frame,0,Layered!)		
			CASE 'G'													/*받을어음 만기결제*/
				OpenSheet(w_kglb10,w_mdi_frame,0,Layered!)	
			CASE 'H'													/*지급어음 만기결제*/
				OpenSheet(w_kglb12,w_mdi_frame,0,Layered!)			
			CASE 'J'													/*수출비용*/
				OpenSheet(w_kifa58,w_mdi_frame,0,Layered!)				
			CASE 'K'													/*수입비용*/
				OpenSheet(w_kifa50,w_mdi_frame,0,Layered!)				
			CASE 'L'													/*수출*/
				OpenSheet(w_kifa14,w_mdi_frame,0,Layered!)				
			CASE 'N'													/*NEGO*/
				OpenSheet(w_kifa151,w_mdi_frame,0,Layered!)				
			CASE 'O'													/*외자입고*/
				OpenSheet(w_kifa16,w_mdi_frame,0,Layered!)				
			CASE 'A'													/*월할 선급비용*/
				OpenSheet(w_kglc24,w_mdi_frame,0,Layered!)				
		END CHOOSE
	END IF
END IF

IF dwo.name = 'dcb_sungin' THEN
	OpenSheet(w_kglc01,w_mdi_frame,0,Layered!)	
END IF

end event

type st_3 from statictext within w_kifb30
integer x = 128
integer y = 72
integer width = 59
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type ln_1 from line within w_kifb30
integer linethickness = 1
integer beginx = 439
integer beginy = 136
integer endx = 805
integer endy = 136
end type

type rr_2 from roundrectangle within w_kifb30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 105
integer y = 188
integer width = 4475
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

