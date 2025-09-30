$PBExportHeader$w_pik1015.srw
$PBExportComments$** 월근태 입력 및 수정
forward
global type w_pik1015 from w_inherite_standard
end type
type dw_4 from u_d_popup_sort within w_pik1015
end type
type dw_1 from datawindow within w_pik1015
end type
type dw_3 from u_d_select_sort within w_pik1015
end type
type p_action from uo_picture within w_pik1015
end type
type rr_5 from roundrectangle within w_pik1015
end type
type rr_3 from roundrectangle within w_pik1015
end type
type dw_6 from u_key_enter within w_pik1015
end type
type dw_5 from u_key_enter within w_pik1015
end type
type dw_2 from u_d_select_sort within w_pik1015
end type
end forward

global type w_pik1015 from w_inherite_standard
string title = "월근태 입력 및 수정"
boolean resizable = false
dw_4 dw_4
dw_1 dw_1
dw_3 dw_3
p_action p_action
rr_5 rr_5
rr_3 rr_3
dw_6 dw_6
dw_5 dw_5
dw_2 dw_2
end type
global w_pik1015 w_pik1015

type variables
Boolean ib_edit_ktcode = false
long il_row

String print_gu                 //window가 조회인지 인쇄인지  

String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false
end variables

forward prototypes
public function integer wf_modify_mkuntae ()
public function integer wf_modify_mkuntaeday ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_modify_mkuntae ();string ls_empno, ls_deptcode, ls_yymm
double ld_kunlo, ld_yunjang, ld_yakun, ld_huil, ld_jktime, ld_jttime, ld_octime, &
		 ld_wchday, ld_ychday, ld_wchdayu, ld_ychdayu
int    li_jkcnt, li_jtcnt, li_occnt, li_sriday, li_sridayu, li_juhuday, li_mchday
long   i, rowcount, cnt

IF dw_3.AcceptText() <> 1 THEN return -1
IF dw_5.AcceptText() <> 1 THEN return -1
ls_yymm = dw_5.GetItemString(dw_5.GetRow(),'sdate')

rowcount = dw_3.RowCount()

IF rowcount > 0 THEN
	FOR i = 1 TO rowcount	
		ls_empno		= dw_3.GetItemString(i,'empno')
		ls_deptcode	= dw_3.GetItemString(i,'deptcode')
		ld_kunlo		= dw_3.GetItemNumber(i,'mklgtime')
		ld_yunjang	= dw_3.GetItemNumber(i,'myjgtime150')
		ld_yakun		= dw_3.GetItemNumber(i,'mykgtimeg')
		ld_huil		= dw_3.GetItemNumber(i,'mhkgtime1')
		ld_jktime	= dw_3.GetItemNumber(i,'mjkgtime')
		ld_jttime	= dw_3.GetItemNumber(i,'mjtgktime')
		ld_octime	= dw_3.GetItemNumber(i,'mocggtime')
		li_jkcnt		= dw_3.GetItemNumber(i,'mjkcnt')
		li_jtcnt		= dw_3.GetItemNumber(i,'mjtcnt')
		li_occnt		= dw_3.GetItemNumber(i,'moccnt')
		ld_wchday	= dw_3.GetItemNumber(i,'mwchday')
		ld_wchdayu	= dw_3.GetItemNumber(i,'mwchdayu')
		ld_ychday	= dw_3.GetItemNumber(i,'mychday')
		ld_ychdayu	= dw_3.GetItemNumber(i,'mychdayu')
		li_sriday	= dw_3.GetItemNumber(i,'msriday')
		li_sridayu	= dw_3.GetItemNumber(i,'msridayu')
		li_juhuday	= dw_3.GetItemNumber(i,'mjuhuday')
		li_mchday	= dw_3.GetItemNumber(i,'mchday')
		
		select count(*)
		  into :cnt
		  from p4_mkuntaetime
		 where companycode = :gs_company and
		 		 myymm = :ls_yymm and
				 empno = :ls_empno;
		if cnt > 0 then
			update p4_mkuntaetime
			   set mklgtime = :ld_kunlo,
					 myjgtime150 = :ld_yunjang,
					 mykgtimeg = :ld_yakun,
					 mhkgtime1 = :ld_huil,
					 mjkgtime = :ld_jktime,
					 mjtgktime = :ld_jttime,
					 mocggtime = :ld_octime,
					 mjkcnt = :li_jkcnt,
					 mjtcnt = :li_jtcnt,
					 moccnt = :li_occnt,
					 mwchday = :ld_wchday,
					 mwchdayu = :ld_wchdayu,
					 mychday = :ld_ychday,
					 mychdayu = :ld_ychdayu,
					 msriday = :li_sriday,
					 msridayu = :li_sridayu,
					 mjuhuday = :li_juhuday,
					 mchday = :li_mchday
			 where companycode = :gs_company and
		 			 myymm = :ls_yymm and
					 empno = :ls_empno;
		else
			INSERT INTO "P4_MKUNTAETIME"  
					( "COMPANYCODE",         "MYYMM",     "DEPTCODE",       "EMPNO",
						  "MKLGTIME",   "MYJGTIME150",    "MYKGTIMEG",   "MHKGTIME1", 
							 "MJKCNT",      "MJKGTIME",       "MJTCNT",   "MJTGKTIME",
							 "MOCCNT",     "MOCGGTIME",      "MWCHDAY",    "MWCHDAYU",
							"MYCHDAY",      "MYCHDAYU",		"MSRIDAY",    "MSRIDAYU",
						  "MJUHUDAY",        "MCHDAY" )  
		  VALUES (   :gs_company,        :ls_yymm,   :ls_deptcode,     :ls_empno,
							:ld_kunlo,     :ld_yunjang,      :ld_yakun,      :ld_huil,
							:li_jkcnt,      :ld_jktime,      :li_jtcnt,    :ld_jttime,
							:li_occnt,      :ld_octime,	  :ld_wchday,   :ld_wchdayu,
						  :ld_ychday,	   :ld_ychdayu,     :li_sriday,    :li_sriday,
						  :li_juhuday,		 :li_mchday  );
		end if
		if sqlca.sqlcode <> 0 then
			MessageBox('DB Error', sqlca.SQLErrText)
			return -1
		end if
	NEXT
END IF

return 1
end function

public function integer wf_modify_mkuntaeday ();string ls_yymm, ls_empno, ls_ktcode, ls_gubn, ls_deptcode,ls_flag
double ld_mday, ld_wolcha, ld_yoncha, ld_saeng
integer i, cnt

ld_wolcha = 0 ; ld_yoncha = 0 ; ld_saeng = 0

dw_5.AcceptText()
ls_yymm  = dw_5.Getitemstring(dw_5.getrow(),'sdate')
ls_empno = dw_3.Getitemstring(dw_3.GetRow(),'empno')

//부서코드
SELECT DEPTCODE
  INTO :ls_deptcode
  FROM P1_MASTER
 WHERE COMPANYCODE = :gs_company AND 
		 EMPNO = :ls_empno;

//기입력자료 여부 확인
SELECT COUNT(*)
  INTO :cnt
  FROM "P4_MKUNTAEDAY"  
 WHERE ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
		 ( "P4_MKUNTAEDAY"."EMPNO" = :ls_empno ) AND  
		 ( "P4_MKUNTAEDAY"."MYYMM" = :ls_yymm ) ;

//기입력자료 삭제처리
IF cnt > 0 THEN
	DELETE FROM "P4_MKUNTAEDAY"  
	 WHERE ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
			 ( "P4_MKUNTAEDAY"."EMPNO" = :ls_empno ) AND  
			 ( "P4_MKUNTAEDAY"."MYYMM" = :ls_yymm ) ;
END IF

// p4_mkuntaeday updaate
dw_2.AcceptText()
for i=1 to dw_2.rowcount()
	ld_mday   = dw_2.Getitemdecimal(i,"mday")
	ls_ktcode = dw_2.Getitemstring(i,"attendancecode")
	ls_gubn   = dw_2.Getitemstring(i,"attendancegubn")

	if ls_gubn = '1' then  //월차일수
		ld_wolcha = ld_mday
	elseif ls_gubn = '2' then  //연차일수
		ld_yoncha = ld_mday
	elseif ls_gubn = '3' then  //생리일수
		ld_saeng = ld_mday
	else
	end if
	
	if ld_mday > 0 then
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
					:ld_mday )  ;
		if sqlca.sqlcode <> 0 then
			return -1
		end if
	end if
next

//월차,연차,생리일수를 p4_mkuntaetime으로 갱신처리 위함	 
dw_3.Setitem(dw_3.GetRow(),'mwchdayu',ld_wolcha)
dw_3.Setitem(dw_3.GetRow(),'mychdayu',ld_yoncha)
dw_3.Setitem(dw_3.GetRow(),'msridayu',ld_saeng)

return 1
end function

public function integer wf_retrieve ();string ls_yymm, ls_fromdate, ls_todate, ls_dept, ls_saup, ls_flag
w_mdi_frame.sle_msg.text =""

dw_5.accepttext()
ls_yymm  = Trim(dw_5.Getitemstring(dw_5.getrow(),'sdate'))
ls_dept  = Trim(dw_5.Getitemstring(dw_5.getrow(),'deptcode'))
ls_saup  = Trim(dw_5.Getitemstring(dw_5.getrow(),'saup'))
ls_fromdate = ls_yymm + '01'

//년월 검사
IF f_datechk(ls_fromdate) = 1 THEN
	ls_todate = f_last_date(ls_yymm)
ELSE
	MessageBox("확 인","작업년월을 확인하세요!")
	dw_5.SetColumn("sdate")
	dw_5.SetFocus()
	Return -1
END IF

IF IsNull(ls_dept) or ls_dept = '' THEN ls_dept = '%'
IF IsNull(ls_saup) or ls_saup = '' THEN ls_saup = '%'

//자료검색
dw_3.SetRedraw(false)
if dw_3.retrieve(gs_company, ls_fromdate, ls_todate, ls_saup, ls_dept) = 0 then
	w_mdi_frame.sle_msg.text = "조회한 자료가 없습니다!"
end if
dw_3.SetRedraw(true)

dw_3.Object.DataWindow.HorizontalScrollSplit = 1198
dw_3.event RowFocusChanged(1)


// 마감이 완료된 월은 수정할수 없다/
IF ls_saup = '%' THEN ls_saup = '10'

SELECT "P4_MFLAG"."GUBN"  
  INTO :ls_flag  
  FROM "P4_MFLAG" 
  where companycode= :gs_company and
  		  myymm = :ls_yymm and
		  saupcd = :ls_saup;	 

if ls_flag = '1' then
	messagebox("확인","마감이 완료된 월입니다. 마감 취소후 작업하세요.")
	p_mod.Enabled = False
	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
else
	p_mod.Enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"	
end if	

ib_any_typing =False
p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"

return 1
end function

event open;call super::open;w_mdi_frame.sle_msg.text =""

ib_any_typing=False

dw_datetime.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_6.SetTransObject(SQLCA)

dw_5.insertrow(0)
dw_6.insertrow(0)

/*사업장 정보 셋팅*/
f_set_saupcd(dw_5,'saup','1')
is_saupcd = gs_saupcd
dw_5.setitem(1,'sdate', Left(gs_today,6))

p_inq.TriggerEvent(Clicked!)

p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"

end event

on w_pik1015.create
int iCurrent
call super::create
this.dw_4=create dw_4
this.dw_1=create dw_1
this.dw_3=create dw_3
this.p_action=create p_action
this.rr_5=create rr_5
this.rr_3=create rr_3
this.dw_6=create dw_6
this.dw_5=create dw_5
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_4
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.p_action
this.Control[iCurrent+5]=this.rr_5
this.Control[iCurrent+6]=this.rr_3
this.Control[iCurrent+7]=this.dw_6
this.Control[iCurrent+8]=this.dw_5
this.Control[iCurrent+9]=this.dw_2
end on

on w_pik1015.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_4)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.p_action)
destroy(this.rr_5)
destroy(this.rr_3)
destroy(this.dw_6)
destroy(this.dw_5)
destroy(this.dw_2)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1015
end type

event p_mod::clicked;call super::clicked;
string ls_yymm, ls_flag, ls_saup

dw_5.AcceptText()
ls_saup = dw_5.Getitemstring(dw_5.getrow(),'saup')
ls_yymm = dw_5.Getitemstring(dw_5.getrow(),'sdate')

IF IsNull(ls_saup) OR ls_saup = '' THEN ls_saup = '%'

//년월 검사
IF ls_yymm = "" OR IsNull(ls_yymm) THEN
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


SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text ="자료를 저장하고 있습니다......."

// p4_mkuntaeday upate
if wf_modify_mkuntaeday() = -1 then
	rollback;
	messagebox("근태일수","자료저장에 실패하였습니다!")
	ib_any_typing = False
	ib_edit_ktcode = False
	return
end if

// p4_mkuntaetime upate
if wf_modify_mkuntae() = -1 then
	rollback;
	messagebox("근태시간","자료저장에 실패하였습니다!")
	ib_any_typing = False
	ib_edit_ktcode = False
	return
end if


commit;

//dw_3.reset()
ib_any_typing = False
ib_edit_ktcode = False

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text ="자료가 저장되었습니다!"

p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"
p_inq.Triggerevent(Clicked!)
end event

type p_del from w_inherite_standard`p_del within w_pik1015
end type

event p_del::clicked;call super::clicked;
string ls_yymm, ls_empno, ls_ktcode 
long ll_cnt, i

if dw_3.AcceptText() = -1 then return
ll_cnt = dw_3.RowCount()
IF ll_cnt <=0 THEN RETURN

IF MessageBox("확 인","선택한 자료(들)를 삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

FOR i = ll_cnt TO 1 STEP -1
	IF dw_3.IsSelected(i) THEN
		ls_yymm  = dw_3.Getitemstring(i,'myymm')
		ls_empno = dw_3.Getitemstring(i,'empno')

		/* 시간 집계 table 삭제*/
		DELETE FROM "P4_MKUNTAETIME"  
			WHERE ( "P4_MKUNTAETIME"."COMPANYCODE" = :gs_company ) AND  
					( "P4_MKUNTAETIME"."EMPNO" = :ls_empno ) AND  
					( "P4_MKUNTAETIME"."MYYMM" = :ls_yymm ) ;
	
		/* 일수 집계 table 삭제*/
		DELETE FROM "P4_MKUNTAEDAY"
			WHERE ( "P4_MKUNTAEDAY"."COMPANYCODE" = :gs_company ) AND  
					( "P4_MKUNTAEDAY"."EMPNO" = :ls_empno ) AND  
					( "P4_MKUNTAEDAY"."MYYMM" = :ls_yymm ) ;

		
//		dw_3.DeleteRow(i)
	END IF
NEXT
IF SQLCA.SQLCODE <> 0 THEN
			rollback;
			MessageBox('실패','자료 삭제에 실패하였습니다!!')
			return
		END if

commit;
p_inq.TriggerEvent(Clicked!)
w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"

ib_any_typing =False
p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"


end event

type p_inq from w_inherite_standard`p_inq within w_pik1015
integer x = 3689
end type

event p_inq::clicked;call super::clicked;wf_retrieve()
end event

type p_print from w_inherite_standard`p_print within w_pik1015
boolean visible = false
integer x = 1920
integer y = 2380
end type

type p_can from w_inherite_standard`p_can within w_pik1015
end type

event p_can::clicked;call super::clicked;ib_any_typing =False

dw_2.reset()
dw_3.reset()
dw_1.setcolumn("myymm")
dw_1.Setfocus()

ib_any_typing =False
PictureName = "C:\erpman\image\취소_d.gif"
end event

type p_exit from w_inherite_standard`p_exit within w_pik1015
end type

event p_exit::clicked;w_mdi_frame.sle_msg.text =""

IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)
end event

type p_ins from w_inherite_standard`p_ins within w_pik1015
boolean visible = false
integer x = 2094
integer y = 2380
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

type p_search from w_inherite_standard`p_search within w_pik1015
boolean visible = false
integer x = 1742
integer y = 2380
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1015
boolean visible = false
integer x = 2267
integer y = 2380
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1015
boolean visible = false
integer x = 2441
integer y = 2380
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1015
boolean visible = false
integer x = 1481
integer y = 2388
end type

type st_window from w_inherite_standard`st_window within w_pik1015
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1015
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1015
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1015
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1015
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1015
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1015
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1015
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1015
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1015
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1015
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1015
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1015
boolean visible = false
end type

type dw_4 from u_d_popup_sort within w_pik1015
boolean visible = false
integer x = 2615
integer y = 2688
integer width = 590
integer height = 180
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_pik1015_add_4"
boolean vscrollbar = true
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

type dw_1 from datawindow within w_pik1015
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
boolean visible = false
integer x = 2437
integer y = 2848
integer width = 2011
integer height = 84
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_pik1015_add_1"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;//F1 key를 누르면 코드조회처리함	

if KeyDown(KeyF1!) then
	TriggerEvent(RbuttonDown!)
end if
end event

event itemchanged;string ls_kdate, ls_yymm, ls_empno, ls_empname, ls_deptname, ls_deptcode

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
			INTO :ls_empname, :ls_deptcode
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
		dw_1.Setitem(1,'empname',ls_empname)
		//dw_1.Setitem(1,'deptcode',ls_deptcode)
		dw_1.Setitem(1,'deptname',ls_deptname)
	
	END IF
end if

if this.getcolumnname() = 'empname' then
	ls_empname = this.gettext()
	IF ls_empname ="" OR IsNull(ls_empname) THEN
	ELSE
		SELECT "P1_MASTER"."EMPNO", "P1_MASTER"."DEPTCODE"  
			INTO :ls_empno, :ls_deptcode
			FROM "P1_MASTER"  
			WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND
					"P1_MASTER"."EMPNAME" = :ls_empname ;
		IF sqlca.sqlcode <> 0 THEN
			messagebox("확인","성명을 확인하십시오!")
			dw_1.setcolumn("empname")
			return -1
		ELSE
			SELECT "P0_DEPT"."DEPTNAME"  
				INTO :ls_deptname  
				FROM "P0_DEPT"  
				WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
						( "P0_DEPT"."DEPTCODE" = :ls_deptcode )   ;
		END IF
		dw_1.Setitem(1,'empno',ls_empno)
		//dw_1.Setitem(1,'deptcode',ls_deptcode)
		dw_1.Setitem(1,'deptname',ls_deptname)
	
	END IF
end if

p_inq.TriggerEvent(Clicked!)

end event

event itemerror;Return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "empno"  OR this.GetColumnName() = "empname" THEN
	
	Open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	this.SetItem(this.GetRow(),"empno",gs_code)
	this.SetItem(this.GetRow(),"empname",gs_codename)
	dw_1.TriggerEvent(itemchanged!)
END IF
end event

type dw_3 from u_d_select_sort within w_pik1015
event ue_pressenter pbm_dwnprocessenter
integer x = 9
integer y = 268
integer width = 3822
integer height = 1980
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pik1015_3"
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing =True
end event

event rowfocuschanged;string ls_yymm, ls_empno, snull
SetNull(snull)

if currentrow > 0 then
	dw_5.AcceptText()
	this.AcceptText()
	
	ls_yymm = dw_5.GetItemString(dw_5.GetRow(),'sdate')
	ls_empno = GetItemString(currentrow,'empno')
	
	if f_datechk(ls_yymm+'01') = -1 then
		messagebox("확인","일자를 확인하십시요!")
		dw_5.setitem(1,'sdate',snull)
		dw_5.setcolumn('sdate')
		dw_5.setfocus()		
		return
	end if
	
	selectRow(0,false)
	selectRow(currentrow,true)
	
	dw_2.SetRedraw(false)
	dw_2.retrieve(gs_company, ls_yymm, ls_empno)
	dw_2.SetRedraw(true)
	this.Setfocus()
end if
end event

event rowfocuschanging;call super::rowfocuschanging;if ib_edit_ktcode then
	string ls_empname, ls_yymm, ls_flag
	
	AcceptText()
	ls_empname = GetItemString(currentrow,'empname')
	if MessageBox('확인','사원 '+ls_empname+'의 근태자료가 수정되었습니다.   '+&
					  '~r~r수정된 근태자료를 저장하시겠습니까?', Question!, YesNo!) = 1 then

		ls_yymm  = dw_5.Getitemstring(dw_5.getrow(),'sdate')
		
		//년월 검사
		IF ls_yymm = "" OR IsNull(ls_yymm) THEN
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
		
		// 마감이 완료된 월은 수정할수 없다/
		SELECT "P4_MFLAG"."GUBN"  
		  INTO :ls_flag
		  FROM "P4_MFLAG" 
		  where companycode= :gs_company and myymm = :ls_yymm;
		if ls_flag = '1' then
			messagebox("확인","마감이 완료된 월 입니다.!!")
			return
		end if

		if wf_modify_mkuntaeday() = -1 then
			rollback;
			messagebox("근태일수",ls_empname+'의 근태자료 저장에 실패하였습니다!!')
		else
			commit;
		end if

	end if
	ib_edit_ktcode = false
end if
end event

type p_action from uo_picture within w_pik1015
integer x = 2235
integer y = 68
integer width = 178
integer taborder = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\일괄적용_up.gif"
end type

event clicked;long		i, ll_row
int		li_kltime, li_juhuday

w_mdi_frame.sle_msg.text=""

dw_6.AcceptText()

li_kltime = dw_6.GetItemNumber(1,'kltime')
li_juhuday = dw_6.GetItemNumber(1,'juhuday')
ll_row = dw_3.RowCount()
	
FOR i = 1 to ll_row
	dw_3.SetItem(i,'mklgtime',li_kltime)
	dw_3.SetItem(i,'mjuhuday',li_juhuday)
Next
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄적용_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄적용_up.gif"
end event

type rr_5 from roundrectangle within w_pik1015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 260
integer width = 3845
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pik1015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3863
integer y = 260
integer width = 731
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_6 from u_key_enter within w_pik1015
integer x = 1669
integer y = 28
integer width = 832
integer height = 224
integer taborder = 11
string dataobject = "d_pik1015_4"
boolean border = false
borderstyle borderstyle = styleraised!
end type

event itemchanged;call super::itemchanged;String	ls_SetValue
long		i, ll_row

w_mdi_frame.sle_msg.text=""

ls_SetValue = this.GetText()
ll_row = dw_2.RowCount()

choose case(dw_3.GetColumnName())
	case 'chtime'
		FOR i = 1 to ll_row
			dw_2.SetItem(i,'cktime',Long(ls_SetValue))
		Next

	case 'tgtime'
		FOR i = 1 to ll_row
			dw_2.SetItem(i,'tktime',Long(ls_SetValue))
		Next
end choose
end event

type dw_5 from u_key_enter within w_pik1015
event ue_keydown pbm_dwnkey
integer x = 5
integer y = 16
integer width = 1600
integer height = 244
integer taborder = 11
string title = "none"
string dataobject = "d_pik1015_1"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

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
	if f_datechk(sdate+'01') = -1 then
		messagebox("확인","일자를 확인하십시요!")
		dw_5.setitem(dw_5.getrow(),'sdate',snull)
		dw_5.setcolumn('sdate')
		dw_5.setfocus()		
		return
	end if
end if

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"deptname",snull)
	ELSE
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
END IF

p_inq.TriggerEvent(Clicked!)
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

IF this.GetColumnName() ="deptcode" THEN
	gs_gubun = Trim(GetItemString(1,'saup'))
	IF IsNull(gs_gubun) OR gs_gubun = '' THEN gs_gubun = '%'
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	TriggerEvent(Itemchanged!)
END IF
end event

type dw_2 from u_d_select_sort within w_pik1015
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 3877
integer y = 268
integer width = 709
integer height = 1980
integer taborder = 11
string dataobject = "d_pik1015_2"
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

event ue_pressenter;Send(Handle(this), 256, 9, 0)
Return 1
end event

event editchanged;call super::editchanged;ib_edit_ktcode = true
end event

event itemchanged;call super::itemchanged;double ld_mday
string ls_gubn

AcceptText()
ld_mday   = dw_2.Getitemdecimal(row,"mday")
ls_gubn   = dw_2.Getitemstring(row,"attendancegubn")
		

//월차,연차,생리일수를 p4_mkuntaetime으로 갱신처리 위함	
if ls_gubn = '1' then  //월차일수
	dw_3.Setitem(dw_3.GetRow(),'mwchdayu',ld_mday)

elseif ls_gubn = '2' then  //연차일수
	dw_3.Setitem(dw_3.GetRow(),'mychdayu',ld_mday)

elseif ls_gubn = '3' then  //생리일수
	dw_3.Setitem(dw_3.GetRow(),'msridayu',ld_mday)
end if

end event

event rowfocuschanged;call super::rowfocuschanged;selectRow(0,false)
selectRow(currentrow,true)
end event

