$PBExportHeader$w_sal_02046.srw
$PBExportComments$출고송장 등록 - 기타매출
forward
global type w_sal_02046 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_02046
end type
type rr_3 from roundrectangle within w_sal_02046
end type
end forward

global type w_sal_02046 from w_standard_print
string title = "기타매출 송장"
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_02046 w_sal_02046

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_yyyy, ls_sabuj, ls_cust, ls_steam, ls_yyyyt

If dw_ip.AcceptText() <> 1 Then Return -1

ls_yyyy    = dw_ip.GetItemString(1,"year")
ls_yyyyt   = dw_ip.GetItemString(1,"yeart")
ls_sabuj   = dw_ip.getitemstring(1,"sabuj")
ls_cust    = dw_ip.GetItemString(1,"custcode")
//ls_steam   = dw_ip.GetItemString(1,"steam")

IF ls_yyyy = "" OR IsNull(ls_yyyy) THEN
	f_message_chk(30,'[수불일자]')
	dw_ip.SetColumn("year")
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_yyyyt = "" OR IsNull(ls_yyyyt) THEN
	f_message_chk(30,'[수불일자]')
	dw_ip.SetColumn("yeart")
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_yyyy > ls_yyyyt  THEN
	f_message_chk(30,'[수불기간]')
	dw_ip.SetColumn("yeart")
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_cust = "" OR IsNull(ls_cust) THEN ls_cust = '%'
IF ls_steam = "" OR IsNull(ls_steam) THEN ls_steam = '%'

IF dw_print.Retrieve(gs_sabu, ls_yyyy,'%','%',ls_cust, ls_yyyyt ) <= 0 THEN
	f_message_chk(50, ' [기타매출] ')
	dw_list.Reset()
	dw_ip.setcolumn('year')
	dw_ip.SetFocus()
	Return -1
END IF

//dw_print.object.t_100.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sabuj) ', 1)"))

//dw_print.ShareData(dw_list)
	
Return 1

end function

on w_sal_02046.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_3
end on

on w_sal_02046.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;f_mod_saupj(dw_ip, 'sabuj')
dw_ip.SetItem(1, "year", Left(f_today(),6) + '01')
dw_ip.SetItem(1, "yeart", f_today())

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

///* User별 관할구역 Setting */
//String sarea, steam, saupj
//
//// 영업팀 권한 설정
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.Modify("sarea.protect=1")
//	dw_ip.Modify("steam.protect=1")
//	
//	dw_ip.SetItem(1, 'sarea', sarea)
//	dw_ip.SetItem(1, 'steam', steam)
//End If
//
end event

type p_preview from w_standard_print`p_preview within w_sal_02046
end type

type p_exit from w_standard_print`p_exit within w_sal_02046
end type

type p_print from w_standard_print`p_print within w_sal_02046
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02046
end type











type dw_print from w_standard_print`dw_print within w_sal_02046
integer x = 3753
integer y = 40
string dataobject = "d_sal_02046_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02046
integer x = 64
integer y = 56
integer width = 3465
integer height = 208
string dataobject = "d_sal_02046"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;
IF this.GetColumnName() = "custname" THEN
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

END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02046
event ue_mousemove pbm_mousemove
integer x = 64
integer y = 312
integer width = 4539
integer height = 1976
string dataobject = "d_sal_02046_p"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_02046
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

type rr_3 from roundrectangle within w_sal_02046
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

