$PBExportHeader$w_kfie10.srw
$PBExportComments$상환이자율 변경내역 조회 출력
forward
global type w_kfie10 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfie10
end type
end forward

global type w_kfie10 from w_standard_print
integer x = 0
integer y = 0
string title = "상환이자율 변경내역 조회 출력"
rr_1 rr_1
end type
global w_kfie10 w_kfie10

type variables
String sacc1,sacc2,sbnkf,sbnkt,sdatef,sdatet,sgaejnm,sbnknmf,sbnknmt
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_locd, sAcc_Ymd,eAcc_Ymd

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_locd = trim(dw_ip.GetItemstring(dw_ip.getrow(),"lo_cd"))

if isnull(s_locd) or s_locd = "" then s_locd = '%' 

sacc_ymd = Trim(dw_ip.GetItemString(1,"k_symd"))
IF sAcc_Ymd = "" OR IsNull(sAcc_Ymd) THEN
	F_MessageChk(1,'[변경년월]')
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	Return -1
END IF

eacc_ymd = Trim(dw_ip.GetItemString(1,"k_eymd"))
IF eAcc_Ymd = "" OR IsNull(eAcc_Ymd) THEN
	eAcc_Ymd = '999999'
END IF

if long(sacc_ymd) > long(eacc_ymd) then
	f_messagechk(24,"")
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	return -1
end if	

IF dw_print.Retrieve(s_locd, sAcc_Ymd,eAcc_Ymd) <= 0 THEN
	f_messagechk(14,'')
	dw_ip.SetFocus()
	Return -1
END IF
  dw_print.sharedata(dw_list)
Return 1
end function

on w_kfie10.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfie10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String snull

SetNull(snull)

dw_ip.SetItem(1,"k_symd",Left(f_today(),6))
dw_ip.SetItem(1,"k_eymd",Left(f_today(),6))

dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kfie10
integer x = 4091
integer y = 0
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_kfie10
integer x = 4439
integer y = 0
integer taborder = 60
end type

type p_print from w_standard_print`p_print within w_kfie10
integer x = 4265
integer y = 0
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfie10
integer x = 3918
integer y = 0
integer taborder = 20
end type







type st_10 from w_standard_print`st_10 within w_kfie10
end type



type dw_print from w_standard_print`dw_print within w_kfie10
integer x = 3726
integer y = 12
string dataobject = "dw_kfie102_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfie10
integer x = 69
integer y = 20
integer width = 2619
integer height = 140
integer taborder = 10
string dataobject = "dw_kfie101"
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

event dw_ip::itemchanged;string sname,snull,sData

SetNull(snull)

IF this.GetColumnName() = "lo_cd"  THEN
	sData = this.GetText()
	if sData = '' or IsNull(sData) then 
		dw_ip.setitem(dw_ip.getrow(), "fr_nm", snull)
		Return
	end if
		
	SELECT "KFM03OT0"."LO_NAME"  
   	INTO :SNAME  
    	FROM "KFM03OT0"  
   	WHERE "KFM03OT0"."LO_CD" = :data ;
   IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(1,'[차입금코드]')	
		dw_ip.setitem(dw_ip.getrow(), "lo_cd", snull)
		dw_ip.setitem(dw_ip.getrow(), "fr_nm", snull)
		Return 1
	ELSE
		dw_ip.setitem(dw_ip.getrow(), "fr_nm", sname)
	END IF
END IF

IF this.GetColumnName() = "k_symd" THEN
	sData = Trim(this.GetText())
	IF sData = "" OR IsNull(sData) THEN Return 
	
	IF F_DateChk(sData+'01') = -1 THEN
		F_MessageChk(21,'[변경년월]')
		this.SetItem(dw_ip.getrow(), "k_symd", snull)
		Return 1	
	END IF
END IF

IF this.GetColumnName() = "k_eymd" THEN
	sData = Trim(this.GetText())
	IF sData = "" OR IsNull(sData) THEN Return 
	
	IF F_DateChk(sData+'01') = -1 THEN
		F_MessageChk(21,'[변경년월]')
		this.SetItem(dw_ip.getrow(), "k_eymd", snull)
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

type dw_list from w_standard_print`dw_list within w_kfie10
integer x = 87
integer y = 172
integer width = 4494
integer height = 2024
integer taborder = 30
string dataobject = "dw_kfie102"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

end event

event dw_list::clicked;call super::clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(Row,True)
end event

type rr_1 from roundrectangle within w_kfie10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 160
integer width = 4539
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

