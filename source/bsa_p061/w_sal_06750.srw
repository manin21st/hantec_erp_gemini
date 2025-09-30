$PBExportHeader$w_sal_06750.srw
$PBExportComments$제품 판매추이 현황
forward
global type w_sal_06750 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06750
end type
end forward

global type w_sal_06750 from w_standard_print
string title = "제품 판매추이 현황"
rr_1 rr_1
end type
global w_sal_06750 w_sal_06750

type variables
string s_yyyy , s_fmmm , s_tomm , s_ittyp , s_itcls
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSarea, sGubun

If dw_ip.AcceptText() <> 1 Then Return -1

s_yyyy   = trim(dw_ip.GetItemString(1,'syy'))
s_fmmm   = trim(dw_ip.GetItemString(1,'sfmm'))
s_tomm   = trim(dw_ip.GetItemString(1,'stmm'))
s_ittyp  = trim(dw_ip.GetItemString(1,'sittyp'))
s_itcls  = trim(dw_ip.GetItemString(1,'sitcls'))
sSarea   = trim(dw_ip.GetItemString(1,'sarea'))

sGubun   = trim(dw_ip.GetItemString(1,'sgubun'))

If IsNull(sSarea) Or sSarea = '' Then sSarea = ''


//--------------------------- 년월 CHECK -------------------------------//
if	s_yyyy = '' or isNull(s_yyyy) or s_yyyy <= '1992' then           
	f_Message_Chk(35, '[FROM년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1 
end if
if	s_fmmm = '' or isNull(s_fmmm) or s_fmmm <= '00' or s_fmmm > '12' then           
	f_Message_Chk(35, '[FROM월]')
	dw_ip.setcolumn('sfmm')
	dw_ip.setfocus()
	Return -1 
end if

if	s_tomm = '' or isNull(s_tomm) or s_tomm <= '00' or s_tomm > '12' then           
	f_Message_Chk(35, '[TO월]')
	dw_ip.setcolumn('stmm')
	dw_ip.setfocus()
	Return -1 
end if
//----------------------------------------------------------------------//

if s_ittyp = "" or IsNull(s_ittyp) then
	s_ittyp = '%'
else
	s_ittyp = s_ittyp + '%'
end if	
if s_itcls = "" or IsNull(s_itcls) then
	s_itcls = '%'
else
	s_itcls = s_itcls + '%'
end if	

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If sGubun <= '05' Then
/* 관할구역별 */
	If dw_print.Retrieve( s_yyyy , s_fmmm , s_tomm , s_ittyp , s_itcls ,ls_silgu) <= 0 then
		f_message_chk(50,'[제품별 판매추이 현황]')
		dw_ip.setcolumn('syy')
		return -1
	End if
Else
/* 바이어별  */
	If dw_print.Retrieve( s_yyyy , s_fmmm , s_tomm , s_ittyp , s_itcls, sSarea+'%',ls_silgu ) <= 0 then
		f_message_chk(50,'[제품별 판매추이 현황]')
		dw_ip.setcolumn('syy')
		return -1
	End if
End If
   dw_print.sharedata(dw_list)
Return 1
end function

on w_sal_06750.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06750.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'syy',left(f_today(),4))
dw_ip.setitem(1,'sfmm','01')
dw_ip.setitem(1,'stmm',mid(f_today(),5,2))
end event

type p_preview from w_standard_print`p_preview within w_sal_06750
end type

type p_exit from w_standard_print`p_exit within w_sal_06750
end type

type p_print from w_standard_print`p_print within w_sal_06750
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06750
end type







type st_10 from w_standard_print`st_10 within w_sal_06750
end type



type dw_print from w_standard_print`dw_print within w_sal_06750
string dataobject = "d_sal_06750_01_P"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06750
integer x = 59
integer y = 40
integer width = 2587
integer height = 484
string dataobject = "d_sal_06750"
end type

event dw_ip::itemchanged;string snull, s_itnm , s_name
int    ireturn 
String sIoCust, sIocustName, sIocustarea, sDept

setnull(snull)

CHOOSE CASE GetColumnName()
		
	CASE 'syy'
		accepttext()
		
		s_yyyy = GetText()
		
		s_yyyy = Mid('000'+s_yyyy,len(s_yyyy),4)
		
      setitem(1, 'syy', s_yyyy)
		
		return
		
	CASE 'sfmm'
		
		accepttext()
		
		s_fmmm = GetText()
		
		s_fmmm = Mid('0'+s_fmmm,len(s_fmmm),2)
		
      setitem(1, 'sfmm', s_fmmm)
		
		return
		
	CASE 'stmm'
		
		accepttext()
		
		s_tomm = GetText()
		
		s_tomm = Mid('0'+s_tomm,len(s_tomm),2)
		
      setitem(1, 'stmm', s_tomm)
		return
		
	CASE 'sittyp'
		
		s_ittyp = GetText()
		
		if s_ittyp = "" or isnull(s_ittyp) then 
         return 
	   end if	
		
		s_name = f_get_reffer('05',s_ittyp)
		
		if	(s_name = '') or isNull(s_name) then    // 품목구분 CHECK
       	f_Message_Chk(33, '[품목구분]')
			setitem(1, 'sittyp', snull)
      	Return 1
      end if
		 
	CASE 'sitcls'
   	accepttext()
	
	   s_itcls = GetText()
	
   	s_ittyp = getitemstring(1, 'sittyp')
   
	   if s_itcls = "" or isnull(s_itcls) then 
		   setitem(1, 'sitname', snull)
         return 
	   end if	
	
   	ireturn = f_get_name2('품목분류', 'Y', s_itcls, s_itnm, s_ittyp)	

      setitem(1, 'sitcls', s_itcls)
      setitem(1, 'sitname', s_itnm)
	
	   return ireturn 

	CASE 'sgubun'
		dw_list.SetRedraw(False)
 		if GetText() = '01' then     // 관할구역 대분류별 출력
			dw_list.DataObject = "d_sal_06750_01"
			dw_print.DataObject = "d_sal_06750_01"
			dw_list.Settransobject(sqlca)
		elseif GetText() = '02' then // 관할구역 중분류별 출력
			dw_list.DataObject = "d_sal_06750_02"
			dw_print.DataObject = "d_sal_06750_02"
			dw_list.Settransobject(sqlca)
		elseif GetText() = '03' then // 관할구역 소분류별 출력
			dw_list.DataObject = "d_sal_06750_07"
			dw_print.DataObject = "d_sal_06750_07"
			dw_list.Settransobject(sqlca)
		elseif GetText() = '04' then // 관할구역 대표품번별 출력
			dw_list.DataObject = "d_sal_06750_08"
		   dw_print.DataObject = "d_sal_06750_08"
		   dw_list.Settransobject(sqlca)
		elseif GetText() = '05' then // 관할구역 제품별 출력
			dw_list.DataObject = "d_sal_06750_03"
		   dw_print.DataObject = "d_sal_06750_03"
		   dw_list.Settransobject(sqlca)
		elseif GetText() = '06' then // 바이어 대분류별 출력
			dw_list.DataObject = "d_sal_06750_04"
		   dw_print.DataObject = "d_sal_06750_04"
		   dw_list.Settransobject(sqlca)
		elseif GetText() = '07' then // 바이어 중분류별 출력
			dw_list.DataObject = "d_sal_06750_05"
		   dw_print.DataObject = "d_sal_06750_05"
		   dw_list.Settransobject(sqlca)
		elseif GetText() = '08' then // 바이어 소분류별 출력
			dw_list.DataObject = "d_sal_06750_09"
		   dw_print.DataObject = "d_sal_06750_09"
		   dw_list.Settransobject(sqlca)
		elseif GetText() = '09' then // 바이어 대표품번별 출력
			dw_list.DataObject = "d_sal_06750_10"
		   dw_print.DataObject = "d_sal_06750_10"
		   dw_list.Settransobject(sqlca)
	   elseif GetText() = '10' then // 바이어 제품별 출력
			dw_list.DataObject = "d_sal_06750_06"
		   dw_print.DataObject = "d_sal_06750_06"
		   dw_list.Settransobject(sqlca)
		end if
		   dw_print.Settransobject(sqlca)
	
	   dw_list.SetRedraw(True)
	/* 거래처 */
	Case "custcode"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
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
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			SetItem(1,"areacode",  sIoCustArea)
			Return
		END IF
END CHOOSE
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sname, sIoCustName, sIoCustArea, sDept
str_itnct sStr_sitnct

setnull(gs_code)
setnull(gs_codename)

Choose Case GetColumnName()
	Case 'sitcls'
		accepttext()
		sname = GetItemString(1, 'sittyp')
		OpenWithParm(w_ittyp_popup9, sname)
		
		sStr_sitnct = Message.PowerObjectParm	
		
		if isnull(sstr_sitnct.s_ittyp) or sstr_sitnct.s_ittyp = "" then return 
		
		SetItem(1,"sittyp",sstr_sitnct.s_ittyp)
		
		SetItem(1,"sitcls", sstr_sitnct.s_sumgub)
		SetItem(1,"sitname", sstr_sitnct.s_titnm)
 Case "custcode","custname"
	  gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
	  Open(w_agent_popup)
	
	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	  SetItem(1,"custcode",gs_code)
	
	  SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
	    INTO :sIoCustName,		:sIoCustArea,			:sDept
	    FROM "VNDMST","SAREA" 
     WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		
	  IF SQLCA.SQLCODE = 0 THEN
	    SetItem(1,"custname",  sIoCustName)
	    SetItem(1,"areacode",  sIoCustArea)
	  END IF
END Choose

end event

event dw_ip::ue_key;call super::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
		IF This.GetColumnName() = "sitcls"  Then
   		this.accepttext()
			gs_code = this.getitemstring(1, 'sittyp')
			
			open(w_ittyp_popup3)
			
			str_sitnct = Message.PowerObjectParm	
			
			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
				return
			end if
		
			this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
			this.SetItem(1,"sitcls", str_sitnct.s_sumgub)
			this.SetItem(1,"sitname", str_sitnct.s_titnm)
		END IF	
END IF

end event

type dw_list from w_standard_print`dw_list within w_sal_06750
integer x = 73
integer y = 532
integer width = 4475
integer height = 1772
string dataobject = "d_sal_06750_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06750
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 524
integer width = 4512
integer height = 1796
integer cornerheight = 40
integer cornerwidth = 55
end type

