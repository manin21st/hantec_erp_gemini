$PBExportHeader$w_kfia09.srw
$PBExportComments$받을어음 검색
forward
global type w_kfia09 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia09
end type
end forward

global type w_kfia09 from w_standard_print
integer x = 0
integer y = 0
string title = "받을어음 검색 명세서 출력"
rr_1 rr_1
end type
global w_kfia09 w_kfia09

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
String sSaupj,sStatus,sDateF,sDateT,sSaupNo,sChangeSaupj,sBalNm

dw_ip.AcceptText()

sSaupj   = dw_ip.GetItemString(1,"saupj")
sStatus  = dw_ip.GetItemString(1,"status_f")
sDateF   = Trim(dw_ip.GetItemString(1,"chbildatef"))
sDateT   = Trim(dw_ip.GetItemString(1,"chbildatet"))
sSaupNo  = dw_ip.GetItemString(1,"saup_no")
sChangeSaupj = dw_ip.GetItemString(1,"owner_saupj")
sBalNm   = dw_ip.GetItemString(1,"balname_f")

IF sSaupj = '' OR IsNull(sSaupj) THEN sSaupj = '%'
IF sStatus = '' OR IsNull(sStatus) THEN 
	F_MessageChk(1,'[어음상태]')
	dw_ip.SetColumn("status_f")
	dw_ip.SetFocus()
	Return -1
END IF

IF sDateF = '' OR IsNull(sDateF) THEN sDateF = '00000000'
IF sDateT = '' OR IsNull(sDateT) THEN sDateT = '99999999'
IF sSaupNo = '' OR IsNull(sSaupNo) THEN sSaupNo = '%'
IF sChangeSaupj = '' OR IsNull(sChangeSaupj) THEN sChangeSaupj = '%'
IF sBalNm = '' OR IsNull(sBalNm) THEN sBalNm = '%'

IF sStatus = '6' OR sStatus = '8' THEN
	sSaupNo = sChangeSaupj
END IF

if dw_print.retrieve(sSaupj,sStatus,sDateF,sDateT,sSaupNo,sBalNm) < 1 then
	f_messagechk(14,"")
	dw_ip.SetFocus()
	dw_list.insertrow(0)
	//Return -1
end if	
dw_print.sharedata(dw_list)

return 1

end function

on w_kfia09.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia09.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.setitem(1,"saupj", Gs_Saupj)

IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(255,255,255))+"'")  
End if

dw_ip.Modify("saup_no.visible = 1")
dw_ip.Modify("saup_nm.visible = 1")
		
dw_ip.Modify("owner_saupj.visible = 0")
		
dw_ip.SetFocus()



end event

type p_preview from w_standard_print`p_preview within w_kfia09
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kfia09
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kfia09
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia09
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_kfia09
integer x = 2382
integer width = 466
end type

type sle_msg from w_standard_print`sle_msg within w_kfia09
integer width = 1989
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfia09
integer x = 2848
integer width = 745
end type

type st_10 from w_standard_print`st_10 within w_kfia09
end type

type gb_10 from w_standard_print`gb_10 within w_kfia09
integer width = 3593
end type

type dw_print from w_standard_print`dw_print within w_kfia09
string dataobject = "dw_kfia092_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia09
integer x = 5
integer y = 44
integer width = 2555
integer height = 320
string dataobject = "dw_kfia091"
end type

event dw_ip::itemchanged;String   sSaupNo,sGbn1,sStatus,sSaupName,snull

SetNull(snull)

IF this.GetColumnName() = "status_f" THEN
	sStatus = this.GetText()
	IF sStatus = '' OR IsNull(sStatus) THEN
		this.Modify("chbildatef_t.text = '변동일자'")
		this.Modify("saup_no_t.text    = '거래처'")
	ELSEIF sStatus = '1' THEN
		this.Modify("chbildatef_t.text = '수금일자'")
		this.Modify("saup_no_t.text    = '거래처'")
	ELSEIF sStatus = '2' THEN
		this.Modify("chbildatef_t.text = '결제일자'")
		this.Modify("saup_no_t.text    = '거래처'")		
	ELSEIF sStatus = '3' THEN
		this.Modify("chbildatef_t.text = '추심일자'")
		this.Modify("saup_no_t.text    = '추심은행'")		
	ELSEIF sStatus = '4' THEN
		this.Modify("chbildatef_t.text = '할인일자'")
		this.Modify("saup_no_t.text    = '할인은행'")	
	ELSEIF sStatus = '6' OR sStatus = '8' THEN	
		this.Modify("chbildatef_t.text = '변동일자'")
		this.Modify("saup_no_t.text    = '변동사업장'")	
	ELSE
		this.Modify("chbildatef_t.text = '변동일자'")	
		this.Modify("saup_no_t.text    = '변동거래처'")		
	END IF
	
	IF sStatus = '6' OR sStatus = '8' THEN	
		this.Modify("saup_no.visible = 0")
		this.Modify("saup_nm.visible = 0")
		
		this.Modify("owner_saupj.visible = 1")
	ELSE
		this.Modify("saup_no.visible = 1")
		this.Modify("saup_nm.visible = 1")
		
		this.Modify("owner_saupj.visible = 0")
	END IF
END IF

IF this.GetColumnName() = "saup_no" THEN
	sSaupNo = trim(this.gettext())
	IF sSaupNo = '' OR IsNull(sSaupNo) then
		this.SetItem(1,"saup_nm", sNull)
		Return 
	END IF
	
	sStatus = this.GetItemString(1,"status_f")
	IF sStatus = '' OR IsNull(sStatus) THEN
		sGbn1 = '%'
	ELSEIF sStatus = '3' OR sStatus = '4' THEN
		sGbn1 = '2'
	ELSE 
		sGbn1 = '1'
	END IF
	
	select person_nm	into :sSaupName from kfz04om0
		where person_cd = :sSaupNo and person_gu like :sGbn1;
	if sqlca.sqlcode <> 0 then
		F_MessageChk(20,'[거래처]')
		this.SetItem(1, "saup_no", snull)
		this.SetItem(1, "saup_nm", snull)
		Return 1
	END IF
	this.SetItem(1,"saup_nm",  sSaupName)
END IF
end event

event dw_ip::rbuttondown;String sStatus,sGbn1

IF this.GetColumnName() = "saup_no"  THEN
	SetNull(lstr_custom.code);		SetNull(lstr_custom.name);
	
	sStatus = this.GetItemString(1,"status_f")
	IF sStatus = '' OR IsNull(sStatus) THEN
		sGbn1 = '%'
	ELSEIF sStatus = '3' OR sStatus = '4' THEN
		sGbn1 = '2'
	ELSE 
		sGbn1 = '1'
	END IF
	
   OpenWithParm(w_kfz04om0_popup1,sGbn1)
	
	IF Lstr_Custom.Code = '' OR IsNull(Lstr_Custom.code) THEN Return
	
	this.SetItem(1, "saup_no", lstr_custom.code)
   this.SetItem(1, "saup_nm", lstr_custom.name)   
END IF
end event

event dw_ip::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kfia09
integer x = 23
integer y = 376
integer width = 4585
integer height = 1916
string title = "받을 어음 검색"
string dataobject = "dw_kfia092"
boolean hscrollbar = false
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia09
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 372
integer width = 4603
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

