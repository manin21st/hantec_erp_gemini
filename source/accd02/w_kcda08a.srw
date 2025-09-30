$PBExportHeader$w_kcda08a.srw
$PBExportComments$회계인명코드 인쇄
forward
global type w_kcda08a from w_standard_print
end type
type rb_1 from radiobutton within w_kcda08a
end type
type rb_2 from radiobutton within w_kcda08a
end type
type st_1 from statictext within w_kcda08a
end type
type rr_1 from roundrectangle within w_kcda08a
end type
type rr_2 from roundrectangle within w_kcda08a
end type
end forward

global type w_kcda08a from w_standard_print
string title = "회계인명코드 조회 출력"
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rr_1 rr_1
rr_2 rr_2
end type
global w_kcda08a w_kcda08a

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
String sgubunf,sgubunt,snamef,snamet,smin,smax,sPersonSts,sStsName

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sgubunf    = dw_ip.GetItemString(1,"sgubun")
sgubunt    = dw_ip.GetItemString(1,"egubun")

sPersonSts = dw_ip.GetItemString(1,"person_sts") 

SELECT MIN("REFFPF"."RFGUB"),MAX("REFFPF"."RFGUB") 
   INTO :smin,:smax  
   FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'CU' ) AND  
         ( "REFFPF"."RFGUB" <> '00' )   ;
IF sgubunf ="" OR IsNull(sgubunf) THEN
	sgubunf =smin
END IF

SELECT "REFFPF"."RFNA1"
   INTO :snamef
   FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'CU' ) AND  
         ( "REFFPF"."RFGUB" = :sgubunf )   ;
IF sgubunt ="" OR IsNull(sgubunt) THEN
	sgubunt =smax
END IF

SELECT "REFFPF"."RFNA1"
   INTO :snamet
   FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'CU' ) AND  
         ( "REFFPF"."RFGUB" = :sgubunt )   ;

IF sPersonSts = "" OR IsNull(sPersonSts) THEN 
	sPersonSts = '%'
ELSE
	SELECT "REFFPF"."RFNA1"
   INTO :sStsName
   FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'ST' ) AND  
         ( "REFFPF"."RFGUB" = :sPersonSts )   ;
END IF

IF dw_print.Retrieve(sgubunf,sgubunt,sPersonSts,snamef,snamet,sStsName) <=0 THEN
	f_messagechk(14,"")
	dw_ip.SetFocus()
	Return -1
END IF
dw_print.ShareData(dw_list)
Return 1

end function

on w_kcda08a.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_kcda08a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;  
String smax,smin

F_Window_Center_Response(This)

SELECT MIN("REFFPF"."RFGUB"),MAX("REFFPF"."RFGUB") 
   INTO :smin,:smax  
   FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU" = '1' ) AND  
         ( "REFFPF"."RFCOD" = 'CU' ) AND  
         ( "REFFPF"."RFGUB" <> '00' )   ;
			
dw_ip.SetItem(1,"sgubun",smin)
dw_ip.SetItem(1,"egubun",smax)

rb_1.Checked =True
dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kcda08a
integer x = 4064
integer y = 52
end type

type p_exit from w_standard_print`p_exit within w_kcda08a
integer x = 4411
integer y = 52
end type

type p_print from w_standard_print`p_print within w_kcda08a
integer x = 4238
integer y = 52
end type

type p_retrieve from w_standard_print`p_retrieve within w_kcda08a
integer x = 3890
integer y = 52
end type

type st_window from w_standard_print`st_window within w_kcda08a
boolean visible = false
integer y = 2108
end type

type sle_msg from w_standard_print`sle_msg within w_kcda08a
boolean visible = false
integer y = 2108
end type

type dw_datetime from w_standard_print`dw_datetime within w_kcda08a
boolean visible = false
integer y = 2108
end type

type st_10 from w_standard_print`st_10 within w_kcda08a
boolean visible = false
integer y = 2108
end type

type gb_10 from w_standard_print`gb_10 within w_kcda08a
boolean visible = false
integer y = 2072
end type

type dw_print from w_standard_print`dw_print within w_kcda08a
string dataobject = "dw_kcda08_3_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kcda08a
integer x = 46
integer y = 32
integer width = 2217
integer height = 268
string dataobject = "dw_kcda08_0"
end type

type dw_list from w_standard_print`dw_list within w_kcda08a
integer x = 59
integer y = 316
integer width = 4530
integer height = 2008
string dataobject = "dw_kcda08_3"
end type

type rb_1 from radiobutton within w_kcda08a
integer x = 2363
integer y = 164
integer width = 306
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "코드순"
boolean checked = true
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	dw_list.SetSort("person_gu A,person_cd A,person_nm A")
END IF
dw_list.Sort()
dw_list.SetRedraw(True)
end event

type rb_2 from radiobutton within w_kcda08a
integer x = 2688
integer y = 164
integer width = 306
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "명칭순"
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	dw_list.SetSort("person_gu A,person_nm A,person_cd A")
END IF
dw_list.Sort()
dw_list.SetRedraw(True)
end event

type st_1 from statictext within w_kcda08a
integer x = 2318
integer y = 80
integer width = 457
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "정렬 구분"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kcda08a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2263
integer y = 32
integer width = 805
integer height = 260
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kcda08a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 304
integer width = 4562
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

