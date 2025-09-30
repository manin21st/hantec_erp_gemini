$PBExportHeader$w_sal_06780.srw
$PBExportComments$===> 해외영업팀 목표금액 및 실적분석
forward
global type w_sal_06780 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06780
end type
end forward

global type w_sal_06780 from w_standard_print
string title = "무역부 목표금액 및 실적분석"
rr_1 rr_1
end type
global w_sal_06780 w_sal_06780

type variables
string  a_fmyyyy , a_yyyy 
integer a_chasu

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
dw_ip.AcceptText()

a_yyyy   = trim(dw_ip.GetItemString(1,'a_yy'))
a_fmyyyy = string(integer(a_yyyy) - 1,'0000')
a_chasu  = dw_ip.GetItemNumber(1,'a_chasu')
//messagebox("",a_chasu)
//기준년도 CHECK
if	(a_yyyy = '') or isNull(a_yyyy) or integer(a_yyyy) <= 1990 then           
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('a_yy')
	dw_ip.setfocus()
	Return -1 
end if

if isnull(a_chasu) or a_chasu < 1 then
	f_message_chk(30,'[영업계획차수]')
	dw_ip.setcolumn('a_chasu')
	dw_ip.setfocus()
   return -1 
end if

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_print.Retrieve( a_fmyyyy , a_yyyy , a_chasu ,ls_silgu) <= 0 then
   f_message_chk(50,'[해외영업팀 목표금액 및 실적분석]')
   dw_ip.setcolumn('a_yy')
   return -1
end if

 dw_print.sharedata(dw_list)
return 1

end function

on w_sal_06780.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06780.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'a_yy',left(f_today(),4))
end event

type p_preview from w_standard_print`p_preview within w_sal_06780
end type

type p_exit from w_standard_print`p_exit within w_sal_06780
end type

type p_print from w_standard_print`p_print within w_sal_06780
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06780
end type







type st_10 from w_standard_print`st_10 within w_sal_06780
end type



type dw_print from w_standard_print`dw_print within w_sal_06780
string dataobject = "d_sal_06780_01_P"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06780
integer x = 91
integer y = 56
integer width = 2350
integer height = 200
string dataobject = "d_sal_06780"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;CHOOSE CASE this.GetColumnName()
		
	CASE 'gubun'
 		if this.GetText() = '1' then     
			dw_list.DataObject = "d_sal_06780_01"
			dw_print.DataObject = "d_sal_06780_01_p"
			dw_list.Settransobject(sqlca)
		elseif this.GetText() = '2' then 
			dw_list.DataObject = "d_sal_06780_02"
			dw_print.DataObject = "d_sal_06780_02_p"
			dw_list.Settransobject(sqlca)
		end if
END CHOOSE
          
			dw_print.Settransobject(sqlca) 
end event

type dw_list from w_standard_print`dw_list within w_sal_06780
integer x = 110
integer y = 264
integer width = 4471
integer height = 2044
string dataobject = "d_sal_06780_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06780
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 101
integer y = 256
integer width = 4498
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

