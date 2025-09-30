$PBExportHeader$w_sal_02565.srw
$PBExportComments$미납잔 현황
forward
global type w_sal_02565 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_02565
end type
end forward

global type w_sal_02565 from w_standard_print
string title = "미납잔 현황"
rr_1 rr_1
end type
global w_sal_02565 w_sal_02565

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_date ,ls_steamcd , ls_sarea , ls_cvcod , ls_cvnas , ls_saupj

if dw_ip.accepttext() <> 1 then return -1

ls_date = Trim(dw_ip.getitemstring(1,'frdate'))
ls_steamcd = dw_ip.getitemstring(1,'steamcd')
ls_sarea = dw_ip.getitemstring(1,'sarea')
ls_cvcod = Trim(dw_ip.getitemstring(1,'cvcod'))
ls_saupj = dw_ip.getitemstring(1,'saupj')

if ls_date = "" or isnull(ls_date) then
	f_message_chk(30,'[주문일자]')
	dw_ip.setfocus()
	dw_ip.setcolumn('frdate')
	return -1
end if

if ls_steamcd = "" or isnull(ls_steamcd) then ls_steamcd = '%'
if ls_sarea = "" or isnull(ls_sarea) then ls_sarea = '%'
if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'
if ls_saupj = "" or isnull(ls_saupj) then ls_saupj = '%'

//if dw_list.retrieve(gs_sabu, ls_date , ls_steamcd ,ls_sarea , ls_cvcod , ls_saupj) < 1 then
//	f_message_chk(300,'')
//	dw_ip.setfocus()
//	dw_ip.setcolumn('frdate')
//	return -1
//end if
//
//dw_list.object.tx_date.text = "주문일자 : " + left(ls_date,4) + "." + mid(ls_date,5,2) + "." +mid(ls_date,7,2)+ " 이전"


if dw_print.retrieve(gs_sabu, ls_date , ls_steamcd ,ls_sarea , ls_cvcod , ls_saupj) < 1 then
	f_message_chk(300,'')
	dw_list.Reset()
	dw_ip.setfocus()
	dw_ip.setcolumn('frdate')
	return -1
end if

dw_print.ShareData(dw_list)

dw_print.object.tx_date.text = "주문일자 : " + left(ls_date,4) + "." + mid(ls_date,5,2) + "." +mid(ls_date,7,2)+ " 이전"


return 1
end function

on w_sal_02565.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_02565.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'frdate',f_today())

/* 부가 사업장 */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
	if gs_code <> '%' then
		dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
	End if
End If

///* 영업팀 & 관할구역 Filtering */
//DataWindowChild state_child1, state_child2, state_child3
//integer rtncode1, rtncode2, rtncode3
//
//IF gs_code     = '10' THEN
//	rtncode2    = dw_ip.GetChild('steamcd', state_child2)
//	rtncode3    = dw_ip.GetChild('sarea'  , state_child3)
//	
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	IF rtncode3 = -1 THEN MessageBox("Error3", "Not a DataWindowChild")
//	
//	state_child2.setFilter("Mid(steamcd,1,1) <> 'Z'")
//	state_child3.setFilter("sarea < '03' ")
//	
//	state_child2.Filter()
//	state_child3.Filter()
//	
//ELSEIF gs_code = '11' THEN
//	rtncode2    = dw_ip.GetChild('steamcd', state_child2)
//	rtncode3    = dw_ip.GetChild('sarea'  , state_child3)
//	
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	IF rtncode3 = -1 THEN MessageBox("Error3", "Not a DataWindowChild")
//	
//	state_child2.setFilter("Mid(steamcd,1,1) = 'Z'")
//	state_child3.setFilter("sarea > '02' ")
//	
//	state_child2.Filter()
//	state_child3.Filter()
//END IF

DataWindowChild state_child
integer rtncode

//영업팀
rtncode 	= dw_ip.GetChild('steamcd', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)

//관할 구역
rtncode 	= dw_ip.GetChild('sarea', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_sal_02565
integer x = 4078
end type

type p_exit from w_standard_print`p_exit within w_sal_02565
integer x = 4425
end type

type p_print from w_standard_print`p_print within w_sal_02565
integer x = 4251
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02565
integer x = 3904
end type







type st_10 from w_standard_print`st_10 within w_sal_02565
end type

type gb_10 from w_standard_print`gb_10 within w_sal_02565
boolean visible = false
integer x = 73
integer y = 2440
end type

type dw_print from w_standard_print`dw_print within w_sal_02565
integer x = 3712
string dataobject = "d_sal_02565_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02565
integer x = 37
integer y = 32
integer width = 3639
integer height = 188
string dataobject = "d_sal_02565"
end type

event itemchanged;call super::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,sPrtGbn,snull
string  sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
 Case "frdate"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[주문일자]')
		this.SetItem(1,"frdate",snull)
		Return 1
	END IF
/* 영업팀 */
 Case "steamcd"
   SetItem(1,'sarea',sNull)
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvcodnm",sNull)
/* 관할구역 */
 Case "sarea"
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvcodnm",sNull)
	
	sIoCustArea = this.GetText()
	IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
	  FROM "SAREA"  
	 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
   SetItem(1,'steamcd',sDept)
	
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"steamcd",   steam)
			SetItem(1,"cvcodnm", scvnas)
			SetItem(1,"sarea",   sarea)	
		END IF
	
///* 거래처 or 부서*/
//Case "custcode"
//	sIoCust = Trim(GetText())
//	IF sIoCust ="" OR IsNull(sIoCust) THEN
//		this.SetItem(1,"custname",snull)
//		Return
//	END IF
//	
//   SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//	  INTO :sIoCustName,		:sIoCustArea,			:sDept
//	  FROM "VNDMST","SAREA" 
//    WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust;
//	
//	IF SQLCA.SQLCODE <> 0 THEN
//		this.TriggerEvent(RbuttonDown!)
//		Return 2
//	ELSE
//		this.SetItem(1,"deptcode",  sDept)
//		this.SetItem(1,"custname",  sIoCustName)
//		this.SetItem(1,"steamcd",  sIoCustArea)
//	END IF
///* 거래처명 or 부서명 */
// Case "custname"
//	sIoCustName = Trim(GetText())
//	IF sIoCustName ="" OR IsNull(sIoCustName) THEN
//		this.SetItem(1,"custcode",snull)
//		Return
//	END IF
//	
//   SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
// 	  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
//	  FROM "VNDMST","SAREA" 
//    WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
//
//	IF SQLCA.SQLCODE <> 0 THEN
//		this.TriggerEvent(RbuttonDown!)
//		Return 2
//	ELSE
//		SetItem(1,"deptcode",  sDept)
//		SetItem(1,"custcode",  sIoCust)
//		SetItem(1,"custname",  sIoCustName)
//		SetItem(1,"steamcd",  sIoCustArea)
//		Return
//	END IF
END Choose

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sIoCustName, sIoCustArea,	sDept,sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName() 
	Case "cvcod" 
		gs_gubun = '1'
		
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		Setitem(1,"cvcodnm",gs_codename)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02565
integer x = 59
integer y = 256
integer width = 4526
integer height = 2052
string dataobject = "d_sal_02565_01"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_sal_02565
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 248
integer width = 4553
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

