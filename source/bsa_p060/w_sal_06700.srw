$PBExportHeader$w_sal_06700.srw
$PBExportComments$ ===> 관할구역별 BUYER별 선적 및 입금현황
forward
global type w_sal_06700 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06700
end type
type rr_2 from roundrectangle within w_sal_06700
end type
end forward

global type w_sal_06700 from w_standard_print
string title = "관할구역별 BUYER별 선적 및 입금 현황"
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_06700 w_sal_06700

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sGubun, yy, sS, sS_Name, sCvstatus, sCvcod, ls_yymm, ls_emp_id, tx_name
If dw_ip.AcceptText() <> 1 Then Return -1

sGubun    = Trim(dw_ip.GetItemString(1,'gubun'))
yy        = Trim(dw_ip.GetItemString(1,'syy'))
ls_emp_id = Trim(dw_ip.getitemstring(1,'emp_id'))
If ls_emp_id = '' Or IsNull(ls_emp_id) Then ls_emp_id = '%'

if	(yy = '') or isNull(yy) or Len(yy) <> 4 then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

// 관할구역 선택
sS = Trim(dw_ip.GetItemString(1,'areacode'))
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

/* 거래상태 */
sCvstatus = Trim(dw_ip.GetItemString(1,'cvstatus'))
If IsNull(sCvstatus) or sCvstatus = '3' Then sCvstatus = ''

sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))
If IsNull(sCvcod) or sCvcod = '' Then sCvcod = ''

// 2003년 06월 03일 수정
dw_print.object.r_yy.Text = yy
dw_print.object.r_sarea.Text = sS_Name

If dw_print.Retrieve(gs_sabu, yy, sS,sCvcod+'%', yy+'01', sCvstatus+'%', ls_emp_id) < 1 then
   f_message_Chk(300, '[출력조건 CHECK]')
 	dw_ip.setcolumn('syy')
   dw_ip.setfocus()
 	return -1
End If

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_empid.text = '"+tx_name+"'")

dw_print.ShareData(dw_list)

SELECT MAX(JPDAT)
INTO :ls_yymm
FROM JUNPYO_CLOSING 
WHERE JPGU = 'X3' ;

if ls_yymm = '' or isnull(ls_yymm) then
	dw_print.object.tx_yymm.text ='전체'
else
	dw_print.object.tx_yymm.text = left(ls_yymm,4) +'.' + mid(ls_yymm,5,2)
end if

return 1


//dw_list.object.r_yy.Text = yy
//dw_list.object.r_sarea.Text = sS_Name
//
//If dw_list.Retrieve(gs_sabu, yy, sS,sCvcod+'%', yy+'01', sCvstatus+'%') < 1 then
//   f_message_Chk(300, '[출력조건 CHECK]')
// 	dw_ip.setcolumn('syy')
//   dw_ip.setfocus()
// 	return -1
//End If
//
//SELECT MAX(JPDAT)
//INTO :ls_yymm
//FROM JUNPYO_CLOSING 
//WHERE JPGU = 'X3' ;
//
//if ls_yymm = '' or isnull(ls_yymm) then
//	dw_list.object.tx_yymm.text ='전체'
//else
//	dw_list.object.tx_yymm.text = left(ls_yymm,4) +'.' + mid(ls_yymm,5,2)
//end if
//
//return 1
end function

on w_sal_06700.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_sal_06700.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

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

event ue_open;call super::ue_open;DataWindowChild state_child
integer rtncode
//영업담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.setitem(1,'syy',left(f_today(),4))
sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'areacode', sarea)
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
End If
end event

type p_preview from w_standard_print`p_preview within w_sal_06700
end type

type p_exit from w_standard_print`p_exit within w_sal_06700
end type

type p_print from w_standard_print`p_print within w_sal_06700
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06700
end type







type st_10 from w_standard_print`st_10 within w_sal_06700
end type



type dw_print from w_standard_print`dw_print within w_sal_06700
string dataobject = "d_sal_06700_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06700
integer x = 50
integer y = 40
integer width = 3634
integer height = 172
string dataobject = "d_sal_06700_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sCol_Name, sNull, sIoCustArea, sDept, sIoCust, sIoCustName
String sCvcod, scvnas, sarea, steam, sSaupj, sName1
sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
	Case "gubun"
		dw_list.SetRedraw(False)
		if this.GetText() = '1' then // 원화를 Click 했을 경우
			dw_list.DataObject = "d_sal_06700_02"
			dw_list.Settransobject(sqlca)
		else                         // 달러를 Click 했을 경우
			dw_list.DataObject = "d_sal_06700_03"
			dw_list.Settransobject(sqlca)
		end if		
		dw_list.SetRedraw(True)
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sIoCustArea = GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
	
	
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
			SetItem(1,"custname", scvnas)
			SetItem(1,"areacode",   sarea)	
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
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
			SetItem(1,"areacode",   sarea)
			Return 1
		END IF


//	/* 거래처 */
//	Case "custcode"
//		sIoCust = GetText()
//		IF sIoCust ="" OR IsNull(sIoCust) THEN
//			SetItem(1,"custname",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
//		IF SQLCA.SQLCODE <> 0 THEN
//			TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	/* 거래처명 */
//	Case "custname"
//		sIoCustName = Trim(GetText())
//		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
//			SetItem(1,"custcode",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
//		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
//		IF SQLCA.SQLCODE <> 0 THEN
//			TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			SetItem(1,"custcode",  sIoCust)
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//			Return
//		END IF
end Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

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
//	/* 거래처 */
//	Case "custcode"
//		gs_gubun = '2'
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
//		IF SQLCA.SQLCODE = 0 THEN
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	/* 거래처명 */
//	Case "custname"
//		gs_gubun = '2'
//		gs_codename = Trim(GetText())
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
//		IF SQLCA.SQLCODE = 0 THEN
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06700
integer x = 50
integer y = 264
integer width = 4553
integer height = 2048
string dataobject = "d_sal_06700_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06700
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 28
integer width = 3680
integer height = 192
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_sal_06700
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 256
integer width = 4581
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 46
end type

