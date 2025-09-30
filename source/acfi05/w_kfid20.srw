$PBExportHeader$w_kfid20.srw
$PBExportComments$받을어음 관리대장
forward
global type w_kfid20 from w_standard_print
end type
type gb_5 from groupbox within w_kfid20
end type
type gb_4 from groupbox within w_kfid20
end type
type rr_1 from roundrectangle within w_kfid20
end type
end forward

global type w_kfid20 from w_standard_print
integer x = 0
integer y = 0
string title = "받을어음 관리대장"
gb_5 gb_5
gb_4 gb_4
rr_1 rr_1
end type
global w_kfid20 w_kfid20

type variables
String sdatef,sdatet,sbillnof,sbillnot
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Int ll_retrow

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sabu_f = dw_ip.GetItemString(dw_ip.Getrow(), 'saupj')
sabu_t = dw_ip.GetItemString(dw_ip.Getrow(), 'saupj')
sdatef = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"datef"))
sdatet = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"datet"))

If sabu_f = "" or Isnull(sabu_f) or sabu_f = '99' then
	sabu_f = '10' 
	sabu_t = '98'
End If

IF DaysAfter(Date(Left(sdatef,4)+"/"+Mid(sdatef,5,2)+"/"+Right(sdatef,2)),&
				 Date(Left(sdatet,4)+"/"+Mid(sdatet,5,2)+"/"+Right(sdatet,2))) < 0 THEN
	MessageBox("확  인","날짜 범위가 잘못 지정되었습니다. 확인하세요.!!!")
	dw_ip.SetColumn("datet")
	dw_ip.SetFocus()
	Return -1
END IF

ll_retrow =dw_print.Retrieve( sabu_f,sabu_t,sdatef,sdatet )

IF ll_retrow <= 0 THEN
	f_messagechk(14,"")
	dw_ip.SetFocus()
	Return -1
END IF
dw_print.sharedata(dw_list)
Return 1
end function

on w_kfid20.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.rr_1
end on

on w_kfid20.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(),"datef",String(today(),"yyyymm")+'01')
dw_ip.SetItem(dw_ip.GetRow(),"datet",String(today(),"yyyymmdd"))

dw_ip.setitem(dw_ip.getrow(),"saupj", Gs_Saupj)
IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(255,255,255))+"'")  //MINT COLOR
End if

dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_kfid20
integer y = 8
end type

type p_exit from w_standard_print`p_exit within w_kfid20
integer y = 8
end type

type p_print from w_standard_print`p_print within w_kfid20
integer y = 8
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfid20
integer y = 8
end type





type dw_datetime from w_standard_print`dw_datetime within w_kfid20
integer width = 754
end type

type st_10 from w_standard_print`st_10 within w_kfid20
end type



type dw_print from w_standard_print`dw_print within w_kfid20
string dataobject = "dw_kfid202_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfid20
integer x = 23
integer width = 2341
integer height = 140
string dataobject = "dw_kfid201"
end type

event dw_ip::itemchanged;String snull

SetNull(snull)

IF dwo.name = "datef" THEN
	
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"날짜") 
		dw_ip.SetItem(dw_ip.Getrow(),"datef",snull)
		Return 1
	END IF
END IF

IF dwo.name = "datet" THEN
	
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"날짜") 
		dw_ip.SetItem(dw_ip.Getrow(),"datet",snull)
		Return 1
	END IF
END IF

IF dwo.name = "gubun" THEN
	dw_ip.SetRedraw(False)
	IF data = '1' THEN
		dw_list.Title ="받을어음 예정결제현황(요약)"
		dw_list.DataObject ="d_kfia32_2"
	ELSEIF data = '2' THEN
		dw_list.Title ="받을어음 예정결제현황(상세)"
		dw_list.DataObject ="d_kfia32_1"
	ELSE
		MessageBox("확 인","출력구분을 입력하시요.!!")
		Return 1
	END IF
	dw_ip.SetRedraw(True)
	dw_list.SetTransObject(SQLCA)
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;this.accepttext()

SetNull(gs_code)
IF this.GetColumnName() ="billnof" THEN
	gs_code =Trim(dw_ip.GetItemString(dw_ip.GetRow(),"billnof"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF

	OPEN(W_KFM02OT0_POPUP)
	
	this.SetItem(this.GetRow(), 'billnof', gs_code)
	
END IF

SetNull(gs_code)
IF this.GetColumnName() ="billnot" THEN
	gs_code =Trim(dw_ip.GetItemString(dw_ip.GetRow(),"billnot"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	
	OPEN(W_KFM02OT0_POPUP)
	
	this.SetItem(this.GetRow(), 'billnot', gs_code)
	
END IF
end event

event dw_ip::getfocus;call super::getfocus;dw_ip.Accepttext()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfid20
integer x = 27
integer y = 172
integer height = 2040
string dataobject = "dw_kfid202"
boolean border = false
boolean hsplitscroll = false
end type

type gb_5 from groupbox within w_kfid20
integer x = 114
integer y = 516
integer width = 494
integer height = 360
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type gb_4 from groupbox within w_kfid20
integer x = 137
integer y = 592
integer width = 494
integer height = 360
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kfid20
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 168
integer width = 4608
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

