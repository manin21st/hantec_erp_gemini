$PBExportHeader$w_kfga08.srw
$PBExportComments$월별 추정 재무제표
forward
global type w_kfga08 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfga08
end type
end forward

global type w_kfga08 from w_standard_print
integer x = 0
integer y = 0
string title = "월별 추정 재무제표 조회 출력"
rr_1 rr_1
end type
global w_kfga08 w_kfga08

type variables
Integer  Lid_Ses
String    LsFromYm,LsToYm

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sFsGbn, sFromYm_Bef_Bef,sToYm_Bef_Bef, sFromYm_Bef,sToYm_Bef,&
		  sFromYm_Cur,sToYm_Cur,sFromYm_Qtr,sToYm_Qtr

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sToYm_Cur = Trim(dw_ip.GetItemString(1,"acymf"))
sFsGbn    = dw_ip.GetItemString(1,"fs_gu") 

IF sToYm_Cur = "" OR IsNull(sToYm_Cur) THEN
	F_MessageChk(1,'[기준년월]')
	dw_ip.SetColumn("acymf")
	dw_ip.SetFocus()
	Return -1	
ELSE
	sFromYm_Cur = sToYm_Cur
	
	sFromYm_Bef = Left(sToYm_Cur,4) + String(Integer(Mid(sToYm_Cur,5,2)) - 1,'00')
	sToYm_Bef   = Left(sToYm_Cur,4) + String(Integer(Mid(sToYm_Cur,5,2)) - 1,'00')
	
	sFromYm_Bef_Bef = Left(sToYm_Cur,4) + String(Integer(Mid(sToYm_Cur,5,2)) - 2,'00')
	sToYm_Bef_Bef   = Left(sToYm_Cur,4) + String(Integer(Mid(sToYm_Cur,5,2)) - 2,'00')
	
	sFromYm_Qtr     = Left(sToYm_Cur,4) + '01'
	sToYm_Qtr       = Left(sToYm_Cur,4) + String(Integer(Mid(sToYm_Cur,5,2)) - 3,'00')
END IF

IF sFsGbn = "" OR IsNull(sFsGbn) THEN
	F_MessageChk(1,'[자료구분]')
	dw_ip.SetColumn("fs_gu")
	dw_ip.SetFocus()
	Return -1	
END IF

IF dw_list.Retrieve(sFsGbn,sFromYm_Cur,sToYm_Cur,sFromYm_Bef,sToYm_Bef,&
						  sFromYm_Bef_Bef,sToYm_Bef_Bef,sFromYm_Qtr,sToYm_Qtr) <= 0 THEN
	F_MessageChk(14,'')
	
	Return -1
END IF

Return 1
end function

on w_kfga08.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfga08.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;Integer iD_Ses
String  sFromYm,sToYm,sCurYm,sMaxData

SELECT Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT" 
	INTO :sMaxData 
   FROM "KFZ09WK2" 
   WHERE Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT" = 
			(SELECT MAX(Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT")
   			FROM "KFZ09WK2" );
								
IF SQLCA.SQLCODE <> 0 THEN
	sCurYm = Left(F_Today(),6)
	
	SELECT "D_SES",   "DYM01",   	"DYM12"  
		INTO :iD_Ses,	:sFromYm,	:sToYm   
		FROM "KFZ08OM0"  ;	
ELSE
	iD_Ses  = Integer(Left(sMaxData,3))
	sFromYm = Mid(sMaxData,4,6)
	sToYm   = Right(sMaxData,6)
END IF

dw_ip.SetItem(1,"acyear",  iD_Ses)
dw_ip.SetItem(1,"acymf",   sFromYm)
dw_ip.SetItem(1,"acymt",   sToYm)

dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kfga08
integer y = 0
integer taborder = 30
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kfga08
integer y = 0
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kfga08
integer y = 0
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfga08
integer y = 0
integer taborder = 20
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_kfga08
integer y = 2788
end type

type sle_msg from w_standard_print`sle_msg within w_kfga08
integer y = 2788
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfga08
integer y = 2788
end type

type st_10 from w_standard_print`st_10 within w_kfga08
integer y = 2640
end type

type gb_10 from w_standard_print`gb_10 within w_kfga08
integer y = 2752
end type

type dw_print from w_standard_print`dw_print within w_kfga08
integer x = 3397
integer y = 20
string dataobject = "d_kfga082_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfga08
integer x = 64
integer y = 20
integer width = 2295
integer height = 124
integer taborder = 10
string dataobject = "d_kfga081"
end type

event dw_ip::rbuttondown;String ls_gj1, ls_gj2,rec_acc1,rec_acc2,sname1,sname2

dw_ip.AcceptText()
IF this.GetColumnName() = "acc1f" OR this.GetColumnName() = "acc2f" THEN
	ls_gj1 = dw_ip.GetItemString(dw_ip.GetRow(), "acc1f")
	ls_gj2 = dw_ip.GetItemString(dw_ip.GetRow(), "acc2f")
ELSEIF this.GetColumnName() = "acc1t" OR this.GetColumnName() = "acc2t" THEN 
	ls_gj1 = dw_ip.GetItemString(dw_ip.GetRow(), "acc1t")
	ls_gj2 = dw_ip.GetItemString(dw_ip.GetRow(), "acc2t")
END IF
IF IsNull(ls_gj1) then
   ls_gj1 = ""
end if
IF IsNull(ls_gj2) then
   ls_gj2 = ""
end if
lstr_account.acc1_cd = Trim(ls_gj1)
lstr_account.acc2_cd = Trim(ls_gj2)
Open(W_KFZ01OM0_POPUP)

IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN

IF this.GetColumnName() = "acc1f" OR this.GetColumnName() = "acc2f" THEN
	dw_ip.SetItem(dw_ip.GetRow(), "acc1f", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "acc2f", lstr_account.acc2_cd)
	dw_ip.SetItem(dw_ip.Getrow(),"accf_name",lstr_account.acc2_nm)
ELSEIF this.GetColumnName() = "acc1t" OR this.GetColumnName() = "acc2t" THEN 
	dw_ip.SetItem(dw_ip.GetRow(), "acc1t", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "acc2t", lstr_account.acc2_cd)
	dw_ip.SetItem(dw_ip.Getrow(),"acct_name",lstr_account.acc2_nm)
END IF
dw_ip.SetFocus()
end event

event dw_ip::itemerror;call super::itemerror;
Return 1

end event

event dw_ip::itemchanged;String  sFromYm,sToYm,sNull
Integer iD_Ses

SetNull(snull)
IF this.GetColumnName() = "acyear" THEN
	iD_Ses = Integer(this.GetText())
	IF iD_Ses = 0 OR IsNull(iD_Ses) THEN 
		this.SetItem(this.GetRow(),"acymf",sNull)
		this.SetItem(this.GetRow(),"acymt",sNull)
		Return
	END IF
	
	SELECT "DYM01",   	"DYM12"  		INTO :sFromYm,	:sToYm   
		FROM "KFZ08OM0"  
		WHERE "KFZ08OM0"."D_SES" = :iD_Ses ;
		
	this.SetItem(this.GetRow(),"acymf",   sFromYm)
	this.SetItem(this.GetRow(),"acymt",   sToYm)
END IF

end event

type dw_list from w_standard_print`dw_list within w_kfga08
integer x = 82
integer y = 164
integer width = 4521
integer height = 2136
string dataobject = "d_kfga082"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_kfga08
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 156
integer width = 4549
integer height = 2160
integer cornerheight = 40
integer cornerwidth = 55
end type

