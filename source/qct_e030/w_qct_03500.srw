$PBExportHeader$w_qct_03500.srw
$PBExportComments$VOC 등록 현황
forward
global type w_qct_03500 from w_standard_print
end type
type pb_2 from u_pb_cal within w_qct_03500
end type
type pb_1 from u_pb_cal within w_qct_03500
end type
type rr_2 from roundrectangle within w_qct_03500
end type
end forward

global type w_qct_03500 from w_standard_print
string title = "VOC 등록 현황"
pb_2 pb_2
pb_1 pb_1
rr_2 rr_2
end type
global w_qct_03500 w_qct_03500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, itnbr1, itnbr2, wongu, won1, won2, gubun
dw_list.reset()
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
wongu  = trim(dw_ip.object.wongu[1])
gubun  = trim(dw_ip.object.gubun[1])

if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

if (IsNull(wongu) or wongu = "") then 
	wongu = "%"
else
	wongu = wongu + "%"
end if	

if (IsNull(gubun) or gubun = "") then 
	gubun = "%"
end if

if wongu = "%" then
   won1 = "ALL"
   won2 = "ALL"
else
	select r1.rfna1, r2.rfna1 into :won1, :won2
	  from reffpf r1, reffpf r2
    where r1.rfcod = '58'
      and r1.rfgub = substr(:wongu,1,1)
		and r2.rfcod = '13'
      and r2.rfgub = substr(:wongu,1,6);
		
	if IsNull(won1) or won1 = "" then won1 = "*"
	if IsNull(won2) or won2 = "" then won2 = "*"
end if		

dw_list.SetRedraw(false)

IF dw_print.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2, wongu, gubun) <= 0 then
	f_message_chk(50,'[VOC 등록현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	Return -1
END IF

//dw_print.insertrow(0)
dw_print.object.txt_won.text = won1 + " - " + won2
dw_print.object.txt_ymd.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")

dw_print.ShareData(dw_list)

dw_list.SetRedraw(true)	

return 1
end function

on w_qct_03500.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_qct_03500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1,'gubun','10')
f_child_wongu(dw_ip, 'wongu', '10')
end event

type p_preview from w_standard_print`p_preview within w_qct_03500
end type

type p_exit from w_standard_print`p_exit within w_qct_03500
end type

type p_print from w_standard_print`p_print within w_qct_03500
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_03500
end type







type st_10 from w_standard_print`st_10 within w_qct_03500
end type



type dw_print from w_standard_print`dw_print within w_qct_03500
string dataobject = "d_qct_03500_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03500
integer x = 0
integer y = 20
integer width = 3319
integer height = 236
string dataobject = "d_qct_03500_01"
end type

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif (this.GetColumnName() = "gubun") Then //원인 그룹
	if IsNull(s_cod) or s_cod = "" then return

   f_child_wongu(this, 'wongu', s_cod)	
elseif this.getcolumnname() = 'itnbr1' then //품번(FROM)  
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itnbr2' then //품번(TO)  
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn
end if

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "itnbr1"	THEN //품번(FROM)		
	open(w_itemas_popup)
	this.object.itnbr1[1] = gs_code
	this.object.itdsc1[1] = gs_codename
	return
ELSEIF this.getcolumnname() = "itnbr2"	THEN //품번(TO)		
	open(w_itemas_popup)
   this.object.itnbr2[1] = gs_code
	this.object.itdsc2[1] = gs_codename
	return
END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "itnbr1"	THEN //품번(FROM)		
	   open(w_itemas_popup2)
	   this.SetItem(1, "itnbr1", gs_code)
	   this.SetItem(1, "itdsc1", gs_codename)
		return
   ELSEIF this.getcolumnname() = "itnbr2" THEN //품번(TO)		
	   open(w_itemas_popup2)
	   this.SetItem(1, "itnbr2", gs_code)
	   this.SetItem(1, "itdsc2", gs_codename)
		return
   END IF
END IF  
end event

type dw_list from w_standard_print`dw_list within w_qct_03500
integer x = 64
integer y = 284
integer width = 4530
integer height = 2052
string dataobject = "d_qct_03500_02"
boolean border = false
end type

type pb_2 from u_pb_cal within w_qct_03500
integer x = 1111
integer y = 40
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type pb_1 from u_pb_cal within w_qct_03500
integer x = 640
integer y = 40
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type rr_2 from roundrectangle within w_qct_03500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 272
integer width = 4562
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

