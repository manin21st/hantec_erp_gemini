$PBExportHeader$w_sal_06610.srw
$PBExportComments$===> 월 해외영업 현황
forward
global type w_sal_06610 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06610
end type
end forward

global type w_sal_06610 from w_standard_print
string title = "월 해외영업 현황"
rr_1 rr_1
end type
global w_sal_06610 w_sal_06610

type variables
string a_yy, a_mm, a_steam, a_steamnm
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_yymm ,tx_name

dw_ip.AcceptText()

a_yy     = trim(dw_ip.GetItemString(1,'a_yy'))
a_mm     = trim(dw_ip.GetItemString(1,'a_mm'))
a_steam  = trim(dw_ip.GetItemString(1,'a_steam'))

//기준년도 CHECK
if	(a_yy='') or isNull(a_yy) or integer(a_yy) <= 1990 then           
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('a_yy')
	dw_ip.setfocus()
	Return -1 
end if

//기준월 CHECK
if	(a_mm ='') or isNull(a_mm) or integer(a_mm) <= 0 or integer(a_mm) > 12 then
	f_Message_Chk(35, '[기준월]')
	dw_ip.setcolumn('a_mm')
	dw_ip.setfocus()
	Return -1
end if

if a_steam = "" or IsNull(a_steam) then     // 영업팀처리
   f_Message_Chk(30, '[영업팀]')
	dw_ip.setcolumn('a_steam')
	dw_ip.setfocus()
	Return -1
//	a_steam = '1%'
//	a_steamnm = '전  체'
//else
//   SELECT STEAMNM
//     INTO :a_steamnm  
//     FROM STEAM
//	 WHERE STEAMCD = :a_steam;
end if	

if dw_print.Retrieve(gs_sabu, a_yy,a_mm,a_steam,a_steamnm) <= 0 then
	f_message_chk(50,'[월 해외 영업 현황]')
	dw_ip.setcolumn('a_yy')
	//return -1
	dw_list.insertrow(0)
end if

SELECT MAX(JPDAT)
INTO  :ls_yymm
FROM JUNPYO_CLOSING
WHERE JPGU = 'X3' ;

dw_list.object.tx_yymm.text = left(ls_yymm,4) + '.' + mid(ls_yymm,5,2)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(a_steam) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("s_steamcd.text = '"+tx_name+"'")

dw_print.sharedata(dw_list)

return 1

end function

on w_sal_06610.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06610.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sTeamCd

///* 해외영업팀 */
//select min(steamcd) into :sTeamCd 
//  from steam 
// where steamcd like '1%';
// 
//dw_ip.SetItem(1,'a_steam',sTeamCd)

dw_ip.setitem(1,'a_yy',left(f_today(),4))
dw_ip.setitem(1,'a_mm',mid(f_today(),5,2))

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'a_steam', steam)
	dw_ip.Modify("a_steam.protect=1")
	dw_ip.Modify("a_steam.background.color = 80859087")
End If

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_06610
boolean visible = false
integer x = 3232
integer y = 84
end type

type p_exit from w_standard_print`p_exit within w_sal_06610
end type

type p_print from w_standard_print`p_print within w_sal_06610
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06610
integer x = 4096
end type







type st_10 from w_standard_print`st_10 within w_sal_06610
end type



type dw_print from w_standard_print`dw_print within w_sal_06610
string dataobject = "d_sal_06610_01"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06610
integer x = 18
integer width = 1760
integer height = 360
string dataobject = "d_sal_06610"
end type

event dw_ip::itemchanged;string snull, s_name , s_name1, sPrtGbn
int    ireturn 

setnull(snull)

CHOOSE CASE this.GetColumnName()
	CASE 'a_steam'
	   a_steam = this.GetText()
   
	   if a_steam = "" or isnull(a_steam) then 
		   this.setitem(1, 'a_steam', snull)
         return 
	   end if	
	
   	ireturn = f_get_name2('영업팀', 'Y', a_steam, s_name, s_name1)	

      this.setitem(1, 'a_steam', a_steam)
	
	   return ireturn 
Case 'prtgbn'
	sPrtGbn = Trim(GetText())
	
	dw_list.SetRedraw(False)
	If sPrtGbn = '0' Then
    	dw_list.DataObject = 'd_sal_06610_01'
    	dw_list.SetTransObject(SQLCA)
	ElseIf sPrtGbn = '1' Then
    	dw_list.DataObject = 'd_sal_06610_03'
    	dw_list.SetTransObject(SQLCA)
	Else
    	dw_list.DataObject = 'd_sal_06610_04'
    	dw_list.SetTransObject(SQLCA)
	End If
	dw_list.SetRedraw(True)
END CHOOSE

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_06610
integer x = 46
integer y = 396
integer width = 4562
integer height = 1944
string dataobject = "d_sal_06610_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06610
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 384
integer width = 4594
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

