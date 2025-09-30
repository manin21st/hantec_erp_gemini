$PBExportHeader$w_qa90_00530.srw
$PBExportComments$수정불합격현황
forward
global type w_qa90_00530 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qa90_00530
end type
type pb_2 from u_pb_cal within w_qa90_00530
end type
type rr_1 from roundrectangle within w_qa90_00530
end type
end forward

global type w_qa90_00530 from w_standard_print
string title = "수정 불합격 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qa90_00530 w_qa90_00530

type prototypes



end prototypes

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_group ()
end prototypes

public function integer wf_retrieve ();String ls_date_st , ls_date_ft , ls_itnbr ,ls_itdsc , ls_pdtgu , ls_pdtgu_nm, ls_saupj

If dw_ip.AcceptText() = -1 Then 
	dw_ip.SetFocus()
	Return -1
End if	

wf_group()

ls_date_st = Trim(dw_ip.Object.sdate[1])
ls_date_ft = Trim(dw_ip.Object.edate[1])

ls_itnbr = Trim(dw_ip.Object.itnbr[1])
ls_itdsc = Trim(dw_ip.Object.itdsc[1])
ls_pdtgu = Trim(dw_ip.Object.pdtgu[1])
ls_saupj = Trim(dw_ip.Object.saupj[1])

If isNull(ls_date_st) or ls_date_st = '' or f_datechk(ls_date_st) < 1 Then
	f_message_chk(35 , '[처리일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("sdate")
	Return -1 
End If

If isNull(ls_date_ft) or ls_date_ft = '' or f_datechk(ls_date_ft) < 1 Then
	f_message_chk(35 , '[처리일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("edate")
	Return -1 
End If

If isNull(ls_itnbr) or ls_itnbr = ''  Then ls_itnbr = '%%'

if dw_list.Retrieve(ls_saupj, ls_date_st , ls_date_ft ,ls_itnbr , ls_pdtgu) <= 0 then
	f_message_chk(50,"[수정 불합격 현황]")
	dw_ip.Setfocus()
	Return -1
Else
	If ls_itnbr = '%%' Then
		dw_print.Object.t_itnbr.Text = '전체'
	else
		dw_print.Object.t_itnbr.Text = '['+ls_itnbr+'] ' + ls_itdsc
	End If
	
	Choose Case ls_pdtgu
		Case '1' 
			dw_print.Object.t_pdtgu.Text = '생산1팀'
		Case '2'
			dw_print.Object.t_pdtgu.Text = '생산2팀'
		Case Else
			dw_print.Object.t_pdtgu.Text = '전체'
	End Choose
End If

Return 1
	
end function

public function integer wf_group ();string	sbjukhap, scvcod

if dw_ip.accepttext() = -1 then return -1

scvcod = trim(dw_ip.getitemstring(1,'cvcod'))
sbjukhap = dw_ip.getitemstring(1,'bjukhap')

if sbjukhap = '1' then
	dw_list.DataObject = 'd_qa90_00530_a'
	dw_print.DataObject = 'd_qa90_00530_p'
Else
	dw_list.DataObject = 'd_qa90_00530_b'
	dw_print.DataObject = 'd_qa90_00530_p2'
End If

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_print.ShareData(dw_list)

if isnull(scvcod) or scvcod = '' then
	dw_list.setfilter("")
	dw_list.filter()
else
	dw_list.setfilter("cvcod='"+scvcod+"'")
	dw_list.filter()
end if

Return 1
end function

on w_qa90_00530.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_qa90_00530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Object.sdate[1] = f_afterday(is_today , -30)
dw_ip.Object.edate[1] =is_today

///* User별 사업장 Setting Start */
//String saupj
//
//If f_check_saupj(saupj) = 1 Then
//	dw_ip.Modify("saupj.protect=1")
//End If
//dw_ip.SetItem(1, 'saupj', saupj)
/* ---------------------- End  */

f_mod_saupj(dw_ip,'saupj')
end event

type p_preview from w_standard_print`p_preview within w_qa90_00530
integer x = 4041
integer y = 32
integer taborder = 10
end type

type p_exit from w_standard_print`p_exit within w_qa90_00530
integer x = 4389
integer y = 32
integer taborder = 30
end type

type p_print from w_standard_print`p_print within w_qa90_00530
integer x = 4215
integer y = 32
integer taborder = 20
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa90_00530
integer x = 3867
integer y = 32
end type



type sle_msg from w_standard_print`sle_msg within w_qa90_00530
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_qa90_00530
end type



type dw_print from w_standard_print`dw_print within w_qa90_00530
string dataobject = "d_qa90_00530_p2"
end type

type dw_ip from w_standard_print`dw_ip within w_qa90_00530
integer x = 32
integer y = 32
integer width = 2885
integer height = 268
string dataobject = "d_qa90_00530_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  ls_col , ls_cod ,ls_nam , ls_null
Setnull(ls_null)
ls_col = Lower(GetColumnName())
ls_cod = Trim(GetText())

Choose Case ls_col
   Case 'sdate' , 'edate' 
		If f_datechk(ls_cod ) < 1 Then
			f_message_chk(35 , '[처리일자]')
			this.setitem(1,ls_col,ls_null)
			Return 1
		End If
		
	Case 'itnbr'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'itnbr',ls_null)
			this.setitem(1,'itdsc',ls_null)
			Return 
		End If
		
		select itdsc into :ls_nam 
		  from ITEMAS
	 	 where itnbr = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'itdsc',ls_nam)
		else
			f_message_chk(33, "[품번]")
			this.setitem(1,'itnbr',ls_null)
			this.setitem(1,'itdsc',ls_null)
			return 1
		end if

	Case 'cvcod'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'cvnas',ls_null)
			Return 
		End If
		
		select cvnas into :ls_nam 
		  from vndmst
	 	 where cvcod = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'cvnas',ls_nam)
		else
			f_message_chk(33, "[거래처]")
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'cvnas',ls_null)
			return 1
		end if
End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;String ls_col

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
ls_col = Lower(GetColumnName())

Choose Case ls_col
	
	Case 'itnbr' 
		open(w_itemas_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)
	
	Case 'cvcod' 
		open(w_vndmst_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)
	
	
End Choose

end event

type dw_list from w_standard_print`dw_list within w_qa90_00530
integer x = 55
integer y = 316
integer width = 4498
integer height = 1892
integer taborder = 40
string dataobject = "d_qa90_00530_b"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type pb_1 from u_pb_cal within w_qa90_00530
integer x = 864
integer y = 60
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
If dw_ip.Object.sdate.protect = '1' Or dw_ip.Object.sdate.TabSequence = '0' Then Return

dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qa90_00530
integer x = 1353
integer y = 60
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
If dw_ip.Object.edate.protect = '1' Or dw_ip.Object.edate.TabSequence = '0' Then Return

dw_ip.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_qa90_00530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 304
integer width = 4521
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

