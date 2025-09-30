$PBExportHeader$w_pdm_01557.srw
$PBExportComments$생산bom(대량추가 )
forward
global type w_pdm_01557 from window
end type
type cbx_1 from checkbox within w_pdm_01557
end type
type p_exit from uo_picture within w_pdm_01557
end type
type p_can from uo_picture within w_pdm_01557
end type
type p_inq from uo_picture within w_pdm_01557
end type
type st_1 from statictext within w_pdm_01557
end type
type dw_to from datawindow within w_pdm_01557
end type
type dw_from from datawindow within w_pdm_01557
end type
type dw_2 from datawindow within w_pdm_01557
end type
type rr_1 from roundrectangle within w_pdm_01557
end type
type p_mod from uo_picture within w_pdm_01557
end type
type p_add from uo_picture within w_pdm_01557
end type
type p_del from uo_picture within w_pdm_01557
end type
end forward

global type w_pdm_01557 from window
integer x = 96
integer y = 136
integer width = 3817
integer height = 2068
boolean titlebar = true
string title = "품목별 대량추가/삭제"
windowtype windowtype = response!
long backcolor = 32106727
cbx_1 cbx_1
p_exit p_exit
p_can p_can
p_inq p_inq
st_1 st_1
dw_to dw_to
dw_from dw_from
dw_2 dw_2
rr_1 rr_1
p_mod p_mod
p_add p_add
p_del p_del
end type
global w_pdm_01557 w_pdm_01557

type variables
string  is_gubun
long   d1_currentRow, d2_currentRow
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_check (string spinbr, string scinbr)
end prototypes

public function integer wf_check (string spinbr, string scinbr);//Long	  L_count
//
///* 상위Loop 검색 */
//L_count = 0
//select count(*)
//  Into :L_count
//  from (select level, Spinbr, Scinbr
//		  from pstruc
//		 connect by  prior Spinbr = Scinbr
//		 start with Scinbr = :sSpinbr) a
// where a.Spinbr = :sScinbr;
// 
// If L_count > 0 Then Return -1
// 
//
///* 하위 Loop 검색 */
//L_count = 0
//select count(*)
//  Into :L_count
//  from (select level, Spinbr, Scinbr
//		  from pstruc
//		 connect by  prior Scinbr = Spinbr
//		 start with Spinbr =  :sSpinbr) a
// where a.Scinbr = :sScinbr;
// 
// If L_count > 0 Then Return -2
//
//L_count = 0
//Select count(*)
//  into :l_count
//  from pstruc
// where Spinbr = :sSpinbr
// 	and Scinbr = :sScinbr;
// If L_count > 0 Then Return -3	 
// 

//====================================================================
// NEW 처리..
//====================================================================


// 1) 역전개 다단계 검색
//    상위품번을 기준으로 구성하려는 하위품번이 상위에 존재하는가에 대한 검색(다단계)
// 2) 상위, 하위가 가상품번인지를 검색한다.(두개다 가상인 경우 return)

integer Li_count
String  sitem, sname, snull, sopseq

Setnull(snull)


Li_count = 0
select count(*)
  Into :Li_count
  from (select level, pinbr, cinbr
		  from pstruc
		 connect by  prior pinbr = cinbr
		 start with cinbr = :Spinbr) a
 where a.pinbr = :Scinbr;	


if  Li_count > 0 	then      // 하위품번이 상위에 구성되어 있으면
    messagebox("하위품번", "구성하려고 하는 하위품번이 상위에 구성되어 있습니다", stopsign!)
    dw_2.setfocus()
    return -1
end if


Li_count = 0

SELECT COUNT(*) 
  INTO :Li_count 
  FROM ITEMAS 
 WHERE ITNBR IN (:Spinbr, :Scinbr) AND ITTYP = '8' ;

if  Li_count > 1 	then      // 상/하위가 가상품목인 경우 바로 return
    messagebox("하위품번", "상위 / 하위 품목이 가상품번입니다. 품목을 확인하세요!", stopsign!)
    dw_2.setfocus()
    return -1
end if




return 0
end function

event open;
f_window_center_response(this)

dw_from.settransobject(sqlca)
dw_to.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_from.InsertRow(0)
dw_to.InsertRow(0)


if isnull(gs_code) or gs_code = '' then return
dw_from.setitem(1,'itnbr', gs_code)
dw_from.triggerevent(itemchanged!)
p_inq.triggerevent(clicked!)
end event

on w_pdm_01557.create
this.cbx_1=create cbx_1
this.p_exit=create p_exit
this.p_can=create p_can
this.p_inq=create p_inq
this.st_1=create st_1
this.dw_to=create dw_to
this.dw_from=create dw_from
this.dw_2=create dw_2
this.rr_1=create rr_1
this.p_mod=create p_mod
this.p_add=create p_add
this.p_del=create p_del
this.Control[]={this.cbx_1,&
this.p_exit,&
this.p_can,&
this.p_inq,&
this.st_1,&
this.dw_to,&
this.dw_from,&
this.dw_2,&
this.rr_1,&
this.p_mod,&
this.p_add,&
this.p_del}
end on

on w_pdm_01557.destroy
destroy(this.cbx_1)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_inq)
destroy(this.st_1)
destroy(this.dw_to)
destroy(this.dw_from)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.p_mod)
destroy(this.p_add)
destroy(this.p_del)
end on

type cbx_1 from checkbox within w_pdm_01557
integer x = 2656
integer y = 180
integer width = 384
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;Long Lrow

If this.Checked = True Then
	For Lrow = 1 to dw_2.rowcount()
  		 dw_2.Setitem(Lrow, "opt", 'Y')
	Next
Else
	For Lrow = 1 to dw_2.rowcount()
		 dw_2.Setitem(Lrow, "opt", 'N')
	Next
End if
end event

type p_exit from uo_picture within w_pdm_01557
integer x = 3589
integer y = 44
integer width = 178
integer taborder = 80
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;
close(parent)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_pdm_01557
integer x = 3415
integer y = 44
integer width = 178
integer taborder = 70
boolean bringtotop = true
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;String snull

SetNull(snull)

dw_from.enabled = true
dw_to.enabled   = true
cbx_1.enabled = true

dw_2.reset()

dw_from.setcolumn('itnbr')
dw_from.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_inq from uo_picture within w_pdm_01557
integer x = 3067
integer y = 44
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sIttyp, sitcls, ls_gritu, sjakgu
String sItnbr

String sold_sql, swhere_clause, snew_sql


if dw_from.AcceptText() = -1 then return 
if dw_to.AcceptText() = -1 then return 

sItnbr = dw_from.GetItemString(1,"itnbr")
sIttyp = dw_to.GetItemString(1,"ittyp")
sItcls = dw_to.GetItemString(1,"itcls")
sjakgu = dw_to.GetItemString(1,"jakgu")

ls_gritu = dw_to.GetItemString(1,"itemas_gritu")  // 모델코드

if sjakgu <> '3' then
	IF sItnbr ="" OR IsNull(sItnbr) THEN
		Messagebox("확 인","복사원 품번을 입력하세요!!")
		dw_from.setcolumn('itnbr')
		dw_from.setfocus()
		Return
	END IF
end if

IF sIttyp ="" OR IsNull(sIttyp) THEN
	f_message_chk(30,'[품목구분]')
	dw_to.Setcolumn('ittyp')
	dw_to.SetFocus()
	return
END IF

IF sItcls ="" OR IsNull(sItcls) THEN
	f_message_chk(30,'[품목분류]')
	dw_to.Setcolumn('itcls')
	dw_to.SetFocus()
	return
ELSE
	sItcls = sItcls + '%'
END IF


if sjakgu = '1' then
	sold_sql = &
				"  select A.ITNBR, ltrim(A.ITDSC)||' '||ltrim(a.ispec)||' '||ltrim(a.jijil) as itdsc,  "+&
				"   'N' AS OPT,   "+&
				"   1 as qtypr, '9999' as opsno, to_char(sysdate, 'yyyymmdd') as efrdt, '99991231' as eftdt, 'Y' as bomend  "+&
				  "    FROM ITEMAS A   " + &
				  "   WHERE ( A.GBWAN = 'Y' ) AND  " + &
				  "         ( A.USEYN = '0' )   " 
	  
	
	swhere_clause = ""
	
	IF not ( sIttyp ="" OR IsNull(sIttyp) )  THEN
		swhere_clause	= swhere_clause + "   AND  ( A.ITTYP = '" + sIttyp + "' ) " 
	end if
	
	IF not ( sItcls ="" OR IsNull(sItcls) ) THEN
		swhere_clause	= swhere_clause +	"   AND   ( A.ITCLS like '" + sitcls + "'  ) "
	end if
	
	// 모델코드 범한 추가(2001.04.11)
	IF not (ls_gritu ="" OR IsNull(ls_gritu) ) THEN
		ls_gritu = "%" + ls_gritu + "%"
		swhere_clause	= swhere_clause + "        AND ( A.GRITU like '" + ls_gritu  +"' ) "
	END IF
	
	
	IF not (sItnbr ="" OR IsNull(sItnbr) )  THEN
		swhere_clause	= swhere_clause + "      AND  ( A.ITNBR  <> '" + sitnbr + "' ) " 	
	end if 
	
	snew_sql = sold_sql + swhere_clause

	dw_2.SetSqlSelect(snew_sql)
	dw_2.settransobject(sqlca)
		
	if dw_2.Retrieve() > 0 then
		dw_from.enabled = false
		dw_to.enabled = false
	Else
		Messagebox("조회", "조회 할 자료가 없읍니다", stopsign!)
	End if
Elseif sjakgu = '2' then
	if dw_2.Retrieve(sitnbr, sittyp, sitcls) > 0 then
		dw_from.enabled = false
		dw_to.enabled = false
	Else
		Messagebox("조회", "조회 할 자료가 없읍니다", stopsign!)
	End if
Elseif sjakgu = '3' then
	if dw_2.Retrieve(sittyp, sitcls) > 0 then
		dw_from.enabled = false
		dw_to.enabled = false
		cbx_1.enabled = false
	Else
		Messagebox("조회", "조회 할 자료가 없읍니다", stopsign!)
	End if	
End if

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

type st_1 from statictext within w_pdm_01557
integer x = 105
integer y = 268
integer width = 206
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "복사처"
boolean focusrectangle = false
end type

type dw_to from datawindow within w_pdm_01557
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 73
integer y = 320
integer width = 3424
integer height = 80
integer taborder = 30
string dataobject = "d_pdm_01557_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;str_itnct str_sitnct

setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" OR This.GetColumnName() = "ittyp" Then
		this.accepttext()
		gs_code = this.getitemstring(1, 'ittyp')
		
		open(w_ittyp_popup2)
		
		str_sitnct = Message.PowerObjectParm	
		
		if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
			return
		end if
	
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp)
		this.SetItem(1,"itcls", str_sitnct.s_sumgub)
		this.SetItem(1,"itnm", str_sitnct.s_titnm)
		this.SetColumn('itcls')
      dw_2.reset()
		this.SetFocus()
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	s_Itcls, s_Name, s_itt, snull, ls_gritu, ls_gritu_name
int      ireturn 

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_2.reset()
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_2.reset()
   end if
	
ELSEIF this.GetColumnName() = "itcls"	THEN
	
	s_itcls = this.gettext()
	
   s_itt  = this.getitemstring(1, 'ittyp')
	
   ireturn = f_get_name2('품목분류2', 'Y', s_itcls, s_name, s_itt)
	
	This.setitem(1, 'itcls', s_itcls)
   This.setitem(1, 'itnm', s_name)
	
   dw_2.reset()
	
//	return ireturn 
	return 1 	
	
elseif this.GetColumnName() = 'itemas_gritu' THEN  // 모델코드
	
	ls_gritu = this.gettext()
 
   IF ls_gritu = "" OR IsNull(ls_gritu) THEN 
		this.SetItem(1,'itemas_gritu', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)		
      dw_2.reset()
		RETURN
   END IF
	
	ls_gritu_name = f_get_reffer('01', ls_gritu)
	
	if isnull(ls_gritu_name) or ls_gritu_name = "" then
		this.SetItem(1,'itemas_gritu', snull)
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_2.reset()
   end if	
elseif this.getcolumnname() = 'jakgu' then
	s_name = gettext()
	if s_name = '1' then                    //   추가
		p_add.visible = True
		p_mod.visible = False
		p_del.visible = False
		
		dw_2.dataobject = 'd_pdm_01557_3'
		dw_2.settransobject(sqlca)
	Elseif s_name = '2' then                //   삭제     
		p_del.visible = True
		p_add.visible = False
		p_mod.visible = False
		
		dw_2.dataobject = 'd_pdm_01557_4'
		dw_2.settransobject(sqlca)		
	Elseif s_name = '3' then			  		 //   수정     
		p_mod.visible = True
		p_add.visible = False
		p_del.visible = False
		
		dw_2.dataobject = 'd_pdm_01557_5'
		dw_2.settransobject(sqlca)				
	end if	
END IF

end event

event rbuttondown;string sname

if this.GetColumnName() = 'itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
   dw_2.reset()
	this.SetFocus()
end if	
end event

event itemerror;RETURN 1
end event

type dw_from from datawindow within w_pdm_01557
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 14
integer y = 4
integer width = 2656
integer height = 260
integer taborder = 10
string dataobject = "d_pdm_01557_0"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
		
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sitnbr, sitdsc, sispec
integer ii, ireturn
 
IF this.getcolumnname() = "itnbr"	THEN
	this.accepttext()
	sitnbr = this.getitemstring(1, "itnbr")
	ireturn = f_get_name2('품번', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
   dw_2.reset()
	return ireturn
elseIF this.getcolumnname() = "itdsc"	THEN
	this.accepttext()
	sitdsc = this.getitemstring(1, "itdsc")
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
   dw_2.reset()
	return ireturn
ELSEIF this.getcolumnname() = "ispec"	THEN
	this.accepttext()
	sispec = this.getitemstring(1, "ispec")
	ireturn = f_get_name2('규격', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
   dw_2.reset()
	return  ireturn
end if



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
	
	this.TriggerEvent(ItemChanged!)
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	this.TriggerEvent(ItemChanged!)
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	this.TriggerEvent(ItemChanged!)
	
END IF
end event

event itemerror;return 1
end event

type dw_2 from datawindow within w_pdm_01557
integer x = 78
integer y = 400
integer width = 3657
integer height = 1524
string dataobject = "d_pdm_01557_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;string scinbr, spinbr, sdata, sjakgu
long lrow, lcnt
integer ii
decimal {4} dqty

Lrow = getrow()
scinbr = dw_from.getitemstring(1, "itnbr")
sjakgu = dw_to.getitemstring(1, "jakgu")
if sjakgu = '2' then return

if Lrow <  1 then
	return 
end if

if sjakgu = '1' then
	if isnull(scinbr) or trim(scinbr) = '' then
		Messagebox("추가/삭제품번", "품번을 먼저 입력하신후 작업하십시요")
		setitem(Lrow, "opt", 'N')
		return 1
	End if
end if

if this.getcolumnname() = 'opt' then
	sdata = gettext()
	if sdata = 'Y' then
		spinbr = getitemstring(Lrow, "itnbr")
		ii =  wf_check(spinbr, scinbr) 
		if ii = -1 then
			Messagebox("Loop Error", "상위에 해당품목이 존재합니다", stopsign!)
		Elseif ii = -2 then
			Messagebox("Loop Error", "하위에 해당품목이 존재합니다", stopsign!)		
		Elseif ii = -3 then
			Messagebox("Loop Error", "해당품목이 존재합니다", stopsign!)			
		End if
			
			
		if ii <> 0 then
			setitem(Lrow, "opt", 'N')
			return 1		
		End if
	end if
Elseif this.getcolumnname() = 'qtypr' then
	dqty = dec(gettext())
	if dqty <= 0 then
		setitem(lrow, "qtypr", 1)
		Messagebox("구성수량", "구성수량을 입력하십시요", stopsign!)
		return 1
	end if
Elseif this.getcolumnname() = 'opsno' then
	sdata  = gettext()
	spinbr = getitemstring(Lrow, "itnbr")
	if sdata <> '9999' then
		lcnt = 0
		Select count(*) into :lcnt from routng where itnbr = :spinbr and opseq = :sdata;
		if lcnt = 0  then
			Messagebox("표준공정", "표준공정이 부정확합니다.", stopsign!)
			setitem(Lrow, "opsno", '9999')
			return 1
		end if		
	End if
Elseif this.getcolumnname() = 'efrdt' then
	sdata  = gettext()
	if f_datechk(sdata) = -1 then
		Messagebox("유효시작", "시작일이 부정확합니다.", stopsign!)
		setitem(Lrow, "efrdt", f_today())
		return 1
	End if	
Elseif this.getcolumnname() = 'eftdt' then
	sdata  = gettext()
	if f_datechk(sdata) = -1 then
		Messagebox("유효시작", "시작일이 부정확합니다.", stopsign!)
		setitem(Lrow, "eftdt", '99991231')
		return 1
	End if		
End if
end event

event itemerror;return 1
end event

event rbuttondown;long Lrow 
lrow = row

if this.getcolumnname() =  "opsno" then
	OpenWithParm(w_routng_popup,this.GetItemString(lrow,"itnbr"))
	if isnull(gs_code) or trim(gs_code) = '' then
		this.SetItem(lrow,"opsno",'9999')		
	else
		this.SetItem(lrow,"opsno",Gs_Code)
	end if
	triggerevent(itemchanged!)
End If	
end event

type rr_1 from roundrectangle within w_pdm_01557
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 292
integer width = 3712
integer height = 1652
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_mod from uo_picture within w_pdm_01557
boolean visible = false
integer x = 3241
integer y = 44
integer width = 178
integer taborder = 40
string picturename = "C:\erpman\image\수정_up.gif"
end type

event clicked;call super::clicked;string	scinbr, spinbr, sjakgu, smaxno, sopsno, sefrdt, seftdt, sbomend
long		lRow, lrow2, cur_row, lmaxno
integer  ii, jj, kk, ll, aa
decimal {4} dqtypr

IF	dw_from.AcceptText() = -1	THEN	RETURN
IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

scinbr = trim(dw_from.GetItemString(1, "itnbr"))
sjakgu = trim(dw_to.GetItemString(1, "jakgu"))

if sjakgu = '1' or sjakgu = '2' then
	IF scinbr ="" OR IsNull(scinbr) THEN
		Messagebox("확 인","품번을 입력하세요!!")
		dw_from.setcolumn('itnbr')
		dw_from.setfocus()
		Return
	END IF
end if

aa = 0
jj = 0
kk = 0
ll = 0

IF dw_2.RowCount() < 1	THEN	return  

if dw_2.update() = 1 then
	commit;
	MESSAGEBOX("수정","자료가 수정되었읍니다", information!)
else
	rollback;
	MESSAGEBOX("수정","저장시 Error발생", information!)	
	return
end if

COMMIT ;
p_can.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\수정_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\수정_up.gif"
end event

type p_add from uo_picture within w_pdm_01557
integer x = 3241
integer y = 44
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;string	scinbr, spinbr, sjakgu, smaxno, sopsno, sefrdt, seftdt, sbomend
long		lRow, lrow2, cur_row, lmaxno
integer  ii, jj, kk, ll, aa
decimal  {4} dqtypr

IF	dw_from.AcceptText() = -1	THEN	RETURN
IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

scinbr = trim(dw_from.GetItemString(1, "itnbr"))
sjakgu = trim(dw_to.GetItemString(1, "jakgu"))

if sjakgu = '1' or sjakgu = '2' then
	IF scinbr ="" OR IsNull(scinbr) THEN
		Messagebox("확 인","품번을 입력하세요!!")
		dw_from.setcolumn('itnbr')
		dw_from.setfocus()
		Return
	END IF
end if

aa = 0
jj = 0
kk = 0
ll = 0

IF dw_2.RowCount() < 1	THEN	return  

IF MessageBox("확인", "자료를 추가 하시겠습니까?", question!, yesno!) = 2	THEN	
	RETURN
End if

SetPointer(HourGlass!)

FOR lRow = 1	TO	 dw_2.RowCount()   //품번을 읽고
	if dw_2.getitemstring(lrow, 'opt') = 'Y' then   //체크품번만 복사
		spinbr = dw_2.GetItemString(lRow, "itnbr")
		
		aa++
		
		// check
		ii = 0
		ii = wf_check(spinbr, scinbr)
		if ii = -1 then
			jj++
		Elseif ii = -2 then
			kk++
		Elseif ii = -3 then
			ll++
		End if
		
		if ii = 0 then
			// 최대번호를 구한후 10씩 증가시킨다.
			SetNull(smaxno)
			select max(usseq) into :smaxno from pstruc 
			 Where pinbr = :spinbr;
			if isnull( smaxno ) then
				smaxno = '00010'
			Else
				lmaxno = dec(smaxno)	+ 10		
				smaxno = string(lmaxno, '00000')
			End if
			
			dqtypr  = dw_2.getitemdecimal(Lrow, "qtypr")
			sopsno  = dw_2.getitemstring(Lrow,  "opsno")
			sefrdt  = dw_2.getitemstring(Lrow,  "efrdt")
			seftdt  = dw_2.getitemstring(Lrow,  "eftdt")
			sbomend = dw_2.getitemstring(Lrow,  "bomend")				
			
			insert into pstruc (pinbr, cinbr, usseq, qtypr, adtin, opsno, efrdt, eftdt, gubun, bomend, gubun2)
							values (:spinbr,:scinbr,:smaxno,:dqtypr,0,     :sopsno,:sefrdt,:seftdt,'1',   :sbomend,'Y');
			if sqlca.sqlcode <> 0 then
				messagebox("Insert Error", sqlca.sqlerrtext + ' ' + string(sqlca.sqlcode), stopsign!)
				rollback;
				return
			end if				
						
		End if

	end if	
NEXT

MessageBox("처리결과", "전체  선택 건수 : " + string(aa) + '~n' + &
							  "상위Loop  Error : " + string(jj) + '~n' + &
							  "하위Loop  Error : " + string(kk) + '~n' + &
							  "Duplicate Error : " + string(ll) + '~n' + &
							  "정상  처리 건수 : " + string(aa - (jj + kk + ll)) + " 가 처리되었읍니다", information!)

COMMIT ;
p_can.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type p_del from uo_picture within w_pdm_01557
boolean visible = false
integer x = 3241
integer y = 44
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;string	scinbr, spinbr, sjakgu, smaxno, sopsno, sefrdt, seftdt, sbomend
long		lRow, lrow2, cur_row, lmaxno
integer  ii, jj, kk, ll, aa
decimal {4} dqtypr

IF	dw_from.AcceptText() = -1	THEN	RETURN
IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

scinbr = trim(dw_from.GetItemString(1, "itnbr"))
sjakgu = trim(dw_to.GetItemString(1, "jakgu"))

if sjakgu = '1' or sjakgu = '2' then
	IF scinbr ="" OR IsNull(scinbr) THEN
		Messagebox("확 인","품번을 입력하세요!!")
		dw_from.setcolumn('itnbr')
		dw_from.setfocus()
		Return
	END IF
end if

aa = 0
jj = 0
kk = 0
ll = 0

IF dw_2.RowCount() < 1	THEN	return  

FOR lRow = 1	TO	 dw_2.RowCount()   //품번을 읽고
	if dw_2.getitemstring(lrow, 'opt') = 'Y' then   //체크품번만 복사
		spinbr = dw_2.GetItemString(lRow, "itnbr")		
		aa++
		
		Delete from pstruc
		 Where pinbr = :spinbr And cinbr = :sCinbr;
		if sqlca.sqlcode <> 0 then
			messagebox("Insert Error", sqlca.sqlerrtext + ' ' + string(sqlca.sqlcode), stopsign!)
			rollback;
			return
		end if 
		
		MessageBox("처리결과", "전체  선택 건수 : " + string(aa) +  " 가 삭제되었읍니다", information!)			
		
	End if			
Next

COMMIT ;
p_can.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

