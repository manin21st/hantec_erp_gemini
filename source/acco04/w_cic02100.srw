$PBExportHeader$w_cic02100.srw
$PBExportComments$경비집계표
forward
global type w_cic02100 from w_standard_print
end type
type rr_1 from roundrectangle within w_cic02100
end type
end forward

global type w_cic02100 from w_standard_print
integer x = 0
integer y = 0
string title = "경비집계표"
rr_1 rr_1
end type
global w_cic02100 w_cic02100

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

on w_cic02100.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cic02100.destroy
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
	
dw_ip.SetItem(1,"saupj",       Gs_Saupj)

//dw_ip.SetItem(1,"pumdtf",f_aftermonth( Left(f_today(),6), -1))
//dw_ip.SetItem(1,"pumdtt",f_aftermonth( Left(f_today(),6), -1))
dw_ip.SetItem(1,"pumdtf",sWorkym)
dw_ip.SetItem(1,"pumdtt",sWorkym)

dw_ip.SetItem(1,'data_gbn','2') //DEFAULT로 상세 체크

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

type p_xls from w_standard_print`p_xls within w_cic02100
end type

type p_sort from w_standard_print`p_sort within w_cic02100
end type

type p_preview from w_standard_print`p_preview within w_cic02100
integer y = 8
integer width = 183
end type

type p_exit from w_standard_print`p_exit within w_cic02100
integer y = 8
end type

type p_print from w_standard_print`p_print within w_cic02100
integer x = 4265
integer y = 8
end type

type p_retrieve from w_standard_print`p_retrieve within w_cic02100
integer x = 3918
integer y = 8
end type

event p_retrieve::clicked;call super::clicked;String sWorkymF, sWorkymT, sExp_gbn, sExpCd, sData_gbn, sGubun
Long	 lRowcnt

If dw_ip.Accepttext() = -1 Then Return

sWorkymF = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'PUMDTF'))
If sWorkymF = "" Or IsNull(sWorkymF) Then
	f_messagechk(1, '[년월-FROM]')
	dw_ip.SetColumn('PUMDTF')
	dw_ip.SetFocus()
	Return
End If

sWorkymT = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'PUMDTT'))
If sWorkymT = "" Or IsNull(sWorkymT) Then
	f_messagechk(1, '[년월-TO]')
	dw_ip.SetColumn('PUMDTT')
	dw_ip.SetFocus()
	Return
End If

sExp_gbn = dw_ip.Object.EXGBN[1]
sExp_gbn = f_nvl(sExp_gbn, '%') 

sExpCd = dw_ip.Object.EXP_CD[1]
sExpCd = f_nvl(sExpCd, '%') 

sData_gbn = dw_ip.Object.DATA_GBN[1]

sGubun = dw_ip.Object.GUBUN[1]

if sData_gbn='1' then //집계
   dw_list.dataobject = 'dw_cic02100_20_total'
	dw_print.dataobject = 'd_cic02100_1_p_total'
else                  //상세
	dw_list.dataobject = 'dw_cic02100_20_detail'
	dw_print.dataobject = 'd_cic02100_1_p_detail'
end if
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

dw_list.ShareData(dw_print)


w_mdi_frame.sle_msg.Text = "조회 중입니다.!!!"
SetPointer(HourGlass!)
dw_list.SetRedraw(False)
lRowcnt = dw_list.Retrieve(sWorkymF, sWorkymT, sExp_gbn, sExpCd, sData_gbn, sGubun)
If lRowcnt <=0 Then
	f_messagechk(14, '')
	dw_ip.SetFocus()
	dw_list.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ""
	SetPointer(Arrow!)
	Return
Else
	dw_list.sharedata(dw_print)
	dw_list.SetFocus()
End If


//ShareData로 사용하여 dw_print를 조회시키기때문에 Share되지 않는 아규먼트 데이터 처리는 여기서 해줌
dw_print.object.t_arg_data_ft.text = LEFT(sWorkymF,4) + '.' + RIGHT(sWorkymF,2) + ' - ' + LEFT(sWorkymT,4) + '.' + RIGHT(sWorkymT,2)
if sData_gbn='1' THEN
   dw_print.object.t_arg_data_gbn.text = '(집계)'
else
   dw_print.object.t_arg_data_gbn.text = '(상세)'
end if


dw_list.SetRedraw(True)
w_mdi_frame.sle_msg.text = "조회가 완료되었습니다.!!!"
SetPointer(Arrow!)
end event







type st_10 from w_standard_print`st_10 within w_cic02100
end type

type gb_10 from w_standard_print`gb_10 within w_cic02100
integer width = 3589
end type

type dw_print from w_standard_print`dw_print within w_cic02100
integer x = 3662
integer y = 24
integer width = 210
integer height = 148
string dataobject = "d_cic02100_1_p_detail"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_cic02100
integer x = 37
integer y = 8
integer width = 3547
integer height = 228
string dataobject = "dw_cic02100_10"
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

P_RETRIEVE.PostEvent(Clicked!)
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::losefocus;//dw_ip.AcceptText()
end event

event dw_ip::rbuttondown;call super::rbuttondown;//IF this.GetColumnName() ="sawon" THEN
//	 lstr_custom.code = ""
//	
//	OpenWithParm(W_KFZ04OM0_POPUP,'4')
//	
//	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
//	
//	this.SetItem(this.GetRow(),"sawon", lstr_custom.code)
//	this.SetItem(this.GetRow(),"sawonnm",lstr_custom.name)
//	
//	this.TriggerEvent(ItemChanged!)
//END IF
//
end event

event dw_ip::ue_pressenter;//
end event

event dw_ip::ue_key;//
end event

event dw_ip::ue_dwntabout;//
end event

type dw_list from w_standard_print`dw_list within w_cic02100
integer x = 55
integer y = 252
integer width = 4553
integer height = 1944
string title = "지출결의명세서"
string dataobject = "dw_cic02100_20_detail"
boolean border = false
boolean hsplitscroll = false
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_cic02100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 240
integer width = 4571
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

