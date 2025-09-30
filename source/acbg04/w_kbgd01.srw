$PBExportHeader$w_kbgd01.srw
$PBExportComments$예산현황 조회
forward
global type w_kbgd01 from w_inherite
end type
type gb_3 from groupbox within w_kbgd01
end type
type dw_1 from datawindow within w_kbgd01
end type
type st_2 from statictext within w_kbgd01
end type
type dw_2 from datawindow within w_kbgd01
end type
type pb_1 from picture within w_kbgd01
end type
type pb_2 from picture within w_kbgd01
end type
type pb_3 from picture within w_kbgd01
end type
type pb_4 from picture within w_kbgd01
end type
type rr_1 from roundrectangle within w_kbgd01
end type
type rr_2 from roundrectangle within w_kbgd01
end type
end forward

global type w_kbgd01 from w_inherite
string title = "예산현황 조회"
gb_3 gb_3
dw_1 dw_1
st_2 st_2
dw_2 dw_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_1 rr_1
rr_2 rr_2
end type
global w_kbgd01 w_kbgd01

type variables
String is_acc1_cd,is_acc2_cd
end variables

on w_kbgd01.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.dw_1=create dw_1
this.st_2=create st_2
this.dw_2=create dw_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.pb_3
this.Control[iCurrent+8]=this.pb_4
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_kbgd01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_1.reset()
dw_1.insertrow(0)

dw_1.object.acname.text = ""

dw_1.setitem(dw_1.getrow(),"saupj", gs_saupj )
dw_1.setitem(dw_1.getrow(),"acc_yy", left(string(today(),"yyyy/mm/dd"),4))
dw_1.setitem(dw_1.getrow(),"dept_cd",gs_dept)

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_1.Modify("dept_cd.protect = 0")
	//dw_1.Modify("dept_cd.background.color ='"+String(RGB(255,255,255))+"'")		
	dw_1.Modify("saupj.protect = 0")
	//dw_1.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")		
ELSE
	dw_1.Modify("saupj.protect = 1")
	//dw_1.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")			
	dw_1.Modify("dept_cd.protect = 1")
	//dw_1.Modify("dept_cd.background.color ='"+String(RGB(192,192,192))+"'")			
END IF

dw_1.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_kbgd01
integer y = 2516
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kbgd01
integer x = 1728
integer y = 2624
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbgd01
integer x = 1550
integer y = 2632
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbgd01
integer x = 1170
integer y = 2620
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kbgd01
integer x = 1371
integer y = 2620
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kbgd01
integer x = 4430
integer y = 44
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kbgd01
integer x = 4256
integer y = 44
integer taborder = 40
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_2.reset()

dw_1.insertrow(0)

sle_msg.text= ""
dw_1.object.acname.text = ""

dw_1.setitem(dw_1.getrow(),"saupj",gs_saupj )
dw_1.setitem(dw_1.getrow(),"acc_yy", left(string(today(),"yyyy/mm/dd"),4))
dw_1.setitem(dw_1.getrow(),"dept_cd",gs_dept)

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_1.Modify("dept_cd.protect = 0")
//	dw_1.Modify("dept_cd.background.color ='"+String(RGB(255,255,255))+"'")		
	dw_1.Modify("saupj.protect = 0")
//	dw_1.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")		
ELSE
	dw_1.Modify("saupj.protect = 1")
//	dw_1.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")			
	dw_1.Modify("dept_cd.protect = 1")
//	dw_1.Modify("dept_cd.background.color ='"+String(RGB(192,192,192))+"'")			
END IF

dw_1.setfocus()

end event

type p_print from w_inherite`p_print within w_kbgd01
integer x = 1280
integer y = 2524
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kbgd01
integer x = 4082
integer y = 44
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string ls_saupj, ls_acc_yy, ls_dept, ls_acc1_cd, ls_acc2_cd, sqlfd, sqlfd2

setpointer(hourglass!)
dw_1.accepttext()

ls_saupj   =  dw_1.getitemstring(dw_1.getrow(), "saupj")
ls_acc_yy  =  dw_1.getitemstring(dw_1.getrow(), "acc_yy")
ls_dept    =  dw_1.getitemstring(dw_1.getrow(), "dept_cd")
ls_acc1_cd =   dw_1.getitemstring(dw_1.getrow(), "acc1_cd")
ls_acc2_cd =   dw_1.getitemstring(dw_1.getrow(), "acc2_cd")

if ls_saupj = "" or isnull(ls_saupj) then
	F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	return 
end if

if ls_dept = "" or isnull(ls_dept) then
	F_MessageChk(1,'[배정부서]')
	dw_1.SetColumn("dept_cd")
	dw_1.SetFocus()
	return	
end if

if ls_acc_yy = "" or isnull(ls_acc_yy ) or 1000 > long(ls_acc_yy) or long(ls_acc_yy) > 9999 then
	F_MessageChk(1,'[회계년도]')
	dw_1.SetColumn("acc_yy")
	dw_1.SetFocus()
	return
else
	if not isnumber(ls_acc_yy) then
		F_MessageChk(1,'[회계년도]')
		dw_1.SetColumn("acc_yy")
		dw_1.SetFocus()
		return
	end if
end if

if ls_acc1_cd = ""  or isnull(ls_acc1_cd) then
	F_MessageChk(1,'[계정과목]')
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	return
end if

if ls_acc2_cd = ""  or isnull(ls_acc2_cd) then
	F_MessageChk(1,'[계정과목]')
	dw_1.SetColumn("acc2_cd")
	dw_1.SetFocus()
	return
end if

if dw_2.retrieve(ls_saupj, ls_acc_yy , ls_dept , ls_acc1_cd, ls_acc2_cd ) <= 0 then
	sle_msg.text = ""
	F_MessageChk(14,'')
	return
else
	sle_msg.text = " 자료가 조회 되었습니다. "
end if

end event

type p_del from w_inherite`p_del within w_kbgd01
integer x = 1093
integer y = 2520
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kbgd01
integer x = 923
integer y = 2528
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kbgd01
end type

type cb_mod from w_inherite`cb_mod within w_kbgd01
end type

type cb_ins from w_inherite`cb_ins within w_kbgd01
end type

type cb_del from w_inherite`cb_del within w_kbgd01
end type

type cb_inq from w_inherite`cb_inq within w_kbgd01
end type

type cb_print from w_inherite`cb_print within w_kbgd01
end type

type st_1 from w_inherite`st_1 within w_kbgd01
end type

type cb_can from w_inherite`cb_can within w_kbgd01
end type

type cb_search from w_inherite`cb_search within w_kbgd01
end type







type gb_button1 from w_inherite`gb_button1 within w_kbgd01
integer x = 334
integer y = 2676
integer width = 402
integer height = 180
end type

type gb_button2 from w_inherite`gb_button2 within w_kbgd01
integer x = 2386
integer y = 2588
integer width = 754
integer height = 180
end type

type gb_3 from groupbox within w_kbgd01
integer x = 2880
integer y = 60
integer width = 576
integer height = 164
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "자료선택"
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_kbgd01
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 40
integer width = 2793
integer height = 200
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kbgd01_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;// 계정과목코드를 읽어 계정명을 표시처리 

if this.getcolumnname() = 'acc2_cd'  then 
//계정과목코드를 읽어 계정명을 표시처리//
string ls_acc1_cd, ls_acc2_cd, sqlfd, sqlfd2, sqlfd3

dw_1.AcceptText()
ls_acc1_cd = dw_1.Getitemstring(dw_1.Getrow(),"acc1_cd")
ls_acc2_cd = dw_1.Getitemstring(dw_1.Getrow(),"acc2_cd")
is_acc1_cd = ls_acc1_cd
is_acc2_cd = ls_acc2_cd

if IsNull(ls_acc2_cd) then
  SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM","KFZ01OM0"."YACC2_NM"  
  INTO :sqlfd, :sqlfd2, :sqlfd3
  FROM "KFZ01OM0"  
  WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) using sqlca ;
  if sqlca.sqlcode = 0 then
     dw_1.object.acname.Text = Trim(sqlfd) + " - " + Trim(sqlfd3)
  else
     dw_1.object.acname.Text = ""
  end if
  
else
  SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM","KFZ01OM0"."YACC2_NM" 
  INTO :sqlfd, :sqlfd2, :sqlfd3
  FROM "KFZ01OM0"  
  WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
        ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
  if sqlca.sqlcode = 0 then
     dw_1.object.acname.Text = Trim(sqlfd) + " - " + Trim(sqlfd3)
  else
     dw_1.object.acname.Text = ""
  end if
end if

  p_inq.triggerevent(clicked!)
     
end if


end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.getcolumnname() <> "acc1_cd" then return

dw_1.accepttext()
gs_code = trim(dw_1.getitemstring(dw_1.getrow(), "acc1_cd"))

if isnull(gs_code) then
	gs_code=""
end if

open(w_kfe01om0_popup)

if  gs_code <> "" and  not isnull(gs_code) then 
	dw_1.setitem(dw_1.getrow(),"acc1_cd",left(gs_code,5))
	dw_1.setitem(dw_1.getrow(),"acc2_cd",mid(gs_code,6,2))
   dw_1.object.acname.text =  gs_codename
	
	p_inq.triggerevent(clicked!)
end if

dw_1.setfocus()
end event

type st_2 from statictext within w_kbgd01
integer x = 3465
integer y = 164
integer width = 544
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "(단위:천원,잔액:원)"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_2 from datawindow within w_kbgd01
integer x = 59
integer y = 280
integer width = 4517
integer height = 1940
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kbgd01_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)
end event

event rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)
end event

type pb_1 from picture within w_kbgd01
integer x = 2935
integer y = 136
integer width = 55
integer height = 48
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\first.gif"
boolean focusrectangle = false
end type

event clicked;String sAcc1,sAcc2,sGetAccCode,sAccNm

dw_1.AcceptText()
sAcc1 = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sAcc2 = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")

SELECT MIN("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0" 
	WHERE ("KFZ01OM0"."YESAN_GU" <> 'N') AND ("KFZ01OM0"."BAL_GU" <> '4') ;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) OR sGetAccCode = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	IF sAcc1 + sAcc2 = sGetAccCode THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM"||'-'||"KFZ01OM0"."ACC2_NM"   
		INTO :sAccNm
		FROM "KFZ01OM0"  
  		WHERE "ACC1_CD"||"ACC2_CD" = :sGetAccCode ; 
		  
	dw_1.SetItem(dw_1.GetRow(),"acc1_cd",Left(sGetAccCode,5))
	dw_1.SetItem(dw_1.GetRow(),"acc2_cd",Mid(sGetAccCode,6,2))
	
	dw_1.object.acname.text = sAccNm
	
	p_inq.TriggerEvent(Clicked!)
END IF
	
end event

type pb_2 from picture within w_kbgd01
integer x = 3067
integer y = 136
integer width = 55
integer height = 48
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\prior.gif"
boolean focusrectangle = false
end type

event clicked;String sAcc1,sAcc2,sGetAccCode,sAccNm,sAcc

dw_1.AcceptText()
sAcc1 = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sAcc2 = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")

sAcc = sAcc1 + sAcc2
SELECT MAX("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0"
	WHERE "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" < :sAcc AND
			("KFZ01OM0"."YESAN_GU" <> 'N') AND ("KFZ01OM0"."BAL_GU" <> '4');
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM"||'-'||"KFZ01OM0"."ACC2_NM"   
		INTO :sAccNm
		FROM "KFZ01OM0"  
  		WHERE "ACC1_CD"||"ACC2_CD" = :sGetAccCode ;
		  
	dw_1.SetItem(dw_1.GetRow(),"acc1_cd",Left(sGetAccCode,5))
	dw_1.SetItem(dw_1.GetRow(),"acc2_cd",Mid(sGetAccCode,6,2))
	dw_1.object.acname.text = sAccNm
	
	p_inq.TriggerEvent(Clicked!)
END IF
	
end event

type pb_3 from picture within w_kbgd01
integer x = 3205
integer y = 136
integer width = 55
integer height = 48
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\next.gif"
boolean focusrectangle = false
end type

event clicked;String sAcc1,sAcc2,sGetAccCode,sAcc,sAccNm

dw_1.AcceptText()
sAcc1 = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sAcc2 = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
sAcc = sAcc1 + sAcc2

SELECT MIN("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0"
	WHERE "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" > :sAcc AND
			("KFZ01OM0"."YESAN_GU" <> 'N') AND ("KFZ01OM0"."BAL_GU" <> '4');
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	SELECT "KFZ01OM0"."ACC1_NM"||'-'||"KFZ01OM0"."ACC2_NM"   
		INTO :sAccNm
		FROM "KFZ01OM0"  
  		WHERE "ACC1_CD"||"ACC2_CD" = :sGetAccCode ;
		  
	dw_1.SetItem(dw_1.GetRow(),"acc1_cd",Left(sGetAccCode,5))
	dw_1.SetItem(dw_1.GetRow(),"acc2_cd",Mid(sGetAccCode,6,2))
	dw_1.object.acname.text = sAccNm
	
	p_inq.TriggerEvent(Clicked!)
END IF
	
end event

type pb_4 from picture within w_kbgd01
integer x = 3333
integer y = 136
integer width = 55
integer height = 48
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\last.gif"
boolean focusrectangle = false
end type

event clicked;String sAcc1,sAcc2,sGetAccCode,sAccNm

dw_1.AcceptText()
sAcc1 = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sAcc2 = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")

SELECT MAX("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0" 
	WHERE ("KFZ01OM0"."YESAN_GU" <> 'N') AND ("KFZ01OM0"."BAL_GU" <> '4');
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) OR sGetAccCode = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	IF sAcc1 + sAcc2 = sGetAccCode THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM"||'-'||"KFZ01OM0"."ACC2_NM"   
		INTO :sAccNm
		FROM "KFZ01OM0"  
  		WHERE "ACC1_CD"||"ACC2_CD" = :sGetAccCode ;
		  
	dw_1.SetItem(dw_1.GetRow(),"acc1_cd",Left(sGetAccCode,5))
	dw_1.SetItem(dw_1.GetRow(),"acc2_cd",Mid(sGetAccCode,6,2))
	dw_1.object.acname.text = sAccNm
	
	p_inq.TriggerEvent(Clicked!)
END IF
	
end event

type rr_1 from roundrectangle within w_kbgd01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 268
integer width = 4549
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kbgd01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2848
integer y = 44
integer width = 1184
integer height = 192
integer cornerheight = 40
integer cornerwidth = 55
end type

