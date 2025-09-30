$PBExportHeader$w_sal_02670.srw
$PBExportComments$ **세금계산서 발행현황
forward
global type w_sal_02670 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02670
end type
type pb_2 from u_pb_cal within w_sal_02670
end type
type dw_excel from datawindow within w_sal_02670
end type
type cb_excel from commandbutton within w_sal_02670
end type
type rr_1 from roundrectangle within w_sal_02670
end type
type rr_3 from roundrectangle within w_sal_02670
end type
end forward

global type w_sal_02670 from w_standard_print
string title = "세금계산서 발행현황"
pb_1 pb_1
pb_2 pb_2
dw_excel dw_excel
cb_excel cb_excel
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_02670 w_sal_02670

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sTeam,sArea,sCust,sTeamName,sAreaName, tx_name,ssaupj, sGubun

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTo         = dw_ip.GetItemString(1,"sdatet")
sArea       = Trim(dw_ip.GetItemString(1,"areacode"))
sCust       = Trim(dw_ip.GetItemString(1,"custcode"))
ssaupj 		= dw_ip.getitemstring(1,"saupj")
sGubun      = Trim(dw_ip.GetItemString(1,"gubun"))

If IsNull(sArea) or sArea = '' then sArea = ''
If IsNull(sCust) or sCust = '' then sCust = ''
If IsNull(sGubun) or sGubun = '' then sGubun = '1'

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

//IF dw_list.Retrieve(gs_sabu, sFrom, sTo, sArea+'%', sCust+'%',ssaupj, sGubun) <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	Return -1
//End If

IF dw_print.Retrieve(gs_sabu, sFrom, sTo, sArea+'%', sCust+'%',ssaupj, sGubun) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
End If

IF dw_excel.Retrieve(gs_sabu, sFrom, sTo, sArea+'%', sCust+'%',ssaupj, sGubun) <=0 THEN
	Return -1
End If

dw_print.ShareData(dw_list)

//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_list.Modify("tx_sarea.text = '"+tx_name+"'")
//dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

Return 1
end function

on w_sal_02670.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_excel=create dw_excel
this.cb_excel=create cb_excel
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.dw_excel
this.Control[iCurrent+4]=this.cb_excel
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_3
end on

on w_sal_02670.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_excel)
destroy(this.cb_excel)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;DataWindowChild state_child
integer rtncode

//관할 구역
rtncode 	= dw_ip.GetChild('areacode', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)

/* User별 관할구역 Setting */
String sarea, steam , saupj
//
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'areacode', sarea)
//	dw_ip.SetItem(1, 'saupj', saupj)
//   dw_ip.Modify("areacode.protect=1")
//	dw_ip.Modify("areacode.background.color = 80859087")
//End If
//
//
/* 부가 사업장 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

//관할 구역
f_child_saupj(dw_ip, 'areacode', '%') 

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)
dw_ip.Setfocus()



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
dw_excel.settransobject(sqlca)

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

type p_xls from w_standard_print`p_xls within w_sal_02670
boolean visible = true
integer x = 3653
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_sal_02670
end type

type p_preview from w_standard_print`p_preview within w_sal_02670
end type

type p_exit from w_standard_print`p_exit within w_sal_02670
end type

type p_print from w_standard_print`p_print within w_sal_02670
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02670
end type











type dw_print from w_standard_print`dw_print within w_sal_02670
integer x = 3744
integer y = 148
string dataobject = "d_sal_02670_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02670
integer x = 55
integer y = 60
integer width = 3195
integer height = 180
string dataobject = "d_sal_02670_01"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;
IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary
string  sCvcod, scvnas, sarea, steam, sSaupj, sName1
String ls_saupj, ls_sarea, ls_return, ls_steam, ls_emp_id, ls_pdtgu,scode
long rtncode 
Datawindowchild state_child 

SetNull(snull)

Choose Case GetColumnName() 
  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[발행기간]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[발행기간]')
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
	
	Case "custcode"
		sCvcod = Trim(GetText())
		IF 	sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"custname", scvnas)
		END IF
		
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		If 	f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
		END IF


	case 'saupj' 
		
		//거래처
		ls_saupj = gettext() 
		sCode 	= this.object.custcode[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 
//		//관할 구역
//		f_child_saupj(dw_ip, 'areacode', ls_saupj)
//		ls_sarea = dw_ip.object.areacode[1] 
//		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'areacode', '')
//		End if 

Case 'prtgb'
	sPrtGbn = Trim(GetText())
	
	dw_list.SetRedraw(False)
	/* 일자기준 */
	If sPrtGbn = '1' Then
    	dw_list.DataObject = 'd_sal_02670'
		dw_print.DataObject = 'd_sal_02670_p' 
	Else
		dw_list.DataObject = 'd_sal_02670_1'
		dw_print.DataObject = 'd_sal_02670_1_p'
	End If
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)	
	dw_list.SetRedraw(True)
	
	p_preview.Enabled = False
	p_print.Enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	
END Choose

end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
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
///* 거래처 */
// Case "custcode"
//	gs_gubun = '1'
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"custcode",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"deptcode",  sDept)
//	  this.SetItem(1,"custname",  sIoCustName)
//	  this.SetItem(1,"areacode",  sIoCustArea)
//	END IF
///* 거래처명 */
// Case "custname"
//	gs_gubun = '1'
//	gs_codename = Trim(GetText())
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"custcode",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"deptcode",  sDept)
//	  this.SetItem(1,"custname",  sIoCustName)
//	  this.SetItem(1,"areacode",  sIoCustArea)
//	END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02670
integer y = 296
integer width = 4562
integer height = 2024
string dataobject = "d_sal_02670"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_02670
integer x = 763
integer y = 72
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

type pb_2 from u_pb_cal within w_sal_02670
integer x = 1221
integer y = 72
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

type dw_excel from datawindow within w_sal_02670
boolean visible = false
integer x = 3397
integer y = 8
integer width = 192
integer height = 136
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_02670_esero"
boolean border = false
boolean livescroll = true
end type

type cb_excel from commandbutton within w_sal_02670
integer x = 4041
integer y = 188
integer width = 576
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전자세금계산서 양식"
end type

event clicked;If dw_list.Rowcount() <= 0 Then Return

string ls_filter , ls_checkno
Long ll_i, ll_row, ll_cnt

ll_row = dw_list.RowCount()
ll_cnt = 0
ls_filter = ""

//선택된 DATA만 엑셀로 다운/////////////////////////////////////////////////////////////////////////////////////
//FOR ll_i = 1 TO ll_row 
//
//	If dw_list.Object.chk[ll_i] = 'Y' then
//		ll_cnt ++
//		ls_checkno = Trim(dw_list.GetItemString(ll_i,"checkno"))
//		if ll_cnt = 1 then
//			
//			ls_filter = 'checkno = string(' + ls_checkno + ')'
//		else
//			ls_filter = ls_filter + ' or checkno = string('+ ls_checkno + ')'
//		end if
//		
//		update saleh set lin_no = 1
//		where checkno = :ls_checkno;
//		
//		commit;
//				
//	End If
//		
//NEXT
//
//dw_excel.SetFilter(ls_filter)
//dw_excel.filter()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//dw_print.ShareData(dw_excel)
// 데이터 윈도우 타이틀에 빈공백 4줄은 엑셀 양식에 6번째 행부터 데이터가 있어여 함
//gf_save_html(dw_excel)
wf_excel_down(dw_excel)

//p_retrieve.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within w_sal_02670
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 40
integer width = 3360
integer height = 216
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_sal_02670
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 284
integer width = 4599
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 46
end type

