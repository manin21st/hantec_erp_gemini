$PBExportHeader$w_sal_02590.srw
$PBExportComments$수주 취소현황 - 거래처별
forward
global type w_sal_02590 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02590
end type
type pb_2 from u_pb_cal within w_sal_02590
end type
type rr_1 from roundrectangle within w_sal_02590
end type
end forward

global type w_sal_02590 from w_standard_print
string title = "수주 취소현황 - 거래처별"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02590 w_sal_02590

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sTeam,sArea,sCust, tx_name, sOrdCancelCause, sPrtGbn,ssaupj ,ls_emp_id

If dw_ip.AcceptText() <> 1 Then Return -1

sPrtgbn = Trim(dw_ip.GetItemString(1,"prtgbn"))
sFrom  = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo    = Trim(dw_ip.GetItemString(1,"sdatet"))
sTeam  = Trim(dw_ip.GetItemString(1,"deptcode"))
sArea  = Trim(dw_ip.GetItemString(1,"areacode"))
sCust  = Trim(dw_ip.GetItemString(1,"custcode"))
sOrdCancelCause  = Trim(dw_ip.GetItemString(1,"ord_cancel_cause"))
ssaupj = dw_ip.getitemstring(1,"saupj")
ls_emp_id   = dw_ip.getitemstring(1,'emp_id')

If IsNull(sTeam) Then sTeam = ''
If IsNull(sArea) Then sArea = ''
If IsNull(sCust) Then sCust = ''
If IsNull(sOrdCancelCause) Then sOrdCancelCause = ''
if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

//IF dw_list.Retrieve(gs_sabu, sTeam+'%', sArea+'%', sCust+'%', sFrom, sTo,ssaupj,ls_emp_id, sOrdCancelCause+'%') <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	Return -1
//End If

IF dw_print.Retrieve(gs_sabu, sTeam+'%', sArea+'%', sCust+'%', sFrom, sTo,ssaupj,ls_emp_id, sOrdCancelCause+'%') <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
End If

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")
dw_print.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_sarea.text = '"+tx_name+"'")
dw_print.Modify("txt_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'custname'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_cvcod.text = '"+tx_name+"'")
dw_print.Modify("txt_cvcod.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

If sPrtGbn = '4' Then
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ord_cancel_cause) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	//dw_list.Modify("txt_cause.text = '"+tx_name+"'")
	dw_print.Modify("txt_cause.text = '"+tx_name+"'")
End If

Return 1

end function

on w_sal_02590.create
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

on w_sal_02590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)

dw_ip.Setfocus()

/* User별 관할구역 Setting */
String sarea, steam , saupj
//
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'areacode', sarea)
//	dw_ip.SetItem(1, 'deptcode', steam)
//	dw_ip.SetItem(1, 'saupj', saupj)
//   dw_ip.Modify("areacode.protect=1")
//	dw_ip.Modify("deptcode.protect=1")
//	dw_ip.Modify("areacode.background.color = 80859087")
//	dw_ip.Modify("deptcode.background.color = 80859087")
//End If


/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//영업팀
f_child_saupj(dw_ip, 'deptcode', gs_saupj) 

//관할 구역
f_child_saupj(dw_ip, 'areacode', gs_saupj) 

//영업담당자

rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 


sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
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

type p_preview from w_standard_print`p_preview within w_sal_02590
end type

type p_exit from w_standard_print`p_exit within w_sal_02590
end type

type p_print from w_standard_print`p_print within w_sal_02590
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02590
end type











type dw_print from w_standard_print`dw_print within w_sal_02590
string dataobject = "d_sal_02590_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02590
integer y = 24
integer width = 2939
integer height = 400
string dataobject = "d_sal_025901"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,sPrtGbn,snull, ls_saupj, ls_emp_id
string  sCvcod, scvnas, sarea, steam, sSaupj, sName1
Long	  rtncode 
datawindowchild state_child 

SetNull(snull)

Choose Case GetColumnName() 
 Case "sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[수주일자]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[수주일자]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF
/* 영업팀 */
 Case "deptcode"
   SetItem(1,'areacode',sNull)
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)
/* 관할구역 */
 Case "areacode"
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)
	
	sIoCustArea = this.GetText()
	IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
	  FROM "SAREA"  
	 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
   SetItem(1,'deptcode',sDept)
	
	/* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode",  		sCvcod)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
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
				SetItem(1,"custcode",  		sCvcod)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 	
		END IF
	/* 자료구분 */
	Case 'prtgbn'
		sPrtGbn = this.GetText()
		
		dw_list.SetRedraw(False)
		IF sPrtGbn = '3' THEN													/* 수주보류 */
			dw_list.DataObject = 'd_sal_02591'
		ELSEIF sPrtGbn = '4' THEN												/* 수주취소 */
			dw_list.DataObject = 'd_sal_02590'
		END IF
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
		dw_list.SetRedraw(True)
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.custcode[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 
 
		//관할 구역
		f_child_saupj(dw_ip, 'areacode', ls_saupj)
		ls_sarea = dw_ip.object.areacode[1] 
//		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'areacode', '')
//		End if 
		//영업팀
		f_child_saupj(dw_ip, 'deptcode', ls_saupj) 
		ls_steam = dw_ip.object.deptcode[1] 
//		ls_return = f_saupj_chk_t('2' , ls_steam ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'deptcode', '')
//		End if 

		//영업담당자
		rtncode 	= dw_ip.GetChild('emp_id', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('47',ls_saupj)
		ls_emp_id = dw_ip.object.emp_id[1] 
//		ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'emp_id', '')
//		End if 

		
END Choose

end event

event dw_ip::rbuttondown;string sIoCustName, sIoCustArea,	sDept,sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName() 
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
//	Case "custcode","custname"
//		gs_gubun = '1'
//		If GetColumnName() = "custname" then
//			gs_codename = Trim(GetText())
//		End If
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		
//		IF SQLCA.SQLCODE = 0 THEN
//			SetItem(1,"deptcode",  sDept)
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02590
integer x = 46
integer y = 448
integer width = 4539
integer height = 1840
string dataobject = "d_sal_02590"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_02590
integer x = 795
integer y = 40
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

type pb_2 from u_pb_cal within w_sal_02590
integer x = 1289
integer y = 40
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

type rr_1 from roundrectangle within w_sal_02590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 440
integer width = 4567
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 55
end type

