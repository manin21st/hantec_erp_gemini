$PBExportHeader$w_sal_05510.srw
$PBExportComments$일일 수주현황
forward
global type w_sal_05510 from w_standard_dw_graph
end type
type pb_1 from u_pb_cal within w_sal_05510
end type
end forward

global type w_sal_05510 from w_standard_dw_graph
string title = "일일 수주금액 그래프"
pb_1 pb_1
end type
global w_sal_05510 w_sal_05510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_gubun

If dw_ip.AcceptText() <> 1 Then Return -1

ls_gubun = dw_ip.getitemstring(1,'prtgbn')

if ls_gubun = '3' then
   String sFrdate,sToDate, sDate, sSteamCd, sSarea, sCvcod, sPdtGu, tx_name 
	Double dAmt, dNuAmt
	Long   ix, nRow
	DataStore ds_ret

	sDate = Trim(dw_ip.GetItemString(1,'sdatef'))
	sSteamCd = Trim(dw_ip.GetItemString(1,'deptcode'))
	sSarea   = Trim(dw_ip.GetItemString(1,'areacode'))
	sCvcod   = Trim(dw_ip.GetItemString(1,'custcode'))
	sPdtGu   = Trim(dw_ip.GetItemString(1,'pdtgu'))
	
	IF sDate = "" OR IsNull(sDate) THEN
		f_message_chk(30,'[기준일자]')
		dw_ip.SetColumn("sdatef")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	If IsNull(sSteamCd) Then sSteamCd = ''
	If IsNull(sSarea) Then sSarea = ''
	If IsNull(sCvcod) Then sCvcod = ''
	If IsNull(sPdtgu) Then sPdtgu = ''
	
	/* 데이타 조회용 datastore 생성 */
	ds_ret = create datastore
	
	ds_ret.DataObject = 'd_sal_05510'
	ds_ret.SetTransObject(sqlca)
	
	/* 기준일자 가져오기 */
	f_SaleDaysAfter(sdate,-25,sfrdate,stodate)
	
	If ds_ret.Retrieve(gs_sabu, sfrdate, stodate, sSteamCd+'%',sSarea+'%',sCvcod+'%',sPdtgu+'%') < 1 then
		f_message_Chk(300, '')
		dw_ip.setcolumn('sdatef')
		dw_ip.setfocus()
		Return -1
	End if
	
	/* 출력용 데이타원도우로 이동 */
	dw_list.SetRedraw(False)
	dw_list.Reset()
	ds_ret.RowsCopy(1, ds_ret.RowCount(), Primary!, dw_list, 1, Primary!)
	
	/* 정렬 */
	ds_ret.SetSort('gb,sdate')
	ds_ret.Sort()
	
	/* 수주금액 누계 편집 gb(2) */
	dNuAmt = 0
	For ix = 1 To ds_ret.RowCount()
		If ds_ret.object.gb[ix] <> '1' then continue
		
		dAmt = ds_ret.GetItemNumber(ix,'gumack')
		If IsNull(dAmt) Then dAmt = 0
		
		dNuAmt += dAmt
		nRow = dw_list.InsertRow(0)
		dw_list.SetItem(nRow,'gb',     '2')
		dw_list.SetItem(nRow,'sdate',  ds_ret.GetItemString(ix,'sdate'))
		dw_list.SetItem(nRow,'ilja',   ds_ret.GetItemString(ix,'ilja'))
		dw_list.SetItem(nRow,'title',  '수주 누계')
		dw_list.SetItem(nRow,'gumack', dNuAmt)
	Next
	
	/* 판매금액 누계 편집 gb(4) */
	dNuAmt = 0
	For ix = 1 To ds_ret.RowCount()
		If ds_ret.object.gb[ix] <> '3' then continue
		
		dAmt = ds_ret.GetItemNumber(ix,'gumack')
		If IsNull(dAmt) Then dAmt = 0
		
		dNuAmt += dAmt
		nRow = dw_list.InsertRow(0)
		dw_list.SetItem(nRow,'gb',     '4')
		dw_list.SetItem(nRow,'sdate',   ds_ret.GetItemString(ix,'sdate'))
		dw_list.SetItem(nRow,'ilja',   ds_ret.GetItemString(ix,'ilja'))
		dw_list.SetItem(nRow,'title',  '판매 누계')
		dw_list.SetItem(nRow,'gumack', dNuAmt)
	Next
	
	/* 정렬 */
	dw_list.SetSort('gb,sdate')
	dw_list.Sort()
	
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")
	
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_list.Modify("txt_sarea.text = '"+tx_name+"'")
	
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_list.Modify("txt_pdtgu.text = '"+tx_name+"'")
	
	tx_name = Trim(dw_ip.GetitemString(1,'custname'))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_list.Modify("txt_cvcod.text = '"+tx_name+"'")
	
	dw_list.Modify("txt_sdate.text = '"+string(stodate,'@@@@.@@.@@')+"'")
	
	dw_list.SetRedraw(True)

else
	String sDatef, sDatet, sTeamCd, sArea, sCvcod1, sGbn, tx_name1

	sDatet  = Trim(dw_ip.GetItemString(1,'sdatef'))
	sTeamCd = Trim(dw_ip.GetItemString(1,'deptcode'))
	sArea   = Trim(dw_ip.GetItemString(1,'areacode'))
	sCvcod1  = Trim(dw_ip.GetItemString(1,'custcode'))
	
	If	(sDatet='') or isNull(sDatet) then
		f_Message_Chk(35, '[기준년도]')
		dw_ip.setcolumn('sdatef')
		dw_ip.setfocus()
		Return -1
	End if
	
	If IsNull(sTeamcd) Then sTeamCd = ''
	If IsNull(sArea)   Then sArea = ''
	If IsNull(sCvcod1)  Then sCvcod1 = ''
	
	dw_list.object.txt_sdate.Text = Left(sDatet,4) + '.' + Mid(sDatet,5,2) + '.' + Right(sDatet,2)
	
	f_saledaysafter(sdatet,-25,sdatef,sdatet)
	
	If ls_gubun = '1' then
		if dw_list.Retrieve(gs_sabu, sDatef, sDatet, sTeamCd+'%', sArea+'%', sCvcod1+'%' ) < 1 then
			f_message_Chk(300, '[출력조건 CHECK]')
			dw_ip.setcolumn('sdatef')
			dw_ip.setfocus()
			return -1
		end if
	else
		if dw_list.Retrieve(gs_sabu, sDatef, sDatet, sTeamCd+'%', sArea+'%' ) < 1 then
			f_message_Chk(300, '[출력조건 CHECK]')
			dw_ip.setcolumn('sdatef')
			dw_ip.setfocus()
			return -1
		end if
	end if
	
	tx_name1 = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
	If IsNull(tx_name1) Or tx_name1 = '' Then tx_name1 = '전체'
	dw_list.Modify("txt_steamcd.text = '"+tx_name1+"'")
	
	tx_name1 = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
	If IsNull(tx_name1) Or tx_name1 = '' Then tx_name1 = '전체'
	dw_list.Modify("txt_sarea.text = '"+tx_name1+"'")
	
	tx_name1 = Trim(dw_ip.GetitemString(1,'custname'))
	If IsNull(tx_name1) Or tx_name1 = '' Then tx_name1 = '전체'
	dw_list.Modify("txt_cvcod.text = '"+tx_name1+"'")
end if	
	return 1
	
//dw_list.ImportFile("C:\ERPMAN\PGM\TTT.TXT")
end function

on w_sal_05510.create
int iCurrent
call super::create
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
end on

on w_sal_05510.destroy
call super::destroy
destroy(this.pb_1)
end on

event open;call super::open;dw_ip.setitem(1,'sdatef',left(f_today(),8))
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05510
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05510
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05510
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05510
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05510
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05510
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05510
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05510
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05510
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05510
integer x = 27
integer y = 0
integer width = 3991
integer height = 256
string dataobject = "d_sal_05510_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,snull

SetNull(snull)

Choose Case GetColumnName() 
 Case "sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[기준일자]')
		this.SetItem(1,GetColumnName(),snull)
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
Case "prtgbn"
	sIoCustName = Trim(GetText())

   dw_list.setredraw(false)
	
	if siocustname = '1' then
	   dw_list.dataobject = 'd_sal_05520_02'
	elseif siocustname = '2' then
		dw_list.dataobject = 'd_sal_05520_03'
	else
		dw_list.dataobject = 'd_sal_05510'
	end if
	   dw_list.settransobject(sqlca)
	dw_list.setredraw(true)
	
END Choose

















end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
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

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05510
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05510
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05510
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05510
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05510
integer y = 276
integer width = 4526
integer height = 2024
string dataobject = "d_sal_05520_02"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05510
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05510
integer y = 264
integer width = 4558
integer height = 2048
end type

type pb_1 from u_pb_cal within w_sal_05510
integer x = 1490
integer y = 28
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

