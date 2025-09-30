$PBExportHeader$w_kfab20.srw
$PBExportComments$감가상각비 수정
forward
global type w_kfab20 from w_inherite
end type
type dw_1 from u_key_enter within w_kfab20
end type
type dw_lst from u_d_popup_sort within w_kfab20
end type
type dw_detail from u_key_enter within w_kfab20
end type
type dw_detail_babu from u_key_enter within w_kfab20
end type
type st_2 from statictext within w_kfab20
end type
type rr_1 from roundrectangle within w_kfab20
end type
type rr_2 from roundrectangle within w_kfab20
end type
end forward

global type w_kfab20 from w_inherite
string title = "감가상각비 수정"
dw_1 dw_1
dw_lst dw_lst
dw_detail dw_detail
dw_detail_babu dw_detail_babu
st_2 st_2
rr_1 rr_1
rr_2 rr_2
end type
global w_kfab20 w_kfab20

forward prototypes
public subroutine wf_clear ()
end prototypes

public subroutine wf_clear ();dw_lst.Reset()

dw_detail.SetRedraw(False)
dw_detail.Reset()
dw_detail.InsertRow(0)
dw_detail.SetRedraw(True)

dw_detail_babu.Reset()

dw_1.SetColumn("gubun")
dw_1.SetFocus()
end subroutine

on w_kfab20.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_lst=create dw_lst
this.dw_detail=create dw_detail
this.dw_detail_babu=create dw_detail_babu
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_lst
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_detail_babu
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_kfab20.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_lst)
destroy(this.dw_detail)
destroy(this.dw_detail_babu)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_1.SetTransObject(Sqlca)
dw_lst.SetTransObject(Sqlca)
dw_detail.SetTransObject(Sqlca)
dw_detail_babu.SetTransObject(Sqlca)

dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(1,"saupj",   Gs_Saupj)
dw_1.SetItem(1,"sang_ym", Left(F_Today(),6))

Wf_Clear()


end event

type dw_insert from w_inherite`dw_insert within w_kfab20
boolean visible = false
integer x = 110
integer y = 1960
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfab20
boolean visible = false
integer x = 3895
integer y = 3188
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfab20
boolean visible = false
integer x = 3717
integer y = 3184
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfab20
boolean visible = false
integer x = 3077
integer y = 16
integer taborder = 0
string picturename = "C:\erpman\image\계산_up.gif"
end type

type p_ins from w_inherite`p_ins within w_kfab20
boolean visible = false
integer x = 3351
integer y = 3184
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfab20
end type

type p_can from w_inherite`p_can within w_kfab20
end type

event p_can::clicked;call super::clicked;
Wf_Clear()


end event

type p_print from w_inherite`p_print within w_kfab20
boolean visible = false
integer x = 3534
integer y = 3184
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfab20
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String  sSaupj,sKfYm,sKfcod

dw_1.AcceptText()
sSaupj = dw_1.GetItemString(1,"saupj")
sKfYm  = Trim(dw_1.GetItemString(1,"sang_ym"))
sKfCod = dw_1.GetItemString(1,"gubun")

if sSaupj = '' or IsNull(sSaupj) then
	F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	Return 
else
	if sSaupj = '99' then sSaupj = '%'
end if

if sKfYm = '' or IsNull(sKfYm) then
	F_MessageChk(1,'[감가상각년월]')
	dw_1.SetColumn("sang_ym")
	dw_1.SetFocus()
	Return 
end if

if sKfCod = '' or IsNull(sKfCod) then sKfCod = '%'

if dw_lst.Retrieve(sSaupj,sKfYm,sKfCod) <=0 then
	F_MessageChk(14,'')
	
	Wf_Clear()
	
	Return
else
	dw_lst.SelectRow(0,False)
	dw_lst.SelectRow(1,True)
	
	dw_detail.SetRedraw(False)
	dw_detail.Retrieve(dw_lst.GetItemString(1,"kfyymm"),&
							 dw_lst.GetItemString(1,"kfcod1"),&
							 dw_lst.GetItemNumber(1,"kfcod2"))
	dw_detail.SetRedraw(True)	
	
	dw_detail_babu.Retrieve(dw_lst.GetItemString(1,"kfyymm"),&
							      dw_lst.GetItemString(1,"kfcod1"),&
							      dw_lst.GetItemNumber(1,"kfcod2"))						 
end if



end event

type p_del from w_inherite`p_del within w_kfab20
integer taborder = 0
end type

event p_del::clicked;call super::clicked;String   sKfCod1,sKfYm
Long     dKfCod2

if dw_lst.GetSelectedRow(0) <=0 then
	F_MessageChk(11,'')
	Return
end if

dw_lst.AcceptText()
sKfYm     = dw_lst.GetitemString(dw_lst.GetSelectedRow(0),"kfyymm")
sKfCod1   = dw_lst.GetitemString(dw_lst.GetSelectedRow(0),"kfcod1")
dKfCod2   = dw_lst.GetitemNumber(dw_lst.GetSelectedRow(0),"kfcod2")

IF F_DbConFirm('삭제') = 2 THEN Return

dw_detail.SetRedraw(False)
dw_detail.DeleteRow(0)

IF dw_detail.update() = 1 THEN	
	delete from kfa10ot1 where kfyymm = :sKfYm and kfcod1 = :sKfcod1 and kfcod2 = :dKfcod2;
	
	/*고정자산 잔고 갱신*/
	String sKfyear
	select kfyear into :sKfyear from kfa07om0 ;

	update kfa04om0
		set kfde01 = decode(substr(:sKfYm,5,2),'01',0,kfde01),
			 kfde02 = decode(substr(:sKfYm,5,2),'02',0,kfde02),
			 kfde03 = decode(substr(:sKfYm,5,2),'03',0,kfde03),
			 kfde04 = decode(substr(:sKfYm,5,2),'04',0,kfde04),
			 kfde05 = decode(substr(:sKfYm,5,2),'05',0,kfde05),
			 kfde06 = decode(substr(:sKfYm,5,2),'06',0,kfde06),
			 kfde07 = decode(substr(:sKfYm,5,2),'07',0,kfde07),
			 kfde08 = decode(substr(:sKfYm,5,2),'08',0,kfde08),
			 kfde09 = decode(substr(:sKfYm,5,2),'09',0,kfde09),
			 kfde10 = decode(substr(:sKfYm,5,2),'10',0,kfde10),
			 kfde11 = decode(substr(:sKfYm,5,2),'11',0,kfde11),
			 kfde12 = decode(substr(:sKfYm,5,2),'12',0,kfde12)
		where kfyear = :sKfyear and kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	
	COMMIT;

	w_mdi_frame.sle_msg.text   = "자료가 삭제되었습니다"
	ib_any_typing = False
ELSE
	F_MessageChk(12,'')
	w_mdi_frame.sle_msg.text   = "자료 삭제를 실패하였습니다.!!"
	ROLLBACK;
	return
END IF

ib_any_typing = False

p_inq.TriggerEvent(Clicked!)
dw_detail.SetRedraw(True)
end event

type p_mod from w_inherite`p_mod within w_kfab20
integer taborder = 60
end type

event p_mod::clicked;Double   dKfAmt2,dKfAmt2Sum,lKfcod
String   sKfJog, sKfcod,sKfYm

dw_detail.AcceptText()
sKfYm   = dw_detail.GetItemString(1,"kfyymm")
sKfcod  = dw_detail.GetItemString(1,"kfcod1")
lKfcod  = dw_detail.GetItemNumber(1,"kfcod2")

sKfJog  = dw_detail.GetItemString(1,"kfjog")
dKfAmt2 = dw_detail.GetItemNumber(1,"kfamt2")
if IsNull(dKfAmt2) then dKfAmt2 = 0

dw_detail_babu.AcceptText()
if dw_detail_babu.RowCount() > 0 then
	dKfAmt2Sum = dw_detail_babu.GetItemNumber(1,"sum_kfamts")
else
	dKfAmt2Sum = 0
end if
if sKfJog = '9' then
	if dKfAmt2 <> dKfAmt2Sum then
		MessageBox('확 인','당월상각액이 공통배부내역의 합과 다릅니다')
		Return
	end if
end if
if f_dbconfirm("저장") = 2 then Return

if dw_detail.Update() <> 1 then
	Rollback;
	F_MessageChk(13,'')
	Return
else
	if dw_detail_babu.Update() <> 1 then
		Rollback;
		F_MessageChk(13,'')
		Return
	end if		
end if

/*고정자산 잔고 갱신*/
String sKfyear
select kfyear into :sKfyear from kfa07om0 ;

//select dym01, 	dym02,	dym03, 	dym04, 	dym05, 	dym06, 	dym07,	dym08,	dym09, 	dym10, 	dym11,	dym12, 	kfyear
//	into :sYm01,:sYm02,	:sYm03,	:sYm04,	:sYm05, 	:sYm06, 	:sYm07,	:sYm08, 	:sYm09,	:sYm10,  :sYm11,  :sYm12, :sKfyear
//	from kfz08om0 a, kfa07om0 b
//	where a.d_ses = b.kfyear ;
//

update kfa04om0
	set kfde01 = decode(substr(:sKfYm,5,2),'01',:dKfAmt2,kfde01),
		 kfde02 = decode(substr(:sKfYm,5,2),'02',:dKfAmt2,kfde02),
		 kfde03 = decode(substr(:sKfYm,5,2),'03',:dKfAmt2,kfde03),
		 kfde04 = decode(substr(:sKfYm,5,2),'04',:dKfAmt2,kfde04),
		 kfde05 = decode(substr(:sKfYm,5,2),'05',:dKfAmt2,kfde05),
		 kfde06 = decode(substr(:sKfYm,5,2),'06',:dKfAmt2,kfde06),
		 kfde07 = decode(substr(:sKfYm,5,2),'07',:dKfAmt2,kfde07),
		 kfde08 = decode(substr(:sKfYm,5,2),'08',:dKfAmt2,kfde08),
		 kfde09 = decode(substr(:sKfYm,5,2),'09',:dKfAmt2,kfde09),
		 kfde10 = decode(substr(:sKfYm,5,2),'10',:dKfAmt2,kfde10),
		 kfde11 = decode(substr(:sKfYm,5,2),'11',:dKfAmt2,kfde11),
		 kfde12 = decode(substr(:sKfYm,5,2),'12',:dKfAmt2,kfde12)
	where kfyear = :sKfyear and kfcod1 = :sKfcod and kfcod2 = :lKfcod;
							
Commit;
w_mdi_frame.sle_msg.text   = "자료가 저장되었습니다."

p_inq.TriggerEvent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_kfab20
end type

type cb_mod from w_inherite`cb_mod within w_kfab20
end type

type cb_ins from w_inherite`cb_ins within w_kfab20
end type

type cb_del from w_inherite`cb_del within w_kfab20
end type

type cb_inq from w_inherite`cb_inq within w_kfab20
end type

type cb_print from w_inherite`cb_print within w_kfab20
end type

type st_1 from w_inherite`st_1 within w_kfab20
end type

type cb_can from w_inherite`cb_can within w_kfab20
end type

type cb_search from w_inherite`cb_search within w_kfab20
end type







type gb_button1 from w_inherite`gb_button1 within w_kfab20
end type

type gb_button2 from w_inherite`gb_button2 within w_kfab20
end type

type dw_1 from u_key_enter within w_kfab20
integer x = 59
integer y = 28
integer width = 2990
integer height = 168
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_kfab201"
boolean border = false
end type

event itemchanged;call super::itemchanged;
Wf_Clear()
end event

type dw_lst from u_d_popup_sort within w_kfab20
integer x = 82
integer y = 204
integer width = 1989
integer height = 2004
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_kfab202"
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
	b_flag = True
ELSE
	dw_lst.SelectRow(0,False)
	dw_lst.SelectRow(row,True)

	dw_detail.SetRedraw(False)
	dw_detail.Retrieve(this.GetItemString(row,"kfyymm"),&
							 this.GetItemString(row,"kfcod1"),&
							 this.GetItemNumber(row,"kfcod2"))
	dw_detail.SetRedraw(True)	
	
	dw_detail_babu.Retrieve(this.GetItemString(row,"kfyymm"),&
							      this.GetItemString(row,"kfcod1"),&
							      this.GetItemNumber(row,"kfcod2"))		
	
	b_Flag = False
END IF

call super ::clicked
end event

type dw_detail from u_key_enter within w_kfab20
integer x = 2126
integer y = 216
integer width = 2446
integer height = 1056
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kfab203"
boolean border = false
end type

event itemchanged;Double  dKfAmt2,dKfAmt3,dKfDeAmt,dKfjAmt,dKfDrAmt,dKfCrAmt, dKfReamt
String  sKfJog

if this.GetColumnName() = 'kfamt2' then
	dKfAmt2 = Double(this.GetText())
	if IsNull(dKfAmt2) then dKfAmt2 = 0
	
	dKfDeAmt = this.GetItemNumber(1,"kfdeamt")						/*기초상각누계액*/
	if IsNull(dKfDeAmt) then dKfDeAmt = 0
	
	dKfjAmt = this.GetItemNumber(1,"kfjamt")							/*기초장부가액*/
	if IsNull(dKfjAmt) then dKfjAmt = 0
	
	dKfdrAmt = this.GetItemNumber(1,"kfdramt")						/*당기증가액*/
	if IsNull(dKfdrAmt) then dKfdrAmt = 0
	
	dKfcrAmt = this.GetItemNumber(1,"kfcramt")						/*당기감소액*/
	if IsNull(dKfcrAmt) then dKfcrAmt = 0
	
	dKfAmt3 = this.GetItemNumber(1,"kfamt3") 							/*전월누계상각액*/
	if IsNull(dKfAmt3) then dKfAmt3 = 0
	
	
	dKfReamt = this.GetItemNumber(1,"kfreamt") 							/*충당금감소액*/
	if IsNull(dKfReamt) then dKfReamt = 0
	
	this.SetItem(1,"kfamt1", dKfAmt3 + dKfAmt2)						/*당기상각누계액*/
	this.SetItem(1,"kfamt4", dKfDeAmt + dKfAmt3 + dKfAmt2)		/*총상각누계액*/
	this.SetItem(1,"kfamt6", dKfjAmt + dKfDrAmt - dKfCrAmt - (dKfAmt3 + dKfAmt2 - dKfReamt ))		/*미상각잔액*/
	
	sKfJog = this.GetItemString(1,"kfjog")
	if sKfJog <> '9' then
		if sKfJog = '1' then
			this.SetItem(1,"kfamtf", dKfAmt2)		
		elseif sKfjog = '2' then
			this.SetItem(1,"kfamtm", dKfAmt2)
		elseif sKfjog = '4' then
			this.SetItem(1,"kfamtr", dKfAmt2)
		end if
	else
		this.SetItem(1,"kfamtf", 0)	
		this.SetItem(1,"kfamtm", 0)
		this.SetItem(1,"kfamtr", 0)
	end if
end if
end event

type dw_detail_babu from u_key_enter within w_kfab20
integer x = 2158
integer y = 1404
integer width = 2395
integer height = 776
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kfab204"
end type

type st_2 from statictext within w_kfab20
integer x = 2176
integer y = 1328
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "<<공통의 배부율>>"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfab20
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 196
integer width = 2025
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfab20
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2107
integer y = 200
integer width = 2501
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

