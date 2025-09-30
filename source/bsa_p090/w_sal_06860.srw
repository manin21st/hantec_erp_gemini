$PBExportHeader$w_sal_06860.srw
$PBExportComments$월별 판매실적 및 계획
forward
global type w_sal_06860 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06860
end type
end forward

global type w_sal_06860 from w_standard_print
string title = "월별 판매실적 및 계획"
rr_1 rr_1
end type
global w_sal_06860 w_sal_06860

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_yymm , ls_yymm1 , ls_mm

if dw_ip.accepttext() <> 1 then return -1

ls_yymm = Trim(dw_ip.getitemstring(1,'yymm'))

if ls_yymm = "" or isnull(ls_yymm) then
	f_message_chk(30,'[기준년월]')
	dw_ip.setcolumn('yymm')
	dw_ip.setfocus()
	return -1
end if

ls_mm = mid(ls_yymm,5,2)

if ls_mm <= '03' then
	ls_yymm1 = left(ls_yymm,4) + '03'
elseif  '03' < ls_mm and ls_mm < '07' then
	ls_yymm1 = left(ls_yymm,4) + '06'
elseif '06' < ls_mm and ls_mm < '10'  then
	ls_yymm1 = left(ls_yymm,4) + '09'
else
	ls_yymm1 = left(ls_yymm,4) + '12'
end if

//messagebox('',ls_yymm1)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_print.retrieve(ls_yymm , ls_yymm1,gs_sabu,ls_silgu) < 1 then
	f_message_chk(300,'')
	dw_ip.setcolumn('yymm')
	dw_ip.setfocus()
	dw_print.InsertRow(0)
//	return -1
else
	dw_print.sharedata(dw_list)
end if

return 1
end function

on w_sal_06860.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06860.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'yymm',left(f_today(),6))
end event

type p_preview from w_standard_print`p_preview within w_sal_06860
end type

type p_exit from w_standard_print`p_exit within w_sal_06860
end type

type p_print from w_standard_print`p_print within w_sal_06860
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06860
end type







type st_10 from w_standard_print`st_10 within w_sal_06860
end type



type dw_print from w_standard_print`dw_print within w_sal_06860
string dataobject = "d_sal_06860_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06860
integer x = 59
integer y = 24
integer width = 617
integer height = 132
string dataobject = "d_sal_06860"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_data , snull

setnull(snull)

Choose Case this.GetColumnName() 
	/* 예상납기기간 */
	Case "yymm"
		ls_data = Trim(this.GetText())
		
		IF ls_data ="" OR IsNull(ls_data) THEN RETURN
		
		IF f_datechk(ls_data + '01') = -1 THEN
			f_message_chk(35,'[기준년월]')
			this.SetItem(1,GetColumnName(),snull)
			Return 1
		END IF
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_06860
integer x = 73
integer y = 184
integer width = 4512
integer height = 2132
string dataobject = "d_sal_06860_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06860
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 180
integer width = 4544
integer height = 2148
integer cornerheight = 40
integer cornerwidth = 55
end type

