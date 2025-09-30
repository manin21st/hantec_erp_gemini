$PBExportHeader$w_sm40_0050.srw
$PBExportComments$납입검수 등록
forward
global type w_sm40_0050 from w_inherite
end type
type dw_1 from u_key_enter within w_sm40_0050
end type
type rr_1 from roundrectangle within w_sm40_0050
end type
type cbx_1 from checkbox within w_sm40_0050
end type
type pb_1 from u_pb_cal within w_sm40_0050
end type
type pb_2 from u_pb_cal within w_sm40_0050
end type
type dw_2 from datawindow within w_sm40_0050
end type
type st_2 from statictext within w_sm40_0050
end type
type dw_3 from datawindow within w_sm40_0050
end type
type rr_2 from roundrectangle within w_sm40_0050
end type
type st_3 from statictext within w_sm40_0050
end type
type p_2 from uo_picture within w_sm40_0050
end type
type pb_check from picturebutton within w_sm40_0050
end type
type cb_1 from commandbutton within w_sm40_0050
end type
type st_4 from statictext within w_sm40_0050
end type
type cb_2 from commandbutton within w_sm40_0050
end type
type dw_gumsu from u_d_select_sort within w_sm40_0050
end type
type dw_imhist from u_d_select_sort within w_sm40_0050
end type
type st_bar from statictext within w_sm40_0050
end type
type hpb_1 from hprogressbar within w_sm40_0050
end type
type p_1 from uo_excel_down within w_sm40_0050
end type
type pb_3 from picturebutton within w_sm40_0050
end type
type pb_4 from picturebutton within w_sm40_0050
end type
type pb_5 from picturebutton within w_sm40_0050
end type
type st_5 from statictext within w_sm40_0050
end type
type cb_3 from commandbutton within w_sm40_0050
end type
type cb_4 from commandbutton within w_sm40_0050
end type
end forward

global type w_sm40_0050 from w_inherite
integer width = 5504
integer height = 3464
string title = "일 검수 확정(정상출고)"
string is_saupcd = "10"
dw_1 dw_1
rr_1 rr_1
cbx_1 cbx_1
pb_1 pb_1
pb_2 pb_2
dw_2 dw_2
st_2 st_2
dw_3 dw_3
rr_2 rr_2
st_3 st_3
p_2 p_2
pb_check pb_check
cb_1 cb_1
st_4 st_4
cb_2 cb_2
dw_gumsu dw_gumsu
dw_imhist dw_imhist
st_bar st_bar
hpb_1 hpb_1
p_1 p_1
pb_3 pb_3
pb_4 pb_4
pb_5 pb_5
st_5 st_5
cb_3 cb_3
cb_4 cb_4
end type
global w_sm40_0050 w_sm40_0050

forward prototypes
public function integer wf_require_chk (string ar_dataobject)
public subroutine wf_filter2 ()
public subroutine wf_filter1 ()
public subroutine wf_select_row (long arg_row)
end prototypes

public function integer wf_require_chk (string ar_dataobject);If ar_dataobject = "d_sm40_0010_1" Then
	
	Long ll_rcnt
	String ls_start , ls_start_time , ls_arrive , ls_arrive_time ,ls_carno
	
	ll_rcnt = dw_1.RowCount()
	If dw_1.AcceptText() < 1 Then Return -1
	If ll_rcnt <  1 Then Return -1
	
	ls_start 	   =  Trim(dw_1.Object.start_dt[1])
	ls_start_time  =  Trim(dw_1.Object.start_time[1])
	ls_arrive      =  Trim(dw_1.Object.arriv_dt[1])
	ls_arrive_time =  Trim(dw_1.Object.arriv_time[1])
	
	ls_carno = Trim(dw_1.Object.trans_carno[1])
	
	If ls_start = '' Or isNull(ls_start) Or f_datechk(ls_start) < 1 Then
		f_message_chk(35,'[출발일자]')
		dw_1.SetFocus()
		dw_1.SetColumn("start_dt")
		Return -1
	End if
	
	If ls_arrive = '' Or isNull(ls_arrive) Or f_datechk(ls_arrive) < 1 Then
		f_message_chk(35,'[도착일자]')
		dw_1.SetFocus()
		dw_1.SetColumn("arriv_dt")
		Return -1
	End if
	
	If ls_carno = '' Or isNull(ls_carno)  Then
		f_message_chk(36,'[차량번호]')
		dw_1.SetFocus()
		dw_1.SetColumn("trans_carno")
		Return -1
	End if
	
End If

Return 1

	
end function

public subroutine wf_filter2 ();If dw_1.AcceptText() < 1 Then Return
If dw_3.AcceptText() < 1 Then Return

String ls_gubun1 , ls_gubun2 , ls_gubun3
String ls_str1 , ls_str2

ls_gubun3 = Trim(dw_3.Object.gubun[1])

If ls_gubun3 = '%' Then
	ls_str2 = ''
Else
	ls_str2 = "yebi1_temp = '"+ls_gubun3+"' "
End iF

If dw_imhist.RowCount() > 0 Then 
	
	dw_imhist.SetFilter(ls_str2)
	dw_imhist.Filter()
	dw_imhist.GroupCalc()

End If

end subroutine

public subroutine wf_filter1 ();If dw_1.AcceptText() < 1 Then Return
If dw_2.AcceptText() < 1 Then Return

String ls_gubun1 , ls_gubun2 , ls_gubun3
String ls_str1 , ls_str2

ls_gubun2 = Trim(dw_2.Object.gubun[1])

If ls_gubun2 = 'Y' then
	ls_str1 = "citnbr = 'Y'"
ElseIf ls_gubun2 = 'N' then
	ls_str1 = "isnull(citnbr) or citnbr = 'N'"
Else
	ls_str1 =""
End if


If dw_gumsu.RowCount() > 0 Then 
	
	dw_gumsu.SetFilter(ls_str1)
	dw_gumsu.Filter()
   
	dw_gumsu.GroupCalc()

End If


	
end subroutine

public subroutine wf_select_row (long arg_row);dw_gumsu.SelectRow(0, FALSE)
if arg_row <= 0 then return
dw_gumsu.SelectRow(arg_row, TRUE)

String ls_saupj , ls_itnbr 
String ls_order_no ,ls_ipno ,ls_factory, ls_iojpno, ls_ipdate
Long   i,ll_f, ll_ipno
Decimal	ld_qty

ls_iojpno = Trim(dw_gumsu.Object.iojpno[arg_row])
ls_factory = Trim(dw_gumsu.Object.factory[arg_row])		//공장
ls_order_no = Trim(dw_gumsu.Object.orderno[arg_row])
ls_itnbr = Trim(dw_gumsu.Object.mitnbr[arg_row])			//품번
ld_qty = dw_gumsu.Object.ipqty[arg_row]						//수량
ls_ipdate = Trim(dw_gumsu.Object.ipdate[arg_row])		    // 검수일자
//ll_ipno = Long(dw_gumsu.Object.ipno[arg_row])
ls_ipno 	  = dw_gumsu.object.ipno[arg_row]
if ls_ipno <> '.' and  ls_ipno <> '' then
	ls_ipno = '00'+ls_ipno
end if

dw_imhist.SelectRow(0, FALSE)

if ld_qty > 0 and isnull(ls_iojpno) or ls_iojpno = '' then
	i = 1
	Do While True
		if len(ls_factory) = 4 then 
			// 새로운 공장코드 4자리는 검수일자, 공장, 품번,수량이 일치하는 것을 찾는다.
		
			ll_f = dw_imhist.Find("sudat = '"+ls_ipdate+"' and itnbr = '"+ls_itnbr+"' and facgbn = '"+ls_factory + &
										 "' and ioqty="+String(ld_qty),i,dw_imhist.RowCount() )
				
		else
			
			ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+"' and loteno = '"+ls_ipno + &
										 "' and ioqty="+String(ld_qty),i,dw_imhist.RowCount() )
										 
			// 발주항번이 있는 경우 다시 한번 검색
			if ll_f = 0 and ls_ipno >= '.' then
				ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+"' and loteno = '000000'" + &
											 " and ioqty="+String(ld_qty),i,dw_imhist.RowCount() )
			end if			

         end if
		
		// MOBIS A/S 는 발주번호 기준으로 다시 한번 검색
		if ll_f = 0 and ls_factory = 'MAS' then
			ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+"' and ioqty="+String(ld_qty) &
										,i,dw_imhist.RowCount() )
		end if			

		If ll_f > 0 Then
			dw_imhist.SelectRow(ll_f,True)
			dw_imhist.ScrollToRow(ll_f)
			i = ll_f+1
			
			if i > dw_imhist.RowCount() then Exit
		Else
			Exit
		End iF
	Loop

else
	// 서열인 경우
	ll_f = dw_imhist.Find("iojpno = '"+ls_iojpno+"'",1,dw_imhist.RowCount())
	If ll_f > 0 Then
		dw_imhist.SelectRow(ll_f,True)
		dw_imhist.ScrollToRow(ll_f)
	End iF
end if

w_mdi_frame.sle_msg.text = ls_order_no
end subroutine

on w_sm40_0050.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_2=create dw_2
this.st_2=create st_2
this.dw_3=create dw_3
this.rr_2=create rr_2
this.st_3=create st_3
this.p_2=create p_2
this.pb_check=create pb_check
this.cb_1=create cb_1
this.st_4=create st_4
this.cb_2=create cb_2
this.dw_gumsu=create dw_gumsu
this.dw_imhist=create dw_imhist
this.st_bar=create st_bar
this.hpb_1=create hpb_1
this.p_1=create p_1
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_5=create pb_5
this.st_5=create st_5
this.cb_3=create cb_3
this.cb_4=create cb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.dw_3
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.p_2
this.Control[iCurrent+12]=this.pb_check
this.Control[iCurrent+13]=this.cb_1
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.cb_2
this.Control[iCurrent+16]=this.dw_gumsu
this.Control[iCurrent+17]=this.dw_imhist
this.Control[iCurrent+18]=this.st_bar
this.Control[iCurrent+19]=this.hpb_1
this.Control[iCurrent+20]=this.p_1
this.Control[iCurrent+21]=this.pb_3
this.Control[iCurrent+22]=this.pb_4
this.Control[iCurrent+23]=this.pb_5
this.Control[iCurrent+24]=this.st_5
this.Control[iCurrent+25]=this.cb_3
this.Control[iCurrent+26]=this.cb_4
end on

on w_sm40_0050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.dw_3)
destroy(this.rr_2)
destroy(this.st_3)
destroy(this.p_2)
destroy(this.pb_check)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.cb_2)
destroy(this.dw_gumsu)
destroy(this.dw_imhist)
destroy(this.st_bar)
destroy(this.hpb_1)
destroy(this.p_1)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.st_5)
destroy(this.cb_3)
destroy(this.cb_4)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_gumsu.SetTransObject(SQLCA)
dw_imhist.SetTransObject(SQLCA)

dw_1.InsertRow(0)
dw_2.InsertRow(0)
dw_3.InsertRow(0)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If

dw_1.Object.sdate[1] = Left(is_today , 6) + '01' 
dw_1.Object.edate[1] = is_today
dw_2.Object.sdate[1] = Left(is_today , 6) + '01' 
dw_2.Object.edate[1] = is_today
dw_3.Object.sdate[1] = Left(is_today , 6) + '01' 
dw_3.Object.edate[1] = is_today

hpb_1.visible = False
st_bar.visible = False

//iMaxOrderNo = sqlca.fun_junpyo(gs_sabu,sOrderDate,sOrderGbn)
//	IF iMaxOrderNo <= 0 THEN
//		ROLLBACK;
//		f_message_chk(51,'')
//		SetNull(sOrderNo)
//		Return sOrderNo
//	END IF
//	
//	sOrderNo = sOrderDate + String(iMaxOrderNo,'000')
end event

type dw_insert from w_inherite`dw_insert within w_sm40_0050
boolean visible = false
integer x = 2834
integer y = 0
integer width = 709
integer height = 116
integer taborder = 140
string dataobject = "d_sm40_0050_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

type p_delrow from w_inherite`p_delrow within w_sm40_0050
boolean visible = false
integer x = 4978
integer y = 152
integer taborder = 70
end type

type p_addrow from w_inherite`p_addrow within w_sm40_0050
boolean visible = false
integer x = 3749
integer y = 32
integer taborder = 60
end type

type p_search from w_inherite`p_search within w_sm40_0050
boolean visible = false
integer x = 4704
integer y = 392
integer taborder = 120
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm40_0050
boolean visible = false
integer x = 5381
integer y = 432
integer taborder = 40
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm40_0050
integer y = 32
integer taborder = 110
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_sm40_0050
integer y = 32
integer taborder = 100
end type

event p_can::clicked;call super::clicked;
dw_gumsu.SetFilter("")
dw_gumsu.Filter()

dw_imhist.SetFilter("")
dw_imhist.Filter()

dw_gumsu.Reset()
dw_imhist.Reset()

cb_4.Enabled = False
end event

type p_print from w_inherite`p_print within w_sm40_0050
boolean visible = false
integer x = 5097
integer y = 148
integer taborder = 130
end type

type p_inq from w_inherite`p_inq within w_sm40_0050
integer x = 3922
integer y = 32
end type

event p_inq::clicked;String ls_saupj , ls_factory , ls_sdate , ls_edate , ls_itnbr ,ls_gubun ,ls_gubun2

If dw_1.AcceptText() < 1 Then Return
If dw_2.AcceptText() < 1 Then Return
If dw_3.AcceptText() < 1 Then Return

ls_saupj = Trim(dw_1.Object.saupj[1])
//ls_sdate = Trim(dw_1.Object.sdate[1])
//ls_edate = Trim(dw_1.Object.edate[1])
ls_factory = Trim(dw_1.Object.factory[1])
ls_itnbr = Trim(dw_1.Object.itnbr[1])

cb_4.Enabled = False

If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'
If ls_factory = 'MAS' Then
	dw_gumsu.dataobject = 'd_sm40_0050_m'
Else
	dw_gumsu.dataobject = 'd_sm40_0050_a'
End If

dw_gumsu.settransobject(sqlca)


If ls_itnbr = '' Or isNull(ls_itnbr)  Then ls_itnbr = '%'

//If IsNull(ls_sdate) Or ls_sdate = '' Then
//	f_message_chk(1400,'[기간-시작일자]')
//	dw_1.SetColumn("sdate")
//	dw_1.SetFocus()
//	Return
//End If
//
//If IsNull(ls_edate) Or ls_edate = '' Then
//	f_message_chk(1400,'[기간-종료일자]')
//	dw_1.SetColumn("sdate")
//	dw_1.SetFocus()
//	Return
//End If

/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If


ls_sdate = Trim(dw_2.Object.sdate[1])
ls_edate = Trim(dw_2.Object.edate[1])

If IsNull(ls_sdate) Or ls_sdate = '' Then
	f_message_chk(1400,'[기간-시작일자]')
	dw_2.SetColumn("sdate")
	dw_2.SetFocus()
	Return
End If

If IsNull(ls_edate) Or ls_edate = '' Then
	f_message_chk(1400,'[기간-종료일자]')
	dw_2.SetColumn("sdate")
	dw_2.SetFocus()
	Return
End If

//if ls_factory = 'HK21' OR ls_factory = 'HK11' then
	//f_message_chk(1400,'[공장]')
	//MessageBox ( '참고', 'CKD HK21, HK11 공장인 경우는 발주번호 정보가 없으므로 출고등록에서 자동 출고 됩니다.' ) 
	//dw_2.SetColumn("factory")
	//dw_2.SetFocus()
	//Return
//end if

dw_gumsu.SetRedraw(False)

If dw_gumsu.Retrieve(ls_saupj, ls_factory , ls_sdate ,ls_edate , ls_itnbr+'%' ) <= 0 Then
	
	f_message_chk(50,'')
Else
	wf_filter1()
End If

dw_gumsu.SetRedraw(True)


ls_sdate = Trim(dw_3.Object.sdate[1])
ls_edate = Trim(dw_3.Object.edate[1])

If IsNull(ls_sdate) Or ls_sdate = '' Then
	f_message_chk(1400,'[기간-시작일자]')
	dw_3.SetColumn("sdate")
	dw_3.SetFocus()
	Return
End If

If IsNull(ls_edate) Or ls_edate = '' Then
	f_message_chk(1400,'[기간-종료일자]')
	dw_3.SetColumn("sdate")
	dw_3.SetFocus()
	Return
End If

dw_imhist.SetRedraw(False)

If dw_imhist.Retrieve(ls_saupj, ls_factory ,ls_sdate ,ls_edate, ls_itnbr+'%'  ) <= 0 Then
	
	f_message_chk(50,'')
Else
	wf_filter2()
End If

dw_imhist.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm40_0050
boolean visible = false
integer x = 5106
integer y = 192
integer taborder = 90
end type

type p_mod from w_inherite`p_mod within w_sm40_0050
integer x = 4096
integer y = 32
integer taborder = 80
end type

event p_mod::clicked;call super::clicked;If dw_gumsu.AcceptText() < 1 Then Return
If dw_imhist.AcceptText() < 1 Then Return

//If dw_gumsu.RowCount() < 1 Then Return
//If dw_imhist.RowCount() < 1 Then Return
If dw_gumsu.ModifiedCount() < 1 and dw_imhist.ModifiedCount() < 1 Then Return

If f_msg_Update() < 1 Then Return

dec  ld_prc , ld_ioprc
LOng i ,ll_qty , ll_f, ll_ipseq, ll_subseq, ll_jaitno
string ls_saupj , ls_sdate , ls_edate
String ls_citnbr , ls_citnbr_temp ,ls_null , ls_van, ls_doccode, ls_custcd, ls_factory, ls_itnbr, ls_ipno, ls_ipsource, ls_jajeno, ls_gumeno
String ls_orderno ,ls_iojpno ,ls_sale_mayymm

SetNull(ls_null)

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_sdate = Trim(dw_1.Object.sdate[1])
ls_edate = Trim(dw_1.Object.edate[1])

//for i= 1 To dw_gumsu.RowCount()
//	
//	ls_citnbr = Trim(dw_gumsu.Object.citnbr[i])
//	ls_citnbr_temp = Trim(dw_gumsu.Object.citnbr_temp[i])
//	ls_orderno = Trim(dw_gumsu.Object.orderno[i])
//	ld_prc = dw_gumsu.Object.ipdan[i]
//	
//	If ls_citnbr = 'Y' and ls_citnbr_temp = 'N' Then
//		ls_iojpno = Trim(dw_gumsu.Object.imhist_iojpno[i])
//		
//		If ls_iojpno = '' or isNull(ls_iojpno) Then
//			MessageBox('확인','출하전표를 입력하세요.')
//			dw_gumsu.ScrollToRow(i)
//			dw_gumsu.SetColumn("imhist_iojpno")
//			dw_gumsu.SetFocus()
//			REturn
//		End if 
//		
//		ll_f = dw_imhist.find("iojpno = '"+ls_iojpno+"'" , 1, dw_imhist.rowcount())
//		
//		If ll_f > 0 Then
//			
//			ls_sale_mayymm = dw_imhist.object.sale_mayymm[ll_f]
//			
//			if isNull(ls_sale_mayymm) = false Then
//				MessageBox('확인','확정된 매출전표입니다. 검수대사에서 제외처리 됩니다.')
//			 	continue ;
//			end if
//			
//			ld_ioprc = dw_imhist.object.ioprc[ll_f]
//			
//			If ld_prc <> ld_ioprc Then
//				dw_imhist.object.ioprc[ll_f] = ld_prc
//			End if
//			
//			dw_imhist.object.ip_jpno[ll_f] = ls_orderno
//			dw_imhist.object.yebi1[ll_f] = ls_edate
//		End if
//
//		
//	Elseif ls_citnbr = 'N' and ls_citnbr_temp = 'Y' Then
//		ls_iojpno = Trim(dw_gumsu.Object.imhist_iojpno[i])
//		
//		If ls_iojpno = '' or isNull(ls_iojpno) Then
//			MessageBox('확인','출하전표를 입력하세요.')
//			dw_gumsu.ScrollToRow(i)
//			dw_gumsu.SetColumn("imhist_iojpno")
//			dw_gumsu.SetFocus()
//			REturn
//		End if 
//		
//		ll_f = dw_imhist.find("iojpno = '"+ls_iojpno+"'" , 1, dw_imhist.rowcount())
//			
//		If ll_f > 0 Then
//			
//			ls_sale_mayymm = dw_imhist.object.sale_mayymm[ll_f]
//			
//			if isNull(ls_sale_mayymm) = false Then
//				MessageBox('확인','확정된 매출전표입니다. 검수대사에서 제외처리 됩니다.')
//			 	continue ;
//			end if
//		
//			dw_imhist.object.yebi1[ll_f] = ls_null
//		End if
//	End if
//Next
	
	
// 20101213 검수 테이블의 증가로 부득이 FOR 로 전환
//If dw_gumsu.Update() < 1 Then
//	Rollback;
//	MessageBox('저장확인-검수', '자료 저장 중 오류가 발생했습니다.')
//	Return
//End if

String  ls_fact
ls_fact = Trim(dw_1.Object.factory[1])
If ls_fact = 'MAS' Then
	/* 모비스 A/S 처리 - BY SHINGOON 2013.01.31 */
	String  ls_seq, ls_inym, ls_brncd
	For i = 1 To dw_gumsu.RowCount()
		ls_citnbr = Trim(dw_gumsu.Object.citnbr[i])
		ls_brncd = dw_gumsu.Object.MINC_BRNCD[i]
		ls_inym = dw_gumsu.Object.MINC_IN_YM[i]
		ls_seq = dw_gumsu.Object.ipno[i]
		
		UPDATE VAN_MOBIS_OR
		      SET CITNBR = :ls_citnbr
		 WHERE MINC_BRNCD = :ls_brncd
		      AND MINC_IN_YM = :ls_inym
			  AND MINC_IN_SEQ = :ls_seq ;
		IF SQLCA.SQLCODE <> 0	THEN
			Rollback;
			MessageBox('저장확인-검수[MAS]', '자료 저장 중 오류가 발생했습니다.~r~r~n~n['+String(SQLCA.SQLCODE)+']~r~n'+SQLCA.SQLERRTEXT)
			Return
		END IF
		
	Next
Else
	/* 모비스A/S 외 처리 - by shingoon 2013.01.31 */
	for i= 1 To dw_gumsu.RowCount()
		
		ls_citnbr = Trim(dw_gumsu.Object.citnbr[i])
		ls_citnbr_temp = Trim(dw_gumsu.Object.old_citnbr[i])
		ls_van = Trim(dw_gumsu.Object.van[i])
		
		ls_doccode = dw_gumsu.Object.doccode[i]
		ls_custcd = dw_gumsu.Object.custcd[i]
		ls_factory = dw_gumsu.Object.factory[i]
		ls_itnbr = dw_gumsu.Object.itnbr[i]
		ls_ipno = dw_gumsu.Object.ipno[i]
		ls_ipsource = dw_gumsu.Object.ipsource[i]
		ls_orderno = dw_gumsu.Object.orderno[i]
		ll_ipseq = dw_gumsu.Object.ipseq[i]
		ll_subseq = dw_gumsu.Object.subseq[i]
		ls_jajeno = dw_gumsu.Object.jajeno[i]
		ll_jaitno = dw_gumsu.Object.jaitno[i]
		ls_gumeno = dw_gumsu.Object.gumeno[i]
					
		if ls_citnbr <> ls_citnbr_temp then
			if ls_van = 'HKCD1' then
				UPDATE VAN_HKCD1 SET CITNBR = :ls_citnbr
				WHERE SABU = :gs_sabu
					 AND DOCCODE = :ls_doccode
					 AND CUSTCD = :ls_custcd
					AND FACTORY = :ls_factory
					AND ITNBR = :ls_itnbr
					AND IPNO = :ls_ipno
					AND IPSOURCE = :ls_ipsource
					AND ORDERNO = :ls_orderno
					AND IPSEQ = :ll_ipseq
					AND SUBSEQ = :ll_subseq;
				IF SQLCA.SQLCODE <> 0	THEN
					Rollback;
					MessageBox('저장확인-검수[HKCD1]', '자료 저장 중 오류가 발생했습니다.~r~r~n~n['+String(SQLCA.SQLCODE)+']~r~n'+SQLCA.SQLERRTEXT)
					Return
				END IF
			elseif  ls_van = 'ERPD1' then
				UPDATE VAN_ERPD1 SET CITNBR = :ls_citnbr
				WHERE SABU = :gs_sabu
					 AND DOCCODE = :ls_doccode
					 AND CUSTCD = :ls_custcd
					AND FACTORY = :ls_factory
					AND ITNBR = :ls_itnbr
					AND JAJENO = :ls_jajeno
					AND JAITNO = :ll_jaitno
					AND IPSOURCE = :ls_ipsource;
				IF SQLCA.SQLCODE <> 0	THEN
					Rollback;
					MessageBox('저장확인-검수[ERPD1]', '자료 저장 중 오류가 발생했습니다.~r~r~n~n['+String(SQLCA.SQLCODE)+']~r~n'+SQLCA.SQLERRTEXT)
					Return
				END IF
			elseif  ls_van = 'CKDD1' then
				UPDATE VAN_CKDD1 SET CITNBR = :ls_citnbr
				WHERE SABU = :gs_sabu
					 AND DOCCODE = :ls_doccode
					 AND CUSTCD = :ls_custcd
					AND FACTORY = :ls_factory
					AND ITNBR = :ls_itnbr
					AND GUMENO = :ls_gumeno;
				IF SQLCA.SQLCODE <> 0	THEN
					Rollback;
					MessageBox('저장확인-검수[CKDD1]', '자료 저장 중 오류가 발생했습니다.~r~r~n~n['+String(SQLCA.SQLCODE)+']~r~n'+SQLCA.SQLERRTEXT)
					Return
				END IF
			end if
		end if
	
	Next
End If

IF SQLCA.SQLCODE <> 0	THEN
	Rollback;
	MessageBox('저장확인-검수', '자료 저장 중 오류가 발생했습니다.~r~r~n~n['+String(SQLCA.SQLCODE)+']~r~n'+SQLCA.SQLERRTEXT)
	Return
END IF

If dw_imhist.Update() < 1 Then
	Rollback;
	MessageBox('저장확인-매출', '자료 저장 중 오류가 발생했습니다.')
	Return
End if

Commit;
p_inq.TriggerEvent(Clicked!)

//f_mdi_msg("저장 완료 하였습니다.")





		
	 
	
	
	
	

end event

type cb_exit from w_inherite`cb_exit within w_sm40_0050
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm40_0050
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm40_0050
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm40_0050
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm40_0050
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm40_0050
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm40_0050
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm40_0050
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm40_0050
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm40_0050
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm40_0050
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm40_0050
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm40_0050
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm40_0050
boolean visible = true
end type

type dw_1 from u_key_enter within w_sm40_0050
integer x = 14
integer y = 24
integer width = 2697
integer height = 268
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sm40_0050_1"
boolean border = false
end type

event itemchanged;String ls_value
Long   nCnt


Choose Case GetColumnName()
	Case "gubun"
		ls_value =Trim( GetText())
		If isNUll(ls_value) = false Then
			
		End If

	Case "sdate"
		ls_value =Trim( GetText())
		
		dw_2.SetItem(1, 'sdate', ls_value)
		dw_3.SetItem(1, 'sdate', ls_value)

	Case "edate"
		ls_value =Trim( GetText())
		
		dw_2.SetItem(1, 'edate', ls_value)
		dw_3.SetItem(1, 'edate', ls_value)

End Choose
end event

event itemerror;call super::itemerror;RETURN 1
end event

event rbuttondown;call super::rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

//IF this.GetColumnName() = "cvcod" THEN
//	gs_code = this.GetText()
//	IF Gs_code ="" OR IsNull(gs_code) THEN 
//		gs_code =""
//	END IF
//	
////	gs_gubun = '2'
//	Open(w_vndmst_popup)
//	
//	IF isnull(gs_Code)  or  gs_Code = ''	then  
//		this.SetItem(lrow, "cvcod", snull)
//		this.SetItem(lrow, "cvnas", snull)
//   	return
//   ELSE
//		lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
//		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
//			f_message_chk(37,'[거래처]') 
//			this.SetItem(lRow, "cvcod", sNull)
//		   this.SetItem(lRow, "cvnas", sNull)
//			RETURN  1
//		END IF
//   END IF	
//
//	this.SetItem(lrow, "cvcod", gs_Code)
//	this.SetItem(lrow, "cvnas", gs_Codename)
//END IF
//
end event

type rr_1 from roundrectangle within w_sm40_0050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 308
integer width = 2217
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_1 from checkbox within w_sm40_0050
boolean visible = false
integer x = 3703
integer y = 400
integer width = 795
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품목별 주간계획(가전) 확인"
end type

event clicked;String syymm, sCust, sDate, eDate, sCvcod, sSaupj

syymm  = trim(dw_1.getitemstring(1, 'yymm'))
sCust  = trim(dw_1.getitemstring(1, 'cust'))
sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
If IsNull(sCvcod) Then sCvcod = ''

If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

If This.Checked = false Then
	dw_imhist.DataObject = 'd_sm01_03010_3'
	dw_imhist.SetTransObject(sqlca)
	
	If dw_imhist.Retrieve(sSaupj, syymm, sCust, sCvcod+'%') <= 0 Then
		f_message_chk(50,'')
	End If	
Else
	dw_imhist.DataObject = 'd_sm01_03010_lg_1'
	dw_imhist.SetTransObject(sqlca)
	
	select week_sdate, week_ldate into :sdate, :edate from pdtweek where week_sdate = :syymm;
	
	If dw_imhist.Retrieve(sSaupj, sDate, eDate) <= 0 Then
		f_message_chk(50,'')
	End If
End If
end event

type pb_1 from u_pb_cal within w_sm40_0050
integer x = 1952
integer y = 64
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdate', gs_code)
dw_2.SetItem(1, 'sdate', gs_code)
dw_3.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_sm40_0050
integer x = 2523
integer y = 64
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'edate', gs_code)
dw_2.SetItem(1, 'edate', gs_code)
dw_3.SetItem(1, 'edate', gs_code)

end event

type dw_2 from datawindow within w_sm40_0050
integer x = 379
integer y = 320
integer width = 1856
integer height = 72
integer taborder = 50
string title = "none"
string dataobject = "d_sm40_0050_2"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_value
Long   nCnt

String ls_gubun1 , ls_str1

AcceptText()
Choose Case GetColumnName()
	Case "gubun"
		ls_value =Trim( GetText())
		If isNUll(ls_value) = false Then

			If ls_value = 'Y' then
				ls_str1 = "citnbr = 'Y'"
			ElseIf ls_value = 'N' then
				ls_str1 = "isnull(citnbr) or citnbr = 'N'"
			Else
				ls_str1 =""
			End if
		
			dw_gumsu.SetFilter(ls_str1)
			dw_gumsu.Filter()
			dw_gumsu.GroupCalc()
			
		End If
		
End Choose
end event

type st_2 from statictext within w_sm40_0050
integer x = 46
integer y = 332
integer width = 315
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "[D1 자료]"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_sm40_0050
integer x = 2725
integer y = 324
integer width = 1861
integer height = 72
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0050_2_2"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_value
Long   nCnt

String ls_gubun1 , ls_str2

Choose Case GetColumnName()
	Case "gubun"
		ls_value =Trim( GetText())
		If isNUll(ls_value) = false Then

			If ls_value = '%' Then
				ls_str2 = ""
			Else
				ls_str2 = "yebi1_temp = '"+ls_value+"' "
			End iF
			
			dw_imhist.SetFilter(ls_str2)
			dw_imhist.Filter()
			dw_imhist.GroupCalc()
			
		End If
		
End Choose
end event

type rr_2 from roundrectangle within w_sm40_0050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2391
integer y = 308
integer width = 2217
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_3 from statictext within w_sm40_0050
integer x = 2395
integer y = 332
integer width = 320
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "[매출자료]"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_2 from uo_picture within w_sm40_0050
boolean visible = false
integer x = 5010
integer y = 392
integer width = 315
boolean bringtotop = true
string picturename = "C:\erpman\image\납품검수대사취소_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\납품검수대사취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\납품검수대사취소_dn.gif"
end event

type pb_check from picturebutton within w_sm40_0050
integer x = 2277
integer y = 328
integer width = 82
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\next.gif"
alignment htextalign = left!
string powertiptext = "선택된 D1 기준으로 출하자료 검수 지정"
end type

event clicked;String ls_saupj , ls_itnbr 
String ls_order_no ,ls_ipno ,ls_factory, ls_ipdate
String s_cod
Long 	 i, j, k=0, ll_f
decimal	dqty

for i = 1 to dw_gumsu.RowCount()
	if dw_gumsu.IsSelected (i) then
		k = i
		EXIT
	end if	
next	
if k = 0 then 
	messagebox('확인','D1 검수자료를 먼저 선택하십시오.')
	return
END IF

/* D1검수 시 단가 갱신 요청 - by shingoon 2013.01.14 */
Decimal  ldc_prc
ls_ipdate = Trim(dw_gumsu.Object.ipdate[k])
ldc_prc = dw_gumsu.GetItemDecimal(k, 'ipdan')
If IsNull(ldc_prc) Then ldc_prc = 0

for i = 1 to dw_imhist.RowCount()
	if dw_imhist.IsSelected (i) then
		dw_imhist.setitem(i,'yebi1_temp','Y')
		dw_imhist.setitem(i,'yebi1',ls_ipdate)
		dw_imhist.SetItem(i, 'ioprc', ldc_prc)
		dw_gumsu.Object.citnbr[k] = 'Y'
	end if	
next	

dw_gumsu.SelectRow(0,False)
dw_imhist.SelectRow(0,False)

//ls_order_no = Trim(dw_gumsu.Object.orderno[k])
//if isnull(ls_order_no) or ls_order_no = '.' then return
//
//dqty = dw_gumsu.Object.ipqty[k]
//if dqty <= 0 then return
//	
//ls_itnbr = Trim(dw_gumsu.Object.mitnbr[k])
//ls_ipdate = Trim(dw_gumsu.Object.ipdate[k])
//ls_ipno 	  = dw_gumsu.object.ipno[k]
//if ls_ipno <> '.' then
//	ls_ipno = '00'+ls_ipno
//end if
//
//i = 1
//Do While True
//	ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+"' and loteno = '"+ls_ipno+"'" &
//								 ,i,dw_imhist.RowCount() )
//								 
//	// 발주항번이 있는 경우 다시 한번 검색
//	if ll_f = 0 and ls_ipno > '.' then
//		ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+"' and loteno = '000000'" &
//									 ,i,dw_imhist.RowCount() )
//	end if			
//
//   If ll_f > 0 Then
//		dw_imhist.setitem(ll_f,'yebi1_temp','Y')
//		dw_imhist.setitem(ll_f,'yebi1',ls_ipdate)
//		i = ll_f+1
//		
//		if i > dw_imhist.RowCount() then Exit
//	Else
//		Exit
//	End iF	
////Loop
//
//dw_gumsu.SelectRow(0,False)
//dw_imhist.SelectRow(0,False)


//String s_cod
//Long i, j, k
//
//for i = 1 to dw_imhist.RowCount()
//	if dw_imhist.IsSelected (i) then
//		k = i
//		EXIT
//	end if	
//next	
//
//if IsNull(k) or k = 0 then 
//	f_message_chk(36,"[출고전표]")
//   return
//else
//	s_cod = dw_imhist.object.iojpno[k]
//	
//end if
//
//for i = 1 to dw_gumsu.RowCount()
//	if dw_gumsu.IsSelected (i) then
//		dw_gumsu.object.imhist_iojpno[i] = s_cod
//	   dw_gumsu.object.citnbr[i] = 'Y'
//	end if	
//next	
//
//dw_gumsu.SelectRow(0,False)
//dw_imhist.SelectRow(0,False)
end event

type cb_1 from commandbutton within w_sm40_0050
boolean visible = false
integer x = 2222
integer y = 192
integer width = 457
integer height = 116
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "D1 자동체크 (전체대상)"
end type

event clicked;String ls_saupj , ls_sdate , ls_edate , ls_itnbr ,ls_gubun ,ls_gubun2 ,ls_lclgbn ,ls_null
String ls_order_no ,ls_ipno ,ls_factory ,ls_curr ,ls_cvcod ,ls_iojpno ,ls_ipsource, ls_ipdate
Long   ll_qty ,ll_out_qty 
Double ld_dan , ld_amt , ld_out_amt , ld_pack_amt , ld_pacdan
Long   ll_cnt = 0 ,ll_count, ll_ipno
long ll_qty_t , ll_out_qty_t

Long ll_bar , i ,ll_f

If dw_1.AcceptText() < 1 Then Return
If dw_2.AcceptText() < 1 Then Return

pointer oldpointer

oldpointer = SetPointer(HourGlass!)

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_sdate = Trim(dw_1.Object.sdate[1])
ls_edate = Trim(dw_1.Object.edate[1])
ls_itnbr = Trim(dw_1.Object.itnbr[1])

ls_gubun = Trim(dw_2.Object.gubun[1])
ls_gubun2 = Trim(dw_3.Object.gubun[1])

If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'
If ls_itnbr = '' Or isNull(ls_itnbr)  Then ls_itnbr = '%'

If IsNull(ls_sdate) Or ls_sdate = '' Then
	f_message_chk(1400,'[기간-시작일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return
End If

If IsNull(ls_edate) Or ls_edate = '' Then
	f_message_chk(1400,'[기간-종료일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return
End If

/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

st_bar.visible = True

// 상계처리 검수완료 =============================

UPDATE VAN_HKCD1 SET citnbr = 'Y'
WHERE ipgubun  IN ( 'A','EE','LD') AND ORDERNO = '.'
 AND ipdate >= :ls_sdate ;
 
If sqlca.sqlnrows > 0 Then
	commit ;
End iF

UPDATE VAN_HKCD1 C SET CITNBR = 'Y'
WHERE (C.MITNBR , C.FACTORY , C.IPDATE , C.ORDERNO )
      IN (SELECT A.MITNBR ,
					  A.FACTORY ,
					  A.IPDATE ,
					  A.ORDERNO 
				FROM (SELECT *
						  FROM VAN_HKCD1 
						 WHERE FACTORY = 'Y' 
							AND ipdate > :ls_sdate 
							AND IPGUBUN = 'EE' AND IPSOURCE = 'D') A ,
					  (SELECT *
						  FROM VAN_HKCD1 
						 WHERE FACTORY = 'Y' 
							AND ipdate > :ls_sdate 
							AND IPGUBUN IS NULL AND IPSOURCE = 'E'   ) B
			 WHERE A.MITNBR = B.MITNBR
			   AND A.FACTORY = B.FACTORY
			   AND A.IPDATE = B.IPDATE
			   AND A.ORDERNO = B.ORDERNO
			   AND A.IPQTY + B.IPQTY = 0 
				  ) ;
If sqlca.sqlnrows > 0 Then
	commit ;
End iF


dw_gumsu.SetRedraw(False)
dw_imhist.SetRedraw(False)

If dw_gumsu.Retrieve(ls_saupj, '%' , ls_sdate ,ls_edate , '%' ) <= 0 Then
	
Else
	// 무조건 새로 진행 - 송병호 - 2006.12.21
//	dw_gumsu.SetFilter( "citnbr = 'N'")
//	dw_gumsu.Filter()
End If

If dw_imhist.Retrieve(ls_saupj, '%' ,f_afterday( ls_sdate , -1 )  ,f_afterday( ls_edate , -1 ),'%'  ) <= 0 Then

Else
	// 무조건 새로 진행 - 송병호 - 2006.12.21
//	dw_imhist.SetFilter( "yebi1_temp = 'N' AND isNull(sale_mayymm) ")
//	dw_imhist.Filter()
End If

ll_bar =  dw_gumsu.RowCount()

hpb_1.visible = True
st_bar.visible = True
hpb_1.maxposition =  100
hpb_1.setstep = 1
hpb_1.position = 0

// 1차 전일실적으로 찾는다 ./////////////////////////////////////

For i = 1 To ll_bar
	
	
	ls_order_no  = Trim(dw_gumsu.object.orderno[i]) 
	ls_factory = Trim(dw_gumsu.object.factory[i])
	ls_itnbr   = Trim(dw_gumsu.object.mitnbr[i])
	ls_ipdate  = Trim(dw_gumsu.object.ipdate[i])
	ll_qty     = dw_gumsu.object.ipqty[i]
	ls_ipno 	  = dw_gumsu.object.ipno[i]
	if ls_ipno <> '.' then
		ls_ipno = '00'+ls_ipno
	end if
	
	
	st_bar.text = ls_itnbr + "  " + string(ll_qty) + '  ' +ls_order_no
	
	ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and facgbn = '"+ls_factory+"' and " + &
	                      "itnbr = '"+ls_itnbr+"' and ioqty = "+string(ll_qty)+" and loteno = '"+ls_ipno+"'", &
								1 , dw_imhist.RowCount() )
								
	// 발주항번이 있는 경우 다시 한번 검색
	if ll_f = 0 and ls_ipno >= '.' then
		ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and facgbn = '"+ls_factory+"' and " + &
									 "itnbr = '"+ls_itnbr+"' and ioqty = "+string(ll_qty)+" and loteno = '000000'", &
									1 , dw_imhist.RowCount() )
	end if
	
	If ll_f < 1 Then Continue;
	
	String ls_yebi1_temp
	ls_yebi1_temp = dw_imhist.GetItemString(ll_f, 'yebi1_temp')
	/* 사용자가 확정지정해서 저장한 경우 보존 (서선주) - 2007.01.23 */
//	If ll_f > 0 and dw_imhist.object.yebi1_temp[ll_f] = 'N' Then
	If ll_f > 0 and ls_yebi1_temp = 'N' Then
//	If ll_f > 0 Then
		
		dw_imhist.object.yebi1_temp[ll_f] = 'Y'
//		dw_imhist.object.yebi1[ll_f] = ls_edate
	
		ls_iojpno = Trim(dw_imhist.object.iojpno[ll_f])
		ld_amt    = dw_imhist.object.ioamt[ll_f]
		
		ld_out_amt = dw_gumsu.object.ipamt[i]
		//ld_pack_amt = Truncate(dw_gumsu.object.packdan[i] *  dw_gumsu.object.packqty[i],0)
		ld_pacdan = dw_gumsu.object.packdan[i]
		
		ls_ipsource = dw_gumsu.object.ipsource[i]
		
		//dw_gumsu.object.citnbr_temp[i] = 'Y'
		dw_gumsu.object.citnbr[i] = 'Y'
//		dw_gumsu.object.imhist_iojpno[i] = ls_iojpno
		
	
//		If ld_out_amt  <> ld_amt AND  ( ls_factory = 'Y' or ls_factory = 'L1') Then 
//			ld_dan = Round( dw_gumsu.object.ipamt[i]  / ll_qty , 2 )
//			dw_imhist.object.ioprc[ll_f] = ld_dan
//			dw_imhist.object.ioamt[ll_f] = dw_gumsu.object.ipamt[i]
//		
//		End if


			/* 출고단가=입고단가+포장단가 - 한텍 - 2006.12.20 - 송병호 */
			dw_imhist.object.ioprc[ll_f] = dw_gumsu.object.ipdan[i] + ld_pacdan
			dw_imhist.object.ioamt[ll_f] = dw_gumsu.object.ipamt[i]
			
			dw_imhist.object.yebi1[ll_f] = ls_ipdate		// 입고일자 기준 - 송병호 - 2006.12.21

			dw_imhist.object.pacprc[ll_f] = ld_pacdan
			dw_imhist.object.lclgbn[ll_f] = ls_ipsource
			
		
	Else
		
//		dw_gumsu.object.citnbr[i] = 'N' 
		
//		ls_iojpno = Trim(dw_gumsu.object.imhist_iojpno[i])
//		
//		If isNull(ls_iojpno) = false Then 
//			
//			Update imhist Set yebi1 = :ls_null
//							 where sabu = :gs_sabu
//								and iojpno = :ls_iojpno ;
//								
//			If sqlca.sqlcode <> 0 Then
//				Messagebox('확인',sqlca.sqlerrText)
//				Rollback;
//				Return
//			End if
//		End if
		
	End if
	
	Yield()
	hpb_1.position = int((i/ll_bar)*100)
							  
Next


st_bar.text = " 검수확인 자료를 저장하고 있습니다....."

dw_imhist.AcceptText()
If dw_imhist.Update() <> 1 Then
	MessageBox('dw_imhist',sqlca.sqlerrText)
	Rollback;
	hpb_1.visible = false
	st_bar.visible = false
	Return
End iF

dw_gumsu.AcceptText()
If dw_gumsu.Update() <> 1 Then
	MessageBox('dw_gumsu',sqlca.sqlerrText)
	Rollback;
	hpb_1.visible = false
	st_bar.visible = false
	Return
End iF

COMMIT;

//datastore ld1
//
//ld1 = Create DataStore
//
//ld1.Dataobject = 'd_sm40_0055_d1'
//ld1.SetTransObject(SQLCA)
//
//ld1.Retrieve(ls_saupj , ls_sdate , ls_edate)
//
//For i = 1 To ld1.Rowcount()
//	ld1.object.imhist_ioprc[i] = Round(ld1.object.van_hkcd1_ipamt[i] / ld1.object.van_hkcd1_ipqty[i],2)
//	ld1.object.imhist_ioamt[i] = ld1.object.van_hkcd1_ipamt[i]
//Next
//
//If ld1.Update() <> 1 Then
//	MessageBox('ld1',sqlca.sqlerrText)
//	Rollback;
//	hpb_1.visible = false
//	st_bar.visible = false
//	Return
//End iF
//
//commit ;

dw_gumsu.SetRedraw(True)
dw_imhist.SetRedraw(True)

hpb_1.visible = false
st_bar.visible = false

p_inq.TriggerEvent(Clicked!)



end event

type st_4 from statictext within w_sm40_0050
integer x = 3470
integer y = 192
integer width = 1166
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "* 일검수는 정상출고만 대상으로 합니다."
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_sm40_0050
integer x = 2738
integer y = 32
integer width = 709
integer height = 116
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "D1 자동체크 (수량일치)"
end type

event clicked;long		lrow, lfind
string	siojpno, ls_sdate, ls_edate, ls_gdate, snull

setnull(snull)

dw_2.setitem(1,'gubun','%')
dw_2.triggerevent(itemchanged!)

dw_3.setitem(1,'gubun','%')
dw_3.triggerevent(itemchanged!)

p_inq.triggerevent(clicked!)

ls_sdate = Trim(dw_2.Object.sdate[1])
ls_edate = Trim(dw_2.Object.edate[1])

SETPOINTER(HOURGLASS!)
/* 사용자가 확정지정해서 저장한 경우 보존 (서선주) - 2007.01.23 */
//dw_imhist.setredraw(false)
//FOR lrow = 1 TO dw_imhist.rowcount()
//	ls_gdate = dw_imhist.getitemstring(lrow,'yebi1')
//	dw_imhist.setitem(lrow,'yebi1_temp','N')
//	if ls_sdate <= ls_gdate and ls_edate >= ls_gdate then
//		dw_imhist.setitem(lrow,'yebi1',snull)
//	end if
//NEXT
//dw_imhist.setredraw(true)

FOR lrow = 1 TO dw_gumsu.rowcount()
	siojpno = dw_gumsu.getitemstring(lrow,'iojpno')
//	if not isnull(siojpno) then
//		dw_gumsu.setitem(lrow,'citnbr','N')
//	end if
	
	SETPOINTER(HOURGLASS!)
	
	dw_gumsu.setrow(lrow)
	dw_gumsu.scrolltorow(lrow)
	wf_select_row(lrow)
//	dw_gumsu.trigger event clicked(0, 0, lrow, dw_gumsu.object)
	
	lfind = dw_imhist.getselectedrow(0)
	if lfind > 0 then
		/* 사용자가 확정지정해서 저장한 경우 보존 (서선주) - 2007.01.23 */
		if dw_imhist.getitemstring(lfind,'yebi1_temp') = 'Y' then continue
		pb_check.triggerevent(clicked!)
	end if
	
	Yield()
NEXT

SETPOINTER(ARROW!)

cb_4.Enabled = True
end event

type dw_gumsu from u_d_select_sort within w_sm40_0050
integer x = 41
integer y = 400
integer width = 2194
integer height = 1920
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sm40_0050_a"
boolean border = false
boolean hsplitscroll = true
end type

event clicked;call super::clicked;if row <= 0 then return

String ls_saupj , ls_itnbr 
String ls_order_no ,ls_ipno ,ls_factory, ls_iojpno, ls_ipdate
Long   i,ll_f, ll_ipno
Decimal	ld_qty

ls_iojpno = Trim(This.Object.iojpno[row])
ls_factory = Trim(This.Object.factory[row])
ls_order_no = Trim(This.Object.orderno[row])
ls_itnbr = Trim(This.Object.mitnbr[row])
ld_qty = This.Object.ipqty[row]
ls_ipdate = Trim(This.Object.ipdate[row])
//ll_ipno = Long(This.Object.ipno[row])
ls_ipno 	  = dw_gumsu.object.ipno[row]
if ls_ipno <> '.' then
	ls_ipno = '00'+ls_ipno
end if

dw_imhist.SelectRow(0, FALSE)

if ld_qty > 0 and isnull(ls_iojpno) or ls_iojpno = '' then
	i = 1
	Do While True
		
		if len(ls_factory) = 4 then 
			// 새로운 공장코드 4자리는 검수일자, 공장, 품번,수량이 일치하는 것을 찾는다.
		
			ll_f = dw_imhist.Find("sudat = '"+ls_ipdate+"' and itnbr = '"+ls_itnbr+"' and facgbn = '"+ls_factory + &
										 "' and ioqty="+String(ld_qty),i,dw_imhist.RowCount() )
				
		else
			
			ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+"' and loteno = '"+ls_ipno+"'",i,dw_imhist.RowCount() )
										 
			// 발주항번이 있는 경우 다시 한번 검색
			if ll_f = 0 and ls_ipno >= '.' then
				ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+"' and loteno = '000000'",i,dw_imhist.RowCount() )
			end if		
			
		end if
		
		// MOBIS A/S 는 발주번호 기준으로 다시 한번 검색
		if ll_f = 0 and ls_factory = 'MAS' then
			ll_f = dw_imhist.Find("lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+"'",i,dw_imhist.RowCount() )
		end if			

		If ll_f > 0 Then
			dw_imhist.SelectRow(ll_f,True)
			dw_imhist.ScrollToRow(ll_f)
			i = ll_f+1
			
			if i > dw_imhist.RowCount() then Exit
		Else
			Exit
		End iF
	Loop
else
	// 서열인 경우
	ll_f = dw_imhist.Find("iojpno = '"+ls_iojpno+"'",1,dw_imhist.RowCount())
	If ll_f > 0 Then
		dw_imhist.SelectRow(ll_f,True)
		dw_imhist.ScrollToRow(ll_f)
	End iF
end if

w_mdi_frame.sle_msg.text = ls_order_no
end event

type dw_imhist from u_d_select_sort within w_sm40_0050
integer x = 2395
integer y = 400
integer width = 2194
integer height = 1920
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sm40_0050_b"
boolean border = false
boolean hsplitscroll = true
end type

event itemchanged;call super::itemchanged;Dec  dmmqty, davg
Long nJucha, ix, nRow
Int  ireturn
String sitnbr, sitdsc, sispec, sjijil, sispec_code, s_cvcod, snull, get_nm

setnull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
//	Case 'itnbr'
//		sItnbr = trim(this.GetText())
//	
//		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
//		setitem(nrow, "itnbr", sitnbr)	
//		setitem(nrow, "itemas_itdsc", sitdsc)
//		
//		Post wf_danga(nrow)
//		
//		RETURN ireturn
//	Case 'cvcod'
//		s_cvcod = this.GetText()								
//		 
//		if s_cvcod = "" or isnull(s_cvcod) then 
//			this.setitem(nrow, 'vndmst_cvnas2', snull)
//			return 
//		end if
//		
//		SELECT "VNDMST"."CVNAS2"  
//		  INTO :get_nm  
//		  FROM "VNDMST"  
//		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
//	
//		if sqlca.sqlcode = 0 then 
//			this.setitem(nrow, 'vndmst_cvnas2', get_nm)
//		else
//			this.triggerevent(RbuttonDown!)
//			return 1
//		end if
//		
//		Post wf_danga(nrow)
	Case "isqty_temp"
		
	Case "yebi1_temp"
		get_nm = trim(this.GetText())
		if get_nm = 'N' then
			this.setitem(nrow, 'yebi1', snull)
		else
			this.setitem(nrow, 'yebi1', this.getitemstring(nrow,'yebi1_old'))
		end if

End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event clicked;call super::clicked;long		i
decimal	ld_sumqty

for i = 1 to dw_imhist.RowCount()
	if dw_imhist.IsSelected (i) then
		ld_sumqty = ld_sumqty + dw_imhist.Object.ioqty[i]
	end if	
next	

dw_imhist.Object.t_sumqty.text = String(ld_sumqty,'#,##0')

if row > 0 then
	w_mdi_frame.sle_msg.text = dw_imhist.Object.lotsno[row]
end if
end event

type st_bar from statictext within w_sm40_0050
integer x = 1161
integer y = 1196
integer width = 2533
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "데이타를 처리하고 있습니다....."
alignment alignment = center!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_sm40_0050
integer x = 1641
integer y = 1076
integer width = 1573
integer height = 80
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type p_1 from uo_excel_down within w_sm40_0050
integer x = 3570
integer y = 32
boolean bringtotop = true
end type

event clicked;call super::clicked;Integer	irtn

irtn = MessageBox('확인','D1 검수자료 다운로드는 <예>,~n출하 자료 다운로드는 <아니오>', &
								Question!, YesNoCancel!, 1)
If irtn = 3 Then Return

If irtn = 1 Then
	uf_excel_down(dw_gumsu)
Else
	uf_excel_down(dw_imhist)
End If
	
end event

type pb_3 from picturebutton within w_sm40_0050
integer x = 2277
integer y = 1596
integer width = 87
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\paperfd.gif"
alignment htextalign = left!
string powertiptext = "D1 검수수량과 출고수량이 다른 자료 표시"
end type

event clicked;String ls_saupj , ls_str1
String ls_factory, ls_itnbr , ls_order_no ,ls_ipno ,ls_iojpno, ls_ipdate
String lsp_factory, lsp_itnbr , lsp_order_no ,lsp_ipno
Long   i,ll_f, ll_g, ll_ipno, lrow
decimal	ld_qty, ld_sumqty, ld_sumioqty

setpointer(hourglass!)

dw_2.setitem(1,'gubun','%')
dw_2.triggerevent(itemchanged!)

dw_3.setitem(1,'gubun','%')
dw_3.triggerevent(itemchanged!)

dw_gumsu.SetRedraw(false)
for lrow = 1 to dw_gumsu.rowcount()
	dw_gumsu.setitem(lrow,'qty_diff','N')
next
dw_gumsu.SetSort("factory A, itnbr A, orderno A, ipno A")
dw_gumsu.Sort()


dw_gumsu.SetRedraw(false)
for lrow = 1 to dw_imhist.rowcount()
	dw_imhist.setitem(lrow,'qty_diff','N')
next
dw_imhist.SetSort("facgbn A, itnbr A, lotsno A, loteno A")
dw_imhist.Sort()

lsp_factory	= ' '
lsp_itnbr	= ' '
lsp_order_no= ' '
lsp_ipno		= ' '

FOR lrow = 1 TO dw_gumsu.rowcount()
	ls_iojpno = Trim(dw_gumsu.Object.iojpno[lrow])
	ls_factory = Trim(dw_gumsu.Object.factory[lrow])
	ls_order_no = Trim(dw_gumsu.Object.orderno[lrow])
	ls_itnbr = Trim(dw_gumsu.Object.mitnbr[lrow])
	lsp_ipno	  = dw_gumsu.object.ipno[lrow]
	ls_ipno 	  = dw_gumsu.object.ipno[lrow]
	ls_ipdate = Trim(dw_gumsu.Object.ipdate[lrow])

	ld_qty = dw_gumsu.object.ipqty[lrow]
	if ld_qty <= 0 then continue


	IF isnull(ls_iojpno) OR ls_iojpno = '' THEN
		//-----------------------------------------------------------------------
		// 검수수량 SUM
		i = 1
		ld_sumqty = 0
		Do While True
			if len(ls_factory) = 4 then 
				// 새로운 공장코드 4자리는 검수일자, 공장, 품번,수량이 일치하는 것을 찾는다.
			
				ll_g = dw_gumsu.Find("factory = '"+ls_factory+"' and ipdate = '"+ls_ipdate+"' and mitnbr = '"+ls_itnbr+"'",i,dw_gumsu.RowCount() )
					
			else
				
				ll_g = dw_gumsu.Find("factory = '"+ls_factory+"' and orderno = '"+ls_order_no+"' and mitnbr = '"+ls_itnbr+ &
											"' and ipno = '"+ls_ipno+"'",i,dw_gumsu.RowCount() )
             end if
										 
			If ll_g > 0 Then
				ld_sumqty = ld_sumqty + dw_gumsu.object.ipqty[ll_g]
				i = ll_g+1				
				if i > dw_gumsu.RowCount() then Exit
			Else
				Exit
			End iF
		Loop
		lrow = i
		//-----------------------------------------------------------------------
		
		
		if ls_ipno <> '.' then
			ls_ipno = '00'+ls_ipno
		end if


		i = 1
		ld_sumioqty = 0
		Do While True
			if len(ls_factory) = 4 then 
				// 새로운 공장코드 4자리는 검수일자, 공장, 품번,수량이 일치하는 것을 찾는다.
			
				ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and sudat = '"+ls_ipdate+"' and itnbr = '"+ls_itnbr+"'",i,dw_imhist.RowCount() )
					
			else
				
				ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+ &
												"' and loteno = '"+ls_ipno+"'",i,dw_imhist.RowCount() )
											 
				// 발주항번이 있는 경우 다시 한번 검색
				if ll_f = 0 and ls_ipno >= '.' then
					ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+ &
													"' and loteno = '000000'",i,dw_imhist.RowCount() )
				end if
				
			end if
			
			If ll_f > 0 Then
				ld_sumioqty = ld_sumioqty + dw_imhist.object.ioqty[ll_f]
				i = ll_f+1				
				if i > dw_imhist.RowCount() then Exit
			Else
				Exit
			End iF
		Loop


		//-----------------------------------------------------------------------
		// SUM 한 수량이 틀릴 경우
		If ld_sumioqty > 0 and ld_sumqty <> ld_sumioqty Then
			i = 1
			Do While True
				if len(ls_factory) = 4 then 
					// 새로운 공장코드 4자리는장, 품번으로 대충 일치하는 것을 찾는다.
				
					ll_f = dw_gumsu.Find("factory = '"+ls_factory+"' and mitnbr = '"+ls_itnbr+"'",i,dw_gumsu.RowCount() )
						
				else
					
					ll_f = dw_gumsu.Find("factory = '"+ls_factory+"' and orderno = '"+ls_order_no+"' and mitnbr = '"+ls_itnbr+ &
												"' and ipno = '"+lsp_ipno+"'",i,dw_gumsu.RowCount() )
				end if
											 
				If ll_f > 0 Then
					dw_gumsu.object.qty_diff[ll_f] = 'Y'
					i = ll_f+1				
					if i > dw_gumsu.RowCount() then Exit
				Else
					Exit
				End iF
			Loop
			//-----------------------------------------------------------------------
			i = 1
			Do While True
				if len(ls_factory) = 4 then 
					// 새로운 공장코드 4자리는장, 품번으로 대충 일치하는 것을 찾는다.
				
					ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and itnbr = '"+ls_itnbr+"'",i,dw_imhist.RowCount() )
						
				else
					
					ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+ &
													"' and loteno = '"+ls_ipno+"'",i,dw_imhist.RowCount() )
												 
					// 발주항번이 있는 경우 다시 한번 검색
					if ll_f = 0 and ls_ipno >= '.' then
						ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+ &
														"' and loteno = '000000'",i,dw_imhist.RowCount() )
					end if
					
				end if
				
				// MOBIS A/S 는 발주번호 기준으로 다시 한번 검색
				if ll_f = 0 and ls_factory = 'MAS' then
					ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+ &
													"'",i,dw_imhist.RowCount() )
				end if			

				If ll_f > 0 Then
					dw_imhist.object.qty_diff[ll_f] = 'Y'
					i = ll_f+1				
					if i > dw_imhist.RowCount() then Exit
				Else
					Exit
				End iF
			Loop
		End If				

	END IF

	if lrow > dw_gumsu.RowCount() then Exit
NEXT

dw_gumsu.SetFilter("qty_diff='Y'")
dw_gumsu.Filter()
dw_gumsu.SetRedraw(true)

dw_imhist.SetFilter("qty_diff='Y'")
dw_imhist.Filter()
dw_imhist.SetRedraw(true)
end event

type pb_4 from picturebutton within w_sm40_0050
integer x = 2277
integer y = 1692
integer width = 87
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\13_LAST.BMP"
alignment htextalign = left!
string powertiptext = "D1 자료중 조회된 출하자료에 없는 자료 표시"
end type

event clicked;String ls_saupj , ls_str1
String ls_factory, ls_itnbr , ls_order_no ,ls_ipno ,ls_iojpno, ls_ipdate
String lsp_factory, lsp_itnbr , lsp_order_no ,lsp_ipno
Long   i,ll_f, ll_g, ll_ipno, lrow
decimal	ld_qty, ld_sumqty, ld_sumioqty

setpointer(hourglass!)

dw_2.setitem(1,'gubun','%')
dw_2.triggerevent(itemchanged!)

dw_3.setitem(1,'gubun','%')
dw_3.triggerevent(itemchanged!)

dw_gumsu.SetRedraw(false)
for lrow = 1 to dw_gumsu.rowcount()
	dw_gumsu.setitem(lrow,'qty_diff','N')
next

dw_gumsu.SetRedraw(false)
FOR lrow = 1 TO dw_gumsu.rowcount()
	ls_iojpno = Trim(dw_gumsu.Object.iojpno[lrow])
	ls_factory = Trim(dw_gumsu.Object.factory[lrow])
	ls_order_no = Trim(dw_gumsu.Object.orderno[lrow])
	ls_itnbr = Trim(dw_gumsu.Object.mitnbr[lrow])
	ls_ipno 	  = dw_gumsu.object.ipno[lrow]
	ls_ipdate = Trim(dw_gumsu.Object.ipdate[lrow])

	ld_qty = dw_gumsu.object.ipqty[lrow]
	if ld_qty <= 0 then continue

	IF isnull(ls_iojpno) OR ls_iojpno = '' THEN
		if ls_ipno <> '.' then
			ls_ipno = '00'+ls_ipno
		end if

		i = 1
		ll_g = 0
		Do While True
			
			if len(ls_factory) = 4 then 
				// 새로운 공장코드 4자리는 검수일자, 공장, 품번,수량이 일치하는 것을 찾는다.
			
				ll_f = dw_imhist.Find("sudat = '"+ls_ipdate+"' and itnbr = '"+ls_itnbr+"' and facgbn = '"+ls_factory + &
											 "' and ioqty="+String(ld_qty),i,dw_imhist.RowCount() )
					
			else
			
				ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+ &
												"' and loteno = '"+ls_ipno+"'",i,dw_imhist.RowCount() )
											 
				// 발주항번이 있는 경우 다시 한번 검색
				if ll_f = 0 and ls_ipno >= '.' then
					ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+ &
													"' and loteno = '000000'",i,dw_imhist.RowCount() )
				end if
				
			end if
			
			// MOBIS A/S 는 발주번호 기준으로 다시 한번 검색
			if ll_f = 0 and ls_factory = 'MAS' then
				ll_f = dw_imhist.Find("facgbn = '"+ls_factory+"' and lotsno = '"+ls_order_no+"' and itnbr = '"+ls_itnbr+ &
												"'",i,dw_imhist.RowCount() )
			end if			

			If ll_f > 0 Then
				ll_g++
				i = ll_f+1				
				if i > dw_imhist.RowCount() then Exit
			Else
				Exit
			End iF
		Loop

		if ll_g = 0 then dw_gumsu.object.qty_diff[lrow] = 'Y'
	ELSE
		// 서열인 경우
		ll_f = dw_imhist.Find("iojpno = '"+ls_iojpno+"'",1,dw_imhist.RowCount())
		If ll_f > 0 Then
		Else
			dw_gumsu.object.qty_diff[lrow] = 'Y'
		End iF
	END IF
NEXT

dw_gumsu.SetFilter("qty_diff='Y'")
dw_gumsu.Filter()
dw_gumsu.SetRedraw(true)
end event

type pb_5 from picturebutton within w_sm40_0050
integer x = 2277
integer y = 1788
integer width = 87
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\13_FIRST.BMP"
alignment htextalign = left!
string powertiptext = "출하자료중 D1 자료에 없는 자료 표시"
end type

event clicked;String ls_saupj , ls_str1
String ls_factory, ls_itnbr , ls_order_no ,ls_ipno ,ls_iojpno
String lsp_factory, lsp_itnbr , lsp_order_no ,lsp_ipno
Long   i,ll_f, ll_g, ll_ipno, lrow
decimal	ld_qty, ld_sumqty, ld_sumioqty

setpointer(hourglass!)

dw_2.setitem(1,'gubun','%')
dw_2.triggerevent(itemchanged!)

dw_3.setitem(1,'gubun','%')
dw_3.triggerevent(itemchanged!)

dw_imhist.SetRedraw(false)
for lrow = 1 to dw_imhist.rowcount()
	dw_imhist.setitem(lrow,'qty_diff','N')
next

dw_imhist.SetRedraw(false)
FOR lrow = 1 TO dw_imhist.rowcount()
	ls_iojpno = Trim(dw_imhist.Object.iojpno[lrow])
	ls_factory = Trim(dw_imhist.Object.facgbn[lrow])
	ls_order_no = Trim(dw_imhist.Object.lotsno[lrow])
	ls_itnbr = Trim(dw_imhist.Object.itnbr[lrow])
	ls_ipno 	  = dw_imhist.object.loteno[lrow]

	ld_qty = dw_imhist.object.ioqty[lrow]
	if ld_qty <= 0 then continue

	// 서열인 경우
	ll_f = dw_gumsu.Find("iojpno = '"+ls_iojpno+"'",1,dw_gumsu.RowCount())
	If ll_f > 0 Then
	Else
		if ls_ipno <> '.' then
			ls_ipno = Right(ls_ipno,4)
		end if

		i = 1
		ll_g = 0
		Do While True
			if len(ls_factory) = 4 then 
				// 새로운 공장코드 4자리는 공장, 품번,수량이 일치하는 것을 찾는다.
			
				ll_f = dw_gumsu.Find("factory = '"+ls_factory+"' and mitnbr = '"+ls_itnbr+ "' and ipqty="+String(ld_qty),i,dw_gumsu.RowCount() )											 
					
			else
			
				ll_f = dw_gumsu.Find("factory = '"+ls_factory+"' and orderno = '"+ls_order_no+"' and mitnbr = '"+ls_itnbr+ &
												"' and ipno = '"+ls_ipno+"'",i,dw_gumsu.RowCount() )
											 
				// 발주항번이 있는 경우 다시 한번 검색
				if ll_f = 0 and ls_ipno >= '.' then
					ll_f = dw_gumsu.Find("factory = '"+ls_factory+"' and orderno = '"+ls_order_no+"' and mitnbr = '"+ls_itnbr+ &
													"' and ipno = '.'",i,dw_gumsu.RowCount() )
				end if
			end if
			
			// MOBIS A/S 는 발주번호 기준으로 다시 한번 검색
			if ll_f = 0 and ls_factory = 'MAS' then
				ll_f = dw_gumsu.Find("factory = '"+ls_factory+"' and orderno = '"+ls_order_no+"' and mitnbr = '"+ls_itnbr+ &
												"'",i,dw_gumsu.RowCount() )
			end if			

			If ll_f > 0 Then
				ll_g++
				i = ll_f+1				
				if i > dw_gumsu.RowCount() then Exit
			Else
				Exit
			End iF
		Loop

		if ll_g = 0 then dw_imhist.object.qty_diff[lrow] = 'Y'
	End iF
NEXT

dw_imhist.SetFilter("qty_diff='Y'")
dw_imhist.Filter()
dw_imhist.SetRedraw(true)
end event

type st_5 from statictext within w_sm40_0050
integer x = 3470
integer y = 252
integer width = 1417
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "* MOBIS A/S 는 개별 처리해야 합니다."
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_sm40_0050
boolean visible = false
integer x = 2222
integer y = 140
integer width = 475
integer height = 116
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "D1 자동체크 (조회대상)"
end type

event clicked;long		lrow, lfind
string	siojpno, ls_sdate, ls_edate, ls_gdate, snull

setnull(snull)

dw_2.setitem(1,'gubun','%')
dw_2.triggerevent(itemchanged!)

dw_3.setitem(1,'gubun','%')
dw_3.triggerevent(itemchanged!)

p_inq.triggerevent(clicked!)

ls_sdate = Trim(dw_2.Object.sdate[1])
ls_edate = Trim(dw_2.Object.edate[1])

SETPOINTER(HOURGLASS!)
/* 사용자가 확정지정해서 저장한 경우 보존 (서선주) - 2007.01.23 */
//dw_imhist.setredraw(false)
//FOR lrow = 1 TO dw_imhist.rowcount()
//	ls_gdate = dw_imhist.getitemstring(lrow,'yebi1')
//	dw_imhist.setitem(lrow,'yebi1_temp','N')
//	if ls_sdate <= ls_gdate and ls_edate >= ls_gdate then
//		dw_imhist.setitem(lrow,'yebi1',snull)
//	end if
//NEXT
//dw_imhist.setredraw(true)

FOR lrow = 1 TO dw_gumsu.rowcount()
	siojpno = dw_gumsu.getitemstring(lrow,'iojpno')
//	if not isnull(siojpno) then
//		dw_gumsu.setitem(lrow,'citnbr','N')
//	end if
	
	SETPOINTER(HOURGLASS!)
	
	dw_gumsu.setrow(lrow)
	dw_gumsu.scrolltorow(lrow)
	wf_select_row(lrow)
//	dw_gumsu.trigger event clicked(0, 0, lrow, dw_gumsu.object)
	
	lfind = dw_imhist.getselectedrow(0)
	if lfind > 0 then
		/* 사용자가 확정지정해서 저장한 경우 보존 (서선주) - 2007.01.23 */
		if dw_imhist.getitemstring(lfind,'yebi1_temp') = 'Y' then continue
		pb_check.triggerevent(clicked!)
	end if
	
	Yield()
NEXT

SETPOINTER(ARROW!)

end event

type cb_4 from commandbutton within w_sm40_0050
integer x = 2738
integer y = 156
integer width = 709
integer height = 116
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "D1 자동체크 (수량합계)"
end type

event clicked;/*-------------------------------------------------------------------------------------*/
/* 발주번호 없이 분할 검수된 자료의 검수 처리를 한번 더 진행 - 2013.01.16 - 송병호 */
String 	ls_itnbr,ls_factory, ls_sudat, ls_ipdate
Long   	i, j, k
Decimal	ld_qty, ld_sumqty, ldc_prc

SETPOINTER(HOURGLASS!)

FOR i = 1 TO dw_imhist.rowcount()
	if dw_imhist.getitemstring(i, 'yebi1_temp') = 'Y' then continue

	dw_imhist.setrow(i)
	dw_imhist.scrolltorow(i)
	dw_imhist.SelectRow(0, False)
	dw_imhist.SelectRow(i, True)

	ls_factory = dw_imhist.getitemstring(i, 'facgbn')		// 공장
	ls_itnbr   = dw_imhist.getitemstring(i, 'itnbr')		// 품번
	ld_qty     = dw_imhist.getitemnumber(i, 'ioqty')		// 수량
	ls_sudat   = dw_imhist.getitemstring(i, 'sudat')		// 검수일자

	ld_sumqty = 0
	dw_gumsu.SelectRow(0, False)

	FOR j = 1 TO dw_gumsu.rowcount()
		if dw_gumsu.Object.citnbr[j] = 'Y' then continue
		if Trim(dw_gumsu.Object.factory[j]) <> ls_factory then continue
		if Trim(dw_gumsu.Object.mitnbr[j]) <> ls_itnbr then continue
		ls_ipdate = Trim(dw_gumsu.Object.ipdate[j])
		if ls_ipdate < ls_sudat then continue
		if dw_gumsu.Object.ipqty[j] = 0 then continue

		ld_sumqty += dw_gumsu.Object.ipqty[j]
		ldc_prc = dw_gumsu.Object.ipdan[j]
		dw_gumsu.SelectRow(j, True)
		
		w_mdi_frame.sle_msg.text = ls_factory+' , '+ls_itnbr+' , '+String(Round(ld_sumqty,0))+' / '+String(Round(ld_qty,0))
		if ld_sumqty >= ld_qty then Exit
	NEXT

	IF ld_sumqty = ld_qty THEN
		dw_imhist.setitem(i, 'yebi1_temp', 'Y')
		dw_imhist.setitem(i, 'yebi1', ls_ipdate)
		dw_imhist.SetItem(i, 'ioprc', ldc_prc)

		for k = 1 to dw_gumsu.RowCount()
			if dw_gumsu.IsSelected(k) then
				dw_gumsu.Object.citnbr[k] = 'Y'
			end if	
		next
		w_mdi_frame.sle_msg.text += ' ... OK !!!'
	END IF

	Yield()
NEXT
dw_gumsu.SelectRow(0, False)
dw_imhist.SelectRow(0, False)
w_mdi_frame.sle_msg.text = ''
/*-------------------------------------------------------------------------------------*/

SETPOINTER(ARROW!)

end event

