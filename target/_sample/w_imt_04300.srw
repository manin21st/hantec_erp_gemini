$PBExportHeader$w_imt_04300.srw
$PBExportComments$인수증미발급 현항--- YDK
forward
global type w_imt_04300 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_04300
end type
type pb_2 from u_pic_cal within w_imt_04300
end type
end forward

global type w_imt_04300 from w_standard_print
string title = "인수금 미발급 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_04300 w_imt_04300

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  ls_sudat_from, ls_sudat_to, ls_polcno, ls_itnbr1 , ls_itnbr2, ssaupj

if dw_ip.Accepttext() <> 1 then return -1

ls_sudat_from = trim(dw_ip.GetItemString(1,"sudat_from"))
ls_sudat_to   = trim(dw_ip.GetItemString(1,"sudat_to"))
ls_polcno     = dw_ip.GetItemString(1,"polcno")
ls_itnbr1     = dw_ip.GetItemString(1,"itnbr1")
ls_itnbr2     = dw_ip.GetItemString(1,"itnbr2")
ssaupj        = dw_ip.GetItemString(1,"saupj")

if ( IsNull(ls_itnbr1) or ls_itnbr1 = "" ) then ls_itnbr1 = "."
if ( IsNull(ls_itnbr2) or ls_itnbr2 = "" ) then ls_itnbr2 = "zzzzzzzzzzzzzzz"
if ( IsNull(ls_sudat_from) or ls_sudat_from ="" ) then ls_sudat_from = '10000101'
if ( IsNull(ls_sudat_to) or ls_sudat_to ="" ) then ls_sudat_to = '99991231'
if IsNull(ls_polcno) or ls_polcno="" then	ls_polcno = '%'

IF dw_print.retrieve( gs_sabu, ls_sudat_from, ls_sudat_to, ls_polcno, &
                     ls_itnbr1 , ls_itnbr2, ssaupj  ) < 1 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	Return -1
END IF

dw_print.object.sudat_f.text = string(ls_sudat_from, '@@@@.@@.@@')
dw_print.object.sudat_t.text = string(ls_sudat_to, '@@@@.@@.@@')

dw_print.ShareData(dw_list)

return 1

end function

on w_imt_04300.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_imt_04300.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;String ls_date

ls_date = f_today()

dw_ip.setItem(1,"sudat_from", left(ls_date,6) + '01' )
dw_ip.setItem(1,"sudat_to", ls_date)
f_mod_saupj(dw_ip, 'saupj')
end event

type dw_list from w_standard_print`dw_list within w_imt_04300
integer width = 3489
integer height = 1964
string dataobject = "d_imt_04300_2"
end type

type cb_print from w_standard_print`cb_print within w_imt_04300
end type

type cb_excel from w_standard_print`cb_excel within w_imt_04300
end type

type cb_preview from w_standard_print`cb_preview within w_imt_04300
end type

type cb_1 from w_standard_print`cb_1 within w_imt_04300
end type

type dw_print from w_standard_print`dw_print within w_imt_04300
string dataobject = "d_imt_04300_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04300
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_imt_04300"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String s_cod , snull , s_nam1 , s_nam2
Integer i_rtn

s_cod = Trim(this.gettext())

if this.getcolumnname() = 'itnbr1' then // 품번(from)
         i_rtn = f_get_name2("품번","N", s_cod , s_nam1, s_nam2 )
			this.setitem(1,"itnbr1",s_cod)
			this.setitem(1,"itdsc1",s_nam1)
			return i_rtn 
elseif this.getcolumnname() = 'itnbr2' then // 품번(to)
         i_rtn = f_get_name2("품번","N", s_cod , s_nam1, s_nam2 )
			this.setitem(1,"itnbr2",s_cod)
			this.setitem(1,"itdsc2",s_nam1)
			return i_rtn 
elseif this.getcolumnname() = 'sudat_from' then
	     if IsNull(s_cod) or s_cod = "" then return
		  if f_datechk(s_cod) = -1 then
			    f_message_chk(35,"[검사일자 FROM]")
				 this.object.sudat_from[1]=""
				 return 1
		  end if
elseif  this.getcolumnname() = 'sudat_to' then
	     if IsNull(s_cod) or s_cod= "" then return
		  if f_datechk(s_cod) = -1 then
			   f_message_chk(35,"[검사일자 TO]")
				this.object.sudat_to[1]="" 
				return 1
			end if
end if



end event

event dw_ip::rbuttondown;setNull(gs_gubun)
setNull(gs_code)
setNull(gs_codename)

IF this.GetColumnName() = 'polcno'	THEN

	gs_gubun = 'LOCAL'
	Open(w_lc_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1, "polcno",		gs_code)

ELSEif this.getcolumnname() = "itnbr1" then  
   open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
   this.setitem(1,"itnbr1",gs_code)
	this.setitem(1,"itdsc1",gs_codename)
elseif this.getcolumnname() = "itnbr2" then
   open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
   this.setitem(1,"itnbr2",gs_code)
	this.setitem(1,"itdsc2",gs_codename)
end if
	
end event

type r_1 from w_standard_print`r_1 within w_imt_04300
end type

type r_2 from w_standard_print`r_2 within w_imt_04300
end type

type pb_1 from u_pic_cal within w_imt_04300
integer x = 1454
integer y = 72
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sudat_from')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sudat_from', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_04300
integer x = 1879
integer y = 72
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sudat_to')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sudat_to', gs_code)



end event

