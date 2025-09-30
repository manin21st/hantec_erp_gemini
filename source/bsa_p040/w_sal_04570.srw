$PBExportHeader$w_sal_04570.srw
$PBExportComments$ ===> 부도어음 현황
forward
global type w_sal_04570 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_04570
end type
end forward

global type w_sal_04570 from w_standard_print
string title = "부도어음 현황"
rr_1 rr_1
end type
global w_sal_04570 w_sal_04570

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sSteam, sYear ,ls_pgubun

if dw_ip.AcceptText() <> 1 then return -1

sYear = Trim(dw_ip.GetItemString(1,'syy'))
sSteam = Trim(dw_ip.GetItemString(1,'ssteam'))
ls_pgubun = Trim(dw_ip.getitemstring(1,'pgubun'))

if	(sYear='') or isNull(sYear) then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
END IF

if isNull(sSteam) or (sSteam = '') then
	sSteam = ''
end if

dw_list.object.r_yy.Text = sYear
dw_print.object.r_yy.Text = sYear

sSteam = sSteam+'%'

string ls_silgu

SELECT DATANAME
INTO   :ls_silgu
FROM   SYSCNFG
WHERE  SYSGU = 'S'   AND
       SERIAL = '8'  AND
       LINENO = '40' ;

if ls_pgubun = '1' then
//	if dw_list.Retrieve(gs_sabu, sYear, sSteam,ls_silgu) < 1 then
//		f_message_Chk(300, '[출력조건 CHECK]')
//		dw_ip.setcolumn('syy')
//		dw_ip.setfocus()
//		return -1
//	end if
	
	if dw_print.Retrieve(gs_sabu, sYear, sSteam,ls_silgu) < 1 then
		f_message_Chk(300, '[출력조건 CHECK]')
		dw_ip.setcolumn('syy')
		dw_ip.setfocus()
		return -1
	end if
	
else
//	if dw_list.Retrieve(sYear, sSteam) < 1 then
//		f_message_Chk(300, '[출력조건 CHECK]')
//		dw_ip.setcolumn('syy')
//		dw_ip.setfocus()
//		return -1
//	end if
	
	if dw_print.Retrieve(sYear, sSteam) < 1 then
		f_message_Chk(300, '[출력조건 CHECK]')
		dw_ip.setcolumn('syy')
		dw_ip.setfocus()
		return -1
	end if
	
end if

dw_print.ShareData(dw_list)

return 1





end function

on w_sal_04570.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_04570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, "ssteam", sarea)
	dw_ip.Modify("ssteam.protect=1")
	dw_ip.Modify("ssteam.background.color = 80859087")
End If

dw_ip.setitem(1,'syy',left(f_today(),4))

dw_Ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_sal_04570
end type

type p_exit from w_standard_print`p_exit within w_sal_04570
end type

type p_print from w_standard_print`p_print within w_sal_04570
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04570
end type







type st_10 from w_standard_print`st_10 within w_sal_04570
end type



type dw_print from w_standard_print`dw_print within w_sal_04570
string dataobject = "d_sal_04570_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04570
integer x = 23
integer y = 28
integer width = 2757
integer height = 156
string dataobject = "d_sal_04570_01"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, mm_chk ,ls_pgubun

dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
   // 기준년도 유효성 Check
	Case "syy"  
		if (Not(isNumber(Trim(this.getText())))) or (Len(Trim(this.getText())) <> 4) then
			f_Message_Chk(35, '[기준년도]')
			this.SetItem(1, "syy", sNull)
			return 1
		end if
		p_retrieve.TriggerEvent(Clicked!)
		
	// 영업팀 버턴클릭시
	Case "ssteam"
		p_retrieve.SetFocus()
		return 1			
	Case 'pgubun'
		ls_pgubun = Trim(GetText())
		
		dw_list.setredraw(false)
		
		if ls_pgubun = '1' then
			dw_list.dataobject = 'd_sal_04570'
			dw_print.dataobject = 'd_sal_04570_p'
		else
			dw_list.dataobject = 'd_sal_04570_02'
			dw_print.dataobject = 'd_sal_04570_02_p'
		end if
		
		dw_list.SetTransObject(Sqlca)
		dw_print.SetTransObject(Sqlca)
		dw_list.setredraw(true)
		
end Choose
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_04570
integer x = 46
integer y = 192
integer width = 4512
integer height = 2132
string dataobject = "d_sal_04570"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_sal_04570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 184
integer width = 4539
integer height = 2152
integer cornerheight = 40
integer cornerwidth = 55
end type

