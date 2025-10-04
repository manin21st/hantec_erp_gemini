$PBExportHeader$w_sal_06030.srw
$PBExportComments$수출 월마감
forward
global type w_sal_06030 from w_inherite
end type
type st_2 from statictext within w_sal_06030
end type
type st_3 from statictext within w_sal_06030
end type
type st_4 from statictext within w_sal_06030
end type
type st_5 from statictext within w_sal_06030
end type
type st_7 from statictext within w_sal_06030
end type
type st_8 from statictext within w_sal_06030
end type
type st_9 from statictext within w_sal_06030
end type
type st_10 from statictext within w_sal_06030
end type
type rr_1 from roundrectangle within w_sal_06030
end type
type rr_2 from roundrectangle within w_sal_06030
end type
type rr_3 from roundrectangle within w_sal_06030
end type
end forward

global type w_sal_06030 from w_inherite
string title = "수출 월마감"
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_7 st_7
st_8 st_8
st_9 st_9
st_10 st_10
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sal_06030 w_sal_06030

forward prototypes
public function integer wf_init ()
end prototypes

public function integer wf_init ();String syymm

SELECT MAX("JUNPYO_CLOSING"."JPDAT")
 INTO :sYymm
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'X3' );

dw_insert.SetItem(1, 'magam', syymm)

Return 0
end function

on w_sal_06030.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.st_10=create st_10
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.st_7
this.Control[iCurrent+6]=this.st_8
this.Control[iCurrent+7]=this.st_9
this.Control[iCurrent+8]=this.st_10
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
this.Control[iCurrent+11]=this.rr_3
end on

on w_sal_06030.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;string sdate
int    nRow

sdate = f_today()

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nrow,'sdate',left(sdate,6))

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_sal_06030
integer x = 1522
integer y = 372
integer width = 1467
integer height = 112
integer taborder = 10
string dataobject = "d_sal_06030_1"
boolean border = false
end type

event dw_insert::itemchanged;String sDate

Choose Case GetColumnName()
	Case 'sdate'
		sdate = Left(data,4) + Mid(data,5,2) + '01'
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
	      Return 1
      END IF
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sal_06030
boolean visible = false
integer x = 727
integer y = 2008
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_06030
boolean visible = false
integer x = 553
integer y = 2008
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_06030
integer x = 1733
integer y = 1300
integer width = 306
string pointer = "C:\erpman\cur\create.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\마감처리_up.gif"
end type

event p_search::clicked;call super::clicked;string  CurMonth,NxtMonth
int     nCnt,nRCnt
String  sSabu,sSales_yymm, sCvcod, sCurr
Dec {2} dMi_Inv_amt,  dMi_Inv_amt_u,  dMi_Inv_amt_w,dMi_Nego_amt, dMi_Nego_amt_u, dMi_Nego_amt_w
Dec {2} dOrd_amt,  dOrd_amt_u,  dOrd_amt_w,dInv_amt, dInv_amt_u, dInv_amt_w
Dec {2} dNego_amt, dNego_amt_u, dNego_amt_w
Dec {2} dNxt_Inv_amt, dNxt_Inv_amt_u, dNxt_Inv_amt_w
Dec {2} dNxt_Nego_amt,dNxt_Nego_amt_u,dNxt_Nego_amt_w

If dw_insert.AcceptText() <> 1 then Return
If dw_insert.GetRow() <= 0 Then Return

CurMonth = Trim(dw_insert.GetItemString(1,'sdate'))
If IsNull(CurMonth) Or CurMonth = '' Then
   f_message_chk(1400,'[마감일자]')
	Return 1
End If

/* 마감처리된 월 확인 */
  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'X3' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :CURMONTH );

If nCnt > 0 Then
	f_message_chk(60,'')
	Return
End If

IF MessageBox("마  감", "수출 월마감이 처리됩니다." +"~n~n" +&
                     	"계속 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN


INSERT INTO "JUNPYO_CLOSING"  
         ( "SABU",           "JPGU",         "JPDAT",           "DEPOT" )  
  VALUES ( :gs_sabu,        'X3',           :CurMonth,           '000000' )  ;
  

/* 익월 */
NxtMonth = f_aftermonth(CurMonth,1) 
nCnt = 0

/* 월마감을 위한 cursor문 */
long lrow 
datastore ds
ds = create datastore
ds.dataobject = "d_sal_06030_ds"
ds.settransobject(sqlca)
ds.retrieve(gs_sabu, curmonth)
	
For Lrow = 1 to ds.rowcount()
	 ssabu 			= ds.getitemstring(Lrow, "sabu")
	 ssales_yymm 	= ds.getitemstring(Lrow, "sales_yymm")
	 scvcod		 	= ds.getitemstring(Lrow, "cvcod")
	 scurr		 	= ds.getitemstring(Lrow, "curr")
    dMi_Inv_amt		= ds.getitemdecimal(Lrow, "amt1")
	 dMi_Inv_amt_u		= ds.getitemdecimal(Lrow, "amt2")
	 dMi_Inv_amt_w		= ds.getitemdecimal(Lrow, "amt3")
  	 dMi_Nego_amt		= ds.getitemdecimal(Lrow, "amt4")
	 dMi_Nego_amt_u	= ds.getitemdecimal(Lrow, "amt5")
	 dMi_Nego_amt_w	= ds.getitemdecimal(Lrow, "amt6")
	 dOrd_amt			= ds.getitemdecimal(Lrow, "amt7")
	 dOrd_amt_u			= ds.getitemdecimal(Lrow, "amt8")
	 dOrd_amt_w			= ds.getitemdecimal(Lrow, "amt9")
	 dInv_amt			= ds.getitemdecimal(Lrow, "amt10")
	 dInv_amt_u			= ds.getitemdecimal(Lrow, "amt11")
	 dInv_amt_w			= ds.getitemdecimal(Lrow, "amt12")
    dNego_amt			= ds.getitemdecimal(Lrow, "amt13")
	 dNego_amt_u		= ds.getitemdecimal(Lrow, "amt14")	
	 dNego_amt_w		= ds.getitemdecimal(Lrow, "amt15")


   /* 익월 미선적금액 = 전월미선적 + 수주금액 - 선적금액 */
   dNxt_Inv_amt    = dMi_inv_amt   + dOrd_amt   - dInv_amt
   dNxt_Inv_amt_u  = dMi_inv_amt_u + dOrd_amt_u - dInv_amt_u
   dNxt_Inv_amt_w  = dMi_inv_amt_w + dOrd_amt_w - dInv_amt_w
	
   /* 익월 미수금액 = 전월미수금 + 선적금액 - 입금금액 */
	dNxt_Nego_amt   = dMi_Nego_amt  + dInv_amt  - dNego_amt
	dNxt_Nego_amt_u = dMi_Nego_amt_u + dInv_amt_u  - dNego_amt_u
	dNxt_Nego_amt_w = dMi_Nego_amt_w + dInv_amt_w  - dNego_amt_w

   Select count(*) into :nRcnt   from expsum
	 where sabu = :sSabu and
	       sales_yymm = :NxtMonth and
			 cvcod = :sCvcod and
			 Curr = :sCurr;

   If nRcnt = 0 then
     INSERT INTO "EXPSUM"  
         ( "SABU",              "SALES_YYMM",              "CVCOD",              "CURR",   
           "MI_INV_AMT",      "MI_INV_AMT_U",       "MI_INV_AMT_W",   
           "MI_NEGO_AMT",    "MI_NEGO_AMT_U",      "MI_NEGO_AMT_W",   
           "ORD_AMT",            "ORD_AMT_U",          "ORD_AMT_W",   
           "INV_AMT",            "INV_AMT_U",          "INV_AMT_W",   
           "NEGO_AMT",          "NEGO_AMT_U",         "NEGO_AMT_W" )  
      VALUES ( :gs_sabu,          :NxtMonth,              :sCvcod,              :sCurr,   
               :dNxt_inv_amt,  :dNxt_inv_amt_u,       :dNxt_inv_amt_w,   
               :dNxt_nego_amt, :dNxt_nego_amt_u,     :dNxt_nego_amt_w,   
           0,              0,              0,   
           0,              0,              0,   
           0,              0,              0 )  ;
   ElseIf nRcnt > 0 then
     UPDATE "EXPSUM" 
	     SET "MI_INV_AMT"    = :dNxt_inv_amt,
		      "MI_INV_AMT_U"  = :dNxt_inv_amt_u,
				"MI_INV_AMT_W"  = :dNxt_inv_amt_w,
            "MI_NEGO_AMT"   = :dNxt_nego_amt,
			   "MI_NEGO_AMT_U" = :dNxt_nego_amt_u,
				"MI_NEGO_AMT_W" = :dNxt_nego_amt_w
		WHERE "SABU" = :gs_sabu and
		      "SALES_YYMM" = :NxtMonth and
				"CVCOD" = :sCvcod and
				"CURR" = :sCurr;
   End If
	
	If sqlca.sqlcode <> 0 Then
		rollback;
		f_message_chk(32,sqlca.sqlerrtext)
		destroy ds
		Return
	End If
Next
Destroy ds

COMMIT;

wf_init()

MessageBox('수출 월마감','마감처리 되었습니다.')
	
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\마감처리_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\마감처리_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_06030
boolean visible = false
integer x = 379
integer y = 2008
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sal_06030
integer x = 2464
integer y = 1300
integer width = 306
string picturename = "C:\erpman\image\닫기W_up.gif"
end type

event p_exit::ue_lbuttondown;PictureName = "C:\erpman\image\닫기W_dn.gif"
end event

event p_exit::ue_lbuttonup;PictureName = "C:\erpman\image\닫기W_up.gif"
end event

type p_can from w_inherite`p_can within w_sal_06030
integer x = 2098
integer y = 1300
integer width = 306
string picturename = "C:\erpman\image\마감취소_up.gif"
end type

event p_can::clicked;call super::clicked;string sDate
int    nRow,nCnt

If dw_insert.AcceptText() <>   1 Then return

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return
	  
sDate = Trim(dw_insert.GetItemString(nRow,'sdate'))
If IsNull(sdate) Or sdate = '' Then
   f_message_chk(1400,'[마감월]')
	Return 1
End If

/* 수금 마감처리된 월 확인 */
  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'X3' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :sDate )   ;

If nCnt = 0 Then
	f_message_chk(66,'')
	Return 
End If

IF MessageBox("취  소", "월마감이 취소 처리됩니다." +"~n~n" +&
                     	"취소 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN


DELETE FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'X3' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :sDate ) ;

Choose Case sqlca.sqlcode
	Case 0
		commit;
		MessageBox('수출매출 월마감 취소','마감취소 되었습니다.')
	Case Else
		rollback;
		f_message_chk(32,sqlca.sqlerrtext)
End Choose

ib_any_typing = False

wf_init()
end event

event p_can::ue_lbuttondown;PictureName = "C:\erpman\image\마감취소_dn.gif"
end event

event p_can::ue_lbuttonup;PictureName = "C:\erpman\image\마감취소_up.gif"
end event

type p_print from w_inherite`p_print within w_sal_06030
boolean visible = false
integer x = 32
integer y = 2008
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_06030
boolean visible = false
integer x = 206
integer y = 2008
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_sal_06030
boolean visible = false
integer x = 1074
integer y = 2008
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sal_06030
boolean visible = false
integer x = 901
integer y = 2008
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_sal_06030
boolean visible = false
integer x = 2386
integer y = 1884
integer width = 443
integer taborder = 40
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_06030
boolean visible = false
integer x = 878
integer y = 2416
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_06030
boolean visible = false
integer x = 517
integer y = 2416
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_sal_06030
boolean visible = false
integer x = 1239
integer y = 2416
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_06030
boolean visible = false
integer x = 1600
integer y = 2416
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_06030
boolean visible = false
integer x = 1961
integer y = 2416
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_06030
end type

type cb_can from w_inherite`cb_can within w_sal_06030
boolean visible = false
integer x = 1906
integer y = 1884
integer width = 443
integer taborder = 30
boolean enabled = false
string text = "마감취소(&C)"
end type

type cb_search from w_inherite`cb_search within w_sal_06030
boolean visible = false
integer x = 1426
integer y = 1884
integer width = 443
integer taborder = 20
boolean enabled = false
string text = "마감처리(&P)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06030
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06030
end type

type st_2 from statictext within w_sal_06030
integer x = 1394
integer y = 732
integer width = 1097
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "* 당월까지의 미선적금액과 미수금액을"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_06030
integer x = 2446
integer y = 832
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 33027312
boolean enabled = false
string text = "이월처리"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_06030
integer x = 2697
integer y = 832
integer width = 242
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "합니다."
boolean focusrectangle = false
end type

type st_5 from statictext within w_sal_06030
integer x = 1394
integer y = 832
integer width = 1033
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "  익월의 미선적금액과 미수금액으로"
boolean focusrectangle = false
end type

type st_7 from statictext within w_sal_06030
integer x = 1394
integer y = 952
integer width = 613
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "* 수출월마감 처리후"
boolean focusrectangle = false
end type

type st_8 from statictext within w_sal_06030
integer x = 1979
integer y = 948
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "매출확정 및 NEGO등록"
boolean focusrectangle = false
end type

type st_9 from statictext within w_sal_06030
integer x = 2592
integer y = 948
integer width = 242
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "을"
boolean focusrectangle = false
end type

type st_10 from statictext within w_sal_06030
integer x = 1463
integer y = 1028
integer width = 530
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "하실 수 없습니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sal_06030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 974
integer y = 252
integer width = 2551
integer height = 332
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_06030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 974
integer y = 600
integer width = 2551
integer height = 592
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_06030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 974
integer y = 1208
integer width = 2551
integer height = 332
integer cornerheight = 40
integer cornerwidth = 55
end type

