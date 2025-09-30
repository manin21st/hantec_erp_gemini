$PBExportHeader$w_pdt_t_10230.srw
$PBExportComments$** 월 라인정지  현황
forward
global type w_pdt_t_10230 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_t_10230
end type
end forward

global type w_pdt_t_10230 from w_standard_print
string title = "월 라인정지 현황"
rr_1 rr_1
end type
global w_pdt_t_10230 w_pdt_t_10230

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
String sFrom,sTo,sGubn,snull,scodefrom, scodeto

setnull(snull)

sFrom       	= trim(dw_ip.GetItemString(1,"ntdat"))
sTo         		= trim(dw_ip.GetItemString(1,"ntdatto"))
scodeFrom   = trim(dw_ip.GetItemString(1,"jocod"))
scodeTo     	= trim(dw_ip.GetItemString(1,"jocodto"))

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

on w_pdt_t_10230.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_t_10230.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_t_10230
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_10230
end type

type p_print from w_standard_print`p_print within w_pdt_t_10230
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_10230
end type











type dw_print from w_standard_print`dw_print within w_pdt_t_10230
integer x = 3493
integer y = 92
string dataobject = "d_pdt_t_10230_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_10230
integer x = 78
integer y = 84
integer width = 2825
integer height = 100
string dataobject = "d_pdt_t_10230_1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "jocod"		THEN		
	gs_code = this.GetText()
	open(w_jomas_popup)
	if 	isnull(gs_code) or gs_code = "" 	Then 	return
	this.SetItem(1, "jocod", gs_code)
	this.SetItem(1, "jocodnm", gs_codename)
	
ELSEIF this.getcolumnname() = "jocodto"		THEN		
	gs_code = this.GetText()
	open(w_jomas_popup)
	if 	isnull(gs_code) or gs_code = "" 		then 	return
	this.SetItem(1, "jocodto", gs_code)
	this.SetItem(1, "jocodtonm", gs_codename)
END IF
end event

event dw_ip::itemchanged;string snull,  sjocod, sjonm, sjonm2
String sDateFrom,sDateTo 
int    ireturn 

SetNull(snull)

Choose Case this.GetColumnName() 
	Case 	"ntdat"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
		IF 	f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[발생일자기간]')
			this.SetItem(1,"ntdat",snull)
			Return 1
		END IF
	Case 	"ntdatto"
		sDateTo = Trim(this.GetText())
		IF 	sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
		IF 	f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[발생일자기간]')
			this.SetItem(1,"ntdatto",snull)
			Return 1
		END IF
	Case 	"jocod"
		sjocod = trim(this.gettext())
   		ireturn = f_get_name2('조', 'N', sjocod, sjonm, sjonm2)
		this.setitem(1, 'jocod', sjocod)
		this.setitem(1, 'jocodnm',  sjonm)
		return ireturn
	Case 	"jocodto"
		sjocod = trim(this.gettext())
   		ireturn = f_get_name2('조', 'N', sjocod, sjonm, sjonm2)
		this.setitem(1, 'jocodto', sjocod)
		this.setitem(1, 'jocodtonm',  sjonm)
		return ireturn
End Choose		

return
end event

type dw_list from w_standard_print`dw_list within w_pdt_t_10230
integer x = 82
integer y = 316
integer width = 4512
integer height = 1980
string dataobject = "d_pdt_t_10230_2"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_t_10230
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 308
integer width = 4535
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

