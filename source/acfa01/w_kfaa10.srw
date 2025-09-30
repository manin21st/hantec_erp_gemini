$PBExportHeader$w_kfaa10.srw
$PBExportComments$고정자산 등록
forward
global type w_kfaa10 from w_inherite
end type
type dw_gbn from u_key_enter within w_kfaa10
end type
type dw_lst from u_d_popup_sort within w_kfaa10
end type
type dw_rate from u_key_enter within w_kfaa10
end type
type rr_1 from roundrectangle within w_kfaa10
end type
type rr_2 from roundrectangle within w_kfaa10
end type
end forward

global type w_kfaa10 from w_inherite
string title = "고정자산 등록"
dw_gbn dw_gbn
dw_lst dw_lst
dw_rate dw_rate
rr_1 rr_1
rr_2 rr_2
end type
global w_kfaa10 w_kfaa10

forward prototypes
public subroutine wf_setting_detail (string sref_kfjog)
public function double wf_no (string sjasan, long lno)
public function integer wf_requiredchk ()
public subroutine wf_retrievemode (string mode)
public subroutine wf_init ()
end prototypes

public subroutine wf_setting_detail (string sref_kfjog);String   sKfjog
Integer  iCount,iFindRow,iCurRow

iCount = dw_rate.RowCount()

Declare cur_f2 cursor for
	select rfgub from reffpf where rfcod = 'F2' and rfgub <> '9' and rfgub <> '00'
	order by rfgub ;
	
open cur_f2;
do while true
	fetch cur_f2 into :sKfjog;
	if sqlca.sqlcode <> 0 then exit
	
	iFindRow = dw_rate.Find("kfjog = '"+sKfJog+"'",1,iCount)
	if iFindRow <=0 then
		iCurRow = dw_rate.InsertRow(0)
		
		dw_rate.SetItem(iCurRow,"kfjog", sKfjog)
	end if
loop
close cur_f2;

dw_rate.SetSort("kfjog A")
dw_rate.Sort()

if sref_kfjog = '9' then
	rr_2.Visible = True
	dw_rate.visible = True
else
	rr_2.Visible = False
	dw_rate.visible = False
end if

dw_rate.SetRedraw(True)


end subroutine

public function double wf_no (string sjasan, long lno);Double l_ser_no

IF lno =0 OR IsNull(lno) THEN
	SELECT MAX(A.KFCOD2)  
   	INTO :l_ser_no  
		FROM(SELECT MAX("KFA02OM0"."KFCOD2") AS KFCOD2
					FROM "KFA02OM0"  
					WHERE "KFA02OM0"."KFCOD1" = :sjasan
		  		UNION ALL
			  SELECT MAX("KFZ12OTH"."KFCOD2") 
					FROM "KFZ12OTH"  
					WHERE "KFZ12OTH"."KFCOD1" = :sjasan) A;				
	IF SQLCA.SQLCODE <> 0 THEN
		l_ser_no =1
	ELSE
		IF IsNull(l_ser_no) THEN l_ser_no = 0
		l_ser_no = l_ser_no + 1
	END IF
ELSE
	SELECT "KFA06OT0"."KFCOD2"  
   	INTO :l_ser_no  
    	FROM "KFA06OT0"  
   	WHERE ( "KFA06OT0"."KFCOD1" = :sjasan ) AND  
      	   ( "KFA06OT0"."KFCOD2" = :lno )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		SELECT MAX("KFA02OM0"."KFCOD2")  
   		INTO :l_ser_no  
    		FROM "KFA02OM0"  
   		WHERE "KFA02OM0"."KFCOD1" = :sjasan ;
		IF SQLCA.SQLCODE <> 0 THEN
			l_ser_no =1
		ELSE
			IF IsNull(l_ser_no) THEN l_ser_no = 0
			l_ser_no = l_ser_no + 1
		END IF
	END IF
END IF

Return l_ser_no
end function

public function integer wf_requiredchk ();
String   sKfcod1,sKfName,sKfGubun,sKfsaCod,sKfmdpt,sKfaqdt,sKfChgb,sKfDecp,sKfDegb,sKfJog,sKfDodt,sMandept, sGubun3
Integer  iKfQty
Double   dKfAmt,dKfrAmt,dKfDeAmt,dKfnyr

sKfCod1  = dw_insert.GetItemString(dw_insert.GetRow(), "kfcod1")
sKfName  = dw_insert.GetItemString(dw_insert.GetRow(), "kfname")
sKfGubun = dw_insert.GetItemString(dw_insert.GetRow(), "kfgubun")
sKfsaCod = dw_insert.GetItemString(dw_insert.GetRow(), "kfsacod")	
sKfmdpt  = dw_insert.GetItemString(dw_insert.GetRow(), "kfmdpt")
sKfaqdt  = Trim(dw_insert.GetItemString(dw_insert.GetRow(), "kfaqdt"))
sKfChgb  = dw_insert.GetItemString(dw_insert.GetRow(), "kfchgb")
sKfdecp  = dw_insert.GetItemString(dw_insert.GetRow(), "kfdecp")
dKfnyr   = dw_insert.GetItemNumber(dw_insert.GetRow(), "kfnyr")
sMandept = Trim(dw_insert.GetItemString(dw_insert.GetRow(), "mandept"))
sKfdegb  = dw_insert.GetItemString(dw_insert.GetRow(), "kfdegb")

iKfQty   = dw_insert.GetItemNumber(dw_insert.GetRow(), "kfqnty")
sKfJog   = dw_insert.GetItemString(dw_insert.GetRow(), "kfjog")

dKfAmt   = dw_insert.GetItemNumber(dw_insert.GetRow(), "kfamt")
dKfrAmt  = dw_insert.GetItemNumber(dw_insert.GetRow(), "kfframt")
dKfDeAmt = dw_insert.GetItemNumber(dw_insert.GetRow(), "kfdeamt")

sKfDodt  = Trim(dw_insert.GetItemString(dw_insert.GetRow(), "kfdodt"))
sGubun3 = Trim(dw_insert.GetItemString(dw_insert.GetRow(), "gubun3"))

if sKfCod1 = '' or IsNull(sKfCod1) then
	F_MessageChk(1,'[자산구분]')
	dw_gbn.SetColumn("kfcod1")
	dw_gbn.SetFocus()
	Return -1
end if
if sKfName = '' or IsNull(sKfName) then
	F_MessageChk(1,'[자산명칭]')
	dw_insert.SetColumn("kfname")
	dw_insert.SetFocus()
	Return -1
end if

if iKfQty = 0 or IsNull(iKfQty) then
	F_MessageChk(1,'[수량]')
	dw_insert.SetColumn("kfqnty")
	dw_insert.SetFocus()
	Return -1
end if
if sKfChgb = '' or IsNull(sKfChgb) then
	F_MessageChk(1,'[변동구분]')
	dw_insert.SetColumn("kfchgb")
	dw_insert.SetFocus()
	Return -1
end if

if sKfaqdt = '' or IsNull(sKfaqdt) then
	F_MessageChk(1,'[취득일자]')
	dw_insert.SetColumn("kfaqdt")
	dw_insert.SetFocus()
	Return -1
end if

if dKfAmt = 0 or IsNull(dKfAmt) then
	F_MessageChk(1,'[취득원가]')
	dw_insert.SetColumn("kfamt")
	dw_insert.SetFocus()
	Return -1
end if

if sKfcod1 <> 'A' and (sKfdecp = '' or IsNull(sKfdecp)) then
	F_MessageChk(1,'[상각방법]')
	dw_insert.SetColumn("kfdecp")
	dw_insert.SetFocus()
	Return -1
end if

if dKfnyr = 0 or IsNull(dKfnyr) then
	F_MessageChk(1,'[내용년수]')
	dw_insert.SetColumn("Kfnyr")
	dw_insert.SetFocus()
	Return -1
end if

if sKfGubun = '' or IsNull(sKfGubun) then
	F_MessageChk(1,'[고정자산분류]')
	dw_insert.SetColumn("kfgubun")
	dw_insert.SetFocus()
	Return -1
end if

if sKfcod1 <> 'A' and (sKfdegb = '' or IsNull(sKfdegb)) then
	F_MessageChk(1,'[상각구분]')
	dw_insert.SetColumn("kfdegb")
	dw_insert.SetFocus()
	Return -1
end if
if sKfmdpt = '' or IsNull(sKfmdpt) then
	F_MessageChk(1,'[관리부서]')
	dw_insert.SetColumn("kfmdpt")
	dw_insert.SetFocus()
	Return -1
end if

if sKfsaCod = '' or IsNull(sKfsaCod) then
	F_MessageChk(1,'[사업장]')
	dw_insert.SetColumn("kfsacod")
	dw_insert.SetFocus()
	Return -1
end if

if sMandept = '' or IsNull(sMandept) then
	F_MessageChk(1,'[원가부문]')
	dw_insert.SetColumn("mandept")
	dw_insert.SetFocus()
	Return -1
end if

if sKfcod1 <> 'A' and (sKfjog = '' or IsNull(sKfjog)) then
	F_MessageChk(1,'[제조일반구분]')
	dw_insert.SetColumn("kfjog")
	dw_insert.SetFocus()
	Return -1
else
	if sKfJog = "9" and dw_rate.RowCount() > 0 then									/*공통이면*/
		Double dKfBaegSum
		
		dw_rate.AcceptText()
		
		dKfBaegSum = dw_rate.GetItemNumber(1,"sum_baeg")
		
		if dKfBaegSum = 0  or IsNull(dKfBaegSum) then
			F_MessageChk(1,'[배부기준율]')
			w_mdi_frame.sle_msg.text   = "공통일때는 배부기준상세를 입력하시오."
			dw_rate.SetColumn("kfjog")
			dw_rate.setfocus()
			Return -1
		elseif dKfBaegSum <> 100 then
			F_MessageChk(20,'[배부기준율 합]')
			w_mdi_frame.sle_msg.text   = "배부기준상세의 합은 100이어야 합니다."
			dw_rate.SetColumn("kfjog")
			dw_rate.setfocus()
			Return -1
		end if	
	end if
end if

if sKfCod1 <> 'A' and sKfChgb <> 'A' and (dKfDeAmt = 0 or IsNull(dKfDeAmt)) and sGubun3 = '1' then
	F_MessageChk(1,'[감가상각누계액]')
	dw_insert.SetColumn("kfdeamt")
	dw_insert.SetFocus()
	Return -1
end if

if (sKfChgb = 'H' or sKfChgb = 'I' or sKfChgb = 'J') and (sKfDodt = '' or IsNull(sKfDodt)) then
	F_MessageChk(1,'[전체매각/폐기일]')
	dw_insert.SetColumn("kfdodt")
	dw_insert.SetFocus()
	Return -1
end if

//건물,구축물:40년 그외 5년
//IF sKfCod1 <> "A" THEN
//	IF sKfCod1 = "B" OR sKfCod1 = "C" THEN
//		IF dKfNyr <> 40 THEN
//			MessageBox("확인","건물,구축물의 내용년수는 40년입니다.")
//			dw_insert.SetColumn("kfnyr")
//			dw_insert.SetFocus()
//			Return -1
//		END IF
//	ELSE
//		IF dKfNyr <> 5 THEN
//			MessageBox("확인","건물,구축물을 제외한 고정자산의 내용년수는 5년입니다.")
//			dw_insert.SetColumn("kfnyr")
//			dw_insert.SetFocus()
//			Return -1
//		END IF
//	END IF
//END IF

Return 1
end function

public subroutine wf_retrievemode (string mode);dw_insert.SetRedraw(False)
IF mode ="M" THEN
	dw_insert.SetTabOrder("kfcod1",0)
	dw_insert.SetTabOrder("kfcod2",0)
	dw_insert.SetColumn("kfname")
	
	p_ins.Enabled = True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
ELSE
	dw_insert.SetTabOrder("kfcod1",1)
	dw_insert.SetTabOrder("kfcod2",1)
	dw_insert.SetColumn("kfname")
	
	p_ins.Enabled = False
	p_ins.PictureName = "C:\erpman\image\추가_d.gif"
END IF
dw_insert.SetRedraw(True)
dw_insert.SetFocus()
end subroutine

public subroutine wf_init ();String   sKfcod1,sDecp
Integer  iNyr
Double   dRate

dw_gbn.AcceptText()
sKfCod1 = dw_gbn.GetItemString(1,"kfcod1")

select substr(rfna5,1,1),to_number(nvl(substr(rfna5,2,2),'0')) 			/*상각방법/내용년수*/
	into :sDecp, :iNyr 
	from reffpf 
	where rfcod = 'F1' and rfgub = :sKfCod1;

select nvl(decode(:sDecp,'1',kfsrrat,kfsarat),0)											/*상각율*/
	into :dRate
	from kfa01om0
	where kfnyr = :iNyr ;

ib_any_typing =False

sModStatus ="I"

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.SetItem(dw_insert.GetRow(),"kfcod1", sKfCod1)
dw_insert.SetItem(dw_insert.GetRow(),"kfdecp", sDecp)
dw_insert.SetItem(dw_insert.GetRow(),"kfnyr",  iNyr)
dw_insert.SetItem(dw_insert.GetRow(),"rat",    dRate)

dw_insert.SetRedraw(True)

wf_retrievemode(sModStatus)

dw_rate.SetRedraw(False)
dw_rate.Reset()
Wf_Setting_Detail('9')
dw_rate.SetRedraw(True)



end subroutine

on w_kfaa10.create
int iCurrent
call super::create
this.dw_gbn=create dw_gbn
this.dw_lst=create dw_lst
this.dw_rate=create dw_rate
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_gbn
this.Control[iCurrent+2]=this.dw_lst
this.Control[iCurrent+3]=this.dw_rate
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_kfaa10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_gbn)
destroy(this.dw_lst)
destroy(this.dw_rate)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_gbn.SetTransObject(Sqlca)
dw_gbn.Reset()
dw_gbn.InsertRow(0)
dw_gbn.SetFocus()

dw_lst.SetTransObject(Sqlca)
dw_lst.Reset()

dw_insert.SetTransObject(Sqlca)
dw_rate.SetTransObject(Sqlca)

Wf_Init()



end event

type dw_insert from w_inherite`dw_insert within w_kfaa10
integer x = 1577
integer y = 172
integer width = 3054
integer height = 1820
integer taborder = 30
string dataobject = "d_kfaa103"
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::rbuttondown;

If this.GetColumnName() = 'gubun1' then	
	SetNull(gs_code)
	SetNull(gs_codename)
		
	gs_code = this.GetItemString(this.GetRow(), 'gubun1')
		
	If isnull(gs_code) then gs_code = "" 
	
	Open(w_mchmst_popup)
	
	If gs_code = "" or isnull(gs_code) then Return
	
	this.SetItem(this.GetRow(), 'gubun1', gs_code)
	this.SetItem(this.GetRow(), 'gubun1_nm', gs_codename)
	
	Return
END IF

end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;
Long wnd

wnd =Handle(this)

IF dwo.name ="kfname" OR dwo.name ="kfsize" OR dwo.name = 'kfmekr' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event dw_insert::itemchanged;String  sKfCod1,sKfGubun,sKfSaCod,sKfmDpt,sManDept,sGubun1,sGubun1_nm,sGubun2,sGubun2_nm,sNull,&
		  sKfjog, sKfaqdt, sKfaqYy, sKfYear,sKfChgb,sKfDecp,sKfDegb,sKfDodt
Integer iCurRow,iKfNyr
Double  dRate


SetNull(snull)

iCurRow = this.GetRow()
IF this.GetColumnName() = "kfcod1" THEN
	sKfCod1 = this.GetText()
	IF sKfCod1 = "" OR IsNull(sKfCod1) THEN Return
	
	If IsNull(F_Get_Refferance('F1',sKfCod1)) THEN
		F_MessageChk(20,'[고정자산구분]')
		this.SetItem(iCurRow,"kfcod1",snull)
		Return 1
	END IF
	
	IF sKfCod1 = 'A' THEN												/* 토지일때 */
		this.SetItem(iCurRow,"kfnyr",  0)
		this.SetItem(iCurRow,"kfjyr",  0)
		this.Setitem(iCurRow,"kfdecp", snull)
		this.Setitem(iCurRow,"kfjog",  snull)
		this.Setitem(iCurRow,"kfdegb", '2')
		
		dw_rate.SetRedraw(False)
		dw_rate.Reset()
		Wf_Setting_Detail('')
	
	END IF
END IF

/* 취득일로 부터 변동구분 계산  */
if this.GetColumnName() = "kfaqdt" then
	sKfaqdt = this.GetText()
	if sKfaqdt = '' or IsNull(sKfaqdt) then Return
	
	if F_DateChk(sKfaqdt) = -1 then
		F_Messagechk(21,'[취득일자]')
		this.SetItem(this.GetRow(),"kfaqdt", sNull)
		Return 1
	end if
	
	sKfaqYy = Left(sKfaqdt,4) 
	
	select nvl(kfyear,'0')	into :sKfYear	from kfa07om0 ;
	
	if sKfaqYy > sKfYear then
		F_MessageChk(20,'[취득년도 > 회기]')
		this.SetItem(this.GetRow(),"kfaqdt",sNull)
		Return 1
	end if

	if Long(sKfYear) - Long(sKfaqYy) > 0 then
		this.Setitem(this.GetRow(),"kfchgb","B")
	else
		this.Setitem(this.GetRow(),"kfchgb","A")
	end if
	
	sKfCod1 = this.GetItemString(this.GetRow(),"kfcod1")
	if sKfCod1 <> 'A' then						/*토지가 아니면*/
		iKfNyr = this.GetitemNumber(this.GetRow(),"kfnyr")
		if iKfNyr <> 0 and Not IsNull(iKfNyr) then
			this.Setitem(this.GetRow(),"kfjyr", iKfNyr - (Integer(sKfYear) - Integer(sKfaqYy)))
		else
			this.Setitem(this.GetRow(),"kfjyr", 0)
		End if
	END IF
	
//	dw_insert.SetItem(iCurRow,"kfhalf",F_Check_Half(this.GetItemString(1,"kfchgb"),sKfaqdt))
end if

IF this.GetColumnName() = "kfgubun" THEN
	sKfGubun = this.GetText()
	IF sKfGubun = "" OR IsNull(sKfGubun) THEN Return

	If IsNull(F_Get_Refferance('F7',sKfGubun)) THEN
		F_MessageChk(20,'[고정자산분류]')
		this.SetItem(iCurRow,"kfgubun",snull)
		Return 1
	END IF

	/* 세법상 무형자산일 경우 NUMBER1에 년상각비 보관함*/
	/* 유형,무형구분하여 gubun3에 1유형, 2무형으로 갱신함*/
	IF sKfGubun = '4' THEN
		iKfnyr = this.GetItemNumber(iCurRow,"kfnyr")
		IF IsNull(iKfNyr) THEN iKfnyr = 0
			
		IF iKfnyr <> 0 THEN
			this.SetItem(iCurRow,"number1",Truncate(lstr_jpra.money/ikfnyr,0))
		END IF
		this.SetItem(iCurRow,"gubun3",'2')
	else
		this.SetItem(iCurRow,"gubun3",'1')
	END IF
END IF

if this.GetColumnName() = 'kfamt' then
	if this.GetItemNumber(this.GetRow(),"kfframt") = 0 OR IsNull(this.GetItemNumber(this.GetRow(),"kfframt")) then
		if this.GetText() = '' or IsNull(this.GetText()) then
			this.Setitem(this.GetRow(),"kfframt",0)
		else
			this.Setitem(this.GetRow(),"kfframt",Double(this.GetText()))
		end if
	end if
end if

if this.GetColumnName() = "kfendyy" then
	if this.GetText() = '' or IsNull(this.GetText()) then
	   this.SetItem(this.GetRow(),"kfendgb",'N')
	else
   	this.SetItem(this.GetRow(),"kfendgb",'Y')
	end if
end if

IF this.GetColumnName() = "kfsacod" THEN
	sKfsaCod = this.GetText()
	IF sKfSaCod = "" OR IsNull(sKfSaCod) THEN Return

	If IsNull(F_Get_Refferance('AD',sKfSaCod)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"kfsacod",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "kfmdpt" THEN
	sKfmDpt = this.GetText()
	IF sKfmDpt = "" OR IsNull(sKfmDpt) THEN Return

	If IsNull(F_Get_Personlst('3',sKfmDpt,'1')) THEN
		F_MessageChk(20,'[관리부서]')
		this.SetItem(iCurRow,"kfmdpt",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "kfnyr" THEN
	String  sDecp
	
	iKfNyr = Integer(this.GetText())
	IF IsNull(iKfNyr) THEN iKfnyr = 0
	
	this.SetItem(iCurRow,"kfjyr",iKfNyr)
	
	sDecp = this.GetItemString(iCurRow,"kfdecp")
	if sDecp = '' or IsNull(sDecp) then Return
	
	select decode(:sDecp,'1',kfsrrat,kfsarat)
		into :dRate
		from kfa01om0
		where kfnyr = :iKfNyr ;
	if sqlca.sqlcode = 0 then
		this.SetItem(iCurRow,"rat", dRate)
	end if
END IF

if this.GetColumnName() = "kfjog" then
	sKfjog = this.GetText()
	if sKfjog = '' or IsNull(sKfjog) then Return
	
	if IsNull(F_Get_Refferance('F2',sKfjog)) then
		F_MessageChk(20,'[제조일반구분]')
		this.SetItem(iCurRow,"kfjog", sNull)
		Return 1
	end if
	
	dw_rate.SetRedraw(False)
	dw_rate.Retrieve(this.GetItemString(1,"kfcod1"),this.GetItemNumber(1,"kfcod2"))
	Wf_Setting_Detail(sKfjog)	
end if

If dw_insert.GetColumnName() = 'gubun1' then
	sgubun1 = dw_insert.GetItemString(iCurRow, 'gubun1')
	
	If sgubun1 = "" or Isnull(sgubun1) then
		dw_insert.SetItem(iCurRow, 'gubun1_nm', snull)
		Return
	End If

	SELECT "MCHMST"."MCHNAM"  		INTO :sgubun1_nm  
		FROM "MCHMST"  
	 	WHERE "MCHMST"."MCHNO" = :sgubun1;

	IF SQLCA.SQLCODE = 100 THEN
		f_messagechk(20,"설비번호")
		dw_insert.SetItem(iCurRow, 'gubun1', sNull)
		dw_insert.SetItem(iCurRow, 'gubun1_nm', sNull)
		dw_insert.SetColumn('gubun1')
		dw_insert.SetFocus()
		Return 1
	END IF
	dw_insert.SetItem(iCurRow, 'gubun1_nm', sgubun1_nm)
END IF

if this.GetColumnName() = "kfchgb" then
	sKfChgb = this.GetText()
	if sKfChgb = '' or IsNull(sKfChgb) then Return
	
	if IsNull(F_Get_Refferance('F5',sKfChgb)) then
		F_MessageChk(20,'[변동구분]')
		this.SetItem(iCurRow,"kfchgb", sNull)
		Return 1
	end if
	
	sKfCod1 = this.GetItemString(this.GetRow(),"kfcod1")
	IF sKfCod1 = "A" AND sKfChgb = "K" THEN
		F_MessageChk(20,'[변동구분]')
		w_mdi_frame.sle_msg.text   = "토지는 변동구분을 상각완료로 입력할 수 없습니다."
		this.SetItem(iCurRow,"kfchgb", sNull)
		Return 1
	END IF
	
//	dw_insert.SetItem(iCurRow,"kfhalf",F_Check_Half(sKfChgb,dw_insert.GetItemString(iCurRow,"kfaqdt")))
end if
if this.GetColumnName() = "kfdecp" then
	sKfDecp = this.GetText()
	if sKfDecp = '' or IsNull(sKfDecp) then Return
	
	if IsNull(F_Get_Refferance('F3',sKfDecp)) then
		F_MessageChk(20,'[상각방법]')
		this.SetItem(iCurRow,"kfdecp", sNull)
		Return 1
	end if
	
	iKfnyr = this.GetItemNumber(iCurRow,"kfnyr")
	IF IsNull(iKfNyr) THEN iKfnyr = 0
	
	select decode(:sKfDecp,'1',kfsrrat,kfsarat)
		into :dRate
		from kfa01om0
		where kfnyr = :iKfNyr ;
	if sqlca.sqlcode = 0 then
		this.SetItem(iCurRow,"rat", dRate)
	end if
end if
if this.GetColumnName() = "kfdegb" then
	sKfDegb = this.GetText()
	if sKfDegb = '' or IsNull(sKfDegb) then Return
	
	if IsNull(F_Get_Refferance('F4',sKfDegb)) then
		F_MessageChk(20,'[상각구분]')
		this.SetItem(iCurRow,"kfdegb", sNull)
		Return 1
	end if
end if

if this.GetColumnName() = "kfdodt" then
	sKfDodt = this.GetText()
	if sKfDodt = '' or IsNull(sKfDodt) then Return
	
	if F_DateChk(sKfDodt) = -1 then
		F_Messagechk(21,'[전체매각/폐기일]')
		this.SetItem(this.GetRow(),"kfdodt", sNull)
		Return 1
	end if
	sKfChgb = this.GetItemString(this.GetRow(),"kfchgb")
	
	select nvl(kfyear,'0')	into :sKfYear	from kfa07om0 ;
	
	if sKfChgb = "H" OR sKfChgb = "I" OR sKfChgb = "J" then
		if  Left(sKfDodt,4) > sKfYear then
			F_MessageChk(20,'[전체매각/폐기일]')
			w_mdi_frame.sle_msg.text = "고정자산 회기년도보다 전체매각 / 폐기년도가 클 수 없습니다."
			this.SetItem(this.GetRow(),"kfdodt", sNull)
			Return 1
		end if
	else
		w_mdi_frame.sle_msg.text   = "전체매각 / 폐기일은 변동구분이 H,I,J 일때만 입력합니다."
		this.SetItem(this.GetRow(),"kfdodt",sNull)
		Return 2
	end if
end if


end event

type p_delrow from w_inherite`p_delrow within w_kfaa10
boolean visible = false
integer x = 2185
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfaa10
boolean visible = false
integer x = 2011
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfaa10
boolean visible = false
integer x = 1650
integer y = 20
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfaa10
integer x = 3735
integer taborder = 60
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;
dw_lst.SelectRow(0,False)

Wf_Init()
end event

type p_exit from w_inherite`p_exit within w_kfaa10
integer x = 4430
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_kfaa10
integer x = 4256
integer taborder = 90
end type

event p_can::clicked;call super::clicked;
Wf_Init()
end event

type p_print from w_inherite`p_print within w_kfaa10
boolean visible = false
integer x = 1833
integer y = 20
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfaa10
integer x = 3561
integer taborder = 50
end type

event p_inq::clicked;call super::clicked;
String sKfcod

if dw_gbn.AcceptText() = -1 then Return
sKfcod = dw_gbn.GetItemString(1,"kfcod1")
if sKfcod = '' or IsNull(sKfcod) then
	F_MessageChk(1,'[자산구분]')
	dw_gbn.SetColumn("kfcod1")
	dw_gbn.SetFocus()
	Return
end if

dw_lst.Retrieve(sKfcod)

Wf_Init()
end event

type p_del from w_inherite`p_del within w_kfaa10
integer x = 4082
integer taborder = 80
end type

event p_del::clicked;String   sKfCod1
Double   dKfCod2

if dw_lst.GetSelectedRow(0) <=0 then
	F_MessageChk(11,'')
	Return
end if

dw_insert.AcceptText()
sKfCod1   = dw_insert.GetitemString(dw_insert.GetRow(),"kfcod1")
dKfCod2   = dw_insert.GetitemNumber(dw_insert.GetRow(),"kfcod2")

IF F_DbConFirm('삭제') = 2 THEN Return

dw_insert.SetRedraw(False)
dw_insert.DeleteRow(0)

IF dw_insert.update() = 1 THEN	
	delete from kfa02ot0 where kfcod1 = :sKfcod1 and kfcod2 = :dKfcod2;
	
	COMMIT;
	
	dw_lst.SetRedraw(False)
	dw_lst.Retrieve(sKfcod1)
	dw_lst.SelectRow(0,False) 
	dw_lst.SetRedraw(True)
	
	dw_insert.SetRedraw(True)
	w_mdi_frame.sle_msg.text   = "자료가 삭제되었습니다"
	ib_any_typing = False
ELSE
	F_MessageChk(12,'')
	w_mdi_frame.sle_msg.text   = "자료 삭제를 실패하였습니다.!!"
	ROLLBACK;
	return
END IF

ib_any_typing = False

Wf_Init()
end event

type p_mod from w_inherite`p_mod within w_kfaa10
integer x = 3909
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;String   sKfcod1,sKfJog ,skfcod2
Double   lKfcod2

if dw_insert.AcceptText() = -1 then Return
if dw_insert.GetRow() <=0 then Return

sKfcod1  = dw_insert.GetItemString(1,"kfcod1")
sKfJog   = dw_insert.GetItemString(1,"kfjog")
lKfcod2  =dw_insert.GetItemNumber(1,"Kfcod2")
if Wf_RequiredChk() = -1 then Return

if f_dbconfirm("저장") = 2 then Return

if sModStatus ="I" then
	
	if lkfcod2  = 0 or isnull(lkfcod2) then 
		
		lkfcod2 = wf_no(skfcod1,lkfcod2)
		
		if lkfcod2 = -1 THEN
			MessageBox("확 인","일련번호 채번을 실패하였습니다.!!")
			dw_insert.SetColumn("kfname")
			dw_insert.setfocus()	 
			Return
		ELSE
			dw_insert.SetItem(dw_insert.GetRow(),"kfcod2",lkfcod2)
		END IF
		end if
else
	lKfcod2  = dw_insert.GetItemNumber(1,"kfcod2")
end if

if dw_insert.Update() = 1 then
	delete from kfa06ot0 where kfcod1 = :sKfcod1 and kfcod2 = :lKfcod2;
	
	if sKfJog = '9' then				/*공통일 경우 배부기준상세 저장*/
		Integer i,iRow
		Double  dKfBaeg
		
		iRow = dw_rate.RowCount()
		if iRow > 0 then
			dw_rate.SetRedraw(False)
			for i = iRow to 1 step -1
				dKfBaeg = dw_rate.GetItemNumber(i, "kfbaeg")
				if dKfBaeg = 0 or IsNull(dKfBaeg) then
					dw_rate.DeleteRow(i)
				else
					dw_rate.SetItem(i,"kfcod1", sKfcod1)
					dw_rate.SetItem(i,"kfcod2", lKfcod2)
				end if
			next
			dw_rate.SetRedraw(True)
			if dw_rate.Update() <> 1 then
				F_MessageChk(13,'[배부율 상세]')
				Rollback;
				Return
			end if
		end if
	else
		delete from kfa02ot0 where kfcod1 = :sKfcod1 and kfcod2 = :lKfcod2;
	end if
	
	Commit;
	w_mdi_frame.sle_msg.text   = "자료가 저장되었습니다."
	
	sModStatus ="M"
	wf_retrievemode(sModStatus)

	ib_any_typing = False
	dw_lst.SetRedraw(False)
	dw_lst.Retrieve(sKfcod1)
	dw_lst.SelectRow(dw_lst.Find("str_kfcod2 = '" + String(lKfcod2) + "'",1,dw_lst.RowCount()),True) 
	dw_lst.SetRedraw(True)
	
else
	F_MessageChk(12,'')
   ROLLBACK;
	Return
end if



end event

type cb_exit from w_inherite`cb_exit within w_kfaa10
end type

type cb_mod from w_inherite`cb_mod within w_kfaa10
end type

type cb_ins from w_inherite`cb_ins within w_kfaa10
end type

type cb_del from w_inherite`cb_del within w_kfaa10
end type

type cb_inq from w_inherite`cb_inq within w_kfaa10
end type

type cb_print from w_inherite`cb_print within w_kfaa10
end type

type st_1 from w_inherite`st_1 within w_kfaa10
end type

type cb_can from w_inherite`cb_can within w_kfaa10
end type

type cb_search from w_inherite`cb_search within w_kfaa10
end type







type gb_button1 from w_inherite`gb_button1 within w_kfaa10
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa10
end type

type dw_gbn from u_key_enter within w_kfaa10
integer x = 37
integer y = 20
integer width = 1449
integer height = 152
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfaa101"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;
String sKfCod,sNull

SetNull(sNull)

if this.GetColumnName() = "kfcod1" then
	sKfcod = this.GetText()
	if sKfcod = '' or IsNull(sKfcod) then Return
	
	if IsNull(F_Get_Refferance('F1',sKfcod)) then
		F_MessageChk(20,'[자산구분]')
		this.SetItem(this.GetRow(),"kfcod1", sNull)
		Return 1
	else
		p_inq.TriggerEvent(Clicked!)
	end if
end if
end event

type dw_lst from u_d_popup_sort within w_kfaa10
integer x = 50
integer y = 184
integer width = 1513
integer height = 2024
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_kfaa102"
boolean vscrollbar = true
boolean border = false
end type

event clicked;
If Row <= 0 then
	dw_lst.SelectRow(0,False)
	b_flag = True
ELSE
	dw_lst.SelectRow(0,False)
	dw_lst.SelectRow(row,True)

	dw_insert.SetRedraw(False)
	dw_insert.Retrieve(dw_lst.GetItemString(Row,"kfcod1"),dw_lst.GetItemNumber(Row,"kfcod2"))
	dw_insert.SetRedraw(True)
	
	sModStatus ="M"
	wf_retrievemode(sModStatus)
	
	dw_rate.Retrieve(dw_lst.GetItemString(Row,"kfcod1"),dw_lst.GetItemNumber(Row,"kfcod2"))
	Wf_Setting_Detail(dw_lst.GetItemString(row,"kfjog"))

	b_Flag = False
END IF

call super ::clicked
end event

type dw_rate from u_key_enter within w_kfaa10
integer x = 1646
integer y = 2024
integer width = 2889
integer height = 168
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_kfaa104"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfaa10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 176
integer width = 1531
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfaa10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1582
integer y = 2004
integer width = 3017
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

