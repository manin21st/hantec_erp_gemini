$PBExportHeader$w_qa90_00610.srw
$PBExportComments$클레임 접수현황
forward
global type w_qa90_00610 from w_standard_print
end type
type rr_1 from roundrectangle within w_qa90_00610
end type
end forward

global type w_qa90_00610 from w_standard_print
string title = "CRAIM 접수 현황"
rr_1 rr_1
end type
global w_qa90_00610 w_qa90_00610

type prototypes



end prototypes

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String 	ls_jpno, ls_saupj 

If dw_ip.AcceptText() = -1 Then 
	dw_ip.SetFocus()
	Return -1
End if	

ls_jpno = Trim(dw_ip.Object.cl_jpno[1])
ls_saupj  = Trim(dw_ip.Object.saupj[1])

If isNull(ls_jpno) or ls_jpno = ''  Then
	f_message_chk(1400 , '[통보서번호]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("cl_jpno")
	Return -1 
End If

if dw_list.Retrieve(ls_saupj , ls_jpno) <= 0 then
	f_message_chk(50,"[CLAIM 현황]")
	dw_ip.Setfocus()
	Return -1
End If

Return 1
	
end function

on w_qa90_00610.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qa90_00610.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
//dw_ip.Object.yyyy[1] = String(Long(Left(is_today , 4)) - 1)

//dw_ip.Object.syymm[1] = Left(is_today , 6)

/* User별 사업장 Setting Start */
If f_check_saupj() = 1 Then
	dw_ip.Modify("saupj.protect=1")
End If
dw_ip.SetItem(1, 'saupj', gs_code)
/* ---------------------- End  */
end event

type p_preview from w_standard_print`p_preview within w_qa90_00610
integer x = 4041
integer y = 32
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_qa90_00610
integer x = 4389
integer y = 32
integer taborder = 110
end type

type p_print from w_standard_print`p_print within w_qa90_00610
integer x = 4215
integer y = 32
integer taborder = 70
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa90_00610
integer x = 3867
integer y = 32
end type



type sle_msg from w_standard_print`sle_msg within w_qa90_00610
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_qa90_00610
end type



type dw_print from w_standard_print`dw_print within w_qa90_00610
string dataobject = "d_qa90_00610_p2"
end type

type dw_ip from w_standard_print`dw_ip within w_qa90_00610
integer x = 32
integer y = 32
integer width = 2107
integer height = 164
string dataobject = "d_qa90_00610_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;//String  ls_col , ls_cod ,ls_nam , ls_null
//Setnull(ls_null)
//ls_col = Lower(GetColumnName())
//ls_cod = Trim(GetText())
//
//Choose Case ls_col
// 
//	Case 'cvcod'
//		If ls_cod = '' Or isNull(ls_cod) Then
//			this.setitem(1,'cvcod',ls_null)
//			this.setitem(1,'cvnas',ls_null)
//			Return 
//		End If
//		
//		select cvnas into :ls_nam 
//		  from vndmst
//	 	 where cvcod = :ls_cod ;
//	 
//		if sqlca.sqlcode = 0 then
//			this.setitem(1,'cvnas',ls_nam)
//		else
//			f_message_chk(33, "[업체코드]")
//			this.setitem(1,'cvcod',ls_null)
//			this.setitem(1,'cvnas',ls_null)
//			return 1
//		end if
//End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

If	Getcolumnname() = "cl_jpno" Then 
	
	open(w_qa03_00020_popup)
	
	If isNull(gs_code) And isNull(gs_gubun) Then Return
	
	This.object.cl_jpno[1] = left(gs_code ,12)
   This.object.gubun[1] = gs_gubun
	
	Return

End If	
end event

type dw_list from w_standard_print`dw_list within w_qa90_00610
integer x = 55
integer y = 216
integer width = 4498
integer height = 2004
string dataobject = "d_qa90_00610_a"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_1 from roundrectangle within w_qa90_00610
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 208
integer width = 4521
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

