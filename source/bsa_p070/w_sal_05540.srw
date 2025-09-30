$PBExportHeader$w_sal_05540.srw
$PBExportComments$일일 수주미처리 그래프(생산팀 기준)
forward
global type w_sal_05540 from w_standard_dw_graph
end type
type pb_1 from u_pb_cal within w_sal_05540
end type
end forward

global type w_sal_05540 from w_standard_dw_graph
string title = "일일 수주미처리 그래프(생산팀 기준)"
pb_1 pb_1
end type
global w_sal_05540 w_sal_05540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDatef, sDatet, sRtn
Double dAmt[22]
Long   ix, iy

If dw_ip.AcceptText() <> 1 Then Return -1

sDatet = Trim(dw_ip.GetItemString(1,'symd'))

if	(sDatet='') or isNull(sDatet) then
	f_Message_Chk(35, '[기준일자]')
	dw_ip.setcolumn('symd')
	dw_ip.setfocus()
	Return -1
end if

f_saledaysafter(sdatet,-22,sdatef,sdatet)

dw_list.object.r_ymd.Text = Left(sdatet,4) + '.' + Mid(sdatet,5,2) + '.' + Right(sdatet,2)

if dw_list.Retrieve(gs_sabu, sdatef, sdatet) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
   dw_ip.setcolumn('symd')
   dw_ip.setfocus()
   return -1
end if

/* 합계 집계 */
For ix = 0 To (dw_list.RowCount() / 22) - 1
	For iy = 1 To 22
		dAmt[iy] += dw_list.GetItemNumber( ix*22 + iy, 'su_amt')
	Next
Next

For ix = 1 To 22
	dw_list.Modify("sum"+string(ix) + ".expression = '" + string(damt[ix]) + "'")
Next

return 1
end function

on w_sal_05540.create
int iCurrent
call super::create
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
end on

on w_sal_05540.destroy
call super::destroy
destroy(this.pb_1)
end on

event open;call super::open;sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
dw_ip.setitem(1,'symd',left(f_today(),8))
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05540
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05540
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05540
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05540
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05540
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05540
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05540
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05540
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05540
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05540
integer width = 1509
integer height = 148
string dataobject = "d_sal_05540_01"
end type

event dw_ip::itemchanged;String sCol_Name, sNull

//dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
	// 기준일자 유효성 Check
   Case "symd"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "symd", sNull)
			f_Message_Chk(35, '[기준일자]')
			return 1
		end if
end Choose
end event

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05540
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05540
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05540
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05540
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05540
integer y = 204
integer height = 2100
string dataobject = "d_sal_05540"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05540
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05540
integer y = 192
integer height = 2132
end type

type pb_1 from u_pb_cal within w_sal_05540
integer x = 832
integer y = 36
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('symd')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'symd', gs_code)

end event

