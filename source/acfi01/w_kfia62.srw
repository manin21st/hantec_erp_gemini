$PBExportHeader$w_kfia62.srw
$PBExportComments$차입금 등록2
forward
global type w_kfia62 from w_inherite
end type
type dw_list from datawindow within w_kfia62
end type
type gb_5 from groupbox within w_kfia62
end type
type gb_plan from groupbox within w_kfia62
end type
type gb_1 from groupbox within w_kfia62
end type
type dw_1 from u_key_enter within w_kfia62
end type
type rb_1 from radiobutton within w_kfia62
end type
type rb_2 from radiobutton within w_kfia62
end type
type pb_2 from picturebutton within w_kfia62
end type
type pb_3 from picturebutton within w_kfia62
end type
type dw_2 from u_d_popup_sort within w_kfia62
end type
type st_2 from statictext within w_kfia62
end type
type sle_1 from singlelineedit within w_kfia62
end type
type rr_1 from roundrectangle within w_kfia62
end type
type rr_2 from roundrectangle within w_kfia62
end type
type rr_3 from roundrectangle within w_kfia62
end type
type ln_1 from line within w_kfia62
end type
end forward

global type w_kfia62 from w_inherite
string title = "차입금 등록"
dw_list dw_list
gb_5 gb_5
gb_plan gb_plan
gb_1 gb_1
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
pb_2 pb_2
pb_3 pb_3
dw_2 dw_2
st_2 st_2
sle_1 sle_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
ln_1 ln_1
end type
global w_kfia62 w_kfia62

type variables

end variables

forward prototypes
public function integer wf_data_chk (string scolname, string scolvalue)
public function integer wf_kfz04om0_update ()
public subroutine wf_init ()
public subroutine wf_setting_retrievemode (string mode)
public function string wf_chaip_no (string sgisandate)
public function integer wf_chk_unrequired ()
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_data_chk (string scolname, string scolvalue);String ssql,snull,satgb,sacc,sch_chk,sCurr
Int lnull,iWeight

SetNull(snull)
SetNull(lnull)

IF scolname ="acc1_cd" THEN
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC2_NM",   
          "KFZ01OM0"."CH_GU"  
   	INTO :ssql,   
           :sch_chk  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :sacc )   ;
	IF SQLCA.SQLCODE <> 0 THEN 
//		f_messagechk(20,"계정과목")
//		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
//		dw_1.SetColumn("acc1_cd")
//		dw_1.SetFocus()
//		Return -1
	ELSE
		IF sch_chk <> "Y" THEN
//			w_mdi_frame.sle_msg.text ="차입금을 등록할 수 없는 계정입니다.!!"
//			Messagebox("확 인","계정과목을 확인하세요.!!")
			dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"accname",snull)
			dw_1.SetColumn("acc1_cd")
			dw_1.SetFocus()
			Return -1
		ELSE
			dw_1.SetItem(dw_1.GetRow(),"accname",ssql)
		END IF
	END IF
END IF

IF scolname ="acc2_cd" THEN
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC2_NM",   
          "KFZ01OM0"."CH_GU"  
   	INTO :ssql,   
           :sch_chk  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :scolvalue)   ;
	IF SQLCA.SQLCODE <> 0 THEN 
//		f_messagechk(20,"계정과목")
//		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
//		dw_1.SetColumn("acc1_cd")
//		dw_1.SetFocus()
//		Return -1
	ELSE
		IF sch_chk <> "Y" THEN
//			w_mdi_frame.sle_msg.text ="차입금을 등록할 수 없는 계정입니다.!!"
//			Messagebox("확 인","계정과목을 확인하세요.!!")
			dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"accname",snull)
			dw_1.SetColumn("acc1_cd")
			dw_1.SetFocus()
			Return -1
		ELSE
			dw_1.SetItem(dw_1.GetRow(),"accname",ssql)
		END IF
	END IF
END IF

//IF scolname ="lo_bnkcd" THEN
//  SELECT "KFZ04OM0"."PERSON_NM"  
//    INTO :ssql
//    FROM "KFZ04OM0"  
//    WHERE ( "KFZ04OM0"."PERSON_GU" = '2') AND  
//          ( "KFZ04OM0"."PERSON_CD" = :scolvalue )   ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확  인","차입은행이 등록된 은행이 아닙니다.확인하세요.!!!")
//		dw_1.Setitem(1,"lo_bnkcd",snull)
//		Return -1
//	END IF
//END IF

IF scolname ="lo_afdt" THEN
	IF f_datechk(scolvalue) = -1 THEN 
		MessageBox("확  인","차입일자를 확인하세요.!!!")
		dw_1.SetItem(1,"lo_afdt",snull)
		Return -1
	END IF
	dw_1.SetItem(1,"lo_aday",Right(sColValue,2))
END IF

IF scolname ="lo_atdt" THEN
	IF f_datechk(scolvalue) = -1 THEN 
		MessageBox("확  인","만기일자를 확인하세요.!!!")
		dw_1.SetItem(1,"lo_atdt",snull)
		Return -1
	END IF
END IF

IF scolname ="lo_aday" THEN
	IF Integer(scolvalue) > 31 THEN
		MessageBox("확  인","이자지급일을 확인하세요.!!!")
		dw_1.SetItem(1,"lo_aday",snull)
		Return -1
	END IF
END IF

IF scolname ="lo_atgb" THEN
	IF scolvalue <> "Y" AND scolvalue <> "N" THEN
		MessageBox("확  인","자동이체여부를 확인하세요.!!!")
		dw_1.SetItem(1,"lo_atgb",snull)
		Return -1
	END IF
END IF

IF scolname ="lo_atbnkcd" THEN
	IF dw_1.GetItemString(dw_1.GetRow(),"lo_atgb") ="Y" AND &
														(scolvalue ="" OR IsNull(scolvalue)) THEN
		MessageBox("확  인","이체은행을 입력하세요.!!")
		Return -1
	ELSEIF dw_1.GetItemString(dw_1.GetRow(),"lo_atgb") ="N" AND &
														(scolvalue <> "" AND Not IsNull(scolvalue)) THEN
		MessageBox("확  인","자동이체여부가 'N'이며 이체은행을 입력하면 안됩니다.!!")
		dw_1.SetItem(1,"lo_atbnkcd",snull)
		Return -1
	ELSE
		SELECT "KFZ04OM0"."PERSON_NM"  
    		INTO :ssql
    		FROM "KFZ04OM0"  
    		WHERE ( "KFZ04OM0"."PERSON_GU" = '2') AND  
          		( "KFZ04OM0"."PERSON_CD" = :scolvalue )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확  인","이체은행이 등록된 은행이 아닙니다.!!")
			dw_1.SetItem(1,"lo_atbnkcd",snull)
			Return -1
		END IF
	END IF
END IF

IF scolname ="lo_atbnkno" THEN
	IF dw_1.GetItemString(1,"lo_atgb") ="Y"  AND &
														(scolvalue = "" OR IsNull(scolvalue)) THEN
		MessageBox("확  인","이체계좌번호는 입력하세요.!!")
		Return -1
	ELSEIF dw_1.GetItemString(dw_1.GetRow(),"lo_atgb") ="N" AND &
														(scolvalue <> "" AND Not IsNull(scolvalue)) THEN
		MessageBox("확  인","자동이체여부가 'N'이며 이체계좌번호를 입력하면 안됩니다.!!")
		dw_1.SetItem(dw_1.getrow(),"lo_atbnkcd",snull)
		Return -1												
	END IF
END IF

IF scolname ="lo_camt" THEN
	IF Double(scolvalue) =0 THEN
		MessageBox("확  인","차입금액을 입력하세요.!!")
		dw_1.SetItem(dw_1.getrow(),"lo_camt",lnull)
		Return -1
	END IF
END IF

IF scolname ="lo_famt" THEN
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(dw_1.getrow(),"lo_famt",0)
	END IF
END IF

IF scolname ="lo_jamt" THEN
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(dw_1.getrow(),"lo_jamt",0)
	END IF
END IF

IF scolname ="lo_curr" THEN
	SELECT "REFFPF"."RFNA1"  
   	INTO :ssql  
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = '10' ) AND  
         	( "REFFPF"."RFGUB" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","사용가능한 통화구분이 아닙니다.!!")
		dw_1.SetItem(dw_1.getrow(),"lo_curr",snull)
		Return -1
	END IF
END IF

IF scolname ="lo_ycamt" THEN
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(dw_1.getrow(),"lo_ycamt",0)
	ELSE
		sCurr = dw_1.GetItemString(dw_1.getrow(),"lo_curr")
		IF sCurr = "" OR IsNull(sCurr) OR sCurr = 'WON'THEN 
			iWeight = 1
		else
			select nvl(to_number(rfna2),1) into :iWeight
				from reffpf
				where rfcod = '10' and rfgub = :sCurr;
		END IF
			
		IF Double(dw_1.GetItemNumber(dw_1.getrow(),"lo_excrat")) <> 0 AND &
								Not IsNull(dw_1.GetItemNumber(dw_1.getrow(),"lo_excrat")) THEN
			dw_1.SetItem(dw_1.getrow(),"lo_camt",TRUNCATE((Double(scolvalue) * dw_1.GetItemNumber(dw_1.getrow(),"lo_excrat")) / iWeight,0)) 
		END IF
	END IF
END IF

IF scolname ="lo_yfamt" THEN
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(dw_1.getrow(),"lo_yfamt",0)
	END IF
END IF

IF scolname ="lo_yjamt" THEN
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(dw_1.getrow(),"lo_yjamt",0)
	END IF
END IF

IF scolname ="lo_excrat" THEN
	IF Double(dw_1.GetItemNumber(dw_1.getrow(),"lo_ycamt")) <> 0 AND &
								Not IsNull(dw_1.GetItemNumber(dw_1.getrow(),"lo_ycamt")) THEN
		sCurr = dw_1.GetItemString(dw_1.getrow(),"lo_curr")
		IF sCurr = "" OR IsNull(sCurr) OR sCurr = 'WON'THEN 
			iWeight = 1
		else
			select nvl(to_number(rfna2),1) into :iWeight
				from reffpf
				where rfcod = '10' and rfgub = :sCurr;
		END IF
		dw_1.SetItem(dw_1.getrow(),"lo_camt",TRUNCATE((Double(scolvalue) * dw_1.GetItemNumber(dw_1.getrow(),"lo_ycamt")) / iWeight,0)) 
	END IF
END IF

IF scolname ="sang_date" THEN
	IF f_datechk(scolvalue) = -1 THEN 
		MessageBox("확  인","최초상환일을 확인하세요.!!!")
		dw_1.SetItem(dw_1.getrow(),"sang_date",snull)
		Return -1
	END IF
END IF

IF scolname ="jigub_date" THEN
	IF f_datechk(scolvalue) = -1 THEN 
		MessageBox("확  인","최초지급일을 확인하세요.!!!")
		dw_1.SetItem(dw_1.getrow(),"jigub_date",snull)
		Return -1
	END IF
END IF

IF scolname ="saupj" THEN
	IF scolvalue = "9" THEN
		f_messagechk(20,"사업장")
		dw_1.SetItem(dw_1.getrow(),"saupj",snull)
		dw_1.SetColumn("saupj")
		Return -1
	END IF
END IF

Return 1
end function

public function integer wf_kfz04om0_update ();String scode,sname,sgu,sno,sbnkcd,sacc1,sacc2

dw_1.AcceptText()

scode  = dw_1.GetItemString(dw_1.GetRow(),"lo_cd")
sacc1  = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sacc2  = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
sname  = dw_1.GetItemString(dw_1.GetRow(),"lo_name")
sbnkcd = dw_1.GetItemString(dw_1.GetRow(),"lo_bnkcd")
sno    = Trim(dw_1.GetItemString(dw_1.GetRow(),"lo_bnkno"))
sgu ='6'

//IF f_mult_custom(scode,sname,sgu,sno,sbnkcd,sacc1,sacc2,'') = -1 THEN RETURN -1
Return 1
end function

public subroutine wf_init ();
String snull
Int lnull

SetNull(snull)
SetNull(lnull)

w_mdi_frame.sle_msg.text =""

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(dw_1.GetRow(),"lo_afdt",f_today())
dw_1.SetItem(dw_1.GetRow(),"saupj",gs_saupj)

IF sModStatus = 'I' THEN								/*등록*/
	dw_1.Modify("lo_cd.protect = 1")
//	dw_1.Modify("lo_cd.background.color ='"+String(RGB(192,192,192))+"'")	
	
	dw_1.SetColumn("lo_name")
	
//	p_del.Enabled = False
//	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
//	p_search.Enabled = False
//	p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
	
//	gb_5.Visible = False
//	pb_2.Visible = False
//	pb_3.Visible = False
ELSE
	dw_1.Modify("lo_cd.protect = 0")
//	dw_1.Modify("lo_cd.background.color =65535")	
	
	dw_1.SetColumn("lo_cd")	
	
//	p_del.Enabled = True
//	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
//	p_search.Enabled = True
//	p_search.PictureName = "C:\Erpman\image\상환계획등록_up.gif"
	
//	gb_5.Visible = True
//	pb_2.Visible = True
//	pb_3.Visible = True
END IF
dw_1.SetRedraw(True)
dw_1.SetFocus()

dw_list.Reset()

ib_any_typing =False
end subroutine

public subroutine wf_setting_retrievemode (string mode);dw_1.SetRedraw(False)
IF mode ="M" THEN
	dw_1.SetTabOrder("lo_cd",0)
	dw_1.SetColumn("lo_name")
	
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
ELSE
	dw_1.SetTabOrder("lo_cd",10)
	dw_1.SetColumn("lo_cd")
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
END IF
dw_1.SetFocus()
dw_1.SetRedraw(True)
end subroutine

public function string wf_chaip_no (string sgisandate);String   sChaipNo
Integer  iMaxNo

SELECT MAX(TO_NUMBER(SUBSTR(A.LOCD,5,3)))
	INTO :iMaxNo  
	FROM(SELECT "KFM03OT0"."LO_CD" AS LOCD
		   FROM "KFM03OT0"  
   		WHERE SUBSTR("KFM03OT0"."LO_AFDT",1,4) = SUBSTR(:sGisanDate,1,4) 
		  UNION ALL
		  SELECT "KFZ12OTE"."LO_CD" AS LOCD
		   FROM "KFZ12OTE"  
   		WHERE SUBSTR("KFZ12OTE"."LO_AFDT",1,4) = SUBSTR(:sGisanDate ,1,4)
		  UNION ALL
		  SELECT "KFZ19OT5"."CHAIP_NO" AS LOCD
		   FROM "KFZ19OT5"  
   		WHERE SUBSTR("KFZ19OT5"."GISAN_DATE",1,4) = SUBSTR(:sGisanDate,1,4) ) A;
			
IF SQLCA.SQLCODE <> 0 THEN
	iMaxNo = 0
ELSE
	IF IsNull(iMaxNo) THEN iMaxNo = 0
END IF

iMaxNo = iMaxNo + 1

sChaipNo = Left(sGisanDate,4) + String(iMaxNo,'000')

Return sChaipNo
end function

public function integer wf_chk_unrequired ();String snull,ssql,slo_atgb,slo_sgbn,slo_atbnkcd,slo_atbnkno,sbal,sman,sSangDate,sPayDate
Double ldb_camt,ldb_famt,ldb_jamt,ldb_ycamt,ldb_yfamt,ldb_yjamt,ll_excrat
Date sdate,edate

SetNull(snull)

dw_1.AcceptText()
sbal        = Trim(dw_1.GetItemString(dw_1.GetRow(),"lo_afdt"))
sman        = Trim(dw_1.GetItemString(dw_1.GetRow(),"lo_atdt"))

slo_atgb    = dw_1.GetItemString(dw_1.GetRow(),"lo_atgb")
slo_atbnkcd = dw_1.GetItemString(dw_1.GetRow(),"lo_atbnkcd")
slo_atbnkno = dw_1.GetItemString(dw_1.GetRow(),"lo_atbnkno")
slo_sgbn    = dw_1.GetItemString(dw_1.GetRow(),"lo_sgbn")

ldb_camt  = dw_1.GetItemNumber(dw_1.GetRow(),"lo_camt")	//원화차입금액
ldb_famt  = dw_1.GetItemNumber(dw_1.GetRow(),"lo_famt")	//원화유동성채무액
ldb_jamt  = dw_1.GetItemNumber(dw_1.GetRow(),"lo_jamt")	//원화상환금액
ldb_ycamt = dw_1.GetItemNumber(dw_1.GetRow(),"lo_ycamt")	//외화차입금액
ldb_yfamt = dw_1.GetItemNumber(dw_1.GetRow(),"lo_yfamt")	//외화유동성채무액
ldb_yjamt = dw_1.GetItemNumber(dw_1.GetRow(),"lo_yjamt")	//외화상환금액

ll_excrat = dw_1.GetItemNumber(dw_1.GetRow(),"lo_excrat")	//기준환율

sSangDate = Trim(dw_1.GetItemString(dw_1.GetRow(),"sang_date"))
sPayDate  = Trim(dw_1.GetItemString(dw_1.GetRow(),"jigub_date"))
IF sSangDate = '' OR IsNull(sSangDate) THEN sSangDate = '99999999'
IF sPayDate = '' OR IsNull(sPayDate) THEN sPayDate = '99999999'

sdate =Date(Left(sbal,4)+"/"+Mid(sbal,5,2)+"/"+Right(sbal,2))
edate =Date(Left(sman,4)+"/"+Mid(sman,5,2)+"/"+Right(sman,2))

IF DaysAfter(sdate,edate) < 0 	THEN
	MessageBox("확  인","차입일자와 만기일자를 확인하세요.!!!")
	dw_1.SetItem(dw_1.getrow(),"lo_atdt",snull)
	dw_1.SetColumn("lo_atdt")
	dw_1.SetFocus()
	Return -1
END IF

IF sbal > sSangDate THEN
	MessageBox("확  인","차입일자와 최초상환일자를 확인하세요.!!!")
	dw_1.SetItem(dw_1.getrow(),"sang_date",snull)
	dw_1.SetColumn("sang_date")
	dw_1.SetFocus()
	Return -1
END IF

IF sbal > sPayDate THEN
	MessageBox("확  인","차입일자와 최초지급일자를 확인하세요.!!!")
	dw_1.SetItem(dw_1.getrow(),"jigub_date",snull)
	dw_1.SetColumn("jigub_date")
	dw_1.SetFocus()
	Return -1
END IF

IF slo_atgb = "Y" THEN
	IF slo_atbnkcd ="" OR IsNull(slo_atbnkcd) THEN							//이체은행
		MessageBox("확  인","이체은행을 입력하세요.!!")
		dw_1.SetColumn("lo_atbnkcd")
		dw_1.SetFocus()
		Return -1
	ELSE
		SELECT "KFZ04OM0"."PERSON_NM"  
    		INTO :ssql
    		FROM "KFZ04OM0"  
    		WHERE ( "KFZ04OM0"."PERSON_GU" = '2') AND  
          		( "KFZ04OM0"."PERSON_CD" = :slo_atbnkcd )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확  인","이체은행이 등록된 은행이 아닙니다.!!")
			dw_1.SetItem(dw_1.getrow(),"lo_atbnkcd",snull)
			dw_1.SetColumn("lo_atbnkcd")
			dw_1.Setfocus()
			Return -1
		END IF
	END IF
		
	IF slo_atbnkno ="" OR IsNull(slo_atbnkno) THEN
		MessageBox("확  인","이체계좌번호는 입력하세요.!!")
		dw_1.SetColumn("lo_atbnkno")
		dw_1.SetFocus()
		Return -1	
	END IF

ELSEIF slo_atgb = "N" THEN
	IF slo_atbnkcd <> "" AND Not IsNull(slo_atbnkcd) THEN
		MessageBox("확  인","자동이체여부가 'N'이며 이체은행을 입력하면 안됩니다.!!")
		dw_1.SetItem(dw_1.getrow(),"lo_atbnkcd",snull)
		dw_1.SetColumn("lo_atbnkcd")
		dw_1.SetFocus()
		Return -1
	END IF
	
	IF slo_atbnkno <> "" AND Not IsNull(slo_atbnkno) THEN
		MessageBox("확  인","자동이체여부가 'N'이며 이체계좌번호를 입력하면 안됩니다.!!")
		dw_1.SetItem(1,"lo_atbnkcd",snull)
		dw_1.SetColumn("lo_atbnkcd")
		dw_1.SetFocus()
		Return -1												
	END IF
END IF

IF ldb_camt < ldb_famt  THEN
	MessageBox("확  인","차입금액보다 유동성채무액이 크면 안됩니다.확인하세요.!!!")
	dw_1.SetColumn("lo_famt")
	dw_1.SetFocus()
	Return -1
END IF

IF ldb_camt < ldb_jamt THEN
	MessageBox("확  인","차입금액이 상환금액보다 작습니다.확인하세요.!!!")
	dw_1.SetColumn("lo_jamt")
	dw_1.SetFocus()
	Return -1
END IF

//IF ldb_camt = ldb_jamt AND slo_sgbn ="1" THEN
//	MessageBox("확  인","차입금액과 상환금액이 같으면 차입상태는 '차입완료'여야합니다.")
//	dw_1.SetColumn("lo_sgbn")
//	dw_1.SetFocus()
//	Return -1
//END IF

IF ldb_ycamt < ldb_yfamt  THEN
	MessageBox("확  인","외화차입금액보다 외화유동성채무액이 크면 안됩니다.확인하세요.!!!")
	dw_1.SetColumn("lo_yfamt")
	dw_1.SetFocus()
	Return -1
END IF

IF ldb_ycamt < ldb_yjamt THEN
	MessageBox("확  인","외화차입금액이 외화상환금액보다 작습니다.확인하세요.!!!")
	dw_1.SetColumn("lo_yjamt")
	dw_1.SetFocus()
	Return -1
END IF

IF IsNull(ll_excrat) OR Double(ll_excrat) =0 THEN
	IF ldb_ycamt <> 0 AND Not IsNull(ldb_ycamt) THEN
		MessageBox("확 인","기준환율을 입력하세요.!!")
		dw_1.SetColumn("lo_excrat")
		dw_1.SetFocus()
		Return -1
	END IF
END IF

// 자동계산처리 비적용함
//IF (Not IsNull(ll_excrat) AND Double(ll_excrat) <> 0) AND &
//										(ldb_ycamt <> 0 AND Not IsNull(ldb_ycamt)) THEN
//	dw_1.SetItem(1,"lo_camt",ldb_ycamt * ll_excrat)	
//END IF
			
Return 1
end function

public function integer wf_requiredchk (integer icurrow);String  sLoName,sBal,sAtGbn,sAtBank,sAtBankNo,sBnkCd,sIjaDay,sLocd,sacc1_cd,sacc2_cd, &
		  sBnkNo,satdt ,slosgbn ,slocurr ,ssaupj ,salcgu,sWcond,sLoGbn
Double  dRate,dLoCamt

dw_1.AcceptText()
sLocd     = dw_1.GetItemString(dw_1.GetRow(),"lo_cd")
sLoName   = dw_1.GetItemString(dw_1.GetRow(),"lo_name")
sacc1_cd  = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sacc2_cd  = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
sBnkCd    = dw_1.GetItemString(dw_1.GetRow(),"lo_bnkcd")
sBnkno	 = dw_1.GetItemString(dw_1.GetRow(),"lo_bnkno")
sbal      = dw_1.GetItemString(dw_1.GetRow(),"lo_afdt")
satdt     = dw_1.GetItemString(dw_1.GetRow(),"lo_atdt")
sIjaDay   = dw_1.GetItemString(dw_1.GetRow(),"lo_aday")
sAtGbn    = dw_1.GetItemString(dw_1.GetRow(),"lo_atgb")
sAtBank   = dw_1.GetItemString(dw_1.GetRow(),"lo_atbnkcd")
sAtBankno = dw_1.GetItemString(dw_1.GetRow(),"lo_atbnkno")
sWcond    = dw_1.GetItemString(dw_1.GetRow(),"kfm03ot0_wcond")

dRate     = dw_1.GetItemNumber(dw_1.GetRow(),"lo_rat")
dLoCamt   = dw_1.GetItemNumber(dw_1.GetRow(),"lo_camt")

slosgbn = dw_1.GetItemString(dw_1.GetRow(),"lo_sgbn")
slocurr = dw_1.GetItemString(dw_1.GetRow(),"lo_curr")
ssaupj  = dw_1.GetItemString(dw_1.GetRow(),"saupj")
salcgu  = dw_1.GetItemString(dw_1.GetRow(),"alc_gu")
sLoGbn  = dw_1.GetItemString(dw_1.GetRow(),"lo_gbn")

IF sModStatus = 'M' THEN
	IF sLocd ="" OR IsNull(sLocd) THEN
		F_MessageChk(1,'[차입금코드]')
		dw_1.SetColumn("lo_cd")
		dw_1.SetFocus()
		Return -1
	END IF
END IF

IF sLoName ="" OR IsNull(sLoName) THEN
	F_MessageChk(1,'[차입금명]')
	dw_1.SetColumn("lo_name")
	dw_1.SetFocus()
	Return -1
END IF

IF sacc1_cd ="" OR IsNull(sacc1_cd) OR sacc2_cd ="" OR IsNull(sacc2_cd)  THEN
	F_MessageChk(1,'[계정과목]')
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return -1
END IF

IF sBnkCd ="" OR IsNull(sBnkCd) THEN
	F_MessageChk(1,'[차입은행]')
	dw_1.SetColumn("lo_bnkcd")
	dw_1.SetFocus()
	Return -1
END IF

IF sBnkNo ="" OR IsNull(sBnkNo) THEN
	F_MessageChk(1,'[차입계좌번호]')
	dw_1.SetColumn("lo_bnkno")
	dw_1.SetFocus()
	Return -1
END IF

IF sLoGbn ="" OR IsNull(sLoGbn) THEN
	F_MessageChk(1,'[차입종류]')
	dw_1.SetColumn("lo_gbn")
	dw_1.SetFocus()
	Return -1
END IF

IF sBal ="" OR IsNull(sBal) THEN
	F_MessageChk(1,'[차입일자]')
	dw_1.SetColumn("lo_afdt")
	dw_1.SetFocus()
	Return -1
END IF

IF satdt ="" OR IsNull(satdt) THEN
	F_MessageChk(1,'[만기일자]')
	dw_1.SetColumn("lo_atdt")
	dw_1.SetFocus()
	Return -1
END IF
IF dRate =0 OR IsNull(dRate) THEN
	F_MessageChk(1,'[이율]')
	dw_1.SetColumn("lo_rat")
	dw_1.SetFocus()
	Return -1
END IF
IF sAtGbn ="" OR IsNull(sAtGbn) THEN
	F_MessageChk(1,'[자동이체여부]')
	dw_1.SetColumn("lo_atgb")
	dw_1.SetFocus()
	Return -1
END IF

IF sAtGbn = "Y" THEN
	IF satbank ="" OR IsNull(satbank) THEN							//이체은행
		F_MessageChk(1,'[이체은행]')
		dw_1.SetColumn("lo_atbnkcd")
		dw_1.SetFocus()
		Return -1
	END IF
		
	IF satbankno ="" OR IsNull(satbankno) THEN
		F_MessageChk(1,'[이체계좌번호]')
		dw_1.SetColumn("lo_atbnkno")
		dw_1.SetFocus()
		Return -1	
	END IF
END IF

IF IsNull(dLoCamt) THEN
	F_MessageChk(1,'[차입금액]')
	dw_1.SetColumn("lo_camt")
	dw_1.SetFocus()
	Return -1
END IF

IF sLosgbn ="" OR IsNull(sLosgbn) THEN
	F_MessageChk(1,'[차입상태]')
	dw_1.SetColumn("lo_sgbn")
	dw_1.SetFocus()
	Return -1
END IF

IF sLocurr ="" OR IsNull(sLocurr) THEN
	F_MessageChk(1,'[통화구분]')
	dw_1.SetColumn("lo_curr")
	dw_1.SetFocus()
	Return -1
END IF

IF sIjaDay ="" OR IsNull(sIjaDay) THEN
	F_MessageChk(1,'[이자지급일]')
	dw_1.SetColumn("lo_aday")
	dw_1.SetFocus()
	Return -1
END IF

if sWcond <> '1000' then							/*분할상환*/
	if IsNull(dw_1.GetItemNumber(dw_1.GetRow(),"guchi")) then
		F_MessageChk(1,'[거치년]')
		dw_1.SetColumn("guchi")
		dw_1.SetFocus()
		Return -1
	end if
	if IsNull(dw_1.GetItemNumber(dw_1.GetRow(),"bunhal")) or dw_1.GetItemNumber(dw_1.GetRow(),"bunhal") = 0 then
		F_MessageChk(1,'[분할년]')
		dw_1.SetColumn("bunhal")
		dw_1.SetFocus()
		Return -1
	end if
	if IsNull(dw_1.GetItemNumber(dw_1.GetRow(),"wjugi")) or dw_1.GetItemNumber(dw_1.GetRow(),"wjugi") = 0 then
		F_MessageChk(1,'[주기(월)]')
		dw_1.SetColumn("wjugi")
		dw_1.SetFocus()
		Return -1
	end if
	if IsNull(dw_1.GetItemString(dw_1.GetRow(),"sang_date")) or dw_1.GetItemString(dw_1.GetRow(),"sang_date") = "" then
		F_MessageChk(1,'[최초상환일자]')
		dw_1.SetColumn("sang_date")
		dw_1.SetFocus()
		Return -1
	end if
end if

IF ssaupj ="" OR IsNull(ssaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	Return -1
END IF

IF salcgu ="" OR IsNull(salcgu) THEN
	F_MessageChk(1,'[승인구분]')
	dw_1.SetColumn("alc_gu")
	dw_1.SetFocus()
	Return -1
END IF
Return 1

end function

event open;call super::open;
dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

dw_2.settransobject(sqlca)

dw_2.sharedata(dw_1)

dw_2.Retrieve()
IF dw_2.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if

wf_setting_retrievemode(smodstatus)

end event

on w_kfia62.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.gb_5=create gb_5
this.gb_plan=create gb_plan
this.gb_1=create gb_1
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.pb_2=create pb_2
this.pb_3=create pb_3
this.dw_2=create dw_2
this.st_2=create st_2
this.sle_1=create sle_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.gb_5
this.Control[iCurrent+3]=this.gb_plan
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.pb_3
this.Control[iCurrent+10]=this.dw_2
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.sle_1
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
this.Control[iCurrent+16]=this.ln_1
end on

on w_kfia62.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.gb_5)
destroy(this.gb_plan)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.ln_1)
end on

event key;GraphicObject which_control
string ls_string,scode, sname
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
          
				 	scode = ls_string + '%'
					
							
				//문자 - 명칭
				Case is >= 127
					scode = '%' + ls_string + '%'
					
				End Choose
			End If	
			
  		  iRow = dw_2.Find("lo_cd like '" + scode +"'",1,dw_2.RowCount())
		  
		  if iRow>0 then
		     
	     else
	        iRow = dw_2.Find("lo_name like '" + scode +"'",1,dw_2.RowCount())
			 if iRow>0 then
		    end if
	     end if			 
		  
		  
        if iRow > 0 then
         	dw_2.ScrollToRow(iRow)
	         dw_2.SelectRow(iRow,True)
		  else 
		      MessageBox('어음번호선택',"선택하신 자료가 없습니다. 다시 선택하신후 작업하세요")  
	     end if	
		   
		 //dw_2.setFocus()
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

type dw_insert from w_inherite`dw_insert within w_kfia62
boolean visible = false
integer x = 87
integer y = 2632
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia62
boolean visible = false
integer x = 4128
integer y = 3024
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia62
boolean visible = false
integer x = 3954
integer y = 3024
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia62
integer x = 3273
integer y = 28
integer width = 306
integer taborder = 0
boolean originalsize = true
string picturename = "C:\Erpman\image\상환계획등록_up.gif"
end type

event p_search::clicked;call super::clicked;
IF dw_1.GetItemString(dw_1.getrow(),"lo_cd") = '' or IsNull(dw_1.GetItemString(dw_1.getrow(),"lo_cd")) THEN Return

OpenSheetWithParm(w_kfia63,dw_1.GetItemString(dw_1.getrow(),"lo_cd"),w_mdi_frame,2,Layered!)
end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\상환계획등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\상환계획등록_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kfia62
integer x = 3749
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;Integer iCurRow

if dw_1.GetRow() <=0 then Return

if Wf_RequiredChk(dw_1.GetRow()) = -1 then Return

dw_1.SetRedraw(False)

iCurRow = dw_1.InsertRow(0)

dw_1.SetItem(iCurRow,"lo_afdt", f_today())
dw_1.SetItem(iCurRow,"saupj",   gs_saupj)
dw_1.ScrollToRow(iCurRow)

dw_1.SetRedraw(True)
dw_1.SetFocus()

dw_2.SelectRow(0,False)
dw_2.SelectRow(iCurRow,True)

dw_2.ScrollToRow(iCurRow)

//p_ins.Enabled = False
//p_ins.PictureName = "C:\erpman\image\추가_d.gif"
sModStatus = 'I'
dw_1.Modify("lo_cd.protect = 1")


end event

type p_exit from w_inherite`p_exit within w_kfia62
integer taborder = 0
end type

type p_can from w_inherite`p_can within w_kfia62
integer taborder = 0
end type

event p_can::clicked;call super::clicked;dw_2.retrieve()

if dw_2.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	dw_2.SelectRow(0,False)
	dw_2.SelectRow(1,True)
	dw_1.ScrollToRow(1)
	smodstatus ="M"
end if

dw_1.SetFocus()

ib_any_typing = False

end event

type p_print from w_inherite`p_print within w_kfia62
boolean visible = false
integer x = 3575
integer y = 3016
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia62
integer x = 3575
integer taborder = 0
end type

event clicked;call super::clicked;Integer iCurRow

dw_2.retrieve()

if dw_2.RowCount() <=0 then
//	p_ins.TriggerEvent(Clicked!)
	dw_1.SetRedraw(False)

	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SetItem(iCurRow,"lo_afdt", f_today())
	dw_1.SetItem(iCurRow,"saupj",   gs_saupj)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetRedraw(True)
	dw_1.SetFocus()
	
	sModStatus = 'I'
	dw_1.Modify("lo_cd.protect = 1")

else
	dw_2.SelectRow(0,False)
	dw_2.SelectRow(1,True)
	dw_1.ScrollToRow(1)
end if

dw_1.SetFocus()

end event

type p_del from w_inherite`p_del within w_kfia62
integer taborder = 0
end type

event p_del::clicked;call super::clicked;String slo_cd
Int lsql_cnt

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()

slo_cd =dw_1.GetItemString(dw_1.getrow(),"lo_cd")

IF f_dbconfirm("삭제") = 2 THEN RETURN

SELECT Count("KFZ12OT0"."SAUP_NO")  
	INTO :lsql_cnt  
   FROM "KFZ12OT0"  
   WHERE "KFZ12OT0"."SAUP_NO" = :slo_cd   ;
IF SQLCA.SQLCODE  = 0 AND lsql_cnt <> 0 THEN
	w_mdi_frame.sle_msg.text ="이 코드로 발행된 전표가 존재합니다.!!"
	MessageBox("확 인","삭제할 수 없는 자료입니다.!!")
	Return
END IF

dw_1.SetRedraw(False)
dw_1.DeleteRow(0)

IF dw_1.Update() = 1 THEN
//	IF f_mult_custom(slo_cd,'','6','','','','','99') = -1 THEN
//		Messagebox("확 인","경리거래처 갱신 실패!!")
//		ROLLBACK;
//	ELSE
		COMMIT;
		
		w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
		ib_any_typing = False
//	END IF
ELSE
	f_messagechk(12,'') 
	ROLLBACK;
	dw_1.SetRedraw(True)
	Return
END IF
	
dw_2.Retrieve()
IF dw_2.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if
dw_1.SetRedraw(True)

wf_setting_retrievemode(smodstatus)

dw_2.SelectRow(0, FALSE)
dw_2.SelectRow(dw_2.GetRow(),TRUE)

end event

type p_mod from w_inherite`p_mod within w_kfia62
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;
String slo_cd,sLoAfDt, schk

w_mdi_frame.sle_msg.text =""

IF dw_1.GetRow() <=0 THEN Return
IF dw_1.AcceptText() = -1 then return 

slo_cd  = dw_1.GetItemString(dw_1.GetRow(),"lo_cd")
sLoAfdt = Trim(dw_1.GetItemString(dw_1.GetRow(),"lo_afdt"))
schk	  = dw_1.getitemstring(dw_1.getrow(), "chk")

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return
IF wf_chk_unrequired() = -1 THEN RETURN					

IF f_dbconfirm("저장") = 2 THEN RETURN

IF schk = 'Y' THEN					/*등록*/
	dw_1.SetItem(dw_1.getrow(),"lo_cd",Wf_ChaIp_No(sLoAfDt))
END IF

IF dw_1.Update() = 1 THEN
	IF wf_kfz04om0_update() = -1 THEN
		ROLLBACK;
		Messagebox("확 인","회계인명 갱신 실패!!")
		p_search.Enabled = False
		p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
	ELSE
		COMMIT;
		w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
		
		dw_1.Modify("lo_cd.protect = 1")
	
		p_search.Enabled = True
		p_search.PictureName = "C:\Erpman\image\상환계획등록_up.gif"
		
		ib_any_typing = False
		
	END IF
ELSE
	ROLLBACK;
	f_messagechk(13,"")
	p_search.Enabled = False
	p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
	RETURN
END IF

dw_2.Retrieve()
IF dw_2.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if

wf_setting_retrievemode(smodstatus)

dw_2.SelectRow(0, FALSE)
dw_2.SelectRow(dw_2.GetRow(),TRUE)





end event

type cb_exit from w_inherite`cb_exit within w_kfia62
boolean visible = false
integer x = 3461
integer y = 2688
integer width = 293
end type

type cb_mod from w_inherite`cb_mod within w_kfia62
boolean visible = false
integer x = 2487
integer y = 2688
integer width = 293
end type

event cb_mod::clicked;call super::clicked;
String slo_cd,sLoAfDt

sle_msg.text =""

IF dw_1.GetRow() <=0 THEN Return
IF dw_1.AcceptText() = -1 then return 

slo_cd  = dw_1.GetItemString(dw_1.GetRow(),"lo_cd")
sLoAfdt = Trim(dw_1.GetItemString(dw_1.GetRow(),"lo_afdt"))

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return
IF wf_chk_unrequired() = -1 THEN RETURN					

IF f_dbconfirm("저장") = 2 THEN RETURN

IF sModStatus = 'I' AND (slo_cd = '' OR IsNull(sLo_Cd)) THEN					/*등록*/
	dw_1.SetItem(1,"lo_cd",Wf_ChaIp_No(sLoAfDt))
END IF

IF dw_1.Update() = 1 THEN
	IF wf_kfz04om0_update() = -1 THEN
		Messagebox("확 인","경리거래처 갱신 실패!!")
		ROLLBACK;
		cb_search.Enabled = False
	ELSE
		COMMIT;
		sle_msg.text ="자료가 저장되었습니다.!!!"
		
		dw_1.Modify("lo_cd.protect = 1")
		dw_1.Modify("lo_cd.background.color ='"+String(RGB(192,192,192))+"'")
	
		cb_search.Enabled = True
		
		ib_any_typing = False
		
	END IF
ELSE
	f_messagechk(13,"")
	ROLLBACK;
	cb_search.Enabled = False
	RETURN
END IF







end event

type cb_ins from w_inherite`cb_ins within w_kfia62
boolean visible = false
integer x = 955
integer y = 2928
integer width = 293
end type

event cb_ins::clicked;call super::clicked;wf_init()
end event

type cb_del from w_inherite`cb_del within w_kfia62
boolean visible = false
integer x = 2811
integer y = 2688
integer width = 293
end type

event cb_del::clicked;call super::clicked;String slo_cd
Int lsql_cnt

sle_msg.text =""

dw_1.AcceptText()

slo_cd =dw_1.GetItemString(1,"lo_cd")

IF f_dbconfirm("삭제") = 2 THEN RETURN

SELECT Count("KFZ12OT0"."SAUP_NO")  
	INTO :lsql_cnt  
   FROM "KFZ12OT0"  
   WHERE "KFZ12OT0"."SAUP_NO" = :slo_cd   ;
IF SQLCA.SQLCODE  = 0 AND lsql_cnt <> 0 THEN
	sle_msg.text ="이 코드로 발행된 전표가 존재합니다.!!"
	MessageBox("확 인","삭제할 수 없는 자료입니다.!!")
	Return
END IF

dw_1.SetRedraw(False)
dw_1.DeleteRow(0)

IF dw_1.Update() = 1 THEN
//	IF f_mult_custom(slo_cd,'','6','','','','','99') = -1 THEN
//		Messagebox("확 인","경리거래처 갱신 실패!!")
//		ROLLBACK;
//	ELSE
		COMMIT;
		WF_INIT()
		sle_msg.text ="자료가 삭제되었습니다.!!!"	
		ib_any_typing = False
//	END IF
	dw_1.SetRedraw(True)
	
ELSE
	f_messagechk(12,'') 
	ROLLBACK;
	dw_1.SetRedraw(True)
END IF

end event

type cb_inq from w_inherite`cb_inq within w_kfia62
boolean visible = false
integer x = 343
integer y = 2688
integer width = 293
end type

event cb_inq::clicked;call super::clicked;String  ls_locd,sNull
Integer iCount

SetNull(sNull)

sle_msg.text =""

dw_1.AcceptText()
ls_locd =dw_1.GetItemString(dw_1.GetRow(),"lo_cd")
IF ls_locd ="" OR IsNull(ls_locd) THEN
	F_MessageChk(1,'[차입금코드]')
	dw_1.SetColumn("lo_cd")
	dw_1.SetFocus()
	Return -1
END IF

select count(*) into :iCount
	from kfm03ot0
	where lo_cd = :ls_locd;
if sqlca.sqlcode <> 0 OR iCount = 0 OR IsNull(iCount) then
	f_messagechk(14,'') 
	
	dw_1.SetItem(1,"lo_cd",sNull)
	
	dw_1.SetColumn("lo_cd")
	dw_1.SetFocus()
	Return
end if

IF dw_1.Retrieve(ls_locd) > 0 THEN
	dw_list.Retrieve(ls_locd,Left(F_Today(),4))
	
	dw_1.Modify("lo_cd.protect = 1")
	dw_1.Modify("lo_cd.background.color ='"+String(RGB(192,192,192))+"'")
		
	dw_1.SetColumn("lo_name")
	dw_1.SetFocus()
END IF
ib_any_typing = False

end event

type cb_print from w_inherite`cb_print within w_kfia62
boolean visible = false
integer x = 1262
integer y = 2928
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kfia62
boolean visible = false
integer width = 288
end type

type cb_can from w_inherite`cb_can within w_kfia62
boolean visible = false
integer x = 3136
integer y = 2688
integer width = 293
end type

event cb_can::clicked;call super::clicked;wf_init()
end event

type cb_search from w_inherite`cb_search within w_kfia62
boolean visible = false
integer x = 1024
integer y = 2688
integer width = 672
string text = "상환계획 등록(&W)"
end type

event cb_search::clicked;call super::clicked;
IF dw_1.GetItemString(1,"lo_cd") = '' or IsNull(dw_1.GetItemString(1,"lo_cd")) THEN Return

OpenSheetWithParm(w_kfia63,dw_1.GetItemString(1,"lo_cd"),w_mdi_frame,2,Layered!)
end event

type dw_datetime from w_inherite`dw_datetime within w_kfia62
boolean visible = false
integer x = 2848
end type

type sle_msg from w_inherite`sle_msg within w_kfia62
boolean visible = false
integer x = 325
integer width = 2523
end type

type gb_10 from w_inherite`gb_10 within w_kfia62
boolean visible = false
integer width = 3598
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia62
boolean visible = false
integer x = 302
integer y = 2636
integer width = 384
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia62
boolean visible = false
integer x = 2427
integer y = 2636
integer width = 1385
end type

type dw_list from datawindow within w_kfia62
integer x = 1074
integer y = 1640
integer width = 3534
integer height = 568
boolean bringtotop = true
string dataobject = "dw_kfia622"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_5 from groupbox within w_kfia62
boolean visible = false
integer x = 2519
integer y = 4
integer width = 343
integer height = 176
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료선택"
end type

type gb_plan from groupbox within w_kfia62
boolean visible = false
integer x = 992
integer y = 2636
integer width = 736
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_kfia62
boolean visible = false
integer x = 1152
integer width = 608
integer height = 156
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type dw_1 from u_key_enter within w_kfia62
event ue_key pbm_dwnkey
integer x = 1047
integer y = 188
integer width = 3579
integer height = 1412
integer taborder = 5
string dataobject = "dw_kfia621"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String   ssql,snull,satgb,sacc,sch_chk,sCurr,sColValue
Int      lnull,iWeight,iGuchi
Dwitemstatus iStatus

SetNull(snull)
SetNull(lnull)

IF this.GetColumnName() ="chk" THEN
	
	iStatus = This.getitemstatus(row, 0, Primary!)
	
	if data = 'Y' then
		sModStatus = 'I'
		dw_1.Modify("lo_cd.protect = 1")
		dw_1.SetTabOrder("lo_cd",0)
	else
		sModStatus = 'M'
		IF iStatus = New! Or iStatus = Newmodified! THEN
			dw_1.Modify("lo_cd.protect = 0")
			dw_1.SetTabOrder("lo_cd",1)
		END IF
	end if
END IF

IF this.GetColumnName() ="insacc" THEN
	scolvalue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	SELECT "KFZ01OM0"."ACC2_NM",   "KFZ01OM0"."GBN1"  
   	INTO :ssql, 		          :sch_chk  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :scolvalue ) AND
				( "KFZ01OM0"."BAL_GU" <> '4') AND ( "KFZ01OM0"."GBN1" = '6') ;
	IF SQLCA.SQLCODE <> 0 THEN 
		f_messagechk(20,"계정과목")
		dw_1.SetItem(dw_1.GetRow(),"insacc", snull)
		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
		dw_1.SetColumn("insacc")
		dw_1.SetFocus()
		Return 
	ELSE
		dw_1.SetItem(dw_1.GetRow(),"acc1_cd", Left(sColValue,5))
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd", Right(sColValue,2))
	END IF
END IF

//IF this.GetColumnName() ="acc1_cd" THEN
//	scolvalue = data
//	sacc =dw_1.GetItemString(row,"acc2_cd")
//	
//	if scolvalue = '' or isnull(scolvalue) then
//		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
//		return 
//	end if
//	
//	IF sacc ="" OR IsNull(sacc) THEN RETURN 
//	
//	SELECT "KFZ01OM0"."ACC2_NM",   "KFZ01OM0"."GBN1"  
//   	INTO :ssql, 		          :sch_chk  
//    	FROM "KFZ01OM0"  
//   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue ) AND ( "KFZ01OM0"."ACC2_CD" = :sacc ) AND
//				( "KFZ01OM0"."GBN1" = '6') ;
//	IF SQLCA.SQLCODE <> 0 THEN 
////		f_messagechk(20,"계정과목")
//		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
//		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
//		dw_1.SetColumn("acc1_cd")
//		dw_1.SetFocus()
//		Return 
//	ELSE
//		dw_1.SetItem(row,"accname",ssql)
//	END IF
//END IF
//
//IF this.GetColumnName() ="acc2_cd" THEN
//	scolvalue = data
//	sacc =dw_1.GetItemString(row,"acc1_cd")
//	
//	if scolvalue = '' or isnull(scolvalue) then
//		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
//		return 
//	end if
//	
//	IF sacc ="" OR IsNull(sacc) THEN RETURN 
//	
//	SELECT "KFZ01OM0"."ACC2_NM",   "KFZ01OM0"."GBN1"  
//   	INTO :ssql, 		          :sch_chk  
//    	FROM "KFZ01OM0"  
//   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND ( "KFZ01OM0"."ACC2_CD" = :scolvalue) AND
//				( "KFZ01OM0"."GBN1" = '6') ;
//	IF SQLCA.SQLCODE <> 0 THEN 
////		f_messagechk(20,"계정과목")
//		dw_1.SetItem(row,"acc1_cd",snull)
//		dw_1.SetItem(row,"acc2_cd",snull)
//		dw_1.SetItem(row,"accname",snull)
//		dw_1.SetColumn("acc1_cd")
//		dw_1.SetFocus()
//		Return 
//	ELSE
//		dw_1.SetItem(row,"accname",ssql)
//	END IF
//END IF

IF this.GetColumnName() ="lo_afdt" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		MessageBox("확  인","차입일자를 확인하세요.!!!")
		dw_1.SetItem(row,"lo_afdt",snull)
		Return 1
	END IF
	dw_1.SetItem(row,"lo_aday",Right(sColValue,2))
END IF

IF this.GetColumnName() ="lo_atdt" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		MessageBox("확  인","만기일자를 확인하세요.!!!")
		dw_1.SetItem(row,"lo_atdt",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_aday" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF Integer(scolvalue) > 31 THEN
		MessageBox("확  인","이자지급일을 확인하세요.!!!")
		dw_1.SetItem(row,"lo_aday",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_atgb" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF scolvalue <> "Y" AND scolvalue <> "N" THEN
		MessageBox("확  인","자동이체여부를 확인하세요.!!!")
		dw_1.SetItem(row,"lo_atgb",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_atbnkcd" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF dw_1.GetItemString(dw_1.GetRow(),"lo_atgb") ="Y" AND &
														(scolvalue ="" OR IsNull(scolvalue)) THEN
		MessageBox("확  인","이체은행을 입력하세요.!!")
		Return 1
	ELSEIF dw_1.GetItemString(dw_1.GetRow(),"lo_atgb") ="N" AND &
														(scolvalue <> "" AND Not IsNull(scolvalue)) THEN
		MessageBox("확  인","자동이체여부가 'N'이며 이체은행을 입력하면 안됩니다.!!")
		dw_1.SetItem(row,"lo_atbnkcd",snull)
		Return 1
	ELSE
		SELECT "KFZ04OM0"."PERSON_NM"  
    		INTO :ssql
    		FROM "KFZ04OM0"  
    		WHERE ( "KFZ04OM0"."PERSON_GU" = '2') AND  
          		( "KFZ04OM0"."PERSON_CD" = :scolvalue )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확  인","이체은행이 등록된 은행이 아닙니다.!!")
			dw_1.SetItem(row,"lo_atbnkcd",snull)
			Return 1
		END IF
	END IF
END IF

IF this.GetColumnName() ="lo_atbnkno" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF dw_1.GetItemString(row,"lo_atgb") ="Y"  AND &
														(scolvalue = "" OR IsNull(scolvalue)) THEN
		MessageBox("확  인","이체계좌번호는 입력하세요.!!")
		Return 1
	ELSEIF dw_1.GetItemString(dw_1.GetRow(),"lo_atgb") ="N" AND &
														(scolvalue <> "" AND Not IsNull(scolvalue)) THEN
		MessageBox("확  인","자동이체여부가 'N'이며 이체계좌번호를 입력하면 안됩니다.!!")
		dw_1.SetItem(row,"lo_atbnkcd",snull)
		Return 1												
	END IF
END IF

IF this.GetColumnName() ="lo_camt" THEN
	sColValue = this.GetText()
	
	IF Double(scolvalue) =0 THEN
		MessageBox("확  인","차입금액을 입력하세요.!!")
		dw_1.SetItem(row,"lo_camt",lnull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_famt" THEN
	sColValue = this.GetText()
	
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(row,"lo_famt",0)
	END IF
END IF

IF this.GetColumnName() ="lo_jamt" THEN
	sColValue = this.GetText()
	
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(row,"lo_jamt",0)
	END IF
END IF

IF this.GetColumnName() ="lo_curr" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	SELECT "REFFPF"."RFNA1"  
   	INTO :ssql  
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = '10' ) AND  
         	( "REFFPF"."RFGUB" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","사용가능한 통화구분이 아닙니다.!!")
		dw_1.SetItem(row,"lo_curr",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_ycamt" THEN
	sColValue = this.GetText()
	
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(1,"lo_ycamt",0)
	ELSE
		sCurr = dw_1.GetItemString(row,"lo_curr")
		IF sCurr = "" OR IsNull(sCurr) OR sCurr = 'WON'THEN 
			iWeight = 1
		else
			select nvl(to_number(rfna2),1) into :iWeight
				from reffpf
				where rfcod = '10' and rfgub = :sCurr;
		END IF
			
		IF Double(dw_1.GetItemNumber(row,"lo_excrat")) <> 0 AND &
								Not IsNull(dw_1.GetItemNumber(row,"lo_excrat")) THEN
			dw_1.SetItem(row,"lo_camt",TRUNCATE((Double(scolvalue) * dw_1.GetItemNumber(row,"lo_excrat")) / iWeight,0)) 
		END IF
	END IF
END IF

IF this.GetColumnName() ="lo_yfamt" THEN
	sColValue = this.GetText()
	
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(row,"lo_yfamt",0)
	END IF
END IF

IF this.GetColumnName() ="lo_yjamt" THEN
	sColValue = this.GetText()
	
	IF IsNull(scolvalue)	THEN
		dw_1.SetItem(row,"lo_yjamt",0)
	END IF
END IF

IF this.GetColumnName() ="lo_excrat" THEN
	sColValue = this.GetText()
	
	IF Double(dw_1.GetItemNumber(row,"lo_ycamt")) <> 0 AND &
								Not IsNull(dw_1.GetItemNumber(row,"lo_ycamt")) THEN
		sCurr = dw_1.GetItemString(row,"lo_curr")
		IF sCurr = "" OR IsNull(sCurr) OR sCurr = 'WON'THEN 
			iWeight = 1
		else
			select nvl(to_number(rfna2),1) into :iWeight
				from reffpf
				where rfcod = '10' and rfgub = :sCurr;
		END IF
		dw_1.SetItem(row,"lo_camt",TRUNCATE((Double(scolvalue) * dw_1.GetItemNumber(row,"lo_ycamt")) / iWeight,0)) 
	END IF
END IF

IF this.GetColumnName() ="sang_date" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		MessageBox("확  인","최초상환일을 확인하세요.!!!")
		dw_1.SetItem(row,"sang_date",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jigub_date" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		MessageBox("확  인","최초지급일을 확인하세요.!!!")
		dw_1.SetItem(row,"jigub_date",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saupj" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF scolvalue = "99" THEN
		f_messagechk(20,"사업장")
		dw_1.SetItem(row,"saupj",snull)
		dw_1.SetColumn("saupj")
		Return 1
	ELSE
		IF IsNull(F_Get_Refferance('AD',sColValue)) THEN
			f_messagechk(20,"사업장")
			dw_1.SetItem(row,"saupj",snull)
			dw_1.SetColumn("saupj")
			Return 1
		END IF
	END IF

END IF
end event

event itemerror;
Return 1
end event

event rbuttondown;String snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)


this.accepttext()

//IF this.GetColumnName() ="lo_cd" THEN
//	gs_code =Trim(dw_1.GetItemString(dw_1.GetRow(),"lo_cd"))
//	IF IsNull(gs_code) THEN
//		gs_code =""
//	END IF
//	OPEN(W_KFM03OT0_POPUP)
//	IF IsNull(gs_code) OR Gs_Code = '' THEN Return
//	
//	this.Setitem(1,"lo_cd",Gs_Code)
//	p_inq.TriggerEvent(Clicked!)
//END IF

IF this.GetColumnName() ="acc1_cd" THEN
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	SetNull(lstr_account.ch_gu)

	lstr_account.acc1_cd =dw_1.GetItemString(this.getrow(),"acc1_cd")
	lstr_account.acc2_cd =dw_1.GetItemString(this.getrow(),"acc2_cd")

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	end if
	
	IF IsNull(lstr_account.acc2_cd) then
   	lstr_account.acc2_cd = ""
	end if

	OpenWithParm(W_KFZ01OM0_POPUP_GBN,'6')
	
	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	dw_1.SetItem(this.getrow(),"acc1_cd",lstr_account.acc1_cd)
	dw_1.SetItem(this.getrow(),"acc2_cd",lstr_account.acc2_cd)

	dw_1.SetItem(this.getrow(),"accname",lstr_account.acc2_nm)
	
	this.setcolumn("acc2_cd")
END IF

end event

event editchanged;ib_any_typing =True
end event

event itemfocuschanged;call super::itemfocuschanged;
Long wnd

wnd =Handle(this)

IF dwo.name ="lo_name" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type rb_1 from radiobutton within w_kfia62
boolean visible = false
integer x = 1211
integer y = 48
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등록"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;smodstatus = 'I'

Wf_Init()
end event

type rb_2 from radiobutton within w_kfia62
boolean visible = false
integer x = 1463
integer y = 48
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수정"
borderstyle borderstyle = stylelowered!
end type

event clicked;smodstatus = 'M'

Wf_Init()
end event

type pb_2 from picturebutton within w_kfia62
boolean visible = false
integer x = 2555
integer y = 72
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\prior.gif"
alignment htextalign = right!
end type

event clicked;String sLoCd,sNewLoCd

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sLoCd = dw_1.GetItemString(dw_1.GetRow(),"lo_cd")

SELECT MAX("KFM03OT0"."LO_CD") INTO :sNewLoCd
	FROM "KFM03OT0" 
	WHERE "LO_CD" < :sLoCd;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sNewLoCd) OR sNewLoCd = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_1.SetItem(dw_1.GetRow(),"lo_cd", sNewLoCd)
	
	p_inq.TriggerEvent(Clicked!)

END IF
	
end event

type pb_3 from picturebutton within w_kfia62
boolean visible = false
integer x = 2702
integer y = 72
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\next.gif"
alignment htextalign = right!
end type

event clicked;String sLoCd,sNewLoCd

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sLoCd = dw_1.GetItemString(dw_1.GetRow(),"lo_cd")

SELECT MIN("KFM03OT0"."LO_CD") INTO :sNewLoCd
	FROM "KFM03OT0" 
	WHERE "LO_CD" > :sLoCd;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sNewLoCd) OR sNewLoCd = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_1.SetItem(dw_1.GetRow(),"lo_cd", sNewLoCd)
	
	p_inq.TriggerEvent(clicked!)

END IF
	
end event

type dw_2 from u_d_popup_sort within w_kfia62
integer x = 32
integer y = 208
integer width = 1001
integer height = 1996
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_kfia623"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_1.ScrollToRow(row)
	
	b_flag = False
	
	if dw_1.getitemstring(row, "lo_cd") = '' or IsNull(dw_1.getitemstring(row, "lo_cd")) then
		dw_list.Reset()
	else
		dw_list.Retrieve(dw_1.getitemstring(row, "lo_cd"),Left(F_Today(),4))
	end if
	
	dw_1.SetTabOrder("lo_cd",0)
	
//	smodstatus="M"
//	wf_setting_retrievemode(smodstatus)
END IF

CALL SUPER ::CLICKED


end event

event rowfocuschanged;call super::rowfocuschanged;//If currentrow <= 0 then
//	dw_1.SelectRow(0,False)
//
//ELSE
//
//	SelectRow(0, FALSE)
//	SelectRow(currentrow,TRUE)
//	
//	dw_1.ScrollToRow(currentrow)
//
//	if dw_1.getitemstring(currentrow, "lo_cd") = '' or IsNull(dw_1.getitemstring(currentrow, "lo_cd")) then
//		dw_list.Reset()
//	else
//		dw_list.Retrieve(dw_1.getitemstring(currentrow, "lo_cd"),Left(F_Today(),4))
//	end if
//END IF
//
end event

type st_2 from statictext within w_kfia62
integer x = 73
integer y = 84
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
string text = "차입금조회"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfia62
integer x = 379
integer y = 76
integer width = 567
integer height = 64
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

type rr_1 from roundrectangle within w_kfia62
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1070
integer y = 1636
integer width = 3547
integer height = 580
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kfia62
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 200
integer width = 1024
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_kfia62
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 36
integer width = 987
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kfia62
integer linethickness = 1
integer beginx = 384
integer beginy = 148
integer endx = 946
integer endy = 148
end type

