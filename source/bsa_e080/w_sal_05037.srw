$PBExportHeader$w_sal_05037.srw
$PBExportComments$매출및 부가세 회계시스템으로 이월
forward
global type w_sal_05037 from w_inherite
end type
type rr_2 from roundrectangle within w_sal_05037
end type
type rb_1 from radiobutton within w_sal_05037
end type
type rb_2 from radiobutton within w_sal_05037
end type
type dw_ip from datawindow within w_sal_05037
end type
type cbx_1 from checkbox within w_sal_05037
end type
type rr_1 from roundrectangle within w_sal_05037
end type
type dw_interface from u_key_enter within w_sal_05037
end type
type pb_1 from u_pb_cal within w_sal_05037
end type
type pb_2 from u_pb_cal within w_sal_05037
end type
type rr_3 from roundrectangle within w_sal_05037
end type
end forward

global type w_sal_05037 from w_inherite
string title = "매출및 부가세 회계시스템으로 전송"
rr_2 rr_2
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
cbx_1 cbx_1
rr_1 rr_1
dw_interface dw_interface
pb_1 pb_1
pb_2 pb_2
rr_3 rr_3
end type
global w_sal_05037 w_sal_05037

on w_sal_05037.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.cbx_1=create cbx_1
this.rr_1=create rr_1
this.dw_interface=create dw_interface
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.dw_interface
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.rr_3
end on

on w_sal_05037.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.cbx_1)
destroy(this.rr_1)
destroy(this.dw_interface)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_3)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(sqlca)
dw_interface.SetTransObject(sqlca)

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

/* User별 관할구역 Setting */
String sarea, steam, saupj

// 관할구역 설정
f_child_saupj(dw_ip, 'sarea', '%')

// 영업팀 권한 설정
If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'sarea', sarea)
	dw_ip.Modify("sarea.protect=1")
End If

dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')


// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'saupj')

dw_ip.SetItem(1, 'sdatef', left(is_today,6)+'01')
dw_ip.SetItem(1, 'sdatet', is_today)
end event

type dw_insert from w_inherite`dw_insert within w_sal_05037
integer x = 41
integer y = 316
integer width = 4539
integer height = 1972
integer taborder = 20
string dataobject = "d_sal_05037_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_sal_05037
boolean visible = false
integer x = 2066
integer y = 2676
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_05037
boolean visible = false
integer x = 2071
integer y = 2636
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_05037
integer x = 3922
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_search::clicked;call super::clicked;//전송처리
Long ix,nRcnt,nCnt,nRow
String sDatef,sDatet,sJasa,sSaleDt,sCheckNo,sSaupj, sCurr, sVelegbn
Double dSaleNo

nRcnt = dw_insert.RowCount()
If nRcnt <= 0 Then Return

dw_interface.Reset()

/* 검색할 키 */
sDatef = dw_ip.GetItemString(1,'sdatef')
sDatet = dw_ip.GetItemString(1,'sdatet')
sSaupj = dw_insert.GetItemString(1,'saupj')
IF IsNull(sSaupj) Or sSaupj = '' THEN
	f_message_chk(30,'[부가사업장]')
	dw_ip.SetColumn("saupj")
	Return
END IF

/* 자사 */
  SELECT "REFFPF"."RFNA2"  
    INTO :sJasa  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU"  = '1' ) AND 
         ( "REFFPF"."RFCOD" = 'AD' ) AND
         ( "REFFPF"."RFGUB" = :sSaupj )  ;

sJasa = Trim(sJasa)

For ix = 1 To nRcnt
	If dw_insert.GetItemString(ix,'chk') = 'Y' then
		sVelegbn = dw_insert.GetItemString(ix,'v_elegbn')
		if isNull(sVelegbn) or sVelegbn = '' then
			f_message_chk(30,'[세금계산서구분]')
			Return
		end if
	end if
Next

SetPointer(HourGlass!)
/* 회계시스템으로 이월 */
For ix = 1 To nRcnt
	If dw_insert.GetItemString(ix,'chk') = 'Y' then
		
		/* 매출세금계산서 자동전표 자료 */
		nRow = dw_interface.InsertRow(0)
		sSaleDt = dw_insert.GetItemString(ix,"SALEDT" )
		dSaleNo = dw_insert.GetItemNumber(ix,"SALENO" )
		sCheckNo = dw_insert.GetItemString(ix,"CHECKNO" )
		
		dw_interface.SetItem(nRow,"SALEDT", sSaleDt )
		dw_interface.SetItem(nRow,"SALENO", dSaleNo )
		dw_interface.SetItem(nRow,"CHECKNO", sCheckNo)
		dw_interface.SetItem(nRow,"CVNAS", dw_insert.GetItemString(ix,"CVNAS"))
		dw_interface.SetItem(nRow,"GON_AMT", dw_insert.GetItemNumber(ix,"GON_AMT"))
		dw_interface.SetItem(nRow,"VAT_AMT", dw_insert.GetItemNumber(ix,"VAT_AMT"))
		dw_interface.SetItem(nRow,"SABU", gs_sabu)		/* 부가사업장 */
//		dw_interface.SetItem(nRow,"SALE_DEPT", dw_insert.GetItemString(ix,"DEPTCODE"))
		dw_interface.SetItem(nRow,"SALE_DEPT", gs_dept)	/* 로그인 사원의 소속부서 - 2007.02.20 - 송병호 */
		dw_interface.SetItem(nRow,"CVCOD", dw_insert.GetItemString(ix,"CVCOD" ))
		dw_interface.SetItem(nRow,"SANO", dw_insert.GetItemString(ix,"SANO" ))
		dw_interface.SetItem(nRow,"OWNAM", dw_insert.GetItemString(ix,"OWNAM" ))
		dw_interface.SetItem(nRow,"RESIDENT", dw_insert.GetItemString(ix,"RESIDENT" ))
		dw_interface.SetItem(nRow,"UPTAE", dw_insert.GetItemString(ix,"UPTAE" ))
		dw_interface.SetItem(nRow,"JONGK", dw_insert.GetItemString(ix,"JONGK" ))
		dw_interface.SetItem(nRow,"ADDR1", dw_insert.GetItemString(ix,"ADDR1" ))
		dw_interface.SetItem(nRow,"ADDR2", dw_insert.GetItemString(ix,"ADDR2" ))
		dw_interface.SetItem(nRow,"DESCR", dw_insert.GetItemString(ix,"DESCR" ))
		dw_interface.SetItem(nRow,"TAX_NO", dw_insert.GetItemString(ix,"TAX_NO" ))
		dw_interface.SetItem(nRow,"VOUC_GU", dw_insert.GetItemString(ix,"VOUC_GU" ))
		dw_interface.SetItem(nRow,"LCNO", dw_insert.GetItemString(ix,"LCNO" ))

		dw_interface.SetItem(nRow,"FOR_AMT", dw_insert.GetItemNumber(ix,"FOR_AMT" ))
		dw_interface.SetItem(nRow,"EXCHRATE", dw_insert.GetItemNumber(ix,"EXCHRATE" ))
		dw_interface.SetItem(nRow,"JASA", sJasa )
		dw_interface.SetItem(nRow,"EXPGU", dw_insert.GetItemString(ix,"EXPGU" ))
		dw_interface.SetItem(nRow,"ALC_GU", 'N')
		dw_interface.SetItem(nRow,"SAUPJ",  dw_insert.GetItemString(ix,"SAUPJ" ))	/* 부가사업장 */
		dw_interface.SetItem(nRow,"VATGBN", dw_insert.GetItemString(ix,"VATGBN" ))	/* 부가세업종구분 */
		dw_interface.SetItem(nRow,"v_elegbn", dw_insert.GetItemString(ix,"v_elegbn" ))
		/* 통화단위 */
//		SELECT min(nvl(yebi2,'WON')) INTO :sCurr FROM IMHIST WHERE CHECKNO = :sCheckno;
//		dw_interface.SetItem(nRow,"CURR", sCurr)
		
		/* 매출세금계산서 품목 자동전표 자료 */
		/* 매출계정 - 국내일경우 - 제품매출내수 */
		/* 매출구분 - 1:일반 (일반판매는 구분하여 LCLGBN = 'L', local수출 그외는 국내매출),2:A/S   */
		INSERT INTO "KIF03OT1"  
				 ( "SABU",      "IOJPNO",   "IP_JPNO",  "SUDAT",   
					"ITNBR",     "IOQTY",   
					"IOPRC",     "IOAMT", 
					"ACCODE", 
					"DESCR",		 "SAUPJ",
					"SALEGU" )
		  SELECT A.SABU,      A.IOJPNO,   A.CHECKNO,  A.IO_DATE,   
					A.ITNBR,     A.IOQTY * NVL(E.CALVALUE, 1),  
               A.IOPRC,     
					/* 절사되면 원단위 마감금액 달라짐 (자재마감-박일영JI). - by shingoon 2007.11.19 */
					/*TRUNC(A.IOAMT * NVL(E.CALVALUE, 1), 0),*****************************************/
					A.IOAMT * NVL(E.CALVALUE, 1),
					/*********************************************************************************/
					FUN_GET_ITNACC(A.ITNBR, decode(A.lclgbn, 'L', '3', '1')),
					A.PSPEC,		 A.SAUPJ,
					DECODE(A.AREA_CD, 'AS', '2', decode(A.lclgbn, 'L', '3', '1'))
			 FROM IMHIST A, SALEH B, ITEMAS C, IOMATRIX E
			WHERE ( A.SABU    = B.SABU ) and  
					( A.CHECKNO = B.CHECKNO ) and  
					( A.SABU    = E.SABU(+) ) and  
					( A.IOGBN   = E.IOGBN(+) ) and  
					( A.ITNBR   = C.ITNBR(+) ) and  
					( ( B.SALENO = :dSaleNo ) and
					  ( B.SALEDT = :sSaleDt ))  ;
					  
		If sqlca.sqlcode <> 0 Then
			MessageBox(ssaledt,string(dsaleno))
			f_message_chk(32,'[SQLcode : ' + string(sqlca.sqlcode)+']')
			RollBack;
			Return
		End If
	
		nCnt += 1
	End If
Next

If nCnt <=0 Then
	f_message_chk(57,'')
	Return
End If

If dw_interface.Update() <> 1 then
	RollBack;
	Return
Else
	Commit;
	p_inq.TriggerEvent(Clicked!)
End If

sle_msg.text ='자료를 저장하였습니다!!'

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_05037
boolean visible = false
integer x = 2327
integer y = 2644
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sal_05037
end type

type p_can from w_inherite`p_can within w_sal_05037
end type

event p_can::clicked;call super::clicked;cbx_1.Checked = False

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_sal_05037
boolean visible = false
integer x = 2565
integer y = 2664
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_05037
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String sDatef,sDatet, sSaupj, sArea
Long   nRcnt

If dw_ip.AcceptText() <> 1 Then Return
If dw_ip.RowCount() <= 0 Then Return

sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
sSaupj = Trim(dw_ip.GetItemString(1,'saupj'))
sArea  = Trim(dw_ip.GetItemString(1, 'sarea'))

If IsNull(sArea) Or sArea = '' Then sArea = ''

dw_ip.SetFocus()
IF f_datechk(sDatef) <> 1 THEN
	f_message_chk(30,'[발행일자]')
	dw_ip.SetColumn("sdatef")
	Return
END IF

IF f_datechk(sDatet) <> 1 THEN
	f_message_chk(30,'[발행일자]')
	dw_ip.SetColumn("sdatet")
	Return
END IF

IF IsNull(sSaupj) Or sSaupj = '' THEN
	f_message_chk(30,'[부가사업장]')
	dw_ip.SetColumn("saupj")
	Return
END IF

If rb_1.Checked = True Then
	nRcnt = dw_insert.Retrieve(gs_sabu, sDatef,sDatet, sSaupj, sArea+'%')
Else
	nRcnt = dw_interface.Retrieve(sDatef,sDatet, sSaupj, sArea+'%')
End If

If nRcnt <= 0 Then
	f_message_chk(50,'')
	dw_ip.Setfocus()
End If

end event

type p_del from w_inherite`p_del within w_sal_05037
end type

event p_del::clicked;call super::clicked;Long ix,nRcnt,nCnt,nRow
String sDatef,sDatet,sJasa,sCheckNo, sSaupj

nRcnt = dw_interface.RowCount()
If nRcnt <= 0 Then Return

/* 검색할 키 */
sDatef = dw_ip.GetItemString(1,'sdatef')
sDatet = dw_ip.GetItemString(1,'sdatet')
sSaupj = dw_ip.GetItemString(1,'saupj')
IF IsNull(sSaupj) Or sSaupj = '' THEN
	f_message_chk(30,'[부가사업장]')
	dw_ip.SetColumn("saupj")
	Return
END IF

/* 매출세금계산서 품목 자동전표 삭제 */
For ix = nRcnt To 1 Step -1
	If dw_interface.GetItemString(ix,'chk') = 'Y' then
		
		sCheckNo = dw_interface.GetItemString(ix,'checkno')
      DELETE FROM "KIF03OT1"  
       WHERE ( "KIF03OT1"."IP_JPNO" = :sCheckNo ) ;

	End If
Next

SetPointer(HourGlass!)

/* 매출세금계산서 자동전표 삭제 */
For ix = nRcnt To 1 Step -1
	If dw_interface.GetItemString(ix,'chk') = 'Y' then
		dw_interface.DeleteRow(ix)
		
		nCnt += 1
	End If
Next

If nCnt <=0 Then
	f_message_chk(57,'')
	Return
End If

If dw_interface.Update() <> 1 then
	RollBack;
	Return
Else
	Commit;
	p_inq.TriggerEvent(Clicked!)
End If

sle_msg.text ='자료를 저장하였습니다!!'

end event

type p_mod from w_inherite`p_mod within w_sal_05037
boolean visible = false
integer x = 2706
integer y = 2688
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_sal_05037
end type

type cb_mod from w_inherite`cb_mod within w_sal_05037
integer x = 1006
integer y = 2688
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_05037
integer x = 645
integer y = 2688
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_sal_05037
end type

type cb_inq from w_inherite`cb_inq within w_sal_05037
end type

type cb_print from w_inherite`cb_print within w_sal_05037
integer x = 1358
integer y = 2688
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_05037
end type

type cb_can from w_inherite`cb_can within w_sal_05037
end type

type cb_search from w_inherite`cb_search within w_sal_05037
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_05037
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_05037
end type

type rr_2 from roundrectangle within w_sal_05037
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 308
integer width = 4562
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within w_sal_05037
integer x = 59
integer y = 48
integer width = 338
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "전송처리"
boolean checked = true
end type

event clicked;dw_insert.Reset()
dw_interface.Reset()

p_search.Enabled = True
p_del.Enabled = False
p_search.PictureName = "C:\erpman\image\처리_up.gif"
p_del.PictureName = "C:\erpman\image\삭제_d.gif"
dw_insert.SetFocus()
dw_insert.Visible = True
dw_interface.Visible = False

cbx_1.Checked = False

dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')
end event

type rb_2 from radiobutton within w_sal_05037
integer x = 398
integer y = 48
integer width = 338
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "전송취소"
end type

event clicked;call super::clicked;dw_insert.Reset()
dw_interface.Reset()

p_search.Enabled = False
p_del.Enabled = True

p_search.PictureName = "C:\erpman\image\처리_d.gif"
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

dw_interface.SetFocus()
dw_insert.Visible = False
dw_interface.Visible = True

cbx_1.Checked = False

dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')
end event

type dw_ip from datawindow within w_sal_05037
event ue_processenter pbm_dwnprocessenter
integer x = 27
integer y = 160
integer width = 3118
integer height = 136
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_05037_3"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sSuDate,sNull, sSaupj

SetNull(sNull)
Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
//		f_child_saupj(this, 'sarea','%')
	Case "sdatef" , "sdatet"
		sSuDate = Trim(this.GetText())
		IF sSuDate ="" OR IsNull(sSuDate) THEN RETURN
		
		IF f_datechk(sSuDate) = -1 THEN
			f_message_chk(35,'[발행기간]')
			this.SetItem(1,GetColumnName() ,snull)
			Return 1
		END IF
END Choose
end event

event itemerror;return 1
end event

type cbx_1 from checkbox within w_sal_05037
integer x = 4146
integer y = 204
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체선택"
end type

event clicked;long ix
String sStatus

IF This.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

If rb_1.Checked = True Then
  For ix = 1 To dw_insert.RowCount()
	  dw_insert.SetItem(ix,'chk',sStatus)
  Next
ElseIf rb_2.Checked = True Then
  For ix = 1 To dw_interface.RowCount()
	  dw_interface.SetItem(ix,'chk',sStatus)
  Next
End If


end event

type rr_1 from roundrectangle within w_sal_05037
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 24
integer width = 722
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_interface from u_key_enter within w_sal_05037
integer x = 41
integer y = 316
integer width = 4539
integer height = 1972
integer taborder = 70
string dataobject = "d_sal_05037_2"
boolean vscrollbar = true
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_05037
integer x = 713
integer y = 184
integer width = 78
integer height = 80
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

type pb_2 from u_pb_cal within w_sal_05037
integer x = 1170
integer y = 184
integer width = 78
integer height = 80
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

type rr_3 from roundrectangle within w_sal_05037
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4055
integer y = 188
integer width = 535
integer height = 104
integer cornerheight = 40
integer cornerwidth = 55
end type

