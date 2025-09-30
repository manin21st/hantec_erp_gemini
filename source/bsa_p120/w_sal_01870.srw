$PBExportHeader$w_sal_01870.srw
$PBExportComments$수주 실적 집계표
forward
global type w_sal_01870 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_01870
end type
end forward

global type w_sal_01870 from w_standard_print
string title = "수주 실적 집계표"
rr_1 rr_1
end type
global w_sal_01870 w_sal_01870

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYYmm, sIttyp, sAmtgu, tx_name
Long   lItcls

If dw_ip.AcceptText() <> 1 Then Return -1

sYYmm		= Trim(dw_ip.GetItemstring(1, 'yymm'))
sIttyp	= Trim(dw_ip.GetItemstring(1, 'ittyp'))
sAmtgu	= Trim(dw_ip.GetItemstring(1, 'amtgu'))
lItcls   = dw_ip.GetItemNumber(1,'prtgbn')

IF	f_datechk(sYYmm+'01') = -1 then
	MessageBox("확인","기준년월을 확인하세요!")
	dw_ip.setcolumn('yymm')
	dw_ip.setfocus()
	Return -1
END IF

If IsNull(sIttyp) Then sIttyp = ''
If IsNull(sAmtgu) Then sAmtgu = ''

If dw_list.Retrieve(gs_sabu, sYYmm, sIttyp+'%', sAmtgu+'%', lItcls) <= 0	Then
	f_message_chk(50,"")
	dw_ip.setcolumn('yymm')
	dw_ip.setfocus()
	Return -1
End if

If dw_print.Retrieve(gs_sabu, sYYmm, sIttyp+'%', sAmtgu+'%', lItcls) < 1 Then Return -1

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_ittyp.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(amtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_amtgu.text = '"+tx_name+"'")

Return 1
end function

on w_sal_01870.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_01870.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_sal_01870
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_print)	

end event

type p_exit from w_standard_print`p_exit within w_sal_01870
end type

type p_print from w_standard_print`p_print within w_sal_01870
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01870
end type







type st_10 from w_standard_print`st_10 within w_sal_01870
end type



type dw_print from w_standard_print`dw_print within w_sal_01870
string dataobject = "d_sal_01870_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01870
integer x = 18
integer y = 32
integer width = 3840
integer height = 208
string dataobject = "d_sal_01870_1"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String sYYmm, sNull

SetNull(sNull)

Choose Case GetColumnName()
	Case 'yymm'
		sYYmm = Trim(GetText())
		IF sYYmm ="" OR IsNull(sYYmm) THEN RETURN
		
		IF f_datechk(sYYmm+'01') = -1 THEN
			f_message_chk(35,'[기준년월]')
			SetItem(1,"yymm",sNull)
			Return 1
		END IF
	Case 'prtgbn'
		dw_list.SetRedraw(False)
		Choose Case Long(GetText())
			Case 2,4,7
				dw_list.Object.rpt_1.DataObject = 'd_sal_018701'
				dw_print.Object.rpt_1.DataObject = 'd_sal_018701'
			Case 15
				dw_list.Object.rpt_1.DataObject = 'd_sal_018702'
				dw_print.Object.rpt_1.DataObject = 'd_sal_018701'				
			Case 20
				dw_list.Object.rpt_1.DataObject = 'd_sal_018703'
				dw_print.Object.rpt_1.DataObject = 'd_sal_018701'				
		End Choose
		dw_list.Settransobject(sqlca)
		dw_print.Settransobject(sqlca)
		dw_list.SetRedraw(True)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_01870
integer x = 46
integer y = 264
integer width = 4535
integer height = 2028
string dataobject = "d_sal_01870"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_sal_01870
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 252
integer width = 4571
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

