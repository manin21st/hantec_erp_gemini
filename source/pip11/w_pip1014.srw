$PBExportHeader$w_pip1014.srw
$PBExportComments$** 급여 고정금액항목별등록
forward
global type w_pip1014 from w_inherite_multi
end type
type rb_pstag1 from radiobutton within w_pip1014
end type
type rb_pstag2 from radiobutton within w_pip1014
end type
type dw_main from u_d_select_sort within w_pip1014
end type
type p_1 from uo_picture within w_pip1014
end type
type rr_1 from roundrectangle within w_pip1014
end type
type dw_empinfo from datawindow within w_pip1014
end type
type dw_saup from datawindow within w_pip1014
end type
type cb_1 from commandbutton within w_pip1014
end type
type st_2 from statictext within w_pip1014
end type
type p_2 from picture within w_pip1014
end type
end forward

global type w_pip1014 from w_inherite_multi
string title = "고정자료항목별 등록"
rb_pstag1 rb_pstag1
rb_pstag2 rb_pstag2
dw_main dw_main
p_1 p_1
rr_1 rr_1
dw_empinfo dw_empinfo
dw_saup dw_saup
cb_1 cb_1
st_2 st_2
p_2 p_2
end type
global w_pip1014 w_pip1014

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

public function integer wf_allowcode ();String sCode,SetNull
Long sCount

dw_empinfo.AcceptText()

sCode = dw_empinfo.GetItemString(1,"allowcode")

IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당을 입력하세요")
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
		  MessageBox("수당확인","수당을 확인하세요")
		  dw_empinfo.SetItem(1,"allowcode",SetNull) 
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
		  MessageBox("수당확인","수당을 확인하세요")
		  dw_empinfo.SetItem(1,"allowcode",SetNull) 
		  dw_empinfo.SetColumn("allowcode")
		  dw_empinfo.SetFocus()
		  Return -1
	  END IF
END IF	

Return 1
end function

on w_pip1014.create
int iCurrent
call super::create
this.rb_pstag1=create rb_pstag1
this.rb_pstag2=create rb_pstag2
this.dw_main=create dw_main
this.p_1=create p_1
this.rr_1=create rr_1
this.dw_empinfo=create dw_empinfo
this.dw_saup=create dw_saup
this.cb_1=create cb_1
this.st_2=create st_2
this.p_2=create p_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_pstag1
this.Control[iCurrent+2]=this.rb_pstag2
this.Control[iCurrent+3]=this.dw_main
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.dw_empinfo
this.Control[iCurrent+7]=this.dw_saup
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.p_2
end on

on w_pip1014.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_pstag1)
destroy(this.rb_pstag2)
destroy(this.dw_main)
destroy(this.p_1)
destroy(this.rr_1)
destroy(this.dw_empinfo)
destroy(this.dw_saup)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.p_2)
end on

event open;call super::open;
dw_empinfo.SetTransObject(SQLCA)      //사원정보
dw_empinfo.Retrieve()
dw_main.SetTransObject(SQLCA)
dw_main.Reset()
dw_saup.SetTransObject(SQLCA)
dw_saup.InsertRow(0)

/*사업장 정보 셋팅*/
f_set_saupcd(dw_saup,'saupcd','1')
is_saupcd = gs_saupcd

dw_empinfo.SetItem(1,"sDate",gs_today)
dw_empinfo.SetItem(1,"PAYGUBN","P")
dw_empinfo.SetItem(1,"jikjong0", "0")
dw_empinfo.SetItem(1,"jikjong1", "1")
dw_empinfo.SetItem(1,"jikjong2", "2")
dw_empinfo.SetItem(1,"kunmu0", "10")
//p_mod.enabled=False
//p_mod.Picturename = "C:\erpman\image\저장_d.gif"
EditCheck = True
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1014
boolean visible = false
integer x = 3214
integer y = 3156
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1014
boolean visible = false
integer x = 3040
integer y = 3156
end type

type p_search from w_inherite_multi`p_search within w_pip1014
boolean visible = false
integer x = 2857
integer y = 3004
end type

type p_ins from w_inherite_multi`p_ins within w_pip1014
boolean visible = false
integer x = 4247
integer y = 2448
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

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

type p_exit from w_inherite_multi`p_exit within w_pip1014
integer x = 4379
end type

event p_exit::clicked;call super::clicked;//w_mdi_frame.SLE_MSG.TEXT =""
//
//IF EditCheck = False THEN
//	IF  MessageBox("확인", "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
//		 question!, yesno!) = 2 THEN
//      close(parent)	   	 
//    END IF
//ELSE
//   close(parent)	   	 
//END IF
//
//
end event

type p_can from w_inherite_multi`p_can within w_pip1014
integer x = 4206
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

type p_print from w_inherite_multi`p_print within w_pip1014
boolean visible = false
integer x = 3031
integer y = 3004
end type

type p_inq from w_inherite_multi`p_inq within w_pip1014
integer x = 3858
end type

event p_inq::clicked;call super::clicked;String sempno,sYear,sCode ,Pbtag,Gubn
String sDeptCode,sLevelCode, ls_saup, ls_jikjong, ls_kunmu
String sJikjong0, sJikjong1, sJikjong2 ,sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3
long i

dw_empinfo.AcceptText()
dw_main.Reset()
dw_saup.AcceptText()

sYear = dw_empinfo.GetItemString(1,"sDate") 
sCode = dw_empinfo.GetItemString(1,"allowcode")
sDeptCode  = dw_empinfo.GetItemString(1,"deptcode")
sLevelCode = dw_empinfo.GetItemString(1,"levelcode") 
Pbtag      = dw_empinfo.GetItemString(1,"paygubn")
ls_saup	  = dw_saup.GetItemString(1,"saupcd")

sJikjong0  = dw_empinfo.GetItemString(1,"jikjong0")		// 임원 : 0
sJikjong1  = dw_empinfo.GetItemString(1,"jikjong1")		// 관리직 : 1
sJikjong2  = dw_empinfo.GetItemString(1,"jikjong2")		// 생산직 : 2
sJikjong3  = dw_empinfo.GetItemString(1,"jikjong3")		// 용역 : 3
sKunmu0  = dw_empinfo.GetItemString(1,"kunmu0")		// 정직원 : 10		
sKunmu1  = dw_empinfo.GetItemString(1,"kunmu1")		// 파견직 : 20
sKunmu2  = dw_empinfo.GetItemString(1,"kunmu2")		// 계약직 : 30
sKunmu3  = dw_empinfo.GetItemString(1,"kunmu3")		// 용역 : 40

IF sYear = '' OR ISNULL(sYear) THEN
	MessageBox("확인","퇴사일자를 입력하세요")
	dw_empinfo.SetColumn("sDate")
	dw_empinfo.SetFocus()
	Return
ELSE
	IF F_DATECHK(sYear) =-1 THEN
		MessageBox("확인","퇴사일자를 확인하세요")
		dw_empinfo.SetColumn("sDate")
	   dw_empinfo.SetFocus()
		Return
	END IF	
END IF	
IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당을 입력하세요")
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
IF ls_saup = '' OR ISNULL(ls_saup) THEN
	ls_saup = '%'
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

IF dw_main.retrieve(gs_company,Pbtag,Gubn,sCode,sYear,sDeptCode,sLevelCode,ls_saup,sJikjong0,sJikjong1,sJikjong2,sJikjong3,sKunmu0,sKunmu1,sKunmu2,sKunmu3 )  <= 0 then
	MessageBox("확인","조회된 자료가 없습니다")
	RowCheck = False
	p_mod.enabled=false
   p_mod.Picturename = "C:\erpman\image\저장_d.gif"
	Return
ELSE
	dw_main.ScrollToRow(dw_main.RowCount())
end if
dw_main.SetRedraw(True)
RowCheck = True
p_mod.enabled=True
p_mod.Picturename = "C:\erpman\image\저장_up.gif"
end event

type p_del from w_inherite_multi`p_del within w_pip1014
boolean visible = false
integer x = 4073
integer y = 2440
end type

type p_mod from w_inherite_multi`p_mod within w_pip1014
integer x = 4032
end type

event p_mod::clicked;call super::clicked;Int K
String sEmpno,Pbtag,Gubn ,gAllowCode
Long sAmt,sCount

dw_empinfo.AcceptText()
Pbtag = dw_empinfo.GetItemString(1,"paygubn")

IF dw_main.Accepttext() = -1 THEN 	RETURN
  
   gAllowCode = dw_empinfo.GetItemString(1,"allowcode")
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
				 FROM "P3_FIXEDDATA"  
				 WHERE ( "P3_FIXEDDATA"."PBTAG" =:Pbtag) AND  
					    ( "P3_FIXEDDATA"."GUBUN" =:Gubn ) AND  
						 ( "P3_FIXEDDATA"."ALLOWCODE" =:gAllowCode) AND
						 ( "P3_FIXEDDATA"."EMPNO" =:sEmpno )  ;
				 IF sCount = 0 THEN
					  INSERT INTO "P3_FIXEDDATA"  
	                    ( "COMPANYCODE", "ALLOWCODE", "EMPNO", "PBTAG",   
	                      "ALLOWAMT",    "GUBUN" )  
	              VALUES ( :gs_company,   :gAllowCode,  :sEmpno, :Pbtag,   
	                       :sAmt,         :Gubn )  ;        
						IF SQLCA.SQLCODE = 0 THEN
							COMMIT ;
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
							EXIT
						END IF	
				ELSE
					  UPDATE "P3_FIXEDDATA"  
						  SET "ALLOWAMT" =:sAmt  
						WHERE ( "P3_FIXEDDATA"."ALLOWCODE" =:gAllowCode ) AND  
								( "P3_FIXEDDATA"."PBTAG" =:Pbtag ) AND  
								( "P3_FIXEDDATA"."GUBUN" =:Gubn ) AND
								( "P3_FIXEDDATA"."EMPNO" =:sEmpno )   ;
					   IF SQLCA.SQLCODE = 0 THEN
							COMMIT ;
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
							EXIT
						END IF					 
               	
				END IF
			ELSEIF ISNULL(sAmt) OR sAmt = 0  THEN 
			      DELETE FROM "P3_FIXEDDATA"  
					WHERE ( "P3_FIXEDDATA"."COMPANYCODE" =:gs_company ) AND  
							( "P3_FIXEDDATA"."ALLOWCODE" =:gAllowCode ) AND  
							( "P3_FIXEDDATA"."PBTAG" =:Pbtag) AND  
							( "P3_FIXEDDATA"."GUBUN" =:Gubn) AND  
							( "P3_FIXEDDATA"."EMPNO" =:sEmpno)   ;
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

type dw_insert from w_inherite_multi`dw_insert within w_pip1014
boolean visible = false
integer x = 1399
integer y = 3052
end type

type st_window from w_inherite_multi`st_window within w_pip1014
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip1014
string tag = "TCODE~" =~' ~' "
boolean visible = false
integer x = 2094
integer y = 3168
integer taborder = 0
string dragicon = "~' ~' "
string text = "생성(&L)"
end type

event cb_append::clicked;call super::clicked;Long  K,sAmt,sCount
String Pbtag,Gubn,sCode

dw_main.Reset()
dw_empinfo.AcceptText()
dw_main.SetRedraw(False)
Pbtag = dw_empinfo.GetItemString(1,"paygubn")

/*지급,공제 구분*/
IF rb_pstag1.Checked = True THEN
	Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN
	Gubn = '2'
END IF	

sCode = dw_empinfo.GetItemString(1,"allowcode")
sAmt  = dw_empinfo.GetItemNumber(1,"allowamt")

IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당을 입력하세요")
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
    FROM "P3_FIXEDDATA"  
   WHERE ( "P3_FIXEDDATA"."PBTAG" = :Pbtag ) AND  
         ( "P3_FIXEDDATA"."GUBUN" = :Gubn ) AND  
         ( "P3_FIXEDDATA"."ALLOWCODE" = :sCode) ;
			
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

type cb_exit from w_inherite_multi`cb_exit within w_pip1014
boolean visible = false
integer x = 2679
integer y = 2652
integer taborder = 60
end type

type cb_update from w_inherite_multi`cb_update within w_pip1014
boolean visible = false
integer x = 1947
integer y = 2652
integer taborder = 40
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1014
boolean visible = false
integer x = 1952
integer y = 3052
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

type cb_delete from w_inherite_multi`cb_delete within w_pip1014
boolean visible = false
integer x = 2341
integer y = 3052
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

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1014
boolean visible = false
integer x = 439
integer y = 2652
integer taborder = 30
end type

type st_1 from w_inherite_multi`st_1 within w_pip1014
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1014
boolean visible = false
integer x = 2313
integer y = 2652
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1014
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1014
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1014
boolean visible = false
integer x = 1902
integer width = 1152
integer height = 176
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1014
boolean visible = false
integer x = 407
integer width = 402
integer height = 176
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1014
boolean visible = false
end type

type rb_pstag1 from radiobutton within w_pip1014
event clicked pbm_bnclicked
integer x = 3255
integer y = 76
integer width = 256
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

event clicked;String SetNull,Pbtag
dw_empinfo.AcceptText()

w_mdi_frame.SLE_MSG.TEXT =""

IF EditCheck = False THEN
	IF  MessageBox("확인", "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 2 THEN
       Return
	END IF
END IF

Pbtag = dw_empinfo.GetItemString(1,"paygubn")

dw_main.Reset()
DataWindowChild state_child

dw_empinfo.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset()
IF Pbtag = 'P' THEN 
	IF state_child.Retrieve("1","Y") <= 0 THEN
		Return 1
	END IF	
ELSE
	IF state_child.Retrieve("1","N") <= 0 THEN
		Return 1
	END IF	
END IF	

dw_empinfo.SetITem(1,"allowcode",SetNull)
end event

type rb_pstag2 from radiobutton within w_pip1014
event clicked pbm_bnclicked
integer x = 3255
integer y = 156
integer width = 256
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

event clicked;String SetNull,Pbtag

dw_empinfo.AcceptText()

IF EditCheck = False THEN
	IF  MessageBox("확인", "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 2 THEN
       Return
	END IF
END IF

Pbtag = dw_empinfo.GetItemString(1,"paygubn")
dw_main.Reset()

DataWindowChild state_child

dw_empinfo.GetChild("allowcode", state_child)
state_child.SetTransObject(SQLCA)
state_child.Reset()

IF Pbtag = 'P' THEN 
	IF state_child.Retrieve("2","Y") <= 0 THEN
		Return 1
	END IF	
ELSE
	IF state_child.Retrieve("2","N") <= 0 THEN
		Return 1
	END IF	
END IF	
dw_empinfo.SetITem(1,"allowcode",SetNull)
end event

type dw_main from u_d_select_sort within w_pip1014
integer x = 786
integer y = 460
integer width = 2779
integer height = 1804
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pip1014_2"
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

type p_1 from uo_picture within w_pip1014
boolean visible = false
integer x = 3904
integer y = 2452
boolean bringtotop = true
string picturename = "C:\Erpman\image\생성_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_down.gif"
end event

event clicked;call super::clicked;Long  K,sAmt,sCount
String Pbtag,Gubn,sCode

dw_main.Reset()
dw_empinfo.AcceptText()
dw_main.SetRedraw(False)
Pbtag = dw_empinfo.GetItemString(1,"paygubn")

/*지급,공제 구분*/
IF rb_pstag1.Checked = True THEN
	Gubn = '1'
ELSEIF rb_pstag2.Checked = True THEN
	Gubn = '2'
END IF	

sCode = dw_empinfo.GetItemString(1,"allowcode")
sAmt  = dw_empinfo.GetItemNumber(1,"allowamt")

IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당을 입력하세요")
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
    FROM "P3_FIXEDDATA"  
   WHERE ( "P3_FIXEDDATA"."PBTAG" = :Pbtag ) AND  
         ( "P3_FIXEDDATA"."GUBUN" = :Gubn ) AND  
         ( "P3_FIXEDDATA"."ALLOWCODE" = :sCode) ;
			
   IF sCount >= 1 THEN
	  IF MessageBox("확인","기존에 자료가 존재합니다. ~r 다시 생성하시겠습니까?",Question!,YesNO!) = 2 THEN
		  RETURN
	  END IF	
   END IF 
	
p_inq.Triggerevent(clicked!)	
/*데이타 존재유무 체크->저장버튼 활성,비활성*/
IF RowCheck = False THEN
	Return
END IF

FOR  K = 1 TO dw_main.RowCount()
    dw_main.SetITem(K,"amt",sAmt)
NEXT
dw_main.SetRedraw(True)
p_mod.Enabled = True
end event

type rr_1 from roundrectangle within w_pip1014
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 782
integer y = 448
integer width = 2802
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_empinfo from datawindow within w_pip1014
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 773
integer y = 16
integer width = 2816
integer height = 416
integer taborder = 10
string dataobject = "d_pip1014_1"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF key=keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string sCode , snull,sname,gCODE,SetNull,JI_GONG_Gubn
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
		dw_empinfo.setItem(1,"levelcode",SetNull)
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
		      dw_empinfo.setcolumn("paygubn")
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
	
	IF sCode = 'P' THEN
		  IF state_child.Retrieve(JI_GONG_Gubn,"Y") <= 0 THEN
			  Return 1
		  END IF
   ELSE 
		   IF state_child.Retrieve(JI_GONG_Gubn,"Y") <= 0 THEN
			  Return 1
		  END IF
	END IF 
END IF	

end event

event rbuttondown;IF dw_empinfo.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)


	Open(w_dept_popup)
	
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
	Return 1
END IF	
end event

type dw_saup from datawindow within w_pip1014
integer x = 805
integer y = 144
integer width = 658
integer height = 76
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF
end event

type cb_1 from commandbutton within w_pip1014
integer x = 4096
integer y = 184
integer width = 448
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Excel Upload"
end type

event clicked;Long   lValue
String sDocname
String sNamed

// 엑셀 IMPORT ***************************************************************

lValue = GetFileOpenName("지급/공제 자료 가져오기", sDocname, sNamed, "XLS", "XLS Files (*.XLS),*.XLS,")
If lValue <> 1 Then Return -1

Setpointer(Hourglass!)

//===========================================================================================
//UserObject 생성
uo_xlobject uo_xl

w_mdi_frame.sle_msg.text = "엑셀 업로드 준비중..."
uo_xl = Create uo_xlobject

//엑셀과 연결
uo_xl.uf_excel_connect(sDocname, False, 3)
uo_xl.uf_selectsheet(1)

//Data 시작 Row Setting (행)
//Excel 에서 A: 1 , B :2 로 시작 

Long   lXlrow
Long   lCnt

lXlrow = 2		// 첫헤드를 제외하고 두번째행부터 진행
lCnt   = 1 

Long   iNotNullCnt
Long   i
Long   ll_find
Long   ll_chk
Double ldb_amt
String ls_emp
String ls_amt
String ls_ret
String ls_nam

Do While(True)
	
	// 사용자 ID(A,1)
	// Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	// 총 36개 열로 구성
	For i =1 To 15
		uo_xl.uf_set_format(lXlrow, i, '@' + Space(50))
	Next
	
	iNotNullCnt = 0 //아래 구문 실행되지 않으면 종료
	
	ls_emp = Trim(uo_xl.uf_gettext(lXlrow, 2))  //사번
	ls_amt = Trim(uo_xl.uf_gettext(lXlrow, 4))  //금액
	
	If Not IsNull(ls_emp) OR ls_emp >= '1000' OR Trim(ls_emp) <> '' Then
		iNotNullCnt++
		
		/* 사원 등록여부 및 퇴직여부 */
		SELECT COUNT('X'), MAX(RETIREDATE), MAX(EMPNAME)
		  INTO :ll_chk   , :ls_ret        , :ls_nam
		  FROM P1_MASTER
		 WHERE EMPNO = :ls_emp ;
		If SQLCA.SQLCODE <> 0 OR IsNull(ll_chk) OR ll_chk = 0 Then
			MessageBox('미 등록 사번', '사번 ' + ls_emp + '(은)는 등록된 사번이 아닙니다.')
			uo_xl.uf_excel_Disconnect()
			DESTROY uo_xl
			Return
		End If
		
		If Trim(ls_ret) <> '' OR Not IsNull(ls_ret) Then
			MessageBox('퇴직 사번', '사번 ' + ls_emp + '(은)는 퇴직 처리된 사번입니다.')
			uo_xl.uf_excel_Disconnect()
			DESTROY uo_xl
			Return
		End If
		
		w_mdi_frame.sle_msg.text = "엑셀 업로드 진행 중.. (" + String(lCnt) + "행) ..." + ls_emp + "  " + ls_nam
		
		If IsNull(ls_amt) Then ls_amt = '0'
		
		ldb_amt = Double(ls_amt)
		
		ll_find = dw_main.Find("empno = '" + ls_emp + "'", 1, dw_main.RowCount())
		
		If ll_find > 0 Then
			dw_main.SetItem(ll_find, 'amt' , ldb_amt)  //금액
		End If
		
		lCnt++
	End If
		
	// 해당 행의 어떤 열에도 값이 지정되지 않았다면 파일 끝으로 인식해서 임포트 종료
	If iNotNullCnt = 0 Then Exit
	
	lXlrow ++
Loop
uo_xl.uf_excel_Disconnect()


//// 엘셀 IMPORT  END ***************************************************************
dw_insert.AcceptText()

MessageBox('확인', String(lCnt)+' 건의 연봉자료를 정상적으로 Import 하였습니다.')
w_mdi_frame.sle_msg.text = ""
DESTROY uo_xl
end event

type st_2 from statictext within w_pip1014
integer x = 3662
integer y = 292
integer width = 891
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "Excel Upload Sample양식 보기"
boolean focusrectangle = false
end type

event clicked;p_2.Visible = True
end event

type p_2 from picture within w_pip1014
boolean visible = false
integer x = 2345
integer y = 368
integer width = 2194
integer height = 1244
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\smp_pip1014.JPG"
boolean border = true
boolean focusrectangle = false
string powertiptext = "이미지를 클릭하면 화면이 닫힙니다."
end type

event clicked;p_2.Visible = False
end event

