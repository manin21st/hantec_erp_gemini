$PBExportHeader$w_sal_05900.srw
$PBExportComments$영업팀별 무상공급 현황(제품군별)
forward
global type w_sal_05900 from w_standard_dw_graph
end type
end forward

global type w_sal_05900 from w_standard_dw_graph
string title = "무상공급 현황(제품군별)"
end type
global w_sal_05900 w_sal_05900

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string printgb,rtn,syear1,syear2,iogbn, tx_name
Long   nRow

If dw_ip.accepttext() <> 1 Then Return -1

syear1  = trim(dw_ip.getitemstring(1, 'syear1'))
syear2  = trim(dw_ip.getitemstring(1, 'syear2'))

IF	IsNull(syear1) or syear1 = '' then
	f_message_chk(1400,'[출고년월]')
	dw_ip.setcolumn('syear1')
	dw_ip.setfocus()
	Return -1
END IF

IF	IsNull(syear2) or syear2 = '' then
	f_message_chk(1400,'[출고년월]')
	dw_ip.setcolumn('syear2')
	dw_ip.setfocus()
	Return -1
END IF

iogbn  = trim(dw_ip.getitemstring(1, 'iogbn'))
If IsNull(iogbn) Then  iogbn = ''

////////////////////////////////////////////////////////////////

dw_list.SetRedraw(false)

//dw_list.DataObject = 'd_sal_05900'
//dw_list.SetTransObject(sqlca)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(iogbn) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_iogbn.text = '"+tx_name+"'")

printgb = Trim(dw_ip.GetItemString(1,'printgb'))
//If printgb = '1' Then
//	rtn = dw_list.Modify("gr_1.Category='lookupdisplay(steamcd)'")
//	rtn = dw_list.Modify("gr_1.Values='crosstabsum(1)'")	
//	rtn = dw_list.Modify("gr_1.Series='gb'")
//	rtn = dw_list.Modify("gr_1.Category.Label='영업팀'")
//Else
//	rtn = dw_list.Modify("gr_1.Category='lookupdisplay(sarea)'")
//	
//	rtn = dw_list.Modify("gr_1.Values='crosstabsum(1)'")	
//	rtn = dw_list.Modify("gr_1.Series='gb'")
//	rtn = dw_list.Modify("gr_1.Category.Label='관할구역'")
//End If

nRow = dw_list.retrieve(gs_saupj, syear1,syear2,iogbn+'%')
If nRow < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear1')
	dw_ip.setfocus()
	dw_list.InsertRow(0)
//	return -1
ELSE
End if

/* 무상출고 내역이 있는 관할구역만 조회 */
dw_list.SetFilter('vcnt <> 2')
dw_list.Filter()

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05900.create
call super::create
end on

on w_sal_05900.destroy
call super::destroy
end on

event open;call super::open;string syear

syear = Left(f_today(),4)
dw_ip.SetItem(1,'syear1',syear +'01')
dw_ip.SetItem(1,'syear2',left(f_today(),6))
dw_ip.SetItem(1,'printgb','1')


end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05900
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05900
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05900
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05900
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05900
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05900
end type

event pb_title::clicked;sle_msg.Text = ''

//string rtn
//rtn = dw_list.Describe("gr_1.title = " + this.text )
//
////mle_1.text = dw_list.Describe("gr_1.Title")
//
//MessageBox(dw_list.Describe("gr_1.Title"),dw_list.Describe("gr_1.Title"))
//
//dw_list.Modify("gr_1.title = '유상웅 '")
end event

type pb_space from w_standard_dw_graph`pb_space within w_sal_05900
end type

event pb_space::clicked;sle_msg.Text = ''
end event

type pb_color from w_standard_dw_graph`pb_color within w_sal_05900
end type

event pb_color::clicked;sle_msg.Text = ''
end event

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05900
end type

event pb_graph::clicked;sle_msg.Text = ''

end event

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05900
integer x = 0
integer width = 2811
integer height = 188
string dataobject = "d_sal_05900_01"
end type

event dw_ip::itemchanged;string rtn

Choose Case GetColumnName()
	Case 'printgb'
		dw_list.SetRedraw(False)

		If Trim(data) = '1' Then
	      dw_list.DataObject = 'd_sal_059001'
	      dw_list.SetTransObject(sqlca)
			rtn = dw_list.Modify("gr_1.Category='lookupdisplay(steamcd)'")
		Else
	      dw_list.DataObject = 'd_sal_05900'
	      dw_list.SetTransObject(sqlca)
			rtn = dw_list.Modify("gr_1.Category='lookupdisplay(sarea)'")
		End If
		dw_list.SetRedraw(True)
End Choose

end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05900
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05900
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05900
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05900
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05900
event ue_dwngraphcreate pbm_dwngraphcreate
integer width = 4562
integer height = 2072
string dataobject = "d_sal_059001"
boolean controlmenu = true
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05900
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05900
integer width = 4594
integer height = 2104
end type

