$PBExportHeader$w_sal_06630.srw
$PBExportComments$===> 전년수출실적 및 당년 판매계획대비 실적현황
forward
global type w_sal_06630 from w_standard_dw_graph
end type
end forward

global type w_sal_06630 from w_standard_dw_graph
string title = "전년수출실적 및 당년 판매계획대비 실적현황"
end type
global w_sal_06630 w_sal_06630

type variables
string a_yyyy,a_fmyyyy,a_steam,a_steamnm,a_sarea
string a_sareanm,a_curr
integer a_chasu
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sMM

If dw_ip.AcceptText() <> 1 Then Return -1

a_yyyy   = Left(trim(dw_ip.GetItemString(1,'a_yy')),4)
sMm     = Right(trim(dw_ip.GetItemString(1,'a_yy')),2)

a_fmyyyy = string(integer(a_yyyy) - 1,'0000')
a_steam  = trim(dw_ip.GetItemString(1,'a_steam'))
a_sarea  = trim(dw_ip.GetItemString(1,'a_sarea'))
a_curr   = trim(dw_ip.GetItemString(1,'a_curr'))
a_chasu  = dw_ip.GetItemNumber(1,'a_chasu')

//기준년도 CHECK
if	f_datechk(a_yyyy+sMM+'01') <> 1 then
	f_Message_Chk(35, '[기준년월]'+a_yyyy+sMM)
	dw_ip.setcolumn('a_yy')
	dw_ip.setfocus()
	Return -1 
end if

if a_steam = "" or IsNull(a_steam) then     // 영업팀처리
	a_steam = '1%'
	a_steamnm = '전  체'
else
   SELECT STEAMNM
     INTO :a_steamnm  
     FROM STEAM
	 WHERE STEAMCD = :a_steam;
end if	

if a_sarea = "" or IsNull(a_sarea) then     // 관할구역명 처리
	a_sarea = '%'
	a_sareanm = '전  체'
else
   SELECT SAREANM
     INTO :a_sareanm
     FROM SAREA
	 WHERE SAREA = :a_sarea;
end if

if dw_list.Retrieve(gs_sabu, a_yyyy,a_fmyyyy,sMM, a_chasu, a_steam, a_steamnm, a_sarea, a_sareanm, a_curr ) <= 0 then
	f_message_chk(50,'[관할구역별 년간 판매계획 현황]')
	dw_ip.setcolumn('a_yy')
	dw_ip.Setfocus()
	return -1
end if

return 1

end function

on w_sal_06630.create
call super::create
end on

on w_sal_06630.destroy
call super::destroy
end on

event open;call super::open;String sTeamCd

/* 해외영업팀 */
//select min(steamcd) into :sTeamCd 
//  from steam 
// where steamcd like '1%';
// 
//dw_ip.SetItem(1,'a_steam',sTeamCd)
dw_ip.setitem(1,'a_yy',left(f_today(),6))

/* User별 관할구역 Setting */
String sarea, steam , saupj

//관할 구역
f_child_saupj(dw_ip, 'a_sarea', gs_saupj) 

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'a_sarea', sarea)
	dw_ip.SetItem(1, 'a_steam', steam)
	dw_ip.Modify("a_sarea.protect=1")
	dw_ip.Modify("a_steam.protect=1")
	dw_ip.Modify("a_sarea.background.color = 80859087")
	dw_ip.Modify("a_steam.background.color = 80859087")
End If
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_06630
end type

type p_print from w_standard_dw_graph`p_print within w_sal_06630
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_06630
end type

type st_window from w_standard_dw_graph`st_window within w_sal_06630
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_06630
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_06630
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_06630
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_06630
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_06630
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_06630
integer x = 14
integer y = 4
integer width = 2551
integer height = 296
string dataobject = "d_sal_06630"
end type

event dw_ip::itemchanged;string snull, s_name , s_name1
int    ireturn 

setnull(snull)

CHOOSE CASE this.GetColumnName()

	CASE 'a_steam'
		
   	this.accepttext()
	
	   a_steam = this.GetText()
   
	   if a_steam = "" or isnull(a_steam) then 
		   this.setitem(1, 'a_steam', snull)
         return 
	   end if	
	
   	ireturn = f_get_name2('영업팀', 'Y', a_steam, s_name, s_name1)	

      this.setitem(1, 'a_steam', a_steam)
	
	   return ireturn 
	CASE 'a_sarea'
		
   	this.accepttext()
	
	   a_sarea = this.GetText()
	
	   if a_sarea = "" or isnull(a_sarea) then 
		   this.setitem(1, 'a_sarea', snull)
         return 
	   end if	
	
   	ireturn = f_get_name2('관할구역', 'Y', a_sarea,  s_name, s_name1)	

      this.setitem(1, 'a_sarea', a_sarea)
	
	   return ireturn 

END CHOOSE
end event

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_06630
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_06630
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_06630
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_06630
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_06630
integer y = 328
integer width = 4567
integer height = 2004
string dataobject = "d_sal_06630_01"
boolean border = false
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_06630
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_06630
integer y = 316
integer height = 2036
end type

