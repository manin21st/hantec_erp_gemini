$PBExportHeader$w_tht_4556.srw
$PBExportComments$초중종물 검사 추이도(합불판정)
forward
global type w_tht_4556 from w_standard_print
end type
type rr_1 from roundrectangle within w_tht_4556
end type
end forward

global type w_tht_4556 from w_standard_print
integer width = 4677
integer height = 2568
string title = "초중종물 검사 추이도(합불판정)"
rr_1 rr_1
end type
global w_tht_4556 w_tht_4556

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	ls_yyyymm, ls_wkctr, ls_itnbr

if dw_ip.accepttext( ) = -1 then return -1

ls_yyyymm	=	dw_ip.getitemstring(1, 'yyyymm')
ls_wkctr	=	dw_ip.getitemstring(1, 'wkctr')
ls_itnbr	=	dw_ip.getitemstring(1, 'itnbr')

IF ls_yyyymm = '' OR isNull(ls_yyyymm)	THEN	
	MessageBox('확인', '검사년월을 입력 하십시오.')
	f_setfocus_dw(dw_ip, 1, 'yyyymm')
	Return -1	
END IF

IF ls_wkctr = '' OR isNull(ls_wkctr)	THEN	
	MessageBox('확인', '작업장을 입력 하십시오.')
	f_setfocus_dw(dw_ip, 1, 'wkctr')
	Return -1	
END IF

if ls_itnbr = '' or isnull(ls_itnbr)	then
	MessageBox('확인', '품번을 입력 하십시오.')
	f_setfocus_dw(dw_ip, 1, 'itnbr')
	Return -1	
END IF

dw_list.retrieve( ls_yyyymm, ls_wkctr, ls_itnbr)

return 1
end function

on w_tht_4556.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_tht_4556.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string	sToday

sToday	= f_today()

dw_ip.setitem(1, 'yyyymm', Left(sToday,6))

end event

type p_xls from w_standard_print`p_xls within w_tht_4556
boolean visible = true
integer x = 3671
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_tht_4556
integer x = 3493
integer y = 32
end type

type p_preview from w_standard_print`p_preview within w_tht_4556
boolean enabled = true
end type

type p_exit from w_standard_print`p_exit within w_tht_4556
end type

type p_print from w_standard_print`p_print within w_tht_4556
boolean enabled = true
end type

type p_retrieve from w_standard_print`p_retrieve within w_tht_4556
end type







type st_10 from w_standard_print`st_10 within w_tht_4556
end type



type dw_print from w_standard_print`dw_print within w_tht_4556
integer x = 3831
integer y = 180
string dataobject = "d_tht_4556_p"
end type

type dw_ip from w_standard_print`dw_ip within w_tht_4556
integer x = 37
integer y = 32
integer width = 3433
integer height = 220
string dataobject = "d_tht_4556_c"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sNull,sPdtgu, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sjijil, sispeccode
String  sItemCls, sItemGbn, sItemClsName, ls_wkctr
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

if this.GetColumnName( ) = 'itnbr' then
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'itnbr',sNull)
			Return
		END IF
		
		SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",
				 "ITEMAS"."ISPEC","ITNCT"."TITNM", "ITNCT"."PDTGU"
		  INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName,:sPdtgu
		  FROM "ITEMAS","ITNCT"
		 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				 "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				 "ITEMAS"."ITNBR" = :sItnbr ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		END IF
		
		SetItem(nRow,"itdsc", sItdsc)
		
		// 표준공정의 검사구분이 자주검사 인 자료 중 최종공정
		SELECT A.WKCTR 
		INTO    :ls_wkctr
		FROM ROUTNG A
		WHERE A.ITNBR = :sItnbr
		AND A.QCGUB = '1'
		AND A.OPSEQ =  (SELECT MAX(OPSEQ) FROM ROUTNG WHERE ITNBR = A.ITNBR)
		GROUP BY A.WKCTR;
				
		SetItem(nRow,"wkctr", ls_wkctr)
elseif this.GetColumnName( ) = 'itdsc' then
	sItdsc = trim(GetText())	
		IF sItdsc ="" OR IsNull(sItdsc) THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			Return
		END IF
		
		/* 품명으로 품번찾기 */
		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetColumn("itdsc")
			Return 1
		End If	
end if

end event

event dw_ip::rbuttondown;if row < 1 then
	return
end if
string sItdsc

if this.GetColumnName( ) = 'empno' or  this.GetColumnName( ) = 'empname' then
	open(w_sawon_popup)
	
	if gs_code = '' or isnull(gs_code) then
		return
	end if
	
	this.setitem(1, 'empno', gs_code)
	this.setitem(1, 'empname', gs_codename)	
elseif this.GetColumnName( ) = 'itnbr' or  this.GetColumnName( ) = 'itdsc' then
	gs_code	=	'1'			/*품목구분*/
	open(w_itemas_popup)
	
	if gs_code = '' or isnull(gs_code) then
		return
	end if
	
	SELECT	FUN_GET_ITDSC(:gs_code)
	  INTO	:sItdsc
	  FROM	DUAL;
	
	this.setitem(1, 'itnbr', gs_code)
	this.setitem(1, 'itdsc', sitdsc)	
end if

SetNull(gs_code)
SetNull(gs_codename)

end event

type dw_list from w_standard_print`dw_list within w_tht_4556
integer x = 50
integer y = 264
integer width = 4544
integer height = 1936
string dataobject = "d_tht_4556_l"
boolean border = false
end type

event dw_list::clicked;call super::clicked;if row < 1 then
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
this.SelectRow(row, true)
this.SetRow(row)
this.SetRedraw(true)
end event

type rr_1 from roundrectangle within w_tht_4556
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 256
integer width = 4576
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

