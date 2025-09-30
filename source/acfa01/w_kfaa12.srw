$PBExportHeader$w_kfaa12.srw
$PBExportComments$고정자산 변동자료 등록
forward
global type w_kfaa12 from w_inherite
end type
type dw_2 from datawindow within w_kfaa12
end type
type dw_1 from datawindow within w_kfaa12
end type
type rr_1 from roundrectangle within w_kfaa12
end type
end forward

global type w_kfaa12 from w_inherite
string title = "변동내역 등록"
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_kfaa12 w_kfaa12

forward prototypes
public function integer wf_get_seq (string skfcod1, double dkfcod2, string skfchgdate)
public function integer wf_requiredchk (integer icurrow)
public subroutine wf_get_amount (string skfcod1, double dkfcod2, string schangeymd, ref double dbuyamt, ref double dnusangamt)
public subroutine wf_retrievemode (string mode)
public subroutine wf_calculation_amount (string skfcod1, double dkfcod2, string skfchgb, string skfchgym, double dkfcamt, ref double drdeamt, ref double drdeamt1)
end prototypes

public function integer wf_get_seq (string skfcod1, double dkfcod2, string skfchgdate);Integer iMaxSeq

SELECT MAX("KFA03OT0"."KFACSEQ")      INTO :iMaxSeq  
	FROM "KFA03OT0"  
   WHERE ( "KFA03OT0"."KFCOD1" = :sKfCod1 ) AND ( "KFA03OT0"."KFCOD2" = :dKfCod2 ) AND  
         ( "KFA03OT0"."KFACDAT" = :sKfChgDate )   ;
IF SQLCA.SQLCODE = 0 THEN
	IF Isnull(iMaxSeq) THEN
		iMaxSeq = 0
	END IF
ELSE
	iMaxSeq = 0
END IF

iMaxSeq = iMaxSeq + 1

Return iMaxSeq
end function

public function integer wf_requiredchk (integer icurrow);String sKfCod1,sKfChgDate,sKfChgb
Double dKfCod2,dKfdAmt,dKfcAmt

sKfCod1    = dw_1.GetItemString(iCurRow,"kfcod1")
dKfCod2    = dw_1.GetItemNumber(iCurRow,"kfcod2")
sKfChgDate = Trim(dw_1.GetItemString(iCurRow,"kfacdat")) 
sKfChGb    = dw_1.GetItemString(iCurRow,"kfchgb")

dKfdAmt	  = dw_1.GetItemNumber(iCurRow,"kfdamt")
dKfcAmt    = dw_1.GetItemNumber(iCurRow,"kfcamt")

IF sKfCod1 = "" OR IsNull(sKfCod1) THEN
	F_MessageChk(1,'[고정자산번호]')
	dw_1.SetColumn("kfcod1")
	dw_1.SetFocus()
	Return -1
END IF

IF dKfCod2 = 0 OR IsNull(dKfCod2) THEN
	F_MessageChk(1,'[고정자산번호]')
	dw_1.SetColumn("kfcod2")
	dw_1.SetFocus()
	Return -1
END IF

IF sKfChgDate = "" OR IsNull(sKfChgDate) THEN
	F_MessageChk(1,'[변동일자]')
	dw_1.SetColumn("kfacdat")
	dw_1.SetFocus()
	Return -1
END IF
IF sKfChgb = "" OR IsNull(sKfChgb) THEN
	F_MessageChk(1,'[변동구분]')
	dw_1.SetColumn("kfchgb")
	dw_1.SetFocus()
	Return -1
END IF

//IF dKfdAmt = 0 OR IsNull(dKfdAmt) THEN
//	F_MessageChk(1,'[금액]')
//	dw_1.SetColumn("kfdamt")
//	dw_1.SetFocus()
//	Return -1
//END IF

IF sKfChgb >='F' AND sKfChgb <= 'J' THEN
	IF dKfcAmt = 0 OR IsNull(dKfcAmt) THEN
		F_MessageChk(1,'[처분자산가액]')
		dw_1.SetColumn("kfcamt")
		dw_1.SetFocus()
		Return -1
	END IF
END IF
Return 1
end function

public subroutine wf_get_amount (string skfcod1, double dkfcod2, string schangeymd, ref double dbuyamt, ref double dnusangamt);/*취득가액*/
select nvl(kfamt,0) + 
		 decode(	Substr(:schangeymd,5,2),
		 '01',nvl(kfdr01,0),
		 '02',nvl(kfdr01,0) + nvl(kfdr02,0),
		 '03',nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0),
		 '04',nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0) + nvl(kfdr04,0),
		 '05',nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0) + nvl(kfdr04,0) +
			   nvl(kfdr05,0),
		 '06',nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0) + nvl(kfdr04,0) +
			   nvl(kfdr05,0) + nvl(kfdr06,0),
		 '07',nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0) + nvl(kfdr04,0) +
		 	   nvl(kfdr05,0) + nvl(kfdr06,0) + nvl(kfdr07,0),
		 '08',nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0) + nvl(kfdr04,0) +
			   nvl(kfdr05,0) + nvl(kfdr06,0) + nvl(kfdr07,0) + nvl(kfdr08,0),
		 '09',nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0) + nvl(kfdr04,0) + 
		 	   nvl(kfdr05,0) + nvl(kfdr06,0) + nvl(kfdr07,0) + nvl(kfdr08,0) + 
		 	   nvl(kfdr09,0),
		 '10',nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0) + nvl(kfdr04,0) +
			   nvl(kfdr05,0) + nvl(kfdr06,0) + nvl(kfdr07,0) + nvl(kfdr08,0) +
				nvl(kfdr09,0) + nvl(kfdr10,0),
		 '11',nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0) + nvl(kfdr04,0) +
		 	   nvl(kfdr05,0) + nvl(kfdr06,0) + nvl(kfdr07,0) + nvl(kfdr08,0) + 
		 	   nvl(kfdr09,0) + nvl(kfdr10,0) + nvl(kfdr11,0),
		 	   nvl(kfdr01,0) + nvl(kfdr02,0) + nvl(kfdr03,0) + nvl(kfdr04,0) +
		 	   nvl(kfdr05,0) + nvl(kfdr06,0) + nvl(kfdr07,0) + nvl(kfdr08,0) +
				nvl(kfdr09,0) + nvl(kfdr10,0) + nvl(kfdr11,0) + nvl(kfdr12,0)) -		
		 decode(	Substr(:schangeymd,5,2),
		 '01',nvl(kfcr01,0),
		 '02',nvl(kfcr01,0) + nvl(kfcr02,0),
		 '03',nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0),
		 '04',nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0) + nvl(kfcr04,0),
		 '05',nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0) + nvl(kfcr04,0) +
			   nvl(kfcr05,0),
		 '06',nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0) + nvl(kfcr04,0) +
			   nvl(kfcr05,0) + nvl(kfcr06,0),
		 '07',nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0) + nvl(kfcr04,0) +
		 	   nvl(kfcr05,0) + nvl(kfcr06,0) + nvl(kfcr07,0),
		 '08',nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0) + nvl(kfcr04,0) +
			   nvl(kfcr05,0) + nvl(kfcr06,0) + nvl(kfcr07,0) + nvl(kfcr08,0),
		 '09',nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0) + nvl(kfcr04,0) + 
		 	   nvl(kfcr05,0) + nvl(kfcr06,0) + nvl(kfcr07,0) + nvl(kfcr08,0) + 
		 	   nvl(kfcr09,0),
		 '10',nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0) + nvl(kfcr04,0) +
			   nvl(kfcr05,0) + nvl(kfcr06,0) + nvl(kfcr07,0) + nvl(kfcr08,0) +
				nvl(kfcr09,0) + nvl(kfcr10,0),
		 '11',nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0) + nvl(kfcr04,0) +
		 	   nvl(kfcr05,0) + nvl(kfcr06,0) + nvl(kfcr07,0) + nvl(kfcr08,0) + 
		 	   nvl(kfcr09,0) + nvl(kfcr10,0) + nvl(kfcr11,0),
		 	   nvl(kfcr01,0) + nvl(kfcr02,0) + nvl(kfcr03,0) + nvl(kfcr04,0) +
		 	   nvl(kfcr05,0) + nvl(kfcr06,0) + nvl(kfcr07,0) + nvl(kfcr08,0) +
				nvl(kfcr09,0) + nvl(kfcr10,0) + nvl(kfcr11,0) + nvl(kfcr12,0))
			into :dbuyamt
			from kfa04om0
			where kfyear = Substr(:schangeymd,1,4) and kfcod1 = :skfcod1 and
					kfcod2 = :dkfcod2 ;	
if sqlca.sqlcode <> 0 then
	dBuyAmt = 0
end if

/*상각누계액 2003.07.19수정 : 매각등 처리시 기초중당금누계액만으로 처리함 매각전월까지의 */
/* 당기상각액은 감안 */
select nvl(kfdeamt,0) + 
		 decode(	Substr(:schangeymd,5,2),
		 '01',nvl(kfde01,0),
		 '02',nvl(kfde01,0) + nvl(kfde02,0),
		 '03',nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0),
		 '04',nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0) + nvl(kfde04,0),
		 '05',nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0) + nvl(kfde04,0) +
			   nvl(kfde05,0),
		 '06',nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0) + nvl(kfde04,0) +
			   nvl(kfde05,0) + nvl(kfde06,0),
		 '07',nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0) + nvl(kfde04,0) +
		 	   nvl(kfde05,0) + nvl(kfde06,0) + nvl(kfde07,0),
		 '08',nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0) + nvl(kfde04,0) +
			   nvl(kfde05,0) + nvl(kfde06,0) + nvl(kfde07,0) + nvl(kfde08,0),
		 '09',nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0) + nvl(kfde04,0) + 
		 	   nvl(kfde05,0) + nvl(kfde06,0) + nvl(kfde07,0) + nvl(kfde08,0) + 
		 	   nvl(kfde09,0),
		 '10',nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0) + nvl(kfde04,0) +
			   nvl(kfde05,0) + nvl(kfde06,0) + nvl(kfde07,0) + nvl(kfde08,0) +
				nvl(kfde09,0) + nvl(kfde10,0),
		 '11',nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0) + nvl(kfde04,0) +
		 	   nvl(kfde05,0) + nvl(kfde06,0) + nvl(kfde07,0) + nvl(kfde08,0) + 
		 	   nvl(kfde09,0) + nvl(kfde10,0) + nvl(kfde11,0),
		 	   nvl(kfde01,0) + nvl(kfde02,0) + nvl(kfde03,0) + nvl(kfde04,0) +
		 	   nvl(kfde05,0) + nvl(kfde06,0) + nvl(kfde07,0) + nvl(kfde08,0) +
				nvl(kfde09,0) + nvl(kfde10,0) + nvl(kfde11,0) + nvl(kfde12,0))
			into :dnusangamt
			from kfa04om0
			where kfyear = Substr(:schangeymd,1,4) and kfcod1 = :skfcod1 and
					kfcod2 = :dkfcod2 ;	

//select nvl(kfdeamt,0)
//			into :dnusangamt
//			from kfa04om0
//			where kfyear = Substr(:schangeymd,1,4) and kfcod1 = :skfcod1 and
//					kfcod2 = :dkfcod2 ;	
if sqlca.sqlcode <> 0 then
	dnusangamt = 0
end if

end subroutine

public subroutine wf_retrievemode (string mode);
dw_1.SetRedraw(False)

IF mode ="M" THEN
	dw_1.Enabled   = False
	p_mod.Enabled = False
	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
	
	p_inq.Enabled = False
	p_inq.PictureName = "C:\erpman\image\조회_d.gif"
ELSE
	dw_1.Enabled =True
	dw_1.SetTabOrder("kfcod1",10)
	dw_1.SetTabOrder("kfcod2",20)
	dw_1.SetTabOrder("kfacdat",30)
	dw_1.SetColumn("kfcod1")
	
	p_mod.Enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"

	p_inq.Enabled = True
	p_inq.PictureName = "C:\erpman\image\조회_up.gif"
END IF
dw_1.SetRedraw(True)
dw_1.SetFocus()
end subroutine

public subroutine wf_calculation_amount (string skfcod1, double dkfcod2, string skfchgb, string skfchgym, double dkfcamt, ref double drdeamt, ref double drdeamt1);Double dBuyAmt,dNuSangAmt

Wf_Get_Amount(sKfCod1,dKfCod2,sKfChgYm,dBuyAmt,dNuSangAmt)

IF IsNull(dBuyAmt) THEN dBuyAmt = 0
IF IsNull(dNuSangAmt) THEN dNuSangAmt = 0

IF sKfChgb = 'F' or sKfChGb = 'G' OR sKfChGb = 'H' or sKfChGb = 'I' or sKfChGb = 'J' THEN			/*부분매각,부분폐기*/
	IF dKfcAmt = 0 OR dBuyAmt = 0 THEN
		dRdeAmt = 0		
	ELSE
		dRdeAmt = Round((dKfcAmt / dBuyAmt) * dNuSangAmt,0)					/*충당금감소액*/
	END IF
	dRdeAmt1 = dKfcAmt - dRdeAmt										/*처분전장부가액*/
ELSE
	dRdeAmt  = 0
	dRdeAmt1 = 0
END IF




end subroutine

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

dw_2.SetTransObject(SQLCA)

ib_any_typing =False
sModStatus ="I"
wf_retrievemode(sModStatus)



end event

on w_kfaa12.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_kfaa12.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

type dw_insert from w_inherite`dw_insert within w_kfaa12
boolean visible = false
integer x = 9
integer y = 2708
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfaa12
boolean visible = false
integer x = 4233
integer y = 3008
end type

type p_addrow from w_inherite`p_addrow within w_kfaa12
boolean visible = false
integer x = 4059
integer y = 3008
integer width = 165
end type

type p_search from w_inherite`p_search within w_kfaa12
boolean visible = false
integer x = 3365
integer y = 3008
end type

type p_ins from w_inherite`p_ins within w_kfaa12
boolean visible = false
integer x = 3886
integer y = 3008
end type

type p_exit from w_inherite`p_exit within w_kfaa12
end type

type p_can from w_inherite`p_can within w_kfaa12
end type

event p_can::clicked;call super::clicked;LONG ROW_NUM

dw_1.Reset()
dw_1.InsertRow(0)

row_num = dw_1.Getrow()

dw_1.SetItem(row_num,"kfacdat","")
dw_1.SetItem(row_num,"kfacseq",0)
dw_1.SetItem(row_num,"kfchgb","")
dw_1.SetItem(row_num,"kfcust","")
dw_1.SetItem(row_num,"kfdamt",0)
dw_1.SetItem(row_num,"kfcamt",0)

dw_2.SelectRow(0,False)

ib_any_typing =False
sModStatus ="I"
wf_retrievemode(sModStatus)

w_mdi_frame.sle_msg.text = ""



end event

type p_print from w_inherite`p_print within w_kfaa12
boolean visible = false
integer x = 3538
integer y = 3008
end type

type p_inq from w_inherite`p_inq within w_kfaa12
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String DKFCOD1
Long DKFCOD2, ROW_NUM, RETRIEVE_ROW

dw_1.AcceptText()

row_num = dw_1.Getrow()

dkfcod1 = dw_1.GetItemString(row_num,"kfcod1")
dkfcod2 = dw_1.GetItemNumber(row_num,"kfcod2")

if IsNull(dkfcod1) then dkfcod1 = ""
if IsNull(dkfcod2) then dkfcod2 = 0

if dkfcod1 = "" or dkfcod2 = 0 then
   w_mdi_frame.sle_msg.text = "자료조회시 고정자산코드는 필수 입력입니다."
   Messagebox("확 인","고정자산코드를 확인하시오. !!!")
	Return
end if

Retrieve_row = dw_2.Retrieve(dkfcod1,dkfcod2)

if Retrieve_row <= 0 then
	MessageBox("확 인","해당 고정자산코드에 해당하는 자료가 없습니다.!!")
   return
end if

w_mdi_frame.sle_msg.text = ""
ib_any_typing =False

sModStatus ="I"
wf_retrievemode(sModStatus)

end event

type p_del from w_inherite`p_del within w_kfaa12
end type

event p_del::clicked;call super::clicked;String sKfCod1,sKfChgb,sKfChgDate,sKfYear,sTempcode,sKfGbn
Long   lKfChgSeq,dKfAmt
Double dKfCod2,dKfcAmt,dKfdAmt,dKfRdeAmt,lKfJyr

IF dw_2.GetSelectedRow(0) <= 0 THEN 
	F_Messagechk(11,'')
	Return
END IF

SELECT "KFA07OM0"."KFYEAR"  	INTO :sKfYear 
	FROM "KFA07OM0" ;

sKfCod1    = dw_1.GetItemString(dw_1.GetRow(),"kfcod1")
dKfCod2    = dw_1.GetItemNumber(dw_1.GetRow(),"kfcod2")
sKfChgDate = Trim(dw_1.GetItemString(dw_1.GetRow(),"kfacdat")) 
lKfChgSeq  = dw_1.GetItemNumber(dw_1.GetRow(),"kfacseq")
sKfChGb    = dw_1.GetItemString(dw_1.GetRow(),"kfchgb")

dKfdAmt	  = dw_1.GetItemNumber(dw_1.GetRow(),"kfdamt")
dKfcAmt    = dw_1.GetItemNumber(dw_1.GetRow(),"kfcamt")
dKfRdeAmt  = dw_1.GetItemNumber(dw_1.GetRow(),"kfrde")

IF Left(sKfChgDate,4) <> sKfYear THEN
	Messagebox("확 인","회기년도와 변동일자의 변동년도를 비교 확인하시오. !!!")            
   Return	
END IF

//IF sKfChgb = "A" or sKfChgb = "B" or sKfChgb = "C" or sKfChgb = "K" then
//   sle_msg.text = "입력한 변동구분은 SYSTEM 내부에서 관리하는 코드입니다."
//   Messagebox("확 인","다음 고정자산 변동구분은 삭제 불가능 합니다. !!!" &
//                     + "~n~nA : 신규취득 ~nB : 과년도취득 ~nC : 자동감가상각" &
//                     + "~nK : 상각완료")
//   return
//END IF

if sKfChgb >= "F" AND sKfChgb <= "J"  then
	SELECT "KFA03OT0"."KFCOD1"      INTO :sTempCode
    FROM "KFA03OT0"  
    WHERE ( "KFA03OT0"."KFCOD1" = :sKfCod1 ) AND ( "KFA03OT0"."KFCOD2" = :dKfCod2 ) AND  
          ( "KFA03OT0"."KFACDAT"||"KFA03OT0"."KFACSEQ" > :sKfChgDate||:lKfChgSeq ) AND 
          ( "KFA03OT0"."KFCHGB" >= 'F' ) AND ( "KFA03OT0"."KFCHGB" <= 'J' )  ;
   IF SQLCA.SQLCODE = 0 then
	   sle_msg.text   = "매각/폐기된 자료는 발생순서의 역순으로 삭제하시오."
   	Messagebox("확 인","매각/폐기된 자료가 입력한 변동일자,순번 뒤에 존재합니다. !!!")
   	Return
   End if
END IF

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_1.SetRedraw(False)
dw_1.DeleteRow(0) 
IF dw_1.Update() <> 1 THEN
	F_MessageChk(13,'')
	Rollback;
	dw_1.SetRedraw(True)
	Return
END IF

Integer iAryCnt,k
Double  dAryDrAmt[],dAryCrAmt[],dAryDnAmt[]

FOR k = 1 TO 12
	IF String(k,'00') = Mid(sKfChgDate,5,2) THEN
		dAryDrAmt[k] = dKfdAmt
		dAryCrAmt[k] = dKfcAmt
		dAryDnAmt[k] = dKfRdeAmt
	ELSE
		dAryDrAmt[k] = 0;		dAryCrAmt[k] = 0;		dAryDnAmt[k] = 0;
	END IF
NEXT

IF sKfChgb = 'D' THEN
	update kfa02om0
		set jdramt = jdramt - :dKfdAmt
		where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
				
	/*무형자산 이면 자본적 지출시 고정자산 마스타의 무형년상각액 갱신 : 취득원가 + 금액 / 잔존년수(2001.02.27수정)*/
	select nvl(kfgubun,' '),nvl(kfamt,0),nvl(kfjyr,0)	into :sKfGbn,	:dKfAmt,		:lKfJyr
		from kfa02om0
		where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	if sKfGbn = '4' then
		update kfa02om0
			set number1 = decode(:lKfJyr,0,0,null,0,Trunc((:dkfamt - :dkfdamt) / :lKfJyr,0)),
				 kfamt   = :dkfamt - :dKfdAmt
			where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	end if
	
	UPDATE "KFA04OM0"  
   	SET "KFDR01" = "KFDR01" - :dAryDrAmt[1],   
          "KFDR02" = "KFDR02" - :dAryDrAmt[2],   
          "KFDR03" = "KFDR03" - :dAryDrAmt[3],   
          "KFDR04" = "KFDR04" - :dAryDrAmt[4],   
          "KFDR05" = "KFDR05" - :dAryDrAmt[5],   
          "KFDR06" = "KFDR06" - :dAryDrAmt[6],   
          "KFDR07" = "KFDR07" - :dAryDrAmt[7],   
          "KFDR08" = "KFDR08" - :dAryDrAmt[8],   
          "KFDR09" = "KFDR09" - :dAryDrAmt[9],   
          "KFDR10" = "KFDR10" - :dAryDrAmt[10],   
          "KFDR11" = "KFDR11" - :dAryDrAmt[11],   
          "KFDR12" = "KFDR12" - :dAryDrAmt[12]
		WHERE ( "KFA04OM0"."KFYEAR" = Substr(:sKfChgDate,1,4) ) AND  
      	   ( "KFA04OM0"."KFCOD1" = :sKfCod1) AND ( "KFA04OM0"."KFCOD2" = :dKfCod2 )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[고정자산 잔고-자본적지출]')
		Rollback;
		Return
	END IF
END IF

IF sKfChgb >= 'F' AND sKfChgb <= 'J' THEN
	UPDATE "KFA04OM0"  
   	SET "KFCR01" = "KFCR01" - :dAryCrAmt[1],   
          "KFCR02" = "KFCR02" - :dAryCrAmt[2],   
          "KFCR03" = "KFCR03" - :dAryCrAmt[3],   
          "KFCR04" = "KFCR04" - :dAryCrAmt[4],   
          "KFCR05" = "KFCR05" - :dAryCrAmt[5],   
          "KFCR06" = "KFCR06" - :dAryCrAmt[6],   
          "KFCR07" = "KFCR07" - :dAryCrAmt[7],   
          "KFCR08" = "KFCR08" - :dAryCrAmt[8],   
          "KFCR09" = "KFCR09" - :dAryCrAmt[9],   
          "KFCR10" = "KFCR10" - :dAryCrAmt[10],   
          "KFCR11" = "KFCR11" - :dAryCrAmt[11],   
          "KFCR12" = "KFCR12" - :dAryCrAmt[12],
			 "KFDN01" = "KFDN01" - :dAryDnAmt[1],   
          "KFDN02" = "KFDN02" - :dAryDnAmt[2],   
          "KFDN03" = "KFDN03" - :dAryDnAmt[3],   
          "KFDN04" = "KFDN04" - :dAryDnAmt[4],   
          "KFDN05" = "KFDN05" - :dAryDnAmt[5],   
          "KFDN06" = "KFDN06" - :dAryDnAmt[6],   
          "KFDN07" = "KFDN07" - :dAryDnAmt[7],   
          "KFDN08" = "KFDN08" - :dAryDnAmt[8],   
          "KFDN09" = "KFDN09" - :dAryDnAmt[9],   
          "KFDN10" = "KFDN10" - :dAryDnAmt[10],   
          "KFDN11" = "KFDN11" - :dAryDnAmt[11],   
          "KFDN12" = "KFDN12" - :dAryDnAmt[12]
		WHERE ( "KFA04OM0"."KFYEAR" = Substr(:sKfChgDate,1,4) ) AND  
      	   ( "KFA04OM0"."KFCOD1" = :sKfCod1) AND ( "KFA04OM0"."KFCOD2" = :dKfCod2 )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[고정자산 잔고-매각,폐기]')
		Rollback;
		Return
	END IF
	
   IF sKfChgb = 'H' OR sKfChgb = 'I' OR sKfChgb = 'J' THEN
	   UPDATE "KFA02OM0"  
   	   SET "KFCHGB" = 'B',
      	    "KFDODT" = NULL  
      WHERE ( "KFA02OM0"."KFCOD1" = :sKfCod1 ) AND  
           ( "KFA02OM0"."KFCOD2"  = :dKfCod2 )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[고정자산 마스타]')
			Rollback;
			Return
		END IF
   END IF
END IF   

commit ;

dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(dw_1.GetRow(),"kfcod1",sKfCod1)
dw_1.SetItem(dw_1.GetRow(),"kfcod2",dKfCod2)
dw_1.SetColumn("kfacdat")
dw_1.SetFocus()

dw_1.SetRedraw(True)

w_mdi_frame.sle_msg.text = "자료가 삭제되었습니다."

dw_2.ReTrieve(sKfCod1,dKfCod2) 

ib_any_typing = False

sModStatus ="I"
wf_retrievemode(sModStatus)


end event

type p_mod from w_inherite`p_mod within w_kfaa12
end type

event p_mod::clicked;call super::clicked;String sKfCod1,sKfChgb,sKfChgDate,sTempCode,sKfGbn
Long   lKfChgSeq,lKfJyr
Double dKfCod2,dKfcAmt,dKfdAmt,dKfRdeAmt,dKfRdeAmt1,dBuyAmt,dNuSangAmt,dKfAmt

IF dw_1.AcceptText() = -1 Then Return

IF dw_1.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return

sKfCod1    = dw_1.GetItemString(dw_1.GetRow(),"kfcod1")
dKfCod2    = dw_1.GetItemNumber(dw_1.GetRow(),"kfcod2")
sKfChgDate = Trim(dw_1.GetItemString(dw_1.GetRow(),"kfacdat")) 
sKfChGb    = dw_1.GetItemString(dw_1.GetRow(),"kfchgb")

dKfdAmt	  = dw_1.GetItemNumber(dw_1.GetRow(),"kfdamt")
dKfcAmt    = dw_1.GetItemNumber(dw_1.GetRow(),"kfcamt")

dBuyAmt    = dw_1.GetItemNumber(dw_1.GetRow(),"kfrde02")
dNuSangAmt = dw_1.GetItemNumber(dw_1.GetRow(),"kfrde03")

IF IsNull(dBuyAmt) THEN dBuyAmt = 0
IF IsNull(dNuSangAmt) THEN dNuSangAmt = 0

SELECT "KFA03OT0"."KFCOD1"  	INTO :sTempCode
	FROM "KFA03OT0"  
	WHERE (( "KFA03OT0"."KFCOD1" = :sKfCod1 )  AND  
			 ( "KFA03OT0"."KFCOD2" = :dKfCod2 )) AND  
			(( "KFA03OT0"."KFCHGB" = 'H' ) OR ( "KFA03OT0"."KFCHGB" = 'I' ) OR  
			 ( "KFA03OT0"."KFCHGB" = 'J' ))  ;
if SQLCA.SQLCODE =  0 then
	F_MessageChk(20,'[고정자산번호-변동완료된 자산]')
  	w_mdi_frame.sle_msg.text   = "현재 고정자산은 전체매각,전체폐기,증여등 변동완료된 자산입니다."
	dw_1.SetColumn("kfcod1")
	dw_1.SetFocus()
  	Return 
End if
	
IF smodstatus ='I' THEN
	lKfChgSeq = Wf_Get_Seq(sKfCod1,dKfCod2,sKfChgDate)
	dw_1.SetItem(dw_1.GetRow(),"kfacseq",lKfChgSeq)
ELSE
	lKfChgSeq = dw_1.GetItemNumber(dw_1.GetRow(),"kfacseq")
END IF

//Wf_Calculation_Amount(sKfCod1,dKfCod2,sKfChgb,Left(sKfChgDate,6),dKfcAmt,dKfRdeAmt,dKfRdeAmt1)

//dw_1.SetItem(dw_1.GetRow(),"kfrde",  dKfRdeAmt)
//dw_1.SetItem(dw_1.GetRow(),"kfrde01",dKfRdeAmt1)

dKfRdeAmt  = dw_1.GetItemNumber(dw_1.GetRow(),"kfrde")
dKfRdeAmt1 = dw_1.GetItemNumber(dw_1.GetRow(),"kfrde01")
IF IsNull(dKfRdeAmt) THEN dKfRdeAmt = 0
IF IsNull(dKfRdeAmt1) THEN dKfRdeAmt1 = 0

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() <> 1 THEN
	F_MessageChk(13,'')
	Rollback;
	Return
END IF

Integer iAryCnt,k
Double  dAryDrAmt[],dAryCrAmt[],dAryDnAmt[]

FOR k = 1 TO 12
	IF String(k,'00') = Mid(sKfChgDate,5,2) THEN
		dAryDrAmt[k] = dKfdAmt
		dAryCrAmt[k] = dKfcAmt
		dAryDnAmt[k] = dKfRdeAmt
	ELSE
		dAryDrAmt[k] = 0;		dAryCrAmt[k] = 0;		dAryDnAmt[k] = 0;
	END IF
NEXT

IF sKfChgb = 'D' THEN
	update kfa02om0
		set jdramt = jdramt + :dKfdAmt
		where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
				
	/*무형자산 이면 자본적 지출시 고정자산 마스타의 무형년상각액 갱신 : 취득원가 + 금액 / 잔존년수(2001.02.27수정)*/
	select nvl(kfgubun,' '),nvl(kfamt,0),nvl(kfjyr,0)	into :sKfGbn,	:dKfAmt,		:lKfJyr
		from kfa02om0
		where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	if sKfGbn = '4' then
		update kfa02om0
			set number1 = decode(:lKfJyr,0,0,null,0,Trunc((:dkfamt + :dkfdamt) / :lKfJyr,0)),
				 kfamt   = :dkfamt + :dKfdAmt
			where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	end if
	
	UPDATE "KFA04OM0"  
   	SET "KFDR01" = "KFDR01" + :dAryDrAmt[1],   
          "KFDR02" = "KFDR02" + :dAryDrAmt[2],   
          "KFDR03" = "KFDR03" + :dAryDrAmt[3],   
          "KFDR04" = "KFDR04" + :dAryDrAmt[4],   
          "KFDR05" = "KFDR05" + :dAryDrAmt[5],   
          "KFDR06" = "KFDR06" + :dAryDrAmt[6],   
          "KFDR07" = "KFDR07" + :dAryDrAmt[7],   
          "KFDR08" = "KFDR08" + :dAryDrAmt[8],   
          "KFDR09" = "KFDR09" + :dAryDrAmt[9],   
          "KFDR10" = "KFDR10" + :dAryDrAmt[10],   
          "KFDR11" = "KFDR11" + :dAryDrAmt[11],   
          "KFDR12" = "KFDR12" + :dAryDrAmt[12]
		WHERE ( "KFA04OM0"."KFYEAR" = Substr(:sKfChgDate,1,4) ) AND  
      	   ( "KFA04OM0"."KFCOD1" = :sKfCod1) AND ( "KFA04OM0"."KFCOD2" = :dKfCod2 )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[고정자산 잔고-자본적지출]')
		Rollback;
		Return
	END IF
END IF

IF sKfChgb >= 'F' AND sKfChgb <= 'J' THEN
	UPDATE "KFA04OM0"  
   	SET "KFCR01" = "KFCR01" + :dAryCrAmt[1],   
          "KFCR02" = "KFCR02" + :dAryCrAmt[2],   
          "KFCR03" = "KFCR03" + :dAryCrAmt[3],   
          "KFCR04" = "KFCR04" + :dAryCrAmt[4],   
          "KFCR05" = "KFCR05" + :dAryCrAmt[5],   
          "KFCR06" = "KFCR06" + :dAryCrAmt[6],   
          "KFCR07" = "KFCR07" + :dAryCrAmt[7],   
          "KFCR08" = "KFCR08" + :dAryCrAmt[8],   
          "KFCR09" = "KFCR09" + :dAryCrAmt[9],   
          "KFCR10" = "KFCR10" + :dAryCrAmt[10],   
          "KFCR11" = "KFCR11" + :dAryCrAmt[11],   
          "KFCR12" = "KFCR12" + :dAryCrAmt[12],
			 "KFDN01" = "KFDN01" + :dAryDnAmt[1],   
          "KFDN02" = "KFDN02" + :dAryDnAmt[2],   
          "KFDN03" = "KFDN03" + :dAryDnAmt[3],   
          "KFDN04" = "KFDN04" + :dAryDnAmt[4],   
          "KFDN05" = "KFDN05" + :dAryDnAmt[5],   
          "KFDN06" = "KFDN06" + :dAryDnAmt[6],   
          "KFDN07" = "KFDN07" + :dAryDnAmt[7],   
          "KFDN08" = "KFDN08" + :dAryDnAmt[8],   
          "KFDN09" = "KFDN09" + :dAryDnAmt[9],   
          "KFDN10" = "KFDN10" + :dAryDnAmt[10],   
          "KFDN11" = "KFDN11" + :dAryDnAmt[11],   
          "KFDN12" = "KFDN12" + :dAryDnAmt[12]
		WHERE ( "KFA04OM0"."KFYEAR" = Substr(:sKfChgDate,1,4) ) AND  
      	   ( "KFA04OM0"."KFCOD1" = :sKfCod1) AND ( "KFA04OM0"."KFCOD2" = :dKfCod2 )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[고정자산 잔고-매각,폐기]')
		Rollback;
		Return
	END IF
	
   IF sKfChgb = 'H' OR sKfChgb = 'I' OR sKfChgb = 'J' THEN
	   UPDATE "KFA02OM0"  
   	   SET "KFCHGB" = :sKfChgb,
      	    "KFDODT" = :sKfChgDate  
      WHERE ( "KFA02OM0"."KFCOD1" = :sKfCod1 ) AND  
           ( "KFA02OM0"."KFCOD2"  = :dKfCod2 )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[고정자산 마스타]')
			Rollback;
			Return
		END IF
   END IF
END IF   

commit ;
dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(dw_1.GetRow(),"kfcod1",sKfCod1)
dw_1.SetItem(dw_1.GetRow(),"kfcod2",dKfCod2)
dw_1.SetColumn("kfacdat")
dw_1.SetFocus()
dw_1.SetRedraw(True)

w_mdi_frame.sle_msg.text = "자료가 저장되었습니다."

dw_2.ReTrieve(sKfCod1,dKfCod2) 

ib_any_typing = False

sModStatus ="I"
wf_retrievemode(sModStatus)



end event

type cb_exit from w_inherite`cb_exit within w_kfaa12
boolean visible = false
integer x = 3424
integer y = 2760
integer taborder = 50
end type

type cb_mod from w_inherite`cb_mod within w_kfaa12
boolean visible = false
integer x = 2354
integer y = 2760
end type

event cb_mod::clicked;call super::clicked;String sKfCod1,sKfChgb,sKfChgDate,sTempCode,sKfGbn
Long   lKfChgSeq,lKfJyr
Double dKfCod2,dKfcAmt,dKfdAmt,dKfRdeAmt,dKfRdeAmt1,dBuyAmt,dNuSangAmt,dKfAmt

IF dw_1.AcceptText() = -1 Then Return

IF dw_1.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return

sKfCod1    = dw_1.GetItemString(dw_1.GetRow(),"kfcod1")
dKfCod2    = dw_1.GetItemNumber(dw_1.GetRow(),"kfcod2")
sKfChgDate = Trim(dw_1.GetItemString(dw_1.GetRow(),"kfacdat")) 
sKfChGb    = dw_1.GetItemString(dw_1.GetRow(),"kfchgb")

dKfdAmt	  = dw_1.GetItemNumber(dw_1.GetRow(),"kfdamt")
dKfcAmt    = dw_1.GetItemNumber(dw_1.GetRow(),"kfcamt")

dBuyAmt    = dw_1.GetItemNumber(dw_1.GetRow(),"kfrde02")
dNuSangAmt = dw_1.GetItemNumber(dw_1.GetRow(),"kfrde03")

IF IsNull(dBuyAmt) THEN dBuyAmt = 0
IF IsNull(dNuSangAmt) THEN dNuSangAmt = 0

SELECT "KFA03OT0"."KFCOD1"  	INTO :sTempCode
	FROM "KFA03OT0"  
	WHERE (( "KFA03OT0"."KFCOD1" = :sKfCod1 )  AND  
			 ( "KFA03OT0"."KFCOD2" = :dKfCod2 )) AND  
			(( "KFA03OT0"."KFCHGB" = 'H' ) OR ( "KFA03OT0"."KFCHGB" = 'I' ) OR  
			 ( "KFA03OT0"."KFCHGB" = 'J' ))  ;
if SQLCA.SQLCODE =  0 then
	F_MessageChk(20,'[고정자산번호-변동완료된 자산]')
  	sle_msg.text   = "현재 고정자산은 전체매각,전체폐기,증여등 변동완료된 자산입니다."
	dw_1.SetColumn("kfcod1")
	dw_1.SetFocus()
  	Return 
End if
	
IF smodstatus ='I' THEN
	lKfChgSeq = Wf_Get_Seq(sKfCod1,dKfCod2,sKfChgDate)
	dw_1.SetItem(dw_1.GetRow(),"kfacseq",lKfChgSeq)
ELSE
	lKfChgSeq = dw_1.GetItemNumber(dw_1.GetRow(),"kfacseq")
END IF

Wf_Calculation_Amount(sKfCod1,dKfCod2,sKfChgb,Left(sKfChgDate,6),dKfcAmt,dKfRdeAmt,dKfRdeAmt1)

dw_1.SetItem(dw_1.GetRow(),"kfrde",  dKfRdeAmt)
dw_1.SetItem(dw_1.GetRow(),"kfrde01",dKfRdeAmt1)

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() <> 1 THEN
	F_MessageChk(13,'')
	Rollback;
	Return
END IF

Integer iAryCnt,k
Double  dAryDrAmt[],dAryCrAmt[],dAryDnAmt[]

FOR k = 1 TO 12
	IF String(k,'00') = Mid(sKfChgDate,5,2) THEN
		dAryDrAmt[k] = dKfdAmt
		dAryCrAmt[k] = dKfcAmt
		dAryDnAmt[k] = dKfRdeAmt
	ELSE
		dAryDrAmt[k] = 0;		dAryCrAmt[k] = 0;		dAryDnAmt[k] = 0;
	END IF
NEXT

IF sKfChgb = 'D' THEN
	/*무형자산 이면 자본적 지출시 고정자산 마스타의 무형년상각액 갱신 : 취득원가 + 금액 / 잔존년수(2001.02.27수정)*/
	select nvl(kfgubun,' '),nvl(kfamt,0),nvl(kfjyr,0)	into :sKfGbn,	:dKfAmt,		:lKfJyr
		from kfa02om0
		where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	if sKfGbn = '4' then
		update kfa02om0
			set number1 = decode(:lKfJyr,0,0,null,0,Trunc((:dkfamt + :dkfdamt) / :lKfJyr,0)),
				 kfamt   = :dkfamt + :dKfdAmt
			where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	end if
	
	UPDATE "KFA04OM0"  
   	SET "KFDR01" = "KFDR01" + :dAryDrAmt[1],   
          "KFDR02" = "KFDR02" + :dAryDrAmt[2],   
          "KFDR03" = "KFDR03" + :dAryDrAmt[3],   
          "KFDR04" = "KFDR04" + :dAryDrAmt[4],   
          "KFDR05" = "KFDR05" + :dAryDrAmt[5],   
          "KFDR06" = "KFDR06" + :dAryDrAmt[6],   
          "KFDR07" = "KFDR07" + :dAryDrAmt[7],   
          "KFDR08" = "KFDR08" + :dAryDrAmt[8],   
          "KFDR09" = "KFDR09" + :dAryDrAmt[9],   
          "KFDR10" = "KFDR10" + :dAryDrAmt[10],   
          "KFDR11" = "KFDR11" + :dAryDrAmt[11],   
          "KFDR12" = "KFDR12" + :dAryDrAmt[12]
		WHERE ( "KFA04OM0"."KFYEAR" = Substr(:sKfChgDate,1,4) ) AND  
      	   ( "KFA04OM0"."KFCOD1" = :sKfCod1) AND ( "KFA04OM0"."KFCOD2" = :dKfCod2 )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[고정자산 잔고-자본적지출]')
		Rollback;
		Return
	END IF
END IF

IF sKfChgb >= 'F' AND sKfChgb <= 'J' THEN
	UPDATE "KFA04OM0"  
   	SET "KFCR01" = "KFCR01" + :dAryCrAmt[1],   
          "KFCR02" = "KFCR02" + :dAryCrAmt[2],   
          "KFCR03" = "KFCR03" + :dAryCrAmt[3],   
          "KFCR04" = "KFCR04" + :dAryCrAmt[4],   
          "KFCR05" = "KFCR05" + :dAryCrAmt[5],   
          "KFCR06" = "KFCR06" + :dAryCrAmt[6],   
          "KFCR07" = "KFCR07" + :dAryCrAmt[7],   
          "KFCR08" = "KFCR08" + :dAryCrAmt[8],   
          "KFCR09" = "KFCR09" + :dAryCrAmt[9],   
          "KFCR10" = "KFCR10" + :dAryCrAmt[10],   
          "KFCR11" = "KFCR11" + :dAryCrAmt[11],   
          "KFCR12" = "KFCR12" + :dAryCrAmt[12],
			 "KFDN01" = "KFDN01" + :dAryDnAmt[1],   
          "KFDN02" = "KFDN02" + :dAryDnAmt[2],   
          "KFDN03" = "KFDN03" + :dAryDnAmt[3],   
          "KFDN04" = "KFDN04" + :dAryDnAmt[4],   
          "KFDN05" = "KFDN05" + :dAryDnAmt[5],   
          "KFDN06" = "KFDN06" + :dAryDnAmt[6],   
          "KFDN07" = "KFDN07" + :dAryDnAmt[7],   
          "KFDN08" = "KFDN08" + :dAryDnAmt[8],   
          "KFDN09" = "KFDN09" + :dAryDnAmt[9],   
          "KFDN10" = "KFDN10" + :dAryDnAmt[10],   
          "KFDN11" = "KFDN11" + :dAryDnAmt[11],   
          "KFDN12" = "KFDN12" + :dAryDnAmt[12]
		WHERE ( "KFA04OM0"."KFYEAR" = Substr(:sKfChgDate,1,4) ) AND  
      	   ( "KFA04OM0"."KFCOD1" = :sKfCod1) AND ( "KFA04OM0"."KFCOD2" = :dKfCod2 )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[고정자산 잔고-매각,폐기]')
		Rollback;
		Return
	END IF
	
   IF sKfChgb = 'H' OR sKfChgb = 'I' OR sKfChgb = 'J' THEN
	   UPDATE "KFA02OM0"  
   	   SET "KFCHGB" = :sKfChgb,
      	    "KFDODT" = :sKfChgDate  
      WHERE ( "KFA02OM0"."KFCOD1" = :sKfCod1 ) AND  
           ( "KFA02OM0"."KFCOD2"  = :dKfCod2 )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[고정자산 마스타]')
			Rollback;
			Return
		END IF
   END IF
END IF   

commit ;
dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(dw_1.GetRow(),"kfcod1",sKfCod1)
dw_1.SetItem(dw_1.GetRow(),"kfcod2",dKfCod2)
dw_1.SetColumn("kfacdat")
dw_1.SetFocus()
dw_1.SetRedraw(True)

sle_msg.text = "자료가 저장되었습니다."

dw_2.ReTrieve(sKfCod1,dKfCod2) 

ib_any_typing = False

sModStatus ="I"
wf_retrievemode(sModStatus)



end event

type cb_ins from w_inherite`cb_ins within w_kfaa12
boolean visible = false
integer x = 1157
integer y = 2760
end type

event cb_ins::clicked;call super::clicked;//LONG ROW_NUM
//
//dw_1.Reset()
//dw_1.InsertRow(0)
//
//row_num = dw_1.Getrow()
//
//dw_1.SetItem(row_num,"kfacdat","")
//dw_1.SetItem(row_num,"kfacseq",0)
//dw_1.SetItem(row_num,"kfchgb","")
//dw_1.SetItem(row_num,"kfcust","")
//dw_1.SetItem(row_num,"kfdamt",0)
//dw_1.SetItem(row_num,"kfcamt",0)
//dw_1.SetItem(row_num,"kfrde",0)
//dw_1.SetItem(row_num,"kfde01",0)
//
//dw_2.SelectRow(0,False)
//
//ib_any_typing =False
//sModStatus ="I"
//wf_retrievemode(sModStatus)
//
//sle_msg.text = ""
end event

type cb_del from w_inherite`cb_del within w_kfaa12
boolean visible = false
integer x = 2711
integer y = 2760
end type

event cb_del::clicked;call super::clicked;String sKfCod1,sKfChgb,sKfChgDate,sKfYear,sTempcode,sKfGbn
Long   lKfChgSeq,dKfAmt
Double dKfCod2,dKfcAmt,dKfdAmt,dKfRdeAmt,lKfJyr

IF dw_2.GetSelectedRow(0) <= 0 THEN 
	F_Messagechk(11,'')
	Return
END IF

SELECT "KFA07OM0"."KFYEAR"  	INTO :sKfYear 
	FROM "KFA07OM0" ;

sKfCod1    = dw_1.GetItemString(dw_1.GetRow(),"kfcod1")
dKfCod2    = dw_1.GetItemNumber(dw_1.GetRow(),"kfcod2")
sKfChgDate = Trim(dw_1.GetItemString(dw_1.GetRow(),"kfacdat")) 
lKfChgSeq  = dw_1.GetItemNumber(dw_1.GetRow(),"kfacseq")
sKfChGb    = dw_1.GetItemString(dw_1.GetRow(),"kfchgb")

dKfdAmt	  = dw_1.GetItemNumber(dw_1.GetRow(),"kfdamt")
dKfcAmt    = dw_1.GetItemNumber(dw_1.GetRow(),"kfcamt")
dKfRdeAmt  = dw_1.GetItemNumber(dw_1.GetRow(),"kfrde")

IF Left(sKfChgDate,4) <> sKfYear THEN
	Messagebox("확 인","회기년도와 변동일자의 변동년도를 비교 확인하시오. !!!")            
   Return	
END IF

//IF sKfChgb = "A" or sKfChgb = "B" or sKfChgb = "C" or sKfChgb = "K" then
//   sle_msg.text = "입력한 변동구분은 SYSTEM 내부에서 관리하는 코드입니다."
//   Messagebox("확 인","다음 고정자산 변동구분은 삭제 불가능 합니다. !!!" &
//                     + "~n~nA : 신규취득 ~nB : 과년도취득 ~nC : 자동감가상각" &
//                     + "~nK : 상각완료")
//   return
//END IF

if sKfChgb >= "F" AND sKfChgb <= "J"  then
	SELECT "KFA03OT0"."KFCOD1"      INTO :sTempCode
    FROM "KFA03OT0"  
    WHERE ( "KFA03OT0"."KFCOD1" = :sKfCod1 ) AND ( "KFA03OT0"."KFCOD2" = :dKfCod2 ) AND  
          ( "KFA03OT0"."KFACDAT"||"KFA03OT0"."KFACSEQ" > :sKfChgDate||:lKfChgSeq ) AND 
          ( "KFA03OT0"."KFCHGB" >= 'F' ) AND ( "KFA03OT0"."KFCHGB" <= 'J' )  ;
   IF SQLCA.SQLCODE = 0 then
	   sle_msg.text   = "매각/폐기된 자료는 발생순서의 역순으로 삭제하시오."
   	Messagebox("확 인","매각/폐기된 자료가 입력한 변동일자,순번 뒤에 존재합니다. !!!")
   	Return
   End if
END IF

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_1.SetRedraw(False)
dw_1.DeleteRow(0) 
IF dw_1.Update() <> 1 THEN
	F_MessageChk(13,'')
	Rollback;
	dw_1.SetRedraw(True)
	Return
END IF

Integer iAryCnt,k
Double  dAryDrAmt[],dAryCrAmt[],dAryDnAmt[]

FOR k = 1 TO 12
	IF String(k,'00') = Mid(sKfChgDate,5,2) THEN
		dAryDrAmt[k] = dKfdAmt
		dAryCrAmt[k] = dKfcAmt
		dAryDnAmt[k] = dKfRdeAmt
	ELSE
		dAryDrAmt[k] = 0;		dAryCrAmt[k] = 0;		dAryDnAmt[k] = 0;
	END IF
NEXT

IF sKfChgb = 'D' THEN
	/*무형자산 이면 자본적 지출시 고정자산 마스타의 무형년상각액 갱신 : 취득원가 + 금액 / 잔존년수(2001.02.27수정)*/
	select nvl(kfgubun,' '),nvl(kfamt,0),nvl(kfjyr,0)	into :sKfGbn,	:dKfAmt,		:lKfJyr
		from kfa02om0
		where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	if sKfGbn = '4' then
		update kfa02om0
			set number1 = decode(:lKfJyr,0,0,null,0,Trunc((:dkfamt - :dkfdamt) / :lKfJyr,0)),
				 kfamt   = :dkfamt - :dKfdAmt
			where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	end if
	
	UPDATE "KFA04OM0"  
   	SET "KFDR01" = "KFDR01" - :dAryDrAmt[1],   
          "KFDR02" = "KFDR02" - :dAryDrAmt[2],   
          "KFDR03" = "KFDR03" - :dAryDrAmt[3],   
          "KFDR04" = "KFDR04" - :dAryDrAmt[4],   
          "KFDR05" = "KFDR05" - :dAryDrAmt[5],   
          "KFDR06" = "KFDR06" - :dAryDrAmt[6],   
          "KFDR07" = "KFDR07" - :dAryDrAmt[7],   
          "KFDR08" = "KFDR08" - :dAryDrAmt[8],   
          "KFDR09" = "KFDR09" - :dAryDrAmt[9],   
          "KFDR10" = "KFDR10" - :dAryDrAmt[10],   
          "KFDR11" = "KFDR11" - :dAryDrAmt[11],   
          "KFDR12" = "KFDR12" - :dAryDrAmt[12]
		WHERE ( "KFA04OM0"."KFYEAR" = Substr(:sKfChgDate,1,4) ) AND  
      	   ( "KFA04OM0"."KFCOD1" = :sKfCod1) AND ( "KFA04OM0"."KFCOD2" = :dKfCod2 )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[고정자산 잔고-자본적지출]')
		Rollback;
		Return
	END IF
END IF

IF sKfChgb >= 'F' AND sKfChgb <= 'J' THEN
	UPDATE "KFA04OM0"  
   	SET "KFCR01" = "KFCR01" - :dAryCrAmt[1],   
          "KFCR02" = "KFCR02" - :dAryCrAmt[2],   
          "KFCR03" = "KFCR03" - :dAryCrAmt[3],   
          "KFCR04" = "KFCR04" - :dAryCrAmt[4],   
          "KFCR05" = "KFCR05" - :dAryCrAmt[5],   
          "KFCR06" = "KFCR06" - :dAryCrAmt[6],   
          "KFCR07" = "KFCR07" - :dAryCrAmt[7],   
          "KFCR08" = "KFCR08" - :dAryCrAmt[8],   
          "KFCR09" = "KFCR09" - :dAryCrAmt[9],   
          "KFCR10" = "KFCR10" - :dAryCrAmt[10],   
          "KFCR11" = "KFCR11" - :dAryCrAmt[11],   
          "KFCR12" = "KFCR12" - :dAryCrAmt[12],
			 "KFDN01" = "KFDN01" - :dAryDnAmt[1],   
          "KFDN02" = "KFDN02" - :dAryDnAmt[2],   
          "KFDN03" = "KFDN03" - :dAryDnAmt[3],   
          "KFDN04" = "KFDN04" - :dAryDnAmt[4],   
          "KFDN05" = "KFDN05" - :dAryDnAmt[5],   
          "KFDN06" = "KFDN06" - :dAryDnAmt[6],   
          "KFDN07" = "KFDN07" - :dAryDnAmt[7],   
          "KFDN08" = "KFDN08" - :dAryDnAmt[8],   
          "KFDN09" = "KFDN09" - :dAryDnAmt[9],   
          "KFDN10" = "KFDN10" - :dAryDnAmt[10],   
          "KFDN11" = "KFDN11" - :dAryDnAmt[11],   
          "KFDN12" = "KFDN12" - :dAryDnAmt[12]
		WHERE ( "KFA04OM0"."KFYEAR" = Substr(:sKfChgDate,1,4) ) AND  
      	   ( "KFA04OM0"."KFCOD1" = :sKfCod1) AND ( "KFA04OM0"."KFCOD2" = :dKfCod2 )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[고정자산 잔고-매각,폐기]')
		Rollback;
		Return
	END IF
	
   IF sKfChgb = 'H' OR sKfChgb = 'I' OR sKfChgb = 'J' THEN
	   UPDATE "KFA02OM0"  
   	   SET "KFCHGB" = 'B',
      	    "KFDODT" = NULL  
      WHERE ( "KFA02OM0"."KFCOD1" = :sKfCod1 ) AND  
           ( "KFA02OM0"."KFCOD2"  = :dKfCod2 )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[고정자산 마스타]')
			Rollback;
			Return
		END IF
   END IF
END IF   

commit ;

dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(dw_1.GetRow(),"kfcod1",sKfCod1)
dw_1.SetItem(dw_1.GetRow(),"kfcod2",dKfCod2)
dw_1.SetColumn("kfacdat")
dw_1.SetFocus()

dw_1.SetRedraw(True)

sle_msg.text = "자료가 삭제되었습니다."

dw_2.ReTrieve(sKfCod1,dKfCod2) 

ib_any_typing = False

sModStatus ="I"
wf_retrievemode(sModStatus)


end event

type cb_inq from w_inherite`cb_inq within w_kfaa12
boolean visible = false
integer x = 315
integer y = 2760
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String DKFCOD1
Long DKFCOD2, ROW_NUM, RETRIEVE_ROW

dw_1.AcceptText()

row_num = dw_1.Getrow()

dkfcod1 = dw_1.GetItemString(row_num,"kfcod1")
dkfcod2 = dw_1.GetItemNumber(row_num,"kfcod2")

if IsNull(dkfcod1) then dkfcod1 = ""
if IsNull(dkfcod2) then dkfcod2 = 0

if dkfcod1 = "" or dkfcod2 = 0 then
   sle_msg.text = "자료조회시 고정자산코드는 필수 입력입니다."
   Messagebox("확 인","고정자산코드를 확인하시오. !!!")
	Return
end if

Retrieve_row = dw_2.Retrieve(dkfcod1,dkfcod2)

if Retrieve_row <= 0 then
	MessageBox("확 인","해당 고정자산코드에 해당하는 자료가 없습니다.!!")
   return
end if

sle_msg.text = ""
ib_any_typing =False

sModStatus ="I"
wf_retrievemode(sModStatus)

end event

type cb_print from w_inherite`cb_print within w_kfaa12
boolean visible = false
integer x = 1554
integer y = 2764
integer height = 104
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfaa12
end type

type cb_can from w_inherite`cb_can within w_kfaa12
boolean visible = false
integer x = 3067
integer y = 2760
integer taborder = 60
boolean cancel = true
end type

event cb_can::clicked;call super::clicked;LONG ROW_NUM

dw_1.Reset()
dw_1.InsertRow(0)

row_num = dw_1.Getrow()

dw_1.SetItem(row_num,"kfacdat","")
dw_1.SetItem(row_num,"kfacseq",0)
dw_1.SetItem(row_num,"kfchgb","")
dw_1.SetItem(row_num,"kfcust","")
dw_1.SetItem(row_num,"kfdamt",0)
dw_1.SetItem(row_num,"kfcamt",0)

dw_2.SelectRow(0,False)

ib_any_typing =False
sModStatus ="I"
wf_retrievemode(sModStatus)

sle_msg.text = ""



end event

type cb_search from w_inherite`cb_search within w_kfaa12
boolean visible = false
integer x = 1906
integer y = 2764
boolean enabled = false
end type

event cb_search::clicked;call super::clicked;//CHAR    dkfcod1, DKFCHGB, INTOCOD
//long    dkfcod2,  dkfacseq, row_num 
//string  dkfacdat, YY, dkfyear
//decimal dKFDAMT,  dKFCAMT, dKFRDE, rdeamt[12]
//decimal dkfdeamt, dramt[12], cramt[12] ,DEAMT[12]
//int     rc, mm, ii ,BUTTON_NUM
//
//
//SELECT "KFA07OM0"."KFYEAR"  
//	INTO :DKFYEAR  
//	FROM "KFA07OM0"  ;
//
//dw_1.AcceptText()
//
//row_num = dw_1.GetRow()
//dKFCOD1 = dw_1.GetItemString(row_num,"KFCOD1")
//dKFCOD2 = dw_1.GetItemNumber(row_num,"KFCOD2")
//dkfacdat= dw_1.GetItemstring(row_num,"kfacdat")
//dkfacseq= dw_1.GetItemNumber(row_num,"kfacseq")
//
//IF dw_2.GetSelectEDRow(0) <= 0 THEN 
//	MessageBox("확 인","삭제할 자료를 선택하세요.!!")
//	Return
//END IF
//
//SELECT   "KFA03OT0"."KFDAMT",   
//         "KFA03OT0"."KFCAMT", 
//         "KFA03OT0"."KFCHGB",
//         "KFA03OT0"."KFRDE",
//         "KFA03OT0"."KFRDE01",   
//         "KFA03OT0"."KFRDE02",   
//         "KFA03OT0"."KFRDE03",   
//         "KFA03OT0"."KFRDE04",   
//         "KFA03OT0"."KFRDE05",   
//         "KFA03OT0"."KFRDE06",   
//         "KFA03OT0"."KFRDE07",   
//         "KFA03OT0"."KFRDE08",   
//         "KFA03OT0"."KFRDE09",   
//         "KFA03OT0"."KFRDE10",   
//         "KFA03OT0"."KFRDE11",   
//         "KFA03OT0"."KFRDE12"       
//INTO     :DKFDAMT,   
//         :DKFCAMT,
//         :DKFCHGB,
//         :DKFRDE,
//         :RDEAMT[1],   
//         :RDEAMT[2],   
//         :RDEAMT[3],   
//         :RDEAMT[4],   
//         :RDEAMT[5],   
//         :RDEAMT[6],   
//         :RDEAMT[7],   
//         :RDEAMT[8],   
//         :RDEAMT[9],   
//         :RDEAMT[10],   
//         :RDEAMT[11],   
//         :RDEAMT[12]      
//FROM     "KFA03OT0"  
//WHERE ( "KFA03OT0"."KFCOD1"   = :DKFCOD1  ) AND  
//      ( "KFA03OT0"."KFCOD2"   = :DKFCOD2  ) AND  
//      ( "KFA03OT0"."KFACDAT"  = :DKFACDAT ) AND  
//      ( "KFA03OT0"."KFACSEQ"  = :DKFACSEQ )   ;
//
//IF SQLCA.SQLCODE <> 0 then
//   sle_msg.text   = "입력한 KEY에 해당하는 고정자산변동자료는 DB 상에 존재하지 않습니다."
//   Messagebox("확 인","자료가 존재하지 않습니다. !!!")
//   dw_1.setfocus()	 
//   Return
//End if
//
////YY = left(DKFacdat,4) 
////mm =  intEGER(mid(DKFacdat,5,2)) 
////if  DKFYEAR <> YY then
////    sle_msg.text = "고정자산 회기년도와 변동년도는 같아야 합니다."
////    Messagebox("확 인","회기년도와 변동일자를 비교 확인하시오. !!!")       
////    dw_1.setfocus()
////    Return
////end if
//
//if DKFCHGB = "A" or DKFCHGB = "B" or DKFCHGB = "C" or DKFCHGB = "K" then
//   sle_msg.text = "입력한 변동구분은 SYSTEM 내부에서 관리하는 코드입니다."
//   Messagebox("확 인","다음 고정자산 변동구분은 삭제 불가능 합니다. !!!" &
//                     + "~n~nA : 신규취득 ~nB : 과년도취득 ~nC : 자동감가상각" &
//                     + "~nK : 상각완료")
//   dw_1.SetFocus()
//   return
//END IF
//
//if DKFCHGB = "F" or DKFCHGB = "G" or DKFCHGB = "H" or DKFCHGB = "I" then
//    SELECT "KFA03OT0"."KFCOD1"  
//    INTO :INTOCOD 
//    FROM "KFA03OT0"  
//    WHERE ( "KFA03OT0"."KFCOD1" = :DKFCOD1 ) AND  
//          ( "KFA03OT0"."KFCOD2" = :DKFCOD2 ) AND  
//          ( "KFA03OT0"."KFACDAT"||"KFA03OT0"."KFACSEQ" > :DKFACDAT||:DKFACSEQ ) AND 
//          ( "KFA03OT0"."KFCHGB" >= 'F' ) AND  
//          ( "KFA03OT0"."KFCHGB" <= 'I' )  ;
//
//   IF SQLCA.SQLCODE = 0 then
//   sle_msg.text   = "매각/폐기된 자료는 발생순서의 역순으로 삭제하시오."
//   Messagebox("확 인","매각/폐기된 자료가 입력한 변동일자,순번 뒤에 존재합니다. !!!")
//   dw_1.setfocus()	 
//   Return
//   End if
//END IF
//BUTTON_NUM = Messagebox("확 인","자료를 삭제하시겠습니까 ?",Question!,OKCancel!,2)
//if button_num = 2 then
//   dw_1.Setfocus()
//   return
//else
//   rc =  DW_1.DeleteRow(0) 
//
//   IF rc = 1 then
//      rc = DW_1.Update() 
//
//      if rc = 1 then
//         dw_1.Reset()
//         dw_1.InsertRow(0)
//         sle_msg.text = "자료가 삭제되었습니다."
//         dw_1.SetItem(row_num,"KFCOD1",DKFCOD1)
//         dw_1.SetItem(row_num,"KFCOD2",DKFCOD2)
//         commit ;
//         dw_2.ReTrieve(dKFCOD1,dKFCOD2) 
//         dw_1.SetFocus()
//         cb_ins.Enabled = True
//       else
//         sle_msg.text = "저장실패" + sqlca.sqlerrtext
//         rollback ;
//       end if
//
//    end if
//end if
//
//dw_1.SetFocus()
//
//IF rc = 1 then
// 
//    if DKFCHGB = "D" then
//
//         SELECT "KFA04OM0"."KFDR01",   
//         "KFA04OM0"."KFDR02",   
//         "KFA04OM0"."KFDR03",   
//         "KFA04OM0"."KFDR04",   
//         "KFA04OM0"."KFDR05",   
//         "KFA04OM0"."KFDR06",   
//         "KFA04OM0"."KFDR07",   
//         "KFA04OM0"."KFDR08",   
//         "KFA04OM0"."KFDR09",   
//         "KFA04OM0"."KFDR10",   
//         "KFA04OM0"."KFDR11",   
//         "KFA04OM0"."KFDR12"  
//    INTO :DRAMT[1],   
//         :DRAMT[2],   
//         :DRAMT[3],   
//         :DRAMT[4],   
//         :DRAMT[5],   
//         :DRAMT[6],   
//         :DRAMT[7],   
//         :DRAMT[8],   
//         :DRAMT[9],   
//         :DRAMT[10],   
//         :DRAMT[11],   
//         :DRAMT[12]  
//    FROM "KFA04OM0"  
//    WHERE ( "KFA04OM0"."KFYEAR" = :YY ) AND  
//         ( "KFA04OM0"."KFCOD1" = :DKFCOD1 ) AND  
//         ( "KFA04OM0"."KFCOD2" = :DKFCOD2 )   ;
//
//    if SQLCA.SQLCODE <> 0 then
//    sle_msg.text   = "고정자산 잔고 SELECT문 ERROR " + SQLCA.SQLERRTEXT
//    Return
//    end if
//   
//    DRAMT[MM] = DRAMT[MM] - DKFDAMT
//    
//     UPDATE "KFA04OM0"  
//     SET "KFDR01" = :DRAMT[1],   
//         "KFDR02" = :DRAMT[2],   
//         "KFDR03" = :DRAMT[3],   
//         "KFDR04" = :DRAMT[4],   
//         "KFDR05" = :DRAMT[5],   
//         "KFDR06" = :DRAMT[6],   
//         "KFDR07" = :DRAMT[7],   
//         "KFDR08" = :DRAMT[8],   
//         "KFDR09" = :DRAMT[9],   
//         "KFDR10" = :DRAMT[10],   
//         "KFDR11" = :DRAMT[11],   
//         "KFDR12" = :DRAMT[12]  
//   WHERE ( "KFA04OM0"."KFYEAR" = :YY ) AND  
//         ( "KFA04OM0"."KFCOD1" = :DKFCOD1 ) AND  
//         ( "KFA04OM0"."KFCOD2" = :DKFCOD2 )   ;
//
//    if SQLCA.SQLCODE <> 0 then
//    sle_msg.text   = "고정자산 잔고 UPDATE문 ERROR " + SQLCA.SQLERRTEXT
//    Return
//    end if
//   
//   END IF
//  
//   if DKFCHGB = "F" OR DKFCHGB = "G" OR DKFCHGB = "H" OR DKFCHGB = "I" then
//
//  SELECT "KFA04OM0"."KFDEAMT",   
//         "KFA04OM0"."KFCR01",   
//         "KFA04OM0"."KFCR02",   
//         "KFA04OM0"."KFCR03",   
//         "KFA04OM0"."KFCR04",   
//         "KFA04OM0"."KFCR05",   
//         "KFA04OM0"."KFCR06",   
//         "KFA04OM0"."KFCR07",   
//         "KFA04OM0"."KFCR08",   
//         "KFA04OM0"."KFCR09",   
//         "KFA04OM0"."KFCR10",   
//         "KFA04OM0"."KFCR11",   
//         "KFA04OM0"."KFCR12",  
//         "KFA04OM0"."KFDE01",   
//         "KFA04OM0"."KFDE02",   
//         "KFA04OM0"."KFDE03",   
//         "KFA04OM0"."KFDE04",   
//         "KFA04OM0"."KFDE05",   
//         "KFA04OM0"."KFDE06",   
//         "KFA04OM0"."KFDE07",   
//         "KFA04OM0"."KFDE08",   
//         "KFA04OM0"."KFDE09",   
//         "KFA04OM0"."KFDE10",   
//         "KFA04OM0"."KFDE11",   
//         "KFA04OM0"."KFDE12"  
//    INTO :DKFDEAMT, 
//         :CRAMT[1],   
//         :CRAMT[2],   
//         :CRAMT[3],   
//         :CRAMT[4],   
//         :CRAMT[5],   
//         :CRAMT[6],   
//         :CRAMT[7],   
//         :CRAMT[8],   
//         :CRAMT[9],   
//         :CRAMT[10],   
//         :CRAMT[11],   
//         :CRAMT[12],
//         :DEAMT[1],   
//         :DEAMT[2],   
//         :DEAMT[3],   
//         :DEAMT[4],   
//         :DEAMT[5],   
//         :DEAMT[6],   
//         :DEAMT[7],   
//         :DEAMT[8],   
//         :DEAMT[9],   
//         :DEAMT[10],   
//         :DEAMT[11],   
//         :DEAMT[12]    
//    FROM "KFA04OM0"  
//    WHERE ( "KFA04OM0"."KFYEAR" = :YY ) AND  
//         ( "KFA04OM0"."KFCOD1" = :DKFCOD1 ) AND  
//         ( "KFA04OM0"."KFCOD2" = :DKFCOD2 )   ;
//
//    if SQLCA.SQLCODE <> 0 then
//    sle_msg.text   = "고정자산 잔고 SELECT문 ERROR " + SQLCA.SQLERRTEXT
//    Return
//    end if
//   
//    CRAMT[MM] = CRAMT[MM] - DKFCAMT
//    DKFDEAMT = DKFDEAMT + DKFRDE
//    FOR II = 1 TO 12
//	     DEAMT[II] = DEAMT[II] + RDEAMT[II]
//    NEXT
//
//     UPDATE "KFA04OM0"
//     SET "KFDEAMT" = :DKFDEAMT,     
//         "KFCR01" = :CRAMT[1],   
//         "KFCR02" = :CRAMT[2],   
//         "KFCR03" = :CRAMT[3],   
//         "KFCR04" = :CRAMT[4],   
//         "KFCR05" = :CRAMT[5],   
//         "KFCR06" = :CRAMT[6],   
//         "KFCR07" = :CRAMT[7],   
//         "KFCR08" = :CRAMT[8],   
//         "KFCR09" = :CRAMT[9],   
//         "KFCR10" = :CRAMT[10],   
//         "KFCR11" = :CRAMT[11],   
//         "KFCR12" = :CRAMT[12], 
//         "KFDE01" = :DEAMT[1],   
//         "KFDE02" = :DEAMT[2],   
//         "KFDE03" = :DEAMT[3],   
//         "KFDE04" = :DEAMT[4],   
//         "KFDE05" = :DEAMT[5],   
//         "KFDE06" = :DEAMT[6],   
//         "KFDE07" = :DEAMT[7],   
//         "KFDE08" = :DEAMT[8],   
//         "KFDE09" = :DEAMT[9],   
//         "KFDE10" = :DEAMT[10],   
//         "KFDE11" = :DEAMT[11],   
//         "KFDE12" = :DEAMT[12]   
//   WHERE ( "KFA04OM0"."KFYEAR" = :YY ) AND  
//         ( "KFA04OM0"."KFCOD1" = :DKFCOD1 ) AND  
//         ( "KFA04OM0"."KFCOD2" = :DKFCOD2 )   ;
//
//    if SQLCA.SQLCODE <> 0 then
//    sle_msg.text   = "고정자산 잔고 UPDATE문 ERROR " + SQLCA.SQLERRTEXT
//    Return
//    end if
//   
//   END IF
//
//   if DKFCHGB = "H" OR DKFCHGB = "I" then
//
//      UPDATE "KFA02OM0"  
//      SET "KFCHGB" = 'B',   
//          "KFDODT" = ''  
//      WHERE ( "KFA02OM0"."KFCOD1" = :DKFCOD1 ) AND  
//           ( "KFA02OM0"."KFCOD2"  = :DKFCOD2 )   ;
//
//      if SQLCA.SQLCODE <> 0 then
//      sle_msg.text   = "고정자산 마스타 UPDATE문 ERROR " + SQLCA.SQLERRTEXT
//      Return
//      end if
//   
//   END IF
//
//END IF
//ib_any_typing =False
end event

type dw_datetime from w_inherite`dw_datetime within w_kfaa12
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfaa12
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfaa12
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfaa12
boolean visible = false
integer x = 283
integer y = 2704
integer width = 393
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa12
boolean visible = false
integer x = 2318
integer y = 2704
end type

type dw_2 from datawindow within w_kfaa12
integer x = 315
integer y = 776
integer width = 4247
integer height = 1456
boolean bringtotop = true
string dataobject = "d_kfaa122"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;CHAR   DKFCOD1
LONG   DKFCOD2, DKFACSEQ
STRING DKFACDAT

if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)

DKFCOD1 = GetItemString(row,"kfcod1")
dkfcod2 = GetItemNumber(row,"kfcod2")
dkfacdat = GetItemString(row,"kfacdat")
dkfacseq = GetItemNumber(row,"kfacseq")

dw_1.Retrieve(dkfcod1,dkfcod2,dkfacdat,dkfacseq)

ib_any_typing =False

sModStatus ="M"
wf_retrievemode(sModStatus)
end event

type dw_1 from datawindow within w_kfaa12
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 270
integer y = 8
integer width = 3470
integer height = 736
integer taborder = 10
string dataobject = "d_kfaa121"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sKfCod1,sKfChgb,sChangeDate,sKfYear,sKfName,sTempCode,snull,sKfCust,sKfCustName,sGubun1
Double dKfCod2,dBuyAmount,dNuSangAmount,dKfcAmt,dKfRdeAmt,dKfRdeAmt1	
Integer iCurRow,lnull

SetNull(snull)
SetNull(lnull)

w_mdi_frame.sle_msg.text = ''

iCurRow = dw_1.GetRow()
IF this.GetColumnName() = "kfcod1" THEN
	sKfCod1 = this.GetText()
	IF sKfCod1 = "" OR IsNull(sKfCod1) THEN 
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		this.SetItem(iCurRow,"kfrde",     0)
		this.SetItem(iCurRow,"kfrde01",   0)
		this.SetItem(iCurRow,"gubun1",    '')
		Return 
	END IF
	
	dKfCod2 = this.GetItemNumber(iCurRow,"kfcod2")
	IF dKfCod2 = 0 OR IsNull(dKfCod2) THEN 
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		this.SetItem(iCurRow,"kfrde",     0)
		this.SetItem(iCurRow,"kfrde01",   0)
		this.SetItem(iCurRow,"gubun1",    '')
		Return
	END IF
	
	SELECT "KFA02OM0"."KFNAME", "KFA02OM0"."GUBUN1"  		INTO :sKfName,  :sGubun1
		FROM "KFA02OM0"  
		WHERE ( "KFA02OM0"."KFCOD1" = :sKfCod1) AND ( "KFA02OM0"."KFCOD2" = :dKfCod2 );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[고정자산번호]')
		this.SetItem(iCurRow,"kfcod1",snull)
		this.SetItem(iCurRow,"kfcod2",lnull)
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		this.SetItem(iCurRow,"kfrde",     0)
		this.SetItem(iCurRow,"kfrde01",   0)
		this.SetItem(iCurRow,"gubun1",    '')
		Return 1
	END IF
	
	this.SetItem(iCurRow,"gubun1",    sGubun1)
	
	sChangeDate = Trim(this.GetItemString(iCurRow,"kfacdat"))
	IF sChangeDate = "" OR IsNull(sChangeDate) THEN
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		Return
	END IF
	
	Wf_Get_Amount(sKfCod1,dKfCod2,Left(sChangeDate,6),dBuyAmount,dNuSangAmount)
	
	this.SetItem(iCurRow,"kfrde02",   dBuyAmount)
	this.SetItem(iCurRow,"kfrde03",   dNuSangAmount)
END IF

IF this.GetColumnName() = "kfcod2" THEN
	dKfCod2 = Double(this.GetText())
	IF dKfCod2 = 0 OR IsNull(dKfCod2) THEN 
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		this.SetItem(iCurRow,"kfrde",     0)
		this.SetItem(iCurRow,"kfrde01",   0)
		this.SetItem(iCurRow,"gubun1",    '')
		Return
	END IF
	
	sKfCod1 = this.GetItemString(iCurRow,"kfcod1")
	IF sKfCod1 = "" OR IsNull(sKfCod1) THEN 
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		this.SetItem(iCurRow,"kfrde",     0)
		this.SetItem(iCurRow,"kfrde01",   0)
		this.SetItem(iCurRow,"gubun1",    '')
		Return
	END IF
	
	SELECT "KFA02OM0"."KFNAME", "KFA02OM0"."GUBUN1"  		INTO :sKfName,  :sGubun1
		FROM "KFA02OM0"  
		WHERE ( "KFA02OM0"."KFCOD1" = :sKfCod1) AND ( "KFA02OM0"."KFCOD2" = :dKfCod2 );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[고정자산번호]')
		this.SetItem(iCurRow,"kfcod1",snull)
		this.SetItem(iCurRow,"kfcod2",lnull)
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		this.SetItem(iCurRow,"kfrde",     0)
		this.SetItem(iCurRow,"kfrde01",   0)
		this.SetItem(iCurRow,"gubun1",    '')
		this.SetColumn("kfcod1")
		this.SetFocus()
		Return 1
	END IF
	this.SetItem(iCurRow,"gubun1",    sGubun1)
	
	sChangeDate = Trim(this.GetItemString(iCurRow,"kfacdat"))
	IF sChangeDate = "" OR IsNull(sChangeDate) THEN
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		this.SetItem(iCurRow,"kfrde",     0)
		this.SetItem(iCurRow,"kfrde01",   0)
		Return
	END IF
	
	Wf_Get_Amount(sKfCod1,dKfCod2,Left(sChangeDate,6),dBuyAmount,dNuSangAmount)
	
	this.SetItem(iCurRow,"kfrde02",   dBuyAmount)
	this.SetItem(iCurRow,"kfrde03",   dNuSangAmount)
END IF

IF this.GetColumnName() = "kfacdat" THEN
	schangeDate = Trim(this.GetText())
	IF schangeDate = "" OR IsNull(schangeDate) THEN 
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		this.SetItem(iCurRow,"kfrde",     0)
		this.SetItem(iCurRow,"kfrde01",   0)
		Return 
	END IF
	
	IF F_DateChk(sChangeDate) = -1 THEN
		F_Messagechk(21,'[변동일자]')
		this.SetItem(iCurRow,"kfacdat",snull)
		Return 1	
	ELSE
		SELECT "KFA07OM0"."KFYEAR"  	INTO :sKfYear			FROM "KFA07OM0"  ;
		IF sKfYear <> Left(sChangeDate,4) THEN
      	Messagebox("확 인","회기년도와 변동일자의 변동년도를 비교 확인하시오. !!!")       
       	this.SetItem(iCurRow,"kfacdat",snull)
       	Return 1
   	END IF
	END IF
	
	sKfCod1 = this.GetItemString(iCurRow,"kfcod1")
	dKfCod2 = this.GetItemNumber(iCurRow,"kfcod2")
	IF sKfcod1 = "" OR IsNull(sKfcod1) OR dKfCod2 = 0 OR IsNull(dKfCod2) THEN 
		this.SetItem(iCurRow,"kfrde02",   0)
		this.SetItem(iCurRow,"kfrde03",   0)
		Return
	END IF
	
	Wf_Get_Amount(sKfCod1,dKfCod2,Left(sChangeDate,6),dBuyAmount,dNuSangAmount)
	
	this.SetItem(iCurRow,"kfrde02",   dBuyAmount)
	this.SetItem(iCurRow,"kfrde03",   dNuSangAmount)
END IF

IF this.GetColumnName() = "kfchgb" THEN
	sKfChgb = this.GetText()
	IF sKfChgb = "" OR IsNull(sKfChgb) THEN Return
	
	IF IsNull(F_Get_Refferance('F5',sKfChgb)) THEN
		F_MessageChk(20,'[고정자산번호]')
		this.SetItem(iCurRow,"kfchgb",snull)
		Return 1
	END IF

	IF sKfChgb = 'A' OR sKfChgb = 'B' OR sKfChgb = 'C' OR sKfChGb = 'K' THEN
		Messagebox("확 인","입력한 변동구분코드는 사용할 수 없읍니다. !!!")
		w_mdi_frame.sle_msg.text = "입력한 변동구분은 SYSTEM 내부에서 관리하는 코드입니다."
		this.SetItem(iCurRow,"kfchgb",snull)
		Return 1
	END IF
	
	IF sKfChgb = 'D' OR sKfChgb = 'E' THEN
		this.SetItem(iCurRow,"kfcamt",0)
	END IF

	sKfCod1 = this.GetItemString(iCurRow,"kfcod1")
	dKfCod2 = this.GetItemNumber(iCurRow,"kfcod2")
	IF sKfcod1 = "" OR IsNull(sKfcod1) OR dKfCod2 = 0 OR IsNull(dKfCod2) THEN 
		this.SetItem(iCurRow,"kfcamt", 0)
	   this.SetItem(iCurRow,"kfrde",  0)
		Return
	END IF
	
	sChangeDate = Trim(this.GetItemString(iCurRow,"kfacdat"))
	IF sChangeDate = "" OR IsNull(sChangeDate) THEN
		this.SetItem(iCurRow,"kfcamt", 0)
	   this.SetItem(iCurRow,"kfrde",  0)
		Return
	END IF
	
	IF sKfChgb = 'H' OR sKfChgb = 'I' OR sKfChgb = 'J' THEN
		Wf_Get_Amount(sKfCod1,dKfCod2,Left(sChangeDate,6),dKfcAmt,dNuSangAmount)
	ELSE
		dKfcAmt = 0				
	END IF
	this.SetItem(iCurRow,"kfcamt", dKfcAmt)
   this.SetItem(iCurRow,"kfrde",  dKfcAmt)	
	
	Wf_Calculation_Amount(sKfCod1,dKfCod2,sKfChgb,Left(sChangeDate,6),dKfcAmt,dKfRdeAmt,dKfRdeAmt1)

	this.SetItem(iCurRow,"kfrde",  dKfRdeAmt)
	this.SetItem(iCurRow,"kfrde01",dKfRdeAmt1)
	
END IF

IF this.GetColumnName() = "kfcust" THEN
	sKfCust = this.GetText()
	IF sKfCust = "" OR IsNull(sKfCust) THEN 
		this.SetItem(iCurRow,"kfcustname", sKfCustName)	
		Return
	END IF
	
	sKfCustName = F_Get_PersonLst('1',sKfCust,'%')
	IF IsNull(sKfCustName) THEN
		F_MessageChk(20,'[거래처]')
		this.SetItem(iCurRow,"kfcust",snull)
		Return 1
	END IF
	this.SetItem(iCurRow,"kfcustname", sKfCustName)	
END IF

IF this.GetColumnName() = "kfcamt" THEN
	dKfcAmt = Double(this.GetText())
	if dKfcAmt = 0 or IsNull(dKfcAmt) then
		this.SetItem(iCurRow,"kfrde",0)
		this.SetItem(iCurRow,"kfrde01",0)
		Return
	end if
	
	/*충당금감소액 계산*/
	String sKfChgDate
	
	sKfCod1    = this.GetItemString(iCurRow,"kfcod1")
	dKfCod2    = this.GetItemNumber(iCurRow,"kfcod2")
	sKfChgDate = Trim(this.GetItemString(iCurRow,"kfacdat")) 
	sKfChGb    = this.GetItemString(iCurRow,"kfchgb")
	
	Wf_Calculation_Amount(sKfCod1,dKfCod2,sKfChgb,Left(sKfChgDate,6),dKfcAmt,dKfRdeAmt,dKfRdeAmt1)

	this.SetItem(iCurRow,"kfrde",  dKfRdeAmt)
	this.SetItem(iCurRow,"kfrde01",dKfRdeAmt1)
END IF

IF this.GetColumnName() = "kfrde" THEN
	dKfRdeAmt = Double(this.GetText())
	if dKfRdeAmt = 0 or IsNull(dKfRdeAmt) then dKfRdeAmt = 0
	
	dKfcAmt = this.GetItemNumber(iCurRow,"kfcamt")
	if dKfcAmt = 0 or IsNull(dKfcAmt) then dKfcAmt = 0
	
	this.SetItem(iCurRow,"kfrde01",dKfcAmt - dKfRdeAmt)
END IF


 
end event

event rbuttondown;String dkfcod1
long   dkfcod2, row_num, retrieve_row 

IF this.GetColumnName() ="kfcod2" THEN 	
	SetNull(gs_code)
	SetNull(gs_codename)

	row_num  = dw_1.Getrow()

	dkfcod1 = dw_1.GetItemString( row_num, "kfcod1")
	dkfcod2 = dw_1.GetItemNumber( row_num, "kfcod2")

	IF Isnull(dkfcod1) then dkfcod1 = ""
	if Isnull(dkfcod2) then dkfcod2 = 0

	gs_code = dkfcod1
	gs_codename = String(dkfcod2)

	open(w_kfaa02b)
	
	IF IsNull(gs_code) THEN RETURN
	
   dw_1.setitem(dw_1.Getrow(),"kfcod1",gs_code)
   dw_1.Setitem(dw_1.Getrow(),"kfcod2",Long(gs_codename))
	
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="kfcust" THEN
	SetNull(lstr_custom.code);		SetNull(lstr_custom.name);
	
	OpenWithParm(W_KFZ04OM0_POPUP,'1')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"kfcust",     lstr_custom.code)
	this.SetItem(this.GetRow(),"kfcustname", lstr_custom.name)
	
	this.TriggerEvent(ItemChanged!)
	
END IF


end event

event editchanged;ib_any_typing =True
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_kfaa12
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 306
integer y = 768
integer width = 4306
integer height = 1468
integer cornerheight = 40
integer cornerwidth = 46
end type

