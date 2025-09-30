$PBExportHeader$w_kfaa02.srw
$PBExportComments$고정자산마스타등록
forward
global type w_kfaa02 from w_inherite
end type
type dw_1 from datawindow within w_kfaa02
end type
type dw_baeg from u_key_enter within w_kfaa02
end type
type st_2 from statictext within w_kfaa02
end type
type rr_1 from roundrectangle within w_kfaa02
end type
end forward

global type w_kfaa02 from w_inherite
string title = "고정자산마스타  등록"
dw_1 dw_1
dw_baeg dw_baeg
st_2 st_2
rr_1 rr_1
end type
global w_kfaa02 w_kfaa02

forward prototypes
public subroutine wf_retrievemode (string mode)
public function integer wf_update_new (string sym, string syear, string skfcod1, double lkfcod2, double damt, string sgbn)
public function double wf_no (string sjasan, long lno)
public subroutine wf_setting_detail (string sref_kfjog)
end prototypes

public subroutine wf_retrievemode (string mode);dw_1.SetRedraw(False)
IF mode ="M" THEN
	dw_1.SetTabOrder("kfcod1",0)
	dw_1.SetTabOrder("kfcod2",0)
	dw_1.SetColumn("kfname")
ELSE
	dw_1.SetTabOrder("kfcod1",10)
	dw_1.SetTabOrder("kfcod2",20)
	dw_1.SetColumn("kfcod1")
END IF
dw_1.SetRedraw(True)
dw_1.SetFocus()
end subroutine

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
	rr_1.Visible = True
	st_2.Visible = True
	dw_baeg.visible = True
else
	rr_1.Visible = False
	st_2.Visible = False
	dw_baeg.visible = False
end if

dw_baeg.SetRedraw(True)


end subroutine

event open;call super::open;dw_1.settransobject(sqlca)
dw_1.reset()
dw_1.Insertrow(0)

dw_1.setitem(dw_1.Getrow(),"KFSACOD",gs_saupj)
dw_1.Setitem(dw_1.Getrow(),"KFMDPT",gs_dept)

dw_baeg.SetTransObject(Sqlca)
dw_baeg.Reset()
Wf_Setting_Detail('9')

ib_any_typing =False
sModStatus ="I"
wf_retrievemode(sModStatus)


end event

on w_kfaa02.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_baeg=create dw_baeg
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_baeg
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_kfaa02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_baeg)
destroy(this.st_2)
destroy(this.rr_1)
end on

type dw_insert from w_inherite`dw_insert within w_kfaa02
boolean visible = false
integer x = 46
integer y = 2476
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfaa02
boolean visible = false
integer x = 3333
integer y = 2760
integer taborder = 70
end type

type p_addrow from w_inherite`p_addrow within w_kfaa02
boolean visible = false
integer x = 3054
integer y = 2760
integer taborder = 50
end type

type p_search from w_inherite`p_search within w_kfaa02
boolean visible = false
integer x = 2231
integer y = 36
integer taborder = 0
string picturename = "C:\erpman\image\검색_up.gif"
end type

type p_ins from w_inherite`p_ins within w_kfaa02
integer x = 3749
integer taborder = 30
string pointer = "C:\erpman\cur\new.cur"
end type

event p_ins::clicked;call super::clicked;dw_1.reset()
dw_1.Insertrow(0)

dw_1.setitem(dw_1.Getrow(),"KFSACOD",gs_saupj)
dw_1.Setitem(dw_1.Getrow(),"KFMDPT",gs_dept)

ib_any_typing = False

sModStatus ="I"
wf_retrievemode(sModStatus)

w_mdi_frame.sle_msg.text = ""


end event

type p_exit from w_inherite`p_exit within w_kfaa02
integer taborder = 150
end type

type p_can from w_inherite`p_can within w_kfaa02
integer taborder = 130
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.reset()
dw_1.Insertrow(0)

dw_1.setitem(dw_1.Getrow(),"KFSACOD",Gs_Saupj)
dw_1.Setitem(dw_1.Getrow(),"KFMDPT",gs_dept)
dw_1.SetRedraw(True)

ib_any_typing = False

dw_baeg.SetRedraw(False)
dw_baeg.Reset()
Wf_Setting_Detail('9')

sModStatus ="I"
wf_retrievemode(sModStatus)

w_mdi_frame.sle_msg.text = ""


end event

type p_print from w_inherite`p_print within w_kfaa02
boolean visible = false
integer x = 2866
integer y = 2768
integer taborder = 180
end type

type p_inq from w_inherite`p_inq within w_kfaa02
integer x = 3575
end type

event p_inq::clicked;call super::clicked;CHAR DKFCOD1, intocod
Long row_num, retrieve_row
Double DKFCOD2

setpointer(hourglass!)

dw_1.AcceptText()
row_num  = dw_1.Getrow()

/* 계정약칭 */
DKFCOD1  = dw_1.Getitemstring(row_num,"KFCOD1")
if  DKFCOD1 = "" or Isnull(DKFCOD1) then
    w_mdi_frame.sle_msg.text   = "고정자산 계정약칭 필드를 클릭한 후 하나를 선택하시오."
    Messagebox("확 인","계정약칭을 입력하시오. !!!")
    DW_1.setfocus()
    DW_1.SetColumn(1)
    Return
end if
  SELECT "REFFPF"."RFGUB"  
    INTO :INTOCOD  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU" = '1' ) AND  
         ( "REFFPF"."RFCOD" = 'F1' ) AND  
         ( "REFFPF"."RFGUB" = :DKFCOD1 )   ;
if SQLCA.SQLCODE <> 0 then
   w_mdi_frame.sle_msg.text   = "입력한 계정약칭은 참조코드에  존재하지 않습니다."
   Messagebox("확 인","계정약칭을 확인하시오. !!!")
   dw_1.setfocus()	 
   DW_1.SetColumn(1)
   Return
end if

/* SEQ 검사 */
DKFCOD2 = dw_1.GetitemNumber(row_num,"KFCOD2")
if  DKFCOD2 = 0 or Isnull(DKFCOD2) then
	w_mdi_frame.sle_msg.text   = "SEQ NO 를 입력한 후 조회버튼을 클릭하시오."
   Messagebox("확 인","SEQ NO를 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn(2)
   Return
end if

dw_1.SetRedraw(False)
retrieve_row = DW_1.Retrieve(dkfcod1,dkfcod2)
if  retrieve_row <= 0  then
	 p_ins.TriggerEvent(Clicked!)
	 
	 dw_1.SetRedraw(True)
    w_mdi_frame.sle_msg.text   = "해당 Key 에 해당하는 자료는 DB 상에 존재하지 않습니다."
    Messagebox("확 인","조회 할 자료가 없습니다. !!!")
    
    dw_1.setfocus()
    Return
end if
dw_1.SetRedraw(True)

ib_any_typing = False

w_mdi_frame.sle_msg.text = ""

sModStatus ="M"
wf_retrievemode(sModStatus)

dw_baeg.Retrieve(dkfcod1,dkfcod2)
	
Wf_Setting_Detail(dw_1.GetItemString(1,"kfjog"))

end event

type p_del from w_inherite`p_del within w_kfaa02
integer taborder = 110
end type

event p_del::clicked;call super::clicked;CHAR   DKFCOD1, RET_COD
long   row_num 
int    button_num
Double DKFCOD2

dw_1.AcceptText()
row_num  = dw_1.Getrow()
DKFCOD1   = dw_1.GetitemString(row_num,"KFCOD1")
DKFCOD2   = dw_1.GetitemNumber(row_num,"KFCOD2")

IF sModStatus ="M" THEN	
   IF Messagebox("확 인","자료를 삭제하시겠습니까 ?",Question!,YesNo!,2) = 2 THEN RETURN
	
	dw_1.SetRedraw(False)
   dw_1.DeleteRow(0)
   IF dw_1.update() = 1 THEN
		
		delete from kfa02ot0 where kfcod1 = :dKfcod1 and kfcod2 = :dKfcod2;
		
      p_ins.TriggerEvent(Clicked!)
   	dw_1.SetRedraw(True)
		COMMIT;
		w_mdi_frame.sle_msg.text   = "자료가 삭제되었습니다"
   ELSE
       w_mdi_frame.sle_msg.text   = "자료 삭제를 실패하였습니다.!!"
       ROLLBACK;
       return
   END IF
ELSE
   Messagebox("확 인","삭제할 자료가 없습니다. !!!")
   return
END IF

ib_any_typing = False

sModStatus ="I"
wf_retrievemode(sModStatus)

dw_baeg.SetRedraw(False)
dw_baeg.Reset()
Wf_Setting_Detail('9')


end event

type p_mod from w_inherite`p_mod within w_kfaa02
integer taborder = 90
end type

event p_mod::clicked;call super::clicked;String  DKFCOD1, DKFSACOD, DKFJOG,     DKFDECP, DKFDEGB, DKFCHGB, INTOCOD
STRING  DKFNAME, DKFMDPT,  INTOSTRING, DKFAQDT, DKFDODT, DKFYEAR, DKFAQDTYMD,SQL_YEAR,dkfgubun
integer DKFNYR,  DKFJYR
long    DKFQNTY,  row_num
decimal DKFAMT,  DKFDEAMT,   DKFCOD2, CHKCOD2, dKfBaegSum

setpointer(hourglass!)

SELECT "KFA07OM0"."KFYEAR"    INTO :DKFYEAR    FROM "KFA07OM0"  ;						/*회기*/

dw_1.AcceptText()
row_num  = dw_1.Getrow()

DKFCOD1  = dw_1.Getitemstring(row_num,"KFCOD1")							/* 계정약칭 */
if  DKFCOD1 = "" OR Isnull(DKFCOD1) then
	w_mdi_frame.sle_msg.text   = "고정자산 계정약칭 필드를 클릭한 후 하나를 선택하시오."
   Messagebox("확 인","계정약칭을 입력하시오. !!!")
   DW_1.setfocus()
   DW_1.SetColumn("KFCOD1")
   Return
else
	SELECT "REFFPF"."RFGUB"  	INTO :INTOCOD  
		FROM "REFFPF"  
		WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'F1' ) AND  
				( "REFFPF"."RFGUB" = :DKFCOD1 )   ;
	if SQLCA.SQLCODE <> 0 then
		w_mdi_frame.sle_msg.text   = "입력한 계정약칭은 참조코드에  존재하지 않습니다."
		Messagebox("확 인","계정약칭을 확인하시오. !!!")
		dw_1.setfocus()	 
		DW_1.SetColumn("KFCOD1")
		Return
	end if
end if

DKFCOD2 = dw_1.GetitemNumber(row_num,"KFCOD2")							/* SEQ 검사 */
IF sModStatus ="I" THEN
	dkfcod2 =wf_no(dkfcod1,dkfcod2)
	IF dkfcod2 = -1 THEN
		MessageBox("확 인","일련번호 채번을 실패하였습니다.!!")
		DW_1.SetColumn("KFCOD2")
		dw_1.setfocus()	 
		Return
	ELSE
		DW_1.SetItem(dw_1.GetRow(),"KFCOD2",dkfcod2)
	END IF
ELSE
	SELECT "KFA02OM0"."KFCOD2"  	INTO   :CHKCOD2  
		FROM   "KFA02OM0"  
		WHERE  ( "KFA02OM0"."KFCOD1" = :DKFCOD1 ) AND ( "KFA02OM0"."KFCOD2" = :DKFCOD2 )   ;
	If SQLCA.SQLCODE = 0  then
		IF sModStatus ="I" THEN
			f_messagechk(10,'')
			Return
		END IF
	END IF
END IF

DKFNAME  = dw_1.GetitemString(row_num,"kfname")								/* 자산명칭 */
if  DKFNAME = "" OR Isnull(DKFNAME) then
	w_mdi_frame.sle_msg.text   = "자산명칭은 자산코드를 구별할 수 있는 유일한 방법입니다."
   Messagebox("확 인","자산명칭을 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("kfname")
   Return
end if

IF dw_1.GetitemString(row_num,"mandept")='' OR IsNull(dw_1.GetitemString(row_num,"mandept")) THEN			/*원가부문*/
   F_MessageChk(1,'[원가부문]')
   dw_1.setfocus()
   DW_1.SetColumn("mandept")
   Return
END IF

dkfgubun = dw_1.GetItemString(row_num,"kfgubun")
if  dkfgubun = "" OR Isnull(dkfgubun) then
   w_mdi_frame.sle_msg.text   = "고정자산분류 필드를 클릭한 후 하나를 선택하시오."
   Messagebox("확 인","고정자산분류 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("kfgubun")
   Return
ELSE
	SELECT "REFFPF"."RFGUB"     INTO :INTOCOD  
		FROM "REFFPF"     
		WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'F7' ) AND  
         ( "REFFPF"."RFGUB" = :dkfgubun )   ;
	if SQLCA.SQLCODE <> 0 then
		w_mdi_frame.sle_msg.text   = "입력한 고정자산분류는 참조코드에  존재하지 않습니다."
		Messagebox("확 인","고정자산분류를 확인하시오. !!!")
		dw_1.setfocus()	 
		DW_1.SetColumn("kfgubun")
		Return
	end if
end if

DKFSACOD = dw_1.Getitemstring(row_num,"kfsacod")								/* 사업장 */
if  DKFSACOD = "" OR Isnull(DKFSACOD) then
	w_mdi_frame.sle_msg.text   = "사업장 필드를 클릭한 후 하나를 선택하시오."
   Messagebox("확 인","사업장을 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("KFsacod")
   Return
else
	SELECT "REFFPF"."RFGUB"      INTO :INTOCOD  
	   FROM "REFFPF"  
   	WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'AD' ) AND  
         	( "REFFPF"."RFGUB" = :DKFSACOD )   ;
	if SQLCA.SQLCODE <> 0 then
   	w_mdi_frame.sle_msg.text   = "입력한 사업장은 참조코드에  존재하지 않습니다."
	   Messagebox("확 인","사업장을 확인하시오. !!!")
   	dw_1.setfocus()	 
	   DW_1.SetColumn("KFsacod")
   	Return
	end if
end if

DKFMDPT  = dw_1.Getitemstring(row_num,"KFmdpt")							/* 관리부서 */
if  DKFMDPT = "" OR Isnull(DKFMDPT) then
	w_mdi_frame.sle_msg.text   = "관리부서 필드를 클릭한 후 하나를 선택하시오."
   Messagebox("확 인","관리부서를 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("KFmdpt")
   Return
else
	select person_cd	into :INTOSTRING  
		from kfz04om0 where person_gu = '3' and person_cd = :DKFMDPT ;
	if SQLCA.SQLCODE <> 0 then
		w_mdi_frame.sle_msg.text   = "입력한 관리부서는 거래처마스타파일에 존재하지 않습니다."
		Messagebox("확 인","관리부서를 확인하시오. !!!")
		dw_1.setfocus()
		DW_1.SetColumn("KFmdpt")	 
		Return
	end if
end if

DKFAQDT = Trim(dw_1.Getitemstring(row_num,"kfaqdt"))							/* 취득일 */
DKFAQDTYMD = DKFAQDT
if  DKFAQDT = "" OR Isnull(DKFAQDT) then
	w_mdi_frame.sle_msg.text   = "취득일은 감가상각시 중요한 필드입니다."
   Messagebox("확 인","취득일을 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("kfaqdt")
   Return
end if

if  Left(DKFAQDT,4) > dkfYEAR then
	w_mdi_frame.sle_msg.text   = "고정자산 회기년도보다 취득년도가 클 수 없습니다."
   Messagebox("확 인","취득일을 확인하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("kfaqdt")
   Return
end if

DKFAQDT = left(DKFAQDT,4) + "/" + mid(DKFAQDT,5,2) + "/" + right(DKFAQDT,2)
if  NOT IsDATE(DKFAQDT) then
	w_mdi_frame.sle_msg.text   = "입력한 날짜는 유효하지 않습니다."
   Messagebox("확 인","취득일을 확인하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("kfaqdt")
   Return
end if

DKFCHGB = dw_1.Getitemstring(row_num,"KFchgb")									/* 변동구분 */
if  DKFCHGB = "" OR Isnull(DKFCHGB) then
	w_mdi_frame.sle_msg.text   = "변동구분 필드를 클릭한 후 하나를 선택하시오."
   Messagebox("확 인","변동구분을 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("KFchgb")
   Return
ELSE
	IF DKFCOD1 = "A" AND DKFCHGB = "K" THEN
		w_mdi_frame.sle_msg.text   = "토지는 변동구분을 상각완료로 입력할 수 없습니다."
		Messagebox("확 인","변동구분을 확인하시오. !!!")
		dw_1.setfocus()
		DW_1.SetColumn("KFchgb")
		Return
	END IF
	SELECT "REFFPF"."RFGUB"      INTO :INTOCOD  
	   FROM "REFFPF"  
   	WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'F5' ) AND  
         	( "REFFPF"."RFGUB" = :DKFCHGB )   ;
	if SQLCA.SQLCODE <> 0 then
   	w_mdi_frame.sle_msg.text   = "입력한 변동구분은 참조코드에  존재하지 않습니다."
	   Messagebox("확 인","변동구분을 확인하시오. !!!")
   	dw_1.setfocus()	 
	   DW_1.SetColumn("KFchgb")
   	Return
	end if
end if

IF DKFCOD1 <> "A" THEN																/* 내용년수 */
   DKFNYR = dw_1.GetitemNumber(row_num,"KFnyr")
   if  DKFNYR = 0 OR Isnull(DKFNYR) then
		w_mdi_frame.sle_msg.text   = "내용년수는 감가상각시 중요한 필드입니다."
      Messagebox("확 인","내용년수를 입력하시오. !!!")
      dw_1.setfocus()
      DW_1.SetColumn("KFnyr")
      Return
   end if
END IF
 
IF DKFCOD1 <> "A" THEN															/* 상각방법 */
   DKFDECP = dw_1.Getitemstring(row_num,"KFDEcp")

   if  DKFDECP = "" OR Isnull(DKFDECP) then
		w_mdi_frame.sle_msg.text   = "상각방법 필드를 클릭한 후 하나를 선택하시오."
      Messagebox("확 인","상각방법를 입력하시오. !!!")
      dw_1.setfocus()
      DW_1.SetColumn("KFDEcp")
      Return
	ELSE
		SELECT "REFFPF"."RFGUB"       INTO :INTOCOD  
			FROM "REFFPF"  
     		WHERE ( "REFFPF"."SABU" = '1' ) AND  ( "REFFPF"."RFCOD" = 'F3' ) AND  
           		( "REFFPF"."RFGUB" = :DKFDECP )   ;
		if SQLCA.SQLCODE <> 0 then
      	w_mdi_frame.sle_msg.text   = "입력한 상각방법은 참조코드에  존재하지 않습니다."
	      Messagebox("확 인","상각방법을 확인하시오. !!!")
   	   dw_1.setfocus()	 
      	DW_1.SetColumn("KFDEcp")
	      Return
   	end if
   end if
END IF

IF DKFCOD1 <> "A" THEN														/* 잔존년수 */
   DKFJYR = dw_1.GetitemNumber(row_num,"KFjyr")
END IF

/*상각구분*/
IF DKFCOD1 <> "A" THEN
   DKFDEGB = dw_1.Getitemstring(row_num,"kfdegb")
   if  DKFDEGB = "" OR Isnull(DKFDEGB) then
		w_mdi_frame.sle_msg.text   = "상각구분 필드를 클릭한 후 하나를 선택하시오."
      Messagebox("확 인","상각구분를 입력하시오. !!!")
      dw_1.setfocus()
      DW_1.SetColumn("KFDEgb")
      Return
	ELSE
		SELECT "REFFPF"."RFGUB"         INTO :INTOCOD  
	      FROM "REFFPF"  
   	   WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'F4' ) AND  
         	   ( "REFFPF"."RFGUB" = :DKFDEGB );
		if SQLCA.SQLCODE <> 0 then
      	w_mdi_frame.sle_msg.text   = "입력한 상각구분은 참조코드에  존재하지 않습니다."
	      Messagebox("확 인","상각구분을 확인하시오. !!!")
   	   dw_1.setfocus()	 
      	DW_1.SetColumn("KFDEgb")
	      Return
   	end if
   end if
END IF

DKFQNTY = dw_1.GetitemNumber(row_num,"KFqnty")									/* 수량 */
if  DKFQNTY = 0 OR Isnull(DKFQNTY) then
	w_mdi_frame.sle_msg.text   = "수량은 안분 감가상각시 중요한 필드입니다."
   Messagebox("확 인","수량을 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("KFqnty")
   Return
end if
 
/* 제조일반구분 */
IF DKFCOD1 <> "A" THEN
   DKFJOG = dw_1.Getitemstring(row_num,"KFjog")
   if  DKFJOG = "" OR Isnull(DKFJOG) then
		w_mdi_frame.sle_msg.text   = "자료를 선택하십시오"
      Messagebox("확 인","제조일반등 구분코드를 입력하시오. !!!")
      dw_1.setfocus()
      DW_1.SetColumn("KFjog")
      Return
	else
		SELECT "REFFPF"."RFGUB"         INTO :INTOCOD  
	      FROM "REFFPF"  
   	   WHERE ( "REFFPF"."SABU" = '1' ) AND  ( "REFFPF"."RFCOD" = 'F2' ) AND  
         	   ( "REFFPF"."RFGUB" = :DKFJOG )   ;
		if SQLCA.SQLCODE <> 0 then
      	w_mdi_frame.sle_msg.text   = "입력한 구분코드가 참조코드에  존재하지 않습니다."
	      Messagebox("확 인","제조일반등 구분을 확인하시오. !!!")
   	   dw_1.setfocus()	 
      	DW_1.SetColumn("KFjog")
	      Return
   	end if
   end if
END IF

if DKFJOG = "9" and dw_baeg.RowCount() > 0 then													/*공통이면*/
	dw_baeg.AcceptText()
	
	dKfBaegSum = dw_baeg.GetItemNumber(1,"sum_baeg")
	
	if dKfBaegSum = 0  or IsNull(dKfBaegSum) then
   	w_mdi_frame.sle_msg.text   = "공통일때는 배부기준상세를 입력하시오."
    	Messagebox("확 인","배부기준상세를 입력하시오. !!!")
    	dw_baeg.setfocus()
    	DW_baeg.SetColumn("KFjog")
    	Return
	elseif dKfBaegSum <> 100 then
		w_mdi_frame.sle_msg.text   = "배부기준상세의 합은 100이어야 합니다."
    	Messagebox("확 인","배부기준상세를 확인하시오. !!!")
    	dw_baeg.setfocus()
    	DW_baeg.SetColumn("KFjog")
    	Return
   end if	
end if

IF dw_1.GetItemNumber(row_num,"kfframt") = 0 OR IsNull(dw_1.GetItemNumber(row_num,"kfframt")) THEN
	w_mdi_frame.sle_msg.text   = ""
   Messagebox("확 인","기초 취득가액을 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("kfframt")
   Return
END IF

DKFAMT = dw_1.Getitemdecimal(row_num,"kfamt")						/* 취득원가 */
if  DKFAMT = 0 OR Isnull(DKFAMT) then
	w_mdi_frame.sle_msg.text   = ""
   Messagebox("확 인","취득원가를 입력하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("kfamt")
   Return
end if

/* 상각누계액 */
IF DKFCOD1 <> "A" THEN
	DKFDEAMT = dw_1.Getitemdecimal(row_num,"KFDEamt")

  	if  Left(DKFAQDT,4) > dkfYEAR then
		if  DKFDEAMT = 0 OR Isnull(DKFDEAMT) then
      	w_mdi_frame.sle_msg.text   = "신규취득이 아닌 경우는 기초상각누계액을 입력하시오."
         Messagebox("확 인","감가상각누계액을 입력하시오. !!!")
         dw_1.setfocus()
         DW_1.SetColumn("KFDEamt") 
         Return
		end if
   end if
end if 

IF DKFAMT < DKFDEAMT THEN
	w_mdi_frame.sle_msg.text   = "상각누계액이 취득가액보다 클 수 없습니다."
   Messagebox("확 인","감가상각누계액을 확인하시오. !!!")
   dw_1.setfocus()
   DW_1.SetColumn("KFDEamt") 
   Return
end if

/* 전체매각 폐기일 */
DKFDODT = Trim(dw_1.Getitemstring(row_num,"KFDODT"))
if Isnull(DKFDODT) then DKFDODT = "" 

IF DKFCHGB = "H" OR DKFCHGB = "I" OR DKFCHGB = "J" THEN
	if  DKFDODT = "" then
   	w_mdi_frame.sle_msg.text   = "전체매각 / 폐기일은 변동구분이 H,I,J 일때만 입력합니다."
      Messagebox("확 인","전체매각 / 폐기일을 입력하시오. !!!")
      dw_1.setfocus()
      DW_1.SetColumn("KFDODT")
      Return
   end if

   if  Left(DKFDODT,4) > DKFYEAR then
      w_mdi_frame.sle_msg.text   = "고정자산 회기년도보다 전체매각 / 폐기년도가 클 수 없습니다."
      Messagebox("확 인","전체매각 / 폐기일을 확인하시오. !!!")
      dw_1.setfocus()
      DW_1.SetColumn("KFDODT")
      Return
   end if

   DKFDODT = left(DKFDODT,4) + "/" + mid(DKFDODT,5,2) + "/" + right(DKFDODT,2)

   if  NOT IsDATE(DKFDODT) then
      w_mdi_frame.sle_msg.text   = "입력한 날짜는 유효하지 않습니다."
      Messagebox("확 인","전체매각 / 폐기일을 확인하시오. !!!")
      dw_1.setfocus()
      DW_1.SetColumn("KFDODT")
      Return
   end if
ELSE
   if  DKFDODT <> ""  then
   	w_mdi_frame.sle_msg.text   = "전체매각 / 폐기일은 변동구분이 H,I,J 일때만 입력합니다."
      Messagebox("확 인","전체매각 / 폐기일을 확인하시오. !!!")
      dw_1.setfocus()
      DW_1.SetColumn("KFDODT")
      Return
   end if
END IF

if IsNull(DKFDEAMT) then
   DKFDEAMT = 0
   DW_1.Setitem(row_num,"KFDEAMT",DKFDEAMT)
END IF

IF f_dbconfirm("저장") = 2 THEN RETURN

/* 무형자산시 과년도취득시 장부가액을 기초취득가액으로 넘긴다*/
dkfgubun = dw_1.GetItemString(row_num,"kfgubun")
if  dkfgubun = '4' and dkfdeamt <> 0 then
	dkfamt = dkfamt - dkfdeamt
	dkfdeamt =0
end if


IF dw_1.Update() = 1 THEN
	DELETE FROM "KFA06OT0"  
	   WHERE ( "KFA06OT0"."KFCOD1" = :DKFCOD1 ) AND ( "KFA06OT0"."KFCOD2" = :DKFCOD2 )   ;

	if dKfJog ='9' then
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
					dw_baeg.SetItem(i,"kfcod1", dkfcod1)
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
		delete from kfa02ot0 where kfcod1 = :dKfcod1 and kfcod2 = :dKfcod2;
	end if
	
	COMMIT;
	w_mdi_frame.sle_msg.text   = "자료가 저장되었습니다."
ELSE
   Messagebox("확 인","자료 저장을 실패했습니다. !!!")
   ROLLBACK;
	Return
END IF

ib_any_typing = False

dw_1.SetRedraw(False)
dw_1.reset()
dw_1.Insertrow(0)
dw_1.setitem(dw_1.Getrow(),"KFSACOD",gs_saupj)
dw_1.Setitem(dw_1.Getrow(),"KFMDPT",DKFMDPT)
dw_1.SetRedraw(True)

sModStatus ="I"
wf_retrievemode(sModStatus)

dw_baeg.SetRedraw(False)
dw_baeg.Reset()
Wf_Setting_Detail('9')
end event

type cb_exit from w_inherite`cb_exit within w_kfaa02
boolean visible = false
integer x = 3218
integer y = 2612
integer taborder = 140
end type

type cb_mod from w_inherite`cb_mod within w_kfaa02
boolean visible = false
integer x = 2176
integer y = 2612
integer taborder = 80
end type

event cb_mod::clicked;call super::clicked;//String  DKFCOD1, DKFSACOD, DKFJOG,     DKFDECP, DKFDEGB, DKFCHGB, INTOCOD
//STRING  DKFNAME, DKFMDPT,  INTOSTRING, DKFAQDT, DKFDODT, DKFYEAR, DKFAQDTYMD,SQL_YEAR,dkfgubun
//integer DKFNYR,  DKFJYR
//long    DKFQNTY,  row_num
//decimal DKFAMT,  DKFDEAMT,   DKFCOD2, CHKCOD2, dKfBaegSum
//
//setpointer(hourglass!)
//
//SELECT "KFA07OM0"."KFYEAR"    INTO :DKFYEAR    FROM "KFA07OM0"  ;						/*회기*/
//
//dw_1.AcceptText()
//row_num  = dw_1.Getrow()
//
//DKFCOD1  = dw_1.Getitemstring(row_num,"KFCOD1")							/* 계정약칭 */
//if  DKFCOD1 = "" OR Isnull(DKFCOD1) then
//	sle_msg.text   = "고정자산 계정약칭 필드를 클릭한 후 하나를 선택하시오."
//   Messagebox("확 인","계정약칭을 입력하시오. !!!")
//   DW_1.setfocus()
//   DW_1.SetColumn("KFCOD1")
//   Return
//else
//	SELECT "REFFPF"."RFGUB"  	INTO :INTOCOD  
//		FROM "REFFPF"  
//		WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'F1' ) AND  
//				( "REFFPF"."RFGUB" = :DKFCOD1 )   ;
//	if SQLCA.SQLCODE <> 0 then
//		sle_msg.text   = "입력한 계정약칭은 참조코드에  존재하지 않습니다."
//		Messagebox("확 인","계정약칭을 확인하시오. !!!")
//		dw_1.setfocus()	 
//		DW_1.SetColumn("KFCOD1")
//		Return
//	end if
//end if
//
//DKFCOD2 = dw_1.GetitemNumber(row_num,"KFCOD2")							/* SEQ 검사 */
//IF sModStatus ="I" THEN
//	dkfcod2 =wf_no(dkfcod1,dkfcod2)
//	IF dkfcod2 = -1 THEN
//		MessageBox("확 인","일련번호 채번을 실패하였습니다.!!")
//		DW_1.SetColumn("KFCOD2")
//		dw_1.setfocus()	 
//		Return
//	ELSE
//		DW_1.SetItem(dw_1.GetRow(),"KFCOD2",dkfcod2)
//	END IF
//ELSE
//	SELECT "KFA02OM0"."KFCOD2"  	INTO   :CHKCOD2  
//		FROM   "KFA02OM0"  
//		WHERE  ( "KFA02OM0"."KFCOD1" = :DKFCOD1 ) AND ( "KFA02OM0"."KFCOD2" = :DKFCOD2 )   ;
//	If SQLCA.SQLCODE = 0  then
//		IF sModStatus ="I" THEN
//			f_messagechk(10,'')
//			Return
//		END IF
//	END IF
//END IF
//
//DKFNAME  = dw_1.GetitemString(row_num,"kfname")								/* 자산명칭 */
//if  DKFNAME = "" OR Isnull(DKFNAME) then
//	sle_msg.text   = "자산명칭은 자산코드를 구별할 수 있는 유일한 방법입니다."
//   Messagebox("확 인","자산명칭을 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("kfname")
//   Return
//end if
//
//IF dw_1.GetitemString(row_num,"mandept")='' OR IsNull(dw_1.GetitemString(row_num,"mandept")) THEN			/*원가부문*/
//   F_MessageChk(1,'[원가부문]')
//   dw_1.setfocus()
//   DW_1.SetColumn("mandept")
//   Return
//END IF
//
//dkfgubun = dw_1.GetItemString(row_num,"kfgubun")
//if  dkfgubun = "" OR Isnull(dkfgubun) then
//   sle_msg.text   = "고정자산분류 필드를 클릭한 후 하나를 선택하시오."
//   Messagebox("확 인","고정자산분류 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("kfgubun")
//   Return
//ELSE
//	SELECT "REFFPF"."RFGUB"     INTO :INTOCOD  
//		FROM "REFFPF"     
//		WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'F7' ) AND  
//         ( "REFFPF"."RFGUB" = :dkfgubun )   ;
//	if SQLCA.SQLCODE <> 0 then
//		sle_msg.text   = "입력한 고정자산분류는 참조코드에  존재하지 않습니다."
//		Messagebox("확 인","고정자산분류를 확인하시오. !!!")
//		dw_1.setfocus()	 
//		DW_1.SetColumn("kfgubun")
//		Return
//	end if
//end if
//
//DKFSACOD = dw_1.Getitemstring(row_num,"kfsacod")								/* 사업장 */
//if  DKFSACOD = "" OR Isnull(DKFSACOD) then
//	sle_msg.text   = "사업장 필드를 클릭한 후 하나를 선택하시오."
//   Messagebox("확 인","사업장을 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("KFsacod")
//   Return
//else
//	SELECT "REFFPF"."RFGUB"      INTO :INTOCOD  
//	   FROM "REFFPF"  
//   	WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'AD' ) AND  
//         	( "REFFPF"."RFGUB" = :DKFSACOD )   ;
//	if SQLCA.SQLCODE <> 0 then
//   	sle_msg.text   = "입력한 사업장은 참조코드에  존재하지 않습니다."
//	   Messagebox("확 인","사업장을 확인하시오. !!!")
//   	dw_1.setfocus()	 
//	   DW_1.SetColumn("KFsacod")
//   	Return
//	end if
//end if
//
//DKFMDPT  = dw_1.Getitemstring(row_num,"KFmdpt")							/* 관리부서 */
//if  DKFMDPT = "" OR Isnull(DKFMDPT) then
//	sle_msg.text   = "관리부서 필드를 클릭한 후 하나를 선택하시오."
//   Messagebox("확 인","관리부서를 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("KFmdpt")
//   Return
//else
//	select person_cd	into :INTOSTRING  
//		from kfz04om0 where person_gu = '3' and person_cd = :DKFMDPT ;
//	if SQLCA.SQLCODE <> 0 then
//		sle_msg.text   = "입력한 관리부서는 거래처마스타파일에 존재하지 않습니다."
//		Messagebox("확 인","관리부서를 확인하시오. !!!")
//		dw_1.setfocus()
//		DW_1.SetColumn("KFmdpt")	 
//		Return
//	end if
//end if
//
//DKFAQDT = Trim(dw_1.Getitemstring(row_num,"kfaqdt"))							/* 취득일 */
//DKFAQDTYMD = DKFAQDT
//if  DKFAQDT = "" OR Isnull(DKFAQDT) then
//	sle_msg.text   = "취득일은 감가상각시 중요한 필드입니다."
//   Messagebox("확 인","취득일을 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("kfaqdt")
//   Return
//end if
//
//if  Left(DKFAQDT,4) > dkfYEAR then
//	sle_msg.text   = "고정자산 회기년도보다 취득년도가 클 수 없습니다."
//   Messagebox("확 인","취득일을 확인하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("kfaqdt")
//   Return
//end if
//
//DKFAQDT = left(DKFAQDT,4) + "/" + mid(DKFAQDT,5,2) + "/" + right(DKFAQDT,2)
//if  NOT IsDATE(DKFAQDT) then
//	sle_msg.text   = "입력한 날짜는 유효하지 않습니다."
//   Messagebox("확 인","취득일을 확인하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("kfaqdt")
//   Return
//end if
//
//DKFCHGB = dw_1.Getitemstring(row_num,"KFchgb")									/* 변동구분 */
//if  DKFCHGB = "" OR Isnull(DKFCHGB) then
//	sle_msg.text   = "변동구분 필드를 클릭한 후 하나를 선택하시오."
//   Messagebox("확 인","변동구분을 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("KFchgb")
//   Return
//ELSE
//	IF DKFCOD1 = "A" AND DKFCHGB = "K" THEN
//		sle_msg.text   = "토지는 변동구분을 상각완료로 입력할 수 없습니다."
//		Messagebox("확 인","변동구분을 확인하시오. !!!")
//		dw_1.setfocus()
//		DW_1.SetColumn("KFchgb")
//		Return
//	END IF
//	SELECT "REFFPF"."RFGUB"      INTO :INTOCOD  
//	   FROM "REFFPF"  
//   	WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'F5' ) AND  
//         	( "REFFPF"."RFGUB" = :DKFCHGB )   ;
//	if SQLCA.SQLCODE <> 0 then
//   	sle_msg.text   = "입력한 변동구분은 참조코드에  존재하지 않습니다."
//	   Messagebox("확 인","변동구분을 확인하시오. !!!")
//   	dw_1.setfocus()	 
//	   DW_1.SetColumn("KFchgb")
//   	Return
//	end if
//end if
//
//IF DKFCOD1 <> "A" THEN																/* 내용년수 */
//   DKFNYR = dw_1.GetitemNumber(row_num,"KFnyr")
//   if  DKFNYR = 0 OR Isnull(DKFNYR) then
//		sle_msg.text   = "내용년수는 감가상각시 중요한 필드입니다."
//      Messagebox("확 인","내용년수를 입력하시오. !!!")
//      dw_1.setfocus()
//      DW_1.SetColumn("KFnyr")
//      Return
//   end if
//END IF
// 
//IF DKFCOD1 <> "A" THEN															/* 상각방법 */
//   DKFDECP = dw_1.Getitemstring(row_num,"KFDEcp")
//
//   if  DKFDECP = "" OR Isnull(DKFDECP) then
//		sle_msg.text   = "상각방법 필드를 클릭한 후 하나를 선택하시오."
//      Messagebox("확 인","상각방법를 입력하시오. !!!")
//      dw_1.setfocus()
//      DW_1.SetColumn("KFDEcp")
//      Return
//	ELSE
//		SELECT "REFFPF"."RFGUB"       INTO :INTOCOD  
//			FROM "REFFPF"  
//     		WHERE ( "REFFPF"."SABU" = '1' ) AND  ( "REFFPF"."RFCOD" = 'F3' ) AND  
//           		( "REFFPF"."RFGUB" = :DKFDECP )   ;
//		if SQLCA.SQLCODE <> 0 then
//      	sle_msg.text   = "입력한 상각방법은 참조코드에  존재하지 않습니다."
//	      Messagebox("확 인","상각방법을 확인하시오. !!!")
//   	   dw_1.setfocus()	 
//      	DW_1.SetColumn("KFDEcp")
//	      Return
//   	end if
//   end if
//END IF
//
//IF DKFCOD1 <> "A" THEN														/* 잔존년수 */
//   DKFJYR = dw_1.GetitemNumber(row_num,"KFjyr")
//END IF
//
///*상각구분*/
//IF DKFCOD1 <> "A" THEN
//   DKFDEGB = dw_1.Getitemstring(row_num,"kfdegb")
//   if  DKFDEGB = "" OR Isnull(DKFDEGB) then
//		sle_msg.text   = "상각구분 필드를 클릭한 후 하나를 선택하시오."
//      Messagebox("확 인","상각구분를 입력하시오. !!!")
//      dw_1.setfocus()
//      DW_1.SetColumn("KFDEgb")
//      Return
//	ELSE
//		SELECT "REFFPF"."RFGUB"         INTO :INTOCOD  
//	      FROM "REFFPF"  
//   	   WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = 'F4' ) AND  
//         	   ( "REFFPF"."RFGUB" = :DKFDEGB );
//		if SQLCA.SQLCODE <> 0 then
//      	sle_msg.text   = "입력한 상각구분은 참조코드에  존재하지 않습니다."
//	      Messagebox("확 인","상각구분을 확인하시오. !!!")
//   	   dw_1.setfocus()	 
//      	DW_1.SetColumn("KFDEgb")
//	      Return
//   	end if
//   end if
//END IF
//
//DKFQNTY = dw_1.GetitemNumber(row_num,"KFqnty")									/* 수량 */
//if  DKFQNTY = 0 OR Isnull(DKFQNTY) then
//	sle_msg.text   = "수량은 안분 감가상각시 중요한 필드입니다."
//   Messagebox("확 인","수량을 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("KFqnty")
//   Return
//end if
// 
///* 제조일반구분 */
//IF DKFCOD1 <> "A" THEN
//   DKFJOG = dw_1.Getitemstring(row_num,"KFjog")
//   if  DKFJOG = "" OR Isnull(DKFJOG) then
//		sle_msg.text   = "자료를 선택하십시오"
//      Messagebox("확 인","제조일반등 구분코드를 입력하시오. !!!")
//      dw_1.setfocus()
//      DW_1.SetColumn("KFjog")
//      Return
//	else
//		SELECT "REFFPF"."RFGUB"         INTO :INTOCOD  
//	      FROM "REFFPF"  
//   	   WHERE ( "REFFPF"."SABU" = '1' ) AND  ( "REFFPF"."RFCOD" = 'F2' ) AND  
//         	   ( "REFFPF"."RFGUB" = :DKFJOG )   ;
//		if SQLCA.SQLCODE <> 0 then
//      	sle_msg.text   = "입력한 구분코드가 참조코드에  존재하지 않습니다."
//	      Messagebox("확 인","제조일반등 구분을 확인하시오. !!!")
//   	   dw_1.setfocus()	 
//      	DW_1.SetColumn("KFjog")
//	      Return
//   	end if
//   end if
//END IF
//
//if DKFJOG = "9" and dw_baeg.RowCount() > 0 then													/*공통이면*/
//	dw_baeg.AcceptText()
//	
//	dKfBaegSum = dw_baeg.GetItemNumber(1,"sum_baeg")
//	
//	if dKfBaegSum = 0  or IsNull(dKfBaegSum) then
//   	sle_msg.text   = "공통일때는 배부기준상세를 입력하시오."
//    	Messagebox("확 인","배부기준상세를 입력하시오. !!!")
//    	dw_baeg.setfocus()
//    	DW_baeg.SetColumn("KFjog")
//    	Return
//	elseif dKfBaegSum <> 100 then
//		sle_msg.text   = "배부기준상세의 합은 100이어야 합니다."
//    	Messagebox("확 인","배부기준상세를 확인하시오. !!!")
//    	dw_baeg.setfocus()
//    	DW_baeg.SetColumn("KFjog")
//    	Return
//   end if	
//end if
//
//IF dw_1.GetItemNumber(row_num,"kfframt") = 0 OR IsNull(dw_1.GetItemNumber(row_num,"kfframt")) THEN
//	sle_msg.text   = ""
//   Messagebox("확 인","기초 취득가액을 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("kfframt")
//   Return
//END IF
//
//DKFAMT = dw_1.Getitemdecimal(row_num,"kfamt")						/* 취득원가 */
//if  DKFAMT = 0 OR Isnull(DKFAMT) then
//	sle_msg.text   = ""
//   Messagebox("확 인","취득원가를 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("kfamt")
//   Return
//end if
//
///* 상각누계액 */
//IF DKFCOD1 <> "A" THEN
//	DKFDEAMT = dw_1.Getitemdecimal(row_num,"KFDEamt")
//
//  	if  Left(DKFAQDT,4) > dkfYEAR then
//		if  DKFDEAMT = 0 OR Isnull(DKFDEAMT) then
//      	sle_msg.text   = "신규취득이 아닌 경우는 기초상각누계액을 입력하시오."
//         Messagebox("확 인","감가상각누계액을 입력하시오. !!!")
//         dw_1.setfocus()
//         DW_1.SetColumn("KFDEamt") 
//         Return
//		end if
//   end if
//end if 
//
//IF DKFAMT < DKFDEAMT THEN
//	sle_msg.text   = "상각누계액이 취득가액보다 클 수 없습니다."
//   Messagebox("확 인","감가상각누계액을 확인하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn("KFDEamt") 
//   Return
//end if
//
///* 전체매각 폐기일 */
//DKFDODT = Trim(dw_1.Getitemstring(row_num,"KFDODT"))
//if Isnull(DKFDODT) then DKFDODT = "" 
//
//IF DKFCHGB = "H" OR DKFCHGB = "I" OR DKFCHGB = "J" THEN
//	if  DKFDODT = "" then
//   	sle_msg.text   = "전체매각 / 폐기일은 변동구분이 H,I,J 일때만 입력합니다."
//      Messagebox("확 인","전체매각 / 폐기일을 입력하시오. !!!")
//      dw_1.setfocus()
//      DW_1.SetColumn("KFDODT")
//      Return
//   end if
//
//   if  Left(DKFDODT,4) > DKFYEAR then
//      sle_msg.text   = "고정자산 회기년도보다 전체매각 / 폐기년도가 클 수 없습니다."
//      Messagebox("확 인","전체매각 / 폐기일을 확인하시오. !!!")
//      dw_1.setfocus()
//      DW_1.SetColumn("KFDODT")
//      Return
//   end if
//
//   DKFDODT = left(DKFDODT,4) + "/" + mid(DKFDODT,5,2) + "/" + right(DKFDODT,2)
//
//   if  NOT IsDATE(DKFDODT) then
//      sle_msg.text   = "입력한 날짜는 유효하지 않습니다."
//      Messagebox("확 인","전체매각 / 폐기일을 확인하시오. !!!")
//      dw_1.setfocus()
//      DW_1.SetColumn("KFDODT")
//      Return
//   end if
//ELSE
//   if  DKFDODT <> ""  then
//   	sle_msg.text   = "전체매각 / 폐기일은 변동구분이 H,I,J 일때만 입력합니다."
//      Messagebox("확 인","전체매각 / 폐기일을 확인하시오. !!!")
//      dw_1.setfocus()
//      DW_1.SetColumn("KFDODT")
//      Return
//   end if
//END IF
//
//if IsNull(DKFDEAMT) then
//   DKFDEAMT = 0
//   DW_1.Setitem(row_num,"KFDEAMT",DKFDEAMT)
//END IF
//
//IF f_dbconfirm("저장") = 2 THEN RETURN
//
///* 무형자산시 과년도취득시 장부가액을 기초취득가액으로 넘긴다*/
//dkfgubun = dw_1.GetItemString(row_num,"kfgubun")
//if  dkfgubun = '4' and dkfdeamt <> 0 then
//	dkfamt = dkfamt - dkfdeamt
//	dkfdeamt =0
//end if
//
//
//IF dw_1.Update() = 1 THEN
//	DELETE FROM "KFA06OT0"  
//	   WHERE ( "KFA06OT0"."KFCOD1" = :DKFCOD1 ) AND ( "KFA06OT0"."KFCOD2" = :DKFCOD2 )   ;
//
//	if dKfJog ='9' then
//		/*공통일 경우 배부기준상세 저장*/
//		Integer i,iRow
//		Double  dKfBaeg
//		
//		iRow = dw_baeg.RowCount()
//		if iRow > 0 then
//			dw_baeg.SetRedraw(False)
//			for i = iRow to 1 step -1
//				dKfBaeg = dw_baeg.GetItemNumber(i, "kfbaeg")
//				if dKfBaeg = 0 or IsNull(dKfBaeg) then
//					dw_baeg.DeleteRow(i)
//				else
//					dw_baeg.SetItem(i,"kfcod1", dkfcod1)
//					dw_baeg.SetItem(i,"kfcod2", dkfcod2)
//				end if
//			next
//			dw_baeg.SetRedraw(True)
//			if dw_baeg.Update() <> 1 then
//				F_MessageChk(13,'[배부율 상세]')
//				Rollback;
//				Return
//			end if
//		end if
//	else
//		delete from kfa02ot0 where kfcod1 = :dKfcod1 and kfcod2 = :dKfcod2;
//	end if
//	
//	COMMIT;
//	sle_msg.text   = "자료가 저장되었습니다."
//ELSE
//   Messagebox("확 인","자료 저장을 실패했습니다. !!!")
//   ROLLBACK;
//	Return
//END IF
//
//ib_any_typing = False
//
//dw_1.SetRedraw(False)
//dw_1.reset()
//dw_1.Insertrow(0)
//dw_1.setitem(dw_1.Getrow(),"KFSACOD",gs_saupj)
//dw_1.Setitem(dw_1.Getrow(),"KFMDPT",DKFMDPT)
//dw_1.SetRedraw(True)
//
//sModStatus ="I"
//wf_retrievemode(sModStatus)
//
//dw_baeg.SetRedraw(False)
//dw_baeg.Reset()
//Wf_Setting_Detail('9')
end event

type cb_ins from w_inherite`cb_ins within w_kfaa02
boolean visible = false
integer x = 951
integer y = 2612
integer taborder = 60
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;//dw_1.reset()
//dw_1.Insertrow(0)
//
//dw_1.setitem(dw_1.Getrow(),"KFSACOD",gs_saupj)
//dw_1.Setitem(dw_1.Getrow(),"KFMDPT",gs_dept)
//
//ib_any_typing = False
//
//sModStatus ="I"
//wf_retrievemode(sModStatus)
//
//sle_msg.text = ""
//
//
end event

type cb_del from w_inherite`cb_del within w_kfaa02
boolean visible = false
integer x = 2523
integer y = 2612
integer taborder = 100
end type

event cb_del::clicked;call super::clicked;//CHAR   DKFCOD1, RET_COD
//long   row_num 
//int    button_num
//Double DKFCOD2
//
//dw_1.AcceptText()
//row_num  = dw_1.Getrow()
//DKFCOD1   = dw_1.GetitemString(row_num,"KFCOD1")
//DKFCOD2   = dw_1.GetitemNumber(row_num,"KFCOD2")
//
//IF sModStatus ="M" THEN	
//   IF Messagebox("확 인","자료를 삭제하시겠습니까 ?",Question!,YesNo!,2) = 2 THEN RETURN
//	
//	dw_1.SetRedraw(False)
//   dw_1.DeleteRow(0)
//   IF dw_1.update() = 1 THEN
//		
//		delete from kfa02ot0 where kfcod1 = :dKfcod1 and kfcod2 = :dKfcod2;
//		
//      cb_ins.TriggerEvent(Clicked!)
//   	dw_1.SetRedraw(True)
//		COMMIT;
//		sle_msg.text   = "자료가 삭제되었습니다"
//   ELSE
//       sle_msg.text   = "자료 삭제를 실패하였습니다.!!"
//       ROLLBACK;
//       return
//   END IF
//ELSE
//   Messagebox("확 인","삭제할 자료가 없습니다. !!!")
//   return
//END IF
//
//ib_any_typing = False
//
//sModStatus ="I"
//wf_retrievemode(sModStatus)
//
//dw_baeg.SetRedraw(False)
//dw_baeg.Reset()
//Wf_Setting_Detail('9')
//
//
end event

type cb_inq from w_inherite`cb_inq within w_kfaa02
boolean visible = false
integer x = 603
integer y = 2612
integer taborder = 120
end type

event cb_inq::clicked;call super::clicked;//CHAR DKFCOD1, intocod
//Long row_num, retrieve_row
//Double DKFCOD2
//
//setpointer(hourglass!)
//
//dw_1.AcceptText()
//row_num  = dw_1.Getrow()
//
///* 계정약칭 */
//DKFCOD1  = dw_1.Getitemstring(row_num,"KFCOD1")
//if  DKFCOD1 = "" or Isnull(DKFCOD1) then
//    sle_msg.text   = "고정자산 계정약칭 필드를 클릭한 후 하나를 선택하시오."
//    Messagebox("확 인","계정약칭을 입력하시오. !!!")
//    DW_1.setfocus()
//    DW_1.SetColumn(1)
//    Return
//end if
//  SELECT "REFFPF"."RFGUB"  
//    INTO :INTOCOD  
//    FROM "REFFPF"  
//   WHERE ( "REFFPF"."SABU" = '1' ) AND  
//         ( "REFFPF"."RFCOD" = 'F1' ) AND  
//         ( "REFFPF"."RFGUB" = :DKFCOD1 )   ;
//if SQLCA.SQLCODE <> 0 then
//   sle_msg.text   = "입력한 계정약칭은 참조코드에  존재하지 않습니다."
//   Messagebox("확 인","계정약칭을 확인하시오. !!!")
//   dw_1.setfocus()	 
//   DW_1.SetColumn(1)
//   Return
//end if
//
///* SEQ 검사 */
//DKFCOD2 = dw_1.GetitemNumber(row_num,"KFCOD2")
//if  DKFCOD2 = 0 or Isnull(DKFCOD2) then
//	sle_msg.text   = "SEQ NO 를 입력한 후 조회버튼을 클릭하시오."
//   Messagebox("확 인","SEQ NO를 입력하시오. !!!")
//   dw_1.setfocus()
//   DW_1.SetColumn(2)
//   Return
//end if
//
//dw_1.SetRedraw(False)
//retrieve_row = DW_1.Retrieve(dkfcod1,dkfcod2)
//if  retrieve_row <= 0  then
//	 cb_ins.TriggerEvent(Clicked!)
//	 dw_1.SetRedraw(True)
//    sle_msg.text   = "해당 Key 에 해당하는 자료는 DB 상에 존재하지 않습니다."
//    Messagebox("확 인","조회 할 자료가 없습니다. !!!")
//    
//    dw_1.setfocus()
//    Return
//end if
//dw_1.SetRedraw(True)
//
//ib_any_typing = False
//
//sle_msg.text = ""
//
//sModStatus ="M"
//wf_retrievemode(sModStatus)
//
//dw_baeg.Retrieve(dkfcod1,dkfcod2)
//	
//Wf_Setting_Detail(dw_1.GetItemString(1,"kfjog"))
//
end event

type cb_print from w_inherite`cb_print within w_kfaa02
boolean visible = false
integer x = 1376
integer y = 2760
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfaa02
end type

type cb_can from w_inherite`cb_can within w_kfaa02
boolean visible = false
integer x = 2871
integer y = 2612
integer taborder = 160
boolean cancel = true
end type

event cb_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.reset()
dw_1.Insertrow(0)

dw_1.setitem(dw_1.Getrow(),"KFSACOD",Gs_Saupj)
dw_1.Setitem(dw_1.Getrow(),"KFMDPT",gs_dept)
dw_1.SetRedraw(True)

ib_any_typing = False

dw_baeg.SetRedraw(False)
dw_baeg.Reset()
Wf_Setting_Detail('9')

sModStatus ="I"
wf_retrievemode(sModStatus)

sle_msg.text = ""


end event

type cb_search from w_inherite`cb_search within w_kfaa02
boolean visible = false
integer x = 105
integer y = 2612
integer taborder = 170
end type

event cb_search::clicked;call super::clicked;//open(w_kfaa02a)

end event

type dw_datetime from w_inherite`dw_datetime within w_kfaa02
integer x = 2857
end type

type sle_msg from w_inherite`sle_msg within w_kfaa02
integer width = 2473
end type

type gb_10 from w_inherite`gb_10 within w_kfaa02
integer width = 3607
end type

type gb_button1 from w_inherite`gb_button1 within w_kfaa02
boolean visible = false
integer x = 73
integer y = 2560
integer width = 1243
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa02
boolean visible = false
integer x = 2135
integer y = 2560
integer width = 1458
end type

type dw_1 from datawindow within w_kfaa02
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 448
integer y = 200
integer width = 3657
integer height = 1540
integer taborder = 20
string dataobject = "d_kfaa02_1"
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

event itemchanged;STRING DKFCOD1, DKFCHGB, DKFAQDT, DKFAQDTYY, DKFYEAR, DKFGUBUN, DKFGBN, DKFENDYY, &
       sgubun1, sgubun1_nm, sgubun2, sgubun2_nm, sKfJog, snull
decimal  DKFNYR, DKFJYR, YYCOMP, DKFAMT,  DKFDEAMT
long row_num

SetNull(snull)

row_num  = dw_1.Getrow()

DW_1.ACCEPTTEXT()

DKFCOD1  = dw_1.Getitemstring(row_num,"KFCOD1")  /*자산계정구분*/
DKFGUBUN = dw_1.Getitemstring(row_num,"KFgubun")  /*세법상분류*/
DKFAMT   = dw_1.Getitemnumber(row_num,"KFAMT")
DKFDEAMT = dw_1.Getitemnumber(row_num,"KFDEAMT")
DKFNYR   = dw_1.Getitemnumber(row_num,"KFNYR")
DKFJYR   = dw_1.Getitemnumber(row_num,"KFJYR")
DKFCHGB  = dw_1.Getitemstring(row_num,"KFchgb")
DKFENDYY = dw_1.Getitemstring(row_num,"KFENDYY")  /**/

if this.GetColumnName() = 'kfamt' then
	if this.GetItemNumber(this.GetRow(),"kfframt") = 0 OR IsNull(this.GetItemNumber(this.GetRow(),"kfframt")) then
		if this.GetText() = '' or IsNull(this.GetText()) then
			this.Setitem(this.GetRow(),"kfframt",0)
		else
			this.Setitem(this.GetRow(),"kfframt",Double(this.GetText()))
		end if
	end if
end if

/* 토지일때 */
IF DKFCOD1 = 'A' THEN
   DW_1.SetItem(row_num,"kfnyr",0)
   DW_1.SetItem(row_num,"kfJyr",0)
   dw_1.Setitem(row_num,"KFDECP","")
   dw_1.Setitem(row_num,"KFJOG","")
   dw_1.Setitem(row_num,"KFDEGB","2")
	
	dw_baeg.SetRedraw(False)
	dw_baeg.Reset()
	Wf_Setting_Detail('')
END IF

/* 세법상 무형자산일 경우 NUMBER1에 년상각비 보관함*/
/* 유형,무형구분하여 gubun3에 1유형, 2무형으로 갱신함*/
IF DKFGUBUN = '4' THEN
	if dkfchgb ='A' AND DKFNYR <> 0 then /*신규취득시*/
      DW_1.SetItem(row_num,"NUMBER1",TRUNCATE(DKFAMT/DKFNYR,0))
	else  /*과년도취득시*/
		if not isnull(dkfjyr) and dkfjyr <> 0 then
         DW_1.SetItem(row_num,"NUMBER1",TRUNCATE((DKFAMT - DKFDEAMT)/DKFJYR,0))
	   end if
	end if
	
   DW_1.SetItem(row_num,"gubun3",'2')
else
   DW_1.SetItem(row_num,"gubun3",'1')
END IF

/* 갱신함*/
IF isnull(DKFENDYY) or DKFENDYY ="" THEN
   DW_1.SetItem(row_num,"kfendgb",'N')
else
   DW_1.SetItem(row_num,"kfendgb",'Y')
END IF

/* 취득일로 부터 변동구분 계산  */
if  DKFCHGB = "" OR DKFCHGB = "A" OR DKFCHGB = "B" OR Isnull(DKFCHGB) THEN
    DKFAQDT = dw_1.Getitemstring(row_num,"kfaqdt")
   
   if DKFAQDT <> ""  AND  NOT Isnull(DKFAQDT) then

      DKFAQDTYY = left(DKFAQDT,4) 

      SELECT "KFA07OM0"."KFYEAR"  
      INTO :DKFYEAR  
      FROM "KFA07OM0"  ;

      YYCOMP = DEC(DKFYEAR) - DEC(DKFAQDTYY)
      IF YYCOMP > 0 THEN
         dw_1.Setitem(ROW_NUM,"KFCHGB","B")
      ELSE
         IF YYCOMP = 0 THEN
            dw_1.Setitem(ROW_NUM,"KFCHGB","A")
         END IF
      END IF 

      IF DKFCOD1 <> 'A' THEN
         DKFNYR = dw_1.GetitemDECIMAL(row_num,"KFNYR")
         if  DKFNYR <> 0  AND  NOT Isnull(DKFNYR) then
             DKFJYR = DKFNYR - YYCOMP

             IF DKFJYR < 0 THEN
                DKFJYR = 0
//                dw_1.Setitem(ROW_NUM,"KFCHGB","K")
             END IF
             dw_1.Setitem(ROW_NUM,"KFJYR",DKFJYR)
         END IF
      END IF
   End if
END IF
if this.GetColumnName() = "kfjog" then
	sKfjog = this.GetText()
	dw_baeg.SetRedraw(False)
	dw_baeg.Retrieve(dkfcod1,this.GetItemNumber(1,"kfcod2"))
	Wf_Setting_Detail(sKfjog)	
end if
If dw_1.GetColumnName() = 'gubun1' then
	sgubun1 = dw_1.GetItemString(row_num, 'gubun1')
	
	If sgubun1 = "" or Isnull(sgubun1) then
		dw_1.SetItem(row_num, 'gubun1_nm', snull)
		Return
	End If

	  SELECT "MCHMST"."MCHNAM"  
		 INTO :sgubun1_nm  
		 FROM "MCHMST"  
	 WHERE "MCHMST"."MCHNO" = :sgubun1;

	IF SQLCA.SQLCODE = 100 THEN
		f_messagechk(20,"설비번호")
		dw_1.SetItem(1, 'gubun1', sNull)
		dw_1.SetItem(1, 'gubun1_nm', sNull)
		dw_1.SetColumn('gubun1')
		dw_1.SetFocus()
		Return 1
	END IF
	dw_1.SetItem(1, 'gubun1_nm', sgubun1_nm)
END IF

If dw_1.GetColumnName() = 'gubun2' then
	sgubun2 = dw_1.GetItemString(row_num, 'gubun2')
	
	If sgubun2 = "" or Isnull(sgubun2) then
		dw_1.SetItem(row_num, 'gubun2_nm', snull)
		Return
	End If
		
	SELECT "KUMMST"."KUMNAME"
	INTO :sgubun2_nm
	FROM "KUMMST"
	WHERE "KUMMST"."KUMNO" = :sgubun2 ;
	
	If sqlca.sqlcode = 100 then
		f_messagechk(20, "금형번호")
		dw_1.SetItem(1, 'gubun2', snull)
		dw_1.SetItem(1, 'gubun2_nm', snull)
		dw_1.SetColumn('gubun2')
		dw_1.SetFocus()
		Return 1
	End If
	dw_1.SetItem(1, 'gubun2_nm', sgubun2_nm)
End If
this.SetItem(this.GetRow(),"kfhalf",F_Check_Half(this.GetItemString(this.GetRow(),"kfchgb"),this.GetItemString(this.GetRow(),"kfaqdt")))
end event

event rbuttondown;char dkfcod1
long dkfcod2, row_num, retrieve_row 
String sgubun1, sgubun2

dw_1.AcceptText()

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() ="kfcod2" THEN 	
	row_num  = dw_1.Getrow()

	dkfcod1 = dw_1.GetItemString( row_num, "kfcod1")
	dkfcod2 = dw_1.GetItemNumber( row_num, "kfcod2")

	IF Isnull(dkfcod1) then dkfcod1 = ""
	if Isnull(dkfcod2) then dkfcod2 = 0

	gs_code = dkfcod1
	gs_codename = String(dkfcod2)

	open(w_kfaa02b)

	if gs_code = '' OR IsNull(gs_code) then Return
	
	dkfcod1 = gs_code
	IF IsNull(gs_codename) THEN
		IsNull(dkfcod2)
	ELSE
		dkfcod2= Long(gs_codename) 
	END IF

	DW_1.Retrieve(dkfcod1,dkfcod2)
	dw_baeg.Retrieve(dkfcod1,dkfcod2)
	Wf_Setting_Detail(dw_1.GetItemString(1,"kfjog"))

	dw_1.SetFocus()

	ib_any_typing =False
	
	sModStatus ="M"
	wf_retrievemode(sModStatus)
	
	w_mdi_frame.sle_msg.text = ""

END IF


end event

event editchanged;ib_any_typing =True
end event

event itemerror;Return 1
end event

event dberror;//MessageBox('error',sqlerrtext)
end event

type dw_baeg from u_key_enter within w_kfaa02
integer x = 475
integer y = 1812
integer width = 3598
integer height = 176
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_kfaa02c1"
boolean border = false
end type

type st_2 from statictext within w_kfaa02
integer x = 498
integer y = 1764
integer width = 453
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "배부기준율 상세"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfaa02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 466
integer y = 1756
integer width = 3625
integer height = 256
integer cornerheight = 40
integer cornerwidth = 46
end type

