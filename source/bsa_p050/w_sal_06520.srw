$PBExportHeader$w_sal_06520.srw
$PBExportComments$ ===> Proforma Invoice 발행현황
forward
global type w_sal_06520 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06520
end type
type pb_2 from u_pb_cal within w_sal_06520
end type
type rr_1 from roundrectangle within w_sal_06520
end type
type rr_2 from roundrectangle within w_sal_06520
end type
end forward

global type w_sal_06520 from w_standard_print
integer width = 4654
string title = "Proforma Invoice 발행현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_06520 w_sal_06520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom, sTo, sS, sS_Name, sV, sV_Name ,ls_saupj ,tx_name, sPists, ls_emp_id

If dw_ip.AcceptText() <> 1 Then Return -1

ls_saupj  = trim(dw_ip.getitemstring(1,'saupj'))
sPists    = trim(dw_ip.getitemstring(1,'pists'))
ls_emp_id = trim(dw_ip.getitemstring(1,'emp_id'))

If ls_saupj = '' Or IsNull(ls_saupj) Then ls_saupj = '%'
If sPists = '0' Then sPists = ''
If ls_emp_id = '' Or IsNull(ls_emp_id) Then ls_emp_id = '%'

sFrom = Trim(dw_ip.GetItemString(1,'d_from'))
if	(sFrom = '') or isNull(sFrom) then
	f_Message_Chk(35, '[시작일자]')
	dw_ip.setcolumn('d_from')
	dw_ip.setfocus()
	Return -1
end if

sTo = Trim(dw_ip.GetItemString(1,'d_to'))
if	(sTo = '') or isNull(sTo) then
	f_Message_Chk(35, '[종료일자]')
	dw_ip.setcolumn('d_to')
	dw_ip.setfocus()
	Return -1
end if

if	( sFrom > sTo ) then
	f_message_Chk(200, '[시작 및 종료일 CHECK]')
	dw_ip.setcolumn('d_to')
	dw_ip.setfocus()
	Return -1
END IF

// 관할구역 선택
sS = Trim(dw_ip.GetItemString(1,'sarea'))
if isNull(sS) or (sS = '') then
	sS = ''
	sS_Name = '전  체'
else
	Select sareanm Into :sS_Name 
	From sarea
	Where sarea = :sS;
	if isNull(sS_Name) then
		sS_Name = ''
	end if
end if
sS = sS + '%'

// 거래처 선택
sV = Trim(dw_ip.GetItemString(1,'cvcod'))
if isNull(sV) or (sV = '') then
	sV = '%'
	sV_Name = '전  체'
else
	sV = sV + '%'
	sV_Name = Trim(dw_ip.GetItemString(1,'cvnas'))
end if

dw_print.object.r_gigan.Text = Left(sFrom,4)+'.'+Mid(sFrom,5,2)+'.'+Right(sFrom,2) + ' - ' + &
                               Left(sTo,4)+'.'+Mid(sTo,5,2)+'.'+Right(sTo,2)
dw_print.object.r_sarea.Text = sS_Name
dw_print.object.r_cvnas.Text = sV_Name

if dw_print.Retrieve(gs_sabu, sFrom, sTo, sS, sV ,ls_saupj, sPists+'%', ls_emp_id) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('sarea')
	dw_ip.setfocus()
	return -1
end if

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pists) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pists.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_empid.text = '"+tx_name+"'")

dw_print.sharedata(dw_list)
return 1
end function

on w_sal_06520.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_sal_06520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;/* User별 관할구역 Setting */
String sarea, steam, saupj
//
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.Modify("sarea.protect=1")
//	dw_ip.Modify("sarea.background.color = 80859087")
//End If
//dw_ip.SetItem(1, "saupj", saupj)
//dw_ip.SetItem(1, "sarea", sarea)
//
/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//관할 구역
f_child_saupj(dw_ip, 'sarea', gs_saupj) 

rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.setitem(1,'d_from',left(f_today(),6) + '01')
dw_ip.setitem(1,'d_to',left(f_today(),8))

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_sal_06520
end type

type p_exit from w_standard_print`p_exit within w_sal_06520
end type

type p_print from w_standard_print`p_print within w_sal_06520
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06520
end type







type st_10 from w_standard_print`st_10 within w_sal_06520
end type



type dw_print from w_standard_print`dw_print within w_sal_06520
integer x = 3790
integer y = 40
string dataobject = "d_sal_06520_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06520
integer x = 55
integer y = 44
integer width = 3671
integer height = 164
string dataobject = "d_sal_06520_01"
end type

event dw_ip::itemchanged;String  sNull
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1, ls_saupj

SetNull(sNull)

Choose Case GetColumnName()
   // 시작일자 유효성 Check
	Case "d_from"  
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[시작일자]')
			this.SetItem(1, "d_from", sNull)
			return 1
		end if
		
	// 끝일자 유효성 Check
   Case "d_to"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "d_to", sNull)
			f_Message_Chk(35, '[종료일자]')
			return 1
		end if
		if Long(this.GetItemString(1,'d_from')) > Long(this.GetText()) then
       	f_message_Chk(200, '[시작 및 종료일 CHECK]')
         this.SetItem(1, "d_to", sNull)
      	this.setcolumn('d_to')
       	this.setfocus()			
			return 1
		end if
		
	Case "sarea"
		this.SetItem(1, "cvcod", sNull)
		this.SetItem(1, "cvnas", sNull)
		
	/* 거래처 */
	Case "cvcod"
		sCvcod = this.GetText()
		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcod",  		sCvcod)
				SetItem(1,"cvnas",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF

	/* 거래처명 */
	Case "cvnas"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcod",  		sCvcod )
				SetItem(1,"cvnas",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 

			Return 1
		END IF
		
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.cvcod[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
		End if 
 
		//관할 구역
		f_child_saupj(dw_ip, 'sarea', ls_saupj)
		ls_sarea = dw_ip.object.sarea[1] 
		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'sarea', '')
		End if 
		
end Choose
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvnas"
		gs_gubun = '2'
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
end Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_06520
integer y = 268
integer height = 2000
string dataobject = "d_sal_06520"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06520
integer x = 814
integer y = 52
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_from')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_from', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06520
integer x = 1353
integer y = 52
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_to')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_to', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33551600
integer x = 41
integer y = 24
integer width = 3863
integer height = 220
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_sal_06520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 264
integer width = 4608
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 46
end type

