$PBExportHeader$w_pik1006.srw
$PBExportComments$** 근무일별 스케쥴 생성 및 수정
forward
global type w_pik1006 from w_inherite_standard
end type
type dw_ip from datawindow within w_pik1006
end type
type rr_1 from roundrectangle within w_pik1006
end type
end forward

global type w_pik1006 from w_inherite_standard
string title = "근무일별 스케쥴 생성 및 수정"
dw_ip dw_ip
rr_1 rr_1
end type
global w_pik1006 w_pik1006

type variables
//Multi Select 사용 변수
long il_lastclickedrow
boolean ib_action_on_buttonup

string sGetName
end variables

forward prototypes
public function integer ufi_shift_highlight (long al_aclickedrow)
end prototypes

public function integer ufi_shift_highlight (long al_aclickedrow);int li_idx

SetRedraw(FALSE)
dw_insert.SelectRow(0, FALSE)            

IF il_lastclickedrow = 0 THEN
	SetRedraw(TRUE)
	RETURN 1
END IF

IF il_lastclickedrow > al_aclickedrow THEN
	FOR li_idx = il_lastclickedrow TO al_aclickedrow STEP -1       

//dw_insert.Modify("yjtime.Color='553648127~tIf(getrow() ='"+string(li_idx) +"' ,255,rgb(255,255,255))'")
// dw_insert.Modify("yjtime.Background.Color='553648127~tIf(getrow() =  " + string(li_idx) + ",255,rgb(255,255,255))'")
 dw_insert.Modify(sGetName +".Background.Color='553648127~tIf(getrow() between  " + string(al_aclickedrow) + " and " + string(il_lastclickedrow) + ",12639424,rgb(255,255,255))'")
 dw_insert.Setitem(li_idx,'flag','Y')

//		 dw_insert.SelectRow(li_idx, TRUE)
     
	END FOR
ELSE
	FOR li_idx = il_lastclickedrow TO al_aclickedrow
		 dw_insert.Modify(sGetName +".Background.Color='553648127~tIf(getrow() between  " + string(il_lastclickedrow) + " and " + string(al_aclickedrow) + ",12639424,rgb(255,255,255))'")
		  dw_insert.Setitem(li_idx,'flag','Y')
//		 dw_insert.SelectRow(li_idx, TRUE)
	NEXT
END IF
SetRedraw(TRUE)
RETURN 1

end function

on w_pik1006.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rr_1
end on

on w_pik1006.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.rr_1)
end on

event open;call super::open;w_mdi_frame.sle_msg.text = ''

dw_ip.SettransObject(sqlca)
dw_insert.SettransObject(sqlca)
dw_ip.insertrow(0)

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd
end event

type p_mod from w_inherite_standard`p_mod within w_pik1006
integer x = 4210
integer taborder = 100
end type

event p_mod::clicked;call super::clicked;if messagebox("확인","저장하시겠습니까?", Question!, YesNo!) = 2 then return


IF dw_insert.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
	ib_any_typing = True
	w_mdi_frame.sle_msg.text ="저장 실패!!"
	Return
END IF
end event

type p_del from w_inherite_standard`p_del within w_pik1006
boolean visible = false
integer x = 4841
integer y = 380
integer taborder = 120
end type

type p_inq from w_inherite_standard`p_inq within w_pik1006
integer x = 4037
end type

event p_inq::clicked;call super::clicked;string ls_saup, ls_kunmu


if dw_ip.Accepttext() = -1 then return 

ls_saup = dw_ip.GetitemString(1,'saup')
ls_kunmu = dw_ip.GetitemString(1,'kunmu')


if IsNull(ls_saup) or ls_saup = '' then
	f_messagechk(1,'사업장을 입력하세요!')
	return
end if
if IsNull(ls_kunmu) or ls_kunmu = '' then
	f_messagechk(1,'근무일구분을 입력하세요!')
	return
end if

if dw_insert.retrieve(ls_saup, ls_kunmu) < 1 then
	w_mdi_frame.sle_msg.text = "조회할 자료가 없습니다"
	dw_ip.SetColumn('kunmu')
	dw_ip.Setfocus()
	return
end if


end event

type p_print from w_inherite_standard`p_print within w_pik1006
boolean visible = false
integer x = 5198
integer y = 380
integer taborder = 190
end type

type p_can from w_inherite_standard`p_can within w_pik1006
boolean visible = false
integer x = 5015
integer y = 380
integer taborder = 150
end type

type p_exit from w_inherite_standard`p_exit within w_pik1006
integer taborder = 170
end type

type p_ins from w_inherite_standard`p_ins within w_pik1006
boolean visible = false
integer x = 4672
integer y = 532
integer taborder = 40
end type

type p_search from w_inherite_standard`p_search within w_pik1006
integer x = 3858
integer taborder = 180
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::clicked;string ls_saup, ls_kunmu
int li_cktime, li_tktime, li_ktime

if dw_ip.Accepttext() = -1 then return 

ls_saup = dw_ip.GetitemString(1,'saup')
ls_kunmu = dw_ip.GetitemString(1,'kunmu')
li_cktime = dw_ip.GetitemNumber(1,'cktime')
li_tktime = dw_ip.GetitemNumber(1,'tktime')
li_ktime = dw_ip.GetitemNumber(1,'ktime')


if IsNull(ls_saup) or ls_saup = '' then
	f_messagechk(1,'사업장을 입력하세요!')
	return
end if
if IsNull(ls_kunmu) or ls_kunmu = '' then
	f_messagechk(1,'근무일구분을 입력하세요!')
	return
end if
if IsNull(li_cktime) or li_cktime = 0 then
	f_messagechk(1,'출근시각을 입력하세요!')
	return
end if
if IsNull(li_tktime) or li_tktime = 0 then
	f_messagechk(1,'퇴근시각을 입력하세요!')
	return
end if
if IsNull(li_ktime) or li_ktime = 0 then
	f_messagechk(1,'관리기본시각을 입력하세요!')
	return
end if

if messagebox("확인","근무일에 해당하는 시간표를 생성하시겠습니까?", Question!,YesNo! ) = 2 then return


DECLARE start_sp_create_kunmusch procedure for sp_create_kunmusch(:ls_saup,:ls_kunmu,&
					:li_cktime,:li_tktime,:li_ktime) ;


SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '생성 중.........!!'
execute start_sp_create_kunmusch ;
SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = '생성 완료!!'

p_inq.Triggerevent(Clicked!)




end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_addrow from w_inherite_standard`p_addrow within w_pik1006
boolean visible = false
integer x = 4846
integer y = 532
integer taborder = 60
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1006
boolean visible = false
integer x = 5019
integer y = 532
integer taborder = 80
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1006
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_dwnmousemove
event ue_msmove pbm_mousemove
event ue_ldw pbm_lbuttondown
integer x = 846
integer y = 344
integer width = 2551
integer height = 1864
integer taborder = 20
string dragicon = "Asterisk!"
string title = "TITLE"
string dataobject = "d_pik1006_2"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_lbuttonup;
SetPointer(HourGlass!)

IF ib_action_on_buttonup THEN
	ib_action_on_buttonup = FALSE
	IF Keydown(KeyControl!) THEN
		this.selectrow(il_lastclickedrow, FALSE)
	ELSE
		this.SelectRow(0, FALSE)
		this.SelectRow(il_lastclickedrow, TRUE)
	END IF
	il_lastclickedrow = 0

END IF

end event

event dw_insert::ue_mousemove;////if row > 0 then
////   this.setrow( row )
////end if
////
//if il_lastclickedrow > 0 then
//
//IF il_lastclickedrow > row THEN
//   dw_insert.ScrollToRow(row - 1)
//ELSE
//	dw_insert.ScrollToRow(row + 1)
//END IF
//
//end if
//
//
end event

event dw_insert::ue_msmove;//long ll_pos
//String dwobject
//string ls_row
//
//dwobject = dw_insert.GetObjectAtPointer()
//ll_pos = Pos(dwobject, "~t")
//IF ll_pos > 0 THEN
//ls_row = Mid(dwobject, ll_pos + 1)
//END IF
//
//IF Long(ls_row) = 0 THEN RETURN
//
////dw_insert.Modify("DataWindow.Detail.Color=~"553648127~tif ( getrow() = " + ls_row + ", rgb(104,146,255), rgb(255,255,255) )~"")
////dw_insert.Selectedrow()
//
//if	mousecheck = 'Y' then
//	il_lastclickedrow = long(ls_row)
//	this.SelectRow(0, FALSE)
//	this.SelectRow(long(ls_row), TRUE)
//end if
//
//
//
end event

event dw_insert::clicked;call super::clicked;   IF Keydown(KeyShift!) THEN
		ufi_shift_highlight(ROW)
	
	ELSEIF this.IsSelected(ROW) THEN
		il_lastclickedrow = ROW
		ib_action_on_buttonup = TRUE
	ELSEIF Keydown(KeyControl!) THEN
		il_lastclickedrow = ROW
		this.SelectRow(ROW, TRUE)
	ELSE
		il_lastclickedrow = ROW
		this.SelectRow(0, FALSE)
		this.SelectRow(ROW, TRUE)
	END IF 
	
	int i
	i = this.GetClickedColumn()
	
	sGetName = this.Describe("#" + String(i) + ".Name")

	

end event

type st_window from w_inherite_standard`st_window within w_pik1006
integer taborder = 160
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1006
integer taborder = 130
end type

type cb_update from w_inherite_standard`cb_update within w_pik1006
integer taborder = 50
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1006
integer taborder = 30
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1006
integer taborder = 70
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1006
integer taborder = 110
end type

type st_1 from w_inherite_standard`st_1 within w_pik1006
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1006
integer taborder = 90
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1006
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1006
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1006
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1006
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1006
end type

type dw_ip from datawindow within w_pik1006
integer x = 841
integer y = 8
integer width = 2450
integer height = 308
integer taborder = 140
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik1006_1"
boolean border = false
boolean livescroll = true
end type

event buttonclicking;int ktype, i
string l_color

this.Accepttext()

//dw_insert.Modify("yjtime.Color=~"553648127~tif ( getrow() = " + string(2) + ", rgb(0,0,0), rgb(255,255,255) )~"")

if IsNull(sGetName) or sGetName = '' then
	return
end if

ktype = this.GetitemNumber(1,'ktime')

if IsNull(ktype) then ktype = 0
//	messagebox("확인","관리기본시간을 선택입력하세요!")
//	this.SetColumn('ktime')
//	this.Setfocus()
//	return
//end if
//	l_color = dw_insert.Describe("evaluate('yjtime.background.color',1)")	
For  i = 1 to dw_insert.rowcount()

//	IF dw_insert.IsSelected(i) THEN
   IF dw_insert.GetitemString(i,'flag') = 'Y' then
		dw_insert.Setitem(i, sGetName, ktype)
	END IF
	   dw_insert.Setitem(i,'flag','N')
Next

dw_insert.Modify(sGetName +".Background.Color='16777215'")






end event

event itemchanged;String ls_saupcd, ls_kunmu
int li_cktime, li_tktime, li_gitime

this.Accepttext()

if this.GetColumnName() = 'saup' then
	is_saupcd = this.GetText()
	ls_saupcd = this.Gettext()
	ls_kunmu = this.GetitemString(1,'kunmu')
	
	if IsNull(ls_saupcd) or ls_saupcd = '' then
	else
		if IsNull(ls_kunmu) or ls_kunmu = '' then
		else
         select max(decode(ctgbn,'1',jtime)),
					 max(decode(ctgbn,'2',jtime)),
					 max(gitime)
		   into :li_cktime, :li_tktime, :li_gitime			 
			from p4_kunmu_sch 
			where saupcd = :ls_saupcd and kunmuil = :ls_kunmu and ctgbn in ('1','2'); 
			
			if sqlca.sqlcode = 0 then
				this.Setitem(1,'cktime', li_cktime)
				this.Setitem(1,'tktime', li_tktime)
				this.Setitem(1,'ktime', li_gitime)
		   end if		
			p_inq.Triggerevent(Clicked!)
		end if
	end if
end if

if this.GetColumnName() = 'kunmu' then
	ls_kunmu = this.Gettext()
	ls_saupcd = this.GetitemString(1,'saup')
	
	if IsNull(ls_kunmu) or ls_kunmu = '' then
   else		
		if IsNull(ls_saupcd) or ls_saupcd = '' then
		else
			select max(decode(ctgbn,'1',jtime)),
					 max(decode(ctgbn,'2',jtime)),
					 max(gitime)
		   into :li_cktime, :li_tktime, :li_gitime			 
			from p4_kunmu_sch 
			where saupcd = :ls_saupcd and kunmuil = :ls_kunmu and ctgbn in ('1','2'); 
			
			if sqlca.sqlcode = 0 then
				this.Setitem(1,'cktime', li_cktime)
				this.Setitem(1,'tktime', li_tktime)
				this.Setitem(1,'ktime', li_gitime)
		   end if		
			p_inq.Triggerevent(Clicked!)
		end if
	end if
end if
end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_pik1006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 837
integer y = 340
integer width = 2574
integer height = 1876
integer cornerheight = 40
integer cornerwidth = 55
end type

