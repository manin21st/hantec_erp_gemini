$PBExportHeader$w_kbga01a.srw
$PBExportComments$예산배정승인 등록
forward
global type w_kbga01a from w_inherite
end type
type dw_lst from datawindow within w_kbga01a
end type
type dw_cond from u_key_enter within w_kbga01a
end type
type rr_1 from roundrectangle within w_kbga01a
end type
end forward

global type w_kbga01a from w_inherite
integer x = 5
integer y = 4
string title = "예산배정 승인/취소 등록"
dw_lst dw_lst
dw_cond dw_cond
rr_1 rr_1
end type
global w_kbga01a w_kbga01a

on w_kbga01a.create
int iCurrent
call super::create
this.dw_lst=create dw_lst
this.dw_cond=create dw_cond
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lst
this.Control[iCurrent+2]=this.dw_cond
this.Control[iCurrent+3]=this.rr_1
end on

on w_kbga01a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lst)
destroy(this.dw_cond)
destroy(this.rr_1)
end on

event open;call super::open;
dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(1,"saupj",   Gs_Saupj)
dw_cond.SetItem(1,"year",    Left(F_Today(),4))
dw_cond.SetItem(1,"cdept_cd",Gs_Dept)

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_cond.Modify("saupj.protect = 0")
//	dw_cond.Modify("saupj.background.color ='"+String(RGB(190,225,184))+"'")		
	
	dw_cond.Modify("cdept_cd.protect = 0")
//	dw_cond.Modify("cdept_cd.background.color ='"+String(RGB(255,255,255))+"'")		
	dw_cond.SetColumn("cdept_cd")
ELSE
	dw_cond.Modify("saupj.protect = 1")
//	dw_cond.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")			
	
	dw_cond.Modify("cdept_cd.protect = 1")
//	dw_cond.Modify("cdept_cd.background.color ='"+String(RGB(192,192,192))+"'")			
	dw_cond.SetColumn("year")
END IF
dw_cond.SetFocus()

dw_lst.SetTransObject(SQLCA)
end event

type dw_insert from w_inherite`dw_insert within w_kbga01a
boolean visible = false
integer x = 41
integer y = 2852
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kbga01a
boolean visible = false
integer x = 3790
integer y = 3048
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbga01a
boolean visible = false
integer x = 3621
integer y = 3036
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbga01a
integer x = 4270
integer taborder = 40
string picturename = "C:\Erpman\image\처리_up.gif"
end type

event p_search::clicked;call super::clicked;Integer i,iDbCount
String  sCurStatus,sChangeStatus,sSaupj,sYear,sAcc1,sAcc2,sCdept

dw_cond.AcceptText()
sSaupj    = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sYear     = dw_cond.GetItemString(dw_cond.GetRow(),"year")

dw_lst.AcceptText()
sCurStatus = dw_cond.GetItemString(1,"gbn")			/*승인처리 = 'N',승인취소 처리 = 'Y'*/

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '처리 중...'

FOR i = 1 TO dw_lst.RowCount()
	sChangeStatus = dw_lst.GetItemString(i,"gubun1")
	
	IF sCurStatus = 'N' AND sChangeStatus = 'N' THEN Continue
	IF sCurStatus = 'Y' AND sChangeStatus = 'Y' THEN Continue
	
	sAcc1  = dw_lst.GetItemString(i,"acc1_cd")
	sAcc2  = dw_lst.GetItemString(i,"acc2_cd")
	sCdept = dw_lst.GetItemString(i,"dept_cd") 
	
	SELECT COUNT(*) INTO :iDbCount
		FROM "KFE01OM0"  
		WHERE ( "KFE01OM0"."SAUPJ" = :sSaupj ) AND ( "KFE01OM0"."ACC_YY" = :sYear ) AND  
      		( "KFE01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFE01OM0"."ACC2_CD" = :sAcc2 ) AND  
      		( "KFE01OM0"."DEPT_CD" = :sCdept )   ;
	IF SQLCA.SQLCODE <> 0 OR IsNull(iDbCount) OR iDbCount = 0 THEN
		F_MessageChk(20014,'')
		Rollback;
		Return
	END IF
	
	UPDATE "KFE01OM0"  
   	SET "GUBUN1" = :sChangeStatus
   	WHERE ( "KFE01OM0"."SAUPJ" = :sSaupj ) AND ( "KFE01OM0"."ACC_YY" = :sYear ) AND  
      		( "KFE01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFE01OM0"."ACC2_CD" = :sAcc2 ) AND  
      		( "KFE01OM0"."DEPT_CD" = :sCdept )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
NEXT
COMMIT;

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = '처리 완료'

p_inq.TriggerEvent(Clicked!)
end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\처리_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\처리_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kbga01a
boolean visible = false
integer x = 4073
integer y = 2888
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kbga01a
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kbga01a
boolean visible = false
integer x = 3936
integer y = 3300
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kbga01a
boolean visible = false
integer x = 3881
integer y = 2852
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kbga01a
integer x = 4096
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaupj,sYear,sCdeptCd,sYesanGbn,sProcGbn,sAcc1f,sAcc2f,sAcc1t,sAcc2t

dw_cond.AcceptText()
sSaupj    = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sYear     = dw_cond.GetItemString(dw_cond.GetRow(),"year")
sCdeptCd  = dw_cond.GetItemString(dw_cond.GetRow(),"cdept_cd") 
sYesanGbn = dw_cond.GetItemString(dw_cond.GetRow(),"ye_gu")  

sAcc1f    = dw_cond.GetItemString(dw_cond.GetRow(),"acc1_cdf")  
sAcc2f    = dw_cond.GetItemString(dw_cond.GetRow(),"acc2_cdf")  

sAcc1t    = dw_cond.GetItemString(dw_cond.GetRow(),"acc1_cdt")  
sAcc2t    = dw_cond.GetItemString(dw_cond.GetRow(),"acc2_cdt")  

sProcGbn  = dw_cond.GetItemString(dw_cond.GetRow(),"gbn")  

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.Setfocus()
	Return
END IF

IF sYear = "" OR IsNull(sYear) THEN
	F_MessageChk(1,'[회계년도]')
	dw_cond.SetColumn("year")
	dw_cond.Setfocus()
	Return
END IF

IF sCdeptCd = "" OR IsNull(sCdeptCd) THEN
	sCdeptCd = '%'
END IF

IF sYesanGbn = "" OR IsNull(sYesanGbn) THEN
	sYesanGbn = '%'
END IF

IF sAcc1f = "" OR IsNull(sAcc1f) OR sAcc2f = "" OR IsNull(sAcc2f) THEN
	sAcc1f = '00000';	sAcc2f = '00'	
END IF

IF sAcc1t = "" OR IsNull(sAcc1t) OR sAcc2t = "" OR IsNull(sAcc2t) THEN
	sAcc1t = '99999';	sAcc2t = '99'	
END IF

IF dw_lst.Retrieve(sSaupj,sYear,sCdeptCd,sYesanGbn,sAcc1f,sAcc2f,sAcc1t,sAcc2t,sProcGbn) <=0 THEN
	F_MessageChk(14,'')
	Return
END IF

dw_cond.SetItem(1,"choose",'2')

end event

type p_del from w_inherite`p_del within w_kbga01a
boolean visible = false
integer x = 3703
integer y = 3216
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kbga01a
boolean visible = false
integer x = 4050
integer y = 3076
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kbga01a
boolean visible = false
integer x = 3278
integer y = 2800
end type

type cb_mod from w_inherite`cb_mod within w_kbga01a
boolean visible = false
integer x = 2903
integer y = 2800
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_kbga01a
boolean visible = false
integer x = 1038
integer y = 2548
end type

type cb_del from w_inherite`cb_del within w_kbga01a
boolean visible = false
integer x = 1984
integer y = 2556
end type

type cb_inq from w_inherite`cb_inq within w_kbga01a
boolean visible = false
integer x = 37
integer y = 2700
end type

type cb_print from w_inherite`cb_print within w_kbga01a
boolean visible = false
integer x = 2345
integer y = 2560
end type

type st_1 from w_inherite`st_1 within w_kbga01a
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kbga01a
boolean visible = false
integer x = 2715
integer y = 2540
end type

type cb_search from w_inherite`cb_search within w_kbga01a
boolean visible = false
integer x = 1403
integer y = 2556
end type

type dw_datetime from w_inherite`dw_datetime within w_kbga01a
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kbga01a
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kbga01a
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kbga01a
boolean visible = false
integer x = 0
integer y = 2644
integer width = 407
end type

type gb_button2 from w_inherite`gb_button2 within w_kbga01a
boolean visible = false
integer x = 2862
integer y = 2740
integer width = 759
end type

type dw_lst from datawindow within w_kbga01a
integer x = 91
integer y = 272
integer width = 4475
integer height = 2032
integer taborder = 30
string dataobject = "dw_kbga01a2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_cond from u_key_enter within w_kbga01a
event ue_key pbm_dwnkey
integer x = 50
integer width = 3936
integer height = 268
integer taborder = 10
string dataobject = "dw_kbga01a1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string  sSaupj,sYear,sDept,sYesan,snull,sChoose,sGbn,sStatus,sAcc1,sAcc2,sAccName
Integer iCurRow,k

SetNull(snull)

IF this.GetcolumnName() <> 'choose' THEN
	dw_lst.Reset()
END IF

iCurRow = this.GetRow()
IF this.GetColumnName() = 'saupj' then
   sSaupj   = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
   	F_MessageChk(20, "[사업장]")	
		this.SetItem(iCurRow, 'saupj', snull)
		return 1
	END IF
END IF

if this.GetColumnName() = 'year' then 
	sYear = this.GetText()
	IF sYear = "" OR IsNull(sYear) THEN Return
end if

if this.GetColumnName() = 'cdept_cd' then
	sDept = this.GetText()
	IF sDept = "" OR IsNull(sDept) THEN Return
	
	SELECT "KFE03OM0"."DEPTCODE"  	
		INTO :sDept
		FROM "KFE03OM0"	WHERE "KFE03OM0"."DEPTCODE" = :sDept;

	IF Sqlca.sqlcode <> 0 then 	
		F_MessageChk(20,'[예산부서]')						
		this.SetItem(iCurRow, 'cdept_cd', snull)
		return 1
	End if 
end if

IF this.GetColumnName() = 'ye_gu' then
   sYesan   = this.GetText()
	IF sYesan = "" OR IsNull(sYesan) THEN Return
	
	IF IsNull(F_Get_Refferance('AB',sYesan)) THEN
   	F_MessageChk(20, "[예산구분]")	
		this.SetItem(iCurRow, 'ye_gu', snull)
		return 1
	END IF
END IF

if this.GetColumnName() = 'acc1_cdf' then 
	sAcc1 = this.GetText()
	IF trim(sAcc1) = "" OR IsNull(sAcc1) THEN Return
	
	sAcc2 = this.GetItemString(iCurRow,"acc2_cdf")
	IF trim(sAcc2) = "" OR IsNull(sAcc2) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"    INTO :sAccName
		FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD" = :sAcc1 and "KFZ01OM0"."ACC2_CD" = :sAcc2 ;
	if sqlca.sqlcode = 0 then
		this.Setitem(iCurRow,"accnamef", sAccName)
	else
		this.Setitem(iCurRow,"acc1_cdf", sNull)
		this.Setitem(iCurRow,"acc2_cdf", sNull)
		this.Setitem(iCurRow,"accnamef", sNull)
		Return 1
	end if
end if

if this.GetColumnName() = 'acc2_cdf' then 
	sAcc2 = this.GetText()
	IF trim(sAcc2) = "" OR IsNull(sAcc2) THEN Return
	
	sAcc1 = this.GetItemString(iCurRow,"acc1_cdf")
	IF trim(sAcc1) = "" OR IsNull(sAcc1) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"    INTO :sAccName
		FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD" = :sAcc1 and "KFZ01OM0"."ACC2_CD" = :sAcc2 ;
	if sqlca.sqlcode = 0 then
		this.Setitem(iCurRow,"accnamef", sAccName)
	else
		this.Setitem(iCurRow,"acc1_cdf", sNull)
		this.Setitem(iCurRow,"acc2_cdf", sNull)
		this.Setitem(iCurRow,"accnamef", sNull)
		this.SetColumn("acc1_cdf")
		this.SetFocus()
		Return 1
	end if
end if

if this.GetColumnName() = 'acc1_cdt' then 
	sAcc1 = this.GetText()
	IF trim(sAcc1) = "" OR IsNull(sAcc1) THEN Return
	
	sAcc2 = this.GetItemString(iCurRow,"acc2_cdt")
	IF trim(sAcc2) = "" OR IsNull(sAcc2) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"    INTO :sAccName
		FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD" = :sAcc1 and "KFZ01OM0"."ACC2_CD" = :sAcc2 ;
	if sqlca.sqlcode = 0 then
		this.Setitem(iCurRow,"accnamet", sAccName)
	else
		this.Setitem(iCurRow,"acc1_cdt", sNull)
		this.Setitem(iCurRow,"acc2_cdt", sNull)
		this.Setitem(iCurRow,"accnamet", sNull)
		Return 1
	end if
end if

if this.GetColumnName() = 'acc2_cdt' then 
	sAcc2 = this.GetText()
	IF trim(sAcc2) = "" OR IsNull(sAcc2) THEN Return
	
	sAcc1 = this.GetItemString(iCurRow,"acc1_cdt")
	IF trim(sAcc1) = "" OR IsNull(sAcc1) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"    INTO :sAccName
		FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD" = :sAcc1 and "KFZ01OM0"."ACC2_CD" = :sAcc2 ;
	if sqlca.sqlcode = 0 then
		this.Setitem(iCurRow,"accnamet", sAccName)
	else
		this.Setitem(iCurRow,"acc1_cdt", sNull)
		this.Setitem(iCurRow,"acc2_cdt", sNull)
		this.Setitem(iCurRow,"accnamet", sNull)
		this.SetColumn("acc1_cdt")
		this.SetFocus()
		Return 1
	end if
end if

IF this.GetcolumnName() = 'choose' THEN
	sChoose = this.GetText()
	
	sGbn = this.GetItemString(iCurrow,"gbn")
	
	IF sChoose = '1' THEN													/*전체 선택*/
		IF sGbn = 'N' THEN						/*승인처리*/
			sStatus = 'Y'
		ELSE
			sStatus = 'N'
		END IF
	ELSE
		IF sGbn = 'N' THEN						/*승인처리*/
			sStatus = 'N'
		ELSE
			sStatus = 'Y'
		END IF
	END IF
	
	FOR k = 1 TO dw_lst.RowCount()
		dw_lst.SetItem(k,"gubun1",sStatus)
	NEXT
END IF

end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

event rbuttondown;SetNull(gs_code)

IF this.GetColumnName() = "acc1_cdf" THEN 
	gs_code = this.GetItemString(this.GetRow(), "acc1_cdf")
	IF IsNull(gs_code) then
		gs_code =""
	end if
	
	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
		this.SetItem(this.GetRow(), "acc1_cdf", Left(gs_code,5))
		this.SetItem(this.GetRow(), "acc2_cdf", Mid(gs_code,6,2))
		this.SetItem(this.GetRow(), "accnamef", gs_codename)
	end if
END IF

IF this.GetColumnName() = "acc1_cdt" THEN 
	gs_code = this.GetItemString(this.GetRow(), "acc1_cdt")
	IF IsNull(gs_code) then
		gs_code =""
	end if
	
	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
		this.SetItem(this.GetRow(), "acc1_cdt", Left(gs_code,5))
		this.SetItem(this.GetRow(), "acc2_cdt", Mid(gs_code,6,2))
		this.SetItem(this.GetRow(), "accnamet", gs_codename)
	end if
END IF


end event

type rr_1 from roundrectangle within w_kbga01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 268
integer width = 4503
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 46
end type

