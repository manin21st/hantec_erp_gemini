$PBExportHeader$w_kfia20a.srw
$PBExportComments$자금수지코드 출력
forward
global type w_kfia20a from w_standard_print
end type
type rb_1 from radiobutton within w_kfia20a
end type
type rb_2 from radiobutton within w_kfia20a
end type
type rr_1 from roundrectangle within w_kfia20a
end type
type st_1 from statictext within w_kfia20a
end type
type rr_2 from roundrectangle within w_kfia20a
end type
end forward

global type w_kfia20a from w_standard_print
integer x = 0
integer y = 0
string title = "자금수지코드 조회 출력"
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
st_1 st_1
rr_2 rr_2
end type
global w_kfia20a w_kfia20a

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
String scdf,scdt, smin, smax

IF dw_ip.AcceptText() = -1 THEN RETURN -1

scdf =dw_ip.GetItemString(1,"finance_cd")
scdt =dw_ip.GetItemString(1,"to_cd")

SELECT MIN("KFM10OM0"."FINANCE_CD"),MAX("KFM10OM0"."FINANCE_CD") 
   INTO :smin,:smax  
   FROM "KFM10OM0"  ;
	
IF scdf ="" OR IsNull(scdf) THEN
	scdf =smin
END IF

IF scdt ="" OR IsNull(scdt) THEN
	scdt =smax
END IF
	
IF dw_print.Retrieve(scdf,scdt) <=0 THEN
	f_messagechk(14,"")
	dw_list.insertrow(0)
	dw_ip.SetFocus()
	//Return -1
END IF
  dw_print.sharedata(dw_list)
Return 1

end function

on w_kfia20a.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
this.st_1=create st_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_kfia20a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
destroy(this.st_1)
destroy(this.rr_2)
end on

event open;call super::open;
rb_1.Checked =True
dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kfia20a
integer x = 4101
integer y = 4
end type

type p_exit from w_standard_print`p_exit within w_kfia20a
integer x = 4462
integer y = 4
end type

type p_print from w_standard_print`p_print within w_kfia20a
integer x = 4279
integer y = 4
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia20a
integer y = 4
end type

type st_window from w_standard_print`st_window within w_kfia20a
integer y = 2580
integer height = 88
end type

type sle_msg from w_standard_print`sle_msg within w_kfia20a
integer y = 2584
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfia20a
integer y = 2584
end type

type st_10 from w_standard_print`st_10 within w_kfia20a
integer y = 2584
end type

type gb_10 from w_standard_print`gb_10 within w_kfia20a
integer y = 2548
end type

type dw_print from w_standard_print`dw_print within w_kfia20a
string dataobject = "dw_kfia20a_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia20a
integer x = 27
integer y = 20
integer width = 1824
integer height = 188
string dataobject = "dw_kfia20a_1"
end type

event dw_ip::rbuttondown;String ls_cd

SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

IF this.GetColumnName() ="finance_cd" THEN
	ls_cd =dw_ip.GetItemString(this.getrow(),"finance_cd")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
   dw_ip.SetItem(this.getrow(),"finance_cd",gs_code)
   dw_ip.SetItem(this.getrow(),"fr_nm",gs_codename)
ELSEIF this.GetColumnName() ="to_cd" THEN
	ls_cd =dw_ip.GetItemString(this.getrow(),"to_cd")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_ip.SetItem(this.getrow(),"to_cd",gs_code)
   dw_ip.SetItem(this.getrow(),"to_nm",gs_codename)
END IF

	
end event

event dw_ip::itemchanged;call super::itemchanged;string   scode, sname, snull

setnull(snull)

IF dwo.name = "finance_cd"  THEN
	scode = this.gettext()
   
   IF IsNull(scode) or scode = "" then
      dw_ip.setitem(dw_ip.getrow(), "fr_nm", snull)
   end if
   scode = Trim(scode)
  
  SELECT "KFM10OM0"."FINANCE_NAME"  
    INTO :SNAME  
    FROM "KFM10OM0"  
   WHERE "KFM10OM0"."FINANCE_CD" = :scode ;
   
	dw_ip.setitem(dw_ip.getrow(), "fr_nm", SNAME) 
   
ELSEIF dwo.name = "to_cd" THEN 
	scode = this.gettext()
 
   IF IsNull(scode) or scode = "" then
      dw_ip.setitem(dw_ip.getrow(), "to_nm", snull)
   end if
   scode = Trim(scode)
	
  SELECT "KFM10OM0"."FINANCE_NAME"  
    INTO :SNAME  
    FROM "KFM10OM0"  
   WHERE "KFM10OM0"."FINANCE_CD" = :scode ;
  
	 dw_ip.SetItem(dw_ip.Getrow(), "to_nm", sname)
   
END IF

dw_ip.SetFocus()
end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia20a
integer x = 59
integer y = 244
integer width = 4539
integer height = 2092
string dataobject = "dw_kfia20a_2"
boolean border = false
end type

type rb_1 from radiobutton within w_kfia20a
integer x = 1915
integer y = 56
integer width = 393
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자금코드순"
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	dw_list.SetSort("finance_cd A,finance_name A")
END IF
dw_list.Sort()
dw_list.SetRedraw(True)
end event

type rb_2 from radiobutton within w_kfia20a
integer x = 1915
integer y = 124
integer width = 393
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자금명칭순"
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	dw_list.SetSort("finance_name A,finance_cd A")
END IF
dw_list.Sort()
dw_list.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_kfia20a
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1879
integer y = 24
integer width = 462
integer height = 168
integer cornerheight = 40
integer cornerwidth = 41
end type

type st_1 from statictext within w_kfia20a
integer x = 1915
integer width = 238
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "정렬구분"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_kfia20a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 224
integer width = 4581
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 41
end type

