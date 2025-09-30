$PBExportHeader$w_pdt_02820.srw
$PBExportComments$** 생산 실적 현황
forward
global type w_pdt_02820 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_02820
end type
type pb_2 from u_pb_cal within w_pdt_02820
end type
type rr_1 from roundrectangle within w_pdt_02820
end type
end forward

global type w_pdt_02820 from w_standard_print
string title = "생산 실적 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_pdt_02820 w_pdt_02820

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String s_frdate, s_todate, sgub1, sgub2, sgub3, sittyp

if dw_ip.AcceptText() = -1 then return -1

s_frdate = trim(dw_ip.GetItemString(1, "sdate"))
s_todate = trim(dw_ip.GetItemString(1, "edate"))
sgub1 = trim(dw_ip.GetItemString(1, "gub1")) //지시구분
sgub2 = trim(dw_ip.GetItemString(1, "gub2")) //생산팀from
sgub3 = trim(dw_ip.GetItemString(1, "gub3")) //생산팀 to
sittyp = trim(dw_ip.GetItemString(1, "ittyp")) //품목구분

IF s_frdate = "" OR IsNull(s_frdate) THEN 
	s_frdate = '10000101'
END IF
IF s_todate = "" OR IsNull(s_todate) THEN 
	s_todate = '99991231'
END IF

IF sgub1 = "" OR IsNull(sgub1) THEN 
	sgub1 = '%'
END IF

IF sgub2 = "" OR IsNull(sgub2) THEN 
	sgub2 = '.'
END IF

IF sgub3 = "" OR IsNull(sgub3) THEN 
	sgub3 = 'z'
END IF

IF sittyp = "" OR IsNull(sittyp) THEN 
	sittyp = '%'
END IF

if s_frdate > s_todate then 
	f_message_chk(34,'[기준일자]')
	dw_ip.Setcolumn('sdate')
	dw_ip.SetFocus()
	return -1
end if	

if sgub2 > sgub3 then 
	f_message_chk(34,'[생산팀]')
	dw_ip.Setcolumn('gub2')
	dw_ip.SetFocus()
	return -1
end if	

IF dw_print.Retrieve(gs_sabu, s_frdate, s_todate, sgub1, sgub2, sgub3, sittyp, gs_saupj) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setcolumn('sdate')
	dw_ip.Setfocus()
	return -1
end if
   
	dw_print.sharedata(dw_list)
return 1

end function

on w_pdt_02820.create
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

on w_pdt_02820.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, "sdate", left(f_today(), 6) + '01')
dw_ip.SetItem(1, "edate", f_today())
dw_ip.SetColumn("sdate")
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_02820
end type

type p_exit from w_standard_print`p_exit within w_pdt_02820
end type

type p_print from w_standard_print`p_print within w_pdt_02820
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02820
end type







type st_10 from w_standard_print`st_10 within w_pdt_02820
end type



type dw_print from w_standard_print`dw_print within w_pdt_02820
string dataobject = "d_pdt_02820_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02820
integer x = 50
integer y = 32
integer width = 3186
integer height = 188
string dataobject = "d_pdt_02820_a"
end type

event dw_ip::itemchanged;string  snull, sdate, sgub, s_name

setnull(snull)

IF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[기준일자 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[기준일자 TO]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'gub1' THEN
	sgub = this.gettext()
 
   IF sgub = "" OR IsNull(sgub) THEN RETURN
	
	s_name = f_get_reffer('60', sgub)
	IF	isnull(s_name) or s_name="" THEN
		f_message_chk(33,'[지시구분]')
		this.SetItem(1,'gub1', snull)
		return 1
   END IF	
ELSEIF this.GetColumnName() = 'gub2' THEN
	sgub = this.gettext()
 
   IF sgub = "" OR IsNull(sgub) THEN RETURN
	
	s_name = f_get_reffer('03', sgub)
	IF	isnull(s_name) or s_name="" THEN
		f_message_chk(33,'[생산팀구분]')
		this.SetItem(1,'gub2', snull)
		return 1
   END IF	
ELSEIF this.GetColumnName() = 'gub3' THEN
	sgub = this.gettext()
 
   IF sgub = "" OR IsNull(sgub) THEN RETURN
	
	s_name = f_get_reffer('03', sgub)
	IF	isnull(s_name) or s_name="" THEN
		f_message_chk(33,'[생산팀구분]')
		this.SetItem(1,'gub3', snull)
		return 1
   END IF		
ELSEIF this.GetColumnName() = 'ittyp' THEN
	sgub = this.gettext()
 
   IF sgub = "" OR IsNull(sgub) THEN RETURN
	
	s_name = f_get_reffer('05', sgub)
	IF	isnull(s_name) or s_name="" THEN
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		return 1
   END IF
ELSEIF this.GetColumnName() = 'prt' THEN
	If Trim(GetText()) = '1' Then
		dw_list.DataObject = 'd_pdt_02820_1'
		dw_print.DataObject = 'd_pdt_02820_1_p'
	Else
		dw_list.DataObject = 'd_pdt_02820_2'
		dw_print.DataObject = 'd_pdt_02820_2_p'
	End If
	dw_list.SetTransObject(sqlca)
	dw_print.SetTransObject(sqlca)
END IF
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02820
integer x = 82
integer y = 256
integer width = 4503
integer height = 2044
string dataobject = "d_pdt_02820_1"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_pdt_02820
integer x = 640
integer y = 48
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02820
integer x = 1102
integer y = 48
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_02820
long linecolor = 8388608
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 248
integer width = 4535
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

