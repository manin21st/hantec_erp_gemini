$PBExportHeader$w_sal_04510.srw
$PBExportComments$ ===>입금내역 현황-회계
forward
global type w_sal_04510 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_04510
end type
type pb_2 from u_pb_cal within w_sal_04510
end type
type rr_1 from roundrectangle within w_sal_04510
end type
end forward

global type w_sal_04510 from w_standard_print
string title = "기간별 입금내역 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_04510 w_sal_04510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSarea, sSDate, sEDate, sSareana, sNull, sSaupj, tx_name, sGubun ,ls_ipgum_emp_id

SetNull(sNull)

If dw_ip.AcceptText() <> 1 Then Return -1

sSarea = Trim(dw_ip.GetItemString(1,'sarea'))
sGubun = Trim(dw_ip.GetItemString(1,'arg_gubun'))
ls_ipgum_emp_id  = dw_ip.getitemstring(1,'emp_id')

If IsNull(sGubun) Or sGubun = '' Then sGubun = '1'
If IsNull(sSarea) Or sSarea = '' Then sSarea = '%'

dw_ip.SetFocus()

sSaupj = Trim(dw_ip.GetItemString(1,'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_Message_Chk(1400, '[부가사업장]')
	dw_ip.setcolumn("saupj")
	return -1
end if

sSDate = Trim(dw_ip.GetItemString(1,'start_date'))
if f_DateChk(sSdate) = -1 then
	f_Message_Chk(35, '[시작일자]')
	dw_ip.SetItem(1, "start_date", sNull)
	dw_ip.setcolumn("start_date")
	return -1
end if
		
sEDate = Trim(dw_ip.GetItemString(1,'end_date'))
if f_DateChk(sEdate) = -1 then
	f_Message_Chk(35, '[종료일자]')
	dw_ip.SetItem(1, "end_date", sNull)
	dw_ip.setcolumn("end_date")
	return -1
end if

if	( sSDate > sEDate ) then
	f_message_Chk(200, '[시작 및 종료일 CHECK]')
	dw_ip.setcolumn("start_date")
	dw_ip.setfocus()
	Return -1
end if

if ls_ipgum_emp_id = "" or isnull(ls_ipgum_emp_id) then ls_ipgum_emp_id = '%'

//if dw_list.Retrieve(gs_sabu, sSdate, sEdate, sSarea, sSaupj, sGubun,ls_ipgum_emp_id) < 1 then
//	f_message_Chk(300, '[출력조건 CHECK]')
//	dw_ip.setcolumn('sarea')
//	dw_ip.setfocus()
//	return -1
//end if

if dw_print.Retrieve(gs_sabu, sSdate, sEdate, sSarea, sSaupj, sGubun,ls_ipgum_emp_id) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('sarea')
	dw_ip.setfocus()
	return -1
end if

dw_print.ShareData(dw_list)

dw_print.object.s_date.Text = Left(sSDate,4)+'.'+Mid(sSDate,5,2)+'.'+Right(sSDate,2)
dw_print.object.e_date.Text = Left(sEDate,4)+'.'+Mid(sEDate,5,2)+'.'+Right(sEDate,2)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

return 1
end function

on w_sal_04510.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sal_04510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;String sToday

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

sToday = f_today()

DataWindowChild state_child
integer rtncode

/* User별 관할구역 Setting */
String sarea, steam, saupj

/* 부가 사업장 */
setnull(gs_code)
f_mod_saupj(dw_ip,'saupj') 

//영업 담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

//관할 구역
rtncode 	= dw_ip.GetChild('sarea', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.SetItem(1, 'start_date', left(sToday,6) + '01' )
dw_ip.SetItem(1, 'end_date', sToday)
end event

type p_preview from w_standard_print`p_preview within w_sal_04510
end type

type p_exit from w_standard_print`p_exit within w_sal_04510
end type

type p_print from w_standard_print`p_print within w_sal_04510
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04510
end type







type st_10 from w_standard_print`st_10 within w_sal_04510
end type



type dw_print from w_standard_print`dw_print within w_sal_04510
string dataobject = "d_sal_04510_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04510
integer x = 27
integer y = 32
integer width = 3616
integer height = 220
string dataobject = "d_sal_04510_1"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, ls_saupj, ls_emp_id
Long 	 rtncode 
datawindowchild state_child 

dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
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
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
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

type dw_list from w_standard_print`dw_list within w_sal_04510
integer x = 55
integer y = 268
integer width = 4530
integer height = 2052
string dataobject = "d_sal_04510"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_sal_04510
integer x = 782
integer y = 132
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

type pb_2 from u_pb_cal within w_sal_04510
integer x = 1266
integer y = 132
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

type rr_1 from roundrectangle within w_sal_04510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4562
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

