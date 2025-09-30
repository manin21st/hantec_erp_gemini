$PBExportHeader$w_sal_05750.srw
$PBExportComments$년도별 판매추이 분석 현황
forward
global type w_sal_05750 from w_standard_dw_graph
end type
end forward

global type w_sal_05750 from w_standard_dw_graph
string title = "년도별 판매추이 분석 현황"
end type
global w_sal_05750 w_sal_05750

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom, sTeam, sArea, sCust, sTeamName, sAreaName, sCustName, sPrtGbn
String sCurr
Long   ix, iyear, iy, nRow
Double dAmt[10]

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTeam       = dw_ip.GetItemString(1,"deptcode")
sArea       = dw_ip.GetItemString(1,"areacode")
sCust       = dw_ip.GetItemString(1,"custcode")
sCustName   = dw_ip.GetItemString(1,"custname")
sPrtGbn     = dw_ip.GetItemString(1,"prtgbn")
sCurr       = dw_ip.GetItemString(1,"curr")

IF sTeam = "" OR IsNull(sTeam) THEN sTeam = ''
IF sArea = "" OR IsNull(sArea) THEN sArea = ''
IF sCust = "" OR IsNull(sCust) THEN sCust = ''
IF sCurr = "" OR IsNull(sCurr) THEN sCurr = 'WON'

dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If dw_list.retrieve(gs_sabu,sFrom, steam+'%',sarea+'%',sCust+'%', sCurr,ls_silgu) < 1 Then
	f_message_chk(50,"")
	dw_list.SetRedraw(True)
	return -1
end if


/* 총계 */
iyear = Long(sFrom)
For ix = 1 To dw_list.RowCount()
	iy = 10 - ( iyear - Long(Left(dw_list.GetItemString(ix,'year'),4)) )
	dAmt[iy] += dw_list.GetItemNumber(ix,'sales_amt')
Next

iyear = iyear - 10
For ix = 1 To 10
	nRow = dw_list.InsertRow(0)
	
	dw_list.SetItem(nRow,'year', String(iyear + ix)+'년')
	dw_list.SetItem(nRow,'code', '99')
	dw_list.SetItem(nRow,'codename', '[총  합]')
	dw_list.SetItem(nRow,'sales_amt', dAmt[ix])
Next

// title 년월 설정
String txt_name

txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_list.Object.txt_steamcd.text = txt_name

txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
dw_list.Object.txt_sarea.text = txt_name

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05750.create
call super::create
end on

on w_sal_05750.destroy
call super::destroy
end on

event open;call super::open;dw_ip.setitem(1,'sdatef',left(f_today(),4))
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05750
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05750
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05750
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05750
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05750
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05750
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05750
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05750
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05750
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05750
integer x = 18
integer y = 20
integer width = 3982
integer height = 196
string dataobject = "d_sal_05750_04"
end type

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn
Long    ix

SetNull(snull)

Choose Case GetColumnName() 
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
/* 자료구분 */
	Case 'prtgbn'
		sPrtGbn = this.GetText()
	
		dw_list.SetRedraw(False)
		IF sPrtGbn = '1' THEN
			dw_list.DataObject = 'd_sal_05750_01'
		ELSEIF sPrtGbn = '2' THEN
			dw_list.DataObject = 'd_sal_05750_02'
		ELSEIF sPrtGbn = '4' THEN
			dw_list.DataObject = 'd_sal_05750_05'
		ELSE
			dw_list.DataObject = 'd_sal_05750_03'
		END IF
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
		dw_list.SetRedraw(True)
END Choose
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sIoCustName,sIoCustArea,sDept, sPrtGbn

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
		gs_gubun = '1'
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

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05750
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05750
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05750
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05750
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05750
string dataobject = "d_sal_05750_01"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05750
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05750
end type

