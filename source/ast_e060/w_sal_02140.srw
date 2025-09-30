$PBExportHeader$w_sal_02140.srw
$PBExportComments$품목분류별 계정 등록
forward
global type w_sal_02140 from w_inherite
end type
type gb_5 from groupbox within w_sal_02140
end type
type gb_4 from groupbox within w_sal_02140
end type
type rr_1 from roundrectangle within w_sal_02140
end type
type dw_1 from datawindow within w_sal_02140
end type
end forward

global type w_sal_02140 from w_inherite
string title = "품목분류별 계정 등록"
gb_5 gb_5
gb_4 gb_4
rr_1 rr_1
dw_1 dw_1
end type
global w_sal_02140 w_sal_02140

type variables

end variables

forward prototypes
public function integer wf_update_middle ()
end prototypes

public function integer wf_update_middle ();Long ix
String sIttyp, sItcls, sKacc, sFacc, sLacc

If dw_1.RowCount() <= 0 Then Return 0

SetPointer(HourGlass!)

For ix = 1 To dw_1.RowCount()
	sIttyp = Trim(dw_1.GetItemString(ix,'ittyp'))
	sItcls = Trim(dw_1.GetItemString(ix,'itcls'))
	sKacc  = Trim(dw_1.GetItemString(ix,'kacc_cd'))
	sFacc  = Trim(dw_1.GetItemString(ix,'facc_cd'))
	sLacc  = Trim(dw_1.GetItemString(ix,'lacc_cd'))

	If IsNull(sIttyp) Then continue
	If IsNull(sItcls) Then continue
	
	If IsNull(sKacc) Then sKacc = ''
	If IsNull(sFacc) Then sFacc = ''
	If IsNull(sLacc) Then sLacc = ''
	
	/* 중분류 update */
	update itnacc
		set kacc_cd = :sKacc,
			 facc_cd = :sFacc,
			 lacc_cd = :sLacc
	 where ittyp = :sIttyp and
			 itcls like :sItcls||'%' ;

//			 exists ( select * from itnct 
//						  where ittyp = a.ittyp and
//								  itcls = a.itcls and
//								  lmsgu = 'M' );

	If sqlca.sqlcode <> 0 Then
		rollback;
		MessageBox('확 인','중분류 update에 실패하였습니다')
		Return -1
	End If
Next

Commit;

w_mdi_frame.sle_msg.Text = '중분류를 저장하였습니다.!!'

Return 1
end function

on w_sal_02140.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.rr_1=create rr_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.dw_1
end on

on w_sal_02140.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.rr_1)
destroy(this.dw_1)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_1.settransobject(sqlca)

dw_insert.InsertRow(0)

f_mod_saupj(dw_insert, 'dcomp')

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02140
integer x = 23
integer y = 32
integer width = 3689
integer height = 224
integer taborder = 30
string dataobject = "d_sal_02140_01"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;Long nRow
String sNull, sItemCls, sItemGbn, sItemClsName, sPdtgu

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	/* 구분 */
	Case 'salegu'
		/* 대분류 조회 */
		If GetText() = '1' Then
			dw_1.dataobject     	= 'd_sal_021401'

			SetItem(nRow,'itcls',sNull)
			SetItem(nRow,'itclsnm',sNull)
		/* 중분류 조회 */
		Else
			dw_1.dataobject     	= 'd_sal_021402'
			
			SetFocus()
			Post SetColumn('itcls')
		End If
      	dw_1.settransobject(sqlca)
		
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."TITNM" ,"ITNCT"."PDTGU"
			  INTO :sItemClsName  , :sPdtgu
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		
		sItemClsName = GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
			sItemGbn = GetItemString(1,"ittyp")
			IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
				SELECT "ITNCT"."ITCLS","ITNCT"."PDTGU"
				  INTO :sItemCls, :sPdtgu
				  FROM "ITNCT"  
				 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
				IF SQLCA.SQLCODE <> 0 THEN
					TriggerEvent(RButtonDown!)
					Return 2
				ELSE
					SetItem(1,"itcls",sItemCls)
			END IF
		END IF
End Choose
end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "itcls"
		gs_gubun = GetItemString(1,"ittyp")
		Open(w_itnct_l_popup)
		If IsNull(gs_code ) Then Return 2
		
		SetItem(1,"itcls", gs_code)
		SetItem(1,"itclsnm", gs_codename)
		SetItem(1,"ittyp",  gs_gubun)
	Case "itclsnm"
		gs_gubun = GetItemString(1,"ittyp")
		Open(w_itnct_l_popup)
		If IsNull(gs_code ) Then Return 2		
		
		SetItem(1,"itcls", gs_code)
		SetItem(1,"itclsnm", gs_codename)
		SetItem(1,"ittyp",  gs_gubun)
END Choose
end event

type p_delrow from w_inherite`p_delrow within w_sal_02140
boolean visible = false
integer x = 4000
integer y = 2948
end type

type p_addrow from w_inherite`p_addrow within w_sal_02140
boolean visible = false
integer x = 3826
integer y = 2948
end type

type p_search from w_inherite`p_search within w_sal_02140
boolean visible = false
integer x = 3131
integer y = 2948
end type

type p_ins from w_inherite`p_ins within w_sal_02140
boolean visible = false
integer x = 3653
integer y = 2948
end type

type p_exit from w_inherite`p_exit within w_sal_02140
end type

type p_can from w_inherite`p_can within w_sal_02140
end type

event p_can::clicked;call super::clicked;dw_1.Reset()

/* Protect */
//dw_insert.Modify('dcomp.protect = 0')
dw_insert.Modify('salegu.protect = 0')
//dw_insert.Modify("salegu.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
dw_insert.Modify('ittyp.protect = 0')
//dw_insert.Modify("ittyp.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint

dw_insert.SetFocus()
dw_insert.SetColumn('ittyp')

ib_any_typing = false
end event

type p_print from w_inherite`p_print within w_sal_02140
boolean visible = false
integer x = 3305
integer y = 2948
end type

type p_inq from w_inherite`p_inq within w_sal_02140
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string salegu, sIttyp, sItcls, sDcomp

If dw_insert.AcceptText() <> 1 Then Return

dw_insert.SetFocus()
dw_insert.SetRow(1)

salegu = Trim(dw_insert.GetItemString(1,'salegu'))
If IsNull(salegu) Or salegu = '' Then
	f_message_chk(1400,'[분류구분]')
	dw_insert.setColumn('salegu')
	Return 2
End If

sDcomp  = Trim(dw_insert.GetItemString(1,'dcomp'))
If 	sDcomp <> '%' then
	sDcomp = sDcomp + '%'
End If

sittyp       = Trim(dw_insert.GetItemString(1,'ittyp'))
If IsNull(sittyp) Or sittyp = '' Then
	f_message_chk(1400,'[품목구분]')
	dw_insert.setColumn('ittyp')
	Return 2
End If

sitcls  = Trim(dw_insert.GetItemString(1,'itcls'))
If SaleGu = '2' and ( IsNull(sitcls) Or sitcls = '' ) Then
	f_message_chk(1400,'[품목분류]')
	dw_insert.setColumn('itcls')
	Return 2
End If

If SaleGu = '1' Then /* 대분류 조회 */
	IF dw_1.retrieve(sDcomp,sIttyp) <=0 THEN
		IF f_message_chk(50,'') = -1 THEN RETURN -1
   		dw_insert.setcolumn('dcomp')
		dw_insert.SetFocus()
		Return -1
	END IF
Else
	IF dw_1.retrieve(sDcomp, sIttyp, sItcls+'%') <=0 THEN
		IF f_message_chk(50,'') = -1 THEN RETURN -1
   		dw_insert.setcolumn('dcomp')
		dw_insert.SetFocus()
		Return -1
	END IF
End If

/* Protect */
//dw_insert.Modify('dcomp.protect = 1')
dw_insert.Modify('salegu.protect = 1')
//dw_insert.Modify("salegu.background.color = 80859087") 
dw_insert.Modify('ittyp.protect = 1')
//dw_insert.Modify("ittyp.background.color = 80859087") 


end event

type p_del from w_inherite`p_del within w_sal_02140
boolean visible = false
integer x = 4347
integer y = 2948
end type

type p_mod from w_inherite`p_mod within w_sal_02140
integer x = 4096
end type

event p_mod::clicked;call super::clicked;String sSalegu, sIttyp, sItcls
Long   nRow

If dw_insert.AcceptText() <> 1 Then return 

sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
If sSaleGu = '2' then
	sItcls  = Trim(dw_insert.GetItemString(1,'itcls'))
End If

If sSalegu = '1' Then
	/* 대분류 저장 */
	If dw_1.AcceptText() <> 1 Then Return
	
	If dw_1.update() > 0 then
		commit using sqlca;
	Else
		rollback using sqlca ;
		f_message_chk(32,'')
		Return
	End If
	
	/* 중분류 일괄 조정 */
 	If wf_update_middle() < 0 Then Return
Else
	/* 중분류 저장 */
	If dw_1.AcceptText() <> 1 Then 
		MessageBox('err','')
		Return
	End If
	
	If dw_1.update() > 0 then
		commit using sqlca;
	Else
		rollback using sqlca ;
		f_message_chk(32,'')
		Return
	End If
End If

w_mdi_frame.sle_msg.text = "저장하였습니다!!"
ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_sal_02140
integer x = 3237
end type

type cb_mod from w_inherite`cb_mod within w_sal_02140
integer x = 2514
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;//String sSalegu, sIttyp, sItcls
//Long   nRow
//
//If dw_insert.AcceptText() <> 1 Then return 
//
//sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
//sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
//If sSaleGu = '2' then
//	sItcls  = Trim(dw_insert.GetItemString(1,'itcls'))
//End If
//
//If sSalegu = '1' Then
//	/* 대분류 저장 */
//	If dw_1.AcceptText() <> 1 Then Return
//	
//	If dw_1.update() > 0 then
//		commit using sqlca;
//	Else
//		rollback using sqlca ;
//		f_message_chk(32,'')
//		Return
//	End If
//	
//	/* 중분류 일괄 조정 */
// 	If wf_update_middle() < 0 Then Return
//Else
//	/* 중분류 저장 */
//	If dw_2.AcceptText() <> 1 Then 
//		MessageBox('err','')
//		Return
//	End If
//	
//	If dw_2.update() > 0 then
//		commit using sqlca;
//	Else
//		rollback using sqlca ;
//		f_message_chk(32,'')
//		Return
//	End If
//End If
//
//sle_msg.text = "저장하였습니다!!"
//ib_any_typing = false
end event

type cb_ins from w_inherite`cb_ins within w_sal_02140
integer x = 343
integer y = 2676
end type

type cb_del from w_inherite`cb_del within w_sal_02140
integer x = 1381
integer y = 2660
integer taborder = 70
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;//String sSalegu, sIttyp, sItcls, sDate
//Long   nRow
//
//sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
//sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
//sDate   = Trim(dw_insert.GetItemString(1,'start_date'))
//
///* 삭제 */
//If dw_1.tag = 'this' Then
//	wf_delete(dw_1)
//	
//	dw_1.retrieve(sSalegu, sIttyp, sDate) // 대분류 조회
//Else
//	nRow = dw_2.GetRow()
//	If nRow <= 0 Then Return
//	
//	sItcls  = Trim(dw_2.GetItemString(nRow,'itcls'))
//	
//	wf_delete(dw_2)
//	
//	dw_1.retrieve(sSalegu, sIttyp, sDate ) // 대분류 조회
//	dw_2.retrieve(sSalegu, sIttyp, Left(sItcls,2)+'%', sDate)     // 중분류 조회
//End If
//dw_1.ScrollToRow(nRow)
//
//ib_any_typing = false
end event

type cb_inq from w_inherite`cb_inq within w_sal_02140
integer x = 1920
integer taborder = 10
end type

event cb_inq::clicked;call super::clicked;//string salegu, sIttyp, sItcls
//
//If dw_insert.AcceptText() <> 1 Then Return
//
//dw_insert.SetFocus()
//dw_insert.SetRow(1)
//
//salegu = Trim(dw_insert.GetItemString(1,'salegu'))
//If IsNull(salegu) Or salegu = '' Then
//	f_message_chk(1400,'[분류구분]')
//	dw_insert.setColumn('salegu')
//	Return 2
//End If
//
//sittyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
//If IsNull(sittyp) Or sittyp = '' Then
//	f_message_chk(1400,'[품목구분]')
//	dw_insert.setColumn('ittyp')
//	Return 2
//End If
//
//sitcls  = Trim(dw_insert.GetItemString(1,'itcls'))
//If SaleGu = '2' and ( IsNull(sitcls) Or sitcls = '' ) Then
//	f_message_chk(1400,'[품목분류]')
//	dw_insert.setColumn('itcls')
//	Return 2
//End If
//
//If SaleGu = '1' Then /* 대분류 조회 */
//	dw_1.retrieve(sIttyp)
//	dw_2.Reset()
//Else
//	dw_2.retrieve(sIttyp, sItcls+'%')
//	dw_1.Reset()
//End If
//
///* Protect */
//dw_insert.Modify('salegu.protect = 1')
//dw_insert.Modify("salegu.background.color = 80859087") 
//dw_insert.Modify('ittyp.protect = 1')
//dw_insert.Modify("ittyp.background.color = 80859087") 
//
//
end event

type cb_print from w_inherite`cb_print within w_sal_02140
integer x = 343
integer y = 2784
end type

type st_1 from w_inherite`st_1 within w_sal_02140
long backcolor = 80859087
end type

type cb_can from w_inherite`cb_can within w_sal_02140
integer x = 2875
integer y = 2780
integer taborder = 80
end type

event cb_can::clicked;call super::clicked;//dw_1.Reset()
//dw_2.Reset()
//
//
///* Protect */
//dw_insert.Modify('salegu.protect = 0')
//dw_insert.Modify("salegu.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
//dw_insert.Modify('ittyp.protect = 0')
//dw_insert.Modify("ittyp.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
//
//dw_insert.SetFocus()
//dw_insert.SetColumn('ittyp')
//
//ib_any_typing = false
end event

type cb_search from w_inherite`cb_search within w_sal_02140
integer x = 343
integer y = 2892
end type



type sle_msg from w_inherite`sle_msg within w_sal_02140
long backcolor = 80859087
end type

type gb_10 from w_inherite`gb_10 within w_sal_02140
fontcharset fontcharset = ansi!
long backcolor = 80859087
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02140
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02140
end type

type gb_5 from groupbox within w_sal_02140
boolean visible = false
integer x = 1847
integer y = 2732
integer width = 494
integer height = 180
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_sal_02140
boolean visible = false
integer x = 2450
integer y = 2732
integer width = 1179
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_1 from roundrectangle within w_sal_02140
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 260
integer width = 4581
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_sal_02140
event ue_pressenter pbm_dwnprocessenter
string tag = "this"
integer x = 32
integer y = 280
integer width = 4567
integer height = 2032
string dataobject = "d_sal_021401"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event clicked;String sIttyp, sItcls
	
If row > 0 Then
	sIttyp  = Trim(GetItemString(row,'ittyp'))
	sItcls  = Trim(GetItemString(row,'itcls'))

	/* 중분류 조회 */
//	dw_2.Retrieve(sIttyp, sItcls+'%')
	
	ScrollToRow(row)
END If

end event

event itemerror;return 1
end event

event rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

