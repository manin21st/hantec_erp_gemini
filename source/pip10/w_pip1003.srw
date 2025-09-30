$PBExportHeader$w_pip1003.srw
$PBExportComments$** 국민연금/의료보험 등록
forward
global type w_pip1003 from w_inherite_multi
end type
type gb_4 from groupbox within w_pip1003
end type
type dw_main from u_key_enter within w_pip1003
end type
type rb_1 from radiobutton within w_pip1003
end type
type rb_2 from radiobutton within w_pip1003
end type
type dw_1 from datawindow within w_pip1003
end type
type sle_1 from singlelineedit within w_pip1003
end type
type st_2 from statictext within w_pip1003
end type
type cb_1 from commandbutton within w_pip1003
end type
type rr_1 from roundrectangle within w_pip1003
end type
type rr_2 from roundrectangle within w_pip1003
end type
end forward

global type w_pip1003 from w_inherite_multi
string title = "국민연금/건강보험 등록"
gb_4 gb_4
dw_main dw_main
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
sle_1 sle_1
st_2 st_2
cb_1 cb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pip1003 w_pip1003

type variables

end variables

forward prototypes
public function integer wf_update_personal (string degree, long bamt, integer iflag)
public function integer wf_requiredcheck (integer ll_row)
end prototypes

public function integer wf_update_personal (string degree, long bamt, integer iflag);if iflag = 1 then     //국민연금
   update p3_personal
	set penamt = :bamt
	where pendegree = :degree;
	
	if sqlca.sqlcode <> 0 then
		messagebox('에러','급여마스타의 국민연금액 업데이트 실패!')
		return -1
	end if
end if
if iflag = 2 then   //건강보험
   update p3_personal
	set medamt = :bamt
	where meddegree = :degree;
	
	if sqlca.sqlcode <> 0 then
		messagebox('에러','급여마스타의 건강보험액 업데이트 실패!')
		return -1
	end if
end if


return 1
end function

public function integer wf_requiredcheck (integer ll_row);
String scode
Double damount

sle_msg.text =""

IF rb_1.Checked = True THEN
	scode  = dw_main.GetItemString(ll_row,"pendegree")
	damount = dw_main.GetItemNumber(ll_row,"penselffine")
	dw_main.SetColumn("pendegree")

ELSE
	scode  = dw_main.GetItemString(ll_row,"meddegree")
	damount = dw_main.GetItemNumber(ll_row,"medselffine")
	dw_main.SetColumn("meddegree")
END IF



IF scode ="" OR IsNull(scode) THEN
	Messagebox("확 인","등급을 입력하세요!!")
	dw_main.SetFocus()
	Return -1
END IF

IF damount = 0 OR IsNull(damount) THEN
	sle_msg.text ="등급에 해당하는 금액을 적어도 하나는 입력을 해야 합니다!!"
	Messagebox("확 인","금액을 입력하세요!!")
	IF rb_1.Checked = True THEN
		dw_main.SetColumn("penselffine")
	ELSE
		dw_main.SetColumn("medselffine")
	END IF
	dw_main.SetFocus()
	Return -1
END IF

Return 1
end function

on w_pip1003.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.dw_main=create dw_main
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.sle_1=create sle_1
this.st_2=create st_2
this.cb_1=create cb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_pip1003.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.dw_main)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.Insertrow(0)

dw_main.SetTransObject(SQLCA)
dw_main.Reset()

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1003
boolean visible = false
integer x = 4192
integer y = 2792
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1003
boolean visible = false
integer x = 4018
integer y = 2792
end type

type p_search from w_inherite_multi`p_search within w_pip1003
boolean visible = false
integer x = 3675
integer y = 2788
end type

type p_ins from w_inherite_multi`p_ins within w_pip1003
integer x = 3694
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue = 1
ELSE
	il_functionvalue = wf_requiredcheck(dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow 
	
	dw_main.InsertRow(il_currow)
	IF rb_2.Checked = True THEN
		dw_main.SetItem(il_currow,"companycode",gs_company)	
		dw_main.SetColumn("meddegree")
	ELSE
		dw_main.SetColumn("pendegree")
	END IF
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetFocus()
	
	
END IF

end event

type p_exit from w_inherite_multi`p_exit within w_pip1003
integer x = 4389
end type

type p_can from w_inherite_multi`p_can within w_pip1003
integer x = 4215
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

dw_main.Reset()
ib_any_typing = false

end event

type p_print from w_inherite_multi`p_print within w_pip1003
boolean visible = false
integer x = 3849
integer y = 2788
end type

type p_inq from w_inherite_multi`p_inq within w_pip1003
integer x = 3520
end type

event p_inq::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

IF rb_1.Checked = True THEN
	dw_main.Retrieve()
	dw_main.SetColumn("pendegree")
ELSE
	dw_main.Retrieve(gs_company)
	dw_main.SetColumn("meddegree")
END IF
	
IF dw_main.RowCount() <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!",StopSign!)
	Return
END IF

w_mdi_frame.sle_msg.text = " 조회 "

dw_main.ScrollToRow(dw_main.RowCount())
dw_main.SetFocus()

end event

type p_del from w_inherite_multi`p_del within w_pip1003
integer x = 4041
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
		IF rb_1.Checked = True THEN
			dw_main.SetColumn("pendegree")
		ELSE
			dw_main.SetColumn("meddegree")
		END IF
		dw_main.SetFocus()
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite_multi`p_mod within w_pip1003
integer x = 3867
end type

event p_mod::clicked;call super::clicked;Int k,  gubun
dec drate
long boamt
string degree

if rb_1.checked = true then
	gubun = 1              //국민연금
elseif rb_2.checked = true then
	gubun = 2             //건강보험
end if

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_requiredcheck(dw_main.GetRow()) = -1 THEN RETURN
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	drate = dec(sle_1.text)
	
	UPDATE "P0_SYSCNFG"  
     SET "DATANAME" = :drate  
   WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  
         ( "P0_SYSCNFG"."SERIAL" = 19 ) AND  
         ( "P0_SYSCNFG"."LINENO" = :gubun )   ;

	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF
if MessageBox("확인", "급여 마스타 금액에 업데이트 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
if gubun = 1 then                         //국민연금
	for k = 1 to dw_main.rowcount()
		 degree = dw_main.GetitemString(k, 'pendegree')	
       boamt  = dw_main.GetitemNumber(k, 'penselffine')
		 
		 if wf_update_personal(degree, boamt, gubun) = -1 then
		    rollback;
	    else
			 commit;
		 end if
	next
end if
if gubun = 2 then
	for k = 1 to dw_main.rowcount()
		 degree = dw_main.GetitemString(k, 'meddegree')	
       boamt  = dw_main.GetitemNumber(k, 'medselffine')
		 
		 if wf_update_personal(degree, boamt, gubun) = -1 then
		    rollback;
	    else
			 commit;
		 end if
	next
end if
w_mdi_frame.sle_msg.text = '급여마스타 업데이트 완료!'	

dw_main.Setfocus()
		

end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1003
boolean visible = false
integer x = 1431
integer y = 2600
end type

type st_window from w_inherite_multi`st_window within w_pip1003
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip1003
boolean visible = false
integer taborder = 40
end type

event cb_append::clicked;call super::clicked;//Int il_currow,il_functionvalue
//
//IF dw_main.RowCount() <=0 THEN
//	il_currow = 0
//	il_functionvalue =1
//ELSE
//	il_functionvalue = wf_requiredcheck(dw_main.GetRow())
//	
//	il_currow = dw_main.GetRow() 
//END IF
//
//IF il_functionvalue = 1 THEN
//	il_currow = il_currow + 1
//	
//	dw_main.InsertRow(il_currow)
//	IF rb_2.Checked = True THEN
//		dw_main.SetItem(il_currow,"companycode",gs_company)	
//		dw_main.SetColumn("meddegree")
//	ELSE
//		dw_main.SetColumn("pendegree")
//	END IF
//	
//	dw_main.ScrollToRow(il_currow)
//	dw_main.SetFocus()
//	
//END IF
//
end event

type cb_exit from w_inherite_multi`cb_exit within w_pip1003
boolean visible = false
integer taborder = 90
end type

type cb_update from w_inherite_multi`cb_update within w_pip1003
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1003
boolean visible = false
integer taborder = 50
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1003
boolean visible = false
integer taborder = 70
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1003
boolean visible = false
integer taborder = 30
end type

type st_1 from w_inherite_multi`st_1 within w_pip1003
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1003
boolean visible = false
integer taborder = 80
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1003
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1003
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1003
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1003
boolean visible = false
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1003
boolean visible = false
end type

type gb_4 from groupbox within w_pip1003
boolean visible = false
integer x = 1815
integer y = 2496
integer width = 1847
integer height = 208
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
end type

type dw_main from u_key_enter within w_pip1003
integer x = 535
integer y = 296
integer width = 3264
integer height = 1892
integer taborder = 20
string dataobject = "d_pip1003_2"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;
Int il_currow,lReturnRow
String slevel,snull,samount

SetNull(snull)

il_currow = this.GetRow()

IF this.GetColumnName() = "meddegree" THEN											//의료보험
	
	slevel = THIS.GETTEXT()								
	
	lReturnRow = This.Find("meddegree = '"+slevel+"' ", 1, This.RowCount())
	
	IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		MessageBox("확인","등록된 등급입니다.~r등록할 수 없습니다.")
		this.SetItem(il_currow, "meddegree", sNull)
		RETURN  1	
	END IF
END IF

IF this.GetColumnName() = "medstandardwage" THEN
	dw_1.accepttext()
	samount = This.gettext()
	if samount ="" OR IsNull(samount) then return 
	
	dw_main.setitem(il_currow, "medselffine", &
				truncate(f_ifz(Double(samount)) * f_ifz(dw_1.getitemnumber(1, "a")) / 100,0))
END IF

IF this.GetColumnName() = "pendegree" THEN											//국민연금
	
	slevel = THIS.GETTEXT()								
	
	lReturnRow = This.Find("pendegree = '"+slevel+"' ", 1, This.RowCount())
	
	IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		MessageBox("확인","등록된 등급입니다.~r등록할 수 없습니다.")
		this.SetItem(il_currow, "pendegree", sNull)
		RETURN  1	
	END IF
END IF

IF this.GetColumnName() = "penstandardwage" THEN
	dw_1.accepttext()
		
	samount = This.gettext()
	IF samount ="" OR IsNull(samount) THEN RETURN

	dw_main.setitem(il_currow, "pencompanyfine", &
		truncate( f_ifz(Double(samount)) * f_ifz(dw_1.getitemnumber(1, "a"))/100,0))

	dw_main.setitem(il_currow, "penselffine", &
		truncate( f_ifz(Double(samount)) * f_ifz(dw_1.getitemnumber(1, "b"))/100,0))
		
	dw_main.setitem(il_currow, "penretirepension", &
		truncate( f_ifz(Double(samount)) * f_ifz(dw_1.getitemnumber(1, "c"))/100,0))
END IF

end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;
//this.SetRowFocusIndicator(Hand!)
end event

event editchanged;call super::editchanged;ib_any_typing =True


end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name = "allowname" THEN
	f_toggle_kor(handle(parent))
ELSE
	f_toggle_eng(handle(parent))
END IF
end event

event ue_pressenter;if dw_main.getcolumnname() = "medselffine" OR dw_main.getcolumnname() = "penretirepension"then
   if dw_main.rowcount() = dw_main.getrow() then
		p_ins.triggerevent(clicked!)
	else
		send(handle(this), 256, 9, 0)
	end if
else
	send(handle(this), 256, 9, 0)
end if

return 1
end event

type rb_1 from radiobutton within w_pip1003
event clicked pbm_bnclicked
integer x = 576
integer y = 120
integer width = 421
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "국민연금"
boolean checked = true
end type

event clicked;dec ld_rate

dw_1.SetRedraw(False)
dw_main.SetRedraw(False)

SELECT TO_NUMBER(TRIM("P0_SYSCNFG"."DATANAME") )
 INTO :ld_rate
 FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  
		( "P0_SYSCNFG"."SERIAL" = 19 ) AND  
		( "P0_SYSCNFG"."LINENO" = '1' ) ;    //국민연금 요율


dw_1.DataObject = "d_pip1003_1"
dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.Insertrow(0)
dw_1.SetFocus()

dw_main.DataObject = "d_pip1003_2"
dw_main.SetTransObject(SQLCA)
dw_main.Reset()

dw_1.SetRedraw(True)
dw_main.SetRedraw(True)

sle_1.text = String(ld_rate)

p_inq.TriggerEvent(Clicked!)

end event

type rb_2 from radiobutton within w_pip1003
event clicked pbm_bnclicked
integer x = 1010
integer y = 120
integer width = 389
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "건강보험"
end type

event clicked;dec ld_rate

dw_1.SetRedraw(False)
dw_main.SetRedraw(False)

SELECT TO_NUMBER(TRIM("P0_SYSCNFG"."DATANAME") )
 INTO :ld_rate
 FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  
		( "P0_SYSCNFG"."SERIAL" = 19 ) AND  
		( "P0_SYSCNFG"."LINENO" = '2' ) ;    //건강보험 요율

dw_1.DataObject = "d_pip1003_3"
dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.Insertrow(0)
dw_1.SetFocus()

dw_main.DataObject = "d_pip1003_4"
dw_main.SetTransObject(SQLCA)
dw_main.Reset()

dw_1.SetRedraw(True)
dw_main.SetRedraw(True)

sle_1.text = String(ld_rate)

p_inq.TriggerEvent(Clicked!)
end event

type dw_1 from datawindow within w_pip1003
boolean visible = false
integer x = 1829
integer y = 2552
integer width = 1815
integer height = 96
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_pip1003_1"
boolean border = false
boolean livescroll = true
end type

type sle_1 from singlelineedit within w_pip1003
integer x = 1696
integer y = 120
integer width = 201
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
end type

type st_2 from statictext within w_pip1003
integer x = 1522
integer y = 128
integer width = 155
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "요율"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pip1003
integer x = 2002
integer y = 112
integer width = 288
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "요율적용"
end type

event clicked;integer i
dec  drate
long ll_samt, ll_jamt

if dw_main.rowcount() < 1 then 
	messagebox("확인","조회한 후 적용하십시오!")
	return
end if



drate = dec(sle_1.text)

if rb_2.checked = true then  //건강보험
	For i = 1 to dw_main.rowcount()
		 ll_samt = dw_main.GetitemNumber(i,'medstandardwage')
		 
		 ll_samt = truncate(ll_samt * drate / 100 / 2 / 10,0) * 10
		 
		 dw_main.Setitem(i,'medselffine', ll_samt)	
	Next	
	
else                      //국민연금
	
	For i = 1 to dw_main.rowcount()
		 ll_samt = dw_main.GetitemNumber(i,'penstandardwage')
		 
		 ll_samt = truncate(ll_samt * drate / 100 / 10,0) * 10
		 
		 dw_main.Setitem(i,'penselffine', ll_samt)	
		 dw_main.Setitem(i,'pencompanyfine', ll_samt)	
		 
	Next	
	
		
		
end if	
	
	
end event

type rr_1 from roundrectangle within w_pip1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 530
integer y = 288
integer width = 3296
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 530
integer y = 48
integer width = 1943
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

