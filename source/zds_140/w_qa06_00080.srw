$PBExportHeader$w_qa06_00080.srw
$PBExportComments$**부품 검증 현황_한텍(17.12.04)
forward
global type w_qa06_00080 from w_inherite
end type
type cb_1 from commandbutton within w_qa06_00080
end type
type dw_ip from datawindow within w_qa06_00080
end type
type dw_list from datawindow within w_qa06_00080
end type
type p_1 from picture within w_qa06_00080
end type
type pb_1 from picturebutton within w_qa06_00080
end type
type p_2 from picture within w_qa06_00080
end type
type dw_hidden from datawindow within w_qa06_00080
end type
type p_isir1 from picture within w_qa06_00080
end type
type p_isir2 from picture within w_qa06_00080
end type
type p_isir3 from picture within w_qa06_00080
end type
type p_isir4 from picture within w_qa06_00080
end type
type st_2 from statictext within w_qa06_00080
end type
type st_3 from statictext within w_qa06_00080
end type
type st_4 from statictext within w_qa06_00080
end type
type st_5 from statictext within w_qa06_00080
end type
type st_6 from statictext within w_qa06_00080
end type
type st_7 from statictext within w_qa06_00080
end type
type st_8 from statictext within w_qa06_00080
end type
type st_9 from statictext within w_qa06_00080
end type
type rr_3 from roundrectangle within w_qa06_00080
end type
type rr_2 from roundrectangle within w_qa06_00080
end type
end forward

global type w_qa06_00080 from w_inherite
integer width = 4645
integer height = 2492
string title = "부품 검증 현황"
cb_1 cb_1
dw_ip dw_ip
dw_list dw_list
p_1 p_1
pb_1 pb_1
p_2 p_2
dw_hidden dw_hidden
p_isir1 p_isir1
p_isir2 p_isir2
p_isir3 p_isir3
p_isir4 p_isir4
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
st_8 st_8
st_9 st_9
rr_3 rr_3
rr_2 rr_2
end type
global w_qa06_00080 w_qa06_00080

type variables
String is_qcno

end variables

forward prototypes
public function integer wf_select_chk ()
public function integer wf_required_chk ()
public subroutine wf_init ()
public subroutine wf_change_image ()
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

dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

//f_mod_saupj(dw_ip, 'saupj')


end subroutine

public subroutine wf_change_image ();string		ls_path, ls_att_dt

ls_path = 'C:\erpman\image\'

// 미진행(빨간색) 이미지로 초기화
p_isir1.PictureName = ls_path + 'isir1_red.gif'
p_isir2.PictureName = ls_path + 'isir2_red.gif'
p_isir3.PictureName = ls_path + 'isir3_red.gif'
p_isir4.PictureName = ls_path + 'isir4_red.gif'

// 검사협정체결 이미지 변경
SELECT MAX(ATT_DT) INTO :ls_att_dt FROM QC_ISIR_FILE WHERE QCNEW_NO = :is_qcno  AND STEP_NO = '0';
If ls_att_dt > '.' Then
	p_isir1.PictureName = ls_path + 'isir1_green.gif'	// 등록
End If


// P1부품검증 이미지 변경
SELECT MAX(ATT_DT) INTO :ls_att_dt FROM QC_ISIR_FILE WHERE QCNEW_NO = :is_qcno  AND STEP_NO = '1';
If ls_att_dt > '.' Then
	p_isir1.PictureName = ls_path + 'isir2_green.gif'	// 등록
End If


// P2부품검증 이미지 변경
SELECT MAX(ATT_DT) INTO :ls_att_dt FROM QC_ISIR_FILE WHERE QCNEW_NO = :is_qcno  AND STEP_NO = '2';
If ls_att_dt > '.' Then
	p_isir1.PictureName = ls_path + 'isir3_green.gif'	// 등록
End If


// ISIR승인 이미지 변경
SELECT MAX(ATT_DT) INTO :ls_att_dt FROM QC_ISIR_FILE WHERE QCNEW_NO = :is_qcno  AND STEP_NO = '3';
If ls_att_dt > '.' Then
	p_isir1.PictureName = ls_path + 'isir4_green.gif'	// 등록
End If

end subroutine

on w_qa06_00080.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_ip=create dw_ip
this.dw_list=create dw_list
this.p_1=create p_1
this.pb_1=create pb_1
this.p_2=create p_2
this.dw_hidden=create dw_hidden
this.p_isir1=create p_isir1
this.p_isir2=create p_isir2
this.p_isir3=create p_isir3
this.p_isir4=create p_isir4
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.rr_3=create rr_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.p_2
this.Control[iCurrent+7]=this.dw_hidden
this.Control[iCurrent+8]=this.p_isir1
this.Control[iCurrent+9]=this.p_isir2
this.Control[iCurrent+10]=this.p_isir3
this.Control[iCurrent+11]=this.p_isir4
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.st_5
this.Control[iCurrent+16]=this.st_6
this.Control[iCurrent+17]=this.st_7
this.Control[iCurrent+18]=this.st_8
this.Control[iCurrent+19]=this.st_9
this.Control[iCurrent+20]=this.rr_3
this.Control[iCurrent+21]=this.rr_2
end on

on w_qa06_00080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ip)
destroy(this.dw_list)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.dw_hidden)
destroy(this.p_isir1)
destroy(this.p_isir2)
destroy(this.p_isir3)
destroy(this.p_isir4)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.rr_3)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_qa06_00080
boolean visible = false
integer x = 59
integer y = 1980
integer width = 4453
integer height = 288
integer taborder = 20
string dataobject = "d_qa06_00070_2"
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

type p_delrow from w_inherite`p_delrow within w_qa06_00080
boolean visible = false
integer x = 5189
integer y = 108
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qa06_00080
boolean visible = false
integer x = 4818
integer y = 332
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qa06_00080
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa06_00080
boolean visible = false
integer x = 4009
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qa06_00080
integer x = 4421
integer y = 48
end type

type p_can from w_inherite`p_can within w_qa06_00080
boolean visible = false
integer x = 4827
integer y = 168
integer taborder = 60
end type

event p_can::clicked;call super::clicked;wf_init()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

type p_print from w_inherite`p_print within w_qa06_00080
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa06_00080
integer x = 4238
integer y = 48
end type

event p_inq::clicked;call super::clicked;if dw_ip.accepttext() = -1 then return

string	sdate1, sdate2, sItnbr, sCvcod

sdate1 = trim(dw_ip.getitemstring(1,'d_st'))
if isnull(sdate1) or sdate1 = "" then sdate1 = '10000101'
sdate2 = trim(dw_ip.getitemstring(1,'d_ed'))
if isnull(sdate2) or sdate2 = "" then sdate2 = '99991231'
sItnbr = trim(dw_ip.getitemstring(1,'it_st'))
if isnull(sItnbr) or sItnbr = "" then sItnbr = '%'
sCvcod = trim(dw_ip.getitemstring(1,'cv_st'))
if isnull(sCvcod) or sCvcod = "" then sCvcod = '%'

//setpointer(hourglass!)
dw_list.setredraw(false)
if dw_list.retrieve(sdate1, sdate2,sItnbr, sCvcod) < 1 Then
	dw_list.setredraw(true)
	f_message_chk(50, '[부품 검증 현황]')
	dw_ip.setfocus()
	return
end if
dw_list.setredraw(true)

ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_qa06_00080
boolean visible = false
integer x = 4814
integer y = 656
integer taborder = 50
end type

type p_mod from w_inherite`p_mod within w_qa06_00080
boolean visible = false
integer x = 4809
integer y = 820
integer taborder = 40
end type

type cb_exit from w_inherite`cb_exit within w_qa06_00080
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qa06_00080
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qa06_00080
integer x = 942
integer y = 2344
integer taborder = 90
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qa06_00080
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qa06_00080
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_qa06_00080
integer x = 1874
integer y = 2348
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_qa06_00080
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within w_qa06_00080
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qa06_00080
integer x = 1371
integer y = 2348
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_qa06_00080
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within w_qa06_00080
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within w_qa06_00080
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qa06_00080
end type

type gb_button2 from w_inherite`gb_button2 within w_qa06_00080
end type

type cb_1 from commandbutton within w_qa06_00080
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

type dw_ip from datawindow within w_qa06_00080
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer width = 2473
integer height = 232
integer taborder = 90
string title = "none"
string dataobject = "d_qa06_00080_0"
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

event itemchanged;String ls_col ,ls_cod , ls_itdsc, ls_cvnas, SNULL
Long   ll_cnt ,ll_row

SETNULL(SNULL)

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())   

Choose Case ls_col
	Case "d_st" , "d_ed" 
		If ls_cod = '' Or isNull(ls_cod) Or f_datechk(ls_cod) < 0  Then
			f_message_chk(35 , '[제출기간]')
			SetColumn(ls_col)
			Return 1
		End If
		
	Case "it_st" 
		if ls_cod = "" or isnull(ls_cod) then 
			THIS.SETITEM(1, "it_st", SNULL)
			THIS.SETITEM(1, "itnm_st", SNULL)
			return 
		end if
	
		/* 품번 확인 */
		SELECT A.ITDSC
		  INTO :ls_itdsc
		  FROM "ITEMAS" A
		 WHERE A.ITNBR = :ls_cod; 
			 
		IF SQLCA.SQLCODE <> 0 THEN
			THIS.SETITEM(1, "it_st", SNULL)
			THIS.SETITEM(1, "itnm_st", SNULL)
			F_MESSAGE_CHK(33, '[품번]')
			RETURN 1
		END IF
		
		THIS.SETITEM(1, "itnm_st", ls_cvnas)

	Case "cv_st" 
		if ls_cod = "" or isnull(ls_cod) then 
			THIS.SETITEM(1, "cv_st", SNULL)
			THIS.SETITEM(1, "cvnm_st", SNULL)
			return 
		end if
	
		/* 거래처 확인 */
		SELECT A.CVNAS
		  INTO :ls_cvnas
		  FROM "VNDMST" A
		 WHERE A.CVCOD = :ls_cod
			AND A.CVGU IN ('1','2','9'); 
			 
		IF SQLCA.SQLCODE <> 0 THEN
			THIS.SETITEM(1, "cv_st", SNULL)
			THIS.SETITEM(1, "cvnm_st", SNULL)
			F_MESSAGE_CHK(33, '[거래처]')
			RETURN 1
		END IF
		
		THIS.SETITEM(1, "cvnm_st", ls_cvnas)


End Choose
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'it_st'	THEN
	Open(w_itemas_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(1,"it_st",gs_code)
	SetItem(1,"itnm_st",gs_codename)

ELSEIF this.GetColumnName() = 'cv_st'	THEN
	Open(w_vndmst_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(1,"cv_st",gs_code)
	SetItem(1,"cvnm_st",gs_codename)
END IF
end event

type dw_list from datawindow within w_qa06_00080
integer x = 41
integer y = 248
integer width = 4544
integer height = 2060
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa06_00080_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(row, True)

is_qcno = This.GetItemString(row, 'qcnew_no')

end event

event rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

is_qcno = This.GetItemString(currentrow, 'qcnew_no')
wf_change_image()
end event

event retrieveend;If rowcount < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(1, True )

is_qcno = This.GetItemString(1, 'qcnew_no')

end event

type p_1 from picture within w_qa06_00080
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

type pb_1 from picturebutton within w_qa06_00080
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

type p_2 from picture within w_qa06_00080
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
boolean visible = false
integer x = 4814
integer y = 492
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

type dw_hidden from datawindow within w_qa06_00080
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

type p_isir1 from picture within w_qa06_00080
integer x = 2921
integer width = 151
integer height = 132
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\isir1_red.gif"
boolean focusrectangle = false
end type

event clicked;If dw_list.GetSelectedRow(0) <= 0 Then
	MessageBox('확인','조회된 자료를 먼저 선택하세요!')
	Return
End If

gs_gubun = '0'		/* 진행단계(0-검사협정체결, 1-P1부품검증, 2-P2부품검증, 3-ISIR승인) */
gs_code = is_qcno
open(w_qa06_00080_popup)
wf_change_image()
end event

type p_isir2 from picture within w_qa06_00080
integer x = 3159
integer width = 151
integer height = 128
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\isir2_red.gif"
boolean focusrectangle = false
end type

event clicked;If dw_list.GetSelectedRow(0) <= 0 Then
	MessageBox('확인','조회된 자료를 먼저 선택하세요!')
	Return
End If

gs_gubun = '1'		/* 진행단계(0-검사협정체결, 1-P1부품검증, 2-P2부품검증, 3-ISIR승인) */
gs_code = is_qcno
open(w_qa06_00080_popup)
wf_change_image()
end event

type p_isir3 from picture within w_qa06_00080
integer x = 3397
integer width = 151
integer height = 128
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\isir3_red.gif"
boolean focusrectangle = false
end type

event clicked;If dw_list.GetSelectedRow(0) <= 0 Then
	MessageBox('확인','조회된 자료를 먼저 선택하세요!')
	Return
End If

gs_gubun = '2'		/* 진행단계(0-검사협정체결, 1-P1부품검증, 2-P2부품검증, 3-ISIR승인) */
gs_code = is_qcno
open(w_qa06_00080_popup)
wf_change_image()
end event

type p_isir4 from picture within w_qa06_00080
integer x = 3634
integer width = 151
integer height = 128
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\isir4_red.gif"
boolean focusrectangle = false
end type

event clicked;If dw_list.GetSelectedRow(0) <= 0 Then
	MessageBox('확인','조회된 자료를 먼저 선택하세요!')
	Return
End If

gs_gubun = '3'		/* 진행단계(0-검사협정체결, 1-P1부품검증, 2-P2부품검증, 3-ISIR승인) */
gs_code = is_qcno
open(w_qa06_00080_popup)
wf_change_image()
end event

type st_2 from statictext within w_qa06_00080
integer x = 2885
integer y = 140
integer width = 229
integer height = 48
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8388608
long backcolor = 32106727
string text = "검사협정"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_qa06_00080
integer x = 2885
integer y = 184
integer width = 229
integer height = 48
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8388608
long backcolor = 32106727
string text = "체결"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_qa06_00080
integer x = 3118
integer y = 136
integer width = 229
integer height = 48
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8388608
long backcolor = 32106727
string text = "P1"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_qa06_00080
integer x = 3118
integer y = 180
integer width = 229
integer height = 48
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8388608
long backcolor = 32106727
string text = "부품검증"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_qa06_00080
integer x = 3351
integer y = 136
integer width = 229
integer height = 48
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8388608
long backcolor = 32106727
string text = "P2"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_qa06_00080
integer x = 3351
integer y = 180
integer width = 229
integer height = 48
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8388608
long backcolor = 32106727
string text = "부품검증"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_8 from statictext within w_qa06_00080
integer x = 3593
integer y = 140
integer width = 229
integer height = 48
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8388608
long backcolor = 32106727
string text = "ISIR"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_9 from statictext within w_qa06_00080
integer x = 3593
integer y = 184
integer width = 229
integer height = 48
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8388608
long backcolor = 32106727
string text = "승인"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_3 from roundrectangle within w_qa06_00080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 240
integer width = 4562
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qa06_00080
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 1964
integer width = 4539
integer height = 344
integer cornerheight = 40
integer cornerwidth = 55
end type

