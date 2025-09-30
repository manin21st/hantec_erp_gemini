$PBExportHeader$w_pu90_00010.srw
$PBExportComments$** 년 구매 계획 현황 [공급업체별]
forward
global type w_pu90_00010 from w_standard_print
end type
type st_1 from statictext within w_pu90_00010
end type
type rr_1 from roundrectangle within w_pu90_00010
end type
type rr_2 from roundrectangle within w_pu90_00010
end type
end forward

global type w_pu90_00010 from w_standard_print
string title = "년 구매 계획 현황 [공급업체별]"
st_1 st_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pu90_00010 w_pu90_00010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String	ls_yyyy, ls_cvcod1, ls_cvcod2, ls_saupj, ls_gubun

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_yyyy 	= Trim(dw_ip.Object.yyyy[1])
ls_cvcod1= Trim(dw_ip.Object.cvcod1[1])
ls_cvcod2= Trim(dw_ip.Object.cvcod2[1])
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_gubun = Trim(dw_ip.Object.gubun[1])

If ls_yyyy = '' Or isNull(ls_yyyy) Then
	f_message_chk(35,'[계획년도]')
	Return -1
end If

If ls_cvcod1 = '' Or isNull(ls_cvcod1) Then ls_cvcod1 = '.'
If ls_cvcod2 = '' Or isNull(ls_cvcod2) Then ls_cvcod2 = 'zzzzzz'

if dw_list.Retrieve(ls_saupj, ls_yyyy, ls_cvcod1, ls_cvcod2, ls_gubun) <= 0 then
	f_message_chk(50,'[년 구매 계획 현황]')
	dw_ip.Setfocus()
	return -1
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

on w_pu90_00010.create
int iCurrent
call super::create
this.st_1=create st_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_pu90_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;string	smaxyyyy

select max(yyyy) into :smaxyyyy from pu01_yearplan ;
if isnull(smaxyyyy) or smaxyyyy = '' then
	dw_ip.Object.yyyy[1] = Left(f_today(),4)
else	
	dw_ip.Object.yyyy[1] = smaxyyyy
end if

dw_ip.Object.saupj[1] = gs_saupj
//dw_ip.Object.saupj[1] = '10'
end event

type p_preview from w_standard_print`p_preview within w_pu90_00010
end type

type p_exit from w_standard_print`p_exit within w_pu90_00010
end type

type p_print from w_standard_print`p_print within w_pu90_00010
end type

type p_retrieve from w_standard_print`p_retrieve within w_pu90_00010
end type







type st_10 from w_standard_print`st_10 within w_pu90_00010
end type



type dw_print from w_standard_print`dw_print within w_pu90_00010
integer x = 3630
integer y = 64
integer height = 76
string dataobject = "d_pu90_00010_p2"
end type

type dw_ip from w_standard_print`dw_ip within w_pu90_00010
integer x = 91
integer y = 40
integer width = 2757
integer height = 188
string dataobject = "d_pu90_00010_1"
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
	
	if isnull(s_name) or s_name = '' then
		this.setitem(1, "cvcod2", s_empno)	
		this.setitem(1, "cvnas2", get_nm)
	end if
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "cvcod2" THEN
	s_empno = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
	this.setitem(1, "cvcod2", s_empno)	
	this.setitem(1, "cvnas2", get_nm)	
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
	this.triggerevent(itemchanged!)
//	this.SetItem(1, "cvnas1", gs_Codename)
	
ELSEIF this.GetColumnName() = "cvcod2" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return
	this.SetItem(1, "cvcod2", gs_Code)
	this.SetItem(1, "cvnas2", gs_Codename)
END IF	
end event

type dw_list from w_standard_print`dw_list within w_pu90_00010
integer x = 46
integer y = 280
integer width = 4562
integer height = 1980
string dataobject = "d_pu90_00010_b"
boolean border = false
end type

type st_1 from statictext within w_pu90_00010
integer x = 4178
integer y = 204
integer width = 434
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "(금액단위:천원)"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pu90_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 28
integer width = 2880
integer height = 220
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pu90_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 272
integer width = 4581
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

