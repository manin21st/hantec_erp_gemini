$PBExportHeader$w_sm04_00030.srw
$PBExportComments$월간 일일 출하 실적
forward
global type w_sm04_00030 from w_standard_print
end type
type rr_2 from roundrectangle within w_sm04_00030
end type
type p_mod from picture within w_sm04_00030
end type
type p_gwins from uo_picture within w_sm04_00030
end type
type rr_1 from roundrectangle within w_sm04_00030
end type
end forward

global type w_sm04_00030 from w_standard_print
string title = "일일 출하 실적(월간)"
rr_2 rr_2
p_mod p_mod
p_gwins p_gwins
rr_1 rr_1
end type
global w_sm04_00030 w_sm04_00030

type variables
String     is_gwgbn            // 그룹웨어 연동여부
Transaction SQLCA1				// 그룹웨어 접속용
String     isHtmlNo = '00020'	// 그룹웨어 문서번호

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYymm, sdate, edate, sPlnt, sGrpNam, tx_name
String sSaupj

If dw_ip.AcceptText() <> 1 Then Return -1

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return -1
End If

IF dw_print.Retrieve(gs_sabu, syymm) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

//dw_list.Retrieve(sSaupj, syymm, sCust+'%', sGrpNam+'%')
//dw_print.sharedata(dw_list)

tx_name = Left(sYymm,4) + '.' + Mid(sYymm,5,2)
dw_print.Modify("t_ym.text = '"+tx_name+"'")

return 1
end function

on w_sm04_00030.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.p_mod=create p_mod
this.p_gwins=create p_gwins
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.p_mod
this.Control[iCurrent+3]=this.p_gwins
this.Control[iCurrent+4]=this.rr_1
end on

on w_sm04_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.p_mod)
destroy(this.p_gwins)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1, 'yymm', Left(is_today,6))


is_gwgbn = 'Y'

If is_gwgbn = 'Y' Then
	String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn
	
	// MsSql Server 접속
	SQLCA1 = Create Transaction
	
	select dataname into	 :ls_dbms     from syscnfg where sysgu = 'W' and serial = '6' and lineno = '1';
	select dataname into	 :ls_database from syscnfg where sysgu = 'W' and serial = '6' and lineno = '2';
	select dataname into	 :ls_id	 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '3';
	select dataname into	 :ls_pwd 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '4';
	select dataname into	 :ls_host 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '5';
	select dataname into	 :ls_port 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '6';
	
	ls_conn_str = "DBMSSOCN,"+ls_host+","+ls_port 
	
	SetNull(ls_reg_cnn)
	RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", ls_host, RegString!, ls_reg_cnn) 
	
	If Trim(Upper(ls_conn_str)) <> Trim(Upper(ls_reg_cnn)) Or &
		( ls_reg_cnn =""  Or isNull(ls_reg_cnn) )  Then
		RegistrySet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", & 
						ls_host, RegString!, ls_conn_str)
	End If
	
	SQLCA1.DBMS = ls_dbms
	SQLCA1.Database = ls_database
	SQLCA1.LogPass = ls_pwd
	SQLCA1.ServerName = ls_host
	SQLCA1.LogId =ls_id
	SQLCA1.AutoCommit = False
	SQLCA1.DBParm = ""
	
	CONNECT USING SQLCA1;
	If sqlca1.sqlcode <> 0 Then
		messagebox(string(sqlca1.sqlcode),sqlca1.sqlerrtext)
		MessageBox('확 인','그룹웨어 연동을 할 수 없습니다.!!')
		is_gwgbn = 'N'
	End If
End If

end event

type p_preview from w_standard_print`p_preview within w_sm04_00030
end type

type p_exit from w_standard_print`p_exit within w_sm04_00030
end type

type p_print from w_standard_print`p_print within w_sm04_00030
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm04_00030
end type

event p_retrieve::clicked;if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="1"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_mod.Enabled =False
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	
	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'

	p_mod.Enabled =True
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)	
end event







type st_10 from w_standard_print`st_10 within w_sm04_00030
end type



type dw_print from w_standard_print`dw_print within w_sm04_00030
integer x = 3666
integer y = 20
string dataobject = "d_sm04_00030_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm04_00030
integer x = 105
integer y = 96
integer width = 3150
integer height = 96
string dataobject = "d_sm04_00030"
end type

event dw_ip::itemchanged;String sDate

Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()
	Case 'grpnam'
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm04_00030
integer x = 73
integer y = 264
integer width = 4512
integer height = 2004
string dataobject = "d_sm04_00030_1"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_2 from roundrectangle within w_sm04_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 52
integer width = 3227
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_mod from picture within w_sm04_00030
boolean visible = false
integer x = 3465
integer y = 56
integer width = 178
integer height = 144
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;//String sOrderDate, sPlnt, svndstk, sItnbr, sCvcod, sGidate, host_jpno, sHoldNo
//Long ix,iy, nCnt, nUpd=0, host_iono, host_seqno
//Boolean bOk = False
//Dec	 dIqty,  dOldIQty
//String sSaupj
//
//If dw_list.AcceptText() <> 1 Then Return
//If f_msg_update() <> 1 Then Return
//
//// 출하의뢰일
//sOrderDate = Trim(dw_ip.GetItemString(1, 'yymm'))
//
///* 사업장 체크 */
//sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
//If IsNull(sSaupj) Or sSaupj = '' Then
//	f_message_chk(1400, '[사업장]')
//	dw_ip.SetFocus()
//	dw_ip.SetColumn('saupj')
//	Return -1
//End If
//
///* 전표번호 생성 */
//host_iono = 0;
//host_iono = sqlca.fun_junpyo(gs_sabu, sOrderDate, 'S1')
//if host_iono < 1 then
//	return -1
//end if
//
//commit;
//
//host_jpno 	= sOrderDate +string(host_iono,'0000');
//host_seqno	= 0;
//	
//For ix = 1 To dw_list.RowCount()
//	If dw_list.GetItemStatus(ix, 0, Primary!) = DataModified! Or dw_list.GetItemStatus(ix, 0, Primary!) = NewModified!  Then
//		bOk = False
//		
//		// 출하의뢰일 하루만 처리한다
//		For iy = 1 To 1
//			dOldIQty = 0
//			dIqty		= 0
//		
//			If dw_list.GetItemStatus(ix, 'itm_qty'+string(iy), Primary!) = DataModified! Or dw_list.GetItemStatus(ix, 'itm_qty'+string(iy), Primary!) = NewModified! Then
//				bOk = True
//			End If
//			
//			// 수정사항이 존재할 경우
//			If bOk Then
//				nUpd ++
//				
//				sPlnt		= Trim(dw_list.GetItemString(ix, 'plnt'))
//				svndstk	= Trim(dw_list.GetItemString(ix, 'vstk'))
//				sItnbr	= Trim(dw_list.GetItemString(ix, 'itnbr'))
//				sCvcod	= Trim(dw_list.GetItemString(ix, 'cvcod'))
//			
//				dIqty		= dw_list.GetItemNumber(ix, 'itm_qty'+string(iy))
//				
//				// 기준일자
//				sGidate = f_afterday(sOrderDate, iy - 1)
//				
//				SELECT COUNT(*) INTO :nCnt FROM SM04_DAILY_ITEM
//				 WHERE SAUPJ = :sSaupj
//				   AND YYMMDD = :sGidate
//					AND CVCOD = :sCvcod
//					AND ITNBR = :sItnbr
//					AND PLNT = :sPlnt
//					AND VNDSTK = :sVndstk
//					AND GUBUN = '4';
//
//				// 임의로 등록된 수량외
//				SELECT SUM(ITM_QTY1) INTO :dOldIQty FROM SM04_DAILY_ITEM
//				 WHERE SAUPJ = :sSaupj
//				   AND YYMMDD = :sGidate
//					AND CVCOD = :sCvcod
//					AND ITNBR = :sItnbr
//					AND PLNT = :sPlnt
//					AND VNDSTK = :sVndstk
//					AND GUBUN <> '4';
//				If IsNull(dOldIQty) Then dOldIQty = 0
//				
//				dIqty = dIqty - dOldIQty
//				
//				If nCnt > 0  Then
//					UPDATE SM04_DAILY_ITEM
//					   SET ITM_QTY1 = :dIqty
//					 WHERE SAUPJ = :sSaupj
//						AND YYMMDD = :sGidate
//						AND CVCOD = :sCvcod
//						AND ITNBR = :sItnbr
//						AND PLNT = :sPlnt
//						AND VNDSTK = :sVndstk
//						AND GUBUN = '4';
//				Else
//					host_seqno += 1
//					sHoldNo = host_jpno + String(host_seqno,'000')
//					INSERT INTO SM04_DAILY_ITEM
//							  ( SAUPJ,    YYMMDD,   GUBUN,    CVCOD,    ITNBR,    
//							    ITM_PRC, 
//								 ITM_QTY1, ITM_QTY2, ITM_QTY3,  ITM_QTY4, ITM_QTY5, ITM_QTY6, ITM_QTY7, 
//								 CNFIRM,   VNDSTK,   JPROD_QTY, ORDER_NO, PROD_QTY, PLNT,
//								 OUT_CHK,  ISQTY,    HOLD_NO)
//					 VALUES ( :sSaupj, :sGidate, '4', 		:sCvcod,   :sItnbr,
//					          fun_erp100000012_1(to_char(sysdate,'yyyymmdd'), :sCvcod, :sItnbr, '1') ,
//					          :dIqty,   0,        0,         0,        0,        0,        0,
//								 'N',      :sVndstk, 0,         NULL,     0,   :sPlnt,
//								 '1',	     0,        :sHoldNo);
//				End If
//				If SQLCA.SQLCODE <> 0 Then
//					MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
//					RollBack;
//					Return
//				End If
//			End If
//		Next
//	End If
//Next
//
//If nUpd > 0 Then
//	COMMIT;
//	
//	// 재조회후 출력한다
//	p_retrieve.TriggerEvent(Clicked!)
//	
//	If  MessageBox("출력", '출력 하시겠습니까?', Exclamation!, OKCancel!, 1) = 2 Then Return
//
//	p_print.TriggerEvent(Clicked!)
//End If
end event

type p_gwins from uo_picture within w_sm04_00030
integer x = 3310
integer y = 28
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\결재상신_up.gif"
end type

event clicked;call super::clicked;String sEstNo, sDate
string smsg, scall, sHeader, sDetail, sFooter, sRepeat, sDetRow, sValue
integer li_FileNum, nspos, nepos, ix, nPos, i, ll_repno1,ll_rptcnt1, ll_repno2,ll_rptcnt2, ll_html,sJucha, sJucha_save
string ls_Emp_Input, sGwNo, ls_reportid1, ls_reportid2, sGwStatus
long ll_FLength, dgwSeq, lRow

// HTML 문서를 읽어들인다
ll_FLength = FileLength("EAFolder_00020.html")
li_FileNum = FileOpen("EAFolder_00020.html", StreamMode!)

IF ll_FLength < 32767 THEN
        FileRead(li_FileNum, scall)
END IF
FileClose(li_FileNum)
If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('확 인','HTML 문서가 존재하지 않습니다.!!')
	Return -1
End If

// 그룹웨어 연동시 문서번호 채번...필요한 경우 함
If IsNull(sGwNo) Or Trim(sGwNo) = '' Then
	sDate = f_today()
	dgwSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'GW')
	IF dgwSeq < 1	 or dgwSeq > 9999	THEN	
		ROLLBACK ;
		f_message_chk(51, '[전자결재]')
		RETURN -1
	END IF
	
	COMMIT;
	
	sGWno = sDate + string(dGWSeq, "0000")
End If

If IsNull(sGwNo) Or sGwNo = '' Then Return 0

// 반복행을 찾는다
nsPos = Pos(scall, '(__LOOP_START__)')
nePos = Pos(scall, '(__LOOP_END__)')

If nsPos > 0 And nePos > 0 Then
	sHeader = Left(sCall, nsPos -1)
	sRepeat = Mid(sCall, nsPos + 17, nePos - (nsPos + 17))
	sFooter = Mid(sCall, nePos + 14)

	// Detail에 대해서 반복해서 값을 setting한다
	ix = 1
	do 
		if ix = 1 then
			sJucha_save = dw_list.GetItemNumber(ix,'c_week_jucha')
		end if
		sJucha = dw_list.GetItemNumber(ix,'c_week_jucha')		
		if sJucha <> sJucha_save then
			nPos = Pos(sRepeat, '(_kd_)')  
			If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 6, string(sJucha_save) + '주')
			nPos = Pos(sDetRow, '(_amt_b1_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_22'),'#,##0'))
			nPos = Pos(sDetRow, '(_amt_d1_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_13'),'#,##0'))
			nPos = Pos(sDetRow, '(_amt_k1_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_21'),'#,##0'))
			nPos = Pos(sDetRow, '(_amt_d3_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_14'),'#,##0'))
			nPos = Pos(sDetRow, '(_amt_c1_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_20'),'#,##0'))
			nPos = Pos(sDetRow, '(_amt_pk_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_19'),'#,##0'))
			nPos = Pos(sDetRow, '(_amt_a1_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_15'),'#,##0'))
			nPos = Pos(sDetRow, '(_amt_gm_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_16'),'#,##0'))
			nPos = Pos(sDetRow, '(_amt_etc_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 11, String(dw_list.GetItemNumber(ix - 1,'compute_17'),'#,##0'))
			nPos = Pos(sDetRow, '(_amt_tot_)')  
			If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 11, String(dw_list.GetItemNumber(ix - 1,'compute_18'),'#,##0'))
		   sDetail = sDetail + sDetRow
			sJucha_save = sJucha
      End if
		nPos = Pos(sRepeat, '(_kd_)')  
		If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 6, dw_list.GetItemString(ix,'key_day'))
		nPos = Pos(sDetRow, '(_amt_b1_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'amt_b1'),'#,##0'))
		nPos = Pos(sDetRow, '(_amt_d1_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'amt_d1'),'#,##0'))
		nPos = Pos(sDetRow, '(_amt_k1_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'amt_k1'),'#,##0'))
		nPos = Pos(sDetRow, '(_amt_d3_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'amt_d3'),'#,##0'))
		nPos = Pos(sDetRow, '(_amt_c1_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'amt_c1'),'#,##0'))
		nPos = Pos(sDetRow, '(_amt_pk_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'amt_pk'),'#,##0'))
		nPos = Pos(sDetRow, '(_amt_a1_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'amt_a1'),'#,##0'))
		nPos = Pos(sDetRow, '(_amt_gm_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix,'amt_gm'),'#,##0'))
		nPos = Pos(sDetRow, '(_amt_etc_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 11, String(dw_list.GetItemNumber(ix,'amt_etc'),'#,##0'))
		nPos = Pos(sDetRow, '(_amt_tot_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 11, String(dw_list.GetItemNumber(ix,'amt_tot'),'#,##0'))
		sDetail = sDetail + sDetRow
		
		ix = ix + 1
	loop while (ix <= dw_list.RowCount() )
// 마지막 소계
	nPos = Pos(sRepeat, '(_kd_)')  
	If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 6, string(sJucha_save) + '주')
	nPos = Pos(sDetRow, '(_amt_b1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_22'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_d1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_13'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_k1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_21'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_d3_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_14'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_c1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_20'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_pk_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_19'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_a1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_15'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_gm_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(ix - 1,'compute_16'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_etc_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 11, String(dw_list.GetItemNumber(ix - 1,'compute_17'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_tot_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 11, String(dw_list.GetItemNumber(ix - 1,'compute_18'),'#,##0'))
	sDetail = sDetail + sDetRow
	
	// 합계 표시 시작--------
	nPos = Pos(sRepeat, '(_kd_)')  
	If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 6, '총계')
	nPos = Pos(sDetRow, '(_amt_b1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(1,'compute_3'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_d1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(1,'compute_4'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_k1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(1,'compute_12'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_d3_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(1,'compute_5'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_c1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(1,'compute_11'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_pk_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(1,'compute_10'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_a1_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(1,'compute_6'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_gm_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 10, String(dw_list.GetItemNumber(1,'compute_7'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_etc_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 11, String(dw_list.GetItemNumber(1,'compute_8'),'#,##0'))
	nPos = Pos(sDetRow, '(_amt_tot_)')  
	If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 11, String(dw_list.GetItemNumber(1,'compute_9'),'#,##0'))

	sDetail = sDetail + sDetRow
// 합계 표시 끝--------		
	sCall = sHeader + sDetail + sFooter
End If

// Detail외 매크로 내역을 치환한다
nPos = Pos(sCall, '(_DATE_)')
sValue = string(dw_ip.GetItemString(1,'yymm'),'@@@@.@@')
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 8, sValue)
		

///////////////////////////////////////////////

If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('확 인','HTML 문서가 생성되지 않았습니다.!!')
	Return -1
End If

//EAERPHTML에 등록되었는지 확인
select count(cscode) into :ll_html from eaerphtml
 where CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS > '0' USING SQLCA1;

If ll_html = 0 Then
	// 기존 미상신 내역이 있으면 삭제
	DELETE FROM EAERPHTML WHERE CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS IS NULL USING SQLCA1;
	
	// 그룹웨어 EAERPHTML TABLE에 기안내용을 INSERT한다
	INSERT INTO EAERPHTML
			  ( CSCODE, KEY1,  ERPEMPCODE, GWDOCGUBUN, SENDINGGUBUN, HTMLCONTENT, STATUS)
	 VALUES ( 'BDS',  :sGWno, Lower(:gs_userid),:isHtmlNo,    '1',   :sCall, '0') using sqlca1;
	If sqlca1.sqlcode <> 0 Then
		MESSAGEBOX(STRING(SQLCA1.SQLCODE), SQLCA1.SQLERRTEXT)
		RollBack USING SQLCA1;
		Return -1
	End If
	
	COMMIT USING SQLCA1;
Else
	MessageBox('확인','기상신된 내역입니다.!!')
	Return 0
End If

// 기안서 상신
gs_code  = "key1="+sGwNo			// Key Group
gs_gubun = isHtmlNo					//그룹웨어 문서번호
SetNull(gs_codename)		 			//제목입력받음(erptitle)
Open(w_groupware_browser)

//EAERPHTML에 상신되었는지 확인
SetNull(sGwStatus)
select approvalstatus into :sGwStatus
  from eafolder_00020_erp a, approvaldocinfo b
 where a.macro_field_1 = :sgwno
	and a.reporterid 	 = b.reporterid
	and a.reportnum	 = b.reportnum	using sqlca1 ;

If Not IsNull(sGwStatus) Or Trim(sGwNo) = '' Then
	MessageBox('결재상신','결재가 상신되었습니다.')
Else
	MessageBox('결재상신','결재가 상신되지 않았습니다.')
	Return -1
End If

// 그룹웨어 문서번호를 구매의뢰 테이블에 저장한다
//For ix = 1 To dw_list.RowCount()
//	dw_list.SetItem(ix, 'shpjpno', sGwno)
//Next

w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)

Return 1
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\결재상신_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\결재상신_up.gif'
end event

type rr_1 from roundrectangle within w_sm04_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 252
integer width = 4553
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

