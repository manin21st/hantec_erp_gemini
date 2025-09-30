$PBExportHeader$w_kfia34.srw
$PBExportComments$받을어음 명세서 조회 출력
forward
global type w_kfia34 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia34
end type
type rb_1 from radiobutton within w_kfia34
end type
type rb_2 from radiobutton within w_kfia34
end type
type rb_3 from radiobutton within w_kfia34
end type
type rb_4 from radiobutton within w_kfia34
end type
type rr_2 from roundrectangle within w_kfia34
end type
end forward

global type w_kfia34 from w_standard_print
integer x = 0
integer y = 0
integer height = 2444
string title = "받을어음 명세서 조회 출력"
rr_1 rr_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rr_2 rr_2
end type
global w_kfia34 w_kfia34

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_chk_cond ()
end prototypes

public function integer wf_retrieve ();string ls_stdate,sChuBnk,sChuFlag

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_stdate = dw_ip.getitemstring(dw_ip.getrow(),'stdate')

IF wf_chk_cond() = -1 THEN RETURN -1

IF rb_1.Checked = True THEN
	sChuFlag = dw_ip.GetItemString(1,"chuflag")
	IF sChuFlag = '1' THEN
		sChuFlag = '3'
	ELSE
		sChuFlag = '1'
	END IF
	if dw_print.Retrieve(sabu_f,sabu_t,ls_stdate,sChuFlag) < 1 then
	   f_messagechk(14,"") 
		
		Return -1
	END IF
ELSEIF rb_2.Checked = True THEN
	sChuBnk = dw_ip.getitemstring(dw_ip.getrow(),'chu_bnk')
	IF sChuBnk = '' OR IsNull(sChuBnk) THEN sChuBnk = '%'
	
	if dw_print.Retrieve(sabu_f,sabu_t,ls_stdate,sChuBnk) < 1 then
		f_messagechk(14,"")
		
		Return -1
	END IF
ELSEIF rb_3.Checked = True THEN
	sChuBnk = dw_ip.getitemstring(dw_ip.getrow(),'chu_bnk')
	IF sChuBnk = '' OR IsNull(sChuBnk) THEN sChuBnk = '%'
	
	if dw_print.Retrieve(sabu_f,sabu_t,ls_stdate,sChuBnk) < 1 then
		f_messagechk(14,"") 
		
		Return -1
	END IF
ELSEIF rb_4.Checked = True THEN
	if dw_print.Retrieve(sabu_f,sabu_t,ls_stdate) < 1 then
		f_messagechk(14,"")
		
		Return -1
	END IF
END IF
    dw_print.sharedata(dw_list)  
Return 1
end function

public function integer wf_chk_cond ();String sSaupj, ls_stdate

dw_ip.AcceptText()

sSaupj =Trim(dw_ip.GetItemString(1,"saupj"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

ls_stdate = dw_ip.GetItemString(dw_ip.GetRow(),"stdate")

IF f_datechk(ls_stdate) = -1 THEN
	f_messagechk(21,"") 
	Return -1
END IF

Return 1

end function

on w_kfia34.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rr_2
end on

on w_kfia34.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rr_2)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.GetRow(),"stdate", String(today(),"yyyymmdd"))
dw_ip.SetItem(dw_ip.GetRow(),"saupj", gs_saupj)
IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(255,255,255))+"'")  //MINT COLOR
End if

dw_ip.Setfocus()

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

end event

type p_preview from w_standard_print`p_preview within w_kfia34
integer y = 4
end type

type p_exit from w_standard_print`p_exit within w_kfia34
integer y = 4
end type

type p_print from w_standard_print`p_print within w_kfia34
integer y = 4
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia34
integer y = 4
end type

type st_window from w_standard_print`st_window within w_kfia34
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within w_kfia34
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfia34
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_kfia34
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within w_kfia34
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_kfia34
integer x = 3941
integer y = 116
string dataobject = "d_kfia34_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia34
integer x = 9
integer y = 24
integer width = 2286
integer height = 228
string dataobject = "d_kfia34_0"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::itemchanged;String snull, scustfnm, scusttnm

SetNull(snull)
sle_msg.text =""

IF dwo.name ="custf" THEN
	SELECT "KFZ04OM0"."PERSON_NM"
   	INTO :scustfnm
   	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
				( "KFZ04OM0"."PERSON_CD" = :data) ;

	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"거래처")
		dw_ip.SetItem(dw_ip.GetRow(),"custf",snull)
		Return 1
	END IF
END IF

IF dwo.name ="custt" THEN
	SELECT "KFZ04OM0"."PERSON_NM"
   	INTO :scusttnm
   	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
				( "KFZ04OM0"."PERSON_CD" = :data) ;

	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"거래처")
		dw_ip.SetItem(dw_ip.GetRow(),"custt",snull)
		Return 1
	END IF
END IF


end event

event dw_ip::rbuttondown;call super::rbuttondown;String snull

SetNull(snull)

IF dwo.name ="custf" THEN
	gs_code =dw_ip.GetItemString(1,"custf")

	IF IsNull(gs_code) then
   	gs_code = ""
	end if

	Open(W_VNDMST_POPUP)
	
	IF Not IsNull(gs_code) THEN
		dw_ip.SetItem(1,"custf",gs_code)
	END IF
END IF

IF dwo.name ="custt" THEN
	gs_code =dw_ip.GetItemString(1,"custt")

	IF IsNull(gs_code) then
   	gs_code = ""
	end if

	Open(W_VNDMST_POPUP)
	
	IF Not IsNull(gs_code) THEN
		dw_ip.SetItem(1,"custt",gs_code)
	END IF
END IF

end event

type dw_list from w_standard_print`dw_list within w_kfia34
integer x = 27
integer y = 272
integer height = 1960
string title = "받을어음 명세서 조회"
string dataobject = "d_kfia34_1"
boolean border = false
end type

event dw_list::clicked;call super::clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(Row,True)
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

end event

type rr_1 from roundrectangle within w_kfia34
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2688
integer y = 16
integer width = 1230
integer height = 224
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within w_kfia34
integer x = 2715
integer y = 52
integer width = 517
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "받을어음 명세서"
boolean checked = true
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	dw_list.dataObject='d_kfia34_1'
	dw_print.dataObject='d_kfia34_1_p'
	
	dw_ip.Modify("datef_t.text = '회계일자'")
	dw_ip.Modify("chu_bnk_t.visible = 0")
	dw_ip.Modify("chu_bnk.visible = 0")
	
	dw_ip.MOdify("chuflag.visible = 1")
//	dw_ip.MOdify("chuflag.visible = 0")
END IF

dw_print.title ="받을어음 명세서"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_2 from radiobutton within w_kfia34
integer x = 3246
integer y = 52
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "받을어음 추심명세서"
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	dw_list.dataObject='d_kfia34_2'
	dw_print.dataObject='d_kfia34_2_p'
	
	dw_ip.Modify("datef_t.text = '변동일자'")
	
	dw_ip.Modify("chu_bnk_t.text = '추심은행'")
	dw_ip.Modify("chu_bnk_t.visible = 1")
	dw_ip.Modify("chu_bnk.visible = 1")
	
	dw_ip.MOdify("chuflag.visible = 0")
END IF

dw_print.title ="받을어음 추심명세서"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_3 from radiobutton within w_kfia34
integer x = 2715
integer y = 128
integer width = 517
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "할인어음 명세서"
end type

event clicked;dw_list.SetRedraw(False)
IF rb_3.Checked =True THEN
	dw_list.dataObject='d_kfia34_3'
	dw_print.dataObject='d_kfia34_3_p'
	
	dw_ip.Modify("datef_t.text = '변동일자'")

	dw_ip.Modify("chu_bnk_t.text = '할인은행'")
	dw_ip.Modify("chu_bnk_t.visible = 1")
	dw_ip.Modify("chu_bnk.visible = 1")
	
	dw_ip.MOdify("chuflag.visible = 0")
END IF

dw_print.title ="할인어음 명세서"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_4 from radiobutton within w_kfia34
integer x = 3246
integer y = 128
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "배서어음 명세서"
end type

event clicked;dw_list.SetRedraw(False)
IF rb_4.Checked =True THEN
	dw_list.dataObject='d_kfia34_4'
	dw_print.dataObject='d_kfia34_4_p'
	dw_ip.Modify("datef_t.text = '회계일자'")
	dw_ip.Modify("chu_bnk_t.visible = 0")
	dw_ip.Modify("chu_bnk.visible = 0")
	
	dw_ip.MOdify("chuflag.visible = 0")
	
	dw_ip.Modify("chu_bnk_t.visible = 0")
	dw_ip.Modify("chu_bnk.visible = 0")
	
	dw_ip.MOdify("chuflag.visible = 0")
	
END IF

dw_print.title ="배서어음 명세서"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rr_2 from roundrectangle within w_kfia34
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 264
integer width = 4603
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

