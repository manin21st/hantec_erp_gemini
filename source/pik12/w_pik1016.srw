$PBExportHeader$w_pik1016.srw
$PBExportComments$** 월마감작업(취소)
forward
global type w_pik1016 from w_inherite_multi
end type
type dw_cond from u_key_enter within w_pik1016
end type
end forward

global type w_pik1016 from w_inherite_multi
string title = "월마감작업"
dw_cond dw_cond
end type
global w_pik1016 w_pik1016

type variables

end variables

on w_pik1016.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
end on

on w_pik1016.destroy
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

dw_cond.SetItem(1,"myymm",Left(gs_today,6))

dw_cond.SetColumn("myymm")
dw_cond.SetFocus()



end event

type p_delrow from w_inherite_multi`p_delrow within w_pik1016
boolean visible = false
integer x = 896
integer y = 2832
end type

type p_addrow from w_inherite_multi`p_addrow within w_pik1016
boolean visible = false
integer x = 722
integer y = 2832
end type

type p_search from w_inherite_multi`p_search within w_pik1016
boolean visible = false
integer x = 27
integer y = 2832
end type

type p_ins from w_inherite_multi`p_ins within w_pik1016
boolean visible = false
integer x = 549
integer y = 2832
end type

type p_exit from w_inherite_multi`p_exit within w_pik1016
end type

type p_can from w_inherite_multi`p_can within w_pik1016
boolean visible = false
integer x = 1248
integer y = 2832
end type

type p_print from w_inherite_multi`p_print within w_pik1016
boolean visible = false
integer x = 201
integer y = 2832
end type

type p_inq from w_inherite_multi`p_inq within w_pik1016
boolean visible = false
integer x = 375
integer y = 2832
end type

type p_del from w_inherite_multi`p_del within w_pik1016
boolean visible = false
integer x = 1074
integer y = 2832
end type

type p_mod from w_inherite_multi`p_mod within w_pik1016
integer x = 4219
end type

event p_mod::clicked;call super::clicked;////// 월마감작업

Int    il_meterPosition,k,il_SearchRow,il_RetrieveRow,il_CurRow,syday,sbday,il_RowCount

String sEmpNo,sgubn,sdeptcode, syymm, yymm,  ls_gubn, sSaup

dw_cond.AcceptText()
yymm = trim(dw_cond.GetItemString(1,"myymm"))
sgubn = dw_cond.GetItemString(1,"gubn")
sSaup = dw_cond.GetItemString(1,"saupcd")

SetPointer(HourGlass!)	

  SELECT "P4_MFLAG"."GUBN"  
    INTO :ls_gubn  
    FROM "P4_MFLAG"  
   WHERE ( "P4_MFLAG"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_MFLAG"."MYYMM" = :yymm ) AND
			( "P4_MFLAG"."SAUPCD" LIKE :sSaup );
	
	IF ls_gubn = sgubn THEN
		SetPointer(Arrow!)
      sle_msg.text =''
		if sgubn = '1' then //마감작업
			MessageBox("확 인","이미 마감이 완료된 월입니다!!")	
		else
			MessageBox("확 인","이미 마감취소가 완료된 월입니다!!")	
		end if	
		return
	END IF
	
	IF SQLCA.SQLCODE = 0 THEN
	  UPDATE "P4_MFLAG"  
        SET "GUBN" = :sgubn  
      WHERE ( "P4_MFLAG"."COMPANYCODE" = :gs_company ) AND  
            ( "P4_MFLAG"."MYYMM" = :yymm ) AND
				( "P4_MFLAG"."SAUPCD" LIKE :sSaup );
		IF SQLCA.SQLCODE <> 0 THEN
			if sgubn = '1' then //마감작업
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
		  INSERT INTO "P4_MFLAG"  ( "COMPANYCODE",  "MYYMM",   "GUBN",	 "SAUPCD" )  
 			 					VALUES  ( :gs_company,    :yymm ,    :sgubn,	 :sSaup   )  ;
	  		IF SQLCA.SQLCODE <> 0 THEN
				if sgubn = '1' then //마감작업
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
	if sgubn = '1' then //마감작업
	   w_mdi_frame.sle_msg.text ='월마감작업 완료!!'
	else	
	   w_mdi_frame.sle_msg.text ='월마감 취소 작업 완료!!'
	end if	
end event

type dw_insert from w_inherite_multi`dw_insert within w_pik1016
boolean visible = false
integer x = 1463
integer y = 2780
end type

type st_window from w_inherite_multi`st_window within w_pik1016
boolean visible = false
integer x = 2181
integer y = 3036
end type

type cb_append from w_inherite_multi`cb_append within w_pik1016
boolean visible = false
integer x = 2821
integer y = 2844
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pik1016
boolean visible = false
integer x = 4009
integer y = 2840
integer taborder = 50
end type

type cb_update from w_inherite_multi`cb_update within w_pik1016
boolean visible = false
integer x = 3625
integer y = 2844
end type

event cb_update::clicked;call super::clicked;////// 월마감작업

Int    il_meterPosition,k,il_SearchRow,il_RetrieveRow,il_CurRow,syday,sbday,il_RowCount

String sEmpNo,sgubn,sdeptcode, syymm, yymm,  ls_gubn

dw_cond.AcceptText()
yymm = trim(dw_cond.GetItemString(1,"myymm"))
sgubn = dw_cond.GetItemString(1,"gubn")

dw_cond.AcceptText()
//dw_cond.retrieve(gs_company, yymm)
SetPointer(HourGlass!)	

  SELECT "P4_MFLAG"."GUBN"  
    INTO :ls_gubn  
    FROM "P4_MFLAG"  
   WHERE ( "P4_MFLAG"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_MFLAG"."MYYMM" = :yymm )   ;
	
	IF ls_gubn = sgubn THEN
		SetPointer(Arrow!)
      sle_msg.text =''
		if sgubn = '1' then //마감작업
			MessageBox("확 인","이미 마감이 완료된 월입니다!!")	
		else
			MessageBox("확 인","이미 마감취소가 완료된 월입니다!!")	
		end if	
		return
	END IF
	
	IF SQLCA.SQLCODE = 0 THEN
	  UPDATE "P4_MFLAG"  
        SET "GUBN" = :sgubn  
      WHERE ( "P4_MFLAG"."COMPANYCODE" = :gs_company ) AND  
            ( "P4_MFLAG"."MYYMM" = :yymm )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			if sgubn = '1' then //마감작업
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
		  INSERT INTO "P4_MFLAG"  ( "COMPANYCODE",  "MYYMM",   "GUBN" )  
 			 VALUES ( :gs_company,    :yymm ,   :sgubn )  ;
	  		IF SQLCA.SQLCODE <> 0 THEN
				if sgubn = '1' then //마감작업
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
	if sgubn = '1' then //마감작업
	   sle_msg.text ='월마감작업 완료!!'
	else	
	   sle_msg.text ='월마감 취소 작업 완료!!'
	end if	
end event

type cb_insert from w_inherite_multi`cb_insert within w_pik1016
boolean visible = false
integer x = 3186
integer y = 2844
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pik1016
boolean visible = false
integer x = 2066
integer y = 2856
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pik1016
boolean visible = false
integer x = 2441
integer y = 2848
integer taborder = 20
end type

type st_1 from w_inherite_multi`st_1 within w_pik1016
boolean visible = false
integer x = 18
integer y = 3036
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pik1016
boolean visible = false
integer x = 1728
integer y = 2860
integer taborder = 40
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pik1016
boolean visible = false
integer x = 2830
integer y = 3036
end type

type sle_msg from w_inherite_multi`sle_msg within w_pik1016
boolean visible = false
integer x = 347
integer y = 3036
end type

type gb_2 from w_inherite_multi`gb_2 within w_pik1016
boolean visible = false
integer x = 3566
integer y = 2784
integer width = 837
end type

type gb_1 from w_inherite_multi`gb_1 within w_pik1016
boolean visible = false
integer x = 2409
integer y = 2784
end type

type gb_10 from w_inherite_multi`gb_10 within w_pik1016
boolean visible = false
integer x = 0
integer y = 2984
end type

type dw_cond from u_key_enter within w_pik1016
integer x = 1449
integer y = 744
integer width = 1627
integer height = 580
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pik1016_1"
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

