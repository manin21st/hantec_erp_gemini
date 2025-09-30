$PBExportHeader$w_kfia01.srw
$PBExportComments$예적금등록
forward
global type w_kfia01 from w_inherite
end type
type dw_gbn from datawindow within w_kfia01
end type
type dw_1 from u_key_enter within w_kfia01
end type
type dw_list from u_d_popup_sort within w_kfia01
end type
type rr_1 from roundrectangle within w_kfia01
end type
end forward

global type w_kfia01 from w_inherite
string title = "예적금 등록"
dw_gbn dw_gbn
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
end type
global w_kfia01 w_kfia01

type variables
Boolean Lb_AutoFlag =True
end variables

forward prototypes
public subroutine wf_setting_retrievemode (string mode)
public function integer wf_data_chk (string scolname, string scolvalue)
public function integer wf_chk_unrequired ()
public function integer wf_kfz04om0_update ()
public subroutine wf_init ()
public function integer wf_requiredchk (integer icurrow)
end prototypes

public subroutine wf_setting_retrievemode (string mode);//dw_1.SetRedraw(False)
//IF mode ="M" THEN
//	dw_1.SetTabOrder("ab_dpno",0)
//	dw_1.SetColumn("ab_name")
//	
//	cb_del.Enabled =True
//ELSE
//	dw_1.SetTabOrder("ab_dpno",10)
//	dw_1.SetColumn("ab_dpno")
//	cb_del.Enabled =False
//END IF
//dw_1.SetFocus()
//dw_1.SetRedraw(True)
end subroutine

public function integer wf_data_chk (string scolname, string scolvalue);String  snull,ssql,ssano,sacc,sdate,sCurr
Date    datef,datet
Double  ldb_calc,dYamt
Integer iWeight

SetNull(snull)

IF scolname = 'auto_flag' THEN
	IF sColValue ='Y' THEN
		Lb_AutoFlag = True	
	ELSe
		Lb_AutoFlag = False
	END IF
END IF

IF scolname ="acc1_cd" THEN
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC2_NM"
   	INTO :ssql 
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :sacc )   ;
	IF SQLCA.SQLCODE <> 0 THEN 
//		f_messagechk(20,"계정과목") 
//		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",snull)
//		dw_1.SetColumn("acc1_cd")
//		dw_1.SetFocus()
//		Return -1
	ELSE
		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",ssql)
	END IF
END IF

IF scolname ="acc2_cd" THEN
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC2_NM"
   	INTO :ssql
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :scolvalue)   ;
	IF SQLCA.SQLCODE <> 0 THEN 
//		f_messagechk(20,"계정과목")
//		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",snull)
//		dw_1.SetColumn("acc1_cd")
//		dw_1.SetFocus()
//		Return -1
	ELSE
		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",ssql)
	END IF
END IF
//지급은행//
IF scolname ="bnk_cd" THEN
	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :ssql  
    	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  
         	( "KFZ04OM0"."PERSON_GU" = '2' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"지급은행")
		dw_1.SetItem(1,"bnk_cd",snull)
		Return -1
	END IF
END IF

//개설일자//
IF scolname ="ab_fst" THEN
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"개설일자") 
		dw_1.SetItem(1,"ab_fst",snull)
		Return -1
	ELSE
		sdate = Trim(dw_1.GetItemString(dw_1.GetRow(),"ab_tst"))
		IF sdate = "" OR IsNull(sdate) THEN RETURN 1
		
		datef =Date(Left(scolvalue,4)+"/"+Mid(scolvalue,5,2)+"/"+Right(scolvalue,2))
		datet =Date(Left(sdate,4)+"/"+Mid(sdate,5,2)+"/"+Right(sdate,2))
		
		IF DaysAfter(datef,datet) <= 0 THEN
			MessageBox("확 인","날짜범위를 확인하세요.!!")
			dw_1.SetItem(1,"ab_fst",snull)
			Return -1
		END IF
	END IF
END IF

//만기일자//
IF scolname ="ab_tst" THEN
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"만기일자") 
		dw_1.SetItem(1,"ab_tst",snull)
		Return -1
	ELSE
		sdate = Trim(dw_1.GetItemString(dw_1.GetRow(),"ab_fst"))
		IF sdate = "" OR IsNull(sdate) THEN RETURN 1
		
		datef =Date(Left(sdate,4)+"/"+Mid(sdate,5,2)+"/"+Right(sdate,2))
		datet =Date(Left(scolvalue,4)+"/"+Mid(scolvalue,5,2)+"/"+Right(scolvalue,2))
		
		IF DaysAfter(datef,datet) <= 0 THEN
			MessageBox("확 인","날짜범위를 확인하세요.!!")
			dw_1.SetItem(1,"ab_tst",snull)
			Return -1
		END IF
	END IF
END IF

//IF scolname ="ab_mamt" THEN
//	IF Double(scolvalue) = 0 THEN 
//		sle_msg.text ="월불입금액이 '0'입니다.!!"
//		MessageBox("확 인","월불입금액을 확인하세요.!!")
//		dw_1.SetItem(1,"ab_mamt",snull)
//		Return -1
//	END IF
//END IF

IF scolname ="ab_curr" THEN
	SELECT "REFFPF"."RFNA1"  
   	INTO :ssql  
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."SABU" = '1' ) AND  
      	   ( "REFFPF"."RFCOD" = '10' ) AND  
         	( "REFFPF"."RFGUB" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","사용가능한 통화구분이 아닙니다.!!")
		dw_1.SetItem(1,"ab_curr",snull)
		Return -1
	END IF
END IF

IF scolname ="ab_ytamt" THEN
	IF IsNull(scolvalue) OR Double(scolvalue) =0 THEN RETURN 1
	
	ldb_calc =dw_1.GetItemNumber(dw_1.GetRow(),"ab_excrat")
	IF IsNull(ldb_calc) OR ldb_calc =0 THEN RETURN 1
	
	sCurr = dw_1.GetItemString(dw_1.GetRow(),"ab_curr")
	IF sCurr = "" OR IsNull(sCurr) THEN Return 1
	
	select nvl(to_number(rfna2),1) into :iWeight
		from reffpf
		where rfcod = '10' and rfgub = :sCurr;
		
	dw_1.SetItem(dw_1.GetRow(),"ab_tamt", Round((Double(scolvalue) * ldb_calc) / iWeight,0))
END IF

IF scolname ="ab_excrat" THEN
	IF IsNull(scolvalue) OR Double(scolvalue) =0 THEN RETURN 1
	
	ldb_calc =dw_1.GetItemNumber(dw_1.GetRow(),"ab_ytamt")
	IF IsNull(ldb_calc) OR ldb_calc =0 THEN RETURN 1

	sCurr = dw_1.GetItemString(dw_1.GetRow(),"ab_curr")
	IF sCurr = "" OR IsNull(sCurr) THEN Return 1
	
	select nvl(to_number(rfna2),1) into :iWeight
		from reffpf
		where rfcod = '10' and rfgub = :sCurr;

	dw_1.SetItem(dw_1.GetRow(),"ab_tamt", Round((Double(scolvalue) * ldb_calc) / iWeight,0))
END IF

IF sColName = 'ab_curr' THEN
	IF IsNull(scolvalue) OR scolvalue ='' THEN RETURN 1
	
	dYamt =dw_1.GetItemNumber(dw_1.GetRow(),"ab_ytamt")
	IF IsNull(dYamt) OR dYamt =0 THEN RETURN 1
	
	ldb_calc =dw_1.GetItemNumber(dw_1.GetRow(),"ab_excrat")
	IF IsNull(ldb_calc) OR ldb_calc =0 THEN RETURN 1
	
	select nvl(to_number(rfna2),1) into :iWeight
		from reffpf
		where rfcod = '10' and rfgub = :sColValue;

	dw_1.SetItem(dw_1.GetRow(),"ab_tamt", Round((dYAmt * ldb_calc) / iWeight,0))	
END IF
//IF scolname ="ab_rat" THEN
//	IF Double(scolvalue) = 0 THEN 
//		MessageBox("확 인","이율을 확인하세요.!!")
//		dw_1.SetItem(1,"ab_rat",snull)
//		Return -1
//	END IF
//END IF

IF scolname ="ab_cdate" THEN
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"해지일자") 
		dw_1.SetItem(1,"ab_cdate",snull)
		Return -1
	END IF
END IF

IF scolname ="ab_dambobank" THEN
	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :ssql  
    	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  
         	( "KFZ04OM0"."PERSON_GU" = '2' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"담보제공기관")
		dw_1.SetItem(1,"ab_dambobank",snull)
		Return -1
	END IF
END IF

IF scolname ="ab_dambodate" THEN
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"담보제공일") 
		dw_1.SetItem(1,"ab_dambodate",snull)
		Return -1
	END IF
END IF

IF scolname ="ab_dambocanceldate" THEN
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"담보해지일") 
		dw_1.SetItem(1,"ab_dambocanceldate",snull)
		Return -1
	END IF
END IF

IF scolname ="alc_gu" THEN
	IF scolvalue <> "Y" AND scolvalue <> "N" THEN
		f_messagechk(20,"승인구분")
		dw_1.SetItem(1,"alc_gu",snull)
		dw_1.SetColumn("alc_gu")
		Return -1
	END IF
END IF

IF scolname ="saupj" THEN
	IF scolvalue = "99" THEN
		f_messagechk(20,"사업장")
		dw_1.SetItem(1,"saupj",snull)
		dw_1.SetColumn("saupj")
		Return -1
	END IF
END IF

Return 1
end function

public function integer wf_chk_unrequired ();//IF dw_jung.Visible =True or dw_etc.Visible = true THEN
//	IF DaysAfter(Date(ls_gae),Date(ls_man)) <= 0 THEN
//		MessageBox("확  인","만기일자가 계약일자와 같거나 빠르면 안됩니다.확인하세요.!!!")
//		dw_1.SetColumn("ab_fst")
//		dw_1.SetFocus()
//		Return
//	END IF
//END IF
Return 1

end function

public function integer wf_kfz04om0_update ();String scode,sname,sgu,sbnkcd,sacc1,sacc2,sab_no

dw_1.AcceptText()

scode  =dw_1.GetItemString(dw_1.GetRow(),"ab_dpno")
sname  =dw_1.GetItemString(dw_1.GetRow(),"ab_name")
sab_no =dw_1.GetItemString(dw_1.GetRow(),"ab_no")
sbnkcd =dw_1.GetItemString(dw_1.GetRow(),"bnk_cd")
sacc1  =dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sacc2  =dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
sgu ='5'

IF f_mult_custom(scode,sname,sgu,sab_no,sbnkcd,sacc1,sacc2,'') = -1 THEN RETURN -1

Return 1
end function

public subroutine wf_init ();String snull
Int lnull

SetNull(snull)
SetNull(lnull)

dw_1.SetRedraw(False)

dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(dw_1.GetRow(),"ab_fst",String(today(),"yyyymmdd"))

dw_1.SetItem(dw_1.GetRow(),"ab_curr",'WON')
dw_1.SetItem(dw_1.GetRow(),"saupj",  gs_saupj)
dw_1.SetItem(dw_1.GetRow(),"ab_sgbn",'1')

//IF F_Authority_Fund_Chk(Gs_Dept)	 = -1 THEN							/*권한 체크- 현업 여부*/	
//	dw_1.Modify("saupj.protect = 1")
//	dw_1.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
//ELSE
//	dw_1.Modify("saupj.protect = 0")
//	dw_1.Modify("saupj.background.color ='"+String(RGB(190,225,184))+"'")
//END IF	

dw_1.SetColumn("ab_dpno")
dw_1.SetFocus()

dw_1.SetRedraw(True)

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

ib_any_typing =False

lb_autoflag = True

smodstatus ="I"

wf_setting_retrievemode(smodstatus)

end subroutine

public function integer wf_requiredchk (integer icurrow);String sAbDpNo,sAbName,sAcc1,sAcc2,sBnkCd,sAbNo,sAbDate,sAbCurr,sSaupj,sAutoTag,sAbJGbn
Double dRate

dw_1.AcceptText()
sAbJGbn = dw_1.GetItemString(icurrow,"ab_jgbn")
sAbDpNo = dw_1.GetItemString(icurrow,"ab_dpno")
sAbName = dw_1.GetItemString(icurrow,"ab_name")
sAcc1   = dw_1.GetItemString(icurrow,"acc1_cd")
sAcc2   = dw_1.GetItemString(icurrow,"acc2_cd")
sBnkCd  = dw_1.GetItemString(icurrow,"bnk_cd")
sAbNo   = dw_1.GetItemString(icurrow,"ab_no")
sAbDate = dw_1.GetItemString(icurrow,"ab_tst")
sAbCurr = dw_1.GetItemString(icurrow,"ab_curr")
sSaupj  = dw_1.GetItemString(icurrow,"saupj")
dRate   = dw_1.GetItemNumber(icurrow,"ab_rat")

sAutoTag = dw_1.GetItemString(icurrow,"auto_flag")

IF sAbJGbn = "" OR IsNull(sAbJGbn) THEN
	F_MessageChk(1,'[예금종류]')
	dw_gbn.SetColumn("ab_jgbn")
	dw_gbn.SetFocus()
	Return -1
END IF

IF sAutoTag = 'N' THEN
	IF sAbDpNo = "" OR IsNull(sAbDpNo) THEN
		F_MessageChk(1,'[예적금코드]')
		dw_1.SetColumn("ab_dpno")
		dw_1.SetFocus()
		Return -1
	END IF
	Lb_AutoFlag = False
ELSE
	Lb_AutoFlag = True	
END IF

IF sAbName = "" OR IsNull(sAbName) THEN
	F_MessageChk(1,'[예적금명]')
	dw_1.SetColumn("ab_name")
	dw_1.SetFocus()
	Return -1
END IF

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

IF sBnkCd = "" OR IsNull(sBnkCd) THEN
	F_MessageChk(1,'[은행코드]')
	dw_1.SetColumn("bnk_cd")
	dw_1.SetFocus()
	Return -1
END IF

IF sAbNo = "" OR IsNull(sAbNo) THEN
	F_MessageChk(1,'[계좌번호]')
	dw_1.SetColumn("ab_no")
	dw_1.SetFocus()
	Return -1
END IF

IF sAbJGbn = '3' THEN
	IF sAbDate = "" OR IsNull(sAbDate) THEN
		F_MessageChk(1,'[만기일자]')
		dw_1.SetColumn("ab_tst")
		dw_1.SetFocus()
		Return -1
	END IF
END IF

IF sAbCurr = "" OR IsNull(sAbCurr) THEN
	F_MessageChk(1,'[통화단위]')
	dw_1.SetColumn("ab_curr")
	dw_1.SetFocus()
	Return -1
END IF

//IF dRate = 0 OR IsNull(dRate) THEN
//	F_MessageChk(1,'[이율]')
//	dw_1.SetColumn("ab_rat")
//	dw_1.SetFocus()
//	Return -1
//END IF

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	Return -1
END IF

Return 1
end function

event open;call super::open;
dw_gbn.SetTransObject(SQLCA)
dw_gbn.Reset()
dw_gbn.InsertRow(0)

dw_gbn.SetFocus()

dw_1.SetTransObject(SQLCA)

dw_1.ShareData(dw_list)	

sModStatus = 'I'
wf_init()
end event

on w_kfia01.create
int iCurrent
call super::create
this.dw_gbn=create dw_gbn
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_gbn
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.rr_1
end on

on w_kfia01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_gbn)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
end on

type dw_insert from w_inherite`dw_insert within w_kfia01
boolean visible = false
integer x = 50
integer y = 2648
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia01
boolean visible = false
integer x = 3753
integer y = 2976
end type

type p_addrow from w_inherite`p_addrow within w_kfia01
boolean visible = false
integer y = 2976
end type

type p_search from w_inherite`p_search within w_kfia01
boolean visible = false
integer x = 3177
integer y = 3004
end type

type p_ins from w_inherite`p_ins within w_kfia01
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue
String   sJGbn

IF dw_gbn.GetRow() <=0 THEN Return

dw_gbn.AcceptText()
sJGbn =dw_gbn.GetItemString(dw_gbn.GetRow(),"ab_jgbn")

IF sJGbn = "" OR IsNull(sJGbn) THEN
	F_MessageChk(1,'[예금종류]')
	dw_gbn.SetColumn("ab_jgbn")
	dw_gbn.SetFocus()
	Return 1
END IF

IF dw_1.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_1.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_1.InsertRow(0)

	dw_1.ScrollToRow(iCurRow)
		
	dw_1.SetColumn("ab_dpno")
	dw_1.SetFocus()
	
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(iCurRow,True)
	
	dw_list.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"ab_jgbn",sJGbn)
	dw_1.SetItem(iCurRow,"saupj",  gs_saupj)
	dw_1.Setitem(iCurRow,"use_tag",'0')
	dw_1.SetItem(iCurRow,"ab_fst",String(today(),"yyyymmdd"))
	
	sJGbn =dw_gbn.GetItemString(dw_gbn.GetRow(),"ab_jgbn")

	IF sJGbn = "" OR IsNull(sJGbn) THEN
		F_MessageChk(1,'[예금종류]')
		dw_gbn.SetColumn("ab_jgbn")
		dw_gbn.SetFocus()
		Return 1
	END IF
	sModStatus = 'I'
	Lb_AutoFlag = False
END IF

p_ins.Enabled = False
p_ins.PictureName = "C:\erpman\image\추가_d.gif"

end event

type p_exit from w_inherite`p_exit within w_kfia01
end type

type p_can from w_inherite`p_can within w_kfia01
end type

event p_can::clicked;call super::clicked;p_inq.TriggerEvent(Clicked!)

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_kfia01
boolean visible = false
integer x = 3369
integer y = 2984
end type

type p_inq from w_inherite`p_inq within w_kfia01
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sab_dpno

w_mdi_frame.sle_msg.text =""

IF dw_gbn.RowCount() <=0 THEN Return

dw_gbn.AcceptText()
sab_dpno =dw_gbn.GetItemString(dw_gbn.GetRow(),"ab_jgbn")

IF sAb_DpNo = "" OR IsNull(sAb_DpNo) THEN
	F_MessageChk(1,'[예금종류]')
	dw_gbn.SetColumn("ab_jgbn")
	dw_gbn.SetFocus()
	Return 1
END IF

IF dw_1.Retrieve(sab_dpno) > 0 THEN
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(1,True)
	
	dw_list.ScrollToRow(1)
		
	smodstatus="M"
	wf_setting_retrievemode(smodstatus)
	
	p_ins.Enabled = True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
else 
	p_ins.TriggerEvent(Clicked!)
END IF




end event

type p_del from w_inherite`p_del within w_kfia01
end type

event p_del::clicked;call super::clicked;String sab_dpno
Int lsql_cnt

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()

if dw_1.GetRow() <=0 then Return

sab_dpno =dw_1.GetItemString(dw_1.Getrow(),"ab_dpno")

IF f_dbconfirm("삭제") = 2 THEN RETURN

SELECT Count("KFZ12OT0"."SAUP_NO")  
	INTO :lsql_cnt  
   FROM "KFZ12OT0" 
   WHERE "KFZ12OT0"."SAUP_NO" = :sab_dpno   ;
IF SQLCA.SQLCODE  = 0 AND lsql_cnt <> 0 THEN
	w_mdi_frame.sle_msg.text ="이 코드로 발행된 전표가 존재합니다.!!"
	MessageBox("확 인","삭제할 수 없는 자료입니다.!!")
	Return
END IF
dw_list.DeleteRow(0)

IF dw_1.Update() = 1 THEN
	IF f_mult_custom(sab_dpno,'','5','','','','','99') = -1 THEN
		Messagebox("확 인","경리거래처 갱신 실패!!")
		ROLLBACK;
		Return
	ELSE
		COMMIT;
		p_ins.Enabled = True
   	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
		w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
	END IF
	p_inq.TriggerEvent(Clicked!)
ELSE
	f_messagechk(12,'')
	ROLLBACK;
	Return
END IF
ib_any_typing = False
end event

type p_mod from w_inherite`p_mod within w_kfia01
end type

event p_mod::clicked;
String sab_dpno,ssql,sNewAbNo,sgbn
Long   lMaxAbNo

w_mdi_frame.sle_msg.text =""

IF dw_gbn.AcceptText() = -1 then return 
IF dw_1.AcceptText() = -1 then return 
if dw_1.GetRow() <=0 then Return

sgbn = dw_gbn.GetItemString(dw_gbn.GetRow(),"ab_jgbn")
sab_dpno = dw_1.GetItemString(dw_1.GetRow(),"ab_dpno")

IF dw_1.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_1.GetRow()) = -1 Then Return

//KFM04OM0() 검색//
IF smodstatus ="M" THEN
ELSE		
	IF Lb_AutoFlag = True THEN
		SELECT MAX(TO_NUMBER(SUBSTR("KFM04OT0"."AB_DPNO",2,2)))
			INTO :lMaxAbNo  
			FROM "KFM04OT0"
			where "KFM04OT0"."AB_JGBN" = :sgbn ;
		IF SQLCA.SQLCODE <> 0 THEN
			lMaxAbNo = 0
		ELSE
			IF IsNull(lMaxAbNo) THEN lMaxAbNo = 0
		END IF
		
		sNewAbNo = sgbn + String( lMaxAbNo + 1,'000')
		
		dw_1.SetItem(dw_1.GetRow(),"ab_dpno",sNewAbNo)
		sab_dpno = sNewAbNo
	END IF

	SELECT "KFM04OT0"."AB_NAME"  
    	INTO :ssql  
    	FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :sab_dpno   ;

	IF SQLCA.SQLCODE = 0 THEN
		f_messagechk(10,"") 
		Return
	END IF
END IF

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	IF wf_kfz04om0_update() = -1 THEN
		Messagebox("확 인","경리거래처 갱신 실패!!")
		ROLLBACK;
		Return
	ELSE
		COMMIT;
//		WF_INIT()
		p_ins.Enabled = True
   	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
		
		w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"	
	END IF
ELSE
	f_messagechk(13,"")
	ROLLBACK;
	RETURN
END IF
ib_any_typing = False







end event

type cb_exit from w_inherite`cb_exit within w_kfia01
integer x = 3186
integer y = 2784
end type

type cb_mod from w_inherite`cb_mod within w_kfia01
event ue_dang_setting pbm_custom01
event ue_jung_setting pbm_custom02
event ue_etc_setting pbm_custom03
integer x = 2213
integer y = 2784
integer width = 293
integer taborder = 50
end type

on cb_mod::ue_dang_setting;call w_inherite`cb_mod::ue_dang_setting;dw_1.SetItem(dw_1.GetRow(),"ab_ovamt",0)

end on

on cb_mod::ue_jung_setting;call w_inherite`cb_mod::ue_jung_setting;dw_1.SetItem(dw_1.GetRow(),"ab_tst","")
dw_1.SetItem(dw_1.GetRow(),"ab_tamt",0)
dw_1.SetItem(dw_1.GetRow(),"ab_mamt",0)
dw_1.SetItem(dw_1.GetRow(),"ab_tnbr",0)
dw_1.SetItem(dw_1.GetRow(),"ab_mnbr",0)
dw_1.SetItem(dw_1.GetRow(),"ab_idat",0)
end on

on cb_mod::ue_etc_setting;call w_inherite`cb_mod::ue_etc_setting;dw_1.SetItem(dw_1.GetRow(),"ab_tst","")
end on

event cb_mod::clicked;call super::clicked;
String sab_dpno,ssql,sNewAbNo
Long   lMaxAbNo

sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

sab_dpno = dw_1.GetItemString(dw_1.GetRow(),"ab_dpno")

IF dw_1.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_1.GetRow()) = -1 Then Return

//KFM04OM0() 검색//
IF smodstatus ="M" THEN
ELSE		
	IF Lb_AutoFlag = True THEN
		SELECT MAX(TO_NUMBER("KFM04OT0"."AB_DPNO"))
			INTO :lMaxAbNo  
			FROM "KFM04OT0"  ;
		IF SQLCA.SQLCODE <> 0 THEN
			lMaxAbNo = 0
		ELSE
			IF IsNull(lMaxAbNo) THEN lMaxAbNo = 0
		END IF
		
		sNewAbNo = String(lMaxAbNo + 1,'000000')
		
		dw_1.SetItem(dw_1.GetRow(),"ab_dpno",sNewAbNo)
		sab_dpno = sNewAbNo
	END IF

	SELECT "KFM04OT0"."AB_NAME"  
    	INTO :ssql  
    	FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :sab_dpno   ;

	IF SQLCA.SQLCODE =0 THEN
		f_messagechk(10,"") 
		Return
	END IF
END IF

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	IF wf_kfz04om0_update() = -1 THEN
		Messagebox("확 인","경리거래처 갱신 실패!!")
		ROLLBACK;
		Return
	ELSE
		COMMIT;
//		WF_INIT()
		cb_ins.Enabled = True
		sle_msg.text ="자료가 저장되었습니다.!!!"	
	END IF
ELSE
	f_messagechk(13,"")
	ROLLBACK;
	RETURN
END IF
ib_any_typing = False







end event

type cb_ins from w_inherite`cb_ins within w_kfia01
event uevent_jung pbm_custom01
event uevent_dang pbm_custom02
event uevent_etc pbm_custom03
integer x = 434
integer y = 2784
integer width = 293
integer taborder = 40
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue
String   sJGbn

IF dw_gbn.GetRow() <=0 THEN Return

dw_gbn.AcceptText()
sJGbn =dw_gbn.GetItemString(dw_gbn.GetRow(),"ab_jgbn")

IF sJGbn = "" OR IsNull(sJGbn) THEN
	F_MessageChk(1,'[예금종류]')
	dw_gbn.SetColumn("ab_jgbn")
	dw_gbn.SetFocus()
	Return 1
END IF

IF dw_1.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_1.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_1.InsertRow(0)

	dw_1.ScrollToRow(iCurRow)
		
	dw_1.SetColumn("ab_dpno")
	dw_1.SetFocus()
	
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(iCurRow,True)
	
	dw_list.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"ab_jgbn",sJGbn)
	dw_1.SetItem(iCurRow,"saupj",  gs_saupj)
	dw_1.Setitem(iCurRow,"use_tag",'0')
	
	cb_ins.Enabled = False
	sModStatus = 'I'
	
	Lb_AutoFlag = False
END IF


end event

type cb_del from w_inherite`cb_del within w_kfia01
integer x = 2537
integer y = 2784
integer width = 293
integer taborder = 60
end type

event cb_del::clicked;call super::clicked;String sab_dpno
Int lsql_cnt

sle_msg.text =""

dw_1.AcceptText()

sab_dpno =dw_1.GetItemString(dw_1.Getrow(),"ab_dpno")

IF f_dbconfirm("삭제") = 2 THEN RETURN

SELECT Count("KFZ12OT0"."SAUP_NO")  
	INTO :lsql_cnt  
   FROM "KFZ12OT0"  
   WHERE "KFZ12OT0"."SAUP_NO" = :sab_dpno   ;
IF SQLCA.SQLCODE  = 0 AND lsql_cnt <> 0 THEN
	sle_msg.text ="이 코드로 발행된 전표가 존재합니다.!!"
	MessageBox("확 인","삭제할 수 없는 자료입니다.!!")
	Return
END IF
dw_1.DeleteRow(0)

IF dw_1.Update() = 1 THEN
//	IF f_mult_custom(sab_dpno,'','5','','','','','99') = -1 THEN
//		Messagebox("확 인","경리거래처 갱신 실패!!")
//		ROLLBACK;
//		Return
//	ELSE
		COMMIT;
		cb_ins.Enabled = True
		sle_msg.text ="자료가 삭제되었습니다.!!!"	
//	END IF
ELSE
	f_messagechk(12,'')
	ROLLBACK;
	Return
END IF
ib_any_typing = False
end event

type cb_inq from w_inherite`cb_inq within w_kfia01
integer x = 114
integer y = 2784
integer width = 293
integer taborder = 80
end type

event cb_inq::clicked;call super::clicked;String sab_dpno

sle_msg.text =""

IF dw_gbn.RowCount() <=0 THEN Return

dw_gbn.AcceptText()
sab_dpno =dw_gbn.GetItemString(dw_gbn.GetRow(),"ab_jgbn")

IF sAb_DpNo = "" OR IsNull(sAb_DpNo) THEN
	F_MessageChk(1,'[예금종류]')
	dw_gbn.SetColumn("ab_jgbn")
	dw_gbn.SetFocus()
	Return 1
END IF

IF dw_1.Retrieve(sab_dpno) > 0 THEN
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(1,True)
	
	dw_list.ScrollToRow(1)
		
	smodstatus="M"
	wf_setting_retrievemode(smodstatus)
END IF

cb_ins.Enabled = True


end event

type cb_print from w_inherite`cb_print within w_kfia01
integer x = 1221
integer y = 2912
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kfia01
integer width = 288
end type

type cb_can from w_inherite`cb_can within w_kfia01
integer x = 2862
integer y = 2784
integer width = 293
end type

event cb_can::clicked;call super::clicked;cb_inq.TriggerEvent(Clicked!)
end event

type cb_search from w_inherite`cb_search within w_kfia01
integer x = 1623
integer y = 2900
integer width = 425
end type

event cb_search::clicked;call super::clicked;Open(w_kfia01a)
IF smodstatus ="M" THEN
	cb_ins.Enabled =False
ELSE
	cb_ins.Enabled =True
END IF

end event

type dw_datetime from w_inherite`dw_datetime within w_kfia01
integer x = 2857
integer width = 745
end type

type sle_msg from w_inherite`sle_msg within w_kfia01
integer x = 325
integer width = 2533
end type

type gb_10 from w_inherite`gb_10 within w_kfia01
integer width = 3602
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia01
integer x = 73
integer y = 2728
integer width = 695
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia01
integer x = 2167
integer y = 2728
integer width = 1390
end type

type dw_gbn from datawindow within w_kfia01
integer x = 73
integer y = 20
integer width = 1275
integer height = 160
integer taborder = 10
string dataobject = "d_kfia011"
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String sAbGbn,snull

SetNull(sNull)

IF this.GetColumnName() = "ab_jgbn" THEN
	sAbGbn = this.GetText()
	IF sAbGbn = "" OR IsNull(sAbGbn) THEN Return
	
	IF Integer(sAbGbn) < 1 OR Integer(sAbGbn) > 9 THEN
		F_MessageChk(20,'[예금종류]')
		this.SetItem(1,"ab_jgbn",snull)
		Return 1
	END IF
	
	IF dw_1.Retrieve(sAbGbn) > 0 THEN
		dw_list.SelectRow(0,False)
		dw_list.SelectRow(1,True)
	
		dw_list.ScrollToRow(1)
		
		smodstatus="M"
		wf_setting_retrievemode(smodstatus)
		
		dw_1.SetColumn("ab_name")
		dw_1.SetFocus()
		
		p_ins.Enabled = True
		p_ins.PictureName = "C:\erpman\image\추가_up.gif"
	else
		p_ins.TriggerEvent(Clicked!)
	END IF
END IF

end event

type dw_1 from u_key_enter within w_kfia01
event ue_key pbm_dwnkey
integer x = 1915
integer y = 284
integer width = 2542
integer height = 1920
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_kfia013"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,ssano,sacc,sdate,sCurr,sColValue
Date    datef,datet
Double  ldb_calc,dYamt
Integer iWeight

SetNull(snull)

IF this.GetColumnName() = 'auto_flag' THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	IF sColValue ='Y' THEN
		Lb_AutoFlag = True	
	ELSe
		Lb_AutoFlag = False
	END IF
END IF

IF this.GetColumnName() ="acc1_cd" THEN
	scolvalue = data
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
	
	if scolvalue = '' or isnull(scolvalue) then
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",snull)
		return 
	end if
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM"
   	INTO :ssql 
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :sacc )   ;
	IF SQLCA.SQLCODE <> 0 THEN 
//		f_messagechk(20,"계정과목") 
		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",snull)
		dw_1.SetColumn("acc1_cd")
		dw_1.SetFocus()
		Return 
	ELSE
		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",ssql)
	END IF
END IF

IF this.GetColumnName() ="acc2_cd" THEN
	scolvalue = data
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
	
	if scolvalue = '' or isnull(scolvalue) then
		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",snull)
		return 
	end if
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM"
   	INTO :ssql
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :scolvalue) AND
				( "KFZ01OM0"."GBN1" = '5');
	IF SQLCA.SQLCODE <> 0 THEN 
//		f_messagechk(20,"계정과목")
		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",snull)
		dw_1.SetColumn("acc1_cd")
		dw_1.SetFocus()
		Return 
	ELSE
		dw_1.SetItem(dw_1.GetRow(),"acc2_nm",ssql)
	END IF
END IF
//지급은행//
IF this.GetColumnName() ="bnk_cd" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :ssql  
    	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  
         	( "KFZ04OM0"."PERSON_GU" = '2' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"지급은행")
		dw_1.SetItem(1,"bnk_cd",snull)
		Return 1
	END IF
END IF

//개설일자//
IF this.GetColumnName() ="ab_fst" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"개설일자") 
		dw_1.SetItem(1,"ab_fst",snull)
		Return 1
	ELSE
		sdate = Trim(dw_1.GetItemString(dw_1.GetRow(),"ab_tst"))
		IF sdate = "" OR IsNull(sdate) THEN 
		ELSE		
			datef =Date(Left(scolvalue,4)+"/"+Mid(scolvalue,5,2)+"/"+Right(scolvalue,2))
			datet =Date(Left(sdate,4)+"/"+Mid(sdate,5,2)+"/"+Right(sdate,2))
			
			IF DaysAfter(datef,datet) <= 0 THEN
				MessageBox("확 인","날짜범위를 확인하세요.!!")
				dw_1.SetItem(1,"ab_fst",snull)
				Return 1
			END IF
		END IF
	END IF
END IF

//만기일자//
IF this.GetColumnName() ="ab_tst" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"만기일자") 
		dw_1.SetItem(1,"ab_tst",snull)
		Return 1
	ELSE
		sdate = Trim(dw_1.GetItemString(dw_1.GetRow(),"ab_fst"))
		IF sdate = "" OR IsNull(sdate) THEN 
		ELSE
			datef =Date(Left(sdate,4)+"/"+Mid(sdate,5,2)+"/"+Right(sdate,2))
			datet =Date(Left(scolvalue,4)+"/"+Mid(scolvalue,5,2)+"/"+Right(scolvalue,2))
			
			IF DaysAfter(datef,datet) <= 0 THEN
				MessageBox("확 인","날짜범위를 확인하세요.!!")
				dw_1.SetItem(1,"ab_tst",snull)
				Return 1
			END IF
		END IF
	END IF
END IF

//IF this.GetColumnName() ="ab_mamt" THEN
//	IF Double(scolvalue) = 0 THEN 
//		sle_msg.text ="월불입금액이 '0'입니다.!!"
//		MessageBox("확 인","월불입금액을 확인하세요.!!")
//		dw_1.SetItem(1,"ab_mamt",snull)
//		Return -1
//	END IF
//END IF

IF this.GetColumnName() ="ab_curr" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	SELECT "REFFPF"."RFNA1"  
   	INTO :ssql  
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = '10' ) AND  
         	( "REFFPF"."RFGUB" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","사용가능한 통화구분이 아닙니다.!!")
		dw_1.SetItem(1,"ab_curr",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="ab_ytamt" THEN
	sColValue = this.GetText()
	IF IsNull(scolvalue) OR Double(scolvalue) =0 THEN RETURN 
	
	ldb_calc =dw_1.GetItemNumber(dw_1.GetRow(),"ab_excrat")
	IF IsNull(ldb_calc) OR ldb_calc =0 THEN RETURN 
	
	sCurr = dw_1.GetItemString(dw_1.GetRow(),"ab_curr")
	IF sCurr = "" OR IsNull(sCurr) THEN Return 
	
	select nvl(to_number(rfna2),1) into :iWeight
		from reffpf
		where rfcod = '10' and rfgub = :sCurr;
		
	dw_1.SetItem(dw_1.GetRow(),"ab_tamt", Round((Double(scolvalue) * ldb_calc) / iWeight,0))
END IF

IF this.GetColumnName() ="ab_excrat" THEN
	sColValue = this.GetText()
	IF IsNull(scolvalue) OR Double(scolvalue) =0 THEN RETURN 
	
	ldb_calc =dw_1.GetItemNumber(dw_1.GetRow(),"ab_ytamt")
	IF IsNull(ldb_calc) OR ldb_calc =0 THEN RETURN 

	sCurr = dw_1.GetItemString(dw_1.GetRow(),"ab_curr")
	IF sCurr = "" OR IsNull(sCurr) THEN Return 
	
	select nvl(to_number(rfna2),1) into :iWeight
		from reffpf
		where rfcod = '10' and rfgub = :sCurr;

	dw_1.SetItem(dw_1.GetRow(),"ab_tamt", Round((Double(scolvalue) * ldb_calc) / iWeight,0))
END IF

IF this.GetColumnName() = 'ab_curr' THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	dYamt =dw_1.GetItemNumber(dw_1.GetRow(),"ab_ytamt")
	IF IsNull(dYamt) OR dYamt =0 THEN RETURN 
	
	ldb_calc =dw_1.GetItemNumber(dw_1.GetRow(),"ab_excrat")
	IF IsNull(ldb_calc) OR ldb_calc =0 THEN RETURN 
	
	select nvl(to_number(rfna2),1) into :iWeight
		from reffpf
		where rfcod = '10' and rfgub = :sColValue;

	dw_1.SetItem(dw_1.GetRow(),"ab_tamt", Round((dYAmt * ldb_calc) / iWeight,0))	
END IF
//IF this.GetColumnName() ="ab_rat" THEN
//	IF Double(scolvalue) = 0 THEN 
//		MessageBox("확 인","이율을 확인하세요.!!")
//		dw_1.SetItem(1,"ab_rat",snull)
//		Return -1
//	END IF
//END IF

IF this.GetColumnName() ="ab_cdate" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"해지일자") 
		dw_1.SetItem(1,"ab_cdate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="ab_dambobank" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :ssql  
    	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  
         	( "KFZ04OM0"."PERSON_GU" = '2' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"담보제공기관")
		dw_1.SetItem(1,"ab_dambobank",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="ab_dambodate" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"담보제공일") 
		dw_1.SetItem(1,"ab_dambodate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="ab_dambocanceldate" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	IF f_datechk(Trim(scolvalue)) = -1 THEN 
		f_messagechk(20,"담보해지일") 
		dw_1.SetItem(1,"ab_dambocanceldate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="alc_gu" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then return
	
	IF scolvalue <> "Y" AND scolvalue <> "N" THEN
		f_messagechk(20,"승인구분")
		dw_1.SetItem(1,"alc_gu",snull)
		dw_1.SetColumn("alc_gu")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saupj" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF scolvalue = "99" THEN
		f_messagechk(20,"사업장")
		dw_1.SetItem(1,"saupj",snull)
		dw_1.SetColumn("saupj")
		Return 1
	ELSE
		IF IsNull(F_Get_Refferance('AD',sColValue)) THEN
			f_messagechk(20,"사업장")
			dw_1.SetItem(1,"saupj",snull)
			dw_1.SetColumn("saupj")
			Return 1
		END IF
	END IF
END IF
end event

event rbuttondown;String snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

//IF this.GetColumnName() ="ab_dpno" THEN
//	gs_code =Trim(dw_1.GetItemString(dw_1.GetRow(),"ab_dpno"))
//	IF IsNull(gs_code) THEN
//		gs_code =""
//	END IF
//	OPEN(W_KFM04OT0_POPUP)
//	IF Not IsNull(gs_code) THEN
//		IF dw_1.Retrieve(gs_code) <=0 THEN
//			dw_1.insertrow(0)
//		ELSE
//			sModStatus = 'M'
//			WF_SETTING_RETRIEVEMODE(smodstatus)
//		END IF
//		this.setitem(1, "ab_dpno", gs_code)
//		this.setitem(1, "ab_name", gs_codename)
//	END IF
IF this.GetColumnName() ="acc1_cd"  THEN
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)

	lstr_account.acc1_cd =dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
	lstr_account.acc2_cd =dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	end if
	
	IF IsNull(lstr_account.acc2_cd) then
   	lstr_account.acc2_cd = ""
	end if
	
	OpenWithParm(W_KFZ01OM0_POPUP_GBN,'5')
	
	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	dw_1.SetItem(dw_1.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	dw_1.SetItem(dw_1.GetRow(),"acc2_cd",lstr_account.acc2_cd)

	dw_1.SetItem(dw_1.GetRow(),"acc2_nm",lstr_account.acc2_nm)
	
//	this.setcolumn("acc2_cd")

END IF
end event

event retrieveend;Integer k

IF rowcount <=0 THEN Return

FOR k = 1 TO rowCount
	dw_1.Setitem(k,"auto_flag",'Y')
	dw_1.Setitem(k,"use_tag",  '1')
NEXT
end event

type dw_list from u_d_popup_sort within w_kfia01
integer x = 59
integer y = 208
integer width = 1769
integer height = 2004
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_kfia012"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = styleraised!
end type

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_1.ScrollToRow(row)
	
	Lb_AutoFlag = False
	
	b_flag = False
	
	smodstatus="M"
	wf_setting_retrievemode(smodstatus)
END IF

CALL SUPER ::CLICKED


end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	dw_1.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
	
	dw_1.ScrollToRow(currentrow)
END IF

end event

type rr_1 from roundrectangle within w_kfia01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 200
integer width = 1797
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 46
end type

