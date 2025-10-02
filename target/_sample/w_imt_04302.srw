$PBExportHeader$w_imt_04302.srw
$PBExportComments$인수증 발급현황 --- YDK
forward
global type w_imt_04302 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_04302
end type
type pb_2 from u_pic_cal within w_imt_04302
end type
end forward

global type w_imt_04302 from w_standard_print
string title = "인수증 발급 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_04302 w_imt_04302

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_polcno , ls_poblno , ls_cvcod1,  ls_entdat_from , ls_entdat_to, ssaupj

if dw_ip.Accepttext() = -1 then return -1

ls_polcno = dw_ip.GetItemstring(1, "polcno")
ls_poblno = dw_ip.GetItemstring(1, "poblno")
ls_cvcod1 = dw_ip.GetItemstring(1, "cvcod1")
ls_entdat_from = trim(dw_ip.GetItemstring(1,"entdat_from"))
ls_entdat_to = trim(dw_ip.GetItemstring(1, "entdat_to" ))
ssaupj = dw_ip.GetItemstring(1, "saupj" )

if (IsNull(ls_polcno) or ls_polcno= "" ) then
	ls_polcno = '%'
else
	ls_polcno = ls_polcno + '%'
end if
if (IsNull(ls_poblno) or ls_poblno="" ) then 
	ls_poblno = '%'
else
	ls_poblno = ls_poblno + '%'
end if

if (IsNull(ls_cvcod1) or ls_cvcod1 = "" ) then ls_cvcod1 = '%'

if (IsNull(ls_entdat_from) or ls_entdat_from = "" ) then ls_entdat_from = '19000101'
if (IsNull(ls_entdat_to) or ls_entdat_to = "" ) then ls_entdat_to = '30001231'

IF dw_print.Retrieve(gs_sabu, ls_polcno, ls_poblno, ls_cvcod1, ls_entdat_from, &
                    ls_entdat_to, ssaupj) < 1 then
   f_message_chk(50,'')
	dw_ip.Setfocus()
	Return -1
END IF

dw_print.object.entdat_from.text = string(ls_entdat_from , '@@@@.@@.@@' ) 
dw_print.object.entdat_to.text = String(ls_entdat_to , '@@@@.@@.@@' ) 

dw_print.ShareData(dw_list)

RETURN 1

end function

on w_imt_04302.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_imt_04302.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;String  ls_date

ls_date = f_today()

dw_ip.SetItem(1,"entdat_from" , left(ls_date, 6) + '01')
dw_ip.SetItem(1,"entdat_to" , ls_date ) 
f_mod_saupj(dw_ip, 'saupj')
end event

type dw_list from w_standard_print`dw_list within w_imt_04302
integer width = 3489
integer height = 1964
string dataobject = "d_imt_04302_1"
end type

type cb_print from w_standard_print`cb_print within w_imt_04302
end type

type cb_excel from w_standard_print`cb_excel within w_imt_04302
end type

type cb_preview from w_standard_print`cb_preview within w_imt_04302
end type

type cb_1 from w_standard_print`cb_1 within w_imt_04302
end type

type dw_print from w_standard_print`dw_print within w_imt_04302
string dataobject = "d_imt_04302_1_P"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04302
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_imt_04302"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string scod ,  snam1 ,  snam2 , snull
Integer li_return

setnull(snull)

scod = this.gettext()

if this.GetColumnName() = 'entdat_from' then
   if IsNull(scod) or scod = "" then return
	if f_datechk(scod) = -1 then
      f_message_chk(35,"[인수일자 FROM]")
		this.setitem(1,'entdat_from' , snull)
		return 1
	end if
elseif this.GetColumnName() = 'entdat_to' then
   if IsNull(scod) or scod = "" then return
	if f_datechk(scod) = -1 then
      f_message_chk(35,"[인수일자 TO]")
		this.setitem(1,'entdat_to' , snull)
		return 1
	end if
elseif this.GetcolumnName() = "cvcod1" then
	li_return = f_get_name2('V1','Y', scod, snam1, snam2 )
	this.setitem(1,"cvcod1", scod)
	this.setitem(1,"cvnam1", snam1)
	return 1
end if

end event

event dw_ip::rbuttondown;setNull(gs_code)
setNull(gs_codename)
setNull(gs_gubun)

if this.GetColumnName() = 'cvcod1' then
	open (w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	setitem(1,"cvcod1",gs_code)
	setitem(1,"cvnam1", gs_codename)
ELSEIF this.GetColumnName() = 'polcno'	THEN

	gs_gubun = 'LOCAL'
	Open(w_lc_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1, "polcno",		gs_code)

ELSEIF this.GetColumnName() = 'poblno'	THEN

	Open(w_bl_popup2)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1, "poblno",		gs_code)

END IF




end event

type r_1 from w_standard_print`r_1 within w_imt_04302
end type

type r_2 from w_standard_print`r_2 within w_imt_04302
end type

type pb_1 from u_pic_cal within w_imt_04302
integer x = 2537
integer y = 156
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('entdat_from')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'entdat_from', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_04302
integer x = 2999
integer y = 156
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('entdat_to')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'entdat_to', gs_code)



end event

