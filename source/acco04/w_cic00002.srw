$PBExportHeader$w_cic00002.srw
$PBExportComments$원가 월 마감작업
forward
global type w_cic00002 from w_inherite_multi
end type
type dw_cond from u_key_enter within w_cic00002
end type
type dw_list from u_d_select_sort within w_cic00002
end type
type st_2 from statictext within w_cic00002
end type
type rr_1 from roundrectangle within w_cic00002
end type
end forward

global type w_cic00002 from w_inherite_multi
integer width = 4841
integer height = 4616
string title = "원가 월마감 작업"
dw_cond dw_cond
dw_list dw_list
st_2 st_2
rr_1 rr_1
end type
global w_cic00002 w_cic00002

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
         ( "P8_HPERSONAL"."HYYMM" = :syymm )  AND
			( "P8_HPERSONAL"."EMPNO" in (select a.empno from p1_master a, p0_dept b
			                             where a.companycode = b.companycode and
												        a.deptcode = b.deptcode and
														  a.companycode = :gs_company and
												        b.saupcd = :is_saupcd ));
		
	DELETE FROM "P8_HFIXEDDATA"  
   WHERE ( "P8_HFIXEDDATA"."COMPANYCODE" = :gs_company ) AND  
         ( "P8_HFIXEDDATA"."HYYMM" = :syymm )    AND
			( "P8_HFIXEDDATA"."EMPNO" in (select a.empno from p1_master a, p0_dept b
			                             where a.companycode = b.companycode and
												        a.deptcode = b.deptcode and
														  a.companycode = :gs_company and
												        b.saupcd = :is_saupcd ));

	DELETE FROM "P8_HEXCEPTDATA"  
   WHERE ( "P8_HEXCEPTDATA"."COMPANYCODE" = :gs_company ) AND  
         ( "P8_HEXCEPTDATA"."HYYMM" = :syymm )   AND
			( "P8_HEXCEPTDATA"."EMPNO" in (select a.empno from p1_master a, p0_dept b
			                             where a.companycode = b.companycode and
												        a.deptcode = b.deptcode and
														  a.companycode = :gs_company and
												        b.saupcd = :is_saupcd ));
			
	DELETE FROM "P8_HEXCEPT_CALC_EMPNO"  
   WHERE ( "P8_HEXCEPT_CALC_EMPNO"."COMPANYCODE" = :gs_company ) AND  
         ( "P8_HEXCEPT_CALC_EMPNO"."HYYMM" = :syymm )    AND
			( "P8_HEXCEPT_CALC_EMPNO"."EMPNO" in (select a.empno from p1_master a, p0_dept b
			                             where a.companycode = b.companycode and
												        a.deptcode = b.deptcode and
														  a.companycode = :gs_company and
												        b.saupcd = :is_saupcd ));
		
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
					"P3_PERSONAL"."PAYCHECK",   
					"P3_PERSONAL"."BONUSCHECK",   
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
			 FROM "P3_PERSONAL"  
		  WHERE ( "P3_PERSONAL"."EMPNO" in (select a.empno from p1_master a, p0_dept b
			                             where a.companycode = b.companycode and
												        a.deptcode = b.deptcode and
														  a.companycode = :gs_company and
												        b.saupcd = :is_saupcd ));
			 
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
    		FROM "P3_FIXEDDATA"  
		  WHERE ( "P3_FIXEDDATA"."EMPNO" in (select a.empno from p1_master a, p0_dept b
			                             where a.companycode = b.companycode and
												        a.deptcode = b.deptcode and
														  a.companycode = :gs_company and
												        b.saupcd = :is_saupcd ));

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
			  FROM "P3_EXCEPTDATA"   
		  WHERE ( "P3_EXCEPTDATA"."EMPNO" in (select a.empno from p1_master a, p0_dept b
			                             where a.companycode = b.companycode and
												        a.deptcode = b.deptcode and
														  a.companycode = :gs_company and
												        b.saupcd = :is_saupcd ));

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
			    FROM "P3_EXCEPT_CALC_EMPNO"   
		  WHERE ( "P3_EXCEPT_CALC_EMPNO"."EMPNO" in (select a.empno from p1_master a, p0_dept b
			                             where a.companycode = b.companycode and
												        a.deptcode = b.deptcode and
														  a.companycode = :gs_company and
												        b.saupcd = :is_saupcd ));

	  IF SQLCA.SQLCODE <> 0 THEN
		  ROLLBACK ;
		  RETURN 1
     END IF	
END IF
COMMIT;
RETURN  0
end function

on w_cic00002.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_list=create dw_list
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_cic00002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;
dw_cond.SetTransObject(SQLCA)
dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_list.SetTransObject(SQLCA)


dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)


//dw_cond.SetItem(dw_cond.GetRow(),"workym",Left(gs_today,6))

dw_cond.SetColumn("workym")
dw_cond.SetFocus()

dw_list.retrieve()



end event

type p_delrow from w_inherite_multi`p_delrow within w_cic00002
boolean visible = false
integer x = 3694
integer y = 2952
integer taborder = 100
boolean enabled = false
end type

type p_addrow from w_inherite_multi`p_addrow within w_cic00002
boolean visible = false
integer x = 3520
integer y = 2952
integer taborder = 80
boolean enabled = false
end type

type p_search from w_inherite_multi`p_search within w_cic00002
boolean visible = false
integer x = 2825
integer y = 2952
integer taborder = 170
boolean enabled = false
end type

type p_ins from w_inherite_multi`p_ins within w_cic00002
integer x = 3854
integer taborder = 50
end type

event p_ins::clicked;call super::clicked;dw_list.retrieve()	

dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)

//dw_cond.SetItem(dw_cond.GetRow(),"workym",Left(gs_today,6))

dw_cond.SetColumn("workym")
dw_cond.SetFocus()

end event

type p_exit from w_inherite_multi`p_exit within w_cic00002
integer x = 4389
integer taborder = 160
end type

type p_can from w_inherite_multi`p_can within w_cic00002
integer x = 4210
integer taborder = 150
end type

event p_can::clicked;call super::clicked;dw_list.retrieve()	

dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)

//dw_cond.SetItem(dw_cond.GetRow(),"workym",Left(gs_today,6))

dw_cond.SetColumn("workym")
dw_cond.SetFocus()

end event

type p_print from w_inherite_multi`p_print within w_cic00002
boolean visible = false
integer x = 2999
integer y = 2952
integer taborder = 180
boolean enabled = false
end type

type p_inq from w_inherite_multi`p_inq within w_cic00002
boolean visible = false
integer x = 2958
boolean enabled = false
end type

event p_inq::clicked;call super::clicked;String ls_date, ls_gubn, snull,sSaup
SetNull(snull)

//IF dw_ip.AcceptText() = -1 THEN Return -1

//ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'mdate')
//ls_gubn = dw_ip.GetItemString(dw_Ip.GetRow(), 'gubn')
//sSaup = dw_ip.GetItemString(dw_ip.GetROw(),"saupcd")

//
//IF ls_date = '' OR IsNull(ls_date) THEN
//	MessageBox("확인", "조회년도를 입력하세요.")
//	dw_ip.SetItem(dw_ip.GetRow(), 'mdate', snull)
//	dw_ip.SetColumn('mdate')
//	dw_ip.SetFocus()
//	Return 1
//END IF

//IF ls_gubn = '' OR IsNull(ls_gubn) THEN ls_gubn = '%'
//IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'

dw_list.SetReDraw(False)
IF dw_list.Retrieve() < 1 THEN
	w_mdi_frame.sle_msg.text = "조회된 자료가 없습니다."
	dw_list.SetReDraw(True)
	Return 1
END IF
dw_list.SetReDraw(True)
end event

type p_del from w_inherite_multi`p_del within w_cic00002
boolean visible = false
integer x = 3867
integer y = 2952
integer taborder = 140
boolean enabled = false
end type

type p_mod from w_inherite_multi`p_mod within w_cic00002
integer x = 4032
integer taborder = 120
end type

event p_mod::clicked;call super::clicked;

String  syymm,  ls_gubn, sgubn

dw_cond.AcceptText()
syymm = trim(dw_cond.GetItemString(1,"workym"))
sgubn = dw_cond.GetItemString(1,"end_yn")


If f_datechk(syymm + '01') = -1 Then 
	f_messagechk(21, '[처리년월]')
	Return 1
End If

SetPointer(HourGlass!)	


  SELECT NVL("CIC0010"."END_YN",'Y')
    INTO :ls_gubn
    FROM "CIC0010"  
   WHERE  ( "CIC0010"."WORKYM" = :syymm ) ;
	
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

    dw_cond.SetItem(1,"end_emp", gs_empno)
    dw_cond.SetItem(1,"end_date", string(Today(),'yyyymmdd'))
    dw_cond.SetItem(1,"end_timE", string(Today(),'hhmm'))
//ls_yymm = f_aftermonth(string(Today(), "YYYYMM"), -1)	 
	if dw_cond.update() = 1 then
	   if sgubn = 'Y' then //마감작업
	     w_mdi_frame.sle_msg.text ='원가 월마감작업 완료!!'
	   else	
	     w_mdi_frame.sle_msg.text ='원가 월마감 취소 작업 완료!!'
	   end if
	   COMMIT USING SQLCA;
	else
		if sgubn = 'Y' then //마감작업
		   MessageBox("확 인","원가 월마감작업 실패!!")
		else
		  MessageBox("확 인","원가 월마감취소작업 실패!!")
		end if	
		rollback;
		return
	end if
	
dw_list.retrieve()	

dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)

//dw_cond.SetItem(dw_cond.GetRow(),"workym",Left(gs_today,6))

dw_cond.SetColumn("workym")
dw_cond.SetFocus()

	
end event

type dw_insert from w_inherite_multi`dw_insert within w_cic00002
boolean visible = false
integer x = 2537
integer y = 2968
integer taborder = 20
end type

type st_window from w_inherite_multi`st_window within w_cic00002
boolean visible = false
integer taborder = 60
end type

type cb_append from w_inherite_multi`cb_append within w_cic00002
boolean visible = false
integer x = 439
integer y = 2636
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_cic00002
boolean visible = false
integer x = 2336
integer y = 2624
integer taborder = 130
end type

type cb_update from w_inherite_multi`cb_update within w_cic00002
boolean visible = false
integer x = 1952
integer y = 2628
integer taborder = 90
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

type cb_insert from w_inherite_multi`cb_insert within w_cic00002
boolean visible = false
integer x = 805
integer y = 2636
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_cic00002
boolean visible = false
integer x = 1189
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_cic00002
boolean visible = false
integer x = 59
integer y = 2640
integer taborder = 70
end type

type st_1 from w_inherite_multi`st_1 within w_cic00002
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_cic00002
boolean visible = false
integer x = 1531
integer taborder = 110
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_cic00002
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_cic00002
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_cic00002
boolean visible = false
integer x = 1893
integer y = 2568
integer width = 837
end type

type gb_1 from w_inherite_multi`gb_1 within w_cic00002
boolean visible = false
integer x = 27
integer y = 2576
end type

type gb_10 from w_inherite_multi`gb_10 within w_cic00002
boolean visible = false
end type

type dw_cond from u_key_enter within w_cic00002
integer x = 3054
integer y = 284
integer width = 1102
integer height = 644
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_cic00002_2"
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

type dw_list from u_d_select_sort within w_cic00002
integer x = 494
integer y = 308
integer width = 2391
integer height = 1724
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_cic00002_1"
boolean border = false
end type

event clicked;call super::clicked;string ls_workym

ls_workym = dw_list.getitemstring(row,"cic0010_workym")

dw_cond.retrieve(ls_workym)
end event

type st_2 from statictext within w_cic00002
integer x = 503
integer y = 240
integer width = 1239
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "Click시 년월 마감여부를 수정할 수 있습니다 !"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_cic00002
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 485
integer y = 208
integer width = 2423
integer height = 1848
integer cornerheight = 40
integer cornerwidth = 55
end type

