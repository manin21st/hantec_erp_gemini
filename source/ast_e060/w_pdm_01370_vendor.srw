$PBExportHeader$w_pdm_01370_vendor.srw
$PBExportComments$** 단가마스타 등록(거래처별수정)
forward
global type w_pdm_01370_vendor from w_inherite
end type
type tab_1 from tab within w_pdm_01370_vendor
end type
type tabpage_1 from userobject within tab_1
end type
type dw_7 from u_key_enter within tabpage_1
end type
type pb_7 from u_pb_cal within tabpage_1
end type
type pb_6 from u_pb_cal within tabpage_1
end type
type pb_5 from u_pb_cal within tabpage_1
end type
type dw_2 from datawindow within tabpage_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type rr_5 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_7 dw_7
pb_7 pb_7
pb_6 pb_6
pb_5 pb_5
dw_2 dw_2
rr_1 rr_1
dw_1 dw_1
rr_5 rr_5
end type
type tabpage_2 from userobject within tab_1
end type
type st_2 from statictext within tabpage_2
end type
type p_2 from uo_picture within tabpage_2
end type
type p_1 from uo_picture within tabpage_2
end type
type dw_cust from u_key_enter within tabpage_2
end type
type dw_list from datawindow within tabpage_2
end type
type rr_2 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
st_2 st_2
p_2 p_2
p_1 p_1
dw_cust dw_cust
dw_list dw_list
rr_2 rr_2
end type
type tabpage_3 from userobject within tab_1
end type
type pb_9 from u_pb_cal within tabpage_3
end type
type pb_8 from u_pb_cal within tabpage_3
end type
type p_4 from uo_picture within tabpage_3
end type
type p_3 from uo_picture within tabpage_3
end type
type dw_hist from datawindow within tabpage_3
end type
type rr_3 from roundrectangle within tabpage_3
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
pb_9 pb_9
pb_8 pb_8
p_4 p_4
p_3 p_3
dw_hist dw_hist
rr_3 rr_3
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type p_6 from uo_picture within tabpage_4
end type
type p_5 from uo_picture within tabpage_4
end type
type dw_4 from datawindow within tabpage_4
end type
type dw_5 from datawindow within tabpage_4
end type
type dw_6 from datawindow within tabpage_4
end type
type rr_4 from roundrectangle within tabpage_4
end type
type tabpage_4 from userobject within tab_1
p_6 p_6
p_5 p_5
dw_4 dw_4
dw_5 dw_5
dw_6 dw_6
rr_4 rr_4
end type
type tabpage_5 from userobject within tab_1
end type
type p_10 from uo_picture within tabpage_5
end type
type p_9 from uo_picture within tabpage_5
end type
type p_8 from uo_picture within tabpage_5
end type
type p_7 from uo_picture within tabpage_5
end type
type dw_8 from u_key_enter within tabpage_5
end type
type rr_6 from roundrectangle within tabpage_5
end type
type tabpage_5 from userobject within tab_1
p_10 p_10
p_9 p_9
p_8 p_8
p_7 p_7
dw_8 dw_8
rr_6 rr_6
end type
type tab_1 from tab within w_pdm_01370_vendor
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type pb_1 from picturebutton within w_pdm_01370_vendor
end type
type pb_2 from picturebutton within w_pdm_01370_vendor
end type
type pb_3 from picturebutton within w_pdm_01370_vendor
end type
type pb_4 from picturebutton within w_pdm_01370_vendor
end type
end forward

global type w_pdm_01370_vendor from w_inherite
string title = "구매/외주 단가마스타 등록"
tab_1 tab_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
end type
global w_pdm_01370_vendor w_pdm_01370_vendor

type variables
char  ic_Status

string     is_key1, is_key2

str_item str_itnbr
end variables

forward prototypes
public subroutine wf_query ()
public function integer wf_update_item ()
public function integer wf_update_vendor ()
public subroutine wf_taborder ()
public subroutine wf_taborderzero ()
public function integer wf_required_chk ()
public function integer wf_confirm_key ()
public subroutine wf_scroll (integer ii_itnbr)
end prototypes

public subroutine wf_query ();
sle_msg.text = "조회"
ic_Status = '2'

wf_TabOrderZero()

tab_1.tabpage_1.dw_1.SetFocus()
	
cb_del.enabled = true






end subroutine

public function integer wf_update_item ();/////////////////////////////////////////////////////////////////////
dec		dPrice, dTemp
string	sItem, sVendor, sSeq, sToday, sgubun, sunit, ssltcd, sefrdt, seftdt, scunit

sToday = f_Today()

sItem   = tab_1.tabpage_1.dw_1.getitemstring(1, "danmst_itnbr")
sVendor = tab_1.tabpage_1.dw_1.getitemstring(1, "danmst_cvcod")
sSeq    = tab_1.tabpage_1.dw_1.getitemstring(1, "opseq")
dPrice  = tab_1.tabpage_1.dw_1.getitemdecimal(1, "danmst_unprc")
dTemp   = tab_1.tabpage_1.dw_1.getitemdecimal(1, "temp")

sgubun  = tab_1.tabpage_1.dw_1.getitemstring(1, "ins_gubun")
sunit   = tab_1.tabpage_1.dw_1.getitemstring(1, "danmst_cunit")
ssltcd  = tab_1.tabpage_1.dw_1.getitemstring(1, "danmst_sltcd")
sefrdt  = tab_1.tabpage_1.dw_1.getitemstring(1, "danmst_efrdt")
seftdt  = tab_1.tabpage_1.dw_1.getitemstring(1, "danmst_eftdt")
scunit  = tab_1.tabpage_1.dw_1.getitemstring(1, "danmst_cunit")

/* 우선거래처 'Y'이고, 단위'WON'이면, wonsrc업데이트 */
if ssltcd = 'Y' and sunit = 'WON' then
	Update itemas
	   set wonsrc = :dPrice
	 Where itnbr  = :sItem
	 Using sqlca;
	 
/* 우선거래처 'Y'이고, 단위'WON'이외 이면, forsrc업데이트 */	 
elseif ssltcd = 'Y' and sunit <> 'WON' then
	Update itemas
	   set forsrc = :dPrice
	 Where itnbr  = :sItem
	 Using sqlca; 
end if

////////////////////////////////////////////////////////////////////

IF ( dTemp <> dPrice ) and ( dTemp <> 0 )		THEN	

	IF MessageBox("확인", "단가이력을 저장하시겠습니까?", question!, yesno!) = 1	THEN
		
	  INSERT INTO "DANHST"  
				( "ITNBR", "CVCOD", "CDATE", "OPSEQ", "BAMT", "AAMT", "IDATE", "REMARK", "EDATE", "CUNIT", "GUOUT" )  
	  VALUES ( :sItem,  :sVendor,:sToday, :sSeq,   :dTemp, :dPrice,:sefrdt, null,:seftdt, :scunit, :sgubun )  ;
	
		IF SQLCA.SQLCODE <> 0	THEN
//			messagebox("저장실패", sqlca.sqlerrtext)
			UPDATE DANHST
				SET BAMT = :dTemp,
					 AAMT = :dPrice,
					 IDATE = :sefrdt,
					 EDATE = :seftdt,
					 CUNIT = :scunit
			 WHERE ITNBR = :sItem	and
					 CVCOD = :sVendor and
					 CDATE = :sToday  and
					 OPSEQ = :sSeq		;
		END IF
	END IF

END IF

RETURN 1
end function

public function integer wf_update_vendor ();//////////////////////////////////////////////////////////////////////
//
//		1. 우선거래처 유무 확인 : 우선 거래처는 1 개
//		
//////////////////////////////////////////////////////////////////////
int      icount
string   sItemFirst, is_opseq
char	   cYN

is_key1 = tab_1.tabpage_1.dw_1.GetItemstring(1, "danmst_itnbr")
is_Opseq= tab_1.tabpage_1.dw_1.GetItemString(1, "OPSEQ")
cYn = tab_1.tabpage_1.dw_1.GetItemString(1, "danmst_sltcd")

IF cYn = 'Y'		THEN

	UPDATE "DANMST"  
   	SET "SLTCD" = 'N'   
	 WHERE "DANMST"."ITNBR" = :is_key1  AND "DANMST"."OPSEQ" = :is_opseq   ;

	tab_1.tabpage_1.dw_1.SetItem(1, "danmst_sltcd", 'Y')
	
	IF sqlca.sqlcode <> 0		THEN
		ROLLBACK;
		RETURN -1
	END IF
ELSE

  SELECT Count("DANMST"."ITNBR")
    INTO :iCount  
    FROM "DANMST"  
   WHERE "DANMST"."ITNBR" = :is_Key1 AND "DANMST"."OPSEQ" = :is_opseq AND  
         "DANMST"."SLTCD" = 'Y'   ;

	IF iCount = 0	THEN
		tab_1.tabpage_1.dw_1.SetItem(1, "danmst_sltcd", 'Y')
	END IF

END IF

RETURN 1
end function

public subroutine wf_taborder ();tab_1.tabpage_1.dw_1.SetTabOrder("ins_gubun", 10)
tab_1.tabpage_1.dw_1.SetTabOrder("danmst_itnbr", 20)
tab_1.tabpage_1.dw_1.SetTabOrder("itemas_itdsc", 30)
tab_1.tabpage_1.dw_1.SetTabOrder("itemas_ispec", 40)
tab_1.tabpage_1.dw_1.SetTabOrder("itemas_jijil", 50)
tab_1.tabpage_1.dw_1.SetTabOrder("opseq", 60)
tab_1.tabpage_1.dw_1.SetTabOrder("danmst_cvcod", 70)

//Tab_1.TabPage_2.enabled = false
//Tab_1.TabPage_3.enabled = false
//
tab_1.tabpage_1.dw_1.SetColumn("danmst_itnbr")
end subroutine

public subroutine wf_taborderzero ();//tab_1.tabpage_1.dw_1.SetTabOrder("ins_gubun", 0)
tab_1.tabpage_1.dw_1.SetTabOrder("danmst_itnbr", 0)
tab_1.tabpage_1.dw_1.SetTabOrder("itemas_itdsc", 0)
tab_1.tabpage_1.dw_1.SetTabOrder("itemas_ispec", 0)
tab_1.tabpage_1.dw_1.SetTabOrder("itemas_jijil", 0)
//tab_1.tabpage_1.dw_1.SetTabOrder("itemas_ispec_code", 0)
tab_1.tabpage_1.dw_1.SetTabOrder("danmst_cvcod", 0)
tab_1.tabpage_1.dw_1.SetTabOrder("opseq", 0)

//Tab_1.TabPage_2.enabled = true
//Tab_1.TabPage_3.enabled = true
//
end subroutine

public function integer wf_required_chk ();if isnull(tab_1.tabpage_1.dw_1.GetItemString(1,'danmst_itnbr')) or &
	tab_1.tabpage_1.dw_1.GetItemString(1,'danmst_itnbr') = "" then
	f_message_chk(1400,'[품번]')
//   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn('danmst_itnbr')
	tab_1.tabpage_1.dw_1.SetFocus()
	return -1
end if	

if isnull(tab_1.tabpage_1.dw_1.GetItemString(1,'opseq')) or &
	tab_1.tabpage_1.dw_1.GetItemString(1,'opseq') = "" then
//   tab_1.SelectTab(1)
	f_message_chk(1400,'[공정순서]')
	tab_1.tabpage_1.dw_1.SetColumn('opseq')
	tab_1.tabpage_1.dw_1.SetFocus()
	return -1
end if	

if isnull(tab_1.tabpage_1.dw_1.GetItemString(1,'danmst_cvcod')) or &
	tab_1.tabpage_1.dw_1.GetItemString(1,'danmst_cvcod') = "" then
	f_message_chk(1400,'[거래처]')
//   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn('danmst_cvcod')
	tab_1.tabpage_1.dw_1.SetFocus()
	return -1
end if			

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,'danmst_unprc')) or &
	tab_1.tabpage_1.dw_1.GetItemNumber(1,'danmst_unprc') < 0 then
	f_message_chk(1400,'[계약단가]')
//   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn('danmst_unprc')
	tab_1.tabpage_1.dw_1.SetFocus()
	return -1
end if			

string s_fdate, s_tdate

s_fdate = tab_1.tabpage_1.dw_1.GetItemString(1,'danmst_efrdt')

s_tdate = tab_1.tabpage_1.dw_1.GetItemString(1,'danmst_eftdt')

if s_fdate > s_tdate then 
	f_message_chk(34,'[유효일자]')
 //  tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn('danmst_eftdt')
	tab_1.tabpage_1.dw_1.SetFocus()
	return -1
end if	

return 1
end function

public function integer wf_confirm_key ();/*============================================================================================
		1.	등록 mode : Key 검색
		2. Argument : None

		3.	Return Value
			- ( -1 ) : 등록된 코드 
			- (  1 ) : 신  규 코드
=============================================================================================*/

string	sConfirm,is_OpSeq

is_key1 = tab_1.tabpage_1.dw_1.GetItemString(1, "DANMST_ITNBR")
is_key2 = tab_1.tabpage_1.dw_1.GetItemString(1, "DANMST_CVCOD")
is_Opseq= tab_1.tabpage_1.dw_1.GetItemString(1, "OPSEQ")

IF is_Opseq ="" OR IsNull(is_Opseq) THEN
	MessageBox("확 인","입력구분이 '외주'이면 공정순서는 필수입력입니다!!")
   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn("opseq")
	tab_1.tabpage_1.dw_1.SetFocus()
	Return -1
END IF

  SELECT "DANMST"."ITNBR"
    INTO :sConfirm  
    FROM "DANMST"  
   WHERE ( "DANMST"."ITNBR" = :is_key1 ) AND  
         ( "DANMST"."CVCOD" = :is_key2 ) AND
			( "DANMST"."OPSEQ" = :is_Opseq ) ;
			
IF sqlca.sqlcode = 0 	then	

	messagebox("확인","등록된코드입니다.~r등록할 수 없습니다.", 		&
						stopsign!)

   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.setcolumn('danmst_itnbr')
	tab_1.tabpage_1.dw_1.SetFocus()

	RETURN ( -1 )

END IF

/////////////////////////////////////////////////////////////////////////
//
//		1.	우선거래처 유무 확인 : 우선 거래처는 1 개
//
//		2. 우선거래처 입력시 -> 기존 우선거래처는 일반거래처로 변경
//			일반거래처 입력시 -> 우선거래처가 없을 경우 우선거래처로 변경
//
/////////////////////////////////////////////////////////////////////////
int		iCount
char		cYn

cYn = tab_1.tabpage_1.dw_1.GetItemString(1, "danmst_sltcd")

IF cYn = 'Y'		THEN

	UPDATE "DANMST"  
   	SET "SLTCD" = 'N'  
	 WHERE "DANMST"."ITNBR" = :is_key1  AND "DANMST"."OPSEQ" = :is_opseq   ;

ELSE

  SELECT Count("DANMST"."ITNBR")
    INTO :iCount  
    FROM "DANMST"  
   WHERE "DANMST"."ITNBR" = :is_Key1 AND "DANMST"."OPSEQ" = :is_opseq AND  
         "DANMST"."SLTCD" = 'Y'   ;

	IF iCount = 0	THEN
		tab_1.tabpage_1.dw_1.SetItem(1, "danmst_sltcd", 'Y')
	END IF

END IF
RETURN  1 

end function

public subroutine wf_scroll (integer ii_itnbr);string scod, srcod, ls_ittyp

tab_1.tabpage_1.dw_1.accepttext()
tab_1.SelectTab(1)

scod = tab_1.tabpage_1.dw_1.getitemstring(1, "danmst_itnbr")

If ii_itnbr <> 1 and ii_itnbr <> 4 Then
	IF IsNull(scod)	 or  scod = ''	THEN
		MessageBox("확 인", "품번을 입력하세요.")
   	tab_1.SelectTab(1)
		tab_1.tabpage_1.dw_1.SetColumn("danmst_itnbr")
		tab_1.tabpage_1.dw_1.SetFocus()
		RETURN
	END IF
End If

Select ittyp into :ls_ittyp from itemas where itnbr = :scod;

If SQLCA.SQLCODE <> 0 Or IsNull(ls_ittyp) or ls_ittyp = ''  Then
	ls_ittyp = '1'
End If

setnull(srcod)

choose case ii_itnbr
	case 1  //First page

		Select Min(itnbr) into :srcod From itemas where ittyp = :ls_ittyp;

//		SELECT min(danmst.itnbr)
//		into :srcod
//    FROM DANMST,   
//         VNDMST,   
//         ROUTNG
//    WHERE danmst.itnbr = routng.itnbr (+)
//    and   danmst.opseq = routng.opseq (+) 
//    and   DANMST.CVCOD = VNDMST.CVCOD;
	case 2  //Prior page
				
		Select Max(itnbr) into :srcod From itemas Where itnbr < :scod and ittyp = :ls_ittyp;

//		SELECT Max(danmst.itnbr)
//		into :srcod
//    FROM DANMST,   
//         VNDMST,   
//         ROUTNG
//    WHERE danmst.itnbr = routng.itnbr (+)
//    and   danmst.opseq = routng.opseq (+) 
//    and   DANMST.CVCOD = VNDMST.CVCOD 
//		and   DANMST.itnbr < :scod;
	case 3  //Next  page
				
		Select Min(itnbr) into :srcod From itemas Where itnbr > :scod and ittyp = :ls_ittyp;

//		SELECT Min(danmst.itnbr)
//		into :srcod
//    FROM DANMST,   
//         VNDMST,   
//         ROUTNG
//    WHERE danmst.itnbr = routng.itnbr (+)
//    and   danmst.opseq = routng.opseq (+) 
//    and   DANMST.CVCOD = VNDMST.CVCOD 
//		and   DANMST.itnbr > :scod;
	case 4  //Last  page
				
		Select Max(itnbr) into :srcod From itemas where ittyp = :ls_ittyp;

//		SELECT Max(danmst.itnbr)
//		into :srcod
//    FROM DANMST,   
//         VNDMST,   
//         ROUTNG
//    WHERE danmst.itnbr = routng.itnbr (+)
//    and   danmst.opseq = routng.opseq (+) 
//    and   DANMST.CVCOD = VNDMST.CVCOD;
End choose

If sqlca.sqlcode <> 0 or IsNull(srcod)  Then
	MessageBox("확 인", "자료의 끝입니다.")
	tab_1.tabpage_1.dw_1.SetColumn("danmst_itnbr")
	tab_1.tabpage_1.dw_1.SetFocus()
Else
	tab_1.tabpage_1.dw_1.setitem(1, "danmst_itnbr", srcod)
	tab_1.tabpage_1.dw_1.triggerevent(itemchanged!)
End If

end subroutine

on w_pdm_01370_vendor.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_4
end on

on w_pdm_01370_vendor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
end on

event open;call super::open;
tab_1.tabpage_1.dw_1.settransobject(sqlca)
tab_1.tabpage_1.dw_2.settransobject(sqlca)
tab_1.tabpage_1.dw_7.settransobject(sqlca)

tab_1.tabpage_2.dw_list.settransobject(sqlca)
tab_1.tabpage_2.dw_cust.settransobject(sqlca)
tab_1.tabpage_2.dw_cust.InsertRow(0)

tab_1.tabpage_3.dw_hist.settransobject(sqlca)
tab_1.tabpage_3.dw_3.settransobject(sqlca)
tab_1.tabpage_3.dw_3.insertrow(0)

tab_1.tabpage_4.dw_4.settransobject(sqlca)
tab_1.tabpage_4.dw_5.settransobject(sqlca)
tab_1.tabpage_4.dw_6.settransobject(sqlca)

tab_1.tabpage_5.dw_8.settransobject(sqlca)

f_child_saupj(tab_1.tabpage_1.dw_1, 'vndmst_emp_id', gs_saupj)

// 등록
p_ins.TriggerEvent("clicked")
//tab_1.tabpage_1.dw_1.setitem(1, 'danmst_efrdt', f_today())


end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		tab_1.tabpage_1.dw_2.scrollpriorpage()
	case keypagedown!
		tab_1.tabpage_1.dw_2.scrollnextpage()
	case keyhome!
		tab_1.tabpage_1.dw_2.scrolltorow(1)
	case keyend!
		tab_1.tabpage_1.dw_2.scrolltorow(tab_1.tabpage_1.dw_2.rowcount())
	case KeyupArrow!
		tab_1.tabpage_1.dw_2.scrollpriorrow()
	case KeyDownArrow!
		tab_1.tabpage_1.dw_2.scrollnextrow()
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

type dw_insert from w_inherite`dw_insert within w_pdm_01370_vendor
boolean visible = false
integer x = 1637
integer y = 2704
integer width = 2313
integer height = 232
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01370_vendor
boolean visible = false
integer x = 3634
integer y = 2568
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01370_vendor
boolean visible = false
integer x = 3447
integer y = 2568
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdm_01370_vendor
boolean visible = false
integer x = 3067
integer y = 2568
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdm_01370_vendor
boolean visible = false
integer x = 3707
integer taborder = 30
boolean enabled = false
end type

event p_ins::clicked;call super::clicked;ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

///////////////////////////////////////////////
tab_1.tabpage_1.dw_1.setredraw(false)

tab_1.tabpage_1.dw_1.reset()
tab_1.tabpage_1.dw_1.insertrow(0)
wf_TabOrder()

tab_1.tabpage_1.dw_1.SetFocus()

tab_1.tabpage_1.dw_1.setredraw(true)
///////////////////////////////////////////////
p_del.enabled = false
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
ib_any_typing = false

//tab_1.SelectTab(1)
//tab_1.tabpage_1.dw_1.setitem(1, 'danmst_efrdt', f_today())
tab_1.tabpage_1.dw_1.SetColumn("danmst_itnbr")
tab_1.tabpage_1.dw_1.Setfocus()

end event

type p_exit from w_inherite`p_exit within w_pdm_01370_vendor
integer x = 4402
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_pdm_01370_vendor
integer x = 4229
integer taborder = 60
end type

event p_can::clicked;ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

///////////////////////////////////////////////
tab_1.tabpage_1.dw_1.setredraw(false)

tab_1.tabpage_1.dw_1.reset()
tab_1.tabpage_1.dw_1.insertrow(0)
//tab_1.tabpage_1.dw_1.setitem(1, 'danmst_efrdt', f_today())
wf_TabOrder()

tab_1.tabpage_1.dw_1.setredraw(true)
///////////////////////////////////////////////
p_del.enabled = false
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'

ib_any_typing = false

tab_1.tabpage_1.dw_1.SetColumn("danmst_itnbr")
tab_1.tabpage_1.dw_2.Reset()
tab_1.tabpage_1.dw_7.Reset()

tab_1.tabpage_2.dw_list.Reset()
tab_1.tabpage_2.dw_cust.Reset()
tab_1.tabpage_2.dw_cust.InsertRow(0)

tab_1.tabpage_3.dw_hist.Reset()
tab_1.tabpage_3.dw_3.Reset()
tab_1.tabpage_3.dw_3.insertrow(0)

if tab_1.SelectedTab = 1 then 
   tab_1.tabpage_1.dw_1.Setfocus()
elseif tab_1.SelectedTab = 2 then 
   tab_1.tabpage_2.dw_cust.setfocus()
else	
   tab_1.tabpage_3.dw_3.setfocus()
end if	
end event

type p_print from w_inherite`p_print within w_pdm_01370_vendor
boolean visible = false
integer x = 3255
integer y = 2568
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdm_01370_vendor
boolean visible = false
integer x = 3534
integer taborder = 20
boolean enabled = false
end type

event p_inq::clicked;call super::clicked;ib_any_typing = false	

IF tab_1.tabpage_1.dw_1.AcceptText() = -1	THEN
	tab_1.tabpage_1.dw_1.SetFocus()
	return
END IF

string	sCode1,	sCode2, sCode3

sCode1 = tab_1.tabpage_1.dw_1.GetItemString(1, "danmst_itnbr")
sCode2 = tab_1.tabpage_1.dw_1.GetItemString(1, "danmst_cvcod")
sCode3 = tab_1.tabpage_1.dw_1.GetItemString(1, "opseq")

IF IsNull(sCode1)	 or  sCode1 = ''	THEN
	MessageBox("확 인", "품번을 입력하세요.")
   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn("danmst_itnbr")
	tab_1.tabpage_1.dw_1.SetFocus()
	RETURN
END IF

//IF IsNull(sCode3)	 or  sCode3 = ''	THEN
//	MessageBox("확 인", "공정순서를 입력하세요.")
////   tab_1.SelectTab(1)
//	tab_1.tabpage_1.dw_1.SetColumn("opseq")
//	tab_1.tabpage_1.dw_1.SetFocus()
//	RETURN
//END IF
//
//IF IsNull(sCode2)	 or  sCode2 = ''	THEN
//	MessageBox("확 인", "거래처를 입력하세요.")
////   tab_1.SelectTab(1)
//	tab_1.tabpage_1.dw_1.SetColumn("danmst_cvcod")
//	tab_1.tabpage_1.dw_1.SetFocus()
//	RETURN
//END IF
///////////////////////////////////////////////////////

tab_1.tabpage_1.dw_1.SetRedraw(false)

IF tab_1.tabpage_1.dw_1.Retrieve(sCode1, sCode2, sCode3, gs_saupj) > 0		THEN
   tab_1.tabpage_1.dw_1.SetItem(1, "temp", tab_1.tabpage_1.dw_1.GetItemNumber(1, "danmst_unprc"))
	
	IF tab_1.tabpage_1.dw_1.GetItemString(1,"opseq") = '9999' and &
		tab_1.tabpage_1.dw_1.GetItemString(1, "ins_gubun") =  '1' then
		tab_1.tabpage_1.dw_1.SetItem(1, "routng_opdsc", '구매용 공정')
	ELSEIF tab_1.tabpage_1.dw_1.GetItemString(1,"opseq") = '9999' and &
		tab_1.tabpage_1.dw_1.GetItemString(1, "ins_gubun") =  '2' then
		tab_1.tabpage_1.dw_1.SetItem(1, "routng_opdsc", '외주용 공정')
	END IF
	
	wf_Query()
ELSE	
//	MessageBox("확 인", "등록된 코드가 아닙니다.")
	tab_1.tabpage_1.dw_1.ReSet()
	tab_1.tabpage_1.dw_1.InsertRow(0)
//   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetFocus()
END IF

tab_1.tabpage_1.dw_2.retrieve(sCode1)
tab_1.tabpage_1.dw_7.retrieve(sCode1)
tab_1.tabpage_1.dw_1.SetRedraw(true)

end event

type p_del from w_inherite`p_del within w_pdm_01370_vendor
boolean visible = false
integer x = 4055
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;
IF tab_1.tabpage_1.dw_1.AcceptText() = -1	THEN	RETURN

if f_msg_delete() <> -1 then 
	
   tab_1.tabpage_1.dw_1.DeleteRow(0)

   IF tab_1.tabpage_1.dw_1.Update() > 0	 THEN
      COMMIT;
    	sle_msg.text =	"자료를 삭제하였습니다!!"	
	ELSE
		ROLLBACK;
      messagebox("삭제실패", "자료에 대한 갱신이 실패하였읍니다")
	END IF

END IF

//cb_can.TriggerEvent("clicked")

tab_1.tabpage_1.dw_1.insertRow(0)

tab_1.tabpage_1.dw_1.SetItem(1, "danmst_itnbr", str_itnbr.code)
tab_1.tabpage_1.dw_1.Setitem(1,"itemas_itdsc", str_itnbr.Name)
tab_1.tabpage_1.dw_1.Setitem(1,"itemas_ispec", str_itnbr.size)
tab_1.tabpage_1.dw_1.Setitem(1,"itemas_jijil", str_itnbr.jaijil)
tab_1.tabpage_1.dw_1.Setitem(1,"itemas_jejos", str_itnbr.jejos)

//p_inq.TriggerEvent("clicked")

tab_1.tabpage_1.dw_2.Retrieve(str_itnbr.code)
tab_1.tabpage_1.dw_7.Retrieve(str_itnbr.code)

tab_1.SelectTab(1)
tab_1.tabpage_1.dw_1.SetColumn("danmst_cvcod")
tab_1.tabpage_1.dw_1.SetFocus()

p_can.PostEvent("clicked")
end event

type p_mod from w_inherite`p_mod within w_pdm_01370_vendor
boolean visible = false
integer x = 3881
integer taborder = 40
boolean enabled = false
end type

event p_mod::clicked;call super::clicked;string snull

setnull(snull)

string	sCode1,	sCode2, sCode3, ls_cunit, sefrdt

tab_1.tabpage_1.dw_1.AcceptText()
tab_1.tabpage_1.dw_7.AcceptText()

sCode1 = tab_1.tabpage_1.dw_1.GetItemString(1, "danmst_itnbr")
sCode2 = tab_1.tabpage_1.dw_1.GetItemString(1, "danmst_cvcod")
sCode3 = tab_1.tabpage_1.dw_1.GetItemString(1, "opseq")
ls_cunit = tab_1.tabpage_1.dw_1.GetItemString(1, "danmst_cunit")
sefrdt  = tab_1.tabpage_1.dw_1.getitemstring(1, "danmst_efrdt")

IF IsNull(sCode1)	 or  sCode1 = ''	THEN
	MessageBox("확 인", "품번을 입력하세요.")
//   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn("danmst_itnbr")
	tab_1.tabpage_1.dw_1.SetFocus()
	RETURN
END IF

IF IsNull(sCode3)	 or  sCode3 = ''	THEN
	MessageBox("확 인", "공정순서를 입력하세요.")
//   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn("opseq")
	tab_1.tabpage_1.dw_1.SetFocus()
	RETURN
END IF

IF IsNull(sCode2)	 or  sCode2 = ''	THEN
	MessageBox("확 인", "거래처를 입력하세요.")
//   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn("danmst_cvcod")
	tab_1.tabpage_1.dw_1.SetFocus()
	RETURN
END IF

IF IsNull(ls_cunit)	 or  ls_cunit = ''	THEN
	MessageBox("확 인", "통화단위를 입력하세요")
//   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn("danmst_cunit")
	tab_1.tabpage_1.dw_1.SetFocus()
	RETURN
END IF

IF IsNull(sefrdt)	 or  sefrdt = '' or sefrdt = '1001011'	THEN
	MessageBox("확 인", "유효일자(적용일자)를 입력하세요.")
//   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetColumn("danmst_efrdt")
	tab_1.tabpage_1.dw_1.SetFocus()
	RETURN
END IF

IF tab_1.tabpage_1.dw_1.AcceptText() = -1  	THEN	
   tab_1.SelectTab(1)
	tab_1.tabpage_1.dw_1.SetFocus()
	RETURN
END IF

/////////////////////////////////////////////////////////////////////////////

IF ic_status = '1'		THEN
	IF wf_Confirm_key( ) = -1  	THEN 	RETURN
ELSE
	IF wf_Update_Vendor() = -1		THEN	RETURN
END IF

if wf_required_chk() = -1 then return

//IF f_checkrequired(tab_1.tabpage_1.dw_1) = -1   THEN 	RETURN

//////////////////////////////////////////////////////////////////////////////
if f_msg_update() = -1 then return

/////////////////////////////////////////////////////////////////////////////
// 	* 단가이력정보 UPDATE
/////////////////////////////////////////////////////////////////////////////
IF wf_Update_item() = -1	THEN	RETURN 

/////////////////////////////////////////////////////////////////////////////
	
IF tab_1.tabpage_1.dw_1.Update() <= 0	 THEN		
	ROLLBACK USING sqlca;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	RETURN 
ELSE
	COMMIT;
END IF

IF tab_1.tabpage_1.dw_7.Update() <= 0	 THEN		
	ROLLBACK USING sqlca;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	RETURN 
ELSE
	COMMIT;
END IF

tab_1.tabpage_1.dw_1.setitemstatus(1, 0, primary!, new!)

ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

wf_TabOrder()

p_del.enabled = false
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
ib_any_typing = false

tab_1.tabpage_2.dw_list.Reset()
tab_1.tabpage_2.dw_cust.Reset()
tab_1.tabpage_2.dw_cust.InsertRow(0)

tab_1.tabpage_3.dw_hist.Reset()
tab_1.tabpage_3.dw_3.Reset()
tab_1.tabpage_3.dw_3.insertrow(0)

//tab_1.tabpage_1.dw_1.SetItem(1, "danmst_itnbr", str_itnbr.code)
//tab_1.tabpage_1.dw_1.Setitem(1,"itemas_itdsc", str_itnbr.Name)
//tab_1.tabpage_1.dw_1.Setitem(1,"itemas_ispec", str_itnbr.size)
//tab_1.tabpage_1.dw_1.Setitem(1,"itemas_jijil", str_itnbr.jaijil)
//tab_1.tabpage_1.dw_1.Setitem(1,"itemas_jejos", str_itnbr.jejos)
	
tab_1.tabpage_1.dw_1.SetItem(1, "danmst_cvcod", snull)
tab_1.tabpage_1.dw_1.Setitem(1,"vndmst_cvnas", snull)
tab_1.tabpage_1.dw_1.Setitem(1,"vndmst_emp_id", snull)
tab_1.tabpage_1.dw_1.SetColumn("danmst_cvcod")
tab_1.tabpage_1.dw_1.SetFocus()

tab_1.tabpage_1.dw_2.retrieve(sCode1)
tab_1.tabpage_1.dw_7.retrieve(sCode1)
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01370_vendor
integer x = 3529
integer y = 2424
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01370_vendor
integer x = 2473
integer y = 2424
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01370_vendor
integer x = 2117
integer y = 2432
end type

type cb_del from w_inherite`cb_del within w_pdm_01370_vendor
integer x = 2825
integer y = 2424
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01370_vendor
integer x = 1765
integer y = 2432
end type

type cb_print from w_inherite`cb_print within w_pdm_01370_vendor
integer x = 1490
integer y = 2720
integer width = 439
string text = ""
end type

type st_1 from w_inherite`st_1 within w_pdm_01370_vendor
end type

type cb_can from w_inherite`cb_can within w_pdm_01370_vendor
integer x = 3177
integer y = 2424
end type

type cb_search from w_inherite`cb_search within w_pdm_01370_vendor
integer x = 1042
integer y = 2768
integer width = 439
string text = ""
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01370_vendor
integer x = 718
integer y = 2576
integer height = 140
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01370_vendor
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01370_vendor
end type

type tab_1 from tab within w_pdm_01370_vendor
event create ( )
event destroy ( )
integer x = 78
integer y = 180
integer width = 4489
integer height = 2200
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean showtext = false
boolean showpicture = false
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
integer selectedtab = 2
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

event selectionchanged;
CHOOSE CASE newindex

CASE 1
//   if ic_Status = '1' then  //등록모드인 경우
      p_inq.enabled = true
      p_mod.enabled = true
      p_ins.enabled = true
      p_del.enabled = false
		
		p_inq.PictureName = 'C:\erpman\image\조회_up.gif'
		p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
		p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
		p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
		
		pb_1.visible = true
		pb_2.visible = true
		pb_3.visible = true
		pb_4.visible = true
		
//	else
//      p_mod.enabled = true
//      p_inq.enabled = true
//      p_ins.enabled = true
//      p_del.enabled = true
//		
//		p_inq.PictureName = 'C:\erpman\image\조회_up.gif'
//		p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
//		p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
//		p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
//   end if		
//   tab_1.tabpage_1.dw_1.reset()
//   tab_1.tabpage_1.dw_2.reset()
//   tab_1.tabpage_1.dw_1.insertrow(0)
     tab_1.tabpage_1.dw_1.SetFocus()
CASE 2
	p_inq.enabled = false
	p_ins.enabled = false
	p_del.enabled = false
   p_mod.enabled = False
	
   pb_1.visible = false
	pb_2.visible = false
	pb_3.visible = false
	pb_4.visible = false
	
	p_inq.PictureName = 'C:\erpman\image\조회_d.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
	
	tab_1.tabpage_2.dw_list.Reset()
	tab_1.tabpage_2.dw_cust.Reset()
	tab_1.tabpage_2.dw_cust.InsertRow(0)
	tab_1.tabpage_2.dw_cust.SetFocus()
CASE 3
	p_inq.enabled = false
	p_ins.enabled = false
	p_del.enabled = false
   p_mod.enabled = False
	
   pb_1.visible = false
	pb_2.visible = false
	pb_3.visible = false
	pb_4.visible = false
	
	p_inq.PictureName = 'C:\erpman\image\조회_d.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
	
	tab_1.tabpage_3.dw_3.SetFocus()
	tab_1.tabpage_3.dw_hist.reset()
CASE 4
	p_inq.enabled = false
	p_ins.enabled = false
	p_del.enabled = false
   p_mod.enabled = False
	
   pb_1.visible = false
	pb_2.visible = false
	pb_3.visible = false
	pb_4.visible = false
	
	p_inq.PictureName = 'C:\erpman\image\조회_d.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
	tab_1.tabpage_4.dw_4.enabled = true
	tab_1.tabpage_4.dw_4.reset()	
	tab_1.tabpage_4.dw_5.reset()	
	tab_1.tabpage_4.dw_4.insertrow(0)
	tab_1.tabpage_4.dw_4.SetFocus()
END CHOOSE

 
	
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 16
integer width = 4453
integer height = 2136
long backcolor = 32106727
string text = "품목 단가 등록"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 553648127
dw_7 dw_7
pb_7 pb_7
pb_6 pb_6
pb_5 pb_5
dw_2 dw_2
rr_1 rr_1
dw_1 dw_1
rr_5 rr_5
end type

on tabpage_1.create
this.dw_7=create dw_7
this.pb_7=create pb_7
this.pb_6=create pb_6
this.pb_5=create pb_5
this.dw_2=create dw_2
this.rr_1=create rr_1
this.dw_1=create dw_1
this.rr_5=create rr_5
this.Control[]={this.dw_7,&
this.pb_7,&
this.pb_6,&
this.pb_5,&
this.dw_2,&
this.rr_1,&
this.dw_1,&
this.rr_5}
end on

on tabpage_1.destroy
destroy(this.dw_7)
destroy(this.pb_7)
destroy(this.pb_6)
destroy(this.pb_5)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.rr_5)
end on

type dw_7 from u_key_enter within tabpage_1
integer x = 78
integer y = 1368
integer width = 4315
integer height = 676
integer taborder = 11
string dataobject = "d_pdm_01370_8"
boolean border = false
end type

type pb_7 from u_pb_cal within tabpage_1
integer x = 1294
integer y = 492
integer taborder = 60
end type

event clicked;call super::clicked;dw_1.SetColumn('danmst_eftdt')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'danmst_eftdt', gs_code)
end event

type pb_6 from u_pb_cal within tabpage_1
integer x = 832
integer y = 492
integer taborder = 60
end type

event clicked;call super::clicked;dw_1.SetColumn('danmst_efrdt')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'danmst_efrdt', gs_code)
end event

type pb_5 from u_pb_cal within tabpage_1
integer x = 832
integer y = 416
integer taborder = 50
end type

event clicked;call super::clicked;dw_1.SetColumn('danmst_codat')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'danmst_codat', gs_code)
end event

type dw_2 from datawindow within tabpage_1
integer x = 78
integer y = 624
integer width = 4315
integer height = 676
boolean bringtotop = true
string dataobject = "d_pdm_01370_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string 	sCode1, sCode2, sCode3
											
IF Row <= 0	then		RETURN									

sCode1 = this.getitemstring(Row, "danmst_itnbr")
sCode2 = this.getitemstring(Row, "danmst_cvcod")
sCode3 = this.getitemstring(Row, "danmst_opseq")

IF tab_1.tabpage_1.dw_1.retrieve(sCode1, sCode2, sCode3, gs_saupj) > 0	THEN
	tab_1.tabpage_1.dw_1.SetItem(1, "temp", this.GetItemNumber(Row, "danmst_unprc"))

	IF tab_1.tabpage_1.dw_1.GetItemString(1,"opseq") = '9999' OR &
		tab_1.tabpage_1.dw_1.GetItemString(1,"ins_gubun") = '1'  THEN 
		tab_1.tabpage_1.dw_1.SetItem(1, "routng_opdsc", '구매용 공정')
	ELSEIF tab_1.tabpage_1.dw_1.GetItemString(1,"opseq") = '9999' OR &
		tab_1.tabpage_1.dw_1.GetItemString(1,"ins_gubun") = '2'  THEN 
		tab_1.tabpage_1.dw_1.SetItem(1, "routng_opdsc", '외주용 공정')
	END IF
END IF

this.selectrow(0, false)
this.selectrow(Row, true)

wf_Query()
tab_1.tabpage_1.dw_1.SetFocus()

if row > 0 Then
	p_del.enabled = true
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
End If
end event

event buttonclicked;str_item str_dan
Double   ddr,dcr,djan
Integer  iCount

IF dwo.name = "dcb_cust" THEN
	str_dan.code     = dw_1.GetItemString(1,"danmst_itnbr")
	str_dan.name     = dw_1.GetItemString(1,"opseq")
	str_dan.size     = dw_1.GetItemString(1,"danmst_cvcod")
	str_dan.jejos    = dw_1.GetItemString(1,"danmst_cunit")
	str_dan.wonchen  = dw_1.GetItemString(1,"routng_opdsc")

	OpenWithParm(w_pdm_01370_popup,str_dan)
	
//	select Count(*), sum(nvl(dr_amt,0)),	sum(nvl(cr_amt,0)),	sum(nvl(jan_amt,0))	
//		into :iCount, :dDr,						:dCr,						:dJan
//		from kfz13ot0
//		where saupj   = :Istr_JanGo.saupj and acc_yy = :Istr_JanGo.acc_yy and acc_mm = :Istr_JanGo.acc_mm and
//				acc1_cd = :Istr_JanGo.acc1_cd and acc2_cd = :Istr_JanGo.acc2_cd ;
//	if sqlca.sqlcode <> 0 then
//		iCount = 0
//	else
//		if IsNull(iCount) then iCount = 0
//	end if
//	
//	if iCount > 0 then
//		this.SetItem(Row,"kfz14ot0_dr_amt",  dDr)
//		this.SetItem(Row,"kfz14ot0_cr_amt",  dCr)
//		this.SetItem(Row,"kfz14ot0_jan_amt", dJan)
//		
//		ib_any_typing = True
//	end if
	
END IF
end event

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 616
integer width = 4352
integer height = 704
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within tabpage_1
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 50
integer y = 16
integer width = 4389
integer height = 596
integer taborder = 10
string dataobject = "d_pdm_01370_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "danmst_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "danmst_itnbr", gs_code)
      THIS.triggerevent(itemchanged!)		
		RETURN 1
	End If
END IF

end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;if ic_status = '1'   then

	ib_any_typing = true

end if

end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event itemchanged;String s_itnbr, sgub, snull, s_itdsc, s_ispec, s_unit, s_ispec_code, sopseq, sopseqname, sdate, semp_id ,s_jijil
string s_shtnm // 약호
int	 ireturn
double d_dan, d_width

sle_msg.text = ''

SetNull(sNull)

IF this.getcolumnname() = "ins_gubun" THEN

    sgub = this.gettext()
	
	IF sgub ="" OR IsNull(sgub) THEN RETURN
	
	IF sgub = '2' THEN
		this.SetItem(1,"opseq",'9999')
		this.SetItem(1,"routng_opdsc", '외주용 공정')
	ELSEIF sgub ='1' THEN
		this.SetItem(1,"opseq",'9999')
		this.SetItem(1,"routng_opdsc",'구매용 공정')
	END IF
ELSEIF	this.getcolumnname() = "danmst_itnbr"	THEN		// 관리품번 확인

	s_Itnbr = THIS.GETTEXT()								

	IF ISNULL(s_Itnbr) or  s_Itnbr = ''	THEN 	
		this.setitem(1, "danmst_itnbr", sNull)
   		this.Setitem(1,"itemas_itdsc", sNull)
		this.Setitem(1,"itemas_ispec", sNull)
		this.Setitem(1,"itemas_jijil", sNull)
		this.Setitem(1,"itemas_jejos", sNull)
//		this.Setitem(1,"itemas_ispec_code", sNull)
		tab_1.tabpage_1.dw_2.reset()
		tab_1.tabpage_1.dw_7.reset()
		Return 
   END IF
	
	ireturn = f_get_name4('품번', 'Y', s_itnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code )
	this.setitem(1, "danmst_itnbr", s_itnbr)
	this.Setitem(1, "itemas_itdsc", s_itdsc)
	this.Setitem(1, "itemas_ispec", s_ispec)
	this.Setitem(1, "itemas_jijil", s_jijil)
	
	/* 약호 넣기 ADT */	
	select itm_shtnm into :s_shtnm
	  from itmsht
	 where itnbr = :s_itnbr
	   and saupj = :gs_saupj;
   
	this.Setitem(1, "itm_shtnm", s_shtnm)
	
//	this.Setitem(1, "itemas_ispec_code", s_ispec_code)
	
   if ireturn = 0 then   
	   SELECT "ITEMAS"."JEJOS"
		  INTO :str_itnbr.jejos
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ITNBR" = :s_itnbr  ;

		this.Setitem(1,"itemas_jejos", str_itnbr.jejos)
		tab_1.tabpage_1.dw_2.retrieve(s_itnbr)
		tab_1.tabpage_1.dw_7.retrieve(s_itnbr) 
	else
		this.Setitem(1,"itemas_jejos", sNull)
		tab_1.tabpage_1.dw_2.reset()
		tab_1.tabpage_1.dw_7.reset()
   end if
	return ireturn 
ELSEIF this.getcolumnname() = "itemas_itdsc"	THEN		// 품명 확인
	s_Itdsc = THIS.GETTEXT()								

	IF ISNULL(s_Itdsc) or  s_Itdsc = ''	THEN 	
		this.setitem(1, "danmst_itnbr", sNull)
   	this.Setitem(1,"itemas_itdsc", sNull)
		this.Setitem(1,"itemas_ispec", sNull)
		this.Setitem(1,"itemas_jijil", sNull)
		this.Setitem(1,"itemas_jejos", sNull)
//		this.Setitem(1,"itemas_ispec_code", sNull)
		tab_1.tabpage_1.dw_2.reset() 
		tab_1.tabpage_1.dw_7.reset() 
		Return 
   END IF
	
   ireturn = f_get_name4('품명', 'Y', s_itnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code )
	this.setitem(1, "danmst_itnbr", s_itnbr)
	this.Setitem(1, "itemas_itdsc", s_itdsc)
	this.Setitem(1, "itemas_ispec", s_ispec)
	this.Setitem(1, "itemas_jijil", s_jijil)
	
	/* 약호 넣기 ADT */	
	select itm_shtnm into :s_shtnm
	  from itmsht
	 where itnbr = :s_itnbr
	   and saupj = :gs_saupj;
   
	this.Setitem(1, "itm_shtnm", s_shtnm)
//	this.Setitem(1, "itemas_ispec_code", s_ispec_code)
	
   if ireturn = 0 then   
	   SELECT "ITEMAS"."JEJOS"
		  INTO :str_itnbr.jejos
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ITNBR" = :s_itnbr  ;

		this.Setitem(1,"itemas_jejos", str_itnbr.jejos)
		tab_1.tabpage_1.dw_2.retrieve(s_itnbr) 
		tab_1.tabpage_1.dw_7.retrieve(s_itnbr) 
	else
		this.Setitem(1,"itemas_jejos", sNull)
		tab_1.tabpage_1.dw_2.reset()
		tab_1.tabpage_1.dw_7.reset()
   end if
	return ireturn 
ELSEIF	this.getcolumnname() = "itemas_ispec"	THEN		// 규격 확인
	s_ispec = THIS.GETTEXT()								

	IF ISNULL(s_Ispec) or  s_Ispec = ''	THEN 	
		this.setitem(1, "danmst_itnbr", sNull)
   	this.Setitem(1,"itemas_itdsc", sNull)
		this.Setitem(1,"itemas_ispec", sNull)
		this.Setitem(1,"itemas_jijil", sNull)
		this.Setitem(1,"itemas_jejos", sNull)
//		this.Setitem(1,"itemas_ispec_code", sNull)
		tab_1.tabpage_1.dw_2.reset() 
		Return 
   END IF
	
   ireturn = f_get_name4('규격', 'Y', s_itnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code )
	this.setitem(1, "danmst_itnbr", s_itnbr)
	this.Setitem(1, "itemas_itdsc", s_itdsc)
	this.Setitem(1, "itemas_ispec", s_ispec)
	this.Setitem(1, "itemas_jijil", s_jijil)
	
	/* 약호 넣기 ADT */	
	select itm_shtnm into :s_shtnm
	  from itmsht
	 where itnbr = :s_itnbr
	   and saupj = :gs_saupj;
   
	this.Setitem(1, "itm_shtnm", s_shtnm)
//	this.Setitem(1, "itemas_ispec_code", s_ispec_code)
	
   if ireturn = 0 then   
	   SELECT "ITEMAS"."JEJOS"
		  INTO :str_itnbr.jejos
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ITNBR" = :s_itnbr  ;

		this.Setitem(1,"itemas_jejos", str_itnbr.jejos)
		tab_1.tabpage_1.dw_2.retrieve(s_itnbr) 
	else
		this.Setitem(1,"itemas_jejos", sNull)
		tab_1.tabpage_1.dw_2.reset() 
   end if
	return ireturn 
ELSEIF	this.getcolumnname() = "itemas_jijil"	THEN		// 규격 확인
	s_jijil = THIS.GETTEXT()								

	IF ISNULL(s_jijil) or  s_jijil = ''	THEN 	
		this.setitem(1, "danmst_itnbr", sNull)
   	this.Setitem(1,"itemas_itdsc", sNull)
		this.Setitem(1,"itemas_ispec", sNull)
		this.Setitem(1,"itemas_jijil", sNull)
		this.Setitem(1,"itemas_jejos", sNull)
//		this.Setitem(1,"itemas_ispec_code", sNull)
		tab_1.tabpage_1.dw_2.reset() 
		Return 
   END IF
	
   ireturn = f_get_name4('재질', 'Y', s_itnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code )
	this.setitem(1, "danmst_itnbr", s_itnbr)
	this.Setitem(1, "itemas_itdsc", s_itdsc)
	this.Setitem(1, "itemas_ispec", s_ispec)
	this.Setitem(1, "itemas_jijil", s_jijil)
	
	/* 약호 넣기 ADT */	
	select itm_shtnm into :s_shtnm
	  from itmsht
	 where itnbr = :s_itnbr
	   and saupj = :gs_saupj;
   
	this.Setitem(1, "itm_shtnm", s_shtnm)
//	this.Setitem(1, "itemas_ispec_code", s_ispec_code)
	
   if ireturn = 0 then   
	   SELECT "ITEMAS"."JEJOS"
		  INTO :str_itnbr.jejos
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ITNBR" = :s_itnbr  ;

		this.Setitem(1,"itemas_jejos", str_itnbr.jejos)
		tab_1.tabpage_1.dw_2.retrieve(s_itnbr) 
	else
		this.Setitem(1,"itemas_jejos", sNull)
		tab_1.tabpage_1.dw_2.reset() 
   end if
	return ireturn 
ELSEIF	this.getcolumnname() = "itemas_ispec_code"	THEN		// 규격 확인
	s_ispec_code = THIS.GETTEXT()								

	IF ISNULL(s_ispec_code) or  s_ispec_code = ''	THEN 	
		this.setitem(1, "danmst_itnbr", sNull)
   	this.Setitem(1,"itemas_itdsc", sNull)
		this.Setitem(1,"itemas_ispec", sNull)
		this.Setitem(1,"itemas_jijil", sNull)
		this.Setitem(1,"itemas_jejos", sNull)
//		this.Setitem(1,"itemas_ispec_code", sNull)
		tab_1.tabpage_1.dw_2.reset() 
		Return 
   END IF
	
   ireturn = f_get_name4('규격코드', 'Y', s_itnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code )
	this.setitem(1, "danmst_itnbr", s_itnbr)
	this.Setitem(1, "itemas_itdsc", s_itdsc)
	this.Setitem(1, "itemas_ispec", s_ispec)
	this.Setitem(1, "itemas_jijil", s_jijil)
	
	/* 약호 넣기 ADT */	
	select itm_shtnm into :s_shtnm
	  from itmsht
	 where itnbr = :s_itnbr
	   and saupj = :gs_saupj;
   
	this.Setitem(1, "itm_shtnm", s_shtnm)
//	this.Setitem(1, "itemas_ispec_code", s_ispec_code)
	
   if ireturn = 0 then   
	   SELECT "ITEMAS"."JEJOS"
		  INTO :str_itnbr.jejos
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ITNBR" = :s_itnbr  ;

		this.Setitem(1,"itemas_jejos", str_itnbr.jejos)
		tab_1.tabpage_1.dw_2.retrieve(s_itnbr) 
	else
		this.Setitem(1,"itemas_jejos", sNull)
		tab_1.tabpage_1.dw_2.reset() 
   end if
	return ireturn 
ELSEIF	this.getcolumnname() = "danmst_cvcod"	THEN		// 거래처코드 확인
	s_itnbr = THIS.GETTEXT()								

	IF ISNULL(s_itnbr) 	or  s_itnbr = ''		THEN  
   	this.setitem(1, "vndmst_cvnas",  sNull)
   	this.setitem(1, "vndmst_emp_id", sNull)
		Return 
   end if
	
   ireturn = f_get_name2("V1", "Y", s_itnbr, s_itdsc, s_ispec)
	this.setitem(1, "danmst_cvcod", s_itnbr)
	this.setitem(1, "vndmst_cvnas", s_itdsc)
  	this.setitem(1, "vndmst_emp_id", sNull)
	/* 담당자 SETTING */
	if ireturn = 0 then
		setnull(semp_id)
		
		If This.GetItemString(1, 'ins_gubun') = '1' Then
			//구매
			SELECT emp_id into :semp_id from vndmst where cvcod = :s_itnbr;
		Else
			//외주
			SELECT outorder_emp into :semp_id from vndmst where cvcod = :s_itnbr ;
		End If
		
		this.setitem(1, "vndmst_emp_id", semp_id)
		if isnull(semp_id) or trim(semp_id) = '' then
			MessageBox("확 인","해당 거래처에는 구매담당자가 없습니다!!")
			this.setitem(1, "danmst_cvcod", snull)
			this.setitem(1, "vndmst_cvnas", snull)
			this.setitem(1, "vndmst_emp_id", snull)
			Return 1		
		end if
	end if
	
	return ireturn 
ELSEIF this.getcolumnname() ="opseq" THEN
	if this.accepttext() = -1 then return 
	
   sOpseq  = this.gettext()
	s_Itnbr    = this.GetItemString(1,"danmst_itnbr")
	
	IF sOpseq ="" OR IsNull(sOpseq) THEN 
		this.SetItem(1,"opseq",snull)
		this.SetItem(1,"routng_opdsc",snull)
		Return
	END IF
	
	IF sOpseq <> '9999' THEN
		SELECT "ROUTNG"."OPDSC"
		  INTO :sOpSeqName
		  FROM "ROUTNG"
		 WHERE "ROUTNG"."ITNBR" = :s_itnbr AND "ROUTNG"."OPSEQ" =:sopseq;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확 인","입력하신 품번으로 등록된 공정순서가 없습니다!!")
			this.SetItem(1,"opseq",snull)
			this.SetItem(1,"routng_opdsc",snull)
			Return 1
		ELSE
			this.SetItem(1,"routng_opdsc",sOpSeqName)
		END IF
	ELSE
  		this.SetItem(1,"routng_opdsc", '외주용 공정')
	END IF
ELSEIF	this.getcolumnname() = "danmst_codat"		THEN
   sdate =  trim(this.gettext())
	
   IF sdate = "" OR IsNull(sdate) THEN RETURN

	IF f_datechk(sdate) = -1	then
		f_message_chk(35,'[계약일자]')
		this.setitem(1, "danmst_codat", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "danmst_efrdt"		THEN
   sdate =  trim(this.gettext())
	
   IF sdate = "" OR IsNull(sdate) THEN RETURN

	IF f_datechk(sdate) = -1	then
		f_message_chk(35,'[유효일자]')
		this.setitem(1, "danmst_efrdt", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "danmst_eftdt"		THEN
   sdate =  trim(this.gettext())
	
   IF sdate = "" OR sdate = '99999999' OR IsNull(sdate) THEN RETURN
	
	IF f_datechk(sdate) = -1	then
		f_message_chk(35,'[유효일자]')
		this.setitem(1, "danmst_eftdt", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'danmst_cunit' THEN
	s_unit = this.gettext()
 
   IF s_unit = "" OR IsNull(s_unit) THEN RETURN
	
	s_unit = f_get_reffer('10', s_unit)
	if isnull(s_unit) or s_unit="" then
		f_message_chk(33,'[통화단위]')
		this.SetItem(1,'danmst_cunit', snull)
		return 1
   end if	
ELSEIF this.GetColumnName() = 'danmst_unprc' THEN
	s_itnbr = getitemstring(1, 'danmst_itnbr')
	d_dan   = Double(GetText())
	
	// 단가(m2) 계산
	select nvl(itm_width,0) into :d_width
	  from itemas
	 where itnbr = :s_itnbr;
	
	If d_width > 0 Then
		setitem(1, 'danmst_unprc2', Truncate( d_dan / ( d_width / 1000 ), 2 ) )
	End If
	
END IF



end event

event error;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column 이 아닌 Column 에서 Error 발생시 

//IF ib_ItemError = true	THEN	
//	ib_ItemError = false		
//	RETURN 1
//END IF



//	2) Required Column  에서 Error 발생시 

//string	sColumnName
//sColumnName = dwo.name + "_t.text"
//
//
//sle_msg.text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."
//

//RETURN 1
	
end event

event itemerror;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column 이 아닌 Column 에서 Error 발생시 

//IF ib_ItemError = true	THEN	
//	ib_ItemError = false		
//	RETURN 1
//END IF



//	2) Required Column  에서 Error 발생시 

//string	sColumnName
//sColumnName = dwo.name + "_t.text"
//
//
//sle_msg.text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."
//
RETURN 1
	
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF	this.getcolumnname() = "danmst_itnbr"	THEN		

	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	
	this.SetItem(1, "danmst_itnbr", gs_code)
	
   this.triggerevent(itemchanged!)
	return 1
ELSEIF	this.getcolumnname() = "itemas_itdsc"	THEN		

	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	
	this.SetItem(1, "danmst_itnbr", gs_code)
//	this.SetItem(1, "itemas_itdsc", gs_codename)
//	this.SetItem(1, "itemas_ispec", gs_gubun)
	
   this.triggerevent(itemchanged!)
	return 1
ELSEIF	this.getcolumnname() = "itemas_ispec"	THEN		

	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	
	this.SetItem(1, "danmst_itnbr", gs_code)
//	this.SetItem(1, "itemas_itdsc", gs_codename)
//	this.SetItem(1, "itemas_ispec", gs_gubun)
	
   this.triggerevent(itemchanged!)
	return 1
ELSEIF	this.Getcolumnname() = "danmst_cvcod"	THEN		

	gs_code = this.GetText()
	IF IsNull(gs_code) THEN gs_code =""
	
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "danmst_cvcod", gs_Code)
	this.setitem(1, "vndmst_cvnas", gs_CodeName)
   this.triggerevent(itemchanged!)	

ELSEIF this.GetColumnName() = "opseq" THEN
	IF this.GetItemString(1,"danmst_itnbr") = "" OR &
													IsNull(this.GetItemString(1,"danmst_itnbr")) THEN
		MessageBox("확 인","품번을 입력하세요!!")
		Return
	ELSE
		OpenWithParm(w_routng_popup,this.GetItemString(1,"danmst_itnbr"))
		
		IF IsNull(Gs_Code) THEN RETURN
		
		this.SetItem(1,"opseq",Gs_Code)
		this.SetItem(1,"routng_opdsc",Gs_CodeName)
		
	END IF					
END IF
end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type rr_5 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 73
integer y = 1348
integer width = 4338
integer height = 728
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 4453
integer height = 2136
long backcolor = 32106727
string text = "거래처별 수정"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
st_2 st_2
p_2 p_2
p_1 p_1
dw_cust dw_cust
dw_list dw_list
rr_2 rr_2
end type

on tabpage_2.create
this.st_2=create st_2
this.p_2=create p_2
this.p_1=create p_1
this.dw_cust=create dw_cust
this.dw_list=create dw_list
this.rr_2=create rr_2
this.Control[]={this.st_2,&
this.p_2,&
this.p_1,&
this.dw_cust,&
this.dw_list,&
this.rr_2}
end on

on tabpage_2.destroy
destroy(this.st_2)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_cust)
destroy(this.dw_list)
destroy(this.rr_2)
end on

type st_2 from statictext within tabpage_2
integer x = 2272
integer y = 64
integer width = 1605
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "* 납입요일 미지정시 토요일로 지정됩니다.!!"
boolean focusrectangle = false
end type

type p_2 from uo_picture within tabpage_2
integer x = 4233
integer y = 24
string picturename = "C:\erpman\image\저장1_up.gif"
end type

event clicked;string sopt, sitnbr, sopseq, sguout, scvcod
long   lcount, k, lcnt

IF tab_1.tabpage_2.dw_list.accepttext() = -1 then return 
if tab_1.tabpage_2.dw_cust.accepttext() = -1 then return 
//if tab_1.tabpage_2.dw_7.accepttext() = -1 then return 

IF tab_1.tabpage_2.dw_list.rowcount() < 1 then return 

//If tab_1.tabpage_2.dw_7.Update() <> 1 Then
//	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//	RollBack;
//	Return
//End If
//commit;

If dw_cust.GetItemString(1, 'gub') = '1' Then
	FOR k=1 TO tab_1.tabpage_2.dw_list.rowcount()
		 sopt  = tab_1.tabpage_2.dw_list.getitemstring(k, "opt")
		 
		if sopt = 'Y' then 
			lcount = lcount + 1
			
		end if	 
	NEXT
	
	if lcount < 1 then return 
	
	IF MessageBox("확인", "자료를 저장하시면 단가이력이 생성됩니다." + '~n~n' + & 
                      "자료를 저장하시겠습니까?", question!, yesno!) = 2 THEN	RETURN 1
End If


/////////////////////////////////////////////////////////////////////
dec		dPrice, dTemp
string	sItem, sVendor, sSeq, sToday

sToday = f_Today()

If dw_cust.GetItemString(1, 'gub') = '1' Then
	FOR k=1 TO tab_1.tabpage_2.dw_list.rowcount()
		 sopt  = tab_1.tabpage_2.dw_list.getitemstring(k, "opt")
		 
		If sopt = 'Y' then 
			sItem   = tab_1.tabpage_2.dw_list.getitemstring(k, "danmst_itnbr")
			sVendor = tab_1.tabpage_2.dw_list.getitemstring(k, "danmst_cvcod")
			sSeq    = tab_1.tabpage_2.dw_list.getitemstring(k, "danmst_opseq")
			dPrice  = tab_1.tabpage_2.dw_list.getitemdecimal(k, "danmst_unprc")
			dtemp   = tab_1.tabpage_2.dw_list.getitemdecimal(k, "yunprc")
		
			INSERT INTO "DANHST"  
					  ( "ITNBR", "CVCOD", "CDATE", "OPSEQ", "BAMT", "AAMT", "IDATE", "REMARK" )  
			 VALUES ( :sItem,  :sVendor,:sToday, :sSeq,   :dTemp, :dPrice,:sToday, null )  ;
		
			IF SQLCA.SQLCODE <> 0	THEN
				
				UPDATE DANHST
					SET BAMT = :dTemp,
						 AAMT = :dPrice
				 WHERE ITNBR = :sItem	and
						 CVCOD = :sVendor and
						 CDATE = :sToday  and
						 OPSEQ = :sSeq		;
			END IF
		END IF
	NEXT
End If

IF tab_1.tabpage_2.dw_list.Update() > 0 THEN		
	
	If dw_cust.GetItemString(1, 'gub') = '1' Then
		// 우선거래처 변경
		for k = 1 to tab_1.tabpage_2.dw_list.rowcount()
			 scvcod = tab_1.tabpage_2.dw_list.getitemstring(k, "danmst_cvcod")
			 sitnbr = tab_1.tabpage_2.dw_list.getitemstring(k, "danmst_itnbr")		
			 sopseq = tab_1.tabpage_2.dw_list.getitemstring(k, "danmst_opseq")		
			 sguout = tab_1.tabpage_2.dw_list.getitemstring(k, "danmst_guout")
				
			// 다른 거래처는 차선거래처로 변경
			if tab_1.tabpage_2.dw_list.getitemstring(k, "sltcd") = 'Y' then
				 Update danmst set sltcd = 'N'
				  where itnbr = :sitnbr
					 And opseq = :sopseq
					 And cvcod != :scvcod
					 And guout = :sguout;
			// 다른 거래처를 우선거래처로 변경			
			else
				 lcnt = 0
				 Select count(*) into :lcnt from danmst
				  Where itnbr = :sitnbr and opseq = :sopseq and guout = :sguout and sltcd = 'Y';
				 if lcnt <> 1 then
					 Update danmst set sltcd = 'Y'
					  where itnbr = :sitnbr
						 And opseq = :sopseq
						 And cvcod != :scvcod
						 And guout = :sguout
						 And rownum = 1;			
				 end if
			end if	
		
		Next		
	End If
	
	messagebox("저장완료", "자료에 대한 저장이 완료되었읍니다")	
	
	COMMIT;
ELSE
	ROLLBACK USING sqlca;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
END IF

tab_1.tabpage_2.dw_list.Retrieve(gs_saupj,TRIM(tab_1.tabpage_2.dw_cust.GetItemString(1,"cvcod")), gs_saupj) 
tab_1.tabpage_2.dw_cust.SetFocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장1_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장1_up.gif"
end event

type p_1 from uo_picture within tabpage_2
integer x = 4059
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\조회1_up.gif"
end type

event clicked;call super::clicked;String scust

tab_1.tabpage_2.dw_cust.AcceptText()
//tab_1.tabpage_2.dw_7.AcceptText()

sCust = TRIM(tab_1.tabpage_2.dw_cust.GetItemString(1,"cvcod"))

if scust = "" or isnull(scust) then 
	MessageBox("확인", "거래처를 입력하십시요.")
	tab_1.tabpage_2.dw_cust.SetFocus()
   return 
end if	

IF tab_1.tabpage_2.dw_list.Retrieve(gs_saupj, scust, gs_saupj) < 1		THEN
	MessageBox("확인", "해당자료가 없습니다.")
	tab_1.tabpage_2.dw_cust.SetFocus()
END IF

//tab_1.tabpage_2.dw_7.Retrieve(scust)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회1_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회1_up.gif"
end event

type dw_cust from u_key_enter within tabpage_2
integer x = 46
integer y = 24
integer width = 2249
integer height = 140
integer taborder = 11
string dataobject = "d_pdm_01370_31"
boolean border = false
end type

event rbuttondown;String snull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

IF	this.Getcolumnname() = "cvcod"	THEN		
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN 
		this.SetItem(1, "cvcod", snull)
		this.setitem(1, "cvnas", snull)		
	end if
		
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	this.setitem(1, "cvnas", gs_CodeName)
END IF
end event

event itemchanged;String sCod,sNam,sNam1

scod = this.gettext()
IF	this.Getcolumnname() = "cvcod"	THEN		
	f_get_name2("V1", 'Y', scod, snam, snam1)

	this.SetItem(1, "cvcod", scod)
	this.setitem(1, "cvnas", snam)
end if

IF	this.Getcolumnname() = "gub"	THEN		
	If GetText() = '1' Then
		dw_list.DataObject = 'd_pdm_01370_3'
		st_2.Visible = False
	Else
		dw_list.DataObject = 'd_pdm_01370_81'
		st_2.Visible = True
	End If
	dw_list.SetTransObject(sqlca)
end if
end event

type dw_list from datawindow within tabpage_2
integer x = 69
integer y = 200
integer width = 4325
integer height = 1812
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdm_01370_81"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemerror;return 1
end event

event itemchanged;dec  dunprc, dtemp

IF this.getcolumnname() = "danmst_unprc"	THEN
   dunprc = dec(this.gettext())
	dtemp  = this.getitemdecimal(row, 'yunprc')
	IF dunprc = dtemp then 
   	this.setitem(row, 'opt', 'N')
   ELSE
   	this.setitem(row, 'opt', 'Y')
	END IF	
elseif this.getcolumnname() = "sltcd"	THEN
   	this.setitem(row, 'opt', 'Y')	
END IF
end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

If dw_cust.getitemstring(1,'gub') = '1' then
	FOR k = 1 TO lRowCount
		IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
			This.SetItem(k,'crt_user',gs_userid)
		ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
			This.SetItem(k,'upd_user',gs_userid)
		END IF	  
	NEXT
end if
end event

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 188
integer width = 4352
integer height = 1844
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 4453
integer height = 2136
long backcolor = 32106727
string text = "단가 이력 수정"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
pb_9 pb_9
pb_8 pb_8
p_4 p_4
p_3 p_3
dw_hist dw_hist
rr_3 rr_3
dw_3 dw_3
end type

on tabpage_3.create
this.pb_9=create pb_9
this.pb_8=create pb_8
this.p_4=create p_4
this.p_3=create p_3
this.dw_hist=create dw_hist
this.rr_3=create rr_3
this.dw_3=create dw_3
this.Control[]={this.pb_9,&
this.pb_8,&
this.p_4,&
this.p_3,&
this.dw_hist,&
this.rr_3,&
this.dw_3}
end on

on tabpage_3.destroy
destroy(this.pb_9)
destroy(this.pb_8)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.dw_hist)
destroy(this.rr_3)
destroy(this.dw_3)
end on

type pb_9 from u_pb_cal within tabpage_3
integer x = 2528
integer y = 116
integer taborder = 50
end type

event clicked;call super::clicked;dw_3.SetColumn('to_date')
IF Isnull(gs_code) THEN Return
dw_3.SetItem(dw_3.getrow(), 'to_date', gs_code)
end event

type pb_8 from u_pb_cal within tabpage_3
integer x = 2075
integer y = 116
integer taborder = 40
end type

event clicked;call super::clicked;dw_3.SetColumn('fr_date')
IF Isnull(gs_code) THEN Return
dw_3.SetItem(dw_3.getrow(), 'fr_date', gs_code)
end event

type p_4 from uo_picture within tabpage_3
integer x = 4219
integer y = 76
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장1_up.gif"
end type

event clicked;IF tab_1.tabpage_3.dw_hist.accepttext() = -1 then return 

IF tab_1.tabpage_3.dw_hist.rowcount() < 1 then return 

if f_msg_update() = -1 then return

IF tab_1.tabpage_3.dw_hist.Update() > 0 THEN		
	COMMIT;
ELSE
	ROLLBACK USING sqlca;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
END IF



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장1_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장1_up.gif"
end event

type p_3 from uo_picture within tabpage_3
integer x = 4046
integer y = 76
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\조회1_up.gif"
end type

event clicked;call super::clicked;string	sItem, sCode1, sCode2, sDate1, sDate2

if tab_1.tabpage_3.dw_3.accepttext() = -1 then return 

sItem = tab_1.tabpage_3.dw_3.GetItemString(1, "itnbr")
scode1 = tab_1.tabpage_3.dw_3.GetItemString(1, "fr_vndcd")
scode2 = tab_1.tabpage_3.dw_3.GetItemString(1, "to_vndcd")
sdate1 = trim(tab_1.tabpage_3.dw_3.GetItemString(1, "Fr_date"))
sdate2 = trim(tab_1.tabpage_3.dw_3.GetItemString(1, "to_date"))

if sitem = '' or isnull(sitem) then 
	sitem = '%'
end if	

IF sCode1 = ''	or isnull(scode1)	THEN 	sCode1 = '.'
IF sCode2 = ''	or isnull(scode2)	THEN	sCode2 = 'ZZZZZZ'

if sdate1 = '' or isnull(sdate1)  then sdate1 ='10000101'
if sdate2 = '' or isnull(sdate2)  then sdate2 ='99999999'

IF tab_1.tabpage_3.dw_hist.Retrieve(gs_saupj, sItem, sCode1, sCode2, sDate1, sDate2, gs_saupj) < 1	THEN
	MessageBox("확인", "해당자료가 없습니다.")
	tab_1.tabpage_3.dw_3.SetFocus()
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회1_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회1_up.gif"
end event

type dw_hist from datawindow within tabpage_3
event ue_pressenter pbm_dwnprocessenter
integer x = 96
integer y = 248
integer width = 4274
integer height = 1768
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pdm_01370_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

type rr_3 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 236
integer width = 4311
integer height = 1796
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_3 from datawindow within tabpage_3
event ue_presenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 20
integer width = 2734
integer height = 200
integer taborder = 10
string dataobject = "d_pdm_01370_5"
boolean border = false
boolean livescroll = true
end type

event ue_presenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
		
		RETURN 1
	End If
END IF

end event

event itemchanged;string	sitnbr, sitdsc, sispec, sdate, snull
integer ireturn

setnull(snull)

IF this.getcolumnname() = "itnbr"	THEN
	sitnbr = this.gettext()
	ireturn = f_get_name2('품번', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	return ireturn
elseIF this.getcolumnname() = "itdsc"	THEN
	sitdsc = this.gettext()
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	return ireturn
ELSEIF this.getcolumnname() = "ispec"	THEN
	sispec = this.gettext()
	ireturn = f_get_name2('규격', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	return  ireturn
ELSEIF	this.getcolumnname() = "fr_date"		THEN
   sdate =  trim(this.gettext())
	
   IF sdate = "" OR IsNull(sdate) THEN RETURN
	
	IF f_datechk(sdate) = -1	then
		f_message_chk(35,'[변경일자]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "to_date"		THEN
   sdate =  trim(this.gettext())
	
   IF sdate = "" OR IsNull(sdate) THEN RETURN
	
	IF f_datechk(sdate) = -1	then
		f_message_chk(35,'[변경일자]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
End if



end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
Setnull(Gs_Gubun)

IF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
ELSEIF this.GetColumnName() = "fr_vndcd" THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return
	this.SetItem(1, "fr_vndcd", gs_Code)
ELSEIF this.GetColumnName() = "to_vndcd" THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return
	this.SetItem(1, "to_vndcd", gs_Code)
END IF
	

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 4453
integer height = 2136
long backcolor = 32106727
string text = "단가 일괄 복사 및 삭제"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
p_6 p_6
p_5 p_5
dw_4 dw_4
dw_5 dw_5
dw_6 dw_6
rr_4 rr_4
end type

on tabpage_4.create
this.p_6=create p_6
this.p_5=create p_5
this.dw_4=create dw_4
this.dw_5=create dw_5
this.dw_6=create dw_6
this.rr_4=create rr_4
this.Control[]={this.p_6,&
this.p_5,&
this.dw_4,&
this.dw_5,&
this.dw_6,&
this.rr_4}
end on

on tabpage_4.destroy
destroy(this.p_6)
destroy(this.p_5)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.dw_6)
destroy(this.rr_4)
end on

type p_6 from uo_picture within tabpage_4
integer x = 4215
integer y = 16
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장1_up.gif"
end type

event clicked;if dw_5.rowcount() < 1 then
	Messagebox("확인", "처리할 내역이 없읍니다", stopsign!)
	return
end if

dw_4.accepttext()
dw_5.accepttext()
dw_6.reset()

String sfr_cvcod, sto_cvcod, sgubun

sfr_cvcod = dw_4.getitemstring(1, "fr_cvcod")
sto_cvcod = dw_4.getitemstring(1, "to_cvcod")
sgubun    = dw_4.getitemstring(1, "gubun")

if isnull(sfr_cvcod) or trim(sfr_cvcod) = '' then
	f_message_chk(30,"[기준거래처]")
	dw_4.setcolumn("fr_cvcod")
	dw_4.setfocus()
	return
end if

// 복사거래처는 복사인 경우에만 check
if sgubun = '1' then
	if isnull(sto_cvcod) or trim(sto_cvcod) = '' then
		f_message_chk(30,"[복사거래처]")
		dw_4.setcolumn("to_cvcod")
		dw_4.setfocus()
		return		
	end if	
	
end if

if f_msg_update() = -1 then return

Long Lrow, lcnt 
string sitnbr, sopseq, sguout, sgbn 

sle_msg.text = '자료를 삭제중입니다..........!!'

For Lrow = 1 to dw_5.rowcount()
	
	 sgbn   = dw_5.getitemstring(Lrow, "gubun")
	 if sgbn = 'N' then continue
	 sitnbr = dw_5.getitemstring(Lrow, "danmst_itnbr")
	 sopseq = dw_5.getitemstring(Lrow, "danmst_opseq")
	 sguout = dw_5.getitemstring(Lrow, "danmst_guout")	 
	
	 if sgubun = '3' then // 삭제
		 Delete From danmst 
		  where itnbr = :sitnbr 
		  	 And cvcod = :sfr_cvcod 	    
	 		 And opseq = :sopseq
			 And guout = :sguout;
	    if sqlca.sqlnrows <> 1 then
			 rollback;
			 Messagebox("삭제", "삭제시 오류발생", stopsign!)
			 sle_msg.text = ''			 
			 return
		 End if
		 
		 // 삭제되는 품목+공정+구분내에서 우선거래처가 없으면 첫번째 거래처를 우선거래처로 변경
		 lcnt = 0
		 Select count(*) into :lcnt from danmst
		  Where itnbr = :sitnbr and opseq = :sopseq and guout = :sguout and sltcd = 'Y';
		 if lcnt < 1 then
			SetNull(lcnt)
			SELECT COUNT('X')
			  INTO :lcnt
			  FROM DANMST
			 WHERE ITNBR = :sitnbr
			   AND OPSEQ = :sopseq
				AND GUOUT = :sguout ;
			If lcnt > 0 Then
				Update danmst set sltcd = 'Y'
			    where itnbr = :sitnbr
			  	   And opseq = :sopseq
				   And guout = :sguout
				   And rownum = 1;
			   if sqlca.sqlnrows <> 1 then
				   rollback;
				   Messagebox("우선거래처", "우선거래처 변경시 오류발생", stopsign!)
				   sle_msg.text = ''			 
				   return
			   End if
		   End If
			
		 end if
		 
		 continue
		 
	 end if
	 
	 // 신규거래처로 복사
    dw_6.insertrow(Lrow)	 
	 dw_6.setitem(Lrow, "danmst_itnbr", 			dw_5.object.danmst_itnbr[lrow])
	 dw_6.setitem(Lrow, "danmst_cvcod", 			sto_cvcod)
	 dw_6.setitem(Lrow, "danmst_opseq", 			dw_5.object.danmst_opseq[lrow])
	 dw_6.setitem(Lrow, "danmst_unprc", 			dw_5.object.danmst_unprc[lrow])
	 dw_6.setitem(Lrow, "danmst_sltcd", 'N')
	 dw_6.setitem(Lrow, "danmst_efrdt", 			dw_5.object.danmst_efrdt[lrow])
	 dw_6.setitem(Lrow, "danmst_eftdt", 			dw_5.object.danmst_eftdt[lrow])
	 dw_6.setitem(Lrow, "danmst_cntgu", 			dw_5.object.danmst_cntgu[lrow])
	 dw_6.setitem(Lrow, "danmst_piqno", 			dw_5.object.danmst_piqno[lrow])
	 dw_6.setitem(Lrow, "danmst_qcgub", 			dw_5.object.danmst_qcgub[lrow])
 	 dw_6.setitem(Lrow, "danmst_qcemp", 			dw_5.object.danmst_qcemp[lrow])
	 dw_6.setitem(Lrow, "danmst_qctyp", 			dw_5.object.danmst_qctyp[lrow])
	 dw_6.setitem(Lrow, "danmst_codat", 			dw_5.object.danmst_codat[lrow])
	 dw_6.setitem(Lrow, "danmst_guout", 			dw_5.object.danmst_guout[lrow])
	 dw_6.setitem(Lrow, "danmst_stdrate", 		dw_5.object.danmst_stdrate[lrow])
	 dw_6.setitem(Lrow, "danmst_maxrate", 		dw_5.object.danmst_maxrate[lrow])
	 dw_6.setitem(Lrow, "danmst_minrate", 		dw_5.object.danmst_minrate[lrow])
	 dw_6.setitem(Lrow, "danmst_cunit", 			dw_5.object.danmst_cunit[lrow])
	 dw_6.setitem(Lrow, "danmst_hangu", 			dw_5.object.danmst_hangu[lrow])
	 dw_6.setitem(Lrow, "danmst_handojidat", 	dw_5.object.danmst_handojidat[lrow])	 
	 dw_6.setitem(Lrow, "danmst_handochdat", 	dw_5.object.danmst_handochdat[lrow])
	 dw_6.setitem(Lrow, "danmst_gonprc", 	dw_5.object.danmst_gonprc[lrow])        //공제단가 
Next

commit;

if sgubun = '1' then
	if dw_6.update() <> 1 then
		rollback;
		Messagebox("거래처변경", "거래처 복사시 오류발생", stopsign!)
		sle_msg.text = ''			 
		return	
	end if
end if

sle_msg.text = ''

Messagebox("완료", "처리가 완료되었읍니다", stopsign!)
dw_5.reset()
dw_4.enabled = true
return


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장1_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장1_up.gif"
end event

type p_5 from uo_picture within tabpage_4
integer x = 4041
integer y = 16
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\조회1_up.gif"
end type

event clicked;call super::clicked;string scvcod, tcvcod, sgubun

dw_4.accepttext()

scvcod = dw_4.getitemstring(1, "fr_cvcod")
tcvcod = dw_4.getitemstring(1, "to_cvcod")
sgubun = dw_4.getitemstring(1, "gubun")

if isnull(scvcod) or trim(scvcod) = '' then
	Messagebox("기준거래처", "기준거래처를 입력하십시요", stopsign!)
	dw_4.setcolumn("fr_cvcod")
	dw_4.setfocus()
	return
end if

if sgubun = '1'  then // 복사 인 경우에는 변경거래처가 필수
	if isnull(tcvcod) or trim(tcvcod) = '' then
		Messagebox("기준거래처", "기준거래처를 입력하십시요", stopsign!)
		dw_4.setcolumn("to_cvcod")
		dw_4.setfocus()
		return
	end if
end if
	
dw_5.retrieve(gs_saupj, scvcod)
dw_4.enabled = false
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회1_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회1_up.gif"
end event

type dw_4 from datawindow within tabpage_4
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 16
integer width = 3616
integer height = 124
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdm_01370_6"
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

event rbuttondown;String snull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

IF	this.Getcolumnname() = "fr_cvcod"	THEN		
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN 
		this.SetItem(1, "fr_cvcod", snull)
		this.setitem(1, "fr_cvnam", snull)		
	end if
		
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "fr_cvcod", gs_Code)
	this.setitem(1, "fr_cvnam", gs_CodeName)
ELSEIF	this.Getcolumnname() = "to_cvcod"	THEN		
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN 
		this.SetItem(1, "to_cvcod", snull)
		this.setitem(1, "to_cvnam", snull)		
	end if
		
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "to_cvcod", gs_Code)
	this.setitem(1, "to_cvnam", gs_CodeName)
	
END IF
	
end event

event itemerror;return 1
end event

event itemchanged;string scod, snam, snam1
integer ireturn

scod = this.gettext()

IF	this.Getcolumnname() = "fr_cvcod"	THEN		
	ireturn = f_get_name2("V1", 'Y', scod, snam, snam1)

	this.SetItem(1, "fr_cvcod", scod)
	this.setitem(1, "fr_cvnam", snam)
	
	return ireturn
elseif this.Getcolumnname() = "to_cvcod"	THEN		
	ireturn = f_get_name2("V1", 'Y', scod, snam, snam1)

	this.SetItem(1, "to_cvcod", scod)
	this.setitem(1, "to_cvnam", snam)
	
	return ireturn
END IF
end event

type dw_5 from datawindow within tabpage_4
integer x = 73
integer y = 180
integer width = 4297
integer height = 1844
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pdm_01370_7"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;string scvcod, sitnbr, sopseq, sguout
long   lrow

lrow = getrow()

if lrow > 0 and getcolumnname() = 'gubun' and dw_4.getitemstring(1, "gubun") = '1' then
	scvcod = dw_4.getitemstring(1, "to_cvcod")
	sitnbr = dw_5.getitemstring(lrow, "danmst_itnbr")
	sopseq = dw_5.getitemstring(lrow, "danmst_opseq")
	sguout = dw_5.getitemstring(lrow, "danmst_guout")
	
	lrow = 0
	select count(*) into :lrow from danmst
	 Where itnbr = :sitnbr and cvcod = :scvcod and opseq = :sopseq and guout = :sguout;
	if lrow > 0 then
		Messagebox("중복", "변경거래처에 해당품목이 이미 있읍니다", stopsign!)
		this.setitem(Lrow, "gubun", 'N')
		return 1
	end if
	
end if
end event

event itemerror;return 1
end event

type dw_6 from datawindow within tabpage_4
boolean visible = false
integer x = 567
integer y = 1268
integer width = 384
integer height = 136
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_pdm_01370_7"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_4 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 172
integer width = 4329
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 4453
integer height = 2136
long backcolor = 32106727
string text = "상각비 등록"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
p_10 p_10
p_9 p_9
p_8 p_8
p_7 p_7
dw_8 dw_8
rr_6 rr_6
end type

on tabpage_5.create
this.p_10=create p_10
this.p_9=create p_9
this.p_8=create p_8
this.p_7=create p_7
this.dw_8=create dw_8
this.rr_6=create rr_6
this.Control[]={this.p_10,&
this.p_9,&
this.p_8,&
this.p_7,&
this.dw_8,&
this.rr_6}
end on

on tabpage_5.destroy
destroy(this.p_10)
destroy(this.p_9)
destroy(this.p_8)
destroy(this.p_7)
destroy(this.dw_8)
destroy(this.rr_6)
end on

type p_10 from uo_picture within tabpage_5
integer x = 3918
integer y = 32
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\저장1_up.gif"
end type

event clicked;call super::clicked;integer r_c, r_c1, f_check
Long nrow, ncnt, ix

dw_8.accepttext()

//if err_check() = -1 then return
ncnt = dw_8.rowcount()
For ix = ncnt to 1 step -1
	If Trim(dw_8.GetItemString(ix, 'itnbr')) = '' Or IsNull(dw_8.GetItemString(ix, 'itnbr')) Then
		dw_8.deleterow(ix)
		continue
	End If
	If Trim(dw_8.GetItemString(ix, 'cvcod')) = '' Or IsNull(dw_8.GetItemString(ix, 'cvcod')) Then
		dw_8.deleterow(ix)
		continue
	End If	
Next

if dw_8.update() = 1 then
	commit;
else
	rollback;
	f_rollback()
end if

p_7.postevent(clicked!)

w_mdi_frame.sle_msg.text = '저장하였습니다.!!'
end event

type p_9 from uo_picture within tabpage_5
integer x = 3744
integer y = 32
integer width = 178
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;long curr_row

curr_row = dw_8.getrow()

if curr_row > 0 then
	dw_8.deleterow(curr_row)
	dw_8.setcolumn(1)
	dw_8.setfocus()
end if

if dw_8.rowcount() = 0 then  //전부삭제된경우
	 messagebox('확인',"삭제할자료가없습니다", &
					exclamation!,ok!) 
end if
	
	
end event

type p_8 from uo_picture within tabpage_5
integer x = 3570
integer y = 32
integer width = 178
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;long IcurrentRow

if dw_8.accepttext() = -1 then return 

if dw_8.rowcount() > 0 then
	icurrentrow = dw_8.getrow() + 1
	dw_8.insertrow(icurrentrow)
else
	dw_8.insertrow(0)
end if

//dw_8.setitem(dw_8.rowcount(),'sabu',gs_sabu)
//dw_8.setitem(dw_8.rowcount(),'rfcod',is_rfcod)
//dw_8.setitem(dw_8.rowcount(),'rfna3',is_key)
dw_8.scrolltorow(icurrentrow)
dw_8.setcolumn('itnbr')
dw_8.setfocus()



end event

type p_7 from uo_picture within tabpage_5
integer x = 3397
integer y = 32
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;dw_8.retrieve()
end event

type dw_8 from u_key_enter within tabpage_5
integer x = 5
integer y = 216
integer width = 4425
integer height = 1832
integer taborder = 60
string dataobject = "d_pdm_01370_9"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;String s_itnbr, sgub, snull, s_itdsc, s_ispec, s_unit, s_ispec_code, sopseq, sopseqname, sdate, semp_id ,s_jijil
string s_shtnm // 약호
int	 ireturn, nrow
double d_dan, d_width

sle_msg.text = ''

SetNull(sNull)

nrow = getrow()
if nrow <= 0  then return

IF	this.getcolumnname() = "itnbr"	THEN		// 관리품번 확인

	s_Itnbr = THIS.GETTEXT()								

	IF ISNULL(s_Itnbr) or  s_Itnbr = ''	THEN 	
		this.setitem(nrow, "itnbr", sNull)
   	this.Setitem(nrow,"itemas_itdsc", sNull)
		this.Setitem(nrow,"itemas_ispec", sNull)
		this.Setitem(nrow,"itemas_jijil", sNull)
		Return 
   END IF
	
	ireturn = f_get_name4('품번', 'Y', s_itnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code )
	this.setitem(nrow, "itnbr", s_itnbr)
	this.Setitem(nrow, "itemas_itdsc", s_itdsc)
	this.Setitem(nrow, "itemas_ispec", s_ispec)
	this.Setitem(nrow, "itemas_jijil", s_jijil)
	
	return ireturn 
ELSEIF	this.getcolumnname() = "cvcod"	THEN		// 거래처코드 확인
	s_itnbr = THIS.GETTEXT()								

	IF ISNULL(s_itnbr) 	or  s_itnbr = ''		THEN  
   	this.setitem(nrow, "vndmst_cvnas",  sNull)
   	Return 
   end if
	
   ireturn = f_get_name2("V1", "Y", s_itnbr, s_itdsc, s_ispec)
	this.setitem(nrow, "cvcod", s_itnbr)
	this.setitem(nrow, "vndmst_cvnas", s_itdsc)
  		
	return ireturn
END IF



end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;Long nrow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

nrow = getrow()
If nrow <= 0 then return

IF	this.getcolumnname() = "itnbr"	THEN		

	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	
	this.SetItem(nrow, "itnbr", gs_code)
	
   this.triggerevent(itemchanged!)
	return 1
ELSEIF	this.Getcolumnname() = "cvcod"	THEN		

	gs_code = this.GetText()
	IF IsNull(gs_code) THEN gs_code =""
	
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(nrow, "cvcod", gs_Code)
	this.setitem(nrow, "vndmst_cvnas", gs_CodeName)
//   this.triggerevent(itemchanged!)				
END IF
end event

type rr_6 from roundrectangle within tabpage_5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 208
integer width = 4448
integer height = 1852
integer cornerheight = 40
integer cornerwidth = 55
end type

type pb_1 from picturebutton within w_pdm_01370_vendor
boolean visible = false
integer x = 2624
integer y = 120
integer width = 82
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\first.cur"
boolean enabled = false
string picturename = "C:\erpman\image\first.gif"
alignment htextalign = left!
end type

event clicked;wf_scroll(1)
end event

type pb_2 from picturebutton within w_pdm_01370_vendor
boolean visible = false
integer x = 2715
integer y = 120
integer width = 82
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\prior.cur"
boolean enabled = false
string picturename = "C:\erpman\image\prior.gif"
alignment htextalign = left!
end type

event clicked;wf_scroll(2)
end event

type pb_3 from picturebutton within w_pdm_01370_vendor
boolean visible = false
integer x = 2807
integer y = 120
integer width = 82
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\next.cur"
boolean enabled = false
string picturename = "C:\erpman\image\next.gif"
alignment htextalign = left!
end type

event clicked;wf_scroll(3)
end event

type pb_4 from picturebutton within w_pdm_01370_vendor
boolean visible = false
integer x = 2898
integer y = 120
integer width = 82
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\last.cur"
boolean enabled = false
string picturename = "C:\erpman\image\last.gif"
alignment htextalign = left!
end type

event clicked;wf_scroll(4)
end event

