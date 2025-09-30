$PBExportHeader$w_sal_06840.srw
$PBExportComments$관할구역별 수금경향
forward
global type w_sal_06840 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06840
end type
type rr_1 from roundrectangle within w_sal_06840
end type
end forward

global type w_sal_06840 from w_standard_print
string title = "관할구역별 수금경향"
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_06840 w_sal_06840

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_ipgum_date , ls_ipgum_date2 ,ls_base_yymm,ls_base_yymm2,ls_sarea ,ls_date , ls_gubun ,tx_name
string tx_gb1,tx_gb2,tx_gb3,tx_gb4,tx_gb5

if dw_ip.accepttext() <> 1 then return -1

ls_ipgum_date = trim(dw_ip.getitemstring(1,'ipgum_date'))
ls_sarea      = trim(dw_ip.getitemstring(1,'sarea' ))
ls_gubun      = trim(dw_ip.getitemstring(1,'gubun' ))

ls_ipgum_date2= (f_aftermonth(left(ls_ipgum_date,6),-29) + '01')
ls_base_yymm  = left(ls_ipgum_date,6)
ls_base_yymm2 = left(ls_ipgum_date2,6)

if ls_ipgum_date= "" or isnull(ls_ipgum_date) then
	f_message_chk(35,'[보고기준일]')
	dw_ip.setcolumn('ipgum_date')
	dw_ip.setfocus()
   return -1
end if

if ls_sarea = "" or isnull(ls_sarea) then ls_sarea='%'

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_print.retrieve(gs_sabu,ls_base_yymm,ls_ipgum_date,ls_sarea,ls_base_yymm2,ls_ipgum_date2,ls_gubun,ls_silgu) < 1 then
	f_message_chk(300,'[출력조건 CHECK]')
	dw_ip.setcolumn('ipgum_date')
	dw_ip.setfocus()
	dw_print.InsertRow(0)
//   return -1
else
	dw_print.sharedata(dw_list)
end if

//dw_list.object.tx_ipgum_date.text = left(ls_ipgum_date,4) + '.' + mid(ls_ipgum_date,5,2) + '.' + mid(ls_ipgum_date,7,2)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

tx_gb1 = f_aftermonth(left(ls_ipgum_date,6),-18)
tx_gb2 = f_aftermonth(left(ls_ipgum_date,6),-12)
tx_gb3 = f_aftermonth(left(ls_ipgum_date,6),-9)
tx_gb4 = f_aftermonth(left(ls_ipgum_date,6),-6)
tx_gb5 = f_aftermonth(left(ls_ipgum_date,6),-3)

dw_print.object.tx_gb1.text = left(tx_gb1,4) + '.' + mid(tx_gb1,5,2) 
dw_print.object.tx_gb2.text = left(tx_gb2,4) + '.' + mid(tx_gb2,5,2) 
dw_print.object.tx_gb3.text = left(tx_gb3,4) + '.' + mid(tx_gb3,5,2) 
dw_print.object.tx_gb4.text = left(tx_gb4,4) + '.' + mid(tx_gb4,5,2) 
dw_print.object.tx_gb5.text = left(tx_gb5,4) + '.' + mid(tx_gb5,5,2) 

dw_list.object.tx_gb1.text = left(tx_gb1,4) + '.' + mid(tx_gb1,5,2) 
dw_list.object.tx_gb2.text = left(tx_gb2,4) + '.' + mid(tx_gb2,5,2) 
dw_list.object.tx_gb3.text = left(tx_gb3,4) + '.' + mid(tx_gb3,5,2) 
dw_list.object.tx_gb4.text = left(tx_gb4,4) + '.' + mid(tx_gb4,5,2) 
dw_list.object.tx_gb5.text = left(tx_gb5,4) + '.' + mid(tx_gb5,5,2) 

return 1

end function

on w_sal_06840.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_06840.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'ipgum_date',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_sal_06840
end type

type p_exit from w_standard_print`p_exit within w_sal_06840
end type

type p_print from w_standard_print`p_print within w_sal_06840
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06840
end type







type st_10 from w_standard_print`st_10 within w_sal_06840
end type



type dw_print from w_standard_print`dw_print within w_sal_06840
string dataobject = "d_sal_06840_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06840
integer x = 37
integer y = 24
integer width = 2715
integer height = 140
string dataobject = "d_sal_06840_04"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_gubun,ls_name ,snull ,sIoCust ,sIoCustName

ls_Name = This.GetColumnName()
SetNull(sNull)

Choose Case ls_Name
	// 보고기준일 유효성 Check
   Case "ipgum_date"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "ipgum_date", sNull)
			f_Message_Chk(35, '[보고기준일]')
			 dw_ip.setcolumn('ipgum_date')
			 dw_ip.setfocus()
			return 1
		end if
end choose
end event

event dw_ip::dberror;call super::dberror;return 1
end event

event dw_ip::error;call super::error;return 
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_06840
integer y = 180
integer width = 4553
integer height = 2136
string dataobject = "d_sal_06840_03"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06840
integer x = 750
integer y = 44
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('ipgum_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'ipgum_date', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06840
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 176
integer width = 4571
integer height = 2152
integer cornerheight = 40
integer cornerwidth = 55
end type

