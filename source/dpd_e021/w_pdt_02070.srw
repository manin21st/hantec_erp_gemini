$PBExportHeader$w_pdt_02070.srw
$PBExportComments$자재소진내역 수정(역산법)
forward
global type w_pdt_02070 from w_inherite
end type
type dw_head from u_key_enter within w_pdt_02070
end type
type dw_hold from u_key_enter within w_pdt_02070
end type
type pb_1 from u_pb_cal within w_pdt_02070
end type
type pb_2 from u_pb_cal within w_pdt_02070
end type
type dw_momast from datawindow within w_pdt_02070
end type
type st_2 from statictext within w_pdt_02070
end type
type cbx_1 from checkbox within w_pdt_02070
end type
type dw_jaje from datawindow within w_pdt_02070
end type
type dw_ban from datawindow within w_pdt_02070
end type
type cbx_2 from checkbox within w_pdt_02070
end type
type st_3 from statictext within w_pdt_02070
end type
type dw_waiju from datawindow within w_pdt_02070
end type
type st_4 from statictext within w_pdt_02070
end type
type rr_1 from roundrectangle within w_pdt_02070
end type
type rr_2 from roundrectangle within w_pdt_02070
end type
end forward

global type w_pdt_02070 from w_inherite
integer height = 2840
string title = "자재소진내역 수정"
dw_head dw_head
dw_hold dw_hold
pb_1 pb_1
pb_2 pb_2
dw_momast dw_momast
st_2 st_2
cbx_1 cbx_1
dw_jaje dw_jaje
dw_ban dw_ban
cbx_2 cbx_2
st_3 st_3
dw_waiju dw_waiju
st_4 st_4
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02070 w_pdt_02070

type variables
String is_sysno='', ispordno, isholdno
String isgub='1'	// 1:생산실적,2:외주불출
end variables

forward prototypes
public function string wf_depotno (string oversea_gu, string sjumaechul)
public function integer wf_create_waiju ()
end prototypes

public function string wf_depotno (string oversea_gu, string sjumaechul);string  sSaupj, sdepotNo, sPdtgu

If	IsNull(oversea_gu) Or oversea_gu = '' Then Return ''

sSaupj 	= gs_saupj
sPdtgu	= dw_head.GetItemString(1, 'pdtgu')

if	sSaupj	=  '%'	then
	sSaupj	=  gs_saupj
End If 

If	isnull(sJumaechul) or sJumaechul = "" then
	select min(cvcod )
	  into :sDepotNo
	  from vndmst
	 where cvgu = '5' and
			 juprod = :oversea_gu and                               // 1:  완제품 , 2: 반제품, 3:원자재
			 ipjogun = :sSaupj ;
else	
	select min(cvcod )
	  into :sDepotNo
	  from vndmst
	 where cvgu = '5' and
			 juprod       = :oversea_gu and                        // 1:  완제품 , 2: 반제품, 3:원자재
			 jumaechul 	  = :sJumaechul and                        // 1: 생산, 2:일반
			 jumaeip      = :sPdtgu and                            // 생산팀
			 ipjogun      = :sSaupj;
End if	

If IsNull(sDepotNo) Then 
	f_message_chk(1400,'[창고]')
	sDepotNo = ''
End If

Return sDepotNo

end function

public function integer wf_create_waiju ();Int iok, inot, ierr, ix, iy, ll_row
String sBaljpno, sBaldate, ls_Jpno, sError,sjpno, sItnbr
Dec    dBalseq, ld_Seq
DataStore ds_bom, ds_imhist

/* 대상내역만 선택한다*/
w_mdi_frame.sle_msg.text = '대상내역을 선택중입니다....!!'

dw_insert.SetFilter("chk_flag = 'Y'")
dw_insert.Filter()
dw_insert.RowsDiscard(1, dw_insert.FilteredCount(), Filter!)

// 전체 내역을 조회함.
dw_hold.SetFilter('')
dw_hold.Filter()

ds_bom   = create datastore
ds_imhist = create datastore
ds_bom.DataObject = 'd_pu01_00010_b'
ds_imhist.DataObject = 'd_pdt_imhist'
ds_bom.SetTransObject(sqlca)
ds_imhist.SetTransObject(sqlca)

For ix = 1 To dw_insert.RowCount()
	sBaljpno = dw_insert.GetItemString(ix, 'poblkt_baljpno')
	dBalseq  = dw_insert.GetItemNumber(ix, 'poblkt_balseq')
	sBaldate = dw_insert.GetItemString(ix, 'pomast_baldate')
	sItnbr   = dw_insert.GetItemString(ix, 'poblkt_itnbr')
	
	// 소재불출내역 생성
	DECLARE erp_create_pstruc_to_soje PROCEDURE FOR erp_create_pstruc_to_soje(:sitnbr);
	EXECUTE erp_create_pstruc_to_soje;
	
	// 차이내역이 없을 경우 skip
	dw_hold.Retrieve(gs_sabu, sBaljpno, dBalseq)
	If dw_hold.RowCount() <= 0 Then 
		inot++
		dw_insert.SetItem(ix, 'status', 'N')
		Continue
	End If

	If dw_hold.GetItemNumber(1, 'sum_sts') <= 0 Then
		inot++
		dw_insert.SetItem(ix, 'status', 'N')
		Continue
	End If
	
	// 입고내역 조회
	dw_waiju.Retrieve(gs_sabu, sBaljpno, dBalseq)
	
	// 외주사급출고 전표번호 생성
	ld_Seq = SQLCA.FUN_JUNPYO(gs_sabu, sBaldate, 'C0')			
	If ld_Seq < 0	Then	
		Rollback;
		RETURN -1
	End If			
	COMMIT;
	ls_Jpno  = sBaldate + String(ld_Seq, "0000")
	
	// 기존 외주사급출고내역 내역 삭제
	delete from imhist where sabu = :gs_sabu and baljpno = :sBaljpno and balseq = :dBalseq and iogbn = 'O06';
	If sqlca.sqlcode <> 0 Then
		dw_insert.SetItem(ix, 'status', 'X')
		ierr++
		rollback;
		Continue
	End If
		
	// 추가내역 삽입
	ll_row=0
	For iy = 1 To dw_hold.RowCount()
		// 삭제된 내역은 반영하지 않는다
		If dw_hold.GetItemNumber(iy, 'sts') > 0 Then Continue
		
		////////////////////////////////////////////////////////////////////////////////
		// ** 출고 HISTORY 생성 **
		////////////////////////////////////////////////////////////////////////////////
		ll_row = ds_imhist.InsertRow(0)

		ds_imhist.Object.sabu[ll_row]	   	=	gs_sabu
		ds_imhist.Object.jnpcrt[ll_row]	   = '002'			                           // 전표생성구분
		ds_imhist.Object.inpcnf[ll_row]    	= 'O'				                           // 입출고구분
		ds_imhist.Object.iojpno[ll_row] 		= ls_Jpno + String(ll_row, "000") 
		ds_imhist.Object.iogbn[ll_row]     	= 'O06'   											// 수불구분=요청구분
		ds_imhist.Object.sudat[ll_row]	   = sBaldate			                        // 수불일자=출고일자
		ds_imhist.Object.itnbr[ll_row]	   = dw_hold.GetItemString(iy, 'itnbr')      // 품번
		ds_imhist.Object.pspec[ll_row]	   = '.'										         // 사양
		ds_imhist.Object.depot_no[ll_row]  	= dw_insert.GetItemString(ix, 'poblkt_ipdpt')   // 기준창고=출고창고
		ds_imhist.Object.cvcod[ll_row]	   = dw_insert.GetItemString(ix, 'pomast_cvcod')   // 거래처창고=입고처
		ds_imhist.Object.ioqty[ll_row]	   = dw_hold.GetItemNumber(iy, 'hold2')      // 수불수량=출고수량
		ds_imhist.Object.ioreqty[ll_row]		= dw_hold.GetItemNumber(iy, 'hold2')      // 수불의뢰수량=출고수량		
		ds_imhist.Object.insdat[ll_row]	   = sBaldate			                        // 검사일자=출고일자	
		ds_imhist.Object.iosuqty[ll_row]		= dw_hold.GetItemNumber(iy, 'hold2')      // 합격수량=출고수량		
		ds_imhist.Object.opseq[ll_row]	   = '9999'                                	// 공정코드
		ds_imhist.Object.ip_jpno[ll_row]   	= ''			 	                           // 할당번호
		ds_imhist.Object.filsk[ll_row]     	= 'Y'												   // 재고관리유무
		ds_imhist.Object.botimh[ll_row]	   = 'N'                         				// 동시출고여부
		ds_imhist.Object.ioredept[ll_row]  	= gs_dept      									// 수불의뢰부서=할당.부서
		ds_imhist.Object.io_confirm[ll_row]	= 'Y'		                              	// 수불승인여부
		ds_imhist.Object.io_date[ll_row]		= sBaldate			                        // 수불승인일자=출고일자	
		ds_imhist.Object.io_empno[ll_row]  	= gs_empno			                        // 수불승인자=담당자	
		ds_imhist.Object.outchk[ll_row]    	= 'Y'                              			// 출고의뢰완료
		ds_imhist.Object.baljpno[ll_row]   	= sBaljpno
		ds_imhist.Object.balseq[ll_row]    	= dBalseq
		ds_imhist.Object.bigo[ll_row]    	= "외주불출에 의한 생산부품출고"
	Next

	// 입고내역을 기준으로 외주자동출고내역을 삭제후 재생성한다.
	For iy = 1 To dw_waiju.RowCount()
		sError = 'X';
		sjpno = Left(dw_waiju.GetItemString(iy, 'iojpno'),12)
		
		sqlca.erp000000360(gs_sabu, sjpno, 'D', sError);
		if sError = 'X' or sError = 'Y' then
			rollback;
			exit
		end if
		sError = 'X';
		sqlca.erp000000360(gs_sabu, sjpno, 'I', sError);
		if sError = 'X' or sError = 'Y' then
			rollback;
			exit
		end if
	Next
	if sError = 'X' or sError = 'Y' then
		dw_insert.SetItem(ix, 'status', 'X')
		ierr++
		Continue
	end if
	
	if ds_imhist.update() <> 1 then
		MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
		Dw_insert.SetItem(ix, 'status', 'X')
		ierr++
		rollback ;
	else
		commit;
		dw_insert.SetItem(ix, 'status', 'Y')
		iok++
	end if

	w_mdi_frame.sle_msg.text = string(ix)+'/'+string(dw_insert.rowcount()) + ' 처리완료!!'
Next

MessageBox('확인','처  리 : '+string(iok) + '~r~n미처리 : '+string(inot)+ '~r~n오  류 : '+string(ierr))

destroy ds_bom
destroy ds_imhist

Return 1
end function

on w_pdt_02070.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.dw_hold=create dw_hold
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_momast=create dw_momast
this.st_2=create st_2
this.cbx_1=create cbx_1
this.dw_jaje=create dw_jaje
this.dw_ban=create dw_ban
this.cbx_2=create cbx_2
this.st_3=create st_3
this.dw_waiju=create dw_waiju
this.st_4=create st_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.dw_hold
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.dw_momast
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.dw_jaje
this.Control[iCurrent+9]=this.dw_ban
this.Control[iCurrent+10]=this.cbx_2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.dw_waiju
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.rr_1
this.Control[iCurrent+15]=this.rr_2
end on

on w_pdt_02070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.dw_hold)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_momast)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.dw_jaje)
destroy(this.dw_ban)
destroy(this.cbx_2)
destroy(this.st_3)
destroy(this.dw_waiju)
destroy(this.st_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_head.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_hold.SetTransObject(sqlca)
dw_momast.SetTransObject(sqlca)
dw_jaje.SetTransObject(sqlca)
dw_ban.SetTransObject(sqlca)
dw_waiju.SetTransObject(sqlca)

dw_head.InsertRow(0)
dw_jaje.InsertRow(0)
dw_ban.InsertRow(0)

dw_head.SetItem(1,'frdate',Left(f_today(),6) + '01')
dw_head.SetItem(1,'todate',f_today())

f_child_saupj(dw_head,'pdtgu', gs_saupj)
String  ls_pdtgu
SELECT RFGUB INTO :ls_pdtgu FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFNA2 = :gs_saupj ;
dw_head.SetItem(1,'pdtgu', ls_pdtgu)

String sCode

/* 반제품 창고 검색 */
//sCode 	= wf_DepotNo('2', '2')	// 반제품창고를 둘경우
sCode 	= wf_DepotNo('2', '1')	// 반제품을 생산창고로 잡을경우
dw_ban.setitem(1, "ban_code", sCode)

/* 자제 창고 검색 */
//sCode 	= wf_DepotNo('3', '')	// 자재창고에서 출고요청할경우
sCode 	= wf_DepotNo('2', '1')	// 자재창고가 없이 자재가 생산창고로 입고될 경우
dw_jaje.setitem(1, "jaje_code", sCode)

dw_head.SetColumn('pordno')
dw_head.SetFocus()
end event

event closequery;call super::closequery;String sError

IF is_sysno > '' then
	if Messagebox("자재소진내역 수정", "작업중입니다" + '~n' + &
									  "취소하시겠읍니까?", question!, yesno!) = 1 then
	
		/* 할당내역을 삭제 */
		Delete From holdstock_copy 			Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';

		/* 지시내역을 삭제 */
		Delete From momast_copy 				Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';

		/* 공정내역을 삭제 */
		Delete From morout_copy 				Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';

		/* 반제품 소요수량 삭제 */
		Delete From momast_copy_lotsim 		Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';

	   COMMIT;

	Else	
		return 1
	End if
end if
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02070
integer x = 50
integer y = 292
integer width = 4494
integer height = 940
string dataobject = "d_pdt_02070_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
	Return
End If

/* 생산실적 수정인 경우 */
If isGub = '1' Then
	dw_hold.Retrieve(gs_sabu, GetItemString(row, 'momast_pordno'), is_sysno)
	dw_head.SetItem(1, 'itnbr', GetItemString(row, 'momast_itnbr'))
	
	datawindowchild dwc
	dw_hold.getchild("opseq", dwc)
	dwc.settransobject(sqlca)
	IF dwc.retrieve(gs_sabu, GetItemString(row, 'momast_pordno')) < 1 THEN 
		dwc.insertrow(0)
	END IF
Else
	dw_hold.Retrieve(gs_sabu, GetItemString(row, 'poblkt_baljpno'), GetItemNumber(row, 'poblkt_balseq'))
	
	dw_head.SetItem(1, 'itnbr', GetItemString(row, 'poblkt_itnbr'))
End If
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02070
boolean visible = false
integer y = 168
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02070
boolean visible = false
integer y = 168
end type

type p_search from w_inherite`p_search within w_pdt_02070
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_pdt_02070
integer x = 3922
string picturename = "C:\erpman\image\계산_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\계산_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\계산_up.gif"
end event

event p_ins::clicked;call super::clicked;String  swanch, sbanch, stoday, ntoday, schk, sgubun, ls_saupj, sitnbr, spdtgu, sitgu, sittyp, snapgi, sban, sjaje
String  sitcls, sporgu, srtnbr, scvcod, stuncu, sordgbn, ls_pspec, scvnas, sjasacode, sMasterNo, sPordno
String  sjdate, ssdate, sedate, serror
Integer ii, nn, k, ireturn
Long    lrow, lopt, Linsrow, ij
Dec{3}  dpdqty, doptqty, dmod
Dec{5}  dpdprc, dunprc

If dw_head.AcceptTExt() <> 1 Then Return -1
If dw_insert.AcceptTExt() <> 1 Then Return -1

/* -------------------------------------------------------------------------------------------------------------- */
/*  기존작업지시 내역을 MOROUT_COPY, MOMAST_COPY로 복사한다                                                       */
/* -------------------------------------------------------------------------------------------------------------- */

// 기초정보 체크
sPdtgu = dw_head.getitemstring(1, "pdtgu")
If isnull(sPdtgu) or Trim(sPdtgu) = '' then
	f_message_chk(309, '[생산팀구분]')
	return -1
end if

/* 대상내역만 선택한다*/
w_mdi_frame.sle_msg.text = '대상내역을 선택중입니다....!!'

dw_insert.SetFilter("chk_flag = 'Y'")
dw_insert.Filter()
dw_insert.RowsDiscard(1, dw_insert.FilteredCount(), Filter!)

/* 생산실적 수정인 경우 */
If isGub = '1' Then
	lopt = dw_insert.RowCount()
	For Lrow = lOpt to 1 Step -1
		sChk     = dw_insert.getitemstring(Lrow, "chk_flag")
		If schk = 'N' then 
			dw_insert.RowsDiscard(Lrow, Lrow, Primary!)
		Else
			sPordno = dw_insert.GetItemString(lRow, 'momast_pordno')
			
			/* 기존 지시내역을 삭제 */
			Delete From momast_copy	Where sabu = :gs_sabu and pordno = :sPordno;
			Delete From morout_copy	Where sabu = :gs_sabu and pordno = :sPordno;
		End If
	Next
	
	commit;
	
	dw_insert.SetFilter("")
	dw_insert.Filter()
	
	If dw_insert.RowCount() <= 0 Then
		MessageBox('확인','작업대상이 없습니다.!!')
		Return
	End If
	
	SetPointer(HourGlass!)
	
	/* 창고는 완제품, 반제품인 경우 첫번째 창고를 선택한다 */
	ls_saupj	= gs_saupj
	Select Min(cvcod) Into :sWanch from Vndmst where cvgu = '5' and juprod = '1' and ipjogun = :ls_saupj;
	Select Min(cvcod) Into :sBanch from Vndmst where cvgu = '5' and juprod = '2' and jumaeip = :spdtgu and ipjogun = :ls_saupj;
	
	/* 작업지시번호 채번(Visual) */
	stoday = f_today()
	
	// 마스타작지번호를 입력한 경우에는 기존내역을 조회한다
	If IsNull(sMasterNo) Or sMasterNo = '' Then
		// 화면상에 보이는 작업지시번호 채번
		ii = sqlca.fun_junpyo(gs_sabu, stoday, 'N0')
		if ii < 1 then
			f_message_chk(51,'[작업지시번호]') 
			rollback;
			return -1
		end if
		Commit;
		ispordno = stoday + String(ii, '0000')		// 신규추가용 품목별 작업지시번호
	
		// 작업지시 기준번호 채번(모든 계산단위는 작업지시 기준번호를 기준으로 한다)
		ntoday = f_today()
		Nn = sqlca.fun_junpyo(gs_sabu, nToday, 'N3')
		if Nn < 1 then
			f_message_chk(51,'[작업지시 기준번호]') 
			rollback;
			return -1
		end if
		
		is_sysno = nToday + String(Nn, '0000')		// master_no임
	Else
		is_sysno = sMasterNo
		ispordno = sMasterNo
	End If
	
	/* 자료 저장용 datawindow clear */
	dw_momast.reset()
		 
	/* 개별 품목으로 작업지시 하는 경우 */
	For Lrow = 1 to dw_insert.rowcount()
		 sChk     = dw_insert.getitemstring(Lrow, "chk_flag")
		 if schk = 'N' then continue
		 
		 sGubun	 = '9'	// 계획구분(1:월,7:샘플, 9:기존작업지시)
		 
		 dPdqty	 = dw_insert.getitemdecimal(Lrow, "momast_pdqty") 	//지시수
	
		 sItnbr = dw_insert.getitemstring(Lrow, "momast_itnbr")
	
		 /* 품목마스터의 구입/생산형태를 기준으로 작성 */
		 Setnull(sItgu)
		 Setnull(sIttyp)
		 Setnull(sItcls)
		 Setnull(sporgu)
		 
		 Select a.itgu, a.ittyp, a.itcls, nvl(a.stdnbr,a.itnbr)   Into :sItgu, :sIttyp, :sitcls, :sRtnbr
			From itemas a	  Where a.itnbr = :sItnbr ;
	
		 /* 주간계획에서 읽어올 경우 가상작지로 셋팅 */
		 sporgu = '12'	
	
			 
		 dPdprc  =	sqlca.fun_erp100000012(stoday, sitnbr, '.')		
			 
		 /* 작업지시를 임시로 생성 */
		 Linsrow = dw_momast.insertrow(0)
		 dw_momast.setitem(Linsrow, "momast_copy_sabu",   gs_sabu)
		 dw_momast.setitem(Linsrow, "momast_copy_jidat",  dw_insert.getitemstring(lrow, "momast_jidat"))
		 
		 dw_momast.setitem(Linsrow, "momast_copy_itnbr",  sItnbr)
		 dw_momast.setitem(Linsrow, "momast_copy_pspec",  '.')	// 기본사양을 저장
		 
		 dw_momast.setitem(Linsrow, "momast_copy_pdtgu",  sPdtgu )
		 dw_momast.setitem(Linsrow, "momast_copy_pdqty",  dPdqty)
		 dw_momast.setitem(Linsrow, "momast_copy_pdmqty", dPdqty)
	
		 dw_momast.setitem(Linsrow, "momast_copy_pdsts",  '1')
		 dw_momast.setitem(Linsrow, "momast_copy_matchk", '2')
		 dw_momast.setitem(Linsrow, "momast_copy_stditnbr", sRtnbr)
	
		 //품목분류 대분류에 의해 작업지시구분을 선택
		 dw_momast.setitem(Linsrow, "momast_copy_porgu", sPorgu)
	
	//	 If sItgu = '6' then		// 외주인 경우 
	//		 dw_momast.setitem(Linsrow, "momast_copy_purgc",  'Y')	
	//	 Else
	//		 dw_momast.setitem(Linsrow, "momast_copy_purgc",  'N')
	//	 End if
		 dw_momast.setitem(Linsrow, "momast_copy_purgc",  dw_insert.getitemstring(lrow, "momast_purgc"))
		  
		 If sIttyp = '1' Or sIttyp = '8' then
			 dw_momast.Setitem(Linsrow, "momast_copy_ipchango", sWanch)
		 Else
			 dw_momast.Setitem(Linsrow, "momast_copy_ipchango", sBanch)
		 End if
		 
		 /* 생산실적 작성용 단가 산출 */
		 dw_momast.setitem(Linsrow, "momast_copy_pdprc", dPdprc)
		 
		 /* 구분이 주간계획인 경우에는 작지번호는 기존 작지번호를 사용한다 (가상임)*/
		 if sGubun = '9' then
			sPordno = dw_insert.getitemstring(Lrow, "momast_pordno")
			dw_momast.setitem(Linsrow, "momast_copy_pordno",  sPordno)
			dw_momast.setitem(Linsrow, "momast_copy_mogubn",  '9') // 작업지시 구분 : 주간계획
			dw_momast.setitem(Linsrow, "momast_copy_holdct",  dw_insert.getitemstring(Lrow, "momast_holdct"))	// 할당계산여부
		 End if	
		 
		/* 작업시작일자는 주간계획 기준일자로 작성 */
		dw_momast.setitem(Linsrow, "momast_copy_esdat",  dw_insert.getitemstring(Lrow, "momast_jidat"))
		
		/* 작업지시 기준번호 작성 */
		dw_momast.setitem(Linsrow, "momast_copy_master_no", is_sysno)
		dw_momast.setitem(Linsrow, "momast_copy_mocnt",  String(Linsrow, '00'))
		
		// 공정내역을 복사한다
		Insert into morout_copy
			(sabu,		pordno,		itnbr,		pspec,		opseq,		de_opseq,			mchcod,
			 wkctr,		jocod,		purgc,		uptgu,		esdat,		eedat,				estim,
			 esinw,		rstim,		tsinw,		ntime,		lastc,		fsdat,				fedat,
			 roqty,		faqty,		suqty,		peqty,		coqty,		paqty,				nedat,
			 ladat,		wicvcod,		wiunprc,		pr_opseq,	do_opseq,	system_end_date,	bajpno,
			 rmks,		watims,		sttim,		esset,		esman,		esmch,				esgbn,
			 rsset,		rsman,		rsmch,		qcgub,		opdsc,		roslt,				system_str_date,	qcgin,  stdmn,
			 master_no, fstim,      fetim,      pdqty)
		 Select
			 sabu,		pordno,		itnbr,		pspec,		opseq,		de_opseq,			mchcod,
			 wkctr,		jocod,		purgc,		uptgu,		null,			null,					estim,
			 esinw,		rstim,		tsinw,		ntime,		lastc,		fsdat,				fedat,
			 roqty,		faqty,		suqty,		peqty,		coqty,		paqty,				nedat,
			 ladat,		wicvcod,		wiunprc,		pr_opseq,	do_opseq,	system_end_date,	bajpno,
			 rmks,		watims,		sttim,		esset,		esman,		esmch,				esgbn,
			 rsset,		rsman,		rsmch,		qcgub,		opdsc,		roslt,				system_str_date,	qcgin,  stdmn,
			 :is_sysno, fstim,      fetim,      :dpdqty
			From Morout
		  Where sabu = :gs_sabu and pordno = :sPordno;
		If SQLCA.SQLCODE <> 0 Then
			MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
			RollBack;
			REturn
		End If
	Next
	
	if dw_momast.update() =  1 then
		commit;
	Else
		Rollback;
		messagebox("작지","작지작성시 Error(wf_requiredchk_tabpage)")	
		return -1
	end if
	
	// 재할당 처리한다
	/* 작업지시에 대한 할당을 작성 - 단 할당생성을 check한 경우 */
	w_mdi_frame.sle_msg.text = '할당내역을 적상중입니다....!!'
	
	sBan		=	dw_ban.getitemstring(1, "ban_code")
	sJaje		=	dw_jaje.getitemstring(1, "jaje_code")
	
	For Lrow = 1 to dw_momast.rowcount()
		
		 sPordno = dw_momast.getitemstring(Lrow, "momast_copy_pordno")
		 sjdate  = dw_momast.getitemstring(Lrow, "momast_copy_jidat")
		 
		 /* 할당내역 생성이 아니면 BOM을 검색안 함 */
		 if dw_momast.getitemstring(Lrow, "momast_copy_holdct") = 'N' then continue;
	
		/* 할당번호 채번 */
		iJ = sqlca.fun_junpyo(gs_sabu, sjdate, 'B0')
		if iJ < 1 then
			rollback;
			f_message_chk(51,'[할당번호]') 
			return -1
		end if
		
		/* 할당번호작성(12자리 기준) */
		isholdno = sjdate + String(iJ, '0000')	
		Commit;
	
		sError = 'X'
		sqlca.erp000000840(gs_sabu, spordno, isholdno, sError);
	
		Choose Case sError
				 Case 'X'
						MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
						Rollback;
						F_message_chk(41,'[할당내역 계산]')
						return;
				 Case 'Y'
						MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
						Rollback;
						F_message_chk(89,'[할당내역 계산]'+spordno)
						p_can.TriggerEvent(Clicked!)
						return;
		End Choose
		
		// 출고예정창고를 Update
		Update HoldsTock_copy a
			Set hold_store = (select Decode(b.ittyp, '2', :sBan, :sJaje) as chango
									  From Itemas b
									 Where b.itnbr = a.itnbr)
		 Where a.sabu = :gs_sabu and a.hold_no like :isholdno||'%';
	Next
	
	Commit;
Else
	/* 외주불출 수정인 경우 */
	
End If

p_inq.Enabled = False
p_inq.PictureName = 'C:\erpman\image\조회_d.gif'
p_ins.Enabled = False
p_ins.PictureName = 'C:\erpman\image\계산_d.gif'
p_mod.Enabled = True
p_mod.PictureName = 'C:\erpman\image\확정_up.gif'

w_mdi_frame.sle_msg.text = 'sysno : ' + is_sysno
end event

type p_exit from w_inherite`p_exit within w_pdt_02070
end type

type p_can from w_inherite`p_can within w_pdt_02070
end type

event p_can::clicked;call super::clicked;String sError, sNull

SetNull(sNull)

dw_head.SetItem(1, 'itnbr', sNull)

dw_insert.Reset()
dw_hold.Reset()

cbx_2.Checked = False
dw_insert.SetFilter("")
dw_insert.Filter()

p_inq.Enabled = True
p_inq.PictureName = 'C:\erpman\image\조회_up.gif'
p_ins.Enabled = True
p_ins.PictureName = 'C:\erpman\image\계산_up.gif'
p_mod.Enabled = False
p_mod.PictureName = 'C:\erpman\image\확정_d.gif'
end event

type p_print from w_inherite`p_print within w_pdt_02070
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_pdt_02070
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String	sPordno, sFrdate, sTodate, sPdtgu, splfrdate, spltodate, sItnbr

if dw_head.AcceptText() = -1 then return 

dw_insert.ReSet()
dw_hold.ReSet()

sPordno   = Trim(dw_head.getitemstring(1,"pordno"))
sFrdate   = dw_head.getitemstring(1,"frdate")
sTodate   = dw_head.getitemstring(1,"todate")
sItnbr    = dw_head.getitemstring(1,"itnbr")
sPdtgu    = dw_head.getitemstring(1,"pdtgu")

If IsNull(sItnbr) Then sItnbr = ''

if IsNull(sPordno) or sPordno = '' then
	sPordno = '%'
else
	sPordno = sPordno + '%'
end if

if IsNull(sFrdate) or sFrdate = '' then
	sFrdate = '11111111'
elseif f_datechk(sFrdate) = -1 then
	MessageBox("확인","날짜를 확인하세요.")
	dw_head.SetColumn('frdate')
	dw_head.SetFocus()
end if

if IsNull(sTodate) or sTodate = '' then
	sTodate = '99991231'
elseif f_datechk(sTodate) = -1 then
	MessageBox("확인","날짜를 확인하세요.")
	dw_head.SetColumn('todate')
	dw_head.SetFocus()
	return
end if

if IsNull(sPdtgu) or sPdtgu = '' then
	MessageBox("확인","생산팀을 확인하세요.")
	dw_head.SetColumn('pdtgu')
	dw_head.SetFocus()
	return
end if

SetPointer(HourGlass!)
/* 생산실적 수정인 경우 */
If isGub = '1' Then
	if dw_insert.Retrieve(gs_sabu,sPordno,sFrdate,sTodate,sPdtgu, gs_saupj, sItnbr+'%') <= 0 then
		f_message_chk(56,'[자재소진내역 수정]')
	
		dw_head.SetColumn("itnbr")
		dw_head.SetFocus()
		return
	end if
Else
	/* 외주불출 수정인 경우 */
	if dw_insert.Retrieve(gs_sabu,sFrdate,sTodate, sItnbr+'%') <= 0 then
		f_message_chk(56,'[외주불출내역 수정]')
	
		dw_head.SetColumn("itnbr")
		dw_head.SetFocus()
		return
	end if
	
	p_ins.Enabled = False
	p_ins.PictureName = 'C:\erpman\image\계산_d.gif'
	p_mod.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\확정_up.gif'
End If
end event

type p_del from w_inherite`p_del within w_pdt_02070
boolean visible = false
integer y = 168
end type

type p_mod from w_inherite`p_mod within w_pdt_02070
integer x = 4096
boolean enabled = false
string picturename = "C:\erpman\image\확정_d.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\확정_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\확정_up.gif"
end event

event p_mod::clicked;call super::clicked;String sPordno, sOut
Long   ix, iok, inot, ierr

IF MessageBox("확 인","일괄 확인 처리를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

SetPointer(HourGlass!)

/* 생산실적 수정인 경우 */
If isGub = '1' Then
	For ix = 1 To dw_insert.RowCount()
		sPordno = dw_insert.GetItemString(ix, 'momast_pordno')
		
		//프로시저 선언
		sOut = 'X'
		
		DECLARE ERP_JAJE_CHULGO_RECREATE procedure for ERP_JAJE_CHULGO_RECREATE(:gs_sabu, :sPordno, :is_sysno) ;
		EXECUTE ERP_JAJE_CHULGO_RECREATE;
		FETCH   ERP_JAJE_CHULGO_RECREATE INTO :sOut;
	
		Choose Case sout
			Case 'N'
				inot++
			Case 'Y'
				iok++
			Case Else
				ierr++
		End Choose
		
		dw_insert.SetItem(ix, 'status', sOut)
		w_mdi_frame.sle_msg.text = string(ix)+'/'+string(dw_insert.rowcount()) + ' 처리완료!!'
		
		CLOSE ERP_JAJE_CHULGO_RECREATE;
	Next
	
	IF is_sysno > '' then
	//	if Messagebox("자재소진내역 수정", "작업중입니다" + '~n' + &
	//									  "취소하시겠읍니까?", question!, yesno!) = 1 then
		
			/* 할당내역을 삭제 */
			Delete From holdstock_copy 			Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';
	
			/* 지시내역을 삭제 */
			Delete From momast_copy 				Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';
	
			/* 공정내역을 삭제 */
			Delete From morout_copy 				Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';
	
			/* 반제품 소요수량 삭제 */
			Delete From momast_copy_lotsim 		Where sabu = :gs_sabu and master_no Like :iS_sysno||'%';
	
			COMMIT;
			
			is_sysno=''
	//	Else	
	//		return 1
	//	End if
	end if

	MessageBox('확인','처  리 : '+string(iok) + '~r~n미처리 : '+string(inot)+ '~r~n오  류 : '+string(ierr))
Else
	/* 외주불출 수정인 경우 */	
	wf_create_waiju()
End If

//p_can.TriggerEvent(Clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_pdt_02070
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02070
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02070
end type

type cb_del from w_inherite`cb_del within w_pdt_02070
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02070
end type

type cb_print from w_inherite`cb_print within w_pdt_02070
end type

type st_1 from w_inherite`st_1 within w_pdt_02070
end type

type cb_can from w_inherite`cb_can within w_pdt_02070
end type

type cb_search from w_inherite`cb_search within w_pdt_02070
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_02070
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02070
end type

type dw_head from u_key_enter within w_pdt_02070
integer x = 37
integer y = 48
integer width = 3328
integer height = 136
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdt_02070_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;

choose case getcolumnname()
	case 'frdate'
		
		SetItem(row, 'todate', gettext())
	Case 'gub'
		If GetText() = '1' Then
			dw_insert.DataObject = 'd_pdt_02070_2'
			dw_hold.DataObject = 'd_pdt_02070_3'
			isgub = '1'
		Else
			// 생산실적 수정중이면 취소처리한다
			IF is_sysno > '' then
				p_can.TriggerEvent(Clicked!)
			End If
			
			dw_insert.DataObject = 'd_pdt_02070_4'
			dw_hold.DataObject = 'd_pdt_02070_5'
			isgub = '2'
		End If
		
		dw_insert.SetTransObject(sqlca)
		dw_hold.SetTransObject(sqlca)
end Choose
end event

type dw_hold from u_key_enter within w_pdt_02070
integer x = 55
integer y = 1360
integer width = 4485
integer height = 896
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdt_02070_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type pb_1 from u_pb_cal within w_pdt_02070
integer x = 658
integer y = 72
integer taborder = 21
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.SetColumn('frdate')
IF IsNull(gs_code) THEN Return
If dw_head.Object.frdate.protect = '1' Or dw_head.Object.frdate.TabSequence = '0' Then Return

dw_head.SetItem(1, 'frdate', gs_code)
dw_head.SetItem(1, 'todate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02070
boolean visible = false
integer x = 1111
integer y = 72
integer taborder = 31
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.SetColumn('todate')
IF IsNull(gs_code) THEN Return
If dw_head.Object.todate.protect = '1' Or dw_head.Object.todate.TabSequence = '0' Then Return

dw_head.SetItem(1, 'todate', gs_code)
end event

type dw_momast from datawindow within w_pdt_02070
boolean visible = false
integer y = 1776
integer width = 4453
integer height = 400
integer taborder = 21
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02030_1"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_pdt_02070
integer x = 78
integer y = 1288
integer width = 425
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "* 자재할당 내역"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_pdt_02070
integer x = 4073
integer y = 1276
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "차이분"
boolean checked = true
end type

event clicked;If This.Checked = True Then
	dw_hold.SetFilter('sts <> 0')
Else
	dw_hold.SetFilter('')
End If

dw_hold.Filter()
end event

type dw_jaje from datawindow within w_pdt_02070
boolean visible = false
integer x = 2469
integer y = 144
integer width = 695
integer height = 80
integer taborder = 41
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02030_42"
boolean border = false
boolean livescroll = true
end type

type dw_ban from datawindow within w_pdt_02070
boolean visible = false
integer x = 2427
integer y = 228
integer width = 722
integer height = 80
integer taborder = 51
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02030_40"
boolean border = false
boolean livescroll = true
end type

type cbx_2 from checkbox within w_pdt_02070
integer x = 3424
integer y = 136
integer width = 329
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체선택"
end type

event clicked;string schk
Long   ix

If This.Checked Then
	schk = 'Y'
Else
	sChk = 'N'
End If

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix, 'chk_flag', schk)
Next
end event

type st_3 from statictext within w_pdt_02070
integer x = 1019
integer y = 204
integer width = 722
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "* 전체외작은 제외됨.."
boolean focusrectangle = false
end type

type dw_waiju from datawindow within w_pdt_02070
boolean visible = false
integer x = 2912
integer y = 2040
integer width = 686
integer height = 400
integer taborder = 31
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02070_6"
boolean border = false
boolean livescroll = true
end type

type st_4 from statictext within w_pdt_02070
integer x = 82
integer y = 204
integer width = 887
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "* 정상작업만 해당(재작업제외)"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_02070
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 46
integer y = 280
integer width = 4512
integer height = 964
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02070
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 46
integer y = 1260
integer width = 4512
integer height = 1016
integer cornerheight = 40
integer cornerwidth = 55
end type

