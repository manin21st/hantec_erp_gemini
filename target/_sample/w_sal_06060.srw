$PBExportHeader$w_sal_06060.srw
$PBExportComments$수출비용등록
forward
global type w_sal_06060 from w_inherite
end type
type dw_1 from datawindow within w_sal_06060
end type
type p_1 from uo_picture within w_sal_06060
end type
type p_2 from uo_picture within w_sal_06060
end type
type pb_1 from u_pic_cal within w_sal_06060
end type
type pb_2 from u_pic_cal within w_sal_06060
end type
type r_1 from rectangle within w_sal_06060
end type
end forward

global type w_sal_06060 from w_inherite
integer width = 4663
integer height = 2476
string title = "수출비용 등록"
dw_1 dw_1
p_1 p_1
p_2 p_2
pb_1 pb_1
pb_2 pb_2
r_1 r_1
end type
global w_sal_06060 w_sal_06060

type variables

end variables

forward prototypes
public function string wf_get_junpyo_no (string pidate)
public function integer wf_select_blno (integer row, string blno)
public function integer wf_select_ngno (integer row, string ngno)
public function string wf_select_pino (integer row, string arg_pino)
public function double wf_get_piamt (string arg_cino, string arg_pino)
public function integer wf_setting_cipi (integer nrow, string scino)
public function integer wf_select_explcno (integer row, string arg_explcno)
public function integer wf_set_default (string sSaupj)
public function integer wf_check_cvcod (string scvcod)
public subroutine wf_init ()
public subroutine wf_protect_key (integer gubun)
end prototypes

public function string wf_get_junpyo_no (string pidate);String  sOrderNo,sOrderGbn
string  sMaxOrderNo

sOrderGbn = 'X5'     // 채번 

sMaxOrderNo = String(sqlca.fun_junpyo(gs_sabu,pidate,sOrderGbn),'000')

IF double(sMaxOrderNo) <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	SetNull(sOrderNo)
	Return sOrderNo
END IF

sOrderNo = pidate + sMaxOrderNo

COMMIT;

Return sOrderNo
end function

public function integer wf_select_blno (integer row, string blno);string s_blno,s_blvndnm,s_blvssl
 
SELECT "EXPBL"."BLNO",   
       FUN_GET_CVNAS("EXPBL"."BLVND"),   
       "EXPBL"."BLVSSL"  
  INTO :s_blno,   
       :s_blvndnm,   
       :s_blvssl  
  FROM "EXPBL"  
 WHERE "EXPBL"."BLNO" = :blno   ;

If sqlca.sqlcode <> 0 Then Return 1
If Len(Trim(s_blno)) <= 0 Or IsNull(s_blno) Then    REturn 1

dw_insert.SetItem(row,'blno',s_blno)

Return 0

end function

public function integer wf_select_ngno (integer row, string ngno);string s_ngno,s_ngbanknm,s_refno
dec    d_ngamt
  
  SELECT "EXPNEGOH"."NGNO",   
         FUN_GET_CVNAS("EXPNEGOH"."NGBANK"),
         "EXPNEGOH"."REFNO",   
         "EXPNEGOH"."NGAMT"  
    INTO :s_ngno,   
         :s_ngbanknm,   
         :s_refno,   
         :d_ngamt  
    FROM "EXPNEGOH"  
   WHERE ( "EXPNEGOH"."SABU" = :gs_sabu ) AND  
         ( "EXPNEGOH"."NGNO" = :ngno )   ;

If sqlca.sqlcode <> 0 Then Return 1
If Len(Trim(s_ngno)) <= 0 Or IsNull(s_ngno) Then  REturn 1

If IsNull(s_ngno)    Then s_ngno = ''
If IsNull(s_ngbanknm) Then s_ngbanknm = ''
If IsNull(s_refno)  Then s_refno = ''
If IsNull(d_ngamt)  Then d_ngamt = 0.0

dw_insert.SetItem(row,'ngno',s_ngno)

Return 0
end function

public function string wf_select_pino (integer row, string arg_pino);//-----------------------------------------------------------//
// ci detail에 pino가 존재하는지 확인                        //
//-----------------------------------------------------------//
String sCino

SetNull(sCino)

SELECT CINO
  INTO :sCino
  FROM "EXPCID"  
 WHERE ( "EXPCID"."SABU" = :gs_sabu ) AND  
       ( "EXPCID"."PINO" = :arg_pino );

If IsNull(sCino) Or Trim(sCino) = '' then Return sCino

Return sCino

end function

public function double wf_get_piamt (string arg_cino, string arg_pino);/* ------------------------------------------------------- */
/* 수출금액을 가져온다.(CI 가 없을 경우 PI금액)을 가져온다 */
/* ------------------------------------------------------- */
Double dPiamt,dChargeAmt

/* Pi 금액만 가져올 경우 */
If IsNull(arg_cino) or Trim(arg_cino) = '' Then 
  SELECT NVL(SUM(NVL("EXPPID"."PIAMT",0)),0)
    INTO :dPiamt  
    FROM "EXPPID"  
   WHERE ( "EXPPID"."SABU" = :gs_sabu ) AND  
         ( "EXPPID"."PINO" = :arg_pino );
Else
	If IsNull(arg_pino) Then
		SELECT NVL(SUM(NVL(CIAMT,0)),0)
		  INTO :dPiamt
		  FROM EXPCID
		 WHERE SABU = :gs_sabu AND
				 CINO = :arg_cino ;
	Else
		SELECT NVL(SUM(NVL(CIAMT,0)),0)
		  INTO :dPiamt
		  FROM EXPCID
		 WHERE SABU = :gs_sabu AND
				 CINO = :arg_cino AND
				 PINO = :arg_pino ;
				 
		SELECT NVL(SUM(NVL(CHRAMT,0)),0)
		  INTO :dChargeAmt
		  FROM EXPCICH
		 WHERE SABU = :gs_sabu AND
				 CINO = :arg_cino AND
				 PINO = :arg_pino ;
	   dPiamt += dChargeAmt
	End If
End If
		
Return dPiamt

end function

public function integer wf_setting_cipi (integer nrow, string scino);/* ------------------------------------------------ */
/* ci,pi no를 setting                               */
/* ------------------------------------------------ */
Long   nMax,ix,itemp, Pos, nCnt, Lrow
string s_ngno,s_cino,s_pino

		
datastore ds
ds = create datastore
ds.dataobject = "d_sal_06060_ds"
ds.settransobject(sqlca)

// 최대 costseq 구함
nMax = 0
For ix = 1 To dw_insert.RowCount()
    itemp = dw_insert.GetItemNumber(ix,'costseq')
    nMax = Max(nMax,itemp)
Next

nCnt = 0
s_ngno = Trim(dw_input.GetItemString(dw_input.GetRow(),'costno'))

Do
	Pos = Pos(sCino,'#')
	If Pos > 0 Then
		s_cino = Left(sCino,pos - 1)
		sCino = Mid(sCino,pos + 1)
	Else
		s_cino = sCino
		sCino = ''
	End If

 	If IsNull(s_cino) or Trim(s_cino) = '' Then Exit

	ds.retrieve(gs_sabu, s_cino)
	For Lrow = 1 to ds.rowcount()
		 s_cino = ds.getitemstring(Lrow, "cino")
		 s_pino = ds.getitemstring(Lrow, "pino")

		If nCnt > 0 Then
			nRow = dw_insert.InsertRow(0)
			nMax = nMax + 1
			dw_insert.SetItem(nRow,'sabu',gs_sabu)
			dw_insert.SetItem(nRow,'costno',s_ngno)
			dw_insert.SetItem(nRow,'costseq',nMax)
		End If
		
		nCnt += 1
		dw_insert.SetItem(nRow,'cino',s_cino)
		dw_insert.SetItem(nRow,'pino',s_pino)
	  	dw_insert.SetItem(nRow,'piamt',wf_get_piamt(s_cino,s_pino))
		  
	Next

	
Loop While Len(sCino) > 1 and Trim(sCino) > ''

destroy ds

Return nCnt
end function

public function integer wf_select_explcno (integer row, string arg_explcno);String sExplcno

  SELECT "EXPLC"."EXPLCNO"  
    INTO :sExplcno  
    FROM "EXPLC"  
   WHERE ( "EXPLC"."SABU" = :gs_sabu ) AND  
         ( "EXPLC"."EXPLCNO" = :arg_explcno )   ;

If sqlca.sqlcode <> 0 Then Return 1
If Len(Trim(sExplcno)) <= 0 Or IsNull(sExplcno) Then    REturn 1

dw_insert.SetItem(row,'explcno',sExplcno)

Return 0

end function

public function integer wf_set_default (string sSaupj);String sDataName, sDeptName

If dw_input.RowCount() <= 0 Then Return 0

dw_input.SetFocus()

/* 자사코드 */
select rfna2 into :sDataName
  from reffpf
 where rfcod = '6B' and
       rfna4 = 1 and
		 rfna3 = :sSaupj;
		 
dw_input.SetItem(1,'jacod',sDataName)

/* 예산부서 */
select rfna2 into :sDataName
  from reffpf
 where rfcod = '6B' and
       rfna4 = 2 and
		 rfna3 = :sSaupj;

dw_input.SetColumn('cdept_cd')
dw_input.SetItem(1,'cdept_cd',sDataName)

SELECT "P0_DEPT"."DEPTNAME2"
  INTO :sDeptName
  FROM "P0_DEPT"  
WHERE "P0_DEPT"."DEPTCODE" = :sDataName AND "P0_DEPT"."USETAG" ='1';

dw_input.SetItem(1,"p0_dept_deptname2",sDeptName)


/* 원가부문 */
select rfna2 into :sDataName
  from reffpf
 where rfcod = '6B' and
       rfna4 = 3 and
		 rfna3 = :sSaupj;

dw_input.SetColumn('edept_cd')
dw_input.SetItem(1,'edept_cd',sDataName)

SELECT "CIA02M"."COST_NM"
  INTO :sDeptName
  FROM "CIA02M"  
WHERE "CIA02M"."COST_CD" = :sDataName AND "CIA02M"."USEGBN" ='1';

dw_input.SetItem(1,"cost_nm",sDeptName)

Return 0
end function

public function integer wf_check_cvcod (string scvcod);String sCustName, sCustSano, sCustUpTae, sCustUpjong, sCustOwner,	sCustResident
String sCustAddr,	sCustGbn,  sTaxGu
			 
	SELECT "VNDMST"."CVNAS",         "VNDMST"."SANO", 		 		"VNDMST"."UPTAE",   
			 "VNDMST"."JONGK",  		   "VNDMST"."OWNAM",				"VNDMST"."RESIDENT",   
			 NVL("VNDMST"."ADDR1",' ')||NVL("VNDMST"."ADDR2",' '),"VNDMST"."CVGU",
			 "VNDMST"."TAX_GU"
	  INTO :sCustName,   			  :sCustSano,   					:sCustUpTae,
		 	 :sCustUpjong,   			  :sCustOwner,   					:sCustResident,
			 :sCustAddr,   													:sCustGbn,
			 :sTaxGu
	  FROM "VNDMST"  
	 WHERE "VNDMST"."CVCOD" = :sCvcod;

							
/* 세금계산서의 거래처정보 미등록시 제외 */
If ( IsNull(sCustSano) or Trim(sCustSano) = '' ) and & 
	( IsNull(sCustResident) or Trim(sCustResident) = '' ) Then
	MessageBox('확인','거래처의 기본정보가 미비합니다~r~r' + &
							'[사업자등록번호,대표자명,업태,업종,주소등을 확인하십시요]')
	Return 2
End If
	
/* 거래처명,업태,업종,주소 */
If ( IsNull(sCustName)   or Trim(sCustName)   = '' )   Or &
	( IsNull(sCustUpTae)  or Trim(sCustUpTae)  = ''  )  Or &
	( IsNull(sCustUpjong) or Trim(sCustUpjong) = ''  )  Or &
	( IsNull(sCustAddr)   or Trim(sCustAddr)   = ''  )  Then 
	MessageBox('확인','거래처의 기본정보가 미비합니다~r~r' + &
							'[사업자등록번호,대표자명,업태,업종,주소등을 확인하십시요]')
	Return 2
End If

Return 0
end function

public subroutine wf_init ();String sDataName

p_inq.Enabled    = True
p_ins.Enabled    = True
p_mod.Enabled    = True
p_search.Enabled = True
p_del.Enabled    = True

p_inq.PictureName  	= "..\image\조회_up.gif"
p_ins.PictureName    = "..\image\추가_up.gif"
p_mod.PictureName    = "..\image\저장_up.gif"
p_search.PictureName = "..\image\삭제_up.gif"
p_del.PictureName    = "..\image\행삭제_up.gif"

dw_input.enabled	   = True
dw_insert.enabled = True

dw_1.reset()
dw_input.reset()
dw_insert.reset()
dw_input.insertrow(0)
dw_input.setitem(1, "sabu", gs_sabu)
dw_input.object.ab_dpno.visible = '0'
dw_input.object.ab_name.visible = '0'					
dw_input.object.t_13.visible = '0'	

wf_protect_key(0)
  
ib_any_typing = False

dw_input.setcolumn("costno")
dw_input.setfocus()


// 부가세 사업장 설정
f_mod_saupj(dw_input, 'saupj')

end subroutine

public subroutine wf_protect_key (integer gubun);if gubun = 1 then  /* 공통항목에 대한 입력제한 */
	dw_input.object.costno.protect 		= 1
	dw_input.object.iseq.protect   		= 1	
	dw_input.object.costdt.protect   	= 1	
	dw_input.object.saupj.protect   	= 1	
	dw_input.object.cdept_cd.protect   = 1	
	dw_input.object.edept_cd.protect    = 1	
	dw_input.object.costvnd.protect   	= 1		
	dw_input.object.jacod.protect   	= 1		
Else
	dw_input.object.costno.protect 		= 0
	dw_input.object.iseq.protect   		= 0	
	dw_input.object.costdt.protect   	= 0	
	dw_input.object.saupj.protect   	= 0	
	dw_input.object.cdept_cd.protect   = 0	
	dw_input.object.edept_cd.protect   	= 0	
	dw_input.object.costvnd.protect   	= 0		
	dw_input.object.jacod.protect   	= 0		
End if
end subroutine

on w_sal_06060.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.r_1
end on

on w_sal_06060.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.r_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_input.SetTransObject(sqlca)
dw_input.InsertRow(0)

dw_insert.SetTransObject(sqlca)
dw_1.settransobject(sqlca)

wf_init()
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", false) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", false) //// 삭제
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", false) //// 저장
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", false) //// 취소
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
m_main2.m_window.m_inq.enabled = false //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = false  //// 삭제
m_main2.m_window.m_save.enabled = false //// 저장
m_main2.m_window.m_cancel.enabled = false //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = true  //// 찾기
m_main2.m_window.m_filter.enabled = true //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event resize;r_head.width = this.width - 60
dw_input.width = this.width - 70

r_1.width = this.width - 60
dw_1.width = this.width - 70

r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70

p_inq.x = r_head.width - 1509
p_ins.x = r_head.width - 1335
p_1.x = r_head.width - 1161
p_2.x = r_head.width - 987
p_mod.x = r_head.width - 813
p_search.x = r_head.width - 639
p_del.x = r_head.width - 465
p_can.x = r_head.width - 291
p_exit.x = r_head.width - 117
end event

type cb_exit from w_inherite`cb_exit within w_sal_06060
integer y = 3200
end type

type sle_msg from w_inherite`sle_msg within w_sal_06060
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_06060
end type

type st_1 from w_inherite`st_1 within w_sal_06060
end type

type p_search from w_inherite`p_search within w_sal_06060
boolean visible = true
integer x = 3899
integer y = 28
string pointer = "C:\erpman\cur\delete.cur"
boolean enabled = true
string picturename = "..\image\삭제_up.gif"
end type

event p_search::clicked;call super::clicked;string s_costno,pi_seq
Long   nRow

nRow  = dw_input.GetRow()
If nRow <=0 Then Return
	  
s_costno = Trim(dw_input.GetItemString(nRow,'costno'))
If IsNull(s_costno) Or s_costno = '' Then Return

IF MessageBox("삭 제",s_costno + "의 모든 자료가 삭제됩니다." +"~n~n" +&
  	        	  "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

If dw_input.DeleteRow(0) = 1 Then
	nRow = dw_insert.RowCount()
	dw_insert.RowsMove(1, nRow,  Primary!,dw_insert,1,Delete!)
	IF dw_input.Update() <> 1 THEN
		ROLLBACK;
		Return
	End If
	IF dw_insert.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF		  
END IF
	 
COMMIT;

sle_msg.text ='자료를 삭제하였습니다!!'

wf_init()
end event

event p_search::ue_lbuttondown;PictureName = "..\image\삭제_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "..\image\삭제_up.gif"
end event

type p_addrow from w_inherite`p_addrow within w_sal_06060
integer x = 1993
integer y = 20
end type

type p_delrow from w_inherite`p_delrow within w_sal_06060
integer x = 2167
integer y = 20
end type

type p_mod from w_inherite`p_mod within w_sal_06060
boolean visible = true
integer x = 3726
integer y = 28
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "..\image\저장_up.gif"
end type

event p_mod::clicked;call super::clicked;String sCostNo,sCostDt,sCurr, sCostGu, sNull, sCdeptCd, sEdeptCd, sSaupj, sCostCd, sGbn1, staxgu, scostjgu 
string svisible
Long   nRow,ix, ncnt
Double dCostAmt,dPiamt

If dw_input.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

/* 수출비용 헤더 저장 */
nRow  = dw_input.GetRow()
If nRow <=0 Then Return

SetNull(sNull)

dw_input.Setfocus()

/* 예적금코드 */
svisible = dw_input.object.ab_dpno.visible
if svisible = '1' then
	sgbn1 = Trim(dw_input.GetItemString(nRow,'ab_dpno'))
	If IsNull(sgbn1) Or sgbn1 = '' Then
		f_message_chk(1400,'[예적금코드]')
		dw_input.Setcolumn('ab_dpno')
		Return
	End If
end if

/* 일자 */
sCostDt = Trim(dw_input.GetItemString(nRow,'costdt'))
If f_datechk(sCostDt) <> 1 Then
	f_message_chk(40,'[발생일자]')
	dw_input.Setcolumn('costdt')
	Return
End If

/* 부가사업장 */
sSaupj = Trim(dw_input.GetItemString(nRow,'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_input.Setcolumn('saupj')
	Return
End If

/* 통화단위 */
sCurr = Trim(dw_input.GetItemstring(1,'curr'))
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(40,'[통화단위]')
	dw_input.Setcolumn('curr')
	Return
End If

/* 예산부서 */
sCdeptCd = Trim(dw_input.GetItemstring(1,'cdept_cd'))
If IsNull(sCdeptCd) Or sCdeptCd = '' Then
	f_message_chk(40,'[예산부서]')
	dw_input.Setcolumn('cdept_cd')
	Return
End If

/* 원가부서 */
sEdeptCd = Trim(dw_input.GetItemstring(1,'edept_cd'))
If IsNull(sEdeptCd) Or sEdeptCd = '' Then
	f_message_chk(40,'[원가부문]')
	dw_input.Setcolumn('edept_cd')
	Return
End If

/* 비용금액 */
If sCurr = 'WON' Then
	dCostAmt = dw_input.GetItemNumber(1,'costamt')
	If IsNull(dCostAmt) or dCostAmt = 0 Then
		f_message_chk(40,'[비용금액]')
		dw_input.Setcolumn('costamt')
		Return
   End If
Else
	dCostAmt = dw_input.GetItemNumber(1,'costforamt')
	If IsNull(dCostAmt) or dCostAmt = 0 Then
		f_message_chk(40,'[비용외화금액]')
		dw_input.Setcolumn('costforamt')
		Return
   End If
End If

/* 비용구분 */
sCostGu = Trim(dw_input.GetItemString(1,'costgu'))
If IsNull(sCostGu) Or sCostGu = '' Then
	f_message_chk(40,'[비용구분]')
	dw_input.Setcolumn('costgu')
	Return
End If

/* 비용코드 */
sCostcd = Trim(dw_input.GetItemString(1,'costcd'))
If IsNull(sCostCd) Or sCostcd = '' Then
	f_message_chk(40,'[비용코드]')
	dw_input.Setcolumn('costcd')
	Return
End If

/* 계산서구분 */
staxgu = Trim(dw_input.GetItemString(1,'taxgu'))
If IsNull(staxGu) Or staxGu = '' Then
	f_message_chk(40,'[계산서구분]')
	dw_input.Setcolumn('taxgu')
	Return
End If

/* 증빙구분 */
scostjgu = Trim(dw_input.GetItemString(1,'costjgu'))
If IsNull(scostjGu) Or scostjGu = '' Then
	f_message_chk(40,'[증빙구분]')
	dw_input.Setcolumn('costjgu')
	Return
End If

/* 상대계정코드 */
sCostcd = Trim(dw_input.GetItemString(1,'scodgu'))
If IsNull(sCostCd) Or sCostcd = '' Then
	f_message_chk(40,'[상대계정코드]')
	dw_input.Setcolumn('scodgu')
	Return
End If


/* 전표번호 채번 */
sCostNo = Trim(dw_input.GetItemString(nrow,'costno'))
if IsNull(sCostNo) or trim(sCostNo) = '' then
   sCostNo = wf_get_junpyo_no(sCostDt)
   dw_input.SetItem(nRow,'sabu',gs_sabu)
   dw_input.SetItem(nRow,'costno',sCostNo)
	dw_input.SetItem(nRow,'iseq',1)
	dw_input.SetItem(nRow,'crtgu','1')
	ncnt = 1
Else
	Select Max(iseq) into :nCnt
	  From expcosth  
	 Where sabu = :gs_sabu and costno = :sCostNo;
	If isnull(ncnt) then ncnt = 0
	
	If ncnt = 0 then
		MessageBox("수출비용 전표번호", "수출비용 전표번호가 없읍니다" + '~n' + &
												  "신규로 등록할 경우에는 전표번호를 Clear하십시요", information!)
		Return
	End if
	
	ncnt++
	
	dw_input.setitem(nrow, 'iseq', ncnt)
End If

IF dw_input.Update() <> 1 THEN
	f_message_chk(32,'')
   ROLLBACK;
   Return
END IF

/* ------------------------------------------------ */
/* 수출비용 Detail 저장                             */
/* ------------------------------------------------ */
dw_insert.SetFocus()
nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1
	/* 수출금액이 없으면 삭제 */
	dPiamt = dw_insert.GetItemNumber(ix,'piamt')
	If dPiamt = 0 Or IsNull(dPiamt) Then
      dw_insert.DeleteRow(ix)
		Continue
	End If

   /* 비용금액 */
   If sCurr = 'WON' Then
	   dCostAmt = dw_insert.GetItemNumber(ix,'costamt')
	   If IsNull(dCostAmt) or dCostAmt = 0 Then
			f_message_chk(40,'[비용금액]')
			dw_insert.ScrollToRow(ix)
			dw_insert.Setcolumn('costamt')
			Return
      End If
   Else
	   dCostAmt = dw_insert.GetItemNumber(ix,'costforamt')
	   If IsNull(dCostAmt) or dCostAmt = 0 Then
			f_message_chk(40,'[비용금액]')
			dw_insert.ScrollToRow(ix)
			dw_insert.Setcolumn('costforamt')
			Return
      End If
   End If

	dw_insert.SetItem(ix,'costno',sCostNo)
	dw_insert.Setitem(ix,'iseq',ncnt)
Next

IF dw_insert.Update() <> 1 THEN
	f_message_chk(32,'')	
   ROLLBACK;
   Return
END IF

COMMIT;

/* 저장후 신규입력상태로 변경 */
dw_input.SetItemStatus(1, 0, Primary!, New!)
dw_input.SetItem(1, 'costno', sCostNo)
dw_input.setitem(1, 'iseq',   0)
dw_input.SetItem(1, 'costcd', snull)
dw_input.SetItem(1, 'costamt', 0)
dw_input.SetItem(1, 'costvat', 0)
dw_input.SetItem(1, 'costforamt', 0)

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItemStatus(ix, 0, Primary!, New!)
	dw_insert.SetItem(ix, 'costamt', 0)
	dw_insert.SetItem(ix, 'costforamt', 0)
Next

f_message_chk(202,'')
sle_msg.text ='자료를 저장하였습니다!!'

dw_1.retrieve(gs_sabu, scostno)

wf_protect_key(1)
ib_any_typing = False

dw_input.setfocus()
end event

event p_mod::ue_lbuttondown;PictureName = "..\image\저장_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "..\image\저장_up.gif"
end event

type p_del from w_inherite`p_del within w_sal_06060
boolean visible = true
integer x = 4073
integer y = 28
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\delrow.cur"
boolean originalsize = true
string picturename = "..\image\행삭제_up.gif"
boolean focusrectangle = true
end type

event p_del::clicked;call super::clicked;String sCostNo
Long   nRow,nCostSeq

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return

nCostSeq = dw_insert.GetItemNumber(nRow,'costseq')
sCostNo = Trim(dw_insert.GetItemString(nRow,'costno'))
Choose Case dw_insert.GetItemStatus(nRow,0,Primary!)
	Case New!,NewModified!
		dw_insert.DeleteRow(nRow)
	Case Else
		IF MessageBox("삭 제","SEQ : " + String(nRow) + "번째  자료가 삭제됩니다." +"~n~n" +&
							"삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
		
		If dw_insert.DeleteRow(nRow) = 1 Then
			IF dw_insert.Update() <> 1 THEN
				ROLLBACK;
				Return
			END IF
			COMMIT;
		End If	  
End Choose

sle_msg.text ='자료를 삭제하였습니다!!'

end event

event p_del::ue_lbuttondown;PictureName = "..\image\행삭제_dn.gif"
end event

event p_del::ue_lbuttonup;PictureName = "..\image\행삭제_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sal_06060
boolean visible = true
integer x = 3031
integer y = 28
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "..\image\조회_up.gif"
end type

event p_inq::clicked;call super::clicked;string sCostNo,sCino,sPino
Long   nRow,ix,nCnt, liseq

If dw_input.AcceptText() <> 1 Then return 

nRow  = dw_input.GetRow()
If nRow <=0 Then Return
	  
sCostNo = Trim(dw_input.GetItemString(nRow,'costno'))
If IsNull(sCostNo) Or sCostNo = '' Then
   f_message_chk(1400,'[수출비용전표]')
	Return 1
End If

liseq   = dw_input.GetItemDecimal(nRow,'iseq')
If IsNull(liseq) Or liseq = 0 Then
   f_message_chk(1400,'[수출비용전표]')
	Return 1
End If

If dw_input.Retrieve(gs_sabu,sCostNo,liseq) <= 0 Then
   sle_msg.Text = '조회한 자료가 없습니다.!!'
	return 
End If

/* 수출비용 상세내역 조회 */
ncnt = 0
nCnt = dw_insert.Retrieve(gs_sabu,sCostNo,liseq)
For ix = 1 To nCnt
	sCino = dw_insert.GetItemString(ix,'cino')
	sPino = dw_insert.GetItemString(ix,'pino')
   dw_insert.SetItem(ix,'piamt',wf_get_piamt(sCino,sPino))

Next

/* 회계시스템 이월 확인 */
ncnt = 0
SELECT COUNT(*)
  INTO :nCnt
  FROM EXPCOSTH 
 WHERE SABU   		= :gs_sabu And
 		 COSTNO	 	= :sCostNo  and
       AC_MOVE		= 'Y';

If nCnt > 0 Then
  sle_msg.Text = '전송 처리된 자료입니다.!!'
//  p_transfer.text  = '회계삭제'
  p_inq.Enabled    = False
  p_ins.Enabled    = False
  p_mod.Enabled    = False
  p_search.Enabled = False
  p_del.Enabled    = False
  
  p_inq.PictureName    = "..\image\조회_d.gif"
  p_ins.PictureName    = "..\image\추가_d.gif"
  p_mod.PictureName    = "..\image\저장_d.gif"
  p_search.PictureName = "..\image\삭제_d.gif"
  p_del.PictureName    = "..\image\행삭제_d.gif"

  dw_input.enabled	  = False
  dw_insert.enabled = False
  return
End If

//p_transfer.text  = '회계전송'

dw_1.retrieve(gs_sabu, scostno)

wf_protect_key(1)
dw_input.setfocus()
end event

event p_inq::ue_lbuttondown;PictureName = "..\image\조회_dn.gif"
end event

event p_inq::ue_lbuttonup;PictureName = "..\image\조회_up.gif"
end event

type p_print from w_inherite`p_print within w_sal_06060
integer x = 1755
integer y = 20
integer width = 178
integer height = 144
boolean enabled = false
boolean originalsize = true
string picturename = "..\image\인쇄_up.gif"
end type

type p_can from w_inherite`p_can within w_sal_06060
boolean visible = true
integer x = 4247
integer y = 28
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "..\image\취소_up.gif"
end type

event p_can::clicked;call super::clicked;wf_init()
end event

event p_can::ue_lbuttondown;PictureName = "..\image\취소_dn.gif"
end event

event p_can::ue_lbuttonup;PictureName = "..\image\취소_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sal_06060
boolean visible = true
integer x = 4421
integer y = 28
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "..\image\닫기_up.gif"
end type

event p_exit::ue_lbuttonup;PictureName = "..\image\닫기_up.gif"
end event

event p_exit::ue_lbuttondown;PictureName = "..\image\닫기_dn.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_06060
boolean visible = true
integer x = 3205
integer y = 28
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "..\image\추가_up.gif"
end type

event p_ins::clicked;call super::clicked;string s_cino,s_costno,s_costdt,s_pino
int    nRow,nMax,ix,itemp

If dw_input.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 then Return
If  dw_input.GetRow() <= 0 Then Return

/* 일자 */
s_costdt = Trim(dw_input.GetItemString(1,'costdt'))
If f_datechk(s_costdt) <> 1 Then
  f_message_chk(40,'[발생일자]')
  dw_input.Setfocus()
  dw_input.Setcolumn('costdt')
  Return
End If

nRow = dw_insert.RowCount()
If nRow > 0 Then
  s_cino = Trim(dw_insert.GetItemString(1,'cino'))
  s_pino = Trim(dw_insert.GetItemString(1,'pino'))
  If ( IsNull(s_cino) Or s_cino = '' ) and (  IsNull(s_pino) Or s_pino = '' ) Then
   f_message_chk(1400,'[C/I No.]')
	dw_insert.SetFocus()
	dw_insert.SetRow(nRow)
	dw_insert.SetColumn('cino')
	Return 1
  End If
End If

// 최대 costseq 구함
nMax = 0
For ix = 1 To nRow
    itemp = dw_insert.GetItemNumber(ix,'costseq')
    nMax = Max(nMax,itemp)
Next
nMax += 1

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow,'sabu',gs_sabu) 
dw_insert.SetItem(nRow,'costseq',nMax)
dw_insert.SetItemStatus(nRow, 0, Primary!, NotModified!)
dw_insert.SetItemStatus(nRow, 0, Primary!, New!)
dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetRow(nRow)
dw_insert.SetColumn('cino')

end event

event p_ins::ue_lbuttondown;PictureName = "..\image\추가_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "..\image\추가_up.gif"
end event

type p_new from w_inherite`p_new within w_sal_06060
integer x = 955
integer y = 3076
end type

type dw_input from w_inherite`dw_input within w_sal_06060
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 204
integer width = 4530
integer height = 784
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06060_h"
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string sdate, sdata, sNull, sCostNo, sCostGu, sScodgu, sAcc, sac_move, sgbn1, SACC1, SACC2 
Long   nRow,nCnt, ix, liseq
dec    wrate,urate,weigh, dCostAmt, diseq 
String sIoCust, sIoCustName, sCvBank, sCvdpNo, sDpName
String sDept, sDeptName, scostdt, ssaupj, scdept_cd, sedept_cd, scostvnd, sjacod, staxgu

SetNull(sNull)
sData = Trim(GetText())
nRow = GetRow()
Choose Case GetColumnName()
	/* 부가사업장 */
	Case 'saupj'
		wf_set_default(GetText())
	/* 수입비용전표번호 */
	Case 'costno'
	  sCostNo = Trim(GetText())
	  IF sCostNo = "" OR IsNull(sCostNo) THEN RETURN
		
     SELECT a.costno, a.costdt, a.saupj, a.cdept_cd, a.edept_cd, a.costvnd,
	  			a.jacod, a.taxgu,  count(*) 
		 into :scostno, :scostdt, :ssaupj, :scdept_cd, :sedept_cd, :scostvnd,
		 		:sjacod, :staxgu, :ncnt 
       FROM expcosth a
      WHERE ( a.sabu  	= :gs_sabu ) AND  
            ( a.costno 	= :sCostNo )
      group by a.costno, a.costdt, a.saupj, a.cdept_cd, a.edept_cd, a.costvnd,
	  			a.jacod, a.taxgu;	

	  IF isnull(ncnt) or ncnt = 0 THEN
		  f_message_chk(33,'[비용전표번호]')
        SetItem(nRow,'costno',sNull)
		  setitem(1,"costno",	sNull)
		  setitem(1,"iseq",		sNull)
		  setitem(1,"costdt",	sNull)
		  setitem(1,"saupj",		sNull)
		  setitem(1,"cdept_cd",	sNull)
		  setitem(1,"edept_cd",	sNull)
		  setitem(1,"costvnd",	sNull)
		  setitem(1,"jacod",		sNull)
		  setitem(1,"taxgu",	sNull)
		  SetItem(1,"costvndnm",  sNull)
		  SetItem(1,"send_bank",  sNull)
		  SetItem(1,"send_dep",   sNull)
		  SetItem(1,"send_nm",    sNull)
		  SetItem(1,"p0_dept_deptname2",sNull)
		  SetItem(1,"cost_nm",	  sNull)
		  dw_1.reset()
		  wf_protect_key(0)
		  Return 1
	  End If
	  
	  setitem(1,"costno",	scostno)
	  setitem(1,"iseq",		0)
	  setitem(1,"costdt",	scostdt)
	  setitem(1,"saupj",		ssaupj)
	  setitem(1,"cdept_cd",	scdept_cd)
	  setitem(1,"edept_cd",	sedept_cd)	  
	  setitem(1,"costvnd",	scostvnd)
	  setitem(1,"jacod",		sjacod)
	  setitem(1,"taxgu",	staxgu)
	  
		SELECT "VNDMST"."CVNAS2", "VNDMST"."CVBANK", "VNDMST"."CVDPNO", "VNDMST"."DPNAME"
		  INTO :sIoCustName, :sCvBank, :sCvdpNo, :sDpName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :scostvnd;
		 	
		SetItem(1,"costvndnm",  sIoCustName)
		SetItem(1,"send_bank",  sCvBank)
		SetItem(1,"send_dep",   sCvdpno)
		SetItem(1,"send_nm",    sDpName)
		
		SetNull(sdeptname)		
		SELECT "P0_DEPT"."DEPTNAME2"
		  INTO :sDeptName
		  FROM "P0_DEPT"  
		WHERE "P0_DEPT"."DEPTCODE" = :scdept_cd AND "P0_DEPT"."USETAG" ='1';
		SetItem(1,"p0_dept_deptname2",sDeptName)

		SetNull(sdeptname)
		SELECT "CIA02M"."COST_NM"
		  INTO :sDeptName
		  FROM "CIA02M"  
		WHERE "CIA02M"."COST_CD" = :seDept_cd AND "CIA02M"."USEGBN" ='1';
		SetItem(1,"cost_nm",sDeptName)
		
	   dw_1.retrieve(gs_sabu, scostno)
		
	   wf_protect_key(1)		
	  
	/* 수입비용전표순번 */
	Case 'iseq'
	  liseq = Dec(GetText())
	  IF liseq = 0 THEN RETURN

     SELECT ac_move into :sac_move
       FROM "EXPCOSTH"  
      WHERE ( "EXPCOSTH"."SABU"   = :gs_sabu ) AND  
            ( "EXPCOSTH"."COSTNO" = :sCostNo  ) AND
				( "EXPCOSTH"."ISEQ"   = :liseq    ) ;

	  IF sqlca.sqlcode  <> 0 THEN
		 f_message_chk(33,'[비용전표번호]')
       SetItem(nRow,'iseq', 0)
		 Return 1
	  End If
	  
	  IF sac_move = 'Y' THEN
		 messagebox("회계전송", "이미 회계전송된 전표입니다", stopsign!)
       SetItem(nRow,'iseq', 0)
		 Return 1
	  End If	  	  

 	  p_inq.PostEvent(Clicked!)		
	/* 접수일자 */
	Case 'costdt'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,'costdt',sNull)
	      Return 1
      END IF

      sdata = GetItemString(row,'curr')
		select rstan,usdrat
		  into :wrate,:urate
		  from ratemt
		 where rdate = :sdate and
		       rcurr = :sdata;

      If IsNull(wrate) Or wrate = 0 Then wrate = 0.0
      If IsNull(urate) Or urate = 0 Then urate = 0.0
		 
		If sqlca.sqlcode = 0 Then
			SetItem(row,'exchrate',wrate)
		Else
			SetItem(row,'exchrate',0)
		End If
		
		Post SetItem(nRow,'costdt',sDate)
	/* 비용구분 : 비용구분에 따라 bl,nego,lc number를 입력받는다 */
	Case 'costgu'
		dw_insert.Object.blno.visible = 0
		dw_insert.Object.ngno.visible = 0
		dw_insert.Object.explcno.visible = 0
		dw_insert.Object.stext.text = ''
		Choose Case Trim(GetText())
			Case '2'
				dw_insert.Object.blno.visible = 1
				dw_insert.Object.stext.text = 'B/L No.'
			Case '3'
				dw_insert.Object.ngno.visible = 1
				dw_insert.Object.stext.text = 'Nego No.'
			Case '4'
				dw_insert.Object.explcno.visible = 1
				dw_insert.Object.stext.text = 'L/C No.'
		End Choose
		
		For ix = 1 To dw_insert.RowCount()
			dw_insert.SetItem(ix,'blno',sNull)
			dw_insert.SetItem(ix,'ngno',sNull)
			dw_insert.SetItem(ix,'explcno',sNull)
		Next
		Return 0 
		
	/* 비용지출처 */
	Case 'costvnd'
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"costvndnm",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2", "VNDMST"."CVBANK", "VNDMST"."CVDPNO", "VNDMST"."DPNAME"
		  INTO :sIoCustName, :sCvBank, :sCvdpNo, :sDpName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sIoCust;
		 
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			If wf_check_cvcod(sIoCust) <> 0 Then Return 2
			
			SetItem(1,"costvndnm",  sIoCustName)
			SetItem(1,"send_bank",  sCvBank)
			SetItem(1,"send_dep",   sCvdpno)
			SetItem(1,"send_nm",    sDpName)
		END IF
	Case 'curr'
		sDate = dw_input.GetItemString(dw_input.GetRow(),'costdt')

      select x.rstan,x.usdrat, y.rfna2
        into :wrate,:urate, :weigh
        from ratemt x, reffpf y
       where x.rcurr = y.rfgub(+) and
             y.rfcod = '10' and
             x.rdate = :sdate and
             x.rcurr = :sdata;

		If IsNull(wrate) Then wrate = 0.0
		If IsNull(urate) Then urate = 0.0
		If IsNull(weigh) Then weigh = 0.0
		 
		If sqlca.sqlcode = 0 Then
			SetItem(row,'exchrate',wrate)
		Else
			SetItem(row,'exchrate',0)
		End If
	/* 결제예정일 */
	Case 'gyul_date'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'[결제예정일]')
      	SetItem(nRow,'gyul_date',sNull)
	      Return 1
      END IF
	/* 예산부서 */
	Case 'cdept_cd'
		sDept = Trim(GetText())
		IF sDept ="" OR IsNull(sDept) THEN
			SetItem(1,"p0_dept_deptname2",sNull)
			Return
		END IF
		
		SELECT "P0_DEPT"."DEPTNAME2"
		  INTO :sDeptName
		  FROM "P0_DEPT"  
		WHERE "P0_DEPT"."DEPTCODE" = :sDept AND "P0_DEPT"."USETAG" ='1';
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"p0_dept_deptname2",sDeptName)
		END IF
	/* 원가부서 */
	Case 'edept_cd'
		sDept = Trim(GetText())
		IF sDept ="" OR IsNull(sDept) THEN
			SetItem(1,"cost_nm",sNull)
			Return
		END IF
		
		SELECT "CIA02M"."COST_NM"
		  INTO :sDeptName
		  FROM "CIA02M"  
		WHERE "CIA02M"."COST_CD" = :sDept AND "CIA02M"."USEGBN" ='1';
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"cost_nm",sDeptName)
		END IF
	/* 상대계정 */
	Case 'scodgu'
		sScodgu = Trim(GetText())
		
		SELECT RFNA2 INTO :sAcc
		  FROM REFFPF 
		 WHERE RFCOD = 'EA' AND 
		       RFGUB = :sScodgu;

		If Len(sAcc) > 0 Then
			SetItem(1,'sacc1_cd',Left(sAcc,5))
			SetItem(1,'sacc2_cd',Mid(sAcc,6,2))
			SACC1 = Left(sAcc,5)
			SACC2 = Mid(sAcc,6,2)
		Else
			SetItem(1,'sacc1_cd', sNull )
			SetItem(1,'sacc2_cd', sNull )
			SACC1 = sNull
			SACC2 = sNull
		End If
		
		setitem(1, "ab_dpno", sNull)
		setitem(1, "ab_name", sNull)
		
		SetNull( sGbn1)
		SELECT GBN1 INTO :SGBN1 FROM KFZ01OM0
		 WHERE ACC1_CD = :sacc1 AND ACC2_CD = :sacc2;
		if sgbn1 = '5' then
			object.ab_dpno.visible = '1'		
			object.ab_name.visible = '1'					
			object.t_13.visible = '1'					
		Else
			object.ab_dpno.visible = '0'
			object.ab_name.visible = '0'					
			object.t_13.visible = '0'					
		End if
	/* 예적금코드 */
	Case 'ab_dpno'
		sScodgu = Trim(GetText())
		
		SELECT ab_name INTO :sAcc
		  FROM kfm04ot0
		 WHERE ab_dpno = :sscodgu;

		if sqlca.sqlcode = 0 then
			SetItem(1,'ab_name',sAcc)
		Else
			SetItem(1,'ab_dpno', sNull )
			SetItem(1,'ab_name', sNull )
			MessageBox("예적금코드", "예적금코드가 부정확합니다", stopsign!)
			return 1
		End If
		
	/* 비용원화금액 */
	Case 'costamt'
		dCostAmt = Dec(GetText())
		
		SetItem(1, 'costvat', TrunCate(dcostAmt * 0.1,0))
End Choose

ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;string s_colnm,sIoCustName, sCvBank, sCvdpNo, sDpName
Double dCostAmt, dCostVat

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

s_colnm = GetColumnName() 
Choose Case s_colnm
	Case "costno"                            // cost 접수번호 선택 popup 
   	Open(w_expcost_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"costno",gs_code)
		SetItem(1,"iseq",  Dec(gs_codename))
	   dw_1.retrieve(gs_sabu, gs_code)		
      p_inq.triggerevent(clicked!)
	/* 비용지출처 */
	Case "costvnd"
		gs_gubun = '2'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		If wf_check_cvcod(gs_code) <> 0 Then Return 2
		
		SetItem(1,"costvnd",gs_code)
		
		SELECT "VNDMST"."CVNAS2", "VNDMST"."CVBANK", "VNDMST"."CVDPNO", "VNDMST"."DPNAME"
		  INTO :sIoCustName, :sCvBank, :sCvdpNo, :sDpName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :gs_code;
		 
		IF SQLCA.SQLCODE <> 0 THEN
			Return 2
		ELSE
			SetItem(1,"costvndnm",  sIoCustName)
			SetItem(1,"send_bank",  sCvBank)
			SetItem(1,"send_dep",   sCvdpno)
			SetItem(1,"send_nm",    sDpName)
		END IF
	/* 예산부서 */
	Case 'cdept_cd'
		Open(w_dept_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"cdept_cd",gs_code)
		SetItem(1,"p0_dept_deptname2",gs_codename)
	/* 원가부문 */
	Case 'edept_cd'
		Open(w_cia02m_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"edept_cd",gs_code)
		SetItem(1,"cost_nm",gs_codename)
	/* 비용반제 전표*/
	Case 'crossno'
		//조회조건 - 지출일자, 계정과목, 매입부서
		//           (gs_gubun, gs_codename, gs_code)
		gs_code     = this.getitemstring(1, 'costvnd')
		gs_codename = this.getitemstring(1, 'scodgu')
		gs_gubun    = this.getitemstring(1, 'costdt')
		
		//총금액(부가세 + 공급가액) <= 미반제금액 인 자료만 선택
		dCostAmt = GetItemNumber(1,'costamt')
		dCostVat = GetItemNumber(1,'costvat')
		If IsNull(dCostAmt) Then dCostAmt = 0
		If IsNull(dCostVat) Then dCostVat = 0
		
		dCostAmt += dCostVat
		
		if gs_code = '' or isnull(gs_code) then 
			messagebox("확 인", "비용지출처를 먼저 선택하세요!")
			return 
		end if	
		if gs_codename = '' or isnull(gs_codename) then 
			messagebox("확 인", "상대계정을 먼저 선택하세요!")
			return 
		end if	
		
		openwithparm(w_kfz19ot0_popup, dCostAmt)
		
		if gs_code = '' or isnull(gs_code) then return 
		
		setitem(1, 'crossno', gs_code)
	/* 예적금코드 */
	Case 'ab_dpno'
		Open(w_kfm04ot0_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"ab_dpno",gs_code)
		SetItem(1,"ab_name",gs_codename)		
END Choose

end event

event dw_input::buttonclicked;call super::buttonclicked;String sCostNo,sCostDt,sCurr, sCostGu, sNull, sCdeptCd, sEdeptCd, sSaupj, sCostCd, sGbn1
string svisible
Long   nRow,ix, ncnt
Double dCostAmt,dPiamt

If dw_input.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

/* 수출비용 헤더 저장 */
nRow  = dw_input.GetRow()
If nRow <=0 Then Return

SetNull(sNull)

dw_input.Setfocus()

/* 예적금코드 */
svisible = dw_input.object.ab_dpno.visible
if svisible = '1' then
	sgbn1 = Trim(dw_input.GetItemString(nRow,'ab_dpno'))
	If IsNull(sgbn1) Or sgbn1 = '' Then
		f_message_chk(1400,'[예적금코드]')
		dw_input.Setcolumn('ab_dpno')
		Return
	End If
end if

/* 일자 */
sCostDt = Trim(dw_input.GetItemString(nRow,'costdt'))
If f_datechk(sCostDt) <> 1 Then
	f_message_chk(40,'[발생일자]')
	dw_input.Setcolumn('costdt')
	Return
End If

/* 부가사업장 */
sSaupj = Trim(dw_input.GetItemString(nRow,'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_input.Setcolumn('saupj')
	Return
End If

/* 통화단위 */
sCurr = Trim(dw_input.GetItemstring(1,'curr'))
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(40,'[통화단위]')
	dw_input.Setcolumn('curr')
	Return
End If

/* 예산부서 */
sCdeptCd = Trim(dw_input.GetItemstring(1,'cdept_cd'))
If IsNull(sCdeptCd) Or sCdeptCd = '' Then
	f_message_chk(40,'[예산부서]')
	dw_input.Setcolumn('cdept_cd')
	Return
End If

/* 원가부서 */
sEdeptCd = Trim(dw_input.GetItemstring(1,'edept_cd'))
If IsNull(sEdeptCd) Or sEdeptCd = '' Then
	f_message_chk(40,'[원가부문]')
	dw_input.Setcolumn('edept_cd')
	Return
End If

/* 비용금액 */
If sCurr = 'WON' Then
	dCostAmt = dw_input.GetItemNumber(1,'costamt')
	If IsNull(dCostAmt) or dCostAmt = 0 Then
		f_message_chk(40,'[비용금액]')
		dw_input.Setcolumn('costamt')
		Return
   End If
Else
	dCostAmt = dw_input.GetItemNumber(1,'costforamt')
	If IsNull(dCostAmt) or dCostAmt = 0 Then
		f_message_chk(40,'[비용외화금액]')
		dw_input.Setcolumn('costforamt')
		Return
   End If
End If

/* 비용구분 */
sCostGu = Trim(dw_input.GetItemString(1,'costgu'))
If IsNull(sCostGu) Or sCostGu = '' Then
	f_message_chk(40,'[비용구분]')
	dw_input.Setcolumn('costgu')
	Return
End If

/* 비용코드 */
sCostcd = Trim(dw_input.GetItemString(1,'costcd'))
If IsNull(sCostCd) Or sCostcd = '' Then
	f_message_chk(40,'[비용코드]')
	dw_input.Setcolumn('costcd')
	Return
End If

/* 상대계정코드 */
sCostcd = Trim(dw_input.GetItemString(1,'scodgu'))
If IsNull(sCostCd) Or sCostcd = '' Then
	f_message_chk(40,'[상대계정코드]')
	dw_input.Setcolumn('scodgu')
	Return
End If


/* 전표번호 채번 */
sCostNo = Trim(dw_input.GetItemString(nrow,'costno'))
if IsNull(sCostNo) or trim(sCostNo) = '' then
   sCostNo = wf_get_junpyo_no(sCostDt)
   dw_input.SetItem(nRow,'sabu',gs_sabu)
   dw_input.SetItem(nRow,'costno',sCostNo)
	dw_input.SetItem(nRow,'iseq',1)
	dw_input.SetItem(nRow,'crtgu','1')
	ncnt = 1
Else
	Select Max(iseq) into :nCnt
	  From expcosth  
	 Where sabu = :gs_sabu and costno = :sCostNo;
	If isnull(ncnt) then ncnt = 0
	
	If ncnt = 0 then
		MessageBox("수출비용 전표번호", "수출비용 전표번호가 없읍니다" + '~n' + &
												  "신규로 등록할 경우에는 전표번호를 Clear하십시요", information!)
		Return
	End if
	
	ncnt++
	
	dw_input.setitem(nrow, 'iseq', ncnt)
End If

IF dw_input.Update() <> 1 THEN
	f_message_chk(32,'')
   ROLLBACK;
   Return
END IF

/* ------------------------------------------------ */
/* 수출비용 Detail 저장                             */
/* ------------------------------------------------ */
dw_insert.SetFocus()
nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1
	/* 수출금액이 없으면 삭제 */
	dPiamt = dw_insert.GetItemNumber(ix,'piamt')
	If dPiamt = 0 Or IsNull(dPiamt) Then
      dw_insert.DeleteRow(ix)
		Continue
	End If

   /* 비용금액 */
   If sCurr = 'WON' Then
	   dCostAmt = dw_insert.GetItemNumber(ix,'costamt')
	   If IsNull(dCostAmt) or dCostAmt = 0 Then
			f_message_chk(40,'[비용금액]')
			dw_insert.ScrollToRow(ix)
			dw_insert.Setcolumn('costamt')
			Return
      End If
   Else
	   dCostAmt = dw_insert.GetItemNumber(ix,'costforamt')
	   If IsNull(dCostAmt) or dCostAmt = 0 Then
			f_message_chk(40,'[비용금액]')
			dw_insert.ScrollToRow(ix)
			dw_insert.Setcolumn('costforamt')
			Return
      End If
   End If

	dw_insert.SetItem(ix,'costno',sCostNo)
	dw_insert.Setitem(ix,'iseq',ncnt)
Next

IF dw_insert.Update() <> 1 THEN
	f_message_chk(32,'')	
   ROLLBACK;
   Return
END IF

COMMIT;

/* 저장후 신규입력상태로 변경 */
dw_input.SetItemStatus(1, 0, Primary!, New!)
dw_input.SetItem(1, 'costno', sCostNo)
dw_input.setitem(1, 'iseq',   0)
dw_input.SetItem(1, 'costcd', snull)
dw_input.SetItem(1, 'costamt', 0)
dw_input.SetItem(1, 'costvat', 0)
dw_input.SetItem(1, 'costforamt', 0)

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItemStatus(ix, 0, Primary!, New!)
	dw_insert.SetItem(ix, 'costamt', 0)
	dw_insert.SetItem(ix, 'costforamt', 0)
Next

f_message_chk(202,'')
sle_msg.text ='자료를 저장하였습니다!!'

dw_1.retrieve(gs_sabu, scostno)

wf_protect_key(1)
ib_any_typing = False

dw_input.setfocus()
end event

type cb_delrow from w_inherite`cb_delrow within w_sal_06060
boolean visible = false
integer y = 3200
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_06060
boolean visible = false
integer y = 3200
end type

type dw_insert from w_inherite`dw_insert within w_sal_06060
integer x = 37
integer y = 1624
integer width = 4530
integer height = 680
integer taborder = 20
string dataobject = "d_sal_06060_d"
end type

event dw_insert::rbuttondown;String sData,sCino
int    nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'cino'
		gs_code = 'A'
		gs_gubun = 'A'
		Open(w_expci_popup)
		If gs_code = '' Or IsNull(gs_code) Then Return 1

//      /* 선택된 갯수가 1개인 경우 */
//		If gs_gubun = '1' Then
//		   SetItem(nrow,'cino',gs_code)
//		   SetItem(nrow,'pino',gs_codename)
//			SetItem(nrow,'piamt',wf_get_piamt(gs_code,gs_codename))
//		Else
			wf_setting_cipi(nRow, gs_code)
//		End If
	Case 'pino'
      open(w_exppih_popup)
		If gs_code = '' Or IsNull(gs_code) Then Return 1
		
		SetItem(nRow,'pino',gs_code)
		
		sCino = wf_select_pino(nRow,gs_code)
		SetItem(nRow,'cino',sCino)
		SetItem(nRow,'piamt',wf_get_piamt(sCino,gs_code))
   /* bl 접수번호 선택 popup */
   Case "blno"
   	Open(w_expbl_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"blno",gs_code)
   /* nego 접수번호 선택 popup */
	Case "ngno"
   	Open(w_expnego_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"ngno",gs_code)
   /* lc 접수번호 선택 popup */
	Case "explcno"
   	Open(w_explc_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"explcno",gs_code)
End Choose

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sCino,sPino, sData
Long   nRow

nRow  = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'cino'
		sCino = Trim(GetText())
		If IsNull(sCino) Or sCino = '' Then 
			MessageBox('확 인','삭제버튼으로 삭제하시기 바랍니다')
			p_del.SetFocus()
			Return 2
		End If
		
		/* CI No로 Invoice금액 설정 */
		If wf_setting_cipi(nRow, sCino) <= 0 Then		Return 2
	Case 'pino'
		sPino = Trim(GetText())
		If IsNull(sPino) Or sPino = '' Then 
			MessageBox('확 인','삭제버튼으로 삭제하시기 바랍니다')
			p_del.SetFocus()
			Return 2
		End If
		
		sCino = wf_select_pino(nRow,sPino)
		SetItem(nRow,'cino',sCino)
		If IsNull(sCino) or sCino = '' Then
			SELECT PINO Into :sPino FROM EXPPIH WHERE PINO = :sPino;
			If sqlca.sqlcode <> 0 Then
  			  f_message_chk(98,'[P/I NO]')
			  Return 1
		   End If
		End If

		SetItem(nRow,'piamt',wf_get_piamt(sCino,sPino))
	Case 'blno'  // bl접수번호
		sData = Trim(GetText())
		If IsNull(sData) or sData = '' Then Return
			
		If wf_select_blno(nRow,Trim(GetText())) <> 0 Then
			f_message_chk(33,'[B/L No.]')
			Return 1
		End If
	Case 'ngno'  // nego 접수번호
		sData = Trim(GetText())
		If IsNull(sData) or sData = '' Then Return
		
		If wf_select_ngno(nRow,Trim(GetText())) <> 0 Then
			f_message_chk(33,'[Nego No.]')
			Return 1
		End If
	Case 'explcno'  // explcno 접수번호
		sData = Trim(GetText())
		If IsNull(sData) or sData = '' Then Return
		
		If wf_select_explcno(nRow,Trim(GetText())) <> 0 Then
			f_message_chk(33,'[L/C No.]')
			Return 1
		End If
End Choose

end event

type cb_mod from w_inherite`cb_mod within w_sal_06060
boolean visible = false
integer y = 3200
end type

type cb_ins from w_inherite`cb_ins within w_sal_06060
boolean visible = false
integer y = 3200
end type

type cb_del from w_inherite`cb_del within w_sal_06060
boolean visible = false
integer y = 3200
end type

type cb_inq from w_inherite`cb_inq within w_sal_06060
boolean visible = false
integer y = 3200
end type

type cb_print from w_inherite`cb_print within w_sal_06060
boolean visible = false
integer x = 1947
integer y = 3200
integer taborder = 110
boolean enabled = false
end type

type cb_can from w_inherite`cb_can within w_sal_06060
boolean visible = false
integer y = 3200
end type

type cb_search from w_inherite`cb_search within w_sal_06060
boolean visible = false
integer y = 3200
end type

type gb_10 from w_inherite`gb_10 within w_sal_06060
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_06060
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06060
end type

type r_head from w_inherite`r_head within w_sal_06060
integer y = 200
integer width = 4539
integer height = 792
end type

type r_detail from w_inherite`r_detail within w_sal_06060
integer y = 1620
integer width = 4539
integer height = 688
end type

type dw_1 from datawindow within w_sal_06060
integer x = 37
integer y = 1040
integer width = 4530
integer height = 528
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_06060_hist"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;String scostno
decimal diseq

if row > 0 then
	scostno = getitemstring(row, "costno")
	diseq   = getitemdecimal(row, "iseq")
	dw_input.setitem(1, "costno", scostno)
	dw_input.setitem(1, "iseq",   diseq)

	p_inq.triggerevent(clicked!)
end if
end event

type p_1 from uo_picture within w_sal_06060
integer x = 3378
integer y = 28
integer width = 178
boolean bringtotop = true
string picturename = "..\image\회계전송_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = '..\image\회계전송_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = '..\image\회계전송_up.gif'
end event

event clicked;call super::clicked;Open(w_sal_06060_trs)
end event

type p_2 from uo_picture within w_sal_06060
integer x = 3552
integer y = 28
integer width = 178
boolean bringtotop = true
string picturename = "..\image\자동배분_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = '..\image\자동배분_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = '..\image\자동배분_up.gif'
end event

event clicked;call super::clicked;/* ---------------------------------------------------- */
/* 수출비용을 CI,PI 금액에 따라 배분한다                */
/* EXPCOSTH -> EXPCOSTD                                 */
/* ---------------------------------------------------- */
Long nCnt,ix
Double dCostAmt,dCostForAmt,dSumAmtd,dSumForAmtd
Double dPiamt,dDivRate,dCostAmtd,dCostForAmtd, dCostVat
Double dSumTotAmt
String sCurr

If dw_input.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
If dw_input.RowCount() <= 0 Then Return

nCnt = dw_insert.RowCount()
If nCnt <= 0 Then
	f_message_chk(161,'')
	Return
End If

dw_input.SetFocus()
/* 통화종류에 따라 배분하는 기준을 결정 */
sCurr = dw_input.GetItemString(1,'curr')
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(40,'[통화]')
	dw_input.SetColumn('curr')
	Return
End If

/* 배분할 비용금액 */
dCostAmt = dw_input.GetItemNumber(1,'costamt')
dCostVat = dw_input.GetItemNumber(1,'costvat')
dCostForAmt = dw_input.GetItemNumber(1,'costforamt')
If sCurr = 'WON' Then
  If IsNull(dCostAmt) Or dCostAmt = 0 Then
	 f_message_chk(40,'[비용금액]')
	 dw_input.SetColumn('costamt')
	 Return
  End If
  
  If IsNull(dCostVat) Then dCostVat = 0
  dCostAmt += dCostVat
Else
  If IsNull(dCostForAmt) Or dCostForAmt = 0 Then
	 f_message_chk(40,'[비용외화금액]')
	 dw_input.SetColumn('costforamt')
	 Return
  End If
End If

dSumAmtd = 0
dSumForAmtd = 0
dSumTotAmt = dw_insert.GetItemNumber(1,'sum_piamt')
For ix = 1 To nCnt
	dPiAmt = dw_insert.GetItemNumber(ix,'piamt')
	If IsNull(dPiamt) or dPiamt = 0 Then Return
	
	/* 수출비용 배분율 계산 */
	dDivRate  = dPiAmt / dSumTotAmt
	
	/*배분된 금액 */
	dCostAmtd = TrunCate(dCostAmt * dDivRate,0)
	dSumAmtd += dCostAmtd
	
	dCostForAmtd = TrunCate(dCostForAmt * dDivRate,2)
	dSumForAmtd += dCostForAmtd
	
	/* 끝전 처리 */
	If ix = nCnt Then  
		dCostAmtd += Round( dCostAmt - dSumAmtd ,2)
		dCostForAmtd += Round( dCostForAmt - dSumForAmtd ,2)
	End If
	
	dw_insert.SetItem(ix,'costamt',    dCostAmtd)
	dw_insert.SetItem(ix,'costforamt', dCostForAmtd)
Next

end event

type pb_1 from u_pic_cal within w_sal_06060
integer x = 763
integer y = 760
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('gyul_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'gyul_date', gs_code)

end event

type pb_2 from u_pic_cal within w_sal_06060
integer x = 2341
integer y = 216
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('costdt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'costdt', gs_code)

end event

type r_1 from rectangle within w_sal_06060
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 33028087
integer x = 32
integer y = 1036
integer width = 4539
integer height = 536
end type

