$PBExportHeader$w_sal_06620.srw
$PBExportComments$===> 관할구역별 전년대비 오더 접수금액 현황
forward
global type w_sal_06620 from w_standard_print
end type
end forward

global type w_sal_06620 from w_standard_print
string title = "관할구역별 전년대비 오더 접수금액 현황"
end type
global w_sal_06620 w_sal_06620

type variables
string a_yy, a_fmyy,a_curr, a_steam, a_steamnm,a_gubun
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sToDate, a_tomm, tx_name

If dw_ip.AcceptText() <> 1 Then Return 1

/* 기준년월 */
sToDate = trim(dw_ip.GetItemString(1,'a_yy')) 

a_yy     = Left(sToDate,4)
a_tomm   = Right(sToDate,2)

a_fmyy   = string(integer(a_yy) - 1,'0000')
a_curr   = trim(dw_ip.GetItemString(1,'a_curr'))
a_steam  = trim(dw_ip.GetItemString(1,'a_steam'))
a_gubun  = trim(dw_ip.GetItemString(1,'a_gubun'))

//기준년도 CHECK
if	(a_yy='') or isNull(a_yy) or integer(a_yy) <= 1990 then           
	f_Message_Chk(35, '[기준년도]')
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

CHOOSE CASE a_gubun
	CASE 'D'
		
		// dw_print.retrieve 로 바꿀경우 그래프가 조회되지 않음.. 단 미리보기에서는 보임..
        if dw_print.Retrieve(a_yy,a_fmyy,a_curr,a_steam,a_steamnm, a_tomm) <= 0 then
           f_message_chk(50,'[관할구역별 전년대비 오더접수금액 현황]')
	        dw_ip.setcolumn('a_yy')
			  dw_list.insertrow(0)
	        return -1
        end if
//	CASE 'G'
//      dw_list.Retrieve(a_yy,a_fmyy,a_curr,a_steam)
			
END CHOOSE

if a_gubun = 'D' then
	If IsNull(sToDate) Or sToDate = '' Then 
		 sToDate = '전체'
	else
	//dw_list.Modify("tx_yymm.text = '"+sToDate+"'")
	stodate = left(stodate,4) +'.'+mid(stodate,5,2) 
	end if
	dw_print.object.tx_yymm.text = stodate 
end if

dw_print.sharedata(dw_list)

return 1

end function

on w_sal_06620.create
call super::create
end on

on w_sal_06620.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event w_sal_06620::open;call super::open;String sTeamCd

dw_ip.setitem(1,'a_yy',left(f_today(),6))

/* 해외영업팀 */
//select min(steamcd) into :sTeamCd 
//  from steam 
// where steamcd like '1%';
// 
//dw_ip.SetItem(1,'a_steam',sTeamCd)

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'a_steam', steam)
	dw_ip.Modify("a_steam.protect=1")
	//dw_ip.Modify("a_steam.background.color = 80859087")
End If
end event

type p_preview from w_standard_print`p_preview within w_sal_06620
end type

type p_exit from w_standard_print`p_exit within w_sal_06620
end type

type p_print from w_standard_print`p_print within w_sal_06620
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06620
end type







type st_10 from w_standard_print`st_10 within w_sal_06620
end type



type dw_print from w_standard_print`dw_print within w_sal_06620
string dataobject = "d_sal_06620_01_P"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06620
integer x = 96
integer y = 68
integer width = 2821
integer height = 140
string dataobject = "d_sal_06620"
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
		
	CASE 'a_gubun'
 		if this.GetText() = 'D' then     // 데이타 시트로 출력
			dw_list.DataObject = "d_sal_06620_01"
			dw_list.Settransobject(sqlca)
		elseif this.GetText() = 'G' then // 그래프로 출력
			dw_list.DataObject = "d_sal_06620_02"
			dw_list.Settransobject(sqlca)
		end if
END CHOOSE
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_06620
integer x = 105
integer y = 232
integer width = 4475
integer height = 2064
string dataobject = "d_sal_06620_01"
boolean border = false
end type

