$PBExportHeader$w_sal_02510.srw
$PBExportComments$거래처별 매출현황
forward
global type w_sal_02510 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02510
end type
type pb_2 from u_pb_cal within w_sal_02510
end type
type rr_1 from roundrectangle within w_sal_02510
end type
type rr_3 from roundrectangle within w_sal_02510
end type
end forward

global type w_sal_02510 from w_standard_print
string title = "거래처별 매출현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_02510 w_sal_02510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sTeam, sArea, sCust,sTeamName,sAreaName, sCustName,ssaupj,tx_name
String sSpecialSpec, sSpecialYn, sGubun ,ls_emp_id, sLclgbn, ls_ittyp

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       	= dw_ip.GetItemString(1,"sdatef")
sTo         	= dw_ip.GetItemString(1,"sdatet")
sTeam       	= dw_ip.GetItemString(1,"deptcode")
sCust       	= dw_ip.GetItemString(1,"custcode")
sCustName   	= dw_ip.GetItemString(1,"custname")
sSpecialSpec 	= dw_ip.GetItemString(1,"special_spec")
sSpecialYn   	= dw_ip.GetItemString(1,"special_yn")
ssaupj 			= dw_ip.getitemstring(1,"saupj")
sGubun 			= dw_ip.getitemstring(1,"gubun")
ls_emp_id    	= dw_ip.getitemstring(1,'emp_id')
sLclgbn    		= dw_ip.getitemstring(1,'lclgbn')
ls_ittyp			= dw_ip.getitemstring(1,'ittyp')

If IsNull(sGubun) Or sgubun = '' Then sGubun = '1'
If IsNull(ls_ittyp) Or ls_ittyp = '' Then ls_ittyp = ''

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

If 	IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
IF 	sTeam = "" OR IsNull(sTeam) THEN sTeam = '%'
IF 	sArea = "" OR IsNull(sArea) THEN sArea = '%'
IF 	sCust = "" OR IsNull(sCust) THEN sCust = '%'
If 	sSpecialSpec = '' Or IsNull(sSpecialSpec) or sSpecialSpec='N' Then sSpecialSpec = ''
If 	sSpecialYn = '' Or IsNull(sSpecialYn) or sSpecialYn='N' Then sSpecialYn = ''
if 	ls_emp_id ="" or isnull(ls_emp_id) then ls_emp_id = '%'

//IF dw_list.Retrieve(gs_sabu,sFrom,sTo,sTeam,sArea,sCust, sspecialspec+'%', sspecialyn+'%',ssaupj,ls_emp_id, sgubun) <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	Return -1
//END IF
IF dw_print.Retrieve(gs_sabu,sFrom,sTo,sTeam,sArea,sCust, sspecialspec+'%', sspecialyn+'%',ssaupj,ls_emp_id, sgubun, sLclgbn, ls_ittyp+'%') <= 0 THEN
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
END IF
	
dw_print.ShareData(dw_list)

IF 	sTeam ='%' THEN
	dw_print.Modify("txt_team.text = '전 체'")
ELSE
	SELECT "STEAM"."STEAMNM"  	INTO :sTeamName  
		  FROM "STEAM"  
   	       WHERE "STEAM"."STEAMCD" = :sTeam   ;

		dw_print.Modify("txt_team.text = '"+sTeamName+"'")
END IF
	

If 	IsNull(sCustName) or sCustName = '' then
	dw_print.Modify("txt_cvcod.text = '전체'")
Else
	dw_print.Modify("txt_cvcod.text = '"+sCustName+"'")
End If

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If 	IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If 	IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")
	
	
//	IF sTeam ='%' THEN
//		dw_list.Modify("txt_team.text = '전 체'")
//	ELSE
//		SELECT "STEAM"."STEAMNM"  	INTO :sTeamName  
//		  FROM "STEAM"  
//   	 WHERE "STEAM"."STEAMCD" = :sTeam   ;
//
//		dw_list.Modify("txt_team.text = '"+sTeamName+"'")
//	END IF
//	
//	IF sArea ='%' THEN
//		dw_list.Modify("txt_area.text = '전 체'")
//	ELSE
//		SELECT "SAREA"."SAREANM"  	INTO :sAreaName  
//		  FROM "SAREA"  
//   	 WHERE "SAREA"."SAREA" = :sArea   ;
//
//		dw_list.Modify("txt_area.text = '"+sAreaName+"'")
//	END IF
//
//  If IsNull(sCustName) or sCustName = '' then
//		dw_list.Modify("txt_cvcod.text = '전체'")
//	Else
//		dw_list.Modify("txt_cvcod.text = '"+sCustName+"'")
//	End If
//	
//	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
//	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//	dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
//
//   tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
//	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//	dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
	
Return 1

end function

on w_sal_02510.create
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

on w_sal_02510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;
/* User별 관할구역 Setting */
String sarea, steam , saupj
//
//If 	f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'deptcode', steam)
//	dw_ip.SetItem(1, 'saupj', saupj)
//	dw_ip.Modify("deptcode.protect=1")
//	dw_ip.Modify("deptcode.background.color = 80859087")
//End If

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

/* 사업장 구분 */

setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//영업팀
f_child_saupj(dw_ip, 'deptcode', gs_saupj) 

//영업 담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 

dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)
dw_ip.SetColumn("deptcode")
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

type p_preview from w_standard_print`p_preview within w_sal_02510
end type

type p_exit from w_standard_print`p_exit within w_sal_02510
end type

type p_print from w_standard_print`p_print within w_sal_02510
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02510
end type











type dw_print from w_standard_print`dw_print within w_sal_02510
integer x = 3561
integer y = 64
string dataobject = "d_sal_025102_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02510
integer x = 64
integer y = 208
integer width = 4526
integer height = 172
string dataobject = "d_sal_025101"
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

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname , sCvcod, scvnas, sarea, steam, sSaupj, sName1
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary ,ls_gubun2
String ls_saupj, scode, ls_sarea, ls_return, ls_steam, ls_emp_id, ls_pdtgu
long rtncode 
Datawindowchild state_child 

SetNull(snull)

sPrtGbn 		= Trim(GetItemString(1,'prtgbn'))
sSummary 	= Trim(GetItemString(1,'summary'))
ls_gubun2 	= getitemstring(1,'gubun2')

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[판매기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF 	sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF 	f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[판매기간]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
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


	Case 'prtgbn'                          //-- 송장기준, 매출기준
		sPrtGbn 		= Trim(GetText())
		
		dw_list.SetRedraw(False)
		/* 송장기준 */
		If sPrtGbn = '1' Then
			dw_ip.Object.sdatef_t.text = '송장기간'
			dw_list.setredraw(false)
			if ls_gubun2 = '1' then
				dw_list.DataObject 	= 'd_sal_025103'
				dw_print.DataObject 	= 'd_sal_025103_p'
			else
				dw_list.DataObject 	= 'd_sal_025106'
				dw_print.DataObject 	= 'd_sal_025106_p'
			end if
		Else
			/* 매출기준 */
			If sSummary = 'Y' Then
				dw_ip.Object.sdatef_t.text = '수불기간'
				dw_list.setredraw(false)
				if 	ls_gubun2 = '1' then
					dw_list.DataObject 		= 'd_sal_025104'
					dw_print.DataObject 	= 'd_sal_025104_p'
				else 
					dw_list.DataObject 		= 'd_sal_025107'
					dw_print.DataObject 	= 'd_sal_025107_p'
				end if
			Else
				dw_ip.Object.sdatef_t.text = '수불기간'
				dw_list.setredraw(false)
				if ls_gubun2 = '1' then
					dw_list.DataObject 	= 'd_sal_025102'
					dw_print.DataObject 	= 'd_sal_025102_p'
				else 
					dw_list.DataObject 	= 'd_sal_025105'
					dw_print.DataObject 	= 'd_sal_025105_p'
				end if
			End If
		End If
		dw_list.SetRedraw(True)
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
	Case 'summary'                  // -- True [ 요약 ]
		sSummary 	= Trim(GetText())
		
		/* 매출기준일 경우만 */
		If 	sPrtGbn = '2' Then
			dw_list.SetRedraw(False)
			If 	sSummary = 'Y' Then
				dw_ip.Object.sdatef_t.text 	= '수불기간'
				if 	ls_gubun2 = '1' then
					dw_list.DataObject 		= 'd_sal_025104'
					dw_print.DataObject 	= 'd_sal_025104_p'
				else 
					dw_list.DataObject 		= 'd_sal_025107'
					dw_print.DataObject 	= 'd_sal_025107_p'
				end if
			Else
				dw_ip.Object.sdatef_t.text 	= '수불기간'
				if ls_gubun2 = '1' then
					dw_list.DataObject 		= 'd_sal_025102'
					dw_print.DataObject 	= 'd_sal_025102_p'
				else 
					dw_list.DataObject 		= 'd_sal_025105'
					dw_print.DataObject 	= 'd_sal_025105_p'
				end if
			End If
			dw_list.SetRedraw(True)
			dw_list.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)
		End If
	Case 'gubun2'          // --  품목별 , 중분류별.
		ls_gubun2 = gettext()
		
		dw_list.setredraw(false)
		if 	ls_gubun2 = '1' then
			if 	sprtgbn = '1' then
				dw_list.dataobject 			= 'd_sal_025103'
				dw_print.dataobject 			= 'd_sal_025103_p'
			else
				if 	ssummary = '1' then
					dw_list.dataobject 		= 'd_sal_025104'
					dw_print.dataobject 		= 'd_sal_025104_p'
					dw_ip.Object.sdatef_t.text = '송장기간'
				else
					dw_list.dataobject 		= 'd_sal_025102'
					dw_print.dataobject 		= 'd_sal_025102_p'
				end if
				dw_ip.Object.sdatef_t.text 	= '수불기간'
			end if
		else
			if 	sprtgbn = '1' then
				dw_list.dataobject 			= 'd_sal_025106'
				dw_print.dataobject 			= 'd_sal_025106_p'
				dw_ip.Object.sdatef_t.text 	= '송장기간'
			else
				if 	ssummary = '1' then
					dw_list.dataobject 		= 'd_sal_025107'
					dw_print.dataobject 		= 'd_sal_025107_p'
				else
					dw_list.dataobject 		= 'd_sal_025105'
					dw_print.dataobject 		= 'd_sal_025105_p'
				end if
				dw_ip.Object.sdatef_t.text 	= '수불기간'
			end if
		end if
		dw_list.setredraw(true)
		dw_list.settransobject(sqlca)
		dw_print.SetTransObject(SQLCA)
	case 'saupj' 
		
		//거래처
		ls_saupj = gettext() 
		sCode 	= this.object.custcode[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 
		//영업팀
		f_child_saupj(dw_ip, 'deptcode', ls_saupj) 
		ls_steam = dw_ip.object.deptcode[1] 
		ls_return = f_saupj_chk_t('2' , ls_steam ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'deptcode', '')
		End if 
		
		//영업 담당자
		rtncode 	= dw_ip.GetChild('emp_id', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('47',ls_saupj)
		ls_emp_id = dw_ip.object.emp_id[1]
		ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'emp_id', '')
		End if 
		
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
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)

//	/* 거래처 */
//	Case "custcode"
//		gs_gubun = '1'
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	/* 거래처명 */
//	Case "custname"
//		gs_gubun = '1'
//		gs_codename = Trim(GetText())
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02510
integer x = 59
integer y = 420
integer width = 4539
integer height = 1892
string dataobject = "d_sal_025102"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_02510
integer x = 1051
integer y = 208
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

type pb_2 from u_pb_cal within w_sal_02510
integer x = 1486
integer y = 204
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

type rr_1 from roundrectangle within w_sal_02510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 196
integer width = 4567
integer height = 204
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_sal_02510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 412
integer width = 4567
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 46
end type

