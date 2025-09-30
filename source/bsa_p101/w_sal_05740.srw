$PBExportHeader$w_sal_05740.srw
$PBExportComments$년간 판매목표 대 실적현황(제품)
forward
global type w_sal_05740 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05740
end type
end forward

global type w_sal_05740 from w_standard_print
string title = "년간 판매목표 대 실적현황(제품)"
rr_1 rr_1
end type
global w_sal_05740 w_sal_05740

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sGubun, yy, sm_from, sm_to, &
       sT, sS, sP, sI, sV, sT_Name, sS_Name, sP_Name, sI_Name, sV_Name

If dw_ip.AcceptText() <> 1 Then Return -1

sGubun = dw_ip.GetItemString(1,'gubun')
yy = Trim(dw_ip.GetItemString(1,'syy'))

if	(yy='') or isNull(yy) then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

sm_from = Trim(dw_ip.GetItemString(1,'m_from'))

if	(sm_from='') or isNull(sm_from) then
	f_Message_Chk(35, '[판매월(From)]')
	dw_ip.setcolumn('m_from')
	dw_ip.setfocus()
	Return -1
end if

sm_to = Trim(dw_ip.GetItemString(1,'m_to'))

if	(sm_to='') or isNull(sm_to) then
	f_Message_Chk(35, '[판매월(to)]')
	dw_ip.setcolumn('m_to')
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
	sI_Name = Trim(dw_ip.GetItemString(1,'titnm'))
end if

if	(yy = '') or isNull(yy) then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

// 거래처 선택
sV = Trim(dw_ip.getItemString(1, 'cvcod'))
if isNull(sV) or (sV = '') then
	sV = '%'
	sV_Name = '전  체'
else
	sV = sV + '%'
	sV_Name = Trim(dw_ip.GetItemString(1,'cvnas2'))
end if

dw_print.object.r_yy.Text = yy
dw_print.object.r_mm.Text = sm_from + ' - ' + sm_to
dw_print.object.r_steam.Text = sT_Name
dw_print.object.r_sarea.Text = sS_Name
dw_print.object.r_cvcod.Text = sV_Name
dw_print.object.r_itcls.Text = sI_Name
dw_print.object.r_pdtgu.Text = sP_Name

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if sGubun = '1' then
   if dw_print.Retrieve(gs_sabu, yy, sm_from, sm_to, sV, sS, sT, sP,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('syy')
      dw_ip.setfocus()
    	return -1
	end if
elseif sGubun = '2' then
   if dw_print.Retrieve(gs_sabu, yy, sm_from, sm_to, sV, sS, sT, sP, sI,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('syy')
      dw_ip.setfocus()
    	return -1
	end if
elseif sGubun = '3' then
   if dw_print.Retrieve(gs_sabu, yy, sm_from, sm_to, sV, sS, sT, sP, sI,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('syy')
      dw_ip.setfocus()
    	return -1
	end if
else
	if dw_print.Retrieve(gs_sabu, yy, sm_from, sm_to, sV, sS, sT, sP, sI,ls_silgu) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('syy')
      dw_ip.setfocus()
    	return -1
	end if	
end if

dw_print.sharedata(dw_list)

return 1
end function

on w_sal_05740.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05740.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,"syy",left(f_today(),4))
dw_ip.setitem(1,"m_from",'01')
dw_ip.setitem(1,"m_to",mid(f_today(),5,2))

end event

type p_preview from w_standard_print`p_preview within w_sal_05740
end type

type p_exit from w_standard_print`p_exit within w_sal_05740
end type

type p_print from w_standard_print`p_print within w_sal_05740
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05740
end type







type st_10 from w_standard_print`st_10 within w_sal_05740
end type



type dw_print from w_standard_print`dw_print within w_sal_05740
string dataobject = "d_sal_05740_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05740
integer x = 69
integer y = 32
integer width = 3269
integer height = 384
string dataobject = "d_sal_05740_01"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, sVndCod, sCvName, sCode, sName, aa, bb

sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
	Case "gubun"
		this.SetItem(1, 'itcls', sNull)
		this.SetItem(1, 'titnm', sNull)
		dw_list.SetRedraw(False)
		if this.GetText() = '1' then // 대분류별 판매목표 대비 실적현황을 Click 했을 경우
			dw_list.DataObject = "d_sal_05740_02"
			dw_print.DataObject = "d_sal_05740_02_p"
			dw_list.Settransobject(sqlca)
			dw_print.Settransobject(sqlca)			
		elseif this.GetText() = '2' then // 중분류별 판매목표 대비 실적현황을 Click 했을 경우
			dw_list.DataObject = "d_sal_05740_03"
			dw_print.DataObject = "d_sal_05740_03_p"
			dw_list.Settransobject(sqlca)
			dw_print.Settransobject(sqlca)			
//		elseif this.GetText() = '3' then // 소분류별 판매목표 대비 실적현황을 Click 했을 경우
//			dw_list.DataObject = "d_sal_05740_05"
//			dw_print.DataObject = "d_sal_05740_05_p"
//			dw_list.Settransobject(sqlca)
//       dw_print.Settransobject(sqlca)			
		else                                  // 제품별 판매목표 대비 실적현황을 Click 했을 경우
			dw_list.DataObject = "d_sal_05740_04"
			dw_print.DataObject = "d_sal_05740_04_p"
			dw_list.Settransobject(sqlca)
			dw_print.Settransobject(sqlca)			
		end if
		
		dw_list.SetRedraw(True)		
	// 판매월(From) 유효성 Check
   Case "m_from"
		if Not(isNumber(Trim(this.getText()))) then
			f_Message_Chk(35, '[판매월]')
			this.SetItem(1, "m_from", sNull)
			return 1
		end if
      this.SetItem(1, "m_from", Mid('0'+Trim(this.getText()), Len(Trim(this.getText())),2))
		return 2		
		
	// 판매월(To) 유효성 Check
   Case "m_to"
		if Not(isNumber(Trim(this.getText()))) then
			f_Message_Chk(35, '[판매월]')
			this.SetItem(1, "m_to", sNull)
			return 1
		end if
      this.SetItem(1, "m_to", Mid('0'+Trim(this.getText()), Len(Trim(this.getText())),2))
		aa = this.GetItemString(1,'m_from')
		bb = this.GetText()
		if this.GetItemString(1,'m_from') > this.GetText() then
			f_message_Chk(200, '[시작 및 종료일 CHECK]')
			this.SetItem(1, "m_to", sNull)
			return 1
		end if			
		return 2				
		
	Case "cvcod"
		sVndCod = this.GetText()
      if isNull(sVndCod) then sVndCod = ''
		//**********************************************
		Select cvnas2 Into :sCvName From vndmst
		Where (sabu = :gs_sabu) and (cvcod = :sVndCod) and (cvstatus = '0');
		//**********************************************
		if (sCvName = '') or (isNull(sCvName)) then
			f_Message_Chk(33, '[거래처가 존재유무 확인]')
			this.SetItem(1, "cvcod", sNull)
			this.SetItem(1, "cvnas2", sNull)
			return 1
		else
			this.SetItem(1, "cvnas2", sCvName)
		end if	
		
	Case "itcls"
		sCode = Trim(This.GetText())
		if isNull(sCode) then 
			return
   	else
	   	Select titnm Into :sName From itnct
		   Where ittyp = '1' and itcls = :sCode;
			
      	if (sName = '') or (isNull(sName)) then
	      	f_Message_Chk(33, '[품목분류 존재유무 확인]')
		     	this.SetItem(1, "titnm", '')
				return 1
   	   else
	   	  	this.SetItem(1, "titnm", sName)
//				  cb_update.SetFocus()
   	   end if					
		end if		
end Choose
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sCol_Name
str_itnct str_sitnct

sCol_Name = This.GetColumnName()
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case sCol_Name
   // 거래처 에디트에 Right 버턴클릭시 Popup 화면
	Case "cvcod"
		gs_code = this.GetText()
		Open(w_agent_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		this.SetItem(1, 'cvcod', gs_code)
		this.SetItem(1, 'cvnas2', gs_codename)
		this.SetColumn('itcls')
		
	// 품목분류 에디트에 Right 버턴클릭시 Popup 화면
	Case "itcls"
		gs_code = this.GetText()
		if this.GetItemString(1, 'gubun') = '2' then
			Open(w_itnct_l_popup)
			
   		if gs_code = "" or isnull(gs_code) then return
		
	   	this.SetItem(1, 'itcls', gs_code)
		   this.SetItem(1, 'titnm', gs_codename)
		elseif this.GetItemString(1, 'gubun') = '3' then
			OpenWithParm(w_ittyp_popup3, '1')
			
			str_sitnct = Message.PowerObjectParm
			
			IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
			
			SetItem(1,"itcls",   str_sitnct.s_sumgub)
			SetItem(1,"titnm", str_sitnct.s_titnm)
//			SetItem(1,"ittyp",   str_sitnct.s_ittyp)
			
//			SetColumn('itnbr')
		else
   		Open(w_ittyp_popup8)
   		str_sitnct =  Message.PowerObjectParm	
			
		   if str_sitnct.s_sumgub = "" or isnull(str_sitnct.s_sumgub) then return
		
   		this.SetItem(1, 'itcls', str_sitnct.s_sumgub)
	   	this.SetItem(1, 'titnm', str_sitnct.s_titnm)
		end if
//		cb_update.SetFocus()
end Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_05740
integer x = 82
integer y = 440
integer width = 4521
integer height = 1852
string dataobject = "d_sal_05740_02"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within w_sal_05740
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 432
integer width = 4544
integer height = 1876
integer cornerheight = 40
integer cornerwidth = 55
end type

