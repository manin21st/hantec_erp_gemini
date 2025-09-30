$PBExportHeader$w_pdt_05580.srw
$PBExportComments$자재검토-구매의뢰
forward
global type w_pdt_05580 from w_inherite
end type
type dw_ban from datawindow within w_pdt_05580
end type
type dw_jaje from datawindow within w_pdt_05580
end type
type dw_estima_update from datawindow within w_pdt_05580
end type
type tab_1 from tab within w_pdt_05580
end type
type tabpage_1 from userobject within tab_1
end type
type dw_momast from datawindow within tabpage_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_momast dw_momast
rr_1 rr_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_pordno from datawindow within tabpage_2
end type
type dw_morout from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_pordno dw_pordno
dw_morout dw_morout
end type
type tab_1 from tab within w_pdt_05580
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_head from datawindow within w_pdt_05580
end type
type pb_1 from u_pb_cal within w_pdt_05580
end type
type pb_2 from u_pb_cal within w_pdt_05580
end type
end forward

shared variables

end variables

global type w_pdt_05580 from w_inherite
string title = "작업지시-자재검토"
dw_ban dw_ban
dw_jaje dw_jaje
dw_estima_update dw_estima_update
tab_1 tab_1
dw_head dw_head
pb_1 pb_1
pb_2 pb_2
end type
global w_pdt_05580 w_pdt_05580

type variables
long insrow
String is_holdgu
end variables

forward prototypes
public subroutine wf_reset ()
public function integer jaje_check (ref long lrow, ref string scolumn)
public function integer wf_estima_update ()
end prototypes

public subroutine wf_reset ();rollback;

ib_any_typing =FALSE

tab_1.SelectTab(1)
tab_1.tabpage_1.dw_momast.Reset()
tab_1.tabpage_2.dw_morout.ReSet()
tab_1.tabpage_2.dw_pordno.ReSet()
tab_1.tabpage_1.Enabled = TRUE
tab_1.tabpage_2.Enabled = FALSE

p_ins.Enabled = FALSE
p_mod.Enabled = FALSE
p_del.Enabled = FALSE
p_inq.Enabled = TRUE

p_ins.PictureName = "c:\erpman\image\추가_d.gif"
p_mod.PictureName = "c:\erpman\image\저장_d.gif"
p_del.PictureName = "c:\erpman\image\삭제_d.gif"
p_inq.PictureName = "c:\erpman\image\조회_up.gif"

dw_head.enabled = true
dw_head.setredraw(false)
dw_head.Reset()
dw_head.InsertRow(0)

dw_head.SetItem(1,'frdate',Left(f_today(),6) + '01')
dw_head.SetItem(1,'todate',f_today())
dw_head.setredraw(true)
dw_head.SetColumn('pordno')
dw_head.SetFocus()

end subroutine

public function integer jaje_check (ref long lrow, ref string scolumn);/* 자재 할당 내역 검색 */

string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, scvcod, sopseq, spordno, stoday
integer  ireturn
Decimal  {5} dunprc
long lcnt, lfind

w_mdi_frame.sle_msg.text = "자재할당내역을 검색중입니다......!!"

sToday = f_today()

tab_1.tabpage_2.dw_morout.accepttext()

setnull(snull)

For 	lcnt = 1 to tab_1.tabpage_2.dw_morout.rowcount()
		lrow = lcnt
		
		/* 공정순서 check */
		If 	isnull(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "opseq")) or &
				Trim(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "opseq")) = '' then
				f_message_chk(30, '[공정순서]')
				sColumn = "opseq"
				w_mdi_frame.sle_msg.text = ""
				return -1
		end if
		
		/* 품번 check */
		If 	isnull(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "itnbr")) or &
				Trim(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "itnbr")) = '' then
				f_message_chk(30, '[품목번호]')
				sColumn = "itnbr"
				w_mdi_frame.sle_msg.text = ""				
				return -1
		end if
		
		/* 사양 check */
		If 	isnull(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "pspec")) or &
				Trim(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "pspec")) = '' then
				tab_1.tabpage_2.dw_morout.setitem(Lcnt, 'pspec', '.')
				w_mdi_frame.sle_msg.text = ""				
		end if		
		
		/* 할당수량 check */
		If 	tab_1.tabpage_2.dw_morout.getitemdecimal(Lcnt, "hold_qty") = 0 then
				f_message_chk(30, '[할당수량]')
				sColumn = "hold_qty"
				w_mdi_frame.sle_msg.text = ""				
				return -1
		end if		
		
		/* 출고창고 check */
		If 	isnull(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "out_store")) or &
				Trim(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "out_store")) = '' then
				f_message_chk(30, '[출고창고]')
				sColumn = "out_store"
				w_mdi_frame.sle_msg.text = ""				
				return -1
		end if
		
		/* 출고요총창고 check */
		If 	isnull(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "hold_store")) or &
				Trim(tab_1.tabpage_2.dw_morout.getitemstring(Lcnt, "hold_store")) = '' then
				f_message_chk(30, '[출고요청창고]')
				sColumn = "out_store"
				w_mdi_frame.sle_msg.text = ""				
				return -1
		end if

Next

w_mdi_frame.sle_msg.text = ""

if tab_1.tabpage_2.dw_morout.update() = 1 then
	commit;	
Else
	Lrow = 1
	sColumn = 'opseq'
	Rollback;
	return -1
end if

return 1
end function

public function integer wf_estima_update ();String     sCvcod, sTuncu ,sCvnas, sJpno, sDate, sItnbr, sitgu, sOrderNo, sPordNo
String	  sempno, sempno2, sestgu, sSaupj, sDepot, sCnvgu, sCnvart, sAccod, sNapDt, sDeptcode, syongdo
Dec {5}    dUnprc
dec {6}    dcnvfat       //변환계수
dec {3}    dvnqty
long	     lRow, lSeq, lcount, i, lLdtime
integer	  j, k
String		ls_pspec

SetPointer(HourGlass!)

dw_estima_update.reset()

tab_1.tabpage_2.dw_morout.AcceptText()
//-------------------------------------------------------------------------------------------
/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';

If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if
//-------------------------------------------------------------------------------------------
/* 구매의뢰 -> 발주확정 연산자를 환경설정에서 검색함 */
select dataname
  into :sCnvart
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '4';

If isNull(sCnvart) or Trim(sCnvart) = '' then
	sCnvart = '*'
End if
//-------------------------------------------------------------------------------------------
sDate = f_today()  		//의뢰일자
lSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')
IF lSeq < 0	 or lseq > 9999	THEN	
	f_message_chk(51, '')
   RETURN -1
END IF
COMMIT;

sJpno = sDate + string(lSeq, "0000")
//-------------------------------------------------------------------------------------------
//거래처에 구매담당자가 없을 경우에 구매담당자 
select dataname
  into :sempno
  from syscnfg
 where sysgu = 'Y' and serial = 14 and lineno = '1';
 
lcount = tab_1.tabpage_2.dw_morout.RowCount()
//-------------------------------------------------------------------------------------------
FOR	lRow = 1		TO		lCount
	sDepot   = tab_1.tabpage_2.dw_morout.getitemstring(lRow,'hold_store')
	sPordNo  = tab_1.tabpage_2.dw_morout.getitemstring(lrow,'pordno')	

	//입고예정 창고로 부가세 사업장을 가져옴
	select ipjogun
	  into :sSaupj
	  from vndmst
	 where cvcod  = :sDepot ; 
	
	//check 선택되고 구매의뢰예정량이 0 이상인 것만 처리.
	if	tab_1.tabpage_2.dw_morout.getitemNumber(lRow, 'req_qty') > 0 THEN 

		j++
      
		if mod(j,998) = 0 then
			lSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')
			IF lSeq < 0	 or lseq > 9999	THEN	
				f_message_chk(51, '')
				RETURN -1
			END IF
			COMMIT;
		
			sJpno = sDate + string(lSeq, "0000")
			j = 1
		end if


		sPordNo  = tab_1.tabpage_2.dw_morout.getitemstring(lrow,'pordno')
		
		SELECT ORDER_NO INTO :sOrderNo FROM MOMAST WHERE SABU = :gs_sabu AND PORDNO = :sPordNo ;
		
		i = dw_estima_update.insertrow(0)
		dw_estima_update.SetItem(i, "sabu",  gs_sabu)
		dw_estima_update.SetItem(i, "estno", sJpno + string(j, "000"))
		dw_estima_update.SetItem(i, "order_no", sOrderNo) // 수주번호
		dw_estima_update.SetItem(i, "gu_pordno", sPordNo)	  // 작지번호
		dw_estima_update.SetItem(i, "saupj", sSaupj)
		dw_estima_update.SetItem(i, "estgu", '1')  //생산용으로 셋팅
		
		sAccod = tab_1.tabpage_2.dw_morout.getitemstring( lrow, 'accod')
		if IsNull(sAccod) or Trim(sAccod) = '' then
			dw_estima_update.SetItem(i,"yebi1",tab_1.tabpage_2.dw_morout.getitemstring(lrow,'itemas_accod')) //품목마스타 계정코드 
		else
			dw_estima_update.SetItem(i,"yebi1",sAccod) // 계정등록코드
		end if
		
		sItnbr = tab_1.tabpage_2.dw_morout.getitemstring( lrow, 'itnbr')
      dw_estima_update.SetItem(i, "itnbr", sitnbr)  //품번 
      dw_estima_update.SetItem(i, "pspec", '.')     //사양

		sItgu = tab_1.tabpage_2.dw_morout.getitemstring(lrow, 'itgu')  //구입형태
		if sitgu >= '1' and sitgu <= '6' then
			dw_estima_update.setitem(i, "itgu", sitgu)
		else
			dw_estima_update.setitem(i, "itgu", '1')
		end if
		if sitgu = '3' or sitgu = '4' then
			dw_estima_update.SetItem(i, "suipgu", '2')
		else
			dw_estima_update.SetItem(i, "suipgu", '1')
		end if	
		
		ls_pspec  = tab_1.tabpage_2.dw_morout.getitemstring(lrow,'pspec')
		
      f_buy_unprc(sitnbr, ls_pspec, '9999', sCvcod, sCvnas, dUnprc, sTuncu)  //거래처, 단가, 통화 

		if sTuncu = '' or isnull(sTuncu) then sTuncu = 'WON'
		dw_estima_update.SetItem(i, "unprc",  dUnprc)   				 //단가 
		dw_estima_update.SetItem(i, "cvcod",  scvcod)  					 //거래처 
		dw_estima_update.SetItem(i, "tuncu",  sTuncu)  					 //통화단위 
		
		dvnqty = tab_1.tabpage_2.dw_morout.getitemDecimal(lrow, 'req_qty')
		dw_estima_update.SetItem(i, "guqty",  dvnqty ) 					 //의뢰수량
		dw_estima_update.SetItem(i, "vnqty",  dvnqty )  				 //발주예정량
		dw_estima_update.SetItem(i, "widat",  sDate) 					 //입력일자
		
		lLdtime = tab_1.tabpage_2.dw_morout.getitemNumber( lrow, 'itemas_ldtime')
		sNapDt  = f_afterday( sDate, lLdtime )		
		dw_estima_update.SetItem(i, "yodat",  sNapDt )  				 //납기요구일 
		
		dw_estima_update.SetItem(i, "blynd",  '1')   					 //의뢰상태로  
		dw_estima_update.SetItem(i, "rdate",  sDate)  					 //의뢰일자

		// 거래처마스타 구매담당자(원칙)
		select emp_id into :sempno2 from vndmst where cvcod = :scvcod;
		
		if sempno2 = '' or isnull(sempno2) then 
			sempno2 = sempno
		end if

		SELECT "P1_MASTER"."DEPTCODE"
		  INTO :sDeptcode
		  FROM "P1_MASTER"
		 WHERE "P1_MASTER"."EMPNO"			= :sempno2 ;

		dw_estima_update.SetItem(i, "rdptno", gs_dept) 				    //의뢰부서 
		dw_estima_update.SetItem(i, "rempno", sempno2)	 				 //의뢰담당자		
		dw_estima_update.SetItem(i, "sempno", sempno2)  				 //구매담당자
//		dw_estima_update.SetItem(i, "project_no", ar_pjtno)  			 //project no  
		dw_estima_update.SetItem(i, "plncrt", '2')     					 //정규,추가 구분
		dw_estima_update.SetItem(i, "ipdpt",   sDepot)  				 //입고창고
		dw_estima_update.SetItem(i, "prcgu",  '2')      				 //선후 여부 
		dw_estima_update.SetItem(i, "sakgu",  'N')      				 //사후관리여부 
		dw_estima_update.SetItem(i, "choyo",  'N')      				 //첨부유무 
		dw_estima_update.SetItem(i, "opseq", '9999')    				 //공정코드  
		dw_estima_update.SetItem(i, "autcrt", 'N')      				 //자동생성 여부    
		
		syongdo = tab_1.tabpage_2.dw_morout.getitemstring( lrow, 'yongdo')		
		dw_estima_update.SetItem(i, "yongdo", syongdo)      				 
		
		if sCnvgu = 'N' then 
			dw_estima_update.SetItem(i, "cnvfat",  1) 
			dw_estima_update.SetItem(i, "cnvart",  sCnvart) 
			dw_estima_update.SetItem(i, "cnvprc",  dUnprc ) 
			dw_estima_update.SetItem(i, "cnvqty",  dvnqty ) 
		else
			dcnvfat = tab_1.tabpage_2.dw_morout.getitemdecimal(lRow, "itemas_cnvfat")

			if dcnvfat <= 0 or isnull(dcnvfat) then dcnvfat = 1

			if dcnvfat = 1 then
				dw_estima_update.SetItem(i, "cnvfat",  1) 
				dw_estima_update.SetItem(i, "cnvart",  sCnvart) 
				dw_estima_update.SetItem(i, "cnvprc",  dUnprc ) 
				dw_estima_update.SetItem(i, "cnvqty",  dvnqty ) 
			elseif sCnvart = '/' then
				dw_estima_update.SetItem(i, "cnvfat",  dcnvfat) 
				dw_estima_update.SetItem(i, "cnvart",  sCnvart) 
				dw_estima_update.SetItem(i, "cnvprc",  round(dUnprc * dcnvfat, 5)) 
				dw_estima_update.SetItem(i, "cnvqty",  round(dvnqty / dcnvfat, 3)) 
			else
				dw_estima_update.SetItem(i, "cnvfat",  dcnvfat) 
				dw_estima_update.SetItem(i, "cnvart",  sCnvart) 
				dw_estima_update.SetItem(i, "cnvprc",  round(dUnprc / dcnvfat, 5)) 
				dw_estima_update.SetItem(i, "cnvqty",  round(dvnqty * dcnvfat, 3)) 
			end if
		end if
	END IF
NEXT

IF dw_estima_update.AcceptText() = -1 then return -1
IF dw_estima_update.Update() > 0		THEN
	
	Update momast set pangbn = 'Y' where sabu = :gs_sabu and pordno = :spordno;
	if sqlca.sqlcode = 0 then
		COMMIT;
	Else
		rollback;
		Messagebox("Error", "작업지시 갱신중 오류발생", stopsign!)
		return -1
	End if
ELSE
	rollback;
	Messagebox("Error", "작업지시 갱신중 오류발생", stopsign!)
	return -1
END IF

return 1
end function

on w_pdt_05580.create
int iCurrent
call super::create
this.dw_ban=create dw_ban
this.dw_jaje=create dw_jaje
this.dw_estima_update=create dw_estima_update
this.tab_1=create tab_1
this.dw_head=create dw_head
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ban
this.Control[iCurrent+2]=this.dw_jaje
this.Control[iCurrent+3]=this.dw_estima_update
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.dw_head
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
end on

on w_pdt_05580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ban)
destroy(this.dw_jaje)
destroy(this.dw_estima_update)
destroy(this.tab_1)
destroy(this.dw_head)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_head.SetTransObject(sqlca)
tab_1.tabpage_1.dw_momast.SetTransObject(sqlca)
tab_1.tabpage_2.dw_morout.SetTransObject(sqlca)
tab_1.tabpage_2.dw_pordno.SetTransObject(sqlca)
dw_estima_update.settransobject(sqlca)

string scode

/* 반제품 창고 검색 */
dw_ban.settransobject(sqlca)
dw_ban.insertrow(0)
Select Min(cvcod) into :sCode
  From vndmst
 Where cvgu = '5' and jumaechul = '2' and juprod = '2';
dw_ban.setitem(1, "ban_code", sCode)


dw_jaje.settransobject(sqlca)
dw_jaje.insertrow(0)
Select Min(cvcod) into :sCode
  From vndmst
 Where cvgu = '5' and jumaechul = '2' and juprod = '3';
dw_jaje.setitem(1, "jaje_code", sCode)

//작지시 할당구분(1:자재소진,2:출고요청), 자재소진인 경우 입고창고는 out_store, 출고요청은 in_store임
select dataname into :is_holdgu from syscnfg where sysgu = 'Y' and serial = 15 and lineno = 8;
If IsNull(is_holdgu) Then is_holdgu = '1'
If is_holdgu = '1' Then
	tab_1.tabpage_2.dw_morout.DataObject = 'd_pdt_05580_02'
Else
	tab_1.tabpage_2.dw_morout.DataObject = 'd_pdt_05580_02_1'
End If
tab_1.tabpage_2.dw_morout.SetTransObject(sqlca)

wf_reset()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_05580
boolean visible = false
integer x = 535
integer y = 2500
integer width = 320
integer height = 92
integer taborder = 10
boolean enabled = false
boolean vscrollbar = true
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;Long    Lrow, get_count
String  sOld_sts, sNew_sts, spordno

Lrow = this.getrow()

IF this.getcolumnname() = "momast_pdsts" THEN
   sold_sts = this.GetItemString(lrow, "old_pdsts")   
   spordno  = this.GetItemString(lrow, "momast_pordno")   
	
   sNew_sts = this.GetText() 

	IF sNew_sts = '3' OR sOld_sts = '3' THEN 
		MESSAGEBOX("확 인", "상태를 임의로 정상완료 시키거나 변경시킬 수  없습니다.")
		this.setitem(lrow, "momast_pdsts", sold_sts)
		return 1
	END IF	
	
	IF sNew_sts > '2' AND sNew_sts <> sOld_sts THEN 
		 SELECT SUM(ICOUNT)
		   INTO :get_count
			FROM
				( SELECT COUNT(*)  AS ICOUNT
					 FROM SHPACT_IPGO A    
					WHERE A.SABU   = :gs_sabu   AND  
							A.PORDNO = :spordno AND A.IOJPNO IS NULL
				  UNION ALL
				  SELECT COUNT(*)  AS ICOUNT
					 FROM SHPACT_IPGO A, IMHIST B   
					WHERE A.SABU   = :gs_sabu   AND  
							A.PORDNO = :spordno  AND A.IOJPNO IS NOT NULL AND
							A.SABU	= B.SABU		AND
							A.IOJPNO = B.IOJPNO  AND
							B.IO_DATE IS NULL ) ;
							
		if get_count > 0 then 
			MessageBox("확 인","입고예정된 자료가 존재합니다. 자료를 확인하세요" + "~n~n" +&
									 "상태를 변경시킬 수 없습니다.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	
		
		get_count = 0
		// ESTIMA(구매의뢰)가 의뢰, 검토 이거나
		// POBLKT(발주품목정보) 발주상태가 진행('1')시에는  취소시킬 수 없음
		SELECT COUNT(*) 
        INTO :get_count  
		  FROM ESTIMA  
		 WHERE SABU = :gs_sabu AND PORDNO = :spordno AND BLYND IN ('1', '2') ;

		if get_count > 0 then 
			MessageBox("확 인","구매의뢰상태가 의뢰, 검토인 자료입니다. 자료를 확인하세요" + "~n~n" +&
									 "상태를 변경시킬 수 없습니다.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	

		get_count = 0
		SELECT COUNT(*) 
        INTO :get_count  
		  FROM POBLKT  
		 WHERE SABU = :gs_sabu AND PORDNO = :spordno AND BALSTS = '1' ;

		if get_count > 0 then 
			MessageBox("확 인","발주품목정보가 진행상태인 자료입니다. 자료를 확인하세요" + "~n~n" +&
									 "상태를 변경시킬 수 없습니다.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	

		get_count = 0
		SELECT COUNT(*) 
        INTO :get_count  
		  FROM IMHIST
		 WHERE SABU = :gs_sabu AND INPCNF = 'I' AND JAKJINO = :sPordno AND IO_DATE IS NULL ;

		if get_count > 0 then 
			MessageBox("확 인","입고승인이 안된 자료가 있습니다. 자료를 확인하세요" + "~n~n" +&
									 "상태를 변경시킬 수 없습니다.", StopSign! )
			this.setitem(lrow, "momast_pdsts", sold_sts)
			Return 1
		end if	

	END IF

END IF

	
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type p_delrow from w_inherite`p_delrow within w_pdt_05580
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_05580
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_05580
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_05580
integer x = 3749
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;Long Lrow, lRow2
String sToday
integer iJ


/********************************************************************************************/
/* 송추가 - 2001.09.19 */
if tab_1.tabpage_2.dw_pordno.RowCount() < 1 then
	MessageBox("확인","Double Click해 자료를 조회한 후 처리하세요.")
	tab_1.SelectTab(1)
	return
end if
/********************************************************************************************/


sToday = f_today()

SEtpointer(hourglass!)
/* 할당번호 채번 */
iJ = sqlca.fun_junpyo(gs_sabu, stoday, 'B0')
if iJ < 1 then
	f_message_chk(51,'[할당번호]')
	rollback;
	return 
end if

Commit;

// 기본적인 내용을 setting
Lrow = tab_1.tabpage_2.dw_morout.insertrow(0)

tab_1.tabpage_2.dw_morout.setitem(Lrow, "sabu", gs_sabu)											// 사업장구분
tab_1.tabpage_2.dw_morout.setitem(Lrow, "hold_no", stoday + String(iJ, '0000') + '001')	// 할당번호
tab_1.tabpage_2.dw_morout.setitem(Lrow, "hold_date", sToday)										// 할당일자
tab_1.tabpage_2.dw_morout.setitem(Lrow, "pspec", '.')													// 사양
tab_1.tabpage_2.dw_morout.setitem(Lrow, "pordno", 	tab_1.tabpage_2.dw_pordno.getitemstring(1, "pordno"))		// 작업지시번호
tab_1.tabpage_2.dw_morout.setitem(Lrow, "hosts", 'N')													// 할당상태

tab_1.tabpage_2.dw_morout.setcolumn("opseq")
tab_1.tabpage_2.dw_morout.scrolltorow(Lrow)
tab_1.tabpage_2.dw_morout.setrow(Lrow)
tab_1.tabpage_2.dw_morout.setfocus()


SEtpointer(Arrow!)
end event

type p_exit from w_inherite`p_exit within w_pdt_05580
end type

type p_can from w_inherite`p_can within w_pdt_05580
end type

event p_can::clicked;call super::clicked;String	sPordno, sFrdate, sTodate, sPdtgu, sgubun


if tab_1.SelectedTab <> 1 then tab_1.SelectTab(1)
tab_1.tabpage_2.dw_morout.ReSet()
//tab_1.tabpage_2.Enabled = FALSE

if dw_head.AcceptText() = -1 then return 
sPordno = Trim(dw_head.getitemstring(1,"pordno"))
sFrdate = dw_head.getitemstring(1,"frdate")
sTodate = dw_head.getitemstring(1,"todate")
sPdtgu  = dw_head.getitemstring(1,"pdtgu")
sgubun  = dw_head.getitemstring(1,"gubun")

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
end if

if IsNull(sPdtgu) or sPdtgu = '' then
	sPdtgu = '%'
end if


SetPointer(HourGlass!)
tab_1.tabpage_1.dw_momast.SetRedraw(FALSE)
if tab_1.tabpage_1.dw_momast.Retrieve(gs_sabu,sPordno,sFrdate,sTodate,sPdtgu) <= 0 then
	Messagebox("Material","Data Not Found!", stopsign!)
	p_mod.Enabled = FALSE
	p_ins.Enabled = FALSE
	p_ins.PictureName = "c:\erpman\image\추가_d.gif"
   p_mod.PictureName = "c:\erpman\image\저장_d.gif"
	
	tab_1.tabpage_2.Enabled = FALSE

	dw_head.SetColumn("pordno")
	dw_head.SetFocus()
	return
end if

if sgubun = 'Y' then		// 미검토
	tab_1.tabpage_1.dw_momast.setfilter("isnull(pangbn)")
	tab_1.tabpage_1.dw_momast.filter()
Else
	tab_1.tabpage_1.dw_momast.setfilter("pangbn = 'Y'")
	tab_1.tabpage_1.dw_momast.filter()		
End if

tab_1.tabpage_1.dw_momast.SetRedraw(TRUE)

//dw_head.enabled = false
ib_any_typing  = FALSE
//this.Enabled = FALSE
tab_1.tabpage_2.Enabled = TRUE

wf_reset()

end event

type p_print from w_inherite`p_print within w_pdt_05580
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_05580
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String	sPordno, sFrdate, sTodate, sPdtgu, sgubun


if tab_1.SelectedTab <> 1 then tab_1.SelectTab(1)
tab_1.tabpage_2.dw_morout.ReSet()
tab_1.tabpage_2.Enabled = FALSE

if dw_head.AcceptText() = -1 then return 
sPordno = Trim(dw_head.getitemstring(1,"pordno"))
sFrdate = dw_head.getitemstring(1,"frdate")
sTodate = dw_head.getitemstring(1,"todate")
sPdtgu  = dw_head.getitemstring(1,"pdtgu")
sgubun  = dw_head.getitemstring(1,"gubun")

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
end if

if IsNull(sPdtgu) or sPdtgu = '' then
	sPdtgu = '%'
end if


SetPointer(HourGlass!)
tab_1.tabpage_1.dw_momast.SetRedraw(FALSE)
if tab_1.tabpage_1.dw_momast.Retrieve(gs_sabu,sPordno,sFrdate,sTodate,sPdtgu) <= 0 then

//	Messagebox("Material","Data Not Found!", stopsign!)
	f_message_chk(50,'[작업지시-자재검토]')
	p_mod.Enabled = FALSE
	p_ins.Enabled = FALSE
	p_ins.PictureName = "c:\erpman\image\추가_d.gif"
   p_mod.PictureName = "c:\erpman\image\저장_d.gif"
   tab_1.tabpage_2.Enabled = FALSE

	dw_head.SetColumn("pordno")
	dw_head.SetFocus()
	return
end if

if sgubun = 'Y' then		// 미검토
	tab_1.tabpage_1.dw_momast.setfilter("isnull(pangbn)")
	tab_1.tabpage_1.dw_momast.filter()
Else
	tab_1.tabpage_1.dw_momast.setfilter("pangbn = 'Y'")
	tab_1.tabpage_1.dw_momast.filter()		
End if

tab_1.tabpage_1.dw_momast.SetRedraw(TRUE)

dw_head.enabled = false
ib_any_typing  = FALSE
this.Enabled = FALSE
tab_1.tabpage_2.Enabled = TRUE

end event

type p_del from w_inherite`p_del within w_pdt_05580
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;Long Lrow


/********************************************************************************************/
/* 송추가 - 2001.09.19 */
if tab_1.tabpage_2.dw_morout.RowCount() < 1 then
	MessageBox("확인","Double Click해 자료를 조회한 후 처리하세요.")
	tab_1.SelectTab(1)
	return
end if
/********************************************************************************************/


If Messagebox("할당삭제",  "삭제하시겠읍니까?", question!, yesno!, 2) = 2 then
	tab_1.tabpage_2.dw_morout.setfocus()
	Return
end if


For Lrow = 1 to tab_1.tabpage_2.dw_morout.rowcount()

	if tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "delgu") = 'Y' then
		tab_1.tabpage_2.dw_morout.deleterow(Lrow)		
		Lrow = Lrow - 1
	end if

Next

end event

type p_mod from w_inherite`p_mod within w_pdt_05580
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;if tab_1.tabpage_2.dw_morout.accepttext() = -1 then return

String sColumn, sgubun, spordno
Long   Lrow, Lcount

Lcount = 0
/********************************************************************************************/
/* 송추가 - 2001.09.19 */
if tab_1.tabpage_2.dw_morout.RowCount() < 1 then
	Lcount = tab_1.tabpage_1.dw_momast.getrow()
	if Lcount > 0 then	
		spordno = tab_1.tabpage_1.dw_momast.getitemstring(Lcount, "momast_pordno")		
		if Messagebox("검토확인", "할당내역이 없읍니다" + '~n' + "작업지시번호 : " + spordno + "를 자재검토로 저장하시겠읍니까?", question!, yesno!) = 1 then
			Update momast set pangbn = 'Y' where sabu = :gs_sabu and pordno = :spordno;
			if sqlca.sqlcode = 0 then
				COMMIT;
				tab_1.tabpage_1.dw_momast.setitem(Lcount, "pangbn", 'Y')				
			Else
				rollback;
				Messagebox("Error", "작업지시 갱신중 오류발생", stopsign!)
				return -1
			End if
		End if
	End if
	tab_1.SelectTab(1)
	return
end if
/********************************************************************************************/


if jaje_check(Lrow, scolumn) = -1 then
	tab_1.tabpage_2.dw_morout.setcolumn(scolumn)
	tab_1.tabpage_2.dw_morout.setrow(Lrow)
	tab_1.tabpage_2.dw_morout.scrolltorow(Lrow)	
	tab_1.tabpage_2.dw_morout.setfocus()
	return
end if


if tab_1.tabpage_2.dw_morout.update() = -1 then
	Messagebox("저장", "Holdstock 저장중 오류발생", stopsign!)
	rollback;
	return
Else
	if wf_estima_update() = -1 then
		Messagebox("저장", "Estima 저장중 오류발생", stopsign!)
		rollback;
		return
	End if
	commit;
	Messagebox("저장", "자료를 저장하였읍니다", information!)
	
	tab_1.tabpage_1.dw_momast.setitem(insrow, "pangbn", 'Y')
	sgubun = dw_head.getitemstring(1, "gubun")
	
	if dw_estima_update.RowCount() > 0 then
		MessageBox("구매의뢰번호 확인", "구매의뢰번호 : " + Left(dw_estima_update.GetItemString(1,'estno'),8) + &
					  "-" + Mid(dw_estima_update.GetItemString(1,'estno'),9,4) + "~r~r로 생성되었습니다.")
	end if
	
	/* 장차장님의 요청으로 송병호가 수정함 - 2001.09.05 */
//	if sgubun = 'Y' then
//		tab_1.tabpage_1.dw_momast.setfilter("isnull(pangbn)")
//		tab_1.tabpage_1.dw_momast.filter()
//	Else
//		tab_1.tabpage_1.dw_momast.setfilter("pangbn = 'Y'")
//		tab_1.tabpage_1.dw_momast.filter()		
//	End if	
	tab_1.selecttab(1)
end if
end event

type cb_exit from w_inherite`cb_exit within w_pdt_05580
integer x = 4288
integer y = 5000
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_pdt_05580
integer x = 3593
integer y = 5000
integer taborder = 90
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_05580
integer x = 2898
integer y = 5000
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_05580
integer x = 3246
integer y = 5000
integer taborder = 100
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_05580
integer x = 2523
integer y = 5000
end type

type cb_print from w_inherite`cb_print within w_pdt_05580
integer x = 1440
integer y = 2456
end type

type st_1 from w_inherite`st_1 within w_pdt_05580
end type

type cb_can from w_inherite`cb_can within w_pdt_05580
integer x = 3941
integer y = 5000
integer taborder = 110
end type

type cb_search from w_inherite`cb_search within w_pdt_05580
integer x = 1783
integer y = 2440
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_05580
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_05580
end type

type dw_ban from datawindow within w_pdt_05580
integer x = 1303
integer y = 5000
integer width = 741
integer height = 76
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02030_40"
boolean border = false
boolean livescroll = true
end type

type dw_jaje from datawindow within w_pdt_05580
integer x = 2295
integer y = 5000
integer width = 741
integer height = 76
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02030_42"
boolean border = false
boolean livescroll = true
end type

type dw_estima_update from datawindow within w_pdt_05580
boolean visible = false
integer x = 1006
integer y = 2464
integer width = 411
integer height = 128
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02030_estima_update"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tab_1 from tab within w_pdt_05580
integer x = 27
integer y = 256
integer width = 4581
integer height = 2064
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;if newindex = 1 then
	tab_1.tabpage_2.dw_morout.reset()
	tab_1.tabpage_2.dw_pordno.reset()
	p_ins.enabled = false
	p_del.enabled = false
	p_mod.enabled = false
	p_ins.PictureName = "c:\erpman\image\추가_d.gif"
   p_mod.PictureName = "c:\erpman\image\저장_d.gif"
   p_del.PictureName = "c:\erpman\image\삭제_d.gif"

Elseif newindex = 2 then	
	p_ins.enabled = true
	p_del.enabled = true
	p_mod.enabled = true	
	p_ins.PictureName = "c:\erpman\image\추가_up.gif"
	p_mod.PictureName = "c:\erpman\image\저장_up.gif"
	p_del.PictureName = "c:\erpman\image\삭제_up.gif"

	
End if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4544
integer height = 1952
long backcolor = 32106727
string text = "작업지시마스타"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_momast dw_momast
rr_1 rr_1
end type

on tabpage_1.create
this.dw_momast=create dw_momast
this.rr_1=create rr_1
this.Control[]={this.dw_momast,&
this.rr_1}
end on

on tabpage_1.destroy
destroy(this.dw_momast)
destroy(this.rr_1)
end on

type dw_momast from datawindow within tabpage_1
integer x = 9
integer y = 12
integer width = 4498
integer height = 1900
integer taborder = 30
string title = "none"
string dataobject = "d_pdt_05580_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row <= 0 then
	SelectRow(0,False)
else
	SelectRow(0, FALSE)
	SelectRow(row,TRUE)
end if
end event

event doubleclicked;String sPordno
Long  Lrow

row = this.GetRow()

if row > 0 then
	insrow = row
	sPordno = getitemstring(row, "momast_pordno")
	
	datawindowchild dwc
	tab_1.tabpage_2.dw_morout.getchild("opseq", dwc)
	dwc.settransobject(sqlca)
	
	tab_1.tabpage_2.dw_morout.reset()
	tab_1.tabpage_2.dw_pordno.reset()
	
	IF dwc.retrieve(gs_sabu, spordno) < 1 THEN 
		dwc.insertrow(0)
	END IF		
	
	tab_1.tabpage_2.dw_morout.retrieve(gs_sabu, spordno)
	tab_1.tabpage_2.dw_pordno.retrieve(gs_sabu, spordno)	
	
	// 구매예정량 계산(기존에 구매의뢰가 있으면 무시)
	For Lrow = 1 to tab_1.tabpage_2.dw_morout.rowcount()
       if tab_1.tabpage_2.dw_morout.getitemstring(Lrow, "itemas_ittyp") > '3' then continue			
       if tab_1.tabpage_2.dw_morout.getitemdecimal(Lrow, "gireq") > 0 then continue					 
		 
		 if tab_1.tabpage_2.dw_morout.getitemdecimal(Lrow, "stock_valid_qty") < 0 then
			 tab_1.tabpage_2.dw_morout.setitem(Lrow, "req_Qty", tab_1.tabpage_2.dw_morout.getitemdecimal(Lrow, "hold_qty"))
		 Elseif tab_1.tabpage_2.dw_morout.getitemdecimal(Lrow, "hold_qty") > tab_1.tabpage_2.dw_morout.getitemdecimal(Lrow, "stock_valid_qty") then
			     tab_1.tabpage_2.dw_morout.setitem(Lrow, "req_qty", tab_1.tabpage_2.dw_morout.getitemdecimal(Lrow, "hold_qty") - &
			 																	     tab_1.tabpage_2.dw_morout.getitemdecimal(Lrow, "stock_valid_qty"))
		 End if
		
	Next
		
	tab_1.selecttab(2)
end if

	

end event

type rr_1 from roundrectangle within tabpage_1
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer y = 8
integer width = 4521
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4544
integer height = 1952
boolean enabled = false
long backcolor = 32106727
string text = "자재검토"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_pordno dw_pordno
dw_morout dw_morout
end type

on tabpage_2.create
this.dw_pordno=create dw_pordno
this.dw_morout=create dw_morout
this.Control[]={this.dw_pordno,&
this.dw_morout}
end on

on tabpage_2.destroy
destroy(this.dw_pordno)
destroy(this.dw_morout)
end on

type dw_pordno from datawindow within tabpage_2
integer x = 9
integer y = 20
integer width = 3520
integer height = 292
integer taborder = 30
string title = "none"
string dataobject = "d_pdt_05580_04"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_morout from datawindow within tabpage_2
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 336
integer width = 4466
integer height = 1580
integer taborder = 30
string title = "none"
string dataobject = "d_pdt_05580_02_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;Long lrow
lrow = this.getrow()

if keydown(keyf1!) then
	this.triggerevent(rbuttondown!)
end if

IF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	end if
END IF

end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;RETURN 1
end event

event doubleclicked;Long Lrow, lReq
string sitnbr

Lrow = getrow()

if Lrow > 0 then
	
	Lreq =  Messagebox("대체품 & 재고정보" ,"대체품 재고정보를 보시겠읍니까?", question!, yesnocancel!)
	
	if Lreq = 1 then
		gs_code = getitemstring(Lrow, "itnbr")
		open(w_pdt_07200_5)
	Elseif lreq = 2 then
		gs_code 		= getitemstring(Lrow, "itnbr")
		gs_codename = getitemstring(Lrow, "itdsc")
		if isnull(gs_code) or trim(gs_code) = '' or isnull(gs_codename) or trim(gs_codename) = '' then
			return
		end if
		open(w_pdt_04000_1)
		setnull(gs_code)
		setnull(gs_codename)	
	End if
	
end if
end event

event itemchanged;Long Lrow
String sItnbr, sItdsc, sIspec, sAutvnd, sNull, sOpdsc, sOpseq, sPurgc, sPordno, sCvcod, sprvdat, &
		 sRqdat, sdepot_no, sdeptcode, sban, sjaje, sittyp, sCvnas, sPspec, sgijun, sout_store, &
		 STDITNBR, shname, sjijil, sispec_code
Integer iReturn
Decimal {3} dJego_qty, dValid_qty, dValid_qty1, dupjego, dupvalid, dreqqty, dgireq, droqty

Setnull(sNull)

Lrow = this.getrow()

this.accepttext()

dw_ban.accepttext() 		// 반제품 출고 기준창고
dw_jaje.accepttext()		// 부품   출고 기준창고
sBan		=	dw_ban.getitemstring(1, "ban_code")
sJaje		=	dw_jaje.getitemstring(1, "jaje_code")
spordno 	=  dw_pordno.getitemstring(1, "pordno")

IF GetColumnName() = "opseq"	THEN
	sOpseq = trim(GetText())
	
	/* 소진창고 */
	Select c.cvcod, c.deptcode into :sdepot_no, :sdeptcode
	  from momast_copy a, vndmst c
	 where a.sabu  = :gs_sabu and a.pordno like :sPordno
		and a.pdtgu = c.jumaeip (+) and c.ipjogun like :gs_saupj;
		
	Setitem(Lrow, "Req_dept", 	sDeptcode)
	
	/* 전체외주인 경우에만 허용함 */
	if sOPSEQ = '9999' then
		Setitem(Lrow, "opdsc", sNull)
		IF dw_pordno.getitemstring(1, "purgc") = 'N' then
			Messagebox("공정", "외주작업이 아니므로 입력할 수 없읍니다", stopsign!)
			Setitem(Lrow, "opseq", 		sNull)
			Setitem(Lrow, "opdsc", 		sNull)
			Setitem(Lrow, "hold_gu", 	sNull)
			Setitem(Lrow, "out_store", sNull)
			Setitem(Lrow, "req_dept", 	sNull)
			Setitem(Lrow, "in_store", 	sNull)
			Setitem(Lrow, "naougu", 	sNull)
			Setitem(Lrow, "out_chk", 	sNull)
			return 1
		Else
			/* 외주출고 에 대한 출고구분을 검색 (외주사급출고는 1개이어야 한다). */
			Select iogbn into :sautvnd from iomatrix 
			 where sabu = :gs_sabu and autvnd = 'Y';
			 
			if sqlca.sqlcode <> 0 then
				Messagebox("외주사급출고", "사급출고구분을 검색할 수 없읍니다", stopsign!)
				Setitem(Lrow, "opseq", 		sNull)
				Setitem(Lrow, "opdsc", 		sNull)
				Setitem(Lrow, "hold_gu", 	sNull)
				Setitem(Lrow, "out_store", sNull)
				Setitem(Lrow, "req_dept", 	sNull)
				Setitem(Lrow, "in_store", 	sNull)
				Setitem(Lrow, "naougu", 	sNull)
				Setitem(Lrow, "out_chk", 	sNull)
				return 1				
			end if
			 
			sRqdat = dw_pordno.getitemstring(1, "esdat")			
			sCvcod = dw_pordno.getitemstring(1, "cvcod")

			Setitem(Lrow, "hold_gu", 		sautvnd)
			Setitem(Lrow, "rqdat", 	 		sRqdat)
			Setitem(Lrow, "out_store", 	sCvcod)
			Setitem(Lrow, "in_store", 		sCvcod)
			
			select cvnas2 into :sCvnas from vndmst
			 Where cvcod = :sCvcod;
			 
			if sqlca.sqlcode <> 0 then
				Messagebox("외주거래처", "외주거래처를 검색할 수 없읍니다", stopsign!)
				Setitem(Lrow, "opseq", 		sNull)
				Setitem(Lrow, "opdsc", 		sNull)
				Setitem(Lrow, "hold_gu", 	sNull)
				Setitem(Lrow, "out_store", sNull)
				Setitem(Lrow, "req_dept", 	sNull)
				Setitem(Lrow, "in_store", 	sNull)
				Setitem(Lrow, "naougu", 	sNull)
				Setitem(Lrow, "out_chk", 	sNull)
				return 1				
			end if			 
			 
			Setitem(Lrow, "cvnas", sCvnas)
			Setitem(Lrow, "naougu",   '2')
			Setitem(Lrow, "out_chk",  '2')
			return
		End if
	End if
	
	/* 공정검색 */
	sitnbr 	= dw_pordno.getitemstring(1, "itnbr")
	stditnbr	= dw_pordno.getitemstring(1, "stditnbr")
	
	
	/********************************************************************************************/
	/* morout_copy => morout - 송수정 - 2001.09.19 */
	Select opdsc, purgc, roqty into :sOpdsc, :spurgc, :droqty
	  from morout
	 Where sabu = :gs_sabu And pordno = :spordno And opseq = :sOpseq;
   /********************************************************************************************/
	
	
	If sqlca.sqlcode <> 0 then
		Messagebox("공정", "해당품목에 공정순서가 없읍니다", stopsign!)
		Setitem(Lrow, "opseq", 		sNull)
		Setitem(Lrow, "opdsc", 		sNull)
		Setitem(Lrow, "hold_gu", 	sNull)
		Setitem(Lrow, "out_store", sNull)
		Setitem(Lrow, "req_dept", 	sNull)
		Setitem(Lrow, "in_store", 	sNull)
		Setitem(Lrow, "naougu", 	sNull)
		Setitem(Lrow, "out_chk", 	sNull)
		return 1
	End if
	
	if droqty > 0 then
		Messagebox("공정", "실적공정은 추가할 수 없읍니다", stopsign!)
		Setitem(Lrow, "opseq", 		sNull)
		Setitem(Lrow, "opdsc", 		sNull)
		Setitem(Lrow, "hold_gu", 	sNull)
		Setitem(Lrow, "out_store", sNull)
		Setitem(Lrow, "req_dept", 	sNull)
		Setitem(Lrow, "in_store", 	sNull)
		Setitem(Lrow, "naougu", 	sNull)
		Setitem(Lrow, "out_chk", 	sNull)
		return 1
	End if		
	
	/* 작업지시 공정검색 */
	
	/********************************************************************************************/
	/* morout_copy => morout - 송수정 - 2001.09.19 */
	Select purgc, wicvcod, esdat into :sPurgc, :scvcod, :sRqdat 
	  from morout
	 Where sabu = :gs_sabu and pordno = :sPordno and opseq = :soPseq;
	/********************************************************************************************/
	
	
	If sqlca.sqlcode <> 0 then
		Messagebox("공정", "작업지시되지 않은 공정입니다.", stopsign!)
		Setitem(Lrow, "opseq", 		sNull)
		Setitem(Lrow, "opdsc", 		sNull)
		Setitem(Lrow, "hold_gu", 	sNull)
		Setitem(Lrow, "out_store", sNull)
		Setitem(Lrow, "req_dept", 	sNull)
		Setitem(Lrow, "in_store", 	sNull)
		Setitem(Lrow, "naougu", 	sNull)
		Setitem(Lrow, "out_chk", 	sNull)
		return 1
	End if

	Setitem(Lrow, "opdsc", sOpdsc)
	
	if spurgc = 'N' then
		
		Select iogbn into :sautvnd from iomatrix 
		 where sabu = :gs_sabu and autpdt = 'Y';
		 
		If sqlca.sqlcode <> 0 then
			Messagebox("할당구분", "할당구분을 검색할 수 없읍니다.", stopsign!)
			Setitem(Lrow, "opseq", 		sNull)
			Setitem(Lrow, "opdsc", 		sNull)
			Setitem(Lrow, "hold_gu", 	sNull)
			Setitem(Lrow, "out_store", sNull)
			Setitem(Lrow, "req_dept", 	sNull)
			Setitem(Lrow, "in_store", 	sNull)
			Setitem(Lrow, "naougu", 	sNull)
			Setitem(Lrow, "out_chk", 	sNull)
			return 1
		End if		 

		Setitem(Lrow, "Out_store", sDepot_no)
		
		select cvnas2 into :sCvnas from vndmst
		 Where cvcod = :sDepot_no;
		 
		if sqlca.sqlcode <> 0 then
			Messagebox("소진처창고", "소진처창고를 검색할 수 없읍니다", stopsign!)
			Setitem(Lrow, "opseq", 		sNull)
			Setitem(Lrow, "opdsc", 		sNull)
			Setitem(Lrow, "hold_gu", 	sNull)
			Setitem(Lrow, "out_store", sNull)
			Setitem(Lrow, "req_dept", 	sNull)
			Setitem(Lrow, "in_store", 	sNull)
			Setitem(Lrow, "naougu", 	sNull)
			Setitem(Lrow, "out_chk", 	sNull)
			return 1				
		end if			 
		 
		Setitem(Lrow, "cvnas", sCvnas)
		Setitem(Lrow, "hold_gu",  	sAutvnd)
		Setitem(Lrow, "in_store", 	sNull)
		Setitem(Lrow, "rqdat", 		sRqdat)
		Setitem(Lrow, "naougu",   '1')
		Setitem(Lrow, "out_chk",  '1')
	Else
		
		Select iogbn into :sautvnd from iomatrix 
		 where sabu = :gs_sabu and autvnd = 'Y';		
		 
		If sqlca.sqlcode <> 0 then
			Messagebox("사급구분", "사급구분을 검색할 수 없읍니다.", stopsign!)
			Setitem(Lrow, "opseq", 		sNull)
			Setitem(Lrow, "opdsc", 		sNull)
			Setitem(Lrow, "hold_gu", 	sNull)
			Setitem(Lrow, "out_store", sNull)
			Setitem(Lrow, "req_dept", 	sNull)
			Setitem(Lrow, "in_store", 	sNull)
			Setitem(Lrow, "naougu", 	sNull)
			Setitem(Lrow, "out_chk", 	sNull)
			return 1
		End if		 		 
		
		Setitem(Lrow, "Out_store", sCvcod)		

		select cvnas2 into :sCvnas from vndmst
		 Where cvcod = :sCvcod;
		 
		if sqlca.sqlcode <> 0 then
			Messagebox("외주거래처", "외주거래처를 검색할 수 없읍니다", stopsign!)
			Setitem(Lrow, "opseq", 		sNull)
			Setitem(Lrow, "opdsc", 		sNull)
			Setitem(Lrow, "hold_gu", 	sNull)
			Setitem(Lrow, "out_store", sNull)
			Setitem(Lrow, "req_dept", 	sNull)
			Setitem(Lrow, "in_store", 	sNull)
			Setitem(Lrow, "naougu", 	sNull)
			Setitem(Lrow, "out_chk", 	sNull)
			return 1				
		end if			 
		 
		Setitem(Lrow, "cvnas", 		sCvnas)
		Setitem(Lrow, "hold_gu",  	sAutvnd)		
		Setitem(Lrow, "in_store", 	sCvcod)
		Setitem(Lrow, "rqdat", 		sRqdat)
		Setitem(Lrow, "naougu",   '2')
		Setitem(Lrow, "out_chk",  '2')
	End if

	RETURN ireturn
ElseIF GetColumnName() = "itnbr"	THEN
	sItnbr = trim(GetText())
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	// 품목구분을 검색하여 할당창고를 저장
	if ireturn = 0 then
		select ittyp into :sittyp from itemas where itnbr = :sitnbr;
		setitem(lrow, "itemas_ittyp", sittyp)
		if sittyp = '2' then
			setitem(lrow, "hold_store", sban)
			sgijun = sban
		else
			setitem(lrow, "hold_store", sjaje)
			sgijun = sjaje
		end if 
		
		select cvnas into :shname
		  from vndmst where cvcod = :sgijun;		
		 setitem(lrow, "vndmst_cvnas", shname)

		dJego_qty 	= 0;
		dValid_qty	= 0;
		sPspec		= dw_morout.getitemstring(Lrow, "pspec")
		
		// 관리창고 현재고
		dJego_qty 	= 0;
		select sum(nvl(valid_qty, 0))
		  into :djego_Qty
		  From
				(Select Nvl(Sum((jego_qty + jisi_qty + balju_qty + pob_qc_qty + gi_qc_qty + ins_qty + gita_in_qty + prod_qty) - 
				                (hold_qty + order_qty)), 0)  as valid_qty
				  From stock
				 where itnbr = :sitnbr
				 union all
				Select Nvl(sum(vnqty), 0)			as valid_qty
				  From estima
				 where sabu 	= :gs_sabu
					and itnbr 	= :sitnbr
					and blynd	IN ('1', '2'));
		dw_morout.setitem(Lrow, "stock_valid_qty", 			dJego_qty)
		
		if 	dw_morout.getitemdecimal(Lrow, "stock_valid_qty") < dw_morout.getitemdecimal(Lrow, "hold_qty")  then
			dreqqty = dw_morout.getitemdecimal(Lrow, "hold_qty") - dw_morout.getitemdecimal(Lrow, "stock_valid_qty") 
			if dreqqty < 0 then dreqqty = dreqqty * -1
			dw_morout.setitem(Lrow, "req_qty", dreqqty)
		End if
		
		// 기존 구매의뢰 수량
		Select Nvl(sum(vnqty), 0)			as valid_qty into :dgireq
		  From estima
		 where sabu 		= :gs_sabu
		 	and gu_pordno	= :spordno
			and itnbr 		= :sitnbr
			and blynd		IN ('1', '2', '3');
		dw_morout.setitem(Lrow, "gireq", dgireq)
		
		// 업체창고 현재고, 가용재고
		dupjego 	= 0
		dupvalid	= 0
		sout_store	= dw_morout.getitemstring(Lrow, "out_store")		
		select sum(nvl(jego_qty, 0)), sum(nvl(jego_qty - hold_qty, 0))
		  into :dupjego, :dupvalid
		  from stock_vendor
		 where cvcod = :sout_store and itnbr = :sitnbr and pspec = :spspec;
		if IsNull(dupjego) then dupjego = 0
		if IsNull(dupjego) then dupvalid = 0				 
		dw_morout.setitem(Lrow, "ven_jego", dupjego)
		dw_morout.setitem(Lrow, "ven_valid", dupvalid)		
		
	end if
	
	RETURN ireturn
ELSEIF GetColumnName() = "itdsc"	THEN
	sItdsc = trim(GetText())
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	// 품목구분을 검색하여 할당창고를 저장
	if ireturn = 0 then
		select ittyp into :sittyp from itemas where itnbr = :sitnbr;
		setitem(lrow, "itemas_ittyp", sittyp)
		if sittyp = '2' then
			setitem(lrow, "hold_store", sban)
			sgijun = sban
		else
			setitem(lrow, "hold_store", sjaje)
			sgijun = sjaje
		end if 
		
		select cvnas into :shname
		  from vndmst where cvcod = :sgijun;		
		 setitem(lrow, "vndmst_cvnas", shname)		
		
		dJego_qty 	= 0
		dValid_qty	= 0 
		sPspec		= dw_morout.getitemstring(Lrow, "pspec")
		
		// 관리창고 현재고
		dJego_qty 	= 0
		select sum(nvl(valid_qty, 0))
		  into :djego_Qty
		  From
				(Select Nvl(Sum((jego_qty + jisi_qty + balju_qty + pob_qc_qty + gi_qc_qty + ins_qty + gita_in_qty + prod_qty) - 
				                (hold_qty + order_qty)), 0)  as valid_qty
				  From stock
				 where itnbr = :sitnbr
				 union all
				Select Nvl(sum(vnqty), 0)			as valid_qty
				  From estima
				 where sabu 	= :gs_sabu
					and itnbr 	= :sitnbr
					and blynd	IN ('1', '2'));
		dw_morout.setitem(Lrow, "stock_valid_qty", 			dJego_qty)	
		if 	dw_morout.getitemdecimal(Lrow, "stock_valid_qty") < dw_morout.getitemdecimal(Lrow, "hold_qty")  then
			dreqqty = dw_morout.getitemdecimal(Lrow, "hold_qty") - dw_morout.getitemdecimal(Lrow, "stock_valid_qty") 
			if dreqqty < 0 then dreqqty = dreqqty * -1			
			dw_morout.setitem(Lrow, "req_qty", dreqqty)
		End if		
		
		// 기존 구매의뢰 수량
		Select Nvl(sum(vnqty), 0)			as valid_qty into :dgireq
		  From estima
		 where sabu 		= :gs_sabu
		 	and gu_pordno	= :spordno
			and itnbr 		= :sitnbr
			and blynd		IN ('1', '2', '3');
		dw_morout.setitem(Lrow, "gireq", dgireq)		
		
		// 업체창고 현재고, 가용재고
		dupjego 	= 0
		dupvalid	= 0
		sout_store	= dw_morout.getitemstring(Lrow, "out_store")		
		select sum(nvl(jego_qty, 0)), sum(nvl(jego_qty - hold_qty, 0))
		  into :dupjego, :dupvalid
		  from stock_vendor
		 where cvcod = :sout_store and itnbr = :sitnbr and pspec = :spspec;
		if IsNull(dupjego) then dupjego = 0
		if IsNull(dupjego) then dupvalid = 0				 
		dw_morout.setitem(Lrow, "ven_jego", dupjego)
		dw_morout.setitem(Lrow, "ven_valid", dupvalid)
	end if	
	
	RETURN ireturn
ELSEIF GetColumnName() = "ispec"	THEN
	sIspec = trim(GetText())
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	// 품목구분을 검색하여 할당창고를 저장
	if ireturn = 0 then
		select ittyp into :sittyp from itemas where itnbr = :sitnbr;
		setitem(lrow, "itemas_ittyp", sittyp)
		if sittyp = '2' then
			setitem(lrow, "hold_store", sban)
			sgijun = sban
		else
			setitem(lrow, "hold_store", sjaje)
			sgijun = sjaje
		end if 
		
		select cvnas into :shname
		  from vndmst where cvcod = :sgijun;		
		 setitem(lrow, "vndmst_cvnas", shname)		
		
		dJego_qty 	= 0;
		dValid_qty	= 0;
		sPspec		= dw_morout.getitemstring(Lrow, "pspec")
	
		// 관리창고 현재고
		dJego_qty 	= 0;
		select sum(nvl(valid_qty, 0))
		  into :djego_Qty
		  From
				(Select Nvl(Sum((jego_qty + jisi_qty + balju_qty + pob_qc_qty + gi_qc_qty + ins_qty + gita_in_qty + prod_qty) - 
				                (hold_qty + order_qty)), 0)  as valid_qty
				  From stock
				 where itnbr = :sitnbr
				 union all
				Select Nvl(sum(vnqty), 0)			as valid_qty
				  From estima
				 where sabu 	= :gs_sabu
					and itnbr 	= :sitnbr
					and blynd	IN ('1', '2'));
		dw_morout.setitem(Lrow, "stock_valid_qty", 			dJego_qty)		
		if dw_morout.getitemdecimal(Lrow, "stock_valid_qty") < dw_morout.getitemdecimal(Lrow, "hold_qty")  then
			dreqqty = dw_morout.getitemdecimal(Lrow, "hold_qty") - dw_morout.getitemdecimal(Lrow, "stock_valid_qty") 
			if dreqqty < 0 then dreqqty = dreqqty * -1			
			dw_morout.setitem(Lrow, "req_qty", dreqqty)
		End if		
		
		// 기존 구매의뢰 수량
		Select Nvl(sum(vnqty), 0)			as valid_qty into :dgireq
		  From estima
		 where sabu 		= :gs_sabu
		 	and gu_pordno	= :spordno
			and itnbr 		= :sitnbr
			and blynd		IN ('1', '2', '3');
		dw_morout.setitem(Lrow, "gireq", dgireq)		
		
		// 업체창고 현재고, 가용재고
		dupjego 	= 0
		dupvalid	= 0
		sout_store	= dw_morout.getitemstring(Lrow, "out_store")		
		select sum(nvl(jego_qty, 0)), sum(nvl(jego_qty - hold_qty, 0))
		  into :dupjego, :dupvalid
		  from stock_vendor
		 where cvcod = :sout_store and itnbr = :sitnbr and pspec = :spspec;
		if IsNull(dupjego) then dupjego = 0
		if IsNull(dupjego) then dupvalid = 0				 
		dw_morout.setitem(Lrow, "ven_jego", dupjego)
		dw_morout.setitem(Lrow, "ven_valid", dupvalid)		
	end if	
	RETURN ireturn
ELSEIF GetColumnName() = "jijil"	THEN
	sjijil = trim(GetText())
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	// 품목구분을 검색하여 할당창고를 저장
	if ireturn = 0 then
		select ittyp into :sittyp from itemas where itnbr = :sitnbr;
		setitem(lrow, "itemas_ittyp", sittyp)
		if sittyp = '2' then
			setitem(lrow, "hold_store", sban)
			sgijun = sban
		else
			setitem(lrow, "hold_store", sjaje)
			sgijun = sjaje
		end if 
		
		select cvnas into :shname
		  from vndmst where cvcod = :sgijun;		
		 setitem(lrow, "vndmst_cvnas", shname)		
		
		dJego_qty 	= 0;
		dValid_qty	= 0;
		sPspec		= dw_morout.getitemstring(Lrow, "pspec")
		
		// 관리창고 현재고
		dJego_qty 	= 0;
		select sum(nvl(valid_qty, 0))
		  into :djego_Qty
		  From
				(Select Nvl(Sum((jego_qty + jisi_qty + balju_qty + pob_qc_qty + gi_qc_qty + ins_qty + gita_in_qty + prod_qty) - 
				                (hold_qty + order_qty)), 0)  as valid_qty
				  From stock
				 where itnbr = :sitnbr
				 union all
				Select Nvl(sum(vnqty), 0)			as valid_qty
				  From estima
				 where sabu 	= :gs_sabu
					and itnbr 	= :sitnbr
					and blynd	IN ('1', '2'));
		dw_morout.setitem(Lrow, "stock_valid_qty", 			dJego_qty)		
		if dw_morout.getitemdecimal(Lrow, "stock_valid_qty") < dw_morout.getitemdecimal(Lrow, "hold_qty")  then
			dreqqty = dw_morout.getitemdecimal(Lrow, "hold_qty") - dw_morout.getitemdecimal(Lrow, "stock_valid_qty") 
			if dreqqty < 0 then dreqqty = dreqqty * -1			
			dw_morout.setitem(Lrow, "req_qty", dreqqty)
		End if		
		
		// 기존 구매의뢰 수량
		Select Nvl(sum(vnqty), 0)			as valid_qty into :dgireq
		  From estima
		 where sabu 		= :gs_sabu
		 	and gu_pordno	= :spordno
			and itnbr 		= :sitnbr
			and blynd		IN ('1', '2', '3');
		dw_morout.setitem(Lrow, "gireq", dgireq)		
		
		// 업체창고 현재고, 가용재고
		dupjego 	= 0
		dupvalid	= 0
		sout_store	= dw_morout.getitemstring(Lrow, "out_store")		
		select sum(nvl(jego_qty, 0)), sum(nvl(jego_qty - hold_qty, 0))
		  into :dupjego, :dupvalid
		  from stock_vendor
		 where cvcod = :sout_store and itnbr = :sitnbr and pspec = :spspec;
		if IsNull(dupjego) then dupjego = 0
		if IsNull(dupjego) then dupvalid = 0				 
		dw_morout.setitem(Lrow, "ven_jego", dupjego)
		dw_morout.setitem(Lrow, "ven_valid", dupvalid)		
	end if	
	RETURN ireturn
ELSEIF GetColumnName() = "ispec_code"	THEN
	sIspec_code = trim(GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	// 품목구분을 검색하여 할당창고를 저장
	if 	ireturn = 0 then
		select ittyp into :sittyp from itemas where itnbr = :sitnbr;
		setitem(lrow, "itemas_ittyp", sittyp)
		if sittyp = '2' then
			setitem(lrow, "hold_store", sban)
			sgijun = sban
		else
			setitem(lrow, "hold_store", sjaje)
			sgijun = sjaje
		end if 
		
		select cvnas into :shname
		  from vndmst where cvcod = :sgijun;		
		 setitem(lrow, "vndmst_cvnas", shname)		
		
		dJego_qty 	= 0;
		dValid_qty	= 0;
		sPspec		= dw_morout.getitemstring(Lrow, "pspec")
		
		// 관리창고 현재고
		dJego_qty 	= 0;
		select sum(nvl(valid_qty, 0))
		  into :djego_Qty
		  From
				(Select Nvl(Sum((jego_qty + jisi_qty + balju_qty + pob_qc_qty + gi_qc_qty + ins_qty + gita_in_qty + prod_qty) - 
				                (hold_qty + order_qty)), 0)  as valid_qty
				  From stock
				 where itnbr = :sitnbr
				 union all
				Select Nvl(sum(vnqty), 0)			as valid_qty
				  From estima
				 where sabu 	= :gs_sabu
					and itnbr 	= :sitnbr
					and blynd	IN ('1', '2'));
		dw_morout.setitem(Lrow, "stock_valid_qty", 			dJego_qty)		
		if dw_morout.getitemdecimal(Lrow, "stock_valid_qty") < dw_morout.getitemdecimal(Lrow, "hold_qty")  then
			dreqqty = dw_morout.getitemdecimal(Lrow, "hold_qty") - dw_morout.getitemdecimal(Lrow, "stock_valid_qty") 
			if dreqqty < 0 then dreqqty = dreqqty * -1			
			dw_morout.setitem(Lrow, "req_qty", dreqqty)
		End if		
		
		// 기존 구매의뢰 수량
		Select Nvl(sum(vnqty), 0)			as valid_qty into :dgireq
		  From estima
		 where sabu 		= :gs_sabu
		 	and gu_pordno	= :spordno
			and itnbr 		= :sitnbr
			and blynd		IN ('1', '2', '3');
		dw_morout.setitem(Lrow, "gireq", dgireq)		
		
		// 업체창고 현재고, 가용재고
		dupjego 	= 0
		dupvalid	= 0
		sout_store	= dw_morout.getitemstring(Lrow, "out_store")		
		select sum(nvl(jego_qty, 0)), sum(nvl(jego_qty - hold_qty, 0))
		  into :dupjego, :dupvalid
		  from stock_vendor
		 where cvcod = :sout_store and itnbr = :sitnbr and pspec = :spspec;
		if IsNull(dupjego) then dupjego = 0
		if IsNull(dupjego) then dupvalid = 0				 
		dw_morout.setitem(Lrow, "ven_jego", dupjego)
		dw_morout.setitem(Lrow, "ven_valid", dupvalid)		
	end if	
	RETURN ireturn
ELSEIF GetColumnName() = "pspec"	THEN
	spspec = trim(GetText())
	sitnbr = getitemstring(lrow, "itnbr")
	sitdsc = getitemstring(lrow, "itdsc")
	sispec = getitemstring(lrow, "ispec")
	
	// 품목구분을 검색하여 할당창고를 저장
	if ireturn = 0 then
		select ittyp into :sittyp from itemas where itnbr = :sitnbr;
		setitem(lrow, "itemas_ittyp", sittyp)
		if sittyp = '2' then
			setitem(lrow, "hold_store", sban)
			sgijun = sban
		else
			setitem(lrow, "hold_store", sjaje)
			sgijun = sjaje
		end if 
		
		select cvnas into :shname
		  from vndmst where cvcod = :sgijun;		
		 setitem(lrow, "vndmst_cvnas", shname)		
		
		dJego_qty 	= 0;
		dValid_qty	= 0;
		
		// 관리창고 현재고
		dJego_qty 	= 0;
		select sum(nvl(valid_qty, 0))
		  into :djego_Qty
		  From
				(Select Nvl(Sum((jego_qty + jisi_qty + balju_qty + pob_qc_qty + gi_qc_qty + ins_qty + gita_in_qty + prod_qty) - 
				                (hold_qty + order_qty)), 0)  as valid_qty
				  From stock
				 where itnbr = :sitnbr
				 union all
				Select Nvl(sum(vnqty), 0)			as valid_qty
				  From estima
				 where sabu 	= :gs_sabu
					and itnbr 	= :sitnbr
					and blynd	IN ('1', '2'));
		dw_morout.setitem(Lrow, "stock_valid_qty", 			dJego_qty)		
		if dw_morout.getitemdecimal(Lrow, "stock_valid_qty") < dw_morout.getitemdecimal(Lrow, "hold_qty")  then
			dreqqty = dw_morout.getitemdecimal(Lrow, "hold_qty") - dw_morout.getitemdecimal(Lrow, "stock_valid_qty") 
			if dreqqty < 0 then dreqqty = dreqqty * -1			
			dw_morout.setitem(Lrow, "req_qty", dreqqty)
		End if 
		
		// 기존 구매의뢰 수량
		Select Nvl(sum(vnqty), 0)			as valid_qty into :dgireq
		  From estima
		 where sabu 		= :gs_sabu
		 	and gu_pordno	= :spordno
			and itnbr 		= :sitnbr
			and blynd		IN ('1', '2', '3');
		dw_morout.setitem(Lrow, "gireq", dgireq)		
		
		// 업체창고 현재고, 가용재고
		dupjego 	= 0
		dupvalid	= 0
		sout_store	= dw_morout.getitemstring(Lrow, "out_store")		
		select sum(nvl(jego_qty, 0)), sum(nvl(jego_qty - hold_qty, 0))
		  into :dupjego, :dupvalid
		  from stock_vendor
		 where cvcod = :sout_store and itnbr = :sitnbr and pspec = :spspec;
		if IsNull(dupjego) then dupjego = 0
		if IsNull(dupjego) then dupvalid = 0		
		dw_morout.setitem(Lrow, "ven_jego", dupjego)
		dw_morout.setitem(Lrow, "ven_valid", dupvalid)		
		
	end if	
	
	RETURN ireturn	
	
ELSEIF GetColumnName() = "out_store"	THEN
	sout_store = trim(GetText())
	sban = getitemstring(Lrow, "hold_gu")
	
	Select autvnd into :sautvnd
	  From iomatrix where sabu = :gs_sabu And iogbn = :sBan;
	  
	select cvgu, cvnas into :sittyp, :sgijun
	  from vndmst where cvcod = :sout_store;
	if sqlca.sqlcode <> 0 then
		Messagebox("소진처", "코드가 부정확합니다", stopsign!)
		setitem(Lrow, "out_store", snull)
		setitem(Lrow, "cvnas",     snull)
		return 1
	Elseif sautvnd = 'N' and sittyp <> '5' then		// 생산출고인데 소진처가 창고가 아니면 error
		Messagebox("소진처", "사내제작이므로 창고코드를 선택하십시요", stopsign!)
		setitem(Lrow, "out_store", snull)
		setitem(Lrow, "cvnas",     snull)		
		return 1		
	Elseif sautvnd = 'Y' and sittyp =  '5' then		// 생산출고인데 소진처가 창고이면      error		
		Messagebox("소진처", "외주사급이므로 거래처코드를 선택하십시요", stopsign!)
		setitem(Lrow, "out_store", snull)
		setitem(Lrow, "cvnas",     snull)		
		return 1	
	Else
		setitem(Lrow, "cvnas", sgijun)
	End if
ELSEIF GetColumnName() = "hold_store"	THEN
	
	sout_store = trim(GetText())
	sban = getitemstring(Lrow, "hold_gu")
	
	Select autvnd into :sautvnd
	  From iomatrix where sabu = :gs_sabu And iogbn = :sBan;
	  
	select cvgu, cvnas into :sittyp, :sgijun
	  from vndmst where cvcod = :sout_store;
	if sqlca.sqlcode <> 0 then
		Messagebox("출고요청처", "코드가 부정확합니다", stopsign!)
		setitem(Lrow, "hold_store",   snull)
		setitem(Lrow, "vndmst_cvnas", snull)		
		return 1
	Elseif sautvnd = 'N' and sittyp <> '5' then		// 생산출고인데 소진처가 창고가 아니면 error
		Messagebox("출고요청처", "사내제작이므로 창고코드를 선택하십시요", stopsign!)
		setitem(Lrow, "hold_store",   snull)
		setitem(Lrow, "vndmst_cvnas", snull)
		return 1		
	Elseif sautvnd = 'Y' and sittyp =  '5' then		// 생산출고인데 소진처가 창고이면      error		
		Messagebox("출고요청처", "외주사급이므로 거래처코드를 선택하십시요", stopsign!)
		setitem(Lrow, "hold_store",   snull)
		setitem(Lrow, "vndmst_cvnas", snull)
		return 1				
	Else
		setitem(Lrow, "vndmst_cvnas", sgijun)				
	End if	
End if

end event

event rbuttondown;String colname
Long   lrow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

colname = this.getcolumnname()
lrow	  = this.getrow()
if this.accepttext() = -1 then return

if colname = "itnbr" or colname = "itdcs" or colname = "ispec" then
   gs_code = this.getitemstring(lrow, "itnbr")
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(lrow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif colname = 'out_store' then
   gs_code = this.getitemstring(lrow, "out_store")
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(lrow,"out_store",gs_code)
	this.TriggerEvent(ItemChanged!)	
elseif colname = 'hold_store' then
   gs_code = this.getitemstring(lrow, "hold_store")
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(lrow,"hold_store",gs_code)
	this.TriggerEvent(ItemChanged!)		
end if

end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type dw_head from datawindow within w_pdt_05580
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 8
integer width = 2194
integer height = 236
integer taborder = 20
string title = "none"
string dataobject = "d_pdt_05580_01"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "pordno"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "pordno", gs_code)

end if
end event

event itemchanged;String	sdata, snull

Setnull(snull)

if this.getcolumnname() = 'frdate' then
	sdata = this.gettext()
	
	if IsNull(sdata) or sdata = '' then return
	
	if f_datechk(sdata) = -1 then
		MessageBox("확인","날짜를 확인하세요.")
		this.SetItem(1,'frdata',snull)
		return 1
	end if


elseif this.getcolumnname() = 'todate' then
	sdata = this.gettext()
	
	if IsNull(sdata) or sdata = '' then return
	
	if f_datechk(sdata) = -1 then
		MessageBox("확인","날짜를 확인하세요.")
		this.SetItem(1,'todata',snull)
		return 1
	end if
elseif this.getcolumnname() = 'gubun' then
	sdata = gettext()
	if sdata = 'Y' then
		tab_1.tabpage_1.dw_momast.setfilter("isnull(pangbn)")
		tab_1.tabpage_1.dw_momast.filter()
	Else
		tab_1.tabpage_1.dw_momast.setfilter("pangbn = 'Y'")
		tab_1.tabpage_1.dw_momast.filter()		
	End if
end if

	
end event

type pb_1 from u_pb_cal within w_pdt_05580
integer x = 1664
integer y = 28
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.Setcolumn('frdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_head.SetItem(1, 'frdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_05580
integer x = 2085
integer y = 28
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.Setcolumn('todate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_head.SetItem(1, 'todate', gs_code)
end event

