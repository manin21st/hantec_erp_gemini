$PBExportHeader$w_kcda01.srw
$PBExportComments$계정과목 등록
forward
global type w_kcda01 from w_inherite
end type
end forward

global type w_kcda01 from w_inherite
integer width = 4736
integer height = 2524
string title = "계정과목 등록"
cbx_1 cbx_1
cbx_2 cbx_2
dw_1 dw_1
dw_list dw_list
st_2 st_2
sle_1 sle_1
p_copy p_copy
dw_copy dw_copy
end type

global w_kcda01 w_kcda01

type variables
end variables

forward prototypes
public subroutine wf_find_row (string sacc1, string sacc2)
public function integer wf_requiredchk (integer ll_row)
public subroutine wf_init ()
public subroutine wf_set_openwindow (string acc1, string acc2)
public subroutine wf_control_kfz01ot1 (string sacc1_cd, string sacc2_cd)
public subroutine wf_acccode_accross ()
public subroutine wf_setting_retrievemode (string mode)
event ue_query ( )
event ue_add ( )
event ue_delete ( )
event ue_save ( )
event ue_cancel ( )
event ue_print ( )
event ue_close ( )
end prototypes

public subroutine wf_find_row (string sacc1, string sacc2);Integer iRow

dw_list.SetRedraw(False)
dw_list.Retrieve(sAcc1,sAcc2)

iRow = dw_list.Find("acc1_cd = '"+sAcc1 + "' and acc2_cd = '" + sAcc2 +"'",1,dw_list.RowCount())
if iRow > 0 then
	dw_list.ScrollToRow(iRow)
	dw_list.SelectRow(iRow,True)
end if
dw_list.SetRedraw(True)

end subroutine

public function integer wf_requiredchk (integer ll_row);String   sAcc1,sAcc2,sDcGu,sBalGu,sLevel,sYesanGbn,sAcc1Name,sAcc2Name,sUpAcc,sGbn6,sCusGbn,sRemark4,sNull
Integer  iCount,iOpenCount

SetNull(sNull)

dw_1.AcceptText()
sAcc1     = dw_1.GetItemString(ll_row,"acc1_cd")
sAcc2     = dw_1.GetItemString(ll_row,"acc2_cd")
sAcc1Name = dw_1.GetItemString(ll_row,"acc1_nm")
sAcc2Name = dw_1.GetItemString(ll_row,"acc2_nm")
sDcGu     = dw_1.GetItemString(ll_row,"dc_gu")
sBalGu    = dw_1.GetItemString(ll_row,"bal_gu")
sLevel    = dw_1.GetItemString(ll_row,"lev_gu")
sYesanGbn = dw_1.GetItemString(ll_row,"yesan_gu") 

sUpAcc    = dw_1.GetItemString(ll_row,"sacc_cd") 
sCusGbn   = dw_1.GetItemString(ll_row,"cus_gu") 
sGbn6     = dw_1.GetItemString(ll_row,"gbn6") 
sRemark4  = dw_1.GetItemString(ll_row,"remark4") /*외화관리여부*/

iOpenCount = dw_1.GetItemNumber(ll_row,"opencount")

IF sAcc1 = "" OR IsNull(sAcc1) THEN
	F_MessageChk(1,'[계정과목]')
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return -1
END IF
IF sAcc2 = "" OR IsNull(sAcc2) THEN
	F_MessageChk(1,'[계정과목]')
	dw_1.SetColumn("acc2_cd")
	dw_1.SetFocus()
	Return -1
END IF

IF sAcc1Name = "" OR IsNull(sAcc1Name) THEN
	F_MessageChk(1,'[계정과목명]')
	dw_1.SetColumn("acc1_nm")
	dw_1.SetFocus()
	Return -1
END IF
IF sAcc2Name = "" OR IsNull(sAcc2Name) THEN
	F_MessageChk(1,'[계정과목명]')
	dw_1.SetColumn("acc2_nm")
	dw_1.SetFocus()
	Return -1
END IF

IF sDcGu = "" OR IsNull(sDcGu) THEN
	F_MessageChk(1,'[대차구분]')
	dw_1.SetColumn("dc_gu")
	dw_1.SetFocus()
	Return -1
END IF

IF sBalGu = "" OR IsNull(sBalGu) THEN
	F_MessageChk(1,'[재무제표항목구분]')
	dw_1.SetColumn("bal_gu")
	dw_1.SetFocus()
	Return -1
END IF

IF sLevel = "" OR IsNull(sLevel) THEN
	F_MessageChk(1,'[계정레벨]')
	dw_1.SetColumn("lev_gu")
	dw_1.SetFocus()
	Return -1
END IF
IF sYesanGbn = "" OR IsNull(sYesanGbn) THEN
	F_MessageChk(1,'[예산통제여부]')
	dw_1.SetColumn("yesan_gu")
	dw_1.SetFocus()
	Return -1
END IF

IF sAcc2 = '00' AND sAcc1 = sUpAcc THEN	/*계정코드 '00'이면 상위계정 <> 계정과목:2001.05.21*/
	F_MessageChk(16,'[상위계정 = 계정과목]')
	dw_1.SetItem(ll_row,"sacc_cd",sNull)
	dw_1.SetColumn("sacc_cd")
	dw_1.SetFocus()
	Return -1
END IF

IF sAcc2 = '00' AND sBalGu <> '4' THEN	/*계정코드 '00'이고 '재무제표'이면 하위계정존재 불가:2001.05.21*/
	select Count(*) Into :iCount from kfz01om0 where sacc_cd = :sAcc1;
	
	if sqlca.sqlcode = 0 and iCount <> 0 then
		F_MessageChk(16,'[하위계정존재 오류]')
		dw_1.SetColumn("acc1_cd")
		dw_1.SetFocus()
		Return -1	
	end if
END IF

IF sGbn6 = 'Y' AND sCusGbn <> 'Y' THEN	/*거래처원장관리 'Y'이면 거래처 체크는 'Y':2001.05.21*/
	F_MessageChk(1,'[거래처체크여부]')
	dw_1.SetColumn("cus_gu")
	dw_1.SetFocus()
	Return -1	
END IF

IF sBalGu <> '4' THEN	/*'재무제표'항목아니면 From,To는 자기자신:2001.05.21*/
	dw_1.SetItem(ll_row,"fracc1_cd",sAcc1)
	dw_1.SetItem(ll_row,"fracc2_cd",sAcc2)
	dw_1.SetItem(ll_row,"toacc1_cd",sAcc1)
	dw_1.SetItem(ll_row,"toacc2_cd",sAcc2)
END IF

IF iOpenCount > 1 THEN
	F_MessageChk(16,'[전표발생계정 > 1]')
	dw_1.SetColumn("sang_gu")
	dw_1.SetFocus()
	Return -1
END IF

Return 1
end function

public subroutine wf_init ();String sNullValue

w_mdi_frame.sle_msg.text =""

SetNull(sNullValue)

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetColumn("acc1_cd")
dw_1.SetFocus()

dw_1.SetRedraw(True)

cbx_2.Checked = False

dw_list.Retrieve()
dw_list.ScrollToRow(1)
end subroutine

public subroutine wf_set_openwindow (string acc1, string acc2);
String sDcGbn,sBalGbn,sVatGbn,sJubGbn,sSangGbn,sRBilGbn,sJBilGbn,sChaGbn,sYuGbn,&
       sWinIdC,sWinIdD,sBudoAcc1,sBudoAcc2,sJaSanGbn

sDcGbn  = dw_1.GetItemString(dw_1.GetRow(),"dc_gu")
sBalGbn = dw_1.GetItemString(dw_1.GetRow(),"bal_gu") 

IF sBalGbn = '4' THEN Return

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),	  SUBSTR("SYSCNFG"."DATANAME",6,2)		/*부도계정*/
	INTO :sBudoAcc1,				  :sBudoAcc2  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '18' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	sBudoAcc1 = '00000'
	sBudoAcc2 = '00'
ELSE
	IF IsNull(sBudoAcc1) THEN sBudoAcc1 = '00000'
	IF IsNull(sBudoAcc2) THEN sBudoAcc2 = '00'
END IF

sSangGbn = dw_1.GetItemString(dw_1.GetRow(),"sang_gu")
sJubGbn  = dw_1.GetItemString(dw_1.GetRow(),"jubdae_gu")
sVatGbn  = dw_1.GetItemString(dw_1.GetRow(),"vat_gu")
sRBilGbn = dw_1.GetItemString(dw_1.GetRow(),"rcvbil_gu")
sJBilGbn = dw_1.GetItemString(dw_1.GetRow(),"paybil_gu")
sChaGbn  = dw_1.GetItemString(dw_1.GetRow(),"ch_gu")
sYuGbn   = dw_1.GetItemString(dw_1.GetRow(),"yu_gu")
sJaSanGbn= dw_1.GetItemString(dw_1.GetRow(),"remark3")

IF sSangGbn = 'Y' THEN
	IF sDcGbn = '1' THEN
		SetNull(sWinIdC)
		sWinIdD = 'w_kglb01g'
	ELSE
		sWinIdC = 'w_kglb01g'
		SetNull(sWinIdD)
	END IF
ELSEIF sJubGbn = 'Y' THEN
	IF sDcGbn = '1' THEN
		sWinIdC = 'w_kglb01a'
		SetNull(sWinIdD)
	END IF
ELSEIF sVatGbn = 'Y' THEN
	IF sDcGbn = '1' THEN
		sWinIdC = 'w_kglb01b'
		SetNull(sWinIdD)
	ELSE
		SetNull(sWinIdC)
		sWinIdD = 'w_kglb01b'
	END IF	
ELSEIF sRBilGbn = 'Y' THEN
	IF sDcGbn = '1' THEN
		IF Acc1 = sBudoAcc1 AND Acc2 = sBudoAcc2 THEN	/*부도계정*/
			SetNull(sWinIdC)
			sWinIdD = 'w_kglb01d1'
		ELSE
			sWinIdC = 'w_kglb01d'
			sWinIdD = 'w_kglb01d1'
		END IF
	END IF
ELSEIF sJBilGbn = 'Y' THEN
	IF sDcGbn = '2' THEN
		sWinIdC = 'w_kglb01c1'
		sWinIdD = 'w_kglb01c'
	END IF	
ELSEIF sChaGbn = 'Y' THEN
	IF sDcGbn = '2' THEN
		SetNull(sWinIdC)
		SetNull(sWinIdD)
	END IF	
ELSEIF sYuGbn = 'Y' THEN
	IF sDcGbn = '1' THEN
		sWinIdC = 'w_kglb01f'
		SetNull(sWinIdD)
	END IF	
ELSEIF sJaSanGbn = 'Y' THEN
	IF sDcGbn = '1' THEN
		sWinIdC = 'w_kglb01h'
		SetNull(sWinIdD)
	END IF
END IF

dw_1.SetItem(dw_1.GetRow(),"use_windowc",sWinIdC)
dw_1.SetItem(dw_1.GetRow(),"use_windowd",sWinIdD)

end subroutine

public subroutine wf_control_kfz01ot1 (string sacc1_cd, string sacc2_cd);Integer iCount,iMaxSeq
String  sDcGbn,sRemark4,sTaxGbn,sGbn4,sGbn1,sChGbn, sDriveGbn

dw_1.AcceptText()
sDcGbn   = dw_1.GetItemString(dw_1.getrow(),"dc_gu")
sRemark4 = dw_1.GetItemString(dw_1.getrow(),"remark4")
IF sRemark4 = 'Y' THEN	/*외화관리='Y'*/
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd;	/*관리자료 삭제*/
	
	insert into kfz01ot0	/*차변-외화종류*/
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'1',			1,					'y_curr',		'외화종류',		'Y',			null,			'1');
		
	insert into kfz01ot0	/*차변-외화금액*/
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'1',			2,					'y_amt',			'외화금액',		'Y',			null,			'0');
		
	insert into kfz01ot0	/*차변-적용환율*/
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'1',			3,					'y_rate',		'적용환율',		'Y',			null,			'0');
		
	insert into kfz01ot0	/*대변-외화종류*/
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'2',			1,					'y_curr',		'외화종류',		'Y',			null,			'1');
		
	insert into kfz01ot0	/*대변-외화금액*/
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'2',			2,					'y_amt',			'외화금액',		'Y',			null,			'0');
		
	insert into kfz01ot0	/*대변-적용환율*/
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'2',			3,					'y_rate',		'적용환율',		'Y',			null,			'0');
END IF

sDcGbn   = dw_1.GetItemString(dw_1.getrow(),"dc_gu")
sTaxGbn = dw_1.GetItemString(dw_1.getrow(),"taxgbn")	/*과세유형관리='Y'*/
IF sTaxGbn = 'Y' THEN
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu = :sDcGbn and 
						(kwan_colid = 'taxgbn' );	
	
	select nvl(Max(seq_no),0)	into :iMaxSeq 
		from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu = :sDcGbn;
		
	if IsNull(iMaxSeq) then iMaxSeq = 0
	iMaxSeq = iMaxSeq + 1
		
	insert into kfz01ot0	/*차대변에 '과세유형관리'추가*/
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		:iMaxSeq,		'taxgbn',		'과세유형관리',	'Y',			null,			'1');

else
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu = :sDcGbn and 
						(kwan_colid = 'taxgbn' );		
END IF

sGbn4 = dw_1.GetItemString(dw_1.getrow(),"gbn4")	/*어음계정관리 = 'Y'*/
IF sGbn4 = 'Y' THEN
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd;	
			
	insert into kfz01ot0	/*차대변에 추가*/
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		1,					'k_symd',		'발행일자',		'Y',			null,			'1');

	insert into kfz01ot0	
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		2,					'k_eymd',		'만기일자',		'Y',			null,			'1');

	insert into kfz01ot0	
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		3,					'kwan_no',		'어음번호',		'Y',			'80',			'1');	
END IF

sDcGbn   = dw_1.GetItemString(dw_1.getrow(),"dc_gu")
sGbn1 = dw_1.GetItemString(dw_1.getrow(),"gbn1")	/*계정성격구분 = '퇴직급여',충당부채 = 'Y'*/
sChGbn = dw_1.GetItemString(dw_1.getrow(),"ch_gu")
IF sGbn1 = '6' AND sChGbn = 'Y' THEN
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu = '1' and kwan_colid = 'exp_gu';	

	if sDcGbn = '1' then 
		sDcGbn = '2'
	else
		sDcGbn = '1'
	end if
	
	insert into kfz01ot0	/*반대변에 추가*/
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		10,				'exp_gu',		'처리구분',		'Y',			null,			'1');
END IF

sDriveGbn = dw_1.GetItemString(dw_1.getrow(),"drivegbn")
IF sDriveGbn = 'Y' THEN
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu =:sDcGbn and kwan_colid = 'kwan_no';	

	insert into kfz01ot0	
		(acc1_cd,			acc2_cd,		dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		10,				'kwan_no',		'관리번호',			'Y',			'98',			'1');
END IF

end subroutine

public subroutine wf_acccode_accross ();String     sAcc1, sAcc2, sLevGu, sUpAcc1, sCurAcc1, sCurAcc2, sCustAcc1, sCustAcc2, &
			  sAryAcc1[7], sAryAcc2[7]
Long       i, j, k,iRowCount,iCurRow
DataStore  Idw_Ary, Idw_Accode

Idw_Ary    = Create DataStore
Idw_Accode = Create DataStore

Idw_Ary.DataObject = 'dw_kcda01_2'
Idw_Ary.SetTransObject(Sqlca)
Idw_Ary.Reset()

Idw_Accode.DataObject = 'dw_kcda01_3'
Idw_Accode.SetTransObject(Sqlca)
Idw_Accode.Reset()

IF Idw_Ary.Retrieve() > 0 THEN	/*관리자료 삭제처리*/
	iRowCount = Idw_Ary.RowCount()
	FOR i = iRowCount TO 1 Step -1
		Idw_Ary.DeleteRow(i)
	NEXT
	IF Idw_Ary.Update() <> 1 THEN
		F_MessageChk(12,'')
		Rollback;
		Return
	END IF
	Commit;
END IF

IF Idw_Accode.Retrieve() > 0 THEN
	iRowCount = Idw_Accode.RowCount()
	
	For i = 1 TO iRowCount
		sAcc1   = Idw_Accode.GetItemString(i,"acc1_cd")
		sAcc2   = Idw_Accode.GetItemString(i,"acc2_cd")
		sUpAcc1 = Idw_Accode.GetItemString(i,"sacc_cd") 
		sLevGu  = Idw_Accode.GetItemString(i,"lev_gu") 
		
		w_mdi_frame.sle_msg.text = "["+sAcc1+"-"+sAcc2+"]"
		
		For k = 1 To 7
			sAryAcc1[k] = '';		sAryAcc2[k] = '';
		Next

		j = 1
		sAryAcc1[1] = sUpAcc1
		sAryAcc2[1] = '00'
		sCurAcc1 = sUpAcc1
		sCurAcc2 = '00'
		
		if sLevGu = '5' then
			sCustAcc1 = sUpAcc1
			sCustAcc2 = '00'
		else
			sCustAcc1 = ''
			sCustAcc2 = ''
		end if
	
		Do while Trim(sCurAcc1) <> '' and Trim(sCurAcc1) <> '     ' and Not ISNULL(sCurAcc1)
	      select sacc_cd 	into :sCurAcc1
				from kfz01om0
				where acc1_cd = :sCurAcc1 and acc2_cd = :sCurAcc2;
			if sqlca.sqlcode = 0 then
				j = j + 1
				
				IF j > 6 then 
					MessageBox('확 인','계정과목의 레벨이 제한 레벨(6)을 초과하였습니다...')
					Return
				END IF
				sAryAcc1[j] = sCurAcc1
				sAryAcc2[j] = sCurAcc2
			end if
   	Loop

		iCurRow = Idw_Ary.InsertRow(0)
		Idw_Ary.SetItem(iCurRow,"acc1_cd",		sAcc1)
		Idw_Ary.SetItem(iCurRow,"acc2_cd",		sAcc2)
		Idw_Ary.SetItem(iCurRow,"s1_acc1_cd",	sAryAcc1[1])
		Idw_Ary.SetItem(iCurRow,"s1_acc2_cd",	sAryAcc2[1])
		Idw_Ary.SetItem(iCurRow,"s2_acc1_cd",	sAryAcc1[2])
		Idw_Ary.SetItem(iCurRow,"s2_acc2_cd",	sAryAcc2[2])
		Idw_Ary.SetItem(iCurRow,"s3_acc1_cd",	sAryAcc1[3])
		Idw_Ary.SetItem(iCurRow,"s3_acc2_cd",	sAryAcc2[3])
		Idw_Ary.SetItem(iCurRow,"s4_acc1_cd",	sAryAcc1[4])
		Idw_Ary.SetItem(iCurRow,"s4_acc2_cd",	sAryAcc2[4])
		Idw_Ary.SetItem(iCurRow,"s5_acc1_cd",	sAryAcc1[5])
		Idw_Ary.SetItem(iCurRow,"s5_acc2_cd",	sAryAcc2[5])
		Idw_Ary.SetItem(iCurRow,"s6_acc1_cd",	sAryAcc1[6])
		Idw_Ary.SetItem(iCurRow,"s6_acc2_cd",	sAryAcc2[6])
		Idw_Ary.SetItem(iCurRow,"t1_acc1_cd",	sCustAcc1)
		Idw_Ary.SetItem(iCurRow,"t1_acc2_cd",	sCustAcc2)
	NEXT
END IF
IF Idw_Ary.Update() <> 1 THEN
	F_MessageChk(13,'')
	Rollback;
	Return
END IF
Commit;

Destroy Idw_Ary
Destroy Idw_Accode

return 
end subroutine

public subroutine wf_setting_retrievemode (string mode);
dw_1.SetRedraw(False)
p_ins.Enabled =True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"
p_mod.Enabled =True
p_mod.PictureName = "C:\erpman\image\수정_up.gif"
IF mode ="M" THEN			//수정
	dw_1.SetTabOrder("acc1_cd",0)
	dw_1.SetTabOrder("acc2_cd",0)
	
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	p_copy.Enabled = False
	p_copy.PictureName = "C:\erpman\image\복사_d.gif"
	
	cbx_2.Enabled  = True
	
	dw_1.SetColumn("acc1_nm")
ELSEIF mode ="I" THEN		//입력
	dw_1.SetTabOrder("acc1_cd",10)
	dw_1.SetTabOrder("acc2_cd",20)
	
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	p_copy.Enabled = True
	p_copy.PictureName = "C:\erpman\image\복사_up.gif"
	
	cbx_2.Enabled  = False
	
	dw_1.SetColumn("acc1_cd")
END IF
dw_1.SetRedraw(True)
end subroutine

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_copy.SetTransObject(SQLCA)

ib_any_typing=False

sModStatus ="I"

WF_SETTING_RETRIEVEMODE(sModStatus)

dw_1.Reset()
dw_1.InsertRow(0)
dw_list.Retrieve()
SLE_1.setfocus()
end event

event activate;call super::activate;gf_toolbar_set(this, "ins:add:del:save:cancel:print:close")
end event

event resize;call super::resize;const long ll_edge = 30

if il_borderpaddingwidth > 0 then
	dw_list.width = 1221 * newwidth / ii_originalwidth
	dw_1.x = dw_list.x + dw_list.width + ll_edge
	dw_1.width = newwidth - dw_1.x - il_borderpaddingwidth
end if

if il_borderpaddingheight > 0 then
	dw_list.height = newheight - dw_list.y - il_borderpaddingheight
	dw_1.height = newheight - dw_1.y - il_borderpaddingheight
end if
end event

on w_kcda01.create
call super::create
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.dw_1=create dw_1
this.dw_list=create dw_list
this.st_2=create st_2
this.sle_1=create sle_1
this.p_copy=create p_copy
this.dw_copy=create dw_copy

int iCurrent
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cbx_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.p_copy
this.Control[iCurrent+8]=this.dw_copy
end on

on w_kcda01.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.p_copy)
destroy(this.dw_copy)
end on

event key;
GraphicObject which_control
string ls_string,sAcc2, sAnm
long iRow

which_control = getfocus()

if  TypeOf(which_control)=SingleLineEdit! then
   if sle_1 = which_control then
    
	  Choose Case key
		Case KeyEnter!	
	       ls_string =trim(sle_1.text)
	      if isNull(ls_string) or ls_string="" then return
	       
		   If Len(ls_string) > 0 Then
				Choose Case Asc(ls_string)
				//영문 - 코드
				Case is < 127
             sAnm= ls_string+"%"
				
				//한글 - 명칭
				Case is >= 127

				 sAnm= "%"+ls_string+"%"

				End Choose
			End If		

     
	    iRow = dw_list.Find("acc1_cd like '" + sAnm +"'",1,dw_list.RowCount())
        
		  if iRow>0 then
		     
	     else
	        iRow = dw_list.Find("acc2_nm like '" + sAnm +"'",1,dw_list.RowCount())
			 if iRow>0 then
		    end if
	     end if			 
		  
		  
		  if iRow > 0 then
         	dw_list.ScrollToRow(iRow)
	         dw_list.SelectRow(iRow,True)
		  else 
		      MessageBox('조회결과',"조회하신 자료가 없습니다. 다시 조회조건을 확인하여 주십시요")  
	     end if	
		   
		 sle_1.text=""
	  End Choose
   end if
else

Choose Case key
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyT!
		p_ins.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose

end if
end event

type dw_insert from w_inherite`dw_insert within w_kcda01
end type

type p_delrow from w_inherite`p_delrow within w_kcda01
end type

type p_addrow from w_inherite`p_addrow within w_kcda01
end type

type p_search from w_inherite`p_search within w_kcda01
end type

type p_ins from w_inherite`p_ins within w_kcda01
end type

type p_new from w_inherite`p_new within w_kcda01
end type

type p_exit from w_inherite`p_exit within w_kcda01
end type

type p_can from w_inherite`p_can within w_kcda01
end type

type p_print from w_inherite`p_print within w_kcda01
end type

type p_inq from w_inherite`p_inq within w_kcda01
end type

type p_del from w_inherite`p_del within w_kcda01
end type

type p_mod from w_inherite`p_mod within w_kcda01
end type

type st_1 from w_inherite`st_1 within w_kcda01
end type

type cbx_1 from checkbox within w_kcda01
integer x = 1641
integer y = 80
integer width = 640
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long backcolor = 32106727
string text = "계정과목 일괄 등록"
end type

event cbx_1::clicked;open(w_kcda01a)
cbx_1.Checked =False
end event

type cbx_2 from checkbox within w_kcda01
integer x = 2450
integer y = 80
integer width = 553
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long textcolor = 33554432
long backcolor = 32106727
string text = "관리항목 등록"
end type

event cbx_2::clicked;
cbx_2.Checked = True
IF sModStatus <> 'M' THEN 
	f_messagechk(11,'')
	cbx_2.Checked = False
	Return
END IF

IF dw_1.GetItemString(1,"bal_gu") = '4' THEN
	F_MessageChk(25,'[재무제표항목 불가]')
	cbx_2.Checked = False
	Return	
END IF

OpenWithParm(W_Kcda01b,dw_1.GetItemString(dw_1.getrow(),"acc1_cd")+dw_1.GetItemString(dw_1.getrow(),"acc2_cd"))

IF Message.StringParm = 'cancel' THEN
	cbx_2.Checked = False
ELSE
	cbx_2.Checked = True
END IF

end event

type dw_1 from datawindow within w_kcda01
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1303
integer y = 196
integer width = 3319
integer height = 2064
integer taborder = 40
string dataobject = "dw_kcda01_1"
boolean border = false
boolean livescroll = true
end type

event dw_1::itemchanged;String sDcGbn,sBalGbn,sCustGbn,sYeSanGbn,sLevel,sAcc1_Code,sAcc2_Code,sAccName,sYeGbn,&
		 sFiCode,sFiName,sNullValue

sle_msg.text =""

SetNull(sNullValue)
		
this.AcceptText()
IF this.GetColumnName() = 'acc1_cd' OR this.GetColumnName() = 'acc2_cd' THEN
	sAcc1_Code = this.GetItemString(row,"acc1_cd")
	sAcc2_Code = this.GetItemString(row,"acc2_cd")
	
	IF sAcc1_Code = "" OR IsNull(sAcc1_Code) THEN 
		this.SetItem(row,"acc2_cd",sNullValue)
		Return
	END IF
	IF sAcc2_Code = "" OR IsNull(sAcc2_Code) THEN 
		this.SetItem(row,"acc1_cd",sNullValue)
		Return
	END IF
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
  		FROM "KFZ01OM0"  
  		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Code) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Code);
	IF SQLCA.SQLCODE = 0 THEN
		p_inq.TriggerEvent(Clicked!)
	ELSE
		this.SetTabOrder('acc1_cd',10)
		this.SetTabOrder('acc2_cd',20)
	END IF
	this.SetFocus()
	
	this.postevent(rbuttondown!)
END IF

IF this.GetColumnName() ="dc_gu" THEN
	sDcGbn = this.GetText()
	IF sDcGbn = "" OR IsNull(sDcGbn) THEN RETURN
	
	IF sDcGbn <> '1' and sDcGbn <> '2' THEN
		f_messagechk(20,"대차구분")
		dw_1.SetItem(row,"dc_gu",sNullValue)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bal_gu" THEN
	sBalGbn = this.GetText()
	IF sBalGbn = "" OR IsNull(sBalGbn) THEN RETURN
	
	IF Integer(sBalGbn) < 1 OR Integer(sBalGbn) > 4 THEN
		f_messagechk(20,"재무제표항목구분") 
		dw_1.SetItem(row,"bal_gu",sNullValue)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="gbn1" THEN
	sCustGbn = this.GetText()
	IF sCustGbn = "" OR IsNull(sCustGbn) THEN RETURN
	
	IF IsNull(F_Get_Refferance('CU',sCustGbn)) THEN
		f_messagechk(20,"계정성격구분")
		dw_1.SetItem(row,"gbn1",sNullValue)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="yesan_gu" THEN
	sYeSanGbn = this.GetText()
	IF sYeSanGbn = "" OR IsNull(sYeSanGbn) THEN RETURN
	
	IF sYeSanGbn <> 'Y' AND sYeSanGbn <> 'N' AND sYeSanGbn <> 'A' THEN
		f_messagechk(20,"예산통제여부")
		dw_1.SetItem(row,"yesan_gu",sNullValue)
		Return 1
	END IF	
END IF

IF this.GetColumnName() ="lev_gu" THEN
	sLevel = this.GetText()
	IF sLevel = "" OR IsNull(sLevel) THEN RETURN
	
	IF sLevel <> '1' AND sLevel <> '2' AND sLevel <> '3' AND sLevel <> '4' AND sLevel <> '5' THEN
		f_messagechk(20,"계정레벨")
		dw_1.SetItem(row,"lev_gu",sNullValue)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="ye_gu" THEN
	sYeGbn = this.GetText()
	IF sYeGbn = "" OR IsNull(sYeGbn) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AB',sYeGbn)) THEN
		F_MessageChk(20,"예적금구분")
		dw_1.SetItem(row,"ye_gu",sNullValue)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="kacc1_cd" OR this.GetColumnName() ="kacc2_cd" THEN
	sAcc1_Code = this.GetItemString(row,"kacc1_cd")
	sAcc2_Code = this.GetItemString(row,"kacc2_cd")
	
	IF sAcc1_Code ="" OR IsNull(sAcc1_Code) THEN 
		dw_1.SetItem(row,"kacc2_cd",sNullValue)
		RETURN
	END IF
	
	IF sAcc2_Code ="" OR IsNull(sAcc2_Code) THEN 
		dw_1.SetItem(row,"kacc1_cd",sNullValue)
		RETURN
	END IF
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
  		FROM "KFZ01OM0"  
  		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Code) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Code);
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"상대계정과목")
		dw_1.SetItem(row,"kacc1_cd",sNullValue)
		dw_1.SetItem(row,"kacc2_cd",sNullValue)
		dw_1.SetColumn("kacc1_cd")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="fin_cd" THEN
	sFiCode = this.GetText()
	IF sFiCode = "" OR IsNull(sFiCode) THEN 
		dw_1.SetItem(row,"finance_name_c",sNullValue)
		RETURN
	END IF
	
	SELECT "KFM10OM0"."FINANCE_NAME"  INTO :sFiName  
	  	FROM "KFM10OM0"  
   	WHERE "KFM10OM0"."FINANCE_CD" = :sFiCode   ;

	IF SQLCA.SQLCODE = 100 THEN
		f_messagechk(20,"차변금융기관코드")
		dw_1.SetItem(row,"fin_cd",sNullValue)
		dw_1.SetItem(row,"finance_name_c",sNullValue)
		dw_1.SetColumn("fin_cd")
		Return 1
	END IF
	dw_1.SetItem(row,"finance_name_c",sFiName)
END IF

IF this.GetColumnName() ="ficode" THEN
	sFiCode = this.GetText()
	IF sFiCode = "" OR IsNull(sFiCode) THEN 
		dw_1.SetItem(row,"finance_name",sNullValue)
		RETURN
	END IF
	
	SELECT "KFM10OM0"."FINANCE_NAME"  INTO :sFiName  
	  	FROM "KFM10OM0"  
   	WHERE "KFM10OM0"."FINANCE_CD" = :sFiCode   ;

	IF SQLCA.SQLCODE = 100 THEN
		f_messagechk(20,"대변금융기관코드")
		dw_1.SetItem(row,"ficode",sNullValue)
		dw_1.SetItem(row,"finance_name",sNullValue)
		dw_1.SetColumn("ficode")
		Return 1
	END IF
	dw_1.SetItem(row,"finance_name",sFiName)
END IF

IF this.GetColumnName() ="fracc1_cd" OR this.GetColumnName() ="fracc2_cd" THEN
	sAcc1_Code = this.GetItemString(row,"fracc1_cd")
	sAcc2_Code = this.GetItemString(row,"fracc2_cd")
	
	IF sAcc1_Code ="" OR IsNull(sAcc1_Code) THEN 
		dw_1.SetItem(row,"fracc2_cd",sNullValue)
		RETURN
	END IF
	
	IF sAcc2_Code ="" OR IsNull(sAcc2_Code) THEN 
		dw_1.SetItem(row,"fracc1_cd",sNullValue)
		RETURN
	END IF

END IF

IF this.GetColumnName() ="toacc1_cd" OR this.GetColumnName() ="toacc2_cd" THEN
	sAcc1_Code = this.GetItemString(row,"toacc1_cd")
	sAcc2_Code = this.GetItemString(row,"toacc2_cd")
	
	IF sAcc1_Code ="" OR IsNull(sAcc1_Code) THEN 
		dw_1.SetItem(row,"toacc2_cd",sNullValue)
		RETURN
	END IF
	
	IF sAcc2_Code ="" OR IsNull(sAcc2_Code) THEN 
		dw_1.SetItem(row,"toacc1_cd",sNullValue)
		RETURN
	END IF

END IF

end event

type dw_list from datawindow within w_kcda01
integer x = 55
integer y = 212
integer width = 1221
integer height = 2020
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_kcda01_4"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event dw_list::rowfocuschanged;long iCount
string a,b

If currentrow > 0 then
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
	
	dw_1.SetRedraw(False)
	if dw_1.Retrieve(this.GetItemString(currentrow,"acc1_cd"),this.GetItemString(currentrow,"acc2_cd")) <=0 then
		dw_1.InsertRow(0)
		dw_1.SetItem(currentrow,"acc1_cd", this.GetItemString(currentrow,"acc1_cd"))
      dw_1.SetItem(currentrow,"acc2_cd", this.GetItemString(currentrow,"acc2_cd"))
  
      f_messagechk(14,"")
	   p_ins.Enabled =True
	   p_ins.PictureName = "C:\erpman\image\추가_up.gif"
	
   end if
	
	dw_1.SetRedraw(True)

		a=dw_list.GetItemString(currentrow,"acc1_cd")
		b=dw_list.GetItemString(currentrow,"acc2_cd") 

      SELECT COUNT(*)  	INTO :iCount  
    		FROM "KFZ01OT0"  
   		WHERE ( "KFZ01OT0"."ACC1_CD" = :a ) AND  
      		   ( "KFZ01OT0"."ACC2_CD" = :b)   ;
			IF SQLCA.SQLCODE = 0 AND iCount > 0 THEN
			cbx_2.Checked = True
			ELSE
			cbx_2.Checked = False
			END IF

			ib_any_typing=False

			sModStatus="M"

        WF_SETTING_RETRIEVEMODE(sModStatus)				//수정 mode 

			p_ins.Enabled =False
			p_ins.PictureName = "C:\erpman\image\추가_d.gif"

end if

end event

type st_2 from statictext within w_kcda01
integer x = 73
integer y = 92
integer width = 366
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long backcolor = 33027312
string text = "계정과목"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kcda01
integer x = 347
integer y = 84
integer width = 567
integer height = 64
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
long textcolor = 33554432
boolean border = false
end type

type p_copy from uo_picture within w_kcda01
integer x = 3387
integer y = 24
integer width = 178
boolean bringtotop = true
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\복사_up.gif"
end type

event p_copy::clicked;call super::clicked;Integer iCount
String sAcc1Cd, sAcc2Cd

dw_1.accepttext()

sAcc1Cd = Trim(dw_1.getitemstring(dw_1.getrow(), "acc1_cd"))
sAcc2Cd = Trim(dw_1.getitemstring(dw_1.getrow(), "acc2_cd"))

IF sAcc1Cd = "" OR IsNull(sAcc1Cd) OR sAcc2Cd = "" OR IsNull(sAcc2Cd) THEN
	F_MessageChk(1,'[복사할코드]')
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return
END IF

Select Count(*)  
  Into :iCount
  From kfz01om0
 Where acc1_cd = :sAcc1Cd
   And acc2_cd = :sAcc2Cd;

IF iCount > 0 THEN
	Messagebox("확인", "이미 등록된 계정과목입니다")
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return
END IF

SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

Open(W_KFZ01OM0_POPUP1)

IF lstr_account.acc1_cd ="" OR IsNull(lstr_account.acc1_cd) THEN Return

dw_copy.reset()

IF dw_copy.retrieve(Mid(gs_code,1,5), Mid(gs_code,6,2)) <= 0 THEN
	Messagebox("확인", "복사 검색 오류입니다")
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return
END IF

dw_1.setredraw(False)

dw_copy.sharedata(dw_1)

dw_1.setitem(dw_1.getrow(), "acc1_cd", sAcc1Cd)
	dw_1.setitem(dw_1.getrow(), "acc2_cd", sAcc2Cd)

dw_1.setitemstatus(dw_1.getrow(),0,Primary!,NewModified!)

dw_1.setredraw(True)

dw_1.setcolumn("acc1_cd")
dw_1.setfocus()
end event

type dw_copy from datawindow within w_kcda01
boolean visible = false
integer x = 2917
integer y = 2304
integer width = 398
integer height = 332
boolean bringtotop = true
boolean enabled = false
string dataobject = "dw_kcda01_1"
boolean border = false
boolean livescroll = true
end type
