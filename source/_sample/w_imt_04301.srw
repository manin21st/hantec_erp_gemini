$PBExportHeader$w_imt_04301.srw
$PBExportComments$인수증출력 --- YDK
forward
global type w_imt_04301 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_04301
end type
type pb_2 from u_pb_cal within w_imt_04301
end type
type pb_3 from u_pb_cal within w_imt_04301
end type
type rr_1 from roundrectangle within w_imt_04301
end type
end forward

global type w_imt_04301 from w_standard_print
string title = "인수증"
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
rr_1 rr_1
end type
global w_imt_04301 w_imt_04301

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  ls_poblno , ls_polcno , ls_cvcod1,  ls_entdat_from , ls_entdat_to , sToday, ssaupj

if dw_ip.Accepttext() = -1 then return -1

ls_poblno = dw_ip.GetItemstring(1, "poblno")
ls_polcno = dw_ip.GetItemstring(1, "polcno")
ls_cvcod1 = dw_ip.GetItemstring(1, "cvcod1")
ls_entdat_from = trim(dw_ip.GetItemstring(1,"entdat_from"))
ls_entdat_to = trim(dw_ip.GetItemstring(1, "entdat_to" ))
stoday    = trim(dw_ip.GetItemstring(1, "stoday" ))
ssaupj        = dw_ip.GetItemString(1,"saupj")


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

if (IsNull(ls_entdat_from) or ls_entdat_from = "" ) then ls_entdat_from = '.'
if (IsNull(ls_entdat_to) or ls_entdat_to = "" ) then ls_entdat_to = 'zzzzzzzz'
if (IsNull(stoday) or stoday = "" ) then stoday = f_today()

//if dw_list.retrieve(gs_sabu, ls_poblno, ls_polcno , ls_cvcod1, ls_entdat_from , &
//                    ls_entdat_to, stoday,  ssaupj ) < 1 then
//   f_message_chk(50,'')
//	dw_ip.setcolumn('poblno')
//	dw_ip.setfocus()
//	return -1
//end if

IF dw_print.retrieve(gs_sabu, ls_poblno, ls_polcno , ls_cvcod1, ls_entdat_from , &
                    ls_entdat_to, stoday,  ssaupj ) < 1 then
   f_message_chk(50,'')
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
	

end function

on w_imt_04301.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.rr_1
end on

on w_imt_04301.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.rr_1)
end on

event open;call super::open;String ls_date

ls_date = f_today()

dw_ip.setItem(1,"entdat_from", left(ls_date,6) + '01' )
dw_ip.setItem(1,"entdat_to", ls_date)
dw_ip.setItem(1,"stoday", ls_date)
f_mod_saupj(dw_ip, 'saupj')
end event

type p_preview from w_standard_print`p_preview within w_imt_04301
end type

type p_exit from w_standard_print`p_exit within w_imt_04301
end type

type p_print from w_standard_print`p_print within w_imt_04301
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04301
end type







type st_10 from w_standard_print`st_10 within w_imt_04301
end type



type dw_print from w_standard_print`dw_print within w_imt_04301
string dataobject = "d_imt_04301_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04301
integer x = 37
integer y = 12
integer width = 3739
integer height = 204
string dataobject = "d_imt_04301"
end type

event dw_ip::itemchanged;string scod ,  snam1 ,  snam2 , snull
Integer li_return

setnull(snull)

scod = trim(this.gettext())

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
elseif this.GetColumnName() = 'stoday' then
   if IsNull(scod) or scod = "" then return
	if f_datechk(scod) = -1 then
      f_message_chk(35,"[발급일자]")
		this.setitem(1, 'stoday', snull)
		return 1
	end if
elseif this.GetcolumnName() = "cvcod1" then
	li_return = f_get_name2('V1','Y', scod, snam1, snam2 )
	this.setitem(1,"cvcod1", scod)
	this.setitem(1,"cvnam1", snam1)
	return li_return
end if

end event

event dw_ip::itemerror;return 1

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

type dw_list from w_standard_print`dw_list within w_imt_04301
integer x = 59
integer y = 244
integer width = 4512
integer height = 2060
string dataobject = "d_imt_04301_2"
boolean border = false
end type

event dw_list::constructor;
dw_list.object.datawindow.print.preview = "yes"


if wf_objectcheck() = -1 then
	is_preview = 'yes'
end if

end event

type pb_1 from u_pb_cal within w_imt_04301
integer x = 2843
integer y = 24
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

type pb_2 from u_pb_cal within w_imt_04301
integer x = 3314
integer y = 24
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

type pb_3 from u_pb_cal within w_imt_04301
integer x = 2843
integer y = 108
integer taborder = 50
boolean bringtotop = true
integer weight = 700
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('stoday')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'stoday', gs_code)



end event

type rr_1 from roundrectangle within w_imt_04301
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 232
integer width = 4544
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

