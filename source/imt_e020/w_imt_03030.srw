$PBExportHeader$w_imt_03030.srw
$PBExportComments$B/L등록
forward
global type w_imt_03030 from w_inherite
end type
type rr_3 from roundrectangle within w_imt_03030
end type
type dw_1 from datawindow within w_imt_03030
end type
type cbx_1 from checkbox within w_imt_03030
end type
type rb_1 from radiobutton within w_imt_03030
end type
type rb_2 from radiobutton within w_imt_03030
end type
type rr_4 from roundrectangle within w_imt_03030
end type
type dw_detail from datawindow within w_imt_03030
end type
type pb_1 from u_pb_cal within w_imt_03030
end type
type pb_2 from u_pb_cal within w_imt_03030
end type
type pb_4 from u_pb_cal within w_imt_03030
end type
type rr_1 from roundrectangle within w_imt_03030
end type
type rr_2 from roundrectangle within w_imt_03030
end type
end forward

global type w_imt_03030 from w_inherite
boolean visible = false
integer width = 4654
string title = "B/L 등록"
rr_3 rr_3
dw_1 dw_1
cbx_1 cbx_1
rb_1 rb_1
rb_2 rb_2
rr_4 rr_4
dw_detail dw_detail
pb_1 pb_1
pb_2 pb_2
pb_4 pb_4
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_03030 w_imt_03030

type variables
char   ic_status
string is_Last_Jpno, is_Date
int    ii_Last_Jpno


end variables

forward prototypes
public subroutine wf_taborderzero ()
public subroutine wf_taborder ()
public subroutine wf_reset ()
public function integer wf_confirm_key ()
public function integer wf_delete ()
public function integer wf_dupchk (long lrow, string lcno, string balno, integer balseq)
public subroutine wf_new ()
public subroutine wf_query ()
public function integer wf_checkrequiredfield ()
end prototypes

public subroutine wf_taborderzero ();dw_detail.SetTabOrder("poblno", 0)

end subroutine

public subroutine wf_taborder ();dw_detail.SetTabOrder("poblno", 10)
dw_detail.SetColumn("poblno")
end subroutine

public subroutine wf_reset ();string   snull
integer  iNull
long		lRow

SetNull(sNull)
SetNull(iNull)
lRow  = dw_insert.GetRow()	
dw_insert.setitem(lRow, 'polcno', snull)
dw_insert.setitem(lRow, 'itnbr', snull)
dw_insert.setitem(lRow, 'itdsc', snull)
dw_insert.setitem(lRow, 'ispec', snull)
dw_insert.setitem(lRow, 'jijil', snull)
dw_insert.setitem(lRow, 'ispec_code', snull)
dw_insert.setitem(lRow, 'polchd_pocurr', snull)
dw_insert.setitem(lRow, 'baljpno', snull)
dw_insert.setitem(lRow, 'balseq', inull)
dw_insert.setitem(lRow, 'poblsq', inull)
dw_insert.setitem(lRow, 'polcdt_lcqty', 0)
dw_insert.setitem(lRow, 'polcdt_blqty', 0)
dw_insert.setitem(lRow, 'blqty', 0)
dw_insert.setitem(lRow, 'polcdt_lcprc', 0)
dw_insert.SetItem(lRow, "amt", 0)		// LC금액
dw_insert.setitem(lRow, 'saupj', snull)

end subroutine

public function integer wf_confirm_key ();/*=====================================================================
		1.	등록 mode : Key 검색
		2. Argument : None
		3.	Return Value
			- ( -1 ) : 등록된 코드 
			- (  1 ) : 신  규 코드
=====================================================================*/
string	sLcno, sConfirm

sLcno = dw_detail.GetItemString(1, "poblno")

SELECT "POBLNO"
  INTO :sConfirm
  FROM "POLCBLHD"  
 WHERE ( "SABU" = :gs_sabu )		AND
 		 ( "POBLNO" = :sLcno )  ;
			
IF sqlca.sqlcode = 0 	then	
	f_message_chk(1, "")
	dw_detail.setcolumn("poblno")
	dw_detail.SetFocus()
	RETURN  -1 
END IF
RETURN  1

end function

public function integer wf_delete ();long	lRow, lRowCount


lRowCount = dw_insert.RowCount()

FOR  lRow = lRowCount 	TO	 1		STEP -1
	
	dw_insert.DeleteRow(lRow)
	
NEXT


RETURN 1
end function

public function integer wf_dupchk (long lrow, string lcno, string balno, integer balseq);//long   lReturnRow
//String sname
//
//sname = lcno + balno + string(balseq)
//
//lReturnRow = dw_list.Find("dupchk = '"+sname+"' ", 1, dw_list.RowCount())
//
//if lrow = 99999999 then 
//	IF (lReturnRow <> 0)		THEN
//	
//		f_message_chk(37,'[L/C번호-발주번호-항번]') 
//		
//		RETURN  -1
//	END IF	
//else
//	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
//	
//		f_message_chk(37,'[L/C번호-발주번호-항번]') 
//		
//		RETURN  -1
//	END IF	
//end if
RETURN 1
end function

public subroutine wf_new ();ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

///////////////////////////////////////////////
dw_detail.setredraw(false)

dw_detail.reset()
dw_detail.insertrow(0)
dw_detail.setitem(1, "sabu", gs_sabu)

wf_TabOrder()
dw_detail.setredraw(true)
///////////////////////////////////////////////
dw_detail.enabled = true
dw_insert.enabled = true

p_mod.enabled = true
p_del.enabled = false
p_addrow.enabled = true
p_delrow.enabled = true
p_ins.enabled = true

p_inq.enabled = true

p_mod.PictureName = "C:\erpman\image\저장_up.gif"
p_del.PictureName = "C:\erpman\image\삭제_d.gif"
p_addrow.PictureName = "C:\erpman\image\행추가_up.gif"
p_delrow.PictureName = "C:\erpman\image\행삭제_up.gif"
p_ins.PictureName    = "C:\erpman\image\추가_up.gif"

dw_detail.SetFocus()

rb_1.checked = true
rb_2.checked = false

ib_any_typing = false


end subroutine

public subroutine wf_query ();w_mdi_frame.sle_msg.text = "조회"
ic_Status = '2'

wf_TabOrderZero()
dw_detail.SetFocus()
	
// button
p_mod.enabled = true
p_del.enabled = true
//cb_insert.enabled = false

p_mod.PictureName = "C:\erpman\image\저장_up.gif"
p_del.PictureName = "C:\erpman\image\삭제_up.gif"



end subroutine

public function integer wf_checkrequiredfield ();string	sBlno,    sVendor, 	&
			sRcvdat,  sDesdat,	&
			sEntfoct, sEntdat,	&
			sOrigin,  sPort, sInsno, spolcno
dec		dQty
long		lRow, lcount, dseq

///////////////////////////////////////////////////////////////////////
// * 통관일자
///////////////////////////////////////////////////////////////////////
sEntdat = trim(dw_detail.GetItemString(1, "entdat"))
IF Not IsNull(sEntdat) 		THEN
	MessageBox("확인", "통관된 자료는 통관일자를 수정할 수 없습니다.")
	dw_detail.SetColumn("poblno")
	dw_detail.SetFocus()
	RETURN -1
END IF

// B/L 번호
sBlno = dw_detail.GetItemString(1, "poblno")
IF ic_status = '1' and cbx_1.checked = true THEN  //자동채번여부
	IF IsNull(sBlno) 	or   sBlno = ''	THEN
		dSeq = SQLCA.FUN_JUNPYO(gs_Sabu, is_today, 'L0')
		if dSeq = -1 then 
			rollback;
			f_message_chk(51, '')
			return -1
		end if
		Commit;
		sInsno = is_today + String(dseq, '0000')
		dw_detail.setitem(1, 'poblno', sinsno)
		
		sBlno = sInsNo
	END IF
ELSE
	IF IsNull(sBlno) 	or   sBlno = ''	THEN
		f_message_chk(30,'[B/L 번호]')		
		dw_detail.SetColumn("poblno")
		dw_detail.SetFocus()
		RETURN -1
	END IF
END IF

// 운송회사
sVendor = dw_detail.GetItemString(1, "tra_cvcod")
//IF ic_status = '1' and rb_1.checked = true  THEN  // BL 인 경우
//	IF IsNull(sVendor) 	or   sVendor = ''	THEN
//		f_message_chk(30,'[관세사]')		
//		dw_detail.SetColumn("tra_cvcod")
//		dw_detail.SetFocus()
//		RETURN -1
//	END IF
//END IF

// 접수일자
sRcvdat = trim(dw_detail.GetItemString(1, "rcvdat"))
IF IsNull(sRcvdat) 	or   sRcvdat = ''	THEN
	f_message_chk(30,'[접수일자]')		
	dw_detail.SetColumn("Rcvdat")
	dw_detail.SetFocus()
	RETURN -1
END IF
	
// 통관예정일자
sEntfoct = trim(dw_detail.GetItemString(1, "Entfoct"))
IF ic_status = '1' and rb_1.checked = true  THEN  // BL 인 경우
	IF IsNull(sEntfoct) 	or   sEntfoct = ''	THEN
		f_message_chk(30,'[통관예정일자]')		
		dw_detail.SetColumn("Entfoct")
		dw_detail.SetFocus()
		RETURN -1
	END IF
END IF

// 도착일자
sDesdat = trim(dw_detail.GetItemString(1, "Desdat"))
//IF ic_status = '1' and rb_1.checked = true  THEN  // BL 인 경우
//	IF IsNull(sDesdat) 	or   sDesdat = ''	THEN
//		f_message_chk(30,'[도착일자]')		
//		dw_detail.SetColumn("Desdat")
//		dw_detail.SetFocus()
//		RETURN -1
//	END IF
//END IF

// 원산지명
sOrigin = dw_detail.GetItemString(1, "origin")

// 발송항
sPort = dw_detail.GetItemString(1, "port_dispatch")


///////////////////////////////////////////////////////////////////////
//	* B/L 자료 저장
///////////////////////////////////////////////////////////////////////

lcount = dw_insert.RowCount()

FOR	lRow = 1		TO		lcount
	spolcno = trim(dw_insert.GetItemString(lRow, "polcno"))
	IF IsNull(spolcno) or spolcno = ''	THEN
		f_message_chk(30,'[L/C 번호]')		
		dw_insert.SetColumn("polcno")
		dw_insert.SetRow(lRow)
		dw_insert.SetFocus()
		RETURN -1
	END IF

	
	dQty = dw_insert.GetItemDecimal(lRow, "blqty")
	IF IsNull(dQty) or dQty = 0	THEN
		f_message_chk(30,'[B/L 수량]')		
		dw_insert.SetColumn("blqty")
		dw_insert.SetRow(lRow)
		dw_insert.SetFocus()
		RETURN -1
	END IF


	dw_insert.SetItem(lRow, "sabu", gs_sabu)
	
	if rb_1.checked then 
		dw_insert.SetItem(lRow, "bigub", '1')
	else
		dw_insert.SetItem(lRow, "bigub", '2')
	end if

	dw_insert.SetItem(lRow, "poblno", sBlno)	
	dw_insert.SetItem(lRow, "rcvdat", sRcvdat)
	dw_insert.SetItem(lRow, "desdat", sDesdat)
	dw_insert.SetItem(lRow, "entfoct", sEntfoct)
	dw_insert.SetItem(lRow, "tra_cvcod", sVendor)
	dw_insert.SetItem(lRow, "origin", sOrigin)
	dw_insert.SetItem(lRow, "port_dispatch", sPort)


	/////////////////////////////////////////////////////////////////////////
	//	1. 등록시 : 순번 입력
	/////////////////////////////////////////////////////////////////////////	
	IF ic_status = '1'	THEN
			dw_insert.SetItem(lRow, "pobseq", lRow)		
	END IF
	
	/////////////////////////////////////////////////////////////////////////
	//	1. 수정시 -> 행추가된 data의 의뢰번호 : 최종순번 + 1 ->SETITEM
	// 2. 전표번호가 NULL 인것만 최종순번 + 1 		
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		int	iSeq
		iSeq = dw_insert.GetitemNumber(lRow, "pobseq")
		IF IsNull(iSeq)	OR 	iSeq = 0 	THEN
			ii_Last_Jpno++
			dw_insert.SetItem(lRow, "pobseq", ii_Last_Jpno)
		END IF
	END IF
	
NEXT

RETURN 1
end function

on w_imt_03030.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_4=create rr_4
this.dw_detail=create dw_detail
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_4=create pb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rr_4
this.Control[iCurrent+7]=this.dw_detail
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.pb_4
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rr_2
end on

on w_imt_03030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_4)
destroy(this.dw_detail)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_detail.settransobject(sqlca)
dw_insert.settransobject(sqlca)

is_Date = f_Today()

p_can.TriggerEvent("clicked")
end event

type dw_insert from w_inherite`dw_insert within w_imt_03030
integer x = 27
integer y = 448
integer width = 4562
integer height = 1872
integer taborder = 20
string dataobject = "d_imt_03031"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;string	sLcno, sBlno, sNull, sitnbr, sitdsc, sispec, sjijil, sispec_code, scurr, &
         sbalno, smagub, sLocalyn, ssaupj
dec		dBlQty, dLc_BlQty, dOpenQty, dprice, dqty, dlcqty, doldqty, djblqty
dec      dunamt, dbalqty
int		iSeq,	iCount, get_count
long		lRow
SetNull(sNull)

lRow  = this.GetRow()	

// LC번호 확인
IF this.GetColumnName() = 'polcno'	THEN
   sLcno = this.gettext()
	sBlno = dw_detail.GetItemString(1, "poblno")
	
   if sLcno = '' or isnull(sLcno) then 
		wf_reset()
		return 1
	else //l/c 완료여부 check
	   SELECT "POLCHD"."POMAGA", "POLCHD"."LOCALYN"
		  INTO :sMagub, :sLocalyn  
		  FROM "POLCHD"  
		 WHERE ( "POLCHD"."SABU"   = :gs_sabu ) AND  
				 ( "POLCHD"."POLCNO" = :sLcno )   ;
				 
		IF SQLCA.SQLCODE <> 0 THEN 
			f_message_chk(33,'[L/C 번호]')		
			wf_reset()
			return 1
		ELSE
			if sMagub = 'Y' then 
				Messagebox("확 인", "L/C 완료처리된 자료는 선택할 수 없읍니다", stopsign!)
				wf_reset()
				return 1
			elseif slocalyn = 'Y' then
				Messagebox("L/C구분", "LOCAL L/C는 인수증에서 등록하십시요", stopsign!)
				wf_reset()
				return 1
			end if
		END IF
   end if	
 
   SELECT COUNT(*), MAX(B.BALJPNO), MAX(B.BALSEQ), MAX(C.ITNBR), MAX(D.ITDSC), MAX(D.ISPEC),
			 MAX(F.POCURR), MAX(D.JIJIL), MAX(D.ISPEC_CODE),
			 MAX(B.LCQTY), MAX(B.LCPRC), MAX(B.BLQTY), MAX(C.SAUPJ), MAX(C.BALQTY), MAX(C.UNAMT)
     INTO :get_count, :sbalno, :iseq, :sitnbr, :sitdsc, :sispec, 
	       :scurr, :sjijil, :sispec_code, 
	       :dlcqty, :dprice, :dblqty, :ssaupj, :dbalqty, :dunamt
     FROM POLCDT B, POBLKT C, ITEMAS D, POLCHD F 
    WHERE ( B.SABU = C.SABU AND B.BALJPNO = C.BALJPNO AND B.BALSEQ = C.BALSEQ ) AND 
          ( B.SABU = F.SABU AND B.POLCNO = F.POLCNO ) AND 
          ( C.ITNBR = D.ITNBR(+) ) AND 
          ( B.SABU = :gs_sabu AND B.POLCNO = :slcno )  ;
	
	if get_count = 1 then 
		this.setitem(lRow, 'baljpno', sbalno)
		this.setitem(lRow, 'balseq', iseq)
//		if wf_dupchk(lrow, slcno, sbalno, iseq) = -1 then 
//			wf_reset()
//			return 1
//		end if	
		this.setitem(lRow, 'itnbr', sitnbr)
		this.setitem(lRow, 'itdsc', sitdsc)
		this.setitem(lRow, 'ispec', sispec)
		this.setitem(lRow, 'jijil', sjijil)
		this.setitem(lRow, 'ispec_code', sispec_code)
		this.setitem(lRow, 'saupj', ssaupj)
		this.setitem(lRow, 'polchd_pocurr', scurr)
		this.setitem(lRow, 'polcdt_lcqty', dlcqty)
		this.setitem(lRow, 'polcdt_blqty', dblqty)
		this.setitem(lRow, 'blqty', dlcqty - dblqty )
		this.setitem(lRow, 'polcdt_lcprc', dprice)

		//this.SetItem(lRow, "amt", ( dlcqty - dblqty ) * dPrice)		// LC금액
		
		// 금액은 발주금액을 발주수량으로 나눈 단가로 수량을 곱한다
		this.setitem(lRow, 'amt', ( dlcqty - dblqty ) * (dunamt / dbalqty))
	
	elseif get_count > 1 then 
		gs_code = slcno
		open(w_lc_detail_popup3)
		if gs_code = '' or isnull(gs_code) then 
			wf_reset()
			return 1
		else
			iseq = integer(gs_gubun)
			this.setitem(lRow, 'baljpno', gs_codename)
			this.setitem(lRow, 'balseq', iseq)
			if wf_dupchk(lrow, gs_code, gs_codename, iseq) = -1 then 
				wf_reset()
				return 1
			end if	
			SELECT C.ITNBR, D.ITDSC, D.ISPEC, F.POCURR, D.JIJIL, D.ISPEC_CODE, 
			       B.LCQTY, B.LCPRC, B.BLQTY, C.SAUPJ, C.BALQTY, C.UNAMT 
			  INTO :sitnbr, :sitdsc, :sispec, :scurr, :sjijil, :sispec_code, 
			       :dlcqty, :dprice, :dblqty, :ssaupj, :dbalqty, :dunamt
			  FROM POLCDT B, POBLKT C, ITEMAS D, POLCHD F  
			 WHERE ( B.SABU = C.SABU AND B.BALJPNO = C.BALJPNO AND B.BALSEQ = C.BALSEQ ) AND 
		          ( B.SABU = F.SABU AND B.POLCNO = F.POLCNO ) AND 
					 ( C.ITNBR = D.ITNBR(+)) AND 
					 ( B.SABU = :gs_sabu AND B.POLCNO = :slcno ) AND
					 ( B.BALJPNO = :gs_codename AND B.BALSEQ = :iseq )  ;
			
			this.setitem(lRow, 'itnbr', sitnbr)
			this.setitem(lRow, 'itdsc', sitdsc)
			this.setitem(lRow, 'ispec', sispec)
			this.setitem(lRow, 'jijil', sjijil)
			this.setitem(lRow, 'ispec_code', sispec_code)
			this.setitem(lRow, 'saupj', ssaupj)
			this.setitem(lRow, 'polchd_pocurr', scurr)
			this.setitem(lRow, 'polcdt_lcqty', dlcqty)
			this.setitem(lRow, 'polcdt_blqty', dblqty)
			this.setitem(lRow, 'blqty', dlcqty - dblqty )
			this.setitem(lRow, 'polcdt_lcprc', dprice)
			//this.SetItem(lRow, "amt", ( dlcqty - dblqty ) * dPrice)		// LC금액
			
			// 금액은 발주금액을 발주수량으로 나눈 단가로 수량을 곱한다
			this.setitem(lRow, 'amt', ( dlcqty - dblqty ) * (dunamt / dbalqty))
   	end if				
	else
		f_message_chk(33,'[L/C 번호]')		
		wf_reset()
		return 1
	end if	
	
	SELECT MAX(POBLSQ)
	  INTO :iCount
	  FROM POLCBL
	 WHERE SABU = :gs_sabu	and POBLNO <> :sBlno	and POLCNO = :slcno ;
	
	IF isnull(iCount) OR iCount = 0 then
		icount = 1
	ELSE
   	iCount++
	END IF	
	
	this.SetItem(lRow, "poblsq", iCount)
END IF
////////////////////////////////////////////////////////////////////////////
//// 발주번호 CHECK
////////////////////////////////////////////////////////////////////////////
//IF this.getcolumnname() = "baljpno" 	THEN
//	
//	sLcno 	= this.GetItemString(lRow, "polcno")
//	iSeq		= this.GetItemNumber(lRow, "balseq")
//	sBaljpno = this.GetText()
//	
//	IF ( Not IsNull(sLcno) ) 	and   ( iSeq <> 0 )	THEN
//		IF wf_Lc_Check(lRow, sLcno, sBaljpno, iSeq) = -1	THEN
//			this.SetItem(lRow, "baljpno", sNull)
//			this.SetItem(lRow, "balseq",  0)
//			RETURN 1
//		END IF
//	END IF
//	
//END IF
//
//
////////////////////////////////////////////////////////////////////////////
//// 발주항번 CHECK
////////////////////////////////////////////////////////////////////////////
//IF this.getcolumnname() = "balseq" 	THEN
//
//	sLcno 	= this.GetItemString(lRow, "polcno")
//	iSeq		= integer(this.GetText())
//	sBaljpno = this.GetItemString(lRow, "baljpno")
//	
//	IF ( Not IsNull(sLcno) ) 	and   ( Not IsNull(sBaljpno) )	THEN
//		IF wf_Lc_Check(lRow, sLcno, sBaljpno, iSeq) = -1	THEN
//			this.SetItem(lRow, "balseq",  0)
//			RETURN 1
//		END IF
//	END IF
//	
//END IF

// B/L수량 + LC의 B/L수량 > LC의 OPEN수량 -> ERROR
IF this.getcolumnname() = "blqty" 	THEN
	dOldQty   = this.GetITemDecimal(lRow, "blqty")

 	dBlQty 	 = dec(this.GetText())
	djBlQty   = this.GetITemDecimal(lRow, "jblqty")
	
	dLc_BlQty = this.GetITemDecimal(lRow, "polcdt_blqty")
	dOpenQty  = this.GetITemDecimal(lRow, "polcdt_lcqty")
	
	IF dBlqty + dLc_Blqty - djblqty > dOpenQty		THEN
		MessageBox("확인", "B/L수량 + L/C의 B/L수량은~r" + "L/C의 OPEN수량보다 클수 없습니다.")
		this.SetItem(lRow, "blqty", doldqty)
		RETURN 1
	END IF
	
END IF



end event

event dw_insert::itemerror;call super::itemerror;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column 이 아닌 Column 에서 Error 발생시 
//
//IF ib_ItemError = true	THEN	
//	ib_ItemError = false		
//	RETURN 1
//END IF
//
//
//
////	2) Required Column  에서 Error 발생시 
//
//string	sColumnName
//sColumnName = dwo.name + "_t.text"
//
//
//sle_message_line.text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."
//
RETURN 1
	
	
end event

event dw_insert::losefocus;call super::losefocus;this.AcceptText()
end event

event dw_insert::rbuttondown;call super::rbuttondown;long	 lRow
string sitnbr, sitdsc, sispec, slocalyn, sMagub, sjijil, sispec_code, scurr, sSaupj
int	 iCount, iseq
decimal dqty, dprice, dlcqty, dblqty, dbalqty, dunamt

lRow  = this.GetRow()	
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// LC번호
IF this.GetColumnName() = 'polcno'	THEN

	string	sBlno
	sBlno = dw_detail.GetItemString(1, "poblno")

	open(w_lc_detail_popup2)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	
	SELECT "POLCHD"."POMAGA", "POLCHD"."LOCALYN"
	  INTO :sMagub, :sLocalyn  
	  FROM "POLCHD"  
	 WHERE ( "POLCHD"."SABU"   = :gs_sabu ) AND  
			 ( "POLCHD"."POLCNO" = :gs_code )   ;
			 
	IF SQLCA.SQLCODE <> 0 THEN 
		f_message_chk(33,'[L/C 번호]')		
		return 
	ELSE
		if sMagub = 'Y' then 
			Messagebox("확 인", "L/C 완료처리된 자료는 선택할 수 없읍니다", stopsign!)
			return 
		elseif slocalyn = 'Y' then
			Messagebox("L/C구분", "LOCAL L/C는 인수증에서 등록하십시요", stopsign!)
			return
		end if
	END IF
	
	iseq = integer(gs_gubun)
	
	this.setitem(lRow, 'polcno', gs_code )
	this.setitem(lRow, 'baljpno', gs_codename)
	this.setitem(lRow, 'balseq', iseq)
   
	if wf_dupchk(lrow, gs_code, gs_codename, iseq) = -1 then 
		wf_reset()
		return 1
	end if	

	SELECT C.ITNBR, D.ITDSC, D.ISPEC, D.JIJIL, D.ISPEC_CODE, 
	       B.LCQTY, B.LCPRC, B.BLQTY, NVL(B.LCQTY,0) - NVL(B.BLQTY,0), F.POCURR, C.SAUPJ , C.BALQTY, C.UNAMT
     INTO :sitnbr, :sitdsc, :sispec, :sjijil, :sispec_code, 
	       :dlcqty, :dprice, :dblqty, :dqty,   :scurr, :sSaupj, :dbalqty, :dunamt
     FROM POLCDT B, POBLKT C, ITEMAS D, POLCHD F 
    WHERE ( B.SABU = F.SABU AND B.POLCNO = F.POLCNO ) AND 
          ( B.SABU = C.SABU AND B.BALJPNO = C.BALJPNO AND B.BALSEQ = C.BALSEQ ) AND 
          ( C.ITNBR = D.ITNBR(+) ) AND 
          ( B.SABU = :gs_sabu AND B.POLCNO = :gs_code AND
            B.BALJPNO = :gs_codename AND B.BALSEQ = :iseq )  ;
	
	this.setitem(lRow, 'itnbr', sitnbr)
	this.setitem(lRow, 'itdsc', sitdsc)
	this.setitem(lRow, 'ispec', sispec)
	this.setitem(lRow, 'jijil', sjijil)
	this.setitem(lRow, 'ispec_code', sispec_code)
	this.setitem(lRow, 'polchd_pocurr', scurr)
	this.setitem(lRow, 'polcdt_lcqty', dlcqty)
	this.setitem(lRow, 'polcdt_blqty', dblqty)
	this.setitem(lRow, 'blqty', dqty)
	this.setitem(lRow, 'polcdt_lcprc', dprice)

	//this.SetItem(lRow, "amt", dQty * dPrice)		// LC금액

	// 금액은 발주금액을 발주수량으로 나눈 단가로 수량을 곱한다
	this.setitem(lRow, 'amt', ( dQty ) * (dunamt / dbalqty))
	
	this.setitem(lRow, 'saupj', ssaupj)

	SELECT MAX(POBLSQ)
	  INTO :iCount
	  FROM POLCBL
	 WHERE SABU = :gs_sabu		and
			 POBLNO <> :sBlno		and
			 POLCNO = :gs_code ;

	IF isnull(iCount) OR iCount = 0 then
		icount = 1
	ELSE
   	iCount++
	END IF	

	this.SetItem(lRow, "poblsq", iCount)
ELSEIF this.GetColumnName() = 'itnbr'	THEN
	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	SetItem(lRow,"itemas_itdsc",gs_codename)
	SetItem(lRow,"itemas_ispec",gs_gubun)
	
	this.TriggerEvent("itemchanged")
ELSEIF this.GetColumnName() = "itdsc"	THEN
	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	SetItem(lRow,"itemas_itdsc",gs_codename)
	SetItem(lRow,"itemas_ispec",gs_gubun)
	
	this.TriggerEvent("itemchanged")
ELSEIF this.GetColumnName() = "ispec"	THEN
	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	SetItem(lRow,"itemas_itdsc",gs_codename)
	SetItem(lRow,"itemas_ispec",gs_gubun)
	
	this.TriggerEvent("itemchanged")
END IF
end event

event dw_insert::updatestart;call super::updatestart;/* Update() function 호출시 user 설정 */
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

event dw_insert::editchanged;call super::editchanged;long	lRow
lRow = this.GetRow()

IF this.getcolumnname() = "blqty" 				or 	&
	this.getcolumnname() = "polcdt_lcprc"		THEN

	this.AcceptText()

	dec	dQty, dPrice, dAmt
	dQty   = this.getitemdecimal(lRow, "blqty") 
	dPrice = this.getitemdecimal(lRow, "polcdt_lcprc")
	
   this.SetItem(lRow, "amt", dQty * dPrice)		// LC금액

END IF






end event

type p_delrow from w_inherite`p_delrow within w_imt_03030
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;string sblno
long	lrow, lcount
lRow = dw_insert.GetRow()

IF lRow < 1		THEN	RETURN

// 물대비용이 등록된 경우에는 수정불가
SELECT COUNT(*)  INTO :lcount
  FROM IMPEXP 
 WHERE SABU = :gs_sabu AND POBLNO = :sBlno and mulgu = 'Y'  ;
 
IF lcount > 0 then 
	MessageBox("확인", "구매결제된 B/L번호는 삭제할 수 없습니다.")
	RETURN 
END IF	

//IF f_msg_delete() = -1 THEN	RETURN

dw_insert.DeleteRow(lRow)
//sBlno = trim(dw_detail.GetItemString(1, "poblno"))
//
//if dw_insert.rowcount() < 1 then
//	
//	// 수입비용이 등록된 경우에는 수정불가
//	SELECT COUNT(*)  INTO :lcount
//	  FROM IMPEXP 
//	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno;
//	 
//	IF lcount > 0 then 
//		MessageBox("확인", "수입비용이 등록된 B/L번호는 삭제할 수 없습니다.")
//		RETURN 
//	END IF		
//	
//	// HEAD삭제
//	DELETE POLCBLHD
//	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno   ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		rollback;
//		MESSAGEBOX("B/L-HEAD", "B/L-HEAD삭제시 오류가 발생", stopsign!)
//		return
//	END IF	
//end if
//

ib_any_typing = true

end event

type p_addrow from w_inherite`p_addrow within w_imt_03030
integer taborder = 50
end type

event p_addrow::clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_insert) = -1	then	return


//////////////////////////////////////////////////////////
long		lRow
string  	sBlno

sBlno	= dw_detail.getitemstring(1, "poblno")
IF rb_1.checked = true and  isnull(sBlno) or sBlno = "" 	THEN
	f_message_chk(30,'[B/L 번호]')
	dw_detail.SetColumn("poblno")
	dw_detail.SetFocus()
	RETURN
END IF

lRow = dw_insert.InsertRow(0)

dw_insert.ScrollToRow(lRow)
dw_insert.SetColumn("polcno")
dw_insert.SetFocus()

ib_any_typing = true
end event

type p_search from w_inherite`p_search within w_imt_03030
boolean visible = false
integer x = 2501
integer y = 12
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_imt_03030
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_insert) = -1	then	return

//////////////////////////////////////////////////////////
long	 k, lcurrow
string sopt, spolcno, sblno, sbajno, slocalyn
int	 iCount, ibaseq
decimal dqty, dprice, dbalqty, dunamt

sBlno	= dw_detail.getitemstring(1, "poblno")

Setnull(gs_code)
open(w_lc_detail_popup)
if Isnull(gs_code) or Trim(gs_code) = "" then return
dw_1.reset()
dw_1.ImportClipboard()

FOR k=1 TO dw_1.rowcount()
	sopt = dw_1.getitemstring(k, 'opt')
	if sopt = 'Y' then 
		sPolcno = dw_1.getitemstring(k, 'polcdt_polcno')
		sbajno  = dw_1.getitemstring(k, 'polcdt_baljpno')
		ibaseq  = dw_1.getitemnumber(k, 'polcdt_balseq')
//		if wf_dupchk(99999999, spolcno, sbajno, ibaseq) = -1 then 
//			continue 
//		end if	

		// L/C내역이 local인 내역은 무시
		select localyn into :slocalyn from polchd
		 where sabu = :gs_sabu and polcno = :spolcno;
		if slocalyn = 'Y' then 
			Messagebox("Local", "L/C-NO : " + spolcno + " 는 Local L/C입니다", stopsign!)
			continue
		end if

		lcurrow = dw_insert.insertrow(0)
		
		dw_insert.SetItem(lcurrow, "sabu", gs_sabu)
		
		if rb_1.checked then 
			dw_insert.SetItem(lcurrow, "bigub", '1')
		else
			dw_insert.SetItem(lcurrow, "bigub", '2')
		end if

		dw_insert.setitem(lcurrow, 'polcno', sPolcno )
		dw_insert.setitem(lcurrow, 'baljpno', sbajno)
		dw_insert.setitem(lcurrow, 'balseq', ibaseq)
		dw_insert.setitem(lcurrow, 'itnbr', dw_1.getitemstring(k, 'poblkt_itnbr' ))
		dw_insert.setitem(lcurrow, 'itdsc', dw_1.getitemstring(k, 'itemas_itdsc' ))
		dw_insert.setitem(lcurrow, 'ispec', dw_1.getitemstring(k, 'itemas_ispec' ))
		dw_insert.setitem(lcurrow, 'jijil', dw_1.getitemstring(k, 'itemas_jijil' ))
		dw_insert.setitem(lcurrow, 'ispec_code', dw_1.getitemstring(k, 'itemas_ispec_code' ))
		dw_insert.setitem(lcurrow, 'saupj', dw_1.getitemstring(k, 'poblkt_saupj' ))
		dw_insert.setitem(lcurrow, 'polchd_pocurr', dw_1.getitemstring(k, 'polchd_pocurr' ))
		dw_insert.setitem(lcurrow, 'polcdt_lcqty', dw_1.getitemdecimal(k, 'polcdt_lcqty' ))
		dw_insert.setitem(lcurrow, 'polcdt_blqty', dw_1.getitemdecimal(k, 'polcdt_blqty' ))
		dw_insert.setitem(lcurrow, 'blqty', dw_1.getitemdecimal(k, 'janqty' ))
		dw_insert.setitem(lcurrow, 'polcdt_lcprc', dw_1.getitemdecimal(k, 'polcdt_lcprc' ))
		dQty   = dw_1.getitemdecimal(k, 'janqty' )
		dPrice = dw_1.getitemdecimal(k, "polcdt_lcprc")
		
		//dw_insert.SetItem(lcurrow, "amt", dQty * dPrice)		// LC금액
      
		dunamt = dw_1.getitemdecimal(k, 'unamt')
		dbalqty = dw_1.getitemdecimal(k, 'balqty')
		dw_insert.setitem(lcurrow, 'amt', ( dQty ) * (dunamt / dbalqty))
		
		SELECT MAX(POBLSQ)
		  INTO :iCount
		  FROM POLCBL
		 WHERE SABU = :gs_sabu		and
				 POBLNO <> :sBlno		and
				 POLCNO = :sPolcno ;

		IF isnull(iCount) OR iCount = 0 then
			icount = 1
		ELSE
			iCount++
		END IF	

		dw_insert.SetItem(lcurrow, "poblsq", iCount)
	end if	
NEXT
dw_1.reset()
dw_insert.ScrollToRow(lcurrow)
dw_insert.SetColumn("polcno")
dw_insert.SetFocus()

ib_any_typing = true
end event

type p_exit from w_inherite`p_exit within w_imt_03030
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_imt_03030
integer taborder = 90
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

Rollback ;

wf_New()

dw_insert.Reset()


end event

type p_print from w_inherite`p_print within w_imt_03030
boolean visible = false
integer x = 2309
integer y = 16
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_imt_03030
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sBlno,		&
			sDate,		&
			sNull
int      get_count			
			
SetNull(sNull)

sBlno	= dw_detail.getitemstring(1, "poblno")

IF isnull(sBlno) or sBlno = "" 	THEN
	f_message_chk(30,'[B/L번호]')
	dw_detail.SetColumn("poblno")
	dw_detail.SetFocus()
	RETURN
END IF

//////////////////////////////////////////////////////////////////////////
dw_detail.SetRedraw(False)

IF dw_detail.Retrieve(gs_Sabu, sBlno) < 1	THEN
	f_message_chk(50, '[B/L번호]')
	dw_detail.setcolumn("poblno")
	dw_detail.setfocus()

	ib_any_typing = False
	p_can.TriggerEvent("clicked")
	RETURN
END IF

dw_detail.SetRedraw(True)

IF dw_insert.Retrieve(gs_Sabu, sBlno) < 1 THEN 
	f_message_chk(50, '[L/C번호]')
	dw_detail.setcolumn("poblno")
	dw_detail.setfocus()
	RETURN
END IF

SELECT COUNT(*) INTO :get_count
  FROM (SELECT DISTINCT INVOICE_NO FROM POLCBL 
         WHERE SABU = :gs_sabu AND POBLNO = :sblno AND INVOICE_NO IS NOT NULL) ;

dw_detail.setitem(1, 'incount', get_count)
/////////////////////////////////////////////////////////////////////////
// * 조회된 '구매L/C품목정보'의 발주번호는 수정할 수 없음
////////////////////////////////////////////////////////////////////////////

wf_Query()
dw_detail.SetFocus()

//////////////////////////////////////////////////////////////////////////
//	* 통관일자가 입력된 자료는 수정할 수 없음
//////////////////////////////////////////////////////////////////////////
string	sGubun, sMagam, staxno, sbigub
sMagam = dw_detail.GetItemString(1, "magyeo")
staxno = dw_detail.GetItemString(1, "taxno")

long lmacnt 

lmacnt = 0
select count(*) into :lmacnt from polcbl
 where sabu = :gs_sabu and poblno = :sblno and magyeo = 'Y';

IF lmacnt > 0 or not isnull(staxno) or sbigub = '2' THEN 
	if lmacnt > 0 then
		w_mdi_frame.sle_msg.text = '마감된 자료는 수정할 수 없습니다.'	
	elseif not isnull(staxno) then
		w_mdi_frame.sle_msg.text = '결제된 자료는 수정할 수 없읍니다.'
	elseif not isnull(sbigub) then
		w_mdi_frame.sle_msg.text = '인수증 자료는 수정할 수 없읍니다.'		
		rb_2.checked = true
	end if
	
	dw_detail.enabled = false
   dw_insert.enabled = false	
	
	p_mod.enabled = false	
	p_del.enabled = false	
	p_addrow.enabled = false	
	p_delrow.enabled = false	
	p_ins.enabled = false

	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	p_addrow.PictureName = "C:\erpman\image\행추가_d.gif"
	p_delrow.PictureName = "C:\erpman\image\행삭제_d.gif"
	p_ins.PictureName    = "C:\erpman\image\추가_d.gif"
	
	ib_any_typing = False
	RETURN 
END IF	

sGubun = dw_detail.GetItemString(1, "entdat")

IF NOT IsNull(sGubun)  	THEN	
	dw_detail.enabled = false
	dw_insert.enabled = false	

	p_mod.enabled = false	
	p_del.enabled = false	
	p_addrow.enabled = false	
	p_delrow.enabled = false	
	p_ins.enabled = false

	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	p_addrow.PictureName = "C:\erpman\image\행추가_d.gif"
	p_delrow.PictureName = "C:\erpman\image\행삭제_d.gif"
	p_ins.PictureName    = "C:\erpman\image\추가_d.gif"
	
	
	w_mdi_frame.sle_msg.text = '통관된 자료는 수정할 수 없습니다'
	
END IF

// 최종 B/L 번호
ii_Last_Jpno = dw_insert.GetItemNumber(dw_insert.RowCount(), "pobseq")

ib_any_typing = False

end event

type p_del from w_inherite`p_del within w_imt_03030
integer taborder = 80
end type

event p_del::clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* 통관일자 입력시 -> 삭제불가
//////////////////////////////////////////////////////////////////
string	sEntdat, sBlno
INT      icount

sEntdat = trim(dw_detail.GetItemString(1, "entdat"))
IF Not IsNull(sEntdat) 		THEN
	MessageBox("확인", "통관된 자료는 수정할 수 없습니다.")
	dw_detail.SetColumn("poblno")
	dw_detail.SetFocus()
	RETURN -1
END IF

sBlno = trim(dw_detail.GetItemString(1, "poblno"))
SELECT COUNT(*)  INTO :icount
  FROM IMPEXP 
 WHERE SABU = :gs_sabu AND POBLNO = :sBlno   ;
 
IF icount > 0 then 
	MessageBox("확인", "수입비용이 등록된 B/L번호는 삭제할 수 없습니다.")
	RETURN 
END IF

//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN

dw_detail.setredraw(False)
	
IF wf_Delete() = -1		THEN	
	dw_detail.setredraw(true)
	RETURN
END IF
/////////////////////////////////////////////////////////////////

IF dw_insert.Update() > 0		THEN
	
	// HEAD삭제
	DELETE POLCBLHD
	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno   ;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback;
		MESSAGEBOX("B/L-HEAD", "B/L-HEAD삭제시 오류가 발생", stopsign!)
		return
	END IF
	
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

wf_New()

dw_insert.Reset()	
	
dw_detail.setredraw(true)


end event

type p_mod from w_inherite`p_mod within w_imt_03030
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_insert.AcceptText() = -1		THEN	RETURN

string	sDate

IF	wf_CheckRequiredField() = -1	THEN	RETURN


// 신규등록시 B/L번호 확인
IF ic_status = '1'	THEN

	IF wf_Confirm_Key() = -1	THEN	RETURN

END IF


/////////////////////////////////////////////////////////////////////////
IF f_msg_update() = -1 		THEN	RETURN

// B/L합계금액 저장
dw_detail.setitem(1, "blamt", dw_insert.getitemdecimal(dw_insert.rowcount(), "blsum"))

IF dw_insert.Update() > 0	and dw_detail.update() > 0	THEN
	COMMIT;
ELSE
	f_Rollback()
	ROLLBACK;
END IF

ib_any_typing = False

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type cb_exit from w_inherite`cb_exit within w_imt_03030
end type

type cb_mod from w_inherite`cb_mod within w_imt_03030
end type

type cb_ins from w_inherite`cb_ins within w_imt_03030
end type

type cb_del from w_inherite`cb_del within w_imt_03030
end type

type cb_inq from w_inherite`cb_inq within w_imt_03030
end type

type cb_print from w_inherite`cb_print within w_imt_03030
end type

type st_1 from w_inherite`st_1 within w_imt_03030
end type

type cb_can from w_inherite`cb_can within w_imt_03030
integer x = 2094
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_imt_03030
end type







type gb_button1 from w_inherite`gb_button1 within w_imt_03030
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_03030
end type

type rr_3 from roundrectangle within w_imt_03030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 184
integer width = 4590
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_imt_03030
boolean visible = false
integer x = 837
integer y = 2540
integer width = 411
integer height = 432
boolean bringtotop = true
string title = "none"
string dataobject = "d_lc_detail_popup1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_imt_03030
integer x = 82
integer y = 72
integer width = 430
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
string text = "자동 채번"
end type

type rb_1 from radiobutton within w_imt_03030
boolean visible = false
integer x = 640
integer y = 72
integer width = 242
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
boolean enabled = false
string text = "B/L"
boolean checked = true
end type

event clicked;wf_New()

dw_insert.Reset()


end event

type rb_2 from radiobutton within w_imt_03030
boolean visible = false
integer x = 978
integer y = 72
integer width = 503
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
boolean enabled = false
string text = "인수증(LOCAL)"
end type

event clicked;wf_New()

dw_insert.Reset()


end event

type rr_4 from roundrectangle within w_imt_03030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 440
integer width = 4590
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from datawindow within w_imt_03030
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 27
integer y = 212
integer width = 4571
integer height = 192
integer taborder = 10
string title = "none"
string dataobject = "d_imt_03030"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;string	sDate, 			&
			sCode, sName,	&
			sNull, sBigub
int      icount			
SetNull(sNull)


// B/L NO
IF this.GetcolumnName() = 'poblno'	THEN
	
	sCode = this.GetText()								
	
	if scode = '' or isnull(scode) then return 

  SELECT COUNT("POLCBL"."POBLNO"), MAX("POLCBL"."BIGUB")
    INTO :icount, :sBigub  
    FROM "POLCBL"  
   WHERE ( "POLCBL"."SABU" = :gs_sabu ) AND  
         ( "POLCBL"."POBLNO" = :scode )   ;

	IF icount > 0 THEN
		if sBigub = '1' then //B/L
	   	rb_1.checked = true
			cbx_1.enabled = false
		else
	   	rb_2.checked = true
			cbx_1.enabled = true
		end if
		p_inq.TriggerEvent(Clicked!)
	   return 1
   END IF	
END IF
// 운송회사
IF this.GetcolumnName() = 'tra_cvcod'	THEN
	
	sCode = this.GetText()								
	
  	if scode = '' or isnull(scode) then
		this.setitem(1, 'vndmst_cvnas', snull)
		return 
   end if
	
   SELECT CVNAS
     INTO :sName
     FROM VNDMST
    WHERE CVCOD = :sCode  AND
	 		 CVSTATUS = '0' ;

	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[운송회사]')
		this.setitem(1, 'tra_cvcod', sNull)
		this.setitem(1, 'vndmst_cvnas', snull)
	   return 1
   ELSE
		this.setitem(1, 'vndmst_cvnas', sName)
   END IF
	
END IF


// 접수일자
IF this.GetColumnName() = 'rcvdat' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[접수일자]')
		This.setitem(1, "rcvdat", sNull)
		return 1
	END IF
	
END IF

// 도착일자
IF this.GetColumnName() = 'desdat' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[도착일자]')
		this.setitem(1, "desdat", sNull)
		return 1
	END IF
	
END IF

// 통관예정일
IF this.GetColumnName() = 'entfoct' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[통관예정일]')
		this.setitem(1, "entfoct", sNull)
		return 1
	END IF
	
END IF


end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''


// 운송회사
IF this.GetColumnName() = 'tra_cvcod'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"tra_cvcod",		gs_code)
	SetItem(1,"vndmst_cvnas",  gs_codename)
	
END IF

// BL번호
IF this.GetColumnName() = 'poblno'	THEN
   
	IF rb_1.Checked then  
		Open(w_bl_popup)
	ELSE
		Open(w_bl_popup2)
	END IF
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "poblno", gs_code)
	this.TriggerEvent(Itemchanged!)
	
END IF
end event

type pb_1 from u_pb_cal within w_imt_03030
integer x = 2085
integer y = 204
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('rcvdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'rcvdat', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_03030
integer x = 2871
integer y = 204
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('desdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'desdat', gs_code)



end event

type pb_4 from u_pb_cal within w_imt_03030
integer x = 2085
integer y = 288
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('entfoct')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'entfoct', gs_code)



end event

type rr_1 from roundrectangle within w_imt_03030
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 549
integer y = 44
integer width = 1029
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_03030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 44
integer width = 517
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

