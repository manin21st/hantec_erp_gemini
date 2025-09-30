$PBExportHeader$w_sal_06660.srw
$PBExportComments$Buyer별 년간 제품 판매 현황
forward
global type w_sal_06660 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06660
end type
end forward

global type w_sal_06660 from w_standard_print
string title = "Buyer별 년간 제품 판매 현황"
rr_1 rr_1
end type
global w_sal_06660 w_sal_06660

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear,steamcd,sarea,cvcod
string   tx_steamnm,tx_sareanm,tx_cvcodnm

////////////////////////////////////////////////////// 조건절값
If dw_ip.accepttext() <> 1 Then Return -1

syear = trim(dw_ip.getitemstring(1, 'syear'))
steamcd = trim(dw_ip.getitemstring(1, 'steam'))
sarea = trim(dw_ip.getitemstring(1, 'sarea'))
cvcod = trim(dw_ip.getitemstring(1, 'cvcod'))

If IsNull(steamcd)  Then steamcd = ''
If IsNull(sarea)  Then sarea = ''
If IsNull(cvcod)  Then cvcod = ''
////////////////////////////////////////////////////// 기간 유효성 check
IF	f_datechk(syear+'0101') = -1 then
	MessageBox("확인","기준년도를 확인하세요!")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

string ls_silgu

SELECT DATANAME
INTO   :ls_silgu
FROM   SYSCNFG
WHERE  SYSGU = 'S'   AND
       SERIAL = '8'  AND
       LINENO = '40' ;

////////////////////////////////////////////////////// 검색
SetPointer(HourGlass!)
dw_print.SetRedraw(False)

if dw_print.retrieve(gs_sabu, syear, steamcd+'%',sarea+'%',cvcod+'%',ls_silgu) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('steam')
	dw_ip.setfocus()
	return -1
end if

dw_print.sharedata(dw_list)
////////////////////////////////////////////////////// 타이틀 설정
string tx_pdtgu,tx_ittyp,tx_itcls

tx_steamnm = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steam) ', 1)"))
tx_sareanm = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))

If tx_steamnm = '' Then tx_steamnm = '전체'
If tx_sareanm = '' Then tx_sareanm = '전체'

dw_print.Object.tx_steamnm.text = tx_steamnm
//dw_list.Object.tx_sareanm.text = tx_sareanm

dw_print.SetRedraw(True)
Return 1
end function

on w_sal_06660.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06660.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sTeamCd

/* 해외영업팀 */
select min(steamcd) into :sTeamCd 
  from steam 
 where steamcd like '1%';
 
dw_ip.SetItem(1,'steam',sTeamCd)
dw_ip.SetItem(1,'syear',Left(f_today(),4))

//관할 구역
f_child_saupj(dw_ip, 'sarea', gs_saupj) 


w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

end event

type p_xls from w_standard_print`p_xls within w_sal_06660
end type

type p_sort from w_standard_print`p_sort within w_sal_06660
end type

type p_preview from w_standard_print`p_preview within w_sal_06660
end type

type p_exit from w_standard_print`p_exit within w_sal_06660
end type

type p_print from w_standard_print`p_print within w_sal_06660
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06660
end type







type st_10 from w_standard_print`st_10 within w_sal_06660
end type



type dw_print from w_standard_print`dw_print within w_sal_06660
string dataobject = "d_sal_06660_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06660
integer x = 87
integer y = 52
integer width = 2999
integer height = 200
string dataobject = "d_sal_06660_01"
end type

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

IF this.GetColumnName() ="cvcod" THEN
	gs_gubun = '2'
	Open(w_vndmst_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"cvcod",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string sArea,sTeam,sCvcod,sCvcodnm,snull

Choose Case  GetColumnName() 
/* 영업팀 */
  Case "steam"
	 SetItem(1,'sarea',snull)
	 SetItem(1,'cvcod',snull)
	 SetItem(1,'cvcodnm',snull)
/* 관할구역 */		
  Case "sarea"
	 sArea = this.GetText()
 	 SetItem(1,'cvcod',snull)
	 SetItem(1,'cvcodnm',snull)
	 IF sArea = "" OR IsNull(sArea) THEN RETURN
	
	 SELECT "SAREA"."SAREA", "SAREA"."STEAMCD" INTO :sArea, :sTeam
		FROM "SAREA"  
	  WHERE "SAREA"."SAREA" = :sArea  ;
	 IF SQLCA.SQLCODE <> 0 THEN
		f_message_chk(33,'[관할구역]')
		this.SetItem(1,"sarea",snull)
		Return 1
	 END IF
	 
	 this.SetItem(1,"steam",  sTeam)
/* 거래처 */
  Case "cvcod"
	 sCvcod = this.GetText()
	 IF sCvcod ="" OR IsNull(sCvcod) THEN
		this.SetItem(1,"cvcodnm",snull)
		Return
	 END IF
	
	 SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
	   INTO :sCvcodnm,		:sArea,			:sTeam
	   FROM "VNDMST","SAREA" 
     WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sCvcod   ;
	 IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(1,"cvcod",snull)
			this.SetItem(1,"cvcodnm",snull)
		END IF
		Return 1
	ELSE
		this.SetItem(1,"steam",  sTeam)
		this.SetItem(1,"sarea",  sArea)
		this.SetItem(1,"cvcodnm",sCvcodnm)
	END IF
End Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06660
integer x = 101
integer y = 264
integer width = 4457
integer height = 2032
string dataobject = "d_sal_06660"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_sal_06660
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 91
integer y = 256
integer width = 4485
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

