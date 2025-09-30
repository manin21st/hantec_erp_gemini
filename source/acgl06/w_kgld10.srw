$PBExportHeader$w_kgld10.srw
$PBExportComments$년비목별명세서 조회 출력
forward
global type w_kgld10 from w_standard_print
end type
type rb_1 from radiobutton within w_kgld10
end type
type rb_2 from radiobutton within w_kgld10
end type
type rr_1 from roundrectangle within w_kgld10
end type
type rr_2 from roundrectangle within w_kgld10
end type
end forward

global type w_kgld10 from w_standard_print
integer x = 0
integer y = 0
string title = "년비목별명세서 조회 출력"
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_kgld10 w_kgld10

forward prototypes
public function integer wf_print ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_print ();
//IF saup_text ="" OR IsNull(saup_text)  THEN	//사업장이 전사이거나 없으면 모든 사업장//
//	saup_text ="9"
//END IF
//
//  SELECT "REFFPF"."RFNA1"  
//    INTO :sref_saup  
//    FROM "REFFPF"  
//	WHERE "REFFPF"."RFCOD" = 'AD'   AND
//			"REFFPF"."RFGUB" = :saup_text ;
//dw_list.modify("saup.text ='"+sref_saup+"'") // 사업명 move
//
//dw_list.modify("bimok.text = '"+ref_nm+"'") //비목명 move
//
//dw_list.SetRedraw(false)
//IF dw_list.retrieve(sabu_f,syy, smm, fr_bimok, to_bimok) <= 0 then
//	messagebox("확인","조회한 자료가 없습니다.!!") 
//   dw_list.SetRedraw(true)	
//	return -1
//END IF
//
//dw_list.SetRedraw(true)	
//
//dw_list.object.datawindow.print.preview="yes"
//	
//gi_page = dw_list.GetItemNumber(1,"last_page")
//
//dw_ip.SetFocus()	
//
Return 1
end function

public function integer wf_retrieve ();String  sSaupj,sYearMonth,sBiMokGbn,sBiMokAccF,sBiMokAccT,sSaupjName

dw_ip.AcceptText()
sSaupj = dw_ip.GetItemString(1,"saupj")
sYearMonth = dw_ip.GetItemString(1,"acc_ym")
sBiMokGbn  = dw_ip.getitemstring(1,"bimok")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	f_messagechk(1, "[사업장]") 
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
ELSE
	SELECT "REFFPF"."RFNA1"     INTO :sSaupjName
		FROM "REFFPF"  
		WHERE "REFFPF"."RFCOD" = 'AD' AND "REFFPF"."RFGUB" = :sSaupj ;
END IF

IF sYearMonth = "" OR IsNull(sYearMonth) THEN
	f_messagechk(22, "")
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	Return -1
END IF
IF sBiMokGbn = "" OR IsNull(sBiMokGbn) THEN
	f_messagechk(1, "[비목구분]") 
	dw_ip.SetColumn("bimok")
	dw_ip.SetFocus()
	Return -1
END IF

SELECT SUBSTR("REFFPF"."RFNA2",1,5),	  SUBSTR("REFFPF"."RFNA2",6,5)
	INTO :sBiMokAccF,							  :sBiMokAccT	  
   FROM "REFFPF"  
	WHERE ( "REFFPF"."RFCOD" = 'BM' ) AND ( "REFFPF"."RFGUB" = :sBiMokGbn )   ;
	
dw_print.modify("saup.text ='"+sSaupjName+"'")
dw_print.modify("bimok.text = '"+F_Get_Refferance('BM',sBimokGbn)+"'") 

if dw_print.retrieve(sSaupj, Left(sYearMonth,4), Mid(sYearMonth,5,2), sBiMokAccF, sBiMokAccT) <= 0 then
	//F_MessageChk(14,'')
	//return -1
	dw_list.insertrow(0)
end if
 dw_print.sharedata(dw_list)
Return 1
end function

on w_kgld10.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kgld10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_ip.SetItem(1,"acc_ym", left(f_today(), 6))
dw_ip.SetItem(1,"saupj", gs_saupj)

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)


end event

type p_preview from w_standard_print`p_preview within w_kgld10
end type

type p_exit from w_standard_print`p_exit within w_kgld10
end type

type p_print from w_standard_print`p_print within w_kgld10
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld10
end type







type st_10 from w_standard_print`st_10 within w_kgld10
end type



type dw_print from w_standard_print`dw_print within w_kgld10
integer x = 3808
integer y = 60
string dataobject = "dw_kgld102_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld10
integer x = 46
integer y = 28
integer width = 2784
integer height = 148
string dataobject = "dw_kgld101"
end type

event dw_ip::getfocus;this.AcceptText()

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String sSaupj,sYearMonth,sBiMokGbn,snull

SetNull(snull)

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(this.GetRow(),"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "acc_ym" THEN
	sYearMonth = Trim(this.GetText())
	IF sYearMonth = "" OR IsNull(sYearMonth) THEN Return
	
	IF F_DateChk(sYearMonth + '01') = -1 THEN
		F_MessageChk(21,'[회계년월]')
		this.SetItem(this.GetRow(),"acc_ym",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "bimok" THEN
	sBiMokGbn = this.GetText()
	IF sBiMokGbn = "" OR IsNull(sBiMokGbn) THEN Return
	
	IF IsNull(F_Get_Refferance('BM',sBiMokGbn)) THEN
		F_MessageChk(20,'[비목구분]')
		this.SetItem(this.GetRow(),"bimok",sNull)
		Return 1
	END IF
END IF

end event

type dw_list from w_standard_print`dw_list within w_kgld10
integer x = 55
integer y = 196
integer width = 4553
integer height = 2008
string dataobject = "dw_kgld102"
boolean border = false
end type

type rb_1 from radiobutton within w_kgld10
integer x = 2935
integer y = 64
integer width = 384
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "계정과목별"
boolean checked = true
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN	
	dw_list.dataObject='dw_kgld102'
	dw_print.dataObject='dw_kgld102_p'
END IF
dw_list.title ="년비목별 명세서(계정과목별)"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_kgld10
integer x = 3397
integer y = 64
integer width = 384
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "계정세목별"
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	dw_list.dataObject='dw_kgld103'
	dw_print.dataObject='dw_kgld103_p'
END IF
dw_list.title ="년비목별 명세서(세목별)"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

type rr_1 from roundrectangle within w_kgld10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2843
integer y = 28
integer width = 1061
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kgld10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 188
integer width = 4571
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

