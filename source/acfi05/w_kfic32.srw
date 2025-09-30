$PBExportHeader$w_kfic32.srw
$PBExportComments$회사채상환계획등록
forward
global type w_kfic32 from w_inherite
end type
type dw_pop from datawindow within w_kfic32
end type
type cb_insert from commandbutton within w_kfic32
end type
type cb_delete from commandbutton within w_kfic32
end type
type dw_hpop from datawindow within w_kfic32
end type
type rr_1 from roundrectangle within w_kfic32
end type
end forward

global type w_kfic32 from w_inherite
integer x = 805
integer y = 256
integer width = 2181
integer height = 2000
string title = "회사채상환계획등록"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_pop dw_pop
cb_insert cb_insert
cb_delete cb_delete
dw_hpop dw_hpop
rr_1 rr_1
end type
global w_kfic32 w_kfic32

forward prototypes
public function integer wf_requirechk (integer icurrow)
end prototypes

public function integer wf_requirechk (integer icurrow);integer iCb_Seq
 string sCb_JiDate

dw_pop.AcceptText()

iCb_Seq      = dw_pop.GetItemNumber(icurrow,"cb_seq")
sCb_JiDate   = dw_pop.GetItemString(icurrow,"cb_jidate")

IF iCb_Seq = 0 OR IsNull(iCb_Seq) THEN
	F_MessageChk(1,'[순번]')
	dw_pop.SetColumn("cb_seq")
	dw_pop.SetFocus()
	Return -1
END IF

IF sCb_JiDate = "" OR IsNull(sCb_JiDate) THEN
	F_MessageChk(1,'[일자]')
	dw_pop.SetColumn("cb_jidate")
	dw_pop.SetFocus()
	Return -1
END IF

if f_datechk(sCb_JiDate) = -1 then 
	F_MessageChk(21, "[일자]")
	return -1
end if

return 1

end function

on w_kfic32.create
int iCurrent
call super::create
this.dw_pop=create dw_pop
this.cb_insert=create cb_insert
this.cb_delete=create cb_delete
this.dw_hpop=create dw_hpop
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pop
this.Control[iCurrent+2]=this.cb_insert
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.dw_hpop
this.Control[iCurrent+5]=this.rr_1
end on

on w_kfic32.destroy
call super::destroy
destroy(this.dw_pop)
destroy(this.cb_insert)
destroy(this.cb_delete)
destroy(this.dw_hpop)
destroy(this.rr_1)
end on

event open;call super::open;string  sCb_Code,sCb_NM
integer iRow,ll_row

F_Window_Center_Response(This)

dw_hpop.SetTransObject(SQLCA)
dw_hpop.Reset()
dw_hpop.InsertRow(0)

sCb_Code = Message.StringParm

  SELECT "KFM22M"."CB_NM" INTO :sCb_Nm
                          FROM "KFM22M" 
							    WHERE "KFM22M"."CB_CODE" = :sCb_Code
								   AND ROWNUM = 1;

dw_hpop.SetItem(1,"cb_code",sCb_Code)
dw_hpop.SetItem(1,"cb_nm",sCb_Nm)

dw_pop.SetTransObJect(sqlca)
dw_pop.Retrieve(sCb_code)

ll_Row = dw_pop.Retrieve(sCb_code)
IF ll_Row = 0 THEN
	dw_pop.InsertRow(0)
	dw_pop.SetItem(dw_pop.GetRow(),"cb_code",sCb_Code)
	dw_pop.SetItem(dw_pop.GetRow(),"cb_ijaamt",0)
	dw_pop.SetItem(dw_pop.GetRow(),"cb_wonamt",0)
END IF	

dw_pop.SetColumn("CB_SEQ")
dw_pop.setfocus()

end event

type dw_insert from w_inherite`dw_insert within w_kfic32
boolean visible = false
integer x = 78
integer y = 2172
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfic32
integer x = 1609
integer y = 12
end type

event p_delrow::clicked;call super::clicked;Integer iL_CurRow
 string sSflag

w_mdi_frame.sle_msg.text =""

iL_currow = dw_pop.GetRow()
IF iL_currow <=0 Then Return

sSflag = dw_pop.GetItemString(iL_CurRow,"sflag")
	
dw_pop.DeleteRow(iL_CurRow)

IF iL_CurRow > 1 THEN
	dw_pop.ScrollToRow(iL_CurRow - 1)
	dw_pop.SetColumn('cb_seq')				
	dw_pop.SetFocus()		
end if

end event

type p_addrow from w_inherite`p_addrow within w_kfic32
integer x = 1435
integer y = 12
end type

event p_addrow::clicked;call super::clicked;string sCb_Code,sCb_JiDate
   Int iCb_Seq,iFunctionValue,iCurRow

iCb_Seq    = dw_pop.GetItemNumber(dw_pop.GetRow(),"cb_seq")
sCb_JiDate = dw_pop.GetItemString(dw_pop.GetRow(),"cb_jidate")

IF dw_pop.RowCount() > 0 THEN
   iFunctionValue = Wf_RequireChk(dw_pop.GetRow())
   IF iFunctionValue <> 1 THEN RETURN
ELSE
    iFunctionValue = 1	
END IF

iCurRow = dw_pop.InsertRow(0)
dw_pop.ScrollToRow(iCurRow)

sCb_Code = dw_hpop.GetItemString(1,"cb_code")
dw_pop.SetItem(iCurRow,"cb_code",sCb_Code)

dw_pop.SetItem(iCurRow,"cb_ijaamt",0)
dw_pop.SetItem(iCurRow,"cb_wonamt",0)

dw_pop.setcolumn('cb_seq')
dw_pop.SetFocus()


w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"

end event

type p_search from w_inherite`p_search within w_kfic32
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_kfic32
boolean visible = false
end type

type p_exit from w_inherite`p_exit within w_kfic32
integer x = 1957
integer y = 8
end type

type p_can from w_inherite`p_can within w_kfic32
boolean visible = false
end type

type p_print from w_inherite`p_print within w_kfic32
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_kfic32
boolean visible = false
end type

type p_del from w_inherite`p_del within w_kfic32
boolean visible = false
end type

type p_mod from w_inherite`p_mod within w_kfic32
integer x = 1783
integer y = 12
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue,iFunctionValue,iRowCnt,iCb_Seq
  long  iReturnRow
string  sSflag,sCb_JiDate

IF dw_pop.AcceptText() = -1 THEN Return

iCb_Seq    = dw_pop.GetItemNumber(dw_pop.GetRow(),"cb_seq")
sCb_JiDate = dw_pop.GetItemString(dw_pop.GetRow(),"cb_jidate")

IF dw_pop.RowCount() > 0 THEN
   iFunctionValue = Wf_RequireChk(dw_pop.GetRow())
   IF iFunctionValue <> 1 THEN RETURN
ELSE
    iFunctionValue = 1	
END IF
  
  iRowCnt = dw_pop.RowCount()
  IF iRowCnt > 0 THEN
     IF f_dbConFirm('저장') = 2 THEN RETURN

      IF dw_POP.Update() = 1 THEN
	      commit;
	
         w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"

     ELSE
	      ROLLBACK;
	     f_messagechk(13,'') 
   END IF
END IF

end event

type cb_exit from w_inherite`cb_exit within w_kfic32
boolean visible = false
integer x = 1655
integer y = 2200
integer width = 361
integer taborder = 50
end type

type cb_mod from w_inherite`cb_mod within w_kfic32
boolean visible = false
integer x = 1275
integer y = 2200
integer width = 361
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue,iFunctionValue,iRowCnt,iCb_Seq
  long  iReturnRow
string  sSflag,sCb_JiDate

IF dw_pop.AcceptText() = -1 THEN Return

iCb_Seq    = dw_pop.GetItemNumber(dw_pop.GetRow(),"cb_seq")
sCb_JiDate = dw_pop.GetItemString(dw_pop.GetRow(),"cb_jidate")

IF dw_pop.RowCount() > 0 THEN
   iFunctionValue = Wf_RequireChk(dw_pop.GetRow())
   IF iFunctionValue <> 1 THEN RETURN
ELSE
    iFunctionValue = 1	
END IF
  
  iRowCnt = dw_pop.RowCount()
  IF iRowCnt > 0 THEN
     IF f_dbConFirm('저장') = 2 THEN RETURN

      IF dw_POP.Update() = 1 THEN
	      commit;
	
         sle_msg.text ="자료가 저장되었습니다.!!!"

     ELSE
	      ROLLBACK;
	     f_messagechk(13,'') 
   END IF
END IF

end event

type cb_ins from w_inherite`cb_ins within w_kfic32
boolean visible = false
integer y = 2348
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kfic32
boolean visible = false
integer x = 946
integer y = 2340
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_kfic32
boolean visible = false
integer y = 2348
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_kfic32
integer x = 1097
integer y = 2508
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfic32
boolean visible = false
integer y = 2012
end type

type cb_can from w_inherite`cb_can within w_kfic32
boolean visible = false
integer x = 1294
integer y = 2340
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_kfic32
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kfic32
boolean visible = false
integer x = 1038
integer y = 2088
integer width = 2322
end type

type sle_msg from w_inherite`sle_msg within w_kfic32
boolean visible = false
integer y = 2012
integer width = 1550
end type

type gb_10 from w_inherite`gb_10 within w_kfic32
boolean visible = false
integer y = 1964
integer width = 1957
end type

type gb_button1 from w_inherite`gb_button1 within w_kfic32
boolean visible = false
integer width = 905
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kfic32
boolean visible = false
integer x = 475
integer y = 2144
integer width = 1573
end type

type dw_pop from datawindow within w_kfic32
event ue_enterkey pbm_dwnprocessenter
integer x = 27
integer y = 180
integer width = 2071
integer height = 1688
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kfic30_c"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;Integer iCb_Seq,iReturnRow,iCurRow
 string sSflag,sCb_Code,sNull,sCb_JiDate
   long ll_find = 1, ll_end
 
SetNull(sNull) 

dw_hpop.AcceptText()

sCb_Code = dw_hpop.GetItemString(1,"cb_code")

dw_pop.AcceptText()

iCb_Seq = dw_pop.GetItemNumber(this.GetRow(),"cb_seq")
sSflag  = dw_pop.GetItemString(this.GetRow(),"sflag")
iCurRow = dw_pop.GetRow()

ll_end = dw_pop.RowCount()

DO WHILE ll_find <= ll_end

   IF ll_find <> iCurRow then
      iReturnRow = dw_pop.find("cb_code = "+ "sCb_Code"+ " and " + "cb_seq =  "+  string(iCb_Seq) , ll_find , ll_find)

      IF iReturnRow <> 0 THEN
	      f_MessageChk(10,'[상환 순번]')
   		dw_pop.SetItem(this.GetRow(),"cb_seq",0)
	      RETURN  1
      END IF
	END IF
	
	ll_find ++
LOOP

end event

event itemerror;RETURN 1
end event

event rowfocuschanging;//this.SetRowFocusIndicator(Hand!)
end event

event itemfocuschanged;//this.SetRowFocusIndicator(Hand!)
end event

type cb_insert from commandbutton within w_kfic32
boolean visible = false
integer x = 517
integer y = 2200
integer width = 361
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행추가(&A)"
end type

event clicked;string sCb_Code,sCb_JiDate
   Int iCb_Seq,iFunctionValue,iCurRow

iCb_Seq    = dw_pop.GetItemNumber(dw_pop.GetRow(),"cb_seq")
sCb_JiDate = dw_pop.GetItemString(dw_pop.GetRow(),"cb_jidate")

IF dw_pop.RowCount() > 0 THEN
   iFunctionValue = Wf_RequireChk(dw_pop.GetRow())
   IF iFunctionValue <> 1 THEN RETURN
ELSE
    iFunctionValue = 1	
END IF

iCurRow = dw_pop.InsertRow(0)
dw_pop.ScrollToRow(iCurRow)

sCb_Code = dw_hpop.GetItemString(1,"cb_code")
dw_pop.SetItem(iCurRow,"cb_code",sCb_Code)

dw_pop.SetItem(iCurRow,"cb_ijaamt",0)
dw_pop.SetItem(iCurRow,"cb_wonamt",0)

dw_pop.setcolumn('cb_seq')
dw_pop.SetFocus()


sle_msg.text = "새로운 자료를 입력하십시요!!"

end event

type cb_delete from commandbutton within w_kfic32
boolean visible = false
integer x = 896
integer y = 2200
integer width = 361
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행삭제(&D)"
end type

event clicked;Integer iL_CurRow
 string sSflag

sle_msg.text =""

iL_currow = dw_pop.GetRow()
IF iL_currow <=0 Then Return

sSflag = dw_pop.GetItemString(iL_CurRow,"sflag")
	
dw_pop.DeleteRow(iL_CurRow)

IF iL_CurRow > 1 THEN
	dw_pop.ScrollToRow(iL_CurRow - 1)
	dw_pop.SetColumn('cb_seq')				
	dw_pop.SetFocus()		
end if

end event

type dw_hpop from datawindow within w_kfic32
integer y = 16
integer width = 1431
integer height = 140
boolean bringtotop = true
boolean enabled = false
string dataobject = "dw_kfic30_e"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kfic32
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 176
integer width = 2098
integer height = 1696
integer cornerheight = 40
integer cornerwidth = 46
end type

