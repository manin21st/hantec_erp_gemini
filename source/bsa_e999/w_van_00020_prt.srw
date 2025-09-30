$PBExportHeader$w_van_00020_prt.srw
$PBExportComments$검수자료 등록- VAN
forward
global type w_van_00020_prt from w_standard_print
end type
type pb_1 from u_pb_cal within w_van_00020_prt
end type
type pb_2 from u_pb_cal within w_van_00020_prt
end type
type rr_1 from roundrectangle within w_van_00020_prt
end type
end forward

global type w_van_00020_prt from w_standard_print
string title = "납품 검수 조서"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_van_00020_prt w_van_00020_prt

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sPlnt, sStrdate, sEndDate, sCvcod, sItnbr
		
IF dw_ip.AcceptText() = -1 THEN RETURN -1

sPlnt    = Trim(dw_ip.GetItemString(1,"vndgu"))
sStrdate = Trim(dw_ip.GetItemString(1,"order_date"))
sEndDate = Trim(dw_ip.GetItemString(1,"end_date"))
sCvcod   = Trim(dw_ip.GetItemString(1,"cvcod"))
sItnbr   = Trim(dw_ip.GetItemString(1,"itnbr"))

If IsNull(sPlnt) Then sPlnt = ''
If IsNull(sCvcod) Then sCvcod = ''
If IsNull(sItnbr) or sItnbr = '' Then sItnbr = '%'

If f_datechk(sStrdate) <> 1 Or f_datechk(sEndDate) <> 1  Then
	f_message_chk(1400,'[검수일자]')
	Return -1
End If

IF dw_print.Retrieve(sPlnt+'%', sStrdate, sEndDate, sCvcod+'%', sItnbr) <=0 THEN
	IF f_message_chk(50,'') = -1 THEN RETURN -1
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1

end function

on w_van_00020_prt.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_van_00020_prt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_van_00020_prt
end type

type p_exit from w_standard_print`p_exit within w_van_00020_prt
end type

type p_print from w_standard_print`p_print within w_van_00020_prt
end type

type p_retrieve from w_standard_print`p_retrieve within w_van_00020_prt
end type







type st_10 from w_standard_print`st_10 within w_van_00020_prt
end type



type dw_print from w_standard_print`dw_print within w_van_00020_prt
string dataobject = "d_van_00020_prt_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_van_00020_prt
integer x = 50
integer y = 112
integer width = 2729
integer height = 172
string dataobject = "d_van_00020_prt_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sOrderDate,snull, scvcod, scvnas, sarea, steam, sSaupj, sname1, sItnbr, sdesc

SetNull(snull)

Choose Case GetColumnName()
	Case 'gbn'
			If GetText() = '1' Then
				dw_list.DataObject = 'd_van_00020_prt_2'
				dw_print.DataObject = 'd_van_00020_prt_2_p'
			Else
				dw_list.DataObject = 'd_van_00020_prt_3'
				dw_print.DataObject = 'd_van_00020_prt_3_p'
			End If
			dw_list.SetTransObject(sqlca)
			dw_print.SetTransObject(sqlca)
	Case "order_date", "end_date"
		sOrderDate = Trim(this.GetText())
		IF sOrderDate ="" OR IsNull(sOrderDate) THEN 
			f_message_chk(35,'[검수일자]')
			SetItem(1,GetColumnName() ,snull)
			Return 1
		END IF
		
		IF f_datechk(sOrderDate) = -1 THEN
			f_message_chk(35,'[검수일자]')
			SetItem(1,GetColumnName() ,snull)
			Return 1
		END IF
	Case "itnbr"
		sitnbr = Trim(GetText())
		IF sitnbr ="" OR IsNull(sitnbr) THEN
			SetItem(1,"itnbr",snull)
			SetItem(1,"itdsc" ,snull)
			Return
		END IF
		
		select Nvl(itdsc, null)
		  into :sdesc
		 From itemas
		 Where itnbr = :sitnbr; 
		 if sqlca.sqlcode = 0 then
			 SetItem(1, "itdsc" , sdesc)
		else
			 SetItem(1, "itnbr", snull)
			 SetItem(1, "itdsc" , snull)
		end if

END Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "itnbr"
		gs_gubun = '1'
		If GetColumnName() = "itdsc" then
			gs_codename = Trim(GetText())
		End If
		Open(w_itemas_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"itnbr", gs_code)
		SetItem(1,"itdsc" , gs_codename)
		SetColumn("itnbr")
		
END Choose

end event

type dw_list from w_standard_print`dw_list within w_van_00020_prt
string dataobject = "d_van_00020_prt_2"
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type pb_1 from u_pb_cal within w_van_00020_prt
integer x = 658
integer y = 200
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('order_date')
IF IsNull(gs_code) THEN Return 
dw_ip.SetItem(1, 'order_date', gs_code)

end event

type pb_2 from u_pb_cal within w_van_00020_prt
integer x = 1157
integer y = 200
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('end_date')
IF IsNull(gs_code) THEN Return 
dw_ip.SetItem(1, 'end_date', gs_code)

end event

type rr_1 from roundrectangle within w_van_00020_prt
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 104
integer width = 2775
integer height = 188
integer cornerheight = 40
integer cornerwidth = 46
end type

