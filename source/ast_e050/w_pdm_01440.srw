$PBExportHeader$w_pdm_01440.srw
$PBExportComments$** 표준공정 등록
forward
global type w_pdm_01440 from w_inherite
end type
type dw_list from u_d_popup_sort within w_pdm_01440
end type
type dw_desc from datawindow within w_pdm_01440
end type
type p_1 from uo_picture within w_pdm_01440
end type
type p_2 from uo_picture within w_pdm_01440
end type
type p_3 from picture within w_pdm_01440
end type
type cb_1 from commandbutton within w_pdm_01440
end type
type dw_mch from datawindow within w_pdm_01440
end type
type rr_1 from roundrectangle within w_pdm_01440
end type
type rr_2 from roundrectangle within w_pdm_01440
end type
end forward

global type w_pdm_01440 from w_inherite
integer width = 4699
integer height = 2596
string title = "표준공정 관리"
dw_list dw_list
dw_desc dw_desc
p_1 p_1
p_2 p_2
p_3 p_3
cb_1 cb_1
dw_mch dw_mch
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01440 w_pdm_01440

type variables
char  ic_Status

// 자료변경여부 검사
string     is_key1, is_key2, is_pitem

end variables

forward prototypes
public function integer wf_confirm_key ()
public function integer wf_gubun (string lastgubun)
public subroutine wf_taborder ()
public subroutine wf_taborderzero ()
public function integer wf_delete_chk (string sitnbr, string sopseq)
public subroutine wf_initial ()
public function integer wf_check_column ()
public subroutine wf_query ()
public function integer wf_required_chk ()
public function integer wf_setting_order (string arg_itnbr, string arg_opseq)
end prototypes

public function integer wf_confirm_key ();/*=====================================================================
		1.	등록 mode : Key 검색
		2. 사용순서 중복여부 확인
		2. Argument : None
		3.	Return Value
			( -1 ) : 등록된 코드 
			(  1 ) : 신  규 코드
=====================================================================*/
string	sConfirm
int		iCount			

is_Key1 = dw_insert.GetItemString(1, "itnbr")
is_Key2 = dw_insert.GetItemString(1, "opseq")


  SELECT "ITNBR"  
    INTO :sConfirm  
    FROM "ROUTNG"  
   WHERE ( "ITNBR" = :is_key1 ) AND  
         ( "OPSEQ" = :is_key2 )   ;

			
IF sqlca.sqlcode = 0 	then	

	messagebox("확인","등록된 코드입니다.~r등록할 수 없습니다.", 		&
						stopsign!)
	dw_insert.setcolumn('itnbr')
	dw_insert.SetFocus()
	RETURN  -1 

END IF



RETURN  1


end function

public function integer wf_gubun (string lastgubun);		
int		iCount
string	sItem, sSeq
sItem = dw_insert.GetItemString(1, "itnbr")
sSeq = dw_insert.GetItemString(1, "opseq")



SELECT COUNT(*)
  INTO :iCount
  FROM "ROUTNG"
 WHERE "ITNBR" = :sItem	and
		 "OPSEQ" <> :sSeq	and
		 "LASTC" = :LastGubun ;
				
IF iCount > 0		THEN

	CHOOSE CASE LastGubun
	CASE '1'
			MessageBox("확인", "최초공정이 등록되어 있습니다.")
	CASE '3'
			MessageBox("확인", "최종공정이 등록되어 있습니다.")
	CASE '9'
			MessageBox("확인", "최초/최종공정이 등록되어 있습니다.")
	END CHOOSE

	RETURN -1
	
END IF

RETURN 1		
end function

public subroutine wf_taborder ();dw_insert.SetTabOrder('itnbr', 10)
dw_insert.SetTabOrder('itemas_itdsc', 20)
dw_insert.SetTabOrder('itemas_ispec', 30)
dw_insert.SetTabOrder('itemas_jijil', 40)
dw_insert.SetTabOrder('itemas_ispec_code', 50)
dw_insert.SetColumn('itnbr')



end subroutine

public subroutine wf_taborderzero ();
dw_insert.SetTabOrder('itnbr', 0)
dw_insert.SetTabOrder('itemas_itdsc', 0)
dw_insert.SetTabOrder('itemas_ispec', 0)
dw_insert.SetTabOrder('itemas_jijil', 0)
dw_insert.SetTabOrder('itemas_ispec_code', 0)

end subroutine

public function integer wf_delete_chk (string sitnbr, string sopseq);long  l_cnt

SELECT COUNT(*)
  INTO :l_cnt
  FROM "PSTRUC"  
 WHERE ( "PSTRUC"."PINBR" = :sItnbr ) AND ( "PSTRUC"."OPSNO" = :sOpseq )   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[생산BOM]')
	return -1
end if

SELECT COUNT(*)
  INTO :l_cnt
  FROM MOMAST, MOROUT  
 WHERE ( MOMAST.SABU = MOROUT.SABU) and  
       ( MOMAST.PORDNO = MOROUT.PORDNO)  and  
       ( ( MOMAST.STDITNBR = :sItnbr ) AND  
       ( MOROUT.OPSEQ = :sOpseq ) )   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[작업지시]')
	return -1
end if

return 1
end function

public subroutine wf_initial ();	ib_any_typing = false


string	sName, sItem, sWorkPlace
sItem = dw_insert.GetItemString(1, "itnbr")
sName	= dw_insert.GetItemString(1, "itemas_itdsc")
sWorkPlace = dw_insert.getitemstring(1, "wkctr")

p_can.TriggerEvent("clicked")

dw_insert.SetItem(1, "itnbr", sitem)
dw_insert.SetItem(1, "itemas_itdsc", sName)

dw_list.Retrieve(sitem)

dw_desc.Reset()
dw_desc.Insertrow(0)
dw_desc.SetItem(1, "itnbr", sitem)

dw_insert.SetColumn("opseq")
dw_insert.SetFocus()

// 작업공정수 계산
f_WorkCount(sWorkPlace)
end subroutine

public function integer wf_check_column ();
///////////////////////////////////////////////////////////////////////
real 	rQty

rQty = dw_insert.GetItemNumber(1, "UNITQ")
IF IsNull(rQty)  or  rQty <=0		THEN	
	MessageBox("확인", "단위수량을 입력하세요.")
	dw_insert.SetColumn("UNITQ")
	dw_insert.SetFocus()
	RETURN -1
END IF


///////////////////////////////////////////////////////////////////////

string 	sLastGubun
sLastGubun = dw_insert.GetItemString(1, "lastc")

CHOOSE CASE sLastGubun
		
	CASE '1'				// 최초공정
		
		IF wf_Gubun('1') = -1	THEN	RETURN -1
		IF wf_Gubun('9') = -1	THEN	RETURN -1		
		
	CASE '3'				// 최종공정		
		
		IF wf_Gubun('3') = -1	THEN	RETURN -1
		IF wf_Gubun('9') = -1	THEN	RETURN -1		
		
	CASE '9'				// 최초/최종공정		
		
		IF wf_Gubun('1') = -1	THEN	RETURN -1
		IF wf_Gubun('3') = -1	THEN	RETURN -1
		IF wf_Gubun('9') = -1	THEN	RETURN -1		

END CHOOSE

RETURN 1
end function

public subroutine wf_query ();
w_mdi_frame.sle_msg.text = "조회"
ic_Status = '2'

wf_TabOrderZero()

dw_insert.SetFocus()
	
p_ins.enabled = false						
p_del.enabled = true

p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_del.PictureName = 'C:\erpman\image\삭제_up.gif'





end subroutine

public function integer wf_required_chk ();if isnull(dw_insert.GetItemString(1,'itnbr')) or &
	dw_insert.GetItemString(1,'itnbr') = "" then
	f_message_chk(1400,'[품번]')
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'opseq')) or &
	dw_insert.GetItemString(1,'opseq') = "" then
	f_message_chk(1400,'[공정순서]')
	dw_insert.SetColumn('opseq')
	dw_insert.SetFocus()
	return -1
end if			

//if isnull(dw_insert.GetItemString(1,'roslt')) or &
//	dw_insert.GetItemString(1,'roslt') = "" then
//	f_message_chk(1400,'[공정코드]')
//	dw_insert.SetColumn('roslt')
//	dw_insert.SetFocus()
//	return -1
//end if			

if isnull(dw_insert.GetItemString(1,'opdsc')) or &
	dw_insert.GetItemString(1,'opdsc') = "" then
	f_message_chk(1400,'[공정명]')
	dw_insert.SetColumn('opdsc')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'wkctr')) or &
	dw_insert.GetItemString(1,'wkctr') = "" then
	f_message_chk(1400,'[작업장]')
	dw_insert.SetColumn('wkctr')
	dw_insert.SetFocus()
	return -1
end if	

//if isnull(dw_insert.GetItemString(1,'rcode')) or &
//	dw_insert.GetItemString(1,'rcode') = "" then
//	f_message_chk(1400,'[설비]')
//	dw_insert.SetColumn('rcode')
//	dw_insert.SetFocus()
//	return -1
//end if	

return 1
end function

public function integer wf_setting_order (string arg_itnbr, string arg_opseq);Long i, ll_row
String ls_itnbr , ls_opseq ,ls_min ,ls_max, sIttyp, sQcgub

ls_itnbr = arg_itnbr
ls_opseq = arg_opseq

SELECT COUNT(*) INTO :ll_row FROM ROUTNG
WHERE  ITNBR = :ls_itnbr   ;

//SELECT ITTYP INTO :sIttyp FROM ITEMAS WHERE ITNBR = :ls_itnbr;
//If sIttyp = '1' Then
//	sQcgub = '2'
//Else
//	sQcgub = '1'
//End If

/* 완제품이면서 최종공정일 경우 품질검사로 지정 */

if ll_row < 1 then
	return 1
elseif ll_row = 1 then
   SELECT OPSEQ INTO :ls_min FROM ROUTNG
	 WHERE ITNBR = :ls_itnbr ;
	
	UPDATE ROUTNG 
	   SET LASTC = '9'
	 WHERE ITNBR = :ls_itnbr  AND OPSEQ = :ls_min ;	

else
	SELECT MIN(OPSEQ) ,MAX(OPSEQ) INTO :ls_min , :ls_max FROM ROUTNG
	 WHERE ITNBR = :ls_itnbr ;
   
	UPDATE ROUTNG
	   SET LASTC = '1'
	 WHERE ITNBR = :ls_itnbr  AND OPSEQ = :ls_min ;	
	 
	UPDATE ROUTNG
	   SET LASTC = '3'
	 WHERE ITNBR = :ls_itnbr  AND OPSEQ = :ls_max ;	 
   
	UPDATE ROUTNG
	   SET LASTC = '0'
	 WHERE ITNBR = :ls_itnbr  AND OPSEQ <> :ls_max  AND OPSEQ <> :ls_min ;	 

end if

COMMIT;

return 1
end function

on w_pdm_01440.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_desc=create dw_desc
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.cb_1=create cb_1
this.dw_mch=create dw_mch
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_desc
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.p_2
this.Control[iCurrent+5]=this.p_3
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_mch
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_pdm_01440.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_desc)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.cb_1)
destroy(this.dw_mch)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_insert.settransobject(sqlca)

// 등록
p_ins.TriggerEvent("clicked")

IF gs_gubun = 'ATTENTION' AND gs_code > '.' THEN 
	string sitdsc, sispec, sjijil, sispec_code

   SELECT ITDSC,   ISPEC,   JIJIL,   ISPEC_CODE
	  INTO :sitdsc, :sispec, :sjijil, :sispec_code
	  FROM ITEMAS
	 WHERE ITNBR = :gs_code ;

   if sqlca.sqlcode = 0 then 
		dw_insert.setitem(1, "itnbr", gs_code)	
		dw_insert.setitem(1, "itemas_itdsc", sitdsc)	
		dw_insert.setitem(1, "itemas_ispec", sispec)
		dw_insert.setitem(1, "itemas_jijil", sjijil)
		dw_insert.setItem(1, "itemas_ispec_code", sispec_code)
		dw_list.Retrieve(gs_code)
	END IF
	gs_gubun = ''
	gs_code  = ''
END IF

dw_desc.SetTransObject(SQLCA)
dw_desc.Reset()
dw_desc.Insertrow(0)
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()
//	Case KeyW!
//		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyT!
		p_ins.TriggerEvent(Clicked!)
//	Case KeyA!
//		p_addrow.TriggerEvent(Clicked!)
//	Case KeyE!
//		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose

end event

type dw_insert from w_inherite`dw_insert within w_pdm_01440
integer x = 87
integer y = 164
integer width = 3410
integer height = 1176
integer taborder = 10
string dataobject = "d_pdm_01440_1"
boolean border = false
end type

event dw_insert::itemchanged;w_mdi_frame.sle_msg.text = ''

string	sNull, sOpseq, s_ispec, s_itdsc, s_jijil, s_ispec_code, sroslt, sname, sitem, sname2, sItnbr
integer  ireturn 

SetNull(sNull)

IF this.GetColumnName() = "itnbr"	THEN
	
	is_pItem = this.GetText()
	
	IF is_PItem = ''	or		IsNull(is_PItem)	THEN	
		this.SetItem(1, "itemas_itdsc", snull)
		this.SetItem(1, "itemas_ispec", snull)
		this.SetItem(1, "itemas_jijil", snull)
		this.SetItem(1, "itemas_ispec_code", snull)
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 
   END IF

	ireturn = f_get_name4('품번', 'Y', is_pitem, s_itdsc, s_ispec, s_jijil, s_ispec_code )    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", is_pitem)	
	this.setitem(1, "itemas_itdsc", s_itdsc)	
	this.setitem(1, "itemas_ispec", s_ispec)
	this.setitem(1, "itemas_jijil", s_jijil)
   this.setItem(1, "itemas_ispec_code", s_ispec_code)
	
	String ls_yn
	SELECT USEYN
	  INTO :ls_yn
	  FROM ITEMAS
	 WHERE SABU  = :gs_sabu
	   AND ITNBR = :is_pItem ;
	This.SetItem(1, 'itemas_useyn', ls_yn)
	
	IF ireturn <> 0		THEN  //0 성공 
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 1
	END IF
	
	//금형번호 
	String ls_kumno,ls_tot_kumno

	DECLARE KUMNO CURSOR FOR  
	SELECT DISTINCT( kumno)
	  FROM KUMMST
	 WHERE SABU = :gs_sabu
	   AND model_nm = :is_pitem;
		
	OPEN KUMNO;
	DO WHILE TRUE
	FETCH KUMNO INTO :ls_kumno;
	if sqlca.sqlcode <> 0 then EXIT
	
	ls_tot_kumno = ls_tot_kumno +','+ls_kumno
	
	LOOP
	CLOSE KUMNO;
	
	if ls_tot_kumno <> '' then
	    ls_tot_kumno = right(ls_tot_kumno, len(ls_tot_kumno)-1)
	end if
	
	This.SetItem(1, 'kumno', ls_tot_kumno)
	
	dw_list.Retrieve(is_PItem)
	
ELSEIF	this.getcolumnname() = "itemas_itdsc"	THEN		// 품명 확인
	s_Itdsc = THIS.GETTEXT()								
	
	IF ISNULL(s_Itdsc) or s_Itdsc = ''	THEN 
      setnull(is_pitem)
		this.setitem(1,"itnbr", sNull)
		this.Setitem(1,"itemas_ispec", sNull)
		this.setitem(1,"itemas_jijil", sNull)
		this.setitem(1,"itemas_ispec_code", sNull)
		
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 
   END IF

	ireturn = f_get_name4('품명', 'Y', is_pitem, s_itdsc, s_ispec, s_jijil , s_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", is_pitem)	
	this.setitem(1, "itemas_itdsc", s_itdsc)	
	this.setitem(1, "itemas_ispec", s_ispec)
	this.setitem(1, "itemas_jijil", s_jijil)
	this.setitem(1, "itemas_ispec_code" , s_ispec_code )

	IF ireturn <> 0	THEN
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 1
	END IF
	dw_list.Retrieve(is_PItem)

ELSEIF	this.getcolumnname() = "itemas_ispec"	THEN		// 규격 확인
	s_Ispec = THIS.GETTEXT()								
	
	IF ISNULL(s_Ispec) or s_Ispec = ''	THEN 
      setnull(is_pitem)
		this.setitem(1,"itemas_itdsc", sNull)
		this.Setitem(1,"itnbr", sNull)
		this.setitem(1,"itemas_jijil", sNull)
		this.setitem(1,"itemas_ispec_code", sNull)
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 
   END IF

	ireturn = f_get_name4('규격', 'Y', is_pitem, s_itdsc, s_ispec, s_jijil , s_ispec_code )    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", is_pitem)	
	this.setitem(1, "itemas_itdsc", s_itdsc)	
	this.setitem(1, "itemas_ispec", s_ispec)
   this.setitem(1, "itemas_jijil", s_jijil)
	this.setitem(1, "itemas_ispec_code", s_ispec_code )
		
		
	IF ireturn <> 0		THEN
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 1
	END IF
	dw_list.Retrieve(is_PItem)

ELSEIF	this.getcolumnname() = "itemas_jijil"	THEN		
	s_jijil = THIS.GETTEXT()								
	
	IF ISNULL(s_jijil) or s_jijil = ''	THEN 
      setnull(is_pitem)
		this.setitem(1,"itemas_itdsc", sNull)
		this.Setitem(1,"itnbr", sNull)
		this.setitem(1,"itemas_ispec", sNull)
		this.setitem(1,"itemas_ispec_code", sNull)
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 
   END IF

	ireturn = f_get_name4('재질', 'Y', is_pitem, s_itdsc, s_ispec, s_jijil , s_ispec_code )    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", is_pitem)	
	this.setitem(1, "itemas_itdsc", s_itdsc)	
	this.setitem(1, "itemas_ispec", s_ispec)
   this.setitem(1, "itemas_jijil", s_jijil)
	this.setitem(1, "itemas_ispec_code", s_ispec_code )
	
	
	IF ireturn <> 0		THEN
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 1
	END IF
	dw_list.Retrieve(is_PItem)

ELSEIF	this.getcolumnname() = "itemas_ispec_code"	THEN		
	s_ispec_code = THIS.GETTEXT()								
	
	IF ISNULL(s_ispec_code) or s_ispec_code = ''	THEN 
      setnull(is_pitem)
		this.setitem(1,"itemas_itdsc", sNull)
		this.Setitem(1,"itnbr", sNull)
		this.setitem(1,"itemas_jijil", sNull)
		this.setitem(1,"itemas_ispec", sNull)
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 
   END IF

	ireturn = f_get_name4('규격코드', 'Y', is_pitem, s_itdsc, s_ispec, s_jijil, s_ispec_code)
	this.setitem(1, "itnbr", is_pitem)	
	this.setitem(1, "itemas_itdsc", s_itdsc)	
	this.setitem(1, "itemas_ispec", s_ispec)
   this.setitem(1, "itemas_jijil", s_jijil)
	this.setitem(1, "itemas_ispec_code", s_ispec_code )

	IF ireturn <> 0		THEN
		dw_desc.Reset()
		dw_desc.Insertrow(0)
		dw_list.reset()
		RETURN 1
	END IF
	dw_list.Retrieve(is_PItem)

ELSEIF this.GetColumnName() ="opseq" THEN
	sOpseq = this.GetText()
	
	IF Len(sOpseq) <> 4 THEN
		Messagebox("확 인","공정번호는 4자리여야 합니다.")
		this.setitem(1, "opseq", sNull)	
		Return 1
	END IF
	
	IF Not IsNumber(sOpseq) THEN
		Messagebox("확 인","공정번호는 숫자만 입력할 수 있습니다.")
		this.setitem(1, "opseq", sNull)	
		Return 1
	END IF
	IF sOpseq < '0005' THEN
		Messagebox("확 인","공정번호는 0005 보다 적을 수 없습니다.")
		this.setitem(1, "opseq", sNull)	
		Return 1
	END IF
ELSEIF this.GetColumnName() ="roslt" THEN
	sroslt = this.GetText()
	
	SELECT "REFFPF"."RFNA1"  
	  INTO :sname  
     FROM "REFFPF"  
    WHERE ( "REFFPF"."SABU" = '1' ) AND  
          ( "REFFPF"."RFCOD" = '21' ) AND  
          ( "REFFPF"."RFGUB" = :sroslt )   ;

	IF SQLCA.SQLCODE <> 0 THEN
	   this.SetItem(1,"opdsc",sNull)
	ELSE	
		this.SetItem(1,"opdsc", left(sname, 20))
 	END IF
ELSEIF this.GetColumnName() = "unitq" THEN
	Double lunitq
	
	lunitq = Double(this.GetText())
	
	IF lunitq <=0 THEN
		MessageBox("확 인","단위수량은 0 보다 커야 합니다.!!")
		this.setitem(1, "unitq", sNull)	
		Return 1
	END IF
ELSEIF this.GetColumnName() = "routng_tbcqt" THEN
	Double ltbcqty
	
	ltbcqty = Double(this.GetText())
	
	IF ltbcqty <=0 THEN
		MessageBox("확 인","시간기준수량은 0 보다 커야 합니다.!!")
		this.setitem(1, "routng_tbcqt", sNull)	
		Return 1
	END IF
ELSEIF this.GetColumnName() = "wkctr"	THEN
	
	string	sCode
	sCode = this.GetText()
	
	SELECT "WCDSC"
		INTO :sName
   	FROM "WRKCTR"  
	   WHERE ( "WKCTR" = :sCode )   ;
	IF sqlca.sqlcode <> 0		THEN
		messagebox("확인", "등록된 작업장이 아닙니다." )
		this.setitem(1, "wkctr", sNull)	
		RETURN 1
	END IF
	this.SetItem(1, "wrkctr_wcdsc", sName)
ELSEIF this.getcolumnname() = 'routng_twocod' then

	sCode = this.GetText()
	if isnull(sCode) or trim(sCode) = '' then return

	sItem  = this.getitemstring(1, "itnbr")
	sName2 = this.getitemstring(1, "opseq")
	
	 SELECT twocod
		INTO :sName
   	FROM routng
	   WHERE itnbr = :sItem and opseq = :sCode;
	IF sqlca.sqlcode <> 0 Then
		messagebox("확인", "등록된 공정이 아닙니다." )
		this.setitem(1, "routng_twocod", sNull)	
		RETURN 1
	END IF
	
	If isnull(sName) or Trim(sName) = '' then
	else
		messagebox("확인", "해당공정은 동시공정입니다." )
		this.setitem(1, "routng_twocod", sNull)	
		RETURN 1		
	end if
	
	If sName2 = sCode then
		messagebox("확인", "표준공정과 동시공정이 동일합니다." )
		this.setitem(1, "routng_twocod", sNull)	
		RETURN 1		
	end if	
	
ELSEIF this.getcolumnname() = 'lastc' then

	sCode = this.GetText()
	
	if sCode <> '0' then 
		this.setitem(1, 'routng_twocod', sNull)
	end if
/* 설비 2003.07.07 ljj */
elseif this.getcolumnname() = "rcode" then
	ireturn = 0
	sitem = Trim(gettext())
	
	sItnbr	= Trim(GetItemString(1, 'itnbr'))
	sOpseq	= Trim(GetItemString(1, 'opseq'))

	If IsNull(sItnbr) Or sItnbr = '' Or IsNull(sOpseq) Or sOpseq = '' Then
		MessageBox('확 인', '품번이나 공정코드를 확인하세요')
		Return 2
	End If
	
	If GetItemNumber(1, 'rcode_cnt') > 1 Then
		MessageBox('확인','설비가 1대이상입니다. 오른쪽 마우스 버튼을 사용하세요')
		Return 2
	/* 등록된 설비가 없거나 1개인 경우 */
	Else
		if isnull(sitem) or trim(sitem) = '' then
			this.setitem(1, "rname", snull)
			
			return
		end if
	
		select mchnam		  into :sname		  from mchmst
		 where sabu = :gs_sabu and mchno = :sitem;
		if sqlca.sqlcode <> 0 then
			f_message_chk(92,'[설비]')
			setnull(sitem)
			setnull(sname)
			ireturn = 1
		end if
		this.setitem(1, "rcode",  sitem)
		this.setitem(1, "rname", sname)
		return ireturn
	End If
ElseIF this.GetColumnName() = "wai_itnbr"	THEN
	
	is_pItem = Trim(GetText())
	
	IF is_PItem = ''	or		IsNull(is_PItem)	THEN	
		RETURN 
   END IF

	ireturn = f_get_name4('품번', 'Y', is_pitem, s_itdsc, s_ispec, s_jijil, s_ispec_code )    //1이면 실패, 0이 성공	
	this.setitem(1, "wai_itnbr", is_pitem)	

	IF ireturn <> 0		THEN  //0 성공 
		RETURN 1
	END IF
ElseIF this.GetColumnName() = "mchr"	THEN
	SetItem(1, 'routng_mchr1', Dec(GetText()))
ElseIF this.GetColumnName() = "pop"	THEN
//	messagebox('',gettext())
	If GetText() = 'Y' Then
		SetItem(1, 'routng_stdmn', 1)
	Else
		SetItem(1, 'routng_stdmn', 0)
	End If
END IF


end event

event dw_insert::itemerror;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column 이 아닌 Column 에서 Error 발생시 

//IF ib_ItemError = true	THEN	
//	ib_ItemError = false		
//	RETURN 1
//END IF
//


//	2) Required Column  에서 Error 발생시 

//string	sColumnName
//sColumnName = dwo.name + "_t.text"
//
//
//sle_msg.text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."
//
RETURN 1
	
end event

event dw_insert::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(gsbom)

String sItnbr, sOpseq
Long   nCnt
Dec	 dMchr

IF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return

	this.SetItem(1, "itnbr", gs_code)

   this.triggerevent(itemchanged!)
ELSEIF this.GetColumnName() = "itemas_itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "itnbr", gs_code)

   this.triggerevent(itemchanged!)
	
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	
	this.SetItem(1, "itnbr", gs_code)
   
	this.triggerevent(itemchanged!)

ELSEIF this.GetColumnName() = "wkctr"	THEN
	
	gs_code = this.GetText()
	open(w_workplace_popup)
	
	IF Isnull(gs_Code) 	or		gs_Code = ''		THEN	RETURN

	this.SetItem(1, "wkctr", 	 gs_Code)
	this.SetItem(1, "wrkctr_wcdsc", 	 gs_CodeName)
	
ELSEIF this.GetColumnName() = "path"	THEN
	
	gs_code = this.GetText()
	open(w_pdm_01440_bmp)
	
	IF Isnull(gs_Code) 	or		gs_Code = ''		THEN	RETURN

	this.SetItem(1, "path", 	 gs_Code)
ELSEIF this.GetColumnName() = "rcode" then
	sItnbr	= Trim(GetItemString(1, 'itnbr'))
	sOpseq	= Trim(GetItemString(1, 'opseq'))

	If IsNull(sItnbr) Or sItnbr = '' Or IsNull(sOpseq) Or sOpseq = '' Then
		MessageBox('확 인', '품번이나 공정코드를 확인하세요')
		Return 2
	End If
	
	If GetItemNumber(1, 'rcode_cnt') > 1 Then
		MessageBox('확 인', '설비대수가 1개 이상입니다. 추가버튼을 사용하세요.')
//		gs_gubun  = sItnbr
//		gs_code	 = sOpseq
//		gs_codename = Trim(GetItemString(1, 'opseq'))
//		open(w_pdm_01440_resource)
//				
//		/* 표준시간 산출 */
//		SELECT COUNT(*) , AVG(RESHR) INTO :dMchr, :nCnt FROM ROUTNG_RESOURCE WHERE ITNBR = :sItnbr AND OPSEQ = :sOpseq;
//		this.setitem(1, "rcode_cnt", ncnt)
//		this.setitem(1, "mchr", dMchr)
//		
	/* 등록된 설비가 없을 경우 */
	Else
		gs_gubun    = this.getitemstring(1, "wkctr")
//		gs_codename = this.getitemstring(1, "rname")
		open(w_mchmst_popup)
//		Open(w_st21_00020_popup)
		if isnull(gs_code) or gs_code = "" then return
	End If
	
	this.setitem(1, "rcode", gs_code)
	this.setitem(1, "rname", gs_codename)
ELSEIF this.GetColumnName() = "wai_itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return

	this.SetItem(1, "wai_itnbr", gs_code)

   this.triggerevent(itemchanged!)
END IF
end event

event dw_insert::ue_key;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itemas_itdsc", gs_codename)
		
		dw_list.Retrieve(gs_code)	
	   dw_desc.SetItem(1,"itnbr",gs_code)
		RETURN 1
	End If
END IF

end event

event dw_insert::editchanged;if ic_status = '1'   then

	ib_any_typing = true

end if

end event

event dw_insert::losefocus;this.AcceptText()
end event

event dw_insert::retrieveend;ib_any_typing = false
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF  New! = this.GetItemStatus(k, 0, Primary!) OR NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event dw_insert::clicked;call super::clicked;String ls_dwobject, sItnbr, sOpseq
Dec dMchr, nCnt

ls_dwobject = GetObjectAtPointer()

If Left(ls_dwobject,5) = 'p_add' Then
	sItnbr	= Trim(GetItemString(1, 'itnbr'))
	sOpseq	= Trim(GetItemString(1, 'opseq'))

	If IsNull(sItnbr) Or sItnbr = '' Or IsNull(sOpseq) Or sOpseq = '' Then
		MessageBox('확 인', '품번이나 공정코드를 확인하세요')
		Return 2
	End If
	
	gs_gubun  = sItnbr
	gs_code	 = sOpseq
	gs_codename = Trim(GetItemString(1, 'opdsc'))
	open(w_pdm_01440_resource)
			
	/* 표준시간 산출 */
	SELECT COUNT(*) , AVG(RESHR) INTO :nCnt, :dMchr FROM ROUTNG_RESOURCE WHERE ITNBR = :sItnbr AND OPSEQ = :sOpseq;
	this.setitem(1, "rcode_cnt", ncnt)
	this.setitem(1, "mchr", dMchr)
	this.setitem(1, "routng_mchr1", dMchr)

ElseIf ls_dwobject = 'b_wkctr' Then
	sItnbr	= Trim(GetItemString(1, 'itnbr'))
	sOpseq	= Trim(GetItemString(1, 'opseq'))

	If IsNull(sItnbr) Or sItnbr = '' Or IsNull(sOpseq) Or sOpseq = '' Then
		MessageBox('확 인', '품번이나 공정코드를 확인하세요')
		Return 2
	End If
	
	gs_gubun  = sItnbr
	gs_code	 = sOpseq
	gs_codename = Trim(GetItemString(1, 'wkctr'))
	gs_codename2 = Trim(GetItemString(1, 'wrkctr_wcdsc'))
	open(w_pdm_01440_wkctr)

ElseIf ls_dwobject = 'b_settm' Then
	sItnbr	= Trim(GetItemString(1, 'itnbr'))
	sOpseq	= Trim(GetItemString(1, 'opseq'))

	If IsNull(sItnbr) Or sItnbr = '' Or IsNull(sOpseq) Or sOpseq = '' Then
		MessageBox('확 인', '품번이나 공정코드를 확인하세요')
		Return 2
	End If
	
	gs_gubun  = sItnbr
	gs_code	 = sOpseq
	gs_codename = Trim(GetItemString(1, 'wkctr'))
	gs_codename2 = Trim(GetItemString(1, 'wrkctr_wcdsc'))
	open(w_pdm_01440_wkctr)	

End If
end event

event dw_insert::buttonclicked;call super::buttonclicked;String sItnbr, sOpseq

If row <= 0 then return

sItnbr	= Trim(GetItemString(1, 'itnbr'))
sOpseq	= Trim(GetItemString(1, 'opseq'))
If IsNull(sItnbr) Or sItnbr = '' Or IsNull(sOpseq) Or sOpseq = '' Then
	MessageBox('확 인', '품번이나 공정코드를 확인하세요')
	Return 2
End If

If dwo.name = 'b_wkctr' Then
	gs_gubun  = sItnbr
	gs_code	 = sOpseq
	gs_codename = Trim(GetItemString(1, 'wkctr'))
	gs_codename2 = Trim(GetItemString(1, 'wrkctr_wcdsc'))
	open(w_pdm_01440_wkctr)

ElseIf dwo.name = 'b_settm' Then
	gs_gubun  = sItnbr
	gs_code	 = sOpseq
	gs_codename = Trim(GetItemString(1, 'itemas_itdsc'))
	gs_codename2 = Trim(GetItemString(1, 'opdsc'))
	open(w_pdm_01440_settime)	
	If gs_gubun = 'OK' Then
		SetItem(1, 'stdst', gi_page)
	End If

ElseIf dwo.name = 'b_worktm' Then
	gs_gubun  = sItnbr
	gs_code	 = sOpseq
	gs_codename = Trim(GetItemString(1, 'itemas_itdsc'))
	gs_codename2 = Trim(GetItemString(1, 'opdsc'))
	open(w_pdm_01440_worktime)	
	If gs_gubun = 'OK' Then
		SetItem(1, 'mchr', gi_page)
	End If
	
ElseIf dwo.name = 'b_mchadd' Then
	Long		ll_ins
	ll_ins = dw_mch.insertrow(0)
	
	dw_mch.setitem(ll_ins, "routng_resource_itnbr" , sItnbr)
	dw_mch.setitem(ll_ins, "routng_resource_opseq" , sOpseq)
	dw_mch.setitem(ll_ins, "routng_resource_rcode2", '.'   )

	dw_mch.setcolumn("routng_resource_rcode")
	dw_mch.scrolltorow(ll_ins)
	dw_mch.setfocus()
	
End If
end event

event dw_insert::updateend;call super::updateend;string s_frday, s_frtime

s_frday = f_today()
	
s_frtime = f_totime()

UPDATE "PGM_HISTORY"  
      SET "UPD_DATE" = :s_frday,   
             "UPD_TIME" = :s_frtime
 WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

IF SQLCA.SQLCODE = 0 THEN 
	COMMIT;
ELSE
	ROLLBACK;
	RETURN
END IF	  
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01440
boolean visible = false
integer x = 4178
integer y = 2868
integer taborder = 120
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01440
boolean visible = false
integer x = 4005
integer y = 2868
integer taborder = 110
end type

type p_search from w_inherite`p_search within w_pdm_01440
integer x = 3099
integer y = 8
integer taborder = 80
string picturename = "C:\erpman\image\단품복사_up.gif"
end type

event p_search::clicked;call super::clicked;Open(w_pdm_01440_copy)
end event

event p_search::ue_lbuttonup;PictureName = 'C:\erpman\image\단품복사_up.gif'
end event

event p_search::ue_lbuttondown;PictureName = 'C:\erpman\image\단품복사_dn.gif'
end event

type p_ins from w_inherite`p_ins within w_pdm_01440
integer x = 3717
integer y = 8
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;
ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

///////////////////////////////////////////////
dw_insert.setredraw(false)

dw_insert.reset()
dw_insert.insertrow(0)

wf_TabOrder()

dw_insert.SetFocus()


dw_insert.setredraw(true)
///////////////////////////////////////////////


p_ins.enabled = true							
p_del.enabled = false
p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
ib_any_typing = false

dw_insert.SetTabOrder("opseq", 50)

//dw_insert.SetItem(1,"routng_uptgu",'N')
dw_insert.SetFocus()

dw_desc.Reset()
dw_desc.InsertRow(0)

dw_desc.Enabled =True

end event

type p_exit from w_inherite`p_exit within w_pdm_01440
integer x = 4411
integer y = 8
integer taborder = 130
end type

type p_can from w_inherite`p_can within w_pdm_01440
integer x = 4238
integer y = 8
integer taborder = 60
end type

event p_can::clicked;call super::clicked;
ic_status = '1'

///////////////////////////////////////////////
dw_insert.setredraw(false)

dw_insert.reset()
dw_insert.insertrow(0)

wf_TabOrder()

dw_insert.SetFocus()


dw_insert.setredraw(true)
///////////////////////////////////////////////


p_ins.enabled = true							
p_del.enabled = false

p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'

ib_any_typing = false

dw_insert.SetTabOrder("opseq", 50)
//dw_insert.SetItem(1,"routng_uptgu",'N')

dw_list.ReSet()

dw_desc.Reset()
dw_desc.InsertRow(0)

dw_mch.ReSet()

dw_desc.Enabled =True

end event

type p_print from w_inherite`p_print within w_pdm_01440
boolean visible = false
integer x = 3831
integer y = 2868
integer taborder = 140
end type

type p_inq from w_inherite`p_inq within w_pdm_01440
integer x = 3543
integer y = 8
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;ib_any_typing = false	

if dw_insert.AcceptText() = -1	then	return

string	sCode1, 		&
			sCode2
sCode1 = dw_insert.GetItemString(1, "itnbr")
sCode2 = dw_insert.GetItemString(1, "opseq")

IF IsNull(sCode1)	 or  sCode1 = ''	THEN
	MessageBox("확인", "품번을 입력하세요.")
	dw_insert.SetColumn(1)
	dw_insert.SetFocus()
	RETURN
END IF

IF IsNull(sCode2)	 or  sCode2 = ''	THEN
	MessageBox("확인", "공정순서를 입력하세요.")
	dw_insert.SetColumn('opseq')
	dw_insert.SetFocus()
	RETURN
END IF

///////////////////////////////////////////////////////

dw_insert.SetRedraw(false)

IF dw_insert.Retrieve(sCode1, sCode2) > 0		THEN

	wf_Query()
	dw_insert.SetTabOrder("opseq", 0)
	dw_insert.SetItem(1, "temp", dw_insert.GetItemString(1,"wkctr"))
		
ELSE	

	MessageBox("확인", "등록된 코드가 아닙니다.")
	dw_insert.ReSet()
	dw_insert.InsertRow(0)
	dw_insert.SetFocus()

END IF

dw_insert.SetRedraw(true)
end event

type p_del from w_inherite`p_del within w_pdm_01440
integer x = 4064
integer y = 8
integer taborder = 50
end type

event p_del::clicked;call super::clicked;string	sName, sItem, sWorkPlace, sOpseq

sItem  = dw_insert.GetItemString(1, "itnbr")
sOpseq = dw_insert.GetItemString(1, "opseq")
sName	 = dw_insert.GetItemString(1, "itemas_itdsc")
sWorkPlace = dw_insert.GetItemString(1, "wkctr")

IF dw_insert.AcceptText() = -1	THEN	RETURN

Beep (1)

wf_delete_chk(sitem, sopseq)

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", &
						         question!, yesno!, 2)  = 1		THEN

    SetPointer(HourGlass!)

    dw_insert.DeleteRow(0)

   IF dw_insert.Update() > 0	 THEN
	   // 작업공정수 계산
		if f_WorkCount(sWorkPlace) = -1 then 
			ROLLBACK USING SQLCA;
			f_rollback()
		end if	
   	COMMIT;
	ELSE
		ROLLBACK;
		f_rollback()
	END IF

END IF

p_can.TriggerEvent("clicked")

///////////////////////////////////////////////////////////
dw_insert.SetItem(1, "itnbr", sitem)
dw_insert.SetItem(1, "itemas_itdsc", sName)
dw_list.Retrieve(sitem)

dw_insert.SetColumn("opseq")
dw_insert.SetFocus()


end event

type p_mod from w_inherite`p_mod within w_pdm_01440
integer x = 3890
integer y = 8
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;String ls_itnbr, ls_opseq
Long   ll_cnt

IF dw_insert.Accepttext() = -1 THEN 	
	dw_insert.setfocus()
	RETURN
END IF

dw_mch.AcceptText()

// 등록시 PK 확인, 사용순서중복여부 확인
IF ic_status = '1'		THEN
	IF  wf_Confirm_key( ) = -1    THEN 	RETURN
END IF

if wf_required_chk() = -1 then return

// 단위수량, 공정확인
IF wf_Check_Column() = -1		THEN	RETURN

// REQUIRED FIELD 확인
//IF f_CheckRequired(dw_insert) = -1 THEN 	RETURN

IF ic_status = '2' THEN
	IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
END IF

SetPointer(HourGlass!)

// 공정구분을 자동 setting 한다. //
ls_itnbr = Trim(dw_insert.GetItemString(1,'itnbr'))
ls_opseq = Trim(dw_insert.GetItemString(1,'opseq'))

string	sWorkPlace

IF dw_insert.Update() > 0	THEN
   
	// 작업공정수 계산
	sWorkPlace = dw_insert.GetItemString(1, "wkctr")
	if f_WorkCount(sWorkPlace) = -1 then 
		ROLLBACK USING SQLCA;
		f_rollback()
	   return 
	end if	

	IF ic_Status = '2'		THEN
		sWorkPlace = dw_insert.GetItemString(1, "temp")
		if f_WorkCount(sWorkPlace) = -1 then 
			ROLLBACK USING SQLCA;
			f_rollback()
			return 
		end if	
	END IF

	SELECT COUNT('X') AS CNT
	  INTO :ll_cnt
	  FROM ERPMAN.ROUTNG_DESC
	 WHERE ITNBR = :ls_itnbr
	   AND OPSEQ = :ls_opseq;

	// 이전 이력이 있으면 따로 세팅하지 않음 '22.10.28 BY BHKIM
	if ll_cnt <= 0 then
		dw_desc.setitem(1, 'itnbr', ls_itnbr)
		dw_desc.setitem(1, 'opseq', ls_opseq)
		if dw_desc.Update() > 0 then 
			COMMIT USING sqlca;															 
		else
			ROLLBACK USING SQLCA;
			f_rollback()
			return 
		end if
	end if
/*********************************************************************************************************/	
//설비는 멀티로 등록 가능하도록 변경
	if dw_mch.Update() > 0 then 
   	COMMIT USING sqlca;															 
	else
		ROLLBACK USING SQLCA;
		f_rollback()
		return 
	end if
	
//	/* 설비정보 저장 */
//	If dw_insert.GetItemNumber(1, 'rcode_cnt') > 1 Then
//	Else
//		String sRcode, sItnbr, sOpseq
//		Dec	 dMchr
//		
//		sItnbr = dw_insert.GetItemString(1,'itnbr')
//		sOpseq = dw_insert.GetItemString(1,'opseq')
//		sRcode = dw_insert.GetItemString(1,"rcode")
//		dMchr  = dw_insert.GetItemNumber(1, 'mchr')
//		sWorkPlace = dw_insert.GetItemString(1, "wkctr")
//		
//		If IsNull(sRcode) Then
//			DELETE FROM ROUTNG_RESOURCE WHERE ITNBR = :sItnbr AND OPSEQ = :sOpseq;
//		Else
//			DELETE FROM ROUTNG_RESOURCE WHERE ITNBR = :sItnbr AND OPSEQ = :sOpseq;
//			INSERT INTO ROUTNG_RESOURCE
//				( ITNBR, OPSEQ, RCODE, GUBUN, RESHR, RCODE2 )
//				VALUES (:sItnbr, :sOpseq, :sRcode, 'M', :dMchr, :sWorkPlace);
//			If sqlca.sqlcode <> 0 Then
//				MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//				ROLLBACK;
//			Else
//				COMMIT;
//			End If
//		End If
//	End If
/***********************************************************************************************************/
	
//	if wf_setting_order(ls_itnbr ,ls_opseq) = -1 then
//		messagebox('Error','Setting Order')
//		return
//	end if
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
END IF
		
wf_Initial()


end event

type cb_exit from w_inherite`cb_exit within w_pdm_01440
integer x = 1673
integer y = 3112
integer width = 293
integer height = 104
integer textsize = -9
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01440
integer x = 768
integer y = 3112
integer width = 293
integer height = 104
integer textsize = -9
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01440
integer x = 2281
integer y = 3112
integer width = 293
integer height = 104
integer textsize = -9
end type

type cb_del from w_inherite`cb_del within w_pdm_01440
integer x = 1070
integer y = 3112
integer width = 293
integer height = 104
integer textsize = -9
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01440
integer x = 1979
integer y = 3112
integer width = 293
integer height = 104
integer textsize = -9
end type

type cb_print from w_inherite`cb_print within w_pdm_01440
integer x = 462
integer y = 3112
integer width = 293
integer height = 104
integer textsize = -9
string text = "단품삭제"
end type

type st_1 from w_inherite`st_1 within w_pdm_01440
end type

type cb_can from w_inherite`cb_can within w_pdm_01440
integer x = 1371
integer y = 3112
integer width = 293
integer height = 104
integer textsize = -9
end type

type cb_search from w_inherite`cb_search within w_pdm_01440
integer x = 160
integer y = 3112
integer width = 293
integer height = 104
integer textsize = -9
string text = "단품복사"
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01440
integer y = 2840
integer height = 140
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01440
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01440
end type

type dw_list from u_d_popup_sort within w_pdm_01440
event ue_key pbm_dwnkey
integer x = 73
integer y = 1380
integer width = 4507
integer height = 924
integer taborder = 0
string dataobject = "d_pdm_01440_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose


end event

event clicked;String sItnbr, sOpseq,sKumno
Long nCnt

IF Row <= 0    then    RETURN                                    

dw_list.selectrow(0, false)
dw_list.selectrow(Row, true)

sItnbr = dw_list.getitemstring(Row, "itnbr")
sOpseq = dw_list.getitemstring(Row, "routng_opseq")
sKumno= dw_Insert.getitemstring(Row,"kumno")

dw_insert.retrieve(dw_list.getitemstring(Row, "itnbr"), dw_list.getitemstring(Row, "routng_opseq"),dw_Insert.getitemstring(Row, "kumno")) 

/* 설비내역 */
SELECT COUNT(*) INTO :nCnt FROM ROUTNG_RESOURCE WHERE ITNBR = :sItnbr AND OPSEQ = :sOpseq;
If nCnt = 0 Then nCnt = 1
dw_insert.SetItem(1, 'rcode_cnt', ncnt)

wf_Query()

dw_desc.Enabled =True
IF dw_desc.retrieve(dw_list.getitemstring(Row, "itnbr"),&
                        dw_list.getitemstring(Row, "routng_opseq")) <=0 THEN
    dw_desc.Insertrow(0)
END IF

// 조회후 작업장코드 -> TEMP
dw_insert.SetTabOrder("opseq", 0)  
dw_insert.SetItem(1, "temp", dw_list.GetItemString(Row,"routng_wkctr"))
dw_insert.SetItem(1, "kumno", sKumno)

dw_mch.Retrieve(sItnbr, sOpseq)
end event

type dw_desc from datawindow within w_pdm_01440
event ue_enter pbm_dwnprocessenter
integer x = 3515
integer y = 176
integer width = 1051
integer height = 1156
integer taborder = 100
boolean titlebar = true
string title = "설명"
string dataobject = "d_pdm_01440_3"
boolean minbox = true
boolean maxbox = true
boolean vscrollbar = true
boolean livescroll = true
end type

event ue_enter;//Send( Handle(this), 256, 9, 0 )
//Return 1
end event

event itemfocuschanged;//Long wnd
//
//wnd =Handle(this)
//
//IF dwo.name ="rdesc" THEN
//	f_toggle_kor(wnd)
//ELSE
//	f_toggle_eng(wnd)
//END IF
end event

type p_1 from uo_picture within w_pdm_01440
integer x = 2926
integer y = 8
integer width = 178
integer taborder = 70
boolean bringtotop = true
string picturename = "C:\erpman\image\일괄복사_up.gif"
end type

event clicked;call super::clicked;Open(w_pdm_01440_allcopy)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄복사_dn.gif"
end event

event p_1::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄복사_up.gif"
end event

type p_2 from uo_picture within w_pdm_01440
integer x = 3273
integer y = 8
integer width = 178
integer taborder = 90
boolean bringtotop = true
string picturename = "C:\erpman\image\단품삭제_up.gif"
end type

event clicked;call super::clicked;Open(w_pdm_01440_delete)

p_can.TriggerEvent("clicked")






end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\단품삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\단품삭제_up.gif"
end event

type p_3 from picture within w_pdm_01440
integer x = 69
integer y = 8
integer width = 306
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\최신자료갱신_up.gif"
boolean focusrectangle = false
end type

event clicked;String ls_window_id = 'w_pdm_01450'

OpenSheet(w_pdm_01450, ls_window_id, w_mdi_frame, 0, Layered!)
end event

type cb_1 from commandbutton within w_pdm_01440
integer x = 425
integer y = 32
integer width = 288
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "이력관리"
end type

event clicked;gs_code     = dw_insert.GetItemString(1, 'itnbr')
gs_codename = dw_insert.GetItemString(1, 'itemas_itdsc')
Open(w_pdm_01440_hist)
end event

type dw_mch from datawindow within w_pdm_01440
integer x = 123
integer y = 500
integer width = 1989
integer height = 408
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01440_mch"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event buttonclicked;If row < 1 Then Return

Choose Case dwo.name
	Case 'b_del'
		If MessageBox('삭제확인', '선택 자료를 삭제 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return
		
		This.DeleteRow(row)
		
		If This.UPDATE() = 1 Then
			COMMIT USING SQLCA;
		Else
			ROLLBACK USING SQLCA;
		End If
End Choose
end event

event rbuttondown;If row < 1 Then Return

Choose Case dwo.name
	Case 'routng_resource_rcode'
		String	ls_itm
		String	ls_seq
		ls_itm = Trim(dw_insert.GetItemString(1, 'itnbr'))
		ls_seq = Trim(dw_insert.GetItemString(1, 'opseq'))
		If IsNull(ls_itm) Or ls_itm = '' Or IsNull(ls_seq) Or ls_seq = '' Then
			MessageBox('확 인', '품번이나 공정코드를 확인하세요')
			Return 2
		End If
		
		gs_gubun = ''//dw_insert.GetItemString(1, 'wkctr')
		
		Open(w_mchmst_popup)
		If IsNull(gs_code) OR gs_code = '' Then Return
		
		This.SetItem(row, 'routng_resource_rcode', gs_code    )
		This.SetItem(row, 'mchmst_mchnam'        , gs_codename)
End Choose
end event

event itemchanged;If row < 1 Then Return

String	ls_nam
Choose Case dwo.name
	Case 'routng_resource_rcode'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'mchmst_mchnam', '')
			Return 2
		End If
		
		SELECT MCHNAM
		  INTO :ls_nam
		  FROM MCHMST
		 WHERE SABU = '1' AND MCHNO = :data ;
		
		This.SetItem(row, 'mchmst_mchnam', ls_nam)
End Choose
end event

type rr_1 from roundrectangle within w_pdm_01440
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 64
integer y = 160
integer width = 4526
integer height = 1192
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01440
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 1372
integer width = 4526
integer height = 940
integer cornerheight = 40
integer cornerwidth = 55
end type

