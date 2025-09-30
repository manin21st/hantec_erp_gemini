$PBExportHeader$w_sal_03500.srw
$PBExportComments$ ** 제품 입고 현황
forward
global type w_sal_03500 from w_standard_print
end type
type cb_1 from commandbutton within w_sal_03500
end type
type pb_1 from u_pb_cal within w_sal_03500
end type
type pb_2 from u_pb_cal within w_sal_03500
end type
type rr_1 from roundrectangle within w_sal_03500
end type
end forward

global type w_sal_03500 from w_standard_print
string title = "제품 입고 현황"
cb_1 cb_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_03500 w_sal_03500

type variables
str_itnct str_sitnct
// m환산기준
Dec idMeter
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_sfrdate, s_stodate, s_ipgu, s_cvcod, s_itnbr, s_chang, sPdtgu
string s_get_cvcod, s_get_itnbr, s_get_ipgu , tx_name,ssaupj

If dw_ip.accepttext() <> 1 Then Return -1

s_sfrdate = Trim(dw_ip.getitemstring(1,"sfrdate"))
s_stodate = Trim(dw_ip.getitemstring(1,"stodate"))
s_ipgu    = Trim(dw_ip.getitemstring(1,"ipgu"))
s_cvcod   = Trim(dw_ip.getitemstring(1,"cvcod"))
s_itnbr   = Trim(dw_ip.getitemstring(1,"itnbr"))
s_chang   = Trim(dw_ip.getitemstring(1,"depot"))
sPdtgu    = Trim(dw_ip.getitemstring(1,"pdtgu"))
ssaupj = dw_ip.getitemstring(1,"saupj")

If IsNull(sPdtgu) or sPdtgu = '' Then sPdtgu = ''
////필수입력항목 체크///////////////////////////////////
if isnull(s_sfrdate) or s_sfrdate = "" then
	f_message_chk(30,'[기준일자]')
	dw_ip.setfocus()
	return -1
end if

if isnull(s_chang) or s_chang = "" then
	f_message_chk(30,'[입고창고]')
	dw_ip.setcolumn("depot")
	dw_ip.setfocus()
	return -1
end if

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

////날짜 from ~ to 유효성 확인////////////////////////
if s_sfrdate > s_stodate then
	f_message_chk(34,'[기준일자]')
	dw_ip.setfocus()
	return  -1
end if

////조건(입고구분)에서 값이 없을때 전체를 출력할 경우//////////////////
if isnull(s_ipgu) or s_ipgu = "" then 
   s_ipgu = '%'
	s_get_ipgu = '전체'
else
   s_get_ipgu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ipgu) ', 1)"))
   s_ipgu = s_ipgu + '%'
end if

////조건(입고처)에서 값이 없을때 전체를 출력할 경우//////////////////
if isnull(s_cvcod) or s_cvcod = "" then 
   s_cvcod = '%'
	s_get_cvcod = '전체'
else
   s_cvcod = s_cvcod + '%'	
	s_get_cvcod = Trim(dw_ip.GetItemString(1,'cvname'))
end if

////조건(제품명)에서 값이 없을때 전체를 출력할 경우//////////////////
if isnull(s_itnbr) or s_itnbr = "" then 
   s_itnbr = '%'
	s_get_itnbr = '전체'
else
   s_itnbr = s_itnbr + '%'	
	s_get_itnbr = Trim(dw_ip.GetItemString(1,'itdsc'))
end if

//// <조회> ///////////////////////////////////////////////////////////////////////////////////////////
//IF dw_list.retrieve(gs_sabu,s_sfrdate,s_stodate,s_ipgu,s_cvcod,s_itnbr,s_chang, spdtgu+'%',ssaupj ) <= 0 THEN
//   f_message_chk(50,'[제품입고현황]')
//	dw_ip.setfocus()
////	cb_print.Enabled =False
//	SetPointer(Arrow!)
//	Return -1
//END IF

IF dw_print.retrieve(gs_sabu,s_sfrdate,s_stodate,s_ipgu,s_cvcod,s_itnbr,s_chang, spdtgu+'%',ssaupj, idMeter ) <= 0 THEN
   f_message_chk(50,'[제품입고현황]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_pdtgu.text = '"+tx_name+"'")
dw_print.Modify("txt_pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.getitemstring(1,"cvname"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("ip_cvcod.text = '"+tx_name+"'")
dw_print.Modify("ip_cvcod.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ipgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("ipgu.text = '"+tx_name+"'")
dw_print.Modify("ipgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("pdtgu.text = '"+tx_name+"'")
dw_print.Modify("pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.getitemstring(1,"itdsc"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("yswitnbr.text = '"+tx_name+"'")
dw_print.Modify("yswitnbr.text = '"+tx_name+"'")
dw_list.scrolltorow(1)
SetPointer(Arrow!)

Return 0

end function

on w_sal_03500.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_sal_03500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;/* User별 관할구역 Setting */
String sarea, steam , saupj
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'saupj', saupj)
//End If

string sDate

sDate = f_today()

dw_ip.reset() 
dw_ip.insertrow(0) 


/* 부가 사업장 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj') 

DataWindowChild state_child
integer rtncode

////창고
f_child_saupj(dw_ip, 'depot', gs_saupj)
//rtncode 	= dw_ip.GetChild('depot', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 창고")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve(gs_saupj)

//생산팀
rtncode 	= dw_ip.GetChild('pdtgu', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('03',gs_saupj)

dw_ip.setitem(1, 'saupj', gs_saupj ) 

dw_ip.setitem(1,"sfrdate", Left(sDate,6) + '01')
dw_ip.SetItem(1, "stodate",sDate)
dw_ip.setfocus()

//m환산기준
SELECT TO_NUMBER(DATANAME) INTO :idMeter FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 2 AND LINENO = :gs_saupj;
If IsNull(idMeter) Then idMeter = 500000


sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_03500
end type

type p_exit from w_standard_print`p_exit within w_sal_03500
end type

type p_print from w_standard_print`p_print within w_sal_03500
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_03500
boolean originalsize = true
end type







type st_10 from w_standard_print`st_10 within w_sal_03500
end type



type dw_print from w_standard_print`dw_print within w_sal_03500
string dataobject = "d_sal_03500_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_03500
integer x = 69
integer y = 168
integer width = 4558
integer height = 196
string dataobject = "d_sal_03500_01"
end type

event dw_ip::itemchanged;String  sNull,sPdtgu,  sItnbr, sItdsc, sIspec, sIttyp, sItcls , sjijil, sispeccode
String  sItemCls, sItemGbn, sItemClsName, sDateFrom,ls_cvcod,ls_cvname,sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_saupj
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	Case "sfrdate","stodate"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[기간]')
			this.SetItem(1,GetColumnName(),snull)
			Return 1
		END IF
	/* 생산팀 */
	Case "pdtgu"
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
	/* 품번 */
	Case	"itnbr" 
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
		
		SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",
				 "ITEMAS"."ISPEC","ITNCT"."TITNM", "ITNCT"."PDTGU"
		  INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName,:sPdtgu
		  FROM "ITEMAS","ITNCT"
		 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				 "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				 "ITEMAS"."ITNBR" = :sItnbr ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		END IF
		
//		SetItem(nRow,"pdtgu", sPdtgu)
		SetItem(nRow,"itdsc", sItdsc)
		SetItem(nRow,"ispec", sIspec)
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())	
		IF sItdsc ="" OR IsNull(sItdsc) THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
		
		/* 품명으로 품번찾기 */
		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetColumn("itdsc")
			Return 1
		End If	
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
		
		/* 규격으로 품번찾기 */
		f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetColumn("ispec")
			Return 1
		End If
	case 'cvcod'
		sCvcod = this.GetText()
		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvname', snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcod",  		sCvcod)
				SetItem(1,"cvname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF

	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam, ls_pdtgu 
		Long   rtncode
		Datawindowchild state_child
		
		//사업장
		ls_saupj = Trim(gettext())

		//창고
		f_child_saupj(this, 'depot', ls_saupj)

		//생산팀
		rtncode 	= dw_ip.GetChild('pdtgu', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('03',ls_saupj)
		ls_pdtgu = dw_ip.object.pdtgu[1] 
		ls_return = f_saupj_chk_t('4' , ls_pdtgu) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'pdtgu', '')
		End if 
		
END Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "itcls"
		OpenWithParm(w_ittyp_popup, '1')
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		
		SetColumn('itnbr')
	Case "itclsnm"
		OpenWithParm(w_ittyp_popup, '1')
		str_sitnct = Message.PowerObjectParm
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",   str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		
		SetColumn('itnbr')
	/* ---------------------------------------- */
	Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"itnbr",gs_code)
		SetFocus()
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
	case 'cvcod'
		gs_gubun = '1'
		open(w_vndmst_popup)
		
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetItem(1,"cvname",gs_codename)
		
		SetColumn('cvcod')
END Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_03500
integer x = 87
integer y = 392
integer width = 4507
integer height = 1908
string dataobject = "d_sal_03500_02"
boolean border = false
boolean hsplitscroll = false
end type

type cb_1 from commandbutton within w_sal_03500
boolean visible = false
integer x = 78
integer y = 40
integer width = 352
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "정렬"
end type

event clicked;openwithparm(w_report_sort, dw_list)
end event

type pb_1 from u_pb_cal within w_sal_03500
integer x = 667
integer y = 176
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sfrdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sfrdate', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_03500
integer x = 1134
integer y = 176
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('stodate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'stodate', gs_code)

end event

type rr_1 from roundrectangle within w_sal_03500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 384
integer width = 4539
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

