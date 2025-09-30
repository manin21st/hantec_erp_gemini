$PBExportHeader$w_kfia30.srw
$PBExportComments$차입금 관리대장 조회 출력
forward
global type w_kfia30 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia30
end type
end forward

global type w_kfia30 from w_standard_print
integer x = 0
integer y = 0
string title = "차입금 관리대장 조회 출력"
rr_1 rr_1
end type
global w_kfia30 w_kfia30

type variables
String sacc1,sacc2,sbnkf,sbnkt,sdatef,sdatet,sgaejnm,sbnknmf,sbnknmt
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_locd, s_tocd,sAcc_Ymd,eAcc_Ymd

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_locd = trim(dw_ip.GetItemstring(dw_ip.getrow(),"lo_cd"))
s_tocd = trim(dw_ip.GetItemstring(dw_ip.getrow(),"to_cd"))

if isnull(s_locd) or s_locd = "" then s_locd = '1' 
if isnull(s_tocd) or s_tocd = "" then s_tocd = 'z' 

if s_locd > s_tocd then
	messagebox("확인","차입금코드의 범위를 확인하세요!!")
	dw_ip.setfocus()
	return -1
end if

//에러체크 (from날짜)
sacc_ymd = Trim(dw_ip.GetItemString(1,"k_symd"))
IF sAcc_Ymd = "" OR IsNull(sAcc_Ymd) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	Return -1
END IF

eacc_ymd = Trim(dw_ip.GetItemString(1,"k_eymd"))
IF eAcc_Ymd = "" OR IsNull(eAcc_Ymd) THEN
	eAcc_Ymd = '99999999'
END IF

if long(sacc_ymd) > long(eacc_ymd) then
	f_messagechk(24,"")
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	return -1
end if	

IF dw_print.Retrieve(s_locd, s_tocd, sAcc_Ymd,eAcc_Ymd) <= 0 THEN
	f_messagechk(14,'')
	dw_ip.SetFocus()
	//Return -1
	dw_list.insertrow(0)
END IF
  dw_print.sharedata(dw_list)
Return 1
end function

on w_kfia30.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia30.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String snull

SetNull(snull)

dw_ip.SetItem(1,"k_symd",Left(f_today(),4)+'0101')
dw_ip.SetItem(1,"k_eymd",f_today())

dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kfia30
end type

type p_exit from w_standard_print`p_exit within w_kfia30
end type

type p_print from w_standard_print`p_print within w_kfia30
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia30
end type







type st_10 from w_standard_print`st_10 within w_kfia30
end type



type dw_print from w_standard_print`dw_print within w_kfia30
string dataobject = "d_kfia30_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia30
integer x = 50
integer y = 36
integer width = 3067
integer height = 228
string dataobject = "d_kfia30_0"
end type

event dw_ip::rbuttondown;this.accepttext()

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() ="lo_cd" THEN
	gs_code = Trim(dw_ip.GetItemString(dw_IP.GetRow(),"lo_cd"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	OPEN(W_KFM03OT0_POPUP)
	dw_ip.SetItem(1, "lo_cd", gs_code)
	dw_ip.setitem(1, "fr_nm", gs_codename)
ELSEIF this.GetColumnName() ="to_cd" THEN
	gs_code = Trim(dw_ip.GetItemString(dw_IP.GetRow(),"to_cd"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	OPEN(W_KFM03OT0_POPUP)
	dw_ip.SetItem(1, "to_cd", gs_code)
	dw_ip.setitem(1, "to_nm", gs_codename)
END IF
end event

event dw_ip::itemchanged;string sname,snull

SetNull(snull)

IF dwo.name = "lo_cd"  THEN
	
	IF data ="" OR IsNull(data) THEN
		dw_ip.setitem(dw_ip.getrow(), "lo_cd", snull)
		dw_ip.setitem(dw_ip.getrow(), "fr_nm", snull)
		Return
	END IF
		
	SELECT "KFM03OT0"."LO_NAME"  
   	INTO :SNAME  
    	FROM "KFM03OT0"  
   	WHERE "KFM03OT0"."LO_CD" = :data ;
   IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확 인","등록된 차입금코드가 아닙니다!!")	
//		dw_ip.setitem(dw_ip.getrow(), "lo_cd", snull)
//		dw_ip.setitem(dw_ip.getrow(), "fr_nm", snull)
//		Return 1
	ELSE
		dw_ip.setitem(dw_ip.getrow(), "fr_nm", sname)
	END IF
ELSEIF dwo.name = "to_cd" THEN 
	IF data ="" OR IsNull(data) THEN
		dw_ip.setitem(dw_ip.getrow(), "to_cd", snull)
		dw_ip.setitem(dw_ip.getrow(), "to_nm", snull)
		Return
	END IF
	
	SELECT "KFM03OT0"."LO_NAME"  
   	INTO :SNAME  
    	FROM "KFM03OT0"  
   	WHERE "KFM03OT0"."LO_CD" = :data ;
	IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확 인","등록된 차입금코드가 아닙니다!!")	
//		dw_ip.setitem(dw_ip.getrow(), "to_cd", snull)
//		dw_ip.setitem(dw_ip.getrow(), "to_nm", snull)
//		Return 1
	ELSE
		dw_ip.SetItem(dw_ip.Getrow(), "to_nm", sname)
	END IF
END IF


String  sStart,sEnd
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "k_symd" THEN
	sStart = Trim(this.GetText())
	IF sStart = "" OR IsNull(sStart) THEN Return 
	
	IF F_DateChk(sStart) = -1 THEN
		F_MessageChk(21,'[회계일자]')
		this.SetItem(row, "k_symd", snull)
		Return 1	
	END IF
END IF

IF this.GetColumnName() = "k_eymd" THEN
	sEnd = Trim(this.GetText())
	IF sEnd = "" OR IsNull(sEnd) THEN Return 
	
	IF F_DateChk(sEnd) = -1 THEN
		F_MessageChk(21,'[회계일자]')
		this.SetItem(row, "k_eymd", snull)
		Return 1	
	END IF
END IF

end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia30
integer x = 64
integer y = 276
integer width = 4507
integer height = 1944
string dataobject = "d_kfia30_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 264
integer width = 4553
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

