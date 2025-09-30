$PBExportHeader$w_sal_02160.srw
$PBExportComments$작업지시 취소요청 현황
forward
global type w_sal_02160 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02160
end type
type pb_2 from u_pb_cal within w_sal_02160
end type
type rr_1 from roundrectangle within w_sal_02160
end type
end forward

global type w_sal_02160 from w_standard_print
string title = "작업지시 취소요청 현황"
boolean maxbox = true
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02160 w_sal_02160

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_datef,s_datet, ssaupj,tx_name

If dw_ip.accepttext() <> 1 Then Return -1

s_datef = dw_ip.getitemstring(1,"sdatef")
s_datet = dw_ip.getitemstring(1,"sdatet")
ssaupj = dw_ip.getitemstring(1,"saupj")

if f_datechk(s_datef) <> 1 Or f_datechk(s_datet) <> 1 then
	f_message_chk(30,'[취소요청일자]')
	dw_ip.setfocus()
	return -1
end if

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

IF dw_print.retrieve(gs_sabu, s_datef, s_datet, sSaupj) <= 0 THEN
   f_message_chk(50,'')
	dw_ip.setfocus()
	Return -1
END IF

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

dw_print.sharedata(dw_list)
Return 0
end function

on w_sal_02160.create
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

on w_sal_02160.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1,"sdatef", left(f_today(),6) + '01')
dw_ip.SetItem(1,"sdatet", left(f_today(),8))

/* User별 관할구역 Setting */
String sarea, steam ,saupj

//If f_check_sarea(sarea, steam , saupj) = 1 Then
//	dw_ip.SetItem(1, 'saupj', saupj)
//end If
//
f_mod_saupj(dw_ip, 'saupj')

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

type p_preview from w_standard_print`p_preview within w_sal_02160
end type

type p_exit from w_standard_print`p_exit within w_sal_02160
end type

type p_print from w_standard_print`p_print within w_sal_02160
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02160
end type







type st_10 from w_standard_print`st_10 within w_sal_02160
end type



type dw_print from w_standard_print`dw_print within w_sal_02160
string dataobject = "d_sal_02160_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02160
integer x = 78
integer y = 32
integer width = 2153
integer height = 244
string dataobject = "d_sal_02160_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname , ls_gubun
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

SetNull(snull)

Choose Case GetColumnName() 
	Case 'gubun'
		ls_gubun = this.gettext()
		
		dw_print.setredraw(false)
		if ls_gubun = '1' then
			dw_list.dataobject = 'd_sal_02160'
		   dw_print.dataobject = 'd_sal_02160_p' 
	   elseif ls_gubun = '2' then
			dw_list.dataobject = 'd_sal_02160_2'
		   dw_print.dataobject = 'd_sal_02160_2_p'
	   end if
		dw_list.settransobject(sqlca)
		dw_print.settransobject(sqlca)
		dw_print.setredraw(true)
			
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[취소요청기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[취소요청기간]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
//	/* 영업팀 */
//	Case "deptcode"
//		SetItem(1,'areacode',sNull)
//		SetItem(1,"custcode",sNull)
//		SetItem(1,"custname",sNull)
//	/* 관할구역 */
//	Case "areacode"
//		SetItem(1,"custcode",sNull)
//		SetItem(1,"custname",sNull)
//		
//		sIoCustArea = this.GetText()
//		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
//		
//		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
//		  FROM "SAREA"  
//		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
//		
//		SetItem(1,'deptcode',sDept)
//	/* 거래처 */
//	Case "custcode"
//		sIoCust = this.GetText()
//		IF sIoCust ="" OR IsNull(sIoCust) THEN
//			this.SetItem(1,"custname",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	/* 거래처명 */
//	Case "custname"
//		sIoCustName = Trim(GetText())
//		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
//			this.SetItem(1,"custcode",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
//		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			SetItem(1,"deptcode",  sDept)
//			SetItem(1,"custcode",  sIoCust)
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//			Return
//		END IF
END Choose
end event

event dw_ip::rbuttondown;//string sIoCustName,sIoCustArea,sDept
//
//SetNull(Gs_Gubun)
//SetNull(Gs_Code)
//SetNull(Gs_CodeName)
//
//Choose Case this.GetColumnName() 
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
//END Choose
//
end event

type dw_list from w_standard_print`dw_list within w_sal_02160
integer x = 91
integer y = 308
integer width = 4507
integer height = 1988
string dataobject = "d_sal_02160"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_sal_02160
integer x = 1577
integer y = 72
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

type pb_2 from u_pb_cal within w_sal_02160
integer x = 2071
integer y = 72
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

type rr_1 from roundrectangle within w_sal_02160
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 300
integer width = 4530
integer height = 2008
integer cornerheight = 40
integer cornerwidth = 55
end type

