$PBExportHeader$w_sal_06580.srw
$PBExportComments$Packing List======> 야금미사용
forward
global type w_sal_06580 from w_standard_print
end type
end forward

global type w_sal_06580 from w_standard_print
string title = "Packing List"
end type
global w_sal_06580 w_sal_06580

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sCINO, sShipMark
long    lrow, lctqty, ladd_row, i

dw_ip.AcceptText()

sCINO = Trim(dw_ip.GetItemString(1,'cino'))

if	(sCINO = '') or isNull(sCINO) then
	f_message_Chk(30, '[C/I No 입력 확인]')
	dw_ip.setcolumn('cino')
	dw_ip.setfocus()
	Return -1
end if
// Shipping Mark,C/T Qty 추출하여 argument로 넘김
Select shipmark,ctqty Into :sShipMark,:lctqty
From expcih  
Where sabu = :gs_sabu and cino = :sCINO;

if isNull(sShipMark) then
	sShipMark = ''
end if

if isNull(lctqty) then
	lctqty = 0
end if

lrow = dw_list.Retrieve(gs_sabu, sCINO, sShipMark, lctqty)

if lrow < 1 then
   f_message_Chk(300, '[출력조건 CHECK]')
  	dw_ip.setcolumn('cino')
	dw_ip.setfocus()
  	return -1
end if

//ladd_row = 30 - lrow
//
//for i = 1 to ladd_row 
//	dw_list.InsertRow(0)
//next

return 1
end function

on w_sal_06580.create
call super::create
end on

on w_sal_06580.destroy
call super::destroy
end on

event open;call super::open;sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

type p_preview from w_standard_print`p_preview within w_sal_06580
end type

type p_exit from w_standard_print`p_exit within w_sal_06580
end type

type p_print from w_standard_print`p_print within w_sal_06580
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06580
end type







type st_10 from w_standard_print`st_10 within w_sal_06580
end type



type dw_print from w_standard_print`dw_print within w_sal_06580
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06580
integer y = 24
string dataobject = "d_sal_06580_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	Case "cino"
		gs_code = 'A'
		gs_gubun ='A'
		Open(w_expci_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(1, 'cino', gs_code)
End Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06580
integer x = 818
string dataobject = "d_sal_06580"
end type

