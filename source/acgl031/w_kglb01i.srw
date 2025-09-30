$PBExportHeader$w_kglb01i.srw
$PBExportComments$전표 등록 : 자산관리-고정자산 신규
forward
global type w_kglb01i from w_inherite
end type
type dw_1 from datawindow within w_kglb01i
end type
type gb_1 from groupbox within w_kglb01i
end type
type dw_baeg from u_key_enter within w_kglb01i
end type
end forward

global type w_kglb01i from w_inherite
integer x = 59
integer y = 144
integer width = 3584
integer height = 2036
string title = "고정자산 등록(신규취득)"
boolean controlmenu = false
boolean minbox = false
windowtype windowtype = response!
dw_1 dw_1
gb_1 gb_1
dw_baeg dw_baeg
end type
global w_kglb01i w_kglb01i

type variables
Boolean     ib_changed
end variables

forward prototypes
public function integer wf_update_new (string sym, string syear, string skfcod1, double lkfcod2, double damt, string sgbn)
public subroutine wf_setting_detail (string sref_kfjog)
public function integer wf_requiredchk (integer irow)
public function double wf_no (string sjasan)
end prototypes

public function integer wf_update_new (string sym, string syear, string skfcod1, double lkfcod2, double damt, string sgbn);
String sMonth

sMonth = Mid(sym,5,2)
IF sGbn = 'UPDATE' THEN
	IF sMonth = '01' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR01" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;
	ELSEIF sMonth = '02' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR02" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;
	ELSEIF sMonth = '03' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR03" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;		
	ELSEIF sMonth = '04' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR04" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;
	ELSEIF sMonth = '05' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR05" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;
	ELSEIF sMonth = '06' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR06" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;
	ELSEIF sMonth = '07' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR07" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;		
	ELSEIF sMonth = '08' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR08" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;		
	ELSEIF sMonth = '09' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR09" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;		
	ELSEIF sMonth = '10' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR10" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;
	ELSEIF sMonth = '11' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR11" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;
	ELSEIF sMonth = '12' THEN
		UPDATE "KFA04OM0"  
	   	SET "KFDR12" = :damt,   
				 "KFAMT" = 0
     		WHERE ( "KFA04OM0"."KFYEAR" = :sYear ) AND ( "KFA04OM0"."KFCOD1" = :skfcod1 ) AND  
         		( "KFA04OM0"."KFCOD2" = :lkfcod2 )   ;
	END IF	
ELSE
	INSERT INTO "KFA04OM0"  
		( "KFYEAR" ,"KFCOD1" ,"KFCOD2" ,"KFAMT"  ,"KFDEAMT",
		  "KFDR01",
		  "KFDR02",   
		  "KFDR03",
		  "KFDR04",
		  "KFDR05",
		  "KFDR06",
		  "KFDR07",
		  "KFDR08",
		  "KFDR09",   
		  "KFDR10",
		  "KFDR11",
		  "KFDR12",
		  "KFCR01" ,"KFCR02" ,"KFCR03","KFCR04",   
		  "KFCR05" ,"KFCR06" ,"KFCR07" ,"KFCR08" ,"KFCR09" ,"KFCR10","KFCR11",   
		  "KFCR12" ,"KFDE01" ,"KFDE02" ,"KFDE03" ,"KFDE04" ,"KFDE05","KFDE06",   
		  "KFDE07" ,"KFDE08" ,"KFDE09" ,"KFDE10" ,"KFDE11" ,"KFDE12","KFDEDT",
		  "KFJAN01","KFJAN02","KFJAN03","KFJAN04","KFJAN05",
		  "KFDN01" ,"KFDN02" ,"KFDN03" ,"KFDN04" ,"KFDN05", "KFDN06",   
		  "KFDN07" ,"KFDN08" ,"KFDN09" ,"KFDN10" ,"KFDN11", "KFDN12",
		  "KDEPVAL","KDIFFVAL")  
	VALUES 
		( :syear,  :skfcod1,  :lkfcod2, 0,	   0,			  
		  decode(:sMonth,'01',:damt,0),
		  decode(:sMonth,'02',:damt,0),
		  decode(:sMonth,'03',:damt,0),
		  decode(:sMonth,'04',:damt,0),
		  decode(:sMonth,'05',:damt,0),
		  decode(:sMonth,'06',:damt,0),
		  decode(:sMonth,'07',:damt,0),
		  decode(:sMonth,'08',:damt,0),
		  decode(:sMonth,'09',:damt,0),
		  decode(:sMonth,'10',:damt,0),
		  decode(:sMonth,'11',:damt,0),
		  decode(:sMonth,'12',:damt,0),
		  0,			0,			0,			0,
		  0,			0,			0,			0,			0,			0,		  0,
		  0,			0,			0,			0,			0,			0,		  0,
		  0,			0,			0,			0,			0,			0,		  0,
		  0,			0,			0,			0,			0,
		  0,			0,			0,			0,			0,			0,
		  0,			0,			0,			0,			0,			0,
		  0,			0)  ;
		  
END IF
Return 1
end function

public subroutine wf_setting_detail (string sref_kfjog);String   sKfjog
Integer  iCount,iFindRow,iCurRow

iCount = dw_baeg.RowCount()

Declare cur_f2 cursor for
	select rfgub from reffpf where rfcod = 'F2' and rfgub <> '9' and rfgub <> '00'
	order by rfgub ;
	
open cur_f2;
do while true
	fetch cur_f2 into :sKfjog;
	if sqlca.sqlcode <> 0 then exit
	
	iFindRow = dw_baeg.Find("kfjog = '"+sKfJog+"'",1,iCount)
	if iFindRow <=0 then
		iCurRow = dw_baeg.InsertRow(0)
		
		dw_baeg.SetItem(iCurRow,"kfjog", sKfjog)
	end if
loop
close cur_f2;

dw_baeg.SetSort("kfjog A")
dw_baeg.Sort()

if sref_kfjog = '9' then
	gb_1.Visible = True
	dw_baeg.visible = True
else
	gb_1.Visible = False
	dw_baeg.visible = False
end if

dw_baeg.SetRedraw(True)


end subroutine

public function integer wf_requiredchk (integer irow);String  sKfCod1, sManDept,sKfName,sSaupj,sKfGubun,sGbn3,sKfmDpt,sKfAqdt,sKfDecp,sKfJog
Double  dKfqnty,dKfBaegSum,dKfnyr
Integer iKfBaeg

dw_1.AcceptText()
sKfCod1   = dw_1.GetItemString(1,"kfcod1")
sKfName   = dw_1.GetItemString(1,"kfname")
sManDept  = dw_1.GetItemString(1,"mandept")
sKfGubun  = dw_1.GetItemString(1,"kfgubun")
sGbn3     = dw_1.GetItemString(1,"gubun3")
sSaupj    = dw_1.GetItemString(1,"kfsacod")
sKfmDpt	 = dw_1.GetItemString(1,"kfmdpt")
sKfAqdt	 = dw_1.GetItemString(1,"kfaqdt")
sKfDecp   = dw_1.GetItemString(1,"kfdecp")
dKfnyr    = dw_1.GetItemNumber(1,"kfnyr")
sMandept  = Trim(dw_1.GetItemString(1,"mandept"))
dKfqnty   = dw_1.GetItemNumber(1,"kfqnty")

sKfJog    = dw_1.GetItemString(1,"kfjog")
iKfBaeg   = dw_1.GetItemNumber(1,"kfbaeg")
IF IsNull(iKfBaeg) THEN iKfBaeg = 0

IF sKfCod1 = "" OR IsNull(sKfCod1) THEN
	F_MessageChk(1,'[고정자산구분]')
	dw_1.SetColumn("kfcod1")
	dw_1.SetFocus()
	Return -1
END IF

IF sKfname = "" OR IsNull(sKfname) THEN
	F_MessageChk(1,'[고정자산명칭]')
	dw_1.SetColumn("kfname")
	dw_1.SetFocus()
	Return -1
END IF

IF sKfGubun = "" OR IsNull(sKfGubun) THEN
	F_MessageChk(1,'[고정자산분류]')
	dw_1.SetColumn("kfgubun")
	dw_1.SetFocus()
	Return -1
END IF

IF sGbn3 = "" OR IsNull(sGbn3) THEN
	F_MessageChk(1,'[고정자산분류]')
	dw_1.SetColumn("gubun6")
	dw_1.SetFocus()
	Return -1
END IF

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("kfsacod")
	dw_1.SetFocus()
	Return -1
END IF

IF sKfmDpt = "" OR IsNull(sKfmDpt) THEN
	F_MessageChk(1,'[관리부서]')
	dw_1.SetColumn("kfmdpt")
	dw_1.SetFocus()
	Return -1
END IF

IF sKfAqdt = "" OR IsNull(sKfAqdt) THEN
	F_MessageChk(1,'[취득일자]')
	dw_1.SetColumn("kfaqdt")
	dw_1.SetFocus()
	Return -1
END IF

IF sKfDecp = "" OR IsNull(sKfDecp) THEN
	F_MessageChk(1,'[상각방법]')
	dw_1.SetColumn("kfdecp")
	dw_1.SetFocus()
	Return -1
END IF

if dKfnyr = 0 or IsNull(dKfnyr) then
	F_MessageChk(1,'[내용년수]')
	dw_1.SetColumn("Kfnyr")
	dw_1.SetFocus()
	Return -1
end if

if sMandept = '' or IsNull(sMandept) then
	F_MessageChk(1,'[원가부문]')
	dw_1.SetColumn("mandept")
	dw_1.SetFocus()
	Return -1
end if

if sKfJog = "9" and dw_baeg.RowCount() > 0 then													/*공통이면*/
	dw_baeg.AcceptText()
	
	dKfBaegSum = dw_baeg.GetItemNumber(1,"sum_baeg")
	
	if dKfBaegSum = 0  or IsNull(dKfBaegSum) then
   	F_MessageChk(1,'[배부기준율]')
    	dw_baeg.setfocus()
    	DW_baeg.SetColumn("KFjog")
    	Return -1
	elseif dKfBaegSum <> 100 then
    	F_MessageChk(20,'[배부율의 합 = 100]')
    	dw_baeg.setfocus()
    	DW_baeg.SetColumn("KFjog")
    	Return -1
   end if	
end if

IF dKfqnty = 0 OR IsNull(dKfqnty) THEN
	F_MessageChk(1,'[수량]')
	dw_1.SetColumn("kfqnty")
	dw_1.SetFocus()
	Return -1
END IF

//건물,구축물:40년 그외 5년
IF sKfCod1 <> "A" THEN
	IF sKfCod1 = "B" OR sKfCod1 = "C" THEN
		IF dKfNyr <> 40 THEN
			MessageBox("확인","건물,구축물의 내용년수는 40년입니다.")
			dw_1.SetColumn("kfnyr")
			dw_1.SetFocus()
			Return -1
		END IF
	ELSE
		IF dKfNyr <> 5 THEN
//			MessageBox("확인","건물,구축물을 제외한 고정자산의 내용년수는 5년입니다.")
//			dw_1.SetColumn("kfnyr")
//			dw_1.SetFocus()
//			Return -1
		END IF
	END IF
END IF

Return 1
end function

public function double wf_no (string sjasan);Double dNo,dKfYear

dKfYear = Double(Mid(dw_1.GetItemString(dw_1.GetRow(),"kfaqdt"),1,4)+"0000")

SELECT MAX(A.KFCOD2)
	INTO :dNo
	FROM(SELECT MAX("KFA02OM0"."KFCOD2") AS KFCOD2
				FROM "KFA02OM0"  
				WHERE "KFA02OM0"."KFCOD1" = :sjasan
				  AND "KFA02OM0"."KFCOD2" > :dKfYear
		  UNION ALL
		  SELECT MAX("KFZ12OTH"."KFCOD2") 
				FROM "KFZ12OTH"  
				WHERE "KFZ12OTH"."KFCOD1" = :sjasan
				  AND "KFZ12OTH"."KFCOD2" > :dKfYear) A;

IF SQLCA.SQLCODE <> 0 THEN
	dNo = dKfYear
ELSE
	IF IsNull(dNo) THEN dNo = dKfYear
END IF

dNo = dNo + 1

Return dNo
end function

event open;call super::open;
Long    iRowCount,iCurRow

f_window_center_Response(this)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

dw_baeg.SetTransObject(Sqlca)
dw_baeg.Reset()
	
iRowCount = dw_1.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno,'1')
IF iRowCount <=0 THEN
	iCurRow = dw_1.InsertRow(0)

   dw_1.SetItem(iCurRow,"saupj",    lstr_jpra.saupjang)
   dw_1.SetItem(iCurRow,"bal_date", lstr_jpra.baldate)
   dw_1.SetItem(iCurRow,"upmu_gu",  lstr_jpra.upmugu)
   dw_1.SetItem(iCurRow,"bjun_no",  lstr_jpra.bjunno)
   dw_1.SetItem(iCurRow,"lin_no",   lstr_jpra.sortno)
	
   dw_1.SetItem(iCurRow,"kfsacod",  lstr_jpra.saupjang)
   dw_1.SetItem(iCurRow,"kfaqdt",   lstr_jpra.baldate)	
	dw_1.setItem(iCurRow,"kfamt",    lstr_jpra.money)
	dw_1.setItem(iCurRow,"kfframt",  lstr_jpra.money)
	
	ib_changed = True
	
	dw_1.Modify("kfcod1.protect = 0")
	
	dw_1.SetColumn("kfcod1")
	
	Wf_Setting_Detail('1')
ELSE
	dw_1.setItem(iRowCount,"kfamt",    lstr_jpra.money)
	dw_1.setItem(iRowCount,"kfframt",  lstr_jpra.money)
	dw_1.Modify("kfcod1.protect = 1")
	
	dw_1.SetColumn("kfname")
	
	dw_baeg.Retrieve(dw_1.GetItemString(1,"kfcod1"),dw_1.GetItemNumber(1,"kfcod2"))
	Wf_Setting_Detail(dw_1.GetItemString(1,"kfjog"))
	
	ib_changed = False	
END IF

//dw_1.SetItem(1,"kfhalf",F_Check_Half('A',dw_1.GetItemString(1,"kfaqdt")))

dw_1.SetFocus()	




end event

on w_kglb01i.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.gb_1=create gb_1
this.dw_baeg=create dw_baeg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_baeg
end on

on w_kglb01i.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.dw_baeg)
end on

type dw_insert from w_inherite`dw_insert within w_kglb01i
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglb01i
boolean visible = false
integer x = 3845
integer y = 1080
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglb01i
boolean visible = false
integer x = 4379
integer y = 1236
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglb01i
boolean visible = false
integer x = 3685
integer y = 1236
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kglb01i
boolean visible = false
integer x = 4206
integer y = 1236
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglb01i
boolean visible = false
integer x = 4334
integer y = 1080
integer taborder = 0
end type

type p_can from w_inherite`p_can within w_kglb01i
integer x = 3163
integer y = 12
integer taborder = 40
end type

event p_can::clicked;call super::clicked;String sRtnValue

sRtnValue = '0'
CloseWithReturn(parent,sRtnValue)




end event

type p_print from w_inherite`p_print within w_kglb01i
boolean visible = false
integer x = 3858
integer y = 1236
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglb01i
boolean visible = false
integer x = 4032
integer y = 1236
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kglb01i
boolean visible = false
integer x = 4078
integer y = 1080
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglb01i
integer x = 3337
integer y = 12
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;String  sRtnValue,sKfcod1,sKfJog
Integer iDbCount
Double  dKfCod2

dw_1.AcceptText()
IF ib_changed = True THEN
	IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return
	
	IF F_DbConFirm('저장') = 2  then return

	sKfcod1 = dw_1.GetItemString(dw_1.GetRow(),"kfcod1")
	dKfCod2 = dw_1.GetItemNumber(dw_1.GetRow(),"kfcod2")
	sKfjog  = dw_1.GetItemString(dw_1.GetRow(),"kfjog")
	IF IsNull(dKfCod2) OR dKfCod2 = 0 THEN
		dKfCod2 = Wf_No(dw_1.GetItemString(dw_1.GetRow(),"kfcod1"))
		IF dKfCod2 <= 0 THEN
			MessageBox("확 인","일련번호 채번을 실패하였습니다.!!")
			dw_1.SetColumn("kfcod2")
			dw_1.setfocus()	 
			Return
		ELSE
			dw_1.SetItem(dw_1.GetRow(),"kfcod2",dkfcod2)
			MessageBox('확 인','채번된 고정자산 일련번호는 '+String(dKfCod2)+'번 입니다')
		END IF
	END IF
	
	IF dw_1.Update() <> 1 THEN
		Rollback;
		F_messageChk(13,'')
		Return
	ELSE
		if sKfjog ='9' then
			/*공통일 경우 배부기준상세 저장*/
			Integer i,iRow
			Double  dKfBaeg
			
			iRow = dw_baeg.RowCount()
			if iRow > 0 then
				dw_baeg.SetRedraw(False)
				for i = iRow to 1 step -1
					dKfBaeg = dw_baeg.GetItemNumber(i, "kfbaeg")
					if dKfBaeg = 0 or IsNull(dKfBaeg) then
						dw_baeg.DeleteRow(i)
					else
						dw_baeg.SetItem(i,"kfcod1", sKfcod1)
						dw_baeg.SetItem(i,"kfcod2", dkfcod2)
					end if
				next
				dw_baeg.SetRedraw(True)
				if dw_baeg.Update() <> 1 then
					F_MessageChk(13,'[배부율 상세]')
					Rollback;
					Return
				end if
			end if
		else
			delete from kfa02ot0 where kfcod1 = :sKfcod1 and kfcod2 = :dKfcod2;
		end if
	
	END IF
	sRtnValue = '1'
ELSE
	SELECT Count("KFZ12OTH"."KFCOD1")	   INTO :iDbCount  				/*기존자료 유무*/
	   FROM "KFZ12OTH"  
   	WHERE ( "KFZ12OTH"."SAUPJ" = :lstr_jpra.saupjang ) AND  
      	   ( "KFZ12OTH"."BAL_DATE" = :lstr_jpra.baldate ) AND  
         	( "KFZ12OTH"."UPMU_GU" = :lstr_jpra.upmugu ) AND  
	         ( "KFZ12OTH"."BJUN_NO" = :lstr_jpra.bjunno ) AND  
   	      ( "KFZ12OTH"."LIN_NO" = :lstr_jpra.sortno ) AND
				( "KFZ12OTH"."PROCGBN" = '1') ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		sRtnValue = '1'
		dw_1.Update()
	ELSE
		sRtnValue = '0'
	END IF
END IF
CloseWithReturn(parent,sRtnValue)

end event

type cb_exit from w_inherite`cb_exit within w_kglb01i
integer x = 1943
integer y = 2440
integer width = 343
string text = "취소(&C)"
end type

type cb_mod from w_inherite`cb_mod within w_kglb01i
integer x = 2313
integer y = 2440
string text = "완료(&F)"
end type

type cb_ins from w_inherite`cb_ins within w_kglb01i
integer x = 997
integer y = 2440
end type

type cb_del from w_inherite`cb_del within w_kglb01i
integer x = 1381
integer y = 2444
end type

type cb_inq from w_inherite`cb_inq within w_kglb01i
integer x = 649
integer y = 2440
end type

type cb_print from w_inherite`cb_print within w_kglb01i
integer x = 1934
integer y = 2216
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kglb01i
integer y = 2300
end type

type cb_can from w_inherite`cb_can within w_kglb01i
integer x = 1728
integer y = 2444
boolean cancel = true
end type

type cb_search from w_inherite`cb_search within w_kglb01i
integer x = 151
integer y = 2440
end type

type dw_datetime from w_inherite`dw_datetime within w_kglb01i
integer y = 2296
end type

type sle_msg from w_inherite`sle_msg within w_kglb01i
integer y = 2300
end type

type gb_10 from w_inherite`gb_10 within w_kglb01i
integer y = 2248
end type

type gb_button1 from w_inherite`gb_button1 within w_kglb01i
integer x = 123
integer y = 2384
integer width = 1243
end type

type gb_button2 from w_inherite`gb_button2 within w_kglb01i
integer x = 1906
integer y = 2384
integer width = 773
end type

type dw_1 from datawindow within w_kglb01i
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 60
integer width = 3534
integer height = 1512
integer taborder = 10
string dataobject = "dw_kglb01i1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String  sKfCod1,sKfGubun,sKfSaCod,sKfmDpt,sManDept,sGubun1,sGubun1_nm,sGubun2,sGubun2_nm,sNull,sKfjog,sDecp
Integer iCurRow,iKfNyr
Double   dRate
		
this.AcceptText()

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
	ELSE
		
		Integer  iNyr
		
		select substr(rfna5,1,1),to_number(nvl(substr(rfna5,2,2),'0')) 			/*상각방법/내용년수*/
			into :sDecp, :iNyr 
			from reffpf 
			where rfcod = 'F1' and rfgub = :sKfCod1;
		
		select nvl(decode(:sDecp,'1',kfsrrat,kfsarat),0)											/*상각율*/
			into :dRate
			from kfa01om0
			where kfnyr = :iNyr ;
			
		this.SetItem(iCurRow,"kfnyr",  iNyr)
		this.Setitem(iCurRow,"kfdecp", sDecp)
		this.SetItem(iCurRow,"rat",    dRate)	
	END IF
END IF

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
	dw_baeg.SetRedraw(False)
	dw_baeg.Retrieve(this.GetItemString(1,"kfcod1"),this.GetItemNumber(1,"kfcod2"))
	Wf_Setting_Detail(sKfjog)	
end if

If this.GetColumnName() = 'gubun1' then
	sgubun1 = this.GetItemString(iCurRow, 'gubun1')
	
	If sgubun1 = "" or Isnull(sgubun1) then
		this.SetItem(iCurRow, 'gubun1_nm', snull)
		Return
	End If

	SELECT "MCHMST"."MCHNAM"  		INTO :sgubun1_nm  
		FROM "MCHMST"  
	 	WHERE "MCHMST"."MCHNO" = :sgubun1;

	IF SQLCA.SQLCODE = 100 THEN
		f_messagechk(20,"설비번호")
		this.SetItem(iCurRow, 'gubun1', sNull)
		this.SetItem(iCurRow, 'gubun1_nm', sNull)
		this.SetColumn('gubun1')
		this.SetFocus()
		Return 1
	END IF
	this.SetItem(iCurRow, 'gubun1_nm', sgubun1_nm)
END IF

If this.GetColumnName() = 'gubun2' then
	sgubun2 = this.GetItemString(iCurRow, 'gubun2')
	
	If sgubun2 = "" or Isnull(sgubun2) then
		this.SetItem(iCurRow, 'gubun2_nm', snull)
		Return
	End If
		
	SELECT "KUMMST"."KUMNAME"	INTO :sgubun2_nm
		FROM "KUMMST"
		WHERE "KUMMST"."KUMNO" = :sgubun2 ;
	
	If sqlca.sqlcode = 100 then
		f_messagechk(20, "금형번호")
		this.SetItem(iCurRow, 'gubun2', snull)
		this.SetItem(iCurRow, 'gubun2_nm', snull)
		this.SetColumn('gubun2')
		this.SetFocus()
		Return 1
	End If
	this.SetItem(iCurRow, 'gubun2_nm', sgubun2_nm)
End If

this.SetItem(iCurRow,"kfhalf",F_Check_Half('A',this.GetItemString(iCurRow,"kfaqdt")))

end event

event editchanged;ib_changed = True
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

event itemfocuschanged;
Long wnd

wnd =Handle(this)

IF dwo.name ="kfname" OR dwo.name ="kfsize" OR dwo.name = 'kfmekr' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event rbuttondown;Integer  row_num
String   sGubun1,sGubun2

If dw_1.GetColumnName() = 'gubun1' then
	row_num = dw_1.GetRow()
	
	SetNull(gs_code)
	SetNull(gs_codename)
		
	sgubun1 = dw_1.GetItemString(row_num, 'gubun1')
		
	If isnull(sgubun1) then 
		sgubun1 = "" 
	End If
		
	gs_code = sgubun1
	
	Open(w_mchmst_popup)
	
	If gs_code = "" or isnull(gs_code) then Return
	
	dw_1.SetItem(row_num, 'gubun1', gs_code)
	dw_1.SetItem(row_num, 'gubun1_nm', gs_codename)
	
	Return
END IF

end event

type gb_1 from groupbox within w_kglb01i
integer x = 27
integer y = 1580
integer width = 3465
integer height = 232
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "배부기준율 상세"
end type

type dw_baeg from u_key_enter within w_kglb01i
integer x = 50
integer y = 1632
integer width = 3419
integer height = 156
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kglb01i2"
boolean border = false
end type

