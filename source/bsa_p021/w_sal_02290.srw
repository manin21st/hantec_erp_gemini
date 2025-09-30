$PBExportHeader$w_sal_02290.srw
$PBExportComments$수주 납기 분석
forward
global type w_sal_02290 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02290
end type
type pb_2 from u_pb_cal within w_sal_02290
end type
type rr_1 from roundrectangle within w_sal_02290
end type
end forward

global type w_sal_02290 from w_standard_print
string title = "수주 납기 분석"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02290 w_sal_02290

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDatef, sDatet, sSaupj, sPangb, sSalegu, tx_name, sGubun

If dw_ip.accepttext() <>  1 Then Return -1

sDatef = Trim(dw_ip.getitemstring(1,"sdatef"))
sDatet = Trim(dw_ip.getitemstring(1,"sdatet"))
ssaupj = Trim(dw_ip.getitemstring(1,"saupj"))
sPangb = Trim(dw_ip.getitemstring(1,"pangb"))
sSalegu = Trim(dw_ip.getitemstring(1,"salegu"))
sGubun = Trim(dw_ip.getitemstring(1,"gubun"))

////필수입력항목 체크///////////////////////////////////////////////
dw_ip.setfocus()
If f_datechk(sDatef) <> 1 Then
	f_message_chk(35,'[수주기간]')
	dw_ip.setcolumn("sdatef")
	return -1
end if

If f_datechk(sDatet) <> 1 Then
	f_message_chk(35,'[수주기간]')
	dw_ip.setcolumn("sdatet")
	return -1
end if

If Isnull(sSaupj) or sSaupj = "" then    sSaupj = ''
If Isnull(sPangb) or sPangb = "" then    sPangb = ''

//dw_list.SetRedraw(False)

IF dw_print.retrieve(gs_sabu, sDatef, sDatet, sPangb+'%', sSalegu, sSaupj+'%', sGubun) <= 0 THEN
	f_message_chk(50,'[수주 납기 분석]')
	dw_ip.setfocus()
	//dw_list.SetRedraw(True)
	dw_print.InsertRow(0)
//	Return -1
else
	dw_print.sharedata(dw_list)
End If

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pangb) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_pangb.text = '"+tx_name+"'")

//dw_list.SetRedraw(True)

Return 1
end function

on w_sal_02290.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sal_02290.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;string sDate

sDate = f_today()
dw_ip.setitem(1,"sdatef",Left(sDate,6)+'01')
dw_ip.SetItem(1, "sdatet", sDate)
dw_ip.setfocus()

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'saupj', saupj)
End If

f_mod_saupj(dw_ip, 'saupj')

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_02290
end type

type p_exit from w_standard_print`p_exit within w_sal_02290
end type

type p_print from w_standard_print`p_print within w_sal_02290
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02290
end type







type st_10 from w_standard_print`st_10 within w_sal_02290
end type



type dw_print from w_standard_print`dw_print within w_sal_02290
string dataobject = "d_sal_022902_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02290
integer y = 24
integer width = 3131
integer height = 240
string dataobject = "d_sal_02290"
end type

event dw_ip::itemchanged;String sNull, sDate

SetNull(snull)

Choose Case GetColumnName() 
	/* 일자 */
	Case 'sdatef', 'sdatet'
		sDate = Trim(GetText())
		If f_datechk(sDate) <> 1 Then
			f_message_chk(35,'[수주기간]')
			Return 1
		End If
	/* 출력구분 */
	Case "gubun" 
		dw_list.setredraw(false)
		Choose Case GetText()
			Case 'L','M','S'
				dw_list.dataobject = 'd_sal_022902'
				dw_print.dataobject = 'd_sal_022902_p'
			Case 'I'
				dw_list.dataobject = 'd_sal_022901'
				dw_print.dataobject = 'd_sal_022901_p'
		End Choose
		dw_list.settransobject(sqlca)
		dw_print.settransobject(sqlca)
		dw_list.setredraw(true)
END Choose

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_02290
integer x = 50
integer y = 268
integer width = 4544
integer height = 2052
string dataobject = "d_sal_022902"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_02290
integer x = 750
integer y = 48
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02290
integer x = 1225
integer y = 44
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02290
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 264
integer width = 4567
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

