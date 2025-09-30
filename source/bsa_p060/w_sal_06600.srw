$PBExportHeader$w_sal_06600.srw
$PBExportComments$===> 외화변화 현황
forward
global type w_sal_06600 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06600
end type
end forward

global type w_sal_06600 from w_standard_print
string title = "외화변화 현황"
rr_1 rr_1
end type
global w_sal_06600 w_sal_06600

type variables
string  a_fmyyyy , a_fmym , a_fmmm , a_fmdd
string  a_yyyy , a_ym , a_mm , a_dd
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String v_fmym

dw_ip.AcceptText()

a_yyyy   =  trim(dw_ip.GetItemString(1,'d_dateyy'))
a_mm     =  trim(dw_ip.GetItemString(1,'d_datemm'))

//기준년도 CHECK
if	(a_yyyy = '') or isNull(a_yyyy) or integer(a_yyyy) <= 1990 then           
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('d_dateyy')
	dw_ip.setfocus()
	Return -1 
end if
//기준월 CHECK
if	(a_mm = '') or isNull(a_mm) or integer(a_mm) <= 0 or integer(a_mm) > 12 then           
	f_Message_Chk(35, '[기준월]')
	dw_ip.setcolumn('d_datemm')
	dw_ip.setfocus()
	Return -1 
end if

v_fmym   = f_aftermonth(a_yyyy, -11)
a_fmyyyy = MID(v_fmym,1,4)
a_fmmm   = MID(v_fmym,5,2)
a_fmym   = f_aftermonth(a_yyyy, -1)
a_fmdd   = f_last_date(a_fmym)
a_ym     = a_yyyy + a_mm
a_dd     = f_last_date(a_yyyy + a_mm)

if dw_list.Retrieve(a_fmyyyy,a_fmym,a_fmmm,a_fmdd,a_yyyy,a_ym,a_mm,a_dd) <= 0 then
   f_message_chk(50,'[외화변화현황]')
   dw_ip.setcolumn('d_dateyy')
   return -1
end if

return 1

end function

on w_sal_06600.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'d_dateyy',left(f_today(),4))
dw_ip.setitem(1,'d_datemm',mid(f_today(),5,2))

dw_list.SharedataOff()
end event

type p_xls from w_standard_print`p_xls within w_sal_06600
end type

type p_sort from w_standard_print`p_sort within w_sal_06600
end type

type p_preview from w_standard_print`p_preview within w_sal_06600
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within w_sal_06600
end type

type p_print from w_standard_print`p_print within w_sal_06600
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_06600
end type







type st_10 from w_standard_print`st_10 within w_sal_06600
end type



type dw_print from w_standard_print`dw_print within w_sal_06600
string dataobject = "d_sal_06600_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06600
integer x = 73
integer y = 44
integer width = 2414
integer height = 196
string dataobject = "d_sal_06600"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;Choose Case this.getcolumnname()
	Case 'gubun'
		dw_list.setredraw(false)
		if this.gettext() = '1' then
			dw_list.dataobject = 'd_sal_06600_01'
		else
			dw_list.dataobject = 'd_sal_06600_06'
		end if
		dw_list.settransobject(sqlca)
		dw_list.setredraw(true)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_06600
integer x = 91
integer y = 264
integer width = 4466
integer height = 2032
string dataobject = "d_sal_06600_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06600
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 252
integer width = 4494
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

