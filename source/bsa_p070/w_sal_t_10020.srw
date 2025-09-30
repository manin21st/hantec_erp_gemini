$PBExportHeader$w_sal_t_10020.srw
$PBExportComments$업체별 ITEM별 매출액 현황
forward
global type w_sal_t_10020 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_t_10020
end type
end forward

global type w_sal_t_10020 from w_standard_print
string title = "업체별 ITEM별 매출액 내역"
rr_1 rr_1
end type
global w_sal_t_10020 w_sal_t_10020

forward prototypes
public function string wf_aftermonth (string syymm, integer n)
public function integer wf_retrieve ()
end prototypes

public function string wf_aftermonth (string syymm, integer n);string stemp

stemp = f_aftermonth(syymm,n)
stemp = Mid(stemp,1,4) + '~r~n' + Right(stemp,2)

return stemp

end function

public function integer wf_retrieve ();string	syymm, scvcod, sSteam

If dw_ip.accepttext() <> 1 Then Return -1

syymm   = trim(dw_ip.getitemstring(1, 'sdatef'))
scvcod  = trim(dw_ip.getitemstring(1, 'custcode'))
sSteam  = trim(dw_ip.getitemstring(1, 'deptcode'))

If IsNull(scvcod)  Then scvcod = ''
If IsNull(sSteam)  Then sSteam = ''

IF	f_datechk(syymm + '01'+'01') = -1 then
	MessageBox("확인","기준년월을 확인하세요!")
	dw_ip.setcolumn('sdatef')
	dw_ip.setfocus()
	Return -1
END IF

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

dw_print.SetRedraw(False)

scvcod = scvcod + '%'
sSteam = sSteam + '%'

if dw_print.retrieve(gs_sabu, syymm, scvcod, ls_silgu,sSteam) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('custcode')
	dw_ip.setfocus()
	return -1
end if

dw_print.SetRedraw(True)
dw_print.sharedata(dw_list)

Return 1
end function

on w_sal_t_10020.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_t_10020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;//Integer  li_idx
//
//li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
//w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
//w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
//w_mdi_frame.Postevent("ue_barrefresh")
//
//is_today = f_today()
//is_totime = f_totime()
//is_window_id = this.ClassName()
//
//w_mdi_frame.st_window.Text = Upper(is_window_id)
//
//SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
//  INTO :is_usegub,  :is_upmu 
//  FROM "SUB2_T"  
// WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;
//
//IF is_usegub = 'Y' THEN
//   INSERT INTO "PGM_HISTORY"  
//	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
//			   "ETIME",      "IPADD",       "USER_NAME" )  
//   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
//	   		NULL,         :gs_ipaddress, :gs_comname )  ;
//
//   IF SQLCA.SQLCODE = 0 THEN 
//	   COMMIT;
//   ELSE 	  
//	   ROLLBACK;
//   END IF	  
//END IF	  
//
//dw_ip.SetTransObject(SQLCA)
//
//dw_list.settransobject(sqlca)
//dw_print.settransobject(sqlca)
//
//IF is_upmu = 'A' THEN //회계인 경우
//   int iRtnVal 
//
//	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
//		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
//			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
//			
//			dw_ip.Modify("saupj.protect = 1")
//		ELSE
//			dw_ip.Modify("saupj.protect = 0")
//		END IF
//	ELSE
//		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
//			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
//		ELSE
//			iRtnVal = F_Authority_Chk(Gs_Dept)
//		END IF
//		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
//			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
//			
//			dw_ip.Modify("saupj.protect = 1")
//		ELSE
//			dw_ip.Modify("saupj.protect = 0")
//		END IF	
//	END IF
//END IF
//dw_print.object.datawindow.print.preview = "yes"	
//
//dw_print.ShareData(dw_list)
//
//PostEvent('ue_open')
end event

event ue_open;call super::ue_open;sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

/* User별 관할구역 Setting */
String sarea, steam, saupj

// 영업팀 권한 설정
If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("deptcode.protect=1")
	
	dw_ip.SetItem(1, 'sarea', sarea)
	dw_ip.SetItem(1, 'deptcode', steam)
End If
dw_ip.SetItem(1,"sdatef", Left(is_today,4))
dw_ip.SetColumn("sdatef")
dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_sal_t_10020
end type

type p_exit from w_standard_print`p_exit within w_sal_t_10020
end type

type p_print from w_standard_print`p_print within w_sal_t_10020
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_t_10020
end type







type st_10 from w_standard_print`st_10 within w_sal_t_10020
end type



type dw_print from w_standard_print`dw_print within w_sal_t_10020
string dataobject = "d_sal_t_10020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_t_10020
integer x = 78
integer y = 32
integer width = 3314
integer height = 156
string dataobject = "d_sal_t_10020_h"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom+'01'+'01') = -1 THEN
			f_message_chk(35,'[매출기준년월]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	/* 거래처 */
	Case "custcode"
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"custname",  sIoCustName)
		END IF
	/* 거래처명 */
	Case "custname"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2"
		  INTO :sIoCust, :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVNAS2" = :sIoCustName;
		
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			Return
		END IF
END Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		this.SetItem(1,"custname", gs_codename)
		
	/* 거래처명 */
	Case "custname"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode", gs_code)
		this.SetItem(1,"custname", gs_codename)
END Choose

end event

event dw_ip::ue_key;call super::ue_key;choose case key
	case keyenter!
		p_retrieve.TriggerEvent(Clicked!)
end choose
end event

type dw_list from w_standard_print`dw_list within w_sal_t_10020
integer x = 91
integer y = 232
integer width = 4498
integer height = 2032
string dataobject = "d_sal_t_10020_d"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_sal_t_10020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 220
integer width = 4530
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

