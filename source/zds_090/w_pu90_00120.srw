$PBExportHeader$w_pu90_00120.srw
$PBExportComments$** 업체별 매입금액 현황
forward
global type w_pu90_00120 from w_standard_print
end type
type rr_1 from roundrectangle within w_pu90_00120
end type
type rr_2 from roundrectangle within w_pu90_00120
end type
end forward

global type w_pu90_00120 from w_standard_print
integer width = 4631
string title = "업체별 매입금액 현황"
rr_1 rr_1
rr_2 rr_2
end type
global w_pu90_00120 w_pu90_00120

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_sdate , ls_edate ,ls_cvcod1 , ls_cvcod2

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_sdate  = Trim(dw_ip.Object.sdate[1])


ls_cvcod1 = Trim(dw_ip.Object.cvcod1[1])
ls_cvcod2 = Trim(dw_ip.Object.cvcod2[1])

If ls_sdate = '' Or isNull(ls_sdate) Or f_dateChk(ls_sdate+'01') < 1 Then
	f_message_chk(35,'[기준년월]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("sdate")
	Return -1
end If

If ls_cvcod1 = '' Or isNull(ls_cvcod1) Then ls_cvcod1 = '.'
If ls_cvcod2 = '' Or isNull(ls_cvcod2) Then ls_cvcod2 = 'zzzzzz'

String  ls_saupj
ls_saupj = dw_ip.GetItemString(1, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

if dw_list.Retrieve(ls_saupj, ls_sdate ,ls_cvcod1 , ls_cvcod2 ) <= 0 then
	f_message_chk(50,'[업체별 매입금액 현황]')
	dw_ip.Setfocus()

	return -1
	
End if

Return 1 

end function

on w_pu90_00120.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pu90_00120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.Object.sdate[1] = Left(is_today,6)


end event

type p_xls from w_standard_print`p_xls within w_pu90_00120
end type

type p_sort from w_standard_print`p_sort within w_pu90_00120
end type

type p_preview from w_standard_print`p_preview within w_pu90_00120
integer x = 4055
end type

type p_exit from w_standard_print`p_exit within w_pu90_00120
integer x = 4402
end type

type p_print from w_standard_print`p_print within w_pu90_00120
integer x = 4229
end type

type p_retrieve from w_standard_print`p_retrieve within w_pu90_00120
integer x = 3881
end type







type st_10 from w_standard_print`st_10 within w_pu90_00120
end type



type dw_print from w_standard_print`dw_print within w_pu90_00120
integer x = 4261
integer y = 152
integer height = 76
string dataobject = "d_pu90_00120_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pu90_00120
integer x = 59
integer y = 32
integer width = 2473
integer height = 204
string dataobject = "d_pu90_00120_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keyF2!) THEN
//   IF	this.getcolumnname() = "cod1"	THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 
//			this.SetItem(1, "cod1", "")
//	      this.SetItem(1, "nam1", "")
//	      return
//	   else
//			this.SetItem(1, "cod1", gs_code)
//	      this.SetItem(1, "nam1", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1
//		end if
//   ELSEIF this.getcolumnname() = "cod2" THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 	
//			this.SetItem(1, "cod2", "")
//	      this.SetItem(1, "nam2", "")
//	      return
//	   else
//			this.SetItem(1, "cod2", gs_code)
//	      this.SetItem(1, "nam2", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1	
//		end if	
//   END IF
//END IF  
end event

event dw_ip::itemchanged;string	sDate, sNull, sname , s_cod, s_nam1, s_nam2
integer  i_rtn

SetNull(sNull)

IF this.GetColumnName() = 'sdate' THEN
	sDate  = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate+'01') = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
//ELSEIF this.GetColumnName() = 'edate' THEN
//	sDate  = TRIM(this.gettext())
//	
//	IF sdate = '' or isnull(sdate) then return 
//	IF f_datechk(sDate) = -1	then
//		this.setitem(1, "edate", sNull)
//		return 1
//	END IF

ELSEIF this.GetColumnName() = 'cvcod1' THEN
	s_cod  = TRIM(this.gettext())
	
	Select cvnas Into :s_nam1
	  From VNDMST 
	 Where cvcod = :s_cod ;
	
	If SQLCA.SQLCODE <> 0 Then
		f_message_Chk(33,"[공급업체]")
		This.Object.cvcod1[1] = ''
		This.Object.cvnas1[1] = ''
		Return 1
	Else
		This.Object.cvnas1[1] = s_nam1
	End If

ELSEIF this.GetColumnName() = 'cvcod2' THEN
	s_cod  = TRIM(this.gettext())
	
	Select cvnas Into :s_nam1
	  From VNDMST 
	 Where cvcod = :s_cod ;
	
	If SQLCA.SQLCODE <> 0 Then
		f_message_Chk(33,"[공급업체]")
		This.Object.cvcod2[1] = ''
		This.Object.cvnas2[1] = ''
		Return 1
	Else
		This.Object.cvnas2[1] = s_nam1
	End If

	
End if




end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

If this.GetColumnName() = "cvcod1" Then
	gs_gubun = '1' 
	open(w_vndmst_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.cvcod1[1] = gs_code
	this.object.cvnas1[1] = gs_codename

ElseIf this.GetColumnName() = "cvcod2" then
	gs_gubun = '1' 
	open(w_vndmst_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.cvcod2[1] = gs_code
	this.object.cvnas2[1] = gs_codename

END IF
	



end event

type dw_list from w_standard_print`dw_list within w_pu90_00120
integer x = 46
integer y = 288
integer width = 4526
integer height = 1968
string dataobject = "d_pu90_00120_a"
boolean border = false
end type

type rr_1 from roundrectangle within w_pu90_00120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 28
integer width = 2537
integer height = 236
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pu90_00120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 280
integer width = 4544
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

