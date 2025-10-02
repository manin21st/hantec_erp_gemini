$PBExportHeader$w_imt_03600.srw
$PBExportComments$** 수입품의서
forward
global type w_imt_03600 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_03600
end type
type pb_2 from u_pic_cal within w_imt_03600
end type
type pb_3 from u_pic_cal within w_imt_03600
end type
type pb_4 from u_pic_cal within w_imt_03600
end type
end forward

global type w_imt_03600 from w_standard_print
integer height = 2548
string title = "수입품의서"
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
end type
global w_imt_03600 w_imt_03600

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string lc1, lc2, sopndat1, sopndat2, smagdat1, smagdat2, ssortgu, sprtgbn

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

lc1 = trim(dw_ip.object.lc1[1])
lc2 = trim(dw_ip.object.lc2[1])

sopndat1 = trim(dw_ip.object.opndat1[1])
sopndat2 = trim(dw_ip.object.opndat2[1])
smagdat1 = trim(dw_ip.object.magdat1[1])
smagdat2 = trim(dw_ip.object.magdat2[1])
ssortgu  = trim(dw_ip.object.sortgu[1])
sprtgbn  = trim(dw_ip.object.prtgbn[1])

if (IsNull(lc1) or lc1 = "")  then lc1 = "."
if (IsNull(lc2) or lc2 = "")  then lc2 = "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"

if (IsNull(sopndat1) or sopndat1 = "")  then sopndat1 = '10000101'
if (IsNull(sopndat2) or sopndat2 = "")  then sopndat2 = '99991231'

if (IsNull(smagdat1) or smagdat1 = "")  then smagdat1 = '10000101'
if (IsNull(smagdat2) or smagdat2 = "")  then smagdat2 = '99991231'

if (IsNull(ssortgu)  or ssortgu  = "")  then ssortgu  = 'zzzzzzzzzzzz'

// 미 마감L/C를 포함할경우에는 L/C마감일자는 무시한다.
If sPrtgbn = 'Y' then
	dw_list.dataobject = 'd_imt_03600_02_1'
	dw_print.dataobject = 'd_imt_03600_02_1_p'
Else
	dw_list.dataobject = 'd_imt_03600_02'	
	dw_print.dataobject = 'd_imt_03600_02_p'
End if
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

//if dw_list.Retrieve(gs_sabu, lc1, lc2, sopndat1, sopndat2, smagdat1, smagdat2, ssortgu) <= 0 then
//	f_message_chk(50,'[수입 품의서]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_list.Retrieve(gs_sabu, lc1, lc2, sopndat1, sopndat2, smagdat1, smagdat2, ssortgu) <= 0 then
	f_message_chk(50,'[수입 품의서]')
	dw_ip.Setfocus()
//	Return -1
END IF

return 1
end function

on w_imt_03600.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.pb_4
end on

on w_imt_03600.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
end on

event open;call super::open;dw_ip.setitem(1, "opndat1", left(f_today(), 6) + '01')
dw_ip.setitem(1, "opndat2", f_today())
dw_ip.setitem(1, "magdat1", left(f_today(), 6) + '01')
dw_ip.setitem(1, "magdat2", f_today())
end event

type dw_list from w_standard_print`dw_list within w_imt_03600
integer y = 392
integer width = 3489
integer height = 1964
string dataobject = "d_imt_03600_02"
end type

type cb_print from w_standard_print`cb_print within w_imt_03600
end type

type cb_excel from w_standard_print`cb_excel within w_imt_03600
end type

type cb_preview from w_standard_print`cb_preview within w_imt_03600
end type

type cb_1 from w_standard_print`cb_1 within w_imt_03600
end type

type dw_print from w_standard_print`dw_print within w_imt_03600
string dataobject = "d_imt_03600_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03600
integer y = 56
integer width = 3489
integer height = 296
string dataobject = "d_imt_03600_01"
end type

event dw_ip::rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

// lc번호
IF this.GetColumnName() = 'lc1'	THEN

	Open(w_lc_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1, "lc1",		gs_code)

ELSEIF this.GetColumnName() = 'lc2'	THEN

	Open(w_lc_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1, "lc2",		gs_code)

END IF


end event

type r_1 from w_standard_print`r_1 within w_imt_03600
integer y = 388
end type

type r_2 from w_standard_print`r_2 within w_imt_03600
integer height = 304
end type

type pb_1 from u_pic_cal within w_imt_03600
integer x = 1911
integer y = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('magdat1')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'magdat1', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_03600
integer x = 2373
integer y = 80
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('magdat2')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'magdat2', gs_code)



end event

type pb_3 from u_pic_cal within w_imt_03600
integer x = 1207
integer y = 80
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('opndat2')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'opndat2', gs_code)



end event

type pb_4 from u_pic_cal within w_imt_03600
integer x = 741
integer y = 80
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('opndat1')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'opndat1', gs_code)



end event

