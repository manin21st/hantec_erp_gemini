$PBExportHeader$w_sal_06640.srw
$PBExportComments$===> 관할구역별 월 제품실적 분석
forward
global type w_sal_06640 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06640
end type
end forward

global type w_sal_06640 from w_standard_print
string title = "관할구역별 월 제품실적 분석"
rr_1 rr_1
end type
global w_sal_06640 w_sal_06640

type variables
string a_yymm, a_fmyymm,a_curr,a_ittyp,a_gubun
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();If dw_ip.AcceptText() <> 1 Then Return -1

a_yymm   = dw_ip.GetItemString(1,'a_yymm')
a_fmyymm = dw_ip.GetItemString(1,'a_fmyymm')
a_curr   = trim(dw_ip.GetItemString(1,'a_curr'))
a_ittyp  = trim(dw_ip.GetItemString(1,'a_ittyp'))
a_gubun  = trim(dw_ip.GetItemString(1,'a_gubun'))

If f_datechk(a_yymm+'01') <> 1 Then
	f_Message_Chk(35, '[FROM년월]')
	dw_ip.setcolumn('a_fmyymm')
	dw_ip.setfocus()
	Return -1 
End if

If f_datechk(a_fmyymm+'01') <> 1 Then
	f_Message_Chk(35, '[TO년월]')
	dw_ip.setcolumn('a_fmyymm')
	dw_ip.setfocus()
	Return -1 
End if

if a_ittyp = "" or IsNull(a_ittyp) then     // 영업팀처리
	a_ittyp = '%'
end if	

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

CHOOSE CASE a_gubun
	CASE 'A'
        if dw_list.Retrieve(gs_sabu, a_yymm,a_fmyymm,a_ittyp,a_curr,ls_silgu) <= 0 then
           f_message_chk(50,'[관할구역별 월 제품실적 분석현황]')
	        dw_ip.setcolumn('a_yymm')
	        return -1
        end if
	CASE 'B'
        if dw_list.Retrieve(gs_sabu, a_yymm,a_fmyymm,a_ittyp,a_curr,ls_silgu) <= 0 then
           f_message_chk(50,'[바이어별 제품 판매현황]')
	        dw_ip.setcolumn('a_yymm')
	        return -1
        end if			
		  
END CHOOSE

dw_list.object.tx_year.text = String(a_fmyymm,'@@@@.@@') + " - " + String(a_yymm,'@@@@.@@')
//If a_curr = 'WON' Then
//	dw_list.object.tx_curr.text = a_curr +' (천원)'
//Else
//	dw_list.object.tx_curr.text = a_curr 
//end If

return 1

end function

on w_sal_06640.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06640.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'a_fmyymm',left(f_today(),4) + '01')
dw_ip.setitem(1,'a_yymm',left(f_today(),6))

dw_list.Sharedataoff()
end event

type p_preview from w_standard_print`p_preview within w_sal_06640
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within w_sal_06640
end type

type p_print from w_standard_print`p_print within w_sal_06640
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_06640
end type







type st_10 from w_standard_print`st_10 within w_sal_06640
end type



type dw_print from w_standard_print`dw_print within w_sal_06640
string dataobject = "d_sal_06640_01"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06640
integer x = 5
integer y = 40
integer width = 2331
integer height = 216
string dataobject = "d_sal_06640"
end type

event dw_ip::itemchanged;string snull, s_name
int    ireturn 

setnull(snull)

CHOOSE CASE this.GetColumnName()

	CASE 'sittyp'
		
		a_ittyp = this.GetText()
		
		if a_ittyp = "" or isnull(a_ittyp) then 
         return 
	   end if	
		
		s_name = f_get_reffer('05',a_ittyp)
		
		if	(s_name = '') or isNull(s_name) then    // 품목구분 CHECK
       	f_Message_Chk(33, '[품목분류]')
			this.setitem(1, 'a_ittyp', snull)
      	Return 1
      end if

	CASE 'a_gubun'
		dw_list.SetRedraw(False)
 		if this.GetText() = 'A' then     // 관할구역별 출력
			dw_list.DataObject = "d_sal_06640_01"
			dw_print.DataObject = "d_sal_06640_01"
			dw_list.Settransobject(sqlca)
		elseif this.GetText() = 'B' then // BUYER 별 출력
			dw_list.DataObject = "d_sal_06640_02"
			dw_print.DataObject = "d_sal_06640_02"
			dw_list.Settransobject(sqlca)
		end if
		dw_print.Settransobject(sqlca)
		dw_list.SetRedraw(True)
END CHOOSE
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_06640
integer x = 27
integer y = 288
integer height = 2020
string dataobject = "d_sal_06640_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06640
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 272
integer width = 4622
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

