$PBExportHeader$w_sal_06010.srw
$PBExportComments$L/C 등록
forward
global type w_sal_06010 from w_inherite
end type
type dw_key from datawindow within w_sal_06010
end type
type rb_new from radiobutton within w_sal_06010
end type
type rb_upd from radiobutton within w_sal_06010
end type
type pb_1 from u_pb_cal within w_sal_06010
end type
type pb_2 from u_pb_cal within w_sal_06010
end type
type pb_3 from u_pb_cal within w_sal_06010
end type
type pb_4 from u_pb_cal within w_sal_06010
end type
type rr_1 from roundrectangle within w_sal_06010
end type
type rr_2 from roundrectangle within w_sal_06010
end type
end forward

global type w_sal_06010 from w_inherite
integer height = 3772
string title = "L/C 등록"
dw_key dw_key
rb_new rb_new
rb_upd rb_upd
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_06010 w_sal_06010

type variables
string sNull
end variables

forward prototypes
public function string wf_get_junpyo_no (string pidate)
public subroutine wf_init ()
public function integer wf_select_pino (integer row, string pino, string cvcod)
public function integer wf_mult_custom (string as_code, string as_gubun)
public subroutine wf_protect_key (boolean gb)
end prototypes

public function string wf_get_junpyo_no (string pidate);String  sOrderNo,sOrderGbn
string  sMaxOrderNo

sOrderGbn = 'X1'     // 채번 

sMaxOrderNo = String(sqlca.fun_junpyo(gs_sabu,pidate,sOrderGbn),'000')

IF Double(sMaxOrderNo) <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	SetNull(sOrderNo)
	Return sOrderNo
END IF

sOrderNo = pidate + sMaxOrderNo

COMMIT;

Return sOrderNo

end function

public subroutine wf_init ();rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)      // 신규입력받을 수 있도록 상태 변환

dw_key.SetFocus()
dw_key.SetRow(1)
dw_key.SetColumn('explcdt')

ib_any_typing = False
end subroutine

public function integer wf_select_pino (integer row, string pino, string cvcod);/* Pino를 선택후 뿌려줌 */
string sPino, sPono
double d_piamt=0,d_ciamt=0,d_ngamt=0, dLcPiamt
Long   nRow,nRtn

SetNull(sNull)
	
SELECT "PINO", "PIAMT", "CIAMT",  "NGAMT"  ,"PONO"  
  INTO :sPino,          :d_piamt,         :d_ciamt,          :d_ngamt  , :sPono
  FROM "EXPPIH"  
 WHERE ( "SABU" = :gs_sabu ) AND  
       ( "PINO" = :pino )   AND
	    ( "CVCOD" = :cvcod);
  
If sqlca.sqlcode <> 0 Then
	f_message_chk(33,'[P/I No.]')
	return 1
End If

SELECT sum(lcpiamt)
  INTO :dlcpiamt
  FROM explcpi
 WHERE ( sabu = :gs_sabu ) AND  
       ( pino = :pino );
If IsNull(dLcPiamt) Then dLcPiamt = 0
		 
/* 기등록여부 확인 */
nRow = dw_insert.Find("pino ='" + sPino + "'",1, dw_insert.RowCount())
If nRow > 0 Then
	f_message_chk(1,'')
	Return 1
End If

dw_insert.SetItem(row,'pino',				sPino)
dw_insert.SetItem(row,'exppih_pono',	sPono)
dw_insert.SetItem(row,'lcpiamt',			d_piamt - dLcPiamt)
dw_insert.SetItem(row,'exppih_piamt',	d_piamt)
dw_insert.SetItem(row,'exppih_ciamt',	d_ciamt)
dw_insert.SetItem(row,'exppih_ngamt',	d_ngamt)

Return 0
end function

public function integer wf_mult_custom (string as_code, string as_gubun);IF f_Mult_Custom(as_Code,as_Code,'9','','','','',as_Gubun) = -1	THEN	RETURN -1

RETURN 1
end function

public subroutine wf_protect_key (boolean gb);dw_key.SetRedraw(False)

/* 조회 */
If gb = True then
   dw_key.Modify('explcno.protect = 0')
//   dw_key.Modify("explcno.background.color = '"+String(Rgb(255,255,0))+"'")	//yellow
//   dw_key.Modify("explcdt.background.color = '"+String(Rgb(255,255,255))+"'") // white		
Else
/* 등록 */
   dw_key.Modify('explcno.protect = 1')
//   dw_key.Modify("explcno.background.color = '"+String(Rgb(192,192,192))+"'")	//gray
//	dw_key.Modify('explcdt.protect = 0')
//   dw_key.Modify("explcdt.background.color = '"+String(Rgb(195,225,184))+"'")	//mint
End If

dw_key.SetRedraw(True)

end subroutine

on w_sal_06010.create
int iCurrent
call super::create
this.dw_key=create dw_key
this.rb_new=create rb_new
this.rb_upd=create rb_upd
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_key
this.Control[iCurrent+2]=this.rb_new
this.Control[iCurrent+3]=this.rb_upd
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_3
this.Control[iCurrent+7]=this.pb_4
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_sal_06010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_key)
destroy(this.rb_new)
destroy(this.rb_upd)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
PostEvent("ue_open")
end event

event ue_open;call super::ue_open;SetNull(sNull)
dw_insert.SetTransObject(sqlca)
dw_key.SetTransObject(sqlca)

wf_init()
//dw_key.InsertRow(0)
end event

type dw_insert from w_inherite`dw_insert within w_sal_06010
integer x = 59
integer y = 668
integer width = 4539
integer height = 1656
integer taborder = 20
string dataobject = "d_sal_06010_d"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rbuttondown;String sData,s_cvcod
Long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'pino'
      s_cvcod = Trim(dw_key.GetItemString(dw_key.GetRow(),'cvcod'))
      If s_cvcod = '' Or IsNull(s_cvcod) Then
	      f_message_chk(40,'[거래처]')
	      dw_key.SetFocus()
	      dw_key.SetColumn('cvcod')
	      Return 1
      End If

		gs_code  = 'ALL' // DIRECT,LOCAL
		gs_gubun = s_cvcod
		Open(w_exppih_popup)
		If trim(gs_code) = '' Or IsNull(gs_code) Then Return
		
		Return wf_select_pino(nRow,gs_code,s_cvcod)
End Choose


end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sData,s_cvcod
Long   nRow

SetNull(gs_code)
SetNull(gs_gubun)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'pino'
      s_cvcod = Trim(dw_key.GetItemString(dw_key.GetRow(),'cvcod'))
      If s_cvcod = '' Or IsNull(s_cvcod) Then
	      f_message_chk(40,'[거래처]')
	      dw_key.SetFocus()
	      dw_key.SetColumn('cvcod')
	      Return 2
      End If
		
		sData = Trim(GetText())
		Return wf_select_pino(nrow,sData,s_cvcod)
End Choose

end event

type p_delrow from w_inherite`p_delrow within w_sal_06010
boolean visible = false
integer x = 2034
integer y = 2512
end type

type p_addrow from w_inherite`p_addrow within w_sal_06010
boolean visible = false
integer x = 1861
integer y = 2512
end type

type p_search from w_inherite`p_search within w_sal_06010
integer x = 3922
integer y = 28
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event p_search::clicked;call super::clicked;string s_explcno,pi_seq
int    nRow

nRow  = dw_key.GetRow()
If nRow <=0 Then Return
	  
s_explcno = Trim(dw_key.GetItemString(nRow,'explcno'))
If IsNull(s_explcno) Or s_explcno = '' Then Return

IF MessageBox("삭 제",s_explcno + "의 모든 자료가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

If dw_key.DeleteRow(0) = 1 Then
	nRow = dw_insert.RowCount()
	dw_insert.RowsMove(1, nRow,  Primary!,dw_insert,1,Delete!)
	IF dw_key.Update() = 1 THEN
		IF wf_mult_custom(s_explcno, '99') = -1	THEN		
			ROLLBACK USING sqlca;
			F_ROLLBACK()
			Return
		End If	
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF

	IF dw_insert.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF		  
END IF

COMMIT;

sle_msg.text ='자료를 삭제하였습니다!!'

wf_init()
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_06010
integer x = 3575
integer y = 28
end type

event p_ins::clicked;call super::clicked;string s_pino
int    nRow

If dw_insert.AcceptText() <> 1 then Return

nRow = dw_insert.RowCount()
If nRow > 0 Then
  s_pino = Trim(dw_insert.GetItemString(nRow,'pino'))
  If IsNull(s_pino) Or s_pino = '' Then
   f_message_chk(1400,'[P/I No.]')
	dw_insert.SetFocus()
	dw_insert.SetRow(nRow)
   dw_insert.SetColumn('pino')
	Return 1
  End If
End If

nRow = dw_insert.InsertRow(0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetRow(nRow)
dw_insert.SetColumn('pino')

end event

type p_exit from w_inherite`p_exit within w_sal_06010
integer y = 28
end type

type p_can from w_inherite`p_can within w_sal_06010
integer y = 28
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_sal_06010
integer x = 1961
integer y = 2488
end type

type p_inq from w_inherite`p_inq within w_sal_06010
integer x = 3401
integer y = 28
end type

event p_inq::clicked;call super::clicked;string s_explcno
int    nRow

If rb_new.Checked = True Then Return  //신규이면 조회불가

If dw_key.AcceptText() <> 1 Then Return

nRow  = dw_key.RowCount()
If nRow <=0 Then Return
	  
s_explcno = Trim(dw_key.GetItemString(nRow,'explcno'))
If IsNull(s_explcno) Or s_explcno = '' Then
   f_message_chk(1400,'[L/C NO]')
	Return 1
End If

If dw_key.Retrieve(gs_sabu,s_explcno) <= 0 Then
   sle_msg.Text = '조회한 자료가 없습니다.!!'
	rb_upd.TriggerEvent(Clicked!)       // 수정모드로 전환
	return 
End If

dw_insert.Retrieve(gs_sabu,s_explcno)  // 품목정보 조회

wf_protect_key(false)

dw_key.SetRedraw(True)

end event

type p_del from w_inherite`p_del within w_sal_06010
integer y = 28
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event p_del::clicked;call super::clicked;string s_pino
int    nRow

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return
	  
s_pino = Trim(dw_insert.GetItemString(nRow,'pino'))

Choose Case dw_insert.GetItemStatus(nRow,0,Primary!)
	Case New!,NewModified! 
		dw_insert.DeleteRow(nRow)
	Case Else	
      IF MessageBox("삭 제","SEQ : " + s_pino + "의  자료가 삭제됩니다." +"~n~n" +&
               	  "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
      If dw_insert.DeleteRow(nRow) = 1 Then
        IF dw_insert.Update() <> 1 THEN
          ROLLBACK;
          Return
        END IF
      End If	  
    
      COMMIT;
End Choose

sle_msg.text ='자료를 삭제하였습니다!!'
end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event p_del::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_mod from w_inherite`p_mod within w_sal_06010
integer x = 3749
integer y = 28
end type

event p_mod::clicked;call super::clicked;string s_explcno,s_explcdt,s_pino
int    nRow,ix,i_piseq
double d_piamt,d_sum_piamt
double d_lcpiamt,d_sum_lcpiamt
double d_ciamt,d_sum_ciamt
double d_ngamt,d_sum_ngamt

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

//------------------------------------------------------------- 일반정보 check
nRow  = dw_key.RowCount()
If nRow <=0 Then Return

/* 접수일자 확인 */
s_explcdt = Trim(dw_key.GetItemString(nRow,'explcdt'))
If f_datechk(s_explcdt) <> 1 Then
   f_message_chk(40,'[접수일자]')
	dw_key.SetFocus()
	dw_key.SetColumn('explcdt')
	Return 1
End If

/* 전표번호 채번 */
If rb_new.Checked = True  Then
   s_explcno = wf_get_junpyo_no(s_explcdt)
   dw_key.SetItem(nRow,'sabu',gs_sabu)
   dw_key.SetItem(nRow,'explcno',s_explcno)
Else
   s_explcno = Trim(dw_key.GetItemString(nRow,'explcno'))
End If

// -------------------------------------------------------// explcpi update
nRow  = dw_insert.RowCount()
	  
// PI 입력확인
For ix = nRow To 1 Step -1
	s_pino  = Trim(dw_insert.GetItemString(ix,'pino'))
	If s_pino = '' Or IsNull(s_pino) Then
      dw_insert.DeleteRow(ix)
		continue
	End If

   d_piamt = dw_insert.GetItemNumber(ix,'lcpiamt')
	dw_insert.SetItem(ix,'sabu',gs_sabu)
	dw_insert.SetItem(ix,'explcno',s_explcno)
//	dw_insert.SetItem(ix,'lcpiamt',d_piamt)
Next

nRow  = dw_insert.RowCount()
If nRow > 0 Then
  d_sum_piamt   = dw_insert.GetItemNumber(nRow,'sum_lcpiamt')
  d_sum_ciamt   = dw_insert.GetItemNumber(nRow,'sum_exppih_ciamt')
  d_sum_ngamt   = dw_insert.GetItemNumber(nRow,'sum_exppih_ngamt')
Else
  d_sum_piamt   = 0
  d_sum_lcpiamt = 0
  d_sum_ciamt   = 0
  d_sum_ngamt   = 0
End If
	
dw_key.SetItem(1,'piamt',d_sum_piamt)
dw_key.SetItem(1,'ciamt',d_sum_ciamt)
dw_key.SetItem(1,'negoamt',d_sum_ngamt)

// piamt = ciamt = ngamt 이면 완료 처리
If d_sum_lcpiamt = d_sum_ciamt Then
  If d_sum_ciamt = d_sum_piamt Then
	  If d_sum_piamt = d_sum_ngamt Then
	     If d_sum_ngamt <> 0 Then dw_key.SetItem(1,'lcsts','9')
		End If
  End If
End If

IF dw_key.Update() = 1 THEN                    // explc update
	IF wf_mult_custom(s_explcno, '1') = -1	THEN		
		ROLLBACK USING sqlca;
		F_ROLLBACK()
		Return
	End If	
ELSE
	ROLLBACK;
	f_Rollback()
END IF

IF dw_insert.Update() <> 1 THEN
   ROLLBACK;
   Return
END IF

commit;

rb_upd.Checked = True
cb_inq.TriggerEvent(Clicked!)

ib_any_typing = False

sle_msg.text ='자료를 저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_sal_06010
integer x = 3045
integer y = 2508
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_sal_06010
integer x = 1193
integer y = 2508
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_sal_06010
integer x = 402
integer y = 2508
integer width = 361
integer taborder = 40
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_06010
integer x = 1989
integer y = 2508
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_sal_06010
integer x = 41
integer y = 2508
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_sal_06010
integer x = 439
integer y = 2496
integer taborder = 80
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_06010
end type

type cb_can from w_inherite`cb_can within w_sal_06010
integer x = 2693
integer y = 2508
integer taborder = 90
end type

type cb_search from w_inherite`cb_search within w_sal_06010
integer x = 1545
integer y = 2508
integer width = 430
integer taborder = 60
string text = "L/C 삭제(&W)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06010
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06010
end type

type dw_key from datawindow within w_sal_06010
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 224
integer width = 4590
integer height = 420
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06010_h"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string sdate, sPino, sExplcno
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long   nRow,nRtn,ix,nCnt

If rb_new.Checked <> True And rb_upd.Checked <> True Then
	f_message_chk(57,' 작업구분 선택')
	Return 2
End If

SetNull(sNull)
Choose Case GetColumnName()
	Case 'explcno'
	  sExplcno = Trim(GetText())
	  IF sExplcno = "" OR IsNull(sExplcno) THEN RETURN

     SELECT COUNT(*)
       INTO :nCnt  
       FROM "EXPLC"  
      WHERE ( "EXPLC"."SABU" = :gs_sabu ) AND  
            ( "EXPLC"."EXPLCNO" = :sExplcno );
		
	  IF nCnt <=0 THEN
		 f_message_chk(33,'[L/C NO]')
       SetItem(nRow,'explcno',sNull)
		 Return 1
	  ELSE
		 cb_inq.TriggerEvent(Clicked!)
	  END If
/* 접수일자 */
	Case 'explcdt'
		nRow = GetRow()
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,'explcdt',sNull)
	      Return 1
      END IF
		
		Post SetItem(nRow,'explcdt',sDate)
	/* 거래처 */	
	Case 'cvcod'
		nRow = dw_insert.RowCount()
		If nRow > 0 Then
        sPino = Trim(dw_insert.GetItemString(nRow,'pino'))
		  If sPino <> '' and Not IsNull(sPino) Then
			 MessageBox('확  인','관련 P/I가 존재합니다')
			 Return 2
		  End If
      End If	

		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod',   sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcodnm",	scvnas)
		END IF
	Case 'opndat','validdt','shipsch'                    // 접수일자
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	setcolumn(GetColumnName())
	      Return 1
      END IF
End Choose

ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;string sPino
long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case "explcno"                              // lc 접수번호 선택 popup 
		If rb_upd.Checked = False Then Return // 수정일 경우만...
		
   	Open(w_explc_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1, "explcno",gs_code)
		cb_inq.TriggerEvent(Clicked!)
	Case "cvcod"
		nRow = dw_insert.RowCount()
		If nRow > 0 Then
			sPino = Trim(dw_insert.GetItemString(nRow,'pino'))
			If sPino <> '' and Not IsNull(sPino) Then
				MessageBox('확  인','관련 P/I가 존재합니다')
				Return 2
			End If
		End If
		
		gs_gubun = '2'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose
end event

type rb_new from radiobutton within w_sal_06010
integer x = 78
integer y = 88
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "신규"
end type

event clicked;If This.Checked = True Then
   wf_protect_key(false)

	dw_key.SetRedraw(False)
   dw_key.Reset()
   dw_key.InsertRow(0)
   dw_insert.Reset()
	
	dw_key.SetFocus()
	dw_key.SetRow(1)
   dw_key.SetItem(dw_key.GetRow(),'explcdt','')	
	dw_key.SetColumn('explcdt')
	dw_key.SetRedraw(True)	
End If

end event

type rb_upd from radiobutton within w_sal_06010
integer x = 329
integer y = 88
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;If This.Checked = True Then
   wf_protect_key(true)

	dw_key.SetRedraw(False)	
   dw_key.Reset()
   dw_key.InsertRow(0)

   dw_insert.Reset()
	
	dw_key.SetFocus()
	dw_key.SetRow(1)
   dw_key.SetItem(dw_key.GetRow(),'explcno','')	
	dw_key.SetColumn('explcno')
	dw_key.SetRedraw(True)	
End If

end event

type pb_1 from u_pb_cal within w_sal_06010
integer x = 809
integer y = 340
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('explcdt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'explcdt', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06010
integer x = 3209
integer y = 248
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('opndat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'opndat', gs_code)

end event

type pb_3 from u_pb_cal within w_sal_06010
integer x = 3209
integer y = 344
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('validdt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'validdt', gs_code)

end event

type pb_4 from u_pb_cal within w_sal_06010
integer x = 3209
integer y = 432
integer width = 78
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('shipsch')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'shipsch', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 56
integer width = 567
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_06010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 656
integer width = 4562
integer height = 1676
integer cornerheight = 40
integer cornerwidth = 55
end type

