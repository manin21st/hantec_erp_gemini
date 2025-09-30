$PBExportHeader$w_pdm_11760.srw
$PBExportComments$표준원가 현황
forward
global type w_pdm_11760 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_11760
end type
end forward

global type w_pdm_11760 from w_standard_print
string tag = "사전원가계산 조회/출력"
string title = "표준원가계산서"
rr_1 rr_1
end type
global w_pdm_11760 w_pdm_11760

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string from_itnbr, to_itnbr, re_date
real gen_rate,merit

IF DW_IP.ACCEPTTEXT() = -1 THEN RETURN -1

from_itnbr = DW_IP.GETITEMSTRING(1,"FR_ITNBR")
to_itnbr = DW_IP.GETITEMSTRING(1,"TO_ITNBR")
re_date = TRIM(DW_IP.GETITEMSTRING(1,"sle_yymmdd"))
gen_rate = DW_IP.GETITEMNUMBER(1,"gen_rate")
merit = DW_IP.GETITEMNUMBER(1,"merit")


If from_itnbr = "" or Isnull(from_itnbr) 	then from_itnbr = '0'
If to_itnbr = "" or Isnull(to_itnbr) 		then to_itnbr = 'zzzzzzzzzzzzzzz'
If Isnull(gen_rate) or gen_rate = 0  then   gen_rate = 0
If Isnull(merit)  or merit = 0	 then		    merit = 0


If Isnull(re_date) or re_date =""  then
    MessageBox("알림","기준년월일을 입력하세요!")
    return -1
 end if



/********************사전원가계획서 ******************************/		 
If dw_list.dataobject = "d_sajun_cost_cal_print" then		 

	dw_list.settransobject(sqlca)
	DW_LIST.RETRIEVE(from_itnbr,to_itnbr,gen_rate,merit,re_date)

END IF
/**********************사전원가변동사항*********************************/
   
If dw_list.dataobject = "d_sajun_cost_modify" then	
   
	
	dw_list.settransobject(sqlca)
	DW_LIST.RETRIEVE(re_date,from_itnbr,to_itnbr,gen_rate,merit)
	
END IF	


return 1
end function

on w_pdm_11760.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11760.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1, "sle_yymmdd", Left(f_today(),6) )

w_mdi_frame.sle_msg.text = '사전원가 계산후 조회하십시요.'
end event

type p_preview from w_standard_print`p_preview within w_pdm_11760
end type

type p_exit from w_standard_print`p_exit within w_pdm_11760
end type

type p_print from w_standard_print`p_print within w_pdm_11760
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11760
end type



type sle_msg from w_standard_print`sle_msg within w_pdm_11760
long textcolor = 255
end type



type st_10 from w_standard_print`st_10 within w_pdm_11760
end type



type dw_print from w_standard_print`dw_print within w_pdm_11760
string dataobject = "d_sajun_cost_cal_print_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11760
integer x = 91
integer y = 68
integer width = 2542
integer height = 260
string dataobject = "d_pdm_11760_a"
end type

event dw_ip::itemchanged;//setnull(gs_gubun)
//setnull(gs_code)
//setnull(gs_codename)
//
//IF this.GetColumnName() = 'fr_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"fr_itnbr",gs_code)
//	this.TriggerEvent(ItemChanged!)
//ELSEIF this.GetColumnName() = 'to_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"to_itnbr",gs_code)
//	this.TriggerEvent(ItemChanged!)
//END IF

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

end event

event dw_ip::ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "fr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"fr_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	ELSEIF This.GetColumnName() = "to_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"to_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdm_11760
integer x = 110
integer y = 364
integer width = 4297
integer height = 1928
string dataobject = "d_sajun_cost_cal_print"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdm_11760
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 96
integer y = 352
integer width = 4343
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

