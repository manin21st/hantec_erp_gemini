$PBExportHeader$w_kcda01.srw
$PBExportComments$계정과목 등록
forward
global type w_kcda01 from w_inherite
end type
type cbx_1 from checkbox within w_kcda01
end type
type cbx_2 from checkbox within w_kcda01
end type
type gb_1 from groupbox within w_kcda01
end type
type dw_1 from datawindow within w_kcda01
end type
type dw_list from datawindow within w_kcda01
end type
type rr_1 from roundrectangle within w_kcda01
end type
type pb_1 from picturebutton within w_kcda01
end type
type pb_2 from picturebutton within w_kcda01
end type
type pb_3 from picturebutton within w_kcda01
end type
type pb_4 from picturebutton within w_kcda01
end type
type st_2 from statictext within w_kcda01
end type
type sle_1 from singlelineedit within w_kcda01
end type
type p_copy from uo_picture within w_kcda01
end type
type dw_copy from datawindow within w_kcda01
end type
type rr_2 from roundrectangle within w_kcda01
end type
type ln_1 from line within w_kcda01
end type
end forward

global type w_kcda01 from w_inherite
string title = "계정과목 등록"
cbx_1 cbx_1
cbx_2 cbx_2
gb_1 gb_1
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
st_2 st_2
sle_1 sle_1
p_copy p_copy
dw_copy dw_copy
rr_2 rr_2
ln_1 ln_1
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
end prototypes

public subroutine wf_find_row (string sacc1, string sacc2);Integer iRow

//iRow = dw_list.GetSelectedRow(0)
//if iRow > 0 then Return

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
sRemark4  = dw_1.GetItemString(ll_row,"remark4") 							/*외화관리여부*/

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
	F_MessageChk(1,'[계정관리명]')
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
	F_MessageChk(1,'[차대구분]')
	dw_1.SetColumn("dc_gu")
	dw_1.SetFocus()
	Return -1
END IF

IF sBalGu = "" OR IsNull(sBalGu) THEN
	F_MessageChk(1,'[전표발행구분]')
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
	F_MessageChk(1,'[예산통제구분]')
	dw_1.SetColumn("yesan_gu")
	dw_1.SetFocus()
	Return -1
END IF

IF sAcc2 = '00' AND sAcc1 = sUpAcc THEN				/*세목이 '00'이면 계정과목 <> 상위계정:2001.05.21*/
	F_MessageChk(16,'[계정과목 = 상위계정]')
	dw_1.SetItem(ll_row,"sacc_cd",sNull)
	dw_1.SetColumn("sacc_cd")
	dw_1.SetFocus()
	Return -1
END IF

IF sAcc2 = '00' AND sBalGu <> '4' THEN					/*세목이 '00'이고 '전표발행'이면 상위계정으로 사용 불가:2001.05.21*/
	select Count(*) Into :iCount from kfz01om0 where sacc_cd = :sAcc1;
	
	if sqlca.sqlcode = 0 and iCount <> 0 then
		F_MessageChk(16,'[상위계정으로 존재]')
		dw_1.SetColumn("acc1_cd")
		dw_1.SetFocus()
		Return -1	
	end if
END IF

IF sGbn6 = 'Y' AND sCusGbn <> 'Y' THEN				/*거래처잔고관리 'Y'이면 거래처 체크도 'Y':2001.05.21*/
	F_MessageChk(1,'[거래처체크여부]')
	dw_1.SetColumn("cus_gu")
	dw_1.SetFocus()
	Return -1	
END IF

IF sBalGu <> '4' THEN									/*'전표발행'계정이면 시작,종료는 자기자신:2001.05.21*/
	dw_1.SetItem(ll_row,"fracc1_cd",sAcc1)
	dw_1.SetItem(ll_row,"fracc2_cd",sAcc2)
	dw_1.SetItem(ll_row,"toacc1_cd",sAcc1)
	dw_1.SetItem(ll_row,"toacc2_cd",sAcc2)
END IF

IF iOpenCount > 1 THEN
	F_MessageChk(16,'[보조처리여부 > 1]')
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

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),	  SUBSTR("SYSCNFG"."DATANAME",6,2)		/*부도어음*/
	INTO :sBudoAcc1,								  :sBudoAcc2  
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
		IF Acc1 = sBudoAcc1 AND Acc2 = sBudoAcc2 THEN					/*부도어음*/
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
//		sWinIdD = 'w_kglb01e'
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
IF sRemark4 = 'Y' THEN							/*외화관리='Y'*/
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd;									/*이전자료 삭제*/
	
	insert into kfz01ot0									/*차변-통화단위*/
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'1',			1,					'y_curr',		'통화단위',		'Y',			null,			'1');
		
	insert into kfz01ot0									/*차변-외화금액*/
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'1',			2,					'y_amt',			'외화금액',		'Y',			null,			'0');
		
	insert into kfz01ot0									/*차변-적용환율*/
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'1',			3,					'y_rate',		'적용환율',		'Y',			null,			'0');
		
	insert into kfz01ot0									/*대변-통화단위*/
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'2',			1,					'y_curr',		'통화단위',		'Y',			null,			'1');
		
	insert into kfz01ot0									/*대변-외화금액*/
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'2',			2,					'y_amt',			'외화금액',		'Y',			null,			'0');
		
	insert into kfz01ot0									/*대변-적용환율*/
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		'2',			3,					'y_rate',		'적용환율',		'Y',			null,			'0');
END IF

sDcGbn   = dw_1.GetItemString(dw_1.getrow(),"dc_gu")
sTaxGbn = dw_1.GetItemString(dw_1.getrow(),"taxgbn")			/*영수증관리='Y'*/
IF sTaxGbn = 'Y' THEN
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu = :sDcGbn and 
										(kwan_colid = 'taxgbn' );	
	
	select nvl(Max(seq_no),0)	into :iMaxSeq 
		from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu = :sDcGbn;
		
	if IsNull(iMaxSeq) then iMaxSeq = 0
	iMaxSeq = iMaxSeq + 1
		
	insert into kfz01ot0									/*자기변에 '영수증구분'추가*/
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		:iMaxSeq,		'taxgbn',		'영수증구분',	'Y',			null,			'1');

//	insert into kfz01ot0									/*자기변에 '지급방법'추가*/
//		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
//	values
//		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		:iMaxSeq + 1,	'gyul_method',	'지급방식',		'Y',			null,			'1');
//
//	insert into kfz01ot0									/*자기변에 '건수'추가*/
//		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
//	values
//		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		:iMaxSeq + 2,	'k_qty',			'건수',			'Y',			null,			'0');
//		
else
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu = :sDcGbn and 
										(kwan_colid = 'taxgbn' );		
END IF

sGbn4 = dw_1.GetItemString(dw_1.getrow(),"gbn4")				/*선급비용관리 = 'Y'*/
IF sGbn4 = 'Y' THEN
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd;	
			
	insert into kfz01ot0									/*자기변에 추가*/
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		1,					'k_symd',		'시작일자',		'Y',			null,			'1');

	insert into kfz01ot0									
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		2,					'k_eymd',		'만기일자',		'Y',			null,			'1');

	insert into kfz01ot0									
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		3,					'kwan_no',		'관리번호',		'Y',			'80',			'1');	
END IF

sDcGbn   = dw_1.GetItemString(dw_1.getrow(),"dc_gu")
sGbn1 = dw_1.GetItemString(dw_1.getrow(),"gbn1")				/*인명구분 = '차입금',잔고관리 = 'Y'*/
sChGbn = dw_1.GetItemString(dw_1.getrow(),"ch_gu")
IF sGbn1 = '6' AND sChGbn = 'Y' THEN
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu = '1' and kwan_colid = 'exp_gu';	

	if sDcGbn = '1' then 
		sDcGbn = '2'
	else
		sDcGbn = '1'
	end if
	
	insert into kfz01ot0									/*상대변에 추가*/
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		10,				'exp_gu',		'처리구분',		'Y',			null,			'1');
END IF

sDriveGbn = dw_1.GetItemString(dw_1.getrow(),"drivegbn")
IF sDriveGbn = 'Y' THEN
	delete from kfz01ot0 where acc1_cd = :sAcc1_Cd and acc2_cd = :sAcc2_Cd and dc_gu =:sDcGbn and kwan_colid = 'kwan_no';	

	insert into kfz01ot0									
		(acc1_cd,			acc2_cd,			dc_gu,		seq_no,			kwan_colid,		kwan_colnm,		reqchk,		ref_gbn,		kwan_type)
	values
		(:sAcc1_Cd,			:sAcc2_Cd,		:sDcGbn,		10,				'kwan_no',		'차량번호',			'Y',			'98',			'1');
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

IF Idw_Ary.Retrieve() > 0 THEN								/*기존자료 삭제처리*/
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
					MessageBox('확 인','상위계정의 갯수가 지정한 값(6)을 초과했습니다...')
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

public subroutine wf_setting_retrievemode (string mode);//************************************************************************************//
// **** FUNCTION NAME :WF_SETTING_RETRIEVEMODE(DATAWINDOW 제어)      					  //
//      * ARGUMENT : String mode(수정mode 인지 입력 mode 인지 구분)						  //
//		  * RETURN VALUE : 없슴 																		  //
//************************************************************************************//

dw_1.SetRedraw(False)
p_ins.Enabled =True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"
p_mod.Enabled =True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"
IF mode ="M" THEN							//수정
	dw_1.SetTabOrder("acc1_cd",0)
	dw_1.SetTabOrder("acc2_cd",0)
	
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	p_copy.Enabled = False
	p_copy.PictureName = "C:\erpman\image\복사_d.gif"
	
	cbx_2.Enabled  = True
	
	dw_1.SetColumn("acc1_nm")
ELSEIF mode ="I" THEN					//입력
	dw_1.SetTabOrder("acc1_cd",10)
	dw_1.SetTabOrder("acc2_cd",20)
	
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	p_copy.Enabled = True
	p_copy.PictureName = "C:\erpman\image\복사_up.gif"
	
	cbx_2.Enabled  = False
	
	dw_1.SetColumn("acc1_cd")
END IF
//dw_1.SetFocus()
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

on w_kcda01.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.gb_1=create gb_1
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.st_2=create st_2
this.sle_1=create sle_1
this.p_copy=create p_copy
this.dw_copy=create dw_copy
this.rr_2=create rr_2
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cbx_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.pb_3
this.Control[iCurrent+10]=this.pb_4
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.sle_1
this.Control[iCurrent+13]=this.p_copy
this.Control[iCurrent+14]=this.dw_copy
this.Control[iCurrent+15]=this.rr_2
this.Control[iCurrent+16]=this.ln_1
end on

on w_kcda01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.p_copy)
destroy(this.dw_copy)
destroy(this.rr_2)
destroy(this.ln_1)
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
				//숫자 - 코드
				Case is < 127
             sAnm= ls_string+"%"
				 //MessageBOx('',"문자이외에는 입력할 수 없습니다.")
				//sle_1.text=""
				//return
				
				//문자 - 명칭
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
		      MessageBox('계정과목선택',"선택하신 자료가 없습니다. 다시 선택하신후 작업하세요")  
	     end if	
		   
		 //dw_list.setFocus()
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
boolean visible = false
integer x = 1797
integer y = 2400
integer height = 84
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kcda01
boolean visible = false
integer x = 3561
integer y = 3048
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kcda01
boolean visible = false
integer x = 3387
integer y = 3048
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kcda01
integer x = 3086
integer width = 306
integer taborder = 110
string pointer = "c:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\계정배열조정_up.gif"
end type

event p_search::clicked;call super::clicked;
w_mdi_frame.sle_msg.text ="계정과목 배열 조정 중....."
SetPointer(HourGlass!)
//F_ACCODE_SEQ()
wf_acccode_accross()

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ="계정과목 배열 조정 완료!!"
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\계정배열조정_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\계정배열조정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kcda01
integer x = 3735
integer taborder = 30
string pointer = "C:\erpman\cur\new.cur"
end type

event clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

WF_INIT()

dw_1.SetFocus()

sModStatus ="I"
ib_any_typing=False

WF_SETTING_RETRIEVEMODE(sModStatus)									//입력 MODE
end event

type p_exit from w_inherite`p_exit within w_kcda01
integer x = 4430
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_kcda01
integer x = 4256
integer taborder = 80
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

p_ins.Enabled =True

WF_INIT()

dw_1.SetFocus()
sModStatus ="I"

ib_any_typing=False
WF_SETTING_RETRIEVEMODE(sModStatus)									//입력 MODE

end event

type p_print from w_inherite`p_print within w_kcda01
boolean visible = false
integer x = 3214
integer y = 3044
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kcda01
integer x = 3561
integer taborder = 20
end type

event p_inq::clicked;String ls_strnm1,ls_strnm2,ret_sql1,ret_sql2
long   ll_row,iCount

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText() 

ls_strnm1 =dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
ls_strnm2 =dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")

IF ls_strnm1 = "" OR IsNull(ls_strnm1) THEN
	f_messagechk(1,'[계정과목]')
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return
END IF

IF ls_strnm2 = "" OR IsNull(ls_strnm2) THEN
	f_messagechk(1,'[계정과목]')
	dw_1.SetColumn("acc2_cd")
	dw_1.SetFocus()
	Return
END IF

IF dw_1.Retrieve(ls_strnm1,ls_strnm2) <= 0 THEN
	dw_1.Reset()
	dw_1.InsertRow(0)
	
	f_messagechk(14,"")
	
   dw_1.SetFocus()
	p_ins.Enabled =True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
	
	Return
ELSE
	SELECT COUNT(*)  	INTO :iCount  
    	FROM "KFZ01OT0"  
   	WHERE ( "KFZ01OT0"."ACC1_CD" = :ls_strnm1 ) AND  
      	   ( "KFZ01OT0"."ACC2_CD" = :ls_strnm2 )   ;
	IF SQLCA.SQLCODE = 0 AND iCount > 0 THEN
		cbx_2.Checked = True
	ELSE
		cbx_2.Checked = False
	END IF
END IF
ib_any_typing=False

sModStatus="M"

WF_SETTING_RETRIEVEMODE(sModStatus)								//수정 mode 

p_ins.Enabled =False
p_ins.PictureName = "C:\erpman\image\추가_d.gif"

dw_list.SelectRow(0,False)
dw_list.SelectRow(dw_list.Find("acc1_cd = '"+ls_strnm1 + "' and acc2_cd = '" + ls_strnm2 +"'",1,dw_list.RowCount()),True)
dw_list.ScrollToRow(dw_list.Find("acc1_cd = '"+ls_strnm1 + "' and acc2_cd = '" + ls_strnm2 +"'",1,dw_list.RowCount()))
end event

type p_del from w_inherite`p_del within w_kcda01
integer x = 4082
integer taborder = 70
end type

event p_del::clicked;call super::clicked;string ls_strnm1,ls_strnm2,ret_sql1,ret_sql2
long ll_row, sqlfdl
integer button_num

ll_row = dw_1.GetRow()
ls_strnm1 = dw_1.GetItemString(ll_row,"acc1_cd")
ls_strnm2 = dw_1.GetItemString(ll_row,"acc2_cd")

SELECT COUNT(*)  
    INTO :sqlfdl
    FROM "KFZ10OT0"  
    WHERE ( "KFZ10OT0"."ACC1_CD" = :ls_strnm1 ) AND  
          ( "KFZ10OT0"."ACC2_CD" = :ls_strnm2 )   ;
if SQLCA.SQLCODE <> 100  then
	IF sqlfdl =0 OR IsNull(sqlfdl) THEN
	ELSE
		MessageBox("확인","삭제할 계정과목으로 승인처리된 전표가 존재합니다. &
                        전표삭제후 다시 작업하십시오!")
		wf_setting_retrievemode("M")
		dw_1.SetFocus()
		Return
	END IF
end if

IF f_dbconfirm("삭제") = 2 THEN Return

dw_1.SetRedraw(False)

dw_1.deleterow(0)
IF dw_1.Update() = 1 THEN	
	COMMIT;
	WF_INIT()
	w_mdi_frame.sle_msg.text =" 자료가 삭제되었습니다.!!!"
	p_ins.Enabled =True
	ib_any_typing=False
ELSE
	F_MESSAGECHK(12,"")
	dw_1.SetRedraw(True)
	dw_1.SetFocus()
	ROLLBACK;	
END IF	

sModStatus ="I"

WF_SETTING_RETRIEVEMODE(sModStatus)									//입력 MODE

end event

type p_mod from w_inherite`p_mod within w_kcda01
integer x = 3909
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;
IF dw_1.AcceptText() = -1 THEN RETURN 

IF Wf_RequiredChk(1) = -1 THEN RETURN

IF f_dbconfirm("등록") = 2 THEN RETURN

Wf_Set_OpenWindow(dw_1.GetItemString(dw_1.getrow(),"acc1_cd"),dw_1.GetItemString(dw_1.getrow(),"acc2_cd"))

IF	dw_1.Update() = 1 THEN
	Wf_Control_Kfz01ot1(dw_1.GetItemString(dw_1.getrow(),"acc1_cd"),dw_1.GetItemString(dw_1.getrow(),"acc2_cd"))			/*관리항목 필수 설정*/
	
	COMMIT;
	
	Wf_Find_Row(dw_1.GetItemString(dw_1.getrow(),"acc1_cd"),dw_1.GetItemString(dw_1.getrow(),"acc2_cd"))
	
	w_mdi_frame.sle_msg.text =" 자료가 저장되었습니다.!!!"
	ib_any_typing=False
ELSE
	f_messagechk(13,"")
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	ROLLBACK;	
END IF

sModStatus ="M"
WF_SETTING_RETRIEVEMODE(sModStatus)								//수정 mode
//cb_ins.TriggerEvent(Clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_kcda01
integer x = 3150
integer y = 2300
integer taborder = 90
end type

type cb_mod from w_inherite`cb_mod within w_kcda01
integer x = 2153
integer y = 3076
end type

type cb_ins from w_inherite`cb_ins within w_kcda01
integer x = 1298
integer y = 3076
end type

type cb_del from w_inherite`cb_del within w_kcda01
integer x = 2510
integer y = 3076
end type

type cb_inq from w_inherite`cb_inq within w_kcda01
integer x = 946
integer y = 3076
end type

type cb_print from w_inherite`cb_print within w_kcda01
integer x = 2245
integer y = 2468
end type

type st_1 from w_inherite`st_1 within w_kcda01
end type

type cb_can from w_inherite`cb_can within w_kcda01
integer x = 2866
integer y = 3076
end type

type cb_search from w_inherite`cb_search within w_kcda01
integer x = 1650
integer y = 3080
integer width = 489
string text = "계정배열조정"
end type

type dw_datetime from w_inherite`dw_datetime within w_kcda01
integer x = 2857
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kcda01
integer width = 2482
end type



type gb_button1 from w_inherite`gb_button1 within w_kcda01
integer x = 320
integer y = 2732
end type

type gb_button2 from w_inherite`gb_button2 within w_kcda01
integer x = 1125
integer y = 2724
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
string facename = "굴림체"
long backcolor = 32106727
string text = "계정과목 일괄 수정"
end type

event clicked;open(w_kcda01a)
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
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "관리항목 등록"
end type

event clicked;
cbx_2.Checked = True
IF sModStatus <> 'M' THEN 
	f_messagechk(11,'')
	cbx_2.Checked = False
	Return
END IF

IF dw_1.GetItemString(1,"bal_gu") = '4' THEN
	F_MessageChk(25,'[전표발행 불가]')
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

type gb_1 from groupbox within w_kcda01
integer x = 1554
integer width = 1518
integer height = 184
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
end type

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

event ue_pressenter;IF GETCOLUMNNAME() <> 'ficode' THEN
	Send(Handle(this),256,9,0)
	Return 1
END IF
end event

event ue_key;IF keydown(keyF1!) OR keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sDcGbn,sBalGbn,sCustGbn,sYeSanGbn,sLevel,sAcc1_Code,sAcc2_Code,sAccName,sYeGbn,&
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

//IF this.GetColumnName() = "acc1_nm" THEN											/*2001.05.21*/
//	this.SetItem(1,"acc2_nm",this.GetText())
//END IF

IF this.GetColumnName() ="dc_gu" THEN
	sDcGbn = this.GetText()
	IF sDcGbn = "" OR IsNull(sDcGbn) THEN RETURN
	
	IF sDcGbn <> '1' and sDcGbn <> '2' THEN
		f_messagechk(20,"차대구분")
		dw_1.SetItem(row,"dc_gu",sNullValue)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bal_gu" THEN
	sBalGbn = this.GetText()
	IF sBalGbn = "" OR IsNull(sBalGbn) THEN RETURN
	
	IF Integer(sBalGbn) < 1 OR Integer(sBalGbn) > 4 THEN
		f_messagechk(20,"전표발행구분") 
		dw_1.SetItem(row,"bal_gu",sNullValue)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="gbn1" THEN
	sCustGbn = this.GetText()
	IF sCustGbn = "" OR IsNull(sCustGbn) THEN RETURN
	
	IF IsNull(F_Get_Refferance('CU',sCustGbn)) THEN
		f_messagechk(20,"인명관리구분")
		dw_1.SetItem(row,"gbn1",sNullValue)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="yesan_gu" THEN
	sYeSanGbn = this.GetText()
	IF sYeSanGbn = "" OR IsNull(sYeSanGbn) THEN RETURN
	
	IF sYeSanGbn <> 'Y' AND sYeSanGbn <> 'N' AND sYeSanGbn <> 'A' THEN
		f_messagechk(20,"예산통제구분")
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
		F_Messagechk(20,"예산구분")
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
		f_messagechk(20,"관련계정")
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
		f_messagechk(20,"차변자금관련계정")
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
		f_messagechk(20,"대변자금관련계정")
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
	
//	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
//  		FROM "KFZ01OM0"  
//  		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Code) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Code);
//	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"시작계정")
//		dw_1.SetItem(row,"fracc1_cd",sNullValue)
//		dw_1.SetItem(row,"fracc2_cd",sNullValue)
//		dw_1.SetColumn("fracc1_cd")
//		Return 1
//	END IF
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
	
//	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
//  		FROM "KFZ01OM0"  
//  		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Code) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Code);
//	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"종료계정")
//		dw_1.SetItem(row,"toacc1_cd",sNullValue)
//		dw_1.SetItem(row,"toacc2_cd",sNullValue)
//		dw_1.SetColumn("toacc1_cd")
//		Return 1
//	END IF
END IF


end event

event itemerror;Beep(1)

Return 1
end event

event editchanged;ib_any_typing =True
end event

event rbuttondown;String ls_gj1,ls_gj2,rec_acc1,rec_acc2

SetNull(gs_code)
SetNull(gs_codename)

sle_msg.text =""
dw_1.AcceptText()

//IF this.GetColumnName() = "acc1_cd" OR &
IF	this.GetColumnName() ="fracc1_cd" OR &
		this.GetColumnName() ="toacc1_cd" OR &
			this.GetColumnName() ="kacc1_cd" THEN
	IF this.GetColumnName() = "acc1_cd" OR this.GetColumnName() = "acc2_cd" THEN 
		ls_gj1 = dw_1.GetItemString(dw_1.GetRow(), "acc1_cd")
		ls_gj2 = dw_1.GetItemString(dw_1.GetRow(), "acc2_cd")	
	ELSEIF this.GetColumnName() ="fracc1_cd" OR this.GetColumnName() = "fracc2_cd" THEN
		ls_gj1 = dw_1.GetItemString(dw_1.GetRow(), "fracc1_cd")
		ls_gj2 = dw_1.GetItemString(dw_1.GetRow(), "fracc2_cd")	
	ELSEIF this.GetColumnName() ="toacc1_cd" OR this.GetColumnName() = "toacc2_cd" THEN
		ls_gj1 = dw_1.GetItemString(dw_1.GetRow(), "toacc1_cd")
		ls_gj2 = dw_1.GetItemString(dw_1.GetRow(), "toacc2_cd")	
	ELSEIF this.GetColumnName() ="kacc1_cd" OR this.GetColumnName() ="kacc2_cd" THEN
		ls_gj1 = dw_1.GetItemString(dw_1.GetRow(), "kacc1_cd")
		ls_gj2 = dw_1.GetItemString(dw_1.GetRow(), "kacc2_cd")	
	END IF

	IF IsNull(ls_gj1) then
		ls_gj1 = ""
	end if
	IF IsNull(ls_gj2) then
		ls_gj2 = ""
	end if
	
	lstr_account.acc1_cd = Trim(ls_gj1)
	lstr_account.acc2_cd = Trim(ls_gj2)
	
	Open(W_KFZ01OM0_POPUP1)
	
//	IF this.GetColumnName() = "acc1_cd" OR this.GetColumnName() = "acc2_cd" OR this.GetColumnName() = "acc1_nm" OR this.GetColumnName() = "acc2_nm" THEN 
//		
//		dw_1.SetItem(dw_1.GetRow(), "acc1_cd", lstr_account.acc1_cd)
//		dw_1.SetItem(dw_1.GetRow(), "acc2_cd", lstr_account.acc2_cd)
//		dw_1.SetItem(dw_1.GetRow(), "acc1_nm", lstr_account.acc1_nm)
//		dw_1.SetItem(dw_1.GetRow(), "acc2_nm", lstr_account.acc2_nm)
//	
//		IF Not IsNull(lstr_account.acc1_cd) AND Not IsNull(lstr_account.acc2_cd) THEN
//			sModStatus = "M"
//			this.Triggerevent(ItemChanged!)
//		ELSE
//			sModStatus = "I"
//			
//			WF_INIT()
//			dw_1.SetColumn("acc1_cd")
//			dw_1.SetFocus()
//		END IF
//		WF_SETTING_RETRIEVEMODE(sModStatus)
//		cb_ins.Enabled =False
	IF this.GetColumnName() ="fracc1_cd" OR this.GetColumnName() = "fracc2_cd" THEN
		dw_1.SetItem(dw_1.GetRow(), "fracc1_cd", lstr_account.acc1_cd)
		dw_1.SetItem(dw_1.GetRow(), "fracc2_cd", lstr_account.acc2_cd)
		dw_1.SetColumn("fracc1_cd")
	ELSEIF this.GetColumnName() ="toacc1_cd" OR this.GetColumnName() = "toacc2_cd" THEN
		dw_1.SetItem(dw_1.GetRow(), "toacc1_cd", lstr_account.acc1_cd)
		dw_1.SetItem(dw_1.GetRow(), "toacc2_cd", lstr_account.acc2_cd)
		dw_1.SetColumn("toacc1_cd")
	ELSEIF this.GetColumnName() ="kacc1_cd" OR this.GetColumnName() ="kacc2_cd" THEN
		dw_1.SetItem(dw_1.GetRow(), "kacc1_cd", lstr_account.acc1_cd)
		dw_1.SetItem(dw_1.GetRow(), "kacc2_cd", lstr_account.acc2_cd)
		dw_1.SetColumn("kacc1_cd")
	END IF
END IF

IF this.GetColumnName() = "fin_cd" THEN 
	Open(W_Kfm10om0_Popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	dw_1.SetItem(dw_1.GetRow(), "fin_cd", gs_code)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF this.GetColumnName() = "ficode" THEN 
	Open(W_Kfm10om0_Popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	dw_1.SetItem(dw_1.GetRow(), "ficode", gs_code)
	this.TriggerEvent(ItemChanged!)
	Return
END IF
	
dw_1.SetFocus()
end event

event itemfocuschanged;
Long wnd

wnd =Handle(this)

IF dwo.name ="acc1_nm" OR dwo.name ="acc2_nm" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event getfocus;this.AcceptText()
end event

type dw_list from datawindow within w_kcda01
integer x = 55
integer y = 212
integer width = 1221
integer height = 2020
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dw_kcda01_4"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;
if row <=0 then Return

this.SelectRow(0,False)
this.SelectRow(Row,True)
This.ScrollTorow(row)
//
//dw_1.SetItem(row,"acc1_cd", this.GetItemString(row,"acc1_cd"))
//dw_1.SetItem(row,"acc2_cd", this.GetItemString(row,"acc2_cd"))
//
//p_inq.TriggerEvent(Clicked!)
end event

event rowfocuschanged;long iCount
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

        WF_SETTING_RETRIEVEMODE(sModStatus)								//수정 mode 

			p_ins.Enabled =False
			p_ins.PictureName = "C:\erpman\image\추가_d.gif"


end if



end event

type rr_1 from roundrectangle within w_kcda01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 204
integer width = 1248
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

type pb_1 from picturebutton within w_kcda01
boolean visible = false
integer x = 1125
integer y = 56
integer width = 82
integer height = 72
integer taborder = 120
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\FIRST.gif"
alignment htextalign = left!
end type

event clicked;String sAcc1,sAcc2,sGetAccCode

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sAcc1 = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sAcc2 = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")

SELECT MIN("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0" ;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) OR sGetAccCode = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	IF sAcc1 + sAcc2 = sGetAccCode THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_1.SetItem(dw_1.GetRow(),"acc1_cd",Left(sGetAccCode,5))
	dw_1.SetItem(dw_1.GetRow(),"acc2_cd",Mid(sGetAccCode,6,2))
	
	p_inq.TriggerEvent(Clicked!)
END IF
	
end event

type pb_2 from picturebutton within w_kcda01
boolean visible = false
integer x = 1216
integer y = 56
integer width = 82
integer height = 72
integer taborder = 130
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\prior.gif"
alignment htextalign = left!
end type

event clicked;String sAcc1,sAcc2,sGetAccCode,sAcc

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sAcc1 = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sAcc2 = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")

sAcc = sAcc1 + sAcc2
SELECT MAX("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0"
	WHERE "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" < :sAcc;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_1.SetItem(dw_1.GetRow(),"acc1_cd",Left(sGetAccCode,5))
	dw_1.SetItem(dw_1.GetRow(),"acc2_cd",Mid(sGetAccCode,6,2))
	
	p_inq.TriggerEvent(Clicked!)
END IF
	
end event

type pb_3 from picturebutton within w_kcda01
boolean visible = false
integer x = 1307
integer y = 56
integer width = 82
integer height = 72
integer taborder = 140
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\next.gif"
alignment htextalign = left!
end type

event clicked;String sAcc1,sAcc2,sGetAccCode,sAcc

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sAcc1 = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sAcc2 = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
sAcc = sAcc1 + sAcc2

SELECT MIN("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0"
	WHERE "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" > :sAcc;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_1.SetItem(dw_1.GetRow(),"acc1_cd",Left(sGetAccCode,5))
	dw_1.SetItem(dw_1.GetRow(),"acc2_cd",Mid(sGetAccCode,6,2))
	
	p_inq.TriggerEvent(Clicked!)
END IF
	
end event

type pb_4 from picturebutton within w_kcda01
boolean visible = false
integer x = 1399
integer y = 56
integer width = 82
integer height = 72
integer taborder = 150
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\last.gif"
alignment htextalign = left!
end type

event clicked;String sAcc1,sAcc2,sGetAccCode

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sAcc1 = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sAcc2 = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")

SELECT MAX("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0" ;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) OR sGetAccCode = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	IF sAcc1 + sAcc2 = sGetAccCode THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_1.SetItem(dw_1.GetRow(),"acc1_cd",Left(sGetAccCode,5))
	dw_1.SetItem(dw_1.GetRow(),"acc2_cd",Mid(sGetAccCode,6,2))
	
	p_inq.TriggerEvent(Clicked!)
END IF
	
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
string facename = "굴림체"
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
string facename = "굴림체"
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

event clicked;call super::clicked;Integer iCount
String sAcc1Cd, sAcc2Cd

dw_1.accepttext()

sAcc1Cd = Trim(dw_1.getitemstring(dw_1.getrow(), "acc1_cd"))
sAcc2Cd = Trim(dw_1.getitemstring(dw_1.getrow(), "acc2_cd"))

IF sAcc1Cd = "" OR IsNull(sAcc1Cd) OR sAcc2Cd = "" OR IsNull(sAcc2Cd) THEN
	F_MessageChk(1,'[계정코드]')
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
	Messagebox("확인", "계정 검색 오류입니다")
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return
END IF

dw_1.setredraw(False)

//dw_1.insertrow(0)

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
string title = "none"
string dataobject = "dw_kcda01_1"
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within w_kcda01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 36
integer width = 901
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kcda01
integer linethickness = 1
integer beginx = 361
integer beginy = 152
integer endx = 914
integer endy = 152
end type

