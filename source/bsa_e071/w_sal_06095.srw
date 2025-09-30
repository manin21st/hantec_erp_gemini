$PBExportHeader$w_sal_06095.srw
$PBExportComments$Nego 사후관리
forward
global type w_sal_06095 from w_inherite
end type
type gb_3 from groupbox within w_sal_06095
end type
type gb_1 from groupbox within w_sal_06095
end type
type dw_key from u_key_enter within w_sal_06095
end type
end forward

global type w_sal_06095 from w_inherite
int Width=3653
int Height=2396
boolean TitleBar=true
string Title="NEGO 사후관리"
WindowState WindowState=normal!
event ue_open pbm_custom01
gb_3 gb_3
gb_1 gb_1
dw_key dw_key
end type
global w_sal_06095 w_sal_06095

type variables
str_itnct str_sitnct
String  sItnbrYN
end variables

forward prototypes
public function integer wf_set_ngsts (integer nrow)
end prototypes

public function integer wf_set_ngsts (integer nrow);String sNegoSts, sNgSts, sNull

SetNull(sNull)
sNegoSts = dw_insert.GetItemString(nRow,'nego_status')

SELECT "REFFPF"."RFGUB"  INTO :sNgSts
 FROM "REFFPF"  
WHERE ( "REFFPF"."SABU" = '1' ) AND  
		( "REFFPF"."RFCOD" = '86' ) AND  
		( "REFFPF"."RFNA2" = :sNegoSts ) ;

//MessageBox(sngsts, sNegoSts)
//
//If sqlca.sqlcode <> 0 Then
//	MessageBox('확 인','등록되지 않은 조건입니다')
//	SetItem(nRow,GetColumnName(),sNull)
//	Return 2
//End If
If Trim(sNgsts) = '' Then SetNull(sNgsts)

dw_insert.SetItem(nRow,'ngsts',sNgSts)

Return 0
end function

on w_sal_06095.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_1=create gb_1
this.dw_key=create dw_key
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_key
end on

on w_sal_06095.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.dw_key)
end on

event open;call super::open;dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

		 
dw_key.InsertRow(0)
dw_key.SetFocus()
dw_key.SetColumn('sdatef')
end event

type dw_insert from w_inherite`dw_insert within w_sal_06095
event ue_rbuttondown pbm_rbuttondown
int X=59
int Y=232
int Width=3474
int Height=1612
int TabOrder=10
string DataObject="d_sal_06095"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

event dw_insert::itemerror;Return 1
end event

event dw_insert::itemchanged;Long   nRow
String sNull, sDate

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

sDate = Trim(GetText())
If IsNull(sDate) or sDate = '' Then 
	SetItem(nRow,GetColumnName(),sNull)
	Post wf_set_ngsts(nRow)
	Return 
End If

/* 일자체크 */
If f_datechk(sDate) <> 1 Then
	f_message_chk(35,'')
	SetItem(nRow,GetColumnName(),sNull)
	Return 1
End If

Post wf_set_ngsts(nRow)

end event

type cb_exit from w_inherite`cb_exit within w_sal_06095
int X=3163
int Y=1892
end type

type cb_mod from w_inherite`cb_mod within w_sal_06095
int X=2459
int Y=1892
int TabOrder=50
end type

event cb_mod::clicked;call super::clicked;Long   nCnt, ix
String sNgSts

If dw_insert.AcceptText() <> 1 Then Return

/* Nego 상태 확인 */
For ix = 1 To dw_insert.RowCount()
	sNgSts = Trim(dw_insert.GetItemString(ix,'ngsts'))
	If IsNull(sNgSts) or sNgSts = '' Then
		MessageBox('확 인','[Nego사후내역의 상태가 없습니다]~r~n~r~n사후상태를 확인하세요')
		dw_insert.SetFocus()
		dw_insert.SetRow(ix)
		dw_insert.ScrollToRow(ix)
		dw_insert.SetColumn('setcnf')
		
		Return
	End If
Next

IF dw_insert.Update() <> 1 THEN
	f_message_chk(32,'')
	sle_msg.text = ''
   ROLLBACK;
   Return
END IF

COMMIT;

sle_msg.text ='자료를 저장하였습니다!!'

end event

type cb_ins from w_inherite`cb_ins within w_sal_06095
int X=430
int Y=2328
int TabOrder=30
boolean Visible=false
boolean Enabled=false
string Text="추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_06095
int X=1161
int Y=2336
int TabOrder=60
boolean Visible=false
boolean Enabled=false
end type

type cb_inq from w_inherite`cb_inq within w_sal_06095
int X=2107
int Y=1892
end type

event cb_inq::clicked;call super::clicked;String sDatef, sDatet, sCvcod

If dw_key.AcceptText() <> 1 Then Return

sDatef = Trim(dw_key.GetItemString(1,'sdatef'))
sDatet = Trim(dw_key.GetItemString(1,'sdatet'))
sCvcod = Trim(dw_key.GetItemString(1,'custcode'))

dw_key.SetFocus()
If f_datechk(sDatef) <> 1 or f_datechk(sDatet) <> 1 Then
	f_message_chk(1400,'[NEGO 기간')
	dw_key.SetColumn('sdatef')
	Return
End If

If IsNull(sCvcod) or sCvcod = '' Then sCvcod = '' 

If dw_insert.Retrieve(gs_sabu, sdatef, sdatet, sCvcod+'%') <= 0 Then
	f_message_chk(50,'')
End If
end event

type cb_print from w_inherite`cb_print within w_sal_06095
int X=2080
int Y=2344
int TabOrder=100
boolean Visible=false
boolean Enabled=false
end type

type cb_can from w_inherite`cb_can within w_sal_06095
int X=2811
int Y=1892
int TabOrder=70
end type

event cb_can::clicked;call super::clicked;dw_key.SetRedraw(False)
dw_key.Reset()
dw_insert.Reset()
dw_key.InsertRow(0)
dw_key.SetFocus()
dw_key.SetColumn('sdatef')
dw_key.SetRedraw(True)
end event

type cb_search from w_inherite`cb_search within w_sal_06095
int X=2496
int Y=2344
int TabOrder=110
boolean Visible=false
boolean Enabled=false
end type

type gb_3 from groupbox within w_sal_06095
int X=2066
int Y=1840
int Width=1477
int Height=192
int TabOrder=90
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_1 from groupbox within w_sal_06095
int X=59
int Y=20
int Width=3474
int Height=188
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_key from u_key_enter within w_sal_06095
int X=96
int Y=92
int Width=3406
int Height=84
int TabOrder=20
boolean BringToTop=true
string DataObject="d_sal_06095_01"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event itemerror;return 1
end event

event itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn

SetNull(snull)

Choose Case GetColumnName() 
  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[NEGO일자]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[NEGO일자]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF

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
		this.SetItem(1,"custname",  sIoCustName)
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
		SetItem(1,"custcode",  sIoCust)
		SetItem(1,"custname",  sIoCustName)
		Return
	END IF
END Choose

end event

event rbuttondown;string sIoCustName,sIoCustArea,sDept

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
	  this.SetItem(1,"custname",  sIoCustName)
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
	  this.SetItem(1,"custname",  sIoCustName)
	END IF
END Choose

end event

