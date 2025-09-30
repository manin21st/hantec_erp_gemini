$PBExportHeader$w_pdt_04540.srw
$PBExportComments$** ±¸¸Å ÀÇ·Ú¼­
forward
global type w_pdt_04540 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_04540
end type
type rr_2 from roundrectangle within w_pdt_04540
end type
end forward

global type w_pdt_04540 from w_standard_print
string title = "±¸¸Å ÀÇ·Ú¼­"
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_04540 w_pdt_04540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cod, sgubun, fdate, tdate, sempno

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sgubun = dw_ip.object.gubun[1]

if sgubun = '1' then //ÀÇ·Ú¹øÈ£º° 
	cod = trim(dw_ip.object.cod[1])
	if (IsNull(cod) or cod = "")  then
		f_message_chk(30, "[ÀÇ·Ú¹øÈ£]")
		dw_ip.SetColumn("cod")
		dw_ip.SetFocus()
		return -1
	else
		cod = cod + "%"
	end if
	
	dw_list.DataObject = 'd_pdt_04540_02'
	dw_print.DataObject = 'd_pdt_04540_02_p'
	dw_print.settransobject(sqlca)

	if dw_print.Retrieve(gs_sabu, cod) <= 0 then
		f_message_chk(50,'[±¸¸Å ÀÇ·Ú¼­]')
		dw_ip.SetColumn("cod")
		dw_ip.SetFocus()
		return -1
	end if
	dw_print.sharedata(dw_list)
else
	sempno = trim(dw_ip.object.empno[1])
	if (IsNull(sempno) or sempno = "")  then
		sempno = '%'
	end if
	
	fdate = trim(dw_ip.object.fdate[1])
	if (IsNull(fdate) or fdate = "")  then
		f_message_chk(30, "[ÀÇ·ÚÀÏÀÚ]")
		dw_ip.SetColumn("fdate")
		dw_ip.SetFocus()
		return -1
	end if
//	tdate = trim(dw_ip.object.tdate[1])
//	if (IsNull(tdate) or tdate = "")  then
//		f_message_chk(30, "[ÀÇ·ÚÀÏÀÚ]")
//		dw_ip.SetColumn("tdate")
//		dw_ip.SetFocus()
//		return -1
//	end if

	dw_list.DataObject = 'd_pdt_04540_03'
	dw_print.DataObject = 'd_pdt_04540_03_p'
	dw_print.settransobject(sqlca)
	
	if dw_print.Retrieve(gs_sabu, sempno, fdate) <= 0 then
		f_message_chk(50,'[±¸¸Å ÀÇ·Ú¼­]')
		dw_ip.SetColumn("empno")
		dw_ip.SetFocus()
		return -1
	end if
	dw_print.sharedata(dw_list)
end if
return 1
end function

on w_pdt_04540.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pdt_04540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.setitem(1, 'fdate', is_today)
dw_ip.setitem(1, 'tdate', is_today)
end event

type p_preview from w_standard_print`p_preview within w_pdt_04540
end type

type p_exit from w_standard_print`p_exit within w_pdt_04540
end type

type p_print from w_standard_print`p_print within w_pdt_04540
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_04540
end type







type st_10 from w_standard_print`st_10 within w_pdt_04540
end type



type dw_print from w_standard_print`dw_print within w_pdt_04540
string dataobject = "d_pdt_04540_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_04540
integer x = 55
integer y = 44
integer width = 3191
integer height = 116
string dataobject = "d_pdt_04540_01"
end type

event dw_ip::rbuttondown;gs_code = ''
gs_codename = ''

// ºÎ¼­
IF this.getcolumnname() = "cod" 	then
	
	gs_Gubun = '1'
	open(w_estima_popup)
	
	if isnull(gs_code)  or  gs_code = ''	then	return
	
	this.setitem(1, "cod", Left(gs_code,12))
	
elseIF this.GetColumnName() = 'empno'	THEN

	Open(w_sawon_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(1,"empno",gs_code)
	SetItem(1,"empnm",gs_codename)

end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;string	sNull,  sCode,  sName, sname2
int      ireturn 

SetNull(sNull)

IF this.GetColumnName() = "empno" THEN
	sCode = this.GetText()
	
   ireturn = f_get_name2('»ç¹ø', 'Y', scode, sname, sname2)	 
	this.setitem(1, "empno",   scode)
	this.setitem(1, "empnm", sname)
   return ireturn 	 
ELSEIF this.GetColumnName() = 'fdate' THEN
	scode  = TRIM(this.gettext())
	IF scode = '' or isnull(scode) then return 

	IF f_datechk(scode) = -1	then
		this.setitem(1, "fdate", sNull)
		return 1
	END IF

ELSEIF this.GetColumnName() = 'tdate' THEN
	scode  = TRIM(this.gettext())
	IF scode = '' or isnull(scode) then return 

	IF f_datechk(scode) = -1	then
		this.setitem(1, "tdate", sNull)
		return 1
	END IF

END IF


end event

type dw_list from w_standard_print`dw_list within w_pdt_04540
integer x = 55
integer y = 212
integer width = 4549
integer height = 2108
string dataobject = "d_pdt_04540_03"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_04540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 32
integer width = 3406
integer height = 132
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pdt_04540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 196
integer width = 4571
integer height = 2124
integer cornerheight = 40
integer cornerwidth = 46
end type

