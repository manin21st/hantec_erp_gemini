$PBExportHeader$w_imt_05010.srw
$PBExportComments$���� ��ȹ�� ���� �Ѱ�ǥ
forward
global type w_imt_05010 from w_standard_print
end type
type shl_1 from statichyperlink within w_imt_05010
end type
type shl_2 from statichyperlink within w_imt_05010
end type
type st_1 from statictext within w_imt_05010
end type
type st_2 from statictext within w_imt_05010
end type
type rr_1 from roundrectangle within w_imt_05010
end type
end forward

global type w_imt_05010 from w_standard_print
string title = "���� ��ȹ�� ���� �Ѱ�ǥ"
string menuname = ""
shl_1 shl_1
shl_2 shl_2
st_1 st_1
st_2 st_2
rr_1 rr_1
end type
global w_imt_05010 w_imt_05010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_yymm, sThree, sThree1,ls_saupj, ls_gubun1, ls_gubun2, ls_gubun3, ls_gubun4, ls_gubun

ls_yymm = dw_ip.GetItemString(1, 'yymm')
ls_saupj = dw_ip.GetItemString(1, 'saupj')

IF ls_saupj = '' OR IsNull(ls_saupj) THEN
	ls_saupj ='%'
END IF

IF ls_yymm = '' OR IsNull(ls_yymm) THEN
	f_message_chk(30, '[���س��]')
	dw_ip.SetFocus()
	Return -1
END IF

ls_gubun = dw_ip.GetItemString(1,'iogbn')

IF ls_gubun = '' OR IsNull(ls_gubun) THEN
	ls_gubun ='%'
END IF

IF dw_list.Retrieve(ls_yymm, ls_saupj, ls_gubun) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

//3���� �Ⱓ setting
select To_char(add_months(to_date(:ls_yymm,'YYMM'), -3), 'YYYYMM'),
       To_char(add_months(to_date(:ls_yymm,'YYMM'), -1), 'YYYYMM')
into   :sThree, :sThree1 
From   dual;
dw_list.Object.t_three1.text = '['+ sThree + ' - ' + sThree1 + ']'
dw_list.Object.t_three2.text = '['+ sThree + ' - ' + sThree1 + ']'
dw_list.Object.t_three3.text = '['+ sThree + ' - ' + sThree1 + ']'

Return 1
end function

on w_imt_05010.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_imt_05010.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'yymm', left(f_today(),6))
f_mod_saupj(dw_ip, 'saupj')

SetNull(gs_gubun)
SetNull(gs_code)

//wf_retrieve()
end event

type p_preview from w_standard_print`p_preview within w_imt_05010
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_imt_05010
end type

type p_print from w_standard_print`p_print within w_imt_05010
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_05010
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_imt_05010
end type



type dw_print from w_standard_print`dw_print within w_imt_05010
integer x = 3255
string dataobject = "d_imt_05010_1"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_05010
integer x = 32
integer y = 96
integer width = 2752
integer height = 136
string dataobject = "d_imt_05010"
end type

type dw_list from w_standard_print`dw_list within w_imt_05010
event ue_mousemove pbm_mousemove
integer x = 55
integer y = 268
integer width = 4549
integer height = 2016
boolean bringtotop = true
string dataobject = "d_imt_05010_1"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object, ls_Sort
Long	 ll_Row

IF this.Rowcount() < 1 then return 1

ls_Object = Lower(This.GetObjectAtPointer())

ll_Row = long(mid(ls_Object, 7, 5))

IF mid(ls_Object, 1, 6)  = 'cvnas2' THEN 

	this.setrow(ll_row)

	ls_Sort = Trim(this.Object.ssort[ll_row]) //�ŷ�ó Ȥ�� ��з����� ���а�
	IF ls_Sort = '1' Then
   	this.setitem(ll_row, 'opt', '1')
	ELSE
		this.setitem(ll_row, 'opt', '2')
	END IF
ELSE
	this.setitem(ll_Row, 'opt', '0')
END IF


end event

event dw_list::clicked;call super::clicked;String  ls_Object, ls_Sort, ls_iogbn
Long	  ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 6)  = 'cvnas2' THEN 
   ll_Row = long(mid(ls_Object, 7, 3))
	if row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'yymm')
  	gs_code = This.GetItemString(row, 'cvcod')
  	gs_codename2 = This.GetItemString(row, 'cvnas2')	  
   gs_codename = This.GetItemString(row, 'ittyp')
	ls_iogbn = dw_ip.GetItemString(1, 'iogbn')
	
	If ls_iogbn = '' or Isnull(ls_iogbn) Then ls_iogbn ='%'
	
	ls_Sort = Trim(this.Object.ssort[row]) //�ŷ�ó ���� ��з����� ���а�
	
	IF ls_Sort = '1' Then
		OpenSheetWithParm(w_imt_05040,ls_iogbn , w_mdi_frame, 0, Layered!)
   ELSE
		OpenSheetWithParm(w_imt_05020,ls_iogbn ,w_mdi_frame, 0, Layered!)
   END IF 
END IF

end event

type shl_1 from statichyperlink within w_imt_05010
integer x = 69
integer y = 36
integer width = 192
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "�����"
alignment alignment = center!
end type

event clicked;//Boolean				lb_isopen
//Window				lw_window
//
//lb_isopen = FALSE
//lw_window = parent.GetFirstSheet()
//DO WHILE IsValid(lw_window)
//	if ClassName(lw_window) = 'w_pdt_09010' then
//		lb_isopen = TRUE
//		Exit
//	else		
//		lw_window = parent.GetNextSheet(lw_window)
//	end if
//LOOP
//if lb_isopen then
//	lw_window.windowstate = Normal!
//	lw_window.SetFocus()
//else	
//	OpenSheet(w_pdt_09010, w_mdi_frame, 0, Layered!)	
//end if
end event

type shl_2 from statichyperlink within w_imt_05010
boolean visible = false
integer x = 421
integer y = 36
integer width = 151
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "����"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_imt_05010
boolean visible = false
integer x = 283
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_imt_05010
integer x = 4251
integer y = 200
integer width = 334
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 31778020
string text = "(����:õ��)"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_imt_05010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

