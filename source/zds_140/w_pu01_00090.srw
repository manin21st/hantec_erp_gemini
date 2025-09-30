$PBExportHeader$w_pu01_00090.srw
$PBExportComments$월 계획등록(유상사급)
forward
global type w_pu01_00090 from w_inherite
end type
type dw_cond from u_key_enter within w_pu01_00090
end type
type dw_hidden from datawindow within w_pu01_00090
end type
type rr_1 from roundrectangle within w_pu01_00090
end type
end forward

global type w_pu01_00090 from w_inherite
string title = "매출계획 등록[유상사급]"
dw_cond dw_cond
dw_hidden dw_hidden
rr_1 rr_1
end type
global w_pu01_00090 w_pu01_00090

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();rollback;

dw_cond.enabled = true

dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)

dw_insert.Reset()

String siogbn, ssalegu, samtgu, sdepot

dw_cond.Modify('cvcod.protect = 0')
dw_cond.Modify('saupj.protect = 0')

dw_cond.Modify('sudat.protect = 0')

dw_cond.SetItem(1, 'sudat', left(is_today,6))
dw_cond.SetRow(1)
dw_cond.SetFocus()
dw_cond.SetColumn("sudat")


// 부가세 사업장 설정
f_mod_saupj(dw_cond, 'saupj')
f_child_saupj(dw_cond, 'depot_no', gs_saupj)

ib_any_typing = False
end subroutine

on w_pu01_00090.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_hidden=create dw_hidden
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_hidden
this.Control[iCurrent+3]=this.rr_1
end on

on w_pu01_00090.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_hidden)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_cond.SetTransObject(SQLCA)
dw_cond.InsertRow(0)

dw_insert.SetTransObject(SQLCA)

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_pu01_00090
integer x = 73
integer y = 304
integer width = 4521
integer height = 1960
string dataobject = "d_pu01_00090_2"
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;Long nRow
String sColnm
dec dItemQty, dItemPrice, dItemWonPrc

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow   	= GetRow()
sColNm 	= GetColumnName() 

Choose Case sColNm
	Case 'qty_01'
		dItemQty = dec(this.GetText())
		IF dItemQty = 0 OR IsNull(dItemQty) THEN 
			SetItem(nRow,"qty_01", 0)
			SetItem(nRow,"amt_01", 0)
			Return
		End if
	
		dItemPrice = this.GetItemNumber(nRow,"unprc")
		IF dItemPrice = 0 Or IsNull(dItemPrice) THEN Return
		dItemWonPrc  = dItemQty * dItemPrice

		SetItem(nRow,"amt_01", ditemWonPrc)
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(currentrow,true)
Else
	this.SelectRow(0,false)
End If
end event

event dw_insert::clicked;call super::clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
End If
end event

type p_delrow from w_inherite`p_delrow within w_pu01_00090
integer x = 3922
end type

event p_delrow::clicked;call super::clicked;Long nRow, iCnt
String sSudat

nRow = dw_insert.GetSelectedRow(0)
If nRow <= 0 Then Return

sSudat = dw_cond.GetItemString(1, 'sudat')


IF MessageBox("삭 제","유상사급 계획이 삭제됩니다." +"~n~n" +&
           	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

////////////////////////////////////////////////////////////////////////

Choose Case dw_insert.GetItemStatus(nRow,0,Primary!)
	Case New!,NewModified!
		dw_insert.DeleteRow(nRow)
	Case Else
		dw_insert.DeleteRow(nRow)
      If dw_insert.Update() <> 1 Then
        RollBack;
        Return
      End If
      Commit;
END CHOOSE

If dw_insert.RowCount() = 0 Then	p_can.TriggerEvent(Clicked!)
	
w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다.!!'
ib_any_typing = False

end event

type p_addrow from w_inherite`p_addrow within w_pu01_00090
boolean visible = false
integer x = 3749
integer y = 172
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pu01_00090
integer x = 3442
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\발주처품목선택_up.gif"
end type

event p_search::clicked;//발주처 품목선택	-버턴명
string scvcod, scvnas, sempno, sin_house, SO_house, sopt, sitem, sopseq, ls_bunbr, scur_ymd,sOrderDate, spspec
int    k, lRow,iRtnValue, nFind
Decimal {5} ddata
Double dDcRate, ddanga
Long	ljegoqty

IF dw_cond.AcceptText() = -1	THEN	RETURN

//dw_insert.Reset()
sCvcod 	= dw_cond.getitemstring(1, "cvcod"   ) /* 거 래 처  */ 
sCvnas 	= dw_cond.getitemstring(1, "vndname" )
sOrderDate = dw_cond.getitemstring(1, "sudat" )

scur_ymd = f_today()
sempno   = gs_empno

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[거래처]')
	dw_cond.SetColumn("cvcod")
	dw_cond.SetFocus()
	RETURN
END IF

IF isnull(sOrderDate) or sOrderDate = "" 	THEN
	f_message_chk(30,'[계획년]')
	dw_cond.SetColumn("sudat")
	dw_cond.SetFocus()
	RETURN
END IF

gs_code = sCvcod
gs_codename = scvnas
open(w_vnddan_popup)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"


FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if sopt  = 'Y' then 
		
		sitem  = dw_hidden.getitemstring(k, 'itnbr' )
		
		nFind = dw_insert.Find("cvcod ='"+scvcod+"' and itnbr ='"+sitem+"'", 1, dw_insert.rowcount())
		If nFind > 0 Then Continue
		
		lRow  = dw_insert.insertrow(0)
		
		dw_insert.SetItem(lRow, 'sabu', gs_saupj)
		dw_insert.SetItem(lRow, 'yymm', sOrderDate)
		
      dw_insert.SetItem(lRow, 'cvcod', sCvcod)
		dw_insert.SetItem(lRow, 'cvnas2',sCvnas)
		
		dw_insert.setitem(lRow, 'itnbr', sitem)
		dw_insert.setitem(lRow, 'itemas_itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(lRow, 'itemas_jijil', dw_hidden.getitemstring(k, 'itemas_jijil' ))
		dw_insert.setitem(lRow, 'itemas_ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(lRow, 'carcode', dw_hidden.getitemstring(k, 'carcode' ))
		
		iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu, sOrderDate, sCvcod, sitem, '.',&
                     'WON','1',dDanga,dDcRate) 
							
		If IsNull(dDanga) Then dDanga = 0
		If IsNull(dDcRate) Then dDcRate = 0
		
		if iRtnValue < 0 then
			dDcRate = 0
		Else
			dw_insert.SetItem(lRow,"unprc", truncate(dDanga,3))
		End if
	end if	
NEXT

dw_hidden.reset()
dw_insert.ScrollToRow(1)
dw_insert.setrow(1)
dw_insert.SetColumn("qty_01")
dw_insert.SetFocus()
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\발주처품목선택_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\발주처품목선택_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pu01_00090
boolean visible = false
integer y = 172
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pu01_00090
end type

type p_can from w_inherite`p_can within w_pu01_00090
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_pu01_00090
boolean visible = false
integer y = 172
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu01_00090
integer x = 3744
end type

event p_inq::clicked;call super::clicked;String sYymm, ssaupj, scvcod
Long   ix

If dw_cond.AcceptText() <> 1 Then Return -1
If dw_insert.AcceptText() <> 1 Then Return -1

sYymm 	= Trim(dw_cond.GetItemString(1,"sudat"))
sSaupj	= Trim(dw_cond.GetItemString(1,"saupj"))
sCvcod	= Trim(dw_cond.GetItemString(1,"cvcod"))

IF sYymm = "" OR IsNull(sYymm) THEN
	f_message_chk(30,'[계획년월]')
	dw_cond.SetColumn("sudat")
	dw_cond.SetFocus()
	Return -1
END IF

IF  sSaupj = "" OR IsNull(sSaupj) THEN
	f_message_chk(30,'[부가사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return -1
END IF

If IsNull(sCVcod) Or Trim(scvcod) = '' Then sCVcod = ''

IF dw_insert.Retrieve(sSaupj,sYymm, sCvcod+'%') <=0 THEN
//	f_message_chk(50,'')
	w_mdi_frame.sle_msg.text = '조회된 내역이 없습니다!!'
	dw_cond.Setfocus()
	Return
ELSE
	dw_insert.SetFocus()
END IF
end event

type p_del from w_inherite`p_del within w_pu01_00090
boolean visible = false
integer y = 172
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pu01_00090
integer x = 4096
end type

event p_mod::clicked;call super::clicked;String sYymm, ssaupj
Long   ix

If dw_cond.AcceptText() <> 1 Then Return -1
If dw_insert.AcceptText() <> 1 Then Return -1

sYymm 	= Trim(dw_cond.GetItemString(1,"sudat"))
sSaupj	= Trim(dw_cond.GetItemString(1,"saupj"))

IF sYymm = "" OR IsNull(sYymm) THEN
	f_message_chk(30,'[계획년월]')
	dw_cond.SetColumn("sudat")
	dw_cond.SetFocus()
	Return -1
END IF

IF  sSaupj = "" OR IsNull(sSaupj) THEN
	f_message_chk(30,'[부가사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return -1
END IF

For ix = 1 To dw_insert.Rowcount()
	dw_insert.SetItem(ix, 'qty_m0', dw_insert.GetItemNumber(ix, 'qty_01'))
	dw_insert.SetItem(ix, 'amt_m0', dw_insert.GetItemNumber(ix, 'amt_01'))
Next

IF dw_insert.Update() <> 1 THEN
	MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	ROLLBACK;
	Return -1
END IF

COMMIT;

w_mdi_frame.sle_msg.text = '자료를 처리하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_pu01_00090
end type

type cb_mod from w_inherite`cb_mod within w_pu01_00090
end type

type cb_ins from w_inherite`cb_ins within w_pu01_00090
end type

type cb_del from w_inherite`cb_del within w_pu01_00090
end type

type cb_inq from w_inherite`cb_inq within w_pu01_00090
end type

type cb_print from w_inherite`cb_print within w_pu01_00090
end type

type st_1 from w_inherite`st_1 within w_pu01_00090
end type

type cb_can from w_inherite`cb_can within w_pu01_00090
end type

type cb_search from w_inherite`cb_search within w_pu01_00090
end type







type gb_button1 from w_inherite`gb_button1 within w_pu01_00090
end type

type gb_button2 from w_inherite`gb_button2 within w_pu01_00090
end type

type dw_cond from u_key_enter within w_pu01_00090
integer x = 50
integer y = 68
integer width = 2930
integer height = 184
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pu01_00090_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;String  sIoJpNo,sSuDate, sIoConFirm,snull, siogbn, ssalegu, samtgu
String  sProject_no,sOrderCust, sProject_prjnm
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1

DataWindowChild state_child
integer rtncode
			
Int     icnt
SetNull(snull)

Choose Case GetColumnName()
	Case "sudat"
		sSuDate = Trim(this.GetText())
		IF sSuDate ="" OR IsNull(sSuDate) THEN RETURN
		
		IF f_datechk(sSuDate+'01') = -1 THEN
			f_message_chk(35,'[계획년월]')
			this.SetItem(1,"sudat",snull)
			Return 1
		END IF
		
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"vndname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'vndname', snull)
			Return 1
		ELSE
			SetItem(1,"cust_area",   sarea)
			SetItem(1,"vndname",		 scvnas)
		END IF
End Choose

p_inq.PostEvent(Clicked!)
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName() 
	/* 거래처 */
	Case "cvcod", "vndname"
		gs_gubun = '1'
		If GetColumnName() = "vndname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetItem(1,"vndname",gs_codename)
		SetColumn("cvcod")
END Choose

p_inq.PostEvent(Clicked!)
end event

type dw_hidden from datawindow within w_pu01_00090
boolean visible = false
integer x = 2075
integer y = 16
integer width = 951
integer height = 256
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_vnddan_popup_2"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pu01_00090
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 296
integer width = 4562
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

