$PBExportHeader$w_sal_t_00100.srw
$PBExportComments$용도별 가격 현황
forward
global type w_sal_t_00100 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_t_00100
end type
type rr_1 from roundrectangle within w_sal_t_00100
end type
end forward

global type w_sal_t_00100 from w_standard_print
string title = "용도별 가격 현황"
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_t_00100 w_sal_t_00100

forward prototypes
public function integer wf_retrieve ()
public function integer wf_setdwprint ()
end prototypes

public function integer wf_retrieve ();String ls_itnbr, ls_date, ls_gubun

dw_ip.AcceptText()

ls_itnbr    =  trim(dw_ip.getitemstring(1,'itnbr')) 
ls_date    =  trim(dw_ip.getitemstring(1,'sdate')) 
ls_gubun    =  trim(dw_ip.getitemstring(1,'gubun')) 

if ls_itnbr= "" or isnull(ls_itnbr) then
	f_message_chk(30,' [품번] ')
	dw_ip.setcolumn('itnbr')
	dw_ip.setfocus()
	return -1
end if

dw_list.setRedraw(False)
dw_print.setRedraw(False)

if dw_list.retrieve(ls_itnbr, ls_date, ls_gubun) < 1 then
	f_message_chk(50,' [용도별 가격 현황] ')
	dw_ip.setcolumn('itnbr')
	dw_ip.setfocus()
   return -1
Else
	dw_print.retrieve(ls_itnbr, ls_date, ls_gubun)
end if

dw_print.Object.t_itnbr.text = ls_itnbr
dw_print.Object.t_date.text = left(ls_date,4) + '.' + mid(ls_date, 5,2) + '.' + right(ls_date, 2)
dw_print.Object.t_date.text = String(ls_date,'@@@@.@@.@@')
dw_print.Object.t_name.text = trim(dw_ip.getitemstring(1,'itdsc'))
//dw_print.Object.t_gubun.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(gubun)', 1)"))

//If wf_setDwPrint() < 1 Then
//	return -1
//End If

dw_list.setRedraw(True)
dw_print.setRedraw(True)

return 1
end function

public function integer wf_setdwprint ();long ll_rowcount, i

ll_rowcount = dw_list.rowcount()

//For i = 1 to ll_rowcount
//
//	
//
//Next

return 1
end function

on w_sal_t_00100.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_t_00100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.shareDataOff()

dw_ip.setitem(1,'sdate',left(f_today(),8))
dw_ip.SetItem(1, "gubun","%")
end event

type p_preview from w_standard_print`p_preview within w_sal_t_00100
integer x = 4078
boolean enabled = true
end type

type p_exit from w_standard_print`p_exit within w_sal_t_00100
end type

type p_print from w_standard_print`p_print within w_sal_t_00100
integer x = 4261
end type

event p_print::clicked;call super::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = 1
//	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_t_00100
integer x = 3895
end type







type st_10 from w_standard_print`st_10 within w_sal_t_00100
end type



type dw_print from w_standard_print`dw_print within w_sal_t_00100
string dataobject = "d_sal_t_00100_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_t_00100
integer x = 32
integer y = 24
integer width = 2784
integer height = 248
string dataobject = "d_sal_t_00100_h"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;string scode, sItDsc, sIspec, sJijil

if THIS.GetColumnName() = "itnbr" THEN
	sCode = This.GetText()
	
	IF sCode = '' OR ISNULL(sCode) THEN 
		f_message_chk(35,'[ 품번 ]')
		this.setFocus()
		this.setColumn('itnbr')
		return 1
	End If
	
	SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
	  INTO :sItDsc,   		 :sIspec, 		:sJijil
	  FROM "ITEMAS"
	 WHERE "ITEMAS"."ITNBR" = :sCode AND	"ITEMAS"."USEYN" = '0' ;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
		this.setitem(1, 'itnbr', '')
		this.setitem(1, 'itdsc', '')
		this.setFocus()
		this.setColumn('itnbr')
//         p_can.triggerevent(clicked!)
		Return 1
	END IF
		this.setitem(1, 'itnbr', sCode)
		this.setitem(1, 'itdsc', sItDsc)
END IF
end event

event dw_ip::rbuttondown;string sittyp

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

this.accepttext()

If this.GetColumnName() = 'itnbr' then

	open(w_itemas_popup)

	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itnbr",gs_code)
	this.SetItem(1,"itdsc",gs_codename)

end if
end event

type dw_list from w_standard_print`dw_list within w_sal_t_00100
event ue_mousemove pbm_mousemove
integer x = 55
integer y = 296
integer width = 4530
integer height = 2020
string dataobject = "d_sal_t_00100_d"
boolean border = false
end type

event dw_list::ue_mousemove;//String ls_Object
//Long	 ll_Row
//
//IF this.Rowcount() < 1 then return 
//
//ls_Object = Lower(This.GetObjectAtPointer())
//
//w_mdi_frame.sle_msg.text = ls_Object

//IF mid(ls_Object, 1, 9)  = 'sort_name' THEN 
//   ll_Row = long(mid(ls_Object, 11, 5))
//	w_mdi_frame.sle_msg.text = 
//ELSE
//	this.setitem(this.getrow(), 'opt1', '0')
//END IF
end event

type pb_1 from u_pb_cal within w_sal_t_00100
integer x = 832
integer y = 152
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)

end event

type rr_1 from roundrectangle within w_sal_t_00100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 292
integer width = 4562
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

