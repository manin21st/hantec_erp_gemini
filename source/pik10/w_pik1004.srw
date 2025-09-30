$PBExportHeader$w_pik1004.srw
$PBExportComments$** 근무스케쥴 등록
forward
global type w_pik1004 from w_inherite_multi
end type
type dw_main from u_key_enter within w_pik1004
end type
type dw_1 from datawindow within w_pik1004
end type
type rr_1 from roundrectangle within w_pik1004
end type
end forward

global type w_pik1004 from w_inherite_multi
string title = "근무스케쥴등록"
dw_main dw_main
dw_1 dw_1
rr_1 rr_1
end type
global w_pik1004 w_pik1004

type variables
String spaytag
end variables

forward prototypes
public function integer wf_requiredcheck (integer ll_row)
end prototypes

public function integer wf_requiredcheck (integer ll_row);
String skmgb, skhgb ,sname 
int sseq, sftime,sttime, sctgb , wk_gbun ,wk_hh , wk_mm ,shhmm
dec sgtime  

dw_1.accepttext()
dw_main.accepttext()

skmgb  = dw_1.GetItemString(1,"kmgubn")
sseq   = dw_main.GetItemnumber(ll_row,"seq")
sctgb  = dw_main.GetItemnumber(ll_row,"ctgubn")
sftime = dw_main.GetItemnumber(ll_row,"fromtime")
sttime = dw_main.GetItemnumber(ll_row,"totime")
sgtime = dw_main.GetItemdecimal(ll_row,"gtime")
skhgb  = dw_main.GetItemString(ll_row,"khgubn")
shhmm = round(sgtime * 100 ,1)

IF skmgb ="" OR IsNull(skmgb) THEN
	Messagebox("확 인","근무일구분을 입력하세요!!")
	dw_main.SetColumn("kmgubn")
	dw_main.SetFocus()
	Return -1
else
	SELECT "P0_KUNMUIL"."KMNAME"  
	 into  :sname
    FROM "P0_KUNMUIL"  
    WHERE "P0_KUNMUIL"."KMGUBN" = :skmgb  ;
	 
	 if SQLCA.SQLCODE <> 0 then
		 MessageBox("확인","등록되지 않은 근무구분 입니다.") 	
		 dw_main.SetColumn("KMGUBN")
		 dw_main.setfocus()
		 RETURN  -1
	 end if  		
END IF

IF sseq = 0 OR IsNull(sseq) THEN
	Messagebox("확 인","seq를 입력하세요!!")
	dw_main.SetColumn("seq")
	dw_main.SetFocus()
	Return -1
END IF

if sctgb > 3  then
	Messagebox("확 인","출퇴근구분을 확인하세요!!")
	dw_main.SetColumn("ctgubn")
	dw_main.SetFocus()
	Return -1
END IF

IF sftime = 0 OR IsNull(sftime) THEN
	Messagebox("확 인","from시간을 입력하세요!!")
	dw_main.SetColumn("fromtime")
	dw_main.SetFocus()
	Return -1
END IF

IF sttime = 0 OR IsNull(sttime) THEN
	Messagebox("확 인","to시간을 입력하세요!!")
	dw_main.SetColumn("totime")
	dw_main.SetFocus()
	Return -1
END IF

IF sgtime = 0 OR IsNull(sgtime) THEN
	Messagebox("확 인","인정시간을 입력하세요!!")
	dw_main.SetColumn("gtime")
	dw_main.SetFocus()
	Return -1
else
	wk_hh = integer(shhmm /100)
   wk_mm = Integer(right(String(shhmm),2))
	wk_gbun= wk_hh * 60 + wk_mm
	dw_main.setitem(ll_row,"gbun",wk_gbun)
END IF

IF skhgb ="" OR IsNull(skhgb) THEN
	Messagebox("확 인","근태구분을 입력하세요!!")
	dw_main.SetColumn("khgubn")
	dw_main.SetFocus()
	Return -1
elseif skhgb <> '1' and skhgb <> '2' and skhgb <> '3' and skhgb <> '4' and skhgb <> '5' and skhgb <> '6' and skhgb <> '9' then
	Messagebox("확 인","근태구분을 확인하세요!!")
	dw_main.SetColumn("khgubn")
	dw_main.SetFocus()
	Return -1
		
END IF

dw_main.setitem(ll_row,"KMGUBN",skmgb)

Return 1
end function

on w_pik1004.create
int iCurrent
call super::create
this.dw_main=create dw_main
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_main
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_pik1004.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_main)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;
dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

f_set_saupcd(dw_1, 'saupcd', '1')
is_saupcd = gs_saupcd

dw_1.SetFocus()

dw_main.SetTransObject(SQLCA)
dw_main.Reset()




end event

type p_delrow from w_inherite_multi`p_delrow within w_pik1004
boolean visible = false
integer x = 2789
integer y = 3124
end type

type p_addrow from w_inherite_multi`p_addrow within w_pik1004
boolean visible = false
integer x = 2615
integer y = 3124
end type

type p_search from w_inherite_multi`p_search within w_pik1004
boolean visible = false
integer x = 2624
integer y = 2964
end type

type p_ins from w_inherite_multi`p_ins within w_pik1004
integer x = 3872
end type

event p_ins::clicked;Int il_currow,il_functionvalue
string ls_kmgubn

dw_1.Accepttext()

ls_kmgubn = dw_1.GetitemString(1,'kmgubn')

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue = 1
ELSE
	il_functionvalue = wf_requiredcheck(dw_main.GetRow())	
	il_currow = dw_main.getrow() + 1
END IF

if IsNull(ls_kmgubn) or ls_kmgubn = '' then
	messagebox("확인","근무일구분을 입력하세요!!")
	dw_1.SetColumn('kmgubn')
	dw_1.Setfocus()
	return
end if


IF il_functionvalue = 1 THEN
	il_currow = il_currow 
	
	dw_main.InsertRow(il_currow)
	dw_main.SetItem(il_currow,"companycode",gs_company)
	dw_main.Setitem(il_currow,"saupcd",dw_1.GetitemString(1,'saupcd'))
	dw_main.Setitem(il_currow,"kmgubn",ls_kmgubn)
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("SEQ")
	dw_main.setitem(il_currow,"ftimegubn","1")
	dw_main.setitem(il_currow,"ttimegubn","1")
	dw_main.SetFocus()
	
	
END IF

end event

type p_exit from w_inherite_multi`p_exit within w_pik1004
end type

type p_can from w_inherite_multi`p_can within w_pik1004
boolean visible = false
integer x = 2971
integer y = 2964
end type

type p_print from w_inherite_multi`p_print within w_pik1004
boolean visible = false
integer x = 2798
integer y = 2964
end type

type p_inq from w_inherite_multi`p_inq within w_pik1004
boolean visible = false
integer x = 3008
integer y = 3116
end type

type p_del from w_inherite_multi`p_del within w_pik1004
integer x = 4219
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
		dw_main.SetColumn("kmgubn")
		dw_main.SetFocus()
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite_multi`p_mod within w_pik1004
integer x = 4046
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN 	RETURN

SetPointer(HourGlass!)
IF dw_main.RowCount() > 0 THEN
	for k = 1 to dw_main.rowcount()
	   IF wf_requiredcheck(k) = -1 THEN 
			SetPointer(Arrow!)
			RETURN 
		END IF
   next
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
		
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	SetPointer(Arrow!)
	Return
END IF

dw_main.Setfocus()
SetPointer(Arrow!)
		

end event

type dw_insert from w_inherite_multi`dw_insert within w_pik1004
boolean visible = false
integer x = 96
integer y = 2860
end type

type st_window from w_inherite_multi`st_window within w_pik1004
boolean visible = false
long backcolor = 80269524
end type

type cb_append from w_inherite_multi`cb_append within w_pik1004
boolean visible = false
integer x = 105
integer taborder = 40
end type

type cb_exit from w_inherite_multi`cb_exit within w_pik1004
boolean visible = false
integer x = 3127
integer taborder = 90
end type

type cb_update from w_inherite_multi`cb_update within w_pik1004
boolean visible = false
integer x = 2395
integer taborder = 60
end type

type cb_insert from w_inherite_multi`cb_insert within w_pik1004
boolean visible = false
integer x = 471
integer taborder = 50
end type

type cb_delete from w_inherite_multi`cb_delete within w_pik1004
boolean visible = false
integer x = 2761
integer taborder = 70
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pik1004
boolean visible = false
integer taborder = 30
end type

event cb_retrieve::clicked;
sle_msg.text = ''

IF dw_main.Retrieve(gs_company) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!",StopSign!)
	Return
ELSE
	dw_main.SetRedraw(False)
	dw_main.ScrollToRow(dw_main.RowCount())
	dw_main.SetColumn("KMGUBN")
	dw_main.SetFocus()
	dw_main.SetRedraw(True)
END IF

sle_msg.text = " 조회 "


end event

type st_1 from w_inherite_multi`st_1 within w_pik1004
boolean visible = false
long backcolor = 80269524
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pik1004
boolean visible = false
integer taborder = 80
end type

event cb_cancel::clicked;call super::clicked;
sle_msg.text = ''

dw_main.Reset()
ib_any_typing = false

cb_retrieve.TriggerEvent(Clicked!)



end event

type dw_datetime from w_inherite_multi`dw_datetime within w_pik1004
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pik1004
boolean visible = false
long backcolor = 80269524
end type

type gb_2 from w_inherite_multi`gb_2 within w_pik1004
boolean visible = false
integer x = 2336
integer width = 1184
long backcolor = 80269524
end type

type gb_1 from w_inherite_multi`gb_1 within w_pik1004
boolean visible = false
integer width = 763
long backcolor = 80269524
end type

type gb_10 from w_inherite_multi`gb_10 within w_pik1004
boolean visible = false
integer x = 14
integer y = 2812
long backcolor = 80269524
end type

type dw_main from u_key_enter within w_pik1004
integer x = 517
integer y = 256
integer width = 3429
integer height = 1772
integer taborder = 20
string dataobject = "d_pik1004_2"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Int il_currow,lReturnRow
String snull,cseq,sGbn

SetNull(snull)

dw_main.accepttext()

il_currow = dw_main.GetRow()  

IF this.GetColumnName() = "nightgubn" THEN
	sGbn = this.GetText()
	
	IF sGbn ="" OR IsNull(sGbn) THEN Return
	
	IF sGbn <> 'Y' and sGbn <> 'N' THEN
		MessageBox("확 인","심야인정여부는 'Y' 또는 'N'입니다!!")
		this.SetItem(il_currow,"nightgubn",'N')
		Return 1
	END IF
END IF

end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;
//this.SetRowFocusIndicator(Hand!)
end event

event editchanged;call super::editchanged;ib_any_typing =True


end event

event ue_pressenter; if dw_main.getcolumnname() = "khgubn" then
   if dw_main.rowcount() = dw_main.getrow() then
		cb_append.triggerevent(clicked!)
	else
		send(handle(this), 256, 9, 0)
	end if
else
	send(handle(this), 256, 9, 0)
end if

return 1
end event

event dberror;
IF sqldbcode = 1 THEN
	MessageBox("저장 에러","자료가 중복되었습니다. ["+String(row)+"라인] !!")
	Return 1
END IF
end event

type dw_1 from datawindow within w_pik1004
integer x = 475
integer y = 20
integer width = 2149
integer height = 200
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pik1004_1"
boolean border = false
boolean livescroll = true
end type

event itemerror;
Return 1
end event

event itemchanged;
String skmgb,snull,sname, sabu

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetColumnName() = "kmgubn" THEN
	skmgb= dw_1.gettext()
	sabu = dw_1.GetitemString(1,'saupcd')
   
   SELECT "P0_KUNMUIL"."KMNAME"  
 		into  :sname
		FROM "P0_KUNMUIL"  
		WHERE "P0_KUNMUIL"."KMGUBN" = :skmgb  ;
	if SQLCA.SQLCODE <> 0 then
		MessageBox("확인","등록되지 않은 근무구분 입니다.") 	
		dw_1.SetColumn("KMGUBN")
		dw_1.setfocus()
		RETURN  1
	ELSE
		dw_main.Retrieve(gs_company,sabu,skmgb)
	end if  	

end if	

end event

type rr_1 from roundrectangle within w_pik1004
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 512
integer y = 252
integer width = 3493
integer height = 1792
integer cornerheight = 40
integer cornerwidth = 46
end type

