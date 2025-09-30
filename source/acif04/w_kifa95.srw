$PBExportHeader$w_kifa95.srw
$PBExportComments$본점 송부전표 처리(전표기준)
forward
global type w_kifa95 from w_inherite
end type
type rr_1 from roundrectangle within w_kifa95
end type
type gb_1 from groupbox within w_kifa95
end type
type rb_1 from radiobutton within w_kifa95
end type
type rb_2 from radiobutton within w_kifa95
end type
type dw_junpoy from datawindow within w_kifa95
end type
type dw_sungin from datawindow within w_kifa95
end type
type dw_print from datawindow within w_kifa95
end type
type dw_ip from u_key_enter within w_kifa95
end type
type cbx_all from checkbox within w_kifa95
end type
type dw_delete from datawindow within w_kifa95
end type
type dw_rtv from datawindow within w_kifa95
end type
end forward

global type w_kifa95 from w_inherite
integer height = 2476
string title = "본점 송부 전표 처리"
rr_1 rr_1
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_ip dw_ip
cbx_all cbx_all
dw_delete dw_delete
dw_rtv dw_rtv
end type
global w_kifa95 w_kifa95

type variables
String sUpmuGbn = 'S',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate)
end prototypes

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i
String  sSaupj,sBalDate,sUpmuGu
Long    lJunNo

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = dw_delete.GetItemString(k,"bal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no")
		
		iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
		IF iRowCount <=0 THEN Return 1
		
		FOR i = iRowCount TO 1 STEP -1							/*전표 삭제*/
			dw_junpoy.DeleteRow(i)		
		NEXT

		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(12,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		END IF
	END IF
NEXT
COMMIT;

SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate);/************************************************************************************/
/* 본점 송부 자동전표를 처리한다.																	*/
/* 1. 채무 : 차변 - 선택된 자료의 계정과목														*/
/* 	       대변 - 받는 사업장의 본점 계정과목													*/
/* 1. 채권 : 차변 - 받는 사업장의 본점 계정과목													*/
/* 	       대변 - 선택된 자료의 계정과목														*/
/************************************************************************************/
Integer k,iCurRow
String  sAcCd,sChaDae,sAcc1_Cha,sAcc2_Cha,sDcGbn,sAcc1_Dae,sAcc2_Dae
Long    lJunNo,lLinNo
Double  dAmount

dw_ip.AcceptText()
sAcCd     = dw_ip.GetItemString(1,"accd")

select dc_gu into :sChaDae from kfz01om0 where acc1_cd||acc2_cd = :sAcCd ;

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="본점 송부 전표 처리 중 ..."

SetPointer(HourGlass!)

dw_junpoy.Reset()
dw_sungin.Reset()

/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
lLinNo = 1

if sChaDae = '1' then							/*자산계정*/
	select substr(rfna2,1,5), substr(rfna2,6,2) into :sAcc1_Cha, :sAcc2_Cha 
		from reffpf where rfcod = 'BR' and rfgub = :sSaupj ;
		
	sDcGbn = '1'									
			
	dAmount = dw_rtv.GetItemNumber(1,"sum_selectamt")
	if IsNull(dAmount) then dAmount = 0
	
	iCurRow = dw_junpoy.InsertRow(0)
		
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
	
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   f_get_refferance('AD',sSaupj) +' 에서 본점 송부')
	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	lLinNo = lLinNo + 1
	
	sDcGbn = '2'
	
	sAcc1_Dae = Left(sAcCd,5)
	sAcc2_Dae = Right(sAcCd,2)
	
	FOR k = 1 TO dw_rtv.RowCount()	
		IF dw_rtv.GetItemString(k,"chk") = '1' THEN
			dAmount = dw_rtv.GetItemNumber(k,"amt")	
			if IsNull(dAmount) then dAmount = 0
			
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
			
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
			dw_junpoy.SetItem(iCurRow,"descr",   dw_rtv.GetItemString(k,"descr"))
			
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
			
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"saup_no"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"saupnm"))
						
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			lLinNo = lLinNo + 1			
		END IF
	NEXT
else
	sDcGbn = '1'
	
	sAcc1_Cha = Left(sAcCd,5)
	sAcc2_Cha = Right(sAcCd,2)
	
	FOR k = 1 TO dw_rtv.RowCount()	
		IF dw_rtv.GetItemString(k,"chk") = '1' THEN
			dAmount = dw_rtv.GetItemNumber(k,"amt")	
			if IsNull(dAmount) then dAmount = 0
			
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
			
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
			dw_junpoy.SetItem(iCurRow,"descr",   dw_rtv.GetItemString(k,"descr"))
			
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
			
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"saup_no"))
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"saupnm"))
			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			lLinNo = lLinNo + 1			
		END IF
	NEXT
	
	sDcGbn = '2'
	
	select substr(rfna2,1,5), substr(rfna2,6,2) into :sAcc1_Dae, :sAcc2_Dae
		from reffpf where rfcod = 'BR' and rfgub = :sSaupj ;
	
	dAmount = dw_rtv.GetItemNumber(1,"sum_selectamt")
	if IsNull(dAmount) then dAmount = 0
	
	iCurRow = dw_junpoy.InsertRow(0)
		
	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
	
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   f_get_refferance('AD',sSaupj) +' 에서 본점 송부')
	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	lLinNo = lLinNo + 1
	
end if

IF dw_junpoy.Update() <> 1 THEN
	Rollback;
	F_MessageChk(13,'[미승인전표]')
	SetPointer(Arrow!)
	Return -1
END IF
COMMIT;

w_mdi_frame.sle_msg.text ="본점 송부 전표 처리 완료!!"

Return 1
end function

on w_kifa95.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.cbx_all=create cbx_all
this.dw_delete=create dw_delete
this.dw_rtv=create dw_rtv
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.dw_junpoy
this.Control[iCurrent+6]=this.dw_sungin
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.dw_ip
this.Control[iCurrent+9]=this.cbx_all
this.Control[iCurrent+10]=this.dw_delete
this.Control[iCurrent+11]=this.dw_rtv
end on

on w_kifa95.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.cbx_all)
destroy(this.dw_delete)
destroy(this.dw_rtv)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"sdate",Left(f_today(),6)+"01")
dw_ip.SetItem(dw_ip.Getrow(),"edate",f_today())
dw_ip.SetItem(dw_ip.Getrow(),"baldate",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 21 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("sdate")
dw_ip.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_kifa95
boolean visible = false
integer x = 41
integer y = 3084
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa95
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa95
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa95
boolean visible = false
integer x = 3776
integer y = 2940
integer taborder = 0
boolean originalsize = true
string picturename = "C:\erpman\image\상세조회_up.gif"
end type

event p_search::clicked;call super::clicked;Integer iSelectRow

SetNull(Gs_Code)

IF rb_1.Checked = True THEN
	iSelectRow = dw_rtv.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return

	Gs_Code = dw_rtv.GetItemString(iSelectRow,"sugum_no")	 			/*수금번호*/
	
	Open(w_kifa05a)
ELSE
	iSelectRow = dw_delete.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return

	Gs_Code = dw_delete.GetItemString(iSelectRow,"sugum_no")	 			/*수금번호*/
	
	Open(w_kifa05a)
END IF
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\상세조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\상세조회_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kifa95
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa95
integer y = 16
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa95
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa95
boolean visible = false
integer y = 3120
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iRtnVal

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

sSaupj   = dw_junpoy.GetItemString(1,"saupj")
sBalDate = dw_junpoy.GetItemString(1,"bal_date") 
sUpmuGu  = dw_junpoy.GetItemString(1,"upmu_gu") 
lBJunNo  = dw_junpoy.GetItemNumber(1,"bjun_no") 

select distinct jun_no into :lJunNo	from kfz10ot0 
	where saupj = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmuGu and bjun_no = :lBJunNo;
if sqlca.sqlcode = 0 then
	iRtnVal = F_Call_JunpoyPrint(dw_print,'Y',sJunGbn,sSaupj,sBalDate,sUpmuGu,lJunNo,sPrtGbn,'P')
else
	iRtnVal = F_Call_JunpoyPrint(dw_print,'N',sJunGbn,sSaupj,sBalDate,sUpmuGu,lBJunNo,sPrtGbn,'P')
end if
		
IF iRtnVal = -1 THEN
	F_MessageChk(14,'')
	Return -1
ELSEIF iRtnVal = -2 THEN
	Return 1
ELSE	
	sPrtGbn = '1'
END IF
end event

type p_inq from w_inherite`p_inq within w_kifa95
integer x = 4096
integer y = 16
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaupjSend,sDtf,sDtT,sAcc

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupjSend   = dw_ip.GetItemString(dw_ip.GetRow(),"send_saupj")
sDtf         = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"sdate"))
sDtT         = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"edate"))
sAcc         = dw_ip.GetItemString(dw_ip.GetRow(),"accd")

IF sSaupjSend ="" OR IsNull(sSaupjSend) THEN
	F_MessageChk(1,'[보내는사업장]')	
	dw_ip.SetColumn("send_saupj")
	dw_ip.SetFocus()
	Return 
END IF

IF sDtf = "" OR IsNull(sDtf) THEN
	F_MessageChk(1,'[전표일자]')	
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return 
END IF
IF sDtT = "" OR IsNull(sDtT) THEN
	F_MessageChk(1,'[전표일자]')	
	dw_ip.SetColumn("edate")
	dw_ip.SetFocus()
	Return 
END IF
IF sAcc ="" OR IsNull(sAcc) THEN
	F_MessageChk(1,'[계정과목]')	
	dw_ip.SetColumn("accd")
	dw_ip.SetFocus()
	Return 
END IF

IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sSaupjSend,sAcc,sDtf,sDtT) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaupjSend,sAcc,sDtf,sDtT) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
	
END IF
p_mod.Enabled =True
p_search.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa95
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa95
integer x = 4270
integer y = 16
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;String  sSaupj,sBalDate,sRcvGbn

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"send_saupj")
sBalDate = dw_ip.GetItemString(dw_ip.GetRow(),"baldate")

IF rb_1.Checked =True THEN
	IF sBalDate = '' or IsNull(sBalDate) THEN
		F_MessageChk(1,'[전표작성일자]')	
		dw_ip.SetColumn("baldate")
		dw_ip.SetFocus()
		Return
	ELSE
		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(29,'[발행일자]')
			Return
		END IF		
	END IF
	
	IF dw_rtv.RowCount() <=0 THEN Return
	
	IF Wf_Insert_Kfz12ot0(sSaupj,sBalDate) = -1 THEN
		Rollback;
		Return
	END IF
	
	/*자동 승인 처리*/
	IF LsAutoSungGbn = 'Y' THEN
		w_mdi_frame.sle_msg.text = '승인 처리 중...'
		IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
			Rollback;
			
			p_print.TriggerEvent(Clicked!)
	
			SetPointer(Arrow!)
			Return -1
		ELSE
			Commit;
			
			p_print.TriggerEvent(Clicked!)
	
		END IF
	ELSE
		p_print.TriggerEvent(Clicked!)		
	END IF

ELSE
	IF dw_delete.RowCount() <=0 THEN Return
	
	IF Wf_Delete_Kfz12ot0() = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kifa95
boolean visible = false
integer x = 4302
integer y = 2752
end type

type cb_mod from w_inherite`cb_mod within w_kifa95
boolean visible = false
integer x = 3941
integer y = 2752
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa95
boolean visible = false
integer x = 2350
integer y = 2748
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa95
boolean visible = false
integer x = 2693
integer y = 2748
end type

type cb_inq from w_inherite`cb_inq within w_kifa95
boolean visible = false
integer x = 3579
integer y = 2752
end type

type cb_print from w_inherite`cb_print within w_kifa95
boolean visible = false
integer x = 2706
integer y = 2748
end type

type st_1 from w_inherite`st_1 within w_kifa95
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kifa95
boolean visible = false
integer x = 2345
integer y = 2628
end type

type cb_search from w_inherite`cb_search within w_kifa95
boolean visible = false
integer x = 3113
integer y = 2756
integer width = 439
string text = "수금상세(&V)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kifa95
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kifa95
boolean visible = false
integer height = 88
end type

type gb_10 from w_inherite`gb_10 within w_kifa95
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kifa95
boolean visible = false
integer x = 2304
integer y = 2580
integer height = 308
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa95
boolean visible = false
integer x = 3067
integer y = 2696
integer width = 1609
end type

type rr_1 from roundrectangle within w_kifa95
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 244
integer width = 4558
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

type gb_1 from groupbox within w_kifa95
integer x = 3168
integer y = 8
integer width = 690
integer height = 224
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "작업선택"
end type

type rb_1 from radiobutton within w_kifa95
integer x = 3195
integer y = 92
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표발행"
boolean checked = true
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("sdate")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa95
integer x = 3520
integer y = 92
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표삭제"
end type

event clicked;IF rb_2.Checked =True THEN
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("sdate")
dw_ip.SetFocus()


end event

type dw_junpoy from datawindow within w_kifa95
boolean visible = false
integer x = 50
integer y = 2608
integer width = 1070
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "전표 저장"
string dataobject = "d_kifa106"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+' '+String(row))
end event

type dw_sungin from datawindow within w_kifa95
boolean visible = false
integer x = 50
integer y = 2716
integer width = 1070
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
end event

type dw_print from datawindow within w_kifa95
boolean visible = false
integer x = 50
integer y = 2824
integer width = 1070
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "전표 인쇄"
string dataobject = "dw_kglb01_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ip from u_key_enter within w_kifa95
event ue_key pbm_dwnkey
integer x = 46
integer y = 16
integer width = 3127
integer height = 220
integer taborder = 10
string dataobject = "d_kifa951"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sBnkNo,sChoose,sdeptCode,sCust,sCustName,sDeptName
Integer i

SetNull(snull)

IF this.GetColumnName() ="sabu" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[사업장]")
		dw_ip.SetItem(1,"sabu",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="saledtf" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"수금일자")
		dw_ip.SetItem(1,"saledtf",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saledtt" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"수금일자")
		dw_ip.SetItem(1,"saledtt",snull)
		Return 1
	END IF
END IF
end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="bnk_no" THEN
	
	OpenWithParm(W_Kfz04om0_POPUP,'5')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"bnk_no",lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"name",  lstr_custom.name)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type cbx_all from checkbox within w_kifa95
integer x = 4274
integer y = 164
integer width = 338
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;Integer i

w_mdi_frame.sle_msg.text = '자료 선택 중...'
if cbx_all.Checked = True then
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'1')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'1')
		NEXT
	END IF
else
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'0')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'0')
		NEXT
	END IF	
end if
w_mdi_frame.sle_msg.text = ''
end event

type dw_delete from datawindow within w_kifa95
integer x = 69
integer y = 252
integer width = 4526
integer height = 1996
integer taborder = 40
string dataobject = "d_kifa953"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

end event

type dw_rtv from datawindow within w_kifa95
integer x = 69
integer y = 252
integer width = 4526
integer height = 1996
integer taborder = 30
string dataobject = "d_kifa952"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemerror;Return 1
end event

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

end event

