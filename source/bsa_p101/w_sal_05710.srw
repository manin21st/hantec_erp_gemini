$PBExportHeader$w_sal_05710.srw
$PBExportComments$년간 판매목표 대 실적현황(제품)
forward
global type w_sal_05710 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05710
end type
end forward

global type w_sal_05710 from w_standard_print
string title = "년간 판매목표 대 실적현황(제품)"
rr_1 rr_1
end type
global w_sal_05710 w_sal_05710

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sGubun, yy, sT, sS, sP, sI, sym[11], sT_Name, sS_Name, sP_Name, sI_Name, sIttyp
Integer i, iYear, iMonth, iyy, imm

If dw_ip.AcceptText() <> 1 Then Return -1

sGubun = dw_ip.GetItemString(1,'gubun')
yy = Trim(dw_ip.GetItemString(1,'syy'))
sIttyp = Trim(dw_ip.GetItemString(1,'ittyp'))

If IsNull(sIttyp) Then sIttyp = ''

if	(yy = '') or isNull(yy) then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

// 영업팀 선택
sT = Trim(dw_ip.GetItemString(1,'steam'))
if isNull(sT) or (sT = '') then
	sT = ''
	sT_Name = '전  체'
else
	Select steamnm Into :sT_Name 
	From steam
	Where steamcd = :sT;
	if isNull(sT_Name) then
		sT_Name = ''
	end if
end if
sT = sT + '%'

// 관할구역 선택
sS = Trim(dw_ip.GetItemString(1,'sarea'))
if isNull(sS) or (sS = '') then
	sS = ''
	sS_Name = '전  체'
else
	Select sareanm Into :sS_Name 
	From sarea
	Where sarea = :sS;
	if isNull(sS_Name) then
		sS_Name = ''
	end if
end if
sS = sS + '%'

// 생산팀 선택
sP = Trim(dw_ip.GetItemString(1,'pdtgu'))
if isNull(sP) or (sP = '') then
	sP = ''
	sP_Name = '전  체'
else
   sP_Name = f_get_reffer('03', sP)
end if
sP = sP + '%'

// 품목분류 선택
sI = Trim(dw_ip.getItemString(1, 'itcls'))
if isNull(sI) or (sI = '') then
	sI = '%'
	sI_Name = '전  체'
else
	sI = sI + '%'
	sI_Name = Trim(dw_ip.GetItemString(1,'itclsnm'))
end if

//dw_list.object.r_yy.Text = yy + '년'
//dw_list.object.r_itcls.Text = sI_Name
//dw_list.object.r_pdtgu.Text = sP_Name
//
string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if sGubun = '1' then
   if dw_print.Retrieve(gs_sabu, yy,sIttyp+'%', sI, sP,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
      dw_ip.setfocus()
		dw_print.InsertRow(0)
//   	return -1
	else
		dw_print.sharedata(dw_list)
	end if
elseif sGubun = '2' then
	dw_print.object.r_steam.Text = sT_Name
   if dw_print.Retrieve(gs_sabu, yy, sT,sIttyp+'%', sI, sP,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('syy')
      dw_ip.setfocus()
		dw_print.InsertRow(0)
//   	return -1
	else
		dw_print.sharedata(dw_list)
	end if
else
   dw_print.object.r_steam.Text = sT_Name
   dw_print.object.r_sarea.Text = sS_Name
	if dw_print.Retrieve(gs_sabu, yy, sT, sS,sIttyp+'%', sI, sP,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('syy')
      dw_ip.setfocus()
		dw_print.InsertRow(0)
//   	return -1
	else
		dw_print.sharedata(dw_list)
	end if	
end if

return 1
end function

on w_sal_05710.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05710.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'syy',left(f_today(),4))
end event

type p_preview from w_standard_print`p_preview within w_sal_05710
end type

type p_exit from w_standard_print`p_exit within w_sal_05710
end type

type p_print from w_standard_print`p_print within w_sal_05710
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05710
end type







type st_10 from w_standard_print`st_10 within w_sal_05710
end type



type dw_print from w_standard_print`dw_print within w_sal_05710
string dataobject = "d_sal_05710_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05710
integer y = 20
integer width = 3534
integer height = 212
string dataobject = "d_sal_05710_01"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, sVndCod, sCvName, sCode, sName
String sItemCls, sItemGbn, sItemClsName, sPdtgu
Long   nRow

sCol_Name = This.GetColumnName()
SetNull(sNull)
nRow = GetRow()
If nRow <= 0 Then return

Choose Case sCol_Name
	Case "gubun"
		this.SetItem(1, 'itcls', sNull)
		this.SetItem(1, 'itclsnm', sNull)
		dw_list.SetRedraw(False)
		if this.GetText() = '1' then // 영업팀별 판매목표 대비 실적현황을 Click 했을 경우
			dw_list.DataObject = "d_sal_05710_02"
			dw_print.DataObject = "d_sal_05710_02_p"
		elseif this.GetText() = '2' then // 시리즈별 판매실적현황을 Click 했을 경우
			dw_list.DataObject = "d_sal_05710_03"
			dw_print.DataObject = "d_sal_05710_03_p"
		else                                  // 제품별 판매실적현황을 Click 했을 경우
			dw_list.DataObject = "d_sal_05710_04"
			dw_print.DataObject = "d_sal_05710_04_p"
		end if
		dw_print.Settransobject(sqlca)
		dw_list.Settransobject(sqlca)
		dw_list.SetRedraw(True)
		
	/* 생산팀 */
	Case "pdtgu"
		SetItem(nRow,'ittyp',sNull)
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."TITNM" ,"ITNCT"."PDTGU"
			  INTO :sItemClsName  , :sPdtgu
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				SetItem(1,"pdtgu",sPdtgu)
				SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		
		sItemClsName = GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
			sItemGbn = GetItemString(1,"ittyp")
			IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
				SELECT "ITNCT"."ITCLS","ITNCT"."PDTGU"
				  INTO :sItemCls, :sPdtgu
				  FROM "ITNCT"  
				 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
				IF SQLCA.SQLCODE <> 0 THEN
					TriggerEvent(RButtonDown!)
					Return 2
				ELSE
					SetItem(1,"pdtgu",sPdtgu)
					SetItem(1,"itcls",sItemCls)
			END IF
		END IF
end Choose
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "itcls"
		OpenWithParm(w_ittyp_popup, GetItemString(GetRow(),"ittyp"))
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",  str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	Case "itclsnm"
		OpenWithParm(w_ittyp_popup, GetItemString(GetRow(),"ittyp"))
		str_sitnct = Message.PowerObjectParm
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",   str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",   str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	/* ---------------------------------------- */
	Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"itnbr",gs_code)
		SetFocus()
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
END Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_05710
integer x = 55
integer y = 252
integer width = 4526
integer height = 2064
string dataobject = "d_sal_05710_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_05710
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 244
integer width = 4558
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

