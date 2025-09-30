$PBExportHeader$w_imt_02010.srw
$PBExportComments$** 발주검토(의뢰번호별)
forward
global type w_imt_02010 from w_inherite
end type
type dw_1 from datawindow within w_imt_02010
end type
type st_2 from statictext within w_imt_02010
end type
type sle_yongdo from singlelineedit within w_imt_02010
end type
type st_3 from statictext within w_imt_02010
end type
type dw_detail from datawindow within w_imt_02010
end type
type dw_hidden from datawindow within w_imt_02010
end type
type dw_2 from datawindow within w_imt_02010
end type
type pb_1 from u_pb_cal within w_imt_02010
end type
type p_1 from picture within w_imt_02010
end type
type rr_1 from roundrectangle within w_imt_02010
end type
type rr_2 from roundrectangle within w_imt_02010
end type
end forward

global type w_imt_02010 from w_inherite
integer height = 3772
string title = "발주검토(의뢰번호별)"
boolean resizable = true
dw_1 dw_1
st_2 st_2
sle_yongdo sle_yongdo
st_3 st_3
dw_detail dw_detail
dw_hidden dw_hidden
dw_2 dw_2
pb_1 pb_1
p_1 p_1
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_02010 w_imt_02010

type variables
string is_pspec, is_jijil, is_gwgbn
end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_required_chk (integer i)
end prototypes

public subroutine wf_reset ();string snull

setnull(snull)

dw_detail.setredraw(false)
dw_insert.setredraw(false)

dw_insert.reset()
dw_detail.reset()

dw_1.setitem(1, 'estno', snull)
dw_1.setitem(1, 'dptno', snull)
dw_1.setitem(1, 'dptnm', snull)
dw_1.setitem(1, 'rdate', snull)
dw_1.setitem(1, 'saupj', snull)
dw_1.setitem(1, 'ipdpt', snull)
dw_1.setitem(1, 'estgu', snull)

dw_1.setfocus()

sle_yongdo.Text = ''

dw_insert.setredraw(true)
dw_detail.setredraw(true)

f_child_saupj(dw_1,'ipdpt',gs_saupj)
/* 부가 사업장 */
f_mod_saupj(dw_1,'saupj')
end subroutine

public function integer wf_required_chk (integer i);if dw_insert.AcceptText() = -1 then return -1

String sToday
sToday = f_today()

if isnull(dw_insert.GetItemString(i,'sempno')) or &
	dw_insert.GetItemString(i,'sempno') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 구매담당자]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('sempno')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'cvcod')) or &
	dw_insert.GetItemString(i,'cvcod') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 거래처]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('cvcod')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'ipdpt')) or &
	dw_insert.GetItemString(i,'ipdpt') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 창고]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ipdpt')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(TRIM(dw_insert.GetItemString(i,'yodat'))) or &
	TRIM(dw_insert.GetItemString(i,'yodat')) = '' or &
	f_datechk(dw_insert.GetItemString(i,'yodat')) = -1 then
	Messagebox("확인", "유효한 일자를 입력하십시요", stopsign!)
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('yodat')
	dw_insert.SetFocus()
	return -1		
end if	

//IF dw_insert.GetItemString(i,'blynd') = '2' then //검토인 경우
//	if	TRIM(dw_insert.GetItemString(i,'yodat')) < sToday  then
//		MessageBox("확인", "납기요구일은 현재일자보다 작을 수 없습니다.", stopsign!)	
//		dw_insert.ScrollToRow(i)
//		dw_insert.SetColumn('yodat')
//		dw_insert.SetFocus()
//		return -1		
//	end if	
//END IF

return 1
end function

on w_imt_02010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
this.sle_yongdo=create sle_yongdo
this.st_3=create st_3
this.dw_detail=create dw_detail
this.dw_hidden=create dw_hidden
this.dw_2=create dw_2
this.pb_1=create pb_1
this.p_1=create p_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_yongdo
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.dw_detail
this.Control[iCurrent+6]=this.dw_hidden
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
end on

on w_imt_02010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.sle_yongdo)
destroy(this.st_3)
destroy(this.dw_detail)
destroy(this.dw_hidden)
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.p_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent('ue_open')
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

event ue_open;call super::ue_open;///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
sTring sCnvgu, sCnvart

/* 그룹웨어 연동여부 */
select dataname
  into :is_gwgbn
  from syscnfg
 where sysgu = 'W' and serial = '1' and lineno = '3';

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

if sCnvgu = 'Y' then // 발주단위 사용시
	dw_insert.dataobject = 'd_imt_02010_1_1'
Else						// 발주단위 사용안함
	dw_insert.dataobject = 'd_imt_02010_1'	
End if


dw_insert.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

//IF f_change_name('1') = 'Y' then 
//	is_pspec = f_change_name('2')
//	is_jijil = f_change_name('3')
//	dw_insert.object.ispec_t.text = is_pspec
//	dw_insert.object.jijil_t.text = is_jijil
//END IF

/* 부가 사업장 */
f_mod_saupj(dw_1, "saupj")

/* 입고창고 */
f_child_saupj(dw_1,'ipdpt',gs_saupj)

end event

type dw_insert from w_inherite`dw_insert within w_imt_02010
integer x = 59
integer y = 260
integer width = 4530
integer height = 1792
integer taborder = 20
string dataobject = "d_imt_02010_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;string snull, scvcod, get_nm, old_sblynd, sblynd, sPordno, get_pdsts
long lrow 
Decimal {3} dData
Decimal {5} dunprc
String   sItnbr, sPspec, sDate

lrow = this.getrow()

SetNull(snull)

IF this.GetColumnName() = "cvcod" THEN
	scvcod = this.GetText()
	
	IF scvcod ="" OR IsNull(scvcod) THEN 
		this.SetItem(lrow,"vndmst_cvnas2",snull)
		RETURN
	END IF
	
	SELECT "VNDMST"."CVNAS2"   
	  INTO :get_nm  
	  FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :scvcod AND "VNDMST"."CVGU" IN ( '1','2','9') AND
	       "VNDMST"."CVSTATUS" = '0' ;
	 
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(lrow,"vndmst_cvnas2",get_nm)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(lrow,"cvcod",snull)
			this.SetItem(lrow,"vndmst_cvnas2",snull)
		END IF
		
		Return 1	
	END IF
ELSEIF this.GetColumnName() = "ipdpt" THEN
	scvcod = this.GetText()
	
	IF scvcod ="" OR IsNull(scvcod) THEN 
		this.SetItem(lrow,"ipdpt_name",snull)
		RETURN
	END IF
	
	SELECT "VNDMST"."CVNAS2"   
	  INTO :get_nm  
	  FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :scvcod AND "VNDMST"."CVGU" = '5' AND
	       "VNDMST"."CVSTATUS" = '0' ;
	 
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(lrow,"ipdpt_name",get_nm)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(lrow,"ipdpt",snull)
			this.SetItem(lrow,"ipdpt_name",snull)
		END IF
		
		Return 1	
	END IF
	
ELSEIF this.getcolumnname() = 'yodat' then
	scvcod = TRIM(this.GetText())	
	if isnull(scvcod) or trim(scvcod) ='' or f_datechk(scvcod) = -1 then
		Messagebox("확인", "유효한 일자를 입력하십시요", stopsign!)
		dw_insert.setitem(lrow, "yodat", snull)
		dw_insert.SetColumn('yodat')
		dw_insert.SetFocus()
		return 1		
	end if	
	
	
//	if	scvcod < f_Today()  then
//		MessageBox("확인", "납기요구일은 현재일자보다 작을 수 없습니다.", stopsign!)	
//		dw_insert.SetColumn('yodat')
//		dw_insert.setitem(lrow, "yodat", snull)
//		dw_insert.SetFocus()
//		return 1		
//	end if	
ELSEIF this.GetColumnName() = "blynd" THEN
   old_sblynd = this.getitemstring(lrow, 'old_blynd')
	sblynd = this.GetText()
   
	IF sblynd = '3' then //발주는 선택할 수 없음
      f_message_chk(71, '[발주상태]')
		this.SetItem(lrow, "blynd", old_sblynd)
      return 1  		
	ELSEIF old_sblynd = '4' then
		sPordno = this.getitemstring(row, 'pordno')
		If not ( sPordno = '' or isnull(sPordno) ) then 
		   SELECT PDSTS  
			  INTO :get_pdsts  
			  FROM MOMAST  
			 WHERE SABU = :gs_sabu AND PORDNO = :sPordno  ;
			 
         if sqlca.sqlcode = 0 then
				if get_pdsts = '6' then 
					MessageBox("확 인","작업지시가 취소 상태입니다. 자료를 확인하세요" + "~n~n" +&
											 "발주상태를 변경시킬 수 없습니다.", StopSign! )
					this.SetItem(lrow, "blynd", old_sblynd)
					Return 1
				end if
			else	
				MessageBox("확 인","작업지시번호를 확인하세요" + "~n~n" +&
										 "발주상태를 변경시킬 수 없습니다.", StopSign! )
				this.SetItem(lrow, "blynd", old_sblynd)
				Return 1
			end if	
		End if	
	END IF

ELSEIF this.getcolumnname() = 'vnqty' then
   dData = dec(this.GetText())
	
	if isnull(dData) then dData = 0
   
	// 업체발주예정량 변경
	if getitemdecimal(Lrow, "cnvfat") = 1   then
		setitem(Lrow, "cnvqty", dData)
	elseif getitemstring(Lrow, "cnvart") = '/'  then
		IF ddata = 0 then
			setitem(Lrow, "cnvqty", 0)			
		else
			setitem(Lrow, "cnvqty", ROUND(dData / getitemdecimal(Lrow, "cnvfat"),3))
		end if
	else
		setitem(Lrow, "cnvqty", ROUND(dData * getitemdecimal(Lrow, "cnvfat"),3))
	end if
ELSEIF this.getcolumnname() = 'unprc' then
   dunprc = dec(this.GetText())
   dData 	= this.GetItemDecimal(Lrow,"vnqty")
	
	if isnull(dunprc) then dunprc = 0
   
	// 업체발주예정단가 변경
	if 	getitemdecimal(Lrow, "cnvfat") =  1  then
		setitem(Lrow, "cnvprc", dunprc)
	elseif 	getitemstring(Lrow, "cnvart") = '*'  then
		IF 	ddata = 0 then
			setitem(Lrow, "cnvprc", 0)			
		else
			setitem(Lrow, "cnvprc", ROUND(dunprc / getitemdecimal(Lrow, "cnvfat"),5))
		end if
	else
		setitem(Lrow, "cnvprc", ROUND(dunprc * getitemdecimal(Lrow, "cnvfat"),5))
	end if	
ELSEIF this.getcolumnname() = 'shpjpno' then    /* Maker 변경*/
//ELSEIF this.getcolumnname() = 'pspec' then    /* 사양 변경*/
	sPspec 	= GetText()
	sItnbr  	= GetItemString(Lrow,'itnbr')
	scvcod 	= GetItemString(Lrow,'cvcod')
	sDate		= GetItemString(Lrow,'rdate')
	
	If IsNull(sPspec) Or Trim(sPspec) = '' Then sPspec = '.'
	
	If 	Not IsNull(sItnbr) Then	
		/* 사양별 매입단가*/
		SELECT Fun_danmst_danga10(:sDate, :scvcod, :sitnbr, :sPspec) INTO :dunprc FROM DUAL;
		
		setitem(Lrow, "unprc", dunprc)
		// 업체발주예정단가 변경
		if 	getitemdecimal(Lrow, "cnvfat") =  1  then
			setitem(Lrow, "cnvprc", dunprc)
		elseif 	getitemstring(Lrow, "cnvart") = '*'  then
			IF 	ddata = 0 then
				setitem(Lrow, "cnvprc", 0)			
			else
				setitem(Lrow, "cnvprc", ROUND(dunprc / getitemdecimal(Lrow, "cnvfat"),5))
			end if
		else
			setitem(Lrow, "cnvprc", ROUND(dunprc * getitemdecimal(Lrow, "cnvfat"),5))
		end if	
	End If		
END IF
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;string snull
long   lrow

SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(snull)

lrow = this.getrow()

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:은행,4:부서,5:창고   
      f_message_chk(70, '[발주처]')
		this.SetItem(lrow, "cvcod", snull)
		this.SetItem(lrow, "vndmst_cvnas2", snull)
      return 1  		
   END IF
	this.SetItem(lrow, "cvcod", gs_Code)
	this.SetItem(lrow, "vndmst_cvnas2", gs_Codename)

ELSEIF this.GetColumnName() = "ipdpt" THEN
	Open(w_vndmst_46_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then		return
	this.SetItem(lrow, "ipdpt", gs_Code)
	this.SetItem(lrow, "ipdpt_name", gs_Codename)
ELSEIF this.GetColumnName() = "seqno" THEN
   this.accepttext()
	gs_code = this.getitemstring(lrow, 'itnbr')
	gs_codename = this.getitemstring(lrow, 'cvcod')
	
	Open(w_itmbuy_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then		return
	this.SetItem(lrow, "seqno", integer(gs_Code))
END IF



end event

event dw_insert::ue_pressenter;IF this.GetColumnName() = "gurmks" THEN return

Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::clicked;if row > 0 then
	selectrow(0,false)
	selectrow(row, true)
else
	selectrow(0,false)
	return
End if

IF 	this.GetItemString(row,"blynd") ='3' THEN
	w_mdi_frame.sle_msg.text = '발주상태가 발주인 자료는 수정이 불가능 합니다.!!'
ELSE
	w_mdi_frame.sle_msg.text =""
END IF


end event

event dw_insert::rowfocuschanged;if currentrow > 0 then
	sle_yongdo.text = getitemstring(currentrow, "yongdo")
end if


end event

event dw_insert::doubleclicked;if dw_insert.AcceptText() = -1 Then Return 
IF This.RowCount() < 1 THEN RETURN 
IF Row < 1 THEN RETURN 

string  sBlynd, sDate, sJpno, sEstno , ls_num
long    k, il_currow, lCount, lseq = 0, lseq2

sblynd = this.getitemstring(Row, 'blynd')

IF sblynd = '3' then //발주는 선택할 수 없음
	f_message_chk(71, '[발주상태]')
	return 1  		
END IF

gs_code   = this.getitemstring(Row, 'estima_estno')
sEstno    = gs_code
sDate     = this.getitemstring(Row, 'rdate')  //의뢰일자

il_currow = row 

Open(W_IMT_02010_POPUP)

if Isnull(gs_code) or Trim(gs_code) = "" then return
dw_hidden.reset()
dw_hidden.ImportClipboard()

lCount = dw_hidden.rowcount()

if 	lCount < 1 then 
	SetPointer(Arrow!)
	return 
end if

//lSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')   // -- 구매의뢰.
//
//IF 	lSeq < 0	 or lseq > 9999	THEN
//	f_message_chk(51, '')
//	SetPointer(Arrow!)
//   	RETURN 
//END IF
//
//COMMIT;
//
//sJpno = sDate + string(lSeq, "0000")


For k = 1 to dw_insert.rowcount()
	ls_num	= right(dw_insert.GetItemString(k, 'estima_estno'),3)
	lSeq2		= Integer(ls_num)
	If lseq2 > lSeq Then
		lSeq = lSeq2
	End If
Next

//ls_num	= right(dw_insert.GetItemString(dw_insert.rowcount(), 'estima_estno'),3)
//lSeq		= Integer(ls_num)

FOR k = 1 TO lCount
	dw_insert.rowscopy(il_currow, il_currow, primary!, dw_insert, il_currow + k, primary!)
	dw_insert.setitem(il_currow + k, 'cvcod', dw_hidden.GetitemString(k, 'cvcod'))
	dw_insert.setitem(il_currow + k, 'vndmst_cvnas2', dw_hidden.GetitemString(k, 'cvnm'))
	dw_insert.setitem(il_currow + k, 'vnqty', dw_hidden.GetitemDecimal(k, 'vnqty'))
	dw_insert.setitem(il_currow + k, 'cnvqty', dw_hidden.GetitemDecimal(k, 'cnvqty'))
	dw_insert.setitem(il_currow + k, 'unprc', dw_hidden.GetitemDecimal(k, 'unprc'))
	dw_insert.setitem(il_currow + k, 'cnvprc', dw_hidden.GetitemDecimal(k, 'cnvprc'))
	dw_insert.setitem(il_currow + k, 'estima_tuncu', dw_hidden.GetitemString(k, 'tuncu'))
	dw_insert.setitem(il_currow + k, 'yodat', dw_hidden.GetitemString(k, 'nadate'))
//	dw_insert.SetItem(il_currow + k, "estima_estno", sJpno + string(k, "000"))
      lSeq	= lSeq + 1
	if	lSeq > 999 	then
		f_message_chk(51, '[분할의뢰 순번범위]')
		SetPointer(Arrow!)
		RETURN 
	END IF
	dw_insert.SetItem(il_currow + k, "estima_estno", left(sEstno,12) + string(lSeq, "000"))
	dw_insert.SetItem(il_currow + k, "jestno", sEstno)
	
	// 전자결재 정보 
	dw_insert.setitem(il_currow + k, 'yebi2', dw_insert.GetitemString(il_currow, 'yebi2'))
	dw_insert.setitem(il_currow + k, 'gubun', dw_insert.GetitemString(il_currow, 'gubun'))
NEXT

dw_insert.setitem(il_currow, 'vnqty',  dw_insert.GetitemDecimal(il_currow, 'vnqty')  &
												 - dw_hidden.GetitemDecimal(1, 'tot_qty'))

dw_insert.setitem(il_currow, 'cnvqty', dw_insert.GetitemDecimal(il_currow, 'cnvqty')  &
												 - dw_hidden.GetitemDecimal(1, 'tot_cnvqty'))

												 
dw_hidden.reset()


//MessageBox("전표번호 확인", "의뢰번호 : " +sDate+ '-' + string(lSeq,"0000")+		&
//									 "~r~r생성되었습니다.")

if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	wf_reset()
	ib_any_typing = FALSE
	return 
end if	

dw_insert.ScrollToRow(il_currow + lCount)
dw_insert.SetFocus()

SetPointer(Arrow!)

end event

event dw_insert::buttonclicked;Long Lrow

Lrow = getrow()

if row <  1 then return

gs_code 		= getitemstring(ROW, "itnbr")
gs_codename = getitemstring(ROW, "itemas_itdsc")

if isnull(gs_code) or trim(gs_code) = '' or isnull(gs_codename) or trim(gs_codename) = '' then
	return
end if


open(w_pdt_04000_1)

setnull(gs_code)
setnull(gs_codename)
end event

type p_delrow from w_inherite`p_delrow within w_imt_02010
boolean visible = false
integer x = 4210
integer y = 2664
end type

type p_addrow from w_inherite`p_addrow within w_imt_02010
boolean visible = false
integer x = 3552
boolean enabled = false
string picturename = "C:\erpman\image\자동생성_up.gif"
end type

event p_addrow::ue_lbuttondown;PictureName = "C:\erpman\image\자동생성_dn.gif"
end event

event p_addrow::ue_lbuttonup;PictureName = "C:\erpman\image\자동생성_up.gif"
end event

event p_addrow::clicked;call super::clicked;//String sEstNo, sgubun, sError
//Int    iRtn
//
//If dw_1.AcceptText() <> 1 Then Return
//
//sEstNo = Mid(dw_1.GetItemString(1,'estno'),1, 12)
//
//iRtn = MessageBox('외주가공품 작업구분을 선택하세요.!!', + &
//                          "소요량 전개 : 예(Y) ~r~n~r~n" + &
//                          "소요량 삭제 : 아니오(N) ~r~n~r~n" + &
//								  "작업   취소 : 취소(C) ~r~n~r~n", Question!, YesNoCancel! )
//If iRtn = 1 Then
//	sGubun = 'I'
//ElseIf iRtn = 2 Then
//	sGubun = 'D'
//Else
//	Return
//End If
//
//DECLARE ERP000009010 PROCEDURE FOR ERP000009010(:gs_sabu, :sEstno, :sgubun) USING SQLCA;
//EXECUTE ERP000009010;
//
//CLOSE ERP000009010;
//
//p_inq.TriggerEvent(Clicked!)

end event

type p_search from w_inherite`p_search within w_imt_02010
integer x = 4078
string picturename = "C:\Erpman\image\일괄검토_up.gif"
end type

event p_search::clicked;call super::clicked;long i, lCount

lcount = dw_insert.rowcount()

FOR i=1 TO lCount
	if dw_insert.getitemstring(i, 'blynd') = '1' then //구매의뢰일 경우만 검토로 변환
	   dw_insert.setitem(i, 'blynd', '8')
	end if	
NEXT
	

end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\일괄검토_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\일괄검토_up.gif"
end event

type p_ins from w_inherite`p_ins within w_imt_02010
boolean visible = false
integer x = 3429
integer width = 306
integer height = 148
string picturename = "C:\Erpman\image\거래처등록_up.gif"
end type

event p_ins::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

setnull(gs_code)

open(w_pdm_01045)
end event

event p_ins::ue_lbuttondown;PictureName = "C:\Erpman\image\거래처등록_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\Erpman\image\거래처등록_up.gif"
end event

type p_exit from w_inherite`p_exit within w_imt_02010
integer x = 4425
end type

type p_can from w_inherite`p_can within w_imt_02010
integer x = 4251
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_imt_02010
boolean visible = false
integer x = 3621
integer y = 2676
end type

type p_inq from w_inherite`p_inq within w_imt_02010
integer x = 3730
end type

event p_inq::clicked;call super::clicked;string s_estno, s_estno2

if dw_1.AcceptText() = -1 then return 

s_estno = trim(dw_1.GetItemString(1,'estno'))

if isnull(s_estno) or s_estno = "" then
	f_message_chk(30,'[의뢰번호]')
	dw_1.Setcolumn('estno')
	dw_1.SetFocus()
	return
end if	

s_estno2 = s_estno + '%'

if dw_insert.Retrieve(gs_sabu, s_estno2) <= 0 then 
	f_message_chk(50,'')
	dw_1.setfocus()
else
	if	dw_detail.retrieve(gs_sabu, s_estno) <= 0 then
		dw_detail.insertrow(0)
		dw_detail.setitem(1, 'sabu', gs_sabu)
		dw_detail.setitem(1, 'estno', s_estno)
   end if
	dw_insert.setfocus()
end if	
	
ib_any_typing = FALSE


end event

type p_del from w_inherite`p_del within w_imt_02010
boolean visible = false
integer x = 3826
integer y = 2676
end type

type p_mod from w_inherite`p_mod within w_imt_02010
integer x = 3904
end type

event p_mod::clicked;long i,j
string s_estno

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

s_estno = trim(dw_1.GetItemString(1,'estno'))
s_estno = s_estno + '%'

w_mdi_frame.sle_msg.text = '자료 check중입니다...!'

////////////////////////////////////////

if f_msg_update() = -1 then return

if is_gwgbn = 'Y' then
	For j = 1 to dw_insert.Rowcount()//////////////////////////////////
FOR i = 1 TO dw_insert.RowCount()
	dw_insert.SetItem(i, "ipdpt", dw_1.GetItemString(1, "ipdpt"))	// 입고창고변경
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

//////////////////////////////////////////////////////////////////////////
sle_msg.text = ''
		if dw_insert.GetITemString(j, 'blynd') = '2' then
			dw_insert.SetItem(j, 'blynd', '8')
		End if
	Next
end if

if dw_insert.update() = 1 then
   if dw_detail.update() = 1 then
		w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
		ib_any_typing= FALSE
		commit ;
	else
		rollback ;
		messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
		return 
	end if	
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
dw_insert.Retrieve(gs_sabu, s_estno)

long chk = 0
string ls_cvcod, ls_old, ls_chk

for i = 1 to dw_insert.rowcount()
	ls_chk = dw_insert.GetItemString(i, 'blynd')
	if ls_chk = '8' then
		chk = chk + 1
	end if
Next

if chk > 0 then
long  ll_qty, ll_amt, ll_cnt
string ls_no, ls_cod, ls_cvnas, ls_name, ls_dept, ls_dsc
	/* 전자결제 상신 */
	IF is_gwgbn = 'Y'  then
		gs_code = left(s_estno,12)
		
		dw_2.retrieve(gs_sabu, gs_code)
		
		select count(*) into :ll_cnt
		  from estima_web
		 where estno like gs_code||'%';
		 
		if ll_cnt > 1 then
		else
		
			For i = 1 to dw_2.RowCount()
			
				ls_no    = dw_2.GetItemString(i,1)
				ls_cod   = dw_2.GetItemString(i,2)
				ls_cvnas = dw_2.GetItemString(i,3)
				ls_name  = dw_2.GetItemString(i,4)
				ls_dept  = dw_2.GetItemString(i,5)
				If dw_2.GetItemNumber(i, 'cnt') > 0 Then
					ls_dsc   = dw_2.GetItemString(i,6) + ' 외 ' + String(dw_2.GetItemNumber(i, 'cnt')) + '건'
				Else
					ls_dsc   = dw_2.GetItemString(i,6)
				End If
				ll_qty   = dw_2.GetItemNumber(i,8)
				ll_amt   = dw_2.GetItemNumber(i,9)
			
				Insert Into estima_web
				(	estno,	cvcod,	cvnas,	empname,	deptname,	itdsc,	guqty,	quamt )
				Values (:ls_no, :ls_cod, :ls_cvnas, :ls_name, :ls_dept, :ls_dsc, :ll_qty, :ll_amt);
				
				IF Sqlca.SqlCode <> 0 THEN 
					MEssageBox('', Sqlca.SqlerrText)
					RollBack ;
					Return 
				END IF
				
				Commit;
			
			Next
			
		end if
		
		gs_code  = "&ESTNO="+gs_code		//의뢰번호
		gs_gubun = '0000000069'	//그룹웨어 문서번호
		SetNull(gs_codename)
		
		WINDOW LW_WINDOW
		OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser', w_mdi_frame, 0, Layered!)
		
		/* 결제상신하지 않을 경우 */
		If gs_code = 'N' or gs_code = 'C' Then		
			Update estima
				set blynd = '2'
			 where substr(estno,1,12) = substr(:s_estno,1,12);
			If sqlca.sqlcode <> 0 Then
				RollBack;
				MessageBox('확 인','결제정보 변경에 실패하였습니다.!!')
				Return
			End If
		End If
	END IF

//	If is_gwgbn = 'Y' then
//		j = 1
//		for i = 1 to dw_insert.RowCount()
//			if i = 1 then
//				ls_old = dw_insert.GetItemString(i, 'cvcod')
//			else
//				ls_cvcod = dw_insert.GetItemString(i, 'cvcod')
//				if ls_cvcod = ls_old then
//					j = j
//				else
//					j = j + 1
//					ls_old = ls_cvcod
//				end if
//			end if
//		Next
//		
//		if j = 1 then 
//			gs_gubun = '1' // 을지 
//		else
//			gs_gubun = '2' // 갑지
//		end if
//		
//		gs_code = left(s_estno,12)
//		
//		open(w_imt_02010_1)
//	End if
end if
end event

type cb_exit from w_inherite`cb_exit within w_imt_02010
integer x = 2368
integer y = 2560
end type

type cb_mod from w_inherite`cb_mod within w_imt_02010
integer x = 1806
integer y = 2564
integer taborder = 70
end type

event cb_mod::clicked;call super::clicked;long i
string s_estno

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

s_estno = trim(dw_1.GetItemString(1,'estno'))
s_estno = s_estno + '%'

sle_msg.text = '자료 check중입니다...!'

//////////////////////////////////////////////////////////////////////////
FOR i = 1 TO dw_insert.RowCount()
	dw_insert.SetItem(i, "ipdpt", dw_1.GetItemString(1, "ipdpt"))	// 입고창고변경
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

//////////////////////////////////////////////////////////////////////////
sle_msg.text = ''

if f_msg_update() = -1 then return

if dw_insert.update() = 1 then
   if dw_detail.update() = 1 then
		sle_msg.text = "자료가 저장되었습니다!!"
		ib_any_typing= FALSE
		commit ;
	else
		rollback ;
		messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
		return 
	end if	
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
dw_insert.Retrieve(gs_sabu, s_estno) 

end event

type cb_ins from w_inherite`cb_ins within w_imt_02010
integer x = 2738
integer y = 2608
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_imt_02010
integer x = 3109
integer y = 2612
end type

type cb_inq from w_inherite`cb_inq within w_imt_02010
integer x = 101
integer y = 2564
end type

event cb_inq::clicked;call super::clicked;string s_estno, s_estno2

if dw_1.AcceptText() = -1 then return 

s_estno = trim(dw_1.GetItemString(1,'estno'))

if isnull(s_estno) or s_estno = "" then
	f_message_chk(30,'[의뢰번호]')
	dw_1.Setcolumn('estno')
	dw_1.SetFocus()
	return
end if	

s_estno2 = s_estno + '%'

if dw_insert.Retrieve(gs_sabu, s_estno2) <= 0 then 
	f_message_chk(50,'')
	dw_1.setfocus()
else
	if	dw_detail.retrieve(gs_sabu, s_estno) <= 0 then
		dw_detail.insertrow(0)
		dw_detail.setitem(1, 'sabu', gs_sabu)
		dw_detail.setitem(1, 'estno', s_estno)
   end if
	dw_insert.setfocus()
end if	
	
ib_any_typing = FALSE


end event

type cb_print from w_inherite`cb_print within w_imt_02010
integer x = 3977
integer y = 2556
integer width = 421
string text = "거래처등록"
end type

event cb_print::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

setnull(gs_code)

open(w_pdm_01045)
end event

type st_1 from w_inherite`st_1 within w_imt_02010
integer x = 210
integer y = 7336
end type

type cb_can from w_inherite`cb_can within w_imt_02010
integer x = 2107
integer y = 2488
integer taborder = 80
end type

event cb_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type cb_search from w_inherite`cb_search within w_imt_02010
integer x = 850
integer y = 2616
integer width = 421
integer taborder = 60
string text = "일괄검토"
end type

event cb_search::clicked;call super::clicked;long i, lCount

lcount = dw_insert.rowcount()

FOR i=1 TO lCount
	if dw_insert.getitemstring(i, 'blynd') = '1' then //구매의뢰일 경우만 검토로 변환
	   dw_insert.setitem(i, 'blynd', '2')
	end if	
NEXT
	

end event

type dw_datetime from w_inherite`dw_datetime within w_imt_02010
integer x = 3054
integer y = 7336
end type

type sle_msg from w_inherite`sle_msg within w_imt_02010
integer x = 562
integer y = 7336
end type

type gb_10 from w_inherite`gb_10 within w_imt_02010
integer x = 192
integer y = 2792
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_02010
integer x = 1362
integer y = 7556
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_02010
integer x = 1906
integer y = 7580
end type

type dw_1 from datawindow within w_imt_02010
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 105
integer y = 44
integer width = 3191
integer height = 180
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_02010_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string snull, s_estno, s_estno2, get_date, get_dptno, get_cvnm, get_autcrt

setnull(snull)

IF this.GetColumnName() ="estno" THEN
	s_estno = trim(this.GetText())
	
	IF	Isnull(s_estno)  or  s_estno = ''	Then
		wf_reset()
		RETURN
   END IF

  string		sSaupj, sIpdpt, sEstgu
  s_estno2 = s_estno + '%'

  SELECT "ESTIMA"."RDATE", "ESTIMA"."RDPTNO", "VNDMST"."CVNAS2", "ESTIMA"."AUTCRT",
  			"ESTIMA"."SAUPJ", "ESTIMA"."IPDPT", "ESTIMA"."ESTGU"
    INTO :get_date,        :get_dptno,        :get_cvnm, :get_autcrt,
	 		:sSaupj, 			:sIpdpt, 			 :sEstgu
    FROM "ESTIMA", "VNDMST"  
   WHERE ( "ESTIMA"."RDPTNO" = "VNDMST"."CVCOD" (+)) and  
         ( "ESTIMA"."SABU" = :gs_sabu ) AND  
         ( "ESTIMA"."ESTNO" like :s_estno2 )    AND
			ROWNUM = 1 ;

	IF SQLCA.SQLCODE <> 0 then 
		this.triggerevent(rbuttondown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
   		wf_reset()
      END IF
      RETURN 1
   ELSE
		dw_1.setitem(1, 'dptno', get_dptno)
		dw_1.setitem(1, 'dptnm', get_cvnm)
		dw_1.setitem(1, 'rdate', get_date)
		dw_1.setitem(1, 'gubun', get_autcrt)
		dw_1.setitem(1, 'saupj', sSaupj)
		dw_1.setitem(1, 'ipdpt', sIpdpt)
		dw_1.setitem(1, 'estgu', sEstgu)
		
		p_inq.triggerevent(clicked!)
	END IF
ElseIF this.GetColumnName() ="saupj" THEN
	sSaupj = trim(GetText())
	
	/* 입고창고 */
	f_child_saupj(dw_1,'ipdpt', sSaupj)
END IF	
end event

event itemerror;return 1
end event

event rbuttondown;string get_dptno, get_cvnm, get_date, s_estno, get_autcrt

setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "estno" THEN
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	gs_code  = '생산' 
	
	open(w_estima_popup_voda)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN
	gs_code = left(gs_code, 12)

	this.SetItem(1, "estno", gs_code)
	this.TriggerEvent("itemchanged")
	
END IF	
end event

type st_2 from statictext within w_imt_02010
integer x = 50
integer y = 2100
integer width = 1079
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "용   도(비고-의뢰자가 작성한 사항)"
boolean focusrectangle = false
end type

type sle_yongdo from singlelineedit within w_imt_02010
integer x = 1161
integer y = 2100
integer width = 1888
integer height = 68
integer taborder = 100
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean border = false
boolean autohscroll = false
end type

type st_3 from statictext within w_imt_02010
integer x = 3346
integer y = 192
integer width = 1253
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[아래자료를 두번 CLICK시 의뢰자료를 분할]"
boolean focusrectangle = false
end type

type dw_detail from datawindow within w_imt_02010
integer x = 50
integer y = 2172
integer width = 4526
integer height = 128
integer taborder = 30
string dataobject = "d_imt_02010_2"
boolean border = false
boolean livescroll = true
end type

event editchanged;ib_any_typing =True
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

type dw_hidden from datawindow within w_imt_02010
boolean visible = false
integer x = 233
integer y = 704
integer width = 2523
integer height = 360
boolean bringtotop = true
string dataobject = "d_imt_02010_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_imt_02010
boolean visible = false
integer x = 928
integer y = 1076
integer width = 1157
integer height = 432
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_imt_02010_3"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_imt_02010
integer x = 2688
integer y = 44
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('rdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'rdate', gs_code)



end event

type p_1 from picture within w_imt_02010
integer x = 3328
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\결재상신_up.gif"
boolean focusrectangle = false
end type

event clicked;String sEstNo, ls_status , sYebi, ls_chk = 'Y'
long i, lCount, nFind

sEstNo 	= left(dw_1.GetItemString(1, 'estno'), 12)
ls_status  = dw_1.GetItemString(1, 'estgu')
gs_code  = "%26SABU=1%26ESTNO="+ sEstNo + "%26ESTGU=" + ls_status		//수주번호
gs_gubun = '00041'										//그룹웨어 문서번호
gs_codename = '구매발주검토'									//제목입력받음

lcount = dw_insert.rowcount()

// 일괄 검토 처리
FOR i=1 TO lCount
	if dw_insert.getitemstring(i, 'blynd') = '1' then
		ls_chk = 'N' 
	end if	
NEXT
if ls_chk = 'N' then 
	if Messagebox('확인', '아직 검토 하지 않은 내역이 존재합니다.~n검토되지 않은 내역을 검토처리 하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 then return 
				
	For i=1 to lCount
		if dw_insert.getitemstring(i, 'blynd') = '1' then
			dw_insert.setitem(i, 'blynd', '8')
			dw_insert.update() 
			commit; 
		end if	
	Next 
End if 

// 검토된 최초 내역
nFind = dw_insert.Find("blynd = '8'", 1, dw_insert.RowCount())
If nFind <= 0 Then Return

// 발주품의에 대한 전자결재 진행상태
sYebi = dw_insert.GetItemString(nFind, 'yebi2')
If IsNull(sYebi) Then sYebi = '0'

If dw_insert.GetItemString(nFind, 'blynd') = '8' AND sYebi = '0' Then
	
	// 그룹웨어 문서번호
	//SELECT TRIM(DATANAME) INTO :gs_gubun FROM SYSCNFG WHERE SYSGU = 'W' AND SERIAL = 1 AND LINENO = 'B';
	
	WINDOW LW_WINDOW
	OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser', w_mdi_frame, 0, Layered!)
	
	lw_window.x = 0
	lw_window.y = 0
End If
end event

type rr_1 from roundrectangle within w_imt_02010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 55
integer y = 32
integer width = 3259
integer height = 204
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_imt_02010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 252
integer width = 4549
integer height = 1808
integer cornerheight = 40
integer cornerwidth = 46
end type

