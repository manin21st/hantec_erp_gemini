$PBExportHeader$w_sal_06760.srw
$PBExportComments$===> 관할구역별 전년대비 판매금액 현황
forward
global type w_sal_06760 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06760
end type
end forward

global type w_sal_06760 from w_standard_print
string title = "관할구역별 전년대비 판매금액 현황"
rr_1 rr_1
end type
global w_sal_06760 w_sal_06760

type variables
string a_yyyy, a_fmyyyy,a_curr, a_steam, a_steamnm
string a_gubun
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();STring a_tomm

If dw_ip.AcceptText() <> 1 Then Return -1

a_yyyy   = Left(trim(dw_ip.GetItemString(1,'a_yy')),4)
a_tomm   = Right(trim(dw_ip.GetItemString(1,'a_yy')),2)

a_fmyyyy = string(integer(a_yyyy) - 1,'0000')
a_curr   = trim(dw_ip.GetItemString(1,'a_curr'))
a_steam  = trim(dw_ip.GetItemString(1,'a_steam'))
a_gubun  = trim(dw_ip.GetItemString(1,'a_gubun'))

//기준년도 CHECK
if	(a_yyyy = '') or isNull(a_yyyy) or integer(a_yyyy) <= 1990 then           
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
        if dw_list.Retrieve(a_yyyy,a_fmyyyy,a_curr,a_steam,a_steamnm, a_tomm) <= 0 then
           f_message_chk(50,'[관할구역별 전년대비 판매금액 현황]')
	        dw_ip.setcolumn('a_yy')
	        return -1
        end if
	CASE 'G'
        dw_list.Retrieve(a_yyyy,a_fmyyyy,a_curr,a_steam)
		  
END CHOOSE

if dw_print.Retrieve(a_yyyy,a_fmyyyy,a_curr,a_steam,a_steamnm, a_tomm) <= 0 then
           f_message_chk(50,'[관할구역별 전년대비 판매금액 현황]')
	        dw_ip.setcolumn('a_yy')
	        return -1
        end if
   dw_print.sharedata(dw_list)

return 1

end function

on w_sal_06760.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06760.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'a_yy',left(f_today(),6))
end event

type p_preview from w_standard_print`p_preview within w_sal_06760
end type

type p_exit from w_standard_print`p_exit within w_sal_06760
end type

type p_print from w_standard_print`p_print within w_sal_06760
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06760
end type







type st_10 from w_standard_print`st_10 within w_sal_06760
end type



type dw_print from w_standard_print`dw_print within w_sal_06760
string dataobject = "d_sal_06760_01_P"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06760
integer x = 59
integer y = 32
integer width = 3095
integer height = 212
string dataobject = "d_sal_06760"
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
			dw_list.DataObject = "d_sal_06760"
			dw_list.Settransobject(sqlca)
		elseif this.GetText() = 'G' then // 그래프로 출력
			dw_list.DataObject = "d_sal_06760_02"
			dw_list.Settransobject(sqlca)
		end if
END CHOOSE
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_06760
integer x = 82
integer y = 256
integer width = 4503
integer height = 2048
string dataobject = "d_sal_06760_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06760
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 244
integer width = 4530
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

