$PBExportHeader$w_sal_06720.srw
$PBExportComments$ Nego 현황
forward
global type w_sal_06720 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06720
end type
type pb_1 from u_pb_cal within w_sal_06720
end type
type rr_2 from roundrectangle within w_sal_06720
end type
type pb_2 from u_pb_cal within w_sal_06720
end type
end forward

global type w_sal_06720 from w_standard_print
string title = "Nego 현황"
rr_1 rr_1
pb_1 pb_1
rr_2 rr_2
pb_2 pb_2
end type
global w_sal_06720 w_sal_06720

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sArea,sAreaName, tx_name, sCurr, sNgno, sCust, sempid

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTo         = dw_ip.GetItemString(1,"sdatet")
sArea       = dw_ip.GetItemString(1,"areacode")
sCust       = dw_ip.GetItemString(1,"custcode")
sCurr       = dw_ip.GetItemString(1,"currgb")
sNgno       = dw_ip.GetItemString(1,"Ngno")
sempid      = dw_ip.getitemstring(1,'emp_id')

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

IF sArea  = "" OR IsNull(sArea)  THEN sArea  = ''
IF sCust  = "" OR IsNull(sCust)  THEN sCust  = ''
IF sNgno  = "" OR IsNull(sNgno)  THEN sNgno  = ''
If sempid = "" Or IsNull(sempid) THEN sempid = ''

IF dw_print.Retrieve(gs_sabu, sFrom, sTo, sArea+'%',sCust+'%', sCurr, sNgno+'%', sempid+'%' ) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	dw_print.InsertRow(0)
//	Return -1
else
	dw_print.sharedata(dw_list)
END IF

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If tx_name = '' Then tx_name = '전체'
dw_print.Object.tx_sarea.text = tx_name

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(currgb) ', 1)"))
If tx_name = '' Then tx_name = '전체'
dw_print.Object.tx_curr.text = tx_name

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_empid.text = '"+tx_name+"'")

Return 1
end function

on w_sal_06720.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.pb_1=create pb_1
this.rr_2=create rr_2
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.pb_2
end on

on w_sal_06720.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.pb_1)
destroy(this.rr_2)
destroy(this.pb_2)
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
dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)


//영업팀 
f_child_saupj(dw_ip, 'areacode', gs_saupj) 


dw_ip.SetColumn("deptcode")
dw_ip.Setfocus()

end event

type p_xls from w_standard_print`p_xls within w_sal_06720
end type

type p_sort from w_standard_print`p_sort within w_sal_06720
end type

type p_preview from w_standard_print`p_preview within w_sal_06720
end type

type p_exit from w_standard_print`p_exit within w_sal_06720
end type

type p_print from w_standard_print`p_print within w_sal_06720
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06720
end type











type dw_print from w_standard_print`dw_print within w_sal_06720
integer x = 3945
integer y = 172
integer height = 92
string dataobject = "d_sal_06720_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06720
integer x = 32
integer y = 44
integer width = 3867
integer height = 180
string dataobject = "d_sal_06720_01"
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

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,snull
String  sPrtGbn

SetNull(snull)

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
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[판매기간]')
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
/* 출력구분 */
Case 'prtgbn'
	sPrtGbn = Trim(GetText())
	
	dw_list.SetRedraw(False)
	If sPrtGbn = '1' Then
		dw_list.DataObject = 'd_sal_06720'
		dw_print.DataObject = 'd_sal_06720_p'
		dw_print.setTransObject(sqlca)
	Else
		dw_list.DataObject = 'd_sal_067201'
		dw_print.DataObject = 'd_sal_067201_p'
		dw_print.SetTransObject(sqlca)
	End If
	dw_list.SetRedraw(True)
END Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName() 
	Case "custcode","custname"
		gs_gubun = '2'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			SetItem(1,"deptcode",  sDept)
			SetItem(1,"custname",  sIoCustName)
			SetItem(1,"areacode",  sIoCustArea)
		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06720
integer y = 272
integer width = 4562
integer height = 2032
string dataobject = "d_sal_06720"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06720
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33551600
integer x = 27
integer y = 28
integer width = 3881
integer height = 216
integer cornerheight = 40
integer cornerwidth = 46
end type

type pb_1 from u_pb_cal within w_sal_06720
integer x = 654
integer y = 56
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type rr_2 from roundrectangle within w_sal_06720
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 264
integer width = 4581
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 46
end type

type pb_2 from u_pb_cal within w_sal_06720
integer x = 1152
integer y = 52
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

