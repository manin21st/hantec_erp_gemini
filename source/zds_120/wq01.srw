$PBExportHeader$wq01.srw
$PBExportComments$초도품 승인 등록
forward
global type wq01 from w_inherite
end type
type cb_1 from commandbutton within wq01
end type
type dw_ip from datawindow within wq01
end type
type dw_list from datawindow within wq01
end type
type p_1 from picture within wq01
end type
type pb_1 from picturebutton within wq01
end type
type p_2 from picture within wq01
end type
type dw_hidden from datawindow within wq01
end type
type rr_3 from roundrectangle within wq01
end type
type rr_2 from roundrectangle within wq01
end type
type rr_1 from roundrectangle within wq01
end type
end forward

global type wq01 from w_inherite
integer width = 4663
integer height = 2656
string title = "초도품 승인 등록"
cb_1 cb_1
dw_ip dw_ip
dw_list dw_list
p_1 p_1
pb_1 pb_1
p_2 p_2
dw_hidden dw_hidden
rr_3 rr_3
rr_2 rr_2
rr_1 rr_1
end type
global wq01 wq01

forward prototypes
public function integer wf_select_chk ()
public function integer wf_required_chk ()
public subroutine wf_init ()
end prototypes

public function integer wf_select_chk ();If dw_ip.AcceptText() < 1 Then Return -1
If dw_ip.RowCount() < 1 Then Return -1

String ls_date_st , ls_date_ft ,ls_gubun , ls_saupj
Long   ll_row

ls_date_st = Trim(dw_ip.Object.sdate[1])
ls_date_ft = Trim(dw_ip.Object.edate[1])
//ls_saupj   = Trim(dw_ip.Object.saupj[1])
ls_gubun   = Trim(dw_ip.Object.cvgub[1])

If ls_date_st = '' Or isNull(ls_date_st) Or f_datechk(ls_date_st) < 0  Then
	f_message_chk(35 , '[접수일자]')
	dw_ip.SetColumn("sdate")
	Return -1
End If

If ls_date_ft = '' Or isNull(ls_date_ft) Or f_datechk(ls_date_ft) < 0  Then
	f_message_chk(35 , '[접수일자]')
	dw_ip.SetColumn("edate")
	Return -1
End If

//If ls_saupj = '' Or isNull(ls_saupj) Then
//	f_message_chk(1400 , '[사업장]')
//	dw_ip.SetColumn("saupj")
//	Return -1
//End If
return 1
end function

public function integer wf_required_chk ();If dw_insert.AcceptText() < 1 Then Return -1
If dw_insert.RowCount() < 1 Then Return -1

String sQanew_no, sItnbr , sCvcod ,sCvgub ,sAct_dt ,sResult, sAccept_dt, sAccept_emp, ls_cnf_dt, ls_insert_dt, ls_insert_txt, sdate, sjpno
Long   ll_row, ll_Cnt, lseq

dw_list.AcceptText()
dw_list.SetFocus()
ll_Cnt = dw_list.Rowcount()	
IF dw_list.ModifiedCount() >= 1 THEN 
	DO WHILE ll_row <= ll_Cnt
		ll_Row = dw_list.GetNextModified(ll_row, Primary!)
		IF ll_Row > 0 THEN
			sQanew_no = Trim(dw_list.Object.qanew_no[ll_row])
			If sQanew_no = '' Or isNull(sQanew_no) Then
				sdate = string(f_today(),'yyyymmdd')
				lseq  = sqlca.fun_junpyo(gs_sabu,sdate,'E2')
				sjpno = sdate + string(lseq,'000')
				dw_list.setitem(ll_row,'qanew_no',sjpno)
			End If
			
			sItnbr   = Trim(dw_list.Object.itnbr[ll_row])
			If sItnbr = '' Or isNull(sItnbr) Then
				f_message_chk(33 , '[품번]')
				dw_insert.SetColumn("itnbr")
				dw_insert.SetFocus()
				Return -1
			End If

			sCvcod   = Trim(dw_list.Object.cvcod[ll_row])	
			If sCvcod = '' Or isNull(sCvcod) Then
				f_message_chk(33 , '[제출업체]')
				dw_insert.SetColumn("cvcod")
				dw_insert.SetFocus()
				Return -1
			End If
			
			ls_insert_dt  = Trim(dw_list.Object.insert_dt[ll_row])
			If f_datechk(ls_insert_dt) < 0  Then
				f_message_chk(35 , '[제출일자]')
				dw_insert.SetColumn("insert_dt")
				dw_insert.SetFocus()
				Return -1
			End If
			
			ls_insert_txt  = Trim(dw_list.Object.insert_txt[ll_row])
			If ls_insert_txt = '' Or isNull(ls_insert_txt) Then
				f_message_chk(33 , '[사유]')
				dw_insert.SetColumn("insert_txt")
				dw_insert.SetFocus()
				Return -1
			End If
		ELSE
				EXIT
		END IF
	LOOP
END IF

//sCvgub   = Trim(dw_insert.Object.cvgub[1])
//sAct_dt  = Trim(dw_insert.Object.act_dt[1])
//sAccept_dt  = Trim(dw_insert.Object.accept_dt[1])
//sAccept_emp = Trim(dw_insert.Object.accept_emp[1])
//sResult  = Trim(dw_insert.Object.result_yn[1])
//ls_cnf_dt  = Trim(dw_insert.Object.cnf_dt[1])

//If f_datechk(sAct_dt) < 0  Then
//	f_message_chk(35 , '[처리일자]')
//	dw_insert.SetColumn("act_dt")
//	dw_insert.SetFocus()
//	Return -1
//End If
//
//If f_datechk(sAccept_dt) < 0 Then
//	f_message_chk(33 , '[접수일자]')
//	dw_insert.SetColumn("accept_dt")
//	dw_insert.SetFocus()
//	Return -1
//End If
//
//If sAccept_emp = '' Or isNull(sAccept_emp) Then
//	f_message_chk(33 , '[접수자]')
//	dw_insert.SetColumn("accept_emp")
//	dw_insert.SetFocus()
//	Return -1
//End If
//
//If sResult = '' Or isNull(sResult) Then
//	f_message_chk(33 , '[판정]')
//	dw_insert.SetColumn("result_yn")
//	dw_insert.SetFocus()
//	Return -1
//End If

//If sResult = 'Y' and f_datechk(ls_cnf_dt) < 0 Then
//	f_message_chk(33 , '[승인일자]')
//	dw_insert.SetColumn("cnf_dt")
//	dw_insert.SetFocus()
//	Return -1
//End If

return 1
end function

public subroutine wf_init ();dw_ip.Reset()
dw_ip.InsertRow(0)

dw_insert.Reset()
dw_insert.InsertRow(0)

dw_ip.SetItem(1, 'sdate', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))

f_mod_saupj(dw_ip, 'saupj')


end subroutine

on wq01.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_ip=create dw_ip
this.dw_list=create dw_list
this.p_1=create p_1
this.pb_1=create pb_1
this.p_2=create p_2
this.dw_hidden=create dw_hidden
this.rr_3=create rr_3
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.p_2
this.Control[iCurrent+7]=this.dw_hidden
this.Control[iCurrent+8]=this.rr_3
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.rr_1
end on

on wq01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ip)
destroy(this.dw_list)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.dw_hidden)
destroy(this.rr_3)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

wf_init()
end event

type dw_insert from w_inherite`dw_insert within wq01
integer x = 59
integer y = 1352
integer width = 4453
integer height = 880
integer taborder = 20
string dataobject = "d_kumqm_00230_3_new"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String ls_col ,ls_cod, snull
Long   ll_cnt ,ll_row
String   sitnbr, sitdsc, sispec, sjijil, sispeccode, sData, sItnbrGbn, sPangb, lsItnbrYn
Long    lRow
Integer nRtn, i

ib_any_typing = True //입력필드 변경여부 Yes

setnull(snull)
ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())

Choose Case ls_col
	Case "itnbr" 
		
		String ls_itdsc ,ls_ispec ,ls_jijil
		
		Select itdsc , ispec , jijil 
		  Into :ls_itdsc , :ls_ispec ,:ls_jijil
		  From itemas 
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itnbr[GetRow()] = ""
			Return 1
		End If
		
		This.Object.itdsc[GetRow()] = ls_itdsc	
		This.Object.ispec[GetRow()] = ls_ispec	
		This.Object.jijil[GetRow()] = ls_jijil	
	Case "citnbr" 
		If Trim(ls_cod) = '' OR IsNull(ls_cod) Then
			This.SetItem(getrow(), 'citdsc', snull)
			Return
		End If
		
		This.SetItem(getrow(), 'citdsc', f_get_name5('13', ls_cod, ''))
//	Case  "itdsc"                   // 품명입력시
//		sItDsc = trim(GetText())	
//		IF sItDsc = ""	or	IsNull(sItDsc)	THEN Return
//
//		/* 품명으로 품번찾기 */
//		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
//		If IsNull(sItnbr) Then
//			this.TriggerEvent(RbuttonDown!)
//			Return 1
//		ElseIf sItnbr <> '' Then
//			SetItem(lRow,"itnbr",sItnbr)
//		ELSE
//			Return 1
//		End If	
	Case "cvcod"
		String ls_cvgub
		String ls_cvnas , ls_sale , ls_gumae ,ls_oyju , ls_oyjuga ,ls_yongyn 
		Select cvnas , 
		       nvl(saleyn  ,'N') , 
				 nvl(gumaeyn ,'N')  , 
				 nvl(oyjuyn  ,'N')  , 
				 nvl(oyjugayn,'N')  , 
				 nvl(yongyn  ,'N')  
		  Into :ls_cvnas , :ls_sale , :ls_gumae ,:ls_oyju , :ls_oyjuga ,:ls_yongyn 
		  From vndmst
		  Where cvcod = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[거래처]")
			This.Object.cvcod[GetRow()] = ""
			Return 1
		End If
		
		This.Object.cvnas[GetRow()] = ls_cvnas
		
		If ls_sale = 'Y' Then
//			If ls_gumae = 'Y' or ls_oyju = 'Y' or ls_oyjuga = 'Y' or ls_yongyn = 'Y' Then
//				ls_cvgub = ''
//			Else
				ls_cvgub = '1'		// 고객사
//			End If
		Else
//			If ls_gumae = 'Y' or ls_oyju = 'Y' or ls_oyjuga = 'Y' or ls_yongyn = 'Y' Then
				ls_cvgub = '2'		// 협력사
//			Else
//				ls_cvgub = ''
//			End If
		End If
		
		This.Object.cvgub[GetRow()] = ls_cvgub
	Case "ccvcod"
		If Trim(ls_cod) = '' OR IsNull(ls_cod) Then
			This.SetItem(getrow(), 'ccvnas', snull)
			Return
		End If
		
		This.SetItem(getrow(), 'ccvnas', f_get_name5('11', ls_cod, ''))

	Case "accept_emp"
		If Trim(ls_cod) = '' OR IsNull(ls_cod) Then
			This.SetItem(getrow(), 'empname', snull)
			Return
		End If
		
		This.SetItem(getrow(), 'empname', f_get_name5('02', ls_cod, ''))
		
End Choose

end event

event dw_insert::rbuttondown;String ls_cod
Long   ll_row

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ll_row = GetRow()

Choose Case Lower(GetColumnName())
	Case "itnbr"
//		gs_code = this.GetText()
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.itnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')
	Case "citnbr"
//		gs_code = this.GetText()
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.citnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')
	Case 'cvcod'
//		gs_code = this.GetText()
		open(w_vndmst_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.cvcod[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')		
	Case 'ccvcod'
//		gs_code = this.GetText()
		open(w_vndmst_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.ccvcod[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')		
	Case 'accept_emp'
		gs_gubun = gs_dept
		open(w_sawon_popup)
		if isnull(gs_code) or gs_code = '' then return
		This.Object.accept_emp[ll_row] = gs_code
		
		TriggerEvent('ItemChanged')
End Choose

end event

event dw_insert::ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dw_insert::ue_pressenter;If Lower(GetColumnName()) ="bad_txt" Then
	Return
Else
	Send(Handle(this),256,9,0)
	Return 1
End if
end event

event dw_insert::buttonclicked;call super::buttonclicked;if dwo.name = 'b_1' then
	string	sitnbr, smindt
	
	sitnbr = this.getitemstring(1,'itnbr')
	
	select min(io_date) into :smindt from imhist
	 where sabu = :gs_sabu and iogbn = 'O02' and itnbr = :sitnbr ;

	if isnull(smindt) or smindt = '' then
	else
		this.setitem(1,'act_dt',smindt)
	end if
end if
end event

type p_delrow from w_inherite`p_delrow within wq01
boolean visible = false
integer x = 5189
integer y = 108
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within wq01
boolean visible = false
integer x = 5015
integer y = 108
integer taborder = 0
end type

type p_search from w_inherite`p_search within wq01
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within wq01
boolean visible = false
integer x = 4009
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within wq01
integer x = 4425
integer y = 36
end type

type p_can from w_inherite`p_can within wq01
integer x = 4242
integer y = 36
integer taborder = 60
end type

event p_can::clicked;call super::clicked;wf_init()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

type p_print from w_inherite`p_print within wq01
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within wq01
integer x = 3694
integer y = 36
end type

event p_inq::clicked;call super::clicked;if dw_ip.accepttext() = -1 then return

string	sdate1, sdate2, sItnbr, sCvgub

sdate1 = trim(dw_ip.getitemstring(1,'sdate'))
if isnull(sdate1) or sdate1 = "" then sdate1 = '10000101'
sdate2 = trim(dw_ip.getitemstring(1,'edate'))
if isnull(sdate2) or sdate2 = "" then sdate2 = '99991231'
//sItnbr = dw_ip.getitemstring(1,'itnbr')
//if isnull(sItnbr) or trim(sItnbr) = '' then sItnbr = '%'

//dw_insert.reset()
//dw_insert.insertrow(0)

String ls_saupj

ls_saupj = dw_ip.GetItemString(1, 'saupj')
sCvgub = dw_ip.GetItemString(1, 'cvgub')

//setpointer(hourglass!)
dw_list.setredraw(false)
//if dw_list.retrieve(sdate1,sdate2,sItnbr,gs_saupj) < 1 then
if dw_list.retrieve(sdate1, sdate2,ls_saupj, sCvgub) < 1 Then
	dw_list.setredraw(true)
	f_message_chk(50, '[초도품 승인 등록]')
	dw_ip.setfocus()
	return
end if
dw_list.setredraw(true)

ib_any_typing = false
end event

type p_del from w_inherite`p_del within wq01
integer x = 4059
integer y = 36
integer taborder = 50
end type

event p_del::clicked;call super::clicked;//if dw_list.rowcount() <= 0 then return
//if f_msg_delete() = -1 then return
//
//dw_list.deleterow(0)
//
//if dw_list.update() = 1 then
//	commit ;
//else
//	rollback ;
//	messagebox("삭제실패", "ISIR 승인이력 삭제 실패!!!")
//end if
//
//ib_any_typing = false

Long   row

row = dw_list.GetRow()
If row < 1 Then Return

If f_msg_delete() <> 1 Then Return

dw_list.DeleteRow(row)

If dw_list.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	f_message_chk(32, '[초도품 승인 자료 삭제 실패!]')
	Return
End If


end event

type p_mod from w_inherite`p_mod within wq01
integer x = 3877
integer y = 36
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;//If dw_list.AcceptText() <> 1 Then Return -1
//If dw_list.RowCount() < 1 Then Return
//
//SetPointer(HourGlass!)
//
//If wf_required_chk() < 1 then Return
//If f_msg_update() = -1 Then Return  //저장 Yes/No ?
//
//If dw_list.Update() <> 1 Then
//	ROLLBACK;
//	f_message_chk(32,'[자료저장 실패]') 
//	Return
//Else
//	Commit ;
//	p_inq.TriggerEvent(Clicked!)
//End If
//
//ib_any_typing = False //입력필드 변경여부 No
//
//SetPointer(Arrow!)
// 

dw_insert.AcceptText()

Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

If f_msg_update() <> 1 Then Return

//-----------------------------------------------------
If dw_insert.GetItemStatus(row, 0, Primary!) = DataModified! Then
Else
	//관리번호 생성
	String ls_day
	
	ls_day = String(TODAY(), 'yyyymm')
	
	String ls_max
	
	Long   ll_ser
	
	SELECT MAX(SUBSTR(QCNEW_NO, 7, 3))
	  INTO :ls_max
	  FROM QC_SAMPL
	 WHERE QCNEW_NO LIKE :ls_day||'%' ;
	If Trim(ls_max) = '' OR IsNull(ls_max) Then
		ll_ser = 1
	Else
		ll_ser = Long(ls_max) + 1
	End If
	
	String ls_jpno
	
	ls_jpno = ls_day + String(ll_ser, '000')
	dw_insert.SetItem(row, 'qcnew_no', ls_jpno )
	
	String ls_saupj
	
	ls_saupj = dw_insert.GetItemString(row, 'saupj')
	If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = gs_saupj
	
	dw_insert.SetItem(row, 'saupj'   , ls_saupj)
	//-------------------------------------------------
End If

String ls_qcno
ls_qcno = dw_insert.GetItemString(row, 'qcnew_no')
If Trim(ls_qcno) = '' OR IsNull(ls_qcno) Then
	f_message_chk(1400, '[초도품 관리번호]')
	dw_insert.SetColumn('qcnew_no')
	dw_insert.SetFocus()
	Return
End If

String ls_itnbr
ls_itnbr = dw_insert.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then
	f_message_chk(1400, '[품번]')
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	Return
End If

String ls_vnd
ls_vnd = dw_insert.GetItemString(row, 'cvcod')
If Trim(ls_vnd) = '' OR IsNull(ls_vnd) Then
	f_message_chk(1400, '[고객사]')
	dw_insert.SetColumn('cvcod')
	dw_insert.SetFocus()
	Return
End If

//String ls_date
//ls_date = dw_insert.GetItemString(row, 'insert_dt')
//If Trim(ls_date) = '' OR IsNull(ls_date) Then
//	f_message_chk(1400, '[의뢰일자]')
//	dw_insert.SetColumn('insert_dt')
//	dw_insert.SetFocus()
//	Return
//End If

//String ls_gavnd
//ls_gavnd = dw_insert.GetItemString(row, 'ganam')
//If Trim(ls_gavnd) = '' OR IsNull(ls_gavnd) Then
//	f_message_chk(1400, '[가공업체]')
//	dw_insert.SetColumn('ganam')
//	dw_insert.SetFocus()
//	Return
//End If

String ls_eono
ls_eono = dw_insert.GetItemString(row, 'eo_no')
If Trim(ls_eono) = '' OR IsNull(ls_eono) Then
	f_message_chk(1400, '[E.O No.]')
	dw_insert.SetColumn('eo_no')
	dw_insert.SetFocus()
	Return
End If

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	p_inq.PostEvent('Clicked')
Else
	ROLLBACK USING SQLCA;
	f_message_chk(32, '[자료 저장 실패]')
	Return
End If

ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within wq01
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within wq01
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within wq01
integer x = 942
integer y = 2344
integer taborder = 90
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within wq01
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within wq01
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within wq01
integer x = 1874
integer y = 2348
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within wq01
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within wq01
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within wq01
integer x = 1371
integer y = 2348
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within wq01
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within wq01
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within wq01
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within wq01
end type

type gb_button2 from w_inherite`gb_button2 within wq01
end type

type cb_1 from commandbutton within wq01
boolean visible = false
integer x = 2267
integer y = 2344
integer width = 576
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "BOM사용내역 조회"
end type

type dw_ip from datawindow within wq01
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 55
integer y = 52
integer width = 3127
integer height = 116
integer taborder = 90
string title = "none"
string dataobject = "d_kumqm_00230_1_new"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)

END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;String ls_col ,ls_cod , ls_cvnas, SNULL
Long   ll_cnt ,ll_row

SETNULL(SNULL)

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())   

Choose Case ls_col
	Case "sdate" , "edate" 
		If ls_cod = '' Or isNull(ls_cod) Or f_datechk(ls_cod) < 0  Then
			f_message_chk(35 , '[접수일자]')
			SetColumn(ls_col)
			Return 1
		End If
		
	Case "cvcod" 
		if ls_cod = "" or isnull(ls_cod) then 
			THIS.SETITEM(1, "CVCOD", SNULL)
			THIS.SETITEM(1, "CVNAS", SNULL)
			return 
		end if
	
		/* 거래처 확인 */
		SELECT A.CVNAS
		  INTO :ls_cvnas
		  FROM "VNDMST" A
		 WHERE A.CVCOD = :ls_cod
			AND A.CVGU IN ('1','2','9'); 
			 
		IF SQLCA.SQLCODE <> 0 THEN
			THIS.SETITEM(1, "CVCOD", SNULL)
			THIS.SETITEM(1, "CVNAS", SNULL)
			F_MESSAGE_CHK(33, '[거래처]')
			RETURN 1
		END IF
		
		THIS.SETITEM(1, "CVNAS", ls_cvnas)


End Choose
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'itnbr'	THEN
	Open(w_itemas_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(1,"itnbr",gs_code)
	SetItem(1,"itdsc",gs_codename)
END IF
end event

type dw_list from datawindow within wq01
integer x = 50
integer y = 220
integer width = 4507
integer height = 1056
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_kumqm_00230_2_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(row, True)

String ls_qcno

ls_qcno = This.GetItemString(row, 'qcnew_no')
If Trim(ls_qcno) = '' OR IsNull(ls_qcno) Then
	MessageBox('관리번호 확인', '관리번호를 확인 하십시오.')
	Return
End If

If dw_insert.Retrieve(ls_qcno) < 1 Then
	dw_insert.InsertRow(0)
End If

end event

event rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

String ls_qcno

ls_qcno = This.GetItemString(currentrow, 'qcnew_no')
If Trim(ls_qcno) = '' OR IsNull(ls_qcno) Then
	MessageBox('관리번호 확인', '관리번호를 확인 하십시오.')
	Return
End If

If dw_insert.Retrieve(ls_qcno) < 1 Then
	dw_insert.InsertRow(0)
End If
//
//
//Long lrow
//String ls_no
//
//lrow = currentrow
//if lrow <= 0 then return
//
//dw_insert.scrolltorow(lrow)
//
////ls_no = Trim(Object.qanew_no[lrow])
////If ls_no = '' Or isNull(ls_no) Then Return
////	
////If dw_insert.Retrieve(ls_no) < 1 Then
////	dw_insert.Reset()
////	dw_insert.InsertRow(0)
////	p_del.Enabled = False
////	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
////Else
////	p_del.Enabled = True
////	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
////End If
//
end event

event retrieveend;If rowcount < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(1, True )

String ls_qcno

ls_qcno = This.GetItemString(1, 'qcnew_no')
If Trim(ls_qcno) = '' OR IsNull(ls_qcno) Then
	MessageBox('관리번호 확인', '관리번호를 확인 하십시오.')
	Return
End If

If dw_insert.Retrieve(ls_qcno) < 1 Then
	dw_insert.InsertRow(0)
End If

end event

type p_1 from picture within wq01
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3223
integer y = 2336
integer width = 178
integer height = 144
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\ERPMAN\image\복사_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

event clicked;if dw_list.rowcount() <= 0 then return

Integer j
Long lnewrow, lrow, lseq, lrcnt, lMax
String sDate, sJpno

lrow = dw_list.getrow()
lnewrow = lrow + 1
if lrow <= 0 then 
	messagebox('확인','선택된 행이 없습니다.')
	return -1
else
//	lnewrow = dw_list.insertrow(0)
	sJpno = string(Long(dw_list.object.max_no[1]) + 1)
	dw_list.RowsCopy(lrow, lrow, Primary!, dw_list, lnewrow, Primary!)
	dw_list.accepttext()
	dw_list.setitem(lnewrow,'qanew_no',sjpno)
	dw_list.setitem(lnewrow,'saupj',gs_saupj)
	dw_list.scrolltorow(lnewrow)
//	dw_list.setitem(lnewrow,'qanew_no',sjpno)
//	dw_list.setitem(lnewrow,'saupj',gs_saupj)
//	dw_list.scrolltorow(lnewrow)
	dw_insert.setfocus()
	dw_insert.setcolumn('insert_dt')
end if

ib_any_typing = true
end event

type pb_1 from picturebutton within wq01
boolean visible = false
integer x = 2949
integer y = 2336
integer width = 375
integer height = 144
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "제출업체선택"
boolean originalsize = true
vtextalign vtextalign = vcenter!
end type

event clicked;//if dw_ip.accepttext() <> 1 then return
//
//String scvcod, scvnas, sqweno, sopt, sDate, sJpno
//Long lrow, k, lrowcnt, lseq, lMax 
//
//gs_gubun = dw_ip.object.itnbr[1]
//if gs_gubun = "" or isnull(gs_gubun) then 
//	f_message_chk(30,'[품번]')
//	dw_ip.setcolumn('itnbr')
//	dw_ip.setfocus()
//	return -1
//end if
//
//gs_code = "%"
//gs_codename = "%"
//
//open(w_vndmst_popup_qa)
//if gs_code = "" or isnull(gs_code) then return
//
//SetPointer(HourGlass!)
//
//lrowcnt = dw_insert.rowcount()
//
//dw_hidden.reset()
//dw_hidden.ImportClipboard()
//	
//for k = 1 to dw_hidden.rowcount()
//	sopt = dw_hidden.getitemstring(k, 'opt')
//	if sopt  = 'Y' then
//		if dw_list.rowcount() > 0 then
//			sJpno = string(Long(dw_list.object.max_no[1]) + 1)
//		else
//			sDate = left(f_today(),6)
//			
//			SELECT TO_NUMBER(MAX(SUBSTR(QANEW_NO,7,3)))
//			INTO :lMax
//			FROM QC_SAMPL
//			WHERE SUBSTR(QANEW_NO,1,6) = :sDate;
//			
//			if isnull(lMax) or lMax = 0 then
//				lMax = 1
//			else
//				lMax = lMax + 1
//			end if
//			sJpno = sDate + string(lMax,'000')
//		end if
//
//		lrow  = dw_list.insertrow(0)
//		
//		dw_list.setitem(lrow,'qanew_no',sJpno)
//		
//		scvcod = dw_hidden.getitemstring(k, 'cvcod' )
//		scvnas = dw_hidden.getitemstring(k, 'cvnas' )
//		
//		dw_list.setItem(lrow,"itnbr",gs_gubun)
//		dw_list.setItem(lrow,"cvcod",scvcod)
//		dw_list.setitem(lrow,'vndmst_cvnas', scvnas)
//		dw_list.setitem(lrow, 'saupj', gs_saupj)
//	end if
//next	
//
//dw_list.ScrollToRow(lrow)
//dw_list.setrow(lrow)
//dw_list.SetColumn("insert_dt")
//dw_list.SetFocus()
//
//ib_any_typing = true
//
//
end event

type p_2 from picture within wq01
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 3511
integer y = 36
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\ERPMAN\image\추가_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"

end event

event clicked;//Long lnewrow, lseq, lMax
//String sDate, sJpno, sMax
//
//sDate = left(f_today(),6)
//
//SELECT TO_NUMBER(MAX(SUBSTR(QANEW_NO,7,3)))
//INTO :lMax
//FROM QC_SAMPL
//WHERE SUBSTR(QANEW_NO,1,6) = :sDate;
//
//if isnull(lMax) or lMax = 0 then
//	lMax = 1
//else
//	lMax = lMax + 1
//end if
//
//sJpno = sDate + string(lMax,'000')
//
//if dw_list.rowcount() > 0 then
//	sJpno = string(Long(dw_list.object.max_no[1]) + 1)
//end if
//	
//lnewrow = dw_list.insertrow(0)
//
//dw_insert.setitem(lnewrow,'saupj',gs_saupj)
//dw_insert.setitem(lnewrow,'qanew_no',sjpno)
//
//dw_list.scrolltorow(lnewrow)
//dw_insert.setfocus()
//dw_insert.setcolumn('insert_dt')
//
//ib_any_typing = true
//--------------------------------------------------------------------
dw_insert.ReSet()

Long   row

row = dw_insert.InsertRow(0)
If row < 1 Then Return

dw_insert.SetItem(row, 'saupj'   , dw_ip.GetItemString(1, 'saupj'))

end event

type dw_hidden from datawindow within wq01
boolean visible = false
integer x = 3227
integer y = 2360
integer width = 128
integer height = 108
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_vndmst_popup_qa"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_3 from roundrectangle within wq01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 212
integer width = 4539
integer height = 1076
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within wq01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 1312
integer width = 4539
integer height = 996
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within wq01
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 36
integer width = 3214
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

