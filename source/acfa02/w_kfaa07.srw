$PBExportHeader$w_kfaa07.srw
$PBExportComments$감가상각비 계산내역 초기화
forward
global type w_kfaa07 from w_inherite
end type
type em_year from editmask within w_kfaa07
end type
type st_2 from statictext within w_kfaa07
end type
type st_3 from statictext within w_kfaa07
end type
type rr_1 from roundrectangle within w_kfaa07
end type
type ln_1 from line within w_kfaa07
end type
end forward

global type w_kfaa07 from w_inherite
string title = "월별 상각비 초기화 처리"
em_year em_year
st_2 st_2
st_3 st_3
rr_1 rr_1
ln_1 ln_1
end type
global w_kfaa07 w_kfaa07

type variables
string dyear
end variables

event open;call super::open;SELECT "KFA07OM0"."KFYEAR"  
  INTO :DYEAR  
  FROM "KFA07OM0"  ;

if DYEAR  = '' then
   DYEAR  = left(f_today(), 4)
   INSERT INTO "KFA07OM0"  
   ( "KFYEAR" )  
   VALUES ( :DYEAR )  ;
end if

em_year.text = DYEAR 
end event

on w_kfaa07.create
int iCurrent
call super::create
this.em_year=create em_year
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_year
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.ln_1
end on

on w_kfaa07.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_year)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
destroy(this.ln_1)
end on

type dw_insert from w_inherite`dw_insert within w_kfaa07
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfaa07
boolean visible = false
integer x = 3753
integer y = 2752
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfaa07
boolean visible = false
integer x = 3579
integer y = 2752
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfaa07
integer x = 4265
integer taborder = 30
string picturename = "C:\Erpman\image\처리_up.gif"
end type

event p_search::clicked;call super::clicked;setpointer(hourglass!)
DYEAR = em_year.text
string syear
select kfyear into :syear
from kfa07om0;
if sqlca.sqlcode <> 0 then
	messagebox("확 인","고정자산 회기년도값을 확인하시오!")
   return
end if

if isnull(syear) or syear = '' then
    sle_msg.text = "회기는 보통 현재 년도입니다." 
    messagebox("확 인","고정자산 회기년도를 확인하시오. !")
    return
end if

//당기 월할상각액 초기화
UPDATE KFA04OM0
SET KFDE01=0, KFDE02=0,KFDE03=0,KFDE04=0,KFDE05=0,KFDE06=0,
    KFDE07=0, KFDE08=0,KFDE09=0,KFDE10=0,KFDE11=0,KFDE12=0, KFDEDT=NULL
WHERE KFYEAR = :syear;

//당기 월할상각자료 초기화
DELETE  FROM KFA03OT0
WHERE KFCHGB='C' and SUBSTR(KFACDAT,1,4) = :SYEAR;

//당기 월할상각이력 초기화
DELETE FROM KFA10OT0 
WHERE SUBSTR(KFYYMM,1,4) = :SYEAR;

if SQLCA.SQLCODE <> 0 then
   messagebox("확 인",sqlca.sqlerrtext)
	rollback;
   return
end if

COMMIT;

w_mdi_frame.sle_msg.text = "월할 상각계산자료의 초기화처리가 완료되었습니다.!"
end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\처리_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\처리_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kfaa07
boolean visible = false
integer x = 3406
integer y = 2752
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfaa07
integer taborder = 20
end type

type p_can from w_inherite`p_can within w_kfaa07
boolean visible = false
integer x = 4274
integer y = 2752
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kfaa07
boolean visible = false
integer x = 3058
integer y = 2752
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfaa07
boolean visible = false
integer x = 3232
integer y = 2752
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kfaa07
boolean visible = false
integer x = 4101
integer y = 2752
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfaa07
boolean visible = false
integer x = 3927
integer y = 2752
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kfaa07
boolean visible = false
integer x = 2574
integer y = 2812
end type

type cb_mod from w_inherite`cb_mod within w_kfaa07
boolean visible = false
integer x = 2181
integer y = 2812
integer width = 361
string text = "처리(&P)"
boolean default = true
end type

event cb_mod::clicked;call super::clicked;setpointer(hourglass!)
DYEAR = em_year.text
string syear
select kfyear into :syear
from kfa07om0;
if sqlca.sqlcode <> 0 then
	messagebox("확 인","고정자산 회기년도값을 확인하시오!")
   return
end if

if isnull(syear) or syear = '' then
    sle_msg.text = "회기는 보통 현재 년도입니다." 
    messagebox("확 인","고정자산 회기년도를 확인하시오. !")
    return
end if

//당기 월할상각액 초기화
UPDATE KFA04OM0
SET KFDE01=0, KFDE02=0,KFDE03=0,KFDE04=0,KFDE05=0,KFDE06=0,
    KFDE07=0, KFDE08=0,KFDE09=0,KFDE10=0,KFDE11=0,KFDE12=0, KFDEDT=NULL
WHERE KFYEAR = :syear;

//당기 월할상각자료 초기화
DELETE  FROM KFA03OT0
WHERE KFCHGB='C' and SUBSTR(KFACDAT,1,4) = :SYEAR;

//당기 월할상각이력 초기화
DELETE FROM KFA10OT0 
WHERE SUBSTR(KFYYMM,1,4) = :SYEAR;

if SQLCA.SQLCODE <> 0 then
   messagebox("확 인",sqlca.sqlerrtext)
	rollback;
   return
end if

COMMIT;

sle_msg.text = "월할 상각계산자료의 초기화처리가 완료되었습니다.!"
end event

type cb_ins from w_inherite`cb_ins within w_kfaa07
boolean visible = false
integer x = 1632
integer y = 3180
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kfaa07
boolean visible = false
integer x = 1984
integer y = 3184
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_kfaa07
boolean visible = false
integer x = 2336
integer y = 3188
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_kfaa07
integer x = 2683
integer y = 3196
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfaa07
end type

type cb_can from w_inherite`cb_can within w_kfaa07
boolean visible = false
integer x = 1787
integer y = 2940
boolean cancel = true
end type

type cb_search from w_inherite`cb_search within w_kfaa07
integer x = 1134
integer y = 3180
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_kfaa07
boolean visible = false
integer x = 974
integer y = 2884
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa07
boolean visible = false
integer x = 2135
integer y = 2760
integer width = 814
end type

type em_year from editmask within w_kfaa07
integer x = 2341
integer y = 848
integer width = 581
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type st_2 from statictext within w_kfaa07
integer x = 1710
integer y = 848
integer width = 581
integer height = 88
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "고정자산회기"
alignment alignment = center!
long bordercolor = 128
boolean focusrectangle = false
end type

type st_3 from statictext within w_kfaa07
integer x = 1339
integer y = 644
integer width = 2112
integer height = 72
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
boolean enabled = false
string text = "월별 상각계산내역(시뮬레이션)자료를 초기화 처리한다"
alignment alignment = center!
long bordercolor = 128
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfaa07
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 581
integer y = 284
integer width = 3671
integer height = 1512
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfaa07
long linecolor = 28144969
integer linethickness = 1
integer beginx = 1463
integer beginy = 720
integer endx = 3319
integer endy = 720
end type

