$PBExportHeader$w_qct_04025.srw
$PBExportComments$A/S 매출생성
forward
global type w_qct_04025 from w_inherite
end type
type dw_1 from datawindow within w_qct_04025
end type
type dw_2 from datawindow within w_qct_04025
end type
type dw_imhist from datawindow within w_qct_04025
end type
type rr_1 from roundrectangle within w_qct_04025
end type
end forward

global type w_qct_04025 from w_inherite
integer x = 5
integer y = 4
string title = "A/S 매출생성"
dw_1 dw_1
dw_2 dw_2
dw_imhist dw_imhist
rr_1 rr_1
end type
global w_qct_04025 w_qct_04025

on w_qct_04025.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_imhist=create dw_imhist
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_imhist
this.Control[iCurrent+4]=this.rr_1
end on

on w_qct_04025.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_imhist)
destroy(this.rr_1)
end on

event open;call super::open;p_mod.PictureName = 'c:\erpman\image\저장_up.gif'

dw_2.dataobject = "d_qct_04025_3"

dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_imhist.SetTransObject(SQLCA)

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_1.ReSet()
dw_1.InsertRow(0)

dw_insert.SetItem(1,"sdate", Left(is_today,6)+'01')
dw_insert.SetItem(1,"edate", is_today)
dw_1.SetItem(1,"sdate", is_today)

dw_insert.Setfocus()

ib_any_typing = False

w_mdi_frame.sle_msg.Text = ''

dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_04025
integer x = 46
integer y = 0
integer width = 1874
integer height = 260
integer taborder = 10
string dataobject = "d_qct_04025_1"
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;string ls_gub , s_cod, s_nam1, s_nam2
int     i_rtn

s_cod = Trim(this.GetText())

IF this.GetColumnName() = "sdate" then
	if Isnull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[처리일자 from]" )
		this.setitem(1, 'sdate', '')
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if Isnull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[처리일자 to]" )
		this.setitem(1, 'edate', '')
		return 1
	end if
elseif this.GetColumnName() = "gub" then
	ls_gub = s_cod

	dw_2.SetReDraw(false)
	if ls_gub = '1' then  //매출생성 
	   p_mod.PictureName = 'c:\erpman\image\저장_up.gif'
		dw_2.dataobject = "d_qct_04025_3"
	else                 // 매출삭제 
	   p_mod.PictureName = 'c:\erpman\image\삭제_up.gif'
		dw_2.dataobject = "d_qct_04025_5"
	end if
	
	dw_2.SetTransObject(SQLCA)
	dw_2.ReSet()
	dw_2.SetReDraw(True)	
elseif this.GetColumnName() = "cvcod" then
	i_rtn = f_get_name2("대리점", "Y", s_cod, s_nam1, s_nam2)
	this.object.cvcod[1] = s_cod
	this.object.cvnas[1] = s_nam1
	return i_rtn
end if

end event

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "cvcod" then //대리점 
   gi_page = -1	
	open(w_agent_popup)
	this.object.cvcod[1] = gs_code
	this.object.cvnas[1] = gs_codename
   gi_page = 0
end if	

end event

type p_delrow from w_inherite`p_delrow within w_qct_04025
boolean visible = false
integer x = 4059
integer y = 3512
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_04025
boolean visible = false
integer x = 3886
integer y = 3512
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_04025
boolean visible = false
integer x = 3191
integer y = 3512
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_04025
boolean visible = false
integer x = 3712
integer y = 3512
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_04025
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_qct_04025
integer taborder = 60
end type

event p_can::clicked;call super::clicked;dw_insert.setitem(1,'gub','1')

p_mod.PictureName = 'c:\erpman\image\저장_up.gif'

dw_2.dataobject = "d_qct_04025_3"
dw_2.SetTransObject(SQLCA)

dw_insert.Reset()
dw_1.Reset()
dw_2.reset()
dw_imhist.reset()

dw_insert.InsertRow(0)
dw_1.InsertRow(0)

dw_insert.SetItem(1,"sdate", Left(is_today,6)+'01')
dw_insert.SetItem(1,"edate", is_today)

dw_insert.Setfocus()


ib_any_typing = False

w_mdi_frame.sle_msg.Text = ''




end event

type p_print from w_inherite`p_print within w_qct_04025
boolean visible = false
integer x = 3365
integer y = 3512
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_04025
integer x = 3918
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;String  ls_sdate, ls_edate , ls_cvcod 

if dw_insert.AcceptText() = -1 then return 

ls_sdate = trim(dw_insert.object.sdate[1])
ls_edate = trim(dw_insert.object.edate[1])
ls_cvcod = trim(dw_insert.object.cvcod[1])

if IsNull(ls_sdate) or ls_sdate= ""  then ls_sdate = '10000101' 
if IsNull(ls_edate) or ls_edate= "" then  ls_edate = '99991231'
if IsNull(ls_cvcod) or ls_cvcod= "" then  ls_cvcod = '%'

if dw_2.Retrieve( gs_sabu, ls_sdate , ls_edate, ls_cvcod ) <= 0 then 
	MessageBox("품목확인","A/S처리된 품목이 없습니다. [확인하세요]")
	dw_insert.setfocus()
	return 
end if


	



end event

type p_del from w_inherite`p_del within w_qct_04025
boolean visible = false
integer x = 4407
integer y = 3512
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_qct_04025
integer x = 4096
end type

event p_mod::clicked;call super::clicked;String  ls_gub , ls_cho , ls_rsl_jpno , ls_IOJPNO , ls_as_jpno, ls_asseq, sNull, sSaupj, sCvcod, sToday, lsIojpno, sdate
Int	 iMaxIoNo, li_asseq ,li_count , i=0
Long   k, nRcnt, nRow
Double dAmt, dItemAmt 

SetNull(sNull)

If dw_insert.AcceptText() <> 1 Then Return
If dw_1.AcceptText() <> 1 Then Return
If dw_2.AcceptText() <> 1 Then Return
if dw_imhist.AcceptText() <> 1 then return

ls_gub = dw_insert.getitemstring(1,"gub")

SetPointer(HourGlass!)
dw_insert.setredraw(false)
dw_imhist.setredraw(false)

If ls_gub = '1' then  // 매출생성 

   sSaupj = Trim(dw_1.GetItemString(1, 'saupj'))
	If IsNull(sSaupj) Or sSaupj ='' Then
		f_message_chk(30,'[부가사업장]')
		SetPointer(Arrow!)
		dw_imhist.setredraw(true)
      dw_insert.setredraw(true)
		Return
	End If
	
   sdate = Trim(dw_1.GetItemString(1, 'sdate'))
	If IsNull(sdate) Or sdate ='' Then
		f_message_chk(30,'[매출생성일]')
		SetPointer(Arrow!)
		dw_imhist.setredraw(true)
      dw_insert.setredraw(true)
		Return
	End If
	
	sCvcod = Trim(dw_1.GetItemString(1, 'cvcod'))
	If IsNull(sCvcod) Or sCvcod ='' Then
		f_message_chk(30,'[매출거래처]')
		SetPointer(Arrow!)
		dw_imhist.setredraw(true)
      dw_insert.setredraw(true)
		Return
	End If
	
   /*송장번호 채번*/
	sToday = f_today()
	
	iMaxIoNo = sqlca.fun_junpyo(gs_sabu, sToday,'C0')
	IF iMaxIoNo <= 0 THEN
		f_message_chk(51,'')
		ROLLBACK;
		SetPointer(Arrow!)
		dw_imhist.setredraw(true)
      dw_insert.setredraw(true)
		Return 
	END IF
	commit;
	
	LsIoJpNo = sToday + String(iMaxIoNo,'0000')

	dw_imhist.Reset()
	For k = 1 TO dw_2.RowCount()
		
				ls_cho = dw_2.GetItemstring(k, 'cho' )
						
				if IsNUll(ls_cho) or ls_cho = 'N' then continue 
				
				dAmt = dw_2.GetItemNumber(k, 'rslamt')
				If dAmt = 0 or IsNull(dAmt) Then
					MessageBox(  string(k) +' 행 확인', string(k) + ' 행  매출 생성할 금액이 없습니다.!!')
					dw_2.setitem(k,'cho','N')
					continue
				End If
				
				
				nRow = dw_imhist.InsertRow(0)
			   i++
			
				dw_imhist.SetItem(nRow, "imhist_sabu",       gs_sabu )
				dw_imhist.SetItem(nRow, "imhist_saupj",	    sSaupj )
				dw_imhist.SetItem(nRow, "imhist_iojpno",     LsIoJpNo+String(k,'000'))
				dw_imhist.SetItem(nRow, "imhist_sudat",      sdate)
				dw_imhist.SetItem(nRow, "imhist_iogbn",      'O16')	/* 기타매출 */
				dw_imhist.SetItem(nRow, "imhist_area_cd",    'AS')	   /* A/S 에 의한 기타매출 */
			
				dw_imhist.SetItem(nRow, "imhist_itnbr",      dw_2.GetItemString(k,'itnbr'))
				dw_imhist.SetItem(nRow, "imhist_pspec",      '.')
				dw_imhist.SetItem(nRow, "imhist_ioqty",      0)
				dw_imhist.SetItem(nRow, "imhist_ioreqty",    0)
				dw_imhist.SetItem(nRow, "imhist_ioprc",      0)
				dw_imhist.SetItem(nRow, "imhist_ioamt",      dw_2.GetItemNumber(k,'rslamt'))
				dw_imhist.SetItem(nRow, "imhist_cvcod",	   sCvcod)
			 
				dw_imhist.SetItem(nRow, "imhist_iofaqty",     0)
				dw_imhist.SetItem(nRow, "imhist_iopeqty",     0)
				dw_imhist.SetItem(nRow, "imhist_iospqty",     0)
				dw_imhist.SetItem(nRow, "imhist_iocdqty",     0)
				dw_imhist.SetItem(nRow, "imhist_iosuqty",     0)
				dw_imhist.SetItem(nRow, "imhist_inv_seq",     0)
				dw_imhist.SetItem(nRow, "imhist_balseq",      0)
				dw_imhist.SetItem(nRow, "imhist_poblsq",      0)
				dw_imhist.SetItem(nRow, "imhist_mayysq",      0)
			  
				dw_imhist.SetItem(nRow, "imhist_io_confirm", 'N') 
				dw_imhist.SetItem(nRow, "imhist_io_date",    sdate) 
				dw_imhist.SetItem(nRow, "imhist_filsk",   	'N') 	  /* 재고관리구분 */
				dw_imhist.SetItem(nRow, "imhist_inpcnf",	   'O') 	  /* 입출고 구분 */
				dw_imhist.SetItem(nRow, "imhist_jnpcrt",     '029')  /* 전표생성구분 */
				dw_imhist.SetItem(nRow, "imhist_opseq",      '9999')
				dw_imhist.SetItem(nRow, "imhist_outchk",     'N')
			
				dw_imhist.SetItem(nRow, "imhist_yebi1",      sdate)
				dw_imhist.SetItem(nRow, "imhist_dyebi3",     0)
	
		      dw_2.SetItem( k, "asgitm_iojpno",     LsIoJpNo+String(k,'000'))
				
		Next			
     	      if i< 1 then
					messageBox('확인' , '매출금액이 없거나 자료를 선택하지않았습니다.' ) 
					SetPointer(Arrow!)
					dw_imhist.setredraw(true)
					dw_insert.setredraw(true)
					return
				end if
			
				IF dw_imhist.update() <> 1 THEN
					ROLLBACK;
					f_message_chk(32,'[수불]')
					w_mdi_frame.sle_msg.text = "IMHIST  TABLE 저장작업 실패하였습니다!"
					SetPointer(Arrow!)
					dw_imhist.setredraw(true)
					dw_insert.setredraw(true)
					Return
				elseif dw_2.update() <> 1 then
					Rollback;
					f_message_chk(32, '[ASGITM Table 저장실패]' )
					w_mdi_frame.sle_msg.text = "ASGITM TABLE 저장작업 실패하였습니다!"
					SetPointer(Arrow!)
					dw_imhist.setredraw(true)
					dw_insert.setredraw(true)
					Return
				else
					ib_any_typing = False
				   w_mdi_frame.sle_msg.text = "매출자료가 생성되었습니다."
					COMMIT;
				end if
           
ELSE  // 매출삭제 
	
				
	For k = 1 TO dw_2.RowCount()
					
					ls_cho = dw_2.GetItemstring(k, 'cho' )
					if IsNUll(ls_cho) or ls_cho = 'N' then continue 
							
					ls_iojpno =   dw_2.Getitemstring( k, 'asgitm_iojpno' )

					dw_2.SetItem( k  ,  "asgitm_iojpno" ,  snull )

					 DELETE FROM "IMHIST"  
							  WHERE ( "IMHIST"."SABU" = :gs_sabu )   
							  AND   ( "IMHIST"."IOJPNO" = :ls_iojpno )   
							  AND	  ( "IMHIST"."IOGBN" = 'O16' )   ;
							  
				
						if SQLCA.sqlcode < 0 then
							f_message_Chk(32, '[A/S 매출삭제]')
							Rollback;
							w_mdi_frame.sle_msg.Text = 'A/S 매출삭제 실패하였습니다.'
							ib_any_typing = False
							SetPointer(Arrow!)
							dw_imhist.setredraw(true)
							dw_insert.setredraw(true)  
							return
						end if
						
					
     next	
	  
	         if dw_2.Update() <> 1 then
					rollback;
					f_message_chk(32, '[ASGITM Table 저장실패]' )
					w_mdi_frame.sle_msg.text = "ASGITM TABLE 저장작업 실패하였습니다!"
					SetPointer(Arrow!)
					dw_imhist.setredraw(true)
					dw_insert.setredraw(true)
					Return
				else
					ib_any_typing = False
					w_mdi_frame.sle_msg.text = "ASGITM 와 IMHIST TABLE 매출자료가 삭제되었습니다."
					COMMIT;
				end if
	
	
END IF
	
SetPointer(Arrow!)
dw_imhist.setredraw(true)
dw_insert.setredraw(true)

p_inq.triggerevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_qct_04025
boolean visible = false
integer x = 2821
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_qct_04025
boolean visible = false
integer x = 2117
integer y = 3288
end type

type cb_ins from w_inherite`cb_ins within w_qct_04025
boolean visible = false
integer x = 233
integer y = 3288
end type

type cb_del from w_inherite`cb_del within w_qct_04025
boolean visible = false
integer x = 581
integer y = 3284
end type

type cb_inq from w_inherite`cb_inq within w_qct_04025
boolean visible = false
integer x = 1769
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_qct_04025
boolean visible = false
integer x = 928
integer y = 3284
end type

type st_1 from w_inherite`st_1 within w_qct_04025
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_qct_04025
boolean visible = false
integer x = 2469
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_qct_04025
boolean visible = false
integer x = 1275
integer y = 3284
end type

type dw_datetime from w_inherite`dw_datetime within w_qct_04025
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_qct_04025
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_qct_04025
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_04025
boolean visible = false
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_04025
boolean visible = false
end type

type dw_1 from datawindow within w_qct_04025
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 1975
integer width = 1874
integer height = 260
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_qct_04025_2"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sIoCust, sNull, sIoCustName, s_cod

SetNull(sNull)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			SetItem(1,"cvnas",sNull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"cvnas",  sIoCustName)
		END IF
	Case "sdate"
		s_cod = Trim(GetText())
		if Isnull(s_cod) or s_cod = "" then return
		if f_datechk(s_cod) = -1 then
			f_message_chk(35, "[생성일자]" )
			this.setitem(1, 'sdate', snull)
			return 1
		end if
End Choose
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose case GetColumnName()
	/* 거래처 */
	Case "cvcod"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod", gs_code)
		SetItem(1,"cvnas", gs_codename)
End Choose
end event

event itemerror;return 1
end event

type dw_2 from datawindow within w_qct_04025
event ue_pressenter pbm_dwnprocessenter
integer x = 73
integer y = 268
integer width = 4517
integer height = 2020
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_qct_04025_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event dberror;//String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
//Integer iPos, iCount
//
//iCount			= 0
//sNewline			= '~r'
//sReturn			= '~n'
//sErrorcode 		= Left(sqlerrtext, 9)
//iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
//sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))
//
////For iPos = Len(sErrorSyntax) to 1 STEP -1
////	 sMsg = Mid(sErrorSyntax, ipos, 1)
////	 If sMsg   = sReturn or sMsg = sNewline Then
////		 iCount++
////	 End if
////Next
////
////sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)
////
//
//str_db_error db_error_msg
//db_error_msg.rowno 	 				= row
//db_error_msg.errorcode 				= sErrorCode
//db_error_msg.errorsyntax_system	= sErrorSyntax
//db_error_msg.errorsyntax_user		= sErrorSyntax
//db_error_msg.errorsqlsyntax			= sqlsyntax
//OpenWithParm(w_error, db_error_msg)
//
//
///*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
//		 "Error Code   -> " + sErrorcode			    + '~n' + &
//		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
//		 "SqlSyntax    -> " + Sqlsyntax
//	MESSAGEBOX("자료처리중 오류발생", sMsg) */
//
//RETURN 1
end event

event rowfocuschanged;//this.SetRowFocusIndicator(Hand!)
end event

type dw_imhist from datawindow within w_qct_04025
boolean visible = false
integer x = 265
integer y = 1148
integer width = 3113
integer height = 360
boolean bringtotop = true
string dataobject = "d_qct_04025_4"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_qct_04025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 260
integer width = 4553
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

