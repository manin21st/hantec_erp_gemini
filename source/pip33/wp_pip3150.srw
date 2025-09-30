$PBExportHeader$wp_pip3150.srw
$PBExportComments$** 월별 항목별 지급/공제액 현황
forward
global type wp_pip3150 from w_standard_print
end type
type dw_1 from datawindow within wp_pip3150
end type
type dw_2 from datawindow within wp_pip3150
end type
type rb_pstag1 from radiobutton within wp_pip3150
end type
type rb_pstag2 from radiobutton within wp_pip3150
end type
type dw_allow from datawindow within wp_pip3150
end type
type rr_1 from roundrectangle within wp_pip3150
end type
end forward

global type wp_pip3150 from w_standard_print
integer x = 0
integer y = 0
string title = "월별 항목별 지급/공제액 현황"
dw_1 dw_1
dw_2 dw_2
rb_pstag1 rb_pstag1
rb_pstag2 rb_pstag2
dw_allow dw_allow
rr_1 rr_1
end type
global wp_pip3150 wp_pip3150

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYm,ls_gubun,ls_Empno,sDeptcode,sJikjong,sKunmu, sCode, sGubn
integer iRtnValue
dw_ip.AcceptText()
dw_allow.AcceptText()

sYm      = dw_ip.GetITemString(1,"l_ym")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/
sJikjong = trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu = trim(dw_ip.GetItemString(1,"kunmu"))
sKunmu = trim(dw_ip.GetItemString(1,"kunmu"))
sCode = dw_allow.GetItemString(1,"allowcode")

IF sJikjong = '' OR IsNull(sJikjong) THEN sJikjong = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
		 
IF sYm = "      " OR IsNull(sYm) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sYm + '01') = -1 THEN
   MessageBox("확인","년월을 확인하세요")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF

IF sCode = '' OR ISNULL(sCode) THEN
	MessageBox("확인","수당을 입력하세요")
	dw_ip.SetColumn("allowcode")
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_gubun = '' OR ISNULL(ls_gubun) THEN
	MessageBox("확 인","구분을 입력하세요!!")
	dw_ip.SetColumn("l_gubn")
	dw_ip.SetFocus()
	Return -1
END IF	

IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
	sDeptcode = '%'
END IF	

/*지급,공제 구분*/
IF rb_pstag1.Checked = True THEN
	sGubn = '1'
ELSEIF rb_pstag2.Checked = True THEN
	sGubn = '2'
END IF

SetPointer(HourGlass!)

dw_list.SETREDRAW(FALSE)
IF dw_print.Retrieve(gs_company, is_saupcd, sYm, sDeptcode, ls_gubun, sJikjong, sKunmu, sCode, sGubn) <=0 THEN
	dw_list.insertrow(0)
	MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_list.SETREDRAW(TRUE)
	SetPointer(Arrow!)
	Return -1
END IF
dw_print.sharedata(dw_list)
dw_list.SETREDRAW(TRUE)

SetPointer(Arrow!)
Return 1
end function

on wp_pip3150.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rb_pstag1=create rb_pstag1
this.rb_pstag2=create rb_pstag2
this.dw_allow=create dw_allow
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rb_pstag1
this.Control[iCurrent+4]=this.rb_pstag2
this.Control[iCurrent+5]=this.dw_allow
this.Control[iCurrent+6]=this.rr_1
end on

on wp_pip3150.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rb_pstag1)
destroy(this.rb_pstag2)
destroy(this.dw_allow)
destroy(this.rr_1)
end on

event open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()

dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_allow.SetTransObject(sqlca)
dw_allow.Retrieve()

dw_ip.SetITem(1,"l_ym",String(gs_today,'@@@@@@'))
dw_ip.SetITem(1,"l_gubn",'P')
dw_allow.SetItem(1,'allowcode','01')

f_set_saupcd(dw_ip,'l_saup','1')
is_saupcd = gs_saupcd
end event

type p_preview from w_standard_print`p_preview within wp_pip3150
integer x = 4069
end type

type p_exit from w_standard_print`p_exit within wp_pip3150
integer x = 4416
end type

type p_print from w_standard_print`p_print within wp_pip3150
integer x = 4242
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip3150
integer x = 3895
end type

type st_window from w_standard_print`st_window within wp_pip3150
boolean visible = false
integer x = 2336
integer y = 2584
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3150
boolean visible = false
integer x = 361
integer y = 2584
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3150
boolean visible = false
integer x = 2830
integer y = 2584
end type

type st_10 from w_standard_print`st_10 within wp_pip3150
boolean visible = false
integer x = 0
integer y = 2584
end type



type dw_print from w_standard_print`dw_print within wp_pip3150
integer x = 3922
integer y = 196
string dataobject = "dp_pip3150_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3150
integer x = 448
integer width = 3374
integer height = 272
string dataobject = "dp_pip3150_10"
end type

event dw_ip::itemchanged;String sDeptno,sName,snull,sEmpNo,sEmpName,sCode

SetNull(snull)

This.AcceptText()

IF dw_ip.GetColumnName() = "l_saup" THEN
	is_saupcd = dw_ip.GetText()
	IF is_saupcd = '' OR ISNULL(is_saupcd) THEN is_saupcd = '%'
END IF	


IF dw_ip.GetColumnName() ="l_dept" THEN 
   sDeptno = dw_ip.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		dw_ip.SetITem(1,"l_dept",snull)
		dw_ip.SetITem(1,"l_deptname",snull)
		Return 
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		dw_ip.SetITem(1,"l_dept",snull)
	   dw_ip.SetITem(1,"l_deptname",snull) 
		dw_ip.SetColumn("l_dept")
      Return 1
	END IF	
	   dw_ip.SetITem(1,"l_deptname",sName) 
END IF
IF dw_ip.GetColumnName() = "l_empno" then
   sEmpNo = dw_ip.GetItemString(1,"l_empno")

	IF sEmpNo = '' or isnull(sEmpNo) THEN
	   dw_ip.SetITem(1,"l_empno",snull)
		dw_ip.SetITem(1,"l_empname",snull)
	ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 dw_ip.SetITem(1,"l_empno",snull)
				 dw_ip.SetITem(1,"l_empname",snull)
				 RETURN 1 
			 END IF
				dw_ip.SetITem(1,"l_empname",sEmpName  )
				
	END IF
END IF

p_retrieve.TriggerEvent(Clicked!)
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF dw_ip.GetColumnName() = "l_dept" THEN
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"l_dept",gs_code)
	dw_ip.SetITem(1,"l_deptname",gs_codename)
END IF	

IF dw_ip.GetColumnName() = "l_empno" THEN
   Open(w_employee_popup)

   if isnull(gs_code) or gs_code = '' then return
   dw_ip.SetITem(1,"l_empno",gs_code)
	dw_ip.SetITem(1,"l_empname",gs_codename)
  
END IF	
end event

type dw_list from w_standard_print`dw_list within wp_pip3150
integer x = 1056
integer y = 300
integer width = 2331
integer height = 1948
string dataobject = "dp_pip3150"
boolean border = false
end type

type dw_1 from datawindow within wp_pip3150
boolean visible = false
integer x = 553
integer y = 2436
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(지급)"
string dataobject = "dp_pip3130_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within wp_pip3150
boolean visible = false
integer x = 1504
integer y = 2436
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(공제)"
string dataobject = "dp_pip3130_40"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_pstag1 from radiobutton within wp_pip3150
integer x = 3502
integer y = 84
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
w_mdi_frame.SLE_MSG.TEXT =""

dw_ip.AcceptText()

Pbtag = dw_ip.GetItemString(1,"l_gubn")

dw_list.Reset()
DataWindowChild state_child

dw_allow.GetChild("allowcode", state_child)
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

dw_allow.SetITem(1,"allowcode",'01')
p_retrieve.TriggerEvent(Clicked!)
end event

type rb_pstag2 from radiobutton within wp_pip3150
integer x = 3502
integer y = 164
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

dw_ip.AcceptText()

Pbtag = dw_ip.GetItemString(1,"l_gubn")
dw_list.Reset()

DataWindowChild state_child

dw_allow.GetChild("allowcode", state_child)
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

dw_allow.SetITem(1,"allowcode",'01')
p_retrieve.TriggerEvent(Clicked!)
end event

type dw_allow from datawindow within wp_pip3150
integer x = 2624
integer y = 160
integer width = 827
integer height = 84
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dp_pip3150_30"
boolean border = false
boolean livescroll = true
end type

event retrievestart;Int rtncode

DataWindowChild state_child

rtncode = dw_allow.GetChild("allowcode", state_child)
IF rtncode = -1 THEN 
	  MessageBox("확인","없슴")
	  Return
END IF  

state_child.SetTransObject(SQLCA)

IF state_child.Retrieve("1","Y") <= 0 THEN
	Return 1
END IF
end event

event itemchanged;p_retrieve.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within wp_pip3150
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1038
integer y = 292
integer width = 2368
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

