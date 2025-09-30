$PBExportHeader$w_kfia25.srw
$PBExportComments$일자금수지 조회 출력
forward
global type w_kfia25 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia25
end type
type st_1 from statictext within w_kfia25
end type
type rb_1 from radiobutton within w_kfia25
end type
type rb_2 from radiobutton within w_kfia25
end type
type rb_3 from radiobutton within w_kfia25
end type
type rr_2 from roundrectangle within w_kfia25
end type
end forward

global type w_kfia25 from w_standard_print
integer x = 0
integer y = 0
string title = "일자금수지 조회 출력"
rr_1 rr_1
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rr_2 rr_2
end type
global w_kfia25 w_kfia25

type variables
String   LsFinanceDate[10]
end variables

forward prototypes
public function integer wf_ins1 (string s_date)
public function integer wf_ins2 (string s_date)
public function integer wf_ins3 (string s_date)
public function integer wf_calculation_date (string sbasedate)
public function integer wf_retrieve ()
end prototypes

public function integer wf_ins1 (string s_date);Long lp_amt
int  K, icount = 12 , ifin_no 
string samt[12], sfin_date, symd[12], sfin_cd

sle_msg.text = "일 자금수지 계획 조회중입니다.!!"

symd ={"dd1","dd2","dd3","dd4","dd5","dd6","dd7","dd8","dd9","dd10","dd11","dd12"} 
samt ={"amt1","amt2","amt3","amt4","amt5","amt6","amt7","amt8","amt9","amt10","amt11","amt12"}

  SELECT count("KFM10OM0"."FINANCE_CD")  
    INTO :ifin_no  
    FROM "KFM10OM0"  ;


if dw_list.Retrieve(s_date) <= 0 then
	f_messagechk(14,"") 
	Return -1
end if


DECLARE cur_ysw CURSOR FOR  
	SELECT DISTINCT "KFM11OT0"."FINANCE_DATE" 
	FROM "KFM11OT0"  
	WHERE "KFM11OT0"."FINANCE_DATE" <= :s_date
   ORDER BY "KFM11OT0"."FINANCE_DATE" DESC  ;

OPEN cur_ysw;

DO WHILE TRUE

	FETCH cur_ysw INTO :sFin_date	;
	
	IF SQLCA.SQLCODE <> 0 OR icount = 0 THEN EXIT
	
	FOR k = 1 TO ifin_no
	    sfin_cd = dw_list.GetItemString(k, "f_cd")
		 
		 SELECT round("KFM11OT0"."PLAN_AMT" / 1000,0)
         INTO :lp_amt  
         FROM "KFM11OT0"  
        WHERE ( "KFM11OT0"."FINANCE_CD" = :sfin_cd ) AND  
              ( "KFM11OT0"."FINANCE_DATE" = :sfin_date )   ;
        
		  dw_list.SetItem( K, samt[icount], lp_amt)
		  dw_list.SetItem( K, symd[icount], right(sFin_date, 4))
   NEXT
   
	icount = icount - 1
   
LOOP

CLOSE cur_ysw;

RETURN 1


end function

public function integer wf_ins2 (string s_date);Long lp_amt
int  K, icount = 12 , ifin_no 
string samt[12], sfin_date, symd[12], sfin_cd

sle_msg.text = "일 자금수지 실적 조회중입니다.!!"

symd ={"dd1","dd2","dd3","dd4","dd5","dd6","dd7","dd8","dd9","dd10","dd11","dd12"} 
samt ={"amt1","amt2","amt3","amt4","amt5","amt6","amt7","amt8","amt9","amt10","amt11","amt12"}

  SELECT count("KFM10OM0"."FINANCE_CD")  
    INTO :ifin_no  
    FROM "KFM10OM0"  ;


if dw_list.Retrieve(s_date) <= 0 then
   f_messagechk(14,"")
	Return -1
end if

DECLARE cur_ysw CURSOR FOR  
	SELECT DISTINCT "KFM11OT0"."FINANCE_DATE" 
	FROM "KFM11OT0"  
	WHERE "KFM11OT0"."FINANCE_DATE" <= :s_date
   ORDER BY "KFM11OT0"."FINANCE_DATE" DESC  ;

OPEN cur_ysw;

DO WHILE TRUE

	FETCH cur_ysw INTO :sFin_date	;
	
	IF SQLCA.SQLCODE <> 0 OR icount = 0 THEN EXIT
	
	FOR k = 1 TO ifin_no
	    sfin_cd = dw_list.GetItemString(k, "f_cd")
		 
		 SELECT round("KFM11OT0"."ACTUAL_AMT" / 1000,0)
         INTO :lp_amt  
         FROM "KFM11OT0"  
        WHERE ( "KFM11OT0"."FINANCE_CD" = :sfin_cd ) AND  
              ( "KFM11OT0"."FINANCE_DATE" = :sfin_date )   ;
        
		  dw_list.SetItem( K, samt[icount], lp_amt)
		  dw_list.SetItem( K, symd[icount], right(sFin_date, 4))
   NEXT
   
	icount = icount - 1
   
LOOP

CLOSE cur_ysw;

RETURN 1


end function

public function integer wf_ins3 (string s_date);Long lp_amt, la_amt
int  K, icount = 6 , ifin_no 
string samt[6], spamt[6], sfin_date, symd[6], sfin_cd

sle_msg.text = "일 자금수지 계획대비실적 조회중입니다.!!"

symd ={"dd1","dd2","dd3","dd4","dd5","dd6"} 
samt ={"amt1","amt2","amt3","amt4","amt5","amt6"}
spamt ={"pamt1","pamt2","pamt3","pamt4","pamt5","pamt6"}

  SELECT count("KFM10OM0"."FINANCE_CD")  
    INTO :ifin_no  
    FROM "KFM10OM0"  ;


if dw_list.Retrieve(s_date) <= 0 then
   f_messagechk(14,"")
	Return -1
end if

DECLARE cur_ysw CURSOR FOR  
	SELECT DISTINCT "KFM11OT0"."FINANCE_DATE" 
	FROM "KFM11OT0"  
	WHERE "KFM11OT0"."FINANCE_DATE" <= :s_date
   ORDER BY "KFM11OT0"."FINANCE_DATE" DESC  ;

OPEN cur_ysw;

DO WHILE TRUE

	FETCH cur_ysw INTO :sFin_date	;
	
	IF SQLCA.SQLCODE <> 0 OR icount = 0 THEN EXIT
	
	FOR k = 1 TO ifin_no
	    sfin_cd = dw_list.GetItemString(k, "f_cd")
		 
		 SELECT round("KFM11OT0"."PLAN_AMT" / 1000,0), round("KFM11OT0"."ACTUAL_AMT"/1000,0)
         INTO :lp_amt, :la_amt  
         FROM "KFM11OT0"  
        WHERE ( "KFM11OT0"."FINANCE_CD" = :sfin_cd ) AND  
              ( "KFM11OT0"."FINANCE_DATE" = :sfin_date )   ;
        
		  dw_list.SetItem( K, samt[icount], lp_amt)
		  dw_list.SetItem( K,spamt[icount], la_amt)
		  dw_list.SetItem( K, symd[icount], right(sFin_date, 4))
   NEXT
   
	icount = icount - 1
   
LOOP

CLOSE cur_ysw;

RETURN 1


end function

public function integer wf_calculation_date (string sbasedate);
String  sClDate, sdate
Integer iCount,iCurCnt

sdate = trim(dw_ip.GetItemString(1,"finance_date"))

SELECT count(distinct finance_date) 	 INTO :iCount
	FROM kfm11ot0
   WHERE finance_date >= :sdate ;
IF SQLCA.SQLCODE <> 0 THEN
	Return -1
ELSE
	IF IsNull(iCount) OR iCount = 0 THEN Return -1
END IF

DECLARE cur_calendar CURSOR FOR  

   SELECT distinct finance_date
	  FROM kfm11ot0
    WHERE finance_date >= :sdate 
 ORDER BY finance_date ;
Open Cur_Calendar;

iCurCnt = 0

DO WHILE True
	FETCH Cur_Calendar INTO :sClDate	;
	
	if iCurCnt > 6 then exit
	
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	iCurCnt = iCurCnt + 1	
	LsFinanceDate[iCurCnt] = sClDate
LOOP
Close Cur_Calendar;


Return 1

end function

public function integer wf_retrieve ();
String  sDatef

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sDatef = trim(dw_ip.GetItemString(1,"finance_date"))

IF f_datechk(sDatef) = -1 THEN
	f_messagechk(20, "기준일자")
	dw_ip.SetColumn("finance_date")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF Wf_Calculation_Date(sDatef) = -1 THEN
		F_Messagechk(14,'')
		dw_ip.SetColumn("finance_date")
		dw_ip.SetFocus()
		Return -1
	End if
END IF

IF dw_print.Retrieve(LsFinanceDate[1], &
						  LsFinanceDate[2], &
						  LsFinanceDate[3], &
						  LsFinanceDate[4], &
						  LsFinanceDate[5], &
						  LsFinanceDate[6]) <=0 THEN
	F_MessageChk(14,'')
	dw_list.insertrow(0)
	//Return -1
END IF
dw_print.sharedata(dw_list)

Return 1

end function

on w_kfia25.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rr_2
end on

on w_kfia25.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,"finance_date", f_today())

end event

type p_preview from w_standard_print`p_preview within w_kfia25
integer y = 8
end type

type p_exit from w_standard_print`p_exit within w_kfia25
integer x = 4453
integer y = 8
end type

type p_print from w_standard_print`p_print within w_kfia25
integer x = 4274
integer y = 8
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia25
integer x = 3918
integer y = 8
end type

type st_window from w_standard_print`st_window within w_kfia25
integer y = 5000
end type

type sle_msg from w_standard_print`sle_msg within w_kfia25
integer y = 5000
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfia25
integer y = 5000
end type

type st_10 from w_standard_print`st_10 within w_kfia25
integer y = 5000
end type

type gb_10 from w_standard_print`gb_10 within w_kfia25
integer y = 5000
end type

type dw_print from w_standard_print`dw_print within w_kfia25
integer x = 3058
integer y = 16
string dataobject = "dw_kfia25_prt1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia25
integer x = 37
integer y = 60
integer width = 731
integer height = 160
string dataobject = "dw_kfia25_1"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kfia25
integer x = 64
integer y = 264
integer width = 4544
integer height = 2060
string dataobject = "dw_kfia25_prt1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia25
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 814
integer y = 64
integer width = 1193
integer height = 140
integer cornerheight = 40
integer cornerwidth = 41
end type

type st_1 from statictext within w_kfia25
integer x = 855
integer y = 80
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "작업선택"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_kfia25
event clicked pbm_bnclicked
integer x = 869
integer y = 144
integer width = 315
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 계  획"
boolean checked = true
end type

event clicked;dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	
	dw_list.dataObject='dw_kfia25_prt1'
END IF
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)


end event

type rb_2 from radiobutton within w_kfia25
event clicked pbm_bnclicked
integer x = 1216
integer y = 136
integer width = 315
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 실  적"
end type

event clicked;dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	
	dw_list.dataObject='dw_kfia25_prt2'
END IF
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)


end event

type rb_3 from radiobutton within w_kfia25
event clicked pbm_bnclicked
integer x = 1568
integer y = 132
integer width = 315
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 비  교"
end type

event clicked;dw_list.SetRedraw(False)
IF rb_3.Checked =True THEN
	
	dw_list.dataObject='dw_kfia25_prt3'
END IF
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)


end event

type rr_2 from roundrectangle within w_kfia25
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 248
integer width = 4585
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 41
end type

