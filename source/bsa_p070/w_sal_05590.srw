$PBExportHeader$w_sal_05590.srw
$PBExportComments$월별 판매실적 현황(생산팀별)
forward
global type w_sal_05590 from w_standard_dw_graph
end type
end forward

global type w_sal_05590 from w_standard_dw_graph
string title = "월별 판매실적 현황(생산팀별)"
end type
global w_sal_05590 w_sal_05590

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ym, sT, sS, sV, sT_Name, sS_Name, sV_Name

If dw_ip.AcceptText() <> 1 Then Return -1

ym = Trim(dw_ip.GetItemString(1,'sym'))
if	(ym = '') or isNull(ym) then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.setcolumn('sym')
	dw_ip.setfocus()
	Return -1
end if

sT = Trim(dw_ip.GetItemString(1,'deptcode'))
if isNull(sT) or (sT = '') then
	sT = ''
	sT_Name = '전  체'
else
	Select steamnm Into :sT_Name 
	From steam
	Where steamcd = :sT;
	if isNull(sT_Name) then
		sT_Name = ''
	end if
end if
sT = sT + '%'

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

sV = Trim(dw_ip.GetItemString(1,'custcode'))
if isNull(sV) or (sV = '') then
	sV = '%'
	sV_Name = '전  체'
else
	sV = sV + '%'
	sV_Name = Trim(dw_ip.GetItemString(1,'custname'))
end if

dw_list.object.r_ym.Text = Left(ym,4) + '.' + Right(ym,2)
dw_list.object.r_steam.Text = sT_Name
dw_list.object.r_sarea.Text = sS_Name
dw_list.object.r_cvcod.Text = sV_Name

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_list.Retrieve(gs_sabu, ym, sV, sS, sT,ls_silgu) < 1 then
   f_message_Chk(300, '[출력조건 CHECK]')
  	dw_ip.setcolumn('sym')
   dw_ip.setfocus()
  	return -1
end if

return 1
end function

on w_sal_05590.create
call super::create
end on

on w_sal_05590.destroy
call super::destroy
end on

event open;call super::open;dw_ip.setitem(1,'sym',left(f_today(),6))
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05590
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05590
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05590
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05590
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05590
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05590
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05590
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05590
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05590
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05590
integer y = 32
integer width = 3991
integer height = 148
string dataobject = "d_sal_05590_01"
end type

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

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
END Choose
end event

event dw_ip::itemerror;return 1
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

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05590
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05590
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05590
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05590
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05590
integer width = 4562
string dataobject = "d_sal_05590"
boolean border = false
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05590
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05590
integer width = 4594
end type

