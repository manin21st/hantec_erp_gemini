$PBExportHeader$w_pip5002.srw
$PBExportComments$** 인정상여 등록
forward
global type w_pip5002 from w_inherite_multi
end type
type dw_main from u_d_select_sort within w_pip5002
end type
type rr_1 from roundrectangle within w_pip5002
end type
type dw_empinfo from datawindow within w_pip5002
end type
type dw_saup from datawindow within w_pip5002
end type
end forward

global type w_pip5002 from w_inherite_multi
string title = "인정상여금 등록"
dw_main dw_main
rr_1 rr_1
dw_empinfo dw_empinfo
dw_saup dw_saup
end type
global w_pip5002 w_pip5002

type variables
String iv_pbtag,iv_pstag , sDate,iv_dept,iv_level,iv_code
Boolean EditCheck
Boolean RowCheck
end variables

forward prototypes
public function integer wf_required_check (integer ll_row)
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

on w_pip5002.create
int iCurrent
call super::create
this.dw_main=create dw_main
this.rr_1=create rr_1
this.dw_empinfo=create dw_empinfo
this.dw_saup=create dw_saup
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_main
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_empinfo
this.Control[iCurrent+4]=this.dw_saup
end on

on w_pip5002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_main)
destroy(this.rr_1)
destroy(this.dw_empinfo)
destroy(this.dw_saup)
end on

event open;call super::open;dw_empinfo.SetTransObject(SQLCA)      //사원정보
dw_empinfo.Retrieve()
dw_main.SetTransObject(SQLCA)
dw_main.Reset()

dw_saup.SetTransObject(sqlca)
dw_saup.InsertRow(0)

/*사업장 정보 셋팅*/
f_set_saupcd(dw_saup,'sabu','1')
is_saupcd = gs_saupcd

dw_empinfo.SetItem(1,"sDate",left(gs_today,6))
p_inq.TriggerEvent(Clicked!)
EditCheck = True
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip5002
boolean visible = false
integer x = 2606
integer y = 3188
integer taborder = 100
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip5002
boolean visible = false
integer x = 3593
integer y = 2388
integer taborder = 80
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

type p_search from w_inherite_multi`p_search within w_pip5002
boolean visible = false
integer x = 2258
integer y = 3044
integer taborder = 180
end type

type p_ins from w_inherite_multi`p_ins within w_pip5002
boolean visible = false
integer x = 2807
integer y = 3016
integer taborder = 60
end type

type p_exit from w_inherite_multi`p_exit within w_pip5002
integer x = 4384
integer y = 28
integer taborder = 170
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

type p_can from w_inherite_multi`p_can within w_pip5002
boolean visible = false
integer x = 3918
integer y = 2400
integer taborder = 160
end type

type p_print from w_inherite_multi`p_print within w_pip5002
boolean visible = false
integer x = 2432
integer y = 3044
integer taborder = 190
end type

type p_inq from w_inherite_multi`p_inq within w_pip5002
integer x = 4037
integer y = 28
end type

event p_inq::clicked;call super::clicked;String sempno,sYearMonth,Gubn
String sDeptCode,sGradeCode,sLevelCode, ls_saup

dw_empinfo.AcceptText()
dw_main.Reset()
dw_saup.AcceptText()

sYearMonth = dw_empinfo.GetItemString(1,"sDate") 
sGradeCode = dw_empinfo.GetItemString(1,"gradecode")
sDeptCode  = dw_empinfo.GetItemString(1,"deptcode")
sLevelCode = dw_empinfo.GetItemString(1,"levelcode") 
ls_saup			= dw_saup.GetItemString(1,"sabu")

IF ls_saup = '' OR IsNull(ls_saup) THEN ls_saup = '%'

IF sYearMonth = '' OR ISNULL(sYearMonth) THEN
	MessageBox("확인","적용년월을 입력하세요")
	dw_empinfo.SetColumn("sDate")
	dw_empinfo.SetFocus()
	Return
ELSE
	IF F_DATECHK(sYearMonth+"01") =-1 THEN
		MessageBox("확인","적용년월을 확인하세요")
		dw_empinfo.SetColumn("sDate")
	   dw_empinfo.SetFocus()
		Return
	END IF	
END IF	

IF sDeptCode = '' OR ISNULL(sDeptCode) THEN
	sDeptCode = '%'
END IF	
IF sGradeCode = '' OR ISNULL(sGradeCode) THEN
	sGradeCode = '%'
END IF
IF sLevelCode = '' OR ISNULL(sLevelCode) THEN
	sLevelCode = '%'
END IF	

IF dw_main.retrieve(gs_company,sYearMonth,sDeptCode,sGradeCode,sLevelCode,ls_saup,'1')  <= 0 then
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

type p_del from w_inherite_multi`p_del within w_pip5002
boolean visible = false
integer x = 4114
integer y = 2388
integer taborder = 140
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

type p_mod from w_inherite_multi`p_mod within w_pip5002
integer x = 4210
integer y = 28
integer taborder = 120
end type

event p_mod::clicked;call super::clicked;String sempno, sYearMonth, sGubn, sYm
Int K
Long sIncomeAmt, sAmt,sCount

dw_empinfo.AcceptText()
dw_saup.AcceptText()

sYearMonth = dw_empinfo.GetItemString(1,"sDate") 

IF sYearMonth = '' OR ISNULL(sYearMonth) THEN
	MessageBox("확인","적용년월을 입력하세요")
	dw_empinfo.SetColumn("sDate")
	dw_empinfo.SetFocus()
	Return
ELSE
	IF F_DATECHK(sYearMonth+"01") =-1 THEN
		MessageBox("확인","적용년월을 확인하세요")
		dw_empinfo.SetColumn("sDate")
	   dw_empinfo.SetFocus()
		Return
	END IF	
END IF	


IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

  SetPointer(HourGlass!)

    FOR  K = 1  TO dw_main.RowCount()	

      IF DW_MAIN.acceptText() = -1 then Continue
	
		sEmpno = dw_main.GetItemString(K,"empno")
		sIncomeAmt = dw_main.GetItemDecimal(K, "IncomeAmt")
		
		IF String(sIncomeAmt) = '' OR IsNull(string(sIncomeAmt)) THEN
			sIncomeAmt = 0
		END IF

	  	IF sIncomeAmt <> 0 THEN
		  SELECT COUNT(*)  
             INTO :sCount  
				 FROM "P3_ACNT_INCOMEAMT"  
				 WHERE ( "P3_ACNT_INCOMEAMT"."GUBUN" = '1') AND  
                   ( "P3_ACNT_INCOMEAMT"."WORKYM" =:sYearMonth) AND      				      
						 ( "P3_ACNT_INCOMEAMT"."EMPNO" =:sEmpno ) ;			
						 
				 IF sCount = 0 THEN
					  INSERT INTO "P3_ACNT_INCOMEAMT"  
    						     ( "GUBUN",  "WORKYM",   "EMPNO",  "INCOMEAMT" )  
								 
	              VALUES ( '1',      :sYearMonth,      :sEmpno,  :sIncomeAmt )  ;        
					  
						IF SQLCA.SQLCODE = 0 THEN
							COMMIT ;
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
//							EXIT
						END IF	
				ELSE
					  UPDATE "P3_ACNT_INCOMEAMT"  
						  SET "INCOMEAMT" = :sIncomeAmt
					WHERE ( "P3_ACNT_INCOMEAMT"."GUBUN" = '1') AND  
                        ( "P3_ACNT_INCOMEAMT"."WORKYM" = :sYearMonth) AND      				      
						      ( "P3_ACNT_INCOMEAMT"."EMPNO" = :sEmpno )  ;
								
					   IF SQLCA.SQLCODE = 0 THEN
							COMMIT ;
							w_mdi_frame.sle_msg.text ="자료 저장성공!!"
							SetPointer(Arrow!)
					   ELSE
						   ROLLBACK ;	
							w_mdi_frame.sle_msg.text ="자료 저장실패!!"
							SetPointer(Arrow!)
//							EXIT
						END IF					 
               	
				END IF
		ELSEIF sIncomeAmt = 0 or String(sIncomeAmt) = '' THEN 
			      DELETE FROM "P3_ACNT_INCOMEAMT"  
					WHERE ( "P3_ACNT_INCOMEAMT"."GUBUN" = '1') AND  
                     ( "P3_ACNT_INCOMEAMT"."WORKYM" = :sYearMonth) AND      				      
						   ( "P3_ACNT_INCOMEAMT"."EMPNO" = :sEmpno )   ;
							
				   IF SQLCA.SQLCODE = 0 THEN
						COMMIT ;
					ELSE
						ROLLBACK ;
						w_mdi_frame.sle_msg.text ="자료 저장실패!!"
						SetPointer(Arrow!)
//						EXIT
					END IF	
		   END IF   
    NEXT

	EditCheck = True
   SetPointer(Arrow!)
end event

type dw_insert from w_inherite_multi`dw_insert within w_pip5002
boolean visible = false
integer x = 101
integer y = 2560
integer taborder = 20
end type

type st_window from w_inherite_multi`st_window within w_pip5002
boolean visible = false
integer taborder = 70
end type

type cb_append from w_inherite_multi`cb_append within w_pip5002
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

type cb_exit from w_inherite_multi`cb_exit within w_pip5002
boolean visible = false
integer x = 2647
integer y = 2636
integer taborder = 150
end type

type cb_update from w_inherite_multi`cb_update within w_pip5002
boolean visible = false
integer x = 1915
integer y = 2636
integer taborder = 110
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip5002
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

type cb_delete from w_inherite_multi`cb_delete within w_pip5002
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

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip5002
boolean visible = false
integer x = 407
integer y = 2636
integer taborder = 90
end type

type st_1 from w_inherite_multi`st_1 within w_pip5002
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip5002
boolean visible = false
integer x = 2281
integer y = 2636
integer taborder = 130
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip5002
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip5002
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip5002
boolean visible = false
integer x = 1902
integer width = 1152
integer height = 176
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip5002
boolean visible = false
integer x = 407
integer width = 402
integer height = 176
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip5002
boolean visible = false
end type

type dw_main from u_d_select_sort within w_pip5002
integer x = 965
integer y = 300
integer width = 2519
integer height = 1940
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pip5002_2"
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

event itemerror;call super::itemerror;Return 1
end event

type rr_1 from roundrectangle within w_pip5002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 946
integer y = 292
integer width = 2569
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_empinfo from datawindow within w_pip5002
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 942
integer y = 28
integer width = 2583
integer height = 260
integer taborder = 40
string dataobject = "d_pip5002_1"
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

p_inq.TriggerEvent(Clicked!)
end event

event rbuttondown;IF dw_empinfo.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(gs_gubun)
	
	gs_gubun = is_saupcd
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_empinfo.SetITem(1,"deptcode",gs_code)
	dw_empinfo.SetITem(1,"deptname",gs_codename)
	p_inq.TriggerEvent(Clicked!)
END IF	
end event

event itemerror;Return 1
end event

type dw_saup from datawindow within w_pip5002
integer x = 969
integer y = 60
integer width = 635
integer height = 96
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd"
boolean border = false
boolean livescroll = true
end type

event itemchanged;is_saupcd = data
p_inq.TriggerEvent(Clicked!)
end event

