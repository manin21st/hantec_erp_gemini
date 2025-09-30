$PBExportHeader$w_kfia58.srw
$PBExportComments$담보 예금 / 차입금 현황
forward
global type w_kfia58 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia58
end type
end forward

global type w_kfia58 from w_standard_print
integer x = 0
integer y = 0
string title = "담보 예금/차입금 현황 조회 및 출력"
rr_1 rr_1
end type
global w_kfia58 w_kfia58

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sBnk,sDamKind,sHDateF,sHDateT,sBaseDate

if dw_ip.AcceptText() = -1 then return -1

sBnk      = dw_ip.GetItemString(1,"bnkcd")
sDamKind  = dw_ip.GetItemString(1,"dam_kind")
sHDateF   = Trim(dw_ip.GetItemString(1,"hdatef"))
sHDateT   = Trim(dw_ip.GetItemString(1,"hdatet"))
sBaseDate = Trim(dw_ip.GetItemString(1,"basedate"))

IF sBnk = '' OR IsNull(sBnk) THEN sBnk = '%'
IF sDamKind = '' OR IsNull(sDamKind) THEN sDamKind = '%'
IF sHDateF = '' OR IsNull(sHDateF) THEN sHDateF = '00000000'
IF sHDateT = '' OR IsNull(sHDateT) THEN sHDateT = '99999999'
IF sBaseDate = '' OR IsNull(sBaseDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_ip.SetColumn("basedate")
	dw_ip.SetFocus()
	Return -1
END IF

dw_list.SetRedraw(false)
if dw_print.retrieve(sBnk,sDamKind,sHDateF,sHDateT,sBaseDate) < 1 then 
	F_MessageChk(14, "")
	dw_list.insertrow(0)
   dw_list.SetRedraw(true)	
	//return -1
end if
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)	

return 1
end function

on w_kfia58.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia58.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"basedate", F_Today())
dw_ip.SetColumn('bnkcd')
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kfia58
end type

type p_exit from w_standard_print`p_exit within w_kfia58
end type

type p_print from w_standard_print`p_print within w_kfia58
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia58
end type







type st_10 from w_standard_print`st_10 within w_kfia58
end type



type dw_print from w_standard_print`dw_print within w_kfia58
string dataobject = "dw_kfia582_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia58
integer x = 46
integer y = 28
integer width = 2277
integer height = 344
string dataobject = "dw_kfia581"
end type

event dw_ip::itemchanged;string sBnk, sBnkName,sPrtGbn,sNull

SetNull(snull)

IF this.GetColumnName() = 'bnkcd' THEN
   sBnk = this.GetText()
	IF sBnk = '' OR IsNull(sBnk) THEN
		this.SetItem(1,"bnkname",sNull)
		Return
	END IF
	
	SELECT person_nm		INTO :sBnkName
		FROM kfz04om0_v2  
		WHERE person_cd = :sBnk ; 
	IF sqlca.sqlcode <> 0 then
//		F_MessageChk(20,'[금융기관]')
//		this.SetItem(this.GetRow(), 'bnkcd',   snull)
//		this.SetItem(this.GetRow(), 'bnkname', snull)		 
//	   return 1
	ELSE
		this.SetItem(this.GetRow(), 'bnkname', sBnkName)	
	END IF
END IF

IF this.GetColumnName() = "dam_kind" THEN
	IF Trim(this.GetText()) = '' OR IsNull(Trim(this.GetText())) THEN Return
	
	IF IsNull(F_Get_Refferance('DB',this.GetText())) THEN
		F_MessageChk(20,'[보증종류]')
		this.SetItem(1,"dam_kind", sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "hdatef" THEN
	IF Trim(this.GetText()) = '' OR IsNull(Trim(this.GetText())) THEN Return
	
	IF F_DateChk(Trim(this.GetText())) = -1 THEN
		F_MessageChk(21,'[해지일자]')
		this.SetItem(1,"hdatef", sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "hdatet" THEN
	IF Trim(this.GetText()) = '' OR IsNull(Trim(this.GetText())) THEN Return
	
	IF F_DateChk(Trim(this.GetText())) = -1 THEN
		F_MessageChk(21,'[해지일자]')
		this.SetItem(1,"hdatet", sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "basedate" THEN
	IF Trim(this.GetText()) = '' OR IsNull(Trim(this.GetText())) THEN Return
	
	IF F_DateChk(Trim(this.GetText())) = -1 THEN
		F_MessageChk(21,'[기준일자]')
		this.SetItem(1,"basedate", sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "prtgbn" THEN
	sPrtGbn = this.GetText()
	
	dw_list.SetRedraw(False)
	IF sPrtGbn = '1' THEN												/*금융기관별*/
		dw_list.DataObject = 'dw_kfia582'
	ELSEIF sPrtGbn = '2' THEN											/*보증종류별*/
		dw_list.DataObject = 'dw_kfia5821'
	ELSEIF sPrtGbn = '3' THEN											/*보증기관별*/	
		dw_list.DataObject = 'dw_kfia5822'
	ELSEIF sPrtGbn = '4' THEN											/*해지일(만기일)자별*/
		dw_list.DataObject = 'dw_kfia5823'
	END IF
	dw_list.SetRedraw(True)	
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()
END IF


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNUll(lstr_custom.code)
SetNUll(lstr_custom.name)

this.accepttext()

if this.GetColumnName() = 'bnkcd' then
	
	lstr_custom.code = this.object.bnkcd[1]
	
	OpenWithParm(w_kfz04om0_popup, '2')
	
   this.SetItem(this.GetRow(), 'bnkcd',   lstr_custom.code)
   this.SetItem(this.GetRow(), 'bnkname', lstr_custom.name)
end if
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia58
integer x = 59
integer y = 388
integer width = 4530
integer height = 1916
string title = "담보 예금/차입금 현황"
string dataobject = "dw_kfia582"
end type

type rr_1 from roundrectangle within w_kfia58
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 380
integer width = 4544
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

