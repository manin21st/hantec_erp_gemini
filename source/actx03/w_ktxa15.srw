$PBExportHeader$w_ktxa15.srw
$PBExportComments$부도어음 대손공제 등록
forward
global type w_ktxa15 from w_inherite
end type
type gb_1 from groupbox within w_ktxa15
end type
type rb_1 from radiobutton within w_ktxa15
end type
type rb_2 from radiobutton within w_ktxa15
end type
type dw_condition from datawindow within w_ktxa15
end type
type dw_kfm02ot1 from datawindow within w_ktxa15
end type
type rr_1 from roundrectangle within w_ktxa15
end type
type dw_insert1 from datawindow within w_ktxa15
end type
type dw_update from datawindow within w_ktxa15
end type
end forward

global type w_ktxa15 from w_inherite
integer height = 2452
string title = "부도어음 대손공제 등록"
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_condition dw_condition
dw_kfm02ot1 dw_kfm02ot1
rr_1 rr_1
dw_insert1 dw_insert1
dw_update dw_update
end type
global w_ktxa15 w_ktxa15

type variables
string i_sin_dat
end variables

forward prototypes
public function integer wf_insert_kfm02ot1 ()
end prototypes

public function integer wf_insert_kfm02ot1 ();/************************************************************************************/
/* 부도어음대손공제Data 등록 															         	*/
/************************************************************************************/
String   sbill_no, sinsu_dat, sbudo_dat, sreason_cd, sgubun, ssano, sownam, scvnas, ssin_dat
Integer  k,iCnt,i,iCurRow
Double   sdaeson_amt

sle_msg.text ="부도어음 대손공제 등록 중 ..."

SetPointer(HourGlass!)

FOR k = 1 TO dw_insert1.RowCount()
	IF dw_insert1.GetItemString(k,"t_temp") = 'Y' THEN	
		
		dw_kfm02ot1.Reset()

		sbill_no    = dw_insert1.GetItemString(k,"kfm02ot1_bill_no")        //어음번호
		sdaeson_amt = dw_insert1.GetItemNumber(k,"kfm02ot1_daeson_amt")     //대손공제액
		sinsu_dat   = dw_insert1.GetItemString(k,"kfm02ot1_insu_dat")       //인수일
      sbudo_dat   = dw_insert1.GetItemString(k,"kfm02ot1_budo_dat")       //부도일
      sreason_cd  = dw_insert1.GetItemString(k,"kfm02ot1_reason_cd")    	 //사유
      sgubun      = dw_insert1.GetItemString(k,"kfm02ot1_gubun")      	 //공제변제구분
      ssano       = dw_insert1.GetItemString(k,"kfm02ot1_sano")	      	 //사업자번호
      sownam      = dw_insert1.GetItemString(k,"kfm02ot1_ownam")		    //대표자명
      scvnas      = dw_insert1.GetItemString(k,"kfm02ot1_cvnas")		    //상호
		ssin_dat    = dw_insert1.GetItemString(k,"kfm02ot1_sin_dat")		    //신고일

		iCurRow = dw_kfm02ot1.InsertRow(0)
		
		dw_kfm02ot1.SetItem(iCurRow,"bill_no",    sbill_no)
		dw_kfm02ot1.SetItem(iCurRow,"bill_amt",   dw_insert1.GetItemNumber(k,"kfm02ot1_bill_amt"))
		dw_kfm02ot1.SetItem(iCurRow,"budo_amt",   dw_insert1.GetItemNumber(k,"kfm02ot1_budo_amt"))
		dw_kfm02ot1.SetItem(iCurRow,"daeson_amt", sdaeson_amt)
		dw_kfm02ot1.SetItem(iCurRow,"insu_dat",   sinsu_dat)
		dw_kfm02ot1.SetItem(iCurRow,"budo_dat",   sbudo_dat)
		dw_kfm02ot1.SetItem(iCurRow,"reason_cd",  sreason_cd)
		dw_kfm02ot1.SetItem(iCurRow,"gubun",      sgubun)
   	dw_kfm02ot1.SetItem(iCurRow,"sano",       ssano)
    	dw_kfm02ot1.SetItem(iCurRow,"ownam",      sownam)	
    	dw_kfm02ot1.SetItem(iCurRow,"cvnas",      scvnas)			 
     	dw_kfm02ot1.SetItem(iCurRow,"sin_dat",    ssin_dat)			 
		 
		IF dw_kfm02ot1.Update() <> 1 THEN
			F_MessageChk(13,'[대손공제등록]')
			SetPointer(Arrow!)
			Return -1
		END IF
  END IF
NEXT
			


sle_msg.text ="부도어음 대손공제 등록 완료!!"

Return 1
end function

on w_ktxa15.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_condition=create dw_condition
this.dw_kfm02ot1=create dw_kfm02ot1
this.rr_1=create rr_1
this.dw_insert1=create dw_insert1
this.dw_update=create dw_update
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_condition
this.Control[iCurrent+5]=this.dw_kfm02ot1
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.dw_insert1
this.Control[iCurrent+8]=this.dw_update
end on

on w_ktxa15.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_condition)
destroy(this.dw_kfm02ot1)
destroy(this.rr_1)
destroy(this.dw_insert1)
destroy(this.dw_update)
end on

event open;call super::open;dw_condition.SetTransObject(sqlca)
dw_insert1.SetTransObject(sqlca)
dw_update.SetTransObject(sqlca)
dw_kfm02ot1.SetTransObject(sqlca)

dw_condition.reset()
dw_insert1.reset()
dw_update.reset()
dw_kfm02ot1.reset()

dw_condition.insertrow(0)
dw_condition.SetItem(1, 'acc_yymmdd', F_today())

dw_condition.SetColumn('acc_yymmdd')
dw_condition.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_ktxa15
boolean visible = false
integer x = 439
integer y = 2592
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa15
boolean visible = false
integer x = 4155
integer y = 2908
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa15
boolean visible = false
integer x = 3936
integer y = 2908
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa15
boolean visible = false
integer x = 3712
integer y = 2808
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_ktxa15
boolean visible = false
integer x = 4174
integer y = 2700
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_ktxa15
integer y = 0
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_ktxa15
integer y = 0
integer taborder = 100
end type

event p_can::clicked;call super::clicked;if rb_1.checked = true then
	dw_insert1.SetRedraw(false)
	dw_insert1.reset()
	dw_insert1.SetRedraw(true)
else
	dw_update.SetRedraw(false)
	dw_update.reset()
	dw_update.SetRedraw(true)
end if

end event

type p_print from w_inherite`p_print within w_ktxa15
boolean visible = false
integer x = 3918
integer y = 2672
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_ktxa15
integer x = 3749
integer y = 0
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string ls_acc_yymmdd

if dw_condition.AcceptText() = -1 then return
ls_acc_yymmdd = Trim(dw_condition.GetItemString(1, 'acc_yymmdd'))

if rb_1.checked = true then
	if dw_insert1.Retrieve() < 1 then 
		F_MessageChk(14, "")
		
	   dw_condition.SetColumn('acc_yymmdd')
		dw_condition.SetFocus()
		return 
	end if	
else
	if ls_acc_yymmdd = '' or isnull(ls_acc_yymmdd) then
		F_MessageChk(1, "[대손공제신고일]")
		dw_condition.Setcolumn('acc_yymmdd')
		dw_condition.SetFocus()
		return 
	end if

	if dw_update.Retrieve(ls_acc_yymmdd) < 1 then 
		F_MessageChk(14, "")
		
	   dw_condition.SetColumn('acc_yymmdd')
		dw_condition.SetFocus()
		return 
	end if
end if	

end event

type p_del from w_inherite`p_del within w_ktxa15
integer y = 0
integer taborder = 80
end type

event p_del::clicked;call super::clicked;long l_row

l_row = dw_update.GetRow()
dw_update.DeleteRow(l_row)

dw_update.update()
if sqlca.sqlcode <> 0 then
	ROLLBACK;
else	
	commit;
end if 	
//dw_update.update()
end event

type p_mod from w_inherite`p_mod within w_ktxa15
integer y = 0
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;String sChk,sGbn,sDate

IF rb_1.Checked =True THEN
	dw_insert1.AcceptText()
	IF dw_insert1.RowCount() <=0 THEN Return
	
	
	IF Wf_Insert_Kfm02ot1() = -1 THEN
		Rollback;
		Return
	END IF
	Commit;
	
	p_inq.TriggerEvent(Clicked!)
ELSE
	IF dw_update.RowCount() <=0 THEN Return
	
	IF dw_update.Update() <> 1 THEN
		F_MessageChk(12,'')
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF
w_mdi_frame.sle_msg.text = '자료를 처리하였습니다!'

end event

type cb_exit from w_inherite`cb_exit within w_ktxa15
integer x = 3209
integer y = 2640
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_ktxa15
integer x = 2126
integer y = 2640
integer taborder = 70
end type

type cb_ins from w_inherite`cb_ins within w_ktxa15
integer x = 2258
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_ktxa15
integer x = 2487
integer y = 2640
integer taborder = 90
end type

type cb_inq from w_inherite`cb_inq within w_ktxa15
integer x = 1774
integer y = 2640
integer taborder = 40
end type

event cb_inq::clicked;call super::clicked;string ls_acc_yymmdd

if dw_condition.AcceptText() = -1 then return
ls_acc_yymmdd = Trim(dw_condition.GetItemString(1, 'acc_yymmdd'))

if rb_1.checked = true then
	if dw_insert1.Retrieve() < 1 then 
		F_MessageChk(14, "")
		
	   dw_condition.SetColumn('acc_yymmdd')
		dw_condition.SetFocus()
		return 
	end if	
else
	if ls_acc_yymmdd = '' or isnull(ls_acc_yymmdd) then
		F_MessageChk(1, "[대손공제신고일]")
		dw_condition.Setcolumn('acc_yymmdd')
		dw_condition.SetFocus()
		return 
	end if

	if dw_update.Retrieve(ls_acc_yymmdd) < 1 then 
		F_MessageChk(14, "")
		
	   dw_condition.SetColumn('acc_yymmdd')
		dw_condition.SetFocus()
		return 
	end if
end if	

end event

type cb_print from w_inherite`cb_print within w_ktxa15
integer x = 1893
integer y = 2776
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_ktxa15
end type

type cb_can from w_inherite`cb_can within w_ktxa15
integer x = 2848
integer y = 2640
end type

type cb_search from w_inherite`cb_search within w_ktxa15
integer x = 2597
integer y = 2776
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_ktxa15
integer x = 41
integer y = 2584
integer width = 402
integer height = 180
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa15
integer x = 2089
integer y = 2584
integer width = 1486
integer height = 188
end type

type gb_1 from groupbox within w_ktxa15
integer x = 2473
integer y = 4
integer width = 1262
integer height = 152
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "작업선택"
end type

type rb_1 from radiobutton within w_ktxa15
integer x = 2519
integer y = 48
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "대손공제 등록"
boolean checked = true
end type

event clicked;IF rb_1.Checked =True THEN
	dw_insert1.Title ="부도어음 대손공제 등록"
	
	dw_insert1.Visible =True
	dw_update.Visible =False
	
	dw_insert1.reset()

END IF
dw_condition.SetColumn("acc_yymmdd")
dw_condition.SetFocus()

end event

type rb_2 from radiobutton within w_ktxa15
integer x = 3195
integer y = 48
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "대손공제 수정"
end type

event clicked;IF rb_2.Checked =True THEN
	dw_update.Title ="부도어음 대손공제 수정"
	
	dw_insert1.Visible =False
	dw_update.Visible =True
	
	dw_condition.AcceptText()
   i_sin_dat = dw_condition.GetItemString(1, 'acc_yymmdd')
	
	dw_update.reset()
END IF

dw_condition.SetColumn("acc_yymmdd")
dw_condition.SetFocus()
end event

type dw_condition from datawindow within w_ktxa15
integer x = 55
integer y = 16
integer width = 960
integer height = 136
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_ktxa151"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string ls_acc_yymmdd

if this.GetColumnName() = 'acc_yymmdd' then
	ls_acc_yymmdd = this.GetText()
	i_sin_dat = this.GetText()
	if trim(ls_acc_yymmdd) = '' or isnull(ls_acc_yymmdd) then 
		F_MessageChk(1, "[회계년월]")
		return 1
	else
		if F_dateChk(ls_acc_yymmdd) = -1 then 
			MessageBox("확 인", "유효한 회계년월이 아닙니다.!!")
			return 1
		end if
	end if
   cb_inq.TriggerEvent(Clicked!)
end if
end event

event itemerror;return 1
end event

type dw_kfm02ot1 from datawindow within w_ktxa15
boolean visible = false
integer x = 146
integer y = 2324
integer width = 1138
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "부도어음대손공제 저장"
string dataobject = "dw_ktxa154"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_ktxa15
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 164
integer width = 4544
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert1 from datawindow within w_ktxa15
event ue_enterkey pbm_dwnprocessenter
integer x = 73
integer y = 176
integer width = 4526
integer height = 2032
integer taborder = 50
string title = "대손공제등록"
string dataobject = "dw_ktxa152"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;send(handle(this), 256, 9, 0)
return 1

end event

event editchanged;ib_any_typing = true 
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF this.GetColumnName() ='saup_nm' or this.GetColumnName() = 'descr' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

// 상대처
if dwo.name = 'saup_no' then
	
	SetNUll(lstr_custom.code)
	SetNUll(lstr_custom.name)
	OpenWithParm(w_kfz04om0_popup, '1')
	
   this.SetItem(row, 'saup_no', lstr_custom.code)
   this.SetItem(Row, 'saup_nm', lstr_custom.name)
	this.TriggerEvent(ItemChanged!)
end if



end event

event rowfocuschanged;//if currentrow <= 0 then
//	this.SelectRow(0, FALSE)
//else
//	this.SelectRow(0, FALSE)
//	this.SelectRow(currentrow, TRUE)
//	this.ScrollToRow(currentrow)
//end if
//
end event

event itemchanged;String sBillNo, sInSuDate, sDaeSonDate,sSaupNo,sSelectFlag, sBill_JiGubun, sSaupNm, sSano, sOwname,sNull,sAddr1,sAddr2 
Long   lRow, lReturnRow
Double dBillAmt, dBudoAmt,dDaeSonAmt

SetNull(snull)

lRow = this.Getrow()
if this.GetcolumnName() = 'kfm02ot1_insu_dat' then 
	sInSuDate = Trim(this.GetText())
	if sInSuDate = '' or isnull(sInSuDate) then Return 
	
	sDaeSonDate = trim(dw_condition.GetItemString(1, 'acc_yymmdd'))
	IF sDaeSonDate = "" OR IsNull(sDaeSonDate) THEN Return
	
	if sDaeSonDate < sInSuDate then
		F_MessageChk(21, "[대손공제신고일<어음인수일]")
		this.SetItem(lRow,"kfm02ot1_insu_dat",snull)
		return 1
	end if
end if

if this.GetcolumnName() = 't_temp' then 
	sSelectFlag = this.GetText()
	
   sBill_JiGubun = this.GetItemString(lRow, 'kfm02ot0_bill_jigu') 	
	if sBill_Jigubun = '' or IsNull(sBill_Jigubun) then sBill_Jigubun = '1'
	
   sSaupNo     = this.GetItemString(lRow,'kfm02ot0_saup_no')
   sBillNo     = this.GetItemString(lRow,'kfm02ot0_bill_no')
	dBillAmt    = this.GetItemNumber(lRow,'kfm02ot0_bill_amt')
	dBudoAmt    = this.GetItemNumber(lRow,'kfm02ot0_budo_amt')
	sDaeSonDate = Trim(dw_condition.GetItemString(1, 'acc_yymmdd'))

	if sSelectFlag = 'Y' then 										 /* 대손공제등록 Check 'Y'*/
		dDaeSonAmt = (dBillAmt - dBudoAmt) * 10 / 100		
		
		this.SetItem(lRow, 'kfm02ot1_bill_no',    sBillNo)                 
		this.SetItem(lRow, 'kfm02ot1_daeson_amt', dDaeSonAmt) 		         
		this.SetItem(lRow, 'kfm02ot1_bill_amt',   dBillAmt)              
		this.SetItem(lRow, 'kfm02ot1_budo_amt',   dBudoAmt)              
		this.SetItem(lRow, 'kfm02ot1_sin_dat',    sDaeSonDate)          
      
		if sBill_JiGubun = '1' then 		/* 어음지급구분이 '1'이면 대표자명,상호,사업자번호 */
			SELECT "VNDMST"."CVNAS",		"VNDMST"."SANO" ,	"VNDMST"."OWNAM", "VNDMST"."ADDR1", "VNDMST"."ADDR2"
				INTO :sSaupNm,   	         :sSano,				:sOwname,			:sAddr1,				:sAddr2
				FROM "VNDMST"  
				WHERE "VNDMST"."CVCOD" = :sSaupNo   ;
				
			this.SetItem(lRow, 'kfm02ot1_cvnas', sSaupNm)              //상호
			this.SetItem(lRow, 'kfm02ot1_sano', sSano)               //사업자번호
			this.SetItem(lRow, 'kfm02ot1_ownam',sOwname)                   //대표자명
			this.SetItem(lRow, 'kfm02ot1_addr1',sAddr1)             
			this.SetItem(lRow, 'kfm02ot1_addr2',sAddr2)  

		end if
	else  																	/* 대손공제등록 Check 'N'*/
		this.SetItem(lRow, 'kfm02ot1_bill_no', snull)  
  		this.SetItem(lRow, 'kfm02ot1_daeson_amt', 0)  
		this.SetItem(lRow, 'kfm02ot1_cvnas', '')  
		this.SetItem(lRow, 'kfm02ot1_sano', '')  
	end if
end if

ib_any_typing =True
end event

type dw_update from datawindow within w_ktxa15
event ue_enterkey pbm_dwnprocessenter
boolean visible = false
integer x = 73
integer y = 172
integer width = 4517
integer height = 2032
integer taborder = 30
string title = "대손공제수정"
string dataobject = "dw_ktxa153"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;send(handle(this), 256, 9, 0)
return 1

end event

event editchanged;cb_mod.enabled = true
ib_any_typing = true 
end event

event itemchanged;string ls_bill_no, ls_plan_day, ls_seq_no, ls_acc_yymmdd, &
       ls_saup_no, ls_saup_nm, get_code, get_name, snull, sFindCol, &
		 ls_t_temp, ls_bill_jigu, ls_person_cd, ls_person_nm, ls_person_no, ls_sin_dat  
long lRow, lReturnRow, ls_bill_amt, ls_budo_amt, ls_daeson_amt


SetNull(snull)

lRow = this.Getrow()

if this.GetcolumnName() = 'kfm02ot1_insu_dat' then 
	
	ls_plan_day = this.GetText()
	
	if trim(ls_plan_day) = '' or isnull(ls_plan_day) then 
		F_MessageChk(1, "[일자]")
		return 1
	else
		ls_acc_yymmdd = trim(dw_condition.GetItemString(dw_condition.GetRow(), 'acc_yymmdd'))
		if F_dateChk(ls_acc_yymmdd + ls_plan_day) = -1 then
			F_MessageChk(21, "[일자]")
			return 1
		end if
	end if
	
end if

ib_any_typing =True
end event

event itemerror;return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF this.GetColumnName() ='saup_nm' or this.GetColumnName() = 'descr' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF

end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

// 상대처
if dwo.name = 'saup_no' then
	
	SetNUll(lstr_custom.code)
	SetNUll(lstr_custom.name)
	OpenWithParm(w_kfz04om0_popup, '1')
	
   this.SetItem(row, 'saup_no', lstr_custom.code)
   this.SetItem(Row, 'saup_nm', lstr_custom.name)
	this.TriggerEvent(ItemChanged!)
end if



end event

event rowfocuschanged;//if currentrow <= 0 then
//	this.SelectRow(0, FALSE)
//else
//	this.SelectRow(0, FALSE)
//	this.SelectRow(currentrow, TRUE)
//	this.ScrollToRow(currentrow)
//end if
//


end event

