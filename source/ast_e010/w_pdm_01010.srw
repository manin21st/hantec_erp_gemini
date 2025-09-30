$PBExportHeader$w_pdm_01010.srw
$PBExportComments$영업팀 등록
forward
global type w_pdm_01010 from w_inherite
end type
type dw_area from u_key_enter within w_pdm_01010
end type
type rb_steam from radiobutton within w_pdm_01010
end type
type rb_sarea from radiobutton within w_pdm_01010
end type
type rb_area from radiobutton within w_pdm_01010
end type
type rb_market from radiobutton within w_pdm_01010
end type
type rr_1 from roundrectangle within w_pdm_01010
end type
type rr_2 from roundrectangle within w_pdm_01010
end type
end forward

global type w_pdm_01010 from w_inherite
integer x = 5
integer y = 4
string title = "영업팀 등록"
boolean resizable = true
dw_area dw_area
rb_steam rb_steam
rb_sarea rb_sarea
rb_area rb_area
rb_market rb_market
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01010 w_pdm_01010

type variables

end variables

forward prototypes
public function integer wf_requiredchk (integer il_currow)
public subroutine wf_changed_flag (datawindow dw_object)
end prototypes

public function integer wf_requiredchk (integer il_currow);String  sCode,sCodeName,sDeptCode, steamcd, ssaupj, sAreaCd

If dw_area.AcceptText() <> 1 Then Return -1

If il_currow <= 0 Then Return 1

If rb_steam.Checked Then
	sCode     = dw_area.GetItemString(il_currow,"steamcd")
	sCodeName = dw_area.GetItemString(il_currow,"steamnm") 
	sDeptCode = dw_area.GetItemString(il_currow,"deptcode")
	
	IF sCode ="" OR IsNull(sCode) THEN
		f_message_chk(30,'[영업팀]')
		dw_area.SetColumn("steamcd")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
	
	IF sCodeName ="" OR IsNull(sCodeName) THEN
		f_message_chk(30,'[영업팀명]')
		dw_area.SetColumn("steamnm")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
	
	IF sDeptCode ="" OR IsNull(sDeptCode) THEN
		f_message_chk(30,'[부서코드]')
		dw_area.SetColumn("deptcode")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF


ElseIf rb_sarea.Checked Then
	sCode     = dw_area.GetItemString(il_currow,"sarea")
	sCodeName = dw_area.GetItemString(il_currow,"sareanm") 
	sTeamCd   = dw_area.GetItemString(il_currow,"steamcd") 
	sDeptCode = dw_area.GetItemString(il_currow,"deptcode")
	sSaupj    = dw_area.GetItemString(il_currow,"saupj")
	
	IF sCode ="" OR IsNull(sCode) THEN
		f_message_chk(30,'[관할구역]')
		dw_area.SetColumn("sarea")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
	
	IF sCodeName ="" OR IsNull(sCodeName) THEN
		f_message_chk(30,'[관할구역명]')
		dw_area.SetColumn("sareanm")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
	
	IF sTeamCd ="" OR IsNull(sTeamCd) THEN
		f_message_chk(30,'[영업팀]')
		dw_area.SetColumn("steamcd")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
	
	IF sDeptCode ="" OR IsNull(sDeptCode) THEN
		f_message_chk(30,'[부서코드]')
		dw_area.SetColumn("deptcode")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
	
	IF sSaupj ="" OR IsNull(sSaupj) THEN
		f_message_chk(30,'[부가사업장]')
		dw_area.SetColumn("saupj")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
ElseIf rb_area.Checked  Then
	sCode     = dw_area.GetItemString(il_currow,"areacd")
	sCodeName = dw_area.GetItemString(il_currow,"areanm") 
	
	IF sCode ="" OR IsNull(sCode) THEN
		f_message_chk(30,'[지역코드]')
		dw_area.SetColumn("areacd")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
	
	IF sCodeName ="" OR IsNull(sCodeName) THEN
		f_message_chk(30,'[지역명]')
		dw_area.SetColumn("areanm")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
ElseIf rb_market.Checked Then
	sCode     = dw_area.GetItemString(il_currow,"marketcode")
	sCodeName = dw_area.GetItemString(il_currow,"marketname") 
	sAreaCd   = dw_area.GetItemString(il_currow,"areacd") 
	
	IF sCode ="" OR IsNull(sCode) THEN
		f_message_chk(30,'[시장코드]')
		dw_area.SetColumn("marketcode")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 
	
	IF sCodeName ="" OR IsNull(sCodeName) THEN
		f_message_chk(30,'[시장명]')
		dw_area.SetColumn("marketcode")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF
	
	IF sAreaCd ="" OR IsNull(sAreaCd) THEN
		f_message_chk(30,'[지역코드]')
		dw_area.SetColumn("areacd")
		dw_area.ScrollToRow(il_currow)
		dw_area.SetFocus()
		Return -1
	END IF 

End If

Return 1
end function

public subroutine wf_changed_flag (datawindow dw_object);Integer k

FOR k = 1 TO dw_Object.RowCount()
	dw_Object.SetItem(k,"flag",'1')
NEXT
end subroutine

event open;call super::open;		
rb_steam.TriggerEvent(Clicked!)

ib_any_typing = false
end event

on w_pdm_01010.create
int iCurrent
call super::create
this.dw_area=create dw_area
this.rb_steam=create rb_steam
this.rb_sarea=create rb_sarea
this.rb_area=create rb_area
this.rb_market=create rb_market
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_area
this.Control[iCurrent+2]=this.rb_steam
this.Control[iCurrent+3]=this.rb_sarea
this.Control[iCurrent+4]=this.rb_area
this.Control[iCurrent+5]=this.rb_market
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_pdm_01010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_area)
destroy(this.rb_steam)
destroy(this.rb_sarea)
destroy(this.rb_area)
destroy(this.rb_market)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type dw_insert from w_inherite`dw_insert within w_pdm_01010
boolean visible = false
integer x = 78
integer y = 2292
integer width = 654
integer height = 108
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01010
boolean visible = false
integer x = 727
integer y = 2308
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01010
boolean visible = false
integer x = 539
integer y = 2308
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdm_01010
boolean visible = false
integer x = 5
integer y = 2308
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdm_01010
integer x = 3442
end type

event p_ins::clicked;call super::clicked;
Int    il_currow,iRtnValue
String sCode

IF dw_area.RowCount() > 0 THEN
	iRtnValue = Wf_RequiredChk(dw_area.GetRow())
ELSE
	iRtnValue = 1
END IF

IF iRtnValue = 1 THEN
	il_CurRow = dw_area.InsertRow(0)
	
	dw_area.Setitem(il_currow, "flag", '0') 
	dw_area.ScrollToRow(il_currow)
	
	dw_area.setcolumn(1)
	dw_area.SetFocus()
	
	w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"
END IF
end event

type p_exit from w_inherite`p_exit within w_pdm_01010
integer x = 4137
end type

type p_can from w_inherite`p_can within w_pdm_01010
integer x = 3963
end type

event p_can::clicked;call super::clicked;
dw_area.SetRedraw(False)
IF dw_area.Retrieve() > 0 THEN
	dw_area.ScrollToRow(dw_area.RowCount())
END IF
dw_area.SetRedraw(True)

dw_area.SetColumn(1)
dw_area.SetFocus()

ib_any_typing = false
end event

type p_print from w_inherite`p_print within w_pdm_01010
boolean visible = false
integer x = 178
integer y = 2308
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdm_01010
boolean visible = false
integer x = 361
integer y = 2308
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_pdm_01010
integer x = 3790
end type

event p_del::clicked;call super::clicked;
Int il_currow

il_currow = dw_area.GetRow()
IF il_currow <=0 Then Return

IF f_msg_delete() = -1 THEN RETURN
	
dw_area.DeleteRow(il_currow)

IF dw_area.Update() > 0 THEN
	commit;
	IF il_currow = 1 OR il_currow <= dw_area.RowCount() THEN
	ELSE
		dw_area.ScrollToRow(il_currow - 1)
		dw_area.SetColumn(1)
		dw_area.SetFocus()
	END IF
	
	Wf_Changed_Flag(dw_area)
	
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite`p_mod within w_pdm_01010
integer x = 3616
end type

event p_mod::clicked;call super::clicked;Integer k
String  sCode

IF dw_area.Accepttext() = -1 THEN 	RETURN

IF dw_area.RowCount() > 0 THEN
	FOR k = 1 TO dw_area.RowCount()
		IF Wf_RequiredChk(k) = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_msg_update() = -1 THEN RETURN

IF dw_area.Update() > 0 THEN			
	COMMIT;
	ib_any_typing =False

	Wf_Changed_Flag(dw_area)
	
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
	Return
END IF

dw_area.ScrollToRow(dw_area.RowCount())
dw_area.Setfocus()

end event

type cb_exit from w_inherite`cb_exit within w_pdm_01010
integer x = 3145
integer y = 2604
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01010
integer x = 2089
integer y = 2604
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01010
integer x = 1746
integer y = 2608
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01010
integer x = 2441
integer y = 2604
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01010
integer x = 544
integer y = 2608
end type

type cb_print from w_inherite`cb_print within w_pdm_01010
integer x = 1390
integer y = 2608
end type

event cb_print::clicked;call super::clicked;//IF MessageBox("확인", "출력하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
//
//dw_1.print()
end event

type st_1 from w_inherite`st_1 within w_pdm_01010
integer x = 46
integer y = 2908
integer width = 320
end type

type cb_can from w_inherite`cb_can within w_pdm_01010
integer x = 2793
integer y = 2604
end type

type cb_search from w_inherite`cb_search within w_pdm_01010
integer x = 896
integer y = 2608
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_01010
integer x = 2789
integer y = 2908
integer width = 741
integer height = 84
end type

type sle_msg from w_inherite`sle_msg within w_pdm_01010
integer y = 2908
integer width = 2418
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01010
integer x = 23
integer y = 2856
integer width = 3525
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01010
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01010
end type

type dw_area from u_key_enter within w_pdm_01010
event ue_key pbm_dwnkey
integer x = 379
integer y = 240
integer width = 3895
integer height = 2032
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pdm_01010"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
//
//If rb_steam.Checked Then
//	if keydown(keytab!) OR KeyDown(KeyEnter!) and this.getcolumnname() = "deptcode" then
//		if this.rowcount() = this.getrow() then
//			cb_ins.Postevent(clicked!)
//		end if
//	ELSEIF keydown(keyF1!) THEN
//		TriggerEvent(RbuttonDown!)
//	END IF
//
//
//ELSEIf rb_sarea.Checked Then
//	if keydown(keytab!) OR KeyDown(KeyEnter!) and this.getcolumnname() = "saupj" then
//		if this.rowcount() = this.getrow() then
//			cb_ins.postevent(clicked!)
//		end if
//	ELSEIF keydown(keyF1!) THEN
//		TriggerEvent(RbuttonDown!)
//	END IF
//End If
//
end event

event editchanged;ib_any_typing =True
end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemfocuschanged;if this.GetColumnName() = "steamnm" then
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
else
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
end if

end event

event itemchanged;string sCode,snull,sDeptCode,sDeptname, sAreaCode, sareaname
Int    lReturnRow,lRow

SetNull(snull)

lRow = this.GetRow()

IF this.GetColumnName() ="sarea" THEN
	
	sCode = this.GetText()
	
	lReturnRow = this.find("sarea ='" + sCode +"'", 1, this.rowcount())

	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(1,'[관할구역코드]')
		this.SetItem(lRow, "sarea", sNull)
		RETURN  1
	END IF
END IF

/* 영업팀일 경우만 체크 */
IF rb_steam.Checked And this.GetColumnName() ="steamcd" THEN
	
	sCode = this.GetText()
	
	lReturnRow = this.find("steamcd ='" + sCode +"'", 1, this.rowcount())

	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(1,'[영업팀]')
		this.SetItem(lRow, "steamcd", sNull)
		RETURN  1
	END IF
END IF

IF this.GetColumnName() ="deptcode" THEN
	sDeptcode = this.GetText()
	
	IF sDeptcode ="" OR IsNull(sDeptcode) THEN 
		this.SetItem(lRow,"vndmst_cvnas2",snull)
		Return
	END IF
	
	SELECT "VNDMST"."CVNAS2"  	INTO :sDeptName  
    	FROM "VNDMST"  
   	WHERE ( "VNDMST"."CVCOD" = :sDeptCode ) AND ( "VNDMST"."CVGU" = '4' )   ;

	IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(RbuttonDown!)
		IF gs_code = "" OR IsNull(gs_code) THEN
			this.SetItem(lRow,"deptcode",snull)
			this.SetItem(lRow,"vndmst_cvnas2",snull)	
		END IF
		Return 1
	ELSE
		this.SetItem(lRow,"vndmst_cvnas2",sDeptName)
	END IF
End If

IF rb_area.Checked = False And this.GetColumnName() ="areacd" THEN
	
	sAreaCode = this.GetText()
	IF sAreaCode = "" OR IsNull(sAreaCode) THEN 
		this.SetItem(lRow,"areanm",snull)
		RETURN
	END IF
	
	SELECT "AREA"."AREANM"  INTO :sAreaName  
	   FROM "AREA"  
   	WHERE "AREA"."AREACD" = :sAreaCode   ;

	IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(lRow,"areanm",snull)
		END IF
		Return 1
	ELSE
		this.SetItem(lRow,"areanm",sAreaName)
	END IF
END IF

ib_any_typing =True
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'flag','1')
END IF
end event

event rbuttondown;
SetNull(Gs_Code)
SetNull(Gs_CodeName)

IF this.GetColumnName() = 'deptcode' THEN
	Open(w_vndmst_4_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"deptcode",gs_code)
	this.SetItem(this.GetRow(),"vndmst_cvnas2",gs_codename)
	
END IF

IF this.GetColumnName() = 'areacd' THEN
	Open(w_nation_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"areacd",gs_code)
	this.SetItem(this.GetRow(),"areanm",gs_codename)
	
END IF

ib_any_typing =True
end event

type rb_steam from radiobutton within w_pdm_01010
boolean visible = false
integer x = 480
integer y = 68
integer width = 347
integer height = 60
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "영업팀"
boolean checked = true
end type

event clicked;dw_area.DataObject = 'd_pdm_01010'
dw_area.SetTransObject(SQLCA)

IF dw_area.Retrieve() > 0 THEN
	dw_area.ScrollToRow(dw_area.RowCount())
END IF

dw_area.SetColumn("steamcd")
dw_area.SetFocus()
end event

type rb_sarea from radiobutton within w_pdm_01010
boolean visible = false
integer x = 869
integer y = 68
integer width = 347
integer height = 60
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "관할구역"
end type

event clicked;dw_area.DataObject = 'd_pdm_01015'
dw_area.SetTransObject(SQLCA)

IF dw_area.Retrieve() > 0 THEN
	dw_area.ScrollToRow(dw_area.RowCount())
END IF

dw_area.SetColumn("sarea")
dw_area.SetFocus()
end event

type rb_area from radiobutton within w_pdm_01010
boolean visible = false
integer x = 1257
integer y = 68
integer width = 430
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "지역(국가)"
end type

event clicked;dw_area.DataObject = 'd_pdm_01020'
dw_area.SetTransObject(SQLCA)

IF dw_area.Retrieve() > 0 THEN
	dw_area.ScrollToRow(dw_area.RowCount())
END IF

dw_area.SetColumn("areacd")
dw_area.SetFocus()
end event

type rb_market from radiobutton within w_pdm_01010
boolean visible = false
integer x = 1728
integer y = 68
integer width = 416
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "시장(상가)"
end type

event clicked;dw_area.DataObject = 'd_pdm_01030'
dw_area.SetTransObject(SQLCA)

IF dw_area.Retrieve() > 0 THEN
	dw_area.ScrollToRow(dw_area.RowCount())
END IF

dw_area.SetColumn("marketcode")
dw_area.SetFocus()
end event

type rr_1 from roundrectangle within w_pdm_01010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 366
integer y = 232
integer width = 3927
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01010
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 393
integer y = 24
integer width = 1810
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

