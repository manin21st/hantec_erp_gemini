$PBExportHeader$w_pip2016.srw
$PBExportComments$** 월급여 마감작업
forward
global type w_pip2016 from w_inherite_multi
end type
type dw_cond from u_key_enter within w_pip2016
end type
end forward

global type w_pip2016 from w_inherite_multi
string title = "월마감작업"
dw_cond dw_cond
end type
global w_pip2016 w_pip2016

type variables

end variables

forward prototypes
public function integer wf_history_create (string syymm, string sgubn)
end prototypes

public function integer wf_history_create (string syymm, string sgubn);/****  월급여 마감작업시 급여 고정금액 자료와 기본자료의 이력을 생성  *****/


/***마감취소시 이력자료 삭제 ***/


IF sgubn = 'N' THEN
	
	DELETE FROM "P8_HPERSONAL"  
   WHERE ( "P8_HPERSONAL"."COMPANYCODE" = :gs_company ) AND  
         ( "P8_HPERSONAL"."HYYMM" = :syymm )   ;
		
	DELETE FROM "P8_HFIXEDDATA"  
   WHERE ( "P8_HFIXEDDATA"."COMPANYCODE" = :gs_company ) AND  
         ( "P8_HFIXEDDATA"."HYYMM" = :syymm )   ;

	DELETE FROM "P8_HEXCEPTDATA"  
   WHERE ( "P8_HEXCEPTDATA"."COMPANYCODE" = :gs_company ) AND  
         ( "P8_HEXCEPTDATA"."HYYMM" = :syymm )   ;
			
	DELETE FROM "P8_HEXCEPT_CALC_EMPNO"  
   WHERE ( "P8_HEXCEPT_CALC_EMPNO"."COMPANYCODE" = :gs_company ) AND  
         ( "P8_HEXCEPT_CALC_EMPNO"."HYYMM" = :syymm )   ;
		
	IF SQLCA.SQLCODE <> 0 THEN
		ROLLBACK;
		RETURN 1
	END IF	
ELSE
		
	INSERT INTO "P8_HPERSONAL"  
  		       ( "COMPANYCODE",
					"EMPNO"      , 
					"HYYMM"      ,
					"PENDEGREE",
					"MEDDEGREE",   
	            "WIFETAG",   
					"DEPENDENT20",
					"DEPENDENT60", 
					"RESPECT"  , 
					"RUBBER",   
	            "BANKCODE", 
					"ACNTNO",  
					"TRUSTEENAME",
					"WORKCOUPLETAG",
					"MEDINSURANCESUBTAG",   
               "MUTUALTAG", 
					"WOMENHOUSE", 
					"CHILDCOUNT", 
					"PAYCHECK", 
					"BONUSCHECK",   
		         "YEARPAY", 
					"RETIREAMTCHECK",
					"EMPLOYCHECK",
					"MEDAMT", 
					"PENAMT",   
	            "CIRCLE_GUBUN",
					"CONSMAT_GUBUN",
					"LOCALSUDANGGUBN",
					"LOCALSUDANGLEVEL",
					"SALESUDANGGUBN",   
               "LUNCHSUDANGGUBN",
					"FAMILYSUDANGINWON",
					"LOCALSUDANG",
					"BONUSPAYGUBN",
					"MEDBEFORGUBN",   
	            "MEDBEFORGUBN2",
					"YEARPAYCOUNT" )  
   	  SELECT "P3_PERSONAL"."COMPANYCODE",   
      		   "P3_PERSONAL"."EMPNO",  
					:syymm  ,
					"P3_PERSONAL"."PENDEGREE",   
					"P3_PERSONAL"."MEDDEGREE",   
					"P3_PERSONAL"."WIFETAG",   
					"P3_PERSONAL"."DEPENDENT20",   
					"P3_PERSONAL"."DEPENDENT60",   
					"P3_PERSONAL"."RESPECT",   
					"P3_PERSONAL"."RUBBER",   
					"P3_PERSONAL"."BANKCODE",   
					"P3_PERSONAL"."ACNTNO",   
					"P3_PERSONAL"."TRUSTEENAME",   
					"P3_PERSONAL"."WORKCOUPLETAG",   
					"P3_PERSONAL"."MEDINSURANCESUBTAG",   
					"P3_PERSONAL"."MUTUALTAG",   
					"P3_PERSONAL"."WOMENHOUSE",   
					"P3_PERSONAL"."CHILDCOUNT",   
					"P3_PERSONAL"."BONUSCHECK",   
					"P3_PERSONAL"."PAYCHECK",   
					"P3_PERSONAL"."YEARPAY",   
					"P3_PERSONAL"."RETIREAMTCHECK",   
					"P3_PERSONAL"."EMPLOYCHECK",   
					"P3_PERSONAL"."MEDAMT",   
					"P3_PERSONAL"."PENAMT",   
					"P3_PERSONAL"."CIRCLE_GUBUN",   
					"P3_PERSONAL"."CONSMAT_GUBUN",   
					"P3_PERSONAL"."LOCALSUDANGGUBN",   
					"P3_PERSONAL"."LOCALSUDANGLEVEL",   
					"P3_PERSONAL"."SALESUDANGGUBN",   
					"P3_PERSONAL"."LUNCHSUDANGGUBN",   
					"P3_PERSONAL"."FAMILYSUDANGINWON",   
					"P3_PERSONAL"."LOCALSUDANG",   
					"P3_PERSONAL"."BONUSPAYGUBN",   
					"P3_PERSONAL"."MEDBEFORGUBN",   
					"P3_PERSONAL"."MEDBEFORGUBN2",   
					"P3_PERSONAL"."YEARPAYCOUNT"  
			 FROM "P3_PERSONAL"   ;	
			 
	  IF SQLCA.SQLCODE <> 0 THEN
		  ROLLBACK ;
		  RETURN 1
	  END IF	  	 
			 
     INSERT INTO "P8_HFIXEDDATA"  
						( "COMPANYCODE",   
						  "ALLOWCODE",   
						  "EMPNO",   
						  "HYYMM",   
						  "PBTAG",   
						  "ALLOWAMT",   
						  "GUBUN" )  
    		SELECT "P3_FIXEDDATA"."COMPANYCODE",   
       	       "P3_FIXEDDATA"."ALLOWCODE",   
         		 "P3_FIXEDDATA"."EMPNO", 
					 :syymm,
         		 "P3_FIXEDDATA"."PBTAG",   
         		 "P3_FIXEDDATA"."ALLOWAMT",   
         		 "P3_FIXEDDATA"."GUBUN"  
    		FROM "P3_FIXEDDATA"  ;

	  IF SQLCA.SQLCODE <> 0 THEN
		  ROLLBACK ;
		  RETURN 1
	  END IF	
	  
	  INSERT INTO "P8_HEXCEPTDATA"  
					( "COMPANYCODE",   
					  "EMPNO",   
					  "PBTAG",   
					  "HYYMM",   
					  "USEREC",   
					  "PAYRATE",   
					  "PAYAMT",   
					  "INCOMETAX",   
					  "RESIDENTTAX",   
					  "PAYDAY",   
					  "PAYDAYS" )  
			 SELECT "P3_EXCEPTDATA"."COMPANYCODE",   
					  "P3_EXCEPTDATA"."EMPNO",   
					  "P3_EXCEPTDATA"."PBTAG", 
					  :syymm,	
					  "P3_EXCEPTDATA"."USEREC",   
					  "P3_EXCEPTDATA"."PAYRATE",   
					  "P3_EXCEPTDATA"."PAYAMT",   
					  "P3_EXCEPTDATA"."INCOMETAX",   
					  "P3_EXCEPTDATA"."RESIDENTTAX",   
					  "P3_EXCEPTDATA"."PAYDAY",   
					  "P3_EXCEPTDATA"."PAYDAYS"  
			  FROM "P3_EXCEPTDATA"  ;

	  IF SQLCA.SQLCODE <> 0 THEN
		  ROLLBACK ;
		  RETURN 1
     END IF	
	  
	  INSERT INTO "P8_HEXCEPT_CALC_EMPNO"  
		          ( "COMPANYCODE",   
       			   "PBTAG",   
                  "ADDSUBTAG",   
                  "ALLOWANCECODE",   
                  "EMPNO",   
                  "HYYMM" )  
				SELECT "P3_EXCEPT_CALC_EMPNO"."COMPANYCODE",   
			          "P3_EXCEPT_CALC_EMPNO"."PBTAG",   
         			 "P3_EXCEPT_CALC_EMPNO"."ADDSUBTAG",   
                   "P3_EXCEPT_CALC_EMPNO"."ALLOWANCECODE",   
                   "P3_EXCEPT_CALC_EMPNO"."EMPNO" ,
						 :syymm
			    FROM "P3_EXCEPT_CALC_EMPNO"  ;

	  IF SQLCA.SQLCODE <> 0 THEN
		  ROLLBACK ;
		  RETURN 1
     END IF	
END IF
COMMIT;
RETURN  0
end function

on w_pip2016.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
end on

on w_pip2016.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
end on

event open;call super::open;
dw_cond.SetTransObject(SQLCA)
dw_cond.SetRedraw(False)
dw_cond.Reset()

dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)

/*사업장 정보 셋팅*/
f_set_saupcd(dw_cond,'saupcd','1')

dw_cond.SetItem(1,"clyearmm",Left(gs_today,6))

dw_cond.SetColumn("clyearmm")
dw_cond.SetFocus()



end event

type p_delrow from w_inherite_multi`p_delrow within w_pip2016
boolean visible = false
integer x = 3694
integer y = 2952
boolean enabled = false
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip2016
boolean visible = false
integer x = 3520
integer y = 2952
boolean enabled = false
end type

type p_search from w_inherite_multi`p_search within w_pip2016
boolean visible = false
integer x = 2825
integer y = 2952
boolean enabled = false
end type

type p_ins from w_inherite_multi`p_ins within w_pip2016
boolean visible = false
integer x = 3346
integer y = 2952
boolean enabled = false
end type

type p_exit from w_inherite_multi`p_exit within w_pip2016
integer x = 4389
end type

type p_can from w_inherite_multi`p_can within w_pip2016
boolean visible = false
integer x = 4041
integer y = 2952
boolean enabled = false
end type

type p_print from w_inherite_multi`p_print within w_pip2016
boolean visible = false
integer x = 2999
integer y = 2952
boolean enabled = false
end type

type p_inq from w_inherite_multi`p_inq within w_pip2016
boolean visible = false
integer x = 3173
integer y = 2952
boolean enabled = false
end type

type p_del from w_inherite_multi`p_del within w_pip2016
boolean visible = false
integer x = 3867
integer y = 2952
boolean enabled = false
end type

type p_mod from w_inherite_multi`p_mod within w_pip2016
integer x = 4215
end type

event p_mod::clicked;call super::clicked;////// 월마감작업

Int    il_meterPosition,k,il_SearchRow,il_RetrieveRow,il_CurRow,syday,sbday,il_RowCount,rtnval

String sEmpNo,sgubn,sdeptcode, syymm,  ls_gubn, spbgubn, sSaup

dw_cond.AcceptText()
syymm = trim(dw_cond.GetItemString(1,"clyearmm"))
sgubn = dw_cond.GetItemString(1,"clyn")
spbgubn = dw_cond.GetItemString(1,"clgubn")
sSaup = dw_cond.GetItemString(1,"saupcd")

SetPointer(HourGlass!)	

  SELECT "P8_PAYFLAG"."CLYN" 
    INTO :ls_gubn
    FROM "P8_PAYFLAG"  
   WHERE ( "P8_PAYFLAG"."COMPANYCODE" = :gs_company ) AND  
         ( "P8_PAYFLAG"."CLYEARMM" = :syymm ) AND  
         ( "P8_PAYFLAG"."CLGUBN" = :spbgubn ) AND
         ( "P8_PAYFLAG"."SAUPCD" = :sSaup );
	IF ls_gubn = sgubn THEN
		SetPointer(Arrow!)
      w_mdi_frame.sle_msg.text =''
		if sgubn = 'Y' then //마감작업
			MessageBox("확 인","이미 마감이 완료된 월입니다!!")	
		else
			MessageBox("확 인","이미 마감취소된 월입니다!!")	
		end if	
		return
	END IF
	
	IF SQLCA.SQLCODE = 0 THEN
		  UPDATE "P8_PAYFLAG"  
   		  SET "CLYN" = :sgubn  
   		WHERE ( "P8_PAYFLAG"."COMPANYCODE" = :gs_company ) AND  
      		   ( "P8_PAYFLAG"."CLYEARMM" = :syymm ) AND  
    		      ( "P8_PAYFLAG"."CLGUBN" = :spbgubn ) AND
         		( "P8_PAYFLAG"."SAUPCD" = :sSaup );

	 		IF SQLCA.SQLCODE <> 0 THEN
				if sgubn = 'Y' then //마감작업
					MessageBox("확 인","월마감작업 실패!!")
				else
					MessageBox("확 인","월마감취소작업 실패!!")
				end if	
	   		ROLLBACK;
			   SetPointer(Arrow!)
   	   	w_mdi_frame.sle_msg.text =''
	   		Return
		   ELSE
   			COMMIT;
			END IF	
	ELSE	
		   INSERT INTO "P8_PAYFLAG"
        	 		    ( "COMPANYCODE", "CLYEARMM", "CLGUBN", "JOBGUBN",  "CLYN",	 "SAUPCD" )  
			   VALUES ( :gs_company,   :syymm,     :spbgubn, '',         :sgubn,	 :sSaup )  ;
				
	  		IF SQLCA.SQLCODE <> 0 THEN
				if sgubn = 'Y' then //마감작업
					MessageBox("확 인","월마감작업 실패!!")
				else
					MessageBox("확 인","월마감취소작업 실패!!")
				end if	
		   	ROLLBACK;
			   SetPointer(Arrow!)
      		w_mdi_frame.sle_msg.text =''
		   	Return
		   ELSE
   			COMMIT;	
			END IF	
	END IF
   SetPointer(Arrow!)
   IF spbgubn = 'P' THEN
		rtnval = wf_history_create(syymm, sgubn)
		IF rtnval = 1 THEN
			IF sgubn = 'Y' then //마감작업
				MessageBox("확 인","월마감작업 실패!!")
			ELSE
				MessageBox("확 인","월마감취소작업 실패!!")
			END IF
			SetPointer(Arrow!)
			w_mdi_frame.sle_msg.text =''
			Return
		END IF	
	END IF
	
	if sgubn = 'Y' then //마감작업
	   w_mdi_frame.sle_msg.text ='월마감작업 완료!!'
	else	
	   w_mdi_frame.sle_msg.text ='월마감 취소 작업 완료!!'
	end if	
end event

type dw_insert from w_inherite_multi`dw_insert within w_pip2016
boolean visible = false
integer x = 2537
integer y = 2968
end type

type st_window from w_inherite_multi`st_window within w_pip2016
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip2016
boolean visible = false
integer x = 439
integer y = 2636
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pip2016
boolean visible = false
integer x = 2336
integer y = 2624
integer taborder = 50
end type

type cb_update from w_inherite_multi`cb_update within w_pip2016
boolean visible = false
integer x = 1952
integer y = 2628
end type

event cb_update::clicked;call super::clicked;////// 월마감작업

Int    il_meterPosition,k,il_SearchRow,il_RetrieveRow,il_CurRow,syday,sbday,il_RowCount,rtnval

String sEmpNo,sgubn,sdeptcode, syymm,  ls_gubn, spbgubn

dw_cond.AcceptText()
syymm = trim(dw_cond.GetItemString(1,"clyearmm"))
sgubn = dw_cond.GetItemString(1,"clyn")
spbgubn = dw_cond.GetItemString(1,"clgubn")

dw_cond.AcceptText()

SetPointer(HourGlass!)	

  SELECT "P8_PAYFLAG"."CLYN" 
    INTO :ls_gubn
    FROM "P8_PAYFLAG"  
   WHERE ( "P8_PAYFLAG"."COMPANYCODE" = :gs_company ) AND  
         ( "P8_PAYFLAG"."CLYEARMM" = :syymm ) AND  
         ( "P8_PAYFLAG"."CLGUBN" = :spbgubn )   ;

	IF ls_gubn = sgubn THEN
		SetPointer(Arrow!)
      sle_msg.text =''
		if sgubn = 'Y' then //마감작업
			MessageBox("확 인","이미 마감이 완료된 월입니다!!")	
		else
			MessageBox("확 인","이미 마감취소된 월입니다!!")	
		end if	
		return
	END IF
	
	IF SQLCA.SQLCODE = 0 THEN
		  UPDATE "P8_PAYFLAG"  
   		  SET "CLYN" = :sgubn  
   		WHERE ( "P8_PAYFLAG"."COMPANYCODE" = :gs_company ) AND  
      		   ( "P8_PAYFLAG"."CLYEARMM" = :syymm ) AND  
    		      ( "P8_PAYFLAG"."CLGUBN" = :spbgubn )   ;

	 		IF SQLCA.SQLCODE <> 0 THEN
				if sgubn = 'Y' then //마감작업
					MessageBox("확 인","월마감작업 실패!!")
				else
					MessageBox("확 인","월마감취소작업 실패!!")
				end if	
	   		ROLLBACK;
			   SetPointer(Arrow!)
   	   	sle_msg.text =''
	   		Return
		   ELSE
   			COMMIT;
			END IF	
	ELSE	
		   INSERT INTO "P8_PAYFLAG"
        	 		    ( "COMPANYCODE", "CLYEARMM", "CLGUBN", "JOBGUBN",  "CLYN" )  
			   VALUES ( :gs_company,   :syymm,     :spbgubn, '',         :sgubn )  ;
				
	  		IF SQLCA.SQLCODE <> 0 THEN
				if sgubn = 'Y' then //마감작업
					MessageBox("확 인","월마감작업 실패!!")
				else
					MessageBox("확 인","월마감취소작업 실패!!")
				end if	
		   	ROLLBACK;
			   SetPointer(Arrow!)
      		sle_msg.text =''
		   	Return
		   ELSE
   			COMMIT;	
			END IF	
	END IF
   SetPointer(Arrow!)
   IF spbgubn = 'P' THEN
		rtnval = wf_history_create(syymm, sgubn)
		IF rtnval = 1 THEN
			IF sgubn = 'Y' then //마감작업
				MessageBox("확 인","월마감작업 실패!!")
			ELSE
				MessageBox("확 인","월마감취소작업 실패!!")
			END IF
			SetPointer(Arrow!)
			sle_msg.text =''
			Return
		END IF	
	END IF
	
	if sgubn = 'Y' then //마감작업
	   sle_msg.text ='월마감작업 완료!!'
	else	
	   sle_msg.text ='월마감 취소 작업 완료!!'
	end if	
end event

type cb_insert from w_inherite_multi`cb_insert within w_pip2016
boolean visible = false
integer x = 805
integer y = 2636
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip2016
boolean visible = false
integer x = 1189
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip2016
boolean visible = false
integer x = 59
integer y = 2640
integer taborder = 20
end type

type st_1 from w_inherite_multi`st_1 within w_pip2016
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip2016
boolean visible = false
integer x = 1531
integer taborder = 40
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip2016
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip2016
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip2016
boolean visible = false
integer x = 1893
integer y = 2568
integer width = 837
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip2016
boolean visible = false
integer x = 27
integer y = 2576
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip2016
boolean visible = false
end type

type dw_cond from u_key_enter within w_pip2016
integer x = 1856
integer y = 832
integer width = 1102
integer height = 644
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pip2016_1"
boolean border = false
end type

event itemerror;
Return 1
end event

event itemchanged;this.AcceptText()
// 
//string yymm
//if dw_cond.getcolumnname() = "myymm" then
//	yymm = dw_cond.gettext()
//	dw_cond.retrieve(gs_company, yymm)
//end if	
end event

event getfocus;this.AcceptText()

end event

