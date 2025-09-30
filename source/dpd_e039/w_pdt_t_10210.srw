$PBExportHeader$w_pdt_t_10210.srw
$PBExportComments$** 비가동 요인 원인 현황
forward
global type w_pdt_t_10210 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_t_10210
end type
type pb_2 from u_pb_cal within w_pdt_t_10210
end type
type rr_1 from roundrectangle within w_pdt_t_10210
end type
end forward

global type w_pdt_t_10210 from w_standard_print
string title = "비가동 요인 원인 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_pdt_t_10210 w_pdt_t_10210

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
String sFrom,sTo,sGubn,snull,scodefrom, scodeto

setnull(snull)

sFrom       	= trim(dw_ip.GetItemString(1,"ntdat"))
sTo         		= trim(dw_ip.GetItemString(1,"ntdatto"))
scodeFrom   = trim(dw_ip.GetItemString(1,"pdtgu"))
scodeTo     	= trim(dw_ip.GetItemString(1,"pdtguto"))

IF 	sFrom ="" OR IsNull(sFrom) THEN sfrom = '10000101'

IF 	sTo ="" OR IsNull(sTo) THEN  sto = '99991231'

IF 	scodeFrom = "" OR isnull(scodeFrom) THEN
  	SELECT MIN("REFFPF"."RFGUB")  
	    	INTO :scodeFrom  
  	 	FROM "REFFPF"  
	   	WHERE ( "REFFPF"."SABU" = :gs_sabu ) AND  
            ( "REFFPF"."RFCOD" = '03' )   ;
END IF

IF 	scodeTo = "" OR isnull(scodeTo) THEN
	SELECT MAX("REFFPF"."RFGUB")  
	    	INTO :scodeTo  
  	 	FROM "REFFPF"  
	   	WHERE ( "REFFPF"."SABU" = :gs_sabu ) AND  
            ( "REFFPF"."RFCOD" = '03' )   ;
END IF	

IF	( scodeFrom > scodeTo  )	  then
	MessageBox("확인","생산팀의 범위를 확인하세요!")
	dw_ip.setcolumn('pdtgu')
	dw_ip.setfocus()
	Return -1
END IF


IF 	dw_print.Retrieve(gs_sabu,sFrom,sTo,scodefrom,scodeto) <=0 THEN
	f_message_chk(50,'')
   	dw_ip.setcolumn('ntdat')
	dw_ip.SetFocus()
	Return -1
END IF
   
dw_print.sharedata(dw_list)
Return 1




end function

on w_pdt_t_10210.create
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

on w_pdt_t_10210.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_t_10210
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_10210
end type

type p_print from w_standard_print`p_print within w_pdt_t_10210
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_10210
end type











type dw_print from w_standard_print`dw_print within w_pdt_t_10210
integer x = 3493
integer y = 92
string dataobject = "d_pdt_t_10210_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_10210
integer x = 78
integer y = 84
integer width = 2866
integer height = 156
string dataobject = "d_pdt_t_10210_1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "fr_jocod"	THEN		
	gs_code = this.GetText()
	open(w_jomas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "fr_jocod", gs_code)
	this.SetItem(1, "fr_jonm", gs_codename)
ELSEIF this.getcolumnname() = "to_jocod"	THEN		
	gs_code = this.GetText()
	open(w_jomas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "to_jocod", gs_code)
	this.SetItem(1, "to_jonm", gs_codename)
END IF
end event

event dw_ip::itemchanged;string snull, syymm, sjocod, sjonm, sjonm2, sdate
String sDateFrom,sDateTo 
int    ireturn 

SetNull(snull)

IF this.GetColumnName() = "ntdat" THEN
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[발생일자기간]')
		this.SetItem(1,"ntdat",snull)
		Return 1
	END IF
elseIF this.GetColumnName() = "ntdatto" THEN
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[발생일자기간]')
		this.SetItem(1,"ntdatto",snull)
		Return 1
	END IF
elseIF this.GetColumnName() ="syymm" THEN
	syymm = trim(this.GetText())
	if syymm = "" or isnull(syymm) then	return 
  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "fr_jocod"	THEN
	sjocod = trim(this.gettext())
   ireturn = f_get_name2('조', 'N', sjocod, sjonm, sjonm2)
	this.setitem(1, 'fr_jocod', sjocod)
	this.setitem(1, 'fr_jonm',  sjonm)
	return ireturn
ELSEIF this.GetColumnName() = "to_jocod"	THEN
	sjocod = trim(this.gettext())
   ireturn = f_get_name2('조', 'N', sjocod, sjonm, sjonm2)
	this.setitem(1, 'to_jocod', sjocod)
	this.setitem(1, 'to_jonm',  sjonm)
	return ireturn
ELSEIF this.GetColumnName() = "sdate"	THEN	
	sdate = trim(this.gettext())
	if sdate = "" or isnull(sdate) then	return 
  	IF f_datechk(sdate + '0101') = -1	then
      f_message_chk(35, '[기준년도]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
END IF 

return
end event

type dw_list from w_standard_print`dw_list within w_pdt_t_10210
integer x = 82
integer y = 260
integer width = 4512
integer height = 2044
string dataobject = "d_pdt_t_10210_2"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_pdt_t_10210
integer x = 704
integer y = 112
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('ntdat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'ntdat', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_t_10210
integer x = 1147
integer y = 112
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('ntdatto')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'ntdatto', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_t_10210
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 252
integer width = 4535
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

