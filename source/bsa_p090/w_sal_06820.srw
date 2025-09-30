$PBExportHeader$w_sal_06820.srw
$PBExportComments$중요품목매출경향
forward
global type w_sal_06820 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06820
end type
end forward

global type w_sal_06820 from w_standard_print
string title = "중요품목 매출경향"
rr_1 rr_1
end type
global w_sal_06820 w_sal_06820

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_date,ls_steamcd, ls_sarea, ls_gubun ,ls_pangbn,ls_pangb1,ls_pangb2 ,tx_name

if dw_ip.accepttext() <> 1 then return -1

ls_date    = trim(dw_ip.getitemstring(1,'jdate'))
ls_steamcd = trim(dw_ip.getitemstring(1,'steamcd'))
ls_sarea   = trim(dw_ip.getitemstring(1,'sarea'))
ls_gubun   = trim(dw_ip.getitemstring(1,'gubun'))
ls_pangbn  = trim(dw_ip.getitemstring(1,'pangbn'))

if ls_date="" or isnull(ls_date) then
	f_message_chk(35,'[기준년월]')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	return -1
end if

if ls_steamcd = "" or isnull(ls_steamcd) then ls_steamcd = '%'

if ls_sarea   = "" or isnull(ls_sarea) then ls_sarea = '%'

if ls_pangbn = '1' then
	ls_pangb1 = '%'
	ls_pangb2 = '%'
	dw_print.object.tx_pangb.text = '전체'
elseif ls_pangbn ='2' then
	ls_pangb1 = '2'
	ls_pangb2 = '3'
	dw_print.object.tx_pangb.text = '수출'
elseif ls_pangbn ='3' then
	ls_pangb1 = '1'
	ls_pangb2 = '1' 
	dw_print.object.tx_pangb.text = '내수'
end if

if ls_gubun = '1' then
	dw_print.object.tx_head.text = '품목분류별 매출경향[금액]'
	dw_print.object.tx_rate.text = '(단위 : 원 )'
else
	dw_print.object.tx_head.text = '품목분류별 매출경향[수량]'
	dw_print.object.tx_rate.text = '(단위 : 개 )'
end if

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_print.retrieve(gs_sabu, ls_date, ls_steamcd +'%',ls_sarea +'%', ls_pangb1, ls_pangb2,ls_gubun,ls_silgu) < 1 then
	f_message_chk(300,'[출력조건 CHECK]')
	dw_ip.setcolumn('jdate')
	dw_ip.setfocus()
	dw_print.InsertRow(0)
   return -1
else
	dw_print.sharedata(dw_list)
end if


dw_print.object.tx_date.text = left(ls_date,4) +'.' + mid(ls_date,5,2)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steamcd) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

return 1
end function

on w_sal_06820.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06820.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'jdate',left(f_today(),6))
end event

type p_preview from w_standard_print`p_preview within w_sal_06820
end type

type p_exit from w_standard_print`p_exit within w_sal_06820
end type

type p_print from w_standard_print`p_print within w_sal_06820
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06820
end type







type st_10 from w_standard_print`st_10 within w_sal_06820
end type



type dw_print from w_standard_print`dw_print within w_sal_06820
string dataobject = "d_sal_06820_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06820
integer y = 24
integer width = 2597
integer height = 228
string dataobject = "d_sal_06820_02"
end type

event dw_ip::itemchanged;call super::itemchanged;String sCol_Name, sNull, sPrtGbn, sIoCustArea, sdept

sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
	// 기준일자 유효성 Check
   Case "jdate"
		if f_DateChk(Trim(this.getText())+'01') = -1 then
			this.SetItem(1, "jdate", sNull)
			f_Message_Chk(35, '[기준년월]')
			return 1
		end if
	/* 영업팀 */
	 Case "steamcd"
		SetItem(1,'sarea',sNull)
	/* 관할구역 */
	 Case "sarea"
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
			
		SetItem(1,'steamcd',sDept)
//	Case 'prtgbn'
//		sPrtGbn = Trim(GetText())
//		
//		dw_list.SetRedraw(False)
//		/* 송장기준 */
//		If sPrtGbn = '1' Then
//			dw_list.DataObject = 'd_sal_055701'
//			dw_list.SetTransObject(SQLCA)
//		elseIf sPrtGbn = '3' Then
//			dw_list.DataObject = 'd_sal_055702'
//			dw_list.SetTransObject(SQLCA)
//		Else
//			dw_list.DataObject = 'd_sal_05570'
//			dw_list.SetTransObject(SQLCA)
//		End If
//		dw_list.SetRedraw(True)
end Choose

end event

event dw_ip::error;call super::error;return 
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_06820
integer x = 55
integer y = 276
integer width = 4539
integer height = 2024
string dataobject = "d_sal_06820_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06820
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 272
integer width = 4567
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

