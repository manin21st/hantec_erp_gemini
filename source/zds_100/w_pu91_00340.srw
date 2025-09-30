$PBExportHeader$w_pu91_00340.srw
$PBExportComments$** MRO 발주서
forward
global type w_pu91_00340 from w_standard_print
end type
type rr_1 from roundrectangle within w_pu91_00340
end type
type rr_2 from roundrectangle within w_pu91_00340
end type
end forward

global type w_pu91_00340 from w_standard_print
string title = "소모품 발주서"
rr_1 rr_1
rr_2 rr_2
end type
global w_pu91_00340 w_pu91_00340

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Long		ll_cnt
String	ls_date1, ls_date2, ls_cvcod1, ls_saupj, ls_dept, ls_empno

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_date1 = Trim(dw_ip.Object.date1[1])
ls_date2 = Trim(dw_ip.Object.date2[1])
ls_cvcod1= Trim(dw_ip.Object.cvcod1[1])
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_dept	= Trim(dw_ip.Object.cvcod2[1])
ls_empno	= Trim(dw_ip.Object.empno[1])
ls_empno = ''

If ls_date1 = '' Or isNull(ls_date1) Then 
	f_message_chk(35,'[발주일자FROM]')
	Return -1
end If

If ls_date2 = '' Or isNull(ls_date2) Then
	f_message_chk(35,'[발주일자TO]')
	Return -1
end If

If ls_cvcod1 = '' Or isNull(ls_cvcod1) Then ls_cvcod1 = '%'
If ls_dept = '' Or isNull(ls_dept) Then ls_dept = '%'
If ls_empno = '' Or isNull(ls_empno) Then ls_empno = '%'

if dw_list.Retrieve(gs_saupj, ls_date1, ls_date2, ls_cvcod1, ls_dept, ls_empno) <= 0 then
	f_message_chk(50,'[MRO 발주서]')
	dw_ip.Setfocus()
	return -1
end if


string	ls_deptnm, ls_telno, ls_faxno

select rfna1, 			rfna2, 			rfna3
  into :ls_deptnm,	:ls_telno,		:ls_faxno
  from reffpf
 where rfcod = '9F' and rfgub = :ls_dept ;

if sqlca.sqlcode = 0 then
	dw_print.modify("t_dept.text='"+ls_deptnm+"'")
	dw_print.modify("t_tel.text='"+ls_telno+"'")
	dw_print.modify("t_fax.text='"+ls_faxno+"'")
end if

Return 1 




//string cod1, cod2, sHouse, sGubun, sfcvcod, stcvcod, sIogbn, sIojpno, eIojpno, sqty, bagbn , sitnbr1, sitnbr2
//decimal {3} dqty1, dqty2
//
//IF dw_ip.AcceptText() = -1 THEN RETURN -1
//
//cod1 = TRIM(dw_ip.GetItemString(1, 'sdate'))
//cod2 = TRIM(dw_ip.GetItemString(1, 'edate'))
//sHouse = dw_ip.GetItemString(1, "house")
//sGubun = dw_ip.GetItemString(1, "gubun")
//sfcvcod = dw_ip.GetItemString(1, "fcvcod")
//stcvcod = dw_ip.GetItemString(1, "tcvcod")
//sIogbn  = dw_ip.GetItemString(1, "iogbn")
//sIojpno  = dw_ip.GetItemString(1, "siojpno")
//eIojpno  = dw_ip.GetItemString(1, "eiojpno")
//sqty     = dw_ip.GetItemString(1, "sqty")
//sitnbr1 = TRIM(dw_ip.GetItemString(1, 'sitnbr'))
//sitnbr2 = TRIM(dw_ip.GetItemString(1, 'eitnbr'))
//
//if (IsNull(cod1) or cod1 = "")  then cod1 = "10000101"
//if (IsNull(cod2) or cod2 = "")  then cod2 = "99991231"
//
//if IsNull(sHouse)  or trim(sHouse) =''		THEN	sHouse = '%'
//if IsNull(sIogbn)  or trim(sIogbn) =''		THEN	sIogbn = '%'
//if IsNull(sfcvcod) or trim(sfcvcod) =''	THEN	sfcvcod = '.'
//if IsNull(stcvcod) or trim(stcvcod) =''	THEN	stcvcod = 'ZZZZZZZZZZZZZZZ'
//if IsNull(siojpno) or trim(sIojpno) =''	THEN	siojpno = '.'
//if IsNull(eiojpno) or trim(eIojpno) =''	THEN	eiojpno = 'ZZZZZZZZZZZZZZZ'
//if (IsNull(sitnbr1) or sitnbr1 = "")  then sitnbr1 = "."
//if (IsNull(sitnbr2) or sitnbr2 = "")  then sitnbr2 = "zzzzzzzzzz"
//
///* 발주단위 사용여부를 환경설정에서 검색함 */
//bagbn	= 'N';
//select dataname
//  into :bagbn
//  from syscnfg
// where sysgu = 'Y' and serial = 12 and lineno = '3';
// 
//if sqlca.sqlcode <> 0 then
//	bagbn = 'N'
//end if
//
//if sgubun <> '4' then
//	if sfcvcod = '.' and stcvcod = 'ZZZZZZZZZZZZZZZ' then
//		IF bagbn = 'Y' then  //변환계수 사용 
//			dw_list.DataObject = 'd_mat_01510_3'		// 전체 거래처
//			dw_print.DataObject = 'd_mat_01510_3_p'
//		ELSE
//			dw_list.DataObject = 'd_mat_01510_1'		// 전체 거래처
//			dw_print.DataObject = 'd_mat_01510_1_p'
//		END IF
//	else	
//		IF bagbn = 'Y' then 
//			dw_list.DataObject = 'd_mat_01510_2'		// 특정 거래처
//			dw_print.DataObject = 'd_mat_01510_2_p'
//		ELSE
//			dw_list.DataObject = 'd_mat_01510'			// 특정 거래처
//			dw_print.DataObject = 'd_mat_01510_p'
//		END IF
//	end if
//	dw_list.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)
//	dw_list.SetFilter("")
//	if sGubun  ="2" then //입고완료
//		dw_list.SetFilter(" (not (IsNull(Trim(insdat)) or Trim(insdat) = '')) and (not (IsNull(Trim(io_date)) or Trim(io_date) = '')) ")
//	elseif sGubun  ="3" then //검사완료 - 미입고
//		dw_list.SetFilter(" (not (IsNull(Trim(insdat)) or Trim(insdat) = '')) and ((IsNull(Trim(io_date)) or Trim(io_date) = '')) ")
//	end if
//	dw_list.Filter( )
//end if
//
//Choose Case sGubun
//		 Case '1'
////				dw_list.object.st_name.text = '전체'
//		 Case '2'
////				dw_list.object.st_name.text = '입고완료'
//		 Case '3'
////				dw_list.object.st_name.text = '검사완료-미입고'
//		 Case '4'
////				dw_list.object.st_name.text = '입고의뢰-검사미완료'
//				if sfcvcod = '.' and stcvcod = 'ZZZZZZZZZZZZZZZ' then
//					IF bagbn = 'Y' then 
//						dw_list.DataObject = 'd_mat_01512_3'	// 거래처 전체		
//						dw_print.DataObject = 'd_mat_01512_3_p'
//					ELSE
//						dw_list.DataObject = 'd_mat_01512_1'	// 거래처 전체		
//						dw_print.DataObject = 'd_mat_01512_1_p'
//					END IF
//				else
//					IF bagbn = 'Y' then 
//						dw_list.DataObject = 'd_mat_01512_2'		// 특정 거래처
//						dw_print.DataObject = 'd_mat_01512_2_p'
//					ELSE
//						dw_list.DataObject = 'd_mat_01512'		// 특정 거래처
//						dw_print.DataObject = 'd_mat_01512_p'
//					END IF
//				end if
//				dw_list.SetTransObject(SQLCA)
//				dw_print.SetTransObject(SQLCA)
//End choose
////////////////////////////////////////////////////////////////////////
//if sqty = '1' then
//	dqty1 = -9999999999.99
//	dqty2 = 0
//elseif sqty = '2' then
//	dqty1 = 0
//	dqty2 = -9999999999.99
//else
//	dqty1 = -9999999999.99
//	dqty2 = -9999999999.99
//end if
//
//
////if dw_list.Retrieve(gs_sabu, cod1, cod2, sHouse, sfcvcod, stcvcod, &
////                    siogbn, siojpno, eiojpno, dqty1, dqty2, sitnbr1, sitnbr2) <= 0 then
////	f_message_chk(50,'[입고 현황]')
////	dw_ip.Setfocus()
////	return -1
////end if
//
//cod1 = left(cod1,4) + '/' + mid(cod1,5,2) + '/' + right(cod1,2)
//cod2 = left(cod2,4) + '/' + mid(cod2,5,2) + '/' + right(cod2,2)
//dw_print.Object.st_date.text = cod1 + ' - ' + cod2
//
//IF dw_print.Retrieve(gs_sabu, cod1, cod2, sHouse, sfcvcod, stcvcod, &
//                    siogbn, siojpno, eiojpno, dqty1, dqty2, sitnbr1, sitnbr2) <= 0 then
//	f_message_chk(50,'[입고 현황]')
//	dw_list.Reset()
//	dw_print.insertrow(0)
////	Return -1
//END IF
//
//dw_print.ShareData(dw_list)
//
Return 1
end function

on w_pu91_00340.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pu91_00340.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.Object.date1[1] = left(f_today(),6)+'01'
dw_ip.Object.date2[1] = f_today()

string	sempname, sdept, sdeptname 

select empname, deptcode, fun_get_dptno(deptcode) 
  into :sempname, :sdept, :sdeptname 
  from p1_master
 where empno = :gs_empno ;

dw_ip.Object.cvcod2[1] = sdept
dw_ip.Object.cvnas2[1] = sdeptname
dw_ip.Object.empno[1] = gs_empno
dw_ip.Object.empnm[1] = sempname

///* User별 사업장 Setting Start */
//String saupj
//
//If f_check_saupj(saupj) = 1 Then
//	dw_ip.Modify("saupj.protect=1")
//End If
//dw_ip.SetItem(1, 'saupj', saupj)
///* ---------------------- End  */
f_mod_saupj(dw_ip, 'saupj')
end event

type p_preview from w_standard_print`p_preview within w_pu91_00340
end type

type p_exit from w_standard_print`p_exit within w_pu91_00340
end type

type p_print from w_standard_print`p_print within w_pu91_00340
end type

type p_retrieve from w_standard_print`p_retrieve within w_pu91_00340
end type







type st_10 from w_standard_print`st_10 within w_pu91_00340
end type



type dw_print from w_standard_print`dw_print within w_pu91_00340
integer x = 3415
integer y = 172
integer height = 76
string dataobject = "d_pu91_00340_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pu91_00340
integer x = 59
integer y = 68
integer width = 3168
integer height = 168
string dataobject = "d_pu91_00340_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keyF2!) THEN
//   IF	this.getcolumnname() = "cod1"	THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 
//			this.SetItem(1, "cod1", "")
//	      this.SetItem(1, "nam1", "")
//	      return
//	   else
//			this.SetItem(1, "cod1", gs_code)
//	      this.SetItem(1, "nam1", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1
//		end if
//   ELSEIF this.getcolumnname() = "cod2" THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 	
//			this.SetItem(1, "cod2", "")
//	      this.SetItem(1, "nam2", "")
//	      return
//	   else
//			this.SetItem(1, "cod2", gs_code)
//	      this.SetItem(1, "nam2", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1	
//		end if	
//   END IF
//END IF  
end event

event dw_ip::itemchanged;string snull, sbaljno, get_nm, s_date, s_empno, s_name, s_name2
int    ireturn 

setnull(snull)

IF this.GetColumnName() = "cvcod1" THEN
	s_empno = this.GetText()
	s_name  = this.getitemstring(1,"cvcod2")
	
	ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
	this.setitem(1, "cvcod1", s_empno)	
	this.setitem(1, "cvnas1", get_nm)
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "empno" THEN
	s_empno = this.GetText()
	
	ireturn = f_get_name2('사번', 'Y', s_empno, get_nm, s_name)
	this.setitem(1, "empno", s_empno)	
	this.setitem(1, "empnm", get_nm)	
	RETURN ireturn
	
END IF	

end event

event dw_ip::rbuttondown;String sNull

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
setnull(snull)

IF this.GetColumnName() = "cvcod1" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return
	this.SetItem(1, "cvcod1", gs_Code)
	this.SetItem(1, "cvnas1", gs_Codename)
	
ELSEIF this.GetColumnName() = "empno" THEN
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return
	this.SetItem(1, "empno", gs_Code)
	this.SetItem(1, "empnm", gs_Codename)
END IF	
end event

type dw_list from w_standard_print`dw_list within w_pu91_00340
integer x = 46
integer y = 304
integer width = 4562
integer height = 1964
string dataobject = "d_pu91_00340_a"
boolean border = false
end type

type rr_1 from roundrectangle within w_pu91_00340
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 48
integer width = 3246
integer height = 220
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pu91_00340
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 292
integer width = 4581
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

