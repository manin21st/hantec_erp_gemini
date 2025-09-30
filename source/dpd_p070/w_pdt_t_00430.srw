$PBExportHeader$w_pdt_t_00430.srw
$PBExportComments$외주 유상 사급현황(자재)
forward
global type w_pdt_t_00430 from w_standard_print
end type
type rr_3 from roundrectangle within w_pdt_t_00430
end type
end forward

global type w_pdt_t_00430 from w_standard_print
string title = "외주 유상 사급현황(자재)"
rr_3 rr_3
end type
global w_pdt_t_00430 w_pdt_t_00430

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_ioyymm, sCvcod,  sCvcodto, ssaupj, t_saupj

If dw_ip.AcceptText() <> 1 Then Return -1

ls_ioyymm  	= dw_ip.GetItemString(1,"io_yymm")
sCvcod      = dw_ip.GetItemString(1,"cvcod")
sCvcodto 	= dw_ip.GetItemString(1,"cvcodto")

IF ls_ioyymm = "" OR IsNull(ls_ioyymm) THEN
	f_message_chk(30,'[마감년월]')
	dw_ip.SetColumn("ls_ioyymm")
	dw_ip.SetFocus()
	Return -1
END IF

IF 	sCvcod 	= "" OR IsNull(sCvcod) 		THEN sCvcod = '.....'
IF 	sCvcodto 	= "" OR IsNull(sCvcodto) 	THEN sCvcodto = 'zzzzz'

dw_list.SetRedraw(False)

IF dw_print.Retrieve(gs_sabu,sCvcod,sCvcodto , ls_ioyymm) <= 0 THEN
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.setcolumn('io_yymm')
	dw_ip.SetFocus()
	Return -1
END IF
	
dw_print.ShareData(dw_list)

dw_list.SetRedraw(True)
//t_saupj 	= Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
//dw_print.Modify("t_saupj.text = '"+t_saupj+"'")

Return 1

end function

on w_pdt_t_00430.create
int iCurrent
call super::create
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
end on

on w_pdt_t_00430.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.SetItem(1,"io_yymm", Left(is_today,6))
//dw_ip.SetItem(1,"sdatet", is_today)
dw_ip.SetColumn("io_yymm")
dw_ip.Setfocus()

/* User별 사업장 Setting */
//setnull(gs_code)
//If 	f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'saupj', gs_code)
//	if 	gs_code <> '%' then
//		dw_ip.setItem(1, 'saupj', gs_code)
//        	dw_ip.Modify("saupj.protect=1")
//		dw_ip.Modify("saupj.background.color = 80859087")
//	End if
//End If
end event

type p_preview from w_standard_print`p_preview within w_pdt_t_00430
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_00430
end type

type p_print from w_standard_print`p_print within w_pdt_t_00430
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_00430
end type











type dw_print from w_standard_print`dw_print within w_pdt_t_00430
integer x = 3744
integer y = 40
string dataobject = "d_pdt_t_00430_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_00430
integer x = 37
integer y = 36
integer width = 2770
integer height = 152
string dataobject = "d_pdt_t_00420_h"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String   sCvcod, sname1, sname2
String   sDateFrom, sDateTo, snull
Integer ireturn

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[수불기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[수불기간]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
	Case "cvcod"
		sCvcod 	= trim(this.gettext())
		ireturn		= f_get_name2('V0', 'Y', sCvcod, sname1, sname2)    //1이면 실패, 0이 성공	
		this.setitem(1, 'cvcod', sCvcod)
		this.setitem(1, 'cvnas2',  sname1)
		return ireturn
	Case "cvcodto"
		sCvcod 	= trim(this.gettext())
		ireturn		= f_get_name2('V0', 'Y', sCvcod, sname1, sname2)    //1이면 실패, 0이 성공	
		this.setitem(1, 'cvcodto', sCvcod)
		this.setitem(1, 'cvnas2to',  sname1)
		return ireturn
		
END Choose

return
end event

event dw_ip::rbuttondown;Long i

SetNull(gs_code)
SetNull(gs_codename)

i = this.GetRow()

Choose   Case this.getcolumnname()
	Case 	"cvcod"
   		gs_gubun = '1'   
		gi_page = -1 
		Open(w_vndmst_popup)
		gi_page = 0 
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		SetItem(i, "cvcod", gs_Code)
		this.TriggerEvent(ItemChanged!)
	Case 	"cvcodto"
   		gs_gubun = '1'   
		gi_page = -1 
		Open(w_vndmst_popup)
		gi_page = 0 
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		SetItem(i, "cvcodto", gs_Code)
		this.TriggerEvent(ItemChanged!)
End Choose

return
end event

type dw_list from w_standard_print`dw_list within w_pdt_t_00430
integer x = 59
integer y = 216
integer width = 4539
integer height = 2096
string dataobject = "d_pdt_t_00430_d"
boolean border = false
end type

type rr_3 from roundrectangle within w_pdt_t_00430
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 208
integer width = 4567
integer height = 2112
integer cornerheight = 40
integer cornerwidth = 46
end type

