$PBExportHeader$w_pdt_08001.srw
$PBExportComments$외주 발주 확정 취소
forward
global type w_pdt_08001 from w_inherite
end type
type dw_1 from datawindow within w_pdt_08001
end type
type cbx_1 from checkbox within w_pdt_08001
end type
type pb_1 from u_pb_cal within w_pdt_08001
end type
type pb_2 from u_pb_cal within w_pdt_08001
end type
type rr_1 from roundrectangle within w_pdt_08001
end type
end forward

global type w_pdt_08001 from w_inherite
string title = "외주발주 확정 취소"
dw_1 dw_1
cbx_1 cbx_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_pdt_08001 w_pdt_08001

type variables

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
		 ( "SYSCNFG"."LINENO" = '2' )   ;
dw_1.setitem(1, 'sempno', get_name) //구매 담당자 기본 셋팅

dw_1.setredraw(true)
dw_insert.setredraw(true)
dw_1.setfocus()

p_search.enabled = true
p_search.PictureName = "c:\erpman\image\발주선택_up.gif"

f_mod_saupj(dw_1, 'saupj')
f_child_saupj(dw_1, 'sempno', gs_saupj)


end subroutine

on w_pdt_08001.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_pdt_08001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;// 외주담당자
datawindowchild state_child1
integer rtncode

rtncode = dw_1.GetChild('sempno', state_child1)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 외주")
state_child1.SetTransObject(SQLCA)
state_child1.Retrieve("2", "2", gs_saupj)

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
		 ( "SYSCNFG"."LINENO" = '2' )   ;
// dw_1.setitem(1, 'sempno', get_name) //구매 담당자 기본 셋팅

///* 담당자 Filtering */
//DataWindowChild state_child2
//integer rtncode2
//
//IF gs_saupj              = '10' THEN
//	rtncode2    = dw_1.GetChild('sempno', state_child2)
//	
//	IF rtncode2 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	
//	state_child2.setFilter("Mid(rfgub,1,1) = '5'")
//	state_child2.Filter()
//	
//ELSEIF gs_saupj      = '11' THEN
//   rtncode2    = dw_1.GetChild('sempno', state_child2)
//	
//	IF rtncode2 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	
//	state_child2.setFilter("Mid(rfgub,1,1) = 'Z'")
//	state_child2.Filter()
//END IF


wf_reset()
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

type dw_insert from w_inherite`dw_insert within w_pdt_08001
integer x = 27
integer y = 268
integer width = 4498
integer height = 2044
integer taborder = 20
string dataobject = "d_pdt_08001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
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

type p_delrow from w_inherite`p_delrow within w_pdt_08001
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_08001
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_08001
boolean visible = false
integer x = 3749
boolean enabled = false
string picturename = "C:\ERPMAN\image\발주선택_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\ERPMAN\image\발주선택_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\ERPMAN\image\발주선택_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pdt_08001
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_08001
end type

type p_can from w_inherite`p_can within w_pdt_08001
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If



end event

type p_print from w_inherite`p_print within w_pdt_08001
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_08001
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string s_frdept, s_todept, s_frdate, s_todate, s_empno
String	ls_saupj, ls_baljpno

if dw_1.AcceptText() = -1 then return 

s_frdate		= trim(dw_1.GetItemString(1,'frdate'))  //의뢰일자 from
s_todate		= trim(dw_1.GetItemString(1,'todate'))  //의뢰일자 to
s_frdept		= trim(dw_1.GetItemString(1,'frdept'))  //의뢰부서 from
s_todept		= trim(dw_1.GetItemString(1,'todept'))  //의뢰부서 to
s_empno 		= dw_1.GetItemString(1,'sempno') //구매담당자
ls_saupj		= dw_1.GetItemString(1,'saupj')    //사업장
ls_baljpno	= dw_1.GetItemString(1,'baljpno')    //발주번호

if 	isnull(s_empno) or s_empno = "" then
	f_message_chk(30,'[외주담당자]')
	dw_1.Setcolumn('sempno')
	dw_1.SetFocus()
	return
end if	

if 	isnull(s_frdept) or s_frdept = "" then s_frdept = '.'
if 	isnull(s_todept) or s_todept = "" then s_todept = 'zzzzzz'
if 	isnull(s_frdate) or s_frdate = "" then s_frdate = '10000101'
if 	isnull(s_todate) or s_todate = "" then s_todate = '99991231'
if 	isnull(ls_baljpno) or ls_baljpno = "" then ls_baljpno = '%'

if 	dw_insert.Retrieve(gs_sabu, ls_saupj, s_frdate, s_todate, &
							 s_frdept, s_todept, s_empno+'%', ls_baljpno) <= 0 then 
	f_message_chk(50,'[발주확정내역]')
	dw_1.SetFocus()
	ib_any_typing = FALSE
	Return 
end if

dw_insert.SetFocus()

ib_any_typing = FALSE

//규격,재질 
If 	f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If

end event

type p_del from w_inherite`p_del within w_pdt_08001
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_08001
integer x = 4096
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
			  "BALSEQ"    = 0
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
				  "CANDAT",                       "CALSEQ",      "CANQTY",        "CANCNV" )  
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
				 TO_CHAR(SYSDATE, 'YYYYMMDD'),	 :dseq,         A.BALQTY,        A.CNVQTY 
		  FROM POBLKT A, POMAST B
		 WHERE A.SABU 		= :gs_sabu
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
//p_can.triggerevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdt_08001
integer x = 3529
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_pdt_08001
integer x = 2825
integer y = 5000
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_pdt_08001
integer x = 539
integer y = 2472
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_08001
integer x = 1143
integer y = 2392
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_08001
integer x = 2482
integer y = 5000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_pdt_08001
integer x = 987
integer y = 5000
integer width = 402
integer height = 5000
boolean enabled = false
string text = "거래처등록"
end type

type st_1 from w_inherite`st_1 within w_pdt_08001
end type

type cb_can from w_inherite`cb_can within w_pdt_08001
integer x = 3177
integer y = 5000
integer taborder = 70
end type

type cb_search from w_inherite`cb_search within w_pdt_08001
integer x = 3282
integer y = 24
integer width = 402
integer height = 152
integer taborder = 40
boolean enabled = false
string text = "발주선택"
end type





type gb_10 from w_inherite`gb_10 within w_pdt_08001
integer y = 5000
integer height = 5000
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_08001
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_08001
end type

type dw_1 from datawindow within w_pdt_08001
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 44
integer width = 3232
integer height = 212
integer taborder = 10
string dataobject = "d_pdt_08001_a"
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
elseif this.getcolumnname() = 'saupj' then 
	s_date = this.gettext()
	f_child_saupj(this, 'sempno', s_date)
END IF	
end event

event itemerror;return 1
end event

event rbuttondown;String 	sGubun

setnull(gs_code)
setnull(gs_codename)

Choose Case 	this.GetColumnName()
	Case 	"frdept" 
		gs_gubun ='1'
		Open(w_vndmst_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
	
		this.SetItem(1, "frdept", gs_Code)
	Case 	"todept" 
		gs_gubun ='1'
		Open(w_vndmst_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
	
		this.SetItem(1, "todept", gs_Code)
	Case 	"baljpno" 
		gs_gubun = '1' //발주지시상태 => 1:의뢰
		gs_code  = '3' //발주구분 => 외주
		open(w_poblkt_popup)
		
		IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN
		
	  SELECT "POMAST"."BALGU" , "POMAST"."BAL_EMPNO" 
		 INTO :sGubun  , :gs_gubun
		 FROM "POMAST"  
		WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
				( "POMAST"."BALJPNO" = :gs_code )   ;
	
		IF SQLCA.SQLCODE <> 0 Then
			IF gs_code ="" OR IsNull(gs_code) THEN
				wf_reset()
			END IF
			RETURN 1
		ElseIF sGubun <> '3' Then
			Messagebox("발주번호", "외주발주내역이 아닙니다", stopsign!)
			RETURN 1			
		end if
	     dw_1.SetItem(1, "baljpno" 	, gs_code)
	     dw_1.SetItem(1, "sempno" 	, gs_gubun)
		  
END Choose	
end event

type cbx_1 from checkbox within w_pdt_08001
integer x = 3278
integer y = 184
integer width = 517
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;long ll_count, lCount
string ls_status

if this.checked = true then
	ls_status='Y'
	this.text = '전체해제'
else
	ls_status='N'
	this.text = '전체선택'
end if

SetPointer(HourGlass!)

lCount = dw_insert.rowcount() 

for ll_count=1 to lCount
	dw_insert.setitem(ll_count, 'cnfm', ls_status)
next

end event

type pb_1 from u_pb_cal within w_pdt_08001
integer x = 1838
integer y = 140
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('frdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'frdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_08001
integer x = 2263
integer y = 140
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('todate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'todate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_08001
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 264
integer width = 4585
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

