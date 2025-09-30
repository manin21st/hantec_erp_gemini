$PBExportHeader$w_sal_06670.srw
$PBExportComments$ ===> Delivery Confirmation
forward
global type w_sal_06670 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06670
end type
end forward

global type w_sal_06670 from w_standard_print
string title = "Delivery Confirmation"
rr_1 rr_1
end type
global w_sal_06670 w_sal_06670

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sPINO, sSangho, sPinote
Long    i, lrow, ladd_row

dw_ip.AcceptText()

sPINO = Trim(dw_ip.GetItemString(1,'pino'))

if	(sPINO = '') or isNull(sPINO) then
	f_message_Chk(30, '[P/I No 입력확인]')
	dw_ip.setcolumn('pino')
	dw_ip.setfocus()
	Return -1
end if

lrow = dw_list.Retrieve(gs_sabu, sPINO)

if lrow < 1 then
   f_message_Chk(300, '[출력조건 CHECK]')
  	dw_ip.setcolumn('pino')
	dw_ip.setfocus()
  	return -1
end if

sSangho = dw_list.GetItemString(1, 'exppih_pisangho')
sPinote = dw_list.GetItemString(1, 'exppih_pinotes')
ladd_row = 35 - mod(lrow, 35)

dw_list.SetRedraw(False)
for i = 1 to ladd_row 
	dw_list.InsertRow(0)
	dw_list.SetItem(dw_list.rowcount(), 'exppih_pisangho', sSangho)
	dw_list.SetItem(dw_list.rowcount(), 'exppih_pinotes', sPinote)	
next
dw_list.SetRedraw(True)

return 1
end function

on w_sal_06670.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06670.destroy
call super::destroy
destroy(this.rr_1)
end on

event w_sal_06670::open;call super::open;w_mdi_frame.sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

end event

type p_preview from w_standard_print`p_preview within w_sal_06670
end type

type p_exit from w_standard_print`p_exit within w_sal_06670
end type

type p_print from w_standard_print`p_print within w_sal_06670
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06670
end type







type st_10 from w_standard_print`st_10 within w_sal_06670
end type



type dw_print from w_standard_print`dw_print within w_sal_06670
string dataobject = "d_sal_06670_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06670
integer x = 384
integer y = 52
integer height = 164
string dataobject = "d_sal_06670_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sCol_Name

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

sCol_Name = GetColumnName()

Choose Case sCol_Name
	Case "pino"
//      gs_code = Trim(this.GetText())
		Open(w_exppih_popup)
		this.SetItem(1, 'pino', gs_code)
//		cb_update.SetFocus()
End Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06670
integer x = 402
integer y = 236
integer width = 3703
integer height = 2068
string dataobject = "d_sal_06670_03"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_sal_06670
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 389
integer y = 228
integer width = 3735
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

