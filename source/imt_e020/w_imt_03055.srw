$PBExportHeader$w_imt_03055.srw
$PBExportComments$L/C 완료처리
forward
global type w_imt_03055 from w_inherite
end type
type rr_3 from roundrectangle within w_imt_03055
end type
type rr_4 from roundrectangle within w_imt_03055
end type
type dw_1 from datawindow within w_imt_03055
end type
type rb_1 from radiobutton within w_imt_03055
end type
type rb_2 from radiobutton within w_imt_03055
end type
type st_11 from statictext within w_imt_03055
end type
type st_2 from statictext within w_imt_03055
end type
type pb_1 from u_pb_cal within w_imt_03055
end type
type pb_2 from u_pb_cal within w_imt_03055
end type
type rr_2 from roundrectangle within w_imt_03055
end type
type rr_33 from roundrectangle within w_imt_03055
end type
end forward

global type w_imt_03055 from w_inherite
boolean visible = false
string title = "L/C 완료 처리"
rr_3 rr_3
rr_4 rr_4
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
st_11 st_11
st_2 st_2
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
rr_33 rr_33
end type
global w_imt_03055 w_imt_03055

type variables
char 		  ic_status
string     is_useyn      //외자인터페이스 생성 적용구분
end variables

on w_imt_03055.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.rr_4=create rr_4
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_11=create st_11
this.st_2=create st_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
this.rr_33=create rr_33
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.rr_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.st_11
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.rr_2
this.Control[iCurrent+11]=this.rr_33
end on

on w_imt_03055.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_11)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
destroy(this.rr_33)
end on

event open;call super::open;//외자인테페이스 생성구분(1:l/c완료처리,2:bl마감시)
SELECT DATANAME
  INTO :is_useyn
  FROM SYSCNFG  
 WHERE SYSGU = 'Y'  AND  SERIAL = 32  AND  LINENO = '1'   ;

IF is_useyn = '' or isnull(is_useyn) then is_useyn = '1' 

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_1.settransobject(sqlca)
dw_1.insertrow(0)

rb_1.checked = true
rb_1.TriggerEvent("clicked")

end event

type dw_insert from w_inherite`dw_insert within w_imt_03055
integer x = 27
integer y = 200
integer width = 4571
integer height = 2120
integer taborder = 30
string dataobject = "d_imt_03055"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;RETURN 1
	
	
end event

event dw_insert::buttonclicked;call super::buttonclicked;IF row < 1 THEN RETURN 

gs_code = this.getitemstring(row, 'polchd_polcno')

open(w_imt_03055_popup)
end event

event dw_insert::itemchanged;call super::itemchanged;string sCode, sLcno
long   get_count
Dec{3} dOpenqty, dBlqty, dipgoqty 

IF this.GetColumnName() = 'polchd_pomaga' THEN

	sCode = this.GetText()
	
	sLcno = this.getitemstring(row, 'polchd_polcno')
   
   IF ic_Status = '2' AND sCode = 'N' and is_useyn = '1' THEN 
		SELECT COUNT(*)
		  INTO :get_count
		  FROM KIF16OT0 
		 WHERE SABU   = :gs_sabu 
		   AND POLCNO = :sLcno
		   AND BAL_DATE IS NOT NULL ;
			
	   if get_count > 0 then 
		   messagebox("확 인", "회계에서 발행처리되어서 취소처리를 할 수 없습니다.")
			this.setitem(row, 'polchd_pomaga', 'Y')
		   return 1
		end if
	END IF 
   IF ic_Status = '1' AND sCode = 'Y' THEN 
		dOpenqty  = this.getitemdecimal(row, 'tot_lcqty')
		dBlqty    = this.getitemdecimal(row, 'tot_blqty')
		dipgoqty  = this.getitemdecimal(row, 'tot_ioreqty') 
		
		if dBlqty > 0 or dipgoqty > 0 then 
			if dOpenqty > dblqty then 
				messagebox('확 인', 'OPEN 수량이 B/L 수량보다 큽니다. OPEN 수량을 확인하세요!')
				this.setitem(row, 'polchd_pomaga', 'N')
				return 1
			elseif dOpenqty > dipgoqty then 	
				messagebox('확 인', 'OPEN 수량이 입고 수량보다 큽니다. OPEN 수량을 확인하세요!')
				this.setitem(row, 'polchd_pomaga', 'N')
				return 1
			end if
		end if
	END IF 
END IF

end event

event dw_insert::editchanged;return 1
end event

type p_delrow from w_inherite`p_delrow within w_imt_03055
boolean visible = false
integer x = 4850
integer y = 12
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_imt_03055
boolean visible = false
integer x = 4827
integer y = 76
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_imt_03055
boolean visible = false
integer x = 4795
integer y = 160
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_imt_03055
boolean visible = false
integer x = 4754
integer y = 220
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_imt_03055
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_imt_03055
integer taborder = 50
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

rb_1.checked = true
rb_1.TriggerEvent("clicked")



end event

type p_print from w_inherite`p_print within w_imt_03055
boolean visible = false
integer x = 4809
integer y = 124
integer height = 140
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_imt_03055
integer x = 3749
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;IF dw_1.accepttext() = -1			THEN 	RETURN 

string	sf_Date, st_date, slcno, ssaupj
Long     k
Integer  iseq, get_seq

sf_Date =  trim(dw_1.getitemstring(1, 'fr_date'))
st_Date =  trim(dw_1.getitemstring(1, 'to_date'))

//ssaupj =  dw_1.getitemstring(1, 'saupj')

dw_insert.setredraw(false)

// 미마감자료
IF ic_Status = '1'	THEN

	IF	dw_insert.Retrieve(gs_sabu) <	1		THEN
		f_message_chk(50, '[미완료 자료]')
		dw_insert.SetFocus()
      dw_insert.setredraw(true)
		RETURN
   END IF
	
ELSE

	IF isnull(sf_Date) or sf_Date = "" 	THEN
		sf_date = '10000101'
	END IF
	IF isnull(st_Date) or st_Date = "" 	THEN
		st_date = '99999999'
	END IF

	IF	dw_insert.Retrieve(gs_sabu, sf_Date, st_date ) <	1		THEN
		f_message_chk(50, '[완료 자료]')
		dw_1.SetColumn('fr_date')
		dw_1.SetFocus()
      dw_insert.setredraw(true)
		RETURN
   END IF

END IF
	
dw_insert.setredraw(true)

end event

type p_del from w_inherite`p_del within w_imt_03055
integer taborder = 0
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\완료취소_up.gif"
end type

event p_del::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_1.accepttext() = -1			THEN 	RETURN 
IF dw_insert.accepttext() = -1			THEN 	RETURN 
IF dw_insert.RowCount() < 1			THEN 	RETURN 

long		lRow, icount
string	sf_Date, snull, smsg, sgubun, sBank
dec      dboamt

sf_Date =  trim(dw_1.getitemstring(1, 'fr_date'))
setnull(snull)

IF Messagebox('확 인', '완료취소 하시겠습니까?',Question!,YesNo!,1) <> 1 then return 

w_mdi_frame.sle_msg.text = 'L/C 완료취소 중...'

FOR  lRow = 1	TO		dw_insert.RowCount()
	sGubun = dw_insert.GetItemString(lRow, "polchd_pomaga")
	IF sGubun = 'N'	THEN
		dw_insert.setitem(lrow, "polchd_lcmadat", snull)
		icount ++
	END IF
NEXT

IF icount < 1 then 
	w_mdi_frame.sle_msg.text = ''
   Messagebox('확 인', '자료를 선택 후 처리 하십시요...') 
	return 
END IF

IF dw_insert.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

w_mdi_frame.sle_msg.text = ''

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event p_del::ue_lbuttonup;PictureName = "C:\erpman\image\완료취소_up.gif"
end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\완료취소_dn.gif"
end event

type p_mod from w_inherite`p_mod within w_imt_03055
integer taborder = 0
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\완료처리_up.gif"
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_1.accepttext() = -1			THEN 	RETURN 
IF dw_insert.accepttext() = -1			THEN 	RETURN 
IF dw_insert.RowCount() < 1			THEN 	RETURN 

long		lRow, icount
string	sf_Date, snull, smsg, sgubun, sBank
dec      dboamt

sf_Date =  trim(dw_1.getitemstring(1, 'fr_date'))
setnull(snull)
IF isnull(sf_Date) or sf_Date = "" 	THEN
	f_message_chk(30,'[완료일자]')
	dw_insert.SetFocus()
	RETURN
END IF
/////////////////////////////////////////////////////////////////////////

IF Messagebox('확 인','L/C 완료처리 하시겠습니까?',Question!,YesNo!,1) <> 1 then return 

w_mdi_frame.sle_msg.text = 'L/C완료 처리중....'

FOR  lRow = 1	TO		dw_insert.RowCount()
	sGubun = dw_insert.GetItemString(lRow, "polchd_pomaga")
	IF sGubun = 'Y'	THEN
		dw_insert.setitem(lrow, "polchd_lcmadat", sf_date)
		icount ++
	END IF
NEXT

IF icount < 1 then 
	w_mdi_frame.sle_msg.text = ''
   Messagebox('확 인', '자료를 선택 후 처리 하십시요...') 
	return 
END IF

IF dw_insert.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

w_mdi_frame.sle_msg.text = ''

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\완료처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\완료처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_imt_03055
end type

type cb_mod from w_inherite`cb_mod within w_imt_03055
end type

type cb_ins from w_inherite`cb_ins within w_imt_03055
end type

type cb_del from w_inherite`cb_del within w_imt_03055
end type

type cb_inq from w_inherite`cb_inq within w_imt_03055
end type

type cb_print from w_inherite`cb_print within w_imt_03055
end type

type st_1 from w_inherite`st_1 within w_imt_03055
end type

type cb_can from w_inherite`cb_can within w_imt_03055
integer x = 2094
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_imt_03055
end type







type gb_button1 from w_inherite`gb_button1 within w_imt_03055
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_03055
end type

type rr_3 from roundrectangle within w_imt_03055
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 969
integer y = 32
integer width = 1179
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_imt_03055
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 188
integer width = 4590
integer height = 2148
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_imt_03055
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 978
integer y = 56
integer width = 1157
integer height = 104
integer taborder = 10
string title = "none"
string dataobject = "d_imt_03055_a"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;string  snull, sdate

setnull(snull)

IF this.GetColumnName() = "fr_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[완료일자]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "to_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[완료일자]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
END IF
end event

type rb_1 from radiobutton within w_imt_03055
integer x = 110
integer y = 72
integer width = 370
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "완료 처리"
boolean checked = true
end type

event clicked;ic_Status = '1'

p_mod.Enabled = True
p_del.Enabled = False
p_mod.Picturename = 'C:\erpman\image\완료처리_up.gif'
p_del.Picturename = 'C:\erpman\image\완료취소_d.gif'

w_mdi_frame.sle_msg.text  = ''

dw_insert.DataObject = 'd_imt_03055'
dw_insert.SetTransObject(SQLCA)

//dw_1.settaborder("fr_date", 0)
dw_1.settaborder("to_date", 0)
//dw_1.Modify("fr_date.BackGround.Color= 12639424") 
dw_1.Modify("to_date.Visible= 0") 
dw_1.Modify("to_date_t.Visible= 0") 

dw_1.setitem(1, 'fr_date', is_today)
dw_insert.setfocus()

pb_2.Visible = False

end event

type rb_2 from radiobutton within w_imt_03055
integer x = 521
integer y = 72
integer width = 370
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "완료 취소"
end type

event clicked;ic_Status = '2'

p_mod.Enabled = False
p_del.Enabled = True
p_mod.Picturename = 'C:\erpman\image\완료처리_up.gif'
p_del.Picturename = 'C:\erpman\image\완료취소_up.gif'
w_mdi_frame.sle_msg.text  = ''

dw_insert.DataObject = 'd_imt_03056'
dw_insert.SetTransObject(SQLCA)

dw_1.Modify("to_date.Visible= 1") 
dw_1.Modify("to_date_t.Visible= 1") 
//dw_1.settaborder("fr_date", 10)
dw_1.settaborder("to_date", 30)
//dw_1.Modify("fr_date.BackGround.Color= 16777215") 

dw_1.setitem(1, 'fr_date', left(is_today,6) + '01')
dw_1.setitem(1, 'to_date', is_today)

dw_1.setcolumn('fr_date')
dw_1.setfocus()

pb_2.Visible = True


end event

type st_11 from statictext within w_imt_03055
integer x = 2199
integer y = 52
integer width = 1275
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "* 선택에 체크박스가 없는 L/C는"
boolean focusrectangle = false
end type

type st_2 from statictext within w_imt_03055
integer x = 2199
integer y = 108
integer width = 1330
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "  관련된 B/L 에서 마감처리 안된 자료가 있습니다."
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_imt_03055
integer x = 1595
integer y = 60
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'fr_date', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_03055
boolean visible = false
integer x = 2048
integer y = 60
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'to_date', gs_code)



end event

type rr_2 from roundrectangle within w_imt_03055
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 32
integer width = 937
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_33 from roundrectangle within w_imt_03055
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2162
integer y = 32
integer width = 1385
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

