$PBExportHeader$w_imt_02050.srw
$PBExportComments$** 발주확정취소
forward
global type w_imt_02050 from w_inherite
end type
type dw_1 from datawindow within w_imt_02050
end type
type pb_1 from u_pb_cal within w_imt_02050
end type
type pb_2 from u_pb_cal within w_imt_02050
end type
type rr_1 from roundrectangle within w_imt_02050
end type
end forward

global type w_imt_02050 from w_inherite
integer height = 3772
string title = "발주확정 취소"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_imt_02050 w_imt_02050

type variables
string is_pspec, is_jijil
end variables

forward prototypes
public subroutine wf_reset ()
end prototypes

public subroutine wf_reset ();string snull

setnull(snull)

dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()

dw_1.insertrow(0)

string get_name

SELECT "SYSCNFG"."DATANAME"  
  INTO :get_name  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 14 ) AND  
		 ( "SYSCNFG"."LINENO" = '1' )   ;
dw_1.setitem(1, 'sempno', get_name) //구매 담당자 기본 셋팅

dw_1.setredraw(true)
dw_insert.setredraw(true)
dw_1.setfocus()

//cb_search.enabled = true
//
//
//
f_child_saupj(dw_1, "sempno", gs_saupj)
f_mod_saupj(dw_1, 'saupj')
end subroutine

on w_imt_02050.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_imt_02050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent('ue_open')
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

event ue_open;call super::ue_open;/*사업장별 구매담당자 셋팅*/
f_child_saupj(dw_1,'sempno','%')

dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

string get_name

SELECT "SYSCNFG"."DATANAME"  
  INTO :get_name  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 14 ) AND  
		 ( "SYSCNFG"."LINENO" = '1' )   ;
dw_1.setitem(1, 'sempno', get_name) //구매 담당자 기본 셋팅


IF f_change_name('1') = 'Y' then 
	is_pspec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_insert.object.ispec_t.text = is_pspec
	dw_insert.object.jijil_t.text = is_jijil
END IF

/* User별 사업장 Setting */
f_mod_saupj(dw_1, 'saupj')

end event

type dw_insert from w_inherite`dw_insert within w_imt_02050
integer x = 64
integer y = 308
integer width = 4539
integer height = 1996
integer taborder = 20
string dataobject = "d_imt_02050"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;//Dec {2} dQty
//
//dQty = Dec(gettext())
//
//if dQty > getitemdecimal(row, "janqty") then
//	Messagebox("취소가능수량", "취소수량의 범위를 벗어났읍니다", stopsign!)
//	setitem(row, "calcenqty", getitemdecimal(row, "janqty"))
//	return 1
//end if
//
//if dQty <> getitemdecimal(row, "janqty") then
//	setitem(row, "cnfm", 'Y')
//end if
//
end event

type p_delrow from w_inherite`p_delrow within w_imt_02050
boolean visible = false
integer x = 1650
integer y = 2432
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_imt_02050
boolean visible = false
integer x = 1477
integer y = 2432
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_imt_02050
boolean visible = false
integer x = 782
integer y = 2432
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_imt_02050
boolean visible = false
integer x = 1303
integer y = 2432
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_imt_02050
integer x = 4425
end type

type p_can from w_inherite`p_can within w_imt_02050
integer x = 4251
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_imt_02050
boolean visible = false
integer x = 955
integer y = 2432
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_imt_02050
integer x = 3904
end type

event p_inq::clicked;call super::clicked;string s_frdept, s_todept, s_frdate, s_todate, s_empno

if dw_1.AcceptText() = -1 then return 

s_frdate= trim(dw_1.GetItemString(1,'frdate'))  //의뢰일자 from
s_todate= trim(dw_1.GetItemString(1,'todate'))  //의뢰일자 to
s_frdept= trim(dw_1.GetItemString(1,'frdept'))  //의뢰부서 from
s_todept= trim(dw_1.GetItemString(1,'todept'))  //의뢰부서 to
s_empno = dw_1.GetItemString(1,'sempno') //구매담당자

if isnull(s_empno) or s_empno = "" then
	f_message_chk(30,'[구매담당자]')
	dw_1.Setcolumn('sempno')
	dw_1.SetFocus()
	return
end if	

if isnull(s_frdept) or s_frdept = "" then s_frdept = '.'
if isnull(s_todept) or s_todept = "" then s_todept = 'zzzzzz'
if isnull(s_frdate) or s_frdate = "" then s_frdate = '00000101'
if isnull(s_todate) or s_todate = "" then s_todate = '99991231'

if dw_insert.Retrieve(gs_sabu, gs_saupj, s_frdate, s_todate, &
							 s_frdept, s_todept, s_empno) <= 0 then 
	f_message_chk(50,'[발주확정내역]')
	dw_1.SetFocus()
end if

dw_insert.SetFocus()

ib_any_typing = FALSE

end event

type p_del from w_inherite`p_del within w_imt_02050
boolean visible = false
integer x = 1998
integer y = 2432
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_imt_02050
integer x = 4078
end type

event p_mod::clicked;call super::clicked;if dw_insert.accepttext() = -1 then return
if dw_insert.rowcount() < 1 then return 
setpointer(hourglass!)

Long    Lrow, get_count, dBalseq, dseq
String  sbaljpno, sbgubun
Integer iReturn

iReturn = Messagebox('확 인','발주자료를 취소처리 하시겠습니까?',Question!,YesNo!,1) 

IF iReturn = 2 THEN  Return 

For Lrow = 1 to dw_insert.rowcount()
	 IF dw_insert.getitemstring(Lrow, "cnfm") = 'N' then continue
		  
	 sBaljpno 	= dw_insert.getitemstring(Lrow, "baljpno")
	 dBalseq  	= dw_insert.getitemNumber(Lrow, "balseq")
		 
	 // 구매의뢰 내역에 대한 자료를 수정
	 // 의뢰수량을 취소수량으로 변경
	 // 상태를 의뢰로 변경
	 UPDATE "ESTIMA"  
		 SET "BLYND" 	= '1',   
			  "BALJUTIME" = NULL,
			  "BALJPNO"   = NULL,
			  "BALSEQ"    = 0,
			  "YEBI2"	  = '0'
	 WHERE ( "ESTIMA"."SABU" 	 = :gs_sabu ) AND  
			 ( "ESTIMA"."BALJPNO" = :sBaljpno ) AND  
			 ( "ESTIMA"."BALSEQ"  = :dBalseq )   ;

	 If sqlca.sqlcode <> 0  then
		 Rollback;
		 Messagebox("확 인", "구매의뢰 자료 저장중 오류발생", stopsign!)
		 return
	 END IF	 		

	 // 구매 취소 이력
	 dseq = 0
	 Select max(calseq) into :dseq from podel_history
	  where sabu = :gs_sabu and baljpno = :sbaljpno and balseq = :dbalseq;
		  
	 if isnull(dseq) then dseq = 0
	 dseq = dseq + 1
		 
    INSERT INTO "PODEL_HISTORY"  
				( "SABU",        "BALJPNO",       "BALGU",       "BALDATE",       "CVCOD",   
				  "BAL_EMPNO",   "BAL_SUIP",      "PLNOPN",      "PLNCRT",        "PLNAPP",   
				  "PLNBNK",      "BGUBUN",        "BALSEQ",      "ITNBR",         "PSPEC",   
				  "OPSEQ",       "GUDAT",         "NADAT",       "BALQTY",        "RCQTY",   
				  "BFAQTY",      "BPEQTY",        "BTEQTY",      "BJOQTY",        "BCUQTY",   
				  "LCOQTY",      "BLQTY",         "ENTQTY",      "LCBIPRC",       "LCBIAMT",   
				  "ORDER_NO",    "BALSTS",        "ESTGU",       "ESTNO",         "SAYEO",   
				  "FNADAT",      "TUNCU",         "UNPRC",       "UNAMT",         "LSIDAT",   
				  "BQCQTYT",     "BIPWQTY",       "PORDNO",      "CRT_DATE",      "CRT_TIME",   
				  "CRT_USER",    "UPD_DATE",      "UPD_TIME",    "UPD_USER",      "IPDPT",   
				  "CNVFAT",      "CNVART",        "CNVQTY",      "CNVIPG",        "CNVFAQ",   
				  "CNVBPE",      "CNVBTE",        "CNVBJO",      "CNVQCT",        "CNVCUQ",   
				  "CNVPRC",      "CNVAMT",        "CNVBLQ",      "CNVENT",        "CNVLCO",   
				  "CANDAT",                       "CALSEQ",      "CANQTY",        "CANCNV", 
				  "ACCOD",       "PROJECT_NO",    "SAUPJ",       "RDPTNO"     )  
		 SELECT A.SABU, 	     A.BALJPNO,       B.BALGU, 	    B.BALDATE, 	   B.CVCOD, 
		       B.BAL_EMPNO, 	  B.BAL_SUIP, 	    B.PLNOPN,    	 B.PLNCRT,     	B.PLNAPP,
				 B.PLNBNK, 		  B.BGUBUN,			 A.BALSEQ,	    A.ITNBR,		   A.PSPEC,	
				 A.OPSEQ,		  A.GUDAT,			 A.NADAT,	    A.BALQTY,	      A.RCQTY,
				 A.BFAQTY,		  A.BPEQTY,			 A.BTEQTY,	    A.BJOQTY,	      A.BCUQTY,
				 A.LCOQTY,		  A.BLQTY,			 A.ENTQTY,	    A.LCBIPRC,	      A.LCBIAMT,
				 A.ORDER_NO,	  A.BALSTS,			 NULL,          NULL,            A.SAYEO,
				 A.FNADAT,       A.TUNCU,		    A.UNPRC,		 A.UNAMT,		   A.LSIDAT,
				 A.BQCQTYT, 	  A.BIPWQTY, 	    A.PORDNO,		 TO_CHAR(SYSDATE, 'YYYYMMDD'), 
				 TO_CHAR(SYSDATE, 'HHMMSS'), 
				 :gs_userid,	  NULL,				 NULL,			 NULL, 			   A.IPDPT,	
				 A.CNVFAT,       A.CNVART,        A.CNVQTY,      A.CNVIPG,        A.CNVFAQ,
				 A.CNVBPE,		  A.CNVBTE,        A.CNVBJO,      A.CNVQCT,        A.CNVCUQ, 
				 A.CNVPRC,       A.CNVAMT, 		 A.CNVBLQ,      A.CNVENT,        A.CNVLCO, 
				 TO_CHAR(SYSDATE, 'YYYYMMDD'),	 :dseq,         A.BALQTY,        A.CNVQTY, 
				 A.ACCOD,        A.PROJECT_NO,    A.SAUPJ,       A.RDPTNO         
		  FROM POBLKT A, POMAST B
		 WHERE A.SABU 		= :GS_SABU
			AND A.BALJPNO	= :SBALJPNO
			AND A.BALSEQ	= :DBALSEQ
			AND A.SABU		= B.SABU
			AND A.BALJPNO	= B.BALJPNO;	 
				
		 If sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
			 Rollback;
			 Messagebox("구매취소이력", "구매취소 이력 자료저장중 오류발생", stopsign!)
			 return
		 END IF	 		
	 
	  DELETE FROM "POBLKT"  
		WHERE ( "POBLKT"."SABU" 	= :gs_sabu ) AND  
				( "POBLKT"."BALJPNO" = :sBaljpno ) AND  
				( "POBLKT"."BALSEQ" 	= :dBalseq )   ;
		
	 If sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
		 Rollback;
		 Messagebox("구매의뢰 변경", "자료저장중 오류발생", stopsign!)
		 return
	 else	 
		select count(*) into :get_count from poblkt 
		 where sabu = :gs_sabu and baljpno = :sBaljpno ;

		 if get_count < 1 then 
          DELETE FROM "POMAST"  
			  WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
				     ( "POMAST"."BALJPNO" = :sBaljpno )   ;
					  
  			 If sqlca.sqlcode <> 0  then
				 Rollback;
				 Messagebox("발주삭제", "발주자료 삭제중 오류발생", stopsign!)
				 return
			 END IF	 		

		 end if
	 end if
 
Next

Commit;

Setpointer(arrow!)
p_inq.triggerevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_imt_02050
end type

type cb_mod from w_inherite`cb_mod within w_imt_02050
end type

type cb_ins from w_inherite`cb_ins within w_imt_02050
integer x = 539
integer y = 2472
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_imt_02050
integer x = 1143
integer y = 2392
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_imt_02050
end type

type cb_print from w_inherite`cb_print within w_imt_02050
integer x = 987
integer y = 2672
integer width = 402
boolean enabled = false
string text = "거래처등록"
end type

type st_1 from w_inherite`st_1 within w_imt_02050
end type

type cb_can from w_inherite`cb_can within w_imt_02050
end type

type cb_search from w_inherite`cb_search within w_imt_02050
integer x = 489
integer y = 2464
integer width = 402
integer taborder = 40
boolean enabled = false
string text = "발주선택"
end type





type gb_10 from w_inherite`gb_10 within w_imt_02050
integer y = 2500
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_02050
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_02050
end type

type dw_1 from datawindow within w_imt_02050
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 60
integer width = 3109
integer height = 216
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_02050_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string snull, s_date

setnull(snull)

IF this.GetColumnName() ="frdate" THEN  //의뢰일자 FROM
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[발주일자]')
		this.SetItem(1,"frdate",snull)
		this.Setcolumn("frdate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() ="todate" THEN  //의뢰일자 TO
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[발주일자]')
		this.SetItem(1,"todate",snull)
		this.Setcolumn("todate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF GEtColumnName() = 'saupj' THEN
	s_date = GetText()
	
	/*사업장별 구매담당자 셋팅*/
	f_child_saupj(dw_1,'sempno','%')
END IF	
end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "frdept" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "frdept", gs_Code)
ELSEIF this.GetColumnName() = "todept" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "todept", gs_Code)
END IF	
end event

type pb_1 from u_pb_cal within w_imt_02050
integer x = 1554
integer y = 164
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('frdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'frdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_02050
integer x = 2007
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('todate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'todate', gs_code)



end event

type rr_1 from roundrectangle within w_imt_02050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 300
integer width = 4558
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

