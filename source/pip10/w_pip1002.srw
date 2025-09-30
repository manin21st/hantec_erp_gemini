$PBExportHeader$w_pip1002.srw
$PBExportComments$** 급여항목 등록
forward
global type w_pip1002 from w_inherite_multi
end type
type gb_5 from groupbox within w_pip1002
end type
type gb_4 from groupbox within w_pip1002
end type
type gb_3 from groupbox within w_pip1002
end type
type rb_1 from radiobutton within w_pip1002
end type
type rb_2 from radiobutton within w_pip1002
end type
type dw_list from u_d_popup_sort within w_pip1002
end type
type dw_main from u_key_enter within w_pip1002
end type
type cb_localsudang from commandbutton within w_pip1002
end type
type cb_1 from commandbutton within w_pip1002
end type
type p_1 from uo_picture within w_pip1002
end type
type rr_1 from roundrectangle within w_pip1002
end type
type rr_2 from roundrectangle within w_pip1002
end type
type rr_3 from roundrectangle within w_pip1002
end type
end forward

global type w_pip1002 from w_inherite_multi
integer height = 2460
string title = "급여 항목 등록"
gb_5 gb_5
gb_4 gb_4
gb_3 gb_3
rb_1 rb_1
rb_2 rb_2
dw_list dw_list
dw_main dw_main
cb_localsudang cb_localsudang
cb_1 cb_1
p_1 p_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pip1002 w_pip1002

type variables
String spaytag,is_status,sAllowCode,sRefTbl,sRefGbn
end variables

forward prototypes
public subroutine wf_setting_dropdowndatawindow (string sflag)
public subroutine wf_reset ()
public function integer wf_requiredcheck (integer ll_row)
end prototypes

public subroutine wf_setting_dropdowndatawindow (string sflag);DataWindowChild dw_child
String  sTag,sReferGbn,snull
Int     lnull

SetNull(snull)
SetNull(lnull)

dw_main.AcceptText()
sTag    = dw_main.GetItemString(1,"referencetable")
sReferGbn = dw_main.GetItemString(1,"refgubn1")

IF sflag = '1' THEN
	dw_main.SetItem(1,"percentage",lnull)
	IF dw_main.GetChild("refgubn1",dw_child) = 1 THEN
		dw_child.SetTransObject(SQLCA)
		IF dw_child.Retrieve(stag) <=0 THEN
			dw_main.SetItem(1,"refgubn1",'00')
			dw_main.SetItem(1,"refgubn2",'00')
			dw_main.Modify("refgubn1.protect = 1")
			dw_main.Modify("refgubn2.protect = 1")
		ELSE
			dw_main.SetItem(1,"refgubn1",snull)
			dw_main.SetItem(1,"refgubn2",snull)
			dw_main.Modify("refgubn1.protect = 0")
		END IF
	END IF
	dw_main.Modify("refgubn2.protect = 1")
ELSE
	IF dw_main.GetChild("refgubn2",dw_child) = 1 THEN
		dw_child.SetTransObject(SQLCA)
		IF dw_child.Retrieve(stag,sReferGbn) <=0 THEN
			dw_main.SetItem(1,"refgubn2",'00')
			dw_main.Modify("refgubn2.protect = 1")
		ELSE
			dw_main.SetItem(1,"refgubn2",snull)
			dw_main.Modify("refgubn2.protect = 0")
		END IF
	END IF
END IF


end subroutine

public subroutine wf_reset ();DataWindowChild dw_child

dw_main.Reset()
IF dw_main.GetChild("refgubn1",dw_child) = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('1') <=0 THEN 
		dw_child.insertrow(0)
	END IF
END IF

IF dw_main.GetChild("refgubn2",dw_child) = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('1','01') <=0 THEN 
		dw_child.insertrow(0)
	END IF
END IF
dw_main.InsertRow(0)
dw_main.SetItem(1,"paysubtag",spaytag)	
dw_main.SetItem(1,"companycode",gs_company)	

IF dw_list.RowCount() <=0 THEN
	dw_list.InsertRow(0)
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(1,True)
	
	dw_main.Modify("allowcode.protect = 0")
	dw_main.Modify("refgubn2.protect  = 1")
	//dw_main.Modify("allowcode.background.color = '"+String(RGB(255,255,255))+"'")
	dw_main.SetColumn("allowcode")
	dw_main.SetFocus()
END IF

is_status = '1'													/*등록*/

end subroutine

public function integer wf_requiredcheck (integer ll_row);
String scode

scode  = dw_main.GetItemString(ll_row,"allowcode")

IF scode ="" OR IsNull(scode) THEN
	Messagebox("확 인","코드를 입력하세요!!")
	dw_main.SetColumn("allowcode")
	dw_main.SetFocus()
	Return -1
END IF

Return 1
end function

on w_pip1002.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_3=create gb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_list=create dw_list
this.dw_main=create dw_main
this.cb_localsudang=create cb_localsudang
this.cb_1=create cb_1
this.p_1=create p_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.dw_main
this.Control[iCurrent+8]=this.cb_localsudang
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.p_1
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rr_2
this.Control[iCurrent+13]=this.rr_3
end on

on w_pip1002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_list)
destroy(this.dw_main)
destroy(this.cb_localsudang)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;
dw_main.SetTransObject(SQLCA)

dw_list.SetTransObject(SQLCA)
dw_list.Reset()

wf_reset()

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)



end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1002
boolean visible = false
integer x = 3877
integer y = 2792
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1002
boolean visible = false
integer x = 3703
integer y = 2792
end type

type p_search from w_inherite_multi`p_search within w_pip1002
boolean visible = false
integer x = 3817
integer y = 2640
end type

type p_ins from w_inherite_multi`p_ins within w_pip1002
integer x = 3424
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredcheck(1)
	
	il_currow = dw_list.RowCount() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_list.InsertRow(il_currow)
	
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(il_currow,True)
	
	dw_main.SetRedraw(False)
	
	Wf_Reset()
	
	dw_main.Modify("allowcode.protect = 0")
	dw_main.Modify("refgubn2.protect  = 1")
	dw_main.Modify("allowcode.background.color = '"+String(RGB(255,255,255))+"'")
	dw_main.SetColumn("allowcode")
	dw_main.SetFocus()
	dw_main.SetRedraw(True)
	
	dw_main.setitem(1,"paysubtag",spaytag)
	dw_list.Enabled = False
	
	is_status = '1'												/*등록*/
END IF

end event

type p_exit from w_inherite_multi`p_exit within w_pip1002
integer x = 4416
end type

type p_can from w_inherite_multi`p_can within w_pip1002
integer x = 4242
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

dw_list.Enabled = True

ib_any_typing = false

p_inq.TriggerEvent(Clicked!)

end event

type p_print from w_inherite_multi`p_print within w_pip1002
boolean visible = false
integer x = 3803
integer y = 2952
end type

type p_inq from w_inherite_multi`p_inq within w_pip1002
integer x = 3250
end type

event p_inq::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

dw_list.SetRedraw(False)
IF dw_list.Retrieve(spaytag) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!",StopSign!)
	dw_list.SetRedraw(True)
	wf_reset()
	Return
ELSE
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(1,True)
	
	sAllowCode = dw_list.GetItemString(1,"allowcode")
	SELECT "P3_ALLOWANCE"."REFERENCETABLE",   "P3_ALLOWANCE"."REFGUBN1"  
   	INTO :sRefTbl,   								:sRefGbn  
	   FROM "P3_ALLOWANCE"  
   	WHERE "P3_ALLOWANCE"."ALLOWCODE" = :sAllowCode AND
				"P3_ALLOWANCE"."PAYSUBTAG" = :sPayTag ;
				
	dw_main.Retrieve(spaytag,dw_list.GetItemString(1,"allowcode"))
	dw_main.Modify("allowcode.protect = 1")
	dw_main.Modify("refgubn2.protect  = 0")
//	dw_main.Modify("allowcode.background.color ='"+String(RGB(192,192,192))+"'")
	
	dw_main.SetColumn("allowname")
//	dw_main.SetFocus()
END IF
dw_list.SetRedraw(True)

dw_list.Enabled = True

is_status = '2'												/*조회*/
w_mdi_frame.sle_msg.text = "조회"

end event

type p_del from w_inherite_multi`p_del within w_pip1002
integer x = 3771
end type

event p_del::clicked;
Int il_currow

il_currow = dw_list.GetSelectedRow(0)

IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return

sAllowCode = dw_list.GetItemString(il_currow,"allowcode")

if rb_1.checked = true then
	if sAllowCode = '01' then
		MessageBox("경고","삭제할 수 없는 코드입니다!")
		return 
	end if
else
	if sAllowCode = '01' or sAllowCode = '02' or sAllowCode = '03' or &
	       sAllowCode = '04' or sAllowCode = '05' then
		MessageBox("경고","삭제할 수 없는 코드입니다!")
		return 
	end if
end if
	
dw_list.DeleteRow(il_currow)

IF dw_list.Update() > 0 THEN
	COMMIT;
	IF dw_list.RowCount() <=0 THEN
		dw_main.Reset()
	ELSE
		IF il_currow = 1 THEN
			il_currow = 1	
		ELSE
			il_currow = il_currow - 1
		END IF
		
		dw_list.SelectRow(0,False)
		dw_list.SelectRow(il_currow,True)
		
		dw_main.Retrieve(spaytag,dw_list.GetItemString(il_currow,"allowcode"))
		dw_main.Modify("allowcode.protect = 1")
//		dw_main.Modify("allowcode.background.color ='"+String(RGB(192,192,192))+"'")
		
		dw_main.SetColumn("allowname")
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

type p_mod from w_inherite_multi`p_mod within w_pip1002
integer x = 3598
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_requiredcheck(dw_main.GetRow()) = -1 THEN RETURN
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

String sForm1P, sForm1B, sForm2P, sForm2B, sForm1, sForm2
dw_main.AcceptText()
sForm1P = dw_main.GetItemString(1,"calcform1_p")
sForm1B = dw_main.GetItemString(1,"calcform1_b")
sForm2P = dw_main.GetItemString(1,"calcform2_p")
sForm2B = dw_main.GetItemString(1,"calcform2_b")
if sForm1P = '' or IsNull(sForm1P) then sForm1P = '0'
if sForm1B = '' or IsNull(sForm1B) then sForm1B = '0'
if sForm2P = '' or IsNull(sForm2P) then sForm2P = '0'
if sForm2B = '' or IsNull(sForm2B) then sForm2B = '0'

if sForm1P <> '0' then
	sForm1 = sForm1P	
else
	sForm1 = ''
end if
if sForm1B <> '0' then
	sForm1 = sForm1 + ' ! '+ sForm1B	
end if

if sForm2P <> '0' then
	sForm2 = sForm2P	
else
	sForm2 = ''
end if
if sForm2B <> '0' then
	sForm2 = sForm2 + ' ! '+ sForm2B	
end if

dw_main.SetItem(1,"calcform1", sForm1)
dw_main.SetItem(1,"calcform2", sForm2)
IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	
	dw_main.Modify("allowcode.protect = 1")
//	dw_main.Modify("allowcode.background.color ='"+String(RGB(192,192,192))+"'")
	
	dw_main.SetColumn("allowname")
	dw_main.SetFocus()
	
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

dw_list.Enabled = True
		

end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1002
boolean visible = false
integer y = 2360
end type

type st_window from w_inherite_multi`st_window within w_pip1002
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip1002
boolean visible = false
integer y = 2772
integer taborder = 60
end type

type cb_exit from w_inherite_multi`cb_exit within w_pip1002
boolean visible = false
integer x = 1993
integer y = 2776
integer taborder = 100
end type

type cb_update from w_inherite_multi`cb_update within w_pip1002
boolean visible = false
integer x = 896
integer y = 2776
integer taborder = 70
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1002
boolean visible = false
integer x = 1801
integer y = 2468
integer height = 124
integer taborder = 0
end type

event cb_insert::clicked;call super::clicked;Int il_currow,il_functionvalue

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
	dw_main.SetItem(il_currow,"paysubtag",spaytag)
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("allowcode")
	dw_main.SetFocus()
	
	
END IF

end event

type cb_delete from w_inherite_multi`cb_delete within w_pip1002
boolean visible = false
integer x = 1262
integer y = 2776
integer taborder = 80
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1002
boolean visible = false
integer y = 2772
integer taborder = 30
end type

type st_1 from w_inherite_multi`st_1 within w_pip1002
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1002
boolean visible = false
integer x = 1627
integer y = 2776
integer taborder = 90
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1002
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1002
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1002
boolean visible = false
integer x = 855
integer y = 2716
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1002
boolean visible = false
integer y = 2712
integer width = 795
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1002
boolean visible = false
end type

type gb_5 from groupbox within w_pip1002
boolean visible = false
integer x = 1097
integer y = 2564
integer width = 558
integer height = 200
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_pip1002
boolean visible = false
integer x = 471
integer y = 2564
integer width = 617
integer height = 200
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_pip1002
integer x = 306
integer y = 80
integer width = 727
integer height = 160
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "지급공제구분"
end type

type rb_1 from radiobutton within w_pip1002
event clicked pbm_bnclicked
integer x = 375
integer y = 144
integer width = 293
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "지급"
boolean checked = true
end type

event clicked;
spaytag ='1'

p_inq.TriggerEvent(Clicked!)


end event

type rb_2 from radiobutton within w_pip1002
event clicked pbm_bnclicked
integer x = 686
integer y = 140
integer width = 293
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "공제"
end type

event clicked;
spaytag ='2'

p_inq.TriggerEvent(Clicked!)
end event

type dw_list from u_d_popup_sort within w_pip1002
integer x = 283
integer y = 284
integer width = 763
integer height = 1912
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pip1002_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;
If Row <= 0 then
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	is_status = '2'												/*조회*/

	sAllowCode = this.GetItemString(Row,"allowcode")

	SELECT "P3_ALLOWANCE"."REFERENCETABLE",   "P3_ALLOWANCE"."REFGUBN1"  
   	INTO :sRefTbl,   								:sRefGbn  
	   FROM "P3_ALLOWANCE"  
   	WHERE "P3_ALLOWANCE"."ALLOWCODE" = :sAllowCode AND
				"P3_ALLOWANCE"."PAYSUBTAG" = :sPayTag ;
				
	dw_main.Retrieve(spaytag, this.GetItemString(Row,"allowcode"))
	dw_main.Modify("allowcode.protect = 1")
//	dw_main.Modify("allowcode.background.color ='"+String(RGB(192,192,192))+"'")
	
	dw_main.SetColumn("allowname")
	dw_main.SetFocus()
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_main from u_key_enter within w_pip1002
integer x = 1330
integer y = 288
integer width = 2565
integer height = 1896
integer taborder = 20
string dataobject = "d_pip1002_2"
boolean border = false
boolean livescroll = false
end type

event itemchanged;Int il_currow,lReturnRow
String sallow,sallowname,snull,stag,sReferGbn,sName,sDate

SetNull(snull)

il_currow = this.GetRow()

IF this.GetColumnName() = "allowcode" THEN
	
	sallow = THIS.GETTEXT()								
	
	lReturnRow = dw_list.Find("allowcode = '"+sallow+"' ", 1, dw_list.RowCount() - 1)
	
	IF  lReturnRow > 0 THEN
		MessageBox("확인","등록된 수당코드입니다.~r등록할 수 없습니다.")
		this.SetItem(il_currow, "allowcode", sNull)
		RETURN  1
	ELSE
		dw_list.SetItem(dw_list.GetSelectedRow(0),"allowcode",sallow)
	END IF
END IF

IF this.GetColumnName() = "allowname" THEN
	sallowname = this.GetText()
	
	IF sallowname = "" OR IsNull(sallowname) THEN RETURN
	
	dw_list.SetItem(dw_list.GetSelectedRow(0),"allowname",sallowname)
END IF

IF this.GetColumnName() = "referencetable" THEN
	
	stag = THIS.GetText()								
	
	IF stag = "" OR IsNull(stag) THEN RETURN
	
	SELECT DISTINCT "P3_ALLOWANCEGUBN"."NAME1"  
   	INTO :sName  
   	FROM "P3_ALLOWANCEGUBN"  
   	WHERE "P3_ALLOWANCEGUBN"."GUBN1" = :stag   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 지급구분이 아닙니다!!")
		this.SetItem(1,"referencetable",snull)
		Return 1
	ELSE
		Wf_Setting_DropDownDataWindow('1')
	END IF
END IF

IF this.GetColumnName() = "refgubn1" THEN
	
	sReferGbn = THIS.GetText()								
	
	IF sReferGbn = "" OR IsNull(sReferGbn) THEN RETURN
	
	stag = this.GetItemString(1,"referencetable")
	
	SELECT DISTINCT "P3_ALLOWANCEGUBN"."NAME2"  
   	INTO :sName  
   	FROM "P3_ALLOWANCEGUBN"  
   	WHERE "P3_ALLOWANCEGUBN"."GUBN1" = :stag AND
				"P3_ALLOWANCEGUBN"."GUBN2"	= :sReferGbn ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 자료구분1이 아닙니다!!")
		this.SetItem(1,"refgubn1",snull)
		Return 1
	ELSE
		Wf_Setting_DropDownDataWindow('2')
	END IF
END IF

IF this.GetColumnName() = "initialdate1" THEN
	sDate = Trim(this.GetText())
	
	IF sDate ="" OR IsNull(sDate) THEN Return
	
	IF f_dateChk(sDate) = -1 THEN
		MessageBox("확 인","유효한 날짜가 아닙니다!!")
		this.SetItem(1,"initialdate1",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "daycalctag" THEN
	stag = Trim(this.GetText())
	
	IF stag ="" OR IsNull(stag) THEN Return
	
	IF stag = '1' THEN   //과세이면		
		this.SetItem(1,"backpaytag",snull)
	END IF
END IF




end event

event itemerror;
Return 1
end event

event editchanged;ib_any_typing =True


end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name = "allowname" THEN
	f_toggle_kor(handle(parent))
ELSE
	f_toggle_eng(handle(parent))
END IF
end event

event retrievestart;DataWindowChild dw_child
Int il_row

IF is_status = '1' THEN
	IF dw_main.GetChild("refgubn1",dw_child) = 1 THEN
		dw_child.SetTransObject(SQLCA)
		IF dw_child.Retrieve('1') <=0 THEN 
			dw_child.insertrow(0)
		END IF
	END IF
	
	IF dw_main.GetChild("refgubn2",dw_child) = 1 THEN
		dw_child.SetTransObject(SQLCA)
		IF dw_child.Retrieve('1','01') <=0 THEN 
			dw_child.insertrow(0)
		END IF
	END IF
ELSE
	IF dw_main.GetChild("refgubn1",dw_child) = 1 THEN
		dw_child.SetTransObject(SQLCA)
		il_row = dw_child.Retrieve(sRefTbl)
		IF dw_child.Retrieve(sRefTbl) <=0 THEN 
			dw_child.insertrow(0)
		END IF
	END IF
	
	IF dw_main.GetChild("refgubn2",dw_child) = 1 THEN
		dw_child.SetTransObject(SQLCA)
		il_row = dw_child.Retrieve(sRefTbl,sRefGbn)
		IF dw_child.Retrieve(sRefTbl,sRefGbn) <=0 THEN 
			dw_child.insertrow(0)
		END IF
	END IF
END IF
end event

event getfocus;//this.AcceptText()
end event

type cb_localsudang from commandbutton within w_pip1002
boolean visible = false
integer x = 503
integer y = 2624
integer width = 553
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "지역수당등록(&L)"
end type

type cb_1 from commandbutton within w_pip1002
boolean visible = false
integer x = 1125
integer y = 2624
integer width = 498
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "제외인원등록(&E)"
end type

type p_1 from uo_picture within w_pip1002
integer x = 3941
integer y = 24
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\제외인원등록_up.gif"
end type

event clicked;call super::clicked;String sAllowance,sAllowance_name

dw_main.AcceptText()

sAllowance      = dw_main.GetItemString(1,"allowcode")
sAllowance_name = dw_main.GetItemString(1,"allowname")

IF sAllowance = "" OR IsNull(sAllowance) OR sAllowance_name ="" OR IsNull(sAllowance_name) THEN RETURN

OpenWithParm(w_pip10022,spaytag+sAllowance+sAllowance_name)





end event

type rr_1 from roundrectangle within w_pip1002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 274
integer y = 276
integer width = 782
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip1002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1083
integer y = 276
integer width = 2990
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pip1002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 270
integer y = 52
integer width = 791
integer height = 212
integer cornerheight = 40
integer cornerwidth = 55
end type

