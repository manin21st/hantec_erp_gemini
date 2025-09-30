$PBExportHeader$w_kgld68.srw
$PBExportComments$거래처별 채권(채무) 연령분석표 조회 출력
forward
global type w_kgld68 from w_standard_print
end type
type dw_1 from dw_list within w_kgld68
end type
type rr_1 from roundrectangle within w_kgld68
end type
end forward

global type w_kgld68 from w_standard_print
integer x = 0
integer y = 0
string title = "거래처별 채권(채무) 연령분석표 조회 출력"
dw_1 dw_1
rr_1 rr_1
end type
global w_kgld68 w_kgld68

forward prototypes
public function integer wf_retrieve ()
public function integer wf_print ()
end prototypes

public function integer wf_retrieve ();String sBaseDate, sCust, sGb, ls_2mon, ls_3mon, ls_6mon

IF dw_ip.AcceptText() = -1 then return -1

sBaseDate = Trim(dw_ip.GetItemString(dw_ip.getrow(), "k_symd"))

sCust     = Trim(dw_ip.GetItemString(dw_ip.getrow(), "in_cd"))

IF sBaseDate = "" OR IsNull(sBaseDate) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
END IF

IF sCust = "" OR IsNull(sCust) THEN sCust = '%'

sGb = Trim(dw_ip.GetItemString(dw_ip.getrow(), "gb"))

Select to_char(add_months(:sBaseDate, -2), 'YYYYMMDD'),
       to_char(add_months(:sBaseDate, -3), 'YYYYMMDD'),
       to_char(add_months(:sBaseDate, -6), 'YYYYMMDD')
  Into :ls_2mon, :ls_3mon, :ls_6mon
  From dual;

IF dw_print.Retrieve(sGb, sBaseDate, sCust, ls_2mon, ls_3mon, ls_6mon) <=0 THEN
	f_Messagechk(14, "")
	return -1
END IF

dw_print.sharedata(dw_list)

Return 1
end function

public function integer wf_print ();Return 1
end function

on w_kgld68.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_kgld68.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1, "k_symd", f_today())
dw_ip.SetItem(1, "gb", "1")

dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_kgld68
end type

type p_exit from w_standard_print`p_exit within w_kgld68
end type

type p_print from w_standard_print`p_print within w_kgld68
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld68
end type

type st_window from w_standard_print`st_window within w_kgld68
integer x = 2409
integer width = 462
end type

type sle_msg from w_standard_print`sle_msg within w_kgld68
integer width = 2011
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld68
integer x = 2866
end type

type st_10 from w_standard_print`st_10 within w_kgld68
end type

type gb_10 from w_standard_print`gb_10 within w_kgld68
integer width = 3607
end type

type dw_print from w_standard_print`dw_print within w_kgld68
string dataobject = "dw_kgld68_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld68
integer x = 46
integer width = 3264
integer height = 152
string dataobject = "dw_kgld681"
end type

event dw_ip::rbuttondown;String ssql_gaej1,snull

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() ="in_cd" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)
	
	lstr_custom.code = this.GetItemString(this.GetRow(),"in_cd")
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""

	OpenWithParm(W_KFZ04OM0_POPUP,"1")
	
	IF IsNull(lstr_custom) THEN
		this.SetItem(this.GetRow(), "in_cd", snull)
		this.SetItem(this.GetRow(), "in_nm", snull)
	ELSE	
		this.SetItem(this.GetRow(), "in_cd", lstr_custom.code)
		this.SetItem(this.GetRow(), "in_nm", lstr_custom.name)
	END IF
END IF
end event

event dw_ip::itemchanged;
String snull, sSymd, sCust, sCustName
 
SetNull(snull)

IF this.GetColumnName() = "k_symd" THEN
	sSymd = Trim(this.GetText())
	IF sSymd = "" OR IsNull(sSymd) THEN Return
	
	IF F_DateChk(sSymd) = -1 THEN
		F_MessageChk(21,'[기준일자]')
		this.SetItem(this.GetRow(), "k_symd", sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "in_cd" THEN
	sCust = this.GetText()
	IF sCust = '' OR IsNull(sCust) THEN
		this.SetItem(this.GetRow(), "in_nm", snull)
		Return
	END IF
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
		FROM "KFZ04OM0"  
		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCust) AND 
				(( "KFZ04OM0"."PERSON_GU" like '1') OR 
				( "KFZ04OM0"."PERSON_GU" = '99')) AND
				( "KFZ04OM0"."PERSON_STS" = '1');
	
	IF SQLCA.SQLCODE = 100 THEN
		Messagebox("확인", "거래처를 확인하십시오")
		this.SetItem(this.GetRow(), "in_cd", snull)
		this.SetItem(this.GetRow(), "in_nm", snull)
		Return 1
	END IF
	
	this.SetItem(this.GetRow(), "in_nm", sCustName)
END IF

IF this.GetColumnName() = "gb" THEN dw_list.reset()
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::ue_key;IF key = keyf1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld68
integer x = 73
integer y = 200
integer width = 4512
integer height = 2096
string title = "반제처리 현황"
string dataobject = "dw_kgld68_1"
boolean border = false
end type

type dw_1 from dw_list within w_kgld68
integer y = 2320
integer height = 2092
integer taborder = 10
boolean bringtotop = true
end type

type rr_1 from roundrectangle within w_kgld68
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 180
integer width = 4558
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

