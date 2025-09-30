$PBExportHeader$w_sal_04511.srw
$PBExportComments$월 입금내역 현황
forward
global type w_sal_04511 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_04511
end type
type pb_2 from u_pb_cal within w_sal_04511
end type
type rr_1 from roundrectangle within w_sal_04511
end type
type rr_3 from roundrectangle within w_sal_04511
end type
end forward

global type w_sal_04511 from w_standard_print
string title = "월 입금내역 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_04511 w_sal_04511

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSarea, sSDate, sEDate, sNull, sCvcod, sIpgumType, tx_name, sSaupj, sGubun ,ls_emp_id

SetNull(sNull)

If dw_ip.AcceptText() <> 1 Then Return 1

sSarea = Trim(dw_ip.GetItemString(1,'sarea'))
sCvcod = Trim(dw_ip.GetItemString(1,'cvcod'))
sIpgumType = Trim(dw_ip.GetItemString(1,'ipgum_type'))
sGubun = Trim(dw_ip.GetItemString(1,'pgubun'))
ls_emp_id = dw_ip.getitemstring(1,'emp_id')

If isnull(sSarea) Then	sSarea = '%'
If IsNull(sCvcod) Then	sCvcod = ''
If IsNull(sIpgumType) Then	sIpgumType = ''
If IsNull(sGubun) Then	sGubun = '1'

dw_ip.SetFocus()

sSaupj = Trim(dw_ip.GetItemString(1,'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_Message_Chk(1400, '[부가사업장]')
	dw_ip.setcolumn("saupj")
	return -1
end if

// 시작일자 유효성 Check
sSDate = Trim(dw_ip.GetItemString(1,'start_date'))
If f_DateChk(sSdate) = -1 then
	f_Message_Chk(35, '[시작일자]')
	dw_ip.SetItem(1, "start_date", sNull)
	dw_ip.setcolumn("start_date")	
	return -1
End If
		
// 끝일자 유효성 Check
sEDate = Trim(dw_ip.GetItemString(1,'end_date'))
If f_DateChk(sEdate) = -1 then
	f_Message_Chk(35, '[종료일자]')
	dw_ip.SetItem(1, "end_date", sNull)
	dw_ip.setcolumn("end_date")
	return -1
End if

If	( sSDate > sEDate ) then
	f_message_Chk(200, '[시작 및 종료일 CHECK]')
	dw_ip.setcolumn("start_date")
	Return -1
End if

if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'

If dw_print.Retrieve(gs_sabu, sSarea+'%', sCvcod+'%', sSDate, sEDate,sIpgumType+'%', sSaupj, sGubun,ls_emp_id) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('sarea')
	dw_ip.setfocus()
	return -1
End if

dw_print.ShareData(dw_list)

dw_print.object.s_date.Text = Left(sSDate,4)+'.'+Mid(sSDate,5,2)+'.'+Right(sSDate,2)
dw_print.object.e_date.Text = Left(sEDate,4)+'.'+Mid(sEDate,5,2)+'.'+Right(sEDate,2)

//If dw_list.Retrieve(gs_sabu, sSarea+'%', sCvcod+'%', sSDate, sEDate,sIpgumType+'%', sSaupj, sGubun,ls_emp_id) < 1 then
//	f_message_Chk(300, '[출력조건 CHECK]')
//	dw_ip.setcolumn('sarea')
//	dw_ip.setfocus()
//	return -1
//End if

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ipgum_type) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_ipgumtype.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

return 1

end function

on w_sal_04511.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_3
end on

on w_sal_04511.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;String sToday

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

sToday = f_today()
DataWindowChild state_child
integer rtncode

/* User별 관할구역 Setting */
String sarea, steam, saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'saupj', saupj)
//	dw_ip.SetItem(1, 'sarea', sarea)
//	dw_ip.Modify("sarea.protect=1")
//	dw_ip.Modify("sarea.background.color = 80859087")
//End If

/* 부가 사업장 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

//영업 담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

//관할 구역
rtncode 	= dw_ip.GetChild('sarea', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('%')

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.SetItem(1, 'start_date', left(sToday,6) + '01')
dw_ip.SetItem(1, 'end_date', sToday)


end event

type p_preview from w_standard_print`p_preview within w_sal_04511
end type

type p_exit from w_standard_print`p_exit within w_sal_04511
end type

type p_print from w_standard_print`p_print within w_sal_04511
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04511
end type







type st_10 from w_standard_print`st_10 within w_sal_04511
end type



type dw_print from w_standard_print`dw_print within w_sal_04511
integer x = 2336
string dataobject = "d_sal_04511_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04511
integer x = 55
integer y = 216
integer width = 4530
integer height = 160
string dataobject = "d_sal_04511_1"
end type

event dw_ip::itemchanged;String sNull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1, ls_saupj, scode
Long	 rtncode 
Datawindowchild state_child 

SetNull(sNull)

Choose Case GetColumnName()
	// 출력구분 선택시
	Case "gubun"
		if this.GetText() = '1' then
         dw_ip.SetItem(1, 'start_date', f_today())
         dw_ip.SetItem(1, 'end_date', f_today())
		elseif this.GetText() = '2' then
         dw_ip.SetItem(1, 'start_date', Left(f_today(),6) + '01')
         dw_ip.SetItem(1, 'end_date', f_last_date(Left(f_today(),6)))
		else
         dw_ip.SetItem(1, 'start_date', sNull)
         dw_ip.SetItem(1, 'end_date', sNull)
		end if
		
   // 시작일자 유효성 Check
	Case "start_date"  
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[시작일자]')
			this.SetItem(1, "start_date", sNull)
			return 1
		end if
		
	// 끝일자 유효성 Check
   Case "end_date"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "end_date", sNull)
			f_Message_Chk(35, '[종료일자]')
			return 1
		end if
	/* 관할구역 */
	Case "sarea"
		SetItem(1,"cvcod",sNull)
		SetItem(1,"cvcodnm",sNull)
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"sarea",   sarea)
				SetItem(1,"cvcodnm",	scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 

		END IF
	/* 거래처명 */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,'cvcod', sCvcod)
				SetItem(1,"cvcodnm", scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 
			Return 1
		END IF
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam , ls_emp_id 
		ls_saupj = gettext() 
		//거래처
		sCode 	= this.object.cvcod[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
		End if 
 
		//관할 구역
		f_child_saupj(dw_ip, 'sarea', ls_saupj)
		ls_sarea = dw_ip.object.sarea[1] 
		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'sarea', '')
		End if 
	
		//영업담당자
		rtncode 	= dw_ip.GetChild('emp_id', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('47',ls_saupj)
		ls_emp_id = dw_ip.object.emp_id[1] 
		ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'emp_id', '')
		End if 

	
end Choose

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_04511
integer x = 46
integer y = 420
integer width = 4553
integer height = 1892
string dataobject = "d_sal_04511"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	this.SelectRow(0,False)
	
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
END IF


end event

type pb_1 from u_pb_cal within w_sal_04511
integer x = 777
integer y = 216
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('start_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'start_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_04511
integer x = 1239
integer y = 212
integer height = 80
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('end_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'end_date', gs_code)

end event

type rr_1 from roundrectangle within w_sal_04511
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 208
integer width = 4581
integer height = 184
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_sal_04511
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 412
integer width = 4581
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 46
end type

