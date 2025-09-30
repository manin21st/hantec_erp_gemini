$PBExportHeader$w_pdm_11711.srw
$PBExportComments$외주사급자재 단가등록
forward
global type w_pdm_11711 from w_inherite
end type
type gb_3 from groupbox within w_pdm_11711
end type
type gb_2 from groupbox within w_pdm_11711
end type
type dw_1 from datawindow within w_pdm_11711
end type
type mle_1 from multilineedit within w_pdm_11711
end type
type rr_2 from roundrectangle within w_pdm_11711
end type
end forward

global type w_pdm_11711 from w_inherite
integer height = 2504
string title = "외주사급자재 단가등록"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
mle_1 mle_1
rr_2 rr_2
end type
global w_pdm_11711 w_pdm_11711

forward prototypes
public function integer wf_retrieve ()
public function integer wf_save ()
end prototypes

public function integer wf_retrieve ();return 1

end function

public function integer wf_save ();Long Lrow, Lcnt
integer li
String scvnas, sdate, scvcod, sNull, sitnbr
Decimal {2} dunprc

Lrow = dw_insert.getrow()
If Lrow < 1 then return -1

if dw_insert.accepttext() = -1 then return -1

SetNull(sNull)
sitnbr = dw_insert.getitemstring(Lrow, "itnbr")
scvcod = dw_insert.getitemstring(Lrow, "wsunpr_cvcod")
scvnas = dw_insert.getitemstring(Lrow, "vndmst_cvnas")
sdate  = dw_insert.getitemstring(Lrow, "wsunpr_sdate")
dunprc = dw_insert.getitemdecimal(Lrow, "wsunpr_unprc")

If ( IsNull(scvcod)  or Trim(scvcod) = '') And &
   ( IsNull(scvnas)  or Trim(scvnas) = '') And &
   ( IsNull(sdate)   or Trim(sdate)  = '') And &
   ( IsNull(dunprc)  or dunprc       = 0 ) then
	return 0
End if

if scvcod <> '.' then
	If ( IsNull(scvnas)  or Trim(scvnas) = '') then
		MessageBox("거래처", "거래처를 입력하세요", stopsign!)
		dw_insert.setcolumn("vndmst_cvnas")
		return 1
	end if
end if

If ( IsNull(sdate)  or Trim(sdate) = '') then
	MessageBox("적용시작일", "적용시작일을 입력하세요", stopsign!)
	dw_insert.setcolumn("wsunpr_sdate")	
	return 1
end if

If ( IsNull(dunprc) or dunprc = 0) then
	MessageBox("단가", "단가를 입력하세요", stopsign!)
	dw_insert.setcolumn("wsunpr_unprc")		
	return 1
end if

/* Li = MessageBox("확인", "저장할까요?" + '~n'  + &
								"거래처 		-> " + scvnas + '~n' + &
							   "적용시작일	-> " + sdate  + '~n' + &
							   "적용단가     -> " + string(dunprc), information!, yesno!) 
If Li = 2 then
	setitem(Lrow, "wsunpr_cvcod", sNull)	
	setitem(Lrow, "vndmst_cvnas", sNull)
	setitem(Lrow, "wsunpr_sdate", sNull)
	setitem(Lrow, "wsunpr_unprc", 0)
End if  */

Lcnt = 0
Select count(*) into :Lcnt 
  From wsunpr   where itnbr = :sItnbr And cvcod = :scvcod And sdate = :sdate;
If Lcnt > 0 then
  update wsunpr  Set unprc = :dunprc where itnbr = :sItnbr And cvcod = :scvcod And sdate = :sdate;
	
Else
	Insert into wsunpr (itnbr,    cvcod,   sdate,  unprc)
				   Values (:sitnbr, :scvcod, :sdate, :dunprc);
	
End if

If sqlca.sqlcode <> 0 then
	rollback;
	Messagebox("저장", "저장이 실패하였읍니다", stopsign!)
	return 0
End if

commit;

return 1
end function

on w_pdm_11711.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.mle_1=create mle_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.mle_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_pdm_11711.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.mle_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_1.insertrow(0)

dw_1.setfocus()
dw_1.setcolumn('ittyp')




end event

type dw_insert from w_inherite`dw_insert within w_pdm_11711
integer x = 96
integer y = 364
integer width = 4512
integer height = 1944
integer taborder = 30
string dataobject = "d_pdm_11711_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::itemchanged;call super::itemchanged;string snull, sData, sname
Long Lrow

SetNull(sNull)
Lrow = row

If Lrow < 1 then return 

if getcolumnname() = 'wsunpr_cvcod' then
	sData = gettext()
	
	if sData = '.' then
		setitem(Lrow, "vndmst_cvnas", '전체거래처')
		return
	End if
	
	Select cvnas2 into :sname from vndmst where cvcod = :sData;
	If sqlca.sqlcode <> 0 then
		MessageBox("거래처", "거래처코드가 부정확합니다", stopsign!)
		setitem(Lrow, "wsunpr_cvcod", snull)
		setitem(Lrow, "vndmst_cvnas", snull)
		setitem(Lrow, "wsunpr_bdate", snull)
		return 1
	End if

	setitem(Lrow, "vndmst_cvnas", sname)
	setitem(Lrow, "wsunpr_bdate", f_today())
End if
end event

event dw_insert::rowfocuschanging;call super::rowfocuschanging;wf_save()
end event

event dw_insert::losefocus;call super::losefocus;wf_save()
end event

event dw_insert::ue_key;call super::ue_key;IF keydown(keyF5!) THEN
	string sitnbr
	Long Lrow
	Lrow = getrow()
	if Lrow < 1 then return
	sitnbr = getitemstring(Lrow, "itnbr")
	//openwithparm(w_pdm_11711_1, sitnbr)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_pdm_11711
boolean visible = false
integer x = 3886
integer y = 2768
end type

type p_addrow from w_inherite`p_addrow within w_pdm_11711
boolean visible = false
integer x = 3712
integer y = 2768
end type

type p_search from w_inherite`p_search within w_pdm_11711
integer x = 4366
integer y = 2572
string picturename = "C:\erpman\image\일괄적용_up.gif"
end type

event p_search::clicked;call super::clicked;long ll_count,i , ll_sum = 0 , j
string ls_nbr , ls_gubun , ls_chk

If dw_insert.accepttext() <> 1 Then Return

ll_count = dw_insert.rowcount()

SetPointer(HourGlass!)

for i= 1 to ll_count
	if dw_insert.getitemstring(i,'chk') = 'Y' then
		j = 1
		ll_sum = ll_sum + j
	end if
next
	
if ll_sum < 1 then
	messagebox('확인','적용할 품번을 선택하세요.')
	return
end if


for i = 1 to ll_count 
	if dw_insert.object.chk[i] = 'Y' then
	   dw_insert.setitem(i,'gritu', ls_gubun)
	end if
next

p_mod.triggerevent(clicked!)

end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄적용_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄적용_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pdm_11711
boolean visible = false
integer x = 3538
integer y = 2768
end type

type p_exit from w_inherite`p_exit within w_pdm_11711
end type

type p_can from w_inherite`p_can within w_pdm_11711
end type

event p_can::clicked;call super::clicked;dw_insert.reset()
dw_1.reset()
dw_1.insertrow(0)

ib_any_typing = FALSE

end event

type p_print from w_inherite`p_print within w_pdm_11711
boolean visible = false
integer x = 3191
integer y = 2768
end type

type p_inq from w_inherite`p_inq within w_pdm_11711
integer x = 4096
end type

event p_inq::clicked;call super::clicked;String ls_ittyp,ls_itcls,ls_itnbr,ls_itdsc,ls_jijil,ls_ispec

If dw_1.AcceptText() <> 1 Then Return -1

ls_ittyp      = trim(dw_1.getitemstring(1,"ittyp"))
ls_itcls      = trim(dw_1.GetItemString(1,"itcls"))
ls_itnbr      = trim(dw_1.GetItemString(1,"itnbr"))
ls_itdsc      = trim(dw_1.GetItemString(1,"itdsc"))
ls_jijil      = trim(dw_1.GetItemString(1,"jijil"))
ls_ispec      = trim(dw_1.GetItemString(1,"ispec"))

If Isnull(ls_ittyp) Then 
	f_message_chk(30,'[품목구분]')
	dw_1.setcolumn('ittyp')
	dw_1.setfocus()
	return 1
end if

If ls_itcls = "" or Isnull(ls_itcls) Then ls_itcls = '%'
If ls_itnbr = "" or Isnull(ls_itnbr) Then ls_itnbr = '%'
If ls_itdsc = "" or Isnull(ls_itdsc) Then ls_itdsc = '%'
If ls_jijil = "" or Isnull(ls_jijil) Then ls_jijil = '%'
If ls_ispec = "" or Isnull(ls_ispec) Then ls_ispec = '%'

ib_any_typing = FALSE

IF dw_insert.Retrieve(ls_ittyp , ls_itcls,ls_itnbr ,ls_itdsc , ls_jijil , ls_ispec) <=0 THEN
	f_message_chk(300,'')
   dw_1.setcolumn('ittyp')
	dw_1.SetFocus()
	Return -1
END IF

dw_insert.setfocus()

Return 1
end event

type p_del from w_inherite`p_del within w_pdm_11711
boolean visible = false
integer x = 4233
integer y = 2768
end type

type p_mod from w_inherite`p_mod within w_pdm_11711
boolean visible = false
integer x = 3465
integer y = 8
end type

event p_mod::clicked;If dw_insert.accepttext() <> 1 Then Return

if dw_insert.update() <> 1 then
	rollback using sqlca;
	f_rollback()
	return
end if

commit using sqlca;


w_mdi_frame.sle_msg.text='저장에 성공하였습니다.'

dw_insert.reset()

end event

type cb_exit from w_inherite`cb_exit within w_pdm_11711
integer x = 3579
integer y = 2644
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_pdm_11711
integer x = 2875
integer y = 2644
integer taborder = 70
end type

event cb_mod::clicked;call super::clicked;//If dw_insert.accepttext() <> 1 Then Return
//If dw_2.accepttext() <> 1 Then Return
//
//if dw_insert.update() <> 1 then
//	rollback using sqlca;
//	f_rollback()
//end if
//
//commit using sqlca;
//
//cbx_1.enabled=false
//cbx_1.checked=false
//
//sle_msg.text='저장에 성공하였습니다.'
//
//dw_insert.reset()
//
end event

type cb_ins from w_inherite`cb_ins within w_pdm_11711
boolean visible = false
integer x = 923
integer y = 2756
integer taborder = 60
end type

event cb_ins::clicked;call super::clicked;//Long nRow, nCurRow
//String sItnbr, sDptNo, sJcode
//
//If dw_2.AcceptText() <> 1 Then Return
//
//nRow = dw_ret.GetRow()
//If nRow <= 0 Then Return
//
//nCurRow = dw_2.RowCount()
//If nCurRow > 0 Then
//	sItnbr = Trim(dw_2.GetItemString(nCurRow, 'itemas_pyeong_itnbr'))
//	sDptNo = Trim(dw_2.GetItemString(nCurRow, 'itemas_pyeong_dptno'))
//	sJcode = Trim(dw_2.GetItemString(nCurRow, 'itemas_pyeong_jcode'))
//	
//	If IsNull(sItnbr) Or sItnbr = '' Then
//		f_message_chk(1400,'[품번]')
//		Return
//	End If
//	
//	If IsNull(sDptNo) Or sDptNo = '' Then
//		f_message_chk(1400,'[평가부서]')
//		Return
//	End If
//	
//	If IsNull(sJcode) Or sJcode = '' Then
//		f_message_chk(1400,'[집계코드]')
//		Return
//	End If
//End If
//
//nCurRow = dw_2.InsertRow(0)
//
//dw_2.SetItem(nCurRow, 'itemas_pyeong_itnbr', dw_ret.GetItemString(nRow, 'itemas_itnbr'))
//dw_2.SetItem(nCurRow, 'itemas_itdsc', dw_ret.GetItemString(nRow, 'itemas_itdsc'))
//dw_2.SetFocus()
//dw_2.SetRow(nCurRow)
//dw_2.SetColumn('itemas_pyeong_dptno')
end event

type cb_del from w_inherite`cb_del within w_pdm_11711
boolean visible = false
integer x = 1303
integer y = 2736
integer taborder = 80
end type

type cb_inq from w_inherite`cb_inq within w_pdm_11711
integer x = 197
integer y = 2772
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;//String ls_ittyp,ls_itcls,ls_itnbr,ls_itdsc,ls_jijil,ls_ispec
//
//If dw_1.AcceptText() <> 1 Then Return -1
//
//ls_ittyp      = trim(dw_1.getitemstring(1,"ittyp"))
//ls_itcls      = trim(dw_1.GetItemString(1,"itcls"))
//ls_itnbr      = trim(dw_1.GetItemString(1,"itnbr"))
//ls_itdsc      = trim(dw_1.GetItemString(1,"itdsc"))
//ls_jijil      = trim(dw_1.GetItemString(1,"jijil"))
//ls_ispec      = trim(dw_1.GetItemString(1,"ispec"))
//
//If Isnull(ls_ittyp) Then 
//	f_message_chk(30,'[품목구분]')
//	dw_1.setcolumn('ittyp')
//	dw_1.setfocus()
//	return 1
//end if
//
//If ls_itcls = "" or Isnull(ls_itcls) Then ls_itcls = '%'
//If ls_itnbr = "" or Isnull(ls_itnbr) Then ls_itnbr = '%'
//If ls_itdsc = "" or Isnull(ls_itdsc) Then ls_itdsc = '%'
//If ls_jijil = "" or Isnull(ls_jijil) Then ls_jijil = '%'
//If ls_ispec = "" or Isnull(ls_ispec) Then ls_ispec = '%'
//
//ib_any_typing = FALSE
//
//IF dw_insert.Retrieve(ls_ittyp , ls_itcls,ls_itnbr ,ls_itdsc , ls_jijil , ls_ispec) <=0 THEN
//	f_message_chk(300,'')
//   dw_1.setcolumn('ittyp')
//	dw_1.SetFocus()
//	Return -1
//END IF
//
//dw_insert.setfocus()
//dw_insert.setcolumn('gritu')
//
//cbx_1.enabled=true
//cbx_1.checked=false
//
//cb_1.enabled=true
//
//Return 1
end event

type cb_print from w_inherite`cb_print within w_pdm_11711
boolean visible = false
integer x = 2542
integer y = 2784
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_pdm_11711
end type

type cb_can from w_inherite`cb_can within w_pdm_11711
integer x = 3227
integer y = 2644
integer taborder = 100
end type

event cb_can::clicked;call super::clicked;//dw_insert.reset()
//dw_1.reset()
//dw_2.reset()
//
//dw_1.insertrow(0)
//dw_2.insertrow(0)
//
//cbx_1.enabled=false
//cbx_1.checked=false
//
//ib_any_typing = FALSE
//
end event

type cb_search from w_inherite`cb_search within w_pdm_11711
boolean visible = false
integer x = 2039
integer y = 2728
integer taborder = 110
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_11711
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_11711
end type

type gb_3 from groupbox within w_pdm_11711
integer x = 2834
integer y = 2588
integer width = 1129
integer height = 196
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_pdm_11711
integer x = 160
integer y = 2716
integer width = 402
integer height = 196
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_1 from datawindow within w_pdm_11711
event ue_pressenter pbm_dwnprocessenter
integer x = 87
integer y = 32
integer width = 2935
integer height = 300
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_11711_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
str_itnct str_sitnct

choose case getcolumnname()
	case "itcls"
        openwithparm(w_ittyp_popup,this.getitemstring(this.getrow(),"ittyp"))
	     
		  str_sitnct=message.powerobjectparm
		  
		  if str_sitnct.s_ittyp="" or isnull(str_sitnct.s_ittyp) then return
		  
		  this.setitem(1,"itcls",str_sitnct.s_sumgub)
		  this.setitem(1,"titnm",str_sitnct.s_titnm)
		  this.setitem(1,"ittyp",str_sitnct.s_ittyp)
		  
		  setcolumn('itnbr')
  //품번,품명,재질,규격 입력시.....//
   case "itnbr"
		gs_gubun=trim(getitemstring(1,'ittyp'))
		open(w_itemas_popup)
		
		if gs_code="" or isnull(gs_code) then return
		
		this.setitem(1,"itnbr",gs_code)
	
		this.setfocus()
		this.setcolumn('itnbr')
		this.postevent(itemchanged!)
end choose
end event

event itemchanged;String  sNull, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sDateFrom, sjijil
String  sItemCls, sItemGbn, sItemClsName
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'titnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		setitem(nrow,'jijil',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'titnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		setitem(nrow,'jijil',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"titnm",sItemClsName)
			END IF
		END IF
	
	/* 품번 */
	  Case	"itnbr" 
		 sItnbr = Trim(this.GetText())
		 IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		 END IF
		
		 SELECT  "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC","ITNCT"."TITNM","ITEMAS"."JIJIL"
			INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName , :sJiJil
			FROM "ITEMAS","ITNCT"
		  WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				  "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				  "ITEMAS"."ITNBR" = :sItnbr ;

		 IF SQLCA.SQLCODE <> 0 THEN
			this.PostEvent(RbuttonDown!)
			Return 2
		 END IF
		 
		 SetItem(nRow,"ittyp", sIttyp)
		 SetItem(nRow,"itdsc", sItdsc)
		 SetItem(nRow,"ispec", sIspec)
		 SetItem(nRow,"itcls", sItcls)
		 SetItem(nRow,"titnm", sItemClsName)
		 setitem(nrow,"jijil", sJiJil)
		 
///* 품명 */
//	 Case "itdsc"
//		 sItdsc = trim(this.GetText())	
//		 IF sItdsc ="" OR IsNull(sItdsc) THEN
//			 SetItem(nRow,'itnbr',sNull)
//			 SetItem(nRow,'itdsc',sNull)
//			 SetItem(nRow,'ispec',sNull)
//			 setitem(nrow,'jijil',sNull)
//			Return
//		 END IF
//		 
//		/* 품명으로 품번찾기 */
//		sItnbr = f_check_itdscA(sItDsc)
//		 If IsNull(sItnbr ) Then
//			 Return 1
//		 ElseIf sItnbr <> '' Then
//			 SetItem(nRow,"itnbr",sItnbr)
//			 SetColumn("itnbr")
//			 SetFocus()
//			 TriggerEvent(ItemChanged!)
//			 Return 1
//		 ELSE
//			 SetItem(nRow,'itnbr',sNull)
//			 SetItem(nRow,'itdsc',sNull)
//			 SetItem(nRow,'ispec',sNull)
//			 setitem(nrow,'jijil',sNull)
//			 SetColumn("itdsc")
//			 Return 1
//		End If	
//	/* 규격 */
//	Case "ispec"
//		sIspec = trim(this.GetText())	
//		IF sIspec = ""	or	IsNull(sIspec)	THEN
//			SetItem(nRow,'itnbr',sNull)
//			SetItem(nRow,'itdsc',sNull)
//			SetItem(nRow,'ispec',sNull)
//			setitem(nrow,'jijil',sNull)
//			Return
//		END IF
//	
//	   /* 규격으로 품번찾기 */
//	   sItnbr = f_check_ispecA(sIspec)
//		If IsNull(sItnbr ) Then
//			Return 1
//		ElseIf sItnbr <> '' Then
//			SetItem(nRow,"itnbr",sItnbr)
//			SetColumn("itnbr")
//			SetFocus()
//			TriggerEvent(ItemChanged!)
//			Return 1
//		ELSE
//			SetItem(nRow,'itnbr',sNull)
//			SetItem(nRow,'itdsc',sNull)
//			SetItem(nRow,'ispec',sNull)
//			setitem(nrow,'jijil',sNull)
//			SetColumn("ispec")
//			Return 1
//	  End If
END Choose

	
end event

event itemerror;return 1
end event

type mle_1 from multilineedit within w_pdm_11711
integer x = 3209
integer y = 216
integer width = 1349
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
string text = "거래처코드에 ~'.~'을 입력하면 전체거래처가 됩니다.[F5상세]"
boolean border = false
end type

type rr_2 from roundrectangle within w_pdm_11711
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 87
integer y = 356
integer width = 4535
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

