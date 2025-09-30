$PBExportHeader$w_kgld90.srw
$PBExportComments$경리자료 복구처리
forward
global type w_kgld90 from w_inherite
end type
type cb_9 from commandbutton within w_kgld90
end type
type dw_ip from datawindow within w_kgld90
end type
type st_2 from statictext within w_kgld90
end type
type cbx_1 from checkbox within w_kgld90
end type
type cbx_2 from checkbox within w_kgld90
end type
type st_4 from statictext within w_kgld90
end type
type gb_1 from groupbox within w_kgld90
end type
type cbx_3 from checkbox within w_kgld90
end type
type cbx_4 from checkbox within w_kgld90
end type
end forward

global type w_kgld90 from w_inherite
string title = "경리자료 복구처리"
cb_9 cb_9
dw_ip dw_ip
st_2 st_2
cbx_1 cbx_1
cbx_2 cbx_2
st_4 st_4
gb_1 gb_1
cbx_3 cbx_3
cbx_4 cbx_4
end type
global w_kgld90 w_kgld90

type variables
String ls_saupj,ls_fyymm,ls_tyymm
Boolean cnt_flag =True
end variables

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetItem(dw_ip.GetRow(),"saupj",gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(),"sym",  String(today(),"yyyymm"))
dw_ip.SetItem(dw_ip.GetRow(),"eym",  String(today(),"yyyymm"))
dw_ip.SetColumn("acc_yy")
dw_ip.SetFocus()

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.Modify("saupj.protect = 1")
	dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_ip.Modify("saupj.protect = 0")
	dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")
END IF	

cbx_1.Checked = true
cbx_2.Checked = true



end event

on w_kgld90.create
int iCurrent
call super::create
this.cb_9=create cb_9
this.dw_ip=create dw_ip
this.st_2=create st_2
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.st_4=create st_4
this.gb_1=create gb_1
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_9
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.cbx_2
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.cbx_3
this.Control[iCurrent+9]=this.cbx_4
end on

on w_kgld90.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_9)
destroy(this.dw_ip)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.st_4)
destroy(this.gb_1)
destroy(this.cbx_3)
destroy(this.cbx_4)
end on

type dw_insert from w_inherite`dw_insert within w_kgld90
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kgld90
integer y = 1924
integer width = 320
integer taborder = 30
end type

type cb_mod from w_inherite`cb_mod within w_kgld90
boolean visible = false
integer x = 1403
integer y = 3040
integer width = 293
integer taborder = 0
end type

type cb_ins from w_inherite`cb_ins within w_kgld90
boolean visible = false
integer x = 1079
integer y = 3040
integer width = 293
integer taborder = 0
end type

on cb_ins::clicked;call w_inherite`cb_ins::clicked;//String ls_date, ls_saupj, ls_acc1_cd,ls_acc2_cd, ls_dcr_gu, &
//       ls_jun_yy, ls_jun_mm, ls_acc1_co, ls_acc2_co, ls_saup_no
//String mysql1, ls_accyear, ls_pro_gu
//Long ll_val_chk, ll_row, ll_junpyo_row, ll_gjmon_row, ll_cumon_row, ll_acc_yy, ll_acc_mm, msg_chk
//Double ldb_amt, ldb_dr_amt, ldb_cr_amt, ldb_drs_amt, ldb_crs_amt
//Long i, k
//String code[7], sav_acc1
//
//dw_1.AcceptText()
//ll_row = dw_1.GetRow()
//ll_val_chk = dw_1.Retrieve()
//ls_saupj = dw_1.GetItemString(ll_row, "ref_cd")
//ls_date = String(em_1.text)
//ll_val_chk = dateck4(ls_date)
//IF ll_val_chk = 0 then
//   MessageBox("확 인", "회계마감년월을 확인하십시오")
//   Return
//ELSE
//   ls_acc_yy = Left(ls_date, 4)
//   ls_acc_mm = Right(ls_date, 2)
//   ls_ym = Left(ls_date,4) + Right(ls_date,2)
//
//   ll_acc_yy = Integer(ls_acc_yy)
//   ll_acc_mm = Integer(ls_acc_mm)
//   IF ll_acc_mm = 12 then
//      ls_accyear = 'P'    //차년 회계년도
//   ELSE
//      ll_acc_mm = ll_acc_mm + 1
//      ls_accyear = 'C'    //당년 회계년도
//   END IF
//   if ll_acc_mm <= 10 then
//     ls_jun_yy = String(ll_acc_yy)
//     ls_jun_mm = '0' +  String(ll_acc_mm)
//   else
//     ls_jun_yy = String(ll_acc_yy)
//     ls_jun_mm = String(ll_acc_mm)
//   end if
//END IF
//
//ll_junpyo_row = dw_junpyo.Retrieve(ls_saupj, ls_acc_yy, ls_acc_mm)
//IF ll_junpyo_row < 1 then
//   msg_chk = MessageBox("확 인", "해당되는 전표가 없습니다.", Question!, RetryCancel!, 0)
//
//   IF msg_chk <> 1 then
//      Return
//   END IF
//   ls_pro_gu = 'H'          //전표발생계정의 월집계값으로 상위계정 집계처리 구분
//ELSE
//   ls_pro_gu = 'D'          //전표를 읽어서 상위계정 집계처리 구분 
//END IF
//
//Setpointer(hourglass!)
////기존 당월마감자료 초기화처리
//sle_1.Text =  '마감자료를 초기화하고 있습니다!!!'
//  UPDATE "KFZ14OT0"  
//     SET "DR_AMT" = 0,   
//         "CR_AMT" = 0  
//   WHERE ( "KFZ14OT0"."SAUPJ" = :ls_saupj ) AND  
//         ( "KFZ14OT0"."ACC_YY" = :ls_acc_yy ) AND  
//         ( "KFZ14OT0"."ACC_MM" = :ls_acc_mm )   
//  using sqlca ;
//  IF SQLCA.SQLCODE <> 0 and SQLCA.SQLCODE <> 100 Then
//     MessageBox("실패", " 계정월집계 초기화 실패")
//     Rollback USING SQLCA ;
//     Return
//  ELSE
//     COMMIT USING SQLCA ;
//  END IF
//
//////승인전표를 건별로 읽어서 집계테이블에 갱신처리함. 단,회계전표가 존재할 경우시 
//sle_1.Text =  '승인전표를 시산표집계처리 중입니다!!!'
//For i = 1 to ll_junpyo_row
//    ls_acc1_cd = dw_junpyo.GetItemString(i, "acc1_cd")
//    ls_acc2_cd = dw_junpyo.GetItemString(i, "acc2_cd")
//    ls_acc1_co = dw_junpyo.GetItemString(i, "acc1_cd")
//    ls_acc2_co = dw_junpyo.GetItemString(i, "acc2_cd")
//    ldb_amt    = dw_junpyo.GetItemDecimal(i, "amt")
//    ls_dcr_gu  = dw_junpyo.GetItemString(i, "dcr_gu")
//    //첫번째 계정과목 또는 계정과목1이 바뀔때 상위계정들을 배열에 move
//    if i = 1 or ls_acc1_cd <> sav_acc1 then 
//       for k = 1 to 7
//           setNull(code[k])
//       next
//       k = 0
//       sav_acc1 = ls_acc1_cd
//       Do until ls_acc1_co = "     " or Isnull(ls_acc1_co)  
//          k = k + 1
//          SELECT "SACC_CD"
//                INTO :mysql1
//                FROM "KFZ01OM0"
//                WHERE "ACC1_CD" = :ls_acc1_co and
//                      "ACC2_CD" = :ls_acc2_co USING SQLCA ;
//          IF SQLCA.SQLCODE = 0 THEN
//             ls_acc1_co = mysql1
//             ls_acc2_co = "  "
//             code[k] = ls_acc1_co
//          ELSE
//             SetNull(ls_acc1_co)
//             SetNull(ls_acc2_co)
//          END IF       
//       Loop
//    end if
//    //시산표 집계처리
//    ll_gjmon_row = dw_gjmon.Retrieve(ls_saupj, ls_acc_yy, ls_acc_mm, ls_acc1_cd, ls_acc2_cd)
//    IF ll_gjmon_row >= 1 then
//       ll_gjmon_row = dw_gjmon.GetRow()
//       ldb_dr_amt = dw_gjmon.GetItemDecimal(ll_gjmon_row, "dr_amt")
//       ldb_cr_amt = dw_gjmon.GetItemDecimal(ll_gjmon_row, "cr_amt")
//       IF ls_dcr_gu = '1' then
//          ldb_dr_amt = ldb_dr_amt + ldb_amt
//       ELSE
//          ldb_cr_amt = ldb_cr_amt + ldb_amt
//       END IF
//       dw_gjmon.SetItem(ll_gjmon_row, "cr_amt", ldb_cr_amt)
//       dw_gjmon.SetItem(ll_gjmon_row, "dr_amt", ldb_dr_amt)
//       dw_gjmon.AcceptText()
//       IF dw_gjmon.Update() <= 0 then
//          MessageBox("실패", "계정 월집계 수정실패")
//          Rollback USING SQLCA ;
//          Return
//       END IF
//    ELSE
//      dw_gjmon.Reset()
//      dw_gjmon.InsertRow(0)
//      ll_gjmon_row = dw_gjmon.GetRow()
//      ldb_dr_amt = 0
//      ldb_cr_amt = 0
//      ldb_drs_amt = 0
//      ldb_crs_amt = 0   
//      IF ls_dcr_gu = '1' THEN
//         ldb_dr_amt = ldb_amt
//      ELSE
//         ldb_cr_amt = ldb_amt
//      END IF
//      dw_gjmon.SetItem(ll_gjmon_row, "saupj", ls_saupj)
//      dw_gjmon.SetItem(ll_gjmon_row, "acc_yy", ls_acc_yy)
//      dw_gjmon.SetItem(ll_gjmon_row, "acc_mm", ls_acc_mm)
//      dw_gjmon.SetItem(ll_gjmon_row, "acc1_cd", ls_acc1_cd)
//      dw_gjmon.SetItem(ll_gjmon_row, "acc2_cd", ls_acc2_cd)    
//      dw_gjmon.SetItem(ll_gjmon_row, "dr_amt", ldb_dr_amt)
//      dw_gjmon.SetItem(ll_gjmon_row, "cr_amt", ldb_cr_amt)
//      dw_gjmon.SetItem(ll_gjmon_row, "drs_amt", ldb_drs_amt)
//      dw_gjmon.SetItem(ll_gjmon_row, "crs_amt", ldb_crs_amt)    
//      dw_gjmon.AcceptText()
//      IF dw_gjmon.Update() <= 0 then
//         MessageBox("실패", " 계정 월집계 입력실패")
//         Rollback USING SQLCA ;
//         Return
//      END IF
//    END IF
//    //상위계정으로 집계처리
//    k = 1
//    DO UNTIL code[k] = "     " or IsNull(code[k])
//      ls_acc1_cd = code[k]
//      ls_acc2_cd = "  "
//      ll_gjmon_row = dw_gjmon.Retrieve(ls_saupj, ls_acc_yy, ls_acc_mm, ls_acc1_cd, ls_acc2_cd)
//      IF ll_gjmon_row >= 1 then
//         ll_gjmon_row = dw_gjmon.GetRow()
//         ldb_dr_amt = dw_gjmon.GetItemDecimal(ll_gjmon_row, "dr_amt")
//         ldb_cr_amt = dw_gjmon.GetItemDecimal(ll_gjmon_row, "cr_amt")
//         IF ls_dcr_gu = '1' then
//           ldb_dr_amt = ldb_dr_amt + ldb_amt
//         ELSE
//           ldb_cr_amt = ldb_cr_amt + ldb_amt
//         END IF 
//         dw_gjmon.SetItem(ll_gjmon_row, "cr_amt", ldb_cr_amt) 
//         dw_gjmon.SetItem(ll_gjmon_row, "dr_amt", ldb_dr_amt) 
//         dw_gjmon.AcceptText()
//         IF dw_gjmon.Update() <= 0 then
//            MessageBox("실패", " 계정 월집계 수정실패")
//            Rollback USING SQLCA ;
//            Return
//         END IF    
//      ELSE   
//         dw_gjmon.Reset()
//         dw_gjmon.InsertRow(0)
//         ll_gjmon_row = dw_gjmon.GetRow()
//         ldb_dr_amt = 0
//         ldb_cr_amt = 0
//         ldb_drs_amt = 0
//         ldb_crs_amt = 0   
//         IF ls_dcr_gu = '1' then
//            ldb_dr_amt = ldb_amt
//         ELSE
//            ldb_cr_amt = ldb_amt
//         END IF 
//         dw_gjmon.SetItem(ll_gjmon_row, "saupj", ls_saupj)
//         dw_gjmon.SetItem(ll_gjmon_row, "acc_yy", ls_acc_yy)
//         dw_gjmon.SetItem(ll_gjmon_row, "acc_mm", ls_acc_mm)
//         dw_gjmon.SetItem(ll_gjmon_row, "acc1_cd", ls_acc1_cd)
//         dw_gjmon.SetItem(ll_gjmon_row, "acc2_cd", ls_acc2_cd)    
//         dw_gjmon.SetItem(ll_gjmon_row, "cr_amt", ldb_cr_amt) 
//         dw_gjmon.SetItem(ll_gjmon_row, "dr_amt", ldb_dr_amt)
//         dw_gjmon.AcceptText()
//         IF dw_gjmon.Update() <= 0 then
//            MessageBox("실패", " 계정 월집계 입력실패")
//            Rollback USING SQLCA ;
//            Return
//         END IF
//       END IF
//       k = k + 1
//    LOOP
//NEXT
//
//COMMIT USING SQLCA ;
//dw_gjmon.Reset()
//
////당월누계금액을 차월로 이월처리함	
//sle_1.Text =  '당월마감금액을 이월처리하고 있습니다!!!'
//ll_gjmon_row = dw_gjinz.Retrieve(ls_saupj, ls_acc_yy, ls_acc_mm)
//IF ll_gjmon_row >= 1 and ls_accyear ="C" then
//   For i = 1 To ll_gjmon_row
//       ls_acc1_cd  = dw_gjinz.GetItemString(i, "acc1_cd")
//       ls_acc2_cd  = dw_gjinz.GetItemString(i, "acc2_cd")
//       ldb_dr_amt  = dw_gjinz.GetItemDecimal(i, "dr_amt")
//       ldb_cr_amt  = dw_gjinz.GetItemDecimal(i, "cr_amt")
//       ldb_drs_amt = dw_gjinz.GetItemDecimal(i, "drs_amt")
//       ldb_crs_amt = dw_gjinz.GetItemDecimal(i, "crs_amt")
//       ldb_drs_amt = ldb_drs_amt + ldb_dr_amt
//       ldb_crs_amt = ldb_crs_amt + ldb_cr_amt  
//       ldb_dr_amt  = 0
//       ldb_cr_amt  = 0
//       dw_gjmon.Reset()
//       dw_gjmon.InsertRow(0)
//       ll_row = dw_gjmon.GetRow()
//       dw_gjmon.SetItem(ll_row, "saupj", ls_saupj)
//       dw_gjmon.SetItem(ll_row, "acc_yy", ls_jun_yy)
//       dw_gjmon.SetItem(ll_row, "acc_mm", ls_jun_mm)
//       dw_gjmon.SetItem(ll_row, "acc1_cd", ls_acc1_cd)
//       dw_gjmon.SetItem(ll_row,"acc2_cd", ls_acc2_cd)    
//       dw_gjmon.SetItem(ll_row,"dr_amt", ldb_dr_amt)
//       dw_gjmon.SetItem(ll_row,"cr_amt", ldb_cr_amt)
//       dw_gjmon.SetItem(ll_row,"drs_amt", ldb_drs_amt)
//       dw_gjmon.SetItem(ll_row,"crs_amt", ldb_crs_amt)    
//       dw_gjmon.AcceptText()
//       IF dw_gjmon.Update() <= 0 then
//          MessageBox("실패", "계정 당월누계금액 차월이월 처리 실패")
//          Rollback USING SQLCA ;
//          Return
//       END IF
//NEXT
//END IF
//COMMIT USING SQLCA ;
//dw_gjinz.Reset()
//
//sle_1.Text =  '시산표집계가 완료되었습니다!!!'
end on

type cb_del from w_inherite`cb_del within w_kgld90
boolean visible = false
integer x = 1728
integer y = 3040
integer width = 293
integer taborder = 0
end type

type cb_inq from w_inherite`cb_inq within w_kgld90
boolean visible = false
integer x = 2053
integer y = 3040
integer width = 293
integer taborder = 0
end type

type cb_print from w_inherite`cb_print within w_kgld90
integer x = 2368
integer y = 3044
integer width = 293
integer taborder = 0
end type

type st_1 from w_inherite`st_1 within w_kgld90
integer width = 338
end type

type cb_can from w_inherite`cb_can within w_kgld90
boolean visible = false
integer x = 1394
integer y = 2844
integer width = 293
integer taborder = 0
end type

on cb_can::clicked;call w_inherite`cb_can::clicked;//Int il_cursor_cnt
//String ls_acc1,ls_acc2,ls_sacc,ls_acc1_code,ls_acc2_code
//Double ldb_cha_amt,ldb_dai_amt,ldb_cha,ldb_dai
//
//DECLARE save_kfz14ot0 CURSOR FOR  
//	SELECT DISTINCT "KFZ14OT0"."ACC1_CD",   
//                   "KFZ14OT0"."ACC2_CD",
//						 "KFZ14OT0"."DR_AMT",
//						 "KFZ14OT0"."CR_AMT"  
//   FROM "KFZ14OT0"  
//   WHERE ( "KFZ14OT0"."SAUPJ" = :ls_saupj ) AND  
//         ( "KFZ14OT0"."ACC_YY" = :ls_yy ) AND  
//         ( "KFZ14OT0"."ACC_MM" = :ls_mm ) AND
//			( "KFZ14OT0"."ACC2_CD" <> '  ' ) 
//	ORDER BY "KFZ14OT0"."ACC1_CD" ASC,"KFZ14OT0"."ACC2_CD" ASC;
//
//OPEN save_kfz14ot0;
//il_cursor_cnt =1
//DO WHILE true
//	FETCH save_kfz14ot0 INTO :ls_acc1,
//									 :ls_acc2,
//									 :ldb_cha_amt,
//									 :ldb_dai_amt;
//
//	IF SQLCA.SQLCODE <> 0 THEN EXIT
//	SELECT "KFZ01OM0"."SACC_CD"
//		INTO :ls_sacc
//		FROM "KFZ01OM0"
//		WHERE "KFZ01OM0"."ACC1_CD" =:ls_acc1 AND "KFZ01OM0"."ACC2_CD" =:ls_acc2;
//	IF SQLCA.SQLCODE =0 THEN
//		ls_acc1_code =ls_sacc
//		ls_acc2_code ="  "
//	ELSE
//		SetNull(ls_acc1_code)
//		SetNull(ls_acc2_code)
//	END IF
//
//	SELECT "KFZ14OT0"."DR_AMT",   
//          "KFZ14OT0"."CR_AMT"  
//   	INTO :ldb_cha,   
//           :ldb_dai  
//      FROM "KFZ14OT0"  
//      WHERE ( "KFZ14OT0"."SAUPJ" = :ls_saupj ) AND  
//            ( "KFZ14OT0"."ACC_YY" = :ls_yy ) AND  
//            ( "KFZ14OT0"."ACC_MM" = :ls_mm ) AND  
//            ( "KFZ14OT0"."ACC1_CD" = :ls_acc1_code ) AND  
//            ( "KFZ14OT0"."ACC2_CD" = :ls_acc2_code )   ;
//	IF SQLCA.SQLCODE =0 THEN
//		ldb_cha_amt =ldb_cha_amt + ldb_cha
//		ldb_dai_amt =ldb_dai_amt + ldb_dai
//		UPDATE "KFZ14OT0"
//			SET "DR_AMT" =:ldb_cha_amt,
//				 "CR_AMT" =:ldb_dai_amt
//      	WHERE ( "KFZ14OT0"."SAUPJ" = :ls_saupj ) AND  
//            	( "KFZ14OT0"."ACC_YY" = :ls_yy ) AND  
//            	( "KFZ14OT0"."ACC_MM" = :ls_mm ) AND  
//            	( "KFZ14OT0"."ACC1_CD" = :ls_acc1_code ) AND  
//            	( "KFZ14OT0"."ACC2_CD" = :ls_acc2_code )   ;			
//	ELSE
//  		INSERT INTO "KFZ14OT0"  
//         		( "SAUPJ",   
//           		  "ACC_YY",   
//                 "ACC_MM",   
//                 "ACC1_CD",   
//                 "ACC2_CD",   
//                 "DR_AMT",   
//                 "CR_AMT" )  
//  		VALUES ( :ls_saupj,   
//               :ls_yy,   
//               :ls_mm,   
//               :ls_acc1_code,   
//               :ls_acc2_code,   
//               :ldb_cha_amt,   
//               :ldb_dai_amt )  ;
//	END IF
//	IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확인",String(il_cursor_cnt)+"에서 계정월집계 수정 실패.!!!")
//		ROLLBACK;
//		cnt_flag =False
//		Return
//	END IF
//	
//	il_cursor_cnt +=1
//LOOP
//cnt_flag =True
//COMMIT;
//CLOSE save_kfz14ot0;
//
//
end on

type cb_search from w_inherite`cb_search within w_kgld90
integer x = 1737
integer y = 2856
integer width = 425
integer taborder = 0
end type

type dw_datetime from w_inherite`dw_datetime within w_kgld90
integer x = 2853
integer width = 741
end type

type sle_msg from w_inherite`sle_msg within w_kgld90
integer x = 375
integer width = 2473
end type

type gb_10 from w_inherite`gb_10 within w_kgld90
integer width = 3602
end type

type gb_button1 from w_inherite`gb_button1 within w_kgld90
boolean visible = false
integer x = 1467
integer y = 2572
end type

type gb_button2 from w_inherite`gb_button2 within w_kgld90
integer x = 2802
integer y = 1876
integer width = 786
integer height = 184
end type

type cb_9 from commandbutton within w_kgld90
event ue_init_table pbm_custom01
integer x = 2862
integer y = 1924
integer width = 320
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "마감(&U)"
end type

event ue_init_table;////계정별 월집계 초기화//
//if cbx_1.Checked = True then
//  DELETE FROM "KFZ14OT0"  
//  WHERE ( "KFZ14OT0"."SAUPJ" = :ls_saupj ) AND  
//        ( "KFZ14OT0"."ACC_YY"||"KFZ14OT0"."ACC_MM" >= :ls_fyymm ) AND  
//        ( "KFZ14OT0"."ACC_YY"||"KFZ14OT0"."ACC_MM" <= :ls_tyymm ) ;  
//  IF SQLCA.SQLCODE <> 0 THEN
//	  MessageBox("확인","계정별 월집계 초기화 실패.!!!")
//	  ROLLBACK;
//  	  Return
//  ELSE
//	  COMMIT;
//  END IF
//end if
//
//if cbx_2.Checked = True then
//  DELETE FROM "KFZ13OT0"  
//  WHERE ( "KFZ13OT0"."SAUPJ" = :ls_saupj ) AND  
//        ( "KFZ13OT0"."ACC_YY"||"KFZ13OT0"."ACC_MM" >= :ls_fyymm ) AND  
//        ( "KFZ13OT0"."ACC_YY"||"KFZ13OT0"."ACC_MM" <= :ls_tyymm ) ;
//  IF SQLCA.SQLCODE <> 0 THEN
//	  MessageBox("확인","거래처별 월집계 초기화 실패.!!!")
//	  ROLLBACK;
//	  Return
//  ELSE
//	  COMMIT;
//  END IF
//end if
//
//
//
//
end event

event clicked;String   sgubun,sSaupj
long     ll_fmm, ll_tmm
Integer  iFrom,iTo,k

sle_msg.text =""

dw_ip.AcceptText()
sSaupj =dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
ls_fyymm =dw_ip.GetItemString(dw_ip.GetRow(),"sym")
ls_tyymm =dw_ip.GetItemString(dw_ip.GetRow(),"eym")
ll_fmm = long(mid(ls_fyymm,5,2))
ll_tmm = long(mid(ls_tyymm,5,2))

IF IsNull(sSaupj) OR sSaupj ="" THEN
	select min(to_number(rfgub)) 	into :iFrom from reffpf where rfcod = 'AD' and rfgub <> '99' and rfgub <> '00';

	select max(to_number(rfgub)) 	into :iTo from reffpf where rfcod = 'AD' and rfgub <> '99' and rfgub <> '00';
ELSE
	iFrom = Integer(sSaupj);			iTo = Integer(sSaupj);
END IF

IF IsNull(ls_fyymm) OR IsNull(ls_fyymm) THEN
	MessageBox("확인","회계년월을 입력하세요.!!!")
   dw_ip.Setcolumn("sym")
	dw_ip.SetFocus()
	Return
END IF
IF IsNull(ls_tyymm) OR IsNull(ls_tyymm) THEN
	MessageBox("확인","회계년월을 입력하세요.!!!")
   dw_ip.Setcolumn("eym")
	dw_ip.SetFocus()
	Return
END IF

IF ls_fyymm > ls_tyymm  THEN
	MessageBox("확인","회계년월 범위를 확인하십시오!")
   dw_ip.Setcolumn("sym")
	dw_ip.SetFocus()
	Return
END IF

if ll_fmm = 0 or ll_tmm = 0 then
	MessageBox("확인","기초 이월인 '00'으로는 입력할 수없습니다!")
   dw_ip.Setcolumn("sym")
	dw_ip.SetFocus()
	Return
end if

IF cbx_1.Checked =True AND cbx_2.Checked =False THEN
	sgubun ='G'	
ELSEIF cbx_1.Checked =False AND cbx_2.Checked =True THEN
	sgubun ='C'	
ELSEIF cbx_1.Checked =True AND cbx_2.Checked =True THEN
	sgubun ='A'
END IF

SetPointer(HourGlass!)

FOR k = iFrom TO iTo
	ls_saupj = String(k,'00')
	
	sle_msg.text = '['+f_Get_Refferance('AD',ls_saupj)+'] 집계 중...'
	
	IF f_acc_restore(sgubun,ls_saupj,ls_fyymm,ls_tyymm) <> 1 THEN
		MessageBox("확 인","경리 자료 복구 실패 !!")
		ROLLBACK;
		RETURN
	END IF	
NEXT

sle_msg.text =" 경리집계자료를 복구처리 하고 있습니다...!"
IF cbx_3.Checked =True  THEN
   if f_saup_restore(ls_fyymm,ls_tyymm,'CG') <> 1 THEN
	   MessageBox("확 인","원가부문별 자료 복구 실패 !!")
	   ROLLBACK;
	   RETURN
	end if
END IF

IF cbx_4.Checked =True  THEN
   if f_saup_restore(ls_fyymm,ls_tyymm,'CC') <> 1 THEN
	   MessageBox("확 인","원가부문별 거래처별 자료 복구 실패 !!")
	   ROLLBACK;
	   RETURN
	end if
END IF

SetPointer(Arrow!)
sle_msg.text =" 경리자료 복구처리를 완료하였습니다!!"

end event

type dw_ip from datawindow within w_kgld90
event ue_pressenter pbm_dwnprocessenter
integer x = 809
integer y = 696
integer width = 1102
integer height = 288
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgld90_ins"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

type st_2 from statictext within w_kgld90
integer x = 795
integer y = 484
integer width = 2043
integer height = 136
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 65535
long backcolor = 128
boolean enabled = false
string text = "경리자료 복구작업은 반복해서 작업할 수 있으며 계정 잔고 및 거래처잔고를 승인전표를 기준으로 재작성함."
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_kgld90
integer x = 1911
integer y = 676
integer width = 631
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
string text = "계정 월집계처리"
borderstyle borderstyle = stylelowered!
end type

type cbx_2 from checkbox within w_kgld90
integer x = 1911
integer y = 748
integer width = 631
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
string text = "거래처 월집계처리"
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_kgld90
integer x = 795
integer y = 380
integer width = 2043
integer height = 104
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16776960
long backcolor = 8388608
boolean enabled = false
string text = "경리 자료 복구 처리"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_kgld90
integer x = 795
integer y = 604
integer width = 2043
integer height = 412
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type cbx_3 from checkbox within w_kgld90
integer x = 1911
integer y = 820
integer width = 850
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
string text = "원가부문별 계정별 월집계처리"
borderstyle borderstyle = stylelowered!
end type

type cbx_4 from checkbox within w_kgld90
integer x = 1911
integer y = 896
integer width = 905
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "원가부문별 거래처별 월집계처리"
borderstyle borderstyle = stylelowered!
end type

