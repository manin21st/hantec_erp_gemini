$PBExportHeader$w_cic02120.srw
$PBExportComments$재공품 평가명세서
forward
global type w_cic02120 from w_standard_print
end type
type rr_1 from roundrectangle within w_cic02120
end type
end forward

global type w_cic02120 from w_standard_print
integer x = 0
integer y = 0
string title = "재공품 평가명세서"
rr_1 rr_1
end type
global w_cic02120 w_cic02120

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

on w_cic02120.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cic02120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sWorkym

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)


SELECT  nvl(max(workym),substr(to_char(sysdate,'yyyymmdd'),1,6))
   INTO  :sWorkym
   FROM  cic0100;

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


//dw_ip.SetItem(1,"workym_f", f_aftermonth( Left(f_today(),6), -1))
//dw_ip.SetItem(1,"workym_t", f_aftermonth( Left(f_today(),6), -1))
dw_ip.SetItem(1,"workym_f", sWorkym)
dw_ip.SetItem(1,"workym_t", sWorkym )
end event

type p_xls from w_standard_print`p_xls within w_cic02120
end type

type p_sort from w_standard_print`p_sort within w_cic02120
end type

type p_preview from w_standard_print`p_preview within w_cic02120
integer y = 8
end type

type p_exit from w_standard_print`p_exit within w_cic02120
integer y = 8
end type

type p_print from w_standard_print`p_print within w_cic02120
integer x = 4265
integer y = 8
end type

type p_retrieve from w_standard_print`p_retrieve within w_cic02120
integer x = 3918
integer y = 8
end type

event p_retrieve::clicked;call super::clicked;String sWorkym_f, sWorkym_t
Long	 lRowcnt

If dw_ip.Accepttext() = -1 Then Return

//sItnbr_f = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'Itnbr_f'))
//If sItnbr_f = "" Or IsNull(sItnbr_f) Then
//	f_messagechk(1, '[제품코드-FROM]')
//	dw_ip.SetColumn('Itnbr_f')
//	dw_ip.SetFocus()
//	Return
//End If
//sItnbr_t = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'Itnbr_t'))
//If sItnbr_t = "" Or IsNull(sItnbr_t) Then
//	f_messagechk(1, '[제품코드-TO]')
//	dw_ip.SetColumn('Itnbr_t')
//	dw_ip.SetFocus()
//	Return
//End If

//sItnbr_f = f_nvl(sItnbr_f, '%')
//sItnbr_t = f_nvl(sItnbr_t, '%')


sWorkym_f = dw_ip.GetItemString(1, 'workym_f')
If sWorkym_f = "" Or IsNull(sWorkym_f) Then
	f_messagechk(1, '[조회일-From]')
	dw_ip.SetColumn('Workym_f')
	dw_ip.SetFocus()
	Return
End If

sWorkym_t = dw_ip.GetItemString(1, 'Workym_t')
If sWorkym_t = "" Or IsNull(sWorkym_t) Then
	f_messagechk(1, '[조회일-To]')
	dw_ip.SetColumn('Workym_t')
	dw_ip.SetFocus()
	Return
End If


w_mdi_frame.sle_msg.Text = "조회 중입니다.!!!"
SetPointer(HourGlass!)
dw_list.SetRedraw(False)
lRowcnt = dw_list.Retrieve(sWorkym_f, sWorkym_t)
If lRowcnt <=0 Then
	f_messagechk(14, '')
	dw_ip.SetFocus()
	dw_list.Reset()
	dw_list.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ""
	SetPointer(Arrow!)
	Return
Else
	//dw_list.sharedata(dw_print)
	//dw_list.SetFocus()
	dw_print.Retrieve(sWorkym_f, sWorkym_t)
End If


//ShareData로 사용하여 dw_print를 조회시키기때문에 Share되지 않는 아규먼트 데이터 처리는 여기서 해줌
//if sItnbr_f='%' and sItnbr_t="%" then 
//   dw_print.object.t_arg_item.text = "제품코드:전체"
//else
//	dw_print.object.t_arg_item.text = "제품코드:" + sItnbr_f + ' - ' + sItnbr_t
//end if

dw_print.object.t_arg_item.text = "조회일자:" + left(sWorkym_f,4) + '.'+ right(sWorkym_f,2) + ' - ' + left(sWorkym_t,4) + '.'+ right(sWorkym_t,2)


dw_list.SetRedraw(True)
w_mdi_frame.sle_msg.text = "조회가 완료되었습니다.!!!"
SetPointer(Arrow!)
end event







type st_10 from w_standard_print`st_10 within w_cic02120
end type

type gb_10 from w_standard_print`gb_10 within w_cic02120
integer width = 3589
end type

type dw_print from w_standard_print`dw_print within w_cic02120
integer x = 3662
integer y = 24
integer width = 210
integer height = 148
string dataobject = "d_cic02120_1_p"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_cic02120
integer x = 37
integer y = 8
integer width = 3547
integer height = 152
string dataobject = "dw_cic02120_10"
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

event dw_ip::itemfocuschanged;call super::itemfocuschanged;//dw_ip.SelectText(1, len(dw_ip.gettext())+2)


end event

event dw_ip::getfocus;call super::getfocus;//dw_ip.SelectText(1, len(dw_ip.gettext())+2)
end event

type dw_list from w_standard_print`dw_list within w_cic02120
integer x = 55
integer y = 176
integer width = 4553
integer height = 2016
string title = "재공품 평가명세서"
string dataobject = "dw_cic02120_20_detail"
boolean border = false
boolean hsplitscroll = false
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_cic02120
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

