$PBExportHeader$w_sal_06830.srw
$PBExportComments$미수경향
forward
global type w_sal_06830 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06830
end type
type rr_1 from roundrectangle within w_sal_06830
end type
end forward

global type w_sal_06830 from w_standard_print
string title = "미수경향"
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_06830 w_sal_06830

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_date1,ls_cvcod,ls_steamcd,ls_sarea,ls_gubun,ls_date2,ls_edate,ls_date3 ,tx_name

if dw_ip.accepttext() <> 1 then return -1

ls_date2    =  trim(dw_ip.getitemstring(1,'date1')) 
ls_cvcod    =  trim(dw_ip.getitemstring(1,'cvcod'))
ls_steamcd  =  trim(dw_ip.getitemstring(1,'steamcd'))
ls_sarea    =  trim(dw_ip.getitemstring(1,'sarea'))
ls_gubun    =  trim(dw_ip.getitemstring(1,'gubun'))

if ls_date2= "" or isnull(ls_date2) then
	f_message_chk(35,'[보고기준일]')
	dw_ip.setcolumn('date1')
	dw_ip.setfocus()

	return -1
end if

if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'
if ls_steamcd = "" or isnull(ls_steamcd) then ls_steamcd = '%'
if ls_sarea = "" or isnull(ls_sarea) then ls_sarea = '%'

//보고기준일의 해당 월로 이월 미수와 전월 매출을 구한다.
ls_date1 = left(ls_date2,6)
ls_edate = f_aftermonth(ls_date1,-1)
ls_date3 = ls_date1 + '01'

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_print.retrieve(gs_sabu,ls_date1,ls_cvcod ,ls_steamcd ,ls_sarea ,ls_gubun,ls_date2,ls_edate,ls_date3,ls_silgu) < 1 then
	f_message_chk(300,'[출력조건 CHECK]')
	dw_ip.setcolumn('date1')
	dw_ip.setfocus()
	dw_print.InsertRow(0)
//   return -1
else
	dw_print.sharedata(dw_list)
end if

if ls_gubun ='1' then
	dw_print.object.tx_nm.text='거래처'
//	dw_list.object.tx_jogun.text = '거래처명 :'
   
	tx_name = trim(dw_ip.getitemstring(1,'cvcodnm'))
	if isnull(tx_name) or tx_name= '' then tx_name ='전체 '
//	dw_list.Modify("tx_jogun1.text = '"+tx_name+"'")
//	
elseif ls_gubun ='2' then
   dw_print.object.tx_nm.text='영업팀'
	dw_print.object.tx_jogun.text = '영업팀명 :'
	
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steamcd) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_print.Modify("tx_jogun1.text = '"+tx_name+"'")
	
else
	dw_print.object.tx_nm.text='관할구역'
	dw_print.object.tx_jogun.text = '관할구역명 :'
	
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_print.Modify("tx_jogun1.text = '"+tx_name+"'")
end if

//dw_list.object.tx_date.text = left(ls_date2,4) + '.' + mid(ls_date2,5,2) + '.' + mid(ls_date2,7,2) 
  

return 1
end function

on w_sal_06830.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_06830.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'date1',left(f_today(),8))

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("steamcd.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
	dw_ip.Modify("steamcd.background.color = 80859087")
End If
dw_ip.SetItem(1, 'sarea', sarea)
dw_ip.SetItem(1, 'steamcd', steam)
end event

type p_preview from w_standard_print`p_preview within w_sal_06830
end type

type p_exit from w_standard_print`p_exit within w_sal_06830
end type

type p_print from w_standard_print`p_print within w_sal_06830
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06830
end type







type st_10 from w_standard_print`st_10 within w_sal_06830
end type



type dw_print from w_standard_print`dw_print within w_sal_06830
string dataobject = "d_sal_06830_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06830
integer y = 24
integer width = 3657
integer height = 220
string dataobject = "d_sal_06830_02"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;string ls_gubun,ls_name ,snull ,sIoCust ,sIocvcodnm, sCvcod, scvnas, sarea, steam, sSaupj, sName1

ls_Name = This.GetColumnName()
SetNull(sNull)

Choose Case ls_Name
	// 보고기준일 유효성 Check
   Case "date1"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "date1", sNull)
			f_Message_Chk(35, '[기준년월]')
			 dw_ip.setcolumn('date1')
			 dw_ip.setfocus()
			return 1
		end if
//	case 'gubun'
//		if trim(this.gettext()) = '1' then
//			 dw_ip.setitem(1,'cvcod',snull)
//			 dw_ip.setitem(1,'cvcodnm',snull)
//			 dw_ip.setitem(1,'steamcd',snull)
//			 dw_ip.setitem(1,'sarea',snull)
//			 dw_ip.object.cvcod.protect = '0'
//			 dw_ip.object.cvcod.background.color =RGB(255,255,0)
//			 dw_ip.object.steamcd.protect = '1'
//			 dw_ip.object.steamcd.background.color =RGB(192,192,192)
//			 dw_ip.object.sarea.protect = '1'
//			 dw_ip.object.sarea.background.color =RGB(192,192,192)
//			 dw_ip.setcolumn('cvcod')
//			 dw_ip.setfocus()
//		elseif trim(this.gettext()) = '2' then
//			 dw_ip.setitem(1,'cvcod',snull)
//			 dw_ip.setitem(1,'cvcodnm',snull)
//			 dw_ip.setitem(1,'steamcd',snull)
//			 dw_ip.setitem(1,'sarea',snull)
//			 dw_ip.object.cvcod.protect = '1'
//			 dw_ip.object.cvcod.background.color =RGB(192,192,192)
//			 dw_ip.object.steamcd.protect = '0'
//			 dw_ip.object.steamcd.background.color =RGB(255,255,255)
//			 dw_ip.object.sarea.protect = '1'
//			 dw_ip.object.sarea.background.color =RGB(192,192,192)
//			 dw_ip.setcolumn('steamcd')
//			 dw_ip.setfocus()
//		else
//			 dw_ip.setitem(1,'cvcod',snull)
//			 dw_ip.setitem(1,'cvcodnm',snull)
//			 dw_ip.setitem(1,'steamcd',snull)
//			 dw_ip.setitem(1,'sarea',snull)
//			 dw_ip.object.cvcod.protect = '1'
//			 dw_ip.object.cvcod.background.color =RGB(192,192,192)
//			 dw_ip.object.steamcd.protect = '1'
//			 dw_ip.object.steamcd.background.color =RGB(192,192,192)
//			 dw_ip.object.sarea.protect = '0'
//			 dw_ip.object.sarea.background.color =RGB(255,255,255)
//			 dw_ip.setcolumn('sarea')
//			 dw_ip.setfocus()
//	   end if
/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"steamcd",   steam)
			SetItem(1,"cvcodnm", scvnas)
			SetItem(1,"sarea",   sarea)	
		END IF
	
end choose

end event

event dw_ip::dberror;call super::dberror;return 1
end event

event dw_ip::error;call super::error;return
end event

event dw_ip::rbuttondown;string sIocvcodnm,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
 Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
 END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06830
integer x = 55
integer y = 280
integer width = 4530
integer height = 2036
string dataobject = "d_sal_06830_01"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06830
integer x = 1157
integer y = 52
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('date1')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'date1', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06830
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 276
integer width = 4562
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

