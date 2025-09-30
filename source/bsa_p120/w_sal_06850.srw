$PBExportHeader$w_sal_06850.srw
$PBExportComments$주요품목 판매계획
forward
global type w_sal_06850 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06850
end type
end forward

global type w_sal_06850 from w_standard_print
string title = "주요 품목별 판매 계획"
rr_1 rr_1
end type
global w_sal_06850 w_sal_06850

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_syy  , ls_fm , ls_tm , ls_team , ls_area , ls_cvcod , ls_gubun , ls_pgubun , tx_name
long   ll_chasu

if dw_ip.accepttext() <> 1 then return -1

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

ls_syy   = Trim(dw_ip.getitemstring(1,'syy'))
ll_chasu = dw_ip.getitemnumber(1,'schasu')
ls_fm    = Trim(dw_ip.getitemstring(1,'fm'))
ls_tm    = Trim(dw_ip.getitemstring(1,'tm'))
ls_team  = Trim(dw_ip.getitemstring(1,'ssteam'))
ls_area  = Trim(dw_ip.getitemstring(1,'ssarea'))
ls_cvcod = Trim(dw_ip.getitemstring(1,'svndcod'))
ls_pgubun = dw_ip.getitemstring(1,'pgubun')
ls_gubun  = dw_ip.getitemstring(1,'gubun')

if ls_syy = "" or isnull(ls_syy) then
	f_message_chk(30,'[계획년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	return -1
end if

if isnull(ll_chasu) then
	f_message_chk(30,'[계획차수]')
	dw_ip.setcolumn('schasu')
	dw_ip.setfocus()
	return -1
end if

if ls_team  = "" or isnull(ls_team)  then ls_team = '%'
if ls_area  = "" or isnull(ls_area)  then ls_area = '%'
if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'
if ls_pgubun = "" or isnull(ls_pgubun) then ls_pgubun = '%'

if ls_gubun = '1' then
	if dw_print.retrieve(ls_syy , ll_chasu , ls_team , ls_area, ls_cvcod , ls_pgubun ) < 1 then
		f_message_chk(300,'')
      dw_ip.setcolumn('syy')
		dw_ip.setfocus()
		dw_print.InsertRow(0)
//		return -1
	else
		dw_print.sharedata(dw_list)
	end if
else
	
		if ls_fm = "" or isnull(ls_fm) then
			f_message_chk(30,'[전년도 계획월 FROM]')
			dw_ip.setcolumn('fm')
			dw_ip.setfocus()
			return -1
		end if
		
		if ls_tm = "" or isnull(ls_tm) then
			f_message_chk(30,'[전년도 계획월 TO]')
			dw_ip.setcolumn('tm')
			dw_ip.setfocus()
			return -1
		end if

   if dw_print.retrieve(ls_syy , ll_chasu , ls_team , ls_area, ls_cvcod ,ls_fm , ls_tm, ls_pgubun,ls_silgu) < 1 then
		f_message_chk(300,'')
      dw_ip.setcolumn('syy')
		dw_ip.setfocus()
		dw_print.InsertRow(0)
//		return -1
	else
		dw_print.sharedata(dw_list)
	end if
end if

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ssteam) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_team.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ssarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_area.text = '"+tx_name+"'")

return 1
end function

on w_sal_06850.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06850.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.settransobject(sqlca)
dw_ip.setitem(1,'syy',left(f_today(),4))
end event

type p_preview from w_standard_print`p_preview within w_sal_06850
end type

type p_exit from w_standard_print`p_exit within w_sal_06850
end type

type p_print from w_standard_print`p_print within w_sal_06850
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06850
end type







type st_10 from w_standard_print`st_10 within w_sal_06850
end type



type dw_print from w_standard_print`dw_print within w_sal_06850
string dataobject = "d_sal_06850_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06850
integer y = 24
integer width = 3689
integer height = 272
string dataobject = "d_sal_06850"
end type

event dw_ip::itemchanged;call super::itemchanged;string  snull, s_name , ls_gubun , s_ssteam  , ls_data , ls_sarea , ls_steam ,ls_cvcod , ls_cvcodnm
int    ireturn 

setnull(snull)

CHOOSE CASE this.GetColumnName()
	Case 'gubun'
		ls_gubun = this.gettext()
	    
		 dw_list.setredraw(false)
		 
		if ls_gubun = '1' then
			dw_list.dataobject = 'd_sal_06850_01'
			dw_print.dataobject = 'd_sal_06850_01_p'
		else
			dw_list.dataobject = 'd_sal_06850_02'
			dw_print.dataobject = 'd_sal_06850_02_p'
		end if
		dw_print.settransobject(sqlca)
		dw_list.settransobject(sqlca)
		dw_list.setredraw(true)
		
Case "ssteam"
		SetItem(1,'ssAREA',sNull)
		SetItem(1,"svndcod",sNull)
		SetItem(1,"svndnm",sNull)
/* 관할구역 */
Case "ssarea"
	SetItem(1,"svndcod",sNull)
	SetItem(1,"svndnm",sNull)
	
	ls_data = this.GetText()
	IF ls_data = "" OR IsNull(ls_data) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :ls_sarea  ,:ls_steam
	  FROM "SAREA"  
	 WHERE "SAREA"."SAREA" = :ls_data   ;
	
	SetItem(1,'ssteam',ls_steam)
/* 거래처 */
Case "svndcod"
	ls_data = this.GetText()
	IF ls_data ="" OR IsNull(ls_data) THEN
		this.SetItem(1,"svndnm",snull)
		Return
	END IF
	
	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
	  INTO :ls_cvcodnm,		:ls_sarea,			:ls_steam
	  FROM "VNDMST","SAREA" 
	 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :ls_data   ;
	IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(RbuttonDown!)
		Return 2
	ELSE
		this.SetItem(1,"ssteam",  ls_steam)
		this.SetItem(1,"ssarea",  ls_sarea)
		this.SetItem(1,"svndnm",  ls_cvcodnm)
	END IF
	
END CHOOSE


end event

event dw_ip::rbuttondown;call super::rbuttondown;string ls_data , ls_cvcod , ls_cvcodnm , ls_sarea , ls_steam

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "svndcod"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"svndcod",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :ls_cvcodnm,		:ls_sarea,			:ls_steam
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"ssteam",  ls_steam)
			this.SetItem(1,"ssarea",  ls_sarea)
			this.SetItem(1,"svndnm",  ls_cvcodnm)
		END IF
END Choose

end event

event dw_ip::itemerror;call super::itemerror;RETURN
end event

event dw_ip::error;call super::error;return
end event

event dw_ip::dberror;call super::dberror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_06850
integer x = 46
integer y = 316
integer width = 4544
integer height = 2000
string dataobject = "d_sal_06850_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06850
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 308
integer width = 4562
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

