$PBExportHeader$w_sal_06730.srw
$PBExportComments$L/C 등록 현황
forward
global type w_sal_06730 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06730
end type
type pb_2 from u_pb_cal within w_sal_06730
end type
type rr_1 from roundrectangle within w_sal_06730
end type
type rr_4 from roundrectangle within w_sal_06730
end type
end forward

global type w_sal_06730 from w_standard_print
string title = "기간별 L/C 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_4 rr_4
end type
global w_sal_06730 w_sal_06730

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_cvcod, s_datef,s_datet, sdeptcode, sareacode,tx_name, ls_emp_id

If dw_ip.accepttext() <> 1 Then Return -1

s_datef   = dw_ip.getitemstring(1,"sdatef")
s_datet   = dw_ip.getitemstring(1,"sdatet")
s_cvcod   = dw_ip.getitemstring(1,"custcode")
sdeptcode = dw_ip.getitemstring(1,"deptcode")
sareacode = dw_ip.getitemstring(1,"areacode")
ls_emp_id = dw_ip.getitemstring(1,'emp_id')

If ls_emp_id = '' Or IsNull(ls_emp_id) Then ls_emp_id = '%'
//필수입력항목 체크///////////////////////////////////
if f_datechk(s_datef) <> 1 Or f_datechk(s_datet) <> 1 then
	f_message_chk(30,'[출고기간]')
	dw_ip.setfocus()
	return -1
end if

If IsNull(s_cvcod ) Then s_cvcod = ''
If IsNull(sdeptcode ) Then sdeptcode = ''
If IsNull(sareacode ) Then sareacode = ''

dw_list.SetRedraw(False)

//조회////////////////////////////////////////////////
IF dw_print.retrieve(gs_sabu, s_datef, s_datet, sdeptcode+'%',sareacode+'%',s_cvcod+'%', ls_emp_id) <= 0 THEN
   f_message_chk(50,'')
	dw_list.SetRedraw(True)
	dw_list.insertrow(0)
	Return -1
END IF
dw_print.sharedata(dw_list)
tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetItemString(1,'custname'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_cvcod.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_empid.text = '"+tx_name+"'")

dw_list.SetRedraw(True)

Return 0
end function

on w_sal_06730.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_4
end on

on w_sal_06730.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_4)
end on

event ue_open;call super::ue_open;DataWindowChild state_child
integer rtncode

//영업담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

//관할 구역
f_child_saupj(dw_ip, 'areacode', gs_saupj) 

dw_ip.reset()
dw_ip.insertrow(0)
dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)
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

type p_xls from w_standard_print`p_xls within w_sal_06730
end type

type p_sort from w_standard_print`p_sort within w_sal_06730
end type

type p_preview from w_standard_print`p_preview within w_sal_06730
end type

type p_exit from w_standard_print`p_exit within w_sal_06730
end type

type p_print from w_standard_print`p_print within w_sal_06730
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06730
end type







type st_10 from w_standard_print`st_10 within w_sal_06730
end type



type dw_print from w_standard_print`dw_print within w_sal_06730
string dataobject = "d_sal_06730_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06730
integer x = 50
integer y = 64
integer width = 3438
integer height = 164
string dataobject = "d_sal_067301"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn

SetNull(snull)

Choose Case GetColumnName() 
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
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"deptcode",  sDept)
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			SetItem(1,"areacode",  sIoCustArea)
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
		gs_gubun = '2'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		gs_gubun = '2'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06730
integer x = 46
integer y = 284
integer width = 4567
integer height = 2028
string dataobject = "d_sal_06730"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06730
integer x = 709
integer y = 64
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked; //해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06730
integer x = 1179
integer y = 64
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06730
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33551600
integer x = 37
integer y = 52
integer width = 3497
integer height = 204
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_sal_06730
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 276
integer width = 4590
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 46
end type

