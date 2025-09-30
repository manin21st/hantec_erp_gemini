$PBExportHeader$w_kgle03.srw
$PBExportComments$결산관리 : 결산처리(new)
forward
global type w_kgle03 from w_inherite
end type
type cb_6 from commandbutton within w_kgle03
end type
type st_2 from statictext within w_kgle03
end type
type mle_1 from multilineedit within w_kgle03
end type
type gb_1 from groupbox within w_kgle03
end type
type dw_ip from u_key_enter within w_kgle03
end type
end forward

global type w_kgle03 from w_inherite
string title = "재무제표 자료 작성"
cb_6 cb_6
st_2 st_2
mle_1 mle_1
gb_1 gb_1
dw_ip dw_ip
end type
global w_kgle03 w_kgle03

type variables
//String  ls_dc_gu
//String  ls_fin_gu,ls_amt_gu,ls_name,ls_amt_posi,ls_chagam_gu
Long      ld_ses,lj_ses
String     sd_frymd,sd_toymd,sj_frymd,sj_toymd
Double   LdChaGam_bef,LdChaGam_dang
String     LsCurrSaupj,LsFsGbn

end variables

forward prototypes
public function integer wf_read_kfz02om0 ()
public function integer wf_get_amount (string ls_acc1, string ls_acc2, string ls_amt_gu, string ls_dc_gu, ref double dbyear_amount, ref double ddyear_amount)
public function integer wf_get_calc9 (long lfs_seq, ref double dbyear_amount, ref double ddyear_amount)
public function integer wf_insert_kfz02wk (long lfsseq, string skname, string sename, string scname, string ls_amt_gu, string ls_amt_posi, string ls_chagam_gu, ref double dbyear_amount, ref double ddyear_amount)
end prototypes

public function integer wf_read_kfz02om0 ();DataStore Idw_Source
Integer   il_Count,k
String    sKName,sEName,sCName,sAcc1,sAcc2,sAmtGbn,sChaGamGbn,sDcGbn,sAmtPosi
Long      lFsSeq
Double    dAmountBef,dAmountDang

Idw_Source = Create DataStore

Idw_Source.DataObject = 'dw_kgle03_2'
Idw_Source.SetTransObject(Sqlca)
Idw_Source.Reset()

sle_msg.text ="재무제표 작성 중...."
SetPointer(HourGlass!)

il_Count = Idw_Source.Retrieve(LsFsGbn)
IF il_Count <=0 THEN Return 1

FOR k = 1 TO il_Count
	lFsSeq     = Idw_Source.GetItemNumber(k,"fs_seq")
	sKName     = Idw_Source.GetItemString(k,"kname")
	sEName     = Idw_Source.GetItemString(k,"ename")
	sCName     = Idw_Source.GetItemString(k,"cname")
	sAcc1      = Idw_Source.GetItemString(k,"acc1_cd")
	sAcc2      = Idw_Source.GetItemString(k,"acc2_cd")
	sAmtGbn    = Idw_Source.GetItemString(k,"amt_gu")
	sChaGamGbn = Idw_Source.GetItemString(k,"chagam_gu")
	sAmtPosi   = Idw_Source.GetItemString(k,"amt_posi")
	sDcGbn     = Idw_Source.GetItemString(k,"dc_gu")
	
	sle_msg.text = F_Get_Refferance('AD',LsCurrSaupj) + '의 '+ '['+F_Get_Refferance('FS',LsFsGbn) +'-'+sKName +'] 처리 중...'
		
	dAmountBef = 0;	dAmountDang =0;
		
	IF sAmtGbn ="9" THEN											//금액구분 ='9'(계산)
		IF wf_get_calc9(lFsSeq,dAmountBef,dAmountDang) = -1 THEN 
			ROLLBACK;
			Return -1
		END IF
	ELSE
		IF wf_get_amount(sAcc1,sAcc2,sAmtGbn,sDcGbn,dAmountBef,dAmountDang) = -1 THEN
			ROLLBACK;
			Return -1
		END IF
	END IF
	
	IF wf_insert_kfz02wk(lFsSeq,sKName,sEName,sCName,sAmtGbn,sAmtPosi,sChaGamGbn,dAmountBef,dAmountDang) = -1 THEN
		Return -1
	END IF
NEXT
sle_msg.text ="재무제표 작성 중 완료!!"
SetPointer(Arrow!)

Return 1
end function

public function integer wf_get_amount (string ls_acc1, string ls_acc2, string ls_amt_gu, string ls_dc_gu, ref double dbyear_amount, ref double ddyear_amount);//***************************************************************************************//
//*** 금액 구하기
// 1. 금액 구분에 따라서 금액을 가져온다.(KFZ02OT2)
//    1-1. 금액구분이 '0' 이면 전기누계 =0, 당기누계 =0
//    1-2. 금액구분이 '1' 이면 전기이월잔액을 가져온다(='KFZ14OM0의 '00'월)
//    1-3.            '2' 이면 차변금액을 가져온다
//    1-4.            '3' 이면 대변금액을 가져온다
//    1-5.            '4' 이면 잔액을 가져온다
//**************************************************************************************//
Double dbyear_cha,dbyear_dai,ddyear_cha,ddyear_dai

IF ls_amt_gu ='1' THEN																//이월
	SELECT SUM("KFZ02OT2"."PRV_JUN_DR_AMT"),   								//전기누계
			 SUM("KFZ02OT2"."PRV_JUN_CR_AMT")  
		INTO :dbyear_cha,   :dbyear_dai  
		FROM "KFZ02OT2"  
		WHERE "SAUPJ" = :LsCurrSaupj AND "ACC1_CD" = :ls_acc1 AND "ACC2_CD" = :ls_acc2 ;

	IF IsNull(dbyear_cha) THEN dbyear_cha =0
	IF IsNull(dbyear_dai) THEN dbyear_dai =0
	
	IF ls_dc_gu ="1" THEN
		dbyear_amount = dbyear_cha - dbyear_dai
	ELSEIF ls_dc_gu ="2" THEN
		dbyear_amount = dbyear_dai - dbyear_cha
	END IF

	SELECT SUM("KFZ02OT2"."JUN_DR_AMT"),   										//당기누계
			 SUM("KFZ02OT2"."JUN_CR_AMT")  
		INTO :ddyear_cha,   :ddyear_dai  
		FROM "KFZ02OT2"  
		WHERE "SAUPJ" = :LsCurrSaupj AND "ACC1_CD" = :ls_acc1 AND "ACC2_CD" = :ls_acc2 ;
	IF IsNull(ddyear_cha) THEN ddyear_cha =0
	IF IsNull(ddyear_dai) THEN ddyear_dai =0
	
	IF ls_dc_gu ="1" THEN
		ddyear_amount = ddyear_cha - ddyear_dai
	ELSEIF ls_dc_gu ="2" THEN
		ddyear_amount = ddyear_dai - ddyear_cha
	END IF
ELSEIF ls_amt_gu ='2' THEN															//차변
	
	SELECT SUM("KFZ02OT2"."PRV_DR_AMT")											//전기누계
		INTO :dbyear_amount
		FROM "KFZ02OT2"  
		WHERE "SAUPJ" = :LsCurrSaupj AND "ACC1_CD" = :ls_acc1 AND "ACC2_CD" = :ls_acc2 ;
	IF IsNull(dbyear_amount) THEN dbyear_amount =0
	
	SELECT SUM("KFZ02OT2"."DR_AMT")												//당기누계
		INTO :ddyear_amount
		FROM "KFZ02OT2"  
		WHERE "SAUPJ" = :LsCurrSaupj AND "ACC1_CD" = :ls_acc1 AND "ACC2_CD" = :ls_acc2 ;
	IF IsNull(ddyear_amount) THEN ddyear_amount =0
ELSEIF ls_amt_gu = '3' THEN														//대변

	SELECT SUM("KFZ02OT2"."PRV_CR_AMT")											//전기누계
		INTO :dbyear_amount
	   FROM "KFZ02OT2"  
		WHERE "SAUPJ" = :LsCurrSaupj AND "ACC1_CD" = :ls_acc1 AND "ACC2_CD" = :ls_acc2 ;
	IF IsNull(dbyear_amount) THEN dbyear_amount =0
	
	SELECT SUM("KFZ02OT2"."CR_AMT")												//당기누계
		INTO :ddyear_amount
	   FROM "KFZ02OT2"  
		WHERE "SAUPJ" = :LsCurrSaupj AND "ACC1_CD" = :ls_acc1 AND "ACC2_CD" = :ls_acc2 ;
	IF IsNull(ddyear_amount) THEN ddyear_amount =0
	
ELSEIF ls_amt_gu ='4' THEN

	Double dbbase_cha,dbbase_dai										//전기누계
	
	SELECT SUM("KFZ02OT2"."PRV_DR_AMT"),    SUM("KFZ02OT2"."PRV_CR_AMT"),
			 SUM("KFZ02OT2"."PRV_JUN_DR_AMT"),SUM("KFZ02OT2"."PRV_JUN_CR_AMT")
		INTO :dbyear_cha,                    :dbyear_dai,
			  :dbbase_cha,							 :dbbase_dai
		FROM "KFZ02OT2"  
		WHERE "SAUPJ" = :LsCurrSaupj AND "ACC1_CD" = :ls_acc1 AND "ACC2_CD" = :ls_acc2 ;
	IF IsNull(dbyear_cha) THEN dbyear_cha =0
	IF IsNull(dbyear_dai) THEN dbyear_dai =0
	IF IsNull(dbbase_cha) THEN dbbase_cha =0
	IF IsNull(dbbase_dai) THEN dbbase_dai =0
	
	IF ls_dc_gu ="1" THEN
		dbyear_amount = (dbyear_cha + dbbase_cha) - (dbyear_dai + dbbase_dai)
	ELSEIF ls_dc_gu ="2" THEN
		dbyear_amount = (dbyear_dai + dbbase_dai) - (dbyear_cha + dbbase_cha)
	END IF

	Double ddbase_cha,ddbase_dai											//당기누계
	
	SELECT SUM("KFZ02OT2"."DR_AMT"),     SUM("KFZ02OT2"."CR_AMT"),
			 SUM("KFZ02OT2"."JUN_DR_AMT"), SUM("KFZ02OT2"."JUN_CR_AMT")
		INTO :ddyear_cha,                 :ddyear_dai,
			  :ddbase_cha,                 :ddbase_dai
		FROM "KFZ02OT2"  
		WHERE "SAUPJ" = :LsCurrSaupj AND "ACC1_CD" = :ls_acc1 AND "ACC2_CD" = :ls_acc2 ;
	IF IsNull(ddyear_cha) THEN ddyear_cha =0
	IF IsNull(ddyear_dai) THEN ddyear_dai =0
	IF IsNull(ddbase_cha) THEN ddbase_cha =0
	IF IsNull(ddbase_dai) THEN ddbase_dai =0
	
	IF ls_dc_gu ="1" THEN
		ddyear_amount = (ddyear_cha + ddbase_cha) - (ddyear_dai + ddbase_dai)
	ELSEIF ls_dc_gu ="2" THEN
		ddyear_amount = (ddyear_dai + ddbase_dai) - (ddyear_cha + ddbase_cha)
	END IF
	
ELSEIF ls_amt_gu ='0' THEN
	SetNull(dbyear_amount)
	SetNull(ddyear_amount)
END IF

Return 1
end function

public function integer wf_get_calc9 (long lfs_seq, ref double dbyear_amount, ref double ddyear_amount);
Double dAmountBef,dAmountDang
Integer 		il_Count,k
String  		sAcc1,sAcc2,sCalcGbn,sAmtGbn,sDcGbn
DataStore  	Idw_CalcLst

Idw_CalcLst = Create DataStore

Idw_CalcLst.DataObject = 'dw_kgle03_3'
Idw_CalcLst.SetTransObject(Sqlca)
Idw_CalcLst.Reset()

il_Count = Idw_CalcLst.Retrieve(LsFsGbn,lFs_Seq)
IF il_Count <=0 THEN
	dbyear_amount =0;	ddyear_amount =0;
	Return 1
END IF
FOR k = 1 TO il_Count
	sAcc1    = Idw_CalcLst.GetItemString(k,"acc1_cd")
	sAcc2    = Idw_CalcLst.GetItemString(k,"acc2_cd")
	sAmtGbn	= Idw_CalcLst.GetItemString(k,"amt_gu")
	sCalcGbn = Idw_CalcLst.GetItemString(k,"calc_gu")
	sDcGbn   = Idw_CalcLst.GetItemString(k,"dc_gu")

	wf_get_amount(sAcc1,sAcc2,sAmtGbn,sDcGbn,dAmountBef,dAmountDang)
	
	IF sCalcGbn ="+" THEN
		dbyear_amount = dbyear_amount + dAmountBef
		ddyear_amount = ddyear_amount + dAmountDang
	ELSEIF sCalcGbn ="-" THEN
		dbyear_amount = dbyear_amount - dAmountBef
		ddyear_amount = ddyear_amount - dAmountDang
	END IF
	dAmountBef =0;		dAmountDang =0;
NEXT
Destroy Idw_CalcLst
	
Return 1
end function

public function integer wf_insert_kfz02wk (long lfsseq, string skname, string sename, string scname, string ls_amt_gu, string ls_amt_posi, string ls_chagam_gu, ref double dbyear_amount, ref double ddyear_amount);//***********************************************************************************//
//****** 구해진 금액을 KFZ02WK의 자료로 생성하기
//  1. 금액 위치에 따라서 구해진 금액을  저장한다
//     1-1. 금액위치가 '1' 이면 JYAMT1,DYAMT1,(전기,당기)
//                     '2' 이면 JYAMT2,DYAMT2,(전기,당기)
//  2. 차감계정설정구분에 따라서 '금액설정금액 - 차감계정'의 값을 금액위치 '2'에 MOVE
//     2-1. '차감계정설정구분'이 'S'(금액설정) 이면 임시변수에 값을 MOVE
//     2-2.                      'M'(차감계정) 이면 
//                                        '2-1의 값' - 금액 을 금액위치 '2'로 MOVE
//
//**********************************************************************************//
IF ls_amt_gu ='0' THEN
	INSERT INTO "KFZ02WK"  
		( "SAUPJ"        ,"CURR_FROM_DATE","CURR_TO_DATE","PRV_FROM_DATE","PRV_TO_DATE",   
		  "FS_GU"        ,"FS_SEQ"        ,"KNAME"       ,"JMAMT1"       ,"JMAMT2"     ,   
		  "DMAMT1"       ,"DMAMT2"        ,"JYAMT1"       ,"JYAMT2"      ,
		  "DYAMT1"       ,"DYAMT2"        ,"CURR_YEAR"   ,"PRV_YEAR"     ,"ACC_YM"		 ,	"ENAME",			"CNAME" )  
	VALUES 
		( :LsCurrSaupj   ,:sd_frymd       ,:sd_toymd     ,:sj_frymd      ,:sj_toymd    ,   
		  :LsFsGbn       ,:lFsSeq         ,:sKName       ,null           ,null         ,
		  null           ,null            ,:dbyear_amount,null           ,
		  :ddyear_amount ,null            ,:ld_ses       ,:lj_ses        ,:sd_toymd    , :sEName,			:sCName )  ;
ELSE
	IF ls_amt_posi ="1" THEN
		INSERT INTO "KFZ02WK"  
			( "SAUPJ"        ,"CURR_FROM_DATE","CURR_TO_DATE","PRV_FROM_DATE","PRV_TO_DATE",   
			  "FS_GU"        ,"FS_SEQ"        ,"KNAME"       ,"JMAMT1"       ,"JMAMT2"     ,   
			  "DMAMT1"       ,"DMAMT2"        ,"JYAMT1"       ,"JYAMT2"      ,
			  "DYAMT1"       ,"DYAMT2"        ,"CURR_YEAR"   ,"PRV_YEAR"     ,"ACC_YM" 	 , "ENAME",			"CNAME" )  
		VALUES 
			( :LsCurrSaupj   ,:sd_frymd       ,:sd_toymd     ,:sj_frymd      ,:sj_toymd    ,   
			  :LsFsGbn       ,:lFsSeq         ,:sKName       ,0              ,0            ,
			  0             ,0               ,:dbyear_amount,0              ,
			  :ddyear_amount,0               ,:ld_ses       ,:lj_ses        ,:sd_toymd     , :sEName,			:sCName )  ;
	ELSE
		INSERT INTO "KFZ02WK"  
			( "SAUPJ"    ,"CURR_FROM_DATE","CURR_TO_DATE","PRV_FROM_DATE","PRV_TO_DATE",   
			  "FS_GU"    ,"FS_SEQ"        ,"KNAME"       ,"JMAMT1"       ,"JMAMT2"     ,   
			  "DMAMT1"   ,"DMAMT2"        ,"JYAMT1"       ,"JYAMT2"     ,
			  "DYAMT1"   ,"DYAMT2"        ,"CURR_YEAR"   ,"PRV_YEAR"     ,"ACC_YM"     ,  "ENAME",			"CNAME" )  
		VALUES 
			( :LsCurrSaupj,:sd_frymd       ,:sd_toymd     ,:sj_frymd      ,:sj_toymd    ,   
			  :LsFsGbn    ,:lFsSeq         ,:sKName       ,0              ,0            ,
			  0           ,0               ,0             ,:dbyear_amount ,
			  0           ,:ddyear_amount  ,:ld_ses       ,:lj_ses        ,:sd_toymd    ,  :sEName,			:sCName )  ;
	END IF
END IF

IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(13,'[결산자료 저장]'+sqlca.sqlerrtext)
	ROLLBACK;
	Return -1
END IF

IF ls_chagam_gu ='S' THEN
	LdChaGam_Bef  = dbyear_amount
	LdChaGam_Dang = ddyear_amount
ELSEIF ls_chagam_gu ='M' THEN
	LdChaGam_Bef = LdChaGam_Bef - dbyear_amount
	LdChaGam_Dang= LdChaGam_Dang - ddyear_amount
	
	UPDATE "KFZ02WK"  
   	SET "JYAMT2" = :LdChaGam_Bef,   "DYAMT2" = :LdChaGam_Dang
  		WHERE ( "SAUPJ" = :LsCurrSaupj ) AND  
      	   ( "CURR_FROM_DATE" = :sd_frymd ) AND ( "CURR_TO_DATE" = :sd_toymd ) AND  
         	( "PRV_FROM_DATE" = :sj_frymd ) AND  ( "PRV_TO_DATE" = :sj_toymd ) AND  
         	( "FS_GU" = :LsFsGbn ) AND  ( "FS_SEQ" = :lFsSeq )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[결산자료 저장]'+sqlca.sqlerrtext)
		ROLLBACK;
		Return -1
	END IF
	
	LdChaGam_Bef  = 0;	LdChaGam_Dang = 0;
END IF

Return 1
end function

event open;call super::open;
dw_ip.SetTransObject(sqlca)
dw_ip.Retrieve()

dw_ip.SetItem(dw_ip.GetRow(),"saupj",gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(),"gubun",'1')

dw_ip.SetFocus()

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.Modify("saupj.protect = 1")
	dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_ip.Modify("saupj.protect = 0")
	dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")
END IF

end event

on w_kgle03.create
int iCurrent
call super::create
this.cb_6=create cb_6
this.st_2=create st_2
this.mle_1=create mle_1
this.gb_1=create gb_1
this.dw_ip=create dw_ip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_6
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.mle_1
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.dw_ip
end on

on w_kgle03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_6)
destroy(this.st_2)
destroy(this.mle_1)
destroy(this.gb_1)
destroy(this.dw_ip)
end on

type dw_insert from w_inherite`dw_insert within w_kgle03
end type

type cb_exit from w_inherite`cb_exit within w_kgle03
integer x = 3209
integer y = 1908
integer taborder = 30
end type

type cb_mod from w_inherite`cb_mod within w_kgle03
boolean visible = false
integer x = 421
integer y = 2632
integer width = 293
integer taborder = 0
end type

type cb_ins from w_inherite`cb_ins within w_kgle03
boolean visible = false
integer x = 2487
integer y = 2632
integer width = 626
integer taborder = 0
string text = "window function"
end type

type cb_del from w_inherite`cb_del within w_kgle03
boolean visible = false
integer x = 745
integer y = 2632
integer width = 293
integer taborder = 0
end type

type cb_inq from w_inherite`cb_inq within w_kgle03
boolean visible = false
integer x = 1070
integer y = 2632
integer width = 293
integer taborder = 0
end type

type cb_print from w_inherite`cb_print within w_kgle03
integer x = 1394
integer y = 2632
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kgle03
integer x = 41
integer y = 2104
integer width = 343
integer textsize = -10
end type

type cb_can from w_inherite`cb_can within w_kgle03
boolean visible = false
integer x = 1710
integer y = 2624
integer width = 293
integer taborder = 0
end type

type cb_search from w_inherite`cb_search within w_kgle03
integer x = 2043
integer y = 2632
integer width = 425
end type

type dw_datetime from w_inherite`dw_datetime within w_kgle03
integer y = 2104
integer width = 741
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kgle03
integer x = 389
integer y = 2104
integer width = 2487
integer textsize = -10
end type

type gb_10 from w_inherite`gb_10 within w_kgle03
integer y = 2052
end type

type gb_button1 from w_inherite`gb_button1 within w_kgle03
boolean visible = false
integer x = 1458
integer y = 2372
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kgle03
integer x = 2839
integer y = 1856
integer width = 741
end type

type cb_6 from commandbutton within w_kgle03
event ue_total_init pbm_custom01
integer x = 2871
integer y = 1908
integer width = 315
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리(&E)"
end type

event clicked;String  sGbn,sSaupj,sFsGbn
Integer iSaupjF,iSaupjT,iFsF,iFsT,k,i,iDbCnt

sle_msg.text =""
dw_ip.AcceptText()

sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sd_frymd = dw_ip.GetItemString(dw_ip.GetRow(),"d_frymd")
sd_toymd = dw_ip.GetItemString(dw_ip.GetRow(),"d_toymd")
sj_frymd = dw_ip.GetItemString(dw_ip.GetRow(),"j_frymd")
sj_toymd = dw_ip.GetItemString(dw_ip.GetRow(),"j_toymd")
ld_ses   = dw_ip.GetItemNumber(dw_ip.GetRow(),"d_ses")
lj_ses   = dw_ip.GetItemNumber(dw_ip.GetRow(),"j_ses")
sFsGbn   = dw_ip.GetItemString(dw_ip.GetRow(),"fsgbn")
sGbn     = dw_ip.GetItemString(dw_ip.GetRow(),"gubun")

IF sGbn ='1' THEN 										/*실결산*/
	sle_msg.text ="실결산 처리 중(시산표 복사)..."
	IF f_closing_copy(sd_frymd,sd_toymd,sj_frymd,sj_toymd) <> 1 THEN
		MessageBox("확 인","시산표 복사 실패 !!")
		Return
	END IF
ELSEIF sGbn ='2' THEN									/*가결산*/
	sle_msg.text ="실결산 처리 중(시산표 복사)..."
	IF f_closing_copy(sd_frymd,sd_toymd,sj_frymd,sj_toymd) <> 1 THEN
		MessageBox("확 인","시산표 복사 실패 !!")
		Return
	END IF
	
	sle_msg.text = '가결산 전표 집계 중...'
	IF f_closing_sum(Left(sd_frymd,6),Left(sd_toymd,6)) <> 1 THEN
		MessageBox("확 인","가결산집계 실패 !!")
		RETURN
	END IF
	sle_msg.text = '가결산 전표 집계 완료!!'
END IF

IF sSaupj = "" OR IsNull(sSaupj) THEN 
	iSaupjF = 1;						
	select max(to_number(rfgub))	into :iSaupjT from reffpf where rfcod = 'AD' and rfgub <> '00';
ELSE
	iSaupjF = Integer(sSaupj);		iSaupjT = Integer(sSaupj);
END IF	
IF sFsGbn = "" OR IsNull(sFsGbn) THEN 
	iFsF = 1;							iFsT = 9;
ELSE
	iFsF = Integer(sFsGbn);			iFsT = Integer(sFsGbn);
END IF

FOR k = iSaupjF TO iSaupjT
	LsCurrSaupj = String(k)
	
	select count(*) into :iDbCnt	from kfz02ot2	where saupj = :LsCurrSaupj;
	if sqlca.sqlcode <> 0 or iDbCnt =0 or IsNull(iDbCnt) then continue
		
	FOR i = iFsF TO iFsT
		LsFsGbn = String(i)
		
		DELETE FROM "KFZ02WK"  															/*초기화*/
			WHERE ( "KFZ02WK"."SAUPJ"          = :LsCurrSaupj ) AND  
					( "KFZ02WK"."CURR_FROM_DATE" = :sd_frymd  ) AND  
					( "KFZ02WK"."CURR_TO_DATE"   = :sd_toymd ) AND  
					( "KFZ02WK"."PRV_FROM_DATE"  = :sj_frymd ) AND  
					( "KFZ02WK"."PRV_TO_DATE"    = :sj_toymd ) AND
					( "KFZ02WK"."FS_GU"          = :LsFsGbn) ;
			
		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확인"," KFZ02WK의 초기화 실패.!!!")
			ROLLBACK;
			Return
		ELSE
			COMMIT;
		END IF
		
		IF Wf_Read_Kfz02om0() = -1 THEN 
			Rollback;
			Return
		END IF
	NEXT
NEXT
Commit;
sle_msg.Text = '재무제표 자료 작성 완료!!'
end event

type st_2 from statictext within w_kgle03
integer x = 914
integer y = 228
integer width = 1637
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "재 무 제 표 자 료 생 성"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type mle_1 from multilineedit within w_kgle03
integer x = 914
integer y = 324
integer width = 1637
integer height = 180
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 65535
long backcolor = 128
string text = " ** 재무제표 자료를 생성 처리 합니다.                   가결산을 처리할 경우에는 가결산전표 등록 작업을  먼저 수행한 후 작업하시기 바랍니다.         "
alignment alignment = center!
borderstyle borderstyle = styleraised!
end type

type gb_1 from groupbox within w_kgle03
integer x = 914
integer y = 488
integer width = 1637
integer height = 688
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
borderstyle borderstyle = styleraised!
end type

type dw_ip from u_key_enter within w_kgle03
integer x = 1006
integer y = 568
integer width = 1454
integer height = 564
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgle03_1"
boolean border = false
end type

event itemchanged;String snull,ssql_saupj

SetNull(snull)

IF dwo.name ="saupj" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 
	  
	SELECT "REFFPF"."RFNA1"  
  		INTO :ssql_saupj
  		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
      		( "REFFPF"."RFGUB" = :data )   ;
  	if sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"사업장")
		dw_ip.SetItem(1,"saupj",snull)
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return 1
  	end if
END IF
end event

event itemerror;Return 1
end event

