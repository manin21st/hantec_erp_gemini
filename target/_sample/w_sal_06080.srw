$PBExportHeader$w_sal_06080.srw
$PBExportComments$B/L 등록
forward
global type w_sal_06080 from w_inherite
end type
type rb_new from radiobutton within w_sal_06080
end type
type rb_upd from radiobutton within w_sal_06080
end type
type pb_1 from u_pic_cal within w_sal_06080
end type
type pb_2 from u_pic_cal within w_sal_06080
end type
type r_1 from rectangle within w_sal_06080
end type
end forward

global type w_sal_06080 from w_inherite
integer width = 4686
integer height = 2464
string title = "B/L 등록"
rb_new rb_new
rb_upd rb_upd
pb_1 pb_1
pb_2 pb_2
r_1 r_1
end type
global w_sal_06080 w_sal_06080

type variables
string is_pino
string SaleConfirm, OutConfirm
end variables

forward prototypes
public subroutine wf_init ()
public function integer wf_select_cino (integer row, string cino)
public function integer wf_select_lcno (integer row, string lcno)
public subroutine wf_protect_key (boolean gb)
end prototypes

public subroutine wf_init ();dw_input.SetFocus()
wf_protect_key(false)

dw_input.SetColumn('blno')         // 접수일자

//cb_mod.Enabled = False
//cb_ins.Enabled = False
//cb_del.Enabled = False
//cb_search.Enabled = False
		
rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)      // 신규입력받을 수 있도록 상태 변환

ib_any_typing = False
end subroutine

public function integer wf_select_cino (integer row, string cino);string s_cino,s_cidate,s_cvcodnm,s_vf_to,s_blno

SELECT "EXPCIH"."CINO","EXPCIH"."CIDATE",
       fun_get_cvnas("EXPCIH"."CVCOD"),"EXPCIH"."VF_TO","EXPCIH"."BLNO"
  INTO :s_cino ,:s_cidate, :s_cvcodnm, :s_vf_to,:s_blno
  FROM "EXPCIH"  
 WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
       ( "EXPCIH"."CINO" = :cino ) AND
		 ( "EXPCIH"."BLNO" IS NULL ) ;

If sqlca.sqlcode <> 0 Then 
   f_message_chk(98,'[C/I NO]')
	Return 1
End If

If Len(Trim(s_blno)) <= 0 Then 
	dw_insert.SetItem(row,'cino','')
   dw_insert.SetItem(row,'cidate','')
   dw_insert.SetItem(row,'cvcodnm','')
   dw_insert.SetItem(row,'vf_to','')	
   f_message_chk(97,'[C/I NO]')
   REturn 1
End If	

If IsNull(s_cino)    Then s_cino = ''
If IsNull(s_cidate) Then s_cidate = ''
If IsNull(s_cvcodnm) Then s_cvcodnm = ''
If IsNull(s_vf_to) Then s_vf_to = ''

dw_insert.SetItem(row,'cino',s_cino)
dw_insert.SetItem(row,'cidate',s_cidate)
dw_insert.SetItem(row,'cvcodnm',s_cvcodnm)
dw_insert.SetItem(row,'vf_to',s_vf_to)

Return 0
end function

public function integer wf_select_lcno (integer row, string lcno);string s_lcno,s_cvcodnm,s_banklcno
dec    lcamt
  
  SELECT "EXPLC"."EXPLCNO",   
         "EXPLC"."BANKLCNO",   
         "EXPLC"."LCAMT",
         FUN_GET_CVNAS("EXPLC"."CVCOD" ) AS CVCODNM  
	 INTO :s_lcno, :s_banklcno ,:lcamt,:s_cvcodnm
    FROM "EXPLC"  
   WHERE ( "EXPLC"."SABU" = :gs_sabu ) AND  
         ( "EXPLC"."EXPLCNO" = :lcno )   ;

dw_input.SetItem(row,'explcno',s_lcno)

If Len(Trim(s_lcno)) <= 0 Or IsNull(s_lcno) Then    REturn 1

Return 0
end function

public subroutine wf_protect_key (boolean gb);Choose Case gb
	Case True
		dw_input.Modify('blno.protect = 1')
	Case False
		dw_input.Modify('blno.protect = 0')
End Choose


end subroutine

on w_sal_06080.create
int iCurrent
call super::create
this.rb_new=create rb_new
this.rb_upd=create rb_upd
this.pb_1=create pb_1
this.pb_2=create pb_2
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_new
this.Control[iCurrent+2]=this.rb_upd
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.r_1
end on

on w_sal_06080.destroy
call super::destroy
destroy(this.rb_new)
destroy(this.rb_upd)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.r_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_input.SetTransObject(sqlca)
dw_input.InsertRow(0)

dw_insert.SetTransObject(sqlca)

/* --------------------------------------------- */
/* 매출확정일 여부 (1:면장,2:출고,3:b/l,4:임의)  */
/* --------------------------------------------- */
select substr(dataname,1,1) into :SaleConfirm
  from syscnfg
 where sysgu = 'S' and
       serial = 8 and
       lineno = 10;

/* --------------------------------------------- */
/* 출고여부 체크 ('Y':출고인경우)                */
/* --------------------------------------------- */
select substr(dataname,1,1) into :OutConfirm
  from syscnfg
 where sysgu = 'T' and
       serial = 1 and
       lineno = 1;
		 
wf_init()
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_search.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_append;call super::ue_append;p_ins.TriggerEvent(Clicked!)
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", true) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true) //// 삭제
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", true) //// 찾기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 true) //// 필터
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = true //// 추가
m_main2.m_window.m_del.enabled = true  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = true  //// 찾기
m_main2.m_window.m_filter.enabled = true //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_sal_06080
integer x = 5362
integer y = 3348
end type

type sle_msg from w_inherite`sle_msg within w_sal_06080
integer x = 5554
integer y = 3164
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_06080
integer x = 5554
integer y = 3164
end type

type st_1 from w_inherite`st_1 within w_sal_06080
integer x = 18
integer y = 3300
end type

type p_search from w_inherite`p_search within w_sal_06080
integer x = 3744
integer y = 3172
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "..\image\삭제_up.gif"
end type

event p_search::clicked;call super::clicked;string s_blno,s_cino
int    nRow,ix

nRow  = dw_input.GetRow()
If nRow <=0 Then Return
	  
s_blno = Trim(dw_input.GetItemString(nRow,'blno'))
If IsNull(s_blno) Or s_blno = '' Then
   f_message_chk(1400,'[B/L NO]')
	dw_input.SetFocus()
	dw_input.SetColumn('blno')
	Return
End If

IF MessageBox("삭 제",s_blno + "의 모든 자료가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
dw_input.DeleteRow(0)
If dw_input.Update() <> 1 Then 
	RollBack ;
	Return
End If

nRow = dw_insert.RowCount()
If nRow > 0 Then 
   For ix = 1 To nRow
	  s_cino = Trim(dw_insert.GetItemString(nrow,'cino'))

 	  If SaleConfirm	= '3' Then
       UPDATE "EXPCIH"  
          SET "BLNO" = null,
			     "SALEDT" = null
        WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
              ( "EXPCIH"."CINO" = :s_cino );
 	  Else
       UPDATE "EXPCIH"  
          SET "BLNO" = null
        WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
              ( "EXPCIH"."CINO" = :s_cino );
	  End If
     If sqlca.sqlcode <> 0 Then
       f_message_chk(32,'')
	    Rollback;
	    Return
     End If
	Next
End IF

COMMIT;

sle_msg.text ='자료를 삭제하였습니다!!'

wf_init()
end event

event p_search::ue_lbuttondown;PictureName = "..\image\삭제_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "..\image\삭제_up.gif"
end event

type p_addrow from w_inherite`p_addrow within w_sal_06080
integer x = 5550
integer y = 3168
end type

type p_delrow from w_inherite`p_delrow within w_sal_06080
integer x = 5550
integer y = 3168
end type

type p_mod from w_inherite`p_mod within w_sal_06080
integer x = 3342
integer y = 3168
end type

event p_mod::clicked;call super::clicked;string sBlno, sCino, sShipdat
Long   nRow,ix,i_piseq, nCnt

If dw_input.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

// bl 헤더 저장
nRow  = dw_input.GetRow()
If nRow <=0 Then Return

sBlno = Trim(dw_input.GetItemString(nRow,'blno'))
If IsNull(sBlno) Or sBlno = '' Then
	f_message_chk(1400,'[B/L NO]')
	dw_input.SetFocus()
	dw_input.SetColumn('blno')
	Return
End If

sshipdat = Trim(dw_input.GetItemString(nRow,'shipdat'))
If SaleConfirm	= '3' Then
	If f_datechk(sshipdat) <> 1 Then
		f_message_chk(1400,'[선적일자]')
		dw_input.SetFocus()
		dw_input.SetColumn('shipdat')
		Return
	End If
	
	/* 매출 확정시점의 환율 확인 */
	SELECT COUNT(*) Into :nCnt
	  FROM RATEMT
	 WHERE RDATE = :sShipDat;
	 
	If nCnt <= 0 Then
		RollBack;
		MessageBox('확 인',String(sShipDat,'@@@@.@@.@@')+'자 환율이 없습니다')
		Return
	End If
End If

SetPointer(HourGlass!)

IF dw_input.Update() <> 1 THEN
	ROLLBACK;
	Return
END IF

/* CI 입력확인 - update */
nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1
	sCino  = Trim(dw_insert.GetItemString(ix,'cino'))
	If sCino = '' Or IsNull(sCino) Then
		dw_insert.DeleteRow(ix)
		continue
	End If
	
	If SaleConfirm	= '3' Then					 
		UPDATE "EXPCIH"  
			SET "BLNO"   = :sBlno,
				 "SALEDT" = :sShipdat
		 WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
				 ( "EXPCIH"."CINO" = :sCino );
	Else
		UPDATE "EXPCIH"  
			SET "BLNO"   = :sBlno
		 WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
		 		 ( "EXPCIH"."CINO" = :sCino );
	End If
	If sqlca.sqlcode <> 0 Then
		rollback;
		f_message_chk(32,'')
		Return
	End If
Next

sle_msg.text ='자료를 저장하였습니다!!'	  
ib_any_typing = False    

COMMIT;
end event

type p_del from w_inherite`p_del within w_sal_06080
boolean visible = true
integer x = 3922
integer y = 8
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "..\image\행삭제_up.gif"
end type

event p_del::clicked;call super::clicked;string s_cino,s_blno
Long   nRow

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return

s_blno = Trim((dw_input.GetItemString(1,'blno')))
s_cino  = Trim((dw_insert.GetItemString(nRow,'cino')))
IF MessageBox("삭 제","SEQ : " + s_cino + "의  자료가 삭제됩니다." +"~n~n" +&
           	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

If SaleConfirm	= '3' Then
  UPDATE "EXPCIH"  
     SET "BLNO" = NULL,
	      "SALEDT" = NULL
   WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
         ( "EXPCIH"."CINO" = :s_cino );
ELSE
  UPDATE "EXPCIH"  
     SET "BLNO" = NULL
   WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
         ( "EXPCIH"."CINO" = :s_cino );
END IF
If sqlca.sqlcode <> 0 Then
   f_message_chk(32,'')
	Rollback;
	Return
End If
   
COMMIT;

dw_insert.Retrieve(s_blno)

sle_msg.text ='자료를 삭제하였습니다!!'

end event

event p_del::ue_lbuttondown;PictureName = "..\image\행삭제_dn.gif"
end event

event p_del::ue_lbuttonup;PictureName = "..\image\행삭제_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sal_06080
integer x = 2638
integer y = 3168
end type

type p_print from w_inherite`p_print within w_sal_06080
integer x = 2286
integer y = 3168
end type

type p_can from w_inherite`p_can within w_sal_06080
integer x = 4046
integer y = 3168
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_exit from w_inherite`p_exit within w_sal_06080
integer x = 4398
integer y = 3168
end type

type p_ins from w_inherite`p_ins within w_sal_06080
integer x = 2990
integer y = 3168
end type

event p_ins::clicked;call super::clicked;string s_blno
int    nRow,nMax,ix,itemp,rowcnt

If dw_input.AcceptText() <> 1 Then Return

s_blno = Trim(dw_input.GetItemString(1,'blno'))
If IsNull(s_blno) Or s_blno = '' Then
   f_message_chk(1400,' B/L NO')
	dw_input.SetFocus()
	dw_input.SetColumn('blno')
	Return 1
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow,'sabu',gs_sabu)
dw_insert.SetItem(nRow,'blno',s_blno)
dw_insert.SetItemStatus(nRow, 0, Primary!, NotModified!)
dw_insert.SetItemStatus(nRow, 0, Primary!, New!)
dw_insert.SetFocus()
dw_insert.SetRow(nRow)
dw_insert.SetColumn('blno')

end event

type p_new from w_inherite`p_new within w_sal_06080
integer x = 1934
integer y = 3168
end type

type dw_input from w_inherite`dw_input within w_sal_06080
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 188
integer width = 4576
integer height = 192
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06080"
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string sdate,cvnas,s_pino,s_pidate,s_pigu,s_pists,s_blno,sNull
Long   nRow,nCnt

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

If rb_new.Checked <> True And rb_upd.Checked <> True Then
	f_message_chk(57,' 작업구분 선택')
	Return 2
End If

SetNull(sNull)
nRow = GetRow()
Choose Case GetColumnName()
	Case 'blno'
		If rb_new.Checked = True Then // 신규일 경우 
		  s_blno = Trim(GetText())
		  
	     SELECT Count("EXPBL"."BLNO"  )
          INTO :nCnt
          FROM "EXPBL"  
         WHERE "EXPBL"."BLNO" = :s_blno;
       
		  SetNull(s_blno)
        If nCnt > 0 Then 
			  SetItem(row,'blno',s_blno)
			  f_message_chk(37,'[B/L NO]')
			  Return 1
		  End If
	   Else
		  cb_inq.Post TriggerEvent(Clicked!)
	   End If
	Case 'blvnd'   // 거래처
   	select fun_get_cvnas(:data) into :cvnas from dual;
		If Trim(cvnas) = '' Or IsNull(cvnas) Then 
			SetNull(cvnas)
			This.SetItem(1,'blvnd',cvnas)
			This.SetItem(1,'blvndnm',cvnas)
			Return 2
		Else	
	      This.SetItem(1,'blvndnm',cvnas)
      End If			
		
	Case 'blacdt','shipdat'              // 일자
		sdate = Left(data,4) + String(Long(Mid(data,5,2)),'00') + String(Long(Right(data,2)),'00')
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
			SetItem(nRow,GetColumnName(),sNull)
	      Return 1
      END IF
		Post SetItem(nRow,GetColumnName(),sDate)
	Case 'explcno'  // LC접수번호
		gs_code = Trim(GetText())
   	If wf_select_lcno(row,gs_code) = 1 Then
			f_message_chk(33,'')
			return 1
		End If
End Choose
ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;string s_colnm
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

s_colnm = GetColumnName() 
Choose Case s_colnm
	Case "blno"                              // bl 접수번호 선택 popup 
		If rb_upd.Checked = False Then Return // 수정일 경우만...
   	Open(w_expbl_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		this.SetItem(1,"blno",gs_code)
		This.TriggerEvent(itemchanged!)
	Case "blvnd"     // 거래처 선택
   	Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		this.SetItem(1,s_colnm,gs_code)
		this.SetItem(1,s_colnm+'nm',gs_codename)
	Case "explcno"                              // lc 접수번호 선택 popup 
   	Open(w_explc_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		this.SetItem(1,"explcno",gs_code)
		Post wf_select_lcno(row,gs_code)
END Choose

end event

type cb_delrow from w_inherite`cb_delrow within w_sal_06080
boolean visible = false
integer x = 1915
integer y = 3348
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_06080
boolean visible = false
integer x = 1605
integer y = 3348
end type

type dw_insert from w_inherite`dw_insert within w_sal_06080
integer x = 37
integer y = 424
integer width = 4576
integer height = 1884
integer taborder = 20
string dataobject = "d_sal_06080_d"
end type

event dw_insert::rbuttondown;String sCists, sOutcfdt, SNull
Long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(SNull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'cino'
		gs_code  = 'N' 	// DIRECT 수출
		gs_gubun = 'A'    // 출고확정과 관계없이 처리
		Open(w_expci_popup)
		If IsNull(gs_code) Then Return 1
		
		If OutConfirm = 'Y' Then
			Select Cists, Outcfdt Into :sCists, :sOutcfdt
			  From Expcih
			 Where Cino = :gs_code;
			 
			 If (sOutcfdt = '' Or isnull(sOutcfdt)) Or sCists <> '2' Then
				 MessageBox('알림','출고등록이 되어있지 않습니다. ~n 출고둥록 후 작업하세요')
				 This.SetItem(nRow,'cino',SNull)
				 This.Setfocus()
				 Return 1
			 End If
		End IF
		
		Return wf_select_cino(nRow, gs_code)
End Choose

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sData, sCists, sOutcfdt, sNull
Long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return 

Choose Case GetColumnName()
	Case 'cino'
      gs_code = Trim(GetText())
		If IsNull(gs_code) Or gs_code = '' Then Return 1
      
		If OutConfirm = 'Y' Then
			Select Cists, Outcfdt Into :sCists, :sOutcfdt
			  From Expcih
			 Where Cino = :gs_code;
			 
			 If (sOutcfdt = '' Or isnull(sOutcfdt)) Or sCists <> '2' Then
				 MessageBox('알림','출고등록이 되어있지 않습니다. ~n 출고둥록 후 작업하세요')
				 This.SetItem(nRow,'cino',sNull)
				 This.Setfocus()
				 Return 1
			 End If
		End IF
		
		Return wf_select_cino(nRow,gs_code)
End Choose

end event

type cb_mod from w_inherite`cb_mod within w_sal_06080
boolean visible = false
integer x = 2226
integer y = 3348
end type

type cb_ins from w_inherite`cb_ins within w_sal_06080
boolean visible = false
integer x = 1294
integer y = 3348
end type

type cb_del from w_inherite`cb_del within w_sal_06080
boolean visible = false
integer x = 2537
integer y = 3348
end type

type cb_inq from w_inherite`cb_inq within w_sal_06080
boolean visible = false
integer x = 965
integer y = 3348
end type

event cb_inq::clicked;call super::clicked;string s_blno, sCino
Long   nRow, ix

If rb_new.Checked = True Then Return  //신규이면 조회불가

If dw_input.AcceptText() <> 1 Then Return

nRow  = dw_input.GetRow()
If nRow <=0 Then Return
	  
s_blno = Trim(dw_input.GetItemString(nRow,'blno'))
If IsNull(s_blno) Or s_blno = '' Then
   f_message_chk(1400,' B/L NO')
	Return 1
End If

If dw_input.Retrieve(s_blno) <= 0 Then
   sle_msg.Text = '조회한 자료가 없습니다.!!'
	rb_upd.TriggerEvent(Clicked!)
	return 
End If

dw_insert.Retrieve(s_blno)

wf_protect_key(true)

/* 회계전송된 자료가 있으면 저장,삭제 불가 */
For ix = 1 To dw_insert.RowCount()
	sCino = dw_insert.GetItemString(ix, 'kif05ot0_cino')
	If Not IsNull(sCino) Then
		cb_mod.Enabled = False
		cb_ins.Enabled = False
		cb_del.Enabled = False
		cb_search.Enabled = False
		
		sle_msg.Text = '회계전송처리된 자료입니다.!!'
		Exit
	End if
Next

dw_input.SetRedraw(True)

end event

type cb_print from w_inherite`cb_print within w_sal_06080
boolean visible = false
integer x = 608
integer y = 3336
end type

type cb_can from w_inherite`cb_can within w_sal_06080
boolean visible = false
integer x = 2848
integer y = 3348
end type

type cb_search from w_inherite`cb_search within w_sal_06080
boolean visible = false
integer x = 119
integer y = 3332
end type

type gb_10 from w_inherite`gb_10 within w_sal_06080
integer x = 5262
integer y = 3164
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_06080
integer x = 5262
integer y = 3164
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06080
integer x = 5262
integer y = 3164
end type

type r_head from w_inherite`r_head within w_sal_06080
integer y = 184
integer width = 4585
integer height = 200
end type

type r_detail from w_inherite`r_detail within w_sal_06080
integer y = 420
integer width = 4585
integer height = 1892
end type

type rb_new from radiobutton within w_sal_06080
integer x = 64
integer y = 60
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
long backcolor = 12639424
string text = "신규"
end type

event clicked;int row 

If This.Checked = True Then
	dw_input.SetRedraw(False)

   dw_insert.Reset()

   dw_input.Reset()
   row = dw_input.InsertRow(0)	
   wf_protect_key(false)
	
	dw_input.SetFocus()
	dw_input.SetRow(row)
	dw_input.SetColumn('blno')
	dw_input.SetRedraw(True)	
End If

end event

type rb_upd from radiobutton within w_sal_06080
integer x = 315
integer y = 60
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
long backcolor = 12639424
string text = "수정"
end type

event clicked;int row 

If This.Checked = True Then
	dw_input.SetRedraw(False)

   dw_insert.Reset()

   dw_input.Reset()
   row = dw_input.InsertRow(0)	
   wf_protect_key(false)
	
	dw_input.SetFocus()
	dw_input.SetRow(row)
	dw_input.SetColumn('blno')
//   dw_input.Modify("blno.background.color = '"+String(Rgb(255,255,0))+"'") // yellow
	dw_input.SetRedraw(True)	
End If

end event

type pb_1 from u_pic_cal within w_sal_06080
integer x = 1755
integer y = 208
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('shipdat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'shipdat', gs_code)

end event

type pb_2 from u_pic_cal within w_sal_06080
integer x = 1755
integer y = 292
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('blacdt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'blacdt', gs_code)

end event

type r_1 from rectangle within w_sal_06080
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 12639424
integer x = 32
integer y = 28
integer width = 553
integer height = 144
end type

