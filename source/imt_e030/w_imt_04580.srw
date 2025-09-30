$PBExportHeader$w_imt_04580.srw
$PBExportComments$권고 대 실입고 차이(출력-표)
forward
global type w_imt_04580 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_04580
end type
end forward

global type w_imt_04580 from w_standard_print
string title = "권고 대 실입고 차이"
rr_1 rr_1
end type
global w_imt_04580 w_imt_04580

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_stdy, s_frmvnd, s_tovnd, s_temp, sempno
long     l_mrseq[12], l_rtnval
integer  i_loopcnt

if dw_ip.AcceptText() = -1 then return -1

s_stdy   = dw_ip.GetItemString(1,"stdy")
s_frmvnd = dw_ip.GetItemString(1,"frmvnd")
s_tovnd  = dw_ip.GetItemString(1,"tovnd")
sempno   = dw_ip.GetItemString(1,"empno")

IF (IsNull(s_stdy) OR s_stdy = "") THEN
   f_message_chk(30,"[기준년도]")
	dw_ip.SetColumn('stdy')
	dw_ip.SetFocus()
	return -1
END IF

//거래처
IF IsNull(s_frmvnd) OR s_frmvnd = "" THEN
	s_frmvnd = '.'
end if
IF IsNull(s_tovnd) OR s_tovnd = "" THEN
	s_tovnd = 'zzzzzz'
END IF

if IsNull(sempno) OR sempno = "" THEN
	dw_print.setfilter("")
else
	dw_print.setfilter("emp_id = '"+ sempno +" '")
end if	
dw_print.filter()
FOR i_loopcnt = 1 TO 12
    if i_loopcnt < 10 then
		 s_temp = s_stdy + "0" + String(i_loopcnt)
	 else
		 s_temp = s_stdy + String(i_loopcnt)
	 end if
	 
	   SELECT MAX(MRSEQ)
		  INTO :l_mrseq[i_loopcnt]
		  FROM MTRPLN_SUM
		 WHERE SABU = :gs_sabu AND MTRYYMM = :s_temp ;

NEXT

l_rtnval = dw_print.Retrieve(gs_sabu, s_stdy, l_mrseq[1], l_mrseq[2], l_mrseq[3], &
                            l_mrseq[4], l_mrseq[5], l_mrseq[6], l_mrseq[7], l_mrseq[8], &
									 l_mrseq[9], l_mrseq[10], l_mrseq[11], l_mrseq[12], &
									 s_frmvnd, s_tovnd)

IF l_rtnval < 1 THEN
	f_message_chk(50,"권고 대 실입고 차이")
	dw_ip.SetColumn('stdy')
	dw_ip.SetFocus()
	return -1
ELSE
	dw_print.ShareData(dw_list)
END IF

Return 1
end function

on w_imt_04580.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_04580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, "stdy", Mid(f_today(),1,4))		


end event

type p_preview from w_standard_print`p_preview within w_imt_04580
end type

type p_exit from w_standard_print`p_exit within w_imt_04580
end type

type p_print from w_standard_print`p_print within w_imt_04580
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04580
end type







type st_10 from w_standard_print`st_10 within w_imt_04580
end type



type dw_print from w_standard_print`dw_print within w_imt_04580
string dataobject = "d_imt_04581_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04580
integer x = 0
integer y = 8
integer width = 2606
integer height = 228
string dataobject = "d_imt_04580"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string snull, s_col, s_cod, s_nam

sle_msg.Text = ""
SetNull(snull)

s_col = this.GetColumnName()

if s_col = 'frmvnd' then   
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then 
		this.SetItem(1,"frmvndnam",snull)
		return
	end if
	
	SELECT CVNAS
     INTO :s_nam
     FROM VNDMST  
    WHERE CVCOD = :s_cod;                    

	if sqlca.sqlcode = 0 then
		this.SetItem(1,"frmvndnam",s_nam)
	else
		this.SetItem(1,"frmvndnam",snull)		
	end if
 
elseif s_col = 'tovnd' then   
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then
		this.SetItem(1,"tovndnam",snull)		
		return
	end if
	
	SELECT CVNAS
     INTO :s_nam
     FROM VNDMST  
    WHERE CVCOD = :s_cod;                    

	if sqlca.sqlcode = 0 then
		this.SetItem(1,"tovndnam",s_nam)
	else
		this.SetItem(1,"tovndnam",snull)		
	end if

end if	
	
	

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.GetColumnName() = "frmvnd"	THEN		
	gs_gubun = '1'
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "frmvnd", gs_code)
	this.SetItem(1, "frmvndnam", gs_codename)
ELSEIF this.GetColumnName() = "tovnd" THEN		
	gs_gubun = '1'
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "tovnd", gs_code)
	this.SetItem(1, "tovndnam", gs_codename)
END IF




end event

type dw_list from w_standard_print`dw_list within w_imt_04580
integer x = 23
integer y = 252
integer width = 4562
integer height = 2084
string dataobject = "d_imt_04581_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_04580
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 244
integer width = 4599
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 55
end type

