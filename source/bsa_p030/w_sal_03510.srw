$PBExportHeader$w_sal_03510.srw
$PBExportComments$ ** 제품 출고 현황
forward
global type w_sal_03510 from w_standard_print
end type
type rb_1 from radiobutton within w_sal_03510
end type
type rb_2 from radiobutton within w_sal_03510
end type
type gb_1 from groupbox within w_sal_03510
end type
type rr_1 from roundrectangle within w_sal_03510
end type
type cb_1 from commandbutton within w_sal_03510
end type
type pb_1 from u_pb_cal within w_sal_03510
end type
type pb_2 from u_pb_cal within w_sal_03510
end type
end forward

global type w_sal_03510 from w_standard_print
string title = "제품 출고 현황"
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
rr_1 rr_1
cb_1 cb_1
pb_1 pb_1
pb_2 pb_2
end type
global w_sal_03510 w_sal_03510

type variables
// m환산기준
Dec idMeter
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_sfrdate, s_stodate, s_ipgu, s_cvcod, s_itnbr,s_depot, sTeamcd, sArea, tx_name
string s_get_cvcod, s_get_itnbr, s_get_ipgu,ssaupj 

If dw_ip.accepttext() <> 1 Then Return -1

s_sfrdate = dw_ip.getitemstring(1,"sfrdate")
s_stodate = dw_ip.getitemstring(1,"stodate")
s_ipgu    = Trim(dw_ip.getitemstring(1,"ipgu"))

sTeamCd   = Trim(dw_ip.getitemstring(1,"deptcode"))
sArea     = Trim(dw_ip.getitemstring(1,"areacode"))
s_cvcod   = Trim(dw_ip.getitemstring(1,"custcode"))

s_itnbr   = Trim(dw_ip.getitemstring(1,"itnbr"))
s_depot   = Trim(dw_ip.getitemstring(1,"depot"))
ssaupj = dw_ip.getitemstring(1,"saupj")

If IsNull(sTeamcd ) Then sTeamCd = ''
If IsNull(sArea ) Then sArea = ''

////필수입력항목 체크///////////////////////////////////
if isnull(s_sfrdate) or s_sfrdate = "" then
	f_message_chk(30,'[기준일자]')
	dw_ip.setfocus()
	return -1
end if

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[출고창고]')
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
	return -1
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
	s_get_cvcod = Trim(dw_ip.GetItemString(1,'custname'))
end if

////조건(제품명)에서 값이 없을때 전체를 출력할 경우//////////////////
if isnull(s_itnbr) or s_itnbr = "" then 
   s_itnbr = '%'
	s_get_itnbr = '전체'
else
   s_itnbr = s_itnbr + '%'
	s_get_itnbr = Trim(dw_ip.GetItemString(1,'itdsc'))
end if

//IF dw_list.retrieve(gs_sabu,s_sfrdate,s_stodate,s_ipgu,sTeamcd+'%',sArea+'%',s_cvcod,s_itnbr,s_depot,ssaupj) <= 0 THEN
//   f_message_chk(50,'[제품출고현황]')
//	dw_ip.setfocus()
////	cb_print.Enabled =False
//	SetPointer(Arrow!)
//	Return -1
//END IF

IF dw_print.retrieve(gs_sabu,s_sfrdate,s_stodate,s_ipgu,sTeamcd+'%',sArea+'%',s_cvcod,s_itnbr,s_depot,ssaupj, idMeter) <= 0 THEN
   f_message_chk(50,'[제품출고현황]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ipgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("ipgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.getitemstring(1,"custname"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("ip_cvcod.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.getitemstring(1,"itdsc"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("yswitnbr.text = '"+tx_name+"'")

Return 0
end function

on w_sal_03510.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.rr_1=create rr_1
this.cb_1=create cb_1
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
end on

on w_sal_03510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.cb_1)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event ue_open;call super::ue_open;string sDate

dw_ip.reset() 
dw_ip.insertrow(0) 

sDate = f_today()
dw_ip.setitem(1,"sfrdate",Left(sDate,6)+'01')
dw_ip.SetItem(1, "stodate", sDate)
dw_ip.setfocus()

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'saupj', saupj)
End If

/* 부가 사업장 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

//창고
f_child_saupj(dw_ip, 'depot', gs_saupj) 

//영업팀
f_child_saupj(dw_ip, 'deptcode', '%') 

//관할 구역
f_child_saupj(dw_ip, 'areacode', '%') 

dw_ip.setitem(1, 'saupj', gs_saupj ) 

//m환산기준
SELECT TO_NUMBER(DATANAME) INTO :idMeter FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 2 AND LINENO = :gs_saupj;
If IsNull(idMeter) Then idMeter = 500000


sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_03510
end type

type p_exit from w_standard_print`p_exit within w_sal_03510
end type

type p_print from w_standard_print`p_print within w_sal_03510
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_03510
end type







type st_10 from w_standard_print`st_10 within w_sal_03510
end type



type dw_print from w_standard_print`dw_print within w_sal_03510
string dataobject = "d_sal_03510_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_03510
integer x = 27
integer y = 32
integer width = 3675
integer height = 296
string dataobject = "d_sal_03510_01"
end type

event dw_ip::itemchanged;string snull, sitnbr, sitdsc, sispec, s_cvnm, s_cvnm2, s_cvcod, s_depot, s_chname, s_chname2
String sIttyp,sItcls,sItemclsName , sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_saupj
String sIocustarea, sDept, sIocust, sIoCustName
long lcount,nRow
int  ireturn

setnull(snull)

nRow = GetRow()
Choose Case	this.GetColumnName() 
	Case "sfrdate","stodat"
	  IF f_datechk(trim(this.gettext())) = -1	then
       f_message_chk(35,'[기간]')
		 this.setitem(1, GetColumnName(), sNull)
		 return 1
	  END IF
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
		SetItem(1,'deptcode',sDept)
	
	/* 거래처 */
	Case "custcode"
		sCvcod = this.GetText()
		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE
			SetItem(1,"custcode",  		sCvcod)
			SetItem(1,"custname",		scvnas)
		END IF

	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"custcode",  		sCvcod )
			SetItem(1,"custname",		scvnas)			
		END IF
		

	/* 품번일 경우 */
  Case	"itnbr" 
	 sItnbr = Trim(this.GetText())
	 IF sItnbr ="" OR IsNull(sItnbr) THEN
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
	   Return
	 END IF
	
	 SELECT  "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC","ITNCT"."TITNM"
	   INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName
	   FROM "ITEMAS","ITNCT"
     WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
	        "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
	        "ITEMAS"."ITNBR" = :sItnbr AND
	        "ITEMAS"."USEYN" = '0' ;

	 IF SQLCA.SQLCODE <> 0 THEN
		this.PostEvent(RbuttonDown!)
		Return 2
	 END IF
	
	 SetItem(nRow,"itdsc", sItdsc)
	 SetItem(nRow,"ispec", sIspec)
/* 품명 */
  Case "itdsc"
	 sItdsc = trim(this.GetText())	
	 IF sItdsc ="" OR IsNull(sItdsc) THEN
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
	   Return
	 END IF
	 
	 SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITNBR"
 	   INTO :sittyp, :sitcls, :sItnbr
	   FROM "ITEMAS"  
	  WHERE "ITEMAS"."ITDSC" like :sItdsc||'%' AND "ITEMAS"."GBWAN" = 'Y' AND
		  ( "ITEMAS"."ITTYP" = '1' OR "ITEMAS"."ITTYP" = '3' OR "ITEMAS"."ITTYP" = '7' );

	 IF SQLCA.SQLCODE = 0 THEN
		SetItem(nRow,"itnbr",sItnbr)
		SetColumn("itnbr")
		
		TriggerEvent(ItemChanged!)
		Return 1
	ELSEIF SQLCA.SQLCODE = 100 THEN
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		Return 1
	ELSE
		Gs_CodeName = '품명'
		Gs_Code = sItdsc
		Gs_gubun = '%'
		
		open(w_itemas_popup5)
		
		if Isnull(Gs_Code) OR Gs_Code = "" then 
		  SetItem(nRow,'itnbr',sNull)
		  SetItem(nRow,'itdsc',sNull)
		  SetItem(nRow,'ispec',sNull)
		  Return 1
		end if
		
		SetItem(nRow,"itnbr",Gs_Code)
		SetColumn("itnbr")
		SetFocus()
		
		TriggerEvent(ItemChanged!)
		Return 1
	END IF
/* 규격 */
 Case "ispec"
	sIspec = trim(this.GetText())	
	IF sIspec = ""	or	IsNull(sIspec)	THEN
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		Return
	END IF

	SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITNBR"
	  INTO :sittyp, :sitcls, :sItnbr
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ISPEC" like :sIspec||'%' AND "ITEMAS"."GBWAN" = 'Y' AND
		  ( "ITEMAS"."ITTYP" = '1' OR "ITEMAS"."ITTYP" = '3' OR "ITEMAS"."ITTYP" = '7' );

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(nRow,"itnbr",sItnbr)
		this.SetColumn("itnbr")
		this.SetFocus()
		
		this.TriggerEvent(ItemChanged!)
		Return 1
	ELSEIF SQLCA.SQLCODE = 100 THEN
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		SetColumn("ispec")
		Return 1
	ELSE
		Gs_Code = sIspec
		Gs_CodeName = '규격'
		Gs_gubun = '%'
		
		open(w_itemas_popup5)
		
		if Isnull(Gs_Code) OR Gs_Code = "" then 
		  SetItem(nRow,'itnbr',sNull)
		  SetItem(nRow,'itdsc',sNull)
		  SetItem(nRow,'ispec',sNull)
		  this.SetColumn("ispec")
		  return 1
		end if
		
		SetItem(nRow,"itnbr",Gs_Code)
		SetColumn("itnbr")
		SetFocus()
		
		TriggerEvent(ItemChanged!)
		Return 1
	END IF
 case 'saupj' 
		STRING ls_return, ls_areacode , ls_steam, ls_deptcode
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.custcode[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 
		//창고
		f_child_saupj(dw_ip, 'depot', ls_saupj) 
		dw_ip.setitem(1, 'depot', '')
		
//		//관할 구역
//		f_child_saupj(dw_ip, 'areacode', ls_saupj)
//		ls_areacode = dw_ip.object.areacode[1] 
//		ls_return = f_saupj_chk_t('1' , ls_areacode ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'areacode', '')
//		End if
//		
//		//영업팀
//		f_child_saupj(dw_ip, 'deptcode', ls_saupj) 
//		ls_deptcode = dw_ip.object.deptcode[1] 
//		ls_return = f_saupj_chk_t('2' , ls_deptcode ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'deptcode', '')
//		End if 
		
		
END Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sitnbr, scvcod,sIpgu, sNull
Long   nRow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
/* 출고처 */
	Case 'custcode'
	  sIpgu  = Trim(GetItemString(1,'ipgu')) /* 출고구분 */
	  sCvcod = this.GetText()
	
	  Choose Case sIpgu
		 Case 'O12','O13','O14','O17'                         /* 부서 */
			open(w_dept_popup2)
		 Case 'O18'                                           /* 고객 */
			open(w_cust_popup)
		 Case 'O02'                                           /* 대리점 */
			open(w_agent_popup)
		 Case Else                                            /* 거래처 */
			gs_gubun = '1'
	      open(w_vndmst_popup)
	  End Choose
   
	  if gs_code = "" or isnull(gs_code) then return 
	
		SetItem(1,'deptcode',sNull)
		SetItem(1,'areacode',sNull)
		
	  this.setitem(1, 'custcode', gs_code)
	  this.setitem(1, 'custname', gs_codename)
     this.setcolumn("itnbr")
	  this.setfocus()
	  return 1
	  
  Case "itnbr"
	 gs_gubun = '1'
	 Open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)	 
  Case "itdsc"
 	 gs_gubun = '1'
	 gs_codename = this.GetText()
	 open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 SetColumn("itnbr")
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)
  Case "ispec"
	 gs_gubun = '1'
	 open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	 SetColumn("itnbr")
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)
end choose


end event

type dw_list from w_standard_print`dw_list within w_sal_03510
integer x = 41
integer y = 364
integer width = 4558
integer height = 1952
string dataobject = "d_sal_03510_02"
boolean border = false
boolean hsplitscroll = false
end type

type rb_1 from radiobutton within w_sal_03510
integer x = 3867
integer y = 252
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "제품별"
boolean checked = true
end type

event clicked;dw_list.setredraw(false)
dw_list.dataobject = 'd_sal_03510_02'
dw_print.dataobject = 'd_sal_03510_02_p'
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_list.setredraw(true)
end event

type rb_2 from radiobutton within w_sal_03510
integer x = 4256
integer y = 252
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "일자별"
end type

event clicked;dw_list.setredraw(false)
dw_list.dataobject = 'd_sal_03510_03'
dw_print.dataobject = 'd_sal_03510_03_p'
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_list.setredraw(true)
end event

type gb_1 from groupbox within w_sal_03510
integer x = 3849
integer y = 192
integer width = 768
integer height = 144
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "집계구분"
end type

type rr_1 from roundrectangle within w_sal_03510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 352
integer width = 4576
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

type cb_1 from commandbutton within w_sal_03510
boolean visible = false
integer x = 3771
integer y = 232
integer width = 352
integer height = 88
integer taborder = 30
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

type pb_1 from u_pb_cal within w_sal_03510
integer x = 585
integer y = 44
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

type pb_2 from u_pb_cal within w_sal_03510
integer x = 1019
integer y = 44
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

