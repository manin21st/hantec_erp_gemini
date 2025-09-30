$PBExportHeader$w_kglb17.srw
$PBExportComments$승인전표 수정(적요)
forward
global type w_kglb17 from w_inherite
end type
type dw_cond from u_key_enter within w_kglb17
end type
type dw_2 from u_d_select_sort within w_kglb17
end type
type dw_rtv from datawindow within w_kglb17
end type
type dw_1 from datawindow within w_kglb17
end type
type rr_1 from roundrectangle within w_kglb17
end type
type rr_2 from roundrectangle within w_kglb17
end type
end forward

global type w_kglb17 from w_inherite
string title = "승인전표 수정(적요)"
boolean ib_any_typing = true
dw_cond dw_cond
dw_2 dw_2
dw_rtv dw_rtv
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_kglb17 w_kglb17

type variables
String sJunpoyGbn = 'A'
end variables

on w_kglb17.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_2=create dw_2
this.dw_rtv=create dw_rtv
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_rtv
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_kglb17.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_2)
destroy(this.dw_rtv)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(dw_cond.GetRow(),"saupj",     gs_saupj)
//dw_cond.SetItem(dw_cond.GetRow(),"dept_cd",   gs_dept)
dw_cond.SetItem(dw_cond.GetRow(),"fromdate",  Left(f_today(),6)+'01')
dw_cond.SetItem(dw_cond.GetRow(),"todate",    f_today())

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_cond.Modify("saupj.protect = 1")
	dw_cond.Modify("dept_cd.protect = 1")
ELSE
	dw_cond.Modify("saupj.protect = 0")
	dw_cond.Modify("dept_cd.protect = 0")
END IF	

dw_cond.SetColumn("fromdate")
dw_cond.SetFocus()

dw_2.SetTransObject(SQLCA)
dw_2.Reset()

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

ib_any_typing = False
end event

type dw_insert from w_inherite`dw_insert within w_kglb17
boolean visible = false
integer x = 165
integer y = 2656
integer width = 1298
integer height = 100
integer taborder = 0
boolean titlebar = true
string title = "미승인전표 라인별 저장"
string dataobject = "dw_kglc013"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

type p_delrow from w_inherite`p_delrow within w_kglb17
boolean visible = false
integer x = 1975
integer y = 2984
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglb17
boolean visible = false
integer x = 1801
integer y = 2984
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglb17
boolean visible = false
integer x = 2149
integer y = 2984
integer taborder = 40
string picturename = "C:\Erpman\image\승인취소_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\승인취소_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\승인취소_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kglb17
boolean visible = false
integer x = 1627
integer y = 2984
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglb17
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kglb17
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kglb17
boolean visible = false
integer x = 2496
integer y = 2988
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglb17
integer x = 3922
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;Long   lJunNoFrom,lJunNoTo  
String sSaupj,sDeptCode,sBalDateFrom,sBalDateTo,sUpmuGbn,sAllGbn

dw_1.Reset()

w_mdi_frame.sle_msg.text =""

dw_cond.AcceptText()
sSaupj       = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sDeptCode    = dw_cond.GetItemString(dw_cond.GetRow(),"dept_cd")
lJunNoFrom   = dw_cond.GetItemNumber(dw_cond.GetRow(),"fromno") 
lJunNoTo     = dw_cond.GetItemNumber(dw_cond.GetRow(),"tono") 
sBalDateFrom = dw_cond.GetItemString(dw_cond.GetRow(),"fromdate") 
sBalDateTo   = dw_cond.GetItemString(dw_cond.GetRow(),"todate") 
sUpmuGbn     = dw_cond.GetItemString(dw_cond.GetRow(),"upmu_gu") 

IF sSaupj = "" or IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	return
END IF

IF sDeptCode = "" or IsNull(sDeptCode) THEN sDeptCode = '%'

IF lJunNoFrom = 0 OR IsNull(lJunNoFrom) THEN	lJunNoFrom = 1

IF lJunNoTo = 0 OR IsNull(lJunNoTo) THEN	lJunNoTo = 1

IF sBalDateFrom = "" or IsNull(sBalDateFrom) THEN
	F_MessageChk(1,'[승인일자]')
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	return
END IF
	
IF sBalDateTo = "" or IsNull(sBalDateTo) THEN
	F_MessageChk(1,'[승인일자]')
	dw_cond.SetColumn("todate")
	dw_cond.SetFocus()
	return
END IF

IF sBalDateFrom > sBalDateTo THEN
   MessageBox("확 인", "날짜의 범위 지정이 잘못되었습니다! 승인일자를 확인하십시오")
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	Return
END IF

IF sUpmuGbn = "" OR IsNull(sUpmuGbn) THEN	sUpmuGbn = '%'

dw_2.Reset()
IF dw_2.Retrieve(sSaupj,sDeptCode,sBalDateFrom,sBalDateTo,lJunNoFrom,lJunNoTo,sUpmuGbn) <=0 THEN
	F_MessageChk(14,'')
	Return
END IF

dw_1.Reset()

w_mdi_frame.sle_msg.text ="승인 전표를 조회하였습니다.!!"
end event

type p_del from w_inherite`p_del within w_kglb17
boolean visible = false
integer x = 2322
integer y = 2984
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglb17
integer x = 4096
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;Integer i

IF F_DbConFirm('저장') = 2 THEN Return

dw_1.accepttext()

If dw_1.rowcount() <= 0 Then Return

w_mdi_frame.sle_msg.text =""

For i = 1 To dw_1.rowcount()
	
	If Isnull(Trim(dw_1.getitemstring(i, "kfz10ot0_descr"))) Or Len(Trim(dw_1.getitemstring(i, "kfz10ot0_descr"))) = 0 Then
		Messagebox("확인", String(i) + "행 적요를 확인하십시오")
		dw_1.setrow(i)
		dw_1.scrolltorow(i)
		dw_1.setfocus()
		Return
	End if
	
Next

If dw_1.Update() < 0 Then
	Rollback;
	Messagebox("확인", "저장시 오류가 발생했습니다")
	dw_1.setfocus()
	Return
End if

Commit;

w_mdi_frame.sle_msg.text ="정상적으로 저장되었습니다"
end event

type cb_exit from w_inherite`cb_exit within w_kglb17
boolean visible = false
integer x = 3264
integer y = 2584
end type

type cb_mod from w_inherite`cb_mod within w_kglb17
boolean visible = false
integer x = 2807
integer y = 2560
integer width = 439
integer height = 116
string text = "승인취소(&S)"
end type

event cb_mod::clicked;call super::clicked;//*************************************************************************************//
//   전표승인취소처리																						//																															
// 1. 승인 TABLE(KFZ10OT0) --> 미승인 TABLE(KFZ12OT0) 갱신										//
//    # 승인전표 TABLE의 전표번호는 삭제TABLE에 보관한다.										//
// 2. KFZ12OT0(미승인 TABLE)의 승인구분을 "N"로 update 											//
// 3. KFZ10OT0의 지급어음구분,받을어음구분,접대비유무,부가세유무,차입금구분				//
//					   															유가증권구분이 "Y" 이면 //
//    지급어음 TABLE,받을어음 TABLE,접대비 TABLE,부가세 TABLE,차입금 TABLE					//
//		유가증권 TABLE에 승인구분은 "N",회계일자,회계승인번호를 부여							// 
//*************************************************************************************//
String  sAccDate,sBalDate,sSaupj,sUpmuGbn,sAlcGbn = 'N'
Integer iSelectedRow,iCurRow,iRowCount,k,i,iFindRow,iMisungInRow
Long    lLinNo,lJunNo,lBJunNo

SetNull(sAccDate)
	
iSelectedRow =	dw_2.GetSelectedRow(0)
If iSelectedRow <= 0 then
   MessageBox("확 인", "승인취소 할 자료를 선택후 승인취소버튼을 누르십시오 !")
   Return
END IF

DO WHILE true
	iCurRow = 	dw_2.GetSelectedRow(0)
	If iCurRow = 0 then EXIT
	
	sSaupj   = dw_2.GetItemString(iCurRow,"saupj")						
	sBalDate = dw_2.GetItemString(iCurRow,"bal_date") 
	sUpmuGbn = dw_2.GetItemString(iCurRow,"upmu_gu") 
	lBJunNo  = dw_2.GetItemNumber(iCurRow,"bjun_no")
	
	sAccDate = dw_2.GetItemString(iCurRow,"acc_date") 					/*승인*/
	lJunNo   = dw_2.GetItemNumber(iCurRow,"jun_no") 
	
	dw_rtv.Reset()
	dw_insert.Reset()									

	iRowCount    = dw_rtv.Retrieve(sSaupj,sAccDate,sUpmuGbn,lJunNo)		/*승인*/
	iMiSungInRow = dw_insert.Retrieve(sSaupj,sBalDate,sUpmuGbn,lBJunNo) 	/*미승인*/
	FOR k = iRowCount TO 1 Step -1
		lLinNo = dw_rtv.GetItemNumber(k,"lin_no")
		
		dw_rtv.DeleteRow(k)
		
		iFindRow = dw_insert.Find("saupj = '" + sSaupj + "'and bal_date = '" + sBalDate + &
								"'and upmu_gu = '" + sUpmuGbn + "'and sbjun_no = '" + String(lBJunNo) + &
								"'and slin_no = '" + String(lLinNo) + "'",1,iMiSungInRow)
		dw_insert.SetItem(iFindRow,"alc_gu",sAlcGbn)
										
	NEXT
	IF dw_rtv.Update() <> 1 THEN
		F_MessageChk(13,'[승인전표]')
		ROLLBACK;
		return
	END IF
	IF dw_insert.Update() <> 1 THEN
		F_MessageChk(13,'[미승인전표]')
		ROLLBACK;
		return
	END IF	
	
	IF F_Control_Junpoy_History('D',	sSaupj, sAccDate,	sUpmuGbn, lJunNo, sBalDate, &
										 '',  '',   'A') = -1  THEN
		F_MessageChk(13,'[전표 이력]')
		Rollback;
		Return
	END IF
	
	dw_2.SelectRow(iCurRow,FALSE)
LOOP

String sJipFrom,sJipTo,sJipFlag

SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)    INTO :sJipFlag  				/*집계 여부*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 8 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN 
	sJipFlag = 'N'
ELSE
	IF IsNull(sJipFlag) OR sJipFlag = "" THEN sJipFlag = 'N'
END IF

IF sJipFlag = 'Y' THEN
	sJipFrom = dw_2.GetItemString(1,"min_ym")
	sJipTo   = dw_2.GetItemString(1,"max_ym")
	
	//stored procedure로 계정별,거래처별 상위 집계 처리(시작년월,종료년월)
	sle_msg.text ="계정별,거래처별 월집계 갱신처리 중입니다..."
	F_ACC_SUM(sJipFrom,sJipTo)

	//stored procedure로 사업부문별 상위 집계 처리(시작년월,종료년월)
	sle_msg.text ="사업부문별 월집계 갱신처리 중입니다..."
	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
	
	//stored procedure로 사업부문별 거래처별 상위 집계 처리(시작년월,종료년월)
	sle_msg.text ="사업부문별 거래처별 월집계 갱신처리 중입니다..."
	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
END IF

COMMIT;

SLE_MSG.TEXT ="승인 취소 처리 완료!!"

cb_inq.TriggerEvent(Clicked!)

SLE_MSG.TEXT =""



end event

type cb_ins from w_inherite`cb_ins within w_kglb17
boolean visible = false
integer x = 2043
integer y = 2472
end type

type cb_del from w_inherite`cb_del within w_kglb17
boolean visible = false
integer x = 1641
integer y = 2616
end type

type cb_inq from w_inherite`cb_inq within w_kglb17
boolean visible = false
integer x = 2235
integer y = 2544
end type

event cb_inq::clicked;call super::clicked;
Long   lJunNoFrom,lJunNoTo  
String sSaupj,sDeptCode,sBalDateFrom,sBalDateTo,sUpmuGbn,sAllGbn

dw_1.Reset()

sle_msg.text =""

dw_cond.AcceptText()
sSaupj       = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sDeptCode    = dw_cond.GetItemString(dw_cond.GetRow(),"dept_cd")
lJunNoFrom   = dw_cond.GetItemNumber(dw_cond.GetRow(),"fromno") 
lJunNoTo     = dw_cond.GetItemNumber(dw_cond.GetRow(),"tono") 
sBalDateFrom = dw_cond.GetItemString(dw_cond.GetRow(),"fromdate") 
sBalDateTo   = dw_cond.GetItemString(dw_cond.GetRow(),"todate") 
sUpmuGbn     = dw_cond.GetItemString(dw_cond.GetRow(),"upmu_gu") 
sAllGbn      = dw_cond.GetItemString(dw_cond.GetRow(),"jungbn") 

IF sSaupj = "" or IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	return
ELSE
	IF sSaupj ='9' THEN sSaupj = '%'
END IF

IF sDeptCode = "" or IsNull(sDeptCode) THEN sDeptCode = '%'

IF lJunNoFrom = 0 OR IsNull(lJunNoFrom) THEN
	lJunNoFrom = 1
END IF

IF lJunNoTo = 0 OR IsNull(lJunNoTo) THEN
	lJunNoTo = 1
END IF

IF sBalDateFrom = "" or IsNull(sBalDateFrom) THEN
	F_MessageChk(1,'[승인일자]')
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	return
END IF
	
IF sBalDateTo = "" or IsNull(sBalDateTo) THEN
	F_MessageChk(1,'[승인일자]')
	dw_cond.SetColumn("todate")
	dw_cond.SetFocus()
	return
END IF

IF sBalDateFrom > sBalDateTo THEN
   MessageBox("확 인", "날짜의 범위 지정이 잘못되었습니다! 승인일자를 확인하십시오")
	dw_cond.SetColumn("fromdate")
	dw_cond.SetFocus()
	Return
END IF

IF sAllGbn = "" OR IsNull(sAllGbn) OR sAllGbn = 'N' THEN
	IF sUpmuGbn = "" OR IsNull(sUpmuGbn) THEN
		F_MessageChk(1,'[전표구분]')
		dw_cond.SetColumn("upmu_gu")
		dw_cond.SetFocus()
		return	
	END IF
ELSE
	sUpmuGbn = '%'
END IF

dw_2.Reset()
IF dw_2.Retrieve(sSaupj,sDeptCode,sBalDateFrom,sBalDateTo,lJunNoFrom,lJunNoTo,sUpmuGbn) <=0 THEN
	F_MessageChk(14,'')
	Return
END IF

dw_1.Reset()

sle_msg.text ="승인 전표를 조회하였습니다.!!"




end event

type cb_print from w_inherite`cb_print within w_kglb17
boolean visible = false
integer x = 1687
integer y = 2484
end type

type st_1 from w_inherite`st_1 within w_kglb17
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kglb17
boolean visible = false
integer x = 2034
integer y = 2616
end type

type cb_search from w_inherite`cb_search within w_kglb17
boolean visible = false
integer x = 1806
integer y = 2768
end type

type dw_datetime from w_inherite`dw_datetime within w_kglb17
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kglb17
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kglb17
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kglb17
boolean visible = false
integer x = 2171
integer y = 2500
integer width = 416
integer height = 176
end type

type gb_button2 from w_inherite`gb_button2 within w_kglb17
boolean visible = false
integer x = 2770
integer y = 2524
integer width = 864
integer height = 176
end type

type dw_cond from u_key_enter within w_kglb17
integer x = 69
integer width = 3630
integer height = 204
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kglc021"
boolean border = false
end type

event getfocus;this.AcceptText()

end event

event itemerror;
Return 1
end event

event itemchanged;String  sSaupj,  sBalDate,sDeptCode,sDeptName,sUpmuGbn,sNull
Integer iCurRow
Long    lJunNo

SetNull(snull)

iCurRow = this.GetRow()

this.AcceptText()
IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "dept_cd" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN Return
	
	sDeptName = F_Get_PersonLst('3',sDeptCode,'1')
	IF IsNull(sDeptName) THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(iCurRow,"dept_cd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "fromdate" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate = "" OR IsNull(sBalDate) THEN RETURN
	
	IF F_DateChk(sBalDate) = -1 THEN
		F_MessageChk(21,'[승인일자]')
		this.SetItem(iCurRow,"fromdate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "todate" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate = "" OR IsNull(sBalDate) THEN RETURN
	
	IF F_DateChk(sBalDate) = -1 THEN
		F_MessageChk(21,'[승인일자]')
		this.SetItem(iCurRow,"todate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="upmu_gu" THEN
	sUpmuGbn = this.GetText()
	IF sUpmuGbn ="" OR IsNull(sUpmuGbn) THEN 
		this.SetItem(iCurRow,"jungbn",'Y')
		RETURN 
	END IF
	
	IF IsNull(f_Get_Refferance('AG',sUpmuGbn)) THEN
		f_messagechk(20,"전표구분")
		this.SetItem(iCurRow,"upmu_gu",snull)
		this.SetColumn("upmu_gu")
		Return 1
	END IF
	this.SetItem(iCurRow,"jungbn",'N')
END IF





end event

type dw_2 from u_d_select_sort within w_kglb17
integer x = 82
integer y = 220
integer width = 4503
integer height = 984
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kglb17"
boolean hscrollbar = false
boolean border = false
end type

event clicked;call super::clicked;
If Row <= 0 then
	b_flag =True
ELSE

	lstr_jpra.saupjang  = dw_2.GetItemString(Row, "saupj")
	lstr_jpra.baldate   = dw_2.GetItemString(Row, "bal_date")
	lstr_jpra.upmugu    = dw_2.GetItemString(Row, "upmu_gu")
	lstr_jpra.bjunno    = dw_2.GetItemNumber(Row, "bjun_no")
	
	If dw_1.Retrieve( lstr_jpra.saupjang, lstr_jpra.baldate, lstr_jpra.upmugu, lstr_jpra.bjunno ) < 0 then
		MessageBox("확 인", "조회하신 전표의 자료가 존재하지 않습니다.")
		dw_2.Setfocus()
	End If

	b_flag = False
END IF

dw_1.setfocus()
end event

type dw_rtv from datawindow within w_kglb17
boolean visible = false
integer x = 165
integer y = 2544
integer width = 1298
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표 라인별 조회.저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;//String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
//Integer iPos, iCount
//
//iCount			= 0
//sNewline			= '~r'
//sReturn			= '~n'
//sErrorcode 		= Left(sqlerrtext, 9)
//iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
//sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))
//
//str_db_error db_error_msg
//db_error_msg.rowno 	 				= row
//db_error_msg.errorcode 				= sErrorCode
//db_error_msg.errorsyntax_system	= sErrorSyntax
//db_error_msg.errorsyntax_user		= sErrorSyntax
//db_error_msg.errorsqlsyntax			= sqlsyntax
//
//OpenWithParm(w_error, db_error_msg)

//RETURN 1
end event

type dw_1 from datawindow within w_kglb17
integer x = 82
integer y = 1240
integer width = 4503
integer height = 944
boolean bringtotop = true
string dataobject = "dw_kglb17_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kglb17
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 212
integer width = 4530
integer height = 1004
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kglb17
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 1232
integer width = 4530
integer height = 964
integer cornerheight = 40
integer cornerwidth = 46
end type

