$PBExportHeader$w_cic02080.srw
$PBExportComments$제품 공정별 S/T 명세서
forward
global type w_cic02080 from w_standard_print
end type
type dw_5 from datawindow within w_cic02080
end type
type rr_1 from roundrectangle within w_cic02080
end type
type dw_1 from datawindow within w_cic02080
end type
end forward

global type w_cic02080 from w_standard_print
integer x = 0
integer y = 0
string title = "제품 공정별 S/T 명세서"
dw_5 dw_5
rr_1 rr_1
dw_1 dw_1
end type
global w_cic02080 w_cic02080

type variables
string s_gelname
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();//string sPumdtf,sPumdtt,sExgbn ,sExpCd
//
//dw_ip.AcceptText()
//
//sPumdtf         = dw_ip.GetItemString(1,"PUMDTF")
//sPumdtt         = dw_ip.GetItemString(1,"PUMDTT")
//sExgbn          = dw_ip.GetItemString(1,"EXGBN")
//sExpCd          = dw_ip.GetItemString(1,"EXP_CD")
//
//IF sPumdtf = "" OR IsNull(sPumdtf) THEN
//	f_messagechk(1,"[조회년도-FROM]")
//	dw_ip.setcolumn("PUMDTF")
//	dw_ip.SetFocus()
//	Return -1
//END IF
//
//IF sPumdtt = "" OR IsNull(sPumdtt) THEN
//	f_messagechk(1,"[조회년도-TO]")
//	dw_ip.setcolumn("PUMDTT")
//	dw_ip.SetFocus()
//	Return -1
//END IF
//
//sExgbn = dw_ip.Object.EXGBN[1]
//sExgbn = f_nvl(sExgbn, '%') 
//
//sExpCd = dw_ip.Object.EXP_CD[1]
//sExpCd = f_nvl(sExpCd, '%') 
//
//setpointer(hourglass!)
//
//if dw_print.retrieve(sPumdtf,sPumdtt,sExgbn ,sExpCd) <= 0 then
//	f_messagechk(14,"")
//	return -1
//end if 
//dw_print.sharedata(dw_list)
//
//dw_ip.SetFocus()
Return 1
end function

on w_cic02080.create
int iCurrent
call super::create
this.dw_5=create dw_5
this.rr_1=create rr_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_5
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_1
end on

on w_cic02080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_5)
destroy(this.rr_1)
destroy(this.dw_1)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

//IF F_Authority_Chk(Gs_Dept) = -1 THEN			/*권한 체크- 현업 여부*/
//	IF F_Change_Saupj_Chk(Gs_Empno) = -1 THEN			
//		dw_ip.Modify("saupj.protect = 1")
//		//dw_ip.Modify("sawon.protect = 1")		
//	else 
//		dw_ip.Modify("saupj.protect = 0")
//		//dw_ip.Modify("sawon.protect = 0")		
//	end if 
//ELSE
//	dw_ip.Modify("saupj.protect = 0")
//	//dw_ip.Modify("sawon.protect = 0")	
//END IF	


end event

type p_xls from w_standard_print`p_xls within w_cic02080
integer x = 2779
integer y = 28
end type

type p_sort from w_standard_print`p_sort within w_cic02080
integer x = 2555
integer y = 12
end type

type p_preview from w_standard_print`p_preview within w_cic02080
integer x = 4087
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_cic02080
integer y = 16
end type

type p_print from w_standard_print`p_print within w_cic02080
integer x = 4261
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_cic02080
integer x = 3909
integer y = 8
end type

event p_retrieve::clicked;call super::clicked;String sItnbr_f, sItnbr_t
Long	 lRowcnt

If dw_ip.Accepttext() = -1 Then Return

sItnbr_f = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'Itnbr_f'))
//If sItnbr_f = "" Or IsNull(sItnbr_f) Then
//	f_messagechk(1, '[제품코드-FROM]')
//	dw_ip.SetColumn('Itnbr_f')
//	dw_ip.SetFocus()
//	Return
//End If

sItnbr_t = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'Itnbr_t'))
//If sItnbr_t = "" Or IsNull(sItnbr_t) Then
//	f_messagechk(1, '[제품코드-TO]')
//	dw_ip.SetColumn('Itnbr_t')
//	dw_ip.SetFocus()
//	Return
//End If

sItnbr_f = f_nvl(sItnbr_f, '%')
sItnbr_t = f_nvl(sItnbr_t, '%')


w_mdi_frame.sle_msg.Text = "조회 중입니다.!!!"
SetPointer(HourGlass!)
//dw_1.SetRedraw(False)
dw_1.Retrieve(sItnbr_f, sItnbr_t)
lRowcnt = dw_1.Rowcount()
If lRowcnt <=0 Then
	f_messagechk(14, '')
	dw_ip.SetFocus()
	//dw_1.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ""
	SetPointer(Arrow!)
	Return
Else
	dw_1.sharedata(dw_print)
	dw_1.SetFocus()
End If


//ShareData로 사용하여 dw_print를 조회시키기때문에 Share되지 않는 아규먼트 데이터 처리는 여기서 해줌
if sItnbr_f='%' and sItnbr_t="%" then 
   dw_print.object.t_arg_item.text = "제품코드:전체"
else
	dw_print.object.t_arg_item.text = "제품코드:" + sItnbr_f + ' - ' + sItnbr_t
end if


dw_1.SetRedraw(True)
w_mdi_frame.sle_msg.text = "조회가 완료되었습니다.!!!"
SetPointer(Arrow!)
end event







type st_10 from w_standard_print`st_10 within w_cic02080
end type

type gb_10 from w_standard_print`gb_10 within w_cic02080
integer width = 3589
end type

type dw_print from w_standard_print`dw_print within w_cic02080
integer x = 3305
integer y = 12
integer width = 210
integer height = 124
string dataobject = "d_cic02080_1_p"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_cic02080
integer x = 37
integer y = 8
integer width = 2363
integer height = 152
string dataobject = "dw_cic02080_10"
end type

event dw_ip::itemchanged;//string snull, sPumdtf,sPumdtt
//SetNull(snull)
//w_mdi_frame.sle_msg.text =""
//
//Choose Case This.GetColumnName()
//	Case 'PUMDTF'
//		sPumdtf = Trim(This.GetText())
//		If sPumdtf = "" Or IsNull(sPumdtf) Then Return
//		
////		If f_datechk(sPumdtf + '01') = -1 Then 
////			f_messagechk(21, '[년월-FROM]')
////			dw_IP.SetItem(1, 'PUMDTF', snull)
////			Return 1
////		End If
//	Case 'PUMDTT'
//		sPumdtt = Trim(This.GetText())
//		If sPumdtt = "" Or IsNull(sPumdtt) Then Return
//		
////		If f_datechk(sPumdtt + '01') = -1 Then 
////			f_messagechk(21, '[년월-FROM]')
////			dw_IP.SetItem(1, 'PUMDTT', snull)
////			Return 1
////		End If
//	Case Else
//		p_retrieve.TriggerEvent(Clicked!)
//End Choose
//
//




w_mdi_frame.sle_msg.text =""
//p_retrieve.TriggerEvent(Clicked!)

IF dwo.name = 'itnbr_t' then
   P_RETRIEVE.PostEvent(Clicked!)
END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

event dw_ip::rbuttondown;call super::rbuttondown;//제품코드 선택 팝업창
String ls_itnbr, ls_titnm, ls_itdsc
SetNull(gs_gubun)
if dwo.name = 'itnbr_f' or dwo.name='itnbr_t' then
	gs_gubun = '1'
	Open(w_itemas_popup10_cic)	
	if gs_gubun <> 'Y' OR ISNULL(gs_Gubun)  then  REturn 	
	dw_5.SettransObject(sqlca)
	dw_5.ReSet()
	dw_5.ImportClipboard()
	string ls_filter
	Int  li_row, li_Trow, li_seq
	ls_filter = "flag = 'Y'"
	dw_5.SetFilter(ls_filter)
	dw_5.filter()
	ls_itnbr = dw_5.GetitemString(1, "itemas_itnbr")	 
	IF dwo.name = 'itnbr_f' then
		this.object.itnbr_f[1] = ls_itnbr
	ELSEIF dwo.name = 'itnbr_t' then
		this.object.itnbr_t[1] = ls_itnbr
	END IF
	this.event rowfocuschanged(this.rowcount())
END IF
end event

type dw_list from w_standard_print`dw_list within w_cic02080
boolean visible = false
integer x = 3045
integer y = 4
integer width = 215
integer height = 144
string title = "제품 공정별 S/T 명세서"
string dataobject = "dw_cic02080_20_detail"
boolean border = false
boolean hsplitscroll = false
borderstyle borderstyle = styleraised!
end type

event dw_list::constructor;SETTRANSOBJECT(SQLCA)
end event

event dw_list::printstart;//
end event

event dw_list::rowfocuschanged;//
end event

event dw_list::u_key;//
end event

type dw_5 from datawindow within w_cic02080
boolean visible = false
integer x = 73
integer y = 712
integer width = 2642
integer height = 620
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_itemas_popup10_detail_cic"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_cic02080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 164
integer width = 4571
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_cic02080
integer x = 55
integer y = 176
integer width = 4530
integer height = 2016
integer taborder = 40
string title = "none"
string dataobject = "dw_cic02080_20_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event constructor;SETTRANSOBJECT(SQLCA)
end event

