$PBExportHeader$w_kfga04.srw
$PBExportComments$경영분석표 조회 출력
forward
global type w_kfga04 from w_standard_print
end type
type pb_before from picture within w_kfga04
end type
type pb_after from picture within w_kfga04
end type
type rr_1 from roundrectangle within w_kfga04
end type
type rr_2 from roundrectangle within w_kfga04
end type
end forward

global type w_kfga04 from w_standard_print
integer x = 0
integer y = 0
string title = "경영분석표 조회 출력"
pb_before pb_before
pb_after pb_after
rr_1 rr_1
rr_2 rr_2
end type
global w_kfga04 w_kfga04

type variables
Integer  Lid_Ses
String    LsFromYm,LsToYm

end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_data_display (integer i_ses, string symf, string symt)
end prototypes

public function integer wf_retrieve ();String sMa1,sMa2,sMa3,sMa4,sMa5,sMa6,sMa7

IF dw_ip.AcceptText() = -1 THEN RETURN -1

LiD_Ses  = dw_ip.GetItemNumber(1,"acyear")
LsFromYm = dw_ip.GetItemString(1,"acymf") 
LsToYm   = dw_ip.GetItemString(1,"acymt") 

sMa1 = dw_ip.GetItemString(1,"ma_gubun1")
sMa2 = dw_ip.GetItemString(1,"ma_gubun2")
sMa3 = dw_ip.GetItemString(1,"ma_gubun3")
sMa4 = dw_ip.GetItemString(1,"ma_gubun4")
sMa5 = dw_ip.GetItemString(1,"ma_gubun5")
sMa6 = dw_ip.GetItemString(1,"ma_gubun6")
sMa7 = dw_ip.GetItemString(1,"ma_gubun7")

IF LID_Ses = 0 OR IsNull(LID_Ses) THEN
	F_MessageChk(1,'[회기]')
	dw_ip.SetColumn("acyear")
	dw_ip.SetFocus()
	Return -1
END IF
IF LsFromYm = "" OR IsNull(LsFromYm) THEN
	F_MessageChk(1,'[회기]')
	dw_ip.SetColumn("acyear")
	dw_ip.SetFocus()
	Return -1	
END IF
IF LsToYm = "" OR IsNull(LsToYm) THEN
	F_MessageChk(1,'[회기]')
	dw_ip.SetColumn("acyear")
	dw_ip.SetFocus()
	Return -1	
END IF

IF sMa1 = 'N' AND sMa2 = 'N' AND sMa3 = 'N' AND sMa4 = 'N' AND sMa5 = 'N' AND sMa6 = 'N' AND sMa7 = 'N' THEN
	MessageBox("확 인", "출력항목은 반드시 하나 이상 ~r~r선택되어야 합니다.")
   return -1
END IF

Wf_Data_Display(LiD_Ses,LsFromYm,LsToYm)

IF dw_list.RowCount() <= 0 THEN
	F_MessageChk(14,'')
	
	pb_before.Enabled = False
	pb_after.Enabled = False
	
	Return -1
END IF

pb_before.Enabled = True
pb_after.Enabled  = True

Return 1
end function

public function integer wf_data_display (integer i_ses, string symf, string symt);String ls_GetSqlSyntax,sFlag = 'Y',sMa1,sMa2,sMa3,sMa4,sMa5,sMa6,sMa7,sTitle
Long   ll_GetSqlSyntax

dw_ip.AcceptText()
sMa1 = dw_ip.GetItemString(1,"ma_gubun1")
sMa2 = dw_ip.GetItemString(1,"ma_gubun2")
sMa3 = dw_ip.GetItemString(1,"ma_gubun3")
sMa4 = dw_ip.GetItemString(1,"ma_gubun4")
sMa5 = dw_ip.GetItemString(1,"ma_gubun5")
sMa6 = dw_ip.GetItemString(1,"ma_gubun6")
sMa7 = dw_ip.GetItemString(1,"ma_gubun7")

IF sMa1 = 'N' AND sMa2 = 'N' AND sMa3 = 'N' AND sMa4 = 'N' AND sMa5 = 'N' AND sMa6 = 'N' AND sMa7 = 'N' THEN
	MessageBox("확 인", "출력항목은 반드시 하나 이상 ~r~r선택되어야 합니다.")
   return -1
END IF

ls_GetSqlSyntax = 'select a.ma_gubun,	a.ma_code,	a.ma_name,	a.ma_sort,	a.ma_bunmo,' + &
						'       a.ma_bunja,	b.ma_actual,   b.ma_stand,	b.bunja,' + &
						'       b.bunmo,		b.remark,	b.ma_code ' + &
						' from kfz09om0 a, kfz09wk b ' + &
						' where a.ma_gubun = b.ma_gubun and ' + &
						'		  a.ma_code = b.ma_code and ' + &
						'       to_char(b.acyear) = ' + "'" + String(i_ses) + "'" + ' and ' + &
						'       b.acymf = ' + "'" + sYmF + "'" + ' and ' + &
						'       b.acymt = ' + "'" + sYmT + "'" + ' and ' + &
						'       a.ma_prtgu = ' + "'" + sFlag + "'" + ' and ' + &
						'       ( ' 
						
/*유동성*/
if sMa1 = 'Y' then
	ls_GetSqlSyntax = ls_GetSqlSyntax + '(a.ma_gubun = ' + "'"+"1" + "'" + ') or' 	
end if

/*안정성*/
if sMa2 = 'Y' then
	ls_GetSqlSyntax = ls_GetSqlSyntax + '(a.ma_gubun = ' + "'"+"2" + "'" + ') or' 	
end if
	
/*수익성*/
if sMa3 = 'Y' then
	ls_GetSqlSyntax = ls_GetSqlSyntax + '(a.ma_gubun = ' + "'"+"3" + "'" + ') or' 	
end if
	
/*활동성*/
if sMa4 = 'Y' then
	ls_GetSqlSyntax = ls_GetSqlSyntax + '(a.ma_gubun = ' + "'"+"4" + "'" + ') or' 	
end if

/*배당관련*/
if sMa5 = 'Y' then
	ls_GetSqlSyntax = ls_GetSqlSyntax + '(a.ma_gubun = ' + "'"+"5" + "'" + ') or' 	
end if

/*부가가치성*/
if sMa6 = 'Y' then
	ls_GetSqlSyntax = ls_GetSqlSyntax + '(a.ma_gubun = ' + "'"+"6" + "'" + ') or' 	
end if

/*성장성*/
if sMa7 = 'Y' then
	ls_GetSqlSyntax = ls_GetSqlSyntax + '(a.ma_gubun = ' + "'"+"7" + "'" + ') or' 	
end if

ll_GetSqlSyntax = len(ls_GetSqlSyntax)
ls_GetSqlSyntax = mid(ls_GetSqlSyntax, 1, ll_GetSqlSyntax - 2)

/*brace를 하나 더 추가한다.*/
ls_GetSqlSyntax = ls_GetSqlSyntax + ')'	

dw_list.SetSqlSelect(ls_GetSqlSyntax)

sTitle = String(i_ses) + '기 (' +String(symf,'@@@@.@@')+'-'+String(symt,'@@@@.@@')+') 기준' 
dw_list.modify("title_1.text ='"+sTitle+"'")

dw_list.SetRedraw(false)
dw_list.Retrieve()
dw_list.SetRedraw(true)	

Return 1

end function

on w_kfga04.create
int iCurrent
call super::create
this.pb_before=create pb_before
this.pb_after=create pb_after
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_before
this.Control[iCurrent+2]=this.pb_after
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kfga04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_before)
destroy(this.pb_after)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;Integer iD_Ses
String  sFromYm,sToYm,sCurYm,sMaxData

SELECT Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT" 
	INTO :sMaxData 
   FROM "KFZ09WK" 
   WHERE Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT" = 
			(SELECT MAX(Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT")
   			FROM "KFZ09WK" );
								
IF SQLCA.SQLCODE <> 0 THEN
	sCurYm = Left(F_Today(),6)
	
	SELECT "D_SES",   "DYM01",   	"DYM12"  
		INTO :iD_Ses,	:sFromYm,	:sToYm   
		FROM "KFZ08OM0" ;	
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

type p_preview from w_standard_print`p_preview within w_kfga04
integer x = 4091
integer taborder = 30
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kfga04
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kfga04
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfga04
integer taborder = 20
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_kfga04
integer x = 2373
integer y = 2536
integer width = 489
integer height = 88
end type

type sle_msg from w_standard_print`sle_msg within w_kfga04
integer height = 80
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfga04
integer y = 2540
integer height = 84
end type

type st_10 from w_standard_print`st_10 within w_kfga04
integer height = 80
end type



type dw_print from w_standard_print`dw_print within w_kfga04
string dataobject = "d_kfga042_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfga04
integer x = 59
integer y = 8
integer width = 3415
integer height = 184
integer taborder = 10
string dataobject = "d_kfga041"
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

type dw_list from w_standard_print`dw_list within w_kfga04
integer x = 78
integer y = 208
integer width = 4535
integer height = 2080
string dataobject = "d_kfga042"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type pb_before from picture within w_kfga04
integer x = 3689
integer y = 68
integer width = 78
integer height = 64
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\prior.gif"
boolean focusrectangle = false
end type

event clicked;String  sYmF,sYmT,sCompData,sPriorData
Integer i_Ses

IF dw_ip.AcceptText() = -1 THEN RETURN -1

i_Ses  = dw_ip.GetItemNumber(1,"acyear")
sYmF   = dw_ip.GetItemString(1,"acymf") 
sYmT   = dw_ip.GetItemString(1,"acymt") 

sCompData = String(i_Ses,'000')+sYmF+sYmT

SELECT MAX(Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT") 
	INTO :sPriorData 
   FROM "KFZ09WK" 
   WHERE Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT" < :sCompData ;
IF SQLCA.SQLCODE <> 0 OR IsNull(sPriorData) OR sPriorData = '' THEN
	F_MessageChk(14,'')
	dw_ip.SetColumn("acyear")
	dw_ip.Setfocus()
	Return
END IF

LiD_Ses  = Integer(Left(sPriorData,3))
LsFromYm = Mid(sPriorData,4,6)
LsToYm   = Right(sPriorData,6)

dw_ip.SetItem(1,"acyear",  LiD_Ses)
dw_ip.SetItem(1,"acymf",   LsFromYm)
dw_ip.SetItem(1,"acymt",   LsToYm)

Wf_Data_Display(LiD_Ses,LsFromYm,LsToYm)

end event

type pb_after from picture within w_kfga04
integer x = 3790
integer y = 68
integer width = 78
integer height = 64
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\next.gif"
boolean focusrectangle = false
end type

event clicked;String  sYmF,sYmT,sCompData,sNextData
Integer i_Ses

IF dw_ip.AcceptText() = -1 THEN RETURN -1

i_Ses  = dw_ip.GetItemNumber(1,"acyear")
sYmF   = dw_ip.GetItemString(1,"acymf") 
sYmT   = dw_ip.GetItemString(1,"acymt") 

sCompData = String(i_Ses,'000')+sYmF+sYmT

SELECT MIN(Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT") 
	INTO :sNextData 
   FROM "KFZ09WK" 
   WHERE Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT" > :sCompData ;
IF SQLCA.SQLCODE <> 0 OR IsNull(sNextData) OR sNextData = '' THEN
	F_MessageChk(14,'')
	dw_ip.SetColumn("acyear")
	dw_ip.Setfocus()
	Return
END IF

LiD_Ses  = Integer(Left(sNextData,3))
LsFromYm = Mid(sNextData,4,6)
LsToYm   = Right(sNextData,6)

dw_ip.SetItem(1,"acyear",  LiD_Ses)
dw_ip.SetItem(1,"acymf",   LsFromYm)
dw_ip.SetItem(1,"acymt",   LsToYm)

Wf_Data_Display(LiD_Ses,LsFromYm,LsToYm)

end event

type rr_1 from roundrectangle within w_kfga04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3662
integer y = 40
integer width = 229
integer height = 116
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfga04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 204
integer width = 4558
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

