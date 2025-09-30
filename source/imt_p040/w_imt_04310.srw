$PBExportHeader$w_imt_04310.srw
$PBExportComments$수입선급금 현황
forward
global type w_imt_04310 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_04310
end type
type pb_2 from u_pb_cal within w_imt_04310
end type
type rr_2 from roundrectangle within w_imt_04310
end type
end forward

global type w_imt_04310 from w_standard_print
string title = "수입 선급금 현황"
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_imt_04310 w_imt_04310

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_polcno, ls_setno,  sfdate , stdate

if dw_ip.Accepttext() = -1 then return -1

ls_polcno = dw_ip.GetItemstring(1, "lcno")
ls_setno  = dw_ip.GetItemstring(1, "setno")
sfdate    = trim(dw_ip.GetItemstring(1, "fdate"))
stdate    = trim(dw_ip.GetItemstring(1, "tdate" ))

if (IsNull(ls_polcno) or ls_polcno= "" ) then
	ls_polcno = '%'
else
	ls_polcno = ls_polcno + '%'
end if
if (IsNull(ls_setno) or ls_setno="" ) then 
	ls_setno = '%'
else
	ls_setno = ls_setno + '%'
end if

if (IsNull(sfdate) or sfdate = "" ) then sfdate = '10000101'
if (IsNull(stdate) or stdate = "" ) then stdate = '99991231'

IF dw_print.retrieve(gs_sabu, sfdate, stdate, ls_setno, ls_polcno) < 1 then
   f_message_chk(50,'')
	dw_ip.Setfocus()
	Return -1
END IF

dw_print.ShareData(dw_list)

RETURN 1

end function

on w_imt_04310.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_2
end on

on w_imt_04310.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,"fdate" , left(is_today, 6) + '01')
dw_ip.SetItem(1,"tdate" , is_today ) 
end event

type p_preview from w_standard_print`p_preview within w_imt_04310
end type

type p_exit from w_standard_print`p_exit within w_imt_04310
end type

type p_print from w_standard_print`p_print within w_imt_04310
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04310
end type







type st_10 from w_standard_print`st_10 within w_imt_04310
end type



type dw_print from w_standard_print`dw_print within w_imt_04310
string dataobject = "d_imt_04310_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04310
integer x = 18
integer y = 40
integer width = 3099
integer height = 160
string dataobject = "d_imt_04310"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string scod ,  snam1 ,  snam2 , snull
Integer li_return

setnull(snull)

scod = trim(this.gettext())

if this.GetColumnName() = 'fdate' then
   if IsNull(scod) or scod = "" then return
	if f_datechk(scod) = -1 then
      f_message_chk(35,"[결제일자 FROM]")
		this.setitem(1,'fdate' , snull)
		return 1
	end if
elseif this.GetColumnName() = 'tdate' then
   if IsNull(scod) or scod = "" then return
	if f_datechk(scod) = -1 then
      f_message_chk(35,"[결제일자 TO]")
		this.setitem(1,'tdate' , snull)
		return 1
	end if
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
ELSEIF this.GetColumnName() = 'lcno'	THEN
	
	gs_gubun = 'LOCAL'
   
	Open(w_lc_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "lcno", gs_code)
// 구매결제번호
ELSEIF this.GetColumnName() = 'setno'	THEN
	  
	Open(w_polcsethd_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "setno", gs_code)
END IF




end event

type dw_list from w_standard_print`dw_list within w_imt_04310
integer x = 32
integer y = 228
integer width = 4567
integer height = 2064
string dataobject = "d_imt_04310_1"
boolean border = false
end type

type pb_1 from u_pb_cal within w_imt_04310
integer x = 599
integer y = 60
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('fdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'fdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_04310
integer x = 1065
integer y = 60
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('tdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'tdate', gs_code)



end event

type rr_2 from roundrectangle within w_imt_04310
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 220
integer width = 4585
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

