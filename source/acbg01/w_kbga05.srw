$PBExportHeader$w_kbga05.srw
$PBExportComments$예산부서등록
forward
global type w_kbga05 from w_inherite
end type
type cb_copy from commandbutton within w_kbga05
end type
type dw_1 from u_d_popup_sort within w_kbga05
end type
type dw_2 from datawindow within w_kbga05
end type
type dw_3 from datawindow within w_kbga05
end type
type rr_1 from roundrectangle within w_kbga05
end type
type rr_2 from roundrectangle within w_kbga05
end type
end forward

global type w_kbga05 from w_inherite
string title = "예산부서등록"
cb_copy cb_copy
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
rr_1 rr_1
rr_2 rr_2
end type
global w_kbga05 w_kbga05

type variables
string is_status
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_2 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/
If ib_any_typing = true then     			//EditChanged Event(dw_2)의 typing 상태확인
	
	Beep(1)
	
	If MessageBox("확인 : " + as_titletext , &
		  "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까?", &
		  question!, yesno! ) = 1 then
		  
		  dw_2.SetFocus()				//yes일 경우 : focus 'dw_2'
		  Return -1
	End If

END IF
																
RETURN 1												// (dw_2) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

on w_kbga05.create
int iCurrent
call super::create
this.cb_copy=create cb_copy
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copy
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.dw_3
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_kbga05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_copy)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_1.InsertRow(0)
dw_1.Retrieve()

dw_2.SetTransObject(sqlca)
dw_2.InsertRow(0)

dw_3.SetTransObject(sqlca)
dw_3.Retrieve()

p_del.enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

dw_2.Setfocus()

is_status = 'I'


end event

type dw_insert from w_inherite`dw_insert within w_kbga05
boolean visible = false
integer x = 73
integer y = 2384
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kbga05
boolean visible = false
integer y = 3044
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbga05
boolean visible = false
integer y = 3044
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbga05
integer x = 3575
integer taborder = 70
string picturename = "C:\Erpman\image\부서코드복사_up.gif"
end type

event p_search::clicked;call super::clicked;If dw_1.AcceptText() = -1 then Return

If MessageBox("자료복사","인사관리 부서코드로부터 추가된 자료를 받으시겠습니까?", question!, yesno!, 2) = 2 Then 
	Return
End If

dw_1.SetRedraw(false)

w_mdi_frame.sle_msg.text = "자료 복사중입니다!!"

Setpointer(hourglass!)


// KFE03OM0 와 P0_DEPT 의 차이부서코드(P0_DEPT) => INSERT 대상
//KFE03OM0 와 KFZ04OM0 의 차이부서코드(KFZ04OM0) => INSERT 대상
INSERT INTO "KFE03OM0"
  ( "DEPTCODE", "DEPTNAME", "DEPTNAME2", "SAUPCD", "UPDEPT", "USETAG" )
  SELECT "P0_DEPT"."DEPTCODE",
  	      "P0_DEPT"."DEPTNAME",
         "P0_DEPT"."DEPTNAME2",
         "P0_DEPT"."SAUPCD",   
         "P0_DEPT"."UPDEPT",
         "P0_DEPT"."USETAG"
    FROM "P0_DEPT"
   WHERE "P0_DEPT"."DEPTCODE" IN ( SELECT "P0_DEPT"."DEPTCODE"  FROM "P0_DEPT" 
                         			  WHERE "P0_DEPT"."COMPANYCODE" = :gs_company AND "P0_DEPT"."USETAG" = '1' 
	                         		  MINUS
   	                     		  SELECT "KFE03OM0"."DEPTCODE" FROM "KFE03OM0" ) ;
								 
IF SQLCA.SQLCODE <> 0 THEN RETURN

INSERT INTO "KFZ04OM0"
  ( "PERSON_CD", "PERSON_NM", "PERSON_GU", "PERSON_NO", "PERSON_BNK", "PERSON_STS", "PERSON_AC1", "PERSON_CD2", "PERSON_TX" )
  SELECT "KFE03OM0"."DEPTCODE",
         "KFE03OM0"."DEPTNAME2",
			'10',
         "KFE03OM0"."UPDEPT",
			' ',
         "KFE03OM0"."USETAG",
			' ', ' ', ' '
    FROM "KFE03OM0"
   WHERE "DEPTCODE" IN ( SELECT "KFE03OM0"."DEPTCODE"  FROM "KFE03OM0" 
                         			   WHERE "KFE03OM0"."USETAG" = '1' 
	                         		   MINUS
   	                     		   SELECT "KFZ04OM0"."PERSON_CD" FROM "KFZ04OM0" ) ;
												
IF SQLCA.SQLCODE <> 0 THEN RETURN

// KFE03OM0 와 P0_DEPT 의 차이부서코드(P0_DEPT) => UPDATE 대상
// KFE03OM0 와 KFZ04OM0 의 차이부서코드(KFZ04OM0) => UPDATE 대상
UPDATE "KFE03OM0"
   SET "DEPTNAME"  = ( SELECT "DEPTNAME" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" ) ,
	    "DEPTNAME2" = ( SELECT "DEPTNAME2" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" ) ,
		 "SAUPCD"    = ( SELECT "SAUPCD" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" ) ,
		 "UPDEPT"    = ( SELECT "UPDEPT" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" ) ,
		 "USETAG"    = ( SELECT "USETAG" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" )
 WHERE "DEPTCODE" IN ( SELECT "KFE03OM0"."DEPTCODE" FROM "KFE03OM0" 
                        INTERSECT
                       SELECT "P0_DEPT"."DEPTCODE"  FROM "P0_DEPT" 
                        WHERE "P0_DEPT"."COMPANYCODE" = 'KN' AND "P0_DEPT"."USETAG" = '1' ) ;

UPDATE "KFZ04OM0"
   SET "PERSON_NM"  = ( SELECT "DEPTNAME2" FROM "KFE03OM0" 
                        WHERE "DEPTCODE" = "KFZ04OM0"."PERSON_CD" ) ,
		 "PERSON_NO"  = ( SELECT "UPDEPT" FROM "KFE03OM0" 
                        WHERE "DEPTCODE" = "KFZ04OM0"."PERSON_CD" ) ,
		 "PERSON_STS" = ( SELECT "USETAG" FROM "KFE03OM0" 
                        WHERE "DEPTCODE" = "KFZ04OM0"."PERSON_CD" ) 
 WHERE "PERSON_CD" IN ( SELECT "KFZ04OM0"."PERSON_CD" FROM "KFZ04OM0" 
                        INTERSECT
                       SELECT "KFE03OM0"."DEPTCODE"  FROM "KFE03OM0" 
                        WHERE "KFE03OM0"."USETAG" = '1' ) ;
						 
If sqlca.sqlcode <> 0 Then
	rollback;
  	w_mdi_frame.sle_msg.text = "자료 저장 도중 에러가 발생하였습니다."
Else
	Commit;
	p_can.TriggerEvent(Clicked!)
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다.!!"
End If

dw_1.SetRedraw(true)

IF SQLCA.SQLCODE <> 0 THEN
	ROLLBACK ;
  	w_mdi_frame.sle_msg.text = "자료 복사 도중 에러가 발생하였습니다."
	RETURN
ELSE
	p_can.TriggerEvent(Clicked!)
	dw_1.Retrieve()
	w_mdi_frame.sle_msg.text = "자료가 복사되었습니다.!!"
	COMMIT ;
END IF
end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\부서코드복사_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\부서코드복사_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kbga05
integer x = 3749
end type

event p_ins::clicked;call super::clicked;//* 저장하지 않고 종료할 경우 에러 메세지 발생시킨다 *//

If wf_warndataloss("확인") = -1 then Return

is_status = 'I'
w_mdi_frame.sle_msg.text = "등록"

///////////////////////////////////////////////
dw_2.setredraw(false)

dw_2.reset()
dw_2.insertrow(0)

dw_2.SetTabOrder(1, 10)
dw_2.SetColumn(1)

dw_2.SetFocus()

dw_2.setredraw(true)
///////////////////////////////////////////////

p_ins.enabled = true							
p_ins.PictureName = "C:\erpman\image\추가_up.gif"
p_del.enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

ib_any_typing = false		//일단은 입력상태를 ZERO로 인식시킨다

end event

type p_exit from w_inherite`p_exit within w_kbga05
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kbga05
integer taborder = 50
end type

event p_can::clicked;call super::clicked;is_status = 'I'
w_mdi_frame.sle_msg.text = ""

///////////////////////////////////////////////
dw_2.setredraw(false)

dw_2.reset()
dw_2.insertrow(0)

dw_2.SetTabOrder(1, 10)
dw_2.SetColumn(1)

dw_2.SetFocus()

dw_2.setredraw(true)

dw_1.SelectRow(0, false)
///////////////////////////////////////////////

p_ins.enabled = true							
p_ins.PictureName = "C:\erpman\image\추가_up.gif"
p_del.enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"


ib_any_typing = false

end event

type p_print from w_inherite`p_print within w_kbga05
boolean visible = false
integer y = 3044
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kbga05
boolean visible = false
integer y = 3044
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kbga05
integer taborder = 40
end type

event p_del::clicked;call super::clicked;String ls_deptcode
Long ll_cnt

If dw_2.AcceptText() = -1 then Return

Beep(1)

ls_deptcode = dw_2.GetItemString(1, 'deptcode')

Select Count(*) Into :ll_cnt
From kfe01om0
Where dept_cd = :ls_deptcode ;

If sqlca.sqlcode = 0 and ll_cnt <> 0 then
	MessageBox("확 인", "예산배정자료가 존재하여 삭제할 수 없습니다.!! ~n~r" &
	                    + "예산배정자료를 확인하시고 삭제하십시오.!!" )
	Return
End If

Select Count(*) Into :ll_cnt
From kfe03om0
Where deptcode = :ls_deptcode ;

If sqlca.sqlcode <> 0 then
	MessageBox("확 인", "자료를 입력하지 않았거나, ~n~r" 	& 
	                    + "해당하는 자료가 없습니다." )
	Return 
End if

IF F_dbConFirm('삭제') = 2 THEN RETURN

dw_2.SetRedraw(False)
dw_2.DeleteRow(0)

IF dw_2.Update() > 0	 THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_messagechk(12,'')
	dw_2.SetRedraw(True)
	Return
END IF

dw_1.Retrieve()

dw_2.SetRedraw(True)
p_can.TriggerEvent(clicked!)   

end event

type p_mod from w_inherite`p_mod within w_kbga05
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;String ls_deptcode, ls_deptname, ls_deptname2, ls_saupcd, ls_updept, ls_usetag, snull
Long ll_row, ll_rowcnt, i

If dw_2.AcceptText() = -1 then Return

ls_deptcode = dw_2.Getitemstring(1, 'deptcode')
ls_deptname = dw_2.Getitemstring(1, 'deptname')
ls_deptname2 = dw_2.Getitemstring(1, 'deptname2')
ls_saupcd = dw_2.Getitemstring(1, 'saupcd')
ls_updept = dw_2.Getitemstring(1, 'updept')
ls_usetag = dw_2.Getitemstring(1, 'usetag')

If ls_deptcode = '' or Isnull(ls_deptcode) then
	f_messagechk( 1, '[예산부서코드]')
	dw_2.Setcolumn('deptcode')
	dw_2.Setfocus()
	Return 1
End If
	
If ls_deptname = '' or Isnull(ls_deptname) then
	f_messagechk( 1, '[예산부서명]')
	dw_2.Setcolumn('deptname')
	dw_2.Setfocus()
	Return 1
End If

If ls_deptname2 = '' or Isnull(ls_deptname2) then
	f_messagechk( 1, '[예산부서약명]')
	dw_2.Setcolumn('deptname2')
	dw_2.Setfocus()
	Return 1
End If

If ls_saupcd = '' or Isnull(ls_saupcd) then
	f_messagechk( 1, '[사업장]')
	dw_2.Setcolumn('saupcd')
	dw_2.Setfocus()
	Return 1
End If

If ls_usetag = '' or Isnull(ls_usetag) then
	f_messagechk( 1, '[사용여부]')
	dw_2.Setcolumn('usetag')
	dw_2.Setfocus()
	Return 1
End If

w_mdi_frame.sle_msg.text = "자료 저장중입니다!!"
Setpointer(hourglass!)

If dw_2.Update() = 1 then
	Commit ;
Else 
	Rollback ;
End If

dw_1.Retrieve()

ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_kbga05
boolean visible = false
integer x = 2519
integer y = 3076
end type

type cb_mod from w_inherite`cb_mod within w_kbga05
boolean visible = false
integer x = 1463
integer y = 3076
end type

event cb_mod::clicked;call super::clicked;String ls_deptcode, ls_deptname, ls_deptname2, ls_saupcd, ls_updept, ls_usetag, snull
Long ll_row, ll_rowcnt, i

If dw_2.AcceptText() = -1 then Return

ls_deptcode = dw_2.Getitemstring(1, 'deptcode')
ls_deptname = dw_2.Getitemstring(1, 'deptname')
ls_deptname2 = dw_2.Getitemstring(1, 'deptname2')
ls_saupcd = dw_2.Getitemstring(1, 'saupcd')
ls_updept = dw_2.Getitemstring(1, 'updept')
ls_usetag = dw_2.Getitemstring(1, 'usetag')

If ls_deptcode = '' or Isnull(ls_deptcode) then
	f_messagechk( 1, '[예산부서코드]')
	dw_2.Setcolumn('deptcode')
	dw_2.Setfocus()
	Return 1
End If
	
If ls_deptname = '' or Isnull(ls_deptname) then
	f_messagechk( 1, '[예산부서명]')
	dw_2.Setcolumn('deptname')
	dw_2.Setfocus()
	Return 1
End If

If ls_deptname2 = '' or Isnull(ls_deptname2) then
	f_messagechk( 1, '[예산부서약명]')
	dw_2.Setcolumn('deptname2')
	dw_2.Setfocus()
	Return 1
End If

If ls_saupcd = '' or Isnull(ls_saupcd) then
	f_messagechk( 1, '[사업장]')
	dw_2.Setcolumn('saupcd')
	dw_2.Setfocus()
	Return 1
End If

If ls_usetag = '' or Isnull(ls_usetag) then
	f_messagechk( 1, '[사용여부]')
	dw_2.Setcolumn('usetag')
	dw_2.Setfocus()
	Return 1
End If

sle_msg.text = "자료 저장중입니다!!"
Setpointer(hourglass!)

If dw_2.Update() = 1 then
	Commit ;
Else 
	Rollback ;
End If


//KFE03OM0 와 KFZ04OM0 의 차이부서코드(KFZ04OM0) => INSERT 대상
INSERT INTO "KFZ04OM0"
  ( "PERSON_CD", "PERSON_NM", "PERSON_GU", "PERSON_NO", "PERSON_BNK", "PERSON_STS", "PERSON_AC1", "PERSON_CD2", "PERSON_TX" )
  SELECT "KFE03OM0"."DEPTCODE",
         "KFE03OM0"."DEPTNAME2",
			'10',
         "KFE03OM0"."UPDEPT",
			' ',
         "KFE03OM0"."USETAG",
			' ', ' ', ' '
    FROM "KFE03OM0"
   WHERE "DEPTCODE" IN ( SELECT "KFE03OM0"."DEPTCODE"  FROM "KFE03OM0" 
                         			   WHERE "KFE03OM0"."USETAG" = '1' 
	                         		   MINUS
   	                     		   SELECT "KFZ04OM0"."PERSON_CD" FROM "KFZ04OM0" ) ;
												
IF SQLCA.SQLCODE <> 0 THEN RETURN

// KFE03OM0 와 KFZ04OM0 의 차이부서코드(KFZ04OM0) => UPDATE 대상
UPDATE "KFZ04OM0"
   SET "PERSON_NM"  = ( SELECT "DEPTNAME2" FROM "KFE03OM0" 
                        WHERE "DEPTCODE" = "KFZ04OM0"."PERSON_CD" ) ,
		 "PERSON_NO"  = ( SELECT "UPDEPT" FROM "KFE03OM0" 
                        WHERE "DEPTCODE" = "KFZ04OM0"."PERSON_CD" ) ,
		 "PERSON_STS" = ( SELECT "USETAG" FROM "KFE03OM0" 
                        WHERE "DEPTCODE" = "KFZ04OM0"."PERSON_CD" ) 
 WHERE "PERSON_CD" IN ( SELECT "KFZ04OM0"."PERSON_CD" FROM "KFZ04OM0" 
                        INTERSECT
                       SELECT "KFE03OM0"."DEPTCODE"  FROM "KFE03OM0" 
                        WHERE "KFE03OM0"."USETAG" = '1' ) ;
						 
If sqlca.sqlcode <> 0 Then
	rollback;
  	sle_msg.text = "자료 저장 도중 에러가 발생하였습니다."
Else
	Commit;
	cb_can.TriggerEvent(Clicked!)
	sle_msg.text = "자료가 저장되었습니다.!!"
End If

dw_1.Retrieve()

ib_any_typing = false
end event

type cb_ins from w_inherite`cb_ins within w_kbga05
boolean visible = false
integer x = 1111
integer y = 3076
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;//* 저장하지 않고 종료할 경우 에러 메세지 발생시킨다 *//

If wf_warndataloss("확인") = -1 then Return

is_status = 'I'
sle_msg.text = "등록"

///////////////////////////////////////////////
dw_2.setredraw(false)

dw_2.reset()
dw_2.insertrow(0)

dw_2.SetTabOrder(1, 10)
dw_2.SetColumn(1)

dw_2.SetFocus()

dw_2.setredraw(true)
///////////////////////////////////////////////

cb_ins.enabled = true							
cb_del.enabled = false

ib_any_typing = false		//일단은 입력상태를 ZERO로 인식시킨다

end event

type cb_del from w_inherite`cb_del within w_kbga05
boolean visible = false
integer x = 1815
integer y = 3076
end type

event cb_del::clicked;call super::clicked;String ls_deptcode
Long ll_cnt

If dw_2.AcceptText() = -1 then Return

Beep(1)

ls_deptcode = dw_2.GetItemString(1, 'deptcode')

Select Count(*) Into :ll_cnt
From kfe01om0
Where dept_cd = :ls_deptcode ;

If sqlca.sqlcode = 0 and ll_cnt <> 0 then
	MessageBox("확 인", "예산배정자료가 존재하여 삭제할 수 없습니다.!! ~n~r" &
	                    + "예산배정자료를 확인하시고 삭제하십시오.!!" )
	Return
End If

Select Count(*) Into :ll_cnt
From kfe03om0
Where deptcode = :ls_deptcode ;

If sqlca.sqlcode <> 0 then
	MessageBox("확 인", "자료를 입력하지 않았거나, ~n~r" 	& 
	                    + "해당하는 자료가 없습니다." )
	Return 
End if

IF F_dbConFirm('삭제') = 2 THEN RETURN

dw_2.SetRedraw(False)
dw_2.DeleteRow(0)

UPDATE "KFZ04OM0"
   SET "PERSON_STS" = '2'
 WHERE "PERSON_CD" IN ( SELECT "KFZ04OM0"."PERSON_CD" FROM "KFZ04OM0" 
                        INTERSECT
                       SELECT "KFE03OM0"."DEPTCODE"  FROM "KFE03OM0" 
                        WHERE "KFE03OM0"."USETAG" = '1' ) ;

IF dw_2.Update() > 0	 THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_messagechk(12,'')
	dw_2.SetRedraw(True)
	Return
END IF

dw_1.Retrieve()

dw_2.SetRedraw(True)
cb_can.TriggerEvent(clicked!)   

end event

type cb_inq from w_inherite`cb_inq within w_kbga05
boolean visible = false
integer x = 1632
integer y = 2572
end type

type cb_print from w_inherite`cb_print within w_kbga05
integer x = 2523
integer y = 2580
end type

type st_1 from w_inherite`st_1 within w_kbga05
integer x = 69
integer y = 2908
end type

type cb_can from w_inherite`cb_can within w_kbga05
boolean visible = false
integer x = 2167
integer y = 3076
end type

event cb_can::clicked;call super::clicked;is_status = 'I'
sle_msg.text = ""

///////////////////////////////////////////////
dw_2.setredraw(false)

dw_2.reset()
dw_2.insertrow(0)

dw_2.SetTabOrder(1, 10)
dw_2.SetColumn(1)

dw_2.SetFocus()

dw_2.setredraw(true)

dw_1.SelectRow(0, false)
///////////////////////////////////////////////

cb_ins.enabled = true							
cb_del.enabled = false

ib_any_typing = false

end event

type cb_search from w_inherite`cb_search within w_kbga05
integer x = 2016
integer y = 2572
end type

type dw_datetime from w_inherite`dw_datetime within w_kbga05
integer x = 2912
integer y = 2908
end type

type sle_msg from w_inherite`sle_msg within w_kbga05
integer x = 421
integer y = 2908
end type

type gb_10 from w_inherite`gb_10 within w_kbga05
integer x = 50
integer y = 2856
end type

type gb_button1 from w_inherite`gb_button1 within w_kbga05
boolean visible = false
integer x = 192
integer y = 3048
integer width = 713
end type

type gb_button2 from w_inherite`gb_button2 within w_kbga05
boolean visible = false
integer x = 1079
integer y = 3024
integer width = 1806
end type

type cb_copy from commandbutton within w_kbga05
boolean visible = false
integer x = 1819
integer y = 2464
integer width = 635
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "부서코드복사(&W)"
end type

event clicked;If dw_1.AcceptText() = -1 then Return

If MessageBox("자료복사","인사관리 부서코드로부터 추가된 자료를 받으시겠습니까?", question!, yesno!, 2) = 2 Then 
	Return
End If

dw_1.SetRedraw(false)

sle_msg.text = "자료 복사중입니다!!"

Setpointer(hourglass!)


// KFE03OM0 와 P0_DEPT 의 차이부서코드(P0_DEPT) => INSERT 대상
//KFE03OM0 와 KFZ04OM0 의 차이부서코드(KFZ04OM0) => INSERT 대상
INSERT INTO "KFE03OM0"
  ( "DEPTCODE", "DEPTNAME", "DEPTNAME2", "SAUPCD", "UPDEPT", "USETAG" )
  SELECT "P0_DEPT"."DEPTCODE",
  	      "P0_DEPT"."DEPTNAME",
         "P0_DEPT"."DEPTNAME2",
         "P0_DEPT"."SAUPCD",   
         "P0_DEPT"."UPDEPT",
         "P0_DEPT"."USETAG"
    FROM "P0_DEPT"
   WHERE "P0_DEPT"."DEPTCODE" IN ( SELECT "P0_DEPT"."DEPTCODE"  FROM "P0_DEPT" 
                         			  WHERE "P0_DEPT"."COMPANYCODE" = :gs_company AND "P0_DEPT"."USETAG" = '1' 
	                         		  MINUS
   	                     		  SELECT "KFE03OM0"."DEPTCODE" FROM "KFE03OM0" ) ;
								 
IF SQLCA.SQLCODE <> 0 THEN RETURN

INSERT INTO "KFZ04OM0"
  ( "PERSON_CD", "PERSON_NM", "PERSON_GU", "PERSON_NO", "PERSON_BNK", "PERSON_STS", "PERSON_AC1", "PERSON_CD2", "PERSON_TX" )
  SELECT "KFE03OM0"."DEPTCODE",
         "KFE03OM0"."DEPTNAME2",
			'10',
         "KFE03OM0"."UPDEPT",
			' ',
         "KFE03OM0"."USETAG",
			' ', ' ', ' '
    FROM "KFE03OM0"
   WHERE "DEPTCODE" IN ( SELECT "KFE03OM0"."DEPTCODE"  FROM "KFE03OM0" 
                         			   WHERE "KFE03OM0"."USETAG" = '1' 
	                         		   MINUS
   	                     		   SELECT "KFZ04OM0"."PERSON_CD" FROM "KFZ04OM0" ) ;
												
IF SQLCA.SQLCODE <> 0 THEN RETURN

// KFE03OM0 와 P0_DEPT 의 차이부서코드(P0_DEPT) => UPDATE 대상
// KFE03OM0 와 KFZ04OM0 의 차이부서코드(KFZ04OM0) => UPDATE 대상
UPDATE "KFE03OM0"
   SET "DEPTNAME"  = ( SELECT "DEPTNAME" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" ) ,
	    "DEPTNAME2" = ( SELECT "DEPTNAME2" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" ) ,
		 "SAUPCD"    = ( SELECT "SAUPCD" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" ) ,
		 "UPDEPT"    = ( SELECT "UPDEPT" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" ) ,
		 "USETAG"    = ( SELECT "USETAG" FROM "P0_DEPT" 
                        WHERE "COMPANYCODE" = 'KN' AND "DEPTCODE" = "KFE03OM0"."DEPTCODE" )
 WHERE "DEPTCODE" IN ( SELECT "KFE03OM0"."DEPTCODE" FROM "KFE03OM0" 
                        INTERSECT
                       SELECT "P0_DEPT"."DEPTCODE"  FROM "P0_DEPT" 
                        WHERE "P0_DEPT"."COMPANYCODE" = 'KN' AND "P0_DEPT"."USETAG" = '1' ) ;

UPDATE "KFZ04OM0"
   SET "PERSON_NM"  = ( SELECT "DEPTNAME2" FROM "KFE03OM0" 
                        WHERE "DEPTCODE" = "KFZ04OM0"."PERSON_CD" ) ,
		 "PERSON_NO"  = ( SELECT "UPDEPT" FROM "KFE03OM0" 
                        WHERE "DEPTCODE" = "KFZ04OM0"."PERSON_CD" ) ,
		 "PERSON_STS" = ( SELECT "USETAG" FROM "KFE03OM0" 
                        WHERE "DEPTCODE" = "KFZ04OM0"."PERSON_CD" ) 
 WHERE "PERSON_CD" IN ( SELECT "KFZ04OM0"."PERSON_CD" FROM "KFZ04OM0" 
                        INTERSECT
                       SELECT "KFE03OM0"."DEPTCODE"  FROM "KFE03OM0" 
                        WHERE "KFE03OM0"."USETAG" = '1' ) ;
						 
If sqlca.sqlcode <> 0 Then
	rollback;
  	sle_msg.text = "자료 저장 도중 에러가 발생하였습니다."
Else
	Commit;
	cb_can.TriggerEvent(Clicked!)
	sle_msg.text = "자료가 저장되었습니다.!!"
End If

dw_1.SetRedraw(true)

IF SQLCA.SQLCODE <> 0 THEN
	ROLLBACK ;
  	sle_msg.text = "자료 복사 도중 에러가 발생하였습니다."
	RETURN
ELSE
	cb_can.TriggerEvent(Clicked!)
	dw_1.Retrieve()
	sle_msg.text = "자료가 복사되었습니다.!!"
	COMMIT ;
END IF
end event

type dw_1 from u_d_popup_sort within w_kbga05
integer x = 466
integer y = 152
integer width = 1888
integer height = 2028
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_kbga05_1_1"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;String  ls_ObjName

if IsNull(dwo.name) then return

ls_ObjName = dwo.name

if Right(ls_ObjName,2) = "_t" then
	uf_sort(ls_ObjName)
end if

If row <= 0 then Return

dw_1.SelectRow(0, false)
dw_1.SelectRow(row, true)

dw_2.Retrieve(dw_1.GetItemString(row, 'deptcode'))

w_mdi_frame.sle_msg.text = "조회"

dw_2.SetTabOrder(1, 0)

dw_2.SetFocus()
	
p_ins.enabled = false						
p_ins.PictureName = "C:\erpman\image\추가_d.gif"
p_del.enabled = true
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

is_status = 'M'
end event

event rowfocuschanged;call super::rowfocuschanged;String  ls_ObjName

if IsNull(this.getColumnName()) then return

ls_ObjName = this.getColumnName()
if Right(ls_ObjName,2) = "_t" then
	uf_sort(ls_ObjName)
end if

If currentrow > 0 then
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
	

	
dw_2.SetRedraw(False)
dw_2.setTransObject(sqlca)
dw_2.Retrieve(dw_1.GetItemString(currentrow, 'deptcode'))

w_mdi_frame.sle_msg.text = "조회"

dw_2.SetTabOrder(1, 0)

dw_2.SetFocus()
	
p_ins.enabled = false						
p_ins.PictureName = "C:\erpman\image\추가_d.gif"
p_del.enabled = true
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

is_status = 'M'
   
	
	

	dw_2.SetRedraw(True)

   this.scrollTorow(currentrow)
	this.setFocus()
   
END IF


end event

type dw_2 from datawindow within w_kbga05
event ue_downenter pbm_dwnprocessenter
integer x = 2661
integer y = 468
integer width = 1490
integer height = 772
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kbga05_2"
boolean border = false
end type

event ue_downenter;Send(Handle(this), 256, 9, 0) 
Return 1
end event

event itemchanged;String ls_deptcode, ls_deptname, ls_deptname2, ls_saupcd, ls_updept, ls_usetag, snull

Setnull(snull)

If dw_2.AcceptText() = -1 then return

w_mdi_frame.sle_msg.text = " "

If is_status = 'I' and dw_2.Getcolumnname() = 'deptcode' then
		ls_deptcode = this.Gettext()
		
		If ls_deptcode = '' or Isnull(ls_deptcode) then
			f_messagechk(1, '[예산부서코드]')
			dw_2.Reset()
			dw_2.Insertrow(0)
			dw_2.Setcolumn('deptcode')
			dw_2.Setfocus()
			Return 1
		End If
		
		Select deptcode
		Into :ls_deptcode
		From kfe03om0
		Where deptcode = :ls_deptcode ;
		If sqlca.sqlcode = 0 then
			Messagebox("확 인", "이미 등록된 예산부서코드입니다,!!")
			dw_2.Reset()
			dw_2.Insertrow(0)
			dw_2.Setfocus()
			Return 1
		End If
		
End If

If dw_2.GetColumnName() = 'deptname' then
	ls_deptname = dw_2.GetText()
	ls_deptcode = dw_2.Getitemstring(1, 'deptcode')
		
	If ls_deptname = "" or Isnull(ls_deptname) then
		f_messagechk(1, '[예산부서명]')
		dw_2.Setcolumn('deptname')
		dw_2.Setfocus()
		Return 1
	End If

	  Select deptname Into :ls_deptname
	  From kfe03om0 
	  Where deptname = :ls_deptname ;
	IF SQLCA.SQLCODE = 0 THEN
		Messagebox("확 인", "이미 등록된 예산부서명입니다,!!")
		dw_2.SetItem(1, 'deptname', snull)
		dw_2.SetItem(1, 'deptname2', snull)
		dw_2.SetColumn('deptname')
		dw_2.SetFocus()
		Return 1
	End If
	dw_2.SetItem(row, 'deptname', ls_deptname)
	dw_2.Setitem(row, 'deptname2', ls_deptname)
End If

If dw_2.GetColumnName() = 'deptname2' then
	ls_deptname2 = dw_2.GetText()
	
	If ls_deptname2 = "" or Isnull(ls_deptname2) then
		f_messagechk(20,'[예산부서약명]')
		dw_2.SetColumn('deptname2')
		dw_2.SetFocus()
		Return 1
	End If
	
End If

If dw_2.GetColumnName() = 'updept' then
	ls_updept = dw_2.Gettext()
	
	If ls_updept = '' or Isnull(ls_updept) then Return
	
	Select updept Into :ls_updept
	From kfe03om0
	Where deptcode = :ls_updept ;
	If sqlca.sqlcode <> 0 then
		MessageBox("확 인", "해당하는 상위예산부서가 존재하지 않습니다.")
		dw_2.Setitem(1, 'updept', snull)
		dw_2.Setcolumn('updept')
		dw_2.Setfocus()
		Return 1
	End If
	
End If

If dw_2.GetColumnName() = 'usetag' then
	ls_usetag = dw_2.GetText()
	
	If Isnull(ls_usetag) or ls_usetag = "" then
		f_messagechk(20,'[사용여부]')
		dw_2.SetColumn('usetag')
		dw_2.SetFocus()
		Return 1
	End If
	
End If

end event

event editchanged;If is_status = 'I' then
	ib_any_typing = true
End If
end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="deptcode" OR dwo.name ="deptname"       OR dwo.name ="deptname2" OR &
	dwo.name ="saupcd" OR dwo.name ="updept" OR dwo.name ="usetag"  THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type dw_3 from datawindow within w_kbga05
boolean visible = false
integer x = 594
integer y = 2560
integer width = 965
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "예산부서(인사예산)"
string dataobject = "dw_kbga05_1_2"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kbga05
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 453
integer y = 144
integer width = 1989
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kbga05
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2592
integer y = 392
integer width = 1605
integer height = 996
integer cornerheight = 40
integer cornerwidth = 46
end type

