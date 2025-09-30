$PBExportHeader$w_imt_04710.srw
$PBExportComments$금형/치공구 이력카드
forward
global type w_imt_04710 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_04710
end type
end forward

global type w_imt_04710 from w_standard_print
string title = "금형 이력현황"
boolean maxbox = true
rr_1 rr_1
end type
global w_imt_04710 w_imt_04710

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_gubun ,ls_kumgubn ,ls_kumno ,ls_kumno1 ,tx_name

if dw_ip.accepttext() <> 1 then return -1

ls_gubun   =  dw_ip.getitemstring(1,'gubun')
ls_kumgubn =  Trim(dw_ip.getitemstring(1,'kumgubn'))
ls_kumno   =  Trim(dw_ip.getitemstring(1,'kumno'))
ls_kumno1  =  Trim(dw_ip.getitemstring(1,'kumno1'))

If Trim(ls_gubun) = '' OR IsNull(ls_gubun) Then ls_gubun = 'M'
if ls_kumgubn = "" or isnull(ls_kumgubn) then ls_kumgubn = '%'
if ls_kumno = "" or isnull(ls_kumno) then ls_kumno = '.'
if ls_kumno1 = "" or isnull(ls_kumno1) then ls_kumno1 = 'ZZZZZZZZZZZZZZZZZZZZ'

If LEN(ls_kumgubn) = 1 Then
	If ls_kumgubn <> '%' Then ls_kumgubn = ls_kumgubn + '%'
End If

//messagebox('1', gs_sabu+'/'+ls_gubun+'/'+ls_kumgubn+'/'+ls_kumno+'/'+ls_kumno1)

if dw_print.retrieve(gs_sabu , ls_gubun ,ls_kumgubn ,ls_kumno ,ls_kumno1) < 1 then
	f_message_chk(300,'')
	dw_ip.setcolumn('kumgubn')
	dw_ip.setfocus()
	return -1
	dw_print.ShareData(dw_list)
end if

//if ls_gubun = 'M' then
//	dw_list.object.tx_gubun.text = '금형'
//else
//	dw_list.object.tx_gubun.text = '치공구'
//end if

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(kumgubn) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_kumgubn.text = '"+tx_name+"'")

return 1

end function

on w_imt_04710.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_04710.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_imt_04710
end type

type p_sort from w_standard_print`p_sort within w_imt_04710
end type

type p_preview from w_standard_print`p_preview within w_imt_04710
end type

type p_exit from w_standard_print`p_exit within w_imt_04710
end type

type p_print from w_standard_print`p_print within w_imt_04710
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04710
end type







type st_10 from w_standard_print`st_10 within w_imt_04710
end type



type dw_print from w_standard_print`dw_print within w_imt_04710
string dataobject = "d_imt_047101_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04710
integer x = 133
integer y = 60
integer width = 983
integer height = 176
string dataobject = "d_imt_047001_2"
end type

event dw_ip::rbuttondown;call super::rbuttondown;STRING ls_kumno ,ls_kumno1 ,ls_data

ls_data = Trim(dw_ip.getcolumnname())

Choose Case ls_data
	Case 'kumno'  
	    gs_gubun = '1'
		 
		 open(w_imt_04630_popup)
		 
		 dw_ip.setitem(1,'kumno',gs_code)
		 
	Case 'kumno1' 
		 gs_gubun = '1'
		 
		 open(w_imt_04630_popup)
		 
		 dw_ip.setitem(1,'kumno1',gs_code)
	
End Choose
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_04710
integer x = 146
integer y = 312
integer width = 4389
integer height = 1992
string dataobject = "d_imt_047101_p"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_04710
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 133
integer y = 300
integer width = 4416
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

