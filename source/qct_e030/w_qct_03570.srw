$PBExportHeader$w_qct_03570.srw
$PBExportComments$claim 처리결과 통보서
forward
global type w_qct_03570 from w_standard_print
end type
type cb_ruler from commandbutton within w_qct_03570
end type
type pb_1 from u_pb_cal within w_qct_03570
end type
type pb_2 from u_pb_cal within w_qct_03570
end type
type rr_2 from roundrectangle within w_qct_03570
end type
end forward

global type w_qct_03570 from w_standard_print
integer width = 4667
string title = "크레임 처리결과 통보서"
cb_ruler cb_ruler
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_qct_03570 w_qct_03570

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, s_itnbr, e_itnbr

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
s_itnbr = trim(dw_ip.object.s_itnbr[1])
e_itnbr = trim(dw_ip.object.e_itnbr[1])

if (IsNull(s_itnbr) or s_itnbr = "")  then s_itnbr = "."
if (IsNull(e_itnbr) or e_itnbr = "")  then e_itnbr = "ZZZZZZZZZZZZZZZ"
if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

IF dw_print.Retrieve(gs_sabu, sdate, edate, s_itnbr, e_itnbr) <= 0 then
	f_message_chk(50,'[크레임 처리결과 통보서]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_03570.create
int iCurrent
call super::create
this.cb_ruler=create cb_ruler
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ruler
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_2
end on

on w_qct_03570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_ruler)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_qct_03570
end type

type p_exit from w_standard_print`p_exit within w_qct_03570
end type

type p_print from w_standard_print`p_print within w_qct_03570
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_03570
end type

event p_retrieve::clicked;call super::clicked;//IF wf_retrieve() = -1 THEN
//	p_print.Enabled =False
//	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
//
//	//cb_ruler.Enabled = false
//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
//	SetPointer(Arrow!)
//	Return
//Else
//	p_print.Enabled =True
//	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
//	if wf_objectcheck() = 1 then
//		p_preview.enabled = true
//		p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
//      p_preview.triggerevent(clicked!)
//   else
//		p_preview.enabled = False
//		p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
//	end if
//	
//END IF
//dw_list.scrolltorow(1)
//SetPointer(Arrow!)



end event







type st_10 from w_standard_print`st_10 within w_qct_03570
end type



type dw_print from w_standard_print`dw_print within w_qct_03570
integer x = 3698
integer y = 20
string dataobject = "d_qct_03570_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03570
integer x = 46
integer y = 44
integer width = 3735
integer height = 168
string dataobject = "d_qct_03570"
end type

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2
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
elseif this.getcolumnname() = 's_itnbr' then //품번(FROM)  
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.s_itnbr[1] = s_cod
	this.object.s_itdsc[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'e_itnbr' then //품번(TO)  
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.e_itnbr[1] = s_cod
	this.object.e_itdsc[1] = s_nam1
	return i_rtn
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "s_itnbr"	THEN //품번(FROM)		
	open(w_itemas_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.object.s_itnbr[1] = gs_code
	this.object.s_itdsc[1] = gs_codename
ELSEIF this.getcolumnname() = "e_itnbr"	THEN //품번(TO)		
	open(w_itemas_popup)
	IF gs_code = '' or isnull(gs_code) then return 
   this.object.e_itnbr[1] = gs_code
	this.object.e_itdsc[1] = gs_codename
END IF
end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "s_itnbr"	THEN //품번(FROM)		
	   open(w_itemas_popup2)
	   this.SetItem(1, "s_itnbr", gs_code)
	   this.SetItem(1, "s_itdsc", gs_codename)
		return
   ELSEIF this.getcolumnname() = "e_itnbr" THEN //품번(TO)		
	   open(w_itemas_popup2)
	   this.SetItem(1, "e_itnbr", gs_code)
	   this.SetItem(1, "e_itdsc", gs_codename)
		return
   END IF
END IF  
end event

type dw_list from w_standard_print`dw_list within w_qct_03570
integer x = 55
integer y = 220
integer width = 4539
integer height = 2052
string dataobject = "d_qct_03570_01"
boolean border = false
end type

type cb_ruler from commandbutton within w_qct_03570
boolean visible = false
integer x = 3598
integer y = 124
integer width = 402
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "cb_ruler"
end type

type pb_1 from u_pb_cal within w_qct_03570
integer x = 631
integer y = 68
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03570
integer x = 1097
integer y = 68
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type rr_2 from roundrectangle within w_qct_03570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 212
integer width = 4562
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

