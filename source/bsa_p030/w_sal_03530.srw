$PBExportHeader$w_sal_03530.srw
$PBExportComments$장기 미출고 현황
forward
global type w_sal_03530 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_03530
end type
type rr_1 from roundrectangle within w_sal_03530
end type
end forward

global type w_sal_03530 from w_standard_print
string title = "장기 미출고 현황"
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_03530 w_sal_03530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_pdtgu, s_depot, tx_name
string s_get_pdtgu, s_get_depot, sIttyp
string s_procdate,s_last_in_date, sPrtgbn
long   l_ilsu

If dw_ip.accepttext() <> 1 Then Return -1

s_procdate = dw_ip.getitemstring(1,"procdate")
sIttyp = dw_ip.getitemstring(1,"ittyp")
s_pdtgu = dw_ip.getitemstring(1,"pdtgu")
s_depot = dw_ip.getitemstring(1,"depot")
sPrtGbn = dw_ip.getitemstring(1,"prtgbn")
l_ilsu = dw_ip.getitemNumber(1,"ilsu")

If IsNull(s_procdate) Or s_procdate = '' Then
   f_message_chk(1400,'[기준일자]')
	dw_ip.setcolumn('procdate')
	dw_ip.setfocus()
	Return -1
End If

If IsNull(s_depot) Or s_depot = '' Then
   f_message_chk(1400,'[창고]')
	dw_ip.setcolumn('depot')
	dw_ip.setfocus()
	Return -1
End If

If IsNull(sIttyp) Or sIttyp = '' Then
   f_message_chk(1400,'[품목구분]')
	dw_ip.setcolumn('ittyp')
	dw_ip.setfocus()
	Return -1
End If

////조건(생산팀)에서 값이 없을때 전체를 출력할 경우//////////////////
if isnull(s_pdtgu) or s_pdtgu = "" then 
	s_get_pdtgu = '전체'
	dw_list.setfilter("")
else
   s_get_pdtgu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
	dw_list.setfilter("itnct_pdtgu = '"+ s_pdtgu +" '")
end if
dw_list.filter()

//// <조회> ///////////////////////////////////////////////////////////////////////////////////////////
//s_last_in_date = String(RelativeDate(Date(left(s_procdate,4)+'/'+Mid(s_procdate,5,2)+'/'+Right(s_procdate,2)),l_ilsu * -1 ),'yyyymmdd')
//IF dw_list.retrieve(s_procdate, sIttyp, s_depot,s_last_in_date,l_ilsu, sPrtGbn) <= 0 THEN
//   f_message_chk(50,'[악성재고현황]')
//	dw_ip.setfocus()
////	cb_print.Enabled =False
//	SetPointer(Arrow!)
//	Return -1
//ELSE
//	dw_print.Object.tx_pdtgu.Text = s_get_pdtgu
//	dw_print.Object.tx_depot.Text = s_get_depot
//END IF
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("txt_ittyp.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(depot) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_depot.text = '"+tx_name+"'")
//
//
//dw_list.scrolltorow(1)
//SetPointer(Arrow!)

s_last_in_date = String(RelativeDate(Date(left(s_procdate,4)+'/'+Mid(s_procdate,5,2)+'/'+Right(s_procdate,2)),l_ilsu * -1 ),'yyyymmdd')
IF dw_print.retrieve(s_procdate, sIttyp, s_depot,s_last_in_date,l_ilsu, sPrtGbn) <= 0 THEN
   f_message_chk(50,'[악성재고현황]')
	dw_ip.setfocus()
//	cb_print.Enabled =False
	SetPointer(Arrow!)
	Return -1
ELSE
	dw_print.ShareData(dw_list)
	dw_print.Object.tx_pdtgu.Text = s_get_pdtgu
	dw_print.Object.tx_depot.Text = s_get_depot
END IF

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_ittyp.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(depot) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_depot.text = '"+tx_name+"'")

dw_list.scrolltorow(1)
SetPointer(Arrow!)

Return 0
end function

on w_sal_03530.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_03530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;string sDate,sDepotNo


/* 창고(영업,완제품) Defalut */
SELECT "VNDMST"."CVCOD" INTO :sDepotNo
  FROM "VNDMST"  
 WHERE ( "VNDMST"."CVGU" = '5' ) AND  
       ( "VNDMST"."JUPROD" = '1' ) AND  
       ( "VNDMST"."SOGUAN" = '1' ) AND
	  ( "VNDMST"."JUHANDLE" = '1' ) AND
	  ( "VNDMST"."IPJOGUN" = :gs_saupj ) ;

sDate = f_today()
dw_ip.setitem(1,"procdate",sDate)
dw_ip.setfocus()
dw_ip.SetItem(1,'depot',sDepotNo)
end event

type p_preview from w_standard_print`p_preview within w_sal_03530
integer x = 4069
end type

type p_exit from w_standard_print`p_exit within w_sal_03530
integer x = 4416
end type

type p_print from w_standard_print`p_print within w_sal_03530
integer x = 4242
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_03530
integer x = 3895
end type







type st_10 from w_standard_print`st_10 within w_sal_03530
end type



type dw_print from w_standard_print`dw_print within w_sal_03530
integer x = 3703
string dataobject = "d_sal_03530_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_03530
integer x = 46
integer y = 24
integer width = 3090
integer height = 212
string dataobject = "d_sal_03530_01"
end type

event dw_ip::itemchanged;string s_chang, s_chname, s_chname2,sDate
int  ireturn

Choose Case GetColumnName() 
	Case 'procdate'
		sdate = Left(data,4) + Mid(data,5,2) + Right(data,2)
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	setcolumn('procdate')
	      Return 1
      END IF
END Choose

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_03530
integer x = 59
integer y = 268
integer width = 4512
integer height = 2044
string dataobject = "d_sal_03530_02"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type pb_1 from u_pb_cal within w_sal_03530
integer x = 709
integer y = 48
integer width = 91
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('procdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'procdate', gs_code)

end event

type rr_1 from roundrectangle within w_sal_03530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 260
integer width = 4535
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

