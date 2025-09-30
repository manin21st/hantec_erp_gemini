$PBExportHeader$w_pdm_11745.srw
$PBExportComments$BOM 수정 이력 조회
forward
global type w_pdm_11745 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_11745
end type
end forward

global type w_pdm_11745 from w_standard_print
string title = "BOM 수정 이력 조회"
rr_1 rr_1
end type
global w_pdm_11745 w_pdm_11745

type variables
Datastore ds_list, ds_list2    //ds_list => 생산bom, ds_list2 => 기술bom

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sittyp, sitcls, sfitnbr, stitnbr, sdate, edate, &
       sgub, sgubun, newsort, sporgu, ls_rfna1, ls_rfna2     

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sGubun  = dw_ip.GetItemString(1,"gubun")  //생산(2)-기술(1)구분
sGub    = dw_ip.GetItemString(1,"gub")    //일자순(1),상위품번(2),하위품번(3)
sittyp  = dw_ip.GetItemString(1,"ittyp")
sitcls  = dw_ip.GetItemString(1,"fitcls")
sfitnbr = dw_ip.GetItemString(1,"fr_itnbr")
stitnbr = dw_ip.GetItemString(1,"to_itnbr")
sdate   = trim(dw_ip.GetItemString(1,"sdate"))
edate   = trim(dw_ip.GetItemString(1,"edate"))

sporgu  = dw_ip.GetItemString(1,"porgu")

SELECT "REFFPF"."RFNA1"  ,
       "REFFPF"."RFGUB"
Into :ls_rfna1, :ls_rfna2
FROM "REFFPF"  
WHERE ( "REFFPF"."SABU" = '1' ) AND  
      ( "REFFPF"."RFCOD" = 'AD' ) AND  
     ( "REFFPF"."RFGUB" NOT IN ('00','99') )
AND "REFFPF"."RFGUB" = :sporgu;

IF sittyp = "" OR IsNull(sittyp) THEN
	sittyp = '%'
end if	

IF sitcls = "" OR IsNull(sitcls) THEN
	sitcls = '%'
else
	sitcls = sitcls + '%'
end if	

IF sfitnbr ="" OR IsNull(sfitnbr) THEN
	sfitnbr = '.'
END IF
IF stitnbr ="" OR IsNull(stitnbr) THEN
	stitnbr = 'zzzzzzzzzzzzzzz'
END IF

if sfitnbr > stitnbr then 
	f_message_chk(34,'[품번]')
	dw_ip.Setcolumn('fr_itnbr')
	dw_ip.SetFocus()
	return -1
end if	

IF sdate ="" OR IsNull(sdate) THEN sdate = '10000101'
IF edate ="" OR IsNull(edate) THEN edate = '99991231'

if sdate > edate then 
	f_message_chk(34,'[변경일자]')
	dw_ip.Setcolumn('sdate')
	dw_ip.SetFocus()
	return -1
end if	

IF sgubun = '1' then 
	dw_list.DataObject = 'd_pdm_11745_2'
	dw_print.DataObject = 'd_pdm_11745_2_p'
ELSE
	dw_list.DataObject = 'd_pdm_11745_1'
	dw_print.DataObject = 'd_pdm_11745_1_p'
END IF	
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

if sgub = '1' then 
	newsort = "upd_date A, pinbr A, cinbr A"
elseif sgub = '2' then 
	newsort = "pinbr A, cinbr A, upd_date A"
elseif sgub = '3' then 
	newsort = "cinbr A, pinbr A, upd_date A"
end if	

if sporgu ='%' Then
	dw_print.object.t_20.text = '전체'
ElseIf sporgu = ls_rfna2 Then
	dw_print.object.t_20.text = ls_rfna1
End If

dw_list.SetSort(newsort)
dw_list.Sort()

IF dw_print.Retrieve(sdate, edate, sfitnbr, stitnbr, sittyp, sitcls, sporgu) <=0 THEN
	f_message_chk(50,"")
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1


end function

on w_pdm_11745.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11745.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;//dw_ip.setitem(1, 'sdate', is_today)
//
//dw_ip.SetFocus()
//
//ds_list  = create datastore
//ds_list2 = create datastore
//
//dw_hidden.settransobject(sqlca)
//
//If Isnull(gsbom) or trim(GsBom) = '' Then
//	Gsbom = 'NONE'
//End if
//
//
end event

event closequery;call super::closequery;//Destroy ds_list
//Destroy ds_list2
//
//gsBOM = ''
end event

type p_preview from w_standard_print`p_preview within w_pdm_11745
end type

type p_exit from w_standard_print`p_exit within w_pdm_11745
end type

type p_print from w_standard_print`p_print within w_pdm_11745
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11745
end type







type st_10 from w_standard_print`st_10 within w_pdm_11745
end type



type dw_print from w_standard_print`dw_print within w_pdm_11745
integer x = 4183
integer y = 208
string dataobject = "d_pdm_11745_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11745
integer x = 73
integer y = 32
integer width = 3854
integer height = 288
string dataobject = "d_pdm_11745"
end type

event dw_ip::rbuttondown;string sittyp
str_itnct lstr_sitnct

this.accepttext()
if this.GetColumnName() = 'fitcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"fclsnm", lstr_sitnct.s_titnm)
elseif this.GetColumnName() = 'fr_itnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
end if	


end event

event dw_ip::ue_pressenter;
Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;
Return 1
end event

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, sdate, sNull, sgub, newsort
int     ireturn

setnull(sNull)

IF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[변경일자 TO]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[변경일자 FROM]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'fitcls' then
	sItnbr = this.GetText()
   this.accepttext()	
	sispec = this.getitemstring(1, 'ittyp')
	
	ireturn = f_get_name2('품목분류', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fitcls", sitnbr)	
	this.setitem(1, "fclsnm", sitdsc)	
	RETURN ireturn
ELSEIF this.GetColumnName() = 'gub' then
	sGub = this.GetText()

	if sgub = '1' then 
		newsort = "upd_date A, pinbr A, cinbr A"
	elseif sgub = '2' then 
		newsort = "pinbr A, cinbr A, upd_date A"
	elseif sgub = '3' then 
		newsort = "cinbr A, pinbr A, upd_date A"
	end if	
	dw_list.SetSort(newsort)
   dw_list.Sort()

END IF
end event

event dw_ip::ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "fr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"fr_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	ELSEIF This.GetColumnName() = "to_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"to_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdm_11745
integer x = 96
integer y = 348
integer width = 4475
integer height = 1956
string dataobject = "d_pdm_11745_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdm_11745
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 340
integer width = 4507
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

