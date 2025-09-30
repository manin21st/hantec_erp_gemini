$PBExportHeader$w_pdt_t_00410.srw
$PBExportComments$외주수불내역서
forward
global type w_pdt_t_00410 from w_standard_print
end type
type rr_3 from roundrectangle within w_pdt_t_00410
end type
end forward

global type w_pdt_t_00410 from w_standard_print
string title = "외주수불내역서"
rr_3 rr_3
end type
global w_pdt_t_00410 w_pdt_t_00410

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom, sTo, sCvcod,  sCvcodto, ssaupj, t_saupj

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       	= dw_ip.GetItemString(1,"sdatef")
sTo         		= dw_ip.GetItemString(1,"sdatet")
sCvcod       	= dw_ip.GetItemString(1,"cvcod")
sCvcodto 		= dw_ip.GetItemString(1,"cvcodto")
ssaupj 		= dw_ip.getitemstring(1,"saupj")

IF 	sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

IF 	sCvcod 	= "" OR IsNull(sCvcod) 		THEN sCvcod = '.....'
IF 	sCvcodto 	= "" OR IsNull(sCvcodto) 	THEN sCvcodto = 'zzzzz'


IF 	dw_print.Retrieve(gs_sabu,sFrom,sTo,sCvcod,sCvcodto) <= 0 THEN
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
END IF
	
dw_print.ShareData(dw_list)
t_saupj 	= Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
dw_print.Modify("t_saupj.text = '"+t_saupj+"'")

Return 1

end function

on w_pdt_t_00410.create
int iCurrent
call super::create
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
end on

on w_pdt_t_00410.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
end on

event open;call super::open;
dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)
dw_ip.SetColumn("cvcod")
dw_ip.Setfocus()


/* User별 사업장 Setting */
setnull(gs_code)
If 	f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
	if 	gs_code <> '%' then
		dw_ip.setItem(1, 'saupj', gs_code)
        	dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
	End if
End If

end event

type p_preview from w_standard_print`p_preview within w_pdt_t_00410
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_00410
end type

type p_print from w_standard_print`p_print within w_pdt_t_00410
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_00410
end type











type dw_print from w_standard_print`dw_print within w_pdt_t_00410
integer x = 3561
integer y = 64
string dataobject = "d_pdt_t_00410_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_00410
integer x = 37
integer y = 164
integer width = 2990
integer height = 236
string dataobject = "d_pdt_t_00410_01"
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

type dw_list from w_standard_print`dw_list within w_pdt_t_00410
integer x = 59
integer y = 420
integer width = 4539
integer height = 1892
string dataobject = "d_pdt_t_00410_02"
boolean border = false
end type

type rr_3 from roundrectangle within w_pdt_t_00410
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 412
integer width = 4567
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 46
end type

