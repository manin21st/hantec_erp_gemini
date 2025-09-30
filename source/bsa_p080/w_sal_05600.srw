$PBExportHeader$w_sal_05600.srw
$PBExportComments$월별 판매실적 현황(영업팀별)
forward
global type w_sal_05600 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05600
end type
end forward

global type w_sal_05600 from w_standard_print
string title = "월별 판매실적 현황(영업팀별)"
rr_1 rr_1
end type
global w_sal_05600 w_sal_05600

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sGubun, ym, sT, sS, sV, sP, sI, sym[11], sT_Name, sS_Name, sV_Name, sP_Name, sI_Name
Integer i
double    lYear, lMonth, lyy, lmm

If dw_ip.AcceptText() <> 1 then Return -1

sGubun = dw_ip.GetItemString(1,'gubun')
ym     = Trim(dw_ip.GetItemString(1,'sym'))

if	(ym = '') or isNull(ym) then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.setcolumn('sym')
	dw_ip.setfocus()
	Return -1
end if

lYear  = Long(Left(ym,4))
lMonth = Long(Right(ym,2))

// 영업팀 선택
sT = Trim(dw_ip.GetItemString(1,'deptcode'))
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
sS = Trim(dw_ip.GetItemString(1,'areacode'))
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
// 거래처 선택
sV = Trim(dw_ip.GetItemString(1,'custcode'))
if isNull(sV) or (sV = '') then
	sV = '%'
	sV_Name = '전  체'
else
	sV = sV + '%'
	sV_Name = Trim(dw_ip.GetItemString(1,'custname'))
end if
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

for i = 1 to 11 
	if lMonth - i < 1 then
		lyy = lYear - 1
		lmm = 12 + (lMonth - i)
	else
		lyy = lYear
		lmm = lMonth - i
	end if
	sym[i] = String(lyy) + Mid('0' + String(lmm), Len(String(lmm)), 2)
next	

dw_print.object.r_ym.Text = Left(ym,4) + '.' + Right(ym,2)
dw_print.object.r_steam.Text = sT_Name
dw_print.object.r_sarea.Text = sS_Name
dw_print.object.r_cvcod.Text = sV_Name
dw_print.object.r_pdtgu.Text = sP_Name
dw_print.object.r_itcls.Text = sI_Name
dw_print.object.r_ym11.Text  = Left(sym[11],4) + '.' + Right(sym[11],2)
dw_print.object.r_ym10.Text  = Left(sym[10],4) + '.' + Right(sym[10],2)
dw_print.object.r_ym9.Text   = Left(sym[9],4) + '.' + Right(sym[9],2)
dw_print.object.r_ym8.Text   = Left(sym[8],4) + '.' + Right(sym[8],2)
dw_print.object.r_ym7.Text   = Left(sym[7],4) + '.' + Right(sym[7],2)
dw_print.object.r_ym6.Text   = Left(sym[6],4) + '.' + Right(sym[6],2)
dw_print.object.r_ym5.Text   = Left(sym[5],4) + '.' + Right(sym[5],2)
dw_print.object.r_ym4.Text   = Left(sym[4],4) + '.' + Right(sym[4],2)
dw_print.object.r_ym3.Text   = Left(sym[3],4) + '.' + Right(sym[3],2)
dw_print.object.r_ym2.Text   = Left(sym[2],4) + '.' + Right(sym[2],2)
dw_print.object.r_ym1.Text   = Left(sym[1],4) + '.' + Right(sym[1],2)
dw_print.object.r_ym0.Text   = Left(ym,4) + '.' + Right(ym,2)

dw_list.object.r_ym.Text = Left(ym,4) + '.' + Right(ym,2)
dw_list.object.r_steam.Text = sT_Name
dw_list.object.r_sarea.Text = sS_Name
dw_list.object.r_cvcod.Text = sV_Name
dw_list.object.r_pdtgu.Text = sP_Name
dw_list.object.r_itcls.Text = sI_Name
dw_list.object.r_ym11.Text  = Left(sym[11],4) + '.' + Right(sym[11],2)
dw_list.object.r_ym10.Text  = Left(sym[10],4) + '.' + Right(sym[10],2)
dw_list.object.r_ym9.Text   = Left(sym[9],4) + '.' + Right(sym[9],2)
dw_list.object.r_ym8.Text   = Left(sym[8],4) + '.' + Right(sym[8],2)
dw_list.object.r_ym7.Text   = Left(sym[7],4) + '.' + Right(sym[7],2)
dw_list.object.r_ym6.Text   = Left(sym[6],4) + '.' + Right(sym[6],2)
dw_list.object.r_ym5.Text   = Left(sym[5],4) + '.' + Right(sym[5],2)
dw_list.object.r_ym4.Text   = Left(sym[4],4) + '.' + Right(sym[4],2)
dw_list.object.r_ym3.Text   = Left(sym[3],4) + '.' + Right(sym[3],2)
dw_list.object.r_ym2.Text   = Left(sym[2],4) + '.' + Right(sym[2],2)
dw_list.object.r_ym1.Text   = Left(sym[1],4) + '.' + Right(sym[1],2)
dw_list.object.r_ym0.Text   = Left(ym,4) + '.' + Right(ym,2)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if sGubun = '1' then
   if dw_print.Retrieve(gs_sabu, sT, sS, sV, sP, ym ,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('sym')
      dw_ip.setfocus()
    	return -1
	end if
elseif sGubun = '2' then
   if dw_print.Retrieve(gs_sabu, sT, sS, sV, sP, sI, ym,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('sym')
      dw_ip.setfocus()
    	return -1
	end if
else	   
	if dw_print.Retrieve(gs_sabu, sT, sS, sV, sP, sI, ym,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('sym')
      dw_ip.setfocus()
    	return -1
	end if	
end if
 
dw_print.sharedata(dw_list)

return 1
end function

on w_sal_05600.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'sym',left(f_today(),6))

end event

type p_preview from w_standard_print`p_preview within w_sal_05600
end type

type p_exit from w_standard_print`p_exit within w_sal_05600
end type

type p_print from w_standard_print`p_print within w_sal_05600
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05600
end type







type st_10 from w_standard_print`st_10 within w_sal_05600
end type



type dw_print from w_standard_print`dw_print within w_sal_05600
string dataobject = "d_sal_05600_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05600
integer x = 64
integer y = 32
integer width = 3355
integer height = 436
string dataobject = "d_sal_05600_01"
end type

event dw_ip::itemchanged;String  sNull, sVndCod, sCvName, sCode, sName
String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sItemCls, sItemGbn, sItemClsName, sPdtGu
Long    nRow

SetNull(sNull)
nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case "gubun"
		SetItem(1, 'itcls', sNull)
		SetItem(1, 'itclsnm', sNull)
		dw_list.SetRedraw(False)
		If GetText() = '1' then // 대분류별 판매실적현황을 Click 했을 경우
			dw_list.DataObject = "d_sal_05600_02"
			dw_print.DataObject = "d_sal_05600_02_p"
			dw_list.Settransobject(sqlca)
			dw_print.Settransobject(sqlca)
		elseif GetText() = '2' then // 중분류별 판매실적현황을 Click 했을 경우
			dw_list.DataObject = "d_sal_05600_03"
			dw_print.DataObject = "d_sal_05600_03_p"
			dw_list.Settransobject(sqlca)
			dw_print.Settransobject(sqlca)
		elseif GetText() = '4' then      // 제품별 판매실적현황을 Click 했을 경우
			dw_list.DataObject = "d_sal_05600_04"
			dw_print.DataObject = "d_sal_05600_04_p"
			dw_list.Settransobject(sqlca)
			dw_print.Settransobject(sqlca)
		else                            //제품별 실적현황(수량)gettext() = '5' then
			dw_list.DataObject = "d_sal_05600_05"
			dw_print.DataObject = "d_sal_05600_05_p"
			dw_list.Settransobject(sqlca)
			dw_print.Settransobject(sqlca)
//	   else                   //소분류별 
//			dw_list.DataObject = "d_sal_05600_06"
//			dw_list.Settransobject(sqlca)
		End if		
		dw_list.SetRedraw(True)
	/* 영업팀 */
	 Case "deptcode"
		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* 관할구역 */
	 Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	
		sIoCustArea = GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
			
		SetItem(1,'deptcode',sDept)
	/* 거래처 */
	Case "custcode"
		sIoCust = GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
			INTO :sIoCustName,		:sIoCustArea,			:sDept
			FROM "VNDMST","SAREA" 
			WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"deptcode",  sDept)
			SetItem(1,"custname",  sIoCustName)
			SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	 Case "custname"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"deptcode",  sDept)
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			SetItem(1,"areacode",  sIoCustArea)
			Return
		END IF
	
	/* 생산팀 */
	Case "pdtgu"
		SetItem(nRow,'ittyp','1')  /* 완제품 */
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
End Choose
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;str_itnct str_sitnct
string sIoCustName,sIoCustArea,sDept,ls_num

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
			INTO :sIoCustName,		:sIoCustArea,			:sDept
			FROM "VNDMST","SAREA" 
			WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	Case "itcls"
		ls_num=dw_ip.getitemstring(1,"gubun")
		if ls_num = '3' then
			OpenWithParm(w_ittyp_popup3,GetItemString(GetRow(),"ittyp"))
		else
			OpenWithParm(w_ittyp_popup,GetItemString(GetRow(),"ittyp"))
		end if
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	Case "itclsnm"
		ls_num=dw_ip.getitemstring(1,"gubun")
		if ls_num = '3' then
			OpenWithParm(w_ittyp_popup3, GetItemString(GetRow(),"ittyp"))
		else
			OpenWithParm(w_ittyp_popup, GetItemString(GetRow(),"ittyp"))
		end if
		
		str_sitnct = Message.PowerObjectParm
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",   str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",   str_sitnct.s_ittyp)
end Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_05600
integer x = 87
integer y = 492
integer width = 4507
integer height = 1804
string dataobject = "d_sal_05600_02"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within w_sal_05600
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 480
integer width = 4539
integer height = 1828
integer cornerheight = 40
integer cornerwidth = 55
end type

