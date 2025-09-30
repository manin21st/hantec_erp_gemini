$PBExportHeader$w_kgld41.srw
$PBExportComments$인명거래처별 거래명세서
forward
global type w_kgld41 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld41
end type
end forward

global type w_kgld41 from w_standard_print
integer x = 0
integer y = 0
string title = "인명거래처별 거래명세서"
rr_1 rr_1
end type
global w_kgld41 w_kgld41

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSaupj, sFdate, sTdate, sAcc1_cd, sAcc2_cd, sPerson_cd, sAcc3_cd

dw_ip.AcceptText()

dw_list.Reset()
sSaupj = dw_ip.GetItemString(dw_ip.GetRow(), "saupj")
if IsNull(sSaupj) or sSaupj = '' then
	sSaupj = '%'
end if
sFdate = dw_ip.GetItemString(dw_ip.GetRow(), "sdate")
sTdate = dw_ip.GetItemString(dw_ip.GetRow(), "fdate")
If string(sFdate) > string(sTdate)	then
	f_messagechk(21, '[회계년월 범위]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
End If

If isnull(sFdate) or trim(sFdate) = '' then 
	f_MessageChk(1, '[시작 회계년월]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
Else
	IF f_datechk(sFdate) = -1 THEN
		f_MessageChk(21, '[시작 회계년월]')
		dw_ip.SetColumn("sdate")
		dw_ip.SetFocus()
		Return -1
	END IF
End if

If isnull(sTdate) or trim(sTdate) = '' then 
	f_MessageChk(1, '[종료 회계년월]')
	dw_ip.SetColumn("fdate")
	dw_ip.SetFocus()
	Return -1
Else
	IF f_datechk(sTdate) = -1 THEN
		f_MessageChk(21, '[종료 회계년월]')
		dw_ip.SetColumn("fdate")
		dw_ip.SetFocus()
		Return -1
	END IF
End if

sAcc1_cd = dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd")
sAcc2_cd = dw_ip.GetItemString(dw_ip.GetRow(), "acc2_cd")
sPerson_cd = dw_ip.GetItemString(dw_ip.GetRow(), "person_cd")

If IsNull(sAcc1_cd) or sAcc1_cd = '' then
	sAcc1_cd = ''
End If

If IsNull(sAcc2_cd) or sAcc2_cd = '' then
	sAcc2_cd = ''
End IF

If IsNull(sPerson_cd) or sPerson_cd = '' then
	sPerson_cd = '%'
End If

if (isnull(sAcc1_cd) or sAcc1_cd = '') or (isnull(sAcc2_cd) or sAcc2_cd = '') then
	sAcc3_cd = '%'
else
	sAcc3_cd = sAcc1_cd + sAcc2_cd
end if

IF dw_print.Retrieve(sSaupj,sFdate, sTdate, sAcc3_cd, sPerson_cd) < 1 THEN
	f_messagechk(11,"")
	dw_list.insertrow(0)
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF
dw_print.sharedata(dw_list)
Return 1
end function

on w_kgld41.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld41.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,"sdate",string(Today(),"yyyymm01"))
dw_ip.setitem(1,"fdate",string(Today(),"yyyymmdd"))

dw_ip.SetItem(1,"saupj",gs_saupj)

end event

type p_preview from w_standard_print`p_preview within w_kgld41
end type

type p_exit from w_standard_print`p_exit within w_kgld41
end type

type p_print from w_standard_print`p_print within w_kgld41
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld41
end type







type st_10 from w_standard_print`st_10 within w_kgld41
end type



type dw_print from w_standard_print`dw_print within w_kgld41
string dataobject = "dw_kgld412_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld41
integer width = 3355
integer height = 228
string dataobject = "dw_kgld411"
end type

event dw_ip::itemchanged;String sSdate, sFdate, sAcc1_cd, sAcc2_cd, sAcc2_nm, sPerson_cd, sPerson_nm, sNull

SetNull(sNull)

If this.GetColumnName() = 'sdate' Then				//필수입력항목인 회계년월 체크
	sSdate = this.GetText()

	If sSdate = '' or IsNull(sSdate) Then
		f_messagechk(1,"[시작 회계년월]")
		Return 1
	Else
		If f_datechk(sSdate) = -1 then 
   		f_messagechk(21,"[시작 회계년월]")			
			Return 1
		End if
	End If
	
End If

If this.GetColumnName() = 'fdate' Then 			
	sFdate = this.GetText()
	sSdate = this.GetItemString(1,"sdate")
	
	If sFdate = '' or IsNull(sFdate) Then
		f_messagechk(1,"[종료 회계년월]")
		Return 1
	Else
		If f_datechk(sFdate) = -1 then 
   		f_messagechk(21,"[종료 회계년월]")			
			Return 1
		End if
	End If
	
End If

//If this.GetColumnName() = 'acc1_cd' Then					//계정과목 체크
//	sAcc1_cd = data
//	If sAcc1_cd = '' or IsNull(sAcc1_cd) then
//		this.SetItem(1,"acc2_cd", snull)
//		this.SetItem(1,"acc2_nm", snull)
//		return
//	End If
//	this.SetItem(1,"acc1_cd", sAcc1_cd)
//End If
	
If this.GetColumnName() = 'acc2_cd' then
	sAcc1_cd = this.GetItemString(1, "acc1_cd")
	sAcc2_cd = data
	
	If sAcc2_cd = '' or IsNull(sAcc2_cd) then
		this.SetItem(1,"acc2_nm", snull)
		return
	ElseIf Not IsNull(sAcc2_cd) then
		
		Select ACC2_NM, gbn1
		Into :sAcc2_nm, :lstr_account.gbn1
		From KFZ01OM0
		Where ACC1_CD = :sAcc1_cd AND
		      ACC2_CD = :sAcc2_cd ;

		If Sqlca.Sqlcode = 0 then
			dw_ip.SetItem(1,"acc2_nm", sAcc2_nm)
		else
			dw_ip.SetItem(1, "acc2_nm", snull)
		End If
	End If
End If

If this.GetColumnName() = 'person_cd' then				// 인명거래처 체크
	sPerson_cd = data
	If sPerson_cd = '' or IsNull(sPerson_cd) then
		dw_ip.SetItem(1, "person_nm",snull)
	Else
		
		Select Person_nm
		Into :sPerson_nm
		From  kfz04om0
		Where kfz04om0.person_cd = :sPerson_cd and 
		      (kfz04om0.person_gu like :lstr_account.gbn1 or
				 kfz04om0.person_gu = '99');
		
		dw_ip.SetItem(1, "person_nm",sPerson_nm)
	End If
End If
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::losefocus;this.AcceptText()
end event

event dw_ip::rbuttondown;String sGbn, ls_acc1_cd, snull

setnull(snull)

SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)
SetNull(lstr_custom.code)	
SetNull(lstr_custom.name)
setnull(gs_code)
setnull(gs_codename)

this.AcceptText()

IF this.GetColumnName() ="acc1_cd" THEN
	
	lstr_account.acc1_cd = dw_ip.GetItemString(1,"acc1_cd")
//	lstr_account.acc2_cd = dw_ip.GetItemString(1,"acc2_cd")

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	End If
	
	IF IsNull(lstr_account.acc2_cd) then
   	lstr_account.acc2_cd = ""
	End If

	Open(W_KFZ01OM0_POPUP_CUST)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN 
		setnull(lstr_account.gbn1)
		dw_ip.SetItem(1,"acc1_cd", snull)
		dw_ip.SetItem(1,"acc2_cd", snull)
		dw_ip.SetItem(1,"acc2_nm", snull)
		dw_ip.SetItem(1,"gbn1", snull)
		dw_ip.SetItem(1,"cus_gu", snull)
		RETURN
	END IF
	
	dw_ip.SetItem(1,"acc1_cd", lstr_account.acc1_cd)
	dw_ip.SetItem(1,"acc2_cd", lstr_account.acc2_cd)
	dw_ip.SetItem(1,"acc2_nm", lstr_account.acc2_nm)
	dw_ip.SetItem(1,"gbn1", lstr_account.gbn1)
	dw_ip.SetItem(1,"cus_gu", lstr_account.cus_gu)
	
//	dw_ip.SetColumn("acc1_cd")

//	this.TriggerEvent(ItemChanged!)
	
END IF

IF this.GetColumnName() ="person_cd" THEN

	lstr_custom.code = this.GetItemString(this.GetRow(),"person_cd")
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
//	sGbn = this.GetItemString(this.GetRow(),"gbn1")
//	
//	IF sGbn = "" OR IsNull(sGbn) THEN 
//		sGbn = '%'
////		MessageBox("확인", "인명거래처를 관리하지 않는 계정입니다.")
////		dw_ip.SetColumn("acc1_cd")
////		dw_ip.SetFocus()
////		Return 1
//	End If

	ls_acc1_cd = dw_ip.getitemstring(dw_ip.getrow(), "acc1_cd")
	
	if ls_acc1_cd = '' or isnull(ls_acc1_cd) then 
		setnull(lstr_account.gbn1)
		if isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'
		OpenWithParm(W_KFZ04OM0_POPUP, lstr_account.gbn1)
	else
		gs_code = dw_ip.getitemstring(dw_ip.getrow(), "acc1_cd") + dw_ip.getitemstring(dw_ip.getrow(), "acc2_cd")
		if lstr_account.gbn1 = "" or isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'
		OpenWithParm(W_KFZ04OM0_POPUP_KWAN, lstr_account.gbn1)
	end if
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"person_cd",lstr_custom.code)
	this.SetItem(this.GetRow(),"person_nm", lstr_custom.name)
	
END IF

dw_ip.SetFocus()
end event

event dw_ip::ue_key;IF key = keyf1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld41
integer x = 50
integer y = 252
integer width = 4549
integer height = 2000
string dataobject = "dw_kgld412"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgld41
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 248
integer width = 4576
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type

