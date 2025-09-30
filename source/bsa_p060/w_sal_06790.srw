$PBExportHeader$w_sal_06790.srw
$PBExportComments$ ===> 월별 수출 부대비용 사용현황
forward
global type w_sal_06790 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06790
end type
end forward

global type w_sal_06790 from w_standard_print
string title = "월별 수출 부대비용 사용현황"
rr_1 rr_1
end type
global w_sal_06790 w_sal_06790

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sGubun, yy ,ls_steamcd , ls_sarea , tx_name

dw_ip.AcceptText()

yy = Trim(dw_ip.GetItemString(1,'syy'))
ls_steamcd = Trim(dw_ip.GetItemString(1,'steamcd'))
ls_sarea   = Trim(dw_ip.GetItemString(1,'sarea'))

if	(yy = '') or isNull(yy) then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

if ls_steamcd ="" or isnull(ls_steamcd) then ls_steamcd = '%'
if ls_sarea ="" or isnull(ls_sarea) then ls_sarea = '%'

// 2003년 6월 3일 수정
dw_print.object.r_yy.Text = yy + '년'

if dw_print.Retrieve(gs_sabu, yy , ls_steamcd, ls_sarea) < 1 then
   f_message_Chk(300, '[출력조건 CHECK]')
 	dw_ip.setcolumn('syy')
   dw_ip.setfocus()
 	return -1
end if

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steamcd) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

return 1


//dw_list.object.r_yy.Text = yy + '년'
//
//if dw_list.Retrieve(gs_sabu, yy , ls_steamcd, ls_sarea) < 1 then
//   f_message_Chk(300, '[출력조건 CHECK]')
// 	dw_ip.setcolumn('syy')
//   dw_ip.setfocus()
// 	return -1
//end if
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steamcd) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_steamcd.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_sarea.text = '"+tx_name+"'")
//
//return 1
end function

on w_sal_06790.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06790.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'syy',left(f_today(),4))
sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

/* User별 관할구역 Setting */
String sarea, steam , saupj

//관할 구역
f_child_saupj(dw_ip, 'sarea', gs_saupj) 

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'sarea', sarea)
	dw_ip.SetItem(1, 'steamcd', steam)
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("steamcd.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
	dw_ip.Modify("steamcd.background.color = 80859087")
End If
end event

type p_xls from w_standard_print`p_xls within w_sal_06790
end type

type p_sort from w_standard_print`p_sort within w_sal_06790
end type

type p_preview from w_standard_print`p_preview within w_sal_06790
end type

type p_exit from w_standard_print`p_exit within w_sal_06790
end type

type p_print from w_standard_print`p_print within w_sal_06790
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06790
end type







type st_10 from w_standard_print`st_10 within w_sal_06790
end type



type dw_print from w_standard_print`dw_print within w_sal_06790
string dataobject = "d_sal_06790_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06790
integer x = 23
integer y = 8
integer width = 2802
integer height = 156
string dataobject = "d_sal_06790_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sCol_Name, sNull, s_YY,sIoCustArea ,sDept

//dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
	// 기준일자 유효성 Check
   Case "syy"
		s_YY = this.GetText()
		if	(s_YY = '') or isNull(s_YY) or Len(s_YY) <> 4 then
      	f_Message_Chk(35, '[기준년도]')
      	dw_ip.setcolumn('syy')
      	dw_ip.setfocus()
      	Return 1
      end if
//		cb_update.SetFocus()
end Choose

Choose Case GetColumnName() 
	/* 영업팀 */
	Case "steamcd"
		SetItem(1,"sarea",sNull)
	/* 관할구역 */
	Case "sarea"
		SetItem(1,"steamcd",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
		SetItem(1,'steamcd',sDept)
end choose
end event

type dw_list from w_standard_print`dw_list within w_sal_06790
integer x = 46
integer y = 188
integer width = 4576
integer height = 2148
string dataobject = "d_sal_06790"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06790
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 176
integer width = 4613
integer height = 2172
integer cornerheight = 40
integer cornerwidth = 55
end type

