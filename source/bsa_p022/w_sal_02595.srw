$PBExportHeader$w_sal_02595.srw
$PBExportComments$할당취소현황
forward
global type w_sal_02595 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02595
end type
type pb_2 from u_pb_cal within w_sal_02595
end type
type rr_1 from roundrectangle within w_sal_02595
end type
end forward

global type w_sal_02595 from w_standard_print
string title = "할당 취소 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02595 w_sal_02595

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sTeam,sArea,sCust
String sTeamName, sAreaName, sSaleGu
String sItcls, sItnbr, tx_name,ssaupj

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTo         = dw_ip.GetItemString(1,"sdatet")
sTeam       = dw_ip.GetItemString(1,"deptcode")
sArea       = dw_ip.GetItemString(1,"areacode")
sCust       = dw_ip.GetItemString(1,"custcode")
sSaleGu     = dw_ip.GetItemString(1,"salegu")
sItcls      = dw_ip.GetItemString(1,"itcls")
sItnbr      = dw_ip.GetItemString(1,"itnbr")
//ssaupj = dw_ip.getitemstring(1,"saupj")

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[수주기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[수주기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

//If IsNull(sSaupj) Or sSaupj = '' Then
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

IF sTeam = "" OR IsNull(sTeam) THEN sTeam = '%'

IF sArea = "" OR IsNull(sArea) THEN sArea = '%'
IF sCust = "" OR IsNull(sCust) THEN sCust = '%'
IF sItCls = "" OR IsNull(sItCls) THEN sItCls = '%'
IF sItnbr = "" OR IsNull(sItnbr) THEN sItnbr = '%'

/* 출고구분 (A:전체, Y:판매출고, N:무상출고 */
If sSaleGu = 'A' Then sSaleGu = ''

//IF dw_list.Retrieve(gs_sabu,sFrom,sTo,sTeam,sArea,sCust, sSaleGu+'%', sItcls+'%', sItnbr+'%') <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	Return -1
//End If

IF dw_print.Retrieve(gs_sabu,sFrom,sTo,sTeam,sArea,sCust, sSaleGu+'%', sItcls+'%', sItnbr+'%') <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
End If

dw_print.ShareData(dw_list)

IF sTeam ='%' THEN
	sTeamName = '전 체'
Else
	sTeamName = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
End If

IF sArea ='%' THEN
	sAreaName = '전 체'
Else
	sAreaName = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
End If

//dw_list.Modify("txt_dept.text = '"+sTeamName+"'")
//dw_list.Modify("txt_area.text = '"+sAreaName+"'")

dw_print.Modify("txt_dept.text = '"+sTeamName+"'")
dw_print.Modify("txt_area.text = '"+sAreaName+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_itcls.text = '"+tx_name+"'")
dw_print.Modify("txt_itcls.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itdsc'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_itnbr.text = '"+tx_name+"'")
dw_print.Modify("txt_itnbr.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'custname'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_cvcod.text = '"+tx_name+"'")
dw_print.Modify("txt_cvcod.text = '"+tx_name+"'")

//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
//
Return 1
end function

on w_sal_02595.create
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

on w_sal_02595.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.Setfocus()

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'areacode', sarea)
	dw_ip.SetItem(1, 'deptcode', steam)
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If

dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_02595
boolean originalsize = true
end type

type p_exit from w_standard_print`p_exit within w_sal_02595
end type

type p_print from w_standard_print`p_print within w_sal_02595
boolean originalsize = true
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02595
boolean originalsize = true
end type











type dw_print from w_standard_print`dw_print within w_sal_02595
integer x = 4311
integer y = 176
string dataobject = "d_sal_02595_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02595
integer x = 23
integer y = 32
integer width = 3890
integer height = 204
string dataobject = "d_sal_025951"
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

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,snull, sjijil, sispeccode
String  sIttyp, sItcls, sItemCls, sItemGbn, sItemClsName, sitnbr, sItdsc, sIspec
string  sCvcod, scvnas, sarea, steam, sSaupj, sName1
Long    nrow

SetNull(snull)
nRow = GetRow()
If nRow <= 0 Then Return 

Choose Case GetColumnName()
	/* 수주일자 */
	Case "sdatef","sdatet"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[수주일자]')
			this.SetItem(1,GetColumnName(),snull)
			Return 1
		END IF
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
	
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = '1'
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			FROM "ITNCT"  
			WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemClsName = this.GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		
		sItemGbn = '1' //this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."ITCLS"	INTO :sItemCls
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"itcls",sItemCls)
			END IF
		END IF
	/* 품번 */
	Case	"itnbr" 
		sItnbr = Trim(this.GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
		
		SELECT  "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC","ITNCT"."TITNM"
		  INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName
		  FROM "ITEMAS","ITNCT"
		 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				 "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				 "ITEMAS"."ITNBR" = :sItnbr ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			this.PostEvent(RbuttonDown!)
			Return 2
		END IF
		
		SetItem(nRow,"ittyp", sIttyp)
		SetItem(nRow,"itdsc", sItdsc)
		SetItem(nRow,"ispec", sIspec)
		SetItem(nRow,"itcls", sItcls)
		SetItem(nRow,"itclsnm", sItemClsName)
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(this.GetText())	
		IF sItdsc ="" OR IsNull(sItdsc) THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
		
		/* 품명으로 품번찾기 */
		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetColumn("itdsc")
			Return 1
		End If	
	/* 규격 */
	Case "ispec"
		sIspec = trim(this.GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetColumn("ispec")
			Return 1
		End If	
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
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"deptcode",   steam)
			SetItem(1,"custname", scvnas)
			SetItem(1,"areacode",   sarea)
			
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"deptcode",   steam)
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
			SetItem(1,"areacode",   sarea)
			
			Return 1
		END IF

//	/* 거래처 */
//	Case "custcode"
//		sIoCust = this.GetText()
//		IF sIoCust ="" OR IsNull(sIoCust) THEN
//			this.SetItem(1,"custname",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//		FROM "VNDMST","SAREA" 
//		WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
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
//		INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
//		FROM "VNDMST","SAREA" 
//		WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
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

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "itcls"
		OpenWithParm(w_ittyp_popup, '1') //완제
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		this.SetItem(1,"itcls",str_sitnct.s_sumgub)
		this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
		this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	Case "itclsnm"
		OpenWithParm(w_ittyp_popup, '1')
		str_sitnct = Message.PowerObjectParm
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
		this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
		this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	/* ---------------------------------------- */
	Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = '1' //Trim(GetItemString(1,'ittyp'))
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"itnbr",gs_code)
		this.SetFocus()
		this.SetColumn('itnbr')
		this.PostEvent(ItemChanged!)

	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
	
//	Case "custcode"
//		gs_gubun = '1'
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//		FROM "VNDMST","SAREA" 
//		WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
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
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//		FROM "VNDMST","SAREA" 
//		WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02595
integer y = 248
integer width = 4571
integer height = 2052
string dataobject = "d_sal_02595"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_sal_02595
integer x = 722
integer y = 44
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

type pb_2 from u_pb_cal within w_sal_02595
integer x = 1189
integer y = 44
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

type rr_1 from roundrectangle within w_sal_02595
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 240
integer width = 4594
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

