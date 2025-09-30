$PBExportHeader$w_pik1015_add.srw
$PBExportComments$** 월 근태 수정(추가입력가능)
forward
global type w_pik1015_add from w_inherite_standard
end type
type cb_1 from commandbutton within w_pik1015_add
end type
type pb_4 from picturebutton within w_pik1015_add
end type
type pb_3 from picturebutton within w_pik1015_add
end type
type pb_2 from picturebutton within w_pik1015_add
end type
type pb_1 from picturebutton within w_pik1015_add
end type
type gb_5 from groupbox within w_pik1015_add
end type
type rr_5 from roundrectangle within w_pik1015_add
end type
type rr_2 from roundrectangle within w_pik1015_add
end type
type rr_3 from roundrectangle within w_pik1015_add
end type
type rr_4 from roundrectangle within w_pik1015_add
end type
type dw_5 from u_key_enter within w_pik1015_add
end type
type dw_1 from u_key_enter within w_pik1015_add
end type
type dw_2 from u_key_enter within w_pik1015_add
end type
type dw_3 from u_key_enter within w_pik1015_add
end type
type dw_4 from u_d_select_sort within w_pik1015_add
end type
end forward

global type w_pik1015_add from w_inherite_standard
string title = "월 근태 수정"
boolean resizable = false
cb_1 cb_1
pb_4 pb_4
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
gb_5 gb_5
rr_5 rr_5
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
dw_5 dw_5
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
end type
global w_pik1015_add w_pik1015_add

type variables
long il_row

String print_gu                 //window가 조회인지 인쇄인지  

String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false
end variables

event open;call super::open;dw_datetime.SetTransObject(SQLCA)
dw_datetime.insertrow(0)

w_mdi_frame.sle_msg.text =""

ib_any_typing=False

dw_datetime.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_5.insertrow(0)
dw_1.reset()
dw_1.Insertrow(0)
dw_1.setitem(1,"myymm",f_aftermonth(left(f_today(),6),-1))
dw_5.setitem(1,'sdate', gs_today)

f_set_saupcd(dw_5, 'saup', '1')
is_saupcd = gs_saupcd

dw_4.retrieve(gs_company,'%','%',gs_today,gs_saupcd)

dw_1.setColumn("empno")
dw_1.SetFocus()



p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"

end event

on w_pik1015_add.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.pb_4=create pb_4
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.gb_5=create gb_5
this.rr_5=create rr_5
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
this.dw_5=create dw_5
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.pb_4
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.gb_5
this.Control[iCurrent+7]=this.rr_5
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
this.Control[iCurrent+10]=this.rr_4
this.Control[iCurrent+11]=this.dw_5
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.dw_2
this.Control[iCurrent+14]=this.dw_3
this.Control[iCurrent+15]=this.dw_4
end on

on w_pik1015_add.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.pb_4)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.gb_5)
destroy(this.rr_5)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.dw_5)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1015_add
end type

event p_mod::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string ls_yymm, ls_empno, ls_ktcode, ls_gubn, ls_deptcode,ls_flag
long ll_mday, ll_wolcha, ll_yoncha, ll_saeng
integer i

ll_wolcha = 0 ; ll_yoncha = 0 ; ll_saeng = 0

dw_1.AcceptText()
ls_yymm     = dw_1.Getitemstring(dw_1.getrow(),'myymm')
ls_empno    = dw_1.Getitemstring(dw_1.getrow(),'empno')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')

//년월 검사
IF ls_yymm = "01" OR IsNull(ls_yymm) THEN
	MessageBox("확 인","근태년월을 입력하십시요!!")
	dw_1.SetColumn("myymm")
	dw_1.SetFocus()
	Return
ELSE
	if f_datechk(ls_yymm + '01') = -1 then
		 messagebox("확인","근태년월을 확인하십시오!")
		 dw_1.setcolumn("myymm")
		 dw_1.setfocus()
		 return -1
	end if
END IF

//사원번호 검사
IF ls_empno ="" OR IsNull(ls_empno) THEN
	MessageBox("확 인","사번을 입력하십시요!!")
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	Return
ELSE
	SELECT "P1_MASTER"."EMPNO"  
		 INTO :ls_empno  
		 FROM "P1_MASTER"  
		WHERE "P1_MASTER"."COMPANYCODE" = :gs_company and
				"P1_MASTER"."EMPNO" = :ls_empno ;
	if sqlca.sqlcode <> 0 then
		 messagebox("확인","사원번호를 확인하십시오!")
		 dw_1.setcolumn("empno")
		 return -1
	end if
END IF


//기입력자료 삭제처리
DELETE FROM "P4_MKUNTAEDAY"  
      WHERE ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
            ( "P4_MKUNTAEDAY"."EMPNO" = :ls_empno ) AND  
            ( "P4_MKUNTAEDAY"."MYYMM" = :ls_yymm ) ;

// p4_mkuntaeday updaate
for i=1 to dw_2.rowcount()
	ll_mday   = dw_2.Getitemdecimal(i,"mday")
	ls_ktcode = dw_2.Getitemstring(i,"attendancecode")
	ls_gubn   = dw_2.Getitemstring(i,"attendancegubn")

   if ls_gubn = '1' then  //월차일수
		ll_wolcha = ll_mday
	elseif ls_gubn = '2' then  //연차일수
		ll_yoncha = ll_mday
	elseif ls_gubn = '3' then  //생리일수
		ll_saeng = ll_mday
	else
	end if
	
	if ll_mday > 0 then
      INSERT INTO "P4_MKUNTAEDAY"  
          ( "COMPANYCODE",   
            "DEPTCODE",   
            "EMPNO",   
            "MYYMM",   
            "MKTCODE",   
            "MDAY" )  
      VALUES ( :gs_company,   
               :ls_deptcode,   
               :ls_empno,   
               :ls_yymm,   
               :ls_ktcode,   
               :ll_mday )  ;

	end if
next

//월차,연차,생리일수를 p4_mkuntaetime으로 갱신처리위함	 
dw_3.Setitem(dw_3.Getrow(),'mwchdayu',ll_wolcha)
dw_3.Setitem(dw_3.Getrow(),'mychdayu',ll_yoncha)
dw_3.Setitem(dw_3.Getrow(),'msridayu',ll_saeng)

dw_3.Setitem(dw_3.Getrow(),'companycode',gs_company)
dw_3.Setitem(dw_3.Getrow(),'myymm',ls_yymm)
dw_3.Setitem(dw_3.Getrow(),'empno',ls_empno)
dw_3.Setitem(dw_3.Getrow(),'deptcode',ls_deptcode)
//
// p4_mkuntaetime upate
if dw_3.Update() = 0 then
	rollback ;
	messagebox("실패","자료저장이 실패하였습니다!")
	return
else
	commit using sqlca ;
end if

//dw_2.reset()
//dw_3.reset()
dw_1.setcolumn("empno")
dw_1.setfocus()

ib_any_typing =False

w_mdi_frame.sle_msg.text ="자료가 저장되었습니다!"

p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"
end event

type p_del from w_inherite_standard`p_del within w_pik1015_add
end type

event p_del::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string ls_yymm, ls_empno, ls_ktcode 

dw_1.AcceptText()
ls_yymm     = dw_1.Getitemstring(dw_1.getrow(),'myymm')
ls_empno    = dw_1.Getitemstring(dw_1.getrow(),'empno')

//년월 검사
IF ls_yymm = "01" OR IsNull(ls_yymm) THEN
	MessageBox("확 인","근태년월을 입력하십시요!!")
	dw_1.SetColumn("myymm")
	dw_1.SetFocus()
	Return
ELSE
	if f_datechk(ls_yymm + '01') = -1 then
		 messagebox("확인","근태년월을 확인하십시오!")
		 dw_1.setcolumn("myymm")
		 dw_1.setfocus()
		 return -1
	end if
END IF

//사원번호 검사
IF ls_empno ="" OR IsNull(ls_empno) THEN
	MessageBox("확 인","사번을 입력하십시요!!")
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	Return
ELSE
	SELECT "P1_MASTER"."EMPNO"  
		 INTO :ls_empno  
		 FROM "P1_MASTER"  
		WHERE "P1_MASTER"."COMPANYCODE" = :gs_company and
				"P1_MASTER"."EMPNO" = :ls_empno ;
	if sqlca.sqlcode <> 0 then
		 messagebox("확인","사원번호를 확인하십시오!")
		 dw_1.setcolumn("empno")
		 return -1
	end if
END IF

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return

dw_2.SetRedraw(False)
dw_3.SetRedraw(False)
dw_3.DeleteRow(1)
IF dw_3.Update() > 0 THEN
	/* 일수 집계 table 삭제*/
	DELETE FROM "P4_MKUNTAEDAY"  
      WHERE ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
            ( "P4_MKUNTAEDAY"."EMPNO" = :ls_empno ) AND  
            ( "P4_MKUNTAEDAY"."MYYMM" = :ls_yymm ) ;
	commit;
	ib_any_typing =False
	dw_2.retrieve(gs_company, ls_yymm, ls_empno)
	dw_2.SetRedraw(True)
	dw_3.SetRedraw(True)
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	dw_2.retrieve(gs_company, ls_yymm, ls_empno)
	dw_2.SetRedraw(True)
	dw_3.SetRedraw(True)
	Return
END IF

p_can.Enabled = True
p_can.PictureName = "C:\erpman\image\취소_up.gif"


end event

type p_inq from w_inherite_standard`p_inq within w_pik1015_add
integer x = 3515
end type

event p_inq::clicked;call super::clicked;string ls_yymm, ls_empno, ls_kdate, ls_empnocode, ls_name, ls_dept, ls_flag
w_mdi_frame.sle_msg.text =""

dw_1.accepttext()
ls_yymm  = Trim(dw_1.Getitemstring(dw_1.getrow(),'myymm'))
ls_empno = trim(dw_1.Getitemstring(dw_1.getrow(),'empno'))
ls_kdate = ls_yymm + '01'

//년월 검사
IF ls_yymm = "01" OR IsNull(ls_yymm) THEN
	MessageBox("확 인","근태년월을 입력하십시요!!")
	dw_1.SetColumn("myymm")
	dw_1.SetFocus()
	Return
ELSE
	if f_datechk(ls_kdate) = -1 then
		 messagebox("확인","근태년월을 확인하십시오!")
		 dw_1.setcolumn("myymm")
		 dw_1.setfocus()
		 return -1
	end if
END IF

//자료검색
dw_2.SetRedraw(false)
dw_3.SetRedraw(false)
if dw_3.retrieve(gs_company, ls_yymm, ls_empno) = 0 then
	w_mdi_frame.sle_msg.text = "조회한 자료가 없습니다!"
//	dw_2.Reset()  
   dw_3.Insertrow(0)
end if

if dw_2.retrieve(gs_company, ls_yymm, ls_empno) < 1 then
  dw_2.insertrow(0)	 	
  dw_3.Setfocus()
end if
dw_2.SetRedraw(true)
dw_3.SetRedraw(true)

// 마감이 완료된 월은 수정할수 없다//
String sSaup
dw_5.AcceptText()
sSaup = dw_5.GetItemString(1,'saup')
IF ISNULL(sSaup) OR sSaup = '' THEN sSaup = '10'

SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag
  FROM "P4_MFLAG" 
  where companycode= :gs_company and
  		  myymm = :ls_yymm and
		  saupcd = :is_saupcd;

if ls_flag = '1' then
	messagebox("확인","마감이 완료된 월입니다. 마감 취소후 작업하세요.")
	p_ins.Enabled = False
	p_ins.PictureName = "C:\erpman\image\추가_d.gif"
	p_mod.Enabled = False
	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
end if

ib_any_typing =False
p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"
end event

type p_print from w_inherite_standard`p_print within w_pik1015_add
boolean visible = false
integer x = 2048
integer y = 2392
end type

type p_can from w_inherite_standard`p_can within w_pik1015_add
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
ib_any_typing =False

dw_2.reset()
dw_3.reset()
dw_1.setcolumn("myymm")
dw_1.Setfocus()

ib_any_typing =False
PictureName = "C:\erpman\image\취소_d.gif"
end event

type p_exit from w_inherite_standard`p_exit within w_pik1015_add
end type

event p_exit::clicked;w_mdi_frame.sle_msg.text =""

IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)
end event

type p_ins from w_inherite_standard`p_ins within w_pik1015_add
integer x = 3689
end type

event p_ins::clicked;call super::clicked;string ls_yymm, ls_empno, ls_kdate, ls_empnocode
w_mdi_frame.sle_msg.text =""

dw_1.accepttext()
ls_yymm  = Trim(dw_1.Getitemstring(dw_1.getrow(),'myymm'))
ls_empno = dw_1.Getitemstring(dw_1.getrow(),'empno')
ls_kdate = ls_yymm + '01'

//년월 검사
IF ls_yymm = "01" OR IsNull(ls_yymm) THEN
	MessageBox("확 인","근태년월을 입력하십시요!!")
	dw_1.SetColumn("myymm")
	dw_1.SetFocus()
	Return
ELSE
	if f_datechk(ls_kdate) = -1 then
		 messagebox("확인","근태년월을 확인하십시오!")
		 dw_1.setcolumn("myymm")
		 dw_1.setfocus()
		 return -1
	end if
END IF

//사원번호 검사
IF ls_empno ="" OR IsNull(ls_empno) THEN
	MessageBox("확 인","사번을 입력하십시요!!")
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	Return
ELSE
	SELECT "P1_MASTER"."EMPNO"  
		 INTO :ls_empnocode  
		 FROM "P1_MASTER"  
		WHERE "P1_MASTER"."COMPANYCODE" = :gs_company and
				"P1_MASTER"."EMPNO" = :ls_empno ;
	if sqlca.sqlcode <> 0 then
		 messagebox("확인","사원번호를 확인하십시오!")
		 dw_1.setcolumn("empno")
		 return -1
	end if
END IF


//자료검색
if dw_3.retrieve(gs_company, ls_yymm, ls_empno) = 0 then
	dw_2.retrieve(gs_company, ls_yymm, ls_empno)
	dw_3.insertrow(0)
	dw_3.Setfocus()
end if

ib_any_typing =False
p_can.Enabled = True
p_can.PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_search from w_inherite_standard`p_search within w_pik1015_add
boolean visible = false
integer x = 1870
integer y = 2392
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1015_add
boolean visible = false
integer x = 2222
integer y = 2392
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1015_add
boolean visible = false
integer x = 2395
integer y = 2392
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1015_add
boolean visible = false
integer x = 1609
integer y = 2392
end type

type st_window from w_inherite_standard`st_window within w_pik1015_add
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1015_add
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1015_add
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1015_add
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1015_add
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1015_add
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1015_add
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1015_add
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1015_add
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1015_add
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1015_add
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1015_add
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1015_add
boolean visible = false
end type

type cb_1 from commandbutton within w_pik1015_add
boolean visible = false
integer x = 2359
integer y = 2872
integer width = 402
integer height = 112
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
end type

type pb_4 from picturebutton within w_pik1015_add
boolean visible = false
integer x = 3305
integer y = 2852
integer width = 82
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "c:\erpman\image\last.gif"
end type

event clicked;string sEmpNo,sname,sMin_name,sYearMonth,sDeptName

sle_msg.text =""

dw_1.accepttext()
sYearMonth = dw_1.Getitemstring(1,'myymm')

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

SELECT MAX("P1_MASTER"."EMPNO")  
	INTO :sEmpNo  
   FROM "P1_MASTER"  
   WHERE ("P1_MASTER"."COMPANYCODE" = :gs_company) AND
       	(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
         ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
         substr("P1_MASTER"."RETIREDATE",1,6) >= :syearmonth));
IF IsNull(sEmpNo) THEN 
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	SELECT "P1_MASTER"."EMPNAME",   "P0_DEPT"."DEPTNAME2"  
	   INTO :sName,   				  :sDeptName  
	   FROM "P1_MASTER",   "P0_DEPT"  
	   WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
   	      ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
      	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :sEmpNo ) )   ;
	dw_1.SetItem(1,"empno",   sEmpNo)
	dw_1.SetItem(1,"empname", sName)
	dw_1.SetItem(1,"deptname",sDeptName)
END IF

if dw_3.retrieve(gs_company, sYearMonth, sEmpNo) = 0 then
 	messagebox("확인","조회한 자료가 없습니다!")
	dw_2.Reset()
	dw_1.setfocus()
	return 1
else
	dw_2.retrieve(gs_company, sYearMonth, sEmpNo)
	dw_3.Setfocus()
end if

end event

type pb_3 from picturebutton within w_pik1015_add
boolean visible = false
integer x = 3195
integer y = 2852
integer width = 82
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "c:\erpman\image\next.gif"
end type

event clicked;string sEmpNo,sname,sYearMonth,sDeptName

sle_msg.text =""

dw_1.accepttext()
sYearMonth = dw_1.Getitemstring(1,'myymm')
sEmpNo      = dw_1.Getitemstring(1,'empno')

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

SELECT Min("P1_MASTER"."EMPNO")  
	INTO :sEmpNo  
   FROM "P1_MASTER"  
   WHERE ("P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" > :sEmpNo) AND
      	(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
         ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
         substr("P1_MASTER"."RETIREDATE",1,6) >= :syearmonth));
IF IsNull(sEmpNo) THEN 
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	SELECT "P1_MASTER"."EMPNAME",   "P0_DEPT"."DEPTNAME2"  
	   INTO :sName,   				  :sDeptName  
	   FROM "P1_MASTER",   "P0_DEPT"  
	   WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
   	      ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
      	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :sEmpNo ) )   ;
	dw_1.SetItem(1,"empno",   sEmpNo)
	dw_1.SetItem(1,"empname", sName)
	dw_1.SetItem(1,"deptname",sDeptName)
END IF

if dw_3.retrieve(gs_company, sYearMonth, sEmpNo) = 0 then
 	messagebox("확인","조회한 자료가 없습니다!")
	dw_2.Reset()
	dw_1.setfocus()
	return 1
else
	dw_2.retrieve(gs_company, sYearMonth, sEmpNo)
	dw_3.Setfocus()
end if

end event

type pb_2 from picturebutton within w_pik1015_add
boolean visible = false
integer x = 3086
integer y = 2852
integer width = 82
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "c:\erpman\image\prior.gif"
end type

event clicked;string sEmpNo,sname,sYearMonth,sDeptName

sle_msg.text =""

dw_1.accepttext()
sYearMonth = dw_1.Getitemstring(1,'myymm')
sEmpNo     = dw_1.Getitemstring(1,'empno')

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

SELECT MAX("P1_MASTER"."EMPNO")  
	INTO :sEmpNo  
   FROM "P1_MASTER"  
   WHERE ("P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" < :sEmpNo) AND  
      	(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
         ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
         substr("P1_MASTER"."RETIREDATE",1,6) >= :syearmonth));
IF IsNull(sEmpNo) THEN 
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	SELECT "P1_MASTER"."EMPNAME",   "P0_DEPT"."DEPTNAME2"  
	   INTO :sName,   				  :sDeptName  
	   FROM "P1_MASTER",   "P0_DEPT"  
	   WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
   	      ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
      	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :sEmpNo ) )   ;
	dw_1.SetItem(1,"empno",   sEmpNo)
	dw_1.SetItem(1,"empname", sName)
	dw_1.SetItem(1,"deptname",sDeptName)
END IF

if dw_3.retrieve(gs_company, sYearMonth, sEmpNo) = 0 then
 	messagebox("확인","조회한 자료가 없습니다!")
	dw_2.Reset()
	dw_1.setfocus()
	return 1
else
	dw_2.retrieve(gs_company, sYearMonth, sEmpNo)
	dw_3.Setfocus()
end if

end event

type pb_1 from picturebutton within w_pik1015_add
boolean visible = false
integer x = 2976
integer y = 2852
integer width = 82
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "c:\erpman\image\first.gif"
alignment htextalign = left!
end type

event clicked;string sEmpNo,sname,sDeptName,sYearMonth

sle_msg.text =""

dw_1.accepttext()
sYearMonth = dw_1.Getitemstring(1,'myymm')

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

SELECT Min("P1_MASTER"."EMPNO")  
	INTO :sEmpNo  
   FROM "P1_MASTER"  
   WHERE ("P1_MASTER"."COMPANYCODE" = :gs_company ) AND
       	(( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) OR  
            ("P1_MASTER"."SERVICEKINDCODE" = '3' AND  
            substr("P1_MASTER"."RETIREDATE",1,6) >= :syearmonth));
IF IsNull(sEmpNo) THEN 
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	SELECT "P1_MASTER"."EMPNAME",   "P0_DEPT"."DEPTNAME2"  
	   INTO :sName,   				  :sDeptName  
	   FROM "P1_MASTER",   "P0_DEPT"  
	   WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
   	      ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
      	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :sEmpNo ) )   ;
	dw_1.SetItem(1,"empno",   sEmpNo)
	dw_1.SetItem(1,"empname", sName)
	dw_1.SetItem(1,"deptname",sDeptName)
END IF

if dw_3.retrieve(gs_company, sYearMonth, sEmpNo) = 0 then
	messagebox("확인","조회한 자료가 없습니다!")
	dw_2.Reset() 
	dw_1.setfocus()
	return 1
else
	dw_2.retrieve(gs_company, sYearMonth, sEmpNo)
	dw_3.Setfocus()
end if

end event

type gb_5 from groupbox within w_pik1015_add
boolean visible = false
integer x = 2926
integer y = 2788
integer width = 544
integer height = 188
integer taborder = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "자료선택"
end type

type rr_5 from roundrectangle within w_pik1015_add
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1838
integer y = 392
integer width = 2496
integer height = 1844
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pik1015_add
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 384
integer y = 392
integer width = 1253
integer height = 1844
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pik1015_add
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1902
integer y = 516
integer width = 2373
integer height = 560
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pik1015_add
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1906
integer y = 1116
integer width = 2373
integer height = 1068
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_5 from u_key_enter within w_pik1015_add
event ue_retrieve ( )
event ue_keydown pbm_dwnkey
integer x = 370
integer y = 92
integer width = 2162
integer height = 244
integer taborder = 11
string title = "none"
string dataobject = "d_pik1015_10"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_retrieve();string sdate, sdept, sgrade, sSaup

if Accepttext() = -1 then return

sdate = trim(getitemstring(1,'sdate'))
sdept = trim(getitemstring(1,'deptcode'))
sgrade = trim(getitemstring(1,'grade'))
sSaup = trim(getitemstring(1,'saup'))

if IsNull(sdate) or sdate = '' then
	messagebox("확인","퇴직일자기준을 확인하세요!")
	return
end if

if IsNull(sdept) or sdept = '' then sdept = '%'
if IsNull(sgrade) or sgrade = '' then sgrade = '%'
if IsNull(sSaup) or sSaup = '' then sSaup = '%'

if dw_4.retrieve(gs_company, sdept, sgrade, sdate, sSaup) < 1 then
	//messagebox("조회","조회자료가 없습니다!")
	w_mdi_frame.sle_msg.text = "조회된 자료가 없습니다!"
	setcolumn('sdate')
	setfocus()
	return
end if
dw_4.event RowFocusChanged(1)
end event

event ue_keydown;IF KeyDown(KeyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;call super::itemchanged;string sdate, sDeptCode, sDeptName, sgrade, snull
setnull(snull)

w_mdi_frame.sle_msg.text = ""

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if this.GetColumnName() = 'sdate' then
	sdate = this.gettext()
	if f_datechk(sdate) = -1 then
		messagebox("확인","일자를 확인하십시요!")
		dw_5.setitem(1,'sdate',snull)
		dw_5.setcolumn('sdate')
		dw_5.setfocus()		
		return
	end if
end if

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"deptname",snull)
		EVENT ue_retrieve()
		Return 1
	END IF
	
	SELECT "P0_DEPT"."DEPTNAME"  
   	INTO :sDeptName
   	FROM "P0_DEPT"
   	WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P0_DEPT"."DEPTCODE" = :sDeptCode );
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"deptname",sDeptName)
	ELSE
		MessageBox("확 인","등록되지 않은 부서입니다!!",StopSign!)
		this.SetItem(1,"deptcode",snull)
		this.SetItem(1,"deptname",snull)
		Return 1
	END IF
END IF

EVENT ue_retrieve()
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF this.GetColumnName() ="deptcode" THEN
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	this.SetItem(1,"deptname",gs_codename)	
END IF

EVENT ue_retrieve()
end event

type dw_1 from u_key_enter within w_pik1015_add
event ue_key pbm_dwnkey
integer x = 1915
integer y = 408
integer width = 2309
integer height = 84
integer taborder = 21
string dataobject = "d_pik1015_add_1"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;//F1 key를 누르면 코드조회처리함	

if KeyDown(KeyF1!) then
	TriggerEvent(RbuttonDown!)
end if
end event

event itemchanged;call super::itemchanged;string ls_kdate, ls_yymm, ls_empno, sEmpName, ls_deptname, ls_deptcode, ls_name

sle_msg.text =""

dw_1.accepttext()
//ls_yymm  = Trim(dw_1.Getitemstring(dw_1.getrow(),'myymm')) 
//ls_empno = dw_1.Getitemstring(dw_1.getrow(),'empno')
ls_kdate = ls_yymm + '01'

//처리연월 검사
if this.getcolumnname() = 'myymm' then
	ls_yymm = this.gettext()
	
	IF ls_yymm ='01' OR IsNull(ls_yymm) THEN
	ELSE
		if f_datechk(ls_yymm +'01') = -1 then
			 messagebox("확인","년월을 확인하십시오!")
			 dw_1.setcolumn("myymm")
			 return -1
		end if
	END IF
end if

//사원번호 검사
if this.getcolumnname() = 'empno' then
	ls_empno = this.gettext()
	IF ls_empno ="" OR IsNull(ls_empno) THEN
	ELSE
		SELECT "P1_MASTER"."EMPNAME", "P1_MASTER"."DEPTCODE"  
			INTO :sEmpName, :ls_deptcode
			FROM "P1_MASTER"  
			WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND
					"P1_MASTER"."EMPNO" = :ls_empno ;
		IF sqlca.sqlcode <> 0 THEN
			messagebox("확인","사원번호를 확인하십시오!")
			dw_1.setcolumn("empno")
			return -1
		ELSE
			SELECT "P0_DEPT"."DEPTNAME"  
				INTO :ls_deptname  
				FROM "P0_DEPT"  
				WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
						( "P0_DEPT"."DEPTCODE" = :ls_deptcode )   ;
		END IF
		dw_1.Setitem(1,'empname',sEmpName)
		//dw_1.Setitem(1,'deptcode',ls_deptcode)
		dw_1.Setitem(1,'deptname',ls_deptname)
	
	END IF
end if

if this.getcolumnname() = 'empname' then
	sEmpName = this.gettext()
	 ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
	 return 1
end if

p_inq.TriggerEvent(Clicked!)

end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "empno"  OR this.GetColumnName() = "empname" THEN
	
	Open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	this.SetItem(this.GetRow(),"empno",gs_code)
	this.SetItem(this.GetRow(),"empname",gs_codename)
	dw_1.TriggerEvent(itemchanged!)
END IF
end event

type dw_2 from u_key_enter within w_pik1015_add
event ue_key pbm_dwnkey
integer x = 1929
integer y = 524
integer width = 2309
integer height = 540
integer taborder = 31
string dataobject = "d_pik1015_add_2"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;
choose case key
       case Keytab!

			IF this.RowCount() < il_row THEN
				
				dw_3.SetColumn('mjkcnt')
				dw_3.SetFocus()
				
				il_row = 0
					
			END IF	
		case Keyenter!
				
			IF this.RowCount() < il_row THEN
				
				dw_3.SetColumn('mjkcnt')
				dw_3.SetFocus()
				
				il_row = 0				
					
			END IF	
end choose			
end event

type dw_3 from u_key_enter within w_pik1015_add
integer x = 1934
integer y = 1124
integer width = 2304
integer height = 1024
integer taborder = 41
string dataobject = "d_pik1015_add_3"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event editchanged;call super::editchanged;ib_any_typing =True
end event

type dw_4 from u_d_select_sort within w_pik1015_add
integer x = 398
integer y = 408
integer width = 1230
integer height = 1808
integer taborder = 11
string dataobject = "d_pik1015_add_4"
boolean hscrollbar = false
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;If CurrentRow <= 0 then
	dw_4.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(CurrentRow,TRUE)
	
	dw_1.SetItem(1,'empno',This.GetItemString(CurrentRow,'empno'))
	dw_1.SetItem(1,'empname',This.GetItemString(CurrentRow,'empname'))
	dw_1.SetItem(1,'deptname',This.GetItemString(CurrentRow,'deptname2'))
	
	p_inq.TriggerEvent(Clicked!)
	
	b_flag = False
END IF
end event

