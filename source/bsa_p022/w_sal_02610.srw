$PBExportHeader$w_sal_02610.srw
$PBExportComments$거래명세서
forward
global type w_sal_02610 from w_standard_print
end type
type cbx_1 from checkbox within w_sal_02610
end type
type dw_1 from dw_print within w_sal_02610
end type
type pb_1 from u_pb_cal within w_sal_02610
end type
type pb_2 from u_pb_cal within w_sal_02610
end type
type dw_2 from datawindow within w_sal_02610
end type
type dw_prt from datawindow within w_sal_02610
end type
type cb_1 from commandbutton within w_sal_02610
end type
type rr_1 from roundrectangle within w_sal_02610
end type
type rr_2 from roundrectangle within w_sal_02610
end type
end forward

global type w_sal_02610 from w_standard_print
string title = "거래명세표 발행"
cbx_1 cbx_1
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
dw_2 dw_2
dw_prt dw_prt
cb_1 cb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_02610 w_sal_02610

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();//String s_cvcod, s_datef, s_datet, s_saupj, s_prtgbn, s_iojpno, sgubun
//Long   lRow, lInsRowcnt, ldsrow, lDetRow, lModno
//datastore ds_data
//
//If 	dw_ip.accepttext() <> 1 Then Return -1
//
//sgubun		= dw_ip.getitemstring(1, "gubun")
//s_prtgbn 	= Trim(dw_ip.getitemstring(1,"prtgbn"))
//s_iojpno 	= Trim(dw_ip.getitemstring(1,"iojpno")) + '%'
//s_datef 	   = dw_ip.getitemstring(1,"sdatef")
//s_datet 	   = dw_ip.getitemstring(1,"sdatet")
//s_cvcod 	   = Trim(dw_ip.getitemstring(1,"custcode")) 
//s_saupj 	   = Trim(dw_ip.getitemstring(1,"saupj"))
//
////필수입력항목 체크///////////////////////////////////
//if s_prtgbn = '1' then 
//	If IsNull(s_iojpno ) or s_iojpno = '' Then
//		f_message_chk(30, ' 출고 전표 번호 ')
//		dw_ip.setfocus()
//		dw_ip.SetColumn('iojpno')
//		return -1
//	end if
//Else
//	if	f_datechk(s_datef) <> 1 Or f_datechk(s_datet) <> 1 then
//		f_message_chk(30,'[기준일자]')
//		dw_ip.setfocus()
//		return -1
//	end if
//
//End if
//
//
//if sgubun = '3' then
//	if IsNull(s_cvcod) Or s_cvcod = '' then
//		f_message_chk(30,'[거래처 코드]')
//		dw_ip.setfocus()
//		return -1
//	end if
//	
//	If IsNull(s_Saupj) Or s_Saupj = '' Then
//		f_message_chk(1400,'[부가사업장]')
//		dw_ip.SetFocus()
//		Return -1
//	End If
//End if
//	
//If 	IsNull(s_iojpno ) or s_iojpno = '' Then
//		s_iojpno = '%'
//end if
//If 	IsNull(s_cvcod ) or s_cvcod = '' Then
//		s_cvcod = '%'
//end if
//If 	IsNull(s_saupj ) or s_saupj = '' Then s_saupj = '%'
//
//dw_print.setSort("")
//dw_print.sort()		
//
//if sgubun = '3' then
//	IF dw_print.retrieve(gs_sabu, s_cvcod, s_datef, s_datet, s_saupj) <= 0 THEN
//		f_message_chk(50,'[거래명세서]')
//		dw_ip.setfocus()
//		SetPointer(Arrow!)
//		dw_list.SetRedraw(True)
//		Return -1
//	END IF
//	
//	dw_print.setSort("x_io_date A,itemas_itnbr A")
//	dw_print.sort()		
//Else	
//	if s_prtgbn = '2' then
//		if sgubun = '1' then
//			messagebox("", gs_sabu+'||'+ s_datef+'||'+ s_datet+'||'+ s_iojpno+'||'+ s_saupj+'||'+ s_cvcod)
//			IF dw_print.retrieve(gs_sabu, s_datef, s_datet, s_iojpno, s_saupj, s_cvcod) <= 0 THEN
//				f_message_chk(50,'[거래명세서]')
//				dw_ip.setfocus()
//				SetPointer(Arrow!)
//				Return -1
//			END IF
//		else
//			messagebox("", gs_sabu+'||'+ s_datef+'||'+ s_datet+'||'+ '%'+'||'+ s_saupj+'||'+ s_cvcod)
//			IF dw_print.retrieve(gs_sabu, s_datef, s_datet, s_iojpno, s_saupj, s_cvcod) <= 0 THEN
//				f_message_chk(50,'[거래명세서]')
//				dw_ip.setfocus()
//				SetPointer(Arrow!)
//				Return -1
//			END IF
//		end if
//		
//		
//	else
//		IF dw_print.retrieve(gs_sabu, s_datef, s_datet, s_iojpno, s_saupj, s_cvcod) <= 0 THEN
//			f_message_chk(50,'[거래명세서]')
//			dw_ip.setfocus()
//			SetPointer(Arrow!)
//			Return -1
//		END IF
//	end if
//End if
//
//
//
//dw_print.ShareData(dw_list)
//
//

dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st

ls_st = dw_ip.GetItemString(row, 'sdatef')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('sdatef')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_ed

ls_ed = dw_ip.GetItemString(row, 'sdatet')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('sdatet')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_cvcod

ls_cvcod = dw_ip.GetItemString(row, 'custcode')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

String ls_saupj

ls_saupj = dw_ip.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(gs_sabu, ls_st, ls_ed, '%', ls_saupj, ls_cvcod)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then
	MessageBox('조회내용', '조회된 내용이 없습니다.')
	Return -1
End If

Return 1
end function

on w_sal_02610.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_2=create dw_2
this.dw_prt=create dw_prt
this.cb_1=create cb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.dw_prt
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_sal_02610.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_2)
destroy(this.dw_prt)
destroy(this.cb_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;string sarea, steam, saupj

dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)

/* User별 사업장 Setting */
f_mod_saupj(dw_ip, 'saupj') 

// 관할구역
f_child_saupj(dw_ip, 'deptcode', gs_saupj) 

// 관할구역 권한 설정
If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'deptcode', sarea)
	dw_ip.Modify("deptcode.protect=1")
End If

//dw_list.InsertRow(0)
end event

type p_xls from w_standard_print`p_xls within w_sal_02610
integer x = 3191
integer y = 44
end type

type p_sort from w_standard_print`p_sort within w_sal_02610
integer x = 3013
integer y = 44
end type

type p_preview from w_standard_print`p_preview within w_sal_02610
end type

event p_preview::clicked;call super::clicked;//

//Long   ll_cnt
//
//ll_cnt = dw_list.RowCount()
//If ll_cnt < 1 Then Return
//
//Long   i
//Long   l

//String ls_jpno[]
//
//l = 0
//For i = 1 To ll_cnt
//	If dw_list.GetItemString(i, 'chk') = 'Y' Then
//		l = l + 1
//		ls_jpno[l] = dw_list.GetItemString(i, 'iojpno')
//	End If
//Next
//
//If l < 1 Then
//	MessageBox('확인', '선택된 행이 없습니다.')
//	Return
//End If
//
//
//dw_print.Retrieve(ls_jpno)
//
//OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within w_sal_02610
end type

type p_print from w_standard_print`p_print within w_sal_02610
end type

event p_print::clicked;//String  ls_itnbr, ls_itdsc, ls_ispec, ls_unit, ls_iodate, ls_optdel, ls_custcode, sgubun, ls_iojpno
//String  ls_opt
//Long    ll_cnt, ll_ioqty, ll_ioprc, i
//
//if dw_list.RowCount() = 0 then 
//	MessageBox("확인","인쇄할 데이터가 존재하지 않습니다.",stopsign!)
//	return
//End If
//
//dw_ip.accepttext()
//dw_list.AcceptText()
//
//sgubun = dw_ip.getitemstring(1, "gubun")
//
//if sgubun = '3' then
//	
//	ls_custcode = dw_ip.getItemString(1, "custcode")
//	
//	//VDO 한라
//	If ls_custcode = '100595' Then
//	
//		dw_1.DataObject = 'd_sal_t_10310_vdo_p'	
//		dw_list.ShareData(dw_1)
//		dw_1.setFilter("optdel='Y'")
//		dw_1.filter()
//		dw_list.setRedraw(false)
//		
//		If MessageBox("확인","인쇄설정을 2420 ×1525로 설정해야 합니다.~r설정하시겠습니까?", Question!, OKCancel!, 1) = 1 Then
//			printsetup()
//			dw_1.print()
//				For i = 1 to dw_list.RowCount()
//					ls_iojpno =  dw_list.GetItemString(i,'x_iojpno')
//					ls_opt    =  dw_list.GetItemString(i,'optdel')
//					
//					If ls_opt = 'Y' Then
//						Update Imhist set gungbn ='Y' 
//						Where  sabu = :gs_sabu
//						and    iojpno = :ls_iojpno;
//						
//						If sqlca.sqlcode = 0 Then
//							Commit;
//						Else
//							RollBack;	
//						End If
//						
//					End If
//					
//				Next
//		End If
//		dw_1.setFilter("")
//		dw_1.filter()
//		
//		dw_list.setRedraw(true)
//	
//	//인지 컨드롤스
//	ElseIf ls_custcode = '100682' Then
//		dw_1.DataObject = 'd_sal_t_10310_inji_p'	
//	
//		dw_list.ShareData(dw_1)
//		dw_1.setFilter("optdel='Y'")
//		dw_1.filter()
//		dw_list.setRedraw(false)
//		
//		If MessageBox("확인","인쇄설정을 1975 ×1315로 설정해야 합니다.~r설정하시겠습니까?", Question!, OKCancel!, 1) = 1 Then
//			printsetup()
//			dw_1.print()
//		End If
//		dw_1.setFilter("")
//		dw_1.filter()
//		
//		dw_list.setRedraw(true)
//	
//	//한국하니웰
//	ElseIf ls_custcode = '100867' Then
//		dw_1.DataObject = 'd_sal_t_10310_hon_p'	
//	
//		dw_list.ShareData(dw_1)
//		dw_1.setFilter("optdel='Y'")
//		dw_1.filter()
//		dw_list.setRedraw(false)
//		
//		If MessageBox("확인","인쇄설정을 2100 ×1500로 설정해야 합니다.~r설정하시겠습니까?", Question!, OKCancel!, 1) = 1 Then
//			printsetup()
//			dw_1.print()
//		End If
//		dw_1.setFilter("")
//		dw_1.filter()
//		
//		dw_list.setRedraw(true)
//	End If
//Else
//	IF dw_print.rowcount() > 0 then 
//		gi_page = dw_print.GetItemNumber(1,"last_page")
//	ELSE
//		gi_page = 1
//	END IF
//	OpenWithParm(w_print_options, dw_print)
//End if
end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_02610
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
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
	
	cb_1.Enabled = False

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	cb_1.Enabled = True
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------



//String s_cvcod, s_datef, s_datet, s_saupj, s_prtgbn, s_iojpno, sgubun, sStdn, ssteam
//Long   lRow, lInsRowcnt, ldsrow, lDetRow, lModno
//datastore ds_data
//
//If 	dw_ip.accepttext() <> 1 Then Return -1
//
//sgubun		= dw_ip.getitemstring(1, "gubun")
//s_prtgbn 	= Trim(dw_ip.getitemstring(1,"prtgbn"))
//s_iojpno 	= Trim(dw_ip.getitemstring(1,"iojpno"))
//s_datef 	   = dw_ip.getitemstring(1,"sdatef")
//s_datet 	   = dw_ip.getitemstring(1,"sdatet")
//s_cvcod 	   = Trim(dw_ip.getitemstring(1,"custcode")) 
//s_saupj 	   = Trim(dw_ip.getitemstring(1,"saupj"))
//sStdn 	   = Trim(dw_ip.getitemstring(1,"stdn"))
//ssteam 	   = Trim(dw_ip.getitemstring(1,"deptcode"))
//
////필수입력항목 체크///////////////////////////////////
//if s_prtgbn = '1' then 
//	If IsNull(s_iojpno ) or s_iojpno = '' Then
//		f_message_chk(30, ' 출고 전표 번호 ')
//		dw_ip.setfocus()
//		dw_ip.SetColumn('iojpno')
//		return -1
//	end if
//Else
//	if	f_datechk(s_datef) <> 1 Or f_datechk(s_datet) <> 1 then
//		f_message_chk(30,'[기준일자]')
//		dw_ip.setfocus()
//		return -1
//	end if
//
//End if
//
//
//if sgubun = '3' then
//	if IsNull(s_cvcod) Or s_cvcod = '' then
//		f_message_chk(30,'[거래처 코드]')
//		dw_ip.setfocus()
//		return -1
//	end if
//	
//	If IsNull(s_Saupj) Or s_Saupj = '' Then
//		f_message_chk(1400,'[부가사업장]')
//		dw_ip.SetFocus()
//		Return -1
//	End If
//End if
//	
//If 	IsNull(s_iojpno ) or s_iojpno = '' Then
//		s_iojpno = ''
//end if
//If 	IsNull(s_cvcod ) or s_cvcod = '' Then
//		s_cvcod = ''
//end if
//If 	IsNull(s_saupj ) or s_saupj = '' Then s_saupj = ''
//If 	IsNull(ssteam ) or ssteam = '' Then ssteam = ''
//
//dw_print.setSort("")
//dw_print.sort()		
//
//if sgubun = '3' then
//	IF dw_print.retrieve(gs_sabu, s_cvcod+'%', s_datef, s_datet, s_saupj+'%') <= 0 THEN
//		f_message_chk(50,'[거래명세서]')
//		dw_ip.setfocus()
//		SetPointer(Arrow!)
//		dw_list.SetRedraw(True)
//		Return -1
//	END IF
//	
//	dw_print.setSort("x_io_date A,itemas_itnbr A")
//	dw_print.sort()		
//Else	
//	if sgubun = '1' or sgubun = '2' then
//		if s_prtgbn = '1' then
//			s_datef='20040101'; s_datet='99991231';
//			IF dw_print.retrieve(gs_sabu, s_datef, s_datet, s_iojpno+'%', s_saupj+'%', s_cvcod+'%') <= 0 THEN
//				f_message_chk(50,'[거래명세서]')
//				dw_ip.setfocus()
//				SetPointer(Arrow!)
//				Return -1
//			END IF
//		else
//			s_iojpno = '%'   // 대신기계는 이곳
////			IF dw_print.retrieve(gs_sabu, s_datef, s_datet, s_iojpno+'%', s_saupj+'%', s_cvcod+'%', sStdn, ssteam+'%') <= 0 THEN
//         IF dw_list.retrieve(gs_sabu, s_datef, s_datet, s_iojpno+'%', s_saupj+'%', s_cvcod+'%') <= 0 THEN
//				f_message_chk(50,'[거래명세서]')
//				dw_ip.setfocus()
//				SetPointer(Arrow!)
//				Return -1
//			Else
//				dw_print.retrieve(gs_sabu,	s_iojpno+'%')
//			END IF
//		end if
//	else    
//		IF dw_print.retrieve(gs_sabu, s_datef, s_datet, s_iojpno+'%', s_saupj+'%', s_cvcod+'%') <= 0 THEN
//			f_message_chk(50,'[출고지시서]')
//			dw_ip.setfocus()
//			SetPointer(Arrow!)
//			Return -1
//		END IF
//	end if
//End if
//
//dw_print.ShareData(dw_list)
//
//Return 1
end event







type st_10 from w_standard_print`st_10 within w_sal_02610
end type



type dw_print from w_standard_print`dw_print within w_sal_02610
integer x = 2510
integer y = 24
string dataobject = "d_sal_02610_r1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02610
integer x = 32
integer width = 2377
integer height = 188
string dataobject = "d_sal_02610_01"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname, sIoJpno, ls_saupj
String  sDateFrom, sDateTo, snull, sPrtGbn, sgubun,sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
	Case "prtgbn"
		sPrtGbn = this.GetText()
		
		if sPrtGbn = '1' then 
			this.SetItem(1,'iojpno','')
		else
			this.SetItem(1,"sdatef", Left(is_today,6)+'01')
			this.SetItem(1,"sdatet", is_today)
		end if ;
	Case "iojpno"
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
		SELECT  "SAUPJ", "CVCOD", FUN_GET_CVNAS("CVCOD")
		  INTO :sSaupj, :sIoCust, :sIoCustName
		  FROM "IMHIST", "IOMATRIX"
		 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
				 ( "IMHIST"."IOJPNO" LIKE :sIoJpNo||'%' ) AND
				 ( "IMHIST"."IOGBN" = "IOMATRIX"."IOGBN" ) AND
				 ( "IOMATRIX"."SALEGU" = 'Y' ) AND                     // 매출구분 Y- 매출에 해당하는 수불구분
//				 ( "IOMATRIX"."JEPUMIO" = 'Y' ) AND                    // 수주출고여부
				 ( "IMHIST"."JNPCRT" ='004')
		GROUP BY SAUPJ, CVCOD		 ;
	
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			SetItem(1, 'saupj', sSaupj)
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
		END IF
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[출고기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[출고기간]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
	Case "custcode"
		sCvcod = this.GetText()
		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode",  		sCvcod)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF

	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode",  		sCvcod )
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 

			Return 1
		END IF
	Case "gubun"
		sDept = gettext()
		if sDept = '1' then
			dw_list.dataobject   = "d_sal_02610_1"
			dw_print.dataobject  = "d_sal_02610_1_p"
			cbx_1.visible = false
		Elseif sDept = '2' then
			dw_list.dataobject   = "d_sal_02610_2"
			dw_print.dataobject  = "d_sal_02610_2_p"
			cbx_1.visible = false
		Elseif sDept = '3' then
			dw_list.DataObject 	= 'd_sal_t_10310_d'
			dw_1.DataObject 		= 'd_sal_t_10310_vdo_p'
			dw_print.DataObject  = 'd_sal_t_10310_d_vdo'
			setitem(1, "prtgbn", '2')
			cbx_1.visible = true
		End if
		dw_1.settransobject(sqlca)		
		dw_list.settransobject(sqlca)
		dw_print.settransobject(sqlca)
	case 'saupj' 
		
		string lsCode, lscvnas, lsarea, lsteam, lsSaupj, lsName1
		String ls_code	
		//거래처
		ls_saupj = gettext() 
		lsCode 	= this.object.custcode[1] 
		f_get_cvnames('1', lsCode, lscvnas, lsarea, lsteam, lsSaupj, lsName1)
		if ls_saupj <> lssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 

END Choose
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "iojpno"	
		gs_gubun    = '004'
		gs_codename = 'B'  /* 출고확인 전/후 */
		Open(w_imhist_02040_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"iojpno",Left(gs_code,12))
		SetFocus()
		PostEvent(ItemChanged!)
		
	/* 거래처 */
	Case "custcode"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		TriggerEvent(ItemChanged!)		
	/* 거래처명 */
	Case "custname"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		TriggerEvent(ItemChanged!)		
END Choose

end event

event dw_ip::clicked;call super::clicked;string sPrtGbn,sCode, scvnas, sarea, steam, sSaupj, sName1
String ls_saupj, ls_sarea, ls_return, ls_steam, ls_emp_id, ls_pdtgu
String  snull
long rtncode 
Datawindowchild state_child 

Choose Case GetColumnName() 
	Case "prtgbn"
		sPrtGbn = this.GetText()
		
		if sPrtGbn = '1' then 
			pb_1.visible = false
			pb_2.visible = false
		else
			pb_1.visible = true
			pb_2.visible = true
		end if 

	
End Choose 
end event

type dw_list from w_standard_print`dw_list within w_sal_02610
integer x = 50
integer y = 228
integer width = 4562
integer height = 944
string dataobject = "d_sal_02610_r1"
boolean border = false
end type

event dw_list::clicked;call super::clicked;if row < 1 then return

this.SelectRow(0, false)
this.SelectRow(row, true)

String ls_jpno

ls_jpno = This.GetItemString(row, 'iojpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('전표번호 확인', '전표번호를 확인 하십시오.')
	Return 
End If

dw_2.SetRedraw(False)
dw_2.Retrieve(gs_sabu, ls_jpno)
dw_print.Retrieve(ls_jpno)
dw_prt.Retrieve(ls_jpno)
dw_2.SetRedraw(True)

end event

event dw_list::retrieveend;call super::retrieveend;If rowcount < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(1, 'iojpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('전표번호 확인', '전표번호를 확인 하십시오.')
	Return 
End If

dw_2.SetRedraw(False)
dw_2.Retrieve(gs_sabu, ls_jpno)
dw_print.Retrieve(ls_jpno)
dw_prt.Retrieve(ls_jpno)
dw_2.SetRedraw(True)


end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

Long   row

row = This.GetRow()
If row < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(row, 'iojpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('전표번호 확인', '전표번호를 확인 하십시오.')
	Return 
End If

dw_2.SetRedraw(False)
dw_2.Retrieve(gs_sabu, ls_jpno)
dw_print.Retrieve(ls_jpno)
dw_prt.Retrieve(ls_jpno)
dw_2.SetRedraw(True)
end event

type cbx_1 from checkbox within w_sal_02610
boolean visible = false
integer x = 2693
integer y = 36
integer width = 357
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "전체선택"
end type

event clicked;Long Lrow

If this.Checked = True Then
	For Lrow = 1 to dw_list.rowcount()
		 if dw_list.getitemString(lrow, 'optdel') = 'N' then 
   		 dw_list.Setitem(Lrow, "optdel", 'Y')
    	 end if	 
	Next
Else
	For Lrow = 1 to dw_list.rowcount()
		 dw_list.Setitem(Lrow, "optdel", 'N')
	Next
	
End if
end event

type dw_1 from dw_print within w_sal_02610
integer y = 140
integer height = 48
integer taborder = 10
boolean bringtotop = true
string dataobject = ""
end type

type pb_1 from u_pb_cal within w_sal_02610
integer x = 663
integer y = 28
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02610
integer x = 1111
integer y = 28
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type dw_2 from datawindow within w_sal_02610
integer x = 50
integer y = 1208
integer width = 4562
integer height = 1044
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_02610_r2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SetRow(currentrow)
This.SelectRow(currentrow, True)
end event

event clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SetRow(row)
This.SelectRow(row, True)
end event

type dw_prt from datawindow within w_sal_02610
boolean visible = false
integer x = 2830
integer y = 68
integer width = 151
integer height = 128
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0010_chul_p"
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)

end event

type cb_1 from commandbutton within w_sal_02610
integer x = 3479
integer y = 36
integer width = 430
integer height = 124
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "출고전표 출력"
end type

event clicked;String ls_name
ls_name = f_get_name5('02', gs_empno, '')

dw_prt.Modify("t_name1.Text = '" + ls_name + "'")
dw_prt.Modify("t_name2.Text = '" + ls_name + "'")
dw_prt.Modify("t_name3.Text = '" + ls_name + "'")

OpenWithParm(w_print_preview, dw_prt)

end event

type rr_1 from roundrectangle within w_sal_02610
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 216
integer width = 4590
integer height = 964
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02610
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 1196
integer width = 4590
integer height = 1068
integer cornerheight = 40
integer cornerwidth = 55
end type

