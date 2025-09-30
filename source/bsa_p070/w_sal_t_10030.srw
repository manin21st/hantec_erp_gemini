$PBExportHeader$w_sal_t_10030.srw
$PBExportComments$년 업체별 출고 현황
forward
global type w_sal_t_10030 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_t_10030
end type
type rr_3 from roundrectangle within w_sal_t_10030
end type
end forward

global type w_sal_t_10030 from w_standard_print
string title = "년 업체별 출고 현황"
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_t_10030 w_sal_t_10030

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_yyyy, ls_gubun2, ls_sabuj, ls_cust, ls_prtgbn, ls_gubun, ls_curr_month, ls_arg_month, ls_steam

If dw_ip.AcceptText() <> 1 Then Return -1

ls_yyyy    = dw_ip.GetItemString(1,"year")
ls_gubun2  = dw_ip.GetItemString(1,"gubun2")
ls_sabuj   = dw_ip.getitemstring(1,"sabuj")
ls_cust    = dw_ip.GetItemString(1,"custcode")
ls_prtgbn  = dw_ip.GetItemString(1,"prtgbn")
ls_gubun   = dw_ip.GetItemString(1,"gubun")
ls_steam   = dw_ip.GetItemString(1,"steam")

ls_curr_month = Left(f_today(), 6)

If ls_yyyy = Left(ls_curr_month, 4) Then
	ls_arg_month = Right(ls_curr_month, 2)
	
//	If left(ls_arg_month, 1) = '0' Then
//		ls_arg_month =  right(ls_arg_month, 1)
//	End If
Else
	ls_arg_month = '12'
End If

If IsNull(ls_gubun) Or ls_gubun = '' Then ls_gubun = '1'

IF ls_yyyy = "" OR IsNull(ls_yyyy) THEN
	f_message_chk(30,'[기준년도]')
	dw_ip.SetColumn("ls_yyyy")
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_cust = "" OR IsNull(ls_cust) THEN ls_cust = '%'
IF ls_steam = "" OR IsNull(ls_steam) THEN ls_steam = '%'

IF dw_print.Retrieve(gs_sabu, ls_yyyy,ls_cust,ls_sabuj, ls_gubun, ls_prtgbn, ls_arg_month,ls_steam ) <= 0 THEN
	f_message_chk(50, ' [년업체별 출고현황] ')
	dw_list.Reset()
	dw_ip.setcolumn('year')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.object.t_100.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sabuj) ', 1)"))
dw_list.Retrieve(gs_sabu, ls_yyyy,ls_cust,ls_sabuj, ls_gubun, ls_prtgbn, ls_arg_month ,ls_steam)

//dw_print.ShareData(dw_list)
	
Return 1

end function

on w_sal_t_10030.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_3
end on

on w_sal_t_10030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;f_mod_saupj(dw_ip, 'sabuj')
dw_ip.SetItem(1, "year", Left(f_today(),4))

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

/* User별 관할구역 Setting */
String sarea, steam, saupj

// 영업팀 권한 설정
If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("steam.protect=1")
	
	dw_ip.SetItem(1, 'sarea', sarea)
	dw_ip.SetItem(1, 'steam', steam)
End If

end event

event open;call super::open;dw_list.shareDataOff()
end event

type p_preview from w_standard_print`p_preview within w_sal_t_10030
end type

type p_exit from w_standard_print`p_exit within w_sal_t_10030
end type

type p_print from w_standard_print`p_print within w_sal_t_10030
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_t_10030
end type











type dw_print from w_standard_print`dw_print within w_sal_t_10030
integer x = 3753
integer y = 40
string dataobject = "d_sal_t_10030_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_t_10030
integer x = 64
integer y = 56
integer width = 3465
integer height = 208
string dataobject = "d_sal_t_10030_h"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;
IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;String ls_gubun2, ls_custcode, ls_cust_name, snull

SetNull(snull)

Choose Case GetColumnName() 

	/* 거래처 */
	Case "custcode"
		ls_custcode = Trim(GetText())
		IF ls_custcode ="" OR IsNull(ls_custcode) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If 1 <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE
			SELECT CVNAS2 Into :ls_cust_name
			FROM VNDMST
			WHERE CVCOD = :ls_custcode;
			
//			SetItem(1,"deptcode", ls_custcode)
			SetItem(1,"custname", ls_cust_name)
//			SetItem(1,"areacode",   sarea)
//			SetItem(1,"emp_id",   sname1)
		END IF
		
	Case 'gubun2'
		ls_gubun2 = Trim(GetText())
		dw_list.SetRedraw(False)
		/* 품목별 */
		If ls_gubun2 = '1' Then
			dw_list.DataObject = 'd_sal_t_10030_d'
			dw_print.DataObject = 'd_sal_t_10030_p'
		/* 중분류별 */
		else
			dw_list.DataObject = 'd_sal_t_10030_d1'
			dw_print.DataObject = 'd_sal_t_10030_p1'
		end if

		dw_list.setredraw(true)
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)

End Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "custcode"
		gs_gubun = '1'
		
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetItem(1,"custname",gs_codename)
		
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)

//	/* 거래처 */
//	Case "custcode"
//		gs_gubun = '1'
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	/* 거래처명 */
//	Case "custname"
//		gs_gubun = '1'
//		gs_codename = Trim(GetText())
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_t_10030
event ue_mousemove pbm_mousemove
integer x = 59
integer y = 308
integer width = 4539
integer height = 1976
string dataobject = "d_sal_t_10030_d"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_t_10030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 44
integer width = 3598
integer height = 232
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_sal_t_10030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 300
integer width = 4567
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 46
end type

