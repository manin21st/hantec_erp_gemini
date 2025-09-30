$PBExportHeader$w_sal_05640.srw
$PBExportComments$년간 제품별 판매실적 현황=========> 미사용
forward
global type w_sal_05640 from w_standard_print
end type
end forward

global type w_sal_05640 from w_standard_print
string title = "년간 제품별 판매실적 현황"
long backcolor = 80859087
end type
global w_sal_05640 w_sal_05640

forward prototypes
public function string wf_get_itnct (string ar_ittyp, string ar_itcls)
public function integer wf_retrieve ()
end prototypes

public function string wf_get_itnct (string ar_ittyp, string ar_itcls);string get_rfna

//SELECT "ITNCT"."BIGO" 
SELECT "ITNCT"."TITNM" 
  INTO :get_rfna 
  FROM "ITNCT" 
 WHERE ( "ITNCT"."ITTYP" = :ar_ittyp ) AND 
       ( "ITNCT"."ITCLS" = :ar_itcls ) ; 

If IsNull(get_rfna) Then get_rfna = ''

Return get_rfna

end function

public function integer wf_retrieve ();string	fr_yymm,to_yymm,sarea,cvcod, tx_name

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

fr_yymm  = trim(dw_ip.getitemstring(1, 'sdatef'))
to_yymm  = trim(dw_ip.getitemstring(1, 'sdatet'))
sarea = trim(dw_ip.getitemstring(1, 'areacode'))
cvcod = trim(dw_ip.getitemstring(1, 'custcode'))

If IsNull(sarea)  Then sarea = ''
If IsNull(cvcod)  Then cvcod = ''

////////////////////////////////////////////////////// 기간 유효성 check
IF	f_datechk(fr_yymm+'01') = -1 then
	MessageBox("확인","매출기간을 확인하세요!")
	dw_ip.setcolumn('sdatef')
	dw_ip.setfocus()
	Return -1
END IF
IF	f_datechk(to_yymm+'01') = -1 then
	MessageBox("확인","매출기간을 확인하세요!")
	dw_ip.setcolumn('sdatet')
	dw_ip.setfocus()
	Return -1
END IF

IF	fr_yymm > to_yymm then
	MessageBox("확인","매출기간을 확인하세요!")
	dw_ip.setcolumn('sdatet')
	dw_ip.setfocus()
	Return -1
END IF
////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)
dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_list.retrieve(gs_sabu, fr_yymm,to_yymm, '%', sarea+'%',cvcod+'%',ls_silgu) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('areacode')
	dw_ip.setfocus()
	return -1
end if

//////////////////////////////////////////////////////// title  설정
dw_list.Object.st_1.text = wf_get_itnct('1','01')
dw_list.Object.st_2.text = wf_get_itnct('1','02')
dw_list.Object.st_3.text = wf_get_itnct('1','03')
dw_list.Object.st_4.text = wf_get_itnct('1','04')
dw_list.Object.st_5.text = wf_get_itnct('1','05')
dw_list.Object.st_6.text = wf_get_itnct('1','06')
dw_list.Object.st_7.text = wf_get_itnct('1','07')
dw_list.Object.st_8.text = wf_get_itnct('1','08')
dw_list.Object.st_9.text = wf_get_itnct('1','09')
dw_list.Object.st_10.text = wf_get_itnct('1','10')
dw_list.Object.st_11.text = wf_get_itnct('1','11')
dw_list.Object.st_12.text = wf_get_itnct('1','12')
dw_list.Object.st_13.text = wf_get_itnct('1','13')

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_sarea.text = '"+tx_name+"'")

dw_list.SetRedraw(True)

Return 1

end function

on w_sal_05640.create
call super::create
end on

on w_sal_05640.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),6)
dw_ip.SetItem(1,'sdatef',left(syymm,4) + '01')
dw_ip.SetItem(1,'sdatet',syymm)
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_05640
end type

type p_exit from w_standard_print`p_exit within w_sal_05640
end type

type p_print from w_standard_print`p_print within w_sal_05640
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05640
end type







type dw_ip from w_standard_print`dw_ip within w_sal_05640
integer x = 37
integer y = 64
integer width = 727
integer height = 1312
string dataobject = "d_sal_05640_01"
end type

event dw_ip::rbuttondown;string sIoCustName, sIoCustArea,	sDept,sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
 Case "custcode","custname"
	  gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
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

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,sPrtGbn,snull

SetNull(snull)

Choose Case GetColumnName() 
 Case "sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom+'01') = -1 THEN
		f_message_chk(35,'[매출기간]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo+'01') = -1 THEN
		f_message_chk(35,'[매출기간]')
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
	sIoCust = Trim(GetText())
	IF sIoCust ="" OR IsNull(sIoCust) THEN
		this.SetItem(1,"custname",snull)
		Return
	END IF
	
   SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
	  INTO :sIoCustName,		:sIoCustArea,			:sDept
	  FROM "VNDMST","SAREA" 
    WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust;
	
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
			dw_list.DataObject = 'd_sal_056402'
		ELSEIF sPrtGbn = '2' THEN					
			dw_list.DataObject = 'd_sal_056401'
		ELSE												
			dw_list.DataObject = 'd_sal_05640'
		END IF
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
		dw_list.SetRedraw(True)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_05640
integer x = 805
integer width = 2807
integer height = 2056
string dataobject = "d_sal_05640"
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

