$PBExportHeader$w_pu90_00080.srw
$PBExportComments$** ���� ���ּ�
forward
global type w_pu90_00080 from w_standard_print
end type
type cb_1 from commandbutton within w_pu90_00080
end type
type rr_1 from roundrectangle within w_pu90_00080
end type
type rr_2 from roundrectangle within w_pu90_00080
end type
end forward

global type w_pu90_00080 from w_standard_print
string title = "�ְ����� ���ּ�"
cb_1 cb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pu90_00080 w_pu90_00080

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Long		ll_cnt
String	ls_yymmdd, ls_cvcod1, ls_cvcod2, ls_waigb, ls_saupj

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_yymmdd= Trim(dw_ip.Object.yymmdd[1])
ls_cvcod1= Trim(dw_ip.Object.cvcod1[1])
ls_cvcod2= Trim(dw_ip.Object.cvcod2[1])
ls_waigb = Trim(dw_ip.Object.waigb[1])
ls_saupj = Trim(dw_ip.Object.saupj[1])

If ls_yymmdd = '' Or isNull(ls_yymmdd) Then
	f_message_chk(35,'[��ȹ����]')
	Return -1
end If

If DayNumber(Date( Left(ls_yymmdd,4)+'-'+Mid(ls_yymmdd,5,2) +'-'+Right(ls_yymmdd,2) )) <> 2 Then
	MessageBox('Ȯ ��','��ȹ���ڴ� �����ϸ� �����մϴ�.!!')
	Return 1
End If

If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

SELECT COUNT(*) Into :ll_cnt
  FROM PU03_WEEKPLAN
 WHERE SABU LIKE :ls_saupj
	AND YYMMDD = :ls_yymmdd
	AND WAIGB = '1'
	AND CNFTIME IS NOT NULL
	AND WEBCNF IS NOT NULL ;

if sqlca.sqlcode <> 0 then
	MessageBox('Ȯ ��','��ȹȮ��[WEB]�� �ڷḸ ���ּ� ������ �����մϴ�.!!')
	Return 1
End If
		
If ls_cvcod1 = '' Or isNull(ls_cvcod1) Then ls_cvcod1 = '.'
If ls_cvcod2 = '' Or isNull(ls_cvcod2) Then ls_cvcod2 = 'zzzzzz'

if dw_list.Retrieve(ls_saupj, ls_yymmdd, ls_waigb, ls_cvcod1, ls_cvcod2) <= 0 then
	f_message_chk(50,'[���� ���ּ�a]')
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
///* ���ִ��� ��뿩�θ� ȯ�漳������ �˻��� */
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
//		IF bagbn = 'Y' then  //��ȯ��� ��� 
//			dw_list.DataObject = 'd_mat_01510_3'		// ��ü �ŷ�ó
//			dw_print.DataObject = 'd_mat_01510_3_p'
//		ELSE
//			dw_list.DataObject = 'd_mat_01510_1'		// ��ü �ŷ�ó
//			dw_print.DataObject = 'd_mat_01510_1_p'
//		END IF
//	else	
//		IF bagbn = 'Y' then 
//			dw_list.DataObject = 'd_mat_01510_2'		// Ư�� �ŷ�ó
//			dw_print.DataObject = 'd_mat_01510_2_p'
//		ELSE
//			dw_list.DataObject = 'd_mat_01510'			// Ư�� �ŷ�ó
//			dw_print.DataObject = 'd_mat_01510_p'
//		END IF
//	end if
//	dw_list.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)
//	dw_list.SetFilter("")
//	if sGubun  ="2" then //�԰�Ϸ�
//		dw_list.SetFilter(" (not (IsNull(Trim(insdat)) or Trim(insdat) = '')) and (not (IsNull(Trim(io_date)) or Trim(io_date) = '')) ")
//	elseif sGubun  ="3" then //�˻�Ϸ� - ���԰�
//		dw_list.SetFilter(" (not (IsNull(Trim(insdat)) or Trim(insdat) = '')) and ((IsNull(Trim(io_date)) or Trim(io_date) = '')) ")
//	end if
//	dw_list.Filter( )
//end if
//
//Choose Case sGubun
//		 Case '1'
////				dw_list.object.st_name.text = '��ü'
//		 Case '2'
////				dw_list.object.st_name.text = '�԰�Ϸ�'
//		 Case '3'
////				dw_list.object.st_name.text = '�˻�Ϸ�-���԰�'
//		 Case '4'
////				dw_list.object.st_name.text = '�԰��Ƿ�-�˻�̿Ϸ�'
//				if sfcvcod = '.' and stcvcod = 'ZZZZZZZZZZZZZZZ' then
//					IF bagbn = 'Y' then 
//						dw_list.DataObject = 'd_mat_01512_3'	// �ŷ�ó ��ü		
//						dw_print.DataObject = 'd_mat_01512_3_p'
//					ELSE
//						dw_list.DataObject = 'd_mat_01512_1'	// �ŷ�ó ��ü		
//						dw_print.DataObject = 'd_mat_01512_1_p'
//					END IF
//				else
//					IF bagbn = 'Y' then 
//						dw_list.DataObject = 'd_mat_01512_2'		// Ư�� �ŷ�ó
//						dw_print.DataObject = 'd_mat_01512_2_p'
//					ELSE
//						dw_list.DataObject = 'd_mat_01512'		// Ư�� �ŷ�ó
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
////	f_message_chk(50,'[�԰� ��Ȳ]')
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
//	f_message_chk(50,'[�԰� ��Ȳ]')
//	dw_list.Reset()
//	dw_print.insertrow(0)
////	Return -1
//END IF
//
//dw_print.ShareData(dw_list)
//
Return 1
end function

on w_pu90_00080.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_pu90_00080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.Object.saupj[1] = gs_saupj
//dw_ip.Object.saupj[1] = '10'
end event

type p_xls from w_standard_print`p_xls within w_pu90_00080
integer x = 3639
end type

type p_sort from w_standard_print`p_sort within w_pu90_00080
integer x = 3461
end type

type p_preview from w_standard_print`p_preview within w_pu90_00080
end type

type p_exit from w_standard_print`p_exit within w_pu90_00080
end type

type p_print from w_standard_print`p_print within w_pu90_00080
end type

type p_retrieve from w_standard_print`p_retrieve within w_pu90_00080
end type







type st_10 from w_standard_print`st_10 within w_pu90_00080
end type



type dw_print from w_standard_print`dw_print within w_pu90_00080
integer x = 3657
integer y = 156
integer height = 76
string dataobject = "d_pu90_00080_p2"
end type

type dw_ip from w_standard_print`dw_ip within w_pu90_00080
integer x = 91
integer y = 40
integer width = 2962
integer height = 188
string dataobject = "d_pu90_00080_1"
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

event dw_ip::rbuttondown;String sNull, sdate

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

ELSEIF this.GetColumnName() = "yymmdd" THEN
	sdate = trim(this.gettext())
	if f_datechk(sdate) = -1 then
		gs_code = left(f_today(),6)
	else
		gs_code = left(sdate,6)
	end if
//	Open(w_calendar_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return
	this.SetItem(1, "yymmdd", gs_Code)
END IF	
end event

type dw_list from w_standard_print`dw_list within w_pu90_00080
integer x = 46
integer y = 280
integer width = 4562
integer height = 1980
string dataobject = "d_pu90_00080_a2"
boolean border = false
end type

type cb_1 from commandbutton within w_pu90_00080
boolean visible = false
integer x = 3163
integer y = 148
integer width = 402
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "none"
end type

event clicked;integer li_ret

//li_ret = uf_save_dw_as_excel(dw_list, 'c:\dw2xls_test.xls')
li_ret = uf_save_dw_as_excel(dw_print, 'c:\dw2xls_test.xls')
if li_ret = 1 then
	messagebox('excel download','OK!!!')
   //success
   //...
else
	messagebox('excel download','ERROR!!!')
   //fail
   //...
end if
end event

type rr_1 from roundrectangle within w_pu90_00080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 28
integer width = 3072
integer height = 220
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pu90_00080
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

