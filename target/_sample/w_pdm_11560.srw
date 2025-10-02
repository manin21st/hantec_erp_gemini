$PBExportHeader$w_pdm_11560.srw
$PBExportComments$** 품목현황
forward
global type w_pdm_11560 from w_standard_print
end type
type gb_1 from groupbox within w_pdm_11560
end type
type rb_1 from radiobutton within w_pdm_11560
end type
type rb_2 from radiobutton within w_pdm_11560
end type
type rb_3 from radiobutton within w_pdm_11560
end type
type cb_2 from commandbutton within w_pdm_11560
end type
end forward

global type w_pdm_11560 from w_standard_print
integer width = 4617
string title = "품목마스터 현황"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_2 cb_2
end type
global w_pdm_11560 w_pdm_11560

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sIttyp, sItcls, sItnbr, tx_name,sItdsc,sIspec, sUseYn, stitcls, sfilsk, spangbn, ls_porgu
String ls_sql, sItgu

If dw_ip.AcceptText() <> 1 Then Return -1
sIttyp  		= Trim(dw_ip.GetItemString(1,"ittyp"))
sItcls  		= Trim(dw_ip.GetItemString(1,"itcls"))
stItcls 		= Trim(dw_ip.GetItemString(1,"titcls"))
sItnbr  	= Trim(dw_ip.GetItemString(1,"itnbr"))
sItdsc  	= Trim(dw_ip.GetItemString(1,"itdsc"))
sIspec  	= Trim(dw_ip.GetItemString(1,"ispec"))
sUseYn  	= Trim(dw_ip.GetItemString(1,"useyn"))
sfilsk  		= Trim(dw_ip.GetItemString(1,"filsk"))
spangbn 	= Trim(dw_ip.GetItemString(1,"pangbn"))
ls_porgu	= dw_ip.GetItemString(1,"porgu")
sItgu    = Trim(dw_ip.GetItemString(1,"itgu"))

If Isnull(sIttyp) or sIttyp = '' Then
	sIttyp = '%'
//	f_message_chk(30,'[품목구분]')
//	dw_ip.setfocus()
//	return -1
End if

If Isnull(sItcls) Then sItcls = '.'
If Isnull(stItcls) Then 
	stItcls = 'zzzzzzz'
else
	stItcls = stItcls + 'zzzzzzz'
end if

If Isnull(sItnbr) Then sItnbr = ''
If Isnull(sItdsc) Then sItdsc = ''
If Isnull(sIspec) Then sIspec = ''
If Isnull(suseyn) or sUseyn = '3' Then sUseYn = ''
If Isnull(spangbn) or spangbn = '' Then spangbn = '%'
If IsNull(sItgu) OR sItgu = '' Then sItgu = '%'

//선택 조건에 따라 qcgub의 조건이 변경됨.
ls_sql = " select 	ITEMAS.ittyp, ITEMAS.itnbr, ITEMAS.itdsc, ITEMAS.ispec, " + &
					" decode(ITEMAS.ispec_code, null, ITEMAS.jijil, ITEMAS.jijil||'-'||ITEMAS.ispec_code) as jijil, " + &
					" ITEMAS.newits, ITEMAS.newite, " + &
					" ITEMAS.useyn, ITEMAS.gbdate, " + &
					" ITEMAS.filsk, 	ITEMAS.pangbn, ITEMAS.itgu, " + &
					" FUN_GET_ITMSHT('" + ls_porgu + "', ITEMAS.itnbr) AS ITM_SHTNM, " + &
					" DECODE(ITEMAS.ITTYP, '1', FUN_GET_CARCODE(ITEMAS.itnbr), FUN_GET_CARTYPE(ITEMAS.itnbr)) AS CARCODE, " + &
					" itnct.titnm, " + &
					" decode(nvl(routng.itnbr, 'N'), 'N', 'N', 'Y') as rout, " + &
					" itemas.yebi3, " + &
					" itemas.forfac " + &
					" from 	itemas, " + &
					"  		itnct, " + &
					"			routng " + &
					" where ITEMAS.ittyp like '" 	+ sIttyp + "' and " + &
					" ITEMAS.itcls between '" 	+ sItcls + "' and '" + stitcls + "'and " + &
      		 		" ITEMAS.itnbr like '" 		+ sItnbr+'%' + "' and " + &
					" nvl(ITEMAS.ispec, ' ') like '" + sIspec+'%' + "' and " + &
					" ITEMAS.useyn like '" 		+ sUseYn+'%'  + "' and " + &
					" nvl(ITEMAS.filsk, ' ') like '" + sfilsk + "' and " + &
					" nvl(ITEMAS.pangbn, ' ') like '" + spangbn +   "' and " + &
					" ITEMAS.ITGU  LIKE '" + sItgu + "' AND " + &
					" ITEMAS.ITTYP = ITNCT.ITTYP and " + &
					" ITEMAS.ITCLS = ITNCT.ITCLS and " + &
					" itemas.itnbr = routng.itnbr(+) and " + &
					" (ITNCT.PORGU = 'ALL' OR ITNCT.PORGU  like '" + ls_porgu + "' " + ' )' 

If rb_1.checked = True Then
	ls_sql = ls_sql + " and qcgub = '1' "
ElseIf rb_2.checked = True Then
	ls_sql = ls_sql + " and ( qcgub <> '1' or qcgub is null ) "
End If

ls_sql = ls_sql + " order by ittyp, ITEMAS.ITCLS, itnbr "

//dw_print.SetSQLSelect ( ls_sql )
dw_print.SetSQLSelect ( ls_sql )
dw_print.settransobject(sqlca)

IF dw_print.Retrieve() <=0 THEN
//IF dw_print.Retrieve(sIttyp, sItcls, stitcls, sItnbr+'%',sItdsc+'%',sIspec+'%',sUseYn+'%', sfilsk, spangbn) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('itcls')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)
// MessageBox("확인",String(dw_print.rowcount()))
//tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_itclsnm.text = '"+'('+sItcls+') '+tx_name+"'")

Return 1
end function

on w_pdm_11560.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.cb_2
end on

on w_pdm_11560.destroy
call super::destroy
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_2)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'porgu')


end event

event resize;r_1.width = this.width - 60
r_1.height = this.height - r_1.y - 65
dw_list.width = this.width - 70
dw_list.height = this.height - dw_list.y - 70
end event

type dw_list from w_standard_print`dw_list within w_pdm_11560
integer y = 416
integer width = 3963
integer height = 1964
string dataobject = "d_pdm_11560"
end type

type cb_print from w_standard_print`cb_print within w_pdm_11560
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_11560
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_11560
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_11560
end type

type dw_print from w_standard_print`dw_print within w_pdm_11560
integer x = 3479
integer y = 108
string dataobject = "d_pdm_11560_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11560
integer y = 56
integer width = 3963
integer height = 304
string dataobject = "d_pdm_11560_01"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sDateFrom,sDateTo,sSaleGu,snull
string  s_name,sIttyp,sItcls,get_nm,sItclsNm,sIspec

SetNull(snull)

Choose Case GetColumnName() 
/* 품목구분 */
 Case 'ittyp'
   This.setitem(1, 'itcls', snull)
   This.setitem(1, 'titcls', snull)
   This.setitem(1, 'itclsnm', snull)	
   This.setitem(1, 'itnbr', snull)
   This.setitem(1, 'itdsc', snull)
	This.setitem(1, 'ispec', snull)
///* 품목분류 */
// Case "itcls"
//   This.setitem(1, 'itnbr', snull)
//   This.setitem(1, 'itdsc', snull)
//	This.setitem(1, 'ispec', snull)
//	
//	s_name = Trim(this.gettext())
//	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
//	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
//	
//   IF s_name = "" OR IsNull(s_name) THEN 	
//     This.setitem(1, 'itclsnm', snull)
//	  RETURN 
//	END IF
//	
//   SELECT "ITNCT"."TITNM"  
//     INTO :get_nm  
//     FROM "ITNCT"  
//    WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
//          ( "ITNCT"."ITCLS" = :s_name ) ;
//
//   IF SQLCA.SQLCODE <> 0 THEN
//	  this.TriggerEvent(rbuttondown!)
//	  if isnull(lstr_sitnct.s_Ittyp) or lstr_sitnct.s_Ittyp = "" then 
//	    This.setitem(1, 'itcls', snull)
//	    This.setitem(1, 'itclsnm', snull)
//		 RETURN 1
//     else
//	    this.SetItem(1,"ittyp",lstr_sitnct.s_Ittyp)
//		 this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
//		 this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
//       Return 1			
//     end if
//   ELSE
//	  this.SetItem(1, 'ittyp',sIttyp)
//	  This.setitem(1, 'itclsnm', get_nm)
//   END IF	
/* 품번 */
Case 'itnbr'
	s_name = trim(this.GetText())
	IF s_name = '' or	IsNull(s_name)	THEN
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 
	END IF
	
	SELECT "ITEMAS"."ITDSC","ITEMAS"."ISPEC", "ITEMAS"."ITTYP",
	       "ITEMAS"."ITCLS","ITNCT"."TITNM"
	  INTO :get_nm, :sIspec, :sIttyp, :sItcls, :sItclsNm
	  FROM "ITEMAS"  ,"ITNCT"
	 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
	       "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
	       "ITEMAS"."ITNBR" = :s_name ;
	
	IF sqlca.sqlcode <> 0 THEN
		f_message_chk(33, "[품번]" )
		this.setitem(1, "itnbr", snull)
		this.setitem(1, "itdsc", snull)
		this.setitem(1, "ispec", snull)
		RETURN 1
	ELSE
		this.setitem(1, "itdsc", get_nm)
		this.setitem(1, "ittyp", sIttyp)
		this.setitem(1, "itcls", sItcls)
		this.setitem(1, "itclsnm", sItclsnm)
		this.setitem(1, "ispec", sIspec)
	END IF
END Choose
end event

event dw_ip::rbuttondown;String sittyp

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)


if this.GetColumnName() = 'itcls'  then
	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
	
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'titcls'  then
	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
	
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"titcls", lstr_sitnct.s_sumgub)
elseIf this.GetColumnName() = 'itnbr' then
	Gs_gubun = Trim(GetItemString(GetRow(),'ittyp'))
	If Gs_gubun = '' Or IsNull(Gs_gubun) Then Gs_gubun = '1'
	open(w_itemas_popup)
   
	if gs_code = "" or isnull(gs_code) then return 
		
	this.setitem(1, 'itnbr', gs_code)
   TriggerEvent(ItemChanged!)
End If

end event

event dw_ip::ue_key;call super::ue_key;string sCol
str_itnct str_sitnct

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3) 
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	
end event

type r_1 from w_standard_print`r_1 within w_pdm_11560
integer y = 412
integer width = 3971
end type

type r_2 from w_standard_print`r_2 within w_pdm_11560
integer width = 3971
integer height = 312
end type

type gb_1 from groupbox within w_pdm_11560
integer x = 2455
integer y = 128
integer width = 1001
integer height = 188
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "none"
end type

type rb_1 from radiobutton within w_pdm_11560
boolean visible = false
integer x = 4736
integer y = 16
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "검사품"
boolean lefttext = true
end type

type rb_2 from radiobutton within w_pdm_11560
boolean visible = false
integer x = 4759
integer y = 92
integer width = 302
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "비검사품"
boolean lefttext = true
end type

type rb_3 from radiobutton within w_pdm_11560
boolean visible = false
integer x = 4754
integer y = 192
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체"
boolean checked = true
boolean lefttext = true
end type

type cb_2 from commandbutton within w_pdm_11560
integer x = 4018
integer y = 188
integer width = 535
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "제조공정도 보기"
end type

event clicked;String ls_itnbr

ls_itnbr = dw_list.GetItemString(dw_list.GetRow(), 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then
	MessageBox('품번확인', '품번을 확인 하십시오!')
	Return
End If

String ls_path

/* 파일서버 경로 가져오기 */
// 경로 지정 방식 변경 BY SHJEON 20120920
select dataname into :ls_path from syscnfg
 where sysgu = 'C' and serial = 12 and lineno = '4' ;


//ls_path = '\\10.206.21.101\public\생산팀\제조공정도(erp_up_용)\MIP생산\' + ls_itnbr + '.xls'
//st_3.Text = ls_path
ls_path = ls_path + ls_itnbr + '.xls'

if FileExists(ls_path) Then
	//
else
	messagebox('확인','해당 품번으로 제조공정도 파일이 존재하지 않습니다.')
	return
end if	

String ls_reg
Long   ll_rtn

ll_rtn = RegistryGet('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Excel.XLL\shell\Open\command\', '', RegString!, ls_reg)
If ll_rtn < 0 Then
	MessageBox('엑셀 프로그램 확인', 'Excel Program이 정상적으로 설치 되었는지 확인 하십시오')
	Return
End If

Run(ls_reg + 'Excel.EXE /r' + ' ' + ls_path, Maximized!)



end event

