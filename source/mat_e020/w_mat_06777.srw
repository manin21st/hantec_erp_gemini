$PBExportHeader$w_mat_06777.srw
$PBExportComments$원자재 현재고현황(LOTNO기준)
forward
global type w_mat_06777 from w_standard_print
end type
type pb_1 from u_pb_cal within w_mat_06777
end type
type pb_2 from u_pb_cal within w_mat_06777
end type
type dw_print1 from datawindow within w_mat_06777
end type
type p_1 from picture within w_mat_06777
end type
type rr_1 from roundrectangle within w_mat_06777
end type
end forward

global type w_mat_06777 from w_standard_print
integer width = 4741
integer height = 3844
string title = "원자재 현재고 현황 (LOT NO 기준)"
pb_1 pb_1
pb_2 pb_2
dw_print1 dw_print1
p_1 p_1
rr_1 rr_1
end type
global w_mat_06777 w_mat_06777

type variables
datawindowchild dws
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom , sTo , ls_gbn, ls_itnbr1 ,ls_lotsno
String ls_jijil , ls_ispec1 , ls_ispec2, ls_ispec, ls_saupj, ls_depot, ls_iogbn

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom = Trim(dw_ip.GetItemString(1,'sdate'))
sTo = Trim(dw_ip.GetItemString(1,'edate'))
ls_itnbr1  = Trim(dw_ip.getitemstring(1,'itnbr1'))
ls_lotsno = Trim(dw_ip.GetItemString(1,"lotsno"))
ls_gbn = Trim(dw_ip.GetItemString(1,'gbn'))
ls_jijil = Trim(dw_ip.GetItemString(1,"jijil"))
ls_ispec1 = Trim(dw_ip.GetItemString(1,"ispec1"))
ls_ispec2 = Trim(dw_ip.GetItemString(1,"ispec2"))
ls_depot = Trim(dw_ip.GetItemString(1,"depot"))
ls_iogbn = Trim(dw_ip.GetItemString(1,"iogbn"))

IF ls_itnbr1   =  '' OR IsNull(ls_itnbr1) THEN ls_itnbr1 = '%'
IF ls_lotsno   =  '' OR IsNull(ls_lotsno) THEN ls_lotsno = '%'

IF ls_jijil   =  '' OR IsNull(ls_jijil) THEN ls_jijil = '%'

IF ls_ispec1   =  '' OR IsNull(ls_ispec1) THEN 
	ls_ispec1 = '%'
ELSE
	ls_ispec1 = ls_ispec1 + '×' 
END IF

IF ls_ispec2   =  '' OR IsNull(ls_ispec2) THEN 
	ls_ispec2 = '%'
ELSE
	ls_ispec2 = ls_ispec2 +'×C' 
END IF

ls_ispec = ls_ispec1 + ls_ispec2

IF ls_ispec   =  '%%'  THEN ls_ispec = '%'

IF ls_iogbn   =  '' OR IsNull(ls_iogbn) THEN ls_iogbn = '%'

/* Print Text*/

dw_print.object.sfrom.Text = left(sFrom,6)+'/'+right(sFrom,2)
dw_print.object.sto.Text = left(sTo,6)+'/'+right(sTo,2) 
dw_print.object.slotsno.Text = ls_lotsno
dw_print.object.sitnbr1.Text = ls_itnbr1

IF ls_itnbr1   =  '%' OR IsNull(ls_itnbr1) THEN dw_print.object.sitnbr1.Text  = '전체'
IF ls_lotsno   =  '%' OR IsNull(ls_lotsno) THEN dw_print.object.slotsno.Text  = '전체'

SELECT IPJOGUN
  INTO :ls_saupj
  FROM VNDMST
 WHERE CVGU = '5' AND SOGUAN = '3' AND CVCOD = :ls_depot ;

if dw_print.Retrieve(sFrom, sTo, ls_gbn,ls_itnbr1, ls_lotsno, ls_jijil, ls_ispec, ls_saupj, ls_iogbn) < 1 then	
	messagebox('','조회할 데이타가 없습니다' )
	dw_ip.setfocus()
	//return -1
end if
dw_print.sharedata(dw_list)


return 1
end function

on w_mat_06777.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_print1=create dw_print1
this.p_1=create p_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.dw_print1
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_mat_06777.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_print1)
destroy(this.p_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;
String sarea, steam, saupj

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1,'sdate',left(f_today(),6) + '01')
dw_ip.setitem(1,'edate',left(f_today(),8))


sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

////창고 
//f_child_saupj(dw_ip, 'depot', gs_saupj)
end event

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_print1.settransobject(sqlca)

dw_ip.getchild("iogbn", dws)
dws.settransobject(sqlca)
dws.retrieve(gs_sabu, '001')

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_xls from w_standard_print`p_xls within w_mat_06777
end type

type p_sort from w_standard_print`p_sort within w_mat_06777
end type

type p_preview from w_standard_print`p_preview within w_mat_06777
integer x = 3931
end type

type p_exit from w_standard_print`p_exit within w_mat_06777
integer x = 4279
end type

type p_print from w_standard_print`p_print within w_mat_06777
integer x = 4105
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_06777
integer x = 3584
integer y = 28
end type







type st_10 from w_standard_print`st_10 within w_mat_06777
end type



type dw_print from w_standard_print`dw_print within w_mat_06777
integer x = 3438
integer y = 216
boolean enabled = false
string dataobject = "d_mat_06777_p_new"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_06777
integer x = 14
integer y = 32
integer width = 3273
integer height = 324
string dataobject = "d_mat_06777_1"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, svndcod, scvname, ls_saupj,chk
String sarea, steam, sCvcod, scvnas, sSaupj, sName1, sItnbr1 , sItnbr2
int nRow

dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

//IF chk = '1' then
//messagebox('','1')
//END IF 

Choose Case sCol_Name
  
		Case "chk"
		dw_list.reset()
		dw_print.reset()
		
end Choose



end event

event dw_ip::rbuttondown;call super::rbuttondown;string sPino
long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case "itnbr1"
		nRow = dw_ip.RowCount()		
		gs_gubun = '1'
		        gs_codename = GetText()
        open(w_itemas_popup)
        IF gs_code = "" OR IsNull(gs_code) THEN RETURN
        
        SetColumn("itnbr1")
        SetItem(nRow,"itnbr1",gs_code)

		TriggerEvent(ItemChanged!)
END Choose
end event

type dw_list from w_standard_print`dw_list within w_mat_06777
integer y = 392
integer width = 4576
integer height = 1936
string dataobject = "d_mat_06777"
boolean border = false
end type

type pb_1 from u_pb_cal within w_mat_06777
boolean visible = false
integer x = 1554
integer y = 64
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_mat_06777
boolean visible = false
integer x = 2057
integer y = 64
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)

end event

type dw_print1 from datawindow within w_mat_06777
boolean visible = false
integer x = 2674
integer y = 88
integer width = 347
integer height = 124
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_06230_p2"
boolean livescroll = true
end type

type p_1 from picture within w_mat_06777
integer x = 3758
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_d.gif"
boolean focusrectangle = false
end type

event clicked;Long ll_row, ll_cnt, Lx, ll_int
String ls_chk, ls_name1, ls_name2, ls_dw_syntax, sData, is_ExcelExe

dw_print.SaveAs()
is_ExcelExe = 'excel.exe'

//If dw_print.Rowcount() <= 0 Then Return	
//gf_save_html(dw_print)


//If this.Enabled Then wf_excel_down(dw_print)
end event

type rr_1 from roundrectangle within w_mat_06777
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 376
integer width = 4608
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

