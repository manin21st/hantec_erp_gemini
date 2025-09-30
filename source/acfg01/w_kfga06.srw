$PBExportHeader$w_kfga06.srw
$PBExportComments$년도별 재무제표
forward
global type w_kfga06 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfga06
end type
end forward

global type w_kfga06 from w_standard_print
integer x = 0
integer y = 0
string title = "년도별 재무제표 조회 출력"
rr_1 rr_1
end type
global w_kfga06 w_kfga06

type variables
Integer  Lid_Ses
String    LsFromYm,LsToYm

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sFsGbn, sFromYm_Bef,sToYm_Bef, sFromYm_Bef_Bef,sToYm_Bef_Bef
Integer iSes_Bef,iSes_Bef_Bef,iFunVal

IF dw_ip.AcceptText() = -1 THEN RETURN -1

LiD_Ses  = dw_ip.GetItemNumber(1,"acyear")
LsFromYm = dw_ip.GetItemString(1,"acymf") 
LsToYm   = dw_ip.GetItemString(1,"acymt") 
sFsGbn   = dw_ip.GetItemString(1,"fs_gu")

IF LID_Ses = 0 OR IsNull(LID_Ses) THEN
	F_MessageChk(1,'[회기]')
	dw_ip.SetColumn("acyear")
	dw_ip.SetFocus()
	Return -1
ELSE
	iSes_Bef     = Lid_Ses - 1
	iSes_Bef_Bef = Lid_Ses - 2		
END IF

IF LsFromYm = "" OR IsNull(LsFromYm) THEN
	F_MessageChk(1,'[시작년월]')
	dw_ip.SetColumn("acymf")
	dw_ip.SetFocus()
	Return -1	
ELSE
	sFromYm_Bef     = String(Long(Left(LsFromYm,4)) - 1,'0000')+Mid(LsFromYm,5,2)
	sFromYm_Bef_Bef = String(Long(Left(LsFromYm,4)) - 2,'0000')+Mid(LsFromYm,5,2)
END IF

IF LsToYm = "" OR IsNull(LsToYm) THEN
	F_MessageChk(1,'[종료년월]')
	dw_ip.SetColumn("acymt")
	dw_ip.SetFocus()
	Return -1	
ELSE
	sToYm_Bef     = String(Long(Left(LsToYm,4)) - 1,'0000')+Mid(LsToYm,5,2)
	sToYm_Bef_Bef = String(Long(Left(LsToYm,4)) - 2,'0000')+Mid(LsToYm,5,2)
END IF

IF sFsGbn = "" OR IsNull(sFsGbn) THEN
	F_MessageChk(1,'[자료구분]')
	dw_ip.SetColumn("fs_gu")
	dw_ip.SetFocus()
	Return -1	
END IF

//IF MessageBox('확 인','자료를 생성하시겠습니까?',Question!,YesNo!) = 1 THEN
//	w_mdi_frame.sle_msg.text ="년별 재무제표 작성 중..."
//	SetPointer(HourGlass!)
//	iFunVal = sqlca.fun_create_kfz09wk2(LiD_Ses,LsFromYm,LsToYm,'%')
//	IF iFunVal = -1 THEN
//		MessageBox('확 인','년별 재무제표 작성 실패!')
//		Return -1
//	END IF	
//	Commit;
//END IF
	
IF dw_list.Retrieve(sFsGbn,Lid_Ses,LsFromYm,LsToYm,iSes_Bef,sFromYm_Bef,sToYm_Bef,&
						  iSes_Bef_Bef,sFromYm_Bef_Bef,sToYm_Bef_Bef) <= 0 THEN
	F_MessageChk(14,'')
	
	Return -1
END IF


Return 1
end function

on w_kfga06.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfga06.destroy
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

type p_preview from w_standard_print`p_preview within w_kfga06
integer y = 0
integer taborder = 30
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kfga06
integer y = 0
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kfga06
integer y = 0
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfga06
integer y = 0
integer taborder = 20
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_kfga06
integer y = 2788
end type

type sle_msg from w_standard_print`sle_msg within w_kfga06
integer y = 2788
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfga06
integer y = 2788
end type

type st_10 from w_standard_print`st_10 within w_kfga06
integer y = 2640
end type

type gb_10 from w_standard_print`gb_10 within w_kfga06
integer y = 2752
end type

type dw_print from w_standard_print`dw_print within w_kfga06
integer x = 3397
integer y = 20
string dataobject = "d_kfga062_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfga06
integer x = 73
integer y = 20
integer width = 3099
integer height = 124
integer taborder = 10
string dataobject = "d_kfga061"
end type

event dw_ip::rbuttondown;String   sNull
Integer  lNull

SetNull(sNull);	SetNull(lNull);

this.AcceptText()
IF this.GetColumnName() = 'acyear' THEN
	SetNull(Gs_Code);
	
	Gs_Code = String(this.GetItemNumber(this.GetRow(),"acyear"))
	IF IsNull(Gs_Code) THEN Gs_Code = ''
	
	Open(W_kfz02wk2_popup)
	
	IF IsNull(Gs_Code) OR Gs_Code = '' THEN Return
		
	this.SetItem(1,"acyear", Integer(Left(Gs_Code,3)))
	
	this.TriggerEvent(ItemChanged!)
END IF

end event

event dw_ip::itemerror;call super::itemerror;
Return 1

end event

event dw_ip::itemchanged;String  sFromYm,sToYm,sNull,sYear
Integer iD_Ses,lNull

SetNull(snull);		SetNull(lNull);

IF this.GetColumnName() = "acyear" THEN
	iD_Ses = Integer(this.GetText())
	IF iD_Ses = 0 OR IsNull(iD_Ses) THEN 
		this.SetItem(this.GetRow(),"acymf",sNull)
		this.SetItem(this.GetRow(),"acymt",sNull)
		Return
	END IF
	
	select distinct substr(curr_from_date,1,4)	into :sYear
		from kfz02wk
		where curr_year = :iD_Ses and rownum = 1 ;
	if sqlca.sqlcode <> 0 then
		MessageBox('확 인','재무제표를 생성하십시요!')
		this.SetItem(this.GetRow(),"acyear",lNull)
		this.SetItem(this.GetRow(),"acymf",sNull)
		this.SetItem(this.GetRow(),"acymt",sNull)
		Return 1
	else
		if IsNull(sYear) or sYear = '' then
			this.SetItem(this.GetRow(),"acyear",lNull)
			this.SetItem(this.GetRow(),"acymf",sNull)
			this.SetItem(this.GetRow(),"acymt",sNull)
			Return 1	
		end if
	end if
		
	this.SetItem(this.GetRow(),"acymf",   sYear+'01')
	this.SetItem(this.GetRow(),"acymt",   sYear+'12')
END IF

end event

type dw_list from w_standard_print`dw_list within w_kfga06
integer x = 82
integer y = 164
integer width = 4507
integer height = 2136
string dataobject = "d_kfga062"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_kfga06
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

