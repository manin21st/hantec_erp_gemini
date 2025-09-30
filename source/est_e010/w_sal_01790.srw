$PBExportHeader$w_sal_01790.srw
$PBExportComments$견적 계산 현황
forward
global type w_sal_01790 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_01790
end type
end forward

global type w_sal_01790 from w_standard_print
string title = "견적 계산 현황"
rr_1 rr_1
end type
global w_sal_01790 w_sal_01790

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate , ls_edate ,ls_cstno ,ls_pdm

if dw_ip.accepttext() <> 1 then return -1

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))
ls_cstno = Trim(dw_ip.getitemstring(1,'cstno'))
ls_pdm   = Trim(dw_ip.getitemstring(1,'pdm'))

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[승인일자 FROM]')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	return -1
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[승인일자 TO]')
	dw_ip.setcolumn('edate')
	dw_ip.setfocus()
	return -1
end if

if ls_cstno = "" or isnull(ls_cstno) then ls_cstno = '%'
if ls_pdm = "" or isnull(ls_pdm) then ls_pdm = '%'

if dw_list.retrieve(gs_sabu, ls_sdate, ls_edate, ls_cstno, ls_pdm) < 1 then 
	f_message_chk(300,'')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	return -1
end if

return 1
end function

on w_sal_01790.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_01790.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'sdate',left(f_today(),6) +'01')
dw_ip.setitem(1,'edate',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_sal_01790
end type

type p_exit from w_standard_print`p_exit within w_sal_01790
end type

type p_print from w_standard_print`p_print within w_sal_01790
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01790
end type







type st_10 from w_standard_print`st_10 within w_sal_01790
end type



type dw_print from w_standard_print`dw_print within w_sal_01790
string dataobject = "d_sal_01790_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01790
integer x = 59
integer y = 24
integer width = 2354
integer height = 212
string dataobject = "d_sal_01790"
end type

event dw_ip::itemchanged;String sNull, sCstNo, ls_sdate, ls_edate, sMin, sMax

SetNull(sNull)

Choose Case GetColumnName()
	Case 'sdate'
		ls_sdate = Trim(this.GetText())
		IF ls_sdate ="" OR IsNull(ls_sdate) THEN RETURN
		
		IF f_datechk(ls_sdate) = -1 THEN
			f_message_chk(35,'[접수일자 FROM]')
			this.SetItem(1,"sdate",snull)
			Return 1
		END IF
	Case 'edate'
		ls_edate = Trim(this.GetText())
		IF ls_edate ="" OR IsNull(ls_edate) THEN RETURN
		
		IF f_datechk(ls_edate) = -1 THEN
			f_message_chk(35,'[접수일자 TO]')
			this.SetItem(1,"edate",snull)
			Return 1
		END IF
	/* 견적번호 */
	Case "cstno"
		sCstNo = Trim(GetText())
		IF sCstNo = "" OR IsNull(sCstNo) THEN RETURN
		
		SELECT MAX("CSTNO"), MIN("CSTDAT"), MAX("CSTDAT")  INTO :sCstNo, :sMin, :sMax
		  FROM "CALCSTH"
		 WHERE "SABU" = :gs_sabu  AND CSTNO = :sCstNo ;
	
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[견적계산번호]')
			SetItem(1,'cstno',sNull)
			Return 1
		END IF
		
		SetItem(1, 'sdate', sMin)
		SetItem(1, 'edate', sMax)
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(Gs_code)
SetNull(Gs_gubun)
SetNull(Gs_codename)

Choose Case GetColumnName()
	/* 견적번호 */
	Case "cstno"
		Open(w_sal_01760_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cstno",gs_code)
		TriggerEvent(ItemChanged!)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_01790
integer x = 69
integer y = 264
integer width = 4517
integer height = 2052
string dataobject = "d_sal_01790_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_01790
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 256
integer width = 4539
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

