$PBExportHeader$w_imt_04301.srw
$PBExportComments$인수증출력 --- YDK
forward
global type w_imt_04301 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_04301
end type
type pb_2 from u_pic_cal within w_imt_04301
end type
type pb_3 from u_pic_cal within w_imt_04301
end type
end forward

global type w_imt_04301 from w_standard_print
string title = "인수증"
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
end type
global w_imt_04301 w_imt_04301

forward prototypes
public function integer wf_retrieve ()
public function integer wf_objectcheck ()
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

public function integer wf_objectcheck ();//현재 출력물의 상태(preview = yes이면 검색대상기능을 제한한다)
is_preview = 'yes'

String sobject

Setnull(sObject)

sObject = dw_list.dataobject

if isnull(sObject) or trim(sObject) = '' or not dw_list.visible then
	return -1
else
	is_preview = dw_list.object.datawindow.print.preview
end if

if is_preview = 'yes' then return -1

// menu의 window를 check하여 0이면 skip하고 0보다 크면 horizontalscroll을 사용
integer ipoint
String sWindow, sFindyn
sWindow = string(this)

Setnull(sfindyn)
ipoint = 0

ipoint = 0
select hpoint, findyn into :ipoint, :sfindyn from sub2_t
 where window_name = :sWindow;
 
if isnull(sfindyn) Or trim(sfindyn) = '' Or sfindyn = 'N' then
	if is_preview = 'yes' then
		return -1
	end if
end if
 
//em_split.text = string(ipoint)
//
//if ipoint > 0 then
//	dw_list.object.datawindow.horizontalscrollsplit			=	ipoint
//	dw_list.object.datawindow.horizontalscrollposition2	= 	ipoint
//end if
//
String this_class[]
windowobject the_object[]

integer i, cnt

For i = 1 to upperbound(control[])
	the_object[i]	=	control[i]
	this_class[i]	=	the_object[i].classname()
Next

// 출력window에 tabl이 있는지 검색하여 있으면 -1을 return
// 다음의 내역은 검색대상에서 제외한다.
// window내에 object을 생성시 필히 nameing rule을 지킬 것
// ln_(Line), r_(Rectangle), rr_(RoundRectangle), oval_(Oval)

dragobject temp

cnt = upperbound(this.control)
for i = cnt to 1 step -1
	if Left(this_class[i], 3) = 'ln_' 	or &
		Left(this_class[i], 2) = 'r_' 		or &	
		Left(this_class[i], 3) = 'rr_' 	or &	
		Left(this_class[i], 5) = 'oval_' 	Then	Continue
		
	Temp	=	this.control[i]
	
	Choose Case TypeOf(temp)
			 Case tab!
					is_preview = 'yes'
					return -1
	End choose
Next

//em_split.enabled = true

return 1
end function

on w_imt_04301.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
end on

on w_imt_04301.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
end on

event open;call super::open;String ls_date

ls_date = f_today()

dw_ip.setItem(1,"entdat_from", left(ls_date,6) + '01' )
dw_ip.setItem(1,"entdat_to", ls_date)
dw_ip.setItem(1,"stoday", ls_date)
f_mod_saupj(dw_ip, 'saupj')
end event

type dw_list from w_standard_print`dw_list within w_imt_04301
integer width = 3489
integer height = 1964
string dataobject = "d_imt_04301_2"
end type

event dw_list::constructor;
dw_list.object.datawindow.print.preview = "yes"


if wf_objectcheck() = -1 then
	is_preview = 'yes'
end if

end event

type cb_print from w_standard_print`cb_print within w_imt_04301
integer y = 2436
end type

type cb_excel from w_standard_print`cb_excel within w_imt_04301
integer y = 2436
end type

type cb_preview from w_standard_print`cb_preview within w_imt_04301
integer y = 2436
end type

type cb_1 from w_standard_print`cb_1 within w_imt_04301
integer y = 2436
end type

type dw_print from w_standard_print`dw_print within w_imt_04301
string dataobject = "d_imt_04301_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04301
integer y = 56
integer width = 3489
integer height = 188
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

type r_1 from w_standard_print`r_1 within w_imt_04301
end type

type r_2 from w_standard_print`r_2 within w_imt_04301
end type

type pb_1 from u_pic_cal within w_imt_04301
integer x = 2843
integer y = 72
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

type pb_2 from u_pic_cal within w_imt_04301
integer x = 3314
integer y = 72
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

type pb_3 from u_pic_cal within w_imt_04301
integer x = 2843
integer y = 156
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('stoday')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'stoday', gs_code)



end event

