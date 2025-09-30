$PBExportHeader$w_van_00020_popup.srw
$PBExportComments$검수자료 등록- VAN
forward
global type w_van_00020_popup from w_inherite_popup
end type
type st_msg from statictext within w_van_00020_popup
end type
type rr_1 from roundrectangle within w_van_00020_popup
end type
end forward

global type w_van_00020_popup from w_inherite_popup
integer height = 1440
string title = "카드 대사"
st_msg st_msg
rr_1 rr_1
end type
global w_van_00020_popup w_van_00020_popup

forward prototypes
public function integer wf_check ()
end prototypes

public function integer wf_check ();String sCardNo, sBaljpno, sSeq, sNull
Long   nCnt, nOkcnt
Dec    dQty

If dw_jogun.AcceptText() <> 1 Then Return 1

SetNull(sNull)

sCardNo = Trim(dw_jogun.GetItemString(1, 'cardno'))
If IsNull(sCardNo) Or sCardNo = '' Then
	st_msg.Text = ''
	Return 1
End If

// Bar code parsing
sBaljpno = Mid(sCardNo,  1, 11)
dQty     = Dec(Mid(sCardNo, 12, 6))
sSeq	   = Mid(sCardNo,  19, 4)

//MessageBox(sBaljpno, sseq)

SetPointer(HourGlass!)

select count(*), sum(decode(x.sarea, 'Y', 1, 0)) into :ncnt, :nOkcnt
  from imhist x, iomatrix y
 where x.sabu = :gs_sabu and
		 x.loteno = :sBaljpno and
		 nvl(x.cust_no,'0000') = :sSeq and
		 x.ioqty = :dQty and
		 x.iogbn = y.iogbn and
		 y.salegu = 'Y' and
		 y.jepumio = 'Y' and
		 x.yebi1 is not null;
If nCnt <= 0 Then
	st_msg.Text = '검수완료된 자료가 없습니다.!!'
Else
	If nOkcnt > 0 And nCnt = nOkcnt Then
		st_msg.Text = '이미 처리된 카드입니다'
	Else
		update imhist x
			set x.sarea = 'Y'
		 where x.sabu = :gs_sabu and
				 x.loteno = :sBaljpno and
				 nvl(x.cust_no,'0000') = :sSeq and
		 		 x.ioqty = :dQty and
		 		 x.yebi1 is not null and
				 exists ( select * from iomatrix y where y.iogbn = x.iogbn and y.salegu = 'Y' and y.jepumio = 'Y');
		If sqlca.sqlcode = 0 Then
//			rollback;
			Commit;
			st_msg.Text = '처리 완료되었습니다'
		Else
			RollBack;
			st_msg.Text = '실패하였습니다.!!'
		End If
	End If
End If

dw_jogun.SetFocus()
dw_jogun.SetColumn('cardno')
dw_jogun.SetItem(1, 'cardno', sNull)

beep(1)

Return 1
end function

on w_van_00020_popup.create
int iCurrent
call super::create
this.st_msg=create st_msg
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_msg
this.Control[iCurrent+2]=this.rr_1
end on

on w_van_00020_popup.destroy
call super::destroy
destroy(this.st_msg)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.InsertRow(0)

dw_jogun.SetFocus()
dw_jogun.SetColumn('cardno')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_van_00020_popup
integer x = 123
integer y = 468
integer width = 2085
integer height = 100
string title = ""
string dataobject = "d_van_00020_popup_1"
end type

event dw_jogun::itemchanged;String sBaljpno, sSeq
Long   nCnt, nOkcnt

Choose Case GetColumnName()
	Case 'cardno'
		sBaljpno = Trim(GetText())
		If IsNull(sBaljpno) Or sBaljpno = '' Then
			st_msg.Text = ''
			Return
		End If
		
		Post wf_check()
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_van_00020_popup
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_van_00020_popup
boolean visible = false
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_van_00020_popup
boolean visible = false
boolean enabled = false
end type

type dw_1 from w_inherite_popup`dw_1 within w_van_00020_popup
boolean visible = false
end type

type sle_2 from w_inherite_popup`sle_2 within w_van_00020_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_van_00020_popup
end type

type cb_return from w_inherite_popup`cb_return within w_van_00020_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_van_00020_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_van_00020_popup
end type

type st_1 from w_inherite_popup`st_1 within w_van_00020_popup
end type

type st_msg from statictext within w_van_00020_popup
integer x = 96
integer y = 756
integer width = 2135
integer height = 144
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_van_00020_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 96
integer y = 424
integer width = 2135
integer height = 188
integer cornerheight = 40
integer cornerwidth = 46
end type

