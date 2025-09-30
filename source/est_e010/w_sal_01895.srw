$PBExportHeader$w_sal_01895.srw
$PBExportComments$견적원가 LIST현황
forward
global type w_sal_01895 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_01895
end type
end forward

global type w_sal_01895 from w_standard_print
string title = "견적원가 LIST"
rr_1 rr_1
end type
global w_sal_01895 w_sal_01895

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_pdm , ls_sdate , ls_edate , ls_cstno , tx_name

if dw_ip.accepttext() <> 1 then return -1

ls_pdm   = Trim(dw_ip.getitemstring(1,'pdm'))
ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))
ls_cstno  = Trim(dw_ip.getitemstring(1,'cstno'))

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[접수일자 FROM]')
	dw_ip.setfocus()
	dw_ip.setcolumn('sdate')
	return -1
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[접수일자 TO]')
	dw_ip.setfocus()
	dw_ip.setcolumn('edate')
	return -1
end if

if ls_pdm = "" or isnull(ls_pdm) then ls_pdm = '%'
if ls_cstno = "" or isnull(ls_cstno) then ls_cstno = '%'

if dw_list.retrieve(gs_sabu , ls_sdate , ls_edate , ls_pdm , ls_cstno) < 1 then
	f_message_chk(300,'')
	dw_ip.setfocus()
	dw_ip.setcolumn('sdate')
	return -1
end if

//dw_list.object.tx_sdate.text = left(ls_sdate,4) + '.' + mid(ls_sdate,5,2) + '.' + mid(ls_sdate,7,2)
//dw_list.object.tx_edate.text = left(ls_edate,4) + '.' + mid(ls_edate,5,2) + '.' + mid(ls_edate,7,2)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdm) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_pdm.text = '"+tx_name+"'")

return 1
end function

on w_sal_01895.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_01895.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_ip.setitem(1,'sdate',left(f_today(),6) + '01' )
dw_ip.setitem(1,'edate',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_sal_01895
end type

type p_exit from w_standard_print`p_exit within w_sal_01895
end type

type p_print from w_standard_print`p_print within w_sal_01895
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01895
end type







type st_10 from w_standard_print`st_10 within w_sal_01895
end type



type dw_print from w_standard_print`dw_print within w_sal_01895
string dataobject = "d_sal_01895_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01895
integer x = 59
integer width = 3118
integer height = 216
string title = "견적원가 LIST"
string dataobject = "d_sal_01895"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_sdate , ls_edate , snull ,ls_ofno ,ls_gubun
long   ll_count

setnull(snull)

Choose Case this.getcolumnname()
	Case 'gubun'
		ls_gubun = this.gettext()
		
		dw_list.setredraw(false)
		if ls_gubun ='1' then
			dw_list.dataobject = 'd_sal_01895_01'
		else
			dw_list.dataobject = 'd_sal_01895_02'
		end if
		dw_list.settransobject(sqlca)
		dw_list.setredraw(true)
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
   Case 'cstno'
		ls_ofno = Trim(this.gettext())
		
		if ls_ofno = "" or isnull(ls_ofno) then return
		
		SELECT COUNT(*)
		INTO   :ll_count
		FROM   CALCSTH
		WHERE  CSTNO = :ls_ofno ;
		
      if ll_count < 1 then 
			messagebox('확인','견적계산번호가 존재 하지 않습니다.')
		   SetItem(1,'cstno',sNull)
			Return 1
		END IF 
		
		IF SQLCA.SQLCODE <> 0 OR sqlca.sqlnrows > 1 THEN
			f_message_chk(33,'[견적계산번호]')
			SetItem(1,'cstno',sNull)
			Return 1
		END IF 
		
End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_gubun)
SetNull(Gs_codename)

Choose Case GetColumnName()
	/* 견적계산번호 */
	Case "cstno"
			Open(w_sal_01760_popup)
			IF gs_code ="" OR IsNull(gs_code) THEN RETURN
			
			SetItem(1,"cstno",gs_code)
		
END Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_01895
integer x = 69
integer y = 352
integer width = 4526
integer height = 1964
string dataobject = "d_sal_01895_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_01895
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 348
integer width = 4544
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

