$PBExportHeader$w_pip1020.srw
$PBExportComments$** 급여 변동금액항목별등록
forward
global type w_pip1020 from w_inherite_multi
end type
type gb_3 from groupbox within w_pip1020
end type
type rb_pstag1 from radiobutton within w_pip1020
end type
type rb_pstag2 from radiobutton within w_pip1020
end type
type dw_main from u_d_select_sort within w_pip1020
end type
type rr_1 from roundrectangle within w_pip1020
end type
type p_1 from uo_picture within w_pip1020
end type
type dw_empinfo from datawindow within w_pip1020
end type
type dw_saup from datawindow within w_pip1020
end type
type dw_up from datawindow within w_pip1020
end type
type st_2 from statictext within w_pip1020
end type
end forward

global type w_pip1020 from w_inherite_multi
string title = "변동자료항목별 등록"
gb_3 gb_3
rb_pstag1 rb_pstag1
rb_pstag2 rb_pstag2
dw_main dw_main
rr_1 rr_1
p_1 p_1
dw_empinfo dw_empinfo
dw_saup dw_saup
dw_up dw_up
st_2 st_2
end type
global w_pip1020 w_pip1020

type variables
String iv_pbtag,iv_pstag , sDate,iv_dept,iv_level,iv_code
Boolean EditCheck
Boolean RowCheck
end variables

forward prototypes
public function integer wf_required_check (integer ll_row)
public function integer wf_allowcode ()
end prototypes

public function integer wf_required_check (integer ll_row);
String scode
Double damount

dw_main.AcceptText()
scode   = dw_main.GetItemString(ll_row,"allowcode")
damount = dw_main.GetItemNumber(ll_row,"allowamt") 

IF scode ="" OR IsNull(scode) THEN
	MessageBox("확 인","수당을 입력하세요!!")
	dw_main.SetColumn("allowcode")
	dw_main.Setfocus()
	Return -1
END IF

IF damount = 0 OR IsNull(damount) THEN
	MessageBox("확 인","금액을 입력하세요!!")
	dw_main.SetColumn("allowamt")
	dw_main.SetFocus()
	Return -1
END IF

Return 1
end function

public function integer wf_allowcode ();String sCode
Long sCount

dw_empinfo.AcceptText()

sCode = dw_empinfo.GetItemString(1,"allowcode")

IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당항목을 입력하세요")
	dw_empinfo.SetColumn("allowcode")
	dw_empinfo.SetFocus()
	Return -1
END IF
IF rb_pstag1.Checked = True THEN
	  SELECT COUNT(*)
      INTO :sCount  
      FROM "P3_ALLOWANCE" 
	  WHERE "P3_ALLOWANCE"."PAYSUBTAG" ='1'AND
	        "P3_ALLOWANCE"."ALLOWCODE" = :sCode ;
	  
	  IF sCount = 0 THEN
		  MessageBox("수당확인","수당항목을 확인하세요")
		  dw_empinfo.SetColumn("allowcode")
		  dw_empinfo.SetFocus()
		  Return -1
	  END IF
ELSEIF rb_pstag2.Checked = True THEN
	 SELECT COUNT(*)
      INTO :sCount  
      FROM "P3_ALLOWANCE" 
	  WHERE "P3_ALLOWANCE"."PAYSUBTAG" ='2' AND
	        "P3_ALLOWANCE"."ALLOWCODE" =:sCode ;
	  
	  IF sCount = 0 THEN
		  MessageBox("수당확인","수당항목을 확인하세요")
		  dw_empinfo.SetColumn("allowcode")
		  dw_empinfo.SetFocus()
		  Return -1
	  END IF
END IF	

Return 1
end function

on w_pip1020.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.rb_pstag1=create rb_pstag1
this.rb_pstag2=create rb_pstag2
this.dw_main=create dw_main
this.rr_1=create rr_1
this.p_1=create p_1
this.dw_empinfo=create dw_empinfo
this.dw_saup=create dw_saup
this.dw_up=create dw_up
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.rb_pstag1
this.Control[iCurrent+3]=this.rb_pstag2
this.Control[iCurrent+4]=this.dw_main
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.dw_empinfo
this.Control[iCurrent+8]=this.dw_saup
this.Control[iCurrent+9]=this.dw_up
this.Control[iCurrent+10]=this.st_2
end on

on w_pip1020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.rb_pstag1)
destroy(this.rb_pstag2)
destroy(this.dw_main)
destroy(this.rr_1)
destroy(this.p_1)
destroy(this.dw_empinfo)
destroy(this.dw_saup)
destroy(this.dw_up)
destroy(this.st_2)
end on

event open;call super::open;dw_empinfo.SetTransObject(SQLCA)      //사원정보
if dw_empinfo.Retrieve() < 1 then
	dw_empinfo.InsertRow(0)
end if
dw_main.SetTransObject(SQLCA)
dw_main.Reset()

dw_saup.SetTransObject(sqlca)
dw_saup.InsertRow(0)

dw_up.SetTransObject(sqlca)
/*사업장 정보 셋팅*/
f_set_saupcd(dw_saup,'sabu','1')
is_saupcd = gs_saupcd

dw_empinfo.SetItem(1,"sDate",f_aftermonth(left(f_today(),6),-1))
dw_empinfo.SetItem(1,"PAYGUBN","P")
dw_empinfo.SetItem(1,"jikjong0", "0")
dw_empinfo.SetItem(1,"jikjong1", "1")
dw_empinfo.SetItem(1,"jikjong2", "2")
dw_empinfo.SetItem(1,"kunmu0", "10")
p_mod.enabled=false
p_mod.Picturename = "C:\erpman\image\저장_d.gif"
EditCheck = True

DataWindowChild state_child
	
dw_empinfo.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset()			

IF state_child.Retrieve('2','P') <= 0 THEN
	Return 1
END IF
  
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1020
boolean visible = false
integer x = 2606
integer y = 3188
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1020
boolean visible = false
integer x = 3593
integer y = 2388
end type

event p_addrow::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue = 1
ELSE
	il_functionvalue = wf_required_check(dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow 
	
	dw_main.InsertRow(il_currow)
	dw_main.SetItem(il_currow,"companycode",gs_company)	
	dw_main.SetItem(il_currow,"empno",&
	dw_empinfo.GetItemString(dw_empinfo.GetRow(),"empno"))
	dw_main.SetItem(il_currow,"pbtag",iv_pbtag)	
	dw_main.SetItem(il_currow,"gubun",iv_pstag)	
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("allowcode")
	dw_main.SetFocus()
	
	
END IF

end event

type p_search from w_inherite_multi`p_search within w_pip1020
boolean visible = false
integer x = 2258
integer y = 3044
end type

type p_ins from w_inherite_multi`p_ins within w_pip1020
boolean visible = false
integer x = 2807
integer y = 3016
end type

type p_exit from w_inherite_multi`p_exit within w_pip1020
integer x = 4416
integer y = 28
end type

event p_exit::clicked;call super::clicked;//w_mdi_frame.sle_msg.text =""
//
//IF EditCheck = false THEN
//	IF  MessageBox("확인", "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
//		 question!, yesno!) = 2 THEN
//       close(parent)	   	 
//	    
//   END IF
//ELSE
//   close(parent)	   	 
//  
//END IF	
//
//
end event

type p_can from w_inherite_multi`p_can within w_pip1020
integer x = 4242
integer y = 28
end type

event p_can::clicked;call super::clicked;String SetNull
w_mdi_frame.sle_msg.text = ''

EditCheck = True

dw_empinfo.SetItem(1,"allowamt",0)
dw_empinfo.SetItem(1,"deptcode",SetNull)
dw_empinfo.SetItem(1,"deptname",SetNull)
dw_empinfo.SetItem(1,"levelcode",SetNull)
dw_main.Reset()
end event

type p_print from w_inherite_multi`p_print within w_pip1020
boolean visible = false
integer x = 2432
integer y = 3044
end type

type p_inq from w_inherite_multi`p_inq within w_pip1020
integer x = 3721
integer y = 28
end type

event p_inq::clicked;call super::clicked;String sempno,sYear,sCode ,Pbtag,Gubn
String sDeptCode,sLevelCode, ls_saup
String sJikjong0, sJikjong1, sJikjong2 ,sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3

dw_empinfo.AcceptText()
dw_main.Reset()
dw_saup.AcceptText()

sYear = dw_empinfo.GetItemString(1,"sDate") 
sCode = dw_empinfo.GetItemString(1,"allowcode")
sDeptCode  = dw_empinfo.GetItemString(1,"deptcode")
sLevelCode = dw_empinfo.GetItemString(1,"levelcode") 
Pbtag      = dw_empinfo.GetItemString(1,"paygubn")
ls_saup			= dw_saup.GetItemString(1,"sabu")

sJikjong0  = dw_empinfo.GetItemString(1,"jikjong0")		// 임원 : 0
sJikjong1  = dw_empinfo.GetItemString(1,"jikjong1")		// 관리직 : 1
sJikjong2  = dw_empinfo.GetItemString(1,"jikjong2")		// 생산직 : 2
sJikjong3  = dw_empinfo.GetItemString(1,"jikjong3")		// 용역 : 3
sKunmu0  = dw_empinfo.GetItemString(1,"kunmu0")		// 정직원 : 10		
sKunmu1  = dw_empinfo.GetItemString(1,"kunmu1")		// 파견직 : 20
sKunmu2  = dw_empinfo.GetItemString(1,"kunmu2")		// 계약직 : 30
sKunmu3  = dw_empinfo.GetItemString(1,"kunmu3")		// 용역 : 40

IF ls_saup = '' OR IsNull(ls_saup) THEN ls_saup = '%'
				 
IF sYear = '' OR ISNULL(sYear) THEN
	MessageBox("확인","적용년월을 입력하세요")
	dw_empinfo.SetColumn("sDate")
	dw_empinfo.SetFocus()
	Return
ELSE
	IF F_DATECHK(sYear+"01") =-1 THEN
		MessageBox("확인","적용년월을 확인하세요")
		dw_empinfo.SetColumn("sDate")
	   dw_empinfo.SetFocus()
		Return
	END IF	
END IF	
IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당항목을 입력하세요")
	dw_empinfo.SetColumn("allowcode")
	dw_empinfo.SetFocus()
	Return
END IF	

IF sDeptCode = '' OR ISNULL(sDeptCode) THEN
	sDeptCode = '%'
END IF	
IF sLevelCode = '' OR ISNULL(sLevelCode) THEN
	sLevelCode = '%'
END IF	

IF Pbtag = '' OR ISNULL(Pbtag) THEN
	MessageBox("확인","급여구분을 입력하세요")
	dw_empinfo.SetColumn("paygubn")
	dw_empinfo.SetFocus()
	Return
END IF	


/*지급,공제 구분*/
IF rb_pstag1.Checked = True THEN
	Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN
	Gubn = '2'
END IF	

/*날짜->'9999.99.99' 로 바꿈->해당년월의 마지막 일자 가져옴*/
//sYear = F_LAST_DATE(sYear)

IF dw_main.retrieve(gs_company,Pbtag,Gubn,sCode,sYear,sDeptCode,sLevelCode,ls_saup,sJikjong0,sJikjong1,sJikjong2,sJikjong3,sKunmu0,sKunmu1,sKunmu2,sKunmu3)  <= 0 then
	MessageBox("확인","조회된 자료가 없습니다")
	RowCheck = False
	p_mod.enabled=false
   p_mod.Picturename = "C:\erpman\image\저장_d.gif"
	Return
ELSE
	dw_main.ScrollToRow(dw_main.RowCount())
END IF
dw_main.SetRedraw(True)
RowCheck = True
p_mod.enabled=True
p_mod.Picturename = "C:\erpman\image\저장_up.gif"




end event

type p_del from w_inherite_multi`p_del within w_pip1020
boolean visible = false
integer x = 4114
integer y = 2388
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
		dw_main.SetColumn("allowcode")
		dw_main.SetFocus()
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite_multi`p_mod within w_pip1020
integer x = 4069
integer y = 28
end type

event p_mod::clicked;call super::clicked;Int K 
String sEmpno,Pbtag,Gubn ,gAllowCode,sYm 
Long sAmt,sCount

dw_empinfo.AcceptText()
Pbtag = dw_empinfo.GetItemString(1,"paygubn")
sYm   = dw_empinfo.GetItemString(1,"sdate")
gAllowCode = dw_empinfo.GetItemString(1,"allowcode")
 
IF dw_main.Accepttext() = -1 THEN 	RETURN
   IF sYm = '' OR ISNULL(sYm) THEN
		MessageBox("확인","년월을 입력하세요")
		dw_empinfo.SetColumn("sdate")
		dw_empinfo.SetFocus()
	END IF 
	IF gAllowCode = '' OR ISNULL(gAllowCode) THEN
		MessageBox("확인","수당을 입력하세요")
		dw_empinfo.SetColumn("allowcode")
		dw_empinfo.SetFocus()
	END IF	
	
///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
     /*급여,상여 구분*/ 

	   /*지급,공제 구분*/
	  IF rb_pstag1.Checked = True THEN
		  Gubn = '1'
	  ELSEIF rb_pstag2.Checked = True THEN
		  Gubn = '2'
	  END IF	
  SetPointer(HourGlass!)
  
    FOR  K = 1  TO dw_main.RowCount()	
		 
		   sAmt = dw_main.GetItemNumber(K,"amt")
			sEmpno = dw_main.GetItemString(K,"empno")
	  	IF sAmt <> 0 THEN
	       
			  SELECT COUNT(*)  
             INTO :sCount  
				 FROM "P3_MONTHCHGDATA"  
				 WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company) AND  
                   ( "P3_MONTHCHGDATA"."WORKYM" =:sYm) AND      				      
						 ( "P3_MONTHCHGDATA"."EMPNO" =:sEmpno ) AND 
						 ( "P3_MONTHCHGDATA"."PBTAG" =:Pbtag) AND  
						 ( "P3_MONTHCHGDATA"."ALLOWCODE" =:gAllowCode) AND
					    ( "P3_MONTHCHGDATA"."GUBUN" =:Gubn ) ;
				 IF sCount = 0 THEN
					  INSERT INTO "P3_MONTHCHGDATA"  
    						     ( "COMPANYCODE",  "WORKYM",   "EMPNO",  "PBTAG",   
                            "ALLOWCODE",    "ALLOWAMT", "GUBUN" )   
								 
	              VALUES ( :gs_company,      :sYm,      :sEmpno,  :Pbtag,   
	                       :gAllowCode,      :sAmt,     :Gubn )  ;        
						IF SQLCA.SQLCODE = 0 THEN
							COMMIT ;
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
							EXIT
						END IF	
				ELSE
					  UPDATE "P3_MONTHCHGDATA"  
						  SET "ALLOWAMT" =:sAmt  
						WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company) AND  
                        ( "P3_MONTHCHGDATA"."WORKYM" =:sYm) AND      				      
						      ( "P3_MONTHCHGDATA"."EMPNO" =:sEmpno ) AND 
						      ( "P3_MONTHCHGDATA"."PBTAG" =:Pbtag) AND  
						      ( "P3_MONTHCHGDATA"."ALLOWCODE" =:gAllowCode) AND
					         ( "P3_MONTHCHGDATA"."GUBUN" =:Gubn ) ;
					   IF SQLCA.SQLCODE = 0 THEN
							COMMIT ;
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
							EXIT
						END IF					 
               	
				END IF
			ELSEIF ISNULL(sAmt) OR sAmt = 0 THEN 
			      DELETE FROM "P3_MONTHCHGDATA"  
					WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company) AND  
                     ( "P3_MONTHCHGDATA"."WORKYM" =:sYm) AND      				      
						   ( "P3_MONTHCHGDATA"."EMPNO" =:sEmpno ) AND 
						   ( "P3_MONTHCHGDATA"."PBTAG" =:Pbtag) AND  
						   ( "P3_MONTHCHGDATA"."ALLOWCODE" =:gAllowCode) AND
					      ( "P3_MONTHCHGDATA"."GUBUN" =:Gubn ) ; 
				   IF SQLCA.SQLCODE = 0 THEN
						COMMIT ;
					ELSE
						ROLLBACK ;
						w_mdi_frame.sle_msg.text ="자료 저장실패!!"
						SetPointer(Arrow!)
						EXIT
					END IF	
		   END IF   
    NEXT

	w_mdi_frame.sle_msg.text ="자료 저장완료!!"
	EditCheck = True
   SetPointer(Arrow!)
end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1020
boolean visible = false
integer x = 101
integer y = 2560
end type

type st_window from w_inherite_multi`st_window within w_pip1020
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip1020
string tag = "TCODE~" =~' ~' "
boolean visible = false
integer x = 1221
integer y = 2720
integer taborder = 0
string dragicon = "~' ~' "
string text = "생성(&L)"
end type

event cb_append::clicked;call super::clicked;Long  K,sAmt,sCount
String Pbtag,Gubn,sCode,sYm

dw_main.SetRedraw(False)
dw_empinfo.AcceptText()

Pbtag = dw_empinfo.GetItemString(1,"paygubn")
sCode = dw_empinfo.GetItemString(1,"allowcode")
sAmt  = dw_empinfo.GetItemNumber(1,"allowamt")
sYm   = dw_empinfo.GetItemString(1,"sdate")
		  
/*지급,공제 구분*/
IF rb_pstag1.Checked = True THEN
	Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN
	Gubn = '2'
END IF	
IF sYm = '' OR ISNULL(sYm) THEN
	MessageBox("확인","적용년월을 입력하세요")
	dw_empinfo.SetColumn("sdate")
	dw_empinfo.SetFocus()
	Return
END IF	


IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당항목을 입력하세요")
	dw_empinfo.SetColumn("allowcode")
	dw_empinfo.SetFocus()
	Return
END IF	

IF sAmt = 0 OR ISNULL(sAmt) THEN
	MessageBox("확인","금액을 입력하세요")
	dw_empinfo.SetColumn("allowamt")
	dw_empinfo.SetFocus()
	Return
END IF	


   SELECT COUNT(*)  
    INTO :sCount  
    FROM "P3_MONTHCHGDATA"
   WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" =:gs_company ) AND 
	      ( "P3_MONTHCHGDATA"."WORKYM"      =:sYm ) AND 
	      ( "P3_MONTHCHGDATA"."PBTAG"       =:Pbtag ) AND  
         ( "P3_MONTHCHGDATA"."ALLOWCODE"   =:sCode) AND
			( "P3_MONTHCHGDATA"."GUBUN"       =:Gubn )  ;
			
   IF sCount >= 1 THEN
	  IF MessageBox("확인","기존에 자료가 존재합니다. ~r 다시 생성하시겠습니까?",Question!,YesNO!) = 2 THEN
		  RETURN
	  END IF	
   END IF 
	
	
cb_retrieve.Triggerevent(clicked!)	
/*데이타 존재유무 체크->저장버튼 활성,비활성*/
IF RowCheck = False THEN
	Return
END IF

FOR  K = 1 TO dw_main.RowCount()
    dw_main.SetITem(K,"amt",sAmt)
NEXT

dw_main.SetRedraw(True)
cb_update.Enabled = True
end event

type cb_exit from w_inherite_multi`cb_exit within w_pip1020
boolean visible = false
integer x = 2647
integer y = 2636
integer taborder = 60
end type

type cb_update from w_inherite_multi`cb_update within w_pip1020
boolean visible = false
integer x = 1915
integer y = 2636
integer taborder = 40
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1020
boolean visible = false
integer x = 955
integer y = 2572
integer width = 302
integer height = 120
integer taborder = 0
end type

event cb_insert::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue = 1
ELSE
	il_functionvalue = wf_required_check(dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow 
	
	dw_main.InsertRow(il_currow)
	dw_main.SetItem(il_currow,"companycode",gs_company)	
	dw_main.SetItem(il_currow,"empno",&
					dw_empinfo.GetItemString(dw_empinfo.GetRow(),"empno"))
	dw_main.SetItem(il_currow,"pbtag",iv_pbtag)	
	dw_main.SetItem(il_currow,"gubun",iv_pstag)	
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("allowcode")
	dw_main.SetFocus()
	
	
END IF

end event

type cb_delete from w_inherite_multi`cb_delete within w_pip1020
boolean visible = false
integer x = 1344
integer y = 2572
integer width = 302
integer height = 120
integer taborder = 0
end type

event cb_delete::clicked;call super::clicked;Int il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
		dw_main.SetColumn("allowcode")
		dw_main.SetFocus()
	END IF
	ib_any_typing =False
	sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1020
boolean visible = false
integer x = 407
integer y = 2636
integer taborder = 30
end type

type st_1 from w_inherite_multi`st_1 within w_pip1020
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1020
boolean visible = false
integer x = 2281
integer y = 2636
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1020
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1020
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1020
boolean visible = false
integer x = 1902
integer width = 1152
integer height = 176
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1020
boolean visible = false
integer x = 407
integer width = 402
integer height = 176
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1020
boolean visible = false
end type

type gb_3 from groupbox within w_pip1020
integer x = 2679
integer y = 248
integer width = 750
integer height = 120
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
end type

type rb_pstag1 from radiobutton within w_pip1020
event clicked pbm_bnclicked
integer x = 2757
integer y = 296
integer width = 283
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "지 급"
boolean checked = true
end type

event clicked;String Pbtag
DataWindowChild state_child

dw_empinfo.AcceptText()
w_mdi_frame.SLE_MSG.TEXT =""

//IF EditCheck = False THEN
//	IF  MessageBox("확인", "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
//		 question!, yesno!) = 2 THEN
//       Return
//	END IF
//END IF

Pbtag = dw_empinfo.GetItemString(1,"paygubn")
dw_main.Reset()

dw_empinfo.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset()

IF state_child.Retrieve("1",Pbtag) <= 0 THEN
	Return 1
END IF	

end event

type rb_pstag2 from radiobutton within w_pip1020
event clicked pbm_bnclicked
integer x = 3077
integer y = 296
integer width = 283
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "공 제"
end type

event clicked;String Pbtag
DataWindowChild state_child

dw_empinfo.AcceptText()
//IF EditCheck = False THEN
//	IF  MessageBox("확인", "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
//		 question!, yesno!) = 2 THEN
//       Return
//	END IF
//END IF

Pbtag = dw_empinfo.GetItemString(1,"paygubn")
dw_main.Reset()

dw_empinfo.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset()

IF state_child.Retrieve("2",Pbtag) <= 0 THEN
	Return 1
END IF	
end event

type dw_main from u_d_select_sort within w_pip1020
integer x = 965
integer y = 420
integer width = 2537
integer height = 1808
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pip1020_100"
boolean border = false
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

event rowfocuschanged;call super::rowfocuschanged;If CurrentRow <= 0 then
	dw_main.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(CurrentRow,TRUE)
	b_flag = False
END IF
end event

type rr_1 from roundrectangle within w_pip1020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 946
integer y = 412
integer width = 2587
integer height = 1824
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_1 from uo_picture within w_pip1020
integer x = 3895
integer y = 28
integer width = 178
boolean bringtotop = true
string picturename = "C:\Erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;Long  K,sAmt,sCount
String sPbtag,Gubn,sCode,sYm, syyyy, smm,sname
string ls_itnbr, usechk, ls_ittyp
int ret

oleobject xlapp

dw_main.SetRedraw(False)
dw_empinfo.AcceptText()

sPbtag = dw_empinfo.GetItemString(1,"paygubn")
sCode = dw_empinfo.GetItemString(1,"allowcode")
sYm   = dw_empinfo.GetItemString(1,"sdate")
syyyy = left(sym,4)
smm =   right(sym,2)
		  
/*지급,공제 구분*/
IF rb_pstag1.Checked = True THEN
	Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN
	Gubn = '2'
END IF	
IF sYm = '' OR ISNULL(sYm) THEN
	MessageBox("확인","적용년월을 입력하세요")
	dw_empinfo.SetColumn("sdate")
	dw_empinfo.SetFocus()
	Return
END IF	


IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당항목을 입력하세요")
	dw_empinfo.SetColumn("allowcode")
	dw_empinfo.SetFocus()
	Return
END IF	

String ls_file_name, file_name, ls_file_name1, stext, ls_save_file, ls_path , ls_filename , ls_oledata , ls_conv_name,txtname
Integer li_rtn , li_FileNum , Result , li_rv , a, cnt
Long ll_import , ll_xls , ll_file_len

w_mdi_frame.sle_msg.text = ""


sname = Trim(dw_empinfo.Describe("Evaluate('LookUpDisplay(allowcode)',1)"))

//li_rv = GetFileOpenName('Select File to open' , ls_path, ls_filename, 'DOC', &
//'Excel Files (*.xls), *.xls, ' + 'All Files (*.*), *.*')
//
//
//if li_rv <> 1 then
//messagebox('알림', '선택한 파일이 없습니다....!!!')
//Return -1
//end if 
//--------------------------------------------------------------------- 

if Messagebox("확인",syyyy+'년 '+smm+'월 '+sname+' 변동자료를 생성하시겠습니까?', Question!, YesNo!) = 2 then return

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "생성 중.................!!"

//stext = ls_path	
//
//a = pos(stext,'.')
//stext = left(stext,a - 1)
//
//OleObject oleExcel 
//
//oleExcel = Create OleObject 
//li_rtn = oleExcel.connecttonewobject("excel.application") 
//
//if li_rtn = 0 then
//oleExcel.WorkBooks.Open(ls_path) 
//else
//Messagebox("!", "실패") 
//Destroy oleExcel 
//Return -1
//end if
//oleExcel.Application.Visible = False 
//
//ll_xls = pos(ls_path, 'xls')
//ls_save_file = stext + '.txt'
//oleExcel.application.workbooks(1).SaveAs(ls_save_file, -4158) 
//
//oleExcel.application.workbooks(1).Saved = True 
//oleExcel.Application.Quit 
//oleExcel.DisConnectObject() 
//Destroy oleExcel
//
//delete from p3_monthchgamt;
//commit;
//
//ll_import = dw_up.ImportFile(ls_save_file)
//
//if dw_up.update() > 0 then
//	commit;
//else
//   rollback;
//end if
//
//if ll_import < 1 Then
//   messagebox('알림', '파일처리에 실패하였습니다.(' + ls_save_file + ')')
//end if
//
//FileDelete(ls_save_file)


if GetFileOpenName("파일 선택", ls_file_name, file_name, "XlS", "Excel Files (*.xls),*.XLS,") = 0 then 
	return -1
end if

ls_file_name1 = ls_file_name


ls_path = mid(ls_file_name, 1 , len(ls_file_name) - len(file_name))

SetPointer(HourGlass!)

xlApp = Create OLEObject //엑셀용 OLE Object를 선언 한다.

ret = xlApp.ConnectToNewObject("excel.application") //엑셀과 연결하여 준다.
if ret < 0 then
  MessageBox("알림","엑셀 프로그램을 사용하는데 실패 하였습니다",StopSign!)
  return -1
end if

xlApp.Application.Workbooks.Open(ls_file_name) //화일을 엑셀에 맞추어서 열어 준다.
ls_file_name1 = ls_path + string(today(),'yyyymmdd') + string(now(),'hhmmss') + '_tmp.txt'

long lo, lc
lo = xlApp.application.Workbooks(1).Worksheets(1).UsedRange.Rows.Count
lc = xlApp.application.Workbooks(1).Worksheets(1).UsedRange.Columns.Count

  //maxRow = xlSheet.UsedRange.Rows.Count
   //maxCol = xlSheet.UsedRange.Columns.Count

xlApp.application.Workbooks(1).Worksheets(1).Rows("1:"+String(lo)).Select
xlApp.application.selection.copy;


xlApp.Application.Quit 
xlApp.DisConnectObject() //엑셀 오브젝트를 파괴한다.
Destroy xlApp

dw_up.ImportClipboard()
Clipboard("")


delete from p3_monthchgamt;
commit;

//ll_import = dw_up.ImportFile(ls_save_file)

if dw_up.update() > 0 then
	commit;
else
	messagebox('알림', '파일처리에 실패하였습니다.(' + ls_save_file + ')')
   rollback;
end if

//if ll_import < 1 Then
//   messagebox('알림', '파일처리에 실패하였습니다.(' + ls_save_file + ')')
//end if
//


delete from p3_monthchgdata
where companycode = :gs_company and workym = :sym and 
      pbtag = :sPbtag and gubun = :Gubn and allowcode = :sCode and
      empno in (select empno from p1_master where fun_get_saupcd(empno) like :is_saupcd);
		
		
INSERT INTO "P3_MONTHCHGDATA"  
("COMPANYCODE",   "WORKYM",  "EMPNO", "PBTAG", "ALLOWCODE", "ALLOWAMT", "GUBUN" )  
select :gs_company,  :sym,     empno,   :sPbtag,    :sCode,      allowamt,       :Gubn
from p3_monthchgamt;

IF SQLCA.SQLCODE <> 0 THEN
	Rollback ;
	messagebox("생성에러","자료생성 실패!!")
	return
ELSE
	Commit ;
	messagebox("생성에러","자료생성 성공!!")
END IF	

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = "자료 생성 완료!!"	


p_inq.Triggerevent(Clicked!)	

return ll_import 



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type dw_empinfo from datawindow within w_pip1020
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 942
integer y = 20
integer width = 2606
integer height = 392
integer taborder = 10
string dataobject = "d_pip1020_200"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string sCode , snull,sname,gCODE,JI_GONG_Gubn,SetNull
Long sCount

SetNull(snull)
dw_empinfo.AcceptText()

/*수당체크*/
IF dw_empinfo.GetColumnName() = "allowcode" THEN
	IF WF_ALLOWCODE() = -1 THEN
	   Return 1
   END IF
END IF	

/* 부서코드 */
IF dw_empinfo.Getcolumnname() = "deptcode" THEN
	sCode =  this.GetText()	
	
	IF sCode ="" OR IsNull(sCode) THEN 
	   dw_empinfo.setitem(1,"deptname",snull)		
		RETURN
	END IF
	
	
	SELECT "P0_DEPT"."DEPTNAME"  
     INTO :sname  
  	  FROM "P0_DEPT"  
	 WHERE "P0_DEPT"."DEPTCODE" = :scode   ;
	
	IF sqlca.sqlcode <> 0 THEN
		Messagebox("확인","부서코드를 확인하십시오!!")
		dw_empinfo.setitem(1,"deptcode",snull)
		dw_empinfo.setitem(1,"deptname",snull)	
		dw_empinfo.setcolumn("deptcode")
		Return 1	
	ELSE
		dw_empinfo.setitem(1,"deptname",sname)		
	END IF	
	
END IF	
/* 직급코드 */
IF dw_empinfo.Getcolumnname() = "levelcode" THEN
	sCode =  this.GetText()	
	IF sCode = '' OR ISNULL(sCode) THEN RETURN
	
	SELECT "P0_LEVEL"."LEVELCODE"  
     INTO :gCODE 
  	  FROM "P0_LEVEL"  
	 WHERE "P0_LEVEL"."LEVELCODE" =:scode ;
	
	IF gCODE = '' or isnull(gCODE) THEN
		Messagebox("확인","직급코드를 확인하십시오!!")
		dw_empinfo.SetITem(1,"levelcode",SetNull)
		dw_empinfo.setcolumn("levelcode")
		Return 1	
	END IF	
END IF				

/*급여,상여 구분*/
IF dw_empinfo.Getcolumnname() = "paygubn" THEN
	sCode =  this.GetText()	
	IF sCode = '' OR ISNULL(sCode) THEN RETURN
	     SELECT COUNT(*)
			 INTO :sCount  
			 FROM "P0_REF"  
			WHERE ( "P0_REF"."CODEGBN" = 'PB' ) AND  
					( "P0_REF"."CODE" <> '00' )  and
					  "P0_REF"."CODE" =:sCode  ; 
			IF sCount = 0 THEN
				Messagebox("확인","급여구분을 확인하십시오!!")
		      dw_empinfo.setcolumn("PAYGUBN")
		      Return 1	
	END IF	
	
	DataWindowChild state_child
	
	dw_empinfo.GetChild("allowcode", state_child)
	state_child.SetTransObject(SQLCA)
	state_child.Reset()			
	
	IF rb_pstag1.Checked = True THEN /*지급,공제구분*/
		JI_GONG_Gubn = '1'
	ELSE
		JI_GONG_Gubn = '2'
	END IF	

	  IF state_child.Retrieve(JI_GONG_Gubn,sCode) <= 0 THEN
		  Return 1
	  END IF
	
END IF	

end event

event rbuttondown;IF dw_empinfo.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(Gs_gubun)
	
	Gs_gubun = is_saupcd
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_empinfo.SetITem(1,"deptcode",gs_code)
	dw_empinfo.SetITem(1,"deptname",gs_codename)
	
END IF	
end event

event itemerror;Return 1
end event

event retrievestart;Int rtncode

DataWindowChild state_child

rtncode = dw_empinfo.GetChild("allowcode", state_child)
IF rtncode = -1 THEN 
	  MessageBox("확인","없슴")
	  Return
END IF  

state_child.SetTransObject(SQLCA)

IF state_child.Retrieve("1","Y") <= 0 THEN
	if state_child.Retrieve("2","Y") <= 0 then
		Return 1
	else
		rb_pstag2.Checked = True
		rb_pstag1.Checked = False
	end if
END IF	
end event

type dw_saup from datawindow within w_pip1020
integer x = 1536
integer y = 40
integer width = 635
integer height = 96
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd"
boolean border = false
boolean livescroll = true
end type

event itemchanged;this.AcceptText()

IF this.GetColumnName() = 'sabu' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

end event

type dw_up from datawindow within w_pip1020
boolean visible = false
integer x = 3639
integer y = 476
integer width = 686
integer height = 128
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_pip1020_300"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_pip1020
integer x = 3611
integer y = 264
integer width = 923
integer height = 116
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "* 일괄자료생성 포맷은 사번, 금액    으로 된 엑셀자료입니다"
boolean focusrectangle = false
end type

