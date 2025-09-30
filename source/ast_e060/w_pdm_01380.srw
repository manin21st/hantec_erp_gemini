$PBExportHeader$w_pdm_01380.srw
$PBExportComments$** 구매단가 집계
forward
global type w_pdm_01380 from w_inherite
end type
type st_3 from statictext within w_pdm_01380
end type
type st_22 from statictext within w_pdm_01380
end type
type st_2 from statictext within w_pdm_01380
end type
type st_4 from statictext within w_pdm_01380
end type
type st_6 from statictext within w_pdm_01380
end type
type st_5 from statictext within w_pdm_01380
end type
type pb_1 from u_pb_cal within w_pdm_01380
end type
end forward

global type w_pdm_01380 from w_inherite
string title = "구매 단가 집계"
st_3 st_3
st_22 st_22
st_2 st_2
st_4 st_4
st_6 st_6
st_5 st_5
pb_1 pb_1
end type
global w_pdm_01380 w_pdm_01380

on w_pdm_01380.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_22=create st_22
this.st_2=create st_2
this.st_4=create st_4
this.st_6=create st_6
this.st_5=create st_5
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_22
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.pb_1
end on

on w_pdm_01380.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.st_22)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.pb_1)
end on

event open;call super::open;dw_Insert.Settransobject(sqlca)
dw_Insert.Insertrow(0)

string sdate

sdate = f_aftermonth(left(is_today, 6), -12)
sdate = sdate + right(is_today, 2)

dw_insert.SetItem(1, 'sdate', sdate)
dw_insert.SetItem(1, 'mon', 12)
dw_insert.SetColumn("sdate")
dw_insert.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_pdm_01380
integer x = 1673
integer y = 500
integer width = 1134
integer height = 328
integer taborder = 10
string dataobject = "d_pdm_01380"
boolean border = false
end type

event dw_insert::itemchanged;STRING s_date, snull

setnull(snull)

IF this.GetColumnName() ="sdate" THEN
	s_date = trim(this.GetText())
	
	if s_date = "" or isnull(s_date) then return 

  	IF f_datechk(s_date) = -1	then
      f_message_chk(35, '[기준일자]')
		this.setitem(1, "sdate", snull)
		return 1
	END IF
END IF
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01380
boolean visible = false
integer x = 3753
integer y = 2776
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01380
boolean visible = false
integer x = 3579
integer y = 2776
end type

type p_search from w_inherite`p_search within w_pdm_01380
integer x = 4270
string picturename = "C:\erpman\image\처리_UP.gif"
end type

event p_search::clicked;call super::clicked;String  sDate, s_Todate 
long    lMonth
int     iReturn

IF dw_insert.AcceptText() = -1 THEN RETURN 

sdate	= trim(dw_insert.GetItemString(1, 'sdate'))

if isnull(sDate) or sDate = "" then
	f_message_chk(30,'[시작일자]')
	dw_insert.SetColumn('sDate')
	dw_insert.SetFocus()
	return
end if	

lMonth = dw_insert.GetItemNumber(1, 'mon')

if isnull(lMonth) or lMonth <= 0 then
	f_message_chk(30,'[집계기간]')
	dw_insert.SetColumn('mon')
	dw_insert.SetFocus()
	return
else
	s_todate = f_aftermonth(left(sdate, 6), lMonth)
	s_todate = s_todate + right(sdate, 2)
	s_todate = f_afterday(s_todate, -1)
end if	

IF Messagebox('단가집계',"단가집계 처리 하시겠습니까?", Question!,YesNo!,2) = 2 THEN RETURN 

w_mdi_frame.sle_msg.text = "단가집계 처리 中 ............"

SetPointer(HourGlass!)

iReturn = sqlca.FUN_DANMST_UPDATE(gs_sabu, sDate, s_todate);
If ireturn < 0  then
	sle_msg.text = ''
	rollback;	
	f_message_chk(89,'[단가 집계] [ ' + string(ireturn) + ' ]') 
	return
end if

Commit;

w_mdi_frame.sle_msg.text = "단가집계 처리 되었습니다.!!"


end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pdm_01380
boolean visible = false
integer x = 3406
integer y = 2776
end type

type p_exit from w_inherite`p_exit within w_pdm_01380
end type

type p_can from w_inherite`p_can within w_pdm_01380
boolean visible = false
integer x = 4274
integer y = 2776
end type

type p_print from w_inherite`p_print within w_pdm_01380
boolean visible = false
integer x = 3058
integer y = 2776
end type

type p_inq from w_inherite`p_inq within w_pdm_01380
boolean visible = false
integer x = 3232
integer y = 2776
end type

type p_del from w_inherite`p_del within w_pdm_01380
boolean visible = false
integer x = 4101
integer y = 2776
end type

type p_mod from w_inherite`p_mod within w_pdm_01380
boolean visible = false
integer x = 3927
integer y = 2776
end type

type cb_exit from w_inherite`cb_exit within w_pdm_01380
boolean visible = false
integer x = 2144
integer y = 2752
integer width = 581
integer height = 120
integer taborder = 40
integer textsize = -9
end type

event cb_exit::clicked;close(parent)
end event

type cb_mod from w_inherite`cb_mod within w_pdm_01380
boolean visible = false
integer x = 649
integer y = 2612
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01380
boolean visible = false
integer x = 3035
integer y = 2612
integer width = 581
integer height = 120
integer taborder = 20
integer textsize = -9
string text = "집계 처리(&G)"
end type

event cb_ins::clicked;call super::clicked;//String  sDate, s_Todate 
//long    lMonth
//int     iReturn
//
//IF dw_insert.AcceptText() = -1 THEN RETURN 
//
//sdate	= trim(dw_insert.GetItemString(1, 'sdate'))
//
//if isnull(sDate) or sDate = "" then
//	f_message_chk(30,'[시작일자]')
//	dw_insert.SetColumn('sDate')
//	dw_insert.SetFocus()
//	return
//end if	
//
//lMonth = dw_insert.GetItemNumber(1, 'mon')
//
//if isnull(lMonth) or lMonth <= 0 then
//	f_message_chk(30,'[집계기간]')
//	dw_insert.SetColumn('mon')
//	dw_insert.SetFocus()
//	return
//else
//	s_todate = f_aftermonth(left(sdate, 6), lMonth)
//	s_todate = s_todate + right(sdate, 2)
//	s_todate = f_afterday(s_todate, -1)
//end if	
//
//IF Messagebox('단가집계',"단가집계 처리 하시겠습니까?", Question!,YesNo!,2) = 2 THEN RETURN 
//
//w_mdi_frame.sle_msg.text = "단가집계 처리 中 ............"
//
//SetPointer(HourGlass!)
//
//iReturn = sqlca.FUN_DANMST_UPDATE(gs_sabu, sDate, s_todate);
//If ireturn < 0  then
//	sle_msg.text = ''
//	rollback;	
//	f_message_chk(89,'[단가 집계] [ ' + string(ireturn) + ' ]') 
//	return
//end if
//
//Commit;
//
//w_mdi_frame.sle_msg.text = "단가집계 처리 되었습니다.!!"
//
//
end event

type cb_del from w_inherite`cb_del within w_pdm_01380
boolean visible = false
integer x = 887
integer y = 2476
integer width = 581
integer height = 120
integer textsize = -9
boolean enabled = false
string text = "마감이력삭제(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01380
boolean visible = false
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_pdm_01380
boolean visible = false
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_pdm_01380
end type

type cb_can from w_inherite`cb_can within w_pdm_01380
boolean visible = false
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_pdm_01380
boolean visible = false
integer x = 2459
integer y = 2612
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01380
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01380
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01380
end type

type st_3 from statictext within w_pdm_01380
integer x = 1010
integer y = 1556
integer width = 2478
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "* 주의할 사항은 단가마스터(구매)에 등록되지 않은 내역은 생성되지 않습니다."
boolean focusrectangle = false
end type

type st_22 from statictext within w_pdm_01380
integer x = 1010
integer y = 1172
integer width = 2418
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "* 구매단가는 시작일자부터 집계기간(개월수)에 해당되는 수불에 구매입고내역 중에서"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdm_01380
integer x = 1074
integer y = 1252
integer width = 654
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
boolean enabled = false
string text = "최저, 최고, 최종단가"
boolean focusrectangle = false
end type

type st_4 from statictext within w_pdm_01380
integer x = 1010
integer y = 1676
integer width = 2478
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "* 단가는 전체, 공정(외주인  경우에만 해당됨)별로 집계합니다."
boolean focusrectangle = false
end type

type st_6 from statictext within w_pdm_01380
integer x = 1705
integer y = 1252
integer width = 2231
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "에  해당되는 내역(단가, 수불승인일자)을 거래처 + 품번 기준으로 집계하여"
boolean focusrectangle = false
end type

type st_5 from statictext within w_pdm_01380
integer x = 1074
integer y = 1344
integer width = 1097
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "단가마스타에 자료를 저장처리 합니다."
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_pdm_01380
integer x = 2555
integer y = 556
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'sdate', gs_code)

end event

